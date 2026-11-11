#include "./tonemap.hlsli"
#include "../UI/UI.hlsli"

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
  float g_fAgxHDRSaturation : packoffset(c014.w);
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
  float _353;
  float _354;
  float _355;
  float _386;
  float _387;
  float _388;
  float _623;
  float _624;
  float _625;
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
  float _248;
  float _267;
  float _268;
  float _269;
  float _270;
  float _274;
  float _279;
  float _296;
  float _318;
  float _324;
  float _373;
  float _374;
  float _375;
  float _376;
  float _381;
  float _394;
  float _396;
  float _402;
  float _410;
  float _424;
  float _425;
  float _426;
  float _431;
  float _459;
  float _460;
  float _461;
  float _473;
  float _478;
  float _480;
  float _481;
  float _482;
  float _483;
  float _493;
  float _497;
  float _546;
  float _547;
  float _548;
  float _553;
  float _566;
  float _567;
  float _568;
  float _600;
  float _602;
  float _604;
  float _605;
  float _618;
  _8 = txBuffer.Sample(samplercoherenttxBuffer, float2(TEXCOORD.x, TEXCOORD.y));
  if (!(g_iTonemapper == 0)) {
    if (g_iTonemapper == 2) {
#if 1
      float3 agx_color = ApplyRemedyAgX(
          _8.x, _8.y, _8.z, ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR),
          g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
          g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
          g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
          g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
          g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
          g_fAgxHDRRatio, g_fAgxHDRMidGrey,
          g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
          TEXCOORD.xy, g_fAgxHDRSaturation);
      _623 = agx_color.x;
      _624 = agx_color.y;
      _625 = agx_color.z;
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
        _353 = _233;
        _354 = _234;
        _355 = _235;
        if (g_fAgxHDRRatio > 1.0f) {
          if (!(!(max(_233, max(_234, _235)) >= g_fAgxHDRMidGrey))) {
            _246 = log2(1.0f / g_fAgxHDRMidGrey);
            _247 = _246 + 20.0f;
            _248 = log2(g_fAgxHDRRatio);
            _267 = (min(max(log2(max(_233, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _246) + 20.0f) / _247;
            _268 = (min(max(log2(max(_234, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _246) + 20.0f) / _247;
            _269 = (min(max(log2(max(_235, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _246) + 20.0f) / _247;
            _270 = 20.0f / _247;
            _274 = max(_267, max(_268, _269));
            _279 = ((_274 - _270) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
            _296 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_270 - _274);
            _318 = select((_274 >= _270), ((_279 / exp2(log2((float((int)(((int)(uint)((int)(_279 > 0.0f))) - ((int)(uint)((int)(_279 < 0.0f))))) * exp2(log2(abs(_279)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_296 / exp2(log2((float((int)(((int)(uint)((int)(_296 > 0.0f))) - ((int)(uint)((int)(_296 < 0.0f))))) * exp2(log2(abs(_296)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _248) / _247);
            _324 = exp2((((_318 - _274) * _247) + _248) * g_fAgxHDRSaturation);
            _353 = (saturate(exp2(((_318 + (_324 * (_267 - _274))) * _247) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
            _354 = (saturate(exp2(((_318 + (_324 * (_268 - _274))) * _247) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
            _355 = (saturate(exp2(((_318 + (_324 * (_269 - _274))) * _247) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
          } else {
            _353 = _233;
            _354 = _234;
            _355 = _235;
          }
        }
        _623 = (mad(-0.07283977419137955f, _355, mad(-0.5876564383506775f, _354, (_353 * 1.6604962348937988f))) * g_fPaperWhite);
        _624 = (mad(-0.008348013274371624f, _355, mad(1.1328951120376587f, _354, (_353 * -0.1245470941066742f))) * g_fPaperWhite);
        _625 = (mad(1.118751049041748f, _355, mad(-0.10059737414121628f, _354, (_353 * -0.018153680488467216f))) * g_fPaperWhite);
      } while (false);
#endif
    } else {
      if ((g_bHDR == 0) || (g_bEnableHDRLUT == 0)) {
        _373 = max(_8.x, 0.0f);
        _374 = max(_8.y, 0.0f);
        _375 = max(_8.z, 0.0f);
        _376 = dot(float3(_373, _374, _375), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        do {
          _386 = _373;
          _387 = _374;
          _388 = _375;
          if (!(_376 == 0.0f)) {
            _381 = max(dot(float3(_8.x, _8.y, _8.z), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _376;
            _386 = (_381 * _373);
            _387 = (_381 * _374);
            _388 = (_381 * _375);
          }
          _394 = max(max(_386, max(_387, _388)), 0.0f);
          _396 = 1.0f / max(_394, 1.1754943508222875e-38f);
          _402 = (pow(_394, g_vTonemapGTParams.x));
          _410 = _402 / (((pow(_402, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
          _424 = exp2(log2(_396 * _386) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
          _425 = exp2(log2(_396 * _387) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
          _426 = exp2(log2(_396 * _388) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
          _431 = log2(_410);
          _459 = saturate(exp2(log2((exp2(_431 * g_vTonemapCrosstalk.x) * (1.0f - _424)) + _424) * g_vTonemapCrosstalkSaturation.x) * _410);
          _460 = saturate(exp2(log2((exp2(_431 * g_vTonemapCrosstalk.y) * (1.0f - _425)) + _425) * g_vTonemapCrosstalkSaturation.y) * _410);
          _461 = saturate(exp2(log2((exp2(_431 * g_vTonemapCrosstalk.z) * (1.0f - _426)) + _426) * g_vTonemapCrosstalkSaturation.z) * _410);
          if (g_bEnableHDRLUT == 0) {
            _623 = (_459 * g_fPaperWhite);
            _624 = (_460 * g_fPaperWhite);
            _625 = (_461 * g_fPaperWhite);
          } else {
            _623 = _459;
            _624 = _460;
            _625 = _461;
          }
        } while (false);
      } else {
        _473 = g_fMaxOutputNits * 0.012500000186264515f;
        _478 = max(abs(_8.x), max(abs(_8.y), abs(_8.z)));
        _480 = 1.0f / max(_478, 1.1754943508222875e-38f);
        _481 = _480 * _8.x;
        _482 = _480 * _8.y;
        _483 = _480 * _8.z;
        _493 = (g_fPaperWhite * 0.18000000715255737f) * exp2(log2((pow(_478, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
        _497 = dot(float3((_493 * _481), (_493 * _482), (_493 * _483)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _546 = exp2(log2(abs(_481)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_481 > 0.0f))) - ((int)(uint)((int)(_481 < 0.0f)))));
        _547 = exp2(log2(abs(_482)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_482 > 0.0f))) - ((int)(uint)((int)(_482 < 0.0f)))));
        _548 = exp2(log2(abs(_483)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_483 > 0.0f))) - ((int)(uint)((int)(_483 < 0.0f)))));
        _553 = log2(saturate(select((_497 <= 0.0f), _497, ((1.0f - exp2(log2(exp2((_497 / _473) * -1.4426950216293335f)))) * _473)) / _473));
        _566 = (exp2(_553 * g_vTonemapCrosstalk.x) * (1.0f - _546)) + _546;
        _567 = (exp2(_553 * g_vTonemapCrosstalk.y) * (1.0f - _547)) + _547;
        _568 = (exp2(_553 * g_vTonemapCrosstalk.z) * (1.0f - _548)) + _548;
        _600 = (float((int)(((int)(uint)((int)(_566 > 0.0f))) - ((int)(uint)((int)(_566 < 0.0f))))) * _493) * exp2(log2(abs(_566)) * g_vTonemapCrosstalkSaturation.x);
        _602 = (float((int)(((int)(uint)((int)(_567 > 0.0f))) - ((int)(uint)((int)(_567 < 0.0f))))) * _493) * exp2(log2(abs(_567)) * g_vTonemapCrosstalkSaturation.y);
        _604 = (float((int)(((int)(uint)((int)(_568 > 0.0f))) - ((int)(uint)((int)(_568 < 0.0f))))) * _493) * exp2(log2(abs(_568)) * g_vTonemapCrosstalkSaturation.z);
        _605 = dot(float3(_600, _602, _604), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _618 = select((_605 <= 0.0f), _605, ((1.0f - exp2(log2(exp2((_605 / _473) * -1.4426950216293335f)))) * _473)) * select((!(_605 == 0.0f)), (1.0f / _605), 0.0f);
        _623 = (_618 * _600);
        _624 = (_618 * _602);
        _625 = (_618 * _604);
      }
    }
  } else {
    _623 = _8.x;
    _624 = _8.y;
    _625 = _8.z;
  }
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  SV_Target.x = (_623 / ui_brightness);
  SV_Target.y = (_624 / ui_brightness);
  SV_Target.z = (_625 / ui_brightness);
  SV_Target.w = _8.w;
  return SV_Target;
}
