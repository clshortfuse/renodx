/*
 * Copyright (C) 2026 Musa Haji
 * Copyright (C) 2026 Hartapfel
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <array>
#include <vector>

#include <sl_core_api.h>
#include "../../utils/log.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/vtable.hpp"

namespace firstlight::dlss {

inline float dlssg_hud_ghosting_fix = 1.f;
inline bool attached = false;
inline bool settings_appended = false;
inline bool hook_installed = false;
inline bool logged_waiting_for_streamline = false;
inline bool logged_ui_tag_suppression = false;

inline sl::Result (*real_sl_set_tag)(
    const sl::ViewportHandle& viewport,
    const sl::ResourceTag* tags,
    uint32_t num_tags,
    sl::CommandBuffer* cmd_buffer) = nullptr;

inline decltype(&slSetTagForFrame) real_sl_set_tag_for_frame = nullptr;

inline void AppendSettings(renodx::utils::settings::Settings& settings) {
  if (settings_appended) return;
  settings_appended = true;

  settings.insert(
      std::find_if(settings.begin(), settings.end(), [](const renodx::utils::settings::Setting* setting) {
        return setting != nullptr && setting->section == "Options";
      }),
      {
          new renodx::utils::settings::Setting{
              .key = "DLSSGHUDGhostingFix",
              .binding = &dlssg_hud_ghosting_fix,
              .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
              .default_value = 1.f,
              .label = "DLSS FG HUD Ghosting Fix",
              .section = "DLSS Frame Generation",
              .tooltip = "Hides the game's broken UI alpha and HUD-less color inputs from DLSS Frame Generation to reduce HUD ghosting and disocclusion artifacts.",
              .labels = {"Off", "On"},
          },
      });
}

inline void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("DLSSGHUDGhostingFix", 0.f);
}

struct FilteredResourceTags {
  const sl::ResourceTag* tags = nullptr;
  uint32_t count = 0u;
  uint32_t suppressed_count = 0u;
};

inline bool IsHUDGhostingFixEnabled() {
  return dlssg_hud_ghosting_fix != 0.f;
}

inline bool IsSuppressedResourceTag(sl::BufferType type) {
  switch (type) {
    case sl::kBufferTypeUIColorAndAlpha:
    case sl::kBufferTypeHUDLessColor:
      return true;
    default:
      return false;
  }
}

inline FilteredResourceTags FilterResourceTags(
    const sl::ResourceTag* tags,
    uint32_t num_tags,
    std::vector<sl::ResourceTag>& filtered_tags) {
  FilteredResourceTags result = {tags, num_tags, 0u};
  if (!IsHUDGhostingFixEnabled() || tags == nullptr || num_tags == 0u) return result;

  bool found_suppressed_tag = false;
  for (uint32_t i = 0u; i < num_tags; ++i) {
    if (IsSuppressedResourceTag(tags[i].type)) {
      ++result.suppressed_count;
      if (!found_suppressed_tag) {
        found_suppressed_tag = true;
        filtered_tags.reserve(num_tags - 1u);
        filtered_tags.insert(filtered_tags.end(), tags, tags + i);
      }
      continue;
    }

    if (found_suppressed_tag) filtered_tags.push_back(tags[i]);
  }

  if (found_suppressed_tag) {
    result.tags = filtered_tags.empty() ? nullptr : filtered_tags.data();
    result.count = static_cast<uint32_t>(filtered_tags.size());
  }

  return result;
}

inline void LogSuppressedUITag(uint32_t suppressed_count) {
  if (logged_ui_tag_suppression || suppressed_count == 0u) return;
  logged_ui_tag_suppression = true;

  renodx::utils::log::i(
      "007 DLSSG: suppressing ",
      suppressed_count,
      " UI/HUD Streamline tag(s) to avoid FG HUD ghosting.");
}

template <typename SetTags>
inline sl::Result SetFilteredTags(
    const sl::ResourceTag* tags,
    uint32_t num_tags,
    const SetTags& set_tags) {
  std::vector<sl::ResourceTag> filtered_tags;
  const auto filtered = FilterResourceTags(tags, num_tags, filtered_tags);
  if (filtered.suppressed_count == 0u) {
    return set_tags(tags, num_tags);
  }

  LogSuppressedUITag(filtered.suppressed_count);
  if (filtered.count == 0u) return sl::Result::eOk;

  return set_tags(filtered.tags, filtered.count);
}

inline sl::Result HookedSlSetTag(
    const sl::ViewportHandle& viewport,
    const sl::ResourceTag* tags,
    uint32_t num_tags,
    sl::CommandBuffer* cmd_buffer) {
  return SetFilteredTags(tags, num_tags, [&](const sl::ResourceTag* output_tags, uint32_t output_count) {
    return real_sl_set_tag(viewport, output_tags, output_count, cmd_buffer);
  });
}

inline sl::Result HookedSlSetTagForFrame(
    const sl::FrameToken& frame,
    const sl::ViewportHandle& viewport,
    const sl::ResourceTag* tags,
    uint32_t num_tags,
    sl::CommandBuffer* cmd_buffer) {
  return SetFilteredTags(tags, num_tags, [&](const sl::ResourceTag* output_tags, uint32_t output_count) {
    return real_sl_set_tag_for_frame(frame, viewport, output_tags, output_count, cmd_buffer);
  });
}

inline const auto& StreamlineDLSSGOptionsHooks() {
  static const std::array<renodx::utils::vtable::HookItem, 2> HOOKS = {
      renodx::utils::vtable::HookItem{
          "slSetTag",
          reinterpret_cast<void**>(&real_sl_set_tag),
          reinterpret_cast<void*>(&HookedSlSetTag),
      },
      renodx::utils::vtable::HookItem{
          "slSetTagForFrame",
          reinterpret_cast<void**>(&real_sl_set_tag_for_frame),
          reinterpret_cast<void*>(&HookedSlSetTagForFrame),
      },
  };
  return HOOKS;
}

inline void TryInstallStreamlineHook() {
  if (hook_installed) return;

  auto* sl_interposer = GetModuleHandleA("sl.interposer.dll");
  if (sl_interposer == nullptr) {
    if (!logged_waiting_for_streamline) {
      logged_waiting_for_streamline = true;
      renodx::utils::log::w("007 DLSSG: sl.interposer.dll is not loaded yet; UI alpha fix hook will retry later.");
    }
    return;
  }

  if (renodx::utils::vtable::Hook(sl_interposer, StreamlineDLSSGOptionsHooks())) {
    hook_installed = true;
    renodx::utils::log::i("007 DLSSG: Streamline UI/HUD tag suppression hook installed.");
  } else {
    renodx::utils::log::w("007 DLSSG: Streamline hook was not installed.");
  }
}

inline void OnInitDevice(reshade::api::device* device) {
  if (device == nullptr || device->get_api() != reshade::api::device_api::d3d12) return;
  TryInstallStreamlineHook();
}

inline void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      break;
    case DLL_PROCESS_DETACH:
      if (!attached) return;
      attached = false;
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      hook_installed = false;
      logged_waiting_for_streamline = false;
      logged_ui_tag_suppression = false;
      break;
    default:
      break;
  }
}

}  // namespace firstlight::dlss
