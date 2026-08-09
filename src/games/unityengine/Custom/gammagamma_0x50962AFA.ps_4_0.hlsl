#include "../tonemap.hlsl"

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
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyz = log2(r0.xyz);
  r1.xyz = cb0[3].xxx * r1.xyz;
  r0.xyz = exp2(r1.xyz);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, cb0[3].x);
  }
  r1.x = dot(r0.xyz, float3(0.219999999,0.707000017,0.0710000023));
  r1.x = min(1, r1.x);
  r1.x = r1.x * -cb0[3].y + cb0[3].y;
  o0.xyzw = r1.xxxx + r0.xyzw;
  o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
  o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
  o0.xyz = PostToneMapScale(o0.xyz, true);
  }
  return;
}