// ---- Created with 3Dmigoto v1.4.1 on Tue Oct 14 22:05:53 2025

#include "./shared.h"

struct exposure_state_sb_data
{
    float exposure;                // Offset:    0
    float exposure_rcp;            // Offset:    4
    float2 exposure_state_padding; // Offset:    8
};

cbuffer post_process_cb_data : register(b0)
{
  float2 scene_texel_size : packoffset(c0);
  float bloom_strength : packoffset(c0.z);
  float time : packoffset(c0.w);
}

cbuffer ExFeaturesCB : register(b9)
{
  uint g_toon_enabled : packoffset(c0);
  uint g_retro_enabled : packoffset(c0.y);
  uint g_liq_crys_enabled : packoffset(c0.z);
  float3 g_pad : packoffset(c1);
}

SamplerState LinearClampSampler_s : register(s0);
Texture2D<float3> scene_texture_in : register(t0);
Texture2D<float3> refraction_texture : register(t1);
Texture2D<float3> bloom_texture : register(t2);
StructuredBuffer<exposure_state_sb_data> exposure_texture : register(t3);
RWTexture2D<float3> scene_texture_out : register(u0);


// 3Dmigoto declarations
#define cmp -

[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;
  r0.xy = (uint2)vThreadID.xy;
  r0.xz = float2(0.5,0.5) + r0.xy;
  r1.xy = scene_texel_size.xy * r0.xz;
  r1.zw = cmp(g_liq_crys_enabled == uint2(1,1));
  r0.w = (int)r1.w | (int)r1.z;
  r0.y = 3.14159012 * r0.y;
  r0.y = sin(r0.y);
  if (r0.w != 0) {
    // Pixelated low-res sampling
    r2.xy = float2(640,480) * r1.xy;
    r2.xy = floor(r2.xy);
    r2.xy = float2(0.00156250002,0.00208333344) * r2.xy;
    r2.xyz = scene_texture_in.SampleLevel(LinearClampSampler_s, r2.xy, 0).xyz;
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(0.545454562,0.545454562,0.545454562) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r3.xy = (int2)vThreadID.xy & int2(1,1);
    r0.w = (int)r3.y ^ (int)r3.x;
    r0.w = r0.w ? 0.0199999996 : -0.0199999996;
    r2.xyz = r2.xyz + r0.www;
    r3.xyz = float3(6,6,6) * r2.xyz;
    r3.xyz = floor(r3.xyz);
    r3.xyz = r3.xyz * float3(0.166666672,0.166666672,0.166666672) + -r2.xyz;
    r2.xyz = r3.xyz * float3(0.800000012,0.800000012,0.800000012) + r2.xyz;
    r2.xyz = float3(4.5,4.5,4.5) * r2.xyz;
  } else {
    r1.xy = refraction_texture.SampleLevel(LinearClampSampler_s, r1.xy, 0).xy;
    r0.xz = r0.xz * scene_texel_size.xy + r1.xy;
    r1.xyw = scene_texture_in.SampleLevel(LinearClampSampler_s, r0.xz, 0).xyz;
    r0.xzw = bloom_texture.SampleLevel(LinearClampSampler_s, r0.xz, 0).xyz;
    r0.xzw = bloom_strength * r0.xzw + r1.xyw;
    r1.x = exposure_texture[0].exposure;
    r0.xzw = r1.xxx * r0.xzw;
    // Tone mapping (custom curve)
    r1.xyw = sqrt(r0.xzw);  
    r3.xyz = r1.xyw * r0.xzw;
    r0.xzw = r0.xzw * r1.xyw + float3(0.384900182,0.384900182,0.384900182);
    r0.xzw = (r3.xyz / r0.xzw);
    r0.xzw = log2(r0.xzw);
    r0.xzw = float3(0.952380955,0.952380955,0.952380955) * r0.xzw;
    r2.xyz = exp2(r0.xzw);
  }
  r0.x = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
  r3.xyzw = float4(0.19250001,0.952499986,0.24000001,0.19250001) * r0.xxxx;
  r0.x = r0.y * 0.150000006 + 0.850000024;
  r0.xyzw = r3.xyzw * r0.xxxx;
  r0.xyzw = max(float4(0,0,0,0), float4(1.20000005, 1.20000005, 1.20000005, 1.20000005) * r0.xyzw); // Remove SDR clamp, allow HDR
  r0.xyzw = r1.zzzz ? r0.xyzw : r2.xyzx;  // Choose LCD effect or normal rendering
  scene_texture_out[vThreadID.xy] = r0.xyz;
  return;
}