// ---- Created with 3Dmigoto v1.4.1 on Tue Oct 14 22:37:26 2025

cbuffer prim3d_scene_cb_data : register(b0)
{
  float4x4 view : packoffset(c0);
  float4x4 view_projection : packoffset(c4);
  float time : packoffset(c8);
  float3 light_position : packoffset(c8.y);
  float camera_far_z : packoffset(c9);
  float camera_far_z_times_near_z : packoffset(c9.y);
  float camera_far_z_minus_near_z : packoffset(c9.z);
  float prim3d_scene_constants_padding : packoffset(c9.w);
}

cbuffer prim3d_basic_cb_data_register_wrapper : register(b1)
{

  struct
  {
    float emissive_factor;
    float depth_fade_opacity;
    float depth_fade_distance;
    float alpha_ramp_curvature;
    float alpha_ramp_steepness;
    float alpha_ramp_growth_delay;
    float alpha_ramp_max_alpha_scalar;
    float prim3d_basic_cb_data_padding;
  } basic_constants_0 : packoffset(c0);

}

SamplerState wrap_sampler_s : register(s0);
Texture2DMS<float> depth_texture : register(t0);
Texture2D<float4> base_texture_0 : register(t1);
Texture2D<float4> base_texture_1 : register(t2);


// 3Dmigoto declarations
#define cmp -


// Volumetric sprite shader for atmosphere/nebula planes. Samples two textures, computes alpha ramp,
// applies depth fade, and writes both colour and emissive targets.
void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : POSITION0,
  float3 v2 : POSITION1,
  float4 v3 : COLOR0,
  float4 v4 : TEXCOORD0,
  float4 v5 : TEXCOORD1,
  float3 v6 : TEXCOORD2,
  out float4 o0 : SV_TARGET0,
  out float4 o1 : SV_TARGET1,
  out float4 o2 : SV_TARGET2)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Sample base and secondary textures, convert from sRGB to linear.
  r0.xyzw = base_texture_0.Sample(wrap_sampler_s, v4.xy).xyzw;
  r1.xyz = r0.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
  r1.xyz = sqrt(r1.xyz);
  r1.xyz = float3(31.2429695,31.2429695,31.2429695) * r1.xyz;
  r1.xyz = r0.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r1.xyz;
  r1.xyz = float3(35.3486404,35.3486404,35.3486404) + r1.xyz;
  r2.xyz = cmp(r0.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
  r3.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  r0.xyz = r2.xyz ? r3.xyz : r1.xyz;
  r1.xyzw = base_texture_1.Sample(wrap_sampler_s, v4.xy).xyzw;
  r2.xyz = r1.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
  r2.xyz = sqrt(r2.xyz);
  r2.xyz = float3(31.2429695,31.2429695,31.2429695) * r2.xyz;
  r2.xyz = r1.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r2.xyz;
  r2.xyz = float3(35.3486404,35.3486404,35.3486404) + r2.xyz;
  r3.xyz = cmp(r1.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
  r4.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r1.xyz;
  r1.xyz = r3.xyz ? r4.xyz : r2.xyz;
  r0.xyzw = r1.xyzw + r0.xyzw; // Combine the two layers before lighting.
  r0.w = log2(r0.w);
  r1.xyz = v3.xyz * r0.xyz;
  // --- Procedural alpha ramp along the particle lifetime.
  r0.x = basic_constants_0.alpha_ramp_growth_delay * r0.w;
  r0.x = exp2(r0.x);
  r0.y = basic_constants_0.alpha_ramp_curvature * r0.x + basic_constants_0.alpha_ramp_steepness;
  r0.x = saturate(r0.x * r0.y);
  r0.y = basic_constants_0.alpha_ramp_max_alpha_scalar * v3.w;
  r0.x = r0.x * r0.y;
  r2.xy = (int2)v0.xy;
  r2.zw = float2(0,0);
  // --- Depth based fade to avoid intersecting nearby geometry.
  r0.y = depth_texture.Load(r2.xy, 0).x;
  r0.y = -r0.y * camera_far_z_minus_near_z + camera_far_z;
  r0.y = camera_far_z_times_near_z / r0.y;
  r0.y = -v1.z + r0.y;
  r0.z = max(9.99999975e-05, basic_constants_0.depth_fade_distance);
  r0.y = saturate(r0.y / r0.z);
  r0.y = basic_constants_0.depth_fade_opacity * r0.y;
  r1.w = r0.x * r0.y;
  o0.xyzw = r1.xyzw;
  o1.xyzw = basic_constants_0.emissive_factor * r1.xyzw;
  o2.xyzw = float4(0,0,0,0);
  return;
}