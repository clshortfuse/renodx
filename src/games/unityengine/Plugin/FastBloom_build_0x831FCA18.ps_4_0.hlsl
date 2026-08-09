#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if(injectedData.isClamped != 0.f){
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = rolloffSdr(r0.xyz);
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  if(injectedData.isClamped != 0.f){
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r1.xyz = rolloffSdr(r1.xyz);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  if(injectedData.isClamped != 0.f){
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r1.xyz = rolloffSdr(r1.xyz);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, w2.xy).xyzw;
  if(injectedData.isClamped != 0.f){
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r1.xyz = rolloffSdr(r1.xyz);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw * float4(0.25,0.25,0.25,0.25) + -cb0[3].zzzz;
  r0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  o0.xyzw = cb0[3].wwww * r0.xyzw * injectedData.fxBloom;
  return;
}