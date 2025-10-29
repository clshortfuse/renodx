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

cbuffer atmosphere_cb_data : register(b6)
{
  float4 atmosphere_color : packoffset(c0);
  float atmosphere_spread : packoffset(c1);
  float cloud_rotation_speed : packoffset(c1.y);
  float cloud_animation_speed : packoffset(c1.z);
  float cloud_noise_0_zoom : packoffset(c1.w);
  float cloud_noise_0_intensity : packoffset(c2);
  float cloud_noise_1_zoom : packoffset(c2.y);
  float cloud_noise_1_intensity : packoffset(c2.z);
  float planet_radius : packoffset(c2.w);
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

cbuffer advanced_planet_rendering_cb_data : register(b4)
{
  float enable_volumetric_scattering : packoffset(c0);
  float enable_parallax_occlusion : packoffset(c0.y);
  float enable_flow_maps : packoffset(c0.z);
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
Texture2D<float4> noise_texture : register(t12);


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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22,r23;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 v[4] = { v0,v1,v2,v3 };
  r0.x = time * cloud_rotation_speed + v6.x;
  r0.y = v6.y;
  r0.zw = mask_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.xy).xy;
  r1.xy = cmp(float2(0.00999999978,0.00999999978) < r0.zw);
  r1.x = (int)r1.y | (int)r1.x;
  r1.yz = cmp(r0.zw < float2(0.99000001,0.99000001));
  r1.y = (int)r1.z | (int)r1.y;
  r1.x = r1.y ? r1.x : 0;
  if (r1.x != 0) {
    r0.zw = r0.zw * float2(2,2) + float2(-1,-1);
    r1.y = dot(r0.zw, r0.zw);
    r1.y = rsqrt(r1.y);
    r1.yz = r1.yy * r0.zw;
    r2.xy = r1.yz * float2(0.0009765625,0.0009765625) + r0.xy;
    r2.xy = mask_texture.Sample(mesh_anisotropic_wrap_sampler_s, r2.xy).xy;
    r2.xy = r2.xy * float2(2,2) + float2(-1,-1);
    r1.yz = -r1.yz * float2(0.0009765625,0.0009765625) + r0.xy;
    r1.yz = mask_texture.Sample(mesh_anisotropic_wrap_sampler_s, r1.yz).xy;
    r1.yz = r1.yz * float2(2,2) + float2(-1,-1);
    r0.zw = float2(0.5,0.5) * r0.zw;
    r0.zw = r2.xy * float2(0.25,0.25) + r0.zw;
    r0.zw = r1.yz * float2(0.25,0.25) + r0.zw;
    r1.y = dot(r0.zw, r0.zw);
    r1.z = sqrt(r1.y);
    r1.z = min(1, r1.z);
    r1.z = log2(r1.z);
    r1.z = 0.850000024 * r1.z;
    r1.z = exp2(r1.z);
    r1.y = rsqrt(r1.y);
    r0.zw = r1.yy * r0.zw;
    r0.zw = r0.zw * r1.zz;
    r1.y = dot(r0.xy, float2(12.9898005,78.2330017));
    r1.y = sin(r1.y);
    r1.y = r1.y * 43758.5469 + time;
    r1.y = frac(r1.y);
    r1.y = 9.99999975e-05 * r1.y;
    r0.zw = r0.zw * float2(0.200000003,0.200000003) + r1.yy;
    r1.y = 0.0799999982 * time;
    r1.z = time * 0.0799999982 + 0.5;
    r1.yz = frac(r1.yz);
    r1.w = -0.5 + r1.y;
    r2.x = abs(r1.w) + abs(r1.w);
    r1.w = -abs(r1.w) * 2 + 1;
    r2.yz = r0.zw * r1.yy + r0.xy;
    r0.zw = r0.zw * r1.zz + r0.xy;
    r1.yz = r0.zw * r2.xx;
    r1.yz = r2.yz * r1.ww + r1.yz;
    r0.xy = float2(0.999989986,0.999989986) * r1.yz;
    r3.xyzw = base_color_texture.Sample(mesh_anisotropic_wrap_sampler_s, r2.yz).xyzw;
    r4.xyzw = base_color_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.zw).xyzw;
    r4.xyzw = r4.xyzw * r2.xxxx;
    r3.xyzw = r3.xyzw * r1.wwww + r4.xyzw;
    r1.yz = normal_texture.Sample(mesh_anisotropic_wrap_sampler_s, r2.yz).xy;
    r4.xy = normal_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.zw).xy;
    r4.xy = r4.xy * r2.xx;
    r1.yz = r1.yz * r1.ww + r4.xy;
    r1.yz = float2(0.999989986,0.999989986) * r1.yz;
    r4.xyz = occlusion_roughness_metallic_texture.Sample(mesh_anisotropic_wrap_sampler_s, r2.yz).xyz;
    r5.xyz = occlusion_roughness_metallic_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.zw).xyz;
    r5.xyz = r5.xyz * r2.xxx;
    r4.xyz = r4.xyz * r1.www + r5.xyz;
    r4.xyz = float3(0.999989986,0.999989986,0.999989986) * r4.yzx;
    r3.xyzw = float4(0.999989986,0.999989986,0.999989986,0.999989986) * r3.xyzw;
    r2.y = mask_texture.Sample(mesh_anisotropic_wrap_sampler_s, r2.yz).z;
    r0.z = mask_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.zw).z;
    r0.z = r0.z * r2.x;
    r0.z = r2.y * r1.w + r0.z;
    r0.z = 0.999989986 * r0.z;
  } else {
    r0.z = 0;
    r3.xyzw = base_color_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.xy).xyzw;
    r1.yz = normal_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.xy).xy;
    r4.xyz = occlusion_roughness_metallic_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.xy).yzx;
  }
  r0.x = mask_texture.Sample(mesh_anisotropic_wrap_sampler_s, r0.xy).z;
  r0.x = r1.x ? r0.z : r0.x;
  r0.y = dot(r1.yz, r1.yz);
  r0.y = 1 + -r0.y;
  r0.y = max(0, r0.y);
  r0.y = sqrt(r0.y);
  r2.xyz = v5.yzx * v4.zxy;
  r2.xyz = v4.yzx * v5.zxy + -r2.xyz;
  r2.xyz = w1.xww * r2.xyz;
  r1.xzw = r2.xyz * r1.zzz;
  r1.xyz = r1.yyy * v5.xyz + r1.xzw;
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
  r4.w = sqrt(r3.w);
  r4.w = 7500 + -r4.w;
  r4.w = saturate(0.000222222225 * r4.w);
  r5.w = cmp(0 >= r4.w);
  r4.w = r0.x ? r4.w : 0;
  r5.w = r0.x ? r5.w : 0;
  if (r5.w == 0) {
    r6.w = ~(int)r0.x;
    r8.w = cmp(0 >= use_pcf_based_shadows);
    r12.yw = float2(1,1);
    r13.xyz = float3(1,1,0);
    r10.w = 0;
    while (true) {
      r11.w = cmp((uint)r13.z >= 4);
      r10.w = 0;
      if (r11.w != 0) break;
      r11.w = (uint)r13.z >> 1;
      r13.w = (int)r13.z & 1;
      r13.w = (uint)r13.w;
      r14.x = 0.5 * r13.w;
      r13.w = r13.w * 0.5 + 0.5;
      r11.w = (uint)r11.w;
      r14.y = 0.5 * r11.w;
      r11.w = r11.w * 0.5 + 0.5;
      r14.xy = cmp(v[r13.z+8].xy >= r14.xy);
      r14.z = cmp(r13.w >= v[r13.z+8].x);
      r14.x = r14.z ? r14.x : 0;
      r14.x = r14.y ? r14.x : 0;
      r14.y = cmp(r11.w >= v[r13.z+8].y);
      r14.x = r14.y ? r14.x : 0;
      if (r14.x != 0) {
        r14.xy = float2(0,-nan);
        while (true) {
          r14.z = cmp(2 < (int)r14.y);
          if (r14.z != 0) break;
          r15.x = (int)r14.y;
          r14.z = r14.x;
          r14.w = -2;
          while (true) {
            r15.z = cmp(2 < (int)r14.w);
            if (r15.z != 0) break;
            r15.y = (int)r14.w;
            r15.zw = shadow_map_texel_size * r15.xy;
            r16.x = dot(r15.xy, float2(0.707106769,0.707106769));
            r16.y = dot(r15.xy, float2(-0.707106769,0.707106769));
            r16.xy = shadow_map_texel_size * r16.xy;
            r15.yz = r8.ww ? r15.zw : r16.xy;
            r15.yz = v[r13.z+8].xy + r15.yz;
            r15.y = shadow_map_texture.SampleLevel(mesh_point_clamp_sampler_s, r15.yz, 0).x;
            r15.y = -shadow_depth_bias + r15.y;
            r15.y = cmp(r15.y < v[r13.z+8].z);
            r15.y = r15.y ? 1.000000 : 0;
            r14.z = r15.y + r14.z;
            r14.w = (int)r14.w + 1;
          }
          r14.x = r14.z;
          r14.y = (int)r14.y + 1;
        }
        r12.z = 0.0399999991 * r14.x;
        r14.y = cmp((uint)r13.z < 3);
        if (r14.y != 0) {
          r13.w = -v[r13.z+8].x + r13.w;
          r11.w = -v[r13.z+8].y + r11.w;
          r11.w = min(r13.w, r11.w);
          r13.w = 0;
          r14.y = -2;
          while (true) {
            r14.w = cmp(2 < (int)r14.y);
            if (r14.w != 0) break;
            r15.x = (int)r14.y;
            r14.w = r13.w;
            r15.z = -2;
            while (true) {
              r15.w = cmp(2 < (int)r15.z);
              if (r15.w != 0) break;
              r15.y = (int)r15.z;
              r16.xy = shadow_map_texel_size * r15.xy;
              r17.x = dot(r15.xy, float2(0.707106769,0.707106769));
              r17.y = dot(r15.xy, float2(-0.707106769,0.707106769));
              r15.yw = shadow_map_texel_size * r17.xy;
              r15.yw = r8.ww ? r16.xy : r15.yw;
              r15.yw = v[r13.z+9].xy + r15.yw;
              r15.y = shadow_map_texture.SampleLevel(mesh_point_clamp_sampler_s, r15.yw, 0).x;
              r15.y = -shadow_depth_bias + r15.y;
              r15.y = cmp(r15.y < v[r13.z+9].z);
              r15.y = r15.y ? 1.000000 : 0;
              r14.w = r15.y + r14.w;
              r15.z = (int)r15.z + 1;
            }
            r13.w = r14.w;
            r14.y = (int)r14.y + 1;
          }
          r11.w = 0.100000024 + -r11.w;
          r11.w = max(0, r11.w);
          r11.w = 10 * r11.w;
          r14.y = r13.w * 0.0399999991 + -r12.z;
          r12.z = r11.w * r14.y + r12.z;
        }
        if (r0.x != 0) {
          r13.xy = r12.wz;
          r10.w = 0;
          break;
        } else {
          r13.xy = r12.zz;
          r10.w = -1;
          break;
        }
        r10.w = r6.w;
      } else {
        r10.w = 0;
      }
      r12.x = (int)r13.z + 1;
      r13.xyz = r12.yyx;
    }
    r6.w = -1 + r13.y;
    r6.w = r4.w * r6.w + 1;
    r6.w = r0.x ? r6.w : 1;
    r6.w = r10.w ? r13.x : r6.w;
  } else {
    r6.w = 1;
  }
  r8.w = cmp(0 < enable_volumetric_scattering);
  r12.xyz = float3(1,1,1) + -r3.xyz;
  r3.w = rsqrt(r3.w);
  r11.xyz = r11.xyz * r3.www;
  r3.w = dot(v4.xyz, v4.xyz);
  r3.w = rsqrt(r3.w);
  r13.xyz = v4.xyz * r3.www;
  r3.w = saturate(w6.y);
  r3.w = -2.16404247 * r3.w;
  r3.w = exp2(r3.w);
  r10.w = saturate(dot(r13.xyz, r11.xyz));
  r10.w = 1 + -r10.w;
  r11.w = r10.w * r10.w;
  r10.w = r11.w * r10.w;
  r3.w = r10.w * r3.w;
  r10.w = 1 + -r7.x;
  r11.w = r10.w * r10.w;
  r12.w = r11.w * r11.w;
  r11.w = r12.w * r11.w;
  r13.w = 1 + r7.y;
  r13.w = r13.w * r13.w;
  r14.x = 0.125 * r13.w;
  r13.w = -r13.w * 0.125 + 1;
  r14.y = r7.x * r13.w + r14.x;
  r14.y = r7.x / r14.y;
  r14.z = r4.x * r4.x;
  r4.x = r4.x * r4.x + -1;
  r14.w = 4 * r7.x;
  r16.xyz = float3(0,0,0);
  r15.xyzw = float4(0,0,0,0);
  while (true) {
    r16.w = cmp((uint)r15.w >= (uint)r7.w);
    if (r16.w != 0) break;
    r17.xyz = cmp((int3)r15.www == int3(1,2,3));
    r16.w = (int)r17.y | (int)r17.x;
    r16.w = (int)r17.z | (int)r16.w;
    if (r16.w != 0) {
      r16.w = (int)r15.w + 1;
      r15.w = r16.w;
      continue;
    }
    r16.w = (int)r7.z + (int)r15.w;
    r16.w = light_indices[r16.w].index;
    r17.x = culled_lights[r16.w].index;
    if (r17.x == 0) {
      r17.x = lights[r16.w].position.x;
      r17.y = lights[r16.w].position.y;
      r17.z = lights[r16.w].position.z;
      r17.w = lights[r16.w].type;
      r17.xyz = -v2.xyz + r17.xyz;
      r18.x = dot(r17.xyz, r17.xyz);
      r18.x = sqrt(r18.x);
      r18.yzw = r17.xyz / r18.xxx;
      r19.xyz = r5.xyz * r2.www + r18.yzw;
      r19.w = dot(r19.xyz, r19.xyz);
      r19.w = rsqrt(r19.w);
      r19.xyz = r19.xyz * r19.www;
      r19.w = dot(r1.yzw, r18.yzw);
      r19.w = max(0.00100000005, r19.w);
      r19.w = min(1, r19.w);
      r20.x = saturate(dot(r1.yzw, r19.xyz));
      r19.x = saturate(dot(r18.yzw, r19.xyz));
      if (r17.w == 0) {
        r17.w = lights[r16.w].surface_radius;
        r17.w = r18.x + -r17.w;
        r19.y = lights[r16.w].attenuation_radius;
        r17.w = max(0, r17.w);
        r19.y = r17.w / r19.y;
        r19.y = r19.y * r19.y;
        r19.y = saturate(-r19.y * r19.y + 1);
        r19.y = r19.y * r19.y;
        r17.w = r17.w * r17.w + 1;
        r17.w = r19.y / r17.w;
      } else {
        r19.y = lights[r16.w].type;
        r19.z = cmp((int)r19.y == 2);
        if (r19.z != 0) {
          r20.y = lights[r16.w].direction.x;
          r20.z = lights[r16.w].direction.y;
          r20.w = lights[r16.w].direction.z;
          r19.z = dot(-r18.yzw, r20.yzw);
          r20.y = lights[r16.w].angle;
          r20.y = cos(r20.y);
          r19.z = cmp(r19.z >= r20.y);
          if (r19.z != 0) {
            r19.z = lights[r16.w].surface_radius;
            r18.x = -r19.z + r18.x;
            r19.z = lights[r16.w].attenuation_radius;
            r18.x = max(0, r18.x);
            r19.z = r18.x / r19.z;
            r19.z = r19.z * r19.z;
            r19.z = saturate(-r19.z * r19.z + 1);
            r19.z = r19.z * r19.z;
            r18.x = r18.x * r18.x + 1;
            r17.w = r19.z / r18.x;
          } else {
            r17.w = 0;
          }
        } else {
          r18.x = cmp((int)r19.y == 3);
          if (r18.x != 0) {
            r21.x = lights[r16.w].attenuation_radius;
            r21.y = lights[r16.w].position.x;
            r21.z = lights[r16.w].position.y;
            r21.w = lights[r16.w].position.z;
            r20.y = lights[r16.w].position.x;
            r20.z = lights[r16.w].position.y;
            r20.w = lights[r16.w].position.z;
            r22.x = lights[r16.w].direction.x;
            r22.y = lights[r16.w].direction.y;
            r22.z = lights[r16.w].direction.z;
            r22.w = lights[r16.w].length;
            r20.yzw = r22.xyz * r22.www + r20.yzw;
            r22.xyz = v2.xyz + -r21.yzw;
            r23.xyz = r20.yzw + -r21.yzw;
            r18.x = dot(r23.xyz, r23.xyz);
            r19.y = dot(r22.xyz, r23.xyz);
            r18.x = 0.00100000005 + r18.x;
            r18.x = r19.y / r18.x;
            r19.y = cmp(r18.x < 0);
            r19.z = cmp(1 < r18.x);
            r22.xyz = r23.xyz * r18.xxx + r21.yzw;
            r20.yzw = r19.zzz ? r20.yzw : r22.xyz;
            r20.yzw = r19.yyy ? r21.yzw : r20.yzw;
            r20.yzw = v2.xyz + -r20.yzw;
            r18.x = dot(r20.yzw, r20.yzw);
            r18.x = sqrt(r18.x);
            r19.y = lights[r16.w].surface_radius;
            r18.x = -r19.y + r18.x;
            r18.x = max(0, r18.x);
            r19.y = r18.x / r21.x;
            r19.y = r19.y * r19.y;
            r19.y = saturate(-r19.y * r19.y + 1);
            r19.y = r19.y * r19.y;
            r18.x = r18.x * r18.x + 1;
            r17.w = r19.y / r18.x;
          } else {
            r17.w = 1;
          }
        }
      }
      r21.x = lights[r16.w].color.x;
      r21.y = lights[r16.w].color.y;
      r21.z = lights[r16.w].color.z;
      r21.w = lights[r16.w].color.w;
      r20.yzw = cmp(r21.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
      r22.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r21.xyz;
      r23.xyz = r21.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
      r23.xyz = sqrt(r23.xyz);
      r23.xyz = float3(31.2429695,31.2429695,31.2429695) * r23.xyz;
      r21.xyz = r21.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r23.xyz;
      r21.xyz = float3(35.3486404,35.3486404,35.3486404) + r21.xyz;
      r20.yzw = r20.yzw ? r22.xyz : r21.xyz;
      r20.yzw = r20.yzw * r21.www;
      r16.w = lights[r16.w].intensity;
      r20.yzw = r20.yzw * r16.www;
      r20.yzw = r20.yzw * r17.www;
      if (r15.w == 0) {
        if (r8.w != 0) {
          r17.xyz = -v2.xyz + r17.xyz;
          r16.w = dot(r17.xyz, r17.xyz);
          r16.w = rsqrt(r16.w);
          r17.xyz = r17.xyz * r16.www;
          r16.w = saturate(dot(r13.xyz, r17.xyz));
          r17.w = log2(r16.w);
          r17.w = 1.5 * r17.w;
          r17.w = exp2(r17.w);
          r17.x = dot(r11.xyz, r17.xyz);
          r17.x = -r17.x * 1.20000005 + 1.36000001;
          r17.x = max(0.0500000007, r17.x);
          r17.x = log2(r17.x);
          r17.x = 1.5 * r17.x;
          r17.x = exp2(r17.x);
          r17.x = 0.639999986 / r17.x;
          r16.w = 1 + -r16.w;
          r16.w = r16.w * r16.w;
          r17.y = r16.w * r16.w;
          r16.w = r17.y * r16.w;
          r21.xyzw = r16.wwww * float4(0.560000002,-0.400000006,-0.776000023,1.5) + float4(0.300000012,0.600000024,1,1);
          r21.xyz = r21.xyz * r21.www;
          r16.w = r17.w * r3.w;
          r16.w = r16.w * r17.x;
          r16.w = 1.20000005 * r16.w;
          r17.xyz = r21.xyz * r16.www;
          r17.xyz = atmosphere_color.www * r17.xyz;
          r15.xyz = float3(0.5,0.5,0.5) * r17.xyz;
        } else {
          r16.w = dot(r11.xyz, r18.yzw);
          r17.xy = float2(-0.349999994,-0.600000024) + r16.ww;
          r17.xy = saturate(float2(4.99999952,5.00000048) * r17.xy);
          r17.zw = r17.xy * float2(-2,-2) + float2(3,3);
          r17.xy = r17.xy * r17.xy;
          r17.xy = r17.zw * r17.xy;
          r17.xzw = r17.xxx * float3(0,-0.549999952,-0.200000003) + float3(1,0.949999988,0.200000003);
          r18.xyz = float3(0.899999976,0.100000001,0.0500000007) + -r17.xzw;
          r17.xzw = r17.yyy * r18.xyz + r17.xzw;
          r17.xzw = -atmosphere_color.xyz + r17.xzw;
          r17.xyz = r17.yyy * r17.xzw + atmosphere_color.xyz;
          r16.w = -r16.w * 1.29999995 + 1.4224999;
          r16.w = log2(r16.w);
          r16.w = 1.5 * r16.w;
          r16.w = exp2(r16.w);
          r16.w = 0.577500045 / r16.w;
          r16.w = 1.5 * r16.w;
          r16.w = min(1, r16.w);
          r16.w = 1 + r16.w;
          r17.xyz = r17.xyz * r16.www;
          r17.xyz = atmosphere_color.www * r17.xyz;
          r17.xyz = r17.xyz * r11.www;
          r17.xyz = r17.xyz * r19.www;
          r15.xyz = float3(5,5,5) * r17.xyz;
        }
        r16.w = r6.w;
      } else {
        r16.w = 1;
      }
      r17.x = 1 + -r19.x;
      r17.y = r17.x * r17.x;
      r17.y = r17.y * r17.y;
      r17.x = r17.x * r17.y;
      r17.xyz = r12.xyz * r17.xxx + r3.xyz;
      r17.w = r19.w * r13.w + r14.x;
      r17.w = r19.w / r17.w;
      r17.w = r17.w * r14.y;
      r18.x = r20.x * r20.x;
      r18.x = r18.x * r4.x + 1;
      r18.x = r18.x * r18.x;
      r18.x = 3.14159274 * r18.x;
      r18.x = r14.z / r18.x;
      r18.yzw = float3(1,1,1) + -r17.xyz;
      r18.yzw = r4.yyy * -r18.yzw + r18.yzw;
      r17.xyz = r17.xyz * r17.www;
      r17.xyz = r17.xyz * r18.xxx;
      r17.w = r19.w * r14.w;
      r17.w = max(9.99999975e-05, r17.w);
      r17.xyz = r17.xyz / r17.www;
      r17.xyz = r18.yzw * r10.xyz + r17.xyz;
      r17.xyz = r17.xyz * r20.yzw;
      r17.xyz = r17.xyz * r19.www;
      r16.xyz = r17.xyz * r16.www + r16.xyz;
    }
    r15.w = (int)r15.w + 1;
  }
  r2.y = (int)r2.y | (int)r2.z;
  if (r2.y != 0) {
    r0.yzw = r0.yzw * r1.xxx + -r13.xyz;
    r0.yzw = r0.yzw * float3(0.100000001,0.100000001,0.100000001) + r13.xyz;
    r1.x = dot(r0.yzw, r0.yzw);
    r1.x = rsqrt(r1.x);
    r0.yzw = r1.xxx * r0.yzw;
    if (r5.w == 0) {
      r1.x = ~(int)r0.x;
      r2.y = cmp(0 >= use_pcf_based_shadows);
      r5.yw = float2(1,1);
      r11.xyz = float3(1,1,0);
      r2.w = 0;
      while (true) {
        r3.w = cmp((uint)r11.z >= 4);
        r2.w = 0;
        if (r3.w != 0) break;
        r3.w = (uint)r11.z >> 1;
        r4.x = (int)r11.z & 1;
        r4.x = (uint)r4.x;
        r6.w = 0.5 * r4.x;
        r4.x = r4.x * 0.5 + 0.5;
        r3.w = (uint)r3.w;
        r7.z = 0.5 * r3.w;
        r3.w = r3.w * 0.5 + 0.5;
        r6.w = cmp(v[r11.z+8].x >= r6.w);
        r7.w = cmp(r4.x >= v[r11.z+8].x);
        r6.w = r6.w ? r7.w : 0;
        r7.z = cmp(v[r11.z+8].y >= r7.z);
        r6.w = r6.w ? r7.z : 0;
        r7.z = cmp(r3.w >= v[r11.z+8].y);
        r6.w = r6.w ? r7.z : 0;
        if (r6.w != 0) {
          r6.w = 0;
          r7.z = -2;
          while (true) {
            r7.w = cmp(2 < (int)r7.z);
            if (r7.w != 0) break;
            r12.x = (int)r7.z;
            r7.w = r6.w;
            r8.w = -2;
            while (true) {
              r11.w = cmp(2 < (int)r8.w);
              if (r11.w != 0) break;
              r12.y = (int)r8.w;
              r13.xy = shadow_map_texel_size * r12.xy;
              r14.x = dot(r12.xy, float2(0.707106769,0.707106769));
              r14.y = dot(r12.xy, float2(-0.707106769,0.707106769));
              r12.yz = shadow_map_texel_size * r14.xy;
              r12.yz = r2.yy ? r13.xy : r12.yz;
              r12.yz = v[r11.z+8].xy + r12.yz;
              r11.w = shadow_map_texture.SampleLevel(mesh_point_clamp_sampler_s, r12.yz, 0).x;
              r11.w = -shadow_depth_bias + r11.w;
              r11.w = cmp(r11.w < v[r11.z+8].z);
              r11.w = r11.w ? 1.000000 : 0;
              r7.w = r11.w + r7.w;
              r8.w = (int)r8.w + 1;
            }
            r6.w = r7.w;
            r7.z = (int)r7.z + 1;
          }
          r5.z = 0.0399999991 * r6.w;
          r7.z = cmp((uint)r11.z < 3);
          if (r7.z != 0) {
            r4.x = -v[r11.z+8].x + r4.x;
            r3.w = -v[r11.z+8].y + r3.w;
            r3.w = min(r4.x, r3.w);
            r4.x = 0;
            r7.z = -2;
            while (true) {
              r8.w = cmp(2 < (int)r7.z);
              if (r8.w != 0) break;
              r12.x = (int)r7.z;
              r8.w = r4.x;
              r11.w = -2;
              while (true) {
                r12.z = cmp(2 < (int)r11.w);
                if (r12.z != 0) break;
                r12.y = (int)r11.w;
                r13.xy = shadow_map_texel_size * r12.xy;
                r14.x = dot(r12.xy, float2(0.707106769,0.707106769));
                r14.y = dot(r12.xy, float2(-0.707106769,0.707106769));
                r12.yz = shadow_map_texel_size * r14.xy;
                r12.yz = r2.yy ? r13.xy : r12.yz;
                r12.yz = v[r11.z+9].xy + r12.yz;
                r12.y = shadow_map_texture.SampleLevel(mesh_point_clamp_sampler_s, r12.yz, 0).x;
                r12.y = -shadow_depth_bias + r12.y;
                r12.y = cmp(r12.y < v[r11.z+9].z);
                r12.y = r12.y ? 1.000000 : 0;
                r8.w = r12.y + r8.w;
                r11.w = (int)r11.w + 1;
              }
              r4.x = r8.w;
              r7.z = (int)r7.z + 1;
            }
            r3.w = 0.100000024 + -r3.w;
            r3.w = max(0, r3.w);
            r3.w = 10 * r3.w;
            r7.z = r4.x * 0.0399999991 + -r5.z;
            r5.z = r3.w * r7.z + r5.z;
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
      r1.x = r4.w * r1.x + 1;
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
      r12.xyz = r2.xyz * float3(0.300000012,0.300000012,0.300000012) + -r11.xyz;
      r11.xyz = r5.yyy * r12.xyz + r11.xyz;
      r12.xyz = r2.xyz * float3(0.5,0.5,0.5) + -r11.xyz;
      r5.xyz = r5.zzz * r12.xyz + r11.xyz;
      r11.xyz = r2.xyz * float3(0.649999976,0.649999976,0.649999976) + -r5.xyz;
      r5.xyz = r5.www * r11.xyz + r5.xyz;
      r11.xyz = float3(-0.625,-0.75,-0.875) + r1.xxx;
      r11.xyz = saturate(float3(500.006439,500.006439,500.006439) * r11.xyz);
      r12.xyz = r11.xyz * float3(-2,-2,-2) + float3(3,3,3);
      r11.xyz = r11.xyz * r11.xyz;
      r11.xyz = r12.xyz * r11.xyz;
      r12.xyz = r2.xyz * float3(0.800000012,0.800000012,0.800000012) + -r5.xyz;
      r5.xyz = r11.xxx * r12.xyz + r5.xyz;
      r12.xyz = r2.xyz * float3(0.949999988,0.949999988,0.949999988) + -r5.xyz;
      r5.xyz = r11.yyy * r12.xyz + r5.xyz;
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
      r12.xyz = r2.xyz * float3(0.300000012,0.300000012,0.300000012) + -r11.xyz;
      r11.xyz = r5.yyy * r12.xyz + r11.xyz;
      r12.xyz = r2.xyz * float3(0.5,0.5,0.5) + -r11.xyz;
      r5.xyz = r5.zzz * r12.xyz + r11.xyz;
      r11.xyz = r2.xyz * float3(0.649999976,0.649999976,0.649999976) + -r5.xyz;
      r5.xyz = r5.www * r11.xyz + r5.xyz;
      r11.xyz = float3(-0.625,-0.75,-0.875) + r0.xxx;
      r11.xyz = saturate(float3(500.006439,500.006439,500.006439) * r11.xyz);
      r12.xyz = r11.xyz * float3(-2,-2,-2) + float3(3,3,3);
      r11.xyz = r11.xyz * r11.xyz;
      r11.xyz = r12.xyz * r11.xyz;
      r12.xyz = r2.xyz * float3(0.800000012,0.800000012,0.800000012) + -r5.xyz;
      r5.xyz = r11.xxx * r12.xyz + r5.xyz;
      r12.xyz = r2.xyz * float3(0.949999988,0.949999988,0.949999988) + -r5.xyz;
      r5.xyz = r11.yyy * r12.xyz + r5.xyz;
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
    r0.x = 1 + -r7.y;
    r0.xyz = max(r0.xxx, r3.xyz);
    r0.xyz = r0.xyz + -r3.xyz;
    r0.w = r12.w * r10.w;
    r0.xyz = r0.xyz * r0.www + r3.xyz;
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
    r0.xyz = r16.xyz + r0.xyz;
    r0.xyz = r0.xyz * r4.zzz + r8.xyz;
    r0.w = saturate(abs(v3.y) / planet_radius);
    r0.w = -0.75 + r0.w;
    r0.w = saturate(r0.w * -5 + 1);
    r0.xyz = r0.xyz * r0.www;
    r1.xy = cloud_noise_0_zoom * v6.xy;
    r0.w = noise_texture.Sample(mesh_anisotropic_wrap_sampler_s, r1.xy).x;
    r1.x = time * cloud_animation_speed;
    r1.x = cloud_noise_0_intensity * r0.w + -r1.x;
    r1.y = 0;
    r1.xy = cloud_noise_1_zoom * v6.xy + -r1.xy;
    r0.w = noise_texture.Sample(mesh_anisotropic_wrap_sampler_s, r1.xy).x;
    r0.w = saturate(cloud_noise_1_intensity * r0.w);
    r9.xyz = r0.xyz * r0.www + r15.xyz;
  }
  o0.xyzw = r9.xyzw;
  o1.w = r9.w;
  o1.xyz = r8.xyz;
  return;
}