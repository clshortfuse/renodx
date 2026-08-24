/*
 * SPDX-License-Identifier: MIT
 */

#include "adapter_shaders.hpp"

#include <array>
#include <cstddef>
#include <cstdint>

#include "embed/detroit_dlss_pack_color.h"
#include "embed/detroit_dlss_prepare_color_motion.h"

namespace renodx::games::detroitbecomehuman::dlss::adapter_shaders {
namespace {

template <std::size_t Size>
consteval auto ToSpirvWords(const std::uint8_t (&bytes)[Size]) {
  static_assert(Size != 0u);
  static_assert(Size % sizeof(std::uint32_t) == 0u);

  std::array<std::uint32_t, Size / sizeof(std::uint32_t)> words = {};
  for (std::size_t index = 0u; index < words.size(); ++index) {
    const auto byte_index = index * sizeof(std::uint32_t);
    words[index] = static_cast<std::uint32_t>(bytes[byte_index])
                   | (static_cast<std::uint32_t>(bytes[byte_index + 1u]) << 8u)
                   | (static_cast<std::uint32_t>(bytes[byte_index + 2u]) << 16u)
                   | (static_cast<std::uint32_t>(bytes[byte_index + 3u]) << 24u);
  }
  return words;
}

alignas(std::uint32_t) constexpr auto kPrepareColorMotionSpirv =
    ToSpirvWords(__detroit_dlss_prepare_color_motion_base);
alignas(std::uint32_t) constexpr auto kPackColorSpirv =
    ToSpirvWords(__detroit_dlss_pack_color_base);

static_assert(kPrepareColorMotionSpirv.front() == UINT32_C(0x07230203));
static_assert(kPackColorSpirv.front() == UINT32_C(0x07230203));

}  // namespace

std::span<const std::uint32_t> GetPrepareColorMotionSpirv() noexcept {
  return kPrepareColorMotionSpirv;
}

std::span<const std::uint32_t> GetPackColorSpirv() noexcept {
  return kPackColorSpirv;
}

}  // namespace renodx::games::detroitbecomehuman::dlss::adapter_shaders
