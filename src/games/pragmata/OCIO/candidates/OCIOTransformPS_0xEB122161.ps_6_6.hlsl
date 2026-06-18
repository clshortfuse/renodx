#include "../../common.hlsli"
#include "../CBuffers/HDRMapping.hlsli"

Texture2D<float4> SrcTexture : register(t0);

Texture2D<float4> OCIO_lut1d_0 : register(t1);

Texture3D<float4> OCIO_lut3d_1 : register(t2);

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

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _13 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _19 = whitePaperNits * 0.009999999776482582f;
  float _20 = _19 * _13.x;
  float _21 = _19 * _13.y;
  float _22 = _19 * _13.z;

  // AP1 -> AP0
  float _25 = mad(_22, 0.1638689935207367f, mad(_21, 0.1406790018081665f, (_20 * 0.6954519748687744f)));
  float _28 = mad(_22, 0.0955343022942543f, mad(_21, 0.8596709966659546f, (_20 * 0.04479460045695305f)));
  float _31 = mad(_22, 1.0015000104904175f, mad(_21, 0.004025210160762072f, (_20 * -0.00552588002756238f)));
  float _32 = abs(_25);
  float _45;
  float _74;
  float _101;
  float _273;
  float _274;
  float _275;
  float _276;
  float _277;
  float _355;
  float _356;
  float _357;
  if (_32 > 6.103515625e-05f) {
    float _35 = min(_32, 65504.0f);
    float _37 = floor(log2(_35));
    float _38 = exp2(_37);
    _45 = dot(float3(_37, ((_35 - _38) / _38), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _45 = (_32 * 16777216.0f);
  }
  float _48 = _45 + select((_25 < 0.0f), 32768.0f, 0.0f);
  float _50 = floor(_48 * 0.00024420025874860585f);
  float4 _59 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_48 + 0.5f) - (_50 * 4095.0f)) * 0.000244140625f), ((_50 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _61 = abs(_28);
  if (_61 > 6.103515625e-05f) {
    float _64 = min(_61, 65504.0f);
    float _66 = floor(log2(_64));
    float _67 = exp2(_66);
    _74 = dot(float3(_66, ((_64 - _67) / _67), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _74 = (_61 * 16777216.0f);
  }
  float _77 = _74 + select((_28 < 0.0f), 32768.0f, 0.0f);
  float _79 = floor(_77 * 0.00024420025874860585f);
  float4 _86 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_77 + 0.5f) - (_79 * 4095.0f)) * 0.000244140625f), ((_79 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _88 = abs(_31);
  if (_88 > 6.103515625e-05f) {
    float _91 = min(_88, 65504.0f);
    float _93 = floor(log2(_91));
    float _94 = exp2(_93);
    _101 = dot(float3(_93, ((_91 - _94) / _94), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _101 = (_88 * 16777216.0f);
  }
  float _104 = _101 + select((_31 < 0.0f), 32768.0f, 0.0f);
  float _106 = floor(_104 * 0.00024420025874860585f);
  float4 _113 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_104 + 0.5f) - (_106 * 4095.0f)) * 0.000244140625f), ((_106 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _115 = _59.x * 64.0f;
  float _116 = _86.x * 64.0f;
  float _117 = _113.x * 64.0f;
  float _118 = floor(_115);
  float _119 = floor(_116);
  float _120 = floor(_117);
  float _121 = _115 - _118;
  float _122 = _116 - _119;
  float _123 = _117 - _120;
  float _127 = (_120 + 0.5f) * 0.015384615398943424f;
  float _128 = (_119 + 0.5f) * 0.015384615398943424f;
  float _129 = (_118 + 0.5f) * 0.015384615398943424f;
  float4 _132 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _128, _129), 0.0f);
  float _136 = _127 + 0.015384615398943424f;
  float _137 = _128 + 0.015384615398943424f;
  float _138 = _129 + 0.015384615398943424f;
  float4 _139 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _137, _138), 0.0f);
  if (!(!(_121 >= _122))) {
    if (!(!(_122 >= _123))) {
      float4 _147 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _128, _138), 0.0f);
      float4 _151 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _137, _138), 0.0f);
      float _155 = _121 - _122;
      float _156 = _122 - _123;
      _273 = ((_151.x * _156) + (_147.x * _155));
      _274 = ((_151.y * _156) + (_147.y * _155));
      _275 = ((_151.z * _156) + (_147.z * _155));
      _276 = _121;
      _277 = _123;
    } else {
      if (!(!(_121 >= _123))) {
        float4 _169 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _128, _138), 0.0f);
        float4 _173 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _128, _138), 0.0f);
        float _177 = _121 - _123;
        float _178 = _123 - _122;
        _273 = ((_173.x * _178) + (_169.x * _177));
        _274 = ((_173.y * _178) + (_169.y * _177));
        _275 = ((_173.z * _178) + (_169.z * _177));
        _276 = _121;
        _277 = _122;
      } else {
        float4 _189 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _128, _129), 0.0f);
        float4 _193 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _128, _138), 0.0f);
        float _197 = _123 - _121;
        float _198 = _121 - _122;
        _273 = ((_193.x * _198) + (_189.x * _197));
        _274 = ((_193.y * _198) + (_189.y * _197));
        _275 = ((_193.z * _198) + (_189.z * _197));
        _276 = _123;
        _277 = _122;
      }
    }
  } else {
    if (!(!(_122 <= _123))) {
      float4 _211 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _128, _129), 0.0f);
      float4 _215 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _137, _129), 0.0f);
      float _219 = _123 - _122;
      float _220 = _122 - _121;
      _273 = ((_215.x * _220) + (_211.x * _219));
      _274 = ((_215.y * _220) + (_211.y * _219));
      _275 = ((_215.z * _220) + (_211.z * _219));
      _276 = _123;
      _277 = _121;
    } else {
      if (!(!(_121 >= _123))) {
        float4 _233 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _137, _129), 0.0f);
        float4 _237 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _137, _138), 0.0f);
        float _241 = _122 - _121;
        float _242 = _121 - _123;
        _273 = ((_237.x * _242) + (_233.x * _241));
        _274 = ((_237.y * _242) + (_233.y * _241));
        _275 = ((_237.z * _242) + (_233.z * _241));
        _276 = _122;
        _277 = _123;
      } else {
        float4 _253 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _137, _129), 0.0f);
        float4 _257 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _137, _129), 0.0f);
        float _261 = _122 - _123;
        float _262 = _123 - _121;
        _273 = ((_257.x * _262) + (_253.x * _261));
        _274 = ((_257.y * _262) + (_253.y * _261));
        _275 = ((_257.z * _262) + (_253.z * _261));
        _276 = _122;
        _277 = _121;
      }
    }
  }
  float _278 = 1.0f - _276;
  float _288 = ((_278 * _132.x) + _273) + (_277 * _139.x);
  float _289 = ((_278 * _132.y) + _274) + (_277 * _139.y);
  float _290 = ((_278 * _132.z) + _275) + (_277 * _139.z);
  if (!((drawMode & 2) == 0)) {
    float _301 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _310 = saturate(exp2(log2(((_301 * 18.8515625f) + 0.8359375f) / ((_301 * 18.6875f) + 1.0f)) * 78.84375f));
    float _316 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _326 = _310 - saturate(exp2(log2(((_316 * 18.8515625f) + 0.8359375f) / ((_316 * 18.6875f) + 1.0f)) * 78.84375f));
    float _330 = saturate(_288 / _310);
    float _331 = saturate(_289 / _310);
    float _332 = saturate(_290 / _310);
    _355 = min((((((_330 * -2.0f) + 2.0f) * _326) + (_330 * _310)) * _330), _288);
    _356 = min((((((_331 * -2.0f) + 2.0f) * _326) + (_331 * _310)) * _331), _289);
    _357 = min((((((_332 * -2.0f) + 2.0f) * _326) + (_332 * _310)) * _332), _290);
  } else {
    _355 = _288;
    _356 = _289;
    _357 = _290;
  }
  SV_Target.x = _355;
  SV_Target.y = _356;
  SV_Target.z = _357;
  SV_Target.w = 1.0f;

  // SV_Target = 0;

  return SV_Target;
}

