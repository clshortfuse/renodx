#include "./shared.h"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t8 : register(t8);
Texture2D<float4> t9 : register(t9);
Texture3D<float4> t10 : register(t10);  // LUT
Texture2D<float4> t13 : register(t13);

SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);

cbuffer cb6 : register(b6) { float4 cb6[5]; }

cbuffer cb0 : register(b0) { float4 cb0[17]; }

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_Position0, float4 v1 : TEXCOORD0, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[12].xy * v1.xy;
  r0.xy = min(cb0[12].zw, r0.xy);
  r0.z = t2.Sample(s1_s, r0.xy).x;

  r0.w = r0.z * cb0[1].z + cb0[1].w;
  r0.w = 1 / r0.w;
  r1.xyzw = cb0[5].xyzw * v1.yyyy;
  r1.xyzw = v1.xxxx * cb0[4].xyzw + r1.xyzw;
  r1.xyzw = r0.zzzz * cb0[6].xyzw + r1.xyzw;
  r1.xyzw = cb0[7].xyzw + r1.xyzw;
  r1.xyz = r1.xyz / r1.www;
  r1.xyz = -cb6[4].xyz + r1.xyz;
  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = rsqrt(r0.z);
  r0.z = saturate(r1.y * r0.z);
  r1.xy = cb0[13].xy * v1.xy;
  r1.xy = min(cb0[13].zw, r1.xy);
  r1.zw = cb0[15].xy * v1.xy;
  r1.zw = min(cb0[15].zw, r1.zw);
  r2.xyz = t1.Sample(s2_s, r1.xy).xyz;  // flare + bloom
  r3.xyz = t3.Sample(s2_s, r1.xy).xyz;  // bloom
  r4.xyz = t4.Sample(s2_s, r1.zw).xyz;  // bloom
  r5.xyz = t0.Sample(s2_s, r0.xy).xyz;  // flares

  r0.x = r0.z * r0.z;
  r0.x = r0.x * cb0[11].x + 1;
  r0.y = saturate(r0.w * cb0[3].x + -cb0[3].y);
  r0.x = r0.y / r0.x;
  r0.x = saturate(r0.x * cb0[2].w + cb0[11].z);
  r0.x = -0.100000001 + r0.x;
  r0.x = saturate(16 * r0.x);
  r0.y = t13.Sample(s2_s, r1.xy).x;  // depth
  r0.x = saturate(r0.x + r0.y);
  r0.yzw = -r5.xyz + r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r5.xyz;
  r1.xyz = t9.Sample(s3_s, v1.xy).xyz;  // lens flare

  r1.xyz = r1.xyz * cb0[2].zzz + cb0[2].yyy;
  r1.xyz = r4.xyz * r1.xyz * injectedData.fxLensFlare;
  r1.xyz = r3.xyz * cb0[2].xxx * injectedData.fxBloom + r1.xyz;

  r0.xyz = r0.xyz * cb0[1].xxx + r1.xyz;

  r0.w = cmp(cb0[11].y == 0.000000);
  if (r0.w != 0) {
    r1.xyz = t8.Sample(s2_s, v1.xy).xyz;
    r1.xyz = float3(-1, -1, -1) + r1.xyz;
    r1.xyz = cb0[1].yyy * r1.xyz + float3(1, 1, 1);
    r1.xyz = lerp(1.f, r1.xyz, injectedData.fxVignette) * r0.xyz;
  } else {
    r2.xy = v1.xy * float2(2, 2) + float2(-1, -1);
    r2.xy = abs(r2.xy) * float2(0.5, 0.5) + float2(0.5, 0.5);
    r2.xy = float2(1, 1) + -r2.xy;
    r2.xyz = t8.Sample(s2_s, r2.xy).xyz;  // vertical mask ?
    r2.xyz = r2.xyz * r2.xyz + float3(-1, -1, -1);
    r2.xyz = cb0[1].yyy * r2.xyz + float3(1, 1, 1);
    r1.xyz = lerp(1.f, r2.xyz, injectedData.fxVignette) * r0.xyz;
  }

  float3 untonemapped = r1.xyz * 0.5f;

  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;

  renodx::lut::Config lut_config = renodx::lut::config::Create(
      s2_s,
      injectedData.colorGradeLUTStrength,
      injectedData.colorGradeLUTScaling,
      renodx::lut::config::type::GAMMA_2_0,
      renodx::lut::config::type::GAMMA_2_0,
      16.f);

  if (injectedData.toneMapType == 0.f) {
    r0.xyz = cb0[8].xxx * r1.xyz;
    r0.xyz = cb0[8].zzz * cb0[8].yyy + r0.xyz;
    r2.xy = cb0[9].xy * cb0[8].ww;
    r0.xyz = r1.xyz * r0.xyz + r2.xxx;
    r2.xzw = cb0[8].xxx * r1.xyz + cb0[8].yyy;
    r1.xyz = r1.xyz * r2.xzw + r2.yyy;
    r0.xyz = r0.xyz / r1.xyz;
    r0.w = cb0[9].x / cb0[9].y;
    r0.xyz = r0.xyz + -r0.www;
    r0.xyz = cb0[3].www * r0.xyz;
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r0.w = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
    r0.xyz = min(float3(1, 1, 1), r0.xyz);
    r1.x = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
    r0.xyz = saturate(cb0[0].xyz * r0.xyz);

    r0.xyz = sqrt(r0.xyz);
    r0.xyz = r0.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
    r0.xyz = t10.Sample(s2_s, r0.xyz).xyz;
    r0.xyz = r0.xyz * r0.xyz;

  } else {
    r0.xyz = renodx::tonemap::config::Apply(untonemapped, config, lut_config, t10);
  }

  if (injectedData.toneMapGammaCorrection) {
    r0.xyz = renodx::color::correct::GammaSafe(r0.xyz);
  }

  // Fake HDR?
  r0.xyz = r0.xyz * cb0[10].xxx + cb0[10].yyy;
  r0.w = r0.w / r1.x;
  r0.w = cb0[11].w * r0.w;
  r1.xyz = r0.xyz * r0.www;
  r0.xyz = cb0[16].xxx ? r1.xyz : r0.xyz;
  r0.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  o0.w = sqrt(r0.w);
  o0.xyz = r0.xyz;

  o0.rgb *= injectedData.toneMapGameNits / 80.f;

  // o0.rgb = lutted.rgb;
  // o0.rgb = untonemapped.rgb;
  // o0.rgb = pow(max(0, o0.rgb), 1.f/2.2f);
  // o0.rgb = 1.f;
  // o0.rgb *= 1000.f / 80.f;
  return;
}
