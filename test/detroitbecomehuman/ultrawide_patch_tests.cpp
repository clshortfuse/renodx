/*
 * SPDX-License-Identifier: MIT
 */

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <iterator>
#include <limits>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <vector>

#include <Windows.h>

#include "src/games/detroitbecomehuman/ultrawide.hpp"

namespace {

namespace ultrawide = renodx::games::detroitbecomehuman::ultrawide;

bool Expect(bool condition, std::string_view description) {
  if (condition) return true;
  std::cerr << "FAIL: " << description << '\n';
  return false;
}

bool NearlyEqual(float left, float right, float tolerance = 0.000001f) {
  return std::fabs(left - right) <= tolerance;
}

template <std::size_t PatternSize, std::size_t InstructionSize>
bool VerifyPatchContract(
    const ultrawide::PatchSpec<PatternSize, InstructionSize>& spec,
    std::span<const std::uint8_t> image,
    std::string_view name) {
  bool passed = true;
  const auto matches = ultrawide::FindPatternMatches(image, spec.pattern);
  passed &= Expect(
      matches == std::vector<std::size_t>({spec.expected_pattern_file_offset}),
      std::string(name).append(" production signature must match the supported EXE once"));
  if (matches.size() != 1u) return false;

  const auto instruction_file_offset = matches.front() + spec.instruction_offset;
  passed &= Expect(
      std::equal(
          spec.instruction.begin(),
          spec.instruction.end(),
          image.begin() + static_cast<std::ptrdiff_t>(instruction_file_offset)),
      std::string(name).append(" production instruction bytes must match the EXE"));

  std::int32_t displacement = 0;
  std::memcpy(
      &displacement,
      image.data() + instruction_file_offset + spec.displacement_offset,
      sizeof(displacement));
  const auto decoded_target = static_cast<std::int64_t>(spec.expected_instruction_rva)
                              + static_cast<std::int64_t>(InstructionSize)
                              + static_cast<std::int64_t>(displacement);
  passed &= Expect(
      decoded_target == static_cast<std::int64_t>(spec.expected_original_target_rva),
      std::string(name).append(" original RIP target must match the supported build"));

  return passed;
}

template <std::size_t PatternSize, std::size_t InstructionSize>
bool VerifyRuntimePatchSpec(
    const ultrawide::PatchSpec<PatternSize, InstructionSize>& spec,
    std::span<const std::uint8_t> image,
    std::string_view name) {
  bool passed = VerifyPatchContract(spec, image, name);

  auto redirected = spec.instruction;
  constexpr std::uintptr_t kSyntheticNextInstruction = 0x0000000140200000ull;
  constexpr std::uintptr_t kSyntheticTarget = 0x0000000141234560ull;
  const auto redirected_displacement =
      ultrawide::CalculateRipDisplacement(kSyntheticNextInstruction, kSyntheticTarget);
  passed &= Expect(
      redirected_displacement.has_value(),
      std::string(name).append(" synthetic target must be RIP-addressable"));
  if (!redirected_displacement.has_value()) return false;
  std::memcpy(
      redirected.data() + spec.displacement_offset,
      &redirected_displacement.value(),
      sizeof(redirected_displacement.value()));
  for (std::size_t index = 0; index < redirected.size(); ++index) {
    if (index >= spec.displacement_offset
        && index < spec.displacement_offset + sizeof(std::int32_t)) {
      continue;
    }
    passed &= Expect(
        redirected[index] == spec.instruction[index],
        std::string(name).append(" redirect must change only four displacement bytes"));
  }
  return passed;
}

bool VerifyPeGate(std::span<const std::uint8_t> image) {
  bool passed = true;
  passed &= Expect(
      image.size() >= sizeof(IMAGE_DOS_HEADER),
      "the supported EXE must contain a DOS header");
  if (image.size() < sizeof(IMAGE_DOS_HEADER)) return false;

  IMAGE_DOS_HEADER dos_header = {};
  std::memcpy(&dos_header, image.data(), sizeof(dos_header));
  passed &= Expect(
      dos_header.e_magic == IMAGE_DOS_SIGNATURE && dos_header.e_lfanew > 0,
      "the supported EXE must have a valid PE offset");
  if (dos_header.e_magic != IMAGE_DOS_SIGNATURE || dos_header.e_lfanew <= 0) return false;

  const auto nt_offset = static_cast<std::size_t>(dos_header.e_lfanew);
  passed &= Expect(
      nt_offset + sizeof(IMAGE_NT_HEADERS64) <= image.size(),
      "the supported EXE must contain a complete PE64 header");
  if (nt_offset + sizeof(IMAGE_NT_HEADERS64) > image.size()) return false;

  IMAGE_NT_HEADERS64 nt_headers = {};
  std::memcpy(&nt_headers, image.data() + nt_offset, sizeof(nt_headers));
  passed &= Expect(
      nt_headers.Signature == IMAGE_NT_SIGNATURE
          && nt_headers.FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64
          && nt_headers.OptionalHeader.Magic == IMAGE_NT_OPTIONAL_HDR64_MAGIC,
      "the supported EXE must be a valid AMD64 PE image");
  passed &= Expect(
      nt_headers.FileHeader.TimeDateStamp == ultrawide::kSupportedExeTimestamp,
      "the production PE timestamp gate must match Build 12158144");
  passed &= Expect(
      nt_headers.OptionalHeader.SizeOfImage == ultrawide::kSupportedExeImageSize,
      "the production PE image-size gate must match Build 12158144");
  return passed;
}

}  // namespace

int main(int argc, char** argv) {
  bool passed = true;

  passed &= Expect(
      NearlyEqual(ultrawide::kVanillaAspect, 16.f / 9.f),
      "the vanilla projection must remain 16:9");
  passed &= Expect(
      NearlyEqual(ultrawide::kNativeUiHalfExtent, 0.5f),
      "the native UI half-extent must remain 0.5");
  passed &= Expect(
      NearlyEqual(ultrawide::kDefaultTargetAspect, 3440.f / 1440.f),
      "the default target must use the monitor's exact 3440:1440 ratio");
  passed &= Expect(
      ultrawide::kRuntimePatchPlan.size() == 2u
          && ultrawide::kRuntimePatchPlan[ultrawide::kAspectPatchIndex]
                 == ultrawide::RuntimePatchId::kAspectGetter
          && ultrawide::kRuntimePatchPlan[ultrawide::kUiPatchIndex]
                 == ultrawide::RuntimePatchId::kUiHalfExtent,
      "the production patch plan must contain aspect and UI compensation redirects");

  passed &= Expect(
      NearlyEqual(
          ultrawide::CalculateUiHalfExtent(ultrawide::kVanillaAspect),
          ultrawide::kNativeUiHalfExtent),
      "16:9 must preserve the native UI half-extent");
  passed &= Expect(
      NearlyEqual(ultrawide::CalculateUiHalfExtent(2560.f / 1080.f), 0.375f),
      "2560x1080 must cancel the ultrawide UI enlargement");
  passed &= Expect(
      NearlyEqual(ultrawide::CalculateUiHalfExtent(3440.f / 1440.f), 16.f / 43.f),
      "3440x1440 must preserve the 16:9 UI size");
  passed &= Expect(
      NearlyEqual(ultrawide::CalculateUiHalfExtent(32.f / 9.f), 0.25f),
      "32:9 must preserve the 16:9 UI size");

  const auto auto_3440 = ultrawide::CalculateActiveValues(3440u, 1440u, true);
  passed &= Expect(
      NearlyEqual(auto_3440.aspect_ratio, 3440.f / 1440.f)
          && NearlyEqual(auto_3440.ui_half_extent, 16.f / 43.f),
      "Auto must use exact 3440x1440 scene and UI compensation values");
  const auto off_3440 = ultrawide::CalculateActiveValues(3440u, 1440u, false);
  passed &= Expect(
      NearlyEqual(off_3440.aspect_ratio, ultrawide::kVanillaAspect)
          && NearlyEqual(off_3440.ui_half_extent, ultrawide::kNativeUiHalfExtent),
      "Off must restore vanilla scene and UI values");
  const auto auto_16_9 = ultrawide::CalculateActiveValues(1920u, 1080u, true);
  passed &= Expect(
      NearlyEqual(auto_16_9.aspect_ratio, ultrawide::kVanillaAspect)
          && NearlyEqual(auto_16_9.ui_half_extent, ultrawide::kNativeUiHalfExtent),
      "Auto must leave 16:9 unchanged");
  const auto invalid_extent = ultrawide::CalculateActiveValues(0u, 0u, true);
  passed &= Expect(
      NearlyEqual(invalid_extent.aspect_ratio, ultrawide::kVanillaAspect)
          && NearlyEqual(invalid_extent.ui_half_extent, ultrawide::kNativeUiHalfExtent),
      "a missing swapchain extent must fall back to vanilla values");
  const auto narrow_extent = ultrawide::CalculateActiveValues(1280u, 1024u, true);
  passed &= Expect(
      NearlyEqual(narrow_extent.aspect_ratio, ultrawide::kVanillaAspect)
          && NearlyEqual(narrow_extent.ui_half_extent, ultrawide::kNativeUiHalfExtent),
      "Auto must not crop displays narrower than 16:9");

  using ultrawide::PatternByte;
  constexpr std::array<std::uint8_t, 12> bytes = {
      0x10, 0xAA, 0x01, 0xCC, 0x20, 0xAA, 0x02, 0xCC, 0x30, 0xAA, 0x03, 0xDD};
  constexpr std::array wildcard_pattern = {
      PatternByte{0xAA, false},
      PatternByte{0x00, true},
      PatternByte{0xCC, false},
  };
  const std::vector<std::size_t> wildcard_matches =
      ultrawide::FindPatternMatches(bytes, wildcard_pattern);
  passed &= Expect(
      wildcard_matches == std::vector<std::size_t>({1u, 5u}),
      "wildcards must match only complete AOB occurrences");

  constexpr std::array exact_pattern = {
      PatternByte{0xAA, false},
      PatternByte{0x03, false},
      PatternByte{0xDD, false},
  };
  passed &= Expect(
      ultrawide::FindPatternMatches(bytes, exact_pattern)
          == std::vector<std::size_t>({9u}),
      "exact AOB matching must include a pattern ending at the buffer boundary");

  constexpr std::array missing_pattern = {
      PatternByte{0xAA, false},
      PatternByte{0x04, false},
  };
  passed &= Expect(
      ultrawide::FindPatternMatches(bytes, missing_pattern).empty(),
      "a mismatching AOB must not produce false positives");

  constexpr std::array oversized_pattern = {
      PatternByte{0x10, false},
      PatternByte{0x00, true},
      PatternByte{0x00, true},
      PatternByte{0x00, true},
      PatternByte{0x00, true},
      PatternByte{0x00, true},
      PatternByte{0x00, true},
      PatternByte{0x00, true},
      PatternByte{0x00, true},
      PatternByte{0x00, true},
      PatternByte{0x00, true},
      PatternByte{0x00, true},
      PatternByte{0x00, true},
  };
  passed &= Expect(
      ultrawide::FindPatternMatches(bytes, oversized_pattern).empty(),
      "an AOB longer than the image must be rejected");

  constexpr std::uintptr_t next_instruction = 0x0000000200000000ull;
  passed &= Expect(
      ultrawide::CalculateRipDisplacement(next_instruction, next_instruction + 0x1234u)
          == std::optional<std::int32_t>(0x1234),
      "forward RIP displacement must be calculated exactly");
  passed &= Expect(
      ultrawide::CalculateRipDisplacement(next_instruction, next_instruction - 0x1234u)
          == std::optional<std::int32_t>(-0x1234),
      "backward RIP displacement must be calculated exactly");
  passed &= Expect(
      ultrawide::CalculateRipDisplacement(
          next_instruction,
          next_instruction + static_cast<std::uintptr_t>(std::numeric_limits<std::int32_t>::max()))
          == std::optional<std::int32_t>(std::numeric_limits<std::int32_t>::max()),
      "INT32_MAX RIP displacement must be accepted");
  passed &= Expect(
      ultrawide::CalculateRipDisplacement(
          next_instruction,
          next_instruction - (static_cast<std::uintptr_t>(std::numeric_limits<std::int32_t>::max()) + 1u))
          == std::optional<std::int32_t>(std::numeric_limits<std::int32_t>::min()),
      "INT32_MIN RIP displacement must be accepted");
  passed &= Expect(
      !ultrawide::CalculateRipDisplacement(
           next_instruction,
           next_instruction + static_cast<std::uintptr_t>(std::numeric_limits<std::int32_t>::max()) + 1u)
           .has_value(),
      "forward RIP displacement overflow must be rejected");
  passed &= Expect(
      !ultrawide::CalculateRipDisplacement(
           next_instruction,
           next_instruction - (static_cast<std::uintptr_t>(std::numeric_limits<std::int32_t>::max()) + 2u))
           .has_value(),
      "backward RIP displacement overflow must be rejected");

  passed &= Expect(
      ultrawide::DecideDisplacementWrite(10, 10, 20)
          == ultrawide::DisplacementWriteAction::kWriteReplacement,
      "an original displacement must request an atomic replacement");
  passed &= Expect(
      ultrawide::DecideDisplacementWrite(20, 10, 20)
          == ultrawide::DisplacementWriteAction::kAlreadyReplaced,
      "an idempotent retry must accept a displacement already at the desired value");
  passed &= Expect(
      ultrawide::DecideDisplacementWrite(30, 10, 20)
          == ultrawide::DisplacementWriteAction::kRefuse,
      "an unexpected third-party displacement must be refused");

  {
    std::array<bool, ultrawide::kRuntimePatchPlan.size()> active = {};
    std::size_t rollback_count = 0u;
    std::size_t apply_count = 0u;
    const bool committed = ultrawide::ApplyPatchTransaction(
        [&apply_count](std::size_t) {
          ++apply_count;
          return ultrawide::PatchOperationResult{true, true};
        },
        [&rollback_count](std::size_t) {
          ++rollback_count;
          return ultrawide::PatchOperationResult{true, true};
        },
        active);
    passed &= Expect(
        committed && active == std::array<bool, 2u>({true, true})
            && apply_count == 2u && rollback_count == 0u,
        "a successful production transaction must commit both redirects");
  }

  {
    std::array<bool, ultrawide::kRuntimePatchPlan.size()> active = {};
    std::vector<std::size_t> rollback_order;
    const bool committed = ultrawide::ApplyPatchTransaction(
        [](std::size_t index) {
          return index == ultrawide::kAspectPatchIndex
                     ? ultrawide::PatchOperationResult{true, true}
                     : ultrawide::PatchOperationResult{true, false};
        },
        [&rollback_order](std::size_t index) {
          rollback_order.push_back(index);
          return ultrawide::PatchOperationResult{true, true};
        },
        active);
    passed &= Expect(
        !committed && active == std::array<bool, 2u>({false, false})
            && rollback_order == std::vector<std::size_t>({1u, 0u}),
        "a failed UI redirect must roll back both writes in reverse order");
  }

  {
    std::array<bool, ultrawide::kRuntimePatchPlan.size()> active = {true, true};
    const bool restored = ultrawide::RestorePatchTransaction(
        [](std::size_t index) {
          return index == ultrawide::kAspectPatchIndex
                     ? ultrawide::PatchOperationResult{true, false}
                     : ultrawide::PatchOperationResult{true, true};
        },
        active);
    passed &= Expect(
        !restored && active == std::array<bool, 2u>({true, false}),
        "failed restoration must retain recoverable active state");
    const bool retried = ultrawide::RestorePatchTransaction(
        [](std::size_t) { return ultrawide::PatchOperationResult{true, true}; },
        active);
    passed &= Expect(
        retried && active == std::array<bool, 2u>({false, false}),
        "a later idempotent restoration retry must clear retained state");
  }

  if (argc == 3 && std::string_view(argv[1]) == "--exe") {
    const std::filesystem::path exe_path = argv[2];
    std::ifstream stream(exe_path, std::ios::binary);
    passed &= Expect(stream.is_open(), "the supported EXE must be readable");
    const std::vector<std::uint8_t> image{
        std::istreambuf_iterator<char>(stream), std::istreambuf_iterator<char>()};
    if (!image.empty()) {
      passed &= VerifyPeGate(image);
      passed &= VerifyRuntimePatchSpec(
          ultrawide::kAspectGetterPatch, image, "aspect getter");
      passed &= VerifyRuntimePatchSpec(
          ultrawide::kUiHalfExtentPatch, image, "UI half-extent");
    } else {
      passed = false;
    }
  } else if (argc != 1) {
    std::cerr << "usage: ultrawide_patch_tests [--exe PATH]\n";
    passed = false;
  }

  std::cout << (passed ? "PASS\n" : "FAIL\n");
  return passed ? 0 : 1;
}
