#include "./tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
    if(injectedData.blitCopyHack >= 1.f){
      if(injectedData.gammaSpace != 0.f){
        r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
      }
      if (injectedData.blitCopyHack != 2.f && (injectedData.count2Old == injectedData.count2New)) {
        r0.xyz = applyUserNoTonemap(r0.xyz);
      }
      if(injectedData.gammaSpace != 0.f){
      if(injectedData.countOld == injectedData.countNew) {
        r0.xyz = PostToneMapScale(r0.xyz, true);
      } else {
        r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
      }
    } else if(injectedData.countOld == injectedData.countNew) {
      r0.xyz = PostToneMapScale(r0.xyz);
    }
    }
  o0.xyzw = cb0[3].xyzw * r0.xyzw;
  o0.w = saturate(o0.w);
  return;
}