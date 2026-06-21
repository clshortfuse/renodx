#include "./shared.h"

float3 ApplyCustomGrade1(float3 color) {
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    if (RENODX_TONE_MAP_EXPOSURE != 1.f || RENODX_TONE_MAP_HIGHLIGHTS != 1.f || RENODX_TONE_MAP_SHADOWS != 1.f || RENODX_TONE_MAP_CONTRAST != 1.f || RENODX_TONE_MAP_FLARE != 0.f) {
      float color_y = renodx::color::y::from::BT709(color);
      float mid_gray = 0.18f;

      color *= RENODX_TONE_MAP_EXPOSURE;

      const float color_y_normalized = color_y / mid_gray;

      float flare = renodx::math::DivideSafe(color_y_normalized + RENODX_TONE_MAP_FLARE, color_y_normalized, 1.f);

      float exponent = RENODX_TONE_MAP_CONTRAST * flare;

      const float color_y_contrast = pow(color_y_normalized, exponent) * mid_gray;

      float y_highlights = renodx::color::grade::Highlights(color_y_contrast, RENODX_TONE_MAP_HIGHLIGHTS, mid_gray);

      float y_shadows = renodx::color::grade::Shadows(y_highlights, RENODX_TONE_MAP_SHADOWS, mid_gray);
      y_shadows = max(0, y_shadows);

      const float y_final = y_shadows;

      color = renodx::color::correct::Luminance(color, color_y, y_final);
    }
  }
  return color;
}

float3 ApplyCustomGrade2(float3 color) {
  if (RENODX_TONE_MAP_SATURATION != 1.f || RENODX_TONE_MAP_HIGHLIGHT_SATURATION != 1.f || RENODX_TONE_MAP_BLOWOUT != 0.f) {
    float3 color_perceptual = renodx::color::oklab::from::BT709(color);
    float y = renodx::color::y::from::BT709(color);
    float highlight_saturation = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

    if (RENODX_TONE_MAP_BLOWOUT != 0.f) {
      color_perceptual.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - RENODX_TONE_MAP_BLOWOUT))));
    }

    if (highlight_saturation != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(highlight_saturation));
      if (highlight_saturation < 0) {
        blowout_change = (2.f - blowout_change);
      }

      color_perceptual.yz *= blowout_change;
    }

    color_perceptual.yz *= RENODX_TONE_MAP_SATURATION;

    color = renodx::color::bt709::from::OkLab(color_perceptual);
    color = renodx::color::bt709::clamp::AP1(color);
  }

  return color;
}

float3 PerChannelCorrection(float3 incorrect_color, float3 reference_color) {
  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 reference_lab = renodx::color::oklab::from::BT709(reference_color);

  float incorrect_chroma = length(incorrect_lab.yz);
  float reference_chroma = length(reference_lab.yz);

  float chroma_ratio = renodx::math::DivideSafe(reference_chroma, incorrect_chroma, 1.f);
  float hue_ratio = 1.f - saturate(chroma_ratio * chroma_ratio);

  float2 blended_lab = lerp(incorrect_lab.yz, reference_lab.yz, hue_ratio);

  float blended_chroma = length(blended_lab);

  blended_lab *= renodx::math::DivideSafe(incorrect_chroma, blended_chroma, 1.f);

  incorrect_lab.yz = blended_lab;

  incorrect_chroma = length(incorrect_lab.yz);

  chroma_ratio = renodx::math::DivideSafe(reference_chroma, incorrect_chroma, 1.f);

  float scale = chroma_ratio;
  float clamp_scale = saturate(sqrt(chroma_ratio));

  float t = 1.0f - step(1.0f, scale);
  scale = lerp(scale, 1.0f, t * clamp_scale);

  blended_lab = incorrect_lab.yz * scale;

  incorrect_lab.yz = blended_lab;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

float3 HDRTonemap(float3 untonemapped, float3 tonemapped) {
  float3 tonemapped_lum = renodx::color::correct::Luminance(untonemapped, tonemapped);

  float3 hdr_tonemapped = lerp(tonemapped_lum, tonemapped, saturate(renodx::color::y::from::BT709(tonemapped_lum) / 0.18f));
  if (CUSTOM_SATURATION_CORRECTION != 1.f) {
    hdr_tonemapped = renodx::color::correct::ChrominanceOKLab(hdr_tonemapped, tonemapped, 1.f - CUSTOM_SATURATION_CORRECTION, 1.f);
  }

  float3 sdr_color = renodx::tonemap::neutwo::PerChannel(hdr_tonemapped);
  hdr_tonemapped = PerChannelCorrection(hdr_tonemapped, sdr_color);

  float3 output_color;
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    output_color = hdr_tonemapped;
  } else {
    output_color = saturate(tonemapped);
  }
  return output_color;
}

float3 TonemappedGraded(float3 graded, float scale, float gamut_compress_scale) {
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    graded = renodx::color::correct::GamutDecompress(graded, gamut_compress_scale);
    graded /= scale;
  }
  
  return graded;
}

float3 Tonemap(float3 color) {
  float3 output_color;
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    color = ApplyCustomGrade2(color);
    output_color = renodx::tonemap::neutwo::MaxChannel(color, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, 100.f);
  } else {
    output_color = saturate(color);
  }
  return renodx::draw::RenderIntermediatePass(output_color);
}

float3 FinalOutput(float3 final_image) {
  final_image = renodx::draw::SwapChainPass(final_image);

  return final_image;
}