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

cbuffer sourceres : register(b6) {
  float2 g_vSourceRes : packoffset(c000.x);
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
  float _19;
  float _20;
  float _30;
  float _31;
  float _61;
  float _62;
  float _278;
  float _298;
  float _299;
  float _300;
  float _338;
  float _339;
  float _340;
  float _426;
  float _427;
  float _428;
  float _830;
  float _831;
  float _832;
  float _856;
  float _857;
  float _858;
  float _944;
  float _955;
  float _966;
  float _1008;
  float _1019;
  float _1030;
  float _1043;
  float _1044;
  float _1045;
  float _1050;
  float _1051;
  float _1052;
  float _1061;
  float _1062;
  float _1063;
  float _1161;
  float _1162;
  float _1163;
  float _1197;
  float _1198;
  float _1199;
  float _1215;
  float _1216;
  float _1217;
  float _42;
  float _46;
  float _47;
  float _51;
  float _55;
  float _67;
  float _68;
  float _72;
  float _73;
  float _76;
  float _77;
  float _78;
  float _79;
  float _80;
  float _81;
  float _82;
  float _83;
  float _90;
  float _91;
  float _92;
  float _93;
  float _94;
  float _95;
  float _108;
  float _109;
  float _112;
  float _113;
  float _114;
  float _115;
  float _124;
  float _125;
  float _126;
  float _127;
  float _128;
  float _129;
  float4 _130;
  float4 _137;
  float4 _147;
  float4 _160;
  float4 _167;
  float4 _174;
  float4 _181;
  float4 _188;
  float4 _195;
  float4 _226;
  float4 _231;
  float4 _236;
  float _262;
  float _263;
  float _264;
  bool _267;
  bool _269;
  float _302;
  float _306;
  float _307;
  float _308;
  float _309;
  float _318;
  float _319;
  float _333;
  bool _343;
  float _359;
  float _360;
  float _361;
  float _389;
  float _391;
  float _392;
  float _393;
  float _395;
  float4 _397;
  float4 _401;
  float _411;
  float _412;
  float _413;
  float _415;
  float _434;
  float _435;
  float _436;
  float _483;
  float _487;
  float _488;
  float _489;
  float _498;
  float _499;
  float _516;
  float _518;
  float _519;
  float _538;
  float _541;
  float _544;
  float _562;
  float _583;
  float _586;
  float _604;
  float _625;
  float _644;
  float _645;
  float _646;
  float _657;
  float _658;
  float _671;
  float _672;
  float _673;
  float _680;
  float _683;
  float _688;
  float _703;
  float _706;
  float _725;
  float _731;
  float _748;
  float _772;
  float _789;
  float _846;
  float _851;
  float _864;
  float _866;
  float _872;
  float _880;
  float _894;
  float _895;
  float _896;
  float _901;
  float _929;
  float _930;
  float _931;
  float _973;
  float _975;
  float _976;
  float _977;
  float _979;
  float4 _981;
  float4 _985;
  float _995;
  float _996;
  float _997;
  float _1032;
  float4 _1075;
  float _1082;
  float _1083;
  float _1084;
  float _1087;
  float _1088;
  float _1089;
  float _1093;
  float _1098;
  float _1112;
  float _1113;
  float _1114;
  float _1119;
  float _1120;
  float _1121;
  float _1122;
  float _1130;
  float _1137;
  float _1138;
  float _1139;
  float _1143;
  float _1150;
  bool _1170;
  float _1184;
  float _1185;
  float _1186;
  _19 = g_vInvOutputRes.x * SV_Position.x;
  _20 = g_vInvOutputRes.y * SV_Position.y;
  _30 = ((_19 * 2.0f) + -1.0f) / g_vLensDistortionUVScale.x;
  _31 = ((_20 * 2.0f) + -1.0f) / g_vLensDistortionUVScale.y;
  if (!(!(g_vLensDistortionParams.w >= 0.0f))) {
    _42 = (g_vLensDistortionParams.x - ((_30 * _30) * g_vLensDistortionParams.y)) - ((_31 * _31) * g_vLensDistortionParams.z);
    _61 = (_30 / _42);
    _62 = (_31 / _42);
  } else {
    _46 = _30 * 0.5f;
    _47 = _31 * 0.5f;
    _51 = sqrt((_47 * _47) + (_46 * _46));
    _55 = (((_51 * _51) * g_vLensDistortionParams.w) + 1.0f) * _51;
    _61 = (_55 * (_30 / _51));
    _62 = (_55 * (_31 / _51));
  }
  _67 = ((_61 * g_vLensDistortionUVScale.x) + 1.0f) * 0.5f;
  _68 = ((_62 * g_vLensDistortionUVScale.y) + 1.0f) * 0.5f;
  _72 = _67 * g_vSourceRes.x;
  _73 = _68 * g_vSourceRes.y;
  _76 = floor(_72 + -0.5f);
  _77 = floor(_73 + -0.5f);
  _78 = _76 + 0.5f;
  _79 = _77 + 0.5f;
  _80 = _72 - _78;
  _81 = _73 - _79;
  _82 = _80 * 0.5f;
  _83 = _81 * 0.5f;
  _90 = (((1.0f - _82) * _80) + -0.5f) * _80;
  _91 = (((1.0f - _83) * _81) + -0.5f) * _81;
  _92 = _80 * _80;
  _93 = _81 * _81;
  _94 = _80 * 1.5f;
  _95 = _81 * 1.5f;
  _108 = (((2.0f - _94) * _80) + 0.5f) * _80;
  _109 = (((2.0f - _95) * _81) + 0.5f) * _81;
  _112 = (_82 + -0.5f) * _92;
  _113 = (_83 + -0.5f) * _93;
  _114 = (((_94 + -2.5f) * _92) + 1.0f) + _108;
  _115 = (((_95 + -2.5f) * _93) + 1.0f) + _109;
  _124 = (_76 + -0.5f) / g_vSourceRes.x;
  _125 = (_77 + -0.5f) / g_vSourceRes.y;
  _126 = (_76 + 2.5f) / g_vSourceRes.x;
  _127 = (_77 + 2.5f) / g_vSourceRes.y;
  _128 = ((_108 / _114) + _78) / g_vSourceRes.x;
  _129 = ((_109 / _115) + _79) / g_vSourceRes.y;
  _130 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_124, _125), 0.0f);
  _137 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_128, _125), 0.0f);
  _147 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_126, _125), 0.0f);
  _160 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_124, _129), 0.0f);
  _167 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_128, _129), 0.0f);
  _174 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_126, _129), 0.0f);
  _181 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_124, _127), 0.0f);
  _188 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_128, _127), 0.0f);
  _195 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_126, _127), 0.0f);
  _226 = g_tSource.GatherRed(g_sLinearClamp_internal, float2(_67, _68));
  _231 = g_tSource.GatherGreen(g_sLinearClamp_internal, float2(_67, _68));
  _236 = g_tSource.GatherBlue(g_sLinearClamp_internal, float2(_67, _68));
  _262 = min(max(((((((_167.x * _114) + (_160.x * _90)) + (_174.x * _112)) * _115) + ((((_137.x * _114) + (_130.x * _90)) + (_147.x * _112)) * _91)) + ((((_188.x * _114) + (_181.x * _90)) + (_195.x * _112)) * _113)), min(min(_226.x, _226.y), min(_226.z, _226.w))), max(max(_226.x, _226.y), max(_226.z, _226.w)));
  _263 = min(max(((((((_167.y * _114) + (_160.y * _90)) + (_174.y * _112)) * _115) + ((((_137.y * _114) + (_130.y * _90)) + (_147.y * _112)) * _91)) + ((((_188.y * _114) + (_181.y * _90)) + (_195.y * _112)) * _113)), min(min(_231.x, _231.y), min(_231.z, _231.w))), max(max(_231.x, _231.y), max(_231.z, _231.w)));
  _264 = min(max(((((((_167.z * _114) + (_160.z * _90)) + (_174.z * _112)) * _115) + ((((_137.z * _114) + (_130.z * _90)) + (_147.z * _112)) * _91)) + ((((_188.z * _114) + (_181.z * _90)) + (_195.z * _112)) * _113)), min(min(_236.x, _236.y), min(_236.z, _236.w))), max(max(_236.x, _236.y), max(_236.z, _236.w)));
  _267 = (g_bPostProcessApplyTonemap != 0);
  _269 = (g_bPostProcessApplyColorGrade != 0);
  if (!(g_bPostProcessApplyTonemap == 0)) {
    _278 = g_fPaperWhite;
  } else {
    _278 = 1.0f;
  }
  if (_269) {
    _298 = max(_262, 0.0f);
    _299 = max(_263, 0.0f);
    _300 = max(_264, 0.0f);
  } else {
    _298 = _262;
    _299 = _263;
    _300 = _264;
  }
  _302 = g_bBrightness[1];
  _306 = exp2(g_fExposureCompensationInEV100) * _302;
  _307 = _306 * _298;
  _308 = _306 * _299;
  _309 = _306 * _300;
  if (!(g_bApplyVignette == 0)) {
    _318 = ((((g_vOverriddenAspectRatioUVScale.x * _19) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _319 = (((g_vOverriddenAspectRatioUVScale.y * _20) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _333 = saturate(exp2(log2(saturate(1.0f - sqrt((_318 * _318) + (_319 * _319))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _338 = (_333 * _307);
    _339 = (_333 * _308);
    _340 = (_333 * _309);
  } else {
    _338 = _307;
    _339 = _308;
    _340 = _309;
  }
  _343 = (g_bEnableHDRLUT == 0);
  if (!(_343 || (!_269))) {
  #if 1
    float3 graded_color = ApplyVanillaPQLUT(
      float3(_338, _339, _340), g_tBaseColorCorrectionMap, g_sLinearClamp_internal, g_fTonemapSaturation);
    _426 = graded_color.x;
    _427 = graded_color.y;
    _428 = graded_color.z;
  #else
    _359 = exp2(log2(saturate(_338 * 0.00800000037997961f)) * 0.1593017578125f);
    _360 = exp2(log2(saturate(_339 * 0.00800000037997961f)) * 0.1593017578125f);
    _361 = exp2(log2(saturate(_340 * 0.00800000037997961f)) * 0.1593017578125f);
    _389 = (exp2(log2(((_360 * 18.8515625f) + 0.8359375f) / ((_360 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
    _391 = max((exp2(log2(((_361 * 18.8515625f) + 0.8359375f) / ((_361 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
    _392 = floor(_391);
    _393 = _391 - _392;
    _395 = (((exp2(log2(((_359 * 18.8515625f) + 0.8359375f) / ((_359 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _392) * 0.02083333395421505f;
    _397 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_395, _389), 0.0f);
    _401 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_395 + 0.02083333395421505f), _389), 0.0f);
    _411 = ((_401.x - _397.x) * _393) + _397.x;
    _412 = ((_401.y - _397.y) * _393) + _397.y;
    _413 = ((_401.z - _397.z) * _393) + _397.z;
    _415 = dot(float3(_411, _412, _413), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _426 = (lerp(_415, _411, g_fTonemapSaturation));
    _427 = (lerp(_415, _412, g_fTonemapSaturation));
    _428 = (lerp(_415, _413, g_fTonemapSaturation));
  #endif
  } else {
    _426 = _338;
    _427 = _339;
    _428 = _340;
  }
  if (_267) {
    do {
      _1050 = _426;
      _1051 = _427;
      _1052 = _428;
      if (!(g_iTonemapper == 0)) {
        _434 = max(_426, 0.0f);
        _435 = max(_427, 0.0f);
        _436 = max(_428, 0.0f);
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _434, _435, _436, _278,
              g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes);
          _1050 = agx_color.x;
          _1051 = agx_color.y;
          _1052 = agx_color.z;
#else
          _483 = g_fAgxMaxEV - g_fAgxMinEV;
          _487 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _436, mad(g_vAgxInsetRow0.y, _435, (g_vAgxInsetRow0.x * _434))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _483);
          _488 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _436, mad(g_vAgxInsetRow1.y, _435, (g_vAgxInsetRow1.x * _434))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _483);
          _489 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _436, mad(g_vAgxInsetRow2.y, _435, (g_vAgxInsetRow2.x * _434))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _483);
          _498 = (g_fAgxContrastSlope * (_487 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _499 = 1.0f / g_fAgxShoulderPower;
          _516 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _518 = _516 * (0.6060606241226196f - _487);
          _519 = 1.0f / g_fAgxToePower;
          _538 = -0.0f - g_fAgxToePrecalcConstant;
          _541 = select((_487 >= 0.6060606241226196f), ((_498 / exp2(log2((float((int)(((int)(uint)((int)(_498 > 0.0f))) - ((int)(uint)((int)(_498 < 0.0f))))) * exp2(log2(abs(_498)) * g_fAgxShoulderPower)) + 1.0f) * _499)) * g_fAgxShoulderPrecalcConstant), ((_518 / exp2(log2((float((int)(((int)(uint)((int)(_518 > 0.0f))) - ((int)(uint)((int)(_518 < 0.0f))))) * exp2(log2(abs(_518)) * g_fAgxToePower)) + 1.0f) * _519)) * _538)) + 0.4894371032714844f;
          _544 = (g_fAgxContrastSlope * (_488 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _562 = _516 * (0.6060606241226196f - _488);
          _583 = select((_488 >= 0.6060606241226196f), ((_544 / exp2(log2((float((int)(((int)(uint)((int)(_544 > 0.0f))) - ((int)(uint)((int)(_544 < 0.0f))))) * exp2(log2(abs(_544)) * g_fAgxShoulderPower)) + 1.0f) * _499)) * g_fAgxShoulderPrecalcConstant), ((_562 / exp2(log2((exp2(log2(abs(_562)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_562 > 0.0f))) - ((int)(uint)((int)(_562 < 0.0f)))))) + 1.0f) * _519)) * _538)) + 0.4894371032714844f;
          _586 = (g_fAgxContrastSlope * (_489 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _604 = _516 * (0.6060606241226196f - _489);
          _625 = select((_489 >= 0.6060606241226196f), ((_586 / exp2(log2((float((int)(((int)(uint)((int)(_586 > 0.0f))) - ((int)(uint)((int)(_586 < 0.0f))))) * exp2(log2(abs(_586)) * g_fAgxShoulderPower)) + 1.0f) * _499)) * g_fAgxShoulderPrecalcConstant), ((_604 / exp2(log2((exp2(log2(abs(_604)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_604 > 0.0f))) - ((int)(uint)((int)(_604 < 0.0f)))))) + 1.0f) * _519)) * _538)) + 0.4894371032714844f;
          _644 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _625, mad(g_vAgxOutsetRow0.y, _583, (_541 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _645 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _625, mad(g_vAgxOutsetRow1.y, _583, (_541 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _646 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _625, mad(g_vAgxOutsetRow2.y, _583, (_541 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _830 = _644;
            _831 = _645;
            _832 = _646;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_644, max(_645, _646)) >= g_fAgxHDRMidGrey))) {
                _657 = log2(1.0f / g_fAgxHDRMidGrey);
                _658 = _657 + 20.0f;
                _671 = min(max(log2(max(_644, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _657);
                _672 = min(max(log2(max(_645, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _657);
                _673 = min(max(log2(max(_646, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _657);
                _680 = 20.0f / _658;
                _683 = (20.0f - log2(g_fAgxHDRRatio)) / _658;
                _688 = ((_671 / _658) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _703 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                _706 = ((-0.0f - _671) / _658) * _703;
                _725 = -0.0f - g_fAgxHDRToePrecalcConstant;
                _731 = ((_672 / _658) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _748 = ((-0.0f - _672) / _658) * _703;
                _772 = ((_673 / _658) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _789 = ((-0.0f - _673) / _658) * _703;
                _830 = (saturate(exp2(((select((((_671 + 20.0f) / _658) >= _680), ((_688 / exp2(log2((float((int)(((int)(uint)((int)(_688 > 0.0f))) - ((int)(uint)((int)(_688 < 0.0f))))) * exp2(log2(abs(_688)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_706 / exp2(log2((float((int)(((int)(uint)((int)(_706 > 0.0f))) - ((int)(uint)((int)(_706 < 0.0f))))) * exp2(log2(abs(_706)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _725)) + _683) * _658) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _831 = (saturate(exp2(((select((((_672 + 20.0f) / _658) >= _680), ((_731 / exp2(log2((float((int)(((int)(uint)((int)(_731 > 0.0f))) - ((int)(uint)((int)(_731 < 0.0f))))) * exp2(log2(abs(_731)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_748 / exp2(log2((float((int)(((int)(uint)((int)(_748 > 0.0f))) - ((int)(uint)((int)(_748 < 0.0f))))) * exp2(log2(abs(_748)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _725)) + _683) * _658) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _832 = (saturate(exp2(((select((((_673 + 20.0f) / _658) >= _680), ((_772 / exp2(log2((float((int)(((int)(uint)((int)(_772 > 0.0f))) - ((int)(uint)((int)(_772 < 0.0f))))) * exp2(log2(abs(_772)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_789 / exp2(log2((float((int)(((int)(uint)((int)(_789 > 0.0f))) - ((int)(uint)((int)(_789 < 0.0f))))) * exp2(log2(abs(_789)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _725)) + _683) * _658) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _830 = _644;
                _831 = _645;
                _832 = _646;
              }
            }
            _1050 = (mad(-0.07283977419137955f, _832, mad(-0.5876564383506775f, _831, (_830 * 1.6604962348937988f))) * _278);
            _1051 = (mad(-0.008348013274371624f, _832, mad(1.1328951120376587f, _831, (_830 * -0.1245470941066742f))) * _278);
            _1052 = (mad(1.118751049041748f, _832, mad(-0.10059737414121628f, _831, (_830 * -0.018153680488467216f))) * _278);
          } while (false);
#endif
        } else {
          _846 = dot(float3(_434, _435, _436), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
          do {
            _856 = _434;
            _857 = _435;
            _858 = _436;
            if (!(_846 == 0.0f)) {
              _851 = max(dot(float3(_426, _427, _428), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _846;
              _856 = (_851 * _434);
              _857 = (_851 * _435);
              _858 = (_851 * _436);
            }
            _864 = max(max(_856, max(_857, _858)), 0.0f);
            _866 = 1.0f / max(_864, 1.1754943508222875e-38f);
            _872 = (pow(_864, g_vTonemapGTParams.x));
            _880 = _872 / (((pow(_872, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
            _894 = exp2(log2(_866 * _856) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
            _895 = exp2(log2(_866 * _857) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
            _896 = exp2(log2(_866 * _858) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
            _901 = log2(_880);
            _929 = saturate(exp2(log2((exp2(_901 * g_vTonemapCrosstalk.x) * (1.0f - _894)) + _894) * g_vTonemapCrosstalkSaturation.x) * _880);
            _930 = saturate(exp2(log2((exp2(_901 * g_vTonemapCrosstalk.y) * (1.0f - _895)) + _895) * g_vTonemapCrosstalkSaturation.y) * _880);
            _931 = saturate(exp2(log2((exp2(_901 * g_vTonemapCrosstalk.z) * (1.0f - _896)) + _896) * g_vTonemapCrosstalkSaturation.z) * _880);
            if (_343) {
              do {
                _1043 = _929;
                _1044 = _930;
                _1045 = _931;
                if (_269) {
                  do {
                    [branch]
                    if (!(_929 <= 0.0031308000907301903f)) {
                      _944 = (((pow(_929, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _944 = (_929 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_930 <= 0.0031308000907301903f)) {
                        _955 = (((pow(_930, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _955 = (_930 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_931 <= 0.0031308000907301903f)) {
                          _966 = (((pow(_931, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _966 = (_931 * 12.920000076293945f);
                        }
                        _973 = (saturate(_955) * 0.96875f) + 0.015625f;
                        _975 = max((saturate(_966) * 31.0f), 0.0f);
                        _976 = floor(_975);
                        _977 = _975 - _976;
                        _979 = (((saturate(_944) * 0.96875f) + 0.015625f) + _976) * 0.03125f;
                        _981 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_979, _973), 0.0f);
                        _985 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_979 + 0.03125f), _973), 0.0f);
                        _995 = ((_985.x - _981.x) * _977) + _981.x;
                        _996 = ((_985.y - _981.y) * _977) + _981.y;
                        _997 = ((_985.z - _981.z) * _977) + _981.z;
                        do {
                          [branch]
                          if (!(_995 <= 0.040449999272823334f)) {
                            _1008 = exp2(log2((_995 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _1008 = (_995 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_996 <= 0.040449999272823334f)) {
                              _1019 = exp2(log2((_996 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _1019 = (_996 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_997 <= 0.040449999272823334f)) {
                                _1030 = exp2(log2((_997 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _1030 = (_997 * 0.07739938050508499f);
                              }
                              _1032 = dot(float3(_1008, _1019, _1030), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _1043 = (lerp(_1032, _1008, g_fTonemapSaturation));
                              _1044 = (lerp(_1032, _1019, g_fTonemapSaturation));
                              _1045 = (lerp(_1032, _1030, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1050 = (_1043 * _278);
                _1051 = (_1044 * _278);
                _1052 = (_1045 * _278);
              } while (false);
            } else {
              _1050 = _929;
              _1051 = _930;
              _1052 = _931;
            }
          } while (false);
        }
      }
      _1061 = (_1050 * g_fTonemapBrightness);
      _1062 = (_1051 * g_fTonemapBrightness);
      _1063 = (_1052 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1061 = (_426 * _278);
    _1062 = (_427 * _278);
    _1063 = (_428 * _278);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1075 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1082 = (_1075.x * 2.0f) + -1.0f;
    _1083 = (_1075.y * 2.0f) + -1.0f;
    _1084 = (_1075.z * 2.0f) + -1.0f;
    if (!(_267)) {
      _1087 = _1061 / _278;
      _1088 = _1062 / _278;
      _1089 = _1063 / _278;
      _1093 = 1.0f - sqrt(max(dot(float3(_1087, _1088, _1089), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
      _1098 = g_fFilmGrainIntensity * (_278 * 5.0f);
      _1161 = ((((_1098 * _1082) * saturate(_1087)) * _1093) + _1061);
      _1162 = ((((_1098 * _1083) * _1093) * saturate(_1088)) + _1062);
      _1163 = ((((_1098 * _1084) * _1093) * saturate(_1089)) + _1063);
    } else {
      _1112 = saturate(_1061);
      _1113 = saturate(_1062);
      _1114 = saturate(_1063);
      _1119 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_1112, max(_1113, _1114))));
      _1120 = _1119 * _1112;
      _1121 = _1119 * _1113;
      _1122 = _1119 * _1114;
      _1130 = ((1.0f - sqrt(dot(float3(_1120, _1121, _1122), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
      _1137 = ((_1130 * _1082) * min(1.0f, _1120)) + _1120;
      _1138 = ((_1130 * _1083) * min(1.0f, _1121)) + _1121;
      _1139 = ((_1130 * _1084) * min(1.0f, _1122)) + _1122;
      _1143 = 1.0f / (max(_1137, max(_1138, _1139)) + 1.0f);
      _1150 = 1.0f / (max(_1120, max(_1121, _1122)) + 1.0f);
      _1161 = (((_1137 * _1143) + _1061) - (_1150 * _1120));
      _1162 = (((_1138 * _1143) + _1062) - (_1150 * _1121));
      _1163 = (((_1139 * _1143) + _1063) - (_1150 * _1122));
    }
  } else {
    _1161 = _1061;
    _1162 = _1062;
    _1163 = _1063;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1170 = (g_bHDR == 0);
    do {
      _1197 = _1161;
      _1198 = _1162;
      _1199 = _1163;
      if (!(_1170 || (g_bHDR_scRGB == 0))) {
        _1184 = max(mad(0.043306104838848114f, _1163, mad(0.329291969537735f, _1162, (_1161 * 0.6274019479751587f))), 0.0f);
        _1185 = max(mad(0.0113602289929986f, _1163, mad(0.9195442795753479f, _1162, (_1161 * 0.06909549236297607f))), 0.0f);
        _1186 = max(mad(0.895578145980835f, _1163, mad(0.08802816271781921f, _1162, (_1161 * 0.016393709927797318f))), 0.0f);
        _1197 = mad(-0.07283977419137955f, _1186, mad(-0.5876564383506775f, _1185, (_1184 * 1.6604962348937988f)));
        _1198 = mad(-0.008348013274371624f, _1186, mad(1.1328951120376587f, _1185, (_1184 * -0.1245470941066742f)));
        _1199 = mad(1.118751049041748f, _1186, mad(-0.10059737414121628f, _1185, (_1184 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1170)) {
        _1215 = mad(0.043306104838848114f, _1199, mad(0.329291969537735f, _1198, (_1197 * 0.6274019479751587f)));
        _1216 = mad(0.0113602289929986f, _1199, mad(0.9195442795753479f, _1198, (_1197 * 0.06909549236297607f)));
        _1217 = mad(0.895578145980835f, _1199, mad(0.08802816271781921f, _1198, (_1197 * 0.016393709927797318f)));
      } else {
        _1215 = _1197;
        _1216 = _1198;
        _1217 = _1199;
      }
    } while (false);
  } else {
    _1215 = _1161;
    _1216 = _1162;
    _1217 = _1163;
  }
  SV_Target.x = _1215;
  SV_Target.y = _1216;
  SV_Target.z = _1217;
  SV_Target.w = 1.0f;
  return SV_Target;
}