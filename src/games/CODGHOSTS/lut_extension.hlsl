#ifndef CODGHOSTS_LUT_EXTENSION_HLSL
#define CODGHOSTS_LUT_EXTENSION_HLSL

// Locate output midgray in the original pre-LUT Hable curve. The LUT remains
// a separate grading stage; do not sample it to calibrate scene brightness.
float3 GetGhostsLUTCurvePivot()
{
    float outputPivot = clamp(RENODX_GHOSTS_LINEAR_EXTENSION_PIVOT, 0.000001f, 0.99f);
    float3 pivot = outputPivot.xxx;
    [unroll]
    for (uint channel = 0; channel < 3; ++channel) {
        if (cb2[9][channel] > 0.000001f) {
            float ratio = outputPivot / cb2[9][channel] + cb2[5][channel];
            float a = cb2[8][channel] * (1.0f - ratio);
            float b = cb2[6][channel] * (cb2[7][channel] - ratio);
            float c = cb2[3][channel] - cb2[4][channel] * ratio;
            float discriminant = b * b - 4.0f * a * c;
            float candidate = 0.0f;
            if (a > 0.000001f && discriminant >= 0.0f)
                candidate = (-b + sqrt(discriminant)) / (2.0f * a);
            else if (b > 0.000001f)
                candidate = -c / b;
            if (candidate > 0.000001f && candidate < 65504.0f)
                pivot[channel] = candidate;
        }
    }
    return pivot;
}

#endif
