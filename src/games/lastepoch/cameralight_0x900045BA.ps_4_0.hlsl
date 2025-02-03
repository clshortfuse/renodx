#include "./common.hlsl"

Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2) {
  float4 cb2[9];
}
cbuffer cb1 : register(b1) {
  float4 cb1[9];
}
cbuffer cb0 : register(b0) {
  float4 cb0[18];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.x = 1 + -r0.x;
  r0.yz = cb1[5].yz + -cb1[5].zy;
  r0.xy = r0.xx * r0.yz + cb1[5].zy;
  r0.z = cb1[5].y * cb1[5].z;
  r0.x = r0.z / r0.x;
  r0.y = r0.y + -r0.x;
  r0.x = cb1[8].w * r0.y + r0.x;
  r0.y = 1 + -r0.x;
  r0.y = cb1[8].w * r0.y + r0.x;
  r0.zw = v1.xy * float2(2, 2) + float2(-1, -1);
  r0.zw = -cb2[8].xy + r0.zw;
  r1.x = r0.z / cb2[6].x;
  r1.y = r0.w / cb2[7].y;
  r0.yz = r1.xy * r0.yy;
  r1.xyz = cb0[15].xyz * r0.zzz;
  r0.yzw = cb0[14].xyz * r0.yyy + r1.xyz;
  r0.xyz = cb0[16].xyz * -r0.xxx + r0.yzw;
  r0.xyz = cb0[17].xyz + r0.xyz;
  r1.xyz = -cb0[4].xyz + r0.xyz;
  r0.xyz = -cb1[4].xyz + r0.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r1.w = sqrt(r0.w);
  r2.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r2.z = -r2.x + r1.w;
  r1.w = cmp(r2.x >= r1.w);
  r2.x = -r2.x * r2.x + r2.y;
  r2.x = max(cb0[13].x, r2.x);
  r1.w = r1.w ? 1.000000 : 0;
  r2.y = r2.z * r2.z + r2.x;
  r2.x = r2.x / r2.y;
  r1.w = max(r2.x, r1.w);
  r1.w = -r1.w * cb0[13].y + 1;
  r2.x = cb0[4].w * r0.w;
  r0.w = rsqrt(r0.w);
  r2.xyzw = t1.Sample(s1_s, r2.xx).xyzw;
  r1.w = r2.x * r1.w;
  r2.xyz = cb0[5].xyz * r1.www;
  r1.w = dot(r0.xyz, r0.xyz);
  r1.w = rsqrt(r1.w);
  r0.xyz = r1.www * r0.xyz;
  r3.xyz = -r1.xyz * r0.www + -r0.xyz;
  r1.xyz = r1.xyz * r0.www;
  r0.w = dot(r3.xyz, r3.xyz);
  r0.w = max(0.00100000005, r0.w);
  r0.w = rsqrt(r0.w);
  r3.xyz = r3.xyz * r0.www;
  r4.xyzw = t5.Sample(s5_s, v1.xy).xyzw;
  r4.xyz = r4.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
  r0.w = dot(r4.xyz, r4.xyz);
  r0.w = rsqrt(r0.w);
  r4.xyz = r4.xyz * r0.www;
  r0.w = saturate(dot(r4.xyz, r3.xyz));
  r1.w = saturate(dot(-r1.xyz, r3.xyz));
  r1.x = saturate(dot(r4.xyz, -r1.xyz));
  r0.x = dot(r4.xyz, -r0.xyz);
  r3.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
  r4.xyzw = float4(1, 1, 1, 1) + -r3.wxyz;
  r0.y = r4.x * r4.x;
  r0.y = max(0.00200000009, r0.y);
  r0.z = r0.y * r0.y;
  r1.y = r0.w * r0.z + -r0.w;
  r0.w = r1.y * r0.w + 1;
  r0.w = r0.w * r0.w + 1.00000001e-07;
  r0.z = 0.318309873 * r0.z;
  r0.z = r0.z / r0.w;
  r0.w = 1 + -r0.y;
  r1.y = abs(r0.x) * r0.w + r0.y;
  r0.y = r1.x * r0.w + r0.y;
  r0.y = abs(r0.x) * r0.y;
  r0.x = 1 + -abs(r0.x);
  r0.y = r1.x * r1.y + r0.y;
  r0.y = 9.99999975e-06 + r0.y;
  r0.y = 0.5 / r0.y;
  r0.y = r0.y * r0.z;
  r0.y = 3.14159274 * r0.y;
  r0.y = r0.y * r1.x;
  r0.y = max(0, r0.y);
  r0.z = dot(r3.xyz, r3.xyz);
  r0.z = cmp(r0.z != 0.000000);
  r0.z = r0.z ? 1.000000 : 0;
  r0.y = r0.y * r0.z;
  r0.yzw = r0.yyy * r2.xyz;
  r1.y = 1 + -r1.w;
  r1.z = r1.y * r1.y;
  r1.z = r1.z * r1.z;
  r1.y = r1.z * r1.y;
  r3.xyz = r4.yzw * r1.yyy + r3.xyz;
  r0.yzw = r3.xyz * r0.yzw;
  r1.y = r0.x * r0.x;
  r1.y = r1.y * r1.y;
  r0.x = r1.y * r0.x;
  r1.y = r1.w + r1.w;
  r1.y = r1.y * r1.w;
  r1.y = r1.y * r4.x + -0.5;
  r0.x = r1.y * r0.x + 1;
  r1.z = 1 + -r1.x;
  r1.w = r1.z * r1.z;
  r1.w = r1.w * r1.w;
  r1.z = r1.w * r1.z;
  r1.y = r1.y * r1.z + 1;
  r0.x = r1.y * r0.x;
  r0.x = r0.x * r1.x;
  r1.xyz = r2.xyz * r0.xxx;
  r2.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  if (injectedData.fxCameraLight == 1.f) {
    o0.xyz = r2.xyz * r1.xyz + r0.yzw;
  } else {
    o0.rgb = 0;
  }
  o0.w = 1;
  return;
}
