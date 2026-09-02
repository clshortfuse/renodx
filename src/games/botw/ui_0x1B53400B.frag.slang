#version 430

layout(set = 1, binding = 1, std140) uniform ufBlock {
  ivec4 uf_remappedPS[2];
  vec4 uf_fragCoordScale;
}
_73;

layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;

layout(location = 0) in vec4 passParameterSem0;
layout(location = 0) out vec4 passPixelColor0;

float mul_nonIEEE(float a, float b) {
  return ((a != 0.0) && (b != 0.0)) ? (a * b) : 0.0;
}

void main() {
  vec4 R0f = vec4(0.0);
  vec4 R1f = vec4(0.0);
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
  R0f = texture(textureUnitPS0, vec2(R0f.x, R0f.y));
  float param = R0f.x;
  float param_1 = intBitsToFloat(_73.uf_remappedPS[0].x);
  R1f.x = mul_nonIEEE(param, param_1) + intBitsToFloat(_73.uf_remappedPS[1].x);
  float param_2 = R0f.y;
  float param_3 = intBitsToFloat(_73.uf_remappedPS[0].y);
  R1f.y = mul_nonIEEE(param_2, param_3) + intBitsToFloat(_73.uf_remappedPS[1].y);
  float param_4 = R0f.z;
  float param_5 = intBitsToFloat(_73.uf_remappedPS[0].z);
  R1f.z = mul_nonIEEE(param_4, param_5) + intBitsToFloat(_73.uf_remappedPS[1].z);
  float param_6 = R0f.w;
  float param_7 = intBitsToFloat(_73.uf_remappedPS[0].w);
  R1f.w = mul_nonIEEE(param_6, param_7) + intBitsToFloat(_73.uf_remappedPS[1].w);
  passPixelColor0 = vec4(R1f.x, R1f.y, R1f.z, saturate(R1f.w));  // saturate alpha
  passPixelColor0 = max(0, passPixelColor0);
}
