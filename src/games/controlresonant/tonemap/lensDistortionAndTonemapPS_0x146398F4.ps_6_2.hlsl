#include "./tonemap.hlsli"

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
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _20;
  float _21;
  float4 _22;
  float _35;
  float _36;
  float _37;
  float _97;
  float _98;
  float _99;
  float _112;
  float _132;
  float _133;
  float _134;
  float _172;
  float _173;
  float _174;
  float _260;
  float _261;
  float _262;
  float _664;
  float _665;
  float _666;
  float _694;
  float _695;
  float _696;
  float _781;
  float _792;
  float _803;
  float _845;
  float _856;
  float _867;
  float _880;
  float _881;
  float _882;
  float _1041;
  float _1042;
  float _1043;
  float _1052;
  float _1053;
  float _1054;
  float _1102;
  float _1103;
  float _1104;
  float _1139;
  float _1150;
  float _1161;
  float _1162;
  float _1163;
  bool _1192;
  float _1213;
  float _1214;
  float _1215;
  float _1248;
  float _1249;
  float _1250;
  float _1266;
  float _1267;
  float _1268;
  float4 _30;
  bool _39;
  uint _43;
  uint _44;
  float _52;
  float _54;
  float _55;
  float _76;
  float _77;
  float _78;
  float _80;
  float _85;
  float _89;
  bool _102;
  bool _104;
  float _136;
  float _140;
  float _141;
  float _142;
  float _143;
  float _152;
  float _153;
  float _167;
  bool _177;
  float _193;
  float _194;
  float _195;
  float _223;
  float _225;
  float _226;
  float _227;
  float _229;
  float4 _231;
  float4 _235;
  float _245;
  float _246;
  float _247;
  float _249;
  float _293;
  float _294;
  float _295;
  float _317;
  float _321;
  float _322;
  float _323;
  float _332;
  float _333;
  float _350;
  float _352;
  float _353;
  float _372;
  float _375;
  float _378;
  float _396;
  float _417;
  float _420;
  float _438;
  float _459;
  float _478;
  float _479;
  float _480;
  float _491;
  float _492;
  float _505;
  float _506;
  float _507;
  float _514;
  float _517;
  float _522;
  float _537;
  float _540;
  float _559;
  float _565;
  float _582;
  float _606;
  float _623;
  float _681;
  float _682;
  float _683;
  float _684;
  float _689;
  float _702;
  float _704;
  float _710;
  float _718;
  float _732;
  float _733;
  float _734;
  float _739;
  float _767;
  float _768;
  float _769;
  float _810;
  float _812;
  float _813;
  float _814;
  float _816;
  float4 _818;
  float4 _822;
  float _832;
  float _833;
  float _834;
  float _869;
  float _891;
  float _896;
  float _898;
  float _899;
  float _900;
  float _901;
  float _911;
  float _915;
  float _964;
  float _965;
  float _966;
  float _971;
  float _984;
  float _985;
  float _986;
  float _1018;
  float _1020;
  float _1022;
  float _1023;
  float _1036;
  float4 _1066;
  float _1076;
  float _1077;
  float _1078;
  float _1082;
  float _1088;
  uint _1108;
  uint _1109;
  uint2 _1110;
  float4 _1124;
  float _1169;
  float _1172;
  float _1175;
  float _1179;
  float _1198;
  float _1208;
  bool _1221;
  float _1235;
  float _1236;
  float _1237;
  _20 = g_vInvOutputRes.x * SV_Position.x;
  _21 = g_vInvOutputRes.y * SV_Position.y;
  _22 = g_tSource.Sample(g_sLinearClamp_internal, float2(_20, _21));
  if (!(g_bDebugReferenceImage == 0)) {
    _30 = g_tSourceReferenceImage.Sample(g_sLinearClamp_internal, float2(_20, _21));
    _35 = _30.x;
    _36 = _30.y;
    _37 = _30.z;
  } else {
    _35 = _22.x;
    _36 = _22.y;
    _37 = _22.z;
  }
  _39 = (g_bDebugLUT == 0);
  if (!(_39)) {
    _43 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _44 = (uint)(int(SV_Position.y)) + (uint)(-112);
    if (((int)_44 < (int)300) && (((int)_43 < (int)500) && ((int)(_44 | _43) > (int)-1))) {
      _52 = float((int)(_43));
      _54 = _52 * 0.0020000000949949026f;
      _55 = float((int)(_44)) * 0.005333333276212215f;
      _76 = saturate(2.0f - (abs(frac(_55) + -0.5f) * 6.0f)) * 2.0f;
      _77 = saturate(2.0f - (abs(frac(_55 + 0.3333333432674408f) + -0.5f) * 6.0f)) * 2.0f;
      _78 = saturate(2.0f - (abs(frac(_55 + -0.3333333432674408f) + -0.5f) * 6.0f)) * 2.0f;
      _80 = g_bBrightness[0];
      _85 = _54 * _54;
      _89 = ((_52 * 0.25f) * (_85 * _85)) * (_80 / exp2(g_fExposureCompensationInEV100));
      _97 = ((_76 * _76) * _89);
      _98 = ((_77 * _77) * _89);
      _99 = ((_78 * _78) * _89);
    } else {
      _97 = _35;
      _98 = _36;
      _99 = _37;
    }
  } else {
    _97 = _35;
    _98 = _36;
    _99 = _37;
  }
  _102 = (g_bPostProcessApplyTonemap == 0);
  _104 = (g_bPostProcessApplyColorGrade != 0);
  if (!(_102)) {
    _112 = g_fPaperWhite;
  } else {
    _112 = 1.0f;
  }
  if (_104) {
    _132 = max(_97, 0.0f);
    _133 = max(_98, 0.0f);
    _134 = max(_99, 0.0f);
  } else {
    _132 = _97;
    _133 = _98;
    _134 = _99;
  }
  _136 = g_bBrightness[1];
  _140 = exp2(g_fExposureCompensationInEV100) * _136;
  _141 = _140 * _132;
  _142 = _140 * _133;
  _143 = _140 * _134;
  if (!(g_bApplyVignette == 0)) {
    _152 = ((((g_vOverriddenAspectRatioUVScale.x * _20) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _153 = (((g_vOverriddenAspectRatioUVScale.y * _21) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _167 = saturate(exp2(log2(saturate(1.0f - sqrt((_152 * _152) + (_153 * _153))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _172 = (_167 * _141);
    _173 = (_167 * _142);
    _174 = (_167 * _143);
  } else {
    _172 = _141;
    _173 = _142;
    _174 = _143;
  }
  _177 = (g_bEnableHDRLUT == 0);
  if (!(_177 || (!_104))) {
  #if 1
    float3 graded_color = ApplyVanillaPQLUT(
      float3(_172, _173, _174), g_tBaseColorCorrectionMap, g_sLinearClamp_internal, g_fTonemapSaturation);
    _260 = graded_color.x;
    _261 = graded_color.y;
    _262 = graded_color.z;
  #else
    _193 = exp2(log2(saturate(_172 * 0.00800000037997961f)) * 0.1593017578125f);
    _194 = exp2(log2(saturate(_173 * 0.00800000037997961f)) * 0.1593017578125f);
    _195 = exp2(log2(saturate(_174 * 0.00800000037997961f)) * 0.1593017578125f);
    _223 = (exp2(log2(((_194 * 18.8515625f) + 0.8359375f) / ((_194 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
    _225 = max((exp2(log2(((_195 * 18.8515625f) + 0.8359375f) / ((_195 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
    _226 = floor(_225);
    _227 = _225 - _226;
    _229 = (((exp2(log2(((_193 * 18.8515625f) + 0.8359375f) / ((_193 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _226) * 0.02083333395421505f;
    _231 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_229, _223), 0.0f);
    _235 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_229 + 0.02083333395421505f), _223), 0.0f);
    _245 = ((_235.x - _231.x) * _227) + _231.x;
    _246 = ((_235.y - _231.y) * _227) + _231.y;
    _247 = ((_235.z - _231.z) * _227) + _231.z;
    _249 = dot(float3(_245, _246, _247), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _260 = (lerp(_249, _245, g_fTonemapSaturation));
    _261 = (lerp(_249, _246, g_fTonemapSaturation));
    _262 = (lerp(_249, _247, g_fTonemapSaturation));
  #endif
  } else {
    _260 = _172;
    _261 = _173;
    _262 = _174;
  }
  if (!(_102)) {
    do {
      _1041 = _260;
      _1042 = _261;
      _1043 = _262;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _260, _261, _262, _112,
              g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes);
          _1041 = agx_color.x;
          _1042 = agx_color.y;
          _1043 = agx_color.z;
#else
          _293 = max(_260, 0.0f);
          _294 = max(_261, 0.0f);
          _295 = max(_262, 0.0f);
          _317 = g_fAgxMaxEV - g_fAgxMinEV;
          _321 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _295, mad(g_vAgxInsetRow0.y, _294, (_293 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _317);
          _322 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _295, mad(g_vAgxInsetRow1.y, _294, (_293 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _317);
          _323 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _295, mad(g_vAgxInsetRow2.y, _294, (_293 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _317);
          _332 = (g_fAgxContrastSlope * (_321 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _333 = 1.0f / g_fAgxShoulderPower;
          _350 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _352 = _350 * (0.6060606241226196f - _321);
          _353 = 1.0f / g_fAgxToePower;
          _372 = -0.0f - g_fAgxToePrecalcConstant;
          _375 = select((_321 >= 0.6060606241226196f), ((_332 / exp2(log2((float((int)(((int)(uint)((int)(_332 > 0.0f))) - ((int)(uint)((int)(_332 < 0.0f))))) * exp2(log2(abs(_332)) * g_fAgxShoulderPower)) + 1.0f) * _333)) * g_fAgxShoulderPrecalcConstant), ((_352 / exp2(log2((float((int)(((int)(uint)((int)(_352 > 0.0f))) - ((int)(uint)((int)(_352 < 0.0f))))) * exp2(log2(abs(_352)) * g_fAgxToePower)) + 1.0f) * _353)) * _372)) + 0.4894371032714844f;
          _378 = (g_fAgxContrastSlope * (_322 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _396 = _350 * (0.6060606241226196f - _322);
          _417 = select((_322 >= 0.6060606241226196f), ((_378 / exp2(log2((float((int)(((int)(uint)((int)(_378 > 0.0f))) - ((int)(uint)((int)(_378 < 0.0f))))) * exp2(log2(abs(_378)) * g_fAgxShoulderPower)) + 1.0f) * _333)) * g_fAgxShoulderPrecalcConstant), ((_396 / exp2(log2((exp2(log2(abs(_396)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_396 > 0.0f))) - ((int)(uint)((int)(_396 < 0.0f)))))) + 1.0f) * _353)) * _372)) + 0.4894371032714844f;
          _420 = (g_fAgxContrastSlope * (_323 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _438 = _350 * (0.6060606241226196f - _323);
          _459 = select((_323 >= 0.6060606241226196f), ((_420 / exp2(log2((float((int)(((int)(uint)((int)(_420 > 0.0f))) - ((int)(uint)((int)(_420 < 0.0f))))) * exp2(log2(abs(_420)) * g_fAgxShoulderPower)) + 1.0f) * _333)) * g_fAgxShoulderPrecalcConstant), ((_438 / exp2(log2((exp2(log2(abs(_438)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_438 > 0.0f))) - ((int)(uint)((int)(_438 < 0.0f)))))) + 1.0f) * _353)) * _372)) + 0.4894371032714844f;
          _478 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _459, mad(g_vAgxOutsetRow0.y, _417, (_375 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _479 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _459, mad(g_vAgxOutsetRow1.y, _417, (_375 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _480 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _459, mad(g_vAgxOutsetRow2.y, _417, (_375 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _664 = _478;
            _665 = _479;
            _666 = _480;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_478, max(_479, _480)) >= g_fAgxHDRMidGrey))) {
                _491 = log2(1.0f / g_fAgxHDRMidGrey);
                _492 = _491 + 20.0f;
                _505 = min(max(log2(max(_478, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _491);
                _506 = min(max(log2(max(_479, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _491);
                _507 = min(max(log2(max(_480, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _491);
                _514 = 20.0f / _492;
                _517 = (20.0f - log2(g_fAgxHDRRatio)) / _492;
                _522 = ((_505 / _492) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _537 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                _540 = ((-0.0f - _505) / _492) * _537;
                _559 = -0.0f - g_fAgxHDRToePrecalcConstant;
                _565 = ((_506 / _492) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _582 = ((-0.0f - _506) / _492) * _537;
                _606 = ((_507 / _492) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _623 = ((-0.0f - _507) / _492) * _537;
                _664 = (saturate(exp2(((select((((_505 + 20.0f) / _492) >= _514), ((_522 / exp2(log2((float((int)(((int)(uint)((int)(_522 > 0.0f))) - ((int)(uint)((int)(_522 < 0.0f))))) * exp2(log2(abs(_522)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_540 / exp2(log2((float((int)(((int)(uint)((int)(_540 > 0.0f))) - ((int)(uint)((int)(_540 < 0.0f))))) * exp2(log2(abs(_540)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _559)) + _517) * _492) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _665 = (saturate(exp2(((select((((_506 + 20.0f) / _492) >= _514), ((_565 / exp2(log2((float((int)(((int)(uint)((int)(_565 > 0.0f))) - ((int)(uint)((int)(_565 < 0.0f))))) * exp2(log2(abs(_565)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_582 / exp2(log2((float((int)(((int)(uint)((int)(_582 > 0.0f))) - ((int)(uint)((int)(_582 < 0.0f))))) * exp2(log2(abs(_582)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _559)) + _517) * _492) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _666 = (saturate(exp2(((select((((_507 + 20.0f) / _492) >= _514), ((_606 / exp2(log2((float((int)(((int)(uint)((int)(_606 > 0.0f))) - ((int)(uint)((int)(_606 < 0.0f))))) * exp2(log2(abs(_606)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_623 / exp2(log2((float((int)(((int)(uint)((int)(_623 > 0.0f))) - ((int)(uint)((int)(_623 < 0.0f))))) * exp2(log2(abs(_623)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _559)) + _517) * _492) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _664 = _478;
                _665 = _479;
                _666 = _480;
              }
            }
            _1041 = (mad(-0.07283977419137955f, _666, mad(-0.5876564383506775f, _665, (_664 * 1.6604962348937988f))) * _112);
            _1042 = (mad(-0.008348013274371624f, _666, mad(1.1328951120376587f, _665, (_664 * -0.1245470941066742f))) * _112);
            _1043 = (mad(1.118751049041748f, _666, mad(-0.10059737414121628f, _665, (_664 * -0.018153680488467216f))) * _112);
          } while (false);
#endif
        } else {
          if (_177) {
            _681 = max(_260, 0.0f);
            _682 = max(_261, 0.0f);
            _683 = max(_262, 0.0f);
            _684 = dot(float3(_681, _682, _683), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            do {
              _694 = _681;
              _695 = _682;
              _696 = _683;
              if (!(_684 == 0.0f)) {
                _689 = max(dot(float3(_260, _261, _262), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _684;
                _694 = (_689 * _681);
                _695 = (_689 * _682);
                _696 = (_689 * _683);
              }
              _702 = max(max(_694, max(_695, _696)), 0.0f);
              _704 = 1.0f / max(_702, 1.1754943508222875e-38f);
              _710 = (pow(_702, g_vTonemapGTParams.x));
              _718 = _710 / (((pow(_710, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
              _732 = exp2(log2(_704 * _694) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
              _733 = exp2(log2(_704 * _695) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
              _734 = exp2(log2(_704 * _696) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
              _739 = log2(_718);
              _767 = saturate(exp2(log2((exp2(_739 * g_vTonemapCrosstalk.x) * (1.0f - _732)) + _732) * g_vTonemapCrosstalkSaturation.x) * _718);
              _768 = saturate(exp2(log2((exp2(_739 * g_vTonemapCrosstalk.y) * (1.0f - _733)) + _733) * g_vTonemapCrosstalkSaturation.y) * _718);
              _769 = saturate(exp2(log2((exp2(_739 * g_vTonemapCrosstalk.z) * (1.0f - _734)) + _734) * g_vTonemapCrosstalkSaturation.z) * _718);
              do {
                _880 = _767;
                _881 = _768;
                _882 = _769;
                if (_104) {
                  do {
                    [branch]
                    if (!(_767 <= 0.0031308000907301903f)) {
                      _781 = (((pow(_767, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _781 = (_767 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_768 <= 0.0031308000907301903f)) {
                        _792 = (((pow(_768, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _792 = (_768 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_769 <= 0.0031308000907301903f)) {
                          _803 = (((pow(_769, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _803 = (_769 * 12.920000076293945f);
                        }
                        _810 = (saturate(_792) * 0.96875f) + 0.015625f;
                        _812 = max((saturate(_803) * 31.0f), 0.0f);
                        _813 = floor(_812);
                        _814 = _812 - _813;
                        _816 = (((saturate(_781) * 0.96875f) + 0.015625f) + _813) * 0.03125f;
                        _818 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_816, _810), 0.0f);
                        _822 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_816 + 0.03125f), _810), 0.0f);
                        _832 = ((_822.x - _818.x) * _814) + _818.x;
                        _833 = ((_822.y - _818.y) * _814) + _818.y;
                        _834 = ((_822.z - _818.z) * _814) + _818.z;
                        do {
                          [branch]
                          if (!(_832 <= 0.040449999272823334f)) {
                            _845 = exp2(log2((_832 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _845 = (_832 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_833 <= 0.040449999272823334f)) {
                              _856 = exp2(log2((_833 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _856 = (_833 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_834 <= 0.040449999272823334f)) {
                                _867 = exp2(log2((_834 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _867 = (_834 * 0.07739938050508499f);
                              }
                              _869 = dot(float3(_845, _856, _867), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _880 = (lerp(_869, _845, g_fTonemapSaturation));
                              _881 = (lerp(_869, _856, g_fTonemapSaturation));
                              _882 = (lerp(_869, _867, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1041 = (_880 * _112);
                _1042 = (_881 * _112);
                _1043 = (_882 * _112);
              } while (false);
            } while (false);
          } else {
            _891 = g_fMaxOutputNits * 0.012500000186264515f;
            _896 = max(abs(_260), max(abs(_261), abs(_262)));
            _898 = 1.0f / max(_896, 1.1754943508222875e-38f);
            _899 = _898 * _260;
            _900 = _898 * _261;
            _901 = _898 * _262;
            _911 = (_112 * 0.18000000715255737f) * exp2(log2((pow(_896, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
            _915 = dot(float3((_911 * _899), (_911 * _900), (_911 * _901)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _964 = exp2(log2(abs(_899)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_899 > 0.0f))) - ((int)(uint)((int)(_899 < 0.0f)))));
            _965 = exp2(log2(abs(_900)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_900 > 0.0f))) - ((int)(uint)((int)(_900 < 0.0f)))));
            _966 = exp2(log2(abs(_901)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_901 > 0.0f))) - ((int)(uint)((int)(_901 < 0.0f)))));
            _971 = log2(saturate(select((_915 <= 0.0f), _915, ((1.0f - exp2(log2(exp2((_915 / _891) * -1.4426950216293335f)))) * _891)) / _891));
            _984 = (exp2(_971 * g_vTonemapCrosstalk.x) * (1.0f - _964)) + _964;
            _985 = (exp2(_971 * g_vTonemapCrosstalk.y) * (1.0f - _965)) + _965;
            _986 = (exp2(_971 * g_vTonemapCrosstalk.z) * (1.0f - _966)) + _966;
            _1018 = (float((int)(((int)(uint)((int)(_984 > 0.0f))) - ((int)(uint)((int)(_984 < 0.0f))))) * _911) * exp2(log2(abs(_984)) * g_vTonemapCrosstalkSaturation.x);
            _1020 = (float((int)(((int)(uint)((int)(_985 > 0.0f))) - ((int)(uint)((int)(_985 < 0.0f))))) * _911) * exp2(log2(abs(_985)) * g_vTonemapCrosstalkSaturation.y);
            _1022 = (float((int)(((int)(uint)((int)(_986 > 0.0f))) - ((int)(uint)((int)(_986 < 0.0f))))) * _911) * exp2(log2(abs(_986)) * g_vTonemapCrosstalkSaturation.z);
            _1023 = dot(float3(_1018, _1020, _1022), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1036 = select((_1023 <= 0.0f), _1023, ((1.0f - exp2(log2(exp2((_1023 / _891) * -1.4426950216293335f)))) * _891)) * select((!(_1023 == 0.0f)), (1.0f / _1023), 0.0f);
            _1041 = (_1036 * _1018);
            _1042 = (_1036 * _1020);
            _1043 = (_1036 * _1022);
          }
        }
      }
      _1052 = (_1041 * g_fTonemapBrightness);
      _1053 = (_1042 * g_fTonemapBrightness);
      _1054 = (_1043 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1052 = (_260 * _112);
    _1053 = (_261 * _112);
    _1054 = (_262 * _112);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1066 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1076 = _1052 / _112;
    _1077 = _1053 / _112;
    _1078 = _1054 / _112;
    _1082 = 1.0f - sqrt(max(dot(float3(_1076, _1077, _1078), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
    _1088 = g_fFilmGrainIntensity * (_112 * 5.0f);
    _1102 = ((((_1088 * ((_1066.x * 2.0f) + -1.0f)) * saturate(_1076)) * _1082) + _1052);
    _1103 = ((((_1088 * ((_1066.y * 2.0f) + -1.0f)) * _1082) * saturate(_1077)) + _1053);
    _1104 = ((((_1088 * ((_1066.z * 2.0f) + -1.0f)) * _1082) * saturate(_1078)) + _1054);
  } else {
    _1102 = _1052;
    _1103 = _1053;
    _1104 = _1054;
  }
  if (!(_39)) {
    _1108 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _1109 = (uint)(int(SV_Position.y)) + (uint)(-48);
    uint2 _1110; g_tBaseColorCorrectionMap.GetDimensions(_1110.x, _1110.y);
    if (((int)_1109 < (int)int(float((int)((int)(_1110.y))))) && (((int)(_1109 | _1108) > (int)-1) && ((int)_1108 < (int)int(float((int)((int)(_1110.x))))))) {
      _1124 = g_tBaseColorCorrectionMap.Load(int3(_1108, _1109, 0));
      if (_177) {
        do {
          [branch]
          if (!(_1124.x <= 0.040449999272823334f)) {
            _1139 = exp2(log2((_1124.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
          } else {
            _1139 = (_1124.x * 0.07739938050508499f);
          }
          do {
            [branch]
            if (!(_1124.y <= 0.040449999272823334f)) {
              _1150 = exp2(log2((_1124.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1150 = (_1124.y * 0.07739938050508499f);
            }
            [branch]
            if (!(_1124.z <= 0.040449999272823334f)) {
              _1161 = _1139;
              _1162 = _1150;
              _1163 = exp2(log2((_1124.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1161 = _1139;
              _1162 = _1150;
              _1163 = (_1124.z * 0.07739938050508499f);
            }
          } while (false);
        } while (false);
      } else {
        _1161 = _1124.x;
        _1162 = _1124.y;
        _1163 = _1124.z;
      }
    } else {
      _1161 = _1102;
      _1162 = _1103;
      _1163 = _1104;
    }
  } else {
    _1161 = _1102;
    _1162 = _1103;
    _1163 = _1104;
  }
  if (!(g_bDebugValidateOutputRange == 0)) {
    _1169 = mad(0.043306104838848114f, _1163, mad(0.329291969537735f, _1162, (_1161 * 0.6274019479751587f)));
    _1172 = mad(0.0113602289929986f, _1163, mad(0.9195442795753479f, _1162, (_1161 * 0.06909549236297607f)));
    _1175 = mad(0.895578145980835f, _1163, mad(0.08802816271781921f, _1162, (_1161 * 0.016393709927797318f)));
    _1179 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
    do {
      _1192 = true;
      if (!(((_1169 < 0.0f) || (_1172 < 0.0f)) || (_1175 < 0.0f))) {
        _1192 = ((_1175 > _1179) || ((_1169 > _1179) || (_1172 > _1179)));
      }
      if (_1192) {
        _1198 = float((int)(int(g_fRealTime * 15.0f)));
        _1208 = select((((((int)((uint)(int(SV_Position.y - _1198)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1198)) / 5u))) & 1) == 0), 1.0f, 0.0f);
        _1213 = (_1208 * _1161);
        _1214 = (_1208 * _1162);
        _1215 = (_1208 * _1163);
      } else {
        _1213 = _1161;
        _1214 = _1162;
        _1215 = _1163;
      }
    } while (false);
  } else {
    _1213 = _1161;
    _1214 = _1162;
    _1215 = _1163;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1221 = (g_bHDR == 0);
    do {
      _1248 = _1213;
      _1249 = _1214;
      _1250 = _1215;
      if (!(_1221 || (g_bHDR_scRGB == 0))) {
        _1235 = max(mad(0.043306104838848114f, _1215, mad(0.329291969537735f, _1214, (_1213 * 0.6274019479751587f))), 0.0f);
        _1236 = max(mad(0.0113602289929986f, _1215, mad(0.9195442795753479f, _1214, (_1213 * 0.06909549236297607f))), 0.0f);
        _1237 = max(mad(0.895578145980835f, _1215, mad(0.08802816271781921f, _1214, (_1213 * 0.016393709927797318f))), 0.0f);
        _1248 = mad(-0.07283977419137955f, _1237, mad(-0.5876564383506775f, _1236, (_1235 * 1.6604962348937988f)));
        _1249 = mad(-0.008348013274371624f, _1237, mad(1.1328951120376587f, _1236, (_1235 * -0.1245470941066742f)));
        _1250 = mad(1.118751049041748f, _1237, mad(-0.10059737414121628f, _1236, (_1235 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1221)) {
        _1266 = mad(0.043306104838848114f, _1250, mad(0.329291969537735f, _1249, (_1248 * 0.6274019479751587f)));
        _1267 = mad(0.0113602289929986f, _1250, mad(0.9195442795753479f, _1249, (_1248 * 0.06909549236297607f)));
        _1268 = mad(0.895578145980835f, _1250, mad(0.08802816271781921f, _1249, (_1248 * 0.016393709927797318f)));
      } else {
        _1266 = _1248;
        _1267 = _1249;
        _1268 = _1250;
      }
    } while (false);
  } else {
    _1266 = _1213;
    _1267 = _1214;
    _1268 = _1215;
  }
  SV_Target.x = _1266;
  SV_Target.y = _1267;
  SV_Target.z = _1268;
  SV_Target.w = 1.0f;
  return SV_Target;
}