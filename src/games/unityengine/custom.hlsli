float EvalCustomSegment(float x, float4 segmentA, float2 segmentB)
{
    const float kOffsetX = segmentA.x;
    const float kOffsetY = segmentA.y;
    const float kScaleX  = segmentA.z;
    const float kScaleY  = segmentA.w;
    const float kLnA     = segmentB.x;
    const float kB       = segmentB.y;

    float x0 = (x - kOffsetX) * kScaleX;
    float y0 = (x0 > 0.0) ? exp(kLnA + kB * log(x0)) : 0.0;
    return y0 * kScaleY + kOffsetY;
}

float EvalCustomCurve(float x, float3 curve, float4 toeSegmentA, float2 toeSegmentB, float4 midSegmentA, float2 midSegmentB, float4 shoSegmentA, float2 shoSegmentB)
{
    float4 segmentA;
    float2 segmentB;

    if (x < curve.y)
    {
        segmentA = toeSegmentA;
        segmentB = toeSegmentB;
    }
    else if (x < curve.z)
    {
        segmentA = midSegmentA;
        segmentB = midSegmentB;
    }
    else
    {
        segmentA = shoSegmentA;
        segmentB = shoSegmentB;
    }

    return EvalCustomSegment(x, segmentA, segmentB);
}

// -----------------------------
// Reuse your existing EvalCustomSegment and EvalCustomCurve as-is.
// (Paste them above if not already present in the file.)
// -----------------------------
// Analytic derivatives for a single EvalCustomSegment (scalar).
// These match the power-law form used in EvalCustomSegment exactly.

// First derivative
static inline float EvalCustomSegment_D1(float x, float4 segmentA, float2 segmentB)
{
    const float kOffsetX = segmentA.x;
    const float kScaleX  = segmentA.z;
    const float kScaleY  = segmentA.w;
    const float kLnA     = segmentB.x;
    const float kB       = segmentB.y;

    float x0 = (x - kOffsetX) * kScaleX;
    if (x0 <= 0.0) return 0.0;

    float a = exp(kLnA);
    // y' = kScaleY * a * kB * x0^(kB-1) * kScaleX
    return kScaleY * a * kB * pow(x0, kB - 1.0) * kScaleX;
}

// Second derivative
static inline float EvalCustomSegment_D2(float x, float4 segmentA, float2 segmentB)
{
    const float kOffsetX = segmentA.x;
    const float kScaleX  = segmentA.z;
    const float kScaleY  = segmentA.w;
    const float kLnA     = segmentB.x;
    const float kB       = segmentB.y;

    float x0 = (x - kOffsetX) * kScaleX;
    if (x0 <= 0.0) return 0.0;

    float a = exp(kLnA);
    // y'' = kScaleY * a * kB*(kB-1) * x0^(kB-2) * kScaleX^2
    return kScaleY * a * (kB * (kB - 1.0)) * pow(x0, kB - 2.0) * (kScaleX * kScaleX);
}

// Third derivative
static inline float EvalCustomSegment_D3(float x, float4 segmentA, float2 segmentB)
{
    const float kOffsetX = segmentA.x;
    const float kScaleX  = segmentA.z;
    const float kScaleY  = segmentA.w;
    const float kLnA     = segmentB.x;
    const float kB       = segmentB.y;

    float x0 = (x - kOffsetX) * kScaleX;
    if (x0 <= 0.0) return 0.0;

    float a = exp(kLnA);
    // y''' = kScaleY * a * kB*(kB-1)*(kB-2) * x0^(kB-3) * kScaleX^3
    return kScaleY * a * (kB * (kB - 1.0) * (kB - 2.0)) * pow(x0, kB - 3.0) * (kScaleX * kScaleX * kScaleX);
}

// Evaluate D1/D3 for the piecewise curve (selects segment like EvalCustomCurve)
static inline float EvalCustomCurve_D1(float x, float3 curve,
                                       float4 toeSegmentA, float2 toeSegmentB,
                                       float4 midSegmentA, float2 midSegmentB,
                                       float4 shoSegmentA, float2 shoSegmentB)
{
    float4 segmentA;
    float2 segmentB;
    if (x < curve.y)
    {
        segmentA = toeSegmentA;
        segmentB = toeSegmentB;
    }
    else if (x < curve.z)
    {
        segmentA = midSegmentA;
        segmentB = midSegmentB;
    }
    else
    {
        segmentA = shoSegmentA;
        segmentB = shoSegmentB;
    }
    return EvalCustomSegment_D1(x, segmentA, segmentB);
}

static inline float EvalCustomCurve_D3(float x, float3 curve,
                                       float4 toeSegmentA, float2 toeSegmentB,
                                       float4 midSegmentA, float2 midSegmentB,
                                       float4 shoSegmentA, float2 shoSegmentB)
{
    float4 segmentA;
    float2 segmentB;
    if (x < curve.y)
    {
        segmentA = toeSegmentA;
        segmentB = toeSegmentB;
    }
    else if (x < curve.z)
    {
        segmentA = midSegmentA;
        segmentB = midSegmentB;
    }
    else
    {
        segmentA = shoSegmentA;
        segmentB = shoSegmentB;
    }
    return EvalCustomSegment_D3(x, segmentA, segmentB);
}

// Evaluate value for the piecewise curve (reuses EvalCustomCurve semantics)
static inline float EvalCustomCurve_Value(float x, float3 curve,
                                          float4 toeSegmentA, float2 toeSegmentB,
                                          float4 midSegmentA, float2 midSegmentB,
                                          float4 shoSegmentA, float2 shoSegmentB)
{
    float4 segmentA;
    float2 segmentB;
    if (x < curve.y)
    {
        segmentA = toeSegmentA;
        segmentB = toeSegmentB;
    }
    else if (x < curve.z)
    {
        segmentA = midSegmentA;
        segmentB = midSegmentB;
    }
    else
    {
        segmentA = shoSegmentA;
        segmentB = shoSegmentB;
    }
    return EvalCustomSegment(x, segmentA, segmentB);
}

// --- Extended CustomTonemap helpers with unique names (no redefinition) ---
// Assumes original EvalCustomSegment, EvalCustomCurve and CustomTonemap remain in file.

// First derivative (unique name)
static inline float EvalCustomSegment_D1_Ext(float x, float4 segmentA, float2 segmentB)
{
    const float kOffsetX = segmentA.x;
    const float kScaleX  = segmentA.z;
    const float kScaleY  = segmentA.w;
    const float kLnA     = segmentB.x;
    const float kB       = segmentB.y;

    float x0 = (x - kOffsetX) * kScaleX;
    if (x0 <= 0.0) return 0.0;

    float a = exp(kLnA);
    return kScaleY * a * kB * pow(x0, kB - 1.0) * kScaleX;
}

// Third derivative (unique name)
static inline float EvalCustomSegment_D3_Ext(float x, float4 segmentA, float2 segmentB)
{
    const float kOffsetX = segmentA.x;
    const float kScaleX  = segmentA.z;
    const float kScaleY  = segmentA.w;
    const float kLnA     = segmentB.x;
    const float kB       = segmentB.y;

    float x0 = (x - kOffsetX) * kScaleX;
    if (x0 <= 0.0) return 0.0;

    float a = exp(kLnA);
    return kScaleY * a * (kB * (kB - 1.0) * (kB - 2.0)) * pow(x0, kB - 3.0) * (kScaleX * kScaleX * kScaleX);
}

// Piecewise wrappers (unique names)
static inline float EvalCustomCurve_D1_Ext(float x, float3 curve,
                                           float4 toeSegmentA, float2 toeSegmentB,
                                           float4 midSegmentA, float2 midSegmentB,
                                           float4 shoSegmentA, float2 shoSegmentB)
{
    float4 segmentA;
    float2 segmentB;
    if (x < curve.y) { segmentA = toeSegmentA; segmentB = toeSegmentB; }
    else if (x < curve.z) { segmentA = midSegmentA; segmentB = midSegmentB; }
    else { segmentA = shoSegmentA; segmentB = shoSegmentB; }
    return EvalCustomSegment_D1_Ext(x, segmentA, segmentB);
}

static inline float EvalCustomCurve_D3_Ext(float x, float3 curve,
                                           float4 toeSegmentA, float2 toeSegmentB,
                                           float4 midSegmentA, float2 midSegmentB,
                                           float4 shoSegmentA, float2 shoSegmentB)
{
    float4 segmentA;
    float2 segmentB;
    if (x < curve.y) { segmentA = toeSegmentA; segmentB = toeSegmentB; }
    else if (x < curve.z) { segmentA = midSegmentA; segmentB = midSegmentB; }
    else { segmentA = shoSegmentA; segmentB = shoSegmentB; }
    return EvalCustomSegment_D3_Ext(x, segmentA, segmentB);
}

// Value wrapper (reuse existing EvalCustomCurve if present; unique wrapper to be explicit)
static inline float EvalCustomCurve_Value_Ext(float x, float3 curve,
                                              float4 toeSegmentA, float2 toeSegmentB,
                                              float4 midSegmentA, float2 midSegmentB,
                                              float4 shoSegmentA, float2 shoSegmentB)
{
    // If EvalCustomCurve is already defined, you can call it directly:
    // return EvalCustomCurve(x, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);
    // Otherwise use the same selection logic:
    float4 segmentA;
    float2 segmentB;
    if (x < curve.y) { segmentA = toeSegmentA; segmentB = toeSegmentB; }
    else if (x < curve.z) { segmentA = midSegmentA; segmentB = midSegmentB; }
    else { segmentA = shoSegmentA; segmentB = shoSegmentB; }
    return EvalCustomSegment(x, segmentA, segmentB);
}

// Helper: detect if a segment's exponent makes D3 identically zero
static inline bool SegmentCoeffZero_Ext(float2 segB)
{
    float kB = segB.y;
    return (abs(kB - 0.0) < 1e-6) || (abs(kB - 1.0) < 1e-6) || (abs(kB - 2.0) < 1e-6);
}

// Analytic knee finder using only segment interiors and boundaries (no fallback param)
static inline float FindKneeAnalyticPerChannel_NoFallback_Ext(float3 curve,
                                                              float4 toeSegmentA, float2 toeSegmentB,
                                                              float4 midSegmentA, float2 midSegmentB,
                                                              float4 shoSegmentA, float2 shoSegmentB)
{
    float bound0 = curve.y;
    float bound1 = curve.z;
    float eps = 1e-6;

    float s0 = max(eps, bound0 * 0.5);
    float s1 = max(bound0 + eps, (bound0 + bound1) * 0.5);
    float s2 = max(bound1 + eps, bound1 + 0.5);

    float d3_0 = EvalCustomCurve_D3_Ext(s0, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);
    float d3_1 = EvalCustomCurve_D3_Ext(s1, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);
    float d3_2 = EvalCustomCurve_D3_Ext(s2, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);

    if (SegmentCoeffZero_Ext(toeSegmentB)) return max(eps, toeSegmentA.x);
    if (SegmentCoeffZero_Ext(midSegmentB)) return bound0;
    if (SegmentCoeffZero_Ext(shoSegmentB)) return bound1;

    if (d3_0 * d3_1 < 0.0) return bound0;
    if (d3_1 * d3_2 < 0.0) return bound1;

    return bound1;
}


float3 Custom(float3 x, float3 curve, float4 toeSegmentA, float2 toeSegmentB, float4 midSegmentA, float2 midSegmentB, float4 shoSegmentA, float2 shoSegmentB){
    float3 sdr_color;
    sdr_color.r = EvalCustomCurve(max(0.f, x.r) * curve.x, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);
    sdr_color.g = EvalCustomCurve(max(0.f, x.g) * curve.x, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);
    sdr_color.b = EvalCustomCurve(max(0.f, x.b) * curve.x, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);
    return sdr_color;
}

float3 CustomExtended(float3 x, float3 curve, float4 toeSegmentA, float2 toeSegmentB, float4 midSegmentA, float2 midSegmentB, float4 shoSegmentA, float2 shoSegmentB){
    float3 normX = x * curve.x;
    float3 hdr_color;

    // compute knees once per channel
    float kneeR = FindKneeAnalyticPerChannel_NoFallback_Ext(curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);
    float kneeG = kneeR; // if you want per-channel different knees based on channel value, call finder with different samples; here we reuse same logic per channel
    float kneeB = kneeR;

    // RED
    {
        float xi = normX.x;
        float yk = EvalCustomCurve_Value_Ext(kneeR, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);
        float sk = EvalCustomCurve_D1_Ext(kneeR, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);
        hdr_color.x = (xi <= kneeR) ? EvalCustomCurve_Value_Ext(xi, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB)
                              : (yk + sk * (xi - kneeR));
    }

    // GREEN
    {
        float xi = normX.y;
        float yk = EvalCustomCurve_Value_Ext(kneeG, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);
        float sk = EvalCustomCurve_D1_Ext(kneeG, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);
        hdr_color.y = (xi <= kneeG) ? EvalCustomCurve_Value_Ext(xi, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB)
                              : (yk + sk * (xi - kneeG));
    }

    // BLUE
    {
        float xi = normX.z;
        float yk = EvalCustomCurve_Value_Ext(kneeB, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);
        float sk = EvalCustomCurve_D1_Ext(kneeB, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB);
        hdr_color.z = (xi <= kneeB) ? EvalCustomCurve_Value_Ext(xi, curve, toeSegmentA, toeSegmentB, midSegmentA, midSegmentB, shoSegmentA, shoSegmentB)
                              : (yk + sk * (xi - kneeB));
    }
    return hdr_color;
}