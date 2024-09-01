// Output tonemapper

#include "shared.h"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture3D<float4> t3 : register(t3);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);

cbuffer cb0 : register(b0) {
  float4 cb0[74];
}

cbuffer cb1 : register(b1) {
  float4 cb1[136];
}

cbuffer cb2 : register(b2) {
  ShaderInjectData injectedData : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

float4 main(linear noperspective float2 v0 : TEXCOORD0, linear noperspective float2 w0 : TEXCOORD3, linear noperspective float3 v1 : TEXCOORD1, linear noperspective float4 v2 : TEXCOORD2, float2 v3 : TEXCOORD4, float4 v4 : SV_POSITION0) : SV_Target0 {
  float4 r0, r1, r2, r3, r4, r5, o0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v2.w * 543.309998 + v2.z;
  r0.x = sin(r0.x);
  r0.x = 493013 * r0.x;
  r0.yz = w0.xy * cb0[70].zw + cb0[70].xy;
  r1.xyzw = cmp(float4(0, 0, 0, 0) < r0.yzyz);
  r2.xyzw = cmp(r0.yzyz < float4(0, 0, 0, 0));
  r1.xyzw = (int4)-r1.xyzw + (int4)r2.xyzw;
  r1.xyzw = (int4)r1.xyzw;
  r2.xyzw = saturate(-cb0[73].zzzz + abs(r0.yzyz));
  r1.xyzw = r2.xyzw * r1.xyzw;
  r1.xyzw = -r1.xyzw * cb0[73].xxyy + r0.yzyz;
  r1.xyzw = r1.xyzw * cb0[71].zwzw + cb0[71].xyxy;
  r1.xyzw = r1.xyzw * cb0[38].zwzw + cb0[39].xyxy;
  r1.xyzw = cb0[38].xyxy * r1.xyzw;
  r2.x = t0.Sample(s0_s, r1.xy).x;
  r2.y = t0.Sample(s0_s, r1.zw).y;
  r2.z = t0.Sample(s0_s, v0.xy).z;
  r1.xyz = cb1[135].zzz * r2.xyz;
  r2.xy = cb0[58].zw * v0.xy + cb0[59].xy;
  r2.xy = max(cb0[50].zw, r2.xy);
  r2.xy = min(cb0[51].xy, r2.xy);
  r2.xyz = t1.Sample(s1_s, r2.xy).xyz;
  r3.xyz = cb1[135].zzz * r2.xyz;
  r4.yz = r0.yz * float2(0.5, -0.5) + float2(0.5, 0.5);
  r0.y = dot(r3.xyz, float3(0.300000012, 0.300000012, 0.300000012));
  r0.y = log2(r0.y);
  r0.y = cb0[65].x * r0.y;
  r0.y = exp2(r0.y);
  r0.z = cb1[132].x * r4.y;
  r4.x = r0.z / cb1[132].y;
  r5.x = dot(float2(0.707106769, -0.707106769), r4.xz);
  r5.y = dot(float2(0.707106769, 0.707106769), r4.xz);
  r0.zw = cmp(r0.yy < cb0[64].zw);
  r0.y = -cb0[64].w + r0.y;
  r1.w = cb0[64].z + -cb0[64].w;
  r0.y = saturate(r0.y / r1.w);
  r1.w = cb0[63].y + -cb0[63].x;
  r0.y = r0.y * r1.w + cb0[63].x;
  r0.y = r0.w ? 0 : r0.y;
  r0.y = r0.z ? r0.y : cb0[63].y;
  r0.y = log2(r0.y);
  r0.y = cb0[63].w * r0.y;
  r0.y = exp2(r0.y);
  r0.zw = cb0[63].zz * r5.xy;
  r0.xzw = frac(r0.xzw);
  r0.zw = r0.zw * float2(2, 2) + float2(-1, -1);
  r0.z = dot(r0.zw, r0.zw);
  r0.z = sqrt(r0.z);
  r5.x = ddx_coarse(r0.z);
  r5.y = ddy_coarse(r0.z);
  r0.w = dot(r5.xy, r5.xy);
  r0.w = sqrt(r0.w);
  r1.w = -r0.w * 0.699999988 + r0.y;
  r0.y = r0.w * 0.699999988 + r0.y;
  r0.yz = -r1.ww + r0.yz;
  r0.y = 1 / r0.y;
  r0.y = saturate(r0.z * r0.y);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = -r0.z * r0.y + 1;
  r0.y = cb0[64].x * r0.y;
  r0.yzw = cb0[61].xyz * r0.yyy + -cb0[61].xyz;
  r0.yzw = cb0[64].yyy * r0.yzw + cb0[61].xyz;
  r1.w = dot(r3.xyz, float3(0.333299994, 0.333299994, 0.333299994));
  r2.w = cmp(0 < r1.w);
  r3.w = 1 + r1.w;
  r3.w = r1.w / r3.w;
  r3.w = cb0[65].y * r3.w;
  r3.w = floor(r3.w);
  r3.w = r3.w / cb0[65].y;
  r4.x = 1 + -r3.w;
  r3.w = r3.w / r4.x;
  r5.xyz = r3.xyz * r3.www;
  r5.xyz = r5.xyz / r1.www;
  r5.xyz = r2.www ? r5.xyz : r3.xyz;
  r4.xyz = t2.Sample(s2_s, r4.yz).xyz;
  r4.xyz = cb0[69].xyz * r4.xyz;
  r2.xyz = -r2.xyz * cb1[135].zzz + r5.xyz;
  r2.xyz = cb0[65].zzz * r2.xyz + r3.xyz;
  r2.xyz = r2.xyz * r4.xyz;
  // r0.yzw = r2.xyz * r0.yzw;
  r0.yzw *= lerp(1.f, r2.xyz, injectedData.fxBloom);

  r0.yzw = r1.xyz * cb0[60].xyz + r0.yzw;
  float3 untonemapped = r0.yzw;

  r0.yzw = r0.yzw * v1.xxx + float3(0.00266771927, 0.00266771927, 0.00266771927);
  r0.yzw = log2(r0.yzw);
  r0.yzw = saturate(r0.yzw * float3(0.0714285746, 0.0714285746, 0.0714285746) + float3(0.610726953, 0.610726953, 0.610726953));
  r0.yzw = r0.yzw * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
  r0.yzw = t3.Sample(s3_s, r0.yzw).xyz;
  r1.xyz = float3(1.04999995, 1.04999995, 1.04999995) * r0.yzw;
  o0.w = saturate(dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114)));
  r0.x = r0.x * 0.00390625 + -0.001953125;
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
    outputColor = untonemapped;
  }

  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.reno_drt_contrast = 1.1f;
  config.reno_drt_saturation = 1.15f;

  outputColor = renodx::tonemap::config::Apply(outputColor, config);

  outputColor *= injectedData.toneMapGameNits;  // Scale by user nits

  // o0.rgb = mul(BT709_TO_BT2020_MAT, o0.rgb);  // use bt2020
  // o0.rgb /= 10000.f;                         // Scale for PQ
  // o0.rgb = max(0, o0.rgb);                   // clamp out of gamut
  // o0.rgb = renodx::color::pq::from::BT2020(o0.rgb);             // convert to PQ
  // o0.rgb = min(1.f, o0.rgb);                 // clamp PQ (10K nits)

  outputColor.rgb /= 80.f;
  o0.rgb = outputColor.rgb;

  return o0;
}
