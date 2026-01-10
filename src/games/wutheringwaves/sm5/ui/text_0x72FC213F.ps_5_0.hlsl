#include "../../common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sun Oct 12 07:05:26 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[12];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[20];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[150];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD10,
  float4 v1 : TEXCOORD11,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD0,
  float4 v4 : TEXCOORD7,
  float3 v5 : TEXCOORD9,
  float4 v6 : SV_Position0,
  uint v7 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = -cb0[70].xyz + v5.xyz;
  r0.w = cmp(cb2[9].x < 0.5);
  r1.xyz = v2.xyz * v2.xyz;
  r1.xyz = r0.www ? r1.xyz : v2.xyz;
  r2.xy = t0.SampleBias(s0_s, v3.xy, cb0[149].y).xy;
  r0.w = max(r2.x, r2.y);
  r1.w = ceil(r0.w);
  r2.x = ceil(v3.z);
  r2.yz = float2(-1,-1) + v3.zw;
  r3.xyzw = t1.SampleBias(s1_s, r2.yz, cb0[149].y).xyzw;
  r2.yzw = r3.xyz * r2.xxx;
  r3.x = cmp(0.5 < cb2[9].x);
  r4.xyz = max(float3(0,0,0), r2.yzw);
  r4.xyz = log2(r4.xyz);
  r4.xyz = float3(0.416666657,0.416666657,0.416666657) * r4.xyz;
  r4.xyz = exp2(r4.xyz);
  r4.xyz = r4.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r4.xyz = max(float3(0,0,0), r4.xyz);
  r2.yzw = r3.xxx ? r4.xyz : r2.yzw;
  r1.xyz = r1.xyz * r1.www + r2.yzw;
  r2.yzw = cb2[1].xyz + -r1.xyz;
  r1.xyz = cb2[9].yyy * r2.yzw + r1.xyz;
  r0.w = r2.x * r3.w + r0.w;
  r0.w = v2.w * r0.w;
  r2.xy = cb1[7].xy * r0.yy;
  r0.xy = r0.xx * cb1[6].xy + r2.xy;
  r0.xy = r0.zz * cb1[8].xy + r0.xy;
  r0.xy = cb1[9].xy + r0.xy;
  r2.xy = cb2[6].xy + -r0.xy;
  r2.xy = -cb2[7].xy + r2.xy;
  r2.zw = cb2[7].xy + cb2[6].xy;
  r0.xy = -r2.zw + r0.xy;
  r2.xy = saturate(r2.xy / cb2[8].xw);
  r0.xy = saturate(r0.xy / cb2[8].zy);
  r0.xy = r2.xy + r0.xy;
  r0.xy = float2(1,1) + -r0.xy;
  r0.x = r0.x * r0.y;
  r0.x = max(0, r0.x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.z = r0.y * r0.x;
  r0.x = -r0.y * r0.x + 1;
  r0.y = cmp(9.99999975e-06 < abs(cb2[11].z));
  r1.w = cmp(cb2[11].z >= 0);
  r0.x = r1.w ? r0.x : r0.z;
  r0.x = r0.y ? r0.x : r0.z;
  r0.w = saturate(r0.w * r0.x);
  r0.xyz = max(float3(0,0,0), r1.xyz);
  r1.x = cmp(0 < cb0[146].x);
  if (r1.x != 0) {
    r1.xyzw = cb0[45].xyzw * v6.yyyy;
    r1.xyzw = v6.xxxx * cb0[44].xyzw + r1.xyzw;
    r1.xyzw = v6.zzzz * cb0[46].xyzw + r1.xyzw;
    r1.xyzw = cb0[47].xyzw + r1.xyzw;
    r1.xyz = r1.xyz / r1.www;
    r1.xyz = -cb0[70].xyz + r1.xyz;
    r2.xyz = -cb1[5].xyz + r1.xyz;
    r3.xyz = float3(1,1,1) + cb1[19].xyz;
    r2.xyz = cmp(r3.xyz < abs(r2.xyz));
    r1.w = (int)r2.y | (int)r2.x;
    r1.w = (int)r2.z | (int)r1.w;
    r1.x = dot(r1.xyz, float3(0.577000022,0.577000022,0.577000022));
    r1.x = 0.00200000009 * r1.x;
    r1.x = frac(r1.x);
    r1.x = cmp(0.5 < r1.x);
    r2.xyz = r1.xxx ? float3(0,1,1) : float3(1,1,0);
    r2.w = 1;
    o0.xyzw = r1.wwww ? r2.xyzw : r0.xyzw;
  } else {
    o0.xyzw = r0.xyzw;
  }

  o0.a *= TEXT_OPACITY;

  return;
}