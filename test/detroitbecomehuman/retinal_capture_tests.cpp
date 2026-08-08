/*
 * SPDX-License-Identifier: MIT
 */

#include <cstdint>
#include <iostream>
#include <string_view>

#include "src/games/detroitbecomehuman/retinal_capture.hpp"

namespace {

namespace capture =
    renodx::games::detroitbecomehuman::retinal_capture;
namespace embedded =
    renodx::games::detroitbecomehuman::dlss::embedded;

bool Expect(bool condition, std::string_view description) {
  if (condition) return true;
  std::cerr << "FAIL: " << description << '\n';
  return false;
}

embedded::DofCompositeImageSnapshot MakeExactSnapshot() {
  embedded::DofCompositeImageSnapshot snapshot = {
      .command_buffer = 1u,
      .descriptor_set = 2u,
      .pipeline_layout = 3u,
      .compute_pipeline = 4u,
      .descriptor_set_index = 0u,
      .binding = capture::kCompositeOutputBinding,
      .dynamic_offset_count = 1u,
      .dynamic_offset = 256u,
      .push_constant_stage_flags = capture::kVkShaderStageCompute,
      .push_constant_offset = 0u,
      .push_constant_size = capture::kShaderInjectDataSize,
  };
  snapshot.image.binding = capture::kCompositeOutputBinding;
  snapshot.image.descriptor_type = capture::kVkDescriptorTypeStorageImage;
  snapshot.image.descriptor_set = snapshot.descriptor_set;
  snapshot.image.resource = {
      .image = 5u,
      .image_view = 6u,
      .format = capture::kVkFormatR16G16B16A16Sfloat,
      .layout = capture::kVkImageLayoutGeneral,
      .width = 3440u,
      .height = 1440u,
      .mip_level = 0u,
      .array_layer = 0u,
  };
  snapshot.image.image_format = capture::kVkFormatR16G16B16A16Sfloat;
  snapshot.image.image_type = capture::kVkImageType2d;
  snapshot.image.view_type = capture::kVkImageViewType2d;
  snapshot.image.aspect_mask = capture::kVkImageAspectColor;
  snapshot.image.level_count = 1u;
  snapshot.image.layer_count = 1u;
  snapshot.image.image_mip_levels = 1u;
  snapshot.image.image_array_layers = 1u;
  snapshot.image.image_width = 3440u;
  snapshot.image.image_height = 1440u;
  snapshot.image.image_depth = 1u;
  snapshot.image.sample_count = capture::kVkSampleCount1;
  snapshot.image.image_usage =
      capture::kVkImageUsageSampled | capture::kVkImageUsageStorage;
  snapshot.image.valid_flags = DETROIT_DLSS_IMAGE_MANDATORY_MASK;
  snapshot.depth.binding = 3u;
  snapshot.depth.descriptor_set = snapshot.descriptor_set;
  snapshot.depth.descriptor_type =
      capture::kVkDescriptorTypeCombinedImageSampler;
  snapshot.depth.resource.image = 7u;
  snapshot.depth.resource.image_view = 8u;
  snapshot.depth.resource.width = 3440u;
  snapshot.depth.resource.height = 1440u;
  snapshot.depth.valid_flags = DETROIT_DLSS_IMAGE_MANDATORY_MASK;
  return snapshot;
}

bool TestExactContract() {
  auto snapshot = MakeExactSnapshot();
  bool passed = true;
  passed &= Expect(
      capture::IsExactCompositeOutput(snapshot),
      "the verified full-resolution b16 contract must pass");

  snapshot.dynamic_offset_count = 0u;
  passed &= Expect(
      !capture::IsExactCompositeOutput(snapshot),
      "missing b52 dynamic offset metadata must fail closed");
  snapshot = MakeExactSnapshot();
  snapshot.push_constant_size = 40u;
  passed &= Expect(
      !capture::IsExactCompositeOutput(snapshot),
      "the native 112-byte push payload must be restorable");
  snapshot = MakeExactSnapshot();
  snapshot.image.resource.format = 109u;
  passed &= Expect(
      !capture::IsExactCompositeOutput(snapshot),
      "a non-RGBA16F view must fail closed");
  snapshot = MakeExactSnapshot();
  snapshot.image.image_usage &= ~capture::kVkImageUsageSampled;
  passed &= Expect(
      !capture::IsExactCompositeOutput(snapshot),
      "an output that cannot be sampled must fail closed");
  snapshot = MakeExactSnapshot();
  snapshot.image.binding = 15u;
  passed &= Expect(
      !capture::IsExactCompositeOutput(snapshot),
      "only the verified composite b16 may be filtered");
  snapshot = MakeExactSnapshot();
  snapshot.depth.resource.width = 1720u;
  passed &= Expect(
      !capture::IsExactCompositeOutput(snapshot),
      "b16 must be full-resolution relative to composite depth b3");
  return passed;
}

}  // namespace

int main() {
  return TestExactContract() ? 0 : 1;
}
