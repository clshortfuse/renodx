#include "../tonemap.hlsl"

Texture2DMS<float4> t0 : register(t0);
cbuffer cb0 : register(b0){
  float4 cb0[138];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  out float3 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r1.xyzw = float4(0,0,0,0);
  while (true) {
    r2.x = cmp((uint)r1.w >= asuint(cb0[134].x));
    if (r2.x != 0) break;
    r2.xyz = t0.Load(r0.xy, r1.w).xyz;
    r2.xyz = cb0[137].xxx * r2.xyz;
    r1.xyz = applyUserTonemapNeutral(r2.xyz) + r1.xyz;
    r1.w = (int)r1.w + 1;
  }
  r0.x = asint(cb0[134].x);
  o0.xyz = r1.xyz / r0.xxx;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}