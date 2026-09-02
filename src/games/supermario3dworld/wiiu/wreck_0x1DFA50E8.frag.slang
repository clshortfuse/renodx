// #version 450

// layout(set = 1, binding = 5, std140) uniform ufBlock
// {
//     ivec4 uf_remappedPS[2];
//     vec4 uf_fragCoordScale;
// } _133;

// layout(set = 1, binding = 4) uniform sampler2D textureUnitPS7;
// layout(set = 1, binding = 3) uniform sampler2D textureUnitPS6;
// layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;
// layout(set = 1, binding = 1) uniform sampler2D textureUnitPS3;
// layout(set = 1, binding = 2) uniform sampler2D textureUnitPS5;

// layout(location = 0) in vec4 passParameterSem0;
// layout(location = 1) in vec4 passParameterSem1;
// layout(location = 2) in vec4 passParameterSem2;
// layout(location = 0) out vec4 passPixelColor0;

// float mul_nonIEEE(float a, float b)
// {
//     return ((a != 0.0) && (b != 0.0)) ? (a * b) : 0.0;
// }

// void main()
// {
//     ivec4 R0i = ivec4(0);
//     ivec4 R1i = ivec4(0);
//     ivec4 R2i = ivec4(0);
//     ivec4 R3i = ivec4(0);
//     ivec4 R123i = ivec4(0);
//     int PV0ix = 0;
//     int PV0iy = 0;
//     int PV0iz = 0;
//     int PV0iw = 0;
//     int PV1ix = 0;
//     int PV1iy = 0;
//     int PV1iz = 0;
//     int PV1iw = 0;
//     int PS0i = 0;
//     int PS1i = 0;
//     ivec4 tempi = ivec4(0);
//     ivec4 ARi = ivec4(0);
//     bool predResult = true;
//     bool activeMaskStack[2];
//     activeMaskStack[0] = false;
//     bool activeMaskStackC[3];
//     activeMaskStackC[0] = false;
//     activeMaskStackC[1] = false;
//     activeMaskStack[0] = true;
//     activeMaskStackC[0] = true;
//     activeMaskStackC[1] = true;
//     R0i = floatBitsToInt(passParameterSem0);
//     R1i = floatBitsToInt(passParameterSem1);
//     R2i = floatBitsToInt(passParameterSem2);
//     if (activeMaskStackC[1] == true)
//     {
//         int _92 = R0i.x;
//         int _96 = R0i.y;
//         ivec2 _103 = floatBitsToInt(texture(textureUnitPS7, vec2(intBitsToFloat(_92), intBitsToFloat(_96))).xy);
//         R0i.x = _103.x;
//         R0i.y = _103.y;
//     }
//     if (activeMaskStackC[1] == true)
//     {
//         PV0iz = floatBitsToInt(intBitsToFloat(R0i.x) + (-intBitsToFloat(1056997505)));
//         PV0iw = floatBitsToInt(intBitsToFloat(R0i.y) + (-intBitsToFloat(1056997505)));
//         float param = intBitsToFloat(PV0iz);
//         float param_1 = intBitsToFloat(_133.uf_remappedPS[0].x);
//         R1i.x = floatBitsToInt(mul_nonIEEE(param, param_1) + intBitsToFloat(R1i.x));
//         float param_2 = intBitsToFloat(PV0iw);
//         float param_3 = intBitsToFloat(_133.uf_remappedPS[0].x);
//         R1i.y = floatBitsToInt(mul_nonIEEE(param_2, param_3) + intBitsToFloat(R1i.y));
//     }
//     if (activeMaskStackC[1] == true)
//     {
//         int _169 = R1i.x;
//         int _172 = R1i.y;
//         ivec2 _177 = floatBitsToInt(texture(textureUnitPS6, vec2(intBitsToFloat(_169), intBitsToFloat(_172))).xy);
//         R1i.x = _177.x;
//         R1i.y = _177.y;
//     }
//     if (activeMaskStackC[1] == true)
//     {
//         PV0iz = floatBitsToInt(intBitsToFloat(R1i.x) + (-intBitsToFloat(1056997505)));
//         PV0iw = floatBitsToInt(intBitsToFloat(R1i.y) + (-intBitsToFloat(1056997505)));
//         float param_4 = intBitsToFloat(_133.uf_remappedPS[1].w);
//         float param_5 = intBitsToFloat(PV0iz);
//         R0i.x = floatBitsToInt(mul_nonIEEE(param_4, param_5));
//         float param_6 = intBitsToFloat(_133.uf_remappedPS[1].w);
//         float param_7 = intBitsToFloat(PV0iw);
//         R0i.y = floatBitsToInt(mul_nonIEEE(param_6, param_7));
//         R1i.x = floatBitsToInt(intBitsToFloat(R2i.x) + intBitsToFloat(R0i.x));
//         R1i.y = floatBitsToInt(intBitsToFloat(R2i.y) + intBitsToFloat(R0i.y));
//         R0i.z = (intBitsToFloat(R0i.x) != 0.0) ? (-1) : 0;
//         R0i.w = (intBitsToFloat(R0i.y) != 0.0) ? (-1) : 0;
//     }
//     if (activeMaskStackC[1] == true)
//     {
//         R2i = floatBitsToInt(texture(textureUnitPS0, vec2(intBitsToFloat(R1i.x), intBitsToFloat(R1i.y))));
//     }
//     if (activeMaskStackC[1] == true)
//     {
//         activeMaskStack[1] = activeMaskStack[0];
//         activeMaskStackC[2] = activeMaskStackC[1];
//         R0i.z += R0i.w;
//         predResult = R0i.z != 0;
//         activeMaskStack[1] = predResult;
//         bool _292 = predResult == true;
//         bool _298;
//         if (_292)
//         {
//             _298 = activeMaskStackC[1] == true;
//         }
//         else
//         {
//             _298 = _292;
//         }
//         activeMaskStackC[2] = _298;
//     }
//     else
//     {
//         activeMaskStack[1] = false;
//         activeMaskStackC[2] = false;
//     }
//     if (activeMaskStackC[2] == true)
//     {
//         float param_8 = intBitsToFloat(_133.uf_remappedPS[0].y);
//         float param_9 = intBitsToFloat(R0i.x);
//         R3i.x = floatBitsToInt(mul_nonIEEE(param_8, param_9) + intBitsToFloat(R1i.x));
//         float param_10 = intBitsToFloat(_133.uf_remappedPS[0].y);
//         float param_11 = intBitsToFloat(R0i.y);
//         R3i.y = floatBitsToInt(mul_nonIEEE(param_10, param_11) + intBitsToFloat(R1i.y));
//         R0i.z = _133.uf_remappedPS[0].y;
//         R0i.z = floatBitsToInt(intBitsToFloat(R0i.z) * 2.0);
//         float param_12 = intBitsToFloat(R0i.x);
//         float param_13 = intBitsToFloat(R0i.z);
//         R0i.x = floatBitsToInt(mul_nonIEEE(param_12, param_13) + intBitsToFloat(R1i.x));
//         float param_14 = intBitsToFloat(R0i.y);
//         float param_15 = intBitsToFloat(R0i.z);
//         R0i.y = floatBitsToInt(mul_nonIEEE(param_14, param_15) + intBitsToFloat(R1i.y));
//     }
//     if (activeMaskStackC[2] == true)
//     {
//         R0i.x = floatBitsToInt(texture(textureUnitPS0, vec2(intBitsToFloat(R0i.x), intBitsToFloat(R0i.y))).x);
//         R0i.y = floatBitsToInt(texture(textureUnitPS0, vec2(intBitsToFloat(R3i.x), intBitsToFloat(R3i.y))).y);
//     }
//     if (activeMaskStackC[2] == true)
//     {
//         R2i.x = R0i.x;
//         R2i.y = R0i.y;
//     }
//     bool _420 = activeMaskStack[0] == true;
//     bool _426;
//     if (_420)
//     {
//         _426 = activeMaskStackC[0] == true;
//     }
//     else
//     {
//         _426 = _420;
//     }
//     activeMaskStackC[1] = _426;
//     if (activeMaskStackC[1] == true)
//     {
//         ivec3 _446 = floatBitsToInt(texture(textureUnitPS3, vec2(intBitsToFloat(R1i.x), intBitsToFloat(R1i.y))).xyz);
//         R0i.x = _446.x;
//         R0i.y = _446.y;
//         R0i.z = _446.z;
//         int _456 = R1i.x;
//         int _459 = R1i.y;
//         ivec3 _464 = floatBitsToInt(texture(textureUnitPS5, vec2(intBitsToFloat(_456), intBitsToFloat(_459))).xyz);
//         R1i.x = _464.x;
//         R1i.y = _464.y;
//         R1i.z = _464.z;
//     }
//     if (activeMaskStackC[1] == true)
//     {
//         float param_16 = intBitsToFloat(_133.uf_remappedPS[1].z);
//         float param_17 = intBitsToFloat(R0i.x);
//         R123i.x = floatBitsToInt(mul_nonIEEE(param_16, param_17) + intBitsToFloat(_133.uf_remappedPS[1].y));
//         float param_18 = intBitsToFloat(_133.uf_remappedPS[1].z);
//         float param_19 = intBitsToFloat(R0i.z);
//         R123i.y = floatBitsToInt(mul_nonIEEE(param_18, param_19) + intBitsToFloat(_133.uf_remappedPS[1].y));
//         float param_20 = intBitsToFloat(_133.uf_remappedPS[1].z);
//         float param_21 = intBitsToFloat(R0i.y);
//         R123i.w = floatBitsToInt(mul_nonIEEE(param_20, param_21) + intBitsToFloat(_133.uf_remappedPS[1].y));
//         R0i.w = R2i.w;
//         float param_22 = intBitsToFloat(R123i.y);
//         float param_23 = intBitsToFloat(R1i.z);
//         PV1ix = floatBitsToInt(mul_nonIEEE(param_22, param_23));
//         float param_24 = intBitsToFloat(R123i.w);
//         float param_25 = intBitsToFloat(R1i.y);
//         PV1iy = floatBitsToInt(mul_nonIEEE(param_24, param_25));
//         float param_26 = intBitsToFloat(R123i.x);
//         float param_27 = intBitsToFloat(R1i.x);
//         PV1iz = floatBitsToInt(mul_nonIEEE(param_26, param_27));
//         float param_28 = intBitsToFloat(_133.uf_remappedPS[1].x);
//         float param_29 = intBitsToFloat(R2i.x);
//         R0i.x = floatBitsToInt(mul_nonIEEE(param_28, param_29) + intBitsToFloat(PV1iz));
//         float param_30 = intBitsToFloat(_133.uf_remappedPS[1].x);
//         float param_31 = intBitsToFloat(R2i.y);
//         R0i.y = floatBitsToInt(mul_nonIEEE(param_30, param_31) + intBitsToFloat(PV1iy));
//         float param_32 = intBitsToFloat(_133.uf_remappedPS[1].x);
//         float param_33 = intBitsToFloat(R2i.z);
//         R0i.z = floatBitsToInt(mul_nonIEEE(param_32, param_33) + intBitsToFloat(PV1ix));
//     }
//     passPixelColor0 = vec4(intBitsToFloat(R0i.x), intBitsToFloat(R0i.y), intBitsToFloat(R0i.z), intBitsToFloat(R0i.w));
// }

#define WRECK
#include "./common.slang"