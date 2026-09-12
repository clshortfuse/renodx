#ifndef SRC_007FIRSTLIGHT_COMMON_HLSLI_
#define SRC_007FIRSTLIGHT_COMMON_HLSLI_

#include "./shared.h"

// Default GammaSafe (sRGB to gamma 2.2), with a C-infinity toe join.
// Matches the original outside |color| = [0.002, 0.006]. Zero retains its original C2 behavior.
#define CINFINITY_GAMMA_SAFE_GENERATOR(T, B)                                                                               \
  T CInfinityGammaSafe(T color) {                                                                                          \
    T magnitude = abs(color);                                                                                              \
    B in_transition = (magnitude > 0.002f) & (magnitude < 0.006f);                                                         \
    [branch]                                                                                                               \
    if (!any(in_transition)) {                                                                                             \
      return renodx::color::correct::GammaSafe(color);                                                                     \
    }                                                                                                                      \
    /* Compute the original result once, including channels outside the transition. */                                     \
    B in_srgb_toe = magnitude <= 0.0031308f;                                                                               \
    T shadow_encoded = 12.92f * magnitude;                                                                                 \
    T highlight_encoded = mad(1.055f, pow(magnitude, 1.f / 2.4f), -0.055f);                                                \
    T original_output = pow(renodx::math::Select(in_srgb_toe, shadow_encoded, highlight_encoded), 2.2f);                   \
    /* Keep inactive channels' blend arithmetic valid. */                                                                  \
    T blend_magnitude = renodx::math::Select(in_transition, magnitude, (T)0.004f);                                         \
    T t = (blend_magnitude - 0.002f) / (0.006f - 0.002f);                                                                  \
    T weight = exp(-abs(2.f * t - 1.f) / (t * (1.f - t)));                                                                 \
    T blend = renodx::math::Select(t < 0.5f, weight, (T)1.f) / (1.f + weight);                                             \
    /* Reuse the decoded original branch; only the other branch needs another power. */                                    \
    T other_output = pow(renodx::math::Select(                                                                             \
                             in_transition, renodx::math::Select(in_srgb_toe, highlight_encoded, shadow_encoded), (T)1.f), \
                         2.2f);                                                                                            \
    T smoothed_output = lerp(                                                                                              \
        original_output, other_output, renodx::math::Select(in_srgb_toe, blend, 1.f - blend));                             \
    return renodx::math::CopySign(renodx::math::Select(in_transition, smoothed_output, original_output), color);           \
  }

CINFINITY_GAMMA_SAFE_GENERATOR(float, bool)
CINFINITY_GAMMA_SAFE_GENERATOR(float3, bool3)
#undef CINFINITY_GAMMA_SAFE_GENERATOR

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

/// Identity through anchor to every derivative; then approaches peak
/// monotonically and concave down. Requires anchor < peak and compression_strength >= 1.
#define APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR(T)                                                      \
  T ApplyAnchoredCInfinityShoulder(T color, T peak, T anchor = 0.18f, float compression_strength = 1.5f) { \
    T shoulder_range = peak - anchor;                                                                      \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                  \
    T flat_weight = exp2(-shoulder_range / (compression_strength * distance_from_anchor));                 \
    T response_denominator = mad(distance_from_anchor, flat_weight, shoulder_range);                       \
    return mad(shoulder_range, distance_from_anchor / response_denominator, color - distance_from_anchor); \
  }

APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR(float)
APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR(float3)
#undef APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR

float ApplyAnchoredCInfinityShoulderMaxChannelScale(float3 color, float peak = 1.f, float anchor = 0.18f, float compression_strength = 1.5f) {
  float max_channel = renodx::math::Max(abs(color));
  float compressed_max = ApplyAnchoredCInfinityShoulder(max_channel, peak, anchor, compression_strength);
  return renodx::math::DivideSafe(compressed_max, max_channel, 1.f);
}

static const float3x3 BT709_TO_BT2020_EXPANDED_BT709_MAT = float3x3(
    0.9773816772f, 0.0112560072f, 0.0113623156f,
    0.0060849375f, 0.9825527470f, 0.0113623156f,
    0.0060849375f, 0.0112560072f, 0.9826590553f);

static const float3x3 BT2020_EXPANDED_BT709_TO_BT709_MAT = float3x3(
    1.0232867278f, -0.0115886389f, -0.0116980889f,
    -0.0062647564f, 1.0179628453f, -0.0116980889f,
    -0.0062647564f, -0.0115886389f, 1.0178533953f);

static const float3x3 BT709_TO_XFYFZF_EXPANDED_BT709_MAT = float3x3(
    0.9416502419f, 0.0286279843f, 0.0297217737f,
    0.0166682791f, 0.9536099471f, 0.0297217737f,
    0.0166682791f, 0.0286279843f, 0.9547037366f);

static const float3x3 XFYFZF_EXPANDED_BT709_TO_BT709_MAT = float3x3(
    1.0630820496f, -0.0309497757f, -0.0321322739f,
    -0.0180201126f, 1.0501523865f, -0.0321322739f,
    -0.0180201126f, -0.0309497757f, 1.0489698883f);

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

#endif  // SRC_007FIRSTLIGHT_COMMON_HLSLI_
