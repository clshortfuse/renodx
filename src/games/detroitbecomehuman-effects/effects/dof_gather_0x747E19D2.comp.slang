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
} _123;

layout(set = 0, binding = 1) uniform sampler2D dofCocMapNear;
layout(set = 0, binding = 4) uniform sampler2D dofPrepassCocMap;
layout(set = 0, binding = 17, r8) uniform writeonly image2D OutTexAlphaNear;
layout(set = 0, binding = 19, r8) uniform writeonly image2D OutTexAlphaFar;
layout(set = 0, binding = 16, r11f_g11f_b10f) uniform writeonly image2D OutTexColorNear;
layout(set = 0, binding = 18, r11f_g11f_b10f) uniform writeonly image2D OutTexColorFar;
layout(set = 0, binding = 0) uniform sampler2D dofColorMapNear;
layout(set = 0, binding = 3) uniform sampler2D dofCocMapFar;
layout(set = 0, binding = 2) uniform sampler2D dofColorMapFar;

shared bvec4 sPrepassFlags;
shared float sNativeNearMaxCoc;

bool IsUvInBounds(vec2 uv)
{
    return uv.x >= 0.0 && uv.x <= 1.0
        && uv.y >= 0.0 && uv.y <= 1.0;
}

void StoreEmpty(ivec2 pixel)
{
    imageStore(OutTexAlphaNear, pixel, vec4(0.0));
    imageStore(OutTexAlphaFar, pixel, vec4(0.0));
    imageStore(OutTexColorNear, pixel, vec4(1.0, 0.0, 0.0, 0.0));
    imageStore(OutTexColorFar, pixel, vec4(0.0, 1.0, 0.0, 0.0));
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
    vec2 uv = (pixelF + vec2(0.5)) / _123._DOF._vfFull_DOFSize.zw;

    if (gl_LocalInvocationIndex == 0u)
    {
        vec4 coarse = texelFetch(
            dofPrepassCocMap,
            ivec2(pixelF / _123._DOF._vCoCScaleFactor.xy),
            0);
        float nearMin = coarse.z * 8.0;
        float nearMax = coarse.x * 8.0;
        float farMin = coarse.w * 8.0;
        float farMax = coarse.y * 8.0;
        float nearSpread = nearMax - nearMin;
        bool refineNear = nearSpread > 0.125;
        if (!refineNear)
        {
            refineNear = nearMin == 0.0 && nearMax != 0.0;
        }
        bool refineFar = (farMax - farMin) > 0.125;
        if (!refineFar)
        {
            refineFar = farMin == 0.0 && farMax != 0.0;
        }
        sPrepassFlags = bvec4(
            coarse.x > 0.0,
            coarse.y > 0.0,
            refineNear,
            refineFar);
        sNativeNearMaxCoc = nearSpread > 4.0 ? 0.0 : coarse.x;
    }
    barrier();
    memoryBarrierShared();

    bool enhanced = CUSTOM_DOF_RUNTIME_MODE >= 0.5;
    float localFarCoc = texelFetch(dofCocMapFar, pixel, 0).x;
    if (!enhanced && !sPrepassFlags.x && !sPrepassFlags.y)
    {
        StoreEmpty(pixel);
        return;
    }

    vec2 nativeRadiusCoc = textureLod(
        dofPrepassCocMap, uv, 0.0).xy;
    if (sNativeNearMaxCoc != 0.0)
    {
        nativeRadiusCoc.x = sNativeNearMaxCoc;
    }

    float nearRadiusCoc = nativeRadiusCoc.x;
    bool hasNear = sPrepassFlags.x;
    bool hasFar = enhanced
        ? localFarCoc > 0.0
        : sPrepassFlags.y;

    if (hasNear)
    {
        float radius = nearRadiusCoc * 8.0;
        vec3 colorSum = vec3(0.0);
        float weightSum = 0.0;
        float alphaSum = 0.0;
        for (int row = 0; row < 7; ++row)
        {
            vec4 colors[7];
            bool useColor[7];
            for (int column = 0; column < 7; ++column)
            {
                int kernelIndex = row * 7 + column;
                vec2 sampleUv = uv
                    + ((_123._DOF._avfKernel[kernelIndex].xy * radius)
                        * vec2(
                            1.0 / _123._DOF._vfFull_DOFSize.z,
                            1.0 / _123._DOF._vfFull_DOFSize.w));
                vec3 sampleColor = textureLod(
                    dofColorMapNear, sampleUv, 0.0).xyz;
                float sampleCoc = sPrepassFlags.z
                    ? textureLod(dofCocMapNear, sampleUv, 0.0).x
                    : nativeRadiusCoc.x;
                colors[column] = vec4(sampleColor, sampleCoc);
                useColor[column] = IsUvInBounds(sampleUv);
            }

            for (int column = 0; column < 7; ++column)
            {
                int kernelIndex = row * 7 + column;
                float sampleCoc = colors[column].w * 8.0;
                float coverage = (useColor[column] && sampleCoc > 0.0)
                    ? 1.0 - clamp(
                        (_123._DOF._avfKernel[kernelIndex].z * radius)
                            - sampleCoc,
                        0.0,
                        1.0)
                    : 0.0;
                float weightedCoverage = coverage * sampleCoc;
                float colorWeight = weightedCoverage * 0.125;
                colorSum += colors[column].xyz * colorWeight;
                weightSum += colorWeight;
                alphaSum += clamp(weightedCoverage * 0.5, 0.0, 1.0);
            }
        }

        imageStore(
            OutTexColorNear,
            pixel,
            vec4(colorSum / vec3(weightSum > 0.0 ? weightSum : 1.0), 0.0));
        imageStore(
            OutTexAlphaNear,
            pixel,
            vec4(clamp(
                0.0408163256943225860595703125 * alphaSum,
                0.0,
                1.0), 0.0, 0.0, 0.0));
    }
    else
    {
        imageStore(OutTexColorNear, pixel, vec4(1.0, 0.0, 0.0, 0.0));
        imageStore(OutTexAlphaNear, pixel, vec4(0.0));
    }

    if (!hasFar)
    {
        imageStore(OutTexColorFar, pixel, vec4(0.0, 1.0, 0.0, 0.0));
        imageStore(OutTexAlphaFar, pixel, vec4(0.0));
        return;
    }

    if (localFarCoc == 0.0)
    {
        imageStore(OutTexColorFar, pixel, vec4(0.0, 0.0, 1.0, 0.0));
        imageStore(OutTexAlphaFar, pixel, vec4(0.0));
        return;
    }

    float farRadius = localFarCoc * 8.0;
    vec3 farColorSum = vec3(0.0);
    float farWeightSum = 0.0;
    float farAlphaSum = 0.0;
    for (int row = 0; row < 7; ++row)
    {
        vec4 colors[7];
        bool useColor[7];
        for (int column = 0; column < 7; ++column)
        {
            int kernelIndex = row * 7 + column;
            vec2 sampleUv = uv
                + ((_123._DOF._avfKernel[kernelIndex].xy * farRadius)
                    * vec2(
                        1.0 / _123._DOF._vfFull_DOFSize.z,
                        1.0 / _123._DOF._vfFull_DOFSize.w));
            vec3 sampleColor = textureLod(
                dofColorMapFar, sampleUv, 0.0).xyz;
            float sampleCoc = enhanced || sPrepassFlags.w
                ? textureLod(dofCocMapFar, sampleUv, 0.0).x
                : nativeRadiusCoc.y;
            colors[column] = vec4(sampleColor, sampleCoc);
            useColor[column] = IsUvInBounds(sampleUv);
        }

        for (int column = 0; column < 7; ++column)
        {
            int kernelIndex = row * 7 + column;
            float sampleCoc = colors[column].w * 8.0;
            float coverage = (useColor[column] && sampleCoc > 0.0)
                ? 1.0 - clamp(
                    (_123._DOF._avfKernel[kernelIndex].z * farRadius)
                        - sampleCoc,
                    0.0,
                    1.0)
                : 0.0;
            float weightedCoverage = coverage * sampleCoc;
            float colorWeight = weightedCoverage * 0.125;
            farColorSum += colors[column].xyz * colorWeight;
            farWeightSum += colorWeight;
            farAlphaSum += weightedCoverage;
        }
    }

    vec4 farOutput;
    if (farWeightSum > 0.0)
    {
        farOutput = vec4(
            farColorSum / vec3(farWeightSum),
            clamp(
                farAlphaSum * 0.02040816284716129302978515625,
                0.0,
                1.0));
    }
    else
    {
        farOutput = vec4(0.0, 1.0, 1.0, 0.0);
    }
    imageStore(OutTexColorFar, pixel, vec4(farOutput.xyz, 0.0));
    imageStore(OutTexAlphaFar, pixel, vec4(farOutput.w, 0.0, 0.0, 0.0));
}
