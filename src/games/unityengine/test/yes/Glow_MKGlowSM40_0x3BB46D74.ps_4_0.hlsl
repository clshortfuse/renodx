#include "../../tonemap.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[14];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t4.Sample(s4_s, v1.xy, int2(0, 0)).xyzw;
  r0.xyz = cb0[8].yyy * r0.xyz;
  r1.xyzw = t3.Sample(s3_s, v1.xy, int2(0, 0)).xyzw;
  r0.xyz = r1.xyz * cb0[8].xxx + r0.xyz;
  r1.xyzw = t1.Sample(s1_s, v1.xy, int2(0, 0)).xyzw;
  r2.xyz = cb0[4].yyy * r1.xyz;
  r3.xyz = sqrt(r2.xyz);
  r1.xyz = r1.xyz * cb0[4].yyy + r3.xyz;
  o0.w = r1.w;
  r1.xyz = r1.xyz * float3(0.5,0.5,0.5) + -r2.xyz;
  r1.xyz = cb0[4].zzz * r1.xyz + r2.xyz;
  r0.xyz = r0.xyz * cb0[13].xxx + -r1.xyz;
  r0.xyz = cb0[7].xxx * r0.xyz + r1.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.xy = float2(0.5,0.5) + -v1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = rsqrt(r0.w);
  r1.xy = r1.xy * r0.ww;
  r1.zw = -r1.xy * v2.xy + v1.xy;
  r1.xy = r1.xy * v2.xy + v1.xy;
  r2.xyzw = t2.Sample(s2_s, r1.xy, int2(0, 0)).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw, int2(0, 0)).xyzw;
  r2.x = r1.x;
  r1.xyzw = t2.Sample(s2_s, v1.xy, int2(0, 0)).xyzw;
  r2.y = r1.y;
  r0.xyz = r2.xyz + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy, int2(0, 0)).xyzw;
  o0.xyz = r1.xyz + r0.xyz;
  if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f) {
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}