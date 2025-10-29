// ---- Created with 3Dmigoto v1.4.1 on Sat Oct 18 16:53:51 2025

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
  float4 taa_setup : packoffset(c20);
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

SamplerState smp_point_s : register(s0);
Texture2D<float4> s_current : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = screen_res.zwzw * float4(0.5,-0.5,0.5,0.5) + v1.xyxy;
  r1.xyz = s_current.Sample(smp_point_s, r0.xy).xyz;
  r0.xyz = s_current.Sample(smp_point_s, r0.zw).xyz;
  r2.xyzw = -screen_res.zwzw * float4(0.5,0.5,0.5,-0.5) + v1.xyxy;
  r3.xyz = s_current.Sample(smp_point_s, r2.xy).xyz;
  r2.xyz = s_current.Sample(smp_point_s, r2.zw).xyz;
  r1.xyz = r3.xyz + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = r0.xyz + r2.xyz;
  r1.xyz = s_current.Sample(smp_point_s, v1.xy).xyz;
  r0.xyz = -r0.xyz * float3(0.25,0.25,0.25) + r1.xyz;
  r0.w = 1;
  r2.xyz = float3(3.03714275,10.2171431,1.03142858) * taa_setup.zzz;
  r2.w = 0.5;
  r0.x = dot(r0.xyzw, r2.xyzw);
  r0.x = r0.x * 0.0700000003 + -0.0350000001;
  o0.xyz = max(r1.xyz + r0.xxx, float3(0.0, 0.0, 0.0));
  o0.w = 1;
  return;
}