#ifndef RENODX_RE6_COLOR_GRADE_HLSLI_
#define RENODX_RE6_COLOR_GRADE_HLSLI_

#include "./shared.h"

bool UseSceneHDR() {
  return RENODX_TONE_MAP_TYPE > 0.5f && RENODX_DIFFUSE_WHITE_NITS > 0.f
      && RENODX_PEAK_WHITE_NITS > RENODX_DIFFUSE_WHITE_NITS;
}

bool MatchOriginalCurve() {
  // Zero is the former padding value in already-built addons; negative is Off.
  return RENODX_ORIGINAL_CURVE_MATCHING >= 0.f;
}

float GameHDRExposureRatio(float4 native_factors) {
  if (!UseSceneHDR() || native_factors.x <= 0.f || !isfinite(native_factors.x)) return 1.f;
  // Older addons contain the previous quarter-strength history. Only consume
  // history when the addon explicitly marks the new, native-exposure filter.
  if (RENODX_CAMERA_EXPOSURE_READY == 1.f
      && RENODX_CAMERA_EXPOSURE > 0.f && isfinite(RENODX_CAMERA_EXPOSURE)) {
    // x is the camera exposure. z also includes the game's brightness scale,
    // which must remain outside temporal filtering.
    return max(RENODX_CAMERA_EXPOSURE, RE6_MIN_CAMERA_EXPOSURE) / max(native_factors.x, 1.e-20f);
  }
  // Enforce the same floor live even before the addon filter is rebuilt.
  return max(native_factors.x, RE6_MIN_CAMERA_EXPOSURE) / max(native_factors.x, 1.e-20f);
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
  float3 sampled = lerp(DecodeGameSRGB(SampleGameLutAtMipZero(table, a)),
      DecodeGameSRGB(SampleGameLutAtMipZero(table, b)), frac(texel));
  // The first texel represents x = 0.5/1024, not black. Continue to zero
  // across the missing half texel instead of holding its positive value.
  return sampled * saturate(address * 2048.f);
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

  // Preserve the authored lookup coordinates through the usable LUT range.
  // Beyond white, use one RGB scale and undo it after sampling to extend HDR
  // without changing the LUT's SDR-range shoulder or clipping each channel.
  float white_coordinate = min(GameLutWhiteCoordinate(table), 1023.5f / 1024.f);
  float maximum = max(address.r, max(address.g, address.b));
  float scale = 1.f;
  [branch]
  if (maximum > white_coordinate) {
    scale = white_coordinate / maximum;
  }
  float3 graded;
  [branch]
  if (MatchOriginalCurve()) {
    // Match the original point-sampled, UNORM-quantized authored curve.
    // The RGB proxy scale is undone, preserving upstream HDR beyond white.
    graded = DecodeGameSRGB(QuantizeGameLut(SampleGameLutAtMipZero(table, max(address, 0.f) * scale))) / scale;
  } else {
    graded = ApplyGameMidtoneSeparation(SampleGameLutLinear(table, max(address, 0.f) * scale) / scale);
  }
  return lerp(color, graded, strength);
}

#endif
