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
  float _29;
  float _30;
  float _60;
  float _61;
  float _85;
  float _105;
  float _106;
  float _107;
  float _145;
  float _146;
  float _147;
  float _233;
  float _234;
  float _235;
  float _637;
  float _638;
  float _639;
  float _663;
  float _664;
  float _665;
  float _751;
  float _762;
  float _773;
  float _815;
  float _826;
  float _837;
  float _850;
  float _851;
  float _852;
  float _857;
  float _858;
  float _859;
  float _868;
  float _869;
  float _870;
  float _968;
  float _969;
  float _970;
  float _1004;
  float _1005;
  float _1006;
  float _1022;
  float _1023;
  float _1024;
  float _41;
  float _45;
  float _46;
  float _50;
  float _54;
  float4 _68;
  bool _74;
  bool _76;
  float _109;
  float _113;
  float _114;
  float _115;
  float _116;
  float _125;
  float _126;
  float _140;
  bool _150;
  float _166;
  float _167;
  float _168;
  float _196;
  float _198;
  float _199;
  float _200;
  float _202;
  float4 _204;
  float4 _208;
  float _218;
  float _219;
  float _220;
  float _222;
  float _241;
  float _242;
  float _243;
  float _290;
  float _294;
  float _295;
  float _296;
  float _305;
  float _306;
  float _323;
  float _325;
  float _326;
  float _345;
  float _348;
  float _351;
  float _369;
  float _390;
  float _393;
  float _411;
  float _432;
  float _451;
  float _452;
  float _453;
  float _464;
  float _465;
  float _478;
  float _479;
  float _480;
  float _487;
  float _490;
  float _495;
  float _510;
  float _513;
  float _532;
  float _538;
  float _555;
  float _579;
  float _596;
  float _653;
  float _658;
  float _671;
  float _673;
  float _679;
  float _687;
  float _701;
  float _702;
  float _703;
  float _708;
  float _736;
  float _737;
  float _738;
  float _780;
  float _782;
  float _783;
  float _784;
  float _786;
  float4 _788;
  float4 _792;
  float _802;
  float _803;
  float _804;
  float _839;
  float4 _882;
  float _889;
  float _890;
  float _891;
  float _894;
  float _895;
  float _896;
  float _900;
  float _905;
  float _919;
  float _920;
  float _921;
  float _926;
  float _927;
  float _928;
  float _929;
  float _937;
  float _944;
  float _945;
  float _946;
  float _950;
  float _957;
  bool _977;
  float _991;
  float _992;
  float _993;
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
  _74 = (g_bPostProcessApplyTonemap != 0);
  _76 = (g_bPostProcessApplyColorGrade != 0);
  if (!(g_bPostProcessApplyTonemap == 0)) {
    _85 = g_fPaperWhite;
  } else {
    _85 = 1.0f;
  }
  if (_76) {
    _105 = max(_68.x, 0.0f);
    _106 = max(_68.y, 0.0f);
    _107 = max(_68.z, 0.0f);
  } else {
    _105 = _68.x;
    _106 = _68.y;
    _107 = _68.z;
  }
  _109 = g_bBrightness[1];
  _113 = exp2(g_fExposureCompensationInEV100) * _109;
  _114 = _113 * _105;
  _115 = _113 * _106;
  _116 = _113 * _107;
  if (!(g_bApplyVignette == 0)) {
    _125 = ((((g_vOverriddenAspectRatioUVScale.x * _18) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _126 = (((g_vOverriddenAspectRatioUVScale.y * _19) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _140 = saturate(exp2(log2(saturate(1.0f - sqrt((_125 * _125) + (_126 * _126))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _145 = (_140 * _114);
    _146 = (_140 * _115);
    _147 = (_140 * _116);
  } else {
    _145 = _114;
    _146 = _115;
    _147 = _116;
  }
  _150 = (g_bEnableHDRLUT == 0);
  if (!(_150 || (!_76))) {
  #if 1
    float3 graded_color = ApplyVanillaPQLUT(
      float3(_145, _146, _147), g_tBaseColorCorrectionMap, g_sLinearClamp_internal, g_fTonemapSaturation);
    _233 = graded_color.x;
    _234 = graded_color.y;
    _235 = graded_color.z;
  #else
    _166 = exp2(log2(saturate(_145 * 0.00800000037997961f)) * 0.1593017578125f);
    _167 = exp2(log2(saturate(_146 * 0.00800000037997961f)) * 0.1593017578125f);
    _168 = exp2(log2(saturate(_147 * 0.00800000037997961f)) * 0.1593017578125f);
    _196 = (exp2(log2(((_167 * 18.8515625f) + 0.8359375f) / ((_167 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
    _198 = max((exp2(log2(((_168 * 18.8515625f) + 0.8359375f) / ((_168 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
    _199 = floor(_198);
    _200 = _198 - _199;
    _202 = (((exp2(log2(((_166 * 18.8515625f) + 0.8359375f) / ((_166 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _199) * 0.02083333395421505f;
    _204 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_202, _196), 0.0f);
    _208 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_202 + 0.02083333395421505f), _196), 0.0f);
    _218 = ((_208.x - _204.x) * _200) + _204.x;
    _219 = ((_208.y - _204.y) * _200) + _204.y;
    _220 = ((_208.z - _204.z) * _200) + _204.z;
    _222 = dot(float3(_218, _219, _220), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _233 = (lerp(_222, _218, g_fTonemapSaturation));
    _234 = (lerp(_222, _219, g_fTonemapSaturation));
    _235 = (lerp(_222, _220, g_fTonemapSaturation));
  #endif
  } else {
    _233 = _145;
    _234 = _146;
    _235 = _147;
  }
  if (_74) {
    do {
      _857 = _233;
      _858 = _234;
      _859 = _235;
      if (!(g_iTonemapper == 0)) {
        _241 = max(_233, 0.0f);
        _242 = max(_234, 0.0f);
        _243 = max(_235, 0.0f);
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _241, _242, _243, _85,
              g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes);
          _857 = agx_color.x;
          _858 = agx_color.y;
          _859 = agx_color.z;
#else
          _290 = g_fAgxMaxEV - g_fAgxMinEV;
          _294 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _243, mad(g_vAgxInsetRow0.y, _242, (g_vAgxInsetRow0.x * _241))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _290);
          _295 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _243, mad(g_vAgxInsetRow1.y, _242, (g_vAgxInsetRow1.x * _241))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _290);
          _296 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _243, mad(g_vAgxInsetRow2.y, _242, (g_vAgxInsetRow2.x * _241))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _290);
          _305 = (g_fAgxContrastSlope * (_294 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _306 = 1.0f / g_fAgxShoulderPower;
          _323 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _325 = _323 * (0.6060606241226196f - _294);
          _326 = 1.0f / g_fAgxToePower;
          _345 = -0.0f - g_fAgxToePrecalcConstant;
          _348 = select((_294 >= 0.6060606241226196f), ((_305 / exp2(log2((float((int)(((int)(uint)((int)(_305 > 0.0f))) - ((int)(uint)((int)(_305 < 0.0f))))) * exp2(log2(abs(_305)) * g_fAgxShoulderPower)) + 1.0f) * _306)) * g_fAgxShoulderPrecalcConstant), ((_325 / exp2(log2((float((int)(((int)(uint)((int)(_325 > 0.0f))) - ((int)(uint)((int)(_325 < 0.0f))))) * exp2(log2(abs(_325)) * g_fAgxToePower)) + 1.0f) * _326)) * _345)) + 0.4894371032714844f;
          _351 = (g_fAgxContrastSlope * (_295 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _369 = _323 * (0.6060606241226196f - _295);
          _390 = select((_295 >= 0.6060606241226196f), ((_351 / exp2(log2((float((int)(((int)(uint)((int)(_351 > 0.0f))) - ((int)(uint)((int)(_351 < 0.0f))))) * exp2(log2(abs(_351)) * g_fAgxShoulderPower)) + 1.0f) * _306)) * g_fAgxShoulderPrecalcConstant), ((_369 / exp2(log2((exp2(log2(abs(_369)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_369 > 0.0f))) - ((int)(uint)((int)(_369 < 0.0f)))))) + 1.0f) * _326)) * _345)) + 0.4894371032714844f;
          _393 = (g_fAgxContrastSlope * (_296 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _411 = _323 * (0.6060606241226196f - _296);
          _432 = select((_296 >= 0.6060606241226196f), ((_393 / exp2(log2((float((int)(((int)(uint)((int)(_393 > 0.0f))) - ((int)(uint)((int)(_393 < 0.0f))))) * exp2(log2(abs(_393)) * g_fAgxShoulderPower)) + 1.0f) * _306)) * g_fAgxShoulderPrecalcConstant), ((_411 / exp2(log2((exp2(log2(abs(_411)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_411 > 0.0f))) - ((int)(uint)((int)(_411 < 0.0f)))))) + 1.0f) * _326)) * _345)) + 0.4894371032714844f;
          _451 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _432, mad(g_vAgxOutsetRow0.y, _390, (_348 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _452 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _432, mad(g_vAgxOutsetRow1.y, _390, (_348 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _453 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _432, mad(g_vAgxOutsetRow2.y, _390, (_348 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _637 = _451;
            _638 = _452;
            _639 = _453;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_451, max(_452, _453)) >= g_fAgxHDRMidGrey))) {
                _464 = log2(1.0f / g_fAgxHDRMidGrey);
                _465 = _464 + 20.0f;
                _478 = min(max(log2(max(_451, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _464);
                _479 = min(max(log2(max(_452, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _464);
                _480 = min(max(log2(max(_453, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _464);
                _487 = 20.0f / _465;
                _490 = (20.0f - log2(g_fAgxHDRRatio)) / _465;
                _495 = ((_478 / _465) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _510 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                _513 = ((-0.0f - _478) / _465) * _510;
                _532 = -0.0f - g_fAgxHDRToePrecalcConstant;
                _538 = ((_479 / _465) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _555 = ((-0.0f - _479) / _465) * _510;
                _579 = ((_480 / _465) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _596 = ((-0.0f - _480) / _465) * _510;
                _637 = (saturate(exp2(((select((((_478 + 20.0f) / _465) >= _487), ((_495 / exp2(log2((float((int)(((int)(uint)((int)(_495 > 0.0f))) - ((int)(uint)((int)(_495 < 0.0f))))) * exp2(log2(abs(_495)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_513 / exp2(log2((float((int)(((int)(uint)((int)(_513 > 0.0f))) - ((int)(uint)((int)(_513 < 0.0f))))) * exp2(log2(abs(_513)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _532)) + _490) * _465) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _638 = (saturate(exp2(((select((((_479 + 20.0f) / _465) >= _487), ((_538 / exp2(log2((float((int)(((int)(uint)((int)(_538 > 0.0f))) - ((int)(uint)((int)(_538 < 0.0f))))) * exp2(log2(abs(_538)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_555 / exp2(log2((float((int)(((int)(uint)((int)(_555 > 0.0f))) - ((int)(uint)((int)(_555 < 0.0f))))) * exp2(log2(abs(_555)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _532)) + _490) * _465) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _639 = (saturate(exp2(((select((((_480 + 20.0f) / _465) >= _487), ((_579 / exp2(log2((float((int)(((int)(uint)((int)(_579 > 0.0f))) - ((int)(uint)((int)(_579 < 0.0f))))) * exp2(log2(abs(_579)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_596 / exp2(log2((float((int)(((int)(uint)((int)(_596 > 0.0f))) - ((int)(uint)((int)(_596 < 0.0f))))) * exp2(log2(abs(_596)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _532)) + _490) * _465) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _637 = _451;
                _638 = _452;
                _639 = _453;
              }
            }
            _857 = (mad(-0.07283977419137955f, _639, mad(-0.5876564383506775f, _638, (_637 * 1.6604962348937988f))) * _85);
            _858 = (mad(-0.008348013274371624f, _639, mad(1.1328951120376587f, _638, (_637 * -0.1245470941066742f))) * _85);
            _859 = (mad(1.118751049041748f, _639, mad(-0.10059737414121628f, _638, (_637 * -0.018153680488467216f))) * _85);
          } while (false);
#endif
        } else {
          _653 = dot(float3(_241, _242, _243), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
          do {
            _663 = _241;
            _664 = _242;
            _665 = _243;
            if (!(_653 == 0.0f)) {
              _658 = max(dot(float3(_233, _234, _235), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _653;
              _663 = (_658 * _241);
              _664 = (_658 * _242);
              _665 = (_658 * _243);
            }
            _671 = max(max(_663, max(_664, _665)), 0.0f);
            _673 = 1.0f / max(_671, 1.1754943508222875e-38f);
            _679 = (pow(_671, g_vTonemapGTParams.x));
            _687 = _679 / (((pow(_679, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
            _701 = exp2(log2(_673 * _663) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
            _702 = exp2(log2(_673 * _664) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
            _703 = exp2(log2(_673 * _665) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
            _708 = log2(_687);
            _736 = saturate(exp2(log2((exp2(_708 * g_vTonemapCrosstalk.x) * (1.0f - _701)) + _701) * g_vTonemapCrosstalkSaturation.x) * _687);
            _737 = saturate(exp2(log2((exp2(_708 * g_vTonemapCrosstalk.y) * (1.0f - _702)) + _702) * g_vTonemapCrosstalkSaturation.y) * _687);
            _738 = saturate(exp2(log2((exp2(_708 * g_vTonemapCrosstalk.z) * (1.0f - _703)) + _703) * g_vTonemapCrosstalkSaturation.z) * _687);
            if (_150) {
              do {
                _850 = _736;
                _851 = _737;
                _852 = _738;
                if (_76) {
                  do {
                    [branch]
                    if (!(_736 <= 0.0031308000907301903f)) {
                      _751 = (((pow(_736, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _751 = (_736 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_737 <= 0.0031308000907301903f)) {
                        _762 = (((pow(_737, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _762 = (_737 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_738 <= 0.0031308000907301903f)) {
                          _773 = (((pow(_738, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _773 = (_738 * 12.920000076293945f);
                        }
                        _780 = (saturate(_762) * 0.96875f) + 0.015625f;
                        _782 = max((saturate(_773) * 31.0f), 0.0f);
                        _783 = floor(_782);
                        _784 = _782 - _783;
                        _786 = (((saturate(_751) * 0.96875f) + 0.015625f) + _783) * 0.03125f;
                        _788 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_786, _780), 0.0f);
                        _792 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_786 + 0.03125f), _780), 0.0f);
                        _802 = ((_792.x - _788.x) * _784) + _788.x;
                        _803 = ((_792.y - _788.y) * _784) + _788.y;
                        _804 = ((_792.z - _788.z) * _784) + _788.z;
                        do {
                          [branch]
                          if (!(_802 <= 0.040449999272823334f)) {
                            _815 = exp2(log2((_802 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _815 = (_802 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_803 <= 0.040449999272823334f)) {
                              _826 = exp2(log2((_803 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _826 = (_803 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_804 <= 0.040449999272823334f)) {
                                _837 = exp2(log2((_804 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _837 = (_804 * 0.07739938050508499f);
                              }
                              _839 = dot(float3(_815, _826, _837), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _850 = (lerp(_839, _815, g_fTonemapSaturation));
                              _851 = (lerp(_839, _826, g_fTonemapSaturation));
                              _852 = (lerp(_839, _837, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _857 = (_850 * _85);
                _858 = (_851 * _85);
                _859 = (_852 * _85);
              } while (false);
            } else {
              _857 = _736;
              _858 = _737;
              _859 = _738;
            }
          } while (false);
        }
      }
      _868 = (_857 * g_fTonemapBrightness);
      _869 = (_858 * g_fTonemapBrightness);
      _870 = (_859 * g_fTonemapBrightness);
    } while (false);
  } else {
    _868 = (_233 * _85);
    _869 = (_234 * _85);
    _870 = (_235 * _85);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _882 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _889 = (_882.x * 2.0f) + -1.0f;
    _890 = (_882.y * 2.0f) + -1.0f;
    _891 = (_882.z * 2.0f) + -1.0f;
    if (!(_74)) {
      _894 = _868 / _85;
      _895 = _869 / _85;
      _896 = _870 / _85;
      _900 = 1.0f - sqrt(max(dot(float3(_894, _895, _896), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
      _905 = g_fFilmGrainIntensity * (_85 * 5.0f);
      _968 = ((((_905 * _889) * saturate(_894)) * _900) + _868);
      _969 = ((((_905 * _890) * _900) * saturate(_895)) + _869);
      _970 = ((((_905 * _891) * _900) * saturate(_896)) + _870);
    } else {
      _919 = saturate(_868);
      _920 = saturate(_869);
      _921 = saturate(_870);
      _926 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_919, max(_920, _921))));
      _927 = _926 * _919;
      _928 = _926 * _920;
      _929 = _926 * _921;
      _937 = ((1.0f - sqrt(dot(float3(_927, _928, _929), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
      _944 = ((_937 * _889) * min(1.0f, _927)) + _927;
      _945 = ((_937 * _890) * min(1.0f, _928)) + _928;
      _946 = ((_937 * _891) * min(1.0f, _929)) + _929;
      _950 = 1.0f / (max(_944, max(_945, _946)) + 1.0f);
      _957 = 1.0f / (max(_927, max(_928, _929)) + 1.0f);
      _968 = (((_944 * _950) + _868) - (_957 * _927));
      _969 = (((_945 * _950) + _869) - (_957 * _928));
      _970 = (((_946 * _950) + _870) - (_957 * _929));
    }
  } else {
    _968 = _868;
    _969 = _869;
    _970 = _870;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _977 = (g_bHDR == 0);
    do {
      _1004 = _968;
      _1005 = _969;
      _1006 = _970;
      if (!(_977 || (g_bHDR_scRGB == 0))) {
        _991 = max(mad(0.043306104838848114f, _970, mad(0.329291969537735f, _969, (_968 * 0.6274019479751587f))), 0.0f);
        _992 = max(mad(0.0113602289929986f, _970, mad(0.9195442795753479f, _969, (_968 * 0.06909549236297607f))), 0.0f);
        _993 = max(mad(0.895578145980835f, _970, mad(0.08802816271781921f, _969, (_968 * 0.016393709927797318f))), 0.0f);
        _1004 = mad(-0.07283977419137955f, _993, mad(-0.5876564383506775f, _992, (_991 * 1.6604962348937988f)));
        _1005 = mad(-0.008348013274371624f, _993, mad(1.1328951120376587f, _992, (_991 * -0.1245470941066742f)));
        _1006 = mad(1.118751049041748f, _993, mad(-0.10059737414121628f, _992, (_991 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_977)) {
        _1022 = mad(0.043306104838848114f, _1006, mad(0.329291969537735f, _1005, (_1004 * 0.6274019479751587f)));
        _1023 = mad(0.0113602289929986f, _1006, mad(0.9195442795753479f, _1005, (_1004 * 0.06909549236297607f)));
        _1024 = mad(0.895578145980835f, _1006, mad(0.08802816271781921f, _1005, (_1004 * 0.016393709927797318f)));
      } else {
        _1022 = _1004;
        _1023 = _1005;
        _1024 = _1006;
      }
    } while (false);
  } else {
    _1022 = _968;
    _1023 = _969;
    _1024 = _970;
  }
  SV_Target.x = _1022;
  SV_Target.y = _1023;
  SV_Target.z = _1024;
  SV_Target.w = 1.0f;
  return SV_Target;
}