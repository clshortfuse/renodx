// ---- Created with 3Dmigoto v1.3.16 on Wed Nov 26 20:49:47 2025

// Lutbuilder - not being used right now but included for completeness
#include "../shared.h"

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[18];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;
  r0.yz = -cb0[2].yz + v1.xy;
  r1.x = cb0[2].x * r0.y;
  r0.x = frac(r1.x);
  r1.x = r0.x / cb0[2].x;
  r0.w = -r1.x + r0.y;
  r0.xyz = r0.xzw * cb0[2].www + float3(-0.386036009,-0.386036009,-0.386036009);
  r0.xyz = float3(13.6054821,13.6054821,13.6054821) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(-0.0479959995,-0.0479959995,-0.0479959995) + r0.xyz;
  r0.xyz = float3(0.179999992,0.179999992,0.179999992) * r0.xyz;
  r1.x = dot(float3(0.390404999,0.549941003,0.00892631989), r0.xyz);
  r1.y = dot(float3(0.070841603,0.963172019,0.00135775004), r0.xyz);
  r1.z = dot(float3(0.0231081992,0.128021002,0.936245024), r0.xyz);
  r0.xyz = cb0[3].xyz * r1.xyz;
  r1.x = dot(float3(2.85846996,-1.62879002,-0.0248910002), r0.xyz);
  r1.y = dot(float3(-0.210181996,1.15820003,0.000324280991), r0.xyz);
  r1.z = dot(float3(-0.0418119989,-0.118169002,1.06867003), r0.xyz);
  r0.xyz = r1.xyz * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.0734997839,0.0734997839,0.0734997839) + float3(-0.0275523961,-0.0275523961,-0.0275523961);
  r0.xyz = r0.xyz * cb0[8].zzz + float3(0.0275523961,0.0275523961,0.0275523961);
  r0.xyz = float3(13.6054821,13.6054821,13.6054821) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(-0.0479959995,-0.0479959995,-0.0479959995) + r0.xyz;
  r0.xyz = cb0[4].xyz * r0.xyz;
  r0.xyz = float3(0.179999992,0.179999992,0.179999992) * r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz + r0.xyz;
  r2.xyz = r0.xyz * r0.xyz;
  r3.xyz = min(float3(1,1,1), r0.xyz);
  r0.xyz = sqrt(r0.xyz);
  r0.w = dot(r3.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.w = saturate(cb0[16].w + r0.w);
  r1.w = 1 + -r0.w;
  r3.xyz = cb0[16].xyz + float3(-0.5,-0.5,-0.5);
  r3.xyz = r1.www * r3.xyz + float3(0.5,0.5,0.5);
  r4.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
  r2.xyz = r4.xyz * r2.xyz;
  r2.xyz = r1.xyz * r3.xyz + r2.xyz;
  r4.xyz = cmp(r3.xyz >= float3(0.5,0.5,0.5));
  r5.xyz = r4.xyz ? float3(0,0,0) : float3(1,1,1);
  r4.xyz = r4.xyz ? float3(1,1,1) : 0;
  r2.xyz = r5.xyz * r2.xyz;
  r5.xyz = float3(1,1,1) + -r3.xyz;
  r3.xyz = r3.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.xyz = r5.xyz * r1.xyz;
  r0.xyz = r0.xyz * r3.xyz + r1.xyz;
  r0.xyz = r0.xyz * r4.xyz + r2.xyz;
  r1.xyz = r0.xyz + r0.xyz;
  r2.xyz = r0.xyz * r0.xyz;
  r0.xyz = sqrt(r0.xyz);
  r3.xyz = cb0[17].xyz + float3(-0.5,-0.5,-0.5);
  r3.xyz = r0.www * r3.xyz + float3(0.5,0.5,0.5);
  r4.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
  r2.xyz = r4.xyz * r2.xyz;
  r2.xyz = r1.xyz * r3.xyz + r2.xyz;
  r4.xyz = cmp(r3.xyz >= float3(0.5,0.5,0.5));
  r5.xyz = r4.xyz ? float3(0,0,0) : float3(1,1,1);
  r4.xyz = r4.xyz ? float3(1,1,1) : 0;
  r2.xyz = r5.xyz * r2.xyz;
  r5.xyz = float3(1,1,1) + -r3.xyz;
  r3.xyz = r3.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.xyz = r5.xyz * r1.xyz;
  r0.xyz = r0.xyz * r3.xyz + r1.xyz;
  r0.xyz = r0.xyz * r4.xyz + r2.xyz;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.x = dot(r0.xyz, cb0[5].xyz);
  r1.y = dot(r0.xyz, cb0[6].xyz);
  r1.z = dot(r0.xyz, cb0[7].xyz);
  r0.xyz = cb0[13].xyz * r1.xyz;
  r0.w = dot(r1.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r2.xy = -cb0[15].xz + r0.ww;
  r2.zw = cb0[15].yw + -cb0[15].xz;
  r2.zw = float2(1,1) / r2.zw;
  r2.xy = saturate(r2.xy * r2.zw);
  r2.zw = r2.xy * float2(-2,-2) + float2(3,3);
  r2.xy = r2.xy * r2.xy;
  r0.w = r2.w * r2.y;
  r1.w = r2.z * r2.x + -r0.w;
  r2.x = -r2.z * r2.x + 1;
  r0.xyz = r1.www * r0.xyz;
  r2.yzw = cb0[12].xyz * r1.xyz;
  r1.xyz = cb0[14].xyz * r1.xyz;
  r0.xyz = r2.yzw * r2.xxx + r0.xyz;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  r0.xyz = r0.xyz * cb0[11].xyz + cb0[9].xyz;
  r1.xyz = cmp(float3(0,0,0) < r0.xyz);
  r2.xyz = cmp(r0.xyz < float3(0,0,0));
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = cb0[10].xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = (int3)-r1.xyz + (int3)r2.xyz;
  r1.xyz = (int3)r1.xyz;
  r2.xyz = r1.xyz * r0.xyz;
  r3.xy = r2.zy;
  r0.xy = r1.yz * r0.yz + -r3.xy;
  r1.x = cmp(r3.y >= r2.z);
  r1.x = r1.x ? 1.000000 : 0;
  r3.zw = float2(-1,0.666666687);
  r0.zw = float2(1,-1);
  r0.xyzw = r1.xxxx * r0.xywz + r3.xywz;
  r1.x = cmp(r2.x >= r0.x);
  r1.x = r1.x ? 1.000000 : 0;
  r3.z = r0.w;
  r0.w = r2.x;
  r2.z = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r3.xyw = r0.wyx;
  r3.xyzw = r3.xyzw + -r0.xyzw;
  r0.xyzw = r1.xxxx * r3.xyzw + r0.xyzw;
  r1.x = min(r0.w, r0.y);
  r1.x = -r1.x + r0.x;
  r1.y = r1.x * 6 + 9.99999975e-005;
  r0.y = r0.w + -r0.y;
  r0.y = r0.y / r1.y;
  r0.y = r0.z + r0.y;
  r3.z = abs(r0.y);
  r3.x = cb0[8].x + r3.z;
  r3.yw = float2(0,0);
  r0.y = t4.SampleLevel(s0_s, r3.xy, 0).x;
  r0.z = t5.SampleLevel(s0_s, r3.zw, 0).x;
  r0.yz = saturate(r0.yz);
  r0.z = r0.z + r0.z;
  r0.y = r0.y + r3.x;
  r1.yzw = float3(-0.5,0.5,-1.5) + r0.yyy;
  r0.y = cmp(1 < r1.y);
  r0.y = r0.y ? r1.w : r1.y;
  r0.w = cmp(r1.y < 0);
  r0.y = r0.w ? r1.z : r0.y;
  r1.yzw = float3(1,0.666666687,0.333333343) + r0.yyy;
  r1.yzw = frac(r1.yzw);
  r1.yzw = r1.yzw * float3(6,6,6) + float3(-3,-3,-3);
  r1.yzw = saturate(float3(-1,-1,-1) + abs(r1.yzw));
  r1.yzw = float3(-1,-1,-1) + r1.yzw;
  r0.y = 9.99999975e-005 + r0.x;
  r2.x = r1.x / r0.y;
  r1.xyz = r2.xxx * r1.yzw + float3(1,1,1);
  r3.xyz = r1.xyz * r0.xxx;
  r0.y = dot(r3.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r1.xyz = r1.xyz * r0.xxx + -r0.yyy;
  r2.yw = float2(0,0);
  r0.x = t6.SampleLevel(s0_s, r2.xy, 0).x;
  r0.w = t7.SampleLevel(s0_s, r2.zw, 0).x;
  r0.xw = saturate(r0.xw);
  r0.x = dot(r0.xx, r0.zz);
  r0.x = r0.w * r0.x;
  r0.x = dot(cb0[8].yy, r0.xx);
  r0.xyz = r0.xxx * r1.xyz + r0.yyy;
  r0.w = max(r0.x, r0.y);
  r0.w = max(r0.w, r0.z);
  r0.w = 1 + r0.w;
  r0.w = 1 / r0.w;
  r0.xyz = r0.xyz * r0.www + float3(0.00390625,0.00390625,0.00390625);
  r0.w = 0;
  r1.x = t0.SampleLevel(s0_s, r0.xw, 0).x;
  r1.x = saturate(r1.x);
  r1.y = t0.SampleLevel(s0_s, r0.yw, 0).x;
  r1.z = t0.SampleLevel(s0_s, r0.zw, 0).x;
  r1.yz = saturate(r1.yz);
  r0.xyz = float3(0.00390625,0.00390625,0.00390625) + r1.xyz;
  r0.w = 0;
  r1.x = t1.SampleLevel(s0_s, r0.xw, 0).x;
  r1.x = saturate(r1.x);
  r1.y = t2.SampleLevel(s0_s, r0.yw, 0).x;
  r1.z = t3.SampleLevel(s0_s, r0.zw, 0).x;
  r1.yz = saturate(r1.yz);
  r0.x = max(r1.x, r1.y);
  r0.x = max(r0.x, r1.z);
  r0.x = 1 + -r0.x;
  r0.x = 1 / r0.x;
  o0.xyz = r1.xyz * r0.xxx;

  // Add ToneMapPass and output
  // o0.xyz = renodx::draw::ToneMapPass(o0.xyz);
  o0.w = 1;
  return;
}