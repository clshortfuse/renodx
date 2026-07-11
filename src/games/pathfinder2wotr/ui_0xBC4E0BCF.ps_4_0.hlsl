// ---- Created with 3Dmigoto v1.3.16 on Tue Nov  5 00:45:43 2024
// UI

#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float2 v0 : TEXCOORD0,
    float4 v1 : SV_POSITION0,
    float4 v2 : COLOR0,
    out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.xyzw = v2.wxyz * r0.wxyz;
  r1.x = 0.999899983 * cb0[2].x;
  r1.x = frac(r1.x);
  r1.y = 0.100000001 + r1.x;
  r1.zw = float2(3.5, 3.5) * v0.xy;
  r2.xyz = float3(0, 2, 0);
  while (true) {
    r2.w = cmp((int)r2.z >= 9);
    if (r2.w != 0) break;
    r3.xy = r2.yy * r1.zw;
    r3.xy = floor(r3.xy);
    r3.zw = r2.yy * r1.zw + -r3.xy;
    r4.xy = r3.zw * r3.zw;
    r3.zw = r3.zw * float2(-2, -2) + float2(3, 3);
    r3.zw = r4.xy * r3.zw;
    r2.w = r3.y * 7 + r3.x;
    r2.w = sin(r2.w);
    r2.w = cb0[5].y * r2.w;
    r2.w = 43 * r2.w;
    r2.w = frac(r2.w);
    r4.xyzw = float4(1, 0, 0, 1) + r3.xyxy;
    r4.xy = r4.yw * float2(7, 7) + r4.xz;
    r4.xy = sin(r4.xy);
    r4.xy = cb0[5].yy * r4.xy;
    r4.xy = float2(43, 43) * r4.xy;
    r4.xy = frac(r4.xy);
    r4.x = r4.x + -r2.w;
    r2.w = r3.z * r4.x + r2.w;
    r3.xy = float2(1, 1) + r3.xy;
    r3.x = r3.y * 7 + r3.x;
    r3.x = sin(r3.x);
    r3.x = cb0[5].y * r3.x;
    r3.x = 43 * r3.x;
    r3.x = frac(r3.x);
    r3.x = r3.x + -r4.y;
    r3.x = r3.z * r3.x + r4.y;
    r3.x = r3.x + -r2.w;
    r2.w = r3.w * r3.x + r2.w;
    r2.w = r2.w / r2.y;
    r2.x = r2.x + r2.w;
    r2.y = r2.y + r2.y;
    r2.z = (int)r2.z + 1;
  }
  r1.y = -r1.x * 0.833333313 + r1.y;
  r1.x = -r1.x * 0.833333313 + r2.x;
  r1.y = 1 / r1.y;
  r1.x = saturate(r1.x * r1.y);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r1.yzw = r1.xxx * r0.yzw;
  r2.x = -r0.x * r1.x + 1;
  r2.xyz = r1.yzw * r2.xxx + cb0[4].xyz;
  r0.yzw = -r0.yzw * r1.xxx + r2.xyz;
  r0.yzw = cb0[2].xxx * r0.yzw + r1.yzw;
  r0.yzw = max(float3(0, 0, 0), r0.yzw);
  r0.yzw = log2(r0.yzw);
  r0.yzw = float3(0.416666657, 0.416666657, 0.416666657) * r0.yzw;
  r0.yzw = exp2(r0.yzw);
  r0.yzw = r0.yzw * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  o0.xyz = max(float3(0, 0, 0), r0.yzw);
  o0.w = r0.x * r1.x + -cb0[5].x;

  o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f);                         // 2.2 gamma correction
  o0.rgb *= injectedData.toneMapUINits / injectedData.toneMapGameNits;  // Ratio of UI:Game brightness
  o0.rgb = renodx::math::SafePow(o0.rgb, 1 / 2.2);                      // Inverse 2.2 gamma

  return;
}