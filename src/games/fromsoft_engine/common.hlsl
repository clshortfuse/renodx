#include "./shared.h"

struct CG_Config {
  float exposure;
  float highlights;
  float shadows;
  float contrast;
  float flare;
  float saturation;
  float dechroma;
  float hue_correction_strength;
  float3 hue_correction_source;
  float hue_correction_type;  // 0 = input, 1 = output
  float blowout;
};

namespace cg_config {

namespace hue_correction_type {
static const float INPUT = 0.f;
static const float CLAMPED = 1.f;
static const float CUSTOM = 2.f;
}

CG_Config Create(
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float flare = 0.f,
    float saturation = 1.f,
    float dechroma = 0.f,
    float hue_correction_strength = 1.f,
    float3 hue_correction_source = 0,
    float hue_correction_type = cg_config::hue_correction_type::INPUT,
    float blowout = 0.f) {
  const CG_Config cg_config = {
    exposure,
    highlights,
    shadows,
    contrast,
    flare,
    saturation,
    dechroma,
    hue_correction_strength,
    hue_correction_source,
    hue_correction_type,
    blowout
  };
  return cg_config;
}

float3 ApplyUserColorGrading(
    float3 bt709,
    CG_Config config) {
  if (config.exposure == 1.f && config.saturation == 1.f && config.dechroma == 0.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f && config.hue_correction_strength == 0.f && config.blowout == 0.f) {
    return bt709;
  }

  float3 color = bt709;

  color *= config.exposure;

  float y = renodx::color::y::from::BT709(abs(color));
  const float y_normalized = y / 0.18f;

  // contrast & flare
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent);

  // highlights
  float y_highlighted = pow(y_contrasted, config.highlights);
  y_highlighted = lerp(y_contrasted, y_highlighted, saturate(y_contrasted));

  // shadows
  float y_shadowed = pow(y_highlighted, -1.f * (config.shadows - 2.f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted));

  const float y_final = y_shadowed * 0.18f;

  color *= (y > 0 ? (y_final / y) : 0);

  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.hue_correction_strength != 0.f) {
      float3 hue_correction_source;
      if (config.hue_correction_type == hue_correction_type::CUSTOM) {
        hue_correction_source = config.hue_correction_source;
      } else if (config.hue_correction_type == hue_correction_type::CLAMPED) {
        hue_correction_source = saturate(bt709);
      } else {
        hue_correction_source = bt709;
      }

      float3 perceptual_old = renodx::color::oklab::from::BT709(hue_correction_source);

      // Save chrominance to apply black
      float chrominance_pre_adjust = distance(perceptual_new.yz, 0);

      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, config.hue_correction_strength);

      float chrominance_post_adjust = distance(perceptual_new.yz, 0);

      // Apply back previous chrominance
      perceptual_new.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);
    }

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    if (config.blowout != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.blowout));
      if (config.blowout < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }

  return color;
}
}  // namespace cg_config

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f) {
  // color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

void ApplyPerChannelCorrection(float3 untonemapped, inout float3 post_tonemap) {
  // Per channel correction messes up black and white scenes
  if (RENODX_TONE_MAP_TYPE && (CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION != 0.f || CUSTOM_COLOR_GRADE_HUE_CORRECTION != 0.f || CUSTOM_COLOR_GRADE_SATURATION_CORRECTION != 0.f || CUSTOM_COLOR_GRADE_HUE_SHIFT != 0.f)) {
    post_tonemap = renodx::draw::ApplyPerChannelCorrection(
        untonemapped,
        post_tonemap,
        CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION,
        CUSTOM_COLOR_GRADE_HUE_CORRECTION,
        CUSTOM_COLOR_GRADE_SATURATION_CORRECTION,
        CUSTOM_COLOR_GRADE_HUE_SHIFT);
  }
}

float3 SampleLUT(float3 color_linear, Texture3D<float4> lut, SamplerState lut_sampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lut_sampler;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_2;
  lut_config.type_output = renodx::lut::config::type::GAMMA_2_2;
  lut_config.scaling = 1.f;

  color_linear = renodx::lut::Sample(
      lut,
      lut_config,
      ToneMapMaxCLL(color_linear));

  return color_linear;
}

float3 VanillaBlend(float3 scene_linear, float4 ui_gamma) {
  float3 scene_gamma = renodx::color::gamma::EncodeSafe(scene_linear);
  // Luminance of scene in linear space
  float scene_luminance = renodx::color::y::from::NTSC1953(scene_gamma);
  float luminance_difference = scene_luminance - 1.f;  // 1 is hardcoded here, but a cbuffer in vanilla
  float scale = luminance_difference;

  if (luminance_difference > 0.0f) {
    float blend_rate = 0.10000002384185791f;
    scale = (blend_rate * (1.0f - exp2(((-0.0f - luminance_difference) / blend_rate) * 1.4426950216293335f)));
  }

  float alphad_scale = (((1.f - scene_luminance) + scale) * (1.0f - (ui_gamma.a * ui_gamma.a))) + scene_luminance;
  float3 output = scene_gamma;
  output.rgb = scene_luminance > 0.f ? ((alphad_scale * output) / scene_luminance) : 0.0f;

  output = ((output * ui_gamma.a) + (1.f * ui_gamma.rgb));

  output = renodx::color::gamma::DecodeSafe(output);
  return output;
}

void HandleUIScale(inout float4 ui_color_gamma) {
  float3 ui_color_linear = renodx::color::gamma::DecodeSafe(ui_color_gamma.rgb);

  // ui_color_linear = renodx::color::correct::GammaSafe(ui_color_linear);
  ui_color_linear *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  ui_color_gamma.rgb = renodx::color::gamma::EncodeSafe(ui_color_linear.rgb);
}

bool ApplyLuminanceSaturationAdjustments(float3 luminance_tonemap_blend, inout float3 saturation_corrected) {
  if (RENODX_TONE_MAP_TYPE != 6.f) return false;
  
  luminance_tonemap_blend = renodx::color::grade::UserColorGrading(
      luminance_tonemap_blend,
      1.f,
      1.f,
      1.f,
      1.f,
      2.375f,  // saturation
      0.9f,    // blowout
      0.65f,   // hue shift strength
      renodx::tonemap::ExponentialRollOff(luminance_tonemap_blend, 1.f, 2.f));

  saturation_corrected = luminance_tonemap_blend;

  return true;
}

bool Tonemap(float3 untonemapped_linear, float4 sdr_linear, inout float4 SV_TARGET, float3 TEXCOORD, float midgray_lum = 0.f, float vanilla_gamma = 2.2f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;
  /* if (midgray_lum > 0.f) {
    untonemapped_linear = untonemapped_linear * (midgray_lum / 0.18f);
  } */
  renodx::draw::Config config = renodx::draw::BuildConfig();
  float3 outputColor = untonemapped_linear;

  config.peak_white_nits = 10000.f;
  outputColor = renodx::draw::UpgradeToneMapByLuminance(outputColor, ToneMapMaxCLL(outputColor), sdr_linear.rgb, 1.f);

  CG_Config grading_config = cg_config::Create();
  grading_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  grading_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  grading_config.shadows = RENODX_TONE_MAP_SHADOWS;
  grading_config.contrast = RENODX_TONE_MAP_CONTRAST;
  grading_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  grading_config.saturation = RENODX_TONE_MAP_SATURATION;
  grading_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  grading_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  outputColor = cg_config::ApplyUserColorGrading(outputColor, grading_config);

  outputColor.rgb = renodx::tonemap::ExponentialRollOff(outputColor.rgb, 0.2f, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
  if (CUSTOM_GRAIN_TYPE) {
    outputColor = renodx::effects::ApplyFilmGrain(
        outputColor.rgb,
        TEXCOORD.xy,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.01f,
        1.f);  // if 1.f = SDR range
  }
  outputColor = renodx::color::bt2020::from::BT709(outputColor.rgb);
  outputColor = renodx::draw::RenderIntermediatePass(outputColor * 100.f);

  SV_TARGET = float4(outputColor, 1.f);
  return true;
}

bool HandleFinal(float4 scene_pq, float4 ui_gamma, inout float4 SV_TARGET, float4 SV_Position) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  float3 scene_linear = renodx::draw::InvertIntermediatePass(scene_pq.rgb) / 100.f;
  scene_linear = renodx::color::bt709::from::BT2020(scene_linear);

  HandleUIScale(ui_gamma);
  float3 blended_linear = VanillaBlend(scene_linear, ui_gamma);

  SV_TARGET.rgb = renodx::draw::SwapChainPass(blended_linear).rgb;
  if (!CUSTOM_GRAIN_TYPE) {
    float random = dot(float2(171.0f, 231.0f), float2(SV_Position.x, SV_Position.y));
    SV_TARGET.rgb = ((((frac(random * 0.009345794096589088f) + -0.5f) * 0.0009775171056389809f) * CUSTOM_GRAIN_STRENGTH) + SV_TARGET.rgb);
  }
  SV_TARGET.a = 1.f;
  return true;
}
