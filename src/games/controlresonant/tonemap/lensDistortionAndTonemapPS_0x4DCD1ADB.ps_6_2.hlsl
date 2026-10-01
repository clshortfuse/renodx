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
  float g_fAgxHDRSaturation : packoffset(c014.w);
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
  float4 _20;
  bool _26;
  bool _28;
  float _36;
  float _56;
  float _57;
  float _58;
  float _96;
  float _97;
  float _98;
  float _318;
  float _319;
  float _320;
  float _656;
  float _657;
  float _658;
  float _686;
  float _687;
  float _688;
  float _773;
  float _784;
  float _795;
  float _837;
  float _848;
  float _859;
  float _872;
  float _873;
  float _874;
  float _1033;
  float _1034;
  float _1035;
  float _1044;
  float _1045;
  float _1046;
  float _1094;
  float _1095;
  float _1096;
  float _1130;
  float _1131;
  float _1132;
  float _1148;
  float _1149;
  float _1150;
  float _60;
  float _64;
  float _65;
  float _66;
  float _67;
  float _76;
  float _77;
  float _91;
  bool _101;
  float _117;
  float _118;
  float _119;
  float _147;
  float _148;
  float _149;
  int _153;
  int _154;
  int _155;
  float _159;
  float _160;
  float _161;
  int _166;
  int _171;
  int _176;
  bool _177;
  bool _178;
  bool _179;
  float4 _197;
  float4 _212;
  float4 _227;
  float4 _242;
  float _249;
  float _256;
  float _260;
  float _261;
  float _265;
  float _269;
  float _278;
  float _281;
  float _284;
  float _286;
  float _288;
  float _290;
  float _294;
  float _295;
  float _296;
  float _299;
  float _302;
  float _305;
  float _307;
  float _351;
  float _352;
  float _353;
  float _375;
  float _379;
  float _380;
  float _381;
  float _390;
  float _391;
  float _408;
  float _410;
  float _411;
  float _430;
  float _433;
  float _436;
  float _454;
  float _475;
  float _478;
  float _496;
  float _517;
  float _536;
  float _537;
  float _538;
  float _549;
  float _550;
  float _551;
  float _570;
  float _571;
  float _572;
  float _573;
  float _577;
  float _582;
  float _599;
  float _621;
  float _627;
  float _673;
  float _674;
  float _675;
  float _676;
  float _681;
  float _694;
  float _696;
  float _702;
  float _710;
  float _724;
  float _725;
  float _726;
  float _731;
  float _759;
  float _760;
  float _761;
  float _802;
  float _804;
  float _805;
  float _806;
  float _808;
  float4 _810;
  float4 _814;
  float _824;
  float _825;
  float _826;
  float _861;
  float _883;
  float _888;
  float _890;
  float _891;
  float _892;
  float _893;
  float _903;
  float _907;
  float _956;
  float _957;
  float _958;
  float _963;
  float _976;
  float _977;
  float _978;
  float _1010;
  float _1012;
  float _1014;
  float _1015;
  float _1028;
  float4 _1058;
  float _1068;
  float _1069;
  float _1070;
  float _1074;
  float _1080;
  bool _1103;
  float _1117;
  float _1118;
  float _1119;
  _18 = g_vInvOutputRes.x * SV_Position.x;
  _19 = g_vInvOutputRes.y * SV_Position.y;
  _20 = g_tSource.Sample(g_sLinearClamp_internal, float2(_18, _19));
  _26 = (g_bPostProcessApplyTonemap == 0);
  _28 = (g_bPostProcessApplyColorGrade != 0);
  if (!(_26)) {
    _36 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  } else {
    _36 = 1.0f;
  }
  if (_28) {
    _56 = max(_20.x, 0.0f);
    _57 = max(_20.y, 0.0f);
    _58 = max(_20.z, 0.0f);
  } else {
    _56 = _20.x;
    _57 = _20.y;
    _58 = _20.z;
  }
  _60 = g_bBrightness[1];
  _64 = exp2(g_fExposureCompensationInEV100) * _60;
  _65 = _64 * _56;
  _66 = _64 * _57;
  _67 = _64 * _58;
  if (!(g_bApplyVignette == 0)) {
    _76 = ((((g_vOverriddenAspectRatioUVScale.x * _18) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _77 = (((g_vOverriddenAspectRatioUVScale.y * _19) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _91 = saturate(exp2(log2(saturate(1.0f - sqrt((_76 * _76) + (_77 * _77))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _96 = (_91 * _65);
    _97 = (_91 * _66);
    _98 = (_91 * _67);
  } else {
    _96 = _65;
    _97 = _66;
    _98 = _67;
  }
  _101 = (g_bEnableHDRLUT == 0);
  if (!(_101 || (!_28))) {
    _117 = exp2(log2(saturate(_96 * 0.00800000037997961f)) * 0.1593017578125f);
    _118 = exp2(log2(saturate(_97 * 0.00800000037997961f)) * 0.1593017578125f);
    _119 = exp2(log2(saturate(_98 * 0.00800000037997961f)) * 0.1593017578125f);
    _147 = saturate(exp2(log2(((_117 * 18.8515625f) + 0.8359375f) / ((_117 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _148 = saturate(exp2(log2(((_118 * 18.8515625f) + 0.8359375f) / ((_118 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _149 = saturate(exp2(log2(((_119 * 18.8515625f) + 0.8359375f) / ((_119 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _153 = int(floor(_147));
    _154 = int(floor(_148));
    _155 = int(floor(_149));
    _159 = _147 - float((int)(_153));
    _160 = _148 - float((int)(_154));
    _161 = _149 - float((int)(_155));
    _166 = ((int)(uint)((int)(_161 > _159))) + ((int)(uint)((int)(_160 > _159)));
    _171 = ((int)(uint)((int)(_161 > _160))) + ((int)(uint)((int)(_159 >= _160)));
    _176 = ((int)(uint)((int)(_159 >= _161))) + ((int)(uint)((int)(_160 >= _161)));
    _177 = (_166 == 0);
    _178 = (_171 == 0);
    _179 = (_176 == 0);
    _197 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_155), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_153), (int)(0))), (int)(47))), min((int)(max((int)(_154), (int)(0))), (int)(47)), 0));
    _212 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_179))) + _155))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_177))) + _153))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_178))) + _154))), (int)(0))), (int)(47)), 0));
    _227 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_176 < (uint)2)))) + _155))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_166 < (uint)2)))) + _153))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_171 < (uint)2)))) + _154))), (int)(0))), (int)(47)), 0));
    _242 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_155 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_153 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_154 + 1u))), (int)(0))), (int)(47)), 0));
    _249 = dot(float3(_159, _160, _161), float3(((float)((bool)_177)), ((float)((bool)_178)), ((float)((bool)_179))));
    _256 = dot(float3(_159, _160, _161), float3(((float)((bool)(uint)(_166 == 2))), ((float)((bool)(uint)(_171 == 2))), ((float)((bool)(uint)(_176 == 2)))));
    _260 = (((_160 + _159) + _161) - _249) - _256;
    _261 = 1.0f - _249;
    _265 = _249 - _260;
    _269 = _260 - _256;
    _278 = (((_256 * _242.x) + (_261 * _197.x)) + (_265 * _212.x)) + (_269 * _227.x);
    _281 = (((_256 * _242.y) + (_261 * _197.y)) + (_265 * _212.y)) + (_269 * _227.y);
    _284 = (((_256 * _242.z) + (_261 * _197.z)) + (_265 * _212.z)) + (_269 * _227.z);
    _286 = mad(0.21580375730991364f, _284, mad(0.3963377773761749f, _281, _278));
    _288 = mad(-0.0638541728258133f, _284, mad(-0.10556134581565857f, _281, _278));
    _290 = mad(-1.2914855480194092f, _284, mad(-0.08948417752981186f, _281, _278));
    _294 = (_286 * _286) * _286;
    _295 = (_288 * _288) * _288;
    _296 = (_290 * _290) * _290;
    _299 = mad(0.23096993565559387f, _296, mad(-3.307711601257324f, _295, (_294 * 4.076741695404053f)));
    _302 = mad(-0.34131938219070435f, _296, mad(2.609757423400879f, _295, (_294 * -1.2684379816055298f)));
    _305 = mad(1.7076146602630615f, _296, mad(-0.7034186124801636f, _295, (_294 * -0.004196086432784796f)));
    _307 = dot(float3(_299, _302, _305), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _318 = (lerp(_307, _299, g_fTonemapSaturation));
    _319 = (lerp(_307, _302, g_fTonemapSaturation));
    _320 = (lerp(_307, _305, g_fTonemapSaturation));
  } else {
    _318 = _96;
    _319 = _97;
    _320 = _98;
  }
  if (!(_26)) {
    do {
      _1033 = _318;
      _1034 = _319;
      _1035 = _320;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _318, _319, _320, _36,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
          _1033 = agx_color.x;
          _1034 = agx_color.y;
          _1035 = agx_color.z;
#else
          _351 = max(_318, 0.0f);
          _352 = max(_319, 0.0f);
          _353 = max(_320, 0.0f);
          _375 = g_fAgxMaxEV - g_fAgxMinEV;
          _379 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _353, mad(g_vAgxInsetRow0.y, _352, (_351 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _375);
          _380 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _353, mad(g_vAgxInsetRow1.y, _352, (_351 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _375);
          _381 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _353, mad(g_vAgxInsetRow2.y, _352, (_351 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _375);
          _390 = (g_fAgxContrastSlope * (_379 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _391 = 1.0f / g_fAgxShoulderPower;
          _408 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _410 = _408 * (0.6060606241226196f - _379);
          _411 = 1.0f / g_fAgxToePower;
          _430 = -0.0f - g_fAgxToePrecalcConstant;
          _433 = select((_379 >= 0.6060606241226196f), ((_390 / exp2(log2((float((int)(((int)(uint)((int)(_390 > 0.0f))) - ((int)(uint)((int)(_390 < 0.0f))))) * exp2(log2(abs(_390)) * g_fAgxShoulderPower)) + 1.0f) * _391)) * g_fAgxShoulderPrecalcConstant), ((_410 / exp2(log2((float((int)(((int)(uint)((int)(_410 > 0.0f))) - ((int)(uint)((int)(_410 < 0.0f))))) * exp2(log2(abs(_410)) * g_fAgxToePower)) + 1.0f) * _411)) * _430)) + 0.4894371032714844f;
          _436 = (g_fAgxContrastSlope * (_380 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _454 = _408 * (0.6060606241226196f - _380);
          _475 = select((_380 >= 0.6060606241226196f), ((_436 / exp2(log2((float((int)(((int)(uint)((int)(_436 > 0.0f))) - ((int)(uint)((int)(_436 < 0.0f))))) * exp2(log2(abs(_436)) * g_fAgxShoulderPower)) + 1.0f) * _391)) * g_fAgxShoulderPrecalcConstant), ((_454 / exp2(log2((exp2(log2(abs(_454)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_454 > 0.0f))) - ((int)(uint)((int)(_454 < 0.0f)))))) + 1.0f) * _411)) * _430)) + 0.4894371032714844f;
          _478 = (g_fAgxContrastSlope * (_381 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _496 = _408 * (0.6060606241226196f - _381);
          _517 = select((_381 >= 0.6060606241226196f), ((_478 / exp2(log2((float((int)(((int)(uint)((int)(_478 > 0.0f))) - ((int)(uint)((int)(_478 < 0.0f))))) * exp2(log2(abs(_478)) * g_fAgxShoulderPower)) + 1.0f) * _391)) * g_fAgxShoulderPrecalcConstant), ((_496 / exp2(log2((exp2(log2(abs(_496)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_496 > 0.0f))) - ((int)(uint)((int)(_496 < 0.0f)))))) + 1.0f) * _411)) * _430)) + 0.4894371032714844f;
          _536 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _517, mad(g_vAgxOutsetRow0.y, _475, (_433 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _537 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _517, mad(g_vAgxOutsetRow1.y, _475, (_433 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _538 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _517, mad(g_vAgxOutsetRow2.y, _475, (_433 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _656 = _536;
            _657 = _537;
            _658 = _538;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_536, max(_537, _538)) >= g_fAgxHDRMidGrey))) {
                _549 = log2(1.0f / g_fAgxHDRMidGrey);
                _550 = _549 + 20.0f;
                _551 = log2(g_fAgxHDRRatio);
                _570 = (min(max(log2(max(_536, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _549) + 20.0f) / _550;
                _571 = (min(max(log2(max(_537, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _549) + 20.0f) / _550;
                _572 = (min(max(log2(max(_538, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _549) + 20.0f) / _550;
                _573 = 20.0f / _550;
                _577 = max(_570, max(_571, _572));
                _582 = ((_577 - _573) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _599 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_573 - _577);
                _621 = select((_577 >= _573), ((_582 / exp2(log2((float((int)(((int)(uint)((int)(_582 > 0.0f))) - ((int)(uint)((int)(_582 < 0.0f))))) * exp2(log2(abs(_582)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_599 / exp2(log2((float((int)(((int)(uint)((int)(_599 > 0.0f))) - ((int)(uint)((int)(_599 < 0.0f))))) * exp2(log2(abs(_599)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _551) / _550);
                _627 = exp2((((_621 - _577) * _550) + _551) * g_fAgxHDRSaturation);
                _656 = (saturate(exp2(((_621 + (_627 * (_570 - _577))) * _550) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _657 = (saturate(exp2(((_621 + (_627 * (_571 - _577))) * _550) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _658 = (saturate(exp2(((_621 + (_627 * (_572 - _577))) * _550) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _656 = _536;
                _657 = _537;
                _658 = _538;
              }
            }
            _1033 = (mad(-0.07283977419137955f, _658, mad(-0.5876564383506775f, _657, (_656 * 1.6604962348937988f))) * _36);
            _1034 = (mad(-0.008348013274371624f, _658, mad(1.1328951120376587f, _657, (_656 * -0.1245470941066742f))) * _36);
            _1035 = (mad(1.118751049041748f, _658, mad(-0.10059737414121628f, _657, (_656 * -0.018153680488467216f))) * _36);
          } while (false);
#endif
        } else {
          if (_101) {
            _673 = max(_318, 0.0f);
            _674 = max(_319, 0.0f);
            _675 = max(_320, 0.0f);
            _676 = dot(float3(_673, _674, _675), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            do {
              _686 = _673;
              _687 = _674;
              _688 = _675;
              if (!(_676 == 0.0f)) {
                _681 = max(dot(float3(_318, _319, _320), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _676;
                _686 = (_681 * _673);
                _687 = (_681 * _674);
                _688 = (_681 * _675);
              }
              _694 = max(max(_686, max(_687, _688)), 0.0f);
              _696 = 1.0f / max(_694, 1.1754943508222875e-38f);
              _702 = (pow(_694, g_vTonemapGTParams.x));
              _710 = _702 / (((pow(_702, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
              _724 = exp2(log2(_696 * _686) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
              _725 = exp2(log2(_696 * _687) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
              _726 = exp2(log2(_696 * _688) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
              _731 = log2(_710);
              _759 = saturate(exp2(log2((exp2(_731 * g_vTonemapCrosstalk.x) * (1.0f - _724)) + _724) * g_vTonemapCrosstalkSaturation.x) * _710);
              _760 = saturate(exp2(log2((exp2(_731 * g_vTonemapCrosstalk.y) * (1.0f - _725)) + _725) * g_vTonemapCrosstalkSaturation.y) * _710);
              _761 = saturate(exp2(log2((exp2(_731 * g_vTonemapCrosstalk.z) * (1.0f - _726)) + _726) * g_vTonemapCrosstalkSaturation.z) * _710);
              do {
                _872 = _759;
                _873 = _760;
                _874 = _761;
                if (_28) {
                  do {
                    [branch]
                    if (!(_759 <= 0.0031308000907301903f)) {
                      _773 = (((pow(_759, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _773 = (_759 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_760 <= 0.0031308000907301903f)) {
                        _784 = (((pow(_760, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _784 = (_760 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_761 <= 0.0031308000907301903f)) {
                          _795 = (((pow(_761, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _795 = (_761 * 12.920000076293945f);
                        }
                        _802 = (saturate(_784) * 0.96875f) + 0.015625f;
                        _804 = max((saturate(_795) * 31.0f), 0.0f);
                        _805 = floor(_804);
                        _806 = _804 - _805;
                        _808 = (((saturate(_773) * 0.96875f) + 0.015625f) + _805) * 0.03125f;
                        _810 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_808, _802), 0.0f);
                        _814 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_808 + 0.03125f), _802), 0.0f);
                        _824 = ((_814.x - _810.x) * _806) + _810.x;
                        _825 = ((_814.y - _810.y) * _806) + _810.y;
                        _826 = ((_814.z - _810.z) * _806) + _810.z;
                        do {
                          [branch]
                          if (!(_824 <= 0.040449999272823334f)) {
                            _837 = exp2(log2((_824 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _837 = (_824 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_825 <= 0.040449999272823334f)) {
                              _848 = exp2(log2((_825 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _848 = (_825 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_826 <= 0.040449999272823334f)) {
                                _859 = exp2(log2((_826 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _859 = (_826 * 0.07739938050508499f);
                              }
                              _861 = dot(float3(_837, _848, _859), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _872 = (lerp(_861, _837, g_fTonemapSaturation));
                              _873 = (lerp(_861, _848, g_fTonemapSaturation));
                              _874 = (lerp(_861, _859, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1033 = (_872 * _36);
                _1034 = (_873 * _36);
                _1035 = (_874 * _36);
              } while (false);
            } while (false);
          } else {
            _883 = g_fMaxOutputNits * 0.012500000186264515f;
            _888 = max(abs(_318), max(abs(_319), abs(_320)));
            _890 = 1.0f / max(_888, 1.1754943508222875e-38f);
            _891 = _890 * _318;
            _892 = _890 * _319;
            _893 = _890 * _320;
            _903 = (_36 * 0.18000000715255737f) * exp2(log2((pow(_888, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
            _907 = dot(float3((_903 * _891), (_903 * _892), (_903 * _893)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _956 = exp2(log2(abs(_891)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_891 > 0.0f))) - ((int)(uint)((int)(_891 < 0.0f)))));
            _957 = exp2(log2(abs(_892)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_892 > 0.0f))) - ((int)(uint)((int)(_892 < 0.0f)))));
            _958 = exp2(log2(abs(_893)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_893 > 0.0f))) - ((int)(uint)((int)(_893 < 0.0f)))));
            _963 = log2(saturate(select((_907 <= 0.0f), _907, ((1.0f - exp2(log2(exp2((_907 / _883) * -1.4426950216293335f)))) * _883)) / _883));
            _976 = (exp2(_963 * g_vTonemapCrosstalk.x) * (1.0f - _956)) + _956;
            _977 = (exp2(_963 * g_vTonemapCrosstalk.y) * (1.0f - _957)) + _957;
            _978 = (exp2(_963 * g_vTonemapCrosstalk.z) * (1.0f - _958)) + _958;
            _1010 = (float((int)(((int)(uint)((int)(_976 > 0.0f))) - ((int)(uint)((int)(_976 < 0.0f))))) * _903) * exp2(log2(abs(_976)) * g_vTonemapCrosstalkSaturation.x);
            _1012 = (float((int)(((int)(uint)((int)(_977 > 0.0f))) - ((int)(uint)((int)(_977 < 0.0f))))) * _903) * exp2(log2(abs(_977)) * g_vTonemapCrosstalkSaturation.y);
            _1014 = (float((int)(((int)(uint)((int)(_978 > 0.0f))) - ((int)(uint)((int)(_978 < 0.0f))))) * _903) * exp2(log2(abs(_978)) * g_vTonemapCrosstalkSaturation.z);
            _1015 = dot(float3(_1010, _1012, _1014), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1028 = select((_1015 <= 0.0f), _1015, ((1.0f - exp2(log2(exp2((_1015 / _883) * -1.4426950216293335f)))) * _883)) * select((!(_1015 == 0.0f)), (1.0f / _1015), 0.0f);
            _1033 = (_1028 * _1010);
            _1034 = (_1028 * _1012);
            _1035 = (_1028 * _1014);
          }
        }
      }
      _1044 = (_1033 * g_fTonemapBrightness);
      _1045 = (_1034 * g_fTonemapBrightness);
      _1046 = (_1035 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1044 = (_318 * _36);
    _1045 = (_319 * _36);
    _1046 = (_320 * _36);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1058 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1068 = _1044 / _36;
    _1069 = _1045 / _36;
    _1070 = _1046 / _36;
    _1074 = 1.0f - sqrt(max(dot(float3(_1068, _1069, _1070), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
    _1080 = g_fFilmGrainIntensity * (_36 * 5.0f);
    _1094 = ((((_1080 * ((_1058.x * 2.0f) + -1.0f)) * saturate(_1068)) * _1074) + _1044);
    _1095 = ((((_1080 * ((_1058.y * 2.0f) + -1.0f)) * _1074) * saturate(_1069)) + _1045);
    _1096 = ((((_1080 * ((_1058.z * 2.0f) + -1.0f)) * _1074) * saturate(_1070)) + _1046);
  } else {
    _1094 = _1044;
    _1095 = _1045;
    _1096 = _1046;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1103 = (g_bHDR == 0);
    do {
      _1130 = _1094;
      _1131 = _1095;
      _1132 = _1096;
      if (!(_1103 || (g_bHDR_scRGB == 0))) {
        _1117 = max(mad(0.043306104838848114f, _1096, mad(0.329291969537735f, _1095, (_1094 * 0.6274019479751587f))), 0.0f);
        _1118 = max(mad(0.0113602289929986f, _1096, mad(0.9195442795753479f, _1095, (_1094 * 0.06909549236297607f))), 0.0f);
        _1119 = max(mad(0.895578145980835f, _1096, mad(0.08802816271781921f, _1095, (_1094 * 0.016393709927797318f))), 0.0f);
        _1130 = mad(-0.07283977419137955f, _1119, mad(-0.5876564383506775f, _1118, (_1117 * 1.6604962348937988f)));
        _1131 = mad(-0.008348013274371624f, _1119, mad(1.1328951120376587f, _1118, (_1117 * -0.1245470941066742f)));
        _1132 = mad(1.118751049041748f, _1119, mad(-0.10059737414121628f, _1118, (_1117 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1103)) {
        _1148 = mad(0.043306104838848114f, _1132, mad(0.329291969537735f, _1131, (_1130 * 0.6274019479751587f)));
        _1149 = mad(0.0113602289929986f, _1132, mad(0.9195442795753479f, _1131, (_1130 * 0.06909549236297607f)));
        _1150 = mad(0.895578145980835f, _1132, mad(0.08802816271781921f, _1131, (_1130 * 0.016393709927797318f)));
      } else {
        _1148 = _1130;
        _1149 = _1131;
        _1150 = _1132;
      }
    } while (false);
  } else {
    _1148 = _1094;
    _1149 = _1095;
    _1150 = _1096;
  }
  SV_Target.x = _1148;
  SV_Target.y = _1149;
  SV_Target.z = _1150;
  SV_Target.w = 1.0f;
  return SV_Target;
}
