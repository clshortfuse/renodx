// ---- Created with 3Dmigoto v1.3.16 on Mon Aug 18 20:17:56 2025
#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

SamplerState s4_s : register(s4);

SamplerState s2_s : register(s2);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[17];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (!CUSTOM_IS_UI) discard;

  r0.xy = float2(0.0250000004,0.0500000007) * cb2[16].xx;
  r0.zw = cmp(r0.xy >= -r0.xy);
  r0.xy = frac(abs(r0.xy));
  r0.xy = r0.zw ? r0.xy : -r0.xy;
  r0.z = r0.y * 20 + -v2.y;
  r1.xy = v2.yy + -r0.xy;
  r0.x = 0.119999997 + r0.z;
  r0.y = r0.x * r0.x;
  r0.x = 1.60000002 * r0.x;
  r0.x = r0.y * -20 + r0.x;
  r0.x = saturate(30 * r0.x);
  r0.x = 1 + r0.x;
  r1.z = v2.x;
  r2.xyzw = t4.Sample(s4_s, r1.zx).xyzw;
  r0.y = t3.Sample(s2_s, r1.zy).x;
  r1.xyzw = saturate(r2.xyzw * r0.xxxx);
  r0.x = t2.Sample(s0_s, v2.xy).x;
  r0.x = saturate(r0.x * r0.y);
  o0.w = r1.w * r0.x;
  o0.xyz = r1.xyz;
  return;
}