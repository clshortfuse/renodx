// HDR-safe replacement for the bloom mask/blob shaping pass.
//
// Original behavior:
//   1. Sample bloom.
//   2. Multiply RGB by 8.
//   3. Compute luminance.
//   4. add_sat(luminance + bias).
//   5. Raise the saturated mask to a power.
//   6. Apply gain/bias and multiply RGB by that mask.
//
// Problem with HDR bloom:
//   Bright values above the old SDR range drive add_sat() to 1.0 across a very
//   large area. The following pow/mad then produces a broad, nearly constant
//   mask, which appears as large distracting bloom blobs.
//
// This replacement:
//   - compresses HDR luminance before the game's original threshold curve;
//   - adds a sharper independent soft threshold for visible blob size;
//   - suppresses low-intensity outer bloom more strongly than the hot center;
//   - keeps the original register layout and alpha-as-mask behavior;
//   - does not apply a final RGB clamp.

#define BLOOM_INPUT_SCALE          8.0f

// Larger values compress HDR luminance more strongly before the original
// add/pow curve. Increase this if large bright regions still flatten together.
#define BLOOM_HDR_ROLLOFF          4.00f

// Visible-radius shaping. Raising START and FULL makes the blob smaller.
#define BLOOM_BLOB_START           0.10f
#define BLOOM_BLOB_FULL            1.50f

// Higher powers suppress the outer region more aggressively.
#define BLOOM_BLOB_POWER           5.00f

// Reduces the whole contribution without clipping HDR values.
#define BLOOM_OUTPUT_SCALE         0.05f

// Optional whitening. This preserves luminance, so it changes hue without
// intentionally increasing brightness or apparent radius.
#define BLOOM_WHITE_BASE_AMOUNT    0.20f
#define BLOOM_WHITE_CORE_AMOUNT    0.80f
#define BLOOM_WHITE_CORE_START     0.35f
#define BLOOM_WHITE_CORE_FULL      2.00f

sampler2D bloomSampler : register(s0);

float4 postFxControl0 : register(c5);
float4 postFxControl1 : register(c6);

struct PS_INPUT
{
    float2 texcoord : TEXCOORD0;
};

float BloomLuminance(float3 color)
{
    // Preserve the game's luminance vector where valid.
    float3 weights = postFxControl0.xyz;

    // Avoid a completely invalid/zero luminance vector.
    float weightMagnitude = abs(weights.r) + abs(weights.g) + abs(weights.b);
    if (weightMagnitude < 0.000001f)
    {
        weights = float3(0.2126f, 0.7152f, 0.0722f);
    }

    return dot(color, weights);
}

float SmoothCubic01(float value)
{
    value = saturate(value);
    return value * value * (3.0f - 2.0f * value);
}

float SmoothRange(float value, float rangeStart, float rangeFull)
{
    float rangeLength = max(rangeFull - rangeStart, 0.000001f);
    return SmoothCubic01((value - rangeStart) / rangeLength);
}

float4 main(PS_INPUT input) : COLOR0
{
    float4 bloomSample = tex2D(bloomSampler, input.texcoord);

    float3 scaledBloom = max(bloomSample.rgb, 0.0f) * BLOOM_INPUT_SCALE;
    float rawLuminance = max(BloomLuminance(scaledBloom), 0.0f);

    // HDR-safe compression into a stable 0..1-like working range.
    // Unlike add_sat(rawLuminance + bias), this does not create a large hard
    // plateau as soon as the bloom texture exceeds the old SDR range.
    float compressedLuminance = rawLuminance /
        max(1.0f + rawLuminance * BLOOM_HDR_ROLLOFF, 0.000001f);

    // Preserve the game's original bias, exponent, gain and offset controls,
    // but feed them the compressed luminance instead of raw HDR luminance.
    float originalCurveInput = saturate(
        compressedLuminance + postFxControl1.x
    );

    float curveExponent = max(postFxControl0.w, 0.000001f);
    float originalMask = pow(originalCurveInput, curveExponent);
    originalMask = originalMask * postFxControl1.y + postFxControl1.z;
    originalMask = max(originalMask, 0.0f);

    // Independent visible-radius mask. This is what majorly reduces the broad
    // low-intensity blob while still allowing the hottest center to survive.
    float blobMask = SmoothRange(
        rawLuminance,
        BLOOM_BLOB_START,
        BLOOM_BLOB_FULL
    );

    blobMask = pow(max(blobMask, 0.0f), BLOOM_BLOB_POWER);

    float finalMask = originalMask * blobMask * BLOOM_OUTPUT_SCALE;

    float3 outputColor = scaledBloom * finalMask;

    // Make the bloom progressively whiter toward the hot center, while
    // preserving output luminance after the color blend.
    float outputLuminance = max(
        dot(outputColor, float3(0.2126f, 0.7152f, 0.0722f)),
        0.0f
    );

    float whiteCoreMask = SmoothRange(
        rawLuminance,
        BLOOM_WHITE_CORE_START,
        BLOOM_WHITE_CORE_FULL
    );

    float whiteAmount = lerp(
        BLOOM_WHITE_BASE_AMOUNT,
        BLOOM_WHITE_CORE_AMOUNT,
        whiteCoreMask
    );

    float3 whiteTarget = outputLuminance.xxx;
    float3 whitenedColor = lerp(outputColor, whiteTarget, whiteAmount);

    float whitenedLuminance = max(
        dot(whitenedColor, float3(0.2126f, 0.7152f, 0.0722f)),
        0.000001f
    );

    if (outputLuminance > 0.0f)
    {
        whitenedColor *= outputLuminance / whitenedLuminance;
    }
    else
    {
        whitenedColor = 0.0f;
    }

    if (whitenedColor.r != whitenedColor.r) whitenedColor.r = 0.0f;
    if (whitenedColor.g != whitenedColor.g) whitenedColor.g = 0.0f;
    if (whitenedColor.b != whitenedColor.b) whitenedColor.b = 0.0f;
    if (finalMask != finalMask) finalMask = 0.0f;

    return float4(whitenedColor, finalMask);
}
