#include "../common.hlsl"

struct u0_t {
  float val[4];
};
RWStructuredBuffer<u0_t> u0 : register(u0);
Texture2D<float4> t0 : register(t0);
cbuffer cb0 : register(b0){
  float4 cb0[44];
}

#define cmp -

[numthreads(1, 1, 1)]
void main() {
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yzw = float3(0,0,0);
  r1.xyz = float3(0,0,0);
  while (true) {
    r1.w = cmp((uint)r1.z >= 8);
    if (r1.w != 0) break;
    r0.x = r1.z;
    r2.xy = t0.Load(r0.xyz).xy;
    r1.xy = r2.xy + r1.xy;
    r1.z = (int)r1.z + 1;
  }
  r0.yzw = float3(1.40129846e-45,0,0);
  r1.zw = r1.xy;
  r2.x = 0;
  while (true) {
    r2.y = cmp((uint)r2.x >= 8);
    if (r2.y != 0) break;
    r0.x = r2.x;
    r2.yz = t0.Load(r0.xyz).xy;
    r1.zw = r2.yz + r1.zw;
    r2.x = (int)r2.x + 1;
  }
  r0.yzw = float3(2.80259693e-45,0,0);
  r1.xy = r1.zw;
  r2.x = 0;
  while (true) {
    r2.y = cmp((uint)r2.x >= 8);
    if (r2.y != 0) break;
    r0.x = r2.x;
    r2.yz = t0.Load(r0.xyz).xy;
    r1.xy = r2.yz + r1.xy;
    r2.x = (int)r2.x + 1;
  }
  r0.yzw = float3(4.20389539e-45,0,0);
  r1.zw = r1.xy;
  r2.x = 0;
  while (true) {
    r2.y = cmp((uint)r2.x >= 8);
    if (r2.y != 0) break;
    r0.x = r2.x;
    r2.yz = t0.Load(r0.xyz).xy;
    r1.zw = r2.yz + r1.zw;
    r2.x = (int)r2.x + 1;
  }
  r0.yzw = float3(5.60519386e-45,0,0);
  r1.xy = r1.zw;
  r2.x = 0;
  while (true) {
    r2.y = cmp((uint)r2.x >= 8);
    if (r2.y != 0) break;
    r0.x = r2.x;
    r2.yz = t0.Load(r0.xyz).xy;
    r1.xy = r2.yz + r1.xy;
    r2.x = (int)r2.x + 1;
  }
  r0.yzw = float3(7.00649232e-45,0,0);
  r1.zw = r1.xy;
  r2.x = 0;
  while (true) {
    r2.y = cmp((uint)r2.x >= 8);
    if (r2.y != 0) break;
    r0.x = r2.x;
    r2.yz = t0.Load(r0.xyz).xy;
    r1.zw = r2.yz + r1.zw;
    r2.x = (int)r2.x + 1;
  }
  r0.yzw = float3(8.40779079e-45,0,0);
  r1.xy = r1.zw;
  r2.x = 0;
  while (true) {
    r2.y = cmp((uint)r2.x >= 8);
    if (r2.y != 0) break;
    r0.x = r2.x;
    r2.yz = t0.Load(r0.xyz).xy;
    r1.xy = r2.yz + r1.xy;
    r2.x = (int)r2.x + 1;
  }
  r0.yzw = float3(9.80908925e-45,0,0);
  r1.zw = r1.xy;
  r2.x = 0;
  while (true) {
    r2.y = cmp((uint)r2.x >= 8);
    if (r2.y != 0) break;
    r0.x = r2.x;
    r2.yz = t0.Load(r0.xyz).xy;
    r1.zw = r2.yz + r1.zw;
    r2.x = (int)r2.x + 1;
  }
  r0.x = r1.z / r1.w;
  r0.x = exp2(r0.x);
  r0.y = u0[0].val[0/4];
  r0.x = r0.x / r0.y;
  r0.x = r0.x * 5464.01611 + 9.99999994e-09;
  r1.y = log2(r0.x);
  r0.x = max(-20, r1.y);
  r0.x = min(19.9990005, r0.x);
  r0.z = 20 + r0.x;
  r0.z = floor(r0.z);
  r0.z = (uint)r0.z;
  r0.x = frac(r0.x);
  r0.w = cb0[r0.z+1].x + -cb0[r0.z+0].x;
  r0.x = r0.x * r0.w + cb0[r0.z+0].x;
  r0.x = max(cb0[42].w, r0.x);
  r1.z = min(cb0[42].z, r0.x);
  r0.x = exp2(-r1.z);
  r0.x = 5464.01611 * r0.x;
  r0.z = cmp(r0.y < r0.x);
  r0.z = r0.z ? cb0[43].y : cb0[42].y;
  r0.y = log2(r0.y);
  r0.w = log2(r0.x);
  r0.x = max(1, r0.x);
  r0.x = 1 / r0.x;
  r0.x = max(0.400000006, r0.x);
  r2.x = saturate(cb0[43].z);
  r0.x = -1 + r0.x;
  r0.x = r2.x * r0.x + 1;
  r0.x = saturate(r0.z * r0.x);
  r0.z = r0.w + -r0.y;
  r0.x = r0.x * r0.z + r0.y;
  r0.x = r0.x + -r0.w;
  r0.x = max(-5, r0.x);
  r0.x = min(5, r0.x);
  r0.x = r0.w + r0.x;
  r0.x = exp2(r0.x);
  r1.x = cb0[43].w ? lerp(cb0[43].x, r0.x, injectedData.fxAutoExposure) : cb0[43].x;
  r1.w = rcp(r1.x);
  u0[0].val[0/4] = r1.x;
  u0[0].val[0/4+1] = r1.y;
  u0[0].val[0/4+2] = r1.z;
  u0[0].val[0/4+3] = r1.w;
  return;
}