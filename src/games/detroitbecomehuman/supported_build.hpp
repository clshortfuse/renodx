/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <array>
#include <cstddef>
#include <cstdint>
#include <string_view>

namespace renodx::games::detroitbecomehuman::supported_build {

inline constexpr std::string_view kExecutableName = "DetroitBecomeHuman.exe";
inline constexpr std::uint64_t kSteamBuildId = 12'158'144u;
inline constexpr std::uint64_t kExecutableSize = 57'986'328u;
inline constexpr std::string_view kExecutableSha256Hex =
    "ECF52321921387E683904E089082D76B973326FC093AF14E524056715519C1CF";
inline constexpr std::array<std::uint8_t, 32u> kExecutableSha256 = {
    0xECu, 0xF5u, 0x23u, 0x21u, 0x92u, 0x13u, 0x87u, 0xE6u,
    0x83u, 0x90u, 0x4Eu, 0x08u, 0x90u, 0x82u, 0xD7u, 0x6Bu,
    0x97u, 0x33u, 0x26u, 0xFCu, 0x09u, 0x3Au, 0xF1u, 0x4Eu,
    0x52u, 0x40u, 0x56u, 0x71u, 0x55u, 0x19u, 0xC1u, 0xCFu,
};

inline constexpr std::uint32_t kTemporalAaShaderCrc = 0xB5506A45u;
inline constexpr std::uint32_t kObservedTemporalAaModuleSize = 37'236u;

// Explicit, build-scoped runtime evidence gate. This is enabled only for the
// executable identity above after the live b52/resource capture and render
// ordering audit were completed. Any executable/shader revision must introduce
// a new evidence revision and starts with this gate disabled.
inline constexpr std::uint32_t kTemporalInputEvidenceRevision = 1u;
inline constexpr bool kTemporalInputsEmpiricallyVerified = true;

[[nodiscard]] constexpr bool MatchesExecutableIdentity(
    std::uint64_t size,
    const std::array<std::uint8_t, 32u>& sha256) noexcept {
  return size == kExecutableSize && sha256 == kExecutableSha256;
}

}  // namespace renodx::games::detroitbecomehuman::supported_build
