#include "./shared.h"
#include "./hejldawson_extended.hlsli"

float3 ColourCorrect(float3 colour, float3 reference) {
  float3 corrected = renodx::color::correct::ChrominanceOKLab(colour, reference, RENODX_COLOR_GRADE_STRENGTH * 0.7f);
  return renodx::color::correct::HueOKLab(corrected, reference, RENODX_COLOR_GRADE_STRENGTH);
}

float3 ApplyColorGrade(float3 color)
{
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  return renodx::color::grade::config::ApplyUserColorGrading(color, config);
}

float3 DisplayMap(float3 color, bool ui = false)
{
  return renodx::tonemap::neutwo::PerChannel(color, getPeak());
}

float getPeak() {
  float ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  [branch]
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    ratio = renodx::color::correct::Gamma(
        ratio,
        true,
      renodx::math::Select(RENODX_GAMMA_CORRECTION == 1.f, 2.2f, 2.4f));
  }
  return ratio;
}

float HejlDawsonCustomInputForOutput(float output_value) {
  const float curve = pow(max(0.f, output_value), 1.f / 2.2f);
  const float a = 6.2f * (curve - 1.f);
  const float b = fma(1.7f, curve, -0.5f);
  const float c = curve * 0.06f;

  if (abs(a) < renodx::math::FLT_EPSILON) {
    const float linear_color = renodx::math::DivideSafe(-c, b, 0.f);
    return linear_color > 0.f ? linear_color : 0.18f;
  }

  const float discriminant = fma(-4.f * a, c, b * b);
  if (discriminant < 0.f) return 0.18f;

  const float sqrt_discriminant = sqrt(discriminant);
  const float denominator = 2.f * a;
  const float root_0 = (-b - sqrt_discriminant) / denominator;
  const float root_1 = (-b + sqrt_discriminant) / denominator;
  float color = root_0 > 0.f ? root_0 : root_1;
  color = root_1 > 0.f && (color <= 0.f || root_1 < color) ? root_1 : color;
  return color > 0.f ? color : 0.18f;
}