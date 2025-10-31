// ---- Created with 3Dmigoto v1.4.1 on Sun Oct 19 02:50:30 2025

#include "./shared.h"

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
  float4 shader_param_8 : packoffset(c20);
  float4 shader_param_7 : packoffset(c21);
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
Texture2D<float4> s_position : register(t0);
Texture2D<float4> s_image : register(t1);
Texture2D<float4> s_blur_2 : register(t2);
Texture2D<float4> s_blur_4 : register(t3);
Texture2D<float4> s_blur_8 : register(t4);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;
  const float3 NV_LUMA = float3(0.262700021, 0.677999973, 0.0593000054);
  const float3 NV_TINT = float3(0.5, 1.0, 0.400000006);
  float nvIntensity = 0.0;

  r0.x = -0.5 + v1.x;
  r0.y = screen_res.x / screen_res.y;
  r0.x = r0.x * r0.y + 0.5;
  r1.xyz = s_image.Sample(smp_rtlinear_s, v1.xy).xyz;
  r2.xyz = s_blur_2.Sample(smp_rtlinear_s, v1.xy).xyz;
  float3 sceneSample = r1.xyz;
  float3 blurSample = r2.xyz;
  r0.z = frac(shader_param_8.x);
  r0.w = floor(shader_param_7.x);
  r1.w = -r0.w * 0.0500000007 + 5;
  r1.w = max(1, r1.w);
  r1.w = min(5, r1.w);
  r0.y = v1.y * r1.w;
  r1.w = cmp(0.0989999995 < r0.z);
  r2.w = cmp(r0.z < 0.100999996);
  r1.w = r1.w ? r2.w : 0;
  if (r1.w != 0) {
    r3.y = r0.w * 0.00999999978 + -0.5;
    r3.x = 0.5;
    r3.xy = -r3.xy + r0.xy;
    r2.w = dot(r3.xy, r3.xy);
    r2.w = sqrt(r2.w);
    r3.x = frac(shader_param_7.y);
    r2.w = cmp(r3.x >= r2.w);
    r2.w = r2.w ? 1.000000 : 0;
  } else {
    r3.x = cmp(0.109000005 < r0.z);
    r3.y = cmp(r0.z < 0.111000001);
    r3.x = r3.y ? r3.x : 0;
    if (r3.x != 0) {
      r3.y = r0.w * 0.00999999978 + -0.5;
      r3.x = 0.25;
      r3.xy = -r3.xy + r0.xy;
      r3.x = dot(r3.xy, r3.xy);
      r3.x = sqrt(r3.x);
      r3.y = frac(shader_param_7.y);
      r3.x = cmp(r3.y >= r3.x);
      r2.w = r3.x ? 1.000000 : 0;
    } else {
      r3.x = cmp(0.119000003 < r0.z);
      r3.y = cmp(r0.z < 0.121000007);
      r3.x = r3.y ? r3.x : 0;
      if (r3.x != 0) {
        r3.y = r0.w * 0.00999999978 + -0.5;
        r3.x = 0.75;
        r3.xy = -r3.xy + r0.xy;
        r3.x = dot(r3.xy, r3.xy);
        r3.x = sqrt(r3.x);
        r3.y = frac(shader_param_7.y);
        r3.x = cmp(r3.y >= r3.x);
        r2.w = r3.x ? 1.000000 : 0;
      } else {
        r3.x = cmp(0.199000001 < r0.z);
        r3.y = cmp(r0.z < 0.201000005);
        r3.x = r3.y ? r3.x : 0;
        if (r3.x != 0) {
          r3.yw = r0.ww * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
          r3.xz = float2(0.25,0.75);
          r3.xyzw = -r3.xyzw + r0.xyxy;
          r3.x = dot(r3.xy, r3.xy);
          r3.x = sqrt(r3.x);
          r3.y = frac(shader_param_7.y);
          r3.x = cmp(r3.y >= r3.x);
          r3.z = dot(r3.zw, r3.zw);
          r3.z = sqrt(r3.z);
          r3.y = cmp(r3.y >= r3.z);
          r3.x = (int)r3.y | (int)r3.x;
          r2.w = r3.x ? 1.000000 : 0;
        } else {
          r3.x = cmp(0.398999989 < r0.z);
          r3.y = cmp(r0.z < 0.401000023);
          r3.x = r3.y ? r3.x : 0;
          r4.yw = r0.ww * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
          r4.xz = float2(0.0500000007,0.300000012);
          r5.xyzw = -r4.xyzw + r0.xyxy;
          r3.y = dot(r5.xy, r5.xy);
          r3.y = sqrt(r3.y);
          r3.z = frac(shader_param_7.y);
          r3.w = dot(r5.zw, r5.zw);
          r3.w = sqrt(r3.w);
          r3.yw = cmp(r3.zz >= r3.yw);
          r3.y = (int)r3.w | (int)r3.y;
          r5.xz = float2(0.699999988,0.949999988);
          r5.yw = r4.ww;
          r4.xyzw = -r5.xyzw + r0.xyxy;
          r3.w = dot(r4.xy, r4.xy);
          r3.w = sqrt(r3.w);
          r3.w = cmp(r3.z >= r3.w);
          r4.x = dot(r4.zw, r4.zw);
          r4.x = sqrt(r4.x);
          r3.z = cmp(r3.z >= r4.x);
          r3.z = (int)r3.z | (int)r3.w;
          r3.y = (int)r3.z | (int)r3.y;
          r3.x = r3.x ? r3.y : 0;
          r2.w = r3.x ? 1.000000 : 0;
        }
      }
    }
  }
  r2.w = cmp(r2.w == 1.000000);
  if (r2.w != 0) {
    r3.xyzw = float4(3,3,6,6) / screen_res.xyxy;
    r4.xy = v1.xy / r3.xy;
    r4.zw = cmp(r4.xy >= -r4.xy);
    r4.xy = frac(abs(r4.xy));
    r4.xy = r4.zw ? r4.xy : -r4.xy;
    r3.xy = -r4.xy * r3.xy + v1.xy;
    r4.xy = float2(12,78) + timers.xx;
    r2.w = dot(r3.xy, r4.xy);
    r2.w = sin(r2.w);
    r3.xy = float2(22738,78372) * r2.ww;
    r4.xy = screen_res.xy * v1.xy;
    r4.xy = (int2)r4.xy;
    r4.zw = float2(0,0);
    r2.w = s_position.Load(r4.xyz).z;
    r4.x = cmp(r2.w == 0.000000);
    r2.w = r4.x ? 10000 : r2.w;
    r4.zw = float2(0,0);
    r5.xyz = float3(0,0,1);
    while (true) {
      r5.w = cmp(4 < r5.z);
      if (r5.w != 0) break;
      r6.xy = float2(-1,1) + r5.zz;
      r5.w = rsqrt(r6.x);
      r5.w = 1 / r5.w;
      r5.w = 4 + -r5.w;
      r6.xz = r5.xy;
      r6.w = 0;
      while (true) {
        r7.x = cmp(r6.w >= 6.28318548);
        if (r7.x != 0) break;
        sincos(r6.w, r7.x, r8.x);
        r8.y = r7.x;
        r7.xy = r8.xy * r3.zw;
        r7.xy = r7.xy * r5.zz + v1.xy;
        r7.xy = screen_res.xy * r7.xy;
        r4.xy = (int2)r7.xy;
        r4.x = s_position.Load(r4.xyz).z;
        r4.y = cmp(r4.x == 0.000000);
        r4.x = r4.y ? 10000 : r4.x;
        r4.y = cmp(r2.w >= r4.x);
        r7.x = r4.x * r5.w + r6.x;
        r7.y = r6.z + r5.w;
        r6.xz = r4.yy ? r7.xy : r6.xz;
        r6.w = 0.52359879 + r6.w;
      }
      r5.xy = r6.xz;
      r5.z = r6.y;
    }
    r2.w = r5.x / r5.y;
    r3.z = saturate(0.0666666701 * r2.w);
    r3.w = r3.z * -2 + 3;
    r3.z = r3.z * r3.z;
    r3.z = -r3.w * r3.z + 1;
    r3.z = max(0.400000006, r3.z);
    r4.xy = r2.xy + -r1.xy;
    r3.zw = r3.zz * r4.xy + r1.xy;
    r4.x = cmp(r2.w < 1000);
    r2.w = -5 + r2.w;
    r2.w = saturate(0.00338983047 * r2.w);
    r4.y = r2.w * -2 + 3;
    r2.w = r2.w * r2.w;
    r2.w = -r4.y * r2.w + 1;
    r2.w = rsqrt(r2.w);
    r2.w = 1 / r2.w;
    r3.w = r3.z + r3.w;
    r3.w = cmp(r3.w < 0.899999976);
    r2.w = 0.100000001 + r2.w;
    r2.w = r3.z * r2.w;
    r2.w = r3.w ? r2.w : r3.z;
    r2.w = r4.x ? r2.w : r3.z;
    r3.z = cmp(shader_param_8.z >= -shader_param_8.z);
    r3.w = frac(abs(shader_param_8.z));
    r3.z = r3.z ? r3.w : -r3.w;
    r3.w = cmp(0 < r3.z);
    if (r3.w != 0) {
      r3.w = 0.03125 * timers.x;
      r4.x = cmp(r3.w >= -r3.w);
      r3.w = frac(abs(r3.w));
      r3.w = r4.x ? r3.w : -r3.w;
      r3.w = 32 * r3.w;
      r3.z = max(0, r3.z);
      r4.x = cos(timers.x);
      r4.x = 343.420013 * r4.x;
      r4.x = frac(r4.x);
      r4.y = 1 + -r3.z;
      r4.y = r4.y * 0.699999988 + r4.x;
      r4.y = min(1, r4.y);
      r4.zw = v1.xy * r4.yy;
      r4.yzw = float3(10,10,10) * r4.yzw;
      r4.zw = floor(r4.zw);
      r4.yz = r4.zw / r4.yy;
      r4.yz = r4.yz * r3.ww;
      r4.yz = cos(r4.yz);
      r4.yz = float2(343.420013,343.420013) * r4.yz;
      r4.yz = frac(r4.yz);
      r4.y = -r3.z * 0.5 + r4.y;
      r4.yz = float2(0.5,0.800000012) + r4.yz;
      r4.y = 1 + -r4.y;
      r4.w = v1.y * r4.y;
      r4.yw = float2(40,40) * r4.yw;
      r4.w = floor(r4.w);
      r4.y = r4.w / r4.y;
      r4.y = r4.y * r3.w;
      r4.y = cos(r4.y);
      r4.y = 343.420013 * r4.y;
      r4.y = frac(r4.y);
      r4.z = min(1, r4.z);
      r4.z = 0.899999976 + -r4.z;
      r3.w = v1.x * v1.y + r3.w;
      r3.w = cos(r3.w);
      r3.w = 343.420013 * r3.w;
      r3.w = frac(r3.w);
      r4.x = cmp(0.5 < r4.x);
      r4.x = r4.x ? 1 : -1;
      r4.y = r4.y * r3.z;
      r4.x = r4.y * r4.x;
      r4.x = 0.0500000007 * r4.x;
      r3.w = r4.x * r3.w;
      r3.w = r3.w * 0.5 + r4.x;
      r3.z = r4.z * r3.z;
      r4.z = r3.z * 0.100000001 + v1.y;
      r4.y = v1.x;
      r4.x = 0;
      r3.z = 0;
      while (true) {
        r4.w = cmp((int)r3.z >= 10);
        if (r4.w != 0) break;
        r4.w = (int)r3.z;
        r4.w = r4.w * r3.w;
        r4.y = saturate(r4.w * 0.100000001 + r4.y);
        r4.w = s_blur_2.SampleLevel(smp_rtlinear_s, r4.yz, 0).x;
        r4.x = r4.x + r4.w;
        r3.z = (int)r3.z + 1;
      }
      r3.z = r4.x * 0.100000001 + -r2.w;
      r2.w = r3.z * 0.899999976 + r2.w;
    }
    r3.zw = float2(0,0);
    r4.x = 1;
    while (true) {
      r4.y = cmp(4 < r4.x);
      if (r4.y != 0) break;
      r5.xy = r3.zw;
      r5.z = 0;
      while (true) {
        r4.y = cmp(r5.z >= 6.28318548);
        if (r4.y != 0) break;
        sincos(r5.z, r6.x, r7.x);
        r7.y = r6.x;
        r4.yz = r7.xy * r4.xx;
        r4.yz = float2(5,5) * r4.yz;
        r4.yz = r4.yz / screen_res.xy;
        r4.yz = v1.xy + r4.yz;
        r4.w = s_blur_8.SampleLevel(smp_rtlinear_s, r4.yz, 0).y;
        r4.y = s_blur_4.SampleLevel(smp_rtlinear_s, r4.yz, 0).y;
        r6.x = r4.w + r4.y;
        r4.y = cmp(0 < r6.x);
        r6.yzw = float3(1,0.5,0.785398185) + r5.yyz;
        r5.yw = r4.yy ? r6.yx : r6.zx;
        r5.x = r5.x + r5.w;
        r5.z = r6.w;
      }
      r3.zw = r5.xy;
      r4.x = 1 + r4.x;
    }
    r3.z = r3.z / r3.w;
    r3.z = -0.699999988 + r3.z;
    r3.w = -0.600000024 + r2.y;
    r3.zw = max(float2(0,0), r3.zw);
    r2.w = r3.w * 1.66666663 + r2.w;
    r2.w = r3.z * 2 + r2.w;
    r3.zw = float2(-0.5,-0.5) + v1.xy;
    r3.zw = float2(2.20000005,2.20000005) * r3.zw;
    r4.x = 0.200000003 * abs(r3.w);
    r4.x = r4.x * r4.x + 1;
    r4.x = r4.x * r3.z;
    r3.z = 0.25 * abs(r4.x);
    r3.z = r3.z * r3.z + 1;
    r4.y = r3.w * r3.z;
    r3.zw = r4.xy * float2(0.5,0.5) + float2(0.5,0.5);
    r3.zw = r3.zw * float2(0.920000017,0.920000017) + float2(0.0399999991,0.0399999991);
    r4.xy = float2(1.08000004,0.648000002) * r2.xx;
    r4.x = r4.x * r4.x;
    r4.x = saturate(r4.x * 0.400000006 + r4.y);
    r4.y = r3.w * r3.z;
    r4.y = 16 * r4.y;
    r4.zw = float2(1,1) + -r3.zw;
    r4.y = r4.y * r4.z;
    r4.y = r4.y * r4.w;
    r4.y = log2(abs(r4.y));
    r4.y = 0.300000012 * r4.y;
    r4.y = exp2(r4.y);
    r4.x = r4.x * r4.y;
    r4.y = dot(r3.ww, screen_res.yy);
    r4.y = sin(r4.y);
    r4.y = r4.y * 0.349999994 + 0.349999994;
    r4.y = log2(r4.y);
    r4.xy = float2(2.65999985,1.70000005) * r4.xy;
    r4.y = exp2(r4.y);
    r4.y = r4.y * 0.699999988 + 0.400000006;
    r4.x = r4.x * r4.y;
    r4.y = 110 * timers.x;
    r4.y = sin(r4.y);
    r4.y = r4.y * 0.00999999978 + 1;
    r4.x = r4.x * r4.y;
    r4.yz = cmp(r3.zw < float2(0,0));
    r3.zw = cmp(float2(1,1) < r3.zw);
    r3.zw = (int2)r3.zw | (int2)r4.yz;
    r3.z = (int)r3.w | (int)r3.z;
    r3.w = v1.x + v1.x;
    r3.w = cmp(r3.w >= -r3.w);
    r4.yz = r3.ww ? float2(2,0.5) : float2(-2,-0.5);
    r3.w = v1.x * r4.z;
    r3.xyw = frac(r3.xyw);
    r3.w = r4.y * r3.w + -1;
    r3.w = saturate(r3.w + r3.w);
    r3.w = -r3.w * 0.649999976 + 1;
    r3.w = r4.x * r3.w;
    r3.z = r3.z ? 0 : r3.w;
    r3.z = r3.z + -r2.w;
    r2.w = r3.z * 0.0700000003 + r2.w;
    r3.zw = floor(shader_param_8.yz);
    r4.xy = float2(0.100000001,0.00999999978) * r3.zw;
    r3.w = rsqrt(r4.x);
    r3.w = 1 / r3.w;
    r3.x = r3.x * r3.w;
  r2.w = max(r3.x * 0.100000001 + r2.w, 0);
  nvIntensity = r2.w;
    r3.x = r3.z * 0.100000001 + -1;
    r3.x = -r3.x * 0.000899999985 + 0.999100029;
    r3.x = cmp(r3.x < r3.y);
    r2.w = r3.x ? 1 : r2.w;
    r3.xyz = float3(0.5,1,0.400000006) * r2.www;
    r2.w = cmp(r2.w >= 0.949999988);
    r3.w = r3.y * r3.y;
  r3.xyz = r2.www ? r3.www : r3.xyz;
  float3 blur4Sample = s_blur_4.SampleLevel(smp_rtlinear_s, v1.xy, 0).xyz;
  float3 blur8Sample = s_blur_8.SampleLevel(smp_rtlinear_s, v1.xy, 0).xyz;
  float baseLuma = max(dot(sceneSample, NV_LUMA), 0);
  float blur2Luma = max(dot(blurSample, NV_LUMA), 0);
  float blur4Luma = max(dot(blur4Sample, NV_LUMA), 0);
  float blur8Luma = max(dot(blur8Sample, NV_LUMA), 0);
  float combinedLuma = baseLuma * 0.600000024 + blur2Luma * 0.25 + blur4Luma * 0.1 + blur8Luma * 0.0500000007;
  float intensityScale = max(nvIntensity, 0);
  float exposureCurve = intensityScale + intensityScale * intensityScale * 0.349999994;
  float highlightCurve = exp2(log2(1 + combinedLuma * 0.75));
  float3 hdrColor = NV_TINT * (exposureCurve * highlightCurve);
  hdrColor += NV_TINT * (baseLuma * 0.25 + blur2Luma * 0.150000006);
  hdrColor += blurSample * float3(0.0299999993, 0.119999997, 0.0799999982);
  float nitsScale = max(RENODX_DIFFUSE_WHITE_NITS, 1.0f) / 203.0f;
  r3.xyz = max(hdrColor * nitsScale, float3(0,0,0));
    if (r1.w != 0) {
      r1.w = frac(shader_param_7.y);
      r5.y = r0.w * 0.00999999978 + -0.5;
      r5.x = 0.5;
      r4.xz = -r5.xy + r0.xy;
      r2.w = dot(r4.xz, r4.xz);
      r2.w = sqrt(r2.w);
      r1.w = r2.w + -r1.w;
      r2.w = 1 / -r4.y;
      r1.w = saturate(r2.w * r1.w);
      r2.w = r1.w * -2 + 3;
      r1.w = r1.w * r1.w;
      r1.w = r2.w * r1.w;
      r2.w = r1.w * r1.w;
      r1.w = -r1.w * r2.w + 1;
      r1.w = 1 + -r1.w;
    } else {
      r2.w = cmp(0.109000005 < r0.z);
      r3.w = cmp(r0.z < 0.111000001);
      r2.w = r2.w ? r3.w : 0;
      if (r2.w != 0) {
        r2.w = frac(shader_param_7.y);
        r5.y = r0.w * 0.00999999978 + -0.5;
        r5.x = 0.25;
        r4.xz = -r5.xy + r0.xy;
        r3.w = dot(r4.xz, r4.xz);
        r3.w = sqrt(r3.w);
        r2.w = r3.w + -r2.w;
        r3.w = 1 / -r4.y;
        r2.w = saturate(r3.w * r2.w);
        r3.w = r2.w * -2 + 3;
        r2.w = r2.w * r2.w;
        r2.w = r3.w * r2.w;
        r3.w = r2.w * r2.w;
        r2.w = -r2.w * r3.w + 1;
        r1.w = 1 + -r2.w;
      } else {
        r2.w = cmp(0.119000003 < r0.z);
        r3.w = cmp(r0.z < 0.121000007);
        r2.w = r2.w ? r3.w : 0;
        if (r2.w != 0) {
          r2.w = frac(shader_param_7.y);
          r5.y = r0.w * 0.00999999978 + -0.5;
          r5.x = 0.75;
          r4.xz = -r5.xy + r0.xy;
          r3.w = dot(r4.xz, r4.xz);
          r3.w = sqrt(r3.w);
          r2.w = r3.w + -r2.w;
          r3.w = 1 / -r4.y;
          r2.w = saturate(r3.w * r2.w);
          r3.w = r2.w * -2 + 3;
          r2.w = r2.w * r2.w;
          r2.w = r3.w * r2.w;
          r3.w = r2.w * r2.w;
          r2.w = -r2.w * r3.w + 1;
          r1.w = 1 + -r2.w;
        } else {
          r2.w = cmp(0.199000001 < r0.z);
          r3.w = cmp(r0.z < 0.201000005);
          r2.w = r2.w ? r3.w : 0;
          if (r2.w != 0) {
            r2.w = frac(shader_param_7.y);
            r5.yw = r0.ww * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
            r5.xz = float2(0.25,0.75);
            r5.xyzw = -r5.xyzw + r0.xyxy;
            r3.w = dot(r5.xy, r5.xy);
            r3.w = sqrt(r3.w);
            r3.w = r3.w + -r2.w;
            r4.x = 1 / -r4.y;
            r3.w = saturate(r4.x * r3.w);
            r4.z = r3.w * -2 + 3;
            r3.w = r3.w * r3.w;
            r3.w = r4.z * r3.w;
            r4.z = r3.w * r3.w;
            r4.w = dot(r5.zw, r5.zw);
            r4.w = sqrt(r4.w);
            r2.w = r4.w + -r2.w;
            r2.w = saturate(r2.w * r4.x);
            r4.x = r2.w * -2 + 3;
            r2.w = r2.w * r2.w;
            r2.w = r4.x * r2.w;
            r4.x = r2.w * r2.w;
            r3.w = -r3.w * r4.z + 1;
            r2.w = -r2.w * r4.x + 1;
            r1.w = -r3.w * r2.w + 1;
          } else {
            r2.w = cmp(0.398999989 < r0.z);
            r0.z = cmp(r0.z < 0.401000023);
            r0.z = r0.z ? r2.w : 0;
            if (r0.z != 0) {
              r0.z = frac(shader_param_7.y);
              r5.yw = r0.ww * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
              r5.xz = float2(0.0500000007,0.300000012);
              r6.xyzw = -r5.xyzw + r0.xyxy;
              r0.w = dot(r6.xy, r6.xy);
              r0.w = sqrt(r0.w);
              r0.w = r0.w + -r0.z;
              r2.w = 1 / -r4.y;
              r0.w = saturate(r2.w * r0.w);
              r3.w = r0.w * -2 + 3;
              r0.w = r0.w * r0.w;
              r0.w = r3.w * r0.w;
              r3.w = r0.w * r0.w;
              r4.x = dot(r6.zw, r6.zw);
              r4.x = sqrt(r4.x);
              r4.x = r4.x + -r0.z;
              r4.x = saturate(r4.x * r2.w);
              r4.y = r4.x * -2 + 3;
              r4.x = r4.x * r4.x;
              r4.x = r4.y * r4.x;
              r4.y = r4.x * r4.x;
              r6.xz = float2(0.699999988,0.949999988);
              r6.yw = r5.ww;
              r5.xyzw = -r6.xyzw + r0.xyxy;
              r0.x = dot(r5.xy, r5.xy);
              r0.x = sqrt(r0.x);
              r0.x = r0.x + -r0.z;
              r0.x = saturate(r0.x * r2.w);
              r0.y = r0.x * -2 + 3;
              r0.x = r0.x * r0.x;
              r0.x = r0.y * r0.x;
              r0.y = r0.x * r0.x;
              r4.z = dot(r5.zw, r5.zw);
              r4.z = sqrt(r4.z);
              r0.z = r4.z + -r0.z;
              r0.z = saturate(r0.z * r2.w);
              r2.w = r0.z * -2 + 3;
              r0.z = r0.z * r0.z;
              r0.z = r2.w * r0.z;
              r2.w = r0.z * r0.z;
              r0.w = -r0.w * r3.w + 1;
              r3.w = -r4.x * r4.y + 1;
              r0.w = r3.w * r0.w;
              r0.x = -r0.x * r0.y + 1;
              r0.x = r0.w * r0.x;
              r0.y = -r0.z * r2.w + 1;
              r1.w = -r0.x * r0.y + 1;
            }
          }
        }
      }
    }
    o0.xyz = r3.xyz * r1.www;
    o0.w = 1;
    return;
  } else {
    r0.x = frac(shader_param_8.w);
    r0.y = cmp(0.000999999931 >= r0.x);
  r2.xyz = max(r2.xyz, float3(0,0,0));
    r0.xzw = r0.xxx * float3(10,10,10) + float3(-1,-2,-3);
  r3.xyz = max(r1.xyz, float3(0,0,0));
    r0.xzw = cmp(float3(0.00999999978,0.00999999978,0.00999999978) >= abs(r0.xzw));
    r0.z = (int)r0.z | (int)r0.w;
    r1.xyz = r0.zzz ? r3.xyz : r1.xyz;
    r0.xzw = r0.xxx ? float3(0,0,0) : r1.xyz;
    o0.xyz = r0.yyy ? r2.xyz : r0.xzw;
    o0.w = 1;
    return;
  }
  return;
}