#include <windows.h>

#include <cmath>
#include <iostream>
#include <limits>

#include "src/utils/swapchain.hpp"

extern "C" __declspec(dllexport) bool ReShadeRegisterAddon(void*, uint32_t) {
  return true;
}

extern "C" __declspec(dllexport) void ReShadeUnregisterAddon(void*) {}

extern "C" __declspec(dllexport) void ReShadeLogMessage(void*, int, const char*) {}

namespace {

bool Expect(bool condition, const char* message) {
  if (condition) return true;
  std::cerr << "FAIL: " << message << '\n';
  return false;
}

}  // namespace

int main() {
  namespace swapchain = renodx::utils::swapchain;
  bool passed = true;

  DXGI_OUTPUT_DESC1 output = {};
  output.ColorSpace = DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020;
  output.MaxLuminance = 1033.f;
  const auto peak = swapchain::GetPeakNits(output);
  passed &= Expect(peak.has_value() && *peak == 1033.f,
                   "valid HDR10 MaxLuminance must be accepted");

  output.ColorSpace = DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709;
  passed &= Expect(swapchain::GetPeakNits(output).has_value(),
                   "linear HDR/WCG desktop output must be accepted");

  output.ColorSpace = DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709;
  passed &= Expect(!swapchain::GetPeakNits(output).has_value(),
                   "SDR desktop output must be rejected");

  output.ColorSpace = DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020;
  for (const float invalid_peak : {
           47.999f,
           4000.001f,
           std::numeric_limits<float>::infinity(),
           std::numeric_limits<float>::quiet_NaN(),
       }) {
    output.MaxLuminance = invalid_peak;
    passed &= Expect(!swapchain::GetPeakNits(output).has_value(),
                     "invalid MaxLuminance must be rejected");
  }

  output.MaxLuminance = 48.f;
  passed &= Expect(swapchain::GetPeakNits(output).value_or(0.f) == 48.f,
                   "lower peak boundary must be accepted");
  output.MaxLuminance = 4000.f;
  passed &= Expect(swapchain::GetPeakNits(output).value_or(0.f) == 4000.f,
                   "upper peak boundary must be accepted");

  passed &= Expect(
      !swapchain::GetDirectXOutputDesc1(static_cast<HMONITOR>(nullptr)).has_value(),
      "null monitor must not start DXGI discovery");
  passed &= Expect(
      !swapchain::GetDirectXOutputDesc1(static_cast<HWND>(nullptr)).has_value(),
      "null window must not start DXGI discovery");
  passed &= Expect(!swapchain::GetPeakNits(static_cast<HWND>(nullptr)).has_value(),
                   "null window must not report a peak");

  std::cerr << (passed ? "PASS\n" : "FAIL\n");
  return passed ? 0 : 1;
}
