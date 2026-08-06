/*
 * SPDX-License-Identifier: MIT
 *
 * Scene-linear tone-map operators adapted to Detroit's configurable HDR
 * range. These functions do not encode PQ; Detroit's native final pass remains
 * the only HDR10 OETF.
 */

#ifndef SRC_DETROITBECOMEHUMAN_TONE_MAPPERS_SLANG_
#define SRC_DETROITBECOMEHUMAN_TONE_MAPPERS_SLANG_

#include "detroit_drt.slang"
#include "khronos_pbr_neutral.slang"

namespace detroit {
namespace tone_map {

float3 AgXCurve(float3 color) {
  // AgX inset/outset matrices and sigmoid approximation, evaluated in linear
  // BT.709. The final 2.2 power returns display-linear values.
  static const float3x3 AGX_INSET_MAT = float3x3(
      0.8424790502f, 0.0784336030f, 0.0792237446f,
      0.0423282422f, 0.8784686327f, 0.0791661292f,
      0.0423756540f, 0.0784336030f, 0.8791429996f);
  static const float3x3 AGX_OUTSET_MAT = float3x3(
      1.1970844422f, -0.0980377041f, -0.0990467381f,
      -0.0528944667f, 1.1518511758f, -0.0989567091f,
      -0.0529685305f, -0.0980377032f, 1.1510062337f);
  static const float AGX_MIN_EV = -12.4739303589f;
  static const float AGX_MAX_EV = 4.0260691643f;

  color = mul(AGX_INSET_MAT, max(color, 0.0f));
  color = clamp(log2(max(color, exp2(AGX_MIN_EV))), AGX_MIN_EV, AGX_MAX_EV);
  color = (color - AGX_MIN_EV) / (AGX_MAX_EV - AGX_MIN_EV);

  const float3 x2 = color * color;
  const float3 x4 = x2 * x2;
  color = 15.5f * x4 * x2
          - 40.14f * x4 * color
          + 31.96f * x4
          - 6.868f * x2 * color
          + 0.4298f * x2
          + 0.1191f * color
          - 0.00232f;
  color = mul(AGX_OUTSET_MAT, max(color, 0.0f));
  return pow(saturate(color), 2.2f);
}

float3 ACESFittedCurve(float3 color) {
  return renodx::tonemap::ACESFittedAP1(max(color, 0.0f));
}

float3 LottesCurve(float3 color) {
  // Timothy Lottes' filmic curve, using the commonly published neutral
  // parameters. Values above its nominal HDR maximum are intentionally
  // bounded before the Detroit HDR adapter.
  static const float A = 1.6f;
  static const float D = 0.977f;
  static const float HDR_MAX = 8.0f;
  static const float MID_IN = 0.18f;
  static const float MID_OUT = 0.267f;
  static const float B =
      (-pow(MID_IN, A) + pow(HDR_MAX, A) * MID_OUT)
      / ((pow(HDR_MAX, A * D) - pow(MID_IN, A * D)) * MID_OUT);
  static const float C =
      (pow(HDR_MAX, A * D) * pow(MID_IN, A)
       - pow(HDR_MAX, A) * pow(MID_IN, A * D) * MID_OUT)
      / ((pow(HDR_MAX, A * D) - pow(MID_IN, A * D)) * MID_OUT);

  color = max(color, 0.0f);
  return saturate(pow(color, A) / (pow(color, A * D) * B + C));
}

float3 HableCurve(float3 color) {
  return saturate(renodx::tonemap::uncharted2::BT709(max(color, 0.0f)));
}

float3 AdaptBoundedCurveToHDR(
    float3 curve,
    float curve_diffuse_white,
    float toe_power,
    float peak_ratio) {
  // All source operators above are normalized display curves. Re-anchor their
  // scene-linear output so 0.18 stays 0.18, 1.0 stays diffuse white, and the
  // bounded shoulder approaches Peak/Game. The upper segment is a monotonic
  // cubic Hermite curve with a flat derivative at display peak.
  curve = saturate(curve);
  peak_ratio = max(peak_ratio, 1.0f);
  const float white = clamp(curve_diffuse_white, 1.0e-4f, 0.9999f);

  const float3 toe_coordinate = saturate(curve / white);
  const float3 toe = pow(toe_coordinate, toe_power);
  if (peak_ratio <= 1.0001f) {
    return toe;
  }

  const float3 shoulder_coordinate =
      saturate((curve - white) / max(1.0f - white, 1.0e-4f));
  const float shoulder_slope = clamp(
      (toe_power / white) * (1.0f - white) / (peak_ratio - 1.0f),
      0.0f,
      3.0f);
  const float3 shoulder =
      shoulder_coordinate * shoulder_coordinate
          * (3.0f - 2.0f * shoulder_coordinate)
      + shoulder_slope * shoulder_coordinate
            * (1.0f - shoulder_coordinate)
            * (1.0f - shoulder_coordinate);
  const float3 highlight = 1.0f + (peak_ratio - 1.0f) * shoulder;
  return lerp(toe, highlight, step(white, curve));
}

float3 ApplyCreativeControls(
    float3 color,
    float peak_ratio,
    float highlight_saturation,
    float blowout,
    float flare) {
  float luminance = max(renodx::color::y::from::BT709(color), 0.0f);
  const float highlight_weight = saturate(
      (luminance - 1.0f) / max(peak_ratio - 1.0f, 1.0e-4f));
  color = lerp(
      luminance,
      color,
      lerp(1.0f, max(highlight_saturation, 0.0f), highlight_weight));

  luminance = max(renodx::color::y::from::BT709(color), 0.0f);
  color = lerp(
      color,
      luminance,
      saturate(blowout) * highlight_weight);
  color += 0.10f * pow(max(flare, 0.0f), 10.0f);
  color = max(color, 0.0f);

  const float max_channel = max(color.r, max(color.g, color.b));
  if (max_channel > peak_ratio) {
    color *= peak_ratio / max(max_channel, 1.0e-6f);
  }
  return color;
}

float3 Apply(
    float3 color,
    float tone_map_type,
    float peak_nits,
    float game_nits,
    float highlight_saturation,
    float blowout,
    float flare) {
  color = max(color, 0.0f);
  if (max(color.r, max(color.g, color.b)) == 0.0f && flare == 0.0f) {
    return 0.0f;
  }
  const float peak_ratio =
      max(peak_nits, max(game_nits, 1.0f)) / max(game_nits, 1.0f);

  float3 curve;
  float curve_diffuse_white;
  float toe_power;

  if (tone_map_type == DETROIT_TONE_MAP_TYPE_AGX) {
    curve = AgXCurve(color);
    curve_diffuse_white = 0.5901592450f;
    toe_power = 1.6944754916f;
  } else if (tone_map_type == DETROIT_TONE_MAP_TYPE_ACES_FITTED) {
    curve = ACESFittedCurve(color);
    curve_diffuse_white = 0.6191154269f;
    toe_power = 0.9695158459f;
  } else if (tone_map_type == DETROIT_TONE_MAP_TYPE_LOTTES) {
    curve = LottesCurve(color);
    curve_diffuse_white = 0.8061527838f;
    toe_power = 1.5518191997f;
  } else if (tone_map_type == DETROIT_TONE_MAP_TYPE_HABLE) {
    curve = HableCurve(color);
    curve_diffuse_white = 0.4625261018f;
    toe_power = 1.1186147858f;
  } else if (tone_map_type == DETROIT_TONE_MAP_TYPE_KHRONOS_PBR) {
    curve = KhronosPBRNeutralCurve(color);
    curve_diffuse_white = 0.8690909091f;
    toe_power = 0.9392011394f;
  } else if (tone_map_type == DETROIT_TONE_MAP_TYPE_PSYCHOV_22) {
    // Match the PsychoV-22 option used by current Cyberpunk 2077 RenoDX. Call
    // the shared analytic implementation directly: it already returns
    // scene-linear display values relative to Game Brightness and uses the
    // selected Peak/Game ratio as its device hull. No Cyberpunk LUT, D3D
    // resource, or PQ pass is imported into Detroit.
    color = renodx::tonemap::psychov::psychotm_test22(
        color,
        peak_ratio);
    return ApplyCreativeControls(
        max(color, 0.0f),
        peak_ratio,
        highlight_saturation,
        blowout,
        flare);
  } else {
    color = DetroitDrt(color, peak_ratio, 0.0f);
    return ApplyCreativeControls(
        max(color, 0.0f),
        peak_ratio,
        highlight_saturation,
        blowout,
        flare);
  }

  color = AdaptBoundedCurveToHDR(
      curve,
      curve_diffuse_white,
      toe_power,
      peak_ratio);
  return ApplyCreativeControls(
      color,
      peak_ratio,
      highlight_saturation,
      blowout,
      flare);
}

}  // namespace tone_map
}  // namespace detroit

#endif  // SRC_DETROITBECOMEHUMAN_TONE_MAPPERS_SLANG_
