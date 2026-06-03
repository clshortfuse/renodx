/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cassert>
#include <cstdint>
#include <functional>
#include <string>
#include <type_traits>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include <gtl/phmap.hpp>
#include <include/reshade.hpp>

#include "./data.hpp"
#include "./platform.hpp"

namespace renodx::utils::cross_addon {

template <typename T>
using vector = std::vector<T, platform::ProcessAllocator<T>>;

using string = std::basic_string<char, std::char_traits<char>, platform::ProcessAllocator<char>>;

template <typename Key, typename Value, typename Hash = gtl::Hash<Key>, typename Equal = gtl::EqualTo<Key>>
using unordered_map = std::unordered_map<
    Key,
    Value,
    Hash,
    Equal,
    platform::ProcessAllocator<std::pair<const Key, Value>>>;

template <typename Key, typename Hash = gtl::Hash<Key>, typename Equal = gtl::EqualTo<Key>>
using unordered_set = std::unordered_set<
    Key,
    Hash,
    Equal,
    platform::ProcessAllocator<Key>>;

template <typename Key, typename Value, typename Mutex = gtl::NullMutex>
using parallel_node_hash_map = gtl::parallel_node_hash_map<
    Key,
    Value,
    gtl::Hash<Key>,
    gtl::EqualTo<Key>,
    platform::ProcessAllocator<std::pair<const Key, Value>>,
    data::THREAD_COUNT,
    Mutex>;

template <typename Key, typename Value, typename Mutex = gtl::NullMutex>
using parallel_flat_hash_map = gtl::parallel_flat_hash_map<
    Key,
    Value,
    gtl::Hash<Key>,
    gtl::EqualTo<Key>,
    platform::ProcessAllocator<std::pair<const Key, Value>>,
    data::THREAD_COUNT,
    Mutex>;

namespace internal {

template <typename T>
inline constexpr bool ALWAYS_FALSE = false;

using ModuleToken = const void*;

inline ModuleToken GetModuleToken() {
  static const uint8_t TOKEN = 0u;
  return &TOKEN;
}

using RegisterReshadeEvent = void (*)(void* callback);
using UnregisterReshadeEvent = void (*)(void* callback);

template <reshade::addon_event ev>
inline void RegisterReshadeEventCallback(void* callback) {
  reshade::register_event<ev>(reinterpret_cast<typename reshade::addon_event_traits<ev>::decl>(callback));
}

template <reshade::addon_event ev>
inline void UnregisterReshadeEventCallback(void* callback) {
  reshade::unregister_event<ev>(reinterpret_cast<typename reshade::addon_event_traits<ev>::decl>(callback));
}

struct EventRecord {
  reshade::addon_event event = static_cast<reshade::addon_event>(0u);
  void* callback = nullptr;
  RegisterReshadeEvent register_reshade = nullptr;
  UnregisterReshadeEvent unregister_reshade = nullptr;
  EventRecord* next = nullptr;
  bool active = false;
  bool reshade_registered = false;
};

struct ModuleRecord {
  ModuleToken token = nullptr;
  EventRecord* events = nullptr;
  ModuleRecord* next = nullptr;
  uint64_t sequence = 0u;
  uint32_t registration_count = 0u;
  bool active = false;
};

template <typename Data>
struct ControlBlock {
  Data* data = nullptr;
  ModuleRecord* modules = nullptr;
  ModuleRecord* event_handler = nullptr;
  uint64_t next_sequence = 1u;
};

inline bool IsBetterHandler(const ModuleRecord& candidate, const ModuleRecord* current) {
  if (current == nullptr) return true;
  return candidate.sequence < current->sequence;
}

template <typename Data>
inline void SyncReshadeEvents(ControlBlock<Data>& control) {
  auto* module = control.event_handler;
  if (module == nullptr || !module->active) return;

  for (auto* event = module->events; event != nullptr; event = event->next) {
    bool wanted = false;
    for (auto* other_module = control.modules; other_module != nullptr && !wanted; other_module = other_module->next) {
      if (!other_module->active) continue;
      for (auto* other_event = other_module->events; other_event != nullptr; other_event = other_event->next) {
        if (other_event->event == event->event && other_event->active) {
          wanted = true;
          break;
        }
      }
    }
    if (wanted && !event->reshade_registered && event->register_reshade != nullptr) {
      event->register_reshade(event->callback);
      event->reshade_registered = true;
    } else if (!wanted && event->reshade_registered && event->unregister_reshade != nullptr) {
      event->unregister_reshade(event->callback);
      event->reshade_registered = false;
    }
  }
}

inline void UnregisterReshadeEvents(ModuleRecord* module) {
  if (module == nullptr) return;

  for (auto* event = module->events; event != nullptr; event = event->next) {
    if (!event->reshade_registered || event->unregister_reshade == nullptr) continue;
    event->unregister_reshade(event->callback);
    event->reshade_registered = false;
  }
}

inline void DeactivateEvents(ModuleRecord& module) {
  for (auto* event = module.events; event != nullptr; event = event->next) {
    event->active = false;
  }
}

template <typename Data>
inline ModuleRecord* ElectHandler(ControlBlock<Data>& control) {
  ModuleRecord* handler = nullptr;

  for (auto* module = control.modules; module != nullptr; module = module->next) {
    if (!module->active) continue;
    if (IsBetterHandler(*module, handler)) {
      handler = module;
    }
  }

  if (handler == control.event_handler) return handler;

  UnregisterReshadeEvents(control.event_handler);
  control.event_handler = handler;
  SyncReshadeEvents(control);
  return handler;
}

template <typename Data>
inline ModuleRecord* FindModule(ControlBlock<Data>& control, ModuleToken token) {
  for (auto* module = control.modules; module != nullptr; module = module->next) {
    if (module->token == token) return module;
  }

  return nullptr;
}

template <typename Data>
inline ModuleRecord* CreateModule(ControlBlock<Data>& control, ModuleToken token) {
  auto* module = data::CreateSharedObject<ModuleRecord>();
  if (module == nullptr) return nullptr;

  module->token = token;
  module->sequence = control.next_sequence++;
  module->next = control.modules;
  control.modules = module;
  return module;
}

inline EventRecord* FindEvent(ModuleRecord& module, reshade::addon_event event, void* callback) {
  for (auto* record = module.events; record != nullptr; record = record->next) {
    if (record->event == event && record->callback == callback) return record;
  }

  return nullptr;
}

inline EventRecord* CreateEvent(ModuleRecord& module, reshade::addon_event event, void* callback) {
  auto* record = data::CreateSharedObject<EventRecord>();
  if (record == nullptr) return nullptr;

  record->event = event;
  record->callback = callback;
  record->next = module.events;
  module.events = record;
  return record;
}

template <typename Data>
inline void InvokeModuleCallback(auto&& callback, Data& data) {
  using Callback = decltype(callback);
  if constexpr (std::is_invocable_v<Callback, Data&>) {
    std::invoke(std::forward<Callback>(callback), data);
  } else if constexpr (std::is_invocable_v<Callback>) {
    std::invoke(std::forward<Callback>(callback));
  } else {
    static_assert(ALWAYS_FALSE<Callback>, "Unsupported cross_addon module callback signature.");
  }
}

}  // namespace internal

template <typename Data>
class Shared {
 public:
  Data* data = nullptr;

  [[nodiscard]] bool IsEventHandler() const {
    auto* current_control = control;
    auto* current_module = module;
    if (current_control == nullptr || current_module == nullptr) return false;

    return current_module->active && current_control->event_handler == current_module;
  }

  bool RegisterModule() {
    return RegisterModule([]() {});
  }

  template <typename F>
  bool RegisterModule(F&& configure_after_add) {
    auto* control = EnsureControl();
    if (control == nullptr || control->data == nullptr) return false;

    auto* module = this->module;
    const auto* const token = internal::GetModuleToken();
    if (module == nullptr || module->token != token) {
      module = internal::FindModule(*control, token);
      if (module == nullptr) {
        module = internal::CreateModule(*control, token);
      }
      this->module = module;
    }

    if (module == nullptr) return false;

    const bool was_active = module->active;
    if (!was_active) {
      module->active = true;
      ++module->registration_count;
      internal::ElectHandler(*control);
    }

    internal::InvokeModuleCallback(std::forward<F>(configure_after_add), *control->data);
    internal::SyncReshadeEvents(*control);
    return !was_active;
  }

  bool UnregisterModule() {
    return UnregisterModule([]() {});
  }

  template <typename F>
  bool UnregisterModule(F&& reconfigure_after_remove) {
    auto* control = this->control;
    auto* module = this->module;
    if (control == nullptr || module == nullptr || control->data == nullptr) return false;

    if (module->registration_count > 0u) {
      --module->registration_count;
    }

    if (module->registration_count == 0u) {
      internal::UnregisterReshadeEvents(module);
      internal::DeactivateEvents(*module);
      module->active = false;
      internal::InvokeModuleCallback(std::forward<F>(reconfigure_after_remove), *control->data);
      internal::ElectHandler(*control);
      internal::SyncReshadeEvents(*control);
      this->module = nullptr;
      return true;
    }

    return false;
  }

  template <reshade::addon_event ev>
  void RegisterEvent(typename reshade::addon_event_traits<ev>::decl callback, bool active = true) {
    RegisterModule();

    auto* control = this->control;
    auto* module = this->module;
    assert(control != nullptr && module != nullptr && module->active);
    if (control == nullptr || module == nullptr || !module->active) return;

    auto* event = internal::FindEvent(*module, ev, reinterpret_cast<void*>(callback));
    if (event == nullptr) {
      event = internal::CreateEvent(*module, ev, reinterpret_cast<void*>(callback));
    }
    if (event == nullptr) return;

    event->register_reshade = internal::RegisterReshadeEventCallback<ev>;
    event->unregister_reshade = internal::UnregisterReshadeEventCallback<ev>;
    event->active = active;

    internal::SyncReshadeEvents(*control);
  }

  template <reshade::addon_event ev>
  void UnregisterEvent(typename reshade::addon_event_traits<ev>::decl callback) {
    auto* control = this->control;
    auto* module = this->module;
    if (control == nullptr || module == nullptr) return;

    auto* event = internal::FindEvent(*module, ev, reinterpret_cast<void*>(callback));
    if (event == nullptr) return;

    if (event->reshade_registered) {
      event->unregister_reshade(event->callback);
      event->reshade_registered = false;
    }
    event->active = false;
    internal::SyncReshadeEvents(*control);
  }

 private:
  internal::ControlBlock<Data>* EnsureControl() {
    if (control != nullptr) return control;

    auto slot = platform::OpenProcessSharedSlot<internal::ControlBlock<Data>>(
        __uuidof(Data),
        [](internal::ControlBlock<Data>*& control) {
          if (control != nullptr) return;

          control = data::CreateSharedObject<internal::ControlBlock<Data>>();
          if (control != nullptr) {
            control->data = data::CreateSharedObject<Data>();
          }
        });

    if (slot.value != nullptr) {
      control = *slot.value;
      data = control != nullptr ? control->data : nullptr;
      process_slot = slot;
    }

    return control;
  }

  internal::ControlBlock<Data>* control = nullptr;
  platform::ProcessSharedSlot<internal::ControlBlock<Data>> process_slot = {};
  internal::ModuleRecord* module = nullptr;
};

}  // namespace renodx::utils::cross_addon