// no motion blur + effect

#include "./shared.h"
#include "./tonemapper.hlsl"

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
  float2 screenXY = r3.xy;

  r0.zw = r0.zw * float2(2, 2) + float2(-1, -1);
  r0.zw = float2(0.769231021, 0.769231021) * r0.zw;
  r0.z = dot(r0.zw, r0.zw);
  r0.z = 1 + -r0.z;
  r0.z = max(0, r0.z);
  r0.z = r0.z * r0.z + -1;
  r0.z = r0.z * 0.300000012 + 1;

  r3.xyz = t3.SampleLevel(s0_s, screenXY, 0).xyz;  // bloom
  r0.w = 0.200000003 * cb0[10].x;
  r3.w = cb0[10].x * 0.200000003 + 1;
  r3.xyzw = r3.zzxy * r3.wwww + -r0.wwww;
  r3.xyzw = max(float4(0, 0, 0, 0), r3.xyzw);
  r1.xyzw = r3.xyzw + r1.xyzw;  // Bloom + LensFlare

  r0.w = t4.SampleLevel(s0_s, float2(0.5, 0.5), 0).x;
  // r1.xyzw = r1.xyzw / r0.wwww;
  // r1.xyzw = r1.xyzw * r0.zzzz;
  r1 = lerp(r1, r1 / r0.w * r0.z, injectedData.fxVignette);

#if DRAW_TONEMAPPER
  DrawToneMapperParams graph_config = renodx::debug::DrawToneMapperStart(r0.xy, r1.zwy, t0, injectedData.toneMapPeakNits, injectedData.toneMapGameNits);
  r1.zwy = graph_config.color;
#endif

  const float3 untonemapped = r1.zwy;

  float3 outputColor = untonemapped;
  if (injectedData.toneMapType == 0) {
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

    float4 lutInputColor = r1.zwxy;
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

    r3.xyzw = lerp(lutInputColor, r3.xyzw, injectedData.colorGradeLUTStrength);
    outputColor = r3.rgb;
#if DRAW_TONEMAPPER
    if (!graph_config.draw)
#endif
      if (injectedData.fxFilmGrain) {
        r3.xyzw = float4(1, 1, 1, 1) + -r1.wyzw;
        r3.xyzw = r3.xyzw * r3.xyzw;
        r3.xyzw = min(float4(1, 1, 1, 1), r3.xyzw);
        r3.xyzw = cb0[11].zzzz * r3.xyzw * injectedData.fxFilmGrain;
        r0.z = dot(r2.wyz, float3(23.1406918, 2.66514421, 9.19949627));
        r0.z = cos(r0.z);
        r2.xyzw = r0.zzzz * r2.xyzw;
        r2.xyzw = frac(r2.xyzw);
        r2.xyzw = float4(-0.333999991, -0.333999991, -0.333999991, -0.333999991) + r2.xyzw;
        r2.xyzw = r3.xyzw * r2.xyzw + float4(1, 1, 1, 1);
        r1.xyzw = r2.xyzw * r1.xyzw;
        outputColor = r1.rgb;
      }
    outputColor = max(0, outputColor);

    outputColor = injectedData.toneMapGammaCorrection ? pow(outputColor, 2.2f) : renodx::color::srgb::Decode(outputColor);
  } else {
    outputColor = applyUserToneMap(untonemapped.rgb, t2, s0_s);
#if DRAW_TONEMAPPER
    if (!graph_config.draw)
#endif
      if (injectedData.fxFilmGrain) {
        float3 grainedColor;
        if (injectedData.fxFilmGrainType == 0) {
          float3 grainInputColor = renodx::color::gamma::EncodeSafe(outputColor, 2.2f);
          float3 invertedColor = 1.f - saturate(grainInputColor);
          float3 clampedColor = min(1.f, invertedColor * invertedColor);
          float3 modulatedStrength = clampedColor * cb0[11].zzz * injectedData.fxFilmGrain;

          r1.z = dot(r2.wyz, float3(
                                 renodx::random::GELFOND_CONSTANT,
                                 renodx::random::GELFOND_SCHNEIDER_CONSTANT,
                                 9.19949627));
          r1.z = cos(r1.z);
          r2.xyz = r1.zzz * r2.xyz;
          float3 randomnessFactor = frac(r2.xyz);

          float3 grainEffect = mad(modulatedStrength, (randomnessFactor - 0.334f), 1.f);  //  r1.xyz = r1.xyz * (r3.xyz - 0.334f) + 1.f;

          grainedColor = grainEffect * grainInputColor;  //  r0.xyz = r1.xyz * r0.xyz;
          grainedColor = renodx::color::gamma::DecodeSafe(grainedColor, 2.2f);
        } else {
          grainedColor = renodx::effects::ApplyFilmGrain(
              outputColor,
              screenXY,
              frac(r3.x),
              cb0[11].z ? injectedData.fxFilmGrain * 0.03f : 0,
              1.f);
        }
        outputColor = grainedColor;
      }
  }

#if DRAW_TONEMAPPER
  if (graph_config.draw) outputColor = renodx::debug::renodx::debug::graph::DrawEnd(outputColor, graph_config);
#endif

  outputColor *= injectedData.toneMapGameNits / 80.f;

  u0[uint2(r0.x, r0.y)] = outputColor.xyzx;

  // No code for instruction (needs manual fix):
  //   store_uav_typed u0.xyzw, r0.xyyy, r1.xyzw return;
}
