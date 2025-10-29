#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 10 19:19:01 2025

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


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = g_screen_size.zw * v0.xy;
  r1.xyzw = t_initial_texture.SampleLevel(s_default_s, r0.xy, 0).xyzw;
  r2.xyz = t_initial_texture.Gather(s_default_s, r0.xy).xyz;
  r3.xyz = t_initial_texture.Gather(s_default_s, r0.xy, int2(-1, -1)).xzw;
  r0.z = max(r2.x, r1.y);
  r0.w = min(r2.x, r1.y);
  r0.z = max(r2.z, r0.z);
  r0.w = min(r2.z, r0.w);
  r2.w = max(r3.y, r3.x);
  r3.w = min(r3.y, r3.x);
  r0.z = max(r2.w, r0.z);
  r0.w = min(r3.w, r0.w);
  r2.w = 0.165999994 * r0.z;
  r0.z = r0.z + -r0.w;
  r0.w = max(0.0833000019, r2.w);
  r0.w = cmp(r0.z >= r0.w);
  if (r0.w != 0) {
    r0.w = t_initial_texture.SampleLevel(s_default_s, r0.xy, 0, int2(1, -1)).y;
    r2.w = t_initial_texture.SampleLevel(s_default_s, r0.xy, 0, int2(-1, 1)).y;
    r4.xy = r3.yx + r2.xz;
    r0.z = 1 / r0.z;
    r3.w = r4.x + r4.y;
    r4.xy = r1.yy * float2(-2,-2) + r4.xy;
    r4.z = r0.w + r2.y;
    r0.w = r3.z + r0.w;
    r4.w = r2.z * -2 + r4.z;
    r0.w = r3.y * -2 + r0.w;
    r3.z = r3.z + r2.w;
    r2.y = r2.w + r2.y;
    r2.w = abs(r4.x) * 2 + abs(r4.w);
    r0.w = abs(r4.y) * 2 + abs(r0.w);
    r4.x = r3.x * -2 + r3.z;
    r2.y = r2.x * -2 + r2.y;
    r2.w = abs(r4.x) + r2.w;
    r0.w = abs(r2.y) + r0.w;
    r2.y = r3.z + r4.z;
    r0.w = cmp(r2.w >= r0.w);
    r2.y = r3.w * 2 + r2.y;
    r2.w = r0.w ? r3.y : r3.x;
    r2.x = r0.w ? r2.x : r2.z;
    r2.z = r0.w ? g_screen_size.w : g_screen_size.z;
    r2.y = r2.y * 0.0833333358 + -r1.y;
    r3.xy = r2.wx + -r1.yy;
    r2.xw = r2.xw + r1.yy;
    r3.z = cmp(abs(r3.x) >= abs(r3.y));
    r3.x = max(abs(r3.x), abs(r3.y));
    r2.z = r3.z ? -r2.z : r2.z;
    r0.z = saturate(abs(r2.y) * r0.z);
    r2.y = r0.w ? g_screen_size.z : 0;
    r3.y = r0.w ? 0 : g_screen_size.w;
    r4.xy = r2.zz * float2(0.5,0.5) + r0.xy;
    r3.w = r0.w ? r0.x : r4.x;
    r4.x = r0.w ? r4.y : r0.y;
    r5.x = r3.w + -r2.y;
    r5.y = r4.x + -r3.y;
    r6.x = r3.w + r2.y;
    r6.y = r4.x + r3.y;
    r3.w = r0.z * -2 + 3;
    r4.x = t_initial_texture.SampleLevel(s_default_s, r5.xy, 0).y;
    r0.z = r0.z * r0.z;
    r4.y = t_initial_texture.SampleLevel(s_default_s, r6.xy, 0).y;
    r2.x = r3.z ? r2.w : r2.x;
    r2.w = 0.25 * r3.x;
    r3.x = -r2.x * 0.5 + r1.y;
    r0.z = r3.w * r0.z;
    r3.x = cmp(r3.x < 0);
    r3.z = -r2.x * 0.5 + r4.x;
    r3.w = -r2.x * 0.5 + r4.y;
    r4.xy = cmp(abs(r3.zw) >= r2.ww);
    r4.z = -r2.y * 1.5 + r5.x;
    r4.z = r4.x ? r5.x : r4.z;
    r5.x = -r3.y * 1.5 + r5.y;
    r4.w = r4.x ? r5.y : r5.x;
    r5.xy = ~(int2)r4.xy;
    r5.x = (int)r5.y | (int)r5.x;
    r5.y = r2.y * 1.5 + r6.x;
    r5.w = r3.y * 1.5 + r6.y;
    r5.yz = r4.yy ? r6.xy : r5.yw;
    if (r5.x != 0) {
      if (r4.x == 0) {
        r3.z = t_initial_texture.SampleLevel(s_default_s, r4.zw, 0).y;
      }
      if (r4.y == 0) {
        r3.w = t_initial_texture.SampleLevel(s_default_s, r5.yz, 0).y;
      }
      r5.x = -r2.x * 0.5 + r3.z;
      r3.z = r4.x ? r3.z : r5.x;
      r4.x = -r2.x * 0.5 + r3.w;
      r3.w = r4.y ? r3.w : r4.x;
      r4.xy = cmp(abs(r3.zw) >= r2.ww);
      r5.x = -r2.y * 2 + r4.z;
      r4.z = r4.x ? r4.z : r5.x;
      r5.x = -r3.y * 2 + r4.w;
      r4.w = r4.x ? r4.w : r5.x;
      r5.xw = ~(int2)r4.xy;
      r5.x = (int)r5.w | (int)r5.x;
      r5.w = r2.y * 2 + r5.y;
      r5.y = r4.y ? r5.y : r5.w;
      r5.w = r3.y * 2 + r5.z;
      r5.z = r4.y ? r5.z : r5.w;
      if (r5.x != 0) {
        if (r4.x == 0) {
          r3.z = t_initial_texture.SampleLevel(s_default_s, r4.zw, 0).y;
        }
        if (r4.y == 0) {
          r3.w = t_initial_texture.SampleLevel(s_default_s, r5.yz, 0).y;
        }
        r5.x = -r2.x * 0.5 + r3.z;
        r3.z = r4.x ? r3.z : r5.x;
        r4.x = -r2.x * 0.5 + r3.w;
        r3.w = r4.y ? r3.w : r4.x;
        r4.xy = cmp(abs(r3.zw) >= r2.ww);
        r5.x = -r2.y * 4 + r4.z;
        r4.z = r4.x ? r4.z : r5.x;
        r5.x = -r3.y * 4 + r4.w;
        r4.w = r4.x ? r4.w : r5.x;
        r5.xw = ~(int2)r4.xy;
        r5.x = (int)r5.w | (int)r5.x;
        r5.w = r2.y * 4 + r5.y;
        r5.y = r4.y ? r5.y : r5.w;
        r5.w = r3.y * 4 + r5.z;
        r5.z = r4.y ? r5.z : r5.w;
        if (r5.x != 0) {
          if (r4.x == 0) {
            r3.z = t_initial_texture.SampleLevel(s_default_s, r4.zw, 0).y;
          }
          if (r4.y == 0) {
            r3.w = t_initial_texture.SampleLevel(s_default_s, r5.yz, 0).y;
          }
          r5.x = -r2.x * 0.5 + r3.z;
          r3.z = r4.x ? r3.z : r5.x;
          r2.x = -r2.x * 0.5 + r3.w;
          r3.w = r4.y ? r3.w : r2.x;
          r2.xw = cmp(abs(r3.zw) >= r2.ww);
          r4.x = -r2.y * 12 + r4.z;
          r4.z = r2.x ? r4.z : r4.x;
          r4.x = -r3.y * 12 + r4.w;
          r4.w = r2.x ? r4.w : r4.x;
          r2.x = r2.y * 12 + r5.y;
          r5.y = r2.w ? r5.y : r2.x;
          r2.x = r3.y * 12 + r5.z;
          r5.z = r2.w ? r5.z : r2.x;
        }
      }
    }
    r2.x = v0.x * g_screen_size.z + -r4.z;
    r2.y = -v0.x * g_screen_size.z + r5.y;
    r2.w = v0.y * g_screen_size.w + -r4.w;
    r2.x = r0.w ? r2.x : r2.w;
    r2.w = -v0.y * g_screen_size.w + r5.z;
    r2.y = r0.w ? r2.y : r2.w;
    r3.yz = cmp(r3.zw < float2(0,0));
    r2.w = r2.y + r2.x;
    r3.xy = cmp((int2)r3.xx != (int2)r3.yz);
    r2.w = 1 / r2.w;
    r3.z = cmp(r2.x < r2.y);
    r2.x = min(r2.x, r2.y);
    r2.y = r3.z ? r3.x : r3.y;
    r0.z = r0.z * r0.z;
    r2.x = r2.x * -r2.w + 0.5;
    r0.z = 0.75 * r0.z;
    r2.x = (int)r2.x & (int)r2.y;
    r0.z = max(r2.x, r0.z);
    r2.xy = r0.zz * r2.zz + r0.xy;
    r3.x = r0.w ? r0.x : r2.x;
    r3.y = r0.w ? r2.y : r0.y;
    o0.xyzw = t_initial_texture.SampleLevel(s_default_s, r3.xy, 0).xyzw;
  } else {
    o0.xyzw = r1.xyzw;
  }
  return;
}