/*
 * SPDX-License-Identifier: MIT
 */

#include <array>
#include <atomic>
#include <chrono>
#include <cstddef>
#include <cstdint>
#include <iostream>
#include <limits>
#include <string_view>
#include <thread>
#include <type_traits>

#include "src/games/detroitbecomehuman/dlss_bridge_abi.h"
#include "src/games/detroitbecomehuman/dlss_bridge_client.hpp"
#include "src/games/detroitbecomehuman/dlss/evaluation_trace.hpp"
#include "src/games/detroitbecomehuman/supported_build.hpp"
#include "src/games/detroitbecomehuman/temporal_mode_state.hpp"

namespace {

namespace supported_build = renodx::games::detroitbecomehuman::supported_build;
namespace dlss_bridge_client =
    renodx::games::detroitbecomehuman::dlss_bridge_client;
namespace dlss_evaluation_trace =
    renodx::games::detroitbecomehuman::dlss;
namespace temporal_mode_state =
    renodx::games::detroitbecomehuman::temporal_mode_state;

static_assert(std::is_standard_layout_v<DetroitDlssBootstrapContext>);
static_assert(std::is_trivially_copyable_v<DetroitDlssBootstrapContext>);
static_assert(std::is_standard_layout_v<DetroitDlssResource>);
static_assert(std::is_trivially_copyable_v<DetroitDlssResource>);
static_assert(std::is_standard_layout_v<DetroitDlssTemporalConstantsSnapshot>);
static_assert(std::is_trivially_copyable_v<DetroitDlssTemporalConstantsSnapshot>);
static_assert(std::is_standard_layout_v<DetroitDlssImageBindingSnapshot>);
static_assert(std::is_trivially_copyable_v<DetroitDlssImageBindingSnapshot>);
static_assert(std::is_standard_layout_v<DetroitDlssTemporalConstantsDiagnostics>);
static_assert(std::is_trivially_copyable_v<DetroitDlssTemporalConstantsDiagnostics>);
static_assert(std::is_standard_layout_v<DetroitDlssTemporalDescriptorSnapshot>);
static_assert(std::is_trivially_copyable_v<DetroitDlssTemporalDescriptorSnapshot>);
static_assert(std::is_standard_layout_v<DetroitDlssModeSettings>);
static_assert(std::is_trivially_copyable_v<DetroitDlssModeSettings>);
static_assert(std::is_standard_layout_v<DetroitDlssTemporalFrameInputs>);
static_assert(std::is_trivially_copyable_v<DetroitDlssTemporalFrameInputs>);
static_assert(std::is_standard_layout_v<DetroitDlssEvaluateResult>);
static_assert(std::is_trivially_copyable_v<DetroitDlssEvaluateResult>);
static_assert(std::is_standard_layout_v<DetroitDlssApiV2>);
static_assert(std::is_trivially_copyable_v<DetroitDlssApiV2>);

static_assert(sizeof(DetroitDlssBootstrapContext) == 80u);
static_assert(alignof(DetroitDlssBootstrapContext) == 8u);
static_assert(offsetof(DetroitDlssBootstrapContext, vk_instance) == 8u);
static_assert(offsetof(DetroitDlssBootstrapContext, graphics_queue_family_index) == 56u);
static_assert(offsetof(DetroitDlssBootstrapContext, capability_flags) == 64u);

static_assert(sizeof(DetroitDlssResource) == 48u);
static_assert(alignof(DetroitDlssResource) == 8u);
static_assert(offsetof(DetroitDlssResource, image_view) == 8u);
static_assert(offsetof(DetroitDlssResource, format) == 16u);
static_assert(offsetof(DetroitDlssResource, width) == 24u);
static_assert(offsetof(DetroitDlssResource, flags) == 40u);

static_assert(sizeof(DetroitDlssTemporalConstantsSnapshot) == 1128u);
static_assert(alignof(DetroitDlssTemporalConstantsSnapshot) == 8u);
static_assert(offsetof(DetroitDlssTemporalConstantsSnapshot, descriptor_set_index) == 8u);
static_assert(offsetof(DetroitDlssTemporalConstantsSnapshot, binding) == 12u);
static_assert(offsetof(DetroitDlssTemporalConstantsSnapshot, command_buffer) == 16u);
static_assert(offsetof(DetroitDlssTemporalConstantsSnapshot, descriptor_set) == 24u);
static_assert(offsetof(DetroitDlssTemporalConstantsSnapshot, buffer) == 40u);
static_assert(offsetof(DetroitDlssTemporalConstantsSnapshot, descriptor_offset) == 48u);
static_assert(offsetof(DetroitDlssTemporalConstantsSnapshot, dynamic_offset) == 56u);
static_assert(offsetof(DetroitDlssTemporalConstantsSnapshot, effective_offset) == 64u);
static_assert(offsetof(DetroitDlssTemporalConstantsSnapshot, descriptor_range) == 72u);
static_assert(offsetof(DetroitDlssTemporalConstantsSnapshot, bytes_written) == 80u);
static_assert(offsetof(DetroitDlssTemporalConstantsSnapshot, valid_flags) == 88u);
static_assert(offsetof(DetroitDlssTemporalConstantsSnapshot, source_flags) == 96u);
static_assert(offsetof(DetroitDlssTemporalConstantsSnapshot, constants) == 104u);

static_assert(sizeof(DetroitDlssImageBindingSnapshot) == 160u);
static_assert(alignof(DetroitDlssImageBindingSnapshot) == 8u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, struct_size) == 0u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, binding) == 4u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, array_element) == 8u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, descriptor_type) == 12u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, descriptor_set) == 16u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, sampler) == 24u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, resource) == 32u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, image_format) == 80u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, image_type) == 84u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, view_type) == 88u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, aspect_mask) == 92u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, level_count) == 96u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, layer_count) == 100u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, image_mip_levels) == 104u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, image_array_layers) == 108u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, image_width) == 112u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, image_height) == 116u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, image_depth) == 120u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, sample_count) == 124u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, image_usage) == 128u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, image_create_flags) == 132u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, valid_flags) == 136u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, source_flags) == 144u);
static_assert(offsetof(DetroitDlssImageBindingSnapshot, update_serial) == 152u);

static_assert(sizeof(DetroitDlssTemporalConstantsDiagnostics) == 80u);
static_assert(alignof(DetroitDlssTemporalConstantsDiagnostics) == 8u);
static_assert(offsetof(DetroitDlssTemporalConstantsDiagnostics, struct_size) == 0u);
static_assert(offsetof(DetroitDlssTemporalConstantsDiagnostics, detail_code) == 4u);
static_assert(offsetof(DetroitDlssTemporalConstantsDiagnostics, buffer_usage) == 8u);
static_assert(offsetof(DetroitDlssTemporalConstantsDiagnostics, memory_property_flags) == 12u);
static_assert(offsetof(DetroitDlssTemporalConstantsDiagnostics, buffer_size) == 16u);
static_assert(offsetof(DetroitDlssTemporalConstantsDiagnostics, allocation_size) == 24u);
static_assert(offsetof(DetroitDlssTemporalConstantsDiagnostics, buffer_memory_offset) == 32u);
static_assert(offsetof(DetroitDlssTemporalConstantsDiagnostics, mapped_offset) == 40u);
static_assert(offsetof(DetroitDlssTemporalConstantsDiagnostics, mapped_size) == 48u);
static_assert(offsetof(DetroitDlssTemporalConstantsDiagnostics, required_payload_size) == 56u);
static_assert(offsetof(DetroitDlssTemporalConstantsDiagnostics, descriptor_source_flags) == 64u);
static_assert(offsetof(DetroitDlssTemporalConstantsDiagnostics, descriptor_update_serial) == 72u);

static_assert(sizeof(DetroitDlssTemporalDescriptorSnapshot) == 3376u);
static_assert(alignof(DetroitDlssTemporalDescriptorSnapshot) == 8u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, struct_size) == 0u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, abi_version) == 4u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, descriptor_set_index) == 8u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, image_binding_count) == 12u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, command_buffer) == 16u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, descriptor_set) == 24u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, pipeline_layout) == 32u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, compute_pipeline) == 40u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, required_image_mask) == 48u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, present_image_mask) == 56u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, complete_image_mask) == 64u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, snapshot_flags) == 72u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, detail_code) == 80u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, reserved) == 84u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, images) == 88u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, constants) == 2168u);
static_assert(offsetof(DetroitDlssTemporalDescriptorSnapshot, constants_diagnostics) == 3296u);

static_assert(sizeof(DetroitDlssModeSettings) == 48u);
static_assert(alignof(DetroitDlssModeSettings) == 4u);
static_assert(offsetof(DetroitDlssModeSettings, mode) == 8u);
static_assert(offsetof(DetroitDlssModeSettings, create_flags) == 12u);
static_assert(offsetof(DetroitDlssModeSettings, render_width) == 24u);
static_assert(offsetof(DetroitDlssModeSettings, max_render_height) == 44u);

static_assert(sizeof(DetroitDlssTemporalFrameInputs) == 392u);
static_assert(alignof(DetroitDlssTemporalFrameInputs) == 8u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, shader_crc) == 8u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, command_buffer) == 16u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, compute_pipeline) == 40u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, constants_buffer) == 48u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, constants_size) == 64u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, constants_dynamic_offset) == 72u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, current_color) == 80u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, depth) == 128u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, motion_vectors) == 176u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, exposure) == 224u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, output) == 272u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, render_width) == 320u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, jitter_x) == 336u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, frame_id) == 360u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, verification_flags) == 376u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, dlaa_sharpening) == 384u);
static_assert(
    offsetof(
        DetroitDlssTemporalFrameInputs,
        dlaa_sharpening_normalization)
    == 388u);

static_assert(sizeof(DetroitDlssEvaluateResult) == 32u);
static_assert(alignof(DetroitDlssEvaluateResult) == 8u);
static_assert(offsetof(DetroitDlssEvaluateResult, status) == 8u);
static_assert(offsetof(DetroitDlssEvaluateResult, frame_id) == 16u);
static_assert(offsetof(DetroitDlssEvaluateResult, flags) == 24u);

static_assert(sizeof(DetroitDlssApiV2) == 64u);
static_assert(alignof(DetroitDlssApiV2) == 8u);
static_assert(offsetof(DetroitDlssApiV2, struct_size) == 0u);
static_assert(offsetof(DetroitDlssApiV2, abi_version) == 4u);
static_assert(offsetof(DetroitDlssApiV2, get_context) == 8u);
static_assert(offsetof(DetroitDlssApiV2, get_temporal_constants) == 16u);
static_assert(offsetof(DetroitDlssApiV2, get_temporal_snapshot) == 24u);
static_assert(offsetof(DetroitDlssApiV2, query_mode) == 32u);
static_assert(offsetof(DetroitDlssApiV2, configure) == 40u);
static_assert(offsetof(DetroitDlssApiV2, evaluate) == 48u);
static_assert(offsetof(DetroitDlssApiV2, shutdown) == 56u);

bool Expect(bool condition, std::string_view description) {
  if (condition) return true;
  std::cerr << "FAIL: " << description << '\n';
  return false;
}

bool g_context_queried = false;
bool g_constants_queried = false;
bool g_snapshot_queried = false;
bool g_use_targeted_snapshot = false;
bool g_mode_queried = false;
bool g_configured = false;
bool g_evaluated = false;
bool g_shutdown = false;

DetroitDlssResultCode DETROIT_DLSS_CALL FakeGetContext(
    DetroitDlssBootstrapContext* context) {
  if (context == nullptr
      || context->struct_size < sizeof(DetroitDlssBootstrapContext)
      || context->abi_version != DETROIT_DLSS_ABI_VERSION) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  g_context_queried = true;
  context->vk_instance = UINT64_C(0x1111111111111111);
  context->vk_physical_device = UINT64_C(0x2222222222222222);
  context->vk_device = UINT64_C(0x3333333333333333);
  context->vk_graphics_queue = UINT64_C(0x4444444444444444);
  context->capability_flags = DETROIT_DLSS_CAPABILITY_SUPPORTED_EXECUTABLE
                              | DETROIT_DLSS_CAPABILITY_TEMPORAL_INPUTS_VERIFIED
                              | DETROIT_DLSS_CAPABILITY_SUPER_RESOLUTION
                              | DETROIT_DLSS_CAPABILITY_DLAA;
  return DETROIT_DLSS_RESULT_SUCCESS;
}

DetroitDlssResultCode DETROIT_DLSS_CALL FakeQueryMode(
    DetroitDlssMode mode,
    std::uint32_t output_width,
    std::uint32_t output_height,
    DetroitDlssModeSettings* settings) {
  if (settings == nullptr
      || settings->struct_size < sizeof(DetroitDlssModeSettings)
      || settings->abi_version != DETROIT_DLSS_ABI_VERSION
      || mode != DETROIT_DLSS_MODE_DLAA) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  g_mode_queried = true;
  settings->mode = mode;
  settings->output_width = output_width;
  settings->output_height = output_height;
  settings->render_width = output_width;
  settings->render_height = output_height;
  return DETROIT_DLSS_RESULT_SUCCESS;
}

DetroitDlssResultCode DETROIT_DLSS_CALL FakeGetTemporalConstants(
    std::uint64_t command_buffer,
    std::uint32_t descriptor_set_index,
    std::uint32_t binding,
    DetroitDlssTemporalConstantsSnapshot* snapshot) {
  if (command_buffer == 0u
      || descriptor_set_index != DETROIT_DLSS_TAA_DESCRIPTOR_SET
      || binding != DETROIT_DLSS_TAA_CONSTANT_BINDING_52
      || snapshot == nullptr
      || snapshot->struct_size < sizeof(DetroitDlssTemporalConstantsSnapshot)
      || snapshot->abi_version != DETROIT_DLSS_ABI_VERSION) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  g_constants_queried = true;
  snapshot->descriptor_set_index = descriptor_set_index;
  snapshot->binding = binding;
  snapshot->command_buffer = command_buffer;
  snapshot->descriptor_set = UINT64_C(0x5001);
  snapshot->pipeline_layout = UINT64_C(0x5002);
  snapshot->buffer = UINT64_C(0x5003);
  if (command_buffer == UINT64_C(0xBAD0F10)) {
    snapshot->descriptor_offset = std::numeric_limits<std::uint64_t>::max() - 31u;
    snapshot->dynamic_offset = 64u;
    snapshot->valid_flags = DETROIT_DLSS_CONSTANTS_DESCRIPTOR_VALID
                            | DETROIT_DLSS_CONSTANTS_DYNAMIC_OFFSET_VALID;
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  snapshot->descriptor_offset = 32u;
  snapshot->dynamic_offset = 64u;
  snapshot->effective_offset = 96u;
  snapshot->descriptor_range = command_buffer == UINT64_C(0xBAD0495) ? 495u : 496u;
  snapshot->descriptor_type = 8u;
  snapshot->valid_flags = DETROIT_DLSS_CONSTANTS_DESCRIPTOR_VALID
                          | DETROIT_DLSS_CONSTANTS_DYNAMIC_OFFSET_VALID
                          | DETROIT_DLSS_CONSTANTS_EFFECTIVE_OFFSET_VALID
                          | DETROIT_DLSS_CONSTANTS_RANGE_VALID;
  snapshot->source_flags = DETROIT_DLSS_CONSTANTS_SOURCE_SHADOW_COPY;
  if (snapshot->descriptor_range < 496u) return DETROIT_DLSS_RESULT_FALLBACK;
  snapshot->bytes_written = 496u;
  snapshot->valid_flags |= DETROIT_DLSS_CONSTANTS_PAYLOAD_VALID;
  snapshot->constants[0] = 0xA5u;
  return DETROIT_DLSS_RESULT_SUCCESS;
}

DetroitDlssResultCode DETROIT_DLSS_CALL FakeGetTemporalSnapshot(
    std::uint64_t command_buffer,
    std::uint32_t descriptor_set_index,
    std::uint64_t expected_descriptor_set,
    std::uint64_t expected_pipeline_layout,
    DetroitDlssTemporalDescriptorSnapshot* snapshot) {
  if (command_buffer == 0u
      || descriptor_set_index != DETROIT_DLSS_TAA_DESCRIPTOR_SET
      || expected_descriptor_set != UINT64_C(0x5001)
      || expected_pipeline_layout != UINT64_C(0x5002)
      || snapshot == nullptr
      || snapshot->struct_size < sizeof(DetroitDlssTemporalDescriptorSnapshot)
      || snapshot->abi_version != DETROIT_DLSS_ABI_VERSION) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  g_snapshot_queried = true;
  snapshot->descriptor_set_index = descriptor_set_index;
  snapshot->image_binding_count = DETROIT_DLSS_TAA_IMAGE_BINDING_COUNT;
  snapshot->command_buffer = command_buffer;
  snapshot->descriptor_set = expected_descriptor_set;
  snapshot->pipeline_layout = expected_pipeline_layout;
  snapshot->compute_pipeline = UINT64_C(0x5004);
  snapshot->required_image_mask = DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK;
  snapshot->present_image_mask = DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK
                                 | DETROIT_DLSS_TAA_OPTIONAL_IMAGE_MASK;
  snapshot->complete_image_mask = DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK;
  snapshot->snapshot_flags = DETROIT_DLSS_SNAPSHOT_COMMON_MANDATORY_MASK
                             | (g_use_targeted_snapshot
                                    ? DETROIT_DLSS_SNAPSHOT_TARGETED_UPDATE_RESOLVED
                                    : DETROIT_DLSS_SNAPSHOT_COMMAND_ACQUISITION_MASK);

  constexpr std::array<std::uint32_t, DETROIT_DLSS_TAA_IMAGE_BINDING_COUNT>
      bindings = {0u, 1u, 2u, 3u, 4u, 5u, 6u, 7u, 9u, 16u, 17u, 18u, 19u};
  for (std::size_t index = 0u; index < bindings.size(); ++index) {
    auto& image = snapshot->images[index];
    image.struct_size = sizeof(DetroitDlssImageBindingSnapshot);
    image.binding = bindings[index];
    image.descriptor_type = bindings[index] < 16u ? 1u : 3u;
    image.descriptor_set = expected_descriptor_set;
    image.resource = {
        .image = UINT64_C(0x6000) + index,
        .image_view = UINT64_C(0x7000) + index,
        .format = 97u,
        .layout = bindings[index] < 16u ? 5u : 1u,
        .width = 3440u,
        .height = 1440u,
    };
    image.image_format = 97u;
    image.image_type = 1u;
    image.view_type = 1u;
    image.aspect_mask = 1u;
    image.level_count = 1u;
    image.layer_count = 1u;
    image.image_mip_levels = 1u;
    image.image_array_layers = 1u;
    image.image_width = 3440u;
    image.image_height = 1440u;
    image.image_depth = 1u;
    image.sample_count = 1u;
    image.valid_flags =
        (DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK & (UINT64_C(1) << bindings[index]))
                != 0u
            ? DETROIT_DLSS_IMAGE_MANDATORY_MASK
            : DETROIT_DLSS_IMAGE_MANDATORY_MASK
                  & ~DETROIT_DLSS_IMAGE_DESCRIPTOR_LAYOUT_VALID;
    image.source_flags = DETROIT_DLSS_DESCRIPTOR_SOURCE_DIRECT_WRITE;
    image.update_serial = index + 1u;
  }

  snapshot->constants = {
      .struct_size = sizeof(DetroitDlssTemporalConstantsSnapshot),
      .abi_version = DETROIT_DLSS_ABI_VERSION,
  };
  if (FakeGetTemporalConstants(
          command_buffer,
          descriptor_set_index,
          DETROIT_DLSS_TAA_CONSTANT_BINDING_52,
          &snapshot->constants)
      != DETROIT_DLSS_RESULT_SUCCESS) {
    return DETROIT_DLSS_RESULT_FALLBACK;
  }
  snapshot->constants_diagnostics.struct_size =
      sizeof(DetroitDlssTemporalConstantsDiagnostics);
  snapshot->constants_diagnostics.required_payload_size = 496u;
  return DETROIT_DLSS_RESULT_SUCCESS;
}

DetroitDlssResultCode DETROIT_DLSS_CALL FakeConfigure(
    const DetroitDlssModeSettings* settings) {
  if (settings == nullptr
      || settings->mode != DETROIT_DLSS_MODE_DLAA
      || settings->render_width != settings->output_width
      || settings->render_height != settings->output_height) {
    return DETROIT_DLSS_RESULT_ERROR;
  }
  g_configured = true;
  return DETROIT_DLSS_RESULT_SUCCESS;
}

DetroitDlssResultCode DETROIT_DLSS_CALL FakeEvaluate(
    const DetroitDlssTemporalFrameInputs* inputs,
    DetroitDlssEvaluateResult* result) {
  if (inputs == nullptr
      || result == nullptr
      || inputs->abi_version != DETROIT_DLSS_ABI_VERSION
      || inputs->shader_crc != DETROIT_DLSS_TEMPORAL_AA_SHADER_CRC) {
    return DETROIT_DLSS_RESULT_ERROR;
  }
  g_evaluated = true;
  result->status = DETROIT_DLSS_RESULT_SUCCESS;
  result->frame_id = inputs->frame_id;
  result->flags = DETROIT_DLSS_EVALUATE_OUTPUT_VALID;
  return DETROIT_DLSS_RESULT_SUCCESS;
}

void DETROIT_DLSS_CALL FakeShutdown() {
  g_shutdown = true;
}

bool TestFixedValuesAndBindings() {
  bool passed = true;
  passed &= Expect(DETROIT_DLSS_ABI_VERSION == 3u, "ABI version must be v3");
  passed &= Expect(DETROIT_DLSS_MODE_NATIVE == 0u, "Native mode value changed");
  passed &= Expect(DETROIT_DLSS_MODE_DLAA == 1u, "DLAA mode value changed");
  passed &= Expect(DETROIT_DLSS_MODE_QUALITY == 2u, "Quality mode value changed");
  passed &= Expect(DETROIT_DLSS_MODE_BALANCED == 3u, "Balanced mode value changed");
  passed &= Expect(DETROIT_DLSS_MODE_PERFORMANCE == 4u, "Performance mode value changed");
  passed &= Expect(DETROIT_DLSS_RESULT_SUCCESS == 0u, "Success result value changed");
  passed &= Expect(DETROIT_DLSS_RESULT_FALLBACK == 1u, "Fallback result value changed");
  passed &= Expect(DETROIT_DLSS_RESULT_ERROR == 2u, "Error result value changed");
  passed &= Expect(
      DETROIT_DLSS_CREATE_KNOWN_MASK == UINT32_C(0x1F),
      "known NGX create flag mask changed");
  passed &= Expect(
      DETROIT_DLSS_VERIFY_MANDATORY_MASK == UINT64_C(0x7FF),
      "mandatory per-frame verification mask changed");
  passed &= Expect(
      DETROIT_DLSS_TEMPORAL_CONSTANTS_CAPACITY == 1024u,
      "bounded constants transport capacity changed");
  passed &= Expect(
      DETROIT_DLSS_CONSTANTS_MANDATORY_MASK == UINT64_C(0x1F),
      "constants snapshot validity mask changed");
  passed &= Expect(
      DETROIT_DLSS_TAA_DECLARED_IMAGE_MASK == UINT64_C(0xF00FF),
      "native TAA declared image mask changed");
  passed &= Expect(
      DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK == UINT64_C(0x1001A),
      "DLSS auto-exposure required image mask changed");
  passed &= Expect(
      DETROIT_DLSS_TAA_OPTIONAL_IMAGE_MASK == UINT64_C(0xE02E5),
      "DLSS optional/history image mask changed");
  passed &= Expect(
      (DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK
       | DETROIT_DLSS_TAA_OPTIONAL_IMAGE_MASK)
              == (DETROIT_DLSS_TAA_DECLARED_IMAGE_MASK
                  | (UINT64_C(1) << DETROIT_DLSS_TAA_SAMPLED_BINDING_9))
          && (DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK
              & DETROIT_DLSS_TAA_OPTIONAL_IMAGE_MASK)
                 == 0u,
      "required and optional masks must partition every captured image binding");
  passed &= Expect(
      DETROIT_DLSS_IMAGE_MANDATORY_MASK == UINT64_C(0x7F),
      "native image completeness mask changed");
  passed &= Expect(
      DETROIT_DLSS_SNAPSHOT_COMMON_MANDATORY_MASK == UINT64_C(0x1FC)
          && DETROIT_DLSS_SNAPSHOT_COMMAND_ACQUISITION_MASK == UINT64_C(0x3)
          && DETROIT_DLSS_SNAPSHOT_TARGETED_UPDATE_RESOLVED == UINT64_C(0x200),
      "targeted and legacy snapshot acquisition masks changed");

  constexpr std::array<std::uint32_t, 9u> sampled = {
      DETROIT_DLSS_TAA_SAMPLED_BINDING_0,
      DETROIT_DLSS_TAA_SAMPLED_BINDING_1,
      DETROIT_DLSS_TAA_SAMPLED_BINDING_2,
      DETROIT_DLSS_TAA_SAMPLED_BINDING_3,
      DETROIT_DLSS_TAA_SAMPLED_BINDING_4,
      DETROIT_DLSS_TAA_SAMPLED_BINDING_5,
      DETROIT_DLSS_TAA_SAMPLED_BINDING_6,
      DETROIT_DLSS_TAA_SAMPLED_BINDING_7,
      DETROIT_DLSS_TAA_SAMPLED_BINDING_9,
  };
  constexpr std::array<std::uint32_t, 9u> expected_sampled = {
      0u,
      1u,
      2u,
      3u,
      4u,
      5u,
      6u,
      7u,
      9u,
  };
  constexpr std::array<std::uint32_t, 4u> storage = {
      DETROIT_DLSS_TAA_STORAGE_BINDING_16,
      DETROIT_DLSS_TAA_STORAGE_BINDING_17,
      DETROIT_DLSS_TAA_STORAGE_BINDING_18,
      DETROIT_DLSS_TAA_STORAGE_BINDING_19,
  };
  constexpr std::array<std::uint32_t, 4u> expected_storage = {16u, 17u, 18u, 19u};
  passed &= Expect(sampled == expected_sampled, "sampled binding contract changed, including b9");
  passed &= Expect(storage == expected_storage, "storage binding contract changed");
  passed &= Expect(DETROIT_DLSS_TAA_CONSTANT_BINDING_52 == 52u, "b52 contract changed");
  passed &= Expect(DETROIT_DLSS_TAA_DESCRIPTOR_SET == 0u, "descriptor set contract changed");
  return passed;
}

bool TestSupportedBuildIdentity() {
  bool passed = true;
  passed &= Expect(supported_build::kSteamBuildId == 12'158'144u, "Steam Build ID changed");
  passed &= Expect(
      supported_build::kExecutableSha256Hex
          == "ECF52321921387E683904E089082D76B973326FC093AF14E524056715519C1CF",
      "supported executable SHA-256 changed");
  passed &= Expect(
      supported_build::kTemporalAaShaderCrc == DETROIT_DLSS_TEMPORAL_AA_SHADER_CRC,
      "C and C++ TAA CRC constants diverged");
  passed &= Expect(
      supported_build::MatchesExecutableIdentity(
          supported_build::kExecutableSize,
          supported_build::kExecutableSha256),
      "exact supported executable identity must pass");
  auto wrong_hash = supported_build::kExecutableSha256;
  wrong_hash.back() ^= 0x01u;
  passed &= Expect(
      !supported_build::MatchesExecutableIdentity(
          supported_build::kExecutableSize,
          wrong_hash),
      "one-byte SHA mutation must fail closed");
  passed &= Expect(
      !supported_build::MatchesExecutableIdentity(
          supported_build::kExecutableSize - 1u,
          supported_build::kExecutableSha256),
      "wrong executable size must fail closed");
  return passed;
}

bool TestTemporalResetGate() {
  dlss_bridge_client::TemporalResetGate gate;
  bool passed = true;
  passed &= Expect(
      gate.IsPending() && gate.Apply(0u, false) == 1u,
      "the first DLSS evaluation must reset temporal history");
  gate.RecordSuccess();
  passed &= Expect(
      !gate.IsPending() && gate.Apply(0u, false) == 0u,
      "a stable frame after success must retain DLSS history");
  gate.RequireReset();
  passed &= Expect(
      gate.Apply(0u, false) == 1u,
      "Native selection or fallback must arm the next-frame reset");
  gate.RecordSuccess();
  passed &= Expect(
      gate.Apply(0u, true) == 1u && gate.Apply(1u, false) == 1u,
      "feature recreation and an explicit game reset must remain authoritative");

  DetroitDlssImageBindingSnapshot image = {
      .struct_size = sizeof(DetroitDlssImageBindingSnapshot),
      .binding = DETROIT_DLSS_TAA_SAMPLED_BINDING_0,
      .descriptor_set = UINT64_C(0x5001),
      .valid_flags = UINT64_C(0x3F),
  };
  passed &= Expect(
      dlss_bridge_client::IsTemporalImageSnapshotAccepted(
          DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK,
          UINT64_C(0x5001),
          image),
      "incomplete optional/history descriptor metadata must not block DLSS");
  image.binding = DETROIT_DLSS_TAA_SAMPLED_BINDING_1;
  passed &= Expect(
      !dlss_bridge_client::IsTemporalImageSnapshotAccepted(
          DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK,
          UINT64_C(0x5001),
          image),
      "the same incomplete metadata must reject a required DLSS input");
  image.valid_flags = DETROIT_DLSS_IMAGE_MANDATORY_MASK;
  image.resource.image = UINT64_C(0x6001);
  image.resource.image_view = UINT64_C(0x7001);
  passed &= Expect(
      dlss_bridge_client::IsTemporalImageSnapshotAccepted(
          DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK,
          UINT64_C(0x5001),
          image),
      "a complete required DLSS input must pass snapshot validation");

  return passed;
}

bool TestModeSettingsCachePolicy() {
  const DetroitDlssModeSettings dlaa = {
      .struct_size = sizeof(DetroitDlssModeSettings),
      .abi_version = DETROIT_DLSS_ABI_VERSION,
      .mode = DETROIT_DLSS_MODE_DLAA,
      .output_width = 3440u,
      .output_height = 1440u,
      .render_width = 3440u,
      .render_height = 1440u,
      .min_render_width = 3440u,
      .min_render_height = 1440u,
      .max_render_width = 3440u,
      .max_render_height = 1440u,
  };

  bool passed = true;
  passed &= Expect(
      dlss_bridge_client::IsModeSettingsCacheReusable(
          dlaa, DETROIT_DLSS_MODE_DLAA, 3440u, 1440u),
      "stable DLAA mode/output settings must bypass a repeated NGX query");
  passed &= Expect(
      !dlss_bridge_client::IsModeSettingsCacheReusable(
          dlaa, DETROIT_DLSS_MODE_QUALITY, 3440u, 1440u),
      "a quality-mode transition must invalidate cached NGX settings");
  passed &= Expect(
      !dlss_bridge_client::IsModeSettingsCacheReusable(
          dlaa, DETROIT_DLSS_MODE_DLAA, 2560u, 1440u),
      "an output-extent transition must invalidate cached NGX settings");

  auto invalid = dlaa;
  invalid.max_render_width = 0u;
  passed &= Expect(
      !dlss_bridge_client::IsModeSettingsCacheReusable(
          invalid, DETROIT_DLSS_MODE_DLAA, 3440u, 1440u),
      "an incomplete NGX settings response must never enter the hot-path cache");
  return passed;
}

bool TestFunctionTableContract() {
  bool passed = true;
  DetroitDlssApiV2 api = {
      .struct_size = sizeof(DetroitDlssApiV2),
      .abi_version = DETROIT_DLSS_ABI_VERSION,
      .get_context = &FakeGetContext,
      .get_temporal_constants = &FakeGetTemporalConstants,
      .get_temporal_snapshot = &FakeGetTemporalSnapshot,
      .query_mode = &FakeQueryMode,
      .configure = &FakeConfigure,
      .evaluate = &FakeEvaluate,
      .shutdown = &FakeShutdown,
  };

  DetroitDlssBootstrapContext context = {};
  context.struct_size = sizeof(DetroitDlssBootstrapContext);
  context.abi_version = DETROIT_DLSS_ABI_VERSION;
  passed &= Expect(
      api.get_context(&context) == DETROIT_DLSS_RESULT_SUCCESS,
      "get_context v2 call failed");
  passed &= Expect(
      context.vk_instance == UINT64_C(0x1111111111111111)
          && context.vk_device == UINT64_C(0x3333333333333333),
      "opaque 64-bit Vulkan handles did not round-trip");

  DetroitDlssTemporalConstantsSnapshot snapshot = {};
  snapshot.struct_size = sizeof(DetroitDlssTemporalConstantsSnapshot);
  snapshot.abi_version = DETROIT_DLSS_ABI_VERSION;
  passed &= Expect(
      api.get_temporal_constants(
          UINT64_C(0xABCDEF),
          DETROIT_DLSS_TAA_DESCRIPTOR_SET,
          DETROIT_DLSS_TAA_CONSTANT_BINDING_52,
          &snapshot)
          == DETROIT_DLSS_RESULT_SUCCESS,
      "get_temporal_constants v2 call failed");
  passed &= Expect(
      snapshot.effective_offset
              == snapshot.descriptor_offset + snapshot.dynamic_offset
          && snapshot.descriptor_range == 496u
          && snapshot.bytes_written == 496u
          && snapshot.bytes_written <= DETROIT_DLSS_TEMPORAL_CONSTANTS_CAPACITY
          && (snapshot.valid_flags & DETROIT_DLSS_CONSTANTS_MANDATORY_MASK)
                 == DETROIT_DLSS_CONSTANTS_MANDATORY_MASK
          && snapshot.source_flags == DETROIT_DLSS_CONSTANTS_SOURCE_SHADOW_COPY
          && snapshot.constants[0] == 0xA5u,
      "bounded b52 snapshot did not preserve offsets and payload size");

  DetroitDlssTemporalConstantsSnapshot short_snapshot = {};
  short_snapshot.struct_size = sizeof(DetroitDlssTemporalConstantsSnapshot);
  short_snapshot.abi_version = DETROIT_DLSS_ABI_VERSION;
  passed &= Expect(
      api.get_temporal_constants(
          UINT64_C(0xBAD0495),
          DETROIT_DLSS_TAA_DESCRIPTOR_SET,
          DETROIT_DLSS_TAA_CONSTANT_BINDING_52,
          &short_snapshot)
              == DETROIT_DLSS_RESULT_FALLBACK
          && short_snapshot.descriptor_range == 495u
          && short_snapshot.bytes_written == 0u
          && (short_snapshot.valid_flags & DETROIT_DLSS_CONSTANTS_PAYLOAD_VALID) == 0u,
      "495-byte b52 range must fail closed without copying a payload");

  DetroitDlssTemporalConstantsSnapshot overflow_snapshot = {};
  overflow_snapshot.struct_size = sizeof(DetroitDlssTemporalConstantsSnapshot);
  overflow_snapshot.abi_version = DETROIT_DLSS_ABI_VERSION;
  passed &= Expect(
      api.get_temporal_constants(
          UINT64_C(0xBAD0F10),
          DETROIT_DLSS_TAA_DESCRIPTOR_SET,
          DETROIT_DLSS_TAA_CONSTANT_BINDING_52,
          &overflow_snapshot)
              == DETROIT_DLSS_RESULT_FALLBACK
          && overflow_snapshot.descriptor_offset
                 > std::numeric_limits<std::uint64_t>::max()
                       - overflow_snapshot.dynamic_offset
          && (overflow_snapshot.valid_flags
              & DETROIT_DLSS_CONSTANTS_EFFECTIVE_OFFSET_VALID)
                 == 0u,
      "overflowing b52 descriptor plus dynamic offset must fail closed");

  DetroitDlssTemporalDescriptorSnapshot temporal_snapshot = {};
  temporal_snapshot.struct_size = sizeof(DetroitDlssTemporalDescriptorSnapshot);
  temporal_snapshot.abi_version = DETROIT_DLSS_ABI_VERSION;
  passed &= Expect(
      api.get_temporal_snapshot(
          UINT64_C(0xABCDEF),
          DETROIT_DLSS_TAA_DESCRIPTOR_SET,
          UINT64_C(0x5001),
          UINT64_C(0x5002),
          &temporal_snapshot)
          == DETROIT_DLSS_RESULT_SUCCESS,
      "get_temporal_snapshot v2 call failed");
  passed &= Expect(
      temporal_snapshot.image_binding_count == DETROIT_DLSS_TAA_IMAGE_BINDING_COUNT
          && temporal_snapshot.required_image_mask == DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK
          && (temporal_snapshot.complete_image_mask
              & temporal_snapshot.required_image_mask)
                 == temporal_snapshot.required_image_mask
          && (temporal_snapshot.complete_image_mask
              & DETROIT_DLSS_TAA_OPTIONAL_IMAGE_MASK)
                 == 0u
          && (temporal_snapshot.snapshot_flags
              & DETROIT_DLSS_SNAPSHOT_COMMON_MANDATORY_MASK)
                 == DETROIT_DLSS_SNAPSHOT_COMMON_MANDATORY_MASK
          && (temporal_snapshot.snapshot_flags
              & DETROIT_DLSS_SNAPSHOT_COMMAND_ACQUISITION_MASK)
                 == DETROIT_DLSS_SNAPSHOT_COMMAND_ACQUISITION_MASK
          && temporal_snapshot.images[0].valid_flags == UINT64_C(0x3F)
          && temporal_snapshot.images[8].binding == 9u
          && temporal_snapshot.images[9].binding == 16u
          && temporal_snapshot.constants.bytes_written == 496u,
      "atomic temporal snapshot did not preserve binding order, masks and b52");

  DetroitDlssTemporalDescriptorSnapshot mismatched_snapshot = {};
  mismatched_snapshot.struct_size = sizeof(DetroitDlssTemporalDescriptorSnapshot);
  mismatched_snapshot.abi_version = DETROIT_DLSS_ABI_VERSION;
  passed &= Expect(
      api.get_temporal_snapshot(
          UINT64_C(0xABCDEF),
          DETROIT_DLSS_TAA_DESCRIPTOR_SET,
          UINT64_C(0xDEAD),
          UINT64_C(0x5002),
          &mismatched_snapshot)
          == DETROIT_DLSS_RESULT_FALLBACK,
      "native/ReShade descriptor-set mismatch must fail closed");

  DetroitDlssModeSettings settings = {};
  settings.struct_size = sizeof(DetroitDlssModeSettings);
  settings.abi_version = DETROIT_DLSS_ABI_VERSION;
  passed &= Expect(
      api.query_mode(DETROIT_DLSS_MODE_DLAA, 3440u, 1440u, &settings)
          == DETROIT_DLSS_RESULT_SUCCESS,
      "query_mode v2 call failed");
  passed &= Expect(
      api.configure(&settings) == DETROIT_DLSS_RESULT_SUCCESS,
      "configure v2 call failed");

  DetroitDlssTemporalFrameInputs inputs = {};
  inputs.struct_size = sizeof(DetroitDlssTemporalFrameInputs);
  inputs.abi_version = DETROIT_DLSS_ABI_VERSION;
  inputs.shader_crc = DETROIT_DLSS_TEMPORAL_AA_SHADER_CRC;
  inputs.frame_id = UINT64_C(0xFEDCBA9876543210);
  DetroitDlssEvaluateResult result = {};
  result.struct_size = sizeof(DetroitDlssEvaluateResult);
  result.abi_version = DETROIT_DLSS_ABI_VERSION;
  passed &= Expect(
      api.evaluate(&inputs, &result) == DETROIT_DLSS_RESULT_SUCCESS,
      "evaluate v2 call failed");
  passed &= Expect(
      result.frame_id == inputs.frame_id
          && result.status == DETROIT_DLSS_RESULT_SUCCESS
          && result.flags == DETROIT_DLSS_EVALUATE_OUTPUT_VALID,
      "evaluate result did not preserve the v2 frame contract");
  api.shutdown();

  passed &= Expect(
      g_context_queried
          && g_constants_queried
          && g_snapshot_queried
          && g_mode_queried
          && g_configured
          && g_evaluated
          && g_shutdown,
      "one or more v2 function-table callbacks were not invoked");

  DetroitDlssBootstrapContext short_context = {};
  short_context.struct_size = sizeof(DetroitDlssBootstrapContext) - 1u;
  short_context.abi_version = DETROIT_DLSS_ABI_VERSION;
  passed &= Expect(
      api.get_context(&short_context) == DETROIT_DLSS_RESULT_FALLBACK,
      "short context must fail closed");
  DetroitDlssBootstrapContext wrong_version = {};
  wrong_version.struct_size = sizeof(DetroitDlssBootstrapContext);
  wrong_version.abi_version = DETROIT_DLSS_ABI_VERSION + 1u;
  passed &= Expect(
      api.get_context(&wrong_version) == DETROIT_DLSS_RESULT_FALLBACK,
      "unknown ABI version must fail closed");
  return passed;
}

DetroitDlssResultCode DETROIT_DLSS_CALL FakeGetApi(
    std::uint32_t requested_version,
    DetroitDlssApiV2* api) {
  if (requested_version != DETROIT_DLSS_ABI_VERSION || api == nullptr
      || api->struct_size < sizeof(DetroitDlssApiV2)) {
    return DETROIT_DLSS_RESULT_ERROR;
  }
  const auto struct_size = api->struct_size;
  *api = {
      .struct_size = struct_size,
      .abi_version = DETROIT_DLSS_ABI_VERSION,
      .get_context = &FakeGetContext,
      .get_temporal_constants = &FakeGetTemporalConstants,
      .get_temporal_snapshot = &FakeGetTemporalSnapshot,
      .query_mode = &FakeQueryMode,
      .configure = &FakeConfigure,
      .evaluate = &FakeEvaluate,
      .shutdown = &FakeShutdown,
  };
  return DETROIT_DLSS_RESULT_SUCCESS;
}

bool TestDirectProviderContract() {
  dlss_bridge_client::Client client;
  DetroitDlssModeSettings settings = {};
  bool passed = Expect(
      !client.QueryModeSettings(DETROIT_DLSS_MODE_DLAA, 3440u, 1440u, &settings),
      "client without an in-process provider must fail closed");
  client.SetApiProvider(&FakeGetApi);
  passed &= Expect(
      client.QueryModeSettings(DETROIT_DLSS_MODE_DLAA, 3440u, 1440u, &settings)
          && settings.render_width == 3440u && settings.render_height == 1440u,
      "direct in-process bridge provider did not return DLAA settings");
  DetroitDlssTemporalDescriptorSnapshot snapshot = {};
  passed &= Expect(
      client.CaptureTemporalSnapshot(
          UINT64_C(0xABCDEF), UINT64_C(0x5001), UINT64_C(0x5002), &snapshot),
      "legacy command-tracked snapshot must remain accepted for Retinal diagnostics");
  g_use_targeted_snapshot = true;
  snapshot = {};
  passed &= Expect(
      client.CaptureTemporalSnapshot(
          UINT64_C(0xABCDEF), UINT64_C(0x5001), UINT64_C(0x5002), &snapshot)
          && (snapshot.snapshot_flags
              & DETROIT_DLSS_SNAPSHOT_TARGETED_UPDATE_RESOLVED)
                 != 0u,
      "targeted descriptor-update snapshot must be accepted without command binds");
  g_use_targeted_snapshot = false;
  client.SetApiProvider(nullptr);
  passed &= Expect(
      !client.QueryModeSettings(DETROIT_DLSS_MODE_DLAA, 3440u, 1440u, &settings),
      "removing the direct provider must restore native fallback");
  return passed;
}

bool TestTemporalModeGenerationInvalidatesAuxiliaryAuthorization() {
  temporal_mode_state::Tracker tracker;
  constexpr std::uint64_t kCommandList = UINT64_C(0x12345678);

  bool passed = true;
  const auto enter_dlaa = tracker.SetMode(DETROIT_DLSS_MODE_DLAA);
  const auto first_dlaa = tracker.GetSnapshot();
  passed &= Expect(
      enter_dlaa.changed && first_dlaa.mode == DETROIT_DLSS_MODE_DLAA,
      "entering DLAA must start a distinct temporal-mode generation");
  passed &= Expect(
      tracker.Record(kCommandList, first_dlaa, true)
          && tracker.QueryAuthorization(kCommandList).authorized,
      "a valid current-generation DLAA output must authorize its command list");

  const auto enter_native = tracker.SetMode(DETROIT_DLSS_MODE_NATIVE);
  passed &= Expect(
      enter_native.changed
          && !tracker.QueryAuthorization(kCommandList).authorized,
      "switching to native TAA must revoke all DLAA command-list authorization");

  const auto reenter_dlaa = tracker.SetMode(DETROIT_DLSS_MODE_DLAA);
  const auto second_dlaa = tracker.GetSnapshot();
  passed &= Expect(
      reenter_dlaa.changed
          && second_dlaa.generation != first_dlaa.generation
          && !tracker.QueryAuthorization(kCommandList).authorized,
      "a later DLAA session must warm up independently");
  passed &= Expect(
      !tracker.Record(kCommandList, first_dlaa, true)
          && !tracker.QueryAuthorization(kCommandList).authorized,
      "a late output from an older temporal-mode generation must fail closed");
  passed &= Expect(
      tracker.Record(kCommandList, second_dlaa, true)
          && tracker.QueryAuthorization(kCommandList).authorized,
      "the current DLAA generation must become authorized after a valid output");

  const auto same_mode = tracker.SetMode(DETROIT_DLSS_MODE_DLAA);
  passed &= Expect(
      !same_mode.changed && tracker.QueryAuthorization(kCommandList).authorized,
      "per-frame same-mode refresh must preserve current authorization");
  passed &= Expect(
      !tracker.Record(kCommandList, second_dlaa, false)
          && !tracker.QueryAuthorization(kCommandList).authorized,
      "a current-generation fallback must revoke authorization");
  return passed;
}

bool TestTemporalModeTransactionSerializesCommit() {
  temporal_mode_state::Tracker tracker;
  constexpr std::uint64_t kCommandList = UINT64_C(0xCAFEBABE);
  (void)tracker.SetMode(DETROIT_DLSS_MODE_DLAA);

  std::atomic_bool attempting_transition = false;
  std::atomic_bool transition_completed = false;
  std::thread transition;
  bool passed = true;
  {
    auto transaction = tracker.BeginTransaction();
    transition = std::thread([&] {
      attempting_transition.store(true, std::memory_order_release);
      (void)tracker.SetMode(DETROIT_DLSS_MODE_NATIVE);
      transition_completed.store(true, std::memory_order_release);
    });
    while (!attempting_transition.load(std::memory_order_acquire)) {
      std::this_thread::yield();
    }
    std::this_thread::sleep_for(std::chrono::milliseconds(10));
    passed &= Expect(
        !transition_completed.load(std::memory_order_acquire),
        "mode transition must wait while temporal output commit owns its lease");
    passed &= Expect(
        transaction.GetSnapshot().mode == DETROIT_DLSS_MODE_DLAA
            && transaction.Record(kCommandList, true),
        "leased generation must authorize output without a fallible recheck");
  }
  transition.join();
  passed &= Expect(
      transition_completed.load(std::memory_order_acquire)
          && tracker.GetMode() == DETROIT_DLSS_MODE_NATIVE
          && !tracker.QueryAuthorization(kCommandList).authorized,
      "blocked mode transition must complete and revoke authorization after commit");
  return passed;
}

bool TestBoundedEvaluationTraceWindow() {
  dlss_evaluation_trace::FirstThreeAttemptWindow window;
  const auto first = window.Begin();
  const auto second = window.Begin();
  const auto third = window.Begin();
  const auto fourth = window.Begin();
  const auto fifth = window.Begin();

  bool passed = true;
  passed &= Expect(
      first == 1u && second == 2u && third == 3u,
      "bounded observability must assign exactly attempts one through three");
  passed &= Expect(
      !fourth.has_value() && !fifth.has_value() && window.Count() == 3u,
      "bounded observability must remain saturated after the third attempt");

  constexpr std::array terminals = {
      dlss_evaluation_trace::EvaluationTerminal::kNgxInitializationFailed,
      dlss_evaluation_trace::EvaluationTerminal::kFeatureCreationPending,
      dlss_evaluation_trace::EvaluationTerminal::kFeatureCreationFailed,
      dlss_evaluation_trace::EvaluationTerminal::kResourceRejected,
      dlss_evaluation_trace::EvaluationTerminal::kPrepareFailed,
      dlss_evaluation_trace::EvaluationTerminal::kEvaluateFailed,
      dlss_evaluation_trace::EvaluationTerminal::kCommitFailed,
      dlss_evaluation_trace::EvaluationTerminal::kSuccess,
  };
  for (const auto terminal : terminals) {
    const auto name = dlss_evaluation_trace::EvaluationTerminalName(terminal);
    passed &= Expect(
        !name.empty() && name != "invalid_terminal"
            && name != "unclassified_terminal",
        "every bounded evaluation path must have an explicit terminal class");
  }
  return passed;
}

}  // namespace

int main() {
  bool passed = true;
  passed &= TestFixedValuesAndBindings();
  passed &= TestSupportedBuildIdentity();
  passed &= TestTemporalResetGate();
  passed &= TestModeSettingsCachePolicy();
  passed &= TestFunctionTableContract();
  passed &= TestDirectProviderContract();
  passed &= TestTemporalModeGenerationInvalidatesAuxiliaryAuthorization();
  passed &= TestTemporalModeTransactionSerializesCommit();
  passed &= TestBoundedEvaluationTraceWindow();
  std::cerr << (passed ? "PASS\n" : "FAIL\n");
  return passed ? 0 : 1;
}
