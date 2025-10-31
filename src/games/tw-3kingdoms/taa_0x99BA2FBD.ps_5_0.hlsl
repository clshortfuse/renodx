#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Oct  9 21:55:25 2025

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

SamplerState s_default_s : register(s0);
Texture2D<float4> t_initial_texture : register(t0);
Texture2D<float4> t_gbuffer_material_bitflags_channel : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r1.xyzw = t_initial_texture.Load(r0.xyw).xyzw;
  r2.xy = g_screen_size.zw * v0.xy;
  r3.xyzw = t_initial_texture.SampleLevel(s_default_s, r2.xy, 0).xyzw;
  r4.xyz = t_initial_texture.Gather(s_default_s, r2.xy).xyz;
  r5.xyz = t_initial_texture.Gather(s_default_s, r2.xy, int2(-1, -1)).xzw;
  r2.z = max(r4.x, r3.y);
  r2.w = min(r4.x, r3.y);
  r2.z = max(r4.z, r2.z);
  r2.w = min(r4.z, r2.w);
  r4.w = max(r5.y, r5.x);
  r5.w = min(r5.y, r5.x);
  r2.z = max(r4.w, r2.z);
  r2.w = min(r5.w, r2.w);
  r4.w = 0.165999994 * r2.z;
  r2.z = r2.z + -r2.w;
  r2.w = max(0.0833000019, r4.w);
  r2.w = cmp(r2.z >= r2.w);
  if (r2.w != 0) {
    r2.w = t_initial_texture.SampleLevel(s_default_s, r2.xy, 0, int2(1, -1)).y;
    r4.w = t_initial_texture.SampleLevel(s_default_s, r2.xy, 0, int2(-1, 1)).y;
    r6.xy = r5.yx + r4.xz;
    r2.z = 1 / r2.z;
    r5.w = r6.x + r6.y;
    r6.xy = r3.yy * float2(-2,-2) + r6.xy;
    r6.z = r2.w + r4.y;
    r2.w = r5.z + r2.w;
    r6.w = r4.z * -2 + r6.z;
    r2.w = r5.y * -2 + r2.w;
    r5.z = r5.z + r4.w;
    r4.y = r4.w + r4.y;
    r4.w = abs(r6.x) * 2 + abs(r6.w);
    r2.w = abs(r6.y) * 2 + abs(r2.w);
    r6.x = r5.x * -2 + r5.z;
    r4.y = r4.x * -2 + r4.y;
    r4.w = abs(r6.x) + r4.w;
    r2.w = abs(r4.y) + r2.w;
    r4.y = r5.z + r6.z;
    r2.w = cmp(r4.w >= r2.w);
    r4.y = r5.w * 2 + r4.y;
    r4.w = r2.w ? r5.y : r5.x;
    r4.x = r2.w ? r4.x : r4.z;
    r4.z = r2.w ? g_screen_size.w : g_screen_size.z;
    r4.y = r4.y * 0.0833333358 + -r3.y;
    r5.xy = r4.wx + -r3.yy;
    r4.xw = r4.xw + r3.yy;
    r5.z = cmp(abs(r5.x) >= abs(r5.y));
    r5.x = max(abs(r5.x), abs(r5.y));
    r4.z = r5.z ? -r4.z : r4.z;
    r2.z = saturate(abs(r4.y) * r2.z);
    r4.y = r2.w ? g_screen_size.z : 0;
    r5.y = r2.w ? 0 : g_screen_size.w;
    r6.xy = r4.zz * float2(0.5,0.5) + r2.xy;
    r5.w = r2.w ? r2.x : r6.x;
    r6.x = r2.w ? r6.y : r2.y;
    r7.x = r5.w + -r4.y;
    r7.y = r6.x + -r5.y;
    r8.x = r5.w + r4.y;
    r8.y = r6.x + r5.y;
    r5.w = r2.z * -2 + 3;
    r6.x = t_initial_texture.SampleLevel(s_default_s, r7.xy, 0).y;
    r2.z = r2.z * r2.z;
    r6.y = t_initial_texture.SampleLevel(s_default_s, r8.xy, 0).y;
    r4.x = r5.z ? r4.w : r4.x;
    r4.w = 0.25 * r5.x;
    r5.x = -r4.x * 0.5 + r3.y;
    r2.z = r5.w * r2.z;
    r5.x = cmp(r5.x < 0);
    r5.z = -r4.x * 0.5 + r6.x;
    r5.w = -r4.x * 0.5 + r6.y;
    r6.xy = cmp(abs(r5.zw) >= r4.ww);
    r6.z = -r4.y * 1.5 + r7.x;
    r6.z = r6.x ? r7.x : r6.z;
    r7.x = -r5.y * 1.5 + r7.y;
    r6.w = r6.x ? r7.y : r7.x;
    r7.xy = ~(int2)r6.xy;
    r7.x = (int)r7.y | (int)r7.x;
    r7.y = r4.y * 1.5 + r8.x;
    r7.w = r5.y * 1.5 + r8.y;
    r7.yz = r6.yy ? r8.xy : r7.yw;
    if (r7.x != 0) {
      if (r6.x == 0) {
        r5.z = t_initial_texture.SampleLevel(s_default_s, r6.zw, 0).y;
      }
      if (r6.y == 0) {
        r5.w = t_initial_texture.SampleLevel(s_default_s, r7.yz, 0).y;
      }
      r7.x = -r4.x * 0.5 + r5.z;
      r5.z = r6.x ? r5.z : r7.x;
      r6.x = -r4.x * 0.5 + r5.w;
      r5.w = r6.y ? r5.w : r6.x;
      r6.xy = cmp(abs(r5.zw) >= r4.ww);
      r7.x = -r4.y * 2 + r6.z;
      r6.z = r6.x ? r6.z : r7.x;
      r7.x = -r5.y * 2 + r6.w;
      r6.w = r6.x ? r6.w : r7.x;
      r7.xw = ~(int2)r6.xy;
      r7.x = (int)r7.w | (int)r7.x;
      r7.w = r4.y * 2 + r7.y;
      r7.y = r6.y ? r7.y : r7.w;
      r7.w = r5.y * 2 + r7.z;
      r7.z = r6.y ? r7.z : r7.w;
      if (r7.x != 0) {
        if (r6.x == 0) {
          r5.z = t_initial_texture.SampleLevel(s_default_s, r6.zw, 0).y;
        }
        if (r6.y == 0) {
          r5.w = t_initial_texture.SampleLevel(s_default_s, r7.yz, 0).y;
        }
        r7.x = -r4.x * 0.5 + r5.z;
        r5.z = r6.x ? r5.z : r7.x;
        r6.x = -r4.x * 0.5 + r5.w;
        r5.w = r6.y ? r5.w : r6.x;
        r6.xy = cmp(abs(r5.zw) >= r4.ww);
        r7.x = -r4.y * 4 + r6.z;
        r6.z = r6.x ? r6.z : r7.x;
        r7.x = -r5.y * 4 + r6.w;
        r6.w = r6.x ? r6.w : r7.x;
        r7.xw = ~(int2)r6.xy;
        r7.x = (int)r7.w | (int)r7.x;
        r7.w = r4.y * 4 + r7.y;
        r7.y = r6.y ? r7.y : r7.w;
        r7.w = r5.y * 4 + r7.z;
        r7.z = r6.y ? r7.z : r7.w;
        if (r7.x != 0) {
          if (r6.x == 0) {
            r5.z = t_initial_texture.SampleLevel(s_default_s, r6.zw, 0).y;
          }
          if (r6.y == 0) {
            r5.w = t_initial_texture.SampleLevel(s_default_s, r7.yz, 0).y;
          }
          r7.x = -r4.x * 0.5 + r5.z;
          r5.z = r6.x ? r5.z : r7.x;
          r4.x = -r4.x * 0.5 + r5.w;
          r5.w = r6.y ? r5.w : r4.x;
          r4.xw = cmp(abs(r5.zw) >= r4.ww);
          r6.x = -r4.y * 12 + r6.z;
          r6.z = r4.x ? r6.z : r6.x;
          r6.x = -r5.y * 12 + r6.w;
          r6.w = r4.x ? r6.w : r6.x;
          r4.x = r4.y * 12 + r7.y;
          r7.y = r4.w ? r7.y : r4.x;
          r4.x = r5.y * 12 + r7.z;
          r7.z = r4.w ? r7.z : r4.x;
        }
      }
    }
    r4.x = v0.x * g_screen_size.z + -r6.z;
    r4.y = -v0.x * g_screen_size.z + r7.y;
    r4.w = v0.y * g_screen_size.w + -r6.w;
    r4.x = r2.w ? r4.x : r4.w;
    r4.w = -v0.y * g_screen_size.w + r7.z;
    r4.y = r2.w ? r4.y : r4.w;
    r5.yz = cmp(r5.zw < float2(0,0));
    r4.w = r4.y + r4.x;
    r5.xy = cmp((int2)r5.xx != (int2)r5.yz);
    r4.w = 1 / r4.w;
    r5.z = cmp(r4.x < r4.y);
    r4.x = min(r4.x, r4.y);
    r4.y = r5.z ? r5.x : r5.y;
    r2.z = r2.z * r2.z;
    r4.x = r4.x * -r4.w + 0.5;
    r2.z = 0.75 * r2.z;
    r4.x = (int)r4.x & (int)r4.y;
    r2.z = max(r4.x, r2.z);
    r4.xy = r2.zz * r4.zz + r2.xy;
    r5.x = r2.w ? r2.x : r4.x;
    r5.y = r2.w ? r4.y : r2.y;
    r3.xyzw = t_initial_texture.SampleLevel(s_default_s, r5.xy, 0).xyzw;
  }
  r0.xy = t_gbuffer_material_bitflags_channel.Load(r0.xyz).xy;
  r0.xy = float2(255,255) * r0.xy;
  r0.xy = round(r0.xy);
  r0.xy = (uint2)r0.xy;
  r0.y = (uint)r0.y << 8;
  r0.x = (int)r0.y | (int)r0.x;
  r0.x = (uint)r0.x;
  r0.x = 1.52590219e-05 * r0.x;
  r0.x = min(1, r0.x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r1.xyzw = -r3.xyzw + r1.xyzw;
  o0.xyzw = r0.xxxx * r1.xyzw + r3.xyzw;
  return;
}