/*
 * SPDX-License-Identifier: MIT
 */

#ifndef RETINAL_FILTER_HORIZONTAL
#error RETINAL_FILTER_HORIZONTAL must be defined before including this file
#endif

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(set = 0, binding = 0) uniform SamplerState LinearClampSampler;
layout(set = 1, binding = 0) uniform texture2D SourceTexture;
layout(set = 2, binding = 0, rgba16f) uniform writeonly image2D OutputTexture;

layout(push_constant) uniform RetinalFilterConstantsBlock
{
    vec2 fixationUv;
    vec2 inverseOutputSize;
    vec2 outputSize;
    float horizontalScreenAngleDegrees;
    float fixationBlend;
    float maximumSigmaPixels;
    float highQuality;
} RetinalConstants;

const float kPi = 3.14159265358979323846;
const float kRadiansToDegrees = 57.2957795130823208768;
const float kDegreesToRadians = 0.01745329251994329577;
const float kSqrtTwo = 1.4142135623730950488;
const float kSqrtThree = 1.7320508075688772935;
const float kGaussianHalfMtfScale = 0.18739062512927757;
const float kPeakConeDensity = 14804.6;
const float kMidgetFractionScaleDegrees = 41.03;
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

float ComputeAxisSigma(vec2 uv)
{
    vec2 size = max(
        vec2(
            FiniteOr(RetinalConstants.outputSize.x, 1.0),
            FiniteOr(RetinalConstants.outputSize.y, 1.0)),
        vec2(1.0));
    float aspect = size.x / size.y;
    float horizontalAngle = clamp(
        FiniteOr(RetinalConstants.horizontalScreenAngleDegrees, 70.0),
        30.0,
        120.0);
    float tanHalfHorizontal = tan(horizontalAngle * kDegreesToRadians * 0.5);
    vec2 fixationUv = SanitizeUv(RetinalConstants.fixationUv);
    vec3 samplePlane = vec3(
        (uv.x * 2.0 - 1.0) * tanHalfHorizontal,
        (1.0 - uv.y * 2.0) * tanHalfHorizontal / aspect,
        1.0);
    vec3 fixationPlane = vec3(
        (fixationUv.x * 2.0 - 1.0) * tanHalfHorizontal,
        (1.0 - fixationUv.y * 2.0) * tanHalfHorizontal / aspect,
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

#if RETINAL_FILTER_HORIZONTAL
    float pixelsPerDegree = size.x / horizontalAngle;
#else
    float verticalAngle = 2.0 * atan(tanHalfHorizontal / aspect)
        * kRadiansToDegrees;
    float pixelsPerDegree = size.y / max(verticalAngle, 1.0e-6);
#endif
    return ComputeAdditionalSigma(retinalNyquist, pixelsPerDegree);
}

float GaussianWeight(float offsetPixels, float sigmaPixels)
{
    if (sigmaPixels <= 1.0e-6)
    {
        return abs(offsetPixels) <= 1.0e-6 ? 1.0 : 0.0;
    }
    return exp(
        -(offsetPixels * offsetPixels)
        / (2.0 * sigmaPixels * sigmaPixels));
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

vec4 FilterHigh(ivec2 pixel, float sigmaPixels)
{
    int radius = min(int(ceil(sigmaPixels * 4.0)), kMaximumKernelRadius);
    vec4 sum = vec4(0.0);
    float weightSum = 0.0;
    for (int offset = -kMaximumKernelRadius;
         offset <= kMaximumKernelRadius;
         ++offset)
    {
        if (abs(offset) > radius)
        {
            continue;
        }
        float weight = GaussianWeight(float(offset), sigmaPixels);
#if RETINAL_FILTER_HORIZONTAL
        ivec2 samplePixel = pixel + ivec2(offset, 0);
#else
        ivec2 samplePixel = pixel + ivec2(0, offset);
#endif
        sum += LoadSource(samplePixel) * weight;
        weightSum += weight;
    }
    return weightSum > 0.0 ? sum / weightSum : LoadSource(pixel);
}

vec4 FilterBalanced(ivec2 pixel, float sigmaPixels)
{
    int radius = min(int(ceil(sigmaPixels * 3.0)), kMaximumKernelRadius);
    float centerWeight = GaussianWeight(0.0, sigmaPixels);
    vec4 sum = LoadSource(pixel) * centerWeight;
    float weightSum = centerWeight;

    // Adjacent fixed Gaussian taps are combined into one hardware-linear
    // sample. The weighted sub-texel offset preserves the original 1D kernel.
    for (int firstOffset = 1;
         firstOffset <= kMaximumKernelRadius;
         firstOffset += 2)
    {
        if (firstOffset > radius)
        {
            continue;
        }
        int secondOffset = firstOffset + 1;
        float firstWeight = GaussianWeight(float(firstOffset), sigmaPixels);
        float secondWeight = secondOffset <= radius
            ? GaussianWeight(float(secondOffset), sigmaPixels)
            : 0.0;
        float pairWeight = firstWeight + secondWeight;
        if (pairWeight <= 0.0)
        {
            continue;
        }
        float pairedOffset = (
            float(firstOffset) * firstWeight
            + float(secondOffset) * secondWeight) / pairWeight;
        sum += (SampleSource(pixel, pairedOffset)
            + SampleSource(pixel, -pairedOffset)) * pairWeight;
        weightSum += 2.0 * pairWeight;
    }
    return weightSum > 0.0 ? sum / weightSum : LoadSource(pixel);
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

    vec2 uv = (vec2(pixel) + vec2(0.5))
        * RetinalConstants.inverseOutputSize;
    float sigmaPixels = ComputeAxisSigma(uv);
    vec4 result;
    if (sigmaPixels <= 1.0e-4)
    {
        result = LoadSource(pixel);
    }
    else if (RetinalConstants.highQuality >= 0.5)
    {
        result = FilterHigh(pixel, sigmaPixels);
    }
    else
    {
        result = FilterBalanced(pixel, sigmaPixels);
    }
    imageStore(OutputTexture, pixel, result);
}
