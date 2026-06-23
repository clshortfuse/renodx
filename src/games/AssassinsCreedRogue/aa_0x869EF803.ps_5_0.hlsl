#include "./shared.h"

// ---- RenoDX-safe FXAA replacement
// Original shader was created with 3Dmigoto v1.3.16 on Sat May 16 11:26:48 2026

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb5 : register(b5)
{
  float4 cb5[1]; // cb5[0].xy = texel size
}

// -----------------------------------------------------------------------------
// RenoDX / HDR-safe FXAA config
// -----------------------------------------------------------------------------

#ifndef RENODX_FXAA_ENABLE
#define RENODX_FXAA_ENABLE 1
#endif

#ifndef RENODX_FXAA_EDGE_THRESHOLD
#define RENODX_FXAA_EDGE_THRESHOLD 0.125
#endif

#ifndef RENODX_FXAA_EDGE_THRESHOLD_MIN
#define RENODX_FXAA_EDGE_THRESHOLD_MIN 0.0312
#endif

#ifndef RENODX_FXAA_SUBPIXEL_STRENGTH
#define RENODX_FXAA_SUBPIXEL_STRENGTH 0.50
#endif

#ifndef RENODX_FXAA_MAX_SPAN
#define RENODX_FXAA_MAX_SPAN 8.0
#endif

#ifndef RENODX_FXAA_REDUCE_MUL
#define RENODX_FXAA_REDUCE_MUL 0.125
#endif

#ifndef RENODX_FXAA_REDUCE_MIN
#define RENODX_FXAA_REDUCE_MIN 0.0078125
#endif

static const float3 RENODX_LUMA = float3(0.2126, 0.7152, 0.0722);

// -----------------------------------------------------------------------------
// HDR-safe luma proxy
// -----------------------------------------------------------------------------
// Important:
// Do NOT use raw HDR green channel for FXAA edge detection.
// Bright HDR values can make the edge detector too aggressive and smear detail.
//
// This compresses HDR into an SDR-ish 0-1 range only for edge/luma decisions.
// The actual output color still samples the original HDR texture.

float3 RenoDX_FXAALumaProxy(float3 color)
{
  color = max(color, 0.0);

  // Simple cheap display-like compression.
  // This is only for edge detection, not final tone mapping.
  color = color / (1.0 + color);

  return saturate(color);
}

float RenoDX_FXAALumaFromColor(float3 color)
{
  return dot(RenoDX_FXAALumaProxy(color), RENODX_LUMA);
}

float RenoDX_FXAALuma(float2 uv)
{
  float3 color = t0.SampleLevel(s0_s, uv, 0).xyz;
  return RenoDX_FXAALumaFromColor(color);
}

float4 RenoDX_SampleHDR(float2 uv)
{
  // Preserve HDR source values.
  // Do not saturate or tone map here.
  return t0.SampleLevel(s0_s, uv, 0);
}

// -----------------------------------------------------------------------------
// Main
// -----------------------------------------------------------------------------

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
#if RENODX_FXAA_ENABLE == 0

  o0 = RenoDX_SampleHDR(v1.xy);
  return;

#else

  float2 uv = v1.xy;
  float2 texel = cb5[0].xy;

  float4 centerSample = RenoDX_SampleHDR(uv);
  float3 centerHDR = centerSample.xyz;

  // ---------------------------------------------------------------------------
  // HDR-safe luma samples
  // ---------------------------------------------------------------------------

  float lumaM  = RenoDX_FXAALumaFromColor(centerHDR);

  float lumaN  = RenoDX_FXAALuma(uv + float2(0.0, -texel.y));
  float lumaS  = RenoDX_FXAALuma(uv + float2(0.0,  texel.y));
  float lumaW  = RenoDX_FXAALuma(uv + float2(-texel.x, 0.0));
  float lumaE  = RenoDX_FXAALuma(uv + float2( texel.x, 0.0));

  float lumaNW = RenoDX_FXAALuma(uv + float2(-texel.x, -texel.y));
  float lumaNE = RenoDX_FXAALuma(uv + float2( texel.x, -texel.y));
  float lumaSW = RenoDX_FXAALuma(uv + float2(-texel.x,  texel.y));
  float lumaSE = RenoDX_FXAALuma(uv + float2( texel.x,  texel.y));

  float lumaMin = min(lumaM, min(min(lumaN, lumaS), min(lumaW, lumaE)));
  float lumaMax = max(lumaM, max(max(lumaN, lumaS), max(lumaW, lumaE)));
  float lumaRange = lumaMax - lumaMin;

  // Same idea as original FXAA:
  // skip pixels that do not have enough local contrast.
  float edgeThreshold = max(
    RENODX_FXAA_EDGE_THRESHOLD_MIN,
    lumaMax * RENODX_FXAA_EDGE_THRESHOLD
  );

  if (lumaRange < edgeThreshold)
  {
    // Preserve original HDR color and alpha.
    o0 = centerSample;
    return;
  }

  // ---------------------------------------------------------------------------
  // FXAA direction
  // ---------------------------------------------------------------------------

  float2 dir;

  dir.x = -((lumaNW + lumaNE) - (lumaSW + lumaSE));
  dir.y =  ((lumaNW + lumaSW) - (lumaNE + lumaSE));

  float dirReduce = max(
    (lumaNW + lumaNE + lumaSW + lumaSE) * (0.25 * RENODX_FXAA_REDUCE_MUL),
    RENODX_FXAA_REDUCE_MIN
  );

  float rcpDirMin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirReduce);

  dir = dir * rcpDirMin;
  dir = clamp(dir, -RENODX_FXAA_MAX_SPAN.xx, RENODX_FXAA_MAX_SPAN.xx);
  dir *= texel;

  // ---------------------------------------------------------------------------
  // Sample HDR color along the edge
  // ---------------------------------------------------------------------------
  // These samples are HDR-preserving. Only the luma tests use compressed luma.

  float3 rgbA =
    0.5 * (
      RenoDX_SampleHDR(uv + dir * (1.0 / 3.0 - 0.5)).xyz +
      RenoDX_SampleHDR(uv + dir * (2.0 / 3.0 - 0.5)).xyz
    );

  float3 rgbB =
    rgbA * 0.5 +
    0.25 * (
      RenoDX_SampleHDR(uv + dir * -0.5).xyz +
      RenoDX_SampleHDR(uv + dir *  0.5).xyz
    );

  float lumaB = RenoDX_FXAALumaFromColor(rgbB);

  float3 aaColor = ((lumaB < lumaMin) || (lumaB > lumaMax)) ? rgbA : rgbB;

  // Blend strength control.
  // Lower values preserve more native sharpness.
  aaColor = lerp(centerHDR, aaColor, saturate(RENODX_FXAA_SUBPIXEL_STRENGTH));

  // Preserve HDR and preserve original alpha.
  o0.xyz = max(aaColor, 0.0);
  o0.w = centerSample.w;

  return;

#endif
}