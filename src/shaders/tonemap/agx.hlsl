#ifndef RENODX_SHADERS_TONEMAP_AGX_HLSL_
#define RENODX_SHADERS_TONEMAP_AGX_HLSL_

#include "../color.hlsl"

// AgX tone scale and gamut shaping based on Troy Sobotka's Kraken AgX.
// https://github.com/sobotka/AgX-Resolve
//
// Independent outset hue-flight support is based on EaryChow's Blender AgX,
// which separates inset rotation from outset/reverse rotation.
// https://github.com/EaryChow/Blender-AgX-Resolve
//
// The full Apply pipeline assumes scene-linear input and normalized log2
// encoding. An explicit-pivot tone-scale builder also supports wrappers
// using another encoding, such as Camera-AgX's LogC3.
namespace renodx {
namespace tonemap {
namespace agx {

struct Primaries {
  float2 red;
  float2 green;
  float2 blue;
  float2 white;
};

struct GamutParameters {
  // AgX-style inward attenuation of the working/inset gamut.
  // 0 = boundary, 0.2 = 80% of the boundary radius.
  float3 attenuation;

  // Inset rotation around the starting gamut white point, in degrees.
  float3 inset_hue_flight;

  // AgX-style outset purity restoration.
  // 0 = boundary. Positive values move the outset primaries inward,
  // causing the base-to-outset transform to restore/increase color purity.
  float3 purity;

  // Outset/reverse rotation around the starting gamut white point, in degrees.
  float3 outset_hue_flight;
};

struct GamutTransforms {
  float3x3 inset;
  float3x3 outset;
};

struct ToneScaleParameters {
  // Exposure range in stops around input_mid_gray.
  float min_ev;
  float max_ev;

  // Scene-linear value corresponding to EV 0.
  float input_mid_gray;

  // Output value of input_mid_gray in the sigmoid domain, before output_power.
  float output_pivot;

  // Sigmoid shape controls.
  float toe_power;
  float shoulder_power;
  float slope;

  // Power applied after the sigmoid to return to display-linear light.
  float output_power;
};

// Fully evaluable tone scale. The derived values may be built from the
// authoring parameters or supplied from CPU-precomputed game constants.
struct ToneScale {
  ToneScaleParameters parameters;

  float inverse_ev_range;
  float minimum_linear;
  float input_pivot;
  float toe_scale;
  float shoulder_scale;
  float inverse_toe_power;
  float inverse_shoulder_power;
};

float2 XYZToChromaticity(float3 xyz) {
  const float xyz_sum = xyz.x + xyz.y + xyz.z;
  const float inverse_sum = 1.f / xyz_sum;

  return xyz.xy * inverse_sum;
}

float3 ChromaticityToXYZDirection(float2 chromaticity) {
  const float inverse_y = 1.f / chromaticity.y;
  const float z = 1.f - chromaticity.x - chromaticity.y;

  return float3(
      chromaticity.x * inverse_y,
      1.f,
      z * inverse_y);
}

Primaries PrimariesFromXYZMatrix(float3x3 gamut_to_xyz) {
  Primaries primaries;

  const float3 red_xyz = float3(gamut_to_xyz[0][0], gamut_to_xyz[1][0], gamut_to_xyz[2][0]);
  const float3 green_xyz = float3(gamut_to_xyz[0][1], gamut_to_xyz[1][1], gamut_to_xyz[2][1]);
  const float3 blue_xyz = float3(gamut_to_xyz[0][2], gamut_to_xyz[1][2], gamut_to_xyz[2][2]);
  const float3 white_xyz = mul(gamut_to_xyz, float3(1.f, 1.f, 1.f));

  primaries.red = XYZToChromaticity(red_xyz);
  primaries.green = XYZToChromaticity(green_xyz);
  primaries.blue = XYZToChromaticity(blue_xyz);
  primaries.white = XYZToChromaticity(white_xyz);

  return primaries;
}

float3x3 PrimariesToXYZMatrix(Primaries primaries) {
  const float3 red_xyz = ChromaticityToXYZDirection(primaries.red);
  const float3 green_xyz = ChromaticityToXYZDirection(primaries.green);
  const float3 blue_xyz = ChromaticityToXYZDirection(primaries.blue);
  const float3 white_xyz = ChromaticityToXYZDirection(primaries.white);

  const float3x3 unscaled_matrix = float3x3(
      red_xyz.x, green_xyz.x, blue_xyz.x,
      red_xyz.y, green_xyz.y, blue_xyz.y,
      red_xyz.z, green_xyz.z, blue_xyz.z);

  const float3x3 xyz_to_unscaled = renodx::math::Invert3x3(unscaled_matrix);
  const float3 primary_scale = mul(xyz_to_unscaled, white_xyz);

  return float3x3(
      unscaled_matrix[0] * primary_scale,
      unscaled_matrix[1] * primary_scale,
      unscaled_matrix[2] * primary_scale);
}

float Cross2(float2 a, float2 b) {
  return a.x * b.y - a.y * b.x;
}

float2 LineIntersection(float2 p0, float2 p1, float2 q0, float2 q1) {
  const float2 p_direction = p1 - p0;
  const float2 q_direction = q1 - q0;

  const float numerator = Cross2(q0 - p0, q_direction);
  const float denominator = Cross2(p_direction, q_direction);
  const float distance = numerator / denominator;

  return p0 + p_direction * distance;
}

float2 RotatePrimary(float2 primary, float2 white, float degrees) {
  const float radians = degrees * (renodx::math::PI / 180.f);

  float sine;
  float cosine;
  sincos(radians, sine, cosine);

  const float2 offset = primary - white;
  const float2 rotated_offset = float2(
      cosine * offset.x - sine * offset.y,
      sine * offset.x + cosine * offset.y);

  return white + rotated_offset;
}

// https://github.com/sobotka/AgX-Resolve
//
// AgX primary geometry:
// 1. Start at the original gamut.
// 2. Rotate a ray around the white point.
// 3. Intersect that ray with the appropriate edge of the original gamut.
// 4. Use that intersection as the new per-primary boundary.
//
// AgX implementations may first expand the primary before rotation.
// This does not affect the resulting infinite ray, so it is omitted here.
Primaries BuildHueFlightBoundary(Primaries base, float3 hue_flight) {
  const float2 rotated_red = RotatePrimary(base.red, base.white, hue_flight.r);
  const float2 rotated_green = RotatePrimary(base.green, base.white, hue_flight.g);
  const float2 rotated_blue = RotatePrimary(base.blue, base.white, hue_flight.b);

  const float2 red_edge_end = hue_flight.r > 0.f ? base.green : base.blue;

  const float2 green_edge_start = hue_flight.g > 0.f ? base.blue : base.red;

  const float2 blue_edge_start = hue_flight.b > 0.f ? base.red : base.blue;
  const float2 blue_edge_end = hue_flight.b > 0.f ? base.blue : base.green;

  Primaries boundary;
  boundary.white = base.white;
  boundary.red = LineIntersection(base.white, rotated_red, base.red, red_edge_end);
  boundary.green = LineIntersection(base.white, rotated_green, green_edge_start, base.green);
  boundary.blue = LineIntersection(base.white, rotated_blue, blue_edge_start, blue_edge_end);

  return boundary;
}

Primaries ScalePrimaries(Primaries primaries, float3 scale) {
  const float2 red_offset = primaries.red - primaries.white;
  const float2 green_offset = primaries.green - primaries.white;
  const float2 blue_offset = primaries.blue - primaries.white;

  primaries.red = primaries.white + red_offset * scale.r;
  primaries.green = primaries.white + green_offset * scale.g;
  primaries.blue = primaries.white + blue_offset * scale.b;

  return primaries;
}

GamutTransforms BuildGamutTransformsFromPrimaries(float3x3 base_to_xyz, Primaries inset_primaries, Primaries outset_primaries) {
  const float3x3 inset_to_xyz = PrimariesToXYZMatrix(inset_primaries);
  const float3x3 outset_to_xyz = PrimariesToXYZMatrix(outset_primaries);

  const float3x3 xyz_to_base = renodx::math::Invert3x3(base_to_xyz);
  const float3x3 xyz_to_outset = renodx::math::Invert3x3(outset_to_xyz);

  GamutTransforms transforms;
  transforms.inset = mul(xyz_to_base, inset_to_xyz);
  transforms.outset = mul(xyz_to_outset, base_to_xyz);

  return transforms;
}

// Parameter form with independent inset and outset hue flight.
GamutTransforms BuildGamutTransforms(float3x3 base_to_xyz, GamutParameters parameters) {
  const Primaries base = PrimariesFromXYZMatrix(base_to_xyz);

  const Primaries inset_boundary = BuildHueFlightBoundary(base, parameters.inset_hue_flight);
  const Primaries outset_boundary = BuildHueFlightBoundary(base, parameters.outset_hue_flight);

  const float3 inset_scale = 1.f - parameters.attenuation;
  const float3 outset_scale = 1.f - parameters.purity;

  const Primaries inset_primaries = ScalePrimaries(inset_boundary, inset_scale);
  const Primaries outset_primaries = ScalePrimaries(outset_boundary, outset_scale);

  return BuildGamutTransformsFromPrimaries(base_to_xyz, inset_primaries, outset_primaries);
}

// Fully explicit form corresponding to EaryChow's independent outset/reverse rotation.
GamutTransforms BuildGamutTransforms(float3x3 base_to_xyz, float3 attenuation, float3 inset_hue_flight, float3 purity, float3 outset_hue_flight) {
  GamutParameters parameters;
  parameters.attenuation = attenuation;
  parameters.inset_hue_flight = inset_hue_flight;
  parameters.purity = purity;
  parameters.outset_hue_flight = outset_hue_flight;

  return BuildGamutTransforms(base_to_xyz, parameters);
}

// Kraken form: inset and outset share the same hue flight.
GamutTransforms BuildGamutTransforms(float3x3 base_to_xyz, float3 attenuation, float3 hue_flight, float3 purity) {
  GamutParameters parameters;
  parameters.attenuation = attenuation;
  parameters.inset_hue_flight = hue_flight;
  parameters.purity = purity;
  parameters.outset_hue_flight = hue_flight;

  return BuildGamutTransforms(base_to_xyz, parameters);
}

// Kraken floors decoded input before the inset transform.
// Input is always scene-linear here, so the decoded floor is 0.
float3 ApplyInset(float3 color, float3x3 inset) {
  color = max(color, 0.f);
  return mul(inset, color);
}

float3 ApplyInset(float3 color, GamutTransforms transforms) {
  return ApplyInset(color, transforms.inset);
}

// Builds an evaluable tone scale using externally supplied Kraken ss/ts values.
// This is useful when a game precomputes the normalization scales CPU-side.
ToneScale BuildToneScale(ToneScaleParameters parameters, float toe_scale, float shoulder_scale) {
  ToneScale tone_scale;
  tone_scale.parameters = parameters;

  const float ev_range = parameters.max_ev - parameters.min_ev;
  tone_scale.inverse_ev_range = 1.f / ev_range;
  tone_scale.minimum_linear = parameters.input_mid_gray * exp2(parameters.min_ev);

  // Normalized-log position of EV 0 (input_mid_gray).
  tone_scale.input_pivot = -parameters.min_ev * tone_scale.inverse_ev_range;

  tone_scale.toe_scale = toe_scale;
  tone_scale.shoulder_scale = shoulder_scale;
  tone_scale.inverse_toe_power = 1.f / parameters.toe_power;
  tone_scale.inverse_shoulder_power = 1.f / parameters.shoulder_power;

  return tone_scale;
}

// input_pivot is expressed in the caller's encoded input domain.
// Compute normalization scales using that pivot before evaluating the sigmoid.
ToneScale BuildToneScale(ToneScaleParameters parameters, float input_pivot) {
  ToneScale tone_scale;
  tone_scale.parameters = parameters;

  const float ev_range = parameters.max_ev - parameters.min_ev;
  tone_scale.inverse_ev_range = 1.f / ev_range;
  tone_scale.minimum_linear = parameters.input_mid_gray * exp2(parameters.min_ev);

  tone_scale.input_pivot = input_pivot;

  tone_scale.inverse_toe_power = 1.f / parameters.toe_power;
  tone_scale.inverse_shoulder_power = 1.f / parameters.shoulder_power;

  const float toe_extent = parameters.slope * tone_scale.input_pivot;
  const float shoulder_extent = parameters.slope * (1.f - tone_scale.input_pivot);

  const float toe_output_range = parameters.output_pivot;
  const float shoulder_output_range = 1.f - parameters.output_pivot;

  const float toe_ratio = toe_extent / toe_output_range;
  const float shoulder_ratio = shoulder_extent / shoulder_output_range;

  // Kraken uses sign-preserving power (spowf) throughout the sigmoid.
  // SignPow preserves that behavior across the full parameter range.
  const float toe_powered = renodx::math::SignPow(toe_ratio, parameters.toe_power);
  const float shoulder_powered = renodx::math::SignPow(shoulder_ratio, parameters.shoulder_power);

  const float toe_normalization = renodx::math::SignPow(toe_powered - 1.f, tone_scale.inverse_toe_power);
  const float shoulder_normalization = renodx::math::SignPow(shoulder_powered - 1.f, tone_scale.inverse_shoulder_power);

  tone_scale.toe_scale = toe_extent / toe_normalization;
  tone_scale.shoulder_scale = shoulder_extent / shoulder_normalization;

  return tone_scale;
}

// Normalized-log convenience overload for Kraken and Blender-AgX.
ToneScale BuildToneScale(ToneScaleParameters parameters) {
  const float ev_range = parameters.max_ev - parameters.min_ev;
  const float inverse_ev_range = 1.f / ev_range;

  return BuildToneScale(parameters, -parameters.min_ev * inverse_ev_range);
}

#define AGX_ENCODE_LOG2_GENERATOR(T)                                                           \
  T EncodeLog2(T value, ToneScale tone_scale) {                                                \
    value = max(value, tone_scale.minimum_linear);                                             \
    const T ev = log2(value / tone_scale.parameters.input_mid_gray);                           \
    const T normalized_ev = (ev - tone_scale.parameters.min_ev) * tone_scale.inverse_ev_range; \
    return saturate(normalized_ev);                                                            \
  }

AGX_ENCODE_LOG2_GENERATOR(float)
AGX_ENCODE_LOG2_GENERATOR(float3)

#undef AGX_ENCODE_LOG2_GENERATOR

#define AGX_DECODE_LOG2_GENERATOR(T)                                                    \
  T DecodeLog2(T value, ToneScale tone_scale) {                                         \
    const float ev_range = tone_scale.parameters.max_ev - tone_scale.parameters.min_ev; \
    const T ev = value * ev_range + tone_scale.parameters.min_ev;                       \
    return tone_scale.parameters.input_mid_gray * exp2(ev);                             \
  }

AGX_DECODE_LOG2_GENERATOR(float)
AGX_DECODE_LOG2_GENERATOR(float3)

#undef AGX_DECODE_LOG2_GENERATOR

float ApplySigmoid(float value, ToneScale tone_scale) {
  const ToneScaleParameters parameters = tone_scale.parameters;

  const bool use_shoulder = value >= tone_scale.input_pivot;
  const float distance = abs(value - tone_scale.input_pivot);

  const float power = renodx::math::Select(use_shoulder, parameters.shoulder_power, parameters.toe_power);

  const float scale = renodx::math::Select(use_shoulder, tone_scale.shoulder_scale, tone_scale.toe_scale);
  const float inverse_power = renodx::math::Select(use_shoulder, tone_scale.inverse_shoulder_power, tone_scale.inverse_toe_power);

  const float mapped = parameters.slope * distance / scale;
  const float powered = renodx::math::SignPow(mapped, power);
  const float response = renodx::math::SignPow(1.f + powered, inverse_power);

  const float shaped = scale * mapped / response;

  return parameters.output_pivot + renodx::math::Select(use_shoulder, shaped, -shaped);
}

float3 ApplySigmoid(float3 color, ToneScale tone_scale) {
  const ToneScaleParameters parameters = tone_scale.parameters;

  const bool3 use_shoulder = color >= tone_scale.input_pivot;
  const float3 distance = abs(color - tone_scale.input_pivot);

  const float3 power = renodx::math::Select(use_shoulder, parameters.shoulder_power, parameters.toe_power);

  const float3 scale = renodx::math::Select(use_shoulder, tone_scale.shoulder_scale, tone_scale.toe_scale);
  const float3 inverse_power = renodx::math::Select(use_shoulder, tone_scale.inverse_shoulder_power, tone_scale.inverse_toe_power);

  const float3 mapped = parameters.slope * distance / scale;
  const float3 powered = renodx::math::SignPow(mapped, power);
  const float3 response = renodx::math::SignPow(1.f + powered, inverse_power);

  const float3 shaped = scale * mapped / response;

  return parameters.output_pivot + renodx::math::Select(use_shoulder, shaped, -shaped);
}

#define AGX_APPLY_TONE_SCALE_GENERATOR(T)                                     \
  T ApplyToneScale(T value, ToneScale tone_scale) {                           \
    value = EncodeLog2(value, tone_scale);                                    \
    value = ApplySigmoid(value, tone_scale);                                  \
    value = renodx::math::SignPow(value, tone_scale.parameters.output_power); \
    return value;                                                             \
  }                                                                           \
                                                                              \
  T ApplyToneScale(T value, ToneScaleParameters parameters) {                 \
    return ApplyToneScale(value, BuildToneScale(parameters));                 \
  }

AGX_APPLY_TONE_SCALE_GENERATOR(float)
AGX_APPLY_TONE_SCALE_GENERATOR(float3)

#undef AGX_APPLY_TONE_SCALE_GENERATOR

// Full Kraken AgX pipeline for scene-linear RGB:
// input floor + inset -> normalized log2 tone scale -> output power -> outset.
float3 Apply(float3 color, GamutTransforms transforms, ToneScale tone_scale) {
  color = ApplyInset(color, transforms);
  color = ApplyToneScale(color, tone_scale);
  color = mul(transforms.outset, color);
  return color;
}

float3 Apply(float3 color, GamutTransforms transforms, ToneScaleParameters parameters) {
  return Apply(color, transforms, BuildToneScale(parameters));
}

}  // namespace agx
}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_SHADERS_TONEMAP_AGX_HLSL_