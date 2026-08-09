#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
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
  r1.xyz = cb0[7].xyz;
  r1.w = r0.w;
  r0.xyzw = r0.xyzw * cb0[6].xxxx + -r1.xyzw;
  r0.xyzw = r0.xyzw * cb0[6].yyyy + r1.xyzw;
  r0.w = saturate(r0.w);
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  r0.xyzw = log2(r0.xyzw);
  r0.xyzw = cb0[6].zzzz * r0.xyzw;
  o0.xyzw = exp2(r0.xyzw);
  } else {
    o0.xyzw = renodx::math::SignPow(r0.xyzw, cb0[6].z);
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}