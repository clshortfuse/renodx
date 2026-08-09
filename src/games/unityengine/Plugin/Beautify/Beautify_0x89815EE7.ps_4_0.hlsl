#include "../../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[135];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.z = dot(r0.xy, r0.xy);
  r0.zw = cb0[134].xy * r0.zz * injectedData.fxCA;
  r0.xy = r0.xy * r0.zz;
  r0.z = (int)r0.w;
  r0.z = (int)r0.z + 1;
  r0.z = max(3, (int)r0.z);
  r0.z = min(32, (int)r0.z);
  r0.w = (int)r0.z;
  r1.xyz = float3(0.5,1.5,2.5) / r0.www;
  r2.xyz = cb0[134].zzz + r1.xyz;
  r3.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
  r3.xyz = float3(0.166666672,0.166666672,0.166666672) * r3.xyz;
  r3.xyz = (r3.xyz >= -r3.xyz) ? frac(abs(r3.xyz)) : -frac(abs(r3.xyz));
  r3.xyz = r3.xyz * float3(6,6,6) + float3(-3,-3,-3);
  r3.xyz = saturate(float3(-1,-1,-1) + abs(r3.xyz));
  r4.xyzw = -r0.xyxy * r1.xxyy + v1.xyxy;
  r5.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r1.xyw = float3(9.99999975e-005,9.99999975e-005,9.99999975e-005) + r3.xyz;
  r2.xyw = r2.yyy * float3(6,6,6) + float3(0,4,2);
  r2.xyw = float3(0.166666672,0.166666672,0.166666672) * r2.xyw;
  r2.xyw = (r2.xyw >= -r2.xyw) ? frac(abs(r2.xyw)) : -frac(abs(r2.xyw));
  r2.xyw = r2.xyw * float3(6,6,6) + float3(-3,-3,-3);
  r2.xyw = saturate(float3(-1,-1,-1) + abs(r2.xyw));
  r4.xyzw = t0.SampleLevel(s0_s, r4.zw, 0).xyzw;
  r4.xyz = r4.xyz * r2.xyw;
  r3.xyz = r5.xyz * r3.xyz + r4.xyz;
  r1.xyw = r2.xyw + r1.xyw;
  r2.xyz = r2.zzz * float3(6,6,6) + float3(0,4,2);
  r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
  r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
  r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
  r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
  r4.xy = -r0.xy * r1.zz + v1.xy;
  r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r3.xyz = r4.xyz * r2.xyz + r3.xyz;
  r1.xyz = r2.xyz + r1.xyw;
  if ((int)r0.z > 3) {
    r1.w = 3.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 4) {
    r1.w = 4.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 5) {
    r1.w = 5.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 6) {
    r1.w = 6.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 7) {
    r1.w = 7.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 8) {
    r1.w = 8.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 9) {
    r1.w = 9.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 10) {
    r1.w = 10.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 11) {
    r1.w = 11.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 12) {
    r1.w = 12.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 13) {
    r1.w = 13.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 14) {
    r1.w = 14.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 15) {
    r1.w = 15.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 16) {
    r1.w = 16.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 17) {
    r1.w = 17.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 18) {
    r1.w = 18.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 19) {
    r1.w = 19.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 20) {
    r1.w = 20.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 21) {
    r1.w = 21.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 22) {
    r1.w = 22.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 23) {
    r1.w = 23.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 24) {
    r1.w = 24.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 25) {
    r1.w = 25.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 26) {
    r1.w = 26.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 27) {
    r1.w = 27.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 28) {
    r1.w = 28.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if ((int)r0.z > 29) {
    r1.w = 29.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 30) {
    r0.w = 30.5 / r0.w;
    r1.w = cb0[134].z + r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r0.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if ((int)r0.z > 31) {
    r0.z = 0.984375 + cb0[134].z;
    r2.xyz = r0.zzz * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r0.xy = -r0.xy * float2(0.984375,0.984375) + v1.xy;
    r0.xyzw = t0.SampleLevel(s0_s, r0.xy, 0).xyzw;
    r3.xyz = r0.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  o0.xyz = r3.xyz / r1.xyz;
  o0.w = 1;
  return;
}