/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "./diagnostics_config.hpp"

#include <windows.h>

#include <bit>
#include <cstdint>
#include <optional>
#include <system_error>
#include <vector>

#include <include/reshade.hpp>

#include "../../utils/detour.hpp"
#include "../../utils/log.hpp"
#include "./output.hpp"
#include "./scene_tracking.hpp"
#include "./vulkan_types.hpp"

#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
#include "./diagnostics/recorder.hpp"
#endif

namespace rdr2vk::vulkan_hooks {
namespace internal {

using vulkan::PFN_vkAcquireNextImage2KHR;
using vulkan::PFN_vkAcquireNextImageKHR;
using vulkan::PFN_vkBeginCommandBuffer;
using vulkan::PFN_vkGetDeviceProcAddr;
using vulkan::PFN_vkQueueSubmit;
using vulkan::PFN_vkQueueSubmit2;
using vulkan::VK_SUBOPTIMAL_KHR;
using vulkan::VK_SUCCESS;
using vulkan::VkAcquireNextImageInfoKHR;
using vulkan::VkCommandBuffer;
using vulkan::VkCommandBufferBeginInfo;
using vulkan::VkDevice;
using vulkan::VkFence;
using vulkan::VkQueue;
using vulkan::VkResult;
using vulkan::VkSemaphore;
using vulkan::VkSubmitInfo;
using vulkan::VkSubmitInfo2;
using vulkan::VkSwapchainKHR;

// ReShade's native entry points are installed once, as in the original addon.
// This does not promise support for devices with different function addresses.
static PFN_vkAcquireNextImageKHR acquire_next_image = nullptr;
static PFN_vkAcquireNextImage2KHR acquire_next_image2 = nullptr;
static PFN_vkBeginCommandBuffer begin_command_buffer = nullptr;
static PFN_vkQueueSubmit queue_submit = nullptr;
static PFN_vkQueueSubmit2 queue_submit2 = nullptr;
static std::vector<renodx::utils::detour::Function> required_hooks;

static VkResult WINAPI QueueSubmit(VkQueue queue, std::uint32_t count, const VkSubmitInfo* submits, VkFence fence) {
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  const auto request = diagnostics::NextRequest();
  const auto fence_handle = reinterpret_cast<std::uint64_t>(fence);
  diagnostics::RecordSync({.kind = "submit_enter", .object = reinterpret_cast<std::uint64_t>(queue), .request = request, .count = 1, .handles = &fence_handle});
#endif
  VkResult result;
  {
    // ReShade calls execute_command_list inside the original submit. Those
    // callbacks select uploads; only the original return can accept their facts.
    scene_tracking::SubmissionScope submission;
    result = queue_submit(queue, count, submits, fence);
    scene_tracking::PublishSubmission(&submission.pending, result == VK_SUCCESS);
  }
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  diagnostics::RecordSync({.kind = "submit_return", .object = reinterpret_cast<std::uint64_t>(queue), .request = request, .result = result, .count = 1, .handles = &fence_handle});
#endif
  return result;
}

static VkResult WINAPI QueueSubmit2(VkQueue queue, std::uint32_t count, const VkSubmitInfo2* submits, VkFence fence) {
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  const auto request = diagnostics::NextRequest();
  const auto fence_handle = reinterpret_cast<std::uint64_t>(fence);
  diagnostics::RecordSync({.kind = "submit2_enter", .object = reinterpret_cast<std::uint64_t>(queue), .request = request, .count = 1, .handles = &fence_handle});
#endif
  VkResult result;
  {
    scene_tracking::SubmissionScope submission;
    result = queue_submit2(queue, count, submits, fence);
    scene_tracking::PublishSubmission(&submission.pending, result == VK_SUCCESS);
  }
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
  diagnostics::RecordSync({.kind = "submit2_return", .object = reinterpret_cast<std::uint64_t>(queue), .request = request, .result = result, .count = 1, .handles = &fence_handle});
#endif
  return result;
}

static VkResult WINAPI AcquireNextImage(
    VkDevice device, VkSwapchainKHR swapchain, std::uint64_t timeout,
    VkSemaphore semaphore, VkFence fence, std::uint32_t* index) {
  const auto result = acquire_next_image(device, swapchain, timeout, semaphore, fence, index);
  if ((result == VK_SUCCESS || result == VK_SUBOPTIMAL_KHR) && index != nullptr) {
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
    diagnostics::RecordSync({.kind = "acquire", .device = reinterpret_cast<std::uint64_t>(device), .object = reinterpret_cast<std::uint64_t>(swapchain), .result = result, .count = *index});
#endif
    output::OnAcquireBackBuffer(reinterpret_cast<std::uint64_t>(swapchain), *index);
  }
  return result;
}

static VkResult WINAPI AcquireNextImage2(
    VkDevice device, const VkAcquireNextImageInfoKHR* info, std::uint32_t* index) {
  const auto result = acquire_next_image2(device, info, index);
  if ((result == VK_SUCCESS || result == VK_SUBOPTIMAL_KHR) && info != nullptr && index != nullptr) {
#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
    diagnostics::RecordSync({.kind = "acquire", .device = reinterpret_cast<std::uint64_t>(device), .object = reinterpret_cast<std::uint64_t>(info->swapchain), .result = result, .count = *index});
#endif
    output::OnAcquireBackBuffer(reinterpret_cast<std::uint64_t>(info->swapchain), *index);
  }
  return result;
}

static VkResult WINAPI BeginCommandBuffer(VkCommandBuffer buffer, const VkCommandBufferBeginInfo* info) {
  // The nested reset callback needs these flags. Restoring the outer scope is
  // essential when another intercepted call happens on the same CPU thread.
  const scene_tracking::RecordingScope recording(info != nullptr ? std::optional{info->flags} : std::nullopt);
  return begin_command_buffer(buffer, info);
}

static void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() != reshade::api::device_api::vulkan || !required_hooks.empty()) return;
  const auto get = reinterpret_cast<PFN_vkGetDeviceProcAddr>(
      GetProcAddress(reshade::internal::get_reshade_module_handle(), "vkGetDeviceProcAddr"));
  if (get == nullptr) {
    renodx::utils::log::e("rdr2vk: could not find ReShade's Vulkan function lookup.");
    return;
  }
  auto* const native = std::bit_cast<VkDevice>(device->get_native());
  acquire_next_image = reinterpret_cast<PFN_vkAcquireNextImageKHR>(get(native, "vkAcquireNextImageKHR"));
  acquire_next_image2 = reinterpret_cast<PFN_vkAcquireNextImage2KHR>(get(native, "vkAcquireNextImage2KHR"));
  begin_command_buffer = reinterpret_cast<PFN_vkBeginCommandBuffer>(get(native, "vkBeginCommandBuffer"));
  queue_submit = reinterpret_cast<PFN_vkQueueSubmit>(get(native, "vkQueueSubmit"));
  queue_submit2 = reinterpret_cast<PFN_vkQueueSubmit2>(get(native, "vkQueueSubmit2"));
  if (queue_submit2 == nullptr) {
    queue_submit2 = reinterpret_cast<PFN_vkQueueSubmit2>(get(native, "vkQueueSubmit2KHR"));
  }
  if (acquire_next_image == nullptr || begin_command_buffer == nullptr || queue_submit == nullptr) {
    renodx::utils::log::e("rdr2vk: required Vulkan acquire, command-buffer begin, or queue-submit functions are missing.");
    return;
  }
  required_hooks = {
      {&acquire_next_image, AcquireNextImage},
      {&begin_command_buffer, BeginCommandBuffer},
      {&queue_submit, QueueSubmit},
  };
  if (acquire_next_image2 != nullptr) {
    required_hooks.emplace_back(&acquire_next_image2, AcquireNextImage2);
  }
  if (queue_submit2 != nullptr) {
    required_hooks.emplace_back(&queue_submit2, QueueSubmit2);
  }
  try {
    // Core rolls back an uncommitted transaction. Optional recording hooks
    // have their own group, so their failure cannot undo this installation.
    renodx::utils::detour::Install(required_hooks);
  } catch (const std::system_error& error) {
    required_hooks.clear();
    renodx::utils::log::e("rdr2vk: could not install required Vulkan hooks; error=", error.code().value());
  }
}

}  // namespace internal

static bool Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
  } else if (reason == DLL_PROCESS_DETACH) {
    reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
    if (!internal::required_hooks.empty()) {
      try {
        renodx::utils::detour::Uninstall(internal::required_hooks);
        internal::required_hooks.clear();
      } catch (const std::system_error& error) {
        // Keep the installed group and original pointers available. Returning
        // false cannot prevent FreeLibrary; live hot unload is not supported.
        renodx::utils::log::e("rdr2vk: could not remove required Vulkan hooks; error=", error.code().value());
        return false;
      }
    }
  }
  return true;
}

}  // namespace rdr2vk::vulkan_hooks