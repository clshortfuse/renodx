#include "./shared.h"

// Rome 2's HDR presentation pass: samples the distorted scene colour, applies
// god rays, evaluates fog-of-war masks, then transforms the result through the
// colour grading matrix this title uses in its swap-chain resolve.
// ---- Created with 3Dmigoto v1.4.1 on Thu Oct  9 18:32:57 2025

cbuffer camera_VS_PS : register(b0)
{
  float3 camera_position : packoffset(c0);
  float4x4 view : packoffset(c1);
  float4x4 projection : packoffset(c5);
  float4x4 view_projection : packoffset(c9);
  float4x4 inv_view : packoffset(c13);
  float4x4 inv_projection : packoffset(c17);
  float4x4 inv_view_projection : packoffset(c21);
  float4 camera_near_far : packoffset(c25);
  float time_in_sec : packoffset(c26);
  float2 g_inverse_focal_length : packoffset(c26.y);
  float g_vertical_fov : packoffset(c26.w);
  float4 g_screen_size : packoffset(c27);
  float g_vpos_texel_offset : packoffset(c28);
  float4 g_viewport_dimensions : packoffset(c29);
  float4 g_camera_temp0 : packoffset(c30);
  float4 g_camera_temp1 : packoffset(c31);
  float4 g_camera_temp2 : packoffset(c32);
  float4 g_clip_rect : packoffset(c33);
  float g_hide_foliage : packoffset(c34);
}

cbuffer colorimetry_VS_PS : register(b1)
{
  float g_brightness : packoffset(c0);
  float g_gamma_output : packoffset(c0.y);
  float g_inv_gamma_output : packoffset(c0.z);
}

cbuffer shared_fog_of_war_PS : register(b2)
{
  float g_fog_of_war_blend : packoffset(c0);
  float g_fog_of_war_outfield_blend : packoffset(c0.y);
}

cbuffer hdr_to_screen_PS : register(b3)
{
  float radial_blur_strength : packoffset(c0);
  float2 radial_blur_position : packoffset(c0.y);
  float focus_distance : packoffset(c0.w);
  float focal_length : packoffset(c1);
  float blur_kernel_scale : packoffset(c1.y);
  float2 grain_tex_offset : packoffset(c1.z);
  float4x4 colour_matrix : packoffset(c2);
  float4 pos_transform : packoffset(c6);
  float4 sample_data_9x9[81] : packoffset(c7);
  float4 sample_data_5x5[25] : packoffset(c88);
  float4 sample_data_3x3[9] : packoffset(c113);
}

SamplerState gbuffer_channel_4_sampler_s : register(s0);
SamplerState s_fog_of_war_mask_s : register(s1);
SamplerState frame_sampler_s : register(s2);
SamplerState distortion_sampler_s : register(s3);
SamplerState god_rays_sampler_s : register(s4);
Texture2D<float4> distortion_sampler : register(t0);
Texture2D<float4> frame_sampler : register(t1);
Texture2D<float4> god_rays_sampler : register(t2);
Texture2D<float4> gbuffer_channel_4_sampler : register(t3);
Texture2D<float4> s_fog_of_war_mask : register(t4);


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

  // Convert SV_Position to normalised UVs that match the game's screen scaling.
  r0.xy = g_vpos_texel_offset + v0.xy;
  r0.xy = g_screen_size.zw * r0.xy;
  // Pull the per-pixel refraction offset, then fold it back into the UVs.
  r1.xyzw = distortion_sampler.SampleLevel(distortion_sampler_s, r0.xy, r0.y).xyzw;
  r0.zw = float2(-0.498039216,-0.498039216) + r1.xy;
  r0.xy = r0.zw * float2(0.0199999996,0.0199999996) + r0.xy;
  // Base scene colour and light shafts come next.
  r1.xyzw = frame_sampler.SampleLevel(frame_sampler_s, r0.xy, r0.y).xyzw;
  r2.xyzw = god_rays_sampler.Sample(god_rays_sampler_s, r0.xy).xyzw;
  r2.xyz = r2.xxx * float3(0.100000001,0.100000001,0.100000001) + r1.xyz;
  // Decode depth from the gbuffer to reconstruct the world position along the ray.
  r3.xyzw = gbuffer_channel_4_sampler.SampleLevel(gbuffer_channel_4_sampler_s, r0.xy, r0.y).yzxw;
  r3.xy = r0.xy * float2(2,-2) + float2(-1,1);
  r3.w = 1;
  r0.x = dot(r3.xyzw, inv_view_projection._m00_m10_m20_m30);
  r0.w = dot(r3.xyzw, inv_view_projection._m02_m12_m22_m32);
  r0.y = dot(r3.xyzw, inv_view_projection._m03_m13_m23_m33);
  r0.xy = r0.xw / r0.yy;
  r0.xw = r0.xy * float2(0.00048828125,0.00048828125) + float2(0.5,0.5);
  r2.w = 1 + -r0.w;
  r3.x = cmp(r0.x < 0);
  r3.y = cmp(1 < r0.x);
  r3.x = (int)r3.y | (int)r3.x;
  r3.y = cmp(r2.w < 0);
  r3.x = (int)r3.y | (int)r3.x;
  r2.w = cmp(1 < r2.w);
  r2.w = (int)r2.w | (int)r3.x;
  if (r2.w == 0) {
    // Inside the clip rect: sample fog-of-war and mix in the developer-selected
    // outfield blend to hide unseen units.
    r0.yz = float2(1,1) + -r0.xw;
    r3.xyzw = s_fog_of_war_mask.SampleLevel(s_fog_of_war_mask_s, r0.xz, 0).xyzw;
    r2.w = cmp(g_fog_of_war_outfield_blend < 1);
    r0.xyzw = float4(50,50,50,50) * r0.xyzw;
    r0.xyzw = min(float4(1,1,1,1), r0.xyzw);
    r0.xy = min(r0.xz, r0.yw);
    r0.x = min(r0.x, r0.y);
    r0.x = 1 + -r0.x;
    r0.x = max(r3.x, r0.x);
    r0.x = r2.w ? r0.x : r3.x;
    r0.y = 1 + -g_fog_of_war_blend;
    r0.x = max(r0.x, r0.y);
  } else {
    r0.x = -g_fog_of_war_outfield_blend * g_fog_of_war_blend + 1;
  }
  r0.y = dot(r2.xyz, float3(0.270000011, 0.670000017, 0.0599999987));
  r1.xyz = float3(0.25,0.25,0.25) * r0.yyy;
  r2.xyz = -r0.yyy * float3(0.25,0.25,0.25) + r2.xyz;
  r2.w = 0;
  // Blend towards the grey fallback driven by fog-of-war, then feed the game's
  // SDR grading chain into RenoDX's tone mapper.
  const float4 fogged_color = r0.xxxx * r2.xyzw + r1.xyzw;
  const float3 linear_untonemapped = fogged_color.xyz;
  const float alpha = fogged_color.w;

  const float3 brightness_color = max(float3(1.0e-06,1.0e-06,1.0e-06), g_brightness * linear_untonemapped);
  const float3 gamma_encoded = exp2(g_inv_gamma_output * log2(brightness_color));
  const float4 colour_input = float4(gamma_encoded, 1);
  const float3 graded_sdr_color = float3(
      dot(colour_input, colour_matrix._m00_m10_m20_m30),
      dot(colour_input, colour_matrix._m01_m11_m21_m31),
      dot(colour_input, colour_matrix._m02_m12_m22_m32));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    const float3 tonemapped = renodx::draw::ToneMapPass(linear_untonemapped, graded_sdr_color);
    o0.xyz = renodx::draw::RenderIntermediatePass(tonemapped);
  } else {
    o0.xyz = graded_sdr_color;
  }
  o0.w = alpha;
  return;
}