/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <array>
#include <cstdint>
#include <span>

namespace renodx::games::detroitbecomehuman::dlss::adapter_shaders {

#if defined(_WIN32)
#define DETROIT_DLSS_ADAPTER_SHADER_API __declspec(dllexport)
#else
#define DETROIT_DLSS_ADAPTER_SHADER_API
#endif

inline constexpr std::array<std::uint32_t, 3u> kWorkgroupSize = {8u, 8u, 1u};

struct PrepareColorMotionBindings {
  static constexpr std::uint32_t kCurrentColor = 0u;
  static constexpr std::uint32_t kMotionVectors = 1u;
  static constexpr std::uint32_t kOutputColor = 2u;
  static constexpr std::uint32_t kOutputMotionVectors = 3u;
};

struct PackColorBindings {
  static constexpr std::uint32_t kDlssColor = 0u;
  static constexpr std::uint32_t kOutputColorPass = 1u;
};

// SPIR-V is materialized as aligned words instead of casting the generated
// byte-array embed. The returned spans can be assigned directly to
// VkShaderModuleCreateInfo::{codeSize,pCode}. Exporting these internal C++
// accessors also prevents the linker from discarding the embedded modules
// before the Vulkan evaluator starts consuming them.
[[nodiscard]] DETROIT_DLSS_ADAPTER_SHADER_API std::span<const std::uint32_t>
GetPrepareColorMotionSpirv() noexcept;
[[nodiscard]] DETROIT_DLSS_ADAPTER_SHADER_API std::span<const std::uint32_t>
GetPackColorSpirv() noexcept;

#undef DETROIT_DLSS_ADAPTER_SHADER_API

}  // namespace renodx::games::detroitbecomehuman::dlss::adapter_shaders
