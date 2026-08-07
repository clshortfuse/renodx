/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <mutex>

#include <Windows.h>

#include "dlss_bridge_abi.h"
#include "dlss_policy.hpp"

namespace renodx::games::detroitbecomehuman::dlss_bridge_client {

inline constexpr wchar_t kBridgeModuleName[] = L"renodx-detroit-dlss-layer.dll";
inline constexpr char kGetApiExportName[] = "DetroitDlssGetApi";

struct Evaluation {
  DetroitDlssResultCode status = DETROIT_DLSS_RESULT_FALLBACK;
  std::uint32_t bridge_detail = 0u;
  dlss_policy::FallbackReason reason = dlss_policy::FallbackReason::kBridgeUnavailable;
  bool output_valid = false;
  bool suppress_final_cas = false;
};

// The bridge is temporal even when the native TAA fallback remains visible.
// Any interruption requires the first subsequently accepted DLSS frame to
// discard history. Client's mutex serializes this deliberately small state.
class TemporalResetGate {
 public:
  constexpr void RequireReset() noexcept { pending_ = true; }

  [[nodiscard]] constexpr std::uint32_t Apply(
      std::uint32_t requested_reset,
      bool feature_reconfigured) const noexcept {
    return requested_reset != 0u || feature_reconfigured || pending_ ? 1u : 0u;
  }

  constexpr void RecordSuccess() noexcept { pending_ = false; }

  [[nodiscard]] constexpr bool IsPending() const noexcept { return pending_; }

 private:
  bool pending_ = true;
};

[[nodiscard]] constexpr bool IsTemporalImageSnapshotAccepted(
    std::uint64_t required_image_mask,
    std::uint64_t descriptor_set,
    const DetroitDlssImageBindingSnapshot& image) noexcept {
  if (image.binding >= 64u
      || (required_image_mask & (UINT64_C(1) << image.binding)) == 0u) {
    return image.binding < 64u;
  }
  return (image.valid_flags & DETROIT_DLSS_IMAGE_MANDATORY_MASK)
             == DETROIT_DLSS_IMAGE_MANDATORY_MASK
         && image.descriptor_set == descriptor_set
         && image.resource.image != 0u
         && image.resource.image_view != 0u;
}

// NGX optimal settings depend on the selected quality mode and output extent,
// not on per-frame jitter/history values. Re-running the vendor callback for
// every temporal dispatch adds avoidable CPU/driver work on the render thread.
// A context identity change clears configured_settings_, so a reusable entry is
// always tied to the same live Vulkan device and NGX capability context.
[[nodiscard]] constexpr bool IsModeSettingsCacheReusable(
    const DetroitDlssModeSettings& settings,
    DetroitDlssMode mode,
    std::uint32_t output_width,
    std::uint32_t output_height) noexcept {
  return settings.struct_size >= sizeof(DetroitDlssModeSettings)
         && settings.abi_version == DETROIT_DLSS_ABI_VERSION
         && settings.mode == mode && settings.output_width == output_width
         && settings.output_height == output_height && settings.render_width != 0u
         && settings.render_height != 0u && settings.min_render_width != 0u
         && settings.min_render_height != 0u && settings.max_render_width != 0u
         && settings.max_render_height != 0u;
}

class Client {
 public:
  // Release an existing NGX feature as soon as the UI selects Native. A later
  // Native TAA dispatch repeats the transition with live dimensions if this
  // immediate path could not reach the bridge.
  [[nodiscard]] bool TransitionToNative() {
    std::scoped_lock lock(mutex_);
    reset_gate_.RequireReset();
    if (!Connect() || !RefreshContext()) return false;
    return ConfigureNativeLocked(
        configured_settings_.output_width,
        configured_settings_.output_height);
  }

  [[nodiscard]] bool QueryModeSettings(
      DetroitDlssMode mode,
      std::uint32_t output_width,
      std::uint32_t output_height,
      DetroitDlssModeSettings* settings) {
    if (settings == nullptr || output_width == 0u || output_height == 0u
        || mode > DETROIT_DLSS_MODE_PERFORMANCE) {
      return false;
    }
    std::scoped_lock lock(mutex_);
    if (!Connect() || !RefreshContext()) return false;
    const auto availability =
        dlss_policy::CheckModeAvailability(mode, GetRuntimeSupport());
    if (!availability.available) return false;

    DetroitDlssModeSettings candidate = {
        .struct_size = sizeof(DetroitDlssModeSettings),
        .abi_version = DETROIT_DLSS_ABI_VERSION,
        .mode = mode,
    };
    if (api_.query_mode(mode, output_width, output_height, &candidate)
            != DETROIT_DLSS_RESULT_SUCCESS
        || candidate.output_width != output_width
        || candidate.output_height != output_height
        || candidate.render_width == 0u || candidate.render_height == 0u) {
      return false;
    }
    *settings = candidate;
    return true;
  }

  [[nodiscard]] bool CaptureTemporalSnapshot(
      std::uint64_t command_buffer,
      std::uint64_t descriptor_set,
      std::uint64_t pipeline_layout,
      DetroitDlssTemporalDescriptorSnapshot* snapshot) {
    if (snapshot == nullptr || command_buffer == 0u) {
      return false;
    }

    std::scoped_lock lock(mutex_);
    if (!Connect()) return false;

    DetroitDlssTemporalDescriptorSnapshot candidate = {
        .struct_size = sizeof(DetroitDlssTemporalDescriptorSnapshot),
        .abi_version = DETROIT_DLSS_ABI_VERSION,
        .descriptor_set_index = DETROIT_DLSS_TAA_DESCRIPTOR_SET,
        .command_buffer = command_buffer,
    };
    const auto capture_status = api_.get_temporal_snapshot(
        command_buffer,
        DETROIT_DLSS_TAA_DESCRIPTOR_SET,
        descriptor_set,
        pipeline_layout,
        &candidate);
    const bool basic_identity_valid =
        candidate.struct_size >= sizeof(DetroitDlssTemporalDescriptorSnapshot)
        && candidate.abi_version == DETROIT_DLSS_ABI_VERSION
        && candidate.command_buffer == command_buffer
        && candidate.descriptor_set_index == DETROIT_DLSS_TAA_DESCRIPTOR_SET;
    if (basic_identity_valid) *snapshot = candidate;

    if (capture_status != DETROIT_DLSS_RESULT_SUCCESS
        || !basic_identity_valid
        || candidate.image_binding_count != DETROIT_DLSS_TAA_IMAGE_BINDING_COUNT
        || (descriptor_set != 0u && candidate.descriptor_set != descriptor_set)
        || (pipeline_layout != 0u && candidate.pipeline_layout != pipeline_layout)
        || candidate.detail_code != DETROIT_DLSS_SNAPSHOT_DETAIL_NONE
        || candidate.required_image_mask != DETROIT_DLSS_TAA_REQUIRED_IMAGE_MASK
        || (candidate.complete_image_mask & candidate.required_image_mask)
               != candidate.required_image_mask
        || (candidate.snapshot_flags & DETROIT_DLSS_SNAPSHOT_MANDATORY_MASK)
               != DETROIT_DLSS_SNAPSHOT_MANDATORY_MASK
        || (candidate.constants.valid_flags & DETROIT_DLSS_CONSTANTS_MANDATORY_MASK)
               != DETROIT_DLSS_CONSTANTS_MANDATORY_MASK) {
      return false;
    }

    constexpr std::array<std::uint32_t, DETROIT_DLSS_TAA_IMAGE_BINDING_COUNT>
        expected_bindings = {0u, 1u, 2u, 3u, 4u, 5u, 6u, 7u, 9u, 16u, 17u, 18u, 19u};
    for (std::size_t index = 0u; index < expected_bindings.size(); ++index) {
      const auto& image = candidate.images[index];
      if (image.binding != expected_bindings[index]) return false;
      if (!IsTemporalImageSnapshotAccepted(
              candidate.required_image_mask,
              candidate.descriptor_set,
              image)) {
        return false;
      }
    }

    *snapshot = candidate;
    return true;
  }

  [[nodiscard]] bool CaptureTemporalConstants(
      std::uint64_t command_buffer,
      std::uint64_t descriptor_set,
      std::uint64_t pipeline_layout,
      DetroitDlssTemporalConstantsSnapshot* snapshot) {
    if (snapshot == nullptr
        || command_buffer == 0u
        || descriptor_set == 0u
        || pipeline_layout == 0u) {
      return false;
    }

    std::scoped_lock lock(mutex_);
    if (!Connect()) return false;

    DetroitDlssTemporalConstantsSnapshot candidate = {
        .struct_size = sizeof(DetroitDlssTemporalConstantsSnapshot),
        .abi_version = DETROIT_DLSS_ABI_VERSION,
        .descriptor_set_index = DETROIT_DLSS_TAA_DESCRIPTOR_SET,
        .binding = DETROIT_DLSS_TAA_CONSTANT_BINDING_52,
        .command_buffer = command_buffer,
    };
    const auto capture_status = api_.get_temporal_constants(
        command_buffer,
        DETROIT_DLSS_TAA_DESCRIPTOR_SET,
        DETROIT_DLSS_TAA_CONSTANT_BINDING_52,
        &candidate);
    const bool basic_identity_valid =
        candidate.struct_size >= sizeof(DetroitDlssTemporalConstantsSnapshot)
        && candidate.abi_version == DETROIT_DLSS_ABI_VERSION
        && candidate.command_buffer == command_buffer
        && candidate.descriptor_set_index == DETROIT_DLSS_TAA_DESCRIPTOR_SET
        && candidate.binding == DETROIT_DLSS_TAA_CONSTANT_BINDING_52;
    // Preserve fail-stage diagnostics (valid_flags and any resolved handles)
    // even when the layer cannot safely copy the whole 496-byte payload.
    if (basic_identity_valid) *snapshot = candidate;

    if (capture_status != DETROIT_DLSS_RESULT_SUCCESS
        || !basic_identity_valid
        || candidate.abi_version != DETROIT_DLSS_ABI_VERSION
        || candidate.descriptor_set != descriptor_set
        || candidate.pipeline_layout != pipeline_layout
        || candidate.buffer == 0u
        || candidate.bytes_written == 0u
        || candidate.bytes_written > DETROIT_DLSS_TEMPORAL_CONSTANTS_CAPACITY
        || candidate.descriptor_range < candidate.bytes_written
        // Vulkan uniform buffer and uniform buffer dynamic respectively.
        || (candidate.descriptor_type != 6u && candidate.descriptor_type != 8u)
        || (candidate.valid_flags & DETROIT_DLSS_CONSTANTS_MANDATORY_MASK)
               != DETROIT_DLSS_CONSTANTS_MANDATORY_MASK
        || (candidate.source_flags
            & (DETROIT_DLSS_CONSTANTS_SOURCE_MAPPED_MEMORY
               | DETROIT_DLSS_CONSTANTS_SOURCE_SHADOW_COPY))
               == 0u
        || candidate.descriptor_offset
               > std::numeric_limits<std::uint64_t>::max()
                     - candidate.dynamic_offset
        || candidate.effective_offset
               != candidate.descriptor_offset + candidate.dynamic_offset) {
      return false;
    }

    *snapshot = candidate;
    return true;
  }

  [[nodiscard]] Evaluation Evaluate(
      DetroitDlssMode mode,
      const DetroitDlssTemporalFrameInputs& inputs) {
    std::scoped_lock lock(mutex_);

    if (mode == DETROIT_DLSS_MODE_NATIVE) {
      reset_gate_.RequireReset();
      if (!Connect() || !RefreshContext()) {
        return {.reason = dlss_policy::FallbackReason::kNativeMode};
      }
      const std::uint32_t output_width =
          inputs.output_width != 0u ? inputs.output_width
                                    : configured_settings_.output_width;
      const std::uint32_t output_height =
          inputs.output_height != 0u ? inputs.output_height
                                     : configured_settings_.output_height;
      const bool configured_native =
          ConfigureNativeLocked(output_width, output_height);
      return {
          .status = configured_native ? DETROIT_DLSS_RESULT_SUCCESS
                                      : DETROIT_DLSS_RESULT_FALLBACK,
          .reason = dlss_policy::FallbackReason::kNativeMode,
      };
    }

    const auto reject = [this](Evaluation evaluation) {
      reset_gate_.RequireReset();
      return evaluation;
    };

    if (!Connect() || !RefreshContext()) {
      return reject({.reason = dlss_policy::FallbackReason::kBridgeUnavailable});
    }

    const auto support = GetRuntimeSupport();
    const auto availability = dlss_policy::CheckModeAvailability(mode, support);
    if (!availability.available) return reject({.reason = availability.reason});

    DetroitDlssModeSettings settings = configured_settings_;
    if (!configured_
        || !IsModeSettingsCacheReusable(
            settings, mode, inputs.output_width, inputs.output_height)) {
      settings = {
          .struct_size = sizeof(DetroitDlssModeSettings),
          .abi_version = DETROIT_DLSS_ABI_VERSION,
          .mode = mode,
      };
      const auto query_status = api_.query_mode(
          mode, inputs.output_width, inputs.output_height, &settings);
      if (query_status != DETROIT_DLSS_RESULT_SUCCESS) {
        return reject({
            .status = query_status,
            .reason = query_status == DETROIT_DLSS_RESULT_ERROR
                          ? dlss_policy::FallbackReason::kEvaluateError
                          : dlss_policy::FallbackReason::kModeUnsupported,
        });
      }
    }

    const std::uint64_t scaled_width =
        static_cast<std::uint64_t>(inputs.render_width) * inputs.output_height;
    const std::uint64_t scaled_height =
        static_cast<std::uint64_t>(inputs.render_height) * inputs.output_width;
    const std::uint64_t aspect_delta = scaled_width >= scaled_height
                                           ? scaled_width - scaled_height
                                           : scaled_height - scaled_width;
    const bool scalar_aspect_matches =
        aspect_delta <= std::max(scaled_width, scaled_height) / 100u + 1u;
    if (dlss_policy::IsSuperResolutionMode(mode) && scalar_aspect_matches
        && inputs.render_width >= settings.min_render_width
        && inputs.render_height >= settings.min_render_height
        && inputs.render_width <= settings.max_render_width
        && inputs.render_height <= settings.max_render_height) {
      // The game applies a scalar and rounds each axis independently. Accept
      // the actual in-range extent reported by the live resources instead of
      // requiring NGX's recommended dimensions bit-for-bit.
      settings.render_width = inputs.render_width;
      settings.render_height = inputs.render_height;
    }

    const auto eligibility =
        dlss_policy::CheckFrameEligibility(mode, support, settings, inputs);
    if (!eligibility.evaluate_dlss) {
      return reject({.reason = eligibility.reason});
    }

    const bool feature_reconfigured =
        !configured_ || !SettingsEqual(settings, configured_settings_);
    if (feature_reconfigured) {
      const auto configure_status = api_.configure(&settings);
      if (configure_status != DETROIT_DLSS_RESULT_SUCCESS) {
        configured_ = false;
        return reject({
            .status = configure_status,
            .reason = configure_status == DETROIT_DLSS_RESULT_ERROR
                          ? dlss_policy::FallbackReason::kEvaluateError
                          : dlss_policy::FallbackReason::kEvaluateFallback,
        });
      }
      configured_settings_ = settings;
      configured_ = true;
    }

    DetroitDlssTemporalFrameInputs effective_inputs = inputs;
    effective_inputs.reset =
        reset_gate_.Apply(inputs.reset, feature_reconfigured);

    DetroitDlssEvaluateResult result = {
        .struct_size = sizeof(DetroitDlssEvaluateResult),
        .abi_version = DETROIT_DLSS_ABI_VERSION,
        .status = DETROIT_DLSS_RESULT_FALLBACK,
        .frame_id = inputs.frame_id,
    };
    const auto evaluate_status = api_.evaluate(&effective_inputs, &result);
    if (evaluate_status != DETROIT_DLSS_RESULT_SUCCESS) {
      return reject({
          .status = evaluate_status,
          .bridge_detail = result.detail_code,
          .reason = evaluate_status == DETROIT_DLSS_RESULT_ERROR
                        ? dlss_policy::FallbackReason::kEvaluateError
                        : dlss_policy::FallbackReason::kEvaluateFallback,
      });
    }

    const auto outcome =
        dlss_policy::FinalizeFrame(eligibility, result, inputs.frame_id);
    if (!outcome.use_dlss_output) {
      return reject({
          .status = result.status,
          .bridge_detail = result.detail_code,
          .reason = outcome.reason,
      });
    }
    reset_gate_.RecordSuccess();
    return {
        .status = result.status,
        .bridge_detail = result.detail_code,
        .reason = outcome.reason,
        .output_valid = outcome.use_dlss_output,
        .suppress_final_cas = outcome.suppress_final_cas,
    };
  }

 private:
  [[nodiscard]] bool ConfigureNativeLocked(
      std::uint32_t output_width,
      std::uint32_t output_height) {
    if (output_width == 0u || output_height == 0u) return false;
    const DetroitDlssModeSettings settings = {
        .struct_size = sizeof(DetroitDlssModeSettings),
        .abi_version = DETROIT_DLSS_ABI_VERSION,
        .mode = DETROIT_DLSS_MODE_NATIVE,
        .output_width = output_width,
        .output_height = output_height,
        .render_width = output_width,
        .render_height = output_height,
        .min_render_width = output_width,
        .min_render_height = output_height,
        .max_render_width = output_width,
        .max_render_height = output_height,
    };
    if (configured_ && SettingsEqual(settings, configured_settings_)) return true;
    if (api_.configure(&settings) != DETROIT_DLSS_RESULT_SUCCESS) {
      configured_ = false;
      return false;
    }
    configured_settings_ = settings;
    configured_ = true;
    return true;
  }

  [[nodiscard]] bool Connect() {
    if (connected_) return true;

    module_ = GetModuleHandleW(kBridgeModuleName);
    if (module_ == nullptr) return false;

    const auto get_api = reinterpret_cast<DetroitDlssGetApiFn>(
        GetProcAddress(module_, kGetApiExportName));
    if (get_api == nullptr) return false;

    DetroitDlssApiV2 candidate = {
        .struct_size = sizeof(DetroitDlssApiV2),
        .abi_version = DETROIT_DLSS_ABI_VERSION,
    };
    if (get_api(DETROIT_DLSS_ABI_VERSION, &candidate)
            != DETROIT_DLSS_RESULT_SUCCESS
        || candidate.struct_size < sizeof(DetroitDlssApiV2)
        || candidate.abi_version != DETROIT_DLSS_ABI_VERSION
        || candidate.get_context == nullptr
        || candidate.get_temporal_constants == nullptr
        || candidate.get_temporal_snapshot == nullptr
        || candidate.query_mode == nullptr
        || candidate.configure == nullptr
        || candidate.evaluate == nullptr) {
      return false;
    }

    api_ = candidate;
    connected_ = true;
    return true;
  }

  [[nodiscard]] bool RefreshContext() {
    DetroitDlssBootstrapContext candidate = {
        .struct_size = sizeof(DetroitDlssBootstrapContext),
        .abi_version = DETROIT_DLSS_ABI_VERSION,
    };
    if (api_.get_context(&candidate) != DETROIT_DLSS_RESULT_SUCCESS
        || candidate.struct_size < sizeof(DetroitDlssBootstrapContext)
        || candidate.abi_version != DETROIT_DLSS_ABI_VERSION
        || candidate.vk_instance == 0u
        || candidate.vk_physical_device == 0u
        || candidate.vk_device == 0u
        || candidate.vk_graphics_queue == 0u) {
      return false;
    }
    const bool context_identity_changed =
        context_.vk_instance != 0u
        && (context_.vk_instance != candidate.vk_instance
            || context_.vk_physical_device != candidate.vk_physical_device
            || context_.vk_device != candidate.vk_device
            || context_.vk_graphics_queue != candidate.vk_graphics_queue);
    if (context_identity_changed) {
      configured_ = false;
      configured_settings_ = {};
    }
    context_ = candidate;
    return true;
  }

  [[nodiscard]] dlss_policy::RuntimeSupport GetRuntimeSupport() const {
    const auto has_capability = [this](DetroitDlssCapabilityFlags flag) {
      return (context_.capability_flags & flag) == flag;
    };
    return {
        .executable_supported =
            has_capability(DETROIT_DLSS_CAPABILITY_SUPPORTED_EXECUTABLE),
        .bridge_available = connected_,
        .ngx_initialized = context_.vk_device != 0u,
        .temporal_interface_verified =
            has_capability(DETROIT_DLSS_CAPABILITY_TEMPORAL_INPUTS_VERIFIED),
        .dlaa_available = has_capability(DETROIT_DLSS_CAPABILITY_DLAA),
        .super_resolution_available =
            has_capability(DETROIT_DLSS_CAPABILITY_SUPER_RESOLUTION),
        .render_scale_control_available =
            has_capability(DETROIT_DLSS_CAPABILITY_RENDER_SCALE_CONTROL),
        .auto_exposure_available =
            has_capability(DETROIT_DLSS_CAPABILITY_AUTO_EXPOSURE),
        .bridge_abi_version = api_.abi_version,
    };
  }

  [[nodiscard]] static bool SettingsEqual(
      const DetroitDlssModeSettings& left,
      const DetroitDlssModeSettings& right) {
    return left.abi_version == right.abi_version
           && left.mode == right.mode
           && left.create_flags == right.create_flags
           && left.output_width == right.output_width
           && left.output_height == right.output_height
           && left.render_width == right.render_width
           && left.render_height == right.render_height
           && left.min_render_width == right.min_render_width
           && left.min_render_height == right.min_render_height
           && left.max_render_width == right.max_render_width
           && left.max_render_height == right.max_render_height;
  }

  std::mutex mutex_;
  HMODULE module_ = nullptr;
  DetroitDlssApiV2 api_ = {};
  DetroitDlssBootstrapContext context_ = {};
  DetroitDlssModeSettings configured_settings_ = {};
  TemporalResetGate reset_gate_ = {};
  bool connected_ = false;
  bool configured_ = false;
};

inline Client client;

}  // namespace renodx::games::detroitbecomehuman::dlss_bridge_client
