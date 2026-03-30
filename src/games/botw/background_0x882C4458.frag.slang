#version 450

layout(set = 1, binding = 1, std140) uniform ufBlock
{
    ivec4 uf_remappedPS[2];
    vec4 uf_fragCoordScale;
} _64;

layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;

layout(location = 0) in vec4 passParameterSem0;
layout(location = 0) out vec4 passPixelColor0;

void main()
{
    vec4 sampled = texture(textureUnitPS0, passParameterSem0.xy);
    vec4 scale = intBitsToFloat(_64.uf_remappedPS[0]);
    vec4 bias = intBitsToFloat(_64.uf_remappedPS[1]);
    vec4 remapped = sampled * scale + bias;
    passPixelColor0 = vec4(remapped.xyz, saturate(remapped.w)); // saturate alpha
}

