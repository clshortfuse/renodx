#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = applyCA(t0, s0_s, v0, injectedData.fxCA);
  r0.w = dot(r0.xyz, float3(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0));
  r1.xyz = r0.xyz / r0.www;
  r1.xyz = -cb0[2].xyz + r1.xyz;
  r0.w = dot(abs(r1.xyz), float3(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0));
  r0.w = min(1, r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r0.w * 0.999989986 + 9.99999975e-06;
  r0.w = pow(r0.w, cb0[2].w);
  r0.w = cb0[3].w * r0.w * injectedData.colorGradeTint;
  r1.x = renodx::color::y::from::BT709(r0.xyz);
  r0.xyz = lerp(r1.xxx, r0.xyz, lerp(1.f, cb0[1].w, injectedData.colorGradeTint));
  r0.xyz = lerp(r0.xyz, cb0[3].xyz * r1.xxx, r0.w);
  r1.xyz = t1.Sample(s1_s, w0.xy).xyz;
  r1.xyz = cb0[0].xyz * r1.xyz * injectedData.fxBloom;
  float3 altBloom = r0.rgb + r1.rgb;
  r0.rgb = lerp(float3(1,1,1), r1.rgb * 2.f, saturate(1.f - r0.rgb));
  if(injectedData.toneMapType != 0.f){
    float3 og = renodx::color::srgb::DecodeSafe(r0.xyz);
    r0.rgb = lerp(altBloom, r0.rgb, saturate(1.f - r1.rgb));
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
    r0.xyz = renodx::color::correct::Hue(r0.xyz, og, 0.81f, 1);
    r0.xyz = renodx::color::correct::Chrominance(r0.xyz, og, 1.f, 0.19f, 1);
  } else {
  r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  }
  if (!injectedData.isUnderWater) {
    r0.rgb = applyVignette(r0.rgb, v0, injectedData.fxVignette);
  }
  r0.rgb = applyUserTonemap(r0.rgb, t2, s2_s);
  o0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
  o0.w = 0;
  return;
}