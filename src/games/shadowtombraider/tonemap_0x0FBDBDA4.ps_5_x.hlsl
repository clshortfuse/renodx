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

  if (RENODX_TONE_MAP_TYPE != 0) {  // custom tonemappers
    float3 inputColor = r0.rgb;

    inputColor = applyUserToneMap(inputColor);

    r0.rgb = renodx::color::bt2020::from::BT709(inputColor);

    r1.xyzw = uiTexture.SampleLevel(UISampler_s, v2.xy, 0).xyzw;
    r0.w = 1 + -r1.w;
    r1.rgb = renodx::color::bt2020::from::BT709(r1.rgb);

    r0.xyz = r0.xyz * r0.w + r1.xyz;  // combine UI and Scene

    r0.rgb *= RENODX_DIFFUSE_WHITE_NITS;
  } else {  // Vanilla

    r0.xyz = saturate(0.00100000005 * r0.xyz);
    r0.rgb = renodx::color::gamma::Encode(r0.rgb, 4);
    r0.xyz = r0.xyz * 0.984375 + 0.0078125;
    r0.xyz = RRT_ODT_LUT_Rec2020_ST2084.SampleLevel(SamplerBilinear_s, r0.xyz, 0).xyz;
    r0.rgb = renodx::color::pq::Decode(r0.rgb, 1.f);

    r1.xyzw = uiTexture.SampleLevel(UISampler_s, v2.xy, 0).xyzw;
    r0.w = 1 + -r1.w;
    r1.xyz *= g_HdrUiBrightness;

    r1.rgb = renodx::color::bt2020::from::BT709(r1.rgb);
    r0.xyz = r0.xyz * r0.www + r1.xyz;
  }

  float3 pqColor = renodx::color::pq::Encode(r0.rgb, 1.f);  // paper white already multiplied in
  o0.rgb = pqColor;
  o0.w = 0;
  return;
}
