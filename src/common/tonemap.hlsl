#include "./color.hlsl"

// https://www.glowybits.com/blog/2016/12/21/ifl_iss_hdr_1/
float3 RgbAcesHdrSrgb(float3 x) {
  x = (x * (x * (x * (x * 2708.7142 + 6801.1525) + 1079.5474) + 1.1614649) - 0.00004139375) / (x * (x * (x * (x * 983.38937 + 4132.0662) + 2881.6522) + 128.35911) + 1.0);
  return max(x, 0.0);
}

// Convert a linear RGB color to an sRGB-encoded color after applying approximate ACES SDR
//  tonemapping (with input scaled by 2.05). Input is assumed to be non-negative.

float3 RgbAcesSdrSrgb(float3 x) {
  return saturate(
    (x * (x * (x * (x * 8.4680 + 1.0) - 0.002957) + 0.0001004) - 0.0000001274) / (x * (x * (x * (x * 8.3604 + 1.8227) + 0.2189) - 0.002117) + 0.00003673)
  );
}

// https://www.slideshare.net/ozlael/hable-john-uncharted2-hdr-lighting
// http://filmicworlds.com/blog/filmic-tonemapping-operators/

const float uncharted2Tonemap_W = 11.2;  // Linear White

float3 uncharted2Tonemap(float x) {
  float A = 0.22;  // Shoulder Strength
  float B = 0.30;  // Linear Strength
  float C = 0.10;  // Linear Angle
  float D = 0.20;  // Toe Strength
  float E = 0.01;  // Toe Numerator
  float F = 0.30;  // Toe Denominator

  return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

float3 renodrt(
  float3 bt709,
  float peakNits = 1000.f / 203.f * 100.f,
  float sceneGray = 0.18f,
  float outputGrayNits = 10.f,
  float contrast = 1.1f,
  float shadow = 0.01f,
  float dechroma = 1.f,
  float saturation = 1.f,
  float highlightBoost = 1.f
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

  float g = 1.1;     // gamma/contrast
  float c = 0.18;    // scene-referred gray
  float c_d = 10;    // output gray in nits
  float w_g = 0.0;   // gray change
  float t_1 = 0.01;  // shadow toe
  float r_hit_min = 128;
  float r_hit_max = 256;

  g = contrast;
  c = sceneGray;
  c_d = outputGrayNits;
  n = peakNits;
  t_1 = shadow;

  float lum = yFromBT709(abs(bt709));

  float normalizedLum = lum / 0.18f;
  float boostedLum = pow(normalizedLum, highlightBoost);
  boostedLum = lerp(normalizedLum, boostedLum, saturate(normalizedLum));
  boostedLum *= 0.18f;
  bt709 *= (lum > 0 ? (boostedLum / lum) : 0);
  lum = boostedLum;

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

  float3 outputColor = bt709 * (lum > 0 ? (newY / lum) : 0);

  float3 originalLCh = okLChFromBT709(bt709);
  float3 newLCh = okLChFromBT709(outputColor);
  newLCh[1] = lerp(originalLCh[1], newLCh[1], saturate(pow(dechroma, 2.f)));
  newLCh[2] = originalLCh[2];  // hue correction

  newLCh[1] *= saturation;
  float3 color = bt709FromOKLCh(newLCh);
  color = mul(BT709_2_AP1_MAT, color);  // Convert to AP1
  color = max(0, color);                // Clamp to AP1
  color = mul(AP1_2_BT709_MAT, color);  // Convert BT709
  return color;
}
