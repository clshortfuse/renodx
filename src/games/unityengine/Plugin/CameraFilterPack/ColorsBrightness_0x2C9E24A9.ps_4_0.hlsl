#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -1 + cb0[2].x;
  r0.yz = v0.xy * cb0[3].xy + cb0[3].zw;
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  r0.xyz = r1.xyz + r0.xxx;
  r1.xyz = cb0[2].xxx * r1.xyz;
  o0.xyz = cb0[2].x < 1 ? r1.xyz : r0.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  o0.w = 1;
  return;
}