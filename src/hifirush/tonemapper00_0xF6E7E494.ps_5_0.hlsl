// Output tonemapper

#include "../common/Open_DRT.hlsl"
#include "../common/aces.hlsl"
#include "../common/color.hlsl"
#include "../common/colorgrade.hlsl"
#include "shared.h"

Texture2D<float4> t0 : register(t0);  // Untonemapped
Texture2D<float4> t1 : register(t1);  // Bloom
Texture2D<float4> t2 : register(t2);
Texture3D<float4> t3 : register(t3);  // 32x32x32 LUT

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);

cbuffer cb0 : register(b0) {
  float4 cb0[71];
}

cbuffer cb1 : register(b1) {
  float4 cb1[136];
}

cbuffer cb2 : register(b2) {
  ShaderInjectData injectedData : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

float4 main(
  linear noperspective float2 v0 : TEXCOORD0,
                                   linear noperspective float2 w0 : TEXCOORD3,
                                                                    linear noperspective float3 v1 : TEXCOORD1,
                                                                                                     linear noperspective float4 v2 : TEXCOORD2,
                                                                                                                                      float2 v3 : TEXCOORD4,
                                                                                                                                                  float4 v4 : SV_POSITION0
) : SV_Target0 {
  float4 r0, r1, r2, r3, r4, r5, o0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v2.w * 543.309998 + v2.z;
  r0.x = sin(r0.x);
  r0.x = 493013 * r0.x;
  r0.x = frac(r0.x);

  const float3 texture0Input = t0.Sample(s0_s, v0.xy).xyz;
  r0.yzw = texture0Input.rgb;
  r0.yzw = cb1[135].zzz * r0.yzw;
  r1.xy = cb0[58].zw * v0.xy + cb0[59].xy;
  r1.xy = max(cb0[50].zw, r1.xy);
  r1.xy = min(cb0[51].xy, r1.xy);
  r1.xyz = t1.Sample(s1_s, r1.xy).xyz;

  r2.xyz = cb1[135].zzz * r1.xyz;

  r3.xy = w0.xy * cb0[70].zw + cb0[70].xy;
  r3.yz = r3.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
  r1.w = dot(r2.xyz, float3(0.300000012, 0.300000012, 0.300000012));
  r1.w = log2(r1.w);
  r1.w = cb0[65].x * r1.w;
  r1.w = exp2(r1.w);
  r2.w = cb1[132].x * r3.y;
  r3.x = r2.w / cb1[132].y;
  r4.x = dot(float2(0.707106769, -0.707106769), r3.xz);
  r4.y = dot(float2(0.707106769, 0.707106769), r3.xz);
  r3.xw = cmp(r1.ww < cb0[64].zw);
  r1.w = -cb0[64].w + r1.w;
  r2.w = cb0[64].z + -cb0[64].w;
  r1.w = saturate(r1.w / r2.w);
  r2.w = cb0[63].y + -cb0[63].x;
  r1.w = r1.w * r2.w + cb0[63].x;
  r1.w = r3.w ? 0 : r1.w;
  r1.w = r3.x ? r1.w : cb0[63].y;
  r1.w = log2(r1.w);
  r1.w = cb0[63].w * r1.w;
  r1.w = exp2(r1.w);
  r3.xw = cb0[63].zz * r4.xy;
  r3.xw = frac(r3.xw);
  r3.xw = r3.xw * float2(2, 2) + float2(-1, -1);
  r2.w = dot(r3.xw, r3.xw);
  r2.w = sqrt(r2.w);
  r4.x = ddx_coarse(r2.w);
  r4.y = ddy_coarse(r2.w);
  r3.x = dot(r4.xy, r4.xy);
  r3.x = sqrt(r3.x);
  r3.w = -r3.x * 0.699999988 + r1.w;
  r1.w = r3.x * 0.699999988 + r1.w;
  r1.w = r1.w + -r3.w;
  r2.w = -r3.w + r2.w;
  r1.w = 1 / r1.w;
  r1.w = saturate(r2.w * r1.w);
  r2.w = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = -r2.w * r1.w + 1;
  r1.w = cb0[64].x * r1.w;
  r4.xyz = cb0[61].xyz * r1.www + -cb0[61].xyz;
  r4.xyz = cb0[64].yyy * r4.xyz + cb0[61].xyz;
  r1.w = dot(r2.xyz, float3(0.333299994, 0.333299994, 0.333299994));
  r2.w = cmp(0 < r1.w);
  r3.x = 1 + r1.w;
  r3.x = r1.w / r3.x;
  r3.x = cb0[65].y * r3.x;
  r3.x = floor(r3.x);
  r3.x = r3.x / cb0[65].y;
  r3.w = 1 + -r3.x;
  r3.x = r3.x / r3.w;
  r5.xyz = r3.xxx * r2.xyz;
  r5.xyz = r5.xyz / r1.www;
  r5.xyz = r2.www ? r5.xyz : r2.xyz;
  r3.xyz = t2.Sample(s2_s, r3.yz).xyz;
  r3.xyz = cb0[69].xyz * r3.xyz;
  r1.xyz = -r1.xyz * cb1[135].zzz + r5.xyz;
  r1.xyz = cb0[65].zzz * r1.xyz + r2.xyz;
  r1.xyz = r1.xyz * r3.xyz;
  r1.xyz = r1.xyz * lerp(1.f, r4.xyz, injectedData.fxBloom);

  r0.yzw = r0.yzw * cb0[60].xyz + r1.xyz;
  float3 untonemapped = r0.yzw;

  r0.yzw = r0.yzw * v1.xxx + float3(0.00266771927, 0.00266771927, 0.00266771927);
  r0.yzw = log2(r0.yzw);

  r0.yzw = saturate(r0.yzw * float3(0.0714285746, 0.0714285746, 0.0714285746) + float3(0.610726953, 0.610726953, 0.610726953));
  r0.yzw = r0.yzw * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
  r0.yzw = t3.Sample(s3_s, r0.yzw).xyz;
  r1.xyz = float3(1.04999995, 1.04999995, 1.04999995) * r0.yzw;
  o0.w = saturate(dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114)));
  r0.x = r0.x * 0.00390625 + -0.001953125;

  // r0.x *= injectedData.fxNoise;

  r0.xyz = r0.yzw * float3(1.04999995, 1.04999995, 1.04999995) + r0.xxx;
  if (cb0[68].x != 0) {
    r1.xyz = log2(r0.xyz);
    r1.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r1.xyz;
    r1.xyz = exp2(r1.xyz);

    r2.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r1.xyz;
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r1.xyz = -r1.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
    r1.xyz = r2.xyz / r1.xyz;

    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r1.xyz;
    r1.xyz = exp2(r1.xyz);

    r1.xyz = float3(10000, 10000, 10000) * r1.xyz;
    r1.xyz = r1.xyz / cb0[67].www;

    r1.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r1.xyz);
    r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
    r1.xyz = max(float3(0.00313066994, 0.00313066994, 0.00313066994), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);

    o0.xyz = min(r2.xyz, r1.xyz);
  } else {
    o0.xyz = r0.xyz;
  }

  float3 outputColor = o0.rgb;
  outputColor = max(0, outputColor);
  if (injectedData.toneMapType == 0.f) {
    outputColor = pow(outputColor, 2.2f);
  } else {
    outputColor = untonemapped.rgb;
  }
  outputColor = applyUserColorGrading(
    outputColor,
    1.f,
    injectedData.colorGradeSaturation,
    injectedData.colorGradeShadows,
    injectedData.colorGradeHighlights,
    injectedData.colorGradeContrast
  );

  const float vanillaMidGray = 0.18f;
  if (injectedData.toneMapType == 2.f) {
    const float ACES_MID_GRAY = 0.10f;
    float paperWhite = injectedData.toneMapGameNits * (vanillaMidGray / ACES_MID_GRAY);
    float hdrScale = (injectedData.toneMapPeakNits / paperWhite);
    outputColor = aces_rgc_rrt_odt(
      outputColor,
      0.0001f / hdrScale,
      48.f * hdrScale
    );
    outputColor /= 48.f;
    outputColor *= (vanillaMidGray / ACES_MID_GRAY);
  } else if (injectedData.toneMapType == 3.f) {
    const float OPENDRT_MID_GRAY = 11.696f / 100.f;
    float paperWhite = injectedData.toneMapGameNits * (vanillaMidGray / OPENDRT_MID_GRAY);
    float hdrScale = (injectedData.toneMapPeakNits / paperWhite);
    outputColor = mul(BT709_2_DISPLAYP3_MAT, outputColor);
    outputColor = max(0, outputColor);
    outputColor = open_drt_transform_bt709(
      outputColor,
      100.f * hdrScale,
      0.12,
      1.f,
      0
    );
    outputColor = mul(DISPLAYP3_2_BT709_MAT, outputColor);
    outputColor *= hdrScale;
    outputColor *= (vanillaMidGray / OPENDRT_MID_GRAY);
  }

  outputColor *= injectedData.toneMapGameNits;  // Scale by user nits

  // o0.rgb = mul(BT709_2_BT2020_MAT, o0.rgb);  // use bt2020
  // o0.rgb /= 10000.f;                         // Scale for PQ
  // o0.rgb = max(0, o0.rgb);                   // clamp out of gamut
  // o0.rgb = pqFromLinear(o0.rgb);             // convert to PQ
  // o0.rgb = min(1.f, o0.rgb);                 // clamp PQ (10K nits)

  outputColor.rgb /= 80.f;
  o0.rgb = outputColor.rgb;

  return o0;
}
