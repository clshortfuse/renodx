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
  float _161;
  float _181;
  float _182;
  float _183;
  float _221;
  float _222;
  float _223;
  float _309;
  float _310;
  float _311;
  float _713;
  float _714;
  float _715;
  float _739;
  float _740;
  float _741;
  float _827;
  float _838;
  float _849;
  float _891;
  float _902;
  float _913;
  float _926;
  float _927;
  float _928;
  float _933;
  float _934;
  float _935;
  float _944;
  float _945;
  float _946;
  float _1044;
  float _1045;
  float _1046;
  float _1081;
  float _1092;
  float _1103;
  float _1104;
  float _1105;
  bool _1125;
  float _1146;
  float _1147;
  float _1148;
  float _1181;
  float _1182;
  float _1183;
  float _1199;
  float _1200;
  float _1201;
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
  float _185;
  float _189;
  float _190;
  float _191;
  float _192;
  float _201;
  float _202;
  float _216;
  bool _226;
  float _242;
  float _243;
  float _244;
  float _272;
  float _274;
  float _275;
  float _276;
  float _278;
  float4 _280;
  float4 _284;
  float _294;
  float _295;
  float _296;
  float _298;
  float _317;
  float _318;
  float _319;
  float _366;
  float _370;
  float _371;
  float _372;
  float _381;
  float _382;
  float _399;
  float _401;
  float _402;
  float _421;
  float _424;
  float _427;
  float _445;
  float _466;
  float _469;
  float _487;
  float _508;
  float _527;
  float _528;
  float _529;
  float _540;
  float _541;
  float _554;
  float _555;
  float _556;
  float _563;
  float _566;
  float _571;
  float _586;
  float _589;
  float _608;
  float _614;
  float _631;
  float _655;
  float _672;
  float _729;
  float _734;
  float _747;
  float _749;
  float _755;
  float _763;
  float _777;
  float _778;
  float _779;
  float _784;
  float _812;
  float _813;
  float _814;
  float _856;
  float _858;
  float _859;
  float _860;
  float _862;
  float4 _864;
  float4 _868;
  float _878;
  float _879;
  float _880;
  float _915;
  float4 _958;
  float _965;
  float _966;
  float _967;
  float _970;
  float _971;
  float _972;
  float _976;
  float _981;
  float _995;
  float _996;
  float _997;
  float _1002;
  float _1003;
  float _1004;
  float _1005;
  float _1013;
  float _1020;
  float _1021;
  float _1022;
  float _1026;
  float _1033;
  uint _1050;
  uint _1051;
  uint2 _1052;
  float4 _1066;
  float _1112;
  float _1131;
  float _1141;
  bool _1154;
  float _1168;
  float _1169;
  float _1170;
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
  _150 = (g_bPostProcessApplyTonemap != 0);
  _152 = (g_bPostProcessApplyColorGrade != 0);
  if (!(g_bPostProcessApplyTonemap == 0)) {
    _161 = g_fPaperWhite;
  } else {
    _161 = 1.0f;
  }
  if (_152) {
    _181 = max(_145, 0.0f);
    _182 = max(_146, 0.0f);
    _183 = max(_147, 0.0f);
  } else {
    _181 = _145;
    _182 = _146;
    _183 = _147;
  }
  _185 = g_bBrightness[1];
  _189 = exp2(g_fExposureCompensationInEV100) * _185;
  _190 = _189 * _181;
  _191 = _189 * _182;
  _192 = _189 * _183;
  if (!(g_bApplyVignette == 0)) {
    _201 = ((((g_vOverriddenAspectRatioUVScale.x * _20) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _202 = (((g_vOverriddenAspectRatioUVScale.y * _21) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _216 = saturate(exp2(log2(saturate(1.0f - sqrt((_201 * _201) + (_202 * _202))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _221 = (_216 * _190);
    _222 = (_216 * _191);
    _223 = (_216 * _192);
  } else {
    _221 = _190;
    _222 = _191;
    _223 = _192;
  }
  _226 = (g_bEnableHDRLUT == 0);
  if (!(_226 || (!_152))) {
#if 1
    float3 graded_color = ApplyVanillaPQLUT(
        float3(_221, _222, _223), g_tBaseColorCorrectionMap, g_sLinearClamp_internal, g_fTonemapSaturation);
    _309 = graded_color.x;
    _310 = graded_color.y;
    _311 = graded_color.z;
#else
    _242 = exp2(log2(saturate(_221 * 0.00800000037997961f)) * 0.1593017578125f);
    _243 = exp2(log2(saturate(_222 * 0.00800000037997961f)) * 0.1593017578125f);
    _244 = exp2(log2(saturate(_223 * 0.00800000037997961f)) * 0.1593017578125f);
    _272 = (exp2(log2(((_243 * 18.8515625f) + 0.8359375f) / ((_243 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
    _274 = max((exp2(log2(((_244 * 18.8515625f) + 0.8359375f) / ((_244 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
    _275 = floor(_274);
    _276 = _274 - _275;
    _278 = (((exp2(log2(((_242 * 18.8515625f) + 0.8359375f) / ((_242 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _275) * 0.02083333395421505f;
    _280 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_278, _272), 0.0f);
    _284 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_278 + 0.02083333395421505f), _272), 0.0f);
    _294 = ((_284.x - _280.x) * _276) + _280.x;
    _295 = ((_284.y - _280.y) * _276) + _280.y;
    _296 = ((_284.z - _280.z) * _276) + _280.z;
    _298 = dot(float3(_294, _295, _296), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _309 = (lerp(_298, _294, g_fTonemapSaturation));
    _310 = (lerp(_298, _295, g_fTonemapSaturation));
    _311 = (lerp(_298, _296, g_fTonemapSaturation));
#endif
  } else {
    _309 = _221;
    _310 = _222;
    _311 = _223;
  }
  if (_150) {
    do {
      _933 = _309;
      _934 = _310;
      _935 = _311;
      if (!(g_iTonemapper == 0)) {
        _317 = max(_309, 0.0f);
        _318 = max(_310, 0.0f);
        _319 = max(_311, 0.0f);
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _317, _318, _319, _161,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes);
          _933 = agx_color.x;
          _934 = agx_color.y;
          _935 = agx_color.z;
#else
          _366 = g_fAgxMaxEV - g_fAgxMinEV;
          _370 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _319, mad(g_vAgxInsetRow0.y, _318, (g_vAgxInsetRow0.x * _317))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _366);
          _371 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _319, mad(g_vAgxInsetRow1.y, _318, (g_vAgxInsetRow1.x * _317))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _366);
          _372 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _319, mad(g_vAgxInsetRow2.y, _318, (g_vAgxInsetRow2.x * _317))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _366);
          _381 = (g_fAgxContrastSlope * (_370 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _382 = 1.0f / g_fAgxShoulderPower;
          _399 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _401 = _399 * (0.6060606241226196f - _370);
          _402 = 1.0f / g_fAgxToePower;
          _421 = -0.0f - g_fAgxToePrecalcConstant;
          _424 = select((_370 >= 0.6060606241226196f), ((_381 / exp2(log2((float((int)(((int)(uint)((int)(_381 > 0.0f))) - ((int)(uint)((int)(_381 < 0.0f))))) * exp2(log2(abs(_381)) * g_fAgxShoulderPower)) + 1.0f) * _382)) * g_fAgxShoulderPrecalcConstant), ((_401 / exp2(log2((float((int)(((int)(uint)((int)(_401 > 0.0f))) - ((int)(uint)((int)(_401 < 0.0f))))) * exp2(log2(abs(_401)) * g_fAgxToePower)) + 1.0f) * _402)) * _421)) + 0.4894371032714844f;
          _427 = (g_fAgxContrastSlope * (_371 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _445 = _399 * (0.6060606241226196f - _371);
          _466 = select((_371 >= 0.6060606241226196f), ((_427 / exp2(log2((float((int)(((int)(uint)((int)(_427 > 0.0f))) - ((int)(uint)((int)(_427 < 0.0f))))) * exp2(log2(abs(_427)) * g_fAgxShoulderPower)) + 1.0f) * _382)) * g_fAgxShoulderPrecalcConstant), ((_445 / exp2(log2((exp2(log2(abs(_445)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_445 > 0.0f))) - ((int)(uint)((int)(_445 < 0.0f)))))) + 1.0f) * _402)) * _421)) + 0.4894371032714844f;
          _469 = (g_fAgxContrastSlope * (_372 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _487 = _399 * (0.6060606241226196f - _372);
          _508 = select((_372 >= 0.6060606241226196f), ((_469 / exp2(log2((float((int)(((int)(uint)((int)(_469 > 0.0f))) - ((int)(uint)((int)(_469 < 0.0f))))) * exp2(log2(abs(_469)) * g_fAgxShoulderPower)) + 1.0f) * _382)) * g_fAgxShoulderPrecalcConstant), ((_487 / exp2(log2((exp2(log2(abs(_487)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_487 > 0.0f))) - ((int)(uint)((int)(_487 < 0.0f)))))) + 1.0f) * _402)) * _421)) + 0.4894371032714844f;
          _527 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _508, mad(g_vAgxOutsetRow0.y, _466, (_424 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _528 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _508, mad(g_vAgxOutsetRow1.y, _466, (_424 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _529 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _508, mad(g_vAgxOutsetRow2.y, _466, (_424 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _713 = _527;
            _714 = _528;
            _715 = _529;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_527, max(_528, _529)) >= g_fAgxHDRMidGrey))) {
                _540 = log2(1.0f / g_fAgxHDRMidGrey);
                _541 = _540 + 20.0f;
                _554 = min(max(log2(max(_527, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _540);
                _555 = min(max(log2(max(_528, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _540);
                _556 = min(max(log2(max(_529, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _540);
                _563 = 20.0f / _541;
                _566 = (20.0f - log2(g_fAgxHDRRatio)) / _541;
                _571 = ((_554 / _541) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _586 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                _589 = ((-0.0f - _554) / _541) * _586;
                _608 = -0.0f - g_fAgxHDRToePrecalcConstant;
                _614 = ((_555 / _541) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _631 = ((-0.0f - _555) / _541) * _586;
                _655 = ((_556 / _541) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _672 = ((-0.0f - _556) / _541) * _586;
                _713 = (saturate(exp2(((select((((_554 + 20.0f) / _541) >= _563), ((_571 / exp2(log2((float((int)(((int)(uint)((int)(_571 > 0.0f))) - ((int)(uint)((int)(_571 < 0.0f))))) * exp2(log2(abs(_571)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_589 / exp2(log2((float((int)(((int)(uint)((int)(_589 > 0.0f))) - ((int)(uint)((int)(_589 < 0.0f))))) * exp2(log2(abs(_589)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _608)) + _566) * _541) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _714 = (saturate(exp2(((select((((_555 + 20.0f) / _541) >= _563), ((_614 / exp2(log2((float((int)(((int)(uint)((int)(_614 > 0.0f))) - ((int)(uint)((int)(_614 < 0.0f))))) * exp2(log2(abs(_614)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_631 / exp2(log2((float((int)(((int)(uint)((int)(_631 > 0.0f))) - ((int)(uint)((int)(_631 < 0.0f))))) * exp2(log2(abs(_631)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _608)) + _566) * _541) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _715 = (saturate(exp2(((select((((_556 + 20.0f) / _541) >= _563), ((_655 / exp2(log2((float((int)(((int)(uint)((int)(_655 > 0.0f))) - ((int)(uint)((int)(_655 < 0.0f))))) * exp2(log2(abs(_655)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_672 / exp2(log2((float((int)(((int)(uint)((int)(_672 > 0.0f))) - ((int)(uint)((int)(_672 < 0.0f))))) * exp2(log2(abs(_672)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _608)) + _566) * _541) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _713 = _527;
                _714 = _528;
                _715 = _529;
              }
            }
            _933 = (mad(-0.07283977419137955f, _715, mad(-0.5876564383506775f, _714, (_713 * 1.6604962348937988f))) * _161);
            _934 = (mad(-0.008348013274371624f, _715, mad(1.1328951120376587f, _714, (_713 * -0.1245470941066742f))) * _161);
            _935 = (mad(1.118751049041748f, _715, mad(-0.10059737414121628f, _714, (_713 * -0.018153680488467216f))) * _161);
          } while (false);
#endif
        } else {
          _729 = dot(float3(_317, _318, _319), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
          do {
            _739 = _317;
            _740 = _318;
            _741 = _319;
            if (!(_729 == 0.0f)) {
              _734 = max(dot(float3(_309, _310, _311), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _729;
              _739 = (_734 * _317);
              _740 = (_734 * _318);
              _741 = (_734 * _319);
            }
            _747 = max(max(_739, max(_740, _741)), 0.0f);
            _749 = 1.0f / max(_747, 1.1754943508222875e-38f);
            _755 = (pow(_747, g_vTonemapGTParams.x));
            _763 = _755 / (((pow(_755, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
            _777 = exp2(log2(_749 * _739) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
            _778 = exp2(log2(_749 * _740) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
            _779 = exp2(log2(_749 * _741) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
            _784 = log2(_763);
            _812 = saturate(exp2(log2((exp2(_784 * g_vTonemapCrosstalk.x) * (1.0f - _777)) + _777) * g_vTonemapCrosstalkSaturation.x) * _763);
            _813 = saturate(exp2(log2((exp2(_784 * g_vTonemapCrosstalk.y) * (1.0f - _778)) + _778) * g_vTonemapCrosstalkSaturation.y) * _763);
            _814 = saturate(exp2(log2((exp2(_784 * g_vTonemapCrosstalk.z) * (1.0f - _779)) + _779) * g_vTonemapCrosstalkSaturation.z) * _763);
            if (_226) {
              do {
                _926 = _812;
                _927 = _813;
                _928 = _814;
                if (_152) {
                  do {
                    [branch]
                    if (!(_812 <= 0.0031308000907301903f)) {
                      _827 = (((pow(_812, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _827 = (_812 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_813 <= 0.0031308000907301903f)) {
                        _838 = (((pow(_813, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _838 = (_813 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_814 <= 0.0031308000907301903f)) {
                          _849 = (((pow(_814, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _849 = (_814 * 12.920000076293945f);
                        }
                        _856 = (saturate(_838) * 0.96875f) + 0.015625f;
                        _858 = max((saturate(_849) * 31.0f), 0.0f);
                        _859 = floor(_858);
                        _860 = _858 - _859;
                        _862 = (((saturate(_827) * 0.96875f) + 0.015625f) + _859) * 0.03125f;
                        _864 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_862, _856), 0.0f);
                        _868 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_862 + 0.03125f), _856), 0.0f);
                        _878 = ((_868.x - _864.x) * _860) + _864.x;
                        _879 = ((_868.y - _864.y) * _860) + _864.y;
                        _880 = ((_868.z - _864.z) * _860) + _864.z;
                        do {
                          [branch]
                          if (!(_878 <= 0.040449999272823334f)) {
                            _891 = exp2(log2((_878 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _891 = (_878 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_879 <= 0.040449999272823334f)) {
                              _902 = exp2(log2((_879 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _902 = (_879 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_880 <= 0.040449999272823334f)) {
                                _913 = exp2(log2((_880 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _913 = (_880 * 0.07739938050508499f);
                              }
                              _915 = dot(float3(_891, _902, _913), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _926 = (lerp(_915, _891, g_fTonemapSaturation));
                              _927 = (lerp(_915, _902, g_fTonemapSaturation));
                              _928 = (lerp(_915, _913, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _933 = (_926 * _161);
                _934 = (_927 * _161);
                _935 = (_928 * _161);
              } while (false);
            } else {
              _933 = _812;
              _934 = _813;
              _935 = _814;
            }
          } while (false);
        }
      }
      _944 = (_933 * g_fTonemapBrightness);
      _945 = (_934 * g_fTonemapBrightness);
      _946 = (_935 * g_fTonemapBrightness);
    } while (false);
  } else {
    _944 = (_309 * _161);
    _945 = (_310 * _161);
    _946 = (_311 * _161);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _958 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _965 = (_958.x * 2.0f) + -1.0f;
    _966 = (_958.y * 2.0f) + -1.0f;
    _967 = (_958.z * 2.0f) + -1.0f;
    if (!(_150)) {
      _970 = _944 / _161;
      _971 = _945 / _161;
      _972 = _946 / _161;
      _976 = 1.0f - sqrt(max(dot(float3(_970, _971, _972), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
      _981 = g_fFilmGrainIntensity * (_161 * 5.0f);
      _1044 = ((((_981 * _965) * saturate(_970)) * _976) + _944);
      _1045 = ((((_981 * _966) * _976) * saturate(_971)) + _945);
      _1046 = ((((_981 * _967) * _976) * saturate(_972)) + _946);
    } else {
      _995 = saturate(_944);
      _996 = saturate(_945);
      _997 = saturate(_946);
      _1002 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_995, max(_996, _997))));
      _1003 = _1002 * _995;
      _1004 = _1002 * _996;
      _1005 = _1002 * _997;
      _1013 = ((1.0f - sqrt(dot(float3(_1003, _1004, _1005), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
      _1020 = ((_1013 * _965) * min(1.0f, _1003)) + _1003;
      _1021 = ((_1013 * _966) * min(1.0f, _1004)) + _1004;
      _1022 = ((_1013 * _967) * min(1.0f, _1005)) + _1005;
      _1026 = 1.0f / (max(_1020, max(_1021, _1022)) + 1.0f);
      _1033 = 1.0f / (max(_1003, max(_1004, _1005)) + 1.0f);
      _1044 = (((_1020 * _1026) + _944) - (_1033 * _1003));
      _1045 = (((_1021 * _1026) + _945) - (_1033 * _1004));
      _1046 = (((_1022 * _1026) + _946) - (_1033 * _1005));
    }
  } else {
    _1044 = _944;
    _1045 = _945;
    _1046 = _946;
  }
  if (!(_87)) {
    _1050 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _1051 = (uint)(int(SV_Position.y)) + (uint)(-48);
    uint2 _1052;
    g_tBaseColorCorrectionMap.GetDimensions(_1052.x, _1052.y);
    if (((int)_1051 < (int)int(float((int)((int)(_1052.y))))) && (((int)(_1051 | _1050) > (int)-1) && ((int)_1050 < (int)int(float((int)((int)(_1052.x))))))) {
      _1066 = g_tBaseColorCorrectionMap.Load(int3(_1050, _1051, 0));
      if (_226) {
        do {
          [branch]
          if (!(_1066.x <= 0.040449999272823334f)) {
            _1081 = exp2(log2((_1066.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
          } else {
            _1081 = (_1066.x * 0.07739938050508499f);
          }
          do {
            [branch]
            if (!(_1066.y <= 0.040449999272823334f)) {
              _1092 = exp2(log2((_1066.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1092 = (_1066.y * 0.07739938050508499f);
            }
            [branch]
            if (!(_1066.z <= 0.040449999272823334f)) {
              _1103 = _1081;
              _1104 = _1092;
              _1105 = exp2(log2((_1066.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1103 = _1081;
              _1104 = _1092;
              _1105 = (_1066.z * 0.07739938050508499f);
            }
          } while (false);
        } while (false);
      } else {
        _1103 = _1066.x;
        _1104 = _1066.y;
        _1105 = _1066.z;
      }
    } else {
      _1103 = _1044;
      _1104 = _1045;
      _1105 = _1046;
    }
  } else {
    _1103 = _1044;
    _1104 = _1045;
    _1105 = _1046;
  }
  if (!(g_bDebugValidateOutputRange == 0)) {
    _1112 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
    do {
      _1125 = true;
      if (!(((_1103 < 0.0f) || (_1104 < 0.0f)) || (_1105 < 0.0f))) {
        _1125 = ((_1105 > _1112) || ((_1103 > _1112) || (_1104 > _1112)));
      }
      if (_1125) {
        _1131 = float((int)(int(g_fRealTime * 15.0f)));
        _1141 = select((((((int)((uint)(int(SV_Position.y - _1131)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1131)) / 5u))) & 1) == 0), 1.0f, 0.0f);
        _1146 = (_1141 * _1103);
        _1147 = (_1141 * _1104);
        _1148 = (_1141 * _1105);
      } else {
        _1146 = _1103;
        _1147 = _1104;
        _1148 = _1105;
      }
    } while (false);
  } else {
    _1146 = _1103;
    _1147 = _1104;
    _1148 = _1105;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1154 = (g_bHDR == 0);
    do {
      _1181 = _1146;
      _1182 = _1147;
      _1183 = _1148;
      if (!(_1154 || (g_bHDR_scRGB == 0))) {
        _1168 = max(mad(0.043306104838848114f, _1148, mad(0.329291969537735f, _1147, (_1146 * 0.6274019479751587f))), 0.0f);
        _1169 = max(mad(0.0113602289929986f, _1148, mad(0.9195442795753479f, _1147, (_1146 * 0.06909549236297607f))), 0.0f);
        _1170 = max(mad(0.895578145980835f, _1148, mad(0.08802816271781921f, _1147, (_1146 * 0.016393709927797318f))), 0.0f);
        _1181 = mad(-0.07283977419137955f, _1170, mad(-0.5876564383506775f, _1169, (_1168 * 1.6604962348937988f)));
        _1182 = mad(-0.008348013274371624f, _1170, mad(1.1328951120376587f, _1169, (_1168 * -0.1245470941066742f)));
        _1183 = mad(1.118751049041748f, _1170, mad(-0.10059737414121628f, _1169, (_1168 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1154)) {
        _1199 = mad(0.043306104838848114f, _1183, mad(0.329291969537735f, _1182, (_1181 * 0.6274019479751587f)));
        _1200 = mad(0.0113602289929986f, _1183, mad(0.9195442795753479f, _1182, (_1181 * 0.06909549236297607f)));
        _1201 = mad(0.895578145980835f, _1183, mad(0.08802816271781921f, _1182, (_1181 * 0.016393709927797318f)));
      } else {
        _1199 = _1181;
        _1200 = _1182;
        _1201 = _1183;
      }
    } while (false);
  } else {
    _1199 = _1146;
    _1200 = _1147;
    _1201 = _1148;
  }
  SV_Target.x = _1199;
  SV_Target.y = _1200;
  SV_Target.z = _1201;
  SV_Target.w = 1.0f;
  return SV_Target;
}
