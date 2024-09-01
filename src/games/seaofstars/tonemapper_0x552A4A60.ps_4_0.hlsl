#include "./shared.h"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);  // ARRI LUT
Texture2D<float4> t4 : register(t4);  // SRGB LUT

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

cbuffer cb0 : register(b0) {
  float4 cb0[204];
}

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0) : SV_Target0 {
  float4 r0, r1, r2, r3, r4, r5;

  const float4 inputColor = t0.Sample(s0_s, v1.xy).xyzw;
  const float4 bloomColor = t2.Sample(s0_s, v1.xy).xyzw;

  float4 testColor = bloomColor;

  r0.xyzw = inputColor;
  r1.xyzw = bloomColor;

  float3 scaledBloom = bloomColor.rgb;
  if (cb0[191].x > 0) {
    // Alpha blend
    scaledBloom.rgb *= 8.f * bloomColor.a;
  }
  scaledBloom.rgb *= cb0[190].x;    // Bloom strength
  scaledBloom.rgb *= cb0[190].yzw;  // Bloom color

  if (injectedData.fxBloom) {
    r0.rgb = inputColor.rgb + scaledBloom * pow(injectedData.fxBloom, injectedData.fxBloom);
  }

  // ???
  if (cb0[198].z >= 0) {
    r1.xy = -cb0[198].xy + v1.xy;
    r1.yz = cb0[198].zz * abs(r1.xy);
    r1.x = cb0[197].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = pow(max(0, r0.w), cb0[198].w);
    r1.xyz = float3(1, 1, 1) + -cb0[197].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[197].xyz;
    r0.xyz = lerp(1.f, r1.xyz, injectedData.fxVignette) * r0.xyz;
  }

  float3 untonemapped = r0.rgb;

  // r1.rgb = cb0[188].w * r0.rgb;  // exposure

  // r1.rgb = ARRI_LOG_A * r1.rgb + ARRI_LOG_B;
  // r1.rgb = max(0, r1.rgb);
  // r1.rgb = log2(r1.rgb);
  // r1.rgb = saturate(r1.rgb * (ARRI_LOG_C * log10(2)) + ARRI_LOG_D);

  float vanillaMidGray = renodx::tonemap::unity::BT709(0.18f);

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
  config.mid_gray_value = vanillaMidGray;
  config.mid_gray_nits = vanillaMidGray * 100.f;
  config.reno_drt_dechroma = 0;

  renodx::lut::Config lut_config = renodx::lut::config::Create(
      s0_s,
      1.f,                                // Internal LUT
      injectedData.colorGradeLUTScaling,  // Cleans up raised black floor
      renodx::lut::config::type::ARRI_C1000_NO_CUT,
      renodx::lut::config::type::LINEAR,
      cb0[188].xyz  // precompute
  );

  float3 outputColor = untonemapped;
  if (config.type == 1.f) {
    outputColor = renodx::tonemap::config::Apply(untonemapped, config);
  } else {
    outputColor = renodx::lut::Sample(t3, lut_config, untonemapped * cb0[188].w);
    float useSDRLUT = (cb0[203].y == 0 && cb0[189].w >= 0);
    if (useSDRLUT) {
      // Seems to be done in LUT builder now
      // Leaving just in case

      float3 sdrLutResult = renodx::lut::Sample(
          t4,
          renodx::lut::config::Create(
              s0_s,
              cb0[189].w,
              injectedData.colorGradeLUTScaling,
              renodx::lut::config::type::SRGB,
              renodx::lut::config::type::SRGB,
              cb0[189].xyz  // precompute
              ),
          outputColor);
      outputColor = lerp(outputColor, sdrLutResult, cb0[189].w);
    }
  }

  r1.xyz = outputColor;
  if (cb0[203].x < 1) {
    // Unstyled texture
    r2.xyzw = t1.SampleLevel(s1_s, v1.xy, 0).xyzw;
    r0.w = r2.w * 255 + 0.5;
    r0.w = (uint)r0.w;
    r0.w = (int)r0.w & 3;
    r0.w = cmp((int)r0.w != 1);
    r0.w = r0.w ? 1.000000 : 0;
    r1.w = 1 + -cb0[203].x;
    r0.w = r0.w * r1.w + cb0[203].x;
    r0.xyz = float3(-1.51571655, -1.51571655, -1.51571655) * untonemapped;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = float3(1, 1, 1) + -r0.xyz;
    r2.xyz = r1.xyz + -r0.xyz;
    r1.xyz = r0.www * r2.xyz + r0.xyz;

    outputColor = lerp(outputColor.xyz, r1.xyz, injectedData.fxHeroLight);
  }

  if (injectedData.toneMapGammaCorrection) {
    // Convert to expected output
    outputColor = renodx::color::correct::GammaSafe(outputColor);

    // Adjust for shader transfer
    outputColor *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    outputColor = renodx::color::correct::GammaSafe(outputColor, true);
  } else {
    outputColor *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  }

  return float4(outputColor.rgb, 1.f);
}
