#version 450

#include "../../detroitbecomehuman/shared.h"

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

const vec2 kQuadOffsets[4] = vec2[](
    vec2(0.0),
    vec2(0.0, 1.0),
    vec2(1.0, 0.0),
    vec2(1.0));

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
} _115;

layout(set = 0, binding = 3) uniform sampler2D AvgLumMap;
layout(set = 0, binding = 2) uniform sampler2D dofPrepassCocMap;
layout(set = 0, binding = 18, r16f) uniform writeonly image2D OutputTexCocNear;
layout(set = 0, binding = 19, r16f) uniform writeonly image2D OutputTexCocFar;
layout(set = 0, binding = 17, r11f_g11f_b10f) uniform writeonly image2D OutputTexColorFar;
layout(set = 0, binding = 16, r11f_g11f_b10f) uniform writeonly image2D OutputTexColorNear;
layout(set = 0, binding = 0) uniform sampler2D colorMap;
layout(set = 0, binding = 1) uniform sampler2D depthMap;

shared vec4 sPrepassCoc;
shared float sExposure;

float LinearizeDepth(float hardwareDepth)
{
    return (_115._DOF._vfProjSetup.y
        / (hardwareDepth + _115._DOF._vfProjSetup.x))
        * _115._DOF._vfProjSetup.w;
}

float ComputeNearCoc(float viewDepth)
{
    if (CUSTOM_DOF_RUNTIME_MODE >= 0.5)
    {
        float focusDepth = _115._DOF._vfLensParam.y
            * CUSTOM_DOF_FOCUS_SCALE;
        float coc = clamp(((_115._DOF._vfLensParam.z
            * ((focusDepth - viewDepth)
                / (_115._DOF._vfLensParam.x + viewDepth)))
            - 1.2999999853491317480802536010742e-05)
            * _115._DOF._vfLensParam.w, 0.0, 1.0);
        return coc * CUSTOM_DOF_RADIUS_SCALE;
    }
    return clamp(((_115._DOF._vfLensParam.z
        * ((_115._DOF._vfLensParam.y - viewDepth)
            / (_115._DOF._vfLensParam.x + viewDepth)))
        - 1.2999999853491317480802536010742e-05)
        * _115._DOF._vfLensParam.w, 0.0, 1.0);
}

float ComputeNativeNearCoc(float viewDepth)
{
    return clamp(((_115._DOF._vfLensParam.z
        * ((_115._DOF._vfLensParam.y - viewDepth)
            / (_115._DOF._vfLensParam.x + viewDepth)))
        - 1.2999999853491317480802536010742e-05)
        * _115._DOF._vfLensParam.w, 0.0, 1.0);
}

float ComputeFarCoc(float viewDepth)
{
    if (CUSTOM_DOF_RUNTIME_MODE >= 0.5)
    {
        float focusDepth = _115._DOF._vfLensParam.y
            * CUSTOM_DOF_FOCUS_SCALE;
        float coc = clamp(((_115._DOF._vfLensParam.z
            * ((viewDepth - focusDepth)
                / (_115._DOF._vfLensParam.x + viewDepth)))
            - 1.2999999853491317480802536010742e-05)
            * _115._DOF._vfLensParam.w, 0.0, 1.0);
        return coc * CUSTOM_DOF_RADIUS_SCALE;
    }
    return clamp(((_115._DOF._vfLensParam.z
        * ((viewDepth - _115._DOF._vfLensParam.y)
            / (_115._DOF._vfLensParam.x + viewDepth)))
        - 1.2999999853491317480802536010742e-05)
        * _115._DOF._vfLensParam.w, 0.0, 1.0);
}

void StoreEmpty(ivec2 pixel)
{
    imageStore(OutputTexCocNear, pixel, vec4(0.0));
    imageStore(OutputTexCocFar, pixel, vec4(0.0));
    imageStore(OutputTexColorFar, pixel, vec4(0.0));
    imageStore(OutputTexColorNear, pixel, vec4(0.0));
}

void main()
{
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    if (CUSTOM_DOF_RUNTIME_MODE < -1.0)
    {
        StoreEmpty(pixel);
        return;
    }
    vec2 pixelF = vec2(pixel);
    vec2 sourcePixel = pixelF * _115._DOF._vScaleFactor;

    if (gl_LocalInvocationIndex == 0u)
    {
        sPrepassCoc = texelFetch(
            dofPrepassCocMap,
            ivec2(pixelF / _115._DOF._vCoCScaleFactor.xy),
            0);
        sExposure = max(
            _115._DOF._vfDofParam.z,
            texelFetch(AvgLumMap, ivec2(0), 0).y);
    }
    barrier();
    memoryBarrierShared();

    bool enhanced = CUSTOM_DOF_RUNTIME_MODE >= 0.5;
    bool coarseNear = sPrepassCoc.x > 0.0;
    bool coarseFar = sPrepassCoc.y > 0.0;
    if (!enhanced && !coarseNear && !coarseFar)
    {
        // The min/max prepass and its dilation are conservative. This is the
        // only Enhanced path decision allowed to use the tile classifier.
        StoreEmpty(pixel);
        return;
    }

    float coarseNearMin = sPrepassCoc.z * 8.0;
    float coarseNearMax = sPrepassCoc.x * 8.0;
    float coarseFarMin = sPrepassCoc.w * 8.0;
    float coarseFarMax = sPrepassCoc.y * 8.0;
    bool refineNear = (coarseNearMax - coarseNearMin) > 0.125;
    if (!refineNear)
    {
        refineNear = coarseNearMin == 0.0 && coarseNearMax != 0.0;
    }
    bool refineFar = enhanced
        || (coarseFarMax - coarseFarMin) > 0.125;
    if (!refineFar)
    {
        refineFar = coarseFarMin == 0.0 && coarseFarMax != 0.0;
    }

    vec3 colors[4];
    float depths[4];
    for (int i = 0; i < 4; ++i)
    {
        colors[i] = textureLod(
            colorMap,
            clamp(
                ((sourcePixel
                    + (kQuadOffsets[i] * (_115._DOF._vScaleFactor * 0.5)))
                    + vec2(0.5))
                    / vec2(_115._DOF._viViewportSize),
                vec2(0.0),
                vec2(1.0)),
            0.0).xyz;
        depths[i] = 0.0;
    }

    if (refineNear || refineFar)
    {
        for (int i = 0; i < 4; ++i)
        {
            ivec2 depthPixel = ivec2(sourcePixel)
                + ivec2(kQuadOffsets[i]
                    * vec2(ivec2(_115._DOF._vScaleFactor * 0.5)));
            depthPixel = ivec2(
                clamp(depthPixel.x, 0, _115._DOF._viViewportSize.x - 1),
                clamp(depthPixel.y, 0, _115._DOF._viViewportSize.y - 1));
            depths[i] = LinearizeDepth(
                texelFetch(depthMap, depthPixel, 0).x);
        }
    }

    float nearCocSum = 0.0;
    vec3 nearColorSum = vec3(0.0);
    float nearCount = 0.0;
    // Foreground bokeh remains authored by Detroit in every mode. Enhanced
    // far controls must not retune the native near CoC used by cut-scenes.
    if (coarseNear)
    {
        for (int i = 0; i < 4; ++i)
        {
            float coc = refineNear
                ? (enhanced
                    ? ComputeNativeNearCoc(depths[i])
                    : ComputeNearCoc(depths[i]))
                : sPrepassCoc.x;
            float valid = float(coc > 0.0);
            nearCocSum += coc;
            nearColorSum += colors[i] * valid;
            nearCount += valid;
        }
    }

    float nearCoc = nearCount > 0.0
        ? nearCocSum / nearCount
        : nearCocSum;
    vec3 nearColor = nearCount > 0.0
        ? nearColorSum * (sExposure / nearCount)
        : nearColorSum;
    imageStore(OutputTexColorNear, pixel, vec4(nearColor, 0.0));
    imageStore(OutputTexCocNear, pixel, vec4(nearCoc, 0.0, 0.0, 0.0));

    float farCocSum = 0.0;
    vec3 farColorSum = vec3(0.0);
    float farCount = 0.0;
    if (coarseFar || enhanced)
    {
        for (int i = 0; i < 4; ++i)
        {
            float coc = refineFar
                ? ComputeFarCoc(depths[i])
                : sPrepassCoc.y;
            float valid = float(coc > 0.0);
            farCocSum += coc;
            farColorSum += colors[i] * valid;
            farCount += valid;
        }
    }

    float farCoc = farCount > 0.0
        ? farCocSum / farCount
        : farCocSum;
    vec3 farColor = farCount > 0.0
        ? farColorSum * (sExposure / farCount)
        : farColorSum;
    imageStore(OutputTexColorFar, pixel, vec4(farColor, 0.0));
    imageStore(OutputTexCocFar, pixel, vec4(farCoc, 0.0, 0.0, 0.0));
}
