/*
 * Copyright (C) 2026 Carlos Lopez
 * Modifications Copyright (C) 2026 Musa Haji (GitHub: mqhaji)
 * SPDX-License-Identifier: MIT
 *
 * Compiler-generated GLSL from maxpayne3/customtest31.hlsli and its dependencies.
 * Locally extended with a finite C-infinity white clip; regeneration must preserve this extension.
 * All public parameters are explicit (GLSL does not support default arguments).
 * Used by the RDR2 PsychoV tonemap path.
 */
#ifndef SRC_GAMES_RDR2_CUSTOMTEST31_GLSL_
#define SRC_GAMES_RDR2_CUSTOMTEST31_GLSL_
#extension GL_EXT_control_flow_attributes : require

#include "./tonemap/c_infinity_rolloff.glsl"

float rdr2_test31_renodx_math_Select_0(bool condition_0, float trueValue_0, float falseValue_0) {
  if (condition_0) {
    return trueValue_0;
  } else {
    return falseValue_0;
  }
}

float rdr2_test31_renodx_math_DivideSafe_0(float dividend_0, float divisor_0, float fallback_0) {
  return rdr2_test31_renodx_math_Select_0(divisor_0 == 0.0, fallback_0, dividend_0 / divisor_0);
}

mat3x3 rdr2_test31_renodx_math_Invert3x3_0(mat3x3 m_0) {
  float A_0 = m_0[1][1] * m_0[2][2] - m_0[1][2] * m_0[2][1];
  float B_0 = -(m_0[1][0] * m_0[2][2] - m_0[1][2] * m_0[2][0]);
  float C_0 = m_0[1][0] * m_0[2][1] - m_0[1][1] * m_0[2][0];
  return mat3x3(A_0, -(m_0[0][1] * m_0[2][2] - m_0[0][2] * m_0[2][1]), m_0[0][1] * m_0[1][2] - m_0[0][2] * m_0[1][1], B_0, m_0[0][0] * m_0[2][2] - m_0[0][2] * m_0[2][0], -(m_0[0][0] * m_0[1][2] - m_0[0][2] * m_0[1][0]), C_0, -(m_0[0][0] * m_0[2][1] - m_0[0][1] * m_0[2][0]), m_0[0][0] * m_0[1][1] - m_0[0][1] * m_0[1][0]) * rdr2_test31_renodx_math_DivideSafe_0(1.0, m_0[0][0] * A_0 + m_0[0][1] * B_0 + m_0[0][2] * C_0, 0.0);
}

float rdr2_test31_rcp_0(float x_0) {
  return 1.0 / x_0;
}

float rdr2_test31_saturate_0(float x_1) {
  return clamp(x_1, 0.0, 1.0);
}

vec3 rdr2_test31_rcp_1(vec3 x_2) {
  return 1.0 / x_2;
}

vec3 rdr2_test31_saturate_1(vec3 x_3) {
  return clamp(x_3, vec3(0.0), vec3(1.0));
}

float rdr2_test31_renodx_math_Min_0(float x_4, float y_0) {
  return min(x_4, y_0);
}

float rdr2_test31_renodx_math_Min_1(float x_5, float y_1, float z_0) {
  return rdr2_test31_renodx_math_Min_0(x_5, rdr2_test31_renodx_math_Min_0(y_1, z_0));
}

float rdr2_test31_renodx_math_Min_2(vec3 xyz_0) {
  return rdr2_test31_renodx_math_Min_1(xyz_0.x, xyz_0.y, xyz_0.z);
}

vec3 rdr2_test31_renodx_color_xfyfzf_from_LMS_0(vec3 lms_0) {
  return (((lms_0) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311))));
}

float rdr2_test31_renodx_color_yf_from_LMS_0(vec3 lms_1) {
  return rdr2_test31_renodx_color_xfyfzf_from_LMS_0(lms_1).y;
}

vec3 rdr2_test31_renodx_tonemap_psychov_custom_psycho31_AnchorSourceBoundaryToYf_0(vec3 source_rgb_0, mat3x3 source_to_lms_0, vec3 source_yf_weights_0, out vec3 anchored_source_rgb_0) {
  anchored_source_rgb_0 = source_rgb_0;
  if ((all(bvec3((greaterThanEqual(source_rgb_0, vec3(0.0))))))) {
    return (((source_rgb_0) * (source_to_lms_0)));
  }
  const vec3 _S1 = vec3(0.0);
  float source_total_0 = dot(max(source_rgb_0, _S1), source_yf_weights_0);
  if (source_total_0 <= 0.0) {
    anchored_source_rgb_0 = _S1;
    return _S1;
  }
  vec3 _S2 = source_total_0 + (source_rgb_0 - source_total_0) * (source_total_0 / (source_total_0 - rdr2_test31_renodx_math_Min_2(source_rgb_0)));
  vec3 bounded_lms_0 = (((_S2) * (source_to_lms_0)));
  float scale_0 = source_total_0 * rdr2_test31_renodx_color_yf_from_LMS_0((((vec3(1.0)) * (source_to_lms_0)))) / rdr2_test31_renodx_color_yf_from_LMS_0(bounded_lms_0);
  anchored_source_rgb_0 = _S2 * scale_0;
  return bounded_lms_0 * scale_0;
}

vec3 rdr2_test31_renodx_math_Select_1(bvec3 condition_1, vec3 trueValue_1, vec3 falseValue_1) {
  vec3 result_0;
  int i_0 = 0;
  [[unroll]]
  for (;;) {
    if (i_0 < 3) {
    } else {
      break;
    }
    if (condition_1[i_0]) {
      result_0[i_0] = trueValue_1[i_0];
    } else {
      result_0[i_0] = falseValue_1[i_0];
    }
    i_0 = i_0 + 1;
  }
  return result_0;
}

vec3 rdr2_test31_renodx_math_CopySign_0(vec3 mag_0, vec3 sgn_0) {
  vec3 abs_value_0 = abs(mag_0);
  return rdr2_test31_renodx_math_Select_1(lessThan(sgn_0, vec3(0.0)), -abs_value_0, abs_value_0);
}

vec3 rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_0(vec3 position_0) {
  vec3 _S3 = rdr2_test31_saturate_1(position_0);
  return rdr2_test31_rcp_1(1.0 + (exp2(((1.0 - 2.0 * _S3) / (_S3 * (1.0 - _S3))))));
}

vec3 rdr2_test31_renodx_tonemap_psychov_custom_psycho31_ApplyAnchoredTonalGrading_0(vec3 color_0, vec3 anchor_in_0, vec3 anchor_out_0, float contrast_0, float flare_0, float highlight_contrast_0, float shadow_contrast_0, float highlights_0, float shadows_0) {
  bool _S4;
  if (contrast_0 == 1.0) {
    _S4 = flare_0 == 0.0;
  } else {
    _S4 = false;
  }
  if (_S4) {
    _S4 = highlight_contrast_0 == 1.0;
  } else {
    _S4 = false;
  }
  if (_S4) {
    _S4 = shadow_contrast_0 == 1.0;
  } else {
    _S4 = false;
  }
  if (_S4) {
    _S4 = highlights_0 == 1.0;
  } else {
    _S4 = false;
  }
  if (_S4) {
    _S4 = shadows_0 == 1.0;
  } else {
    _S4 = false;
  }
  if (_S4) {
    _S4 = (all(bvec3((equal(anchor_in_0, anchor_out_0)))));
  } else {
    _S4 = false;
  }
  if (_S4) {
    return color_0;
  }
  vec3 normalized_0 = color_0 / anchor_in_0;
  bool _S5 = contrast_0 != 1.0;
  if (_S5) {
    _S4 = true;
  } else {
    _S4 = flare_0 > 0.0;
  }
  vec3 graded_normalized_0;
  vec3 tonal_displacement_0;
  if (_S4) {
    vec3 exponent_0 = vec3(contrast_0);
    if (flare_0 > 0.0) {
      graded_normalized_0 = exponent_0 * fma((exp2((-normalized_0 / rdr2_test31_saturate_1(1.0 - normalized_0)))), flare_0 / (normalized_0 + flare_0), vec3(1.0));
    } else {
      graded_normalized_0 = exponent_0;
    }
    vec3 input_stops_0 = log2(normalized_0);
    const vec3 _S6 = vec3(0.0);
    vec3 highlight_stops_0 = max(input_stops_0, _S6);
    if (_S5) {
      vec3 displacement_0 = (contrast_0 - 1.0) * highlight_stops_0;
      vec3 displacement_magnitude_0 = abs(displacement_0);
      tonal_displacement_0 = highlight_stops_0 + displacement_0 / fma(displacement_magnitude_0, (exp2((-1.0 / displacement_magnitude_0))), vec3(1.0));
    } else {
      tonal_displacement_0 = highlight_stops_0;
    }
    graded_normalized_0 = (exp2((fma(graded_normalized_0, min(input_stops_0, _S6), tonal_displacement_0))));
  } else {
    graded_normalized_0 = normalized_0;
  }
  if (highlight_contrast_0 != 1.0) {
    vec3 distance_0 = max(graded_normalized_0 - 1.0, vec3(0.0));
    vec3 distance_squared_0 = distance_0 * distance_0;
    graded_normalized_0 = graded_normalized_0 + distance_0 * (pow(1.0 + (1.0 + distance_squared_0) * (exp2((-1.0 / distance_squared_0))), vec3(0.5 * (highlight_contrast_0 - 1.0))) - 1.0);
  }
  if (shadow_contrast_0 != 1.0) {
    vec3 distance_1 = rdr2_test31_saturate_1(1.0 - graded_normalized_0);
    vec3 distance_squared_1 = distance_1 * distance_1;
    graded_normalized_0 = graded_normalized_0 * pow(1.0 + distance_squared_1 * distance_1 * (exp2((1.0 - 1.0 / distance_squared_1))), vec3(1.0 - shadow_contrast_0));
  }
  bool _S7 = highlights_0 != 1.0;
  if (_S7) {
    _S4 = true;
  } else {
    _S4 = shadows_0 != 1.0;
  }
  if (_S4) {
    vec3 tonal_stops_0 = log2(graded_normalized_0);
    const vec3 tonal_displacement_1 = vec3(0.0);
    if (_S7) {
      float adjustment_0 = highlights_0 - 1.0;
      tonal_displacement_0 = fma(vec3(adjustment_0 * fma(1.5, abs(adjustment_0), 0.5)), rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_0((tonal_stops_0 - 1.0) * 0.1428571492433548), tonal_displacement_1);
    } else {
      tonal_displacement_0 = tonal_displacement_1;
    }
    if (shadows_0 != 1.0) {
      float adjustment_1 = shadows_0 - 1.0;
      tonal_displacement_0 = fma(vec3(adjustment_1 * fma(1.5, abs(adjustment_1), 0.5)), rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_0((-1.0 - tonal_stops_0) * 0.1428571492433548), tonal_displacement_0);
    }
    graded_normalized_0 = graded_normalized_0 * (exp2((tonal_displacement_0)));
  }
  return graded_normalized_0 * anchor_out_0;
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho30_ApplyAdaptiveRelativePurity_0(vec3 source_lms_0, vec3 anchor_lms_0, float purity_delta_0) {
  vec3 source_q_0 = source_lms_0 / anchor_lms_0;
  if (purity_delta_0 == 1.0) {
    return source_q_0;
  }
  return mix(vec3(rdr2_test31_renodx_color_yf_from_LMS_0(source_lms_0) / rdr2_test31_renodx_color_yf_from_LMS_0(anchor_lms_0)), source_q_0, vec3(purity_delta_0));
}

vec3 rdr2_test31_renodx_tonemap_psychov_custom_psycho31_GradeLMS_0(vec3 grading_source_lms_0, vec3 anchor_in_lms_0, vec3 anchor_out_lms_0, float highlights_1, float shadows_1, float contrast_1, float flare_1, float highlight_contrast_1, float shadow_contrast_1, float purity_scale_0, float highlight_saturation_0, float dechroma_0, float sdr_eotf_emulation_0, out vec3 tonal_input_lms_0, bool signed_response_0) {
  tonal_input_lms_0 = grading_source_lms_0;
  bool _S8 = !signed_response_0;
  if (_S8) {
    tonal_input_lms_0 = max(tonal_input_lms_0, vec3(0.0));
  }
  if (sdr_eotf_emulation_0 != 0.0) {
    vec3 magnitude_0 = abs(tonal_input_lms_0 / (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))));
    tonal_input_lms_0 = rdr2_test31_renodx_math_CopySign_0(pow(rdr2_test31_renodx_math_Select_1(lessThanEqual(magnitude_0, vec3(0.00313066854141653)), 12.92000007629394531 * magnitude_0, 1.0549999475479126 * pow(magnitude_0, vec3(0.4166666567325592)) - 0.05499999970197678), vec3(2.20000004768371582)) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))), tonal_input_lms_0);
  }
  vec3 pre_shoulder_lms_0;
  if (signed_response_0) {
    pre_shoulder_lms_0 = abs(tonal_input_lms_0);
  } else {
    pre_shoulder_lms_0 = tonal_input_lms_0;
  }
  vec3 graded_lms_0 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_ApplyAnchoredTonalGrading_0(pre_shoulder_lms_0, anchor_in_lms_0, anchor_out_lms_0, contrast_1, flare_1, highlight_contrast_1, shadow_contrast_1, highlights_1, shadows_1);
  if (signed_response_0) {
    pre_shoulder_lms_0 = rdr2_test31_renodx_math_CopySign_0(graded_lms_0, tonal_input_lms_0);
  } else {
    pre_shoulder_lms_0 = graded_lms_0;
  }
  bool _S9;
  if (purity_scale_0 != 1.0) {
    _S9 = true;
  } else {
    _S9 = highlight_saturation_0 != 1.0;
  }
  if (_S9) {
    _S9 = true;
  } else {
    _S9 = dechroma_0 != 0.0;
  }
  if (_S9) {
    bool _S10 = dechroma_0 != 0.0;
    if (_S10) {
      _S9 = true;
    } else {
      _S9 = highlight_saturation_0 != 1.0;
    }
    float effective_purity_scale_0;
    if (_S9) {
      float rolloff_position_0 = rdr2_test31_saturate_0(log2(max(max(rdr2_test31_renodx_color_yf_from_LMS_0(pre_shoulder_lms_0 / anchor_out_lms_0) / rdr2_test31_renodx_color_yf_from_LMS_0(vec3(1.0)), 0.0), 1.0)) * (1.0 / (2.75 * log2(10.0))));
      float rolloff_0 = rolloff_position_0 * rolloff_position_0 * rolloff_position_0 * fma(rolloff_position_0, fma(6.0, rolloff_position_0, -15.0), 10.0);
      if (_S10) {
        effective_purity_scale_0 = purity_scale_0 * fma(-dechroma_0, rolloff_0, 1.0);
      } else {
        effective_purity_scale_0 = purity_scale_0;
      }
      if (highlight_saturation_0 != 1.0) {
        effective_purity_scale_0 = effective_purity_scale_0 * fma(highlight_saturation_0 - 1.0, rolloff_0 * rolloff_0 * fma(0.5, rolloff_0, 0.5) * 0.66666668653488159, 1.0);
      }
    } else {
      effective_purity_scale_0 = purity_scale_0;
    }
    pre_shoulder_lms_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_ApplyAdaptiveRelativePurity_0(pre_shoulder_lms_0, anchor_out_lms_0, effective_purity_scale_0) * anchor_out_lms_0;
  }
  if (_S8) {
    pre_shoulder_lms_0 = max(pre_shoulder_lms_0, vec3(0.0));
  }
  return pre_shoulder_lms_0;
}

vec3 rdr2_test31_renodx_tonemap_psychov_custom_psycho31_ApplyAnchoredCInfinityShoulder_0(vec3 color_1, vec3 peak_0, vec3 anchor_0, vec2 compression_strength_0) {
  return CInfinityRollOff(color_1, peak_0, anchor_0, compression_strength_0.x, peak_0 * compression_strength_0.y);
}

float rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_1(float position_1) {
  if (position_1 <= 0.0) {
    return 0.0;
  }
  if (position_1 >= 1.0) {
    return 1.0;
  }
  return rdr2_test31_rcp_0(1.0 + (exp2(((1.0 - 2.0 * position_1) / (position_1 * (1.0 - position_1))))));
}

float rdr2_test31_renodx_tonemap_psychov_custom_psycho31_ShoulderMeanA2Weight_0(vec3 source_q_1, vec3 graded_lms_1, vec3 response_lms_0, float mean_a2_shadow_source_weight_0, float mean_a2_midgray_source_weight_0, float mean_a2_highlight_source_weight_0) {
  float _S11 = max(mean_a2_shadow_source_weight_0, 0.0);
  float _S12 = max(mean_a2_midgray_source_weight_0, 0.0);
  float _S13 = max(mean_a2_highlight_source_weight_0, 0.0);
  bool _S14 = _S11 == _S12;
  bool _S15;
  if (_S14) {
    _S15 = _S12 == _S13;
  } else {
    _S15 = false;
  }
  if (_S15) {
    return _S12;
  }
  float source_level_0 = rdr2_test31_renodx_color_yf_from_LMS_0((((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))) * source_q_1) / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))));
  if (source_level_0 <= 1.0) {
    if (_S14) {
      return _S11;
    }
    if (source_level_0 <= 0.5) {
      return _S11;
    }
    if (source_level_0 == 1.0) {
      return _S12;
    }
    return mix(_S11, _S12, rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_1(1.0 + log2(source_level_0)));
  }
  if (_S12 == _S13) {
    return _S12;
  }
  float graded_yf_0 = rdr2_test31_renodx_color_yf_from_LMS_0(graded_lms_1);
  float response_yf_0 = rdr2_test31_renodx_color_yf_from_LMS_0(response_lms_0);
  if (!(graded_yf_0 > 0.0)) {
    _S15 = true;
  } else {
    _S15 = isnan(graded_yf_0);
  }
  if (_S15) {
    _S15 = true;
  } else {
    _S15 = isinf(graded_yf_0);
  }
  if (_S15) {
    _S15 = true;
  } else {
    _S15 = isnan(response_yf_0);
  }
  if (_S15) {
    _S15 = true;
  } else {
    _S15 = isinf(response_yf_0);
  }
  if (_S15) {
    return _S12;
  }
  float shoulder_loss_0 = rdr2_test31_saturate_0(1.0 - response_yf_0 / graded_yf_0);
  if (shoulder_loss_0 <= 0.0) {
    return _S12;
  }
  float _S16;
  if (source_level_0 >= 2.0) {
    _S16 = 1.0;
  } else {
    _S16 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_1(log2(source_level_0));
  }
  return mix(_S12, _S13, _S16 * rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_1(shoulder_loss_0 / 0.5));
}

void rdr2_test31_renodx_tonemap_psychov_custom_psycho31_ResponseState_0(vec3 source_lms_1, vec3 anchor_in_lms_1, vec3 anchor_out_lms_1, vec3 target_peak_lms_0, float highlights_2, float shadows_2, float contrast_2, float flare_2, float highlight_contrast_2, float shadow_contrast_2, float purity_scale_1, float highlight_saturation_1, float dechroma_1, float sdr_eotf_emulation_1, vec2 compression_0, float mean_a2_shadow_source_weight_1, float mean_a2_midgray_source_weight_1, float mean_a2_highlight_source_weight_1, out vec3 source_q_2, out vec3 response_u_0, out float effective_mean_a2_weight_0) {
  vec3 tonal_input_lms_1;
  vec3 pre_shoulder_lms_1 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_GradeLMS_0(source_lms_1, anchor_in_lms_1, anchor_out_lms_1, highlights_2, shadows_2, contrast_2, flare_2, highlight_contrast_2, shadow_contrast_2, purity_scale_1, highlight_saturation_1, dechroma_1, sdr_eotf_emulation_1, tonal_input_lms_1, true);
  vec3 graded_lms_2 = abs(pre_shoulder_lms_1);
  vec3 response_lms_1 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_ApplyAnchoredCInfinityShoulder_0(graded_lms_2, target_peak_lms_0, anchor_out_lms_1, compression_0);
  source_q_2 = source_lms_1 / anchor_in_lms_1;
  vec3 tonal_input_q_0 = tonal_input_lms_1 / anchor_in_lms_1;
  response_u_0 = rdr2_test31_renodx_math_CopySign_0(response_lms_1, pre_shoulder_lms_1) / target_peak_lms_0;
  effective_mean_a2_weight_0 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_ShoulderMeanA2Weight_0(abs(tonal_input_q_0), graded_lms_2, response_lms_1, mean_a2_shadow_source_weight_1, mean_a2_midgray_source_weight_1, mean_a2_highlight_source_weight_1);
  return;
}

vec2 rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2FromQ_0(vec3 q_0) {
  float _S17 = q_0.x;
  float _S18 = q_0.y;
  return vec2(_S17 - _S18, 2.0 * q_0.z - _S17 - _S18);
}

float rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2Radius6_0(vec2 dt_0) {
  float _S19 = dt_0.x;
  float _S20 = dt_0.y;
  return 3.0 * _S19 * _S19 + _S20 * _S20;
}

float rdr2_test31_renodx_math_Max_0(float x_6, float y_2) {
  return max(x_6, y_2);
}

float rdr2_test31_renodx_math_Max_1(float x_7, float y_3, float z_1) {
  return rdr2_test31_renodx_math_Max_0(x_7, rdr2_test31_renodx_math_Max_0(y_3, z_1));
}

float rdr2_test31_renodx_math_Max_2(vec3 xyz_1) {
  return rdr2_test31_renodx_math_Max_1(xyz_1.x, xyz_1.y, xyz_1.z);
}

vec3 rdr2_test31_renodx_tonemap_psychov_custom_psycho31_MeanA2Response_0(vec3 source_q_3, vec3 response_u_1, float effective_mean_a2_weight_1, out float response_yf_1, out uint valid_0) {
  bool _S21;
  if (!(any(bvec3((isnan(source_q_3)))))) {
    _S21 = !(any(bvec3((isinf(source_q_3)))));
  } else {
    _S21 = false;
  }
  if (_S21) {
    _S21 = !(any(bvec3((isnan(response_u_1)))));
  } else {
    _S21 = false;
  }
  if (_S21) {
    _S21 = !(any(bvec3((isinf(response_u_1)))));
  } else {
    _S21 = false;
  }
  uint _S22;
  if (_S21) {
    _S22 = 1U;
  } else {
    _S22 = 0U;
  }
  valid_0 = _S22;
  if (_S22 == 0U) {
    response_yf_1 = 0.0;
    return vec3(0.0);
  }
  vec2 source_dt_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2FromQ_0(source_q_3);
  vec2 response_dt_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2FromQ_0(response_u_1);
  float source_radius6_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2Radius6_0(source_dt_0);
  float response_radius6_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2Radius6_0(response_dt_0);
  float source_confidence_0 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_1((sqrt(source_radius6_0 / 6.0) / max(1.0, rdr2_test31_renodx_math_Max_2(abs(source_q_3))) - 9.99999997475242708e-07) / 7.00000009601353668e-06);
  if (source_confidence_0 > 0.0) {
    _S21 = response_radius6_0 > 0.0;
  } else {
    _S21 = false;
  }
  vec2 authored_dt_0;
  if (_S21) {
    float inverse_response_radius_0 = (inversesqrt((response_radius6_0)));
    float response_radius_0 = response_radius6_0 * inverse_response_radius_0;
    float _S23 = effective_mean_a2_weight_1 * source_confidence_0;
    float _S24 = (inversesqrt((source_radius6_0)));
    vec2 _S25 = response_dt_0 * inverse_response_radius_0;
    vec2 mean_direction_0 = source_dt_0 * (_S24 * _S23) + _S25;
    float mean_radius6_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2Radius6_0(mean_direction_0);
    float angular_confidence_0 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_1((mean_radius6_0 - 0.0000152587890625) / 0.0002288818359375);
    float mean_radius6_1;
    if (angular_confidence_0 < 1.0) {
      vec2 mean_direction_1 = source_dt_0 * (_S24 * (_S23 * angular_confidence_0)) + _S25;
      float _S26 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2Radius6_0(mean_direction_1);
      authored_dt_0 = mean_direction_1;
      mean_radius6_1 = _S26;
    } else {
      authored_dt_0 = mean_direction_0;
      mean_radius6_1 = mean_radius6_0;
    }
    authored_dt_0 = authored_dt_0 * (response_radius_0 * (inversesqrt((mean_radius6_1))));
  } else {
    authored_dt_0 = response_dt_0;
  }
  float _S27 = response_u_1.x;
  float _S28 = response_u_1.y;
  response_yf_1 = mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * _S27 + mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * _S28;
  return vec3(authored_dt_0.x, _S27 + _S28 + response_u_1.z, authored_dt_0.y);
}

vec3 rdr2_test31_renodx_tonemap_psychov_custom_psycho31_ResponseCoord_0(vec3 source_lms_2, vec3 anchor_in_lms_2, vec3 anchor_out_lms_2, vec3 target_peak_lms_1, float highlights_3, float shadows_3, float contrast_3, float flare_3, float highlight_contrast_3, float shadow_contrast_3, float purity_scale_2, float highlight_saturation_2, float dechroma_2, float sdr_eotf_emulation_2, vec2 compression_1, float mean_a2_shadow_source_weight_2, float mean_a2_midgray_source_weight_2, float mean_a2_highlight_source_weight_2, out vec3 source_q_4, out float response_yf_2, out uint valid_1) {
  vec3 response_u_2;
  float effective_mean_a2_weight_2;
  rdr2_test31_renodx_tonemap_psychov_custom_psycho31_ResponseState_0(source_lms_2, anchor_in_lms_2, anchor_out_lms_2, target_peak_lms_1, highlights_3, shadows_3, contrast_3, flare_3, highlight_contrast_3, shadow_contrast_3, purity_scale_2, highlight_saturation_2, dechroma_2, sdr_eotf_emulation_2, compression_1, mean_a2_shadow_source_weight_2, mean_a2_midgray_source_weight_2, mean_a2_highlight_source_weight_2, source_q_4, response_u_2, effective_mean_a2_weight_2);
  vec3 _S29 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_MeanA2Response_0(source_q_4, response_u_2, effective_mean_a2_weight_2, response_yf_2, valid_1);
  return _S29;
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho31_LMSFromTest30Coord_0(vec3 coord_0, float peak_value_0) {
  float _S30 = coord_0.x;
  float _S31 = coord_0.z;
  return (((peak_value_0 * ((2.0 * coord_0.y + 3.0 * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) - mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * _S30 - _S31) / 6.0 + _S30 * (((vec3(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x, -(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y, -0.5 * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) - mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297))))))) + _S31 * (((vec3(0.0, 0.0, 0.5 * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297))))))))) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))));
}

float rdr2_test31_renodx_tonemap_psychov_psycho31_YfFromTest30Coord_0(vec3 coord_1) {
  return (2.0 * coord_1.y + 3.0 * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) - mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * coord_1.x - coord_1.z) / 6.0;
}

float rdr2_test31_renodx_tonemap_psychov_custom_psycho31_NormalizedL8TargetDemand_0(vec3 coord_2, float response_yf_ceiling_0, int target_gamut_mode_0) {
  float mapped_a_0 = clamp(rdr2_test31_renodx_tonemap_psychov_psycho31_YfFromTest30Coord_0(coord_2), 0.0, clamp(response_yf_ceiling_0, 0.0, 1.0));
  float _S32 = coord_2.x;
  float _S33 = coord_2.z;
  float radial_length_0 = sqrt(0.5 * _S32 * _S32 + _S33 * _S33 / 6.0);
  bool _S34;
  if (mapped_a_0 <= 0.0) {
    _S34 = true;
  } else {
    _S34 = mapped_a_0 >= 1.0;
  }
  if (_S34) {
    _S34 = true;
  } else {
    _S34 = radial_length_0 == 0.0;
  }
  if (_S34) {
    return 0.0;
  }
  float inverse_radial_length_0 = rdr2_test31_rcp_0(radial_length_0);
  float normalized_d_0 = _S32 * inverse_radial_length_0;
  float normalized_t_0 = _S33 * inverse_radial_length_0;
  vec3 radial_rgb_0;
  if (target_gamut_mode_0 == 0) {
    radial_rgb_0 = normalized_d_0 * (((vec3(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x, -(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y, -0.5 * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) - mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297))))))) + normalized_t_0 * (((vec3(0.0, 0.0, 0.5 * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297)))))));
  } else {
    if (target_gamut_mode_0 == 3) {
      radial_rgb_0 = normalized_d_0 * (((vec3(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x, -(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y, -0.5 * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) - mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(2.49349689483642578, -0.93138360977172852, -0.40271079540252686, -0.82948899269104004, 1.7626640796661377, 0.02362468652427197, 0.03584583103656769, -0.07617238909006119, 0.95688450336456299))))))) + normalized_t_0 * (((vec3(0.0, 0.0, 0.5 * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(2.49349689483642578, -0.93138360977172852, -0.40271079540252686, -0.82948899269104004, 1.7626640796661377, 0.02362468652427197, 0.03584583103656769, -0.07617238909006119, 0.95688450336456299)))))));
    } else {
      if (target_gamut_mode_0 == 4) {
        radial_rgb_0 = normalized_d_0 * (((vec3(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x, -(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y, -0.5 * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) - mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(2.12806034088134766, -0.64282751083374023, -0.34874185919761658, -0.75490963459014893, 1.67645835876464844, 0.03769309818744659, 0.01452613156288862, -0.05973323062062263, 0.96039605140686035))))))) + normalized_t_0 * (((vec3(0.0, 0.0, 0.5 * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(2.12806034088134766, -0.64282751083374023, -0.34874185919761658, -0.75490963459014893, 1.67645835876464844, 0.03769309818744659, 0.01452613156288862, -0.05973323062062263, 0.96039605140686035)))))));
      } else {
        radial_rgb_0 = normalized_d_0 * (((vec3(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x, -(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y, -0.5 * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) - mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(1.71665120124816895, -0.35567077994346619, -0.25336629152297974, -0.66668432950973511, 1.61648118495941162, 0.01576854661107063, 0.01763985678553581, -0.04277061298489571, 0.94210314750671387))))))) + normalized_t_0 * (((vec3(0.0, 0.0, 0.5 * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(1.71665120124816895, -0.35567077994346619, -0.25336629152297974, -0.66668432950973511, 1.61648118495941162, 0.01576854661107063, 0.01763985678553581, -0.04277061298489571, 0.94210314750671387)))))));
      }
    }
  }
  const vec3 _S35 = vec3(0.0);
  vec3 upper_demand_0 = max(radial_rgb_0, _S35) / (1.0 - mapped_a_0);
  vec3 lower_demand_0 = max(-radial_rgb_0, _S35) / mapped_a_0;
  float _S36 = max(rdr2_test31_renodx_math_Max_2(upper_demand_0), rdr2_test31_renodx_math_Max_2(lower_demand_0));
  if (_S36 == 0.0) {
    return 0.0;
  }
  vec3 normalized_demand_rgb_0 = (upper_demand_0 + lower_demand_0) / _S36;
  vec3 normalized_demand_rgb_1 = normalized_demand_rgb_0 * normalized_demand_rgb_0;
  vec3 normalized_demand_rgb_2 = normalized_demand_rgb_1 * normalized_demand_rgb_1;
  return radial_length_0 / rdr2_test31_rcp_0(_S36 * sqrt(sqrt(sqrt(dot(normalized_demand_rgb_2, normalized_demand_rgb_2)))));
}

float rdr2_test31_renodx_tonemap_psychov_custom_psycho31_SmoothMax3_0(vec3 values_0) {
  return log2((exp2((4.0 * values_0.x))) + (exp2((4.0 * values_0.y))) + (exp2((4.0 * values_0.z)))) / 4.0;
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho31_Test30CoordFromDTA_0(float d_0, float t_0, float a_0) {
  return vec3(d_0, 3.0 * a_0 - 1.5 * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) - mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * d_0 + 0.5 * t_0, t_0);
}

float rdr2_test31_renodx_tonemap_psychov_custom_psycho31_SmoothUnitLimit_0(float value_0, float sharpness_0) {
  float zero_offset_0 = 1.0 - log2(1.0 + (exp2((sharpness_0)))) / sharpness_0;
  bool _S37 = value_0 >= 0.00100000004749745;
  float near_zero_0;
  if (!_S37) {
    float origin_slope_0 = rdr2_test31_rcp_0(1.0 + (exp2((-sharpness_0))));
    float near_zero_1 = value_0 * origin_slope_0 * (1.0 - 0.5 * sharpness_0 * log(2.0) * (1.0 - origin_slope_0) * value_0) / (1.0 - zero_offset_0);
    if (value_0 <= 0.00009999999747379) {
      return near_zero_1;
    }
    near_zero_0 = near_zero_1;
  } else {
    near_zero_0 = 0.0;
  }
  float limited_0 = 1.0 - log2(1.0 + (exp2((sharpness_0 * (1.0 - value_0))))) / sharpness_0;
  if (_S37) {
    return (limited_0 - zero_offset_0) / (1.0 - zero_offset_0);
  }
  return mix(near_zero_0, (limited_0 - zero_offset_0) / (1.0 - zero_offset_0), rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_1((value_0 - 0.00009999999747379) / 0.00089999998454005));
}

vec3 rdr2_test31_renodx_tonemap_psychov_custom_psycho31_MapL8TargetDemand_0(vec3 coord_3, float response_yf_ceiling_1, int target_gamut_mode_1, float normalized_demand_0) {
  float mapped_a_1 = clamp(rdr2_test31_renodx_tonemap_psychov_psycho31_YfFromTest30Coord_0(coord_3), 0.0, clamp(response_yf_ceiling_1, 0.0, 1.0));
  if (!(normalized_demand_0 > 0.0)) {
    return rdr2_test31_renodx_tonemap_psychov_psycho31_Test30CoordFromDTA_0(0.0, 0.0, mapped_a_1);
  }
  float radial_scale_0 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_SmoothUnitLimit_0(normalized_demand_0, 16.0) / normalized_demand_0;
  return rdr2_test31_renodx_tonemap_psychov_psycho31_Test30CoordFromDTA_0(coord_3.x * radial_scale_0, coord_3.z * radial_scale_0, mapped_a_1);
}

vec3 rdr2_test31_renodx_tonemap_psychov_custom_psycho31_SmoothFixedYfL8TargetEndpoint_0(vec3 coord_4, float response_yf_ceiling_2, int target_gamut_mode_2, out float normalized_demand_1) {
  float _S38 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_NormalizedL8TargetDemand_0(coord_4, response_yf_ceiling_2, target_gamut_mode_2);
  normalized_demand_1 = _S38;
  return rdr2_test31_renodx_tonemap_psychov_custom_psycho31_MapL8TargetDemand_0(coord_4, response_yf_ceiling_2, target_gamut_mode_2, _S38);
}

vec3 rdr2_test31_renodx_tonemap_psychov_custom_psycho31_TargetEndpoint_0(vec3 coord_5, float response_yf_ceiling_3, int target_gamut_mode_3, out uint valid_2) {
  float unused_normalized_demand_0;
  vec3 solved_coord_0 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_SmoothFixedYfL8TargetEndpoint_0(coord_5, response_yf_ceiling_3, target_gamut_mode_3, unused_normalized_demand_0);
  valid_2 = 0U;
  if ((any(bvec3((isnan(solved_coord_0)))))) {
    return vec3(0.0);
  }
  uint _S39;
  if (!(any(bvec3((isinf(solved_coord_0)))))) {
    _S39 = 1U;
  } else {
    _S39 = 0U;
  }
  valid_2 = _S39;
  vec3 _S40;
  if (_S39 != 0U) {
    _S40 = solved_coord_0;
  } else {
    _S40 = vec3(0.0);
  }
  return _S40;
}

float rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityClamp01_0(float value_1) {
  float _S41 = 1.0 - value_1 * rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_1(value_1 / 0.05000000074505806);
  return 1.0 - _S41 * rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_1(_S41 / 0.05000000074505806);
}

vec3 rdr2_test31_renodx_tonemap_psychov_custom_psycho31_SourceCoordinateCage_0(vec3 desired_coord_0, vec3 anchored_source_rgb_1, mat3x3 source_to_lms_1, vec3 anchor_in_lms_3, vec3 anchor_out_lms_3, vec3 target_peak_lms_2, float highlights_4, float shadows_4, float contrast_4, float flare_4, float highlight_contrast_4, float shadow_contrast_4, float purity_scale_3, float highlight_saturation_3, float dechroma_3, float sdr_eotf_emulation_3, vec2 compression_2, float mean_a2_shadow_source_weight_3, float mean_a2_midgray_source_weight_3, float mean_a2_highlight_source_weight_3, float response_yf_ceiling_4, int target_gamut_mode_4, out uint valid_3) {
  valid_3 = 0U;
  vec3 source_yf_coefficients_0 = (((source_to_lms_1) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1])));
  float neutral_source_rgb_0 = dot(source_yf_coefficients_0, anchored_source_rgb_1) / dot(source_yf_coefficients_0, vec3(1.0));
  if (neutral_source_rgb_0 <= 0.0) {
    return vec3(0.0);
  }
  vec3 source_residual_0 = anchored_source_rgb_1 - neutral_source_rgb_0;
  vec3 raw_lower_demand_0 = -source_residual_0 / neutral_source_rgb_0;
  float boundary_fraction_0 = rdr2_test31_rcp_0(rdr2_test31_renodx_tonemap_psychov_custom_psycho31_SmoothMax3_0(0.5 * (raw_lower_demand_0 + sqrt(raw_lower_demand_0 * raw_lower_demand_0 + 1.00000011116208043e-06))));
  vec3 neutral_source_q_0;
  float neutral_response_yf_0;
  uint neutral_valid_0;
  vec3 neutral_coord_0 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_ResponseCoord_0((((vec3(neutral_source_rgb_0)) * (source_to_lms_1))), anchor_in_lms_3, anchor_out_lms_3, target_peak_lms_2, highlights_4, shadows_4, contrast_4, flare_4, highlight_contrast_4, shadow_contrast_4, purity_scale_3, highlight_saturation_3, dechroma_3, sdr_eotf_emulation_3, compression_2, mean_a2_shadow_source_weight_3, mean_a2_midgray_source_weight_3, mean_a2_highlight_source_weight_3, neutral_source_q_0, neutral_response_yf_0, neutral_valid_0);
  vec3 boundary_source_q_0;
  float boundary_response_yf_0;
  uint boundary_valid_0;
  vec3 source_boundary_coord_0 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_ResponseCoord_0((((neutral_source_rgb_0 + source_residual_0 * boundary_fraction_0) * (source_to_lms_1))), anchor_in_lms_3, anchor_out_lms_3, target_peak_lms_2, highlights_4, shadows_4, contrast_4, flare_4, highlight_contrast_4, shadow_contrast_4, purity_scale_3, highlight_saturation_3, dechroma_3, sdr_eotf_emulation_3, compression_2, mean_a2_shadow_source_weight_3, mean_a2_midgray_source_weight_3, mean_a2_highlight_source_weight_3, boundary_source_q_0, boundary_response_yf_0, boundary_valid_0);
  bool _S42;
  if (neutral_valid_0 == 0U) {
    _S42 = true;
  } else {
    _S42 = boundary_valid_0 == 0U;
  }
  if (_S42) {
    return vec3(0.0);
  }
  uint target_endpoint_valid_0;
  vec3 target_endpoint_coord_0 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_TargetEndpoint_0(source_boundary_coord_0, boundary_response_yf_0, target_gamut_mode_4, target_endpoint_valid_0);
  if (target_endpoint_valid_0 == 0U) {
    return vec3(0.0);
  }
  uint neutral_endpoint_valid_0;
  vec3 neutral_endpoint_coord_0 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_TargetEndpoint_0(neutral_coord_0, neutral_response_yf_0, target_gamut_mode_4, neutral_endpoint_valid_0);
  if (neutral_endpoint_valid_0 == 0U) {
    return vec3(0.0);
  }
  float desired_a_0 = rdr2_test31_renodx_tonemap_psychov_psycho31_YfFromTest30Coord_0(desired_coord_0);
  vec3 source_chord_0 = source_boundary_coord_0 - neutral_coord_0;
  float source_chord_a_0 = rdr2_test31_renodx_tonemap_psychov_psycho31_YfFromTest30Coord_0(source_chord_0);
  float _S43 = source_chord_0.x;
  float _S44 = source_chord_0.z;
  vec3 mapped_coord_0 = mix(neutral_endpoint_coord_0, target_endpoint_coord_0, vec3(rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityClamp01_0((0.5 * (desired_coord_0.x - neutral_coord_0.x) * _S43 + (desired_coord_0.z - neutral_coord_0.z) * _S44 / 6.0 + (desired_a_0 - rdr2_test31_renodx_tonemap_psychov_psycho31_YfFromTest30Coord_0(neutral_coord_0)) * source_chord_a_0) / max(0.5 * _S43 * _S43 + _S44 * _S44 / 6.0 + source_chord_a_0 * source_chord_a_0, 9.999999960041972e-13))));
  float cage_a_0 = rdr2_test31_renodx_tonemap_psychov_psycho31_YfFromTest30Coord_0(mapped_coord_0);
  float ceiling_a_0 = clamp(desired_a_0, 0.0, rdr2_test31_saturate_0(response_yf_ceiling_4));
  vec3 mapped_coord_1;
  if (cage_a_0 > ceiling_a_0) {
    mapped_coord_1 = mapped_coord_0 * (ceiling_a_0 / cage_a_0);
  } else {
    mapped_coord_1 = mapped_coord_0;
  }
  if (!(any(bvec3((isnan(mapped_coord_1)))))) {
    _S42 = !(any(bvec3((isinf(mapped_coord_1)))));
  } else {
    _S42 = false;
  }
  uint _S45;
  if (_S42) {
    _S45 = 1U;
  } else {
    _S45 = 0U;
  }
  valid_3 = _S45;
  if (_S45 != 0U) {
  } else {
    mapped_coord_1 = vec3(0.0);
  }
  return mapped_coord_1;
}

vec3 rdr2_test31_renodx_tonemap_psychov_custom_psychotm_test31_0(vec3 bt709_linear_input_0, float peak_value_1, float exposure_0, float highlights_5, float shadows_5, float contrast_5, float flare_5, float highlight_contrast_5, float shadow_contrast_5, float purity_scale_4, float highlight_saturation_4, float dechroma_4, vec3 current_adaptive_state_bt709_0, vec3 current_background_state_bt709_0, float sdr_eotf_emulation_4, float gamut_compression_0, int gamut_compression_mode_0, float compression_strength, float mean_a2_shadow_source_weight_4, float mean_a2_midgray_source_weight_4, float mean_a2_highlight_source_weight_4, int source_boundary_0, float source_awareness_0, float clip) {
  // Carry strength and clip/peak together so each response uses the same LMS white clip.
  vec2 compression_3 = vec2(compression_strength, clip / peak_value_1);
  vec3 exposed_input_0 = bt709_linear_input_0 * exposure_0;
  vec3 anchored_source_rgb_2 = exposed_input_0;
  bool _S46;
  vec3 input_lms_0;
  mat3x3 source_to_lms_2;
  if (source_boundary_0 == 0) {
    input_lms_0 = (((exposed_input_0) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))));
    source_to_lms_2 = (((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))));
  } else {
    if (source_boundary_0 == 2) {
      vec3 source_rgb_1 = (((exposed_input_0) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(1.71665120124816895, -0.35567077994346619, -0.25336629152297974, -0.66668432950973511, 1.61648118495941162, 0.01576854661107063, 0.01763985678553581, -0.04277061298489571, 0.94210314750671387)))))));
      if ((all(bvec3((lessThanEqual(source_rgb_1, vec3(0.0))))))) {
        _S46 = !(any(bvec3((isinf(source_rgb_1)))));
      } else {
        _S46 = false;
      }
      if (_S46) {
        return vec3(0.0, 0.0, 0.0);
      }
      vec3 _S47 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_AnchorSourceBoundaryToYf_0(source_rgb_1, (((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))), max(((((((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)) / (max(((((((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).x + max(((((((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).y + max(((((((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).z), anchored_source_rgb_2);
      input_lms_0 = _S47;
      source_to_lms_2 = (((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))));
    } else {
      if (source_boundary_0 == 3) {
        vec3 source_rgb_2 = (((exposed_input_0) * (mat3x3(0.6130974292755127, 0.33952313661575317, 0.04737945273518562, 0.07019372284412384, 0.91635388135910034, 0.01345239859074354, 0.0206155925989151, 0.10956977307796478, 0.86981463432312012))));
        if ((all(bvec3((lessThanEqual(source_rgb_2, vec3(0.0))))))) {
          _S46 = !(any(bvec3((isinf(source_rgb_2)))));
        } else {
          _S46 = false;
        }
        if (_S46) {
          return vec3(0.0, 0.0, 0.0);
        }
        vec3 _S48 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_AnchorSourceBoundaryToYf_0(source_rgb_2, ((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))), max((((((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)) / (max((((((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).x + max((((((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).y + max((((((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).z), anchored_source_rgb_2);
        input_lms_0 = _S48;
        source_to_lms_2 = ((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))));
      } else {
        if ((all(bvec3((lessThanEqual(exposed_input_0, vec3(0.0))))))) {
          _S46 = !(any(bvec3((isinf(exposed_input_0)))));
        } else {
          _S46 = false;
        }
        if (_S46) {
          return vec3(0.0, 0.0, 0.0);
        }
        vec3 _S49 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_AnchorSourceBoundaryToYf_0(exposed_input_0, (((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))), max(((((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)) / (max(((((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).x + max(((((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).y + max(((((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).z), anchored_source_rgb_2);
        input_lms_0 = _S49;
        source_to_lms_2 = (((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))));
      }
    }
  }
  vec3 anchor_in_lms_4 = (((current_adaptive_state_bt709_0) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))));
  vec3 anchor_out_lms_4;
  if ((all(bvec3((equal(current_background_state_bt709_0, current_adaptive_state_bt709_0)))))) {
    anchor_out_lms_4 = anchor_in_lms_4;
  } else {
    anchor_out_lms_4 = (((current_background_state_bt709_0) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))));
  }
  vec3 target_peak_lms_3 = (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))) * peak_value_1;
  vec3 source_q_5;
  float response_yf_3;
  uint response_valid_0;
  vec3 desired_test30_coord_0 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_ResponseCoord_0(input_lms_0, anchor_in_lms_4, anchor_out_lms_4, target_peak_lms_3, highlights_5, shadows_5, contrast_5, flare_5, highlight_contrast_5, shadow_contrast_5, purity_scale_4, highlight_saturation_4, dechroma_4, sdr_eotf_emulation_4, compression_3, mean_a2_shadow_source_weight_4, mean_a2_midgray_source_weight_4, mean_a2_highlight_source_weight_4, source_q_5, response_yf_3, response_valid_0);
  if (response_valid_0 == 0U) {
    return vec3(0.0, 0.0, 0.0);
  }
  if (gamut_compression_0 == 0.0) {
    return (((rdr2_test31_renodx_tonemap_psychov_psycho31_LMSFromTest30Coord_0(desired_test30_coord_0, peak_value_1)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297)))))));
  }
  vec3 desired_lms_0 = rdr2_test31_renodx_tonemap_psychov_psycho31_LMSFromTest30Coord_0(desired_test30_coord_0, peak_value_1);
  float normalized_demand_2 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_NormalizedL8TargetDemand_0(desired_test30_coord_0, response_yf_3, gamut_compression_mode_0);
  float source_weight_0;
  if (source_boundary_0 != 0) {
    source_weight_0 = rdr2_test31_saturate_0(source_awareness_0);
  } else {
    source_weight_0 = 0.0;
  }
  if (source_weight_0 != 0.0) {
    source_weight_0 = source_weight_0 * rdr2_test31_renodx_tonemap_psychov_custom_psycho31_CInfinityTransition_1((normalized_demand_2 - 0.80000001192092896) / 1.20000004768371582);
  }
  const vec3 _S50 = vec3(0.0);
  uint cage_valid_0 = 0U;
  bool _S51 = source_weight_0 != 0.0;
  vec3 source_aware_test30_coord_0;
  if (_S51) {
    vec3 cage_test30_coord_0 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_SourceCoordinateCage_0(desired_test30_coord_0, anchored_source_rgb_2, source_to_lms_2, anchor_in_lms_4, anchor_out_lms_4, target_peak_lms_3, highlights_5, shadows_5, contrast_5, flare_5, highlight_contrast_5, shadow_contrast_5, purity_scale_4, highlight_saturation_4, dechroma_4, sdr_eotf_emulation_4, compression_3, mean_a2_shadow_source_weight_4, mean_a2_midgray_source_weight_4, mean_a2_highlight_source_weight_4, response_yf_3, gamut_compression_mode_0, cage_valid_0);
    if (cage_valid_0 != 0U) {
      source_aware_test30_coord_0 = cage_test30_coord_0;
    } else {
      source_aware_test30_coord_0 = _S50;
    }
  } else {
    source_aware_test30_coord_0 = _S50;
  }
  if (source_weight_0 != 1.0) {
    _S46 = true;
  } else {
    _S46 = cage_valid_0 == 0U;
  }
  vec3 knee_mapped_test30_coord_0;
  uint solve_valid_0;
  if (_S46) {
    vec3 knee_mapped_test30_coord_1 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_MapL8TargetDemand_0(desired_test30_coord_0, response_yf_3, gamut_compression_mode_0, normalized_demand_2);
    if (!(any(bvec3((isnan(knee_mapped_test30_coord_1)))))) {
      _S46 = !(any(bvec3((isinf(knee_mapped_test30_coord_1)))));
    } else {
      _S46 = false;
    }
    if (_S46) {
      solve_valid_0 = 1U;
    } else {
      solve_valid_0 = 0U;
    }
    if (cage_valid_0 == 0U) {
      if (solve_valid_0 != 0U) {
        input_lms_0 = knee_mapped_test30_coord_1;
      } else {
        input_lms_0 = _S50;
      }
      source_aware_test30_coord_0 = input_lms_0;
    }
    knee_mapped_test30_coord_0 = knee_mapped_test30_coord_1;
  } else {
    solve_valid_0 = 0U;
    knee_mapped_test30_coord_0 = _S50;
  }
  vec3 mapped_lms_0;
  if (source_weight_0 == 1.0) {
    mapped_lms_0 = rdr2_test31_renodx_tonemap_psychov_psycho31_LMSFromTest30Coord_0(source_aware_test30_coord_0, peak_value_1);
  } else {
    if (solve_valid_0 == 0U) {
      return vec3(0.0, 0.0, 0.0);
    }
    if (_S51) {
      knee_mapped_test30_coord_0 = mix(knee_mapped_test30_coord_0, source_aware_test30_coord_0, vec3(source_weight_0));
    }
    mapped_lms_0 = rdr2_test31_renodx_tonemap_psychov_psycho31_LMSFromTest30Coord_0(knee_mapped_test30_coord_0, peak_value_1);
  }
  vec3 output_bt709_0 = (((mix(desired_lms_0, mapped_lms_0, vec3(gamut_compression_0))) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297)))))));
  if (!(any(bvec3((isnan(output_bt709_0)))))) {
    _S46 = !(any(bvec3((isinf(output_bt709_0)))));
  } else {
    _S46 = false;
  }
  if (_S46) {
    input_lms_0 = output_bt709_0;
  } else {
    input_lms_0 = vec3(0.0, 0.0, 0.0);
  }
  return input_lms_0;
}

vec3 rdr2_test31_CompressBT2020Radial_0(vec3 color_2, float fit_strength_0, float norm_power_0) {
  float yf_0 = dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * (((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))[0] / (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x + mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * (((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))[1] / (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y, color_2);
  if (yf_0 <= 0.0) {
    return vec3(0.0);
  }
  const vec3 _S52 = vec3(0.0);
  vec3 clipped_0;
  if (fit_strength_0 != 1.0) {
    vec3 clipped_1 = max(color_2, _S52);
    vec3 clipped_2 = clipped_1 * (yf_0 / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * (((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))[0] / (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x + mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * (((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))[1] / (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y, clipped_1));
    if (fit_strength_0 == 0.0) {
      return clipped_2;
    }
    clipped_0 = clipped_2;
  } else {
    clipped_0 = _S52;
  }
  vec3 radial_rgb_1 = color_2 - yf_0;
  vec3 lower_rgb_0 = max(-radial_rgb_1, _S52);
  float lower_scale_0 = rdr2_test31_renodx_math_Max_2(lower_rgb_0);
  if (lower_scale_0 == 0.0) {
    return color_2;
  }
  vec3 normalized_lower_0 = lower_rgb_0 / lower_scale_0;
  float lower_norm_0;
  if (norm_power_0 == 8.0) {
    vec3 normalized_lower_1 = normalized_lower_0 * normalized_lower_0;
    vec3 normalized_lower_2 = normalized_lower_1 * normalized_lower_1;
    lower_norm_0 = lower_scale_0 * sqrt(sqrt(sqrt(dot(normalized_lower_2, normalized_lower_2))));
  } else {
    vec3 powers_0 = pow(normalized_lower_0, vec3(norm_power_0));
    lower_norm_0 = lower_scale_0 * pow(powers_0.x + powers_0.y + powers_0.z, rdr2_test31_rcp_0(norm_power_0));
  }
  float normalized_demand_3 = lower_norm_0 / yf_0;
  vec3 fitted_0 = fma(radial_rgb_1, vec3(rdr2_test31_renodx_tonemap_psychov_custom_psycho31_SmoothUnitLimit_0(normalized_demand_3, 16.0) / normalized_demand_3), vec3(yf_0));
  if (fit_strength_0 == 1.0) {
    return fitted_0;
  }
  return mix(clipped_0, fitted_0, vec3(fit_strength_0));
}

vec3 rdr2_test31_renodx_color_xyz_from_xyY_0(vec3 xyY_0) {
  vec2 _S53 = xyY_0.xy;
  vec3 XYZ_0;
  XYZ_0.xz = vec2(xyY_0.x, 1.0 - _S53.x - _S53.y) / xyY_0.y * xyY_0[2];
  XYZ_0[1] = xyY_0[2];
  return XYZ_0;
}

vec3 rdr2_test31_CompressXYZRadial_0(vec3 xyz_2) {
  vec3 d65_xyz_0 = rdr2_test31_renodx_color_xyz_from_xyY_0(vec3(vec2(0.31272000074386597, 0.32903000712394714), 1.0));
  vec3 color_3 = xyz_2 / d65_xyz_0;
  float y_4 = color_3.y;
  if (y_4 <= 0.0) {
    return vec3(0.0);
  }
  vec3 radial_xyz_0 = color_3 - y_4;
  vec3 lower_xyz_0 = max(-radial_xyz_0, vec3(0.0));
  float lower_scale_1 = rdr2_test31_renodx_math_Max_2(lower_xyz_0);
  if (lower_scale_1 == 0.0) {
    return xyz_2;
  }
  vec3 normalized_lower_3 = lower_xyz_0 / lower_scale_1;
  vec3 normalized_lower_4 = normalized_lower_3 * normalized_lower_3;
  vec3 normalized_lower_5 = normalized_lower_4 * normalized_lower_4;
  float normalized_demand_4 = lower_scale_1 * sqrt(sqrt(sqrt(dot(normalized_lower_5, normalized_lower_5)))) / y_4;
  return (y_4 + radial_xyz_0 * (rdr2_test31_renodx_tonemap_psychov_custom_psycho31_SmoothUnitLimit_0(normalized_demand_4, 16.0) / normalized_demand_4)) * d65_xyz_0;
}

vec3 rdr2_test31_CompressLMSRadial_0(vec3 lms_2) {
  float yf_1 = rdr2_test31_renodx_color_yf_from_LMS_0(lms_2) / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))));
  if (yf_1 <= 0.0) {
    return vec3(0.0);
  }
  vec3 neutral_lms_0 = (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))) * yf_1;
  vec3 radial_lms_0 = lms_2 - neutral_lms_0;
  vec3 lower_lms_0 = max(-radial_lms_0, vec3(0.0)) / (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))));
  float lower_scale_2 = rdr2_test31_renodx_math_Max_2(lower_lms_0);
  if (lower_scale_2 == 0.0) {
    return lms_2;
  }
  vec3 normalized_lower_6 = lower_lms_0 / lower_scale_2;
  vec3 normalized_lower_7 = normalized_lower_6 * normalized_lower_6;
  vec3 normalized_lower_8 = normalized_lower_7 * normalized_lower_7;
  float normalized_demand_5 = lower_scale_2 * sqrt(sqrt(sqrt(dot(normalized_lower_8, normalized_lower_8)))) / yf_1;
  return neutral_lms_0 + radial_lms_0 * (rdr2_test31_renodx_tonemap_psychov_custom_psycho31_SmoothUnitLimit_0(normalized_demand_5, 16.0) / normalized_demand_5);
}

vec3 rdr2_test31_renodx_tonemap_psychov_custom_psychograde_test31_0(vec3 bt709_linear_input_1, float exposure_1, float highlights_6, float shadows_6, float contrast_6, float flare_6, float highlight_contrast_6, float shadow_contrast_6, float purity_scale_5, float highlight_saturation_5, float dechroma_5, vec3 current_adaptive_state_bt709_1, vec3 current_background_state_bt709_1, int source_boundary_1) {
  vec3 exposed_input_1 = bt709_linear_input_1 * exposure_1;
  vec3 unused_anchored_source_rgb_0;
  bool _S54;
  vec3 input_lms_1;
  if (source_boundary_1 == 0) {
    input_lms_1 = (((exposed_input_1) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))));
  } else {
    if (source_boundary_1 == 2) {
      vec3 source_rgb_3 = (((exposed_input_1) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(1.71665120124816895, -0.35567077994346619, -0.25336629152297974, -0.66668432950973511, 1.61648118495941162, 0.01576854661107063, 0.01763985678553581, -0.04277061298489571, 0.94210314750671387)))))));
      if ((all(bvec3((lessThanEqual(source_rgb_3, vec3(0.0))))))) {
        _S54 = !(any(bvec3((isinf(source_rgb_3)))));
      } else {
        _S54 = false;
      }
      if (_S54) {
        return vec3(0.0);
      }
      vec3 _S55 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_AnchorSourceBoundaryToYf_0(source_rgb_3, (((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))), max(((((((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)) / (max(((((((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).x + max(((((((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).y + max(((((((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).z), unused_anchored_source_rgb_0);
      input_lms_1 = _S55;
    } else {
      if (source_boundary_1 == 3) {
        vec3 source_rgb_4 = (((exposed_input_1) * (mat3x3(0.6130974292755127, 0.33952313661575317, 0.04737945273518562, 0.07019372284412384, 0.91635388135910034, 0.01345239859074354, 0.0206155925989151, 0.10956977307796478, 0.86981463432312012))));
        if ((all(bvec3((lessThanEqual(source_rgb_4, vec3(0.0))))))) {
          _S54 = !(any(bvec3((isinf(source_rgb_4)))));
        } else {
          _S54 = false;
        }
        if (_S54) {
          return vec3(0.0);
        }
        vec3 _S56 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_AnchorSourceBoundaryToYf_0(source_rgb_4, ((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))), max((((((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)) / (max((((((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).x + max((((((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).y + max((((((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).z), unused_anchored_source_rgb_0);
        input_lms_1 = _S56;
      } else {
        if ((all(bvec3((lessThanEqual(exposed_input_1, vec3(0.0))))))) {
          _S54 = !(any(bvec3((isinf(exposed_input_1)))));
        } else {
          _S54 = false;
        }
        if (_S54) {
          return vec3(0.0);
        }
        vec3 _S57 = rdr2_test31_renodx_tonemap_psychov_custom_psycho31_AnchorSourceBoundaryToYf_0(exposed_input_1, (((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))), max(((((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)) / (max(((((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).x + max(((((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).y + max(((((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).z), unused_anchored_source_rgb_0);
        input_lms_1 = _S57;
      }
    }
  }
  if ((any(bvec3((lessThan(input_lms_1, vec3(0.0))))))) {
    float input_yf_0 = rdr2_test31_renodx_color_yf_from_LMS_0(input_lms_1);
    if (!(input_yf_0 > 0.0)) {
      _S54 = true;
    } else {
      _S54 = isnan(input_yf_0);
    }
    if (_S54) {
      _S54 = true;
    } else {
      _S54 = isinf(input_yf_0);
    }
    if (_S54) {
      return vec3(0.0);
    }
    vec3 neutral_lms_1 = (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))) * (input_yf_0 / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))));
    vec3 residual_0 = input_lms_1 - neutral_lms_1;
    input_lms_1 = max(neutral_lms_1 + residual_0 * min(1.0, rdr2_test31_renodx_math_Min_2(neutral_lms_1 / max(-residual_0, neutral_lms_1))), vec3(0.0));
  }
  if ((all(bvec3((equal(input_lms_1, vec3(0.0))))))) {
    return vec3(0.0);
  }
  vec3 anchor_in_lms_5 = (((current_adaptive_state_bt709_1) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))));
  vec3 anchor_out_lms_5;
  if ((all(bvec3((equal(current_background_state_bt709_1, current_adaptive_state_bt709_1)))))) {
    anchor_out_lms_5 = anchor_in_lms_5;
  } else {
    anchor_out_lms_5 = (((current_background_state_bt709_1) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))));
  }
  vec3 unused_tonal_input_lms_0;
  vec3 output_bt709_1 = (((rdr2_test31_renodx_tonemap_psychov_custom_psycho31_GradeLMS_0(input_lms_1, anchor_in_lms_5, anchor_out_lms_5, highlights_6, shadows_6, contrast_6, flare_6, highlight_contrast_6, shadow_contrast_6, purity_scale_5, highlight_saturation_5, dechroma_5, 0.0, unused_tonal_input_lms_0, false)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297)))))));
  if (!(any(bvec3((isnan(output_bt709_1)))))) {
    _S54 = !(any(bvec3((isinf(output_bt709_1)))));
  } else {
    _S54 = false;
  }
  if (_S54) {
    input_lms_1 = output_bt709_1;
  } else {
    input_lms_1 = vec3(0.0);
  }
  return input_lms_1;
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho30_AnchorSourceBoundaryToYf_0(vec3 source_rgb_5, mat3x3 source_to_lms_3, vec3 source_yf_weights_1, out vec3 anchored_source_rgb_3) {
  if ((all(bvec3((greaterThanEqual(source_rgb_5, vec3(0.0))))))) {
    anchored_source_rgb_3 = source_rgb_5;
    return (((source_rgb_5) * (source_to_lms_3)));
  } else {
    float source_total_1 = dot(max(source_rgb_5, vec3(0.0)), source_yf_weights_1);
    vec3 residual_1 = source_rgb_5 - source_total_1;
    vec3 _S58 = source_total_1 + residual_1 * min(1.0, rdr2_test31_renodx_math_Min_2(rdr2_test31_renodx_math_Select_1(lessThan(residual_1, vec3(-9.99999997475242708e-07)), source_total_1 / -residual_1, vec3(1.00000002004087734e+20))));
    vec3 bounded_lms_1 = (((_S58) * (source_to_lms_3)));
    float scale_1 = source_total_1 * dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) / rdr2_test31_renodx_color_yf_from_LMS_0(bounded_lms_1);
    anchored_source_rgb_3 = _S58 * scale_1;
    return bounded_lms_1 * scale_1;
  }
}

float rdr2_test31_renodx_tonemap_psychov_psycho30_GradeQuinticUnitRamp_0(float t_1) {
  float _S59 = rdr2_test31_saturate_0(t_1);
  return _S59 * _S59 * _S59 * (_S59 * (_S59 * 6.0 - 15.0) + 10.0);
}

float rdr2_test31_renodx_tonemap_psychov_psycho30_HighlightsScalar_0(float x_8, float highlights_7, float adapted_anchor_yf_0) {
  if (highlights_7 == 1.0) {
    return x_8;
  } else {
    float ratio_0 = x_8 / adapted_anchor_yf_0;
    float t_2;
    if (x_8 > adapted_anchor_yf_0) {
      t_2 = rdr2_test31_saturate_0(log2(ratio_0) / log2(1.0 / adapted_anchor_yf_0));
    } else {
      t_2 = 0.0;
    }
    float t_3 = rdr2_test31_renodx_tonemap_psychov_psycho30_GradeQuinticUnitRamp_0(t_2);
    if (highlights_7 > 1.0) {
      return x_8 * mix(1.0, pow(ratio_0, highlights_7 - 1.0), t_3);
    } else {
      return x_8 / mix(1.0, pow(ratio_0, 1.0 - highlights_7), t_3);
    }
  }
}

float rdr2_test31_renodx_tonemap_psychov_psycho30_ShadowsScalar_0(float x_9, float shadows_7, float adapted_anchor_yf_1) {
  if (shadows_7 == 1.0) {
    return x_9;
  } else {
    float ratio_1 = x_9 / adapted_anchor_yf_1;
    float anchor_squared_0 = adapted_anchor_yf_1 * adapted_anchor_yf_1;
    float anchor_cubed_0 = anchor_squared_0 * adapted_anchor_yf_1;
    float shadow_floor_0 = adapted_anchor_yf_1 * (exp2((-4.0)));
    float t_4;
    if (x_9 > shadow_floor_0) {
      t_4 = rdr2_test31_saturate_0(log2(ratio_1) / log2(shadow_floor_0 / adapted_anchor_yf_1));
    } else {
      t_4 = 1.0;
    }
    float t_5 = rdr2_test31_renodx_tonemap_psychov_psycho30_GradeQuinticUnitRamp_0(t_4);
    if (shadows_7 > 1.0) {
      return mix(x_9, x_9 * (1.0 - anchor_squared_0) + anchor_cubed_0 * pow(ratio_1, 2.0 - shadows_7), t_5);
    } else {
      return mix(x_9, x_9 * (1.0 + anchor_squared_0) - anchor_cubed_0 * pow(ratio_1, shadows_7), t_5);
    }
  }
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho31_ResponseInputQ_0(vec3 source_lms_3, vec3 anchor_lms_1, float highlights_8, float shadows_8, float purity_delta_1) {
  bool _S60;
  if (highlights_8 != 1.0) {
    _S60 = true;
  } else {
    _S60 = shadows_8 != 1.0;
  }
  vec3 graded_lms_3;
  if (_S60) {
    vec3 graded_lms_4 = abs(source_lms_3);
    float graded_yf_1 = rdr2_test31_renodx_color_yf_from_LMS_0(graded_lms_4);
    float adapted_anchor_yf_2 = rdr2_test31_renodx_color_yf_from_LMS_0(anchor_lms_1);
    graded_lms_3 = rdr2_test31_renodx_math_CopySign_0(graded_lms_4 * (rdr2_test31_renodx_tonemap_psychov_psycho30_ShadowsScalar_0(rdr2_test31_renodx_tonemap_psychov_psycho30_HighlightsScalar_0(graded_yf_1, highlights_8, adapted_anchor_yf_2), shadows_8, adapted_anchor_yf_2) / graded_yf_1), source_lms_3);
  } else {
    graded_lms_3 = source_lms_3;
  }
  return rdr2_test31_renodx_tonemap_psychov_psycho30_ApplyAdaptiveRelativePurity_0(graded_lms_3, anchor_lms_1, purity_delta_1);
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho30_TargetRGBFromLMS_0(vec3 lms_3, int target_gamut_mode_5) {
  vec3 target_rgb_0;
  if (target_gamut_mode_5 == 0) {
    target_rgb_0 = (((lms_3) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297)))))));
  } else {
    target_rgb_0 = (((lms_3) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(1.71665120124816895, -0.35567077994346619, -0.25336629152297974, -0.66668432950973511, 1.61648118495941162, 0.01576854661107063, 0.01763985678553581, -0.04277061298489571, 0.94210314750671387)))))));
  }
  return target_rgb_0;
}

float rdr2_test31_renodx_tonemap_psychov_psycho30_TargetNeutralYfLimit_0(float target_rgb_peak_0, vec3 anchor_lms_2, int target_gamut_mode_6) {
  return target_rgb_peak_0 * rdr2_test31_renodx_color_yf_from_LMS_0(anchor_lms_2) / rdr2_test31_renodx_math_Max_2(rdr2_test31_renodx_tonemap_psychov_psycho30_TargetRGBFromLMS_0(anchor_lms_2, target_gamut_mode_6));
}

float rdr2_test31_renodx_tonemap_psychov_psycho30_AutoCompressionPower_0(float anchor_yf_0, float peak_yf_0) {
  return max(1.85000002384185791 / ((log((peak_yf_0 / anchor_yf_0)) * float(0.43429448190325182765112891891661))), 1.0);
}

vec3 rdr2_test31_renodx_math_SignPow_0(vec3 x_10, vec3 exponent_1) {
  return rdr2_test31_renodx_math_CopySign_0(pow(abs(x_10), exponent_1), x_10);
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho30_ApplySignedConeResponseFallback_0(vec3 source_relative_lms_0, float response_power_0) {
  if (response_power_0 == 1.0) {
    return source_relative_lms_0;
  }
  return rdr2_test31_renodx_math_SignPow_0(source_relative_lms_0, vec3(response_power_0));
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho30_LMSFromScaledA2_0(vec2 scaled_a2_0, float physical_yf_0, vec3 anchor_lms_3) {
  float a_l_0 = mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * anchor_lms_3.x;
  float _S61 = scaled_a2_0.x;
  float q_m_0 = (physical_yf_0 - a_l_0 * _S61) / (a_l_0 + mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * anchor_lms_3.y);
  float q_l_0 = q_m_0 + _S61;
  return vec3(q_l_0, q_m_0, 0.5 * (scaled_a2_0.y + q_l_0 + q_m_0)) * anchor_lms_3;
}

float rdr2_test31_renodx_tonemap_psychov_psycho30_FiniteEndpoint_0(float x_11, float anchor_1, float peak_1, float h_0) {
  float _S62 = anchor_1 / peak_1;
  bool _S63 = !(h_0 == 1.0);
  float anchor_power_0;
  if (_S63) {
    anchor_power_0 = pow(anchor_1 / peak_1, h_0);
  } else {
    anchor_power_0 = _S62;
  }
  float slope_normalization_0 = 1.0 - anchor_power_0;
  float encoded_0 = anchor_power_0 / (anchor_power_0 + slope_normalization_0 * pow(x_11 / anchor_1, -h_0 / slope_normalization_0));
  float _S64 = peak_1 * encoded_0;
  float result_1;
  if (_S63) {
    result_1 = peak_1 * pow(encoded_0, 1.0 / h_0);
  } else {
    result_1 = _S64;
  }
  return result_1;
}

float rdr2_test31_renodx_math_CopySign_1(float mag_1, float sgn_1) {
  float abs_value_1 = abs(mag_1);
  return rdr2_test31_renodx_math_Select_0(sgn_1 < 0.0, -abs_value_1, abs_value_1);
}

vec2 rdr2_test31_renodx_tonemap_psychov_psycho30_MBFromRelativeLMS_0(vec3 relative_lms_0) {
  float yf_2 = rdr2_test31_renodx_color_yf_from_LMS_0(relative_lms_0);
  return vec2(relative_lms_0.x * mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] / yf_2, relative_lms_0.z * 0.03715970739722252 / yf_2);
}

vec2 rdr2_test31_renodx_tonemap_psychov_psycho30_AdaptiveNeutralMB_0() {
  return vec2(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0], 0.03715970739722252) / (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1]
                                                                                                                                                                                                  [0]
                                                                                                                                                                                                  + mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1]);
}

float rdr2_test31_renodx_tonemap_psychov_psycho30_Cross2_0(vec2 a_1, vec2 b_0) {
  return a_1.x * b_0.y - a_1.y * b_0.x;
}

float rdr2_test31_renodx_tonemap_psychov_psycho30_RaySegmentRadius_0(vec2 origin_0, vec2 direction_0, vec2 a_2, vec2 b_1) {
  vec2 edge_0 = b_1 - a_2;
  float denominator_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_Cross2_0(direction_0, edge_0);
  if ((abs(denominator_0)) <= 9.99999997475242708e-07) {
    return 1.00000002004087734e+20;
  }
  vec2 ao_0 = a_2 - origin_0;
  float t_6 = rdr2_test31_renodx_tonemap_psychov_psycho30_Cross2_0(ao_0, edge_0) / denominator_0;
  float u_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_Cross2_0(ao_0, direction_0) / denominator_0;
  bool _S65;
  if (t_6 >= 0.0) {
    _S65 = u_0 >= 0.0;
  } else {
    _S65 = false;
  }
  if (_S65) {
    _S65 = u_0 <= 1.0;
  } else {
    _S65 = false;
  }
  float _S66;
  if (_S65) {
    _S66 = t_6;
  } else {
    _S66 = 1.00000002004087734e+20;
  }
  return _S66;
}

float rdr2_test31_renodx_tonemap_psychov_psycho30_TransformedSourceClipScaledA2Magnitude_0(vec2 source_mb_0, float response_power_1, vec3 response_anchor_ratio_0, float physical_yf_1, vec3 anchor_lms_4) {
  vec2 neutral_mb_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_AdaptiveNeutralMB_0();
  vec2 source_offset_0 = source_mb_0 - neutral_mb_0;
  float source_radius2_0 = dot(source_offset_0, source_offset_0);
  if (source_radius2_0 <= 9.999999960041972e-13) {
    return 0.0;
  }
  vec2 vertices_0[3];
  int channel_0 = 0;
  [[unroll]]
  for (;;) {
    if (channel_0 < 3) {
    } else {
      break;
    }
    vertices_0[channel_0] = rdr2_test31_renodx_tonemap_psychov_psycho30_MBFromRelativeLMS_0(vec3((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))) [0][channel_0], (((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))) [1][channel_0], (((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))) [2][channel_0]) / anchor_lms_4);
    channel_0 = channel_0 + 1;
  }
  vec2 source_direction_0 = source_offset_0 * (inversesqrt((source_radius2_0)));
  float _S67 = min(rdr2_test31_renodx_tonemap_psychov_psycho30_RaySegmentRadius_0(neutral_mb_0, source_direction_0, vertices_0[0], vertices_0[1]), min(rdr2_test31_renodx_tonemap_psychov_psycho30_RaySegmentRadius_0(neutral_mb_0, source_direction_0, vertices_0[1], vertices_0[2]), rdr2_test31_renodx_tonemap_psychov_psycho30_RaySegmentRadius_0(neutral_mb_0, source_direction_0, vertices_0[2], vertices_0[0])));
  if (_S67 >= 1.00000002004087734e+20) {
    return 0.0;
  }
  vec2 boundary_mb_0 = neutral_mb_0 + source_direction_0 * _S67;
  float _S68 = boundary_mb_0.x;
  float m_fraction_0 = 1.0 - _S68;
  bool _S69;
  if (_S68 <= 9.99999997475242708e-07) {
    _S69 = true;
  } else {
    _S69 = m_fraction_0 <= 9.99999997475242708e-07;
  }
  if (_S69) {
    _S69 = true;
  } else {
    _S69 = (boundary_mb_0.y) <= 9.99999997475242708e-07;
  }
  if (_S69) {
    return 0.0;
  }
  vec2 boundary_response_ratio_0 = vec2(_S68 * mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] / (m_fraction_0 * mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0]), boundary_mb_0.y * mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] / (m_fraction_0 * 0.03715970739722252));
  vec2 response_ratio_0;
  if (response_power_1 == 1.0) {
    response_ratio_0 = boundary_response_ratio_0;
  } else {
    response_ratio_0 = pow(boundary_response_ratio_0, vec2(response_power_1));
  }
  float _S70 = response_anchor_ratio_0.y;
  vec2 response_ratio_1 = response_ratio_0 * vec2(response_anchor_ratio_0.x / _S70, response_anchor_ratio_0.z / _S70);
  vec3 boundary_q_direction_0 = vec3(response_ratio_1.x, 1.0, response_ratio_1.y);
  return sqrt(rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2Radius6_0(rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2FromQ_0(boundary_q_direction_0 * (physical_yf_1 / rdr2_test31_renodx_color_yf_from_LMS_0(anchor_lms_4 * boundary_q_direction_0)))));
}

float rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2TargetSupport_0(vec2 direction_1, float clip_magnitude_0, float physical_yf_2, vec3 anchor_lms_5, int target_gamut_mode_7, float target_rgb_peak_1) {
  if (clip_magnitude_0 <= 9.99999997475242708e-07) {
    return 0.0;
  }
  vec3 neutral_target_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_TargetRGBFromLMS_0(rdr2_test31_renodx_tonemap_psychov_psycho30_LMSFromScaledA2_0(vec2(0.0), physical_yf_2, anchor_lms_5), target_gamut_mode_7);
  vec3 _S71 = rdr2_test31_renodx_tonemap_psychov_psycho30_TargetRGBFromLMS_0(rdr2_test31_renodx_tonemap_psychov_psycho30_LMSFromScaledA2_0(direction_1, physical_yf_2, anchor_lms_5), target_gamut_mode_7) - neutral_target_0;
  float support_0 = clip_magnitude_0;
  int channel_1 = 0;
  [[unroll]]
  for (;;) {
    if (channel_1 < 3) {
    } else {
      break;
    }
    int _S72 = channel_1;
    if ((_S71[channel_1]) > 9.99999997475242708e-07) {
      support_0 = min(support_0, (target_rgb_peak_1 - neutral_target_0[channel_1]) / _S71[_S72]);
    } else {
      float support_1;
      if ((_S71[_S72]) < -9.99999997475242708e-07) {
        support_1 = min(support_0, neutral_target_0[channel_1] / -_S71[_S72]);
      } else {
        support_1 = support_0;
      }
      support_0 = support_1;
    }
    channel_1 = channel_1 + 1;
  }
  return max(support_0, 0.0);
}

float rdr2_test31_renodx_tonemap_psychov_psycho30_NeutwoWithClip_0(float x_12, float peak_2, float clip_0, float h_1) {
  if (peak_2 <= 9.99999997475242708e-07) {
    return 0.0;
  }
  if (clip_0 <= (peak_2 * 1.00000095367431641)) {
    return min(x_12, peak_2);
  }
  float q_1 = rdr2_test31_saturate_0(x_12 / clip_0);
  float k_0 = rdr2_test31_saturate_0(peak_2 / clip_0);
  if (h_1 == 1.0) {
    return peak_2 * q_1 / (q_1 * (1.0 - k_0) + k_0);
  } else {
    float kh_0 = pow(k_0, h_1);
    return peak_2 * q_1 / pow(pow(q_1, h_1) * (1.0 - kh_0) + kh_0, 1.0 / h_1);
  }
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho30_LinearA2Fallback_0(vec3 source_q_6, vec3 anchor_in_lms_6, vec3 anchor_out_lms_6, int target_gamut_mode_8, float target_rgb_peak_2, float response_power_2, float response_h_0, float target_compression_strength_0) {
  vec3 response_lms_2 = anchor_out_lms_6 * rdr2_test31_renodx_tonemap_psychov_psycho30_ApplySignedConeResponseFallback_0(source_q_6, response_power_2);
  float response_yf_4 = rdr2_test31_renodx_color_yf_from_LMS_0(response_lms_2);
  vec2 source_scaled_a2_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2FromQ_0(source_q_6);
  vec2 response_scaled_a2_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2FromQ_0(response_lms_2 / anchor_in_lms_6);
  float source_radius6_1 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2Radius6_0(source_scaled_a2_0);
  float response_radius6_1 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2Radius6_0(response_scaled_a2_0);
  bool _S73;
  if (source_radius6_1 > 5.9999999760251832e-12) {
    _S73 = response_radius6_1 > 5.9999999760251832e-12;
  } else {
    _S73 = false;
  }
  vec3 authored_lms_0;
  if (_S73) {
    float inverse_response_radius_1 = (inversesqrt((response_radius6_1)));
    float response_radius_1 = response_radius6_1 * inverse_response_radius_1;
    vec2 midpoint_0 = source_scaled_a2_0 * (inversesqrt((source_radius6_1))) + response_scaled_a2_0 * inverse_response_radius_1;
    float midpoint_radius6_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2Radius6_0(midpoint_0);
    if (midpoint_radius6_0 > 9.999999960041972e-13) {
      authored_lms_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_LMSFromScaledA2_0(midpoint_0 * (inversesqrt((midpoint_radius6_0))) * response_radius_1, response_yf_4, anchor_in_lms_6);
    } else {
      authored_lms_0 = response_lms_2;
    }
  } else {
    authored_lms_0 = response_lms_2;
  }
  float target_yf_0 = rdr2_test31_renodx_math_CopySign_1(rdr2_test31_renodx_tonemap_psychov_psycho30_FiniteEndpoint_0(abs(response_yf_4), rdr2_test31_renodx_color_yf_from_LMS_0(anchor_out_lms_6), rdr2_test31_renodx_tonemap_psychov_psycho30_TargetNeutralYfLimit_0(target_rgb_peak_2, anchor_in_lms_6, target_gamut_mode_8), response_h_0), response_yf_4);
  if (response_yf_4 == 0.0) {
    _S73 = target_yf_0 == 0.0;
  } else {
    _S73 = false;
  }
  vec3 desired_lms_1;
  if (_S73) {
    desired_lms_1 = vec3(0.0);
  } else {
    desired_lms_1 = authored_lms_0 * (target_yf_0 / response_yf_4);
  }
  if (target_compression_strength_0 == 0.0) {
    return desired_lms_1;
  } else {
    if (target_yf_0 <= 0.0) {
      return desired_lms_1 * (1.0 - target_compression_strength_0);
    } else {
      vec2 desired_scaled_a2_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2FromQ_0(desired_lms_1 / anchor_in_lms_6);
      float desired_radius6_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2Radius6_0(desired_scaled_a2_0);
      if (desired_radius6_0 <= 5.9999999760251832e-12) {
        return anchor_in_lms_6 * (target_yf_0 / rdr2_test31_renodx_color_yf_from_LMS_0(anchor_in_lms_6));
      }
      float inverse_desired_magnitude_0 = (inversesqrt((desired_radius6_0)));
      float desired_magnitude_0 = desired_radius6_0 * inverse_desired_magnitude_0;
      vec2 direction_2 = desired_scaled_a2_0 * inverse_desired_magnitude_0;
      float _S74 = max(rdr2_test31_renodx_tonemap_psychov_psycho30_TransformedSourceClipScaledA2Magnitude_0(rdr2_test31_renodx_tonemap_psychov_psycho30_MBFromRelativeLMS_0(source_q_6), response_power_2, anchor_out_lms_6 / anchor_in_lms_6, target_yf_0, anchor_in_lms_6), desired_magnitude_0);
      float target_support_0 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2TargetSupport_0(direction_2, _S74, target_yf_0, anchor_in_lms_6, target_gamut_mode_8, target_rgb_peak_2);
      return rdr2_test31_renodx_tonemap_psychov_psycho30_LMSFromScaledA2_0(direction_2 * mix(desired_magnitude_0, min(rdr2_test31_renodx_tonemap_psychov_psycho30_NeutwoWithClip_0(desired_magnitude_0, target_support_0, max(_S74, target_support_0), response_h_0), target_support_0), target_compression_strength_0), target_yf_0, anchor_in_lms_6);
    }
  }
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho30_FiniteResponseUFromPositiveQ_0(vec3 source_q_7, vec3 adaptation_peak_ratio_0, float response_power_3, float response_h_1) {
  bool uniform_response_0 = response_h_1 == 1.0;
  vec3 anchor_power_1;
  if (uniform_response_0) {
    anchor_power_1 = adaptation_peak_ratio_0;
  } else {
    anchor_power_1 = pow(adaptation_peak_ratio_0, vec3(response_h_1));
  }
  vec3 slope_normalization_1 = 1.0 - anchor_power_1;
  vec3 finite_encoded_0 = anchor_power_1 / (anchor_power_1 + slope_normalization_1 * pow(source_q_7, -(response_power_3 * response_h_1 / slope_normalization_1)));
  if (uniform_response_0) {
    return finite_encoded_0;
  } else {
    return pow(finite_encoded_0, vec3(1.0 / response_h_1));
  }
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho30_MeanA2ResponseFromPositiveQ_0(vec3 source_q_8, vec3 adaptation_peak_ratio_1, float response_power_4, float response_h_2, out float normalized_response_yf_0) {
  vec3 response_u_3 = rdr2_test31_renodx_tonemap_psychov_psycho30_FiniteResponseUFromPositiveQ_0(source_q_8, adaptation_peak_ratio_1, response_power_4, response_h_2);
  float _S75 = source_q_8.x;
  float _S76 = source_q_8.y;
  vec2 source_dt_1 = vec2(_S75 - _S76, 2.0 * source_q_8.z - _S75 - _S76);
  float _S77 = response_u_3.x;
  float _S78 = response_u_3.y;
  float response_lms_sum_0 = _S77 + _S78;
  float _S79 = response_u_3.z;
  vec2 response_dt_1 = vec2(_S77 - _S78, 2.0 * _S79 - response_lms_sum_0);
  float source_radius6_2 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2Radius6_0(source_dt_1);
  float response_radius6_2 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2Radius6_0(response_dt_1);
  bool _S80;
  if (source_radius6_2 > 5.9999999760251832e-12) {
    _S80 = response_radius6_2 > 5.9999999760251832e-12;
  } else {
    _S80 = false;
  }
  vec2 authored_dt_1;
  if (_S80) {
    float inverse_response_radius_2 = (inversesqrt((response_radius6_2)));
    float response_radius_2 = response_radius6_2 * inverse_response_radius_2;
    vec2 mean_direction_2 = source_dt_1 * (inversesqrt((source_radius6_2))) + response_dt_1 * inverse_response_radius_2;
    float mean_radius6_2 = rdr2_test31_renodx_tonemap_psychov_psycho30_ScaledA2Radius6_0(mean_direction_2);
    if (mean_radius6_2 > 9.999999960041972e-13) {
      authored_dt_1 = mean_direction_2 * (response_radius_2 * (inversesqrt((mean_radius6_2))));
    } else {
      authored_dt_1 = response_dt_1;
    }
  } else {
    authored_dt_1 = response_dt_1;
  }
  normalized_response_yf_0 = mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * _S77 + mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * _S78;
  return vec3(authored_dt_1.x, response_lms_sum_0 + _S79, authored_dt_1.y);
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho29_OrthonormalConeCoordFromLMS_0(vec3 lms_4, vec3 peak_lms_0) {
  vec3 u_1 = lms_4 / max(abs(peak_lms_0), vec3(9.99999997475242708e-07, 9.99999997475242708e-07, 9.99999997475242708e-07));
  float _S81 = u_1.x;
  float _S82 = u_1.y;
  float _S83 = u_1.z;
  return vec3((_S81 - _S82) * (inversesqrt((2.0))), (_S81 + _S82 + _S83) * (inversesqrt((3.0))), (2.0 * _S83 - _S81 - _S82) * (inversesqrt((6.0))));
}

float rdr2_test31_renodx_tonemap_psychov_psycho29_YfFromLMS_0(vec3 lms_5) {
  return fma(lms_5.x, mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0], lms_5.y * mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1]);
}

vec2 rdr2_test31_renodx_tonemap_psychov_psycho29_OrthonormalYfCoefficients_0(vec2 direction_3, vec3 peak_lms_1) {
  vec3 safe_peak_0 = max(abs(peak_lms_1), vec3(9.99999997475242708e-07, 9.99999997475242708e-07, 9.99999997475242708e-07));
  float _S84 = max(rdr2_test31_renodx_tonemap_psychov_psycho29_YfFromLMS_0(safe_peak_0), 9.99999997475242708e-07);
  float alpha_l_0 = mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * safe_peak_0.x / _S84;
  float alpha_m_0 = mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * safe_peak_0.y / _S84;
  float _S85 = max(alpha_l_0 + alpha_m_0, 9.99999997475242708e-07);
  return vec2((inversesqrt((3.0))), (alpha_l_0 / _S85 - alpha_m_0 / _S85) * direction_3.x * (inversesqrt((2.0))) - direction_3.y * (inversesqrt((6.0))));
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho29_LMSFromNormalizedPsychoCoord_0(vec3 coord_6, vec3 peak_lms_2) {
  vec3 safe_peak_lms_0 = max(abs(peak_lms_2), vec3(9.99999997475242708e-07, 9.99999997475242708e-07, 9.99999997475242708e-07));
  float _S86 = max(rdr2_test31_renodx_tonemap_psychov_psycho29_YfFromLMS_0(safe_peak_lms_0), 9.99999997475242708e-07);
  float alpha_l_1 = mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * safe_peak_lms_0.x / _S86;
  float alpha_m_1 = mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * safe_peak_lms_0.y / _S86;
  float _S87 = max(alpha_l_1 + alpha_m_1, 9.99999997475242708e-07);
  float difference_0 = sqrt(2.0) * coord_6.x;
  float _S88 = coord_6.y;
  float u_m_0 = _S88 - alpha_l_1 / _S87 * difference_0;
  float u_l_0 = _S88 + alpha_m_1 / _S87 * difference_0;
  return vec3(u_l_0, u_m_0, 0.5 * (sqrt(6.0) * coord_6.z + u_l_0 + u_m_0)) * safe_peak_lms_0;
}

void rdr2_test31_renodx_tonemap_psychov_psycho29_TargetARCoefficients_0(vec2 direction_4, vec3 peak_lms_3, mat3x3 lms_to_target_0, float target_rgb_peak_3, out vec3 a_rgb_0, out vec3 rho_rgb_0) {
  float _S89 = max(target_rgb_peak_3, 9.99999997475242708e-07);
  a_rgb_0 = (((rdr2_test31_renodx_tonemap_psychov_psycho29_LMSFromNormalizedPsychoCoord_0(vec3(0.0, 1.0, 0.0), peak_lms_3)) * (lms_to_target_0))) / _S89;
  rho_rgb_0 = (((rdr2_test31_renodx_tonemap_psychov_psycho29_LMSFromNormalizedPsychoCoord_0(vec3(direction_4.x, 0.0, direction_4.y), peak_lms_3)) * (lms_to_target_0))) / _S89;
  return;
}

void rdr2_test31_renodx_tonemap_psychov_psycho29_NeutwoSupportScales_0(vec2 direction_5, vec3 peak_lms_4, mat3x3 lms_to_target_1, float target_rgb_peak_4, out float k_black_0, out float k_white_0, out uint valid_4) {
  vec3 a_rgb_1;
  vec3 rho_rgb_1;
  rdr2_test31_renodx_tonemap_psychov_psycho29_TargetARCoefficients_0(direction_5, peak_lms_4, lms_to_target_1, target_rgb_peak_4, a_rgb_1, rho_rgb_1);
  vec3 smooth_abs_0 = sqrt(rho_rgb_1 * rho_rgb_1 + vec3(9.999999960041972e-13, 9.999999960041972e-13, 9.999999960041972e-13));
  k_white_0 = rdr2_test31_rcp_0(max(length(0.5 * (smooth_abs_0 + rho_rgb_1)), 9.99999997475242708e-07));
  k_black_0 = rdr2_test31_rcp_0(max(length(0.5 * (smooth_abs_0 - rho_rgb_1)), 9.99999997475242708e-07));
  bool _S90;
  if (!(any(bvec3((isnan(a_rgb_1)))))) {
    _S90 = !(any(bvec3((isinf(a_rgb_1)))));
  } else {
    _S90 = false;
  }
  if (_S90) {
    _S90 = !(any(bvec3((isnan(rho_rgb_1)))));
  } else {
    _S90 = false;
  }
  if (_S90) {
    _S90 = !(any(bvec3((isinf(rho_rgb_1)))));
  } else {
    _S90 = false;
  }
  if (_S90) {
    _S90 = k_black_0 > 0.0;
  } else {
    _S90 = false;
  }
  if (_S90) {
    _S90 = k_white_0 > 0.0;
  } else {
    _S90 = false;
  }
  if (_S90) {
    _S90 = !isnan(k_black_0);
  } else {
    _S90 = false;
  }
  if (_S90) {
    _S90 = !isinf(k_black_0);
  } else {
    _S90 = false;
  }
  if (_S90) {
    _S90 = !isnan(k_white_0);
  } else {
    _S90 = false;
  }
  if (_S90) {
    _S90 = !isinf(k_white_0);
  } else {
    _S90 = false;
  }
  uint _S91;
  if (_S90) {
    _S91 = 1U;
  } else {
    _S91 = 0U;
  }
  valid_4 = _S91;
  return;
}

float rdr2_test31_renodx_tonemap_psychov_psycho29_FaceSupportRatio_0(float normalized_yf_0, vec3 black_pressure_0, vec3 white_pressure_0, float q_2) {
  vec3 terms_black_0 = black_pressure_0 / max(normalized_yf_0, 9.99999997475242708e-07);
  vec3 terms_white_0 = white_pressure_0 / max(1.0 - normalized_yf_0, 9.99999997475242708e-07);
  float _S92 = max(max(max(terms_black_0.x, terms_black_0.y), terms_black_0.z), max(max(terms_white_0.x, terms_white_0.y), terms_white_0.z));
  if (!(_S92 > 0.0)) {
    return 1.0;
  }
  if (q_2 >= 2048.0) {
    return 1.0;
  }
  vec3 _S93 = vec3(q_2, q_2, q_2);
  vec3 powers_black_0 = pow(terms_black_0 / _S92, _S93);
  vec3 powers_white_0 = pow(terms_white_0 / _S92, _S93);
  return pow(max(powers_black_0.x + powers_black_0.y + powers_black_0.z + powers_white_0.x + powers_white_0.y + powers_white_0.z, 9.99999997475242708e-07), -rdr2_test31_rcp_0(q_2));
}

float rdr2_test31_renodx_tonemap_psychov_psycho29_PerHueSupportQ_0(vec3 black_pressure_1, vec3 white_pressure_1, float face_gap_0) {
  float _S94 = 1.0 - clamp(face_gap_0, 0.00009999999747379, 0.5);
  float required_q_0 = 2.0;
  int candidate_index_0 = 0;
  [[unroll]]
  for (;;) {
    if (candidate_index_0 < 10) {
    } else {
      break;
    }
    float normalized_yf_1;
    if (candidate_index_0 > 0) {
      int crossing_index_0 = candidate_index_0 - 1;
      int _S95 = crossing_index_0 / 3;
      float denominator_1 = black_pressure_1[_S95] + white_pressure_1[crossing_index_0 % 3];
      if (!(denominator_1 > 9.99999997475242708e-07)) {
        candidate_index_0 = candidate_index_0 + 1;
        continue;
      }
      normalized_yf_1 = black_pressure_1[_S95] / denominator_1;
    } else {
      normalized_yf_1 = 0.5;
    }
    bool _S96;
    if (normalized_yf_1 > 0.0) {
      _S96 = normalized_yf_1 < 1.0;
    } else {
      _S96 = false;
    }
    bool _S97;
    if (!_S96) {
      _S97 = true;
    } else {
      _S97 = (rdr2_test31_renodx_tonemap_psychov_psycho29_FaceSupportRatio_0(normalized_yf_1, black_pressure_1, white_pressure_1, 2.0)) >= _S94;
    }
    if (_S97) {
      candidate_index_0 = candidate_index_0 + 1;
      continue;
    }
    if ((rdr2_test31_renodx_tonemap_psychov_psycho29_FaceSupportRatio_0(normalized_yf_1, black_pressure_1, white_pressure_1, 2048.0)) < _S94) {
      required_q_0 = 2048.0;
      candidate_index_0 = candidate_index_0 + 1;
      continue;
    }
    float lo_0 = 2.0;
    float hi_0 = 2048.0;
    int i_1 = 0;
    [[unroll]]
    for (;;) {
      if (i_1 < 12) {
      } else {
        break;
      }
      float mid_0 = 0.5 * (lo_0 + hi_0);
      if ((rdr2_test31_renodx_tonemap_psychov_psycho29_FaceSupportRatio_0(normalized_yf_1, black_pressure_1, white_pressure_1, mid_0)) >= _S94) {
        hi_0 = mid_0;
      } else {
        lo_0 = mid_0;
      }
      i_1 = i_1 + 1;
    }
    required_q_0 = max(required_q_0, hi_0);
    candidate_index_0 = candidate_index_0 + 1;
  }
  return required_q_0;
}

float rdr2_test31_renodx_tonemap_psychov_psycho29_LqNorm_0(vec3 values_1, float q_3) {
  float _S98 = max(max(values_1.x, values_1.y), values_1.z);
  if (!(_S98 > 0.0)) {
    return 0.0;
  }
  if (q_3 >= 2048.0) {
    return _S98;
  }
  vec3 powers_1 = pow(values_1 / _S98, vec3(q_3, q_3, q_3));
  return _S98 * pow(max(powers_1.x + powers_1.y + powers_1.z, 9.99999997475242708e-07), rdr2_test31_rcp_0(q_3));
}

void rdr2_test31_renodx_tonemap_psychov_psycho29_LqSupportScales_0(vec2 direction_6, vec3 peak_lms_5, mat3x3 lms_to_target_2, float target_rgb_peak_5, float fixed_q_0, float dynamic_face_gap_0, float dynamic_mix_0, float generalized_mix_0, out float q_4, out float k_black_1, out float k_white_1, out uint valid_5) {
  float dynamic_weight_0 = rdr2_test31_saturate_0(dynamic_mix_0);
  float generalized_weight_0 = rdr2_test31_saturate_0(generalized_mix_0);
  q_4 = mix(2.0, clamp(fixed_q_0, 2.0, 2048.0), generalized_weight_0);
  if (generalized_weight_0 <= 0.0) {
    rdr2_test31_renodx_tonemap_psychov_psycho29_NeutwoSupportScales_0(direction_6, peak_lms_5, lms_to_target_2, target_rgb_peak_5, k_black_1, k_white_1, valid_5);
    return;
  }
  vec3 a_rgb_2;
  vec3 rho_rgb_2;
  rdr2_test31_renodx_tonemap_psychov_psycho29_TargetARCoefficients_0(direction_6, peak_lms_5, lms_to_target_2, target_rgb_peak_5, a_rgb_2, rho_rgb_2);
  vec3 smooth_abs_1 = sqrt(rho_rgb_2 * rho_rgb_2 + vec3(9.999999960041972e-13, 9.999999960041972e-13, 9.999999960041972e-13));
  const vec3 _S99 = vec3(0.0, 0.0, 0.0);
  vec3 white_pressure_2 = max(0.5 * (smooth_abs_1 + rho_rgb_2), _S99);
  vec3 black_pressure_2 = max(0.5 * (smooth_abs_1 - rho_rgb_2), _S99);
  if (dynamic_weight_0 > 0.0) {
    q_4 = mix(q_4, mix(2.0, rdr2_test31_renodx_tonemap_psychov_psycho29_PerHueSupportQ_0(black_pressure_2, white_pressure_2, dynamic_face_gap_0), generalized_weight_0), dynamic_weight_0);
  }
  vec3 white_pressure_3;
  vec3 black_pressure_3;
  if (q_4 >= 2048.0) {
    vec3 _S100 = max(-rho_rgb_2, _S99);
    white_pressure_3 = max(rho_rgb_2, _S99);
    black_pressure_3 = _S100;
  } else {
    white_pressure_3 = white_pressure_2;
    black_pressure_3 = black_pressure_2;
  }
  k_white_1 = rdr2_test31_rcp_0(max(rdr2_test31_renodx_tonemap_psychov_psycho29_LqNorm_0(white_pressure_3, q_4), 9.99999997475242708e-07));
  k_black_1 = rdr2_test31_rcp_0(max(rdr2_test31_renodx_tonemap_psychov_psycho29_LqNorm_0(black_pressure_3, q_4), 9.99999997475242708e-07));
  bool _S101;
  if (!(any(bvec3((isnan(a_rgb_2)))))) {
    _S101 = !(any(bvec3((isinf(a_rgb_2)))));
  } else {
    _S101 = false;
  }
  if (_S101) {
    _S101 = !(any(bvec3((isnan(rho_rgb_2)))));
  } else {
    _S101 = false;
  }
  if (_S101) {
    _S101 = !(any(bvec3((isinf(rho_rgb_2)))));
  } else {
    _S101 = false;
  }
  if (_S101) {
    _S101 = q_4 >= 2.0;
  } else {
    _S101 = false;
  }
  if (_S101) {
    _S101 = !isnan(q_4);
  } else {
    _S101 = false;
  }
  if (_S101) {
    _S101 = !isinf(q_4);
  } else {
    _S101 = false;
  }
  if (_S101) {
    _S101 = k_black_1 > 0.0;
  } else {
    _S101 = false;
  }
  if (_S101) {
    _S101 = k_white_1 > 0.0;
  } else {
    _S101 = false;
  }
  if (_S101) {
    _S101 = !isnan(k_black_1);
  } else {
    _S101 = false;
  }
  if (_S101) {
    _S101 = !isinf(k_black_1);
  } else {
    _S101 = false;
  }
  if (_S101) {
    _S101 = !isnan(k_white_1);
  } else {
    _S101 = false;
  }
  if (_S101) {
    _S101 = !isinf(k_white_1);
  } else {
    _S101 = false;
  }
  uint _S102;
  if (_S101) {
    _S102 = 1U;
  } else {
    _S102 = 0U;
  }
  valid_5 = _S102;
  return;
}

float rdr2_test31_renodx_tonemap_Neutwo_0(float x_13, float peak_3) {
  return peak_3 * x_13 * (inversesqrt((fma(x_13, x_13, peak_3 * peak_3))));
}

float rdr2_test31_renodx_tonemap_psychov_psycho29_LqSupportRadius_0(float normalized_yf_2, float k_black_2, float k_white_2, float q_5) {
  float _S103 = rdr2_test31_saturate_0(normalized_yf_2);
  float black_support_0 = k_black_2 * _S103;
  float white_support_0 = k_white_2 * (1.0 - _S103);
  bool _S104;
  if (!(black_support_0 > 0.0)) {
    _S104 = true;
  } else {
    _S104 = !(white_support_0 > 0.0);
  }
  if (_S104) {
    return 0.0;
  }
  if (q_5 >= 2048.0) {
    return min(black_support_0, white_support_0);
  }
  if ((abs(q_5 - 2.0)) <= 9.99999997475242708e-07) {
    return rdr2_test31_renodx_tonemap_Neutwo_0(black_support_0, white_support_0);
  }
  float inverse_black_0 = rdr2_test31_rcp_0(black_support_0);
  float inverse_white_0 = rdr2_test31_rcp_0(white_support_0);
  float _S105 = max(inverse_black_0, inverse_white_0);
  return rdr2_test31_rcp_0(_S105 * pow(max(pow(inverse_black_0 / _S105, q_5) + pow(inverse_white_0 / _S105, q_5), 9.99999997475242708e-07), rdr2_test31_rcp_0(q_5)));
}

float rdr2_test31_renodx_tonemap_psychov_psycho29_EvaluateYfCandidate_0(float candidate_yf_0, float desired_c0_0, float desired_rho_0, vec2 yf_coefficients_0, float k_black_3, float k_white_3, float q_6, out float candidate_c0_0, out float candidate_rho_0) {
  float A_1 = rdr2_test31_saturate_0(candidate_yf_0);
  float _S106 = yf_coefficients_0.x;
  float inverse_axis_0 = rdr2_test31_rcp_0(rdr2_test31_renodx_math_CopySign_1(max(abs(_S106), 9.99999997475242708e-07), _S106));
  float _S107 = yf_coefficients_0.y;
  float k_1 = _S107 * inverse_axis_0;
  float _S108 = clamp((k_1 * (A_1 * inverse_axis_0 - desired_c0_0) + desired_rho_0) / (k_1 * k_1 + 1.0), 0.0, rdr2_test31_renodx_tonemap_psychov_psycho29_LqSupportRadius_0(A_1, k_black_3, k_white_3, q_6));
  candidate_rho_0 = _S108;
  float _S109 = (A_1 - _S107 * _S108) * inverse_axis_0;
  candidate_c0_0 = _S109;
  float delta_c0_0 = _S109 - desired_c0_0;
  float delta_rho_0 = candidate_rho_0 - desired_rho_0;
  return delta_c0_0 * delta_c0_0 + delta_rho_0 * delta_rho_0;
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho29_LqYfCeilingSolve_0(vec3 desired_coord_1, float response_yf_5, vec3 peak_lms_6, mat3x3 lms_to_target_3, float target_rgb_peak_6, float fixed_q_1, float dynamic_face_gap_1, float dynamic_mix_1, float generalized_mix_1, out uint valid_6) {
  bool _S110;
  if (!(any(bvec3((isnan(desired_coord_1)))))) {
    _S110 = !(any(bvec3((isinf(desired_coord_1)))));
  } else {
    _S110 = false;
  }
  if (_S110) {
    _S110 = !isnan(response_yf_5);
  } else {
    _S110 = false;
  }
  if (_S110) {
    _S110 = !isinf(response_yf_5);
  } else {
    _S110 = false;
  }
  uint _S111;
  if (_S110) {
    _S111 = 1U;
  } else {
    _S111 = 0U;
  }
  valid_6 = _S111;
  if (_S111 == 0U) {
    return vec3(0.0, 0.0, 0.0);
  }
  vec2 _S112 = desired_coord_1.xz;
  float desired_rho2_0 = dot(_S112, _S112);
  float desired_rho_1 = sqrt(max(desired_rho2_0, 0.0));
  vec2 direction_7;
  if (desired_rho2_0 > 9.999999960041972e-13) {
    direction_7 = _S112 * (inversesqrt((desired_rho2_0)));
  } else {
    direction_7 = vec2(1.0, 0.0);
  }
  vec2 yf_coefficients_1 = rdr2_test31_renodx_tonemap_psychov_psycho29_OrthonormalYfCoefficients_0(direction_7, peak_lms_6);
  float k_black_4;
  float k_white_4;
  float q_7;
  uint support_valid_0;
  rdr2_test31_renodx_tonemap_psychov_psycho29_LqSupportScales_0(direction_7, peak_lms_6, lms_to_target_3, target_rgb_peak_6, fixed_q_1, dynamic_face_gap_1, dynamic_mix_1, generalized_mix_1, q_7, k_black_4, k_white_4, support_valid_0);
  if (support_valid_0 == 0U) {
    valid_6 = 0U;
    return vec3(0.0, 0.0, 0.0);
  }
  float max_a_0 = rdr2_test31_saturate_0(response_yf_5);
  float best_cost_0 = 3.4028234663852886e+38;
  int best_index_0 = 0;
  int i_2 = 0;
  [[dont_unroll]]
  for (;;) {
    if (i_2 <= 32) {
    } else {
      break;
    }
    float candidate_c0_1;
    float candidate_rho_1;
    float cost_0 = rdr2_test31_renodx_tonemap_psychov_psycho29_EvaluateYfCandidate_0(max_a_0 * (float(i_2) / 32.0), desired_coord_1.y, desired_rho_1, yf_coefficients_1, k_black_4, k_white_4, q_7, candidate_c0_1, candidate_rho_1);
    if (cost_0 < best_cost_0) {
      best_cost_0 = cost_0;
      best_index_0 = i_2;
    }
    i_2 = i_2 + 1;
  }
  float lo_1 = max_a_0 * (float(max(best_index_0 - 1, 0)) / 32.0);
  float hi_1 = max_a_0 * (float(min(best_index_0 + 1, 32)) / 32.0);
  float _S113 = 0.6180340051651001 * (hi_1 - lo_1);
  float x1_0 = hi_1 - _S113;
  float x2_0 = lo_1 + _S113;
  float _S114 = desired_coord_1.y;
  float c01_0;
  float rho1_0;
  float _S115 = rdr2_test31_renodx_tonemap_psychov_psycho29_EvaluateYfCandidate_0(x1_0, _S114, desired_rho_1, yf_coefficients_1, k_black_4, k_white_4, q_7, c01_0, rho1_0);
  float c02_0;
  float rho2_0;
  float _S116 = rdr2_test31_renodx_tonemap_psychov_psycho29_EvaluateYfCandidate_0(x2_0, _S114, desired_rho_1, yf_coefficients_1, k_black_4, k_white_4, q_7, c02_0, rho2_0);
  float f1_0 = _S115;
  float f2_0 = _S116;
  float x1_1 = x1_0;
  float x2_1 = x2_0;
  float hi_2 = hi_1;
  float lo_2 = lo_1;
  int iteration_0 = 0;
  [[unroll]]
  for (;;) {
    if (iteration_0 < 20) {
    } else {
      break;
    }
    if (f1_0 > f2_0) {
      c01_0 = c02_0;
      rho1_0 = rho2_0;
      float x2_2 = x1_1 + 0.6180340051651001 * (hi_2 - x1_1);
      float _S117 = rdr2_test31_renodx_tonemap_psychov_psycho29_EvaluateYfCandidate_0(x2_2, _S114, desired_rho_1, yf_coefficients_1, k_black_4, k_white_4, q_7, c02_0, rho2_0);
      float _S118 = x1_1;
      f1_0 = f2_0;
      f2_0 = _S117;
      x1_1 = x2_1;
      x2_1 = x2_2;
      lo_2 = _S118;
    } else {
      c02_0 = c01_0;
      rho2_0 = rho1_0;
      float x1_2 = x2_1 - 0.6180340051651001 * (x2_1 - lo_2);
      float _S119 = rdr2_test31_renodx_tonemap_psychov_psycho29_EvaluateYfCandidate_0(x1_2, _S114, desired_rho_1, yf_coefficients_1, k_black_4, k_white_4, q_7, c01_0, rho1_0);
      float _S120 = f1_0;
      float _S121 = x1_1;
      float _S122 = x2_1;
      f1_0 = _S119;
      f2_0 = _S120;
      x1_1 = x1_2;
      x2_1 = _S121;
      hi_2 = _S122;
    }
    iteration_0 = iteration_0 + 1;
  }
  float best_rho_0;
  float best_c0_0;
  if (f1_0 < f2_0) {
    best_rho_0 = rho1_0;
    best_c0_0 = c01_0;
  } else {
    best_rho_0 = rho2_0;
    best_c0_0 = c02_0;
  }
  float _S123 = max(best_rho_0, 0.0);
  vec3 solved_coord_1 = vec3(direction_7.x * _S123, best_c0_0, direction_7.y * _S123);
  if (!(any(bvec3((isnan(solved_coord_1)))))) {
    _S110 = !(any(bvec3((isinf(solved_coord_1)))));
  } else {
    _S110 = false;
  }
  if (_S110) {
    _S111 = 1U;
  } else {
    _S111 = 0U;
  }
  valid_6 = _S111;
  vec3 _S124;
  if (_S111 != 0U) {
    _S124 = solved_coord_1;
  } else {
    _S124 = vec3(0.0, 0.0, 0.0);
  }
  return _S124;
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho29_LMSFromOrthonormalConeCoord_0(vec3 coord_7, vec3 peak_lms_7) {
  float common_0 = coord_7.y * (inversesqrt((3.0)));
  float x_term_0 = coord_7.x * (inversesqrt((2.0)));
  float z_term_0 = coord_7.z * (inversesqrt((6.0)));
  return vec3(common_0 + x_term_0 - z_term_0, common_0 - x_term_0 - z_term_0, common_0 + 2.0 * z_term_0) * max(abs(peak_lms_7), vec3(9.99999997475242708e-07, 9.99999997475242708e-07, 9.99999997475242708e-07));
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho31_JointL4TargetEndpoint_0(vec3 coord_8, float response_yf_ceiling_5, int target_gamut_mode_9, float target_rgb_peak_7, out uint valid_7) {
  bool _S125 = target_gamut_mode_9 == 0;
  mat3x3 target_to_lms_0;
  if (_S125) {
    target_to_lms_0 = (((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))));
  } else {
    target_to_lms_0 = (((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))));
  }
  mat3x3 lms_to_target_4;
  if (_S125) {
    lms_to_target_4 = (((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297))));
  } else {
    lms_to_target_4 = (((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(1.71665120124816895, -0.35567077994346619, -0.25336629152297974, -0.66668432950973511, 1.61648118495941162, 0.01576854661107063, 0.01763985678553581, -0.04277061298489571, 0.94210314750671387))));
  }
  vec3 target_peak_lms_4 = (((vec3(target_rgb_peak_7, target_rgb_peak_7, target_rgb_peak_7)) * (target_to_lms_0)));
  vec3 solved_ortho_0 = rdr2_test31_renodx_tonemap_psychov_psycho29_LqYfCeilingSolve_0(rdr2_test31_renodx_tonemap_psychov_psycho29_OrthonormalConeCoordFromLMS_0(rdr2_test31_renodx_tonemap_psychov_psycho31_LMSFromTest30Coord_0(coord_8, target_rgb_peak_7), target_peak_lms_4), response_yf_ceiling_5, target_peak_lms_4, lms_to_target_4, target_rgb_peak_7, 4.0, 0.00999999977648258, 0.0, 1.0, valid_7);
  if (valid_7 == 0U) {
    return vec3(0.0);
  }
  vec3 normalized_lms_0 = rdr2_test31_renodx_tonemap_psychov_psycho29_LMSFromOrthonormalConeCoord_0(solved_ortho_0, target_peak_lms_4) / ((((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))) * target_rgb_peak_7);
  float _S126 = normalized_lms_0.x;
  float _S127 = normalized_lms_0.y;
  float _S128 = normalized_lms_0.z;
  vec3 solved_coord_2 = vec3(_S126 - _S127, _S126 + _S127 + _S128, 2.0 * _S128 - _S126 - _S127);
  bool _S129;
  if (!(any(bvec3((isnan(solved_coord_2)))))) {
    _S129 = !(any(bvec3((isinf(solved_coord_2)))));
  } else {
    _S129 = false;
  }
  uint _S130;
  if (_S129) {
    _S130 = 1U;
  } else {
    _S130 = 0U;
  }
  valid_7 = _S130;
  vec3 _S131;
  if (_S130 != 0U) {
    _S131 = solved_coord_2;
  } else {
    _S131 = vec3(0.0);
  }
  return _S131;
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho31_SourceCoordinateCage_0(vec3 desired_coord_2, vec3 anchored_source_rgb_4, mat3x3 source_to_lms_4, vec3 anchor_in_lms_7, vec3 adaptation_peak_ratio_2, float highlights_9, float shadows_9, float purity_delta_2, float response_power_5, float response_h_3, int target_gamut_mode_10, float target_rgb_peak_8, out uint valid_8) {
  valid_8 = 0U;
  vec3 source_yf_coefficients_1 = (((source_to_lms_4) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1])));
  float neutral_source_rgb_1 = dot(source_yf_coefficients_1, anchored_source_rgb_4) / dot(source_yf_coefficients_1, vec3(1.0, 1.0, 1.0));
  if (neutral_source_rgb_1 <= 9.99999997475242708e-07) {
    return vec3(0.0);
  }
  vec3 source_residual_1 = anchored_source_rgb_4 - neutral_source_rgb_1;
  const vec3 _S132 = vec3(0.0);
  float demand_scale_0 = rdr2_test31_renodx_math_Max_2(max(-source_residual_1 / neutral_source_rgb_1, _S132));
  if (demand_scale_0 <= 9.99999997475242708e-07) {
    return _S132;
  }
  float boundary_fraction_1 = rdr2_test31_rcp_0(demand_scale_0);
  bool _S133;
  if (boundary_fraction_1 <= 9.99999997475242708e-07) {
    _S133 = true;
  } else {
    _S133 = boundary_fraction_1 >= 1.00000002004087734e+20;
  }
  if (_S133) {
    _S133 = true;
  } else {
    _S133 = isnan(boundary_fraction_1);
  }
  if (_S133) {
    _S133 = true;
  } else {
    _S133 = isinf(boundary_fraction_1);
  }
  if (_S133) {
    return _S132;
  }
  vec3 neutral_q_0 = rdr2_test31_renodx_tonemap_psychov_psycho31_ResponseInputQ_0((((vec3(neutral_source_rgb_1, neutral_source_rgb_1, neutral_source_rgb_1)) * (source_to_lms_4))), anchor_in_lms_7, highlights_9, shadows_9, purity_delta_2);
  vec3 boundary_q_0 = rdr2_test31_renodx_tonemap_psychov_psycho31_ResponseInputQ_0((((neutral_source_rgb_1 + source_residual_1 * boundary_fraction_1) * (source_to_lms_4))), anchor_in_lms_7, highlights_9, shadows_9, purity_delta_2);
  if ((any(bvec3((lessThanEqual(neutral_q_0, vec3(0.0))))))) {
    _S133 = true;
  } else {
    _S133 = (any(bvec3((lessThanEqual(boundary_q_0, vec3(0.0))))));
  }
  if (_S133) {
    return _S132;
  }
  float neutral_response_yf_1;
  vec3 _S134 = rdr2_test31_renodx_tonemap_psychov_psycho30_MeanA2ResponseFromPositiveQ_0(neutral_q_0, adaptation_peak_ratio_2, response_power_5, response_h_3, neutral_response_yf_1);
  float boundary_response_yf_1;
  vec3 source_boundary_coord_1 = rdr2_test31_renodx_tonemap_psychov_psycho30_MeanA2ResponseFromPositiveQ_0(boundary_q_0, adaptation_peak_ratio_2, response_power_5, response_h_3, boundary_response_yf_1);
  uint target_endpoint_valid_1;
  vec3 target_endpoint_coord_1 = rdr2_test31_renodx_tonemap_psychov_psycho31_JointL4TargetEndpoint_0(source_boundary_coord_1, boundary_response_yf_1, target_gamut_mode_10, target_rgb_peak_8, target_endpoint_valid_1);
  if (target_endpoint_valid_1 == 0U) {
    return _S132;
  }
  float desired_a_1 = rdr2_test31_renodx_tonemap_psychov_psycho31_YfFromTest30Coord_0(desired_coord_2);
  float source_chord_a_1 = rdr2_test31_renodx_tonemap_psychov_psycho31_YfFromTest30Coord_0(source_boundary_coord_1) - neutral_response_yf_1;
  float _S135 = source_boundary_coord_1.x;
  float _S136 = source_boundary_coord_1.z;
  float source_chord_length2_0 = 0.5 * _S135 * _S135 + _S136 * _S136 / 6.0 + source_chord_a_1 * source_chord_a_1;
  if (source_chord_length2_0 <= 9.999999960041972e-13) {
    return _S132;
  }
  float response_progress_0 = rdr2_test31_saturate_0((0.5 * desired_coord_2.x * _S135 + desired_coord_2.z * _S136 / 6.0 + (desired_a_1 - neutral_response_yf_1) * source_chord_a_1) / source_chord_length2_0);
  vec3 mapped_coord_2 = rdr2_test31_renodx_tonemap_psychov_psycho31_Test30CoordFromDTA_0(response_progress_0 * target_endpoint_coord_1.x, response_progress_0 * target_endpoint_coord_1.z, mix(neutral_response_yf_1, rdr2_test31_renodx_tonemap_psychov_psycho31_YfFromTest30Coord_0(target_endpoint_coord_1), response_progress_0));
  if (!(any(bvec3((isnan(mapped_coord_2)))))) {
    _S133 = !(any(bvec3((isinf(mapped_coord_2)))));
  } else {
    _S133 = false;
  }
  uint _S137;
  if (_S133) {
    _S137 = 1U;
  } else {
    _S137 = 0U;
  }
  valid_8 = _S137;
  vec3 _S138;
  if (_S137 != 0U) {
    _S138 = mapped_coord_2;
  } else {
    _S138 = _S132;
  }
  return _S138;
}

vec3 rdr2_test31_renodx_tonemap_psychov_psycho31_FixedYfL4TargetEndpoint_0(vec3 coord_9, float response_yf_ceiling_6, int target_gamut_mode_11, out float normalized_demand_6) {
  normalized_demand_6 = 0.0;
  float mapped_a_2 = clamp(rdr2_test31_renodx_tonemap_psychov_psycho31_YfFromTest30Coord_0(coord_9), 0.0, clamp(response_yf_ceiling_6, 0.0, 1.0));
  float _S139 = coord_9.x;
  float _S140 = coord_9.z;
  float radial_length_1 = sqrt(0.5 * _S139 * _S139 + _S140 * _S140 / 6.0);
  bool _S141;
  if (mapped_a_2 <= 0.0) {
    _S141 = true;
  } else {
    _S141 = mapped_a_2 >= 1.0;
  }
  if (_S141) {
    _S141 = true;
  } else {
    _S141 = radial_length_1 <= 9.99999997475242708e-07;
  }
  if (_S141) {
    return rdr2_test31_renodx_tonemap_psychov_psycho31_Test30CoordFromDTA_0(0.0, 0.0, mapped_a_2);
  }
  float inverse_radial_length_1 = rdr2_test31_rcp_0(radial_length_1);
  float normalized_d_1 = _S139 * inverse_radial_length_1;
  float normalized_t_1 = _S140 * inverse_radial_length_1;
  vec3 radial_rgb_2;
  if (target_gamut_mode_11 == 0) {
    radial_rgb_2 = normalized_d_1 * (((vec3(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x, -(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y, -0.5 * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) - mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297))))))) + normalized_t_1 * (((vec3(0.0, 0.0, 0.5 * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297)))))));
  } else {
    radial_rgb_2 = normalized_d_1 * (((vec3(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x, -(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y, -0.5 * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][0] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).x / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))))) - mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311) [1][1] * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).y / dot(mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1], (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))))) * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(1.71665120124816895, -0.35567077994346619, -0.25336629152297974, -0.66668432950973511, 1.61648118495941162, 0.01576854661107063, 0.01763985678553581, -0.04277061298489571, 0.94210314750671387))))))) + normalized_t_1 * (((vec3(0.0, 0.0, 0.5 * (((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))).z)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(1.71665120124816895, -0.35567077994346619, -0.25336629152297974, -0.66668432950973511, 1.61648118495941162, 0.01576854661107063, 0.01763985678553581, -0.04277061298489571, 0.94210314750671387)))))));
  }
  const vec3 _S142 = vec3(0.0);
  vec3 upper_demand_1 = max(radial_rgb_2, _S142) / (1.0 - mapped_a_2);
  vec3 lower_demand_1 = max(-radial_rgb_2, _S142) / mapped_a_2;
  float _S143 = max(rdr2_test31_renodx_math_Max_2(upper_demand_1), rdr2_test31_renodx_math_Max_2(lower_demand_1));
  if (_S143 <= 9.99999997475242708e-07) {
    return rdr2_test31_renodx_tonemap_psychov_psycho31_Test30CoordFromDTA_0(0.0, 0.0, mapped_a_2);
  }
  vec3 normalized_upper_0 = upper_demand_1 / _S143;
  vec3 normalized_lower_9 = lower_demand_1 / _S143;
  vec3 _S144 = normalized_upper_0 * normalized_upper_0;
  vec3 _S145 = normalized_lower_9 * normalized_lower_9;
  float support_2 = rdr2_test31_rcp_0(_S143 * sqrt(sqrt(dot(_S144, _S144) + dot(_S145, _S145))));
  normalized_demand_6 = radial_length_1 / support_2;
  float _S146 = min(radial_length_1, support_2);
  return rdr2_test31_renodx_tonemap_psychov_psycho31_Test30CoordFromDTA_0(normalized_d_1 * _S146, normalized_t_1 * _S146, mapped_a_2);
}

vec3 rdr2_test31_renodx_tonemap_psychov_psychotm_test31_0(vec3 bt709_linear_input_2, float peak_value_2, float exposure_2, float highlights_10, float shadows_10, float contrast_7, float purity_scale_6, float bleaching_intensity_0, float clip_point_0, float hue_restore_0, float encoded_response_power_0, int white_curve_mode_0, float cone_response_exponent_0, vec3 current_adaptive_state_bt709_2, vec3 current_background_state_bt709_2, float gamut_compression_1, int gamut_compression_mode_1, float adaptive_normalization_0, float compression_4, int source_boundary_2, float source_awareness_1, float yf_support_q_0, float yf_dynamic_face_gap_0, float yf_dynamic_mix_0, float yf_generalized_mix_0) {
  vec3 exposed_input_2 = bt709_linear_input_2 * exposure_2;
  vec3 anchored_source_rgb_5 = exposed_input_2;
  bool _S147;
  vec3 input_lms_2;
  mat3x3 source_to_lms_5;
  if (source_boundary_2 == 0) {
    input_lms_2 = (((exposed_input_2) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))));
    source_to_lms_5 = (((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))));
  } else {
    if (source_boundary_2 == 2) {
      vec3 source_rgb_6 = (((exposed_input_2) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(1.71665120124816895, -0.35567077994346619, -0.25336629152297974, -0.66668432950973511, 1.61648118495941162, 0.01576854661107063, 0.01763985678553581, -0.04277061298489571, 0.94210314750671387)))))));
      if ((all(bvec3((lessThanEqual(source_rgb_6, vec3(0.0))))))) {
        _S147 = !(any(bvec3((isinf(source_rgb_6)))));
      } else {
        _S147 = false;
      }
      if (_S147) {
        return vec3(0.0, 0.0, 0.0);
      }
      vec3 _S148 = rdr2_test31_renodx_tonemap_psychov_psycho30_AnchorSourceBoundaryToYf_0(source_rgb_6, (((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))), max(((((((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)) / (max(((((((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).x + max(((((((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).y + max(((((((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).z), anchored_source_rgb_5);
      input_lms_2 = _S148;
      source_to_lms_5 = (((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))));
    } else {
      if (source_boundary_2 == 3) {
        vec3 source_rgb_7 = (((exposed_input_2) * (mat3x3(0.6130974292755127, 0.33952313661575317, 0.04737945273518562, 0.07019372284412384, 0.91635388135910034, 0.01345239859074354, 0.0206155925989151, 0.10956977307796478, 0.86981463432312012))));
        if ((all(bvec3((lessThanEqual(source_rgb_7, vec3(0.0))))))) {
          _S147 = !(any(bvec3((isinf(source_rgb_7)))));
        } else {
          _S147 = false;
        }
        if (_S147) {
          return vec3(0.0, 0.0, 0.0);
        }
        vec3 _S149 = rdr2_test31_renodx_tonemap_psychov_psycho30_AnchorSourceBoundaryToYf_0(source_rgb_7, ((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))), max((((((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)) / (max((((((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).x + max((((((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).y + max((((((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).z), anchored_source_rgb_5);
        input_lms_2 = _S149;
        source_to_lms_5 = ((((((mat3x3(0.66245418787002563, 0.13400420546531677, 0.15618768334388733, 0.27222871780395508, 0.67408174276351929, 0.05368951708078384, -0.00557464966550469, 0.00406073359772563, 1.01033914089202881)) * (mat3x3(0.98722398281097412, -0.00611322838813066, 0.01595328748226166, -0.00759837171062827, 1.00186145305633545, 0.00533003592863679, 0.00307257706299424, -0.00509596150368452, 1.08168065547943115))))) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))));
      } else {
        if ((all(bvec3((lessThanEqual(exposed_input_2, vec3(0.0))))))) {
          _S147 = !(any(bvec3((isinf(exposed_input_2)))));
        } else {
          _S147 = false;
        }
        if (_S147) {
          return vec3(0.0, 0.0, 0.0);
        }
        vec3 _S150 = rdr2_test31_renodx_tonemap_psychov_psycho30_AnchorSourceBoundaryToYf_0(exposed_input_2, (((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))), max(((((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)) / (max(((((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).x + max(((((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).y + max(((((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))) * (mat3x3(1.94735467433929443, -1.4144512414932251, 0.36476325988769531, 0.68990272283554077, 0.34832188487052917, 0.0, 0.0, 0.0, 1.93485343456268311)[1]))), vec3(0.0)).z), anchored_source_rgb_5);
        input_lms_2 = _S150;
        source_to_lms_5 = (((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))));
      }
    }
  }
  vec3 anchor_in_lms_8 = (((current_adaptive_state_bt709_2) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))));
  vec3 anchor_out_lms_7;
  if ((all(bvec3((equal(current_background_state_bt709_2, current_adaptive_state_bt709_2)))))) {
    anchor_out_lms_7 = anchor_in_lms_8;
  } else {
    anchor_out_lms_7 = (((current_background_state_bt709_2) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416)))))));
  }
  float response_power_6 = contrast_7 * cone_response_exponent_0;
  float purity_delta_3 = purity_scale_6 / contrast_7;
  vec3 response_input_q_0 = rdr2_test31_renodx_tonemap_psychov_psycho31_ResponseInputQ_0(input_lms_2, anchor_in_lms_8, highlights_10, shadows_10, purity_delta_3);
  float response_h_4;
  if (compression_4 == 0.0) {
    response_h_4 = rdr2_test31_renodx_tonemap_psychov_psycho30_AutoCompressionPower_0(rdr2_test31_renodx_color_yf_from_LMS_0(anchor_out_lms_7), rdr2_test31_renodx_tonemap_psychov_psycho30_TargetNeutralYfLimit_0(peak_value_2, anchor_in_lms_8, gamut_compression_mode_1));
  } else {
    response_h_4 = compression_4;
  }
  if ((any(bvec3((lessThanEqual(response_input_q_0, vec3(0.0))))))) {
    return (((rdr2_test31_renodx_tonemap_psychov_psycho30_LinearA2Fallback_0(response_input_q_0, anchor_in_lms_8, anchor_out_lms_7, gamut_compression_mode_1, peak_value_2, response_power_6, response_h_4, gamut_compression_1)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297)))))));
  }
  vec3 adaptation_peak_ratio_3 = anchor_out_lms_7 / ((((vec3(1.0, 1.0, 1.0)) * ((((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))))))) * peak_value_2);
  float response_yf_6;
  vec3 desired_test30_coord_1 = rdr2_test31_renodx_tonemap_psychov_psycho30_MeanA2ResponseFromPositiveQ_0(response_input_q_0, adaptation_peak_ratio_3, response_power_6, response_h_4, response_yf_6);
  if (gamut_compression_1 == 0.0) {
    return (((rdr2_test31_renodx_tonemap_psychov_psycho31_LMSFromTest30Coord_0(desired_test30_coord_1, peak_value_2)) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297)))))));
  }
  vec3 desired_lms_2 = rdr2_test31_renodx_tonemap_psychov_psycho31_LMSFromTest30Coord_0(desired_test30_coord_1, peak_value_2);
  float source_weight_1;
  if (source_boundary_2 != 0) {
    source_weight_1 = rdr2_test31_saturate_0(source_awareness_1);
  } else {
    source_weight_1 = 0.0;
  }
  const vec3 _S151 = vec3(0.0);
  bool _S152 = source_weight_1 != 0.0;
  vec3 source_aware_test30_coord_1;
  if (_S152) {
    uint cage_valid_1;
    vec3 cage_test30_coord_1 = rdr2_test31_renodx_tonemap_psychov_psycho31_SourceCoordinateCage_0(desired_test30_coord_1, anchored_source_rgb_5, source_to_lms_5, anchor_in_lms_8, adaptation_peak_ratio_3, highlights_10, shadows_10, purity_delta_3, response_power_6, response_h_4, gamut_compression_mode_1, peak_value_2, cage_valid_1);
    if (cage_valid_1 != 0U) {
      source_aware_test30_coord_1 = cage_test30_coord_1;
    } else {
      uint direct_target_valid_0;
      vec3 _S153 = rdr2_test31_renodx_tonemap_psychov_psycho31_JointL4TargetEndpoint_0(desired_test30_coord_1, response_yf_6, gamut_compression_mode_1, peak_value_2, direct_target_valid_0);
      if (direct_target_valid_0 == 0U) {
        float unused_desired_target_demand_0;
        source_aware_test30_coord_1 = rdr2_test31_renodx_tonemap_psychov_psycho31_FixedYfL4TargetEndpoint_0(desired_test30_coord_1, response_yf_6, gamut_compression_mode_1, unused_desired_target_demand_0);
      } else {
        source_aware_test30_coord_1 = _S153;
      }
    }
  } else {
    source_aware_test30_coord_1 = _S151;
  }
  vec3 mapped_lms_1;
  if (source_weight_1 == 1.0) {
    mapped_lms_1 = rdr2_test31_renodx_tonemap_psychov_psycho31_LMSFromTest30Coord_0(source_aware_test30_coord_1, peak_value_2);
  } else {
    bool _S154 = gamut_compression_mode_1 == 0;
    mat3x3 target_to_lms_1;
    if (_S154) {
      target_to_lms_1 = (((mat3x3(0.41239079833030701, 0.35758432745933533, 0.18048079311847687, 0.21263900399208069, 0.71516865491867065, 0.07219231873750687, 0.01933081820607185, 0.11919478327035904, 0.95053213834762573)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))));
    } else {
      target_to_lms_1 = (((mat3x3(0.63695806264877319, 0.14461690187454224, 0.16888096928596497, 0.26270020008087158, 0.67799806594848633, 0.0593017153441906, 0.0, 0.02807269245386124, 1.06098508834838867)) * (mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))));
    }
    mat3x3 lms_to_target_5;
    if (_S154) {
      lms_to_target_5 = (((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297))));
    } else {
      lms_to_target_5 = (((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(1.71665120124816895, -0.35567077994346619, -0.25336629152297974, -0.66668432950973511, 1.61648118495941162, 0.01576854661107063, 0.01763985678553581, -0.04277061298489571, 0.94210314750671387))));
    }
    vec3 target_peak_lms_5 = (((vec3(peak_value_2, peak_value_2, peak_value_2)) * (target_to_lms_1)));
    uint solve_valid_1;
    vec3 solved_coord_3 = rdr2_test31_renodx_tonemap_psychov_psycho29_LqYfCeilingSolve_0(rdr2_test31_renodx_tonemap_psychov_psycho29_OrthonormalConeCoordFromLMS_0(desired_lms_2, target_peak_lms_5), response_yf_6, target_peak_lms_5, lms_to_target_5, peak_value_2, yf_support_q_0, yf_dynamic_face_gap_0, yf_dynamic_mix_0, yf_generalized_mix_0, solve_valid_1);
    if (solve_valid_1 == 0U) {
      return vec3(0.0, 0.0, 0.0);
    }
    vec3 mapped_lms_2 = rdr2_test31_renodx_tonemap_psychov_psycho29_LMSFromOrthonormalConeCoord_0(solved_coord_3, target_peak_lms_5);
    if (_S152) {
      mapped_lms_1 = mix(mapped_lms_2, rdr2_test31_renodx_tonemap_psychov_psycho31_LMSFromTest30Coord_0(source_aware_test30_coord_1, peak_value_2), vec3(source_weight_1));
    } else {
      mapped_lms_1 = mapped_lms_2;
    }
  }
  vec3 output_bt709_2 = (((mix(desired_lms_2, mapped_lms_1, vec3(gamut_compression_1))) * ((((rdr2_test31_renodx_math_Invert3x3_0(mat3x3(0.26705029606819153, 0.84719902276992798, -0.03470416739583015, -0.38706883788108826, 1.16542994976043701, 0.10302286595106125, 0.02672779373824596, -0.02729131653904915, 0.53332674503326416))) * (mat3x3(3.24096989631652832, -1.53738319873809814, -0.49861076474189758, -0.96924364566802979, 1.87596750259399414, 0.04155505821108818, 0.05563008040189743, -0.20397695899009705, 1.05697154998779297)))))));
  if (!(any(bvec3((isnan(output_bt709_2)))))) {
    _S147 = !(any(bvec3((isinf(output_bt709_2)))));
  } else {
    _S147 = false;
  }
  if (_S147) {
    input_lms_2 = output_bt709_2;
  } else {
    input_lms_2 = vec3(0.0, 0.0, 0.0);
  }
  return input_lms_2;
}

#define custom_psychotm_test31    rdr2_test31_renodx_tonemap_psychov_custom_psychotm_test31_0
#define custom_psychograde_test31 rdr2_test31_renodx_tonemap_psychov_custom_psychograde_test31_0
#define psychotm_test31           rdr2_test31_renodx_tonemap_psychov_psychotm_test31_0
#define CompressBT2020Radial      rdr2_test31_CompressBT2020Radial_0
#define CompressXYZRadial         rdr2_test31_CompressXYZRadial_0
#define CompressLMSRadial         rdr2_test31_CompressLMSRadial_0

#endif
