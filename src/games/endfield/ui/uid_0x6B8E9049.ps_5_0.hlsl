// ---- Created with 3Dmigoto v1.3.16 on Wed Jan 21 22:51:32 2026
#include "../shared.h"
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);



SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[23];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  float4 v7 : TEXCOORD6,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t2.Sample(s2_s, v2.xy).w;
  r0.y = -v3.x + r0.x;
  r0.y = cmp(r0.y < 0);
  if (r0.y != 0) discard;
  r0.x = v3.z + -r0.x;
  r0.y = cb1[22].w * cb1[6].x;
  r0.z = cb1[22].w * cb1[4].y;
  r0.yw = v3.yy * r0.yz;
  r1.xyz = cb1[3].xyz * v1.xyz;
  r2.xy = cb1[2].xy * cb0[0].yy + v6.xy;
  r2.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r1.xyz = r2.xyz * r1.xyz;
  r2.w = cb1[3].w * r2.w;
  r3.xy = cb1[4].zw * cb0[0].yy + v6.zw;
  r3.xyzw = t1.Sample(s1_s, r3.xy).xyzw;
  r3.xyzw = cb1[5].xyzw * r3.xyzw;
  r1.w = 0.5 * r0.y;
  r2.xyz = r2.www * r1.xyz;
  r3.xyz = r3.xyz * r3.www;
  r1.x = saturate(r0.x * v3.y + r1.w);
  r0.y = min(1, r0.y);
  r0.y = sqrt(r0.y);
  r0.y = r1.x * r0.y;
  r3.xyzw = r3.xyzw + -r2.xyzw;
  r2.xyzw = r0.yyyy * r3.xyzw + r2.xyzw;
  r0.x = r0.x * v3.y + -r1.w;
  r0.x = r0.w * 0.5 + r0.x;
  r0.y = r0.z * v3.y + 1;
  r0.x = saturate(r0.x / r0.y);
  r0.x = 1 + -r0.x;
  r0.xyzw = r2.xyzw * r0.xxxx;
  o0.xyzw = v1.wwww * r0.xyzw;

  if (UI_VISIBILITY < 0.5f) {
    o0 = 0;
    return;
  }
  float2 invViewportSize = float2(3840.0f, 2160.0f);
  float2 uv = v0.xy / invViewportSize;

  if (STATUS_TEXT_OPACITY < 0.5f) {
    bool isUuid = (uv.x >= 0.05f && uv.x <= 0.13f) && (uv.y >= 0.97f);
    if (isUuid) {
      o0.xyzw = 0.0f;
    }
  }
  if (PING_TEXT_OPACITY < 0.5f) {
    bool isPing = (uv.x >= 0.02f && uv.x <= 0.05f) && (uv.y >= 0.97f);
    if (isPing) {
      o0.xyzw = 0.0f;
    }
  }
  return;
}