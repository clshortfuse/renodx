// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 01 11:48:18 2025

#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

cbuffer cb3 : register(b3)
{
  float4 cb3[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  if (!CUSTOM_SHOW_HUD) discard;

  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -cb3[1].x + v2.x;
  r0.y = -cb3[2].x + v2.y;
  r0.z = max(abs(r0.x), abs(r0.y));
  r0.z = 1 / r0.z;
  r0.w = min(abs(r0.x), abs(r0.y));
  r0.z = r0.w * r0.z;
  r0.w = r0.z * r0.z;
  r1.x = r0.w * 0.0208350997 + -0.0851330012;
  r1.x = r0.w * r1.x + 0.180141002;
  r1.x = r0.w * r1.x + -0.330299497;
  r0.w = r0.w * r1.x + 0.999866009;
  r1.x = r0.z * r0.w;
  r1.x = r1.x * -2 + 1.57079637;
  r1.y = cmp(abs(r0.y) < abs(r0.x));
  r1.x = r1.y ? r1.x : 0;
  r0.z = r0.z * r0.w + r1.x;
  r0.w = cmp(r0.y < -r0.y);
  r0.w = r0.w ? -3.141593 : 0;
  r0.z = r0.z + r0.w;
  r0.w = min(r0.x, r0.y);
  r0.x = max(r0.x, r0.y);
  r0.x = cmp(r0.x >= -r0.x);
  r0.y = cmp(r0.w < -r0.w);
  r0.x = r0.x ? r0.y : 0;
  r0.x = r0.x ? -r0.z : r0.z;
  r0.y = cmp(-9.99999975e-005 >= cb3[3].x);
  r0.z = max(9.99999975e-005, cb3[3].x);
  r0.y = r0.y ? cb3[3].x : r0.z;
  r0.zw = -cb3[0].xy * float2(6.28318548,6.28318548) + float2(3.14159274,3.14159274);
  r1.x = r0.z + -r0.y;
  r1.y = -r1.x + r0.x;
  r1.z = r0.z + r0.y;
  r1.x = r1.z + -r1.x;
  r1.x = 1 / r1.x;
  r1.x = saturate(r1.y * r1.x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r1.y = r0.x + r0.y;
  r0.y = r0.x + -r0.y;
  r1.y = r1.y + -r0.y;
  r0.y = r0.w + -r0.y;
  r0.z = -cb3[3].y + r0.z;
  r0.w = 1 / r1.y;
  r0.y = saturate(r0.y * r0.w);
  r0.w = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.w * r0.y;
  r0.y = r1.x * r0.y;
  r0.w = cmp(0 < cb3[3].y);
  r1.x = cmp(cb3[3].y < 0);
  r0.w = (int)-r0.w + (int)r1.x;
  r0.w = (int)r0.w;
  r1.x = max(9.99999975e-005, abs(cb3[3].y));
  r1.y = r0.w * r1.x + r0.z;
  r0.z = -r0.w * r1.x + r0.z;
  r0.w = r1.y + -r0.z;
  r0.x = r0.x + -r0.z;
  r0.z = 1 / r0.w;
  r0.x = saturate(r0.x * r0.z);
  r0.z = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.z * r0.x;
  r0.x = r0.y * r0.x;
  r0.z = cmp(abs(cb3[3].y) >= 9.99999975e-005);
  r0.x = r0.z ? r0.x : r0.y;
  r1.xyzw = t0.Sample(s1_s, v2.xy).xyzw;
  r1.xyzw = v1.xyzw * r1.xyzw;
  o0.w = r1.w * r0.x;
  o0.xyz = r1.xyz;
  return;
}