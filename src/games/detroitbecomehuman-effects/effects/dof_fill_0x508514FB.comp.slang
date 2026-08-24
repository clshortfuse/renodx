#version 450

#include "../../detroitbecomehuman/shared.h"

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

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
} _91;

layout(set = 0, binding = 0) uniform sampler2D dofPrepassCocMap;
layout(set = 0, binding = 1) uniform sampler2D dofColorMapNear;
layout(set = 0, binding = 3) uniform sampler2D dofAlphaMapNear;
layout(set = 0, binding = 16, rgba16f) uniform writeonly image2D OutColorNear;
layout(set = 0, binding = 2) uniform sampler2D dofColorMapFar;
layout(set = 0, binding = 4) uniform sampler2D dofAlphaMapFar;
layout(set = 0, binding = 17, rgba16f) uniform writeonly image2D OutColorFar;

shared vec2 sNativePrepassCoc;

float AlphaOccupancy(sampler2D alphaMap, vec2 uv)
{
    vec4 gathered = textureGather(alphaMap, uv);
    float minimumAlpha = min(
        min(min(gathered.x, gathered.y), gathered.z),
        gathered.w);
    return float(minimumAlpha > 0.0);
}

vec3 FilterNear(vec2 uv, float coc)
{
    vec2 radius = vec2(coc * 1.33333337306976318359375)
        / _91._DOF._vfFull_DOFSize.zw;
    vec2 maxUv = (vec2(_91._DOF._viDOFViewportSize)
        / _91._DOF._vfFull_DOFSize.zw)
        - (vec2(0.5) / _91._DOF._vfFull_DOFSize.zw);
    vec3 centerColor = textureLod(
        dofColorMapNear, clamp(uv, vec2(0.0), maxUv), 0.0).xyz;
    vec3 colorSum = vec3(0.0);
    float weightSum = 0.0;
    for (int x = 0; x < 3; ++x)
    {
        for (int y = 0; y < 3; ++y)
        {
            vec2 sampleUv = uv
                + vec2(float(x - 1), float(y - 1)) * radius;
            sampleUv = clamp(sampleUv, vec2(0.0), maxUv);
            float weight = AlphaOccupancy(dofAlphaMapNear, sampleUv);
            colorSum += textureLod(
                dofColorMapNear, sampleUv, 0.0).xyz * weight;
            weightSum += weight;
        }
    }
    return weightSum > 0.0 ? colorSum / vec3(weightSum) : centerColor;
}

vec3 FilterFar(vec2 uv, float coc)
{
    vec2 radius = vec2(coc * 1.33333337306976318359375)
        / _91._DOF._vfFull_DOFSize.zw;
    vec2 maxUv = (vec2(_91._DOF._viDOFViewportSize)
        / _91._DOF._vfFull_DOFSize.zw)
        - (vec2(0.5) / _91._DOF._vfFull_DOFSize.zw);
    vec3 centerColor = textureLod(
        dofColorMapFar, clamp(uv, vec2(0.0), maxUv), 0.0).xyz;
    vec3 colorSum = vec3(0.0);
    float weightSum = 0.0;
    for (int x = 0; x < 3; ++x)
    {
        for (int y = 0; y < 3; ++y)
        {
            vec2 sampleUv = uv
                + vec2(float(x - 1), float(y - 1)) * radius;
            sampleUv = clamp(sampleUv, vec2(0.0), maxUv);
            float weight = AlphaOccupancy(dofAlphaMapFar, sampleUv);
            colorSum += textureLod(
                dofColorMapFar, sampleUv, 0.0).xyz * weight;
            weightSum += weight;
        }
    }
    return weightSum > 0.0 ? colorSum / vec3(weightSum) : centerColor;
}

vec3 FilterFarDense5x5(vec2 uv, float coc)
{
    // Double the sampling density without expanding Detroit's original
    // 3x3 Fill footprint: two half-radius steps reach the same outer extent
    // as one native step. Only background-valid RGB contributes.
    vec2 sampleStep = vec2(coc * 0.666666686534881591796875)
        / _91._DOF._vfFull_DOFSize.zw;
    vec2 maxUv = (vec2(_91._DOF._viDOFViewportSize)
        / _91._DOF._vfFull_DOFSize.zw)
        - (vec2(0.5) / _91._DOF._vfFull_DOFSize.zw);
    vec3 centerColor = textureLod(
        dofColorMapFar, clamp(uv, vec2(0.0), maxUv), 0.0).xyz;
    const float spatialWeights[5] = float[](1.0, 4.0, 6.0, 4.0, 1.0);
    vec3 colorSum = vec3(0.0);
    float weightSum = 0.0;
    for (int x = 0; x < 5; ++x)
    {
        for (int y = 0; y < 5; ++y)
        {
            vec2 sampleUv = uv
                + vec2(float(x - 2), float(y - 2)) * sampleStep;
            sampleUv = clamp(sampleUv, vec2(0.0), maxUv);
            float weight = AlphaOccupancy(dofAlphaMapFar, sampleUv)
                * spatialWeights[x] * spatialWeights[y];
            colorSum += textureLod(
                dofColorMapFar, sampleUv, 0.0).xyz * weight;
            weightSum += weight;
        }
    }
    return weightSum > 0.0 ? colorSum / vec3(weightSum) : centerColor;
}

void main()
{
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    if (CUSTOM_DOF_RUNTIME_MODE < -1.0)
    {
        imageStore(OutColorNear, pixel, vec4(0.0));
        imageStore(OutColorFar, pixel, vec4(0.0));
        return;
    }
    vec2 pixelF = vec2(pixel);
    vec2 uv = (pixelF + vec2(0.5)) / _91._DOF._vfFull_DOFSize.zw;
    if (gl_LocalInvocationIndex == 0u)
    {
        sNativePrepassCoc = texelFetch(
            dofPrepassCocMap,
            ivec2(pixelF / _91._DOF._vCoCScaleFactor.xy),
            0).xy;
    }
    barrier();
    memoryBarrierShared();
    uint runtimeMode = uint(CUSTOM_DOF_RUNTIME_MODE + 0.5);
    bool highQuality = runtimeMode == 2u
        || runtimeMode == 4u
        || runtimeMode == 6u;
    float farFillRadiusScale = CUSTOM_DOF_RUNTIME_MODE >= 0.5
        ? CUSTOM_DOF_RADIUS_SCALE
        : 1.0;

    // Preserve Detroit's authored foreground fill and alpha in every mode.
    // Enhanced radius controls apply only to the independently modified far
    // layer, so cut-scene near bokeh remains identical in strength to Vanilla.
    vec3 nearCenter = texelFetch(dofColorMapNear, pixel, 0).xyz;
    vec3 nearColor = nearCenter;
    if ((sNativePrepassCoc.x * 8.0) > 3.0)
    {
        nearColor = FilterNear(uv, sNativePrepassCoc.x);
    }
    imageStore(
        OutColorNear,
        pixel,
        vec4(nearColor, texelFetch(dofAlphaMapNear, pixel, 0).x));

    vec3 farCenter = texelFetch(dofColorMapFar, pixel, 0).xyz;
    vec3 farColor = farCenter;
    if (highQuality)
    {
        // Fill has no depth or local far-CoC binding. Reconstruct its existing
        // coarse radius continuously per DOF pixel instead of switching the
        // whole 8x8 workgroup at once. This affects hidden-background RGB only;
        // authored Gather alpha below remains untouched.
        vec2 prepassPosition = (pixelF + vec2(0.5))
            / _91._DOF._vCoCScaleFactor.xy - vec2(0.5);
        ivec2 prepassBase = ivec2(floor(prepassPosition));
        vec2 prepassFraction = fract(prepassPosition);
        ivec2 prepassMaximum = max(
            _91._DOF._viPrepassTexSize - ivec2(1),
            ivec2(0));
        float farCoc00 = texelFetch(
            dofPrepassCocMap,
            clamp(prepassBase, ivec2(0), prepassMaximum),
            0).y;
        float farCoc10 = texelFetch(
            dofPrepassCocMap,
            clamp(prepassBase + ivec2(1, 0), ivec2(0), prepassMaximum),
            0).y;
        float farCoc01 = texelFetch(
            dofPrepassCocMap,
            clamp(prepassBase + ivec2(0, 1), ivec2(0), prepassMaximum),
            0).y;
        float farCoc11 = texelFetch(
            dofPrepassCocMap,
            clamp(prepassBase + ivec2(1), ivec2(0), prepassMaximum),
            0).y;
        float interpolatedFarCoc = mix(
            mix(farCoc00, farCoc10, prepassFraction.x),
            mix(farCoc01, farCoc11, prepassFraction.x),
            prepassFraction.y) * farFillRadiusScale;

        float scaledFarCoc00 = farCoc00 * farFillRadiusScale;
        float scaledFarCoc10 = farCoc10 * farFillRadiusScale;
        float scaledFarCoc01 = farCoc01 * farFillRadiusScale;
        float scaledFarCoc11 = farCoc11 * farFillRadiusScale;
        if (CUSTOM_DOF_FILL_EDGE_AWARE_COC)
        {
            // The bilinear value is a stable local anchor. Nine neighboring
            // coarse samples may refine it only when their CoC is compatible,
            // and the result is clamped to the four-corner monotonic range.
            // This reconstructs Fill radius; it never becomes visibility.
            float localMinimum = min(
                min(scaledFarCoc00, scaledFarCoc10),
                min(scaledFarCoc01, scaledFarCoc11));
            float localMaximum = max(
                max(scaledFarCoc00, scaledFarCoc10),
                max(scaledFarCoc01, scaledFarCoc11));
            float compatibilityScale = max(farFillRadiusScale, 0.25);
            float compatibilityStart = 0.0625 * compatibilityScale;
            float compatibilityEnd = clamp(
                (localMaximum - localMinimum) + compatibilityStart,
                0.125 * compatibilityScale,
                0.25 * compatibilityScale);
            ivec2 prepassCenter = ivec2(floor(
                prepassPosition + vec2(0.5)));
            float cocSum = interpolatedFarCoc * 2.0;
            float weightSum = 2.0;
            for (int x = -1; x <= 1; ++x)
            {
                for (int y = -1; y <= 1; ++y)
                {
                    ivec2 samplePosition = prepassCenter + ivec2(x, y);
                    ivec2 samplePixel = clamp(
                        samplePosition, ivec2(0), prepassMaximum);
                    float sampleFarCoc = texelFetch(
                        dofPrepassCocMap, samplePixel, 0).y
                        * farFillRadiusScale;
                    vec2 spatialOffset = vec2(samplePosition)
                        - prepassPosition;
                    float spatialWeight = 1.0
                        / (1.0 + dot(spatialOffset, spatialOffset) * 1.5);
                    float compatibility = 1.0 - smoothstep(
                        compatibilityStart,
                        compatibilityEnd,
                        abs(sampleFarCoc - interpolatedFarCoc));
                    float weight = spatialWeight * compatibility;
                    cocSum += sampleFarCoc * weight;
                    weightSum += weight;
                }
            }
            interpolatedFarCoc = clamp(
                cocSum / weightSum,
                localMinimum,
                localMaximum);
        }

        float fillStart = 2.0;
        float fillEnd = 4.0;
        if (CUSTOM_DOF_FILL_ADAPTIVE_TRANSITION)
        {
            float horizontalGradient = mix(
                abs(scaledFarCoc10 - scaledFarCoc00),
                abs(scaledFarCoc11 - scaledFarCoc01),
                prepassFraction.y);
            float verticalGradient = mix(
                abs(scaledFarCoc01 - scaledFarCoc00),
                abs(scaledFarCoc11 - scaledFarCoc10),
                prepassFraction.x);
            float gradientPixels = max(
                horizontalGradient, verticalGradient) * 8.0;
            float halfWidth = mix(
                0.75,
                2.0,
                smoothstep(0.25, 2.0, gradientPixels));
            fillStart = 3.0 - halfWidth;
            fillEnd = 3.0 + halfWidth;
        }
        float fillWeight = smoothstep(
            fillStart,
            fillEnd,
            interpolatedFarCoc * 8.0);
        if (fillWeight > 0.0)
        {
            vec3 filledFarColor;
            if (CUSTOM_DOF_FILL_DENSE_RGB)
            {
                filledFarColor = FilterFarDense5x5(
                    uv, interpolatedFarCoc);
            }
            else
            {
                filledFarColor = FilterFar(uv, interpolatedFarCoc);
            }
            farColor = mix(farCenter, filledFarColor, vec3(fillWeight));
        }
    }
    else if ((sNativePrepassCoc.y * farFillRadiusScale * 8.0) > 3.0)
    {
        farColor = FilterFar(
            uv, sNativePrepassCoc.y * farFillRadiusScale);
    }
    imageStore(
        OutColorFar,
        pixel,
        vec4(farColor, texelFetch(dofAlphaMapFar, pixel, 0).x));
}
