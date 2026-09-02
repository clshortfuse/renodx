#pragma once

#include <cstddef>
#include <cstdint>
#include <string_view>

namespace renodx::games::doom2016::supported_build {

inline constexpr std::string_view kExecutableName = "DOOMx64vk.exe";
inline constexpr std::string_view kExecutableSha256 =
    "A32DF8FFA042090F14FE0A200F1C5D7DDDF9C947FAC223916C252F826F1ECF11";
inline constexpr std::uint64_t kExecutableSize = 101520384ull;
inline constexpr std::uint64_t kGogProductId = 1390579243ull;
inline constexpr std::uint64_t kSteamAppId = 379720ull;
inline constexpr std::string_view kPsychoV30SourceSha256 =
    "01E075AB1E9FD79469E160FCD05F54277DE8B47C76CC3C4A425E4DAA7F164F58";

inline constexpr std::uint32_t kPostProcessShaderCrc = 0xF600527Eu;
inline constexpr std::uint32_t kOutputShaderCrc = 0x49CBC37Fu;
inline constexpr std::size_t kPostProcessShaderByteSize = 54792u;
inline constexpr std::size_t kOutputShaderByteSize = 22644u;

}  // namespace renodx::games::doom2016::supported_build
