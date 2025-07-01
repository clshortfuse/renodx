#include "./shared.h"
// Piecewise highlight rolloff function with descriptive parameter names

float3 HighlightRolloff(
    float3 color,
    float  knee_slope,         // param1.y
    float  knee_offset,        // param1.z
    float  max_white,          // param1.x   (the min() clamp)
    float  shoulder_den,       // param1.w
    float  shoulder_thresh,    // param2.z   (threshold for rolloff start)
    float  shoulder_add,       // param2.x
    float  shoulder_slope,     // param2.y
    float  shoulder_limit,     // param2.w   (upper end of rolloff)
    float  gamma_scale,        // param3.w   (scale for log/exponent)
    float  tail_slope,         // param3.x
    float  tail_offset,        // param3.z
    float  tail_add            // param3.y
) {
    // --- Piecewise threshold: choose between "linear" knee or non-linear shoulder ---
    float3 t1 = knee_slope * color + knee_offset;
    float3 t2 = shoulder_add + color;
    t2 = -shoulder_den / t2;
    t2 = shoulder_slope + t2;
    bool3 is_knee = color < shoulder_thresh;
    float3 result = is_knee ? t1 : t2;

    // --- Nonlinear curve shaping, compressing highlights ---
    result = sqrt(result);
    bool3 is_positive = (float3(0, 0, 0) < result);
    result = log2(result);
    result = gamma_scale * result;
    result = exp2(result);
    result = is_positive ? result : float3(0, 0, 0);
    result *= result;
    result = min(max_white, result);

    // --- More piecewise shaping for extreme highlights (shoulder/tail) ---
    float3 t3 = -knee_offset + result;
    t3 = t3 / knee_slope;
    float3 t4 = -shoulder_slope + result;
    t4 = -shoulder_den / t4;
    t4 = -shoulder_add + t4;
    is_knee = result < shoulder_limit;
    result = is_knee ? t3 : t4;

    // --- Final shaping for the brightest values ---
    float3 t5 = knee_slope * result + knee_offset;
    float3 t6 = tail_add + result;
    t6 = -tail_slope / t6;
    t6 = tail_offset + t6;
    is_knee = result < shoulder_thresh;
    result = is_knee ? t5 : t6;

    return result;
}
