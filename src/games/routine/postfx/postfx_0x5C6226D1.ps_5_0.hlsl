#include "./lilium_rcas.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Sat Dec 20 02:31:43 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[2];
}

cbuffer cb1 : register(b1) {
  float4 cb1[149];
}

cbuffer cb0 : register(b0) {
  float4 cb0[11];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb1[148].xyxy / cb1[148].xxyy;
  r1.x = cmp(cb1[148].x >= cb1[148].y);
  r0.xy = r1.xx ? r0.xy : r0.zw;
  r0.z = cmp(r0.x >= r0.y);
  r0.z = r0.z ? r0.y : r0.x;
  r0.z = r0.z * -0.312893212 + 1.00999999;
  r1.xy = asuint(cb0[10].xy);
  r1.xy = v0.xy + -r1.xy;
  r1.xy = r1.xy * cb0[10].zw + float2(-0.5, -0.5);
  r1.xy = r1.xy + r1.xy;
  r0.xy = r1.xy * r0.xy;
  r0.xy = r0.xy * r0.zz;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = sqrt(r0.x);
  r0.y = log2(r0.x);
  r0.x = cmp(2.98023295e-08 >= r0.x);
  r0.y = cb2[0].x * r0.y;
  r0.y = exp2(r0.y);
  r0.y = 1 + -r0.y;
  r0.x = r0.x ? 1 : r0.y;
  r0.xy = r1.xy * r0.xx;
  r0.xy = r0.xy * cb2[0].yy + r1.xy;
  r0.xy = r0.xy * cb2[0].zz + float2(1, 1);
  r0.xy = cb0[0].zw * r0.xy;
  r0.xy = r0.xy * float2(0.5, 0.5) + cb0[0].xy;
  r0.xy = max(cb0[1].xy, r0.xy);
  r0.xy = min(cb0[1].zw, r0.xy);
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;

  // o0 = r0;
  // return;

  r0.rgb = ScaleSceneInverse(r0.rgb);

  r1.xyz = cb2[1].xyz + -r0.xyz;
  r0.xyz = cb2[0].www * r1.xyz + r0.xyz;
  o0.w = r0.w;
  o0.rgb = r0.rgb;
  // o0.xyz = max(0, o0.rgb);

  o0.rgb = LinearizeAndClampMaxChannel(o0.rgb);
  o0.rgb = ScaleScene(o0.rgb);

  return;
}
