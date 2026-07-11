// ---- Created with 3Dmigoto v1.3.16 on Tue Nov  5 03:23:23 2024
// UI

#include "./shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[10];
}

cbuffer cb1 : register(b1) {
  float4 cb1[29];
}

cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float2 v0 : TEXCOORD0,
    float4 v1 : SV_POSITION0,
    out float4 o0 : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(0 < cb2[9].w);
  r1.xyzw = t2.Sample(s0_s, v0.xy).xyzw;
  r0.y = cb2[8].z * r1.x + cb2[8].w;
  r0.y = 1 / r0.y;
  r0.zw = cb2[6].yz + -cb2[6].zy;
  r0.z = r1.x * r0.z + cb2[6].z;
  r0.x = r0.x ? r0.z : r0.y;
  r0.x = -cb2[6].y + r0.x;
  r0.x = r0.x / r0.w;
  r0.y = cmp(r0.x < 0.100000001);
  r0.x = cmp(0.899999976 < r0.x);
  r0.x = (int)r0.x | (int)r0.y;
  r0.yz = v0.xy * float2(2, 2) + float2(-1, -1);
  r1.yzw = cb0[3].xzw * r0.zzz;
  r0.yzw = cb0[2].xzw * r0.yyy + r1.yzw;
  r0.yzw = cb0[4].xzw * r1.xxx + r0.yzw;
  r0.yzw = cb0[5].xzw + r0.yzw;
  r0.yz = r0.yz / r0.ww;
  r0.yz = saturate(r0.yz * cb1[28].xy + cb1[28].zw);
  r1.xyzw = t0.Sample(s1_s, r0.yz).xyzw;
  r0.y = max(r1.x, r1.y);
  r0.z = 1 + -r1.z;
  r0.y = r0.y * r0.z;
  o0.w = r0.x ? 0 : r0.y;
  r0.x = 1 + -cb0[1].w;
  r0.x = r1.y * r0.x;
  r0.x = max(r1.x, r0.x);
  r0.x = r0.x * r0.z;
  r1.xyzw = t1.Sample(s0_s, v0.xy).xyzw;
  r0.yzw = -cb0[1].xyz + r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + cb0[1].xyz;
  r1.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r0.xyz;
  r2.xyz = log2(abs(r0.xyz));
  r0.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r0.xyz);
  r2.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  o0.xyz = r0.xyz ? r1.xyz : r2.xyz;

  o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f);                         // 2.2 gamma correction
  o0.rgb *= injectedData.toneMapUINits / injectedData.toneMapGameNits;  // Ratio of UI:Game brightness
  o0.rgb = renodx::math::SafePow(o0.rgb, 1 / 2.2);                      // Inverse 2.2 gamma

  return;
}