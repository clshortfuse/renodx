#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float4 v0 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[0].xx + v0.xy;
  r0.xy = cb0[2].xy * r0.xy;
  r0.z = t1.Sample(s1_s, r0.xy).x;
  r0.w = r0.z * cb0[2].w + -cb0[1].x;
  r0.z = 0.999899983 + -r0.z;
  r0.z = ceil(r0.z);
  r0.w = saturate(r0.w / cb0[1].y);
  r1.y = r0.w * r0.z;
  r1.xzw = float3(0.66,0.66,0.66) * r1.yyy;
  r2.xy = cb0[2].xy * r1.xx * injectedData.fxBlur;
  r2.zw = -r2.yx;
  r3.xyzw = r2.xzwy * r1.xxxx + r0.xyxy;
  r4.xyz = t0.Sample(s0_s, r3.xy).xyz;
  r3.xyz = t0.Sample(s0_s, r3.zw).xyz;
  r0.zw = -r2.xy * r1.xx + r0.xy;
  r2.xy = r2.xy * r1.xx + r0.xy;
  r2.xyz = t0.Sample(s0_s, r2.xy).xyz;
  r5.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r4.xyz = r5.xyz + r4.xyz;
  o0.w = r5.w;
  r3.xyz = r4.xyz + r3.xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r3.x = -cb0[2].x * injectedData.fxBlur;
  r3.yw = float2(0,0);
  r0.zw = r3.xy * r1.zy + r0.xy;
  r4.xyz = t0.Sample(s0_s, r0.zw).xyz;
  r2.xyz = r4.xyz + r2.xyz;
  r3.z = cb0[2].x * injectedData.fxBlur;
  r0.zw = r3.zw * r1.wy + r0.xy;
  r3.xyz = t0.Sample(s0_s, r0.zw).xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r3.y = -cb0[2].y * injectedData.fxBlur;
  r3.xz = float2(0,0);
  r0.zw = r3.xy * r1.yw + r0.xy;
  r4.xyz = t0.Sample(s0_s, r0.zw).xyz;
  r2.xyz = r4.xyz + r2.xyz;
  r3.w = cb0[2].y * injectedData.fxBlur;
  r0.xy = r3.zw * r1.yw + r0.xy;
  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r0.xyz = r2.xyz + r0.xyz;
  o0.xyz = float3(0.125,0.125,0.125) * r0.xyz;
  return;
}