// ---- Created with 3Dmigoto v1.3.16 on Tue Nov  5 00:45:41 2024
// UI

#include "./shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[1];
}

cbuffer cb0 : register(b0) {
  float4 cb0[23];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0 : SV_POSITION0,
    float4 v1 : COLOR0,
    float4 v2 : TEXCOORD0,
    float4 v3 : TEXCOORD1,
    float4 v4 : TEXCOORD2,
    float4 v5 : TEXCOORD3,
    float4 v6 : TEXCOORD5,
    out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s2_s, v2.xy).xyzw;
  r0.x = -v3.x + r0.w;
  r0.y = v3.z + -r0.w;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.xz = cb0[4].zw * cb1[0].yy + v6.zw;
  r1.xyzw = t2.Sample(s1_s, r0.xz).xyzw;
  r1.xyzw = cb0[5].xyzw * r1.xyzw;
  r0.xzw = log2(r1.xyz);
  r0.xzw = float3(0.416666657, 0.416666657, 0.416666657) * r0.xzw;
  r0.xzw = exp2(r0.xzw);
  r0.xzw = r0.xzw * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
  r3.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r1.xyz);
  r0.xzw = r3.xyz ? r2.xyz : r0.xzw;
  r1.xyz = r0.xzw * r1.www;
  r0.xzw = cb0[3].xyz * v1.xyz;
  r2.xy = cb0[2].xy * cb1[0].yy + v6.xy;
  r2.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  r0.xzw = r2.xyz * r0.xzw;
  r2.w = cb0[3].w * r2.w;
  r3.xyz = log2(r0.xzw);
  r3.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = r3.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r4.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r0.xzw;
  r0.xzw = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r0.xzw);
  r0.xzw = r0.xzw ? r4.xyz : r3.xyz;
  r2.xyz = r0.xzw * r2.www;
  r1.xyzw = -r2.xyzw + r1.xyzw;
  r0.x = cb0[22].w * cb0[6].x;
  r0.x = v3.y * r0.x;
  r0.z = min(1, r0.x);
  r0.x = 0.5 * r0.x;
  r0.z = sqrt(r0.z);
  r0.w = saturate(r0.y * v3.y + r0.x);
  r0.x = r0.y * v3.y + -r0.x;
  r0.y = r0.w * r0.z;
  r1.xyzw = r0.yyyy * r1.xyzw + r2.xyzw;
  r0.y = cb0[22].w * cb0[4].y;
  r0.z = v3.y * r0.y;
  r0.y = r0.y * v3.y + 1;
  r0.x = r0.z * 0.5 + r0.x;
  r0.x = saturate(r0.x / r0.y);
  r0.x = 1 + -r0.x;
  r0.xyzw = r1.xyzw * r0.xxxx;
  o0.xyzw = v1.wwww * r0.xyzw;

  o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f);                         // 2.2 gamma correction
  o0.rgb *= injectedData.toneMapUINits / injectedData.toneMapGameNits;  // Ratio of UI:Game brightness
  o0.rgb = renodx::math::SafePow(o0.rgb, 1 / 2.2);                      // Inverse 2.2 gamma

  return;
}