#include "./shared.h"

renodx::canvas::Context CreateDebugOverlayContext(
    float3 color,
    float2 screen_position,
    float2 cursor_position,
    float2 glyph_size,
    bool gamma_input = false) {
  float3 canvas_color = gamma_input
                            ? renodx::color::gamma::DecodeSafe(color, 2.2f)
                            : color;

  return renodx::canvas::CreateContext(
      screen_position + 0.5f,
      cursor_position,
      glyph_size,
      canvas_color,
      1.0f,
      1.0f.xxx,
      1.0f,
      1.0f,
      renodx::canvas::MODE_NORMAL,
      0.0f,
      1.18f);
}

void DrawDebugText(
    inout renodx::canvas::Context context,
    int a, int b = 0, int c = 0, int d = 0,
    int e = 0, int f = 0, int g = 0, int h = 0,
    int i = 0, int j = 0, int k = 0, int l = 0,
    int m = 0, int n = 0, int o = 0, int p = 0,
    int q = 0, int r = 0, int s = 0, int t = 0,
    int u = 0, int v = 0, int w = 0, int x = 0) {
  renodx::canvas::DrawDynamicText(context, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);
  renodx::canvas::DrawDynamicText(context, q, r, s, t, u, v, w, x);
}

void DrawDebugFloatRow(
    inout renodx::canvas::Context context,
    float value,
    int a, int b = 0, int c = 0, int d = 0,
    int e = 0, int f = 0, int g = 0, int h = 0,
    int i = 0, int j = 0, int k = 0, int l = 0,
    int m = 0, int n = 0, int o = 0, int p = 0,
    int q = 0, int r = 0, int s = 0, int t = 0,
    int u = 0, int v = 0, int w = 0, int x = 0) {
  DrawDebugText(context, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x);
  renodx::canvas::DrawText(context, ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, value, 0.0f, 5.0f);
  renodx::canvas::NewLine(context);
}

void DrawDebugIntegerRow(
    inout renodx::canvas::Context context,
    int value,
    int a, int b = 0, int c = 0, int d = 0,
    int e = 0, int f = 0, int g = 0, int h = 0,
    int i = 0, int j = 0, int k = 0, int l = 0,
    int m = 0, int n = 0, int o = 0, int p = 0,
    int q = 0, int r = 0, int s = 0, int t = 0,
    int u = 0, int v = 0, int w = 0, int x = 0) {
  DrawDebugText(context, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x);
  renodx::canvas::DrawText(context, ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawInteger(context, value);
  renodx::canvas::NewLine(context);
}

float3 GetDebugOverlayOutput(renodx::canvas::Context context, bool gamma_output = false) {
  float3 output = renodx::canvas::GetOutput(context).rgb;
  return gamma_output
             ? renodx::color::gamma::EncodeSafe(output, 2.2f)
             : output;
}

float ComputeMaxChCompressionScale(float3 untonemapped, float gray = 0.18f, float peak = 1.f, float clip = 100.f) {
  float max_channel = renodx::math::Max(untonemapped);
  float compressed_max_channel = renodx::math::Select(max_channel <= gray, max_channel, renodx::tonemap::Neutwo(max_channel, peak, clip, gray));
  float scale = renodx::math::DivideSafe(compressed_max_channel, max_channel, 1.f);

  return scale;
}

float3 RenderIntermediatePass(float3 color) {
  if (TONE_MAP_TYPE != 0.f) {
    color = renodx::color::gamma::DecodeSafe(color);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color);
  }
  return color;
}

float3 InvertIntermediatePass(float3 color) {
  if (TONE_MAP_TYPE != 0.f) {
    color = renodx::color::gamma::DecodeSafe(color);
    color /= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color);
  }
  return color;
}
