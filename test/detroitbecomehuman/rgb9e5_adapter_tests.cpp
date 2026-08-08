/*
 * SPDX-License-Identifier: MIT
 */

#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <iostream>
#include <limits>
#include <string_view>

#include "src/games/detroitbecomehuman/dlss/adapter_shaders.hpp"
#include "src/games/detroitbecomehuman/dlss/rgb9e5_adapter.hpp"

namespace {

namespace rgb9e5 = renodx::games::detroitbecomehuman::dlss::rgb9e5;
namespace adapter_shaders =
    renodx::games::detroitbecomehuman::dlss::adapter_shaders;

static_assert(adapter_shaders::kWorkgroupSize == std::array<std::uint32_t, 3u>{8u, 8u, 1u});
static_assert(adapter_shaders::PrepareColorMotionBindings::kCurrentColor == 0u);
static_assert(adapter_shaders::PrepareColorMotionBindings::kOutputColor == 1u);
static_assert(adapter_shaders::PackColorBindings::kDlssColor == 0u);
static_assert(adapter_shaders::PackColorBindings::kOutputColorPass == 1u);
static_assert(adapter_shaders::PackColorBindings::kConstants == 2u);

bool Expect(bool condition, std::string_view description) {
  if (condition) return true;
  std::cerr << "FAIL: " << description << '\n';
  return false;
}

bool TestKnownEncodings() {
  bool passed = true;
  passed &= Expect(rgb9e5::Pack({0.f, 0.f, 0.f}) == 0u, "black encoding changed");
  passed &= Expect(
      rgb9e5::Pack({0.5f, 0.5f, 0.5f}) == UINT32_C(0x7C020100),
      "0.5 gray encoding changed");
  passed &= Expect(
      rgb9e5::Pack({1.f, 1.f, 1.f}) == UINT32_C(0x84020100),
      "1.0 gray encoding changed");
  passed &= Expect(
      rgb9e5::Pack({1.f, 0.f, 0.f}) == UINT32_C(0x80000100),
      "unit red encoding changed");
  passed &= Expect(
      rgb9e5::Pack({rgb9e5::kMaxChannel, rgb9e5::kMaxChannel, rgb9e5::kMaxChannel})
          == UINT32_C(0xFFFFFFFF),
      "maximum finite encoding changed");
  return passed;
}

bool TestSanitizationAndClamp() {
  const auto quiet_nan = std::numeric_limits<float>::quiet_NaN();
  const auto infinity = std::numeric_limits<float>::infinity();

  bool passed = true;
  passed &= Expect(
      rgb9e5::Pack({quiet_nan, 1.f, infinity}) == UINT32_C(0x80020000),
      "NaN and infinity must be sanitized to zero per channel");
  passed &= Expect(
      rgb9e5::Pack({-1.f, -2.f, -3.f}) == 0u,
      "negative values must clamp to black");
  passed &= Expect(
      rgb9e5::Pack({rgb9e5::kMaxChannel * 2.f,
                    rgb9e5::kMaxChannel * 4.f,
                    rgb9e5::kMaxChannel * 8.f})
          == UINT32_C(0xFFFFFFFF),
      "finite overflow must clamp to the RGB9E5 maximum");
  return passed;
}

bool TestKnownDecodingsAndRoundTrip() {
  const auto black = rgb9e5::Unpack(0u);
  const auto white = rgb9e5::Unpack(UINT32_C(0x84020100));
  const auto maximum = rgb9e5::Unpack(UINT32_C(0xFFFFFFFF));
  const std::array<float, 3u> exact = {4.f, 2.f, 1.f};
  const auto round_trip = rgb9e5::Unpack(rgb9e5::Pack(exact));

  bool passed = true;
  passed &= Expect(
      black == std::array<float, 3u>{0.f, 0.f, 0.f},
      "black decoding changed");
  passed &= Expect(
      white == std::array<float, 3u>{1.f, 1.f, 1.f},
      "1.0 gray decoding changed");
  passed &= Expect(
      maximum == std::array<float, 3u>{rgb9e5::kMaxChannel, rgb9e5::kMaxChannel, rgb9e5::kMaxChannel},
      "maximum decoding changed");
  passed &= Expect(round_trip == exact, "exact powers of two must round-trip");
  return passed;
}

bool TestEmbeddedShaderApi() {
  const auto prepare = adapter_shaders::GetPrepareColorMotionSpirv();
  const auto pack = adapter_shaders::GetPackColorSpirv();

  bool passed = true;
  passed &= Expect(
      !prepare.empty() && prepare.front() == UINT32_C(0x07230203),
      "prepare adapter must expose embedded SPIR-V words");
  passed &= Expect(
      !pack.empty() && pack.front() == UINT32_C(0x07230203),
      "pack adapter must expose embedded SPIR-V words");
  passed &= Expect(
      reinterpret_cast<std::uintptr_t>(prepare.data()) % alignof(std::uint32_t) == 0u
          && reinterpret_cast<std::uintptr_t>(pack.data()) % alignof(std::uint32_t) == 0u,
      "VkShaderModule pCode spans must retain uint32 alignment");
  return passed;
}

}  // namespace

int main() {
  bool passed = true;
  passed &= TestKnownEncodings();
  passed &= TestSanitizationAndClamp();
  passed &= TestKnownDecodingsAndRoundTrip();
  passed &= TestEmbeddedShaderApi();
  return passed ? 0 : 1;
}
