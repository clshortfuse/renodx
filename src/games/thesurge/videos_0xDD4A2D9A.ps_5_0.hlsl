#include "./common.hlsl"

cbuffer PER_FRAME : register(b0){
  float4 time_parameters : packoffset(c0);
  float4 color_parameters2 : packoffset(c1);
}

SamplerState sampler_bilinear_wrap_s : register(s2);
Texture2D<float4> map0Sampler : register(t0);
Texture2D<float4> map1Sampler : register(t1);
Texture2D<float4> map2Sampler : register(t2);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : Color0,
  float4 v2 : Texcoord0,
  float2 v3 : Texcoord1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = map0Sampler.Sample(sampler_bilinear_wrap_s, v2.xy).w;
  r0.y = map1Sampler.Sample(sampler_bilinear_wrap_s, v2.xy).w;
  r0.z = map2Sampler.Sample(sampler_bilinear_wrap_s, v2.xy).w;
  r0.xyz = float3(-0.0625,-0.5,-0.5) + r0.xyz;
  r1.x = saturate(dot(r0.xz, float2(1.16400003,1.59599996)));
  r1.y = saturate(dot(r0.xyz, float3(1.16400003,-0.39199999,-0.813000023)));
  r1.z = saturate(dot(r0.xy, float2(1.16400003,2.01699996)));
  r0.xyz = log2(r1.xyz);
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = saturate(v1.xyz * r0.xyz);
  o0.xyz = color_parameters2.www * r0.xyz;
  o0.w = v1.w;
  if(injectedData.fxHDRVideos == 1.f){
    o0.rgb = InverseToneMapBT2446a(o0.rgb);
  } else {
    o0.rgb = InverseToneMapCustom(o0.rgb, injectedData.fxHDRVideos);
  }
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}