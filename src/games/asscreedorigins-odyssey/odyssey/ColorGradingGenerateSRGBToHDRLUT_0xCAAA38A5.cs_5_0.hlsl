#include "../common.hlsli"

// clang-format off
cbuffer ColorGradingGenerateSRGBToHDRLUT_cbuffer : register(b7) {
  struct
  {
    float WhiteScale;
    float MaxNitsHDRTV;
  } ColorGradingGenerateSRGBToHDRLUT_constants: packoffset(c0);
}
// clang-format on

RWTexture3D<float4> ColorGradingGenerateSRGBToHDRLUT_Output : register(u1);
RWTexture3D<float4> ColorGradingGenerateSRGBToHDRLUT_OutputUI : register(u2);

// 3Dmigoto declarations
#define cmp            -
#define DISPATCH_BLOCK 16

[numthreads(DISPATCH_BLOCK, DISPATCH_BLOCK, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture3d (unorm,unorm,unorm,unorm) u1
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture3d (unorm,unorm,unorm,unorm) u2
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 16, 16, 1
  r0.xyz = (uint3)vThreadID.xyz;
  r0.xyz = float3(0.0322580636, 0.0322580636, 0.0322580636) * r0.xyz;
  r0.xyz = min(float3(1, 1, 1), r0.xyz);
#if 0
  r1.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r0.xyz;
  r1.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r0.xyz);
  r0.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r0.xyz = r2.xyz ? r0.xyz : r1.xyz;
#else
  r0.rgb = renodx::color::gamma::DecodeSafe(r0.rgb, 2.2f);
#endif
  r1.x = dot(r0.xyz, float3(0.412390828, 0.357584387, 0.180480748));
  r1.y = dot(r0.xyz, float3(0.212639034, 0.715168774, 0.0721922964));
  r1.z = dot(r0.xyz, float3(0.0193308201, 0.119194753, 0.95053196));
  r0.x = dot(r1.xyz, float3(1.71665084, -0.35567075, -0.253366232));
  r0.y = dot(r1.xyz, float3(-0.666684449, 1.61648142, 0.0157685392));
  r0.z = dot(r1.xyz, float3(0.0176398549, -0.0427706093, 0.942103207));
  r1.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
  r1.xyz = log2(abs(r1.xyz));
  r1.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyzw = r1.xxyy * float4(18.8515625, 18.6875, 18.8515625, 18.6875) + float4(0.8359375, 1, 0.8359375, 1);
  r1.xy = r1.zz * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
  r0.w = r1.x / r1.y;
  r0.w = log2(r0.w);
  r0.w = 78.84375 * r0.w;
  r1.z = exp2(r0.w);
  r2.xy = r2.xz / r2.yw;
  r2.xy = log2(r2.xy);
  r2.xy = float2(78.84375, 78.84375) * r2.xy;
  r1.xy = exp2(r2.xy);
  r1.w = 1;
  // No code for instruction (needs manual fix):
  ColorGradingGenerateSRGBToHDRLUT_Output[vThreadID] = r1;  // store_uav_typed u1.xyzw, vThreadID.xyzz, r1.xyzw
#if 0
  r0.w = ColorGradingGenerateSRGBToHDRLUT_constants.WhiteScale * 2.5 + 100;
#else
  r0.w = ColorGradingGenerateSRGBToHDRLUT_constants.WhiteScale;
#endif

  r0.w = max(48, r0.w);
  r0.w = min(600, r0.w);
  r0.xyz = r0.xyz * r0.www;
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
  // No code for instruction (needs manual fix):
  ColorGradingGenerateSRGBToHDRLUT_OutputUI[vThreadID] = r0;  // store_uav_typed u2.xyzw, vThreadID.xyzz, r0.xyzw
  return;
}
