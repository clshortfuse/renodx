
#include "./shared.h"

struct FrameLuminanceInfo {
  float frameLuminance;                  // Offset:    0
  float avgLuminance;                    // Offset:    4
  float keyValue;                        // Offset:    8
  float avgKeyValueOverLuminance;        // Offset:   12
  float brightness_scale;                // Offset:   16
  float brightness_scale_final;          // Offset:   20
  float delayed_brightness_scale_final;  // Offset:   24
  float pad;                             // Offset:   28
};

cbuffer ToneMapInfo : register(b4) {
  uint currentEntry : packoffset(c0);
  uint numEntries : packoffset(c0.y);
  uint uavOffset : packoffset(c0.z);
  uint numXTiles : packoffset(c0.w);
  uint numYTiles : packoffset(c1);
  uint numTotalTiles : packoffset(c1.y);
  float keyAlpha : packoffset(c1.z);
  float keyBeta : packoffset(c1.w);
  float keyGamma : packoffset(c2);
  float maxLuminance : packoffset(c2.y);
  float adaptationPerc : packoffset(c2.z);
  float adaptationShiftLimit : packoffset(c2.w);
  float adaptationShiftXtoLimit : packoffset(c3);
  float toneClampEnabled : packoffset(c3.y);
  float toneSmoothEnabled : packoffset(c3.z);
  float whitePoint : packoffset(c3.w);
  float g_fExposure_pre : packoffset(c4);
  float g_fExposure_post : packoffset(c4.y);
  float g_fSplitScreenPosition : packoffset(c4.z);
  float g_fGlobalDelayMixValue : packoffset(c4.w);
}

SamplerState SamplerGenericPointClamp_s : register(s10);
StructuredBuffer<FrameLuminanceInfo> frameLuminanceInfo : register(t0);
Texture2D<float4> frameBufferCopy : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(toneSmoothEnabled != 0.000000);
  r0.y = frameLuminanceInfo[currentEntry].delayed_brightness_scale_final;
  r0.z = frameLuminanceInfo[currentEntry].brightness_scale;
  r0.x = r0.x ? r0.y : r0.z;
  r0.x = -1 + r0.x;
  r0.x = adaptationPerc * r0.x + 1;
  r1.xyzw = frameBufferCopy.SampleLevel(SamplerGenericPointClamp_s, v1.xy, 0).xyzw;
  
  // Custom: Support RGBA16F upgrade
  r1.xyz = max(0, r1.xyz);

  r0.yzw = g_fExposure_pre * r1.xyz;
  o0.w = r1.w;
  r0.xyz = r0.yzw * r0.xxx;
  r0.xyz = g_fExposure_post * r0.xyz;

  if (RENODX_TONE_MAP_TYPE != 0) {
    o0.rgb = r0.xyz;
    return;
  }

  r0.w = max(r0.y, r0.z);
  r0.w = max(r0.x, r0.w);
  r1.x = min(r0.y, r0.z);
  r1.x = min(r1.x, r0.x);
  r0.w = r1.x + r0.w;
  r1.x = r0.w * 0.5 + 1;
  r0.w = 0.5 * r0.w;
  r1.y = whitePoint * whitePoint;
  r1.y = r0.w / r1.y;
  r1.y = 1 + r1.y;
  r1.y = r1.y * r0.w;
  r0.w = max(1.1920929e-07, r0.w);
  r1.x = r1.y / r1.x;
  r0.w = r1.x / r0.w;
  o0.xyz = r0.xyz * r0.www;
  return;
}
