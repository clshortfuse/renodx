// ---- Created with 3Dmigoto v1.4.1 on Tue Oct 14 22:37:26 2025

cbuffer prim3d_planet_corona_cb_data : register(b1)
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

  float3 corona_position : packoffset(c2);
  float corona_radius : packoffset(c2.w);
  float corona_curvature_bleed_distance : packoffset(c3);
  float2 prim3d_planet_corona_cb_data_padding : packoffset(c3.y);
}

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

SamplerState wrap_sampler_s : register(s0);
Texture2DMS<float> depth_texture : register(t0);
Texture2D<float4> base_texture_0 : register(t1);
Texture2D<float4> noise_texture : register(t3);


// 3Dmigoto declarations
#define cmp -


// Planetary corona pixel shader. Builds HDR glow colour from base/ noise textures,
// applies curvature-based falloff, depth fade, and emits emissive contribution.
void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : POSITION0,
  float3 v2 : POSITION1,
  float4 v3 : COLOR0,
  float4 v4 : COLOR1,
  float4 v5 : TEXCOORD0,
  float3 v6 : TEXCOORD1,
  out float4 o0 : SV_TARGET0,
  out float4 o1 : SV_TARGET1,
  out float4 o2 : SV_TARGET2)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Sample colour and convert from sRGB to linear space.
  r0.xyzw = base_texture_0.Sample(wrap_sampler_s, v5.xy).xyzw;
  r1.xyz = r0.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
  r1.xyz = sqrt(r1.xyz);
  r1.xyz = float3(31.2429695,31.2429695,31.2429695) * r1.xyz;
  r1.xyz = r0.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r1.xyz;
  r1.xyz = float3(35.3486404,35.3486404,35.3486404) + r1.xyz;
  r2.xyz = cmp(r0.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
  r3.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  r0.xyz = r2.xyz ? r3.xyz : r1.xyz;
  // --- Secondary noise texture used to add colour breakup.
  r1.xyzw = noise_texture.Sample(wrap_sampler_s, v5.xy).xyzw;
  r2.xyz = r1.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
  r2.xyz = sqrt(r2.xyz);
  r2.xyz = float3(31.2429695,31.2429695,31.2429695) * r2.xyz;
  r2.xyz = r1.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r2.xyz;
  r2.xyz = float3(35.3486404,35.3486404,35.3486404) + r2.xyz;
  r3.xyz = cmp(r1.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
  r4.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r1.xyz;
  r1.xyz = r3.xyz ? r4.xyz : r2.xyz;
  r0.xyzw = saturate(r1.xyzw * float4(0.75,0.75,0.75,0.75) + r0.xyzw); // Blend noise with base emission.
  r1.xyz = v3.xyz * r0.xyz;
  r0.xyz = -r0.xyz * v3.xyz + float3(1,0.600000024,0.300000012);
  r0.w = log2(r0.w);
  r0.w = basic_constants_0.alpha_ramp_growth_delay * r0.w;
  r0.w = exp2(r0.w);
  r0.w = 1.5 * r0.w;
  // --- Compute sun direction and camera relationship.
  r2.xyz = light_position.xyz + -corona_position.xyz;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r2.xyz * r1.www;
  r3.xyz = -corona_position.xyz + v2.xyz;
  r1.w = dot(r3.xyz, r3.xyz);
  r2.w = rsqrt(r1.w);
  r1.w = sqrt(r1.w);
  r1.w = -0.800000012 + r1.w;
  r1.w = saturate(5.00000048 * r1.w);
  r3.xyz = r3.xyz * r2.www;
  r2.w = dot(r3.xyz, r2.xyz);
  r3.w = saturate(r2.w);
  r2.w = corona_curvature_bleed_distance + r2.w;
  r2.w = saturate(r2.w / corona_curvature_bleed_distance);
  r4.x = r3.w * r3.w;
  r3.w = r4.x * r3.w;
  r0.xyz = r3.www * r0.xyz + r1.xyz;
  // --- Fade with camera forward vector to avoid backface glow leaks.
  r1.x = dot(-v2.xyz, -v2.xyz);
  r1.x = rsqrt(r1.x);
  r1.xyz = -v2.xyz * r1.xxx;
  r2.x = dot(r1.xyz, r2.xyz);
  r1.x = saturate(dot(r3.xyz, r1.xyz));
  r1.x = 1 + -r1.x;
  r1.y = -r2.x * 1.20000005 + 1.36000001;
  r1.y = max(0.0500000007, r1.y);
  r1.y = log2(r1.y);
  r1.y = 1.5 * r1.y;
  r1.y = exp2(r1.y);
  r1.y = 0.639999986 / r1.y;
  r1.y = r1.y * 2 + 1;
  r0.xyz = r1.yyy * r0.xyz;
  r0.xyz = r0.xyz * r2.www;
  r1.y = r1.w * -2 + 3;
  r1.z = r1.w * r1.w;
  r1.y = r1.y * r1.z;
  r1.z = r1.x * r1.x;
  r1.x = r1.x * r1.z;
  r1.x = r1.x * r1.y;
  r1.y = dot(v2.xyz, v2.xyz);
  r1.y = sqrt(r1.y);
  r1.y = -r1.y * 1.99999999e-06 + 1;
  r1.y = max(0, r1.y);
  r1.x = r1.x * r1.y;
  r3.xyz = r1.xxx * r0.xyz;
  r0.x = basic_constants_0.alpha_ramp_curvature * r0.w + basic_constants_0.alpha_ramp_steepness;
  r0.x = saturate(r0.w * r0.x);
  r0.y = basic_constants_0.alpha_ramp_max_alpha_scalar * v3.w;
  r0.x = r0.x * r0.y;
  r4.xy = (int2)v0.xy;
  r4.zw = float2(0,0);
  // --- Depth dependent opacity so the corona fades into geometry.
  r0.y = depth_texture.Load(r4.xy, 0).x;
  r0.y = -r0.y * camera_far_z_minus_near_z + camera_far_z;
  r0.y = camera_far_z_times_near_z / r0.y;
  r0.y = -v1.z + r0.y;
  r0.z = max(9.99999975e-05, basic_constants_0.depth_fade_distance);
  r0.y = saturate(r0.y / r0.z);
  r0.y = basic_constants_0.depth_fade_opacity * r0.y;
  r0.x = r0.x * r0.y;
  r0.x = r0.x * r2.w;
  r3.w = r0.x * r1.x;
  o0.xyzw = r3.xyzw;
  o1.xyzw = basic_constants_0.emissive_factor * r3.xyzw;
  o2.xyzw = float4(0,0,0,0);
  return;
}