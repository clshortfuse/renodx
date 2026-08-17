#version 450
#include "./shared.h"

layout(set = 1, binding = 1, std140) uniform ufBlock
{
    vec4 uf_fragCoordScale;
} _312;

layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;

layout(location = 0) in vec4 passParameterSem0;
layout(location = 1) in vec4 passParameterSem1;
layout(location = 2) in vec4 passParameterSem2;
layout(location = 0) out vec4 passPixelColor0;

void main()
{
    vec4 R0f = vec4(0.0);
    vec4 R1f = vec4(0.0);
    vec4 R2f = vec4(0.0);
    vec4 R3f = vec4(0.0);
    vec4 R4f = vec4(0.0);
    vec4 R5f = vec4(0.0);
    vec4 R6f = vec4(0.0);
    vec4 R123f = vec4(0.0);
    float PV0fx = 0.0;
    float PV0fy = 0.0;
    float PV0fz = 0.0;
    float PV0fw = 0.0;
    float PV1fx = 0.0;
    float PV1fy = 0.0;
    float PV1fz = 0.0;
    float PV1fw = 0.0;
    float PS0f = 0.0;
    float PS1f = 0.0;
    vec4 tempf = vec4(0.0);
    ivec4 ARi = ivec4(0);
    bool predResult = true;
    R0f = passParameterSem0;
    R1f = passParameterSem1;
    R2f = passParameterSem2;
    R3f = texture(textureUnitPS0, vec2(R2f.x, R2f.y));
    R4f = texture(textureUnitPS0, vec2(R1f.x, R1f.y));
    R5f = texture(textureUnitPS0, vec2(R0f.x, R0f.y));
    R6f = texture(textureUnitPS0, vec2(R0f.x, R0f.w));
    R0f = texture(textureUnitPS0, vec2(R0f.x, R0f.z));
    R1f = texture(textureUnitPS0, vec2(R1f.x, R1f.z));
    R2f = texture(textureUnitPS0, vec2(R2f.x, R2f.z));
    R123f.x = (R3f.w * 0.003173828125) + 0.0;
    R123f.y = (R3f.z * 0.003173828125) + 0.0;
    R123f.z = (R3f.y * 0.003173828125) + 0.0;
    R123f.w = (R3f.x * 0.003173828125) + 0.0;
    R123f.x = (R4f.w * 0.06982421875) + R123f.x;
    R123f.y = (R4f.z * 0.06982421875) + R123f.y;
    R123f.z = (R4f.y * 0.06982421875) + R123f.z;
    R123f.w = (R4f.x * 0.06982421875) + R123f.w;
    R123f.x = (R5f.w * 0.314208984375) + R123f.x;
    R123f.y = (R5f.z * 0.314208984375) + R123f.y;
    R123f.z = (R5f.y * 0.314208984375) + R123f.z;
    R123f.w = (R5f.x * 0.314208984375) + R123f.w;
    R123f.x = (R6f.w * 0.2255859375) + R123f.x;
    R123f.y = (R6f.z * 0.2255859375) + R123f.y;
    R123f.z = (R6f.y * 0.2255859375) + R123f.z;
    R123f.w = (R6f.x * 0.2255859375) + R123f.w;
    R123f.x = (R0f.w * 0.314208984375) + R123f.x;
    R123f.y = (R0f.z * 0.314208984375) + R123f.y;
    R123f.z = (R0f.y * 0.314208984375) + R123f.z;
    R123f.w = (R0f.x * 0.314208984375) + R123f.w;
    R123f.x = (R1f.w * 0.06982421875) + R123f.x;
    R123f.y = (R1f.z * 0.06982421875) + R123f.y;
    R123f.z = (R1f.y * 0.06982421875) + R123f.z;
    R123f.w = (R1f.x * 0.06982421875) + R123f.w;
    R2f.x = (R2f.x * 0.003173828125) + R123f.w;
    R2f.y = (R2f.y * 0.003173828125) + R123f.z;
    R2f.z = (R2f.z * 0.003173828125) + R123f.y;
    R2f.w = (R2f.w * 0.003173828125) + R123f.x;
    passPixelColor0 = vec4(R2f.x, R2f.y, R2f.z, R2f.w) * CUSTOM_BLOOM;
}

