#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Tue Jun 04 23:18:36 2024

cbuffer _Globals : register(b0) {
  float4 DL_FREG_007 : packoffset(c7);
  float4 DL_FREG_008 : packoffset(c8);
  float4 DL_FREG_009 : packoffset(c9);
  float4 DL_FREG_010 : packoffset(c10);
  float4 DL_FREG_011 : packoffset(c11);
  float4 DL_FREG_012 : packoffset(c12);
  float4 DL_FREG_013 : packoffset(c13);
  float4 DL_FREG_014 : packoffset(c14);
  float4 DL_FREG_015 : packoffset(c15);
  float4 DL_FREG_016 : packoffset(c16);
  float4 DL_FREG_017 : packoffset(c17);
  float4 DL_FREG_018 : packoffset(c18);
  float4 DL_FREG_019 : packoffset(c19);
  float4 DL_FREG_020 : packoffset(c20);
  float4 DL_FREG_021 : packoffset(c21);
  float4 DL_FREG_022 : packoffset(c22);
  float4 DL_FREG_023 : packoffset(c23);
  float4 DL_FREG_024 : packoffset(c24);
  float4 DL_FREG_025 : packoffset(c25);
  float4 DL_FREG_026 : packoffset(c26);
  float4 DL_FREG_027 : packoffset(c27);
  float4 DL_FREG_028 : packoffset(c28);
  float4 DL_FREG_029 : packoffset(c29);
  float4 DL_FREG_030 : packoffset(c30);
  float4 DL_FREG_031 : packoffset(c31);
  float4 DL_FREG_032 : packoffset(c32);
  float4 DL_FREG_033 : packoffset(c33);
  float4 DL_FREG_034 : packoffset(c34);
  float4 DL_FREG_035 : packoffset(c35);
  float4 DL_FREG_036 : packoffset(c36);
  float4 DL_FREG_037 : packoffset(c37);
  float4 DL_FREG_038 : packoffset(c38);
  float4 DL_FREG_039 : packoffset(c39);
  float4 DL_FREG_040 : packoffset(c40);
  float4 DL_FREG_041 : packoffset(c41);
  float4 DL_FREG_042 : packoffset(c42);
  float4 DL_FREG_043 : packoffset(c43);
  float4 DL_FREG_044 : packoffset(c44);
  float4 DL_FREG_045 : packoffset(c45);
  float4 DL_FREG_046 : packoffset(c46);
  float4 DL_FREG_047 : packoffset(c47);
  float4 DL_FREG_048 : packoffset(c48);
  float4 DL_FREG_049 : packoffset(c49);
  float4 DL_FREG_050 : packoffset(c50);
  float4 DL_FREG_051 : packoffset(c51);
  float4 DL_FREG_052 : packoffset(c52);
  float4 DL_FREG_053 : packoffset(c53);
  float4 DL_FREG_054 : packoffset(c54);
  float4 DL_FREG_055 : packoffset(c55);
  float4 DL_FREG_056 : packoffset(c56);
  float4 DL_FREG_057 : packoffset(c57);
  float4x4 DL_FREG_058 : packoffset(c58);
  float4x4 DL_FREG_062 : packoffset(c62);
  float4 DL_FREG_066 : packoffset(c66);
  float4 DL_FREG_067 : packoffset(c67);
  float4 DL_FREG_068 : packoffset(c68);
  float4 DL_FREG_069 : packoffset(c69);
  float4 DL_FREG_070 : packoffset(c70);
  float4 DL_FREG_071 : packoffset(c71);
  float4 DL_FREG_072 : packoffset(c72);
  float4 DL_FREG_073 : packoffset(c73);
  float4x4 DL_FREG_074 : packoffset(c74);
  float4 DL_FREG_078 : packoffset(c78);
  uint4 gFC_FrameIndex : packoffset(c81);
  float4x4 gVC_WorldViewClipMtx : packoffset(c82);
  float4 gVC_ScreenSize : packoffset(c86);
  float4 gVC_NoiseParam : packoffset(c87);
}

SamplerState gSMP_0Sampler_s : register(s0);
SamplerState gSMP_1Sampler_s : register(s1);
SamplerState gSMP_2Sampler_s : register(s2);
SamplerState gSMP_3Sampler_s : register(s3);
SamplerState gSMP_5Sampler_s : register(s5);
Texture2D<float4> gSMP_0 : register(t0);
Texture2D<float4> gSMP_1 : register(t1);
Texture2D<float4> gSMP_2 : register(t2);
Texture2D<float4> gSMP_3 : register(t3);
Texture2D<float4> gSMP_5 : register(t5);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0
          : SV_Position0, float4 v1
          : TEXCOORD1, out float4 o0
          : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Initial tonemapper settings, used in case 0
  float vanillaMidGray = DL_FREG_054.z / DL_FREG_054.w;
  float renoDRTContrast = 1.16f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 1.f;
  float renoDRTDechroma = injectedData.colorGradeBlowout;
  float renoDRTSaturation = 1.3f;
  float renoDRTHighlights = 1.04f;

  r0.xyz = gSMP_0.Sample(gSMP_0Sampler_s, v1.xy).xyz;
  r1.xyzw = gSMP_1.Sample(gSMP_1Sampler_s, v1.xy).wxyz;
  if (injectedData.toneMapType == 0) {  // Clamp vanilla tonemapper to BT709
    r0.xyz = max(0, r0.xyz);
    r1.yzw = max(0, r1.yzw);
  }
  r1.x = saturate(r1.x);
  r2.xyz = gSMP_3.Sample(gSMP_3Sampler_s, v1.xy).xyz;
  r0.w = DL_FREG_071.y + -DL_FREG_056.x;
  r0.w = r1.x * r0.w + DL_FREG_056.x;
  r0.xyz = r0.www * r1.yzw + r0.xyz;
  r0.xyz = DL_FREG_056.yyy * r2.xyz + r0.xyz;
  r0.w = (uint)DL_FREG_057.x;

  float3 untonemapped = r0.xyz;

  switch (r0.w) {
    case 0:  // Vanilla tonemapper 0
      r0.w = gSMP_5.Sample(gSMP_5Sampler_s, float2(0.5, 0.5)).x;
      r0.w = max(DL_FREG_056.z, r0.w);
      r0.w = min(DL_FREG_056.w, r0.w);
      r0.w = 9.99999975e-005 + r0.w;
      r0.w = DL_FREG_054.x / r0.w;
      r2.xyz = r0.xyz * r0.www;
      if (injectedData.toneMapType != 0) {  // Custom tonemappers
        untonemapped = r2.xyz;
      }
      r0.w = DL_FREG_055.z * DL_FREG_055.y;  // Start of tonemap 0
      r3.xyz = DL_FREG_055.xxx * r2.xyz + r0.www;
      r4.xy = DL_FREG_055.ww * DL_FREG_054.zw;
      r3.xyz = r2.xyz * r3.xyz + r4.xxx;
      r5.xyz = DL_FREG_055.xxx * r2.xyz + DL_FREG_055.yyy;
      r2.xyz = r2.xyz * r5.xyz + r4.yyy;
      r2.xyz = r3.xyz / r2.xyz;
      r1.w = DL_FREG_054.z / DL_FREG_054.w;
      r2.xyz = r2.xyz + -r1.www;
      r0.w = DL_FREG_055.x * DL_FREG_054.y + r0.w;
      r0.w = DL_FREG_054.y * r0.w + r4.x;
      r2.w = DL_FREG_055.x * DL_FREG_054.y + DL_FREG_055.y;
      r2.w = DL_FREG_054.y * r2.w + r4.y;
      r0.w = r0.w / r2.w;
      r0.w = r0.w + -r1.w;
      r1.xyz = r2.xyz / r0.www;
      break;

    case 1:  // Vanilla tonemapper 1
      r0.w = gSMP_5.Sample(gSMP_5Sampler_s, float2(0.5, 0.5)).x;
      r0.w = max(DL_FREG_056.z, r0.w);
      r0.w = min(DL_FREG_056.w, r0.w);
      r0.w = 9.99999975e-005 + r0.w;
      r0.w = DL_FREG_054.x / r0.w;
      r2.xyz = r0.xyz * r0.www;
      if (injectedData.toneMapType != 0) {  // Custom tonemappers
        vanillaMidGray = .15f;
        renoDRTContrast = 0.92f;
        renoDRTFlare = 0.f;
        renoDRTShadows = 1.f;
        // renoDRTDechroma = 0.7f;
        renoDRTSaturation = 1.3f;
        renoDRTHighlights = 1.f;
        untonemapped = r2.xyz;
      }
      r0.w = dot(r2.xyz, float3(0.212672904, 0.715152204,
                                0.0721750036));  // Start of tonemap 1
      r0.w = max(9.99999975e-005, r0.w);
      r1.w = 1 + r0.w;
      r1.w = r0.w / r1.w;
      r2.xyz = r1.www * r2.xyz;
      r1.xyz = r2.xyz / r0.www;
      break;

    case 2:  // Vanilla tonemapper 2
      r0.w = gSMP_5.Sample(gSMP_5Sampler_s, float2(0.5, 0.5)).x;
      r0.w = max(DL_FREG_056.z, r0.w);
      r0.w = min(DL_FREG_056.w, r0.w);
      r0.w = 9.99999975e-005 + r0.w;
      r0.w = DL_FREG_054.x / r0.w;
      r0.xyz = r0.xyz * r0.www;
      if (injectedData.toneMapType != 0) {  // Custom tonemappers
        vanillaMidGray = .151f;
        renoDRTContrast = 0.94f;
        renoDRTFlare = 0.f;
        renoDRTShadows = 1.f;
        // renoDRTDechroma = 0.7f;
        renoDRTSaturation = 1.3f;
        renoDRTHighlights = 1.f;
        untonemapped = r0.xyz;
      }
      r0.w = dot(r0.xyz, float3(0.212672904, 0.715152204,
                                0.0721750036));  // Start of tonemap 2
      r0.w = max(9.99999975e-005, r0.w);
      r1.w = DL_FREG_054.y * DL_FREG_054.y;
      r1.w = r0.w / r1.w;
      r1.w = 1 + r1.w;
      r1.w = r1.w * r0.w;
      r2.x = 1 + r0.w;
      r1.w = r1.w / r2.x;
      r0.xyz = r1.www * r0.xyz;
      r1.xyz = r0.xyz / r0.www;
      break;

    default:  // Debug?
      r1.xyz = float3(1, 0, 1);
      break;
  }

  if (injectedData.toneMapType != 0) {
    float3 tonemapped = renodx::tonemap::config::Apply(
        untonemapped,
        renodx::tonemap::config::Create(
            injectedData.toneMapType,
            injectedData.toneMapPeakNits,
            injectedData.toneMapGameNits,
            injectedData.toneMapGammaCorrection,
            injectedData.colorGradeExposure,
            injectedData.colorGradeHighlights,
            injectedData.colorGradeShadows,
            injectedData.colorGradeContrast,
            injectedData.colorGradeSaturation,
            vanillaMidGray,
            vanillaMidGray * 100.f,
            renoDRTHighlights,
            renoDRTShadows,
            renoDRTContrast,
            renoDRTSaturation,
            renoDRTDechroma,
            renoDRTFlare));

    if (injectedData.toneMapHueCorrection) {
      r1.xyz = renodx::color::correct::Hue(tonemapped, r1.xyz);
    } else {
      r1.xyz = tonemapped;
    }
  } else {  // Clamp vanilla tonemapper to BT709
    r0.xyz = max(0, r1.xyz);
  }

  r0.xyz = sign(r1.xyz) * pow(abs(r1.xyz), 1.f / 2.2f);  // Linearize before color grade

  const float3 preLUT = r0.xyz;

  r0.w = 1;
  r1.x = dot(r0.xyzw, DL_FREG_062._m00_m10_m20_m30);
  r1.y = dot(r0.xyzw, DL_FREG_062._m01_m11_m21_m31);
  r1.z = dot(r0.xyzw, DL_FREG_062._m02_m12_m22_m32);
  r0.xyz = gSMP_2.Sample(gSMP_2Sampler_s, v1.zw).xyz;
  r2.xyz = r1.xyz * r0.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  r3.xyz = float3(1, 1, 1) + -r0.xyz;
  r3.xyz = r3.xyz + r3.xyz;
  r4.xyz = float3(1, 1, 1) + -r1.xyz;
  r3.xyz = -r3.xyz * r4.xyz + float3(1, 1, 1);
  r0.xyz = cmp(float3(0.5, 0.5, 0.5) >= r0.xyz);
  r4.xyz = r0.xyz ? float3(1, 1, 1) : 0;
  r0.xyz = r0.xyz ? float3(0, 0, 0) : float3(1, 1, 1);
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = r3.xyz * r4.xyz + r0.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  //  r0.xyz = DL_FREG_068.xxx * r0.xyz + r1.xyz;
  //  DL_FREG_068.xxx = noise
  r0.xyz =
      lerp(preLUT + DL_FREG_068.xxx * r0.xyz, DL_FREG_068.xxx * r0.xyz + r1.xyz,
           injectedData.colorGradeLUTStrength);

  if (injectedData.fxFilmGrain) {
    float3 grainedColor = renodx::effects::ApplyFilmGrain(
        r0.rgb, v1.xy, frac(injectedData.elapsedTime / 1000.f),
        injectedData.fxFilmGrain * 0.03f, 1.f);
    r0.xyz = grainedColor;
  }

  if (injectedData.toneMapType == 0) {  // Cap vanilla tonemapper
    r0.xyz = clamp(r0.xyz, 0, injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
  }

  r0.rgb = injectedData.toneMapGammaCorrection
               ? sign(r0.rgb) * pow(abs(r0.rgb), 2.2f)
               : renodx::color::bt709::from::SRGB(r0.rgb);

  r0.rgb *= injectedData.toneMapGameNits / 80.f;

  r0.rgb = renodx::color::bt709::clamp::BT2020(r0.rgb);

  o0.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  o0.xyz = r0.xyz;
  return;
}