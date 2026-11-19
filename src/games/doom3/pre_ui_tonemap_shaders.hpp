#pragma once

// GLSL for the Doom 3 pre-UI tone map (see ToneMapScene in opengl_framebuffer.hpp).
// It runs on the finished 3D scene right before Doom 3 draws its GUI and mirrors
// the display shader's tone mappers:
//   - RenoDRT: renodx::draw::ToneMapPass with the visible settings (luminance or
//     per-channel scaling and the grading sliders). Hidden hue correction and
//     options stay neutral, with output bounded to the selected peak.
//   - PsychoV35: renodx::tonemap::psychov::psychotm_test35 exactly as
//     ApplyPsychoV35 calls it, plus its OKLab saturation slider.
// Color matrices are precomputed from the shared RGB and PsychoV35 sources. HLSL
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
uniform vec4 psycho;  // PsychoV35 compression, gamut compression, cone response, purity scale
uniform vec4 modes;   // tone mapper (0 RenoDRT, 1 PsychoV35), PsychoV35 gamut mode, source boundary

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
    float y_new = min(ReinhardScalable(vec3(y), white_max, peak).x, peak);
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
  return min(color, vec3(peak));
}

float Max3(vec3 v) { return max(v.x, max(v.y, v.z)); }

// PsychoV35 matrices: HLSL rows stored as GLSL columns for v * M.
const mat3 P35_BT709_TO_LMS = mat3(0.2896057765550949, 0.6972466441767436, 0.07637127861652246,
    0.09018375761738257, 0.7073490256546452, 0.1122031464307159,
    0.01552874012260572, 0.05360930730601509, 0.5097978304529558);
const mat3 P35_LMS_TO_BT709 = mat3(4.967619650489394, -4.92237952939332, 0.3391991812339037,
    -0.6196828787997994, 2.051750651511519, -0.3587439844047841,
    -0.08615200402306292, -0.06581938299690304, 1.988954483326219);
const mat3 P35_LMS_TO_BT2020 = mat3(2.908921353735816, -2.415564244797975, 0.1808342947861866,
    -0.2275532729619213, 1.545796661336631, -0.2838427126802022,
    -0.05027123210578335, 0.0409489516665878, 1.755283912080666);
const vec3 P35_WHITE_LMS = vec3(1.063223699348361, 0.9097359297027436, 0.5789358778815766);
const vec3 P35_YF = vec3(.68990272, .34832189, 0.0);
const mat3 P35_BT709_TO_AP1 = mat3(
    0.613097429, 0.339523137, 0.0473794527,
    0.0701937228, 0.916353881, 0.0134523986,
    0.0206155926, 0.109569773, 0.869814634);
const mat3 P35_AP1_TO_BT709 = mat3(
    1.70505095, -0.621792138, -0.0832588747,
    -0.130256414, 1.14080477, -0.0105483187,
    -0.0240033567, -0.128968969, 1.15297234);

// PsychoV35 public path: human conditioning off, exact target fit.
// Port of src/shaders/tonemap/psychov/test35.hlsl (43d58747).
// Copyright (C) 2026 Carlos Lopez. SPDX-License-Identifier: MIT
// Legacy source-boundary metadata is unused by Test35, as in its HLSL API.

float P35Mean(vec3 v) {
  return v.x + ((v.y - v.x) + (v.z - v.x)) / 3.0;
}

vec3 P35TargetResidual(vec3 normalized_lms, int target) {
  vec3 physical_lms = normalized_lms * P35_WHITE_LMS;
  return target == 0 ? physical_lms * P35_LMS_TO_BT709 : physical_lms * P35_LMS_TO_BT2020;
}

vec3 PsychoV35(vec3 bt709) {
  float peak = max(tone.x, 1.0);
  float contrast = max(grade.x, 1e-4);
  vec3 anchor_in = vec3(0.18) * P35_BT709_TO_LMS;
  vec3 input_lms = (bt709 * tone.y) * P35_BT709_TO_LMS;
  if (tone.z != 1.0 || tone.w != 1.0) {
    float input_yf = dot(P35_YF, input_lms);
    float anchor_yf = dot(P35_YF, anchor_in);
    float graded_y = input_yf;
    if (tone.z != 1.0) {
      float ratio = graded_y / anchor_yf;
      float blend = graded_y > anchor_yf ? clamp(log2(ratio) / log2(1.0 / anchor_yf), 0.0, 1.0) : 0.0;
      blend = Smootherstep(blend);
      float shaped = pow(ratio, abs(tone.z - 1.0));
      graded_y = tone.z > 1.0 ? graded_y * mix(1.0, shaped, blend) : graded_y / mix(1.0, shaped, blend);
    }
    if (tone.w != 1.0) {
      float ratio = graded_y / anchor_yf;
      float blend = graded_y > anchor_yf * exp2(-4.0) ? clamp(log2(ratio) / -4.0, 0.0, 1.0) : 1.0;
      blend = Smootherstep(blend);
      float target_y = tone.w > 1.0
          ? graded_y * (1.0 - anchor_yf * anchor_yf) + anchor_yf * anchor_yf * anchor_yf * pow(ratio, 2.0 - tone.w)
          : graded_y * (1.0 + anchor_yf * anchor_yf) - anchor_yf * anchor_yf * anchor_yf * pow(ratio, tone.w);
      graded_y = mix(graded_y, target_y, blend);
    }
    if (input_yf != 0.0) input_lms *= graded_y / input_yf;
  }

  vec3 source_ratio = input_lms / anchor_in;
  if (psycho.w != contrast) {
    float neutral_ratio = dot(P35_YF, input_lms) / dot(P35_YF, anchor_in);
    vec3 purity_direction = source_ratio - neutral_ratio;
    float purity_amount = psycho.w / contrast;
    if (all(greaterThanEqual(source_ratio, vec3(0.0))) && neutral_ratio > 0.0 && purity_amount > 1.0) {
      for (int cone = 0; cone < 3; ++cone) {
        if (purity_direction[cone] < 0.0) purity_amount = min(purity_amount, neutral_ratio / -purity_direction[cone]);
      }
      source_ratio = max(neutral_ratio + purity_amount * purity_direction, 0.0);
    } else {
      source_ratio = neutral_ratio + purity_amount * purity_direction;
    }
  }
  if (all(equal(source_ratio, vec3(0.0)))) return vec3(0.0);
  int target = int(modes.y);
  vec3 anchor_target = target == 0 ? anchor_in * P35_LMS_TO_BT709 : anchor_in * P35_LMS_TO_BT2020;
  float neutral_yf_limit = peak * dot(P35_YF, anchor_in) / Max3(anchor_target);
  float h = psycho.x == 0.0 ? max(1.85 / (log2(neutral_yf_limit / dot(P35_YF, anchor_in)) * 0.30102999566), 1.0) : psycho.x;
  float response_power = contrast * max(psycho.z, 1e-4);
  vec3 anchor_power = pow(anchor_in / (P35_WHITE_LMS * peak), vec3(h));
  vec3 input_exponent = response_power * h / (1.0 - anchor_power);

  // Factor exposure exactly as the HLSL reference. Zero cones retain their
  // analytic limits; positive-cone tails retain their log-domain deficits.
  float drive = Max3(abs(source_ratio));
  source_ratio /= drive;
  vec3 log_source_ratio;
  for (int cone = 0; cone < 3; ++cone) log_source_ratio[cone] = log(source_ratio[cone] != 0.0 ? source_ratio[cone] : 1.0);
  float exposure_stops = log2(drive);
  vec3 response, deficit;
  for (int cone = 0; cone < 3; ++cone) {
    if (source_ratio[cone] == 0.0) {
      response[cone] = 0.0;
      deficit[cone] = 1.0;
    } else {
      float log_q = log_source_ratio[cone] + exposure_stops * log(2.0);
      float latent = log(anchor_power[cone]) - log(1.0 - anchor_power[cone]) + input_exponent[cone] * log_q;
      float correction = log(1.0 + exp(-abs(latent)));
      float log_u = (min(latent, 0.0) - correction) / h;
      float log_tail = -max(latent, 0.0) - correction;
      float log_deficit = latent > 20.0 ? log_tail - log(h)
          : log(abs(log_u) < 0.01 ? -log_u * (1.0 + log_u * (0.5 + log_u * (1.0 / 6.0 + log_u / 24.0))) : 1.0 - exp(log_u));
      response[cone] = exp(log_u);
      deficit[cone] = exp(log_deficit);
    }
  }
  float response_mean = P35Mean(response);
  vec3 response_residual = response_mean > 0.5 ? P35Mean(deficit) - deficit : response - response_mean;
  float residual_scale = Max3(abs(response_residual));
  vec3 scaled_residual = residual_scale > 0.0 ? response_residual / residual_scale : vec3(0.0);
  float scaled_radius = length(scaled_residual);
  float radius = residual_scale * scaled_radius;
  vec3 direction = scaled_radius > 0.0 ? scaled_residual / scaled_radius : vec3(0.0);
  vec3 source = source_ratio - P35Mean(source_ratio);
  float source_radius = length(source);
  if (source_radius > 0.0 && radius > 0.0) {
    vec3 midpoint_direction = source / source_radius + direction;
    float midpoint_length = length(midpoint_direction);
)",
    R"(    if (midpoint_length > 0.0) direction = midpoint_direction / midpoint_length;
  }
  float mean = peak * response_mean;
  float headroom = peak * P35Mean(deficit);
  vec3 residual = peak * radius * direction;
  if (psycho.y == 0.0) return mean + P35TargetResidual(residual, 0);
  if (all(equal(residual, vec3(0.0)))) return vec3(mean);
  vec3 target_displacement = P35TargetResidual(residual, target);
  float scale = 1.0;
  for (int channel = 0; channel < 3; ++channel) {
    if (target_displacement[channel] > 0.0) {
      scale = min(scale, headroom / target_displacement[channel]);
    } else if (target_displacement[channel] < 0.0) {
      scale = min(scale, mean / -target_displacement[channel]);
    }
  }
  return mean + P35TargetResidual(residual * mix(1.0, scale, psycho.y), 0);
}

const mat3 BT709_TO_BT2020 = mat3(0.627403895993272, 0.3292830383829807, 0.04331306566132904,
    0.06909728938704494, 0.9195403951018893, 0.01136231562034049,
    0.01639143883150003, 0.08801330783058922, 0.8955952531541842);
const mat3 BT2020_TO_BT709 = mat3(1.660491001968074, -0.5876411387421842, -0.07284986323746398,
    -0.124550474559401, 1.132899897113987, -0.008349422675236091,
    -0.01815076327606974, -0.1005788979878201, 1.118729661481103);

vec3 ApplyPsychoV35(vec3 color) {
  color = PsychoV35(color);
  if (grade.z != 1.0) {
    vec3 lab = OkLabFromBT709(color);
    lab.yz *= grade.z;
    color = max(BT709FromOkLab(lab) * P35_BT709_TO_AP1, 0.0) * P35_AP1_TO_BT709;
  }
  return color;
}

void main() {
  vec4 source = texelFetch(scene, ivec2(gl_FragCoord.xy), 0);
  // Doom 3 writes a legacy gamma-domain signal; decode it like the display shader.
  vec3 color = Sanitize(pow(Sanitize(source.rgb), vec3(2.2)));
  // Extend only scene values above game white. The quadratic onset leaves
  // diffuse white and its slope unchanged; the tone mapper owns peak rolloff.
  vec3 scene_color = color;
  float scene_y = dot(color, BT709_Y);
  float highlight_weight = scene_y > 1.0 ? 1.0 - 1.0 / scene_y : 0.0;
  if (scene_y > 1.0) {
    color *= 1.0 + (max(tone.x, 1.0) - 1.0) * highlight_weight * highlight_weight;
    color = Sanitize(color);
  }
  color = Sanitize(modes.x == 1.0 ? ApplyPsychoV35(color) : RenoDRT(color));
  if (highlight_weight > 0.0 && tone.x > 1.0) {
    // Preserve the scene's SDR color ratios at the mapped highlight peak.
    bool wide_target = modes.x == 1.0 && modes.y != 0.0;
    vec3 reference = scene_color;
    if (grade.z != 1.0) {
      vec3 lab = OkLabFromBT709(reference);
      lab.yz *= grade.z;
      reference = max(BT709FromOkLab(lab) * P35_BT709_TO_AP1, 0.0) * P35_AP1_TO_BT709;
    }
    reference = max(wide_target ? reference * BT709_TO_BT2020 : reference, 0.0);
    vec3 mapped = max(wide_target ? color * BT709_TO_BT2020 : color, 0.0);
    float mapped_peak = Max3(mapped);
    float bounded_peak = min(mapped_peak, tone.x);
    mapped *= bounded_peak / max(mapped_peak, 1e-6);
    reference *= bounded_peak / max(Max3(reference), 1e-6);
    color = mix(mapped, reference, highlight_weight * highlight_weight);
    if (wide_target) color = color * BT2020_TO_BT709;
  }
  // Store relative to UI white, re-encoded to Doom 3's gamma domain so the GUI
  // blends over it exactly as it would over the vanilla scene.
  gl_FragColor = vec4(pow(color * extra.z, vec3(1.0 / 2.2)), source.a);
}
)",
};

}  // namespace doom3::opengl
