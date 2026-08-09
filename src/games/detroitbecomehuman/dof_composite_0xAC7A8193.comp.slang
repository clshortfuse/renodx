#version 450

#include "shared.h"
#include "render_debug_common.slang"

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

const ivec2 kBilinearOffsets[4] = ivec2[](
    ivec2(0),
    ivec2(1, 0),
    ivec2(0, 1),
    ivec2(1));

const int kTransitionBalancedKernelIndices[4] = int[](
    8, 12, 36, 40);

// Sixteen equal-angle directions keep High isotropic while the fixed maximum
// radial step bounds the widened Edge search independently of resolution.
const vec2 kFarEdgeUnitDirections[16] = vec2[](
    vec2(1.0, 0.0),
    vec2(0.92387953251, 0.38268343237),
    vec2(0.70710678119, 0.70710678119),
    vec2(0.38268343237, 0.92387953251),
    vec2(0.0, 1.0),
    vec2(-0.38268343237, 0.92387953251),
    vec2(-0.70710678119, 0.70710678119),
    vec2(-0.92387953251, 0.38268343237),
    vec2(-1.0, 0.0),
    vec2(-0.92387953251, -0.38268343237),
    vec2(-0.70710678119, -0.70710678119),
    vec2(-0.38268343237, -0.92387953251),
    vec2(0.0, -1.0),
    vec2(0.38268343237, -0.92387953251),
    vec2(0.70710678119, -0.70710678119),
    vec2(0.92387953251, -0.38268343237));

const int kFarEdgeMaximumRadialSteps = 16;
// Relative depth change per full-resolution pixel that is still considered a
// continuous curved surface rather than a new occluding layer.
const float kFarEdgeSurfaceDiscontinuity = 0.01;
// A material CoC jump can reveal a nearby blurred background even when its
// depth discontinuity is smaller than the geometric threshold.
const float kFarEdgeCocDiscontinuity = 0.5;
// TAA can spread a strong Far CoC transition over several pixels so neither
// individual depth nor CoC steps cross the hard-boundary thresholds. Confirm
// that ramp only from two neighboring positive samples. The second sample
// must own at least one full-resolution pixel of blur; this also saturates the
// existing Far activation and prevents numerical CoC drift from creating a
// foreground halo.
const float kFarEdgeRampStartCoc = 0.0625;
const float kFarEdgeRampConfirmCoc = 1.0;
// A confirmed ramp must gain enough Far radius per full-resolution pixel to
// represent a filtered silhouette rather than gradual depth across a curved
// focused surface.
const float kFarEdgeRampMinimumCocSlope = 0.25;
const float kFarEdgeRampDepthBacktrackTolerance = 0.001;
const float kFarEdgeRampCocBacktrackTolerance = 0.0625;

struct POST_PROCESS_DOF_CONSTANT_BUFFER
{
    vec4 _vfProjSetup;
    vec4 _vfDofParam;
    vec4 _vfLensParam;
    vec4 _vfFull_DOFSize;
    vec4 _vCoCScaleFactor;
    ivec2 _viPrepassTexSize;
    ivec2 _viDOFViewportSize;
    ivec2 _viViewportSize;
    vec2 _vScaleFactor;
    vec4 _avfKernel[169];
};

layout(set = 0, binding = 52, std140) uniform dyn_CONSTANT_BUFFER_BLOCK_0
{
    POST_PROCESS_DOF_CONSTANT_BUFFER _DOF;
} _125;

layout(set = 0, binding = 1) uniform sampler2D AvgLumMap;
layout(set = 0, binding = 0) uniform sampler2D dofPrepassCocMap;
layout(set = 0, binding = 2) uniform sampler2D accumBufferMap;
layout(set = 0, binding = 3) uniform sampler2D depthMap;
layout(set = 0, binding = 5) uniform sampler2D FarDofMap;
layout(set = 0, binding = 4) uniform sampler2D NearDofMap;
layout(set = 0, binding = 16, rgba16f) uniform writeonly image2D OutputTex;

ivec2 ClampDofPixel(ivec2 pixel)
{
    return ivec2(
        clamp(pixel.x, 0, _125._DOF._viDOFViewportSize.x - 1),
        clamp(pixel.y, 0, _125._DOF._viDOFViewportSize.y - 1));
}

ivec2 ClampFullPixel(ivec2 pixel)
{
    return ivec2(
        clamp(pixel.x, 0, _125._DOF._viViewportSize.x - 1),
        clamp(pixel.y, 0, _125._DOF._viViewportSize.y - 1));
}

float LinearizeDepth(float hardwareDepth)
{
    return (_125._DOF._vfProjSetup.y
        / (hardwareDepth + _125._DOF._vfProjSetup.x))
        * _125._DOF._vfProjSetup.w;
}

float ComputeFarCoc16(float viewDepth)
{
    if (CUSTOM_DOF_RUNTIME_MODE >= 0.5)
    {
        float focusDepth = _125._DOF._vfLensParam.y
            * CUSTOM_DOF_FOCUS_SCALE;
        float coc = clamp(((_125._DOF._vfLensParam.z
            * ((viewDepth - focusDepth)
                / (_125._DOF._vfLensParam.x + viewDepth)))
            - 1.2999999853491317480802536010742e-05)
            * _125._DOF._vfLensParam.w, 0.0, 1.0);
        return coc * CUSTOM_DOF_RADIUS_SCALE * 16.0;
    }
    return clamp(((_125._DOF._vfLensParam.z
        * ((viewDepth - _125._DOF._vfLensParam.y)
            / (_125._DOF._vfLensParam.x + viewDepth)))
        - 1.2999999853491317480802536010742e-05)
        * _125._DOF._vfLensParam.w, 0.0, 1.0) * 16.0;
}

float ComputeNearCoc16(float viewDepth)
{
    float focusDepth = _125._DOF._vfLensParam.y;
    float radiusScale = 1.0;
    if (CUSTOM_DOF_RUNTIME_MODE >= 0.5)
    {
        focusDepth *= CUSTOM_DOF_FOCUS_SCALE;
        radiusScale = CUSTOM_DOF_RADIUS_SCALE;
    }
    float coc = clamp(((_125._DOF._vfLensParam.z
        * ((focusDepth - viewDepth)
            / (_125._DOF._vfLensParam.x + viewDepth)))
        - 1.2999999853491317480802536010742e-05)
        * _125._DOF._vfLensParam.w, 0.0, 1.0);
    return coc * radiusScale * 16.0;
}

float FarCocAtDofPixel(ivec2 dofPixel)
{
    vec2 fullPosition = (vec2(ClampDofPixel(dofPixel)) + vec2(0.5))
        * _125._DOF._vScaleFactor;
    ivec2 fullPixel = ClampFullPixel(ivec2(fullPosition));
    return ComputeFarCoc16(LinearizeDepth(
        texelFetch(depthMap, fullPixel, 0).x));
}

float CocCompatibility(float centerCoc, float sampleCoc)
{
    float scale = max(max(centerCoc, sampleCoc), 1.0);
    return clamp(1.0 - abs(sampleCoc - centerCoc) / scale, 0.0, 1.0);
}

vec4 ResolveFarBalanced(vec2 dofPosition, float centerCoc, vec3 sharpColor)
{
    ivec2 basePixel = ivec2(dofPosition);
    float fx = fract(dofPosition.x);
    float fy = fract(dofPosition.y);
    float weights[4] = float[](
        (1.0 - fy) * (1.0 - fx),
        (1.0 - fy) * fx,
        fy * (1.0 - fx),
        fy * fx);
    vec3 colorSum = vec3(0.0);
    float validWeight = 0.0;
    float alphaSum = 0.0;
    for (int i = 0; i < 4; ++i)
    {
        ivec2 samplePixel = ClampDofPixel(basePixel + kBilinearOffsets[i]);
        vec4 sampleValue = texelFetch(FarDofMap, samplePixel, 0);
        float depthWeight = CocCompatibility(
            centerCoc, FarCocAtDofPixel(samplePixel));
        float spatialDepthWeight = weights[i] * depthWeight;
        float valid = float(sampleValue.w > 0.0);
        float colorWeight = spatialDepthWeight * valid;
        colorSum += sampleValue.xyz * colorWeight;
        validWeight += colorWeight;
        alphaSum += sampleValue.w * spatialDepthWeight;
    }
    return validWeight > 0.0
        ? vec4(colorSum / vec3(validWeight), clamp(alphaSum, 0.0, 1.0))
        : vec4(sharpColor, 0.0);
}

vec4 ResolveFarHigh(vec2 dofPosition, float centerCoc, vec3 sharpColor)
{
    ivec2 centerPixel = ivec2(floor(dofPosition));
    vec3 colorSum = vec3(0.0);
    float validWeight = 0.0;
    float alphaSum = 0.0;
    float spatialWeightSum = 0.0;
    for (int y = -1; y <= 1; ++y)
    {
        for (int x = -1; x <= 1; ++x)
        {
            ivec2 samplePixel = ClampDofPixel(
                centerPixel + ivec2(x, y));
            vec2 delta = (vec2(samplePixel) + vec2(0.5)) - dofPosition;
            float spatialWeight = exp(-0.5 * dot(delta, delta));
            float depthWeight = CocCompatibility(
                centerCoc, FarCocAtDofPixel(samplePixel));
            vec4 sampleValue = texelFetch(FarDofMap, samplePixel, 0);
            float combinedWeight = spatialWeight * depthWeight;
            float valid = float(sampleValue.w > 0.0);
            float colorWeight = combinedWeight * valid;
            colorSum += sampleValue.xyz * colorWeight;
            validWeight += colorWeight;
            alphaSum += sampleValue.w * combinedWeight;
            spatialWeightSum += spatialWeight;
        }
    }
    return validWeight > 0.0 && spatialWeightSum > 0.0
        ? vec4(
            colorSum / vec3(validWeight),
            clamp(alphaSum / spatialWeightSum, 0.0, 1.0))
        : vec4(sharpColor, 0.0);
}

vec2 ResolveGatherFillCoverage(vec2 dofPosition)
{
    ivec2 basePixel = ivec2(dofPosition);
    float fx = fract(dofPosition.x);
    float fy = fract(dofPosition.y);
    float weights[4] = float[](
        (1.0 - fy) * (1.0 - fx),
        (1.0 - fy) * fx,
        fy * (1.0 - fx),
        fy * fx);
    vec2 coverage = vec2(0.0);
    for (int i = 0; i < 4; ++i)
    {
        ivec2 samplePixel = ClampDofPixel(
            basePixel + kBilinearOffsets[i]);
        coverage.x += texelFetch(NearDofMap, samplePixel, 0).w
            * weights[i];
        coverage.y += texelFetch(FarDofMap, samplePixel, 0).w
            * weights[i];
    }
    return clamp(coverage, vec2(0.0), vec2(1.0));
}

vec3 ResolveFullResolutionFar(
    vec2 pixelF,
    float centerCoc,
    float exposure,
    bool highQuality,
    float apertureRadiusScale,
    bool fillOccludedSamples,
    vec3 occludedFallbackColor,
    out float farSupport,
    vec3 fallbackColor)
{
    // Optimization idea for a future Balanced path: fixed Gaussian taps can
    // be paired with hardware linear sampling to reduce texture reads. Do not
    // apply that reduction to High or directly to DOF color/alpha layers:
    // Detroit's authored aperture shape and the per-sample depth/CoC rejection
    // require independent weights to avoid silhouette halos and background
    // leakage across depth discontinuities.
    int sampleCount = highQuality ? 49 : 4;
    float centerCocHalfResolution = centerCoc * 0.5;
    float centerWeight = highQuality
        ? 0.0
        : max(centerCocHalfResolution, 0.0625);
    vec3 colorSum = fallbackColor * centerWeight;
    float weightSum = centerWeight;
    float supportedApertureWeight = 0.0;
    float apertureWeight = 0.0;
    for (int i = 0; i < sampleCount; ++i)
    {
        int kernelIndex = highQuality
            ? i
            : kTransitionBalancedKernelIndices[i];
        vec4 kernel = _125._DOF._avfKernel[kernelIndex];
        vec2 samplePosition = pixelF
            + kernel.xy * centerCoc * apertureRadiusScale;
        ivec2 basePixel = highQuality
            ? ivec2(floor(samplePosition))
            : ivec2(floor(samplePosition + vec2(0.5)));
        vec2 fraction = fract(samplePosition);
        float interpolationWeights[4] = float[](
            (1.0 - fraction.y) * (1.0 - fraction.x),
            (1.0 - fraction.y) * fraction.x,
            fraction.y * (1.0 - fraction.x),
            fraction.y * fraction.x);
        int interpolationCount = highQuality ? 4 : 1;
        for (int j = 0; j < interpolationCount; ++j)
        {
            ivec2 samplePixel = ClampFullPixel(
                basePixel + (highQuality ? kBilinearOffsets[j] : ivec2(0)));
            float interpolationWeight = highQuality
                ? interpolationWeights[j]
                : 1.0;
            float sampleCoc = ComputeFarCoc16(LinearizeDepth(
                texelFetch(depthMap, samplePixel, 0).x));
            float sampleCocHalfResolution = sampleCoc * 0.5;
            bool hasFarSample = sampleCoc > 0.0;
            apertureWeight += interpolationWeight;
            supportedApertureWeight += interpolationWeight
                * float(hasFarSample);
            if (!hasFarSample && !fillOccludedSamples)
            {
                continue;
            }
            float coverage = hasFarSample
                ? 1.0 - clamp(
                    kernel.z * centerCocHalfResolution
                        - sampleCocHalfResolution,
                    0.0,
                    1.0)
                : 1.0;
            float radiusWeight = hasFarSample
                ? max(sampleCocHalfResolution, 0.0625)
                : max(centerCocHalfResolution, 0.0625);
            float compatibility = hasFarSample
                ? CocCompatibility(centerCoc, sampleCoc)
                : 1.0;
            float weight = interpolationWeight
                * coverage
                * radiusWeight
                * compatibility;
            vec3 sampleColor = hasFarSample
                ? texelFetch(accumBufferMap, samplePixel, 0).xyz
                    * vec3(exposure)
                : occludedFallbackColor;
            colorSum += sampleColor * vec3(weight);
            weightSum += weight;
        }
    }
    farSupport = apertureWeight > 0.0
        ? supportedApertureWeight / apertureWeight
        : 1.0;
    return weightSum > 0.0
        ? colorSum / vec3(weightSum)
        : fallbackColor;
}

bool CoarseFarMayReach(ivec2 pixel, float searchRadius)
{
    ivec2 coarseSize = textureSize(dofPrepassCocMap, 0);
    vec2 coarseScale = max(
        _125._DOF._vCoCScaleFactor.zw,
        vec2(1.0));
    ivec2 minimumTile = clamp(
        ivec2(floor(
            (vec2(pixel) - vec2(searchRadius)) / coarseScale)),
        ivec2(0),
        coarseSize - ivec2(1));
    ivec2 maximumTile = clamp(
        ivec2(floor(
            (vec2(pixel) + vec2(searchRadius)) / coarseScale)),
        ivec2(0),
        coarseSize - ivec2(1));
    for (int y = minimumTile.y; y <= maximumTile.y; ++y)
    {
        for (int x = minimumTile.x; x <= maximumTile.x; ++x)
        {
            // Coarse far CoC is deliberately boolean here. It may reject a
            // footprint that contains no far background, but never controls
            // final radius, color, coverage or layer visibility.
            if (texelFetch(dofPrepassCocMap, ivec2(x, y), 0).y > 0.0)
            {
                return true;
            }
        }
    }
    return false;
}

int ClassifyFarEdgeSector(ivec2 offset)
{
    ivec2 magnitude = abs(offset);
    const float kTanHalfSector = 0.41421356237;
    if (float(magnitude.y) <= float(magnitude.x) * kTanHalfSector)
    {
        return offset.x > 0 ? 0 : 4;
    }
    if (float(magnitude.x) <= float(magnitude.y) * kTanHalfSector)
    {
        return offset.y > 0 ? 2 : 6;
    }
    if (offset.x > 0)
    {
        return offset.y > 0 ? 1 : 7;
    }
    return offset.y > 0 ? 3 : 5;
}

vec3 ResolveFarEdgeFallbackColor(
    ivec2 sourcePixel,
    float sourceCoc,
    float exposure,
    bool highQuality)
{
    vec3 colorSum = vec3(0.0);
    float weightSum = 0.0;
    for (int offsetY = -1; offsetY <= 1; ++offsetY)
    {
        for (int offsetX = -1; offsetX <= 1; ++offsetX)
        {
            ivec2 offset = ivec2(offsetX, offsetY);
            if (!highQuality && abs(offsetX) + abs(offsetY) > 1)
            {
                continue;
            }
            ivec2 samplePixel = sourcePixel + offset;
            if (any(lessThan(samplePixel, ivec2(0)))
                || any(greaterThanEqual(
                    samplePixel, _125._DOF._viViewportSize)))
            {
                continue;
            }
            float sampleDepth = LinearizeDepth(
                texelFetch(depthMap, samplePixel, 0).x);
            float sampleFarCoc = ComputeFarCoc16(sampleDepth);
            float cocWeight = CocCompatibility(sourceCoc, sampleFarCoc)
                * smoothstep(0.25, 1.5, sampleFarCoc);
            float spatialWeight = highQuality
                ? exp(-0.5 * dot(vec2(offset), vec2(offset)))
                : (all(equal(offset, ivec2(0))) ? 1.0 : 0.5);
            float weight = cocWeight * spatialWeight;
            colorSum += texelFetch(
                accumBufferMap, samplePixel, 0).xyz
                * vec3(exposure * weight);
            weightSum += weight;
        }
    }
    return weightSum > 0.0
        ? colorSum / vec3(weightSum)
        : texelFetch(accumBufferMap, sourcePixel, 0).xyz * vec3(exposure);
}

float ComputeFarEdgeCandidateCoverage(
    float sampleDistance,
    float sampleFarCoc,
    float edgeWidthPixels)
{
    // The ordered ray already proved a real farther discontinuity. Keep depth
    // as a validity test rather than attenuating the artistic coverage again.
    float farActivation = clamp(sampleFarCoc, 0.0, 1.0);

    // Edge Bokeh Width is an exact full-resolution reach. Far CoC proves that
    // the sampled surface owns background bokeh and selects its authored color,
    // but must not silently shrink a user-requested pixel width.
    float localEdgeWidth = edgeWidthPixels;
    // Convert center-to-center distance into pixel-footprint distance: width N
    // reaches radial step N, while step N+1 remains zero. Fade over the whole
    // requested width so the result behaves like a distance field instead of
    // a flat morphological band followed by a short outer ramp.
    float effectiveDistance = max(sampleDistance - 0.5, 0.0);
    float normalizedDistance = clamp(
        effectiveDistance / max(localEdgeWidth, 1.0), 0.0, 1.0);
    float radialCoverage = 1.0 - smoothstep(
        0.0, 1.0, normalizedDistance);
    return farActivation * radialCoverage;
}

vec4 ResolveFarEdgeIntrusion(
    ivec2 pixel,
    float centerDepth,
    float centerFarCoc,
    float edgeWidthPixels,
    float exposure,
    bool highQuality)
{
    // The user value is the exact full-resolution maximum. Far CoC still gates
    // candidate validity and authored color, but does not reduce this reach.
    float maximumSearchRadius = edgeWidthPixels;
    if (maximumSearchRadius < 1.0)
    {
        return vec4(0.0);
    }

    // Native coarse CoC was classified with the authored focus distance.
    // It is conservative only while the enhanced focus scale is neutral;
    // otherwise the adjusted full-resolution CoC must remain authoritative.
    bool nativeFocusClassification =
        abs(CUSTOM_DOF_FOCUS_SCALE - 1.0) <= 1.0e-5;
    if (nativeFocusClassification
        && !CoarseFarMayReach(pixel, maximumSearchRadius))
    {
        return vec4(0.0);
    }

    float bestCoverage[8];
    ivec2 bestPixel[8];
    float bestFarCoc[8];
    float bestDistance[8];
    for (int sector = 0; sector < 8; ++sector)
    {
        bestCoverage[sector] = 0.0;
        bestPixel[sector] = pixel;
        bestFarCoc[sector] = 0.0;
        bestDistance[sector] = 1.0e20;
    }

    // Walk every integer distance so the first real surface discontinuity along
    // each ray owns the result. The first step of the eight Balanced directions
    // already covers every adjacent pixel; ordered rays avoid tunnelling through
    // a nearer or in-focus layer. Balanced evaluates at most 128 depth probes
    // and High at most 256, independently of screen resolution.
    int maximumRadialStep = min(
        int(ceil(maximumSearchRadius)),
        kFarEdgeMaximumRadialSteps);
    for (int directionIndex = 0; directionIndex < 16; ++directionIndex)
    {
        if (!highQuality && (directionIndex & 1) != 0)
        {
            continue;
        }
        ivec2 previousOffset = ivec2(0);
        float previousDepth = centerDepth;
        float previousFarCoc = centerFarCoc;
        bool previousRampValid = false;
        float previousRampDistance = 0.0;
        float previousRampCoc = 0.0;
        for (int radialStep = 1;
             radialStep <= kFarEdgeMaximumRadialSteps;
             ++radialStep)
        {
            if (radialStep > maximumRadialStep)
            {
                break;
            }
            ivec2 offset = ivec2(round(
                kFarEdgeUnitDirections[directionIndex]
                    * float(radialStep)));
            if (all(equal(offset, ivec2(0)))
                || all(equal(offset, previousOffset)))
            {
                continue;
            }
            float localStepDistance = max(
                length(vec2(offset - previousOffset)), 1.0);
            previousOffset = offset;
            float sampleDistance = length(vec2(offset));
            ivec2 samplePixel = pixel + offset;
            if (any(lessThan(samplePixel, ivec2(0)))
                || any(greaterThanEqual(
                    samplePixel, _125._DOF._viViewportSize)))
            {
                break;
            }
            float sampleDepth = LinearizeDepth(
                texelFetch(depthMap, samplePixel, 0).x);
            float localDepthGap = (sampleDepth - previousDepth)
                / (max(max(abs(sampleDepth), abs(previousDepth)), 1.0e-4)
                    * localStepDistance);
            float cumulativeCenterDepthGap = (sampleDepth - centerDepth)
                / max(max(abs(sampleDepth), abs(centerDepth)), 1.0e-4);
            if (localDepthGap < -kFarEdgeSurfaceDiscontinuity)
            {
                // A nearer surface occludes every farther point on this ray.
                break;
            }
            if (cumulativeCenterDepthGap <= 0.0025)
            {
                // Still inside the center surface's depth tolerance.
                previousRampValid = false;
                previousDepth = sampleDepth;
                previousFarCoc = ComputeFarCoc16(sampleDepth);
                continue;
            }

            float sampleFarCoc = ComputeFarCoc16(sampleDepth);
            float farCocJump = sampleFarCoc - previousFarCoc;
            bool depthBoundary =
                localDepthGap > kFarEdgeSurfaceDiscontinuity;
            bool cocBoundary = localDepthGap > 0.0
                && farCocJump >= kFarEdgeCocDiscontinuity;
            if (depthBoundary || cocBoundary)
            {
                // A true depth or CoC discontinuity owns the ray. Positive Far
                // CoC contributes background bokeh; an in-focus layer blocks
                // everything behind it.
                if (sampleFarCoc <= 0.0)
                {
                    break;
                }
                float candidateCoverage = ComputeFarEdgeCandidateCoverage(
                    sampleDistance,
                    sampleFarCoc,
                    edgeWidthPixels);
                int sector = ClassifyFarEdgeSector(offset);
                bool closerCandidate = sampleDistance + 1.0e-4
                    < bestDistance[sector];
                bool strongerAtSameDistance = abs(
                    sampleDistance - bestDistance[sector]) <= 1.0e-4
                    && candidateCoverage > bestCoverage[sector];
                if (candidateCoverage > 0.0
                    && (closerCandidate || strongerAtSameDistance))
                {
                    bestCoverage[sector] = candidateCoverage;
                    bestPixel[sector] = samplePixel;
                    bestFarCoc[sector] = sampleFarCoc;
                    bestDistance[sector] = sampleDistance;
                }
                break;
            }

            // A temporally antialiased silhouette can form a monotonic Far CoC
            // ramp without any single material jump. Require two neighboring
            // positive samples and a one-pixel confirmed Far radius. The first
            // sample supplies only the geometric boundary distance; color and
            // CoC always come from the second, confirmed background sample.
            bool rampPositive = sampleFarCoc >= kFarEdgeRampStartCoc;
            bool rampNotNearer =
                localDepthGap >= -kFarEdgeRampDepthBacktrackTolerance;
            bool rampCocMonotonic = sampleFarCoc
                + kFarEdgeRampCocBacktrackTolerance >= previousRampCoc;
            bool rampCocSteep = sampleFarCoc - centerFarCoc
                >= kFarEdgeRampMinimumCocSlope * sampleDistance;
            bool confirmedRamp = previousRampValid
                && rampPositive
                && rampNotNearer
                && rampCocMonotonic
                && rampCocSteep
                && sampleFarCoc >= kFarEdgeRampConfirmCoc;
            if (confirmedRamp)
            {
                float candidateDistance = previousRampDistance;
                float candidateCoverage = ComputeFarEdgeCandidateCoverage(
                    candidateDistance,
                    sampleFarCoc,
                    edgeWidthPixels);
                int sector = ClassifyFarEdgeSector(offset);
                bool closerCandidate = candidateDistance + 1.0e-4
                    < bestDistance[sector];
                bool strongerAtSameDistance = abs(
                    candidateDistance - bestDistance[sector]) <= 1.0e-4
                    && candidateCoverage > bestCoverage[sector];
                if (candidateCoverage > 0.0
                    && (closerCandidate || strongerAtSameDistance))
                {
                    bestCoverage[sector] = candidateCoverage;
                    bestPixel[sector] = samplePixel;
                    bestFarCoc[sector] = sampleFarCoc;
                    bestDistance[sector] = candidateDistance;
                }
                break;
            }

            // Keep only the immediately preceding eligible sample. Sliding the
            // seed prevents a long, shallow CoC drift across a curved focused
            // surface from moving the inferred silhouette deep into it.
            previousRampValid = rampPositive && rampNotNearer;
            previousRampDistance = sampleDistance;
            previousRampCoc = sampleFarCoc;

            // Smooth foreground curvature and gradual CoC drift remain the same
            // surface; neither may create a false one-pixel silhouette gap.
            previousDepth = sampleDepth;
            previousFarCoc = sampleFarCoc;
        }
    }

    vec3 farColorSum = vec3(0.0);
    float farColorWeight = 0.0;
    float nearestCoverage = 0.0;
    for (int sector = 0; sector < 8; ++sector)
    {
        // Compare the selected background radius with this exact center. This
        // keeps equally defocused background pixels unchanged while allowing a
        // filtered silhouette pixel with nonzero CoC to receive farther bokeh.
        float relativeCocSupport = clamp(
            (bestFarCoc[sector] - centerFarCoc)
                / max(bestFarCoc[sector], 1.0),
            0.0,
            1.0);
        float sectorCoverage = bestCoverage[sector] * relativeCocSupport;
        if (sectorCoverage <= 0.0)
        {
            continue;
        }

        vec3 backgroundSharpColor = texelFetch(
            accumBufferMap, bestPixel[sector], 0).xyz * vec3(exposure);
        vec2 bestDofPosition = vec2(bestPixel[sector])
            / _125._DOF._vScaleFactor;
        vec4 authoredFar = highQuality
            ? ResolveFarHigh(
                bestDofPosition,
                bestFarCoc[sector],
                backgroundSharpColor)
            : ResolveFarBalanced(
                bestDofPosition,
                bestFarCoc[sector],
                backgroundSharpColor);
        vec3 directionColor = authoredFar.xyz;
        if (authoredFar.w <= 0.0)
        {
            // Missing half-resolution color must never disable geometric
            // coverage. Use one bounded full-resolution fallback per sector;
            // never repeat the complete 49x4 aperture resolve here.
            directionColor = ResolveFarEdgeFallbackColor(
                bestPixel[sector],
                bestFarCoc[sector],
                exposure,
                highQuality);
        }
        farColorSum += directionColor * vec3(sectorCoverage);
        farColorWeight += sectorCoverage;
        nearestCoverage = max(nearestCoverage, sectorCoverage);
    }

    if (farColorWeight <= 0.0)
    {
        return vec4(0.0);
    }

    // Width controls geometry only. Keep the authored default coverage fixed
    // so a small nonzero pixel width does not become visually inert.
    const float edgeOpacity = 0.60;
    vec3 edgeColor = farColorSum / vec3(farColorWeight);

    // One depth-validated sector is sufficient to establish the signed
    // distance to visible background. Sector count must not make curved or
    // nearly axis-aligned silhouettes weaker than straight edges.
    float directionalSupport = clamp(nearestCoverage, 0.0, 1.0);
    return vec4(
        edgeColor,
        directionalSupport * edgeOpacity);
}

vec3 CompositeVanilla(ivec2 pixel, vec2 pixelF, vec4 coarse, vec3 sharpColor)
{
    vec3 farResult = sharpColor;
    if (coarse.y > 0.0)
    {
        float viewDepth = LinearizeDepth(
            texelFetch(depthMap, pixel, 0).x);
        float farCoc = ComputeFarCoc16(viewDepth);
        if (farCoc > 0.0)
        {
            vec2 dofPosition = pixelF / _125._DOF._vScaleFactor;
            ivec2 basePixel = ivec2(dofPosition);
            vec4 samples[4];
            for (int i = 0; i < 4; ++i)
            {
                samples[i] = texelFetch(
                    FarDofMap,
                    ClampDofPixel(basePixel + kBilinearOffsets[i]),
                    0);
            }
            float fx = fract(dofPosition.x);
            float fy = fract(dofPosition.y);
            float weights[4] = float[](
                (1.0 - fy) * (1.0 - fx),
                (1.0 - fy) * fx,
                fy * (1.0 - fx),
                fy * fx);
            vec4 sum = vec4(0.0);
            float validWeight = 0.0;
            for (int i = 0; i < 4; ++i)
            {
                float weight = weights[i] * float(samples[i].w > 0.0);
                sum += samples[i] * weight;
                validWeight += weight;
            }
            vec4 resolved;
            if (validWeight > 0.0)
            {
                resolved = vec4(
                    sum.xyz / vec3(validWeight),
                    sum.w);
            }
            else
            {
                resolved = vec4(sharpColor, sum.w);
            }
            float blend = farCoc > 1.0
                ? resolved.w
                : clamp(farCoc, 0.0, 1.0);
            farResult = mix(sharpColor, resolved.xyz, vec3(blend));
        }
    }

    if (coarse.x <= 0.0)
    {
        return farResult;
    }

    vec2 dofPosition = pixelF / _125._DOF._vScaleFactor;
    ivec2 basePixel = ivec2(dofPosition);
    vec4 samples[4];
    for (int i = 0; i < 4; ++i)
    {
        samples[i] = texelFetch(
            NearDofMap,
            ClampDofPixel(basePixel + kBilinearOffsets[i]),
            0);
    }
    float fx = fract(dofPosition.x);
    float fy = fract(dofPosition.y);
    float weights[4] = float[](
        (1.0 - fy) * (1.0 - fx),
        (1.0 - fy) * fx,
        fy * (1.0 - fx),
        fy * fx);
    vec4 sum = vec4(0.0);
    float validWeight = 0.0;
    for (int i = 0; i < 4; ++i)
    {
        float weight = weights[i] * float(samples[i].w > 0.0);
        sum += samples[i] * weight;
        validWeight += weight;
    }
    vec4 resolved;
    if (validWeight > 0.0)
    {
        resolved = vec4(sum.xyz / vec3(validWeight), sum.w);
    }
    else
    {
        resolved = vec4(farResult, sum.w);
    }
    return mix(farResult, resolved.xyz, vec3(resolved.w));
}

vec3 CompositeEnhanced(
    ivec2 pixel,
    vec2 pixelF,
    vec3 sharpColor,
    float exposure,
    out float finalEdgeCoverage)
{
    finalEdgeCoverage = 0.0;
    vec2 dofPosition = pixelF / _125._DOF._vScaleFactor;
    float centerDepth = LinearizeDepth(
        texelFetch(depthMap, pixel, 0).x);
    float farCoc = ComputeFarCoc16(centerDepth);
    uint runtimeMode = uint(CUSTOM_DOF_RUNTIME_MODE + 0.5);
    bool cinematic = runtimeMode == 3u
        || runtimeMode == 4u
        || runtimeMode == 5u
        || runtimeMode == 6u;
    bool highQuality = runtimeMode == 2u
        || runtimeMode == 4u
        || runtimeMode == 6u;
    float edgeWidthPixels = clamp(
        CUSTOM_DOF_EDGE_WIDTH_PIXELS, 0.0, 16.0);
    vec3 farResult = sharpColor;
    if (farCoc > 0.0)
    {
        vec4 farLayer = cinematic
            ? (highQuality
                ? ResolveFarHigh(dofPosition, farCoc, sharpColor)
                : ResolveFarBalanced(dofPosition, farCoc, sharpColor))
            : vec4(sharpColor, 0.0);
        float farSupport;
        vec3 transitionBlur = ResolveFullResolutionFar(
            pixelF,
            farCoc,
            exposure,
            highQuality,
            1.0,
            cinematic,
            farLayer.xyz,
            farSupport,
            sharpColor);
        vec3 transitionResult = mix(
            sharpColor,
            transitionBlur,
            vec3(clamp(
                clamp(farCoc, 0.0, 1.0)
                    * CUSTOM_DOF_FAR_STRENGTH,
                0.0,
                1.0)));
        farResult = transitionResult;
        if (cinematic)
        {
            // Native far/fill supplies authored color and hidden background,
            // but its R8 alpha never becomes a visibility mask.
            vec3 nativeFarResult = mix(
                sharpColor,
                farLayer.xyz,
                vec3(clamp(
                    clamp(farCoc, 0.0, 1.0)
                        * CUSTOM_DOF_FAR_STRENGTH,
                    0.0,
                    1.0)));
            farResult = mix(
                transitionResult,
                nativeFarResult,
                vec3(
                    smoothstep(5.0, 8.0, farCoc)
                    * smoothstep(0.75, 0.98, farSupport)));
        }
    }

    // Apply Edge Bokeh after the depth-aware far resolve. Candidate-relative
    // Far CoC inside the ordered search protects already defocused background
    // while allowing filtered silhouette pixels to receive farther bokeh.
    if (cinematic && edgeWidthPixels > 0.0)
    {
        vec4 edgeIntrusion = ResolveFarEdgeIntrusion(
            pixel,
            centerDepth,
            farCoc,
            edgeWidthPixels,
            exposure,
            highQuality);
        float farCoverage = clamp(
            edgeIntrusion.w * CUSTOM_DOF_FAR_STRENGTH,
            0.0,
            1.0);
        finalEdgeCoverage = farCoverage;
        farResult = mix(
            farResult,
            edgeIntrusion.xyz,
            vec3(farCoverage));
    }

    // Foreground bokeh is an authored cut-scene layer. Composite it with the
    // same color, R8 alpha, bilinear weights and ordering as Vanilla, without
    // applying Enhanced focus/radius/strength controls or a depth rejection.
    vec4 coarse = texelFetch(
        dofPrepassCocMap,
        ivec2(pixelF / _125._DOF._vCoCScaleFactor.zw),
        0);
    if (coarse.x <= 0.0)
    {
        return farResult;
    }

    ivec2 basePixel = ivec2(dofPosition);
    vec4 nearSamples[4];
    for (int i = 0; i < 4; ++i)
    {
        nearSamples[i] = texelFetch(
            NearDofMap,
            ClampDofPixel(basePixel + kBilinearOffsets[i]),
            0);
    }
    float fx = fract(dofPosition.x);
    float fy = fract(dofPosition.y);
    float nearWeights[4] = float[](
        (1.0 - fy) * (1.0 - fx),
        (1.0 - fy) * fx,
        fy * (1.0 - fx),
        fy * fx);
    vec4 nearSum = vec4(0.0);
    float nearValidWeight = 0.0;
    for (int i = 0; i < 4; ++i)
    {
        float weight = nearWeights[i] * float(nearSamples[i].w > 0.0);
        nearSum += nearSamples[i] * weight;
        nearValidWeight += weight;
    }
    vec4 resolvedNear;
    if (nearValidWeight > 0.0)
    {
        resolvedNear = vec4(
            nearSum.xyz / vec3(nearValidWeight),
            nearSum.w);
    }
    else
    {
        resolvedNear = vec4(farResult, nearSum.w);
    }
    return mix(farResult, resolvedNear.xyz, vec3(resolvedNear.w));
}

void main()
{
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    vec2 pixelF = vec2(pixel);
    float exposure = max(
        _125._DOF._vfDofParam.z,
        texelFetch(AvgLumMap, ivec2(0), 0).y);
    vec3 sharpColor = texelFetch(accumBufferMap, pixel, 0).xyz
        * vec3(exposure);

    uint debugSource = RenderDebugActive()
        ? RenderDebugSourceAtPixel(pixel, _125._DOF._viViewportSize)
        : RENDER_DEBUG_SOURCE_NONE;

    float finalEdgeCoverage = 0.0;
    vec3 outputColor;
    if (RenderDebugPreserveAtPass(debugSource, RENDER_DEBUG_PASS_DOF))
    {
        // A temporal panel already contains its diagnostic color. Bypass DOF
        // for that panel so it reaches the final scene composite unchanged.
        outputColor = sharpColor;
    }
    else if (CUSTOM_DOF_RUNTIME_MODE < 0.5)
    {
        vec4 coarse = texelFetch(
            dofPrepassCocMap,
            ivec2(pixelF / _125._DOF._vCoCScaleFactor.zw),
            0);
        outputColor = CompositeVanilla(pixel, pixelF, coarse, sharpColor);
    }
    else
    {
        outputColor = CompositeEnhanced(
            pixel, pixelF, sharpColor, exposure, finalEdgeCoverage);
    }

    if (RenderDebugGenerateAtPass(debugSource, RENDER_DEBUG_PASS_DOF))
    {
        vec4 debugValue = vec4(0.0);
        if (debugSource == RENDER_DEBUG_SOURCE_DOF_COARSE_COC)
        {
            debugValue = texelFetch(
                dofPrepassCocMap,
                ivec2(pixelF / _125._DOF._vCoCScaleFactor.zw),
                0);
        }
        else if (debugSource == RENDER_DEBUG_SOURCE_DOF_FULL_COC)
        {
            float viewDepth = LinearizeDepth(
                texelFetch(depthMap, pixel, 0).x);
            debugValue.x = ComputeFarCoc16(viewDepth)
                - ComputeNearCoc16(viewDepth);
        }
        else if (debugSource == RENDER_DEBUG_SOURCE_DOF_EDGE_CONTROL)
        {
            // Show the value decoded by this exact composite shader. This
            // distinguishes a stale UI/payload route from weak edge coverage.
            debugValue.x = clamp(
                CUSTOM_DOF_EDGE_WIDTH_PIXELS, 0.0, 16.0);
        }
        else if (debugSource == RENDER_DEBUG_SOURCE_DOF_EDGE_COVERAGE)
        {
            // This is the final post-resolve mix weight after focused-center
            // protection and Background Bokeh strength, not native R8 alpha.
            debugValue.x = finalEdgeCoverage;
        }
        else
        {
            vec2 coverage = ResolveGatherFillCoverage(
                pixelF / _125._DOF._vScaleFactor);
            if (debugSource == RENDER_DEBUG_SOURCE_DOF_NEAR)
            {
                debugValue.w = coverage.x;
            }
            else if (debugSource == RENDER_DEBUG_SOURCE_DOF_FAR)
            {
                debugValue.w = coverage.y;
            }
            else if (debugSource
                == RENDER_DEBUG_SOURCE_DOF_GATHER_FILL)
            {
                debugValue.xy = coverage;
            }
        }
        outputColor = RenderDebugBlend(
            outputColor,
            RenderDebugMap(debugValue, debugSource));
    }
    imageStore(OutputTex, pixel, vec4(outputColor, 1.0));
}
