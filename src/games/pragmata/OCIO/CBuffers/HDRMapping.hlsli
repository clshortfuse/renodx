#include "../../common.hlsli"

cbuffer HDRMapping : register(b0) {
  // float whitePaperNits : packoffset(c000.x);
  float ORIGINAL_whitePaperNits : packoffset(c000.x);
  float configImageAlphaScale : packoffset(c000.y);
  float displayMaxNits : packoffset(c000.z);
  float displayMinNits : packoffset(c000.w);
  float4 displayMaxNitsRect : packoffset(c001.x);
  float4 secondaryDisplayMaxNitsRect : packoffset(c002.x);
  float4 standardMaxNitsRect : packoffset(c003.x);
  float4 secondaryStandardMaxNitsRect : packoffset(c004.x);
  float2 displayMaxNitsRectSize : packoffset(c005.x);
  float2 standardMaxNitsRectSize : packoffset(c005.z);
  float4 mdrOutRangeRect : packoffset(c006.x);
  uint drawMode : packoffset(c007.x);
  // float gammaForHDR : packoffset(c007.y);
  float ORIGINAL_gammaForHDR : packoffset(c007.y);
  float displayMaxNitsST2084 : packoffset(c007.z);
  float displayMinNitsST2084 : packoffset(c007.w);
  uint drawModeOnMDRPass : packoffset(c008.x);
  // float saturationForHDR : packoffset(c008.y);
  float ORIGINAL_saturationForHDR : packoffset(c008.y);
  float2 targetInvSize : packoffset(c008.z);
  float toeEnd : packoffset(c009.x);
  float toeStrength : packoffset(c009.y);
  float blackPoint : packoffset(c009.z);
  float shoulderStartPoint : packoffset(c009.w);
  float shoulderStrength : packoffset(c010.x);
  // float whitePaperNitsForOverlay : packoffset(c010.y);
  float ORIGINAL_whitePaperNitsForOverlay : packoffset(c010.y);
  float saturationOnDisplayMapping : packoffset(c010.z);
  float graphScale : packoffset(c010.w);
  float4 hdrImageRect : packoffset(c011.x);
  float2 hdrImageRectSize : packoffset(c012.x);
  float secondaryDisplayMaxNits : packoffset(c012.z);
  float secondaryDisplayMinNits : packoffset(c012.w);
  float2 secondaryDisplayMaxNitsRectSize : packoffset(c013.x);
  float2 secondaryStandardMaxNitsRectSize : packoffset(c013.z);
  float shoulderAngle : packoffset(c014.x);
  // uint enableHDRAdjustmentForOverlay : packoffset(c014.y);
  uint ORIGINAL_enableHDRAdjustmentForOverlay : packoffset(c014.y);
  float brightnessAdjustmentForOverlay : packoffset(c014.z);
  float saturateAdjustmentForOverlay : packoffset(c014.w);
};

static float whitePaperNitsForOverlay = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_whitePaperNitsForOverlay : RENODX_GRAPHICS_WHITE_NITS;
static uint enableHDRAdjustmentForOverlay = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_enableHDRAdjustmentForOverlay : 0u;

static float gammaForHDR = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_gammaForHDR : 1.f;

static float saturationForHDR = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_saturationForHDR : 0.f;

static float whitePaperNits = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_whitePaperNits : RENODX_DIFFUSE_WHITE_NITS;
// static float whitePaperNits = ORIGINAL_whitePaperNits;

void SetExposureAndContrastForOCIOLUT(inout float exposure, inout float3 color) {
  if (TONE_MAP_TYPE == 0.f) {
    exposure = whitePaperNits * 0.01f;
  } else {
    exposure = RENODX_CUSTOM_EXPOSURE;

#if APPLY_HIGHLIGHT_BOOST == 1
    float y_in = LuminosityFromAP1LuminanceNormalized(color);
    float y_out = SplitContrast(y_in, 1.f, 1.1f, 0.18f * RENODX_CUSTOM_EXPOSURE);

    color = renodx::color::correct::Luminance(color, y_in, y_out);
#elif APPLY_HIGHLIGHT_BOOST == 2
    color = SplitContrast(color, 1.f, 1.1f, 0.18f * RENODX_CUSTOM_EXPOSURE);
#endif
  }
  return;
}
