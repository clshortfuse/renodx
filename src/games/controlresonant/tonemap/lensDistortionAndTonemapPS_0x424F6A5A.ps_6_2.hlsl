#include "./tonemap.hlsli"

StructuredBuffer<float> g_bBrightness : register(t0);

Texture2D<float4> g_tFilmGrain : register(t1);

Texture2D<float4> g_tBaseColorCorrectionMap : register(t2);

Texture2D<float4> g_tSource : register(t3);

cbuffer shared_sys_constants : register(b0) {
  float2 g_vOutputRes : packoffset(c000.x);
  float2 g_vInvOutputRes : packoffset(c000.z);
  float g_fAlphaFadeMinMultiplier : packoffset(c001.x);
  float g_fAlphaFadeStartDistance : packoffset(c001.y);
  float g_fAlphaFadeEndDistance : packoffset(c001.z);
  float g_fAlphaFadeDynamicObjectMinOpacity : packoffset(c001.w);
  float4 g_vAlphaFadeProjectionConstants : packoffset(c002.x);
  float4 g_vProjectionConstants : packoffset(c003.x);
};

cbuffer shared_sys : register(b1) {
  float2 g_vScreenRes : packoffset(c000.x);
  float2 g_vInvScreenRes : packoffset(c000.z);
};

cbuffer shared_hdr_global : register(b2) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

cbuffer shared_hdr : register(b3) {
  float g_fExposureCompensationInEV100 : packoffset(c000.x);
};

cbuffer shared_tonemap_general : register(b4) {
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

cbuffer shared_tonemap_post : register(b5) {
  float g_fPaperWhite : packoffset(c000.x);
  int g_bApplyVignette : packoffset(c000.y);
  int g_bApplyFilmGrain : packoffset(c000.z);
};

cbuffer postprocess : register(b6) {
  float4 g_vPostClearColor : packoffset(c000.x);
  float4 g_vLensDistortionParams : packoffset(c001.x);
  float2 g_vLensDistortionUVScale : packoffset(c002.x);
  float g_fLensDistortionJincSize : packoffset(c002.z);
  float g_fLensDistortionJincLobes : packoffset(c002.w);
  float2 g_vOverriddenAspectRatioUVScale : packoffset(c003.x);
  int g_bPostProcessApplyTonemap : packoffset(c003.z);
  int g_bPostProcessApplyColorGrade : packoffset(c003.w);
  int g_bPostProcessConvertToBackBufferFormat : packoffset(c004.x);
  int g_bDebugLUT : packoffset(c004.y);
  int g_bDebugValidateOutputRange : packoffset(c004.z);
  int g_bDebugReferenceImage : packoffset(c004.w);
  float4 g_vOverlayRect : packoffset(c005.x);
  float g_fWaveformGain : packoffset(c006.x);
  float g_fCieGain : packoffset(c006.y);
};

SamplerState g_sLinearClamp_internal : register(s6, space1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _18;
  float _19;
  float4 _20;
  bool _26;
  bool _28;
  float _37;
  float _57;
  float _58;
  float _59;
  float _97;
  float _98;
  float _99;
  float _185;
  float _186;
  float _187;
  float _589;
  float _590;
  float _591;
  float _615;
  float _616;
  float _617;
  float _703;
  float _714;
  float _725;
  float _767;
  float _778;
  float _789;
  float _802;
  float _803;
  float _804;
  float _809;
  float _810;
  float _811;
  float _820;
  float _821;
  float _822;
  float _920;
  float _921;
  float _922;
  float _956;
  float _957;
  float _958;
  float _974;
  float _975;
  float _976;
  float _61;
  float _65;
  float _66;
  float _67;
  float _68;
  float _77;
  float _78;
  float _92;
  bool _102;
  float _118;
  float _119;
  float _120;
  float _148;
  float _150;
  float _151;
  float _152;
  float _154;
  float4 _156;
  float4 _160;
  float _170;
  float _171;
  float _172;
  float _174;
  float _193;
  float _194;
  float _195;
  float _242;
  float _246;
  float _247;
  float _248;
  float _257;
  float _258;
  float _275;
  float _277;
  float _278;
  float _297;
  float _300;
  float _303;
  float _321;
  float _342;
  float _345;
  float _363;
  float _384;
  float _403;
  float _404;
  float _405;
  float _416;
  float _417;
  float _430;
  float _431;
  float _432;
  float _439;
  float _442;
  float _447;
  float _462;
  float _465;
  float _484;
  float _490;
  float _507;
  float _531;
  float _548;
  float _605;
  float _610;
  float _623;
  float _625;
  float _631;
  float _639;
  float _653;
  float _654;
  float _655;
  float _660;
  float _688;
  float _689;
  float _690;
  float _732;
  float _734;
  float _735;
  float _736;
  float _738;
  float4 _740;
  float4 _744;
  float _754;
  float _755;
  float _756;
  float _791;
  float4 _834;
  float _841;
  float _842;
  float _843;
  float _846;
  float _847;
  float _848;
  float _852;
  float _857;
  float _871;
  float _872;
  float _873;
  float _878;
  float _879;
  float _880;
  float _881;
  float _889;
  float _896;
  float _897;
  float _898;
  float _902;
  float _909;
  bool _929;
  float _943;
  float _944;
  float _945;
  _18 = g_vInvOutputRes.x * SV_Position.x;
  _19 = g_vInvOutputRes.y * SV_Position.y;
  _20 = g_tSource.Sample(g_sLinearClamp_internal, float2(_18, _19));
  _26 = (g_bPostProcessApplyTonemap != 0);
  _28 = (g_bPostProcessApplyColorGrade != 0);
  if (!(g_bPostProcessApplyTonemap == 0)) {
    _37 = g_fPaperWhite;
  } else {
    _37 = 1.0f;
  }
  if (_28) {
    _57 = max(_20.x, 0.0f);
    _58 = max(_20.y, 0.0f);
    _59 = max(_20.z, 0.0f);
  } else {
    _57 = _20.x;
    _58 = _20.y;
    _59 = _20.z;
  }
  _61 = g_bBrightness[1];
  _65 = exp2(g_fExposureCompensationInEV100) * _61;
  _66 = _65 * _57;
  _67 = _65 * _58;
  _68 = _65 * _59;
  if (!(g_bApplyVignette == 0)) {
    _77 = ((((g_vOverriddenAspectRatioUVScale.x * _18) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _78 = (((g_vOverriddenAspectRatioUVScale.y * _19) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _92 = saturate(exp2(log2(saturate(1.0f - sqrt((_77 * _77) + (_78 * _78))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _97 = (_92 * _66);
    _98 = (_92 * _67);
    _99 = (_92 * _68);
  } else {
    _97 = _66;
    _98 = _67;
    _99 = _68;
  }
  _102 = (g_bEnableHDRLUT == 0);
  if (!(_102 || (!_28))) {
  #if 1
    float3 graded_color = ApplyVanillaPQLUT(
      float3(_97, _98, _99), g_tBaseColorCorrectionMap, g_sLinearClamp_internal, g_fTonemapSaturation);
    _185 = graded_color.x;
    _186 = graded_color.y;
    _187 = graded_color.z;
  #else
    _118 = exp2(log2(saturate(_97 * 0.00800000037997961f)) * 0.1593017578125f);
    _119 = exp2(log2(saturate(_98 * 0.00800000037997961f)) * 0.1593017578125f);
    _120 = exp2(log2(saturate(_99 * 0.00800000037997961f)) * 0.1593017578125f);
    _148 = (exp2(log2(((_119 * 18.8515625f) + 0.8359375f) / ((_119 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
    _150 = max((exp2(log2(((_120 * 18.8515625f) + 0.8359375f) / ((_120 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
    _151 = floor(_150);
    _152 = _150 - _151;
    _154 = (((exp2(log2(((_118 * 18.8515625f) + 0.8359375f) / ((_118 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _151) * 0.02083333395421505f;
    _156 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_154, _148), 0.0f);
    _160 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_154 + 0.02083333395421505f), _148), 0.0f);
    _170 = ((_160.x - _156.x) * _152) + _156.x;
    _171 = ((_160.y - _156.y) * _152) + _156.y;
    _172 = ((_160.z - _156.z) * _152) + _156.z;
    _174 = dot(float3(_170, _171, _172), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _185 = (lerp(_174, _170, g_fTonemapSaturation));
    _186 = (lerp(_174, _171, g_fTonemapSaturation));
    _187 = (lerp(_174, _172, g_fTonemapSaturation));
  #endif
  } else {
    _185 = _97;
    _186 = _98;
    _187 = _99;
  }
  if (_26) {
    do {
      _809 = _185;
      _810 = _186;
      _811 = _187;
      if (!(g_iTonemapper == 0)) {
        _193 = max(_185, 0.0f);
        _194 = max(_186, 0.0f);
        _195 = max(_187, 0.0f);
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _193, _194, _195, _37,
              g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes);
          _809 = agx_color.x;
          _810 = agx_color.y;
          _811 = agx_color.z;
#else
          _242 = g_fAgxMaxEV - g_fAgxMinEV;
          _246 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _195, mad(g_vAgxInsetRow0.y, _194, (g_vAgxInsetRow0.x * _193))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _242);
          _247 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _195, mad(g_vAgxInsetRow1.y, _194, (g_vAgxInsetRow1.x * _193))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _242);
          _248 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _195, mad(g_vAgxInsetRow2.y, _194, (g_vAgxInsetRow2.x * _193))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _242);
          _257 = (g_fAgxContrastSlope * (_246 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _258 = 1.0f / g_fAgxShoulderPower;
          _275 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _277 = _275 * (0.6060606241226196f - _246);
          _278 = 1.0f / g_fAgxToePower;
          _297 = -0.0f - g_fAgxToePrecalcConstant;
          _300 = select((_246 >= 0.6060606241226196f), ((_257 / exp2(log2((float((int)(((int)(uint)((int)(_257 > 0.0f))) - ((int)(uint)((int)(_257 < 0.0f))))) * exp2(log2(abs(_257)) * g_fAgxShoulderPower)) + 1.0f) * _258)) * g_fAgxShoulderPrecalcConstant), ((_277 / exp2(log2((float((int)(((int)(uint)((int)(_277 > 0.0f))) - ((int)(uint)((int)(_277 < 0.0f))))) * exp2(log2(abs(_277)) * g_fAgxToePower)) + 1.0f) * _278)) * _297)) + 0.4894371032714844f;
          _303 = (g_fAgxContrastSlope * (_247 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _321 = _275 * (0.6060606241226196f - _247);
          _342 = select((_247 >= 0.6060606241226196f), ((_303 / exp2(log2((float((int)(((int)(uint)((int)(_303 > 0.0f))) - ((int)(uint)((int)(_303 < 0.0f))))) * exp2(log2(abs(_303)) * g_fAgxShoulderPower)) + 1.0f) * _258)) * g_fAgxShoulderPrecalcConstant), ((_321 / exp2(log2((exp2(log2(abs(_321)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_321 > 0.0f))) - ((int)(uint)((int)(_321 < 0.0f)))))) + 1.0f) * _278)) * _297)) + 0.4894371032714844f;
          _345 = (g_fAgxContrastSlope * (_248 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _363 = _275 * (0.6060606241226196f - _248);
          _384 = select((_248 >= 0.6060606241226196f), ((_345 / exp2(log2((float((int)(((int)(uint)((int)(_345 > 0.0f))) - ((int)(uint)((int)(_345 < 0.0f))))) * exp2(log2(abs(_345)) * g_fAgxShoulderPower)) + 1.0f) * _258)) * g_fAgxShoulderPrecalcConstant), ((_363 / exp2(log2((exp2(log2(abs(_363)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_363 > 0.0f))) - ((int)(uint)((int)(_363 < 0.0f)))))) + 1.0f) * _278)) * _297)) + 0.4894371032714844f;
          _403 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _384, mad(g_vAgxOutsetRow0.y, _342, (_300 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _404 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _384, mad(g_vAgxOutsetRow1.y, _342, (_300 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _405 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _384, mad(g_vAgxOutsetRow2.y, _342, (_300 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _589 = _403;
            _590 = _404;
            _591 = _405;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_403, max(_404, _405)) >= g_fAgxHDRMidGrey))) {
                _416 = log2(1.0f / g_fAgxHDRMidGrey);
                _417 = _416 + 20.0f;
                _430 = min(max(log2(max(_403, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _416);
                _431 = min(max(log2(max(_404, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _416);
                _432 = min(max(log2(max(_405, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _416);
                _439 = 20.0f / _417;
                _442 = (20.0f - log2(g_fAgxHDRRatio)) / _417;
                _447 = ((_430 / _417) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _462 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                _465 = ((-0.0f - _430) / _417) * _462;
                _484 = -0.0f - g_fAgxHDRToePrecalcConstant;
                _490 = ((_431 / _417) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _507 = ((-0.0f - _431) / _417) * _462;
                _531 = ((_432 / _417) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _548 = ((-0.0f - _432) / _417) * _462;
                _589 = (saturate(exp2(((select((((_430 + 20.0f) / _417) >= _439), ((_447 / exp2(log2((float((int)(((int)(uint)((int)(_447 > 0.0f))) - ((int)(uint)((int)(_447 < 0.0f))))) * exp2(log2(abs(_447)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_465 / exp2(log2((float((int)(((int)(uint)((int)(_465 > 0.0f))) - ((int)(uint)((int)(_465 < 0.0f))))) * exp2(log2(abs(_465)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _484)) + _442) * _417) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _590 = (saturate(exp2(((select((((_431 + 20.0f) / _417) >= _439), ((_490 / exp2(log2((float((int)(((int)(uint)((int)(_490 > 0.0f))) - ((int)(uint)((int)(_490 < 0.0f))))) * exp2(log2(abs(_490)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_507 / exp2(log2((float((int)(((int)(uint)((int)(_507 > 0.0f))) - ((int)(uint)((int)(_507 < 0.0f))))) * exp2(log2(abs(_507)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _484)) + _442) * _417) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _591 = (saturate(exp2(((select((((_432 + 20.0f) / _417) >= _439), ((_531 / exp2(log2((float((int)(((int)(uint)((int)(_531 > 0.0f))) - ((int)(uint)((int)(_531 < 0.0f))))) * exp2(log2(abs(_531)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_548 / exp2(log2((float((int)(((int)(uint)((int)(_548 > 0.0f))) - ((int)(uint)((int)(_548 < 0.0f))))) * exp2(log2(abs(_548)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _484)) + _442) * _417) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _589 = _403;
                _590 = _404;
                _591 = _405;
              }
            }
            _809 = (mad(-0.07283977419137955f, _591, mad(-0.5876564383506775f, _590, (_589 * 1.6604962348937988f))) * _37);
            _810 = (mad(-0.008348013274371624f, _591, mad(1.1328951120376587f, _590, (_589 * -0.1245470941066742f))) * _37);
            _811 = (mad(1.118751049041748f, _591, mad(-0.10059737414121628f, _590, (_589 * -0.018153680488467216f))) * _37);
          } while (false);
#endif
        } else {
          _605 = dot(float3(_193, _194, _195), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
          do {
            _615 = _193;
            _616 = _194;
            _617 = _195;
            if (!(_605 == 0.0f)) {
              _610 = max(dot(float3(_185, _186, _187), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _605;
              _615 = (_610 * _193);
              _616 = (_610 * _194);
              _617 = (_610 * _195);
            }
            _623 = max(max(_615, max(_616, _617)), 0.0f);
            _625 = 1.0f / max(_623, 1.1754943508222875e-38f);
            _631 = (pow(_623, g_vTonemapGTParams.x));
            _639 = _631 / (((pow(_631, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
            _653 = exp2(log2(_625 * _615) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
            _654 = exp2(log2(_625 * _616) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
            _655 = exp2(log2(_625 * _617) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
            _660 = log2(_639);
            _688 = saturate(exp2(log2((exp2(_660 * g_vTonemapCrosstalk.x) * (1.0f - _653)) + _653) * g_vTonemapCrosstalkSaturation.x) * _639);
            _689 = saturate(exp2(log2((exp2(_660 * g_vTonemapCrosstalk.y) * (1.0f - _654)) + _654) * g_vTonemapCrosstalkSaturation.y) * _639);
            _690 = saturate(exp2(log2((exp2(_660 * g_vTonemapCrosstalk.z) * (1.0f - _655)) + _655) * g_vTonemapCrosstalkSaturation.z) * _639);
            if (_102) {
              do {
                _802 = _688;
                _803 = _689;
                _804 = _690;
                if (_28) {
                  do {
                    [branch]
                    if (!(_688 <= 0.0031308000907301903f)) {
                      _703 = (((pow(_688, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _703 = (_688 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_689 <= 0.0031308000907301903f)) {
                        _714 = (((pow(_689, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _714 = (_689 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_690 <= 0.0031308000907301903f)) {
                          _725 = (((pow(_690, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _725 = (_690 * 12.920000076293945f);
                        }
                        _732 = (saturate(_714) * 0.96875f) + 0.015625f;
                        _734 = max((saturate(_725) * 31.0f), 0.0f);
                        _735 = floor(_734);
                        _736 = _734 - _735;
                        _738 = (((saturate(_703) * 0.96875f) + 0.015625f) + _735) * 0.03125f;
                        _740 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_738, _732), 0.0f);
                        _744 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_738 + 0.03125f), _732), 0.0f);
                        _754 = ((_744.x - _740.x) * _736) + _740.x;
                        _755 = ((_744.y - _740.y) * _736) + _740.y;
                        _756 = ((_744.z - _740.z) * _736) + _740.z;
                        do {
                          [branch]
                          if (!(_754 <= 0.040449999272823334f)) {
                            _767 = exp2(log2((_754 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _767 = (_754 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_755 <= 0.040449999272823334f)) {
                              _778 = exp2(log2((_755 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _778 = (_755 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_756 <= 0.040449999272823334f)) {
                                _789 = exp2(log2((_756 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _789 = (_756 * 0.07739938050508499f);
                              }
                              _791 = dot(float3(_767, _778, _789), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _802 = (lerp(_791, _767, g_fTonemapSaturation));
                              _803 = (lerp(_791, _778, g_fTonemapSaturation));
                              _804 = (lerp(_791, _789, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _809 = (_802 * _37);
                _810 = (_803 * _37);
                _811 = (_804 * _37);
              } while (false);
            } else {
              _809 = _688;
              _810 = _689;
              _811 = _690;
            }
          } while (false);
        }
      }
      _820 = (_809 * g_fTonemapBrightness);
      _821 = (_810 * g_fTonemapBrightness);
      _822 = (_811 * g_fTonemapBrightness);
    } while (false);
  } else {
    _820 = (_185 * _37);
    _821 = (_186 * _37);
    _822 = (_187 * _37);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _834 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _841 = (_834.x * 2.0f) + -1.0f;
    _842 = (_834.y * 2.0f) + -1.0f;
    _843 = (_834.z * 2.0f) + -1.0f;
    if (!(_26)) {
      _846 = _820 / _37;
      _847 = _821 / _37;
      _848 = _822 / _37;
      _852 = 1.0f - sqrt(max(dot(float3(_846, _847, _848), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
      _857 = g_fFilmGrainIntensity * (_37 * 5.0f);
      _920 = ((((_857 * _841) * saturate(_846)) * _852) + _820);
      _921 = ((((_857 * _842) * _852) * saturate(_847)) + _821);
      _922 = ((((_857 * _843) * _852) * saturate(_848)) + _822);
    } else {
      _871 = saturate(_820);
      _872 = saturate(_821);
      _873 = saturate(_822);
      _878 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_871, max(_872, _873))));
      _879 = _878 * _871;
      _880 = _878 * _872;
      _881 = _878 * _873;
      _889 = ((1.0f - sqrt(dot(float3(_879, _880, _881), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
      _896 = ((_889 * _841) * min(1.0f, _879)) + _879;
      _897 = ((_889 * _842) * min(1.0f, _880)) + _880;
      _898 = ((_889 * _843) * min(1.0f, _881)) + _881;
      _902 = 1.0f / (max(_896, max(_897, _898)) + 1.0f);
      _909 = 1.0f / (max(_879, max(_880, _881)) + 1.0f);
      _920 = (((_896 * _902) + _820) - (_909 * _879));
      _921 = (((_897 * _902) + _821) - (_909 * _880));
      _922 = (((_898 * _902) + _822) - (_909 * _881));
    }
  } else {
    _920 = _820;
    _921 = _821;
    _922 = _822;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _929 = (g_bHDR == 0);
    do {
      _956 = _920;
      _957 = _921;
      _958 = _922;
      if (!(_929 || (g_bHDR_scRGB == 0))) {
        _943 = max(mad(0.043306104838848114f, _922, mad(0.329291969537735f, _921, (_920 * 0.6274019479751587f))), 0.0f);
        _944 = max(mad(0.0113602289929986f, _922, mad(0.9195442795753479f, _921, (_920 * 0.06909549236297607f))), 0.0f);
        _945 = max(mad(0.895578145980835f, _922, mad(0.08802816271781921f, _921, (_920 * 0.016393709927797318f))), 0.0f);
        _956 = mad(-0.07283977419137955f, _945, mad(-0.5876564383506775f, _944, (_943 * 1.6604962348937988f)));
        _957 = mad(-0.008348013274371624f, _945, mad(1.1328951120376587f, _944, (_943 * -0.1245470941066742f)));
        _958 = mad(1.118751049041748f, _945, mad(-0.10059737414121628f, _944, (_943 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_929)) {
        _974 = mad(0.043306104838848114f, _958, mad(0.329291969537735f, _957, (_956 * 0.6274019479751587f)));
        _975 = mad(0.0113602289929986f, _958, mad(0.9195442795753479f, _957, (_956 * 0.06909549236297607f)));
        _976 = mad(0.895578145980835f, _958, mad(0.08802816271781921f, _957, (_956 * 0.016393709927797318f)));
      } else {
        _974 = _956;
        _975 = _957;
        _976 = _958;
      }
    } while (false);
  } else {
    _974 = _920;
    _975 = _921;
    _976 = _922;
  }
  SV_Target.x = _974;
  SV_Target.y = _975;
  SV_Target.z = _976;
  SV_Target.w = 1.0f;
  return SV_Target;
}