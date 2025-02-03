#include "./common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[11];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[7].z;
  r0.x = -cb0[6].z + r0.x;
  r0.y = -cb0[7].x + cb0[6].x;
  r0.xy = cb0[5].yy * float2(0.5, 0.5) + r0.xy;
  r0.xy = r0.xy / cb0[5].yy;
  r0.z = cb0[5].x / cb0[5].y;
  r0.xy = r0.xy + -r0.zz;
  r0.z = r0.z + r0.z;
  r1.xy = v1.xy * cb0[4].xy + cb0[4].zw;
  r0.xy = r1.xy * r0.zz + r0.xy;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.y = 1 + -cb0[8].y;
  r0.x = -r0.y * 0.5 + r0.x;
  r0.y = 1 + -r0.y;
  r0.x = r0.x / r0.y;
  r0.y = saturate(6.9197979 * r0.x);
  r0.y = r0.y * 0.43921572 + 0.423529387;
  r0.z = 0.90196079 + -r0.y;
  r1.xyzw = float4(-0.144502893, -0.294804305, -0.401739508, -0.543358505) + r0.xxxx;
  r2.xyzw = float4(-0.130052596, -0.130052596, -0.130052596, -0.300000012) + r0.xxxx;
  r2.xyzw = saturate(float4(6.06937122, 6.06937122, 6.06937122, 5.00000048) * r2.xyzw);
  r3.xyzw = saturate(float4(6.65285492, 9.35058308, 7.06070089, 24.7147274) * r1.xyzw);
  r0.x = saturate(3.23363566 * r1.y);
  r0.y = r3.x * r0.z + r0.y;
  r0.z = 0.886274517 + -r0.y;
  r0.y = r3.y * r0.z + r0.y;
  r0.z = 0.623529375 + -r0.y;
  r0.y = r3.z * r0.z + r0.y;
  r0.y = r3.w * -r0.y + r0.y;
  r0.zw = v1.xy * cb0[2].xy + cb0[2].zw;
  r1.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.z = cmp(r1.w >= 0.00999999978);
  r0.z = r0.z ? 1.000000 : 0;
  r3.w = r0.y * r0.z;
  r0.y = 1 + -cb0[3].x;
  r0.y = r0.y * r0.y;
  r4.w = -r0.y * r0.y + 1;
  r5.xyzw = r2.xyzw * float4(-0.00382699398, 0.238204181, 0.188679218, -2) + float4(0.00382699398, 0.286974192, 0.811320782, 3);
  r0.y = r2.w * r2.w;
  r0.y = r5.w * r0.y;
  r2.xyz = float3(0.504000008, 0.677206397, 1) + -r5.xyz;
  r0.xzw = r0.xxx * r2.xyz + r5.xyz;
  r2.x = log2(r0.w);
  r2.x = 2.20000005 * r2.x;
  r2.x = exp2(r2.x);
  r2.y = cmp(r0.w < 1);
  r5.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r0.xzw;
  r5.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r5.xyz;
  r5.xyz = log2(r5.xyz);
  r5.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r5.xyz;
  r3.xyz = exp2(r5.xyz);
  r3.z = r2.y ? r3.z : r2.x;
  r0.z = cmp(0.0404499993 >= r0.x);
  r0.x = 0.0773993805 * r0.x;
  r3.x = r0.z ? r0.x : r3.x;
  r0.x = 1;
  r0.w = cb0[3].x;
  r1.xyzw = r1.xyzw * r0.xxxw;
  r4.xyz = float3(1, 1, 1);
  r2.xyzw = r3.xyzw * r4.xyzw + -r1.xyzw;
  r1.xyzw = r3.wwww * r2.xyzw + r1.xyzw;
  r1.w = r1.w * r0.y;
  r0.xy = v1.xy * cb0[10].xy + cb0[10].zw;
  r0.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  o0.xyzw = r1.xyzw * r0.xyzw;
  o0.rgb = UIScale(o0.rgb);
  return;
}
