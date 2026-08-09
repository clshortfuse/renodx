#include "../../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v2.zw).xyzw;
  r0.xyz = float3(0,1,0) * r0.xyz;
  r1.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r0.xyz = r1.xyz * float3(1,0,0) + r0.xyz;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r0.xyz = r1.xyz * float3(0,0,1) + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if (injectedData.countOld == injectedData.countNew) {
    r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.w = dot(saturate(r1.xyz), float3(0.219999999,0.707000017,0.0710000023));
  r0.w = -cb0[8].x + r0.w;
  r2.xy = saturate(cb0[8].yz * r0.ww);
  r0.w = dot(cb0[6].zy, r2.xy);
  r0.w = max(0, r0.w);
  r0.w = cb0[6].x + r0.w;
  r2.xyz = cb0[4].xyz * r0.www * injectedData.fxFilmGrain;
  r0.xyz = r2.xyz * r0.xyz + float3(0.5,0.5,0.5);
  r0.xyz = saturate(r0.xyz);
  r2.xyz = float3(1,1,1) + -r0.xyz;
  if(injectedData.toneMapType == 0.f){
  r1.xyz = saturate(r1.xyz);
  }
  o0.w = r1.w;
  if(injectedData.fxFilmGrainType == 0.f){
  r3.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r3.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
  r2.xyz = -r3.xyz * r2.xyz + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = r1.xyz >= float3(0.5,0.5,0.5) ? float3(0,0,0) : r0.xyz;
  r1.xyz = r1.xyz >= float3(0.5,0.5,0.5) ? float3(1,1,1) : 0;
  r0.xyz = r0.xyz + r0.xyz;
  r0.xyz = r1.xyz * r2.xyz + r0.xyz;
  } else {
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r0.xyz = applyFilmGrain(r1.xyz, v1);
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = PostToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  }
  o0.xyz = r0.xyz;
  return;
}