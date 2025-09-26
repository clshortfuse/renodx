#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Sep 24 13:51:42 2025

cbuffer dx11_cb1 : register(b1)
{
  float4 HSV : packoffset(c0);
  float3 ColorBalance : packoffset(c1);
  float EmissiveBloomStrength : packoffset(c1.w);
  float2 InvDownSampleSize : packoffset(c2);
  float2 InvWindowSize : packoffset(c2.z);
  float2 BloomToScreenScale : packoffset(c3);
  float BrightThreshold : packoffset(c3.z);
  float MiddleGrey : packoffset(c3.w);
  float LumWhite2 : packoffset(c4);
}

SamplerState MainScene_Sampler_s : register(s0);
SamplerState RestoreBloom_Sampler_s : register(s1);
SamplerState ColorCube_Sampler_s : register(s2);
SamplerState AverageLuminanceTexture_Sampler_s : register(s3);
Texture2D<float4> MainScene_Texture : register(t0);
Texture2D<float4> RestoreBloom_Texture : register(t1);
Texture2D<float4> ColorCube_Texture : register(t2);
Texture2D<float4> AverageLuminanceTexture_Texture : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = MainScene_Texture.SampleLevel(MainScene_Sampler_s, v1.xy, 0).xyz;
  r1.xy = BloomToScreenScale.xy * v1.xy;
  r1.xyz = RestoreBloom_Texture.SampleLevel(RestoreBloom_Sampler_s, r1.xy, 0).xyz;
  r0.xyzw = r1.xyzz + r0.xyzz;
  r1.x = AverageLuminanceTexture_Texture.SampleLevel(AverageLuminanceTexture_Sampler_s, float2(0.5,0.5), 0).x;
  r1.x = MiddleGrey / r1.x;
  r0.xyzw = r1.xxxx * r0.xyzw;
  
  float3 untonemapped = r0.xyz;

  // Tonemap with Uncharted2
  r1.xyzw = r0.xyww * float4(0.219999999,0.219999999,0.219999999,0.219999999) + float4(0.0300000012,0.0300000012,0.0300000012,0.0300000012);
  r1.xyzw = r0.xyww * r1.xyzw + float4(0.00200000009,0.00200000009,0.00200000009,0.00200000009);
  r2.xyzw = r0.xyww * float4(0.219999999,0.219999999,0.219999999,0.219999999) + float4(0.300000012,0.300000012,0.300000012,0.300000012);
  r0.xyzw = r0.xyzw * r2.xyzw + float4(0.0600000024,0.0600000024,0.0600000024,0.0600000024);
  r0.xyzw = r1.xyzw / r0.xyzw;
  r0.xyzw = float4(-0.0333333313,-0.0333333313,-0.0333333313,-0.0333333313) + r0.xyzw;
  r0.xyzw = float4(1.1530019,1.1530019,1.1530019,1.1530019) * r0.xyzw;

  // Go to 2.2 Gamma
  r0.xyzw = log2(r0.xyzw);
  r0.xyzw = float4(0.454545468,0.454545468,0.454545468,0.454545468) * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  r0.xyzw = min(float4(1,1,1,1), r0.xyzw);

  // Sample 2D 16x16x16 LUT
  r1.yzw = r0.yxz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r0.xy = float2(0.03125,32) * r1.zw;
  r0.y = floor(r0.y);
  r0.z = 1 + r0.y;
  r0.z = min(31, r0.z);
  r1.x = r0.y * 0.03125 + r0.x;
  r2.xyz = ColorCube_Texture.Sample(ColorCube_Sampler_s, r1.xy).xyz;
  r1.x = r0.z * 0.03125 + r0.x;
  r1.xyz = ColorCube_Texture.Sample(ColorCube_Sampler_s, r1.xy).xyz;
  r0.x = r0.w * 31 + -r0.y;
  r0.yzw = r1.yzx + -r2.yzx;
  r0.xyz = r0.xxx * r0.yzw + r2.yzx;


  r0.w = max(r0.x, r0.y);
  r1.z = max(r0.z, r0.w);
  r0.w = min(r0.x, r0.y);
  r0.w = min(r0.z, r0.w);

  r0.w = r1.z + -r0.w;
  r1.w = cmp(r0.w != 0.000000);
  r2.y = r0.w / r1.z;
  r3.xyz = r0.xyz + -r0.yzx;
  r3.xyz = r3.xyz / r0.www;
  r0.xy = cmp(r0.zx == r1.zz);
  r3.xyz = float3(6,2,4) + r3.xyz;
  r0.y = r0.y ? r3.y : r3.z;
  r2.x = r0.x ? r3.x : r0.y;
  r1.xy = r1.ww ? r2.xy : 0;
  r0.xy = HSV.zy * r1.zy;
  r0.z = cmp(r0.y != 0.000000);
  if (r0.z != 0) {
    r0.w = HSV.x + r1.x;
    r1.x = 6 * r0.w;
    r1.x = cmp(r1.x >= -r1.x);
    r1.xy = r1.xx ? float2(6,0.166666672) : float2(-6,-0.166666672);
    r0.w = r1.y * r0.w;
    r0.w = frac(r0.w);
    r0.w = r1.x * r0.w;
    r0.y = r0.y * r0.x;
    r1.x = r0.w + r0.w;
    r1.x = cmp(r1.x >= -r1.x);
    r1.xy = r1.xx ? float2(2,0.5) : float2(-2,-0.5);
    r1.y = r1.y * r0.w;
    r1.y = frac(r1.y);
    r1.x = r1.x * r1.y + -1;
    r2.y = 1 + -abs(r1.x);
    r3.xyzw = cmp(r0.wwww < float4(1,2,3,4));
    r0.w = cmp(r0.w < 5);
    r2.xz = float2(1,0);
    r1.xyw = r0.www ? r2.yzx : r2.xzy;
    r1.xyw = r3.www ? r2.zyx : r1.xyw;
    r1.xyw = r3.zzz ? r2.zxy : r1.xyw;
    r1.xyw = r3.yyy ? r2.yxz : r1.xyw;
    r1.xyw = r3.xxx ? r2.xyz : r1.xyw;
    r0.w = r1.z * HSV.z + -r0.y;
    r1.xyz = r1.xyw * r0.yyy + r0.www;
  }
  r0.xyz = r0.zzz ? r1.xyz : r0.xxx;
  r0.xyz = ColorBalance.xyz * r0.xyz;
  r0.xyz = float3(-0.0399999991,-0.0399999991,-0.0399999991) + r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = float3(1.31578946,1.31578946,1.31578946) * r0.xyz;
  o0.xyz = min(float3(1,1,1), r0.xyz);

  float3 graded_sdr = renodx::color::srgb::DecodeSafe(o0.xyz);
  o0.rgb = renodx::draw::ToneMapPass(untonemapped, graded_sdr);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

  o0.w = 1;
  return;
}