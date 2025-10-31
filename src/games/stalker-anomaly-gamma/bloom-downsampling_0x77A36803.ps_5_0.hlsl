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
  float4 blur_setup : packoffset(c26);
}

SamplerState smp_rtlinear_s : register(s0);
Texture2D<float4> s_bloom : register(t0);
Texture2D<float4> s_downsample : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = s_bloom.Sample(smp_rtlinear_s, v1.xy).xyzw;
  r1.xy = float2(1,1) / blur_setup.xy;
  r2.xy = blur_setup.ww * r1.xy;
  r1.xy = -r1.xy * blur_setup.ww + v1.xy;
  r1.xyzw = s_bloom.Sample(smp_rtlinear_s, r1.xy).xyzw;
  r2.z = -r2.x;
  r3.xyzw = v1.xyxy + r2.zyxy;
  r4.xyzw = s_bloom.Sample(smp_rtlinear_s, r3.xy).xyzw;
  r3.xyzw = s_bloom.Sample(smp_rtlinear_s, r3.zw).xyzw;
  r2.w = 0;
  r5.xyzw = v1.xyxy + r2.wyxw;
  r6.xyzw = r2.xwwy * float4(-1,1,1,-1) + v1.xyxy;
  r2.xy = r2.xy * float2(1,-1) + v1.xy;
  r2.xyzw = s_bloom.Sample(smp_rtlinear_s, r2.xy).xyzw;
  r7.xyzw = s_bloom.Sample(smp_rtlinear_s, r5.xy).xyzw;
  r4.xyzw = r7.xyzw + r4.xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r4.xyzw = s_bloom.Sample(smp_rtlinear_s, r6.xy).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r3.xyzw = s_bloom.Sample(smp_rtlinear_s, r5.zw).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = s_bloom.Sample(smp_rtlinear_s, r6.zw).xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r2.xyzw;
  r1.xyzw = s_downsample.Sample(smp_rtlinear_s, r5.xy).xyzw;
  r2.xyzw = s_downsample.Sample(smp_rtlinear_s, r5.zw).xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = s_downsample.Sample(smp_rtlinear_s, r6.xy).xyzw;
  r3.xyzw = s_downsample.Sample(smp_rtlinear_s, r6.zw).xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r2.xyzw;
  r0.xyzw = r0.xyzw + r3.xyzw;
    o0.xyzw = float4(0.0769230798,0.0769230798,0.0769230798,0.0769230798) * r0.xyzw;
  return;
}