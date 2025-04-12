#include "./common.hlsl"

cbuffer PER_INSTANCE : register(b0){
  float4 rendertarget_size : packoffset(c0);
  float4 upsample_parameters : packoffset(c1);
}
cbuffer PER_STAGE : register(b1){
  float4 camera_clip_distances : packoffset(c0);
}
cbuffer PER_FRAME : register(b2){
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
SamplerState sampler_point_clamp_s : register(s1);
SamplerState sampler_bilinear_wrap_s : register(s2);
SamplerState sampler_bilinear_clamp_s : register(s3);
SamplerState sampler_trilinear_wrap_s : register(s4);
Texture2D<float4> sceneSampler : register(t0);
Texture2D<float4> bloomSampler : register(t1);
Texture2D<float4> lensFlareSampler : register(t2);
Texture2D<float4> depthSampler : register(t3);
Texture2D<float4> gaussBlurSampler : register(t4);
Texture2D<float4> vignetteSampler : register(t5);
Texture2D<float4> lensDirtSampler : register(t6);
Texture3D<float4> colorGradingLUTSampler : register(t7);
Texture2D<float4> motionBlurSampler : register(t8);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v0.xy;
  r1.xy = rendertarget_size.zw * v0.xy;
  r0.zw = float2(0,0);
  r0.xyzw = sceneSampler.Load(r0.xyz).xyzw;
  r2.xyzw = motionBlurSampler.SampleLevel(sampler_bilinear_clamp_s, r1.xy, 0).wxyz;
  r2.x = saturate(r2.x);
  r2.yzw = r2.yzw + -r0.xyz;
  r0.xyz = r2.xxx * r2.yzw + r0.xyz;
  r1.z = cmp(0 < dof_parameters0.z);
  if (r1.z != 0) {
    r1.z = depthSampler.SampleLevel(sampler_point_clamp_s, r1.xy, 0).x;
    r1.z = -camera_clip_distances.z + r1.z;
    r1.z = camera_clip_distances.w / r1.z;
    r1.z = r1.z / camera_clip_distances.y;
    r2.xyz = gaussBlurSampler.SampleLevel(sampler_bilinear_clamp_s, r1.xy, 0).xyz;
    r1.z = -dof_parameters0.x + r1.z;
    r1.z = abs(r1.z) / dof_parameters0.y;
    r1.z = saturate(dof_parameters0.z * r1.z);
    r2.xyz = r2.xyz + -r0.xyz;
    r0.xyz = r1.zzz * r2.xyz + r0.xyz;
  }
  r2.xyz = bloomSampler.SampleLevel(sampler_bilinear_clamp_s, r1.xy, 0).xyz;
  r2.xyz = hdr_bloom_parameters0.xyz * r2.xyz;
  r3.xyz = lensFlareSampler.SampleLevel(sampler_bilinear_clamp_s, r1.xy, 0).xyz;
  r2.xyz = r2.xyz * hdr_bloom_parameters0.www * injectedData.fxBloom + r3.xyz;
  r0.xyz = r2.xyz + r0.xyz;
  r3.xyz = lensDirtSampler.SampleLevel(sampler_bilinear_wrap_s, r1.xy, 0).xyz;
  r2.xyz = r3.xyz * r2.xyz;
  r0.xyz = r2.xyz * hdr_color_parameters1.yyy + r0.xyz;
  r1.xyz = vignetteSampler.SampleLevel(sampler_bilinear_clamp_s, r1.xy, 0).xyz;
  r1.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.xyz = -r1.www + r0.xyz;
  r0.xyz = hdr_color_parameters0.www * r0.xyz + r1.www;
  r0.xyz = hdr_color_parameters0.xyz * r0.xyz;
  r1.xyz = float3(1,1,1) + -r1.xyz;
  r1.xyz = -r1.xyz * hdr_color_parameters1.xxx * injectedData.fxVignette + float3(1,1,1);
  r1.xyz = r1.xyz * r0.xyz;
  r0.rgb = applyUserTonemap(r1.rgb, colorGradingLUTSampler, sampler_trilinear_wrap_s, hdr_filmcurve_parameters);
  o0.rgb = r0.rgb;
  o0.w = r0.w;
  return;
}