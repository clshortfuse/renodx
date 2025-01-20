#include "./shared.h"

cbuffer GammaBuffer : register(b7) {
  float4 gammaValue : packoffset(c0);
}

SamplerState BilinearSampler_s : register(s1);
Texture2D<float4> InstanceTexture0 : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    out float4 o0: SV_Target0) {
  const float4 icb[] = { { 0, 7.000000, 15.000000, 0 },
                         { 3.000000, 4.000000, 12.000000, 0 },
                         { 15.000000, 8.000000, 0, 0 },
                         { 12.000000, 11.000000, 3.000000, 0 },
                         { 10.000000, 13.000000, 5.000000, 0 },
                         { 14.000000, 9.000000, 1.000000, 0 },
                         { 5.000000, 2.000000, 10.000000, 0 },
                         { 1.000000, 6.000000, 14.000000, 0 },
                         { 7.000000, 0, 8.000000, 0 },
                         { 4.000000, 3.000000, 11.000000, 0 },
                         { 8.000000, 15.000000, 7.000000, 0 },
                         { 11.000000, 12.000000, 4.000000, 0 },
                         { 13.000000, 10.000000, 2.000000, 0 },
                         { 9.000000, 14.000000, 6.000000, 0 },
                         { 2.000000, 5.000000, 13.000000, 0 },
                         { 6.000000, 1.000000, 9.000000, 0 } };
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (uint2)v0.xy;
  r0.y = (uint)r0.y << 2;
  r0.xy = (int2)r0.xy & int2(3, 12);
  r0.x = (int)r0.x | (int)r0.y;
  r0.x = icb[r0.x + 0].x + 0.5;
  r0.x = r0.x * 0.0625 + -0.5;
  r1.xyzw = InstanceTexture0.Sample(BilinearSampler_s, v2.xy).xyzw;
  float3 original = r1.rgb;
  o0.rgb = original;

  o0.w = r1.w;
  if (CUSTOM_SCAN_LINES != 0) {
    // r0.yzw = log2(r1.xyz);
    // r0.yzw = gammaValue.xxx * r0.yzw;
    // r0.yzw = exp2(r0.yzw);
    r0.yzw = renodx::math::SignPow(r1.xyz, gammaValue.x);

    o0.xyz = r0.xxx * float3(0.00390625, 0.00390625, 0.00390625) + r0.yzw;

    o0.rgb = lerp(original, o0.rgb, CUSTOM_SCAN_LINES);
  }

  if (CUSTOM_IS_SWAPCHAIN_WRITE) {
    o0.rgb = renodx::draw::SwapChainPass(o0.rgb);
  }

  return;
}
