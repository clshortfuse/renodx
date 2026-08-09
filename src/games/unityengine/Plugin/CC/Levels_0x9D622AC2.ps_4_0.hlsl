#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[11];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyzw = -cb0[6].xyzw + r0.xyzw;
  r0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  r1.xyzw = cb0[7].xyzw + -cb0[6].xyzw;
  r0.xyzw = r0.xyzw / r1.xyzw;
  if(injectedData.toneMapType == 0.f){
  r0.xyzw = min(float4(1,1,1,1), r0.xyzw);
  r0.xyzw = log2(r0.xyzw);
  r1.xyzw = float4(1,1,1,1) / cb0[8].xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  } else {
    r0.x = renodx::math::SignPow(r0.x, 1 / cb0[8].x);
    r0.y = renodx::math::SignPow(r0.y, 1 / cb0[8].y);
    r0.z = renodx::math::SignPow(r0.z, 1 / cb0[8].z);
    r0.w = renodx::math::SignPow(r0.w, 1 / cb0[8].w);
  }
  r1.xyzw = cb0[10].xyzw + -cb0[9].xyzw;
  o0.xyzw = r0.xyzw * r1.xyzw + cb0[9].xyzw;
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