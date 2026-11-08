#ifndef RENODX_RE6_COLOR_GRADE_HLSLI_
#define RENODX_RE6_COLOR_GRADE_HLSLI_

#include "./shared.h"

bool UseSceneHDR() {
  return RENODX_TONE_MAP_TYPE > 0.5f && RENODX_DIFFUSE_WHITE_NITS > 0.f
      && RENODX_PEAK_WHITE_NITS > RENODX_DIFFUSE_WHITE_NITS;
}

float3 DecodeGameSRGB(float3 encoded) {
  return lerp(pow(max((encoded + 0.055f) * 0.947867274f, 0.f), 2.4f),
      encoded * 0.0773993805f, encoded <= 0.03928f);
}

float3 EncodeGameSRGB(float3 color) {
  return lerp(1.055f * pow(max(color, 0.f), 1.f / 2.4f) - 0.055f,
      12.92f * color, color <= 0.003131f);
}

float3 QuantizeGameLut(float3 encoded) {
  return floor(saturate(encoded) * 255.f + 0.5f) / 255.f;
}

float3 SampleGameLut(sampler2D table, float3 address) {
  return float3(tex2D(table, address.xx).r,
      tex2D(table, address.yy).g, tex2D(table, address.zz).b);
}

float3 SampleGameLutAtMipZero(sampler2D table, float3 address) {
  return float3(tex2Dlod(table, float4(address.r, 0.5f, 0.f, 0.f)).r,
      tex2Dlod(table, float4(address.g, 0.5f, 0.f, 0.f)).g,
      tex2Dlod(table, float4(address.b, 0.5f, 0.f, 0.f)).b);
}

float3 SampleGameLutLinear(sampler2D table, float3 address) {
  // Keep the game's point sampler and interpolate decoded texels ourselves.
  float3 texel = saturate(address) * 1024.f - 0.5f;
  float3 first = floor(texel);
  float3 a = (clamp(first, 0.f, 1023.f) + 0.5f) / 1024.f;
  float3 b = (clamp(first + 1.f, 0.f, 1023.f) + 0.5f) / 1024.f;
  return lerp(DecodeGameSRGB(SampleGameLutAtMipZero(table, a)),
      DecodeGameSRGB(SampleGameLutAtMipZero(table, b)), frac(texel));
}

// The nearest FP16 value below one can also be the encoded white plateau.
static const float kGameLutEncodedWhite = 0.99951171875f;

float GameLutWhiteCoordinate(sampler2D table) {
  const float2 last = float2(1023.5f / 1024.f, 0.5f);
  float3 edge = tex2Dlod(table, float4(last, 0.f, 0.f)).rgb;
  float3 previous = tex2Dlod(table, float4(last - float2(1.f / 1024.f, 0.f), 0.f, 0.f)).rgb;
  if (!all(edge >= kGameLutEncodedWhite && edge <= 1.f) || !all(previous == edge)) return 1.f;

  // Some authored curves hit white before the end of the table. The table
  // builder maps a white knot to white in all three channels.
  float low = 0.f;
  float high = 1023.f;
  [unroll]
  for (int i = 0; i < 10; ++i) {
    float middle = floor((low + high) * 0.5f);
    float2 uv = float2((middle + 0.5f) / 1024.f, 0.5f);
    if (all(tex2Dlod(table, float4(uv, 0.f, 0.f)).rgb >= edge)) {
      high = middle;
    } else {
      low = middle + 1.f;
    }
  }
  return low > 0.f ? (low + 0.5f) / 1024.f : 1.f;
}

float3 ExtendGameLutHighlights(float3 address, float3 graded, sampler2D table, float white_coordinate) {
  // Measure each authored curve just before its white point, after the builder's gamma.
  const float shoulder_width = 0.0625f;
  float edge_center = min(white_coordinate, 1023.5f / 1024.f);
  float near_edge = max(edge_center - shoulder_width, 0.5f / 1024.f);
  float3 inner = DecodeGameSRGB(tex2Dlod(table, float4(near_edge, 0.5f, 0.f, 0.f)).rgb);
  float3 edge = DecodeGameSRGB(tex2Dlod(table, float4(edge_center, 0.5f, 0.f, 0.f)).rgb);
  float3 slope = max((edge - inner) / max(edge_center - near_edge, 1.e-6f), 0.f);
  float3 excess = max(address - white_coordinate, 0.f);

  // Continue at the measured slope, then approach unit slope farther past the table.
  // Preserve the authored shoulder longer. A nearly flat early white point
  // still needs to recover slope promptly so it does not form a second plateau.
  float3 transition = lerp(0.125f, 1.6f, smoothstep(0.08f, 0.5f, slope));
  float3 shoulder = transition * (1.f - exp(-excess / transition));
  float3 extended = excess + (slope - 1.f) * shoulder;
  // Keep the LUT output scene-linear. The final tone mapper sets the display peak.
  return graded + extended;
}

float3 GameLutShoulderAddress(float3 address) {
  float y = renodx::color::y::from::BT709(max(address, 0.f));
  float3 early_shoulder = smoothstep(0.05f, 0.22f, address - y);

  // A channel can enter the shoulder before the pixel as a whole. Redistribute
  // that channel's lookup range while keeping both ends of the shoulder fixed.
  const float shoulder_start = 0.42f;
  const float shoulder_width = 1.f - shoulder_start;
  float3 t = saturate((address - shoulder_start) / shoulder_width);
  float3 bend = t * (1.f - t) * smoothstep(0.f, 0.4f, t) * (1.f - smoothstep(0.8f, 1.f, t));
  return address - (0.65f * shoulder_width) * early_shoulder * bend;
}

float3 ApplyGameMidtoneSeparation(float3 graded) {
  // Older add-ons leave this register at zero. Preview the default in that case.
  float setting = RENODX_MIDTONE_SEPARATION;
  float separation = setting == 0.f ? 0.25f : clamp(setting - 1.f, 0.f, 0.5f);
  float y = renodx::color::y::from::BT709(graded);
  // Keep the contrast adjustment uniform across the midtones, fading it
  // smoothly into black and scene white.
  float taper = smoothstep(0.f, 0.15f, y) * (1.f - smoothstep(0.85f, 1.f, y));
  float delta = (0.12f * separation) * (y - 0.18f) * taper;
  return graded * (1.f + delta / max(y, 1.e-6f));
}

float3 ApplyGameColorGrade(float3 color, float4x4 color_matrix, sampler2D table, float strength, bool hdr) {
  float3 address = mul(float4(color, 1.f), color_matrix).rgb;
  if (!hdr) {
    return lerp(color, DecodeGameSRGB(QuantizeGameLut(SampleGameLut(table, address))), strength);
  }

  strength *= saturate(RENODX_COLOR_GRADE_STRENGTH);
  if (strength <= 0.f) return color;

  float3 lookup = GameLutShoulderAddress(address);
  float3 graded = SampleGameLutLinear(table, lookup);
  [branch]
  float encoded_white_linear = DecodeGameSRGB(kGameLutEncodedWhite.xxx).r;
  if (any(lookup > 1.f) || any(graded >= encoded_white_linear)) {
    float white_coordinate = GameLutWhiteCoordinate(table);
    graded = ExtendGameLutHighlights(lookup, graded, table, white_coordinate);
  }
  return lerp(color, ApplyGameMidtoneSeparation(graded), strength);
}

#endif
