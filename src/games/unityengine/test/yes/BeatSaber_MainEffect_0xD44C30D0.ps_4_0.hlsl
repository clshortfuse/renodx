#include "../../tonemap.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(0.1,0.2) + v1.xy;
  r0.xy = r0.xy * cb0[2].xy + cb0[2].zz;
  r0.xyzw = t2.Sample(s0_s, r0.xy).xyzw;
  r0.x = -0.5 + r0.x;
  r0.x = 1.0 / 255.0 * r0.x;
  r1.xyzw = t1.Sample(s2_s, w1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[5].zzz * injectedData.fxBloom + r0.xxx;
  r1.xy = cb0[5].xy * float2(-0.5,0.5) + v1.xy;
  r1.xyzw = t0.Sample(s1_s, r1.xy).xyzw;
  r2.xyzw = cb0[5].xyxy * float4(0,-0.5,0.5,0.5) + v1.xyxy;
  r3.xyzw = t0.Sample(s1_s, r2.zw).xyzw;
  r2.xyzw = t0.Sample(s1_s, r2.xy).xyzw;
  r4.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r0.w = r4.w + r2.w;
  r0.w = r0.w + r3.w;
  r0.w = r0.w + r1.w;
  r0.w = 0.25 * r0.w;
  r0.w = r0.w * r0.w;
  r0.w = r0.w * cb0[2].w + -cb0[3].x;
  r1.xyz = r4.xyz + r0.www;
  if(injectedData.toneMapType == 0.f){
    r1.xyz = saturate(r1.xyz);
  }
  r4.xyz = r1.xyz + r0.xyz;
  o0.xyzw = cb0[6].xxxx * r4.xyzw;
  if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  } else if (injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}
