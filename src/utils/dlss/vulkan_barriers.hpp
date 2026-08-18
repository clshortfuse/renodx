/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "ngx_vulkan.hpp"

namespace renodx::utils::dlss::vulkan {

struct ImageBarrierPlan final {
  VkPipelineStageFlags source_stage = 0u;
  VkPipelineStageFlags destination_stage = 0u;
  VkImageMemoryBarrier barrier = {};
};

inline ImageBarrierPlan MakeImageBarrierPlan(
    const TrackedImageState& image,
    VkPipelineStageFlags source_stage,
    VkPipelineStageFlags destination_stage,
    VkAccessFlags source_access,
    VkAccessFlags destination_access,
    VkImageLayout old_layout,
    VkImageLayout new_layout) {
  return {
      .source_stage = source_stage,
      .destination_stage = destination_stage,
      .barrier = {
          .sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
          .pNext = nullptr,
          .srcAccessMask = source_access,
          .dstAccessMask = destination_access,
          .oldLayout = old_layout,
          .newLayout = new_layout,
          .srcQueueFamilyIndex = image.queue_family,
          .dstQueueFamilyIndex = image.queue_family,
          .image = image.image,
          .subresourceRange = image.range,
      },
  };
}

// Fresh scratch discards prior contents. Reused scratch depends only on its
// last proven access; both paths prepare a compute storage write in GENERAL.
inline ImageBarrierPlan PlanScratchStorageWrite(
    const TrackedImageState& image) {
  const bool discard = !image.contents_valid
                       || image.layout == VK_IMAGE_LAYOUT_UNDEFINED;
  return MakeImageBarrierPlan(
      image,
      discard ? VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT : image.stage,
      VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      discard ? 0u : image.access,
      VK_ACCESS_SHADER_WRITE_BIT,
      discard ? VK_IMAGE_LAYOUT_UNDEFINED : image.layout,
      VK_IMAGE_LAYOUT_GENERAL);
}

inline ImageBarrierPlan PlanPreparedColorSampledRead(
    const TrackedImageState& image) {
  return MakeImageBarrierPlan(
      image,
      VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      VK_ACCESS_SHADER_WRITE_BIT,
      VK_ACCESS_SHADER_READ_BIT,
      VK_IMAGE_LAYOUT_GENERAL,
      VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL);
}

inline ImageBarrierPlan PlanNgxOutputSampledRead(
    const TrackedImageState& image) {
  return MakeImageBarrierPlan(
      image,
      VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      VK_ACCESS_SHADER_WRITE_BIT,
      VK_ACCESS_SHADER_READ_BIT,
      VK_IMAGE_LAYOUT_GENERAL,
      VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL);
}

inline ImageBarrierPlan PlanNativeOutputPackWrite(
    const TrackedImageState& image) {
  return MakeImageBarrierPlan(
      image,
      VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT,
      VK_ACCESS_SHADER_WRITE_BIT,
      VK_IMAGE_LAYOUT_GENERAL,
      VK_IMAGE_LAYOUT_GENERAL);
}

inline ImageBarrierPlan PlanPackedOutputDownstream(
    const TrackedImageState& image) {
  return MakeImageBarrierPlan(
      image,
      VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
      VK_ACCESS_SHADER_WRITE_BIT,
      VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT,
      VK_IMAGE_LAYOUT_GENERAL,
      VK_IMAGE_LAYOUT_GENERAL);
}

}  // namespace renodx::utils::dlss::vulkan
