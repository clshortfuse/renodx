float uncharted2GetLinearWhite(float x, float A, float B, float C, float D, float E, float F) {
  float part1 = ((B * C * F) - (B * E) - (B * F * x)) /
    (2.f * A * (E + F * x - F));
  float part2 = (sqrt((- (B * C * F) + (B * E) + (B * F * x)) * (- (B * C * F) + (B * E) + (B * F * x)) - (4.f * D * F * F * x * ((A * E) + (A * F * x) - (A * F))))) /
  (2.f * A * (E + F * x - F));
  return part1 - part2;
}

float3 uncharted2(float3 color, float3 x, float A = 0.22f, float B = 0.3f, float C = 0.1f, float D = 0.2f, float E = 0.01, float F = 0.3f, float W = 11.2f){
  return renodx::tonemap::ApplyCurve(color, A, B, C, D, E, F) / renodx::tonemap::ApplyCurve(W, A, B, C, D, E, F);
}

float3 uncharted2Extended(float3 x, float A = 0.22f, float B = 0.3f, float C = 0.1f, float D = 0.2f, float E = 0.01, float F = 0.3f, float linear_white = 11.2f){
  float3 numerator = mad(x, mad(A, x, C * B), D * E);  // x * (a * x + c * b) + d * e
  float3 denominator = mad(x, mad(A, x, B), D * F);    // x * (a * x + b) + d * f

  float numerator_white = mad(linear_white, mad(A, linear_white, C * B), D * E);
  float denominator_white = mad(linear_white, mad(A, linear_white, B), D * F);

  float e_over_f = E / F;

  float3 curve_x = (numerator / denominator) - e_over_f;
  float curve_white = (numerator_white / denominator_white) - e_over_f;
  float curve_white_inverse = 1.f / curve_white;

  float3 value = curve_x * curve_white_inverse;

  // Use Cardono's Method to solve for point of peak velocity (2nd derivative = 0)
  // 2B^{2}D(E-CF)+2AD(E-F)(-DF+3Ax^{2})+2ABx(3D(E-CF)+A(-1+C)x^{2}) = 0
  float a_0 = 2 * B * B * D * (E - C * F) - 2 * A * D * D * F * (E - F);
  float a_1 = 6 * A * B * D * (E - C * F);
  float a_2 = 6 * A * A * D * (E - F);
  float a_3 = 2 * A * A * B * (C - 1);

  float a_3_rcp = 1.f / a_3;  // Helper

  // float p = (3 * a_1 * a_3 - a_2 * a_2) / (3 * a_3 * a_3);
  float p = (3 * a_1 * a_3 - a_2 * a_2) * (1.f / 3.f) * (a_3_rcp * a_3_rcp);

  // float q = (27 * a_0 * a_3 * a_3 - 9 * a_1 * a_2 * a_3 + 2 * a_2 * a_2 * a_2) / (27 * a_3 * a_3 * a_3);
  float q = (27 * a_0 * a_3 * a_3 - 9 * a_1 * a_2 * a_3 + 2 * a_2 * a_2 * a_2) * (1.f / 27.f) * (a_3_rcp * a_3_rcp * a_3_rcp);

  // float delta = pow((q / 2), 2) + pow((p / 3), 3);
  float delta = (q * q) / 4.f + (p * p * p) / 27.f;

  float z;
  [branch]
  if (delta >= 0.0f) {
    // float z = pow(sqrt(delta) - q / 2.f, 1.f / 3.f) - pow(sqrt(delta) + q / 2.f, 1.f / 3.f);
    // Δ ≥ 0 → one real root, cube‑root form
    float sqrt_delta = sqrt(delta);
    z = pow(-q / 2.f + sqrt_delta, 1.f / 3.f) + pow(-q / 2.f - sqrt_delta, 1.f / 3.f);
  } else {
    // Δ < 0 → three real roots, use cosine form
    // usually ta k e k=0 root
    // float theta = acos((-q / 2.0f) / sqrt(-pow(p / 3.0f, 3)));
    // float r = 2.0f * sqrt(-p / 3.0f);

    // p is always negative here
    float positive_p_over_3 = -p / 3.f;

    float theta = acos((-q / 2.0f) * rsqrt(positive_p_over_3 * positive_p_over_3 * positive_p_over_3));
    float r = 2.0f * sqrt(positive_p_over_3);

    z = r * cos(theta / 3.0f);
  }

  // float peak_velocity = z - a_2 / (3 * a_3);
  float peak_velocity_point = (z - a_2) * (1.f / 3.f) * a_3_rcp;

  // If no toe, use initial velocity
  peak_velocity_point = max(0, peak_velocity_point);

  float peak_velocity_value_numerator = mad(peak_velocity_point, mad(A, peak_velocity_point, C * B), D * E);
  float peak_velocity_value_denominator = mad(peak_velocity_point, mad(A, peak_velocity_point, B), D * F);
  float peak_velocity_value_denominator_rcp = 1.f / peak_velocity_value_denominator;

  float peak_velocity_value_base = peak_velocity_value_numerator * peak_velocity_value_denominator_rcp;

  // Evaluate first derivative to get velocity (skip [E/F, W] normalization)
  // R\left(x\right)=\frac{(2Ax+CB)D_{r}\left(x\right)-(2Ax+B)N_{r}\left(x\right)}{D_{r}\left(x\right)^{2}}
  // R\left(x\right)=\frac{(2Ax+CB)-(2Ax+B)F\left(x\right)}{D_{r}\left(x\right)}
  float peak_velocity_unscaled = ((2 * A * peak_velocity_point + C * B)
                                  - ((2 * A * peak_velocity_point + B) * peak_velocity_value_base))
                                 * peak_velocity_value_denominator_rcp;

  float peak_velocity = peak_velocity_unscaled * curve_white_inverse;

  float curve_peak = peak_velocity_value_base - e_over_f;
  float value_peak = curve_peak * curve_white_inverse;

  // Use point slope form (y = y1 + m(x - x1)) to extend curve linearly beyond peak velocity

  float m = peak_velocity;
  float3 x_0 = value;
  float x1 = peak_velocity_point;
  float y1 = value_peak;
  float3 extended_value = y1 + m * (x_0 - x1);

  return renodx::math::Select(value > peak_velocity_point, extended_value, value);
}