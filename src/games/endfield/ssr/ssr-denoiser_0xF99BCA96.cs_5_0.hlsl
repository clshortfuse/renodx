
#include "../shared.h"

Texture2D<float4> t3 : register(t3);  
Texture2D<float4> t2 : register(t2);  
Texture2D<float4> t1 : register(t1);  
Texture2D<float4> t0 : register(t0);  

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[83];
}

RWTexture2D<float4> u0 : register(u0);

#define cmp -

[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13;
  uint4 bitmask, uiDest;
  float4 fDest;

  // === ORIGINAL DENOISER ===
  r0.xyzw = (int4)vThreadID.xyxy + int4(0,1,1,1);
  r0.xyzw = (int4)r0.xyzw;
  r0.xyzw = float4(0.5,0.5,0.5,0.5) + r0.xyzw;
  r0.xyzw = cb0[82].zwzw * r0.xyzw;
  r1.xyz = t1.SampleLevel(s0_s, r0.zw, 0).xyz;
  r0.xyz = t1.SampleLevel(s0_s, r0.xy, 0).xyz;
  r0.w = dot(r1.xz, float2(0.5,-0.5));
  r2.y = 0.501960814 + r0.w;
  r0.w = dot(r1.xzy, float3(-0.25,-0.25,0.5));
  r2.x = dot(r1.xzy, float3(0.25,0.25,0.5));
  r2.z = 0.501960814 + r0.w;
  r0.w = dot(r0.xz, float2(0.5,-0.5));
  r1.y = 0.501960814 + r0.w;
  r0.w = dot(r0.xzy, float3(-0.25,-0.25,0.5));
  r1.x = dot(r0.xzy, float3(0.25,0.25,0.5));
  r1.z = 0.501960814 + r0.w;
  r0.xyzw = (int4)vThreadID.xyxy + int4(1,0,-1,1);
  r0.xyzw = (int4)r0.xyzw;
  r0.xyzw = float4(0.5,0.5,0.5,0.5) + r0.xyzw;
  r0.xyzw = cb0[82].zwzw * r0.xyzw;
  r3.xyz = t1.SampleLevel(s0_s, r0.zw, 0).xyz;
  r0.xyz = t1.SampleLevel(s0_s, r0.xy, 0).xyz;
  r0.w = dot(r3.xz, float2(0.5,-0.5));
  r4.y = 0.501960814 + r0.w;
  r0.w = dot(r3.xzy, float3(-0.25,-0.25,0.5));
  r4.x = dot(r3.xzy, float3(0.25,0.25,0.5));
  r4.z = 0.501960814 + r0.w;
  r0.w = dot(r0.xz, float2(0.5,-0.5));
  r3.y = 0.501960814 + r0.w;
  r0.w = dot(r0.xzy, float3(-0.25,-0.25,0.5));
  r3.x = dot(r0.xzy, float3(0.25,0.25,0.5));
  r3.z = 0.501960814 + r0.w;
  r0.xyzw = (int4)vThreadID.xyxy + int4(1,-1,-1,0);
  r0.xyzw = (int4)r0.xyzw;
  r0.xyzw = float4(0.5,0.5,0.5,0.5) + r0.xyzw;
  r0.xyzw = cb0[82].zwzw * r0.xyzw;
  r5.xyz = t1.SampleLevel(s0_s, r0.zw, 0).xyz;
  r0.xyz = t1.SampleLevel(s0_s, r0.xy, 0).xyz;
  r0.w = dot(r5.xz, float2(0.5,-0.5));
  r6.y = 0.501960814 + r0.w;
  r0.w = dot(r5.xzy, float3(-0.25,-0.25,0.5));
  r6.x = dot(r5.xzy, float3(0.25,0.25,0.5));
  r6.z = 0.501960814 + r0.w;
  r0.w = dot(r0.xz, float2(0.5,-0.5));
  r5.y = 0.501960814 + r0.w;
  r0.w = dot(r0.xzy, float3(-0.25,-0.25,0.5));
  r5.x = dot(r0.xzy, float3(0.25,0.25,0.5));
  r5.z = 0.501960814 + r0.w;
  r0.xyzw = (int4)vThreadID.xyxy + int4(-1,-1,0,-1);
  r0.xyzw = (int4)r0.xyzw;
  r0.xyzw = float4(0.5,0.5,0.5,0.5) + r0.xyzw;
  r0.xyzw = cb0[82].zwzw * r0.xyzw;
  r7.xyz = t1.SampleLevel(s0_s, r0.xy, 0).xyz;
  r0.xyz = t1.SampleLevel(s0_s, r0.zw, 0).xyz;
  r0.w = dot(r7.xz, float2(0.5,-0.5));
  r8.y = 0.501960814 + r0.w;
  r0.w = dot(r7.xzy, float3(-0.25,-0.25,0.5));
  r8.x = dot(r7.xzy, float3(0.25,0.25,0.5));
  r8.z = 0.501960814 + r0.w;
  r0.w = dot(r0.xz, float2(0.5,-0.5));
  r7.y = 0.501960814 + r0.w;
  r0.w = dot(r0.xzy, float3(-0.25,-0.25,0.5));
  r7.x = dot(r0.xzy, float3(0.25,0.25,0.5));
  r7.z = 0.501960814 + r0.w;
  r0.xyz = r7.xyz * r7.xyz;
  r0.xyz = r8.xyz * r8.xyz + r0.xyz;
  r0.xyz = r5.xyz * r5.xyz + r0.xyz;
  r0.xyz = r6.xyz * r6.xyz + r0.xyz;
  r9.xy = (int2)vThreadID.xy;
  r9.xy = float2(0.5,0.5) + r9.xy;
  r9.xy = cb0[82].zw * r9.xy;
  r10.xyz = t1.SampleLevel(s0_s, r9.xy, 0).xyz;
  r0.w = dot(r10.xz, float2(0.5,-0.5));
  r11.y = 0.501960814 + r0.w;
  r0.w = dot(r10.xzy, float3(-0.25,-0.25,0.5));
  r11.z = 0.501960814 + r0.w;
  r11.x = dot(r10.xzy, float3(0.25,0.25,0.5));
  r0.xyz = r11.xyz * r11.xyz + r0.xyz;
  r0.xyz = r3.xyz * r3.xyz + r0.xyz;
  r0.xyz = r4.xyz * r4.xyz + r0.xyz;
  r0.xyz = r1.xyz * r1.xyz + r0.xyz;
  r0.xyz = r2.xyz * r2.xyz + r0.xyz;
  r12.xyz = r8.xyz + r7.xyz;
  r12.xyz = r12.xyz + r5.xyz;
  r12.xyz = r12.xyz + r6.xyz;
  r12.xyz = r12.xyz + r11.xyz;
  r12.xyz = r12.xyz + r3.xyz;
  r12.xyz = r12.xyz + r4.xyz;
  r12.xyz = r12.xyz + r1.xyz;
  r12.xyz = r12.xyz + r2.xyz;
  r13.xyz = float3(0.111111112,0.111111112,0.111111112) * r12.xyz;
  r13.xyz = r13.xyz * r13.xyz;
  r0.xyz = r0.xyz * float3(0.111111112,0.111111112,0.111111112) + -r13.xyz;
  r0.xyz = sqrt(r0.xyz);

  // Variance multiplier: wider = more history survives the clamp = less shimmer
  // Vanilla is 1.25. In Reduced mode, widen to 2.0 for stability.

  float variance_mult = (shader_injection.improved_ssr >= 0.5f) ? 2.0f : 1.25f;
  r0.xyz = variance_mult * r0.xyz;
  r13.xyz = r12.xyz * float3(0.111111112,0.111111112,0.111111112) + -r0.xyz;
  r0.xyz = r12.xyz * float3(0.111111112,0.111111112,0.111111112) + r0.xyz;
  r12.xyz = min(r8.xyz, r5.xyz);
  r5.xyz = max(r8.xyz, r5.xyz);
  r8.xyz = min(r4.xyz, r2.xyz);
  r2.xyz = max(r4.xyz, r2.xyz);
  r2.xyz = max(r5.xyz, r2.xyz);
  r4.xyz = min(r12.xyz, r8.xyz);
  r5.xyz = min(r3.xyz, r1.xyz);
  r1.xyz = max(r3.xyz, r1.xyz);
  r3.xyz = min(r11.xyz, r6.xyz);
  r6.xyz = max(r11.xyz, r6.xyz);
  r1.xyz = max(r6.xyz, r1.xyz);
  r1.xyz = max(r7.xyz, r1.xyz);
  r3.xyz = min(r3.xyz, r5.xyz);
  r3.xyz = min(r7.xyz, r3.xyz);
  r4.xyz = min(r3.xyz, r4.xyz);
  r3.xyz = r4.xyz + r3.xyz;
  r3.xyz = float3(0.5,0.5,0.5) * r3.xyz;
  r3.xyz = min(r3.xyz, r13.xyz);
  r2.xyz = max(r1.xyz, r2.xyz);
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = float3(0.5,0.5,0.5) * r1.xyz;
  r0.xyz = max(r1.xyz, r0.xyz);
  r1.xyz = r0.xyz + -r3.xyz;
  r0.xyz = r0.xyz + r3.xyz;
  r1.xyz = float3(0.5,0.5,0.5) * r1.xyz;
  r2.xy = t0.SampleLevel(s0_s, r9.xy, 0).xy;
  r2.zw = float2(-0.5,-0.5) + r2.xy;
  r2.xy = abs(r2.xy) * float2(2,2) + float2(-1,-1);
  r2.xy = r2.xy * r2.xy;
  r2.xy = r2.xy * r2.xy;
  r3.xy = cmp(float2(0,0) < r2.zw);
  r2.zw = cmp(r2.zw < float2(0,0));
  r2.zw = (int2)-r3.xy + (int2)r2.zw;
  r2.zw = (int2)r2.zw;
  r2.xy = -r2.xy * r2.zw + r9.xy;
  r0.w = t2.SampleLevel(s0_s, r9.xy, 0).x;
  r0.w = 0.899999976 * r0.w;
  if (shader_injection.improved_ssr >= 0.5f) {
    // Manual bilinear interpolation for history color
    float2 texelPos = r2.xy * cb0[82].xy - 0.5;
    float2 f = frac(texelPos);
    float2 base = (floor(texelPos) + 0.5) * cb0[82].zw;
    float3 h00 = t3.SampleLevel(s0_s, base, 0).xyz;
    float3 h10 = t3.SampleLevel(s0_s, base + float2(cb0[82].z, 0), 0).xyz;
    float3 h01 = t3.SampleLevel(s0_s, base + float2(0, cb0[82].w), 0).xyz;
    float3 h11 = t3.SampleLevel(s0_s, base + cb0[82].zw, 0).xyz;
    r2.xyz = lerp(lerp(h00, h10, f.x), lerp(h01, h11, f.x), f.y);
  } else {
    r2.xyz = t3.SampleLevel(s0_s, r2.xy, 0).xyz;
  }
  r1.w = dot(r2.xz, float2(0.5,-0.5));
  r3.y = 0.501960814 + r1.w;
  r1.w = dot(r2.xzy, float3(-0.25,-0.25,0.5));
  r3.x = dot(r2.xzy, float3(0.25,0.25,0.5));
  r3.z = 0.501960814 + r1.w;
  r2.xyz = -r0.xyz * float3(0.5,0.5,0.5) + r3.xyz;
  r1.xyz = r2.xyz / r1.xyz;
  r1.y = max(abs(r1.y), abs(r1.z));
  r1.x = max(abs(r1.x), r1.y);
  r1.yzw = r2.xyz / r1.xxx;
  r1.x = cmp(1 < r1.x);
  r0.xyz = r0.xyz * float3(0.5,0.5,0.5) + r1.yzw;
  r0.xyz = r1.xxx ? r0.xyz : r3.xyz;
  r0.yz = float2(-0.501960814,-0.501960814) + r0.yz;
  r1.xy = r0.xx + r0.yz;
  r1.xw = r1.xx + -r0.zz;
  r0.y = r0.x + -r0.y;
  r1.z = r0.y + -r0.z;
  r1.xyzw = r1.xyzw + -r10.xyzx;
  r0.xyzw = r0.wwww * r1.xyzw + r10.xyzx;
  r0.xyzw = max(float4(0.00100000005,0.00100000005,0.00100000005,0.00100000005), r0.xyzw);
  u0[vThreadID.xy] = r0.xyzw;
  return;
}