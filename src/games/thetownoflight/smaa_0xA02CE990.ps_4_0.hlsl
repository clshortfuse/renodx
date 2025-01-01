#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Tue Dec 03 21:18:57 2024
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[2];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, v2.xy).xyzw;
  r1.xyzw = t0.Sample(s1_s, v2.zw).xyzw;
  r2.xyzw = t0.Sample(s1_s, v1.xy).ywzx;
  r2.x = r0.w;
  r2.y = r1.y;
  r0.x = dot(r2.xyzw, float4(1, 1, 1, 1));
  r0.x = cmp(r0.x < 9.99999975e-006);
  if (r0.x != 0) {
    o0.xyzw = t1.SampleLevel(s0_s, v1.xy, 0).xyzw;
  } else {
    r0.x = max(r2.z, r0.w);
    r0.y = max(r2.y, r2.w);
    r0.x = cmp(r0.y < r0.x);
    r1.x = r0.x ? r0.w : 0;
    r1.z = r0.x ? r2.z : 0;
    r1.yw = r0.xx ? float2(0, 0) : r2.yw;
    r2.x = r0.x ? r0.w : r2.y;
    r2.y = r0.x ? r2.z : r2.w;
    r0.x = dot(r2.xy, float2(1, 1));
    r0.xy = r2.xy / r0.xx;
    r2.xyzw = float4(1, 1, -1, -1) * cb0[1].xyxy;
    r1.xyzw = r1.xyzw * r2.xyzw + v1.xyxy;
    r2.xyzw = t1.SampleLevel(s0_s, r1.xy, 0).xyzw;
    r1.xyzw = t1.SampleLevel(s0_s, r1.zw, 0).xyzw;
    r1.xyzw = r1.xyzw * r0.yyyy;
    o0.xyzw = r0.xxxx * r2.xyzw + r1.xyzw;
  }

  if (injectedData.toneMapType == 1) {  // DICE Tonemap
    o0.rgb = applyToneMap(o0.rgb);
  }
  return;
}
