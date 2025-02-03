#include "./common.hlsl"

Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerComparisonState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb3 : register(b3) {
  float4 cb3[26];
}
cbuffer cb2 : register(b2) {
  float4 cb2[22];
}
cbuffer cb1 : register(b1) {
  float4 cb1[8];
}
cbuffer cb0 : register(b0) {
  float4 cb0[11];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float3 v2: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 + -cb3[24].x;
  r0.y = cb1[5].z / v2.z;
  r0.yzw = v2.xyz * r0.yyy;
  r1.xy = v1.xy / v1.ww;
  if (injectedData.fxCameraLight == 0.f) {
    r2.rgba = 0;
  } else {
    r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  }
  r1.z = cb1[7].x * r2.x + cb1[7].y;
  r1.z = 1 / r1.z;
  r2.xyz = r1.zzz * r0.yzw;
  r3.xyz = cb2[19].xyz * r2.yyy;
  r2.xyw = cb2[18].xyz * r2.xxx + r3.xyz;
  r2.xyw = cb2[20].xyz * r2.zzz + r2.xyw;
  r2.xyw = cb2[21].xyz + r2.xyw;
  r3.xyzw = cb3[9].xyzw * r2.yyyy;
  r3.xyzw = cb3[8].xyzw * r2.xxxx + r3.xyzw;
  r3.xyzw = cb3[10].xyzw * r2.wwww + r3.xyzw;
  r3.xyzw = cb3[11].xyzw + r3.xyzw;
  r3.xyz = r3.xyz / r3.www;
  r0.y = t6.SampleCmpLevelZero(s3_s, r3.xy, r3.z).x;
  r0.x = r0.y * r0.x + cb3[24].x;
  r3.xyz = -cb3[25].xyz + r2.xyw;
  r0.y = dot(r3.xyz, r3.xyz);
  r0.y = sqrt(r0.y);
  r0.y = -r0.w * r1.z + r0.y;
  r0.y = cb3[25].w * r0.y + r2.z;
  r0.y = saturate(r0.y * cb3[24].z + cb3[24].w);
  r0.x = saturate(r0.x + r0.y);
  r0.yzw = cb0[8].xyw * r2.yyy;
  r0.yzw = cb0[7].xyw * r2.xxx + r0.yzw;
  r0.yzw = cb0[9].xyw * r2.www + r0.yzw;
  r0.yzw = cb0[10].xyw + r0.yzw;
  r0.yz = r0.yz / r0.ww;
  r0.w = cmp(r0.w < 0);
  r0.w = r0.w ? 1.000000 : 0;
  r3.xyzw = t1.SampleBias(s2_s, r0.yz, -8).xyzw;
  r0.y = r3.w * r0.w;
  r3.xyz = cb0[4].xyz + -r2.xyw;
  r2.xyz = -cb1[4].xyz + r2.xyw;
  r0.z = dot(r3.xyz, r3.xyz);
  r0.w = cb0[4].w * r0.z;
  r0.z = rsqrt(r0.z);
  r4.xyzw = t2.Sample(s1_s, r0.ww).xyzw;
  r0.y = r4.x * r0.y;
  r0.x = r0.y * r0.x;
  r0.y = dot(-cb0[3].xyz, r3.xyz);
  r0.w = saturate(1 + -cb0[5].w);
  r0.y = saturate(-r0.w * 20 + r0.y);
  r0.x = r0.y * r0.x;
  r0.xyw = cb0[5].xyz * r0.xxx;
  r1.z = dot(r2.xyz, r2.xyz);
  r1.z = rsqrt(r1.z);
  r2.xyz = r2.xyz * r1.zzz;
  r4.xyz = r3.xyz * r0.zzz + -r2.xyz;
  r3.xyz = r3.xyz * r0.zzz;
  r0.z = dot(r4.xyz, r4.xyz);
  r0.z = max(0.00100000005, r0.z);
  r0.z = rsqrt(r0.z);
  r4.xyz = r4.xyz * r0.zzz;
  r5.xyzw = t5.Sample(s6_s, r1.xy).xyzw;
  r5.xyz = r5.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
  r0.z = dot(r5.xyz, r5.xyz);
  r0.z = rsqrt(r0.z);
  r5.xyz = r5.xyz * r0.zzz;
  r0.z = saturate(dot(r5.xyz, r4.xyz));
  r1.z = saturate(dot(r3.xyz, r4.xyz));
  r1.w = saturate(dot(r5.xyz, r3.xyz));
  r2.x = dot(r5.xyz, -r2.xyz);
  r3.xyzw = t4.Sample(s5_s, r1.xy).xyzw;
  r4.xyzw = t3.Sample(s4_s, r1.xy).xyzw;
  r5.xyzw = float4(1, 1, 1, 1) + -r3.wxyz;
  r1.x = r5.x * r5.x;
  r1.y = r1.x * r1.x;
  r2.y = r0.z * r1.y + -r0.z;
  r0.z = r2.y * r0.z + 1;
  r0.z = r0.z * r0.z + 1.00000001e-07;
  r1.y = 0.318309873 * r1.y;
  r0.z = r1.y / r0.z;
  r1.y = -r5.x * r5.x + 1;
  r2.y = abs(r2.x) * r1.y + r1.x;
  r1.x = r1.w * r1.y + r1.x;
  r1.x = abs(r2.x) * r1.x;
  r1.y = 1 + -abs(r2.x);
  r1.x = r1.w * r2.y + r1.x;
  r1.x = 9.99999975e-06 + r1.x;
  r1.x = 0.5 / r1.x;
  r0.z = r1.x * r0.z;
  r0.z = 3.14159274 * r0.z;
  r0.z = r0.z * r1.w;
  r0.z = max(0, r0.z);
  r1.x = dot(r3.xyz, r3.xyz);
  r1.x = cmp(r1.x != 0.000000);
  r1.x = r1.x ? 1.000000 : 0;
  r0.z = r1.x * r0.z;
  r2.xyz = r0.zzz * r0.xyw;
  r0.z = 1 + -r1.z;
  r1.x = r1.z * r1.z;
  r1.x = dot(r1.xx, r5.xx);
  r1.x = -0.5 + r1.x;
  r1.z = r0.z * r0.z;
  r1.z = r1.z * r1.z;
  r0.z = r1.z * r0.z;
  r3.xyz = r5.yzw * r0.zzz + r3.xyz;
  r2.xyz = r3.xyz * r2.xyz;
  r0.z = r1.y * r1.y;
  r0.z = r0.z * r0.z;
  r0.z = r0.z * r1.y;
  r0.z = r1.x * r0.z + 1;
  r1.y = 1 + -r1.w;
  r1.z = r1.y * r1.y;
  r1.z = r1.z * r1.z;
  r1.y = r1.z * r1.y;
  r1.x = r1.x * r1.y + 1;
  r0.z = r1.x * r0.z;
  r0.z = r0.z * r1.w;
  r0.xyz = r0.xyw * r0.zzz;
  o0.xyz = r4.xyz * r0.xyz + r2.xyz;
  o0.w = 1;
  return;
}
