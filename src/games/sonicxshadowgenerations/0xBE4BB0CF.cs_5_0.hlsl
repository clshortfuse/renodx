#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Wed Nov 18 20:52:44 2026

cbuffer _Globals : register(b0)
{
  float4 ssss_param : packoffset(c0);
  float4 ssss_colors[16] : packoffset(c1);
  float4 ssss_ambient_boost : packoffset(c17);
}

cbuffer cbWorld : register(b1)
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

cbuffer cb_shlightfield_probes : register(b2)
{
  float4 shlightfield_param : packoffset(c0);
  float4 shlightfield_multiply_color_up : packoffset(c1);
  float4 shlightfield_multiply_color_down : packoffset(c2);
  float4 shlightfield_probes_SHLightFieldProbe[27] : packoffset(c3);
  float4 shlightfield_probe_SHLightFieldProbe_end : packoffset(c256);
}

cbuffer cb_local_light_context_data : register(b3)
{
  float4 g_local_light_count : packoffset(c0);
  float4 g_local_light_shadow_param[3] : packoffset(c1);
  row_major float4x4 g_local_light_shadow_matrix[3] : packoffset(c4);
  row_major float4x4 g_local_light_data[1000] : packoffset(c16);
}

SamplerState s_EnvBRDF_sampler_s : register(s0);
SamplerState s_IBL_sampler_s : register(s1);
SamplerState s_SSAO_sampler_s : register(s2);
SamplerState s_RLR_sampler_s : register(s3);
SamplerState s_SHLightField0_sampler_s : register(s4);
SamplerState s_SHLightField1_sampler_s : register(s5);
SamplerState s_SHLightField2_sampler_s : register(s6);
SamplerState s_IBLProbeArray_sampler_s : register(s7);
SamplerComparisonState s_LocalShadowMap_sampler_s : register(s8);
Texture2D<float4> s_EnvBRDF : register(t0);
TextureCube<float4> s_IBL : register(t1);
Texture2D<float4> s_DepthBuffer : register(t2);
Texture2D<float4> s_SSAO : register(t3);
Texture2D<float4> s_RLR : register(t4);
Texture2D<float4> s_GBuffer0 : register(t5);
Texture2D<float4> s_GBuffer1 : register(t6);
Texture2D<float4> s_GBuffer2 : register(t7);
Texture2D<float4> s_GBuffer3 : register(t8);
Texture3D<float4> s_SHLightField0_NedSmpignorenametexture : register(t9);
Texture3D<float4> s_SHLightField1_NedSmpignorenametexture : register(t10);
Texture3D<float4> s_SHLightField2_NedSmpignorenametexture : register(t11);
StructuredBuffer<uint> s_LocalLightIndexData : register(t12);
TextureCubeArray<float4> s_IBLProbeArray : register(t13);
TextureCubeArray<float4> s_LocalShadowMap : register(t14);
RWTexture2D<float4> rw_Output0 : register(u0);
RWTexture2D<float4> rw_Output1 : register(u1);
RWByteAddressBuffer rw_indirectSSSSDrawArguments : register(u2);
RWStructuredBuffer<uint> rw_IndirectSSSSTiles : register(u3);


// 3Dmigoto declarations
#define cmp -


groupshared uint has_sss;

[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID, uint vThreadIDInGroupFlattened : SV_GroupIndex, uint3 vThreadGroupID : SV_GroupID)
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22,r23,r24,r25,r26,r27,r28;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 x0[9];
  float4 x1[9];
  r0.xy = (int2)vThreadID.xy;
  r0.xy = cmp(r0.xy < u_viewport_info.xy);
  r0.x = r0.y ? r0.x : 0;
  r1.xy = vThreadID.xy;
  r1.zw = float2(0,0);
  r2.xyzw = s_GBuffer0.Load(r1.xyw).xyzw;
  r0.y = 255 * r2.w;
  r0.y = (uint)r0.y;
  r0.z = (int)r0.y & 7;
  r0.w = cmp((int)r0.z == 3);
  r2.w = cmp((int)r0.z != 0);
  r3.x = cmp((int)vThreadIDInGroupFlattened == 0);
  if (vThreadIDInGroupFlattened == 0) {
    has_sss = 0u;
  }
  GroupMemoryBarrierWithGroupSync();
  if (r0.w != 0) {
    InterlockedOr(has_sss, 1u);
  }
  GroupMemoryBarrierWithGroupSync();
r3.y = has_sss;
  r3.y = cmp((int)r3.y != 0);
  r3.x = r3.x ? r3.y : 0;
  if (r3.x != 0) {
    uint previous_count;
    rw_indirectSSSSDrawArguments.InterlockedAdd(0u, 6u, previous_count);
    r3.x = previous_count;
    uiDest.x = (uint)r3.x / 6;
    r3.x = uiDest.x;
    r3.y = mad((int)vThreadGroupID.y, 0x00010000, (int)vThreadGroupID.x);
    rw_IndirectSSSSTiles[r3.x].x = r3.y;
  }
  r0.x = r0.x ? r2.w : 0;
  if (r0.x == 0) {
    rw_Output0[vThreadID.xy] = clear_color;
    rw_Output1[vThreadID.xy] = 0.f;
    return;
  }
  r3.xy = (uint2)u_viewport_info.xy;
  r3.xy = min((uint2)vThreadID.xy, (uint2)r3.xy);
  r3.xy = (uint2)r3.xy;
  r3.xy = float2(0.5,0.5) + r3.xy;
  r3.xy = r3.xy / u_screen_info.xy;
  r4.xyz = s_GBuffer1.Load(r1.xyw).xyz;
  r5.xyzw = s_GBuffer2.Load(r1.xyw).xyzw;
  r6.xyzw = s_GBuffer3.Load(r1.xyw).xyzw;
  r0.x = s_DepthBuffer.Load(r1.xyz).x;
  r1.xy = (uint2)vThreadGroupID.xy >> int2(1,1);
  r7.xyz = r4.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r4.xzw = -r6.xxx + r2.xyz;
  r4.xzw = r6.www * r4.xzw + r6.xxx;
  r1.z = r0.x * u_view_param.w + -u_view_param.z;
  r1.z = -u_view_param.x / r1.z;
  r3.zw = u_viewport_info.zw * r3.xy;
  r3.zw = r3.zw * float2(2,-2) + float2(-1,1);
  r8.xyzw = inv_view_proj_matrix._m10_m11_m12_m13 * r3.wwww;
  r8.xyzw = r3.zzzz * inv_view_proj_matrix._m00_m01_m02_m03 + r8.xyzw;
  r8.xyzw = r0.xxxx * inv_view_proj_matrix._m20_m21_m22_m23 + r8.xyzw;
  r8.xyzw = inv_view_proj_matrix._m30_m31_m32_m33 + r8.xyzw;
  r8.xyz = r8.xyz / r8.www;
  r9.xyz = u_cameraPosition.xyz + -r8.xyz;
  r0.x = dot(r9.xyz, r9.xyz);
  r0.x = rsqrt(r0.x);
  r10.xyz = r9.xyz * r0.xxx;
  r1.w = 0.100000001 * abs(r5.w);
  r1.w = trunc(r1.w);
  r2.w = abs(r5.w) * 0.100000001 + -r1.w;
  r11.x = 10 * r2.w;
  r1.w = (uint)r1.w;
  r3.zw = cmp((int2)r0.zz == int2(4,1));
  r12.x = floor(abs(r5.z));
  r12.y = frac(abs(r5.z));
  r11.zw = float2(2,10) * r12.xy;
  r2.w = dot(r5.xy, r5.xy);
  r2.w = 1 + -r2.w;
  r2.w = sqrt(r2.w);
  r5.w = cmp(0 < r5.z);
  r9.w = cmp(r5.z < 0);
  r5.w = (int)-r5.w + (int)r9.w;
  r5.w = (int)r5.w;
  r12.z = r5.w * r2.w;
  r12.xy = r5.xy;
  r13.xyz = r12.zxy * r7.yzx;
  r13.xyz = r12.yzx * r7.zxy + -r13.xyz;
  r2.w = dot(r13.xyz, r13.xyz);
  r2.w = rsqrt(r2.w);
  r13.xyz = r13.xyz * r2.www;
  r12.xyz = r3.zzz ? r12.xyz : 0;
  r13.xyz = r3.zzz ? r13.xyz : 0;
  r14.xy = r3.zz ? r11.zw : 0;
  r12.xyz = r0.www ? float3(0,0,0) : r12.xyz;
  r13.xyz = r0.www ? float3(0,0,0) : r13.xyz;
  r14.z = 0;
  r14.xyz = r0.www ? r5.xyz : r14.xyz;
  r2.w = (int)r0.w | (int)r3.z;
  r5.xyz = r2.www ? float3(0,0,0) : r5.xyz;
  r11.zw = cmp((int2)r1.ww == int2(0,1));
  r2.w = cmp(0 < shlightfield_param.x);
  r5.w = r2.w ? r11.z : 0;
  r11.y = 1;
  r11.xy = r5.ww ? r11.xy : r11.yx;
  r15.xyzw = s_SSAO.SampleLevel(s_SSAO_sampler_s, r3.xy, 0).xyzw;
  r16.xyz = saturate(u_ssao_param.xxx + r15.xyz);
  r15.yzw = min(r15.www, r11.yyy);
  r5.w = (int)r0.y & 8;
  r17.xyz = u_lightColor.xyz * r15.www;
  r17.xyz = r17.xyz * r5.xyz;
  r17.xyz = r17.xyz * r2.xyz;
  r5.xyz = r5.www ? r17.xyz : r5.xyz;
  r9.w = saturate(dot(r7.xyz, u_lightDirection.xyz));
  r9.xyz = r9.xyz * r0.xxx + u_lightDirection.xyz;
  r0.x = dot(r9.xyz, r9.xyz);
  r0.x = rsqrt(r0.x);
  r9.xyz = r9.xyz * r0.xxx;
  r0.x = saturate(dot(r4.xzw, float3(16.5,16.5,16.5)));
  r10.w = saturate(dot(r9.xyz, u_lightDirection.xyz));
  r17.xyz = r0.xxx + -r4.xzw;
  r0.x = 1 + -r10.w;
  r10.w = r0.x * r0.x;
  r10.w = r10.w * r10.w;
  r0.x = r10.w * r0.x;
  r18.xyz = r17.xyz * r0.xxx + r4.xzw;
  r0.x = r9.w * r15.w;
  r19.xyz = u_lightColor.xyz * r0.xxx;
  r0.x = 1 + -r18.x;
  r10.w = 1 + -r6.w;
  r0.x = r10.w * r0.x;
  r19.xyz = r19.xyz * r0.xxx;
  r20.x = saturate(dot(r7.xyz, r10.xyz));
  r0.x = saturate(dot(r7.xyz, r9.xyz));
  r11.y = r6.y * r6.y;
  r21.xy = r11.yy * r14.xy;
  r12.x = dot(r9.xyz, r12.xyz);
  r9.x = dot(r9.xyz, r13.xyz);
  r9.y = r21.y * r21.x;
  r9.y = 3.14159274 * r9.y;
  r12.yz = r11.yy * r14.xy + float2(9.99999997e-007,9.99999997e-007);
  r9.z = r12.x / r12.y;
  r9.x = r9.x / r12.z;
  r9.x = r9.x * r9.x;
  r9.x = r9.z * r9.z + r9.x;
  r9.x = r0.x * r0.x + r9.x;
  r9.x = r9.x * r9.x;
  r9.x = r9.y * r9.x + 9.99999997e-007;
  r9.x = 1 / r9.x;
  r9.y = -r0.x * r0.x + 1;
  r0.x = r0.x * r6.y;
  r0.x = r0.x * r0.x + r9.y;
  r0.x = r6.y / r0.x;
  r0.x = r0.x * r0.x;
  r0.x = 0.318309873 * r0.x;
  r0.x = r3.z ? r9.x : r0.x;
  r3.z = 1 + r6.y;
  r3.z = r3.z * r3.z;
  r9.x = 0.125 * r3.z;
  r3.z = -r3.z * 0.125 + 1;
  r9.y = r9.w * r3.z + r9.x;
  r9.z = r20.x * r3.z + r9.x;
  r9.y = r9.y * r9.z;
  r9.y = 0.25 / r9.y;
  r0.x = r9.y * r0.x;
  r12.xyz = saturate(r0.xxx * r18.xyz);
  r12.xyz = r12.xyz * r9.www;
  r12.xyz = u_lightColor.xyz * r12.xyz;
  r12.xyz = r12.xyz * r15.yzw;
  r0.x = (uint)g_local_light_count.x;
  if (r0.x != 0) {
    r9.yw = (int2)u_tile_info.zw;
    r9.yw = (int2)r9.yw + int2(15,15);
    r9.yw = (uint2)r9.yw >> int2(4,4);
    r9.yw = cmp((int2)r1.xy < (int2)r9.yw);
    r0.x = r9.w ? r9.y : 0;
    r9.yw = (uint2)u_tile_info.xy;
    r9.y = mad((int)r1.y, (int)r9.y, (int)r1.x);
    r9.y = (int)r9.y * 3;
    r11.y = s_LocalLightIndexData[r9.y].x;
    r11.y = (int)r11.y & 0x0000ffff;
    r13.x = min(64, (uint)r11.y);
    r9.y = (uint)r9.y << 6;
    r13.y = (int)r9.y + (int)r9.w;
    r9.yw = (int2)r0.xx & (int2)r13.xy;
    if (2 == 0) r0.x = 0; else if (2+4 < 32) {     r0.x = (uint)r0.y << (32-(2 + 4)); r0.x = (uint)r0.x >> (32-2);    } else r0.x = (uint)r0.y >> 4;
    r0.x = 1 << (int)r0.x;
    r13.x = 1;
    r18.xyz = float3(0,0,0);
    r21.xyz = float3(0,0,0);
    r11.y = 0;
    while (true) {
      r12.w = cmp((uint)r11.y >= (uint)r9.y);
      if (r12.w != 0) break;
      r12.w = (int)r9.w + (int)r11.y;
      r12.w = s_LocalLightIndexData[r12.w].x;
      bitmask.w = ((~(-1 << 16)) << 2) & 0xffffffff;  r12.w = (((uint)r12.w << 2) & bitmask.w) | ((uint)0 & ~bitmask.w);
      r13.w = (int)r0.x & (int4)g_local_light_data[r12.w/4]._m33;
      if (3 == 0) r14.w = 0; else if (3+16 < 32) {       r14.w = (uint)g_local_light_data[r12.w/4]._m33 << (32-(3 + 16)); r14.w = (uint)r14.w >> (32-3);      } else r14.w = (uint)g_local_light_data[r12.w/4]._m33 >> 16;
      r14.w = (int)r14.w + -1;
      r16.w = cmp((int)r14.w >= 0);
      r17.w = cmp(0.00999999978 < abs(g_local_light_shadow_param[r14.w].w));
      r16.w = r16.w ? r17.w : 0;
      if (r16.w == 0) {
        r16.w = 1;
      } else {
        r17.w = cmp(g_local_light_shadow_param[r14.w].w < 0);
        r22.xyz = -g_local_light_shadow_param[r14.w].xyz + r8.xyz;
        r18.w = dot(r22.xyz, r22.xyz);
        r18.w = sqrt(r18.w);
        if (r17.w != 0) {
          r17.w = (uint)r14.w << 2;
          r23.xyzw = g_local_light_shadow_matrix[r17.w/4]._m10_m11_m12_m13 * r8.yyyy;
          r23.xyzw = r8.xxxx * g_local_light_shadow_matrix[r17.w/4]._m00_m01_m02_m03 + r23.xyzw;
          r23.xyzw = r8.zzzz * g_local_light_shadow_matrix[r17.w/4]._m20_m21_m22_m23 + r23.xyzw;
          r23.xyzw = g_local_light_shadow_matrix[r17.w/4]._m30_m31_m32_m33 + r23.xyzw;
          r23.xyz = r23.zxy / r23.www;
          r13.yz = float2(1,-1) * r23.zy;
          r17.w = dot(r13.xyz, r13.xyz);
          r17.w = rsqrt(r17.w);
          r23.yzw = r17.www * r13.xyz;
          r22.xyz = r23.yzw * r18.www;
          r13.yz = r22.yz;
        } else {
          r17.w = (uint)r14.w << 2;
          r19.w = max(abs(r22.y), abs(r22.z));
          r19.w = max(abs(r22.x), r19.w);
          r23.yz = g_local_light_shadow_matrix[r17.w/4]._m22_m23 * -r19.ww + g_local_light_shadow_matrix[r17.w/4]._m32_m33;
          r23.x = r23.y / r23.z;
          r13.yz = r22.yz;
        }
        r24.w = (int)r14.w;
        r17.w = -0.00100000005 + r23.x;
        r19.w = 0;
        r21.w = 0;
        while (true) {
          r22.z = cmp((int)r21.w >= 5);
          if (r22.z != 0) break;
          r22.zw = icb[r21.w+3].xy * float2(0.00200000009,0.00200000009);
          sincos(r22.z, r23.x, r25.x);
          sincos(r22.w, r26.x, r27.x);
          r28.xz = sin(-r22.zw);
          r28.y = r25.x;
          r24.y = dot(r28.yx, r13.yz);
          r28.w = r23.x;
          r22.y = dot(r28.wy, r13.yz);
          r28.x = r27.x;
          r28.y = r26.x;
          r24.x = dot(r28.xy, r22.xy);
          r24.z = dot(r28.zx, r22.xy);
          r22.y = s_LocalShadowMap.SampleCmpLevelZero(s_LocalShadowMap_sampler_s, r24.xyzw, r17.w).x;
          r19.w = r22.y + r19.w;
          r21.w = (int)r21.w + 1;
        }
        r13.y = -1 + r18.w;
        r13.y = saturate(-2.50000024 * r13.y);
        r13.z = r13.y * -2 + 3;
        r13.y = r13.y * r13.y;
        r13.y = r13.z * r13.y;
        r13.y = r19.w * 0.200000003 + r13.y;
        r13.y = min(1, r13.y);
        r13.y = -1 + r13.y;
        r16.w = abs(g_local_light_shadow_param[r14.w].w) * r13.y + 1;
      }
      if (r13.w != 0) {
        r13.yzw = g_local_light_data[r12.w/4]._m10_m11_m12 + -r8.xyz;
        r14.w = dot(r13.yzw, r13.yzw);
        r17.w = cmp(g_local_light_data[r12.w/4]._m13 < r14.w);
        r18.w = g_local_light_data[r12.w/4]._m00 + g_local_light_data[r12.w/4]._m01;
        r18.w = g_local_light_data[r12.w/4]._m02 + r18.w;
        r18.w = cmp(abs(r18.w) < 9.99999997e-007);
        r17.w = (int)r17.w | (int)r18.w;
        if (r17.w == 0) {
          r17.w = 256 & (int4)g_local_light_data[r12.w/4]._m33;
          r18.w = rsqrt(r14.w);
          r22.xyz = r18.www * r13.yzw;
          r21.w = dot(g_local_light_data[r12.w/4]._m20_m21_m22, -r22.xyz);
          r21.w = -g_local_light_data[r12.w/4]._m30 + r21.w;
          r21.w = saturate(g_local_light_data[r12.w/4]._m31 * r21.w);
          r21.w = r21.w * r21.w;
          r22.w = cmp(r21.w >= 9.99999997e-007);
          r22.w = r17.w ? r22.w : -1;
          if (r22.w != 0) {
            r23.xy = int2(16,32) & (int)g_local_light_data[r12.w/4]._m33;
            r22.w = r14.w / g_local_light_data[r12.w/4]._m13;
            r22.w = -r22.w * r22.w + 1;
            r22.w = max(0, r22.w);
            r22.w = r22.w * r22.w;
            r24.xyz = g_local_light_data[r12.w/4]._m00_m01_m02 * float3(0.0795774683,0.0795774683,0.0795774683);
            r12.w = r17.w ? r21.w : 1;
            r14.w = max(1, r14.w);
            r14.w = rcp(r14.w);
            r17.w = saturate(dot(r7.xyz, r22.xyz));
            r13.yzw = r13.yzw * r18.www + r10.xyz;
            r18.w = dot(r13.yzw, r13.yzw);
            r18.w = rsqrt(r18.w);
            r13.yzw = r18.www * r13.yzw;
            r18.w = saturate(dot(r13.yzw, r22.xyz));
            r18.w = 1 + -r18.w;
            r21.w = r18.w * r18.w;
            r21.w = r21.w * r21.w;
            r18.w = r21.w * r18.w;
            r22.xyz = r17.xyz * r18.www + r4.xzw;
            r14.w = r14.w * r22.w;
            r12.w = r14.w * r12.w;
            if (r23.y != 0) {
              r14.w = r16.w * r12.w;
              r13.y = saturate(dot(r7.xyz, r13.yzw));
              r13.z = -r13.y * r13.y + 1;
              r13.y = r13.y * r6.y;
              r13.y = r13.y * r13.y + r13.z;
              r13.y = r6.y / r13.y;
              r13.y = r13.y * r13.y;
              r13.y = 0.318309873 * r13.y;
              r13.z = r17.w * r3.z + r9.x;
              r13.z = r13.z * r9.z;
              r13.z = 0.25 / r13.z;
              r13.y = r13.y * r13.z;
              r13.yzw = saturate(r13.yyy * r22.xyz);
              r13.yzw = r13.yzw * r17.www;
              r13.yzw = r13.yzw * r24.xyz;
              r21.xyz = r14.www * r13.yzw + r21.xyz;
            }
            if (r23.x != 0) {
              r12.w = r16.w * r12.w;
              r13.yzw = r17.www * r24.xyz;
              r14.w = 1 + -r22.x;
              r14.w = r14.w * r10.w;
              r13.yzw = r14.www * r13.yzw;
              r18.xyz = r12.www * r13.yzw + r18.xyz;
            }
          }
        }
      }
      r11.y = (int)r11.y + 1;
    }
  } else {
    r18.xyz = float3(0,0,0);
    r21.xyz = float3(0,0,0);
  }
  r0.x = cmp((int)r0.z != 1);
  r0.x = r0.x ? r11.z : 0;
  if (r0.x != 0) {
    r0.x = round(g_debug_option.x);
    r0.x = (int)r0.x;
    r0.x = cmp((int)r0.x == 4);
    r0.x = r0.x ? 0 : r6.z;
    r3.z = min(r11.x, r6.z);
    r13.xy = float2(-1,0);
    r17.y = 0;
    r9.xy = float2(0,0);
    while (true) {
      r9.z = cmp((int)r17.y >= 3);
      r9.y = 0;
      if (r9.z != 0) break;
      r22.xyzw = mad((int4)r17.yyyy, int4(9,9,9,9), int4(5,6,7,8));
      r23.xyz = shlightfield_probes_SHLightFieldProbe[r22.y].xyz * r8.yyy;
      r23.xyz = r8.xxx * shlightfield_probes_SHLightFieldProbe[r22.x].xyz + r23.xyz;
      r22.xyz = r8.zzz * shlightfield_probes_SHLightFieldProbe[r22.z].xyz + r23.xyz;
      r22.xyz = shlightfield_probes_SHLightFieldProbe[r22.w].xyz + r22.xyz;
      r23.xyz = cmp(float3(0.5,0.5,0.5) >= abs(r22.xyz));
      r9.z = r23.y ? r23.x : 0;
      r9.z = r23.z ? r9.z : 0;
      if (r9.z != 0) {
        r9.x = r17.y;
        r9.y = -1;
        break;
      }
      r17.x = dot(abs(r22.xyz), abs(r22.xyz));
      r9.w = cmp(r13.x < 0);
      r11.y = cmp(r17.x < r13.x);
      r9.w = (int)r9.w | (int)r11.y;
      r13.xy = r9.ww ? r17.xy : r13.xy;
      r17.y = (int)r17.y + 1;
      r9.y = r9.z;
      r9.x = 0;
    }
    r9.x = r9.y ? r9.x : r13.y;
    r9.y = (int)r9.x * 9;
    r13.xyzw = mad((int4)r9.xxxx, int4(9,9,9,9), int4(5,6,7,8));
    r17.xyz = shlightfield_probes_SHLightFieldProbe[r13.y].xyz * r8.yyy;
    r17.xyz = r8.xxx * shlightfield_probes_SHLightFieldProbe[r13.x].xyz + r17.xyz;
    r17.xyz = r8.zzz * shlightfield_probes_SHLightFieldProbe[r13.z].xyz + r17.xyz;
    r17.xyz = shlightfield_probes_SHLightFieldProbe[r13.w].xyz + r17.xyz;
    r22.xyz = saturate(float3(0.5,0.5,0.5) + r17.xyz);
    r23.xyz = shlightfield_probes_SHLightFieldProbe[r13.y].xyz * r7.yyy;
    r13.xyw = r7.xxx * shlightfield_probes_SHLightFieldProbe[r13.x].xyz + r23.xyz;
    r13.xyz = r7.zzz * shlightfield_probes_SHLightFieldProbe[r13.z].xyz + r13.xyw;
    r9.z = dot(r13.xyz, r13.xyz);
    r9.z = rsqrt(r9.z);
    r13.xyz = r13.xyz * r9.zzz;
    r13.xyz = shlightfield_param.zzz * r13.xyz;
    r13.xyz = r22.xyz * shlightfield_probes_SHLightFieldProbe[r9.y].xyz + r13.xyz;
    r13.xyz = r13.xyz / shlightfield_probes_SHLightFieldProbe[r9.y].xyz;
    r9.yzw = float3(1,1,1) / shlightfield_probes_SHLightFieldProbe[r9.y].xyz;
    r22.xyz = float3(0.5,0.5,0.5) * r9.yzw;
    r9.yzw = -r9.yzw * float3(0.5,0.5,0.5) + float3(1,1,1);
    r13.xyz = max(r22.xyz, r13.xyz);
    r13.xyz = min(r13.xyz, r9.yzw);
    x0[0].xyz = float3(0,0,0);
    x0[1].xyz = float3(0,0,0);
    x0[2].xyz = float3(0,0,0);
    x0[3].xyz = float3(0,0,0);
    x0[4].xyz = float3(0,0,0);
    x0[5].xyz = float3(0,0,0);
    if (r9.x == 0) {
      r13.w = 0.111111112 * r13.x;
      r9.yzw = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r13.wyz, 0).xyz;
      x0[0].xyz = r9.yzw;
      r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.111111112,0,0);
      r9.yzw = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r9.yzw, 0).xyz;
      x0[1].xyz = r9.yzw;
      r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.222222224,0,0);
      r9.yzw = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r9.yzw, 0).xyz;
      x0[2].xyz = r9.yzw;
      r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.333333343,0,0);
      r9.yzw = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r9.yzw, 0).xyz;
      x0[3].xyz = r9.yzw;
      r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.444444448,0,0);
      r9.yzw = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r9.yzw, 0).xyz;
      x0[4].xyz = r9.yzw;
      r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.555555582,0,0);
      r9.yzw = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r9.yzw, 0).xyz;
      x0[5].xyz = r9.yzw;
    } else {
      r9.y = cmp((int)r9.x == 1);
      if (r9.y != 0) {
        r9.yzw = float3(0.111111112,1,1) * r13.xyz;
        r9.yzw = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r9.yzw, 0).xyz;
        x0[0].xyz = r9.yzw;
        r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.111111112,0,0);
        r9.yzw = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r9.yzw, 0).xyz;
        x0[1].xyz = r9.yzw;
        r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.222222224,0,0);
        r9.yzw = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r9.yzw, 0).xyz;
        x0[2].xyz = r9.yzw;
        r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.333333343,0,0);
        r9.yzw = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r9.yzw, 0).xyz;
        x0[3].xyz = r9.yzw;
        r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.444444448,0,0);
        r9.yzw = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r9.yzw, 0).xyz;
        x0[4].xyz = r9.yzw;
        r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.555555582,0,0);
        r9.yzw = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r9.yzw, 0).xyz;
        x0[5].xyz = r9.yzw;
      } else {
        r9.y = cmp((int)r9.x == 2);
        if (r9.y != 0) {
          r9.yzw = float3(0.111111112,1,1) * r13.xyz;
          r9.yzw = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r9.yzw, 0).xyz;
          x0[0].xyz = r9.yzw;
          r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.111111112,0,0);
          r9.yzw = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r9.yzw, 0).xyz;
          x0[1].xyz = r9.yzw;
          r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.222222224,0,0);
          r9.yzw = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r9.yzw, 0).xyz;
          x0[2].xyz = r9.yzw;
          r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.333333343,0,0);
          r9.yzw = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r9.yzw, 0).xyz;
          x0[3].xyz = r9.yzw;
          r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.444444448,0,0);
          r9.yzw = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r9.yzw, 0).xyz;
          x0[4].xyz = r9.yzw;
          r9.yzw = r13.xyz * float3(0.111111112,1,1) + float3(0.555555582,0,0);
          r9.yzw = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r9.yzw, 0).xyz;
          x0[5].xyz = r9.yzw;
        }
      }
    }
    r9.x = mad((int)r9.x, 9, 1);
    r9.x = shlightfield_probes_SHLightFieldProbe[r9.x].x + 0.5;
    r9.x = floor(r9.x);
    r9.x = (uint)r9.x;
    if (r9.x == 0) {
      r9.yzw = x0[0].xyz;
      r13.xyz = r7.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(3,0,0);
      r11.y = dot(r13.xyz, r13.xyz);
      r11.y = sqrt(r11.y);
      r9.yzw = float3(14.7026539,14.7026539,14.7026539) * r9.yzw;
      r13.xy = float2(1.44269502,169.524918) * r11.yy;
      r11.y = exp2(r13.x);
      r12.w = exp2(-r13.x);
      r11.y = -r12.w + r11.y;
      r11.y = 0.5 * r11.y;
      r9.yzw = r11.yyy * r9.yzw;
      r9.yzw = r9.yzw / r13.yyy;
      r13.xyz = x0[1].xyz;
      r22.xyz = r7.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(-3,0,0);
      r11.y = dot(r22.xyz, r22.xyz);
      r11.y = sqrt(r11.y);
      r13.xyz = float3(14.7026539,14.7026539,14.7026539) * r13.xyz;
      r22.xy = float2(1.44269502,169.524918) * r11.yy;
      r11.y = exp2(r22.x);
      r12.w = exp2(-r22.x);
      r11.y = -r12.w + r11.y;
      r11.y = 0.5 * r11.y;
      r13.xyz = r13.xyz * r11.yyy;
      r13.xyz = r13.xyz / r22.yyy;
      r9.yzw = r13.xyz + r9.yzw;
      r13.xyz = x0[2].xyz;
      r22.xyz = r7.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(0,3,0);
      r11.y = dot(r22.xyz, r22.xyz);
      r11.y = sqrt(r11.y);
      r13.xyz = float3(14.7026539,14.7026539,14.7026539) * r13.xyz;
      r22.xy = float2(1.44269502,169.524918) * r11.yy;
      r11.y = exp2(r22.x);
      r12.w = exp2(-r22.x);
      r11.y = -r12.w + r11.y;
      r11.y = 0.5 * r11.y;
      r13.xyz = r13.xyz * r11.yyy;
      r13.xyz = r13.xyz / r22.yyy;
      r9.yzw = r13.xyz + r9.yzw;
      r13.xyz = x0[3].xyz;
      r22.xyz = r7.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(0,-3,0);
      r11.y = dot(r22.xyz, r22.xyz);
      r11.y = sqrt(r11.y);
      r13.xyz = float3(14.7026539,14.7026539,14.7026539) * r13.xyz;
      r22.xy = float2(1.44269502,169.524918) * r11.yy;
      r11.y = exp2(r22.x);
      r12.w = exp2(-r22.x);
      r11.y = -r12.w + r11.y;
      r11.y = 0.5 * r11.y;
      r13.xyz = r13.xyz * r11.yyy;
      r13.xyz = r13.xyz / r22.yyy;
      r9.yzw = r13.xyz + r9.yzw;
      r13.xyz = x0[4].xyz;
      r22.xyz = r7.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(0,0,3);
      r11.y = dot(r22.xyz, r22.xyz);
      r11.y = sqrt(r11.y);
      r13.xyz = float3(14.7026539,14.7026539,14.7026539) * r13.xyz;
      r22.xy = float2(1.44269502,169.524918) * r11.yy;
      r11.y = exp2(r22.x);
      r12.w = exp2(-r22.x);
      r11.y = -r12.w + r11.y;
      r11.y = 0.5 * r11.y;
      r13.xyz = r13.xyz * r11.yyy;
      r13.xyz = r13.xyz / r22.yyy;
      r9.yzw = r13.xyz + r9.yzw;
      r13.xyz = x0[5].xyz;
      r22.xyz = r7.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(0,0,-3);
      r11.y = dot(r22.xyz, r22.xyz);
      r11.y = sqrt(r11.y);
      r13.xyz = float3(14.7026539,14.7026539,14.7026539) * r13.xyz;
      r22.xy = float2(1.44269502,169.524918) * r11.yy;
      r11.y = exp2(r22.x);
      r12.w = exp2(-r22.x);
      r11.y = -r12.w + r11.y;
      r11.y = 0.5 * r11.y;
      r13.xyz = r13.xyz * r11.yyy;
      r13.xyz = r13.xyz / r22.yyy;
      r9.yzw = r13.xyz + r9.yzw;
      r13.xyz = float3(0.318309873,0.318309873,0.318309873) * r9.yzw;
      if (r2.w != 0) {
        r22.xyz = r7.yzx * r7.yzy;
        r23.xyz = float3(-1.02381635,-1.02381635,-1.02381635) * r7.yzx;
        r24.xy = -r7.zz * r7.yx;
        r11.y = 0.858085036 * r22.z;
        r12.w = r22.y * 3 + -1;
        r12.w = 0.247708231 * r12.w;
        r22.yz = float2(-0.858085036,-0.858085036) * r24.xy;
        r13.w = r7.x * r7.x + -r22.x;
        r13.w = 0.429042518 * r13.w;
        r22.xw = (int2)u_tile_info.zw;
        r22.xw = (int2)r22.xw + int2(15,15);
        r22.xw = (uint2)r22.xw >> int2(4,4);
        r22.xw = cmp((int2)r1.xy < (int2)r22.xw);
        r14.w = r22.w ? r22.x : 0;
        r22.xw = (uint2)u_tile_info.xy;
        r16.w = mad((int)r1.y, (int)r22.x, (int)r1.x);
        r16.w = mad((int)r16.w, 3, 2);
        r17.w = s_LocalLightIndexData[r16.w].x;
        r17.w = (int)r17.w & 0x0000ffff;
        r24.x = min(64, (uint)r17.w);
        r16.w = (uint)r16.w << 6;
        r24.y = (int)r16.w + (int)r22.w;
        r22.xw = (int2)r14.ww & (int2)r24.xy;
        r8.w = 1;
        r24.xyz = float3(0,0,0);
        r14.w = 1;
        r16.w = 0;
        while (true) {
          r17.w = cmp((uint)r16.w >= (uint)r22.x);
          if (r17.w != 0) break;
          r17.w = (int)r16.w + (int)r22.w;
          r17.w = s_LocalLightIndexData[r17.w].x;
          r17.w = (int)r17.w & 0x0000ffff;
          r18.w = (uint)g_probe_param[r17.w].x >> 1;
          r25.xy = cmp((int2)r18.ww == int2(3,2));
          r18.w = (int)r25.y | (int)r25.x;
          if (r18.w != 0) {
            r25.xyz = -g_probe_pos[r17.w].xyz + r8.xyz;
            r18.w = dot(r25.xyz, r25.xyz);
            r18.w = sqrt(r18.w);
            r18.w = r18.w / g_probe_param[r17.w].z;
          } else {
            r19.w = (int)r17.w * 3;
            r21.w = dot(g_probe_data[r19.w].xyzw, r8.xyzw);
            r23.w = dot(g_probe_data[r19.w+1].xyzw, r8.xyzw);
            r19.w = dot(g_probe_data[r19.w+2].xyzw, r8.xyzw);
            r21.w = max(abs(r23.w), abs(r21.w));
            r18.w = max(r21.w, abs(r19.w));
          }
          r19.w = cmp(r18.w < 0.99000001);
          r21.w = max(g_probe_param[r17.w].y, 0.00999999978);
          r21.w = min(0.99000001, r21.w);
          r21.w = 1 + -r21.w;
          r21.w = 1 / r21.w;
          r18.w = -g_probe_param[r17.w].y + r18.w;
          r18.w = saturate(-r21.w * r18.w + 1);
          r18.w = r19.w ? r18.w : 0;
          r19.w = cmp(0 < r18.w);
          if (r19.w != 0) {
            r17.w = (int)r17.w * 7;
            r25.x = g_probe_shparam[r17.w].w * r23.x;
            r25.yz = g_probe_shparam[r17.w+1].xy * r23.xx;
            r25.xyz = g_probe_shparam[r17.w].xyz * float3(0.886227667,0.886227667,0.886227667) + r25.xyz;
            r26.xy = g_probe_shparam[r17.w+1].zw * r23.yy;
            r26.z = g_probe_shparam[r17.w+2].x * r23.y;
            r25.xyz = r26.xyz + r25.xyz;
            r25.xyz = r23.zzz * g_probe_shparam[r17.w+2].yzw + r25.xyz;
            r25.xyz = r11.yyy * g_probe_shparam[r17.w+3].xyz + r25.xyz;
            r26.x = g_probe_shparam[r17.w+3].w * r22.y;
            r26.yz = g_probe_shparam[r17.w+4].xy * r22.yy;
            r25.xyz = r26.xyz + r25.xyz;
            r26.xy = g_probe_shparam[r17.w+4].zw * r12.ww;
            r26.z = g_probe_shparam[r17.w+5].x * r12.w;
            r25.xyz = r26.xyz + r25.xyz;
            r25.xyz = r22.zzz * g_probe_shparam[r17.w+5].yzw + r25.xyz;
            r25.xyz = r13.www * g_probe_shparam[r17.w+6].xyz + r25.xyz;
            r25.xyz = float3(0.318309873,0.318309873,0.318309873) * r25.xyz;
            r17.w = min(r18.w, r14.w);
            r25.xyz = r25.xyz * r17.www + r24.xyz;
            r14.w = -r17.w + r14.w;
            r17.w = cmp(0 >= r14.w);
            if (r17.w != 0) {
              r24.xyz = r25.xyz;
              break;
            }
            r24.xyz = r25.xyz;
          }
          r16.w = (int)r16.w + 1;
        }
        r25.xyz = u_sky_sh_param[1].xyz * r23.xxx;
        r25.xyz = u_sky_sh_param[0].xyz * float3(0.886227667,0.886227667,0.886227667) + r25.xyz;
        r23.xyw = r23.yyy * u_sky_sh_param[2].xyz + r25.xyz;
        r23.xyz = r23.zzz * u_sky_sh_param[3].xyz + r23.xyw;
        r23.xyz = r11.yyy * u_sky_sh_param[4].xyz + r23.xyz;
        r22.xyw = r22.yyy * u_sky_sh_param[5].xyz + r23.xyz;
        r22.xyw = r12.www * u_sky_sh_param[6].xyz + r22.xyw;
        r22.xyz = r22.zzz * u_sky_sh_param[7].xyz + r22.xyw;
        r22.xyz = r13.www * u_sky_sh_param[8].xyz + r22.xyz;
        r22.xyz = r22.xyz * r3.zzz;
        r22.xyz = float3(0.318309873,0.318309873,0.318309873) * r22.xyz;
        r11.y = r3.z * -u_sggi_param[1].w + u_sggi_param[1].w;
        r22.xyz = r24.xyz * r11.yyy + r22.xyz;
        r13.xyz = r9.yzw * float3(0.318309873,0.318309873,0.318309873) + r22.xyz;
      }
    } else {
      if (r2.w != 0) {
        r9.yzw = r7.yzx * r7.yzy;
        r22.xyz = float3(-1.02381635,-1.02381635,-1.02381635) * r7.yzx;
        r23.xy = -r7.zz * r7.yx;
        r9.z = r9.z * 3 + -1;
        r23.xy = float2(-0.858085036,-0.858085036) * r23.xy;
        r9.y = r7.x * r7.x + -r9.y;
        r9.yzw = float3(0.429042518,0.247708231,0.858085036) * r9.yzw;
        r23.zw = (int2)u_tile_info.zw;
        r23.zw = (int2)r23.zw + int2(15,15);
        r23.zw = (uint2)r23.zw >> int2(4,4);
        r23.zw = cmp((int2)r1.xy < (int2)r23.zw);
        r11.y = r23.w ? r23.z : 0;
        r23.zw = (uint2)u_tile_info.xy;
        r12.w = mad((int)r1.y, (int)r23.z, (int)r1.x);
        r12.w = mad((int)r12.w, 3, 2);
        r13.w = s_LocalLightIndexData[r12.w].x;
        r13.w = (int)r13.w & 0x0000ffff;
        r24.x = min(64, (uint)r13.w);
        r12.w = (uint)r12.w << 6;
        r24.y = (int)r12.w + (int)r23.w;
        r23.zw = (int2)r11.yy & (int2)r24.xy;
        r8.w = 1;
        r24.xyz = float3(0,0,0);
        r11.y = 1;
        r12.w = 0;
        while (true) {
          r13.w = cmp((uint)r12.w >= (uint)r23.z);
          if (r13.w != 0) break;
          r13.w = (int)r12.w + (int)r23.w;
          r13.w = s_LocalLightIndexData[r13.w].x;
          r13.w = (int)r13.w & 0x0000ffff;
          r14.w = (uint)g_probe_param[r13.w].x >> 1;
          r25.xy = cmp((int2)r14.ww == int2(3,2));
          r14.w = (int)r25.y | (int)r25.x;
          if (r14.w != 0) {
            r25.xyz = -g_probe_pos[r13.w].xyz + r8.xyz;
            r14.w = dot(r25.xyz, r25.xyz);
            r14.w = sqrt(r14.w);
            r14.w = r14.w / g_probe_param[r13.w].z;
          } else {
            r16.w = (int)r13.w * 3;
            r17.w = dot(g_probe_data[r16.w].xyzw, r8.xyzw);
            r18.w = dot(g_probe_data[r16.w+1].xyzw, r8.xyzw);
            r16.w = dot(g_probe_data[r16.w+2].xyzw, r8.xyzw);
            r17.w = max(abs(r18.w), abs(r17.w));
            r14.w = max(r17.w, abs(r16.w));
          }
          r16.w = cmp(r14.w < 0.99000001);
          r17.w = max(g_probe_param[r13.w].y, 0.00999999978);
          r17.w = min(0.99000001, r17.w);
          r17.w = 1 + -r17.w;
          r17.w = 1 / r17.w;
          r14.w = -g_probe_param[r13.w].y + r14.w;
          r14.w = saturate(-r17.w * r14.w + 1);
          r14.w = r16.w ? r14.w : 0;
          r16.w = cmp(0 < r14.w);
          if (r16.w != 0) {
            r13.w = (int)r13.w * 7;
            r25.x = g_probe_shparam[r13.w].w * r22.x;
            r25.yz = g_probe_shparam[r13.w+1].xy * r22.xx;
            r25.xyz = g_probe_shparam[r13.w].xyz * float3(0.886227667,0.886227667,0.886227667) + r25.xyz;
            r26.xy = g_probe_shparam[r13.w+1].zw * r22.yy;
            r26.z = g_probe_shparam[r13.w+2].x * r22.y;
            r25.xyz = r26.xyz + r25.xyz;
            r25.xyz = r22.zzz * g_probe_shparam[r13.w+2].yzw + r25.xyz;
            r25.xyz = r9.www * g_probe_shparam[r13.w+3].xyz + r25.xyz;
            r26.x = g_probe_shparam[r13.w+3].w * r23.x;
            r26.yz = g_probe_shparam[r13.w+4].xy * r23.xx;
            r25.xyz = r26.xyz + r25.xyz;
            r26.xy = g_probe_shparam[r13.w+4].zw * r9.zz;
            r26.z = g_probe_shparam[r13.w+5].x * r9.z;
            r25.xyz = r26.xyz + r25.xyz;
            r25.xyz = r23.yyy * g_probe_shparam[r13.w+5].yzw + r25.xyz;
            r25.xyz = r9.yyy * g_probe_shparam[r13.w+6].xyz + r25.xyz;
            r25.xyz = float3(0.318309873,0.318309873,0.318309873) * r25.xyz;
            r13.w = min(r14.w, r11.y);
            r25.xyz = r25.xyz * r13.www + r24.xyz;
            r11.y = -r13.w + r11.y;
            r13.w = cmp(0 >= r11.y);
            if (r13.w != 0) {
              r24.xyz = r25.xyz;
              break;
            }
            r24.xyz = r25.xyz;
          }
          r12.w = (int)r12.w + 1;
        }
        r25.xyz = u_sky_sh_param[1].xyz * r22.xxx;
        r25.xyz = u_sky_sh_param[0].xyz * float3(0.886227667,0.886227667,0.886227667) + r25.xyz;
        r22.xyw = r22.yyy * u_sky_sh_param[2].xyz + r25.xyz;
        r22.xyz = r22.zzz * u_sky_sh_param[3].xyz + r22.xyw;
        r22.xyz = r9.www * u_sky_sh_param[4].xyz + r22.xyz;
        r22.xyz = r23.xxx * u_sky_sh_param[5].xyz + r22.xyz;
        r22.xyz = r9.zzz * u_sky_sh_param[6].xyz + r22.xyz;
        r22.xyz = r23.yyy * u_sky_sh_param[7].xyz + r22.xyz;
        r9.yzw = r9.yyy * u_sky_sh_param[8].xyz + r22.xyz;
        r9.yzw = r9.yzw * r3.zzz;
        r9.yzw = float3(0.318309873,0.318309873,0.318309873) * r9.yzw;
        r11.y = r3.z * -u_sggi_param[1].w + u_sggi_param[1].w;
        r13.xyz = r24.xyz * r11.yyy + r9.yzw;
      } else {
        r9.x = cmp((int)r9.x == 2);
        if (r9.x != 0) {
          r9.xyz = cmp(float3(0.5,0.5,0.5) >= abs(r17.xyz));
          r9.x = r9.y ? r9.x : 0;
          r9.x = r9.z ? r9.x : 0;
          r9.x = r9.x ? 0 : 6;
          r9.y = 0;
          while (true) {
            r9.z = cmp((uint)r9.y >= (uint)r9.x);
            if (r9.z != 0) break;
            x0[r9.y+0].x = 1;
            r9.y = (int)r9.y + 1;
          }
          r9.yzw = r7.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
          r17.xyzw = r7.xyzx * r7.xyzy;
          r11.y = x0[1].x;
          r12.w = x0[0].x;
          r12.w = r12.w + -r11.y;
          r9.y = r9.y * r12.w + r11.y;
          r11.y = x0[3].x;
          r12.w = x0[2].x;
          r12.w = r12.w + -r11.y;
          r9.z = r9.z * r12.w + r11.y;
          r9.z = r17.y * r9.z;
          r9.y = r17.x * r9.y + r9.z;
          r9.z = x0[5].x;
          r11.y = x0[4].x;
          r11.y = r11.y + -r9.z;
          r9.z = r9.w * r11.y + r9.z;
          r9.y = saturate(r17.z * r9.z + r9.y);
          r3.z = min(r9.y, r3.z);
          r9.xyz = float3(-1.02381635,-1.02381635,-1.02381635) * r7.yzx;
          r22.xy = -r7.zz * r7.yx;
          r9.w = 0.858085036 * r17.w;
          r11.y = r17.z * 3 + -1;
          r11.y = 0.247708231 * r11.y;
          r17.xz = float2(-0.858085036,-0.858085036) * r22.xy;
          r12.w = r7.x * r7.x + -r17.y;
          r12.w = 0.429042518 * r12.w;
          r17.yw = (int2)u_tile_info.zw;
          r17.yw = (int2)r17.yw + int2(15,15);
          r17.yw = (uint2)r17.yw >> int2(4,4);
          r17.yw = cmp((int2)r1.xy < (int2)r17.yw);
          r13.w = r17.w ? r17.y : 0;
          r17.yw = (uint2)u_tile_info.xy;
          r14.w = mad((int)r1.y, (int)r17.y, (int)r1.x);
          r14.w = mad((int)r14.w, 3, 2);
          r16.w = s_LocalLightIndexData[r14.w].x;
          r16.w = r16.w ? 0.000000 : 0;
          r22.x = min(64, (uint)r16.w);
          r14.w = (uint)r14.w << 6;
          r22.y = (int)r14.w + (int)r17.w;
          r17.yw = r13.ww ? r22.xy : 0;
          r8.w = 1;
          r22.xyz = float3(0,0,0);
          r13.w = 1;
          r14.w = 0;
          while (true) {
            r16.w = cmp((uint)r14.w >= (uint)r17.y);
            if (r16.w != 0) break;
            r16.w = (int)r14.w + (int)r17.w;
            r16.w = s_LocalLightIndexData[r16.w].x;
            r16.w = (int)r16.w & 0x0000ffff;
            r18.w = (uint)g_probe_param[r16.w].x >> 1;
            r23.xy = cmp((int2)r18.ww == int2(3,2));
            r18.w = (int)r23.y | (int)r23.x;
            if (r18.w != 0) {
              r23.xyz = -g_probe_pos[r16.w].xyz + r8.xyz;
              r18.w = dot(r23.xyz, r23.xyz);
              r18.w = sqrt(r18.w);
              r18.w = r18.w / g_probe_param[r16.w].z;
            } else {
              r19.w = (int)r16.w * 3;
              r21.w = dot(g_probe_data[r19.w].xyzw, r8.xyzw);
              r22.w = dot(g_probe_data[r19.w+1].xyzw, r8.xyzw);
              r19.w = dot(g_probe_data[r19.w+2].xyzw, r8.xyzw);
              r21.w = max(abs(r22.w), abs(r21.w));
              r18.w = max(r21.w, abs(r19.w));
            }
            r19.w = cmp(r18.w < 0.99000001);
            r21.w = max(g_probe_param[r16.w].y, 0.00999999978);
            r21.w = min(0.99000001, r21.w);
            r21.w = 1 + -r21.w;
            r21.w = 1 / r21.w;
            r18.w = -g_probe_param[r16.w].y + r18.w;
            r18.w = saturate(-r21.w * r18.w + 1);
            r18.w = r19.w ? r18.w : 0;
            r19.w = cmp(0 < r18.w);
            if (r19.w != 0) {
              r16.w = (int)r16.w * 7;
              r23.x = g_probe_shparam[r16.w].w * r9.x;
              r23.yz = g_probe_shparam[r16.w+1].xy * r9.xx;
              r23.xyz = g_probe_shparam[r16.w].xyz * float3(0.886227667,0.886227667,0.886227667) + r23.xyz;
              r24.xy = g_probe_shparam[r16.w+1].zw * r9.yy;
              r24.z = g_probe_shparam[r16.w+2].x * r9.y;
              r23.xyz = r24.xyz + r23.xyz;
              r23.xyz = r9.zzz * g_probe_shparam[r16.w+2].yzw + r23.xyz;
              r23.xyz = r9.www * g_probe_shparam[r16.w+3].xyz + r23.xyz;
              r24.x = g_probe_shparam[r16.w+3].w * r17.x;
              r24.yz = g_probe_shparam[r16.w+4].xy * r17.xx;
              r23.xyz = r24.xyz + r23.xyz;
              r24.xy = g_probe_shparam[r16.w+4].zw * r11.yy;
              r24.z = g_probe_shparam[r16.w+5].x * r11.y;
              r23.xyz = r24.xyz + r23.xyz;
              r23.xyz = r17.zzz * g_probe_shparam[r16.w+5].yzw + r23.xyz;
              r23.xyz = r12.www * g_probe_shparam[r16.w+6].xyz + r23.xyz;
              r23.xyz = float3(0.318309873,0.318309873,0.318309873) * r23.xyz;
              r16.w = min(r18.w, r13.w);
              r23.xyz = r23.xyz * r16.www + r22.xyz;
              r13.w = -r16.w + r13.w;
              r16.w = cmp(0 >= r13.w);
              if (r16.w != 0) {
                r22.xyz = r23.xyz;
                break;
              }
              r22.xyz = r23.xyz;
            }
            r14.w = (int)r14.w + 1;
          }
          r23.xyz = u_sky_sh_param[1].xyz * r9.xxx;
          r23.xyz = u_sky_sh_param[0].xyz * float3(0.886227667,0.886227667,0.886227667) + r23.xyz;
          r23.xyz = r9.yyy * u_sky_sh_param[2].xyz + r23.xyz;
          r9.xyz = r9.zzz * u_sky_sh_param[3].xyz + r23.xyz;
          r9.xyz = r9.www * u_sky_sh_param[4].xyz + r9.xyz;
          r9.xyz = r17.xxx * u_sky_sh_param[5].xyz + r9.xyz;
          r9.xyz = r11.yyy * u_sky_sh_param[6].xyz + r9.xyz;
          r9.xyz = r17.zzz * u_sky_sh_param[7].xyz + r9.xyz;
          r9.xyz = r12.www * u_sky_sh_param[8].xyz + r9.xyz;
          r9.xyz = r9.xyz * r3.zzz;
          r9.xyz = float3(0.318309873,0.318309873,0.318309873) * r9.xyz;
          r3.z = r3.z * -u_sggi_param[1].w + u_sggi_param[1].w;
          r13.xyz = r22.xyz * r3.zzz + r9.xyz;
        } else {
          r13.xyz = float3(0,0,0);
        }
      }
    }
    r9.xyz = max(float3(0,0,0), r13.xyz);
    r13.xyz = -shlightfield_multiply_color_down.xyz + shlightfield_multiply_color_up.xyz;
    r13.xyz = r4.yyy * r13.xyz + shlightfield_multiply_color_down.xyz;
    r13.xyz = shlightfield_param.yyy * r13.xyz;
    r9.xyz = r13.xyz * r9.xyz;
    r0.x = r0.x * r10.w;
    r13.xyz = float3(1,1,1) + -r4.xzw;
    r13.xyz = r13.xyz * r0.xxx;
    r9.xyz = r13.xyz * r9.xyz;
  } else {
    r9.xyz = float3(0,0,0);
  }
  r0.x = (uint)r1.w;
  r0.x = min(1, r0.x);
  r1.w = (int)r0.x;
  r13.xyzw = round(g_debug_option.yyyx);
  r17.xyzw = (int4)r13.wxyz;
  r1.w = (int)-r1.w + 1;
  r1.w = (int)r1.w;
  r22.xyzw = cmp((int4)r17.yzwx == int4(1,2,3,3));
  r3.z = -u_sggi_param[0].x + r6.y;
  r3.z = saturate(u_sggi_param[0].y * r3.z);
  r10.w = -r3.z * r0.x + 1;
  r10.w = r22.z ? r10.w : r6.z;
  r10.w = r22.y ? 1 : r10.w;
  r1.w = r22.x ? r1.w : r10.w;
  r10.w = 1 + -r1.w;
  r10.w = r6.w * r10.w + r1.w;
  r1.w = r11.w ? r10.w : r1.w;
  r9.w = r3.w ? 0 : r1.w;
  r13.xyz = cmp((int3)r17.xxx == int3(43,19,44));
  r1.w = (int)r13.x | (int)r22.w;
  r1.w = (int)r13.y | (int)r1.w;
  r1.w = (int)r13.z | (int)r1.w;
  r17.yzw = r13.xxx ? r11.xxx : r9.xyz;
  r23.xyz = r13.zzz ? float3(0,0,0) : r17.yzw;
  r23.w = 0;
  r9.xyzw = r1.wwww ? r23.xyzw : r9.xyzw;
  r1.w = cmp(9.99999975e-006 < r9.w);
  if (r1.w != 0) {
    r1.w = r20.x + r20.x;
    r13.xyz = r1.www * r7.xyz + -r10.xyz;
    r1.w = dot(r13.xyz, r13.xyz);
    r1.w = rsqrt(r1.w);
    r10.w = saturate(1 + -r6.y);
    r11.y = sqrt(r10.w);
    r11.y = r11.y + r6.y;
    r10.w = r11.y * r10.w;
    r13.xyz = r13.xyz * r1.www + -r7.xyz;
    r23.xyz = r10.www * r13.xyz + r7.xyz;
    r1.w = saturate(r6.y);
    r1.w = sqrt(r1.w);
    r1.w = 6 * r1.w;
    r11.yw = (int2)u_tile_info.zw;
    r11.yw = (int2)r11.yw + int2(15,15);
    r11.yw = (uint2)r11.yw >> int2(4,4);
    r11.yw = cmp((int2)r1.xy < (int2)r11.yw);
    r10.w = r11.w ? r11.y : 0;
    r11.yw = (uint2)u_tile_info.xy;
    r11.y = mad((int)r1.y, (int)r11.y, (int)r1.x);
    r11.y = mad((int)r11.y, 3, 2);
    r12.w = s_LocalLightIndexData[r11.y].x;
    r12.w = (int)r12.w & 0x0000ffff;
    r13.x = min(64, (uint)r12.w);
    r11.y = (uint)r11.y << 6;
    r13.y = (int)r11.y + (int)r11.w;
    r11.yw = (int2)r10.ww & (int2)r13.xy;
    r24.xyz = r8.xyz;
    r24.w = 1;
    r8.w = 1;
    r13.xyz = float3(0,0,0);
    r10.w = 0;
    r12.w = 0;
    r14.w = 0;
    while (true) {
      r16.w = cmp((uint)r14.w < (uint)r11.y);
      r17.y = cmp(r12.w < 1);
      r16.w = r16.w ? r17.y : 0;
      r17.y = cmp(r10.w < 1);
      r16.w = r16.w ? r17.y : 0;
      if (r16.w == 0) break;
      r16.w = (int)r11.w + (int)r14.w;
      r16.w = s_LocalLightIndexData[r16.w].x;
      r16.w = (int)r16.w & 0x0000ffff;
      r17.y = (uint)g_probe_param[r16.w].x >> 1;
      r17.z = cmp((int)r17.y == 1);
      if (r17.z != 0) {
        r17.z = (int)r16.w * 3;
        r25.x = dot(g_probe_data[r17.z].xyzw, r24.xyzw);
        r25.y = dot(g_probe_data[r17.z+1].xyzw, r24.xyzw);
        r25.z = dot(g_probe_data[r17.z+2].xyzw, r24.xyzw);
        r17.w = max(abs(r25.x), abs(r25.y));
        r17.w = max(r17.w, abs(r25.z));
        r18.w = cmp(r17.w < 0.99000001);
        r19.w = max(g_probe_param[r16.w].y, 0.00999999978);
        r19.w = min(0.99000001, r19.w);
        r19.w = 1 + -r19.w;
        r19.w = 1 / r19.w;
        r17.w = -g_probe_param[r16.w].y + r17.w;
        r17.w = saturate(-r19.w * r17.w + 1);
        r17.w = r18.w ? r17.w : 0;
        r18.w = cmp(0 < r17.w);
        if (r18.w != 0) {
          r26.x = dot(g_probe_data[r17.z].xyz, r23.xyz);
          r26.y = dot(g_probe_data[r17.z+1].xyz, r23.xyz);
          r26.z = dot(g_probe_data[r17.z+2].xyz, r23.xyz);
          r27.xyz = float3(1,1,1) + -r25.xyz;
          r27.xyz = r27.xyz / r26.xyz;
          r25.xyz = float3(-1,-1,-1) + -r25.xyz;
          r25.xyz = r25.xyz / r26.xyz;
          r25.xyz = max(r27.xyz, r25.xyz);
          r17.z = min(r25.y, r25.z);
          r17.z = min(r25.x, r17.z);
          r25.xyz = r23.xyz * r17.zzz + r8.xyz;
          r25.xyz = -g_probe_pos[r16.w].xyz + r25.xyz;
        } else {
          r25.xyz = r23.xyz;
        }
      } else {
        r17.z = cmp((int)r17.y == 3);
        if (r17.z != 0) {
          r26.xyz = -g_probe_pos[r16.w].xyz + r8.xyz;
          r17.z = dot(r26.xyz, r26.xyz);
          r18.w = sqrt(r17.z);
          r19.w = r18.w / g_probe_param[r16.w].z;
          r21.w = cmp(r19.w < 0.99000001);
          r22.y = max(g_probe_param[r16.w].y, 0.00999999978);
          r22.y = min(0.99000001, r22.y);
          r22.y = 1 + -r22.y;
          r22.y = 1 / r22.y;
          r19.w = -g_probe_param[r16.w].y + r19.w;
          r19.w = saturate(-r22.y * r19.w + 1);
          r17.w = r21.w ? r19.w : 0;
          r19.w = cmp(0 < r17.w);
          r26.xyz = r26.xyz / r18.www;
          r21.w = dot(r26.xyz, -r23.xyz);
          r22.y = r21.w * r18.w;
          r17.z = -r22.y * r22.y + r17.z;
          r17.z = sqrt(r17.z);
          r17.z = r17.z * r17.z;
          r17.z = g_probe_param[r16.w].z * g_probe_param[r16.w].z + -r17.z;
          r17.z = sqrt(r17.z);
          r17.z = r21.w * r18.w + r17.z;
          r26.xyz = r23.xyz * r17.zzz + r8.xyz;
          r26.xyz = -g_probe_pos[r16.w].xyz + r26.xyz;
          r25.xyz = r19.www ? r26.xyz : r23.xyz;
        } else {
          r17.z = cmp((int)r17.y == 2);
          if (r17.z != 0) {
            r26.xyz = -g_probe_pos[r16.w].xyz + r8.xyz;
            r17.z = dot(r26.xyz, r26.xyz);
            r17.z = sqrt(r17.z);
            r17.z = r17.z / g_probe_param[r16.w].z;
            r18.w = cmp(r17.z < 0.99000001);
            r19.w = max(g_probe_param[r16.w].y, 0.00999999978);
            r19.w = min(0.99000001, r19.w);
            r19.w = 1 + -r19.w;
            r19.w = 1 / r19.w;
            r17.z = -g_probe_param[r16.w].y + r17.z;
            r17.z = saturate(-r19.w * r17.z + 1);
            r17.w = r18.w ? r17.z : 0;
          } else {
            if (r17.y == 0) {
              r17.y = (int)r16.w * 3;
              r17.z = dot(g_probe_data[r17.y].xyzw, r8.xyzw);
              r18.w = dot(g_probe_data[r17.y+1].xyzw, r8.xyzw);
              r17.y = dot(g_probe_data[r17.y+2].xyzw, r8.xyzw);
              r17.z = max(abs(r18.w), abs(r17.z));
              r17.y = max(r17.z, abs(r17.y));
              r17.z = cmp(r17.y < 0.99000001);
              r18.w = max(g_probe_param[r16.w].y, 0.00999999978);
              r18.w = min(0.99000001, r18.w);
              r18.w = 1 + -r18.w;
              r18.w = 1 / r18.w;
              r17.y = -g_probe_param[r16.w].y + r17.y;
              r17.y = saturate(-r18.w * r17.y + 1);
              r17.w = r17.z ? r17.y : 0;
            } else {
              r17.w = 1;
            }
          }
          r25.xyz = r23.xyz;
        }
      }
      r17.y = cmp(0 < r17.w);
      if (r17.y != 0) {
        r25.z = -r25.z;
        r25.w = g_probe_pos[r16.w].w;
        r25.xyzw = s_IBLProbeArray.SampleLevel(s_IBLProbeArray_sampler_s, r25.xyzw, r1.w).xyzw;
        r16.w = 1 + -r12.w;
        r16.w = min(r17.w, r16.w);
        r13.xyz = r25.xyz * r16.www + r13.xyz;
        r10.w = r25.w * r16.w + r10.w;
        r12.w = r16.w + r12.w;
      }
      r14.w = (int)r14.w + 1;
    }
    r11.y = r15.w * r6.z;
    r23.w = -r23.z;
    r23.xyzw = s_IBL.SampleLevel(s_IBL_sampler_s, r23.xyw, r1.w).xyzw;
    r17.yzw = float3(1,1,1) + r23.xyz;
    r17.yzw = max(float3(0,0,0), r17.yzw);
    r17.yzw = log2(r17.yzw);
    r17.yzw = u_ibl_param.xxx * r17.yzw;
    r17.yzw = exp2(r17.yzw);
    r17.yzw = float3(-1,-1,-1) + r17.yzw;
    r17.yzw = max(float3(0,0,0), r17.yzw);
    r23.xyz = r23.xyz + -r17.yzw;
    r17.yzw = r11.yyy * r23.xyz + r17.yzw;
    r1.w = saturate(1 + -r10.w);
    r23.w = r23.w * r1.w;
    r13.xyz = r17.yzw * r1.www + r13.xyz;
    r1.w = cmp((int)r0.z == 2);
    if (r1.w != 0) {
      r24.xyzw = r6.yyyy * float4(-1,-0.0274999999,-0.572000027,0.0219999999) + float4(1,0.0425000004,1.03999996,-0.0399999991);
      r1.w = r24.x * r24.x;
      r10.w = -9.27999973 * r20.x;
      r10.w = exp2(r10.w);
      r1.w = min(r10.w, r1.w);
      r1.w = r1.w * r24.x + r24.y;
      r11.yw = r1.ww * float2(-1.03999996,1.03999996) + r24.zw;
    } else {
      r20.y = r6.y;
      r11.yw = s_EnvBRDF.SampleLevel(s_EnvBRDF_sampler_s, r20.xy, 0).xy;
    }
    r17.yzw = r4.xzw * r11.yyy + r11.www;
    r13.xyz = r17.yzw * r13.xyz;
    r13.xyz = max(float3(0,0,0), r13.xyz);
    r23.xyz = r13.xyz * r9.www;
    if (enable_ibl_plus_directional_specular != 0) {
      r1.w = u_rlr_param[1].w * r6.y;
      r24.xyzw = s_RLR.SampleLevel(s_RLR_sampler_s, r3.xy, r1.w).xyzw;
      r13.xyz = r24.xyz * r17.yzw;
      r25.xyz = max(float3(0,0,0), r13.xyz);
      r1.w = 1 + -u_sggi_param[1].x;
      r9.w = 1.00010002 + -r1.w;
      r1.w = r24.w + -r1.w;
      r9.w = 1 / r9.w;
      r1.w = saturate(r9.w * r1.w);
      r9.w = r1.w * -2 + 3;
      r1.w = r1.w * r1.w;
      r10.w = r9.w * r1.w;
      r25.w = 1;
      r24.xyzw = r25.xyzw + -r23.xyzw;
      r23.xyzw = r10.wwww * r24.xyzw + r23.xyzw;
      r1.w = -r9.w * r1.w + 1;
      r12.xyz = r12.xyz * r1.www;
    }
    r12.xyz = r23.www * r12.xyz;
    r5.xyz = r23.xyz * r6.zzz + r5.xyz;
  }
  r1.w = r16.x * r16.z;
  r13.xyz = float3(1,1,1) + -u_occlusion_capsule_param[0].xyz;
  r13.xyz = r16.xxx * r13.xyz + u_occlusion_capsule_param[0].xyz;
  r17.yzw = float3(1,1,1) + -u_occlusion_capsule_param[1].xyz;
  r16.yzw = r16.yyy * r17.yzw + u_occlusion_capsule_param[1].xyz;
  r17.yzw = r3.www ? float3(1,1,1) : r13.xyz;
  r12.xyz = r12.xyz * r1.www;
  r13.xyz = r18.xyz * r13.xyz;
  r18.xyz = r17.yzw * r9.xyz;
  r23.xyz = r17.yzw * r5.xyz;
  r24.xyz = r12.xyz * r0.xxx;
  r0.x = r22.z ? r3.z : 0;
  r0.x = r22.x ? 1 : r0.x;
  r22.xyz = r24.xyz * r0.xxx;
  r12.xyz = enable_ibl_plus_directional_specular ? r12.xyz : r22.xyz;
  r13.xyz = r19.xyz * r16.yzw + r13.xyz;
  r16.yzw = max(float3(0,0,0), r13.xyz);
  r16.yzw = r16.yzw * float3(0.318309873,0.318309873,0.318309873) + r18.xyz;
  r16.yzw = r16.yzw * r2.xyz;
  r12.xyz = r21.xyz * r1.www + r12.xyz;
  r19.xyz = max(float3(0,0,0), r12.xyz);
  r19.xyz = r5.xyz * r17.yzw + r19.xyz;
  switch (r17.x) {
    case 0 :    r21.w = 1;
    break;
    case 1 :    r16.yzw = float3(0.318309873,0.318309873,0.318309873) * r13.xyz;
    r21.w = 0;
    r19.xyz = float3(0,0,0);
    break;
    case 2 :    r21.w = 0;
    r16.yzw = r12.xyz;
    r19.xyz = float3(0,0,0);
    break;
    case 3 :    r21.w = 0;
    r16.yzw = r23.xyz;
    r19.xyz = float3(0,0,0);
    break;
    case 43 :    r21.w = 0;
    r16.yzw = r18.xyz;
    r19.xyz = float3(0,0,0);
    break;
    case 44 :    r16.yzw = r9.xyz * r17.yzw + r23.xyz;
    r21.w = 0;
    r19.xyz = float3(0,0,0);
    break;
    case 4 :    r21.w = 0;
    r16.yzw = r23.xyz;
    r19.xyz = float3(0,0,0);
    break;
    case 5 :    case 6 :    r0.x = r20.x + r20.x;
    r12.xyz = r0.xxx * r7.xyz + -r10.xyz;
    r0.x = dot(r12.xyz, r12.xyz);
    r0.x = rsqrt(r0.x);
    r12.xyz = r12.xyz * r0.xxx + -r7.xyz;
    r12.xyz = r12.xyz * float3(0.994937599,0.994937599,0.994937599) + r7.xyz;
    r3.zw = (int2)u_tile_info.zw;
    r3.zw = (int2)r3.zw + int2(15,15);
    r3.zw = (uint2)r3.zw >> int2(4,4);
    r3.zw = cmp((int2)r1.xy < (int2)r3.zw);
    r0.x = r3.w ? r3.z : 0;
    r3.zw = (uint2)u_tile_info.xy;
    r1.w = mad((int)r1.y, (int)r3.z, (int)r1.x);
    r1.w = mad((int)r1.w, 3, 2);
    r3.z = s_LocalLightIndexData[r1.w].x;
    r3.z = (int)r3.z & 0x0000ffff;
    r13.x = min(64, (uint)r3.z);
    r1.w = (uint)r1.w << 6;
    r13.y = (int)r1.w + (int)r3.w;
    r3.zw = (int2)r0.xx & (int2)r13.xy;
    r22.xyz = r8.xyz;
    r22.w = 1;
    r8.w = 1;
    r13.xyz = float3(0,0,0);
    r0.x = 0;
    r1.w = 0;
    r9.w = 0;
    while (true) {
      r10.w = cmp((uint)r9.w < (uint)r3.z);
      r11.y = cmp(r1.w < 1);
      r10.w = r10.w ? r11.y : 0;
      r11.y = cmp(r0.x < 1);
      r10.w = r10.w ? r11.y : 0;
      if (r10.w == 0) break;
      r10.w = (int)r3.w + (int)r9.w;
      r10.w = s_LocalLightIndexData[r10.w].x;
      r10.w = (int)r10.w & 0x0000ffff;
      r11.y = (uint)g_probe_param[r10.w].x >> 1;
      r11.w = cmp((int)r11.y == 1);
      if (r11.w != 0) {
        r11.w = (int)r10.w * 3;
        r23.x = dot(g_probe_data[r11.w].xyzw, r22.xyzw);
        r23.y = dot(g_probe_data[r11.w+1].xyzw, r22.xyzw);
        r23.z = dot(g_probe_data[r11.w+2].xyzw, r22.xyzw);
        r14.w = max(abs(r23.x), abs(r23.y));
        r14.w = max(r14.w, abs(r23.z));
        r18.w = cmp(r14.w < 0.99000001);
        r19.w = max(g_probe_param[r10.w].y, 0.00999999978);
        r19.w = min(0.99000001, r19.w);
        r19.w = 1 + -r19.w;
        r19.w = 1 / r19.w;
        r14.w = -g_probe_param[r10.w].y + r14.w;
        r14.w = saturate(-r19.w * r14.w + 1);
        r14.w = r18.w ? r14.w : 0;
        r18.w = cmp(0 < r14.w);
        if (r18.w != 0) {
          r24.x = dot(g_probe_data[r11.w].xyz, r12.xyz);
          r24.y = dot(g_probe_data[r11.w+1].xyz, r12.xyz);
          r24.z = dot(g_probe_data[r11.w+2].xyz, r12.xyz);
          r25.xyz = float3(1,1,1) + -r23.xyz;
          r25.xyz = r25.xyz / r24.xyz;
          r23.xyz = float3(-1,-1,-1) + -r23.xyz;
          r23.xyz = r23.xyz / r24.xyz;
          r23.xyz = max(r25.xyz, r23.xyz);
          r11.w = min(r23.y, r23.z);
          r11.w = min(r23.x, r11.w);
          r23.xyz = r12.xyz * r11.www + r8.xyz;
          r23.xyz = -g_probe_pos[r10.w].xyz + r23.xyz;
        } else {
          r23.xyz = r12.xyz;
        }
      } else {
        r11.w = cmp((int)r11.y == 3);
        if (r11.w != 0) {
          r24.xyz = -g_probe_pos[r10.w].xyz + r8.xyz;
          r11.w = dot(r24.xyz, r24.xyz);
          r18.w = sqrt(r11.w);
          r19.w = r18.w / g_probe_param[r10.w].z;
          r20.y = cmp(r19.w < 0.99000001);
          r24.w = max(g_probe_param[r10.w].y, 0.00999999978);
          r24.w = min(0.99000001, r24.w);
          r24.w = 1 + -r24.w;
          r24.w = 1 / r24.w;
          r19.w = -g_probe_param[r10.w].y + r19.w;
          r19.w = saturate(-r24.w * r19.w + 1);
          r14.w = r20.y ? r19.w : 0;
          r19.w = cmp(0 < r14.w);
          r24.xyz = r24.xyz / r18.www;
          r20.y = dot(r24.xyz, -r12.xyz);
          r24.x = r20.y * r18.w;
          r11.w = -r24.x * r24.x + r11.w;
          r11.w = sqrt(r11.w);
          r11.w = r11.w * r11.w;
          r11.w = g_probe_param[r10.w].z * g_probe_param[r10.w].z + -r11.w;
          r11.w = sqrt(r11.w);
          r11.w = r20.y * r18.w + r11.w;
          r24.xyz = r12.xyz * r11.www + r8.xyz;
          r24.xyz = -g_probe_pos[r10.w].xyz + r24.xyz;
          r23.xyz = r19.www ? r24.xyz : r12.xyz;
        } else {
          r11.w = cmp((int)r11.y == 2);
          if (r11.w != 0) {
            r24.xyz = -g_probe_pos[r10.w].xyz + r8.xyz;
            r11.w = dot(r24.xyz, r24.xyz);
            r11.w = sqrt(r11.w);
            r11.w = r11.w / g_probe_param[r10.w].z;
            r18.w = cmp(r11.w < 0.99000001);
            r19.w = max(g_probe_param[r10.w].y, 0.00999999978);
            r19.w = min(0.99000001, r19.w);
            r19.w = 1 + -r19.w;
            r19.w = 1 / r19.w;
            r11.w = -g_probe_param[r10.w].y + r11.w;
            r11.w = saturate(-r19.w * r11.w + 1);
            r14.w = r18.w ? r11.w : 0;
          } else {
            if (r11.y == 0) {
              r11.y = (int)r10.w * 3;
              r11.w = dot(g_probe_data[r11.y].xyzw, r8.xyzw);
              r18.w = dot(g_probe_data[r11.y+1].xyzw, r8.xyzw);
              r11.y = dot(g_probe_data[r11.y+2].xyzw, r8.xyzw);
              r11.w = max(abs(r18.w), abs(r11.w));
              r11.y = max(r11.w, abs(r11.y));
              r11.w = cmp(r11.y < 0.99000001);
              r18.w = max(g_probe_param[r10.w].y, 0.00999999978);
              r18.w = min(0.99000001, r18.w);
              r18.w = 1 + -r18.w;
              r18.w = 1 / r18.w;
              r11.y = -g_probe_param[r10.w].y + r11.y;
              r11.y = saturate(-r18.w * r11.y + 1);
              r14.w = r11.w ? r11.y : 0;
            } else {
              r14.w = 1;
            }
          }
          r23.xyz = r12.xyz;
        }
      }
      r11.y = cmp(0 < r14.w);
      if (r11.y != 0) {
        r23.z = -r23.z;
        r23.w = g_probe_pos[r10.w].w;
        r23.xyzw = s_IBLProbeArray.SampleLevel(s_IBLProbeArray_sampler_s, r23.xyzw, 0.600000024).xyzw;
        r10.w = 1 + -r1.w;
        r10.w = min(r14.w, r10.w);
        r13.xyz = r23.xyz * r10.www + r13.xyz;
        r0.x = r23.w * r10.w + r0.x;
        r1.w = r10.w + r1.w;
      }
      r9.w = (int)r9.w + 1;
    }
    r1.w = r15.w * r6.z;
    r12.w = -r12.z;
    r12.xyz = s_IBL.SampleLevel(s_IBL_sampler_s, r12.xyw, 0.600000024).xyz;
    r22.xyz = float3(1,1,1) + r12.xyz;
    r22.xyz = max(float3(0,0,0), r22.xyz);
    r22.xyz = log2(r22.xyz);
    r22.xyz = u_ibl_param.xxx * r22.xyz;
    r22.xyz = exp2(r22.xyz);
    r22.xyz = float3(-1,-1,-1) + r22.xyz;
    r22.xyz = max(float3(0,0,0), r22.xyz);
    r12.xyz = -r22.xyz + r12.xyz;
    r12.xyz = r1.www * r12.xyz + r22.xyz;
    r0.x = saturate(1 + -r0.x);
    r12.xyz = r12.xyz * r0.xxx + r13.xyz;
    r0.x = cmp((int)r0.z == 2);
    if (r0.x != 0) {
      r0.x = -9.27999973 * r20.x;
      r0.x = exp2(r0.x);
      r0.x = min(0.980100036, r0.x);
      r0.x = r0.x * 0.99000001 + 0.0422249995;
      r3.zw = r0.xx * float2(-1.03999996,1.03999996) + float2(1.03427994,-0.0397799984);
    } else {
      r20.z = 0.00999999978;
      r3.zw = s_EnvBRDF.SampleLevel(s_EnvBRDF_sampler_s, r20.xz, 0).xy;
    }
    r0.x = r3.z + r3.w;
    r12.xyz = r12.xyz * r0.xxx;
    r16.yzw = max(float3(0,0,0), r12.xyz);
    r21.w = 0;
    r19.xyz = float3(0,0,0);
    break;
    case 7 :    r21.w = 0;
    r16.yzw = r15.yzw;
    r19.xyz = float3(0,0,0);
    break;
    case 33 :    r0.x = round(g_probe_param[0].x);
    r0.x = (int)r0.x;
    r0.x = (int)r0.x & 1;
    r8.w = 1;
    r12.x = dot(g_probe_data[0].xyzw, r8.xyzw);
    r12.y = dot(g_probe_data[1].xyzw, r8.xyzw);
    r12.z = dot(g_probe_data[2].xyzw, r8.xyzw);
    r1.w = max(abs(r12.x), abs(r12.y));
    r1.w = max(r1.w, abs(r12.z));
    r1.w = cmp(g_probe_param[0].y < r1.w);
    r1.w = r1.w ? 1.000000 : 0;
    r12.xyz = cmp(float3(0.99000001,0.99000001,0.99000001) < abs(r12.xyz));
    r3.z = (int)r12.y | (int)r12.x;
    r3.z = (int)r12.z | (int)r3.z;
    r1.w = r3.z ? 0 : r1.w;
    r21.w = r0.x ? r1.w : 1;
    break;
    case 35 :    r21.w = 0;
    break;
    default :
    r21.w = 1;
    break;
  }
  r0.x = cmp(shadow_map_parameter[0].z == -1.000000);
  if (r0.x != 0) {
    r8.w = 1;
    r0.x = dot(shadow_camera_view_matrix_third_row.xyzw, r8.xyzw);
    r12.xyzw = cmp(shadow_cascade_frustums_eye_space_depth.xyzw < -r0.xxxx);
    r12.xyzw = r12.xyzw ? float4(1,1,1,1) : 0;
    r1.w = dot(float4(1,1,1,1), r12.xyzw);
    r3.z = (int)shadow_map_parameter[0].y;
    r3.w = cmp(0 < (int)r3.z);
    r3.w = r3.w ? 0 : 4;
    r1.w = r3.w + r1.w;
    r1.w = (int)r1.w;
    r3.w = cmp(shadow_map_parameter[1].z == 0.000000);
    if (r3.w != 0) {
      r3.w = 0;
    } else {
      r9.w = dot(shadow_cascade_frustums_eye_space_depth.xyzw, icb[r1.w+0].xyzw);
      r9.w = r9.w + r0.x;
      r9.w = saturate(shadow_map_parameter[1].z * r9.w);
      r3.w = 1 + -r9.w;
    }
    r9.w = cmp((int)r1.w < (int)r3.z);
    if (r9.w != 0) {
      r12.xyz = shadow_view_matrix._m10_m11_m12 * r8.yyy;
      r12.xyz = r8.xxx * shadow_view_matrix._m00_m01_m02 + r12.xyz;
      r12.xyz = r8.zzz * shadow_view_matrix._m20_m21_m22 + r12.xyz;
      r12.xyz = shadow_view_matrix._m30_m31_m32 + r12.xyz;
      r12.xyz = r12.xyz * shadow_cascade_scale[r1.w].xyz + shadow_cascade_offset[r1.w].xyz;
      r13.xyz = cmp(r12.xyz >= float3(0,0,0));
      r12.xyz = cmp(r12.xyz < float3(1,1,1));
      r9.w = r12.x ? r13.x : 0;
      r9.w = r13.y ? r9.w : 0;
      r9.w = r12.y ? r9.w : 0;
      r9.w = r13.z ? r9.w : 0;
      r9.w = r12.z ? r9.w : 0;
      if (r9.w != 0) {
        r9.w = (int)r1.w + 1;
        r3.z = (int)r3.z + -1;
        r9.w = min((int)r9.w, (int)r3.z);
        r3.z = dot(shadow_cascade_frustums_eye_space_depth.xyzw, icb[r3.z+0].xyzw);
        r0.x = r3.z + r0.x;
        r0.x = saturate(shadow_map_parameter[1].x * r0.x);
        r12.xyz = icb[r9.w+8].xyz + -icb[r1.w+8].xyz;
        r12.xyz = r3.www * r12.xyz + icb[r1.w+8].xyz;
        r12.xyz = float3(-1,-1,-1) + r12.xyz;
        r12.xyz = r0.xxx * r12.xyz + float3(1,1,1);
        r16.yzw = r16.yzw * r12.xyz;
      }
    }
  }
  r0.x = cmp(0.00100000005 < g_LightScatteringColor.w);
  r1.w = -g_LightScatteringFarNearScale.y + r1.z;
  r1.w = saturate(g_LightScatteringFarNearScale.x * r1.w);
  r1.w = g_LightScatteringFarNearScale.z * r1.w;
  r12.xyz = g_LightScattering_Ray_Mie_Ray2_Mie2.xyz + g_LightScattering_Ray_Mie_Ray2_Mie2.www;
  r13.xyz = -r12.xyz * r1.www;
  r13.xyz = float3(1.44269502,1.44269502,1.44269502) * r13.xyz;
  r13.xyz = exp2(r13.xyz);
  r1.w = dot(u_lightDirection.xyz, r10.xyz);
  r22.xyzw = float4(0.0596830994,0.0596830994,0.0596830994,0.0795774683) * g_LightScattering_Ray_Mie_Ray2_Mie2.xyzw;
  r3.z = r1.w * r1.w + 1;
  r1.w = g_LightScattering_ConstG_FogDensity.z * r1.w + g_LightScattering_ConstG_FogDensity.y;
  r1.w = 9.99999997e-007 + abs(r1.w);
  r1.w = log2(r1.w);
  r1.w = 1.5 * r1.w;
  r1.w = exp2(r1.w);
  r1.w = g_LightScattering_ConstG_FogDensity.x / r1.w;
  r1.w = r22.w * r1.w;
  r15.yzw = r22.xyz * r3.zzz + r1.www;
  r12.xyz = r15.yzw / r12.xyz;
  r12.xyz = g_LightScatteringColor.xyz * r12.xyz;
  r15.yzw = float3(1,1,1) + -r13.xyz;
  r12.xyz = r15.yzw * r12.xyz;
  r12.xyz = g_LightScatteringFarNearScale.www * r12.xyz;
  r15.yzw = r16.yzw * r13.xyz + -r16.yzw;
  r15.yzw = g_LightScatteringColor.www * r15.yzw + r16.yzw;
  r13.xyz = r19.xyz * r13.xyz + -r19.xyz;
  r13.xyz = g_LightScatteringColor.www * r13.xyz + r19.xyz;
  r12.xyz = g_LightScatteringColor.www * r12.xyz;
  r15.yzw = r0.xxx ? r15.yzw : r16.yzw;
  r13.xyz = r0.xxx ? r13.xyz : r19.xyz;
  r12.xyz = r0.xxx ? r12.xyz : 0;
  r16.yzw = u_fog_param_0.xyz * u_fog_param_0.www;
  r0.x = cmp(0.00100000005 < u_fog_param_2.x);
  if (r0.x != 0) {
    r0.x = saturate(u_fog_param_2.y);
    r0.x = sqrt(r0.x);
    r0.x = 6 * r0.x;
    r19.xyz = float3(-1,-1,1) * r10.xyz;
    r19.xyz = s_IBL.SampleLevel(s_IBL_sampler_s, r19.xyz, r0.x).xyz;
    r19.xyz = -u_fog_param_0.xyz * u_fog_param_0.www + r19.xyz;
    r16.yzw = u_fog_param_2.xxx * r19.xyz + r16.yzw;
  }
  r0.x = view_matrix._m12 * r8.y;
  r0.x = r8.x * view_matrix._m02 + r0.x;
  r0.x = r8.z * view_matrix._m22 + r0.x;
  r0.x = view_matrix._m32 + r0.x;
  r1.w = -u_fog_param_1.x + -r0.x;
  r3.z = u_fog_param_1.y + -u_fog_param_1.x;
  r3.w = u_fog_param_1.z * r3.z;
  r1.w = min(r3.w, r1.w);
  r1.w = saturate(r1.w / r3.z);
  r1.w = u_enable_fog_d ? r1.w : 0;
  r0.x = -u_fog_param_3.z + -r0.x;
  r3.zw = u_fog_param_3.wy + -u_fog_param_3.zx;
  r0.x = saturate(r0.x / r3.z);
  r3.z = -u_fog_param_3.x + r8.y;
  r3.z = saturate(r3.z / r3.w);
  r3.z = 1 + -r3.z;
  r0.x = r3.z * r0.x;
  r0.x = u_fog_param_1.w * r0.x;
  r3.z = 1 + -r1.w;
  r0.x = r3.z * r0.x + r1.w;
  r0.x = u_enable_fog_d ? r0.x : r1.w;
  r0.x *= 1.f - saturate(shader_injection.fx_fog_coverage_reduction);
  r1.w = 1 + -r0.x;
  r15.yzw = r15.yzw * r1.www;
  r13.xyz = r13.xyz * r1.www;
  r16.yzw *= r0.xxx * (1.f - saturate(shader_injection.fx_fog_light_reduction));
  r21.xyz = r12.xyz * r1.www + r16.yzw;
  r0.x = cmp(0 != r13.w);
  r0.x = r0.x ? r11.z : 0;
  if (r0.x != 0) {
    r0.x = min(r11.x, r6.z);
    r1.w = 0;
    r11.xy = float2(-1,0);
    r12.y = 0;
    r3.z = 0;
    while (true) {
      r3.w = cmp((int)r12.y >= 3);
      r3.z = 0;
      if (r3.w != 0) break;
      r19.xyzw = mad((int4)r12.yyyy, int4(9,9,9,9), int4(5,6,7,8));
      r16.yzw = shlightfield_probes_SHLightFieldProbe[r19.y].xyz * r8.yyy;
      r16.yzw = r8.xxx * shlightfield_probes_SHLightFieldProbe[r19.x].xyz + r16.yzw;
      r16.yzw = r8.zzz * shlightfield_probes_SHLightFieldProbe[r19.z].xyz + r16.yzw;
      r16.yzw = shlightfield_probes_SHLightFieldProbe[r19.w].xyz + r16.yzw;
      r19.xyz = cmp(float3(0.5,0.5,0.5) >= abs(r16.yzw));
      r3.w = r19.y ? r19.x : 0;
      r3.w = r19.z ? r3.w : 0;
      if (r3.w != 0) {
        r1.w = r12.y;
        r3.z = -1;
        break;
      }
      r12.x = dot(abs(r16.yzw), abs(r16.yzw));
      r9.w = cmp(r11.x < 0);
      r10.w = cmp(r12.x < r11.x);
      r9.w = (int)r9.w | (int)r10.w;
      r11.xy = r9.ww ? r12.xy : r11.xy;
      r12.y = (int)r12.y + 1;
      r3.z = r3.w;
      r1.w = 0;
    }
    r1.w = r3.z ? r1.w : r11.y;
    r3.z = (int)r1.w * 9;
    r11.xyzw = mad((int4)r1.wwww, int4(9,9,9,9), int4(5,6,7,8));
    r12.xyz = shlightfield_probes_SHLightFieldProbe[r11.y].xyz * r8.yyy;
    r12.xyz = r8.xxx * shlightfield_probes_SHLightFieldProbe[r11.x].xyz + r12.xyz;
    r12.xyz = r8.zzz * shlightfield_probes_SHLightFieldProbe[r11.z].xyz + r12.xyz;
    r12.xyz = shlightfield_probes_SHLightFieldProbe[r11.w].xyz + r12.xyz;
    r16.yzw = saturate(float3(0.5,0.5,0.5) + r12.xyz);
    r19.xyz = shlightfield_probes_SHLightFieldProbe[r11.y].xyz * r7.yyy;
    r11.xyw = r7.xxx * shlightfield_probes_SHLightFieldProbe[r11.x].xyz + r19.xyz;
    r11.xyz = r7.zzz * shlightfield_probes_SHLightFieldProbe[r11.z].xyz + r11.xyw;
    r3.w = dot(r11.xyz, r11.xyz);
    r3.w = rsqrt(r3.w);
    r11.xyz = r11.xyz * r3.www;
    r11.xyz = shlightfield_param.zzz * r11.xyz;
    r11.xyz = r16.yzw * shlightfield_probes_SHLightFieldProbe[r3.z].xyz + r11.xyz;
    r11.xyz = r11.xyz / shlightfield_probes_SHLightFieldProbe[r3.z].xyz;
    r16.yzw = float3(1,1,1) / shlightfield_probes_SHLightFieldProbe[r3.z].xyz;
    r19.xyz = float3(0.5,0.5,0.5) * r16.yzw;
    r16.yzw = -r16.yzw * float3(0.5,0.5,0.5) + float3(1,1,1);
    r11.xyz = max(r19.xyz, r11.xyz);
    r11.xyz = min(r11.xyz, r16.yzw);
    x1[0].xyz = float3(0,0,0);
    x1[1].xyz = float3(0,0,0);
    x1[2].xyz = float3(0,0,0);
    x1[3].xyz = float3(0,0,0);
    x1[4].xyz = float3(0,0,0);
    x1[5].xyz = float3(0,0,0);
    if (r1.w == 0) {
      r11.w = 0.111111112 * r11.x;
      r16.yzw = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r11.wyz, 0).xyz;
      x1[0].xyz = r16.yzw;
      r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.111111112,0,0);
      r16.yzw = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r16.yzw, 0).xyz;
      x1[1].xyz = r16.yzw;
      r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.222222224,0,0);
      r16.yzw = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r16.yzw, 0).xyz;
      x1[2].xyz = r16.yzw;
      r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.333333343,0,0);
      r16.yzw = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r16.yzw, 0).xyz;
      x1[3].xyz = r16.yzw;
      r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.444444448,0,0);
      r16.yzw = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r16.yzw, 0).xyz;
      x1[4].xyz = r16.yzw;
      r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.555555582,0,0);
      r16.yzw = s_SHLightField0_NedSmpignorenametexture.SampleLevel(s_SHLightField0_sampler_s, r16.yzw, 0).xyz;
      x1[5].xyz = r16.yzw;
    } else {
      r3.z = cmp((int)r1.w == 1);
      if (r3.z != 0) {
        r16.yzw = float3(0.111111112,1,1) * r11.xyz;
        r16.yzw = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r16.yzw, 0).xyz;
        x1[0].xyz = r16.yzw;
        r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.111111112,0,0);
        r16.yzw = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r16.yzw, 0).xyz;
        x1[1].xyz = r16.yzw;
        r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.222222224,0,0);
        r16.yzw = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r16.yzw, 0).xyz;
        x1[2].xyz = r16.yzw;
        r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.333333343,0,0);
        r16.yzw = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r16.yzw, 0).xyz;
        x1[3].xyz = r16.yzw;
        r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.444444448,0,0);
        r16.yzw = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r16.yzw, 0).xyz;
        x1[4].xyz = r16.yzw;
        r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.555555582,0,0);
        r16.yzw = s_SHLightField1_NedSmpignorenametexture.SampleLevel(s_SHLightField1_sampler_s, r16.yzw, 0).xyz;
        x1[5].xyz = r16.yzw;
      } else {
        r3.z = cmp((int)r1.w == 2);
        if (r3.z != 0) {
          r16.yzw = float3(0.111111112,1,1) * r11.xyz;
          r16.yzw = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r16.yzw, 0).xyz;
          x1[0].xyz = r16.yzw;
          r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.111111112,0,0);
          r16.yzw = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r16.yzw, 0).xyz;
          x1[1].xyz = r16.yzw;
          r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.222222224,0,0);
          r16.yzw = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r16.yzw, 0).xyz;
          x1[2].xyz = r16.yzw;
          r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.333333343,0,0);
          r16.yzw = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r16.yzw, 0).xyz;
          x1[3].xyz = r16.yzw;
          r16.yzw = r11.xyz * float3(0.111111112,1,1) + float3(0.444444448,0,0);
          r16.yzw = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r16.yzw, 0).xyz;
          x1[4].xyz = r16.yzw;
          r11.xyz = r11.xyz * float3(0.111111112,1,1) + float3(0.555555582,0,0);
          r11.xyz = s_SHLightField2_NedSmpignorenametexture.SampleLevel(s_SHLightField2_sampler_s, r11.xyz, 0).xyz;
          x1[5].xyz = r11.xyz;
        }
      }
    }
    r1.w = mad((int)r1.w, 9, 1);
    r1.w = shlightfield_probes_SHLightFieldProbe[r1.w].x + 0.5;
    r1.w = floor(r1.w);
    r1.w = (uint)r1.w;
    if (r1.w == 0) {
      r11.xyz = x1[0].xyz;
      r16.yzw = r7.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(3,0,0);
      r3.z = dot(r16.yzw, r16.yzw);
      r3.z = sqrt(r3.z);
      r11.xyz = float3(14.7026539,14.7026539,14.7026539) * r11.xyz;
      r3.zw = float2(1.44269502,169.524918) * r3.zz;
      r9.w = exp2(r3.z);
      r3.z = exp2(-r3.z);
      r3.z = r9.w + -r3.z;
      r3.z = 0.5 * r3.z;
      r11.xyz = r11.xyz * r3.zzz;
      r11.xyz = r11.xyz / r3.www;
      r16.yzw = x1[1].xyz;
      r19.xyz = r7.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(-3,0,0);
      r3.z = dot(r19.xyz, r19.xyz);
      r3.z = sqrt(r3.z);
      r16.yzw = float3(14.7026539,14.7026539,14.7026539) * r16.yzw;
      r3.zw = float2(1.44269502,169.524918) * r3.zz;
      r9.w = exp2(r3.z);
      r3.z = exp2(-r3.z);
      r3.z = r9.w + -r3.z;
      r3.z = 0.5 * r3.z;
      r16.yzw = r16.yzw * r3.zzz;
      r16.yzw = r16.yzw / r3.www;
      r11.xyz = r16.yzw + r11.xyz;
      r16.yzw = x1[2].xyz;
      r19.xyz = r7.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(0,3,0);
      r3.z = dot(r19.xyz, r19.xyz);
      r3.z = sqrt(r3.z);
      r16.yzw = float3(14.7026539,14.7026539,14.7026539) * r16.yzw;
      r3.zw = float2(1.44269502,169.524918) * r3.zz;
      r9.w = exp2(r3.z);
      r3.z = exp2(-r3.z);
      r3.z = r9.w + -r3.z;
      r3.z = 0.5 * r3.z;
      r16.yzw = r16.yzw * r3.zzz;
      r16.yzw = r16.yzw / r3.www;
      r11.xyz = r16.yzw + r11.xyz;
      r16.yzw = x1[3].xyz;
      r19.xyz = r7.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(0,-3,0);
      r3.z = dot(r19.xyz, r19.xyz);
      r3.z = sqrt(r3.z);
      r16.yzw = float3(14.7026539,14.7026539,14.7026539) * r16.yzw;
      r3.zw = float2(1.44269502,169.524918) * r3.zz;
      r9.w = exp2(r3.z);
      r3.z = exp2(-r3.z);
      r3.z = r9.w + -r3.z;
      r3.z = 0.5 * r3.z;
      r16.yzw = r16.yzw * r3.zzz;
      r16.yzw = r16.yzw / r3.www;
      r11.xyz = r16.yzw + r11.xyz;
      r16.yzw = x1[4].xyz;
      r19.xyz = r7.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(0,0,3);
      r3.z = dot(r19.xyz, r19.xyz);
      r3.z = sqrt(r3.z);
      r16.yzw = float3(14.7026539,14.7026539,14.7026539) * r16.yzw;
      r3.zw = float2(1.44269502,169.524918) * r3.zz;
      r9.w = exp2(r3.z);
      r3.z = exp2(-r3.z);
      r3.z = r9.w + -r3.z;
      r3.z = 0.5 * r3.z;
      r16.yzw = r16.yzw * r3.zzz;
      r16.yzw = r16.yzw / r3.www;
      r11.xyz = r16.yzw + r11.xyz;
      r16.yzw = x1[5].xyz;
      r19.xyz = r7.xyz * float3(2.1329999,2.1329999,-2.1329999) + float3(0,0,-3);
      r3.z = dot(r19.xyz, r19.xyz);
      r3.z = sqrt(r3.z);
      r16.yzw = float3(14.7026539,14.7026539,14.7026539) * r16.yzw;
      r3.zw = float2(1.44269502,169.524918) * r3.zz;
      r9.w = exp2(r3.z);
      r3.z = exp2(-r3.z);
      r3.z = r9.w + -r3.z;
      r3.z = 0.5 * r3.z;
      r16.yzw = r16.yzw * r3.zzz;
      r16.yzw = r16.yzw / r3.www;
      r11.xyz = r16.yzw + r11.xyz;
      r16.yzw = float3(0.318309873,0.318309873,0.318309873) * r11.xyz;
      if (r2.w != 0) {
        r19.xyz = r7.yzx * r7.yzy;
        r22.xyz = float3(-1.02381635,-1.02381635,-1.02381635) * r7.yzx;
        r3.zw = -r7.zz * r7.yx;
        r9.w = 0.858085036 * r19.z;
        r10.w = r19.y * 3 + -1;
        r10.w = 0.247708231 * r10.w;
        r3.zw = float2(-0.858085036,-0.858085036) * r3.zw;
        r11.w = r7.x * r7.x + -r19.x;
        r11.w = 0.429042518 * r11.w;
        r19.xy = (int2)u_tile_info.zw;
        r19.xy = (int2)r19.xy + int2(15,15);
        r19.xy = (uint2)r19.xy >> int2(4,4);
        r19.xy = cmp((int2)r1.xy < (int2)r19.xy);
        r12.w = r19.y ? r19.x : 0;
        r19.xy = (uint2)u_tile_info.xy;
        r13.w = mad((int)r1.y, (int)r19.x, (int)r1.x);
        r13.w = mad((int)r13.w, 3, 2);
        r14.w = s_LocalLightIndexData[r13.w].x;
        r14.w = (int)r14.w & 0x0000ffff;
        r23.x = min(64, (uint)r14.w);
        r13.w = (uint)r13.w << 6;
        r23.y = (int)r13.w + (int)r19.y;
        r19.xy = r12.ww ? r23.xy : 0;
        r8.w = 1;
        r23.xyz = float3(0,0,0);
        r12.w = 1;
        r13.w = 0;
        while (true) {
          r14.w = cmp((uint)r13.w >= (uint)r19.x);
          if (r14.w != 0) break;
          r14.w = (int)r13.w + (int)r19.y;
          r14.w = s_LocalLightIndexData[r14.w].x;
          r14.w = (int)r14.w & 0x0000ffff;
          r18.w = (uint)g_probe_param[r14.w].x >> 1;
          r19.zw = cmp((int2)r18.ww == int2(3,2));
          r18.w = (int)r19.w | (int)r19.z;
          if (r18.w != 0) {
            r24.xyz = -g_probe_pos[r14.w].xyz + r8.xyz;
            r18.w = dot(r24.xyz, r24.xyz);
            r18.w = sqrt(r18.w);
            r18.w = r18.w / g_probe_param[r14.w].z;
          } else {
            r19.z = (int)r14.w * 3;
            r19.w = dot(g_probe_data[r19.z].xyzw, r8.xyzw);
            r20.y = dot(g_probe_data[r19.z+1].xyzw, r8.xyzw);
            r19.z = dot(g_probe_data[r19.z+2].xyzw, r8.xyzw);
            r19.w = max(abs(r20.y), abs(r19.w));
            r18.w = max(r19.w, abs(r19.z));
          }
          r19.z = cmp(r18.w < 0.99000001);
          r19.w = max(g_probe_param[r14.w].y, 0.00999999978);
          r19.w = min(0.99000001, r19.w);
          r19.w = 1 + -r19.w;
          r19.w = 1 / r19.w;
          r18.w = -g_probe_param[r14.w].y + r18.w;
          r18.w = saturate(-r19.w * r18.w + 1);
          r18.w = r19.z ? r18.w : 0;
          r19.z = cmp(0 < r18.w);
          if (r19.z != 0) {
            r14.w = (int)r14.w * 7;
            r24.x = g_probe_shparam[r14.w].w * r22.x;
            r24.yz = g_probe_shparam[r14.w+1].xy * r22.xx;
            r24.xyz = g_probe_shparam[r14.w].xyz * float3(0.886227667,0.886227667,0.886227667) + r24.xyz;
            r25.xy = g_probe_shparam[r14.w+1].zw * r22.yy;
            r25.z = g_probe_shparam[r14.w+2].x * r22.y;
            r24.xyz = r25.xyz + r24.xyz;
            r24.xyz = r22.zzz * g_probe_shparam[r14.w+2].yzw + r24.xyz;
            r24.xyz = r9.www * g_probe_shparam[r14.w+3].xyz + r24.xyz;
            r25.x = g_probe_shparam[r14.w+3].w * r3.z;
            r25.yz = g_probe_shparam[r14.w+4].xy * r3.zz;
            r24.xyz = r25.xyz + r24.xyz;
            r25.xy = g_probe_shparam[r14.w+4].zw * r10.ww;
            r25.z = g_probe_shparam[r14.w+5].x * r10.w;
            r24.xyz = r25.xyz + r24.xyz;
            r24.xyz = r3.www * g_probe_shparam[r14.w+5].yzw + r24.xyz;
            r24.xyz = r11.www * g_probe_shparam[r14.w+6].xyz + r24.xyz;
            r24.xyz = float3(0.318309873,0.318309873,0.318309873) * r24.xyz;
            r14.w = min(r18.w, r12.w);
            r24.xyz = r24.xyz * r14.www + r23.xyz;
            r12.w = -r14.w + r12.w;
            r14.w = cmp(0 >= r12.w);
            if (r14.w != 0) {
              r23.xyz = r24.xyz;
              break;
            }
            r23.xyz = r24.xyz;
          }
          r13.w = (int)r13.w + 1;
        }
        r19.xyz = u_sky_sh_param[1].xyz * r22.xxx;
        r19.xyz = u_sky_sh_param[0].xyz * float3(0.886227667,0.886227667,0.886227667) + r19.xyz;
        r19.xyz = r22.yyy * u_sky_sh_param[2].xyz + r19.xyz;
        r19.xyz = r22.zzz * u_sky_sh_param[3].xyz + r19.xyz;
        r19.xyz = r9.www * u_sky_sh_param[4].xyz + r19.xyz;
        r19.xyz = r3.zzz * u_sky_sh_param[5].xyz + r19.xyz;
        r19.xyz = r10.www * u_sky_sh_param[6].xyz + r19.xyz;
        r19.xyz = r3.www * u_sky_sh_param[7].xyz + r19.xyz;
        r19.xyz = r11.www * u_sky_sh_param[8].xyz + r19.xyz;
        r19.xyz = r19.xyz * r0.xxx;
        r19.xyz = float3(0.318309873,0.318309873,0.318309873) * r19.xyz;
        r3.z = r0.x * -u_sggi_param[1].w + u_sggi_param[1].w;
        r19.xyz = r23.xyz * r3.zzz + r19.xyz;
        r16.yzw = r11.xyz * float3(0.318309873,0.318309873,0.318309873) + r19.xyz;
      }
    } else {
      if (r2.w != 0) {
        r11.xyz = r7.yzx * r7.yzy;
        r19.xyz = float3(-1.02381635,-1.02381635,-1.02381635) * r7.yzx;
        r3.zw = -r7.zz * r7.yx;
        r2.w = 0.858085036 * r11.z;
        r9.w = r11.y * 3 + -1;
        r9.w = 0.247708231 * r9.w;
        r3.zw = float2(-0.858085036,-0.858085036) * r3.zw;
        r10.w = r7.x * r7.x + -r11.x;
        r10.w = 0.429042518 * r10.w;
        r11.xy = (int2)u_tile_info.zw;
        r11.xy = (int2)r11.xy + int2(15,15);
        r11.xy = (uint2)r11.xy >> int2(4,4);
        r11.xy = cmp((int2)r1.xy < (int2)r11.xy);
        r11.x = r11.y ? r11.x : 0;
        r11.yz = (uint2)u_tile_info.xy;
        r11.y = mad((int)r1.y, (int)r11.y, (int)r1.x);
        r11.y = mad((int)r11.y, 3, 2);
        r11.w = s_LocalLightIndexData[r11.y].x;
        r11.w = (int)r11.w & 0x0000ffff;
        r22.x = min(64, (uint)r11.w);
        r11.y = (uint)r11.y << 6;
        r22.y = (int)r11.y + (int)r11.z;
        r11.xy = r11.xx ? r22.xy : 0;
        r8.w = 1;
        r22.xyz = float3(0,0,0);
        r11.zw = float2(1,0);
        while (true) {
          r12.w = cmp((uint)r11.w >= (uint)r11.x);
          if (r12.w != 0) break;
          r12.w = (int)r11.w + (int)r11.y;
          r12.w = s_LocalLightIndexData[r12.w].x;
          r12.w = (int)r12.w & 0x0000ffff;
          r13.w = (uint)g_probe_param[r12.w].x >> 1;
          r20.yz = cmp((int2)r13.ww == int2(3,2));
          r13.w = (int)r20.z | (int)r20.y;
          if (r13.w != 0) {
            r23.xyz = -g_probe_pos[r12.w].xyz + r8.xyz;
            r13.w = dot(r23.xyz, r23.xyz);
            r13.w = sqrt(r13.w);
            r13.w = r13.w / g_probe_param[r12.w].z;
          } else {
            r14.w = (int)r12.w * 3;
            r18.w = dot(g_probe_data[r14.w].xyzw, r8.xyzw);
            r19.w = dot(g_probe_data[r14.w+1].xyzw, r8.xyzw);
            r14.w = dot(g_probe_data[r14.w+2].xyzw, r8.xyzw);
            r18.w = max(abs(r19.w), abs(r18.w));
            r13.w = max(r18.w, abs(r14.w));
          }
          r14.w = cmp(r13.w < 0.99000001);
          r18.w = max(g_probe_param[r12.w].y, 0.00999999978);
          r18.w = min(0.99000001, r18.w);
          r18.w = 1 + -r18.w;
          r18.w = 1 / r18.w;
          r13.w = -g_probe_param[r12.w].y + r13.w;
          r13.w = saturate(-r18.w * r13.w + 1);
          r13.w = r14.w ? r13.w : 0;
          r14.w = cmp(0 < r13.w);
          if (r14.w != 0) {
            r12.w = (int)r12.w * 7;
            r23.x = g_probe_shparam[r12.w].w * r19.x;
            r23.yz = g_probe_shparam[r12.w+1].xy * r19.xx;
            r23.xyz = g_probe_shparam[r12.w].xyz * float3(0.886227667,0.886227667,0.886227667) + r23.xyz;
            r24.xy = g_probe_shparam[r12.w+1].zw * r19.yy;
            r24.z = g_probe_shparam[r12.w+2].x * r19.y;
            r23.xyz = r24.xyz + r23.xyz;
            r23.xyz = r19.zzz * g_probe_shparam[r12.w+2].yzw + r23.xyz;
            r23.xyz = r2.www * g_probe_shparam[r12.w+3].xyz + r23.xyz;
            r24.x = g_probe_shparam[r12.w+3].w * r3.z;
            r24.yz = g_probe_shparam[r12.w+4].xy * r3.zz;
            r23.xyz = r24.xyz + r23.xyz;
            r24.xy = g_probe_shparam[r12.w+4].zw * r9.ww;
            r24.z = g_probe_shparam[r12.w+5].x * r9.w;
            r23.xyz = r24.xyz + r23.xyz;
            r23.xyz = r3.www * g_probe_shparam[r12.w+5].yzw + r23.xyz;
            r23.xyz = r10.www * g_probe_shparam[r12.w+6].xyz + r23.xyz;
            r23.xyz = float3(0.318309873,0.318309873,0.318309873) * r23.xyz;
            r12.w = min(r13.w, r11.z);
            r23.xyz = r23.xyz * r12.www + r22.xyz;
            r11.z = -r12.w + r11.z;
            r12.w = cmp(0 >= r11.z);
            if (r12.w != 0) {
              r22.xyz = r23.xyz;
              break;
            }
            r22.xyz = r23.xyz;
          }
          r11.w = (int)r11.w + 1;
        }
        r11.xyz = u_sky_sh_param[1].xyz * r19.xxx;
        r11.xyz = u_sky_sh_param[0].xyz * float3(0.886227667,0.886227667,0.886227667) + r11.xyz;
        r11.xyz = r19.yyy * u_sky_sh_param[2].xyz + r11.xyz;
        r11.xyz = r19.zzz * u_sky_sh_param[3].xyz + r11.xyz;
        r11.xyz = r2.www * u_sky_sh_param[4].xyz + r11.xyz;
        r11.xyz = r3.zzz * u_sky_sh_param[5].xyz + r11.xyz;
        r11.xyz = r9.www * u_sky_sh_param[6].xyz + r11.xyz;
        r11.xyz = r3.www * u_sky_sh_param[7].xyz + r11.xyz;
        r11.xyz = r10.www * u_sky_sh_param[8].xyz + r11.xyz;
        r11.xyz = r11.xyz * r0.xxx;
        r11.xyz = float3(0.318309873,0.318309873,0.318309873) * r11.xyz;
        r2.w = r0.x * -u_sggi_param[1].w + u_sggi_param[1].w;
        r16.yzw = r22.xyz * r2.www + r11.xyz;
      } else {
        r1.w = cmp((int)r1.w == 2);
        if (r1.w != 0) {
          r11.xyz = cmp(float3(0.5,0.5,0.5) >= abs(r12.xyz));
          r1.w = r11.y ? r11.x : 0;
          r1.w = r11.z ? r1.w : 0;
          r1.w = r1.w ? 0 : 6;
          r2.w = 0;
          while (true) {
            r3.z = cmp((uint)r2.w >= (uint)r1.w);
            if (r3.z != 0) break;
            x1[r2.w+0].x = 1;
            r2.w = (int)r2.w + 1;
          }
          r1.w = -1.02381635 * r7.y;
          r11.xyz = r7.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
          r12.xyzw = r7.xyzx * r7.xyzy;
          r2.w = x1[1].x;
          r3.z = x1[0].x;
          r3.z = r3.z + -r2.w;
          r2.w = r11.x * r3.z + r2.w;
          r3.z = x1[3].x;
          r3.w = x1[2].x;
          r3.w = r3.w + -r3.z;
          r3.z = r11.y * r3.w + r3.z;
          r3.z = r12.y * r3.z;
          r2.w = r12.x * r2.w + r3.z;
          r3.z = x1[5].x;
          r3.w = x1[4].x;
          r3.w = r3.w + -r3.z;
          r3.z = r11.z * r3.w + r3.z;
          r2.w = saturate(r12.z * r3.z + r2.w);
          r0.x = min(r2.w, r0.x);
          r3.zw = float2(-1.02381635,-1.02381635) * r7.zx;
          r11.xy = -r7.zz * r7.yx;
          r2.w = 0.858085036 * r12.w;
          r9.w = r12.z * 3 + -1;
          r9.w = 0.247708231 * r9.w;
          r11.xy = float2(-0.858085036,-0.858085036) * r11.xy;
          r10.w = r7.x * r7.x + -r12.y;
          r10.w = 0.429042518 * r10.w;
          r11.zw = (int2)u_tile_info.zw;
          r11.zw = (int2)r11.zw + int2(15,15);
          r11.zw = (uint2)r11.zw >> int2(4,4);
          r11.zw = cmp((int2)r1.xy < (int2)r11.zw);
          r11.z = r11.w ? r11.z : 0;
          r12.xy = (uint2)u_tile_info.xy;
          r11.w = mad((int)r1.y, (int)r12.x, (int)r1.x);
          r11.w = mad((int)r11.w, 3, 2);
          r12.x = s_LocalLightIndexData[r11.w].x;
          r12.x = (int)r12.x & 0x0000ffff;
          r19.x = min(64, (uint)r12.x);
          r11.w = (uint)r11.w << 6;
          r19.y = (int)r11.w + (int)r12.y;
          r11.zw = r11.zz ? r19.xy : 0;
          r8.w = 1;
          r12.xyzw = float4(0,0,0,1);
          r13.w = 0;
          while (true) {
            r14.w = cmp((uint)r13.w >= (uint)r11.z);
            if (r14.w != 0) break;
            r14.w = (int)r11.w + (int)r13.w;
            r14.w = s_LocalLightIndexData[r14.w].x;
            r14.w = (int)r14.w & 0x0000ffff;
            r18.w = (uint)g_probe_param[r14.w].x >> 1;
            r19.xy = cmp((int2)r18.ww == int2(3,2));
            r18.w = (int)r19.y | (int)r19.x;
            if (r18.w != 0) {
              r19.xyz = -g_probe_pos[r14.w].xyz + r8.xyz;
              r18.w = dot(r19.xyz, r19.xyz);
              r18.w = sqrt(r18.w);
              r18.w = r18.w / g_probe_param[r14.w].z;
            } else {
              r19.x = (int)r14.w * 3;
              r19.y = dot(g_probe_data[r19.x].xyzw, r8.xyzw);
              r19.z = dot(g_probe_data[r19.x+1].xyzw, r8.xyzw);
              r19.x = dot(g_probe_data[r19.x+2].xyzw, r8.xyzw);
              r19.y = max(abs(r19.y), abs(r19.z));
              r18.w = max(r19.y, abs(r19.x));
            }
            r19.x = cmp(r18.w < 0.99000001);
            r19.y = max(g_probe_param[r14.w].y, 0.00999999978);
            r19.y = min(0.99000001, r19.y);
            r19.y = 1 + -r19.y;
            r19.y = 1 / r19.y;
            r18.w = -g_probe_param[r14.w].y + r18.w;
            r18.w = saturate(-r19.y * r18.w + 1);
            r18.w = r19.x ? r18.w : 0;
            r19.x = cmp(0 < r18.w);
            if (r19.x != 0) {
              r14.w = (int)r14.w * 7;
              r19.x = g_probe_shparam[r14.w].w * r1.w;
              r19.yz = g_probe_shparam[r14.w+1].xy * r1.ww;
              r19.xyz = g_probe_shparam[r14.w].xyz * float3(0.886227667,0.886227667,0.886227667) + r19.xyz;
              r22.xy = g_probe_shparam[r14.w+1].zw * r3.zz;
              r22.z = g_probe_shparam[r14.w+2].x * r3.z;
              r19.xyz = r22.xyz + r19.xyz;
              r19.xyz = r3.www * g_probe_shparam[r14.w+2].yzw + r19.xyz;
              r19.xyz = r2.www * g_probe_shparam[r14.w+3].xyz + r19.xyz;
              r22.x = g_probe_shparam[r14.w+3].w * r11.x;
              r22.yz = g_probe_shparam[r14.w+4].xy * r11.xx;
              r19.xyz = r22.xyz + r19.xyz;
              r22.xy = g_probe_shparam[r14.w+4].zw * r9.ww;
              r22.z = g_probe_shparam[r14.w+5].x * r9.w;
              r19.xyz = r22.xyz + r19.xyz;
              r19.xyz = r11.yyy * g_probe_shparam[r14.w+5].yzw + r19.xyz;
              r19.xyz = r10.www * g_probe_shparam[r14.w+6].xyz + r19.xyz;
              r19.xyz = float3(0.318309873,0.318309873,0.318309873) * r19.xyz;
              r14.w = min(r18.w, r12.w);
              r19.xyz = r19.xyz * r14.www + r12.xyz;
              r12.w = -r14.w + r12.w;
              r14.w = cmp(0 >= r12.w);
              if (r14.w != 0) {
                r12.xyz = r19.xyz;
                break;
              }
              r12.xyz = r19.xyz;
            }
            r13.w = (int)r13.w + 1;
          }
          r19.xyz = u_sky_sh_param[1].xyz * r1.www;
          r19.xyz = u_sky_sh_param[0].xyz * float3(0.886227667,0.886227667,0.886227667) + r19.xyz;
          r19.xyz = r3.zzz * u_sky_sh_param[2].xyz + r19.xyz;
          r19.xyz = r3.www * u_sky_sh_param[3].xyz + r19.xyz;
          r19.xyz = r2.www * u_sky_sh_param[4].xyz + r19.xyz;
          r11.xzw = r11.xxx * u_sky_sh_param[5].xyz + r19.xyz;
          r11.xzw = r9.www * u_sky_sh_param[6].xyz + r11.xzw;
          r11.xyz = r11.yyy * u_sky_sh_param[7].xyz + r11.xzw;
          r11.xyz = r10.www * u_sky_sh_param[8].xyz + r11.xyz;
          r11.xyz = r11.xyz * r0.xxx;
          r11.xyz = float3(0.318309873,0.318309873,0.318309873) * r11.xyz;
          r0.x = r0.x * -u_sggi_param[1].w + u_sggi_param[1].w;
          r16.yzw = r12.xyz * r0.xxx + r11.xyz;
        } else {
          r16.yzw = float3(0,0,0);
        }
      }
    }
    r11.xyz = max(float3(0,0,0), r16.yzw);
    r12.xyz = -shlightfield_multiply_color_down.xyz + shlightfield_multiply_color_up.xyz;
    r12.xyz = r4.yyy * r12.xyz + shlightfield_multiply_color_down.xyz;
    r12.xyz = shlightfield_param.yyy * r12.xyz;
    r11.xyz = r12.xyz * r11.xyz;
    r18.xyz = r11.xyz * r16.xxx;
  }
  switch (r17.x) {
    case 10 :    break;
    case 11 :    break;
    case 12 :    r15.yzw = r18.xyz;
    break;
    case 13 :    break;
    case 14 :    r15.yzw = r2.xyz;
    break;
    case 15 :    r11.xyz = saturate(float3(0.010397804,0.010397804,0.010397804) + -r2.xyz);
    r0.x = dot(r11.xyz, r11.xyz);
    r0.x = cmp(r0.x != 0.000000);
    r11.xyz = saturate(float3(-0.899384499,-0.899384499,-0.899384499) + r2.xyz);
    r1.w = dot(r11.xyz, r11.xyz);
    r1.w = cmp(r1.w != 0.000000);
    r0.x = (int)r0.x | (int)r1.w;
    r15.yzw = r0.xxx ? float3(10,0,0) : r2.xyz;
    break;
    case 16 :    r15.yzw = float3(1,1,1);
    break;
    case 17 :    r15.yzw = saturate(r7.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5));
    break;
    case 18 :    r15.yzw = r6.yyy;
    break;
    case 36 :    r15.yzw = float3(1,1,1) + -r6.yyy;
    break;
    case 19 :    r15.yzw = r5.xyz * r17.yzw + r18.xyz;
    break;
    case 20 :    r15.yzw = r6.zzz;
    break;
    case 21 :    r15.yzw = r4.xzw;
    break;
    case 22 :    r15.yzw = r6.www;
    break;
    case 23 :    break;
    case 37 :    break;
    case 38 :    break;
    case 26 :    r15.yzw = r15.xxx;
    break;
    case 27 :    r15.yzw = s_RLR.SampleLevel(s_RLR_sampler_s, r3.xy, 0).xyz;
    break;
    case 28 :    r3.xy = (int2)u_tile_info.zw;
    r3.xy = (int2)r3.xy + int2(15,15);
    r3.xy = (uint2)r3.xy >> int2(4,4);
    r3.xy = cmp((int2)r1.xy < (int2)r3.xy);
    r0.x = r3.y ? r3.x : 0;
    r3.xy = (uint2)u_tile_info.xy;
    r1.w = mad((int)r1.y, (int)r3.x, (int)r1.x);
    r1.w = mad((int)r1.w, 3, 2);
    r2.w = s_LocalLightIndexData[r1.w].x;
    r2.w = (int)r2.w & 0x0000ffff;
    r5.x = min(64, (uint)r2.w);
    r1.w = (uint)r1.w << 6;
    r5.y = (int)r1.w + (int)r3.y;
    r3.xy = r0.xx ? r5.xy : 0;
    r11.xyz = r8.xyz;
    r11.w = 1;
    r8.w = 1;
    r5.xyz = float3(0,0,0);
    r0.x = 0;
    r1.w = 0;
    r2.w = 0;
    while (true) {
      r3.z = cmp((uint)r2.w < (uint)r3.x);
      r3.w = cmp(r1.w < 1);
      r3.z = r3.w ? r3.z : 0;
      r3.w = cmp(r0.x < 1);
      r3.z = r3.w ? r3.z : 0;
      if (r3.z == 0) break;
      r3.z = (int)r2.w + (int)r3.y;
      r3.z = s_LocalLightIndexData[r3.z].x;
      r3.z = (int)r3.z & 0x0000ffff;
      r3.w = (uint)g_probe_param[r3.z].x >> 1;
      r4.y = cmp((int)r3.w == 1);
      if (r4.y != 0) {
        r4.y = (int)r3.z * 3;
        r12.x = dot(g_probe_data[r4.y].xyzw, r11.xyzw);
        r12.y = dot(g_probe_data[r4.y+1].xyzw, r11.xyzw);
        r12.z = dot(g_probe_data[r4.y+2].xyzw, r11.xyzw);
        r6.w = max(abs(r12.x), abs(r12.y));
        r6.w = max(r6.w, abs(r12.z));
        r9.w = cmp(r6.w < 0.99000001);
        r10.w = max(g_probe_param[r3.z].y, 0.00999999978);
        r10.w = min(0.99000001, r10.w);
        r10.w = 1 + -r10.w;
        r10.w = 1 / r10.w;
        r6.w = -g_probe_param[r3.z].y + r6.w;
        r6.w = saturate(-r10.w * r6.w + 1);
        r6.w = r9.w ? r6.w : 0;
        r9.w = cmp(0 < r6.w);
        if (r9.w != 0) {
          r16.x = dot(g_probe_data[r4.y].xyz, r7.xyz);
          r16.y = dot(g_probe_data[r4.y+1].xyz, r7.xyz);
          r16.z = dot(g_probe_data[r4.y+2].xyz, r7.xyz);
          r17.yzw = float3(1,1,1) + -r12.xyz;
          r17.yzw = r17.yzw / r16.xyz;
          r12.xyz = float3(-1,-1,-1) + -r12.xyz;
          r12.xyz = r12.xyz / r16.xyz;
          r12.xyz = max(r17.yzw, r12.xyz);
          r4.y = min(r12.y, r12.z);
          r4.y = min(r12.x, r4.y);
          r12.xyz = r7.xyz * r4.yyy + r8.xyz;
          r12.xyz = -g_probe_pos[r3.z].xyz + r12.xyz;
        } else {
          r12.xyz = r7.xyz;
        }
      } else {
        r4.y = cmp((int)r3.w == 3);
        if (r4.y != 0) {
          r16.xyz = -g_probe_pos[r3.z].xyz + r8.xyz;
          r4.y = dot(r16.xyz, r16.xyz);
          r9.w = sqrt(r4.y);
          r10.w = r9.w / g_probe_param[r3.z].z;
          r13.w = cmp(r10.w < 0.99000001);
          r14.w = max(g_probe_param[r3.z].y, 0.00999999978);
          r14.w = min(0.99000001, r14.w);
          r14.w = 1 + -r14.w;
          r14.w = 1 / r14.w;
          r10.w = -g_probe_param[r3.z].y + r10.w;
          r10.w = saturate(-r14.w * r10.w + 1);
          r6.w = r13.w ? r10.w : 0;
          r10.w = cmp(0 < r6.w);
          r16.xyz = r16.xyz / r9.www;
          r13.w = dot(r16.xyz, -r7.xyz);
          r14.w = r13.w * r9.w;
          r4.y = -r14.w * r14.w + r4.y;
          r4.y = sqrt(r4.y);
          r4.y = r4.y * r4.y;
          r4.y = g_probe_param[r3.z].z * g_probe_param[r3.z].z + -r4.y;
          r4.y = sqrt(r4.y);
          r4.y = r13.w * r9.w + r4.y;
          r16.xyz = r7.xyz * r4.yyy + r8.xyz;
          r16.xyz = -g_probe_pos[r3.z].xyz + r16.xyz;
          r12.xyz = r10.www ? r16.xyz : r7.xyz;
        } else {
          r4.y = cmp((int)r3.w == 2);
          if (r4.y != 0) {
            r16.xyz = -g_probe_pos[r3.z].xyz + r8.xyz;
            r4.y = dot(r16.xyz, r16.xyz);
            r4.y = sqrt(r4.y);
            r4.y = r4.y / g_probe_param[r3.z].z;
            r9.w = cmp(r4.y < 0.99000001);
            r10.w = max(g_probe_param[r3.z].y, 0.00999999978);
            r10.w = min(0.99000001, r10.w);
            r10.w = 1 + -r10.w;
            r10.w = 1 / r10.w;
            r4.y = -g_probe_param[r3.z].y + r4.y;
            r4.y = saturate(-r10.w * r4.y + 1);
            r6.w = r9.w ? r4.y : 0;
          } else {
            if (r3.w == 0) {
              r3.w = (int)r3.z * 3;
              r4.y = dot(g_probe_data[r3.w].xyzw, r8.xyzw);
              r9.w = dot(g_probe_data[r3.w+1].xyzw, r8.xyzw);
              r3.w = dot(g_probe_data[r3.w+2].xyzw, r8.xyzw);
              r4.y = max(abs(r9.w), abs(r4.y));
              r3.w = max(r4.y, abs(r3.w));
              r4.y = cmp(r3.w < 0.99000001);
              r9.w = max(g_probe_param[r3.z].y, 0.00999999978);
              r9.w = min(0.99000001, r9.w);
              r9.w = 1 + -r9.w;
              r9.w = 1 / r9.w;
              r3.w = -g_probe_param[r3.z].y + r3.w;
              r3.w = saturate(-r9.w * r3.w + 1);
              r6.w = r4.y ? r3.w : 0;
            } else {
              r6.w = 1;
            }
          }
          r12.xyz = r7.xyz;
        }
      }
      r3.w = cmp(0 < r6.w);
      if (r3.w != 0) {
        r12.z = -r12.z;
        r12.w = g_probe_pos[r3.z].w;
        r12.xyzw = s_IBLProbeArray.SampleLevel(s_IBLProbeArray_sampler_s, r12.xyzw, 6).xyzw;
        r3.z = 1 + -r1.w;
        r3.z = min(r6.w, r3.z);
        r5.xyz = r12.xyz * r3.zzz + r5.xyz;
        r0.x = r12.w * r3.z + r0.x;
        r1.w = r3.z + r1.w;
      }
      r2.w = (int)r2.w + 1;
    }
    r7.w = -r7.z;
    r3.xyz = s_IBL.SampleLevel(s_IBL_sampler_s, r7.xyw, 6).xyz;
    r0.x = saturate(1 + -r0.x);
    r15.yzw = r3.xyz * r0.xxx + r5.xyz;
    break;
    case 29 :    r0.x = r20.x + r20.x;
    r3.xyz = r0.xxx * r7.xyz + -r10.xyz;
    r0.x = dot(r3.xyz, r3.xyz);
    r0.x = rsqrt(r0.x);
    r1.w = saturate(1 + -r6.y);
    r2.w = sqrt(r1.w);
    r2.w = r2.w + r6.y;
    r1.w = r2.w * r1.w;
    r3.xyz = r3.xyz * r0.xxx + -r7.xyz;
    r3.xyz = r1.www * r3.xyz + r7.xyz;
    r0.x = saturate(r6.y);
    r0.x = sqrt(r0.x);
    r0.x = 6 * r0.x;
    r5.xy = (int2)u_tile_info.zw;
    r5.xy = (int2)r5.xy + int2(15,15);
    r5.xy = (uint2)r5.xy >> int2(4,4);
    r5.xy = cmp((int2)r1.xy < (int2)r5.xy);
    r1.w = r5.y ? r5.x : 0;
    r5.xy = (uint2)u_tile_info.xy;
    r1.x = mad((int)r1.y, (int)r5.x, (int)r1.x);
    r1.x = mad((int)r1.x, 3, 2);
    r1.y = s_LocalLightIndexData[r1.x].x;
    r1.y = (int)r1.y & 0x0000ffff;
    r10.x = min(64, (uint)r1.y);
    r1.x = (uint)r1.x << 6;
    r10.y = (int)r1.x + (int)r5.y;
    r1.xy = (int2)r1.ww & (int2)r10.xy;
    r10.xyz = r8.xyz;
    r10.w = 1;
    r8.w = 1;
    r5.xyz = float3(0,0,0);
    r1.w = 0;
    r2.w = 0;
    r4.y = 0;
    while (true) {
      r6.w = cmp((uint)r4.y < (uint)r1.x);
      r7.w = cmp(r2.w < 1);
      r6.w = r6.w ? r7.w : 0;
      r7.w = cmp(r1.w < 1);
      r6.w = r6.w ? r7.w : 0;
      if (r6.w == 0) break;
      r6.w = (int)r1.y + (int)r4.y;
      r6.w = s_LocalLightIndexData[r6.w].x;
      r6.w = (int)r6.w & 0x0000ffff;
      r7.w = (uint)g_probe_param[r6.w].x >> 1;
      r9.w = cmp((int)r7.w == 1);
      if (r9.w != 0) {
        r9.w = (int)r6.w * 3;
        r11.x = dot(g_probe_data[r9.w].xyzw, r10.xyzw);
        r11.y = dot(g_probe_data[r9.w+1].xyzw, r10.xyzw);
        r11.z = dot(g_probe_data[r9.w+2].xyzw, r10.xyzw);
        r11.w = max(abs(r11.x), abs(r11.y));
        r11.w = max(r11.w, abs(r11.z));
        r12.x = cmp(r11.w < 0.99000001);
        r12.y = max(g_probe_param[r6.w].y, 0.00999999978);
        r12.y = min(0.99000001, r12.y);
        r12.y = 1 + -r12.y;
        r12.y = 1 / r12.y;
        r11.w = -g_probe_param[r6.w].y + r11.w;
        r11.w = saturate(-r12.y * r11.w + 1);
        r11.w = r12.x ? r11.w : 0;
        r12.x = cmp(0 < r11.w);
        if (r12.x != 0) {
          r12.x = dot(g_probe_data[r9.w].xyz, r3.xyz);
          r12.y = dot(g_probe_data[r9.w+1].xyz, r3.xyz);
          r12.z = dot(g_probe_data[r9.w+2].xyz, r3.xyz);
          r16.xyz = float3(1,1,1) + -r11.xyz;
          r16.xyz = r16.xyz / r12.xyz;
          r11.xyz = float3(-1,-1,-1) + -r11.xyz;
          r11.xyz = r11.xyz / r12.xyz;
          r11.xyz = max(r16.xyz, r11.xyz);
          r9.w = min(r11.y, r11.z);
          r9.w = min(r11.x, r9.w);
          r11.xyz = r3.xyz * r9.www + r8.xyz;
          r12.xyz = -g_probe_pos[r6.w].xyz + r11.xyz;
        } else {
          r12.xyz = r3.xyz;
        }
      } else {
        r9.w = cmp((int)r7.w == 3);
        if (r9.w != 0) {
          r11.xyz = -g_probe_pos[r6.w].xyz + r8.xyz;
          r9.w = dot(r11.xyz, r11.xyz);
          r13.w = sqrt(r9.w);
          r14.w = r13.w / g_probe_param[r6.w].z;
          r15.x = cmp(r14.w < 0.99000001);
          r16.x = max(g_probe_param[r6.w].y, 0.00999999978);
          r16.x = min(0.99000001, r16.x);
          r16.x = 1 + -r16.x;
          r16.x = 1 / r16.x;
          r14.w = -g_probe_param[r6.w].y + r14.w;
          r14.w = saturate(-r16.x * r14.w + 1);
          r11.w = r15.x ? r14.w : 0;
          r14.w = cmp(0 < r11.w);
          r11.xyz = r11.xyz / r13.www;
          r11.x = dot(r11.xyz, -r3.xyz);
          r11.y = r11.x * r13.w;
          r9.w = -r11.y * r11.y + r9.w;
          r9.w = sqrt(r9.w);
          r9.w = r9.w * r9.w;
          r9.w = g_probe_param[r6.w].z * g_probe_param[r6.w].z + -r9.w;
          r9.w = sqrt(r9.w);
          r9.w = r11.x * r13.w + r9.w;
          r11.xyz = r3.xyz * r9.www + r8.xyz;
          r11.xyz = -g_probe_pos[r6.w].xyz + r11.xyz;
          r12.xyz = r14.www ? r11.xyz : r3.xyz;
        } else {
          r9.w = cmp((int)r7.w == 2);
          if (r9.w != 0) {
            r11.xyz = -g_probe_pos[r6.w].xyz + r8.xyz;
            r9.w = dot(r11.xyz, r11.xyz);
            r9.w = sqrt(r9.w);
            r9.w = r9.w / g_probe_param[r6.w].z;
            r11.x = cmp(r9.w < 0.99000001);
            r11.y = max(g_probe_param[r6.w].y, 0.00999999978);
            r11.y = min(0.99000001, r11.y);
            r11.y = 1 + -r11.y;
            r11.y = 1 / r11.y;
            r9.w = -g_probe_param[r6.w].y + r9.w;
            r9.w = saturate(-r11.y * r9.w + 1);
            r11.w = r11.x ? r9.w : 0;
          } else {
            if (r7.w == 0) {
              r7.w = (int)r6.w * 3;
              r9.w = dot(g_probe_data[r7.w].xyzw, r8.xyzw);
              r11.x = dot(g_probe_data[r7.w+1].xyzw, r8.xyzw);
              r7.w = dot(g_probe_data[r7.w+2].xyzw, r8.xyzw);
              r9.w = max(abs(r11.x), abs(r9.w));
              r7.w = max(r9.w, abs(r7.w));
              r9.w = cmp(r7.w < 0.99000001);
              r11.x = max(g_probe_param[r6.w].y, 0.00999999978);
              r11.x = min(0.99000001, r11.x);
              r11.x = 1 + -r11.x;
              r11.x = 1 / r11.x;
              r7.w = -g_probe_param[r6.w].y + r7.w;
              r7.w = saturate(-r11.x * r7.w + 1);
              r11.w = r9.w ? r7.w : 0;
            } else {
              r11.w = 1;
            }
          }
          r12.xyz = r3.xyz;
        }
      }
      r7.w = cmp(0 < r11.w);
      if (r7.w != 0) {
        r12.z = -r12.z;
        r12.w = g_probe_pos[r6.w].w;
        r12.xyzw = s_IBLProbeArray.SampleLevel(s_IBLProbeArray_sampler_s, r12.xyzw, r0.x).xyzw;
        r6.w = 1 + -r2.w;
        r6.w = min(r11.w, r6.w);
        r5.xyz = r12.xyz * r6.www + r5.xyz;
        r1.w = r12.w * r6.w + r1.w;
        r2.w = r6.w + r2.w;
      }
      r4.y = (int)r4.y + 1;
    }
    r3.w = -r3.z;
    r3.xyz = s_IBL.SampleLevel(s_IBL_sampler_s, r3.xyw, r0.x).xyz;
    r10.xyz = float3(1,1,1) + r3.xyz;
    r10.xyz = max(float3(0,0,0), r10.xyz);
    r10.xyz = log2(r10.xyz);
    r10.xyz = u_ibl_param.xxx * r10.xyz;
    r10.xyz = exp2(r10.xyz);
    r10.xyz = float3(-1,-1,-1) + r10.xyz;
    r10.xyz = max(float3(0,0,0), r10.xyz);
    r3.xyz = -r10.xyz + r3.xyz;
    r3.xyz = r6.zzz * r3.xyz + r10.xyz;
    r0.x = saturate(1 + -r1.w);
    r1.xyw = r3.xyz * r0.xxx + r5.xyz;
    r0.x = cmp((int)r0.z == 2);
    if (r0.x != 0) {
      r3.xyzw = r6.yyyy * float4(-1,-0.0274999999,-0.572000027,0.0219999999) + float4(1,0.0425000004,1.03999996,-0.0399999991);
      r0.x = r3.x * r3.x;
      r0.z = -9.27999973 * r20.x;
      r0.z = exp2(r0.z);
      r0.x = min(r0.x, r0.z);
      r0.x = r0.x * r3.x + r3.y;
      r0.xz = r0.xx * float2(-1.03999996,1.03999996) + r3.zw;
    } else {
      r20.w = r6.y;
      r0.xz = s_EnvBRDF.SampleLevel(s_EnvBRDF_sampler_s, r20.xw, 0).xy;
    }
    r3.xyz = r4.xzw * r0.xxx + r0.zzz;
    r1.xyw = r3.xyz * r1.xyw;
    r15.yzw = max(float3(0,0,0), r1.xyw);
    break;
    case 30 :    r6.x = r20.x;
    r15.yz = s_EnvBRDF.SampleLevel(s_EnvBRDF_sampler_s, r6.xy, 0).xy;
    r15.w = 0;
    break;
    case 31 :    r1.xyw = float3(0.00999999978,0.00999999978,0.00999999978) * r8.xyz;
    r3.xyz = cmp(r1.xyw >= -r1.xyw);
    r1.xyw = frac(abs(r1.xyw));
    r1.xyw = r3.xyz ? r1.xyw : -r1.xyw;
    r1.xyw = float3(1,1,1) + r1.xyw;
    r3.xyz = cmp(r1.xyw >= float3(0,0,0));
    r3.xyz = r3.xyz ? float3(1,1,1) : 0;
    r15.yzw = r3.xyz + r1.xyw;
    break;
    case 32 :    r1.xyw = (int3)r0.yyy & int3(1,2,4);
    r15.yzw = r1.xyw ? float3(1,1,1) : float3(0,0,0);
    break;
    case 39 :    if (2 == 0) r0.x = 0; else if (2+4 < 32) {     r0.x = (uint)r0.y << (32-(2 + 4)); r0.x = (uint)r0.x >> (32-2);    } else r0.x = (uint)r0.y >> 4;
    r0.x = 1 << (int)r0.x;
    r0.x = (int)r0.x & 2;
    r15.yzw = r0.xxx ? float3(1,1,1) : float3(0,0,0);
    break;
    case 40 :    r0.x = g_global_user_param_3.y + -g_global_user_param_3.x;
    r0.z = -g_global_user_param_3.x + r1.z;
    r15.yzw = r0.zzz / r0.xxx;
    break;
    case 41 :    r1.xyz = (int3)r0.yyy & int3(1,2,4);
    r1.xyz = r1.xyz ? float3(0.5,0.5,0.5) : float3(0,0,0);
    r0.x = r5.w ? 3 : 1;
    r15.yzw = r1.xyz * r0.xxx;
    break;
    case 42 :    if (2 == 0) r0.x = 0; else if (2+4 < 32) {     r0.x = (uint)r0.y << (32-(2 + 4)); r0.x = (uint)r0.x >> (32-2);    } else r0.x = (uint)r0.y >> 4;
    r0.xyz = cmp((int3)r0.xxx == int3(1,2,3));
    r15.yzw = r0.xyz ? float3(1,1,1) : 0;
    break;
    default :
    r17.x = 0;
    break;
  }
  r1.xyzw = r17.xxxx ? float4(0,0,0,1) : r21.xyzw;
  r0.xyz = r17.xxx ? float3(0,0,0) : r13.xyz;
  if (r0.w != 0) {
    r0.w = 0.5 * r14.x;
    r0.w = max(0.00999999978, r0.w);
    r0.w = min(0.49000001, r0.w);
    r2.w = trunc(r14.y);
    r3.w = r2.w + r0.w;
    r0.w = (uint)r3.w;
    r0.w = (int)r0.w & 15;
    r4.xyz = u_lightColor.xyz * r2.xyz;
    r4.xyz = float3(0.318309873,0.318309873,0.318309873) * r4.xyz;
    r4.xyz = ssss_colors[r0.w].xyz * r4.xyz;
    r0.w = -ssss_colors[r0.w].w + 1;
    r0.w = ssss_param.x * r0.w;
    r2.w = max(10, ssss_param.z);
    r0.w = r2.w * r0.w;
    r0.w = -r0.w * r0.w;
    r5.xyzw = float4(225.421097,29.8077488,7.71494627,2.54443574) * r0.wwww;
    r5.xyzw = exp2(r5.xyzw);
    r5.xy = float2(0.232999995,0.100000001) * r5.xy;
    r2.w = r5.x + r5.y;
    r2.w = r5.z * 0.118000001 + r2.w;
    r2.w = r5.w * 0.112999998 + r2.w;
    r5.xy = float2(0.724972427,0.194695696) * r0.ww;
    r5.xy = exp2(r5.xy);
    r0.w = r5.x * 0.35800001 + r2.w;
    r0.w = r5.y * 0.0780000016 + r0.w;
    r2.w = dot(u_lightDirection.xyz, -r7.xyz);
    r2.w = saturate(0.300000012 + r2.w);
    r0.w = r2.w * r0.w;
    r4.xyz = r0.www * r4.xyz;
    r4.xyz = r4.xyz * r14.zzz + r15.yzw;
    r1.xyz = r0.xyz + r1.xyz;
    r2.xyz = r9.xyz * r2.xyz;
    r3.xyz = r2.xyz * ssss_ambient_boost.xyz + r4.xyz;
  } else {
    r0.xyz = r15.yzw + r0.xyz;
    r1.xyz = r0.xyz + r1.xyz;
    r3.xyzw = float4(0,0,0,0);
  }
  rw_Output1[vThreadID.xy] = r3;
  rw_Output0[vThreadID.xy] = r1;
  return;
}
