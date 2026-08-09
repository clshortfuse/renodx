#include "../../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[6].xy + cb0[6].zw;
  r0.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r1.xy = v2.xy * cb0[4].xy + cb0[4].zw;
  r1.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  if(injectedData.toneMapType == 0.f){
  r0.xyzw = -r0.xyzw * cb0[2].xxxx * injectedData.fxBloom + float4(1,1,1,1);
  r1.xyzw = float4(1,1,1,1) + -r1.xyzw;
  r0.xyzw = -r0.xyzw * r1.xyzw + float4(1,1,1,1);
  } else {
  r0.w = -r0.w * cb0[2].x * injectedData.fxBloom + 1.f;
  r1.w = 1.f + -r1.w;
  r0.w = -r0.w * r1.w + 1.f;
  r0.xyz = r1.xyz + ((r0.xyz * cb0[2].x * injectedData.fxBloom) / (1.f + r1.xyz));
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
    r0.xyz = PostToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  }
  o0.xyzw = r0.xyzw;
  o0.w = saturate(o0.w);
  return;
}