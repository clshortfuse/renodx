// Copyright (C) 2016-2021, Intel Corporation
// SPDX-License-Identifier: MIT
//
// Five-by-five depth-aware resolve for the XeGTAO-derived Detroit path.

#version 450
#extension GL_EXT_samplerless_texture_functions : require

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

struct POST_PROCESSING_HBAO_GRAINY_BLUR_CONSTANT_BUFFER
{
    ivec2 _viViewportSize;
    vec2 _vfInputTextureInvSize;
    float _fNoiseDelta;
    int _iPadding0;
    int _iPadding1;
    int _iPadding2;
};

layout(set = 0, binding = 52, std140) uniform dyn_CONSTANT_BUFFER_BLOCK_0
{
    POST_PROCESSING_HBAO_GRAINY_BLUR_CONSTANT_BUFFER g_cbBlur;
} _denoise;

layout(set = 0, binding = 0) uniform sampler2D sTileTexture;
layout(set = 0, binding = 1) uniform usampler2D sPackedAOAndDepth;
layout(set = 0, binding = 2) uniform sampler2D sBlueNoiseTexture32;
layout(set = 0, binding = 16, r8) uniform writeonly image2D OutOcclusion;

float SpatialKernelWeight(int offset)
{
    int distance = abs(offset);
    return distance == 0 ? 6.0 : (distance == 1 ? 4.0 : 1.0);
}

bool HasActiveTile(ivec2 pixel)
{
    ivec2 tile_size = max(textureSize(sTileTexture, 0), ivec2(1));
    ivec2 tile = clamp(pixel >> 4, ivec2(0), tile_size - ivec2(1));
    return texelFetch(sTileTexture, tile, 0).x != 0.0;
}

void main()
{
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    ivec2 output_size = imageSize(OutOcclusion);
    ivec2 viewport_size = min(_denoise.g_cbBlur._viViewportSize, output_size);
    if (any(greaterThanEqual(pixel, viewport_size)))
        return;

    if (!HasActiveTile(pixel))
    {
        imageStore(OutOcclusion, pixel, vec4(0.0));
        return;
    }

    ivec2 input_size = max(textureSize(sPackedAOAndDepth, 0), ivec2(1));
    uint center_packed = texelFetch(sPackedAOAndDepth, pixel, 0).x;
    int center_depth = int(center_packed & 8191u);
    if (center_depth == 0)
    {
        imageStore(OutOcclusion, pixel, vec4(0.0));
        return;
    }

    float weighted_occlusion = 0.0;
    float total_weight = 0.0;

    for (int y = -2; y <= 2; ++y)
    {
        float weight_y = SpatialKernelWeight(y);
        for (int x = -2; x <= 2; ++x)
        {
            ivec2 sample_pixel = clamp(pixel + ivec2(x, y), ivec2(0), input_size - ivec2(1));
            uint packed = texelFetch(sPackedAOAndDepth, sample_pixel, 0).x;
            int depth_delta = abs(int(packed & 8191u) - center_depth);
            // Detroit's native resolve only accepts packed-depth deltas below
            // three codes. A wider gate bleeds AO across silhouettes.
            if (depth_delta >= 3)
                continue;

            float spatial_weight = SpatialKernelWeight(x) * weight_y;
            float depth_weight = exp2(-0.5 * float(depth_delta * depth_delta));
            float weight = spatial_weight * depth_weight;
            weighted_occlusion += (float(packed >> 13u) / 7.0) * weight;
            total_weight += weight;
        }
    }

    float occlusion = total_weight > 0.0
        ? weighted_occlusion / total_weight
        : float(center_packed >> 13u) / 7.0;
    ivec2 noise_size = max(textureSize(sBlueNoiseTexture32, 0), ivec2(1));
    ivec2 noise_pixel = pixel % noise_size;
    float dither = fract(
        texelFetch(sBlueNoiseTexture32, noise_pixel, 0).x
        + _denoise.g_cbBlur._fNoiseDelta) - 0.5;
    occlusion = clamp(occlusion + dither / 255.0, 0.0, 1.0);
    imageStore(OutOcclusion, pixel, vec4(occlusion, 0.0, 0.0, 0.0));
}
