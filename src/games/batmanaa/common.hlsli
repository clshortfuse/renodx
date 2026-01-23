#include "./brightnesslimiter.hlsli"
#include "./shared.h"

float3 ApplyCustomLensFlare(float3 flare) {
  if (CUSTOM_LENS_FLARE_TYPE != 0.f) {
    float y_in = renodx::color::y::from::BT709(flare);
    float y_out = renodx::color::grade::Highlights(y_in, 3.f, 0.18f);
    float3 boosted = renodx::color::correct::Luminance(flare, y_in, y_out);
    flare = lerp(flare, boosted, saturate(y_in / 0.5f));
  }
  return flare;
}

// Restores the source color hue (and optionally brightness) through Oklab (this works on colors beyond SDR in brightness and gamut too).
// The strength sweet spot for a strong hue restoration seems to be 0.75, while for chrominance, going up to 1 is ok.
float3 RestoreHueAndChrominance(float3 targetColor, float3 sourceColor, float hueStrength = 0.75, float chrominanceStrength = 1.0, float minChrominanceChange = 0.0, float maxChrominanceChange = 3.40282346638528859812e+38, float lightnessStrength = 0.0, float clampChrominanceLoss = 0.0) {
  if (hueStrength == 0.0 && chrominanceStrength == 0.0 && lightnessStrength == 0.0)  // Static optimization (useful if the param is const)
    return targetColor;

  // Invalid or black colors fail oklab conversions or ab blending so early out
  if (renodx::color::y::from::BT709(targetColor) <= 1.175494351e-38f)
    return targetColor;  // Optionally we could blend the target towards the source, or towards black, but there's no need until proven otherwise

  const float3 sourceOklab = renodx::color::oklab::from::BT709(sourceColor);
  float3 targetOklab = renodx::color::oklab::from::BT709(targetColor);

  targetOklab.x = lerp(targetOklab.x, sourceOklab.x, lightnessStrength);  // TODOFT5: the alt method was used by Bioshock 2, did it make sense? Should it be here?

  float currentChrominance = length(targetOklab.yz);

  if (hueStrength != 0.0) {
    // First correct both hue and chrominance at the same time (oklab a and b determine both, they are the color xy coordinates basically).
    // As long as we don't restore the hue to a 100% (which should be avoided?), this will always work perfectly even if the source color is pure white (or black, any "hueless" and "chromaless" color).
    // This method also works on white source colors because the center of the oklab ab diagram is a "white hue", thus we'd simply blend towards white (but never flipping beyond it (e.g. from positive to negative coordinates)),
    // and then restore the original chrominance later (white still conserving the original hue direction, so likely spitting out the same color as the original, or one very close to it).
    const float chrominancePre = currentChrominance;
    targetOklab.yz = lerp(targetOklab.yz, sourceOklab.yz, hueStrength);
    const float chrominancePost = length(targetOklab.yz);
    // Then restore chrominance to the original one
    float chrominanceRatio = renodx::math::SafeDivision(chrominancePre, chrominancePost, 1);
    targetOklab.yz *= chrominanceRatio;
    // currentChrominance = chrominancePre; // Redundant
  }

  if (chrominanceStrength != 0.0) {
    const float sourceChrominance = length(sourceOklab.yz);
    // Scale original chroma vector from 1.0 to ratio of target to new chroma
    // Note that this might either reduce or increase the chroma.
    float targetChrominanceRatio = renodx::math::SafeDivision(sourceChrominance, currentChrominance, 1);
    // Optional safe boundaries (0.333x to 2x is a decent range)
    targetChrominanceRatio = clamp(targetChrominanceRatio, minChrominanceChange, maxChrominanceChange);
    float chromaScale = lerp(1.0, targetChrominanceRatio, chrominanceStrength);

    if (clampChrominanceLoss > 0.0) {
      float needsClamp = 1.0f - step(1.0f, chromaScale);  // 1 when chromaScale < 1
      chromaScale = lerp(chromaScale, 1.0f, needsClamp * clampChrominanceLoss);
    }

    targetOklab.yz *= chromaScale;
  }

  return renodx::color::bt709::from::OkLab(targetOklab);
}

// Linear BT.709 in and out. Restore the fog hue and chrominance, to indeed have a look closer to vanilla
float3 FixColorFade(float3 Scene, float3 Fade, float clampChrominanceLoss = 0.0, float FogCorrectionAverageBrightness = 4.f) {
  // const float FogCorrectionAverageBrightness = 4.f;  // increase to limit effect to darker parts
  const float FogCorrectionMinBrightness = 0.0;
  const float FogCorrectionHue = 1.0;  // 1 might break and turn brown due to divisions by 0 or something, anyway fog is usually grey in Cronos, even if there's a slight different white point between the working and output color spaces (D60 vs D65)
  const float FogCorrectionChrominance = 1.0;
  const float FogCorrectionIntensity = 1.0;

  float3 sceneWithFog = Scene + Fade;
  float3 prevSceneWithFog = sceneWithFog;

  float fadeMax = max(abs(Fade.x), max(abs(Fade.y), abs(Fade.z)));  // This might have values below zero but it should be ok
  float3 normalizedFade = fadeMax != 0.0 ? (Fade / fadeMax) : Fade;
  float3 fadeOklab = renodx::color::oklab::from::BT709(normalizedFade);

  float3 sceneOklab = renodx::color::oklab::from::BT709(Scene);

  const float fogBrightness = saturate((FogCorrectionAverageBrightness * sceneOklab.x) + FogCorrectionMinBrightness);  // Restore an optional min amount of fog on black and a good amount of fog on non black backgrounds
  const float fogHue = FogCorrectionHue * saturate(length(fadeOklab.yz) / sqrt(2.0));                                  // Restoring the fog hue might look good if the fog was colorful, but if it was just grey, then it'd randomly shift the background hue to an ugly value, so we scale the fog hue restoration by the chrominance of the fade (it seems like it's usually white/grey in Cronos)
  const float fogChrominance = FogCorrectionChrominance;                                                               // Restore the fog chrominance to a 100%, which means we'd either desaturate or saturate the background
  sceneWithFog = RestoreHueAndChrominance(Scene, sceneWithFog, fogHue, fogChrominance, 0.f, 3.40282346638528859812e+38, fogBrightness, clampChrominanceLoss);

  return lerp(prevSceneWithFog, sceneWithFog, FogCorrectionIntensity);
}

float3 ConditionalSaturate(float3 color, bool clamp_negatives = true) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    color = saturate(color);
  } else if (clamp_negatives) {
    color = max(0, color);
  }
  return color;
}

float3 ConditionalClipShadows(float3 color, bool clamp_negatives = true) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    color = max(color, 0.0001f);
  } else if (clamp_negatives) {
    color = max(0, color);
  }
  return color;
}

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    // value = max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), x));
    return max(x,
               lerp(x, mid_gray * pow(x / mid_gray, highlights),
                    renodx::tonemap::ExponentialRollOff(x, 1.f, 1.1f)));
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
#if 0
  // const float highlights = 1 + (sign(config.highlights - 1) * pow(abs(config.highlights - 1), 10.f));
  // float y_highlighted = renodx::color::grade::Highlights(y_contrasted, config.highlights, mid_gray);
#else
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);
#endif
  // shadows
  float y_shadowed = Shadows(y_highlighted, config.shadows, mid_gray);

  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 RestoreHueAndChrominance(float3 incorrect_color, float3 reference_color, float hue_strength = 0.5, float chrominance_strength = 1.0) {
  const float3 reference_oklab = renodx::color::oklab::from::BT709(reference_color);
  float3 incorrect_oklab = renodx::color::oklab::from::BT709(incorrect_color);

  float chrominance_current = length(incorrect_oklab.yz);
  float chrominance_ratio = 1.0;

  if (hue_strength != 0.0) {
    const float chrominance_pre = chrominance_current;
    incorrect_oklab.yz = lerp(incorrect_oklab.yz, reference_oklab.yz, hue_strength);
    const float chrominancePost = length(incorrect_oklab.yz);
    chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
    chrominance_current = chrominancePost;
  }

  if (chrominance_strength != 0.0) {
    const float reference_chrominance = length(reference_oklab.yz);
    float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
    chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_strength);
  }
  incorrect_oklab.yz *= chrominance_ratio;

  return renodx::color::bt709::from::OkLab(incorrect_oklab);
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

#if 0
    // if (config.hue_correction_strength != 0.f) {
    //   float3 perceptual_old = renodx::color::oklab::from::BT709(hue_reference_color);

    //   // Save chrominance to apply black
    //   float chrominance_pre_adjust = distance(perceptual_new.yz, 0);

    //   perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, config.hue_correction_strength);

    //   float chrominance_post_adjust = distance(perceptual_new.yz, 0);

    //   // Apply back previous chrominance
    //   perceptual_new.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);
    // }

    // if (config.dechroma != 0.f) {
    //   perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    // }
#else
    if (config.hue_correction_strength != 0.0 || config.dechroma != 0.0) {
      const float3 reference_oklab = renodx::color::oklab::from::BT709(hue_reference_color);

      float chrominance_current = length(perceptual_new.yz);
      float chrominance_ratio = 1.0;

      if (config.hue_correction_strength != 0.0) {
        const float chrominance_pre = chrominance_current;
        perceptual_new.yz = lerp(perceptual_new.yz, reference_oklab.yz, config.hue_correction_strength);
        const float chrominancePost = length(perceptual_new.yz);
        chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
        chrominance_current = chrominancePost;
      }

      if (config.dechroma != 0.0) {
        const float reference_chrominance = length(reference_oklab.yz);
        float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
        chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, config.dechroma);
      }
      perceptual_new.yz *= chrominance_ratio;
    }
#endif

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

float3 ApplyHermiteSplineByLuminance(float3 input, float diffuse_nits, float peak_nits) {
  const float peak_ratio = peak_nits / diffuse_nits;
  float white_clip = max(RENODX_TONE_MAP_WHITE_CLIP, peak_ratio * 1.5f);

  float y_in = renodx::color::y::from::BT709(input);
  float input_pq = renodx::color::pq::Encode(y_in, diffuse_nits);
  float target_white_pq = renodx::color::pq::Encode(peak_nits, 1.f);
  float max_white_pq = renodx::color::pq::Encode(white_clip, diffuse_nits);
  float target_black_pq = renodx::color::pq::Encode(0.0001f, 1.f);
  float min_black_pq = renodx::color::pq::Encode(0.f, 1.f);

  float scaled = renodx::tonemap::HermiteSplineRolloff(input_pq, target_white_pq, max_white_pq, target_black_pq, min_black_pq);

  float y_out = (renodx::color::pq::Decode(scaled, diffuse_nits));
  y_out = min(y_out, peak_ratio);

  float3 new_color = renodx::color::correct::Luminance(input, y_in, y_out);

  return new_color;
}

float3 ApplyHermiteSplineByMaxChannel(float3 input, float diffuse_nits, float peak_nits) {
  const float peak_ratio = peak_nits / diffuse_nits;
  float white_clip = max(RENODX_TONE_MAP_WHITE_CLIP, peak_ratio * 1.5f);  // safeguard to prevent artifacts

  float max_channel = renodx::math::Max(input.r, input.g, input.b);

  float max_pq = renodx::color::pq::Encode(max_channel, diffuse_nits);
  float target_white_pq = renodx::color::pq::Encode(peak_nits, 1.f);
  float max_white_pq = renodx::color::pq::Encode(white_clip, diffuse_nits);
  float target_black_pq = renodx::color::pq::Encode(0.0001f, 1.f);
  float min_black_pq = renodx::color::pq::Encode(0.f, 1.f);

  float scaled_pq = renodx::tonemap::HermiteSplineRolloff(max_pq, target_white_pq, max_white_pq, target_black_pq, min_black_pq);

  float mapped_max = renodx::color::pq::Decode(scaled_pq, diffuse_nits);
  mapped_max = min(mapped_max, peak_ratio);

  float scale = renodx::math::DivideSafe(mapped_max, max_channel, 0.f);
  return input * scale;
}

renodx::color::grade::Config CreateColorGradeConfig() {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = RENODX_TONE_MAP_HUE_SHIFT;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

  return cg_config;
}

float3 ApplyToneMap(float3 untonemapped, float2 position, sampler2D SceneColorTexture, bool use_grain = true, bool use_abl = true) {
  float3 tonemapped;
  untonemapped = renodx::color::gamma::DecodeSafe(untonemapped);

  if (RENODX_TONE_MAP_TYPE == 0) {
    tonemapped = saturate(untonemapped);
  } else {
    // set up grading config
    const renodx::color::grade::Config cg_config = CreateColorGradeConfig();
    float3 hue_correction_source = untonemapped;
    const float y = renodx::color::y::from::BT709(untonemapped);

    float3 untonemapped_graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, cg_config);
    if (RENODX_TONE_MAP_HUE_SHIFT > 0.f || RENODX_TONE_MAP_BLOWOUT > 0.f) {
      hue_correction_source = renodx::tonemap::ReinhardPiecewise(untonemapped, 4.f, 1.f);
    }
    untonemapped_graded = ApplySaturationBlowoutHueCorrectionHighlightSaturation(untonemapped_graded, hue_correction_source, y, cg_config);

    if (RENODX_TONE_MAP_TYPE == 1.f) {
      tonemapped = untonemapped_graded;
    } else {
      tonemapped = ApplyHermiteSplineByMaxChannel(untonemapped_graded, RENODX_DIFFUSE_WHITE_NITS, RENODX_PEAK_WHITE_NITS);
    }
  }

  if (use_abl && RENODX_AUTO_BRIGHTNESS_LIMIT) {
    tonemapped = ABL_ApplyLimit(SceneColorTexture, tonemapped);
  }

  if (use_grain) {
    tonemapped = renodx::effects::ApplyFilmGrain(
        tonemapped,
        position,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.03f);
  }
  tonemapped *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  tonemapped = renodx::color::gamma::EncodeSafe(tonemapped);
  return tonemapped;
}
