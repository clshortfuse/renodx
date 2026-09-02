#version 450

#include "../shared.h"
#include "./ui_brightness.slang"

layout(set = 0, binding = 2) uniform sampler2D tex;

layout(location = 1) in vec4 vcolor;
layout(location = 0) in vec2 tc0;
layout(location = 0) out vec4 fcolor;

void main()
{
    // Literal native Scaleform path.
    vec4 c = vcolor;
    c.w *= texture(tex, tc0).w;
    fcolor = c;

    // RGB-only adjustment after the original alpha-mask evaluation.
    if (DetroitShouldTransformUi())
    {
        fcolor.xyz = DetroitScaleUiRgb(fcolor.xyz);
    }

    fcolor = fcolor;
}
