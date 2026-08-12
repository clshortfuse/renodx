/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <array>
#include <cstdint>
#include <span>

namespace renodx::games::detroitbecomehuman::dlss::adapter_shaders {

inline constexpr std::array<std::uint32_t, 3u> kWorkgroupSize = {8u, 8u, 1u};

struct PrepareColorMotionBindings {
  static constexpr std::uint32_t kCurrentColor = 0u;
  static constexpr std::uint32_t kOutputColor = 1u;
};

struct PackColorBindings {
  static constexpr std::uint32_t kDlssColor = 0u;
  static constexpr std::uint32_t kOutputColorPass = 1u;
};

inline constexpr std::uint32_t kPackPushConstantOffset = 120u;
inline constexpr std::uint32_t kPackPushConstantSize = 8u;
inline constexpr std::uint32_t kPackPushConstantRangeSize = 128u;
static_assert(
    kPackPushConstantOffset + kPackPushConstantSize
    == kPackPushConstantRangeSize);

// SPIR-V is materialized as aligned words instead of casting the generated
// byte-array embed. The returned spans can be assigned directly to
// VkShaderModuleCreateInfo::{codeSize,pCode}.
[[nodiscard]] std::span<const std::uint32_t> GetPrepareColorMotionSpirv() noexcept;
[[nodiscard]] std::span<const std::uint32_t> GetPackColorSpirv() noexcept;

}  // namespace renodx::games::detroitbecomehuman::dlss::adapter_shaders
