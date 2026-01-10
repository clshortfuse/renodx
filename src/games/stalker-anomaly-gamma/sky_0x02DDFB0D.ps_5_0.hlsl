// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 17 22:21:57 2025

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
TextureCube<float4> s_sky0 : register(t0);
TextureCube<float4> s_sky1 : register(t1);


// 3Dmigoto declarations
#define cmp -

// Skybox composite pass: blends two cubemaps, drives optional animated highlights,
// and outputs both full-resolution HDR color (o0) and a downsampled copy (o1).
void main(
  float4 v0 : COLOR0,
  float4 v1 : TEXCOORD0,
  float3 v2 : TEXCOORD1,
  float4 v3 : SV_Position0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Sample both sky cubemaps and interpolate using the weights encoded in v0.
  r0.xyz = s_sky0.Sample(smp_rtlinear_s, v1.xyz).xyz;
  r1.xyz = s_sky1.Sample(smp_rtlinear_s, v2.xyz).xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = v0.www * r1.xyz + r0.xyz;
  r0.xyz = v0.xyz * r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  // Convert through log/exp to reproduce the original shader's LUT domain.
  r0.xyz = log2(r0.xyz);
  r1.xyz = float3(1,1,1) * r0.xyz;
  r1.xyz = exp2(r1.xyz);
  // Always use HDR path: keep linear HDR sky colors and a downsample for o1
  r2.xyz = float3(0.111111112,0.111111112,0.111111112) * r1.xyz;
  r3.xyz = r1.xyz;
  // Derive normalized screen-space coordinates and per-tile parameters.
  r0.xy = v3.xy / screen_res.xy;
  r0.z = floor(shader_param_8.x);
  r0.w = frac(shader_param_8.x);
  r0.x = -0.5 + r0.x;
  r1.x = screen_res.x / screen_res.y;
  r1.x = r0.x * r1.x + 0.5;
  r0.x = floor(shader_param_7.x);
  r1.z = -r0.x * 0.0500000007 + 5;
  r1.z = max(1, r1.z);
  r1.z = min(5, r1.z);
  r1.y = r1.z * r0.y;
  r0.yz = cmp(float2(0.0989999995,0) < r0.wz);
  r1.z = cmp(r0.w < 0.100999996);
  r0.y = r0.y ? r1.z : 0;
  // Determine whether the current pixel falls inside any animated highlight mask.
  if (r0.y != 0) {
    r4.y = r0.x * 0.00999999978 + -0.5;
    r4.x = 0.5;
    r1.zw = -r4.xy + r1.xy;
    r1.z = dot(r1.zw, r1.zw);
    r1.z = sqrt(r1.z);
    r1.w = frac(shader_param_7.y);
    r1.z = cmp(r1.w >= r1.z);
    r1.z = r1.z ? 1.000000 : 0;
  } else {
    r1.w = cmp(0.109000005 < r0.w);
    r2.w = cmp(r0.w < 0.111000001);
    r1.w = r1.w ? r2.w : 0;
    if (r1.w != 0) {
      r4.y = r0.x * 0.00999999978 + -0.5;
      r4.x = 0.25;
      r4.xy = -r4.xy + r1.xy;
      r1.w = dot(r4.xy, r4.xy);
      r1.w = sqrt(r1.w);
      r2.w = frac(shader_param_7.y);
      r1.w = cmp(r2.w >= r1.w);
      r1.z = r1.w ? 1.000000 : 0;
    } else {
      r1.w = cmp(0.119000003 < r0.w);
      r2.w = cmp(r0.w < 0.121000007);
      r1.w = r1.w ? r2.w : 0;
      if (r1.w != 0) {
        r4.y = r0.x * 0.00999999978 + -0.5;
        r4.x = 0.75;
        r4.xy = -r4.xy + r1.xy;
        r1.w = dot(r4.xy, r4.xy);
        r1.w = sqrt(r1.w);
        r2.w = frac(shader_param_7.y);
        r1.w = cmp(r2.w >= r1.w);
        r1.z = r1.w ? 1.000000 : 0;
      } else {
        r1.w = cmp(0.199000001 < r0.w);
        r2.w = cmp(r0.w < 0.201000005);
        r1.w = r1.w ? r2.w : 0;
        if (r1.w != 0) {
          r4.yw = r0.xx * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
          r4.xz = float2(0.25,0.75);
          r4.xyzw = -r4.xyzw + r1.xyxy;
          r1.w = dot(r4.xy, r4.xy);
          r1.w = sqrt(r1.w);
          r2.w = frac(shader_param_7.y);
          r1.w = cmp(r2.w >= r1.w);
          r3.w = dot(r4.zw, r4.zw);
          r3.w = sqrt(r3.w);
          r2.w = cmp(r2.w >= r3.w);
          r1.w = (int)r1.w | (int)r2.w;
          r1.z = r1.w ? 1.000000 : 0;
        } else {
          r1.w = cmp(0.398999989 < r0.w);
          r2.w = cmp(r0.w < 0.401000023);
          r1.w = r1.w ? r2.w : 0;
          r4.yw = r0.xx * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
          r4.xz = float2(0.0500000007,0.300000012);
          r5.xyzw = -r4.xyzw + r1.xyxy;
          r2.w = dot(r5.xy, r5.xy);
          r2.w = sqrt(r2.w);
          r3.w = frac(shader_param_7.y);
          r2.w = cmp(r3.w >= r2.w);
          r4.x = dot(r5.zw, r5.zw);
          r4.x = sqrt(r4.x);
          r4.x = cmp(r3.w >= r4.x);
          r2.w = (int)r2.w | (int)r4.x;
          r5.xz = float2(0.699999988,0.949999988);
          r5.yw = r4.ww;
          r4.xyzw = -r5.xyzw + r1.xyxy;
          r4.x = dot(r4.xy, r4.xy);
          r4.x = sqrt(r4.x);
          r4.x = cmp(r3.w >= r4.x);
          r4.y = dot(r4.zw, r4.zw);
          r4.y = sqrt(r4.y);
          r3.w = cmp(r3.w >= r4.y);
          r3.w = (int)r3.w | (int)r4.x;
          r2.w = (int)r2.w | (int)r3.w;
          r1.w = r1.w ? r2.w : 0;
          r1.z = r1.w ? 1.000000 : 0;
        }
      }
    }
  }
  if (r0.y != 0) {
    r4.y = r0.x * 0.00999999978 + -0.5;
    r4.x = 0.5;
    r4.xy = -r4.xy + r1.xy;
    r1.w = dot(r4.xy, r4.xy);
    r1.w = sqrt(r1.w);
    r2.w = frac(shader_param_7.y);
    r1.w = cmp(r2.w >= r1.w);
    r1.w = r1.w ? 1.000000 : 0;
  } else {
    r2.w = cmp(0.109000005 < r0.w);
    r3.w = cmp(r0.w < 0.111000001);
    r2.w = r2.w ? r3.w : 0;
    if (r2.w != 0) {
      r4.y = r0.x * 0.00999999978 + -0.5;
      r4.x = 0.25;
      r4.xy = -r4.xy + r1.xy;
      r2.w = dot(r4.xy, r4.xy);
      r2.w = sqrt(r2.w);
      r3.w = frac(shader_param_7.y);
      r2.w = cmp(r3.w >= r2.w);
      r1.w = r2.w ? 1.000000 : 0;
    } else {
      r2.w = cmp(0.119000003 < r0.w);
      r3.w = cmp(r0.w < 0.121000007);
      r2.w = r2.w ? r3.w : 0;
      if (r2.w != 0) {
        r4.y = r0.x * 0.00999999978 + -0.5;
        r4.x = 0.75;
        r4.xy = -r4.xy + r1.xy;
        r2.w = dot(r4.xy, r4.xy);
        r2.w = sqrt(r2.w);
        r3.w = frac(shader_param_7.y);
        r2.w = cmp(r3.w >= r2.w);
        r1.w = r2.w ? 1.000000 : 0;
      } else {
        r2.w = cmp(0.199000001 < r0.w);
        r3.w = cmp(r0.w < 0.201000005);
        r2.w = r2.w ? r3.w : 0;
        if (r2.w != 0) {
          r4.yw = r0.xx * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
          r4.xz = float2(0.25,0.75);
          r4.xyzw = -r4.xyzw + r1.xyxy;
          r2.w = dot(r4.xy, r4.xy);
          r2.w = sqrt(r2.w);
          r3.w = frac(shader_param_7.y);
          r2.w = cmp(r3.w >= r2.w);
          r4.x = dot(r4.zw, r4.zw);
          r4.x = sqrt(r4.x);
          r3.w = cmp(r3.w >= r4.x);
          r2.w = (int)r2.w | (int)r3.w;
          r1.w = r2.w ? 1.000000 : 0;
        } else {
          r2.w = cmp(0.398999989 < r0.w);
          r3.w = cmp(r0.w < 0.401000023);
          r2.w = r2.w ? r3.w : 0;
          r4.yw = r0.xx * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
          r4.xz = float2(0.0500000007,0.300000012);
          r5.xyzw = -r4.xyzw + r1.xyxy;
          r3.w = dot(r5.xy, r5.xy);
          r3.w = sqrt(r3.w);
          r4.x = frac(shader_param_7.y);
          r3.w = cmp(r4.x >= r3.w);
          r4.y = dot(r5.zw, r5.zw);
          r4.y = sqrt(r4.y);
          r4.y = cmp(r4.x >= r4.y);
          r3.w = (int)r3.w | (int)r4.y;
          r5.xz = float2(0.699999988,0.949999988);
          r5.yw = r4.ww;
          r5.xyzw = -r5.xyzw + r1.xyxy;
          r4.y = dot(r5.xy, r5.xy);
          r4.y = sqrt(r4.y);
          r4.y = cmp(r4.x >= r4.y);
          r4.z = dot(r5.zw, r5.zw);
          r4.z = sqrt(r4.z);
          r4.x = cmp(r4.x >= r4.z);
          r4.x = (int)r4.x | (int)r4.y;
          r3.w = (int)r3.w | (int)r4.x;
          r2.w = r2.w ? r3.w : 0;
          r1.w = r2.w ? 1.000000 : 0;
        }
      }
    }
  }
  r1.zw = cmp(r1.zw == float2(1,1));
  r1.z = (int)r1.w | (int)r1.z;
  r0.z = r0.z ? r1.z : 0;
  // Highlight active: compute falloff weights and mix boosted HDR outputs.
  if (r0.z != 0) {
    r1.zw = floor(shader_param_8.yz);
    r4.xyz = float3(5,5,5) * r3.xyz;
    r0.z = dot(r4.xyz, float3(0.298999995,0.587000012,0.114));
    r4.xyz = float3(5,5,5) * r2.xyz;
    r2.w = dot(r4.xyz, float3(0.298999995,0.587000012,0.114));
    r1.zw = float2(0.00999999978,0.100000001) * r1.wz;
    r4.x = saturate(r1.w * r0.z);
    r4.yzw = saturate(float3(0,0,0));
    r5.x = saturate(r2.w * r1.w);
    r5.yzw = saturate(float3(0,0,0));
    if (r0.y != 0) {
      r0.y = frac(shader_param_7.y);
      r6.y = r0.x * 0.00999999978 + -0.5;
      r6.x = 0.5;
      r6.xy = -r6.xy + r1.xy;
      r0.z = dot(r6.xy, r6.xy);
      r0.z = sqrt(r0.z);
      r0.y = r0.z + -r0.y;
      r0.z = 1 / -r1.z;
      r0.y = saturate(r0.y * r0.z);
      r0.z = r0.y * -2 + 3;
      r0.y = r0.y * r0.y;
      r0.y = r0.z * r0.y;
      r0.z = r0.y * r0.y;
      r0.y = -r0.y * r0.z + 1;
      r0.y = 1 + -r0.y;
      r0.z = r0.y;
    } else {
      r1.w = cmp(0.109000005 < r0.w);
      r2.w = cmp(r0.w < 0.111000001);
      r1.w = r1.w ? r2.w : 0;
      if (r1.w != 0) {
        r2.w = frac(shader_param_7.y);
        r6.y = r0.x * 0.00999999978 + -0.5;
        r6.x = 0.25;
        r6.xy = -r6.xy + r1.xy;
        r3.w = dot(r6.xy, r6.xy);
        r3.w = sqrt(r3.w);
        r2.w = r3.w + -r2.w;
        r3.w = 1 / -r1.z;
        r2.w = saturate(r3.w * r2.w);
        r3.w = r2.w * -2 + 3;
        r2.w = r2.w * r2.w;
        r2.w = r3.w * r2.w;
        r3.w = r2.w * r2.w;
        r2.w = -r2.w * r3.w + 1;
        r0.z = 1 + -r2.w;
      } else {
        r2.w = cmp(0.119000003 < r0.w);
        r3.w = cmp(r0.w < 0.121000007);
        r2.w = r2.w ? r3.w : 0;
        if (r2.w != 0) {
          r2.w = frac(shader_param_7.y);
          r6.y = r0.x * 0.00999999978 + -0.5;
          r6.x = 0.75;
          r6.xy = -r6.xy + r1.xy;
          r3.w = dot(r6.xy, r6.xy);
          r3.w = sqrt(r3.w);
          r2.w = r3.w + -r2.w;
          r3.w = 1 / -r1.z;
          r2.w = saturate(r3.w * r2.w);
          r3.w = r2.w * -2 + 3;
          r2.w = r2.w * r2.w;
          r2.w = r3.w * r2.w;
          r3.w = r2.w * r2.w;
          r2.w = -r2.w * r3.w + 1;
          r0.z = 1 + -r2.w;
        } else {
          r2.w = cmp(0.199000001 < r0.w);
          r3.w = cmp(r0.w < 0.201000005);
          r2.w = r2.w ? r3.w : 0;
          if (r2.w != 0) {
            r2.w = frac(shader_param_7.y);
            r6.yw = r0.xx * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
            r6.xz = float2(0.25,0.75);
            r6.xyzw = -r6.xyzw + r1.xyxy;
            r3.w = dot(r6.xy, r6.xy);
            r3.w = sqrt(r3.w);
            r3.w = r3.w + -r2.w;
            r6.x = 1 / -r1.z;
            r3.w = saturate(r6.x * r3.w);
            r6.y = r3.w * -2 + 3;
            r3.w = r3.w * r3.w;
            r3.w = r6.y * r3.w;
            r6.y = r3.w * r3.w;
            r6.z = dot(r6.zw, r6.zw);
            r6.z = sqrt(r6.z);
            r2.w = r6.z + -r2.w;
            r2.w = saturate(r2.w * r6.x);
            r6.x = r2.w * -2 + 3;
            r2.w = r2.w * r2.w;
            r2.w = r6.x * r2.w;
            r6.x = r2.w * r2.w;
            r3.w = -r3.w * r6.y + 1;
            r2.w = -r2.w * r6.x + 1;
            r0.z = -r3.w * r2.w + 1;
          } else {
            r2.w = cmp(0.398999989 < r0.w);
            r3.w = cmp(r0.w < 0.401000023);
            r2.w = r2.w ? r3.w : 0;
            if (r2.w != 0) {
              r2.w = frac(shader_param_7.y);
              r6.yw = r0.xx * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
              r6.xz = float2(0.0500000007,0.300000012);
              r7.xyzw = -r6.xyzw + r1.xyxy;
              r3.w = dot(r7.xy, r7.xy);
              r3.w = sqrt(r3.w);
              r3.w = r3.w + -r2.w;
              r6.x = 1 / -r1.z;
              r3.w = saturate(r6.x * r3.w);
              r6.y = r3.w * -2 + 3;
              r3.w = r3.w * r3.w;
              r3.w = r6.y * r3.w;
              r6.y = r3.w * r3.w;
              r6.z = dot(r7.zw, r7.zw);
              r6.z = sqrt(r6.z);
              r6.z = r6.z + -r2.w;
              r6.z = saturate(r6.z * r6.x);
              r7.x = r6.z * -2 + 3;
              r6.z = r6.z * r6.z;
              r6.z = r7.x * r6.z;
              r8.xz = float2(0.699999988,0.949999988);
              r8.yw = r6.ww;
              r8.xyzw = -r8.xyzw + r1.xyxy;
              r6.w = dot(r8.xy, r8.xy);
              r6.w = sqrt(r6.w);
              r6.w = r6.w + -r2.w;
              r6.w = saturate(r6.w * r6.x);
              r7.y = r6.w * -2 + 3;
              r6.w = r6.w * r6.w;
              r6.w = r7.y * r6.w;
              r7.xy = r6.zw * r6.zw;
              r7.z = dot(r8.zw, r8.zw);
              r7.z = sqrt(r7.z);
              r2.w = r7.z + -r2.w;
              r2.w = saturate(r2.w * r6.x);
              r6.x = r2.w * -2 + 3;
              r2.w = r2.w * r2.w;
              r2.w = r6.x * r2.w;
              r6.x = r2.w * r2.w;
              r3.w = -r3.w * r6.y + 1;
              r6.y = -r6.z * r7.x + 1;
              r3.w = r6.y * r3.w;
              r6.y = -r6.w * r7.y + 1;
              r3.w = r6.y * r3.w;
              r2.w = -r2.w * r6.x + 1;
              r0.z = -r3.w * r2.w + 1;
            }
          }
        }
      }
      if (r1.w != 0) {
        r1.w = frac(shader_param_7.y);
        r6.y = r0.x * 0.00999999978 + -0.5;
        r6.x = 0.25;
        r6.xy = -r6.xy + r1.xy;
        r2.w = dot(r6.xy, r6.xy);
        r2.w = sqrt(r2.w);
        r1.w = r2.w + -r1.w;
        r2.w = 1 / -r1.z;
        r1.w = saturate(r2.w * r1.w);
        r2.w = r1.w * -2 + 3;
        r1.w = r1.w * r1.w;
        r1.w = r2.w * r1.w;
        r2.w = r1.w * r1.w;
        r1.w = -r1.w * r2.w + 1;
        r0.y = 1 + -r1.w;
      } else {
        r1.w = cmp(0.119000003 < r0.w);
        r2.w = cmp(r0.w < 0.121000007);
        r1.w = r1.w ? r2.w : 0;
        if (r1.w != 0) {
          r1.w = frac(shader_param_7.y);
          r6.y = r0.x * 0.00999999978 + -0.5;
          r6.x = 0.75;
          r6.xy = -r6.xy + r1.xy;
          r2.w = dot(r6.xy, r6.xy);
          r2.w = sqrt(r2.w);
          r1.w = r2.w + -r1.w;
          r2.w = 1 / -r1.z;
          r1.w = saturate(r2.w * r1.w);
          r2.w = r1.w * -2 + 3;
          r1.w = r1.w * r1.w;
          r1.w = r2.w * r1.w;
          r2.w = r1.w * r1.w;
          r1.w = -r1.w * r2.w + 1;
          r0.y = 1 + -r1.w;
        } else {
          r1.w = cmp(0.199000001 < r0.w);
          r2.w = cmp(r0.w < 0.201000005);
          r1.w = r1.w ? r2.w : 0;
          if (r1.w != 0) {
            r1.w = frac(shader_param_7.y);
            r6.yw = r0.xx * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
            r6.xz = float2(0.25,0.75);
            r6.xyzw = -r6.xyzw + r1.xyxy;
            r2.w = dot(r6.xy, r6.xy);
            r2.w = sqrt(r2.w);
            r2.w = r2.w + -r1.w;
            r3.w = 1 / -r1.z;
            r2.w = saturate(r3.w * r2.w);
            r6.x = r2.w * -2 + 3;
            r2.w = r2.w * r2.w;
            r2.w = r6.x * r2.w;
            r6.x = r2.w * r2.w;
            r6.y = dot(r6.zw, r6.zw);
            r6.y = sqrt(r6.y);
            r1.w = r6.y + -r1.w;
            r1.w = saturate(r1.w * r3.w);
            r3.w = r1.w * -2 + 3;
            r1.w = r1.w * r1.w;
            r1.w = r3.w * r1.w;
            r3.w = r1.w * r1.w;
            r2.w = -r2.w * r6.x + 1;
            r1.w = -r1.w * r3.w + 1;
            r0.y = -r2.w * r1.w + 1;
          } else {
            r1.w = cmp(0.398999989 < r0.w);
            r0.w = cmp(r0.w < 0.401000023);
            r0.w = r0.w ? r1.w : 0;
            if (r0.w != 0) {
              r0.w = frac(shader_param_7.y);
              r6.yw = r0.xx * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
              r6.xz = float2(0.0500000007,0.300000012);
              r7.xyzw = -r6.xyzw + r1.xyxy;
              r0.x = dot(r7.xy, r7.xy);
              r0.x = sqrt(r0.x);
              r0.x = r0.x + -r0.w;
              r1.z = 1 / -r1.z;
              r0.x = saturate(r1.z * r0.x);
              r1.w = r0.x * -2 + 3;
              r0.x = r0.x * r0.x;
              r0.x = r1.w * r0.x;
              r2.w = dot(r7.zw, r7.zw);
              r2.w = sqrt(r2.w);
              r2.w = r2.w + -r0.w;
              r2.w = saturate(r2.w * r1.z);
              r3.w = r2.w * -2 + 3;
              r2.w = r2.w * r2.w;
              r2.w = r3.w * r2.w;
              r3.w = r2.w * r2.w;
              r7.xz = float2(0.699999988,0.949999988);
              r7.yw = r6.ww;
              r6.xyzw = -r7.xyzw + r1.xyxy;
              r1.x = dot(r6.xy, r6.xy);
              r1.x = sqrt(r1.x);
              r1.x = r1.x + -r0.w;
              r1.x = saturate(r1.x * r1.z);
              r1.y = r1.x * -2 + 3;
              r1.x = r1.x * r1.x;
              r1.x = r1.y * r1.x;
              r1.y = r1.x * r1.x;
              r6.x = dot(r6.zw, r6.zw);
              r6.x = sqrt(r6.x);
              r0.w = r6.x + -r0.w;
              r0.w = saturate(r0.w * r1.z);
              r1.z = r0.w * -2 + 3;
              r0.w = r0.w * r0.w;
              r0.w = r1.z * r0.w;
              r1.zw = r0.wx * r0.wx;
              r0.x = -r0.x * r1.w + 1;
              r1.w = -r2.w * r3.w + 1;
              r0.x = r1.w * r0.x;
              r1.x = -r1.x * r1.y + 1;
              r0.x = r1.x * r0.x;
              r0.w = -r0.w * r1.z + 1;
              r0.y = -r0.x * r0.w + 1;
            }
          }
        }
      }
    }
    r0.x = r0.z * r0.y;
    o0.xyzw = r4.xyzw * r0.xxxx;
    o1.xyzw = r5.xyzw * r0.xxxx;
  } else {
    // No highlight mask: pass the original HDR sky and downsampled copy through.
    o0.xyz = r3.xyz;
    o0.w = 0;
    o1.xyz = r2.xyz;
    o1.w = 0;
  }
  return;
}