#ifndef CODGHOSTS_LUTLESS_EXTENSION_HLSL
#define CODGHOSTS_LUTLESS_EXTENSION_HLSL

// Included after the rational curve and complete SDR reference in passes 3/4.
// The pivot is OUTPUT midgray: scene 0.18 can lie deep in the Hable toe.
float3 ApplyOriginalLinearPiecewiseExtension(float3 sceneColor)
{
    sceneColor = SafePositive(sceneColor);
    float outputPivot = clamp(RENODX_GHOSTS_LINEAR_EXTENSION_PIVOT, 0.000001f, 0.99f);
    float3 pivot = outputPivot.xxx;

    // Invert the authored output range and Hable rational polynomial directly.
    // This is a quadratic inverse, not an inflection/second-derivative search.
    if (cb2[36].y > 0.000001f) {
        float encodedPivot = renodx::color::srgb::Encode(outputPivot) / cb2[36].y + cb2[36].x;
        float curvePivot = renodx::color::srgb::Decode(saturate(encodedPivot));
        [unroll]
        for (uint channel = 0; channel < 3; ++channel) {
            if (cb2[9][channel] > 0.000001f) {
                float ratio = curvePivot / cb2[9][channel] + cb2[5][channel];
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
    }

    // Keep the numerical derivative away from denorm-sized steps.  Very small
    // pivots could previously make the finite-difference denominator tiny,
    // amplifying precision noise into INF/NaN slopes.
    float3 stepSize = max(
        min(0.001f.xxx, pivot * 0.01f),
        0.000001f.xxx);

    float3 outputAtPivot =
        SafePositive(max(ApplyCompleteSDRReference(pivot), 0.0f.xxx));
    float3 sampleHigh =
        SafePositive(max(ApplyCompleteSDRReference(pivot + stepSize), 0.0f.xxx));
    float3 sampleLow =
        SafePositive(max(ApplyCompleteSDRReference(max(pivot - stepSize, 0.0f.xxx)), 0.0f.xxx));

    // The authored Hable curve is monotonic here, so a negative/non-finite
    // derivative is numerical garbage rather than useful highlight behavior.
    float3 slope = SafePositive(max(
        (sampleHigh - sampleLow) / (2.0f * stepSize),
        0.0f.xxx));

    float3 lower =
        SafePositive(max(ApplyCompleteSDRReference(sceneColor), 0.0f.xxx));
    float3 upper =
        SafePositive(max(slope * (sceneColor - pivot) + outputAtPivot, 0.0f.xxx));

    float3 extendedColor = SafePositive(float3(
        sceneColor.r < pivot.r ? lower.r : upper.r,
        sceneColor.g < pivot.g ? lower.g : upper.g,
        sceneColor.b < pivot.b ? lower.b : upper.b));

    // Preserve the authored SDR highlight color while keeping the extra HDR
    // highlight range supplied by the tangent extension.
    //
    // IMPORTANT: preserve MAX-RGB/peak here, not luminance.  The previous
    // luminance-normalized version could require enormous RGB multipliers for
    // strongly saturated blue/red anchors (especially blue because BT.709 Y
    // gives it a small luminance coefficient).  The resulting RGB could still
    // be finite here but become pathological in the later AP1 / OkLab / HDR
    // rolloff path and produce NaNs.
    //
    // The SDR anchor is still sampled on the same input RGB ray at the
    // extension boundary through the original Ghosts/Hable rational curve, so
    // it keeps the authored hue and saturation without adding another encoded
    // output/sRGB round trip. We normalize that anchor to unit max-RGB and give it
    // exactly the same peak channel as the already-safe tangent extension.
    // Therefore this chroma correction can NEVER create a channel brighter
    // than the extension itself.
    const float epsilon = 0.000001f;

    float anchorScale = 1.0f;
    if (sceneColor.r > pivot.r)
        anchorScale = min(anchorScale, pivot.r / max(sceneColor.r, epsilon));
    if (sceneColor.g > pivot.g)
        anchorScale = min(anchorScale, pivot.g / max(sceneColor.g, epsilon));
    if (sceneColor.b > pivot.b)
        anchorScale = min(anchorScale, pivot.b / max(sceneColor.b, epsilon));

    anchorScale = SafeFinitePositive1(anchorScale);
    anchorScale = saturate(anchorScale);

    float3 anchorScene = SafePositive(sceneColor * anchorScale);
    // Use the original rational/Hable result directly for chromaticity.
    // Do NOT run this synthetic boundary sample through the extra encoded-output
    // + sRGB-decode path; that was an unnecessary second nonlinear evaluation
    // introduced only by the color fix. The regular SDR/tangent samples above
    // still use ApplyCompleteSDRReference exactly as before.
    float3 sdrColorAnchor =
        SafePositive(max(ApplyOriginalRationalTonemap(anchorScene), 0.0f.xxx));

    float extendedPeak = SafeFinitePositive1(max(
        extendedColor.r,
        max(extendedColor.g, extendedColor.b)));

    float anchorPeak = SafeFinitePositive1(max(
        sdrColorAnchor.r,
        max(sdrColorAnchor.g, sdrColorAnchor.b)));

    if (anchorScale < 0.999999f && anchorPeak > epsilon && extendedPeak > epsilon) {
        // Unit max-RGB direction. Every component is guaranteed to remain in
        // [0, 1], so multiplying by extendedPeak cannot overshoot the already
        // finite tangent-extended peak.
        float3 sdrColorDirection = SafePositive(
            sdrColorAnchor / max(anchorPeak, epsilon));
        sdrColorDirection = saturate(sdrColorDirection);

        float3 sdrColorAtHDRPeak = SafePositive(
            sdrColorDirection * extendedPeak);

        // Fade the SDR chroma match in immediately above the extension
        // boundary, reaching full strength by roughly 1.5x the boundary.
        float ratioR = SafeFinitePositive1(sceneColor.r / max(pivot.r, epsilon));
        float ratioG = SafeFinitePositive1(sceneColor.g / max(pivot.g, epsilon));
        float ratioB = SafeFinitePositive1(sceneColor.b / max(pivot.b, epsilon));
        float extensionRatio = max(ratioR, max(ratioG, ratioB));

        float colorMatch = saturate((extensionRatio - 1.0f) / 0.5f);
        colorMatch = colorMatch * colorMatch * (3.0f - 2.0f * colorMatch);
        colorMatch = SafeFinitePositive1(colorMatch);
        colorMatch = saturate(colorMatch);

        // Explicit weighted sum instead of lerp avoids compiler forms such as
        // a + t * (b - a), which can manufacture NaN if a future edit ever
        // lets either endpoint reach opposite infinities.
        extendedColor = SafePositive(
            extendedColor * (1.0f - colorMatch)
            + sdrColorAtHDRPeak * colorMatch);
    }

    return SafePositive(max(extendedColor, 0.0f.xxx));
}

#endif
