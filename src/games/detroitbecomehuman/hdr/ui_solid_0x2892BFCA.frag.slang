#version 450

#include "../shared.h"
#include "./ui_brightness.slang"

layout(location = 0) out vec4 fcolor;
layout(location = 0) in vec4 color;
layout(location = 3) in vec4 fucxmul;
layout(location = 2) in vec4 fucxadd;
layout(location = 1) in vec4 factor;

void main()
{
    // Literal native Scaleform path.
    fcolor = color;
    fcolor = clamp((fcolor * fucxmul) + fucxadd, vec4(0.0), vec4(1.0));
    fcolor.w *= factor.w;

    // RGB-only adjustment after the original color transform and clamp.
    if (DetroitShouldTransformUi())
    {
        fcolor.xyz = DetroitScaleUiRgb(fcolor.xyz);
    }

    fcolor = fcolor;
}
