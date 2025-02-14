#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 03 06:54:12 2024

cbuffer GammaBuffer : register(b10) {
  float g_GammaValue : packoffset(c0);
  float g_HdrUiBrightness : packoffset(c0.y);
  float g_sdrLutSize : packoffset(c0.z);
  float g_hdrLutSize : packoffset(c0.w);
  float g_BrightnessCorrection : packoffset(c1);
  uint g_calibrationShowGamma : packoffset(c1.y);
  uint g_calibrationShowNits : packoffset(c1.z);
  uint GammaBuffer_pad2 : packoffset(c1.w);
  float2 g_calibrationImageLowerUV : packoffset(c2);
  float2 g_calibrationImageUpperUV : packoffset(c2.z);

  // clang-format off
  struct
  {
    float P;
    float a;
    float m;
    float l;
    float c;
    float b;
  } gtParams: packoffset(c3);
  // clang-format on
}

SamplerState UISampler_s : register(s1);
SamplerState SamplerBilinear_s : register(s2);
SamplerState SceneColorSampler_s : register(s3);
Texture2D<float3> colorBuffer : register(t0);
Texture2D<float4> uiTexture : register(t1);
Texture3D<float4> RRT_ODT_LUT_Rec2020_ST2084 : register(t3);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2;

  r0.xyz = colorBuffer.Sample(SceneColorSampler_s, v2.xy).xyz;
  r0.xyz = g_BrightnessCorrection * r0.xyz;

  // r0.xyz = saturate(float3(0.00100000005, 0.00100000005, 0.00100000005) * r0.xyz);
  r0.xyz = saturate(0.00100000005 * r0.xyz);

  // r0.xyz = log2(r0.xyz);
  // r0.xyz = float3(0.25, 0.25, 0.25) * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  r0.rgb = renodx::color::gamma::Encode(r0.rgb, 4.f);

  r0.xyz = r0.xyz * float3(0.984375, 0.984375, 0.984375) + float3(0.0078125, 0.0078125, 0.0078125);

  r0.xyz = r0.xyz * 0.984375 + 0.0078125;
  r0.xyz = RRT_ODT_LUT_Rec2020_ST2084.SampleLevel(SamplerBilinear_s, r0.xyz, 0).xyz;

  // r0.xyz = saturate(r0.xyz);
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  // r1.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r0.xyz;
  // r0.xyz = -r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  // r1.xyz = max(float3(0, 0, 0), r1.xyz);
  // r0.xyz = r1.xyz / r0.xyz;
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  // r0.xyz = float3(10000, 10000, 10000) * r0.xyz;

  r0.rgb = renodx::color::pq::Decode(r0.rgb, 1.f);

  float3 graded_untonemapped = renodx::color::bt709::from::BT2020(r0.xyz);
  graded_untonemapped /= 250.f;  // Normalize

  float3 tonemapped = renodx::draw::ToneMapPass(graded_untonemapped);

  if (CUSTOM_FILM_GRAIN_STRENGTH != 0.f) {
    tonemapped = renodx::effects::ApplyFilmGrain(
        tonemapped,
        v2.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
  }

  r0.xyz = tonemapped;

  r1.xyzw = uiTexture.SampleLevel(UISampler_s, v2.xy, 0).xyzw;
  r1.xyz = g_HdrUiBrightness * r1.xyz;

  r1.xyz /= 250.f;

  // XYZ => BT2020
  // r2.x = dot(float3(0.412456393, 0.357576102, 0.180437505), r1.xyz);
  // r2.y = dot(float3(0.212672904, 0.715152204, 0.0721750036), r1.xyz);
  // r2.z = dot(float3(0.0193339009, 0.119191997, 0.950304091), r1.xyz);
  // r1.x = dot(float3(1.7166512, -0.35567078, -0.253366292), r2.xyz);
  // r1.y = dot(float3(-0.66668433, 1.61648118, 0.0157685466), r2.xyz);
  // r1.z = dot(float3(0.0176398568, -0.042770613, 0.942103148), r2.xyz);

  r0.w = 1 + -r1.w;
  r0.xyz = r0.xyz * r0.www + r1.xyz;

  r0.xyz *= RENODX_DIFFUSE_WHITE_NITS;

  // r0.xyz = saturate(float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz);
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  // r1.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
  // r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
  // r0.xyz = r1.xyz / r0.xyz;
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
  // o0.xyz = exp2(r0.xyz);

  o0.rgb = renodx::color::bt2020::from::BT709(r0.rgb);
  o0.rgb = max(0, o0.rgb);
  // o0.rgb *= RENODX_DIFFUSE_WHITE_NITS;

  if (RENODX_TONE_MAP_TYPE == 3.f) {
    // Clamp to peak in BT2020
    o0.rgb = min(o0.rgb, RENODX_PEAK_WHITE_NITS);
  }

  o0.rgb = renodx::color::pq::Encode(o0.rgb, 1.f);
  o0.w = 0;
  return;
}
