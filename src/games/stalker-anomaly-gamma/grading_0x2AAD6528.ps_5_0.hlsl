// ---- Created with 3Dmigoto v1.4.1 on Sat Oct 18 17:18:58 2025

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
Texture2D<float4> s_distort : register(t4);


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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 / screen_res.x;
  r0.y = s_position.Sample(smp_nofilter_s, v0.xy).z;
  r1.xyz = s_distort.Sample(smp_nofilter_s, v0.xy).xyz;
  r0.zw = float2(-0.498039216,-0.498039216) + r1.xy;
  r0.zw = r0.zw * float2(0.0500000007,0.0500000007) + v0.xy;
  r1.x = s_position.Sample(smp_nofilter_s, r0.zw).z;
  r1.x = 0.00100000005 + r1.x;
  r1.x = cmp(r1.x < r0.y);
  r0.zw = r1.xx ? v0.xy : r0.zw;
  r1.xy = screen_res.xy * r0.zw;
  r2.xy = (int2)r1.xy;
  r2.zw = float2(0,0);
  r1.xyw = s_image.Load(r2.xyz).xyz;
  r2.xyzw = s_ssfx_bloom.Sample(smp_rtlinear_s, r0.zw).xyzw;
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
  r3.xy = float2(12,78) + timers.xx;
  r0.w = dot(v0.xy, r3.xy);
  r0.w = sin(r0.w);
  r0.w = 43758 * r0.w;
  r0.w = frac(r0.w);
  r0.z = r0.w * 0.25 + r0.z;
  r0.w = r0.z * 34 + 1;
  r0.z = r0.w * r0.z;
  r0.w = 0.00346020772 * r0.z;
  r0.w = floor(r0.w);
  r0.z = -r0.w * 289 + r0.z;
  sincos(r0.z, r3.x, r4.x);
  r0.w = r0.z * 34 + 1;
  r0.z = r0.w * r0.z;
  r0.w = 0.00346020772 * r0.z;
  r0.w = floor(r0.w);
  r0.z = -r0.w * 289 + r0.z;
  r0.w = r0.z * r0.x;
  r0.w = 0.020166669 * r0.w;
  r4.y = r3.x;
  r3.xy = r0.ww * r4.xy + v0.xy;
  r3.xyz = s_image.Sample(smp_linear_s, r3.xy).xyz;
  r5.xyz = -r3.xyz + r1.xyw;
  // Prevent detail from being added into r0.xzw/r3: neutralize compose
  r0.xzw = r3.xyz;
  r4.xyz = r5.xyz * float3(0.25,0.25,0.25) + -r3.xyz;
  r0.xzw = r3.xyz;
  r6.xyz = -r6.xyz + r1.xyw;
  r5.xyz = max(abs(r6.xyz), abs(r5.xyz));
  r6.xyzw = float4(-1,1,1,-1) * r4.xyxy;
  r7.xyzw = r0.wwww * r6.xyzw + v0.xyxy;
  r8.xyz = s_image.Sample(smp_linear_s, r7.xy).xyz;
  r3.xyz = r8.xyz + r3.xyz;
  r8.xyz = -r8.xyz + r1.xyw;
  r5.xyz = max(abs(r8.xyz), r5.xyz);
  r7.xyz = s_image.Sample(smp_linear_s, r7.zw).xyz;
  r3.xyz = r7.xyz + r3.xyz;
  r7.xyz = -r7.xyz + r1.xyw;
  r5.xyz = max(abs(r7.xyz), r5.xyz);
  r7.xyz = -r3.xyz * float3(0.25,0.25,0.25) + r1.xyw;
  r7.xyz = -abs(r7.xyz) * float3(25.5004463,25.5004463,25.5004463) + float3(1,1,1);
  r7.xyz = max(float3(0,0,0), float3(3,3,3) * r7.xyz);
  r5.xyz = -r5.xyz * float3(25.5004463,25.5004463,25.5004463) + float3(1,1,1);
  r5.xyz = max(float3(0,0,0), float3(3,3,3) * r5.xyz);
  r5.xyz = r7.xyz * r5.xyz;
  r3.xyz = r3.xyz * float3(0.25,0.25,0.25) + -r1.xyw;
  // Sharpening disabled at scale 1: use base color only
  r3.xyz = r1.xyw;
  r0.w = r0.z * 34 + 1;
  r0.z = r0.w * r0.z;
  r0.w = 0.00346020772 * r0.z;
  r0.w = floor(r0.w);
  r0.z = -r0.w * 289 + r0.z;
  r0.w = r0.z * r0.x;
  r0.w = 0.0806666762 * r0.w;
  r4.zw = r0.ww * r4.xy + v0.xy;
  r5.xyz = s_image.Sample(smp_linear_s, r4.zw).xyz;
  r7.xyz = -r5.xyz + r3.xyz;
  r4.zw = r0.ww * -r4.xy + v0.xy;
  r8.xyz = s_image.Sample(smp_linear_s, r4.zw).xyz;
  r5.xyz = r8.xyz + r5.xyz;
  r8.xyz = -r8.xyz + r3.xyz;
  r7.xyz = max(abs(r8.xyz), abs(r7.xyz));
  r8.xyzw = r0.wwww * r6.xyzw + v0.xyxy;
  r9.xyz = s_image.Sample(smp_linear_s, r8.xy).xyz;
  r5.xyz = r9.xyz + r5.xyz;
  r9.xyz = -r9.xyz + r3.xyz;
  r7.xyz = max(abs(r9.xyz), r7.xyz);
  r8.xyz = s_image.Sample(smp_linear_s, r8.zw).xyz;
  r5.xyz = r8.xyz + r5.xyz;
  r8.xyz = -r8.xyz + r3.xyz;
  r7.xyz = max(abs(r8.xyz), r7.xyz);
  r8.xyz = -r5.xyz * float3(0.25,0.25,0.25) + r3.xyz;
  r8.xyz = -abs(r8.xyz) * float3(25.5004463,25.5004463,25.5004463) + float3(1,1,1);
  r8.xyz = max(float3(0,0,0), float3(3,3,3) * r8.xyz);
  r7.xyz = -r7.xyz * float3(25.5004463,25.5004463,25.5004463) + float3(1,1,1);
  r7.xyz = max(float3(0,0,0), float3(3,3,3) * r7.xyz);
  r7.xyz = r8.xyz * r7.xyz;
  r5.xyz = r5.xyz * float3(0.25,0.25,0.25) + -r3.xyz;
  // Sharpening disabled at scale 2: use base color only
  r3.xyz = r1.xyw;
  r0.w = r0.z * 34 + 1;
  r0.z = r0.w * r0.z;
  r0.w = 0.00346020772 * r0.z;
  r0.w = floor(r0.w);
  r0.z = -r0.w * 289 + r0.z;
  r0.x = r0.z * r0.x;
  r0.x = 0.181500003 * r0.x;
  r0.zw = r0.xx * r4.xy + v0.xy;
  r5.xyz = s_image.Sample(smp_linear_s, r0.zw).xyz;
  r7.xyz = -r5.xyz + r3.xyz;
  r0.zw = r0.xx * -r4.xy + v0.xy;
  r4.xyz = s_image.Sample(smp_linear_s, r0.zw).xyz;
  r5.xyz = r5.xyz + r4.xyz;
  r4.xyz = -r4.xyz + r3.xyz;
  r4.xyz = max(abs(r7.xyz), abs(r4.xyz));
  r6.xyzw = r0.xxxx * r6.xyzw + v0.xyxy;
  r0.xzw = s_image.Sample(smp_linear_s, r6.xy).xyz;
  r5.xyz = r5.xyz + r0.xzw;
  r0.xzw = r3.xyz + -r0.xzw;
  r0.xzw = max(r4.xyz, abs(r0.xzw));
  r4.xyz = s_image.Sample(smp_linear_s, r6.zw).xyz;
  r5.xyz = r5.xyz + r4.xyz;
  r4.xyz = -r4.xyz + r3.xyz;
  r0.xzw = max(abs(r4.xyz), r0.xzw);
  r4.xyz = -r5.xyz * float3(0.25,0.25,0.25) + r3.xyz;
  r4.xyz = -abs(r4.xyz) * float3(25.5004463,25.5004463,25.5004463) + float3(1,1,1);
  r4.xyz = max(float3(0,0,0), float3(3,3,3) * r4.xyz);
  r0.xzw = -r0.xzw * float3(25.5004463,25.5004463,25.5004463) + float3(1,1,1);
  r0.xzw = max(float3(0,0,0), float3(3,3,3) * r0.xzw);
  r0.xzw = r4.xyz * r0.xzw;
  r4.xyz = r5.xyz * float3(0.25,0.25,0.25) + -r3.xyz;
  r0.xzw = r0.xzw * r4.xyz + r3.xyz;
  r0.y = cmp(0.00100000005 >= r0.y);
  r0.y = r0.y ? 1.000000 : 0;
  r0.xzw = r0.xzw + -r1.xyw;
  // Use base color for r0.xyz (avoid adding detail back)
  r0.xyz = r1.xyw;
  r0.w = floor(shader_param_8.x);
  r1.x = frac(shader_param_8.x);
  r0.w = cmp(r0.w < 0.00999999978);
  r1.y = -0.5 + v0.x;
  r1.w = screen_res.x / screen_res.y;
  r3.x = r1.y * r1.w + 0.5;
  r1.y = floor(shader_param_7.x);
  r1.w = -r1.y * 0.0500000007 + 5;
  r1.w = max(1, r1.w);
  r1.w = min(5, r1.w);
  r3.y = v0.y * r1.w;
  r1.w = cmp(0.0989999995 < r1.x);
  r3.z = cmp(r1.x < 0.100999996);
  r1.w = r1.w ? r3.z : 0;
  if (r1.w != 0) {
    r4.y = r1.y * 0.00999999978 + -0.5;
    r4.x = 0.5;
    r3.zw = -r4.xy + r3.xy;
    r1.w = dot(r3.zw, r3.zw);
    r1.w = sqrt(r1.w);
    r3.z = frac(shader_param_7.y);
    r1.w = cmp(r3.z >= r1.w);
    r1.w = r1.w ? 1.000000 : 0;
  } else {
    r3.z = cmp(0.109000005 < r1.x);
    r3.w = cmp(r1.x < 0.111000001);
    r3.z = r3.w ? r3.z : 0;
    if (r3.z != 0) {
      r4.y = r1.y * 0.00999999978 + -0.5;
      r4.x = 0.25;
      r3.zw = -r4.xy + r3.xy;
      r3.z = dot(r3.zw, r3.zw);
      r3.z = sqrt(r3.z);
      r3.w = frac(shader_param_7.y);
      r3.z = cmp(r3.w >= r3.z);
      r1.w = r3.z ? 1.000000 : 0;
    } else {
      r3.z = cmp(0.119000003 < r1.x);
      r3.w = cmp(r1.x < 0.121000007);
      r3.z = r3.w ? r3.z : 0;
      if (r3.z != 0) {
        r4.y = r1.y * 0.00999999978 + -0.5;
        r4.x = 0.75;
        r3.zw = -r4.xy + r3.xy;
        r3.z = dot(r3.zw, r3.zw);
        r3.z = sqrt(r3.z);
        r3.w = frac(shader_param_7.y);
        r3.z = cmp(r3.w >= r3.z);
        r1.w = r3.z ? 1.000000 : 0;
      } else {
        r3.z = cmp(0.199000001 < r1.x);
        r3.w = cmp(r1.x < 0.201000005);
        r3.z = r3.w ? r3.z : 0;
        if (r3.z != 0) {
          r4.yw = r1.yy * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
          r4.xz = float2(0.25,0.75);
          r4.xyzw = -r4.xyzw + r3.xyxy;
          r3.z = dot(r4.xy, r4.xy);
          r3.z = sqrt(r3.z);
          r3.w = frac(shader_param_7.y);
          r3.z = cmp(r3.w >= r3.z);
          r4.x = dot(r4.zw, r4.zw);
          r4.x = sqrt(r4.x);
          r3.w = cmp(r3.w >= r4.x);
          r3.z = (int)r3.w | (int)r3.z;
          r1.w = r3.z ? 1.000000 : 0;
        } else {
          r3.z = cmp(0.398999989 < r1.x);
          r1.x = cmp(r1.x < 0.401000023);
          r1.x = r1.x ? r3.z : 0;
          r4.yw = r1.yy * float2(0.00999999978,0.00999999978) + float2(-0.5,-0.5);
          r4.xz = float2(0.0500000007,0.300000012);
          r5.xyzw = -r4.xyzw + r3.xyxy;
          r1.y = dot(r5.xy, r5.xy);
          r1.y = sqrt(r1.y);
          r3.z = frac(shader_param_7.y);
          r1.y = cmp(r3.z >= r1.y);
          r3.w = dot(r5.zw, r5.zw);
          r3.w = sqrt(r3.w);
          r3.w = cmp(r3.z >= r3.w);
          r1.y = (int)r1.y | (int)r3.w;
          r5.xz = float2(0.699999988,0.949999988);
          r5.yw = r4.ww;
          r4.xyzw = -r5.xyzw + r3.xyxy;
          r3.x = dot(r4.xy, r4.xy);
          r3.x = sqrt(r3.x);
          r3.y = dot(r4.zw, r4.zw);
          r3.y = sqrt(r3.y);
          r3.xy = cmp(r3.zz >= r3.xy);
          r3.x = (int)r3.y | (int)r3.x;
          r1.y = (int)r1.y | (int)r3.x;
          r1.x = r1.x ? r1.y : 0;
          r1.w = r1.x ? 1.000000 : 0;
        }
      }
    }
  }
  r1.x = cmp(r1.w == 0.000000);
  r0.w = r0.w ? r1.x : 0;
  if (r0.w != 0) {
    r1.xyw = r2.xyz * r2.www;
    r3.xyz = max(float3(0,0,0), r0.xyz);
    r3.xyz = log2(r3.xyz);
    r3.xyz = float3(2.20000005,2.20000005,2.20000005) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r1.xyw = max(float3(0,0,0), r1.xyw);
    r1.xyw = log2(r1.xyw);
    r1.xyw = float3(2.20000005,2.20000005,2.20000005) * r1.xyw;
    r1.xyw = exp2(r1.xyw);
    r1.xyw = r3.xyz + r1.xyw;
    r1.xyw = log2(r1.xyw);
    r1.xyw = float3(0.454545438,0.454545438,0.454545438) * r1.xyw;
    r0.xyz = exp2(r1.xyw);
  }
  // Force HDR path: skip SDR-only adjustments
  r0.w = 0;
  if (r0.w != 0) {
    r1.xyw = pp_img_corrections.xxx * r0.xyz;
    r0.w = dot(r1.xyw, float3(0.212500006,0.715399981,0.0720999986));
    r3.xy = float2(3.5,0.262500018) * r0.ww;
    r3.xy = saturate(r3.xy);
    r4.xyz = pp_img_cg.xyz * r3.xxx;
  // Unclamped SDR remap (allow HDR values through)
  r0.w = r0.w * 1.75 + -0.5;
  r0.w = r0.w + r0.w;
    r3.xzw = -r3.xxx * pp_img_cg.xyz + float3(1,1,1);
    r3.xzw = r0.www * r3.xzw + r4.xyz;
    r4.xyz = cmp(float3(0,0,0) < pp_img_cg.xyz);
    r0.w = (int)r4.y | (int)r4.x;
    r0.w = (int)r4.z | (int)r0.w;
    r3.xzw = -r0.xyz * pp_img_corrections.xxx + r3.xzw;
  // Use unclamped pre-LUT color so we don't force [0,1] SDR clamping
  r3.xyz = r3.yyy * r3.xzw + r1.xyw;
  r1.xyw = r0.www ? r3.xyz : r1.xyw;
    r0.w = dot(r1.xyw, float3(0.212500006,0.715399981,0.0720999986));
    r2.w = 1 + -pp_img_corrections.z;
    r3.xyz = r0.www + -r1.xyw;
  // Compose without clamping to allow HDR range
  r1.xyw = r2.www * r3.xyz + r1.xyw;
    r0.w = 0.949999988 / pp_img_corrections.y;
    r1.xyw = log2(r1.xyw);
    r1.xyw = r1.xyw * r0.www;
    r1.xyw = exp2(r1.xyw);
    r0.w = 63 * r1.w;
    r0.w = frac(r0.w);
    r3.xy = r1.xy * float2(0.0153808594,0.0579044111) + float2(0.000122070312,0.000459558825);
    r2.w = r1.w * 63 + -r0.w;
    r4.x = r2.w * 0.015625 + r3.x;
  // Bypass LUT: output the pre-LUT computed color instead of sampling LUT atlas
  // Use r1.xyw which contains pre-LUT color/base composition earlier in the shader
  r0.xyz = r1.xyw;
  }
  // Final output: use base post-LUT/pre-LUT composition (disable any added detail)
  // r1.xyw contains bloom/extra; r0.xyz is the composed base color — use r0 directly
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}