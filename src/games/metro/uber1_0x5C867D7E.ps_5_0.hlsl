#include "./common.hlsl"
//#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Aug 29 12:09:45 2024

cbuffer cb_screen : register(b2)
{
  float4 rtdim : packoffset(c0);
  float4 depth_xform : packoffset(c1);
  float4 envmap_color : packoffset(c2);
  float4 sph_r[3] : packoffset(c3);
  float4 sph_g[3] : packoffset(c6);
  float4 sph_b[3] : packoffset(c9);
}

cbuffer cb_misc_0 : register(b3)
{
  float4 fog_color : packoffset(c0);
  float4 fog_height : packoffset(c1);
  float4 sky_color : packoffset(c2);
  float4 clouds_dir : packoffset(c3);
  float4 ambient : packoffset(c4);
  float4 pp_dof : packoffset(c5);
  float4 pp_gasmask : packoffset(c6);
  float4 pp_gasmask_c : packoffset(c7);
  float4 g_color : packoffset(c8);
  row_major float4x4 m_screen : packoffset(c9);
  float4 ddof_params : packoffset(c13);
  float4 gi_bbox[3] : packoffset(c14);
}

SamplerState s_clamp_tri_s : register(s5);
SamplerState s_clamp_bi_s : register(s6);
Texture2D<float4> t_dudv : register(t0);
Texture2D<float4> t_position : register(t1);
Texture2D<float4> t_accum : register(t2);
Texture2D<float4> t_bloom : register(t3);
Texture2D<float4> t_bloom_n : register(t4);
Texture2D<float4> t_bloom_b : register(t5);
Texture2D<float4> t_image_nomsaa_srcdof : register(t6);
Texture3D<float4> t_grade : register(t7);
Texture2D<float4> t_lensdirt : register(t8);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float3 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = rtdim.xy * v0.xy;
  r1.xyzw = rtdim.xyxy * float4(-0.400000006,0.800000012,0.800000012,0.400000006) + r0.xyxy;
  r2.xyz = t_accum.Sample(s_clamp_bi_s, r1.xy).xyz;
  r1.xyz = t_accum.Sample(s_clamp_bi_s, r1.zw).xyz;
  r0.zw = r2.xy + r1.xy;
  r1.x = min(r2.z, r1.z);
  r2.xyzw = rtdim.xyxy * float4(0.400000006,-0.800000012,-0.800000012,-0.400000006) + r0.xyxy;
  r1.yzw = t_accum.Sample(s_clamp_bi_s, r2.xy).xyz;
  r2.xyz = t_accum.Sample(s_clamp_bi_s, r2.zw).xyz;
  r0.zw = r1.yz + r0.zw;
  r1.x = min(r1.x, r1.w);
  r1.x = min(r1.x, r2.z);
  r0.zw = r0.zw + r2.xy;
  r0.zw = float2(0.25,0.25) * r0.zw;
  r1.y = dot(r0.zw, r0.zw);
  r1.y = sqrt(r1.y);
  r1.y = 9.99999975e-06 + r1.y;
  r1.y = 0.00282842712 / r1.y;
  r1.y = min(1, r1.y);
  r2.yz = r1.yy * r0.zw;
  r0.z = rtdim.x / rtdim.y;
  r2.x = r2.y * r0.z;
  r3.xyzw = float4(-4,-4,-3,-3) * r2.xzxz;
  r4.xyzw = rtdim.xyxy * float4(-1.3125,0.1875,-0.9375,-0.9375) + -r3.xyzw;
  r5.xy = (int2)v0.xy;
  r5.zw = float2(0,0);
  r0.w = t_position.Load(r5.xyw).z;
  r1.yz = t_dudv.Load(r5.xyz).xy;
  r5.xy = r1.yz * float2(0.0350000001,0.0350000001) + r0.xy;
  r0.xy = saturate(r0.ww * pp_dof.wz + -pp_dof.xy);
  r0.w = cmp(1024 < r0.w);
  r0.x = 1 + -r0.x;
  r0.x = -r0.y + r0.x;
  r6.xyzw = t_bloom.Sample(s_clamp_bi_s, r5.xy).xyzw;
  r6.xyzw = r6.xyzw + r6.xyzw;
  r0.x = r0.w ? -r6.w : r0.x;
  r0.x = saturate(-r0.x);
  r7.xyzw = t_bloom_n.Sample(s_clamp_bi_s, r5.xy).xyzw;
  r0.y = saturate(3 * r7.w);
  r7.xyzw = r7.xyzw + r7.xyzw;
  r0.w = max(r0.x, r0.y);
  r3.xyzw = r0.wwww * r4.xyzw + r3.xyzw;
  r3.xyzw = r5.xyxy + r3.xyzw;
  r4.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r3.zw).xyzw;
  r3.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r3.xy).xyzw;

  //r4.w = saturate(r4.w);
  //r3.w = saturate(r4.w);

  r1.y = -r4.w + r1.x;
  r1.y = max(0, r1.y);
  r1.y = r1.y * 3 + 1;
  r1.y = 1 / r1.y;
  r4.xyz = r4.xyz * r1.yyy;
  r1.z = -r3.w + r1.x;
  r1.z = max(0, r1.z);
  r1.z = r1.z * 3 + 1;
  r1.z = 1 / r1.z;
  r3.xyz = r3.xyz * r1.zzz + r4.xyz;
  r1.y = r1.z + r1.y;
  r4.xyzw = float4(-2,-2,3,3) * r2.xzxz;
  r1.zw = rtdim.xy * float2(-0.5625,0.9375) + -r4.xy;
  r1.zw = r0.ww * r1.zw + r4.xy;
  r1.zw = r5.xy + r1.zw;
  r8.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r1.zw).xyzw;

  //r8.w = saturate(r8.w);

  r1.z = -r8.w + r1.x;
  r1.z = max(0, r1.z);
  r1.z = r1.z * 3 + 1;
  r1.z = 1 / r1.z;
  r3.xyz = r8.xyz * r1.zzz + r3.xyz;
  r1.y = r1.y + r1.z;
  r1.zw = rtdim.xy * float2(-0.1875,-0.5625) + r2.xz;
  r1.zw = r0.ww * r1.zw + -r2.xz;
  r1.zw = r5.xy + r1.zw;
  r8.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r1.zw).xyzw;

  //r8.w = saturate(r8.w);

  r1.z = -r8.w + r1.x;
  r1.z = max(0, r1.z);
  r1.z = r1.z * 3 + 1;
  r1.z = 1 / r1.z;
  r3.xyz = r8.xyz * r1.zzz + r3.xyz;
  r1.y = r1.y + r1.z;
  r1.zw = rtdim.xy * r0.ww;
  r1.zw = r1.zw * float2(0.1875,0.5625) + r5.xy;
  r8.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r1.zw).xyzw;

 // r8.w = saturate(r8.w);

  r1.z = -r8.w + r1.x;
  r1.z = max(0, r1.z);
  r1.z = r1.z * 3 + 1;
  r1.z = 1 / r1.z;
  r3.xyz = r8.xyz * r1.zzz + r3.xyz;
  r1.y = r1.y + r1.z;
  r1.zw = rtdim.xy * float2(0.5625,-1.3125) + -r2.xz;
  r1.zw = r0.ww * r1.zw + r2.xz;
  r2.xy = r2.xz + r2.xz;
  r1.zw = r5.xy + r1.zw;
  r8.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r1.zw).xyzw;

  //r8.w = saturate(r8.w);

  r1.z = -r8.w + r1.x;
  r1.z = max(0, r1.z);
  r1.z = r1.z * 3 + 1;
  r1.z = 1 / r1.z;
  r3.xyz = r8.xyz * r1.zzz + r3.xyz;
  r1.y = r1.y + r1.z;
  r1.zw = rtdim.xy * float2(0.9375,-0.1875) + -r2.xy;
  r1.zw = r0.ww * r1.zw + r2.xy;
  r1.zw = r5.xy + r1.zw;
  r2.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r1.zw).xyzw;

  //r2.w = saturate(r2.w);

  r1.z = -r2.w + r1.x;
  r1.z = max(0, r1.z);
  r1.z = r1.z * 3 + 1;
  r1.z = 1 / r1.z;
  r2.xyz = r2.xyz * r1.zzz + r3.xyz;
  r1.y = r1.y + r1.z;
  r1.zw = rtdim.xy * float2(1.3125,1.3125) + -r4.zw;
  r1.zw = r0.ww * r1.zw + r4.zw;
  r1.zw = r5.xy + r1.zw;
  r3.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r1.zw).xyzw;

  //r3.w = saturate(r3.w);

  r0.w = -r3.w + r1.x;
  r0.w = max(0, r0.w);
  r0.w = r0.w * 3 + 1;
  r0.w = 1 / r0.w;
  r1.xzw = r3.xyz * r0.www + r2.xyz;
  r0.w = r1.y + r0.w;
  r1.xyz = r1.xzw / r0.www;
  r0.w = max(9.99999975e-05, abs(r6.w));
  r2.xyz = r6.xyz / r0.www;
  r2.xyz = r2.xyz + -r1.xyz;
  r1.xyz = r0.xxx * r2.xyz + r1.xyz;
  r0.x = max(9.99999975e-05, r7.w);
  r2.xyz = r7.xyz / r0.xxx;
  r2.xyz = r2.xyz + -r1.xyz;
  r0.xyw = r0.yyy * r2.xyz + r1.xyz;
  r1.x = -0.5 + r5.y;
  r5.z = r1.x * r0.z + 0.5;
  r1.xyzw = t_lensdirt.Sample(s_clamp_tri_s, r5.xz).xyzw;
  r2.xyz = t_bloom_b.Sample(s_clamp_bi_s, r5.xy).xyz;
  r1.xyz = r1.xyz * r1.www;
  r1.xyz = float3(5,5,5) * r1.xyz;
  r0.z = pp_gasmask.w * 5 + 1;
  r1.xyz = r1.xyz * r0.zzz + float3(1,1,1);

  //r1.xyz *= CUSTOM_LENS_DIRT;
  //r2.xyz *= CUSTOM_BLOOM_STRENGTH;

  r0.xyz = r2.xyz * r1.xyz + r0.xyw;

  float3 untonemapped = r0.rgb;
  
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = float3(0.125, 0.125, 0.125) * r1.xyz;
  r2.xyz = r0.xyz * float3(0.150000006,0.150000006,0.150000006) + float3(0.0500000007,0.0500000007,0.0500000007);
  r2.xyz = r0.xyz * r2.xyz + float3(0.00400000019,0.00400000019,0.00400000019);
  r3.xyz = r0.xyz * float3(0.150000006,0.150000006,0.150000006) + float3(0.5,0.5,0.5);
  r0.xyz = r0.xyz * r3.xyz + float3(0.0600000024,0.0600000024,0.0600000024);
  r0.xyz = r2.xyz / r0.xyz;
  r0.xyz = float3(-0.0666666627,-0.0666666627,-0.0666666627) + r0.xyz;
  r0.xyz = r0.xyz * float3(4.53191471, 4.53191471, 4.53191471) + r1.xyz;

  // float3 tonemapped_bt709 = r0.rgb;
  // r0.rgb = CustomTonemap(untonemapped, tonemapped_bt709);

  float3 ungraded_color = r0.rgb;

  r1.xyz = t_grade.Sample(s_clamp_bi_s, r0.zyx).xyz;
  //r0.xyz = saturate(r0.xyz);
  r0.xyz = r1.zyx * float3(2,2,2) + r0.xyz;
  r0.xyz = float3(-1,-1,-1) + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  o0.xyz = r0.xyz;
  o0.w = sqrt(r0.w);

  float3 tonemapped_bt709 = o0.rgb;
  o0.rgb = CustomTonemap(untonemapped, tonemapped_bt709);

  //o0.rgb = lerp(ungraded_color, o0.rgb, CUSTOM_COLOR_GRADE_TWO);
  //o0.rgb = CustomPostProcessing(o0.rgb, r1.xy);
  //o0.rgb = CustomIntermediatePass(o0.rgb);
  //o0.w = saturate(o0.w);
  return;
}