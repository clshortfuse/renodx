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

vec3 ResolveSmoothedVanillaFarTransition(
    vec2 pixelF,
    float farCoc,
    vec3 sharpColor,
    bool highQuality,
    out float transitionSupport)
{
    transitionSupport = 0.0;
    ivec2 centerFullPixel = ClampFullPixel(ivec2(pixelF));
    int fullRadius = highQuality ? 3 : 2;
    float maximumFullSigma = highQuality ? 1.75 : 1.25;
    float cocSigmaStrength = smoothstep(0.5, 8.0, farCoc);
    float fullSigma = mix(0.65, maximumFullSigma, cocSigmaStrength);
    float filteredCocSum = 0.0;
    float fullSpatialWeightSum = 0.0;
    for (int y = -3; y <= 3; ++y)
    {
        for (int x = -3; x <= 3; ++x)
        {
            if (abs(x) > fullRadius || abs(y) > fullRadius)
            {
                continue;
            }
            ivec2 offset = ivec2(x, y);
            ivec2 sampleFullPixel = ClampFullPixel(
                centerFullPixel + offset);
            float spatialWeight = exp(
                -0.5 * dot(vec2(offset), vec2(offset))
                    / (fullSigma * fullSigma));
            float sampleFarCoc = ComputeFarCoc16(LinearizeDepth(
                texelFetch(depthMap, sampleFullPixel, 0).x));
            filteredCocSum += sampleFarCoc * spatialWeight;
            fullSpatialWeightSum += spatialWeight;
        }
    }
    float filteredFullResolutionCoc = fullSpatialWeightSum > 0.0
        ? filteredCocSum / fullSpatialWeightSum
        : farCoc;
    float fullResolutionFarGradient = clamp(
        (farCoc - filteredFullResolutionCoc) / max(farCoc, 1.0),
        0.0,
        1.0);
    float backgroundBlurStrength = smoothstep(0.5, 4.0, farCoc);

    vec2 dofPosition = pixelF / _125._DOF._vScaleFactor;
    ivec2 centerPixel = ivec2(floor(dofPosition));
    int colorRadius = highQuality ? 3 : 2;
    float maximumColorSigma = highQuality ? 1.75 : 1.25;
    float colorSigma = mix(
        0.65,
        maximumColorSigma,
        cocSigmaStrength);
    vec3 colorSum = vec3(0.0);
    float colorWeightSum = 0.0;
    for (int y = -3; y <= 3; ++y)
    {
        for (int x = -3; x <= 3; ++x)
        {
            if (abs(x) > colorRadius || abs(y) > colorRadius)
            {
                continue;
            }
            ivec2 samplePixel = ClampDofPixel(
                centerPixel + ivec2(x, y));
            vec2 delta = (vec2(samplePixel) + vec2(0.5)) - dofPosition;
            float spatialWeight = exp(
                -0.5 * dot(delta, delta)
                    / (colorSigma * colorSigma));
            vec4 sampleValue = texelFetch(FarDofMap, samplePixel, 0);
            float alpha = clamp(sampleValue.w, 0.0, 1.0);
            float colorWeight = spatialWeight * alpha;
            colorSum += sampleValue.xyz * vec3(colorWeight);
            colorWeightSum += colorWeight;
        }
    }
    vec3 resolvedColor = colorWeightSum > 0.0
        ? colorSum / vec3(colorWeightSum)
        : sharpColor;
    float fullResolutionCoverage = clamp(farCoc, 0.0, 1.0);
    // FarDofMap alpha only validates authored color samples. Visibility comes
    // from a full-resolution Gaussian CoC gradient, so the half-resolution R8
    // grid cannot become a moving silhouette mask.
    transitionSupport = fullResolutionFarGradient
        * backgroundBlurStrength
        * (1.0 - smoothstep(4.0, 8.0, farCoc));
    return mix(
        sharpColor,
        resolvedColor,
        vec3(fullResolutionCoverage));
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
    out float finalVanillaTransition)
{
    finalVanillaTransition = 0.0;
    vec2 dofPosition = pixelF / _125._DOF._vScaleFactor;
    vec4 coarse = texelFetch(
        dofPrepassCocMap,
        ivec2(pixelF / _125._DOF._vCoCScaleFactor.zw),
        0);
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
        float transitionCoverage = clamp(
            clamp(farCoc, 0.0, 1.0) * CUSTOM_DOF_FAR_STRENGTH,
            0.0,
            1.0);
        vec3 transitionResult = mix(
            sharpColor,
            transitionBlur,
            vec3(transitionCoverage));
        float vanillaTransitionControl = cinematic
            ? clamp(CUSTOM_DOF_VANILLA_TRANSITION, 0.0, 1.0)
            : 0.0;
        float vanillaTransitionBlend = 0.0;
        if (vanillaTransitionControl > 0.0)
        {
            float vanillaTransitionSupport;
            vec3 vanillaTransition = ResolveSmoothedVanillaFarTransition(
                pixelF,
                farCoc,
                sharpColor,
                highQuality,
                vanillaTransitionSupport);
            vanillaTransitionBlend = vanillaTransitionControl
                * vanillaTransitionSupport;
            transitionResult = mix(
                transitionResult,
                vanillaTransition,
                vec3(vanillaTransitionBlend));
        }
        finalVanillaTransition = vanillaTransitionBlend;
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
            float deepLayerWeight = smoothstep(5.0, 8.0, farCoc)
                * smoothstep(0.75, 0.98, farSupport);
            farResult = mix(
                transitionResult,
                nativeFarResult,
                vec3(deepLayerWeight));
            finalVanillaTransition *= 1.0 - deepLayerWeight;
        }
    }

    // Foreground bokeh is an authored cut-scene layer. Composite it with the
    // same color, R8 alpha, bilinear weights and ordering as Vanilla, without
    // applying Enhanced focus/radius/strength controls or a depth rejection.
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

    float finalVanillaTransition = 0.0;
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
            pixel, pixelF, sharpColor, exposure, finalVanillaTransition);
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
        else if (debugSource
            == RENDER_DEBUG_SOURCE_DOF_VANILLA_TRANSITION_CONTROL)
        {
            // Show the value decoded by this exact composite shader so a stale
            // UI or payload route cannot be mistaken for a weak transition.
            debugValue.x = clamp(
                CUSTOM_DOF_VANILLA_TRANSITION, 0.0, 1.0);
        }
        else if (debugSource
            == RENDER_DEBUG_SOURCE_DOF_VANILLA_TRANSITION_CONTRIBUTION)
        {
            // This is the final filtered Vanilla-transition contribution after
            // confirmed deep-layer replacement, not its R8 alpha value.
            debugValue.x = finalVanillaTransition;
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
