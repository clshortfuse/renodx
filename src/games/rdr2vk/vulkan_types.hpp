/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "./diagnostics_config.hpp"

#include <windows.h>

#include <cstddef>
#include <cstdint>

namespace rdr2vk::vulkan {

// External API handles are opaque. These x64 declarations avoid requiring a
// Vulkan SDK and must not be used to inspect driver-private object layouts.
using VkDevice = struct VkDevice_T*;
using VkQueue = struct VkQueue_T*;
using VkCommandBuffer = struct VkCommandBuffer_T*;
using VkSwapchainKHR = struct VkSwapchainKHR_T*;
using VkSemaphore = struct VkSemaphore_T*;
using VkFence = struct VkFence_T*;
using VkResult = std::int32_t;

// API-boundary declarations: submit arrays are forwarded unchanged, never read
// or indexed here, so their SDK-owned definitions are intentionally unavailable.
struct VkSubmitInfo;
struct VkSubmitInfo2;

struct VkCommandBufferBeginInfo {
  std::uint32_t type;
  const void* next;
  std::uint32_t flags;
  const void* inheritance;
};

struct VkAcquireNextImageInfoKHR {
  std::uint32_t type;
  const void* next;
  VkSwapchainKHR swapchain;
  std::uint64_t timeout;
  VkSemaphore semaphore;
  VkFence fence;
  std::uint32_t device_mask;
};

using PFN_vkVoidFunction = void(WINAPI*)();
using PFN_vkGetDeviceProcAddr = PFN_vkVoidFunction(WINAPI*)(VkDevice, const char*);
using PFN_vkAcquireNextImageKHR = VkResult(WINAPI*)(VkDevice, VkSwapchainKHR, std::uint64_t, VkSemaphore, VkFence, std::uint32_t*);
using PFN_vkAcquireNextImage2KHR = VkResult(WINAPI*)(VkDevice, const VkAcquireNextImageInfoKHR*, std::uint32_t*);
using PFN_vkBeginCommandBuffer = VkResult(WINAPI*)(VkCommandBuffer, const VkCommandBufferBeginInfo*);
using PFN_vkQueueSubmit = VkResult(WINAPI*)(VkQueue, std::uint32_t, const VkSubmitInfo*, VkFence);
using PFN_vkQueueSubmit2 = VkResult(WINAPI*)(VkQueue, std::uint32_t, const VkSubmitInfo2*, VkFence);

static constexpr VkResult VK_SUCCESS = 0;
static constexpr VkResult VK_SUBOPTIMAL_KHR = 1000001003;
static constexpr std::uint32_t VK_COMMAND_BUFFER_USAGE_RENDER_PASS_CONTINUE_BIT = 2;
static constexpr std::uint32_t VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT = 4;

static_assert(sizeof(void*) == 8, "RDR2 Vulkan native hooks require x64");
static_assert(sizeof(VkDevice) == 8 && sizeof(VkFence) == 8 && sizeof(VkResult) == 4);
static_assert(sizeof(VkCommandBufferBeginInfo) == 32 && alignof(VkCommandBufferBeginInfo) == 8);
static_assert(offsetof(VkCommandBufferBeginInfo, next) == 8
              && offsetof(VkCommandBufferBeginInfo, flags) == 16
              && offsetof(VkCommandBufferBeginInfo, inheritance) == 24);
static_assert(sizeof(VkAcquireNextImageInfoKHR) == 56 && alignof(VkAcquireNextImageInfoKHR) == 8);
static_assert(offsetof(VkAcquireNextImageInfoKHR, swapchain) == 16
              && offsetof(VkAcquireNextImageInfoKHR, timeout) == 24
              && offsetof(VkAcquireNextImageInfoKHR, semaphore) == 32
              && offsetof(VkAcquireNextImageInfoKHR, fence) == 40
              && offsetof(VkAcquireNextImageInfoKHR, device_mask) == 48);

#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS

struct VkBufferViewCreateInfo {
  std::uint32_t type;
  const void* next;
  std::uint32_t flags;
  std::uint64_t buffer;
  std::uint32_t format;
  std::uint64_t offset;
  std::uint64_t range;
};

struct VkWriteDescriptorSet {
  std::uint32_t type;
  const void* next;
  std::uint64_t set;
  std::uint32_t binding;
  std::uint32_t element;
  std::uint32_t count;
  std::uint32_t descriptor_type;
  const void* images;
  const void* buffers;
  const std::uint64_t* views;
};

// Allocator, image/buffer descriptor payloads, and descriptor-copy arrays are
// API-owned data forwarded verbatim. Only texel-buffer inputs are inspected.
using PFN_vkDestroyImageView = void(WINAPI*)(VkDevice, std::uint64_t, const void*);
using PFN_vkCreateBufferView = VkResult(WINAPI*)(VkDevice, const VkBufferViewCreateInfo*, const void*, std::uint64_t*);
using PFN_vkDestroyBufferView = void(WINAPI*)(VkDevice, std::uint64_t, const void*);
using PFN_vkUpdateDescriptorSets = void(WINAPI*)(VkDevice, std::uint32_t, const VkWriteDescriptorSet*, std::uint32_t, const void*);
using PFN_vkGetFenceStatus = VkResult(WINAPI*)(VkDevice, VkFence);
// Non-dispatchable fence array elements have the same eight-byte x64 ABI as VkFence.
using PFN_vkWaitForFences = VkResult(WINAPI*)(VkDevice, std::uint32_t, const std::uint64_t*, std::uint32_t, std::uint64_t);
using PFN_vkResetFences = VkResult(WINAPI*)(VkDevice, std::uint32_t, const std::uint64_t*);

static_assert(sizeof(VkBufferViewCreateInfo) == 56 && alignof(VkBufferViewCreateInfo) == 8);
static_assert(offsetof(VkBufferViewCreateInfo, buffer) == 24
              && offsetof(VkBufferViewCreateInfo, format) == 32
              && offsetof(VkBufferViewCreateInfo, offset) == 40
              && offsetof(VkBufferViewCreateInfo, range) == 48);
static_assert(sizeof(VkWriteDescriptorSet) == 64 && alignof(VkWriteDescriptorSet) == 8);
static_assert(offsetof(VkWriteDescriptorSet, set) == 16
              && offsetof(VkWriteDescriptorSet, descriptor_type) == 36
              && offsetof(VkWriteDescriptorSet, images) == 40
              && offsetof(VkWriteDescriptorSet, buffers) == 48
              && offsetof(VkWriteDescriptorSet, views) == 56);

#endif  // RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS

}  // namespace rdr2vk::vulkan