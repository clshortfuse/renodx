#ifndef SRC_ONIMUSHA_COMMON_HLSLI_
#define SRC_ONIMUSHA_COMMON_HLSLI_

#include "./shared.h"

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

#endif  // SRC_ONIMUSHA_COMMON_HLSLI_