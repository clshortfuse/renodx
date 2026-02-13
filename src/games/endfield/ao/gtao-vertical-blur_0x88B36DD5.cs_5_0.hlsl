// ---- Created with 3Dmigoto v1.4.1 on Tue Feb 10 15:11:49 2026
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[4];
}


#include "../shared.h"

#define cmp -

RWTexture2D<unorm float4> u0 : register(u0);

[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2,r3,r4;
  r0.xy = (uint2)vThreadID.xy;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.zw = cb0[3].zw * r0.xy;
  r1.x = t1.SampleLevel(s0_s, r0.zw, 0).z;
  r1.x = 1 + -r1.x;
  r1.x = saturate(r1.x + r1.x);
  r1.x *= AO_DENOISER_BLUR_BETA;
  r1.w = t0.SampleLevel(s0_s, r0.zw, 0).x;
  r2.x = cb0[3].z;
  r2.y = 1;
  r1.y = cb0[3].w;
  r1.z = 0;
  r3.xyz = float3(0,0,-3);
  while (true) {
    r2.z = cmp(3 < r3.z);
    if (r2.z != 0) break;
    r2.zw = r3.zz * r2.xy;
    r2.zw = r2.zw * r1.xy;
    r2.zw = r2.zw * r1.zx;
    r4.xy = r2.zw * cb0[3].zw + r0.zw;
    r3.w = t0.SampleLevel(s0_s, r4.xy, 0).x;
    r3.w = r3.w + -r1.w;
    r3.w = min(1, abs(r3.w));
    r3.w = 1 + -r3.w;
    r4.x = r3.x + r3.w;
    r2.zw = r0.xy * cb0[3].zw + r2.zw;
    r2.z = t2.SampleLevel(s0_s, r2.zw, 0).x;
    r4.y = r2.z * r3.w + r3.y;
    r4.z = 1 + r3.z;
    r3.xyz = r4.xyz;
    continue;
  }
  r0.x = max(9.99999975e-05, r3.x);
  r0.x = r3.y / r0.x;
  u0[vThreadID.xy] = r0.xxxx;
  return;
}