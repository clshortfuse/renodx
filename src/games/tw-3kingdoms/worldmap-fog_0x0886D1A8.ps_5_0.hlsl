// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 24 21:13:17 2025

#include "./shared.h"

cbuffer shroud_PS : register(b0)
{
  float g_shroud_enabled : packoffset(c0);
  float g_campaign_autumn_timer : packoffset(c0.y);
  float g_snow_height : packoffset(c0.z) = {1.39999998};
  float g_rock_slope_scale : packoffset(c0.w) = {0.400000006};
  float g_rock_height_min : packoffset(c1) = {0.400000006};
  float g_rock_height_max : packoffset(c1.y) = {1.39999998};
  float2 g_uv_offset : packoffset(c1.z);
  float4 g_shroud_layer_texture_index : packoffset(c2);
  float g_discovered_shroud_brightness : packoffset(c3);
  float g_discovered_shroud_saturation : packoffset(c3.y);
  float g_undiscovered_shroud_brightness : packoffset(c3.z);
  float g_undiscovered_shroud_saturation : packoffset(c3.w);
  float g_shroud_edge_noise_uv_scale : packoffset(c4);
  float g_shroud_edge_noise_strength : packoffset(c4.y);
  float g_shroud_edge_brightness : packoffset(c4.z);
  float g_shroud_edge_ink_uv_scale : packoffset(c4.w);
  float g_shroud_lerp_factor : packoffset(c5);
  float g_shroud_terrain_detail_factor : packoffset(c5.y);
  float g_discovered_shroud_border_brightness : packoffset(c5.z);
  float g_discovered_shroud_border_saturation : packoffset(c5.w);
  float g_discovered_shroud_border_alpha : packoffset(c6);
  float g_shroud_fade_in_out_alpha : packoffset(c6.y);
}

cbuffer camera : register(b1)
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

cbuffer lighting_VS_PS : register(b2)
{
  bool g_apply_environment_specular : packoffset(c0);
  float3 sun_direction : packoffset(c0.y);
  float3 sun_colour : packoffset(c1);
  float sun_specular : packoffset(c1.w);
  float3 ambient_cube_lr[2] : packoffset(c2);
  float3 ambient_cube_tb[2] : packoffset(c4);
  float3 ambient_cube_fb[2] : packoffset(c6);
  float3 g_deep_water_colour : packoffset(c8);
  float3 g_shallow_water_colour : packoffset(c9);
  float3 g_sea_bed_light_scatter : packoffset(c10);
  float g_refraction_light_scatter : packoffset(c10.w);
  int g_ssr_enabled : packoffset(c11);
  bool g_use_spherical_harmonics : packoffset(c11.y);
  bool g_use_spherical_harmonics_array : packoffset(c11.z);
  float2 g_cloud_shadow_direction : packoffset(c12);
  float g_cloud_shadow_speed : packoffset(c12.z);
  float g_cloud_shadow_scale : packoffset(c12.w);
  float g_cloud_shadow_lerp : packoffset(c13);
  float2 g_noise_uv_shift : packoffset(c13.y);
  bool g_skin_enable : packoffset(c13.w);
  float2 g_skin_curvature_scale_bias : packoffset(c14);
  float2 g_skin_translucency_scale_bias : packoffset(c14.z);
  float3 g_skin_blood_colour : packoffset(c15);
  float4 g_world_bounds : packoffset(c16);
  float4 g_playable_area_bounds : packoffset(c17);
  float g_vegetation_wrap_lighting_bias : packoffset(c18);
  float g_spherical_harmonic_terms : packoffset(c18.y);
  float g_spherical_harmonic_fadeout : packoffset(c18.z);
  float g_ambient_fudge_factor : packoffset(c18.w);
  float g_time_of_day_unary : packoffset(c19);
}

SamplerState s_shroud_s : register(s0);
SamplerState s_shroud_cloud_s : register(s1);
Texture2D<float4> t_shroud : register(t0);
Texture2D<float4> t_readable_depth_texture : register(t1);
Texture2D<float4> t_shroud_cloud : register(t2);


// 3Dmigoto declarations
#define cmp -


// Campaign shroud overlay: reconstructs world position, looks up shroud mask, and modulates noise-driven edge effects.
void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Derive world position from the depth buffer and inverse view-projection.
  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r0.z = t_readable_depth_texture.Load(r0.xyz).x;
  r1.xy = -g_viewport_origin.xy + v0.xy;
  r1.xy = g_viewport_dimensions.zw * r1.xy;
  r0.xy = r1.xy * float2(2,-2) + float2(-1,1);
  r0.w = 1;
  r1.x = dot(r0.xyzw, inv_view_projection._m00_m10_m20_m30);
  r1.y = dot(r0.xyzw, inv_view_projection._m01_m11_m21_m31);
  r1.z = dot(r0.xyzw, inv_view_projection._m02_m12_m22_m32);
  r0.x = dot(r0.xyzw, inv_view_projection._m03_m13_m23_m33);
  r0.xyz = r1.xyz / r0.xxx;
  r1.xy = -g_world_bounds.xy + r0.xz;
  r1.zw = g_world_bounds.zw + -g_world_bounds.xy;
  r1.xy = r1.xy / r1.zw;
  r1.zw = -g_uv_offset.xy * float2(2,2) + float2(1,1);
  r1.xy = r1.xy * r1.zw + g_uv_offset.xy;
  r0.w = t_shroud.SampleLevel(s_shroud_s, r1.xy, 0).w;
  // Evaluate fade strength based on shroud alpha and camera height.
  r1.x = saturate(0.519999981 + r0.w);
  r0.w = 0.200000003 + -r0.w;
  r0.w = saturate(20 * r0.w);
  r1.x = -r1.x * r1.x + 1;
  r1.y = 10 + -r0.y;
  r1.y = saturate(0.100000001 * r1.y);
  r1.y = r1.y * r1.y;
  r1.x = r1.y * r1.x;
  r1.y = saturate(-camera_position.y * 0.0250000004 + 3);
  r1.x = r1.x * r1.y;
  r1.z = 0.300000012 * r1.x;
  r1.x = -r1.x * 0.300000012 + 1;
  r1.x = r0.w * r1.x + r1.z;
  r0.w = r1.y * r0.w;
  r0.w = r0.w * -0.399999976 + 1;
  r0.y = camera_position.y + -r0.y;
  r0.y = saturate(r0.y * 0.0714285746 + -1);
  r0.y = r1.x * r0.y;
  r1.x = r0.y * g_shroud_fade_in_out_alpha + -0.00100000005;
  r0.y = g_shroud_fade_in_out_alpha * r0.y;
  o0.w = r0.y;
  r0.y = cmp(r1.x < 0);
  if (r0.y != 0) discard;
  // Sample animated cloud and ink textures to add noisy edges to the shroud silhouette.
  r2.xyzw = float4(0.00999999978,0.00999999978,0.00649999967,0.00649999967) * r0.xzxz;
  r3.xyzw = float4(0.0133333337,0.0133333337,0.00866666622,0.00866666622) * r0.xzxz;
  r2.xyzw = time_in_sec * float4(-0.015625,0.00187500007,-0.0125000002,0.00150000001) + r2.xyzw;
  r0.xyz = t_shroud_cloud.Sample(s_shroud_cloud_s, r2.xy).xzw;
  r1.xzw = t_shroud_cloud.Sample(s_shroud_cloud_s, r2.zw).xyw;
  r0.xyz = r1.zxw + r0.yxz;
  r1.xz = time_in_sec * float2(-0.0115,0.00499999989) + -r3.xy;
  r2.xy = time_in_sec * float2(-0.0132249994,0.00574999955) + r3.zw;
  r2.xy = t_shroud_cloud.Sample(s_shroud_cloud_s, r2.xy).yw;
  r1.xzw = t_shroud_cloud.Sample(s_shroud_cloud_s, r1.xz).yzw;
  r0.xyz = r1.zxw + r0.xyz;
  r0.xyz = r0.xyz + r2.xxy;
  r0.x = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.y = r0.x * r0.x;
  // Convert noise intensity into final RGB tint and apply the current fade amount.
  r0.xyz = r0.xxx * r0.yyy + float3(-2.0999999,-1.95000005,-1.5);
  r0.xyz = r1.yyy * r0.xyz + float3(2.0999999,1.95000005,1.5);
  float3 fog_output = r0.xyz * r0.www;
  o0.xyz = RENODX_WORLD_MAP_FOG_SATURATE != 0.f ? saturate(fog_output) : fog_output;
  return;
}