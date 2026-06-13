#ifndef RE9REQUIEM_COMMON_HLSLI
#define RE9REQUIEM_COMMON_HLSLI

#include "./shared.h"

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

void DrawLabel(
    inout renodx::canvas::Context context,
    int a, int b = 0, int c = 0, int d = 0,
    int e = 0, int f = 0, int g = 0, int h = 0,
    int i = 0, int j = 0, int k = 0, int l = 0,
    int m = 0, int n = 0, int o = 0, int p = 0) {
  renodx::canvas::DrawDynamicText(context, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);
}

void DrawFloatRow(
    inout renodx::canvas::Context context,
    float value,
    int a, int b = 0, int c = 0, int d = 0,
    int e = 0, int f = 0, int g = 0, int h = 0,
    int i = 0, int j = 0, int k = 0, int l = 0,
    int m = 0, int n = 0, int o = 0, int p = 0) {
  DrawLabel(context, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);
  renodx::canvas::DrawText(context, ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, value, 0.0f, 5.0f);
  renodx::canvas::NewLine(context);
}

float YfFromAP1(float3 ap1) {
  return renodx::color::yf::from::BT2020(renodx::color::bt2020::from::AP1(ap1));
}

#endif  // RE9REQUIEM_COMMON_HLSLI
