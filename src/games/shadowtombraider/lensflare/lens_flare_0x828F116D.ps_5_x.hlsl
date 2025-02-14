#include "../shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Feb  4 18:09:49 2025

struct ExposureInfo
{
    float frameLuminanceAverage;   // Offset:    0
    float currentAverageEv;        // Offset:    4
    float frameOptimalEv;          // Offset:    8
    float previousCameraExposure;  // Offset:   12
    float previousCameraInvExposure;// Offset:   16
    float cameraExposure;          // Offset:   20
    float cameraInvExposure;       // Offset:   24
    float _exposureInfo_pad0;      // Offset:   28
    float cameraExposureInternal;  // Offset:   32
    float cameraInvExposureInternal;// Offset:   36
    float previousCameraExposureInternal;// Offset:   40
    float previousCameraInvExposureInternal;// Offset:   44
    uint luminanceIndex;           // Offset:   48
    uint luminanceCount;           // Offset:   52
    float frameHistogramMax;       // Offset:   56
    float frameHistogramPixelCount;// Offset:   60
    float luminanceHistory[16];    // Offset:   64
    uint frameHistogram[64];       // Offset:  128
};

cbuffer MaterialBuffer : register(b3)
{
  float4 MaterialParams[512] : packoffset(c0);
}

SamplerState SamplerGenericAutoWrap_s : register(s6);
Texture2D<float4> p_default_Setup_n1_Texture_texture : register(t0);
StructuredBuffer<ExposureInfo> FrameExposureBuffer : register(t57);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  uint v3 : PSIZE0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(0 != MaterialParams[0].x);
  r0.y = p_default_Setup_n1_Texture_texture.Sample(SamplerGenericAutoWrap_s, v2.xy).x;
  r0.y = MaterialParams[0].y * r0.y;
  r1.xyzw = v1.xyzw * r0.yyyy;
  r0.y = FrameExposureBuffer[0].cameraExposure;
  r0.z = FrameExposureBuffer[0].cameraInvExposure;
  r2.xyz = r1.xyz * r0.zzz;
  r0.xzw = r0.xxx ? r1.xyz : r2.xyz;
  o0.w = r1.w * CUSTOM_LENS_FLARE;
  o0.xyz = r0.xzw * r0.yyy;
  return;
}