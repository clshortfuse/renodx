#include "../../tonemap.hlsl"

Texture3D<float4> t2 : register(t2);
Texture3D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

// DOOMBLADE

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  float3 lutInput = r0.xyz;
  if (injectedData.gammaSpace != 0.f) {
    lutInput = renodx::color::srgb::DecodeSafe(lutInput);
  }
  r1.xyz = handleUserLUT(lutInput, t2, s2_s, 0, injectedData.gammaSpace != 0.f ? 0 : 2);
  r2.xyz = handleUserLUT(lutInput, t1, s1_s, 0, injectedData.gammaSpace != 0.f ? 0 : 2);
  //r1.xyzw = t2.Sample(s2_s, r0.xyz).xyzw;
  //r2.xyzw = t1.Sample(s1_s, r0.xyz).xyzw;
  r1.xyz = -r2.xyz + r1.xyz;
  r1.xyz = cb0[2].xxx * r1.xyz + r2.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[2].yyy * r1.xyz + r0.xyz;
  if (injectedData.gammaSpace != 0.f) {
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  if(injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)){
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  } else if (injectedData.gammaSpace != 0.f) {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}