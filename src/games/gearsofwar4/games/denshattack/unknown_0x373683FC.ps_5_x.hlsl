#include "../postfx.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Fri Jul 17 03:09:38 2026
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[5];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[1];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[164];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[6];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asuint(cb0[5].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.zw = r0.xy * cb0[5].zw + float2(-0.5,-0.5);
  r0.xy = cb0[5].zw * r0.xy;
  r0.z = dot(r0.zw, r0.zw);
  r0.z = sqrt(r0.z);
  r0.z = -r0.z * cb3[1].z + 1;
  r0.w = cb3[1].w * r0.z;
  r0.w = r0.w * r0.w;
  r0.w = 1.44269514 * r0.w;
  r0.w = exp2(r0.w);
  r0.w = 1 / r0.w;
  r0.w = 1 + -r0.w;
  r1.x = cmp(r0.z >= 0);
  r0.z = cmp(9.99999975e-06 < abs(r0.z));
  r0.w = r1.x ? r0.w : 0;
  r0.z = r0.z ? r0.w : 0;
  r0.w = cb3[0].x * cb1[163].z;
  r0.w = 6.28318548 * r0.w;
  r0.w = sin(r0.w);
  r0.w = 1 + r0.w;
  r1.xy = cmp(r0.ww >= float2(1.20000005,0.600000024));
  r1.zw = r0.xy * cb3[0].yz + cb3[1].xy;
  r0.xy = r0.xy * cb0[0].zw + cb0[0].xy;
  r2.xyzw = t3.Sample(s3_s, r0.xy).xyzw;

  r2.xyz = InvertLUTEncode(r2.xyz);

  r0.x = t0.Sample(s0_s, r1.zw).w;
  r0.y = t1.Sample(s1_s, r1.zw).w;
  r0.w = t2.Sample(s2_s, r1.zw).w;
  r0.x = r1.x ? r0.x : r0.y;
  r0.x = r1.y ? r0.x : r0.w;
  r0.x = r0.z * -r0.x + r0.x;
  r0.y = -cb3[2].y + cb2[0].y;
  r0.y = cb3[2].x * r0.y + cb3[2].y;
  r0.x = r0.x * r0.y;
  r0.x = max(0, r0.x);
  r0.x = min(cb3[2].z, r0.x);
  r0.yzw = cb3[3].xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  o0.w = r2.w;
  r1.xyz = cb3[4].xyz + -r0.xyz;
  r0.xyz = cb3[3].www * r1.xyz + r0.xyz;

  r0.xyz = renodx::math::Select(RENODX_TONE_MAP_TYPE == 0, max(0, r0.xyz), r0.xyz);
  o0.xyz = ApplyLUTEncode(r0.xyz);

  //o0.xyz = 0;
  return;
}