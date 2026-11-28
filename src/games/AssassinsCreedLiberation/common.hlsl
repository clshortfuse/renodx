#include "./shared.h"

#ifndef RENODX_DIFFUSE_WHITE_NITS
#define RENODX_DIFFUSE_WHITE_NITS 203.0f
#endif

cbuffer CBToneMapping : register(b3)
{
  uint iToneMapType : packoffset(c0);
  bool bLuminanceVersion : packoffset(c0.y);
  float fShouldStr : packoffset(c0.z);
  float fLinearStr : packoffset(c0.w);
  float fIntermediate : packoffset(c1);
  float fS1 : packoffset(c1.y);
  float fS2 : packoffset(c1.z);
  float fS3 : packoffset(c1.w);
  float fS4 : packoffset(c2);
  uint iLUTSize : packoffset(c2.y);
  bool bIsLinearToPQ : packoffset(c2.z);
  bool bIsPQToLinear : packoffset(c2.w);
  bool bEnableColorGrading : packoffset(c3);
}

void GamutCompression(inout float3 color, inout float compression_scale)
{
  compression_scale = 1.0f;
  color = max(color, 0.0f);
}

void GamutDecompression(inout float3 color, float compression_scale)
{
  color = max(color, 0.0f);
}

float3 HDRBoost(float3 color, float power = 0.20f, float normalization_point = 0.02f)
{
  if (power == 0.0f) return color;

  color = max(color, 0.0f);

  float smoothing = power * 2.0f;
  color = max(
      color,
      lerp(
          color,
          normalization_point * pow(max(color / normalization_point, 0.0f), 1.0f + power),
          color / ((color / smoothing) + 1.0f)));

  return max(color, 0.0f);
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(
    float3 untonemapped,
    float y,
    renodx::color::grade::Config config,
    float mid_gray = 0.18f)
{
  if (
      config.exposure == 1.0f &&
      config.shadows == 1.0f &&
      config.highlights == 1.0f &&
      config.contrast == 1.0f &&
      config.flare == 0.0f)
  {
    return untonemapped;
  }

  float3 color = max(untonemapped, 0.0f);

  color *= config.exposure;

  const float y_normalized = y / max(mid_gray, 0.000001f);
  const float highlight_mask = 1.0f / max(mid_gray, 0.000001f);
  const float shadow_mask = mid_gray;

  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.0f);
  float exponent = config.contrast * flare;

  float y_contrasted = pow(max(y_normalized, 0.0f), exponent);

  float y_highlighted = pow(max(y_contrasted, 0.0f), config.highlights);
  y_highlighted = lerp(y_contrasted, y_highlighted, saturate(y_contrasted / highlight_mask));

  float y_shadowed = pow(max(y_highlighted, 0.0f), -1.0f * (config.shadows - 2.0f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted / shadow_mask));

  float y_final = y_shadowed * mid_gray;

  color *= (y > 0.0f ? (y_final / max(y, 0.000001f)) : 0.0f);

  return max(color, 0.0f);
}

float3 ApplySaturationBlowoutHighlightSaturation(
    float3 tonemapped,
    float y,
    renodx::color::grade::Config config)
{
  float3 color = max(tonemapped, 0.0f);

  if (config.saturation != 1.0f || config.dechroma != 0.0f || config.blowout != 0.0f)
  {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.dechroma != 0.0f)
    {
      perceptual_new.yz *= lerp(
          1.0f,
          0.0f,
          saturate(pow(y / (10000.0f / 100.0f), 1.0f - config.dechroma)));
    }

    if (config.blowout != 0.0f)
    {
      float percent_max = saturate(y * 100.0f / 10000.0f);
      float blowout_strength = 100.0f;
      float blowout_change = pow(1.0f - percent_max, blowout_strength * abs(config.blowout));

      if (config.blowout < 0.0f)
      {
        blowout_change = 2.0f - blowout_change;
      }

      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);
    color = renodx::color::bt709::clamp::AP1(color);
  }

  return max(color, 0.0f);
}

float3 ApplyPerChannelBlowoutHueShift(float3 untonemapped)
{
  if (RENODX_TONE_MAP_PER_CHANNEL == 0 && CUSTOM_SCENE_GRADE_PER_CHANNEL_BLOWOUT > 0.0f)
  {
    float calculated_peak = 0.01f * pow(100.0f - CUSTOM_SCENE_GRADE_PER_CHANNEL_BLOWOUT, 2.0f);

    float3 graded_color = renodx::tonemap::HermiteSplinePerChannelRolloff(
        max(untonemapped, 0.0f),
        calculated_peak,
        100.0f);

    float3 color = renodx::color::correct::Chrominance(
        untonemapped,
        graded_color,
        1.0f,
        0.0f,
        CUSTOM_SCENE_GRADE_METHOD);

    color = renodx::color::correct::Hue(
        color,
        graded_color,
        CUSTOM_SCENE_GRADE_HUE_SHIFT,
        CUSTOM_SCENE_GRADE_METHOD);

    return max(color, 0.0f);
  }

  return max(untonemapped, 0.0f);
}

float3 PreTonemapSliders(float3 untonemapped)
{
  renodx::color::grade::Config config = renodx::color::grade::config::Create();

  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = RENODX_TONE_MAP_FLARE;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

  untonemapped = max(untonemapped, 0.0f);
  untonemapped = ApplyPerChannelBlowoutHueShift(untonemapped);
  untonemapped = HDRBoost(untonemapped, CUSTOM_HDR_BOOST);

  float y = renodx::color::y::from::BT709(untonemapped);

  return ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, config);
}

float3 PostTonemapSliders(float3 hdr_color)
{
  renodx::color::grade::Config config = renodx::color::grade::config::Create();

  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.blowout = -1.0f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.0f);

  float y = renodx::color::y::from::BT709(hdr_color);

  return ApplySaturationBlowoutHighlightSaturation(hdr_color, y, config);
}

float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.0f)
{
  if (RENODX_TONE_MAP_TYPE == 0.0f)
  {
    return color;
  }

  color = max(color, 0.0f);
  color = min(color, 100.0f);

  float peak = max(color.r, max(color.g, color.b));
  peak = clamp(peak, 0.000001f, 100.0f);

  float log_peak = log2(peak);
  float log_mapped = renodx::tonemap::ExponentialRollOff(
      log_peak,
      log2(rolloff_start),
      log2(output_max));

  float scale = exp2(log_mapped - log_peak);

  return min(output_max, color * scale);
}

float3 Dice(float3 color, float rolloff_start = 0.5f, float output_max = 1.0f)
{
  if (RENODX_TONE_MAP_TYPE == 0.0f)
  {
    return color;
  }

  return renodx::tonemap::dice::BT709(max(color, 0.0f), output_max, rolloff_start);
}

float3 NeutralSDRYLerp(float3 color)
{
  color = max(color, 0.0f);

  float color_y = renodx::color::y::from::BT709(color);
  color = lerp(color, renodx::tonemap::renodrt::NeutralSDR(color), saturate(color_y));

  return max(color, 0.0f);
}

float3 HDRDisplayMap(float3 color)
{
  if (RENODX_TONE_MAP_TYPE == 0.0f)
  {
    return saturate(color);
  }

  color = max(color, 0.0f);

  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE;

  color = renodx::draw::ToneMapPass(color, config);

  return max(color, 0.0f);
}

float3 CustomTonemap(float3 untonemapped, float2 coords)
{
  if (RENODX_TONE_MAP_TYPE == 0.0f)
  {
    return renodx::draw::RenderIntermediatePass(saturate(untonemapped));
  }

  untonemapped = max(untonemapped, 0.0f);

  untonemapped = PreTonemapSliders(untonemapped);

  float3 hdr_color = HDRDisplayMap(untonemapped);

  hdr_color = PostTonemapSliders(hdr_color);

  hdr_color = renodx::effects::ApplyFilmGrain(
      hdr_color,
      coords,
      CUSTOM_RANDOM,
      CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);

  hdr_color = max(hdr_color, 0.0f);
  hdr_color = renodx::color::bt2020::from::BT709(hdr_color);

  return renodx::draw::RenderIntermediatePass(hdr_color);
}

float3 CustomGradingBegin(float3 color)
{
  if (RENODX_TONE_MAP_TYPE == 0.0f)
  {
    return color;
  }

  color = ToneMapMaxCLL(color);

  return color;
}

float3 CustomGradingEnd(float3 ungraded_color, float3 sdr_color, float3 graded_color)
{
  if (RENODX_TONE_MAP_TYPE == 0.0f)
  {
    return graded_color;
  }

  return renodx::tonemap::UpgradeToneMap(
      max(ungraded_color, 0.0f),
      max(sdr_color, 0.0f),
      max(graded_color, 0.0f),
      CUSTOM_GRADING_STRENGTH);
}

bool IsCustomHDRMode() {
  // Type 24 is accepted while testing live shaders with the previous addon.
  return RENODX_TONE_MAP_TYPE == 3.f || RENODX_TONE_MAP_TYPE == 30.f || RENODX_TONE_MAP_TYPE == 24.f;
}

float GetWorkingPeak(float peak) {
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    return renodx::color::correct::GammaSafe(peak, true, 2.2f);
  }
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    return renodx::color::correct::GammaSafe(peak, true, 2.4f);
  }
  return peak;
}

// Original fitted ACES neutral curve at V(x)=0.18:
// x=0.26314668, V'(x)=0.90388522, logarithmic slope x*V'(x)/V(x)=1.3214133.
static const float ACES_ANCHOR_IN = 0.26314668f;
static const float ACES_ANCHOR_OUT = 0.18f;
static const float ACES_ANCHOR_CONE = 1.3214133f;

float3 MapSceneToDisplay(float3 scene, float peak, float type = -1.f) {
  if (type < 0.f) type = RENODX_TONE_MAP_TYPE;
  peak = GetWorkingPeak(peak);
  if (type == 30.f || type == 24.f) {
    return renodx::tonemap::psychov::psychotm_test30(
        scene, peak, 1.f, 1.f, 1.f, 1.f, 1.f, 1.f, 100.f, 1.f, 1.f, 0,
        ACES_ANCHOR_CONE * max(RENODX_PSYCHOV30_CONE_RESPONSE, 0.01f),
        ACES_ANCHOR_IN.xxx, ACES_ANCHOR_OUT.xxx,
        RENODX_PSYCHOV30_GAMUT_COMPRESSION,
        RENODX_PSYCHOV30_GAMUT_MODE > 0.5f ? 1 : 0,
        1.f, RENODX_PSYCHOV30_COMPRESSION);
  }
  float clip = max(100.f, peak);
  float below = renodx::tonemap::ReinhardScalableExtended(ACES_ANCHOR_IN * 0.999f, clip, peak, 0.f, ACES_ANCHOR_IN, ACES_ANCHOR_OUT);
  float above = renodx::tonemap::ReinhardScalableExtended(ACES_ANCHOR_IN * 1.001f, clip, peak, 0.f, ACES_ANCHOR_IN, ACES_ANCHOR_OUT);
  float elasticity = (above - below) / (0.002f * ACES_ANCHOR_OUT);
  renodx::tonemap::renodrt::Config config = renodx::tonemap::renodrt::config::Create();
  config.nits_peak = peak * 100.f;
  config.mid_gray_value = ACES_ANCHOR_IN;
  config.mid_gray_nits = ACES_ANCHOR_OUT * 100.f;
  config.contrast = ACES_ANCHOR_CONE / max(elasticity, 0.000001f);
  config.saturation = 1.f;
  config.dechroma = 0.f;
  config.hue_correction_strength = 0.f;
  config.tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
  config.working_color_space = RENODX_TONE_MAP_WORKING_COLOR_SPACE;
  config.per_channel = RENODX_TONE_MAP_PER_CHANNEL == 1.f;
  config.clamp_color_space = -1.f;
  config.clamp_peak = -1.f;
  config.white_clip = clip;
  return renodx::tonemap::renodrt::BT709(scene, config);
}
