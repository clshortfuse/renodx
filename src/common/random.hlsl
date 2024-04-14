#ifndef SRC_COMMON_RANDOM_HLSL_
#define SRC_COMMON_RANDOM_HLSL_

float rand(float2 uv) {
  return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453123);
}

// https://www.shadertoy.com/view/4djSRW
// 3 out, 3 in...
float3 hash33(float3 p3) {
  p3 = frac(p3 * float3(0.1031f, 0.1030f, 0.0973f));
  p3 += dot(p3, p3.yxz + 33.33);
  return frac((p3.xxy + p3.yxx) * p3.zyx);
}

float4 hash41(float p) {
  float4 p4 = frac(p * float4(0.1031f, 0.1030f, 0.0973f, 0.1099f));
  p4 += dot(p4, p4.wzxy + 33.33);
  return frac((p4.xxyz + p4.yzzw) * p4.zywx);
}

uint wang(uint v) {
  v = (v ^ 61u) ^ (v >> 16u);
  v *= 9u;
  v ^= v >> 4u;
  v *= 0x27d4eb2du;
  v ^= v >> 15u;
  return v;
}

uint seedGen(float2 p) {
  return 19u * p.x + 47u * p.y + 101u;
}

uint seedGen(float3 p) {
  return 19u * p.x + 47u * p.y + 101u * p.z + 131u;
}

const float GELFOND_CONSTANT = 23.1406926327792690;           // e^pi (Gelfond's constant)
const float GELFOND_SCHNEIDER_CONSTANT = 2.6651441426902251;  // 2^sqrt(2) (Gelfond–Schneider constant)

#endif  // SRC_COMMON_RANDOM_HLSL_
