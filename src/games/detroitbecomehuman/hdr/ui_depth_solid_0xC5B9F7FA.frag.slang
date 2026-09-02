#version 450

#include "../shared.h"
#include "./ui_brightness.slang"

layout(set = 0, binding = 1, std140) uniform FConstants
{
    vec4 fExtra;
} constants;

layout(set = 0, binding = 2) uniform sampler2D depth;

layout(location = 0) out vec4 fcolor;
layout(location = 0) in vec4 color;
layout(location = 4) in vec4 fucxmul;
layout(location = 3) in vec4 fucxadd;
layout(location = 2) in vec4 factor;
layout(location = 1) in vec4 cpos;

void main()
{
    // Literal native depth-aware solid HUD path.
    fcolor = color;
    fcolor = clamp((fcolor * fucxmul) + fucxadd,
                   vec4(0.0), vec4(1.0));
    fcolor.w *= factor.w;
    fcolor = fcolor;
    vec3 clip_position = cpos.xyz / vec3(cpos.w);
    vec2 depth_uv = ((clip_position.xy * 0.5) + vec2(0.5)) *
                    constants.fExtra.xy;
    float depth_value = texture(depth, depth_uv).x;
    float depth_alpha = depth_value < clip_position.z
        ? 1.0
        : constants.fExtra.z;
    fcolor.w *= depth_alpha;

    if (DetroitShouldTransformUi())
    {
        fcolor.xyz = DetroitScaleUiRgb(fcolor.xyz);
    }
}
