#include "./tonemap.hlsli"

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

float3 ApplyToneMap(float3 untonemapped) {
  if (RENODX_TONE_MAP_TYPE == 1.f) return untonemapped;

  float4 r0, r1, r2, r3, r4, r5;
  float3 tonemapped = untonemapped;
  float y_in, y_out;
  r0.rgb = untonemapped;

  r0.w = gSMP_5.Sample(gSMP_5Sampler_s, float2(0.5, 0.5)).x;
  r0.w = max(DL_FREG_056.z, r0.w);
  r0.w = min(DL_FREG_056.w, r0.w);
  r0.w = DL_FREG_054.x / (10e-05 + r0.w);
  r2.xyz = r0.xyz * r0.www;
  untonemapped = r2.rgb;

  uint vanilla_tonemap_type = (uint)DL_FREG_057.x;
  switch (vanilla_tonemap_type) {
    case 0u:  // uncharted2
      float A = DL_FREG_055.x, B = DL_FREG_055.y, C = DL_FREG_055.z, D = DL_FREG_055.w, E = DL_FREG_054.z, F = DL_FREG_054.w;
      float W = DL_FREG_054.y;
      float white_precompute = 1.f / renodx::tonemap::ApplyCurve(W, A, B, C, D, E, F);

      if (RENODX_TONE_MAP_TYPE == 0.f) {
        tonemapped = renodx::tonemap::ApplyCurve(untonemapped, A, B, C, D, E, F) * white_precompute;
      } else {
        float coeffs[6] = { A, B, C, D, E, F };
        Uncharted2::Config::Uncharted2ExtendedConfig uc2_config = Uncharted2::Config::CreateUncharted2ExtendedConfig(coeffs, white_precompute);
        tonemapped = Uncharted2::ApplyExtended(untonemapped, uc2_config);
      }

      break;
    case 1u:  // Reinhard
      y_in = max(10e-05, renodx::color::y::from::BT709(untonemapped));
      y_out = renodx::tonemap::Reinhard(y_in);
      if (RENODX_TONE_MAP_TYPE != 0.f) {
        y_out = ApplyReinhardPlus(y_in, y_out);
      }
      tonemapped = untonemapped * (y_out / y_in);

      break;
    case 2u:  // Reinhard Extended
      y_in = max(10e-05, renodx::color::y::from::BT709(untonemapped));
      y_out = renodx::tonemap::ReinhardExtended(y_in, DL_FREG_054.y, 1.0f);
      if (RENODX_TONE_MAP_TYPE != 0.f) {
        y_out = ApplyReinhardExtendedPlus(y_in, y_out, DL_FREG_054.y, 1.f);
      }
      tonemapped = untonemapped * (y_out / y_in);

      break;
    default:
      tonemapped = float3(1, 0, 1);
      break;
  }

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    tonemapped = saturate(tonemapped);
  }

  return tonemapped;
}

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  float3 working_color;

  r0.xyz = gSMP_0.Sample(gSMP_0Sampler_s, v1.xy).xyz;  // main render
  r0.xyz = max(10e-07, r0.xyz);
  r1.xyzw = gSMP_1.Sample(gSMP_1Sampler_s, v1.xy).wxyz;
  r1.yzw = max(10e-07, r1.yzw);

  r1.x = saturate(r1.x);
  r2.xyz = gSMP_3.Sample(gSMP_3Sampler_s, v1.xy).xyz;
  r0.w = DL_FREG_071.y + -DL_FREG_056.x;
  r0.w = r1.x * r0.w + DL_FREG_056.x;
  r0.xyz = r0.www * r1.yzw + r0.xyz;
  r0.xyz = DL_FREG_056.yyy * r2.xyz + r0.xyz;

  working_color = r0.rgb;

  r1.rgb = ApplyToneMap(r0.rgb);
  working_color = r1.rgb;

  r0.rgb = renodx::color::gamma::EncodeSafe(r1.rgb, 2.2f);
  working_color = r0.rgb;
  {  // color filter
    r0.w = 1;
    r1.x = dot(r0.xyzw, DL_FREG_062._m00_m10_m20_m30);
    r1.y = dot(r0.xyzw, DL_FREG_062._m01_m11_m21_m31);
    r1.z = dot(r0.xyzw, DL_FREG_062._m02_m12_m22_m32);
    working_color = lerp(r0.rgb, r1.rgb, RENODX_COLOR_GRADE_STRENGTH);

#if 0
    if (RENODX_TONE_MAP_TYPE != 0.f) {
      working_color = lerp(r0.rgb, working_color, saturate(r0.rgb / 0.18f));
      working_color = renodx::color::gamma::EncodeSafe(renodx::lut::RecolorUnclamped(renodx::color::bt709::clamp::BT2020(renodx::color::gamma::DecodeSafe(r1.rgb)), renodx::color::bt709::clamp::BT2020(renodx::color::gamma::DecodeSafe(working_color)), 1.f));
    }
#endif
  }

  if (CUSTOM_GRAIN_TYPE == 0.f) {  // noise
    r0.xyz = gSMP_2.Sample(gSMP_2Sampler_s, v1.zw).xyz;
    r2.xyz = working_color * r0.xyz;
    r2.xyz = r2.xyz + r2.xyz;
    r3.xyz = float3(1, 1, 1) + -r0.xyz;
    r3.xyz = r3.xyz + r3.xyz;
    r4.xyz = float3(1, 1, 1) + -working_color;
    r3.xyz = -r3.xyz * r4.xyz + float3(1, 1, 1);
    r0.xyz = cmp(float3(0.5, 0.5, 0.5) >= r0.xyz);
    r4.xyz = r0.xyz ? float3(1, 1, 1) : 0;
    r0.xyz = r0.xyz ? float3(0, 0, 0) : float3(1, 1, 1);
    r0.xyz = r2.xyz * r0.xyz;
    r0.xyz = r3.xyz * r4.xyz + r0.xyz;
    r0.xyz = r0.xyz + -working_color;
    working_color = DL_FREG_068.xxx * r0.xyz + working_color;
  }

  working_color = renodx::color::gamma::DecodeSafe(working_color, 2.2f);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    working_color = saturate(working_color);
  } else {
    working_color = renodx::color::bt709::clamp::BT2020(working_color);
    working_color = ApplyUserGrading(working_color);

    if (RENODX_TONE_MAP_TYPE != 1.f) {
      float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      working_color = ApplyHermiteSplineByMaxChannel(working_color, RENODX_DIFFUSE_WHITE_NITS, RENODX_PEAK_WHITE_NITS);
    }
  }

  if (CUSTOM_GRAIN_TYPE != 0.f) {
    working_color = renodx::effects::ApplyFilmGrain(working_color, v1.xy, CUSTOM_RANDOM, CUSTOM_GRAIN_STRENGTH * 0.03f);
  }

  working_color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  working_color = renodx::color::gamma::EncodeSafe(working_color, 2.2f);

  o0.w = renodx::color::luma::from::BT601(max(0, working_color));
  o0.xyz = working_color;
  return;
}
