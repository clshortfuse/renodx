#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Aug 29 12:45:15 2024

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

SamplerState s_wrap_tri_s : register(s2);
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
Texture2D<float4> t_gm_base : register(t9);
Texture2D<float4> t_gm_dist : register(t10);


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

  float2 coords = r0.xy;

  r0.zw = float2(5,3) * r0.xy;
  r1.xyz = t_gm_dist.Sample(s_wrap_tri_s, r0.zw).xyw;
  r0.z = r1.z * 2 + pp_gasmask.w;
  r1.xy = float2(-0.501960814,-0.501960814) + r1.xy;
  r0.z = -1 + r0.z;
  r0.w = -3 + pp_gasmask.w;
  r2.xyz = t_gm_base.Sample(s_clamp_tri_s, r0.xy).xyw;
  r0.w = r2.z * r0.w;
  r0.z = r0.w * r0.z;
  r0.w = r2.z * 2 + -1;
  r0.z = saturate(r0.z * r0.w);
  r3.xyz = float3(1.89999998,-0.501960814,-0.501960814) + r2.zxy;
  r1.xy = -r3.yz * float2(0.100000001,0.100000001) + r1.xy;
  r1.zw = float2(0.100000001,0.100000001) * r3.yz;
  r0.w = r3.x + -r2.x;
  r0.w = r0.w + -r2.y;
  r0.w = saturate(10 * r0.w);
  r1.xy = r0.zz * r1.xy + r1.zw;
  r0.zw = r1.xy * r0.ww;
  r1.xy = (int2)v0.xy;
  r1.zw = float2(0,0);
  r3.xy = t_dudv.Load(r1.xyz).xy;
  r1.x = t_position.Load(r1.xyw).z;
  r0.zw = r3.xy * float2(0.0350000001,0.0350000001) + r0.zw;
  r3.xy = v0.xy * rtdim.xy + r0.zw;
  r0.zw = saturate(r1.xx * pp_dof.wz + -pp_dof.xy);
  r1.x = cmp(1024 < r1.x);
  r0.z = 1 + -r0.z;
  r0.z = -r0.w + r0.z;
  r4.xyzw = t_bloom.Sample(s_clamp_bi_s, r3.xy).xyzw;
  r4.xyzw = r4.xyzw + r4.xyzw;
  r0.z = r1.x ? -r4.w : r0.z;
  r0.z = saturate(-r0.z);
  r1.xyzw = t_bloom_n.Sample(s_clamp_bi_s, r3.xy).xyzw;
  r0.w = saturate(3 * r1.w);
  r1.xyzw = r1.xyzw + r1.xyzw;
  r2.w = max(r0.z, r0.w);
  r5.xyzw = rtdim.xyxy * float4(-0.400000006,0.800000012,0.800000012,0.400000006) + r0.xyxy;
  r6.xyzw = rtdim.xyxy * float4(0.400000006,-0.800000012,-0.800000012,-0.400000006) + r0.xyxy;
  r7.xyz = t_accum.Sample(s_clamp_bi_s, r5.xy).xyz;
  r5.xyz = t_accum.Sample(s_clamp_bi_s, r5.zw).xyz;
  r0.xy = r7.xy + r5.xy;
  r3.w = min(r7.z, r5.z);
  r5.xyz = t_accum.Sample(s_clamp_bi_s, r6.xy).xyz;
  r6.xyz = t_accum.Sample(s_clamp_bi_s, r6.zw).xyz;
  r0.xy = r5.xy + r0.xy;
  r3.w = min(r5.z, r3.w);
  r3.w = min(r3.w, r6.z);
  r0.xy = r0.xy + r6.xy;
  r0.xy = float2(0.25,0.25) * r0.xy;
  r5.x = dot(r0.xy, r0.xy);
  r5.x = sqrt(r5.x);
  r5.x = 9.99999975e-06 + r5.x;
  r5.x = 0.00282842712 / r5.x;
  r5.x = min(1, r5.x);
  r5.yz = r5.xx * r0.xy;
  r0.x = rtdim.x / rtdim.y;
  r5.x = r5.y * r0.x;
  r6.xyzw = float4(-4,-4,-3,-3) * r5.xzxz;
  r7.xyzw = rtdim.xyxy * float4(-1.3125,0.1875,-0.9375,-0.9375) + -r6.xyzw;
  r6.xyzw = r2.wwww * r7.xyzw + r6.xyzw;
  r6.xyzw = r6.xyzw + r3.xyxy;
  r7.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r6.zw).xyzw;
  r6.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r6.xy).xyzw;

  //r7.w = saturate(r7.w);
  //r6.w = saturate(r6.w);

  r0.y = -r7.w + r3.w;
  r0.y = max(0, r0.y);
  r0.y = r0.y * 3 + 1;
  r0.y = 1 / r0.y;
  r7.xyz = r7.xyz * r0.yyy;
  r5.y = -r6.w + r3.w;
  r5.y = max(0, r5.y);
  r5.y = r5.y * 3 + 1;
  r5.y = 1 / r5.y;
  r6.xyz = r6.xyz * r5.yyy + r7.xyz;
  r0.y = r5.y + r0.y;
  r7.xyzw = float4(-2,-2,3,3) * r5.xzxz;
  r5.yw = rtdim.xy * float2(-0.5625,0.9375) + -r7.xy;
  r5.yw = r2.ww * r5.yw + r7.xy;
  r5.yw = r5.yw + r3.xy;
  r8.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r5.yw).xyzw;

  //r8.w = saturate(r8.w);

  r5.y = -r8.w + r3.w;
  r5.y = max(0, r5.y);
  r5.y = r5.y * 3 + 1;
  r5.y = 1 / r5.y;
  r6.xyz = r8.xyz * r5.yyy + r6.xyz;
  r0.y = r5.y + r0.y;
  r5.yw = rtdim.xy * float2(-0.1875,-0.5625) + r5.xz;
  r5.yw = r2.ww * r5.yw + -r5.xz;
  r5.yw = r5.yw + r3.xy;
  r8.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r5.yw).xyzw;

  //r8.w = saturate(r8.w);

  r5.y = -r8.w + r3.w;
  r5.y = max(0, r5.y);
  r5.y = r5.y * 3 + 1;
  r5.y = 1 / r5.y;
  r6.xyz = r8.xyz * r5.yyy + r6.xyz;
  r0.y = r5.y + r0.y;
  r5.yw = rtdim.xy * r2.ww;
  r5.yw = r5.yw * float2(0.1875,0.5625) + r3.xy;
  r8.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r5.yw).xyzw;

  //r8.w = saturate(r8.w);

  r5.y = -r8.w + r3.w;
  r5.y = max(0, r5.y);
  r5.y = r5.y * 3 + 1;
  r5.y = 1 / r5.y;
  r6.xyz = r8.xyz * r5.yyy + r6.xyz;
  r0.y = r5.y + r0.y;
  r5.yw = rtdim.xy * float2(0.5625,-1.3125) + -r5.xz;
  r5.yw = r2.ww * r5.yw + r5.xz;
  r5.xz = r5.xz + r5.xz;
  r5.yw = r5.yw + r3.xy;
  r8.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r5.yw).xyzw;

  //r8.w = saturate(r8.w);

  r5.y = -r8.w + r3.w;
  r5.y = max(0, r5.y);
  r5.y = r5.y * 3 + 1;
  r5.y = 1 / r5.y;
  r6.xyz = r8.xyz * r5.yyy + r6.xyz;
  r0.y = r5.y + r0.y;
  r5.yw = rtdim.xy * float2(0.9375,-0.1875) + -r5.xz;
  r5.xy = r2.ww * r5.yw + r5.xz;
  r5.xy = r5.xy + r3.xy;
  r5.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r5.xy).xyzw;

  //r5.w = saturate(r5.w);

  r5.w = -r5.w + r3.w;
  r5.w = max(0, r5.w);
  r5.w = r5.w * 3 + 1;
  r5.w = 1 / r5.w;
  r5.xyz = r5.xyz * r5.www + r6.xyz;
  r0.y = r5.w + r0.y;
  r6.xy = rtdim.xy * float2(1.3125,1.3125) + -r7.zw;
  r6.xy = r2.ww * r6.xy + r7.zw;
  r6.xy = r6.xy + r3.xy;
  r6.xyzw = t_image_nomsaa_srcdof.Sample(s_clamp_bi_s, r6.xy).xyzw;

 // r6.w = saturate(r6.w);

  r2.w = -r6.w + r3.w;
  r2.w = max(0, r2.w);
  r2.w = r2.w * 3 + 1;
  r2.w = 1 / r2.w;
  r5.xyz = r6.xyz * r2.www + r5.xyz;
  r0.y = r2.w + r0.y;
  r5.xyz = r5.xyz / r0.yyy;
  r0.y = max(9.99999975e-05, abs(r4.w));
  r4.xyz = r4.xyz / r0.yyy;
  r4.xyz = r4.xyz + -r5.xyz;
  r4.xyz = r0.zzz * r4.xyz + r5.xyz;
  r0.y = max(9.99999975e-05, r1.w);
  r1.xyz = r1.xyz / r0.yyy;
  r1.xyz = r1.xyz + -r4.xyz;
  r0.yzw = r0.www * r1.xyz + r4.xyz;
  r1.x = -0.5 + r3.y;
  r3.z = r1.x * r0.x + 0.5;
  r1.xyzw = t_lensdirt.Sample(s_clamp_tri_s, r3.xz).xyzw;
  r3.xyz = t_bloom_b.Sample(s_clamp_bi_s, r3.xy).xyz;

  r1.xyz *= CUSTOM_LENS_DIRT;
  r3.xyz *= CUSTOM_BLOOM_STRENGTH;

  r1.xyz = r1.xyz * r1.www;
  r1.xyz = float3(5,5,5) * r1.xyz;
  r0.x = pp_gasmask.w * 5 + 1;
  r1.xyz = r1.xyz * r0.xxx + float3(1,1,1);
  r0.xyz = r3.xyz * r1.xyz + r0.yzw;

  float3 untonemapped = renodx::color::srgb::DecodeSafe(r0.xyz);

  // r1.xyz = r3.xyz * r1.xyz;
  // r1.xyz = float3(0.125,0.125,0.125) * r1.xyz;
  // r3.xyz = r0.xyz * float3(0.150000006,0.150000006,0.150000006) + float3(0.0500000007,0.0500000007,0.0500000007);
  // r3.xyz = r0.xyz * r3.xyz + float3(0.00400000019,0.00400000019,0.00400000019);
  // r4.xyz = r0.xyz * float3(0.150000006,0.150000006,0.150000006) + float3(0.5,0.5,0.5);
  // r0.xyz = r0.xyz * r4.xyz + float3(0.0600000024,0.0600000024,0.0600000024);
  // r0.xyz = r3.xyz / r0.xyz;
  // r0.xyz = float3(-0.0666666627,-0.0666666627,-0.0666666627) + r0.xyz;
  // r0.xyz = r0.xyz * float3(4.53191471,4.53191471,4.53191471) + r1.xyz;

  float3 tonemapped_bt709 = renodx::tonemap::uncharted2::BT709(untonemapped, 1);

  float midgray = renodx::tonemap::uncharted2::BT709(0.18f, 1);
  midgray /= 0.18;
  untonemapped *= midgray;

  float3 tonemapped_hdr = CustomUpgradeTonemap(untonemapped, tonemapped_bt709, RENODX_COLOR_GRADE_STRENGTH);
  r0.xyz = renodx::color::srgb::EncodeSafe(tonemapped_hdr);

  r1.xy = float2(-0.5,-0.5) + r2.xy;
  r0.w = r2.z * r2.z;
  r1.z = 1;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);

  r1.xyz = r1.xyz * r1.www;
  r1.x = dot(-pp_gasmask.xyz, r1.xyz);
  r1.x = r1.x * 0.5 + 0.5;
  r1.x = r1.x * r1.x;
  r1.x = max(0.100000001, r1.x);
  r1.xyz = pp_gasmask_c.xyz * r1.xxx;
  r0.xyz = r0.www * r1.xyz + r0.xyz;

  float3 ungraded_color = renodx::color::srgb::DecodeSafe(r0.xyz);
  float3 ungraded_sdr = CustomTonemapSDR(ungraded_color);
  r0.rgb = renodx::color::srgb::EncodeSafe(ungraded_sdr);

  r1.xyz = t_grade.Sample(s_clamp_bi_s, r0.zyx).xyz;
  // r0.xyz = saturate(r0.xyz);
  r0.xyz = r1.zyx * float3(2,2,2) + r0.xyz;
  r0.xyz = float3(-1,-1,-1) + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  o0.xyz = r0.xyz;
  o0.w = sqrt(r0.w);

  float3 graded_color = renodx::color::srgb::DecodeSafe(o0.rgb);
  float3 outputColor = CustomUpgradeGrading(ungraded_color, ungraded_sdr, graded_color, CUSTOM_COLOR_GRADE_TWO);
  outputColor = CustomTonemap(outputColor, graded_color);
  outputColor = CustomPostProcessing(outputColor, coords);
  outputColor = CustomIntermediatePass(outputColor);

  o0.rgb = outputColor;
  //o0.w = saturate(o0.w);
  return;
}