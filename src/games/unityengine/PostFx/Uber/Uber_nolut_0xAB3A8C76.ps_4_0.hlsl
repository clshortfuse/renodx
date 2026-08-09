#include "../../tonemap.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[17];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb1[6].x / cb1[6].y;
  r0.x = -1 + r0.x;
  r0.x = cb0[16].w * r0.x + 1;
  r0.yz = -cb0[15].xy + v1.xy;
  r0.yz = cb0[16].xx * abs(r0.yz) * min(1.f, injectedData.fxVignette);
  r0.x = r0.y * r0.x;
  r1.y = log2(r0.z);
  r1.x = log2(r0.x);
  r0.xy = cb0[16].zz * r1.xy;
  r0.xy = exp2(r0.xy);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = log2(r0.x);
  r0.x = cb0[16].y * r0.x * max(1.f, injectedData.fxVignette);
  r0.x = exp2(r0.x);
  r0.yzw = float3(1,1,1) + -cb0[14].xyz;
  r0.xyz = r0.xxx * r0.yzw + cb0[14].xyz;
  r1.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r2.xyzw = t1.Sample(s0_s, w1.xy).xyzw;
  r1.xyz = r2.xyz * r1.xxx;
  r1.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r1.xyz = handleUserLUT(r0.xyz, t2, s2_s, cb0[13].xyz);
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[13].www * r1.xyz + r0.xyz;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}