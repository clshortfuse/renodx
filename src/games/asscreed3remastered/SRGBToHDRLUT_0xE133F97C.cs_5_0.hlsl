// ---- Created with 3Dmigoto v1.3.16 on Thu May 14 14:08:24 2026

#include "./common.hlsli"

cbuffer ColorGradingGenerateLUTConstscb : register(b6)
{

  struct
  {
    float WhiteScale;
    float MaxNitsHDRTV;
  } g_ColorGradingLUTConsts : packoffset(c0);

}

RWTexture3D<float4> ColorGradingGenerateSRGBToHDRLUT_Output : register(u0);
RWTexture3D<float4> ColorGradingGenerateSRGBToHDRLUT_OutputUI : register(u1);


// 3Dmigoto declarations
#define cmp -


[numthreads(16, 16, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_typed_texture3d (float,float,float,float) u0
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_typed_texture3d (float,float,float,float) u1
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

// Needs manual fix for instruction:
// unknown dcl_: dcl_thread_group 16, 16, 1
  r0.xyz = (uint3)vThreadID.xyz;
  r0.xyz = float3(0.0322580636,0.0322580636,0.0322580636) * r0.xyz;
  r0.xyz = min(float3(1,1,1), r0.xyz);
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    r0.xyz = renodx::color::gamma::DecodeSafe(r0.xyz, 2.2f);
  } else {
    r1.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.xyz;
    r1.xyz = float3(0.947867274,0.947867274,0.947867274) * r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(2.4000001,2.4000001,2.4000001) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
    r0.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
    r0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  }
  r1.x = dot(r0.xyz, float3(0.412390798,0.357584327,0.180480793));
  r1.y = dot(r0.xyz, float3(0.212639004,0.715168655,0.0721923187));
  r1.z = dot(r0.xyz, float3(0.0193308182,0.119194783,0.950532138));
  r0.x = dot(r1.xyz, float3(1.7166512,-0.35567078,-0.253366292));
  r0.y = dot(r1.xyz, float3(-0.66668433,1.61648118,0.0157685466));
  r0.z = dot(r1.xyz, float3(0.0176398568,-0.042770613,0.942103148));
  r1.xyz = float3(9.99999975e-005,9.99999975e-005,9.99999975e-005) * r0.xyz;
  r1.xyz = log2(abs(r1.xyz));
  r1.xyz = float3(0.159301758,0.159301758,0.159301758) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyzw = r1.xxyy * float4(18.8515625,18.6875,18.8515625,18.6875) + float4(0.8359375,1,0.8359375,1);
  r1.xy = r1.zz * float2(18.8515625,18.6875) + float2(0.8359375,1);
  r0.w = r1.x / r1.y;
  r0.w = log2(r0.w);
  r0.w = 78.84375 * r0.w;
  r1.z = exp2(r0.w);
  r2.xy = r2.xz / r2.yw;
  r2.xy = log2(r2.xy);
  r2.xy = float2(78.84375,78.84375) * r2.xy;
  r1.xy = exp2(r2.xy);
  r1.w = 1;
// No code for instruction (needs manual fix):
ColorGradingGenerateSRGBToHDRLUT_Output[vThreadID.xyz] = r1.xyzw;
  r0.w = (RENODX_TONE_MAP_TYPE != 0.f)
             ? g_ColorGradingLUTConsts.WhiteScale
             : (g_ColorGradingLUTConsts.WhiteScale * 2.5 + -100);
  r0.w = max(50, r0.w);
  r0.w = min(600, r0.w);
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = float3(9.99999975e-005,9.99999975e-005,9.99999975e-005) * r0.xyz;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(0.159301758,0.159301758,0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyzw = r0.xxyy * float4(18.8515625,18.6875,18.8515625,18.6875) + float4(0.8359375,1,0.8359375,1);
  r0.xy = r0.zz * float2(18.8515625,18.6875) + float2(0.8359375,1);
  r0.x = r0.x / r0.y;
  r0.x = log2(r0.x);
  r0.x = 78.84375 * r0.x;
  r0.z = exp2(r0.x);
  r1.xy = r1.xz / r1.yw;
  r1.xy = log2(r1.xy);
  r1.xy = float2(78.84375,78.84375) * r1.xy;
  r0.xy = exp2(r1.xy);
  r0.w = 1;
// No code for instruction (needs manual fix):
ColorGradingGenerateSRGBToHDRLUT_OutputUI[vThreadID.xyz] = r0.xyzw;
  return;
}
