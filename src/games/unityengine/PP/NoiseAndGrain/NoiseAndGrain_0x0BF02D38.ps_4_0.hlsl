#include "../../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

#define cmp -

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

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if(injectedData.toneMapType == 0.f){
  r2.xyz = saturate(r2.xyz);
  }
  o0.w = r2.w;
  if(injectedData.fxFilmGrainType == 0.f){
  r1.xyz = float3(1,1,1) + -r0.xyz;
  r3.xyz = float3(-0.5,-0.5,-0.5) + r2.xyz;
  r3.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
  r1.xyz = -r3.xyz * r1.xyz + float3(1,1,1);
  r3.xyz = cmp(r2.xyz >= float3(0.5,0.5,0.5));
  r2.xyz = r3.xyz ? float3(0,0,0) : r2.xyz;
  r3.xyz = r3.xyz ? float3(1,1,1) : 0;
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = r0.xyz + r0.xyz;
  o0.xyz = r3.xyz * r1.xyz + r0.xyz;
  } else {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r2.xyz) : r2.xyz;
    o0.xyz = applyFilmGrain(o0.xyz, v1);
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}