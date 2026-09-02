/*
 * SPDX-License-Identifier: MIT
 */

#ifndef RETINAL_FILTER_HORIZONTAL
#error RETINAL_FILTER_HORIZONTAL must be defined before including this file
#endif

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

// Vulkan permits at most one push-descriptor set in a pipeline layout. Keep
// every Retinal descriptor in that one set and use distinct bindings.
layout(set = 0, binding = 0) uniform SamplerState LinearClampSampler;
layout(set = 0, binding = 1) uniform texture2D SourceTexture;
layout(set = 0, binding = 2, rgba16f) uniform writeonly image2D OutputTexture;

layout(push_constant) uniform RetinalFilterConstantsBlock
{
    vec2 fixationUv;
    vec2 inverseOutputSize;
    vec2 outputSize;
    float tanHalfHorizontal;
    float tanHalfVertical;
    float horizontalPixelsPerDegree;
    float verticalPixelsPerDegree;
    float fixationBlend;
    float maximumSigmaPixels;
    float highQuality;
} RetinalConstants;

const float kPi = 3.14159265358979323846;
const float kRadiansToDegrees = 57.2957795130823208768;
const float kSqrtTwo = 1.4142135623730950488;
const float kSqrtThree = 1.7320508075688772935;
const float kGaussianHalfMtfScale = 0.18739062512927757;
const float kPeakConeDensity = 14804.6;
const float kMidgetFractionScaleDegrees = 41.03;
const float kMaximumSigmaPixels = 8.0;
const int kMaximumKernelRadius = 32;

float FiniteOr(float value, float fallbackValue)
{
    return (isnan(value) || isinf(value)) ? fallbackValue : value;
}

vec2 SanitizeUv(vec2 value)
{
    return clamp(
        vec2(FiniteOr(value.x, 0.5), FiniteOr(value.y, 0.5)),
        vec2(0.0),
        vec2(1.0));
}

void GetMeridianParameters(
    int meridian,
    out float mixture,
    out float rationalScaleDegrees,
    out float exponentialScaleDegrees)
{
    // Watson (2014), Table 1: temporal, superior, nasal, inferior.
    if (meridian == 0)
    {
        mixture = 0.9851;
        rationalScaleDegrees = 1.058;
        exponentialScaleDegrees = 22.14;
    }
    else if (meridian == 1)
    {
        mixture = 0.9935;
        rationalScaleDegrees = 1.035;
        exponentialScaleDegrees = 16.35;
    }
    else if (meridian == 2)
    {
        mixture = 0.9729;
        rationalScaleDegrees = 1.084;
        exponentialScaleDegrees = 7.633;
    }
    else
    {
        mixture = 0.9960;
        rationalScaleDegrees = 0.9932;
        exponentialScaleDegrees = 12.13;
    }
}

float ComputeMidgetDensity(float eccentricityDegrees, int meridian)
{
    float eccentricity = clamp(FiniteOr(eccentricityDegrees, 0.0), 0.0, 120.0);
    float mixture;
    float rationalScale;
    float exponentialScale;
    GetMeridianParameters(
        meridian, mixture, rationalScale, exponentialScale);
    float midgetFraction = 1.0
        / (1.0 + eccentricity / kMidgetFractionScaleDegrees);
    float rational = 1.0 + eccentricity / rationalScale;
    float meridianDensity = mixture / (rational * rational)
        + (1.0 - mixture) * exp(-eccentricity / exponentialScale);
    return max(
        FiniteOr(
            2.0 * kPeakConeDensity * midgetFraction * meridianDensity,
            1.0),
        1.0);
}

float ComputeMosaicSpacing(float eccentricityDegrees, int meridian)
{
    float density = ComputeMidgetDensity(eccentricityDegrees, meridian);
    return max(FiniteOr(sqrt(4.0 / (kSqrtThree * density)), 1.0), 1.0e-8);
}

float ComputeMonocularSpacing(vec2 eccentricityDegrees)
{
    vec2 position = clamp(
        vec2(
            FiniteOr(eccentricityDegrees.x, 0.0),
            FiniteOr(eccentricityDegrees.y, 0.0)),
        vec2(-120.0),
        vec2(120.0));
    float radius = min(length(position), 120.0);
    if (radius <= 1.0e-6)
    {
        return ComputeMosaicSpacing(0.0, 0);
    }

    int horizontalMeridian = position.x >= 0.0 ? 0 : 2;
    int verticalMeridian = position.y >= 0.0 ? 1 : 3;
    float horizontalSpacing = ComputeMosaicSpacing(
        radius, horizontalMeridian);
    float verticalSpacing = ComputeMosaicSpacing(
        radius, verticalMeridian);
    return max(
        FiniteOr(
            sqrt(
                position.x * position.x
                    * horizontalSpacing * horizontalSpacing
                + position.y * position.y
                    * verticalSpacing * verticalSpacing)
                / radius,
            horizontalSpacing),
        1.0e-8);
}

float ComputeRetinalNyquist(vec2 eccentricityDegrees)
{
    float rightSpacing = ComputeMonocularSpacing(eccentricityDegrees);
    float leftSpacing = ComputeMonocularSpacing(
        vec2(-eccentricityDegrees.x, eccentricityDegrees.y));
    float rightSquared = rightSpacing * rightSpacing;
    float leftSquared = leftSpacing * leftSpacing;
    float binocularSpacing = kSqrtTwo * sqrt(
        rightSquared * leftSquared
        / max(rightSquared + leftSquared, 1.0e-8));
    float nyquist = 1.0 / (kSqrtThree * max(binocularSpacing, 1.0e-8));
    return clamp(FiniteOr(nyquist, 0.0), 0.0, 65.5);
}

float ComputeAdditionalSigma(
    float retinalNyquist,
    float pixelsPerDegree)
{
    float blend = clamp(FiniteOr(RetinalConstants.fixationBlend, 0.0), 0.0, 1.0);
    float sigmaLimit = clamp(
        FiniteOr(RetinalConstants.maximumSigmaPixels, 8.0),
        0.0,
        8.0);
    if (retinalNyquist <= 0.0 || pixelsPerDegree <= 0.0
        || blend <= 0.0 || sigmaLimit <= 0.0)
    {
        return 0.0;
    }

    float displayNyquist = pixelsPerDegree * 0.5;
    float addedVarianceFrequency = max(
        1.0 / (retinalNyquist * retinalNyquist)
            - 1.0 / (displayNyquist * displayNyquist),
        0.0);
    float sigma = kGaussianHalfMtfScale * pixelsPerDegree
        * sqrt(addedVarianceFrequency) * sqrt(blend);
    return clamp(FiniteOr(sigma, 0.0), 0.0, sigmaLimit);
}

vec2 ComputeAxisSigmas(vec2 uv)
{
    float tanHalfHorizontal = max(
        FiniteOr(RetinalConstants.tanHalfHorizontal, 0.7002075),
        1.0e-6);
    float tanHalfVertical = max(
        FiniteOr(RetinalConstants.tanHalfVertical, tanHalfHorizontal),
        1.0e-6);
    vec2 fixationUv = SanitizeUv(RetinalConstants.fixationUv);
    vec3 samplePlane = vec3(
        (uv.x * 2.0 - 1.0) * tanHalfHorizontal,
        (1.0 - uv.y * 2.0) * tanHalfVertical,
        1.0);
    vec3 fixationPlane = vec3(
        (fixationUv.x * 2.0 - 1.0) * tanHalfHorizontal,
        (1.0 - fixationUv.y * 2.0) * tanHalfVertical,
        1.0);
    vec3 sampleRay = normalize(samplePlane);
    vec3 fixationRay = normalize(fixationPlane);
    float eccentricity = clamp(
        acos(clamp(dot(sampleRay, fixationRay), -1.0, 1.0))
            * kRadiansToDegrees,
        0.0,
        120.0);
    vec2 planeDelta = samplePlane.xy - fixationPlane.xy;
    float planeDistance = length(planeDelta);
    vec2 eccentricityPosition = planeDistance > 1.0e-6
        ? eccentricity * planeDelta / planeDistance
        : vec2(0.0);
    float retinalNyquist = ComputeRetinalNyquist(eccentricityPosition);
    float horizontalPixelsPerDegree = max(
        FiniteOr(RetinalConstants.horizontalPixelsPerDegree, 0.0),
        0.0);
    float verticalPixelsPerDegree = max(
        FiniteOr(RetinalConstants.verticalPixelsPerDegree, 0.0),
        0.0);
    return vec2(
        ComputeAdditionalSigma(retinalNyquist, horizontalPixelsPerDegree),
        ComputeAdditionalSigma(retinalNyquist, verticalPixelsPerDegree));
}

ivec2 ClampSourcePixel(ivec2 pixel)
{
    ivec2 maximumPixel = max(
        ivec2(RetinalConstants.outputSize) - ivec2(1),
        ivec2(0));
    return clamp(pixel, ivec2(0), maximumPixel);
}

vec4 LoadSource(ivec2 pixel)
{
    return SourceTexture.Load(ivec3(ClampSourcePixel(pixel), 0));
}

vec4 SampleSource(ivec2 centerPixel, float signedOffset)
{
#if RETINAL_FILTER_HORIZONTAL
    vec2 offset = vec2(signedOffset, 0.0);
#else
    vec2 offset = vec2(0.0, signedOffset);
#endif
    vec2 halfTexel = RetinalConstants.inverseOutputSize * 0.5;
    vec2 uv = (vec2(centerPixel) + vec2(0.5) + offset)
        * RetinalConstants.inverseOutputSize;
    uv = clamp(uv, halfTexel, vec2(1.0) - halfTexel);
    return SourceTexture.SampleLevel(LinearClampSampler, uv, 0.0);
}

vec3 FilterLinearGaussian(
    ivec2 pixel,
    vec3 centerColor,
    float sigmaPixels,
    float radiusScale)
{
    int radius = min(
        int(ceil(sigmaPixels * radiusScale)),
        kMaximumKernelRadius);
    vec3 sum = centerColor;
    float weightSum = 1.0;

    // For g(n) = exp(-n^2 / (2*sigma^2)), the multiplier from g(n) to
    // g(n+1) itself changes by the constant exp(-1/sigma^2). This recurrence
    // evaluates exactly the same discrete Gaussian weights with two exp()
    // operations per pixel instead of one per tap.
    float inverseVariance = 1.0 / (sigmaPixels * sigmaPixels);
    float weightStep = exp(-0.5 * inverseVariance);
    float weightStepRatio = exp(-inverseVariance);
    float previousWeight = 1.0;

    // RasterGrid pairing: two adjacent fixed Gaussian taps are represented by
    // one hardware-linear sample at their weighted sub-texel position. Both
    // signs remain independent, so the symmetric separable kernel, cutoff,
    // normalization, RGB and edge-clamp behavior are unchanged.
    for (int firstOffset = 1;
         firstOffset <= kMaximumKernelRadius;
         firstOffset += 2)
    {
        if (firstOffset > radius)
        {
            break;
        }

        float firstWeight = previousWeight * weightStep;
        weightStep *= weightStepRatio;

        int secondOffset = firstOffset + 1;
        float secondWeight = 0.0;
        if (secondOffset <= radius)
        {
            secondWeight = firstWeight * weightStep;
            weightStep *= weightStepRatio;
            previousWeight = secondWeight;
        }
        else
        {
            previousWeight = firstWeight;
        }

        float pairWeight = firstWeight + secondWeight;
        if (pairWeight <= 0.0)
        {
            // Very small sigma can flush every non-center weight to zero.
            // All later Gaussian weights are smaller, so the center-only
            // result is already complete and avoids a 0/0 paired offset.
            break;
        }
        float pairedOffset = (
            float(firstOffset) * firstWeight
            + float(secondOffset) * secondWeight) / pairWeight;
        sum += (SampleSource(pixel, pairedOffset).xyz
            + SampleSource(pixel, -pairedOffset).xyz) * pairWeight;
        weightSum += 2.0 * pairWeight;
    }
    return sum / weightSum;
}

vec3 FilterBalanced(ivec2 pixel, vec3 centerColor, float sigmaPixels)
{
    return FilterLinearGaussian(pixel, centerColor, sigmaPixels, 3.0);
}

vec3 FilterHigh(ivec2 pixel, vec3 centerColor, float sigmaPixels)
{
    return FilterLinearGaussian(pixel, centerColor, sigmaPixels, 4.0);
}

void main()
{
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    ivec2 outputSize = ivec2(RetinalConstants.outputSize);
    if (pixel.x < 0 || pixel.y < 0
        || pixel.x >= outputSize.x || pixel.y >= outputSize.y)
    {
        return;
    }

    vec4 centerSource = LoadSource(pixel);
#if RETINAL_FILTER_HORIZONTAL
    vec2 uv = (vec2(pixel) + vec2(0.5))
        * RetinalConstants.inverseOutputSize;
    vec2 axisSigmas = ComputeAxisSigmas(uv);
    float sigmaPixels = axisSigmas.x;
#else
    // Detroit's exact composite writes alpha=1. The private RGBA16F scratch
    // may therefore carry the per-pixel vertical sigma produced horizontally;
    // the final pass restores the native alpha contract below.
    float sigmaLimit = clamp(
        FiniteOr(RetinalConstants.maximumSigmaPixels, kMaximumSigmaPixels),
        0.0,
        kMaximumSigmaPixels);
    float sigmaPixels = clamp(
        FiniteOr(centerSource.w, 0.0),
        0.0,
        sigmaLimit);
#endif
    vec3 result;
    if (sigmaPixels <= 1.0e-4)
    {
        result = centerSource.xyz;
    }
    else if (RetinalConstants.highQuality >= 0.5)
    {
        result = FilterHigh(pixel, centerSource.xyz, sigmaPixels);
    }
    else
    {
        result = FilterBalanced(pixel, centerSource.xyz, sigmaPixels);
    }
#if RETINAL_FILTER_HORIZONTAL
    imageStore(OutputTexture, pixel, vec4(result, axisSigmas.y));
#else
    imageStore(OutputTexture, pixel, vec4(result, 1.0));
#endif
}
