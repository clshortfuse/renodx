#ifndef SRC_SHADERS_DANIELE_HLSL_
#define SRC_SHADERS_DANIELE_HLSL_

namespace renodx {
namespace tonemap {
namespace daniele {

struct Config {
  float n_r;        // reference nits
  float n;          // peak nits
  float g;          // surround/contrast
  float c;          // scene-referred gray
  float c_d;        // output gray in nits
  float w_g;        // gray change
  float t_1;        // shadow toe
  float r_hit_min;  // minimum hit nits
  float r_hit_max;  // maximum hit nits
};

namespace config {
Config Create(
    float n_r = 100.f,        // reference nits
    float n = 1000.f,         // peak nits
    float g = 1.1f,           // surround/contrast
    float c = 0.18f,          // scene-referred gray
    float c_d = 10.f,         // output gray in nits
    float w_g = 10.013f,      // gray change
    float t_1 = 0.01f,        // shadow toe
    float r_hit_min = 128.f,  // minimum hit nits
    float r_hit_max = 256.f   // maximum hit nits
) {
  Config config;
  config.n_r = n_r;
  config.n = n;
  config.g = g;
  config.c = c;
  config.c_d = c_d;
  config.w_g = w_g;
  config.t_1 = t_1;
  config.r_hit_min = r_hit_min;
  config.r_hit_max = r_hit_max;
  return config;
}
}

// https://www.desmos.com/calculator/d37z5t5lr5
float ToneMap(float x, Config tonemap_config) {
  float n_r = tonemap_config.n_r;
  float n = tonemap_config.n;
  float g = tonemap_config.g;
  float c = tonemap_config.c;
  float c_d = tonemap_config.c_d;
  float w_g = tonemap_config.w_g;
  float t_1 = tonemap_config.t_1;
  float r_hit_min = tonemap_config.r_hit_min;
  float r_hit_max = tonemap_config.r_hit_max;

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

  float ts = pow(max(0, x) / (x + s_2), g) * m_2;
  float flared = max(0, (ts * ts) / (ts + t_1));

  return flared;
}

float ToneMap(float x) {
  return ToneMap(x, config::Create());
}
}  // namespace daniele
}  // namespace tonemap
}  // namespace renodx

#endif