// ---- Created with 3Dmigoto v1.3.16 on Mon May 18 11:44:33 2026
// HDR-safe highlight / bloom mask version.
// Original behavior:
//   luma -> threshold -> saturate mask -> smoothstep -> constant color output
//
// HDR change:
//   Keep the original saturate mask shape, but multiply by a soft HDR intensity
//   factor based on source luminance above 1.0.
// This avoids clamping highlight contribution to pure SDR strength.

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[130];
}

// 3Dmigoto declarations
#define cmp -

#ifndef RENODX_HDR_BLOOM_EXTRA_STRENGTH
// 0.00 = original SDR-style behavior
// 0.25 = subtle HDR bloom response
// 0.50 = moderate HDR bloom response
// 1.00 = strong HDR bloom response
#define RENODX_HDR_BLOOM_EXTRA_STRENGTH 0.50
#endif

#ifndef RENODX_HDR_BLOOM_EXTRA_MAX
// Safety cap for the extra HDR bloom multiplier.
#define RENODX_HDR_BLOOM_EXTRA_MAX 4.0
#endif

float GetHDRBloomExtra(float luma)
{
  // Only add extra strength once the source is above SDR white.
  float hdrLuma = max(luma, 1.0);

  // Log response keeps it from exploding on very bright pixels.
  // luma 1  -> 1.0
  // luma 2  -> 1.5 at strength 0.5
  // luma 4  -> 2.0 at strength 0.5
  // luma 8  -> 2.5 at strength 0.5
  float extra = 1.0 + log2(hdrLuma) * RENODX_HDR_BLOOM_EXTRA_STRENGTH;

  return clamp(extra, 1.0, RENODX_HDR_BLOOM_EXTRA_MAX);
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Sample source color.
  r0.xyz = t0.Sample(s0_s, v1.xy).xyz;

  // Original luminance calculation.
  float luma = dot(float3(0.298999995, 0.587000012, 0.114), r0.xyz);

  // Original threshold normalization:
  // r0.x = luma - cb0[128].y;
  // r0.y = 1 / (1 - cb0[128].y);
  // r0.x = saturate(r0.x * r0.y);
  float threshold = cb0[128].y;
  float invRange = 1.0 / max(1.0 - threshold, 0.0001);

  float mask = saturate((luma - threshold) * invRange);

  // Original smoothstep curve:
  // r0.y = r0.x * -2 + 3;
  // r0.x = r0.x * r0.x;
  // r0.x = r0.y * r0.x;
  mask = mask * mask * (3.0 - 2.0 * mask);

  // Original strength.
  float strength = cb0[128].x * mask;

  // HDR addition:
  // Preserve original mask, but allow brighter-than-SDR pixels to push bloom.
  float hdrExtra = GetHDRBloomExtra(luma);
  strength *= hdrExtra;

  // Original output:
  // o0.xyzw = cb0[129].xyzw * r0.xxxx;
  o0.xyzw = cb0[129].xyzw * strength.xxxx;

  return;
}