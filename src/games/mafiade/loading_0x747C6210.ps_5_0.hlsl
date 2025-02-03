#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[1];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : VDATA0,
  float4 v2 : VDATA1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
// sensor noise
  r1.x = cmp(0 < cb0[0].z);
  if (r1.x != 0) {
    r1.xy = cb0[0].xy + v0.xy;
    r1.xy = (int2)r1.xy;
    r1.xy = (int2)r1.xy & int2(63,63);
    r1.zw = float2(0,0);
    r1.xyz = t1.Load(r1.xyz).xyz;
    r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
      r2.rgb = renodx::math::SignSqrt(r0.rgb);
    r3.xyz = cb0[0].www + r2.xyz;
    r3.xyz = min(cb0[0].zzz, r3.xyz);
    r1.xyz = r1.xyz * r3.xyz * injectedData.fxNoise + r2.xyz;
      r0.rgb = renodx::color::gamma::DecodeSafe(r1.rgb, 2.f);
  }
  o0.xyzw = r0.xyzw;
  return;
}