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
  SV_Target.w = 1.0f;

  float4 _11 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  if (TONE_MAP_TYPE != 0.f) {
    float3 untonemapped_ap1 = _11.rgb;
#if 1
    return float4(ApplyToneMapEncodePQ(untonemapped_ap1, displayMaxNits, whitePaperNits, TEXCOORD), SV_Target.w);
    // return float4(renodx_custom::aces::rrtodt_academy_rec2020_1000nits_15nits_st2084::Apply(untonemapped_ap1), SV_Target.w);
#else
    SV_Target.rgb = renodx_custom::aces::odt_srgb_100nits_dim::Apply(
        renodx_custom::aces::rrt::ApplyToODTInputFromAP1(_11.rgb));

    if (RENODX_GAMMA_CORRECTION != 0.f) {
      SV_Target.rgb = renodx::color::gamma::DecodeSafe(SV_Target.rgb);
    } else {
      SV_Target.rgb = renodx::color::srgb::DecodeSafe(SV_Target.rgb);
    }

    SV_Target.rgb = renodx::color::bt2020::from::BT709(SV_Target.rgb);
    SV_Target.rgb *= RENODX_DIFFUSE_WHITE_NITS;
    SV_Target.rgb = renodx::color::pq::EncodeSafe(SV_Target.rgb, 1.f);

    return SV_Target;
#endif
  }

  float _17 = whitePaperNits * 0.01f;
  float _18 = _17 * _11.x;
  float _19 = _17 * _11.y;
  float _20 = _17 * _11.z;
  float _35;
  float _50;
  float _65;

  _35 = renodx::color::acescc::Encode(_18);
  _50 = renodx::color::acescc::Encode(_19);
  _65 = renodx::color::acescc::Encode(_20);

  float3 _74 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_35 * 0.984375f) + 0.0078125f), ((_50 * 0.984375f) + 0.0078125f), ((_65 * 0.984375f) + 0.0078125f)), 0.0f).rgb;

  SV_Target.x = _74.x;
  SV_Target.y = _74.y;
  SV_Target.z = _74.z;
  return SV_Target;
}
