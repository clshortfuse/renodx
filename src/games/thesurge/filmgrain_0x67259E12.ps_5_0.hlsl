#include "./common.hlsl"

cbuffer PER_INSTANCE : register(b0){
  float4 rendertarget_size : packoffset(c0);
  float4 upsample_parameters : packoffset(c1);
}
cbuffer PER_FRAME : register(b1){
  float4 hdr_filmcurve_parameters : packoffset(c0);
  float4 hdr_exposure_parameters : packoffset(c1);
  float4 hdr_color_parameters0 : packoffset(c2);
  float4 hdr_color_parameters1 : packoffset(c3);
  float4 hdr_bloom_parameters0 : packoffset(c4);
  float4 hdr_bloom_parameters1 : packoffset(c5);
  float4 hdr_lightshaft_parameters0 : packoffset(c6);
  float4 hdr_lensflare_parameters0 : packoffset(c7);
  float4 dof_parameters0 : packoffset(c8);
  float4 dof_parameters1 : packoffset(c9);
  float4 chromashift_parameters : packoffset(c10);
  float4 unsharpmask_parameters : packoffset(c11);
  float4 filmgrain_parameters : packoffset(c12);
}
SamplerState sampler_bilinear_clamp_s : register(s3);
Texture2D<float4> sceneSampler : register(t0);
Texture2D<float4> grainNoiseSampler : register(t1);
Texture2D<float4> distortSampler : register(t2);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = rendertarget_size.zwzw * v0.xyxy;
  r1.xyz = distortSampler.SampleLevel(sampler_bilinear_clamp_s, r0.zw, 0).xyz;
  r1.w = dot(r1.xy, r1.xy);
  r1.w = sqrt(r1.w);
  r2.x = cmp(1 < r1.w);
  r3.xyzw = r1.xyxy / r1.wwww;
  r2.xyzw = r2.xxxx ? r3.xyzw : r1.xyxy;
  r0.xyzw = r2.xyzw * float4(0.100000001,0.100000001,0.100000001,0.100000001) + r0.xyzw;
  r1.x = r1.z * r1.w;
  r2.zw = sceneSampler.SampleLevel(sampler_bilinear_clamp_s, r0.zw, 0).zw;
  r1.yz = float2(0.5,0.5) + -r0.zw;
  r1.y = dot(r1.yz, r1.yz);
  r1.y = min(1, r1.y);
  r1.y = log2(r1.y);
  r1.y = chromashift_parameters.w * r1.y;
  r1.y = exp2(r1.y);
  r1.y = chromashift_parameters.x * r1.y;
  r1.yz = chromashift_parameters.zy * r1.yy;
  r1.x = r1.z * 0.00100000005 + r1.x;
  r0.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r0.xyzw;
  r1.z = dot(r0.zw, r0.zw);
  r1.y = r1.z * -r1.y + 1;
  r3.xyzw = r1.xxxx * float4(8,8,3,3) + float4(1,1,1,1);
  r1.xyzw = r3.xyzw * r1.yyyy;
  r0.xyzw = r1.xyzw * r0.xyzw + float4(0.5,0.5,0.5,0.5);
  r2.x = sceneSampler.Sample(sampler_bilinear_clamp_s, r0.xy).x;
  r2.y = sceneSampler.Sample(sampler_bilinear_clamp_s, r0.zw).y;
  r0.x = cmp(0 < filmgrain_parameters.x);
  if (r0.x != 0) {
    r0.xy = filmgrain_parameters.zw + v0.xy;
    r0.xy = (int2)r0.xy;
    r0.xy = (int2)r0.xy & int2(255,255);
    r0.zw = float2(0,0);
    r0.xyz = grainNoiseSampler.Load(r0.xyz).xyz;
    r0.xyz = r0.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r1.xyz = filmgrain_parameters.yyy + r2.xyz;
    r1.xyz = min(filmgrain_parameters.xxx, r1.xyz);
    r2.xyz = injectedData.fxFilmGrainType != 0.f ? applyFilmGrain(r2.rgb, v0.xy)
    : r0.xyz * r1.xyz * injectedData.fxFilmGrain + r2.xyz;
  }
  o0.xyzw = r2.xyzw;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}