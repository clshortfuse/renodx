#include "./shared.h"

Texture2D<float4> g_xInputTexture : register(t0);

Texture2D<float4> g_xBloomTexture : register(t1);

Texture2D<float4> g_xGodRaysTexture : register(t2);

Texture2D<float4> g_xThisFramesLuminance : register(t3);

cbuffer ToneMapperConstants : register(b1) {
  float g_fToneMapA : packoffset(c000.x);
  float g_fToneMapB : packoffset(c000.y);
  float g_fFixedLuminance : packoffset(c000.z);
  float g_fHDRGodRaysStrength : packoffset(c000.w);
  float g_fOneOverExposureRange : packoffset(c001.x);
  int g_bDynamicExposure : packoffset(c001.y);
  int g_bUseGodRays : packoffset(c001.z);
  int g_bUseBloom : packoffset(c001.w);
  int g_bUseLastFramesLuminance : packoffset(c002.x);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _13 = g_xInputTexture.Load(int3(int(SV_Position.x), int(SV_Position.y), 0));
  // RenoDX: vanilla clamps the scene at 32; HDR keeps the sun and direct reflections
  float scene_clamp = RENODX_TONE_MAP_TYPE == 0.f ? 31.9990234375f : 512.f;
  float _20 = max(min(_13.x, scene_clamp), 0.0f);
  float _21 = max(min(_13.y, scene_clamp), 0.0f);
  float _22 = max(min(_13.z, scene_clamp), 0.0f);
  bool _25 = (g_bDynamicExposure != 0);
  float4 _26 = g_xThisFramesLuminance.Load(int3(0, 0, 0));
  float _30 = select(_25, _26.x, g_fFixedLuminance);
  float _42;
  float _43;
  float _44;
  float _60;
  float _61;
  float _62;
  [branch]
  if (!(g_bUseBloom == 0)) {
    float4 _34 = g_xBloomTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
    _34.xyz *= CUSTOM_BLOOM;  // RenoDX: bloom strength slider
    _42 = (_34.x + _20);
    _43 = (_34.y + _21);
    _44 = (_34.z + _22);
  } else {
    _42 = _20;
    _43 = _21;
    _44 = _22;
  }
  [branch]
  if (!(g_bUseGodRays == 0)) {
    float4 _49 = g_xGodRaysTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
    _49.xyz *= CUSTOM_GOD_RAYS;  // RenoDX: god rays strength slider
    _60 = ((_49.x * g_fHDRGodRaysStrength) + _42);
    _61 = ((_49.y * g_fHDRGodRaysStrength) + _43);
    _62 = ((_49.z * g_fHDRGodRaysStrength) + _44);
  } else {
    _60 = _42;
    _61 = _43;
    _62 = _44;
  }
  // RenoDX: HDR path floors divisors at 1e-6 (sign kept); vanilla keeps the raw values
  float _30_divisor = RENODX_TONE_MAP_TYPE == 0.f ? _30 : (_30 < 0.f ? -1.f : 1.f) * max(abs(_30), 1e-6f);
  float tone_map_b = RENODX_TONE_MAP_TYPE == 0.f ? g_fToneMapB : (g_fToneMapB < 0.f ? -1.f : 1.f) * max(abs(g_fToneMapB), 1e-6f);
  float _70 = select(_25, ((saturate(g_fOneOverExposureRange * _30) * 0.3499999940395355f) + 0.029999999329447746f), 0.18000000715255737f) / _30_divisor;
  // RenoDX: scale the game's auto exposure response (reference_exposure = exposure at adapted luminance 1.0)
  if (_25) {
    float reference_exposure = (saturate(g_fOneOverExposureRange) * 0.3499999940395355f) + 0.029999999329447746f;
    float exposure_ratio = _70 / reference_exposure;
    float strength;
    if (exposure_ratio > 1.f) {
      strength = CUSTOM_AUTO_EXPOSURE_BRIGHTEN;
    } else {
      strength = CUSTOM_AUTO_EXPOSURE_DARKEN;
    }
    // RenoDX: limits in EV around the reference exposure
    _70 = reference_exposure * clamp(pow(exposure_ratio, strength), exp2(-CUSTOM_AUTO_EXPOSURE_LIMIT_DARKEN), exp2(CUSTOM_AUTO_EXPOSURE_LIMIT_BRIGHTEN));
  }
  float _71 = _70 * _60;
  float _72 = _70 * _61;
  float _73 = _70 * _62;
  float _77 = _71 * sqrt(_71);
  float _78 = sqrt(_72) * _72;
  float _79 = sqrt(_73) * _73;
  float _88 = _77 / ((g_fToneMapA * _77) + tone_map_b);
  float _89 = _78 / ((g_fToneMapA * _78) + tone_map_b);
  float _90 = _79 / ((g_fToneMapA * _79) + tone_map_b);
  // RenoDX: vanilla curve is u/(1+A*u) with u = x^1.5/B, so _77/B is the pre-curve HDR value
  float3 untonemapped = float3(_77, _78, _79) / tone_map_b;
  float3 vanilla = float3(_88, _89, _90);
  // RenoDX: TONE_MAP_TYPE 0 keeps vanilla (clamped), otherwise HDR tonemap path
  float3 colour;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    colour = saturate(vanilla);
  } else {
    colour = renodx::draw::ToneMapPass(untonemapped, vanilla);
    // RenoDX: the vanilla SDR reference clips per channel, so bright highlights lose colour;
    // fade toward the unreferenced tone map above ~100 nits (1.0 = diffuse white)
    [branch]
    if (CUSTOM_HIGHLIGHT_COLOUR > 0.f) {
      float3 free_colour = renodx::draw::ToneMapPass(untonemapped);
      float weight = CUSTOM_HIGHLIGHT_COLOUR * smoothstep(0.5f, 2.5f, renodx::color::y::from::BT709(colour));
      colour = lerp(colour, free_colour, weight);
    }
    // RenoDX: DICE (type 4) rolls None's image off into the peak
    [branch]
    if (RENODX_TONE_MAP_TYPE == 4.f) {
      float display_peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      if (RENODX_GAMMA_CORRECTION != 0.f) {
        display_peak = renodx::color::correct::Gamma(display_peak, RENODX_GAMMA_CORRECTION > 0.f, abs(RENODX_GAMMA_CORRECTION) == 1.f ? 2.2f : 2.4f);
      }
      // shoulder 0.5 (measured on 2 sunny views): <1% of pixels differ from None, brightest 0.01% stays at 95-98% of peak
      colour = renodx::tonemap::dice::BT709(colour, display_peak, 0.5f * display_peak);
    }
    // RenoDX: a non-finite value becomes 0 so it cannot spread through float targets (negatives stay for wide gamut)
    colour = select(isfinite(colour), colour, 0.f);
  }
  SV_Target.xyz = colour;
  float luma = dot(colour, float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  SV_Target.w = sqrt(RENODX_TONE_MAP_TYPE == 0.f ? luma : max(luma, 0.f));
  return SV_Target;
}
