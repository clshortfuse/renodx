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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 v[4] = { v0,v1,v2,v3 };
  r0.xy = mask_texture.Sample(mesh_anisotropic_wrap_sampler_s, v6.xy).xy;
  r0.zw = cmp(float2(0.00999999978,0.00999999978) < r0.xy);
  r0.z = (int)r0.w | (int)r0.z;
  r1.xy = cmp(r0.xy < float2(0.99000001,0.99000001));
  r0.w = (int)r1.y | (int)r1.x;
  r0.z = r0.w ? r0.z : 0;
  if (r0.z != 0) {
    r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
    r0.w = dot(r0.xy, r0.xy);
    r0.w = rsqrt(r0.w);
    r1.xy = r0.xy * r0.ww;
    r1.zw = r1.xy * float2(0.0009765625,0.0009765625) + v6.xy;
    r1.zw = mask_texture.Sample(mesh_anisotropic_wrap_sampler_s, r1.zw).xy;
    r1.zw = r1.zw * float2(2,2) + float2(-1,-1);
    r1.xy = -r1.xy * float2(0.0009765625,0.0009765625) + v6.xy;
    r1.xy = mask_texture.Sample(mesh_anisotropic_wrap_sampler_s, r1.xy).xy;
    r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
    r0.xy = float2(0.5,0.5) * r0.xy;
    r0.xy = r1.zw * float2(0.25,0.25) + r0.xy;
    r0.xy = r1.xy * float2(0.25,0.25) + r0.xy;
    r0.w = dot(r0.xy, r0.xy);
    r1.x = sqrt(r0.w);
    r1.x = min(1, r1.x);
    r1.x = log2(r1.x);
    r1.x = 0.850000024 * r1.x;
    r1.x = exp2(r1.x);
    r0.w = rsqrt(r0.w);
    r0.xy = r0.xy * r0.ww;
    r0.xy = r0.xy * r1.xx;
    r0.w = dot(v6.xy, float2(12.9898005,78.2330017));
    r0.w = sin(r0.w);
    r0.w = r0.w * 43758.5469 + time;
    r0.w = frac(r0.w);
    r0.w = 9.99999975e-05 * r0.w;
    r0.xy = r0.xy * float2(0.200000003,0.200000003) + r0.ww;
    r0.w = 0.0799999982 * time;
    r0.w = frac(r0.w);
    r1.x = time * 0.0799999982 + 0.5;
    r1.x = frac(r1.x);
    r1.y = -0.5 + r0.w;
    r1.z = abs(r1.y) + abs(r1.y);
    r1.y = -abs(r1.y) * 2 + 1;
    r2.xy = r0.xy * r0.ww + v6.xy;
    r0.xy = r0.xy * r1.xx + v6.xy;
    r0.w = dot(v7.xyz, v7.xyz);
    r0.w = rsqrt(r0.w);
    r3.xyz = v7.xyz * r0.www;
    r0.w = 9.99999975e-06 + abs(r3.z);
    r1.x = occlusion_roughness_metallic_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, r2.xy, 0).w;
    r1.w = -0.5 + r1.x;
    r1.w = 5 * abs(r1.w);
    r1.w = min(1, r1.w);
    r1.w = -0.63499999 + r1.w;
    r1.w = 2.73972607 * r1.w;
    r1.w = max(0, r1.w);
    r2.z = cmp(0 < r1.w);
    if (r2.z != 0) {
      occlusion_roughness_metallic_texture.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
      r2.z = uiDest.y;
      r2.z = (uint)r2.z;
      r2.z = 0.200000003 / r2.z;
      r1.x = rsqrt(r1.x);
      r1.x = 1 / r1.x;
      r1.x = 1.03999996 + -r1.x;
      r2.w = 1 + -r2.y;
      r2.w = min(r2.y, r2.w);
      r2.w = saturate(50 * r2.w);
      r3.w = r2.w * -2 + 3;
      r2.w = r2.w * r2.w;
      r2.w = r3.w * r2.w;
      r4.xy = float2(-0.0149900001,1.99999995e-05) + abs(r3.zz);
      r3.w = saturate(7.40740728 * r4.x);
      r4.x = r3.w * -2 + 3;
      r3.w = r3.w * r3.w;
      r3.w = r4.x * r3.w;
      r4.x = 1 + -r0.w;
      r4.z = r4.x * r4.x;
      r4.x = r4.x * r4.z;
      r4.x = r4.x * 1.25 + 1;
      r3.w = r4.x * r3.w;
      r2.w = r3.w * r2.w;
      r1.w = r2.w * r1.w;
      r1.w = parallax_factor * r1.w;
      r1.w = 0.0299999993 * r1.w;
      r2.w = r4.z * 32 + 32;
      r3.w = (int)r2.w;
      r4.xy = -r3.xy / r4.yy;
      r2.w = trunc(r2.w);
      r1.w = r1.w / r2.w;
      r2.w = 1 / r2.w;
      r4.z = 1 + -r2.z;
      r4.w = 5 * r0.w;
      r4.w = min(1, r4.w);
      r4.w = r4.w * 0.00150000001 + 0.000500000024;
      r5.xyzw = r2.xyxy;
      r6.xy = float2(0,0);
      r6.zw = r1.xx;
      r7.x = 0;
      while (true) {
        r7.y = cmp((int)r7.x >= (int)r3.w);
        if (r7.y != 0) break;
        r8.xy = r4.xy * r1.ww + r5.xy;
        r7.y = max(r8.y, r2.z);
        r8.z = min(r7.y, r4.z);
        r7.y = occlusion_roughness_metallic_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, r8.xz, 0).w;
        r7.z = -0.5 + r7.y;
        r7.z = 5 * abs(r7.z);
        r7.z = min(1, r7.z);
        r7.z = cmp(r7.z < 0.300000012);
        if (r7.z != 0) {
          r5.xy = r8.xz;
          break;
        }
        r7.y = rsqrt(r7.y);
        r7.y = 1 / r7.y;
        r7.y = 1 + -r7.y;
        r7.z = r7.y + r4.w;
        r7.z = cmp(r7.z < r6.x);
        if (r7.z != 0) {
          r5.xy = r8.xz;
          r6.z = r7.y;
          break;
        }
        r7.z = r6.x + r2.w;
        r5.zw = r8.xz;
        r6.y = r6.x;
        r6.w = r7.y;
        r6.x = r7.z;
        r6.z = r7.y;
        r7.x = (int)r7.x + 1;
        r5.xy = r8.xz;
      }
      r1.xw = r5.xy;
      r4.xy = r5.zw;
      r7.xyzw = r6.xyzw;
      r2.w = 0;
      while (true) {
        r3.w = cmp((int)r2.w >= 4);
        if (r3.w != 0) break;
        r8.xy = r4.xy + r1.xw;
        r8.xy = float2(0.5,0.5) * r8.xy;
        r3.w = max(r8.y, r2.z);
        r8.z = min(r3.w, r4.z);
        r3.w = occlusion_roughness_metallic_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, r8.xz, 0).w;
        r3.w = rsqrt(r3.w);
        r3.w = 1 / r3.w;
        r9.z = 1 + -r3.w;
        r3.w = r7.y + r7.x;
        r9.x = 0.5 * r3.w;
        r3.w = cmp(r9.z < r9.x);
        r1.xw = r3.ww ? r8.xz : r1.xw;
        r4.xy = r3.ww ? r4.xy : r8.xz;
        r9.yw = r7.yw;
        r7.yw = r9.xz;
        r7.xyzw = r3.wwww ? r9.xyzw : r7.xyzw;
        r2.w = (int)r2.w + 1;
      }
      r2.zw = r7.wx + -r7.yz;
      r2.w = r2.z + r2.w;
      r2.w = 9.99999975e-06 + r2.w;
      r2.z = saturate(r2.z / r2.w);
      r1.xw = -r4.xy + r1.xw;
      r2.xy = r2.zz * r1.xw + r4.xy;
    }
    r1.x = occlusion_roughness_metallic_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, r0.xy, 0).w;
    r1.w = -0.5 + r1.x;
    r1.w = 5 * abs(r1.w);
    r1.w = min(1, r1.w);
    r1.w = -0.63499999 + r1.w;
    r1.w = 2.73972607 * r1.w;
    r1.w = max(0, r1.w);
    r2.z = cmp(0 < r1.w);
    if (r2.z != 0) {
      occlusion_roughness_metallic_texture.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
      r2.z = uiDest.y;
      r2.z = (uint)r2.z;
      r2.z = 0.200000003 / r2.z;
      r1.x = rsqrt(r1.x);
      r1.x = 1 / r1.x;
      r1.x = 1.03999996 + -r1.x;
      r2.w = 1 + -r0.y;
      r2.w = min(r2.w, r0.y);
      r2.w = saturate(50 * r2.w);
      r3.w = r2.w * -2 + 3;
      r2.w = r2.w * r2.w;
      r2.w = r3.w * r2.w;
      r3.zw = float2(-0.0149900001,1.99999995e-05) + abs(r3.zz);
      r3.z = saturate(7.40740728 * r3.z);
      r4.x = r3.z * -2 + 3;
      r3.z = r3.z * r3.z;
      r3.z = r4.x * r3.z;
      r4.x = 1 + -r0.w;
      r4.y = r4.x * r4.x;
      r4.x = r4.x * r4.y;
      r4.x = r4.x * 1.25 + 1;
      r3.z = r4.x * r3.z;
      r2.w = r3.z * r2.w;
      r1.w = r2.w * r1.w;
      r1.w = parallax_factor * r1.w;
      r1.w = 0.0299999993 * r1.w;
      r2.w = r4.y * 32 + 32;
      r3.z = (int)r2.w;
      r3.xy = -r3.xy / r3.ww;
      r2.w = trunc(r2.w);
      r1.w = r1.w / r2.w;
      r2.w = 1 / r2.w;
      r3.w = 1 + -r2.z;
      r0.w = 5 * r0.w;
      r0.w = min(1, r0.w);
      r0.w = r0.w * 0.00150000001 + 0.000500000024;
      r4.xyzw = r0.xyxy;
      r5.xy = float2(0,0);
      r5.zw = r1.xx;
      r6.x = 0;
      while (true) {
        r6.y = cmp((int)r6.x >= (int)r3.z);
        if (r6.y != 0) break;
        r7.xy = r3.xy * r1.ww + r4.xy;
        r6.y = max(r7.y, r2.z);
        r7.z = min(r6.y, r3.w);
        r6.y = occlusion_roughness_metallic_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, r7.xz, 0).w;
        r6.z = -0.5 + r6.y;
        r6.z = 5 * abs(r6.z);
        r6.z = min(1, r6.z);
        r6.z = cmp(r6.z < 0.300000012);
        if (r6.z != 0) {
          r4.xy = r7.xz;
          break;
        }
        r6.y = rsqrt(r6.y);
        r6.y = 1 / r6.y;
        r6.y = 1 + -r6.y;
        r6.z = r6.y + r0.w;
        r6.z = cmp(r6.z < r5.x);
        if (r6.z != 0) {
          r4.xy = r7.xz;
          r5.z = r6.y;
          break;
        }
        r6.z = r5.x + r2.w;
        r4.zw = r7.xz;
        r5.y = r5.x;
        r5.w = r6.y;
        r5.x = r6.z;
        r5.z = r6.y;
        r6.x = (int)r6.x + 1;
        r4.xy = r7.xz;
      }
      r1.xw = r4.xy;
      r3.xy = r4.zw;
      r6.xyzw = r5.xyzw;
      r0.w = 0;
      while (true) {
        r2.w = cmp((int)r0.w >= 4);
        if (r2.w != 0) break;
        r7.xy = r3.xy + r1.xw;
        r7.xy = float2(0.5,0.5) * r7.xy;
        r2.w = max(r7.y, r2.z);
        r7.z = min(r2.w, r3.w);
        r2.w = occlusion_roughness_metallic_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, r7.xz, 0).w;
        r2.w = rsqrt(r2.w);
        r2.w = 1 / r2.w;
        r8.z = 1 + -r2.w;
        r2.w = r6.y + r6.x;
        r8.x = 0.5 * r2.w;
        r2.w = cmp(r8.z < r8.x);
        r1.xw = r2.ww ? r7.xz : r1.xw;
        r3.xy = r2.ww ? r3.xy : r7.xz;
        r8.yw = r6.yw;
        r6.yw = r8.xz;
        r6.xyzw = r2.wwww ? r8.xyzw : r6.xyzw;
        r0.w = (int)r0.w + 1;
      }
      r0.w = r6.w + -r6.y;
      r2.z = r6.x + -r6.z;
      r2.z = r2.z + r0.w;
      r2.z = 9.99999975e-06 + r2.z;
      r0.w = saturate(r0.w / r2.z);
      r1.xw = -r3.xy + r1.xw;
      r0.xy = r0.ww * r1.xw + r3.xy;
    }
    r1.xw = r0.xy * r1.zz;
    r1.xw = r2.xy * r1.yy + r1.xw;
    r1.xw = float2(0.999989986,0.999989986) * r1.xw;
    r3.xyzw = base_color_texture.Sample(mesh_anisotropic_wrap_sampler_s, r2.xy).xyzw;
    r4.xyzw = base_color_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.xy).xyzw;
    r4.xyzw = r4.xyzw * r1.zzzz;
    r3.xyzw = r3.xyzw * r1.yyyy + r4.xyzw;
    r2.zw = normal_texture.Sample(mesh_anisotropic_wrap_sampler_s, r2.xy).xy;
    r4.xy = normal_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.xy).xy;
    r4.xy = r4.xy * r1.zz;
    r2.zw = r2.zw * r1.yy + r4.xy;
    r2.zw = float2(0.999989986,0.999989986) * r2.zw;
    r4.xyz = occlusion_roughness_metallic_texture.Sample(mesh_anisotropic_wrap_sampler_s, r2.xy).xyz;
    r5.xyz = occlusion_roughness_metallic_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.xy).xyz;
    r5.xyz = r5.xyz * r1.zzz;
    r4.xyz = r4.xyz * r1.yyy + r5.xyz;
    r4.xyz = float3(0.999989986,0.999989986,0.999989986) * r4.yzx;
    r3.xyzw = float4(0.999989986,0.999989986,0.999989986,0.999989986) * r3.xyzw;
    r0.w = mask_texture.Sample(mesh_anisotropic_wrap_sampler_s, r2.xy).z;
    r0.x = mask_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.xy).z;
    r0.x = r0.x * r1.z;
    r0.x = r0.w * r1.y + r0.x;
    r0.x = 0.999989986 * r0.x;
  } else {
    r0.x = 0;
    r0.y = occlusion_roughness_metallic_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, v6.xy, 0).w;
    r0.w = -0.5 + r0.y;
    r0.w = 5 * abs(r0.w);
    r0.w = min(1, r0.w);
    r0.w = -0.63499999 + r0.w;
    r0.w = 2.73972607 * r0.w;
    r0.w = max(0, r0.w);
    r1.y = cmp(0 < r0.w);
    if (r1.y != 0) {
      r1.y = dot(v7.xyz, v7.xyz);
      r1.y = rsqrt(r1.y);
      r5.xyz = v7.xyz * r1.yyy;
      occlusion_roughness_metallic_texture.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
      r1.y = uiDest.y;
      r1.y = (uint)r1.y;
      r1.y = 0.200000003 / r1.y;
      r0.y = rsqrt(r0.y);
      r0.y = 1 / r0.y;
      r0.y = 1.03999996 + -r0.y;
      r1.z = 1 + -v6.y;
      r1.z = min(v6.y, r1.z);
      r1.z = saturate(50 * r1.z);
      r2.x = r1.z * -2 + 3;
      r1.z = r1.z * r1.z;
      r1.z = r2.x * r1.z;
      r6.xyz = float3(9.99999975e-06,-0.0149900001,1.99999995e-05) + abs(r5.zzz);
      r2.xy = float2(7.40740728,5) * r6.yx;
      r2.x = saturate(r2.x);
      r4.w = r2.x * -2 + 3;
      r2.x = r2.x * r2.x;
      r2.x = r4.w * r2.x;
      r4.w = 1 + -r6.x;
      r5.z = r4.w * r4.w;
      r4.w = r5.z * r4.w;
      r4.w = r4.w * 1.25 + 1;
      r2.x = r4.w * r2.x;
      r1.z = r2.x * r1.z;
      r0.w = r1.z * r0.w;
      r0.w = parallax_factor * r0.w;
      r0.w = 0.0299999993 * r0.w;
      r1.z = r5.z * 32 + 32;
      r2.x = (int)r1.z;
      r5.xy = -r5.xy / r6.zz;
      r1.z = trunc(r1.z);
      r0.w = r0.w / r1.z;
      r1.z = 1 / r1.z;
      r4.w = 1 + -r1.y;
      r2.y = min(1, r2.y);
      r2.y = r2.y * 0.00150000001 + 0.000500000024;
      r5.zw = v6.xy;
      r6.xy = v6.xy;
      r6.zw = float2(0,0);
      r7.xy = r0.yy;
      r7.z = 0;
      while (true) {
        r7.w = cmp((int)r7.z >= (int)r2.x);
        if (r7.w != 0) break;
        r8.xy = r5.xy * r0.ww + r5.zw;
        r7.w = max(r8.y, r1.y);
        r8.z = min(r7.w, r4.w);
        r7.w = occlusion_roughness_metallic_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, r8.xz, 0).w;
        r8.y = -0.5 + r7.w;
        r8.y = 5 * abs(r8.y);
        r8.y = min(1, r8.y);
        r8.y = cmp(r8.y < 0.300000012);
        if (r8.y != 0) {
          r5.zw = r8.xz;
          break;
        }
        r7.w = rsqrt(r7.w);
        r7.w = 1 / r7.w;
        r7.w = 1 + -r7.w;
        r8.y = r7.w + r2.y;
        r8.y = cmp(r8.y < r6.z);
        if (r8.y != 0) {
          r5.zw = r8.xz;
          r7.x = r7.w;
          break;
        }
        r8.y = r6.z + r1.z;
        r6.xy = r8.xz;
        r6.w = r6.z;
        r7.y = r7.w;
        r6.z = r8.y;
        r7.xy = r7.wy;
        r7.z = (int)r7.z + 1;
        r5.zw = r8.xz;
      }
      r0.yw = r5.zw;
      r2.xy = r6.xy;
      r8.xy = r6.zw;
      r8.zw = r7.xy;
      r1.z = 0;
      while (true) {
        r5.x = cmp((int)r1.z >= 4);
        if (r5.x != 0) break;
        r5.xy = r2.xy + r0.yw;
        r9.xy = float2(0.5,0.5) * r5.xy;
        r5.x = max(r9.y, r1.y);
        r9.z = min(r5.x, r4.w);
        r5.x = occlusion_roughness_metallic_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, r9.xz, 0).w;
        r5.x = rsqrt(r5.x);
        r5.x = 1 / r5.x;
        r10.z = 1 + -r5.x;
        r5.x = r8.y + r8.x;
        r10.x = 0.5 * r5.x;
        r5.x = cmp(r10.z < r10.x);
        r0.yw = r5.xx ? r9.xz : r0.yw;
        r2.xy = r5.xx ? r2.xy : r9.xz;
        r10.yw = r8.yw;
        r8.yw = r10.xz;
        r8.xyzw = r5.xxxx ? r10.xyzw : r8.xyzw;
        r1.z = (int)r1.z + 1;
      }
      r1.yz = r8.wx + -r8.yz;
      r1.z = r1.y + r1.z;
      r1.z = 9.99999975e-06 + r1.z;
      r1.y = saturate(r1.y / r1.z);
      r0.yw = -r2.xy + r0.yw;
      r1.xw = r1.yy * r0.yw + r2.xy;
    } else {
      r1.xw = v6.xy;
    }
    r3.xyzw = base_color_texture.Sample(mesh_anisotropic_wrap_sampler_s, r1.xw).xyzw;
    r2.zw = normal_texture.Sample(mesh_anisotropic_wrap_sampler_s, r1.xw).xy;
    r4.xyz = occlusion_roughness_metallic_texture.Sample(mesh_anisotropic_wrap_sampler_s, r1.xw).yzx;
  }
  r0.y = mask_texture.Sample(mesh_anisotropic_wrap_sampler_s, r1.xw).z;
  r0.x = r0.z ? r0.x : r0.y;
  r0.y = dot(r2.zw, r2.zw);
  r0.y = 1 + -r0.y;
  r0.y = max(0, r0.y);
  r0.y = sqrt(r0.y);
  r1.xyz = v5.yzx * v4.zxy;
  r1.xyz = v4.yzx * v5.zxy + -r1.xyz;
  r1.xyz = w1.xww * r1.xyz;
  r1.xyz = r2.www * r1.xyz;
  r1.xyz = r2.zzz * v5.xyz + r1.xyz;
  r0.yzw = r0.yyy * v4.xyz + r1.xyz;
  r1.x = dot(r0.yzw, r0.yzw);
  r1.x = rsqrt(r1.x);
  r1.yzw = r1.xxx * r0.yzw;
  r2.xyz = cmp(g_retro_enabled == int3(1,1,1));
  r2.xz = (int2)r2.yx | (int2)r2.xz;
  if (r2.x != 0) {
    r5.xy = ddx_coarse(v6.xy);
    r5.zw = ddy_coarse(v6.xy);
    r5.xy = abs(r5.xy) + abs(r5.zw);
    r2.w = dot(r5.xy, r5.xy);
    r2.w = sqrt(r2.w);
    r2.w = 75 * r2.w;
    r2.w = min(1, r2.w);
    r4.w = 6.5 * time;
    r4.w = floor(r4.w);
    r5.xy = v6.xy * float2(25,25) + r4.ww;
    r5.xy = sin(r5.xy);
    r5.xy = float2(43758.5469,43758.5469) * r5.xy;
    r5.xy = frac(r5.xy);
    r5.xy = float2(-1.5,-1.5) + r5.xy;
    r5.xy = r5.xy * r2.ww;
    r5.xy = r5.xy * float2(0.0299999993,0.0299999993) + v6.xy;
    r6.xyzw = base_color_texture.Sample(mesh_anisotropic_wrap_sampler_s, r5.xy).xyzw;
    r5.xy = float2(0.00449999981,0.00449999981) + r5.xy;
    r5.xyzw = base_color_texture.Sample(mesh_anisotropic_wrap_sampler_s, r5.xy).xyzw;
    r5.xyzw = r5.xyzw + -r6.xyzw;
    r5.xyzw = r5.xyzw * float4(0.230000004,0.230000004,0.230000004,0.230000004) + r6.xyzw;
    r3.xyzw = base_color_factor.xyzw * r5.xyzw;
  }
  r5.xyz = camera_position.xyz + -v2.xyz;
  r2.w = dot(r5.xyz, r5.xyz);
  r2.w = rsqrt(r2.w);
  r6.xyz = r5.xyz * r2.www;
  r4.w = dot(r1.yzw, r6.xyz);
  r4.w = max(0.00100000005, r4.w);
  r4.xy = roughness_metallic_emissive_factors.xy * r4.xy;
  r4.x = max(9.99999975e-05, r4.x);
  r7.xy = min(float2(1,2.20000005), r4.wx);
  r4.x = r7.y * r7.y;
  r4.x = max(0.0450000018, r4.x);
  r8.xyz = log2(r3.xyz);
  r8.xyz = float3(1.79999995,1.79999995,1.79999995) * r8.xyz;
  r8.xyz = exp2(r8.xyz);
  r0.x = roughness_metallic_emissive_factors.z * r0.x;
  r9.xyz = float3(-1,-1,-1) + r8.xyz;
  r9.xyz = roughness_metallic_emissive_factors.www * r9.xyz + float3(1,1,1);
  r8.xyz = r8.xyz * r0.xxx;
  r8.xyz = r8.xyz * r9.xyz;
  r9.xyz = cmp(r3.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
  r10.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r3.xyz;
  r11.xyz = r3.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
  r11.xyz = sqrt(r11.xyz);
  r11.xyz = float3(31.2429695,31.2429695,31.2429695) * r11.xyz;
  r11.xyz = r3.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r11.xyz;
  r11.xyz = float3(35.3486404,35.3486404,35.3486404) + r11.xyz;
  r3.xyz = r9.xyz ? r10.xyz : r11.xyz;
  r9.xyzw = base_color_factor.xyzw * r3.xyzw;
  r3.xyz = r3.xyz * base_color_factor.xyz + float3(-0.0399999991,-0.0399999991,-0.0399999991);
  r3.xyz = r4.yyy * r3.xyz + float3(0.0399999991,0.0399999991,0.0399999991);
  r10.xyz = float3(0.318309873,0.318309873,0.318309873) * r9.xyz;
  r0.x = log2(v1.z);
  r0.x = r0.x * froxel_z_scale + froxel_z_bias;
  r0.x = max(0, r0.x);
  r0.x = (uint)r0.x;
  r3.w = froxel_size_in_pixels;
  r7.zw = v0.xy / r3.ww;
  r7.zw = (uint2)r7.zw;
  r3.w = mad((int)froxel_counts.x, (int)r7.w, (int)r7.z);
  r4.w = (int)froxel_counts.y * (int)froxel_counts.x;
  r0.x = mad((int)r4.w, (int)r0.x, (int)r3.w);
  r7.z = light_clusters[r0.x].offset;
  r7.w = light_clusters[r0.x].count;
  r0.x = cmp(0 < use_pcf_based_shadows);
  r11.xyz = -camera_position.xyz + v2.xyz;
  r3.w = dot(r11.xyz, r11.xyz);
  r3.w = sqrt(r3.w);
  r3.w = 7500 + -r3.w;
  r3.w = saturate(0.000222222225 * r3.w);
  r4.w = cmp(0 >= r3.w);
  r3.w = r0.x ? r3.w : 0;
  r4.w = r0.x ? r4.w : 0;
  if (r4.w == 0) {
    r5.w = ~(int)r0.x;
    r6.w = cmp(0 >= use_pcf_based_shadows);
    r11.yw = float2(1,1);
    r12.xyz = float3(1,1,0);
    r8.w = 0;
    while (true) {
      r10.w = cmp((uint)r12.z >= 4);
      r8.w = 0;
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
            r14.yz = r6.ww ? r14.zw : r15.xy;
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
              r14.yw = r6.ww ? r15.xy : r14.yw;
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
        if (r0.x != 0) {
          r12.xy = r11.wz;
          r8.w = 0;
          break;
        } else {
          r12.xy = r11.zz;
          r8.w = -1;
          break;
        }
        r8.w = r5.w;
      } else {
        r8.w = 0;
      }
      r11.x = (int)r12.z + 1;
      r12.xyz = r11.yyx;
    }
    r5.w = -1 + r12.y;
    r5.w = r3.w * r5.w + 1;
    r5.w = r0.x ? r5.w : 1;
    r5.w = r8.w ? r12.x : r5.w;
  } else {
    r5.w = 1;
  }
  r11.xyz = float3(1,1,1) + -r3.xyz;
  r6.w = 1 + r7.y;
  r6.w = r6.w * r6.w;
  r8.w = 0.125 * r6.w;
  r6.w = -r6.w * 0.125 + 1;
  r10.w = r7.x * r6.w + r8.w;
  r10.w = r7.x / r10.w;
  r11.w = r4.x * r4.x;
  r4.x = r4.x * r4.x + -1;
  r12.x = 4 * r7.x;
  r12.yzw = float3(0,0,0);
  r13.x = 0;
  while (true) {
    r13.y = cmp((uint)r13.x >= (uint)r7.w);
    if (r13.y != 0) break;
    r13.yzw = cmp((int3)r13.xxx == int3(1,2,3));
    r13.y = (int)r13.z | (int)r13.y;
    r13.y = (int)r13.w | (int)r13.y;
    if (r13.y != 0) {
      r13.y = (int)r13.x + 1;
      r13.x = r13.y;
      continue;
    }
    r13.y = (int)r7.z + (int)r13.x;
    r13.y = light_indices[r13.y].index;
    r13.z = culled_lights[r13.y].index;
    if (r13.z == 0) {
      r14.x = lights[r13.y].position.x;
      r14.y = lights[r13.y].position.y;
      r14.z = lights[r13.y].position.z;
      r14.w = lights[r13.y].type;
      r14.xyz = -v2.xyz + r14.xyz;
      r13.z = dot(r14.xyz, r14.xyz);
      r13.z = sqrt(r13.z);
      r14.xyz = r14.xyz / r13.zzz;
      r15.xyz = r5.xyz * r2.www + r14.xyz;
      r13.w = dot(r15.xyz, r15.xyz);
      r13.w = rsqrt(r13.w);
      r15.xyz = r15.xyz * r13.www;
      r13.w = dot(r1.yzw, r14.xyz);
      r13.w = max(0.00100000005, r13.w);
      r13.w = min(1, r13.w);
      r15.w = saturate(dot(r1.yzw, r15.xyz));
      r15.x = saturate(dot(r14.xyz, r15.xyz));
      if (r14.w == 0) {
        r14.w = lights[r13.y].surface_radius;
        r14.w = -r14.w + r13.z;
        r15.y = lights[r13.y].attenuation_radius;
        r14.w = max(0, r14.w);
        r15.y = r14.w / r15.y;
        r15.y = r15.y * r15.y;
        r15.y = saturate(-r15.y * r15.y + 1);
        r15.y = r15.y * r15.y;
        r14.w = r14.w * r14.w + 1;
        r14.w = r15.y / r14.w;
      } else {
        r15.y = lights[r13.y].type;
        r15.z = cmp((int)r15.y == 2);
        if (r15.z != 0) {
          r16.x = lights[r13.y].direction.x;
          r16.y = lights[r13.y].direction.y;
          r16.z = lights[r13.y].direction.z;
          r14.x = dot(-r14.xyz, r16.xyz);
          r14.y = lights[r13.y].angle;
          r14.y = cos(r14.y);
          r14.x = cmp(r14.x >= r14.y);
          if (r14.x != 0) {
            r14.x = lights[r13.y].surface_radius;
            r13.z = -r14.x + r13.z;
            r14.x = lights[r13.y].attenuation_radius;
            r13.z = max(0, r13.z);
            r14.x = r13.z / r14.x;
            r14.x = r14.x * r14.x;
            r14.x = saturate(-r14.x * r14.x + 1);
            r14.x = r14.x * r14.x;
            r13.z = r13.z * r13.z + 1;
            r14.w = r14.x / r13.z;
          } else {
            r14.w = 0;
          }
        } else {
          r13.z = cmp((int)r15.y == 3);
          if (r13.z != 0) {
            r16.x = lights[r13.y].attenuation_radius;
            r16.y = lights[r13.y].position.x;
            r16.z = lights[r13.y].position.y;
            r16.w = lights[r13.y].position.z;
            r14.x = lights[r13.y].position.x;
            r14.y = lights[r13.y].position.y;
            r14.z = lights[r13.y].position.z;
            r17.x = lights[r13.y].direction.x;
            r17.y = lights[r13.y].direction.y;
            r17.z = lights[r13.y].direction.z;
            r17.w = lights[r13.y].length;
            r14.xyz = r17.xyz * r17.www + r14.xyz;
            r17.xyz = v2.xyz + -r16.yzw;
            r18.xyz = r14.xyz + -r16.yzw;
            r13.z = dot(r18.xyz, r18.xyz);
            r15.y = dot(r17.xyz, r18.xyz);
            r13.z = 0.00100000005 + r13.z;
            r13.z = r15.y / r13.z;
            r15.y = cmp(r13.z < 0);
            r15.z = cmp(1 < r13.z);
            r17.xyz = r18.xyz * r13.zzz + r16.yzw;
            r14.xyz = r15.zzz ? r14.xyz : r17.xyz;
            r14.xyz = r15.yyy ? r16.yzw : r14.xyz;
            r14.xyz = v2.xyz + -r14.xyz;
            r13.z = dot(r14.xyz, r14.xyz);
            r13.z = sqrt(r13.z);
            r14.x = lights[r13.y].surface_radius;
            r13.z = -r14.x + r13.z;
            r13.z = max(0, r13.z);
            r14.x = r13.z / r16.x;
            r14.x = r14.x * r14.x;
            r14.x = saturate(-r14.x * r14.x + 1);
            r14.x = r14.x * r14.x;
            r13.z = r13.z * r13.z + 1;
            r14.w = r14.x / r13.z;
          } else {
            r14.w = 1;
          }
        }
      }
      r16.x = lights[r13.y].color.x;
      r16.y = lights[r13.y].color.y;
      r16.z = lights[r13.y].color.z;
      r16.w = lights[r13.y].color.w;
      r14.xyz = cmp(r16.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
      r17.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r16.xyz;
      r18.xyz = r16.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
      r18.xyz = sqrt(r18.xyz);
      r18.xyz = float3(31.2429695,31.2429695,31.2429695) * r18.xyz;
      r16.xyz = r16.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r18.xyz;
      r16.xyz = float3(35.3486404,35.3486404,35.3486404) + r16.xyz;
      r14.xyz = r14.xyz ? r17.xyz : r16.xyz;
      r14.xyz = r14.xyz * r16.www;
      r13.y = lights[r13.y].intensity;
      r14.xyz = r14.xyz * r13.yyy;
      r14.xyz = r14.xyz * r14.www;
      r13.y = r13.x ? 1 : r5.w;
      r13.z = 1 + -r15.x;
      r14.w = r13.z * r13.z;
      r14.w = r14.w * r14.w;
      r13.z = r14.w * r13.z;
      r15.xyz = r11.xyz * r13.zzz + r3.xyz;
      r13.z = r13.w * r6.w + r8.w;
      r13.z = r13.w / r13.z;
      r13.z = r13.z * r10.w;
      r14.w = r15.w * r15.w;
      r14.w = r14.w * r4.x + 1;
      r14.w = r14.w * r14.w;
      r14.w = 3.14159274 * r14.w;
      r14.w = r11.w / r14.w;
      r16.xyz = float3(1,1,1) + -r15.xyz;
      r16.xyz = r4.yyy * -r16.xyz + r16.xyz;
      r15.xyz = r15.xyz * r13.zzz;
      r15.xyz = r15.xyz * r14.www;
      r13.z = r13.w * r12.x;
      r13.z = max(9.99999975e-05, r13.z);
      r15.xyz = r15.xyz / r13.zzz;
      r15.xyz = r16.xyz * r10.xyz + r15.xyz;
      r14.xyz = r15.xyz * r14.xyz;
      r14.xyz = r14.xyz * r13.www;
      r12.yzw = r14.xyz * r13.yyy + r12.yzw;
    }
    r13.x = (int)r13.x + 1;
  }
  r2.y = (int)r2.y | (int)r2.z;
  if (r2.y != 0) {
    r2.y = dot(v4.xyz, v4.xyz);
    r2.y = rsqrt(r2.y);
    r5.xyz = v4.xyz * r2.yyy;
    r0.yzw = r0.yzw * r1.xxx + -r5.xyz;
    r0.yzw = r0.yzw * float3(0.100000001,0.100000001,0.100000001) + r5.xyz;
    r1.x = dot(r0.yzw, r0.yzw);
    r1.x = rsqrt(r1.x);
    r0.yzw = r1.xxx * r0.yzw;
    if (r4.w == 0) {
      r1.x = ~(int)r0.x;
      r2.y = cmp(0 >= use_pcf_based_shadows);
      r5.yw = float2(1,1);
      r11.xyz = float3(1,1,0);
      r2.w = 0;
      while (true) {
        r4.x = cmp((uint)r11.z >= 4);
        r2.w = 0;
        if (r4.x != 0) break;
        r4.x = (uint)r11.z >> 1;
        r4.w = (int)r11.z & 1;
        r4.xw = (uint2)r4.xw;
        r6.w = 0.5 * r4.w;
        r4.w = r4.w * 0.5 + 0.5;
        r7.z = 0.5 * r4.x;
        r4.x = r4.x * 0.5 + 0.5;
        r6.w = cmp(v[r11.z+8].x >= r6.w);
        r7.w = cmp(r4.w >= v[r11.z+8].x);
        r6.w = r6.w ? r7.w : 0;
        r7.z = cmp(v[r11.z+8].y >= r7.z);
        r6.w = r6.w ? r7.z : 0;
        r7.z = cmp(r4.x >= v[r11.z+8].y);
        r6.w = r6.w ? r7.z : 0;
        if (r6.w != 0) {
          r6.w = 0;
          r7.z = -2;
          while (true) {
            r7.w = cmp(2 < (int)r7.z);
            if (r7.w != 0) break;
            r13.x = (int)r7.z;
            r7.w = r6.w;
            r8.w = -2;
            while (true) {
              r10.w = cmp(2 < (int)r8.w);
              if (r10.w != 0) break;
              r13.y = (int)r8.w;
              r13.zw = shadow_map_texel_size * r13.xy;
              r14.x = dot(r13.xy, float2(0.707106769,0.707106769));
              r14.y = dot(r13.xy, float2(-0.707106769,0.707106769));
              r14.xy = shadow_map_texel_size * r14.xy;
              r13.yz = r2.yy ? r13.zw : r14.xy;
              r13.yz = v[r11.z+8].xy + r13.yz;
              r10.w = shadow_map_texture.SampleLevel(mesh_point_clamp_sampler_s, r13.yz, 0).x;
              r10.w = -shadow_depth_bias + r10.w;
              r10.w = cmp(r10.w < v[r11.z+8].z);
              r10.w = r10.w ? 1.000000 : 0;
              r7.w = r10.w + r7.w;
              r8.w = (int)r8.w + 1;
            }
            r6.w = r7.w;
            r7.z = (int)r7.z + 1;
          }
          r5.z = 0.0399999991 * r6.w;
          r7.z = cmp((uint)r11.z < 3);
          if (r7.z != 0) {
            r4.xw = -v[r11.z+8].yx + r4.xw;
            r4.x = min(r4.w, r4.x);
            r4.w = 0;
            r7.z = -2;
            while (true) {
              r8.w = cmp(2 < (int)r7.z);
              if (r8.w != 0) break;
              r13.x = (int)r7.z;
              r8.w = r4.w;
              r10.w = -2;
              while (true) {
                r11.w = cmp(2 < (int)r10.w);
                if (r11.w != 0) break;
                r13.y = (int)r10.w;
                r13.zw = shadow_map_texel_size * r13.xy;
                r14.x = dot(r13.xy, float2(0.707106769,0.707106769));
                r14.y = dot(r13.xy, float2(-0.707106769,0.707106769));
                r14.xy = shadow_map_texel_size * r14.xy;
                r13.yz = r2.yy ? r13.zw : r14.xy;
                r13.yz = v[r11.z+9].xy + r13.yz;
                r11.w = shadow_map_texture.SampleLevel(mesh_point_clamp_sampler_s, r13.yz, 0).x;
                r11.w = -shadow_depth_bias + r11.w;
                r11.w = cmp(r11.w < v[r11.z+9].z);
                r11.w = r11.w ? 1.000000 : 0;
                r8.w = r11.w + r8.w;
                r10.w = (int)r10.w + 1;
              }
              r4.w = r8.w;
              r7.z = (int)r7.z + 1;
            }
            r4.x = 0.100000024 + -r4.x;
            r4.x = max(0, r4.x);
            r4.x = 10 * r4.x;
            r7.z = r4.w * 0.0399999991 + -r5.z;
            r5.z = r4.x * r7.z + r5.z;
          }
          if (r0.x != 0) {
            r11.xy = r5.wz;
            r2.w = 0;
            break;
          } else {
            r11.xy = r5.zz;
            r2.w = -1;
            break;
          }
          r2.w = r1.x;
        } else {
          r2.w = 0;
        }
        r5.x = (int)r11.z + 1;
        r11.xyz = r5.yyx;
      }
      r1.x = -1 + r11.y;
      r1.x = r3.w * r1.x + 1;
      r0.x = r0.x ? r1.x : 1;
      r0.x = r2.w ? r11.x : r0.x;
    } else {
      r0.x = 1;
    }
    r1.x = r0.x * r0.x;
    r1.x = rsqrt(r1.x);
    r0.x = r1.x * r0.x;
    r0.x = r2.z ? 0.5 : r0.x;
    if (r2.x != 0) {
      r1.x = dot(r0.xxx, r0.xxx);
      r1.x = rsqrt(r1.x);
      r1.x = r1.x * r0.x;
      r2.x = dot(r9.xyz, float3(0.298999995,0.587000012,0.114));
      r2.xy = float2(-0.0399999991,-0.180000007) + r2.xx;
      r2.xy = saturate(float2(12.5,8.33333302) * r2.xy);
      r2.zw = r2.xy * float2(-2,-2) + float2(3,3);
      r2.xy = r2.xy * r2.xy;
      r2.x = r2.z * r2.x;
      r2.y = -r2.w * r2.y + 1;
      r2.x = r2.x * r2.y;
      r9.xyz = saturate(r9.xyz);
      r2.yzw = r9.xyz * r9.xyz;
      r5.xyz = log2(r9.xyz);
      r5.xyz = float3(1.14999998,1.14999998,1.14999998) * r5.xyz;
      r5.xyz = exp2(r5.xyz);
      r5.xyz = -r9.xyz * r9.xyz + r5.xyz;
      r2.xyz = r2.xxx * r5.xyz + r2.yzw;
      r2.w = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
      r2.w = 8 * r2.w;
      r2.w = floor(r2.w);
      r2.w = 0.125 * r2.w;
      r5.xyz = float3(9.99999975e-06,9.99999975e-06,9.99999975e-06) + r2.xyz;
      r3.w = dot(r5.xyz, r5.xyz);
      r3.w = rsqrt(r3.w);
      r5.xyz = r5.xyz * r3.www;
      r5.xyz = saturate(r5.xyz * r2.www);
      r5.xyz = r5.xyz + -r2.xyz;
      r2.xyz = r5.xyz * float3(0.600000024,0.600000024,0.600000024) + r2.xyz;
      r1.x = saturate(dot(r0.yzw, r1.xxx));
      r5.xyzw = float4(-0.125,-0.25,-0.375,-0.5) + r1.xxxx;
      r5.xyzw = saturate(float4(499.998993,499.998993,499.998993,500.006439) * r5.xyzw);
      r11.xyzw = r5.xyzw * float4(-2,-2,-2,-2) + float4(3,3,3,3);
      r5.xyzw = r5.xyzw * r5.xyzw;
      r5.xyzw = r11.xyzw * r5.xyzw;
      r11.xyz = r5.xxx * r2.xyz;
      r11.xyz = float3(0.13000001,0.13000001,0.13000001) * r11.xyz;
      r11.xyz = r2.xyz * float3(0.0199999996,0.0199999996,0.0199999996) + r11.xyz;
      r13.xyz = r2.xyz * float3(0.300000012,0.300000012,0.300000012) + -r11.xyz;
      r11.xyz = r5.yyy * r13.xyz + r11.xyz;
      r13.xyz = r2.xyz * float3(0.5,0.5,0.5) + -r11.xyz;
      r5.xyz = r5.zzz * r13.xyz + r11.xyz;
      r11.xyz = r2.xyz * float3(0.649999976,0.649999976,0.649999976) + -r5.xyz;
      r5.xyz = r5.www * r11.xyz + r5.xyz;
      r11.xyz = float3(-0.625,-0.75,-0.875) + r1.xxx;
      r11.xyz = saturate(float3(500.006439,500.006439,500.006439) * r11.xyz);
      r13.xyz = r11.xyz * float3(-2,-2,-2) + float3(3,3,3);
      r11.xyz = r11.xyz * r11.xyz;
      r11.xyz = r13.xyz * r11.xyz;
      r13.xyz = r2.xyz * float3(0.800000012,0.800000012,0.800000012) + -r5.xyz;
      r5.xyz = r11.xxx * r13.xyz + r5.xyz;
      r13.xyz = r2.xyz * float3(0.949999988,0.949999988,0.949999988) + -r5.xyz;
      r5.xyz = r11.yyy * r13.xyz + r5.xyz;
      r2.xyz = -r5.xyz + r2.xyz;
      r2.xyz = r11.zzz * r2.xyz + r5.xyz;
      r1.x = 1 + -r4.z;
      r5.xyz = r2.xyz * r1.xxx;
      r2.xyz = r5.xyz * float3(-0.899999976,-0.899999976,-0.800000012) + r2.xyz;
      r5.xyz = ddx_coarse(r0.yzw);
      r11.xyz = ddy_coarse(r0.yzw);
      r1.x = dot(r5.xyz, r5.xyz);
      r1.x = sqrt(r1.x);
      r2.w = dot(r11.xyz, r11.xyz);
      r2.w = sqrt(r2.w);
      r1.x = r2.w + r1.x;
      r2.w = -10 + abs(v1.z);
      r2.w = saturate(0.00999999978 * r2.w);
      r2.w = 1 + r2.w;
      r1.x = r2.w * r1.x;
      r1.x = 1.5 * r1.x;
      r1.x = min(1, r1.x);
      r1.x = -0.0900000036 + r1.x;
      r1.x = saturate(3.22580647 * r1.x);
      r2.w = r1.x * -2 + 3;
      r1.x = r1.x * r1.x;
      r1.x = r2.w * r1.x;
      r9.xyz = saturate(r1.xxx * -r2.xyz + r2.xyz);
    } else {
      r1.x = dot(r0.xxx, r0.xxx);
      r1.x = rsqrt(r1.x);
      r0.x = r1.x * r0.x;
      r1.x = dot(r9.xyz, float3(0.298999995,0.587000012,0.114));
      r2.xy = float2(-0.0399999991,-0.180000007) + r1.xx;
      r2.xy = saturate(float2(12.5,8.33333302) * r2.xy);
      r2.zw = r2.xy * float2(-2,-2) + float2(3,3);
      r2.xy = r2.xy * r2.xy;
      r1.x = r2.z * r2.x;
      r2.x = -r2.w * r2.y + 1;
      r1.x = r2.x * r1.x;
      r9.xyz = saturate(r9.xyz);
      r2.xyz = log2(r9.xyz);
      r5.xyz = float3(1.79999995,1.79999995,1.79999995) * r2.xyz;
      r5.xyz = exp2(r5.xyz);
      r2.xyz = float3(1.20000005,1.20000005,1.20000005) * r2.xyz;
      r2.xyz = exp2(r2.xyz);
      r2.xyz = r2.xyz + -r5.xyz;
      r2.xyz = r1.xxx * r2.xyz + r5.xyz;
      r1.x = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
      r1.x = 8 * r1.x;
      r1.x = floor(r1.x);
      r1.x = 0.125 * r1.x;
      r5.xyz = float3(9.99999975e-06,9.99999975e-06,9.99999975e-06) + r2.xyz;
      r2.w = dot(r5.xyz, r5.xyz);
      r2.w = rsqrt(r2.w);
      r5.xyz = r5.xyz * r2.www;
      r5.xyz = saturate(r5.xyz * r1.xxx);
      r5.xyz = r5.xyz + -r2.xyz;
      r2.xyz = r5.xyz * float3(0.600000024,0.600000024,0.600000024) + r2.xyz;
      r0.x = saturate(dot(r0.yzw, r0.xxx));
      r5.xyzw = float4(-0.125,-0.25,-0.375,-0.5) + r0.xxxx;
      r5.xyzw = saturate(float4(499.998993,499.998993,499.998993,500.006439) * r5.xyzw);
      r11.xyzw = r5.xyzw * float4(-2,-2,-2,-2) + float4(3,3,3,3);
      r5.xyzw = r5.xyzw * r5.xyzw;
      r5.xyzw = r11.xyzw * r5.xyzw;
      r11.xyz = r5.xxx * r2.xyz;
      r11.xyz = float3(0.13000001,0.13000001,0.13000001) * r11.xyz;
      r11.xyz = r2.xyz * float3(0.0199999996,0.0199999996,0.0199999996) + r11.xyz;
      r13.xyz = r2.xyz * float3(0.300000012,0.300000012,0.300000012) + -r11.xyz;
      r11.xyz = r5.yyy * r13.xyz + r11.xyz;
      r13.xyz = r2.xyz * float3(0.5,0.5,0.5) + -r11.xyz;
      r5.xyz = r5.zzz * r13.xyz + r11.xyz;
      r11.xyz = r2.xyz * float3(0.649999976,0.649999976,0.649999976) + -r5.xyz;
      r5.xyz = r5.www * r11.xyz + r5.xyz;
      r11.xyz = float3(-0.625,-0.75,-0.875) + r0.xxx;
      r11.xyz = saturate(float3(500.006439,500.006439,500.006439) * r11.xyz);
      r13.xyz = r11.xyz * float3(-2,-2,-2) + float3(3,3,3);
      r11.xyz = r11.xyz * r11.xyz;
      r11.xyz = r13.xyz * r11.xyz;
      r13.xyz = r2.xyz * float3(0.800000012,0.800000012,0.800000012) + -r5.xyz;
      r5.xyz = r11.xxx * r13.xyz + r5.xyz;
      r13.xyz = r2.xyz * float3(0.949999988,0.949999988,0.949999988) + -r5.xyz;
      r5.xyz = r11.yyy * r13.xyz + r5.xyz;
      r2.xyz = -r5.xyz + r2.xyz;
      r2.xyz = r11.zzz * r2.xyz + r5.xyz;
      r0.x = saturate(dot(r0.yzw, r6.xyz));
      r0.x = 1 + -r0.x;
      r0.x = r0.x * r0.x + -0.899999976;
      r0.x = saturate(14.2857037 * r0.x);
      r1.x = r0.x * -2 + 3;
      r0.x = r0.x * r0.x;
      r0.x = r1.x * r0.x;
      r2.xyz = r0.xxx * -r2.xyz + r2.xyz;
      r5.xyz = ddx_coarse(r0.yzw);
      r0.xyz = ddy_coarse(r0.yzw);
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
      r9.xyz = saturate(r0.xxx * -r2.xyz + r2.xyz);
    }
  } else {
    r0.xy = float2(1,1) + -r7.yx;
    r0.xzw = max(r0.xxx, r3.xyz);
    r0.xzw = r0.xzw + -r3.xyz;
    r1.x = r0.y * r0.y;
    r1.x = r1.x * r1.x;
    r0.y = r1.x * r0.y;
    r0.xyz = r0.xzw * r0.yyy + r3.xyz;
    r2.xyz = float3(1,1,1) + -r0.xyz;
    r2.xyz = r4.yyy * -r2.xyz + r2.xyz;
    r2.xyz = r2.xyz * r10.xyz;
    r3.xyz = irradiance_texture.Sample(mesh_anisotropic_wrap_sampler_s, r1.yzw).xyz;
    r4.xyw = cmp(r3.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
    r5.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r3.xyz;
    r10.xyz = r3.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
    r10.xyz = sqrt(r10.xyz);
    r10.xyz = float3(31.2429695,31.2429695,31.2429695) * r10.xyz;
    r3.xyz = r3.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r10.xyz;
    r3.xyz = float3(35.3486404,35.3486404,35.3486404) + r3.xyz;
    r3.xyz = r4.xyw ? r5.xyz : r3.xyz;
    r0.w = dot(-r6.xyz, r1.yzw);
    r0.w = r0.w + r0.w;
    r1.xyz = r1.yzw * -r0.www + -r6.xyz;
    r0.w = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r0.w);
    r1.xyz = r1.xyz * r0.www;
    r0.w = 3 * r7.y;
    r1.xyz = radiance_texture.SampleLevel(mesh_anisotropic_wrap_sampler_s, r1.xyz, r0.w).xyz;
    r4.xyw = cmp(r1.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
    r5.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r1.xyz;
    r6.xyz = r1.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
    r6.xyz = sqrt(r6.xyz);
    r6.xyz = float3(31.2429695,31.2429695,31.2429695) * r6.xyz;
    r1.xyz = r1.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r6.xyz;
    r1.xyz = float3(35.3486404,35.3486404,35.3486404) + r1.xyz;
    r1.xyz = r4.xyw ? r5.xyz : r1.xyz;
    r4.xy = dfg_texture.SampleLevel(mesh_linear_clamp_sampler_s, r7.xy, 0).xy;
    r0.xyz = r0.xyz * r4.xxx + r4.yyy;
    r0.xyz = r0.xyz * r1.xyz;
    r0.xyz = r2.xyz * r3.xyz + r0.xyz;
    r0.xyz = r12.yzw + r0.xyz;
    r9.xyz = r0.xyz * r4.zzz + r8.xyz;
  }
  o0.xyzw = r9.xyzw;
  o1.w = r9.w;
  o1.xyz = r8.xyz;
  return;
}