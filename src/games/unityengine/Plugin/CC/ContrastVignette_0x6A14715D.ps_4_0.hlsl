#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[8].xy + v1.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.y = cb0[6].y + cb0[6].x;
  r0.x = r0.x * r0.y + -0.8;
  r0.y = cb0[6].x * 0.799 + -0.8;
  r0.y = 1 / r0.y;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.z = r0.y * r0.x + -1;
  r0.x = r0.y * r0.x;
  r0.y = -cb0[6].z * r0.z + 1;
  r0.y = -cb0[6].w + r0.y;
  r0.y = max(1, r0.y);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = -cb0[7].xyz + r1.xyz;
  o0.w = r1.w;
  r0.yzw = r1.xyz * r0.yyy + cb0[7].xyz;
  o0.xyz = r0.yzw * r0.xxx;
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