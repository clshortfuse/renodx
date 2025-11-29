// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 24 21:13:17 2025

#include "./shared.h"

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

cbuffer shroud_PS : register(b1)
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

cbuffer tone_mapping : register(b3)
{
  float g_tone_mapping_brightness : packoffset(c0);
  float g_tone_mapping_burn : packoffset(c0.y);
  int g_use_auto_exposure : packoffset(c0.z);
}

cbuffer shader_params : register(b4)
{
  float sp_Screen_Alpha : packoffset(c0);
  float sp_faction_number : packoffset(c0.y);
  float sp_map_alpha : packoffset(c0.z);
}

SamplerState s_shroud_s : register(s0);
SamplerState s_shroud_wrap_s : register(s1);
SamplerState s_xml_campaign_map_s : register(s2);
Texture2D<float4> gbuffer_channel_1_texture : register(t0);
Texture2D<float4> gbuffer_channel_4_texture : register(t1);
Texture2D<float4> t_shroud : register(t2);
Texture2D<float4> t_shroud_prev : register(t3);
Texture2D<float4> t_shroud_noise : register(t4);
Texture2D<float4> t_ink_flood_map : register(t5);
Texture2D<float4> t_ink_fractal_noise : register(t6);
Texture2D<float4> t_xml_Input_Texture : register(t7);
Texture2D<float4> t_xml_Input_Texture1 : register(t8);
Texture2D<float4> t_xml_Input_Texture2 : register(t9);
Texture2D<float4> t_xml_Input_Texture3 : register(t10);
Texture2D<float4> t_xml_campaign_lookup : register(t11);
Texture2D<float4> t_xml_campaign_lookup1 : register(t12);
Texture2D<float4> t_xml_campaign_lookup3 : register(t13);
Texture2D<float4> t_xml_campaign_lookup4 : register(t14);
Texture2D<float4> t_xml_campaign_map : register(t15);


// 3Dmigoto declarations
#define cmp -


// Campaign map composite: merges shroud visibility, faction overlays, and tone mapping for the strategy view.
void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  float4 v7 : TEXCOORD6,
  float4 v8 : TEXCOORD7,
  float3 v9 : TEXCOORD8,
  float w9 : TEXCOORD9,
  float4 v10 : COLOR1,
  float4 v11 : COLOR2,
  float4 v12 : NORMAL0,
  uint v13 : NORMAL1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Convert screen position to viewport-normalized coordinates and fetch depth for world reconstruction.
  r0.xy = -g_viewport_origin.xy + v0.xy;
  r0.xy = g_viewport_dimensions.zw * r0.xy;
  r0.zw = g_viewport_dimensions.xy * r0.xy;
  r0.zw = g_screen_size.zw * r0.zw;
  gbuffer_channel_1_texture.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
  r1.xy = uiDest.xy;
  r1.zw = (uint2)r1.xy;
  r0.zw = r1.zw * r0.zw;
  r0.zw = floor(r0.zw);
  r0.zw = (int2)r0.zw;
  r1.xy = (int2)r1.xy + int2(-1,-1);
  r0.zw = max(int2(0,0), (int2)r0.zw);
  r1.xy = min((int2)r0.zw, (int2)r1.xy);
  r1.zw = float2(0,0);
  r1.z = gbuffer_channel_4_texture.Load(r1.xyz).x;
  r1.xy = r0.xy * float2(2,-2) + float2(-1,1);
  r1.w = 1;
  r0.x = dot(r1.xyzw, inv_view_projection._m00_m10_m20_m30);
  r0.z = dot(r1.xyzw, inv_view_projection._m03_m13_m23_m33);
  r0.w = r0.x / r0.z;
  r2.x = -g_world_bounds.x + r0.w;
  r2.yz = g_world_bounds.zw + -g_world_bounds.xy;
  r2.x = r2.x / r2.y;
  r0.y = dot(r1.xyzw, inv_view_projection._m02_m12_m22_m32);
  r1.x = r0.y / r0.z;
  r1.y = -g_world_bounds.y + r1.x;
  r1.y = r1.y / r2.z;
  r2.y = 1 + -r1.y;
  r1.yzw = t_xml_campaign_map.Sample(s_xml_campaign_map_s, r2.xy).xyz;
  r2.z = cmp(g_shroud_enabled != 0.000000);
  if (r2.z != 0) {
    // Resolve the fog-of-war mask, including animated ink edges and turbulence when the shroud is active.
    r2.z = cmp(g_shroud_fade_in_out_alpha >= 0.00100000005);
    if (r2.z != 0) {
      r3.xyzw = r0.xyxy / r0.zzzz;
      r0.x = cmp(0.5 < g_shroud_enabled);
      if (r0.x != 0) {
        r4.xyzw = -g_world_bounds.xyxy + r3.zwzw;
        r5.xyzw = g_world_bounds.zwzw + -g_world_bounds.xyxy;
        r4.xyzw = r4.xyzw / r5.xyzw;
        r5.xyzw = -g_uv_offset.xyxy * float4(2,2,2,2) + float4(1,1,1,1);
        r4.xyzw = r4.xyzw * r5.xyzw + g_uv_offset.xyxy;
        r0.x = t_shroud.SampleLevel(s_shroud_s, r4.zw, 0).w;
        r0.y = t_shroud_prev.SampleLevel(s_shroud_s, r4.zw, 0).w;
        r4.xyzw = float4(0.00999999978,0.00999999978,-1,-1) + r4.xyzw;
        r4.xyzw = saturate(float4(100,100,100.000099,100.000099) * r4.xyzw);
        r5.xyzw = r4.xyzw * float4(-2,-2,-2,-2) + float4(3,3,3,3);
        r4.xyzw = r4.xyzw * r4.xyzw;
        r4.xyzw = r5.xyzw * r4.xyzw;
        r0.xy = r4.xx * r0.xy;
        r0.xy = r4.yy * r0.xy;
        r0.xy = r4.zz * -r0.xy + r0.xy;
        r0.xy = r4.ww * -r0.xy + r0.xy;
      } else {
        r0.xy = float2(1,1);
      }
      r0.x = r0.x + -r0.y;
      r0.x = g_shroud_lerp_factor * r0.x + r0.y;
      r0.y = cmp(0.99000001 >= r0.x);
      if (r0.y != 0) {
        r0.xy = float2(-0.5,-0.300000012) + r0.xx;
        r0.x = saturate(r0.x + r0.x);
        r0.z = r0.x * -2 + 3;
        r0.x = r0.x * r0.x;
        r2.z = r0.z * r0.x;
        r0.y = saturate(5.00000048 * r0.y);
        r2.w = r0.y * -2 + 3;
        r0.y = r0.y * r0.y;
        r0.y = r2.w * r0.y;
        r0.x = r0.z * r0.x + -0.5;
        r0.x = r0.x * r0.x + -0.25;
        r0.x = r0.x * r0.x;
        r0.xz = float2(16,4.80000019) * r0.xx;
        r4.xyzw = g_shroud_edge_noise_uv_scale * r3.xyzw;
        r2.w = t_shroud_noise.Sample(s_shroud_wrap_s, r4.xy).x;
        r2.w = -0.5 + r2.w;
        r3.x = g_shroud_edge_noise_strength * r0.x;
        r2.z = r3.x * r2.w + r2.z;
        r5.xyzw = float4(-0.0130000003,0,0.100000001,5) * time_in_sec;
        r3.xy = g_shroud_edge_ink_uv_scale * r3.zw + r5.xy;
        r3.xy = float2(4,4) * r3.xy;
        r3.xy = t_ink_fractal_noise.Sample(s_shroud_wrap_s, r3.xy).xz;
        r3.xy = float2(-0.5,-0.5) + r3.xy;
        r3.xy = r3.xy * float2(0.0299999993,0.0299999993) + r4.zw;
        r3.xy = t_ink_flood_map.Sample(s_shroud_wrap_s, r3.xy).xz;
        r2.w = -0.5 + r3.x;
        r0.z = r0.z * r2.w + r2.z;
        r3.xz = float2(-0.300000012,-0.5) + r2.zz;
        r3.xz = saturate(float2(5.00000048,100.000099) * r3.xz);
        r4.xy = r3.xz * float2(-2,-2) + float2(3,3);
        r3.xz = r3.xz * r3.xz;
        r3.xz = r4.xy * r3.xz;
        r2.w = r3.y * r3.x;
        r0.x = r2.w * r0.x + 0.600000024;
        r0.x = min(1, r0.x);
        r2.w = 255 * r0.z;
        r3.xyw = min(float3(1,1,1), r5.zwz);
        r5.xyz = float3(1,1,1) + -r3.wyw;
        r5.xyz = -r5.xyz * r5.xyz + float3(1,1,1);
        r5.xyz = sqrt(r5.xyz);
        r6.xyz = float3(1,1,1) + -r5.zyz;
        r7.xyz = sin(r3.xyw);
        r5.xyz = r6.xyz * r7.xyz + r5.xyz;
        r6.xyzw = r5.xxyy * float4(255,255,255,255) + float4(-20,20,-5,5);
        r7.xyzw = cmp(r6.xyzw >= r2.wwww);
        r3.xw = r0.zz * float2(255,255) + -r6.xz;
        r3.xw = -r3.xw * float2(0.0250000004,0.100000001) + float2(1,1);
        r3.xw = r7.yw ? r3.xw : 0;
        r3.xw = r7.xz ? float2(1,1) : r3.xw;
        r0.z = 1.42857146 * r3.y;
        r0.z = max(0, r0.z);
        r0.z = min(0.300000012, r0.z);
        r0.z = r3.w * r0.z;
        r0.z = max(r3.x, r0.z);
        r0.x = r0.x * r0.z;
        r0.z = r0.x * -0.0500000007 + 0.0500000007;
        r2.w = saturate(r0.x);
        r0.z = r2.w * r0.z;
        r2.w = r5.z * 9 + time_in_sec;
        r3.x = 0.200000003 * r2.w;
        r3.x = frac(r3.x);
        r3.yw = -r3.xx * float2(0.200000003,0.200000003) + r4.zw;
        r3.y = t_ink_flood_map.Sample(s_shroud_wrap_s, r3.yw).y;
        r2.w = r2.w * 0.200000003 + 0.5;
        r2.w = frac(r2.w);
        r4.xy = -r2.ww * float2(0.200000003,0.200000003) + r4.zw;
        r2.w = t_ink_flood_map.Sample(s_shroud_wrap_s, r4.xy).y;
        r2.z = 0.5 + -r2.z;
        r2.z = saturate(100.000099 * r2.z);
        r3.w = r2.z * -2 + 3;
        r2.z = r2.z * r2.z;
        r2.z = -r3.w * r2.z + 1;
        r3.x = -0.5 + r3.x;
        r3.x = r3.x + r3.x;
        r2.w = r2.w + -r3.y;
        r2.w = abs(r3.x) * r2.w + r3.y;
        r2.w = 1 + r2.w;
        r2.w = r2.w * r0.x;
        r2.z = 1 + -r2.z;
        r2.z = r2.w * r2.z;
        r0.x = r0.z * r0.x + -g_discovered_shroud_brightness;
        r0.x = r2.z * r0.x + g_discovered_shroud_brightness;
        r0.z = r0.y * r0.x;
        r0.x = -r0.y * r0.x + 1;
        r0.x = r3.z * r0.x + r0.z;
        r0.x = -1 + r0.x;
        r0.x = g_shroud_fade_in_out_alpha * r0.x + 1;
      } else {
        r0.x = 1;
      }
    } else {
      r0.x = 1;
    }
  } else {
    r0.x = 1;
  }
  r1.yzw = sp_map_alpha * r1.yzw;
  r0.x = saturate(r0.x * 3 + 0.400000006);
  r1.yzw = r1.yzw * float3(0.800000012,0.800000012,0.800000012) + float3(-0.699999988,-0.649999976,-0.5);
  r0.xyz = r0.xxx * r1.yzw + float3(0.699999988,0.649999976,0.5);
  // Gather faction-lookup atlases and blend them using the campaign lookup indirections.
  r1.yz = float2(3840,3024) * r2.xy;
  r3.xyzw = r2.xxxx * float4(3840,3840,3840,3840) + float4(0.25,0.75,-0.25,-0.75);
  r4.x = (int)r3.y;
  r4.y = (int)r1.z;
  r4.zw = float2(0,0);
  r1.w = t_xml_campaign_lookup.Load(r4.xyz).x;
  r1.w = 65536 * r1.w;
  r1.w = r1.w / sp_faction_number;
  r1.w = 512 * r1.w;
  r4.x = (int)r1.w;
  r4.yzw = float3(0,0,0);
  r4.xyzw = t_xml_Input_Texture.Load(r4.xyz).xyzw;
  r5.x = (int)r3.z;
  r5.y = (int)r1.z;
  r5.zw = float2(0,0);
  r1.w = t_xml_campaign_lookup3.Load(r5.xyz).x;
  r1.w = 65536 * r1.w;
  r1.w = r1.w / sp_faction_number;
  r1.w = 512 * r1.w;
  r5.x = (int)r1.w;
  r5.yzw = float3(0,0,0);
  r5.xyzw = t_xml_Input_Texture2.Load(r5.xyz).xyzw;
  r6.xyzw = r2.yyyy * float4(3024,3024,3024,3024) + float4(0.5,-0.5,0.25,0.75);
  r7.x = (int)r3.x;
  r7.y = (int)r6.x;
  r7.zw = float2(0,0);
  r1.w = t_xml_campaign_lookup1.Load(r7.xyz).x;
  r1.w = 65536 * r1.w;
  r1.w = r1.w / sp_faction_number;
  r1.w = 512 * r1.w;
  r7.x = (int)r1.w;
  r7.yzw = float3(0,0,0);
  r7.xyzw = t_xml_Input_Texture1.Load(r7.xyz).xyzw;
  r8.x = (int)r3.x;
  r8.y = (int)r6.y;
  r8.zw = float2(0,0);
  r1.w = t_xml_campaign_lookup4.Load(r8.xyz).x;
  r1.w = 65536 * r1.w;
  r1.w = r1.w / sp_faction_number;
  r1.w = 512 * r1.w;
  r8.x = (int)r1.w;
  r8.yzw = float3(0,0,0);
  r8.xyzw = t_xml_Input_Texture3.Load(r8.xyz).xyzw;
  r5.xyzw = r5.xwyz + -r4.xwyz;
  r4.xyzw = r5.xyzw * float4(0.5,0.5,0.5,0.5) + r4.xwyz;
  r5.xyzw = r8.xwyz + -r7.xwyz;
  r5.xyzw = r5.xyzw * float4(0.5,0.5,0.5,0.5) + r7.xwyz;
  r5.xyzw = r5.xyzw + -r4.xyzw;
  r4.xyzw = r5.xyzw * float4(0.5,0.5,0.5,0.5) + r4.xyzw;
  r5.x = (int)r3.x;
  r5.y = (int)r1.z;
  r5.zw = float2(0,0);
  r1.w = t_xml_campaign_lookup.Load(r5.xyz).x;
  r1.w = 65536 * r1.w;
  r1.w = r1.w / sp_faction_number;
  r1.w = 512 * r1.w;
  r5.x = (int)r1.w;
  r5.yzw = float3(0,0,0);
  r5.xyzw = t_xml_Input_Texture.Load(r5.xyz).xyzw;
  r7.x = (int)r3.w;
  r7.y = (int)r1.z;
  r7.zw = float2(0,0);
  r1.z = t_xml_campaign_lookup3.Load(r7.xyz).x;
  r1.z = 65536 * r1.z;
  r1.z = r1.z / sp_faction_number;
  r1.z = 512 * r1.z;
  r7.x = (int)r1.z;
  r7.yzw = float3(0,0,0);
  r7.xyzw = t_xml_Input_Texture2.Load(r7.xyz).xyzw;
  r8.x = (int)r3.z;
  r8.y = (int)r6.x;
  r8.zw = float2(0,0);
  r1.z = t_xml_campaign_lookup1.Load(r8.xyz).x;
  r1.z = 65536 * r1.z;
  r1.z = r1.z / sp_faction_number;
  r1.z = 512 * r1.z;
  r8.x = (int)r1.z;
  r8.yzw = float3(0,0,0);
  r8.xyzw = t_xml_Input_Texture1.Load(r8.xyz).xyzw;
  r3.x = (int)r3.z;
  r3.y = (int)r6.y;
  r3.zw = float2(0,0);
  r1.z = t_xml_campaign_lookup4.Load(r3.xyz).x;
  r1.z = 65536 * r1.z;
  r1.z = r1.z / sp_faction_number;
  r1.z = 512 * r1.z;
  r3.x = (int)r1.z;
  r3.yzw = float3(0,0,0);
  r3.xyzw = t_xml_Input_Texture3.Load(r3.xyz).xyzw;
  r7.xyzw = r7.xwyz + -r5.xwyz;
  r5.xyzw = r7.xyzw * float4(0.5,0.5,0.5,0.5) + r5.xwyz;
  r3.xyzw = r3.xwyz + -r8.xwyz;
  r3.xyzw = r3.xyzw * float4(0.5,0.5,0.5,0.5) + r8.xwyz;
  r3.xyzw = r3.xyzw + -r5.xyzw;
  r3.xyzw = r3.xyzw * float4(0.5,0.5,0.5,0.5) + r5.xyzw;
  r3.xyzw = r3.xyzw + -r4.xyzw;
  r3.xyzw = r3.xyzw * float4(0.5,0.5,0.5,0.5) + r4.xyzw;
  r2.xyzw = r2.xxyy * float4(3840,3840,3024,3024) + float4(0.5,-0.5,-0.25,-0.75);
  r4.x = (int)r2.x;
  r4.y = (int)r6.z;
  r4.zw = float2(0,0);
  r1.z = t_xml_campaign_lookup.Load(r4.xyz).x;
  r1.z = 65536 * r1.z;
  r1.z = r1.z / sp_faction_number;
  r1.z = 512 * r1.z;
  r4.x = (int)r1.z;
  r4.yzw = float3(0,0,0);
  r4.xyzw = t_xml_Input_Texture.Load(r4.xyz).xyzw;
  r5.x = (int)r2.y;
  r5.y = (int)r6.z;
  r5.zw = float2(0,0);
  r1.z = t_xml_campaign_lookup3.Load(r5.xyz).x;
  r1.z = 65536 * r1.z;
  r1.z = r1.z / sp_faction_number;
  r1.z = 512 * r1.z;
  r5.x = (int)r1.z;
  r5.yzw = float3(0,0,0);
  r5.xyzw = t_xml_Input_Texture2.Load(r5.xyz).xyzw;
  r7.x = (int)r1.y;
  r7.y = (int)r6.w;
  r7.zw = float2(0,0);
  r1.z = t_xml_campaign_lookup1.Load(r7.xyz).x;
  r1.z = 65536 * r1.z;
  r1.z = r1.z / sp_faction_number;
  r1.z = 512 * r1.z;
  r7.x = (int)r1.z;
  r7.yzw = float3(0,0,0);
  r7.xyzw = t_xml_Input_Texture1.Load(r7.xyz).xyzw;
  r8.x = (int)r1.y;
  r8.y = (int)r2.z;
  r8.zw = float2(0,0);
  r1.z = t_xml_campaign_lookup4.Load(r8.xyz).x;
  r1.z = 65536 * r1.z;
  r1.z = r1.z / sp_faction_number;
  r1.z = 512 * r1.z;
  r8.x = (int)r1.z;
  r8.yzw = float3(0,0,0);
  r8.xyzw = t_xml_Input_Texture3.Load(r8.xyz).xyzw;
  r5.xyzw = r5.xwyz + -r4.xwyz;
  r4.xyzw = r5.xyzw * float4(0.5,0.5,0.5,0.5) + r4.xwyz;
  r5.xyzw = r8.xwyz + -r7.xwyz;
  r5.xyzw = r5.xyzw * float4(0.5,0.5,0.5,0.5) + r7.xwyz;
  r5.xyzw = r5.xyzw + -r4.xyzw;
  r4.xyzw = r5.xyzw * float4(0.5,0.5,0.5,0.5) + r4.xyzw;
  r5.xy = (int2)r2.xz;
  r5.zw = float2(0,0);
  r1.z = t_xml_campaign_lookup.Load(r5.xyz).x;
  r1.z = 65536 * r1.z;
  r1.z = r1.z / sp_faction_number;
  r1.z = 512 * r1.z;
  r5.x = (int)r1.z;
  r5.yzw = float3(0,0,0);
  r5.xyzw = t_xml_Input_Texture.Load(r5.xyz).xyzw;
  r7.xy = (int2)r2.yz;
  r7.zw = float2(0,0);
  r1.z = t_xml_campaign_lookup3.Load(r7.xyz).x;
  r1.z = 65536 * r1.z;
  r1.z = r1.z / sp_faction_number;
  r1.z = 512 * r1.z;
  r7.x = (int)r1.z;
  r7.yzw = float3(0,0,0);
  r7.xyzw = t_xml_Input_Texture2.Load(r7.xyz).xyzw;
  r8.x = (int)r1.y;
  r8.y = (int)r6.z;
  r8.zw = float2(0,0);
  r1.z = t_xml_campaign_lookup1.Load(r8.xyz).x;
  r1.z = 65536 * r1.z;
  r1.z = r1.z / sp_faction_number;
  r1.z = 512 * r1.z;
  r6.x = (int)r1.z;
  r6.yzw = float3(0,0,0);
  r6.xyzw = t_xml_Input_Texture1.Load(r6.xyz).xyzw;
  r8.x = (int)r1.y;
  r8.y = (int)r2.w;
  r8.zw = float2(0,0);
  r1.y = t_xml_campaign_lookup4.Load(r8.xyz).x;
  r1.y = 65536 * r1.y;
  r1.y = r1.y / sp_faction_number;
  r1.y = 512 * r1.y;
  r2.x = (int)r1.y;
  r2.yzw = float3(0,0,0);
  r2.xyzw = t_xml_Input_Texture3.Load(r2.xyz).xyzw;
  r7.xyzw = r7.xwyz + -r5.xwyz;
  r5.xyzw = r7.xyzw * float4(0.5,0.5,0.5,0.5) + r5.xwyz;
  r2.xyzw = r2.xwyz + -r6.xwyz;
  r2.xyzw = r2.xyzw * float4(0.5,0.5,0.5,0.5) + r6.xwyz;
  r2.xyzw = r2.xyzw + -r5.xyzw;
  r2.xyzw = r2.xyzw * float4(0.5,0.5,0.5,0.5) + r5.xyzw;
  r2.xyzw = r2.xyzw + -r4.xyzw;
  r2.xyzw = r2.xyzw * float4(0.5,0.5,0.5,0.5) + r4.xyzw;
  r2.xyzw = r2.xyzw + -r3.xyzw;
  r2.xyzw = r2.xyzw * float4(0.5,0.5,0.5,0.5) + r3.xyzw;
  r1.y = saturate(1.5 * r2.y);
  r1.z = sp_Screen_Alpha * r1.y;
  r1.w = cmp(r0.w < g_world_bounds.z);
  r0.w = cmp(g_world_bounds.x < r0.w);
  r0.w = r1.w ? r0.w : 0;
  r0.w = r0.w ? 1.000000 : 0;
  r1.w = cmp(r1.x < g_world_bounds.w);
  r1.x = cmp(g_world_bounds.y < r1.x);
  r1.x = r1.w ? r1.x : 0;
  r1.x = r1.x ? 1.000000 : 0;
  r0.w = r1.x * r0.w;
  r0.w = r1.z * r0.w;
  r1.xzw = r2.xzw + -r0.xyz;
  r0.xyz = r0.www * r1.xzw + r0.xyz;
  r0.xyz = max(float3(9.99999997e-07,9.99999997e-07,9.99999997e-07), r0.xyz);
  r1.x = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.xyz = r1.xxx / r0.xyz;
  r1.z = g_tone_mapping_brightness * g_tone_mapping_brightness;
  r0.xyz = r1.zzz * r0.xyz;
  // Apply a Reinhard-like tone curve with optional burn limit to keep the campaign view legible.
  r1.z = cmp(g_tone_mapping_burn < 9.99999997e-07);
  r2.xyz = -r1.xxx * r0.xyz + r0.xyz;
  r3.xyz = cmp(r2.xyz < float3(9.99999997e-07,9.99999997e-07,9.99999997e-07));
  r3.xyz = r3.xyz ? float3(1,1,1) : r2.xyz;
  r3.xyz = r1.xxx / r3.xyz;
  r1.w = 1 / g_tone_mapping_burn;
  r1.w = -0.999000013 + r1.w;
  r1.w = 1 / r1.w;
  r0.xyz = r0.xyz * r0.xyz;
  r0.xyz = r0.xyz * r1.www;
  r4.xyz = -r1.xxx * r0.xyz;
  r4.xyz = float3(4,4,4) * r4.xyz;
  r4.xyz = r2.xyz * r2.xyz + -r4.xyz;
  r4.xyz = max(float3(0,0,0), r4.xyz);
  r4.xyz = sqrt(r4.xyz);
  r2.xyz = r4.xyz + -r2.xyz;
  r0.xyz = r0.xyz + r0.xyz;
  r0.xyz = max(float3(9.99999997e-07,9.99999997e-07,9.99999997e-07), r0.xyz);
  r0.xyz = r2.xyz / r0.xyz;
  o0.xyz = r1.zzz ? r3.xyz : r0.xyz;
  r0.x = -sp_map_alpha + r1.y;
  r0.x = r0.w * r0.x + sp_map_alpha;
  r0.y = sp_map_alpha + -r0.x;
  o0.w = sp_map_alpha * r0.y + r0.x;
  return;
}