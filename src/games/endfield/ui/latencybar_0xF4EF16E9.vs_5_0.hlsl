#include "../shared.h"

cbuffer cb4 : register(b4) {
  float4 cb4[12];
}

cbuffer cb3 : register(b3) {
  float4 cb3[9];
}

cbuffer cb2 : register(b2) {
  float4 cb2[48];
}

cbuffer cb1 : register(b1) {
  float4 cb1[1];
}

cbuffer cb0 : register(b0) {
  float4 cb0[21];
}

void main(
    float4 v0 : POSITION0,
    float4 v1 : COLOR0,
    float2 v2 : TEXCOORD0,
    out float4 o0 : SV_Position0,
    out float4 o1 : TEXCOORD0,
    out float2 o2 : TEXCOORD1,
    out float4 o3 : TEXCOORD2,
    out float4 o4 : TEXCOORD3,
    out float4 o5 : TEXCOORD4) {
  float4 r0, r1, r2, r3;

  r0.xy = -cb1[0].yz * float2(2, 2) + float2(1, 1);
  r1.xyz = cb3[1].xyz * v0.yyy;
  r1.xyz = cb3[0].xyz * v0.xxx + r1.xyz;
  r1.xyz = cb3[2].xyz * v0.zzz + r1.xyz;
  r1.xyz = cb3[3].xyz + r1.xyz;
  r1.xyz = -cb2[44].xyz * cb1[0].xxx + r1.xyz;
  r1.w = 1;
  r0.z = 0 < cb1[0].x ? 1.0 : 0.0;
  r2.x = r0.z != 0 ? cb2[32].x : cb0[17].x;
  r2.y = r0.z != 0 ? cb2[33].x : cb0[18].x;
  r2.z = r0.z != 0 ? cb2[34].x : cb0[19].x;
  r2.w = r0.z != 0 ? cb2[35].x : cb0[20].x;
  r2.x = dot(r2.xyzw, r1.xyzw);
  r3.x = r0.z != 0 ? cb2[32].y : cb0[17].y;
  r3.y = r0.z != 0 ? cb2[33].y : cb0[18].y;
  r3.z = r0.z != 0 ? cb2[34].y : cb0[19].y;
  r3.w = r0.z != 0 ? cb2[35].y : cb0[20].y;
  r2.y = dot(r3.xyzw, r1.xyzw);
  r0.xy = r2.xy * r0.xy;
  r2.xy = r0.zz != 0 ? r0.xy : r2.xy;
  r3.x = r0.z != 0 ? cb2[32].z : cb0[17].z;
  r3.y = r0.z != 0 ? cb2[33].z : cb0[18].z;
  r3.z = r0.z != 0 ? cb2[34].z : cb0[19].z;
  r3.w = r0.z != 0 ? cb2[35].z : cb0[20].z;
  r2.z = dot(r3.xyzw, r1.xyzw);
  r3.x = r0.z != 0 ? cb2[32].w : cb0[17].w;
  r3.y = r0.z != 0 ? cb2[33].w : cb0[18].w;
  r3.z = r0.z != 0 ? cb2[34].w : cb0[19].w;
  r3.w = r0.z != 0 ? cb2[35].w : cb0[20].w;
  r2.w = dot(r3.xyzw, r1.xyzw);
  o0.xyzw = r2.xyzw;
  o5.zw = r2.zw;
  r0.x = cb4[11].y != 0.000000 ? 1.0 : 0.0;
  r1.xyzw = r0.xxxx != 0 ? cb4[11].zzzw : float4(1, 1, 1, 1);
  r3.xyzw = cb4[8].xyzw * v1.xyzw;
  o1.xyzw = r3.xyzw * r1.xyzw;
  o2.xy = v2.xy * cb4[9].xy + cb4[9].zw;
  o3.xyzw = v0.xyzw;
  r1.xz = r0.zz != 0 ? cb2[8].yx : cb0[5].yx;
  r1.yw = r0.zz != 0 ? cb2[9].yx : cb0[6].yx;
  r0.z = dot(r1.zw, cb2[47].xy);
  r0.w = dot(r1.xy, cb2[47].xy);
  r0.xy = r2.ww / abs(r0.zw);
  r1.xz = float2(0.5, 0.5) * r2.xw;
  r0.z = cb2[46].x * r2.y;
  r1.w = 0.5 * r0.z;
  o5.xy = r1.xw + r1.zz;
  r0.xy = cb3[8].yz * float2(0.25, 0.25) + abs(r0.xy);
  o4.zw = float2(0.25, 0.25) / r0.xy;
  r0.xyzw = max(cb3[6].xyzw, float4(-2e+10, -2e+10, -2e+10, -2e+10));
  r0.xyzw = min(float4(2e+10, 2e+10, 2e+10, 2e+10), r0.xyzw);
  r0.xy = v0.xy * float2(2, 2) + -r0.xy;
  o4.xy = r0.xy + -r0.zw;

  if (LATENCY_BAR_DRAW_OPACITY < 0.5f) {
    float2 ndc = o0.xy / max(abs(o0.w), 0.00001f);
    if ((ndc.x >= -0.99f && ndc.x <= -0.93f)
        && (ndc.y >= -0.99f && ndc.y <= -0.90f)) {
      o0 = float4(2.0f, 2.0f, 0.0f, 1.0f);
    }
  }
}
