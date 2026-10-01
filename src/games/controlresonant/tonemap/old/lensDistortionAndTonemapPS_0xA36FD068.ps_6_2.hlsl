#include "../tonemap.hlsli"

StructuredBuffer<float> g_bBrightness : register(t0);

Texture2D<float4> g_tFilmGrain : register(t1);

Texture2D<float4> g_tBaseColorCorrectionMap : register(t2);

Texture2D<float4> g_tSource : register(t3);

Texture2D<float4> g_tSourceReferenceImage : register(t4);

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

cbuffer shared_time : register(b2) {
  float g_fWorldTime : packoffset(c000.x);
  float g_fWorldTimeDelta : packoffset(c000.y);
  float g_fRealTime : packoffset(c000.z);
  float g_fRealTimeDelta : packoffset(c000.w);
  uint g_uTemporalFrame : packoffset(c001.x);
  uint g_uCurrentFrame : packoffset(c001.y);
  int g_bCinematicActive : packoffset(c001.z);
};

cbuffer shared_hdr_global : register(b3) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

cbuffer shared_hdr : register(b4) {
  float g_fExposureCompensationInEV100 : packoffset(c000.x);
};

cbuffer shared_tonemap_general : register(b5) {
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

cbuffer shared_tonemap_post : register(b6) {
  float g_fPaperWhite : packoffset(c000.x);
  int g_bApplyVignette : packoffset(c000.y);
  int g_bApplyFilmGrain : packoffset(c000.z);
};

cbuffer postprocess : register(b7) {
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
  float _20;
  float _21;
  float _31;
  float _32;
  float _62;
  float _63;
  float _83;
  float _84;
  float _85;
  float _145;
  float _146;
  float _147;
  float _160;
  float _180;
  float _181;
  float _182;
  float _220;
  float _221;
  float _222;
  float _308;
  float _309;
  float _310;
  float _712;
  float _713;
  float _714;
  float _742;
  float _743;
  float _744;
  float _829;
  float _840;
  float _851;
  float _893;
  float _904;
  float _915;
  float _928;
  float _929;
  float _930;
  float _1089;
  float _1090;
  float _1091;
  float _1100;
  float _1101;
  float _1102;
  float _1150;
  float _1151;
  float _1152;
  float _1187;
  float _1198;
  float _1209;
  float _1210;
  float _1211;
  bool _1240;
  float _1261;
  float _1262;
  float _1263;
  float _1296;
  float _1297;
  float _1298;
  float _1314;
  float _1315;
  float _1316;
  float _43;
  float _47;
  float _48;
  float _52;
  float _56;
  float4 _70;
  float4 _78;
  bool _87;
  uint _91;
  uint _92;
  float _100;
  float _102;
  float _103;
  float _124;
  float _125;
  float _126;
  float _128;
  float _133;
  float _137;
  bool _150;
  bool _152;
  float _184;
  float _188;
  float _189;
  float _190;
  float _191;
  float _200;
  float _201;
  float _215;
  bool _225;
  float _241;
  float _242;
  float _243;
  float _271;
  float _273;
  float _274;
  float _275;
  float _277;
  float4 _279;
  float4 _283;
  float _293;
  float _294;
  float _295;
  float _297;
  float _341;
  float _342;
  float _343;
  float _365;
  float _369;
  float _370;
  float _371;
  float _380;
  float _381;
  float _398;
  float _400;
  float _401;
  float _420;
  float _423;
  float _426;
  float _444;
  float _465;
  float _468;
  float _486;
  float _507;
  float _526;
  float _527;
  float _528;
  float _539;
  float _540;
  float _553;
  float _554;
  float _555;
  float _562;
  float _565;
  float _570;
  float _585;
  float _588;
  float _607;
  float _613;
  float _630;
  float _654;
  float _671;
  float _729;
  float _730;
  float _731;
  float _732;
  float _737;
  float _750;
  float _752;
  float _758;
  float _766;
  float _780;
  float _781;
  float _782;
  float _787;
  float _815;
  float _816;
  float _817;
  float _858;
  float _860;
  float _861;
  float _862;
  float _864;
  float4 _866;
  float4 _870;
  float _880;
  float _881;
  float _882;
  float _917;
  float _939;
  float _944;
  float _946;
  float _947;
  float _948;
  float _949;
  float _959;
  float _963;
  float _1012;
  float _1013;
  float _1014;
  float _1019;
  float _1032;
  float _1033;
  float _1034;
  float _1066;
  float _1068;
  float _1070;
  float _1071;
  float _1084;
  float4 _1114;
  float _1124;
  float _1125;
  float _1126;
  float _1130;
  float _1136;
  uint _1156;
  uint _1157;
  uint2 _1158;
  float4 _1172;
  float _1217;
  float _1220;
  float _1223;
  float _1227;
  float _1246;
  float _1256;
  bool _1269;
  float _1283;
  float _1284;
  float _1285;
  _20 = g_vInvOutputRes.x * SV_Position.x;
  _21 = g_vInvOutputRes.y * SV_Position.y;
  _31 = ((_20 * 2.0f) + -1.0f) / g_vLensDistortionUVScale.x;
  _32 = ((_21 * 2.0f) + -1.0f) / g_vLensDistortionUVScale.y;
  if (!(!(g_vLensDistortionParams.w >= 0.0f))) {
    _43 = (g_vLensDistortionParams.x - ((_31 * _31) * g_vLensDistortionParams.y)) - ((_32 * _32) * g_vLensDistortionParams.z);
    _62 = (_31 / _43);
    _63 = (_32 / _43);
  } else {
    _47 = _31 * 0.5f;
    _48 = _32 * 0.5f;
    _52 = sqrt((_48 * _48) + (_47 * _47));
    _56 = (((_52 * _52) * g_vLensDistortionParams.w) + 1.0f) * _52;
    _62 = (_56 * (_31 / _52));
    _63 = (_56 * (_32 / _52));
  }
  _70 = g_tSource.Sample(g_sLinearClamp_internal, float2((((_62 * g_vLensDistortionUVScale.x) + 1.0f) * 0.5f), (((_63 * g_vLensDistortionUVScale.y) + 1.0f) * 0.5f)));
  if (!(g_bDebugReferenceImage == 0)) {
    _78 = g_tSourceReferenceImage.Sample(g_sLinearClamp_internal, float2(_20, _21));
    _83 = _78.x;
    _84 = _78.y;
    _85 = _78.z;
  } else {
    _83 = _70.x;
    _84 = _70.y;
    _85 = _70.z;
  }
  _87 = (g_bDebugLUT == 0);
  if (!(_87)) {
    _91 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _92 = (uint)(int(SV_Position.y)) + (uint)(-112);
    if (((int)_92 < (int)300) && (((int)_91 < (int)500) && ((int)(_92 | _91) > (int)-1))) {
      _100 = float((int)(_91));
      _102 = _100 * 0.0020000000949949026f;
      _103 = float((int)(_92)) * 0.005333333276212215f;
      _124 = saturate(2.0f - (abs(frac(_103) + -0.5f) * 6.0f)) * 2.0f;
      _125 = saturate(2.0f - (abs(frac(_103 + 0.3333333432674408f) + -0.5f) * 6.0f)) * 2.0f;
      _126 = saturate(2.0f - (abs(frac(_103 + -0.3333333432674408f) + -0.5f) * 6.0f)) * 2.0f;
      _128 = g_bBrightness[0];
      _133 = _102 * _102;
      _137 = ((_100 * 0.25f) * (_133 * _133)) * (_128 / exp2(g_fExposureCompensationInEV100));
      _145 = ((_124 * _124) * _137);
      _146 = ((_125 * _125) * _137);
      _147 = ((_126 * _126) * _137);
    } else {
      _145 = _83;
      _146 = _84;
      _147 = _85;
    }
  } else {
    _145 = _83;
    _146 = _84;
    _147 = _85;
  }
  _150 = (g_bPostProcessApplyTonemap == 0);
  _152 = (g_bPostProcessApplyColorGrade != 0);
  if (!(_150)) {
    _160 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  } else {
    _160 = 1.0f;
  }
  if (_152) {
    _180 = max(_145, 0.0f);
    _181 = max(_146, 0.0f);
    _182 = max(_147, 0.0f);
  } else {
    _180 = _145;
    _181 = _146;
    _182 = _147;
  }
  _184 = g_bBrightness[1];
  _188 = exp2(g_fExposureCompensationInEV100) * _184;
  _189 = _188 * _180;
  _190 = _188 * _181;
  _191 = _188 * _182;
  if (!(g_bApplyVignette == 0)) {
    _200 = ((((g_vOverriddenAspectRatioUVScale.x * _20) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _201 = (((g_vOverriddenAspectRatioUVScale.y * _21) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _215 = saturate(exp2(log2(saturate(1.0f - sqrt((_200 * _200) + (_201 * _201))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _220 = (_215 * _189);
    _221 = (_215 * _190);
    _222 = (_215 * _191);
  } else {
    _220 = _189;
    _221 = _190;
    _222 = _191;
  }
  _225 = (g_bEnableHDRLUT == 0);
  if (!(_225 || (!_152))) {
    _241 = exp2(log2(saturate(_220 * 0.00800000037997961f)) * 0.1593017578125f);
    _242 = exp2(log2(saturate(_221 * 0.00800000037997961f)) * 0.1593017578125f);
    _243 = exp2(log2(saturate(_222 * 0.00800000037997961f)) * 0.1593017578125f);
    _271 = (exp2(log2(((_242 * 18.8515625f) + 0.8359375f) / ((_242 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
    _273 = max((exp2(log2(((_243 * 18.8515625f) + 0.8359375f) / ((_243 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
    _274 = floor(_273);
    _275 = _273 - _274;
    _277 = (((exp2(log2(((_241 * 18.8515625f) + 0.8359375f) / ((_241 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _274) * 0.02083333395421505f;
    _279 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_277, _271), 0.0f);
    _283 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_277 + 0.02083333395421505f), _271), 0.0f);
    _293 = ((_283.x - _279.x) * _275) + _279.x;
    _294 = ((_283.y - _279.y) * _275) + _279.y;
    _295 = ((_283.z - _279.z) * _275) + _279.z;
    _297 = dot(float3(_293, _294, _295), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _308 = (lerp(_297, _293, g_fTonemapSaturation));
    _309 = (lerp(_297, _294, g_fTonemapSaturation));
    _310 = (lerp(_297, _295, g_fTonemapSaturation));
  } else {
    _308 = _220;
    _309 = _221;
    _310 = _222;
  }
  if (!(_150)) {
    do {
      _1089 = _308;
      _1090 = _309;
      _1091 = _310;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _308, _309, _310, _160,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes);
          _1089 = agx_color.x;
          _1090 = agx_color.y;
          _1091 = agx_color.z;
#else
          _341 = max(_308, 0.0f);
          _342 = max(_309, 0.0f);
          _343 = max(_310, 0.0f);
          _365 = g_fAgxMaxEV - g_fAgxMinEV;
          _369 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _343, mad(g_vAgxInsetRow0.y, _342, (_341 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _365);
          _370 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _343, mad(g_vAgxInsetRow1.y, _342, (_341 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _365);
          _371 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _343, mad(g_vAgxInsetRow2.y, _342, (_341 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _365);
          _380 = (g_fAgxContrastSlope * (_369 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _381 = 1.0f / g_fAgxShoulderPower;
          _398 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _400 = _398 * (0.6060606241226196f - _369);
          _401 = 1.0f / g_fAgxToePower;
          _420 = -0.0f - g_fAgxToePrecalcConstant;
          _423 = select((_369 >= 0.6060606241226196f), ((_380 / exp2(log2((float((int)(((int)(uint)((int)(_380 > 0.0f))) - ((int)(uint)((int)(_380 < 0.0f))))) * exp2(log2(abs(_380)) * g_fAgxShoulderPower)) + 1.0f) * _381)) * g_fAgxShoulderPrecalcConstant), ((_400 / exp2(log2((float((int)(((int)(uint)((int)(_400 > 0.0f))) - ((int)(uint)((int)(_400 < 0.0f))))) * exp2(log2(abs(_400)) * g_fAgxToePower)) + 1.0f) * _401)) * _420)) + 0.4894371032714844f;
          _426 = (g_fAgxContrastSlope * (_370 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _444 = _398 * (0.6060606241226196f - _370);
          _465 = select((_370 >= 0.6060606241226196f), ((_426 / exp2(log2((float((int)(((int)(uint)((int)(_426 > 0.0f))) - ((int)(uint)((int)(_426 < 0.0f))))) * exp2(log2(abs(_426)) * g_fAgxShoulderPower)) + 1.0f) * _381)) * g_fAgxShoulderPrecalcConstant), ((_444 / exp2(log2((exp2(log2(abs(_444)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_444 > 0.0f))) - ((int)(uint)((int)(_444 < 0.0f)))))) + 1.0f) * _401)) * _420)) + 0.4894371032714844f;
          _468 = (g_fAgxContrastSlope * (_371 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _486 = _398 * (0.6060606241226196f - _371);
          _507 = select((_371 >= 0.6060606241226196f), ((_468 / exp2(log2((float((int)(((int)(uint)((int)(_468 > 0.0f))) - ((int)(uint)((int)(_468 < 0.0f))))) * exp2(log2(abs(_468)) * g_fAgxShoulderPower)) + 1.0f) * _381)) * g_fAgxShoulderPrecalcConstant), ((_486 / exp2(log2((exp2(log2(abs(_486)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_486 > 0.0f))) - ((int)(uint)((int)(_486 < 0.0f)))))) + 1.0f) * _401)) * _420)) + 0.4894371032714844f;
          _526 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _507, mad(g_vAgxOutsetRow0.y, _465, (_423 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _527 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _507, mad(g_vAgxOutsetRow1.y, _465, (_423 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _528 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _507, mad(g_vAgxOutsetRow2.y, _465, (_423 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _712 = _526;
            _713 = _527;
            _714 = _528;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_526, max(_527, _528)) >= g_fAgxHDRMidGrey))) {
                _539 = log2(1.0f / g_fAgxHDRMidGrey);
                _540 = _539 + 20.0f;
                _553 = min(max(log2(max(_526, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _539);
                _554 = min(max(log2(max(_527, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _539);
                _555 = min(max(log2(max(_528, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _539);
                _562 = 20.0f / _540;
                _565 = (20.0f - log2(g_fAgxHDRRatio)) / _540;
                _570 = ((_553 / _540) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _585 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                _588 = ((-0.0f - _553) / _540) * _585;
                _607 = -0.0f - g_fAgxHDRToePrecalcConstant;
                _613 = ((_554 / _540) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _630 = ((-0.0f - _554) / _540) * _585;
                _654 = ((_555 / _540) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _671 = ((-0.0f - _555) / _540) * _585;
                _712 = (saturate(exp2(((select((((_553 + 20.0f) / _540) >= _562), ((_570 / exp2(log2((float((int)(((int)(uint)((int)(_570 > 0.0f))) - ((int)(uint)((int)(_570 < 0.0f))))) * exp2(log2(abs(_570)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_588 / exp2(log2((float((int)(((int)(uint)((int)(_588 > 0.0f))) - ((int)(uint)((int)(_588 < 0.0f))))) * exp2(log2(abs(_588)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _607)) + _565) * _540) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _713 = (saturate(exp2(((select((((_554 + 20.0f) / _540) >= _562), ((_613 / exp2(log2((float((int)(((int)(uint)((int)(_613 > 0.0f))) - ((int)(uint)((int)(_613 < 0.0f))))) * exp2(log2(abs(_613)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_630 / exp2(log2((float((int)(((int)(uint)((int)(_630 > 0.0f))) - ((int)(uint)((int)(_630 < 0.0f))))) * exp2(log2(abs(_630)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _607)) + _565) * _540) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _714 = (saturate(exp2(((select((((_555 + 20.0f) / _540) >= _562), ((_654 / exp2(log2((float((int)(((int)(uint)((int)(_654 > 0.0f))) - ((int)(uint)((int)(_654 < 0.0f))))) * exp2(log2(abs(_654)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_671 / exp2(log2((float((int)(((int)(uint)((int)(_671 > 0.0f))) - ((int)(uint)((int)(_671 < 0.0f))))) * exp2(log2(abs(_671)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _607)) + _565) * _540) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _712 = _526;
                _713 = _527;
                _714 = _528;
              }
            }
            _1089 = (mad(-0.07283977419137955f, _714, mad(-0.5876564383506775f, _713, (_712 * 1.6604962348937988f))) * _160);
            _1090 = (mad(-0.008348013274371624f, _714, mad(1.1328951120376587f, _713, (_712 * -0.1245470941066742f))) * _160);
            _1091 = (mad(1.118751049041748f, _714, mad(-0.10059737414121628f, _713, (_712 * -0.018153680488467216f))) * _160);
          } while (false);
#endif
        } else {
          if (_225) {
            _729 = max(_308, 0.0f);
            _730 = max(_309, 0.0f);
            _731 = max(_310, 0.0f);
            _732 = dot(float3(_729, _730, _731), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            do {
              _742 = _729;
              _743 = _730;
              _744 = _731;
              if (!(_732 == 0.0f)) {
                _737 = max(dot(float3(_308, _309, _310), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _732;
                _742 = (_737 * _729);
                _743 = (_737 * _730);
                _744 = (_737 * _731);
              }
              _750 = max(max(_742, max(_743, _744)), 0.0f);
              _752 = 1.0f / max(_750, 1.1754943508222875e-38f);
              _758 = (pow(_750, g_vTonemapGTParams.x));
              _766 = _758 / (((pow(_758, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
              _780 = exp2(log2(_752 * _742) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
              _781 = exp2(log2(_752 * _743) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
              _782 = exp2(log2(_752 * _744) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
              _787 = log2(_766);
              _815 = saturate(exp2(log2((exp2(_787 * g_vTonemapCrosstalk.x) * (1.0f - _780)) + _780) * g_vTonemapCrosstalkSaturation.x) * _766);
              _816 = saturate(exp2(log2((exp2(_787 * g_vTonemapCrosstalk.y) * (1.0f - _781)) + _781) * g_vTonemapCrosstalkSaturation.y) * _766);
              _817 = saturate(exp2(log2((exp2(_787 * g_vTonemapCrosstalk.z) * (1.0f - _782)) + _782) * g_vTonemapCrosstalkSaturation.z) * _766);
              do {
                _928 = _815;
                _929 = _816;
                _930 = _817;
                if (_152) {
                  do {
                    [branch]
                    if (!(_815 <= 0.0031308000907301903f)) {
                      _829 = (((pow(_815, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _829 = (_815 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_816 <= 0.0031308000907301903f)) {
                        _840 = (((pow(_816, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _840 = (_816 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_817 <= 0.0031308000907301903f)) {
                          _851 = (((pow(_817, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _851 = (_817 * 12.920000076293945f);
                        }
                        _858 = (saturate(_840) * 0.96875f) + 0.015625f;
                        _860 = max((saturate(_851) * 31.0f), 0.0f);
                        _861 = floor(_860);
                        _862 = _860 - _861;
                        _864 = (((saturate(_829) * 0.96875f) + 0.015625f) + _861) * 0.03125f;
                        _866 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_864, _858), 0.0f);
                        _870 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_864 + 0.03125f), _858), 0.0f);
                        _880 = ((_870.x - _866.x) * _862) + _866.x;
                        _881 = ((_870.y - _866.y) * _862) + _866.y;
                        _882 = ((_870.z - _866.z) * _862) + _866.z;
                        do {
                          [branch]
                          if (!(_880 <= 0.040449999272823334f)) {
                            _893 = exp2(log2((_880 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _893 = (_880 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_881 <= 0.040449999272823334f)) {
                              _904 = exp2(log2((_881 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _904 = (_881 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_882 <= 0.040449999272823334f)) {
                                _915 = exp2(log2((_882 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _915 = (_882 * 0.07739938050508499f);
                              }
                              _917 = dot(float3(_893, _904, _915), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _928 = (lerp(_917, _893, g_fTonemapSaturation));
                              _929 = (lerp(_917, _904, g_fTonemapSaturation));
                              _930 = (lerp(_917, _915, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1089 = (_928 * _160);
                _1090 = (_929 * _160);
                _1091 = (_930 * _160);
              } while (false);
            } while (false);
          } else {
            _939 = g_fMaxOutputNits * 0.012500000186264515f;
            _944 = max(abs(_308), max(abs(_309), abs(_310)));
            _946 = 1.0f / max(_944, 1.1754943508222875e-38f);
            _947 = _946 * _308;
            _948 = _946 * _309;
            _949 = _946 * _310;
            _959 = (_160 * 0.18000000715255737f) * exp2(log2((pow(_944, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
            _963 = dot(float3((_959 * _947), (_959 * _948), (_959 * _949)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1012 = exp2(log2(abs(_947)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_947 > 0.0f))) - ((int)(uint)((int)(_947 < 0.0f)))));
            _1013 = exp2(log2(abs(_948)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_948 > 0.0f))) - ((int)(uint)((int)(_948 < 0.0f)))));
            _1014 = exp2(log2(abs(_949)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_949 > 0.0f))) - ((int)(uint)((int)(_949 < 0.0f)))));
            _1019 = log2(saturate(select((_963 <= 0.0f), _963, ((1.0f - exp2(log2(exp2((_963 / _939) * -1.4426950216293335f)))) * _939)) / _939));
            _1032 = (exp2(_1019 * g_vTonemapCrosstalk.x) * (1.0f - _1012)) + _1012;
            _1033 = (exp2(_1019 * g_vTonemapCrosstalk.y) * (1.0f - _1013)) + _1013;
            _1034 = (exp2(_1019 * g_vTonemapCrosstalk.z) * (1.0f - _1014)) + _1014;
            _1066 = (float((int)(((int)(uint)((int)(_1032 > 0.0f))) - ((int)(uint)((int)(_1032 < 0.0f))))) * _959) * exp2(log2(abs(_1032)) * g_vTonemapCrosstalkSaturation.x);
            _1068 = (float((int)(((int)(uint)((int)(_1033 > 0.0f))) - ((int)(uint)((int)(_1033 < 0.0f))))) * _959) * exp2(log2(abs(_1033)) * g_vTonemapCrosstalkSaturation.y);
            _1070 = (float((int)(((int)(uint)((int)(_1034 > 0.0f))) - ((int)(uint)((int)(_1034 < 0.0f))))) * _959) * exp2(log2(abs(_1034)) * g_vTonemapCrosstalkSaturation.z);
            _1071 = dot(float3(_1066, _1068, _1070), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1084 = select((_1071 <= 0.0f), _1071, ((1.0f - exp2(log2(exp2((_1071 / _939) * -1.4426950216293335f)))) * _939)) * select((!(_1071 == 0.0f)), (1.0f / _1071), 0.0f);
            _1089 = (_1084 * _1066);
            _1090 = (_1084 * _1068);
            _1091 = (_1084 * _1070);
          }
        }
      }
      _1100 = (_1089 * g_fTonemapBrightness);
      _1101 = (_1090 * g_fTonemapBrightness);
      _1102 = (_1091 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1100 = (_308 * _160);
    _1101 = (_309 * _160);
    _1102 = (_310 * _160);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1114 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1124 = _1100 / _160;
    _1125 = _1101 / _160;
    _1126 = _1102 / _160;
    _1130 = 1.0f - sqrt(max(dot(float3(_1124, _1125, _1126), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
    _1136 = g_fFilmGrainIntensity * (_160 * 5.0f);
    _1150 = ((((_1136 * ((_1114.x * 2.0f) + -1.0f)) * saturate(_1124)) * _1130) + _1100);
    _1151 = ((((_1136 * ((_1114.y * 2.0f) + -1.0f)) * _1130) * saturate(_1125)) + _1101);
    _1152 = ((((_1136 * ((_1114.z * 2.0f) + -1.0f)) * _1130) * saturate(_1126)) + _1102);
  } else {
    _1150 = _1100;
    _1151 = _1101;
    _1152 = _1102;
  }
  if (!(_87)) {
    _1156 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _1157 = (uint)(int(SV_Position.y)) + (uint)(-48);
    uint2 _1158;
    g_tBaseColorCorrectionMap.GetDimensions(_1158.x, _1158.y);
    if (((int)_1157 < (int)int(float((int)((int)(_1158.y))))) && (((int)(_1157 | _1156) > (int)-1) && ((int)_1156 < (int)int(float((int)((int)(_1158.x))))))) {
      _1172 = g_tBaseColorCorrectionMap.Load(int3(_1156, _1157, 0));
      if (_225) {
        do {
          [branch]
          if (!(_1172.x <= 0.040449999272823334f)) {
            _1187 = exp2(log2((_1172.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
          } else {
            _1187 = (_1172.x * 0.07739938050508499f);
          }
          do {
            [branch]
            if (!(_1172.y <= 0.040449999272823334f)) {
              _1198 = exp2(log2((_1172.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1198 = (_1172.y * 0.07739938050508499f);
            }
            [branch]
            if (!(_1172.z <= 0.040449999272823334f)) {
              _1209 = _1187;
              _1210 = _1198;
              _1211 = exp2(log2((_1172.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1209 = _1187;
              _1210 = _1198;
              _1211 = (_1172.z * 0.07739938050508499f);
            }
          } while (false);
        } while (false);
      } else {
        _1209 = _1172.x;
        _1210 = _1172.y;
        _1211 = _1172.z;
      }
    } else {
      _1209 = _1150;
      _1210 = _1151;
      _1211 = _1152;
    }
  } else {
    _1209 = _1150;
    _1210 = _1151;
    _1211 = _1152;
  }
  if (!(g_bDebugValidateOutputRange == 0)) {
    _1217 = mad(0.043306104838848114f, _1211, mad(0.329291969537735f, _1210, (_1209 * 0.6274019479751587f)));
    _1220 = mad(0.0113602289929986f, _1211, mad(0.9195442795753479f, _1210, (_1209 * 0.06909549236297607f)));
    _1223 = mad(0.895578145980835f, _1211, mad(0.08802816271781921f, _1210, (_1209 * 0.016393709927797318f)));
    _1227 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
    do {
      _1240 = true;
      if (!(((_1217 < 0.0f) || (_1220 < 0.0f)) || (_1223 < 0.0f))) {
        _1240 = ((_1223 > _1227) || ((_1217 > _1227) || (_1220 > _1227)));
      }
      if (_1240) {
        _1246 = float((int)(int(g_fRealTime * 15.0f)));
        _1256 = select((((((int)((uint)(int(SV_Position.y - _1246)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1246)) / 5u))) & 1) == 0), 1.0f, 0.0f);
        _1261 = (_1256 * _1209);
        _1262 = (_1256 * _1210);
        _1263 = (_1256 * _1211);
      } else {
        _1261 = _1209;
        _1262 = _1210;
        _1263 = _1211;
      }
    } while (false);
  } else {
    _1261 = _1209;
    _1262 = _1210;
    _1263 = _1211;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1269 = (g_bHDR == 0);
    do {
      _1296 = _1261;
      _1297 = _1262;
      _1298 = _1263;
      if (!(_1269 || (g_bHDR_scRGB == 0))) {
        _1283 = max(mad(0.043306104838848114f, _1263, mad(0.329291969537735f, _1262, (_1261 * 0.6274019479751587f))), 0.0f);
        _1284 = max(mad(0.0113602289929986f, _1263, mad(0.9195442795753479f, _1262, (_1261 * 0.06909549236297607f))), 0.0f);
        _1285 = max(mad(0.895578145980835f, _1263, mad(0.08802816271781921f, _1262, (_1261 * 0.016393709927797318f))), 0.0f);
        _1296 = mad(-0.07283977419137955f, _1285, mad(-0.5876564383506775f, _1284, (_1283 * 1.6604962348937988f)));
        _1297 = mad(-0.008348013274371624f, _1285, mad(1.1328951120376587f, _1284, (_1283 * -0.1245470941066742f)));
        _1298 = mad(1.118751049041748f, _1285, mad(-0.10059737414121628f, _1284, (_1283 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1269)) {
        _1314 = mad(0.043306104838848114f, _1298, mad(0.329291969537735f, _1297, (_1296 * 0.6274019479751587f)));
        _1315 = mad(0.0113602289929986f, _1298, mad(0.9195442795753479f, _1297, (_1296 * 0.06909549236297607f)));
        _1316 = mad(0.895578145980835f, _1298, mad(0.08802816271781921f, _1297, (_1296 * 0.016393709927797318f)));
      } else {
        _1314 = _1296;
        _1315 = _1297;
        _1316 = _1298;
      }
    } while (false);
  } else {
    _1314 = _1261;
    _1315 = _1262;
    _1316 = _1263;
  }
  SV_Target.x = _1314;
  SV_Target.y = _1315;
  SV_Target.z = _1316;
  SV_Target.w = 1.0f;
  return SV_Target;
}
