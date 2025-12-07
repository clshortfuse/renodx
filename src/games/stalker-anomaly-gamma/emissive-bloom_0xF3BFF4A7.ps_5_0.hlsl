// ---- Created with 3Dmigoto v1.4.1 on Wed Oct 15 22:09:27 2025

cbuffer _Globals : register(b0)
{
  float4 hdr10_parameters1 : packoffset(c0);
  float4 hdr10_parameters2 : packoffset(c1);
  float4 hdr10_parameters3 : packoffset(c2);
  float4 hdr10_parameters4 : packoffset(c3);
  float4 hdr10_parameters5 : packoffset(c4);
  float4 hdr10_parameters6 : packoffset(c5);
  float4 hdr10_parameters7 : packoffset(c6);
  float4 hdr10_parameters8 : packoffset(c7);
  float4 hdr10_parameters9 : packoffset(c8);
  float4 hdr10_parameters10 : packoffset(c9);
  row_major float4x4 m_wvp_prev : packoffset(c10);
  row_major float4x4 m_vp_prev : packoffset(c14);
  float4 ssfx_jitter : packoffset(c18);
  float4 L_hotness : packoffset(c19);
  float4 ssfx_florafixes_1 : packoffset(c20);
  float4 ssfx_florafixes_2 : packoffset(c21);
  float4 ssfx_lightsetup_1 : packoffset(c22);
  float4 env_color : packoffset(c23);
  float4 hmodel_stuff : packoffset(c24);
  float4 sky_color : packoffset(c25);
  float4 ssfx_bloom_1 : packoffset(c26);
}

SamplerState smp_nofilter_s : register(s0);
SamplerState smp_linear_s : register(s1);
Texture2D<float4> s_position : register(t0);
Texture2D<float4> s_scene : register(t1);
Texture2D<float4> s_emissive : register(t2);
Texture2D<float4> s_hud_mask : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = s_position.Sample(smp_nofilter_s, v1.xy).z;
  r0.x = cmp(0.00100000005 >= r0.x);
  r0.x = r0.x ? ssfx_bloom_1.w : 1;
  r0.yzw = s_scene.SampleLevel(smp_linear_s, v1.xy, 0).xyz;
  r0.xyz = r0.yzw * r0.xxx;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = ssfx_bloom_1.xxx * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.w = s_hud_mask.SampleLevel(smp_linear_s, v1.xy, 0).z;
  r0.w = cmp(0.100000001 < r0.w);
  r0.w = r0.w ? 0.25 : 1;
  r1.xyz = s_emissive.SampleLevel(smp_linear_s, v1.xy, 0).xyz;
  o0.xyz = r1.xyz * r0.www + r0.xyz;
  r0.xyz = r1.xyz * r0.www;
  o0.w = dot(r0.xyz, float3(1,1,1));
  return;
}