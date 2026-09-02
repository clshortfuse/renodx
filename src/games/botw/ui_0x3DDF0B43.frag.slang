#version 450

layout(set = 1, binding = 1, std140) uniform ufBlock {
  ivec4 uf_remappedPS[2];
  vec4 uf_fragCoordScale;
}
_77;

layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;

layout(location = 0) in vec4 passParameterSem0;
layout(location = 1) in vec4 passParameterSem1;
layout(location = 0) out vec4 passPixelColor0;

float mul_nonIEEE(float a, float b) {
  return ((a != 0.0) && (b != 0.0)) ? (a * b) : 0.0;
}

void main() {
  vec4 R0f = vec4(0.0);
  vec4 R1f = vec4(0.0);
  vec4 R123f = vec4(0.0);
  vec4 R127f = vec4(0.0);
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
  R1f = texture(textureUnitPS0, vec2(R1f.x, R1f.y));
  float param = R1f.y;
  float param_1 = intBitsToFloat(_77.uf_remappedPS[0].y);
  R127f.z = mul_nonIEEE(param, param_1) + intBitsToFloat(_77.uf_remappedPS[1].y);
  float param_2 = R1f.x;
  float param_3 = intBitsToFloat(_77.uf_remappedPS[0].x);
  R123f.w = mul_nonIEEE(param_2, param_3) + intBitsToFloat(_77.uf_remappedPS[1].x);
  float param_4 = R1f.w;
  float param_5 = intBitsToFloat(_77.uf_remappedPS[0].w);
  R123f.x = mul_nonIEEE(param_4, param_5) + intBitsToFloat(_77.uf_remappedPS[1].w);
  float param_6 = R1f.z;
  float param_7 = intBitsToFloat(_77.uf_remappedPS[0].z);
  R123f.y = mul_nonIEEE(param_6, param_7) + intBitsToFloat(_77.uf_remappedPS[1].z);
  float param_8 = R0f.x;
  float param_9 = R123f.w;
  R1f.x = mul_nonIEEE(param_8, param_9);
  float param_10 = R0f.y;
  float param_11 = R127f.z;
  R1f.y = mul_nonIEEE(param_10, param_11);
  float param_12 = R0f.z;
  float param_13 = R123f.y;
  R1f.z = mul_nonIEEE(param_12, param_13);
  float param_14 = R0f.w;
  float param_15 = R123f.x;
  R1f.w = mul_nonIEEE(param_14, param_15);
  passPixelColor0 = vec4(R1f.x, R1f.y, R1f.z, saturate(R1f.w));  // saturate alpha
  passPixelColor0 = max(0, passPixelColor0);
}

