#include "./shared.h"

// Tonemapper 3 (0xE73A0FFC) - Ghosts-faithful RenoDX HDR conversion.
//
// Vanilla mode:
//   preserves the pass's original rational tonemapper.
//
// Strict HDR test path:
//   linear scene
//   -> RenoDX pre-tonemap controls
//   -> original Ghosts rational curve through the 0.18 pivot
//   -> exact first-derivative linear extension above the pivot
//   -> select RenoDRT or Pragmap from the same SDR-anchored carrier
//   -> RenoDX post-tonemap controls
//   -> RenderIntermediatePass
//
// This pass has no Texture3D LUT, so there is intentionally no SDR LUT
// compression / UpgradeToneMap stage.
//
// The old highlight-restoration and SDR color/shadow match stages remain
// available behind compile-time test toggles, but default OFF.
// ============================================================================
// Pragmap - third HDR tonemapper
// ============================================================================
//
// Runtime mode IDs:
//   0 = Vanilla
//   3 = RenoDRT / Ghosts-faithful HDR
//   4 = Pragmap
#ifndef RENODX_TONE_MAP_TYPE_PRAGMAP
#define RENODX_TONE_MAP_TYPE_PRAGMAP 4.0f
#endif

#include "./pragmap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
    float4 cb2[37];
}

#ifndef RENODX_TONE_MAP_TYPE_VANILLA
#define RENODX_TONE_MAP_TYPE_VANILLA 0.0f
#endif

#ifndef RENODX_TONEMAPPER_INPUT_SCALE
#define RENODX_TONEMAPPER_INPUT_SCALE 1.0f
#endif

// ============================================================================
// Ghosts-faithful HDR rolloff experiment
// ============================================================================
//
// The original rational tonemapper is preserved through a mid-gray pivot.
// Above the pivot, its exact first derivative is extended linearly.
//
// That extended signal is then rolled PER CHANNEL to the configured HDR peak,
// followed by hue-direction correction.
//
// The old highlight-restoration and SDR-reference matching stages are optional
// and disabled by default so they cannot hide the behavior of this path.
#ifndef RENODX_GHOSTS_LINEAR_EXTENSION_PIVOT
#define RENODX_GHOSTS_LINEAR_EXTENSION_PIVOT 0.18f
#endif

#ifndef RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION
#define RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION 1.0f
#endif

#ifndef RENODX_GHOSTS_ROLLOFF_TEST_USE_HIGHLIGHT_RESTORE
#define RENODX_GHOSTS_ROLLOFF_TEST_USE_HIGHLIGHT_RESTORE 0
#endif

#ifndef RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_COLOR_MATCH
#define RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_COLOR_MATCH 0
#endif

#ifndef RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_SHADOW_MATCH
#define RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_SHADOW_MATCH 0
#endif


// Partial absolute SDR color match, matching Tonemapper 1.
#ifndef RENODX_TONEMAPPER_SDR_ABSOLUTE_COLOR_MATCH
#define RENODX_TONEMAPPER_SDR_ABSOLUTE_COLOR_MATCH 0.35f
#endif

#ifndef RENODX_TONEMAPPER_MID_GRAY
#define RENODX_TONEMAPPER_MID_GRAY 0.18f
#endif

// Scene-light value where the Hermite shoulder is fully compressed.
// This is not the output peak; output peak comes from Peak Brightness / Game White.
#ifndef RENODX_TONEMAPPER_WHITE_CLIP
#define RENODX_TONEMAPPER_WHITE_CLIP 100.0f
#endif

// Controlled highlight restoration, matching Tonemapper 1.
#ifndef RENODX_HDR_HIGHLIGHT_RESTORE
#define RENODX_HDR_HIGHLIGHT_RESTORE 0.35f
#endif

#ifndef RENODX_HDR_HIGHLIGHT_START
#define RENODX_HDR_HIGHLIGHT_START 1.00f
#endif

#ifndef RENODX_HDR_HIGHLIGHT_FULL
#define RENODX_HDR_HIGHLIGHT_FULL 4.00f
#endif

#ifndef RENODX_HDR_RESTORE_LIMIT_TO_DISPLAY
#define RENODX_HDR_RESTORE_LIMIT_TO_DISPLAY 1
#endif

// Optional dark-area anchor to the original SDR tonemapper.
#ifndef RENODX_TONEMAPPER_SDR_SHADOW_MATCH
#define RENODX_TONEMAPPER_SDR_SHADOW_MATCH 1.0f
#endif

#ifndef RENODX_TONEMAPPER_SDR_MATCH_FULL
#define RENODX_TONEMAPPER_SDR_MATCH_FULL 0.18f
#endif

#ifndef RENODX_TONEMAPPER_SDR_MATCH_END
#define RENODX_TONEMAPPER_SDR_MATCH_END 0.75f
#endif

// ============================================================================
// Soft SDR luminance anchor with scene-referred HDR release
// ============================================================================
//
// The SDR result is used as a luminance guide, not substituted directly into
// HDR. Release is based on PRE-TONEMAP scene intensity so the waveform rises
// smoothly instead of bunching on the SDR shoulder.
// ============================================================================
// Shoulder-aware upper-SDR brightness match
// ============================================================================
//
// Bright diffuse SDR values may still sit slightly above the HDR tonemapper.
// Match that remaining brightness difference only while the original scene is
// still below the HDR highlight shoulder.
//
// The match fades out using PRE-TONEMAP scene intensity:
//   scene peak <= 0.60 : full configured bright-range matching
//   scene peak 0.60-1.10: smoothly release the SDR brightness target
//   scene peak >= 1.10 : no extra SDR brightness matching
//
// This pass is lift-only and scales RGB uniformly, so it preserves the existing
// SDR color match and never darkens an HDR value that is already brighter.
// Safety cap for this additional lift only. This is not an HDR output clamp.
// Set to 1 only for direct encoded-SDR comparison/debugging.
#ifndef RENODX_TONEMAPPER_EXACT_ENCODED_VANILLA
#define RENODX_TONEMAPPER_EXACT_ENCODED_VANILLA 0
#endif

float SafeFinitePositive1(float value)
{
    value = (value == value) ? value : 0.0f;
    return min(max(value, 0.0f), 65504.0f);
}

float3 SafePositive(float3 color)
{
    // Preferred first-pass NaN fix for HDR color paths: clamp negatives away
    // before the per-channel finite/FP16 sanitization below.
    color = max(color, float3(0.0f, 0.0f, 0.0f));

    return float3(
        SafeFinitePositive1(color.r),
        SafeFinitePositive1(color.g),
        SafeFinitePositive1(color.b)
    );
}

// ============================================================================
// Extra HDR NaN / INF protection
// ============================================================================
//
// `max(color, 0)` remains the first/default cleanup for color values.
//
// These helpers cover the cases max() alone cannot fix:
//   - NaN
//   - +INF / -INF
//   - invalid zero-base negative powers
//
// Finite positive HDR is preserved up to FP16's real maximum (65504).
float GhostsFiniteSigned1(float value)
{
    if (value != value)
        return 0.0f;

    return clamp(
        value,
        -65504.0f,
        65504.0f
    );
}

float2 GhostsFiniteSigned2(float2 value)
{
    return float2(
        GhostsFiniteSigned1(value.x),
        GhostsFiniteSigned1(value.y)
    );
}

float3 GhostsFiniteSigned3(float3 value)
{
    return float3(
        GhostsFiniteSigned1(value.x),
        GhostsFiniteSigned1(value.y),
        GhostsFiniteSigned1(value.z)
    );
}

float4 GhostsFiniteSigned4(float4 value)
{
    return float4(
        GhostsFiniteSigned1(value.x),
        GhostsFiniteSigned1(value.y),
        GhostsFiniteSigned1(value.z),
        GhostsFiniteSigned1(value.w)
    );
}

float GhostsSafePositiveParameter1(
    float value,
    float fallbackValue)
{
    if (value != value)
        value = fallbackValue;

    return clamp(
        value,
        0.0f,
        65504.0f
    );
}

float GhostsSafePowPositive1(
    float baseValue,
    float exponent)
{
    baseValue =
        SafeFinitePositive1(
            max(baseValue, 0.0f)
        );

    exponent =
        GhostsFiniteSigned1(
            exponent
        );

    // Avoid 0 raised to a negative exponent -> INF.
    if (baseValue <= 0.0f)
    {
        if (exponent < 0.0f)
            return 0.0f;

        if (exponent == 0.0f)
            return 1.0f;

        return 0.0f;
    }

    return SafeFinitePositive1(
        pow(
            max(baseValue, 0.00000001f),
            exponent
        )
    );
}

// ============================================================================
// HDR auto-exposure strength
// ============================================================================
//
// The game supplies `sceneScale` through TEXCOORD2. These shaders do not own
// the temporal exposure adaptation itself, so they cannot add proper history-
// based smoothing here.
//
// Instead, this reduces the MAGNITUDE of the incoming exposure changes in
// exposure/log2 space:
//
//     1.00 = original game exposure
//     0.50 = half of the exposure change in stops
//     0.00 = neutral scale of 1.0
//
// Vanilla mode bypasses this helper and keeps the original game sceneScale.
float ApplyGhostsAutoExposureStrength(float sceneScale)
{
    sceneScale =
        GhostsFiniteSigned1(
            sceneScale
        );

    float strength =
        saturate(
            GhostsFiniteSigned1(
                RENODX_GHOSTS_AUTO_EXPOSURE_STRENGTH
            )
        );

    // Preserve original behavior exactly at 100%.
    if (strength >= 0.999999f)
        return sceneScale;

    // 0% = neutral exposure multiplier.
    if (strength <= 0.000001f)
        return 1.0f;

    // Exposure is multiplicative, so interpolate toward 1.0 in stops rather
    // than linearly. This damps frame-to-frame pumping without imposing an SDR
    // clamp or reducing HDR headroom.
    float safeSceneScale =
        max(
            sceneScale,
            0.000001f
        );

    float exposureStops =
        log2(
            safeSceneScale
        );

    float adjustedSceneScale =
        exp2(
            exposureStops * strength
        );

    return SafeFinitePositive1(
        adjustedSceneScale
    );
}



// Tonemapper-1-style partial absolute SDR color match.
// The SDR chromaticity is normalized to current HDR luminance before blending.
float3 ApplyPartialAbsoluteSDRColorMatch(
    float3 hdrColor,
    float3 sdrReference)
{
    hdrColor = SafePositive(max(hdrColor, 0.0f.xxx));
    sdrReference = saturate(SafePositive(max(sdrReference, 0.0f.xxx)));

    const float epsilon = 0.000001f;

    float hdrLuminance =
        max(
            renodx::color::y::from::BT709(hdrColor),
            0.0f
        );

    float sdrLuminance =
        max(
            renodx::color::y::from::BT709(sdrReference),
            0.0f
        );

    if (sdrLuminance <= epsilon)
    {
        return hdrColor;
    }

    float3 sdrMatchedColor =
        sdrReference
        * (hdrLuminance / sdrLuminance);

    float strength =
        saturate(
            RENODX_TONEMAPPER_SDR_ABSOLUTE_COLOR_MATCH
        );

    return SafePositive(
        max(
            lerp(
                hdrColor,
                sdrMatchedColor,
                strength
            ),
            0.0f.xxx
        )
    );
}


float SmoothCubic01(float value)
{
    value = saturate(value);
    return value * value * (3.0f - 2.0f * value);
}


float MaxRGB(float3 color)
{
    return max(
        color.r,
        max(
            color.g,
            color.b));
}

// Correct only the hue direction shifted by the per-channel rolloff.
//
// The rolled-off OkLab chroma magnitude is intentionally retained, so this does
// not undo the desired per-channel highlight blowout/desaturation.
float3 CorrectGhostsPerChannelRolloffHue(
    float3 preRolloffColor,
    float3 rolledOffColor)
{
    preRolloffColor =
        SafePositive(
            max(preRolloffColor, 0.0f)
        );

    rolledOffColor =
        SafePositive(
            max(rolledOffColor, 0.0f)
        );

    float strength =
        saturate(
            RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION
        );

    if (strength <= 0.000001f)
    {
        return rolledOffColor;
    }

    float3 sourceLab =
        renodx::color::oklab::from::BT709(
            preRolloffColor
        );

    float3 rolledLab =
        renodx::color::oklab::from::BT709(
            rolledOffColor
        );

    float sourceChroma =
        length(sourceLab.yz);

    float rolledChroma =
        length(rolledLab.yz);

    if (
        sourceChroma <= 0.000001f
        || rolledChroma <= 0.000001f
    )
    {
        return rolledOffColor;
    }

    float2 sourceHueDirection =
        sourceLab.yz / sourceChroma;

    float2 hueCorrectedChroma =
        sourceHueDirection * rolledChroma;

    rolledLab.yz =
        lerp(
            rolledLab.yz,
            hueCorrectedChroma,
            strength
        );

    float3 correctedColor =
        renodx::color::bt709::from::OkLab(
            rolledLab
        );

    correctedColor =
        renodx::color::bt709::clamp::AP1(
            correctedColor
        );

    return SafePositive(
        max(correctedColor, 0.0f)
    );
}

bool IsVanillaMode()
{
    float modeDelta = RENODX_TONE_MAP_TYPE - RENODX_TONE_MAP_TYPE_VANILLA;
    return modeDelta > -0.5f && modeDelta < 0.5f;
}

bool IsPragmapMode()
{
    float modeDelta =
        RENODX_TONE_MAP_TYPE
        - RENODX_TONE_MAP_TYPE_PRAGMAP;

    return modeDelta > -0.5f
        && modeDelta < 0.5f;
}

float SafeDivideSigned1(float numerator, float denominator)
{
    numerator = (numerator == numerator) ? numerator : 0.0f;
    denominator = (denominator == denominator) ? denominator : 0.0f;

    const float epsilon = 0.000001f;
    if (denominator > -epsilon && denominator < epsilon)
    {
        denominator = denominator < 0.0f ? -epsilon : epsilon;
    }

    return clamp(numerator / denominator, -65504.0f, 65504.0f);
}

// Exact rational curve from the dumped shader, kept in linear output space.
// Exact original rational curve before the pass's final SDR clamp.
// ============================================================================
// Actual original-SDR luminance match
// ============================================================================
//
// The target is the REAL Ghosts SDR result, not a luminance-compressed copy of
// the HDR tonemapper output.
//
// Full SDR luminance guidance is kept through the 0.18 scene pivot, then
// released by PRE-TONEMAP scene brightness. The SDR white shoulder also
// releases the match so HDR highlights are not pulled back to SDR clipping.
#ifndef RENODX_GHOSTS_SDR_LUMA_MATCH_FULL
#define RENODX_GHOSTS_SDR_LUMA_MATCH_FULL 0.18f
#endif

#ifndef RENODX_GHOSTS_SDR_LUMA_MATCH_END
#define RENODX_GHOSTS_SDR_LUMA_MATCH_END 1.10f
#endif

#ifndef RENODX_GHOSTS_SDR_LUMA_MATCH_STRENGTH
#define RENODX_GHOSTS_SDR_LUMA_MATCH_STRENGTH 1.00f
#endif

#ifndef RENODX_GHOSTS_SDR_LUMA_MATCH_MIN_SCALE
#define RENODX_GHOSTS_SDR_LUMA_MATCH_MIN_SCALE 0.25f
#endif

#ifndef RENODX_GHOSTS_SDR_LUMA_MATCH_MAX_SCALE
#define RENODX_GHOSTS_SDR_LUMA_MATCH_MAX_SCALE 4.00f
#endif

#ifndef RENODX_GHOSTS_SDR_LUMA_RELEASE_START
#define RENODX_GHOSTS_SDR_LUMA_RELEASE_START 0.55f
#endif

#ifndef RENODX_GHOSTS_SDR_LUMA_RELEASE_END
#define RENODX_GHOSTS_SDR_LUMA_RELEASE_END 0.90f
#endif

float ComputeGhostsActualSDRLumaWeight(float3 actualSDRColor)
{
    actualSDRColor =
        saturate(
            SafePositive(
                max(actualSDRColor, 0.0f)
            )
        );

    const float epsilon = 0.000001f;

    float startPoint =
        max(
            RENODX_GHOSTS_SDR_LUMA_RELEASE_START,
            0.0f
        );

    float endPoint =
        max(
            RENODX_GHOSTS_SDR_LUMA_RELEASE_END,
            startPoint + epsilon
        );

    float sdrPeak =
        MaxRGB(
            actualSDRColor
        );

    float shoulderAmount =
        SmoothCubic01(
            (sdrPeak - startPoint)
            / (endPoint - startPoint)
        );

    return 1.0f - shoulderAmount;
}

float3 ApplyGhostsActualSDRLuminanceMatch(
    float3 hdrColor,
    float3 actualSDRColor,
    float3 preTonemapColor)
{
    hdrColor =
        SafePositive(
            max(hdrColor, 0.0f)
        );

    actualSDRColor =
        saturate(
            SafePositive(
                max(actualSDRColor, 0.0f)
            )
        );

    preTonemapColor =
        SafePositive(
            max(preTonemapColor, 0.0f)
        );

    const float epsilon = 0.000001f;

    float hdrY =
        max(
            renodx::color::y::from::BT709(hdrColor),
            epsilon
        );

    float sdrY =
        max(
            renodx::color::y::from::BT709(actualSDRColor),
            0.0f
        );

    float targetScale =
        sdrY / hdrY;

    targetScale =
        clamp(
            targetScale,
            max(
                RENODX_GHOSTS_SDR_LUMA_MATCH_MIN_SCALE,
                epsilon
            ),
            max(
                RENODX_GHOSTS_SDR_LUMA_MATCH_MAX_SCALE,
                RENODX_GHOSTS_SDR_LUMA_MATCH_MIN_SCALE
            )
        );

    float scenePeak =
        MaxRGB(
            preTonemapColor
        );

    float fullPoint =
        max(
            RENODX_GHOSTS_SDR_LUMA_MATCH_FULL,
            0.0f
        );

    float endPoint =
        max(
            RENODX_GHOSTS_SDR_LUMA_MATCH_END,
            fullPoint + epsilon
        );

    float release =
        saturate(
            (scenePeak - fullPoint)
            / (endPoint - fullPoint)
        );

    float smoothRelease =
        SmoothCubic01(
            release
        );

    // Earlier than normal smoothstep so the SDR shoulder cannot become a
    // horizontal HDR shelf.
    float earlyRelease =
        sqrt(
            max(
                smoothRelease,
                0.0f
            )
        );

    float sdrWeight =
        ComputeGhostsActualSDRLumaWeight(
            actualSDRColor
        );

    float matchWeight =
        (1.0f - earlyRelease)
        * sdrWeight
        * saturate(
            RENODX_GHOSTS_SDR_LUMA_MATCH_STRENGTH
        );

    float safeScale =
        max(
            targetScale,
            epsilon
        );

    float appliedScale =
        exp2(
            log2(safeScale)
            * matchWeight
        );

    return SafePositive(
        max(
            hdrColor * appliedScale,
            0.0f
        )
    );
}

float3 ApplyOriginalRationalTonemapUnclamped(float3 sceneColor)
{
    sceneColor =
        SafePositive(
            max(sceneColor, 0.0f)
        );

    float3 sceneSquared =
        sceneColor * sceneColor;

    float3 linearTerm =
        cb2[6].xyz * sceneColor;

    float3 quadraticTerm =
        cb2[8].xyz * sceneSquared;

    float3 numerator =
        cb2[7].xyz * linearTerm
        + quadraticTerm
        + cb2[3].xyz;

    float3 denominator =
        quadraticTerm
        + linearTerm
        + cb2[4].xyz;

    float3 color = float3(
        SafeDivideSigned1(numerator.r, denominator.r),
        SafeDivideSigned1(numerator.g, denominator.g),
        SafeDivideSigned1(numerator.b, denominator.b)
    );

    color =
        (color - cb2[5].xyz)
        * cb2[9].xyz;

    return color;
}

float3 ApplyOriginalRationalTonemap(float3 sceneColor)
{
    return saturate(
        SafePositive(
            max(
                ApplyOriginalRationalTonemapUnclamped(sceneColor),
                0.0f
            )
        )
    );
}

// Exact first derivative of the original Ghosts rational tonemapper.
//
// N(x) = cb2[3] + cb2[7]*cb2[6]*x + cb2[8]*x^2
// D(x) = cb2[4] + cb2[6]*x          + cb2[8]*x^2
//
// F(x) = cb2[9] * (N(x) / D(x) - cb2[5])
float3 GetOriginalTonemapSlope(float inputValue)
{
    float x =
        max(inputValue, 0.0f);

    float xSquared =
        x * x;

    float3 denominatorLinear =
        cb2[6].xyz;

    float3 numeratorLinear =
        cb2[7].xyz * cb2[6].xyz;

    float3 quadratic =
        cb2[8].xyz;

    float3 numerator =
        cb2[3].xyz
        + numeratorLinear * x
        + quadratic * xSquared;

    float3 denominator =
        cb2[4].xyz
        + denominatorLinear * x
        + quadratic * xSquared;

    float3 numeratorDerivative =
        numeratorLinear
        + 2.0f * quadratic * x;

    float3 denominatorDerivative =
        denominatorLinear
        + 2.0f * quadratic * x;

    float3 derivativeNumerator =
        numeratorDerivative * denominator
        - numerator * denominatorDerivative;

    float3 derivativeDenominator =
        denominator * denominator;

    float3 rationalSlope = float3(
        SafeDivideSigned1(
            derivativeNumerator.r,
            derivativeDenominator.r
        ),
        SafeDivideSigned1(
            derivativeNumerator.g,
            derivativeDenominator.g
        ),
        SafeDivideSigned1(
            derivativeNumerator.b,
            derivativeDenominator.b
        )
    );

    return rationalSlope * cb2[9].xyz;
}


float3 ApplyOriginalLinearPiecewiseExtension(float3 sceneColor)
{
    sceneColor =
        SafePositive(
            max(sceneColor, 0.0f)
        );

    float pivot =
        max(
            RENODX_GHOSTS_LINEAR_EXTENSION_PIVOT,
            0.000001f
        );

    float3 originalCurve =
        ApplyOriginalRationalTonemapUnclamped(
            sceneColor
        );

    float3 outputAtPivot =
        ApplyOriginalRationalTonemapUnclamped(
            pivot.xxx
        );

    float3 slopeAtPivot =
        GetOriginalTonemapSlope(
            pivot
        );

    float3 linearExtension =
        slopeAtPivot * (sceneColor - pivot.xxx)
        + outputAtPivot;

    return SafePositive(
        max(
            float3(
                sceneColor.r <= pivot ? originalCurve.r : linearExtension.r,
                sceneColor.g <= pivot ? originalCurve.g : linearExtension.g,
                sceneColor.b <= pivot ? originalCurve.b : linearExtension.b
            ),
            0.0f
        )
    );
}

float3 LinearToSRGB(float3 linearColor)
{
    linearColor = saturate(SafePositive(linearColor));

    float3 safeColor = max(linearColor, 0.00000001f.xxx);
    float3 highEncoded =
        exp2(log2(safeColor) * 0.416666657f)
        * 1.05499995f
        - 0.0549999997f;

    float3 lowEncoded = linearColor * 12.9200001f;

    return float3(
        linearColor.r <= 0.00313080009f ? lowEncoded.r : highEncoded.r,
        linearColor.g <= 0.00313080009f ? lowEncoded.g : highEncoded.g,
        linearColor.b <= 0.00313080009f ? lowEncoded.b : highEncoded.b);
}

float3 ApplyOriginalEncodedOutput(float3 linearColor)
{
    float3 encodedColor = LinearToSRGB(linearColor);
    encodedColor = (encodedColor - cb2[36].xxx) * cb2[36].yyy;
    return saturate(encodedColor);
}

// Exposure, contrast, flare, shadows, and highlights are applied by luminance,
// so RGB ratios and hue remain stable.
float3 ApplyPreTonemapControls(float3 sceneColor)
{
    sceneColor = SafePositive(sceneColor);

    renodx::color::grade::Config config =
        renodx::color::grade::config::Create();

    config.exposure = RENODX_TONE_MAP_EXPOSURE;
    config.contrast = RENODX_TONE_MAP_CONTRAST;
    config.flare = RENODX_TONE_MAP_FLARE;
    config.shadows = RENODX_TONE_MAP_SHADOWS;
    config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

    float midGray = max(RENODX_TONEMAPPER_MID_GRAY, 0.000001f);
    float sourceY = max(renodx::color::y::from::BT709(sceneColor), 0.0f);

    float3 color = sceneColor * config.exposure;
    float exposedY = max(sourceY * config.exposure, 0.0f);
    float normalizedY = exposedY / midGray;

    float flareScale = renodx::math::DivideSafe(
        normalizedY + config.flare,
        normalizedY,
        1.0f);

    float contrastedY = pow(
        max(normalizedY, 0.0f),
        config.contrast * flareScale);

    float highlightedY =
        GhostsSafePowPositive1(
            contrastedY,
            config.highlights
        );

    highlightedY = lerp(
        contrastedY,
        highlightedY,
        saturate(contrastedY / (1.0f / midGray)));

    float shadowedY =
        GhostsSafePowPositive1(
            highlightedY,
            -(config.shadows - 2.0f)
        );

    shadowedY = lerp(
        shadowedY,
        highlightedY,
        saturate(highlightedY / midGray));

    float finalY = shadowedY * midGray;
    color *= exposedY > 0.0f ? finalY / exposedY : 0.0f;

    return SafePositive(color);
}

float3 ApplyHDRDisplayMap(float3 sceneColor)
{
    sceneColor = SafePositive(sceneColor);
    sceneColor = renodx::color::bt709::clamp::AP1(sceneColor);

    float displayPeak = max(
        RENODX_PEAK_WHITE_NITS
        / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f),
        1.0f);

    float whiteClip = max(
        RENODX_TONEMAPPER_WHITE_CLIP,
        displayPeak + 0.000001f);

    float3 mappedColor;

    [branch]
    if (RENODX_TONE_MAP_PER_CHANNEL < 0.5f)
    {
        mappedColor =
            renodx::tonemap::HermiteSplineLuminanceRolloff(
                sceneColor,
                displayPeak,
                whiteClip);
    }
    else
    {
        mappedColor =
            renodx::tonemap::HermiteSplinePerChannelRolloff(
                sceneColor,
                displayPeak,
                whiteClip);
    }

    return SafePositive(mappedColor);
}

// ============================================================================
// Pragmap HDR display mapper
// ============================================================================
//
// This is a complete, parallel HDR tonemapper.
//
// It receives the same pre-tonemap linear color as the RenoDRT branch and uses
// the configured RenoDX peak relative to diffuse white.
// ============================================================================
// Ghosts-side Pragmap main shoulder control
// ============================================================================
//
// pragmap.hlsl stays completely untouched.
//
// Stock Pragmap uses:
//
//     toneCompression = 1.50
//
// for BOTH the luminance shoulder and max-channel blowout shoulder.
//
// The addon Shoulder Compression slider stores 0.75 at its default, so this
// wrapper maps:
//
//     0.75 * 2.0 = 1.50
//
// That makes the slider control Pragmap's MAIN shoulder instead of only an
// extra near-peak post-process stage.
float3 ApplyPragmapWithMainCompression(
    float3 color,
    float peak,
    float hueStrength,
    float blowoutStrength,
    float mainCompression)
{
    color =
        SafePositive(
            max(color, 0.0f)
        );

    peak =
        max(
            GhostsFiniteSigned1(peak),
            0.000001f
        );

    mainCompression =
        max(
            GhostsFiniteSigned1(mainCompression),
            0.01f
        );

    float y1 =
        max(
            renodx::color::y::from::BT709(color),
            0.0f
        );

    float y2 =
        anchoredCInfinityShoulder(
            y1,
            peak,
            toneAnchor,
            mainCompression
        );

    y2 =
        SafeFinitePositive1(
            y2
        );

    float m1 =
        max(
            color.r,
            max(color.g, color.b)
        );

    float m2 =
        anchoredCInfinityShoulder(
            m1,
            peak,
            toneAnchor,
            mainCompression
        );

    m2 =
        SafeFinitePositive1(
            m2
        );

    float mDiff =
        saturate(
            renodx::math::DivideSafe(
                m2,
                m1,
                1.0f
            )
        );

    float hueDriver =
        renodx::math::DivideSafe(
            y2 - toneAnchor,
            peak - toneAnchor,
            0.0f
        );

    float3 jzazbz =
        jzazbzFromBt709(
            color
        );

    jzazbz =
        GhostsFiniteSigned3(
            jzazbz
        );

    jzazbz =
        hueShiftBezoldBrucke(
            jzazbz,
            hueDriver,
            hueStrength
        );

    jzazbz =
        GhostsFiniteSigned3(
            jzazbz
        );

    float3 blownOutColor =
        jzazbz;

    blownOutColor.yz *=
        mDiff;

    jzazbz =
        lerp(
            jzazbz,
            blownOutColor,
            blowoutStrength
        );

    jzazbz =
        GhostsFiniteSigned3(
            jzazbz
        );

    color =
        bt709FromJzAzBz(
            jzazbz
        );

    color =
        SafePositive(
            max(color, 0.0f)
        );

    float reconstructedY =
        max(
            renodx::color::y::from::BT709(color),
            0.000001f
        );

    color *=
        renodx::math::DivideSafe(
            y2,
            reconstructedY,
            1.0f
        );

    color =
        SafePositive(
            max(color, 0.0f)
        );

    // Keep Pragmap's original final overshoot correction unchanged.
    color =
        overshootCorrection(
            color,
            peak,
            overshootShoulder,
            0.75f
        );

    return SafePositive(
        max(color, 0.0f)
    );
}

float3 ApplyPragmapTonemap(float3 linearColor)
{
    linearColor =
        SafePositive(
            max(linearColor, 0.0f)
        );

    float safePeakWhite =
        GhostsSafePositiveParameter1(
            RENODX_PEAK_WHITE_NITS,
            1000.0f
        );

    float safeDiffuseWhite =
        max(
            GhostsSafePositiveParameter1(
                RENODX_DIFFUSE_WHITE_NITS,
                203.0f
            ),
            1.0f
        );

    float displayPeak =
        clamp(
            safePeakWhite / safeDiffuseWhite,
            1.000001f,
            65504.0f
        );

    // Hue control.
    float hueControl =
        saturate(
            GhostsFiniteSigned1(
                RENODX_PRAGMAP_HUE_STRENGTH
            )
        );

    float pragmapHueStrength =
        hueControl;

    if (hueControl > 0.25f)
    {
        float hueHighRange =
            saturate(
                (hueControl - 0.25f)
                / 0.75f
            );

        pragmapHueStrength =
            lerp(
                0.25f,
                4.0f,
                hueHighRange
            );
    }

    // Blowout control.
    float blowoutControl =
        saturate(
            GhostsFiniteSigned1(
                RENODX_PRAGMAP_BLOWOUT_STRENGTH
            )
        );

    float pragmapBlowoutStrength =
        blowoutControl;

    if (blowoutControl > 0.20f)
    {
        float blowoutHighRange =
            saturate(
                (blowoutControl - 0.20f)
                / 0.80f
            );

        pragmapBlowoutStrength =
            lerp(
                0.20f,
                4.0f,
                blowoutHighRange
            );
    }

    // Shoulder position remains a separate optional final-stage control.
    float pragmapShoulder =
        clamp(
            GhostsFiniteSigned1(
                RENODX_PRAGMAP_SHOULDER
            ),
            0.01f,
            0.99f
        );

    // Shoulder Compression now controls Pragmap's MAIN toneCompression.
    //
    // Existing addon parse:
    //     75% -> 0.75
    //
    // Stock Pragmap:
    //     toneCompression = 1.50
    //
    // Therefore:
    //     effectiveMainCompression = sliderValue * 2.0
    float compressionControl =
        clamp(
            GhostsFiniteSigned1(
                RENODX_PRAGMAP_SHOULDER_COMPRESSION
            ),
            0.01f,
            4.0f
        );

    float pragmapMainCompression =
        max(
            compressionControl * 2.0f,
            0.02f
        );

    float3 mappedColor =
        ApplyPragmapWithMainCompression(
            linearColor,
            displayPeak,
            pragmapHueStrength,
            pragmapBlowoutStrength,
            pragmapMainCompression
        );

    mappedColor =
        SafePositive(
            max(mappedColor, 0.0f)
        );

    // Keep Shoulder independent from Shoulder Compression.
    //
    // Changing only Shoulder from the stock 0.80 adds an extra final-stage
    // shoulder-position override. Its compression stays at stock 0.75.
    const float pragmapDefaultShoulder =
        0.80f;

    float shoulderDelta =
        GhostsFiniteSigned1(
            pragmapShoulder
            - pragmapDefaultShoulder
        );

    bool useExtraShoulderStage =
        shoulderDelta > 0.000001f
        || shoulderDelta < -0.000001f;

    if (useExtraShoulderStage)
    {
        mappedColor =
            overshootCorrection(
                mappedColor,
                displayPeak,
                pragmapShoulder,
                0.75f
            );

        mappedColor =
            SafePositive(
                max(mappedColor, 0.0f)
            );
    }

    return SafePositive(
        max(mappedColor, 0.0f)
    );
}

// Strict Ghosts-faithful HDR carrier.
//
// original curve / first-derivative extension
//     -> per-channel Hermite rolloff to HDR peak
//     -> hue-direction correction
float3 ApplySelectedHDRDisplayMap(float3 sceneColor)
{
    sceneColor =
        SafePositive(
            max(sceneColor, 0.0f)
        );

    // =====================================================================
    // Shared SDR-anchored carrier
    // =====================================================================
    //
    // Both HDR tonemappers now start from the SAME Ghosts-faithful signal:
    //
    //   below 0.18:
    //       original Ghosts rational tonemapper
    //
    //   above 0.18:
    //       exact first-derivative tangent extension
    //
    // Previously Pragmap received raw sceneColor here while RenoDRT received
    // the tangent-extended signal. That made Pragmap substantially brighter
    // and more washed out in this non-LUT pass.

    float3 extendedScene =
        ApplyOriginalLinearPiecewiseExtension(
            sceneColor
        );

    extendedScene =
        SafePositive(
            max(extendedScene, 0.0f)
        );

    // Explicit initialization avoids old FXC X4000 data-flow warnings.
    float3 selectedHDR =
        0.0f.xxx;

    [branch]
    if (IsPragmapMode())
    {
        // Pragmap now receives the same SDR-anchored carrier as RenoDRT.
        //
        // pragmap.hlsl itself remains completely unmodified.
        selectedHDR =
            ApplyPragmapTonemap(
                extendedScene
            );
    }
    else
    {
        float safePeakWhite =
            GhostsSafePositiveParameter1(
                RENODX_PEAK_WHITE_NITS,
                1000.0f
            );

        float safeDiffuseWhite =
            max(
                GhostsSafePositiveParameter1(
                    RENODX_DIFFUSE_WHITE_NITS,
                    203.0f
                ),
                1.0f
            );

        float displayPeak =
            clamp(
                safePeakWhite / safeDiffuseWhite,
                1.000001f,
                65504.0f
            );

        float whiteClip =
            max(
                GhostsFiniteSigned1(
                    RENODX_TONEMAPPER_WHITE_CLIP
                ),
                displayPeak + 0.000001f
            );

        float3 rolloffInput =
            renodx::color::bt709::clamp::AP1(
                extendedScene
            );

        rolloffInput =
            SafePositive(
                max(rolloffInput, 0.0f)
            );

        float3 hdrRolloff =
            renodx::tonemap::HermiteSplinePerChannelRolloff(
                rolloffInput,
                displayPeak,
                whiteClip
            );

        hdrRolloff =
            SafePositive(
                max(hdrRolloff, 0.0f)
            );

        hdrRolloff =
            CorrectGhostsPerChannelRolloffHue(
                rolloffInput,
                hdrRolloff
            );

        selectedHDR =
            SafePositive(
                max(hdrRolloff, 0.0f)
            );
    }

    return SafePositive(
        max(selectedHDR, 0.0f)
    );
}

float3 RestoreHDRHighlights(
    float3 toneMappedColor,
    float3 preTonemapColor
)
{
    toneMappedColor =
        SafePositive(toneMappedColor);

    preTonemapColor =
        SafePositive(preTonemapColor);

    float preTonemapPeak =
        MaxRGB(preTonemapColor);

    float restoreRange = max(
        RENODX_HDR_HIGHLIGHT_FULL
        - RENODX_HDR_HIGHLIGHT_START,
        0.000001f
    );

    float restoreMask = saturate(
        (
            preTonemapPeak
            - RENODX_HDR_HIGHLIGHT_START
        )
        / restoreRange
    );

    restoreMask =
        SmoothCubic01(restoreMask);

    restoreMask *=
        saturate(RENODX_HDR_HIGHLIGHT_RESTORE);

    float3 restorationTarget =
        preTonemapColor;

#if RENODX_HDR_RESTORE_LIMIT_TO_DISPLAY

    // HDR values are relative to diffuse white.
    float displayPeak = max(
        RENODX_PEAK_WHITE_NITS
        / max(
            RENODX_DIFFUSE_WHITE_NITS,
            1.0f
        ),
        1.0f
    );

    if (preTonemapPeak > displayPeak)
    {
        restorationTarget *=
            displayPeak
            / max(
                preTonemapPeak,
                0.000001f
            );
    }

#endif

    return SafePositive(
        lerp(
            toneMappedColor,
            restorationTarget,
            restoreMask
        )
    );
}


// Saturation, Blowout, and Highlight Saturation after display mapping.
float3 ApplyPostTonemapControls(float3 mappedColor)
{
    mappedColor = SafePositive(mappedColor);

    renodx::color::grade::Config config =
        renodx::color::grade::config::Create();

    config.saturation = RENODX_TONE_MAP_SATURATION;
    config.dechroma = RENODX_TONE_MAP_BLOWOUT;
    config.blowout =
        -(RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.0f);

    float luminance = max(
        renodx::color::y::from::BT709(mappedColor),
        0.0f);

    float3 perceptual =
        renodx::color::oklab::from::BT709(mappedColor);

    if (config.dechroma != 0.0f)
    {
        float highlightAmount = saturate(
            pow(
                max(luminance / 100.0f, 0.0f),
                1.0f - config.dechroma));

        perceptual.yz *= 1.0f - highlightAmount;
    }

    if (config.blowout != 0.0f)
    {
        float blowoutMagnitude = config.blowout;
        if (blowoutMagnitude < 0.0f)
        {
            blowoutMagnitude = -blowoutMagnitude;
        }

        float blowoutChange = pow(
            1.0f - saturate(luminance / 100.0f),
            100.0f * blowoutMagnitude);

        if (config.blowout < 0.0f)
        {
            blowoutChange = 2.0f - blowoutChange;
        }

        perceptual.yz *= blowoutChange;
    }

    perceptual.yz *= config.saturation;

    float3 color = renodx::color::bt709::from::OkLab(perceptual);
    color = renodx::color::bt709::clamp::AP1(color);

    return SafePositive(color);
}

// Match the HDR color appearance to the game's actual original SDR result
// WITHOUT changing HDR luminance.
// Soft waveform-safe SDR luminance anchor.
// Match bright diffuse SDR luminance without inheriting the clipped SDR shoulder.
//
// RGB is scaled uniformly, so the SDR hue/saturation match remains unchanged.
// This function only lifts HDR when the SDR reference is brighter, and its
// influence fades to zero as PRE-TONEMAP scene intensity becomes highlight-like.
float3 MatchOriginalSDRShadows(float3 hdrColor, float3 vanillaColor)
{
    hdrColor = SafePositive(hdrColor);
    vanillaColor = saturate(SafePositive(vanillaColor));

    float strength = saturate(RENODX_TONEMAPPER_SDR_SHADOW_MATCH);
    if (strength <= 0.000001f)
    {
        return hdrColor;
    }

    float fullPoint = max(RENODX_TONEMAPPER_SDR_MATCH_FULL, 0.0f);
    float endPoint = max(
        RENODX_TONEMAPPER_SDR_MATCH_END,
        fullPoint + 0.000001f);

    float vanillaY = max(
        renodx::color::y::from::BT709(vanillaColor),
        0.0f);

    float hdrY = max(
        renodx::color::y::from::BT709(hdrColor),
        0.0f);

    float fadePosition = saturate(
        (vanillaY - fullPoint) / (endPoint - fullPoint));

    float matchMask =
        (1.0f - SmoothCubic01(fadePosition)) * strength;

    // Darken only; never raise the HDR black floor.
    float luminanceScale = min(
        vanillaY / max(hdrY, 0.000001f),
        1.0f);

    return SafePositive(
        lerp(hdrColor, hdrColor * luminanceScale, matchMask));
}

void main(
    float4 position : SV_POSITION0,
    float2 texcoord : TEXCOORD0,
    float sceneScale : TEXCOORD2,
    out float4 outputColor : SV_TARGET0)
{
    float4 source = t0.Sample(s0_s, texcoord);

    
    // Remove bad texture data before scene scaling can turn INF * 0 into NaN.
    source.rgb =
        SafePositive(
            max(source.rgb, 0.0f)
        );

    source.a =
        GhostsFiniteSigned1(
            source.a
        );

    sceneScale =
        GhostsFiniteSigned1(
            sceneScale
        );

    // HDR-only exposure damping.
    //
    // Vanilla keeps the exact incoming game exposure. RenoDRT and Pragmap use
    // the user-controlled strength to reduce rapid exposure pumping.
    if (!IsVanillaMode())
    {
        sceneScale =
            ApplyGhostsAutoExposureStrength(
                sceneScale
            );
    }
// This is the useful pre-tonemap linear scene signal.
    float3 sceneColor = SafePositive(
        source.rgb
        * sceneScale
        * max(RENODX_TONEMAPPER_INPUT_SCALE, 0.0f));

    // Vanilla mode must continue to use the untouched original scene signal.
    float3 vanillaLinear =
        ApplyOriginalRationalTonemap(sceneColor);

    if (IsVanillaMode())
    {
#if RENODX_TONEMAPPER_EXACT_ENCODED_VANILLA
        outputColor.rgb = ApplyOriginalEncodedOutput(vanillaLinear);
#else
        outputColor.rgb = saturate(SafePositive(
            renodx::draw::RenderIntermediatePass(vanillaLinear)));
#endif
        outputColor.a = source.a;
        return;
    }

    // Same pre-tonemap user-control stage as before.
    float3 preTonemapColor =
        ApplyPreTonemapControls(
            sceneColor
        );

    // Tonemapper 3 has no LUT. Its SDR reference is therefore the original
    // rational SDR tonemapper result from the same adjusted scene.
    float3 sdrShadowReference =
        ApplyOriginalRationalTonemap(
            preTonemapColor
        );

    float3 hdrColor =
        ApplySelectedHDRDisplayMap(
            preTonemapColor
        );

    // No 3D LUT exists in this pass, but its lower/midtone luminance still
    // follows the REAL original Ghosts SDR rational result.
    hdrColor =
        ApplyGhostsActualSDRLuminanceMatch(
            hdrColor,
            sdrShadowReference,
            preTonemapColor
        );

    // No Texture3D LUT exists in this pass, so there is no SDR LUT
    // transfer stage to apply.

#if RENODX_GHOSTS_ROLLOFF_TEST_USE_HIGHLIGHT_RESTORE

    hdrColor =
        RestoreHDRHighlights(
            hdrColor,
            preTonemapColor
        );

#endif

#if RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_COLOR_MATCH

    hdrColor =
        ApplyPartialAbsoluteSDRColorMatch(
            hdrColor,
            sdrShadowReference
        );

#endif

#if RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_SHADOW_MATCH

    hdrColor =
        MatchOriginalSDRShadows(
            hdrColor,
            sdrShadowReference
        );

#endif

    // Match Tonemapper 1's final user color-control ordering.
    hdrColor =
        ApplyPostTonemapControls(hdrColor);

    // Broad negative-value protection without clamping HDR above 1.0.
    hdrColor =
        SafePositive(
            max(
                hdrColor,
                0.0f.xxx));

    outputColor.rgb = SafePositive(
        renodx::draw::RenderIntermediatePass(hdrColor));

    outputColor.a = source.a;
}
    
