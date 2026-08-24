#version 450

layout(set = 1, binding = 2, std140) uniform ufBlock {
  ivec4 uf_remappedPS[3];
  vec4 uf_fragCoordScale;
}
_113;

layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;
layout(set = 1, binding = 1) uniform sampler2D textureUnitPS1;

layout(location = 0) in vec4 passParameterSem0;
layout(location = 1) in vec4 passParameterSem1;
layout(location = 2) in vec4 passParameterSem2;
layout(location = 0) out vec4 passPixelColor0;

float mul_nonIEEE(float a, float b) {
  return ((a != 0.0) && (b != 0.0)) ? (a * b) : 0.0;
}

void main() {
  ivec4 R0i = ivec4(0);
  ivec4 R1i = ivec4(0);
  ivec4 R2i = ivec4(0);
  ivec4 R122i = ivec4(0);
  ivec4 R123i = ivec4(0);
  ivec4 R127i = ivec4(0);
  int PV0ix = 0;
  int PV0iy = 0;
  int PV0iz = 0;
  int PV0iw = 0;
  int PV1ix = 0;
  int PV1iy = 0;
  int PV1iz = 0;
  int PV1iw = 0;
  int PS0i = 0;
  int PS1i = 0;
  ivec4 tempi = ivec4(0);
  ivec4 ARi = ivec4(0);
  bool predResult = true;
  R0i = floatBitsToInt(passParameterSem0);
  R1i = floatBitsToInt(passParameterSem1);
  R2i = floatBitsToInt(passParameterSem2);
  R1i = floatBitsToInt(texture(textureUnitPS0, vec2(intBitsToFloat(R1i.x), intBitsToFloat(R1i.y))));
  R2i = floatBitsToInt(texture(textureUnitPS1, vec2(intBitsToFloat(R2i.x), intBitsToFloat(R2i.y))));
  PV0ix = floatBitsToInt(max(intBitsToFloat(R1i.w), intBitsToFloat(R2i.w)));
  PV0iy = floatBitsToInt(min(intBitsToFloat(R1i.w), intBitsToFloat(R2i.w)));
  PV0iz = _113.uf_remappedPS[0].x & 128;
  float param = intBitsToFloat(R2i.x);
  float param_1 = intBitsToFloat(R2i.w);
  R123i.w = floatBitsToInt(mul_nonIEEE(param, param_1) + intBitsToFloat(R1i.x));
  float param_2 = intBitsToFloat(R2i.y);
  float param_3 = intBitsToFloat(R2i.w);
  R122i.x = floatBitsToInt(mul_nonIEEE(param_2, param_3) + intBitsToFloat(R1i.y));
  R123i.x = (PV0iz == 0) ? PV0ix : PV0iy;
  float param_4 = intBitsToFloat(R123i.w);
  float param_5 = intBitsToFloat(_113.uf_remappedPS[1].x);
  R123i.y = floatBitsToInt(mul_nonIEEE(param_4, param_5) + intBitsToFloat(_113.uf_remappedPS[2].x));
  float param_6 = intBitsToFloat(R122i.x);
  float param_7 = intBitsToFloat(_113.uf_remappedPS[1].y);
  R127i.z = floatBitsToInt(mul_nonIEEE(param_6, param_7) + intBitsToFloat(_113.uf_remappedPS[2].y));
  float param_8 = intBitsToFloat(R2i.z);
  float param_9 = intBitsToFloat(R2i.w);
  R123i.w = floatBitsToInt(mul_nonIEEE(param_8, param_9) + intBitsToFloat(R1i.z));
  int backupReg0i = R123i.y;
  float param_10 = intBitsToFloat(R123i.x);
  float param_11 = intBitsToFloat(_113.uf_remappedPS[1].w);
  R123i.x = floatBitsToInt(mul_nonIEEE(param_10, param_11) + intBitsToFloat(_113.uf_remappedPS[2].w));
  float param_12 = intBitsToFloat(R123i.w);
  float param_13 = intBitsToFloat(_113.uf_remappedPS[1].z);
  R123i.y = floatBitsToInt(mul_nonIEEE(param_12, param_13) + intBitsToFloat(_113.uf_remappedPS[2].z));
  float param_14 = intBitsToFloat(R0i.x);
  float param_15 = intBitsToFloat(backupReg0i);
  R1i.x = floatBitsToInt(mul_nonIEEE(param_14, param_15));
  float param_16 = intBitsToFloat(R0i.y);
  float param_17 = intBitsToFloat(R127i.z);
  R1i.y = floatBitsToInt(mul_nonIEEE(param_16, param_17));
  float param_18 = intBitsToFloat(R0i.z);
  float param_19 = intBitsToFloat(R123i.y);
  R1i.z = floatBitsToInt(mul_nonIEEE(param_18, param_19));
  float param_20 = intBitsToFloat(R0i.w);
  float param_21 = intBitsToFloat(R123i.x);
  R1i.w = floatBitsToInt(mul_nonIEEE(param_20, param_21));
  passPixelColor0 = vec4(intBitsToFloat(R1i.x), intBitsToFloat(R1i.y), intBitsToFloat(R1i.z), saturate(intBitsToFloat(R1i.w)));  // saturate alpha
}

