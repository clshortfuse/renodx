#version 450
#include "./shared.h"
#define USE_SETTINGS_PUSHCONSTANTS

layout(set = 1, binding = 2, std140) uniform ufBlock
{
    ivec4 uf_remappedPS[1];
    vec4 uf_fragCoordScale;
} _82;

layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;
layout(set = 1, binding = 1) uniform sampler3D textureUnitPS1;

layout(location = 0) in vec4 passParameterSem0;
layout(location = 0) out vec4 passPixelColor0;

void main()
{
    float scale = intBitsToFloat(_82.uf_remappedPS[0].x);
    float lutScale = intBitsToFloat(_82.uf_remappedPS[0].z);
    float lutBias = intBitsToFloat(_82.uf_remappedPS[0].w);

    vec3 raw = texture(textureUnitPS0, passParameterSem0.xy).xyz;
    float hdrScale = renodx::tonemap::neutwo::ComputeMaxChannelScale(raw);
    raw *= hdrScale;
    vec3 scaled = raw * scale;
    vec3 clamped = clamp(scaled, 0.0, 1.0);
    
    vec3 encoded = pow(clamped, 1/2.2);

    vec3 lutUv = encoded * lutScale + lutBias;

    vec3 color = texture(textureUnitPS1, lutUv).xyz;
    color /= hdrScale;
    passPixelColor0 = vec4(color, 1.0);
    //passPixelColor0 = renodx::color::srgb::EncodeSafe(passPixelColor0);
    //passPixelColor0 = renodx::draw::RenderIntermediatePass(passPixelColor0);

}

