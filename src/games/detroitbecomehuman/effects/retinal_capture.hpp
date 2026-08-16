/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>

#include <include/reshade.hpp>

#include "../dlss/embedded_bootstrap.hpp"
#include "retinal_runtime.hpp"

namespace renodx::games::detroitbecomehuman::retinal_capture {

namespace embedded = dlss::embedded;

inline constexpr std::uint32_t kCompositeOutputBinding = 16u;
inline constexpr std::uint32_t kVkDescriptorTypeCombinedImageSampler = 1u;
inline constexpr std::uint32_t kVkDescriptorTypeStorageImage = 3u;
inline constexpr std::uint32_t kVkFormatR16G16B16A16Sfloat = 97u;
inline constexpr std::uint32_t kVkImageLayoutGeneral = 1u;
inline constexpr std::uint32_t kVkImageType2d = 1u;
inline constexpr std::uint32_t kVkImageViewType2d = 1u;
inline constexpr std::uint32_t kVkImageAspectColor = 0x1u;
inline constexpr std::uint32_t kVkSampleCount1 = 1u;
inline constexpr std::uint32_t kVkImageUsageSampled = 0x4u;
inline constexpr std::uint32_t kVkImageUsageStorage = 0x8u;
inline constexpr std::uint32_t kVkShaderStageCompute = 0x20u;
inline constexpr std::uint32_t kShaderInjectDataSize = 112u;

enum class CaptureResult : std::uint32_t {
  kNotAttempted = 0u,
  kSuccess,
  kNullCommandList,
  kMissingDevice,
  kUnsupportedDeviceApi,
  kSnapshotUnavailable,
  kCommandStateInvalid,
  kPipelineContractMismatch,
  kPushConstantContractMismatch,
  kOutputDescriptorContractMismatch,
  kOutputMetadataIncomplete,
  kOutputResourceMissing,
  kOutputFormatMismatch,
  kOutputLayoutMismatch,
  kOutputExtentInvalid,
  kOutputSubresourceMismatch,
  kOutputImageContractMismatch,
  kOutputUsageMismatch,
  kDepthDescriptorContractMismatch,
  kDepthMetadataIncomplete,
  kDepthResourceMissing,
  kDepthExtentMismatch,
  kDepthSubresourceMismatch,
  kSnapshotReleaseFailed,
};

struct Capture {
  embedded::DofCompositeImageSnapshot native = {};
  retinal::CompositeOutputSnapshot output = {};
  CaptureResult result = CaptureResult::kNotAttempted;
  embedded::DofCompositeCaptureDetail embedded_detail =
      embedded::DofCompositeCaptureDetail::kNotAttempted;

  [[nodiscard]] bool IsValid() const noexcept {
    return result == CaptureResult::kSuccess;
  }
};

[[nodiscard]] inline CaptureResult ValidateCompositeOutput(
    const embedded::DofCompositeImageSnapshot& snapshot) noexcept {
  const auto& image = snapshot.image;
  const auto& resource = image.resource;
  const auto& depth = snapshot.depth;
  constexpr std::uint32_t kRequiredUsage =
      kVkImageUsageSampled | kVkImageUsageStorage;
  if (snapshot.command_buffer == 0u || snapshot.descriptor_set == 0u
      || snapshot.pipeline_layout == 0u || snapshot.compute_pipeline == 0u) {
    return CaptureResult::kCommandStateInvalid;
  }
  if (snapshot.descriptor_set_index != 0u
      || snapshot.binding != kCompositeOutputBinding
      || snapshot.dynamic_offset_count != 1u) {
    return CaptureResult::kPipelineContractMismatch;
  }
  if ((snapshot.push_constant_stage_flags & kVkShaderStageCompute) == 0u
      || snapshot.push_constant_offset != 0u
      || snapshot.push_constant_size != kShaderInjectDataSize) {
    return CaptureResult::kPushConstantContractMismatch;
  }
  if (image.binding != kCompositeOutputBinding
      || image.descriptor_set != snapshot.descriptor_set
      || image.descriptor_type != kVkDescriptorTypeStorageImage) {
    return CaptureResult::kOutputDescriptorContractMismatch;
  }
  if ((image.valid_flags & DETROIT_DLSS_IMAGE_MANDATORY_MASK)
      != DETROIT_DLSS_IMAGE_MANDATORY_MASK) {
    return CaptureResult::kOutputMetadataIncomplete;
  }
  if (resource.image == 0u || resource.image_view == 0u) {
    return CaptureResult::kOutputResourceMissing;
  }
  if (resource.format != kVkFormatR16G16B16A16Sfloat
      || image.image_format != kVkFormatR16G16B16A16Sfloat) {
    return CaptureResult::kOutputFormatMismatch;
  }
  if (resource.layout != kVkImageLayoutGeneral) {
    return CaptureResult::kOutputLayoutMismatch;
  }
  if (resource.width == 0u || resource.height == 0u) {
    return CaptureResult::kOutputExtentInvalid;
  }
  if (resource.mip_level != 0u || resource.array_layer != 0u) {
    return CaptureResult::kOutputSubresourceMismatch;
  }
  if (image.image_type != kVkImageType2d
      || image.view_type != kVkImageViewType2d
      || image.aspect_mask != kVkImageAspectColor || image.level_count != 1u
      || image.layer_count != 1u || image.image_mip_levels != 1u
      || image.image_array_layers != 1u || image.image_depth != 1u
      || image.sample_count != kVkSampleCount1) {
    return CaptureResult::kOutputImageContractMismatch;
  }
  if ((image.image_usage & kRequiredUsage) != kRequiredUsage) {
    return CaptureResult::kOutputUsageMismatch;
  }
  if (depth.binding != 3u || depth.descriptor_set != snapshot.descriptor_set
      || depth.descriptor_type != kVkDescriptorTypeCombinedImageSampler) {
    return CaptureResult::kDepthDescriptorContractMismatch;
  }
  if ((depth.valid_flags & DETROIT_DLSS_IMAGE_MANDATORY_MASK)
      != DETROIT_DLSS_IMAGE_MANDATORY_MASK) {
    return CaptureResult::kDepthMetadataIncomplete;
  }
  if (depth.resource.image == 0u || depth.resource.image_view == 0u) {
    return CaptureResult::kDepthResourceMissing;
  }
  if (depth.resource.width != resource.width
      || depth.resource.height != resource.height) {
    return CaptureResult::kDepthExtentMismatch;
  }
  if (depth.resource.mip_level != 0u || depth.resource.array_layer != 0u) {
    return CaptureResult::kDepthSubresourceMismatch;
  }
  return CaptureResult::kSuccess;
}

[[nodiscard]] inline bool IsExactCompositeOutput(
    const embedded::DofCompositeImageSnapshot& snapshot) noexcept {
  return ValidateCompositeOutput(snapshot) == CaptureResult::kSuccess;
}

[[nodiscard]] inline Capture CaptureCompositeOutput(
    reshade::api::command_list* command_list) {
  Capture result = {};
  if (command_list == nullptr) {
    result.result = CaptureResult::kNullCommandList;
    return result;
  }
  if (command_list->get_device() == nullptr) {
    result.result = CaptureResult::kMissingDevice;
    return result;
  }
  if (command_list->get_device()->get_api()
      != reshade::api::device_api::vulkan) {
    result.result = CaptureResult::kUnsupportedDeviceApi;
    return result;
  }
  if (!embedded::CaptureDofCompositeImageSnapshot(
          command_list->get_native(),
          &result.native,
          &result.embedded_detail)) {
    result.result = CaptureResult::kSnapshotUnavailable;
    return result;
  }
  result.result = ValidateCompositeOutput(result.native);
  if (result.result != CaptureResult::kSuccess) {
    // Capture freezes the layer's tracked game state. A redundant native
    // release safely thaws it even though no Retinal command was recorded.
    if (!embedded::ReleaseDofCompositeImageSnapshot(result.native)) {
      result.result = CaptureResult::kSnapshotReleaseFailed;
    }
    result.native = {};
    return result;
  }
  const auto& resource = result.native.image.resource;
  result.output = {
      .resource = reshade::api::resource{resource.image},
      .unordered_access_view = reshade::api::resource_view{resource.image_view},
      .width = resource.width,
      .height = resource.height,
      .mip_level = resource.mip_level,
      .array_layer = resource.array_layer,
      .valid = true,
  };
  result.result = CaptureResult::kSuccess;
  return result;
}

[[nodiscard]] inline bool ReleaseCompositeState(const Capture& capture) {
  return capture.IsValid()
         && embedded::ReleaseDofCompositeImageSnapshot(capture.native);
}

[[nodiscard]] inline bool RestoreCompositeState(
    const Capture& capture,
    const void* push_constant_data,
    std::uint32_t push_constant_size) {
  return capture.IsValid()
         && embedded::RestoreDofCompositeComputeState(
             capture.native, push_constant_data, push_constant_size);
}

}  // namespace renodx::games::detroitbecomehuman::retinal_capture
