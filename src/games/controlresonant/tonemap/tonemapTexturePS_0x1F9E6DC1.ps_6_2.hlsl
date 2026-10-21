#include "./tonemap.hlsli"
#include "../composeSceneAndUICS/composeSceneAndUICS.hlsli"

Texture2D<float4> txBuffer : register(t0);

cbuffer shared_hdr_global : register(b0) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

cbuffer shared_tonemap_general : register(b1) {
  float g_fVignetteExp : packoffset(c000.x);
  float g_fTonemapWhitepoint : packoffset(c000.y);
  float3 g_vTonemapCrosstalk : packoffset(c001.x);
  float3 g_vTonemapCrosstalkSaturation : packoffset(c002.x);
  float4 g_vTonemapGTParams : packoffset(c003.x);
  float g_fTonemapSaturation : packoffset(c004.x);
  float g_fTonemapBrightness : packoffset(c004.y);
  float g_fFilmGrainIntensity : packoffset(c004.z);
  int2 g_vFilmGrainOffset : packoffset(c005.x);
  int g_bEnableHDRLUT : packoffset(c005.z);
  int g_iTonemapper : packoffset(c005.w);
  float g_fAgxMinEV : packoffset(c006.x);
  float g_fAgxMaxEV : packoffset(c006.y);
  float g_fAgxToePower : packoffset(c006.z);
  float g_fAgxShoulderPower : packoffset(c006.w);
  float g_fAgxContrastSlope : packoffset(c007.x);
  float g_fAgxToePrecalcConstant : packoffset(c007.y);
  float g_fAgxShoulderPrecalcConstant : packoffset(c007.z);
  float3 g_vAgxInsetRow0 : packoffset(c008.x);
  float3 g_vAgxInsetRow1 : packoffset(c009.x);
  float3 g_vAgxInsetRow2 : packoffset(c010.x);
  float3 g_vAgxOutsetRow0 : packoffset(c011.x);
  float3 g_vAgxOutsetRow1 : packoffset(c012.x);
  float3 g_vAgxOutsetRow2 : packoffset(c013.x);
  float g_fAgxHDRRatio : packoffset(c013.w);
  float g_fAgxHDRMidGrey : packoffset(c014.x);
  float g_fAgxHDRToePrecalcConstant : packoffset(c014.y);
  float g_fAgxHDRShoulderPrecalcConstant : packoffset(c014.z);
};

cbuffer shared_tonemap_post : register(b2) {
  float g_fPaperWhite : packoffset(c000.x);
  int g_bApplyVignette : packoffset(c000.y);
  int g_bApplyFilmGrain : packoffset(c000.z);
};

SamplerState samplercoherenttxBuffer : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float4 _8;
  float _419;
  float _420;
  float _421;
  float _452;
  float _453;
  float _454;
  float _689;
  float _690;
  float _691;
  float _48;
  float _49;
  float _50;
  float _72;
  float _76;
  float _77;
  float _78;
  float _87;
  float _88;
  float _105;
  float _107;
  float _108;
  float _127;
  float _130;
  float _133;
  float _151;
  float _172;
  float _175;
  float _193;
  float _214;
  float _233;
  float _234;
  float _235;
  float _246;
  float _247;
  float _260;
  float _261;
  float _262;
  float _269;
  float _272;
  float _277;
  float _292;
  float _295;
  float _314;
  float _320;
  float _337;
  float _361;
  float _378;
  float _439;
  float _440;
  float _441;
  float _442;
  float _447;
  float _460;
  float _462;
  float _468;
  float _476;
  float _490;
  float _491;
  float _492;
  float _497;
  float _525;
  float _526;
  float _527;
  float _539;
  float _544;
  float _546;
  float _547;
  float _548;
  float _549;
  float _559;
  float _563;
  float _612;
  float _613;
  float _614;
  float _619;
  float _632;
  float _633;
  float _634;
  float _666;
  float _668;
  float _670;
  float _671;
  float _684;
  _8 = txBuffer.Sample(samplercoherenttxBuffer, float2(TEXCOORD.x, TEXCOORD.y));
  if (!(g_iTonemapper == 0)) {
    if (g_iTonemapper == 2) {
#if 1
      float3 agx_color = ApplyRemedyAgX(
          _8.x, _8.y, _8.z, g_fPaperWhite,
          g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
          g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
          g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
          g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
          g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
          g_fAgxHDRRatio, g_fAgxHDRMidGrey,
          g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
          TEXCOORD.xy);
      _689 = agx_color.x;
      _690 = agx_color.y;
      _691 = agx_color.z;
#else
      _48 = max(_8.x, 0.0f);
      _49 = max(_8.y, 0.0f);
      _50 = max(_8.z, 0.0f);
      _72 = g_fAgxMaxEV - g_fAgxMinEV;
      _76 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _50, mad(g_vAgxInsetRow0.y, _49, (_48 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _72);
      _77 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _50, mad(g_vAgxInsetRow1.y, _49, (_48 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _72);
      _78 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _50, mad(g_vAgxInsetRow2.y, _49, (_48 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _72);
      _87 = (g_fAgxContrastSlope * (_76 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
      _88 = 1.0f / g_fAgxShoulderPower;
      _105 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
      _107 = _105 * (0.6060606241226196f - _76);
      _108 = 1.0f / g_fAgxToePower;
      _127 = -0.0f - g_fAgxToePrecalcConstant;
      _130 = select((_76 >= 0.6060606241226196f), ((_87 / exp2(log2((float((int)(((int)(uint)((int)(_87 > 0.0f))) - ((int)(uint)((int)(_87 < 0.0f))))) * exp2(log2(abs(_87)) * g_fAgxShoulderPower)) + 1.0f) * _88)) * g_fAgxShoulderPrecalcConstant), ((_107 / exp2(log2((float((int)(((int)(uint)((int)(_107 > 0.0f))) - ((int)(uint)((int)(_107 < 0.0f))))) * exp2(log2(abs(_107)) * g_fAgxToePower)) + 1.0f) * _108)) * _127)) + 0.4894371032714844f;
      _133 = (g_fAgxContrastSlope * (_77 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
      _151 = _105 * (0.6060606241226196f - _77);
      _172 = select((_77 >= 0.6060606241226196f), ((_133 / exp2(log2((float((int)(((int)(uint)((int)(_133 > 0.0f))) - ((int)(uint)((int)(_133 < 0.0f))))) * exp2(log2(abs(_133)) * g_fAgxShoulderPower)) + 1.0f) * _88)) * g_fAgxShoulderPrecalcConstant), ((_151 / exp2(log2((exp2(log2(abs(_151)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_151 > 0.0f))) - ((int)(uint)((int)(_151 < 0.0f)))))) + 1.0f) * _108)) * _127)) + 0.4894371032714844f;
      _175 = (g_fAgxContrastSlope * (_78 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
      _193 = _105 * (0.6060606241226196f - _78);
      _214 = select((_78 >= 0.6060606241226196f), ((_175 / exp2(log2((float((int)(((int)(uint)((int)(_175 > 0.0f))) - ((int)(uint)((int)(_175 < 0.0f))))) * exp2(log2(abs(_175)) * g_fAgxShoulderPower)) + 1.0f) * _88)) * g_fAgxShoulderPrecalcConstant), ((_193 / exp2(log2((exp2(log2(abs(_193)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_193 > 0.0f))) - ((int)(uint)((int)(_193 < 0.0f)))))) + 1.0f) * _108)) * _127)) + 0.4894371032714844f;
      _233 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _214, mad(g_vAgxOutsetRow0.y, _172, (_130 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
      _234 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _214, mad(g_vAgxOutsetRow1.y, _172, (_130 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
      _235 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _214, mad(g_vAgxOutsetRow2.y, _172, (_130 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
      do {
        _419 = _233;
        _420 = _234;
        _421 = _235;
        if (g_fAgxHDRRatio > 1.0f) {
          if (!(!(max(_233, max(_234, _235)) >= g_fAgxHDRMidGrey))) {
            _246 = log2(1.0f / g_fAgxHDRMidGrey);
            _247 = _246 + 20.0f;
            _260 = min(max(log2(max(_233, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _246);
            _261 = min(max(log2(max(_234, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _246);
            _262 = min(max(log2(max(_235, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _246);
            _269 = 20.0f / _247;
            _272 = (20.0f - log2(g_fAgxHDRRatio)) / _247;
            _277 = ((_260 / _247) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
            _292 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
            _295 = ((-0.0f - _260) / _247) * _292;
            _314 = -0.0f - g_fAgxHDRToePrecalcConstant;
            _320 = ((_261 / _247) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
            _337 = ((-0.0f - _261) / _247) * _292;
            _361 = ((_262 / _247) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
            _378 = ((-0.0f - _262) / _247) * _292;
            _419 = (saturate(exp2(((select((((_260 + 20.0f) / _247) >= _269), ((_277 / exp2(log2((float((int)(((int)(uint)((int)(_277 > 0.0f))) - ((int)(uint)((int)(_277 < 0.0f))))) * exp2(log2(abs(_277)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_295 / exp2(log2((float((int)(((int)(uint)((int)(_295 > 0.0f))) - ((int)(uint)((int)(_295 < 0.0f))))) * exp2(log2(abs(_295)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _314)) + _272) * _247) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
            _420 = (saturate(exp2(((select((((_261 + 20.0f) / _247) >= _269), ((_320 / exp2(log2((float((int)(((int)(uint)((int)(_320 > 0.0f))) - ((int)(uint)((int)(_320 < 0.0f))))) * exp2(log2(abs(_320)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_337 / exp2(log2((float((int)(((int)(uint)((int)(_337 > 0.0f))) - ((int)(uint)((int)(_337 < 0.0f))))) * exp2(log2(abs(_337)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _314)) + _272) * _247) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
            _421 = (saturate(exp2(((select((((_262 + 20.0f) / _247) >= _269), ((_361 / exp2(log2((float((int)(((int)(uint)((int)(_361 > 0.0f))) - ((int)(uint)((int)(_361 < 0.0f))))) * exp2(log2(abs(_361)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_378 / exp2(log2((float((int)(((int)(uint)((int)(_378 > 0.0f))) - ((int)(uint)((int)(_378 < 0.0f))))) * exp2(log2(abs(_378)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _314)) + _272) * _247) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
          } else {
            _419 = _233;
            _420 = _234;
            _421 = _235;
          }
        }
        _689 = (mad(-0.07283977419137955f, _421, mad(-0.5876564383506775f, _420, (_419 * 1.6604962348937988f))) * g_fPaperWhite);
        _690 = (mad(-0.008348013274371624f, _421, mad(1.1328951120376587f, _420, (_419 * -0.1245470941066742f))) * g_fPaperWhite);
        _691 = (mad(1.118751049041748f, _421, mad(-0.10059737414121628f, _420, (_419 * -0.018153680488467216f))) * g_fPaperWhite);
      } while (false);
#endif
    } else {
      if ((g_bHDR == 0) || (g_bEnableHDRLUT == 0)) {
        _439 = max(_8.x, 0.0f);
        _440 = max(_8.y, 0.0f);
        _441 = max(_8.z, 0.0f);
        _442 = dot(float3(_439, _440, _441), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        do {
          _452 = _439;
          _453 = _440;
          _454 = _441;
          if (!(_442 == 0.0f)) {
            _447 = max(dot(float3(_8.x, _8.y, _8.z), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _442;
            _452 = (_447 * _439);
            _453 = (_447 * _440);
            _454 = (_447 * _441);
          }
          _460 = max(max(_452, max(_453, _454)), 0.0f);
          _462 = 1.0f / max(_460, 1.1754943508222875e-38f);
          _468 = (pow(_460, g_vTonemapGTParams.x));
          _476 = _468 / (((pow(_468, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
          _490 = exp2(log2(_462 * _452) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
          _491 = exp2(log2(_462 * _453) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
          _492 = exp2(log2(_462 * _454) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
          _497 = log2(_476);
          _525 = saturate(exp2(log2((exp2(_497 * g_vTonemapCrosstalk.x) * (1.0f - _490)) + _490) * g_vTonemapCrosstalkSaturation.x) * _476);
          _526 = saturate(exp2(log2((exp2(_497 * g_vTonemapCrosstalk.y) * (1.0f - _491)) + _491) * g_vTonemapCrosstalkSaturation.y) * _476);
          _527 = saturate(exp2(log2((exp2(_497 * g_vTonemapCrosstalk.z) * (1.0f - _492)) + _492) * g_vTonemapCrosstalkSaturation.z) * _476);
          if (g_bEnableHDRLUT == 0) {
            _689 = (_525 * g_fPaperWhite);
            _690 = (_526 * g_fPaperWhite);
            _691 = (_527 * g_fPaperWhite);
          } else {
            _689 = _525;
            _690 = _526;
            _691 = _527;
          }
        } while (false);
      } else {
        _539 = g_fMaxOutputNits * 0.012500000186264515f;
        _544 = max(abs(_8.x), max(abs(_8.y), abs(_8.z)));
        _546 = 1.0f / max(_544, 1.1754943508222875e-38f);
        _547 = _546 * _8.x;
        _548 = _546 * _8.y;
        _549 = _546 * _8.z;
        _559 = (g_fPaperWhite * 0.18000000715255737f) * exp2(log2((pow(_544, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
        _563 = dot(float3((_559 * _547), (_559 * _548), (_559 * _549)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _612 = exp2(log2(abs(_547)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_547 > 0.0f))) - ((int)(uint)((int)(_547 < 0.0f)))));
        _613 = exp2(log2(abs(_548)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_548 > 0.0f))) - ((int)(uint)((int)(_548 < 0.0f)))));
        _614 = exp2(log2(abs(_549)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_549 > 0.0f))) - ((int)(uint)((int)(_549 < 0.0f)))));
        _619 = log2(saturate(select((_563 <= 0.0f), _563, ((1.0f - exp2(log2(exp2((_563 / _539) * -1.4426950216293335f)))) * _539)) / _539));
        _632 = (exp2(_619 * g_vTonemapCrosstalk.x) * (1.0f - _612)) + _612;
        _633 = (exp2(_619 * g_vTonemapCrosstalk.y) * (1.0f - _613)) + _613;
        _634 = (exp2(_619 * g_vTonemapCrosstalk.z) * (1.0f - _614)) + _614;
        _666 = (float((int)(((int)(uint)((int)(_632 > 0.0f))) - ((int)(uint)((int)(_632 < 0.0f))))) * _559) * exp2(log2(abs(_632)) * g_vTonemapCrosstalkSaturation.x);
        _668 = (float((int)(((int)(uint)((int)(_633 > 0.0f))) - ((int)(uint)((int)(_633 < 0.0f))))) * _559) * exp2(log2(abs(_633)) * g_vTonemapCrosstalkSaturation.y);
        _670 = (float((int)(((int)(uint)((int)(_634 > 0.0f))) - ((int)(uint)((int)(_634 < 0.0f))))) * _559) * exp2(log2(abs(_634)) * g_vTonemapCrosstalkSaturation.z);
        _671 = dot(float3(_666, _668, _670), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _684 = select((_671 <= 0.0f), _671, ((1.0f - exp2(log2(exp2((_671 / _539) * -1.4426950216293335f)))) * _539)) * select((!(_671 == 0.0f)), (1.0f / _671), 0.0f);
        _689 = (_684 * _666);
        _690 = (_684 * _668);
        _691 = (_684 * _670);
      }
    }
  } else {
    _689 = _8.x;
    _690 = _8.y;
    _691 = _8.z;
  }
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  SV_Target.x = (_689 / ui_brightness);
  SV_Target.y = (_690 / ui_brightness);
  SV_Target.z = (_691 / ui_brightness);
  SV_Target.w = _8.w;

  return SV_Target;
}
