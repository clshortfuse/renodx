// --- Neutral tonemap extension helpers (added) ---
// Derivative of the raw NeutralCurve (numerator/denominator form).
// Matches NeutralCurve: ((x*(a*x + c*b) + d*e) / (x*(a*x + b) + d*f)) - e/f
float DerivativeNeutral(float x, float a, float b, float c, float d, float e, float f){
    // numerator derivative (from symbolic differentiation)
    // num = x*(a*x + c*b) + d*e
    // den = x*(a*x + b) + d*f
    // d/dx (num/den) = (num' * den - den' * num) / den^2
    float num = x * (a * x + c * b) + d * e;
    float den = x * (a * x + b) + d * f;

    float num_p = (2.0 * a * x + c * b); // derivative of numerator w.r.t x
    float den_p = (2.0 * a * x + b);     // derivative of denominator w.r.t x

    float den_sq = den * den;// + FLT_MIN; // avoid div by zero
    return (num_p * den - den_p * num) / den_sq;
}

// Second derivative of the raw NeutralCurve (used to find inflection / pivot).
float SecondDerivativeNeutral(float x, float a, float b, float c, float d, float e, float f){
    // Compute using symbolic expansion for stability:
    // We compute numerator and denominator pieces carefully to avoid precision issues.
    float t = x * (a * x + b) + d * f;
    float den = t * t * t; // (den)^3 in the derived closed form
    // Numerator derived from symbolic algebra (kept in expanded form)
    float term1 = a * b * x * (a * (c - 1.0) * x * x + 3.0 * d * (e - c * f));
    float term2 = a * d * (e - f) * (3.0 * a * x * x - d * f);
    float term3 = b * b * d * (e - c * f);
    float num = 2.0 * (term1 + term2 + term3);
    return num / (den);// + FLT_MIN);
}

// Find the positive root where second derivative == 0 (pivot point).
// Returns 0 if no meaningful positive root found.
float FindSecondDerivativeRootNeutral(float a, float b, float c, float d, float e, float f){
    // Coefficients of cubic numerator: A3 x^3 + A2 x^2 + A1 x + A0
    float A3 = a * a * b * (c - 1.0);
    float A2 = 3.0 * a * a * d * (e - f);
    float A1 = 3.0 * a * b * d * (e - c * f);
    float A0 = a * d * d * (f * f - e * f) + b * b * d * (e - c * f);

    // If cubic degenerates, return 0
    if (abs(A3) < 1e-12)
        return 0.0;

    // Normalize to monic cubic: x^3 + an x^2 + bn x + cn = 0
    float invA3 = 1.0 / A3;
    float an = A2 * invA3;
    float bn = A1 * invA3;
    float cn = A0 * invA3;

    // Depressed cubic substitution x = t - an/3
    float an_3 = an / 3.0;
    float p = bn - an * an_3;
    float q = 2.0 * an * an * an / 27.0 - an * bn / 3.0 + cn;

    float half_q = 0.5 * q;
    float Delta = half_q * half_q + (p / 3.0) * (p / 3.0) * (p / 3.0);

    float t;
    if (Delta >= 0.0)
    {
        float sqrtD = sqrt(Delta);
        float u = -half_q + sqrtD;
        float v = -half_q - sqrtD;
        // signed cube roots for robustness
        float u_c = (u >= 0.0) ? pow(u, 1.0/3.0) : -pow(-u, 1.0/3.0);
        float v_c = (v >= 0.0) ? pow(v, 1.0/3.0) : -pow(-v, 1.0/3.0);
        t = u_c + v_c;
    }
    else
    {
        // three real roots -> use trig solution, pick principal
        float m = 2.0 * sqrt(-p / 3.0);
        float angle = acos( clamp((-half_q) / sqrt(-(p * p * p) / 27.0), -1.0, 1.0) );
        t = m * cos(angle / 3.0);
    }

    float x = t - an_3;
    return max(x, 0.0);
}

// --- Modified NeutralTonemap (replaces original) ---
// Keep original constants and whiteScale behavior
float3 Neutral(float3 x, float a, float b, float c, float d, float e, float f, float whiteLevel, float whiteClip){
    bool extended = RENODX_TONE_MAP_TYPE != 0.f;
    float3 whiteScale = (1.0).xxx / renodx::tonemap::ApplyCurve(whiteLevel, a, b, c, d, e, f);
    // --- original whiteScale / base computation (unchanged) ---
    float3 sdr_color = renodx::tonemap::ApplyCurve(max(0.f, x) * whiteScale, a, b, c, d, e, f);
    sdr_color *= whiteScale;
    sdr_color /= whiteClip.xxx;
    return sdr_color;
}
float3 NeutralExtended(float3 x, float a, float b, float c, float d, float e, float f, float whiteLevel, float whiteClip){
      //x = max(0.f, x);
    // --- compute scalar whiteScale and pivot in raw curve domain ---
    // Use scalar whiteScale (all channels use same neutral coefficients so whiteScale.x is representative)
    float3 whiteScale = (1.0).xxx / renodx::tonemap::ApplyCurve(whiteLevel, a, b, c, d, e, f);
    float W = 1.0 / renodx::tonemap::ApplyCurve(whiteLevel, a, b, c, d, e, f).x;

    // Find pivot in raw curve domain (u domain)
    float u_pivot = FindSecondDerivativeRootNeutral(a, b, c, d, e, f);

    // If degenerate or no positive pivot, return base (no extension)
    if (u_pivot <= 0.0)
        return renodx::tonemap::ApplyCurve(x * whiteScale, a, b, c, d, e, f) * whiteScale / whiteClip;

    // Convert pivot to shader input domain: x_pivot = u_pivot / W
    float x_pivot = u_pivot / W;

    // Compute pivot output (per-channel) in the same way base was computed:
    // pivot_out = NeutralCurve(u_pivot) * W
    float3 pivot_out = renodx::tonemap::ApplyCurve(u_pivot, a, b, c, d, e, f) * W;

    // Compute slope in output space using chain rule:
    // slope_out = d(NeutralCurve)/du (at u_pivot) * du/dx * W
    // du/dx = W, so slope_out = DerivativeNeutral(u_pivot) * W * W
    float slope_scalar = DerivativeNeutral(u_pivot, a, b, c, d, e, f) * W * W;

    // Make slope per-channel (same scalar slope for each channel)
    float3 slope = slope_scalar.xxx;

    // Compute offset so the line passes through pivot_out at x_pivot:
    // offset = pivot_out - slope * x_pivot
    float3 offset = pivot_out - slope * x_pivot;

    // Compute linear extension per-channel
    float3 extendedLine = slope * x + offset;

    // Blend: for x <= x_pivot use base, for x > x_pivot use linear extension
    // step(a,b) returns 0 if b < a else 1; broadcasting works with scalar a and float3 b
    float3 mask = step(x_pivot, x); // 0 for below pivot, 1 for above (per-channel)
    float3 hdr_color = lerp(renodx::tonemap::ApplyCurve(x * whiteScale, a, b, c, d, e, f) * whiteScale / whiteClip, extendedLine, mask);
  return hdr_color;
}