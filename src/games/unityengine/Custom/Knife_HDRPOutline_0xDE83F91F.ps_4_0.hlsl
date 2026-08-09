#include "../shared.h"

Texture2D<float4> t2 : register(t2);
Texture2DArray<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[47];
}
cbuffer cb0 : register(b0){
  float4 cb0[2];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(0,0);
  r1.x = round(cb0[0].w);
  r1.xw = (int2)r1.xx;
  r1.y = 0;
  r2.xyzw = float4(0.707106769,-4.37113883e-08,-0.707106769,-8.74227766e-08) * cb0[0].wwww;
  r2.xyzw = round(r2.xyzw);
  r1.z = (int)r2.y;
  r3.xy = cb1[46].xy * v1.xy;
  r3.xy = (uint2)r3.xy;
  r1.xyzw = (int4)r1.xyzw + (int4)r3.xyxy;
  r1.xyzw = (int4)r1.xyzw;
  r1.xyzw = max(float4(0,0,0,0), r1.xyzw);
  r1.xyzw = min(cb1[46].xyxy, r1.xyzw);
  r0.xy = (int2)r1.xy;
  r1.xy = (int2)r1.zw;
  r0.xyzw = t2.Load(r0.xyz).xyzw;
  r0.xyz = r0.xyz * r0.www;
  r0.w = max(0, r0.w);
  r4.xyzw = (int4)r2.xxzx;
  r2.y = (int)r2.w;
  r4.xyzw = (int4)r3.xyxy + (int4)r4.xyzw;
  r4.xyzw = (int4)r4.xyzw;
  r4.xyzw = max(float4(0,0,0,0), r4.xyzw);
  r4.xyzw = min(cb1[46].xyxy, r4.xyzw);
  r4.xyzw = (int4)r4.zwxy;
  r5.xy = r4.zw;
  r5.zw = float2(0,0);
  r5.xyzw = t2.Load(r5.xyz).xyzw;
  r6.x = 1 + -r5.w;
  r5.xyz = r5.xyz * r5.www;
  r0.w = max(r5.w, r0.w);
  r0.xyz = r0.xyz * r6.xxx + r5.xyz;
  r1.zw = float2(0,0);
  r1.xyzw = t2.Load(r1.xyz).xyzw;
  r5.x = 1 + -r1.w;
  r1.xyz = r1.xyz * r1.www;
  r0.w = max(r1.w, r0.w);
  r0.xyz = r0.xyz * r5.xxx + r1.xyz;
  r4.zw = float2(0,0);
  r1.xyzw = t2.Load(r4.xyz).xyzw;
  r4.x = 1 + -r1.w;
  r1.xyz = r1.xyz * r1.www;
  r0.w = max(r1.w, r0.w);
  r0.xyz = r0.xyz * r4.xxx + r1.xyz;
  r1.x = round(-cb0[0].w);
  r2.xw = (int2)r1.xx;
  r1.xyzw = float4(-0.70710665,-0.707106888,1.19248806e-08,0.707107008) * cb0[0].wwww;
  r1.xyzw = round(r1.xyzw);
  r2.z = (int)r1.z;
  r1.xyz = (int3)r1.xyw;
  r2.xyzw = (int4)r2.xyzw + (int4)r3.xyxy;
  r2.xyzw = (int4)r2.xyzw;
  r2.xyzw = max(float4(0,0,0,0), r2.xyzw);
  r2.xyzw = min(cb1[46].xyxy, r2.xyzw);
  r4.xy = (int2)r2.xy;
  r2.xy = (int2)r2.zw;
  r4.zw = float2(0,0);
  r4.xyzw = t2.Load(r4.xyz).xyzw;
  r5.x = 1 + -r4.w;
  r4.xyz = r4.xyz * r4.www;
  r0.w = max(r4.w, r0.w);
  r0.xyz = r0.xyz * r5.xxx + r4.xyz;
  r4.x = -0.707106531 * cb0[0].w;
  r4.x = round(r4.x);
  r1.w = (int)r4.x;
  r1.xyzw = (int4)r1.xyzw + (int4)r3.xyxy;
  r1.xyzw = (int4)r1.xyzw;
  r1.xyzw = max(float4(0,0,0,0), r1.xyzw);
  r1.xyzw = min(cb1[46].xyxy, r1.xyzw);
  r4.xy = (int2)r1.xy;
  r1.xy = (int2)r1.zw;
  r4.zw = float2(0,0);
  r4.xyzw = t2.Load(r4.xyz).xyzw;
  r5.x = 1 + -r4.w;
  r4.xyz = r4.xyz * r4.www;
  r0.w = max(r4.w, r0.w);
  r0.xyz = r0.xyz * r5.xxx + r4.xyz;
  r2.zw = float2(0,0);
  r2.xyzw = t2.Load(r2.xyz).xyzw;
  r4.x = 1 + -r2.w;
  r2.xyz = r2.xyz * r2.www;
  r0.w = max(r2.w, r0.w);
  r0.xyz = r0.xyz * r4.xxx + r2.xyz;
  r1.zw = float2(0,0);
  r1.xyzw = t2.Load(r1.xyz).xyzw;
  r2.x = 1 + -r1.w;
  r1.xyz = r1.xyz * r1.www;
  r4.w = max(r1.w, r0.w);
  r4.xyz = r0.xyz * r2.xxx + r1.xyz;
  r3.zw = float2(0,0);
  r0.xyzw = t2.Load(r3.xyw).xyzw;
  r1.xyzw = t1.Load(r3.xyzw).xyzw;
  r2.x = saturate(100 * r0.w);
  r2.y = r2.x * -2 + 3;
  r2.x = r2.x * r2.x;
  r2.x = -r2.y * r2.x + 1;
  r3.xyzw = r4.xyzw * r2.xxxx;
  r2.xyzw = -r4.xyzw * r2.xxxx + r4.xyzw;
  r2.xyzw = cb0[1].xxxx * r2.xyzw + r3.xyzw;
  r3.xy = cb0[0].xy * v1.xy;
  r3.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.x = cb0[0].z * r3.x;
  r0.xyzw = r3.xxxx * r0.xyzw + r2.xyzw;
  r2.x = 1 + -r0.w;
  r0.xyz = r0.xyz * r0.www;
  r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  r0.xyz = r1.xyz * r2.xxx + r0.xyz;
  r1.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  o0.xyzw = r1.xyzw;
  return;
}