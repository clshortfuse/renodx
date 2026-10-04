#include "../shared.h"

Texture2DArray<float4> t4 : register(t4);
Texture2DArray<float4> t3 : register(t3);
Texture2DArray<float4> t2 : register(t2);
Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
RWTexture2DArray<float4> u0 : register(u0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[55];
}

[numthreads(8, 8, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (uint3)vThreadID.xyz;
  r1.xy = float2(0.5,0.5) + r0.xy;
  r1.xy = cb0[51].zw * r1.xy;
  r1.xy = cb0[54].xy * r1.xy;
  r2.xyz = vThreadID.xyz;
  r2.w = 0;
  r3.xyz = t0.Load(r2.xyzw).xyz;
  float3 preDOF = r3.xyz;
  r1.zw = cb1[0].yy * cb0[51].xy;
  r4.xy = rcp(cb0[54].xy);
  r1.zw = r4.xy * r1.zw;
  r4.xy = float2(1,1) / r1.zw;
  r4.zw = cb0[54].xy + -r4.xy;
  r1.xy = min(r4.zw, r1.xy);
  r0.w = t4.Load(r2.xyzw).x;
  if (r0.w > 0) {
    r2.xy = r1.xy * r1.zw + float2(0.5,0.5);
    r2.zw = floor(r2.xy);
    r2.xy = frac(r2.xy);
    r5.xyzw = -r2.xyxy * float4(0.5,0.5,0.166666672,0.166666672) + float4(0.5,0.5,0.5,0.5);
    r5.xyzw = r2.xyxy * r5.xyzw + float4(0.5,0.5,-0.5,-0.5);
    r6.xy = r2.xy * float2(0.5,0.5) + float2(-1,-1);
    r6.zw = r2.xy * r2.xy;
    r6.xy = r6.zw * r6.xy + float2(0.666666687,0.666666687);
    r5.xyzw = r2.xyxy * r5.xyzw + float4(0.166666672,0.166666672,0.166666672,0.166666672);
    r2.xy = float2(1,1) + -r6.xy;
    r2.xy = r2.xy + -r5.xy;
    r2.xy = r2.xy + -r5.zw;
    r5.zw = r5.zw + r6.xy;
    r5.xy = r5.xy + r2.xy;
    r6.zw = rcp(r5.zw);
    r6.zw = r6.xy * r6.zw + float2(-1,-1);
    r7.xy = rcp(r5.xy);
    r6.xy = r2.xy * r7.xy + float2(1,1);
    r7.xyzw = r6.zwxw + r2.zwzw;
    r7.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r7.xyzw;
    r7.xyzw = r7.xyzw * r4.xyxy;
    r8.xy = min(r7.xy, r4.zw);
    r8.z = (uint)vThreadID.z;
    r9.xyz = t3.SampleLevel(s0_s, r8.xyz, 0).xyz;
    r8.xy = min(r7.zw, r4.zw);
    r7.xyz = t3.SampleLevel(s0_s, r8.xyz, 0).xyz;
    r7.xyz = r7.xyz * r5.xxx;
    r7.xyz = r5.zzz * r9.xyz + r7.xyz;
    r2.xyzw = r6.zyxy + r2.zwzw;
    r2.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r2.xyzw;
    r2.xyzw = r2.xyzw * r4.xyxy;
    r8.xy = min(r2.xy, r4.zw);
    r6.xyz = t3.SampleLevel(s0_s, r8.xyz, 0).xyz;
    r8.xy = min(r2.zw, r4.zw);
    r2.xyz = t3.SampleLevel(s0_s, r8.xyz, 0).xyz;
    r2.xyz = r5.xxx * r2.xyz;
    r2.xyz = r5.zzz * r6.xyz + r2.xyz;
    r2.xyz = r5.yyy * r2.xyz;
    r2.xyz = r5.www * r7.xyz + r2.xyz;
    r0.w = 12.566371 * r0.w;
    r0.w = sqrt(r0.w);
    r2.w = min(1, r0.w);
    r2.xyz = r2.xyz * r2.www;
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
  } else {
    r2.xyz = float3(0,0,0);
    r0.w = 1;
  }
  r2.xyzw = r3.xyzx * r0.wwww + r2.xyzx;
  r1.xy = r1.xy * r1.zw + float2(0.5,0.5);
  r1.zw = floor(r1.xy);
  r1.xy = frac(r1.xy);
  r3.xyzw = -r1.xyxy * float4(0.5,0.5,0.166666672,0.166666672) + float4(0.5,0.5,0.5,0.5);
  r3.xyzw = r1.xyxy * r3.xyzw + float4(0.5,0.5,-0.5,-0.5);
  r5.xy = r1.xy * float2(0.5,0.5) + float2(-1,-1);
  r5.zw = r1.xy * r1.xy;
  r5.xy = r5.zw * r5.xy + float2(0.666666687,0.666666687);
  r3.xyzw = r1.xyxy * r3.xyzw + float4(0.166666672,0.166666672,0.166666672,0.166666672);
  r1.xy = float2(1,1) + -r5.xy;
  r1.xy = r1.xy + -r3.xy;
  r1.xy = r1.xy + -r3.zw;
  r3.zw = r3.zw + r5.xy;
  r3.xy = r3.xy + r1.xy;
  r5.zw = rcp(r3.zw);
  r5.zw = r5.xy * r5.zw + float2(-1,-1);
  r6.xy = rcp(r3.xy);
  r5.xy = r1.xy * r6.xy + float2(1,1);
  r6.xyzw = r5.zwxw + r1.zwzw;
  r6.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r6.xyzw;
  r6.xyzw = r6.xyzw * r4.xyxy;
  r0.xy = min(r6.xy, r4.zw);
  r7.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
  r6.xy = min(r6.zw, r4.zw);
  r6.z = r0.z;
  r8.xyz = t1.SampleLevel(s0_s, r6.xyz, 0).xyz;
  r8.xyzw = r8.xyzx * r3.xxxx;
  r7.xyzw = r3.zzzz * r7.xyzx + r8.xyzw;
  r1.xyzw = r5.zyxy + r1.zwzw;
  r1.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r1.xyzw;
  r1.xyzw = r1.xyzw * r4.xyxy;
  r5.xy = min(r1.xy, r4.zw);
  r5.z = r6.z;
  r8.xyz = t1.SampleLevel(s0_s, r5.xyz, 0).xyz;
  r1.xy = min(r1.zw, r4.zw);
  r1.z = r5.z;
  r4.xyz = t1.SampleLevel(s0_s, r1.xyz, 0).xyz;
  r4.xyzw = r4.xyzx * r3.xxxx;
  r4.xyzw = r3.zzzz * r8.xyzx + r4.xyzw;
  r4.xyzw = r4.xyzw * r3.yyyy;
  r4.xyzw = r3.wwww * r7.xyzw + r4.xyzw;
  r0.x = t2.SampleLevel(s0_s, r0.xyz, 0).x;
  r0.y = t2.SampleLevel(s0_s, r6.xyz, 0).x;
  r0.y = r3.x * r0.y;
  r0.x = r3.z * r0.x + r0.y;
  r0.y = t2.SampleLevel(s0_s, r5.xyz, 0).x;
  r0.z = t2.SampleLevel(s0_s, r1.xyz, 0).x;
  r0.z = r3.x * r0.z;
  r0.y = r3.z * r0.y + r0.z;
  r0.y = r3.y * r0.y;
  r0.x = r3.w * r0.x + r0.y;
  r1.xyzw = r4.xyzw + -r2.wyzw;
  r0.xyzw = r0.xxxx * r1.xyzw + r2.xyzw;
  r0.xyz = lerp(preDOF, r0.xyz, CUSTOM_DOF);
  u0[vThreadID] = r0.xyzw;
  return;
}