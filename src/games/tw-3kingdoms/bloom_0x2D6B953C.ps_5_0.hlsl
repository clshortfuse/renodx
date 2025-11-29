#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Oct 23 22:55:41 2025

cbuffer camera : register(b0)
{
  float3 camera_position : packoffset(c0);
  float3 prev_camera_position : packoffset(c1);
  float4x4 view : packoffset(c2);
  float4x4 projection : packoffset(c6);
  float4x4 view_projection : packoffset(c10);
  float4x4 prev_view_projection : packoffset(c14);
  float4x4 inv_view : packoffset(c18);
  float4x4 prev_inv_view : packoffset(c22);
  float4x4 inv_projection : packoffset(c26);
  float4x4 inv_view_projection : packoffset(c30);
  float4 camera_near_far : packoffset(c34);
  float time_in_sec : packoffset(c35);
  float prev_time_in_sec : packoffset(c35.y);
  float real_time_in_sec : packoffset(c35.z);
  float update_time_in_sec : packoffset(c35.w);
  float2 g_inverse_focal_length : packoffset(c36);
  float g_vertical_fov : packoffset(c36.z);
  float4 g_screen_size : packoffset(c37);
  float g_vpos_texel_offset : packoffset(c38);
  float4 g_viewport_dimensions : packoffset(c39);
  float2 g_viewport_origin : packoffset(c40);
  float4 g_render_target_dimensions : packoffset(c41);
  float4 g_camera_temp0 : packoffset(c42);
  float4 g_camera_temp1 : packoffset(c43);
  float4 g_camera_temp2 : packoffset(c44);
  float4 g_clip_rect : packoffset(c45);
  float3 g_vr_head_rotation : packoffset(c46);
  int g_num_of_samples : packoffset(c46.w);
  float g_supersampling : packoffset(c47);
  float4 g_mouse_position : packoffset(c48);
  float3 g_frustum_points[8] : packoffset(c49);
  float g_orthographic : packoffset(c56.w);
  float g_overlay_lerp : packoffset(c57);
  float g_overlay_parchment_lerp : packoffset(c57.y);
  float2 g_camera_jitter : packoffset(c57.z);
  float2 g_prev_camera_jitter : packoffset(c58);
  uint g_debug_visualization_mode : packoffset(c58.z);
  bool g_taa_is_enabled : packoffset(c58.w);
}

cbuffer bloom_buffer : register(b1)
{
  float g_bloom_threshold : packoffset(c0);
  float g_bloom_strength : packoffset(c0.y);
}

cbuffer render_target_dims_buffer : register(b2)
{
  float2 g_render_target_recip_size : packoffset(c0);
}

SamplerState g_hdr_rgb_texture_sampler_s : register(s0);
Texture2D<float4> g_hdr_rgb_texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = g_vpos_texel_offset + v0.xy;
  r0.xy = g_render_target_recip_size.xy * r0.xy;
  r0.xyz = g_hdr_rgb_texture.SampleLevel(g_hdr_rgb_texture_sampler_s, r0.xy, 0).xyz;
  r0.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r1.x = max(0, g_bloom_threshold);
  r0.w = saturate(-r1.x + r0.w);
  r0.xyz = r0.xyz * r0.www;
  o0.xyz = g_bloom_strength * r0.xyz * CUSTOM_BLOOM_STRENGTH;
  o0.w = 1;
  return;
}