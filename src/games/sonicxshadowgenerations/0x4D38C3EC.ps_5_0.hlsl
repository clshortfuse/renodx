#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Wed Nov 18 20:52:20 2026

cbuffer cbWorld : register(b0)
{
  row_major float4x4 view_matrix : packoffset(c0);
  row_major float4x4 proj_matrix : packoffset(c4);
  row_major float4x4 inv_view_matrix : packoffset(c8);
  row_major float4x4 inv_proj_matrix : packoffset(c12);
  float4 global_clip_plane : packoffset(c16);
  float4 clear_color : packoffset(c17);
  row_major float4x4 view_proj_matrix : packoffset(c18);
  row_major float4x4 inv_view_proj_matrix : packoffset(c22);
  row_major float4x4 prev_view_proj_matrix : packoffset(c26);
  row_major float4x4 uv_reproj_matrix : packoffset(c30);
  float4 jitter_offset : packoffset(c34);
  float4 global_mip_bias : packoffset(c35);
  float4 shadow_camera_view_matrix_third_row : packoffset(c36);
  row_major float4x4 shadow_view_matrix : packoffset(c37);
  row_major float4x4 shadow_view_proj_matrix : packoffset(c41);
  float4 shadow_map_parameter[2] : packoffset(c45);
  float4 shadow_map_size : packoffset(c47);
  float4 shadow_cascade_offset[4] : packoffset(c48);
  float4 shadow_cascade_scale[4] : packoffset(c52);
  float4 shadow_parallax_correct_param[4] : packoffset(c56);
  float4 shadow_cascade_frustums_eye_space_depth : packoffset(c60);
  float4 shadow_cascade_transition_scale : packoffset(c61);
  row_major float4x4 heightmap_view_matrix : packoffset(c62);
  row_major float4x4 heightmap_view_proj_matrix : packoffset(c66);
  float4 heightmap_parameter : packoffset(c70);
  float4 planar_reflection_parameter : packoffset(c71);
  float4 u_lightColor : packoffset(c72);
  float4 u_lightDirection : packoffset(c73);
  float4 u_cameraPosition : packoffset(c74);
  float4 g_probe_data[72] : packoffset(c75);
  float4 g_probe_pos[24] : packoffset(c147);
  float4 g_probe_param[24] : packoffset(c171);
  float4 g_probe_shparam[168] : packoffset(c195);
  float4 g_probe_count : packoffset(c363);
  float4 g_LightScattering_Ray_Mie_Ray2_Mie2 : packoffset(c364);
  float4 g_LightScattering_ConstG_FogDensity : packoffset(c365);
  float4 g_LightScatteringFarNearScale : packoffset(c366);
  float4 g_LightScatteringColor : packoffset(c367);
  float4 g_alphathreshold : packoffset(c368);
  float4 g_smoothness_param : packoffset(c369);
  float4 g_time_param : packoffset(c370);
  float4 u_ibl_param : packoffset(c371);
  float4 u_planar_projection_shadow_plane : packoffset(c372);
  float3 u_planar_projection_shadow_light_position : packoffset(c373);
  float4 u_planar_projection_shadow_color : packoffset(c374);
  float4 u_planar_projection_shadow_param : packoffset(c375);
  float4 g_global_user_param_0 : packoffset(c376);
  float4 g_global_user_param_1 : packoffset(c377);
  float4 g_global_user_param_2 : packoffset(c378);
  float4 g_global_user_param_3 : packoffset(c379);
  float4 g_global_user_param_4 : packoffset(c380);
  float4 g_global_user_param_5 : packoffset(c381);
  float4 g_global_user_param_6 : packoffset(c382);
  float4 g_global_user_param_7 : packoffset(c383);
  bool u_enable_fog_d : packoffset(c384);
  bool u_enable_fog_h : packoffset(c384.y);
  float4 u_fog_param_0 : packoffset(c385);
  float4 u_fog_param_1 : packoffset(c386);
  float4 u_fog_param_2 : packoffset(c387);
  float4 u_fog_param_3 : packoffset(c388);
  float4 g_tonemap_param : packoffset(c389);
  float4 u_contrast_factor[3] : packoffset(c390);
  float4 u_hls_offset : packoffset(c393);
  float4 u_hls_rgb : packoffset(c394);
  float4 u_hls_colorize : packoffset(c395);
  float4 u_color_grading_factor : packoffset(c396);
  float4 u_screen_info : packoffset(c397);
  float4 u_current_viewport_mask : packoffset(c398);
  float4 u_viewport_info : packoffset(c399);
  float4 u_prev_viewport_info : packoffset(c400);
  float4 u_view_param : packoffset(c401);
  float4 u_sggi_param[2] : packoffset(c402);
  float4 u_histogram_param : packoffset(c404);
  float4 u_occlusion_capsule_param[2] : packoffset(c405);
  float4 u_ssao_param : packoffset(c407);
  float4 u_wind_param[5] : packoffset(c408);
  float4 u_wind_frequencies : packoffset(c413);
  float4 u_wind_global_param[3] : packoffset(c414);
  float4 u_grass_lod_distance : packoffset(c417);
  float4 u_grass_dither_distance : packoffset(c418);
  float4 u_weather_param : packoffset(c419);
  float4 u_hiz_param : packoffset(c420);
  float4 u_rlr_param[2] : packoffset(c421);
  float4 u_sky_sh_param[9] : packoffset(c423);
  float4 u_tile_info : packoffset(c432);
  float4 u_detail_param : packoffset(c433);
  bool enable_ibl_plus_directional_specular : packoffset(c434);
  bool enable_rlr : packoffset(c434.y);
  bool enable_rlr_trans_surface : packoffset(c434.z);
  bool enable_vol_shadow : packoffset(c434.w);
  float4 g_debug_option : packoffset(c435);
  float4 g_debug_param_float : packoffset(c436);
  int4 g_debug_param_int : packoffset(c437);
  float4 u_interaction_param[2] : packoffset(c438);
  float4 u_cloud_shadow_param : packoffset(c440);
  float4 u_vol_shadow_param[5] : packoffset(c441);
  float4 cyber_space_noise_param[2] : packoffset(c446);
}

cbuffer cbMaterialDynamic : register(b2)
{
  row_major float4x4 world_matrix : packoffset(c0);
  row_major float4x4 prev_world_matrix : packoffset(c4);
  float4 light_field_color[8] : packoffset(c8);
  float4 u_modulate_color : packoffset(c16);
  float4 u_forcetrans_param : packoffset(c17);
  float4 u_view_offset : packoffset(c18);
  float4 u_vat_type : packoffset(c19);
  float4 u_vat_param : packoffset(c20);
  float4 u_vat_param2 : packoffset(c21);
  float4 u_dvat_pos : packoffset(c22);
  float4 u_dvat_param : packoffset(c23);
  float4 u_timestamp : packoffset(c24);
  float4 u_shading_model_flag : packoffset(c25);
  float4 u_model_user_param_0 : packoffset(c26);
  float4 u_model_user_param_1 : packoffset(c27);
  float4 u_model_user_param_2 : packoffset(c28);
  float4 u_model_user_param_3 : packoffset(c29);
  float4 u_model_user_param_4 : packoffset(c30);
  float4 u_model_user_param_5 : packoffset(c31);
  float4 u_model_user_param_6 : packoffset(c32);
  float4 u_model_user_param_7 : packoffset(c33);
  float4 u_compute_instance_param : packoffset(c34);
  bool enable_shadow_map : packoffset(c35);
  bool u_disable_max_bone_influences_8 : packoffset(c35.y);
}

cbuffer cbMaterialImmutable : register(b1)
{
  float4 emissive : packoffset(c0);
  float4 PBRFactor : packoffset(c1);
  float4 FalloffFactor : packoffset(c2);
  float4 TexcoordIndex_diffuse : packoffset(c3);
  float4 TexcoordMtx_diffuse[2] : packoffset(c4);
  float4 TexcoordIndex_specular : packoffset(c6);
  float4 TexcoordMtx_specular[2] : packoffset(c7);
  float4 TexcoordIndex_normal : packoffset(c9);
  float4 TexcoordMtx_normal[2] : packoffset(c10);
}

cbuffer cb_local_light_context_data : register(b8)
{
  float4 g_local_light_count : packoffset(c0);
  float4 g_local_light_shadow_param[3] : packoffset(c1);
  row_major float4x4 g_local_light_shadow_matrix[3] : packoffset(c4);
  row_major float4x4 g_local_light_data[1000] : packoffset(c16);
}

SamplerState diffuse_sampler_s : register(s0);
SamplerState normal_sampler_s : register(s1);
SamplerState specular_sampler_s : register(s2);
SamplerState gi_texture_sampler_s : register(s3);
SamplerState s_EnvBRDF_sampler_s : register(s4);
SamplerState s_IBL_sampler_s : register(s5);
SamplerState s_ShadowMap_sampler_s : register(s6);
SamplerState s_Luminance_sampler_s : register(s7);
SamplerState s_IBLProbeArray_sampler_s : register(s8);
SamplerState s_VolShadow_sampler_s : register(s10);
SamplerComparisonState s_LocalShadowMap_sampler_s : register(s9);
Texture2D<float4> diffuse_NedSmpignorenametexture : register(t0);
Texture2D<float4> normal_NedSmpignorenametexture : register(t1);
Texture2D<float4> specular_NedSmpignorenametexture : register(t2);
Texture2DArray<float4> gi_texture : register(t3);
Texture2D<float4> s_EnvBRDF_NedSmpignorenametexture : register(t4);
TextureCube<float4> s_IBL_NedSmpignorenametexture : register(t5);
Texture2DArray<float4> s_ShadowMap : register(t6);
Texture2D<float4> s_Luminance_NedSmpignorenametexture : register(t7);
Texture2D<float4> s_DebugFont : register(t8);
StructuredBuffer<uint> s_LocalLightIndexData : register(t9);
TextureCubeArray<float4> s_IBLProbeArray : register(t10);
TextureCubeArray<float4> s_LocalShadowMap : register(t11);
Texture3D<float4> s_VolShadow : register(t12);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD4,
  float2 v7 : TEXCOORD11,
  float w7 : TEXCOORD6,
  float4 v8 : TEXCOORD5,
  float4 v9 : TEXCOORD7,
  float3 v10 : TEXCOORD9,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0, 1.000000, 0},
                              { 0, 0, 0, 1.000000},
                              { 1.000000, 1.000000, 0, 0},
                              { 1.000000, -1.000000, 0, 0},
                              { -1.000000, 1.000000, 0, 0},
                              { -1.000000, -1.000000, 0, 0},
                              { 1.500000, 0.300000, 0.300000, 1.000000},
                              { 0.300000, 1.500000, 0.300000, 1.000000},
                              { 0.300000, 0.300000, 5.500000, 1.000000},
                              { 1.500000, 0.300000, 5.500000, 1.000000} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22,r23,r24,r25,r26;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 x0[2];
  float4 x1[5];
  float4 x2[5];
  float4 x3[5];
  r0.xyzw = TexcoordMtx_diffuse[0].xyzw * v2.xxyy;
  r0.xy = r0.xy + r0.zw;
  r0.xy = TexcoordMtx_diffuse[1].xy + r0.xy;
  r0.xyzw = diffuse_NedSmpignorenametexture.SampleBias(diffuse_sampler_s, r0.xy, global_mip_bias.x).xyzw;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.x = dot(v4.xyz, v4.xyz);
  r1.x = rsqrt(r1.x);
  r1.xyz = v4.xyz * r1.xxx;
  r1.w = dot(v5.xyz, v5.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = v5.xyz * r1.www;
  r3.xyz = r2.yzx * r1.zxy;
  r3.xyz = r1.yzx * r2.zxy + -r3.xyz;
  r3.xyz = v7.xxx * r3.xyz;
  r1.w = dot(r3.xyz, r3.xyz);
  r1.w = rsqrt(r1.w);
  r3.xyz = r3.xyz * r1.www;
  r4.xyzw = TexcoordMtx_normal[0].xyzw * v3.xxyy;
  r4.xy = r4.xy + r4.zw;
  r4.xy = TexcoordMtx_normal[1].xy + r4.xy;
  r4.xy = normal_NedSmpignorenametexture.SampleBias(normal_sampler_s, r4.xy, global_mip_bias.x).xy;
  r4.xy = r4.xy * float2(2,2) + float2(-1,-1);
  r1.w = dot(r4.xy, r4.xy);
  r1.w = min(1, r1.w);
  r1.w = 1 + -r1.w;
  r1.w = sqrt(r1.w);
  r3.xyz = r4.yyy * r3.xyz;
  r2.xyz = r4.xxx * r2.xyz + r3.xyz;
  r2.xyz = r1.www * r1.xyz + r2.xyz;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r2.xyz * r1.www;
  r3.xyz = cmp(r2.xyz != r2.xyz);
  r1.w = (int)r3.y | (int)r3.x;
  r1.w = (int)r3.z | (int)r1.w;
  r2.xyz = r1.www ? r1.xyz : r2.xyz;
  r3.xyzw = TexcoordMtx_specular[0].xyzw * v2.xxyy;
  r3.xy = r3.xy + r3.zw;
  r3.xy = TexcoordMtx_specular[1].xy + r3.xy;
  r3.xyzw = specular_NedSmpignorenametexture.SampleBias(specular_sampler_s, r3.xy, global_mip_bias.x).wxyz;
  r1.w = 1 + -r3.z;
  r4.y = max(0.00999999978, r1.w);
  r1.w = 0.25 * r3.y;
  r5.xyz = -r3.yyy * float3(0.25,0.25,0.25) + r0.xyz;
  r3.yzw = r3.www * r5.xyz + r1.www;
  r5.xy = u_screen_info.zw * v0.xy;
  r5.xy = u_screen_info.xy * r5.xy;
  r5.xy = (uint2)r5.xy;
  r5.zw = (uint2)r5.xy >> int2(4,4);
  r6.x = v4.w;
  r6.y = v5.w;
  r6.z = v6.w;
  r7.xyz = u_cameraPosition.xyz + -r6.xyz;
  r1.w = dot(r7.xyz, r7.xyz);
  r1.w = rsqrt(r1.w);
  r8.xyz = r7.xyz * r1.www;
  r4.w = dot(r2.xyz, r8.xyz);
  r7.w = 1 + FalloffFactor.z;
  r4.w = saturate(r7.w + -r4.w);
  r4.w = log2(r4.w);
  r4.w = FalloffFactor.y * r4.w;
  r4.w = exp2(r4.w);
  r7.w = FalloffFactor.x * r4.w;
  r9.xyz = float3(1,1,1) + -r3.yzw;
  r3.yzw = r7.www * r9.xyz + r3.yzw;
  r8.w = cmp(r3.z >= 0.899999976);
  r9.xyz = r8.www ? float3(1,1,1) : 0;
  r10.xyz = -r3.yzw + r0.xyz;
  r3.yzw = r9.zzz * r10.xyz + r3.yzw;
  r10.xy = round(g_debug_option.xy);
  r10.xy = (int2)r10.xy;
  switch (r10.x) {
    case 6 :    r2.xyz = r1.xyz;
    break;
    case 8 :    r0.xyz = float3(1,1,1);
    break;
    case 9 :    r0.xyz = float3(1,1,1);
    r3.x = 1;
    break;
    default :
    break;
  }
  if (enable_shadow_map != 0) {
    r11.xyzw = cmp(shadow_cascade_frustums_eye_space_depth.xyzw < w7);
    r11.xyzw = r11.xyzw ? float4(1,1,1,1) : 0;
    r1.x = dot(float4(1,1,1,1), r11.xyzw);
    r1.y = (int)shadow_map_parameter[0].y;
    r1.z = cmp(0 < (int)r1.y);
    r1.z = r1.z ? 0 : 4;
    r11.z = r1.x + r1.z;
    r1.x = (int)r11.z;
    r1.z = cmp((int)r1.x >= (int)r1.y);
    if (r1.z != 0) {
      r1.z = shadow_map_parameter[1].y;
    } else {
      r9.w = (int)r1.x + 1;
      r1.y = (int)r1.y + -1;
      r9.w = min((int)r9.w, (int)r1.y);
      r10.z = cmp(shadow_map_parameter[1].z == 0.000000);
      if (r10.z != 0) {
        r10.z = 0;
      } else {
        r10.w = dot(shadow_cascade_frustums_eye_space_depth.xyzw, icb[r1.x+0].xyzw);
        r10.w = -w7 + r10.w;
        r10.w = saturate(shadow_map_parameter[1].z * r10.w);
        r10.z = 1 + -r10.w;
      }
      x0[0].x = 1;
      x0[1].x = 1;
      r10.w = cmp(0 < shadow_parallax_correct_param[0].w);
      if (r10.w != 0) {
        r12.xyz = v8.xyz;
        r13.xy = float2(0,0);
        r12.w = 0;
        while (true) {
          r13.z = cmp((int)r12.w >= 16);
          if (r13.z != 0) break;
          r11.xyw = r12.xyz * shadow_cascade_scale[r1.x].xyz + shadow_cascade_offset[r1.x].xyz;
          r13.z = s_ShadowMap.SampleLevel(s_ShadowMap_sampler_s, r11.xyz, 0).x;
          r13.w = cmp(r11.w < r13.z);
          r11.w = -r13.z + r11.w;
          r14.x = r13.x + abs(r11.w);
          r14.y = 1 + r13.y;
          r13.xy = r13.ww ? r14.xy : r13.xy;
          r12.xyz = shadow_parallax_correct_param[r1.x].xyz + r12.xyz;
          r12.w = (int)r12.w + 1;
        }
        r11.w = cmp(0 < r13.y);
        r12.x = rcp(r13.y);
        r12.x = r13.x * r12.x;
        r11.w = r11.w ? r12.x : 0;
        r12.xyz = r11.www * shadow_parallax_correct_param[r1.x].xyz + v8.xyz;
        r12.xyz = r12.xyz * shadow_cascade_scale[r1.x].xyz + shadow_cascade_offset[r1.x].xyz;
      } else {
        r12.xyz = v8.xyz * shadow_cascade_scale[r1.x].xyz + shadow_cascade_offset[r1.x].xyz;
      }
      r13.xy = cmp(r12.xy >= float2(0,0));
      r13.zw = cmp(r12.xy < float2(1,1));
      r11.w = r13.z ? r13.x : 0;
      r11.w = r13.y ? r11.w : 0;
      r11.w = r13.w ? r11.w : 0;
      r12.w = cmp(r12.z >= 0);
      r11.w = r11.w ? r12.w : 0;
      r12.w = cmp(r12.z < 1);
      r11.w = r11.w ? r12.w : 0;
      if (r11.w != 0) {
        r11.w = dot(shadow_cascade_transition_scale.xyzw, icb[r1.x+0].xyzw);
        r12.xy = r12.xy * shadow_map_size.xy + float2(-0.5,-0.5);
        r13.xy = frac(r12.xy);
        r12.xy = floor(r12.xy);
        r12.xy = float2(0.5,0.5) + r12.xy;
        r11.xy = shadow_map_size.zw * r12.xy;
        r14.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r11.xyz, int2(-1, -1)).xyzw;
        r14.xyzw = r14.xyzw + -r12.zzzz;
        r14.xyzw = saturate(r14.xyzw * r11.wwww + shadow_map_parameter[0].xxxx);
        r15.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r11.xyz, int2(1, -1)).xyzw;
        r15.xyzw = r15.xyzw + -r12.zzzz;
        r15.xyzw = saturate(r15.xyzw * r11.wwww + shadow_map_parameter[0].xxxx);
        r16.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r11.xyz, int2(-1, 1)).xyzw;
        r16.xyzw = r16.xyzw + -r12.zzzz;
        r16.xyzw = saturate(r16.xyzw * r11.wwww + shadow_map_parameter[0].xxxx);
        r17.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r11.xyz, int2(1, 1)).xyzw;
        r12.xyzw = r17.xyzw + -r12.zzzz;
        r11.xyzw = saturate(r12.xyzw * r11.wwww + shadow_map_parameter[0].xxxx);
        r12.x = 1 + -r13.x;
        r12.yz = r14.wx * r12.xx + r14.zy;
        r12.xw = r16.wx * r12.xx + r16.zy;
        r12.yz = r12.yz + r15.wx;
        r11.xw = r12.xw + r11.wx;
        r12.xy = r15.zy * r13.xx + r12.yz;
        r12.zw = r11.zy * r13.xx + r11.xw;
        r13.z = 1 + -r13.y;
        r13.w = 1;
        r11.x = dot(r12.wxzy, r13.yzww);
        r11.x = 0.111111112 * r11.x;
        r11.x = min(1, r11.x);
        x0[0].x = r11.x;
      }
      r11.x = cmp(0 >= r10.z);
      r11.y = cmp(0.999998987 < r10.z);
      r11.x = (int)r11.y | (int)r11.x;
      r1.x = cmp((int)r1.x == (int)r9.w);
      r1.x = (int)r1.x | (int)r11.x;
      if (r1.x == 0) {
        if (r10.w != 0) {
          r11.w = (int)r9.w;
          r12.xyz = v8.xyz;
          r13.xy = float2(0,0);
          r1.x = 0;
          while (true) {
            r10.w = cmp((int)r1.x >= 16);
            if (r10.w != 0) break;
            r11.xyz = r12.xyz * shadow_cascade_scale[r9.w].xyz + shadow_cascade_offset[r9.w].xyz;
            r10.w = s_ShadowMap.SampleLevel(s_ShadowMap_sampler_s, r11.xyw, 0).x;
            r11.x = cmp(r11.z < r10.w);
            r10.w = r11.z + -r10.w;
            r14.x = r13.x + abs(r10.w);
            r14.y = 1 + r13.y;
            r13.xy = r11.xx ? r14.xy : r13.xy;
            r12.xyz = shadow_parallax_correct_param[r9.w].xyz + r12.xyz;
            r1.x = (int)r1.x + 1;
          }
          r1.x = cmp(0 < r13.y);
          r10.w = rcp(r13.y);
          r10.w = r13.x * r10.w;
          r1.x = r1.x ? r10.w : 0;
          r11.xyz = r1.xxx * shadow_parallax_correct_param[r9.w].xyz + v8.xyz;
          r11.xyz = r11.xyz * shadow_cascade_scale[r9.w].xyz + shadow_cascade_offset[r9.w].xyz;
        } else {
          r11.xyz = v8.xyz * shadow_cascade_scale[r9.w].xyz + shadow_cascade_offset[r9.w].xyz;
        }
        r12.xy = cmp(r11.xy >= float2(0,0));
        r12.zw = cmp(r11.xy < float2(1,1));
        r1.x = r12.z ? r12.x : 0;
        r1.x = r12.y ? r1.x : 0;
        r1.x = r12.w ? r1.x : 0;
        r10.w = cmp(r11.z >= 0);
        r1.x = r1.x ? r10.w : 0;
        r10.w = cmp(r11.z < 1);
        r1.x = r1.x ? r10.w : 0;
        if (r1.x != 0) {
          r12.z = (int)r9.w;
          r1.x = dot(shadow_cascade_transition_scale.xyzw, icb[r9.w+0].xyzw);
          r11.xy = r11.xy * shadow_map_size.xy + float2(-0.5,-0.5);
          r13.xy = frac(r11.xy);
          r11.xy = floor(r11.xy);
          r11.xy = float2(0.5,0.5) + r11.xy;
          r12.xy = shadow_map_size.zw * r11.xy;
          r14.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r12.xyz, int2(-1, -1)).xyzw;
          r14.xyzw = r14.xyzw + -r11.zzzz;
          r14.xyzw = saturate(r14.xyzw * r1.xxxx + shadow_map_parameter[0].xxxx);
          r15.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r12.xyz, int2(1, -1)).xyzw;
          r15.xyzw = r15.xyzw + -r11.zzzz;
          r15.xyzw = saturate(r15.xyzw * r1.xxxx + shadow_map_parameter[0].xxxx);
          r16.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r12.xyz, int2(-1, 1)).xyzw;
          r16.xyzw = r16.xyzw + -r11.zzzz;
          r16.xyzw = saturate(r16.xyzw * r1.xxxx + shadow_map_parameter[0].xxxx);
          r12.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r12.xyz, int2(1, 1)).xyzw;
          r11.xyzw = r12.xyzw + -r11.zzzz;
          r11.xyzw = saturate(r11.xyzw * r1.xxxx + shadow_map_parameter[0].xxxx);
          r1.x = 1 + -r13.x;
          r12.xy = r14.wx * r1.xx + r14.zy;
          r12.zw = r16.wx * r1.xx + r16.zy;
          r12.xy = r12.xy + r15.wx;
          r11.xw = r12.zw + r11.wx;
          r12.xy = r15.zy * r13.xx + r12.xy;
          r12.zw = r11.zy * r13.xx + r11.xw;
          r13.z = 1 + -r13.y;
          r13.w = 1;
          r1.x = dot(r12.wxzy, r13.yzww);
          r1.x = 0.111111112 * r1.x;
          r1.x = min(1, r1.x);
          x0[1].x = r1.x;
        }
      }
      r1.x = dot(shadow_cascade_frustums_eye_space_depth.xyzw, icb[r1.y+0].xyzw);
      r1.x = -w7 + r1.x;
      r1.x = saturate(shadow_map_parameter[1].x * r1.x);
      r1.y = x0[0].x;
      r9.w = x0[1].x;
      r9.w = r9.w + -r1.y;
      r1.y = r10.z * r9.w + r1.y;
      r1.y = -shadow_map_parameter[1].y + r1.y;
      r1.x = r1.x * r1.y + shadow_map_parameter[1].y;
      r1.y = shadow_map_parameter[1].y + -r1.x;
      r1.z = shadow_map_parameter[1].w * r1.y + r1.x;
    }
  } else {
    r1.z = 1;
  }
  if (enable_ibl_plus_directional_specular != 0) {
    r11.xyz = -u_cameraPosition.xyz + r6.xyz;
    r1.x = dot(r11.xyz, r11.xyz);
    r1.x = sqrt(r1.x);
    r11.xyzw = cmp(u_vol_shadow_param[4].xyzw < r1.xxxx);
    r11.xyzw = r11.xyzw ? float4(1,1,1,1) : 0;
    r1.y = dot(float4(1,1,1,1), r11.xyzw);
    r9.w = (int)r1.y;
    r10.z = cmp((int)r9.w < 4);
    if (r10.z != 0) {
      r11.xyz = -u_vol_shadow_param[r9.w].xyz + r6.xyz;
      r12.xyz = u_vol_shadow_param[r9.w].www * r11.xyz;
      r12.xyz = cmp(abs(r12.xyz) < float3(0.479999989,0.479999989,0.479999989));
      r10.z = r12.y ? r12.x : 0;
      r10.z = r12.z ? r10.z : 0;
      if (r10.z != 0) {
        r11.xyz = r11.xyz * u_vol_shadow_param[r9.w].www + float3(0.5,0.5,0.5);
        r1.y = 0.25 * r1.y;
        r11.w = r11.z * 0.25 + r1.y;
        r1.y = s_VolShadow.SampleLevel(s_VolShadow_sampler_s, r11.xyw, 0).x;
      } else {
        r1.y = 1;
      }
    } else {
      r1.y = 1;
    }
    r10.z = (int)r9.w + 1;
    r10.w = cmp((int)r10.z < 4);
    if (r10.w != 0) {
      r11.xyz = -u_vol_shadow_param[r9.w+1].xyz + r6.xyz;
      r12.xyz = u_vol_shadow_param[r9.w+1].www * r11.xyz;
      r12.xyz = cmp(abs(r12.xyz) < float3(0.479999989,0.479999989,0.479999989));
      r10.w = r12.y ? r12.x : 0;
      r10.w = r12.z ? r10.w : 0;
      if (r10.w != 0) {
        r11.xyz = r11.xyz * u_vol_shadow_param[r9.w+1].www + float3(0.5,0.5,0.5);
        r10.w = (int)r10.z;
        r10.w = 0.25 * r10.w;
        r11.w = r11.z * 0.25 + r10.w;
        r10.w = s_VolShadow.SampleLevel(s_VolShadow_sampler_s, r11.xyw, 0).x;
        r9.w = dot(u_vol_shadow_param[4].xyzw, icb[r9.w+0].xyzw);
        r11.x = 0.5 * r9.w;
        r9.w = -r9.w * 0.5 + r1.x;
        r11.x = 1 / r11.x;
        r9.w = saturate(r11.x * r9.w);
        r11.x = r9.w * -2 + 3;
        r9.w = r9.w * r9.w;
        r9.w = r11.x * r9.w;
        r10.w = r10.w + -r1.y;
        r1.y = r9.w * r10.w + r1.y;
      }
    }
    r9.w = cmp((int)r10.z >= 4);
    r10.z = u_vol_shadow_param[4].w * 0.199999988;
    r1.x = -u_vol_shadow_param[4].w * 0.800000012 + r1.x;
    r10.z = 1 / r10.z;
    r1.x = saturate(r10.z * r1.x);
    r10.z = r1.x * -2 + 3;
    r1.x = r1.x * r1.x;
    r1.x = r10.z * r1.x;
    r10.z = 1 + -r1.y;
    r1.x = r1.x * r10.z + r1.y;
    r1.x = r9.w ? r1.x : r1.y;
    r1.z = min(r1.z, r1.x);
  }
  r1.x = saturate(dot(r2.xyz, u_lightDirection.xyz));
  r7.xyz = r7.xyz * r1.www + u_lightDirection.xyz;
  r1.y = dot(r7.xyz, r7.xyz);
  r1.y = rsqrt(r1.y);
  r7.xyz = r7.xyz * r1.yyy;
  r1.y = saturate(dot(r3.yzw, float3(16.5,16.5,16.5)));
  r1.w = saturate(dot(r7.xyz, u_lightDirection.xyz));
  r11.xyz = r1.yyy + -r3.yzw;
  r1.y = 1 + -r1.w;
  r1.w = r1.y * r1.y;
  r1.w = r1.w * r1.w;
  r1.y = r1.y * r1.w;
  r12.xyz = r11.xyz * r1.yyy + r3.yzw;
  r13.xyz = u_lightColor.xyz * r1.xxx;
  r1.y = 1 + -r12.x;
  r1.w = r8.w ? 0 : 1;
  r1.y = r1.y * r1.w;
  r13.xyz = r13.xyz * r1.yyy;
  r4.x = saturate(dot(r2.xyz, r8.xyz));
  r1.y = saturate(dot(r2.xyz, r7.xyz));
  r7.x = -r1.y * r1.y + 1;
  r1.y = r1.y * r4.y;
  r1.y = r1.y * r1.y + r7.x;
  r1.y = r4.y / r1.y;
  r1.y = r1.y * r1.y;
  r1.y = 0.318309873 * r1.y;
  r7.x = 1 + r4.y;
  r7.x = r7.x * r7.x;
  r7.y = 0.125 * r7.x;
  r7.x = -r7.x * 0.125 + 1;
  r7.z = r1.x * r7.x + r7.y;
  r8.w = r4.x * r7.x + r7.y;
  r7.z = r8.w * r7.z;
  r7.z = 0.25 / r7.z;
  r1.y = r7.z * r1.y;
  r12.xyz = saturate(r1.yyy * r12.xyz);
  r12.xyz = r12.xyz * r1.xxx;
  r12.xyz = u_lightColor.xyz * r12.xyz;
  r10.yzw = cmp((int3)r10.yyy == int3(1,3,2));
  r1.x = -u_sggi_param[0].x + r4.y;
  r1.x = saturate(u_sggi_param[0].y * r1.x);
  r1.y = r10.z ? r1.x : 0;
  r1.y = r10.y ? 1 : r1.y;
  r14.xyz = r12.xyz * r1.yyy;
  r12.xyz = enable_ibl_plus_directional_specular ? r12.xyz : r14.xyz;
  r1.y = (uint)g_local_light_count.x;
  if (r1.y != 0) {
    r14.xy = (int2)u_tile_info.zw;
    r14.xy = (int2)r14.xy + int2(15,15);
    r14.xy = (uint2)r14.xy >> int2(4,4);
    r14.xy = cmp((int2)r5.zw < (int2)r14.xy);
    r1.y = r14.y ? r14.x : 0;
    r14.xy = (uint2)u_tile_info.xy;
    r7.z = mad((int)r5.w, (int)r14.x, (int)r5.z);
    r7.z = (int)r7.z * 3;
    r9.w = s_LocalLightIndexData[r7.z].x;
    r9.w = (uint)r9.w >> 16;
    r15.x = min(64, (uint)r9.w);
    r7.z = (uint)r7.z << 6;
    r15.y = (int)r7.z + (int)r14.y;
    r15.z = 16;
    r14.xyz = (int3)r1.yyy & (int3)r15.xyz;
    if (2 == 0) r1.y = 0; else if (2+4 < 32) {     r1.y = (uint)u_shading_model_flag.x << (32-(2 + 4)); r1.y = (uint)r1.y >> (32-2);    } else r1.y = (uint)u_shading_model_flag.x >> 4;
    r1.y = 1 << (int)r1.y;
    r15.x = 1;
    r16.xyz = float3(0,0,0);
    r17.xyz = float3(0,0,0);
    r7.z = 0;
    while (true) {
      r9.w = cmp((uint)r7.z >= (uint)r14.x);
      if (r9.w != 0) break;
      r9.w = (int)r7.z + (int)r14.y;
      r9.w = s_LocalLightIndexData[r9.w].x;
      r9.w = (uint)r9.w >> (uint)r14.z;
      bitmask.w = ((~(-1 << 16)) << 2) & 0xffffffff;  r9.w = (((uint)r9.w << 2) & bitmask.w) | ((uint)0 & ~bitmask.w);
      r11.w = (int)r1.y & (int4)g_local_light_data[r9.w/4]._m33;
      if (3 == 0) r12.w = 0; else if (3+16 < 32) {       r12.w = (uint)g_local_light_data[r9.w/4]._m33 << (32-(3 + 16)); r12.w = (uint)r12.w >> (32-3);      } else r12.w = (uint)g_local_light_data[r9.w/4]._m33 >> 16;
      r12.w = (int)r12.w + -1;
      r13.w = cmp((int)r12.w >= 0);
      r14.w = cmp(0.00999999978 < abs(g_local_light_shadow_param[r12.w].w));
      r13.w = r13.w ? r14.w : 0;
      if (r13.w == 0) {
        r13.w = 1;
      } else {
        r14.w = cmp(g_local_light_shadow_param[r12.w].w < 0);
        r18.xyz = -g_local_light_shadow_param[r12.w].xyz + r6.xyz;
        r15.w = dot(r18.xyz, r18.xyz);
        r15.w = sqrt(r15.w);
        if (r14.w != 0) {
          r14.w = (uint)r12.w << 2;
          r19.xyzw = g_local_light_shadow_matrix[r14.w/4]._m10_m11_m12_m13 * v5.wwww;
          r19.xyzw = v4.wwww * g_local_light_shadow_matrix[r14.w/4]._m00_m01_m02_m03 + r19.xyzw;
          r19.xyzw = v6.wwww * g_local_light_shadow_matrix[r14.w/4]._m20_m21_m22_m23 + r19.xyzw;
          r19.xyzw = g_local_light_shadow_matrix[r14.w/4]._m30_m31_m32_m33 + r19.xyzw;
          r19.xyz = r19.zxy / r19.www;
          r15.yz = float2(1,-1) * r19.zy;
          r14.w = dot(r15.xyz, r15.xyz);
          r14.w = rsqrt(r14.w);
          r19.yzw = r15.xyz * r14.www;
          r18.xyz = r19.yzw * r15.www;
          r15.yz = r18.yz;
        } else {
          r14.w = (uint)r12.w << 2;
          r16.w = max(abs(r18.y), abs(r18.z));
          r16.w = max(abs(r18.x), r16.w);
          r19.yz = g_local_light_shadow_matrix[r14.w/4]._m22_m23 * -r16.ww + g_local_light_shadow_matrix[r14.w/4]._m32_m33;
          r19.x = r19.y / r19.z;
          r15.yz = r18.yz;
        }
        r20.w = (int)r12.w;
        r14.w = -0.00100000005 + r19.x;
        r16.w = 0;
        r17.w = 0;
        while (true) {
          r18.z = cmp((int)r17.w >= 5);
          if (r18.z != 0) break;
          r18.zw = icb[r17.w+3].xy * float2(0.00200000009,0.00200000009);
          sincos(r18.z, r19.x, r21.x);
          sincos(r18.w, r22.x, r23.x);
          r24.xz = sin(-r18.zw);
          r24.y = r21.x;
          r20.y = dot(r24.yx, r15.yz);
          r24.w = r19.x;
          r18.y = dot(r24.wy, r15.yz);
          r24.x = r23.x;
          r24.y = r22.x;
          r20.x = dot(r24.xy, r18.xy);
          r20.z = dot(r24.zx, r18.xy);
          r18.y = s_LocalShadowMap.SampleCmpLevelZero(s_LocalShadowMap_sampler_s, r20.xyzw, r14.w).x;
          r16.w = r18.y + r16.w;
          r17.w = (int)r17.w + 1;
        }
        r14.w = -1 + r15.w;
        r14.w = saturate(-2.50000024 * r14.w);
        r15.y = r14.w * -2 + 3;
        r14.w = r14.w * r14.w;
        r14.w = r15.y * r14.w;
        r14.w = r16.w * 0.200000003 + r14.w;
        r14.w = min(1, r14.w);
        r14.w = -1 + r14.w;
        r13.w = abs(g_local_light_shadow_param[r12.w].w) * r14.w + 1;
      }
      if (r11.w != 0) {
        r15.yzw = g_local_light_data[r9.w/4]._m10_m11_m12 + -r6.xyz;
        r11.w = dot(r15.yzw, r15.yzw);
        r12.w = cmp(g_local_light_data[r9.w/4]._m13 < r11.w);
        r14.w = g_local_light_data[r9.w/4]._m00 + g_local_light_data[r9.w/4]._m01;
        r14.w = g_local_light_data[r9.w/4]._m02 + r14.w;
        r14.w = cmp(abs(r14.w) < 9.99999997e-007);
        r12.w = (int)r12.w | (int)r14.w;
        if (r12.w == 0) {
          r12.w = 256 & (int4)g_local_light_data[r9.w/4]._m33;
          r14.w = rsqrt(r11.w);
          r18.xyz = r15.yzw * r14.www;
          r17.w = dot(g_local_light_data[r9.w/4]._m20_m21_m22, -r18.xyz);
          r17.w = -g_local_light_data[r9.w/4]._m30 + r17.w;
          r17.w = saturate(g_local_light_data[r9.w/4]._m31 * r17.w);
          r17.w = r17.w * r17.w;
          r18.w = cmp(r17.w >= 9.99999997e-007);
          r18.w = r12.w ? r18.w : -1;
          if (r18.w != 0) {
            r19.xy = int2(16,32) & (int)g_local_light_data[r9.w/4]._m33;
            r18.w = r11.w / g_local_light_data[r9.w/4]._m13;
            r18.w = -r18.w * r18.w + 1;
            r18.w = max(0, r18.w);
            r18.w = r18.w * r18.w;
            r20.xyz = g_local_light_data[r9.w/4]._m00_m01_m02 * float3(0.0795774683,0.0795774683,0.0795774683);
            r9.w = r12.w ? r17.w : 1;
            r11.w = max(1, r11.w);
            r11.w = rcp(r11.w);
            r12.w = saturate(dot(r2.xyz, r18.xyz));
            r15.yzw = r15.yzw * r14.www + r8.xyz;
            r14.w = dot(r15.yzw, r15.yzw);
            r14.w = rsqrt(r14.w);
            r15.yzw = r15.yzw * r14.www;
            r14.w = saturate(dot(r15.yzw, r18.xyz));
            r14.w = 1 + -r14.w;
            r17.w = r14.w * r14.w;
            r17.w = r17.w * r17.w;
            r14.w = r17.w * r14.w;
            r18.xyz = r11.xyz * r14.www + r3.yzw;
            r11.w = r11.w * r18.w;
            r9.w = r11.w * r9.w;
            if (r19.y != 0) {
              r11.w = r13.w * r9.w;
              r14.w = saturate(dot(r2.xyz, r15.yzw));
              r15.y = -r14.w * r14.w + 1;
              r14.w = r14.w * r4.y;
              r14.w = r14.w * r14.w + r15.y;
              r14.w = r4.y / r14.w;
              r14.w = r14.w * r14.w;
              r14.w = 0.318309873 * r14.w;
              r15.y = r12.w * r7.x + r7.y;
              r15.y = r15.y * r8.w;
              r15.y = 0.25 / r15.y;
              r14.w = r15.y * r14.w;
              r15.yzw = saturate(r14.www * r18.xyz);
              r15.yzw = r15.yzw * r12.www;
              r15.yzw = r15.yzw * r20.xyz;
              r17.xyz = r11.www * r15.yzw + r17.xyz;
            }
            if (r19.x != 0) {
              r9.w = r13.w * r9.w;
              r15.yzw = r12.www * r20.xyz;
              r11.w = 1 + -r18.x;
              r11.w = r11.w * r1.w;
              r15.yzw = r15.yzw * r11.www;
              r16.xyz = r9.www * r15.yzw + r16.xyz;
            }
          }
        }
      }
      r7.z = (int)r7.z + 1;
    }
  } else {
    r16.xyz = float3(0,0,0);
    r17.xyz = float3(0,0,0);
  }
  r7.xyz = r2.yzx * r2.yzy;
  r11.xyz = float3(-1.02381635,-1.02381635,-1.02381635) * r2.yzx;
  r14.xy = -r2.zz * r2.yx;
  r1.y = 0.858085036 * r7.z;
  r7.y = r7.y * 3 + -1;
  r14.xy = float2(-0.858085036,-0.858085036) * r14.xy;
  r7.x = r2.x * r2.x + -r7.x;
  r7.xy = float2(0.429042518,0.247708231) * r7.xy;
  r14.zw = (int2)u_tile_info.zw;
  r14.zw = (int2)r14.zw + int2(15,15);
  r14.zw = (uint2)r14.zw >> int2(4,4);
  r14.zw = cmp((int2)r5.zw < (int2)r14.zw);
  r7.z = r14.w ? r14.z : 0;
  r14.zw = (uint2)u_tile_info.xy;
  r5.z = mad((int)r5.w, (int)r14.z, (int)r5.z);
  r5.w = (int)r5.z * 3;
  r8.w = mad((int)r5.z, 3, 2);
  r9.w = s_LocalLightIndexData[r8.w].x;
  r11.w = (uint)r9.w >> 16;
  r15.x = min(64, (uint)r11.w);
  r8.w = (uint)r8.w << 6;
  r15.y = (int)r8.w + (int)r14.w;
  r15.z = 16;
  r15.yzw = (int3)r7.zzz & (int3)r15.xyz;
  r6.w = 1;
  r18.xyz = float3(0,0,0);
  r8.w = 1;
  r11.w = 0;
  while (true) {
    r12.w = cmp((uint)r11.w >= (uint)r15.y);
    if (r12.w != 0) break;
    r12.w = (int)r11.w + (int)r15.z;
    r12.w = s_LocalLightIndexData[r12.w].x;
    r12.w = (uint)r12.w >> (uint)r15.w;
    r12.w = (int)r12.w & 0x0000ffff;
    r13.w = (uint)g_probe_param[r12.w].x >> 1;
    r14.zw = cmp((int2)r13.ww == int2(3,2));
    r13.w = (int)r14.w | (int)r14.z;
    if (r13.w != 0) {
      r19.xyz = -g_probe_pos[r12.w].xyz + r6.xyz;
      r13.w = dot(r19.xyz, r19.xyz);
      r13.w = sqrt(r13.w);
      r13.w = r13.w / g_probe_param[r12.w].z;
    } else {
      r14.z = (int)r12.w * 3;
      r14.w = dot(g_probe_data[r14.z].xyzw, r6.xyzw);
      r16.w = dot(g_probe_data[r14.z+1].xyzw, r6.xyzw);
      r14.z = dot(g_probe_data[r14.z+2].xyzw, r6.xyzw);
      r14.w = max(abs(r16.w), abs(r14.w));
      r13.w = max(r14.w, abs(r14.z));
    }
    r14.z = cmp(r13.w < 0.99000001);
    r14.w = max(g_probe_param[r12.w].y, 0.00999999978);
    r14.w = min(0.99000001, r14.w);
    r14.w = 1 + -r14.w;
    r14.w = 1 / r14.w;
    r13.w = -g_probe_param[r12.w].y + r13.w;
    r13.w = saturate(-r14.w * r13.w + 1);
    r13.w = r14.z ? r13.w : 0;
    r14.z = cmp(0 < r13.w);
    if (r14.z != 0) {
      r12.w = (int)r12.w * 7;
      r19.x = g_probe_shparam[r12.w].w * r11.x;
      r19.yz = g_probe_shparam[r12.w+1].xy * r11.xx;
      r19.xyz = g_probe_shparam[r12.w].xyz * float3(0.886227667,0.886227667,0.886227667) + r19.xyz;
      r20.xy = g_probe_shparam[r12.w+1].zw * r11.yy;
      r20.z = g_probe_shparam[r12.w+2].x * r11.y;
      r19.xyz = r20.xyz + r19.xyz;
      r19.xyz = r11.zzz * g_probe_shparam[r12.w+2].yzw + r19.xyz;
      r19.xyz = r1.yyy * g_probe_shparam[r12.w+3].xyz + r19.xyz;
      r20.x = g_probe_shparam[r12.w+3].w * r14.x;
      r20.yz = g_probe_shparam[r12.w+4].xy * r14.xx;
      r19.xyz = r20.xyz + r19.xyz;
      r20.xy = g_probe_shparam[r12.w+4].zw * r7.yy;
      r20.z = g_probe_shparam[r12.w+5].x * r7.y;
      r19.xyz = r20.xyz + r19.xyz;
      r19.xyz = r14.yyy * g_probe_shparam[r12.w+5].yzw + r19.xyz;
      r19.xyz = r7.xxx * g_probe_shparam[r12.w+6].xyz + r19.xyz;
      r19.xyz = float3(0.318309873,0.318309873,0.318309873) * r19.xyz;
      r12.w = min(r13.w, r8.w);
      r19.xyz = r19.xyz * r12.www + r18.xyz;
      r8.w = -r12.w + r8.w;
      r12.w = cmp(0 >= r8.w);
      if (r12.w != 0) {
        r18.xyz = r19.xyz;
        break;
      }
      r18.xyz = r19.xyz;
    }
    r11.w = (int)r11.w + 1;
  }
  r19.xyz = u_sky_sh_param[1].xyz * r11.xxx;
  r19.xyz = u_sky_sh_param[0].xyz * float3(0.886227667,0.886227667,0.886227667) + r19.xyz;
  r11.xyw = r11.yyy * u_sky_sh_param[2].xyz + r19.xyz;
  r11.xyz = r11.zzz * u_sky_sh_param[3].xyz + r11.xyw;
  r11.xyz = r1.yyy * u_sky_sh_param[4].xyz + r11.xyz;
  r11.xyz = r14.xxx * u_sky_sh_param[5].xyz + r11.xyz;
  r11.xyz = r7.yyy * u_sky_sh_param[6].xyz + r11.xyz;
  r11.xyz = r14.yyy * u_sky_sh_param[7].xyz + r11.xyz;
  r11.xyz = r7.xxx * u_sky_sh_param[8].xyz + r11.xyz;
  r11.xyz = float3(0.318309873,0.318309873,0.318309873) * r11.xyz;
  r14.xy = v2.zw;
  r14.z = 0;
  r1.y = gi_texture.SampleLevel(gi_texture_sampler_s, r14.xyz, 0).x;
  r1.y = saturate(r1.y);
  r11.xyz = r11.xyz * r1.yyy;
  r1.y = r1.y * -u_sggi_param[1].w + u_sggi_param[1].w;
  r11.xyz = r18.xyz * r1.yyy + r11.xyz;
  r14.xyz = float3(1,1,1) + -r3.yzw;
  r14.xyz = r14.xyz * r1.www;
  r18.xyz = r14.xyz * r11.xyz;
  r1.x = 1 + -r1.x;
  r1.x = r10.z ? r1.x : r1.z;
  r1.x = r10.w ? 1 : r1.x;
  r1.x = r10.y ? 0 : r1.x;
  r1.y = r4.x + r4.x;
  r10.yzw = r1.yyy * r2.xyz + -r8.xyz;
  r1.y = dot(r10.yzw, r10.yzw);
  r1.y = rsqrt(r1.y);
  r19.xyz = float3(1,1,1) + -r4.yyy;
  r1.w = max(0, r19.z);
  r7.x = sqrt(r1.w);
  r7.x = r7.x + r4.y;
  r1.w = r7.x * r1.w;
  r10.yzw = r10.yzw * r1.yyy + -r2.xyz;
  r20.xyz = r1.www * r10.yzw + r2.xyz;
  r1.y = min(1, r4.y);
  r1.y = sqrt(r1.y);
  r1.y = 6 * r1.y;
  r6.w = 1;
  r21.xyz = r6.xyz;
  r21.w = 1;
  r22.xyz = float3(0,0,0);
  r1.w = 0;
  r7.xy = float2(0,0);
  while (true) {
    r8.w = cmp((uint)r7.y < (uint)r15.y);
    r11.w = cmp(r7.x < 1);
    r8.w = r8.w ? r11.w : 0;
    r11.w = cmp(r1.w < 1);
    r8.w = r8.w ? r11.w : 0;
    if (r8.w == 0) break;
    r8.w = (int)r7.y + (int)r15.z;
    r8.w = s_LocalLightIndexData[r8.w].x;
    r8.w = (uint)r8.w >> (uint)r15.w;
    r8.w = (int)r8.w & 0x0000ffff;
    r11.w = (uint)g_probe_param[r8.w].x >> 1;
    r12.w = cmp((int)r11.w == 1);
    if (r12.w != 0) {
      r12.w = (int)r8.w * 3;
      r23.x = dot(g_probe_data[r12.w].xyzw, r6.xyzw);
      r23.y = dot(g_probe_data[r12.w+1].xyzw, r6.xyzw);
      r23.z = dot(g_probe_data[r12.w+2].xyzw, r6.xyzw);
      r13.w = max(abs(r23.x), abs(r23.y));
      r13.w = max(r13.w, abs(r23.z));
      r14.w = cmp(r13.w < 0.99000001);
      r16.w = max(g_probe_param[r8.w].y, 0.00999999978);
      r16.w = min(0.99000001, r16.w);
      r16.w = 1 + -r16.w;
      r16.w = 1 / r16.w;
      r13.w = -g_probe_param[r8.w].y + r13.w;
      r13.w = saturate(-r16.w * r13.w + 1);
      r13.w = r14.w ? r13.w : 0;
      r14.w = cmp(0 < r13.w);
      if (r14.w != 0) {
        r24.x = dot(g_probe_data[r12.w].xyz, r20.xyz);
        r24.y = dot(g_probe_data[r12.w+1].xyz, r20.xyz);
        r24.z = dot(g_probe_data[r12.w+2].xyz, r20.xyz);
        r25.xyz = float3(1,1,1) + -r23.xyz;
        r25.xyz = r25.xyz / r24.xyz;
        r23.xyz = float3(-1,-1,-1) + -r23.xyz;
        r23.xyz = r23.xyz / r24.xyz;
        r23.xyz = max(r25.xyz, r23.xyz);
        r12.w = min(r23.y, r23.z);
        r12.w = min(r23.x, r12.w);
        r23.xyz = r20.xyz * r12.www + r21.xyz;
        r23.xyz = -g_probe_pos[r8.w].xyz + r23.xyz;
      } else {
        r23.xyz = r20.xyz;
      }
    } else {
      r12.w = cmp((int)r11.w == 3);
      if (r12.w != 0) {
        r24.xyz = -g_probe_pos[r8.w].xyz + r6.xyz;
        r12.w = dot(r24.xyz, r24.xyz);
        r14.w = sqrt(r12.w);
        r16.w = r14.w / g_probe_param[r8.w].z;
        r17.w = cmp(r16.w < 0.99000001);
        r18.w = max(g_probe_param[r8.w].y, 0.00999999978);
        r18.w = min(0.99000001, r18.w);
        r18.w = 1 + -r18.w;
        r18.w = 1 / r18.w;
        r16.w = -g_probe_param[r8.w].y + r16.w;
        r16.w = saturate(-r18.w * r16.w + 1);
        r13.w = r17.w ? r16.w : 0;
        r16.w = cmp(0 < r13.w);
        r24.xyz = r24.xyz / r14.www;
        r17.w = dot(r24.xyz, -r20.xyz);
        r18.w = r17.w * r14.w;
        r12.w = -r18.w * r18.w + r12.w;
        r12.w = sqrt(r12.w);
        r12.w = r12.w * r12.w;
        r12.w = g_probe_param[r8.w].z * g_probe_param[r8.w].z + -r12.w;
        r12.w = sqrt(r12.w);
        r12.w = r17.w * r14.w + r12.w;
        r24.xyz = r20.xyz * r12.www + r6.xyz;
        r24.xyz = -g_probe_pos[r8.w].xyz + r24.xyz;
        r23.xyz = r16.www ? r24.xyz : r20.xyz;
      } else {
        r12.w = cmp((int)r11.w == 2);
        if (r12.w != 0) {
          r24.xyz = -g_probe_pos[r8.w].xyz + r6.xyz;
          r12.w = dot(r24.xyz, r24.xyz);
          r12.w = sqrt(r12.w);
          r12.w = r12.w / g_probe_param[r8.w].z;
          r14.w = cmp(r12.w < 0.99000001);
          r16.w = max(g_probe_param[r8.w].y, 0.00999999978);
          r16.w = min(0.99000001, r16.w);
          r16.w = 1 + -r16.w;
          r16.w = 1 / r16.w;
          r12.w = -g_probe_param[r8.w].y + r12.w;
          r12.w = saturate(-r16.w * r12.w + 1);
          r13.w = r14.w ? r12.w : 0;
        } else {
          if (r11.w == 0) {
            r11.w = (int)r8.w * 3;
            r12.w = dot(g_probe_data[r11.w].xyzw, r21.xyzw);
            r14.w = dot(g_probe_data[r11.w+1].xyzw, r21.xyzw);
            r11.w = dot(g_probe_data[r11.w+2].xyzw, r21.xyzw);
            r12.w = max(abs(r14.w), abs(r12.w));
            r11.w = max(r12.w, abs(r11.w));
            r12.w = cmp(r11.w < 0.99000001);
            r14.w = max(g_probe_param[r8.w].y, 0.00999999978);
            r14.w = min(0.99000001, r14.w);
            r14.w = 1 + -r14.w;
            r14.w = 1 / r14.w;
            r11.w = -g_probe_param[r8.w].y + r11.w;
            r11.w = saturate(-r14.w * r11.w + 1);
            r13.w = r12.w ? r11.w : 0;
          } else {
            r13.w = 1;
          }
        }
        r23.xyz = r20.xyz;
      }
    }
    r11.w = cmp(0 < r13.w);
    if (r11.w != 0) {
      r23.z = -r23.z;
      r23.w = g_probe_pos[r8.w].w;
      r23.xyzw = s_IBLProbeArray.SampleLevel(s_IBLProbeArray_sampler_s, r23.xyzw, r1.y).xyzw;
      r8.w = 1 + -r7.x;
      r8.w = min(r13.w, r8.w);
      r22.xyz = r23.xyz * r8.www + r22.xyz;
      r1.w = r23.w * r8.w + r1.w;
      r7.x = r8.w + r7.x;
    }
    r7.y = (int)r7.y + 1;
  }
  r3.x = r3.x * r1.z;
  r20.w = -r20.z;
  r21.xyz = s_IBL_NedSmpignorenametexture.SampleLevel(s_IBL_sampler_s, r20.xyw, r1.y).xyz;
  r23.xyz = float3(1,1,1) + r21.xyz;
  r23.xyz = max(float3(0,0,0), r23.xyz);
  r23.xyz = log2(r23.xyz);
  r23.xyz = u_ibl_param.xxx * r23.xyz;
  r23.xyz = exp2(r23.xyz);
  r23.xyz = float3(-1,-1,-1) + r23.xyz;
  r23.xyz = max(float3(0,0,0), r23.xyz);
  r24.xyz = -r23.xyz + r21.xyz;
  r23.xyz = r3.xxx * r24.xyz + r23.xyz;
  r1.w = saturate(1 + -r1.w);
  r22.xyz = r23.xyz * r1.www + r22.xyz;
  r23.xy = s_EnvBRDF_NedSmpignorenametexture.SampleLevel(s_EnvBRDF_sampler_s, r4.xy, 0).xy;
  r24.xyz = r3.yzw * r23.xxx + r23.yyy;
  r22.xyz = r24.xyz * r22.xyz;
  r22.xyz = max(float3(0,0,0), r22.xyz);
  r1.w = 1 + -r1.x;
  r1.x = r9.z * r1.w + r1.x;
  r22.xyz = r22.xyz * r1.xxx;
  r13.xyz = r13.xyz * r1.zzz;
  r1.xzw = r12.xyz * r1.zzz;
  r7.x = 1 + -r0.w;
  r7.x = saturate(r7.w * r7.x + r0.w);
  r1.xzw = r1.xzw / r7.xxx;
  r7.xyw = r22.xyz / r7.xxx;
  r12.w = saturate(FalloffFactor.x * r4.w + r0.w);
  r13.xyz = r13.xyz * r3.xxx + r16.xyz;
  r16.xyz = max(float3(0,0,0), r13.xyz);
  r16.xyz = r16.xyz * float3(0.318309873,0.318309873,0.318309873) + r18.xyz;
  r16.xyz = r16.xyz * r0.xyz;
  r1.xzw = r1.xzw * r3.xxx + r17.xyz;
  r17.xyz = max(float3(0,0,0), r1.xzw);
  r12.xyz = r17.xyz + r7.xyw;
  switch (r10.x) {
    case 0 :    r23.xyz = r16.xyz;
    break;
    case 1 :    r23.xyz = float3(0.318309873,0.318309873,0.318309873) * r13.xyz;
    r12.xyzw = float4(0,0,0,0);
    break;
    case 2 :    r12.xyzw = float4(0,0,0,0);
    r23.xyz = r1.xzw;
    break;
    case 3 :    r12.xyzw = float4(0,0,0,0);
    r23.xyz = r18.xyz;
    break;
    case 43 :    r12.xyzw = float4(0,0,0,0);
    r23.xyz = r18.xyz;
    break;
    case 44 :    r23.xyz = r14.xyz * r11.xyz + r7.xyw;
    r12.xyzw = float4(0,0,0,0);
    break;
    case 4 :    r12.xyzw = float4(0,0,0,0);
    r23.xyz = r7.xyw;
    break;
    case 5 :    case 6 :    r13.xyz = r10.yzw * float3(0.994937599,0.994937599,0.994937599) + r2.xyz;
    r17.xyz = r6.xyz;
    r17.w = 1;
    r6.w = 1;
    r1.xzw = float3(0,0,0);
    r0.w = 0;
    r3.x = 0;
    r4.w = 0;
    while (true) {
      r8.w = cmp((uint)r4.w < (uint)r15.y);
      r10.y = cmp(r3.x < 1);
      r8.w = r8.w ? r10.y : 0;
      r10.y = cmp(r0.w < 1);
      r8.w = r8.w ? r10.y : 0;
      if (r8.w == 0) break;
      r8.w = (int)r4.w + (int)r15.z;
      r8.w = s_LocalLightIndexData[r8.w].x;
      r8.w = (uint)r8.w >> (uint)r15.w;
      r8.w = (int)r8.w & 0x0000ffff;
      r10.y = (uint)g_probe_param[r8.w].x >> 1;
      r10.z = cmp((int)r10.y == 1);
      if (r10.z != 0) {
        r10.z = (int)r8.w * 3;
        r22.x = dot(g_probe_data[r10.z].xyzw, r17.xyzw);
        r22.y = dot(g_probe_data[r10.z+1].xyzw, r17.xyzw);
        r22.z = dot(g_probe_data[r10.z+2].xyzw, r17.xyzw);
        r10.w = max(abs(r22.x), abs(r22.y));
        r10.w = max(r10.w, abs(r22.z));
        r11.w = cmp(r10.w < 0.99000001);
        r14.w = max(g_probe_param[r8.w].y, 0.00999999978);
        r14.w = min(0.99000001, r14.w);
        r14.w = 1 + -r14.w;
        r14.w = 1 / r14.w;
        r10.w = -g_probe_param[r8.w].y + r10.w;
        r10.w = saturate(-r14.w * r10.w + 1);
        r10.w = r11.w ? r10.w : 0;
        r11.w = cmp(0 < r10.w);
        if (r11.w != 0) {
          r25.x = dot(g_probe_data[r10.z].xyz, r13.xyz);
          r25.y = dot(g_probe_data[r10.z+1].xyz, r13.xyz);
          r25.z = dot(g_probe_data[r10.z+2].xyz, r13.xyz);
          r26.xyz = float3(1,1,1) + -r22.xyz;
          r26.xyz = r26.xyz / r25.xyz;
          r22.xyz = float3(-1,-1,-1) + -r22.xyz;
          r22.xyz = r22.xyz / r25.xyz;
          r22.xyz = max(r26.xyz, r22.xyz);
          r10.z = min(r22.y, r22.z);
          r10.z = min(r22.x, r10.z);
          r22.xyz = r13.xyz * r10.zzz + r17.xyz;
          r22.xyz = -g_probe_pos[r8.w].xyz + r22.xyz;
        } else {
          r22.xyz = r13.xyz;
        }
      } else {
        r10.z = cmp((int)r10.y == 3);
        if (r10.z != 0) {
          r25.xyz = -g_probe_pos[r8.w].xyz + r6.xyz;
          r10.z = dot(r25.xyz, r25.xyz);
          r11.w = sqrt(r10.z);
          r14.w = r11.w / g_probe_param[r8.w].z;
          r16.w = cmp(r14.w < 0.99000001);
          r18.w = max(g_probe_param[r8.w].y, 0.00999999978);
          r18.w = min(0.99000001, r18.w);
          r18.w = 1 + -r18.w;
          r18.w = 1 / r18.w;
          r14.w = -g_probe_param[r8.w].y + r14.w;
          r14.w = saturate(-r18.w * r14.w + 1);
          r10.w = r16.w ? r14.w : 0;
          r14.w = cmp(0 < r10.w);
          r25.xyz = r25.xyz / r11.www;
          r16.w = dot(r25.xyz, -r13.xyz);
          r18.w = r16.w * r11.w;
          r10.z = -r18.w * r18.w + r10.z;
          r10.z = sqrt(r10.z);
          r10.z = r10.z * r10.z;
          r10.z = g_probe_param[r8.w].z * g_probe_param[r8.w].z + -r10.z;
          r10.z = sqrt(r10.z);
          r10.z = r16.w * r11.w + r10.z;
          r25.xyz = r13.xyz * r10.zzz + r6.xyz;
          r25.xyz = -g_probe_pos[r8.w].xyz + r25.xyz;
          r22.xyz = r14.www ? r25.xyz : r13.xyz;
        } else {
          r10.z = cmp((int)r10.y == 2);
          if (r10.z != 0) {
            r25.xyz = -g_probe_pos[r8.w].xyz + r6.xyz;
            r10.z = dot(r25.xyz, r25.xyz);
            r10.z = sqrt(r10.z);
            r10.z = r10.z / g_probe_param[r8.w].z;
            r11.w = cmp(r10.z < 0.99000001);
            r14.w = max(g_probe_param[r8.w].y, 0.00999999978);
            r14.w = min(0.99000001, r14.w);
            r14.w = 1 + -r14.w;
            r14.w = 1 / r14.w;
            r10.z = -g_probe_param[r8.w].y + r10.z;
            r10.z = saturate(-r14.w * r10.z + 1);
            r10.w = r11.w ? r10.z : 0;
          } else {
            if (r10.y == 0) {
              r10.y = (int)r8.w * 3;
              r10.z = dot(g_probe_data[r10.y].xyzw, r6.xyzw);
              r11.w = dot(g_probe_data[r10.y+1].xyzw, r6.xyzw);
              r10.y = dot(g_probe_data[r10.y+2].xyzw, r6.xyzw);
              r10.z = max(abs(r11.w), abs(r10.z));
              r10.y = max(r10.z, abs(r10.y));
              r10.z = cmp(r10.y < 0.99000001);
              r11.w = max(g_probe_param[r8.w].y, 0.00999999978);
              r11.w = min(0.99000001, r11.w);
              r11.w = 1 + -r11.w;
              r11.w = 1 / r11.w;
              r10.y = -g_probe_param[r8.w].y + r10.y;
              r10.y = saturate(-r11.w * r10.y + 1);
              r10.w = r10.z ? r10.y : 0;
            } else {
              r10.w = 1;
            }
          }
          r22.xyz = r13.xyz;
        }
      }
      r10.y = cmp(0 < r10.w);
      if (r10.y != 0) {
        r22.z = -r22.z;
        r22.w = g_probe_pos[r8.w].w;
        r22.xyzw = s_IBLProbeArray.SampleLevel(s_IBLProbeArray_sampler_s, r22.xyzw, 0.600000024).xyzw;
        r8.w = 1 + -r3.x;
        r8.w = min(r10.w, r8.w);
        r1.xzw = r22.xyz * r8.www + r1.xzw;
        r0.w = r22.w * r8.w + r0.w;
        r3.x = r8.w + r3.x;
      }
      r4.w = (int)r4.w + 1;
    }
    r13.w = -r13.z;
    r10.yzw = s_IBL_NedSmpignorenametexture.SampleLevel(s_IBL_sampler_s, r13.xyw, 0.600000024).xyz;
    r0.w = saturate(1 + -r0.w);
    r1.xzw = r10.yzw * r0.www + r1.xzw;
    r4.z = 0.00999999978;
    r4.xz = s_EnvBRDF_NedSmpignorenametexture.SampleLevel(s_EnvBRDF_sampler_s, r4.xz, 0).xy;
    r0.w = r4.x + r4.z;
    r1.xzw = r1.xzw * r0.www;
    r23.xyz = max(float3(0,0,0), r1.xzw);
    r12.xyzw = float4(0,0,0,0);
    break;
    case 7 :    r12.xyzw = float4(0,0,0,0);
    r23.xyz = float3(1,1,1);
    break;
    case 33 :    r0.w = round(g_probe_param[0].x);
    r0.w = (int)r0.w;
    r0.w = (int)r0.w & 1;
    r6.w = 1;
    r13.x = dot(g_probe_data[0].xyzw, r6.xyzw);
    r13.y = dot(g_probe_data[1].xyzw, r6.xyzw);
    r13.z = dot(g_probe_data[2].xyzw, r6.xyzw);
    r1.x = max(abs(r13.x), abs(r13.y));
    r1.x = max(r1.x, abs(r13.z));
    r1.x = cmp(g_probe_param[0].y < r1.x);
    r1.x = r1.x ? 1.000000 : 0;
    r4.xzw = cmp(float3(0.99000001,0.99000001,0.99000001) < abs(r13.xyz));
    r1.z = (int)r4.z | (int)r4.x;
    r1.z = (int)r4.w | (int)r1.z;
    r1.x = r1.z ? 0 : r1.x;
    r12.w = r0.w ? r1.x : r12.w;
    r23.xyz = r16.xyz;
    break;
    case 35 :    r12.w = 0;
    r23.xyz = r16.xyz;
    break;
    default :
    switch (r10.x) {
      case 10 :      r23.xyz = float3(0,0,0);
      r0.w = r10.x;
      break;
      case 11 :      r23.xyz = float3(0,0,0);
      r0.w = r10.x;
      break;
      case 12 :      r23.xyz = r18.xyz;
      r0.w = r10.x;
      break;
      case 13 :      r23.xyz = float3(0,0,0);
      r0.w = r10.x;
      break;
      case 14 :      r23.xyz = r0.xyz;
      r0.w = r10.x;
      break;
      case 15 :      r1.xzw = float3(0.010397804,0.010397804,0.010397804) + -r0.xyz;
      r1.xzw = max(float3(0,0,0), r1.xzw);
      r1.x = dot(r1.xzw, r1.xzw);
      r4.xzw = saturate(float3(-0.899384499,-0.899384499,-0.899384499) + r0.xyz);
      r1.z = dot(r4.xzw, r4.xzw);
      r1.xz = cmp(r1.xz != float2(0,0));
      r1.x = (int)r1.z | (int)r1.x;
      r23.xyz = r1.xxx ? float3(10,0,0) : r0.xyz;
      r0.w = r10.x;
      break;
      case 16 :      r23.xyz = r12.www;
      r0.w = r10.x;
      break;
      case 17 :      r23.xyz = saturate(r2.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5));
      r0.w = r10.x;
      break;
      case 18 :      r23.xyz = r4.yyy;
      r0.w = r10.x;
      break;
      case 36 :      r23.xyz = r19.xyz;
      r0.w = r10.x;
      break;
      case 19 :      r23.xyz = r14.xyz * r11.xyz + r7.xyw;
      r0.w = r10.x;
      break;
      case 20 :      r23.xyz = float3(1,1,1);
      r0.w = r10.x;
      break;
      case 21 :      r23.xyz = r3.yzw;
      r0.w = r10.x;
      break;
      case 22 :      r23.xyz = r9.xyz;
      r0.w = r10.x;
      break;
      case 23 :      r0.xy = (int2)r5.xy & int2(15,15);
      r1.xz = cmp((int2)r0.xy != int2(0,0));
      r0.z = r1.z ? r1.x : 0;
      if (r0.z != 0) {
        r0.z = s_LocalLightIndexData[r5.w].x;
        r1.x = (uint)r0.z >> 16;
        r1.x = min(64, (uint)r1.x);
        r1.x = (int)r1.x & (int)r7.z;
        r0.z = (int)r0.z & 0x0000ffff;
        r0.z = min(64, (uint)r0.z);
        r0.z = (int)r0.z & (int)r7.z;
        r0.y = (int)r0.y + 8;
        r0.x = cmp((uint)r0.x < (uint)r0.y);
        r0.x = r0.x ? r1.x : r0.z;
        if (r0.x != 0) {
          r0.x = (uint)r0.x;
          r0.x = 0.0500000007 * r0.x;
          x1[0].xyz = float3(1,0,0);
          x1[1].xyz = float3(1,1,0);
          x1[2].xyz = float3(0,1,0);
          x1[3].xyz = float3(0,1,1);
          x1[4].xyz = float3(0,0,1);
          r0.x = min(1, r0.x);
          r0.x = 1 + -r0.x;
          r0.y = 4 * r0.x;
          r0.y = trunc(r0.y);
          r0.x = r0.x * 4 + -r0.y;
          r0.y = (int)r0.y;
          r3.xyz = x1[r0.y+0].xyz;
          r0.y = (int)r0.y + 1;
          r0.y = min(4, (int)r0.y);
          r4.xyz = x1[r0.y+0].xyz;
          r4.xyz = r4.xyz + -r3.xyz;
          r0.xyz = r0.xxx * r4.xyz + r3.xyz;
          r0.xyz = float3(0.400000006,0.400000006,0.400000006) * r0.xyz;
        } else {
          r0.xyz = float3(0,0,0);
        }
        r1.zw = (int2)r5.xy & int2(-16,-16);
        r3.xyz = float3(1,1,1) + -r0.xyz;
        r1.x = (uint)r1.x;
        r4.zw = float2(0,0);
        r23.xyz = r0.xyz;
        r3.w = r1.z;
        r5.w = r1.w;
        r7.xyw = float3(100,0,0);
        while (true) {
          r8.w = cmp((uint)r7.w >= 3);
          if (r8.w != 0) break;
          r8.w = r1.x / r7.x;
          r8.w = (uint)r8.w;
          r8.w = (uint)r8.w;
          r8.w = 0.100000001 * r8.w;
          r8.w = frac(r8.w);
          r8.w = 10 * r8.w;
          r8.w = (uint)r8.w;
          r9.x = cmp((int)r8.w != 0);
          r7.y = (int)r7.y | (int)r9.x;
          r9.x = cmp((int)r7.w == 2);
          r9.x = (int)r7.y | (int)r9.x;
          if (r9.x != 0) {
            r9.x = -(int)r3.w;
            r9.y = -(int)r5.w;
            r9.xy = (int2)r5.xy + (int2)r9.xy;
            r10.yz = cmp((uint2)r9.xy < int2(8,8));
            r9.z = r10.z ? r10.y : 0;
            if (r9.z != 0) {
              r4.x = mad((int)r8.w, 7, (int)r9.x);
              r4.y = (int)r9.y + 207;
              r4.x = s_DebugFont.Load(r4.xyz).w;
              r9.xyz = -r23.xyz + r3.xyz;
              r23.xyz = r4.xxx * r9.xyz + r23.xyz;
            }
            r4.x = (int)r3.w + 7;
          } else {
            r4.x = (int)r3.w + 7;
          }
          r3.w = (int)r4.x + -2;
          r7.x = 0.100000001 * r7.x;
          r7.w = (int)r7.w + 1;
        }
      } else {
        r23.xyz = float3(0,0,0);
      }
      r0.w = r10.x;
      break;
      case 37 :      r0.xy = (int2)r5.xy & int2(15,15);
      r1.xz = cmp((int2)r0.xy != int2(0,0));
      r0.z = r1.z ? r1.x : 0;
      if (r0.z != 0) {
        r0.z = mad((int)r5.z, 3, 1);
        r0.z = s_LocalLightIndexData[r0.z].x;
        r1.x = (uint)r0.z >> 16;
        r1.x = min(64, (uint)r1.x);
        r1.x = (int)r1.x & (int)r7.z;
        r0.z = (int)r0.z & 0x0000ffff;
        r0.z = min(64, (uint)r0.z);
        r0.z = (int)r0.z & (int)r7.z;
        r0.y = (int)r0.y + 8;
        r0.x = cmp((uint)r0.x < (uint)r0.y);
        r0.x = r0.x ? r1.x : r0.z;
        if (r0.x != 0) {
          r0.x = (uint)r0.x;
          r0.x = 0.0500000007 * r0.x;
          x2[0].xyz = float3(1,0,0);
          x2[1].xyz = float3(1,1,0);
          x2[2].xyz = float3(0,1,0);
          x2[3].xyz = float3(0,1,1);
          x2[4].xyz = float3(0,0,1);
          r0.x = min(1, r0.x);
          r0.x = 1 + -r0.x;
          r0.y = 4 * r0.x;
          r0.y = trunc(r0.y);
          r0.x = r0.x * 4 + -r0.y;
          r0.y = (int)r0.y;
          r3.xyz = x2[r0.y+0].xyz;
          r0.y = (int)r0.y + 1;
          r0.y = min(4, (int)r0.y);
          r4.xyz = x2[r0.y+0].xyz;
          r4.xyz = r4.xyz + -r3.xyz;
          r0.xyz = r0.xxx * r4.xyz + r3.xyz;
          r0.xyz = float3(0.400000006,0.400000006,0.400000006) * r0.xyz;
        } else {
          r0.xyz = float3(0,0,0);
        }
        r1.zw = (int2)r5.xy & int2(-16,-16);
        r3.xyz = float3(1,1,1) + -r0.xyz;
        r1.x = (uint)r1.x;
        r4.zw = float2(0,0);
        r23.xyz = r0.xyz;
        r3.w = r1.z;
        r5.z = r1.w;
        r5.w = 100;
        r7.xy = float2(0,0);
        while (true) {
          r7.w = cmp((uint)r7.y >= 3);
          if (r7.w != 0) break;
          r7.w = r1.x / r5.w;
          r7.w = (uint)r7.w;
          r7.w = (uint)r7.w;
          r7.w = 0.100000001 * r7.w;
          r7.w = frac(r7.w);
          r7.w = 10 * r7.w;
          r7.w = (uint)r7.w;
          r8.w = cmp((int)r7.w != 0);
          r7.x = (int)r7.x | (int)r8.w;
          r8.w = cmp((int)r7.y == 2);
          r8.w = (int)r7.x | (int)r8.w;
          if (r8.w != 0) {
            r9.x = -(int)r3.w;
            r9.y = -(int)r5.z;
            r9.xy = (int2)r5.xy + (int2)r9.xy;
            r10.yz = cmp((uint2)r9.xy < int2(8,8));
            r8.w = r10.z ? r10.y : 0;
            if (r8.w != 0) {
              r4.x = mad((int)r7.w, 7, (int)r9.x);
              r4.y = (int)r9.y + 207;
              r4.x = s_DebugFont.Load(r4.xyz).w;
              r9.xyz = -r23.xyz + r3.xyz;
              r23.xyz = r4.xxx * r9.xyz + r23.xyz;
            }
            r4.x = (int)r3.w + 7;
          } else {
            r4.x = (int)r3.w + 7;
          }
          r3.w = (int)r4.x + -2;
          r5.w = 0.100000001 * r5.w;
          r7.y = (int)r7.y + 1;
        }
      } else {
        r23.xyz = float3(0,0,0);
      }
      r0.w = r10.x;
      break;
      case 38 :      r0.xy = (int2)r5.xy & int2(15,15);
      r1.xz = cmp((int2)r0.xy != int2(0,0));
      r0.z = r1.z ? r1.x : 0;
      if (r0.z != 0) {
        r0.z = (int)r7.z & (int)r15.x;
        r1.x = (int)r9.w & 0x0000ffff;
        r1.x = min(64, (uint)r1.x);
        r1.x = (int)r1.x & (int)r7.z;
        r0.y = (int)r0.y + 8;
        r0.x = cmp((uint)r0.x < (uint)r0.y);
        r0.x = r0.x ? r0.z : r1.x;
        if (r0.x != 0) {
          r0.x = (uint)r0.x;
          r0.x = 0.0500000007 * r0.x;
          x3[0].xyz = float3(1,0,0);
          x3[1].xyz = float3(1,1,0);
          x3[2].xyz = float3(0,1,0);
          x3[3].xyz = float3(0,1,1);
          x3[4].xyz = float3(0,0,1);
          r0.x = min(1, r0.x);
          r0.x = 1 + -r0.x;
          r0.y = 4 * r0.x;
          r0.y = trunc(r0.y);
          r0.x = r0.x * 4 + -r0.y;
          r0.y = (int)r0.y;
          r1.xzw = x3[r0.y+0].xyz;
          r0.y = (int)r0.y + 1;
          r0.y = min(4, (int)r0.y);
          r3.xyz = x3[r0.y+0].xyz;
          r3.xyz = r3.xyz + -r1.xzw;
          r1.xzw = r0.xxx * r3.xyz + r1.xzw;
          r1.xzw = float3(0.400000006,0.400000006,0.400000006) * r1.xzw;
        } else {
          r1.xzw = float3(0,0,0);
        }
        r0.xy = (int2)r5.xy & int2(-16,-16);
        r3.xyz = float3(1,1,1) + -r1.xzw;
        r0.z = (uint)r0.z;
        r4.zw = float2(0,0);
        r23.xyz = r1.xzw;
        r3.w = r0.x;
        r5.z = r0.y;
        r5.w = 100;
        r7.xy = float2(0,0);
        while (true) {
          r7.z = cmp((uint)r7.y >= 3);
          if (r7.z != 0) break;
          r7.z = r0.z / r5.w;
          r7.z = (uint)r7.z;
          r7.z = (uint)r7.z;
          r7.z = 0.100000001 * r7.z;
          r7.z = frac(r7.z);
          r7.z = 10 * r7.z;
          r7.z = (uint)r7.z;
          r7.w = cmp((int)r7.z != 0);
          r7.x = (int)r7.w | (int)r7.x;
          r7.w = cmp((int)r7.y == 2);
          r7.w = (int)r7.w | (int)r7.x;
          if (r7.w != 0) {
            r9.x = -(int)r3.w;
            r9.y = -(int)r5.z;
            r9.xy = (int2)r5.xy + (int2)r9.xy;
            r9.zw = cmp((uint2)r9.xy < int2(8,8));
            r7.w = r9.w ? r9.z : 0;
            if (r7.w != 0) {
              r4.x = mad((int)r7.z, 7, (int)r9.x);
              r4.y = (int)r9.y + 207;
              r4.x = s_DebugFont.Load(r4.xyz).w;
              r9.xyz = -r23.xyz + r3.xyz;
              r23.xyz = r4.xxx * r9.xyz + r23.xyz;
            }
            r4.x = (int)r3.w + 7;
          } else {
            r4.x = (int)r3.w + 7;
          }
          r3.w = (int)r4.x + -2;
          r5.w = 0.100000001 * r5.w;
          r7.y = (int)r7.y + 1;
        }
      } else {
        r23.xyz = float3(0,0,0);
      }
      r0.w = r10.x;
      break;
      case 26 :      r23.xyz = float3(1,1,1);
      r0.w = r10.x;
      break;
      case 27 :      r23.xyz = float3(0,0,0);
      r0.w = r10.x;
      break;
      case 28 :      r3.xyz = r6.xyz;
      r3.w = 1;
      r6.w = 1;
      r0.xyz = float3(0,0,0);
      r1.xzw = float3(0,0,0);
      while (true) {
        r4.x = cmp((uint)r1.w < (uint)r15.y);
        r4.y = cmp(r1.z < 1);
        r4.x = r4.y ? r4.x : 0;
        r4.y = cmp(r1.x < 1);
        r4.x = r4.y ? r4.x : 0;
        if (r4.x == 0) break;
        r4.x = (int)r1.w + (int)r15.z;
        r4.x = s_LocalLightIndexData[r4.x].x;
        r4.x = (uint)r4.x >> (uint)r15.w;
        r4.x = (int)r4.x & 0x0000ffff;
        r4.y = (uint)g_probe_param[r4.x].x >> 1;
        r4.z = cmp((int)r4.y == 1);
        if (r4.z != 0) {
          r4.z = (int)r4.x * 3;
          r5.x = dot(g_probe_data[r4.z].xyzw, r3.xyzw);
          r5.y = dot(g_probe_data[r4.z+1].xyzw, r3.xyzw);
          r5.z = dot(g_probe_data[r4.z+2].xyzw, r3.xyzw);
          r4.w = max(abs(r5.x), abs(r5.y));
          r4.w = max(r4.w, abs(r5.z));
          r5.w = cmp(r4.w < 0.99000001);
          r7.x = max(g_probe_param[r4.x].y, 0.00999999978);
          r7.x = min(0.99000001, r7.x);
          r7.x = 1 + -r7.x;
          r7.x = 1 / r7.x;
          r4.w = -g_probe_param[r4.x].y + r4.w;
          r4.w = saturate(-r7.x * r4.w + 1);
          r4.w = r5.w ? r4.w : 0;
          r5.w = cmp(0 < r4.w);
          if (r5.w != 0) {
            r7.x = dot(g_probe_data[r4.z].xyz, r2.xyz);
            r7.y = dot(g_probe_data[r4.z+1].xyz, r2.xyz);
            r7.z = dot(g_probe_data[r4.z+2].xyz, r2.xyz);
            r9.xyz = float3(1,1,1) + -r5.xyz;
            r9.xyz = r9.xyz / r7.xyz;
            r5.xyz = float3(-1,-1,-1) + -r5.xyz;
            r5.xyz = r5.xyz / r7.xyz;
            r5.xyz = max(r9.xyz, r5.xyz);
            r4.z = min(r5.y, r5.z);
            r4.z = min(r5.x, r4.z);
            r5.xyz = r2.xyz * r4.zzz + r3.xyz;
            r5.xyz = -g_probe_pos[r4.x].xyz + r5.xyz;
          } else {
            r5.xyz = r2.xyz;
          }
        } else {
          r4.z = cmp((int)r4.y == 3);
          if (r4.z != 0) {
            r7.xyz = -g_probe_pos[r4.x].xyz + r6.xyz;
            r4.z = dot(r7.xyz, r7.xyz);
            r7.w = sqrt(r4.z);
            r8.w = r7.w / g_probe_param[r4.x].z;
            r9.x = cmp(r8.w < 0.99000001);
            r9.y = max(g_probe_param[r4.x].y, 0.00999999978);
            r9.y = min(0.99000001, r9.y);
            r9.y = 1 + -r9.y;
            r9.y = 1 / r9.y;
            r8.w = -g_probe_param[r4.x].y + r8.w;
            r8.w = saturate(-r9.y * r8.w + 1);
            r4.w = r9.x ? r8.w : 0;
            r8.w = cmp(0 < r4.w);
            r7.xyz = r7.xyz / r7.www;
            r7.x = dot(r7.xyz, -r2.xyz);
            r7.y = r7.x * r7.w;
            r4.z = -r7.y * r7.y + r4.z;
            r4.z = sqrt(r4.z);
            r4.z = r4.z * r4.z;
            r4.z = g_probe_param[r4.x].z * g_probe_param[r4.x].z + -r4.z;
            r4.z = sqrt(r4.z);
            r4.z = r7.x * r7.w + r4.z;
            r7.xyz = r2.xyz * r4.zzz + r6.xyz;
            r7.xyz = -g_probe_pos[r4.x].xyz + r7.xyz;
            r5.xyz = r8.www ? r7.xyz : r2.xyz;
          } else {
            r4.z = cmp((int)r4.y == 2);
            if (r4.z != 0) {
              r7.xyz = -g_probe_pos[r4.x].xyz + r6.xyz;
              r4.z = dot(r7.xyz, r7.xyz);
              r4.z = sqrt(r4.z);
              r4.z = r4.z / g_probe_param[r4.x].z;
              r7.x = cmp(r4.z < 0.99000001);
              r7.y = max(g_probe_param[r4.x].y, 0.00999999978);
              r7.y = min(0.99000001, r7.y);
              r7.y = 1 + -r7.y;
              r7.y = 1 / r7.y;
              r4.z = -g_probe_param[r4.x].y + r4.z;
              r4.z = saturate(-r7.y * r4.z + 1);
              r4.w = r7.x ? r4.z : 0;
            } else {
              if (r4.y == 0) {
                r4.y = (int)r4.x * 3;
                r4.z = dot(g_probe_data[r4.y].xyzw, r6.xyzw);
                r7.x = dot(g_probe_data[r4.y+1].xyzw, r6.xyzw);
                r4.y = dot(g_probe_data[r4.y+2].xyzw, r6.xyzw);
                r4.z = max(abs(r7.x), abs(r4.z));
                r4.y = max(r4.z, abs(r4.y));
                r4.z = cmp(r4.y < 0.99000001);
                r7.x = max(g_probe_param[r4.x].y, 0.00999999978);
                r7.x = min(0.99000001, r7.x);
                r7.x = 1 + -r7.x;
                r7.x = 1 / r7.x;
                r4.y = -g_probe_param[r4.x].y + r4.y;
                r4.y = saturate(-r7.x * r4.y + 1);
                r4.w = r4.z ? r4.y : 0;
              } else {
                r4.w = 1;
              }
            }
            r5.xyz = r2.xyz;
          }
        }
        r4.y = cmp(0 < r4.w);
        if (r4.y != 0) {
          r5.z = -r5.z;
          r5.w = g_probe_pos[r4.x].w;
          r5.xyzw = s_IBLProbeArray.SampleLevel(s_IBLProbeArray_sampler_s, r5.xyzw, 6).xyzw;
          r4.x = 1 + -r1.z;
          r4.x = min(r4.w, r4.x);
          r0.xyz = r5.xyz * r4.xxx + r0.xyz;
          r1.x = r5.w * r4.x + r1.x;
          r1.z = r4.x + r1.z;
        }
        r1.w = (int)r1.w + 1;
      }
      r2.w = -r2.z;
      r2.xyz = s_IBL_NedSmpignorenametexture.SampleLevel(s_IBL_sampler_s, r2.xyw, 6).xyz;
      r1.x = saturate(1 + -r1.x);
      r23.xyz = r2.xyz * r1.xxx + r0.xyz;
      r0.w = r10.x;
      break;
      case 29 :      r2.xyz = r6.xyz;
      r2.w = 1;
      r6.w = 1;
      r0.xyz = float3(0,0,0);
      r1.xzw = float3(0,0,0);
      while (true) {
        r3.x = cmp((uint)r1.w < (uint)r15.y);
        r3.y = cmp(r1.z < 1);
        r3.x = r3.y ? r3.x : 0;
        r3.y = cmp(r1.x < 1);
        r3.x = r3.y ? r3.x : 0;
        if (r3.x == 0) break;
        r3.x = (int)r1.w + (int)r15.z;
        r3.x = s_LocalLightIndexData[r3.x].x;
        r3.x = (uint)r3.x >> (uint)r15.w;
        r3.x = (int)r3.x & 0x0000ffff;
        r3.y = (uint)g_probe_param[r3.x].x >> 1;
        r3.z = cmp((int)r3.y == 1);
        if (r3.z != 0) {
          r3.z = (int)r3.x * 3;
          r4.x = dot(g_probe_data[r3.z].xyzw, r2.xyzw);
          r4.y = dot(g_probe_data[r3.z+1].xyzw, r2.xyzw);
          r4.z = dot(g_probe_data[r3.z+2].xyzw, r2.xyzw);
          r3.w = max(abs(r4.x), abs(r4.y));
          r3.w = max(r3.w, abs(r4.z));
          r4.w = cmp(r3.w < 0.99000001);
          r5.x = max(g_probe_param[r3.x].y, 0.00999999978);
          r5.x = min(0.99000001, r5.x);
          r5.x = 1 + -r5.x;
          r5.x = 1 / r5.x;
          r3.w = -g_probe_param[r3.x].y + r3.w;
          r3.w = saturate(-r5.x * r3.w + 1);
          r3.w = r4.w ? r3.w : 0;
          r4.w = cmp(0 < r3.w);
          if (r4.w != 0) {
            r5.x = dot(g_probe_data[r3.z].xyz, r20.xyz);
            r5.y = dot(g_probe_data[r3.z+1].xyz, r20.xyz);
            r5.z = dot(g_probe_data[r3.z+2].xyz, r20.xyz);
            r7.xyz = float3(1,1,1) + -r4.xyz;
            r7.xyz = r7.xyz / r5.xyz;
            r4.xyz = float3(-1,-1,-1) + -r4.xyz;
            r4.xyz = r4.xyz / r5.xyz;
            r4.xyz = max(r7.xyz, r4.xyz);
            r3.z = min(r4.y, r4.z);
            r3.z = min(r4.x, r3.z);
            r4.xyz = r20.xyz * r3.zzz + r2.xyz;
            r4.xyz = -g_probe_pos[r3.x].xyz + r4.xyz;
          } else {
            r4.xyz = r20.xyz;
          }
        } else {
          r3.z = cmp((int)r3.y == 3);
          if (r3.z != 0) {
            r5.xyz = -g_probe_pos[r3.x].xyz + r6.xyz;
            r3.z = dot(r5.xyz, r5.xyz);
            r5.w = sqrt(r3.z);
            r7.x = r5.w / g_probe_param[r3.x].z;
            r7.y = cmp(r7.x < 0.99000001);
            r7.z = max(g_probe_param[r3.x].y, 0.00999999978);
            r7.z = min(0.99000001, r7.z);
            r7.z = 1 + -r7.z;
            r7.z = 1 / r7.z;
            r7.x = -g_probe_param[r3.x].y + r7.x;
            r7.x = saturate(-r7.z * r7.x + 1);
            r3.w = r7.y ? r7.x : 0;
            r7.x = cmp(0 < r3.w);
            r5.xyz = r5.xyz / r5.www;
            r5.x = dot(r5.xyz, -r20.xyz);
            r5.y = r5.x * r5.w;
            r3.z = -r5.y * r5.y + r3.z;
            r3.z = sqrt(r3.z);
            r3.z = r3.z * r3.z;
            r3.z = g_probe_param[r3.x].z * g_probe_param[r3.x].z + -r3.z;
            r3.z = sqrt(r3.z);
            r3.z = r5.x * r5.w + r3.z;
            r5.xyz = r20.xyz * r3.zzz + r6.xyz;
            r5.xyz = -g_probe_pos[r3.x].xyz + r5.xyz;
            r4.xyz = r7.xxx ? r5.xyz : r20.xyz;
          } else {
            r3.z = cmp((int)r3.y == 2);
            if (r3.z != 0) {
              r5.xyz = -g_probe_pos[r3.x].xyz + r6.xyz;
              r3.z = dot(r5.xyz, r5.xyz);
              r3.z = sqrt(r3.z);
              r3.z = r3.z / g_probe_param[r3.x].z;
              r5.x = cmp(r3.z < 0.99000001);
              r5.y = max(g_probe_param[r3.x].y, 0.00999999978);
              r5.y = min(0.99000001, r5.y);
              r5.y = 1 + -r5.y;
              r5.y = 1 / r5.y;
              r3.z = -g_probe_param[r3.x].y + r3.z;
              r3.z = saturate(-r5.y * r3.z + 1);
              r3.w = r5.x ? r3.z : 0;
            } else {
              if (r3.y == 0) {
                r3.y = (int)r3.x * 3;
                r3.z = dot(g_probe_data[r3.y].xyzw, r6.xyzw);
                r5.x = dot(g_probe_data[r3.y+1].xyzw, r6.xyzw);
                r3.y = dot(g_probe_data[r3.y+2].xyzw, r6.xyzw);
                r3.z = max(abs(r5.x), abs(r3.z));
                r3.y = max(r3.z, abs(r3.y));
                r3.z = cmp(r3.y < 0.99000001);
                r5.x = max(g_probe_param[r3.x].y, 0.00999999978);
                r5.x = min(0.99000001, r5.x);
                r5.x = 1 + -r5.x;
                r5.x = 1 / r5.x;
                r3.y = -g_probe_param[r3.x].y + r3.y;
                r3.y = saturate(-r5.x * r3.y + 1);
                r3.w = r3.z ? r3.y : 0;
              } else {
                r3.w = 1;
              }
            }
            r4.xyz = r20.xyz;
          }
        }
        r3.y = cmp(0 < r3.w);
        if (r3.y != 0) {
          r4.z = -r4.z;
          r4.w = g_probe_pos[r3.x].w;
          r4.xyzw = s_IBLProbeArray.SampleLevel(s_IBLProbeArray_sampler_s, r4.xyzw, r1.y).xyzw;
          r3.x = 1 + -r1.z;
          r3.x = min(r3.w, r3.x);
          r0.xyz = r4.xyz * r3.xxx + r0.xyz;
          r1.x = r4.w * r3.x + r1.x;
          r1.z = r3.x + r1.z;
        }
        r1.w = (int)r1.w + 1;
      }
      r1.x = saturate(1 + -r1.x);
      r0.xyz = r21.xyz * r1.xxx + r0.xyz;
      r0.xyz = r0.xyz * r24.xyz;
      r23.xyz = max(float3(0,0,0), r0.xyz);
      r0.w = r10.x;
      break;
      case 30 :      r23.z = 0;
      r0.w = r10.x;
      break;
      case 31 :      r0.xyz = float3(0.00999999978,0.00999999978,0.00999999978) * r6.xyz;
      r1.xyz = cmp(r0.xyz >= -r0.xyz);
      r0.xyz = frac(abs(r0.xyz));
      r0.xyz = r1.xyz ? r0.xyz : -r0.xyz;
      r0.xyz = float3(1,1,1) + r0.xyz;
      r1.xyz = cmp(r0.xyz >= float3(0,0,0));
      r1.xyz = r1.xyz ? float3(1,1,1) : 0;
      r23.xyz = r1.xyz + r0.xyz;
      r0.w = r10.x;
      break;
      case 32 :      r23.xyz = float3(0,0,0);
      r0.w = r10.x;
      break;
      case 39 :      if (2 == 0) r0.x = 0; else if (2+4 < 32) {       r0.x = (uint)u_shading_model_flag.x << (32-(2 + 4)); r0.x = (uint)r0.x >> (32-2);      } else r0.x = (uint)u_shading_model_flag.x >> 4;
      r0.x = 1 << (int)r0.x;
      r0.x = (int)r0.x & 2;
      r23.xyz = r0.xxx ? float3(1,1,1) : float3(0,0,0);
      r0.w = r10.x;
      break;
      case 40 :      r0.x = g_global_user_param_3.y + -g_global_user_param_3.x;
      r23.xyz = -g_global_user_param_3.xxx / r0.xxx;
      r0.w = r10.x;
      break;
      case 41 :      r0.xyz = (int3)u_shading_model_flag.xxx & int3(4,1,8);
      r1.xyz = r0.xyz ? float3(0.5,0.5,3) : float3(0,0,1);
      r1.w = 0.5;
      r23.xyz = r1.ywx * r1.zzz;
      r0.w = r10.x;
      break;
      case 42 :      if (2 == 0) r0.x = 0; else if (2+4 < 32) {       r0.x = (uint)u_shading_model_flag.x << (32-(2 + 4)); r0.x = (uint)r0.x >> (32-2);      } else r0.x = (uint)u_shading_model_flag.x >> 4;
      r0.xyz = cmp((int3)r0.xxx == int3(1,2,3));
      r23.xyz = r0.xyz ? float3(1,1,1) : 0;
      r0.w = r10.x;
      break;
      default :
      r23.xyz = float3(0,0,0);
      r0.w = 0;
      break;
    }
    if (r0.w != 0) {
      r0.x = s_Luminance_NedSmpignorenametexture.SampleLevel(s_Luminance_sampler_s, float2(0.75,0.5), 0).x;
      r23.xyz = r23.xyz * r0.xxx;
    }
    r12.xyzw = float4(0,0,0,0);
    break;
  }
  r0.x = cmp(shadow_map_parameter[0].z == -1.000000);
  if (r0.x != 0) {
    r6.w = 1;
    r0.x = dot(shadow_camera_view_matrix_third_row.xyzw, r6.xyzw);
    r1.xyzw = cmp(shadow_cascade_frustums_eye_space_depth.xyzw < -r0.xxxx);
    r1.xyzw = r1.xyzw ? float4(1,1,1,1) : 0;
    r0.y = dot(float4(1,1,1,1), r1.xyzw);
    r0.z = (int)shadow_map_parameter[0].y;
    r0.w = cmp(0 < (int)r0.z);
    r0.w = r0.w ? 0 : 4;
    r0.y = r0.y + r0.w;
    r0.y = (int)r0.y;
    r0.w = cmp(shadow_map_parameter[1].z == 0.000000);
    if (r0.w != 0) {
      r0.w = 0;
    } else {
      r1.x = dot(shadow_cascade_frustums_eye_space_depth.xyzw, icb[r0.y+0].xyzw);
      r1.x = r1.x + r0.x;
      r1.x = saturate(shadow_map_parameter[1].z * r1.x);
      r0.w = 1 + -r1.x;
    }
    r1.x = cmp((int)r0.y < (int)r0.z);
    if (r1.x != 0) {
      r1.xyz = shadow_view_matrix._m10_m11_m12 * v5.www;
      r1.xyz = v4.www * shadow_view_matrix._m00_m01_m02 + r1.xyz;
      r1.xyz = v6.www * shadow_view_matrix._m20_m21_m22 + r1.xyz;
      r1.xyz = shadow_view_matrix._m30_m31_m32 + r1.xyz;
      r1.xyz = r1.xyz * shadow_cascade_scale[r0.y].xyz + shadow_cascade_offset[r0.y].xyz;
      r2.xyz = cmp(r1.xyz >= float3(0,0,0));
      r1.xyz = cmp(r1.xyz < float3(1,1,1));
      r1.x = r1.x ? r2.x : 0;
      r1.x = r2.y ? r1.x : 0;
      r1.x = r1.y ? r1.x : 0;
      r1.x = r2.z ? r1.x : 0;
      r1.x = r1.z ? r1.x : 0;
      if (r1.x != 0) {
        r1.x = (int)r0.y + 1;
        r0.z = (int)r0.z + -1;
        r1.x = min((int)r1.x, (int)r0.z);
        r0.z = dot(shadow_cascade_frustums_eye_space_depth.xyzw, icb[r0.z+0].xyzw);
        r0.x = r0.z + r0.x;
        r0.x = saturate(shadow_map_parameter[1].x * r0.x);
        r1.xyz = icb[r1.x+8].xyz + -icb[r0.y+8].xyz;
        r0.yzw = r0.www * r1.xyz + icb[r0.y+8].xyz;
        r0.yzw = float3(-1,-1,-1) + r0.yzw;
        r0.xyz = r0.xxx * r0.yzw + float3(1,1,1);
        r23.xyz = r23.xyz * r0.xyz;
      }
    }
  }
  r12.xyz = r23.xyz + r12.xyz;
  r0.xyzw = u_modulate_color.xyzw * r12.xyzw;
  switch (r10.x) {
    case 24 :    r1.xyz = v9.xyz;
    break;
    case 25 :    r1.xyz = v10.xyz;
    break;
    default :
    r2.xyz = r0.xyz * v9.xyz + v10.xyz;
    r2.xyz = -r12.xyz * u_modulate_color.xyz + r2.xyz;
    r1.xyz = g_LightScatteringColor.www * r2.xyz + r0.xyz;
    break;
  }
  r0.x = floor(g_global_user_param_3.y);
  r0.x = (uint)r0.x;
  r2.yz = v0.xy * u_screen_info.zw + -g_global_user_param_2.zw;
  r2.x = g_global_user_param_2.y * r2.y;
  r0.y = dot(r2.xz, r2.xz);
  r0.y = sqrt(r0.y);
  r0.z = dot(r1.xyz, float3(0.212500006,0.715399981,0.0720999986));
  r2.xyz = r0.zzz + -r1.xyz;
  r2.xyz = g_global_user_param_3.xxx * r2.xyz + r1.xyz;
  r0.z = max(r1.y, r1.z);
  r0.z = max(r1.x, r0.z);
  r3.xyz = r0.zzz + -r1.xyz;
  r3.xyz = r3.xyz + -r1.xyz;
  r3.xyz = g_global_user_param_3.xxx * r3.xyz + r1.xyz;
  r4.xy = cmp((int2)r0.xx == int2(1,2));
  r4.yzw = r4.yyy ? r2.xyz : r1.xyz;
  r3.xyz = r4.xxx ? r3.xyz : r4.yzw;
  r2.xyz = r0.xxx ? r3.xyz : r2.xyz;
  r0.x = cmp(g_global_user_param_2.x < r0.y);
  r0.xyz = r0.xxx ? r1.xyz : r2.xyz;
  r1.xyz = u_fog_param_0.xyz * u_fog_param_0.www;
  r1.w = cmp(0.00100000005 < u_fog_param_2.x);
  if (r1.w != 0) {
    r1.w = saturate(u_fog_param_2.y);
    r1.w = sqrt(r1.w);
    r1.w = 6 * r1.w;
    r2.xyz = float3(-1,-1,1) * r8.xyz;
    r2.xyz = s_IBL_NedSmpignorenametexture.SampleLevel(s_IBL_sampler_s, r2.xyz, r1.w).xyz;
    r2.xyz = -u_fog_param_0.xyz * u_fog_param_0.www + r2.xyz;
    r1.xyz = u_fog_param_2.xxx * r2.xyz + r1.xyz;
  }
  r1.w = view_matrix._m12 * v5.w;
  r1.w = v4.w * view_matrix._m02 + r1.w;
  r1.w = v6.w * view_matrix._m22 + r1.w;
  r1.w = view_matrix._m32 + r1.w;
  r2.x = -u_fog_param_1.x + -r1.w;
  r2.y = u_fog_param_1.y + -u_fog_param_1.x;
  r2.z = u_fog_param_1.z * r2.y;
  r2.x = min(r2.x, r2.z);
  r2.x = saturate(r2.x / r2.y);
  r2.x = u_enable_fog_d ? r2.x : 0;
  r1.w = -u_fog_param_3.z + -r1.w;
  r2.yz = u_fog_param_3.wy + -u_fog_param_3.zx;
  r1.w = saturate(r1.w / r2.y);
  r2.y = -u_fog_param_3.x + v5.w;
  r2.y = saturate(r2.y / r2.z);
  r2.y = 1 + -r2.y;
  r1.w = r2.y * r1.w;
  r1.w = u_fog_param_1.w * r1.w;
  r2.y = 1 + -r2.x;
  r1.w = r2.y * r1.w + r2.x;
  r1.w = u_enable_fog_d ? r1.w : r2.x;
  r1.xyz *= 1.f - saturate(shader_injection.fx_fog_light_reduction);
  r1.w *= 1.f - saturate(shader_injection.fx_fog_coverage_reduction);
  r1.xyz = r1.xyz + -r0.xyz;
  o0.xyz = r1.www * r1.xyz + r0.xyz;
  o0.w = r0.w;
  return;
}
