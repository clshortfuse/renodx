#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Thu Oct 16 22:20:17 2025
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[8];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[23];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.z = dot(r0.xy, r0.xy);
  r0.zw = cb0[4].xy * r0.zz;
  r0.xy = r0.xy * r0.zz;
  r0.z = (int)r0.w;
  r0.z = (int)r0.z + 1;
  r0.z = max(3, (int)r0.z);
  r0.z = min(32, (int)r0.z);
  r0.w = (int)r0.z;
  r1.xyz = float3(0.5,1.5,2.5) / r0.www;
  r2.xyz = r1.xxx * float3(6,6,6) + float3(0,4,2);
  r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
  r2.xyz = frac(r2.xyz);
  r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
  r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
  r3.xyzw = -r0.xyxy * r1.xxyy + v1.xyxy;
  r4.xyzw = t0.SampleLevel(s0_s, r3.xy, 0).xyzw;
  r1.xyw = r1.yyy * float3(6,6,6) + float3(0,4,2);
  r1.xyw = float3(0.166666672,0.166666672,0.166666672) * r1.xyw;
  r1.xyw = frac(r1.xyw);
  r1.xyw = r1.xyw * float3(6,6,6) + float3(-3,-3,-3);
  r1.xyw = saturate(float3(-1,-1,-1) + abs(r1.xyw));
  r3.xyzw = t0.SampleLevel(s0_s, r3.zw, 0).xyzw;
  r3.xyz = r3.xyz * r1.xyw;
  r3.xyz = r4.xyz * r2.xyz + r3.xyz;
  r1.xyw = r2.xyz + r1.xyw;
  r2.xyz = r1.zzz * float3(6,6,6) + float3(0,4,2);
  r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
  r2.xyz = frac(r2.xyz);
  r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
  r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
  r4.xy = -r0.xy * r1.zz + v1.xy;
  r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r3.xyz = r4.xzy * r2.xzy + r3.xzy;
  r1.xyz = r2.xzy + r1.xwy;
  r2.xyzw = cmp(int4(3,4,5,6) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 3.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 4.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 5.5 / r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  if (r2.w != 0) {
    r1.w = 6.5 / r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  r2.xyzw = cmp(int4(7,8,9,10) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 7.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 8.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 9.5 / r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  if (r2.w != 0) {
    r1.w = 10.5 / r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  r2.xyzw = cmp(int4(11,12,13,14) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 11.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 12.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 13.5 / r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  if (r2.w != 0) {
    r1.w = 14.5 / r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  r2.xyzw = cmp(int4(15,16,17,18) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 15.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 16.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 17.5 / r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  if (r2.w != 0) {
    r1.w = 18.5 / r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  r2.xyzw = cmp(int4(19,20,21,22) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 19.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 20.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 21.5 / r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  if (r2.w != 0) {
    r1.w = 22.5 / r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  r2.xyzw = cmp(int4(23,24,25,26) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 23.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 24.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 25.5 / r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  if (r2.w != 0) {
    r1.w = 26.5 / r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  r2.xyzw = cmp(int4(27,28,29,30) < (int4)r0.zzzz);
  if (r2.x != 0) {
    r1.w = 27.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.y != 0) {
    r1.w = 28.5 / r0.w;
    r4.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xzy * r4.xzy + r3.xyz;
    r1.xyz = r4.xzy + r1.xyz;
  }
  if (r2.z != 0) {
    r1.w = 29.5 / r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  if (r2.w != 0) {
    r0.w = 30.5 / r0.w;
    r2.xyz = r0.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r0.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xzy * r2.xzy + r3.xyz;
    r1.xyz = r2.xzy + r1.xyz;
  }
  r0.z = cmp(31 < (int)r0.z);
  if (r0.z != 0) {
    r0.xy = -r0.xy * float2(0.984375,0.984375) + v1.xy;
    r0.xyzw = t0.SampleLevel(s0_s, r0.xy, 0).xyzw;
    r3.xy = r0.xz * float2(1,0.0937497616) + r3.xy;
    r1.xy = float2(1,0.0937497616) + r1.xy;
  }
  r0.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) + r1.xzy;
  r0.xyz = r3.xzy / r0.xyz;
  r1.xw = float2(0,0);
  r1.yz = cb0[2].yx;
  r2.xyz = v2.xyw + -r1.xyx;
  r2.xyzw = t1.SampleLevel(s1_s, r2.xy, r2.z).xyzw;
  r0.w = cb1[7].x * r2.x + cb1[7].y;
  r0.w = 1 / r0.w;
  r2.xyz = v2.xyw + -r1.zww;
  r2.xyzw = t1.SampleLevel(s1_s, r2.xy, r2.z).xyzw;
  r2.x = cb1[7].x * r2.x + cb1[7].y;
  r2.x = 1 / r2.x;
  r2.yzw = v2.xyw + r1.zww;
  r3.xyzw = t1.SampleLevel(s1_s, r2.yz, r2.w).xyzw;
  r2.y = cb1[7].x * r3.x + cb1[7].y;
  r2.y = 1 / r2.y;
  r3.xyz = v2.xyw + r1.xyx;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xy, r3.z).xyzw;
  r2.z = cb1[7].x * r3.x + cb1[7].y;
  r2.z = 1 / r2.z;
  r2.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r3.x = max(r2.z, r0.w);
  r3.x = max(r3.x, r2.x);
  r3.x = max(r3.x, r2.y);
  r0.w = min(r2.z, r0.w);
  r0.w = min(r0.w, r2.x);
  r0.w = min(r0.w, r2.y);
  r0.w = r3.x + -r0.w;
  r0.w = 9.99999975e-06 + r0.w;
  r3.xyzw = v1.xyxy + -r1.xyzw;
  r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r1.xyzw = v1.xyxy + r1.zwxy;
  r5.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.x = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  r1.y = dot(r5.xyz, float3(0.298999995,0.587000012,0.114));
  r1.z = dot(r3.xyz, float3(0.298999995,0.587000012,0.114));
  r1.w = dot(r4.xyz, float3(0.298999995,0.587000012,0.114));
  r2.y = max(r1.x, r1.w);
  r2.y = max(r2.y, r1.z);
  r2.y = max(r2.y, r1.y);
  r1.x = min(r1.x, r1.w);
  r1.x = min(r1.x, r1.z);
  r1.x = min(r1.x, r1.y);
  r1.x = -9.99999997e-07 + r1.x;
  r1.y = r2.w * 2 + -r1.x;
  r1.y = r1.y + -r2.y;
  r1.x = r2.y + -r1.x;
  r1.x = saturate(cb0[8].w / r1.x);
  r1.z = -cb0[9].z + r2.x;
  r1.z = cb0[9].w / abs(r1.z);
  r1.w = cmp(1 < r1.z);
  r1.w = r1.w ? 1.000000 : 0;
  r1.z = saturate(cb0[16].z * r1.z);
  r1.z = max(r1.w, r1.z);
  r0.w = saturate(cb0[8].y / r0.w);
  r1.x = r1.y * r1.x;
  r0.w = r1.x * r0.w;
  r0.w = cb0[8].x * r0.w;
  r0.w = max(-cb0[8].z, r0.w);
  r0.w = min(cb0[8].z, r0.w);
  r0.w = r0.w * r1.z + 1;
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r1.xyz = cb0[14].xxx * r1.xyz;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r0.xyz = cb0[7].xxx * r0.xyz;

  float3 untonemapped = r0.xyz;
  float3 hdr_color = CustomTonemap(untonemapped);
  float3 sdr_color = CustomGradingBegin(hdr_color);
  r0.xyz = sdr_color;

  // r1.xyz = r0.xyz * float3(2.50999999,2.50999999,2.50999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  // r1.xyz = r1.xyz * r0.xyz;
  // r3.xyz = r0.xyz * float3(2.43000007,2.43000007,2.43000007) + float3(0.589999974,0.589999974,0.589999974);
  // r0.xyz = r0.xyz * r3.xyz + float3(0.140000001,0.140000001,0.140000001);
  // r0.xyz = r1.xyz / r0.xyz;

  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.w = -1 + cb0[5].w;
  r1.xyz = min(float3(1,1,1), r0.xyz);
  r1.w = r1.z * r0.w;
  r1.xy = r1.xy * r0.ww + float2(0.5,0.5);
  r3.zw = cb0[5].xy * r1.xy;
  r1.x = floor(r1.w);
  r3.y = r1.x * cb0[5].y + r3.z;
  r3.x = cb0[5].y + r3.y;
  r4.xyzw = t3.Sample(s3_s, r3.yw).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.xw).xyzw;
  r0.w = r1.z * r0.w + -r1.x;
  r1.xyz = r3.xyz + -r4.xyz;
  r1.xyz = r0.www * r1.xyz + r4.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[10].www * r1.xyz + r0.xyz;
  r1.xyz = r0.xyz * float3(0.305306017,0.305306017,0.305306017) + float3(0.682171106,0.682171106,0.682171106);
  r1.xyz = r0.xyz * r1.xyz + float3(0.0125228781,0.0125228781,0.0125228781);
  r3.xyz = r1.xyz * r0.xyz;
  r0.w = max(r3.y, r3.z);
  r0.w = max(r3.x, r0.w);
  r1.w = min(r3.y, r3.z);
  r1.w = min(r3.x, r1.w);
  r0.w = saturate(-r1.w + r0.w);
  r0.w = 1 + -r0.w;
  r0.w = cb0[7].z * r0.w;
  r1.w = dot(r3.xyz, float3(0.298999995,0.587000012,0.114));
  r0.xyz = r0.xyz * r1.xyz + -r1.www;
  r0.xyz = r0.www * r0.xyz + float3(1,1,1);
  r0.xyz = r3.xyz * r0.xyz;
  r1.xyz = r0.xyz * cb0[11].xyz + -r0.xyz;
  r0.xyz = cb0[11].www * r1.xyz + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[7].yyy + float3(0.5,0.5,0.5);
  r1.xy = -cb0[16].xy + w1.xy;
  r1.z = cb0[18].x * r1.y;
  r0.w = dot(r1.xz, r1.xz);
  r0.w = saturate(cb0[17].w * r0.w + cb0[22].z);
  r1.xyz = r2.www * cb0[17].xyz + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r1.xy = cb1[6].xy * v1.xy;
  r0.w = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r0.www;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r0.w = cmp(r2.x >= cb0[9].y);
  r0.w = r0.w ? 1.000000 : 0;
  r0.w = cb0[9].x * r0.w;
  r1.xyz = r0.www * r1.xyz + float3(1,1,1);
  o0.xyz = r1.xyz * r0.xyz;
  o0.w = 1;

  float3 graded_color = o0.xyz;
  float3 upgraded_color = CustomGradingEnd(hdr_color, sdr_color, graded_color);
  o0.xyz = upgraded_color;

  //o0.rgb = hdr_color;

  o0.rgb = CustomIntermediatePass(o0.rgb);
  return;
}