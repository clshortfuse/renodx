#include "../CBuffers/HDRMapping.hlsli"
#include "../OCIO.hlsli"

Texture2D<float4> SrcTexture : register(t0);

Texture3D<float4> SrcLUT : register(t1);

// cbuffer HDRMapping : register(b0) {
//   float whitePaperNits : packoffset(c000.x);
//   float configImageAlphaScale : packoffset(c000.y);
//   float displayMaxNits : packoffset(c000.z);
//   float displayMinNits : packoffset(c000.w);
//   float4 displayMaxNitsRect : packoffset(c001.x);
//   float4 secondaryDisplayMaxNitsRect : packoffset(c002.x);
//   float4 standardMaxNitsRect : packoffset(c003.x);
//   float4 secondaryStandardMaxNitsRect : packoffset(c004.x);
//   float2 displayMaxNitsRectSize : packoffset(c005.x);
//   float2 standardMaxNitsRectSize : packoffset(c005.z);
//   float4 mdrOutRangeRect : packoffset(c006.x);
//   uint drawMode : packoffset(c007.x);
//   float gammaForHDR : packoffset(c007.y);
//   float displayMaxNitsST2084 : packoffset(c007.z);
//   float displayMinNitsST2084 : packoffset(c007.w);
//   uint drawModeOnMDRPass : packoffset(c008.x);
//   float saturationForHDR : packoffset(c008.y);
//   float2 targetInvSize : packoffset(c008.z);
//   float toeEnd : packoffset(c009.x);
//   float toeStrength : packoffset(c009.y);
//   float blackPoint : packoffset(c009.z);
//   float shoulderStartPoint : packoffset(c009.w);
//   float shoulderStrength : packoffset(c010.x);
//   float whitePaperNitsForOverlay : packoffset(c010.y);
//   float saturationOnDisplayMapping : packoffset(c010.z);
//   float graphScale : packoffset(c010.w);
//   float4 hdrImageRect : packoffset(c011.x);
//   float2 hdrImageRectSize : packoffset(c012.x);
//   float secondaryDisplayMaxNits : packoffset(c012.z);
//   float secondaryDisplayMinNits : packoffset(c012.w);
//   float2 secondaryDisplayMaxNitsRectSize : packoffset(c013.x);
//   float2 secondaryStandardMaxNitsRectSize : packoffset(c013.z);
//   float shoulderAngle : packoffset(c014.x);
//   uint enableHDRAdjustmentForOverlay : packoffset(c014.y);
//   float brightnessAdjustmentForOverlay : packoffset(c014.z);
//   float saturateAdjustmentForOverlay : packoffset(c014.w);
// };

SamplerState PointBorder : register(s2, space32);

SamplerState TrilinearClamp : register(s9, space32);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
};

OutputSignature main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD) {
  float4 SV_Target;
  float4 SV_Target_1;
  float4 _11 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  float _17;

#if 1
  SetExposureAndContrastForOCIOLUT(_17, _11.rgb);
#else
  if (TONE_MAP_TYPE == 0.f) {
    _17 = whitePaperNits * 0.01f;
  } else {
    _17 = RENODX_CUSTOM_EXPOSURE;

#if APPLY_HIGHLIGHT_BOOST == 1
    float y_in = renodx::color::y::from::AP1(_11.rgb);
    float y_out = SplitContrast(y_in, 1.f, 1.1f, 0.18f * RENODX_CUSTOM_EXPOSURE);

    _11.rgb = renodx::color::correct::Luminance(_11.rgb, y_in, y_out);
#elif APPLY_HIGHLIGHT_BOOST == 2
    _11.rgb = SplitContrast(_11.rgb, 1.f, 1.1f, 0.18f * RENODX_CUSTOM_EXPOSURE);
#endif
  }
#endif

  float _18 = _17 * _11.x;
  float _19 = _17 * _11.y;
  float _20 = _17 * _11.z;

#if SKIP_OCIO_LUT
  SV_Target.rgb = float3(_18, _19, _20);
  SV_Target.rgb = renodx::color::bt2020::from::AP1(SV_Target.rgb);
  SV_Target.rgb = renodx::color::pq::EncodeSafe(SV_Target.rgb, 100.f);
  return SV_Target;
#endif

  float _35;
  float _50;
  float _65;
  if (!(_18 <= 0.0f)) {
    if (_18 < 3.0517578125e-05f) {
      _35 = ((log2((_18 * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _35 = ((log2(_18) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _35 = -0.35844698548316956f;
  }
  if (!(_19 <= 0.0f)) {
    if (_19 < 3.0517578125e-05f) {
      _50 = ((log2((_19 * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _50 = ((log2(_19) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _50 = -0.35844698548316956f;
  }
  if (!(_20 <= 0.0f)) {
    if (_20 < 3.0517578125e-05f) {
      _65 = ((log2((_20 * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _65 = ((log2(_20) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _65 = -0.35844698548316956f;
  }
  float4 _74 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_35 * 0.984375f) + 0.0078125f), ((_50 * 0.984375f) + 0.0078125f), ((_65 * 0.984375f) + 0.0078125f)), 0.0f);
  SV_Target.x = _74.x;
  SV_Target.y = _74.y;
  SV_Target.z = _74.z;
  SV_Target.w = 1.0f;
  SV_Target_1.x = _74.x;
  SV_Target_1.y = _74.y;
  SV_Target_1.z = _74.z;
  SV_Target_1.w = 1.0f;

  // SV_Target.rgb *= 999.f;
  // SV_Target_1.rgb *= 999.f;

  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

