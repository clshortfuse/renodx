#include "./common.hlsl"

Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : VDATA0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t3.Sample(s0_s, v1.xy).w;
  r0.yzw = t4.Sample(s0_s, v1.xy).xyz;
  r0.x = saturate(4 * r0.x);
  r1.x = t1.Sample(s0_s, v1.xy).x;
  r1.x = cb0[0].y * r1.x;
  r1.x = cb0[1].y / r1.x;
  r1.x = -cb0[1].x + r1.x;
  r1.yzw = t5.Sample(s0_s, v1.xy).xyz;
  r1.x = saturate(-1666.66675 * r1.x);
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.yzw = -r2.xyz + r1.yzw;
  r1.xyz = r1.xxx * r1.yzw + r2.xyz;
  r0.yzw = -r1.xyz + r0.yzw;
  r2.xyz = r0.xxx * r0.yzw + r1.xyz;
  // Sensor Noise
  r0.x = cmp(0 < cb0[2].z);
  if (r0.x != 0) {
    r0.xy = cb0[2].xy + v0.xy;
    r0.xy = (int2)r0.xy;
    r0.xy = (int2)r0.xy & int2(63,63);
    r0.zw = float2(0,0);
    r0.xyz = t2.Load(r0.xyz).xyz;
    r0.xyz = r0.xyz * float3(2,2,2) + float3(-1,-1,-1);
      r1.rgb = renodx::math::SignSqrt(r2.rgb);
    r3.xyz = cb0[2].www + r1.xyz;
    r3.xyz = min(cb0[2].zzz, r3.xyz);
    r0.xyz = r0.xyz * r3.xyz * injectedData.fxNoise + r1.xyz;
      r2.rgb = renodx::color::gamma::DecodeSafe(r0.rgb, 2.f);
  }
      r2.rgb = PostToneMapScale(r2.rgb);
  o0.xyzw = r2.xyzw;
  return;
}