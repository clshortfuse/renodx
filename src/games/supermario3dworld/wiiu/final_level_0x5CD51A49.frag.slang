// #version 450

// layout(set = 1, binding = 3, std140) uniform ufBlock
// {
//     ivec4 uf_remappedPS[1];
//     vec4 uf_fragCoordScale;
// } _106;

// layout(set = 1, binding = 1) uniform sampler2D textureUnitPS3;
// layout(set = 1, binding = 2) uniform sampler2D textureUnitPS5;
// layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;

// layout(location = 0) in vec4 passParameterSem0;
// layout(location = 0) out vec4 passPixelColor0;

// float mul_nonIEEE(float a, float b)
// {
//     return ((a != 0.0) && (b != 0.0)) ? (a * b) : 0.0;
// }

// void main()
// {
//     vec4 R0f = vec4(0.0);
//     vec4 R1f = vec4(0.0);
//     vec4 R2f = vec4(0.0);
//     vec4 R123f = vec4(0.0);
//     float PV0fx = 0.0;
//     float PV0fy = 0.0;
//     float PV0fz = 0.0;
//     float PV0fw = 0.0;
//     float PV1fx = 0.0;
//     float PV1fy = 0.0;
//     float PV1fz = 0.0;
//     float PV1fw = 0.0;
//     float PS0f = 0.0;
//     float PS1f = 0.0;
//     vec4 tempf = vec4(0.0);
//     ivec4 ARi = ivec4(0);
//     bool predResult = true;
//     R0f = passParameterSem0;
//     vec3 _72 = texture(textureUnitPS3, vec2(R0f.x, R0f.y)).xyz;
//     R1f.x = _72.x;
//     R1f.y = _72.y;
//     R1f.z = _72.z;
//     vec3 _88 = texture(textureUnitPS5, vec2(R0f.x, R0f.y)).xyz;
//     R2f.x = _88.x;
//     R2f.y = _88.y;
//     R2f.z = _88.z;
//     R0f = texture(textureUnitPS0, vec2(R0f.x, R0f.y));
//     float param = intBitsToFloat(_106.uf_remappedPS[0].z);
//     float param_1 = R1f.x;
//     R123f.x = mul_nonIEEE(param, param_1) + intBitsToFloat(_106.uf_remappedPS[0].y);
//     float param_2 = intBitsToFloat(_106.uf_remappedPS[0].z);
//     float param_3 = R1f.z;
//     R123f.y = mul_nonIEEE(param_2, param_3) + intBitsToFloat(_106.uf_remappedPS[0].y);
//     float param_4 = intBitsToFloat(_106.uf_remappedPS[0].z);
//     float param_5 = R1f.y;
//     R123f.w = mul_nonIEEE(param_4, param_5) + intBitsToFloat(_106.uf_remappedPS[0].y);
//     R1f.w = R0f.w;
//     float param_6 = R123f.y;
//     float param_7 = R2f.z;
//     PV1fx = mul_nonIEEE(param_6, param_7);
//     float param_8 = R123f.w;
//     float param_9 = R2f.y;
//     PV1fy = mul_nonIEEE(param_8, param_9);
//     float param_10 = R123f.x;
//     float param_11 = R2f.x;
//     PV1fz = mul_nonIEEE(param_10, param_11);
//     float param_12 = intBitsToFloat(_106.uf_remappedPS[0].x);
//     float param_13 = R0f.x;
//     R1f.x = mul_nonIEEE(param_12, param_13) + PV1fz;
//     float param_14 = intBitsToFloat(_106.uf_remappedPS[0].x);
//     float param_15 = R0f.y;
//     R1f.y = mul_nonIEEE(param_14, param_15) + PV1fy;
//     float param_16 = intBitsToFloat(_106.uf_remappedPS[0].x);
//     float param_17 = R0f.z;
//     R1f.z = mul_nonIEEE(param_16, param_17) + PV1fx;
//     passPixelColor0 = vec4(R1f.x, R1f.y, R1f.z, R1f.w);
// }

#define FINAL_LEVEL
#include "./common.slang"