#version 450
#include "./shared.h"

layout(set = 1, binding = 2, std140) uniform ufBlock
{
    ivec4 uf_remappedPS[1];
    vec4 uf_fragCoordScale;
} _63;

layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;
layout(set = 1, binding = 1) uniform sampler3D textureUnitPS1;

layout(location = 0) in vec4 passParameterSem0;
layout(location = 0) out vec4 passPixelColor0;

void main()
{
    vec4 R0f = vec4(0.0);
    vec4 R1f = vec4(0.0);
    vec4 R5f = vec4(0.0);
    vec4 R127f = vec4(0.0);
    vec4 PV0f = vec4(0.0);
    vec4 PV1f = vec4(0.0);
    float PS0f = 0.0;
    float PS1f = 0.0;
    vec4 tempf = vec4(0.0);
    ivec4 ARi = ivec4(0);
    bool predResult = true;
    R0f = passParameterSem0;
    vec4 _40 = R0f;
    vec3 _44 = texture(textureUnitPS0, _40.xy).xyz;
    R0f.x = _44.x;
    R0f.y = _44.y;
    R0f.z = _44.z;
    R5f = texture(textureUnitPS0, passParameterSem0.xy);
    float tempResultf = clamp(intBitsToFloat(_63.uf_remappedPS[0].x), 0.0, 1.0);
    float tempResultf2 = clamp(intBitsToFloat(_63.uf_remappedPS[0].z), 0.0, 1.0);
    R127f.x = R0f.z * tempResultf;
    R127f.x = clamp(R127f.x, 0.0, 1.0);
    R127f.y = R0f.y * tempResultf;
    R127f.y = clamp(R127f.y, 0.0, 1.0);
    PV0f.z = R0f.x * tempResultf;
    PV0f.z = clamp(PV0f.z, 0.0, 1.0);
    R1f.w = 1.0;
    tempResultf = max(0.0, PV0f.z);
    tempResultf = log2(tempResultf);
    if (isinf(tempResultf) == true)
    {
        tempResultf = -3.4028234663852885981170418348452e+38;
    }
    PS1f = tempResultf;
    R127f.z = PS1f * intBitsToFloat(1055439406);
    tempResultf = max(0.0, R127f.y);
    tempResultf = log2(tempResultf);
    if (isinf(tempResultf) == true)
    {
        tempResultf = -3.4028234663852885981170418348452e+38;
    }
    PS0f = tempResultf;
    R127f.w = PS0f * intBitsToFloat(1055439406);
    tempResultf = max(0.0, R127f.x);
    tempResultf = log2(tempResultf);
    if (isinf(tempResultf) == true)
    {
        tempResultf = -3.4028234663852885981170418348452e+38;
    }
    PS1f = tempResultf;
    R127f.x = PS1f * intBitsToFloat(1055439406);
    PS0f = exp2(R127f.z);
    R0f.x = (PS0f * tempResultf2) + intBitsToFloat(_63.uf_remappedPS[0].w);
    PS1f = exp2(R127f.w);
    R0f.y = (PS1f * intBitsToFloat(_63.uf_remappedPS[0].z)) + intBitsToFloat(_63.uf_remappedPS[0].w);
    PS0f = exp2(R127f.x);
    R0f.z = (PS0f * intBitsToFloat(_63.uf_remappedPS[0].z)) + intBitsToFloat(_63.uf_remappedPS[0].w);
    vec4 _188 = R0f;
    vec3 _192 = clamp(_188.xyz, vec3(0.0), vec3(1.0));
    R0f.x = _192.x;
    R0f.y = _192.y;
    R0f.z = _192.z;
    vec3 _212 = texture(textureUnitPS1, vec3(R0f.x, R0f.y, R0f.z)).xyz;
    R1f.x = _212.x;
    R1f.y = _212.y;
    R1f.z = _212.z;
    R5f = mix(R1f, R5f, vec4(0.0)) * 1.0;
    vec4 _224 = R5f;
    vec4 _226 = R5f;
    vec3 _232 = mix(_224.xyz, smoothstep(vec3(0.0), vec3(1.0), _226.xyz), vec3(0.0));
    R5f.x = _232.x;
    R5f.y = _232.y; 
    R5f.z = _232.z;
    passPixelColor0 = vec4(R5f.x, R5f.y, R5f.z, R5f.w);

    passPixelColor0.xyz = _44;
        //passPixelColor0 = renodx::color::srgb::DecodeSafe(passPixelColor0);
    passPixelColor0 = renodx::draw::RenderIntermediatePass(passPixelColor0);
    
}

