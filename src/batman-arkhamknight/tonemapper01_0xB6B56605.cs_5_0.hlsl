// No motion blur

#include "./shared.h"
#include "./tonemapper.hlsl"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);

SamplerState s0_s : register(s0);

RWTexture2D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float4 cb0[12];
}

// 3Dmigoto declarations
#define cmp -

[numthreads(16, 16, 1)] void main(uint3 vThreadGroupID : SV_GroupID, uint3 vThreadID : SV_DispatchThreadID) {
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u0
  float4 r0, r1, r2, r3, r4;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 16, 16, 1
  r0.xy = float2(2, -2) / cb0[6].xy;
  r0.zw = (int2)vThreadID.xy;
  r0.zw = cb0[7].zw + r0.zw;
  r1.xy = (uint2)r0.zw;
  r2.xyzw = (uint4)r1.xyyx;
  r0.zw = -cb0[7].zw + r2.wz;
  r2.xyzw = cb0[11].xyxx + r2.xyzw;
  r0.zw = float2(0.5, 0.5) + r0.zw;
  r0.xy = r0.zw * r0.xy + float2(-1, 1);
  r0.xy = r0.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
  r0.zw = cb0[7].xy * r0.xy;
  r0.xy = r0.xy * float2(2, 2) + float2(-1, -1);
  r0.xy = float2(0.769231021, 0.769231021) * r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = r0.x * r0.x + -1;
  r0.x = r0.x * 0.300000012 + 1;

  r0.yzw = t2.SampleLevel(s0_s, r0.zw, 0).xyz;  // Bloom
  // r0.yzw = saturate(r0.yzw); // cap to SDR
  r0.yzw = max(0, r0.yzw);

  r3.x = 0.200000003 * cb0[10].x;
  r3.y = cb0[10].x * 0.200000003 + 1;
  r3.xyzw = r0.wwyz * r3.yyyy + -r3.xxxx;
  r3.xyzw = max(float4(0, 0, 0, 0), r3.xyzw);
  r1.zw = float2(0, 0);

  const float4 texture0Input = t0.Load(r1.xyw);
  r0.yzw = texture0Input.xyz;

  r3.xyzw = r0.wwyz + (r3.xyzw * injectedData.fxBloom);

  // r3.zwy = texture0Input.xyz;

  r0.y = t3.SampleLevel(s0_s, float2(0.5, 0.5), 0).x;
  // r3.xyzw = r3.xyzw / r0.yyyy;
  // r0.xyzw = r3.xyzw * r0.xxxx;
  r0.xyzw = lerp(r3, r3 / r0.y * r0.x, injectedData.fxVignette);

#if DRAW_TONEMAPPER
  DrawToneMapperParams dtmParams = DrawToneMapperStart(r1.xy, r0.zwy, t0, injectedData.toneMapPeakNits);
  r0.zwy = dtmParams.outputColor;
#endif

  float3 untonemapped = r0.zwy;

  r3.xyzw = r0.yyzw * float4(0.219999999, 0.219999999, 0.219999999, 0.219999999) + float4(0.0299999993, 0.0299999993, 0.0299999993, 0.0299999993);
  r3.xyzw = r0.yyzw * r3.xyzw + float4(0.00200000009, 0.00200000009, 0.00200000009, 0.00200000009);
  r4.xyzw = r0.yyzw * float4(0.219999999, 0.219999999, 0.219999999, 0.219999999) + float4(0.300000012, 0.300000012, 0.300000012, 0.300000012);
  r0.xyzw = r0.xyzw * r4.xyzw + float4(0.0599999987, 0.0599999987, 0.0599999987, 0.0599999987);
  r0.xyzw = r3.xyzw / r0.xyzw;
  r0.xyzw = float4(-0.0333333351, -0.0333333351, -0.0333333351, -0.0333333351) + r0.xyzw;
  r0.xyzw = max(float4(0, 0, 0, 0), r0.xyzw);
  r0.xyzw = float4(1.66289866, 1.66289866, 1.66289866, 1.66289866) * r0.xyzw;
  r0.xyzw = log2(r0.xyzw);
  r0.xyzw = float4(0.454545468, 0.454545468, 0.454545468, 0.454545468) * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);

  float4 lutInputColor = r0.zwxy;
  r0.xyzw = min(float4(1, 1, 1, 1), r0.xyzw);
  r3.xyw = float3(14.9998999, 0.9375, 0.05859375) * r0.xwz;
  r0.x = floor(r3.x);
  r3.x = r0.x * 0.0625 + r3.w;
  r3.xyzw = float4(0.001953125, 0.03125, 0.064453125, 0.03125) + r3.xyxy;
  r0.x = r0.y * 15 + -r0.x;
  r0.yzw = t1.SampleLevel(s0_s, r3.zw, 0).xyz;
  r3.xyz = t1.SampleLevel(s0_s, r3.xy, 0).xyz;
  r4.xyzw = -r3.xyzx + r0.yzwy;
  r0.xyzw = r0.xxxx * r4.xyzw + r3.xyzx;

  r0.xyzw = lerp(lutInputColor, r0.xyzw, injectedData.colorGradeLUTStrength);

  r3.xyzw = float4(1, 1, 1, 1) + -r0.wyzw;
  r3.xyzw = r3.xyzw * r3.xyzw;
  r3.xyzw = min(float4(1, 1, 1, 1), r3.xyzw);
  r3.xyzw = cb0[11].zzzz * r3.xyzw;
  r1.z = dot(r2.wyz, float3(23.1406918, 2.66514421, 9.19949627));
  r1.z = cos(r1.z);
  r2.xyzw = r1.zzzz * r2.xyzw;
  r2.xyzw = frac(r2.xyzw);
  r2.xyzw = float4(-0.333999991, -0.333999991, -0.333999991, -0.333999991) + r2.xyzw;
  r2.xyzw = r3.xyzw * r2.xyzw + float4(1, 1, 1, 1);
  r0.xyzw = r2.xyzw * r0.xyzw;


  float4 outputColor = r0.xyzw;

#if DRAW_TONEMAPPER
  outputColor.rgb = applyUserToneMap(outputColor.rgb, untonemapped.rgb, dtmParams);
#else
  outputColor.rgb = applyUserToneMap(outputColor.rgb, untonemapped.rgb);
#endif

  u0[uint2(r1.x, r1.y)] = outputColor;

  // No code for instruction (needs manual fix):
  // store_uav_typed u0.xyzw, r1.xyyy, r0.xyzw return;
}
