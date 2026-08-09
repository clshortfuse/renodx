#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[50];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[45].xy + cb0[45].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r0.xyz = InvertToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  } else {
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
  }
  if(injectedData.isClamped != 0.f){
  r0.xyz = rolloffSdr(r0.xyz);
  }
  r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  r0.xyz = -cb0[49].yyy + r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(cb0[46].xxx, r0.xyz);
  r0.xyz = cb0[46].yyy * r0.xyz;
  r0.w = max(r0.x, r0.y);
  r1.x = max(9.99999997e-07, r0.z);
  r0.w = max(r1.x, r0.w);
  r0.w = min(1, r0.w);
  r0.w = 255 * r0.w;
  r0.w = ceil(r0.w);
  r0.w = 0.00392156886 * r0.w;
  o0.xyz = r0.xyz / r0.www;
  o0.w = r0.w;
  return;
}