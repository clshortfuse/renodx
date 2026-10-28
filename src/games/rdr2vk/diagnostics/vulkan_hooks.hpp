/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "../diagnostics_config.hpp"

#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS

#include <windows.h>

#include <array>
#include <bit>
#include <cstddef>
#include <cstdint>
#include <mutex>
#include <shared_mutex>
#include <span>
#include <utility>

#include <include/reshade.hpp>

#include "../../../utils/detour.hpp"
#include "../../../utils/log.hpp"
#include "../vulkan_types.hpp"
#include "./recorder.hpp"

namespace rdr2vk::diagnostics::vulkan_hooks {
namespace internal {

using vulkan::PFN_vkCreateBufferView;
using vulkan::PFN_vkDestroyBufferView;
using vulkan::PFN_vkDestroyImageView;
using vulkan::PFN_vkGetDeviceProcAddr;
using vulkan::PFN_vkGetFenceStatus;
using vulkan::PFN_vkResetFences;
using vulkan::PFN_vkUpdateDescriptorSets;
using vulkan::PFN_vkWaitForFences;
using vulkan::VkBufferViewCreateInfo;
using vulkan::VkDevice;
using vulkan::VkFence;
using vulkan::VkResult;
using vulkan::VkWriteDescriptorSet;

struct HookState {
  std::shared_mutex mutex;
  PFN_vkDestroyImageView destroy_image_view = nullptr;
  PFN_vkCreateBufferView create_buffer_view = nullptr;
  PFN_vkDestroyBufferView destroy_buffer_view = nullptr;
  PFN_vkUpdateDescriptorSets update_descriptor_sets = nullptr;
  PFN_vkGetFenceStatus get_fence_status = nullptr;
  PFN_vkWaitForFences wait_for_fences = nullptr;
  PFN_vkResetFences reset_fences = nullptr;
  std::array<renodx::utils::detour::Function, 7> functions = {};
  std::size_t function_count = 0;
  bool installed = false;
  bool registered = false;
};

static HookState hooks;

// Originals are published/rewritten by the Detours transaction, not by recorder
// callbacks. Installation/removal follows the baseline serialized lifecycle.
// A mutex on each call would not make hot unloading safe and is not added here.
static void WINAPI DestroyImageView(VkDevice device, std::uint64_t view, const void* allocator) {
  if (!IsActive()) {
    hooks.destroy_image_view(device, view, allocator);
    return;
  }
  ViewDestroyScope observation({.kind = ViewKind::IMAGE, .device = reinterpret_cast<std::uint64_t>(device), .view = view});
  hooks.destroy_image_view(device, view, allocator);
  observation.Returned();
}

static VkResult WINAPI CreateBufferView(VkDevice device, const VkBufferViewCreateInfo* info,
                                        const void* allocator, std::uint64_t* view) {
  if (!IsActive()) return hooks.create_buffer_view(device, info, allocator, view);
  VkBufferViewCreateInfo description = {};
  SIZE_T description_bytes = 0;
  if (info != nullptr) {
    ReadProcessMemory(GetCurrentProcess(), info, &description, sizeof(description), &description_bytes);
  }
  // Partial input bytes do not establish any valid description fields.
  if (description_bytes != sizeof(description)) {
    description = {};
  }
  std::uint64_t previous_output = 0;
  SIZE_T previous_bytes = 0;
  if (view != nullptr) {
    ReadProcessMemory(GetCurrentProcess(), view, &previous_output, sizeof(previous_output), &previous_bytes);
  }
  BufferCreationScope observation({
      .device = reinterpret_cast<std::uint64_t>(device),
      .buffer = description.buffer,
      .format = description.format,
      .offset = description.offset,
      .range = description.range,
      .output_slot = reinterpret_cast<std::uint64_t>(view),
      .previous_output = previous_output,
      .previous_bytes = previous_bytes,
      .info_readable = description_bytes == sizeof(description),
  });
  const auto result = hooks.create_buffer_view(device, info, allocator, view);
  std::uint64_t output = 0;
  SIZE_T output_bytes = 0;
  if (view != nullptr) {
    ReadProcessMemory(GetCurrentProcess(), view, &output, sizeof(output), &output_bytes);
  }
  observation.Returned({.result = result, .output = output, .output_bytes = output_bytes});
  return result;
}

static void WINAPI DestroyBufferView(VkDevice device, std::uint64_t view, const void* allocator) {
  if (!IsActive()) {
    hooks.destroy_buffer_view(device, view, allocator);
    return;
  }
  ViewDestroyScope observation({.kind = ViewKind::BUFFER, .device = reinterpret_cast<std::uint64_t>(device), .view = view});
  // Even an observed duplicate is forwarded. No history-dependent suppression.
  hooks.destroy_buffer_view(device, view, allocator);
  observation.Returned();
}

static void WINAPI UpdateDescriptorSets(VkDevice device, std::uint32_t count, const VkWriteDescriptorSet* writes,
                                        std::uint32_t copy_count, const void* copies) {
  if (!IsActive()) {
    hooks.update_descriptor_sets(device, count, writes, copy_count, copies);
    return;
  }
  DescriptorBatchObservation batch = {
      .device = reinterpret_cast<std::uint64_t>(device),
      .writes_address = reinterpret_cast<std::uint64_t>(writes),
      .writes = count,
      .copies = copy_count,
  };
  DescriptorUpdateScope observation(&batch);
  // Capture first so reports can show the entire bounded batch. The second
  // pass checks ALL original references, including those beyond entry 128.
  const auto visit_inputs = [&](bool capture) {
    if (writes == nullptr) {
      if (count != 0) {
        ++batch.unreadable;
      }
      return;
    }
    for (std::uint32_t index = 0; index < count; ++index) {
      VkWriteDescriptorSet write = {};
      SIZE_T copied = 0;
      // ReadProcessMemory avoids introducing a new access violation before the
      // original call when an application input is unreadable. No input is fixed.
      const auto address = reinterpret_cast<std::uintptr_t>(writes) + (static_cast<std::uint64_t>(index) * sizeof(write));
      if (!ReadProcessMemory(GetCurrentProcess(), reinterpret_cast<const void*>(address), &write, sizeof(write), &copied)
          || copied != sizeof(write)) {
        ++batch.unreadable;
        continue;
      }
      // Vulkan types 4/5 are uniform/storage texel-buffer views. Other descriptor
      // payloads and copy arrays are forwarded, not decoded or dereferenced.
      if (write.descriptor_type != 4 && write.descriptor_type != 5) continue;
      if (capture) {
        batch.references += write.count;
      }
      if (write.views == nullptr) {
        if (write.count != 0 && (!capture || batch.captured < batch.inputs.size())) {
          ++batch.unreadable;
        }
        continue;
      }
      // Unreadable entries do not consume a snapshot slot. Keep looking until
      // it holds 128 readable inputs; the checking pass still visits every input.
      for (std::size_t element = 0; element < write.count; ++element) {
        if (capture && batch.captured == batch.inputs.size()) break;
        std::uint64_t view = 0;
        const auto input_address = reinterpret_cast<std::uintptr_t>(write.views) + (element * sizeof(view));
        if (!ReadProcessMemory(GetCurrentProcess(), reinterpret_cast<const void*>(input_address), &view, sizeof(view), &copied)
            || copied != sizeof(view)) {
          ++batch.unreadable;
          continue;
        }
        const DescriptorInput input = {
            .view = view,
            .descriptor_set = write.set,
            .input_address = input_address,
            .binding = write.binding,
            .element = write.element + static_cast<std::uint32_t>(element),
            .type = write.descriptor_type,
        };
        if (capture) {
          batch.inputs[batch.captured++] = input;
        } else {
          observation.Record(input);
        }
      }
    }
  };
  visit_inputs(true);
  batch.phase = 1;
  visit_inputs(false);
  batch.phase = 2;
  hooks.update_descriptor_sets(device, count, writes, copy_count, copies);
  observation.Returned();
}

static VkResult WINAPI GetFenceStatus(VkDevice device, VkFence fence) {
  const auto result = hooks.get_fence_status(device, fence);
  if (IsActive()) {
    RecordSync({
        .kind = "fence_status",
        .device = reinterpret_cast<std::uint64_t>(device),
        .object = reinterpret_cast<std::uint64_t>(fence),
        .result = result,
    });
  }
  return result;
}

static VkResult WINAPI WaitForFences(VkDevice device, std::uint32_t count, const std::uint64_t* fences,
                                     std::uint32_t wait_all, std::uint64_t timeout) {
  if (!IsActive()) return hooks.wait_for_fences(device, count, fences, wait_all, timeout);
  const auto request = NextRequest();
  RecordSync({
      .kind = "wait_enter",
      .device = reinterpret_cast<std::uint64_t>(device),
      .object = wait_all,
      .request = request,
      .count = count,
      .handles = fences,
  });
  const auto result = hooks.wait_for_fences(device, count, fences, wait_all, timeout);
  RecordSync({
      .kind = "wait_return",
      .device = reinterpret_cast<std::uint64_t>(device),
      .object = wait_all,
      .request = request,
      .result = result,
      .count = count,
      .handles = fences,
  });
  return result;
}

static VkResult WINAPI ResetFences(VkDevice device, std::uint32_t count, const std::uint64_t* fences) {
  if (!IsActive()) return hooks.reset_fences(device, count, fences);
  const auto request = NextRequest();
  RecordSync({
      .kind = "reset_enter",
      .device = reinterpret_cast<std::uint64_t>(device),
      .request = request,
      .count = count,
      .handles = fences,
  });
  const auto result = hooks.reset_fences(device, count, fences);
  RecordSync({
      .kind = "reset_return",
      .device = reinterpret_cast<std::uint64_t>(device),
      .request = request,
      .result = result,
      .count = count,
      .handles = fences,
  });
  return result;
}

static void OnInitDevice(reshade::api::device* device) {
  if (!IsActive() || device->get_api() != reshade::api::device_api::vulkan) return;
  try {
    const std::unique_lock lock(hooks.mutex);
    if (hooks.installed || !hooks.registered) return;
    const auto get = reinterpret_cast<PFN_vkGetDeviceProcAddr>(
        GetProcAddress(reshade::internal::get_reshade_module_handle(), "vkGetDeviceProcAddr"));
    if (get == nullptr) {
      renodx::utils::log::w("rdr2vk: optional Vulkan lookup is unavailable; rendering hooks are unchanged.");
      return;
    }
    auto* const native = std::bit_cast<VkDevice>(device->get_native());
    hooks.destroy_image_view = reinterpret_cast<PFN_vkDestroyImageView>(get(native, "vkDestroyImageView"));
    hooks.create_buffer_view = reinterpret_cast<PFN_vkCreateBufferView>(get(native, "vkCreateBufferView"));
    hooks.destroy_buffer_view = reinterpret_cast<PFN_vkDestroyBufferView>(get(native, "vkDestroyBufferView"));
    hooks.update_descriptor_sets = reinterpret_cast<PFN_vkUpdateDescriptorSets>(get(native, "vkUpdateDescriptorSets"));
    hooks.get_fence_status = reinterpret_cast<PFN_vkGetFenceStatus>(get(native, "vkGetFenceStatus"));
    hooks.wait_for_fences = reinterpret_cast<PFN_vkWaitForFences>(get(native, "vkWaitForFences"));
    hooks.reset_fences = reinterpret_cast<PFN_vkResetFences>(get(native, "vkResetFences"));
    hooks.functions = {};
    hooks.function_count = 0;
    if (hooks.destroy_image_view != nullptr) {
      hooks.functions[hooks.function_count++] = {&hooks.destroy_image_view, DestroyImageView};
    }
    if (hooks.update_descriptor_sets != nullptr) {
      hooks.functions[hooks.function_count++] = {&hooks.update_descriptor_sets, UpdateDescriptorSets};
    }
    if (hooks.create_buffer_view != nullptr && hooks.destroy_buffer_view != nullptr) {
      hooks.functions[hooks.function_count++] = {&hooks.create_buffer_view, CreateBufferView};
      hooks.functions[hooks.function_count++] = {&hooks.destroy_buffer_view, DestroyBufferView};
    }
    if (hooks.get_fence_status != nullptr && hooks.wait_for_fences != nullptr && hooks.reset_fences != nullptr) {
      hooks.functions[hooks.function_count++] = {&hooks.get_fence_status, GetFenceStatus};
      hooks.functions[hooks.function_count++] = {&hooks.wait_for_fences, WaitForFences};
      hooks.functions[hooks.function_count++] = {&hooks.reset_fences, ResetFences};
    }
    if (hooks.function_count == 0) {
      renodx::utils::log::w("rdr2vk: no optional Vulkan hook subsets are available; rendering hooks are unchanged.");
      return;
    }
    RetainNativeHookProducer();
    try {
      // One atomic group of available subsets, separate from rendering hooks.
      renodx::utils::detour::Install(std::span(hooks.functions.data(), hooks.function_count));
      hooks.installed = true;
    } catch (...) {
      ReleaseNativeHookProducer();
      hooks.functions = {};
      hooks.function_count = 0;
      throw;
    }
    RecordSync({.kind = "diagnostic_hooks_installed", .device = device->get_native(), .count = static_cast<std::uint32_t>(hooks.function_count)});
  } catch (...) {
    renodx::utils::log::w("rdr2vk: optional Vulkan hook installation failed; rendering hooks are unchanged.");
  }
}

}  // namespace internal

// Attach after diagnostics::Use and before init_device is dispatched. The same
// single-device function-address assumption as the old hooks remains. No hook
// is installed late into an already-running device and no hot unload is promised.
// False on detach means the addon must remain loaded; the recorder pin remains.
inline bool Use(DWORD reason) {
  try {
    if (reason == DLL_PROCESS_ATTACH) {
      if (!IsActive()) return false;
      {
        const std::unique_lock lock(internal::hooks.mutex);
        if (internal::hooks.registered) return true;
      }
      reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      const std::unique_lock lock(internal::hooks.mutex);
      internal::hooks.registered = true;
    } else if (reason == DLL_PROCESS_DETACH) {
      // Stop future installation first, while leaving the recorder alive for
      // any original calls still reaching our installed wrappers.
      bool registered = false;
      {
        const std::unique_lock lock(internal::hooks.mutex);
        registered = std::exchange(internal::hooks.registered, false);
      }
      if (registered) {
        reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      }
      const std::unique_lock lock(internal::hooks.mutex);
      if (internal::hooks.installed) {
        // On failure keep installed=true, originals, group, and recorder pin.
        renodx::utils::detour::Uninstall(std::span(internal::hooks.functions.data(), internal::hooks.function_count));
        internal::hooks.installed = false;
        internal::hooks.functions = {};
        internal::hooks.function_count = 0;
        ReleaseNativeHookProducer();
      }
    }
    return true;
  } catch (...) {
    renodx::utils::log::w("rdr2vk: optional hook lifecycle failed; retaining active hooks and recorder state. Do not unload this addon.");
    return false;
  }
}

}  // namespace rdr2vk::diagnostics::vulkan_hooks

#endif  // RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS