// ---- Created with 3Dmigoto v1.3.16 on Fri Mar 21 23:49:18 2025
// Glow shader, potentially clamps some cutscenes

#include "./common.hlsl"

cbuffer _Globals : register(b0) {
  float4 ColorRate : packoffset(c0);
  float4 ColorBlendStartUV : packoffset(c1);
  float4 ColorParam1 : packoffset(c2);
  float4 ColorParam0 : packoffset(c3);
}

SamplerState smplScene_s : register(s0);
Texture2D<float4> smplScene_Tex : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = ColorParam1.xy + -v1.xy;
  r0.xy = abs(r0.xy) / ColorParam1.zw;
  r0.x = cmp(r0.x < r0.y);
  r0.yz = ColorBlendStartUV.zx + -v1.yx;
  r1.xy = -ColorBlendStartUV.wy + v1.yx;
  r1.zw = min(abs(r1.xy), abs(r0.yz));
  r0.yz = max(r1.yx, r0.zy);
  r0.y = max(r0.y, r0.z);
  r0.y = cmp(0 < r0.y);
  r0.zw = saturate(r1.zw / ColorParam0.wz);
  r0.x = r0.x ? r0.z : r0.w;
  r0.x = r0.y ? r0.x : 0;
  r0.y = 1 + -r0.x;
  r0.xy = ColorRate.ww * r0.xy;
  r0.z = cmp(ColorParam0.x == 0.000000);
  r0.x = r0.z ? r0.x : r0.y;
  r0.y = 1 + -r0.x;
  r1.xyz = smplScene_Tex.Sample(smplScene_s, v1.xy).xyz;

  o0.rgb = r1.rgb;
  o0.w = 1.f;
  return;

  // Below clamps some real-time cutscenes
  // Not 100% sure what the math below does; but just removing saturates causes artifacts
  // There seems to be no visual downside to skipping all this

  r0.yzw = r1.xyz * r0.yyy;
  r2.xyz = saturate(r1.xyz / ColorParam0.yyy);
  r2.xyz = trunc(r2.xyz);
  r1.xyz = r2.xyz + -r1.xyz;
  r1.xyz = abs(r1.xyz) + abs(r1.xyz);
  r3.xyz = -ColorRate.xyz + r2.xyz;
  r1.xyz = -r1.xyz * abs(r3.xyz) + r2.xyz;
  o0.xyz = saturate(r0.xxx * abs(r1.xyz) + r0.yzw);
  o0.w = 1;
  return;
}
