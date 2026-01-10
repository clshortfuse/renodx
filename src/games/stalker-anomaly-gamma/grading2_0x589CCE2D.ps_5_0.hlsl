// ---- Created with 3Dmigoto v1.4.1 on Wed Oct 15 21:57:25 2025

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
  float4 ssfx_florafixes_1 : packoffset(c22);
  float4 ssfx_florafixes_2 : packoffset(c23);
  float4 ssfx_lightsetup_1 : packoffset(c24);
  float4 env_color : packoffset(c25);
  float4 hmodel_stuff : packoffset(c26);
  float4 sky_color : packoffset(c27);
  float4 fakescope_params3 : packoffset(c28);
  float4 ssfx_lut : packoffset(c29);
  float4 e_barrier : packoffset(c30);
  float4 e_weights : packoffset(c31);
  float4 e_kernel : packoffset(c32);
  float tnmp_a : packoffset(c33);
  float tnmp_b : packoffset(c33.y);
  float tnmp_c : packoffset(c33.z);
  float tnmp_d : packoffset(c33.w);
  float tnmp_e : packoffset(c34);
  float tnmp_f : packoffset(c34.y);
  float tnmp_w : packoffset(c34.z);
  float tnmp_exposure : packoffset(c34.w);
  float tnmp_gamma : packoffset(c35);
  float tnmp_onoff : packoffset(c35.y);
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
SamplerState smp_rtlinear_s : register(s1);
SamplerState smp_linear_s : register(s2);
Texture2D<float4> s_position : register(t0);
Texture2D<float4> s_image : register(t1);
Texture2D<float4> s_lut_atlas : register(t2);
Texture2D<float4> s_ssfx_bloom : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD1,
  float2 v1 : TEXCOORD2,
  float2 w1 : TEXCOORD3,
  float4 v2 : TEXCOORD4,
  float4 v3 : TEXCOORD5,
  float4 v4 : TEXCOORD6,
  float4 v5 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 / screen_res.x;
  r0.y = s_position.Sample(smp_nofilter_s, v0.xy).z;
  r0.zw = screen_res.xy * v0.xy;
  r1.xy = (int2)r0.zw;
  r1.zw = float2(0,0);
  r1.xyz = s_image.Load(r1.xyz).xyz;
  r0.z = v0.x * 34 + 1;
  r0.z = v0.x * r0.z;
  r0.w = 0.00346020772 * r0.z;
  r0.w = floor(r0.w);
  r0.z = -r0.w * 289 + r0.z;
  r0.z = v0.y + r0.z;
  r0.w = r0.z * 34 + 1;
  r0.z = r0.w * r0.z;
  r0.w = 0.00346020772 * r0.z;
  r0.w = floor(r0.w);
  r0.z = -r0.w * 289 + r0.z;
  r2.xy = float2(12,78) + timers.xx;
  r0.w = dot(v0.xy, r2.xy);
  r0.w = sin(r0.w);
  r0.w = 43758 * r0.w;
  r0.w = frac(r0.w);
  r0.z = r0.w * 0.25 + r0.z;
  r0.w = r0.z * 34 + 1;
  r0.z = r0.w * r0.z;
  r0.w = 0.00346020772 * r0.z;
  r0.w = floor(r0.w);
  r0.z = -r0.w * 289 + r0.z;
  sincos(r0.z, r2.x, r3.x);
  r0.w = r0.z * 34 + 1;
  r0.z = r0.w * r0.z;
  r0.w = 0.00346020772 * r0.z;
  r0.w = floor(r0.w);
  r0.z = -r0.w * 289 + r0.z;
  r0.w = r0.z * r0.x;
  r0.w = 0.020166669 * r0.w;
  r0.w = 0;  // Disable jitter offset for film grain
  r3.y = r2.x;
  r2.xy = r0.ww * r3.xy + v0.xy;
  r2.xyz = s_image.Sample(smp_linear_s, r2.xy).xyz;
  r4.xyz = -r2.xyz + r1.xyz;
  r3.zw = r0.ww * -r3.xy + v0.xy;
  r5.xyz = s_image.Sample(smp_linear_s, r3.zw).xyz;
  r2.xyz = r5.xyz + r2.xyz;
  r5.xyz = -r5.xyz + r1.xyz;
  r4.xyz = max(abs(r5.xyz), abs(r4.xyz));
  r5.xyzw = float4(-1,1,1,-1) * r3.xyxy;
  r6.xyzw = r0.wwww * r5.xyzw + v0.xyxy;
  r7.xyz = s_image.Sample(smp_linear_s, r6.xy).xyz;
  r2.xyz = r7.xyz + r2.xyz;
  r7.xyz = -r7.xyz + r1.xyz;
  r4.xyz = max(abs(r7.xyz), r4.xyz);
  r6.xyz = s_image.Sample(smp_linear_s, r6.zw).xyz;
  r2.xyz = r6.xyz + r2.xyz;
  r6.xyz = -r6.xyz + r1.xyz;
  r4.xyz = max(abs(r6.xyz), r4.xyz);
  r6.xyz = -r2.xyz * float3(0.25,0.25,0.25) + r1.xyz;
  r6.xyz = -abs(r6.xyz) * float3(25.5004463,25.5004463,25.5004463) + float3(1,1,1);
  r6.xyz = max(float3(0,0,0), float3(3,3,3) * r6.xyz);
  r4.xyz = -r4.xyz * float3(25.5004463,25.5004463,25.5004463) + float3(1,1,1);
  r4.xyz = max(float3(0,0,0), float3(3,3,3) * r4.xyz);
  r4.xyz = r6.xyz * r4.xyz;
  r2.xyz = r2.xyz * float3(0.25,0.25,0.25) + -r1.xyz;
  r2.xyz = r4.xyz * r2.xyz + r1.xyz;
  r0.w = r0.z * 34 + 1;
  r0.z = r0.w * r0.z;
  r0.w = 0.00346020772 * r0.z;
  r0.w = floor(r0.w);
  r0.z = -r0.w * 289 + r0.z;
  r0.w = r0.z * r0.x;
  r0.w = 0.0806666762 * r0.w;
  r0.w = 0;  // Disable jitter offset for film grain
  r3.zw = r0.ww * r3.xy + v0.xy;
  r4.xyz = s_image.Sample(smp_linear_s, r3.zw).xyz;
  r6.xyz = -r4.xyz + r2.xyz;
  r3.zw = r0.ww * -r3.xy + v0.xy;
  r7.xyz = s_image.Sample(smp_linear_s, r3.zw).xyz;
  r4.xyz = r7.xyz + r4.xyz;
  r7.xyz = -r7.xyz + r2.xyz;
  r6.xyz = max(abs(r7.xyz), abs(r6.xyz));
  r7.xyzw = r0.wwww * r5.xyzw + v0.xyxy;
  r8.xyz = s_image.Sample(smp_linear_s, r7.xy).xyz;
  r4.xyz = r8.xyz + r4.xyz;
  r8.xyz = -r8.xyz + r2.xyz;
  r6.xyz = max(abs(r8.xyz), r6.xyz);
  r7.xyz = s_image.Sample(smp_linear_s, r7.zw).xyz;
  r4.xyz = r7.xyz + r4.xyz;
  r7.xyz = -r7.xyz + r2.xyz;
  r6.xyz = max(abs(r7.xyz), r6.xyz);
  r7.xyz = -r4.xyz * float3(0.25,0.25,0.25) + r2.xyz;
  r7.xyz = -abs(r7.xyz) * float3(25.5004463,25.5004463,25.5004463) + float3(1,1,1);
  r7.xyz = max(float3(0,0,0), float3(3,3,3) * r7.xyz);
  r6.xyz = -r6.xyz * float3(25.5004463,25.5004463,25.5004463) + float3(1,1,1);
  r6.xyz = max(float3(0,0,0), float3(3,3,3) * r6.xyz);
  r6.xyz = r7.xyz * r6.xyz;
  r4.xyz = r4.xyz * float3(0.25,0.25,0.25) + -r2.xyz;
  r2.xyz = r6.xyz * r4.xyz + r2.xyz;
  r0.w = r0.z * 34 + 1;
  r0.z = r0.w * r0.z;
  r0.w = 0.00346020772 * r0.z;
  r0.w = floor(r0.w);
  r0.z = -r0.w * 289 + r0.z;
  r0.x = r0.z * r0.x;
  r0.x = 0.181500003 * r0.x;
  r0.x = 0;  // Disable jitter offset for film grain
  r0.zw = r0.xx * r3.xy + v0.xy;
  r4.xyz = s_image.Sample(smp_linear_s, r0.zw).xyz;
  r6.xyz = -r4.xyz + r2.xyz;
  r0.zw = r0.xx * -r3.xy + v0.xy;
  r3.xyz = s_image.Sample(smp_linear_s, r0.zw).xyz;
  r4.xyz = r4.xyz + r3.xyz;
  r3.xyz = -r3.xyz + r2.xyz;
  r3.xyz = max(abs(r6.xyz), abs(r3.xyz));
  r5.xyzw = r0.xxxx * r5.xyzw + v0.xyxy;
  r0.xzw = s_image.Sample(smp_linear_s, r5.xy).xyz;
  r4.xyz = r4.xyz + r0.xzw;
  r0.xzw = r2.xyz + -r0.xzw;
  r0.xzw = max(r3.xyz, abs(r0.xzw));
  r3.xyz = s_image.Sample(smp_linear_s, r5.zw).xyz;
  r4.xyz = r4.xyz + r3.xyz;
  r3.xyz = -r3.xyz + r2.xyz;
  r0.xzw = max(abs(r3.xyz), r0.xzw);
  r3.xyz = -r4.xyz * float3(0.25,0.25,0.25) + r2.xyz;
  r3.xyz = -abs(r3.xyz) * float3(25.5004463,25.5004463,25.5004463) + float3(1,1,1);
  r3.xyz = max(float3(0,0,0), float3(3,3,3) * r3.xyz);
  r0.xzw = -r0.xzw * float3(25.5004463,25.5004463,25.5004463) + float3(1,1,1);
  r0.xzw = max(float3(0,0,0), float3(3,3,3) * r0.xzw);
  r0.xzw = r3.xyz * r0.xzw;
  r3.xyz = r4.xyz * float3(0.25,0.25,0.25) + -r2.xyz;
  r0.xzw = r0.xzw * r3.xyz + r2.xyz;
  r0.y = cmp(0.00100000005 >= r0.y);
  r0.y = r0.y ? 1.000000 : 0;
  r0.xzw = r0.xzw + -r1.xyz;
  r0.xyz = r0.yyy * r0.xzw + r1.xyz;
  r0.w = floor(shader_param_8.x);
  r1.x = frac(shader_param_8.x);
  r0.w = cmp(r0.w < 0.00999999978);
  r1.y = -0.5 + v0.x;
  r1.z = screen_res.x / screen_res.y;
  r2.x = r1.y * r1.z + 0.5;
  r1.y = floor(shader_param_7.x);
  r1.z = -r1.y * 0.0500000007 + 5;
  r1.z = max(1, r1.z);
  r1.z = min(5, r1.z);
  r2.y = v0.y * r1.z;
  r1.z = cmp(0.0989999995 < r1.x);
  r1.w = cmp(r1.x < 0.100999996);
  r1.z = r1.w ? r1.z : 0;
  if (r1.z != 0) {
    r3.y = r1.y * 0.00999999978 + -0.5;
    r3.x = 0.5;
    r1.zw = -r3.xy + r2.xy;
    r1.z = dot(r1.zw, r1.zw);
    r1.z = sqrt(r1.z);
    r1.w = frac(shader_param_7.y);
    r1.z = cmp(r1.w >= r1.z);
    r1.z = r1.z ? 1.000000 : 0;
  } else {
    r1.w = cmp(0.109000005 < r1.x);
    r2.z = cmp(r1.x < 0.111000001);
    r1.w = r1.w ? r2.z : 0;
    if (r1.w != 0) {
      r3.y = r1.y * 0.00999999978 + -0.5;
      r3.x = 0.25;
      r2.zw = -r3.xy + r2.xy;
      r1.w = dot(r2.zw, r2.zw);
      r1.w = sqrt(r1.w);
      r2.z = frac(shader_param_7.y);
      r1.w = cmp(r2.z >= r1.w);
      r1.z = r1.w ? 1.000000 : 0;
    } else {
      r1.w = cmp(0.119000003 < r1.x);
      r2.z = cmp(r1.x < 0.121000007);
      r1.w = r1.w ? r2.z : 0;
      if (r1.w != 0) {
        r3.y = r1.y * 0.00999999978 + -0.5;
        r3.x = 0.75;
        r2.zw = -r3.xy + r2.xy;
        r1.w = dot(r2.zw, r2.zw);
        r1.w = sqrt(r1.w);
        r2.z = frac(shader_param_7.y);
        r1.w = cmp(r2.z >= r1.w);
        r1.z = r1.w ? 1.000000 : 0;
      } else {
        r1.w = cmp(0.199000001 < r1.x);
        r2.z = cmp(r1.x < 0.201000005);
        r1.w = r1.w ? r2.z : 0;
        if (r1.w != 0) {
          r3.yw = r1.yy * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
          r3.xz = float2(0.25,0.75);
          r3.xyzw = -r3.xyzw + r2.xyxy;
          r1.w = dot(r3.xy, r3.xy);
          r1.w = sqrt(r1.w);
          r2.z = frac(shader_param_7.y);
          r1.w = cmp(r2.z >= r1.w);
          r2.w = dot(r3.zw, r3.zw);
          r2.w = sqrt(r2.w);
          r2.z = cmp(r2.z >= r2.w);
          r1.w = (int)r1.w | (int)r2.z;
          r1.z = r1.w ? 1.000000 : 0;
        } else {
          r1.w = cmp(0.398999989 < r1.x);
          r1.x = cmp(r1.x < 0.401000023);
          r1.x = r1.x ? r1.w : 0;
          r3.yw = r1.yy * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
          r3.xz = float2(0.0500000007,0.300000012);
          r4.xyzw = -r3.xyzw + r2.xyxy;
          r1.y = dot(r4.xy, r4.xy);
          r1.y = sqrt(r1.y);
          r1.w = frac(shader_param_7.y);
          r1.y = cmp(r1.w >= r1.y);
          r2.z = dot(r4.zw, r4.zw);
          r2.z = sqrt(r2.z);
          r2.z = cmp(r1.w >= r2.z);
          r1.y = (int)r1.y | (int)r2.z;
          r4.xz = float2(0.699999988,0.949999988);
          r4.yw = r3.ww;
          r2.xyzw = -r4.xyzw + r2.xyxy;
          r2.x = dot(r2.xy, r2.xy);
          r2.x = sqrt(r2.x);
          r2.x = cmp(r1.w >= r2.x);
          r2.y = dot(r2.zw, r2.zw);
          r2.y = sqrt(r2.y);
          r1.w = cmp(r1.w >= r2.y);
          r1.w = (int)r1.w | (int)r2.x;
          r1.y = (int)r1.w | (int)r1.y;
          r1.x = r1.x ? r1.y : 0;
          r1.z = r1.x ? 1.000000 : 0;
        }
      }
    }
  }
  r1.x = cmp(r1.z == 0.000000);
  r0.w = r0.w ? r1.x : 0;
  if (r0.w != 0) {
    r1.xyzw = s_ssfx_bloom.Sample(smp_rtlinear_s, v0.xy).xyzw;
    r1.xyz = r1.xyz * r1.www;
    r2.xyz = max(float3(0,0,0), r0.xyz);
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(2.20000005,2.20000005,2.20000005) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r1.xyz = max(float3(0,0,0), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(2.20000005,2.20000005,2.20000005) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r2.xyz + r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.454545438,0.454545438,0.454545438) * r1.xyz;
    r0.xyz = exp2(r1.xyz);
  }
  // Force HDR path: skip SDR-only adjustments
  r0.w = 0;
  if (r0.w != 0) {
    r1.xyz = pp_img_corrections.xxx * r0.xyz;
    r0.w = dot(r1.xyz, float3(0.212500006,0.715399981,0.0720999986));
    r2.xy = float2(3.5,0.262500018) * r0.ww;
  r2.xy = max(float2(0,0), r2.xy);
    r3.xyz = pp_img_cg.xyz * r2.xxx;
    r0.w = saturate(r0.w * 1.75 + -0.5);
    r0.w = r0.w + r0.w;
    r2.xzw = -r2.xxx * pp_img_cg.xyz + float3(1,1,1);
    r2.xzw = r0.www * r2.xzw + r3.xyz;
    r3.xyz = cmp(float3(0,0,0) < pp_img_cg.xyz);
    r0.w = (int)r3.y | (int)r3.x;
    r0.w = (int)r3.z | (int)r0.w;
    r2.xzw = -r0.xyz * pp_img_corrections.xxx + r2.xzw;
  r2.xyz = max(float3(0,0,0), r2.yyy * r2.xzw + r1.xyz);
    r1.xyz = r0.www ? r2.xyz : r1.xyz;
    r0.w = dot(r1.xyz, float3(0.212500006,0.715399981,0.0720999986));
    r1.w = 1 + -pp_img_corrections.z;
    r2.xyz = r0.www + -r1.xyz;
  r1.xyz = max(float3(0,0,0), r1.www * r2.xyz + r1.xyz);
    r0.w = 0.949999988 / pp_img_corrections.y;
    r1.xyz = log2(r1.xyz);
    r1.xyz = r1.xyz * r0.www;
    r1.xyz = exp2(r1.xyz);
    r0.w = 63 * r1.z;
    r0.w = frac(r0.w);
    r2.xy = r1.xy * float2(0.0153808594,0.0579044111) + float2(0.000122070312,0.000459558825);
    r1.w = r1.z * 63 + -r0.w;
    r3.x = r1.w * 0.015625 + r2.x;
    r3.yw = ssfx_lut.yy * float2(0.0588235296,0.0588235296) + r2.yy;
    r2.xyz = s_lut_atlas.SampleLevel(smp_linear_s, r3.xy, 0).xyz;
    r3.z = 0.015625 + r3.x;
    r3.xyz = s_lut_atlas.SampleLevel(smp_linear_s, r3.zw, 0).xyz;
    r3.xyz = r3.xyz + -r2.xyz;
    r2.xyz = r0.www * r3.xyz + r2.xyz;
    r2.xyz = r2.xyz + -r1.xyz;
    r0.xyz = ssfx_lut.xxx * r2.xyz + r1.xyz;
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}