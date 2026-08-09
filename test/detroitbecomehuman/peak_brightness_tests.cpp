#include <chrono>
#include <cmath>
#include <iostream>
#include <limits>
#include <optional>

#include "src/games/detroitbecomehuman/peak_brightness.hpp"

namespace {

bool Expect(bool condition, const char* message) {
  if (condition) return true;
  std::cerr << "FAIL: " << message << '\n';
  return false;
}

}  // namespace

int main() {
  namespace peak =
      renodx::games::detroitbecomehuman::peak_brightness;
  bool passed = true;

  float saved_manual_peak = 1033.f;
  auto resolved = peak::Resolve(
      peak::Source::kAutomatic,
      saved_manual_peak,
      600.f);
  passed &= Expect(
      resolved.automatic && !resolved.used_fallback
          && resolved.effective_peak_nits == 600.f,
      "Auto must use valid DXGI MaxLuminance");
  passed &= Expect(saved_manual_peak == 1033.f,
                   "Auto must not overwrite the saved manual value");

  resolved = peak::Resolve(
      peak::Source::kManual,
      saved_manual_peak,
      600.f);
  passed &= Expect(
      !resolved.automatic && !resolved.used_fallback
          && resolved.effective_peak_nits == 1033.f,
      "Manual must ignore detected metadata");

  for (const auto invalid : {
           std::optional<float>{},
           std::optional<float>{47.f},
           std::optional<float>{4001.f},
           std::optional<float>{std::numeric_limits<float>::infinity()},
           std::optional<float>{std::numeric_limits<float>::quiet_NaN()},
       }) {
    resolved = peak::Resolve(
        peak::Source::kAutomatic,
        saved_manual_peak,
        invalid);
    passed &= Expect(
        resolved.automatic && resolved.used_fallback
            && resolved.effective_peak_nits == peak::kFallbackPeakNits,
        "invalid or missing metadata must use the 1000-nit fallback");
  }

  resolved = peak::Resolve(
      peak::Source::kManual,
      std::numeric_limits<float>::quiet_NaN(),
      std::nullopt);
  passed &= Expect(
      resolved.used_fallback
          && resolved.effective_peak_nits == peak::kFallbackPeakNits,
      "invalid manual input must fail safely");

  peak::RefreshController refresh;
  const auto start = peak::RefreshController::Clock::time_point{};
  passed &= Expect(
      !refresh.ShouldRefresh(
          peak::Source::kManual, 1u, true, start, false),
      "Manual must not poll DXGI");
  passed &= Expect(
      refresh.ShouldRefresh(
          peak::Source::kAutomatic, 1u, true, start, false),
      "first Auto frame must query immediately");
  passed &= Expect(
      !refresh.ShouldRefresh(
          peak::Source::kAutomatic,
          1u,
          true,
          start + std::chrono::milliseconds(999),
          false),
      "Auto must not poll before one second");
  passed &= Expect(
      refresh.ShouldRefresh(
          peak::Source::kAutomatic,
          1u,
          true,
          start + std::chrono::seconds(1),
          false),
      "Auto must refresh once per second");
  passed &= Expect(
      refresh.ShouldRefresh(
          peak::Source::kAutomatic,
          2u,
          true,
          start + std::chrono::seconds(1),
          false),
      "monitor changes must refresh immediately");
  passed &= Expect(
      refresh.ShouldRefresh(
          peak::Source::kAutomatic,
          2u,
          false,
          start + std::chrono::seconds(1),
          false),
      "HDR-state changes must refresh immediately");
  passed &= Expect(
      refresh.ShouldRefresh(
          peak::Source::kAutomatic,
          2u,
          false,
          start + std::chrono::seconds(1),
          true),
      "forced refresh must bypass the timer");
  refresh.Reset();
  passed &= Expect(
      refresh.ShouldRefresh(
          peak::Source::kAutomatic,
          2u,
          false,
          start + std::chrono::seconds(1),
          false),
      "reset must make the next Auto query immediate");

  std::cerr << (passed ? "PASS\n" : "FAIL\n");
  return passed ? 0 : 1;
}
