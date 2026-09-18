// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 06 10:55:32 2025
#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);

SamplerState s4_s : register(s4);

cbuffer cb1 : register(b1)
{
  float4 cb1[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (!CUSTOM_IS_UI) discard;

  r0.x = t4.Sample(s4_s, v2.xy).w;
  r0.x = r0.x * 2 + -1;
  r1.x = ddx_coarse(r0.x);
  r1.y = ddy_coarse(r0.x);
  r0.y = dot(r1.xy, r1.xy);
  r0.y = rsqrt(r0.y);
  r0.yz = r1.xy * r0.yy;
  r1.xy = cmp(r1.xy == float2(0,0));
  r0.w = r1.y ? r1.x : 0;
  r0.yz = r0.ww ? float2(0,0) : r0.yz;
  r1.xy = float2(256,256) * v2.xy;
  r1.zw = ddy_coarse(r1.xy);
  r1.xy = ddx_coarse(r1.xy);
  r0.zw = r1.zw * r0.zz;
  r0.yz = r0.yy * r1.xy + r0.zw;
  r0.y = dot(r0.yz, r0.yz);
  r0.y = sqrt(r0.y);
  r0.z = r0.y * 0.707099974 + r0.x;
  r0.y = 1.41419995 * r0.y;
  r0.y = 1 / r0.y;
  r0.y = saturate(r0.z * r0.y);
  r0.x = -cb1[0].z + r0.x;
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.z * r0.y;
  r0.z = -v1.w * r0.y + 1;
  r1.w = v1.w * r0.y;
  r1.xyz = v1.xyz * r1.www;
  r0.yw = cb1[1].xy + v2.xy;
  r0.y = t4.Sample(s4_s, r0.yw).w;
  r0.y = r0.y * 2 + -1;
  r0.y = -cb1[0].x + r0.y;
  r2.xy = cb1[0].yw + -cb1[0].xz;
  r2.xy = float2(1,1) / r2.xy;
  r0.xy = saturate(r2.yx * r0.xy);
  r0.w = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.w * r0.y;
  r2.w = cb1[2].w * r0.y;
  r2.xyz = cb1[2].xyz * r2.www;
  r1.xyzw = r2.xyzw * r0.zzzz + r1.xyzw;
  r0.y = 1 + -r1.w;
  r0.z = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.z * r0.x;
  r3.w = cb1[3].w * r0.x;
  r3.xyz = cb1[3].xyz * r3.www;
  r0.xyzw = r3.xyzw * r0.yyyy + r1.xyzw;
  r1.x = max(r3.w, r2.w);
  o0.w = max(r1.x, r0.w);
  o0.xyz = r0.xyz;
  return;
}