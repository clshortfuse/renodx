#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:29 2024
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2;

  r0.xy = t0.SampleLevel(s0_s, v1.xy, 0).xy;
  r0.xy = v1.xy + -r0.xy;
  r0.zw = r0.xy * float2(2, 2) + float2(-1, -1);

  // upgraded index 2: r8g8b8a8_typeless -> r16g16b16a16_float
  float4 previous_frame = t2.SampleLevel(s2_s, r0.xy, 0).xyzw;
  // clamp after upgrading to 16 bit

  r0.x = max(abs(r0.z), abs(r0.w));
  r0.x = cmp(r0.x >= 1);
  r0.y = previous_frame.w * previous_frame.w;

  float4 current_frame = t1.SampleLevel(s1_s, v1.xy, 0).xyzw;
  // clamp after upgrading to 16 bit

  r0.y = current_frame.w * current_frame.w + -r0.y;
  r0.y = 0.200000003 * abs(r0.y);
  r0.y = sqrt(r0.y);
  r0.y = -r0.y * 30 + 1;
  r0.y = max(0, r0.y);
  r0.y = 0.5 * r0.y;
  r0.x = r0.x ? 0 : r0.y;
  r0.yzw = -current_frame.xyz + previous_frame.xyz;
  o0.xyz = r0.xxx * r0.yzw + current_frame.xyz;
  o0.w = current_frame.w;

  return;
}
