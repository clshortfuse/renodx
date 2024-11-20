/// Inverse of the Reinhard tonemapping function used in RDR1.
///
/// Reconstructs the original linear HDR value from its Extended Reinhard
/// tone-mapped result.
/// Uses the positive root for a valid HDR value.
///
/// @param x - The tone-mapped value.
/// @param whitePoint - The white point scaling factor.
/// @return The original linear HDR value.
float RDR1ReinardInverse(float x, float whitePoint) {
  // Calculate the two roots of the inverse
  float term1 = 0.5 * (whitePoint * x - whitePoint);
  float term2 = 0.5 * sqrt(whitePoint) * sqrt((whitePoint * x * x) - (2.0 * whitePoint * x) + whitePoint + 4.0 * x);

  // Use the positive root, as it's the physically meaningful solution
  return term1 + term2;
}

/// Computes the mid-gray point for the Reinhard tonemapping function.
///
/// This function calculates the linear HDR input value that corresponds to the
/// standard scene referred mid-gray (18%) in the Reinhard tone-mapped space.
/// This value is crucial for aligning the mid-gray points of untonemapped and
/// Reinhard-tonemapped images during blending.
///
/// @param whitePoint - The white point scaling factor used in the tonemapping.
/// @return The linear HDR mid-gray value.
float RDR1ReinhardMidgray(float whitePoint) {
  return RDR1ReinardInverse(0.18, whitePoint);
}

/// Computes the scale factor for aligning mid-gray levels in RDR1.
///
/// This function returns a scaling factor to map the untonemapped image's scene referred
/// mid-gray to align with the Reinhard tone-mapped's scene referred mid-gray. 
/// This ensures that the blended result retains the original game's visual art direction
/// while enabling HDR highlights.
///
/// @param whitePoint - The white point scaling factor used in the tonemapping.
/// @return The scale factor for aligning mid-gray levels.
float RDR1ReinhardMidgrayScale(float whitePoint) {
  return RDR1ReinhardMidgray(whitePoint) / 0.18;
}
