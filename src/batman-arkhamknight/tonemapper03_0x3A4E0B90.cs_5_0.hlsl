// no motion blur + effect

#include "../common/Open_DRT.hlsl"
#include "../common/aces.hlsl"
#include "../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t4 : register(t4);

SamplerState s0_s : register(s0);

RWTexture2D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float4 cb0[13];
}

cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

[numthreads(16, 16, 1)] void main(uint3 vThreadGroupID : SV_GroupID, uint3 vThreadID : SV_DispatchThreadID) {
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u0
  float4 r0, r1, r2, r3, r4;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 16, 16, 1
  r0.xy = (int2)vThreadID.xy;
  r0.xy = cb0[7].zw + r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0, 0);
  const float3 texture0Input = t0.Load(r0.xyw).rgb;
  r1.xyz = texture0Input.rgb;
  r2.xyzw = t1.Load(r0.xyz).wxyz;
  r1.xyzw = cb0[12].xxxx * r1.zzxy;
  r2.x = saturate(r2.x);
  r0.z = 1 + -r2.x;
  r1.xyzw = r1.xyzw * r0.zzzz + r2.wwyz;
  r2.xyzw = (uint4)r0.xyyx;
  r0.zw = -cb0[7].zw + r2.wz;
  r2.xyzw = cb0[11].xyxx + r2.xyzw;
  r0.zw = float2(0.5, 0.5) + r0.zw;
  r3.xy = float2(2, -2) / cb0[6].xy;
  r0.zw = r0.zw * r3.xy + float2(-1, 1);
  r0.zw = r0.zw * float2(0.5, -0.5) + float2(0.5, 0.5);
  r3.xy = cb0[7].xy * r0.zw;
  r0.zw = r0.zw * float2(2, 2) + float2(-1, -1);
  r0.zw = float2(0.769231021, 0.769231021) * r0.zw;
  r0.z = dot(r0.zw, r0.zw);
  r0.z = 1 + -r0.z;
  r0.z = max(0, r0.z);
  r0.z = r0.z * r0.z + -1;
  r0.z = r0.z * 0.300000012 + 1;
  r3.xyz = t3.SampleLevel(s0_s, r3.xy, 0).xyz;  // bloom
  r0.w = 0.200000003 * cb0[10].x;
  r3.w = cb0[10].x * 0.200000003 + 1;
  r3.xyzw = r3.zzxy * r3.wwww + -r0.wwww;
  r3.xyzw = max(float4(0, 0, 0, 0), r3.xyzw);
  r1.xyzw = r3.xyzw + r1.xyzw;

  const float3 bloomedInput = r1.zwy;
  r0.w = t4.SampleLevel(s0_s, float2(0.5, 0.5), 0).x;
  r1.xyzw = r1.xyzw / r0.wwww;
  r1.xyzw = r1.xyzw * r0.zzzz;
  r3.xyzw = r1.yyzw * float4(0.219999999, 0.219999999, 0.219999999, 0.219999999) + float4(0.0299999993, 0.0299999993, 0.0299999993, 0.0299999993);
  r3.xyzw = r1.yyzw * r3.xyzw + float4(0.00200000009, 0.00200000009, 0.00200000009, 0.00200000009);
  r4.xyzw = r1.yyzw * float4(0.219999999, 0.219999999, 0.219999999, 0.219999999) + float4(0.300000012, 0.300000012, 0.300000012, 0.300000012);
  r1.xyzw = r1.xyzw * r4.xyzw + float4(0.0599999987, 0.0599999987, 0.0599999987, 0.0599999987);
  r1.xyzw = r3.xyzw / r1.xyzw;
  r1.xyzw = float4(-0.0333333351, -0.0333333351, -0.0333333351, -0.0333333351) + r1.xyzw;
  r1.xyzw = max(float4(0, 0, 0, 0), r1.xyzw);
  r1.xyzw = float4(1.66289866, 1.66289866, 1.66289866, 1.66289866) * r1.xyzw;
  r1.xyzw = log2(r1.xyzw);
  r1.xyzw = float4(0.454545468, 0.454545468, 0.454545468, 0.454545468) * r1.xyzw;
  r1.xyzw = exp2(r1.xyzw);
  r1.xyzw = min(float4(1, 1, 1, 1), r1.xyzw);
  r3.xyw = float3(14.9998999, 0.9375, 0.05859375) * r1.xwz;
  r0.z = floor(r3.x);
  r3.x = r0.z * 0.0625 + r3.w;
  r3.xyzw = float4(0.001953125, 0.03125, 0.064453125, 0.03125) + r3.xyxy;
  r0.z = r1.y * 15 + -r0.z;
  r1.xyz = t2.SampleLevel(s0_s, r3.zw, 0).xyz;
  r3.xyz = t2.SampleLevel(s0_s, r3.xy, 0).xyz;
  r1.xyzw = -r3.xyzx + r1.xyzx;
  r1.xyzw = r0.zzzz * r1.xyzw + r3.xyzx;
  r3.xyzw = float4(1, 1, 1, 1) + -r1.wyzw;
  r3.xyzw = r3.xyzw * r3.xyzw;
  r3.xyzw = min(float4(1, 1, 1, 1), r3.xyzw);
  r3.xyzw = cb0[11].zzzz * r3.xyzw;
  r0.z = dot(r2.wyz, float3(23.1406918, 2.66514421, 9.19949627));
  r0.z = cos(r0.z);
  r2.xyzw = r0.zzzz * r2.xyzw;
  r2.xyzw = frac(r2.xyzw);
  r2.xyzw = float4(-0.333999991, -0.333999991, -0.333999991, -0.333999991) + r2.xyzw;
  r2.xyzw = r3.xyzw * r2.xyzw + float4(1, 1, 1, 1);
  r1.xyzw = r2.xyzw * r1.xyzw;

  float4 outputColor = r1.xyzw;
  outputColor.rgb = pow(abs(r0.rgb), 2.2f) * sign(r0.rgb);

  if (injectedData.toneMapperEnum == 0) {
    outputColor.rgb *= 203.f / 80.f;
  } else {
    if (injectedData.toneMapperEnum == 1) {
      outputColor.rgb = bloomedInput.rgb;  // Untonemapped
      outputColor.rgb *= injectedData.gamePaperWhite / 80.f;
    } else {
      float inputY = yFromBT709(bloomedInput.rgb);
      float outputY = yFromBT709(outputColor.rgb);
      outputColor.rgb *= (outputY ? inputY / outputY : 1);
      if (injectedData.toneMapperEnum == 2) {
        outputColor.rgb = aces_rrt_odt(
          outputColor.rgb * 203.f / 80.f,
          0.0001f,  // minY
          48.f * (injectedData.gamePeakWhite / injectedData.gamePaperWhite),
          AP1_2_BT2020_MAT
        );
      } else {
        outputColor.rgb = mul(BT709_2_BT2020_MAT, outputColor.rgb);
        outputColor.rgb = open_drt_transform_custom(
          outputColor.rgb * 203.f / 80.f,
          100.f * (injectedData.gamePeakWhite / injectedData.gamePaperWhite),
          0
        );
      }
      outputColor.rgb = mul(BT2020_2_BT709_MAT, outputColor.rgb);
      outputColor.rgb *= injectedData.gamePeakWhite / 80.f;
    }
  }

  u0[uint2(r0.x, r0.y)] = outputColor;

  // No code for instruction (needs manual fix):
  //   store_uav_typed u0.xyzw, r0.xyyy, r1.xyzw return;
}
