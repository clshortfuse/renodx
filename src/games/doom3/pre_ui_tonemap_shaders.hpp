#pragma once

// GLSL for the Doom 3 pre-UI tone map (see ToneMapScene in opengl_framebuffer.hpp).
// It runs on the finished 3D scene right before Doom 3 draws its GUI and mirrors
// the display shader's tone mappers:
//   - RenoDRT: renodx::draw::ToneMapPass with the visible settings (luminance or
//     per-channel scaling and the grading sliders). Hidden hue correction and
//     clamp options stay at their neutral defaults.
//   - PsychoV30: renodx::tonemap::psychov::psychotm_test30 exactly as
//     ApplyPsychoV30 calls it, plus its OKLab saturation slider.
// Derived color matrices are precomputed from src/shaders/color/rgb.hlsl. HLSL
// row-major matrices are written row by row and applied as `v * M`.
// The fragment source is split into pieces for glShaderSource (MSVC caps a single
// string literal at 16 KB).

namespace doom3::opengl {

inline constexpr const char* TONE_MAP_VERTEX_SHADER = R"(#version 130
void main() { gl_Position = gl_Vertex; }
)";

inline constexpr const char* TONE_MAP_FRAGMENT_SHADER[] = {
    R"(#version 130
uniform sampler2D scene;
uniform vec4 tone;    // peak / game white, exposure, highlights, shadows
uniform vec4 grade;   // contrast, flare (RenoDRT), saturation, highlight blowout (RenoDRT)
uniform vec4 extra;   // dechroma (RenoDRT Blowout), per channel (RenoDRT), game white / UI white
uniform vec4 psycho;  // PsychoV30 compression, gamut compression, cone response, purity scale
uniform vec4 modes;   // tone mapper (0 RenoDRT, 1 PsychoV30), PsychoV30 gamut mode, source boundary

const float MID_GRAY = 0.18;
const vec3 BT709_Y = vec3(0.2126390059, 0.7151686788, 0.0721923154);
const mat3 BT709_TO_LMS = mat3(0.4122214708, 0.5363325363, 0.0514459929,
                               0.2119034982, 0.6806995451, 0.1073969566,
                               0.0883024619, 0.2817188376, 0.6299787005);
const mat3 LMS_TO_OKLAB = mat3(0.2104542553, 0.7936177850, -0.0040720468,
                               1.9779984951, -2.4285922050, 0.4505937099,
                               0.0259040371, 0.7827717662, -0.8086757660);
const mat3 OKLAB_TO_LMS = mat3(1.0, 0.3963377774, 0.2158037573,
                               1.0, -0.1055613458, -0.0638541728,
                               1.0, -0.0894841775, -1.2914855480);
const mat3 LMS_TO_BT709 = mat3(4.0767416621, -3.3077115913, 0.2309699292,
                               -1.2684380046, 2.6097574011, -0.3413193965,
                               -0.0041960863, -0.7034186147, 1.7076147010);

float Sanitize(float x) { return (isnan(x) || isinf(x)) ? 0.0 : clamp(x, 0.0, 65504.0); }
vec3 Sanitize(vec3 c) { return vec3(Sanitize(c.r), Sanitize(c.g), Sanitize(c.b)); }
float DivideSafe(float a, float b, float fallback) { return b == 0.0 ? fallback : a / b; }
float Smootherstep(float t) { return t * t * t * (t * (t * 6.0 - 15.0) + 10.0); }
float Contrast(float x, float contrast) { return pow(x / MID_GRAY, contrast) * MID_GRAY; }
float CopySign(float m, float s) { return s < 0.0 ? -abs(m) : abs(m); }
vec3 CopySign(vec3 m, vec3 s) { return vec3(CopySign(m.x, s.x), CopySign(m.y, s.y), CopySign(m.z, s.z)); }
float Max3(vec3 v) { return max(v.x, max(v.y, v.z)); }
float Min3(vec3 v) { return min(v.x, min(v.y, v.z)); }
vec3 OkLabFromBT709(vec3 rgb) {
  vec3 lms = rgb * BT709_TO_LMS;
  return (sign(lms) * pow(abs(lms), vec3(1.0 / 3.0))) * LMS_TO_OKLAB;
}
vec3 BT709FromOkLab(vec3 lab) {
  vec3 lms = lab * OKLAB_TO_LMS;
  return (lms * lms * lms) * LMS_TO_BT709;
}

// renodx::color::grade::Highlights and Shadows, version 4.
float Highlights(float x, float highlights) {
  float t = x > MID_GRAY ? clamp(log2(x / MID_GRAY) / log2(1.0 / MID_GRAY), 0.0, 1.0) : 0.0;
  t = Smootherstep(t);
  if (highlights > 1.0) return mix(x, MID_GRAY * pow(x / MID_GRAY, highlights), t);
  return DivideSafe(x * x, mix(x, MID_GRAY * pow(x / MID_GRAY, 2.0 - highlights), t), x);
}

float Shadows(float x, float shadows) {
  float ratio = max(DivideSafe(x, MID_GRAY, 0.0), 0.0);
  float base_term = x * MID_GRAY;
  float shadow_floor = MID_GRAY / 16.0;
  float t = x > shadow_floor ? clamp(log2(x / MID_GRAY) / log2(shadow_floor / MID_GRAY), 0.0, 1.0) : 1.0;
  t = Smootherstep(t);
  float direction = shadows > 1.0 ? 1.0 : -1.0;
  float power = shadows > 1.0 ? shadows : 2.0 - shadows;
  float adjusted = x * (1.0 + direction * DivideSafe(base_term, pow(ratio, power), 0.0));
  float reference = x * (1.0 + direction * DivideSafe(base_term, ratio, 0.0));
  return x + (adjusted - reference) * t;
}

// renodx::tonemap::ReinhardScalableExtended with x_min = 0 and mid gray kept at 0.18.
vec3 ReinhardScalable(vec3 x, float white_max, float peak) {
  float cc = white_max * white_max;
  float k = cc * MID_GRAY - MID_GRAY * MID_GRAY * peak;
  float q_minus_z = peak - MID_GRAY;
  vec3 xk = x * k;
  return peak * (xk + MID_GRAY * x * x * q_minus_z) / (xk + cc * MID_GRAY * q_minus_z);
}

vec3 RenoDRT(vec3 color) {
  float peak = tone.x;
  float y_original = dot(color, BT709_Y);
  float y = y_original * tone.y;
  float white_clip = 100.0;
  if (tone.z != 1.0) {
    y = Highlights(y, tone.z);
    white_clip = Highlights(white_clip, tone.z);
  }
  if (tone.w != 1.0) {
    y = Shadows(y, tone.w);
    white_clip = Shadows(white_clip, tone.w);
  }
  vec3 per_channel = color * (y_original > 0.0 ? y / y_original : 0.0);

  bool contrasted = grade.x != 1.0 || grade.y != 0.0;
  float computed_contrast = 1.0;
  if (contrasted) {
    float ratio = y / MID_GRAY;
    float flare = mix(DivideSafe(ratio + grade.y, ratio, 1.0), 1.0, clamp(ratio, 0.0, 1.0));
    computed_contrast = grade.x * flare;
    white_clip = Contrast(white_clip, grade.x);
  }
  float white_max = max(white_clip, peak);

  if (extra.y == 1.0) {
    vec3 signs = sign(per_channel);
    per_channel = abs(per_channel);
    if (contrasted) per_channel = pow(per_channel / MID_GRAY, vec3(computed_contrast)) * MID_GRAY;
    color = min(ReinhardScalable(per_channel, white_max, peak), vec3(peak)) * signs;
  } else {
    if (contrasted) y = Contrast(y, computed_contrast);
    float y_new = min(ReinhardScalable(vec3(y), white_max, peak).x, white_max);
    color *= y_original > 0.0 ? y_new / y_original : 1.0;
  }

  if (extra.x != 0.0 || grade.z != 1.0 || grade.w != 0.0) {
    vec3 lab = OkLabFromBT709(color);
    if (extra.x != 0.0) lab.yz *= 1.0 - clamp(pow(max(y_original / 100.0, 1e-7), 1.0 - extra.x), 0.0, 1.0);
    if (grade.w != 0.0) {
      float change = pow(1.0 - clamp(y_original / 100.0, 0.0, 1.0), 100.0 * abs(grade.w));
      lab.yz *= grade.w < 0.0 ? 2.0 - change : change;
    }
    lab.yz *= grade.z;
    color = BT709FromOkLab(lab);
  }
  return color;
}
)",
    R"(
// ---------------------------------------------------------------------------
// PsychoV30 (src/shaders/tonemap/psychov/test30.hlsl)
// ---------------------------------------------------------------------------
const float P30_EPSILON = 1e-6;
const float P30_EPSILON2 = 1e-12;
const float P30_LARGE_SUPPORT = 1e20;
const mat3 P30_BT709_TO_LMS = mat3(
    0.289605781, 0.69724663, 0.0763712847,
    0.090183753, 0.707349008, 0.112203145,
    0.0155287402, 0.0536093118, 0.509797841);
const mat3 P30_LMS_TO_BT709 = mat3(
    4.96761934, -4.9223793, 0.339199099,
    -0.619682846, 2.05175061, -0.358743957,
    -0.0861520007, -0.0658193844, 1.98895448);
const mat3 P30_LMS_TO_BT2020 = mat3(
    2.90892126, -2.41556417, 0.180834251,
    -0.227553233, 1.54579657, -0.283842679,
    -0.0502712299, 0.0409489497, 1.7552839);
const mat3 P30_BT2020_TO_LMS = mat3(
    0.392659192, 0.612045046, 0.058519464,
    0.0596120639, 0.737074685, 0.113049159,
    0.0098550494, 0.000333748584, 0.568747118);
const mat3 P30_AP1_TO_LMS = mat3(
    0.4011386, 0.605498127, 0.0565869351,
    0.0589378931, 0.736400802, 0.114397191,
    0.00725747769, -0.0142459994, 0.585924473);
const mat3 P30_BT709_TO_BT2020 = mat3(
    0.627403901, 0.329283032, 0.0433130691,
    0.0690972852, 0.919540336, 0.0113623187,
    0.0163914388, 0.0880133151, 0.895595265);
const mat3 P30_BT709_TO_AP1 = mat3(
    0.613097429, 0.339523137, 0.0473794527,
    0.0701937228, 0.916353881, 0.0134523986,
    0.0206155926, 0.109569773, 0.869814634);
const mat3 P30_AP1_TO_BT709 = mat3(
    1.70505095, -0.621792138, -0.0832588747,
    -0.130256414, 1.14080477, -0.0105483187,
    -0.0240033567, -0.128968969, 1.15297234);
const vec3 P30_YF = vec3(0.689902723, 0.348321885, 0.0);  // Stockman-Sharpe LMS -> Yf row
const vec3 P30_MB_WEIGHTS = vec3(0.689902723, 0.348321885, 0.0371597074);
const vec2 P30_NEUTRAL_MB = vec2(0.689902723, 0.0371597074) / (0.689902723 + 0.348321885);
const vec3 P30_BT709_YF_WEIGHTS = vec3(0.220118417, 0.692513527, 0.0873680565);
const vec3 P30_BT2020_YF_WEIGHTS = vec3(0.277665954, 0.6464105, 0.0759235463);
const vec3 P30_AP1_YF_WEIGHTS = vec3(0.283011668, 0.641887047, 0.0751012845);
const vec3 P30_D65_WHITE_LMS = vec3(1.0632237, 0.909735905, 0.578935893);
const vec3 P30_BT709_D_RGB = vec3(4.68155381, -1.46103043, -0.2141844);
const vec3 P30_BT709_T_RGB = vec3(0.0981872668, -0.103844877, 0.575738569);
const vec3 P30_BT2020_D_RGB = vec3(2.44685564, -1.0224274, -0.243675248);
const vec3 P30_BT2020_T_RGB = vec3(0.0523457194, -0.0821633574, 0.508098426);
const float P30_D65_WHITE_YF = 1.05040185;
const float P30_ALPHA_L = 0.698324098;
const float P30_ALPHA_M = 0.301675902;
const float P30_ALPHA_DELTA = 0.396648196;

float P30Yf(vec3 lms) { return dot(P30_YF, lms); }
float P30Radius6(vec2 dt) { return 3.0 * dt.x * dt.x + dt.y * dt.y; }
float P30Cost(vec2 delta, float radial_metric) { return 2.0 * delta.x * delta.x + radial_metric * delta.y * delta.y; }
vec2 P30ScaledA2FromQ(vec3 q) { return vec2(q.x - q.y, 2.0 * q.z - q.x - q.y); }
float P30Cross2(vec2 a, vec2 b) { return a.x * b.y - a.y * b.x; }
vec3 P30TargetRGBFromLMS(vec3 lms, int mode) { return mode == 0 ? lms * P30_LMS_TO_BT709 : lms * P30_LMS_TO_BT2020; }

vec3 P30AnchorSourceBoundaryToYf(vec3 source_rgb, mat3 source_to_lms, vec3 source_yf_weights) {
  if (all(greaterThanEqual(source_rgb, vec3(0.0)))) return source_rgb * source_to_lms;
  float source_total = dot(max(source_rgb, 0.0), source_yf_weights);
  vec3 residual = source_rgb - source_total;
  vec3 lower_fraction = mix(vec3(P30_LARGE_SUPPORT), source_total / -residual, lessThan(residual, vec3(-P30_EPSILON)));
  float boundary_fraction = min(1.0, Min3(lower_fraction));
  vec3 bounded_lms = (source_total + residual * boundary_fraction) * source_to_lms;
  return bounded_lms * (source_total * P30_D65_WHITE_YF / P30Yf(bounded_lms));
}

float P30FiniteEndpoint(float x, float anchor, float peak, float h) {
  if (x <= 0.0) return 0.0;  // limit of the curve; avoids pow(0, negative)
  bool uniform_response = h == 1.0;
  float anchor_power = uniform_response ? anchor / peak : pow(anchor / peak, h);
  float slope_normalization = 1.0 - anchor_power;
  float response_drive = pow(x / anchor, -h / slope_normalization);
  float encoded = anchor_power / (anchor_power + slope_normalization * response_drive);
  return uniform_response ? peak * encoded : peak * pow(encoded, 1.0 / h);
}

float P30AutoCompressionPower(float anchor_yf, float peak_yf) {
  // Half of the 3.7 log10 reference simultaneous range above adaptation.
  return max(1.85 / (log2(peak_yf / anchor_yf) * 0.30102999566), 1.0);
}

float P30QuinticRamp(float t) { return Smootherstep(clamp(t, 0.0, 1.0)); }

float P30Highlights(float x, float highlights, float anchor_yf) {
  if (highlights == 1.0) return x;
  float ratio = x / anchor_yf;
  float t = x > anchor_yf ? clamp(log2(ratio) / log2(1.0 / anchor_yf), 0.0, 1.0) : 0.0;
  t = P30QuinticRamp(t);
  if (highlights > 1.0) return x * mix(1.0, pow(ratio, highlights - 1.0), t);
  return x / mix(1.0, pow(ratio, 1.0 - highlights), t);
}

float P30Shadows(float x, float shadows, float anchor_yf) {
  if (shadows == 1.0) return x;
  float ratio = x / anchor_yf;
  float anchor_squared = anchor_yf * anchor_yf;
  float anchor_cubed = anchor_squared * anchor_yf;
  float shadow_floor = anchor_yf * exp2(-4.0);
  float t = x > shadow_floor ? clamp(log2(ratio) / log2(shadow_floor / anchor_yf), 0.0, 1.0) : 1.0;
  t = P30QuinticRamp(t);
  if (shadows > 1.0) return mix(x, x * (1.0 - anchor_squared) + anchor_cubed * pow(ratio, 2.0 - shadows), t);
  return mix(x, x * (1.0 + anchor_squared) - anchor_cubed * pow(ratio, shadows), t);
}

vec3 P30ApplyAdaptiveRelativePurity(vec3 source_lms, vec3 anchor_lms, float purity_delta) {
  vec3 source_q = source_lms / anchor_lms;
  if (purity_delta == 1.0) return source_q;
  float relative_yf = P30Yf(source_lms) / P30Yf(anchor_lms);
  return mix(vec3(relative_yf), source_q, purity_delta);
}

float P30TargetNeutralYfLimit(float target_rgb_peak, vec3 anchor_lms, int mode) {
  return target_rgb_peak * P30Yf(anchor_lms) / Max3(P30TargetRGBFromLMS(anchor_lms, mode));
}

vec2 P30MBFromRelativeLMS(vec3 relative_lms) {
  float yf = P30Yf(relative_lms);
  return vec2(relative_lms.x * P30_MB_WEIGHTS.x / yf, relative_lms.z * P30_MB_WEIGHTS.z / yf);
}

vec3 P30FiniteResponseU(vec3 source_q, vec3 adaptation_peak_ratio, float response_power, float response_h) {
  bool uniform_response = response_h == 1.0;
  vec3 anchor_power = uniform_response ? adaptation_peak_ratio : pow(adaptation_peak_ratio, vec3(response_h));
  vec3 slope_normalization = 1.0 - anchor_power;
  vec3 response_drive = pow(source_q, -(response_power * response_h / slope_normalization));
  vec3 encoded = anchor_power / (anchor_power + slope_normalization * response_drive);
  return uniform_response ? encoded : pow(encoded, vec3(1.0 / response_h));
}

// Requires all(source_q > 0).
vec3 P30MeanA2Response(vec3 source_q, vec3 adaptation_peak_ratio, float response_power, float response_h,
                       out float normalized_response_yf) {
  vec3 u = P30FiniteResponseU(source_q, adaptation_peak_ratio, response_power, response_h);
  vec2 source_dt = P30ScaledA2FromQ(source_q);
  float response_lms_sum = u.x + u.y;
  vec2 response_dt = vec2(u.x - u.y, 2.0 * u.z - response_lms_sum);
  vec2 authored_dt = response_dt;
  float source_radius6 = P30Radius6(source_dt);
  float response_radius6 = P30Radius6(response_dt);
  if (source_radius6 > 6.0 * P30_EPSILON2 && response_radius6 > 6.0 * P30_EPSILON2) {
    float inverse_response_radius = inversesqrt(response_radius6);
    float response_radius = response_radius6 * inverse_response_radius;
    vec2 mean_direction = source_dt * inversesqrt(source_radius6) + response_dt * inverse_response_radius;
    float mean_radius6 = P30Radius6(mean_direction);
    if (mean_radius6 > P30_EPSILON2) authored_dt = mean_direction * (response_radius * inversesqrt(mean_radius6));
  }
  normalized_response_yf = P30_ALPHA_L * u.x + P30_ALPHA_M * u.y;
  return vec3(authored_dt.x, response_lms_sum + u.z, authored_dt.y);
}

vec2 P30ClosestPointOnScaleSegment(float desired_c, float radial_metric, vec2 segment_start, vec2 segment_end) {
  vec2 segment = segment_end - segment_start;
  float denominator = 2.0 * segment.x * segment.x + radial_metric * segment.y * segment.y;
  if (denominator <= P30_EPSILON2) return segment_start;
  float numerator = 2.0 * (desired_c - segment_start.x) * segment.x
                    + radial_metric * (1.0 - segment_start.y) * segment.y;
  return segment_start + segment * clamp(numerator / denominator, 0.0, 1.0);
}

// Exact nearest point for the fixed authored A2 direction inside the target
// RGB cube with the response-Yf ceiling.
vec3 P30YfCeilingSolve(vec3 desired_coord, float response_yf, int mode) {
  float max_a = response_yf;
  float radial_a_numerator = 3.0 * P30_ALPHA_DELTA * desired_coord.x - desired_coord.z;
  float desired_a = (2.0 * desired_coord.y + radial_a_numerator) / 6.0;
  vec3 radial_rgb = mode == 0 ? desired_coord.x * P30_BT709_D_RGB + desired_coord.z * P30_BT709_T_RGB
                              : desired_coord.x * P30_BT2020_D_RGB + desired_coord.z * P30_BT2020_T_RGB;
  vec3 desired_target_rgb = desired_a + radial_rgb;
  if (desired_a >= 0.0 && desired_a <= max_a
      && all(greaterThanEqual(desired_target_rgb, vec3(-P30_EPSILON)))
      && all(lessThanEqual(desired_target_rgb, vec3(1.0 + P30_EPSILON)))) {
    return desired_coord;
  }

  float radial_metric = P30Radius6(desired_coord.xz);
  if (radial_metric <= 6.0 * P30_EPSILON2) return vec3(0.0, clamp(desired_coord.y, 0.0, 3.0 * max_a), 0.0);

  float positive_pressure = Max3(radial_rgb);
  float negative_pressure = -Min3(radial_rgb);
  float total_pressure = positive_pressure + negative_pressure;
  bool is_triangle = max_a * total_pressure <= negative_pressure;
  float max_a_radial_scale;
  float upper_a;
  float upper_radial_scale;
  if (is_triangle) {
    max_a_radial_scale = max_a / negative_pressure;
    upper_a = max_a;
    upper_radial_scale = max_a_radial_scale;
  } else {
    max_a_radial_scale = (1.0 - max_a) / positive_pressure;
    upper_radial_scale = 1.0 / total_pressure;
    upper_a = negative_pressure * upper_radial_scale;
  }
  vec2 vertex0 = vec2(0.0);
  vec2 vertex1 = vec2(3.0 * max_a, 0.0);
  vec2 vertex2 = vec2(3.0 * max_a - 0.5 * radial_a_numerator * max_a_radial_scale, max_a_radial_scale);
  vec2 vertex3 = vec2(3.0 * upper_a - 0.5 * radial_a_numerator * upper_radial_scale, upper_radial_scale);
  vec2 desired_c_scale = vec2(desired_coord.y, 1.0);

  vec2 best_c_scale = vec2(clamp(desired_coord.y, vertex0.x, vertex1.x), 0.0);
  float best_cost = P30Cost(best_c_scale - desired_c_scale, radial_metric);
  vec2 candidate = P30ClosestPointOnScaleSegment(desired_coord.y, radial_metric, vertex1, vertex2);
  float cost = P30Cost(candidate - desired_c_scale, radial_metric);
  if (cost < best_cost) {
    best_c_scale = candidate;
    best_cost = cost;
  }
  if (!is_triangle) {
    candidate = P30ClosestPointOnScaleSegment(desired_coord.y, radial_metric, vertex2, vertex3);
    cost = P30Cost(candidate - desired_c_scale, radial_metric);
    if (cost < best_cost) {
      best_c_scale = candidate;
      best_cost = cost;
    }
  }
  candidate = P30ClosestPointOnScaleSegment(desired_coord.y, radial_metric, vertex0, vertex3);
  cost = P30Cost(candidate - desired_c_scale, radial_metric);
  if (cost < best_cost) best_c_scale = candidate;

  return vec3(desired_coord.x * best_c_scale.y, best_c_scale.x, desired_coord.z * best_c_scale.y);
}
)",
    R"(
vec3 P30LMSFromScaledA2(vec2 scaled_a2, float physical_yf, vec3 anchor_lms) {
  float a_l = P30_YF.x * anchor_lms.x;
  float a_m = P30_YF.y * anchor_lms.y;
  float q_m = (physical_yf - a_l * scaled_a2.x) / (a_l + a_m);
  float q_l = q_m + scaled_a2.x;
  float q_s = 0.5 * (scaled_a2.y + q_l + q_m);
  return vec3(q_l, q_m, q_s) * anchor_lms;
}

float P30ScaledA2TargetSupport(vec2 direction, float clip_magnitude, float physical_yf, vec3 anchor_lms,
                               int mode, float target_rgb_peak) {
  if (clip_magnitude <= P30_EPSILON) return 0.0;
  vec3 neutral_target = P30TargetRGBFromLMS(P30LMSFromScaledA2(vec2(0.0), physical_yf, anchor_lms), mode);
  vec3 delta_target = P30TargetRGBFromLMS(P30LMSFromScaledA2(direction, physical_yf, anchor_lms), mode) - neutral_target;
  float support = clip_magnitude;
  for (int channel = 0; channel < 3; ++channel) {
    if (delta_target[channel] > P30_EPSILON) {
      support = min(support, (target_rgb_peak - neutral_target[channel]) / delta_target[channel]);
    } else if (delta_target[channel] < -P30_EPSILON) {
      support = min(support, neutral_target[channel] / -delta_target[channel]);
    }
  }
  return max(support, 0.0);
}

float P30RaySegmentRadius(vec2 origin, vec2 direction, vec2 a, vec2 b) {
  vec2 edge = b - a;
  float denominator = P30Cross2(direction, edge);
  if (abs(denominator) <= P30_EPSILON) return P30_LARGE_SUPPORT;
  vec2 ao = a - origin;
  float t = P30Cross2(ao, edge) / denominator;
  float u = P30Cross2(ao, direction) / denominator;
  return t >= 0.0 && u >= 0.0 && u <= 1.0 ? t : P30_LARGE_SUPPORT;
}

float P30TransformedSourceClipScaledA2Magnitude(vec2 source_mb, float response_power, vec3 response_anchor_ratio,
                                                float physical_yf, vec3 anchor_lms) {
  vec2 source_offset = source_mb - P30_NEUTRAL_MB;
  float source_radius2 = dot(source_offset, source_offset);
  if (source_radius2 <= P30_EPSILON2) return 0.0;
  // BT.709 primaries (columns of the source matrix) in adaptation-relative MB.
  vec2 vertex0 = P30MBFromRelativeLMS(vec3(P30_BT709_TO_LMS[0][0], P30_BT709_TO_LMS[1][0], P30_BT709_TO_LMS[2][0]) / anchor_lms);
  vec2 vertex1 = P30MBFromRelativeLMS(vec3(P30_BT709_TO_LMS[0][1], P30_BT709_TO_LMS[1][1], P30_BT709_TO_LMS[2][1]) / anchor_lms);
  vec2 vertex2 = P30MBFromRelativeLMS(vec3(P30_BT709_TO_LMS[0][2], P30_BT709_TO_LMS[1][2], P30_BT709_TO_LMS[2][2]) / anchor_lms);
  vec2 source_direction = source_offset * inversesqrt(source_radius2);
  float source_boundary_radius = min(
      P30RaySegmentRadius(P30_NEUTRAL_MB, source_direction, vertex0, vertex1),
      min(P30RaySegmentRadius(P30_NEUTRAL_MB, source_direction, vertex1, vertex2),
          P30RaySegmentRadius(P30_NEUTRAL_MB, source_direction, vertex2, vertex0)));
  if (source_boundary_radius >= P30_LARGE_SUPPORT) return 0.0;

  vec2 boundary_mb = P30_NEUTRAL_MB + source_direction * source_boundary_radius;
  float m_fraction = 1.0 - boundary_mb.x;
  if (boundary_mb.x <= P30_EPSILON || m_fraction <= P30_EPSILON || boundary_mb.y <= P30_EPSILON) return 0.0;
  vec2 response_ratio = vec2(boundary_mb.x * P30_MB_WEIGHTS.y / (m_fraction * P30_MB_WEIGHTS.x),
                             boundary_mb.y * P30_MB_WEIGHTS.y / (m_fraction * P30_MB_WEIGHTS.z));
  if (response_power != 1.0) response_ratio = pow(response_ratio, vec2(response_power));
  response_ratio *= vec2(response_anchor_ratio.x / response_anchor_ratio.y, response_anchor_ratio.z / response_anchor_ratio.y);
  vec3 boundary_q_direction = vec3(response_ratio.x, 1.0, response_ratio.y);
  float boundary_q_m = physical_yf / P30Yf(anchor_lms * boundary_q_direction);
  return sqrt(P30Radius6(P30ScaledA2FromQ(boundary_q_direction * boundary_q_m)));
}

float P30NeutwoWithClip(float x, float peak, float clip, float h) {
  if (peak <= P30_EPSILON) return 0.0;
  if (clip <= peak * (1.0 + P30_EPSILON)) return min(x, peak);
  float q = clamp(x / clip, 0.0, 1.0);
  float k = clamp(peak / clip, 0.0, 1.0);
  if (h == 1.0) return peak * q / (q * (1.0 - k) + k);
  float qh = pow(q, h);
  float kh = pow(k, h);
  return peak * q / pow(qh * (1.0 - kh) + kh, 1.0 / h);
}

// Signed fallback for adaptation-relative LMS containing a zero or negative cone value.
vec3 P30LinearA2Fallback(vec3 source_q, vec3 anchor_in_lms, vec3 anchor_out_lms, int mode, float target_rgb_peak,
                         float response_power, float response_h, float target_compression_strength) {
  vec3 signed_response = response_power == 1.0
                             ? source_q
                             : CopySign(pow(abs(source_q), vec3(response_power)), source_q);
  vec3 response_lms = anchor_out_lms * signed_response;
  float response_yf = P30Yf(response_lms);

  vec2 source_scaled_a2 = P30ScaledA2FromQ(source_q);
  vec2 response_scaled_a2 = P30ScaledA2FromQ(response_lms / anchor_in_lms);
  float source_radius6 = P30Radius6(source_scaled_a2);
  float response_radius6 = P30Radius6(response_scaled_a2);
  vec3 authored_lms = response_lms;
  if (source_radius6 > 6.0 * P30_EPSILON2 && response_radius6 > 6.0 * P30_EPSILON2) {
    float inverse_response_radius = inversesqrt(response_radius6);
    float response_radius = response_radius6 * inverse_response_radius;
    vec2 midpoint = source_scaled_a2 * inversesqrt(source_radius6) + response_scaled_a2 * inverse_response_radius;
    float midpoint_radius6 = P30Radius6(midpoint);
    if (midpoint_radius6 > P30_EPSILON2) {
      authored_lms = P30LMSFromScaledA2(midpoint * inversesqrt(midpoint_radius6) * response_radius, response_yf, anchor_in_lms);
    }
  }

  float neutral_yf_limit = P30TargetNeutralYfLimit(target_rgb_peak, anchor_in_lms, mode);
  float target_yf = CopySign(P30FiniteEndpoint(abs(response_yf), P30Yf(anchor_out_lms), neutral_yf_limit, response_h), response_yf);

  vec3 desired_lms = (response_yf == 0.0 && target_yf == 0.0) ? vec3(0.0) : authored_lms * (target_yf / response_yf);
  if (target_compression_strength == 0.0) return desired_lms;
  if (target_yf <= 0.0) return desired_lms * (1.0 - target_compression_strength);

  vec2 desired_scaled_a2 = P30ScaledA2FromQ(desired_lms / anchor_in_lms);
  float desired_radius6 = P30Radius6(desired_scaled_a2);
  if (desired_radius6 <= 6.0 * P30_EPSILON2) return anchor_in_lms * (target_yf / P30Yf(anchor_in_lms));

  float inverse_desired_magnitude = inversesqrt(desired_radius6);
  float desired_magnitude = desired_radius6 * inverse_desired_magnitude;
  vec2 direction = desired_scaled_a2 * inverse_desired_magnitude;
  float source_clip_magnitude = max(
      P30TransformedSourceClipScaledA2Magnitude(P30MBFromRelativeLMS(source_q), response_power,
                                                anchor_out_lms / anchor_in_lms, target_yf, anchor_in_lms),
      desired_magnitude);
  float target_support = P30ScaledA2TargetSupport(direction, source_clip_magnitude, target_yf, anchor_in_lms,
                                                  mode, target_rgb_peak);
  float compressed_magnitude = min(
      P30NeutwoWithClip(desired_magnitude, target_support, max(source_clip_magnitude, target_support), response_h),
      target_support);
  return P30LMSFromScaledA2(direction * mix(desired_magnitude, compressed_magnitude, target_compression_strength),
                            target_yf, anchor_in_lms);
}

// psychotm_test30 with ApplyPsychoV30's arguments: 0.18 adaptation and
// background anchors and the injected PsychoV30 controls.
vec3 PsychoV30(vec3 bt709) {
  float peak_value = max(tone.x, 1.0);
  float contrast = max(grade.x, 1e-4);
  float compression = psycho.x;
  float gamut_compression = psycho.y;
  float cone_response_exponent = max(psycho.z, 1e-4);
  float purity_scale = psycho.w;
  int gamut_mode = int(modes.y);
  int source_boundary = int(modes.z);

  vec3 exposed_input = bt709 * tone.y;
  vec3 input_lms;
  if (source_boundary == 0) {
    input_lms = exposed_input * P30_BT709_TO_LMS;
  } else if (source_boundary == 2) {
    vec3 source_rgb = exposed_input * P30_BT709_TO_BT2020;
    if (all(lessThanEqual(source_rgb, vec3(0.0))) && !any(isinf(source_rgb))) return vec3(0.0);
    input_lms = P30AnchorSourceBoundaryToYf(source_rgb, P30_BT2020_TO_LMS, P30_BT2020_YF_WEIGHTS);
  } else if (source_boundary == 3) {
    vec3 source_rgb = exposed_input * P30_BT709_TO_AP1;
    if (all(lessThanEqual(source_rgb, vec3(0.0))) && !any(isinf(source_rgb))) return vec3(0.0);
    input_lms = P30AnchorSourceBoundaryToYf(source_rgb, P30_AP1_TO_LMS, P30_AP1_YF_WEIGHTS);
  } else {
    if (all(lessThanEqual(exposed_input, vec3(0.0))) && !any(isinf(exposed_input))) return vec3(0.0);
    input_lms = P30AnchorSourceBoundaryToYf(exposed_input, P30_BT709_TO_LMS, P30_BT709_YF_WEIGHTS);
  }

  vec3 anchor_in_lms = vec3(0.18) * P30_BT709_TO_LMS;
  vec3 anchor_out_lms = anchor_in_lms;

  vec3 graded_lms = input_lms;
  if (tone.z != 1.0 || tone.w != 1.0) {
    graded_lms = abs(input_lms);
    float graded_yf = P30Yf(graded_lms);
    float adapted_anchor_yf = P30Yf(anchor_in_lms);
    float graded_yf_out = P30Shadows(P30Highlights(graded_yf, tone.z, adapted_anchor_yf), tone.w, adapted_anchor_yf);
    graded_lms = CopySign(graded_lms * (graded_yf_out / graded_yf), input_lms);
  }

  float response_power = contrast * cone_response_exponent;
  vec3 response_input_q = P30ApplyAdaptiveRelativePurity(graded_lms, anchor_in_lms, purity_scale / contrast);

  float response_h = compression == 0.0
                         ? P30AutoCompressionPower(P30Yf(anchor_out_lms),
                                                   P30TargetNeutralYfLimit(peak_value, anchor_in_lms, gamut_mode))
                         : compression;

  if (any(lessThanEqual(response_input_q, vec3(0.0)))) {
    return P30LinearA2Fallback(response_input_q, anchor_in_lms, anchor_out_lms, gamut_mode, peak_value,
                               response_power, response_h, gamut_compression)
           * P30_LMS_TO_BT709;
  }
  float response_yf;
  vec3 desired_coord = P30MeanA2Response(response_input_q, anchor_out_lms / (P30_D65_WHITE_LMS * peak_value),
                                         response_power, response_h, response_yf);
  vec3 selected_coord = desired_coord;
  if (gamut_compression != 0.0) {
    vec3 solved_coord = P30YfCeilingSolve(desired_coord, response_yf, gamut_mode);
    selected_coord = gamut_compression == 1.0 ? solved_coord : mix(desired_coord, solved_coord, gamut_compression);
  }
  float output_a = (2.0 * selected_coord.y + 3.0 * P30_ALPHA_DELTA * selected_coord.x - selected_coord.z) / 6.0;
  return peak_value * (output_a + selected_coord.x * P30_BT709_D_RGB + selected_coord.z * P30_BT709_T_RGB);
}

// ApplyPsychoV30 keeps the general saturation slider (renodx::color::grade::Saturation).
vec3 ApplyPsychoV30(vec3 color) {
  color = PsychoV30(color);
  if (grade.z != 1.0) {
    vec3 lab = OkLabFromBT709(color);
    lab.yz *= grade.z;
    color = max(BT709FromOkLab(lab) * P30_BT709_TO_AP1, 0.0) * P30_AP1_TO_BT709;
  }
  return color;
}

void main() {
  vec4 source = texelFetch(scene, ivec2(gl_FragCoord.xy), 0);
  // Doom 3 writes a legacy gamma-domain signal; decode it like the display shader.
  vec3 color = Sanitize(pow(Sanitize(source.rgb), vec3(2.2)));
  color = Sanitize(modes.x == 1.0 ? ApplyPsychoV30(color) : RenoDRT(color));
  // Store relative to UI white, re-encoded to Doom 3's gamma domain so the GUI
  // blends over it exactly as it would over the vanilla scene.
  gl_FragColor = vec4(pow(color * extra.z, vec3(1.0 / 2.2)), source.a);
}
)",
};

}  // namespace doom3::opengl
