// ---- Created with 3Dmigoto v1.4.1 on Wed Oct 15 22:09:27 2025

cbuffer static_globals : register(b0)
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
SamplerState smp_rtlinear_s : register(s1);
SamplerState smp_base_s : register(s2);
Texture2D<float4> s_base : register(t0);
Texture2D<float4> s_accumulator : register(t1);
TextureCube<float4> s_env : register(t2);
Texture2D<float4> s_glass : register(t3);
Texture2D<float4> s_screen : register(t4);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v1 : TEXCOORD0,
  float w1 : FOG0,
  float3 v2 : TEXCOORD1,
  float4 v3 : SV_Position0,
  float4 v4 : TEXCOORD2,
  float3 v5 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0, 1.000000, 0},
                              { 0, 0, 0, 1.000000} };
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = ddx_coarse(v3.zxy);
  r1.xyz = ddy_coarse(v3.yzx);
  r2.xyz = r1.xyz * r0.xyz;
  r0.xyz = r0.zxy * r1.yzx + -r2.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = rsqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = cmp(abs(r0.yzz) < abs(r0.xxy));
  r0.x = r0.y ? r0.x : 0;
  r0.yz = r0.zz ? float2(2.80259693e-45,0) : float2(0,1.40129846e-45);
  r0.xy = r0.xx ? float2(1,2) : r0.yz;
  r1.x = dot(v3.xy, icb[r0.x+0].xy);
  r1.y = dot(v3.xy, icb[r0.y+0].xy);
  r0.xy = float2(0.5,0.5) * r1.xy;
  r0.xy = s_glass.Sample(smp_base_s, r0.xy).xy;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.z = dot(v4.xyz, v5.xyz);
  r0.z = r0.z + r0.z;
  r1.xyz = v5.xyz * -r0.zzz + v4.xyz;
  r0.z = saturate(dot(r1.xyz, v4.xyz));
  r0.w = r0.z * r0.z;
  r0.w = r0.w * r0.w;
  r0.z = r0.z * r0.w;
  r0.w = r0.z * 0.0500000007 + 0.00300000003;
  r1.x = r0.w / v3.w;
  r0.w = max(r1.x, r0.w);
  r0.xy = r0.xy * r0.ww;
  r0.xy = max(float2(-1,-1), r0.xy);
  r0.xy = min(float2(1,1), r0.xy);
  r1.xy = v3.xy / screen_res.xy;
  r1.zw = r1.xy + r0.xy;
  r2.y = s_screen.SampleLevel(smp_rtlinear_s, r1.zw, 0).y;
  r0.w = 1 / screen_res.x;
  r1.zw = r0.ww * float2(2,2) + r1.xy;
  r3.xy = -r0.ww * float2(2,2) + r1.xy;
  r0.w = s_accumulator.Sample(smp_nofilter_s, r1.xy).x;
  r0.w = saturate(2000 * r0.w);
  r0.z = r0.z * r0.w;
  r1.xy = r3.xy + r0.xy;
  r0.xy = r1.zw + r0.xy;
  r2.x = s_screen.SampleLevel(smp_rtlinear_s, r0.xy, 0).x;
  r2.z = s_screen.SampleLevel(smp_rtlinear_s, r1.xy, 0).z;
  r1.xyzw = s_base.Sample(smp_base_s, v1.xy).xyzw;
  r0.xyw = s_env.Sample(smp_rtlinear_s, v2.xyz).xyz;
  r1.xyz = r1.xyz + -r0.xyw;
  r0.xyw = r1.www * r1.xyz + r0.xyw;
  r0.xyw = saturate(float3(1.5,1.5,1.5) * r0.xyw);
  r1.xyz = r2.xyz * r0.xyw;
  r0.xyw = -r2.xyz * r0.xyw + r2.xyz;
  r1.w = 1 + -w1.x;
  r0.xyw = r1.www * r0.xyw + r1.xyz;
    o0.xyz = r0.zzz * float3(0.0899999961,0.100000001,0.0899999961) + r0.xyw;
  o0.w = w1.x * w1.x;
  return;
}