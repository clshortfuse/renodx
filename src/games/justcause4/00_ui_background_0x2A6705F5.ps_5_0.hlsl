#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_Position0, float4 v1 : COLOR0, float2 v2 : TEXCOORD0, float2 w2 : TEXCOORD2, nointerpolation uint v3 : TEXCOORD1, out float4 o0 : SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 x0[6];
  x0[0].x = 0;
  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyz = r0.xyz * w2.x + w2.y;
  x0[1].x = r0.x;
  x0[2].x = r0.y;
  x0[3].x = r0.z;
  x0[4].x = r0.w;
  x0[5].x = 1;
  r0.x = (int)v3.x & 255;
  r0.x = x0[r0.x + 0].x;
  if (8 == 0)
    r1.x = 0;
  else if (8 + 8 < 32) {
    r1.x = (uint)v3.x << (32 - (8 + 8));
    r1.x = (uint)r1.x >> (32 - 8);
  } else
    r1.x = (uint)v3.x >> 8;
  if (8 == 0)
    r1.y = 0;
  else if (8 + 16 < 32) {
    r1.y = (uint)v3.x << (32 - (8 + 16));
    r1.y = (uint)r1.y >> (32 - 8);
  } else
    r1.y = (uint)v3.x >> 16;
  r0.y = x0[r1.x + 0].x;
  r0.z = x0[r1.y + 0].x;
  r0.xyz = v1.xyz * r0.xyz;
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  r0.w = (uint)v3.x >> 24;
  r0.w = x0[r0.w + 0].x;
  r0.w = v1.w * r0.w;
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection
               ? pow(o0.rgb, 2.2f)
               : renodx::color::srgb::Decode(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
