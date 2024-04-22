#ifndef SRC_COMMON_RENODRT_HLSL_
#define SRC_COMMON_RENODRT_HLSL_

#include "./color.hlsl"

float3 renodrt(
  float3 bt709,
  float peakNits = 1000.f / 203.f * 100.f,
  float sceneGray = 0.18f,
  float outputGrayNits = 10.f,
  float exposure = 1.f,
  float highlights = 1.f,
  float shadows = 1.f,  // 0 = 0.10, 1.f = 0, >1 = contrast
  float contrast = 1.1f,
  float saturation = 1.f,
  float dechroma = 0.5f,
  float flare = 0.f
) {
  float n_r = 100.f;
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

  float g = 1.1;       // gamma/contrast
  float c = 0.18;      // scene-referred gray
  float c_d = 10.013;  // output gray in nits
  float w_g = 0.00f;   // gray change
  float t_1 = 0.01;    // shadow toe
  float r_hit_min = 128;
  float r_hit_max = 256;

  g = contrast;
  c = sceneGray;
  c_d = outputGrayNits;
  n = peakNits;
  t_1 = flare;

  float originalY = yFromBT709(abs(bt709));
  float3 originalLCh = okLChFromBT709(bt709);

  float lum = originalY * exposure;

  float normalizedLum = lum / 0.18f;

  float highlightedLum = pow(normalizedLum, highlights);
  highlightedLum = lerp(normalizedLum, highlightedLum, saturate(normalizedLum));

  float shadowedLum = pow(highlightedLum, -1.f * (shadows - 2.f));
  shadowedLum = lerp(shadowedLum, highlightedLum, saturate(highlightedLum));
  shadowedLum *= 0.18f;
  lum = shadowedLum;

  float m_0 = (n / n_r);
  float m_1 = 0.5 * (m_0 + sqrt(m_0 * (m_0 + (4.0 * t_1))));
  float r_hit = r_hit_min + ((r_hit_max - r_hit_min) * (log(m_0) / log(10000.0 / 100.0)));

  float u = pow((r_hit / m_1) / ((r_hit / m_1) + 1.0), g);
  float m = m_1 / u;
  float w_i = log(n / 100.0) / log(2.0);
  float c_t = (c_d / n_r) * (1.0 + (w_i * w_g));
  float g_ip = 0.5 * (c_t + sqrt(c_t * (c_t + (4.0 * t_1))));
  float g_ipp2 = -m_1 * pow(g_ip / m, 1.0 / g) / (pow(g_ip / m, 1.0 / g) - 1.0);
  float w_2 = c / g_ipp2;
  float s_2 = w_2 * m_1;
  float u_2 = pow((r_hit / m_1) / ((r_hit / m_1) + w_2), g);
  float m_2 = m_1 / u_2;

  float ts = pow(max(0, lum) / (lum + s_2), g) * m_2;

  float flared = max(0, (ts * ts) / (ts + t_1));

  float newY = clamp(flared, 0, m_0);

  float3 outputColor = bt709 * (originalY > 0 ? (newY / originalY) : 0);

  float3 newLCh = okLChFromBT709(outputColor);
  newLCh[1] = lerp(newLCh[1], 0.f, saturate(pow(originalY / (10000.f / 100.f), (1.f - dechroma))));
  newLCh[1] *= saturation;
  newLCh[2] = originalLCh[2];  // hue correction

  float3 color = bt709FromOKLCh(newLCh);
  color = mul(BT709_2_AP1_MAT, color);  // Convert to AP1
  color = max(0, color);                // Clamp to AP1
  color = mul(AP1_2_BT709_MAT, color);  // Convert BT709
  color = min(m_0, color);              // Clamp to Peak
  return color;
}

#endif  // SRC_COMMON_RENODRT_HLSL_
