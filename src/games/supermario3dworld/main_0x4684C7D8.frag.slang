#version 450
#include "./shared.h"

struct _11
{
    vec4 Color;
    vec2 UV;
};

layout(set = 0, binding = 0) uniform sampler2D sTexture;

layout(location = 0) out vec4 fColor;
layout(location = 0) in _11 In;

void main()
{
    fColor = In.Color * texture(sTexture, In.UV);
    fColor = renodx::color::srgb::Decode(fColor);
}

