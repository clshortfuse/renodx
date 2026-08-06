/*
 * SPDX-License-Identifier: MIT
 */

#include <array>
#include <cstddef>
#include <cstdint>
#include <iostream>
#include <limits>
#include <string_view>
#include <type_traits>

#include "src/games/detroitbecomehuman/dlss_bridge_abi.h"
#include "src/games/detroitbecomehuman/dlss_bridge_client.hpp"
#include "src/games/detroitbecomehuman/supported_build.hpp"

namespace {

namespace supported_build = renodx::games::detroitbecomehuman::supported_build;
namespace dlss_bridge_client =
    renodx::games::detroitbecomehuman::dlss_bridge_client;

static_assert(std::is_standard_layout_v<DetroitDlssBootstrapContext>);
static_assert(std::is_trivially_copyable_v<DetroitDlssBootstrapContext>);
static_assert(std::is_standard_layout_v<DetroitDlssResource>);
static_assert(std::is_trivially_copyable_v<DetroitDlssResource>);
static_assert(std::is_standard_layout_v<DetroitDlssTemporalConstantsSnapshot>);
static_assert(std::is_trivially_copyable_v<DetroitDlssTemporalConstantsSnapshot>);
static_assert(std::is_standard_layout_v<DetroitDlssImageBindingSnapshot>);
static_assert(std::is_trivially_copyable_v<DetroitDlssImageBindingSnapshot>);
static_assert(std::is_standard_layout_v<DetroitGtaoNormalSnapshot>);
static_assert(std::is_trivially_copyable_v<DetroitGtaoNormalSnapshot>);
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

static_assert(sizeof(DetroitGtaoNormalSnapshot) == 200u);
static_assert(alignof(DetroitGtaoNormalSnapshot) == 8u);
static_assert(offsetof(DetroitGtaoNormalSnapshot, command_buffer) == 8u);
static_assert(offsetof(DetroitGtaoNormalSnapshot, descriptor_set) == 16u);
static_assert(offsetof(DetroitGtaoNormalSnapshot, pipeline_layout) == 24u);
static_assert(offsetof(DetroitGtaoNormalSnapshot, capture_serial) == 32u);
static_assert(offsetof(DetroitGtaoNormalSnapshot, normal) == 40u);

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

static_assert(sizeof(DetroitDlssTemporalFrameInputs) == 376u);
static_assert(alignof(DetroitDlssTemporalFrameInputs) == 8u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, shader_crc) == 8u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, command_buffer) == 16u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, constants_buffer) == 40u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, constants_size) == 56u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, current_color) == 64u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, depth) == 112u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, motion_vectors) == 160u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, exposure) == 208u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, output) == 256u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, render_width) == 304u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, jitter_x) == 320u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, frame_id) == 344u);
static_assert(offsetof(DetroitDlssTemporalFrameInputs, verification_flags) == 360u);

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
  context->capability_flags = DETROIT_DLSS_CAPABILITY_SUPER_RESOLUTION
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
  snapshot->snapshot_flags = DETROIT_DLSS_SNAPSHOT_MANDATORY_MASK;

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
  passed &= Expect(DETROIT_DLSS_ABI_VERSION == 2u, "ABI version must be v2");
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
      DETROIT_DLSS_SNAPSHOT_MANDATORY_MASK == UINT64_C(0x1FF),
      "atomic snapshot completeness mask changed");

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
  passed &= Expect(
      DETROIT_GTAO_NORMAL_BINDING == 1u,
      "native SSR normal binding changed");
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

  DetroitGtaoNormalSnapshot normal_snapshot = {
      .struct_size = sizeof(DetroitGtaoNormalSnapshot),
      .abi_version = DETROIT_DLSS_ABI_VERSION,
      .command_buffer = UINT64_C(0xABCDEF),
      .descriptor_set = UINT64_C(0x8001),
      .pipeline_layout = UINT64_C(0x8002),
      .capture_serial = 7u,
      .normal = {
          .struct_size = sizeof(DetroitDlssImageBindingSnapshot),
          .binding = DETROIT_GTAO_NORMAL_BINDING,
          .descriptor_set = UINT64_C(0x8001),
          .resource = {
              .image = UINT64_C(0x9001),
              .image_view = UINT64_C(0x9002),
              .format = dlss_bridge_client::kVkFormatR32Uint,
              .width = 3440u,
              .height = 1440u,
          },
          .image_type = dlss_bridge_client::kVkImageType2D,
          .view_type = dlss_bridge_client::kVkImageViewType2D,
          .sample_count = dlss_bridge_client::kVkSampleCount1,
          .valid_flags = DETROIT_DLSS_IMAGE_MANDATORY_MASK,
      },
  };
  passed &= Expect(
      dlss_bridge_client::IsGtaoNormalSnapshotAccepted(
          UINT64_C(0xABCDEF), 3440u, 1440u, normal_snapshot),
      "a complete R32_UINT native normal snapshot must pass validation");
  normal_snapshot.normal.resource.format = 97u;
  passed &= Expect(
      !dlss_bridge_client::IsGtaoNormalSnapshotAccepted(
          UINT64_C(0xABCDEF), 3440u, 1440u, normal_snapshot),
      "a non-R32_UINT resource must not be accepted as Detroit normals");
  normal_snapshot.normal.resource.format = dlss_bridge_client::kVkFormatR32Uint;
  normal_snapshot.normal.resource.width = 2560u;
  passed &= Expect(
      !dlss_bridge_client::IsGtaoNormalSnapshotAccepted(
          UINT64_C(0xABCDEF), 3440u, 1440u, normal_snapshot),
      "a mismatched normal extent must fail closed");
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
              & DETROIT_DLSS_SNAPSHOT_MANDATORY_MASK)
                 == DETROIT_DLSS_SNAPSHOT_MANDATORY_MASK
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

}  // namespace

int main() {
  bool passed = true;
  passed &= TestFixedValuesAndBindings();
  passed &= TestSupportedBuildIdentity();
  passed &= TestTemporalResetGate();
  passed &= TestFunctionTableContract();
  std::cerr << (passed ? "PASS\n" : "FAIL\n");
  return passed ? 0 : 1;
}
