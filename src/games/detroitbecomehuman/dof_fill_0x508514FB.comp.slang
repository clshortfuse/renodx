#version 450

#include "shared.h"

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
    if ((sNativePrepassCoc.y * farFillRadiusScale * 8.0) > 3.0)
    {
        farColor = FilterFar(
            uv, sNativePrepassCoc.y * farFillRadiusScale);
    }
    imageStore(
        OutColorFar,
        pixel,
        vec4(farColor, texelFetch(dofAlphaMapFar, pixel, 0).x));
}
