// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// resourceTables__passData__smpPointClamp    sampler      NA          NA             s0      1
// resourceTables__passData__smpLinearClamp    sampler      NA          NA             s1      1
// resourceTables__passData__smpCompare  sampler_c      NA          NA             s3      1
// resourceTables__passData.LUTTexture    texture  float4          3d             t0      1
// resourceTables__passData.InputLuminanceLocal    texture   float          2d             t1      1
// resourceTables__passData.InputDepth    texture   float          2d             t2      1
// resourceTables__passData.InputColor    texture  float4          2d             t3      1
// resourceTables__passData.InputBloom    texture  float4          2d             t4      1
// resourceTables__passData.InputBlurredSurface    texture  float4          2d             t6      1
// resourceTables__passData.InputTransparents    texture  float4          2d            t12      1
// resourceTables__passData.InputTransparentsLowRes    texture  float4          2d            t13      1
// resourceTables__passData.InputRefraction    texture  float4          2d            t14      1
// resourceTables__passData.NoiseTexture    texture   float     2darray            t17      1
// resourceTables__passData.BilateralVectorsTex    texture  float2          2d            t18      1
// resourceTables__passData.InputProperties    texture  float4          2d            t21      1
// resourceTables__passData.OutRejectionFactor        UAV   float          2d             u9      1
// ConstBuf__passData                cbuffer      NA          NA            cb0      1

#include "./common.hlsli"

RWTexture2D<float4> u9 : register(u9);  // decompiler missed this

Texture2D<float4> t21 : register(t21);

Texture2D<float4> t18 : register(t18);

Texture2DArray<float4> t17 : register(t17);

Texture2D<float4> t14 : register(t14);

Texture2D<float4> t13 : register(t13);

Texture2D<float4> t12 : register(t12);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t0 : register(t0);

SamplerComparisonState s3_s : register(s3);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[31];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u9
  float4 r0, r1, r2, r3, r4, r5, r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (uint2)v0.xy;
  r0.zw = float2(0, 0);
  r1.xy = t18.Load(r0.xyw).xy;
  r1.xy = cb0[2].zw * r1.xy;
  r2.xyz = t6.SampleLevel(s1_s, v1.xy, 0).xyz;
  r1.xy = r1.xy * float2(8, 8) + v1.xy;
  r1.z = t6.SampleLevel(s1_s, r1.xy, 0).w;
  r1.w = cmp(r1.z < 1);
  if (r1.w != 0) {
    r3.xyz = t14.SampleLevel(s1_s, r1.xy, 0).xyw;
    r4.xy = float2(1, -1) * r3.xy;
    r1.w = dot(r3.xy, r3.xy);
    r1.w = cmp(r1.w != 0.000000);
    if (r1.w != 0) {
      r5.xyzw = t14.Gather(s0_s, v1.xy).xyzw;
      r1.w = min(r5.y, r5.z);
      r1.w = min(r5.x, r1.w);
      r1.w = min(r1.w, r5.w);
      r1.w = max(1, -r1.w);
      r1.w = r3.z / r1.w;
      r3.xy = (int2)r0.xy & int2(63, 63);
      r3.z = 7 & asint(cb0[14].w);
      r3.w = 0;
      r2.w = t17.Load(r3.xyzw).x;
      r3.x = 0.25 * r2.w;
      r3.yz = r4.xy * r3.xx + v1.xy;
      r3.y = t2.SampleCmpLevelZero(s3_s, r3.yz, r1.w).x;
      r5.xyz = r2.www * float3(0.25, 0.25, 0.25) + float3(0.25, 0.5, 0.75);
      r6.xyzw = r4.xyxy * r5.xxyy + v1.xyxy;
      r2.w = t2.SampleCmpLevelZero(s3_s, r6.xy, r1.w).x;
      r3.z = t2.SampleCmpLevelZero(s3_s, r6.zw, r1.w).x;
      r4.zw = r4.xy * r5.zz + v1.xy;
      r1.w = t2.SampleCmpLevelZero(s3_s, r4.zw, r1.w).x;
      r3.y = cmp(0 >= r3.y);
      r3.x = r3.y ? r3.x : 0;
      r2.w = cmp(0 >= r2.w);
      r2.w = r2.w ? r5.x : r3.x;
      r3.x = cmp(0 >= r3.z);
      r2.w = r3.x ? r5.y : r2.w;
      r1.w = cmp(0 >= r1.w);
      r1.w = r1.w ? r5.z : r2.w;
    } else {
      r1.w = 0;
    }
    r3.xy = r4.xy * r1.ww + v1.xy;
    r3.xyz = t3.SampleLevel(s1_s, r3.xy, 0).xyz;
    r4.xyzw = t12.SampleLevel(s1_s, v1.xy, 0).xyzw;
    r4.xyzw = max(float4(0, 0, 0, 0), r4.xyzw);
    r5.xyzw = t13.SampleLevel(s1_s, r1.xy, 0).xyzw;
    r5.xyzw = max(float4(0, 0, 0, 0), r5.xyzw);
    r1.x = r5.w * r4.w;
    r4.xyz = r4.xyz * r5.www + r5.xyz;
    r1.y = r4.y + -r3.y;
    r1.y = saturate(cb0[29].z * r1.y);
    r1.x = min(1, r1.x);
    r3.xyz = r3.xyz * r1.xxx + r4.xyz;
    r1.z = saturate(r1.z);
    r1.x = max(r3.y, r3.z);
    r1.x = max(r3.x, r1.x);
    r1.x = 1 + r1.x;
    r1.x = rcp(r1.x);
    r4.xyz = r3.xyz * r1.xxx;
    r3.xyz = -r3.xyz * r1.xxx + r2.xyz;
    r2.xyz = r1.zzz * r3.xyz + r4.xyz;
  } else {
    r1.y = 0;
  }
  r1.x = max(r2.y, r2.z);
  r1.x = max(r2.x, r1.x);
  r1.x = 1 + -r1.x;
  r1.x = rcp(r1.x);
  r2.xyz = r2.xyz * r1.xxx;
  r1.x = cmp(0 != cb0[21].w);
  if (r1.x != 0) {
    r1.x = t1.SampleLevel(s1_s, v1.xy, 0).x;
    r1.x = exp2(r1.x);
    r3.xyz = r2.xyz * r1.xxx;
  } else {
    r3.xyz = cb0[22].xxx * r2.xyz;
  }
  r2.xyz = t4.SampleLevel(s1_s, v1.xy, 0).xyz;

  r2.rgb *= CUSTOM_BLOOM;

  r2.xyz = cb0[1].zzz * r2.xyz + r3.xyz;
  r1.xw = -cb0[14].yz + v0.xy;
  r1.x = dot(r1.xw, r1.xw);
  r1.x = cb0[14].x * r1.x;
  r1.x = r1.x * r1.x;
  r1.x = cb0[13].z * r1.x;
  r1.x = exp2(-r1.x);
  r2.xyz = r2.xyz * r1.xxx;
  r3.xyz = cb0[20].xyz * r2.yyy;
  r2.xyw = r2.xxx * cb0[19].xyz + r3.xyz;
  r2.xyz = r2.zzz * cb0[21].xyz + r2.xyw;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  r3.xyzw = -cb0[12].wxyz + float4(1, 1, 1, 1);
  r1.x = cb0[13].y * v1.x;
  r1.x = v1.y * r1.x;
  r4.xy = float2(1, 1) + -v1.xy;
  r1.x = r4.x * r1.x;
  r1.x = r1.x * r4.y;
  r1.x = log2(abs(r1.x));
  r1.x = cb0[13].x * r1.x;
  r1.x = exp2(r1.x);
  r1.x = saturate(r3.x * r1.x + cb0[12].w);
  r3.xyz = r1.xxx * r3.yzw + cb0[12].xyz;
  r2.xyz = r3.xyz * r2.xyz;
  r1.x = cmp(0 != cb0[0].w);
  r2.xyz = r1.xxx ? float3(0, 0, 0) : r2.xyz;

  // r2.rgb = renodx::color::grade::UserColorGrading(
  //     r2.rgb,
  //     RENODX_TONE_MAP_EXPOSURE,
  //     RENODX_TONE_MAP_HIGHLIGHTS,
  //     RENODX_TONE_MAP_SHADOWS,
  //     RENODX_TONE_MAP_CONTRAST,
  //     1.f,   // saturation, applied later
  //     0.f,   // dechroma, applied later
  //     0.f);  // hue correction, applied later
  r2.rgb = ApplyExposureContrastFlareHighlightsShadowsByLuminance(r2.rgb);

  float3 lut_input_color = r2.rgb;

  // arri encode
  r3.xyz = cmp(float3(0.0105910003, 0.0105910003, 0.0105910003) < r2.xyz);
  r4.xyzw = r2.xxyy * float4(5.55555582, 5.3676548, 5.55555582, 5.3676548) + float4(0.0522719994, 0.0928089991, 0.0522719994, 0.0928089991);
  r1.xw = log2(r4.xz);
  r1.xw = r1.xw * float2(0.0744116008, 0.0744116008) + float2(0.385536999, 0.385536999);
  r4.xy = r3.xy ? r1.xw : r4.yw;
  r1.xw = r2.zz * float2(5.55555582, 5.3676548) + float2(0.0522719994, 0.0928089991);
  r1.x = log2(r1.x);
  r1.x = r1.x * 0.0744116008 + 0.385536999;
  r4.z = r3.z ? r1.x : r1.w;

  // sample LUT
  r2.xyz = r4.xyz * float3(0.984375, 0.984375, 0.984375) + float3(0.0078125, 0.0078125, 0.0078125);
  r2.xyz = t0.SampleLevel(s1_s, r2.xyz, 0).xyz;

  // arri decode
  r3.xyz = cmp(float3(0.149658203, 0.149658203, 0.149658203) < r2.xyz);
  r4.xyzw = float4(-0.385536999, -0.0928089991, -0.385536999, -0.0928089991) + r2.xxyy;
  r4.xyzw = float4(13.4387865, 0.186301097, 13.4387865, 0.186301097) * r4.xyzw;
  r2.xyw = exp2(r4.xzx);
  r2.xyw = float3(-0.0522719994, -0.0522719994, -0.0522719994) + r2.xyw;
  r2.xyw = float3(0.179999992, 0.179999992, 0.179999992) * r2.xyw;
  r4.xyw = r3.xyx ? r2.xyw : r4.ywy;
  r1.xw = float2(-0.385536999, -0.0928089991) + r2.zz;
  r1.xw = float2(13.4387865, 0.186301097) * r1.xw;
  r1.x = exp2(r1.x);
  r1.x = -0.0522719994 + r1.x;
  r1.x = 0.179999992 * r1.x;
  r4.z = r3.z ? r1.x : r1.w;
  r2.xyzw = r4.xyzw;

  if (RENODX_COLOR_GRADE_SCALING) {
    float3 min_black = renodx::color::arri::logc::c800::Decode(t0.SampleLevel(s1_s, renodx::color::arri::logc::c800::Encode((0.f).xxx) + 0.0078125, 0.0f).rgb);

    float lut_min_y = renodx::color::y::from::BT709(max(0, min_black));
    if (lut_min_y > 0) {
      float lut_mid_ratio = renodx::color::y::from::BT709(renodx::color::arri::logc::c800::Decode(t0.SampleLevel(s1_s, renodx::color::arri::logc::c800::Encode((0.18f).xxx) + 0.0078125, 0.0f).rgb)) / 0.18f;
      float3 corrected_black = renodx::lut::CorrectBlack(lut_input_color * lut_mid_ratio, r2.wyz, lut_min_y, 70.f);
      r2.wyz = lerp(r2.wyz, corrected_black, RENODX_COLOR_GRADE_SCALING);
    }
  }

  float3 lut_output_color = max(0, r2.wyz);

  r2.wyz = lerp(lut_input_color, lut_output_color, RENODX_COLOR_GRADE_STRENGTH);

  r1.x = max(r2.y, r2.z);
  r1.x = max(r2.w, r1.x);
  r3.xyzw = cmp(r2.wyzw < float4(0.180000007, 0.180000007, 0.180000007, 0.180000007));
  r4.xyzw = min(cb0[24].xxxx, r2.wyzw);
  r4.xyzw = log2(r4.xyzw);
  r5.xyzw = cb0[23].wwww * r4.wyzw;
  r5.xyzw = exp2(r5.xyzw);
  r4.xyzw = cb0[24].zzzz * r4.xyzw;
  r4.xyzw = exp2(r4.xyzw);
  r4.xyzw = r4.xyzw * cb0[25].xxxx + cb0[25].yyyy;
  r4.xyzw = r5.xyzw / r4.xyzw;
  r3.xyzw = r3.xyzw ? r4.xyzw : r2.xyzw;
  r1.w = max(r3.y, r3.z);
  r1.w = max(r3.w, r1.w);
  r2.xyzw = r2.xyzw * r1.wwww;
  r2.xyzw = r2.xyzw / r1.xxxx;
  r3.xyzw = r3.xyzw + -r2.wyzw;
  r2.xyzw = cb0[24].wwww * r3.xyzw + r2.xyzw;

  r2.xyzw = max(float4(0, 0, 0, 0), r2.xyzw);
  r2.xyzw = min(float4(7, 7, 7, 7), r2.xyzw);
  r3.xyz = float3(0.25, 0.5, -0.25) * r2.xyw;
  r1.xw = r3.xz + r3.yy;
  r3.x = r2.z * 0.25 + r1.x;
  r3.y = dot(r2.wz, float2(0.5, -0.5));
  r3.z = r2.z * -0.25 + r1.w;
  r1.x = saturate(r1.z * 4 + -1);
  r1.x = -cb0[29].w * r1.x;
  r1.w = cmp(-0.100000001 < r1.x);
  r1.y = cb0[30].x * r1.y;
  r1.x = r1.w ? r1.y : r1.x;
  r1.x = cb0[29].w + r1.x;
  r1.x = cb0[30].z * r1.x;
  r0.z = t21.Load(r0.xyz).w;
  r0.z = r0.z * 255 + 0.5;
  r0.z = (uint)r0.z;
  r0.w = 255 * r1.x;
  r0.w = (int)r0.w;
  r0.zw = (int2)r0.zw & int2(1, 252);
  r0.z = r0.z ? 1 : 0;
  r0.z = (int)r0.w + (int)r0.z;
  r0.w = cmp(0.100000001 < r1.z);
  r0.w = r0.w ? 0.000000 : 0;
  r0.z = (int)r0.w + (int)r0.z;
  r0.z = (int)r0.z;
  r0.z = 0.00392156886 * r0.z;
  // No code for instruction (needs manual fix):
  u9[uint2(r0.xy)] = r0.z;  // store_uav_typed u9.xyzw, r0.xyyy, r0.zzzz
  r0.xyz = float3(0.142857149, 0.142857149, 0.142857149) * r3.xyz;
  r0.x = sqrt(r0.x);
  r0.x = sqrt(r0.x);
  r0.x = 4095 * r0.x;
  r0.x = floor(r0.x);
  r0.xw = float2(0.000244200259, 0.25) * r0.xx;
  r1.x = r0.x * r0.x;
  r1.x = r1.x * r1.x;
  r1.x = rcp(r1.x);
  r1.x = 0.5 * r1.x;
  r0.yz = r1.xx * r0.yz;
  o0.yz = saturate(r0.yz * float2(0.499511242, 0.499511242) + float2(0.499511242, 0.499511242));
  r0.y = frac(r0.w);
  o0.w = 1.33333337 * r0.y;
  o0.x = r0.x;
  return;
}

/*

*/