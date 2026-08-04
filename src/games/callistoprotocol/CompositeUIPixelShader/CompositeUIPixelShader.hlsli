#include "../common.hlsli"

// Derives power from anchor-to-peak range, fading to Reinhard power 1 for narrow ranges.
float ComputeNakaRushtonCompressionPower(float anchor_y, float peak_y) {
  static const float REFERENCE_ONE_SIDE_RANGE_STOPS = 3.7f * 0.5f * log2(10.f);
  static const float TRANSITION_START_RANGE_STOPS = log2(4.f / 0.18f);
  static const float TRANSITION_END_RANGE_STOPS = log2(1.f / 0.18f);

  float range_stops = log2(peak_y / anchor_y);
  float hdr_power = max(REFERENCE_ONE_SIDE_RANGE_STOPS / range_stops, 1.f);
  [branch]
  if (range_stops < TRANSITION_START_RANGE_STOPS) {
    float hdr_weight = saturate((range_stops - TRANSITION_END_RANGE_STOPS) * 0.5f);
    hdr_weight *= hdr_weight * mad(-2.f, hdr_weight, 3.f);
    hdr_power = mad(hdr_weight, hdr_power - 1.f, 1.f);
  }

  return hdr_power;
}

// Exact cone response through anchor_in; generalized Naka-Rushton above anchor_out.
// Monotonic and C2 at the anchor for positive anchors, peak > anchor_out, and power > 1.
float ApplyNakaRushtonToneCurve(
    float color,
    float peak,
    float anchor_in,
    float anchor_out,
    float cone_response_exponent,
    float compression_power) {
  float cone_response = anchor_out * pow(max(color / anchor_in, 0.f), cone_response_exponent);
  float shoulder_range = peak - anchor_out;
  float distance_from_anchor = max(cone_response - anchor_out, 0.f);
  float position = distance_from_anchor / shoulder_range;
  float response_scale = pow(1.f + pow(position, compression_power), -rcp(compression_power));

  return mad(distance_from_anchor, response_scale, cone_response - distance_from_anchor);
}

float ApplyNakaRushtonToneCurve(float color, float peak, float anchor) {
  return ApplyNakaRushtonToneCurve(color, peak, anchor, anchor, 1.f, 2.f);
}

// Maps white_clip to peak and remains flat above it; C2 at the anchor and clip.
float ApplyNakaRushtonToneCurve(
    float color,
    float peak,
    float anchor_in,
    float anchor_out,
    float cone_response_exponent,
    float compression_power,
    float white_clip) {
  float cone_response = anchor_out * pow(max(color / anchor_in, 0.f), cone_response_exponent);
  float white_cone_response = anchor_out * pow(white_clip / anchor_in, cone_response_exponent);
  float shoulder_range = peak - anchor_out;
  float distance_from_anchor = max(cone_response - anchor_out, 0.f);
  float input_range = white_cone_response - anchor_out;
  float clipped_distance = min(distance_from_anchor, input_range);
  float clip_position = clipped_distance / input_range;
  float position = clipped_distance / shoulder_range;
  float warp_base = 1.f - clip_position * clip_position * clip_position;
  float response_scale = pow(
      warp_base * warp_base * warp_base + pow(position, compression_power),
      -rcp(compression_power));

  return mad(clipped_distance, response_scale, cone_response - distance_from_anchor);
}

float3 ApplyNakaRushtonToneCurve(
    float3 color,
    float3 peak,
    float3 anchor_in,
    float3 anchor_out,
    float cone_response_exponent,
    float compression_power) {
  float3 cone_response = anchor_out * pow(max(color / anchor_in, 0.f), cone_response_exponent);
  float3 shoulder_range = peak - anchor_out;
  float3 distance_from_anchor = max(cone_response - anchor_out, 0.f);
  float3 position = distance_from_anchor / shoulder_range;
  float3 response_scale = pow(1.f + pow(position, compression_power), -rcp(compression_power));

  return mad(distance_from_anchor, response_scale, cone_response - distance_from_anchor);
}

float3 ApplyNakaRushtonToneCurve(float3 color, float3 peak, float3 anchor) {
  return ApplyNakaRushtonToneCurve(color, peak, anchor, anchor, 1.f, 2.f);
}

float3 ApplyNakaRushtonToneCurve(
    float3 color,
    float3 peak,
    float3 anchor_in,
    float3 anchor_out,
    float3 cone_response_exponent,
    float3 compression_power,
    float3 white_clip) {
  float3 cone_response = anchor_out * pow(max(color / anchor_in, 0.f), cone_response_exponent);
  float3 white_cone_response = anchor_out * pow(white_clip / anchor_in, cone_response_exponent);
  float3 shoulder_range = peak - anchor_out;
  float3 distance_from_anchor = max(cone_response - anchor_out, 0.f);
  float3 input_range = white_cone_response - anchor_out;
  float3 clipped_distance = min(distance_from_anchor, input_range);
  float3 clip_position = clipped_distance / input_range;
  float3 position = clipped_distance / shoulder_range;
  float3 warp_base = 1.f - clip_position * clip_position * clip_position;
  float3 response_scale = pow(
      warp_base * warp_base * warp_base + pow(position, compression_power),
      -rcp(compression_power));

  return mad(clipped_distance, response_scale, cone_response - distance_from_anchor);
}

// Identity through anchor; then monotonic and concave down, approaching peak asymptotically.
// The anchor join is C2 continuous. Requires anchor < peak.
float3 ApplyAnchoredCubicShoulder(
    float3 color,
    float3 anchor,
    float3 peak) {
  float3 shoulder_range = peak - anchor;
  float3 distance_from_anchor = max(color - anchor, 0.f);
  float3 response_numerator = distance_from_anchor * (shoulder_range + distance_from_anchor);
  float3 response_denominator = mad(shoulder_range, shoulder_range, response_numerator);

  return mad(shoulder_range, response_numerator / response_denominator, color - distance_from_anchor);
}

// Identity through anchor; reaches peak at clip, then remains flat.
// Monotonic, concave down, and C2 at both joins. Requires anchor < peak < clip.
float3 ApplyAnchoredCubicShoulder(
    float3 color,
    float3 anchor,
    float3 peak,
    float3 clip) {
  float3 shoulder_range = peak - anchor;
  float3 input_range = clip - anchor;
  float3 position = saturate((color - anchor) / input_range);
  float3 range_ratio = input_range / shoulder_range;
  float3 linear_coefficient = range_ratio - 3.f;
  float3 mixed_coefficient = range_ratio * linear_coefficient;
  float3 response_denominator = mad(
      position,
      mad(mixed_coefficient + 3.f, position, linear_coefficient),
      1.f);
  float3 response_numerator = position * mad(position, position + mixed_coefficient, range_ratio);

  return mad(shoulder_range, response_numerator / response_denominator, min(color, anchor));
}

bool ComposeUIAndSceneSCRGB(float3 scene_color, float4 ui_color_gamma, inout float4 output_color, float2 position) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  ui_color_gamma = max(0, ui_color_gamma);
  float ui_alpha = ui_color_gamma.a;

  if (RENODX_GAMMA_CORRECTION_UI == 0.f) {
    ui_color_gamma.rgb = renodx::color::gamma::Encode(renodx::color::srgb::Decode(ui_color_gamma.rgb));
  }

  // Defer display mapping to compositing because PostProcessToneMap applies adjustments after tonemapping.
  static const float MID_GRAY = 0.18f;
  float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  float compression_power = ComputeNakaRushtonCompressionPower(MID_GRAY, peak_ratio);
  if (RENODX_TONE_MAP_WORKING_COLOR_SPACE == 0.f) {  // BT.709
    scene_color = ApplyNakaRushtonToneCurve(
        scene_color,
        peak_ratio.xxx,
        MID_GRAY.xxx,
        MID_GRAY.xxx,
        1.f,
        compression_power,
        100.f.xxx);
  } else {  // LMS
    float3 scene_lms = renodx::color::lms::from::BT709(scene_color);
    float3 anchor_lms = renodx::color::lms::from::BT2020(MID_GRAY.xxx);
    float3 peak_lms = renodx::color::lms::from::BT2020(peak_ratio.xxx);
    scene_lms = ApplyNakaRushtonToneCurve(
        scene_lms,
        peak_lms,
        anchor_lms,
        anchor_lms,
        1.f,
        compression_power,
        renodx::color::lms::from::BT2020(100.f));
    scene_color = renodx::color::bt709::from::LMS(scene_lms);
  }

  // Rescale that reference so 1.0 represents the configured diffuse white.
  scene_color *= RENODX_DIFFUSE_WHITE_NITS;

  // Blend UI and scene color in gamma space, then convert back to linear space.
  scene_color /= RENODX_GRAPHICS_WHITE_NITS;
  float3 scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color);
  float3 composited_color_gamma = mad(scene_color_gamma, 1.f - ui_alpha, ui_color_gamma.rgb);
  float3 composited_color = renodx::color::gamma::DecodeSafe(composited_color_gamma);
  composited_color *= RENODX_GRAPHICS_WHITE_NITS;

  output_color = float4(composited_color / 80.f, ui_alpha);
  return true;
}
