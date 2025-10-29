// ---- Created with 3Dmigoto v1.4.1 on Tue Oct 14 22:37:26 2025

struct mesh_light_sb_data
{
    float4 color;                  // Offset:    0
    float intensity;               // Offset:   16
    float surface_radius;          // Offset:   20
    float angle;                   // Offset:   24
    float attenuation_radius;      // Offset:   28
    float3 position;               // Offset:   32
    uint type;                     // Offset:   44
    float3 direction;              // Offset:   48
    float length;                  // Offset:   60
};

struct light_cluster_sb_data
{
    uint offset;                   // Offset:    0
    uint count;                    // Offset:    4
    float2 light_cluster_padding;  // Offset:    8
};

struct light_index_sb_data
{
    uint index;                    // Offset:    0
    float3 light_index_padding;    // Offset:    4
};

cbuffer mesh_player_color_cb_data : register(b7)
{
  float4 player_color_primary_srgb : packoffset(c0);
  float4 player_color_secondary_srgb : packoffset(c1);
  float4 player_color_primary_emissive_srgb : packoffset(c2);
  float4 player_color_secondary_emissive_srgb : packoffset(c3);
}

cbuffer mesh_scene_cb_data : register(b0)
{
  float4x4 view : packoffset(c0);
  float4x4 view_projection : packoffset(c4);
  float4 camera_position : packoffset(c8);
  float time : packoffset(c9);
  float3 mesh_scene_cb_data_padding : packoffset(c9.y);
}

cbuffer shadow_ps_cb_data : register(b5)
{
  float shadow_map_texel_size : packoffset(c0);
  float shadow_depth_bias : packoffset(c0.y);
  float use_pcf_based_shadows : packoffset(c0.z);
  float shadow_ps_cb_data_padding : packoffset(c0.w);
}

cbuffer mesh_material_cb_data : register(b2)
{
  float4 base_color_factor : packoffset(c0);
  float4 roughness_metallic_emissive_factors : packoffset(c1);
  float parallax_factor : packoffset(c2);
  float3 mesh_material_cb_data_padding : packoffset(c2.y);
}

cbuffer ExFeaturesCB : register(b9)
{
  uint g_toon_enabled : packoffset(c0);
  uint g_retro_enabled : packoffset(c0.y);
  uint g_liq_crys_enabled : packoffset(c0.z);
  float3 g_pad : packoffset(c1);
}

cbuffer froxel_cb_data : register(b3)
{
  uint3 froxel_counts : packoffset(c0);
  uint froxel_size_in_pixels : packoffset(c0.w);
  float froxel_z_scale : packoffset(c1);
  float froxel_z_bias : packoffset(c1.y);
  float2 froxel_constants_padding : packoffset(c1.z);
}

SamplerState mesh_anisotropic_wrap_sampler_s : register(s0);
SamplerState mesh_point_clamp_sampler_s : register(s2);
SamplerState mesh_linear_clamp_sampler_s : register(s3);
Texture2D<float4> base_color_texture : register(t0);
Texture2D<float4> occlusion_roughness_metallic_texture : register(t1);
Texture2D<float4> normal_texture : register(t2);
Texture2D<float4> mask_texture : register(t3);
TextureCube<float4> radiance_texture : register(t4);
TextureCube<float4> irradiance_texture : register(t5);
Texture2D<float4> dfg_texture : register(t6);
StructuredBuffer<mesh_light_sb_data> lights : register(t7);
StructuredBuffer<light_cluster_sb_data> light_clusters : register(t8);
StructuredBuffer<light_index_sb_data> light_indices : register(t9);
StructuredBuffer<light_index_sb_data> culled_lights : register(t10);
Texture2D<float4> shadow_map_texture : register(t11);


// 3Dmigoto declarations
#define cmp -


// PBR shader with player colour remapping and clustered lighting. Comments explain the major steps
// in the 3Dmigoto register output: parallax occlusion, palette blending, light accumulation.
void main(
  float4 v0 : SV_POSITION0,
  float3 v1 : POSITION0,
  float w1 : TEXCOORD0,
  float3 v2 : POSITION1,
  float3 v3 : POSITION2,
  float3 v4 : NORMAL0,
  float3 v5 : TANGENT0,
  float2 v6 : TEXCOORD1,
  float2 w6 : TEXCOORD2,
  float4 v7 : TEXCOORD7,
  float4 v8 : TEXCOORD3,
  float4 v9 : TEXCOORD4,
  float4 v10 : TEXCOORD5,
  float3 v11 : TEXCOORD6,
  out float4 o0 : SV_TARGET0,
  out float4 o1 : SV_TARGET1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Shadow frustum data is packed into v[4+] slots by the decompiler.
  float4 v[4] = { v0,v1,v2,v3 };
  r0.x = occlusion_roughness_metallic_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, v6.xy, 0).w;
  r0.y = -0.5 + r0.x;
  r0.y = 5 * abs(r0.y);
  r0.y = min(1, r0.y);
  r0.y = -0.63499999 + r0.y;
  r0.y = 2.73972607 * r0.y;
  r0.y = max(0, r0.y);
  r0.z = cmp(0 < r0.y);
  if (r0.z != 0) {
    // --- Parallax occlusion march using ORM alpha channel as the height field.
    r0.z = dot(v7.xyz, v7.xyz);
    r0.z = rsqrt(r0.z);
    r1.xyz = v7.xyz * r0.zzz;
    occlusion_roughness_metallic_texture.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
    r0.z = (uint)r0.z;
    r0.z = 0.200000003 / r0.z;
    r0.x = rsqrt(r0.x);
    r0.x = 1 / r0.x;
    r0.x = 1.03999996 + -r0.x;
    r0.w = 1 + -v6.y;
    r0.w = min(v6.y, r0.w);
    r0.w = saturate(50 * r0.w);
    r1.w = r0.w * -2 + 3;
    r0.w = r0.w * r0.w;
    r0.w = r1.w * r0.w;
    r2.xyz = float3(9.99999975e-06,-0.0149900001,1.99999995e-05) + abs(r1.zzz);
    r1.zw = float2(7.40740728,5) * r2.yx;
    r1.z = saturate(r1.z);
    r2.y = r1.z * -2 + 3;
    r1.z = r1.z * r1.z;
    r1.z = r2.y * r1.z;
    r2.x = 1 + -r2.x;
    r2.y = r2.x * r2.x;
    r2.x = r2.x * r2.y;
    r2.x = r2.x * 1.25 + 1;
    r1.z = r2.x * r1.z;
    r0.w = r1.z * r0.w;
    r0.y = r0.w * r0.y;
    r0.y = parallax_factor * r0.y;
    r0.y = 0.0299999993 * r0.y;
    r0.w = r2.y * 32 + 32;
    r1.z = (int)r0.w;
    r1.xy = -r1.xy / r2.zz;
    r0.w = trunc(r0.w);
    r0.y = r0.y / r0.w;
    r0.w = 1 / r0.w;
    r2.x = 1 + -r0.z;
    r1.w = min(1, r1.w);
    r1.w = r1.w * 0.00150000001 + 0.000500000024;
    r2.yz = v6.xy;
    r3.xy = v6.xy;
    r2.w = 0;
    r3.z = 0;
    r3.w = r0.x;
    r4.x = r0.x;
    r4.y = 0;
    while (true) {
      r4.z = cmp((int)r4.y >= (int)r1.z);
      if (r4.z != 0) break;
      r5.xy = r1.xy * r0.yy + r2.yz;
      r4.z = max(r5.y, r0.z);
      r5.z = min(r4.z, r2.x);
      r4.z = occlusion_roughness_metallic_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, r5.xz, 0).w;
      r4.w = -0.5 + r4.z;
      r4.w = 5 * abs(r4.w);
      r4.w = min(1, r4.w);
      r4.w = cmp(r4.w < 0.300000012);
      if (r4.w != 0) {
        r2.yz = r5.xz;
        break;
      }
      r4.z = rsqrt(r4.z);
      r4.z = 1 / r4.z;
      r4.z = 1 + -r4.z;
      r4.w = r4.z + r1.w;
      r4.w = cmp(r4.w < r2.w);
      if (r4.w != 0) {
        r2.yz = r5.xz;
        r3.w = r4.z;
        break;
      }
      r4.w = r2.w + r0.w;
      r3.xy = r5.xz;
      r3.z = r2.w;
      r4.x = r4.z;
      r2.w = r4.w;
      r3.w = r4.z;
      r4.y = (int)r4.y + 1;
      r2.yz = r5.xz;
    }
    r0.xy = r2.yz;
    r1.xy = r3.xy;
    r5.x = r2.w;
    r5.yz = r3.zw;
    r5.w = r4.x;
    r0.w = 0;
    while (true) {
      r1.z = cmp((int)r0.w >= 4);
      if (r1.z != 0) break;
      r1.zw = r1.xy + r0.xy;
      r6.xy = float2(0.5,0.5) * r1.zw;
      r1.z = max(r6.y, r0.z);
      r6.z = min(r1.z, r2.x);
      r1.z = occlusion_roughness_metallic_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, r6.xz, 0).w;
      r1.z = rsqrt(r1.z);
      r1.z = 1 / r1.z;
      r7.z = 1 + -r1.z;
      r1.z = r5.y + r5.x;
      r7.x = 0.5 * r1.z;
      r1.z = cmp(r7.z < r7.x);
      r0.xy = r1.zz ? r6.xz : r0.xy;
      r1.xy = r1.zz ? r1.xy : r6.xz;
      r7.yw = r5.yw;
      r5.yw = r7.xz;
      r5.xyzw = r1.zzzz ? r7.xyzw : r5.xyzw;
      r0.w = (int)r0.w + 1;
    }
    r0.zw = r5.wx + -r5.yz;
    r0.w = r0.z + r0.w;
    r0.w = 9.99999975e-06 + r0.w;
    r0.z = saturate(r0.z / r0.w);
    r0.xy = -r1.xy + r0.xy;
    r0.xy = r0.zz * r0.xy + r1.xy;
  } else {
    // Skip parallax: reuse mesh UV.
    r0.xy = v6.xy;
  }
  r0.zw = normal_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.xy).xy;
  r1.xyz = occlusion_roughness_metallic_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.xy).xyz; // ORM
  r2.xyz = mask_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.xy).xyz;
  r1.w = dot(r0.zw, r0.zw);
  r1.w = 1 + -r1.w;
  r1.w = max(0, r1.w);
  r1.w = sqrt(r1.w);
  r3.xyz = v5.yzx * v4.zxy;
  r3.xyz = v4.yzx * v5.zxy + -r3.xyz;
  r3.xyz = w1.xww * r3.xyz;
  r3.xyz = r3.xyz * r0.www;
  r3.xyz = r0.zzz * v5.xyz + r3.xyz;
  r3.xyz = r1.www * v4.xyz + r3.xyz;
  r0.z = dot(r3.xyz, r3.xyz);
  r0.z = rsqrt(r0.z);
  r4.xyz = r3.xyz * r0.zzz;
  r5.xyz = cmp(g_retro_enabled == int3(1,1,1));
  r5.xz = (int2)r5.yx | (int2)r5.xz;
  if (r5.x != 0) {
    // Retro override path (not expanded in dump) jitters the base colour.
    r6.xy = ddx_coarse(v6.xy);
    r6.zw = ddy_coarse(v6.xy);
    r6.xy = abs(r6.xy) + abs(r6.zw);
    r0.w = dot(r6.xy, r6.xy);
    r0.w = sqrt(r0.w);
    r0.w = 75 * r0.w;
    r0.w = min(1, r0.w);
    r1.w = 6.5 * time;
    r1.w = floor(r1.w);
    r6.xy = v6.xy * float2(25,25) + r1.ww;
    r6.xy = sin(r6.xy);
    r6.xy = float2(43758.5469,43758.5469) * r6.xy;
    r6.xy = frac(r6.xy);
    r6.xy = float2(-1.5,-1.5) + r6.xy;
    r6.xy = r6.xy * r0.ww;
    r6.xy = r6.xy * float2(0.0299999993,0.0299999993) + v6.xy;
    r7.xyzw = base_color_texture.Sample(mesh_anisotropic_wrap_sampler_s, r6.xy).xyzw;
    r6.xy = float2(0.00449999981,0.00449999981) + r6.xy;
    r6.xyzw = base_color_texture.Sample(mesh_anisotropic_wrap_sampler_s, r6.xy).xyzw;
    r6.xyzw = r6.xyzw + -r7.xyzw;
    r6.xyzw = r6.xyzw * float4(0.230000004,0.230000004,0.230000004,0.230000004) + r7.xyzw;
    r6.xyzw = base_color_factor.xyzw * r6.xyzw;
  } else {
    r6.xyzw = base_color_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.xy).xyzw;
  }
  // --- View vector and N dot V prep for Cook-Torrance lighting.
  // --- View vector and Fresnel setup for main lighting.
  r0.xyw = camera_position.xyz + -v2.xyz;
  r1.w = dot(r0.xyw, r0.xyw);
  r1.w = rsqrt(r1.w);
  r7.xyz = r1.www * r0.xyw;
  r2.w = dot(r4.xyz, r7.xyz);
  r2.w = max(0.00100000005, r2.w);
  r8.x = min(1, r2.w);
  r1.yz = roughness_metallic_emissive_factors.xy * r1.yz;
  r1.y = max(9.99999975e-05, r1.y);
  r8.y = min(2.20000005, r1.y);
  r1.y = r8.y * r8.y;
  r1.y = max(0.0450000018, r1.y);
  // --- Player colour palette remap (primary then secondary, emissive applied at end).
  r9.xyz = cmp(float3(0.5,0.5,0.5) >= r6.xyz);
  r2.w = dot(player_color_primary_srgb.xx, r6.xx);
  r10.xyz = float3(1,1,1) + -r6.xyz;
  r10.xyz = r10.xyz + r10.xyz;
  r11.xyz = float3(1,1,1) + -player_color_primary_srgb.xyz;
  r10.xyz = -r10.xyz * r11.xyz + float3(1,1,1);
  r11.x = r9.x ? r2.w : r10.x;
  r2.w = dot(player_color_primary_srgb.yy, r6.yy);
  r11.y = r9.y ? r2.w : r10.y;
  r2.w = dot(player_color_primary_srgb.zz, r6.zz);
  r11.z = r9.z ? r2.w : r10.z;
  r9.xyz = r11.xyz + -r6.xyz;
  r9.xyz = r2.xxx * r9.xyz + r6.xyz;
  r10.xyz = cmp(float3(0.5,0.5,0.5) >= r9.xyz);
  r2.w = dot(player_color_secondary_srgb.xx, r9.xx);
  r11.xyz = float3(1,1,1) + -r9.xyz;
  r11.xyz = r11.xyz + r11.xyz;
  r12.xyz = float3(1,1,1) + -player_color_secondary_srgb.xyz;
  r11.xyz = -r11.xyz * r12.xyz + float3(1,1,1);
  r12.x = r10.x ? r2.w : r11.x;
  r2.w = dot(player_color_secondary_srgb.yy, r9.yy);
  r12.y = r10.y ? r2.w : r11.y;
  r2.w = dot(player_color_secondary_srgb.zz, r9.zz);
  r12.z = r10.z ? r2.w : r11.z;
  r10.xyz = r12.xyz + -r9.xyz;
  r9.xyz = r2.yyy * r10.xyz + r9.xyz;
  r2.xy = r2.xy * r2.zz;
  r10.xyz = player_color_primary_emissive_srgb.xyz + -r9.xyz;
  r9.xyz = r2.xxx * r10.xyz + r9.xyz;
  r10.xyz = player_color_secondary_emissive_srgb.xyz + -r9.xyz;
  r2.xyw = r2.yyy * r10.xyz + r9.xyz;
  r9.xyz = log2(r2.xyw);
  r9.xyz = float3(1.79999995,1.79999995,1.79999995) * r9.xyz;
  r9.xyz = exp2(r9.xyz);
  r2.z = roughness_metallic_emissive_factors.z * r2.z;
  r10.xyz = float3(-1,-1,-1) + r9.xyz;
  r10.xyz = roughness_metallic_emissive_factors.www * r10.xyz + float3(1,1,1);
  r9.xyz = r9.xyz * r2.zzz;
  r9.xyz = r9.xyz * r10.xyz;
  r10.xyz = cmp(r2.xyw < float3(0.0404499993,0.0404499993,0.0404499993));
  r11.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r2.xyw;
  r12.xyz = r2.xyw * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
  r12.xyz = sqrt(r12.xyz);
  r12.xyz = float3(31.2429695,31.2429695,31.2429695) * r12.xyz;
  r2.xyz = r2.xyw * float3(-7.43604994,-7.43604994,-7.43604994) + -r12.xyz;
  r2.xyz = float3(35.3486404,35.3486404,35.3486404) + r2.xyz;
  r6.xyz = r10.xyz ? r11.xyz : r2.xyz;
  r2.xyzw = base_color_factor.xyzw * r6.xyzw;
  r6.xyz = r6.xyz * base_color_factor.xyz + float3(-0.0399999991,-0.0399999991,-0.0399999991);
  r6.xyz = r1.zzz * r6.xyz + float3(0.0399999991,0.0399999991,0.0399999991);
  r10.xyz = float3(0.318309873,0.318309873,0.318309873) * r2.xyz;
  // --- Clustered-light froxel lookup and cascade index.
  r3.w = log2(v1.z);
  r3.w = r3.w * froxel_z_scale + froxel_z_bias;
  r3.w = max(0, r3.w);
  r3.w = (uint)r3.w;
  r4.w = froxel_size_in_pixels;
  r8.zw = v0.xy / r4.ww;
  r8.zw = (uint2)r8.zw;
  r4.w = mad((int)froxel_counts.x, (int)r8.w, (int)r8.z);
  r5.w = (int)froxel_counts.y * (int)froxel_counts.x;
  r3.w = mad((int)r5.w, (int)r3.w, (int)r4.w);
  r8.z = light_clusters[r3.w].offset;
  r8.w = light_clusters[r3.w].count;
  r3.w = cmp(0 < use_pcf_based_shadows);
  r11.xyz = -camera_position.xyz + v2.xyz;
  r4.w = dot(r11.xyz, r11.xyz);
  r4.w = sqrt(r4.w);
  r4.w = 7500 + -r4.w;
  r4.w = saturate(0.000222222225 * r4.w);
  r5.w = cmp(0 >= r4.w);
  r4.w = r3.w ? r4.w : 0;
  r5.w = r3.w ? r5.w : 0;
  if (r5.w == 0) {
    // Percentage-closer filtering across cascaded shadow map.
    r6.w = ~(int)r3.w;
    r7.w = cmp(0 >= use_pcf_based_shadows);
    r11.yw = float2(1,1);
    r12.xyz = float3(1,1,0);
    r9.w = 0;
    while (true) {
      r10.w = cmp((uint)r12.z >= 4);
      r9.w = 0;
      if (r10.w != 0) break;
      r10.w = (uint)r12.z >> 1;
      r12.w = (int)r12.z & 1;
      r12.w = (uint)r12.w;
      r13.x = 0.5 * r12.w;
      r12.w = r12.w * 0.5 + 0.5;
      r10.w = (uint)r10.w;
      r13.y = 0.5 * r10.w;
      r10.w = r10.w * 0.5 + 0.5;
      r13.xy = cmp(v[r12.z+8].xy >= r13.xy);
      r13.z = cmp(r12.w >= v[r12.z+8].x);
      r13.x = r13.z ? r13.x : 0;
      r13.x = r13.y ? r13.x : 0;
      r13.y = cmp(r10.w >= v[r12.z+8].y);
      r13.x = r13.y ? r13.x : 0;
      if (r13.x != 0) {
        r13.xy = float2(0,-nan);
        while (true) {
          r13.z = cmp(2 < (int)r13.y);
          if (r13.z != 0) break;
          r14.x = (int)r13.y;
          r13.z = r13.x;
          r13.w = -2;
          while (true) {
            r14.z = cmp(2 < (int)r13.w);
            if (r14.z != 0) break;
            r14.y = (int)r13.w;
            r14.zw = shadow_map_texel_size * r14.xy;
            r15.x = dot(r14.xy, float2(0.707106769,0.707106769));
            r15.y = dot(r14.xy, float2(-0.707106769,0.707106769));
            r15.xy = shadow_map_texel_size * r15.xy;
            r14.yz = r7.ww ? r14.zw : r15.xy;
            r14.yz = v[r12.z+8].xy + r14.yz;
            r14.y = shadow_map_texture.SampleLevel(mesh_point_clamp_sampler_s, r14.yz, 0).x;
            r14.y = -shadow_depth_bias + r14.y;
            r14.y = cmp(r14.y < v[r12.z+8].z);
            r14.y = r14.y ? 1.000000 : 0;
            r13.z = r14.y + r13.z;
            r13.w = (int)r13.w + 1;
          }
          r13.x = r13.z;
          r13.y = (int)r13.y + 1;
        }
        r11.z = 0.0399999991 * r13.x;
        r13.y = cmp((uint)r12.z < 3);
        if (r13.y != 0) {
          r12.w = -v[r12.z+8].x + r12.w;
          r10.w = -v[r12.z+8].y + r10.w;
          r10.w = min(r12.w, r10.w);
          r12.w = 0;
          r13.y = -2;
          while (true) {
            r13.w = cmp(2 < (int)r13.y);
            if (r13.w != 0) break;
            r14.x = (int)r13.y;
            r13.w = r12.w;
            r14.z = -2;
            while (true) {
              r14.w = cmp(2 < (int)r14.z);
              if (r14.w != 0) break;
              r14.y = (int)r14.z;
              r15.xy = shadow_map_texel_size * r14.xy;
              r16.x = dot(r14.xy, float2(0.707106769,0.707106769));
              r16.y = dot(r14.xy, float2(-0.707106769,0.707106769));
              r14.yw = shadow_map_texel_size * r16.xy;
              r14.yw = r7.ww ? r15.xy : r14.yw;
              r14.yw = v[r12.z+9].xy + r14.yw;
              r14.y = shadow_map_texture.SampleLevel(mesh_point_clamp_sampler_s, r14.yw, 0).x;
              r14.y = -shadow_depth_bias + r14.y;
              r14.y = cmp(r14.y < v[r12.z+9].z);
              r14.y = r14.y ? 1.000000 : 0;
              r13.w = r14.y + r13.w;
              r14.z = (int)r14.z + 1;
            }
            r12.w = r13.w;
            r13.y = (int)r13.y + 1;
          }
          r10.w = 0.100000024 + -r10.w;
          r10.w = max(0, r10.w);
          r10.w = 10 * r10.w;
          r13.y = r12.w * 0.0399999991 + -r11.z;
          r11.z = r10.w * r13.y + r11.z;
        }
        if (r3.w != 0) {
          r12.xy = r11.wz;
          r9.w = 0;
          break;
        } else {
          r12.xy = r11.zz;
          r9.w = -1;
          break;
        }
        r9.w = r6.w;
      } else {
        r9.w = 0;
      }
      r11.x = (int)r12.z + 1;
      r12.xyz = r11.yyx;
    }
    r6.w = -1 + r12.y;
    r6.w = r4.w * r6.w + 1;
    r6.w = r3.w ? r6.w : 1;
    r6.w = r9.w ? r12.x : r6.w;
  } else {
    r6.w = 1;
  }
  // --- Iterate clustered lights and accumulate per-light BRDF terms.
  r11.xyz = float3(1,1,1) + -r6.xyz;
  r7.w = 1 + r8.y;
  r7.w = r7.w * r7.w;
  r9.w = 0.125 * r7.w;
  r7.w = -r7.w * 0.125 + 1;
  r10.w = r8.x * r7.w + r9.w;
  r10.w = r8.x / r10.w;
  r11.w = r1.y * r1.y;
  r1.y = r1.y * r1.y + -1;
  r12.x = 4 * r8.x;
  r13.z = 0;
  r14.z = 0;
  r12.yzw = float3(0,0,0);
  r13.w = 0;
  while (true) {
    r14.w = cmp((uint)r13.w >= (uint)r8.w);
    if (r14.w != 0) break;
    if (r13.w == 0) {
      r13.w = 1;
      continue;
    }
    r14.w = (int)r8.z + (int)r13.w;
    r14.w = light_indices[r14.w].index;
    r15.x = culled_lights[r14.w].index;
    if (r15.x == 0) {
      r15.x = lights[r14.w].position.x;
      r15.y = lights[r14.w].position.y;
      r15.z = lights[r14.w].position.z;
      r15.w = lights[r14.w].type;
      r15.xyz = -v2.xyz + r15.xyz;
      r16.x = dot(r15.xyz, r15.xyz);
      r16.x = sqrt(r16.x);
      r15.xyz = r15.xyz / r16.xxx;
      r16.yzw = r0.xyw * r1.www + r15.xyz;
      r17.x = dot(r16.yzw, r16.yzw);
      r17.x = rsqrt(r17.x);
      r16.yzw = r17.xxx * r16.yzw;
      r17.x = dot(r4.xyz, r15.xyz);
      r17.x = max(0.00100000005, r17.x);
      r17.x = min(1, r17.x);
      r17.y = saturate(dot(r4.xyz, r16.yzw));
      r16.y = saturate(dot(r15.xyz, r16.yzw));
      if (r15.w == 0) {
        r15.w = lights[r14.w].surface_radius;
        r15.w = r16.x + -r15.w;
        r16.z = lights[r14.w].attenuation_radius;
        r15.w = max(0, r15.w);
        r16.z = r15.w / r16.z;
        r16.z = r16.z * r16.z;
        r16.z = saturate(-r16.z * r16.z + 1);
        r16.z = r16.z * r16.z;
        r15.w = r15.w * r15.w + 1;
        r15.w = r16.z / r15.w;
      } else {
        r16.z = lights[r14.w].type;
        r16.w = cmp((int)r16.z == 2);
        if (r16.w != 0) {
          r18.x = lights[r14.w].direction.x;
          r18.y = lights[r14.w].direction.y;
          r18.z = lights[r14.w].direction.z;
          r15.x = dot(-r15.xyz, r18.xyz);
          r15.y = lights[r14.w].angle;
          r15.y = cos(r15.y);
          r15.x = cmp(r15.x >= r15.y);
          if (r15.x != 0) {
            r15.x = lights[r14.w].surface_radius;
            r15.x = r16.x + -r15.x;
            r15.y = lights[r14.w].attenuation_radius;
            r15.x = max(0, r15.x);
            r15.y = r15.x / r15.y;
            r15.y = r15.y * r15.y;
            r15.y = saturate(-r15.y * r15.y + 1);
            r15.y = r15.y * r15.y;
            r15.x = r15.x * r15.x + 1;
            r15.w = r15.y / r15.x;
          } else {
            r15.w = 0;
          }
        } else {
          r15.x = cmp((int)r16.z == 3);
          if (r15.x != 0) {
            r18.x = lights[r14.w].attenuation_radius;
            r18.y = lights[r14.w].position.x;
            r18.z = lights[r14.w].position.y;
            r18.w = lights[r14.w].position.z;
            r15.x = lights[r14.w].position.x;
            r15.y = lights[r14.w].position.y;
            r15.z = lights[r14.w].position.z;
            r19.x = lights[r14.w].direction.x;
            r19.y = lights[r14.w].direction.y;
            r19.z = lights[r14.w].direction.z;
            r19.w = lights[r14.w].length;
            r15.xyz = r19.xyz * r19.www + r15.xyz;
            r16.xzw = v2.xyz + -r18.yzw;
            r19.xyz = r15.xyz + -r18.yzw;
            r17.z = dot(r19.xyz, r19.xyz);
            r16.x = dot(r16.xzw, r19.xyz);
            r16.z = 0.00100000005 + r17.z;
            r16.x = r16.x / r16.z;
            r16.z = cmp(r16.x < 0);
            r16.w = cmp(1 < r16.x);
            r19.xyz = r19.xyz * r16.xxx + r18.yzw;
            r15.xyz = r16.www ? r15.xyz : r19.xyz;
            r15.xyz = r16.zzz ? r18.yzw : r15.xyz;
            r15.xyz = v2.xyz + -r15.xyz;
            r15.x = dot(r15.xyz, r15.xyz);
            r15.x = sqrt(r15.x);
            r15.y = lights[r14.w].surface_radius;
            r15.x = r15.x + -r15.y;
            r15.x = max(0, r15.x);
            r15.y = r15.x / r18.x;
            r15.y = r15.y * r15.y;
            r15.y = saturate(-r15.y * r15.y + 1);
            r15.y = r15.y * r15.y;
            r15.x = r15.x * r15.x + 1;
            r15.w = r15.y / r15.x;
          } else {
            r15.w = 1;
          }
        }
      }
      r18.x = lights[r14.w].color.x;
      r18.y = lights[r14.w].color.y;
      r18.z = lights[r14.w].color.z;
      r18.w = lights[r14.w].color.w;
      r15.x = cmp((int)r13.w == 1);
      if (r15.x == 0) {
        r15.y = cmp((int)r13.w == 2);
        if (r15.y != 0) {
          r15.y = max(r18.y, r18.z);
          r15.y = max(r18.x, r15.y);
          r15.z = min(r18.y, r18.z);
          r15.z = min(r18.x, r15.z);
          r15.z = r15.y + -r15.z;
          r16.x = cmp(r15.z == 0.000000);
          r19.xyz = r18.yzx + -r18.zxy;
          r19.xyz = r19.xyz / r15.zzz;
          r16.z = 0.166666672 * r19.x;
          r16.z = floor(r16.z);
          r16.z = -r16.z * 6 + r19.x;
          r16.z = 60 * r16.z;
          r17.zw = cmp(r18.xy == r15.yy);
          r19.xy = float2(2,4) + r19.yz;
          r19.xy = float2(60,60) * r19.xy;
          r16.w = r17.w ? r19.x : r19.y;
          r16.z = r17.z ? r16.z : r16.w;
          r16.x = r16.x ? 0 : r16.z;
          r16.z = cmp(r15.y == 0.000000);
          r15.z = r15.z / r15.y;
          r15.z = r16.z ? 0 : r15.z;
          r16.z = 0.333333343 * r15.y;
          r13.x = r16.z * r15.z;
          r16.zw = float2(0.0166666675,0.00833333377) * r16.xx;
          r15.z = floor(r16.w);
          r15.z = -r15.z * 2 + r16.z;
          r15.z = -1 + r15.z;
          r15.z = 1 + -abs(r15.z);
          r13.y = r15.z * r13.x;
          r15.y = r15.y * 0.333333343 + -r13.x;
          r19.xyzw = cmp(r16.xxxx >= float4(0,60,120,180));
          r20.xyzw = cmp(r16.xxxx < float4(60,120,180,240));
          r19.xyzw = r19.xyzw ? r20.xyzw : 0;
          r15.z = cmp(r16.x >= 240);
          r16.x = cmp(r16.x < 300);
          r15.z = r15.z ? r16.x : 0;
          r16.xzw = r15.zzz ? r13.yzx : r13.xzy;
          r16.xzw = r19.www ? r13.zyx : r16.xzw;
          r16.xzw = r19.zzz ? r13.zxy : r16.xzw;
          r16.xzw = r19.yyy ? r13.yxz : r16.xzw;
          r16.xzw = r19.xxx ? r13.xyz : r16.xzw;
          r18.xyz = r16.xzw + r15.yyy;
        } else {
          r13.x = cmp((int)r13.w == 3);
          if (r13.x != 0) {
            r13.x = max(r18.y, r18.z);
            r13.x = max(r18.x, r13.x);
            r13.y = min(r18.y, r18.z);
            r13.y = min(r18.x, r13.y);
            r13.y = r13.x + -r13.y;
            r15.y = cmp(r13.y == 0.000000);
            r16.xzw = r18.yzx + -r18.zxy;
            r16.xzw = r16.xzw / r13.yyy;
            r15.z = 0.166666672 * r16.x;
            r15.z = floor(r15.z);
            r15.z = -r15.z * 6 + r16.x;
            r15.z = 60 * r15.z;
            r17.zw = cmp(r18.xy == r13.xx);
            r16.xz = float2(2,4) + r16.zw;
            r16.xz = float2(60,60) * r16.xz;
            r16.x = r17.w ? r16.x : r16.z;
            r15.z = r17.z ? r15.z : r16.x;
            r15.y = r15.y ? 0 : r15.z;
            r15.z = cmp(r13.x == 0.000000);
            r13.y = r13.y / r13.x;
            r13.y = r15.z ? 0 : r13.y;
            r14.x = r13.x * r13.y;
            r16.xz = float2(0.0166666675,0.00833333377) * r15.yy;
            r15.z = floor(r16.z);
            r15.z = -r15.z * 2 + r16.x;
            r15.z = -1 + r15.z;
            r15.z = 1 + -abs(r15.z);
            r14.y = r15.z * r14.x;
            r13.x = -r13.x * r13.y + r13.x;
            r19.xyzw = cmp(r15.yyyy >= float4(0,60,120,180));
            r20.xyzw = cmp(r15.yyyy < float4(60,120,180,240));
            r19.xyzw = r19.xyzw ? r20.xyzw : 0;
            r13.y = cmp(r15.y >= 240);
            r15.y = cmp(r15.y < 300);
            r13.y = r13.y ? r15.y : 0;
            r16.xzw = r13.yyy ? r14.yzx : r14.xzy;
            r16.xzw = r19.www ? r14.zyx : r16.xzw;
            r16.xzw = r19.zzz ? r14.zxy : r16.xzw;
            r16.xzw = r19.yyy ? r14.yxz : r16.xzw;
            r16.xzw = r19.xxx ? r14.xyz : r16.xzw;
            r18.xyz = r16.xzw + r13.xxx;
          }
        }
      }
      r16.xzw = cmp(r18.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
      r19.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r18.xyz;
      r20.xyz = r18.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
      r20.xyz = sqrt(r20.xyz);
      r20.xyz = float3(31.2429695,31.2429695,31.2429695) * r20.xyz;
      r18.xyz = r18.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r20.xyz;
      r18.xyz = float3(35.3486404,35.3486404,35.3486404) + r18.xyz;
      r16.xzw = r16.xzw ? r19.xyz : r18.xyz;
      r16.xzw = r16.xzw * r18.www;
      r13.x = lights[r14.w].intensity;
      r14.xyw = r16.xzw * r13.xxx;
      r14.xyw = r14.xyw * r15.www;
      r13.x = r15.x ? r6.w : 1;
      r13.y = 1 + -r16.y;
      r15.x = r13.y * r13.y;
      r15.x = r15.x * r15.x;
      r13.y = r15.x * r13.y;
      r15.xyz = r11.xyz * r13.yyy + r6.xyz;
      r13.y = r17.x * r7.w + r9.w;
      r13.y = r17.x / r13.y;
      r13.y = r13.y * r10.w;
      r15.w = r17.y * r17.y;
      r15.w = r15.w * r1.y + 1;
      r15.w = r15.w * r15.w;
      r15.w = 3.14159274 * r15.w;
      r15.w = r11.w / r15.w;
      r16.xyz = float3(1,1,1) + -r15.xyz;
      r16.xyz = r1.zzz * -r16.xyz + r16.xyz;
      r15.xyz = r15.xyz * r13.yyy;
      r15.xyz = r15.xyz * r15.www;
      r13.y = r17.x * r12.x;
      r13.y = max(9.99999975e-05, r13.y);
      r15.xyz = r15.xyz / r13.yyy;
      r15.xyz = r16.xyz * r10.xyz + r15.xyz;
      r14.xyw = r15.xyz * r14.xyw;
      r14.xyw = r14.xyw * r17.xxx;
      r12.yzw = r14.xyw * r13.xxx + r12.yzw;
    }
    r13.w = (int)r13.w + 1;
  }
  r0.x = (int)r5.y | (int)r5.z;
  if (r0.x != 0) {
    r0.x = dot(v4.xyz, v4.xyz);
    r0.x = rsqrt(r0.x);
    r0.xyw = v4.xyz * r0.xxx;
    r3.xyz = r3.xyz * r0.zzz + -r0.xyw;
    r0.xyz = r3.xyz * float3(0.100000001,0.100000001,0.100000001) + r0.xyw;
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r0.xyz = r0.xyz * r0.www;
    if (r5.w == 0) {
      r0.w = ~(int)r3.w;
      r1.y = cmp(0 >= use_pcf_based_shadows);
      r11.yw = float2(1,1);
      r3.xyz = float3(1,1,0);
      r1.w = 0;
      while (true) {
        r5.y = cmp((uint)r3.z >= 4);
        r1.w = 0;
        if (r5.y != 0) break;
        r5.y = (uint)r3.z >> 1;
        r5.w = (int)r3.z & 1;
        r5.yw = (uint2)r5.yw;
        r6.w = 0.5 * r5.w;
        r5.w = r5.w * 0.5 + 0.5;
        r7.w = 0.5 * r5.y;
        r5.y = r5.y * 0.5 + 0.5;
        r6.w = cmp(v[r3.z+8].x >= r6.w);
        r8.z = cmp(r5.w >= v[r3.z+8].x);
        r6.w = r6.w ? r8.z : 0;
        r7.w = cmp(v[r3.z+8].y >= r7.w);
        r6.w = r6.w ? r7.w : 0;
        r7.w = cmp(r5.y >= v[r3.z+8].y);
        r6.w = r6.w ? r7.w : 0;
        if (r6.w != 0) {
          r6.w = 0;
          r7.w = -2;
          while (true) {
            r8.z = cmp(2 < (int)r7.w);
            if (r8.z != 0) break;
            r13.x = (int)r7.w;
            r8.z = r6.w;
            r8.w = -2;
            while (true) {
              r9.w = cmp(2 < (int)r8.w);
              if (r9.w != 0) break;
              r13.y = (int)r8.w;
              r13.zw = shadow_map_texel_size * r13.xy;
              r14.x = dot(r13.xy, float2(0.707106769,0.707106769));
              r14.y = dot(r13.xy, float2(-0.707106769,0.707106769));
              r14.xy = shadow_map_texel_size * r14.xy;
              r13.yz = r1.yy ? r13.zw : r14.xy;
              r13.yz = v[r3.z+8].xy + r13.yz;
              r9.w = shadow_map_texture.SampleLevel(mesh_point_clamp_sampler_s, r13.yz, 0).x;
              r9.w = -shadow_depth_bias + r9.w;
              r9.w = cmp(r9.w < v[r3.z+8].z);
              r9.w = r9.w ? 1.000000 : 0;
              r8.z = r9.w + r8.z;
              r8.w = (int)r8.w + 1;
            }
            r6.w = r8.z;
            r7.w = (int)r7.w + 1;
          }
          r11.z = 0.0399999991 * r6.w;
          r7.w = cmp((uint)r3.z < 3);
          if (r7.w != 0) {
            r5.yw = -v[r3.z+8].yx + r5.yw;
            r5.y = min(r5.w, r5.y);
            r5.w = 0;
            r7.w = -2;
            while (true) {
              r8.w = cmp(2 < (int)r7.w);
              if (r8.w != 0) break;
              r13.x = (int)r7.w;
              r8.w = r5.w;
              r9.w = -2;
              while (true) {
                r10.w = cmp(2 < (int)r9.w);
                if (r10.w != 0) break;
                r13.y = (int)r9.w;
                r13.zw = shadow_map_texel_size * r13.xy;
                r14.x = dot(r13.xy, float2(0.707106769,0.707106769));
                r14.y = dot(r13.xy, float2(-0.707106769,0.707106769));
                r14.xy = shadow_map_texel_size * r14.xy;
                r13.yz = r1.yy ? r13.zw : r14.xy;
                r13.yz = v[r3.z+9].xy + r13.yz;
                r10.w = shadow_map_texture.SampleLevel(mesh_point_clamp_sampler_s, r13.yz, 0).x;
                r10.w = -shadow_depth_bias + r10.w;
                r10.w = cmp(r10.w < v[r3.z+9].z);
                r10.w = r10.w ? 1.000000 : 0;
                r8.w = r10.w + r8.w;
                r9.w = (int)r9.w + 1;
              }
              r5.w = r8.w;
              r7.w = (int)r7.w + 1;
            }
            r5.y = 0.100000024 + -r5.y;
            r5.y = max(0, r5.y);
            r5.y = 10 * r5.y;
            r7.w = r5.w * 0.0399999991 + -r11.z;
            r11.z = r5.y * r7.w + r11.z;
          }
          if (r3.w != 0) {
            r3.xy = r11.wz;
            r1.w = 0;
            break;
          } else {
            r3.xy = r11.zz;
            r1.w = -1;
            break;
          }
          r1.w = r0.w;
        } else {
          r1.w = 0;
        }
        r11.x = (int)r3.z + 1;
        r3.xyz = r11.yyx;
      }
      r0.w = -1 + r3.y;
      r0.w = r4.w * r0.w + 1;
      r0.w = r3.w ? r0.w : 1;
      r0.w = r1.w ? r3.x : r0.w;
    } else {
      r0.w = 1;
    }
    r1.y = r0.w * r0.w;
    r1.y = rsqrt(r1.y);
    r0.w = r1.y * r0.w;
    r0.w = r5.z ? 0.5 : r0.w;
    if (r5.x != 0) {
      r1.y = dot(r0.www, r0.www);
      r1.y = rsqrt(r1.y);
      r1.y = r1.y * r0.w;
      r1.w = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
      r3.xy = float2(-0.0399999991,-0.180000007) + r1.ww;
      r3.xy = saturate(float2(12.5,8.33333302) * r3.xy);
      r3.zw = r3.xy * float2(-2,-2) + float2(3,3);
      r3.xy = r3.xy * r3.xy;
      r1.w = r3.z * r3.x;
      r3.x = -r3.w * r3.y + 1;
      r1.w = r3.x * r1.w;
      r2.xyz = saturate(r2.xyz);
      r3.xyz = r2.xyz * r2.xyz;
      r5.xyz = log2(r2.xyz);
      r5.xyz = float3(1.14999998,1.14999998,1.14999998) * r5.xyz;
      r5.xyz = exp2(r5.xyz);
      r5.xyz = -r2.xyz * r2.xyz + r5.xyz;
      r3.xyz = r1.www * r5.xyz + r3.xyz;
      r1.w = dot(r3.xyz, float3(0.298999995,0.587000012,0.114));
      r1.w = 8 * r1.w;
      r1.w = floor(r1.w);
      r1.w = 0.125 * r1.w;
      r5.xyz = float3(9.99999975e-06,9.99999975e-06,9.99999975e-06) + r3.xyz;
      r3.w = dot(r5.xyz, r5.xyz);
      r3.w = rsqrt(r3.w);
      r5.xyz = r5.xyz * r3.www;
      r5.xyz = saturate(r5.xyz * r1.www);
      r5.xyz = r5.xyz + -r3.xyz;
      r3.xyz = r5.xyz * float3(0.600000024,0.600000024,0.600000024) + r3.xyz;
      r1.y = saturate(dot(r0.xyz, r1.yyy));
      r5.xyzw = float4(-0.125,-0.25,-0.375,-0.5) + r1.yyyy;
      r5.xyzw = saturate(float4(499.998993,499.998993,499.998993,500.006439) * r5.xyzw);
      r11.xyzw = r5.xyzw * float4(-2,-2,-2,-2) + float4(3,3,3,3);
      r5.xyzw = r5.xyzw * r5.xyzw;
      r5.xyzw = r11.xyzw * r5.xyzw;
      r11.xyz = r5.xxx * r3.xyz;
      r11.xyz = float3(0.13000001,0.13000001,0.13000001) * r11.xyz;
      r11.xyz = r3.xyz * float3(0.0199999996,0.0199999996,0.0199999996) + r11.xyz;
      r13.xyz = r3.xyz * float3(0.300000012,0.300000012,0.300000012) + -r11.xyz;
      r11.xyz = r5.yyy * r13.xyz + r11.xyz;
      r13.xyz = r3.xyz * float3(0.5,0.5,0.5) + -r11.xyz;
      r5.xyz = r5.zzz * r13.xyz + r11.xyz;
      r11.xyz = r3.xyz * float3(0.649999976,0.649999976,0.649999976) + -r5.xyz;
      r5.xyz = r5.www * r11.xyz + r5.xyz;
      r11.xyz = float3(-0.625,-0.75,-0.875) + r1.yyy;
      r11.xyz = saturate(float3(500.006439,500.006439,500.006439) * r11.xyz);
      r13.xyz = r11.xyz * float3(-2,-2,-2) + float3(3,3,3);
      r11.xyz = r11.xyz * r11.xyz;
      r11.xyz = r13.xyz * r11.xyz;
      r13.xyz = r3.xyz * float3(0.800000012,0.800000012,0.800000012) + -r5.xyz;
      r5.xyz = r11.xxx * r13.xyz + r5.xyz;
      r13.xyz = r3.xyz * float3(0.949999988,0.949999988,0.949999988) + -r5.xyz;
      r5.xyz = r11.yyy * r13.xyz + r5.xyz;
      r3.xyz = -r5.xyz + r3.xyz;
      r3.xyz = r11.zzz * r3.xyz + r5.xyz;
      r1.y = 1 + -r1.x;
      r5.xyz = r3.xyz * r1.yyy;
      r3.xyz = r5.xyz * float3(-0.899999976,-0.899999976,-0.800000012) + r3.xyz;
      r5.xyz = ddx_coarse(r0.xyz);
      r11.xyz = ddy_coarse(r0.xyz);
      r1.y = dot(r5.xyz, r5.xyz);
      r1.w = dot(r11.xyz, r11.xyz);
      r1.yw = sqrt(r1.yw);
      r1.y = r1.y + r1.w;
      r1.w = -10 + abs(v1.z);
      r1.w = saturate(0.00999999978 * r1.w);
      r1.w = 1 + r1.w;
      r1.y = r1.y * r1.w;
      r1.y = 1.5 * r1.y;
      r1.y = min(1, r1.y);
      r1.y = -0.0900000036 + r1.y;
      r1.y = saturate(3.22580647 * r1.y);
      r1.w = r1.y * -2 + 3;
      r1.y = r1.y * r1.y;
      r1.y = r1.w * r1.y;
      r2.xyz = saturate(r1.yyy * -r3.xyz + r3.xyz);
    } else {
      r1.y = dot(r0.www, r0.www);
      r1.y = rsqrt(r1.y);
      r0.w = r1.y * r0.w;
      r1.y = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
      r1.yw = float2(-0.0399999991,-0.180000007) + r1.yy;
      r1.yw = saturate(float2(12.5,8.33333302) * r1.yw);
      r3.xy = r1.yw * float2(-2,-2) + float2(3,3);
      r1.yw = r1.yw * r1.yw;
      r1.y = r3.x * r1.y;
      r1.w = -r3.y * r1.w + 1;
      r1.y = r1.y * r1.w;
      r2.xyz = saturate(r2.xyz);
      r3.xyz = log2(r2.xyz);
      r5.xyz = float3(1.79999995,1.79999995,1.79999995) * r3.xyz;
      r5.xyz = exp2(r5.xyz);
      r3.xyz = float3(1.20000005,1.20000005,1.20000005) * r3.xyz;
      r3.xyz = exp2(r3.xyz);
      r3.xyz = r3.xyz + -r5.xyz;
      r3.xyz = r1.yyy * r3.xyz + r5.xyz;
      r1.y = dot(r3.xyz, float3(0.298999995,0.587000012,0.114));
      r1.y = 8 * r1.y;
      r1.y = floor(r1.y);
      r1.y = 0.125 * r1.y;
      r5.xyz = float3(9.99999975e-06,9.99999975e-06,9.99999975e-06) + r3.xyz;
      r1.w = dot(r5.xyz, r5.xyz);
      r1.w = rsqrt(r1.w);
      r5.xyz = r5.xyz * r1.www;
      r5.xyz = saturate(r5.xyz * r1.yyy);
      r5.xyz = r5.xyz + -r3.xyz;
      r3.xyz = r5.xyz * float3(0.600000024,0.600000024,0.600000024) + r3.xyz;
      r0.w = saturate(dot(r0.xyz, r0.www));
      r5.xyzw = float4(-0.125,-0.25,-0.375,-0.5) + r0.wwww;
      r5.xyzw = saturate(float4(499.998993,499.998993,499.998993,500.006439) * r5.xyzw);
      r11.xyzw = r5.xyzw * float4(-2,-2,-2,-2) + float4(3,3,3,3);
      r5.xyzw = r5.xyzw * r5.xyzw;
      r5.xyzw = r11.xyzw * r5.xyzw;
      r11.xyz = r5.xxx * r3.xyz;
      r11.xyz = float3(0.13000001,0.13000001,0.13000001) * r11.xyz;
      r11.xyz = r3.xyz * float3(0.0199999996,0.0199999996,0.0199999996) + r11.xyz;
      r13.xyz = r3.xyz * float3(0.300000012,0.300000012,0.300000012) + -r11.xyz;
      r11.xyz = r5.yyy * r13.xyz + r11.xyz;
      r13.xyz = r3.xyz * float3(0.5,0.5,0.5) + -r11.xyz;
      r5.xyz = r5.zzz * r13.xyz + r11.xyz;
      r11.xyz = r3.xyz * float3(0.649999976,0.649999976,0.649999976) + -r5.xyz;
      r5.xyz = r5.www * r11.xyz + r5.xyz;
      r11.xyz = float3(-0.625,-0.75,-0.875) + r0.www;
      r11.xyz = saturate(float3(500.006439,500.006439,500.006439) * r11.xyz);
      r13.xyz = r11.xyz * float3(-2,-2,-2) + float3(3,3,3);
      r11.xyz = r11.xyz * r11.xyz;
      r11.xyz = r13.xyz * r11.xyz;
      r13.xyz = r3.xyz * float3(0.800000012,0.800000012,0.800000012) + -r5.xyz;
      r5.xyz = r11.xxx * r13.xyz + r5.xyz;
      r13.xyz = r3.xyz * float3(0.949999988,0.949999988,0.949999988) + -r5.xyz;
      r5.xyz = r11.yyy * r13.xyz + r5.xyz;
      r3.xyz = -r5.xyz + r3.xyz;
      r3.xyz = r11.zzz * r3.xyz + r5.xyz;
      r0.w = saturate(dot(r0.xyz, r7.xyz));
      r0.w = 1 + -r0.w;
      r0.w = r0.w * r0.w + -0.899999976;
      r0.w = saturate(14.2857037 * r0.w);
      r1.y = r0.w * -2 + 3;
      r0.w = r0.w * r0.w;
      r0.w = r1.y * r0.w;
      r3.xyz = r0.www * -r3.xyz + r3.xyz;
      r5.xyz = ddx_coarse(r0.xyz);
      r0.xyz = ddy_coarse(r0.xyz);
      r0.w = dot(r5.xyz, r5.xyz);
      r0.x = dot(r0.xyz, r0.xyz);
      r0.xw = sqrt(r0.xw);
      r0.x = r0.w + r0.x;
      r0.x = -0.0399999991 + r0.x;
      r0.x = saturate(3.8461535 * r0.x);
      r0.y = r0.x * -2 + 3;
      r0.x = r0.x * r0.x;
      r0.x = r0.y * r0.x;
      r0.x = log2(r0.x);
      r0.x = 0.300000012 * r0.x;
      r0.x = exp2(r0.x);
      r0.x = min(1, r0.x);
      r2.xyz = saturate(r0.xxx * -r3.xyz + r3.xyz);
    }
  } else {
    // --- Environment-only fallback (IBL via irradiance + split-sum specular).
    r0.xy = float2(1,1) + -r8.yx;
    r0.xzw = max(r0.xxx, r6.xyz);
    r0.xzw = r0.xzw + -r6.xyz;
    r1.y = r0.y * r0.y;
    r1.y = r1.y * r1.y;
    r0.y = r1.y * r0.y;
    r0.xyz = r0.xzw * r0.yyy + r6.xyz;
    r3.xyz = float3(1,1,1) + -r0.xyz;
    r1.yzw = r1.zzz * -r3.xyz + r3.xyz;
    r1.yzw = r1.yzw * r10.xyz;
    r3.xyz = irradiance_texture.Sample(mesh_anisotropic_wrap_sampler_s, r4.xyz).xyz;
    r5.xyz = cmp(r3.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
    r6.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r3.xyz;
    r10.xyz = r3.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
    r10.xyz = sqrt(r10.xyz);
    r10.xyz = float3(31.2429695,31.2429695,31.2429695) * r10.xyz;
    r3.xyz = r3.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r10.xyz;
    r3.xyz = float3(35.3486404,35.3486404,35.3486404) + r3.xyz;
    r3.xyz = r5.xyz ? r6.xyz : r3.xyz;
    r0.w = dot(-r7.xyz, r4.xyz);
    r0.w = r0.w + r0.w;
    r4.xyz = r4.xyz * -r0.www + -r7.xyz;
    r0.w = dot(r4.xyz, r4.xyz);
    r0.w = rsqrt(r0.w);
    r4.xyz = r4.xyz * r0.www;
    r0.w = 3 * r8.y;
    r4.xyz = radiance_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, r4.xyz, r0.w).xyz;
    r5.xyz = cmp(r4.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
    r6.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r4.xyz;
    r7.xyz = r4.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
    r7.xyz = sqrt(r7.xyz);
    r7.xyz = float3(31.2429695,31.2429695,31.2429695) * r7.xyz;
    r4.xyz = r4.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r7.xyz;
    r4.xyz = float3(35.3486404,35.3486404,35.3486404) + r4.xyz;
    r4.xyz = r5.xyz ? r6.xyz : r4.xyz;
    r5.xy = dfg_texture.SampleLevel(mesh_linear_clamp_sampler_s, r8.xy, 0).xy;
    r0.xyz = r0.xyz * r5.xxx + r5.yyy;
    r0.xyz = r0.xyz * r4.xyz;
    r0.xyz = r1.yzw * r3.xyz + r0.xyz;
    r0.xyz = r12.yzw + r0.xyz;
    r2.xyz = r0.xyz * r1.xxx + r9.xyz;
  }
  o0.xyzw = r2.xyzw;
  o1.w = r2.w;
  o1.xyz = r9.xyz;
  return;
}