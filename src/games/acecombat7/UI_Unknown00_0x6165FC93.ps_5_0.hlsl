// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 11 21:13:03 2024
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[7];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[10];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[135];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD10,
  float4 v1 : TEXCOORD11,
  float4 v2 : TEXCOORD0,
  float4 v3 : SV_Position0,
  uint v4 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyz = r0.xyz * cb2[4].xyz + cb2[5].xyz;
  r0.w = -1 + r0.w;
  r0.w = cb2[6].x * r0.w + 1;
  r1.w = saturate(cb2[6].y * r0.w);
  r1.xyz = max(float3(0,0,0), r0.xyz);
  r0.x = cmp(0 < cb0[134].x);
  if (r0.x != 0) {
    r0.xyzw = cb0[37].xyzw * v3.yyyy;
    r0.xyzw = v3.xxxx * cb0[36].xyzw + r0.xyzw;
    r0.xyzw = v3.zzzz * cb0[38].xyzw + r0.xyzw;
    r0.xyzw = cb0[39].xyzw + r0.xyzw;
    r0.xyz = r0.xyz / r0.www;
    r0.xyz = -cb0[58].xyz + r0.xyz;
    r2.xyz = -cb1[8].xyz + r0.xyz;
    r3.xyz = float3(1,1,1) + cb1[9].xyz;
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

  //o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f);  // 2.2 gamma correction
  //o0.a = sign(o0.a) * pow(abs(o0.a), 2.2f); // 2.2 gamma on Alpha
  //o0.rgb *= injectedData.toneMapUINits / 80.f;  // Added ui slider  return;
  //o0.rgb = renodx::math::SafePow(o0.rgb, 1 / 2.2);
}