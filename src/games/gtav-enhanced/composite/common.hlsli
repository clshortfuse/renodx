#include "../shared.h"

float3 ApplyPerChannelCorrectionICtCp(
    float3 untonemapped, float3 per_channel_color,
    float hue_correct_strength = 0.f,
    float chrominance_loss_restore_strength = 0.f,
    float chrominance_gain_reduce_strength = 0.f,
    float saturation = 1.f) {
  if (hue_correct_strength != 0.f
      || chrominance_loss_restore_strength != 0.f
      || chrominance_gain_reduce_strength != 0.f
      || saturation != 1.f) {
    float3 perceptual_new = renodx::color::ictcp::from::BT709(per_channel_color);
    const float3 untonemapped_ictcp = renodx::color::ictcp::from::BT709(untonemapped);

    float chrominance_current = length(perceptual_new.yz);

    if (hue_correct_strength != 0.f) {
      const float chrominance_pre = chrominance_current;
      perceptual_new.yz = lerp(perceptual_new.yz, untonemapped_ictcp.yz, hue_correct_strength);
      const float chrominance_post = length(perceptual_new.yz);
      perceptual_new.yz *= renodx::math::SafeDivision(chrominance_pre, chrominance_post, 1.f);
      chrominance_current = chrominance_pre;
    }

    const float untonemapped_chrominance = length(untonemapped_ictcp.yz);
    const float target_chrominance_ratio = renodx::math::SafeDivision(untonemapped_chrominance, chrominance_current, 1.f);
    const float chroma_gain_mask = step(untonemapped_chrominance, chrominance_current);  // 1 when current chroma is above reference
    const float chroma_loss_mask = 1.f - chroma_gain_mask;                               // 1 when current chroma is below reference
    const float chrominance_correct_strength = (chroma_gain_mask * chrominance_gain_reduce_strength)
                                               + (chroma_loss_mask * chrominance_loss_restore_strength);
    float chroma_scale = lerp(1.f, target_chrominance_ratio, chrominance_correct_strength);

    perceptual_new.yz *= chroma_scale;
    perceptual_new.yz *= saturation;

    per_channel_color = renodx::color::bt709::from::ICtCp(perceptual_new);
  }
  return per_channel_color;
}

renodx::canvas::Context CreateGTAVDebugOverlayContext(
    float3 color,
    float2 screen_position,
    float2 cursor_position,
    float2 glyph_size) {
  return renodx::canvas::CreateContext(
      screen_position + 0.5f,
      cursor_position,
      glyph_size,
      color,
      1.0f,
      1.0f.xxx,
      1.0f,
      1.0f,
      renodx::canvas::MODE_NORMAL,
      0.0f,
      1.18f);
}

void DrawGTAVDebugText(
    inout renodx::canvas::Context context,
    int a, int b = 0, int c = 0, int d = 0,
    int e = 0, int f = 0, int g = 0, int h = 0,
    int i = 0, int j = 0, int k = 0, int l = 0,
    int m = 0, int n = 0, int o = 0, int p = 0) {
  renodx::canvas::DrawDynamicText(context, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);
}

void DrawGTAVDebugFloatRow(
    inout renodx::canvas::Context context,
    float value,
    int a, int b = 0, int c = 0, int d = 0,
    int e = 0, int f = 0, int g = 0, int h = 0,
    int i = 0, int j = 0, int k = 0, int l = 0,
    int m = 0, int n = 0, int o = 0, int p = 0) {
  DrawGTAVDebugText(context, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);
  renodx::canvas::DrawText(context, ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, value, 0.0f, 5.0f);
  renodx::canvas::NewLine(context);
}

#define GTAV_HABLE_TONEMAP_GENERATOR(T)                                \
  T ApplyGTAVHableTonemap(                                             \
      T untonemapped,                                                  \
      float a,         /* shoulder_strength */                         \
      float b,         /* linear_strength */                           \
      float c_times_b, /* linear_angle_times_strength */               \
      float d_times_e, /* toe_strength_times_numerator */              \
      float d_times_f, /* toe_strength_times_denominator */            \
      float e_over_f,  /* toe_numerator_over_denominator */            \
      float white_scale) {                                             \
    T shoulder = untonemapped * a;                                     \
    T numerator = ((shoulder + c_times_b) * untonemapped) + d_times_e; \
    T denominator = ((shoulder + b) * untonemapped) + d_times_f;       \
    T curve = (numerator / denominator) - e_over_f;                    \
    return max((T)0.f, curve * white_scale);                           \
  }

GTAV_HABLE_TONEMAP_GENERATOR(float)
GTAV_HABLE_TONEMAP_GENERATOR(float3)
#undef GTAV_HABLE_TONEMAP_GENERATOR

float ApplyGTAVHableTonemapInverse(float tonemapped,
                                   float a,          // shoulder_strength
                                   float b,          // linear_strength
                                   float c_times_b,  // linear_angle_times_strength
                                   float d_times_e,  // toe_strength_times_numerator
                                   float d_times_f,  // toe_strength_times_denominator
                                   float e_over_f,   // toe_numerator_over_denominator
                                   float white_scale) {
  float target = renodx::math::SafeDivision(tonemapped, white_scale, 0.f) + e_over_f;

  float qa = a * (1.f - target);
  float qb = c_times_b - (target * b);
  float qc = d_times_e - (target * d_times_f);

  if (abs(qa) < 1e-6f) {
    return max(0.f, renodx::math::SafeDivision(-qc, qb, 0.f));
  }

  float discriminant = max(0.f, (qb * qb) - (4.f * qa * qc));
  float sqrt_discriminant = sqrt(discriminant);
  float inv_2qa = 0.5f / qa;
  float root_a = (-qb + sqrt_discriminant) * inv_2qa;
  float root_b = (-qb - sqrt_discriminant) * inv_2qa;

  bool root_a_valid = root_a > 0.f;
  bool root_b_valid = root_b > 0.f;
  if (root_a_valid && root_b_valid) return min(root_a, root_b);
  if (root_a_valid) return root_a;
  if (root_b_valid) return root_b;
  return 0.f;
}

float CalculateGTAVHableDerivative(float x,
                                   float a,          // shoulder_strength
                                   float b,          // linear_strength
                                   float c_times_b,  // linear_angle_times_strength
                                   float d_times_e,  // toe_strength_times_numerator
                                   float d_times_f,  // toe_strength_times_denominator
                                   float white_scale) {
  float denominator = (a * x * x) + (b * x) + d_times_f;
  float numerator = (a * (b - c_times_b) * x * x)
                    + (2.f * a * (d_times_f - d_times_e) * x)
                    + (c_times_b * d_times_f - b * d_times_e);
  return white_scale * numerator / (denominator * denominator);
}

float SignCbrt(float x) {
  return sign(x) * pow(abs(x), 1.f / 3.f);
}

float3 SolveGTAVHableCubic(float a3, float a2, float a1, float a0) {
  static const float PI = 3.14159265358979323846f;

  float inv_a = 1.f / a3;
  float b = a2 * inv_a;
  float c = a1 * inv_a;
  float d = a0 * inv_a;

  float shift = b / 3.f;
  float p = c - (b * b) / 3.f;
  float q = (2.f * b * b * b) / 27.f - (b * c) / 3.f + d;

  float half_q = 0.5f * q;
  float third_p = p / 3.f;
  float discriminant = half_q * half_q + third_p * third_p * third_p;

  if (discriminant > 0.f) {
    float s = sqrt(discriminant);
    float u = SignCbrt(-half_q + s);
    float v = SignCbrt(-half_q - s);
    return (u + v - shift).xxx;
  }

  float t = 2.f * sqrt(-third_p);
  float cos_arg = (-half_q) / sqrt(-(third_p * third_p * third_p));
  cos_arg = clamp(cos_arg, -1.f, 1.f);

  float phi = acos(cos_arg) / 3.f;
  return float3(
      t * cos(phi) - shift,
      t * cos(phi - 2.f * PI / 3.f) - shift,
      t * cos(phi - 4.f * PI / 3.f) - shift);
}

float FindGTAVHableInflection(float a,
                              float b,
                              float c_times_b,
                              float d_times_e,
                              float d_times_f) {
  float a3 = a * a * (b - c_times_b);
  float a2 = 3.f * a * a * (d_times_f - d_times_e);
  float a1 = 3.f * a * (c_times_b * d_times_f - b * d_times_e);
  float a0 = a * d_times_e * d_times_f - a * d_times_f * d_times_f - b * b * d_times_e + b * c_times_b * d_times_f;

  float3 roots = SolveGTAVHableCubic(a3, a2, a1, a0);
  return max(roots.x, max(roots.y, roots.z));
}

struct GTAVTonemapConfig {
  float a;          // shoulder_strength
  float b;          // linear_strength
  float c_times_b;  // linear_angle_times_strength
  float d_times_e;  // toe_strength_times_numerator
  float d_times_f;  // toe_strength_times_denominator
  float e_over_f;   // toe_numerator_over_denominator
  float white_scale;

  float saturation;
  float3 grade_a;
  float3 grade_b;
  float grade_luma_max;
  float blend_range;
};

float3 DrawGTAVHableParamsDebug(float3 color,
                                float2 screen_position,
                                GTAVTonemapConfig config,
                                float mid_gray_in,
                                float mid_gray_out,
                                float hable_slope) {
  const float2 panel_min = float2(32.0f, 32.0f);
  const float2 panel_max = float2(560.0f, 560.0f);

  renodx::canvas::Context context = CreateGTAVDebugOverlayContext(
      color,
      screen_position,
      panel_min + float2(24.0f, 24.0f),
      float2(18.0f, 28.0f));

  renodx::canvas::SetColor(context, 0x05080c, 0.88f, 1.0f);
  renodx::canvas::FillRect(context, panel_min, panel_max);

  renodx::canvas::SetColor(context, 0x38ff9c, 1.0f, 1.0f);
  DrawGTAVDebugText(context, 'G', 'T', 'A', 'V', ' ', 'H', 'a', 'b', 'l', 'e');
  renodx::canvas::NewLine(context);

  renodx::canvas::SetColor(context, 0xdde6f0, 1.0f, 1.0f);
  DrawGTAVDebugFloatRow(context, config.a, 'a');
  DrawGTAVDebugFloatRow(context, config.b, 'b');
  DrawGTAVDebugFloatRow(context, config.c_times_b, 'c', '_', 't', 'i', 'm', 'e', 's', '_', 'b');
  DrawGTAVDebugFloatRow(context, config.d_times_e, 'd', '_', 't', 'i', 'm', 'e', 's', '_', 'e');
  DrawGTAVDebugFloatRow(context, config.d_times_f, 'd', '_', 't', 'i', 'm', 'e', 's', '_', 'f');
  DrawGTAVDebugFloatRow(context, config.e_over_f, 'e', '_', 'o', 'v', 'e', 'r', '_', 'f');
  DrawGTAVDebugFloatRow(context, config.white_scale, 'w', 'h', 'i', 't', 'e', '_', 's', 'c', 'a', 'l', 'e');
  DrawGTAVDebugFloatRow(context, mid_gray_in, 'm', 'i', 'd', '_', 'g', 'r', 'a', 'y', '_', 'i', 'n');
  DrawGTAVDebugFloatRow(context, mid_gray_out, 'm', 'i', 'd', '_', 'g', 'r', 'a', 'y', '_', 'o', 'u', 't');
  DrawGTAVDebugFloatRow(context, hable_slope, 'h', 'a', 'b', 'l', 'e', '_', 's', 'l', 'o', 'p', 'e');

  return renodx::canvas::GetOutput(context).rgb;
}

float3 ApplyPostToneMapGrading(float3 vanilla_color, GTAVTonemapConfig config) {
  float vanilla_luma = dot(vanilla_color, float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float3 post_grade_b = vanilla_luma + (config.saturation * (vanilla_color - vanilla_luma));
  float grade_blend = saturate(vanilla_luma / config.grade_luma_max);
  float3 post_grade_a = lerp(config.grade_a, config.grade_b, grade_blend) * post_grade_b;
  float post_grade_blend = saturate(((vanilla_luma - 1.0f) + config.blend_range) / max(0.009999999776482582f, config.blend_range));
  float3 post_process_color = lerp(post_grade_a, post_grade_b, post_grade_blend);
  return renodx::color::bt709::clamp::AP1(post_process_color);
}

float ContrastAndFlare(float x, float contrast, float flare, float mid_gray = 0.18f) {
  if (contrast == 1.f && flare == 0.f) return x;
  float x_normalized = x / mid_gray;
  float flare_ratio = renodx::math::DivideSafe(x_normalized + flare, x_normalized, 1.f);
  return pow(x_normalized, contrast * flare_ratio) * mid_gray;
}

float3 ApplyAnchoredAdaptationContrast(float3 color, float contrast,
                                       float3 anchor_in = 0.18f, float3 anchor_out = 0.18f,
                                       float flare = 0.f) {
  float3 ax = abs(color);
  float3 normalized = ax / anchor_in;
  float3 flare_ratio = renodx::math::DivideSafe(normalized + flare, normalized, 1.f);
  float3 exponent = contrast * flare_ratio;

  float3 ax_n = pow(ax, exponent);
  float3 s_n = pow(anchor_in, exponent);
  float3 response_target = ax_n / (ax_n + s_n);
  float3 response_baseline = ax / (ax + anchor_in);
  float3 gain = renodx::math::DivideSafe(response_target, response_baseline, 0.f);

  float3 contrasted = renodx::math::CopySign(ax * gain, color);
  return contrasted * (anchor_out / anchor_in);
}

float4 GenerateGTAVOutput(float3 input_color, float2 position, float2 screen_position, GTAVTonemapConfig config) {
  float3 untonemapped = input_color;

  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 6.f) {
    // abs() needed for transitions
    config.a = abs(config.a);
    config.b = abs(config.b);
    config.c_times_b = abs(config.c_times_b);
    config.d_times_e = abs(config.d_times_e);
    config.d_times_f = abs(config.d_times_f);
    config.e_over_f = abs(config.e_over_f);

#if 1  // inflection
    const float mid_gray_in = FindGTAVHableInflection(config.a,
                                                      config.b,
                                                      config.c_times_b,
                                                      config.d_times_e,
                                                      config.d_times_f);
    const float mid_gray_out = ApplyGTAVHableTonemap(mid_gray_in,
                                                     config.a,
                                                     config.b,
                                                     config.c_times_b,
                                                     config.d_times_e,
                                                     config.d_times_f,
                                                     config.e_over_f,
                                                     config.white_scale);
#else  // 0.18 out
    const float mid_gray_out = 0.18f;
    const float mid_gray_in = ApplyGTAVHableTonemapInverse(mid_gray_out,
                                                           config.a,
                                                           config.b,
                                                           config.c_times_b,
                                                           config.d_times_e,
                                                           config.d_times_f,
                                                           config.e_over_f,
                                                           config.white_scale);
#endif

    const float hable_slope = CalculateGTAVHableDerivative(mid_gray_in,
                                                           config.a,
                                                           config.b,
                                                           config.c_times_b,
                                                           config.d_times_e,
                                                           config.d_times_f,
                                                           config.white_scale);

    float peak_value = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION == 1.f) peak_value = renodx::color::correct::GammaSafe(peak_value, true, 2.2f);
    if (RENODX_GAMMA_CORRECTION == 2.f) peak_value = renodx::color::correct::GammaSafe(peak_value, true, 2.4f);

    tonemapped = renodx::tonemap::psychov::psychotm_test17(
        untonemapped, peak_value,
        RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS, RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION, 1.f, RENODX_RENO_DRT_WHITE_CLIP, 1.f, 1.f, 0,
        hable_slope * mid_gray_in / mid_gray_out, mid_gray_in, mid_gray_out);

    float maxch_scale = renodx::tonemap::neutwo::ComputeBT709Scale(tonemapped, 1.f, peak_value);
    float3 post_process_color = ApplyPostToneMapGrading(tonemapped * maxch_scale, config) / maxch_scale;

    tonemapped = post_process_color;

    // tonemapped = DrawGTAVHableParamsDebug(tonemapped, screen_position, config, mid_gray_in, mid_gray_out, hable_slope);

  } else {
    const float mid_gray_in = FindGTAVHableInflection(config.a,
                                                      config.b,
                                                      config.c_times_b,
                                                      config.d_times_e,
                                                      config.d_times_f);
    const float mid_gray_out = ApplyGTAVHableTonemap(mid_gray_in,
                                                     config.a,
                                                     config.b,
                                                     config.c_times_b,
                                                     config.d_times_e,
                                                     config.d_times_f,
                                                     config.e_over_f,
                                                     config.white_scale);

    float3 vanilla_color = ApplyGTAVHableTonemap(untonemapped,
                                                 config.a,
                                                 config.b,
                                                 config.c_times_b,
                                                 config.d_times_e,
                                                 config.d_times_f,
                                                 config.e_over_f,
                                                 config.white_scale);

    untonemapped = untonemapped * mid_gray_out / mid_gray_in;

    if (RENODX_TONE_MAP_TYPE != 0.f
        && (CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION != 0.f
            || CUSTOM_COLOR_GRADE_HUE_CORRECTION != 0.f
            || CUSTOM_COLOR_GRADE_SATURATION_CORRECTION != 0.f)) {
      vanilla_color = ApplyPerChannelCorrectionICtCp(untonemapped,
                                                     vanilla_color,
                                                     CUSTOM_COLOR_GRADE_HUE_CORRECTION,
                                                     CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION,
                                                     CUSTOM_COLOR_GRADE_SATURATION_CORRECTION);
    }

    float3 post_process_color = ApplyPostToneMapGrading(vanilla_color, config);

    tonemapped = renodx::draw::ToneMapPass(untonemapped, post_process_color);
  }

  if (CUSTOM_FILM_GRAIN != 0.f) {
    tonemapped = renodx::effects::ApplyFilmGrain(tonemapped, position, CUSTOM_RANDOM, CUSTOM_FILM_GRAIN * 0.03f, 1.f);
  }

  float tonemap_luminance = max(0, renodx::color::y::from::BT709(tonemapped));
  float3 output = renodx::draw::RenderIntermediatePass(tonemapped);
  return float4(output, tonemap_luminance);
}

void ConfigureVanillaDithering(in float vanilla_red, in float vanilla_green,
                               in float vanilla_blue, inout float dithered_red,
                               inout float dithered_green,
                               inout float dithered_blue) {
  dithered_red = lerp(vanilla_red, dithered_red, CUSTOM_DITHERING);
  dithered_green = lerp(vanilla_green, dithered_green, CUSTOM_DITHERING);
  dithered_blue = lerp(vanilla_blue, dithered_blue, CUSTOM_DITHERING);
}

void ConfigureVanillaGrain(inout float grain_add, inout float grain_multiply) {
  grain_add *= CUSTOM_FILM_GRAIN;
  grain_multiply = lerp(1.f, grain_multiply, CUSTOM_FILM_GRAIN);
}
