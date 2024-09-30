#ifndef SRC_SHADERS_RENODRT_HLSL_
#define SRC_SHADERS_RENODRT_HLSL_

#include "./color.hlsl"
#include "./math.hlsl"

namespace renodx {
namespace tonemap {
namespace renodrt {
float3 BT709(
    float3 bt709,
    float nits_peak,
    float mid_gray_value,
    float mid_gray_nits,
    float exposure,
    float highlights,
    float shadows,  // 0 = 0.10, 1.f = 0, >1 = contrast
    float contrast,
    float saturation,
    float dechroma,
    float flare,
    float hue_correction_strength,
    float3 hue_correction_source) {
  const float n_r = 100.f;
  float n = 1000.f;

  // drt cam
  // n_r = 100
  // g = 1.15
  // c = 0.18
  // c_d = 10.013
  // w_g = 0.14
  // t_1 = 0.04
  // r_hit_min = 128
  // r_hit_max = 896

  float g = 1.1;            // gamma/contrast
  float c = 0.18;           // scene-referred gray
  float c_d = 10.013;       // output gray in nits
  const float w_g = 0.00f;  // gray change
  float t_1 = 0.01;         // shadow toe
  const float r_hit_min = 128;
  const float r_hit_max = 256;

  g = contrast;
  c = mid_gray_value;
  c_d = mid_gray_nits;
  n = nits_peak;
  t_1 = flare;

  float3 signs = renodx::math::Sign(bt709);

  bt709 = abs(bt709);

  float y_original = renodx::color::y::from::BT709(bt709);

  float3 restore_lab = (hue_correction_strength == 0)
                           ? 0
                           : renodx::color::oklab::from::BT709(hue_correction_source);
  float3 restore_lch = (hue_correction_strength == 0)
                           ? 0
                           : renodx::color::oklch::from::OkLab(restore_lab);

  float y = y_original * exposure;

  float y_normalized = y / 0.18f;

  float y_highlighted = pow(y_normalized, highlights);
  y_highlighted = lerp(y_normalized, y_highlighted, saturate(y_normalized));

  float y_shadowed = pow(y_highlighted, -1.f * (shadows - 2.f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted));
  y_shadowed *= 0.18f;
  y = y_shadowed;

  float m_0 = (n / n_r);
  float m_1 = 0.5 * (m_0 + sqrt(m_0 * (m_0 + (4.0 * t_1))));
  float r_hit = r_hit_min + ((r_hit_max - r_hit_min) * (log(m_0) / log(10000.0 / 100.0)));

  float u = pow((r_hit / m_1) / ((r_hit / m_1) + 1.0), g);
  const float m = m_1 / u;
  const float w_i = log(n / 100.0) / log(2.0);
  const float c_t = (c_d / n_r) * (1.0 + (w_i * w_g));
  const float g_ip = 0.5 * (c_t + sqrt(c_t * (c_t + (4.0 * t_1))));
  const float g_ipp2 = -m_1 * pow(g_ip / m, 1.0 / g) / (pow(g_ip / m, 1.0 / g) - 1.0);
  const float w_2 = c / g_ipp2;
  const float s_2 = w_2 * m_1;
  float u_2 = pow((r_hit / m_1) / ((r_hit / m_1) + w_2), g);
  float m_2 = m_1 / u_2;

  float ts = pow(max(0, y) / (y + s_2), g) * m_2;

  float flared = max(0, (ts * ts) / (ts + t_1));

  float y_new = clamp(flared, 0, m_0);

  float3 color_output = signs * bt709 * (y_original > 0 ? (y_new / y_original) : 0);
  float3 color = color_output;

  if (dechroma != 0.f || saturation != 1.f || hue_correction_strength != 0.f) {
    float3 lab_new = renodx::color::oklab::from::BT709(color_output);
    float3 lch_new = renodx::color::oklch::from::OkLab(lab_new);

    if (hue_correction_strength != 0.f) {
      if (hue_correction_strength == 1.f) {
        lch_new[2] = restore_lch[2];  // Full hue override
      } else {
        float old_chroma = lch_new[1];  // Store old chroma
        lab_new.yz = lerp(lab_new.yz, restore_lab.yz, hue_correction_strength);
        lch_new = renodx::color::oklch::from::OkLab(lab_new);
        lch_new[1] = old_chroma;  // chroma restore
      }
    }

    if (dechroma != 0.f) {
      lch_new[1] = lerp(lch_new[1], 0.f, saturate(pow(y_original / (10000.f / 100.f), (1.f - dechroma))));
    }
    if (saturation != 1.f) {
      lch_new[1] *= saturation;
    }

    color = renodx::color::bt709::from::OkLCh(lch_new);

    color = renodx::color::bt709::clamp::AP1(color);
    color = min(m_0, color);  // Clamp to Peak
  }
  return color;
}
float3 BT709(
    float3 bt709,
    float nits_peak = 1000.f / 203.f * 100.f,
    float mid_gray_value = 0.18f,
    float mid_gray_nits = 10.f,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.1f,
    float saturation = 1.f,
    float dechroma = 0.5f,
    float flare = 0.f,
    float hue_correction_strength = 1.f) {
  return BT709(
      bt709,
      nits_peak,
      mid_gray_value,
      mid_gray_nits,
      exposure,
      highlights,
      shadows,
      contrast,
      saturation,
      dechroma,
      flare,
      hue_correction_strength,
      bt709);
}
}  // namespace renodrt
}  // namespace tonemap
}  // namespace renodx

#endif  // SRC_SHADERS_RENODRT_HLSL_
