// ---- Created with 3Dmigoto v1.3.16 on Thu Oct 17 13:24:09 2024
#include "./DICE.hlsl"
#include "./shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[8];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0 : TEXCOORD0,
                                     float4 v1 : SV_POSITION0,
                                                 out float4 o0 : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;  // UI bt2020

  r0.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r0.xyz);
  r1.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) < r0.xyz);
  r2.xyz = r0.xyz * float3(0.947867274, 0.947867274, 0.947867274) + float3(0.0521326996, 0.0521326996, 0.0521326996);
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r0.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r0.xyz = r1.xyz ? r2.xyz : r0.xyz;
  r1.x = dot(float3(0.627488017, 0.329267114, 0.0433014743), r0.xyz);
  r1.y = dot(float3(0.069108218, 0.9195171, 0.0113595454), r0.xyz);
  r1.z = dot(float3(0.0163962338, 0.0880229846, 0.895499706), r0.xyz);
  r0.xyz = cb0[7].www * r1.xyz;

  // We don't need WCG UI
  r0.rgb = renodx::color::bt709::from::BT2020(r0.rgb);
  if (injectedData.toneMapType > 1.f) {
    r0.rgb = max(0, r0.rgb);
  }
  if (injectedData.toneMapGammaCorrection == 1.f) {
    r0.rgb = renodx::color::correct::GammaSafe(r0.rgb);
  }
  r0.rgb = renodx::color::bt2020::from::BT709(r0.rgb);
  r0.rgb *= injectedData.toneMapUINits / 203.f;  // Value found so it matches tonemapUINits

  r1.xyz = t1.Sample(s1_s, v0.xy).xyz;  // Game in PQ
  if (injectedData.toneMapType > 1.f) {
    r1.rgb = renodx::color::pq::Decode(r1.rgb, 80.f);

    r1.rgb = renodx::color::bt709::from::BT2020(r1.rgb);
    r1.rgb = renodx::color::grade::UserColorGrading(
        r1.rgb,
        injectedData.colorGradeExposure,
        injectedData.colorGradeHighlights,
        injectedData.colorGradeShadows,
        injectedData.colorGradeContrast,
        1.f);  // We'll do saturation post tonemap

    const float dicePaperWhite = injectedData.toneMapGameNits / 80.f;
    const float dicePeakWhite = injectedData.toneMapPeakNits / 80.f;
    const float highlightsShoulderStart = 0.3;  // Random value honestly
    const float frostReinPeak = injectedData.toneMapPeakNits / injectedData.toneMapGameNits;

    // Tonemap adjustments from color correctors
    if (injectedData.toneMapDisplay == 1.f) {
      DICESettings config = DefaultDICESettings();
      config.Type = 1;
      config.ShoulderStart = highlightsShoulderStart;

      r1.rgb = DICETonemap(r1.rgb * dicePaperWhite, dicePeakWhite, config) / dicePaperWhite;
    } else if (injectedData.toneMapDisplay == 2.f) {
      r1.rgb = renodx::tonemap::frostbite::BT709(r1.rgb, frostReinPeak);
    } else if (injectedData.toneMapDisplay == 3.f) {
      r1.rgb = renodx::tonemap::ReinhardScalable(r1.rgb, frostReinPeak);
    }

    r1.rgb = renodx::color::grade::UserColorGrading(
        r1.rgb,
        1.f,
        1.f,
        1.f,
        1.f,
        injectedData.colorGradeSaturation);

    if (injectedData.toneMapGammaCorrection == 1.f) {
      r1.rgb = renodx::color::correct::GammaSafe(r1.rgb);
    }

    r1.rgb = renodx::color::bt2020::from::BT709(r1.rgb);
    r1.rgb = max(0, r1.rgb);
    r1.rgb = renodx::color::pq::Encode(r1.rgb, 80.f);
  }

  r1.rgb = renodx::color::pq::Decode(r1.rgb, 1.f);  // We need it to merge with UI

  /* // pow(in_color, 1.f / M2)
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  // max(e_m12 - C1, 0)
  r2.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r1.xyz;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  // (C2 - C3 * e_m12)
  r1.xyz = -r1.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  // r2 is max(e_m12 - C1, 0)
  // r1 is (C2 - C3 * e_m12)
  r1.xyz = r2.xyz / r1.xyz;
  // pow(result, 1.f / M1)
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r1.xyz;  // 1.f / M1
  r1.xyz = exp2(r1.xyz);
  // out_color * (10000.f / scaling)
  r1.xyz = float3(10000, 10000, 10000) * r1.xyz;  // No scaling used, notice it's full 10k
  // We use 1.f so it Decodes using the full 10k */

  r1.w = cmp(0 < r0.w);
  r2.x = cmp(r0.w < 1);
  r1.w = r1.w ? r2.x : 0;
  if (r1.w != 0) {
    r1.w = dot(r1.xyz, float3(0.262699991, 0.677999973, 0.0593000017));
    r1.w = r1.w / cb0[7].z;
    r1.w = 1 + r1.w;
    r1.w = 1 / r1.w;
    r1.w = r1.w * cb0[7].z + -1;
    r1.w = r0.w * r1.w + 1;
    r1.xyz = r1.xyz * r1.www;
  }
  r0.w = 1 + -r0.w;
  r0.xyz = cb0[7].zzz * r0.xyz;
  r0.xyz = r1.xyz * r0.www + r0.xyz;  // Blending UI with game

  /* // 0.00009999999975 ~= 0.00001 * Bt2020 color
  // This is basically (scaling / 10000.f) where scaling is 1.f
  r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
  // pow(color, M1)
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  // (C1 + C2 * y_m1)
  r1.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
  // (1.f + C3 * y_m1)
  r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
  // ((C1 + C2 * y_m1) / (1.f + C3 * y_m1))
  // r1 = (C1 + C2 * y_m1)
  // r0 = (1.f + C3 * y_m1)
  r0.xyz = rcp(r0.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  // pow(result, M2)
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
  o0.xyz = exp2(r0.xyz); */

  o0.rgb = renodx::color::pq::Encode(r0.rgb, 1.f);
  o0.w = 1;

  return;
}