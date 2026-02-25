#version 450

#extension GL_GOOGLE_include_directive : require
#include "./output.glsl"

layout(local_size_x = 32, local_size_y = 32, local_size_z = 1) in;

vec3 _50;
vec3 _58;

layout(set = 0, binding = 23, std140) uniform _6_7 {
  float _m0;
  float _m1;
  uint _m2;
  uint _m3;
  uint _m4;
  uint _m5;
  float _m6;
  float _m7;
  float _m8;
  float _m9;
  float _m10;
  float _m11;
  float _m12;
  float _m13;
  float _m14;
  float _m15;
  uint _m16;
  uint _m17;
  uint _m18;
  uint _m19;
}
_7;

layout(set = 0, binding = 19, std140) uniform _8_9 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec4 _m3;
  vec4 _m4;
  vec4 _m5;
  vec4 _m6;
  vec4 _m7;
  vec4 _m8;
  vec4 _m9;
  vec4 _m10;
  float _m11;
  float _m12;
  float _m13;
  float _m14;
  float _m15;
  float _m16;
  float _m17;
  float _m18;
  float _m19;
  float _m20;
  float _m21;
  float _m22;
  float _m23;
  float _m24;
  uint _m25;
  uint _m26;
}
_9;

layout(set = 1, binding = 64, rgba32f) uniform writeonly image3D _11;

void main() {
  uvec3 _65 = uvec3(gl_GlobalInvocationID.xy, gl_WorkGroupID.z);
  vec3 _72 = vec3(_65) / vec3(float(_9._m26 - 1u));
  float _75 = pow(abs(_72.x), 0.0126833133399486541748046875);
  vec3 _82;
  _82.x = pow(max(_75 - 0.8359375, 0.0) / (18.8515625 - (18.6875 * _75)), 6.277394771575927734375);
  float _85 = pow(abs(_72.y), 0.0126833133399486541748046875);
  _82.y = pow(max(_85 - 0.8359375, 0.0) / (18.8515625 - (18.6875 * _85)), 6.277394771575927734375);
  float _95 = pow(abs(_72.z), 0.0126833133399486541748046875);
  _82.z = pow(max(_95 - 0.8359375, 0.0) / (18.8515625 - (18.6875 * _95)), 6.277394771575927734375);
  vec3 _109 = (_82 * _7._m15) / vec3(_7._m0);
  float _124 = _109.x;
  float _125 = _109.y;
  float _126 = _109.z;
  float _129 = max(max(_124, max(_125, _126)), 5.9604644775390625e-08);
  float _133 = pow(_129, _9._m1.x);
  float _137 = _133 / ((pow(_133, _9._m1.y) * _9._m1.z) + _9._m1.w);
  vec3 _160;
  _160.x = pow(mix(pow(_124 / _129, _9._m2.x), 1.0, pow(_137, _9._m3.x)), _9._m4.x) * _137;
  _160.y = pow(mix(pow(_125 / _129, _9._m2.y), 1.0, pow(_137, _9._m3.y)), _9._m4.y) * _137;
  _160.z = pow(mix(pow(_126 / _129, _9._m2.z), 1.0, pow(_137, _9._m3.z)), _9._m4.z) * _137;
  imageStore(_11, ivec3(_65), vec4(_160 * mat3(vec3(1.66049015522003173828125, -0.587639033794403076171875, -0.072851590812206268310546875), vec3(-0.124549962580204010009765625, 1.13289988040924072265625, -0.00834796018898487091064453125), vec3(-0.01815111003816127777099609375, -0.10057871043682098388671875, 1.11872971057891845703125)), 1.0));
}

