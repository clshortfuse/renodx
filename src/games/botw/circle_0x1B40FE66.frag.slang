#version 450

layout(set = 1, binding = 2, std140) uniform ufBlock {
  ivec4 uf_remappedPS[3];
  vec4 uf_fragCoordScale;
}
_108;

layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;
layout(set = 1, binding = 1) uniform sampler2D textureUnitPS1;

layout(location = 0) in vec4 passParameterSem0;
layout(location = 1) in vec4 passParameterSem1;
layout(location = 0) out vec4 passPixelColor0;

float mul_nonIEEE(float a, float b) {
  return ((a != 0.0) && (b != 0.0)) ? (a * b) : 0.0;
}

void main() {
  ivec4 R0i = ivec4(0);
  ivec4 R1i = ivec4(0);
  ivec4 R122i = ivec4(0);
  ivec4 R123i = ivec4(0);
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
  R0i = floatBitsToInt(texture(textureUnitPS0, vec2(intBitsToFloat(R0i.x), intBitsToFloat(R0i.y))));
  R1i = floatBitsToInt(texture(textureUnitPS1, vec2(intBitsToFloat(R1i.x), intBitsToFloat(R1i.y))));
  PV0ix = floatBitsToInt(max(intBitsToFloat(R0i.w), intBitsToFloat(R1i.w)));
  PV0iy = floatBitsToInt(min(intBitsToFloat(R0i.w), intBitsToFloat(R1i.w)));
  PV0iz = _108.uf_remappedPS[0].x & 128;
  float param = intBitsToFloat(R1i.x);
  float param_1 = intBitsToFloat(R1i.w);
  R123i.w = floatBitsToInt(mul_nonIEEE(param, param_1) + intBitsToFloat(R0i.x));
  float param_2 = intBitsToFloat(R1i.y);
  float param_3 = intBitsToFloat(R1i.w);
  R122i.x = floatBitsToInt(mul_nonIEEE(param_2, param_3) + intBitsToFloat(R0i.y));
  int backupReg0i = R123i.w;
  R123i.x = (PV0iz == 0) ? PV0ix : PV0iy;
  float param_4 = intBitsToFloat(R122i.x);
  float param_5 = intBitsToFloat(_108.uf_remappedPS[1].y);
  R0i.y = floatBitsToInt(mul_nonIEEE(param_4, param_5) + intBitsToFloat(_108.uf_remappedPS[2].y));
  float param_6 = intBitsToFloat(R1i.z);
  float param_7 = intBitsToFloat(R1i.w);
  R123i.w = floatBitsToInt(mul_nonIEEE(param_6, param_7) + intBitsToFloat(R0i.z));
  float param_8 = intBitsToFloat(backupReg0i);
  float param_9 = intBitsToFloat(_108.uf_remappedPS[1].x);
  R0i.x = floatBitsToInt(mul_nonIEEE(param_8, param_9) + intBitsToFloat(_108.uf_remappedPS[2].x));
  float param_10 = intBitsToFloat(R123i.w);
  float param_11 = intBitsToFloat(_108.uf_remappedPS[1].z);
  R0i.z = floatBitsToInt(mul_nonIEEE(param_10, param_11) + intBitsToFloat(_108.uf_remappedPS[2].z));
  float param_12 = intBitsToFloat(R123i.x);
  float param_13 = intBitsToFloat(_108.uf_remappedPS[1].w);
  R0i.w = floatBitsToInt(mul_nonIEEE(param_12, param_13) + intBitsToFloat(_108.uf_remappedPS[2].w));
  passPixelColor0 = vec4(intBitsToFloat(R0i.x), intBitsToFloat(R0i.y), intBitsToFloat(R0i.z), saturate(intBitsToFloat(R0i.w)));  // saturate alpha
}

