// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 17 19:55:43 2025

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
  float4 sun_shafts_intensity : packoffset(c20);
  float4 c_sunshafts : packoffset(c21);
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

SamplerState smp_rtlinear_s : register(s0);
Texture2D<float4> s_image : register(t0);
Texture2D<float4> s_sun_shafts : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -L_sun_dir_w.y * L_sun_dir_w.y + 1;
  r0.x = sqrt(r0.x);
  r0.x = 180 / r0.x;
  r0.xyz = r0.xxx * L_sun_dir_w.xyz + eye_position.xyz;
  r0.w = 1;
  r1.x = dot(m_VP._m00_m01_m02_m03, r0.xyzw);
  r1.y = dot(m_VP._m30_m31_m32_m33, r0.xyzw);
  r0.x = dot(m_VP._m10_m11_m12_m13, r0.xyzw);
  r0.x = r1.y + -r0.x;
  r0.y = r1.x + r1.y;
  r0.xy = float2(0.5,0.5) * r0.xy;
  r0.xy = r0.xy / r1.yy;
  r0.xy = -v0.yx + r0.xy;
  r0.z = dot(r0.xy, r0.xy);
  r0.z = rsqrt(r0.z);
  r0.xy = r0.xy * r0.zz;
  r0.zw = r0.xy * screen_res.zw + v0.xy;
  r0.xy = -r0.xy * screen_res.zw + v0.xy;
  r1.xyz = s_sun_shafts.Sample(smp_rtlinear_s, r0.xy).xyz;
  r0.xyz = s_sun_shafts.Sample(smp_rtlinear_s, r0.zw).xyz;
  r0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  r2.xyz = s_sun_shafts.Sample(smp_rtlinear_s, v0.xy).xyz;
  r0.xyz = r2.xyz * float3(0.5,0.5,0.5) + r0.xyz;
  r0.xyz = r1.xyz * float3(0.25,0.25,0.25) + r0.xyz;
  r0.xyz = L_sun_color.xyz * r0.xyz;
  r1.xyz = s_image.Sample(smp_rtlinear_s, v0.xy).xyz;
  r2.xyz = float3(1,1,1) + -r1.xyz;
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = sun_shafts_intensity.xyz * r0.xyz;
  r0.w = 10 * c_sunshafts.x;
  o0.xyz = r0.xyz * r0.www + r1.xyz;
  o0.w = 1;
  return;
}