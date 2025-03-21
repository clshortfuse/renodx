#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Mar 21 00:58:54 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.xyzw = r0.wxyz * v1.wxyz + float4(-0.00999999978,-0.5,-0.5,-0.5);
  r0.xyzw = v1.wxyz * r0.wxyz;
  r1.x = cmp(r1.x < 0);
  r1.yzw = -r1.yzw * float3(2,2,2) + float3(1,1,1);
  if (r1.x != 0) discard;
  r2.xy = v3.xy / v3.ww;
  r2.xy = float2(1,1) + r2.xy;
  r2.x = 0.5 * r2.x;
  r2.z = -r2.y * 0.5 + 1;
  r2.xyzw = t1.Sample(s1_s, r2.xz).xyzw;
  r1.xyz = r2.xyz / r1.yzw;
  r2.xyz = float3(1,1,1) + -r2.xyz;
  r3.xyz = r0.yzw + r0.yzw;
  r2.xyz = r2.xyz / r3.xyz;
  r2.xyz = float3(1,1,1) + -r2.xyz;
  r0.yzw = cmp(float3(0.5,0.5,0.5) < r0.yzw);
  o0.w = r0.x;
  o0.xyz = r0.yzw ? r1.xyz : r2.xyz;

  if (RENODX_TONE_MAP_TYPE == 0) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}