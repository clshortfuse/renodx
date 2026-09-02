/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#ifndef VK_NO_PROTOTYPES
#define VK_NO_PROTOTYPES
#endif
#include <vulkan/vulkan.h>

#include <cstddef>
#include <cstdint>
#include <memory>
#include <span>

#include "dlss_bridge_abi.h"
#include "utils/dlss/ngx_vulkan.hpp"

namespace renodx::games::detroitbecomehuman::dlss {

enum class AdapterStatus : std::uint32_t {
  kSuccess = 0u,
  kFallback = 1u,
  kError = 2u,
};

enum class AdapterDetail : std::uint32_t {
  kNone = 0u,
  kInvalidArgument,
  kAlreadyInitialized,
  kNotInitialized,
  kMissingProcedure,
  kUnsupportedFormat,
  kUnexpectedResource,
  kScratchCapacityExceeded,
  kUnsafeCommandBufferReuse,
  kStalePreparedFrame,
  kVulkanFailure,
  kNgxEvaluationFailed,
};

struct AdapterResult {
  AdapterStatus status = AdapterStatus::kFallback;
  AdapterDetail detail = AdapterDetail::kNone;
  VkResult vk_result = VK_SUCCESS;

  [[nodiscard]] constexpr bool Succeeded() const noexcept {
    return status == AdapterStatus::kSuccess;
  }
};

struct AdapterRuntimeCreateInfo {
  VkInstance instance = VK_NULL_HANDLE;
  VkPhysicalDevice physical_device = VK_NULL_HANDLE;
  VkDevice device = VK_NULL_HANDLE;
  PFN_vkGetInstanceProcAddr get_instance_proc_addr = nullptr;
  PFN_vkGetDeviceProcAddr get_device_proc_addr = nullptr;
  VkPhysicalDeviceMemoryProperties memory_properties = {};
  std::uint32_t maximum_scratch_bundles = 4u;
};

struct AdapterPrepareInfo {
  VkCommandBuffer command_buffer = VK_NULL_HANDLE;
  DetroitDlssResource current_color = {};
  DetroitDlssResource depth = {};
  DetroitDlssResource motion_vectors = {};
  DetroitDlssResource output_color_pass = {};
  renodx::utils::dlss::vulkan::TrackedImageState output_color_pass_state = {};
  std::uint32_t render_width = 0u;
  std::uint32_t render_height = 0u;
  std::uint32_t output_width = 0u;
  std::uint32_t output_height = 0u;
  float dlaa_sharpening = 0.f;
  float dlaa_sharpening_normalization = 1.f;
  bool one_time_submit = false;
};

/*
 * A successful prepare call writes only private scratch images. The returned
 * resources replace the native color, motion-vector and output resources in
 * the NGX evaluation parameters. The native output_color_pass is not touched
 * until CommitAfterNgx is called with ngx_succeeded=true.
 *
 * Scratch bundles are keyed by command buffer. Vulkan already forbids a
 * command buffer from being reset/re-recorded while pending, which makes the
 * key a reliable in-flight lifetime boundary without guessing the game's
 * swapchain depth. Call RetireCommandBuffer after the command buffer is no
 * longer pending and before its handle can be recycled.
 *
 * Prepare and CommitAfterNgx bind private compute pipelines and descriptor
 * sets through downstream Vulkan procedures. The layer must capture the game
 * compute state before Prepare and restore it after CommitAfterNgx.
 */
struct AdapterPreparedFrame {
  std::uint64_t token = 0u;
  VkCommandBuffer command_buffer = VK_NULL_HANDLE;
  DetroitDlssResource color = {};
  DetroitDlssResource depth = {};
  DetroitDlssResource motion_vectors = {};
  DetroitDlssResource output = {};
  renodx::utils::dlss::vulkan::TrackedImageState color_state = {};
  renodx::utils::dlss::vulkan::TrackedImageState output_state = {};
  renodx::utils::dlss::vulkan::TrackedImageState native_output_state = {};
  std::uint32_t output_width = 0u;
  std::uint32_t output_height = 0u;
};

class AdapterRuntime final {
 public:
  AdapterRuntime();
  ~AdapterRuntime();

  AdapterRuntime(const AdapterRuntime&) = delete;
  AdapterRuntime& operator=(const AdapterRuntime&) = delete;
  AdapterRuntime(AdapterRuntime&&) = delete;
  AdapterRuntime& operator=(AdapterRuntime&&) = delete;

  [[nodiscard]] AdapterResult Initialize(const AdapterRuntimeCreateInfo& create_info);
  [[nodiscard]] AdapterResult Prepare(
      const AdapterPrepareInfo& prepare_info,
      AdapterPreparedFrame* prepared_frame);

  /*
   * Records the RGB9E5 pack only when ngx_succeeded is true. Passing false is
   * the mandatory failure path after a failed NGX create/evaluate call and is
   * guaranteed not to access the native output image.
   */
  [[nodiscard]] AdapterResult CommitAfterNgx(
      const AdapterPreparedFrame& prepared_frame,
      bool ngx_succeeded);

  /*
   * Non-blocking completion check for ONE_TIME_SUBMIT recordings. A bundle is
   * recycled only after its post-pack VkEvent is signaled. Returns the exact
   * command buffers whose NGX recording lifetime can be discarded.
   */
  [[nodiscard]] std::size_t PollCompletedOneTimeCommandBuffers(
      std::span<VkCommandBuffer> completed) noexcept;

  /*
   * Call only after vkResetCommandBuffer or vkResetCommandPool succeeded.
   * The old recording is invalid and not pending at that point, so the
   * command buffer's private bundle can be detached into the bounded idle
   * pool and safely assigned to a different command buffer later.
   */
  void RecycleCommandBuffer(VkCommandBuffer command_buffer) noexcept;

  /* The command buffer must not be pending when this is called. */
  [[nodiscard]] AdapterResult RetireCommandBuffer(VkCommandBuffer command_buffer);

  /*
   * Shutdown normally waits for the device to become idle before destroying
   * shared Vulkan objects. The vkDestroyDevice interception may pass false:
   * Vulkan already requires the application to complete every submission
   * before that terminal call, so another layer-owned wait is redundant and
   * can deadlock a driver shutdown path.
   */
  void Shutdown(bool wait_for_idle = true) noexcept;

 private:
  struct Impl;
  std::unique_ptr<Impl> impl_;
};

}  // namespace renodx::games::detroitbecomehuman::dlss
