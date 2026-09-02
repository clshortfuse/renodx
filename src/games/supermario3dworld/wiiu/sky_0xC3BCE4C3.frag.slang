#version 450

layout(set = 1, binding = 1, std140) uniform ufBlock
{
    vec4 uf_fragCoordScale;
} _67;

layout(set = 1, binding = 0) uniform sampler2DArray textureUnitPS0;

layout(location = 0) noperspective in vec4 passParameterSem1;
layout(location = 0) out vec4 passPixelColor0;

void main()
{
    vec4 R0f = texture(textureUnitPS0, vec3(passParameterSem1.x, passParameterSem1.y, 0.0));
    R0f.xyz = saturate(R0f.xyz);
    passPixelColor0 = vec4(R0f.x, R0f.y, R0f.z, R0f.w);
}

