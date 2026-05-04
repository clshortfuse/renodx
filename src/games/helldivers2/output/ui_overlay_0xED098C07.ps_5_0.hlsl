#include "../shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Feb 12 17:02:30 2026

cbuffer global_viewport : register(b0)
{
  float3 camera_unprojection : packoffset(c0);
  float3 camera_center_pos : packoffset(c1);
  float3 cb_camera_pos : packoffset(c2);
  float4x4 camera_view : packoffset(c3);
  float4x4 camera_projection : packoffset(c7);
  float4x4 camera_inv_view : packoffset(c11);
  float4x4 camera_inv_projection : packoffset(c15);
  float4x4 camera_view_projection : packoffset(c19);
  float4x4 camera_last_view : packoffset(c23);
  float4x4 camera_last_projection : packoffset(c27);
  float4x4 camera_last_inv_view : packoffset(c31);
  float4x4 camera_last_inv_projection : packoffset(c35);
  float4x4 camera_last_view_projection : packoffset(c39);
  float3 camera_near_far : packoffset(c43);
  float time : packoffset(c43.w);
  float delta_time : packoffset(c44);
  float frame_number : packoffset(c44.y);
  float2 vp_render_resolution : packoffset(c44.z);
  float2 raw_non_checkerboarded_target_size : packoffset(c45);
  float taa_enabled : packoffset(c45.z);
  float vrs_enabled : packoffset(c45.w);
  float imp_transparent_override : packoffset(c46);
  float debug_rendering : packoffset(c46.y);
  float post_effects_enabled : packoffset(c46.z);
  float4 raw_non_checkerboarded_viewport : packoffset(c47);
  float debug_lod : packoffset(c48);
  float debug_shadow_lod : packoffset(c48.y);
  float texture_density_visualization : packoffset(c48.z);
}

cbuffer c_per_object : register(b1)
{
  float4x4 cb_world : packoffset(c0);
  bool use_object_camera_transform : packoffset(c4);
  float2 hud_curve_amount : packoffset(c4.y);
}

cbuffer c0 : register(b2)
{
  float4 scissor_rect : packoffset(c0);
  float scissor_mode : packoffset(c1);
  float4 atlas_scissor : packoffset(c2);
  float threshold_fade : packoffset(c3);
  float desaturate : packoffset(c3.y);
  float4 distortion_grain_speed : packoffset(c4);
  float2 distortion_strength : packoffset(c5);
  float2 clip_center : packoffset(c5.z);
  float clip_distance : packoffset(c6);
  float edge_fade_offset : packoffset(c6.y);
  float3 edge_fade_tint : packoffset(c7);
  float4 clip_box : packoffset(c8);
  float4 linear_fade_offsets : packoffset(c9);
}

SamplerState __samp_hdr0_div4_fullres_s : register(s0);
Texture2D<float4> __tex_hdr0_div4_fullres : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  float inf = 1e+20;

  r0.xy = v0.xy / raw_non_checkerboarded_viewport.xy;
  r0.z = cmp(scissor_rect.z < 0);
  r0.w = raw_non_checkerboarded_target_size.y / raw_non_checkerboarded_target_size.x;
  r1.x = hud_curve_amount.x * r0.w;
  r1.yz = r0.xy * float2(2,2) + float2(-1,-1);
  r1.w = 1 + -hud_curve_amount.y;
  r2.xy = abs(r1.yz) * abs(r1.yz);
  r3.y = r2.x * hud_curve_amount.y + r1.w;
  r0.w = -hud_curve_amount.x * r0.w + 1;
  r3.x = r2.y * r1.x + r0.w;
  r1.xy = r1.yz / r3.xy;
  r1.xy = float2(1,1) + r1.xy;
  r1.xy = float2(0.5,0.5) * r1.xy;
  r1.zw = -atlas_scissor.xy / atlas_scissor.zw;
  r1.xy = r0.zz ? r1.xy : r1.zw;
  r1.zw = abs(scissor_rect.xy) + -r1.xy;
  r1.zw = r1.zw / abs(scissor_rect.zw);
  r0.w = dot(r1.zw, r1.zw);
  r0.w = sqrt(r0.w);
  r0.w = cmp(r0.w >= 1);
  r1.zw = cmp(float2(1.5,0.5) < scissor_mode);
  r2.xy = cmp(r1.xy < abs(scissor_rect.xy));
  r1.xy = cmp(abs(scissor_rect.zw) < r1.xy);
  r1.x = (int)r1.x | (int)r2.x;
  r1.x = (int)r2.y | (int)r1.x;
  r1.x = (int)r1.y | (int)r1.x;
  r1.x = r1.x ? r1.w : 0;
  r0.w = r1.z ? r0.w : r1.x;
  r0.z = r0.z ? r0.w : 0;
  if (r0.z != 0) discard;
  r0.xyz = __tex_hdr0_div4_fullres.Sample(__samp_hdr0_div4_fullres_s, r0.xy).xyz;
  r1.xy = (uint2)v0.xy;
  r0.w = frame_number;
  r0.w = (int)r0.w + (int)r1.x;
  r0.w = (uint)r0.w;
  r1.x = (uint)r1.y;
  r1.x = 0.27100271 * r1.x;
  r0.w = r0.w * 1.61803401 + r1.x;
  r1.x = floor(r0.w);
  r0.w = -r1.x + r0.w;
  r1.xyz = float3(255,255,255) * r0.xyz;
  r1.xyz = floor(r1.xyz);
  r2.xyz = float3(0.00392156886,0.00392156886,0.00392156886) * r1.xyz;
  r3.xyz = r1.xyz * float3(0.00392156886,0.00392156886,0.00392156886) + float3(0.00392156886,0.00392156886,0.00392156886);
  r0.xyz = -r3.xyz + r0.xyz;
  r1.xyz = r1.xyz * float3(0.00392156886,0.00392156886,0.00392156886) + -r3.xyz;
  r3.xyz = (int3)-r1.xyz + int3(0x7ef19fff,0x7ef19fff,0x7ef19fff);
  r1.xyz = -r3.xyz * r1.xyz + float3(2,2,2);
  r1.xyz = r3.xyz * r1.xyz;
  r0.xyz = -r0.xyz * r1.xyz + r0.www;
  r0.xyz = saturate(float3(inf,inf,inf) * r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.00392156886,0.00392156886,0.00392156886) + r2.xyz);
  r0.w = dot(r0.xyz, float3(0.212699994,0.715200007,0.0720999986));
  r0.xyz = r0.xyz + -r0.www;

  r1.x = 1 + (-desaturate * UNDER_UI_DESATURATION);

  r0.xyz = r0.xyz * r1.xxx + r0.www;
  o0.xyz = v1.xyz * r0.xyz;
  r0.xyzw = cmp(linear_fade_offsets.xyzw == float4(-1,-1,-1,-1));
  r0.xy = r0.zw ? r0.xy : 0;
  r0.x = r0.y ? r0.x : 0;
  r1.xyzw = cmp(linear_fade_offsets.xyzw == float4(0,0,0,0));
  r0.yz = r1.zw ? r1.xy : 0;
  r0.y = r0.z ? r0.y : 0;
  r0.x = (int)r0.y | (int)r0.x;
  r0.y = raw_non_checkerboarded_viewport.y + -v0.y;
  r1.x = -clip_box.x + v0.x;
  r0.zw = -linear_fade_offsets.zw + clip_box.zw;
  r1.z = v0.x + -r0.z;
  r1.y = -clip_box.y + r0.y;
  r1.w = r0.y + -r0.w;
  r2.xyzw = max(float4(9.99999975e-05,9.99999975e-05,9.99999975e-05,9.99999975e-05), linear_fade_offsets.xyzw);
  r1.xyzw = saturate(r1.xyzw / r2.xyzw);
  r0.yz = float2(1,1) + -r1.zw;
  r0.yz = min(r1.xy, r0.yz);
  r0.y = min(r0.y, r0.z);
  r0.y = v1.w * r0.y;
  o0.w = r0.x ? v1.w : r0.y;
  return;
}