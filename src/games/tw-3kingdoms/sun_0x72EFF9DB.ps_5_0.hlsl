// ---- Created with 3Dmigoto v1.4.1 on Thu Oct 23 20:50:43 2025
// Sun billboard shader: fetches the star texture, tints it with the sun colour
// and scales intensity by the brightness factor. Specular/ambient settings from
// lighting cbuffer are unused here.

cbuffer lighting_VS_PS : register(b0)
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

cbuffer sun_VS : register(b1)
{
  float4x4 g_world_view : packoffset(c0);
  float4x4 g_projection : packoffset(c4);
  float g_sun_scale : packoffset(c8);
  float g_sun_brightness_factor : packoffset(c8.y);
}

SamplerState s_diffuse_s : register(s0);
Texture2D<float4> t_diffuse : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t_diffuse.Sample(s_diffuse_s, v1.xy).xyzw;
  // Apply sun colour and global brightness.
  r0.xyz = sun_colour.xyz * r0.xyz;
  o0.w = r0.w;
  o0.xyz = g_sun_brightness_factor * r0.xyz;
  return;
}