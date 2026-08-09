#include "../shared.h"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v3.xy / v3.ww;
  r0.xy = float2(1,1) + r0.xy;
  r0.x = 0.5 * r0.x;
  r0.z = -r0.y * 0.5 + 1;
  r0.xyzw = t1.Sample(s1_s, r0.xz).xyzw;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  o0.xyz = r1.xyz * v1.xyz + r0.xyz;
  r0.x = v1.w * r1.w;
  o0.w = r0.x;
  if(injectedData.isClamped > 1.f){
    o0 = saturate(o0);
  }
  return;
}