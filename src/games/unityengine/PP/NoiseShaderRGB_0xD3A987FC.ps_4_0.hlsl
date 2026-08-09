#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v2.xy + v2.zw;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r1.xyzw = v2.xyxy * float4(0.015625,0.015625,0.125,0.125) + v2.zwzw;
  r2.xyzw = t1.Sample(s1_s, r1.zw).xyzw;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r0.x = dot(float4(1,0.75,0.5,0.25), r0.xyzw);
  r0.x = frac(r0.x);
  r0.x = r0.x * 2 + -1;
  r0.x = r0.x * abs(r0.x);
  r0.x = cb0[5].x * r0.x * injectedData.fxNoise;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = r1.xyz * float3(4,4,4);
  r0.xyz = r1.xyz + r0.xxx;
  r2.xyzw = t2.Sample(s2_s, w1.xy).xyzw;
  r2.xyz = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.xyz = r2.xyz * cb0[5].yyy + r0.xyz;
  o0.xyzw = float4(0.25,0.25,0.25,1) * r1.xyzw;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}