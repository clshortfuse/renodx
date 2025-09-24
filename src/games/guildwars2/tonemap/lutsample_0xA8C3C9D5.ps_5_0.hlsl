#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[1];
}

void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t1.Sample(s1_s, w0.xy).xyz;
  r0.xyz = cb0[0].xyz * r0.xyz * injectedData.fxBloom;
  r1.xyz = applyCA(t0, s0_s, v0, injectedData.fxCA);
  if(injectedData.toneMapType == 0.f){
    r0.xyz = -r0.xyz * float3(2,2,2) + float3(1,1,1);
    r1.xyz = float3(1,1,1) + -r1.xyz;
    r0.xyz = -r1.xyz * r0.xyz + float3(1,1,1);
  } else {
    r0.xyz = r1.xyz + ((r0.xyz * 2.f) / (1 + r1.xyz));
  }
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r0.rgb = applyVignette(r0.rgb, v0, injectedData.fxVignette);
  r0.rgb = applyUserTonemap(r0.rgb, t2, s2_s);
  o0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
  o0.w = 0;
  return;
}