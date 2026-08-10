/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <array>
#include <atomic>
#include <bit>
#include <cmath>
#include <cstdint>
#include <mutex>
#include <string_view>

namespace renodx::games::detroitbecomehuman::render_debug {

enum class OverlayMode : std::uint32_t {
  kOff = 0u,
  kSingle = 1u,
  kDashboard = 2u,
};

enum class DashboardPreset : std::uint32_t {
  kDof = 0u,
  kTemporal,
  kScene,
  kLighting,
  kRetinal,
  kCustom,
  // Appended so saved values for every established dashboard stay stable.
  kDofVanillaTransition,
};

// Keep source values within five bits. These values are mirrored by
// render_debug_common.slang and form the stable CPU/shader contract.
enum class Source : std::uint32_t {
  kNone = 0u,
  kDofCoarseCoc = 1u,
  kDofFullResolutionCoc = 2u,
  kDofNearLayer = 3u,
  kDofFarLayer = 4u,
  kDofGatherFillLayers = 5u,
  kTemporalDepth = 6u,
  kTemporalMotionVectors = 7u,
  kTemporalHistory = 8u,
  kSceneBeforeGrade = 9u,
  kSceneAfterGrade = 10u,
  kSceneLuminance = 11u,
  kGtao = 12u,
  kLightingDiffuse = 13u,
  kLightingSpecular = 14u,
  kRetinalFixation = 15u,
  kRetinalEccentricity = 16u,
  kRetinalNyquist = 17u,
  kRetinalRadius = 18u,
  kDofVanillaTransitionControl = 19u,
  kDofVanillaTransitionContribution = 20u,
};

enum class Channel : std::uint32_t {
  kAuto = 0u,
  kRgb,
  kRed,
  kGreen,
  kBlue,
  kAlpha,
  kLuminance,
  kVector,
};

enum class Mapping : std::uint32_t {
  kAuto = 0u,
  kLinear,
  kSigned,
  kLog2,
};

enum class Decoder : std::uint32_t {
  kColor = 0u,
  kScalar,
  kSignedCoc,
  kDepth,
  kMotionVectors,
  kAlpha,
  kLuminance,
  kUnavailable,
};

enum class ProducerPass : std::uint32_t {
  kNone = 0u,
  kTemporal = 1u << 0u,
  kDofComposite = 1u << 1u,
  kSceneComposite = 1u << 2u,
};

enum class Access : std::uint32_t {
  kDirectBinding = 0u,
  kDerivedInline,
  kUnavailable,
};

enum class RuntimeStatus : std::uint32_t {
  kOff = 0u,
  kWaitingForPasses,
  kActive,
  kActiveWithUnavailableSources,
  kUnsupportedBuild,
};

struct BindingContract {
  std::uint32_t shader_crc = 0u;
  std::uint32_t descriptor_set = 0u;
  std::uint32_t binding = 0u;
};

struct SourceContract {
  Source source = Source::kNone;
  std::string_view label;
  ProducerPass producer = ProducerPass::kNone;
  Access access = Access::kUnavailable;
  Decoder decoder = Decoder::kUnavailable;
  Channel default_channel = Channel::kAuto;
  Mapping default_mapping = Mapping::kAuto;
  float range_min = 0.f;
  float range_max = 1.f;
  BindingContract binding = {};

  [[nodiscard]] constexpr bool IsAvailable() const noexcept {
    return access != Access::kUnavailable;
  }
};

inline constexpr std::uint32_t kTemporalShaderCrc = 0xB5506A45u;
inline constexpr std::uint32_t kDofCompositeShaderCrc = 0xAC7A8193u;
inline constexpr std::uint32_t kSceneCompositeShaderCrc = 0xEBFBDDB1u;
// Inline propagation has no persistent image, so frame freezing is not
// exposed. Bit 28 instead marks temporal sources unavailable while DLSS owns
// b16; this keeps diagnostics from interfering with the DLSS output path.
inline constexpr bool kFreezeFrameSupported = false;

inline constexpr std::array<SourceContract, 21u> kSourceContracts = {{
    {Source::kNone, "Off", ProducerPass::kNone, Access::kUnavailable, Decoder::kUnavailable, Channel::kAuto, Mapping::kAuto, 0.f, 1.f, {}},
    {Source::kDofCoarseCoc, "DOF Coarse CoC", ProducerPass::kDofComposite, Access::kDirectBinding, Decoder::kSignedCoc, Channel::kAuto, Mapping::kSigned, -16.f, 16.f, {kDofCompositeShaderCrc, 0u, 0u}},
    {Source::kDofFullResolutionCoc, "DOF Full-resolution CoC", ProducerPass::kDofComposite, Access::kDerivedInline, Decoder::kSignedCoc, Channel::kAuto, Mapping::kSigned, -16.f, 16.f, {kDofCompositeShaderCrc, 0u, 3u}},
    {Source::kDofNearLayer, "DOF Near Layer", ProducerPass::kDofComposite, Access::kDirectBinding, Decoder::kAlpha, Channel::kAlpha, Mapping::kLinear, 0.f, 1.f, {kDofCompositeShaderCrc, 0u, 4u}},
    {Source::kDofFarLayer, "DOF Gather/Fill Far Layer", ProducerPass::kDofComposite, Access::kDirectBinding, Decoder::kAlpha, Channel::kAlpha, Mapping::kLinear, 0.f, 1.f, {kDofCompositeShaderCrc, 0u, 5u}},
    {Source::kDofGatherFillLayers, "DOF Gather/Fill Near + Far", ProducerPass::kDofComposite, Access::kDerivedInline, Decoder::kAlpha, Channel::kRgb, Mapping::kLinear, 0.f, 1.f, {kDofCompositeShaderCrc, 0u, 4u}},
    {Source::kTemporalDepth, "TAA Linear Depth", ProducerPass::kTemporal, Access::kDirectBinding, Decoder::kDepth, Channel::kRed, Mapping::kLog2, -4.f, 12.f, {kTemporalShaderCrc, 0u, 3u}},
    {Source::kTemporalMotionVectors, "TAA Motion Vectors", ProducerPass::kTemporal, Access::kDirectBinding, Decoder::kMotionVectors, Channel::kVector, Mapping::kSigned, -1.f, 1.f, {kTemporalShaderCrc, 0u, 4u}},
    {Source::kTemporalHistory, "TAA History", ProducerPass::kTemporal, Access::kDirectBinding, Decoder::kColor, Channel::kRgb, Mapping::kLinear, 0.f, 1.f, {kTemporalShaderCrc, 0u, 2u}},
    {Source::kSceneBeforeGrade, "Scene Before Grade", ProducerPass::kSceneComposite, Access::kDirectBinding, Decoder::kColor, Channel::kRgb, Mapping::kLinear, 0.f, 1.f, {kSceneCompositeShaderCrc, 0u, 0u}},
    {Source::kSceneAfterGrade, "Scene After Grade", ProducerPass::kSceneComposite, Access::kDerivedInline, Decoder::kColor, Channel::kRgb, Mapping::kLinear, 0.f, 1.f, {kSceneCompositeShaderCrc, 0u, 16u}},
    {Source::kSceneLuminance, "Scene Luminance", ProducerPass::kSceneComposite, Access::kDerivedInline, Decoder::kLuminance, Channel::kLuminance, Mapping::kLog2, -10.f, 6.f, {kSceneCompositeShaderCrc, 0u, 0u}},
    {Source::kGtao, "GTAO (Unavailable)", ProducerPass::kSceneComposite, Access::kUnavailable, Decoder::kUnavailable, Channel::kAuto, Mapping::kAuto, 0.f, 1.f, {}},
    {Source::kLightingDiffuse, "Diffuse Lighting (Unavailable)", ProducerPass::kSceneComposite, Access::kUnavailable, Decoder::kUnavailable, Channel::kAuto, Mapping::kAuto, 0.f, 1.f, {}},
    {Source::kLightingSpecular, "Specular Lighting (Unavailable)", ProducerPass::kSceneComposite, Access::kUnavailable, Decoder::kUnavailable, Channel::kAuto, Mapping::kAuto, 0.f, 1.f, {}},
    {Source::kRetinalFixation, "Retinal Fixation (Unavailable)", ProducerPass::kSceneComposite, Access::kUnavailable, Decoder::kUnavailable, Channel::kAuto, Mapping::kAuto, 0.f, 1.f, {}},
    {Source::kRetinalEccentricity, "Retinal Eccentricity (Unavailable)", ProducerPass::kSceneComposite, Access::kUnavailable, Decoder::kUnavailable, Channel::kAuto, Mapping::kAuto, 0.f, 1.f, {}},
    {Source::kRetinalNyquist, "Retinal Nyquist (Unavailable)", ProducerPass::kSceneComposite, Access::kUnavailable, Decoder::kUnavailable, Channel::kAuto, Mapping::kAuto, 0.f, 1.f, {}},
    {Source::kRetinalRadius, "Retinal Radius (Unavailable)", ProducerPass::kSceneComposite, Access::kUnavailable, Decoder::kUnavailable, Channel::kAuto, Mapping::kAuto, 0.f, 1.f, {}},
    {Source::kDofVanillaTransitionControl, "DOF Vanilla Transition Control", ProducerPass::kDofComposite, Access::kDerivedInline, Decoder::kScalar, Channel::kRed, Mapping::kLinear, 0.f, 1.f, {kDofCompositeShaderCrc, 0u, 52u}},
    {Source::kDofVanillaTransitionContribution, "DOF Final Vanilla Transition", ProducerPass::kDofComposite, Access::kDerivedInline, Decoder::kScalar, Channel::kRed, Mapping::kLinear, 0.f, 1.f, {kDofCompositeShaderCrc, 0u, 3u}},
}};

[[nodiscard]] constexpr const SourceContract& GetSourceContract(
    Source source) noexcept {
  const auto index = static_cast<std::uint32_t>(source);
  return index < kSourceContracts.size() ? kSourceContracts[index]
                                         : kSourceContracts[0u];
}

struct Config {
  OverlayMode mode = OverlayMode::kOff;
  DashboardPreset dashboard = DashboardPreset::kDof;
  Source single_source = Source::kDofFullResolutionCoc;
  std::array<Source, 3u> custom_slots = {
      Source::kDofFullResolutionCoc,
      Source::kTemporalDepth,
      Source::kSceneBeforeGrade,
  };
  Channel channel = Channel::kAuto;
  Mapping mapping = Mapping::kAuto;
  float opacity = 1.f;
  bool temporal_source_unavailable = false;
  bool show_fixation = false;
};

struct ResolvedOverlay {
  OverlayMode mode = OverlayMode::kOff;
  std::array<Source, 3u> slots = {};
  std::uint32_t slot_count = 0u;
  Channel channel = Channel::kAuto;
  Mapping mapping = Mapping::kAuto;
  float opacity = 1.f;
  bool temporal_source_unavailable = false;
  bool show_fixation = false;

  [[nodiscard]] constexpr bool IsActive() const noexcept {
    return mode != OverlayMode::kOff && slot_count != 0u;
  }
};

[[nodiscard]] constexpr std::array<Source, 3u> GetDashboardSources(
    DashboardPreset preset,
    const std::array<Source, 3u>& custom_slots) noexcept {
  switch (preset) {
    case DashboardPreset::kDof:
      return {Source::kDofCoarseCoc,
              Source::kDofFullResolutionCoc,
              Source::kDofGatherFillLayers};
    case DashboardPreset::kTemporal:
      return {Source::kTemporalDepth,
              Source::kTemporalMotionVectors,
              Source::kTemporalHistory};
    case DashboardPreset::kScene:
      return {Source::kSceneBeforeGrade,
              Source::kSceneAfterGrade,
              Source::kSceneLuminance};
    case DashboardPreset::kLighting:
      return {Source::kGtao,
              Source::kLightingDiffuse,
              Source::kLightingSpecular};
    case DashboardPreset::kRetinal:
      return {Source::kRetinalEccentricity,
              Source::kRetinalNyquist,
              Source::kRetinalRadius};
    case DashboardPreset::kCustom:
      return custom_slots;
    case DashboardPreset::kDofVanillaTransition:
      return {Source::kDofFullResolutionCoc,
              Source::kDofVanillaTransitionControl,
              Source::kDofVanillaTransitionContribution};
  }
  return {};
}

[[nodiscard]] inline ResolvedOverlay Resolve(const Config& config) noexcept {
  ResolvedOverlay result = {
      .mode = config.mode,
      .channel = config.channel,
      .mapping = config.mapping,
      .opacity = std::isfinite(config.opacity)
                     ? std::clamp(config.opacity, 0.f, 1.f)
                     : 1.f,
      .temporal_source_unavailable = config.temporal_source_unavailable,
      .show_fixation = config.show_fixation,
  };
  switch (config.mode) {
    case OverlayMode::kSingle:
      result.slots[0u] = config.single_source;
      result.slot_count = 1u;
      break;
    case OverlayMode::kDashboard:
      result.slots = GetDashboardSources(config.dashboard, config.custom_slots);
      result.slot_count = 3u;
      break;
    case OverlayMode::kOff:
      break;
  }
  return result;
}

inline constexpr std::uint32_t kModeShift = 0u;
inline constexpr std::uint32_t kModeMask = 0x3u;
inline constexpr std::uint32_t kSlot0Shift = 2u;
inline constexpr std::uint32_t kSlot1Shift = 7u;
inline constexpr std::uint32_t kSlot2Shift = 12u;
inline constexpr std::uint32_t kSourceMask = 0x1Fu;
inline constexpr std::uint32_t kChannelShift = 17u;
inline constexpr std::uint32_t kChannelMask = 0x7u;
inline constexpr std::uint32_t kMappingShift = 20u;
inline constexpr std::uint32_t kMappingMask = 0x3u;
inline constexpr std::uint32_t kOpacityShift = 22u;
inline constexpr std::uint32_t kOpacityMask = 0x3Fu;
inline constexpr std::uint32_t kTemporalUnavailableShift = 28u;
inline constexpr std::uint32_t kShowFixationShift = 29u;
inline constexpr std::uint32_t kFinitePayloadMask = 0x3FFFFFFFu;

[[nodiscard]] inline std::uint32_t PackBits(
    const ResolvedOverlay& overlay) noexcept {
  if (!overlay.IsActive()) return 0u;
  const auto opacity = static_cast<std::uint32_t>(std::lround(
      std::clamp(overlay.opacity, 0.f, 1.f)
      * static_cast<float>(kOpacityMask)));
  const auto source_bits = [](Source source) {
    return static_cast<std::uint32_t>(source) & kSourceMask;
  };
  return ((static_cast<std::uint32_t>(overlay.mode) & kModeMask)
          << kModeShift)
         | (source_bits(overlay.slots[0u]) << kSlot0Shift)
         | (source_bits(overlay.slots[1u]) << kSlot1Shift)
         | (source_bits(overlay.slots[2u]) << kSlot2Shift)
         | ((static_cast<std::uint32_t>(overlay.channel) & kChannelMask)
            << kChannelShift)
         | ((static_cast<std::uint32_t>(overlay.mapping) & kMappingMask)
            << kMappingShift)
         | ((opacity & kOpacityMask) << kOpacityShift)
         | (static_cast<std::uint32_t>(overlay.temporal_source_unavailable)
            << kTemporalUnavailableShift)
         | (static_cast<std::uint32_t>(overlay.show_fixation)
            << kShowFixationShift);
}

[[nodiscard]] inline float PackPayload(const Config& config) noexcept {
  const auto bits = PackBits(Resolve(config));
  return bits == 0u ? 0.f : std::bit_cast<float>(bits);
}

[[nodiscard]] constexpr std::uint32_t RequiredPassMask(
    const ResolvedOverlay& overlay) noexcept {
  if (!overlay.IsActive()) return 0u;
  std::uint32_t mask = static_cast<std::uint32_t>(
      ProducerPass::kSceneComposite);
  for (std::uint32_t index = 0u; index < overlay.slot_count; ++index) {
    const auto producer = GetSourceContract(overlay.slots[index]).producer;
    mask |= static_cast<std::uint32_t>(producer);
  }
  return mask;
}

[[nodiscard]] constexpr bool HasUnavailableSource(
    const ResolvedOverlay& overlay) noexcept {
  for (std::uint32_t index = 0u; index < overlay.slot_count; ++index) {
    const auto& contract = GetSourceContract(overlay.slots[index]);
    if (!contract.IsAvailable()
        || (overlay.temporal_source_unavailable
            && contract.producer == ProducerPass::kTemporal)) {
      return true;
    }
  }
  return false;
}

struct FrameResult {
  float payload = 0.f;
  RuntimeStatus status = RuntimeStatus::kOff;
  std::uint32_t observed_pass_mask = 0u;
  std::uint32_t required_pass_mask = 0u;
};

// The controller owns no GPU resources. ResetDevice is therefore complete
// cleanup for this inline design and cannot leak stale views across recreation.
class RuntimeController {
 public:
  void SetConfig(const Config& config) {
    const std::scoped_lock lock(config_mutex_);
    config_ = config;
  }

  void Observe(ProducerPass pass) noexcept {
    observed_pass_mask_.fetch_or(
        static_cast<std::uint32_t>(pass), std::memory_order_relaxed);
  }

  [[nodiscard]] FrameResult FinishFrame(bool supported_build) {
    const auto observed = observed_pass_mask_.exchange(
        0u, std::memory_order_acq_rel);
    Config config;
    {
      const std::scoped_lock lock(config_mutex_);
      config = config_;
    }
    const auto overlay = Resolve(config);
    FrameResult result = {
        .observed_pass_mask = observed,
        .required_pass_mask = RequiredPassMask(overlay),
    };
    if (!overlay.IsActive()) {
      Store(result);
      return result;
    }
    if (!supported_build) {
      result.status = RuntimeStatus::kUnsupportedBuild;
      Store(result);
      return result;
    }
    if ((observed & result.required_pass_mask) != result.required_pass_mask) {
      result.status = RuntimeStatus::kWaitingForPasses;
      Store(result);
      return result;
    }
    result.payload = std::bit_cast<float>(PackBits(overlay));
    result.status = HasUnavailableSource(overlay)
                        ? RuntimeStatus::kActiveWithUnavailableSources
                        : RuntimeStatus::kActive;
    Store(result);
    return result;
  }

  void ResetDevice() noexcept {
    observed_pass_mask_.store(0u, std::memory_order_release);
    payload_bits_.store(0u, std::memory_order_release);
    status_.store(RuntimeStatus::kOff, std::memory_order_release);
    last_observed_pass_mask_.store(0u, std::memory_order_release);
  }

  [[nodiscard]] float GetPayload() const noexcept {
    return std::bit_cast<float>(payload_bits_.load(std::memory_order_acquire));
  }

  [[nodiscard]] RuntimeStatus GetStatus() const noexcept {
    return status_.load(std::memory_order_acquire);
  }

  [[nodiscard]] std::uint32_t GetLastObservedPassMask() const noexcept {
    return last_observed_pass_mask_.load(std::memory_order_acquire);
  }

 private:
  void Store(const FrameResult& result) noexcept {
    payload_bits_.store(
        std::bit_cast<std::uint32_t>(result.payload),
        std::memory_order_release);
    status_.store(result.status, std::memory_order_release);
    last_observed_pass_mask_.store(
        result.observed_pass_mask, std::memory_order_release);
  }

  std::mutex config_mutex_;
  Config config_ = {};
  std::atomic_uint32_t observed_pass_mask_ = 0u;
  std::atomic_uint32_t payload_bits_ = 0u;
  std::atomic<RuntimeStatus> status_ = RuntimeStatus::kOff;
  std::atomic_uint32_t last_observed_pass_mask_ = 0u;
};

}  // namespace renodx::games::detroitbecomehuman::render_debug
