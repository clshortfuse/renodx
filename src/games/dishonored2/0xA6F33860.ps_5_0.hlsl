#include "./shared.h"

struct postfx_luminance_autoexposure_t {
  float EngineLuminanceFactor;
  float LuminanceFactor;
  float MinLuminanceLDR;
  float MaxLuminanceLDR;
  float MiddleGreyLuminanceLDR;
  float EV;
  float Fstop;
  uint PeakHistogramValue;
};

cbuffer PerInstanceCB : register(b2) {
  float4 cb_positiontoviewtexture : packoffset(c0);
  float4 cb_postfx_tonemapping_tonemappingparms : packoffset(c1);
  float4 cb_postfx_tonemapping_tonemappingcoeffs1 : packoffset(c2);
  float4 cb_postfx_tonemapping_tonemappingcoeffs0 : packoffset(c3);
  float4 cb_postfx_lensdirt_usedefault : packoffset(c4);
  float2 cb_env_tonemapping_gamma_brightness : packoffset(c5);
  uint2 cb_postfx_luminance_exposureindex : packoffset(c5.z);
  float cb_env_bloom_veil_strength : packoffset(c6);
  float cb_view_white_level : packoffset(c6.y);
  float cb_postfx_luminance_customevbias : packoffset(c6.z);
  float cb_postfx_lensflares_streakwidth : packoffset(c6.w);
  float cb_postfx_lensflares_streakradius : packoffset(c7);
  float cb_postfx_lensflares_streakopacity : packoffset(c7.y);
  float cb_postfx_lensflares_streakoffset : packoffset(c7.z);
  float cb_postfx_bloom_lensdirt_strength : packoffset(c7.w);
  float cb_postfx_bloom_lensdirt_blendweight : packoffset(c8);
  uint cb_postfx_bloom_enabled : packoffset(c8.y);
}

cbuffer PerViewCB : register(b1) {
  float4 cb_alwaystweak : packoffset(c0);
  float4 cb_viewrandom : packoffset(c1);
  float4x4 cb_viewprojectionmatrix : packoffset(c2);
  float4x4 cb_viewmatrix : packoffset(c6);
  float4 cb_subpixeloffset : packoffset(c10);
  float4x4 cb_projectionmatrix : packoffset(c11);
  float4x4 cb_previousviewprojectionmatrix : packoffset(c15);
  float4x4 cb_previousviewmatrix : packoffset(c19);
  float4x4 cb_previousprojectionmatrix : packoffset(c23);
  float4 cb_mousecursorposition : packoffset(c27);
  float4 cb_mousebuttonsdown : packoffset(c28);
  float4 cb_jittervectors : packoffset(c29);
  float4x4 cb_inverseviewprojectionmatrix : packoffset(c30);
  float4x4 cb_inverseviewmatrix : packoffset(c34);
  float4x4 cb_inverseprojectionmatrix : packoffset(c38);
  float4 cb_globalviewinfos : packoffset(c42);
  float3 cb_wscamforwarddir : packoffset(c43);
  uint cb_alwaysone : packoffset(c43.w);
  float3 cb_wscamupdir : packoffset(c44);
  uint cb_usecompressedhdrbuffers : packoffset(c44.w);
  float3 cb_wscampos : packoffset(c45);
  float cb_time : packoffset(c45.w);
  float3 cb_wscamleftdir : packoffset(c46);
  float cb_systime : packoffset(c46.w);
  float2 cb_jitterrelativetopreviousframe : packoffset(c47);
  float2 cb_worldtime : packoffset(c47.z);
  float2 cb_shadowmapatlasslicedimensions : packoffset(c48);
  float2 cb_resolutionscale : packoffset(c48.z);
  float2 cb_parallelshadowmapslicedimensions : packoffset(c49);
  float cb_framenumber : packoffset(c49.z);
  uint cb_alwayszero : packoffset(c49.w);
}

SamplerState smp_linearclamp_s : register(s0);
Texture2D<float4> ro_postfx_bloom_lensdirt_to : register(t0);
Texture2D<float4> ro_postfx_bloom_lensdirt_from : register(t1);
Texture3D<float4> ro_tonemapping_finalcolorcube : register(t2);
Texture2D<float4> ro_postfx_lensflares_texlensflares : register(t3);
Texture2D<float4> ro_postfx_bloom_texbloom : register(t4);
Texture2D<float4> ro_viewcolormap : register(t5);
StructuredBuffer<postfx_luminance_autoexposure_t>
    ro_postfx_luminance_buffautoexposure : register(t6);

float3 ApplyVanillaToneCurve(float3 color) {
  const bool3 use_low_curve =
      color < cb_postfx_tonemapping_tonemappingparms.xxx;
  const float4 coefficients_r = use_low_curve.r
                                    ? cb_postfx_tonemapping_tonemappingcoeffs0
                                    : cb_postfx_tonemapping_tonemappingcoeffs1;
  const float4 coefficients_g = use_low_curve.g
                                    ? cb_postfx_tonemapping_tonemappingcoeffs0
                                    : cb_postfx_tonemapping_tonemappingcoeffs1;
  const float4 coefficients_b = use_low_curve.b
                                    ? cb_postfx_tonemapping_tonemappingcoeffs0
                                    : cb_postfx_tonemapping_tonemappingcoeffs1;

  float3 numerator;
  numerator.r = coefficients_r.x * color.r + coefficients_r.z;
  numerator.g = coefficients_g.x * color.g + coefficients_g.z;
  numerator.b = coefficients_b.x * color.b + coefficients_b.z;

  float3 denominator;
  denominator.r = coefficients_r.y * color.r + coefficients_r.w;
  denominator.g = coefficients_g.y * color.g + coefficients_g.w;
  denominator.b = coefficients_b.y * color.b + coefficients_b.w;
  return numerator / denominator;
}

float3 ApplyGammaBrightness(float3 color) {
  color = saturate(cb_env_tonemapping_gamma_brightness.yyy * color);
  return exp2(
      cb_env_tonemapping_gamma_brightness.xxx * log2(color));
}

void main(float4 v0 : INTERP0, float4 v1 : SV_POSITION0,
          out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3, r4;

  r0.xy = (uint2)v1.xy;
  r0.zw = float2(0.f, 0.f);
  r0.xyz = ro_viewcolormap.Load(r0.xyz).xyz;
  r0.w = ro_postfx_luminance_buffautoexposure[cb_postfx_luminance_exposureindex.y]
             .EngineLuminanceFactor;
  r0.w = cb_view_white_level * r0.w;
  r1.xyz = r0.xyz * r0.www;
  r0.xyz = cb_usecompressedhdrbuffers ? r1.xyz : r0.xyz;

  if (cb_postfx_bloom_enabled != 0u) {
    r1.xy = cb_resolutionscale.xy * v0.xy;
    if (0.f < cb_postfx_lensdirt_usedefault.x) {
      r1.zw = cb_subpixeloffset.xy + v0.xy;
      r2.xyz = ro_postfx_bloom_lensdirt_from.SampleLevel(
                                                smp_linearclamp_s, r1.zw, 0.f)
                   .xyz;
    } else {
      r1.zw = cb_subpixeloffset.xy + v0.xy;
      r3.xyz = ro_postfx_bloom_lensdirt_from.SampleLevel(
                                                smp_linearclamp_s, r1.zw, 0.f)
                   .xyz;
      r4.xyz = ro_postfx_bloom_lensdirt_to.SampleLevel(
                                              smp_linearclamp_s, r1.zw, 0.f)
                   .xyz;
      r4.xyz = r4.xyz - r3.xyz;
      r2.xyz = cb_postfx_bloom_lensdirt_blendweight * r4.xyz + r3.xyz;
    }
    r2.xyz *= DISHONORED2_LENS_DIRT_AMOUNT;

    if (0.f < cb_env_bloom_veil_strength) {
      r3.xyz = ro_postfx_bloom_texbloom.SampleLevel(
                                           smp_linearclamp_s, r1.xy, 0.f)
                   .xyz;
      r4.xyz = r3.xyz * r0.www;
      r3.xyz = cb_usecompressedhdrbuffers ? r4.xyz : r3.xyz;
      r3.xyz = cb_env_bloom_veil_strength * r3.xyz;
      r4.xyz = cb_postfx_bloom_lensdirt_strength * r2.xyz;
      r3.xyz = r4.xyz * r3.xyz + r3.xyz;
      r0.xyz = r3.xyz * DISHONORED2_BLOOM_INTENSITY + r0.xyz;
    }

    r1.zw = float2(-0.5f, -0.5f) + v0.xy;
    r2.w = cb_viewmatrix._m02 + cb_viewmatrix._m21;
    sincos(r2.w, r3.x, r4.x);
    r3.xy = float2(-0.5f, 0.5f) * r3.xx;
    r3.z = r4.x;
    r4.x = dot(r3.zx, r1.zw);
    r4.y = dot(r3.yz, r1.zw);
    r1.z = dot(r4.xy, r4.xy);
    r1.w = min(abs(r4.x), abs(r4.y));
    r2.w = max(abs(r4.x), abs(r4.y));
    r2.w = 1.f / r2.w;
    r1.w = r2.w * r1.w;
    r2.w = r1.w * r1.w;
    r3.x = r2.w * 0.0208350997f - 0.0851330012f;
    r3.x = r2.w * r3.x + 0.180141002f;
    r3.x = r2.w * r3.x - 0.330299497f;
    r2.w = r2.w * r3.x + 0.999866009f;
    r3.x = r2.w * r1.w;
    r3.y = abs(r4.y) < abs(r4.x);
    r3.x = r3.x * -2.f + 1.57079637f;
    r3.x = r3.y ? r3.x : 0.f;
    r1.w = r1.w * r2.w + r3.x;
    r2.w = r4.y < -r4.y;
    r2.w = r2.w ? -3.141593f : 0.f;
    r1.w = r2.w + r1.w;
    r2.w = min(r4.x, r4.y);
    r3.x = max(r4.x, r4.y);
    r2.w = r2.w < -r2.w;
    r3.x = r3.x >= -r3.x;
    r2.w = r2.w ? r3.x : 0.f;
    r1.w = r2.w ? -r1.w : r1.w;
    r1.w = 3.14159274f + r1.w;
    r2.w = 651.898621f * r1.w;
    r2.w = floor(r2.w);
    r3.x = sin(r2.w);
    r3.x = 43758.5469f * r3.x;
    r3.y = 1.f + r2.w;
    r3.y = sin(r3.y);
    r3.y = 43758.5469f * r3.y;
    r3.xy = frac(r3.xy);
    r1.w = r1.w * 651.898621f - r2.w;
    r2.w = r3.y - r3.x;
    r1.w = r1.w * r2.w + r3.x;
    r1.w = r1.w * cb_postfx_lensflares_streakoffset
           + cb_postfx_lensflares_streakradius;
    r1.z = -r1.w * r1.w + r1.z;
    r1.z = -cb_postfx_lensflares_streakwidth + abs(r1.z);
    r1.w = 1.f / -cb_postfx_lensflares_streakwidth;
    r1.z = saturate(r1.z * r1.w);
    r1.w = r1.z * -2.f + 3.f;
    r1.z = r1.z * r1.z;
    r1.z = r1.w * r1.z;
    r2.xyz = r1.zzz * cb_postfx_lensflares_streakopacity + r2.xyz;
    r1.zw = float2(1.f, 1.f) / cb_resolutionscale.xy;
    r1.xy = saturate(-cb_positiontoviewtexture.zw * r1.zw + r1.xy);
    r1.xyz = ro_postfx_lensflares_texlensflares.SampleLevel(
                                                   smp_linearclamp_s, r1.xy, 0.f)
                 .xyz;
    r3.xyz = r1.xyz * r0.www;
    r1.xyz = cb_usecompressedhdrbuffers ? r3.xyz : r1.xyz;
    r2.xyz = r2.xyz * float3(0.8f, 0.8f, 0.8f)
             + float3(0.2f, 0.2f, 0.2f);
    r0.xyz = r1.xyz * r2.xyz + r0.xyz;
  }

  const float3 untonemapped = max(0.f, r0.xyz) * v0.zzz;
  float3 neutral_sdr = ApplyVanillaToneCurve(untonemapped);

  float3 lut_coordinates = neutral_sdr * 31.f + 0.5f;
  lut_coordinates *= 0.03125f;
  float3 graded_sdr = ro_tonemapping_finalcolorcube.SampleLevel(
                                                       smp_linearclamp_s, lut_coordinates, 0.f)
                          .xyz;
  graded_sdr = ApplyGammaBrightness(graded_sdr);

  if (shader_injection.override_black_clip != 0.f
      && RENODX_TONE_MAP_TYPE != 0.f) {
    const float3 neutral_black = ApplyVanillaToneCurve(0.f);
    const float3 black_lut_coordinates =
        (neutral_black * 31.f + 0.5f) * 0.03125f;
    float3 graded_black = ro_tonemapping_finalcolorcube.SampleLevel(
                                                           smp_linearclamp_s,
                                                           black_lut_coordinates,
                                                           0.f)
                              .xyz;
    graded_black = ApplyGammaBrightness(graded_black);

    neutral_sdr = Dishonored2RemoveBlackFloor(neutral_sdr, neutral_black);
    graded_sdr = Dishonored2RemoveBlackFloor(graded_sdr, graded_black);
  }

  const float3 hdr_color = RENODX_TONE_MAP_TYPE == 0.f
                               ? graded_sdr
                               : renodx::draw::ToneMapPass(
                                     untonemapped, graded_sdr, neutral_sdr);
  o0.rgb = renodx::draw::RenderIntermediatePass(hdr_color);
  o0.a = 1.f;
}
