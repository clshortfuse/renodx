#include "../tonemap.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[32];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = saturate(cb0[28].xyxy * float4(-0.25,-0.25,0.25,-0.25) + v1.xyxy);
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = saturate(cb0[28].xyxy * float4(-0.25,0.25,0.25,0.25) + v1.xyxy);
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  r0.w = dot(r0.xyz, float3(0.0531499982,0.178800002,0.0180500001));
  r0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  r0.xyzw = cb0[31].yyyy * r0.xyzw * injectedData.fxBloom;
  r1.x = saturate(r0.w / cb0[31].z);
  r1.y = 0;
  r1.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r2.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  o0.xyz = r0.xyz * r1.xxx + r2.xyz;
  o0.w = r2.w;
  if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}