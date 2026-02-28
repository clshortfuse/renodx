#include "../common.hlsli"

cbuffer HDRMapping : register(b1) {
  float whitePaperNits : packoffset(c000.x);
  float configImageAlphaScale : packoffset(c000.y);
  float displayMaxNits : packoffset(c000.z);
  float displayMinNits : packoffset(c000.w);
  float4 displayMaxNitsRect : packoffset(c001.x);
  float4 secondaryDisplayMaxNitsRect : packoffset(c002.x);
  float4 standardMaxNitsRect : packoffset(c003.x);
  float4 secondaryStandardMaxNitsRect : packoffset(c004.x);
  float2 displayMaxNitsRectSize : packoffset(c005.x);
  float2 standardMaxNitsRectSize : packoffset(c005.z);
  float4 standardMinNitsRect : packoffset(c006.x);
  float4 secondaryStandardMinNitsRect : packoffset(c007.x);
  float4 displayMinNitsRect : packoffset(c008.x);
  float4 secondaryDisplayMinNitsRect : packoffset(c009.x);
  float4 mdrOutRangeRect : packoffset(c010.x);
  uint drawMode : packoffset(c011.x);
  float gammaForHDR : packoffset(c011.y);
  float displayMaxNitsST2084 : packoffset(c011.z);
  float displayMinNitsST2084 : packoffset(c011.w);
  uint drawModeOnMDRPass : packoffset(c012.x);
  float saturationForHDR : packoffset(c012.y);
  float2 targetInvSize : packoffset(c012.z);
  float toeEnd : packoffset(c013.x);
  float toeStrength : packoffset(c013.y);
  float blackPoint : packoffset(c013.z);
  float shoulderStartPoint : packoffset(c013.w);
  float shoulderStrength : packoffset(c014.x);

  // float whitePaperNitsForOverlay : packoffset(c014.y);
  float ORIGINAL_whitePaperNitsForOverlay : packoffset(c014.y);

  float saturationOnDisplayMapping : packoffset(c014.z);
  float graphScale : packoffset(c014.w);
  float4 hdrImageRect : packoffset(c015.x);
  float2 hdrImageRectSize : packoffset(c016.x);
  float secondaryDisplayMaxNits : packoffset(c016.z);
  float secondaryDisplayMinNits : packoffset(c016.w);
  float2 secondaryDisplayMaxNitsRectSize : packoffset(c017.x);
  float2 secondaryStandardMaxNitsRectSize : packoffset(c017.z);
  float shoulderAngle : packoffset(c018.x);

  // uint enableHDRAdjustmentForOverlay : packoffset(c018.y);
  uint ORIGINAL_enableHDRAdjustmentForOverlay : packoffset(c018.y);

  float brightnessAdjustmentForOverlay : packoffset(c018.z);
  float saturateAdjustmentForOverlay : packoffset(c018.w);
};

static float whitePaperNitsForOverlay = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_whitePaperNitsForOverlay : RENODX_GRAPHICS_WHITE_NITS;
static uint enableHDRAdjustmentForOverlay = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_enableHDRAdjustmentForOverlay : 0u;
