#ifndef SRC_GAMES_DETROITBECOMEHUMAN_ULTRAWIDE_HPP_
#define SRC_GAMES_DETROITBECOMEHUMAN_ULTRAWIDE_HPP_

#include <array>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <optional>
#include <span>
#include <vector>

namespace renodx::games::detroitbecomehuman::ultrawide {

inline constexpr std::uint32_t kSupportedExeTimestamp = 0x64DD1BF3u;
inline constexpr std::uint32_t kSupportedExeImageSize = 0x038C1000u;

inline constexpr float kVanillaAspect = 16.f / 9.f;
inline constexpr float kNativeUiHalfExtent = 0.5f;
inline constexpr float kDefaultTargetAspect = 3440.f / 1440.f;

constexpr float CalculateUiHalfExtent(float aspect_ratio) {
  return kNativeUiHalfExtent * aspect_ratio / kVanillaAspect;
}

struct ActiveValues {
  float aspect_ratio;
  float ui_half_extent;
};

constexpr ActiveValues CalculateActiveValues(
    std::uint32_t width,
    std::uint32_t height,
    bool enabled) {
  float detected_aspect = kVanillaAspect;
  if (width != 0u && height != 0u) {
    detected_aspect = static_cast<float>(width) / static_cast<float>(height);
  }

  const float active_aspect = enabled && detected_aspect > kVanillaAspect
                                  ? detected_aspect
                                  : kVanillaAspect;
  return {
      .aspect_ratio = active_aspect,
      .ui_half_extent = CalculateUiHalfExtent(active_aspect),
  };
}

struct PatternByte {
  std::uint8_t value;
  bool wildcard = false;
};

template <std::size_t PatternSize, std::size_t InstructionSize>
struct PatchSpec {
  std::array<PatternByte, PatternSize> pattern;
  std::size_t instruction_offset;
  std::array<std::uint8_t, InstructionSize> instruction;
  std::size_t displacement_offset;
  std::size_t expected_pattern_file_offset;
  std::uintptr_t expected_instruction_rva;
  std::uintptr_t expected_original_target_rva;
};

template <std::size_t PatternSize, std::size_t InstructionSize>
consteval bool IsPatchSpecValid(const PatchSpec<PatternSize, InstructionSize>& spec) {
  if (spec.instruction_offset + InstructionSize > PatternSize
      || spec.displacement_offset + sizeof(std::int32_t) != InstructionSize) {
    return false;
  }
  for (std::size_t index = 0; index < InstructionSize; ++index) {
    const auto& pattern_byte = spec.pattern[spec.instruction_offset + index];
    if (pattern_byte.wildcard || pattern_byte.value != spec.instruction[index]) return false;
  }
  return true;
}

inline constexpr PatchSpec<21u, 8u> kAspectGetterPatch = {
    .pattern = {{{0xF3},
                 {0x0F},
                 {0x10},
                 {0x05},
                 {0x3D},
                 {0x0C},
                 {0xD4},
                 {0x01},
                 {0xC3},
                 {0xF3},
                 {0x0F},
                 {0x10},
                 {0x05},
                 {0x80},
                 {0x0C},
                 {0xD4},
                 {0x01},
                 {0xC3},
                 {0xCC},
                 {0xCC},
                 {0xCC}}},
    .instruction_offset = 9u,
    .instruction = {0xF3, 0x0F, 0x10, 0x05, 0x80, 0x0C, 0xD4, 0x01},
    .displacement_offset = 4u,
    .expected_pattern_file_offset = 0x15BB03u,
    .expected_instruction_rva = 0x15C50Cu,
    .expected_original_target_rva = 0x1E9D194u,
};

inline constexpr PatchSpec<33u, 9u> kUiHalfExtentPatch = {
    .pattern = {{{0x48},
                 {0x8B},
                 {0x03},
                 {0x48},
                 {0x8B},
                 {0xCB},
                 {0xFF},
                 {0x50},
                 {0x10},
                 {0x48},
                 {0x8B},
                 {0x03},
                 {0x48},
                 {0x8B},
                 {0xCB},
                 {0xF3},
                 {0x44},
                 {0x0F},
                 {0x10},
                 {0x35},
                 {0x3F},
                 {0xB0},
                 {0x2D},
                 {0x01},
                 {0x44},
                 {0x0F},
                 {0x28},
                 {0xC0},
                 {0xF3},
                 {0x45},
                 {0x0F},
                 {0x59},
                 {0xC6}}},
    .instruction_offset = 15u,
    .instruction = {0xF3, 0x44, 0x0F, 0x10, 0x35, 0x3F, 0xB0, 0x2D, 0x01},
    .displacement_offset = 5u,
    .expected_pattern_file_offset = 0xBC14F5u,
    .expected_instruction_rva = 0xBC1F04u,
    .expected_original_target_rva = 0x1E9CF4Cu,
};

static_assert(IsPatchSpecValid(kAspectGetterPatch));
static_assert(IsPatchSpecValid(kUiHalfExtentPatch));

enum class RuntimePatchId : std::uint8_t {
  kAspectGetter,
  kUiHalfExtent,
};

inline constexpr std::array kRuntimePatchPlan = {
    RuntimePatchId::kAspectGetter,
    RuntimePatchId::kUiHalfExtent,
};
inline constexpr std::size_t kAspectPatchIndex = 0u;
inline constexpr std::size_t kUiPatchIndex = 1u;

static_assert(kRuntimePatchPlan.size() == 2u);
static_assert(kRuntimePatchPlan[kAspectPatchIndex] == RuntimePatchId::kAspectGetter);
static_assert(kRuntimePatchPlan[kUiPatchIndex] == RuntimePatchId::kUiHalfExtent);

struct PatchOperationResult {
  bool bytes_written = false;
  bool final_protection_restored = false;

  [[nodiscard]] constexpr bool Succeeded() const {
    return bytes_written && final_protection_restored;
  }
};

enum class DisplacementWriteAction {
  kWriteReplacement,
  kAlreadyReplaced,
  kRefuse,
};

constexpr DisplacementWriteAction DecideDisplacementWrite(
    std::int32_t observed,
    std::int32_t expected,
    std::int32_t replacement) {
  if (observed == replacement) return DisplacementWriteAction::kAlreadyReplaced;
  if (observed == expected) return DisplacementWriteAction::kWriteReplacement;
  return DisplacementWriteAction::kRefuse;
}

template <typename Apply, typename Restore, std::size_t PatchCount>
bool ApplyPatchTransaction(
    Apply&& apply,
    Restore&& restore,
    std::array<bool, PatchCount>& active_patches) {
  active_patches = {};
  for (std::size_t index = 0; index < active_patches.size(); ++index) {
    const auto result = apply(index);
    active_patches[index] = result.bytes_written;
    if (result.Succeeded()) continue;

    for (std::size_t rollback = index + 1u; rollback-- > 0u;) {
      if (!active_patches[rollback]) continue;
      if (restore(rollback).Succeeded()) active_patches[rollback] = false;
    }
    return false;
  }
  return true;
}

template <typename Restore, std::size_t PatchCount>
bool RestorePatchTransaction(
    Restore&& restore,
    std::array<bool, PatchCount>& active_patches) {
  bool restored = true;
  for (std::size_t index = active_patches.size(); index-- > 0u;) {
    if (!active_patches[index]) continue;
    if (restore(index).Succeeded()) {
      active_patches[index] = false;
    } else {
      restored = false;
    }
  }
  return restored;
}

inline std::vector<std::size_t> FindPatternMatches(
    std::span<const std::uint8_t> data,
    std::span<const PatternByte> pattern) {
  std::vector<std::size_t> matches;
  if (pattern.empty() || data.size() < pattern.size()) return matches;

  for (std::size_t offset = 0; offset <= data.size() - pattern.size(); ++offset) {
    bool matched = true;
    for (std::size_t index = 0; index < pattern.size(); ++index) {
      if (!pattern[index].wildcard && data[offset + index] != pattern[index].value) {
        matched = false;
        break;
      }
    }
    if (matched) matches.push_back(offset);
  }
  return matches;
}

inline std::optional<std::int32_t> CalculateRipDisplacement(
    std::uintptr_t next_instruction,
    std::uintptr_t target) {
  if (target >= next_instruction) {
    const auto distance = target - next_instruction;
    if (distance > static_cast<std::uintptr_t>(std::numeric_limits<std::int32_t>::max())) {
      return std::nullopt;
    }
    return static_cast<std::int32_t>(distance);
  }

  const auto distance = next_instruction - target;
  constexpr auto kMaxNegativeDistance =
      static_cast<std::uintptr_t>(std::numeric_limits<std::int32_t>::max()) + 1u;
  if (distance > kMaxNegativeDistance) return std::nullopt;
  return static_cast<std::int32_t>(-static_cast<std::int64_t>(distance));
}

}  // namespace renodx::games::detroitbecomehuman::ultrawide

#endif  // SRC_GAMES_DETROITBECOMEHUMAN_ULTRAWIDE_HPP_
