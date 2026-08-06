/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <array>
#include <bit>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <optional>
#include <span>

#include "supported_build.hpp"

namespace renodx::games::detroitbecomehuman::resolution_scaling {

// Every address below belongs only to Steam Build 12158144 and is additionally
// protected by the executable identity gate in supported_build.hpp.
inline constexpr std::uint32_t kSupportedPeTimestamp = 0x64DD1BF3u;
inline constexpr std::uint32_t kSupportedImageSize = 0x038C1000u;

inline constexpr std::uintptr_t kGraphicOptionsGlobalSlotRva = 0x02A10158u;
inline constexpr std::uintptr_t kRendererGlobalsSlotRva = 0x02A10120u;
inline constexpr std::uintptr_t kRuntimeUpdateFunctionRva = 0x00150EB0u;
inline constexpr std::uintptr_t kRuntimeScaleLoadRva = 0x001510FEu;
inline constexpr std::uintptr_t kRendererStoreSequenceRva = 0x00151121u;
inline constexpr std::uintptr_t kRuntimeUpdateCallSiteRva = 0x00191EA5u;

inline constexpr std::uintptr_t kBaseWidthOffset = 0x11CCu;
inline constexpr std::uintptr_t kBaseHeightOffset = 0x11D0u;
inline constexpr std::uintptr_t kRenderWidthOffset = 0x11D4u;
inline constexpr std::uintptr_t kRenderHeightOffset = 0x11D8u;
inline constexpr std::uintptr_t kSerializedScaleOffset = 0x1608u;
// The frame update at 0x191E8E derives this transient byte from the root dirty
// word before calling the hooked function. Publishing a changed derived extent
// after the original call must mirror only that transient observation; it must
// not set the persistent root/subobject dirty bits used by JSON serialization.
inline constexpr std::uintptr_t kRuntimeDirtyObservedFlagOffset = 0x19u;
inline constexpr std::uintptr_t kRendererWidthOffset = 0x158Cu;
inline constexpr std::uintptr_t kRendererHeightOffset = 0x1590u;

// Hooking the whole update function lets the addon replace only its derived
// render dimensions after the original code has run. The serialized
// RESOLUTION_SCALING field at +0x1608 is never written by the addon.
inline constexpr std::array<std::uint8_t, 22u> kRuntimeUpdatePrologue = {
    0x40,
    0x56,
    0x48,
    0x83,
    0xEC,
    0x40,
    0x0F,
    0xB7,
    0x41,
    0x1A,
    0x48,
    0x8B,
    0xF1,
    0x0F,
    0xB6,
    0x0D,
    0x52,
    0x63,
    0x8C,
    0x02,
    0xA8,
    0x02,
};

inline constexpr std::array<std::uint8_t, 8u> kRuntimeScaleLoad = {
    0xF3,
    0x0F,
    0x10,
    0x8E,
    0x08,
    0x16,
    0x00,
    0x00,
};

inline constexpr std::array<std::uint8_t, 39u> kRendererStoreSequence = {
    0x48,
    0x8B,
    0x05,
    0xF8,
    0xEF,
    0x8B,
    0x02,
    0x89,
    0x96,
    0xD4,
    0x11,
    0x00,
    0x00,
    0xF3,
    0x0F,
    0x59,
    0xC1,
    0xF3,
    0x0F,
    0x2C,
    0xC8,
    0x89,
    0x8E,
    0xD8,
    0x11,
    0x00,
    0x00,
    0x89,
    0x90,
    0x8C,
    0x15,
    0x00,
    0x00,
    0x89,
    0x88,
    0x90,
    0x15,
    0x00,
    0x00,
};

inline constexpr std::array<std::uint8_t, 12u> kRuntimeUpdateCallSite = {
    0x48,
    0x8B,
    0x0D,
    0xAC,
    0xE2,
    0x87,
    0x02,
    0xE8,
    0xFF,
    0xEF,
    0xFB,
    0xFF,
};

struct ExecutableIdentity {
  std::uint64_t file_size = 0u;
  std::array<std::uint8_t, 32u> sha256 = {};
};

[[nodiscard]] constexpr bool IsExactSupportedBuild(
    const ExecutableIdentity& identity) noexcept {
  return supported_build::MatchesExecutableIdentity(
      identity.file_size, identity.sha256);
}

inline constexpr float kMinimumSaneScale = 0.25f;
inline constexpr float kMaximumSaneScale = 2.f;

[[nodiscard]] constexpr bool IsSaneScale(float scale) noexcept {
  return scale >= kMinimumSaneScale && scale <= kMaximumSaneScale;
}

[[nodiscard]] constexpr bool ScalesMatch(float lhs, float rhs) noexcept {
  if (!IsSaneScale(lhs) || !IsSaneScale(rhs)) return false;
  return std::bit_cast<std::uint32_t>(lhs)
         == std::bit_cast<std::uint32_t>(rhs);
}

enum class ScaleRequestDecision {
  kReject,
  kNoChange,
  kApply,
};

enum class ProcessThreadRole {
  kIgnore,
  kCurrent,
  kOther,
};

[[nodiscard]] constexpr ProcessThreadRole ClassifyProcessThread(
    std::uint32_t process_id,
    std::uint32_t current_thread_id,
    std::uint32_t owner_process_id,
    std::uint32_t thread_id) noexcept {
  if (process_id == 0u || thread_id == 0u || owner_process_id != process_id) {
    return ProcessThreadRole::kIgnore;
  }
  return thread_id == current_thread_id ? ProcessThreadRole::kCurrent
                                        : ProcessThreadRole::kOther;
}

enum class HookLifecyclePhase : std::uint32_t {
  kRunning,
  kClosingAttached,
  kDetachedDraining,
};

enum class HookOriginalRoute {
  kTrampoline,
  kOriginalEntry,
};

[[nodiscard]] constexpr HookOriginalRoute SelectHookOriginalRoute(
    HookLifecyclePhase phase) noexcept {
  return phase == HookLifecyclePhase::kDetachedDraining
             ? HookOriginalRoute::kOriginalEntry
             : HookOriginalRoute::kTrampoline;
}

[[nodiscard]] constexpr bool ShouldPublishHookPostUpdate(
    HookLifecyclePhase phase) noexcept {
  return phase == HookLifecyclePhase::kRunning;
}

[[nodiscard]] constexpr ScaleRequestDecision DecideScaleRequest(
    float requested,
    float current) noexcept {
  if (!IsSaneScale(requested) || !IsSaneScale(current)) {
    return ScaleRequestDecision::kReject;
  }
  return ScalesMatch(requested, current)
             ? ScaleRequestDecision::kNoChange
             : ScaleRequestDecision::kApply;
}

struct PixelExtent {
  std::uint32_t width = 0u;
  std::uint32_t height = 0u;

  [[nodiscard]] constexpr bool operator==(const PixelExtent&) const = default;
};

[[nodiscard]] constexpr float NextFloatTowardPositiveInfinity(
    float value) noexcept {
  const auto bits = std::bit_cast<std::uint32_t>(value);
  if ((bits & 0x7FFFFFFFu) > 0x7F800000u || bits == 0x7F800000u) {
    return value;
  }
  if (bits == 0x80000000u) return std::bit_cast<float>(1u);
  return std::bit_cast<float>(
      (bits & 0x80000000u) != 0u ? bits - 1u : bits + 1u);
}

[[nodiscard]] constexpr float NextFloatTowardNegativeInfinity(
    float value) noexcept {
  const auto bits = std::bit_cast<std::uint32_t>(value);
  if ((bits & 0x7FFFFFFFu) > 0x7F800000u || bits == 0xFF800000u) {
    return value;
  }
  if (bits == 0u) return std::bit_cast<float>(0x80000001u);
  return std::bit_cast<float>(
      (bits & 0x80000000u) != 0u ? bits + 1u : bits - 1u);
}

[[nodiscard]] constexpr std::optional<std::uint32_t>
TruncateScaledDimension(std::uint32_t output, float scale) noexcept {
  if (output == 0u || !IsSaneScale(scale)) return std::nullopt;
  const float scaled = static_cast<float>(output) * scale;
  if (!(scaled >= 0.f) || !(scaled < 4294967296.f)) return std::nullopt;
  return static_cast<std::uint32_t>(scaled);
}

[[nodiscard]] constexpr bool ScaleProducesExactTruncatedExtent(
    PixelExtent output,
    PixelExtent render,
    float scale) noexcept {
  const auto width = TruncateScaledDimension(output.width, scale);
  const auto height = TruncateScaledDimension(output.height, scale);
  return width == render.width && height == render.height;
}

// NGX can return width and height whose individual ratios differ by a fraction
// of a pixel. Intersect the two truncation intervals and return a float that
// reproduces both exact integer dimensions in Detroit's renderer.
[[nodiscard]] constexpr std::optional<float>
SelectScaleForExactTruncatedExtent(
    PixelExtent output,
    PixelExtent render) noexcept {
  if (output.width == 0u || output.height == 0u || render.width == 0u
      || render.height == 0u) {
    return std::nullopt;
  }

  const double width_lower =
      static_cast<double>(render.width) / static_cast<double>(output.width);
  const double width_upper =
      (static_cast<double>(render.width) + 1.0)
      / static_cast<double>(output.width);
  const double height_lower =
      static_cast<double>(render.height) / static_cast<double>(output.height);
  const double height_upper =
      (static_cast<double>(render.height) + 1.0)
      / static_cast<double>(output.height);
  const double lower = std::max(width_lower, height_lower);
  const double upper = std::min(width_upper, height_upper);
  if (!(lower < upper)) return std::nullopt;

  const float rounded_lower = static_cast<float>(lower);
  const float rounded_upper = static_cast<float>(upper);
  const std::array candidates = {
      NextFloatTowardPositiveInfinity(rounded_lower),
      rounded_lower,
      NextFloatTowardNegativeInfinity(rounded_upper),
  };
  for (const float candidate : candidates) {
    const double exact_candidate = static_cast<double>(candidate);
    if (exact_candidate < lower || !(exact_candidate < upper)) continue;
    if (ScaleProducesExactTruncatedExtent(output, render, candidate)) {
      return candidate;
    }
  }
  return std::nullopt;
}

struct RuntimeDimensionUpdate {
  PixelExtent target = {};
  bool changed = false;
};

[[nodiscard]] constexpr std::optional<RuntimeDimensionUpdate>
CalculateRuntimeDimensionUpdate(
    PixelExtent base,
    PixelExtent observed,
    float scale) noexcept {
  const auto width = TruncateScaledDimension(base.width, scale);
  const auto height = TruncateScaledDimension(base.height, scale);
  if (!width.has_value() || !height.has_value() || width.value() == 0u
      || height.value() == 0u) {
    return std::nullopt;
  }
  const PixelExtent target = {width.value(), height.value()};
  return RuntimeDimensionUpdate{
      .target = target,
      .changed = target != observed,
  };
}

[[nodiscard]] constexpr std::optional<std::uintptr_t> CheckedAdd(
    std::uintptr_t base,
    std::uintptr_t offset) noexcept {
  if (base > std::numeric_limits<std::uintptr_t>::max() - offset) {
    return std::nullopt;
  }
  return base + offset;
}

[[nodiscard]] constexpr std::optional<std::uintptr_t> ResolveImageAddress(
    std::uintptr_t module_base,
    std::size_t image_size,
    std::uintptr_t rva,
    std::size_t required_size) noexcept {
  if (module_base == 0u || required_size == 0u || rva > image_size
      || required_size > image_size - rva) {
    return std::nullopt;
  }
  const auto address = CheckedAdd(module_base, rva);
  if (!address.has_value()
      || required_size - 1u
             > std::numeric_limits<std::uintptr_t>::max() - address.value()) {
    return std::nullopt;
  }
  return address;
}

[[nodiscard]] constexpr std::optional<std::uintptr_t> ResolveRel32TargetRva(
    std::uintptr_t instruction_rva,
    std::size_t instruction_size,
    std::int32_t displacement) noexcept {
  const auto next = CheckedAdd(instruction_rva, instruction_size);
  if (!next.has_value()) return std::nullopt;
  if (displacement >= 0) {
    return CheckedAdd(next.value(), static_cast<std::uint32_t>(displacement));
  }
  const auto magnitude = static_cast<std::uintptr_t>(
      -static_cast<std::int64_t>(displacement));
  if (magnitude > next.value()) return std::nullopt;
  return next.value() - magnitude;
}

[[nodiscard]] inline std::optional<std::int32_t> ReadRel32(
    std::span<const std::uint8_t> bytes,
    std::size_t displacement_offset) noexcept {
  if (displacement_offset > bytes.size()
      || sizeof(std::uint32_t) > bytes.size() - displacement_offset) {
    return std::nullopt;
  }
  const std::uint32_t raw =
      static_cast<std::uint32_t>(bytes[displacement_offset])
      | (static_cast<std::uint32_t>(bytes[displacement_offset + 1u]) << 8u)
      | (static_cast<std::uint32_t>(bytes[displacement_offset + 2u]) << 16u)
      | (static_cast<std::uint32_t>(bytes[displacement_offset + 3u]) << 24u);
  return std::bit_cast<std::int32_t>(raw);
}

struct KnownCodeSlices {
  std::span<const std::uint8_t> runtime_update_prologue;
  std::span<const std::uint8_t> runtime_scale_load;
  std::span<const std::uint8_t> renderer_store_sequence;
  std::span<const std::uint8_t> runtime_update_call_site;
};

struct KnownCodeValidation {
  bool runtime_update_prologue_matches = false;
  bool runtime_scale_load_matches = false;
  bool renderer_store_sequence_matches = false;
  bool runtime_update_call_site_matches = false;
  bool renderer_global_slot_target_matches = false;
  bool graphic_options_slot_target_matches = false;
  bool runtime_update_call_target_matches = false;

  [[nodiscard]] constexpr bool Succeeded() const noexcept {
    return runtime_update_prologue_matches && runtime_scale_load_matches
           && renderer_store_sequence_matches
           && runtime_update_call_site_matches
           && renderer_global_slot_target_matches
           && graphic_options_slot_target_matches
           && runtime_update_call_target_matches;
  }
};

template <std::size_t Size>
[[nodiscard]] inline bool BytesMatch(
    std::span<const std::uint8_t> observed,
    const std::array<std::uint8_t, Size>& expected) noexcept {
  return observed.size() == expected.size()
         && std::equal(observed.begin(), observed.end(), expected.begin());
}

[[nodiscard]] inline KnownCodeValidation ValidateKnownCode(
    const KnownCodeSlices& code) noexcept {
  KnownCodeValidation validation = {
      .runtime_update_prologue_matches =
          BytesMatch(code.runtime_update_prologue, kRuntimeUpdatePrologue),
      .runtime_scale_load_matches =
          BytesMatch(code.runtime_scale_load, kRuntimeScaleLoad),
      .renderer_store_sequence_matches =
          BytesMatch(code.renderer_store_sequence, kRendererStoreSequence),
      .runtime_update_call_site_matches =
          BytesMatch(code.runtime_update_call_site, kRuntimeUpdateCallSite),
  };

  if (const auto displacement = ReadRel32(code.renderer_store_sequence, 3u);
      displacement.has_value()) {
    validation.renderer_global_slot_target_matches =
        ResolveRel32TargetRva(
            kRendererStoreSequenceRva, 7u, displacement.value())
        == kRendererGlobalsSlotRva;
  }
  if (const auto displacement = ReadRel32(code.runtime_update_call_site, 3u);
      displacement.has_value()) {
    validation.graphic_options_slot_target_matches =
        ResolveRel32TargetRva(
            kRuntimeUpdateCallSiteRva, 7u, displacement.value())
        == kGraphicOptionsGlobalSlotRva;
  }
  if (const auto displacement = ReadRel32(code.runtime_update_call_site, 8u);
      displacement.has_value()) {
    validation.runtime_update_call_target_matches =
        ResolveRel32TargetRva(
            kRuntimeUpdateCallSiteRva + 7u, 5u, displacement.value())
        == kRuntimeUpdateFunctionRva;
  }
  return validation;
}

static_assert(kSerializedScaleOffset == 0x1608u);
static_assert(IsSaneScale(0.5f));
static_assert(!IsSaneScale(0.f));
static_assert(
    SelectScaleForExactTruncatedExtent({3440u, 1440u}, {2293u, 960u})
        .has_value());

}  // namespace renodx::games::detroitbecomehuman::resolution_scaling
