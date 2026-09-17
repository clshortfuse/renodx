#include "../../tonemap.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = cb0[3].xyz * cb0[3].xyz;
  r1.xyzw = t0.Sample(s1_s, v0.xy).xyzw;
  r2.xyz = float3(1,1,1) + -r1.xyz;
  r2.xyz = r2.xyz * float3(0.00999999978,0.00999999978,0.00999999978) + r1.xyz;
  r0.xyz = r0.xyz * r2.xyz + -r1.xyz;
  r0.xyz = cb0[3].www * r0.xyz + r1.xyz;
  o0.w = r1.w;
  r1.xyz = float3(1,1,1) + -r0.xyz;
  r1.xyz = r1.xyz + r1.xyz;
  r2.xyz = float3(1,1,1) + -cb0[5].xyz;
  r1.xyz = -r1.xyz * r2.xyz + float3(1,1,1);
  r2.xyz = cb0[5].xyz * r0.xyz;
  r0.xyz = cmp(r0.xyz >= float3(0.5,0.5,0.5));
  r0.xyz = r0.xyz ? float3(1,1,1) : 0;
  r1.xyz = -r2.xyz * float3(2,2,2) + r1.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  r0.xyz = r0.xyz * r1.xyz + r2.xyz;
  r1.xyzw = t2.Sample(s2_s, v0.xy).xyzw * injectedData.fxLens;
  r2.xyzw = t1.Sample(s0_s, v0.xy).xyzw * injectedData.fxBloom;
  r1.xyz = saturate(-r2.xyz + r1.xyz);
  r1.xyz = r1.xyz + r2.xyz;
  r0.w = 1 + cb0[5].w;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  if(injectedData.gammaSpace != 0.f){
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  } else if (injectedData.gammaSpace != 0.f) {
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}