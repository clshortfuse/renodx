#include "../tonemap.hlsli"

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
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float _18;
  float _19;
  float _29;
  float _30;
  float _60;
  float _61;
  float _84;
  float _104;
  float _105;
  float _106;
  float _144;
  float _145;
  float _146;
  float _232;
  float _233;
  float _234;
  float _636;
  float _637;
  float _638;
  float _666;
  float _667;
  float _668;
  float _753;
  float _764;
  float _775;
  float _817;
  float _828;
  float _839;
  float _852;
  float _853;
  float _854;
  float _1013;
  float _1014;
  float _1015;
  float _1024;
  float _1025;
  float _1026;
  float _1074;
  float _1075;
  float _1076;
  float _1110;
  float _1111;
  float _1112;
  float _1128;
  float _1129;
  float _1130;
  float _41;
  float _45;
  float _46;
  float _50;
  float _54;
  float4 _68;
  bool _74;
  bool _76;
  float _108;
  float _112;
  float _113;
  float _114;
  float _115;
  float _124;
  float _125;
  float _139;
  bool _149;
  float _165;
  float _166;
  float _167;
  float _195;
  float _197;
  float _198;
  float _199;
  float _201;
  float4 _203;
  float4 _207;
  float _217;
  float _218;
  float _219;
  float _221;
  float _265;
  float _266;
  float _267;
  float _289;
  float _293;
  float _294;
  float _295;
  float _304;
  float _305;
  float _322;
  float _324;
  float _325;
  float _344;
  float _347;
  float _350;
  float _368;
  float _389;
  float _392;
  float _410;
  float _431;
  float _450;
  float _451;
  float _452;
  float _463;
  float _464;
  float _477;
  float _478;
  float _479;
  float _486;
  float _489;
  float _494;
  float _509;
  float _512;
  float _531;
  float _537;
  float _554;
  float _578;
  float _595;
  float _653;
  float _654;
  float _655;
  float _656;
  float _661;
  float _674;
  float _676;
  float _682;
  float _690;
  float _704;
  float _705;
  float _706;
  float _711;
  float _739;
  float _740;
  float _741;
  float _782;
  float _784;
  float _785;
  float _786;
  float _788;
  float4 _790;
  float4 _794;
  float _804;
  float _805;
  float _806;
  float _841;
  float _863;
  float _868;
  float _870;
  float _871;
  float _872;
  float _873;
  float _883;
  float _887;
  float _936;
  float _937;
  float _938;
  float _943;
  float _956;
  float _957;
  float _958;
  float _990;
  float _992;
  float _994;
  float _995;
  float _1008;
  float4 _1038;
  float _1048;
  float _1049;
  float _1050;
  float _1054;
  float _1060;
  bool _1083;
  float _1097;
  float _1098;
  float _1099;
  _18 = g_vInvOutputRes.x * SV_Position.x;
  _19 = g_vInvOutputRes.y * SV_Position.y;
  _29 = ((_18 * 2.0f) + -1.0f) / g_vLensDistortionUVScale.x;
  _30 = ((_19 * 2.0f) + -1.0f) / g_vLensDistortionUVScale.y;
  if (!(!(g_vLensDistortionParams.w >= 0.0f))) {
    _41 = (g_vLensDistortionParams.x - ((_29 * _29) * g_vLensDistortionParams.y)) - ((_30 * _30) * g_vLensDistortionParams.z);
    _60 = (_29 / _41);
    _61 = (_30 / _41);
  } else {
    _45 = _29 * 0.5f;
    _46 = _30 * 0.5f;
    _50 = sqrt((_46 * _46) + (_45 * _45));
    _54 = (((_50 * _50) * g_vLensDistortionParams.w) + 1.0f) * _50;
    _60 = (_54 * (_29 / _50));
    _61 = (_54 * (_30 / _50));
  }
  _68 = g_tSource.Sample(g_sLinearClamp_internal, float2((((_60 * g_vLensDistortionUVScale.x) + 1.0f) * 0.5f), (((_61 * g_vLensDistortionUVScale.y) + 1.0f) * 0.5f)));
  _74 = (g_bPostProcessApplyTonemap == 0);
  _76 = (g_bPostProcessApplyColorGrade != 0);
  if (!(_74)) {
    _84 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  } else {
    _84 = 1.0f;
  }
  if (_76) {
    _104 = max(_68.x, 0.0f);
    _105 = max(_68.y, 0.0f);
    _106 = max(_68.z, 0.0f);
  } else {
    _104 = _68.x;
    _105 = _68.y;
    _106 = _68.z;
  }
  _108 = g_bBrightness[1];
  _112 = exp2(g_fExposureCompensationInEV100) * _108;
  _113 = _112 * _104;
  _114 = _112 * _105;
  _115 = _112 * _106;
  if (!(g_bApplyVignette == 0)) {
    _124 = ((((g_vOverriddenAspectRatioUVScale.x * _18) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _125 = (((g_vOverriddenAspectRatioUVScale.y * _19) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _139 = saturate(exp2(log2(saturate(1.0f - sqrt((_124 * _124) + (_125 * _125))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _144 = (_139 * _113);
    _145 = (_139 * _114);
    _146 = (_139 * _115);
  } else {
    _144 = _113;
    _145 = _114;
    _146 = _115;
  }
  _149 = (g_bEnableHDRLUT == 0);
  if (!(_149 || (!_76))) {
    _165 = exp2(log2(saturate(_144 * 0.00800000037997961f)) * 0.1593017578125f);
    _166 = exp2(log2(saturate(_145 * 0.00800000037997961f)) * 0.1593017578125f);
    _167 = exp2(log2(saturate(_146 * 0.00800000037997961f)) * 0.1593017578125f);
    _195 = (exp2(log2(((_166 * 18.8515625f) + 0.8359375f) / ((_166 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
    _197 = max((exp2(log2(((_167 * 18.8515625f) + 0.8359375f) / ((_167 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
    _198 = floor(_197);
    _199 = _197 - _198;
    _201 = (((exp2(log2(((_165 * 18.8515625f) + 0.8359375f) / ((_165 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _198) * 0.02083333395421505f;
    _203 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_201, _195), 0.0f);
    _207 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_201 + 0.02083333395421505f), _195), 0.0f);
    _217 = ((_207.x - _203.x) * _199) + _203.x;
    _218 = ((_207.y - _203.y) * _199) + _203.y;
    _219 = ((_207.z - _203.z) * _199) + _203.z;
    _221 = dot(float3(_217, _218, _219), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _232 = (lerp(_221, _217, g_fTonemapSaturation));
    _233 = (lerp(_221, _218, g_fTonemapSaturation));
    _234 = (lerp(_221, _219, g_fTonemapSaturation));
  } else {
    _232 = _144;
    _233 = _145;
    _234 = _146;
  }
  if (!(_74)) {
    do {
      _1013 = _232;
      _1014 = _233;
      _1015 = _234;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _232, _233, _234, _84,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes);
          _1013 = agx_color.x;
          _1014 = agx_color.y;
          _1015 = agx_color.z;
#else
          _265 = max(_232, 0.0f);
          _266 = max(_233, 0.0f);
          _267 = max(_234, 0.0f);
          _289 = g_fAgxMaxEV - g_fAgxMinEV;
          _293 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _267, mad(g_vAgxInsetRow0.y, _266, (_265 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _289);
          _294 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _267, mad(g_vAgxInsetRow1.y, _266, (_265 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _289);
          _295 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _267, mad(g_vAgxInsetRow2.y, _266, (_265 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _289);
          _304 = (g_fAgxContrastSlope * (_293 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _305 = 1.0f / g_fAgxShoulderPower;
          _322 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _324 = _322 * (0.6060606241226196f - _293);
          _325 = 1.0f / g_fAgxToePower;
          _344 = -0.0f - g_fAgxToePrecalcConstant;
          _347 = select((_293 >= 0.6060606241226196f), ((_304 / exp2(log2((float((int)(((int)(uint)((int)(_304 > 0.0f))) - ((int)(uint)((int)(_304 < 0.0f))))) * exp2(log2(abs(_304)) * g_fAgxShoulderPower)) + 1.0f) * _305)) * g_fAgxShoulderPrecalcConstant), ((_324 / exp2(log2((float((int)(((int)(uint)((int)(_324 > 0.0f))) - ((int)(uint)((int)(_324 < 0.0f))))) * exp2(log2(abs(_324)) * g_fAgxToePower)) + 1.0f) * _325)) * _344)) + 0.4894371032714844f;
          _350 = (g_fAgxContrastSlope * (_294 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _368 = _322 * (0.6060606241226196f - _294);
          _389 = select((_294 >= 0.6060606241226196f), ((_350 / exp2(log2((float((int)(((int)(uint)((int)(_350 > 0.0f))) - ((int)(uint)((int)(_350 < 0.0f))))) * exp2(log2(abs(_350)) * g_fAgxShoulderPower)) + 1.0f) * _305)) * g_fAgxShoulderPrecalcConstant), ((_368 / exp2(log2((exp2(log2(abs(_368)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_368 > 0.0f))) - ((int)(uint)((int)(_368 < 0.0f)))))) + 1.0f) * _325)) * _344)) + 0.4894371032714844f;
          _392 = (g_fAgxContrastSlope * (_295 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _410 = _322 * (0.6060606241226196f - _295);
          _431 = select((_295 >= 0.6060606241226196f), ((_392 / exp2(log2((float((int)(((int)(uint)((int)(_392 > 0.0f))) - ((int)(uint)((int)(_392 < 0.0f))))) * exp2(log2(abs(_392)) * g_fAgxShoulderPower)) + 1.0f) * _305)) * g_fAgxShoulderPrecalcConstant), ((_410 / exp2(log2((exp2(log2(abs(_410)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_410 > 0.0f))) - ((int)(uint)((int)(_410 < 0.0f)))))) + 1.0f) * _325)) * _344)) + 0.4894371032714844f;
          _450 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _431, mad(g_vAgxOutsetRow0.y, _389, (_347 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _451 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _431, mad(g_vAgxOutsetRow1.y, _389, (_347 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _452 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _431, mad(g_vAgxOutsetRow2.y, _389, (_347 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _636 = _450;
            _637 = _451;
            _638 = _452;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_450, max(_451, _452)) >= g_fAgxHDRMidGrey))) {
                _463 = log2(1.0f / g_fAgxHDRMidGrey);
                _464 = _463 + 20.0f;
                _477 = min(max(log2(max(_450, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _463);
                _478 = min(max(log2(max(_451, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _463);
                _479 = min(max(log2(max(_452, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _463);
                _486 = 20.0f / _464;
                _489 = (20.0f - log2(g_fAgxHDRRatio)) / _464;
                _494 = ((_477 / _464) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _509 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                _512 = ((-0.0f - _477) / _464) * _509;
                _531 = -0.0f - g_fAgxHDRToePrecalcConstant;
                _537 = ((_478 / _464) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _554 = ((-0.0f - _478) / _464) * _509;
                _578 = ((_479 / _464) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _595 = ((-0.0f - _479) / _464) * _509;
                _636 = (saturate(exp2(((select((((_477 + 20.0f) / _464) >= _486), ((_494 / exp2(log2((float((int)(((int)(uint)((int)(_494 > 0.0f))) - ((int)(uint)((int)(_494 < 0.0f))))) * exp2(log2(abs(_494)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_512 / exp2(log2((float((int)(((int)(uint)((int)(_512 > 0.0f))) - ((int)(uint)((int)(_512 < 0.0f))))) * exp2(log2(abs(_512)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _531)) + _489) * _464) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _637 = (saturate(exp2(((select((((_478 + 20.0f) / _464) >= _486), ((_537 / exp2(log2((float((int)(((int)(uint)((int)(_537 > 0.0f))) - ((int)(uint)((int)(_537 < 0.0f))))) * exp2(log2(abs(_537)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_554 / exp2(log2((float((int)(((int)(uint)((int)(_554 > 0.0f))) - ((int)(uint)((int)(_554 < 0.0f))))) * exp2(log2(abs(_554)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _531)) + _489) * _464) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _638 = (saturate(exp2(((select((((_479 + 20.0f) / _464) >= _486), ((_578 / exp2(log2((float((int)(((int)(uint)((int)(_578 > 0.0f))) - ((int)(uint)((int)(_578 < 0.0f))))) * exp2(log2(abs(_578)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_595 / exp2(log2((float((int)(((int)(uint)((int)(_595 > 0.0f))) - ((int)(uint)((int)(_595 < 0.0f))))) * exp2(log2(abs(_595)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _531)) + _489) * _464) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _636 = _450;
                _637 = _451;
                _638 = _452;
              }
            }
            _1013 = (mad(-0.07283977419137955f, _638, mad(-0.5876564383506775f, _637, (_636 * 1.6604962348937988f))) * _84);
            _1014 = (mad(-0.008348013274371624f, _638, mad(1.1328951120376587f, _637, (_636 * -0.1245470941066742f))) * _84);
            _1015 = (mad(1.118751049041748f, _638, mad(-0.10059737414121628f, _637, (_636 * -0.018153680488467216f))) * _84);
          } while (false);
#endif
        } else {
          if (_149) {
            _653 = max(_232, 0.0f);
            _654 = max(_233, 0.0f);
            _655 = max(_234, 0.0f);
            _656 = dot(float3(_653, _654, _655), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            do {
              _666 = _653;
              _667 = _654;
              _668 = _655;
              if (!(_656 == 0.0f)) {
                _661 = max(dot(float3(_232, _233, _234), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _656;
                _666 = (_661 * _653);
                _667 = (_661 * _654);
                _668 = (_661 * _655);
              }
              _674 = max(max(_666, max(_667, _668)), 0.0f);
              _676 = 1.0f / max(_674, 1.1754943508222875e-38f);
              _682 = (pow(_674, g_vTonemapGTParams.x));
              _690 = _682 / (((pow(_682, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
              _704 = exp2(log2(_676 * _666) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
              _705 = exp2(log2(_676 * _667) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
              _706 = exp2(log2(_676 * _668) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
              _711 = log2(_690);
              _739 = saturate(exp2(log2((exp2(_711 * g_vTonemapCrosstalk.x) * (1.0f - _704)) + _704) * g_vTonemapCrosstalkSaturation.x) * _690);
              _740 = saturate(exp2(log2((exp2(_711 * g_vTonemapCrosstalk.y) * (1.0f - _705)) + _705) * g_vTonemapCrosstalkSaturation.y) * _690);
              _741 = saturate(exp2(log2((exp2(_711 * g_vTonemapCrosstalk.z) * (1.0f - _706)) + _706) * g_vTonemapCrosstalkSaturation.z) * _690);
              do {
                _852 = _739;
                _853 = _740;
                _854 = _741;
                if (_76) {
                  do {
                    [branch]
                    if (!(_739 <= 0.0031308000907301903f)) {
                      _753 = (((pow(_739, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _753 = (_739 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_740 <= 0.0031308000907301903f)) {
                        _764 = (((pow(_740, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _764 = (_740 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_741 <= 0.0031308000907301903f)) {
                          _775 = (((pow(_741, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _775 = (_741 * 12.920000076293945f);
                        }
                        _782 = (saturate(_764) * 0.96875f) + 0.015625f;
                        _784 = max((saturate(_775) * 31.0f), 0.0f);
                        _785 = floor(_784);
                        _786 = _784 - _785;
                        _788 = (((saturate(_753) * 0.96875f) + 0.015625f) + _785) * 0.03125f;
                        _790 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_788, _782), 0.0f);
                        _794 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_788 + 0.03125f), _782), 0.0f);
                        _804 = ((_794.x - _790.x) * _786) + _790.x;
                        _805 = ((_794.y - _790.y) * _786) + _790.y;
                        _806 = ((_794.z - _790.z) * _786) + _790.z;
                        do {
                          [branch]
                          if (!(_804 <= 0.040449999272823334f)) {
                            _817 = exp2(log2((_804 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _817 = (_804 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_805 <= 0.040449999272823334f)) {
                              _828 = exp2(log2((_805 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _828 = (_805 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_806 <= 0.040449999272823334f)) {
                                _839 = exp2(log2((_806 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _839 = (_806 * 0.07739938050508499f);
                              }
                              _841 = dot(float3(_817, _828, _839), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _852 = (lerp(_841, _817, g_fTonemapSaturation));
                              _853 = (lerp(_841, _828, g_fTonemapSaturation));
                              _854 = (lerp(_841, _839, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1013 = (_852 * _84);
                _1014 = (_853 * _84);
                _1015 = (_854 * _84);
              } while (false);
            } while (false);
          } else {
            _863 = g_fMaxOutputNits * 0.012500000186264515f;
            _868 = max(abs(_232), max(abs(_233), abs(_234)));
            _870 = 1.0f / max(_868, 1.1754943508222875e-38f);
            _871 = _870 * _232;
            _872 = _870 * _233;
            _873 = _870 * _234;
            _883 = (_84 * 0.18000000715255737f) * exp2(log2((pow(_868, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
            _887 = dot(float3((_883 * _871), (_883 * _872), (_883 * _873)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _936 = exp2(log2(abs(_871)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_871 > 0.0f))) - ((int)(uint)((int)(_871 < 0.0f)))));
            _937 = exp2(log2(abs(_872)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_872 > 0.0f))) - ((int)(uint)((int)(_872 < 0.0f)))));
            _938 = exp2(log2(abs(_873)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_873 > 0.0f))) - ((int)(uint)((int)(_873 < 0.0f)))));
            _943 = log2(saturate(select((_887 <= 0.0f), _887, ((1.0f - exp2(log2(exp2((_887 / _863) * -1.4426950216293335f)))) * _863)) / _863));
            _956 = (exp2(_943 * g_vTonemapCrosstalk.x) * (1.0f - _936)) + _936;
            _957 = (exp2(_943 * g_vTonemapCrosstalk.y) * (1.0f - _937)) + _937;
            _958 = (exp2(_943 * g_vTonemapCrosstalk.z) * (1.0f - _938)) + _938;
            _990 = (float((int)(((int)(uint)((int)(_956 > 0.0f))) - ((int)(uint)((int)(_956 < 0.0f))))) * _883) * exp2(log2(abs(_956)) * g_vTonemapCrosstalkSaturation.x);
            _992 = (float((int)(((int)(uint)((int)(_957 > 0.0f))) - ((int)(uint)((int)(_957 < 0.0f))))) * _883) * exp2(log2(abs(_957)) * g_vTonemapCrosstalkSaturation.y);
            _994 = (float((int)(((int)(uint)((int)(_958 > 0.0f))) - ((int)(uint)((int)(_958 < 0.0f))))) * _883) * exp2(log2(abs(_958)) * g_vTonemapCrosstalkSaturation.z);
            _995 = dot(float3(_990, _992, _994), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1008 = select((_995 <= 0.0f), _995, ((1.0f - exp2(log2(exp2((_995 / _863) * -1.4426950216293335f)))) * _863)) * select((!(_995 == 0.0f)), (1.0f / _995), 0.0f);
            _1013 = (_1008 * _990);
            _1014 = (_1008 * _992);
            _1015 = (_1008 * _994);
          }
        }
      }
      _1024 = (_1013 * g_fTonemapBrightness);
      _1025 = (_1014 * g_fTonemapBrightness);
      _1026 = (_1015 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1024 = (_232 * _84);
    _1025 = (_233 * _84);
    _1026 = (_234 * _84);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1038 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1048 = _1024 / _84;
    _1049 = _1025 / _84;
    _1050 = _1026 / _84;
    _1054 = 1.0f - sqrt(max(dot(float3(_1048, _1049, _1050), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
    _1060 = g_fFilmGrainIntensity * (_84 * 5.0f);
    _1074 = ((((_1060 * ((_1038.x * 2.0f) + -1.0f)) * saturate(_1048)) * _1054) + _1024);
    _1075 = ((((_1060 * ((_1038.y * 2.0f) + -1.0f)) * _1054) * saturate(_1049)) + _1025);
    _1076 = ((((_1060 * ((_1038.z * 2.0f) + -1.0f)) * _1054) * saturate(_1050)) + _1026);
  } else {
    _1074 = _1024;
    _1075 = _1025;
    _1076 = _1026;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1083 = (g_bHDR == 0);
    do {
      _1110 = _1074;
      _1111 = _1075;
      _1112 = _1076;
      if (!(_1083 || (g_bHDR_scRGB == 0))) {
        _1097 = max(mad(0.043306104838848114f, _1076, mad(0.329291969537735f, _1075, (_1074 * 0.6274019479751587f))), 0.0f);
        _1098 = max(mad(0.0113602289929986f, _1076, mad(0.9195442795753479f, _1075, (_1074 * 0.06909549236297607f))), 0.0f);
        _1099 = max(mad(0.895578145980835f, _1076, mad(0.08802816271781921f, _1075, (_1074 * 0.016393709927797318f))), 0.0f);
        _1110 = mad(-0.07283977419137955f, _1099, mad(-0.5876564383506775f, _1098, (_1097 * 1.6604962348937988f)));
        _1111 = mad(-0.008348013274371624f, _1099, mad(1.1328951120376587f, _1098, (_1097 * -0.1245470941066742f)));
        _1112 = mad(1.118751049041748f, _1099, mad(-0.10059737414121628f, _1098, (_1097 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1083)) {
        _1128 = mad(0.043306104838848114f, _1112, mad(0.329291969537735f, _1111, (_1110 * 0.6274019479751587f)));
        _1129 = mad(0.0113602289929986f, _1112, mad(0.9195442795753479f, _1111, (_1110 * 0.06909549236297607f)));
        _1130 = mad(0.895578145980835f, _1112, mad(0.08802816271781921f, _1111, (_1110 * 0.016393709927797318f)));
      } else {
        _1128 = _1110;
        _1129 = _1111;
        _1130 = _1112;
      }
    } while (false);
  } else {
    _1128 = _1074;
    _1129 = _1075;
    _1130 = _1076;
  }
  SV_Target.x = _1128;
  SV_Target.y = _1129;
  SV_Target.z = _1130;
  SV_Target.w = 1.0f;
  return SV_Target;
}
