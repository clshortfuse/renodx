#include "../tonemap.hlsl"

Texture3D<float4> t2 : register(t2);
Texture3D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.w = 0;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  //r1.xyzw = saturate(r1.xyzw);
  r1.w = saturate(r1.w);
  /*r2.xyz = r1.xyz * cb0[3].xxx + cb0[3].yyy;
  r3.xyzw = t1.Sample(s1_s, r2.xyz).xyzw;
  r2.xyzw = t2.Sample(s2_s, r2.xyz).xyzw;*/
  r2.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
  r3.xyz = handleUserLUT(r2.xyz, t1, s1_s, 0.5 / cb0[3].y, injectedData.gammaSpace != 0.f ? 0 : 2);
  r2.xyz = handleUserLUT(r2.xyz, t2, s2_s, 0.5 / cb0[3].y, injectedData.gammaSpace != 0.f ? 0 : 2);
  r0.xyz = r3.xyz + -r2.xyz;
  r2.w = r1.w;
  r0.xyzw = cb0[2].xxxx * r0.xyzw + r2.xyzw;
  r0.xyzw = r0.xyzw + -r1.xyzw;
  o0.xyzw = cb0[3].zzzz * r0.xyzw + r1.xyzw;
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