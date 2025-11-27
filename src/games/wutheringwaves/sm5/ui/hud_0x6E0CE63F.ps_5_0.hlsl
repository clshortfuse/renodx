#include "../../common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sun Oct 12 07:05:26 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[3];
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
  float4 v5 : SV_Position0,
  uint v6 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(cb2[2].x < 0.5);
  r0.yzw = v2.xyz * v2.xyz;
  r0.xyz = r0.xxx ? r0.yzw : v2.xyz;
  r1.xyzw = t0.SampleBias(s0_s, v3.xy, cb0[149].y).xyzw;
  r0.w = cmp(0.5 < cb2[2].x);
  r2.xyz = max(float3(0,0,0), r1.xyz);
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r1.xyz = r0.www ? r2.xyz : r1.xyz;
  r2.xyz = r1.xyz * r0.xyz;
  r0.xyz = -r0.xyz * r1.xyz + cb2[1].xyz;
  r0.xyz = cb2[2].yyy * r0.xyz + r2.xyz;
  r1.w = saturate(v2.w * r1.w);
  r1.xyz = max(float3(0,0,0), r0.xyz);
  r0.x = cmp(0 < cb0[146].x);
  if (r0.x != 0) {
    r0.xyzw = cb0[45].xyzw * v5.yyyy;
    r0.xyzw = v5.xxxx * cb0[44].xyzw + r0.xyzw;
    r0.xyzw = v5.zzzz * cb0[46].xyzw + r0.xyzw;
    r0.xyzw = cb0[47].xyzw + r0.xyzw;
    r0.xyz = r0.xyz / r0.www;
    r0.xyz = -cb0[70].xyz + r0.xyz;
    r2.xyz = -cb1[5].xyz + r0.xyz;
    r3.xyz = float3(1,1,1) + cb1[19].xyz;
    r2.xyz = cmp(r3.xyz < abs(r2.xyz));
    r0.w = (int)r2.y | (int)r2.x;
    r0.w = (int)r2.z | (int)r0.w;
    r0.x = dot(r0.xyz, float3(0.577000022,0.577000022,0.577000022));
    r0.x = 0.00200000009 * r0.x;
    r0.x = frac(r0.x);
    r0.x = cmp(0.5 < r0.x);
    r2.xyz = r0.xxx ? float3(0,1,1) : float3(1,1,0);
    r2.w = 1;
    o0.xyzw = r0.wwww ? r2.xyzw : r1.xyzw;
  } else {
    o0.xyzw = r1.xyzw;
  }

  o0.a *= HUD_OPACITY;

  return;
}