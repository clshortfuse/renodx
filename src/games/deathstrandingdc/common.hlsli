#include "./shared.h"

#define cmp -

float3 ApplyDeathStrandingToneMap(float3 untonemapped, float4 mHDRCompressionParam1, float4 mHDRCompressionParam2,
                                  float4 mHDRCompressionParam3, uint peak = 0u) {
  float3 r0, r1, r2;
  r0.rgb = untonemapped;

  if (peak == 1u) {  // unclamped
    mHDRCompressionParam2.z = renodx::math::FLT32_MAX;
    mHDRCompressionParam2.w = renodx::math::FLT32_MAX;
    mHDRCompressionParam1.x = renodx::math::FLT32_MAX;
  }

  // part 1
  r1.xyz = mHDRCompressionParam1.y * r0.xyz + mHDRCompressionParam1.z;
  r2.xyz = mHDRCompressionParam2.x + r0.xyz;
  r2.xyz = -mHDRCompressionParam1.w / r2.xyz;
  r2.xyz = mHDRCompressionParam2.y + r2.xyz;
  r0.xyz = cmp(r0.xyz < mHDRCompressionParam2.z);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;

  // part 2
  r0.xyz = sqrt(r0.xyz);
  r1.xyz = cmp(float3(0, 0, 0) < r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = mHDRCompressionParam3.w * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r1.xyz ? r0.xyz : 0;
  r0.xyz = r0.xyz * r0.xyz;
  r0.xyz = min(mHDRCompressionParam1.x, r0.xyz);
  r1.xyz = -mHDRCompressionParam1.z + r0.xyz;
  r1.xyz = r1.xyz / mHDRCompressionParam1.y;
  r2.xyz = -mHDRCompressionParam2.y + r0.xyz;
  r2.xyz = -mHDRCompressionParam1.w / r2.xyz;
  r2.xyz = -mHDRCompressionParam2.x + r2.xyz;
  r0.xyz = cmp(r0.xyz < mHDRCompressionParam2.w);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;

  // part 3
  r1.xyz = mHDRCompressionParam1.y * r0.xyz + mHDRCompressionParam1.z;
  r2.xyz = mHDRCompressionParam3.y + r0.xyz;
  r2.xyz = -mHDRCompressionParam3.x / r2.xyz;
  r2.xyz = mHDRCompressionParam3.z + r2.xyz;
  r0.xyz = cmp(r0.xyz < mHDRCompressionParam2.z);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;

  return r0.rgb;
}

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    // value = max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), x));
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {  // highlights < 1.f
    x /= mid_gray;
    return lerp(x, pow(x, highlights), step(1.f, x)) * mid_gray;
  }
}

float Shadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.f) return x;

  const float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  const float base_term = x * mid_gray;
  const float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);

  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {  // shadows < 1.f
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  // contrast & flare
  const float y_normalized = y / mid_gray;
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent) * mid_gray;

  // highlights
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);

  // shadows
  float y_shadowed = Shadows(y_highlighted, config.shadows, mid_gray);

  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 untonemapped, float y, renodx::color::grade::Config config, float chrominance_emulation = 0.f) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f || chrominance_emulation != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    // hue and chrominance emulation
    if (config.hue_correction_strength != 0.0 || chrominance_emulation != 0.0) {
      const float3 reference_oklab = renodx::color::oklab::from::BT709(untonemapped);

      float chrominance_current = length(perceptual_new.yz);
      float chrominance_ratio = 1.0;

      if (config.hue_correction_strength != 0.0) {
        const float chrominance_pre = chrominance_current;
        perceptual_new.yz = lerp(perceptual_new.yz, reference_oklab.yz, config.hue_correction_strength);
        const float chrominancePost = length(perceptual_new.yz);
        chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
        chrominance_current = chrominancePost;
      }

      if (chrominance_emulation != 0.0) {
        const float reference_chrominance = length(reference_oklab.yz);
        float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
        chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_emulation);
      }
      perceptual_new.yz *= chrominance_ratio;
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

float3 ToneMapForLUT(inout float r, inout float g, inout float b, inout float3 untonemapped) {
  untonemapped = max(0, float3(r, g, b));
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return untonemapped;
  }

  // some clipping is required for cufflink light to remain blue, so we do luminance tonemap then clip
  float y_in = renodx::color::y::from::BT709(untonemapped);
  float y_out = renodx::tonemap::ReinhardPiecewise(y_in, 1.f, 0.18f);
  float3 tonemapped = renodx::color::correct::Luminance(untonemapped, y_in, y_out);
  tonemapped = min(tonemapped, 1.f);

  r = tonemapped.r, g = tonemapped.g, b = tonemapped.b;

  return tonemapped;
}

float3 ApplyHermiteSplineByMaxChannel(float3 input, float peak_white, float white_clip = 100.f) {
  float max_channel = renodx::math::Max(input.r, input.g, input.b);

  float mapped_peak = exp2(renodx::tonemap::HermiteSplineRolloff(log2(max_channel), log2(peak_white), log2(white_clip)));
  float scale = renodx::math::DivideSafe(mapped_peak, max_channel, 1.f);
  float3 tonemapped = input * scale;
  return tonemapped;
}

float3 ApplyDisplayMap(float3 undisplaymapped) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_DECHROMA;
  cg_config.hue_correction_strength = RENODX_TONE_MAP_HUE_SHIFT;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  float chrominance_emulation = RENODX_TONE_MAP_BLOWOUT;
  float y = renodx::color::y::from::BT709(undisplaymapped);
  // blow out and hue shift before max channel tonemap
  float3 hue_chrominance_source = renodx::tonemap::ReinhardPiecewise(undisplaymapped, 12.5f, 1.f);

  undisplaymapped = ApplyExposureContrastFlareHighlightsShadowsByLuminance(undisplaymapped, y, cg_config, 0.18f);
  undisplaymapped = ApplySaturationBlowoutHueCorrectionHighlightSaturation(undisplaymapped, hue_chrominance_source, y, cg_config, chrominance_emulation);

  float3 displaymapped;
  if (RENODX_TONE_MAP_TYPE == 2.f) {
    float peak_white = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION) peak_white = renodx::color::correct::GammaSafe(peak_white, true);

    displaymapped = renodx::color::bt709::from::BT2020(
        ApplyHermiteSplineByMaxChannel(renodx::color::bt2020::from::BT709(undisplaymapped), peak_white, 100.f));
  } else {
    displaymapped = undisplaymapped;
  }

  return displaymapped;
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  float3 result = renodx::color::correct::Hue(corrected_color, incorrect_color);

  return result;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);
  } else {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  }

  return corrected_color;
}

float3 ScaleScene(float3 color_scene) {
  if (RENODX_GAMMA_CORRECTION == 0.f) {
    color_scene *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  } else {
    color_scene = ApplyGammaCorrection(color_scene);
    color_scene *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color_scene = renodx::color::correct::GammaSafe(color_scene, true);
  }

  return color_scene;
}

void UpgradeToneMapApplyDisplayMapAndScale(float3 untonemapped, float3 tonemapped,
                                           inout float graded_r, inout float graded_g, inout float graded_b) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return;
  float3 undisplaymapped = renodx::tonemap::UpgradeToneMap(untonemapped, tonemapped, float3(graded_r, graded_g, graded_b), 1.f);

  float3 displaymapped = ApplyDisplayMap(undisplaymapped);

  displaymapped = ScaleScene(displaymapped);

  graded_r = displaymapped.r, graded_g = displaymapped.g, graded_b = displaymapped.b;
  return;
}

float DPForPQ(float3 a, float3 b) {
  precise float _209 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _209));
}

void EncodePQ(float3 color_bt709, float mOETFSettings_x, float mOETFSettings_y, inout float b, inout float g, inout float r) {
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 color_bt2020 = renodx::color::bt2020::from::BT709(color_bt709);
    float3 color_pq = renodx::color::pq::EncodeSafe(color_bt2020, RENODX_DIFFUSE_WHITE_NITS);
    r = color_pq.r, g = color_pq.g, b = color_pq.b;
  } else {
    float3 _975 = color_bt709;
    float _992 = exp2(mOETFSettings_x * log2(mOETFSettings_y * DPForPQ(float3(0.627403914928436279296875f, 0.3292830288410186767578125f, 0.0433130674064159393310546875f), _975)));
    float _993 = exp2(log2(mOETFSettings_y * DPForPQ(float3(0.069097287952899932861328125f, 0.9195404052734375f, 0.01136231608688831329345703125f), _975)) * mOETFSettings_x);
    float _994 = exp2(log2(mOETFSettings_y * DPForPQ(float3(0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f), _975)) * mOETFSettings_x);
    b = exp2(log2(mad(_994, 18.8515625f, 0.8359375f) / mad(_994, 18.6875f, 1.0f)) * 78.84375f);
    g = exp2(log2(mad(_993, 18.8515625f, 0.8359375f) / mad(_993, 18.6875f, 1.0f)) * 78.84375f);
    r = exp2(log2(mad(_992, 18.8515625f, 0.8359375f) / mad(_992, 18.6875f, 1.0f)) * 78.84375f);
  }
  return;
}

void DecodePQ(float3 color_pq, float mOETFSettings_x, float mOETFSettings_y, inout float b, inout float g, inout float r) {
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 color_bt2020 = renodx::color::pq::DecodeSafe(color_pq, RENODX_DIFFUSE_WHITE_NITS);
    float3 color_bt709 = renodx::color::bt709::from::BT2020(color_bt2020);
    r = color_bt709.r, g = color_bt709.g, b = color_bt709.b;
  } else {
    float _133 = color_pq.x, _134 = color_pq.y, _135 = color_pq.z;
    float _206 = exp2(log2(_133) * 0.0126833133399486541748046875f);
    float _207 = exp2(log2(_134) * 0.0126833133399486541748046875f);
    float _208 = exp2(log2(_135) * 0.0126833133399486541748046875f);
    float _226 = 1.0f / mOETFSettings_x;
    float _227 = 1.0f / mOETFSettings_y;
    float3 _240 = float3(exp2(_226 * log2(max((_206 - 0.8359375f) / mad(_206, -18.6875f, 18.8515625f), 0.0f))) * _227, exp2(_226 * log2(max((_207 - 0.8359375f) / mad(_207, -18.6875f, 18.8515625f), 0.0f))) * _227, exp2(_226 * log2(max((_208 - 0.8359375f) / mad(_208, -18.6875f, 18.8515625f), 0.0f))) * _227);
    b = DPForPQ(float3(-0.01815080083906650543212890625f, -0.100579001009464263916015625f, 1.11872994899749755859375f), _240);
    g = DPForPQ(float3(-0.12454999983310699462890625f, 1.1328999996185302734375f, -0.008349419571459293365478515625f), _240);
    r = DPForPQ(float3(1.6604900360107421875f, -0.5876410007476806640625f, -0.0728498995304107666015625f), _240);
  }
  return;
}
// #pragma warning(push)
// #pragma warning(disable: 4000)
bool GenerateOutput(float3 color_bt709, inout float4 output, bool clamp_peak = false) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    color_bt709 = renodx::color::correct::GammaSafe(color_bt709);
  }
  float3 color_bt2020 = renodx::color::bt2020::from::BT709(color_bt709);
  color_bt2020 *= RENODX_GRAPHICS_WHITE_NITS;
  color_bt2020 = (clamp_peak && RENODX_TONE_MAP_TYPE != 1.f) ? min(color_bt2020, RENODX_PEAK_WHITE_NITS) : color_bt2020;
  float3 color_pq = renodx::color::pq::EncodeSafe(color_bt2020, 1.f);

  output.rgb = color_pq;
  return true;
}

void ReScaleBrightnessAndGammaCorrectForTAA(inout float r, inout float g, inout float b, bool clamp_peak = false) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
  } else {
    float3 scene_pq = float3(r, g, b);
    float3 color_linear = renodx::color::pq::DecodeSafe(scene_pq, RENODX_DIFFUSE_WHITE_NITS);
    color_linear = renodx::color::bt709::from::BT2020(color_linear);
    if (RENODX_GAMMA_CORRECTION) {
      color_linear = renodx::color::correct::GammaSafe(color_linear);
    }
    color_linear = renodx::color::bt2020::from::BT709(color_linear) * RENODX_GRAPHICS_WHITE_NITS;
    color_linear = (clamp_peak && RENODX_TONE_MAP_TYPE != 1.f) ? min(color_linear, RENODX_PEAK_WHITE_NITS) : color_linear;
    scene_pq = renodx::color::pq::EncodeSafe(color_linear, 1.f);
    r = scene_pq.r, g = scene_pq.g, b = scene_pq.b;
  }
  return;
}

void FinalizeOutput(float3 color_bt709, float mOETFSettings_x, float mOETFSettings_y, inout float r, inout float g, inout float b, bool clamp_peak = false) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float _740 = exp2(mOETFSettings_x * log2(mOETFSettings_y * DPForPQ(float3(0.627403914928436279296875f, 0.3292830288410186767578125f, 0.0433130674064159393310546875f), color_bt709)));
    float _741 = exp2(log2(mOETFSettings_y * DPForPQ(float3(0.069097287952899932861328125f, 0.9195404052734375f, 0.01136231608688831329345703125f), color_bt709)) * mOETFSettings_x);
    float _742 = exp2(log2(mOETFSettings_y * DPForPQ(float3(0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f), color_bt709)) * mOETFSettings_x);
    b = exp2(log2(mad(_742, 18.8515625f, 0.8359375f) / mad(_742, 18.6875f, 1.0f)) * 78.84375f);
    g = exp2(log2(mad(_741, 18.8515625f, 0.8359375f) / mad(_741, 18.6875f, 1.0f)) * 78.84375f);
    r = exp2(log2(mad(_740, 18.8515625f, 0.8359375f) / mad(_740, 18.6875f, 1.0f)) * 78.84375f);
  } else {
    if (RENODX_GAMMA_CORRECTION != 0.f) {
      color_bt709 = renodx::color::correct::GammaSafe(color_bt709);
    }
    float3 color_bt2020 = renodx::color::bt2020::from::BT709(color_bt709);
    color_bt2020 *= RENODX_GRAPHICS_WHITE_NITS;
    color_bt2020 = (clamp_peak && RENODX_TONE_MAP_TYPE != 1.f) ? min(color_bt2020, RENODX_PEAK_WHITE_NITS) : color_bt2020;
    float3 color_pq = renodx::color::pq::EncodeSafe(color_bt2020, 1.f);

    r = color_pq.r, g = color_pq.g, b = color_pq.b;
  }
  return;
}

// #pragma warning(pop)