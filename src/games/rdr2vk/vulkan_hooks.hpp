/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

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
static std::vector<renodx::utils::detour::Function> installed_hooks;

static VkResult WINAPI QueueSubmit(VkQueue queue, std::uint32_t count, const VkSubmitInfo* submits, VkFence fence) {
  // ReShade calls execute_command_list inside the original submit. Those
  // callbacks select uploads; only the original return can accept their facts.
  scene_tracking::SubmissionScope submission;
  const auto result = queue_submit(queue, count, submits, fence);
  scene_tracking::PublishSubmission(&submission.pending, result == VK_SUCCESS);
  return result;
}

static VkResult WINAPI QueueSubmit2(VkQueue queue, std::uint32_t count, const VkSubmitInfo2* submits, VkFence fence) {
  scene_tracking::SubmissionScope submission;
  const auto result = queue_submit2(queue, count, submits, fence);
  scene_tracking::PublishSubmission(&submission.pending, result == VK_SUCCESS);
  return result;
}

static VkResult WINAPI AcquireNextImage(
    VkDevice device, VkSwapchainKHR swapchain, std::uint64_t timeout,
    VkSemaphore semaphore, VkFence fence, std::uint32_t* index) {
  const auto result = acquire_next_image(device, swapchain, timeout, semaphore, fence, index);
  if ((result == VK_SUCCESS || result == VK_SUBOPTIMAL_KHR) && index != nullptr) {
    output::OnAcquireBackBuffer(reinterpret_cast<std::uint64_t>(swapchain), *index);
  }
  return result;
}

static VkResult WINAPI AcquireNextImage2(
    VkDevice device, const VkAcquireNextImageInfoKHR* info, std::uint32_t* index) {
  const auto result = acquire_next_image2(device, info, index);
  if ((result == VK_SUCCESS || result == VK_SUBOPTIMAL_KHR) && info != nullptr && index != nullptr) {
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
  if (device->get_api() != reshade::api::device_api::vulkan || !installed_hooks.empty()) return;
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
  installed_hooks = {
      {&acquire_next_image, AcquireNextImage},
      {&begin_command_buffer, BeginCommandBuffer},
      {&queue_submit, QueueSubmit},
  };
  if (acquire_next_image2 != nullptr) {
    installed_hooks.emplace_back(&acquire_next_image2, AcquireNextImage2);
  }
  if (queue_submit2 != nullptr) {
    installed_hooks.emplace_back(&queue_submit2, QueueSubmit2);
  }
  try {
    // All hooks go in together; if one fails, none stay installed.
    renodx::utils::detour::Install(installed_hooks);
  } catch (const std::system_error& error) {
    installed_hooks.clear();
    renodx::utils::log::e("rdr2vk: could not install the Vulkan hooks; error=", error.code().value());
  }
}

}  // namespace internal

static void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
  } else if (reason == DLL_PROCESS_DETACH) {
    reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
    if (!internal::installed_hooks.empty()) {
      try {
        renodx::utils::detour::Uninstall(internal::installed_hooks);
        internal::installed_hooks.clear();
      } catch (const std::system_error& error) {
        // Keep the original pointers: the hooks may still be called. Unloading
        // the add-on while the game runs is not supported.
        renodx::utils::log::e("rdr2vk: could not remove the Vulkan hooks; error=", error.code().value());
      }
    }
  }
}

}  // namespace rdr2vk::vulkan_hooks