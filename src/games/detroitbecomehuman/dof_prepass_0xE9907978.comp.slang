// Detroit's native DoF prepass uses a coarse CoC per tile, then only samples
// the four underlying depth values when their CoC spread exceeds 0.125 * 8.
// That hard gate leaves thin, partially covered geometry (especially hair)
// with the tile CoC and creates a visible focus boundary. Keep the native
// lens model and blur chain. The user mode can restore the exact native gate.

#version 450

#include "./shared.h"

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

const vec2 k_quad_offsets[4] = vec2[](vec2(0.0), vec2(0.0, 1.0), vec2(1.0, 0.0), vec2(1.0));

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

shared vec4 dof_prepass_coc;
shared float exposure;

float LinearizeDepth(float hardware_depth)
{
    return (_115._DOF._vfProjSetup.y / (hardware_depth + _115._DOF._vfProjSetup.x))
        * _115._DOF._vfProjSetup.w;
}

float NearCoc(float view_depth)
{
    return clamp(((_115._DOF._vfLensParam.z
        * ((_115._DOF._vfLensParam.y - view_depth) / (_115._DOF._vfLensParam.x + view_depth)))
        - 0.000013) * _115._DOF._vfLensParam.w, 0.0, 1.0);
}

float FarCoc(float view_depth)
{
    return clamp(((_115._DOF._vfLensParam.z
        * ((view_depth - _115._DOF._vfLensParam.y) / (_115._DOF._vfLensParam.x + view_depth)))
        - 0.000013) * _115._DOF._vfLensParam.w, 0.0, 1.0);
}

void main()
{
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    vec2 pixel_f = vec2(pixel);
    vec2 source_pixel = pixel_f * _115._DOF._vScaleFactor;

    if (gl_LocalInvocationIndex == 0u)
    {
        dof_prepass_coc = texelFetch(
            dofPrepassCocMap,
            ivec2(pixel_f / _115._DOF._vCoCScaleFactor.xy),
            0);
        exposure = max(_115._DOF._vfDofParam.z, texelFetch(AvgLumMap, ivec2(0), 0).y);
    }
    barrier();
    memoryBarrierShared();

    bool has_near = dof_prepass_coc.x > 0.0;
    bool has_far = dof_prepass_coc.y > 0.0;
    if (!has_near && !has_far)
    {
        imageStore(OutputTexCocNear, pixel, vec4(0.0));
        imageStore(OutputTexCocFar, pixel, vec4(0.0));
        imageStore(OutputTexColorNear, pixel, vec4(0.0));
        imageStore(OutputTexColorFar, pixel, vec4(0.0));
        return;
    }

    // Native threshold was (max - min) * 8 > 0.125. The user control is in
    // normalized CoC units; 0.015625 reproduces that original threshold.
    float edge_threshold = CUSTOM_DOF_MODE >= 1.0
        ? max(CUSTOM_DOF_EDGE_THRESHOLD, 0.0)
        : 0.015625;
    bool refine_near = (dof_prepass_coc.x - dof_prepass_coc.z) > edge_threshold;
    bool refine_far = (dof_prepass_coc.y - dof_prepass_coc.w) > edge_threshold;

    vec3 colors[4];
    float depths[4];
    for (int i = 0; i < 4; ++i)
    {
        vec2 uv = clamp(
            ((source_pixel + (k_quad_offsets[i] * (_115._DOF._vScaleFactor * 0.5))) + vec2(0.5))
                / vec2(_115._DOF._viViewportSize),
            vec2(0.0), vec2(1.0));
        colors[i] = textureLod(colorMap, uv, 0.0).xyz;
        depths[i] = 0.0;
    }

    if (refine_near || refine_far)
    {
        for (int i = 0; i < 4; ++i)
        {
            ivec2 depth_pixel = ivec2(source_pixel)
                + ivec2(k_quad_offsets[i] * vec2(ivec2(_115._DOF._vScaleFactor * 0.5)));
            depth_pixel = clamp(depth_pixel, ivec2(0), _115._DOF._viViewportSize - ivec2(1));
            depths[i] = LinearizeDepth(texelFetch(depthMap, depth_pixel, 0).x);
        }
    }

    float near_sum = 0.0;
    vec3 near_color_sum = vec3(0.0);
    float near_count = 0.0;
    if (has_near)
    {
        for (int i = 0; i < 4; ++i)
        {
            float coc = refine_near ? NearCoc(depths[i]) : dof_prepass_coc.x;
            float valid = float(coc > 0.0);
            near_sum += coc;
            near_color_sum += colors[i] * valid;
            near_count += valid;
        }
    }
    float near_coc = near_count > 0.0 ? near_sum / near_count : near_sum;
    vec3 near_color = near_count > 0.0 ? near_color_sum * (exposure / near_count) : near_color_sum;
    imageStore(OutputTexColorNear, pixel, vec4(near_color, 0.0));
    imageStore(OutputTexCocNear, pixel, vec4(near_coc, 0.0, 0.0, 0.0));

    float far_sum = 0.0;
    vec3 far_color_sum = vec3(0.0);
    float far_count = 0.0;
    if (has_far)
    {
        for (int i = 0; i < 4; ++i)
        {
            float coc = refine_far ? FarCoc(depths[i]) : dof_prepass_coc.y;
            float valid = float(coc > 0.0);
            far_sum += coc;
            far_color_sum += colors[i] * valid;
            far_count += valid;
        }
    }
    float far_coc = far_count > 0.0 ? far_sum / far_count : far_sum;
    vec3 far_color = far_count > 0.0 ? far_color_sum * (exposure / far_count) : far_color_sum;
    imageStore(OutputTexColorFar, pixel, vec4(far_color, 0.0));
    imageStore(OutputTexCocFar, pixel, vec4(far_coc, 0.0, 0.0, 0.0));
}
