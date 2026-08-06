/*
 * SPDX-License-Identifier: MIT
 */

#include <cmath>
#include <iostream>
#include <string_view>

#include "src/games/detroitbecomehuman/gtao_temporal_contract.hpp"

namespace {

namespace contract =
    renodx::games::detroitbecomehuman::gtao_temporal_contract;

bool Expect(bool condition, std::string_view message) {
  if (condition) return true;
  std::cerr << "FAIL: " << message << '\n';
  return false;
}

}  // namespace

int main() {
  bool ok = true;

  static_assert(contract::kPixelsPerWorkgroupAxis == 16u);
  static_assert(
      contract::GetDispatchCoverage(215u, 90u)
      == contract::Extent{3440u, 1440u});
  static_assert(contract::IsCoveredByDispatch(
      {2293u, 960u}, 144u, 60u));
  static_assert(!contract::IsCoveredByDispatch(
      {3440u, 1440u}, 144u, 60u));
  static_assert(
      contract::SelectHistoryExtent(
          144u, 60u, {2293u, 960u}, {3440u, 1440u})
      == contract::Extent{2293u, 960u});
  static_assert(
      contract::SelectHistoryExtent(
          215u, 90u, {}, {3440u, 1440u})
      == contract::Extent{3440u, 1440u});
  static_assert(
      contract::SelectHistoryExtent(10u, 5u, {}, {})
      == contract::Extent{160u, 80u});

  ok &= Expect(
      std::abs(contract::DepthDisocclusionThreshold(-10.f) - 0.2f)
          < 1.0e-6f,
      "depth rejection threshold must scale with view depth");
  ok &= Expect(
      std::abs(contract::DepthDisocclusionThreshold(0.f) - 0.002f)
          < 1.0e-6f,
      "depth rejection threshold must retain a near-plane floor");
  ok &= Expect(
      contract::TemporalHistoryWeight(0.f, 0.f)
          > contract::TemporalHistoryWeight(16.f, 0.f),
      "static pixels must retain more history than fast pixels");
  ok &= Expect(
      contract::TemporalHistoryWeight(0.f, 1.f) == 0.f,
      "disoccluded pixels must reject history");
  ok &= Expect(
      contract::TemporalHistoryWeight(NAN, 0.f) == 0.f,
      "non-finite motion must reject history");

  if (!ok) return 1;
  std::cout << "PASS: Detroit XeGTAO temporal contract\n";
  return 0;
}
