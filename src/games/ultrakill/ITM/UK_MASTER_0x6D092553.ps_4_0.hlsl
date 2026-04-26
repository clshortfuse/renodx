// ---- Created with 3Dmigoto v1.3.16 on Mon Feb 02 14:02:07 2026
#include "../shared.h"
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[11];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : COLOR2,
  float4 v3 : TEXCOORD0,
  float4 v4 : TEXCOORD1,
  float4 v5 : TEXCOORD2,
  float4 v6 : TEXCOORD9,
  float3 v7 : TEXCOORD10,
  out float4 o0 : SV_Target0,
  out float2 o1 : SV_Target1)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v3.xy / v4.ww;
  r0.xyzw = t0.SampleLevel(s0_s, r0.xy, 0).xyzw;
  r0.xyz = r0.xyz * v1.xyz + -v2.xyz;
  r0.w = v1.w * r0.w;
  r0.w = saturate(r0.w);
  o0.xyz = v2.www * r0.xyz + v2.xyz;
  r0.x = cb0[10].x * r0.w;
  r0.y = r0.w * cb0[10].x + -9.99999975e-005;
  r0.y = saturate(ceil(r0.y));
  o1.y = cb0[7].z * r0.y;
  o0.w = r0.x;
  r0.x = cb0[7].x ? 0.5 : 0;
  o1.x = max(cb0[7].y, r0.x);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float highlight_strength = 1.33f;
    o0.rgb = float3(
        renodx::color::grade::Highlights(o0.r, highlight_strength),
        renodx::color::grade::Highlights(o0.g, highlight_strength),
        renodx::color::grade::Highlights(o0.b, highlight_strength)
    );
  };
  return;
}