#version 450

#include "../../detroitbecomehuman/shared.h"
#include "../debug/render_debug_common.slang"

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

const ivec2 kBilinearOffsets[4] = ivec2[](
    ivec2(0),
    ivec2(1, 0),
    ivec2(0, 1),
    ivec2(1));

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

vec4 ResolveFarBalanced(vec2 dofPosition, vec3 sharpColor)
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
        float authoredCoverage = clamp(sampleValue.w, 0.0, 1.0);
        float colorWeight = weights[i] * float(authoredCoverage > 0.0);
        colorSum += sampleValue.xyz * colorWeight;
        validWeight += colorWeight;
        alphaSum += authoredCoverage * weights[i];
    }
    return validWeight > 0.0
        ? vec4(colorSum / vec3(validWeight), clamp(alphaSum, 0.0, 1.0))
        : vec4(sharpColor, 0.0);
}

vec3 ResolveFullResolutionSmallCoc(
    ivec2 pixel,
    float centerFarCoc,
    float exposure)
{
    // Bridge small CoC from Detroit's full-resolution source instead of
    // exposing the reduced-resolution bokeh grid. This is deliberately a
    // compact bridge, not a second full-screen DOF system in Composite.
    const float cornerWeight = 0.5453;
    const float sideWeight = 0.9717;
    vec3 colorSum = vec3(0.0);
    float weightSum = 0.0;
    for (int y = -1; y <= 1; ++y)
    {
        for (int x = -1; x <= 1; ++x)
        {
            ivec2 offset = ivec2(x, y);
            ivec2 samplePixel = ClampFullPixel(pixel + offset);
            float sampleDepth = LinearizeDepth(
                texelFetch(depthMap, samplePixel, 0).x);
            float sampleFarCoc = ComputeFarCoc16(sampleDepth);
            float sameFarLayer = smoothstep(0.0, 0.25, sampleFarCoc);
            float cocCompatibility = 1.0 - smoothstep(
                0.5,
                1.5,
                abs(sampleFarCoc - centerFarCoc));
            float spatialWeight = x == 0 && y == 0
                ? 1.0
                : (x != 0 && y != 0 ? cornerWeight : sideWeight);
            float weight = spatialWeight * sameFarLayer * cocCompatibility;
            colorSum += texelFetch(accumBufferMap, samplePixel, 0).xyz
                * vec3(exposure * weight);
            weightSum += weight;
        }
    }
    return weightSum > 0.0
        ? colorSum / vec3(weightSum)
        : texelFetch(accumBufferMap, pixel, 0).xyz * vec3(exposure);
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
    float vanillaTransitionControl = cinematic
        ? clamp(CUSTOM_DOF_VANILLA_TRANSITION, 0.0, 1.0)
        : 0.0;
    vec3 farResult = sharpColor;
    if (farCoc > 0.0)
    {
        // Resolve the authored layer unconditionally inside the full-resolution
        // far gate. High controls contribution with a smooth CoC weight below;
        // conditionally creating the layer at 1.5 px exposed the algorithm
        // handoff as an isocontour on curved, high-frequency surfaces.
        vec4 farLayer = ResolveFarBalanced(dofPosition, sharpColor);
        float cleanCoverage = clamp(
            clamp(farCoc, 0.0, 1.0) * CUSTOM_DOF_FAR_STRENGTH,
            0.0,
            1.0);
        float transitionCoverage = cleanCoverage;
        float authoredTransitionCoverage = cleanCoverage;
        if (vanillaTransitionControl > 0.0)
        {
            authoredTransitionCoverage = farCoc > 1.0
                ? clamp(
                    farLayer.w * CUSTOM_DOF_FAR_STRENGTH,
                    0.0,
                    1.0)
                : cleanCoverage;
            transitionCoverage = mix(
                cleanCoverage,
                authoredTransitionCoverage,
                vanillaTransitionControl);
        }
        if (highQuality)
        {
            float smallCocWeight = clamp(
                smoothstep(0.35, 1.5, farCoc)
                    * CUSTOM_DOF_FAR_STRENGTH,
                0.0,
                1.0);
            float reducedResolutionProgress = smoothstep(
                1.0,
                2.5,
                farCoc);
            vec3 smallCocColor = sharpColor;
            if (reducedResolutionProgress < 1.0)
            {
                smallCocColor = ResolveFullResolutionSmallCoc(
                    pixel, farCoc, exposure);
            }
            vec3 smallCocResult = mix(
                sharpColor,
                smallCocColor,
                vec3(smallCocWeight));
            // Handoff between two complete composites. Applying coverage to
            // the outer interpolation leaves the uncovered portion on the
            // fixed 3x3 bridge and exposes that residual as a CoC isocontour.
            vec3 authoredFarResult = mix(
                sharpColor,
                farLayer.xyz,
                vec3(transitionCoverage));
            farResult = mix(
                smallCocResult,
                authoredFarResult,
                vec3(reducedResolutionProgress));
            finalVanillaTransition = vanillaTransitionControl
                * authoredTransitionCoverage
                * reducedResolutionProgress;
        }
        else
        {
            farResult = mix(
                sharpColor,
                farLayer.xyz,
                vec3(transitionCoverage));
            finalVanillaTransition = vanillaTransitionControl
                * authoredTransitionCoverage;
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
            // This is the final contribution of authored Gather/Fill coverage
            // after the full-resolution small-CoC bridge, not raw R8 alpha.
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
