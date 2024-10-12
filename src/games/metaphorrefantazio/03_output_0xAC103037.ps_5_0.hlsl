// ---- Created with 3Dmigoto v1.3.16 on Thu Sep 26 18:26:30 2024
#include "./tonemapper.hlsl"

SamplerState linearSampler_s : register(s0);
SamplerState nearestSampler_s : register(s1);
Texture2D<float4> colorTexture : register(t0);
Texture2D<float4> bloomTexture : register(t1);
Texture2D<float4> effectTexture : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = bloomTexture.Sample(linearSampler_s, v1.xy).xyzw;
  r1.xyzw = effectTexture.Sample(nearestSampler_s, v1.xy).xyzw;
  r2.xyzw = colorTexture.Sample(nearestSampler_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * r1.www + r1.xyz;
  o0.w = r2.w;
  o0.xyz = r0.xyz * r0.www + r1.xyz;

  o0.rgb = scaleLuminance(o0.rgb);
  return;
}