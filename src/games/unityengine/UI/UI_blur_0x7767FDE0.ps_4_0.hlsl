#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[3];
}
cbuffer cb0 : register(b0){
  float4 cb0[22];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : INTERP0,
  float4 v2 : INTERP1,
  float3 v3 : INTERP2,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.SampleBias(s1_s, v1.xy, cb0[5].x).xyzw;
  if (r0.w == 0.0) discard;
  r1.y = cb0[4].y + -v0.y;
  r1.y = cb0[21].x < 0 ? r1.y : v0.y;
  r1.x = v0.x;
  r1.yz = r1.xy / cb0[4].xy;
  r1.xw = float2(1,1) + -r1.zz;
  r1.z = dot(r1.yw, float2(12.9898005,78.2330017));
  r1.z = sin(r1.z);
  r1.z = 43758.5469 * r1.z;
  r1.z = frac(r1.z);
  sincos(r1.z, r2.x, r3.x);
  r2.x = r2.x * cb1[0].x + r1.y;
  r2.y = r3.x * cb1[0].y + r1.x;
  r2.xyzw = t0.SampleBias(s0_s, r2.xy, cb0[5].x).xyzw;
  r3.xyzw = float4(1,2,3,4) + r1.zzzz;
  sincos(r3.x, r3.x, r4.x);
  r5.x = r3.x * cb1[0].x + r1.y;
  r5.y = r4.x * cb1[0].y + r1.x;
  r4.xyzw = t0.SampleBias(s0_s, r5.xy, cb0[5].x).xyzw;
  r2.xyz = r4.xyz + r2.xyz;
  sincos(r3.y, r3.x, r4.x);
  r3.x = r3.x * cb1[0].x + r1.y;
  r3.y = r4.x * cb1[0].y + r1.x;
  r4.xyzw = t0.SampleBias(s0_s, r3.xy, cb0[5].x).xyzw;
  sincos(r3.z, r3.x, r5.x);
  r3.x = r3.x * cb1[0].x + r1.y;
  r3.y = r5.x * cb1[0].y + r1.x;
  r5.xyzw = t0.SampleBias(s0_s, r3.xy, cb0[5].x).xyzw;
  r3.xyz = r5.xyz + r4.xyz;
  r2.xyz = r3.xyz + r2.xyz;
  sincos(r3.w, r3.x, r4.x);
  r3.x = r3.x * cb1[0].x + r1.y;
  r3.y = r4.x * cb1[0].y + r1.x;
  r3.xyzw = t0.SampleBias(s0_s, r3.xy, cb0[5].x).xyzw;
  r1.z = 5 + r1.z;
  sincos(r1.z, r4.x, r5.x);
  r4.x = r4.x * cb1[0].x + r1.y;
  r4.y = r5.x * cb1[0].y + r1.x;
  r1.xyzw = t0.SampleBias(s0_s, r4.xy, cb0[5].x).xyzw;
  r1.xyz = r3.xyz + r1.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = v2.xyz * r1.xyz;
  r1.xyz = r1.xyz * r0.xyz;
  r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r1.xyz;
  r1.xyz = float3(0.333333343,0.333333343,0.333333343) * r1.xyz;
  r3.xyz = r2.xyz * r2.xyz;
  r4.xyz = -cb1[2].xyz * float3(2,2,2) + float3(1,1,1);
  r3.xyz = r4.xyz * r3.xyz;
  r3.xyz = r1.xyz * cb1[2].xyz + r3.xyz;
  if(injectedData.toneMapType == 0.f){
  r2.xyz = sqrt(r2.xyz);
  } else {
  r2.xyz = renodx::math::SignSqrt(r2.xyz);
  }
  r4.xyz = cb1[2].xyz * float3(2,2,2) + float3(-1,-1,-1);
  r5.xyz = float3(1,1,1) + -cb1[2].xyz;
  r1.xyz = r5.xyz * r1.xyz;
  r1.xyz = r2.xyz * r4.xyz + r1.xyz;
  r4.xyz = step(0.5f, cb1[2].xyz);
  r2.xyz = 1.f - r4.xyz;
  r2.xyz = r2.xyz * r3.xyz;
  r0.xyz = r1.xyz * r4.xyz + r2.xyz;
  o0.xyzw = v2.xyzw * r0.xyzw;
  o0.w = saturate(o0.w);
  return;
}