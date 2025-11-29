// ---- Created with 3Dmigoto v1.4.1 on Wed Oct 15 23:41:00 2025

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
}

cbuffer static_globals : register(b1)
{
  row_major float3x4 m_V : packoffset(c0);
  row_major float3x4 m_inv_V : packoffset(c3);
  row_major float4x4 m_P : packoffset(c6);
  row_major float4x4 m_VP : packoffset(c10);
  float4 timers : packoffset(c14);
  float4 fog_plane : packoffset(c15);
  float4 fog_params : packoffset(c16);
  float4 fog_color : packoffset(c17);
  float4 L_ambient : packoffset(c18);
  float3 L_sun_color : packoffset(c19);
  float3 L_sun_dir_w : packoffset(c20);
  float4 L_hemi_color : packoffset(c21);
  float3 eye_position : packoffset(c22);
  float4 pos_decompression_params : packoffset(c23);
  float4 screen_res : packoffset(c24);
  float3 L_sun_dir_e : packoffset(c25);
  float4 parallax : packoffset(c26);
  float4 rain_params : packoffset(c27);
  float4 pp_img_corrections : packoffset(c28);
  float4 pp_img_cg : packoffset(c29);
  float4 actor_data : packoffset(c30);
}

SamplerState smp_nofilter_s : register(s0);
SamplerState smp_linear_s : register(s1);
Texture2D<float4> s_position : register(t0);
Texture2D<float4> noise_tex : register(t1);
Texture2D<float4> s_vollight : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = s_vollight.SampleLevel(smp_linear_s, v0.xy, 0).xyz;
  r0.w = s_position.Sample(smp_nofilter_s, v0.xy).z;
  r1.xy = float2(256,256) / screen_res.xy;
  r1.xy = v0.xy / r1.xy;
  r1.x = noise_tex.Sample(smp_linear_s, r1.xy).x;
  r0.xyz = saturate(-r1.xxx * float3(0.00999999978,0.00999999978,0.00999999978) + r0.xyz);
  r1.x = cmp(r0.w < 0.00100000005);
  r0.w = saturate(1.5 * r0.w);
  r0.w = r1.x ? 1 : r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.w = log2(v0.w);
  r0.w = 2.20000005 * r0.w;
  r0.w = exp2(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = log2(r0.xyz);
  r1.xyz = float3(0.454545438,0.454545438,0.454545438) * r0.xyz;
  r1.xyz = exp2(r1.xyz);
  // Force HDR path
  r0.w = 1;
  if (r0.w != 0) {
    r2.xyz = float3(0.111111112,0.111111112,0.111111112) * r1.xyz;
    r3.xyz = r1.xyz;
  } else {
    r0.xyz = float3(1,1,1) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r4.xyz = float3(1,1,1) + r0.xyz;
    r0.xyz = r0.xyz / r4.xyz;
    r0.xyz = float3(1.08928573,1.08928573,1.08928573) * r0.xyz;
    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(0.454545438,0.454545438,0.454545438) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r3.xyz = min(float3(1,1,1), r0.xyz);
    r2.xyz = float3(0.111111112,0.111111112,0.111111112) * r1.xyz;
  }
  o0.xyz = r3.xyz;
  o0.w = 0;
  o1.xyz = r2.xyz;
  o1.w = 0;
  return;
}