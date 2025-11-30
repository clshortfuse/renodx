// ---- Created with 3Dmigoto v1.4.1 on Thu Oct 23 20:50:43 2025
// Large volumetric lighting shader. Integrates shadow maps, noise textures,
// fog parameters, and spherical harmonics to accumulate atmospheric scattering.

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

cbuffer shadowmap_PS : register(b1)
{
  float4 g_vHardShadowBufferSize : packoffset(c0);
  float4x4 g_amHardSplit[4] : packoffset(c1);
  float4x4 g_amHardSplit_prewarp[4] : packoffset(c17);
  float2 g_fFadeRange : packoffset(c33);
  float g_sample_bias : packoffset(c33.z);
  float g_iSplitCount : packoffset(c33.w);
  float3 g_shadow_light_direction : packoffset(c34);
  float g_split_distances[5] : packoffset(c35);
  uint g_static_shadows_enabled : packoffset(c39.y);
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

cbuffer fog_legacy : register(b3)
{
  float3 g_legacy_volume_fog_colour : packoffset(c0);
  float g_legacy_fog_distance_start : packoffset(c0.w);
  float g_legacy_fog_distance_strength : packoffset(c1);
  float g_legacy_fog_distance_scale : packoffset(c1.y);
  float g_legacy_fog_height_bottom : packoffset(c1.z);
  float g_legacy_fog_height_top : packoffset(c1.w);
  float g_legacy_fog_height_strength : packoffset(c2);
  float g_legacy_fog_colour_blend : packoffset(c2.y);
  float g_legacy_fog_clear_distance : packoffset(c2.z);
  float2 g_legacy_force_fog : packoffset(c3);
  float g_legacy_fog_lerp : packoffset(c3.z);
}

cbuffer fog : register(b4)
{
  float g_fog_density_constant : packoffset(c0);
  float g_fog_density_height : packoffset(c0.y);
  float g_fog_height_bottom : packoffset(c0.z);
  float g_fog_height_top : packoffset(c0.w);
  float g_fog_density_mie : packoffset(c1);
  float g_fog_noise : packoffset(c1.y);
  float3 g_fog_colour : packoffset(c2);
  uint g_fog_mode : packoffset(c2.w);
  float g_fog_lerp : packoffset(c3);
  float g_fog_clear_distance : packoffset(c3.y);
  float g_fog_y_multiplier : packoffset(c3.z);
  float g_campaign_density_scaling : packoffset(c3.w);
  float g_height_fog_clear_distance : packoffset(c4);
  float g_clear_distance_fade_out : packoffset(c4.y);
  float g_fog_shadow_strength : packoffset(c4.z);
  float g_fog_blur_offset : packoffset(c4.w);
  float g_fog_blur_strength : packoffset(c5);
}

SamplerState s_volume_noise_s : register(s0);
SamplerState s_2d_noise_s : register(s1);
Texture2DArray<float4> t_dynamic_shadows : register(t0);
Texture2DArray<float4> t_static_shadows : register(t1);
Texture2D<float4> t_world_spherical_harmonics : register(t2);
Texture2DArray<float4> t_world_spherical_harmonics_array : register(t3);
Texture3D<float4> t_volume_noise : register(t4);
Texture2D<float4> t_2d_noise : register(t5);
Texture2D<float4> gbuffer_channel_4_texture : register(t6);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 0, 0, 1.000000, 0},
                              { 1, 0, 0, 0},
                              { 2, 0, 1.000000, 0},
                              { 0, 1, 0, 0},
                              { 1, 1, 0, 0},
                              { 2, 1, 0, 0},
                              { 0, 2, 0, 0},
                              { 1, 2, -1.000000, 0},
                              { 2, 2, -1.000000, 0} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = g_screen_size.zw * v0.xy;
  gbuffer_channel_4_texture.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
  r0.zw = uiDest.xy;
  r1.xy = (uint2)r0.zw;
  r1.xy = r1.xy * r0.xy;
  r1.xy = floor(r1.xy);
  r1.xy = (int2)r1.xy;
  r0.zw = (int2)r0.zw + int2(-1,-1);
  r1.xy = max(int2(0,0), (int2)r1.xy);
  r1.xy = min((int2)r1.xy, (int2)r0.zw);
  r1.zw = float2(0,0);
  r1.z = gbuffer_channel_4_texture.Load(r1.xyz).x;
  r0.xy = g_render_target_dimensions.xy * r0.xy;
  r0.xy = g_viewport_dimensions.zw * r0.xy;
  r1.xy = r0.xy * float2(2,-2) + float2(-1,1);
  r1.w = 1;
  r0.x = dot(r1.xyzw, inv_view_projection._m00_m10_m20_m30);
  r0.y = dot(r1.xyzw, inv_view_projection._m01_m11_m21_m31);
  r0.z = dot(r1.xyzw, inv_view_projection._m02_m12_m22_m32);
  r0.w = dot(r1.xyzw, inv_view_projection._m03_m13_m23_m33);
  r0.xyz = r0.xyz / r0.www;
  r1.xy = float2(0.00200000009,0.00200000009) * r0.xz;
  r0.w = t_2d_noise.SampleLevel(s_2d_noise_s, r1.xy, 0).x;
  r0.w = g_legacy_force_fog.x * r0.w;
  r1.xyz = -camera_position.xyz + r0.xyz;
  r1.w = dot(r1.xyz, r1.xyz);
  r2.x = sqrt(r1.w);
  r2.y = min(g_height_fog_clear_distance, g_fog_clear_distance);
  r0.w = r0.w * 0.5 + r2.x;
  r2.z = g_legacy_force_fog.y + -g_legacy_force_fog.x;
  r0.w = -g_legacy_force_fog.x + r0.w;
  r2.z = 1 / r2.z;
  r0.w = saturate(r2.z * r0.w);
  r2.z = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r2.z * r0.w;
  r3.xyz = r1.xyz / r2.xxx;
  r2.z = dot(-r3.xyz, sun_direction.xyz);
  r2.w = 9.99999975e-05 + r2.y;
  r2.w = cmp(r2.w < r2.x);
  if (r2.w != 0) {
    r1.w = rsqrt(r1.w);
    r4.xyz = r1.xyz * r1.www;
    r4.xyz = r4.xyz * r2.yyy + camera_position.xyz;
    r5.xyz = -r4.xyz + r0.xyz;
    r1.w = dot(r5.xyz, r5.xyz);
    r1.w = sqrt(r1.w);
    r2.yw = r4.xz * float2(0.00100000005,0.00100000005) + v0.xy;
    r2.yw = r3.xy * float2(0.100000001,0.100000001) + r2.yw;
    r2.yw = g_camera_jitter.xy + r2.yw;
    r2.yw = float2(0.103100002,0.103100002) * r2.yw;
    r2.yw = frac(r2.yw);
    r5.xyz = float3(19.1900005,19.1900005,19.1900005) + r2.wyy;
    r3.w = dot(r2.ywy, r5.xyz);
    r2.yw = r3.ww + r2.yw;
    r2.w = r2.y + r2.w;
    r2.y = r2.w * r2.y;
    r2.y = frac(r2.y);
    r2.y = frac(r2.y);
    r2.w = -5000 + r1.w;
    r2.w = saturate(0.000125000006 * r2.w);
    r3.w = r2.w * -2 + 3;
    r2.w = r2.w * r2.w;
    r2.w = r3.w * r2.w;
    r3.w = 0.25 + -r2.y;
    r2.y = r2.w * r3.w + r2.y;
    r5.xy = float2(0.0625,0.03125) * r1.ww;
    r5.zw = cmp(float2(0,0.00999999978) < g_fog_shadow_strength);
    r2.w = cmp(0 < g_fog_noise);
    r6.xy = float2(0.00999999978,-0.00999999978) * time_in_sec;
    r7.w = 1;
    r8.w = 1;
    r9.w = 0;
    r11.xyz = float3(0,0,0);
    r6.zw = float2(0,0);
    r3.w = 0;
    r4.w = 0;
    r10.xyzw = float4(0,0,0,0);
    while (true) {
      r11.w = cmp((int)r10.w >= 16);
      if (r11.w != 0) break;
      r11.w = (int)r10.w;
      r11.w = r11.w + r2.y;
      r11.w = r5.x * r11.w + r5.y;
      r11.w = min(r11.w, r1.w);
      r7.xyz = r3.xyz * r11.www + r4.xyz;
      if (r5.z != 0) {
        r12.x = dot(r7.xyzw, view_projection._m03_m13_m23_m33);
        r12.y = cmp(r11.w < 1000);
        r12.z = cmp(1 < (int)r10.w);
        r12.y = r12.z ? r12.y : 0;
        r8.xyz = -g_shadow_light_direction.xyz * g_sample_bias + r7.xyz;
        r13.x = cmp(r12.x >= g_split_distances[1]);
        r13.y = cmp(r12.x >= g_split_distances[2]);
        r13.z = cmp(r12.x >= g_split_distances[3]);
        r13.w = cmp(r12.x >= g_split_distances[4]);
        r13.xyzw = r13.xyzw ? float4(1,1,1,1) : 0;
        r12.x = dot(r13.xyzw, r13.xyzw);
        r12.x = 0.5 + r12.x;
        r12.x = floor(r12.x);
        r9.z = (int)r12.x;
        r12.z = (uint)r9.z << 2;
        r13.x = dot(r8.xyzw, g_amHardSplit[r12.z/4]._m00_m10_m20_m30);
        r13.y = dot(r8.xyzw, g_amHardSplit[r12.z/4]._m01_m11_m21_m31);
        r13.z = dot(r8.xyzw, g_amHardSplit[r12.z/4]._m02_m12_m22_m32);
        r8.x = dot(r8.xyzw, g_amHardSplit[r12.z/4]._m03_m13_m23_m33);
        r14.xyz = r13.xyz / r8.xxx;
        r8.y = cmp(r12.x >= g_iSplitCount);
        r12.xzw = cmp(r14.xyz < float3(0,0,0));
        r8.z = (int)r12.z | (int)r12.x;
        r8.z = (int)r12.w | (int)r8.z;
        r12.xzw = cmp(float3(1,1,1) < r14.xyz);
        r12.x = (int)r12.z | (int)r12.x;
        r12.x = (int)r12.w | (int)r12.x;
        r8.z = (int)r8.z | (int)r12.x;
        r8.y = (int)r8.z | (int)r8.y;
        if (r8.y == 0) {
          r8.xy = r13.xy / r8.xx;
          r8.xy = g_vHardShadowBufferSize.xy * r8.xy;
          r8.xy = floor(r8.xy);
          r9.xy = (int2)r8.xy;
          r8.x = t_dynamic_shadows.Load(r9.xyzw).x;
          r8.y = t_static_shadows.Load(r9.xyzw).x;
          r8.y = g_static_shadows_enabled ? r8.y : 1;
          r8.x = min(r8.x, r8.y);
          r8.x = cmp(r14.z < r8.x);
          r8.x = r8.x ? 1.000000 : 0;
        } else {
          r8.x = 1;
        }
        r8.x = r12.y ? r8.x : 1;
      } else {
        r8.x = 1;
      }
      r8.y = cmp(r11.w < 400);
      r8.y = r2.w ? r8.y : 0;
      if (r8.y != 0) {
        r9.xyz = time_in_sec * float3(4.4000001,-4.4000001,4.4000001) + r7.xyz;
        r9.xyz = float3(0.00999999978,0.00999999978,0.00999999978) * r9.xyz;
        r7.x = t_volume_noise.SampleLevel(s_volume_noise_s, r9.xyz, 0).x;
        r7.x = r7.x * 2 + -1;
        r7.x = r7.x * g_fog_noise + 1;
      } else {
        r7.x = 1;
      }
      r4.w = r7.x + r4.w;
      r7.x = 60000 + -r7.y;
      r7.z = r7.x * 0.5 + r7.y;
      r7.yz = max(float2(0,0), r7.yz);
      r8.yz = float2(-0.000206276105,-0.00120224594) * r7.zz;
      r8.yz = exp2(r8.yz);
      r7.z = g_fog_density_mie * r8.z;
      r9.xy = float2(-0.000206276105,-0.00120224594) * r7.yy;
      r9.xy = exp2(r9.xy);
      r7.y = r9.x * r5.x;
      r6.z = r9.x * r5.x + r6.z;
      r8.z = g_fog_density_mie * r9.y;
      r9.x = r8.z * r5.x;
      r6.w = r8.z * r5.x + r6.w;
      r8.y = r8.y * r7.x + r6.z;
      r7.x = r7.z * r7.x + r6.w;
      r7.x = 2.20000002e-05 * r7.x;
      r12.xyz = r8.yyy * float3(5.80000005e-06,1.35e-05,3.3100001e-05) + r7.xxx;
      r12.xyz = float3(-1.44269502,-1.44269502,-1.44269502) * r12.xyz;
      r12.xyz = exp2(r12.xyz);
      r7.xyz = r12.xyz * r7.yyy;
      r10.xyz = r7.xyz * r8.xxx + r10.xyz;
      r7.xyz = r12.xyz * r9.xxx;
      r11.xyz = r7.xyz * r8.xxx + r11.xyz;
      r3.w = r8.x + r3.w;
      r10.w = (int)r10.w + 1;
    }
    r1.w = r2.z * r2.z + 1;
    r2.y = 0.5 * r1.w;
    r4.xyz = r10.xyz * r2.yyy;
    r2.y = -r2.z * 1.51999998 + 1.5776;
    r2.y = log2(r2.y);
    r2.y = 1.5 * r2.y;
    r2.y = exp2(r2.y);
    r1.w = r1.w / r2.y;
    r1.w = 0.000978047145 * r1.w;
    r5.xyz = r11.xyz * r1.www;
    r5.xyz = float3(1.99999995e-05,1.99999995e-05,1.99999995e-05) * r5.xyz;
    r4.xyz = r4.xyz * float3(5.80000005e-06,1.35e-05,3.3100001e-05) + r5.xyz;
    r1.w = 0.0625 * r3.w;
    r2.y = 0.0625 * r4.w;
    r2.w = -g_height_fog_clear_distance + r2.x;
    r2.w = max(0, r2.w);
    r0.xyz = r0.xyz * float3(0.00100000005,0.00100000005,0.00100000005) + r6.xyx;
    r0.x = t_volume_noise.SampleLevel(s_volume_noise_s, r0.xyz, 0).x;
    r0.x = -0.5 + r0.x;
    r0.y = -0.0799999982 * r0.x;
    r0.xz = float2(0,0);
    r0.xyz = r3.xyz + r0.xyz;
    r0.x = dot(r0.xyz, r0.xyz);
    r0.x = rsqrt(r0.x);
    r0.x = r0.y * r0.x;
    r0.y = r0.x * g_height_fog_clear_distance + camera_position.y;
    r0.z = cmp(r0.y >= g_fog_height_top);
    r3.x = cmp(0 < r0.x);
    r0.z = r0.z ? r3.x : 0;
    if (r0.z == 0) {
      r3.xy = -g_fog_height_top + r0.yy;
      r3.xy = r3.xy / -r0.xx;
      r0.z = 10000 + r0.y;
      r0.z = r0.z / -r0.x;
      r3.z = min(r3.x, r3.y);
      r3.x = max(r3.x, r3.y);
      r3.xz = max(float2(0,0), r3.xz);
      r4.w = min(r3.y, r0.z);
      r0.z = max(r3.y, r0.z);
      r3.y = max(0, r4.w);
      r0.z = max(0, r0.z);
      r4.w = g_fog_density_height * r2.y;
      r4.w = 0.0125000002 * r4.w;
      r5.x = min(r3.z, r3.x);
      r5.y = max(r3.z, r2.w);
      r5.y = min(r5.y, r3.x);
      r5.z = cmp(r5.x != r5.y);
      r0.y = r3.z * r0.x + r0.y;
      r5.y = r5.y + -r3.z;
      r6.x = r5.x + -r3.z;
      r6.y = g_fog_height_top + -g_fog_height_bottom;
      r6.y = r6.y + r6.y;
      r0.y = r0.y + r0.y;
      r6.z = r6.x * r0.x + r0.y;
      r6.z = -g_fog_height_top * 2 + r6.z;
      r6.x = r6.x * r6.z;
      r6.x = r6.x * r4.w;
      r6.x = r6.x / r6.y;
      r6.x = 1.44269502 * r6.x;
      r6.x = exp2(r6.x);
      r6.z = r5.y * r0.x + r0.y;
      r6.z = -g_fog_height_top * 2 + r6.z;
      r5.y = r6.z * r5.y;
      r5.y = r5.y * r4.w;
      r5.y = r5.y / r6.y;
      r5.y = 1.44269502 * r5.y;
      r5.y = exp2(r5.y);
      r5.y = r6.x + -r5.y;
      r6.x = min(r3.y, r0.z);
      r6.z = max(r5.x, r3.y);
      r6.z = min(r6.z, r0.z);
      r6.w = cmp(r6.x != r6.z);
      r6.z = r6.z + -r3.y;
      r6.z = -r6.z * r4.w;
      r6.z = 1.44269502 * r6.z;
      r6.z = exp2(r6.z);
      r6.z = r6.z * r5.y;
      r5.y = r6.w ? r6.z : r5.y;
      r5.y = r5.z ? r5.y : 0;
      r5.z = max(r3.y, r2.w);
      r0.z = min(r5.z, r0.z);
      r5.z = cmp(r6.x != r0.z);
      r6.z = r0.z + -r3.y;
      r3.y = r6.x + -r3.y;
      r3.y = -r3.y * r4.w;
      r3.y = 1.44269502 * r3.y;
      r3.y = exp2(r3.y);
      r6.x = -r6.z * r4.w;
      r6.x = 1.44269502 * r6.x;
      r6.x = exp2(r6.x);
      r3.y = -r6.x + r3.y;
      r0.z = max(r0.z, r3.z);
      r0.z = min(r0.z, r3.x);
      r3.x = cmp(r5.x != r0.z);
      r0.z = r0.z + -r3.z;
      r0.x = r0.z * r0.x + r0.y;
      r0.x = -g_fog_height_top * 2 + r0.x;
      r0.x = r0.z * r0.x;
      r0.x = r0.x * r4.w;
      r0.x = r0.x / r6.y;
      r0.x = 1.44269502 * r0.x;
      r0.x = exp2(r0.x);
      r0.x = r3.y * r0.x;
      r0.x = r3.x ? r0.x : r3.y;
      r0.x = r5.y + r0.x;
      r0.xyz = r5.zzz ? r0.xxx : r5.yyy;
    } else {
      r0.xyz = float3(0,0,0);
    }
    r0.xyz = r0.xyz * r1.www;
    r1.w = 1 / g_clear_distance_fade_out;
    r1.w = saturate(r2.w * r1.w);
    r2.w = r1.w * -2 + 3;
    r1.w = r1.w * r1.w;
    r1.w = r2.w * r1.w;
    r0.xyz = r1.www * r0.xyz;
    r1.w = -g_fog_clear_distance + r2.x;
    r1.w = max(0, r1.w);
    r2.w = cmp(0.00999999978 < r1.w);
    r2.w = r2.w ? r5.w : 0;
    r3.x = min(g_clear_distance_fade_out, r1.w);
    r3.y = r3.x * r3.x;
    r3.z = g_clear_distance_fade_out + g_clear_distance_fade_out;
    r3.y = r3.y / r3.z;
    r3.x = -r3.x + r1.w;
    r3.x = r3.y + r3.x;
    r3.x = r3.x / r1.w;
    r2.w = r2.w ? r3.x : 1;
    r2.y = g_fog_density_constant * r2.y;
    r2.y = r2.y * r2.w;
    r1.w = r2.y * r1.w;
    r1.w = 0.0180336889 * r1.w;
    r2.y = exp2(r1.w);
    r1.w = exp2(-r1.w);
    r2.w = r2.y + r1.w;
    r1.w = r2.y + -r1.w;
    r1.w = 0.5 * r1.w;
    r1.w = saturate(r2.w * 0.5 + -r1.w);
    r1.w = 1 + -r1.w;
    r2.y = r3.w * 0.0625 + -1;
    r2.y = g_fog_shadow_strength * r2.y + 1;
    r1.w = r2.y * r1.w;
    r0.xyz = max(r1.www, r0.xyz);
  } else {
    r0.xyz = float3(0,0,0);
    r4.xyz = float3(0,0,0);
  }
  r0.xyz = max(r0.xyz, r0.www);
  r0.w = r2.z * r2.z + 1;
  r0.w = 0.5 * r0.w;
  r2.yzw = r0.xyz * r0.www + r4.xyz;
  r3.xyz = r0.xyz * r0.www + -r2.yzw;
  r0.xyz = r0.xyz * r3.xyz + r2.yzw;
  r0.xyz = g_fog_colour.xyz * r0.xyz;
  r0.w = 1 / r2.x;
  r0.w = min(1, r0.w);
  r2.xyz = r0.www * r1.xyz;
  r1.xy = r0.ww * r1.xz + camera_position.xz;
  if (g_use_spherical_harmonics_array != 0) {
    t_world_spherical_harmonics_array.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z, uiDest.w);
    r3.xyz = uiDest.xyz;
    r4.xyzw = g_playable_area_bounds.xyxy + g_playable_area_bounds.zwzw;
    r5.xyzw = float4(0.5,0.5,0.5,0.5) * r4.xyzw;
    r4.xyzw = -r4.zwzw * float4(0.5,0.5,0.5,0.5) + g_playable_area_bounds.xyzw;
    r4.xyzw = r4.xyzw * float4(1.04999995,1.04999995,1.04999995,1.04999995) + r5.xyzw;
    r1.zw = cmp(r1.xy < r4.xy);
    r5.xy = cmp(r4.zw < r1.xy);
    r1.zw = (int2)r1.zw | (int2)r5.xy;
    r0.w = (int)r1.w | (int)r1.z;
    r1.z = dot(r2.xyz, r2.xyz);
    r1.z = rsqrt(r1.z);
    r1.zw = r2.xz * r1.zz;
    r5.xy = cmp(r1.zw < float2(0,0));
    r4.xy = camera_position.xz + -r4.xy;
    r4.zw = -camera_position.xz + r4.zw;
    r4.xy = r5.xy ? r4.xy : r4.zw;
    r4.zw = float2(9.99999975e-05,9.99999975e-05) + abs(r1.zw);
    r4.xy = r4.xy / r4.zw;
    r2.w = min(r4.x, r4.y);
    r1.zw = r1.zw * r2.ww + camera_position.xz;
    r1.zw = r0.ww ? r1.zw : r1.xy;
    r1.zw = -g_playable_area_bounds.xy + r1.zw;
    r4.xy = g_playable_area_bounds.zw + -g_playable_area_bounds.xy;
    r1.zw = r1.zw / r4.xy;
    r4.xy = float2(-1,-1) + r1.zw;
    r4.xy = max(r4.xy, -r1.zw);
    r4.xy = max(float2(0,0), r4.xy);
    r0.w = max(r4.x, r4.y);
    r1.zw = saturate(r1.zw);
    uiDest.xy = (uint2)r3.xy / int2(3,3);
    r3.xy = uiDest.xy;
    r3.xy = (uint2)r3.xy;
    r4.xy = r3.xy * r1.zw;
    r4.zw = trunc(r4.xy);
    r5.xy = float2(1,1) / r3.xy;
    r1.zw = r5.xy + r1.zw;
    r1.zw = frac(r1.zw);
    r1.zw = r3.xy * r1.zw;
    r1.zw = trunc(r1.zw);
    r3.xy = frac(r4.xy);
    r2.w = (uint)r3.z;
    r3.w = g_time_of_day_unary * r2.w;
    r4.x = trunc(r3.w);
    r4.y = r4.x * r2.w;
    r4.y = cmp(r4.y >= -r4.y);
    r2.w = r4.y ? r2.w : -r2.w;
    r4.y = 1 / r2.w;
    r4.x = r4.x * r4.y;
    r4.x = frac(r4.x);
    r2.w = r4.x * r2.w;
    r5.z = (uint)r2.w;
    r2.w = (int)r5.z + 1;
    r6.z = (uint)r2.w % (uint)r3.z;
    r2.w = frac(r3.w);
    r3.z = round(g_spherical_harmonic_terms);
    r3.z = (int)r3.z;
    r5.w = 0;
    r7.zw = r5.zw;
    r8.zw = r7.zw;
    r9.zw = r8.zw;
    r10.z = r6.z;
    r11.xyz = float3(0,0,0);
    r3.w = 0;
    while (true) {
      r4.x = cmp((int)r3.w >= (int)r3.z);
      if (r4.x != 0) break;
      r4.x = (uint)r3.w % 3;
      r4.x = (int)r4.x;
      r4.y = r4.z * 3 + r4.x;
      r11.w = (int)icb[r3.w+0].y;
      r12.x = r4.w * 3 + r11.w;
      r5.x = (int)r4.y;
      r5.y = (int)r12.x;
      r12.yzw = t_world_spherical_harmonics_array.Load(r5.xyzw).xyz;
      r4.x = r1.z * 3 + r4.x;
      r7.x = (int)r4.x;
      r7.y = (int)r12.x;
      r13.xyz = t_world_spherical_harmonics_array.Load(r7.xyzw).xyz;
      r11.w = r1.w * 3 + r11.w;
      r8.x = (int)r4.y;
      r8.y = (int)r11.w;
      r14.xyz = t_world_spherical_harmonics_array.Load(r8.xyzw).xyz;
      r9.x = (int)r4.x;
      r9.y = (int)r11.w;
      r15.xyz = t_world_spherical_harmonics_array.Load(r9.xyzw).xyz;
      r6.xyw = r5.xyw;
      r16.xyz = t_world_spherical_harmonics_array.Load(r6.xyzw).xyz;
      r6.xyw = r7.xyw;
      r6.xyw = t_world_spherical_harmonics_array.Load(r6.xyzw).xyz;
      r10.xyw = r8.xyw;
      r17.xyz = t_world_spherical_harmonics_array.Load(r10.xyzw).xyz;
      r10.xyw = r9.xyw;
      r10.xyw = t_world_spherical_harmonics_array.Load(r10.xyzw).xyz;
      r16.xyz = r16.xyz + -r12.yzw;
      r12.xyz = r2.www * r16.xyz + r12.yzw;
      r6.xyw = r6.xyw + -r13.xyz;
      r6.xyw = r2.www * r6.xyw + r13.xyz;
      r13.xyz = r17.xyz + -r14.xyz;
      r13.xyz = r2.www * r13.xyz + r14.xyz;
      r10.xyw = r10.xyw + -r15.xyz;
      r10.xyw = r2.www * r10.xyw + r15.xyz;
      r6.xyw = r6.xyw + -r12.xyz;
      r6.xyw = r3.xxx * r6.xyw + r12.xyz;
      r10.xyw = r10.xyw + -r13.xyz;
      r10.xyw = r3.xxx * r10.xyw + r13.xyz;
      r10.xyw = r10.xyw + -r6.xyw;
      r6.xyw = r3.yyy * r10.xyw + r6.xyw;
      r11.xyz = r6.xyw * icb[r3.w+0].zzz + r11.xyz;
      r3.w = (int)r3.w + 1;
    }
    r0.w = saturate(g_spherical_harmonic_fadeout * r0.w);
    r1.z = cmp(0 < r0.w);
    r3.xyz = ambient_cube_tb[0].xyz + -r11.xyz;
    r3.xyz = r0.www * r3.xyz + r11.xyz;
    r3.xyz = r1.zzz ? r3.xyz : r11.xyz;
    r3.xyz = max(float3(0,0,0), r3.xyz);
    r3.xyz = g_ambient_fudge_factor * r3.xyz;
  } else {
    if (g_use_spherical_harmonics != 0) {
      t_world_spherical_harmonics.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
      r1.zw = uiDest.xy;
      r4.xyzw = g_playable_area_bounds.xyxy + g_playable_area_bounds.zwzw;
      r5.xyzw = float4(0.5,0.5,0.5,0.5) * r4.xyzw;
      r4.xyzw = -r4.zwzw * float4(0.5,0.5,0.5,0.5) + g_playable_area_bounds.xyzw;
      r4.xyzw = r4.xyzw * float4(1.04999995,1.04999995,1.04999995,1.04999995) + r5.xyzw;
      r5.xy = cmp(r1.xy < r4.xy);
      r5.zw = cmp(r4.zw < r1.xy);
      r5.xy = (int2)r5.zw | (int2)r5.xy;
      r0.w = (int)r5.y | (int)r5.x;
      r2.y = dot(r2.xyz, r2.xyz);
      r2.y = rsqrt(r2.y);
      r2.xy = r2.xz * r2.yy;
      r2.zw = cmp(r2.xy < float2(0,0));
      r4.xy = camera_position.xz + -r4.xy;
      r4.zw = -camera_position.xz + r4.zw;
      r2.zw = r2.zw ? r4.xy : r4.zw;
      r4.xy = float2(9.99999975e-05,9.99999975e-05) + abs(r2.xy);
      r2.zw = r2.zw / r4.xy;
      r2.z = min(r2.z, r2.w);
      r2.xy = r2.xy * r2.zz + camera_position.xz;
      r1.xy = r0.ww ? r2.xy : r1.xy;
      r1.xy = -g_playable_area_bounds.xy + r1.xy;
      r2.xy = g_playable_area_bounds.zw + -g_playable_area_bounds.xy;
      r1.xy = r1.xy / r2.xy;
      r2.xy = float2(-1,-1) + r1.xy;
      r2.xy = max(r2.xy, -r1.xy);
      r2.xy = max(float2(0,0), r2.xy);
      r0.w = max(r2.x, r2.y);
      r0.w = saturate(g_spherical_harmonic_fadeout * r0.w);
      r1.xy = saturate(r1.xy);
      r1.xy = frac(r1.xy);
  // Texture packs three coefficients per texel; convert full resolution to tile counts.
  uiDest.zw = (uint2)r1.zw / uint2(3,3);
      r1.zw = uiDest.zw;
      r1.zw = (uint2)r1.zw;
      r2.xy = r1.zw * r1.xy;
      r2.zw = trunc(r2.xy);
      r2.xy = frac(r2.xy);
      r4.xy = float2(1,1) / r1.zw;
      r1.xy = r4.xy + r1.xy;
      r1.xy = frac(r1.xy);
      r1.xy = r1.zw * r1.xy;
      r1.xy = trunc(r1.xy);
      r1.z = round(g_spherical_harmonic_terms);
      r1.z = (int)r1.z;
      r4.zw = float2(0,0);
      r5.zw = float2(0,0);
      r6.zw = float2(0,0);
      r7.zw = float2(0,0);
      r8.xyz = float3(0,0,0);
      r1.w = 0;
      while (true) {
        r3.w = cmp((int)r1.w >= (int)r1.z);
        if (r3.w != 0) break;
        r3.w = (uint)r1.w % 3;
        r3.w = (int)r3.w;
        r8.w = r2.z * 3 + r3.w;
        r9.x = (int)icb[r1.w+0].y;
        r9.y = r2.w * 3 + r9.x;
        r4.x = (int)r8.w;
        r4.y = (int)r9.y;
        r10.xyz = t_world_spherical_harmonics.Load(r4.xyz).xyz;
        r3.w = r1.x * 3 + r3.w;
        r5.x = (int)r3.w;
        r5.y = (int)r9.y;
        r9.yzw = t_world_spherical_harmonics.Load(r5.xyz).xyz;
        r4.x = r1.y * 3 + r9.x;
        r6.x = (int)r8.w;
        r6.y = (int)r4.x;
        r11.xyz = t_world_spherical_harmonics.Load(r6.xyz).xyz;
        r7.x = (int)r3.w;
        r7.y = (int)r4.x;
        r12.xyz = t_world_spherical_harmonics.Load(r7.xyz).xyz;
        r9.xyz = r9.yzw + -r10.xyz;
        r9.xyz = r2.xxx * r9.xyz + r10.xyz;
        r10.xyz = r12.xyz + -r11.xyz;
        r10.xyz = r2.xxx * r10.xyz + r11.xyz;
        r10.xyz = r10.xyz + -r9.xyz;
        r9.xyz = r2.yyy * r10.xyz + r9.xyz;
        r8.xyz = r9.xyz * icb[r1.w+0].zzz + r8.xyz;
        r1.w = (int)r1.w + 1;
      }
      r1.x = cmp(0 < r0.w);
      r1.yzw = ambient_cube_tb[0].xyz + -r8.xyz;
      r1.yzw = r0.www * r1.yzw + r8.xyz;
      r1.xyz = r1.xxx ? r1.yzw : r8.xyz;
      r1.xyz = max(float3(0,0,0), r1.xyz);
      r3.xyz = g_ambient_fudge_factor * r1.xyz;
    } else {
      r3.xyz = g_ambient_fudge_factor * ambient_cube_tb[0].xyz;
    }
  }
  r1.xyz = sun_colour.xyz * float3(1.90384671e-05,1.90384671e-05,1.90384671e-05) + r3.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  o0.xyz = g_fog_lerp * r0.xyz;
  o0.w = g_fog_lerp;
  return;
}