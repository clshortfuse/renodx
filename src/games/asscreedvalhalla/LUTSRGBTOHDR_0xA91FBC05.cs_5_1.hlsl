#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Mar 22 22:56:58 2025
RWTexture3D<float4> u0 : register(u0, space6);
RWTexture3D<float4> u1 : register(u1, space6);

cbuffer CB0 : register(b0, space6) {
  float4 CB0[1][5];
};

// 3Dmigoto declarations
#define cmp            -
#define DISPATCH_BLOCK 16

[numthreads(DISPATCH_BLOCK, DISPATCH_BLOCK, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture3d (unorm,unorm,unorm,unorm) U0[0:0], space=6
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture3d (unorm,unorm,unorm,unorm) U1[1:1], space=6
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 16, 16, 1
  r0.xyz = (uint3)vThreadID.xyz;
  r0.xyz = float3(0.0322580636, 0.0322580636, 0.0322580636) * r0.xyz;
  r0.xyz = min(float3(1, 1, 1), r0.xyz);
#if 0
  r1.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r0.xyz);
  r2.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r0.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r0.xyz;
  r0.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r1.xyz ? r2.xyz : r0.xyz;
  r1.xyz = log2(r0.xyz);
  r1.xyz = CB0[0][0].yyy * r1.xyz;
  r1.xyz = exp2(r1.xyz);
#else
  r0.rgb = renodx::color::gamma::DecodeSafe(r0.rgb, 2.2f);
  r1.rgb = r0.rgb;
#endif
  r0.w = dot(r0.xyz, float3(0.627403796, 0.329282999, 0.0433130413));
  r1.w = dot(r0.xyz, float3(0.0690973178, 0.919540644, 0.0113622984));
  r0.x = dot(r0.xyz, float3(0.0163914412, 0.0880132914, 0.895595133));
  r2.x = dot(r1.xyz, float3(0.627403796, 0.329282999, 0.0433130413));
  r2.y = dot(r1.xyz, float3(0.0690973178, 0.919540644, 0.0113622984));
  r2.z = dot(r1.xyz, float3(0.0163914412, 0.0880132914, 0.895595133));
  r0.xy = float2(9.99999975e-05, 9.99999975e-05) * r0.xw;
  r0.y = log2(r0.y);
  r0.y = 0.159301758 * r0.y;
  r0.y = exp2(r0.y);
  r0.yz = r0.yy * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
  r0.y = r0.y / r0.z;
  r0.y = log2(r0.y);
  r0.y = 78.84375 * r0.y;
  r3.x = exp2(r0.y);
  r0.y = 9.99999975e-05 * r1.w;
  r0.y = log2(r0.y);
  r0.y = 0.159301758 * r0.y;
  r0.y = exp2(r0.y);
  r0.yz = r0.yy * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
  r0.y = r0.y / r0.z;
  r0.y = log2(r0.y);
  r0.y = 78.84375 * r0.y;
  r3.y = exp2(r0.y);
  r0.x = log2(r0.x);
  r0.x = 0.159301758 * r0.x;
  r0.x = exp2(r0.x);
  r0.xy = r0.xx * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
  r0.x = r0.x / r0.y;
  r0.x = log2(r0.x);
  r0.x = 78.84375 * r0.x;
  r3.z = exp2(r0.x);
  r0.xyz = CB0[0][0].xxx * r2.xyz;
#if 1
  r0.rgb *= (RENODX_GRAPHICS_WHITE_NITS / 270.f);
#endif
  r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyzw = r0.xxyy * float4(18.8515625, 18.6875, 18.8515625, 18.6875) + float4(0.8359375, 1, 0.8359375, 1);
  r0.xy = r1.xz / r1.yw;
  r0.xy = log2(r0.xy);
  r0.xy = float2(78.84375, 78.84375) * r0.xy;
  r1.xy = exp2(r0.xy);
  r0.xy = r0.zz * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
  r0.x = r0.x / r0.y;
  r0.x = log2(r0.x);
  r0.x = 78.84375 * r0.x;
  r1.z = exp2(r0.x);
  r3.w = 1;
  // No code for instruction (needs manual fix):
  u0[vThreadID] = r3;  // store_uav_typed U0[0].xyzw, vThreadID.xyzz, r3.xyzw
  r1.w = 1;
  // No code for instruction (needs manual fix):
  u1[vThreadID] = r1;  // store_uav_typed U1[1].xyzw, vThreadID.xyzz, r1.xyzw
  return;
}
