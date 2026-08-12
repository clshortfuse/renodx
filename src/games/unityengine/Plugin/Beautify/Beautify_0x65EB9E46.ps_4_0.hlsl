#include "../../shared.h"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[171];
}

#define cmp -
// Iron Nest: Heavy Turret Simulator

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float2 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.z = dot(r0.xy, r0.xy);
  r0.zw = cb0[138].xy * r0.zz;
  r0.xy = r0.xy * r0.zz;
  r0.z = (int)r0.w;
  r0.z = (int)r0.z + 1;
  r0.z = max(3, (int)r0.z);
  r0.z = min(32, (int)r0.z);
  r0.w = (int)r0.z;
  r1.xyz = float3(0.5,1.5,2.5) / r0.www;
  r2.xyz = cb0[138].zzz + r1.xyz;
  r3.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
  r3.xyz = float3(0.166666672,0.166666672,0.166666672) * r3.xyz;
  r4.xyz = cmp(r3.xyz >= -r3.xyz);
  r3.xyz = frac(abs(r3.xyz));
  r3.xyz = r4.xyz ? r3.xyz : -r3.xyz;
  r3.xyz = r3.xyz * float3(6,6,6) + float3(-3,-3,-3);
  r3.xyz = saturate(float3(-1,-1,-1) + abs(r3.xyz));
  r4.xyzw = -r0.xyxy * r1.xxyy + v1.xyxy;
  r5.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r1.xyw = float3(9.99999975e-005,9.99999975e-005,9.99999975e-005) + r3.xyz;
  r2.xyw = r2.yyy * float3(6,6,6) + float3(0,4,2);
  r2.xyw = float3(0.166666672,0.166666672,0.166666672) * r2.xyw;
  r6.xyz = cmp(r2.xyw >= -r2.xyw);
  r2.xyw = frac(abs(r2.xyw));
  r2.xyw = r6.xyz ? r2.xyw : -r2.xyw;
  r2.xyw = r2.xyw * float3(6,6,6) + float3(-3,-3,-3);
  r2.xyw = saturate(float3(-1,-1,-1) + abs(r2.xyw));
  r4.xyzw = t0.SampleLevel(s0_s, r4.zw, 0).xyzw;
  r4.xyz = r4.xyz * r2.xyw;
  r3.xyz = r5.xyz * r3.xyz + r4.xyz;
  r1.xyw = r2.xyw + r1.xyw;
  r2.xyz = r2.zzz * float3(6,6,6) + float3(0,4,2);
  r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
  r4.xyz = cmp(r2.xyz >= -r2.xyz);
  r2.xyz = frac(abs(r2.xyz));
  r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
  r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
  r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
  r4.xy = -r0.xy * r1.zz + v1.xy;
  r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r3.xyz = r4.xyz * r2.xyz + r3.xyz;
  r1.xyz = r2.xyz + r1.xyw;
  r2.xyzw = cmp(int4(3,4,5,6) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 3.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 4.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 5.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (r2.w != 0) {
    r1.w = 6.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  r2.xyzw = cmp(int4(7,8,9,10) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 7.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 8.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 9.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (r2.w != 0) {
    r1.w = 10.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  r2.xyzw = cmp(int4(11,12,13,14) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 11.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 12.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 13.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (r2.w != 0) {
    r1.w = 14.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  r2.xyzw = cmp(int4(15,16,17,18) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 15.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 16.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 17.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (r2.w != 0) {
    r1.w = 18.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  r2.xyzw = cmp(int4(19,20,21,22) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 19.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 20.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 21.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (r2.w != 0) {
    r1.w = 22.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  r2.xyzw = cmp(int4(23,24,25,26) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 23.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 24.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 25.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (r2.w != 0) {
    r1.w = 26.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  r2.xyzw = cmp(int4(27,28,29,30) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 27.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 28.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r5.xyz = cmp(r4.xyz >= -r4.xyz);
    r4.xyz = frac(abs(r4.xyz));
    r4.xyz = r5.xyz ? r4.xyz : -r4.xyz;
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 29.5 / r0.w;
    r2.x = cb0[138].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (r2.w != 0) {
    r0.w = 30.5 / r0.w;
    r1.w = cb0[138].z + r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r0.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  r0.z = cmp(31 < (int)r0.z);
  if (r0.z != 0) {
    r0.z = 0.984375 + cb0[138].z;
    r2.xyz = r0.zzz * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= -r2.xyz);
    r2.xyz = frac(abs(r2.xyz));
    r2.xyz = r4.xyz ? r2.xyz : -r2.xyz;
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r0.xy = -r0.xy * float2(0.984375,0.984375) + v1.xy;
    r0.xyzw = t0.SampleLevel(s0_s, r0.xy, 0).xyzw;
    r3.xyz = r0.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  r0.xyz = r3.xyz / r1.xyz;
  r0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r1.xyzw = t1.SampleBias(s0_s, v1.xy, cb0[4].x).xyzw;
  r0.xyz = r1.xyz * cb0[150].xxx + r0.xyz;
  r1.xyzw = t2.SampleBias(s0_s, v1.xy, cb0[4].x).xyzw;
  r2.xyzw = t3.SampleBias(s1_s, v1.xy, cb0[4].x).xyzw;
  r1.w = 0.5 + -cb0[151].z;
  r1.xyz = saturate(r1.xyz * cb0[151].www + r1.www);
  r1.xyz = r1.xyz * r2.xyz;
  r0.xyz = r1.xyz * cb0[151].yyy + r0.xyz;
  r1.x = max(r0.y, r0.z);
  r1.x = max(r1.x, r0.x);
  r1.y = min(r0.y, r0.z);
  r1.y = min(r1.y, r0.x);
  r1.x = saturate(r1.x + -r1.y);
  r1.x = 1 + -r1.x;
  r1.x = cb0[153].z * r1.x;
  r1.y = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r1.yzw = -r1.yyy + r0.xyz;
  r1.xyz = r1.xxx * r1.yzw + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  r1.xyz = r0.xyz * cb0[154].xyz + -r0.xyz;
  r0.xyz = cb0[154].www * r1.xyz + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[153].yyy + float3(0.5,0.5,0.5);
  r0.xyz = cb0[153].xxx * r0.xyz;
  r1.xyzw = cb0[141].zzzz * cb0[136].zwzw;
  r2.xy = v1.xy * r1.zw;
  r2.xyzw = floor(r2.xyxy);
  r0.w = sqrt(r0.w);
  r3.xy = v1.xy * r1.zw + -r2.zw;
  r1.xyzw = float4(1,1,1,1) / r1.xyzw;
  r3.zw = r2.zw * r1.zw;
  r3.z = dot(r3.zw, float2(321.894196,1225.65479));
  r4.xyzw = r2.zwzw * r1.zwzw + float4(0.100000001,0.100000001,0.200000003,0.200000003);
  r3.w = dot(r4.xy, float2(321.894196,1225.65479));
  r4.x = dot(r4.zw, float2(321.894196,1225.65479));
  r5.xy = sin(r3.zw);
  r5.z = sin(r4.x);
  r4.xyz = r5.xyz * float3(4251.48633,4251.48633,4251.48633) + cb0[15].yyy;
  r4.xyz = frac(r4.xyz);
  r5.xyzw = float4(1,0,0,1) + r2.zwzw;
  r6.xyzw = r5.xyzw * r1.xyzw;
  r3.z = dot(r6.xy, float2(321.894196,1225.65479));
  r7.xyzw = r5.xyxy * r1.xyxy + float4(0.100000001,0.100000001,0.200000003,0.200000003);
  r3.w = dot(r7.xy, float2(321.894196,1225.65479));
  r4.w = dot(r7.zw, float2(321.894196,1225.65479));
  r7.xy = sin(r3.zw);
  r7.z = sin(r4.w);
  r7.xyz = r7.xyz * float3(4251.48633,4251.48633,4251.48633) + cb0[15].yyy;
  r7.xyz = frac(r7.xyz);
  r3.z = dot(r6.zw, float2(321.894196,1225.65479));
  r5.xyzw = r5.zwzw * r1.zwzw + float4(0.100000001,0.100000001,0.200000003,0.200000003);
  r3.w = dot(r5.xy, float2(321.894196,1225.65479));
  r4.w = dot(r5.zw, float2(321.894196,1225.65479));
  r5.xy = sin(r3.zw);
  r5.z = sin(r4.w);
  r5.xyz = r5.xyz * float3(4251.48633,4251.48633,4251.48633) + cb0[15].yyy;
  r5.xyz = frac(r5.xyz);
  r2.xyzw = float4(1,1,1,1) + r2.xyzw;
  r3.zw = r2.zw * r1.zw;
  r3.z = dot(r3.zw, float2(321.894196,1225.65479));
  r1.xyzw = r2.xyzw * r1.xyzw + float4(0.100000001,0.100000001,0.200000003,0.200000003);
  r1.x = dot(r1.xy, float2(321.894196,1225.65479));
  r1.y = dot(r1.zw, float2(321.894196,1225.65479));
  r2.x = sin(r3.z);
  r2.yz = sin(r1.xy);
  r1.xyz = r2.xyz * float3(4251.48633,4251.48633,4251.48633) + cb0[15].yyy;
  r1.xyz = frac(r1.xyz);
  r2.xyz = r7.xyz + -r4.xyz;
  r2.xyz = r3.xxx * r2.xyz + r4.xyz;
  r1.xyz = r1.xyz + -r5.xyz;
  r1.xyz = r3.xxx * r1.xyz + r5.xyz;
  r1.xyz = r1.xyz + -r2.xyz;
  r1.xyz = r3.yyy * r1.xyz + r2.xyz;
  r2.xy = cmp(float2(0,0) < cb0[142].xz);
  if (r2.x != 0) {
    r2.xz = float2(20,20) * v1.xy;
    r3.xyzw = floor(r2.xzxz);
    r2.xz = v1.xy * float2(20,20) + -r3.zw;
    r1.w = 0.5 * cb0[15].y;
    r1.w = floor(r1.w);
    r3.xyzw = r3.xyzw + r1.wwww;
    r1.w = dot(r3.zw, float2(321.894196,1225.65479));
    r3.xyzw = float4(0.100000001,0.100000001,0.200000003,0.200000003) + r3.xyzw;
    r2.w = dot(r3.xy, float2(321.894196,1225.65479));
    r3.x = dot(r3.zw, float2(321.894196,1225.65479));
    r4.x = sin(r1.w);
    r4.y = sin(r2.w);
    r4.z = sin(r3.x);
    r3.xyz = r4.xyz * float3(4251.48633,4251.48633,4251.48633) + cb0[15].yyy;
    r3.xyz = frac(r3.xyz);
    r1.w = cmp(cb0[142].x < r3.x);
    r2.xz = float2(-0.5,-0.5) + r2.xz;
    r2.x = dot(r2.xz, r2.xz);
    r2.z = r3.y * 0.300000012 + 0.100000001;
    r2.z = r2.z * r2.z;
    r2.z = 1 / r2.z;
    r2.x = r2.x * r2.z;
    r2.x = min(1, r2.x);
    r2.z = r2.x * -2 + 3;
    r2.x = r2.x * r2.x;
    r2.x = -r2.z * r2.x + 1;
    r2.z = -0.5 + r3.z;
    r2.x = r2.x * r2.z;
    r2.x = cb0[142].y * r2.x;
    r1.w = r1.w ? r2.x : 0;
  } else {
    r1.w = 0;
  }
  if (r2.y != 0) {
    r2.x = dot(cb0[15].xyzw, float4(1,1,1,1));
    r2.x = floor(r2.x);
    r2.y = 321.894196 * r2.x;
    r2.y = sin(r2.y);
    r2.y = r2.y * 4251.48633 + cb0[15].y;
    r2.y = frac(r2.y);
    r2.y = cmp(cb0[142].z < r2.y);
    r2.xz = float2(0.100000001,0.200000003) + r2.xx;
    r2.xz = float2(321.894196,321.894196) * r2.xz;
    r2.xz = sin(r2.xz);
    r2.xz = r2.xz * float2(4251.48633,4251.48633) + cb0[15].yy;
    r2.xz = frac(r2.xz);
    r2.z = r2.z * 0.00300000003 + 0.00100000005;
    r2.x = v1.x + -r2.x;
    r2.z = 1 / r2.z;
    r2.x = abs(r2.x) * r2.z;
    r2.x = min(1, r2.x);
    r2.z = r2.x * -2 + 3;
    r2.x = r2.x * r2.x;
    r2.x = -r2.z * r2.x + 1;
    r2.x = r2.x * cb0[142].w + r1.w;
    r1.w = r2.y ? r2.x : r1.w;
  }
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = float3(1,0.949999988,1.04999995) * r1.xyz;
  r0.w = cb0[141].y * -r0.w + 1;
  r1.xyz = r1.xyz * r0.www;
  r1.xyz = r1.xyz * cb0[141].xxx + r1.www;
  r1.xyz = float3(1,1,1) + r1.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  if (injectedData.toneMapType == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  r1.xy = -cb0[169].xy + v1.xy;
  r2.x = cb0[170].x * r1.x;
  r2.y = cb0[169].z * r1.y;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = -cb0[169].w + r0.w;
  r1.x = -cb0[169].w + cb0[155].w;
  r0.w = saturate(r0.w / r1.x);
  r0.w = saturate(-cb0[155].z + r0.w);
  r1.xyz = -cb0[168].xyz + r0.xyz;
  r1.xyz = r0.www * r1.xyz + cb0[168].xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  o0.xyz = cb0[168].www * r1.xyz + r0.xyz;
  o0.w = 1;
  return;
}