#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Wed Nov 18 20:52:21 2026

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

cbuffer cb_shlightfield_probes : register(b6)
{
  float4 shlightfield_param : packoffset(c0);
  float4 shlightfield_multiply_color_up : packoffset(c1);
  float4 shlightfield_multiply_color_down : packoffset(c2);
  float4 shlightfield_probes_SHLightFieldProbe[27] : packoffset(c3);
  float4 shlightfield_probe_SHLightFieldProbe_end : packoffset(c256);
}

cbuffer cbMaterialImmutable : register(b1)
{
  float4 TexcoordIndex_diffuse : packoffset(c0);
  float4 TexcoordMtx_diffuse[2] : packoffset(c1);
  float4 TexcoordIndex_specular : packoffset(c3);
  float4 TexcoordMtx_specular[2] : packoffset(c4);
  float4 TexcoordIndex_normal : packoffset(c6);
  float4 TexcoordMtx_normal[2] : packoffset(c7);
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
SamplerState s_EnvBRDF_sampler_s : register(s3);
SamplerState s_IBL_sampler_s : register(s4);
SamplerState s_ShadowMap_sampler_s : register(s5);
SamplerState s_SHLightField0_sampler_s : register(s6);
SamplerState s_SHLightField1_sampler_s : register(s7);
SamplerState s_SHLightField2_sampler_s : register(s8);
SamplerState s_IBLProbeArray_sampler_s : register(s9);
SamplerState s_VolShadow_sampler_s : register(s11);
SamplerState s_Luminance_sampler_s : register(s12);
SamplerComparisonState s_LocalShadowMap_sampler_s : register(s10);
Texture2D<float4> diffuse_NedSmpignorenametexture : register(t0);
Texture2D<float4> normal_NedSmpignorenametexture : register(t1);
Texture2D<float4> specular_NedSmpignorenametexture : register(t2);
Texture2D<float4> s_EnvBRDF_NedSmpignorenametexture : register(t3);
TextureCube<float4> s_IBL_NedSmpignorenametexture : register(t4);
Texture2DArray<float4> s_ShadowMap : register(t5);
Texture3D<float4> s_SHLightField0_NedSmpignorenametexture : register(t6);
Texture3D<float4> s_SHLightField1_NedSmpignorenametexture : register(t7);
Texture3D<float4> s_SHLightField2_NedSmpignorenametexture : register(t8);
StructuredBuffer<uint> s_LocalLightIndexData : register(t9);
TextureCubeArray<float4> s_IBLProbeArray : register(t10);
TextureCubeArray<float4> s_LocalShadowMap : register(t11);
Texture3D<float4> s_VolShadow : register(t12);
Texture2D<float4> s_Luminance_NedSmpignorenametexture : register(t13);


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
  float4 x1[9];
  float4 x2[5];
  float4 x3[5];
  float4 x4[5];
  r0.xyzw = TexcoordMtx_diffuse[0].xyzw * v2.xxyy;
  r0.xy = r0.xy + r0.zw;
  r0.xy = TexcoordMtx_diffuse[1].xy + r0.xy;
  r0.xyzw = diffuse_NedSmpignorenametexture.SampleBias(diffuse_sampler_s, r0.xy, global_mip_bias.x).xyzw;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.x = cmp(0 < u_vat_type.x);
  r1.yzw = v1.xyz * r0.xyz;
  r0.xyz = r1.xxx ? r0.xyz : r1.yzw;
  r1.w = v1.w * r0.w;
  r0.w = dot(v4.xyz, v4.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = v4.xyz * r0.www;
  r0.w = dot(v5.xyz, v5.xyz);
  r0.w = rsqrt(r0.w);
  r3.xyz = v5.xyz * r0.www;
  r4.xyz = r3.yzx * r2.zxy;
  r4.xyz = r2.yzx * r3.zxy + -r4.xyz;
  r4.xyz = v7.xxx * r4.xyz;
  r0.w = dot(r4.xyz, r4.xyz);
  r0.w = rsqrt(r0.w);
  r4.xyz = r4.xyz * r0.www;
  r5.xyzw = TexcoordMtx_normal[0].xyzw * v3.xxyy;
  r5.xy = r5.xy + r5.zw;
  r5.xy = TexcoordMtx_normal[1].xy + r5.xy;
  r5.xy = normal_NedSmpignorenametexture.SampleBias(normal_sampler_s, r5.xy, global_mip_bias.x).xy;
  r5.xy = r5.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r5.xy, r5.xy);
  r0.w = min(1, r0.w);
  r0.w = 1 + -r0.w;
  r0.w = sqrt(r0.w);
  r4.xyz = r5.yyy * r4.xyz;
  r3.xyz = r5.xxx * r3.xyz + r4.xyz;
  r3.xyz = r0.www * r2.xyz + r3.xyz;
  r0.w = dot(r3.xyz, r3.xyz);
  r0.w = rsqrt(r0.w);
  r3.xyz = r3.xyz * r0.www;
  r4.xyz = cmp(r3.xyz != r3.xyz);
  r0.w = (int)r4.y | (int)r4.x;
  r0.w = (int)r4.z | (int)r0.w;
  r3.xyz = r0.www ? r2.xyz : r3.xyz;
  r4.xyzw = TexcoordMtx_specular[0].xyzw * v2.xxyy;
  r4.xy = r4.xy + r4.zw;
  r4.xy = TexcoordMtx_specular[1].xy + r4.xy;
  r4.xyzw = specular_NedSmpignorenametexture.SampleBias(specular_sampler_s, r4.xy, global_mip_bias.x).wxyz;
  r5.xy = float2(1,1) + -r4.zw;
  r6.y = max(0.00999999978, r5.x);
  r0.w = 0.25 * r4.y;
  r5.xzw = -r4.yyy * float3(0.25,0.25,0.25) + r0.xyz;
  r5.xzw = r4.www * r5.xzw + r0.www;
  r4.yz = u_screen_info.zw * v0.xy;
  r4.yz = u_screen_info.xy * r4.yz;
  r4.yz = (uint2)r4.yz;
  r7.xy = (uint2)r4.yz >> int2(4,4);
  r8.x = v4.w;
  r8.y = v5.w;
  r8.z = v6.w;
  r9.xyz = u_cameraPosition.xyz + -r8.xyz;
  r0.w = dot(r9.xyz, r9.xyz);
  r0.w = rsqrt(r0.w);
  r10.xyz = r9.xyz * r0.www;
  r7.zw = round(g_debug_option.xy);
  r7.zw = (int2)r7.zw;
  switch (r7.z) {
    case 6 :    r3.xyz = r2.xyz;
    break;
    case 8 :    r0.xyz = float3(1,1,1);
    break;
    case 9 :    r0.xyz = float3(1,1,1);
    r4.x = 1;
    break;
    default :
    break;
  }
  r2.xyz = r4.xxx;
  if (enable_shadow_map != 0) {
    r11.xyzw = cmp(shadow_cascade_frustums_eye_space_depth.xyzw < w7);
    r11.xyzw = r11.xyzw ? float4(1,1,1,1) : 0;
    r2.w = dot(float4(1,1,1,1), r11.xyzw);
    r4.x = (int)shadow_map_parameter[0].y;
    r6.w = cmp(0 < (int)r4.x);
    r6.w = r6.w ? 0 : 4;
    r11.z = r6.w + r2.w;
    r2.w = (int)r11.z;
    r6.w = cmp((int)r2.w >= (int)r4.x);
    if (r6.w != 0) {
      r6.w = shadow_map_parameter[1].y;
    } else {
      r9.w = (int)r2.w + 1;
      r4.x = (int)r4.x + -1;
      r9.w = min((int)r9.w, (int)r4.x);
      r10.w = cmp(shadow_map_parameter[1].z == 0.000000);
      if (r10.w != 0) {
        r10.w = 0;
      } else {
        r12.x = dot(shadow_cascade_frustums_eye_space_depth.xyzw, icb[r2.w+0].xyzw);
        r12.x = -w7 + r12.x;
        r12.x = saturate(shadow_map_parameter[1].z * r12.x);
        r10.w = 1 + -r12.x;
      }
      x0[0].x = 1;
      x0[1].x = 1;
      r12.x = cmp(0 < shadow_parallax_correct_param[0].w);
      if (r12.x != 0) {
        r12.yzw = v8.xyz;
        r13.xyz = float3(0,0,0);
        while (true) {
          r13.w = cmp((int)r13.z >= 16);
          if (r13.w != 0) break;
          r11.xyw = r12.yzw * shadow_cascade_scale[r2.w].xyz + shadow_cascade_offset[r2.w].xyz;
          r13.w = s_ShadowMap.SampleLevel(s_ShadowMap_sampler_s, r11.xyz, 0).x;
          r14.x = cmp(r11.w < r13.w);
          r11.w = -r13.w + r11.w;
          r15.x = r13.x + abs(r11.w);
          r15.y = 1 + r13.y;
          r13.xy = r14.xx ? r15.xy : r13.xy;
          r12.yzw = shadow_parallax_correct_param[r2.w].xyz + r12.yzw;
          r13.z = (int)r13.z + 1;
        }
        r11.w = cmp(0 < r13.y);
        r12.y = rcp(r13.y);
        r12.y = r13.x * r12.y;
        r11.w = r11.w ? r12.y : 0;
        r12.yzw = r11.www * shadow_parallax_correct_param[r2.w].xyz + v8.xyz;
        r12.yzw = r12.yzw * shadow_cascade_scale[r2.w].xyz + shadow_cascade_offset[r2.w].xyz;
      } else {
        r12.yzw = v8.xyz * shadow_cascade_scale[r2.w].xyz + shadow_cascade_offset[r2.w].xyz;
      }
      r13.xy = cmp(r12.yz >= float2(0,0));
      r13.zw = cmp(r12.yz < float2(1,1));
      r11.w = r13.z ? r13.x : 0;
      r11.w = r13.y ? r11.w : 0;
      r11.w = r13.w ? r11.w : 0;
      r13.x = cmp(r12.w >= 0);
      r11.w = r11.w ? r13.x : 0;
      r13.x = cmp(r12.w < 1);
      r11.w = r11.w ? r13.x : 0;
      if (r11.w != 0) {
        r11.w = dot(shadow_cascade_transition_scale.xyzw, icb[r2.w+0].xyzw);
        r12.yz = r12.yz * shadow_map_size.xy + float2(-0.5,-0.5);
        r13.xy = frac(r12.yz);
        r12.yz = floor(r12.yz);
        r12.yz = float2(0.5,0.5) + r12.yz;
        r11.xy = shadow_map_size.zw * r12.yz;
        r14.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r11.xyz, int2(-1, -1)).xyzw;
        r14.xyzw = r14.xyzw + -r12.wwww;
        r14.xyzw = saturate(r14.xyzw * r11.wwww + shadow_map_parameter[0].xxxx);
        r15.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r11.xyz, int2(1, -1)).xyzw;
        r15.xyzw = r15.xyzw + -r12.wwww;
        r15.xyzw = saturate(r15.xyzw * r11.wwww + shadow_map_parameter[0].xxxx);
        r16.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r11.xyz, int2(-1, 1)).xyzw;
        r16.xyzw = r16.xyzw + -r12.wwww;
        r16.xyzw = saturate(r16.xyzw * r11.wwww + shadow_map_parameter[0].xxxx);
        r17.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r11.xyz, int2(1, 1)).xyzw;
        r17.xyzw = r17.xyzw + -r12.wwww;
        r11.xyzw = saturate(r17.xyzw * r11.wwww + shadow_map_parameter[0].xxxx);
        r12.y = 1 + -r13.x;
        r12.zw = r14.wx * r12.yy + r14.zy;
        r14.xy = r16.wx * r12.yy + r16.zy;
        r12.yz = r12.zw + r15.wx;
        r11.xw = r14.xy + r11.wx;
        r14.xy = r15.zy * r13.xx + r12.yz;
        r14.zw = r11.zy * r13.xx + r11.xw;
        r13.z = 1 + -r13.y;
        r13.w = 1;
        r11.x = dot(r14.wxzy, r13.yzww);
        r11.x = 0.111111112 * r11.x;
        r11.x = min(1, r11.x);
        x0[0].x = r11.x;
      }
      r11.x = cmp(0 >= r10.w);
      r11.y = cmp(0.999998987 < r10.w);
      r11.x = (int)r11.y | (int)r11.x;
      r2.w = cmp((int)r2.w == (int)r9.w);
      r2.w = (int)r2.w | (int)r11.x;
      if (r2.w == 0) {
        if (r12.x != 0) {
          r11.w = (int)r9.w;
          r12.xyz = v8.xyz;
          r13.xy = float2(0,0);
          r2.w = 0;
          while (true) {
            r12.w = cmp((int)r2.w >= 16);
            if (r12.w != 0) break;
            r11.xyz = r12.xyz * shadow_cascade_scale[r9.w].xyz + shadow_cascade_offset[r9.w].xyz;
            r11.x = s_ShadowMap.SampleLevel(s_ShadowMap_sampler_s, r11.xyw, 0).x;
            r11.y = cmp(r11.z < r11.x);
            r11.x = r11.z + -r11.x;
            r14.x = r13.x + abs(r11.x);
            r14.y = 1 + r13.y;
            r13.xy = r11.yy ? r14.xy : r13.xy;
            r12.xyz = shadow_parallax_correct_param[r9.w].xyz + r12.xyz;
            r2.w = (int)r2.w + 1;
          }
          r2.w = cmp(0 < r13.y);
          r11.x = rcp(r13.y);
          r11.x = r13.x * r11.x;
          r2.w = r2.w ? r11.x : 0;
          r11.xyz = r2.www * shadow_parallax_correct_param[r9.w].xyz + v8.xyz;
          r11.xyz = r11.xyz * shadow_cascade_scale[r9.w].xyz + shadow_cascade_offset[r9.w].xyz;
        } else {
          r11.xyz = v8.xyz * shadow_cascade_scale[r9.w].xyz + shadow_cascade_offset[r9.w].xyz;
        }
        r12.xy = cmp(r11.xy >= float2(0,0));
        r12.zw = cmp(r11.xy < float2(1,1));
        r2.w = r12.z ? r12.x : 0;
        r2.w = r12.y ? r2.w : 0;
        r2.w = r12.w ? r2.w : 0;
        r11.w = cmp(r11.z >= 0);
        r2.w = r2.w ? r11.w : 0;
        r11.w = cmp(r11.z < 1);
        r2.w = r2.w ? r11.w : 0;
        if (r2.w != 0) {
          r12.z = (int)r9.w;
          r2.w = dot(shadow_cascade_transition_scale.xyzw, icb[r9.w+0].xyzw);
          r11.xy = r11.xy * shadow_map_size.xy + float2(-0.5,-0.5);
          r13.xy = frac(r11.xy);
          r11.xy = floor(r11.xy);
          r11.xy = float2(0.5,0.5) + r11.xy;
          r12.xy = shadow_map_size.zw * r11.xy;
          r14.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r12.xyz, int2(-1, -1)).xyzw;
          r14.xyzw = r14.xyzw + -r11.zzzz;
          r14.xyzw = saturate(r14.xyzw * r2.wwww + shadow_map_parameter[0].xxxx);
          r15.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r12.xyz, int2(1, -1)).xyzw;
          r15.xyzw = r15.xyzw + -r11.zzzz;
          r15.xyzw = saturate(r15.xyzw * r2.wwww + shadow_map_parameter[0].xxxx);
          r16.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r12.xyz, int2(-1, 1)).xyzw;
          r16.xyzw = r16.xyzw + -r11.zzzz;
          r16.xyzw = saturate(r16.xyzw * r2.wwww + shadow_map_parameter[0].xxxx);
          r12.xyzw = s_ShadowMap.Gather(s_ShadowMap_sampler_s, r12.xyz, int2(1, 1)).xyzw;
          r11.xyzw = r12.xyzw + -r11.zzzz;
          r11.xyzw = saturate(r11.xyzw * r2.wwww + shadow_map_parameter[0].xxxx);
          r2.w = 1 + -r13.x;
          r12.xy = r14.wx * r2.ww + r14.zy;
          r12.zw = r16.wx * r2.ww + r16.zy;
          r12.xy = r12.xy + r15.wx;
          r11.xw = r12.zw + r11.wx;
          r12.xy = r15.zy * r13.xx + r12.xy;
          r12.zw = r11.zy * r13.xx + r11.xw;
          r13.z = 1 + -r13.y;
          r13.w = 1;
          r2.w = dot(r12.wxzy, r13.yzww);
          r2.w = 0.111111112 * r2.w;
          r2.w = min(1, r2.w);
          x0[1].x = r2.w;
        }
      }
      r2.w = dot(shadow_cascade_frustums_eye_space_depth.xyzw, icb[r4.x+0].xyzw);
      r2.w = -w7 + r2.w;
      r2.w = saturate(shadow_map_parameter[1].x * r2.w);
      r4.x = x0[0].x;
      r9.w = x0[1].x;
      r9.w = r9.w + -r4.x;
      r4.x = r10.w * r9.w + r4.x;
      r4.x = -shadow_map_parameter[1].y + r4.x;
      r2.w = r2.w * r4.x + shadow_map_parameter[1].y;
      r4.x = shadow_map_parameter[1].y + -r2.w;
      r6.w = shadow_map_parameter[1].w * r4.x + r2.w;
    }
  } else {
    r6.w = 1;
  }
  if (enable_ibl_plus_directional_specular != 0) {
    r11.xyz = -u_cameraPosition.xyz + r8.xyz;
    r2.w = dot(r11.xyz, r11.xyz);
    r2.w = sqrt(r2.w);
    r11.xyzw = cmp(u_vol_shadow_param[4].xyzw < r2.wwww);
    r11.xyzw = r11.xyzw ? float4(1,1,1,1) : 0;
    r4.x = dot(float4(1,1,1,1), r11.xyzw);
    r9.w = (int)r4.x;
    r11.xyz = -u_vol_shadow_param[r9.w].xyz + r8.xyz;
    r12.xyz = u_vol_shadow_param[r9.w].www * r11.xyz;
    r12.xyz = cmp(abs(r12.xyz) < float3(0.479999989,0.479999989,0.479999989));
    r10.w = r12.y ? r12.x : 0;
    r10.w = r12.z ? r10.w : 0;
    if (r10.w != 0) {
      r11.xyz = r11.xyz * u_vol_shadow_param[r9.w].www + float3(0.5,0.5,0.5);
      r4.x = 0.25 * r4.x;
      r11.w = r11.z * 0.25 + r4.x;
      r4.x = s_VolShadow.SampleLevel(s_VolShadow_sampler_s, r11.xyw, 0).x;
    } else {
      r4.x = 1;
    }
    r10.w = (int)r9.w + 1;
    r11.x = cmp((int)r10.w < 4);
    if (r11.x != 0) {
      r11.xyz = -u_vol_shadow_param[r9.w+1].xyz + r8.xyz;
      r12.xyz = u_vol_shadow_param[r9.w+1].www * r11.xyz;
      r12.xyz = cmp(abs(r12.xyz) < float3(0.479999989,0.479999989,0.479999989));
      r11.w = r12.y ? r12.x : 0;
      r11.w = r12.z ? r11.w : 0;
      if (r11.w != 0) {
        r11.xyz = r11.xyz * u_vol_shadow_param[r9.w+1].www + float3(0.5,0.5,0.5);
        r12.x = (int)r10.w;
        r12.x = 0.25 * r12.x;
        r11.w = r11.z * 0.25 + r12.x;
        r11.x = s_VolShadow.SampleLevel(s_VolShadow_sampler_s, r11.xyw, 0).x;
        r9.w = dot(u_vol_shadow_param[4].xyzw, icb[r9.w+0].xyzw);
        r11.y = 0.5 * r9.w;
        r9.w = -r9.w * 0.5 + r2.w;
        r11.y = 1 / r11.y;
        r9.w = saturate(r11.y * r9.w);
        r11.y = r9.w * -2 + 3;
        r9.w = r9.w * r9.w;
        r9.w = r11.y * r9.w;
        r11.x = r11.x + -r4.x;
        r4.x = r9.w * r11.x + r4.x;
      }
    }
    r9.w = cmp((int)r10.w >= 4);
    r10.w = u_vol_shadow_param[4].w * 0.199999988;
    r2.w = -u_vol_shadow_param[4].w * 0.800000012 + r2.w;
    r10.w = 1 / r10.w;
    r2.w = saturate(r10.w * r2.w);
    r10.w = r2.w * -2 + 3;
    r2.w = r2.w * r2.w;
    r2.w = r10.w * r2.w;
    r10.w = 1 + -r4.x;
    r2.w = r2.w * r10.w + r4.x;
    r2.w = r9.w ? r2.w : r4.x;
    r6.w = min(r6.w, r2.w);
  }
  r2.w = saturate(dot(r3.xyz, u_lightDirection.xyz));
  r9.xyz = r9.xyz * r0.www + u_lightDirection.xyz;
  r0.w = dot(r9.xyz, r9.xyz);
  r0.w = rsqrt(r0.w);
  r9.xyz = r9.xyz * r0.www;
  r0.w = saturate(dot(r5.xzw, float3(16.5,16.5,16.5)));
  r4.x = saturate(dot(r9.xyz, u_lightDirection.xyz));
  r11.xyz = r0.www + -r5.xzw;
  r0.w = 1 + -r4.x;
  r4.x = r0.w * r0.w;
  r4.x = r4.x * r4.x;
  r0.w = r4.x * r0.w;
  r12.xyz = r11.xyz * r0.www + r5.xzw;
  r13.xyz = u_lightColor.xyz * r2.www;
  r0.w = 1 + -r12.x;
  r0.w = r0.w * r5.y;
  r13.xyz = r13.xyz * r0.www;
  r6.x = saturate(dot(r3.xyz, r10.xyz));
  r0.w = saturate(dot(r3.xyz, r9.xyz));
  r4.x = -r0.w * r0.w + 1;
  r0.w = r0.w * r6.y;
  r0.w = r0.w * r0.w + r4.x;
  r0.w = r6.y / r0.w;
  r0.w = r0.w * r0.w;
  r0.w = 0.318309873 * r0.w;
  r4.x = 1 + r6.y;
  r4.x = r4.x * r4.x;
  r9.x = 0.125 * r4.x;
  r4.x = -r4.x * 0.125 + 1;
  r9.y = r2.w * r4.x + r9.x;
  r9.z = r6.x * r4.x + r9.x;
  r9.y = r9.y * r9.z;
  r9.y = 0.25 / r9.y;
  r0.w = r9.y * r0.w;
  r12.xyz = saturate(r0.www * r12.xyz);
  r12.xyz = r12.xyz * r2.www;
  r12.xyz = u_lightColor.xyz * r12.xyz;
  r12.xyz = enable_ibl_plus_directional_specular ? r12.xyz : float3(0,0,0);
  r0.w = (uint)g_local_light_count.x;
  if (r0.w != 0) {
    r9.yw = (int2)u_tile_info.zw;
    r9.yw = (int2)r9.yw + int2(15,15);
    r9.yw = (uint2)r9.yw >> int2(4,4);
    r9.yw = cmp((int2)r7.xy < (int2)r9.yw);
    r0.w = r9.w ? r9.y : 0;
    r9.yw = (uint2)u_tile_info.xy;
    r2.w = mad((int)r7.y, (int)r9.y, (int)r7.x);
    r2.w = (int)r2.w * 3;
    r9.y = s_LocalLightIndexData[r2.w].x;
    r9.y = (uint)r9.y >> 16;
    r14.x = min(64, (uint)r9.y);
    r2.w = (uint)r2.w << 6;
    r14.y = (int)r2.w + (int)r9.w;
    r14.z = 16;
    r14.xyz = (int3)r0.www & (int3)r14.xyz;
    if (2 == 0) r0.w = 0; else if (2+4 < 32) {     r0.w = (uint)u_shading_model_flag.x << (32-(2 + 4)); r0.w = (uint)r0.w >> (32-2);    } else r0.w = (uint)u_shading_model_flag.x >> 4;
    r0.w = 1 << (int)r0.w;
    r15.y = 1;
    r16.xyz = float3(0,0,0);
    r17.xyz = float3(0,0,0);
    r2.w = 0;
    while (true) {
      r9.y = cmp((uint)r2.w >= (uint)r14.x);
      if (r9.y != 0) break;
      r9.y = (int)r2.w + (int)r14.y;
      r9.y = s_LocalLightIndexData[r9.y].x;
      r9.y = (uint)r9.y >> (uint)r14.z;
      bitmask.y = ((~(-1 << 16)) << 2) & 0xffffffff;  r9.y = (((uint)r9.y << 2) & bitmask.y) | ((uint)0 & ~bitmask.y);
      r9.w = (int)r0.w & (int4)g_local_light_data[r9.y/4]._m33;
      if (3 == 0) r10.w = 0; else if (3+16 < 32) {       r10.w = (uint)g_local_light_data[r9.y/4]._m33 << (32-(3 + 16)); r10.w = (uint)r10.w >> (32-3);      } else r10.w = (uint)g_local_light_data[r9.y/4]._m33 >> 16;
      r10.w = (int)r10.w + -1;
      r11.w = cmp((int)r10.w >= 0);
      r12.w = cmp(0.00999999978 < abs(g_local_light_shadow_param[r10.w].w));
      r11.w = r11.w ? r12.w : 0;
      if (r11.w == 0) {
        r11.w = 1;
      } else {
        r12.w = cmp(g_local_light_shadow_param[r10.w].w < 0);
        r18.xyz = -g_local_light_shadow_param[r10.w].xyz + r8.xyz;
        r13.w = dot(r18.xyz, r18.xyz);
        r15.x = sqrt(r13.w);
        if (r12.w != 0) {
          r12.w = (uint)r10.w << 2;
          r19.xyzw = g_local_light_shadow_matrix[r12.w/4]._m10_m11_m12_m13 * v5.wwww;
          r19.xyzw = v4.wwww * g_local_light_shadow_matrix[r12.w/4]._m00_m01_m02_m03 + r19.xyzw;
          r19.xyzw = v6.wwww * g_local_light_shadow_matrix[r12.w/4]._m20_m21_m22_m23 + r19.xyzw;
          r19.xyzw = g_local_light_shadow_matrix[r12.w/4]._m30_m31_m32_m33 + r19.xyzw;
          r19.xyz = r19.zxy / r19.www;
          r15.zw = float2(1,-1) * r19.zy;
          r12.w = dot(r15.yzw, r15.yzw);
          r12.w = rsqrt(r12.w);
          r19.yzw = r15.xzw * r12.www;
          r18.xyz = r19.yzw * r15.yxx;
          r15.zw = r18.yz;
        } else {
          r12.w = (uint)r10.w << 2;
          r13.w = max(abs(r18.y), abs(r18.z));
          r13.w = max(abs(r18.x), r13.w);
          r19.yz = g_local_light_shadow_matrix[r12.w/4]._m22_m23 * -r13.ww + g_local_light_shadow_matrix[r12.w/4]._m32_m33;
          r19.x = r19.y / r19.z;
          r15.zw = r18.yz;
        }
        r20.w = (int)r10.w;
        r12.w = -0.00100000005 + r19.x;
        r13.w = 0;
        r14.w = 0;
        while (true) {
          r16.w = cmp((int)r14.w >= 5);
          if (r16.w != 0) break;
          r18.zw = icb[r14.w+3].xy * float2(0.00200000009,0.00200000009);
          sincos(r18.z, r19.x, r21.x);
          sincos(r18.w, r22.x, r23.x);
          r24.xz = sin(-r18.zw);
          r24.y = r21.x;
          r20.y = dot(r24.yx, r15.zw);
          r24.w = r19.x;
          r18.y = dot(r24.wy, r15.zw);
          r24.x = r23.x;
          r24.y = r22.x;
          r20.x = dot(r24.xy, r18.xy);
          r20.z = dot(r24.zx, r18.xy);
          r16.w = s_LocalShadowMap.SampleCmpLevelZero(s_LocalShadowMap_sampler_s, r20.xyzw, r12.w).x;
          r13.w = r16.w + r13.w;
          r14.w = (int)r14.w + 1;
        }
        r12.w = -1 + r15.x;
        r12.w = saturate(-2.50000024 * r12.w);
        r14.w = r12.w * -2 + 3;
        r12.w = r12.w * r12.w;
        r12.w = r14.w * r12.w;
        r12.w = r13.w * 0.200000003 + r12.w;
        r12.w = min(1, r12.w);
        r12.w = -1 + r12.w;
        r11.w = abs(g_local_light_shadow_param[r10.w].w) * r12.w + 1;
      }
      if (r9.w != 0) {
        r15.xzw = g_local_light_data[r9.y/4]._m10_m11_m12 + -r8.xyz;
        r9.w = dot(r15.xzw, r15.xzw);
        r10.w = cmp(g_local_light_data[r9.y/4]._m13 < r9.w);
        r12.w = g_local_light_data[r9.y/4]._m00 + g_local_light_data[r9.y/4]._m01;
        r12.w = g_local_light_data[r9.y/4]._m02 + r12.w;
        r12.w = cmp(abs(r12.w) < 9.99999997e-007);
        r10.w = (int)r10.w | (int)r12.w;
        if (r10.w == 0) {
          r10.w = 256 & (int4)g_local_light_data[r9.y/4]._m33;
          r12.w = rsqrt(r9.w);
          r18.xyz = r15.xzw * r12.www;
          r14.w = dot(g_local_light_data[r9.y/4]._m20_m21_m22, -r18.xyz);
          r14.w = -g_local_light_data[r9.y/4]._m30 + r14.w;
          r14.w = saturate(g_local_light_data[r9.y/4]._m31 * r14.w);
          r14.w = r14.w * r14.w;
          r16.w = cmp(r14.w >= 9.99999997e-007);
          r16.w = r10.w ? r16.w : -1;
          if (r16.w != 0) {
            r19.xy = int2(16,32) & (int)g_local_light_data[r9.y/4]._m33;
            r16.w = r9.w / g_local_light_data[r9.y/4]._m13;
            r16.w = -r16.w * r16.w + 1;
            r16.w = max(0, r16.w);
            r16.w = r16.w * r16.w;
            r20.xyz = g_local_light_data[r9.y/4]._m00_m01_m02 * float3(0.0795774683,0.0795774683,0.0795774683);
            r9.y = r10.w ? r14.w : 1;
            r9.w = max(1, r9.w);
            r9.w = rcp(r9.w);
            r10.w = saturate(dot(r3.xyz, r18.xyz));
            r15.xzw = r15.xzw * r12.www + r10.xyz;
            r12.w = dot(r15.xzw, r15.xzw);
            r12.w = rsqrt(r12.w);
            r15.xzw = r15.xzw * r12.www;
            r12.w = saturate(dot(r15.xzw, r18.xyz));
            r12.w = 1 + -r12.w;
            r14.w = r12.w * r12.w;
            r14.w = r14.w * r14.w;
            r12.w = r14.w * r12.w;
            r18.xyz = r11.xyz * r12.www + r5.xzw;
            r9.w = r9.w * r16.w;
            r9.y = r9.w * r9.y;
            if (r19.y != 0) {
              r9.w = r11.w * r9.y;
              r12.w = saturate(dot(r3.xyz, r15.xzw));
              r14.w = -r12.w * r12.w + 1;
              r12.w = r12.w * r6.y;
              r12.w = r12.w * r12.w + r14.w;
              r12.w = r6.y / r12.w;
              r12.w = r12.w * r12.w;
              r12.w = 0.318309873 * r12.w;
              r14.w = r10.w * r4.x + r9.x;
              r14.w = r14.w * r9.z;
              r14.w = 0.25 / r14.w;
              r12.w = r14.w * r12.w;
              r15.xzw = saturate(r12.www * r18.xyz);
              r15.xzw = r15.xzw * r10.www;
              r15.xzw = r15.xzw * r20.xyz;
              r17.xyz = r9.www * r15.xzw + r17.xyz;
            }
            if (r19.x != 0) {
              r9.y = r11.w * r9.y;
              r15.xzw = r10.www * r20.xyz;
              r9.w = 1 + -r18.x;
              r9.w = r9.w * r5.y;
              r15.xzw = r15.xzw * r9.www;
              r16.xyz = r9.yyy * r15.xzw + r16.xyz;
            }
          }
        }
      }
      r2.w = (int)r2.w + 1;
    }
  } else {
    r16.xyz = float3(0,0,0);
    r17.xyz = float3(0,0,0);
  }
  r0.w = 0;
  r9.xy = float2(-1,0);
  r11.y = 0;
  r2.w = 0;
  while (true) {
    r4.x = cmp((int)r11.y >= 3);
    r2.w = 0;
    if (r4.x != 0) break;
    r14.xyzw = mad((int4)r11.yyyy, int4(9,9,9,9), int4(5,6,7,8));
    r15.xyz = shlightfield_probes_SHLightFieldProbe[r14.y].xyz * v5.www;
    r15.xyz = v4.www * shlightfield_probes_SHLightFieldProbe[r14.x].xyz + r15.xyz;
    r14.xyz = v6.www * shlightfield_probes_SHLightFieldProbe[r14.z].xyz + r15.xyz;
    r14.xyz = shlightfield_probes_SHLightFieldProbe[r14.w].xyz + r14.xyz;
    r15.xyz = cmp(float3(0.5,0.5,0.5) >= abs(r14.xyz));
    r4.x = r15.y ? r15.x : 0;
    r4.x = r15.z ? r4.x : 0;
    if (r4.x != 0) {
      r0.w = r11.y;
      r2.w = -1;
      break;
    }
    r11.x = dot(abs(r14.xyz), abs(r14.xyz));
    r9.z = cmp(r9.x < 0);
    r9.w = cmp(r11.x < r9.x);
    r9.z = (int)r9.w | (int)r9.z;
    r9.xy = r9.zz ? r11.xy : r9.xy;
    r11.y = (int)r11.y + 1;
    r2.w = r4.x;
    r0.w = 0;
  }
  r0.w = r2.w ? r0.w : r9.y;
  r2.w = (int)r0.w * 9;
  r9.xyzw = mad((int4)r0.wwww, int4(9,9,9,9), int4(5,6,7,8));
  r11.xyz = shlightfield_probes_SHLightFieldProbe[r9.y].xyz * v5.www;
  r11.xyz = v4.www * shlightfield_probes_SHLightFieldProbe[r9.x].xyz + r11.xyz;
  r11.xyz = v6.www * shlightfield_probes_SHLightFieldProbe[r9.z].xyz + r11.xyz;
  r11.xyz = shlightfield_probes_SHLightFieldProbe[r9.w].xyz + r11.xyz;
  r14.xyz = saturate(float3(0.5,0.5,0.5) + r11.xyz);
  r15.xyz = shlightfield_probes_SHLightFieldProbe[r9.y].xyz * r3.yyy;
  r9.xyw = r3.xxx * shlightfield_probes_SHLightFieldProbe[r9.x].xyz + r15.xyz;
  r9.xyz = r3.zzz * shlightfield_probes_SHLightFieldProbe[r9.z].xyz + r9.xyw;
  r4.x = dot(r9.xyz, r9.xyz);
  r4.x = rsqrt(r4.x);
  r9.xyz = r9.xyz * r4.xxx;
  r9.xyz = shlightfield_param.zzz * r9.xyz;
  r9.xyz = r14.xyz * shlightfield_probes_SHLightFieldProbe[r2.w].xyz + r9.xyz;
  r9.xyz = r9.xyz / shlightfield_probes_SHLightFieldProbe[r2.w].xyz;
  r14.xyz = float3(1,1,1) / shlightfield_probes_SHLightFieldProbe[r2.w].xyz;
  r15.xyz = float3(0.5,0.5,0.5) * r14.xyz;
  r14.xyz = -r14.xyz * float3(0.5,0.5,0.5) + float3(1,1,1);
  r9.xyz = max(r15.xyz, r9.xyz);
  r9.xyz = min(r9.xyz, r14.xyz);
  x1[0].xyz = float3(0,0,0);
  x1[1].xyz = float3(0,0,0);
  x1[2].xyz = float3(0,0,0);
  x1[3].xyz = float3(0,0,0);
  x1[4].xyz = float3(0,0,0);
  x1[5].xyz = float3(0,0,0);
  if (r0.w == 0) {
    r9.w = 0.111111112 * r9.x;
    r14.xyz = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r9.wyz, 0).xyz;
    x1[0].xyz = r14.xyz;
    r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.111111112,0,0);
    r14.xyz = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r14.xyz, 0).xyz;
    x1[1].xyz = r14.xyz;
    r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.222222224,0,0);
    r14.xyz = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r14.xyz, 0).xyz;
    x1[2].xyz = r14.xyz;
    r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.333333343,0,0);
    r14.xyz = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r14.xyz, 0).xyz;
    x1[3].xyz = r14.xyz;
    r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.444444448,0,0);
    r14.xyz = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r14.xyz, 0).xyz;
    x1[4].xyz = r14.xyz;
    r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.555555582,0,0);
    r14.xyz = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r14.xyz, 0).xyz;
    x1[5].xyz = r14.xyz;
  } else {
    r2.w = cmp((int)r0.w == 1);
    if (r2.w != 0) {
      r14.xyz = float3(0.111111112,1,1) * r9.xyz;
      r14.xyz = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r14.xyz, 0).xyz;
      x1[0].xyz = r14.xyz;
      r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.111111112,0,0);
      r14.xyz = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r14.xyz, 0).xyz;
      x1[1].xyz = r14.xyz;
      r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.222222224,0,0);
      r14.xyz = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r14.xyz, 0).xyz;
      x1[2].xyz = r14.xyz;
      r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.333333343,0,0);
      r14.xyz = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r14.xyz, 0).xyz;
      x1[3].xyz = r14.xyz;
      r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.444444448,0,0);
      r14.xyz = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r14.xyz, 0).xyz;
      x1[4].xyz = r14.xyz;
      r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.555555582,0,0);
      r14.xyz = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r14.xyz, 0).xyz;
      x1[5].xyz = r14.xyz;
    } else {
      r2.w = cmp((int)r0.w == 2);
      if (r2.w != 0) {
        r14.xyz = float3(0.111111112,1,1) * r9.xyz;
        r14.xyz = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r14.xyz, 0).xyz;
        x1[0].xyz = r14.xyz;
        r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.111111112,0,0);
        r14.xyz = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r14.xyz, 0).xyz;
        x1[1].xyz = r14.xyz;
        r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.222222224,0,0);
        r14.xyz = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r14.xyz, 0).xyz;
        x1[2].xyz = r14.xyz;
        r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.333333343,0,0);
        r14.xyz = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r14.xyz, 0).xyz;
        x1[3].xyz = r14.xyz;
        r14.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.444444448,0,0);
        r14.xyz = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r14.xyz, 0).xyz;
        x1[4].xyz = r14.xyz;
        r9.xyz = r9.xyz * float3(0.111111112,1,1) + float3(0.555555582,0,0);
        r9.xyz = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r9.xyz, 0).xyz;
        x1[5].xyz = r9.xyz;
      }
    }
  }
  r0.w = mad((int)r0.w, 9, 1);
  r0.w = shlightfield_probes_SHLightFieldProbe[r0.w].x + 0.5;
  r0.w = floor(r0.w);
  r0.w = (uint)r0.w;
  if (r0.w == 0) {
    r9.xyz = x1[0].xyz;
    r14.xyz = r3.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(3,0,0);
    r2.w = dot(r14.xyz, r14.xyz);
    r2.w = sqrt(r2.w);
    r9.xyz = float3(14.7026539,14.7026539,14.7026539) * r9.xyz;
    r14.xy = float2(1.44269502,169.524918) * r2.ww;
    r2.w = exp2(r14.x);
    r4.x = exp2(-r14.x);
    r2.w = -r4.x + r2.w;
    r2.w = 0.5 * r2.w;
    r9.xyz = r9.xyz * r2.www;
    r9.xyz = r9.xyz / r14.yyy;
    r14.xyz = x1[1].xyz;
    r15.xyz = r3.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(-3,0,0);
    r2.w = dot(r15.xyz, r15.xyz);
    r2.w = sqrt(r2.w);
    r14.xyz = float3(14.7026539,14.7026539,14.7026539) * r14.xyz;
    r15.xy = float2(1.44269502,169.524918) * r2.ww;
    r2.w = exp2(r15.x);
    r4.x = exp2(-r15.x);
    r2.w = -r4.x + r2.w;
    r2.w = 0.5 * r2.w;
    r14.xyz = r14.xyz * r2.www;
    r14.xyz = r14.xyz / r15.yyy;
    r9.xyz = r14.xyz + r9.xyz;
    r14.xyz = x1[2].xyz;
    r15.xyz = r3.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(0,3,0);
    r2.w = dot(r15.xyz, r15.xyz);
    r2.w = sqrt(r2.w);
    r14.xyz = float3(14.7026539,14.7026539,14.7026539) * r14.xyz;
    r15.xy = float2(1.44269502,169.524918) * r2.ww;
    r2.w = exp2(r15.x);
    r4.x = exp2(-r15.x);
    r2.w = -r4.x + r2.w;
    r2.w = 0.5 * r2.w;
    r14.xyz = r14.xyz * r2.www;
    r14.xyz = r14.xyz / r15.yyy;
    r9.xyz = r14.xyz + r9.xyz;
    r14.xyz = x1[3].xyz;
    r15.xyz = r3.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(0,-3,0);
    r2.w = dot(r15.xyz, r15.xyz);
    r2.w = sqrt(r2.w);
    r14.xyz = float3(14.7026539,14.7026539,14.7026539) * r14.xyz;
    r15.xy = float2(1.44269502,169.524918) * r2.ww;
    r2.w = exp2(r15.x);
    r4.x = exp2(-r15.x);
    r2.w = -r4.x + r2.w;
    r2.w = 0.5 * r2.w;
    r14.xyz = r14.xyz * r2.www;
    r14.xyz = r14.xyz / r15.yyy;
    r9.xyz = r14.xyz + r9.xyz;
    r14.xyz = x1[4].xyz;
    r15.xyz = r3.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(0,0,3);
    r2.w = dot(r15.xyz, r15.xyz);
    r2.w = sqrt(r2.w);
    r14.xyz = float3(14.7026539,14.7026539,14.7026539) * r14.xyz;
    r15.xy = float2(1.44269502,169.524918) * r2.ww;
    r2.w = exp2(r15.x);
    r4.x = exp2(-r15.x);
    r2.w = -r4.x + r2.w;
    r2.w = 0.5 * r2.w;
    r14.xyz = r14.xyz * r2.www;
    r14.xyz = r14.xyz / r15.yyy;
    r9.xyz = r14.xyz + r9.xyz;
    r14.xyz = x1[5].xyz;
    r15.xyz = r3.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(0,0,-3);
    r2.w = dot(r15.xyz, r15.xyz);
    r2.w = sqrt(r2.w);
    r14.xyz = float3(14.7026539,14.7026539,14.7026539) * r14.xyz;
    r15.xy = float2(1.44269502,169.524918) * r2.ww;
    r2.w = exp2(r15.x);
    r4.x = exp2(-r15.x);
    r2.w = -r4.x + r2.w;
    r2.w = 0.5 * r2.w;
    r14.xyz = r14.xyz * r2.www;
    r14.xyz = r14.xyz / r15.yyy;
    r9.xyz = r14.xyz + r9.xyz;
    r9.xyz = float3(0.318309873,0.318309873,0.318309873) * r9.xyz;
  } else {
    r0.w = cmp((int)r0.w == 2);
    if (r0.w != 0) {
      r11.xyz = cmp(float3(0.5,0.5,0.5) >= abs(r11.xyz));
      r0.w = r11.y ? r11.x : 0;
      r0.w = r11.z ? r0.w : 0;
      r0.w = r0.w ? 0 : 6;
      r2.w = 0;
      while (true) {
        r4.x = cmp((uint)r2.w >= (uint)r0.w);
        if (r4.x != 0) break;
        x1[r2.w+0].x = 1;
        r2.w = (int)r2.w + 1;
      }
      r0.w = -1.02381635 * r3.y;
      r11.xyz = r3.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
      r14.xyzw = r3.xyzx * r3.xyzy;
      r2.w = x1[1].x;
      r4.x = x1[0].x;
      r4.x = r4.x + -r2.w;
      r2.w = r11.x * r4.x + r2.w;
      r4.x = x1[3].x;
      r9.w = x1[2].x;
      r9.w = r9.w + -r4.x;
      r4.x = r11.y * r9.w + r4.x;
      r4.x = r14.y * r4.x;
      r2.w = r14.x * r2.w + r4.x;
      r4.x = x1[5].x;
      r9.w = x1[4].x;
      r9.w = r9.w + -r4.x;
      r4.x = r11.z * r9.w + r4.x;
      r2.w = saturate(r14.z * r4.x + r2.w);
      r11.xy = float2(-1.02381635,-1.02381635) * r3.zx;
      r11.zw = -r3.zz * r3.yx;
      r4.x = 0.858085036 * r14.w;
      r9.w = r14.z * 3 + -1;
      r9.w = 0.247708231 * r9.w;
      r11.zw = float2(-0.858085036,-0.858085036) * r11.zw;
      r10.w = r3.x * r3.x + -r14.y;
      r10.w = 0.429042518 * r10.w;
      r14.xy = (int2)u_tile_info.zw;
      r14.xy = (int2)r14.xy + int2(15,15);
      r14.xy = (uint2)r14.xy >> int2(4,4);
      r14.xy = cmp((int2)r7.xy < (int2)r14.xy);
      r12.w = r14.y ? r14.x : 0;
      r14.xy = (uint2)u_tile_info.xy;
      r13.w = mad((int)r7.y, (int)r14.x, (int)r7.x);
      r13.w = mad((int)r13.w, 3, 2);
      r14.x = s_LocalLightIndexData[r13.w].x;
      r14.x = (uint)r14.x >> 16;
      r15.x = min(64, (uint)r14.x);
      r13.w = (uint)r13.w << 6;
      r15.y = (int)r13.w + (int)r14.y;
      r15.z = 16;
      r14.xyz = (int3)r12.www & (int3)r15.xyz;
      r8.w = 1;
      r15.xyz = float3(0,0,0);
      r12.w = 1;
      r13.w = 0;
      while (true) {
        r14.w = cmp((uint)r13.w >= (uint)r14.x);
        if (r14.w != 0) break;
        r14.w = (int)r13.w + (int)r14.y;
        r14.w = s_LocalLightIndexData[r14.w].x;
        r14.w = (uint)r14.w >> (uint)r14.z;
        r14.w = (int)r14.w & 0x0000ffff;
        r15.w = (uint)g_probe_param[r14.w].x >> 1;
        r18.xy = cmp((int2)r15.ww == int2(3,2));
        r15.w = (int)r18.y | (int)r18.x;
        if (r15.w != 0) {
          r18.xyz = -g_probe_pos[r14.w].xyz + r8.xyz;
          r15.w = dot(r18.xyz, r18.xyz);
          r15.w = sqrt(r15.w);
          r15.w = r15.w / g_probe_param[r14.w].z;
        } else {
          r16.w = (int)r14.w * 3;
          r17.w = dot(g_probe_data[r16.w].xyzw, r8.xyzw);
          r18.x = dot(g_probe_data[r16.w+1].xyzw, r8.xyzw);
          r16.w = dot(g_probe_data[r16.w+2].xyzw, r8.xyzw);
          r17.w = max(abs(r18.x), abs(r17.w));
          r15.w = max(r17.w, abs(r16.w));
        }
        r16.w = cmp(r15.w < 0.99000001);
        r17.w = max(g_probe_param[r14.w].y, 0.00999999978);
        r17.w = min(0.99000001, r17.w);
        r17.w = 1 + -r17.w;
        r17.w = 1 / r17.w;
        r15.w = -g_probe_param[r14.w].y + r15.w;
        r15.w = saturate(-r17.w * r15.w + 1);
        r15.w = r16.w ? r15.w : 0;
        r16.w = cmp(0 < r15.w);
        if (r16.w != 0) {
          r14.w = (int)r14.w * 7;
          r18.x = g_probe_shparam[r14.w].w * r0.w;
          r18.yz = g_probe_shparam[r14.w+1].xy * r0.ww;
          r18.xyz = g_probe_shparam[r14.w].xyz * float3(0.886227667,0.886227667,0.886227667) + r18.xyz;
          r19.xy = g_probe_shparam[r14.w+1].zw * r11.xx;
          r19.z = g_probe_shparam[r14.w+2].x * r11.x;
          r18.xyz = r19.xyz + r18.xyz;
          r18.xyz = r11.yyy * g_probe_shparam[r14.w+2].yzw + r18.xyz;
          r18.xyz = r4.xxx * g_probe_shparam[r14.w+3].xyz + r18.xyz;
          r19.x = g_probe_shparam[r14.w+3].w * r11.z;
          r19.yz = g_probe_shparam[r14.w+4].xy * r11.zz;
          r18.xyz = r19.xyz + r18.xyz;
          r19.xy = g_probe_shparam[r14.w+4].zw * r9.ww;
          r19.z = g_probe_shparam[r14.w+5].x * r9.w;
          r18.xyz = r19.xyz + r18.xyz;
          r18.xyz = r11.www * g_probe_shparam[r14.w+5].yzw + r18.xyz;
          r18.xyz = r10.www * g_probe_shparam[r14.w+6].xyz + r18.xyz;
          r18.xyz = float3(0.318309873,0.318309873,0.318309873) * r18.xyz;
          r14.w = min(r15.w, r12.w);
          r18.xyz = r18.xyz * r14.www + r15.xyz;
          r12.w = -r14.w + r12.w;
          r14.w = cmp(0 >= r12.w);
          if (r14.w != 0) {
            r15.xyz = r18.xyz;
            break;
          }
          r15.xyz = r18.xyz;
        }
        r13.w = (int)r13.w + 1;
      }
      r14.xyz = u_sky_sh_param[1].xyz * r0.www;
      r14.xyz = u_sky_sh_param[0].xyz * float3(0.886227667,0.886227667,0.886227667) + r14.xyz;
      r14.xyz = r11.xxx * u_sky_sh_param[2].xyz + r14.xyz;
      r14.xyz = r11.yyy * u_sky_sh_param[3].xyz + r14.xyz;
      r14.xyz = r4.xxx * u_sky_sh_param[4].xyz + r14.xyz;
      r11.xyz = r11.zzz * u_sky_sh_param[5].xyz + r14.xyz;
      r11.xyz = r9.www * u_sky_sh_param[6].xyz + r11.xyz;
      r11.xyz = r11.www * u_sky_sh_param[7].xyz + r11.xyz;
      r11.xyz = r10.www * u_sky_sh_param[8].xyz + r11.xyz;
      r11.xyz = r11.xyz * r2.www;
      r11.xyz = float3(0.318309873,0.318309873,0.318309873) * r11.xyz;
      r0.w = r2.w * -u_sggi_param[1].w + u_sggi_param[1].w;
      r9.xyz = r15.xyz * r0.www + r11.xyz;
    } else {
      r9.xyz = float3(0,0,0);
    }
  }
  r9.xyz = max(float3(0,0,0), r9.xyz);
  r0.w = 1 + r3.y;
  r0.w = 0.5 * r0.w;
  r11.xyz = -shlightfield_multiply_color_down.xyz + shlightfield_multiply_color_up.xyz;
  r11.xyz = r0.www * r11.xyz + shlightfield_multiply_color_down.xyz;
  r11.xyz = shlightfield_param.yyy * r11.xyz;
  r9.xyz = r11.xyz * r9.xyz;
  r11.xyz = float3(1,1,1) + -r5.xzw;
  r11.xyz = r11.xyz * r5.yyy;
  r9.xyz = r11.xyz * r9.xyz;
  r11.xyz = cmp((int3)r7.www == int3(1,2,3));
  r0.w = (int)r11.y | (int)r11.z;
  r0.w = (int)r11.x | (int)r0.w;
  r0.w = r0.w ? 1 : r6.w;
  r2.w = r6.x + r6.x;
  r11.xyz = r2.www * r3.xyz + -r10.xyz;
  r2.w = dot(r11.xyz, r11.xyz);
  r2.w = rsqrt(r2.w);
  r14.xyz = float3(1,1,1) + -r6.yyy;
  r4.x = max(0, r14.z);
  r5.y = sqrt(r4.x);
  r5.y = r5.y + r6.y;
  r4.x = r5.y * r4.x;
  r11.xyz = r11.xyz * r2.www + -r3.xyz;
  r15.xyz = r4.xxx * r11.xyz + r3.xyz;
  r2.w = min(1, r6.y);
  r2.w = sqrt(r2.w);
  r2.w = 6 * r2.w;
  r18.xy = (int2)u_tile_info.zw;
  r18.xy = (int2)r18.xy + int2(15,15);
  r18.xy = (uint2)r18.xy >> int2(4,4);
  r18.xy = cmp((int2)r7.xy < (int2)r18.xy);
  r4.x = r18.y ? r18.x : 0;
  r18.xy = (uint2)u_tile_info.xy;
  r5.y = mad((int)r7.y, (int)r18.x, (int)r7.x);
  r7.x = (int)r5.y * 3;
  r7.y = mad((int)r5.y, 3, 2);
  r7.w = s_LocalLightIndexData[r7.y].x;
  r9.w = (uint)r7.w >> 16;
  r19.x = min(64, (uint)r9.w);
  r7.y = (uint)r7.y << 6;
  r19.y = (int)r7.y + (int)r18.y;
  r19.z = 16;
  r18.xyz = (int3)r4.xxx & (int3)r19.xyz;
  r8.w = 1;
  r20.xyz = r8.xyz;
  r20.w = 1;
  r19.yzw = float3(0,0,0);
  r7.y = 0;
  r9.w = 0;
  r10.w = 0;
  while (true) {
    r11.w = cmp((uint)r10.w < (uint)r18.x);
    r12.w = cmp(r9.w < 1);
    r11.w = r11.w ? r12.w : 0;
    r12.w = cmp(r7.y < 1);
    r11.w = r11.w ? r12.w : 0;
    if (r11.w == 0) break;
    r11.w = (int)r10.w + (int)r18.y;
    r11.w = s_LocalLightIndexData[r11.w].x;
    r11.w = (uint)r11.w >> (uint)r18.z;
    r11.w = (int)r11.w & 0x0000ffff;
    r12.w = (uint)g_probe_param[r11.w].x >> 1;
    r13.w = cmp((int)r12.w == 1);
    if (r13.w != 0) {
      r13.w = (int)r11.w * 3;
      r21.x = dot(g_probe_data[r13.w].xyzw, r8.xyzw);
      r21.y = dot(g_probe_data[r13.w+1].xyzw, r8.xyzw);
      r21.z = dot(g_probe_data[r13.w+2].xyzw, r8.xyzw);
      r14.w = max(abs(r21.x), abs(r21.y));
      r14.w = max(r14.w, abs(r21.z));
      r16.w = cmp(r14.w < 0.99000001);
      r17.w = max(g_probe_param[r11.w].y, 0.00999999978);
      r17.w = min(0.99000001, r17.w);
      r17.w = 1 + -r17.w;
      r17.w = 1 / r17.w;
      r14.w = -g_probe_param[r11.w].y + r14.w;
      r14.w = saturate(-r17.w * r14.w + 1);
      r14.w = r16.w ? r14.w : 0;
      r16.w = cmp(0 < r14.w);
      if (r16.w != 0) {
        r22.x = dot(g_probe_data[r13.w].xyz, r15.xyz);
        r22.y = dot(g_probe_data[r13.w+1].xyz, r15.xyz);
        r22.z = dot(g_probe_data[r13.w+2].xyz, r15.xyz);
        r23.xyz = float3(1,1,1) + -r21.xyz;
        r23.xyz = r23.xyz / r22.xyz;
        r21.xyz = float3(-1,-1,-1) + -r21.xyz;
        r21.xyz = r21.xyz / r22.xyz;
        r21.xyz = max(r23.xyz, r21.xyz);
        r13.w = min(r21.y, r21.z);
        r13.w = min(r21.x, r13.w);
        r21.xyz = r15.xyz * r13.www + r20.xyz;
        r21.xyz = -g_probe_pos[r11.w].xyz + r21.xyz;
      } else {
        r21.xyz = r15.xyz;
      }
    } else {
      r13.w = cmp((int)r12.w == 3);
      if (r13.w != 0) {
        r22.xyz = -g_probe_pos[r11.w].xyz + r8.xyz;
        r13.w = dot(r22.xyz, r22.xyz);
        r16.w = sqrt(r13.w);
        r17.w = r16.w / g_probe_param[r11.w].z;
        r18.w = cmp(r17.w < 0.99000001);
        r22.w = max(g_probe_param[r11.w].y, 0.00999999978);
        r22.w = min(0.99000001, r22.w);
        r22.w = 1 + -r22.w;
        r22.w = 1 / r22.w;
        r17.w = -g_probe_param[r11.w].y + r17.w;
        r17.w = saturate(-r22.w * r17.w + 1);
        r14.w = r18.w ? r17.w : 0;
        r17.w = cmp(0 < r14.w);
        r22.xyz = r22.xyz / r16.www;
        r18.w = dot(r22.xyz, -r15.xyz);
        r22.x = r18.w * r16.w;
        r13.w = -r22.x * r22.x + r13.w;
        r13.w = sqrt(r13.w);
        r13.w = r13.w * r13.w;
        r13.w = g_probe_param[r11.w].z * g_probe_param[r11.w].z + -r13.w;
        r13.w = sqrt(r13.w);
        r13.w = r18.w * r16.w + r13.w;
        r22.xyz = r15.xyz * r13.www + r8.xyz;
        r22.xyz = -g_probe_pos[r11.w].xyz + r22.xyz;
        r21.xyz = r17.www ? r22.xyz : r15.xyz;
      } else {
        r13.w = cmp((int)r12.w == 2);
        if (r13.w != 0) {
          r22.xyz = -g_probe_pos[r11.w].xyz + r8.xyz;
          r13.w = dot(r22.xyz, r22.xyz);
          r13.w = sqrt(r13.w);
          r13.w = r13.w / g_probe_param[r11.w].z;
          r16.w = cmp(r13.w < 0.99000001);
          r17.w = max(g_probe_param[r11.w].y, 0.00999999978);
          r17.w = min(0.99000001, r17.w);
          r17.w = 1 + -r17.w;
          r17.w = 1 / r17.w;
          r13.w = -g_probe_param[r11.w].y + r13.w;
          r13.w = saturate(-r17.w * r13.w + 1);
          r14.w = r16.w ? r13.w : 0;
        } else {
          if (r12.w == 0) {
            r12.w = (int)r11.w * 3;
            r13.w = dot(g_probe_data[r12.w].xyzw, r20.xyzw);
            r16.w = dot(g_probe_data[r12.w+1].xyzw, r20.xyzw);
            r12.w = dot(g_probe_data[r12.w+2].xyzw, r20.xyzw);
            r13.w = max(abs(r16.w), abs(r13.w));
            r12.w = max(r13.w, abs(r12.w));
            r13.w = cmp(r12.w < 0.99000001);
            r16.w = max(g_probe_param[r11.w].y, 0.00999999978);
            r16.w = min(0.99000001, r16.w);
            r16.w = 1 + -r16.w;
            r16.w = 1 / r16.w;
            r12.w = -g_probe_param[r11.w].y + r12.w;
            r12.w = saturate(-r16.w * r12.w + 1);
            r14.w = r13.w ? r12.w : 0;
          } else {
            r14.w = 1;
          }
        }
        r21.xyz = r15.xyz;
      }
    }
    r12.w = cmp(0 < r14.w);
    if (r12.w != 0) {
      r21.z = -r21.z;
      r21.w = g_probe_pos[r11.w].w;
      r21.xyzw = s_IBLProbeArray.SampleLevel(s_IBLProbeArray_sampler_s, r21.xyzw, r2.w).xyzw;
      r11.w = 1 + -r9.w;
      r11.w = min(r14.w, r11.w);
      r19.yzw = r21.xyz * r11.www + r19.yzw;
      r7.y = r21.w * r11.w + r7.y;
      r9.w = r11.w + r9.w;
    }
    r10.w = (int)r10.w + 1;
  }
  r9.w = r6.w * r2.z;
  r15.w = -r15.z;
  r20.xyz = s_IBL_NedSmpignorenametexture.SampleLevel(s_IBL_sampler_s, r15.xyw, r2.w).xyz;
  r21.xyz = float3(1,1,1) + r20.xyz;
  r21.xyz = max(float3(0,0,0), r21.xyz);
  r21.xyz = log2(r21.xyz);
  r21.xyz = u_ibl_param.xxx * r21.xyz;
  r21.xyz = exp2(r21.xyz);
  r21.xyz = float3(-1,-1,-1) + r21.xyz;
  r21.xyz = max(float3(0,0,0), r21.xyz);
  r20.xyz = -r21.xyz + r20.xyz;
  r22.xyz = r9.www * r20.xyz + r21.xyz;
  r7.y = saturate(1 + -r7.y);
  r19.yzw = r22.xyz * r7.yyy + r19.yzw;
  r22.xy = s_EnvBRDF_NedSmpignorenametexture.SampleLevel(s_EnvBRDF_sampler_s, r6.xy, 0).xy;
  r23.xyz = r5.xzw * r22.xxx + r22.yyy;
  r19.yzw = r23.xyz * r19.yzw;
  r19.yzw = max(float3(0,0,0), r19.yzw);
  r7.y = 1 + -r0.w;
  r0.w = r4.w * r7.y + r0.w;
  r19.yzw = r19.yzw * r0.www;
  r24.xyz = r9.xyz * r2.xyz;
  r25.xyz = r19.yzw * r2.xyz;
  r13.xyz = r13.xyz * r6.www + r16.xyz;
  r16.xyz = max(float3(0,0,0), r13.xyz);
  r16.xyz = r16.xyz * float3(0.318309873,0.318309873,0.318309873) + r24.xyz;
  r16.xyz = r16.xyz * r0.xyz;
  r12.xyz = r12.xyz * r6.www + r17.xyz;
  r17.xyz = max(float3(0,0,0), r12.xyz);
  r1.xyz = r19.yzw * r2.xyz + r17.xyz;
  switch (r7.z) {
    case 0 :    r22.xyz = r16.xyz;
    break;
    case 1 :    r22.xyz = float3(0.318309873,0.318309873,0.318309873) * r13.xyz;
    r1.xyzw = float4(0,0,0,0);
    break;
    case 2 :    r1.xyzw = float4(0,0,0,0);
    r22.xyz = r12.xyz;
    break;
    case 3 :    r1.xyzw = float4(0,0,0,0);
    r22.xyz = r24.xyz;
    break;
    case 43 :    r1.xyzw = float4(0,0,0,0);
    r22.xyz = r24.xyz;
    break;
    case 44 :    r22.xyz = r9.xyz * r2.xyz + r25.xyz;
    r1.xyzw = float4(0,0,0,0);
    break;
    case 4 :    r1.xyzw = float4(0,0,0,0);
    r22.xyz = r25.xyz;
    break;
    case 5 :    case 6 :    r11.xyz = r11.xyz * float3(0.994937599,0.994937599,0.994937599) + r3.xyz;
    r12.xyz = r8.xyz;
    r12.w = 1;
    r8.w = 1;
    r13.xyz = float3(0,0,0);
    r0.w = 0;
    r6.w = 0;
    r7.y = 0;
    while (true) {
      r9.w = cmp((uint)r7.y < (uint)r18.x);
      r10.w = cmp(r6.w < 1);
      r9.w = r9.w ? r10.w : 0;
      r10.w = cmp(r0.w < 1);
      r9.w = r9.w ? r10.w : 0;
      if (r9.w == 0) break;
      r9.w = (int)r7.y + (int)r18.y;
      r9.w = s_LocalLightIndexData[r9.w].x;
      r9.w = (uint)r9.w >> (uint)r18.z;
      r9.w = (int)r9.w & 0x0000ffff;
      r10.w = (uint)g_probe_param[r9.w].x >> 1;
      r13.w = cmp((int)r10.w == 1);
      if (r13.w != 0) {
        r13.w = (int)r9.w * 3;
        r17.x = dot(g_probe_data[r13.w].xyzw, r12.xyzw);
        r17.y = dot(g_probe_data[r13.w+1].xyzw, r12.xyzw);
        r17.z = dot(g_probe_data[r13.w+2].xyzw, r12.xyzw);
        r14.w = max(abs(r17.x), abs(r17.y));
        r14.w = max(r14.w, abs(r17.z));
        r15.w = cmp(r14.w < 0.99000001);
        r16.w = max(g_probe_param[r9.w].y, 0.00999999978);
        r16.w = min(0.99000001, r16.w);
        r16.w = 1 + -r16.w;
        r16.w = 1 / r16.w;
        r14.w = -g_probe_param[r9.w].y + r14.w;
        r14.w = saturate(-r16.w * r14.w + 1);
        r14.w = r15.w ? r14.w : 0;
        r15.w = cmp(0 < r14.w);
        if (r15.w != 0) {
          r26.x = dot(g_probe_data[r13.w].xyz, r11.xyz);
          r26.y = dot(g_probe_data[r13.w+1].xyz, r11.xyz);
          r26.z = dot(g_probe_data[r13.w+2].xyz, r11.xyz);
          r19.yzw = float3(1,1,1) + -r17.xyz;
          r19.yzw = r19.yzw / r26.xyz;
          r17.xyz = float3(-1,-1,-1) + -r17.xyz;
          r17.xyz = r17.xyz / r26.xyz;
          r17.xyz = max(r19.yzw, r17.xyz);
          r13.w = min(r17.y, r17.z);
          r13.w = min(r17.x, r13.w);
          r17.xyz = r11.xyz * r13.www + r12.xyz;
          r17.xyz = -g_probe_pos[r9.w].xyz + r17.xyz;
        } else {
          r17.xyz = r11.xyz;
        }
      } else {
        r13.w = cmp((int)r10.w == 3);
        if (r13.w != 0) {
          r19.yzw = -g_probe_pos[r9.w].xyz + r8.xyz;
          r13.w = dot(r19.yzw, r19.yzw);
          r15.w = sqrt(r13.w);
          r16.w = r15.w / g_probe_param[r9.w].z;
          r18.w = cmp(r16.w < 0.99000001);
          r20.w = max(g_probe_param[r9.w].y, 0.00999999978);
          r20.w = min(0.99000001, r20.w);
          r20.w = 1 + -r20.w;
          r20.w = 1 / r20.w;
          r16.w = -g_probe_param[r9.w].y + r16.w;
          r16.w = saturate(-r20.w * r16.w + 1);
          r14.w = r18.w ? r16.w : 0;
          r16.w = cmp(0 < r14.w);
          r19.yzw = r19.yzw / r15.www;
          r18.w = dot(r19.yzw, -r11.xyz);
          r19.y = r18.w * r15.w;
          r13.w = -r19.y * r19.y + r13.w;
          r13.w = sqrt(r13.w);
          r13.w = r13.w * r13.w;
          r13.w = g_probe_param[r9.w].z * g_probe_param[r9.w].z + -r13.w;
          r13.w = sqrt(r13.w);
          r13.w = r18.w * r15.w + r13.w;
          r19.yzw = r11.xyz * r13.www + r8.xyz;
          r19.yzw = -g_probe_pos[r9.w].xyz + r19.yzw;
          r17.xyz = r16.www ? r19.yzw : r11.xyz;
        } else {
          r13.w = cmp((int)r10.w == 2);
          if (r13.w != 0) {
            r19.yzw = -g_probe_pos[r9.w].xyz + r8.xyz;
            r13.w = dot(r19.yzw, r19.yzw);
            r13.w = sqrt(r13.w);
            r13.w = r13.w / g_probe_param[r9.w].z;
            r15.w = cmp(r13.w < 0.99000001);
            r16.w = max(g_probe_param[r9.w].y, 0.00999999978);
            r16.w = min(0.99000001, r16.w);
            r16.w = 1 + -r16.w;
            r16.w = 1 / r16.w;
            r13.w = -g_probe_param[r9.w].y + r13.w;
            r13.w = saturate(-r16.w * r13.w + 1);
            r14.w = r15.w ? r13.w : 0;
          } else {
            if (r10.w == 0) {
              r10.w = (int)r9.w * 3;
              r13.w = dot(g_probe_data[r10.w].xyzw, r8.xyzw);
              r15.w = dot(g_probe_data[r10.w+1].xyzw, r8.xyzw);
              r10.w = dot(g_probe_data[r10.w+2].xyzw, r8.xyzw);
              r13.w = max(abs(r15.w), abs(r13.w));
              r10.w = max(r13.w, abs(r10.w));
              r13.w = cmp(r10.w < 0.99000001);
              r15.w = max(g_probe_param[r9.w].y, 0.00999999978);
              r15.w = min(0.99000001, r15.w);
              r15.w = 1 + -r15.w;
              r15.w = 1 / r15.w;
              r10.w = -g_probe_param[r9.w].y + r10.w;
              r10.w = saturate(-r15.w * r10.w + 1);
              r14.w = r13.w ? r10.w : 0;
            } else {
              r14.w = 1;
            }
          }
          r17.xyz = r11.xyz;
        }
      }
      r10.w = cmp(0 < r14.w);
      if (r10.w != 0) {
        r17.z = -r17.z;
        r17.w = g_probe_pos[r9.w].w;
        r17.xyzw = s_IBLProbeArray.SampleLevel(s_IBLProbeArray_sampler_s, r17.xyzw, 0.600000024).xyzw;
        r9.w = 1 + -r6.w;
        r9.w = min(r14.w, r9.w);
        r13.xyz = r17.xyz * r9.www + r13.xyz;
        r0.w = r17.w * r9.w + r0.w;
        r6.w = r9.w + r6.w;
      }
      r7.y = (int)r7.y + 1;
    }
    r11.w = -r11.z;
    r11.xyz = s_IBL_NedSmpignorenametexture.SampleLevel(s_IBL_sampler_s, r11.xyw, 0.600000024).xyz;
    r12.xyz = float3(1,1,1) + r11.xyz;
    r12.xyz = max(float3(0,0,0), r12.xyz);
    r12.xyz = log2(r12.xyz);
    r12.xyz = u_ibl_param.xxx * r12.xyz;
    r12.xyz = exp2(r12.xyz);
    r12.xyz = float3(-1,-1,-1) + r12.xyz;
    r12.xyz = max(float3(0,0,0), r12.xyz);
    r11.xyz = -r12.xyz + r11.xyz;
    r11.xyz = r2.zzz * r11.xyz + r12.xyz;
    r0.w = saturate(1 + -r0.w);
    r11.xyz = r11.xyz * r0.www + r13.xyz;
    r6.z = 0.00999999978;
    r6.xz = s_EnvBRDF_NedSmpignorenametexture.SampleLevel(s_EnvBRDF_sampler_s, r6.xz, 0).xy;
    r0.w = r6.x + r6.z;
    r6.xzw = r11.xyz * r0.www;
    r22.xyz = max(float3(0,0,0), r6.xzw);
    r1.xyzw = float4(0,0,0,0);
    break;
    case 7 :    r1.xyzw = float4(0,0,0,0);
    r22.xyz = float3(1,1,1);
    break;
    case 33 :    r0.w = round(g_probe_param[0].x);
    r0.w = (int)r0.w;
    r0.w = (int)r0.w & 1;
    r8.w = 1;
    r11.x = dot(g_probe_data[0].xyzw, r8.xyzw);
    r11.y = dot(g_probe_data[1].xyzw, r8.xyzw);
    r11.z = dot(g_probe_data[2].xyzw, r8.xyzw);
    r6.x = max(abs(r11.x), abs(r11.y));
    r6.x = max(r6.x, abs(r11.z));
    r6.x = cmp(g_probe_param[0].y < r6.x);
    r6.x = r6.x ? 1.000000 : 0;
    r11.xyz = cmp(float3(0.99000001,0.99000001,0.99000001) < abs(r11.xyz));
    r6.z = (int)r11.y | (int)r11.x;
    r6.z = (int)r11.z | (int)r6.z;
    r6.x = r6.z ? 0 : r6.x;
    r1.w = r0.w ? r6.x : r1.w;
    r22.xyz = r16.xyz;
    break;
    case 35 :    r1.w = 0;
    r22.xyz = r16.xyz;
    break;
    default :
    switch (r7.z) {
      case 10 :      r22.xyz = float3(0,0,0);
      r0.w = r7.z;
      break;
      case 11 :      r22.xyz = float3(0,0,0);
      r0.w = r7.z;
      break;
      case 12 :      r22.xyz = r24.xyz;
      r0.w = r7.z;
      break;
      case 13 :      r22.xyz = float3(0,0,0);
      r0.w = r7.z;
      break;
      case 14 :      r22.xyz = r0.xyz;
      r0.w = r7.z;
      break;
      case 15 :      r6.xzw = saturate(float3(0.010397804,0.010397804,0.010397804) + -r0.xyz);
      r6.x = dot(r6.xzw, r6.xzw);
      r11.xyz = saturate(float3(-0.899384499,-0.899384499,-0.899384499) + r0.xyz);
      r6.z = dot(r11.xyz, r11.xyz);
      r6.xz = cmp(r6.xz != float2(0,0));
      r6.x = (int)r6.z | (int)r6.x;
      r22.xyz = r6.xxx ? float3(10,0,0) : r0.xyz;
      r0.w = r7.z;
      break;
      case 16 :      r22.xyz = r1.www;
      r0.w = r7.z;
      break;
      case 17 :      r22.xyz = saturate(r3.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5));
      r0.w = r7.z;
      break;
      case 18 :      r22.xyz = r6.yyy;
      r0.w = r7.z;
      break;
      case 36 :      r22.xyz = r14.xyz;
      r0.w = r7.z;
      break;
      case 19 :      r22.xyz = r9.xyz * r2.xyz + r25.xyz;
      r0.w = r7.z;
      break;
      case 20 :      r22.xyz = r2.xyz;
      r0.w = r7.z;
      break;
      case 21 :      r22.xyz = r5.xzw;
      r0.w = r7.z;
      break;
      case 22 :      r22.xyz = r4.www;
      r0.w = r7.z;
      break;
      case 23 :      r0.xy = (int2)r4.yz & int2(15,15);
      r2.xy = cmp((int2)r0.xy != int2(0,0));
      r0.z = r2.y ? r2.x : 0;
      if (r0.z != 0) {
        r0.z = s_LocalLightIndexData[r7.x].x;
        r2.x = (uint)r0.z >> 16;
        r2.x = min(64, (uint)r2.x);
        r2.x = (int)r2.x & (int)r4.x;
        r0.z = (int)r0.z & 0x0000ffff;
        r0.z = min(64, (uint)r0.z);
        r0.z = (int)r0.z & (int)r4.x;
        r0.y = (int)r0.y + 8;
        r0.x = cmp((uint)r0.x < (uint)r0.y);
        r0.x = r0.x ? r2.x : r0.z;
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
          r5.xzw = x2[r0.y+0].xyz;
          r0.y = (int)r0.y + 1;
          r0.y = min(4, (int)r0.y);
          r6.xyz = x2[r0.y+0].xyz;
          r6.xyz = r6.xyz + -r5.xzw;
          r0.xyz = r0.xxx * r6.xyz + r5.xzw;
          r22.xyz = float3(0.400000006,0.400000006,0.400000006) * r0.xyz;
        } else {
          r22.xyz = float3(0,0,0);
        }
      } else {
        r22.xyz = float3(0,0,0);
      }
      r0.w = r7.z;
      break;
      case 37 :      r0.xy = (int2)r4.yz & int2(15,15);
      r2.xy = cmp((int2)r0.xy != int2(0,0));
      r0.z = r2.y ? r2.x : 0;
      if (r0.z != 0) {
        r0.z = mad((int)r5.y, 3, 1);
        r0.z = s_LocalLightIndexData[r0.z].x;
        r2.x = (uint)r0.z >> 16;
        r2.x = min(64, (uint)r2.x);
        r2.x = (int)r2.x & (int)r4.x;
        r0.z = (int)r0.z & 0x0000ffff;
        r0.z = min(64, (uint)r0.z);
        r0.z = (int)r0.z & (int)r4.x;
        r0.y = (int)r0.y + 8;
        r0.x = cmp((uint)r0.x < (uint)r0.y);
        r0.x = r0.x ? r2.x : r0.z;
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
          r5.xyz = x3[r0.y+0].xyz;
          r0.y = (int)r0.y + 1;
          r0.y = min(4, (int)r0.y);
          r6.xyz = x3[r0.y+0].xyz;
          r6.xyz = r6.xyz + -r5.xyz;
          r0.xyz = r0.xxx * r6.xyz + r5.xyz;
          r22.xyz = float3(0.400000006,0.400000006,0.400000006) * r0.xyz;
        } else {
          r22.xyz = float3(0,0,0);
        }
      } else {
        r22.xyz = float3(0,0,0);
      }
      r0.w = r7.z;
      break;
      case 38 :      r0.xy = (int2)r4.yz & int2(15,15);
      r2.xy = cmp((int2)r0.xy != int2(0,0));
      r0.z = r2.y ? r2.x : 0;
      if (r0.z != 0) {
        r0.z = (int)r4.x & (int)r19.x;
        r2.x = (int)r7.w & 0x0000ffff;
        r2.x = min(64, (uint)r2.x);
        r2.x = (int)r2.x & (int)r4.x;
        r0.y = (int)r0.y + 8;
        r0.x = cmp((uint)r0.x < (uint)r0.y);
        r0.x = r0.x ? r0.z : r2.x;
        if (r0.x != 0) {
          r0.x = (uint)r0.x;
          r0.x = 0.0500000007 * r0.x;
          x4[0].xyz = float3(1,0,0);
          x4[1].xyz = float3(1,1,0);
          x4[2].xyz = float3(0,1,0);
          x4[3].xyz = float3(0,1,1);
          x4[4].xyz = float3(0,0,1);
          r0.x = min(1, r0.x);
          r0.x = 1 + -r0.x;
          r0.y = 4 * r0.x;
          r0.y = trunc(r0.y);
          r0.x = r0.x * 4 + -r0.y;
          r0.y = (int)r0.y;
          r4.xyz = x4[r0.y+0].xyz;
          r0.y = (int)r0.y + 1;
          r0.y = min(4, (int)r0.y);
          r5.xyz = x4[r0.y+0].xyz;
          r5.xyz = r5.xyz + -r4.xyz;
          r0.xyz = r0.xxx * r5.xyz + r4.xyz;
          r22.xyz = float3(0.400000006,0.400000006,0.400000006) * r0.xyz;
        } else {
          r22.xyz = float3(0,0,0);
        }
      } else {
        r22.xyz = float3(0,0,0);
      }
      r0.w = r7.z;
      break;
      case 26 :      r22.xyz = float3(1,1,1);
      r0.w = r7.z;
      break;
      case 27 :      r22.xyz = float3(0,0,0);
      r0.w = r7.z;
      break;
      case 28 :      r4.xyz = r8.xyz;
      r4.w = 1;
      r8.w = 1;
      r0.xyz = float3(0,0,0);
      r2.xy = float2(0,0);
      r5.x = 0;
      while (true) {
        r5.y = cmp((uint)r5.x < (uint)r18.x);
        r5.z = cmp(r2.y < 1);
        r5.y = r5.z ? r5.y : 0;
        r5.z = cmp(r2.x < 1);
        r5.y = r5.z ? r5.y : 0;
        if (r5.y == 0) break;
        r5.y = (int)r5.x + (int)r18.y;
        r5.y = s_LocalLightIndexData[r5.y].x;
        r5.y = (uint)r5.y >> (uint)r18.z;
        r5.y = (int)r5.y & 0x0000ffff;
        r5.z = (uint)g_probe_param[r5.y].x >> 1;
        r5.w = cmp((int)r5.z == 1);
        if (r5.w != 0) {
          r5.w = (int)r5.y * 3;
          r6.x = dot(g_probe_data[r5.w].xyzw, r4.xyzw);
          r6.y = dot(g_probe_data[r5.w+1].xyzw, r4.xyzw);
          r6.z = dot(g_probe_data[r5.w+2].xyzw, r4.xyzw);
          r6.w = max(abs(r6.x), abs(r6.y));
          r6.w = max(r6.w, abs(r6.z));
          r7.x = cmp(r6.w < 0.99000001);
          r7.y = max(g_probe_param[r5.y].y, 0.00999999978);
          r7.y = min(0.99000001, r7.y);
          r7.y = 1 + -r7.y;
          r7.y = 1 / r7.y;
          r6.w = -g_probe_param[r5.y].y + r6.w;
          r6.w = saturate(-r7.y * r6.w + 1);
          r6.w = r7.x ? r6.w : 0;
          r7.x = cmp(0 < r6.w);
          if (r7.x != 0) {
            r9.x = dot(g_probe_data[r5.w].xyz, r3.xyz);
            r9.y = dot(g_probe_data[r5.w+1].xyz, r3.xyz);
            r9.z = dot(g_probe_data[r5.w+2].xyz, r3.xyz);
            r7.xyw = float3(1,1,1) + -r6.xyz;
            r7.xyw = r7.xyw / r9.xyz;
            r6.xyz = float3(-1,-1,-1) + -r6.xyz;
            r6.xyz = r6.xyz / r9.xyz;
            r6.xyz = max(r7.xyw, r6.xyz);
            r5.w = min(r6.y, r6.z);
            r5.w = min(r6.x, r5.w);
            r6.xyz = r3.xyz * r5.www + r4.xyz;
            r9.xyz = -g_probe_pos[r5.y].xyz + r6.xyz;
          } else {
            r9.xyz = r3.xyz;
          }
        } else {
          r5.w = cmp((int)r5.z == 3);
          if (r5.w != 0) {
            r6.xyz = -g_probe_pos[r5.y].xyz + r8.xyz;
            r5.w = dot(r6.xyz, r6.xyz);
            r7.x = sqrt(r5.w);
            r7.y = r7.x / g_probe_param[r5.y].z;
            r7.w = cmp(r7.y < 0.99000001);
            r10.w = max(g_probe_param[r5.y].y, 0.00999999978);
            r10.w = min(0.99000001, r10.w);
            r10.w = 1 + -r10.w;
            r10.w = 1 / r10.w;
            r7.y = -g_probe_param[r5.y].y + r7.y;
            r7.y = saturate(-r10.w * r7.y + 1);
            r6.w = r7.w ? r7.y : 0;
            r7.y = cmp(0 < r6.w);
            r6.xyz = r6.xyz / r7.xxx;
            r6.x = dot(r6.xyz, -r3.xyz);
            r6.y = r6.x * r7.x;
            r5.w = -r6.y * r6.y + r5.w;
            r5.w = sqrt(r5.w);
            r5.w = r5.w * r5.w;
            r5.w = g_probe_param[r5.y].z * g_probe_param[r5.y].z + -r5.w;
            r5.w = sqrt(r5.w);
            r5.w = r6.x * r7.x + r5.w;
            r6.xyz = r3.xyz * r5.www + r8.xyz;
            r6.xyz = -g_probe_pos[r5.y].xyz + r6.xyz;
            r9.xyz = r7.yyy ? r6.xyz : r3.xyz;
          } else {
            r5.w = cmp((int)r5.z == 2);
            if (r5.w != 0) {
              r6.xyz = -g_probe_pos[r5.y].xyz + r8.xyz;
              r5.w = dot(r6.xyz, r6.xyz);
              r5.w = sqrt(r5.w);
              r5.w = r5.w / g_probe_param[r5.y].z;
              r6.x = cmp(r5.w < 0.99000001);
              r6.y = max(g_probe_param[r5.y].y, 0.00999999978);
              r6.y = min(0.99000001, r6.y);
              r6.y = 1 + -r6.y;
              r6.y = 1 / r6.y;
              r5.w = -g_probe_param[r5.y].y + r5.w;
              r5.w = saturate(-r6.y * r5.w + 1);
              r6.w = r6.x ? r5.w : 0;
            } else {
              if (r5.z == 0) {
                r5.z = (int)r5.y * 3;
                r5.w = dot(g_probe_data[r5.z].xyzw, r8.xyzw);
                r6.x = dot(g_probe_data[r5.z+1].xyzw, r8.xyzw);
                r5.z = dot(g_probe_data[r5.z+2].xyzw, r8.xyzw);
                r5.w = max(abs(r6.x), abs(r5.w));
                r5.z = max(r5.w, abs(r5.z));
                r5.w = cmp(r5.z < 0.99000001);
                r6.x = max(g_probe_param[r5.y].y, 0.00999999978);
                r6.x = min(0.99000001, r6.x);
                r6.x = 1 + -r6.x;
                r6.x = 1 / r6.x;
                r5.z = -g_probe_param[r5.y].y + r5.z;
                r5.z = saturate(-r6.x * r5.z + 1);
                r6.w = r5.w ? r5.z : 0;
              } else {
                r6.w = 1;
              }
            }
            r9.xyz = r3.xyz;
          }
        }
        r5.z = cmp(0 < r6.w);
        if (r5.z != 0) {
          r9.z = -r9.z;
          r9.w = g_probe_pos[r5.y].w;
          r9.xyzw = s_IBLProbeArray.SampleLevel(s_IBLProbeArray_sampler_s, r9.xyzw, 6).xyzw;
          r5.y = 1 + -r2.y;
          r5.y = min(r6.w, r5.y);
          r0.xyz = r9.xyz * r5.yyy + r0.xyz;
          r2.x = r9.w * r5.y + r2.x;
          r2.y = r5.y + r2.y;
        }
        r5.x = (int)r5.x + 1;
      }
      r3.w = -r3.z;
      r3.xyz = s_IBL_NedSmpignorenametexture.SampleLevel(s_IBL_sampler_s, r3.xyw, 6).xyz;
      r2.x = saturate(1 + -r2.x);
      r22.xyz = r3.xyz * r2.xxx + r0.xyz;
      r0.w = r7.z;
      break;
      case 29 :      r3.xyz = r8.xyz;
      r3.w = 1;
      r8.w = 1;
      r0.xyz = float3(0,0,0);
      r2.xy = float2(0,0);
      r4.x = 0;
      while (true) {
        r4.y = cmp((uint)r4.x < (uint)r18.x);
        r4.z = cmp(r2.y < 1);
        r4.y = r4.z ? r4.y : 0;
        r4.z = cmp(r2.x < 1);
        r4.y = r4.z ? r4.y : 0;
        if (r4.y == 0) break;
        r4.y = (int)r4.x + (int)r18.y;
        r4.y = s_LocalLightIndexData[r4.y].x;
        r4.y = (uint)r4.y >> (uint)r18.z;
        r4.y = (int)r4.y & 0x0000ffff;
        r4.z = (uint)g_probe_param[r4.y].x >> 1;
        r4.w = cmp((int)r4.z == 1);
        if (r4.w != 0) {
          r4.w = (int)r4.y * 3;
          r5.x = dot(g_probe_data[r4.w].xyzw, r3.xyzw);
          r5.y = dot(g_probe_data[r4.w+1].xyzw, r3.xyzw);
          r5.z = dot(g_probe_data[r4.w+2].xyzw, r3.xyzw);
          r5.w = max(abs(r5.x), abs(r5.y));
          r5.w = max(r5.w, abs(r5.z));
          r6.x = cmp(r5.w < 0.99000001);
          r6.y = max(g_probe_param[r4.y].y, 0.00999999978);
          r6.y = min(0.99000001, r6.y);
          r6.y = 1 + -r6.y;
          r6.y = 1 / r6.y;
          r5.w = -g_probe_param[r4.y].y + r5.w;
          r5.w = saturate(-r6.y * r5.w + 1);
          r5.w = r6.x ? r5.w : 0;
          r6.x = cmp(0 < r5.w);
          if (r6.x != 0) {
            r6.x = dot(g_probe_data[r4.w].xyz, r15.xyz);
            r6.y = dot(g_probe_data[r4.w+1].xyz, r15.xyz);
            r6.z = dot(g_probe_data[r4.w+2].xyz, r15.xyz);
            r7.xyw = float3(1,1,1) + -r5.xyz;
            r7.xyw = r7.xyw / r6.xyz;
            r5.xyz = float3(-1,-1,-1) + -r5.xyz;
            r5.xyz = r5.xyz / r6.xyz;
            r5.xyz = max(r7.xyw, r5.xyz);
            r4.w = min(r5.y, r5.z);
            r4.w = min(r5.x, r4.w);
            r5.xyz = r15.xyz * r4.www + r3.xyz;
            r6.xyz = -g_probe_pos[r4.y].xyz + r5.xyz;
          } else {
            r6.xyz = r15.xyz;
          }
        } else {
          r4.w = cmp((int)r4.z == 3);
          if (r4.w != 0) {
            r5.xyz = -g_probe_pos[r4.y].xyz + r8.xyz;
            r4.w = dot(r5.xyz, r5.xyz);
            r7.x = sqrt(r4.w);
            r7.y = r7.x / g_probe_param[r4.y].z;
            r7.w = cmp(r7.y < 0.99000001);
            r9.x = max(g_probe_param[r4.y].y, 0.00999999978);
            r9.x = min(0.99000001, r9.x);
            r9.x = 1 + -r9.x;
            r9.x = 1 / r9.x;
            r7.y = -g_probe_param[r4.y].y + r7.y;
            r7.y = saturate(-r9.x * r7.y + 1);
            r5.w = r7.w ? r7.y : 0;
            r7.y = cmp(0 < r5.w);
            r5.xyz = r5.xyz / r7.xxx;
            r5.x = dot(r5.xyz, -r15.xyz);
            r5.y = r5.x * r7.x;
            r4.w = -r5.y * r5.y + r4.w;
            r4.w = sqrt(r4.w);
            r4.w = r4.w * r4.w;
            r4.w = g_probe_param[r4.y].z * g_probe_param[r4.y].z + -r4.w;
            r4.w = sqrt(r4.w);
            r4.w = r5.x * r7.x + r4.w;
            r5.xyz = r15.xyz * r4.www + r8.xyz;
            r5.xyz = -g_probe_pos[r4.y].xyz + r5.xyz;
            r6.xyz = r7.yyy ? r5.xyz : r15.xyz;
          } else {
            r4.w = cmp((int)r4.z == 2);
            if (r4.w != 0) {
              r5.xyz = -g_probe_pos[r4.y].xyz + r8.xyz;
              r4.w = dot(r5.xyz, r5.xyz);
              r4.w = sqrt(r4.w);
              r4.w = r4.w / g_probe_param[r4.y].z;
              r5.x = cmp(r4.w < 0.99000001);
              r5.y = max(g_probe_param[r4.y].y, 0.00999999978);
              r5.y = min(0.99000001, r5.y);
              r5.y = 1 + -r5.y;
              r5.y = 1 / r5.y;
              r4.w = -g_probe_param[r4.y].y + r4.w;
              r4.w = saturate(-r5.y * r4.w + 1);
              r5.w = r5.x ? r4.w : 0;
            } else {
              if (r4.z == 0) {
                r4.z = (int)r4.y * 3;
                r4.w = dot(g_probe_data[r4.z].xyzw, r8.xyzw);
                r5.x = dot(g_probe_data[r4.z+1].xyzw, r8.xyzw);
                r4.z = dot(g_probe_data[r4.z+2].xyzw, r8.xyzw);
                r4.w = max(abs(r5.x), abs(r4.w));
                r4.z = max(r4.w, abs(r4.z));
                r4.w = cmp(r4.z < 0.99000001);
                r5.x = max(g_probe_param[r4.y].y, 0.00999999978);
                r5.x = min(0.99000001, r5.x);
                r5.x = 1 + -r5.x;
                r5.x = 1 / r5.x;
                r4.z = -g_probe_param[r4.y].y + r4.z;
                r4.z = saturate(-r5.x * r4.z + 1);
                r5.w = r4.w ? r4.z : 0;
              } else {
                r5.w = 1;
              }
            }
            r6.xyz = r15.xyz;
          }
        }
        r4.z = cmp(0 < r5.w);
        if (r4.z != 0) {
          r6.z = -r6.z;
          r6.w = g_probe_pos[r4.y].w;
          r6.xyzw = s_IBLProbeArray.SampleLevel(s_IBLProbeArray_sampler_s, r6.xyzw, r2.w).xyzw;
          r4.y = 1 + -r2.y;
          r4.y = min(r5.w, r4.y);
          r0.xyz = r6.xyz * r4.yyy + r0.xyz;
          r2.x = r6.w * r4.y + r2.x;
          r2.y = r4.y + r2.y;
        }
        r4.x = (int)r4.x + 1;
      }
      r2.yzw = r2.zzz * r20.xyz + r21.xyz;
      r2.x = saturate(1 + -r2.x);
      r0.xyz = r2.yzw * r2.xxx + r0.xyz;
      r0.xyz = r0.xyz * r23.xyz;
      r22.xyz = max(float3(0,0,0), r0.xyz);
      r0.w = r7.z;
      break;
      case 30 :      r22.z = 0;
      r0.w = r7.z;
      break;
      case 31 :      r0.xyz = float3(0.00999999978,0.00999999978,0.00999999978) * r8.xyz;
      r2.xyz = cmp(r0.xyz >= -r0.xyz);
      r0.xyz = frac(abs(r0.xyz));
      r0.xyz = r2.xyz ? r0.xyz : -r0.xyz;
      r0.xyz = float3(1,1,1) + r0.xyz;
      r2.xyz = cmp(r0.xyz >= float3(0,0,0));
      r2.xyz = r2.xyz ? float3(1,1,1) : 0;
      r22.xyz = r2.xyz + r0.xyz;
      r0.w = r7.z;
      break;
      case 32 :      r22.xyz = float3(0,0,0);
      r0.w = r7.z;
      break;
      case 39 :      if (2 == 0) r0.x = 0; else if (2+4 < 32) {       r0.x = (uint)u_shading_model_flag.x << (32-(2 + 4)); r0.x = (uint)r0.x >> (32-2);      } else r0.x = (uint)u_shading_model_flag.x >> 4;
      r0.x = 1 << (int)r0.x;
      r0.x = (int)r0.x & 2;
      r22.xyz = r0.xxx ? float3(1,1,1) : float3(0,0,0);
      r0.w = r7.z;
      break;
      case 40 :      r0.x = g_global_user_param_3.y + -g_global_user_param_3.x;
      r22.xyz = -g_global_user_param_3.xxx / r0.xxx;
      r0.w = r7.z;
      break;
      case 41 :      r0.xyz = (int3)u_shading_model_flag.xxx & int3(4,1,8);
      r2.xyz = r0.xyz ? float3(0.5,0.5,3) : float3(0,0,1);
      r2.w = 0.5;
      r22.xyz = r2.ywx * r2.zzz;
      r0.w = r7.z;
      break;
      case 42 :      if (2 == 0) r0.x = 0; else if (2+4 < 32) {       r0.x = (uint)u_shading_model_flag.x << (32-(2 + 4)); r0.x = (uint)r0.x >> (32-2);      } else r0.x = (uint)u_shading_model_flag.x >> 4;
      r0.xyz = cmp((int3)r0.xxx == int3(1,2,3));
      r22.xyz = r0.xyz ? float3(1,1,1) : 0;
      r0.w = r7.z;
      break;
      default :
      r22.xyz = float3(0,0,0);
      r0.w = 0;
      break;
    }
    if (r0.w != 0) {
      r0.x = s_Luminance_NedSmpignorenametexture.SampleLevel(s_Luminance_sampler_s, float2(0.75,0.5), 0).x;
      r22.xyz = r22.xyz * r0.xxx;
    }
    r1.xyzw = float4(0,0,0,0);
    break;
  }
  r0.x = cmp(shadow_map_parameter[0].z == -1.000000);
  if (r0.x != 0) {
    r8.w = 1;
    r0.x = dot(shadow_camera_view_matrix_third_row.xyzw, r8.xyzw);
    r2.xyzw = cmp(shadow_cascade_frustums_eye_space_depth.xyzw < -r0.xxxx);
    r2.xyzw = r2.xyzw ? float4(1,1,1,1) : 0;
    r0.y = dot(float4(1,1,1,1), r2.xyzw);
    r0.z = (int)shadow_map_parameter[0].y;
    r0.w = cmp(0 < (int)r0.z);
    r0.w = r0.w ? 0 : 4;
    r0.y = r0.y + r0.w;
    r0.y = (int)r0.y;
    r0.w = cmp(shadow_map_parameter[1].z == 0.000000);
    if (r0.w != 0) {
      r0.w = 0;
    } else {
      r2.x = dot(shadow_cascade_frustums_eye_space_depth.xyzw, icb[r0.y+0].xyzw);
      r2.x = r2.x + r0.x;
      r2.x = saturate(shadow_map_parameter[1].z * r2.x);
      r0.w = 1 + -r2.x;
    }
    r2.x = cmp((int)r0.y < (int)r0.z);
    if (r2.x != 0) {
      r2.xyz = shadow_view_matrix._m10_m11_m12 * v5.www;
      r2.xyz = v4.www * shadow_view_matrix._m00_m01_m02 + r2.xyz;
      r2.xyz = v6.www * shadow_view_matrix._m20_m21_m22 + r2.xyz;
      r2.xyz = shadow_view_matrix._m30_m31_m32 + r2.xyz;
      r2.xyz = r2.xyz * shadow_cascade_scale[r0.y].xyz + shadow_cascade_offset[r0.y].xyz;
      r3.xyz = cmp(r2.xyz >= float3(0,0,0));
      r2.xyz = cmp(r2.xyz < float3(1,1,1));
      r2.x = r2.x ? r3.x : 0;
      r2.x = r3.y ? r2.x : 0;
      r2.x = r2.y ? r2.x : 0;
      r2.x = r3.z ? r2.x : 0;
      r2.x = r2.z ? r2.x : 0;
      if (r2.x != 0) {
        r2.x = (int)r0.y + 1;
        r0.z = (int)r0.z + -1;
        r2.x = min((int)r2.x, (int)r0.z);
        r0.z = dot(shadow_cascade_frustums_eye_space_depth.xyzw, icb[r0.z+0].xyzw);
        r0.x = r0.z + r0.x;
        r0.x = saturate(shadow_map_parameter[1].x * r0.x);
        r2.xyz = icb[r2.x+8].xyz + -icb[r0.y+8].xyz;
        r0.yzw = r0.www * r2.xyz + icb[r0.y+8].xyz;
        r0.yzw = float3(-1,-1,-1) + r0.yzw;
        r0.xyz = r0.xxx * r0.yzw + float3(1,1,1);
        r22.xyz = r22.xyz * r0.xyz;
      }
    }
  }
  r1.xyz = r22.xyz + r1.xyz;
  r0.xyzw = u_modulate_color.xyzw * r1.xyzw;
  switch (r7.z) {
    case 24 :    r2.xyz = v9.xyz;
    break;
    case 25 :    r2.xyz = v10.xyz;
    break;
    default :
    r3.xyz = r0.xyz * v9.xyz + v10.xyz;
    r1.xyz = -r1.xyz * u_modulate_color.xyz + r3.xyz;
    r2.xyz = g_LightScatteringColor.www * r1.xyz + r0.xyz;
    break;
  }
  r0.x = floor(g_global_user_param_3.y);
  r0.x = (uint)r0.x;
  r1.yz = v0.xy * u_screen_info.zw + -g_global_user_param_2.zw;
  r1.x = g_global_user_param_2.y * r1.y;
  r0.y = dot(r1.xz, r1.xz);
  r0.y = sqrt(r0.y);
  r0.z = dot(r2.xyz, float3(0.212500006,0.715399981,0.0720999986));
  r1.xyz = r0.zzz + -r2.xyz;
  r1.xyz = g_global_user_param_3.xxx * r1.xyz + r2.xyz;
  r0.z = max(r2.y, r2.z);
  r0.z = max(r2.x, r0.z);
  r3.xyz = r0.zzz + -r2.xyz;
  r3.xyz = r3.xyz + -r2.xyz;
  r3.xyz = g_global_user_param_3.xxx * r3.xyz + r2.xyz;
  r4.xy = cmp((int2)r0.xx == int2(1,2));
  r4.yzw = r4.yyy ? r1.xyz : r2.xyz;
  r3.xyz = r4.xxx ? r3.xyz : r4.yzw;
  r1.xyz = r0.xxx ? r3.xyz : r1.xyz;
  r0.x = cmp(g_global_user_param_2.x < r0.y);
  r0.xyz = r0.xxx ? r2.xyz : r1.xyz;
  r1.xyz = u_fog_param_0.xyz * u_fog_param_0.www;
  r1.w = cmp(0.00100000005 < u_fog_param_2.x);
  if (r1.w != 0) {
    r1.w = saturate(u_fog_param_2.y);
    r1.w = sqrt(r1.w);
    r1.w = 6 * r1.w;
    r2.xyz = float3(-1,-1,1) * r10.xyz;
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
