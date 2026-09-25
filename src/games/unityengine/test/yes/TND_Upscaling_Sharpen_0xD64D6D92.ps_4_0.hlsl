#include "../../shared.h"

Texture2D<float4> t0 : register(t0);
cbuffer cb0 : register(b0){
  float4 cb0[2];
}

void main(
  float4 v0 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(0,0);
  r0.xy = (uint2)v0.xy;
  r1.xyzw = t0.Load(r0.xyz).xyzw;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
  r1.xyz = max(float3(0,0,0), r1.xyz);
  }
  r1.xyz = min(float3(65504,65504,65504), r1.xyz);
  r0.z = r1.x * 0.5 + r1.y;
  r0.z = r1.z * 0.5 + r0.z;
  r2.xyzw = (int4)r0.xyxy + int4(0,-1,-1,0);
  r3.xyzw = (int4)r0.xyxy + int4(0,1,1,0);
  r4.xy = r2.zw;
  r4.zw = float2(0,0);
  r4.xyzw = t0.Load(r4.xyz).xyzw;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
  r0.xyw = max(float3(0,0,0), r4.xyz);
  }
  r0.xyw = min(float3(65504,65504,65504), r0.xyw);
  r1.w = r0.x * 0.5 + r0.y;
  r1.w = r0.w * 0.5 + r1.w;
  r4.x = max(r1.w, r0.z);
  r2.zw = float2(0,0);
  r2.xyzw = t0.Load(r2.xyz).xyzw;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
  r2.xyz = max(float3(0,0,0), r2.xyz);
  }
  r2.xyz = min(float3(65504,65504,65504), r2.xyz);
  r2.w = r2.x * 0.5 + r2.y;
  r2.w = r2.z * 0.5 + r2.w;
  r4.x = max(r2.w, r4.x);
  r5.xy = r3.zw;
  r5.zw = float2(0,0);
  r5.xyzw = t0.Load(r5.xyz).xyzw;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
  r4.yzw = max(float3(0,0,0), r5.xyz);
  }
  r4.yzw = min(float3(65504,65504,65504), r4.yzw);
  r5.x = r4.y * 0.5 + r4.z;
  r5.x = r4.w * 0.5 + r5.x;
  r3.zw = float2(0,0);
  r3.xyzw = t0.Load(r3.xyz).xyzw;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
  r3.xyz = max(float3(0,0,0), r3.xyz);
  }
  r3.xyz = min(float3(65504,65504,65504), r3.xyz);
  r3.w = r3.x * 0.5 + r3.y;
  r3.w = r3.z * 0.5 + r3.w;
  r5.y = max(r5.x, r3.w);
  r4.x = max(r5.y, r4.x);
  r5.y = min(r1.w, r0.z);
  r1.w = 0.25 * r1.w;
  r1.w = r2.w * 0.25 + r1.w;
  r2.w = min(r5.y, r2.w);
  r1.w = r5.x * 0.25 + r1.w;
  r5.x = min(r5.x, r3.w);
  r1.w = r3.w * 0.25 + r1.w;
  r0.z = r1.w + -r0.z;
  r1.w = min(r5.x, r2.w);
  r1.w = r4.x + -r1.w;
  r2.w = asfloat(2129764351u - asuint(r1.w));
  r1.w = -r2.w * r1.w + 2;
  r1.w = r2.w * r1.w;
  r0.z = saturate(r1.w * abs(r0.z));
  r0.z = r0.z * -0.5 + 1;
  r5.xyz = max(r4.yzw, r0.xyw);
  r5.xyz = max(r5.xyz, r2.xyz);
  r5.xyz = max(r5.xyz, r3.xyz);
  r6.xyz = float3(4,4,4) * r5.xyz;
  r5.xyz = float3(1,1,1) + -r5.xyz;
  r6.xyz = float3(1,1,1) / r6.xyz;
  r7.xyz = min(r4.yzw, r0.xyw);
  r7.xyz = min(r7.xyz, r2.xyz);
  r7.xyz = min(r7.xyz, r3.xyz);
  r6.xyz = r7.xyz * r6.xyz;
  r7.xyz = r7.xyz * float3(4,4,4) + float3(-4,-4,-4);
  r7.xyz = float3(1,1,1) / r7.xyz;
  r5.xyz = r7.xyz * r5.xyz;
  r5.xyz = max(-r6.xyz, r5.xyz);
  r1.w = max(r5.y, r5.z);
  r1.w = max(r5.x, r1.w);
  r1.w = min(0, r1.w);
  r1.w = max(-0.1875, r1.w);
  r1.w = cb0[1].x * r1.w;
  r0.z = r1.w * r0.z;
  r0.xyw = r0.zzz * r0.xyw;
  r0.xyw = r0.zzz * r2.xyz + r0.xyw;
  r0.xyw = r0.zzz * r3.xyz + r0.xyw;
  r0.xyw = r0.zzz * r4.yzw + r0.xyw;
  r0.z = r0.z * 4 + 1;
  r0.xyw = r0.xyw + r1.xyz;
  r1.x = asfloat(2129764351u - asuint(r0.z));
  r0.z = -r1.x * r0.z + 2;
  r0.z = r1.x * r0.z;
  o0.xyz = r0.xyw * r0.zzz;
  o0.w = 1;
  return;
}