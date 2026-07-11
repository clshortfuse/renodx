#include "./common.hlsl"

// Sunshaft fix thanks to Miru97

// ---- Created with 3Dmigoto v1.3.16 on Fri Mar 21 23:49:27 2025

cbuffer plLightShaftConstants : register(b2) {
  float4 g_cbLightShaftInfo0 : packoffset(c0);
  float4 g_cbLightShaftPower : packoffset(c1);
  float4 g_cbLightShaftNoizeParams : packoffset(c2);
  float4 g_cbProcSize : packoffset(c3);
  float4 g_cbLightShaftBlurWeights[4] : packoffset(c4);
  float4 g_cbViewportInfo : packoffset(c8);
}

SamplerState sampleLinear_s : register(s7);
SamplerState samplePoint_s : register(s8);
Texture2D<float4> g_InScene : register(t0);
Texture2D<float4> g_InNoize : register(t1);
Texture2D<float> g_InDepth : register(t2);
RWTexture2D<float4> g_RwLightShaftWork1 : register(u0);

// 3Dmigoto declarations
#define cmp -

[numthreads(16, 16, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u0
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 16, 16, 1
  r0.xy = (uint2)vThreadID.xy;
  r0.xy = float2(0.5, 0.5) + r0.xy;
  r0.xy = r0.xy / g_cbProcSize.xy;
  r0.zw = cmp(g_cbViewportInfo.xy >= r0.xy);
  r0.z = r0.w ? r0.z : 0;
  if (r0.z != 0) {
    r1.xyzw = g_InScene.SampleLevel(sampleLinear_s, r0.xy, 0).xyzw;
    r1.xyzw = max(float4(0, 0, 0, 0), r1.xyzw);
    r0.z = saturate(g_cbLightShaftNoizeParams.z);
    r2.xy = g_cbLightShaftInfo0.xy * float2(-1, 1) + r0.xy;
    r2.zw = g_cbLightShaftNoizeParams.xx * r2.xy;
    r2.zw = floor(r2.zw);
    r2.xy = r2.xy * g_cbLightShaftNoizeParams.xx + -r2.zw;
    r0.w = g_InNoize.SampleLevel(samplePoint_s, r2.xy, 0).x;
    r0.w = cmp(g_cbLightShaftNoizeParams.y < r0.w);
    r0.w = r0.w ? 1.000000 : 0;
    r2.xyzw = r0.wwww * r1.xyzw + -r1.xyzw;
    r1.xyzw = r0.zzzz * r2.xyzw + r1.xyzw;
    r0.z = cmp(g_cbLightShaftInfo0.z < 1);

    float invDptParam = 1.f - g_cbLightShaftInfo0.z;

    if (SUNSHAFT_FIX == 0.f) {
      if (r0.z != 0) {
        r0.x = g_InDepth.SampleLevel(samplePoint_s, r0.xy, 0).x;
        r0.x = cmp(g_cbLightShaftInfo0.z < r0.x);
        r0.x = r0.x ? 0 : 1;
      } else {
        r0.x = 0;
      }
    } else if (SUNSHAFT_FIX == 1.f) {  // Miru97's sunshaft/light shaft fix
      r0.z = cmp(invDptParam < 1);
      if (r0.z != 0) {
        r0.x = g_InDepth.SampleLevel(samplePoint_s, r0.xy, 0).x;
        r0.x = cmp(invDptParam < r0.x);
        r0.x = r0.x ? 0 : 1;
      } else {
        r0.x = 0;
      }
    }

    r0.xyzw = r1.xyzw * r0.xxxx;

    // No code for instruction (needs manual fix):
    // store_uav_typed u0.xyzw, vThreadID.xyyy, r0.xyzw
    g_RwLightShaftWork1[vThreadID.xy] = r0.xyzw;
  }
  return;
}
