#include "../shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Mon Jun 15 21:51:24 2026
cbuffer cb6_buf : register(b6) {
  float4 cb6[1];
}

RWTexture3D<float4> u0 : register(u0);
RWTexture3D<float4> u4 : register(u4);

// 3Dmigoto declarations
#define cmp -

[numthreads(16, 16, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (uint3)vThreadID.xyz;
  r0.xyz = float3(0.0322580636, 0.0322580636, 0.0322580636) * r0.xyz;
  r0.xyz = min(float3(1, 1, 1), r0.xyz);

// sRGB decode
#if RENODX_UI_GAMMA_CORRECTION
  r0.xyz = renodx::color::gamma::Decode(max(0, r0.rgb));
#else
  r1.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r0.xyz;
  r1.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r0.xyz);
  r0.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r0.xyz = r2.xyz ? r0.xyz : r1.xyz;
#endif

  r0.w = dot(r0.xyz, float3(0.627403796, 0.329282999, 0.0433130413));
  r0.w = 9.99999975e-05 * r0.w;
  r0.w = log2(r0.w);
  r0.w = 0.159301758 * r0.w;
  r0.w = exp2(r0.w);
  r1.xy = r0.ww * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
  r0.w = r1.x / r1.y;
  r0.w = log2(r0.w);
  r0.w = 78.84375 * r0.w;
  r1.x = exp2(r0.w);
  r0.w = dot(r0.xyz, float3(0.0690973178, 0.919540644, 0.0113622984));
  r0.w = 9.99999975e-05 * r0.w;
  r0.w = log2(r0.w);
  r0.w = 0.159301758 * r0.w;
  r0.w = exp2(r0.w);
  r2.xy = r0.ww * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
  r0.w = r2.x / r2.y;
  r0.w = log2(r0.w);
  r0.w = 78.84375 * r0.w;
  r1.y = exp2(r0.w);
  r0.w = dot(r0.xyz, float3(0.0163914412, 0.0880132914, 0.895595133));
#if 0
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb6[0].yyy * r0.xyz;
  r0.xyz = exp2(r0.xyz);
#endif
  r0.w = 9.99999975e-05 * r0.w;
  r0.w = log2(r0.w);
  r0.w = 0.159301758 * r0.w;
  r0.w = exp2(r0.w);
  r2.xy = r0.ww * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
  r0.w = r2.x / r2.y;
  r0.w = log2(r0.w);
  r0.w = 78.84375 * r0.w;
  r1.z = exp2(r0.w);
  r1.w = 1;
  u4[vThreadID] = r1;
  r1.x = dot(r0.xyz, float3(0.627403796, 0.329282999, 0.0433130413));
  r1.y = dot(r0.xyz, float3(0.0690973178, 0.919540644, 0.0113622984));
  r1.z = dot(r0.xyz, float3(0.0163914412, 0.0880132914, 0.895595133));
  // r0.xyz = cb6[0].xxx * r1.xyz;
  r0.rgb = RENODX_GRAPHICS_WHITE_NITS * r1.rgb;
  r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyzw = r0.xxyy * float4(18.8515625, 18.6875, 18.8515625, 18.6875) + float4(0.8359375, 1, 0.8359375, 1);
  r0.xy = r0.zz * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
  r0.x = r0.x / r0.y;
  r0.x = log2(r0.x);
  r0.x = 78.84375 * r0.x;
  r0.z = exp2(r0.x);
  r1.xy = r1.xz / r1.yw;
  r1.xy = log2(r1.xy);
  r1.xy = float2(78.84375, 78.84375) * r1.xy;
  r0.xy = exp2(r1.xy);
  r0.w = 1;
  u0[vThreadID] = r0;
  return;
}
