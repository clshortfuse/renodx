#include "./common.hlsl"

// Scanner
// ---- Created with 3Dmigoto v1.4.1 on Wed Apr 16 19:06:20 2025
Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[41];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;

  r0.yzw = renodx::color::srgb::DecodeSafe(r1.rgb);

  r1.xyz = r0.yzw * r0.xxx;
  r0.xyzw = float4(-1, -1, 1, 1) * cb0[32].xyxy;
  r2.x = 0.5 * cb0[34].x;
  r3.xyzw = saturate(r0.xyzy * r2.xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r0.xyzw = saturate(r0.xwzw * r2.xxxx + v1.xyxy);
  r0.xyzw = cb0[26].xxxx * r0.xyzw;
  r2.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r0.xyzw = t3.Sample(s3_s, r0.zw).xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r3.xyz = float3(0.25, 0.25, 0.25) * r0.xyz;
  r2.xyz = cb0[34].zzz * r2.xyz;
  r0.xyzw = float4(0.25, 0.25, 0.25, 1) * r0.xyzw;
  r4.xyz = cb0[35].xyz * r0.xyz;
  r4.w = 0.25 * r0.w;
  r0.xyzw = r4.xyzw + r1.xyzw;
  r1.xyz = r2.xyz * r3.xyz;
  r1.w = 0;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.x = cmp(cb0[40].y < 0.5);
  if (r1.x != 0) {
    r1.xy = -cb0[38].xy + v1.xy;
    r1.yz = cb0[39].xx * abs(r1.yx);
    r1.w = cb0[22].x / cb0[22].y;
    r1.w = -1 + r1.w;
    r1.w = cb0[39].w * r1.w + 1;
    r1.x = r1.z * r1.w;
    r1.xy = saturate(r1.xy);
    r1.xy = log2(r1.xy);
    r1.xy = cb0[39].zz * r1.xy;
    r1.xy = exp2(r1.xy);
    r1.x = dot(r1.xy, r1.xy);
    r1.x = 1 + -r1.x;
    r1.x = max(0, r1.x);
    r1.x = log2(r1.x);
    r1.x = cb0[39].y * r1.x;
    r1.x = exp2(r1.x);
    r1.yzw = float3(1, 1, 1) + -cb0[37].xyz;
    r1.yzw = r1.xxx * r1.yzw + cb0[37].xyz;
    r2.xyz = r1.yzw * r0.xyz;
    r1.y = -1 + r0.w;
    r2.w = r1.x * r1.y + 1;
  } else {
    r1.xyzw = t6.Sample(s6_s, v1.xy).xyzw;
    r1.xyz = float3(1, 1, 1) + -cb0[37].xyz;
    r1.xyz = r1.www * r1.xyz + cb0[37].xyz;
    r1.xyz = r0.xyz * r1.xyz + -r0.xyz;
    r2.xyz = cb0[40].xxx * r1.xyz + r0.xyz;
    r0.x = -1 + r0.w;
    r2.w = r1.w * r0.x + 1;
  }

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = Vanilla(r2.rgb, t5, s5_s, cb0[36].xyz, v1.xy, t0, s0_s, cb0[30]);
  } else {
    o0.rgb = ApplyUserTonemap(r2.rgb, t5, s5_s, cb0[36].xyz);
  }

  o0.w = 1;
  return;
}
