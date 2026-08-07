// Native Detroit DoF expands its tile CoC with an all-or-nothing 3x3 max/min
// operation. The abrupt expansion is visible as a rectangular focus step on
// thin geometry. Retain the occlusion protection, but blend the expansion
// into the centre tile instead of replacing it outright.

#version 450

#include "./shared.h"

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
} _107;

layout(set = 0, binding = 0) uniform sampler2D dofPrepassCocMap;
layout(set = 0, binding = 16, rgba16f) uniform writeonly image2D OutputCocTexture;

void main()
{
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    if (any(greaterThanEqual(pixel, _107._DOF._viPrepassTexSize)))
    {
        return;
    }

    vec4 centre = texelFetch(dofPrepassCocMap, pixel, 0);
    float near_max = 0.0;
    float near_min = 1.0;
    float far_max = 0.0;
    float far_min = 1.0;

    for (int y = -1; y <= 1; ++y)
    {
        for (int x = -1; x <= 1; ++x)
        {
            ivec2 sample_pixel = pixel + ivec2(x, y);
            if (any(lessThan(sample_pixel, ivec2(0)))
                || any(greaterThanEqual(sample_pixel, _107._DOF._viPrepassTexSize)))
            {
                continue;
            }
            vec4 coc = texelFetch(dofPrepassCocMap, sample_pixel, 0);
            near_max = max(near_max, coc.x);
            near_min = min(near_min, coc.z);
            if (centre.y > 0.0)
            {
                far_max = max(far_max, coc.y);
                far_min = min(far_min, coc.w);
            }
        }
    }

    // 0 keeps the centre tile; 1 reproduces the native full 3x3 dilation.
    // Modes below Smooth Tile Edges always retain Detroit's original dilation.
    float dilation_amount = CUSTOM_DOF_MODE >= 2.0
        ? clamp(CUSTOM_DOF_DILATION_AMOUNT, 0.0, 1.0)
        : 1.0;
    vec4 filtered = vec4(near_max, far_max, near_min, far_min);
    imageStore(OutputCocTexture, pixel, mix(centre, filtered, dilation_amount));
}
