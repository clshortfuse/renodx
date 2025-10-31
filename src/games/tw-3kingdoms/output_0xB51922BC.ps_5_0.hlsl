#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 10 20:09:49 2025

struct Auto_exposure_output
{
    float tone_mapper_brightness;  // Offset:    0
};

cbuffer colorimetry_VS_PS : register(b0)
{
  float g_brightness : packoffset(c0);
  float g_gamma_output : packoffset(c0.y);
  float g_inv_gamma_output : packoffset(c0.z);
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

cbuffer tone_mapping : register(b2)
{
  float g_tone_mapping_brightness : packoffset(c0);
  float g_tone_mapping_burn : packoffset(c0.y);
  int g_use_auto_exposure : packoffset(c0.z);
}

cbuffer hdr_to_screen_PS : register(b3)
{
  float4x4 colour_matrix : packoffset(c0);
  float lut_weights[3] : packoffset(c4);
  float overscan : packoffset(c6.y);
  int require_distortion_composition : packoffset(c6.z);
}

SamplerState g_hdr_rgb_texture_sampler_s : register(s0);
SamplerState g_hdr_rgb_bloom_texture_sampler_s : register(s1);
SamplerState distortion_sampler_s : register(s2);
SamplerState lut_sampler_s : register(s3);
Texture2D<float4> g_hdr_rgb_texture : register(t0);
Texture2D<float4> g_hdr_rgb_bloom_texture : register(t1);
StructuredBuffer<Auto_exposure_output> g_auto_exposure_input_buffer : register(t2);
Texture2D<float4> distortion_texture : register(t3);
Texture3D<float4> lut_texture_1 : register(t4);
Texture3D<float4> lut_texture_2 : register(t5);
Texture3D<float4> lut_texture_3 : register(t6);
Texture3D<float4> lut_secondary_texture_1 : register(t7);
Texture3D<float4> lut_secondary_texture_2 : register(t8);
Texture3D<float4> lut_secondary_texture_3 : register(t9);
Texture2D<uint4> screen_stencil_texture : register(t10);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = g_screen_size.zw * v0.xy;
  r0.zw = overscan * r0.xy;
  r1.xy = overscan * g_screen_size.zw;
  r1.zw = float2(0.5,0.5) * r1.xy;
  r0.xy = r0.xy * overscan + -r1.zw;
  r1.zw = distortion_texture.SampleLevel(distortion_sampler_s, r0.xy, 0).xy;
  r0.xy = r1.zw * float2(0.00999999978,0.00999999978) + r0.xy;
  r0.xy = r1.xy * float2(0.5,0.5) + r0.xy;
  r0.xy = require_distortion_composition ? r0.xy : r0.zw;
  r1.xyz = g_hdr_rgb_texture.SampleLevel(g_hdr_rgb_texture_sampler_s, r0.xy, 0).xyz;
  r0.xyz = g_hdr_rgb_bloom_texture.SampleLevel(g_hdr_rgb_bloom_texture_sampler_s, r0.xy, 0).xyz;
  r0.xyz = r1.xyz + r0.xyz;

  float3 untonemapped = r0.xyz;

  r0.w = g_auto_exposure_input_buffer[0].tone_mapper_brightness;
  r0.w = g_use_auto_exposure ? r0.w : g_tone_mapping_brightness;
  r1.x = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r1.y = cmp(r1.x != 0.000000);
  r0.w = r0.w * r0.w;
  r1.z = r0.w * r1.x;
  r1.w = 1 / g_tone_mapping_burn;
  r1.w = -0.999000013 + r1.w;
  r1.w = r1.z / r1.w;
  r1.w = 1 + r1.w;
  r1.z = r1.z * r1.w;
  r0.w = r0.w * r1.x + 1;
  r0.w = r1.z / r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = r0.xyz / r1.xxx;
  r0.w = 1;
  r0.xyzw = r1.yyyy ? r0.xyzw : 0;
  r1.xyz = saturate(g_brightness * r0.xyz);
  r1.xyz = log2(r1.xyz);
  r1.xyz = g_inv_gamma_output * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.w = 1;
  r2.x = dot(r1.xyzw, colour_matrix._m00_m10_m20_m30);
  r2.y = dot(r1.xyzw, colour_matrix._m01_m11_m21_m31);
  r2.z = dot(r1.xyzw, colour_matrix._m02_m12_m22_m32);
  r1.xy = overscan * v0.xy;
  r1.xy = (int2)r1.xy;
  r1.zw = float2(0,0);
  r1.x = screen_stencil_texture.Load(r1.xyz).y;
  r1.x = (int)r1.x & 128;
  r1.x = cmp((int)r1.x != 0);
        renodx::lut::Config lut_config = renodx::lut::config::Create();
        lut_config.lut_sampler = lut_sampler_s;
        lut_config.size = 32u;
        lut_config.tetrahedral = true;
        lut_config.scaling = 1.0f;
        lut_config.type_input = renodx::lut::config::type::SRGB;
        lut_config.type_output = renodx::lut::config::type::SRGB;

        float3 lut_input_linear = renodx::color::srgb::DecodeSafe(saturate(r2.xyz));
        float3 lut_output_linear;

        if (r1.x == 0) {
          float3 lut1 = renodx::lut::Sample(lut_input_linear, lut_config, lut_texture_1);
          float3 lut2 = renodx::lut::Sample(lut_input_linear, lut_config, lut_texture_2);
          float3 lut3 = renodx::lut::Sample(lut_input_linear, lut_config, lut_texture_3);
          lut_output_linear = lut1 * lut_weights[0] + lut2 * lut_weights[1] + lut3 * lut_weights[2];
        } else {
          float3 lut1 = renodx::lut::Sample(lut_input_linear, lut_config, lut_secondary_texture_1);
          float3 lut2 = renodx::lut::Sample(lut_input_linear, lut_config, lut_secondary_texture_2);
          float3 lut3 = renodx::lut::Sample(lut_input_linear, lut_config, lut_secondary_texture_3);
          lut_output_linear = lut1 * lut_weights[0] + lut2 * lut_weights[1] + lut3 * lut_weights[2];
        }

        r0.xyz = renodx::color::srgb::EncodeSafe(saturate(lut_output_linear));
  o0.xyz = r0.xyz;
  o0.w = 1.0f;  // Initialize alpha channel to fix warning
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
    o0.xyz = renodx::draw::ToneMapPass(untonemapped, o0.xyz);
    o0.xyz = renodx::effects::ApplyFilmGrain(
        o0.xyz,
        v1.xy,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.03f);
    o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
  } else {
    o0.xyz = saturate(o0.xyz);
  }
  return;
}

//Alternative LUT sampling code with RenoDX

// Primary LUT path with RenoDX scaling
// renodx::lut::Config lut_config = renodx::lut::config::Create();

// lut_config.lut_sampler = lut_sampler_s;
// lut_config.size = 32u;
// lut_config.tetrahedral = true;
// lut_config.scaling = 1.0f;  // Apply scaling to fix raised floor

// Sample and blend the three primary LUTs with RenoDX scaling
// float3 lut1 = renodx::lut::Sample(r2.xyz, lut_config, lut_texture_1);
// float3 lut2 = renodx::lut::Sample(r2.xyz, lut_config, lut_texture_2);
// float3 lut3 = renodx::lut::Sample(r2.xyz, lut_config, lut_texture_3);

// r0.xyz = lut1 * lut_weights[0] + lut2 * lut_weights[1] + lut3 * lut_weights[2];
// } else {
//  Secondary LUT path with RenoDX scaling
// renodx::lut::Config lut_config = renodx::lut::config::Create();
// lut_config.lut_sampler = lut_sampler_s;
// lut_config.size = 32u;
// lut_config.tetrahedral = true;
// lut_config.scaling = 1.0f;  // Apply scaling to fix raised floor

// Sample and blend the three secondary LUTs with RenoDX scaling
// float3 lut1 = renodx::lut::Sample(r2.xyz, lut_config, lut_secondary_texture_1);
// float3 lut2 = renodx::lut::Sample(r2.xyz, lut_config, lut_secondary_texture_2);
// float3 lut3 = renodx::lut::Sample(r2.xyz, lut_config, lut_secondary_texture_3);

// r0.xyz = lut1 * lut_weights[0] + lut2 * lut_weights[1] + lut3 * lut_weights[2];


//Original LUT sampling code

//if (r1.x == 0) {
  //r1.xyz = lut_texture_1.SampleLevel(lut_sampler_s, r2.xyz, 0).xyz;
  //r3.xyz = lut_texture_2.SampleLevel(lut_sampler_s, r2.xyz, 0).xyz;
  //r3.xyz = lut_weights[1] * r3.xyz;
  //r1.xyz = r1.xyz * lut_weights[0] + r3.xyz;
  //r3.xyz = lut_texture_3.SampleLevel(lut_sampler_s, r2.xyz, 0).xyz;
  //r0.xyz = r3.xyz * lut_weights[2] + r1.xyz;
//} else {
  //r1.xyz = lut_secondary_texture_1.SampleLevel(lut_sampler_s, r2.xyz, 0).xyz;
  //r3.xyz = lut_secondary_texture_2.SampleLevel(lut_sampler_s, r2.xyz, 0).xyz;
  //r3.xyz = lut_weights[1] * r3.xyz;
  //r1.xyz = r1.xyz * lut_weights[0] + r3.xyz;
  //r2.xyz = lut_secondary_texture_3.SampleLevel(lut_sampler_s, r2.xyz, 0).xyz;
 // r0.xyz = r2.xyz * lut_weights[2] + r1.xyz;
//}
