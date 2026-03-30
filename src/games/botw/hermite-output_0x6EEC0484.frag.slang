#define USE_SETTINGS_PUSHCONSTANTS

#version 450
#include "./shared.h"

layout(push_constant, std430) uniform pc
{
    vec2 textureSrcResolution;
    vec2 nativeResolution;
    vec2 outputResolution;
} _372;

layout(set = 0, binding = 0) uniform sampler2D textureSrc;

layout(location = 0) out vec4 colorOut0;
layout(location = 0) in vec2 passUV;

vec3 CubicHermite(vec3 A, vec3 B, vec3 C, vec3 D, float t)
{
    float t2 = t * t;
    float t3 = (t * t) * t;
    vec3 a = ((((-A) / vec3(2.0)) + ((B * 3.0) / vec3(2.0))) - ((C * 3.0) / vec3(2.0))) + (D / vec3(2.0));
    vec3 b = ((A - ((B * 5.0) / vec3(2.0))) + (C * 2.0)) - (D / vec3(2.0));
    vec3 c = ((-A) / vec3(2.0)) + (C / vec3(2.0));
    vec3 d = B;
    return (((a * t3) + (b * t2)) + (c * t)) + d;
}

vec3 BicubicHermiteTexture(vec2 uv, vec4 texelSize)
{
    vec2 pixel = (uv * texelSize.zw) + vec2(0.5);
    vec2 frac = fract(pixel);
    pixel = (floor(pixel) / texelSize.zw) - vec2(texelSize.xy / vec2(2.0));
    vec4 doubleSize = texelSize * 2.0;
    vec3 C00 = texture(textureSrc, pixel + vec2(-texelSize.x, -texelSize.y)).xyz;
    vec3 C10 = texture(textureSrc, pixel + vec2(0.0, -texelSize.y)).xyz;
    vec3 C20 = texture(textureSrc, pixel + vec2(texelSize.x, -texelSize.y)).xyz;
    vec3 C30 = texture(textureSrc, pixel + vec2(doubleSize.x, -texelSize.y)).xyz;
    vec3 C01 = texture(textureSrc, pixel + vec2(-texelSize.x, 0.0)).xyz;
    vec3 C11 = texture(textureSrc, pixel + vec2(0.0)).xyz;
    vec3 C21 = texture(textureSrc, pixel + vec2(texelSize.x, 0.0)).xyz;
    vec3 C31 = texture(textureSrc, pixel + vec2(doubleSize.x, 0.0)).xyz;
    vec3 C02 = texture(textureSrc, pixel + vec2(-texelSize.x, texelSize.y)).xyz;
    vec3 C12 = texture(textureSrc, pixel + vec2(0.0, texelSize.y)).xyz;
    vec3 C22 = texture(textureSrc, pixel + vec2(texelSize.x, texelSize.y)).xyz;
    vec3 C32 = texture(textureSrc, pixel + vec2(doubleSize.x, texelSize.y)).xyz;
    vec3 C03 = texture(textureSrc, pixel + vec2(-texelSize.x, doubleSize.y)).xyz;
    vec3 C13 = texture(textureSrc, pixel + vec2(0.0, doubleSize.y)).xyz;
    vec3 C23 = texture(textureSrc, pixel + vec2(texelSize.x, doubleSize.y)).xyz;
    vec3 C33 = texture(textureSrc, pixel + vec2(doubleSize.x, doubleSize.y)).xyz;
    vec3 param = C00;
    vec3 param_1 = C10;
    vec3 param_2 = C20;
    vec3 param_3 = C30;
    float param_4 = frac.x;
    vec3 CP0X = CubicHermite(param, param_1, param_2, param_3, param_4);
    vec3 param_5 = C01;
    vec3 param_6 = C11;
    vec3 param_7 = C21;
    vec3 param_8 = C31;
    float param_9 = frac.x;
    vec3 CP1X = CubicHermite(param_5, param_6, param_7, param_8, param_9);
    vec3 param_10 = C02;
    vec3 param_11 = C12;
    vec3 param_12 = C22;
    vec3 param_13 = C32;
    float param_14 = frac.x;
    vec3 CP2X = CubicHermite(param_10, param_11, param_12, param_13, param_14);
    vec3 param_15 = C03;
    vec3 param_16 = C13;
    vec3 param_17 = C23;
    vec3 param_18 = C33;
    float param_19 = frac.x;
    vec3 CP3X = CubicHermite(param_15, param_16, param_17, param_18, param_19);
    vec3 param_20 = CP0X;
    vec3 param_21 = CP1X;
    vec3 param_22 = CP2X;
    vec3 param_23 = CP3X;
    float param_24 = frac.y;
    return CubicHermite(param_20, param_21, param_22, param_23, param_24);
}

void main()
{
    vec4 texelSize = vec4(vec2(1.0) / _372.textureSrcResolution, _372.textureSrcResolution);
    vec2 param = passUV;
    vec4 param_1 = texelSize;
    colorOut0 = vec4(BicubicHermiteTexture(param, param_1), 1.0);
    colorOut0 = renodx::draw::SwapChainPass(colorOut0);
}

