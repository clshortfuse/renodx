#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[33];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = saturate(cb0[28].xyxy * float4(-1,-1,1,-1) + v1.xyxy);
  r0.xyzw = cb0[26].xxxx * r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  if(injectedData.isClamped != 0.f){
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r1.xyz = rolloffSdr(r1.xyz);
    r0.xyz = rolloffSdr(r0.xyz);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = saturate(cb0[28].xyxy * float4(-1,1,1,1) + v1.xyxy);
  r1.xyzw = cb0[26].xxxx * r1.xyzw;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  if(injectedData.isClamped != 0.f){
    r2.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r2.xyz) : r2.xyz;
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r2.xyz = rolloffSdr(r2.xyz);
    r1.xyz = rolloffSdr(r1.xyz);
    r2.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r2.xyz) : r2.xyz;
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r0.xyzw = float4(0.25,0.25,0.25,0.25) * r0.xyzw;
  r0.xyzw = min(float4(65504,65504,65504,65504), r0.xyzw);
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = min(cb0[32].xxxx, r0.xyzw);
  r1.x = max(r0.x, r0.y);
  r1.x = max(r1.x, r0.z);
  r1.yz = -cb0[31].yx + r1.xx;
  r1.xy = max(float2(9.99999975e-05,0), r1.xy);
  r1.y = min(cb0[31].z, r1.y);
  r1.w = cb0[31].w * r1.y;
  r1.y = r1.w * r1.y;
  r1.y = max(r1.y, r1.z);
  r1.x = r1.y / r1.x;
  o0.xyzw = r1.xxxx * r0.xyzw;
  return;
}