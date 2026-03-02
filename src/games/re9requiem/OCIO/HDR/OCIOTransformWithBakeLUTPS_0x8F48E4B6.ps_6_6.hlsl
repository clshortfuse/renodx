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
//   float4 standardMinNitsRect : packoffset(c006.x);
//   float4 secondaryStandardMinNitsRect : packoffset(c007.x);
//   float4 displayMinNitsRect : packoffset(c008.x);
//   float4 secondaryDisplayMinNitsRect : packoffset(c009.x);
//   float4 mdrOutRangeRect : packoffset(c010.x);
//   uint drawMode : packoffset(c011.x);
//   float gammaForHDR : packoffset(c011.y);
//   float displayMaxNitsST2084 : packoffset(c011.z);
//   float displayMinNitsST2084 : packoffset(c011.w);
//   uint drawModeOnMDRPass : packoffset(c012.x);
//   float saturationForHDR : packoffset(c012.y);
//   float2 targetInvSize : packoffset(c012.z);
//   float toeEnd : packoffset(c013.x);
//   float toeStrength : packoffset(c013.y);
//   float blackPoint : packoffset(c013.z);
//   float shoulderStartPoint : packoffset(c013.w);
//   float shoulderStrength : packoffset(c014.x);
//   float whitePaperNitsForOverlay : packoffset(c014.y);
//   float saturationOnDisplayMapping : packoffset(c014.z);
//   float graphScale : packoffset(c014.w);
//   float4 hdrImageRect : packoffset(c015.x);
//   float2 hdrImageRectSize : packoffset(c016.x);
//   float secondaryDisplayMaxNits : packoffset(c016.z);
//   float secondaryDisplayMinNits : packoffset(c016.w);
//   float2 secondaryDisplayMaxNitsRectSize : packoffset(c017.x);
//   float2 secondaryStandardMaxNitsRectSize : packoffset(c017.z);
//   float shoulderAngle : packoffset(c018.x);
//   uint enableHDRAdjustmentForOverlay : packoffset(c018.y);
//   float brightnessAdjustmentForOverlay : packoffset(c018.z);
//   float saturateAdjustmentForOverlay : packoffset(c018.w);
// };

SamplerState PointBorder : register(s2, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _11 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

#if SKIP_OCIO_LUT
  SV_Target.rgb = _11.rgb;
  SV_Target.rgb = renodx::color::bt2020::from::AP1(SV_Target.rgb);
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    SV_Target.rgb = renodx::color::correct::GammaSafe(SV_Target.rgb);
  }
  SV_Target.rgb = renodx::color::pq::EncodeSafe(SV_Target.rgb, 100.f);
  return SV_Target;
#endif

#if 1
  if (TONE_MAP_TYPE != 0.f) {
    _11.rgb = ApplyCustomGrading(_11.rgb);
  }
  float _17 = SetPreExposureForOCIOLUT();
#else
  float _17 = whitePaperNits * 0.009999999776482582f;
#endif

  float _18 = _17 * _11.x;
  float _19 = _17 * _11.y;
  float _20 = _17 * _11.z;
  float _35;
  float _50;
  float _65;

#if 0
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
#else
  if (RENODX_LUT_SHAPER == 0.f) {
    _35 = renodx::color::acescc::Encode(_18);
    _50 = renodx::color::acescc::Encode(_19);
    _65 = renodx::color::acescc::Encode(_20);
  } else {
    _35 = renodx::color::pq::Encode(_18, 100.f);
    _50 = renodx::color::pq::Encode(_19, 100.f);
    _65 = renodx::color::pq::Encode(_20, 100.f);
  }
#endif

  float3 _74;
  if (TONE_MAP_TYPE == 0.f) {
    _74 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_35 * 0.984375f) + 0.0078125f), ((_50 * 0.984375f) + 0.0078125f), ((_65 * 0.984375f) + 0.0078125f)), 0.0f).rgb;
  } else {
    _74 = renodx::lut::SampleTetrahedral(SrcLUT, float3(_35, _50, _65), 64u).rgb;
  }

#if 1
  _74.rgb = ApplyPostToneMapProcessingPQInput(_74.rgb, TEXCOORD, _11.rgb, SrcLUT, TrilinearClamp);
#endif

  SV_Target.x = _74.x;
  SV_Target.y = _74.y;
  SV_Target.z = _74.z;
  SV_Target.w = 1.0f;
  return SV_Target;
}
