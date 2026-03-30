#define USE_SETTINGS_PUSHCONSTANTS

#include "./shared.h"
#version 450

layout(push_constant, std430) uniform pc
{
    vec2 textureSrcResolution;
    vec2 nativeResolution;
    vec2 outputResolution;
} _234;

layout(set = 0, binding = 0) uniform sampler2D textureSrc;

layout(location = 0) out vec4 colorOut0;
layout(location = 0) in vec2 passUV;

vec4 cubic(float x)
{
    float x2 = x * x;
    float x3 = x2 * x;
    vec4 w;
    w.x = (((-x3) + (3.0 * x2)) - (3.0 * x)) + 1.0;
    w.y = ((3.0 * x3) - (6.0 * x2)) + 4.0;
    w.z = ((((-3.0) * x3) + (3.0 * x2)) + (3.0 * x)) + 1.0;
    w.w = x3;
    return w / vec4(6.0);
}

vec4 bcFilter(vec2 uv, vec4 texelSize)
{
    vec2 pixel = (uv * texelSize.zw) - vec2(0.5);
    vec2 pixelFrac = fract(pixel);
    vec2 pixelInt = pixel - pixelFrac;
    float param = pixelFrac.x;
    vec4 xcubic = cubic(param);
    float param_1 = pixelFrac.y;
    vec4 ycubic = cubic(param_1);
    vec4 c = vec4(pixelInt.x - 0.5, pixelInt.x + 1.5, pixelInt.y - 0.5, pixelInt.y + 1.5);
    vec4 s = vec4(xcubic.x + xcubic.y, xcubic.z + xcubic.w, ycubic.x + ycubic.y, ycubic.z + ycubic.w);
    vec4 offset = c + (vec4(xcubic.y, xcubic.w, ycubic.y, ycubic.w) / s);
    vec4 sample0 = texture(textureSrc, vec2(offset.x, offset.z) * texelSize.xy);
    vec4 sample1 = texture(textureSrc, vec2(offset.y, offset.z) * texelSize.xy);
    vec4 sample2 = texture(textureSrc, vec2(offset.x, offset.w) * texelSize.xy);
    vec4 sample3 = texture(textureSrc, vec2(offset.y, offset.w) * texelSize.xy);
    float sx = s.x / (s.x + s.y);
    float sy = s.z / (s.z + s.w);
    return mix(mix(sample3, sample2, vec4(sx)), mix(sample1, sample0, vec4(sx)), vec4(sy));
}

void main()
{
    vec4 texelSize = vec4(vec2(1.0) / _234.textureSrcResolution, _234.textureSrcResolution);
    vec2 param = passUV;
    vec4 param_1 = texelSize;
    colorOut0 = renodx::draw::SwapChainPass(vec4(bcFilter(param, param_1).xyz, 1.0));
}

