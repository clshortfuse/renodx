#include "./shared.h"

// Depth of field circle-of-confusion generator. Rome 2 takes the distorted UV,
// reconstructs view-space depth, then evaluates the filmic CoC falloff that is
// stored in the alpha channel for later blur passes.
// ---- Created with 3Dmigoto v1.4.1 on Thu Oct  9 18:21:06 2025

cbuffer camera_VS_PS : register(b0)
{
  float3 camera_position : packoffset(c0);
  float4x4 view : packoffset(c1);
  float4x4 projection : packoffset(c5);
  float4x4 view_projection : packoffset(c9);
  float4x4 inv_view : packoffset(c13);
  float4x4 inv_projection : packoffset(c17);
  float4x4 inv_view_projection : packoffset(c21);
  float4 camera_near_far : packoffset(c25);
  float time_in_sec : packoffset(c26);
  float2 g_inverse_focal_length : packoffset(c26.y);
  float g_vertical_fov : packoffset(c26.w);
  float4 g_screen_size : packoffset(c27);
  float g_vpos_texel_offset : packoffset(c28);
  float4 g_viewport_dimensions : packoffset(c29);
  float4 g_camera_temp0 : packoffset(c30);
  float4 g_camera_temp1 : packoffset(c31);
  float4 g_camera_temp2 : packoffset(c32);
  float4 g_clip_rect : packoffset(c33);
  float g_hide_foliage : packoffset(c34);
}

cbuffer depth_of_field_coc_PS : register(b1)
{
  float g_focus_distance : packoffset(c0);
  float g_focal_length : packoffset(c0.y);
  float g_coc_blur_kernel_scale : packoffset(c0.z);
}

SamplerState gbuffer_channel_4_sampler_s : register(s0);
SamplerState input_sampler_s : register(s1);
SamplerState distortion_sampler_s : register(s2);
Texture2D<float4> distortion_sampler : register(t0);
Texture2D<float4> gbuffer_channel_4_sampler : register(t1);
Texture2D<float4> input_sampler : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Convert the pixel position into UVs and apply refraction offsets so the CoC
  // lines up with the distorted colour buffer.
  r0.xy = g_vpos_texel_offset + v0.xy;
  r0.xy = g_screen_size.zw * r0.xy;
  r1.xyzw = distortion_sampler.SampleLevel(distortion_sampler_s, r0.xy, r0.y).xyzw;
  r0.zw = float2(-0.5,-0.5) + r1.xy;
  r0.zw = r0.zw * r1.zz;
  r0.xy = r0.zw * float2(0.0199999996,0.0199999996) + r0.xy;
  // Fetch depth to reconstruct clip-space position, and pull the pre-blurred
  // luminance at the same time so the alpha channel can be reused downstream.
  r1.xyzw = gbuffer_channel_4_sampler.SampleLevel(gbuffer_channel_4_sampler_s, r0.xy, 0).yzxw;
  r1.xy = r0.xy * float2(2,-2) + float2(-1,1);
  r0.xyzw = input_sampler.SampleLevel(input_sampler_s, r0.xy, r0.y).xyzw;
  o0.xyz = r0.xyz;
  r1.w = 1;
  // Map the reprojected depth into metres, clamp it to the configured focus
  // distance, and evaluate the filmic Gaussian falloff that Rome 2 expects.
  r0.x = dot(r1.xyzw, inv_projection._m02_m12_m22_m32);
  r0.y = dot(r1.xyzw, inv_projection._m03_m13_m23_m33);
  r0.x = r0.x / r0.y;
  r0.y = cmp(0 >= r0.x);
  r0.x = r0.y ? 1 : r0.x;
  r0.y = min(500, g_focus_distance);
  r0.x = r0.x + -r0.y;
  r0.x = r0.x * r0.x;
  r0.y = dot(g_focal_length, g_focal_length);
  r0.x = r0.x / r0.y;
  r0.x = -1.44269502 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = 1 + -r0.x;
  r0.y = 0.600000024 * g_coc_blur_kernel_scale;
  o0.w = saturate(r0.y * r0.x);
  return;
}