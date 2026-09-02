#version 450

#include "../shared.h"
#include "./ui_brightness.slang"

layout(set = 0, binding = 1, std140) uniform FConstants
{
    vec4 fsize;
    vec4 offset;
    vec4 scolor;
    vec4 srctexscale;
    vec4 texscale;
} constants;

layout(set = 0, binding = 3) uniform sampler2D tex;
layout(set = 0, binding = 2) uniform sampler2D srctex;

layout(location = 0) out vec4 fcolor;
layout(location = 2) in vec2 tc0;
layout(location = 1) in vec4 fucxmul;
layout(location = 0) in vec4 fucxadd;

void main()
{
    // Literal native Scaleform shadow/composite path. Its offscreen source is
    // deliberately left in BT.709 by the target-aware replacement callback.
    fcolor = vec4(0.0);
    vec4 color = vec4(0.0);
    for (float ix = -constants.fsize.x;
         ix <= constants.fsize.x;
         ix += 1.0)
    {
        for (float iy = -constants.fsize.y;
             iy <= constants.fsize.y;
             iy += 1.0)
        {
            vec2 i = vec2(ix, iy);
            color += texture(
                tex,
                tc0 + ((constants.offset.xy + i) *
                       constants.texscale.xy));
        }
    }
    fcolor = color * constants.fsize.w;
    vec4 shadow_color = constants.scolor;
    vec4 shadow_color_2 = vec4(0.0);
    fcolor.w *= constants.fsize.z;
    fcolor.x = 0.0;
    vec4 base = texture(srctex, tc0 * constants.srctexscale.xy);
    vec4 base_value = base;
    vec2 alphas = vec2(shadow_color.w, shadow_color_2.w);
    vec2 masks = clamp(fcolor.wx, vec2(0.0), vec2(1.0)) * alphas;
    fcolor = vec4(masks.y, fcolor.y, fcolor.z, masks.x);
    fcolor = (((shadow_color * fcolor.w) +
               (shadow_color_2 * fcolor.x)) *
              (1.0 - base.w)) + base_value;
    fcolor = (fcolor * vec4(fucxmul.xyz, 1.0)) * fucxmul.w;
    fcolor += fucxadd * fcolor.w;
    fcolor = clamp(fcolor, vec4(0.0), vec4(1.0));

    if (DetroitShouldTransformUi())
    {
        // This pass blends with ONE / ONE_MINUS_SRC_ALPHA, so its RGB is
        // premultiplied. Perform nonlinear brightness/primaries work on
        // straight color, then restore premultiplication without touching A.
        float alpha = fcolor.w;
        vec3 straight_rgb = alpha > 1.0e-6
            ? fcolor.xyz / alpha
            : vec3(0.0);
        fcolor.xyz = DetroitScaleUiRgb(straight_rgb) * alpha;
    }

    fcolor = fcolor;
}
