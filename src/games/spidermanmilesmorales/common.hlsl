#include "./include/ToneMapCB.hlsl"
#include "./shared.h"

float3 UpgradeToneMapPerceptual(float3 untonemapped, float3 tonemapped, float3 post_processed, float strength) {
  float3 lab_untonemapped = renodx::color::ictcp::from::BT709(untonemapped);
  float3 lab_tonemapped = renodx::color::ictcp::from::BT709(tonemapped);
  float3 lab_post_processed = renodx::color::ictcp::from::BT709(post_processed);

  float3 lch_untonemapped = renodx::color::oklch::from::OkLab(lab_untonemapped);
  float3 lch_tonemapped = renodx::color::oklch::from::OkLab(lab_tonemapped);
  float3 lch_post_processed = renodx::color::oklch::from::OkLab(lab_post_processed);

  float3 lch_upgraded = lch_untonemapped;
  lch_upgraded.xz *= renodx::math::DivideSafe(lch_post_processed.xz, lch_tonemapped.xz, 0.f);

  float3 lab_upgraded = renodx::color::oklab::from::OkLCh(lch_upgraded);

  float c_untonemapped = length(lab_untonemapped.yz);
  float c_tonemapped = length(lab_tonemapped.yz);
  float c_post_processed = length(lab_post_processed.yz);

  if (c_untonemapped > 0) {
    float new_chrominance = c_untonemapped;
    new_chrominance = min(max(c_untonemapped, 0.25f), c_untonemapped * (c_post_processed / c_tonemapped));
    if (new_chrominance > 0) {
      lab_upgraded.yz *= new_chrominance / c_untonemapped;
    }
  }

  float3 upgraded = renodx::color::bt709::from::ICtCp(lab_upgraded);
  return lerp(untonemapped, upgraded, strength);
}

float UpgradeToneMapRatio(float color_hdr, float color_sdr, float post_process_color) {
  [branch]
  if (color_hdr < color_sdr) {
    // If subtracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    return color_hdr / color_sdr;
  } else {
    float delta = color_hdr - color_sdr;
    delta = max(0, delta);  // Cleans up NaN
    const float ap1_new = post_process_color + delta;

    const bool ap1_valid = (post_process_color > 0);  // Cleans up NaN and ignore black
    return ap1_valid ? (ap1_new / post_process_color) : 0;
  }
}

float3 UpgradeToneMapPerChannel(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength, uint working_color_space = 2u, uint hue_processor = 2u) {
  // float ratio = 1.f;

  float3 working_hdr, working_sdr, working_post_process;

  [branch]
  if (working_color_space == 2u) {
    working_hdr = max(0, renodx::color::ap1::from::BT709(color_hdr));
    working_sdr = max(0, renodx::color::ap1::from::BT709(color_sdr));
    working_post_process = max(0, renodx::color::ap1::from::BT709(post_process_color));
  } else
    [branch] if (working_color_space == 1u) {
      working_hdr = max(0, renodx::color::bt2020::from::BT709(color_hdr));
      working_sdr = max(0, renodx::color::bt2020::from::BT709(color_sdr));
      working_post_process = max(0, renodx::color::bt2020::from::BT709(post_process_color));
    }
  else {
    working_hdr = max(0, color_hdr);
    working_sdr = max(0, color_sdr);
    working_post_process = max(0, post_process_color);
  }

  float3 ratio = float3(
      UpgradeToneMapRatio(working_hdr.r, working_sdr.r, working_post_process.r),
      UpgradeToneMapRatio(working_hdr.g, working_sdr.g, working_post_process.g),
      UpgradeToneMapRatio(working_hdr.b, working_sdr.b, working_post_process.b));

  float3 color_scaled = max(0, working_post_process * ratio);

  [branch]
  if (working_color_space == 2u) {
    color_scaled = renodx::color::bt709::from::AP1(color_scaled);
  } else
    [branch] if (working_color_space == 1u) {
      color_scaled = renodx::color::bt709::from::BT2020(color_scaled);
    }

  float peak_correction;
  [branch]
  if (working_color_space == 2u) {
    peak_correction = saturate(1.f - renodx::color::y::from::AP1(working_post_process));
  } else
    [branch] if (working_color_space == 1u) {
      peak_correction = saturate(1.f - renodx::color::y::from::BT2020(working_post_process));
    }
  else {
    peak_correction = saturate(1.f - renodx::color::y::from::BT709(working_post_process));
  }

  [branch]
  if (hue_processor == 2u) {
    color_scaled = renodx::color::correct::HuedtUCS(color_scaled, post_process_color, peak_correction);
  } else
    [branch] if (hue_processor == 1u) {
      color_scaled = renodx::color::correct::HueICtCp(color_scaled, post_process_color, peak_correction);
    }
  else {
    color_scaled = renodx::color::correct::HueOKLab(color_scaled, post_process_color, peak_correction);
  }
  return lerp(color_hdr, color_scaled, post_process_strength);
}

float3 UpgradeToneMap(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength, uint upgradeMethod) {
  if (upgradeMethod == 0u)
    return renodx::tonemap::UpgradeToneMap(color_hdr, color_sdr, post_process_color, post_process_strength);
  else if (upgradeMethod == 1u)
    return UpgradeToneMapPerChannel(color_hdr, color_sdr, post_process_color, post_process_strength);
  else
    return UpgradeToneMapPerceptual(color_hdr, color_sdr, post_process_color, post_process_strength);
}

float OverrideGamma() {
  [branch]
  if (RENODX_GAMMA_ADJUST_TYPE) {
    return RENODX_GAMMA_ADJUST_VALUE;
  } else {
    return ToneMapCBuffer_m0[3u].w * RENODX_GAMMA_ADJUST_VALUE;
  }
}

static float m_HdrGamma = OverrideGamma();
