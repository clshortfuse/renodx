#version 450

#include "../../detroitbecomehuman/shared.h"

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

const ivec2 kBilinearOffsets[4] = ivec2[](
    ivec2(0),
    ivec2(1, 0),
    ivec2(0, 1),
    ivec2(1));

const ivec2 kCoverageSearchDirections[8] = ivec2[](
    ivec2(1, 0),
    ivec2(-1, 0),
    ivec2(0, 1),
    ivec2(0, -1),
    ivec2(1, 1),
    ivec2(-1, 1),
    ivec2(1, -1),
    ivec2(-1, -1));

const int kBalancedDirectionalSamples = 7;
const int kHighDirectionalSamples = 9;
const int kBalancedCoverageFeatherSteps = 3;
const int kHighCoverageFeatherSteps = 4;
const float kBalancedCameraVelocityScale = 0.24;
const float kHighCameraVelocityScale = 0.32;
const float kBalancedMaximumReach = 8.0;
const float kHighMaximumReach = 12.0;
const float kMinimumLocalVelocityRatio = 0.45;
const float kMaximumMotionMaskBlend = 0.65;
const float kMaximumCoverageFade = 0.75;
const float kMinimumParallelEdgeFade = 0.15;

struct POST_PROCESSING_MOTION_BLUR_CONSTANT_BUFFER
{
    vec4 _vfProjSetup;
    ivec2 _viWorkSizes;
    ivec2 _viWorkHalfSizes;
    vec2 _vfFbSizes;
    vec2 _vfFbHalfSizes;
    vec4 _vfMbParams;
    vec2 _vfNeoScale;
    ivec2 _viNeoScale;
    ivec2 _vi2xNeoScale;
    ivec2 _viTileSizes;
    float _fUpsamplingFactor;
    float _fInvUpsamplingFactor;
    float _fPadding0;
    float _fPadding1;
};

layout(set = 0, binding = 52, std140) uniform dyn_CONSTANT_BUFFER_BLOCK_0
{
    POST_PROCESSING_MOTION_BLUR_CONSTANT_BUFFER g_cbMb;
} _116;

layout(set = 0, binding = 0) uniform sampler2D colorMap;
layout(set = 0, binding = 1) uniform sampler2D blurMap;
layout(set = 0, binding = 2) uniform sampler2D velMaxTileMap;
layout(set = 0, binding = 3) uniform sampler2D alphaMap;
layout(set = 0, binding = 4) uniform sampler2D AvgLumMap;
layout(set = 0, binding = 5) uniform sampler2D velMap;
layout(set = 0, binding = 6) uniform sampler2D depthMap;
layout(set = 0, binding = 16, rgba16f) uniform writeonly image2D OutputTex;

vec4 ResolveBlurMap(ivec2 pixel)
{
    ivec2 previousPixel = pixel - ivec2(1);
    ivec2 basePixel = ivec2(
        vec2(previousPixel) / vec2(_116.g_cbMb._vi2xNeoScale));
    vec4 colors[4];
    for (int i = 0; i < 4; ++i)
    {
        colors[i] = texelFetch(
            blurMap,
            clamp(
                basePixel + kBilinearOffsets[i],
                ivec2(0),
                _116.g_cbMb._viWorkHalfSizes - ivec2(1)),
            0);
    }
    ivec2 remainder = previousPixel % _116.g_cbMb._vi2xNeoScale;
    vec4 horizontalWeight = vec4((0.5 + float(remainder.x)) * 0.5);
    return mix(
        mix(colors[0], colors[1], horizontalWeight),
        mix(colors[2], colors[3], horizontalWeight),
        vec4((0.5 + float(remainder.y))
            / (2.0 * _116.g_cbMb._vfNeoScale.y)));
}

struct NativeMotionBlurResult
{
    vec3 color;
    vec3 resolvedBlur;
    float tileVelocity;
};

NativeMotionBlurResult ResolveMotionBlurVanilla(ivec2 pixel)
{
    float exposure = max(
        _116.g_cbMb._vfMbParams.w,
        texelFetch(AvgLumMap, ivec2(0), 0).y);
    vec2 pixelF = vec2(pixel);
    ivec2 tilePixel = ivec2(
        (pixelF * _116.g_cbMb._vfMbParams.xx)
            / _116.g_cbMb._vfNeoScale);
    ivec2 maximumTilePixel = _116.g_cbMb._viTileSizes - ivec2(1);
    vec3 sharpColor = texelFetch(colorMap, pixel, 0).xyz * exposure;
    float tileVelocity = length(texelFetch(
        velMaxTileMap,
        clamp(tilePixel, ivec2(0), maximumTilePixel),
        0).xy);
    if (tileVelocity <= 2.0)
    {
        return NativeMotionBlurResult(sharpColor, sharpColor, tileVelocity);
    }

    float randomValue = fract(sin(dot(
        pixelF / _116.g_cbMb._vfFbSizes,
        vec2(12.98980045318603515625, 78.233001708984375)))
        * 43758.546875);
    int randomTile = (2 * int(4.0 * randomValue)) + 1;
    vec2 maximumVelocity = texelFetch(
        velMaxTileMap,
        clamp(
            tilePixel
                + (ivec2(randomTile / 3, randomTile % 3) - ivec2(1)),
            ivec2(0),
            maximumTilePixel),
        0).xy;
    vec4 resolvedBlur = ResolveBlurMap(pixel);
    vec3 outputColor = resolvedBlur.xyz;
    ivec2 halfPixel = ivec2(
        vec2(pixel - ivec2(1))
            / vec2(_116.g_cbMb._vi2xNeoScale));
    if (texelFetch(alphaMap, halfPixel, 0).x > 0.100000001490116119384765625)
    {
        vec2 velocityScale = _116.g_cbMb._vfFbHalfSizes
            * (0.25 * _116.g_cbMb._vfMbParams.y);
        vec2 localVelocity = clamp(
            texelFetch(velMap, pixel, 0).xy * velocityScale,
            vec2(-32.0),
            vec2(32.0));
        vec2 pixelCenter = vec2(pixel) + vec2(0.5);
        float centerDepth = -texelFetch(
            depthMap, ivec2(pixelCenter), 0).x;
        float centerVelocityLength = clamp(
            length(localVelocity), 0.5, 32.0);
        float sampleJitter = _116.g_cbMb._vfMbParams.z
            * (randomValue - 0.5);
        vec3 colorSum = sharpColor;
        float weightSum = 1.0;
        for (int i = 0; i < 8; ++i)
        {
            float sampleScale = mix(
                -1.0,
                1.0,
                (float(i) + sampleJitter)
                    * 0.14285700023174285888671875);
            float sampleDistance = abs(sampleScale * tileVelocity);
            ivec2 samplePixel = clamp(
                ivec2(pixelCenter
                    + mix(
                        maximumVelocity,
                        localVelocity,
                        bvec2((i % 2) == 0))
                        * sampleScale),
                ivec2(0),
                _116.g_cbMb._viWorkSizes - ivec2(1));
            float sampleDepth = -texelFetch(depthMap, samplePixel, 0).x;
            float sampleVelocityLength = clamp(
                length(texelFetch(velMap, samplePixel, 0).xy
                    * velocityScale),
                0.5,
                32.0);
            float sampleWeight =
                (clamp(
                    (centerDepth - sampleDepth)
                        * 999.99993896484375,
                    0.0,
                    1.0)
                    * clamp(
                        1.0 - sampleDistance / sampleVelocityLength,
                        0.0,
                        1.0))
                + (clamp(
                    (sampleDepth - centerDepth)
                        * 999.99993896484375,
                    0.0,
                    1.0)
                    * clamp(
                        1.0 - sampleDistance / centerVelocityLength,
                        0.0,
                        1.0))
                + ((2.0 * (1.0 - clamp(
                    (sampleDistance
                        - 0.89999997615814208984375
                            * sampleVelocityLength)
                        / (0.100000001490116119384765625
                            * sampleVelocityLength),
                    0.0,
                    1.0)))
                    * (1.0 - clamp(
                        (sampleDistance
                            - 0.89999997615814208984375
                                * centerVelocityLength)
                            / (0.100000001490116119384765625
                                * centerVelocityLength),
                        0.0,
                        1.0)));
            colorSum += texelFetch(colorMap, samplePixel, 0).xyz
                * exposure * sampleWeight;
            weightSum += sampleWeight;
        }
        float useMotionSamples = floor(
            1.89999997615814208984375
                - clamp(
                    weightSum * 0.14285700023174285888671875,
                    0.0,
                    1.0));
        outputColor = mix(
            resolvedBlur.xyz,
            colorSum / vec3(weightSum),
            vec3(useMotionSamples));
    }
    return NativeMotionBlurResult(
        outputColor, resolvedBlur.xyz, tileVelocity);
}

bool UseExperimentalMotionFeather(out bool highQuality)
{
    highQuality = true;
    return CUSTOM_EXPERIMENTAL_MOTION_BLUR;
}

float ResolveStableMotionMask(ivec2 halfPixel)
{
    // alphaMap is half resolution and contains small coverage discontinuities
    // inside animated characters. A separable 1-2-1 kernel prevents one mask
    // texel from being interpreted as an exterior silhouette.
    float coverageSum = 0.0;
    for (int y = -1; y <= 1; ++y)
    {
        float yWeight = y == 0 ? 2.0 : 1.0;
        for (int x = -1; x <= 1; ++x)
        {
            float xWeight = x == 0 ? 2.0 : 1.0;
            ivec2 samplePixel = clamp(
                halfPixel + ivec2(x, y),
                ivec2(0),
                _116.g_cbMb._viWorkHalfSizes - ivec2(1));
            coverageSum += smoothstep(
                0.05,
                0.2,
                texelFetch(alphaMap, samplePixel, 0).x)
                * xWeight * yWeight;
        }
    }
    return coverageSum * 0.0625;
}

struct MotionEdgeGatherResult
{
    vec3 color;
    float depthOppositeSupport;
};

MotionEdgeGatherResult ResolveMotionEdgeGather(
    ivec2 pixel,
    vec2 gatherVector,
    int sampleCount,
    bool centerIsForeground,
    float centerDepth,
    float exposure)
{
    vec2 pixelCenter = vec2(pixel) + vec2(0.5);
    vec3 colorSum = vec3(0.0);
    float weightSum = 0.0;
    float depthOppositeWeightSum = 0.0;
    for (int sampleIndex = 0;
         sampleIndex < kHighDirectionalSamples;
         ++sampleIndex)
    {
        if (sampleIndex >= sampleCount)
        {
            break;
        }
        float sampleScale = mix(
            -1.0,
            1.0,
            float(sampleIndex) / float(sampleCount - 1));
        float gaussianWeight = exp(
            -2.5 * sampleScale * sampleScale);
        ivec2 samplePixel = clamp(
            ivec2(pixelCenter + gatherVector * sampleScale),
            ivec2(0),
            _116.g_cbMb._viWorkSizes - ivec2(1));
        ivec2 sampleHalfPixel = clamp(
            ivec2(vec2(samplePixel - ivec2(1))
                / vec2(_116.g_cbMb._vi2xNeoScale)),
            ivec2(0),
            _116.g_cbMb._viWorkHalfSizes - ivec2(1));
        float sampleMaskCoverage = ResolveStableMotionMask(sampleHalfPixel);
        float sampleDepth = -texelFetch(depthMap, samplePixel, 0).x;
        float depthDiscontinuity = smoothstep(
            0.00025,
            0.002,
            abs(sampleDepth - centerDepth));
        float oppositeSideCoverage = centerIsForeground
            ? 1.0 - sampleMaskCoverage
            : sampleMaskCoverage;
        vec3 sharpSample = texelFetch(
            colorMap, samplePixel, 0).xyz * exposure;
        vec3 blurredBackground = ResolveBlurMap(samplePixel).xyz;
        colorSum += mix(
            blurredBackground,
            sharpSample,
            vec3(sampleMaskCoverage)) * gaussianWeight;
        weightSum += gaussianWeight;
        depthOppositeWeightSum += oppositeSideCoverage
            * depthDiscontinuity * gaussianWeight;
    }
    return MotionEdgeGatherResult(
        colorSum / vec3(max(weightSum, 0.0001)),
        clamp(depthOppositeWeightSum / max(weightSum, 0.0001), 0.0, 1.0));
}

struct InwardSilhouetteFadeResult
{
    vec3 exteriorColor;
    float amount;
};

InwardSilhouetteFadeResult ResolveInwardSilhouetteFade(
    ivec2 pixel,
    float centerDepth,
    vec2 motionVector,
    bool highQuality)
{
    int directionCount = highQuality ? 8 : 4;
    int maximumSearchSteps = highQuality
        ? kHighCoverageFeatherSteps
        : kBalancedCoverageFeatherSteps;
    float nearestExteriorDistance = float(maximumSearchSteps) + 1.0;
    vec2 nearestExteriorDirection = vec2(0.0);
    ivec2 nearestExteriorPixel = pixel;
    for (int directionIndex = 0;
         directionIndex < directionCount;
         ++directionIndex)
    {
        for (int step = 1; step <= kHighCoverageFeatherSteps; ++step)
        {
            if (step > maximumSearchSteps)
            {
                break;
            }
            ivec2 samplePixel = clamp(
                pixel + kCoverageSearchDirections[directionIndex] * step,
                ivec2(0),
                _116.g_cbMb._viWorkSizes - ivec2(1));
            float sampleDepth = -texelFetch(depthMap, samplePixel, 0).x;
            float depthEdgeEvidence = smoothstep(
                0.00025, 0.002, abs(sampleDepth - centerDepth));
            if (depthEdgeEvidence <= 0.5)
            {
                continue;
            }

            ivec2 sampleHalfPixel = clamp(
                ivec2(vec2(samplePixel - ivec2(1))
                    / vec2(_116.g_cbMb._vi2xNeoScale)),
                ivec2(0),
                _116.g_cbMb._viWorkHalfSizes - ivec2(1));
            float exteriorCoverage = 1.0 - smoothstep(
                0.2, 0.55, ResolveStableMotionMask(sampleHalfPixel));
            float exteriorEvidence = depthEdgeEvidence * exteriorCoverage;
            if (exteriorEvidence <= 0.5)
            {
                continue;
            }

            float directionScale = directionIndex >= 4
                ? 1.41421356237
                : 1.0;
            float candidateDistance =
                (float(step) - 0.5 * exteriorEvidence)
                * directionScale;
            if (candidateDistance < nearestExteriorDistance)
            {
                nearestExteriorDistance = candidateDistance;
                nearestExteriorDirection = vec2(
                    kCoverageSearchDirections[directionIndex]);
                nearestExteriorPixel = samplePixel;
            }
            break;
        }
    }
    if (nearestExteriorDistance > float(maximumSearchSteps))
    {
        return InwardSilhouetteFadeResult(vec3(0.0), 0.0);
    }

    float distanceFade = 1.0 - smoothstep(
        0.5,
        float(maximumSearchSteps) + 0.5,
        nearestExteriorDistance);
    float motionAlignment = abs(dot(
        normalize(motionVector),
        normalize(nearestExteriorDirection)));
    float orientationFade = mix(
        kMinimumParallelEdgeFade,
        1.0,
        smoothstep(0.15, 0.85, motionAlignment));
    ivec2 exteriorColorPixel = clamp(
        nearestExteriorPixel + ivec2(nearestExteriorDirection) * 2,
        ivec2(0),
        _116.g_cbMb._viWorkSizes - ivec2(1));
    return InwardSilhouetteFadeResult(
        ResolveBlurMap(exteriorColorPixel).xyz,
        distanceFade * orientationFade);
}

vec3 ResolveMotionMaskFeather(
    ivec2 pixel,
    NativeMotionBlurResult nativeResult,
    bool highQuality)
{
    ivec2 halfPixel = clamp(
        ivec2(vec2(pixel - ivec2(1))
            / vec2(_116.g_cbMb._vi2xNeoScale)),
        ivec2(0),
        _116.g_cbMb._viWorkHalfSizes - ivec2(1));
    float centerMaskCoverage = ResolveStableMotionMask(halfPixel);
    bool centerIsForeground = centerMaskCoverage >= 0.5;

    // The protected character can have almost no local velocity during a fast
    // camera pan. Borrow a bounded amount of the deterministic center-tile
    // velocity, without the native random neighboring-tile selection.
    vec2 pixelF = vec2(pixel);
    ivec2 tilePixel = clamp(
        ivec2((pixelF * _116.g_cbMb._vfMbParams.xx)
            / _116.g_cbMb._vfNeoScale),
        ivec2(0),
        _116.g_cbMb._viTileSizes - ivec2(1));
    vec2 tileVelocityVector = texelFetch(
        velMaxTileMap, tilePixel, 0).xy;
    vec2 velocityScale = _116.g_cbMb._vfFbHalfSizes
        * (0.25 * _116.g_cbMb._vfMbParams.y);
    vec2 localVelocity = clamp(
        texelFetch(velMap, pixel, 0).xy * velocityScale,
        vec2(-32.0),
        vec2(32.0));
    float localVelocityLength = length(localVelocity);
    float cameraVelocityScale = highQuality
        ? kHighCameraVelocityScale
        : kBalancedCameraVelocityScale;
    vec2 assistedVelocity = localVelocityLength
            < nativeResult.tileVelocity * kMinimumLocalVelocityRatio
        ? tileVelocityVector * cameraVelocityScale
        : localVelocity;
    float assistedVelocityLength = length(assistedVelocity);
    float maximumReach = highQuality
        ? kHighMaximumReach
        : kBalancedMaximumReach;
    assistedVelocity *= min(
        1.0,
        maximumReach / max(assistedVelocityLength, 0.0001));
    if (length(assistedVelocity) < 0.5)
    {
        return nativeResult.color;
    }

    // Convolve both sides of the character boundary only along camera motion.
    // A screen-space pass across the depth normal creates a distinct bright or
    // dark outline against high-contrast backgrounds, so the depth edge is
    // used only as continuous support for the directional blend.
    float exposure = max(
        _116.g_cbMb._vfMbParams.w,
        texelFetch(AvgLumMap, ivec2(0), 0).y);
    float centerDepth = -texelFetch(depthMap, pixel, 0).x;
    MotionEdgeGatherResult directionalGather = ResolveMotionEdgeGather(
        pixel,
        assistedVelocity,
        highQuality
            ? kHighDirectionalSamples
            : kBalancedDirectionalSamples,
        centerIsForeground,
        centerDepth,
        exposure);
    float motionStrength = smoothstep(
        2.0, 16.0, nativeResult.tileVelocity);
    float transitionControl = motionStrength;
    vec3 outputColor = mix(
        nativeResult.color,
        directionalGather.color,
        vec3(transitionControl
            * kMaximumMotionMaskBlend
            * smoothstep(
                0.01, 0.45, directionalGather.depthOppositeSupport)));
    if (centerIsForeground)
    {
        InwardSilhouetteFadeResult inwardSilhouetteFade =
            ResolveInwardSilhouetteFade(
            pixel,
            centerDepth,
            assistedVelocity,
            highQuality);
        outputColor = mix(
            outputColor,
            inwardSilhouetteFade.exteriorColor,
            vec3(transitionControl
                * kMaximumCoverageFade
                * inwardSilhouetteFade.amount));
    }
    return outputColor;
}

void main()
{
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    if (any(greaterThanEqual(pixel, _116.g_cbMb._viWorkSizes)))
    {
        return;
    }

    NativeMotionBlurResult nativeResult = ResolveMotionBlurVanilla(pixel);
    bool highQuality;
    vec3 outputColor = UseExperimentalMotionFeather(highQuality)
        && nativeResult.tileVelocity > 2.0
        ? ResolveMotionMaskFeather(pixel, nativeResult, highQuality)
        : nativeResult.color;
    imageStore(OutputTex, pixel, vec4(outputColor, 1.0));
}
