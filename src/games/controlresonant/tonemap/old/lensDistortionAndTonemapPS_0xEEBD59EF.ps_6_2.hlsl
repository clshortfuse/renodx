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
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float _19;
  float _20;
  float _30;
  float _31;
  float _61;
  float _62;
  float _277;
  float _297;
  float _298;
  float _299;
  float _337;
  float _338;
  float _339;
  float _425;
  float _426;
  float _427;
  float _829;
  float _830;
  float _831;
  float _859;
  float _860;
  float _861;
  float _946;
  float _957;
  float _968;
  float _1010;
  float _1021;
  float _1032;
  float _1045;
  float _1046;
  float _1047;
  float _1206;
  float _1207;
  float _1208;
  float _1217;
  float _1218;
  float _1219;
  float _1267;
  float _1268;
  float _1269;
  float _1303;
  float _1304;
  float _1305;
  float _1321;
  float _1322;
  float _1323;
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
  float _301;
  float _305;
  float _306;
  float _307;
  float _308;
  float _317;
  float _318;
  float _332;
  bool _342;
  float _358;
  float _359;
  float _360;
  float _388;
  float _390;
  float _391;
  float _392;
  float _394;
  float4 _396;
  float4 _400;
  float _410;
  float _411;
  float _412;
  float _414;
  float _458;
  float _459;
  float _460;
  float _482;
  float _486;
  float _487;
  float _488;
  float _497;
  float _498;
  float _515;
  float _517;
  float _518;
  float _537;
  float _540;
  float _543;
  float _561;
  float _582;
  float _585;
  float _603;
  float _624;
  float _643;
  float _644;
  float _645;
  float _656;
  float _657;
  float _670;
  float _671;
  float _672;
  float _679;
  float _682;
  float _687;
  float _702;
  float _705;
  float _724;
  float _730;
  float _747;
  float _771;
  float _788;
  float _846;
  float _847;
  float _848;
  float _849;
  float _854;
  float _867;
  float _869;
  float _875;
  float _883;
  float _897;
  float _898;
  float _899;
  float _904;
  float _932;
  float _933;
  float _934;
  float _975;
  float _977;
  float _978;
  float _979;
  float _981;
  float4 _983;
  float4 _987;
  float _997;
  float _998;
  float _999;
  float _1034;
  float _1056;
  float _1061;
  float _1063;
  float _1064;
  float _1065;
  float _1066;
  float _1076;
  float _1080;
  float _1129;
  float _1130;
  float _1131;
  float _1136;
  float _1149;
  float _1150;
  float _1151;
  float _1183;
  float _1185;
  float _1187;
  float _1188;
  float _1201;
  float4 _1231;
  float _1241;
  float _1242;
  float _1243;
  float _1247;
  float _1253;
  bool _1276;
  float _1290;
  float _1291;
  float _1292;
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
  _267 = (g_bPostProcessApplyTonemap == 0);
  _269 = (g_bPostProcessApplyColorGrade != 0);
  if (!(_267)) {
    _277 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  } else {
    _277 = 1.0f;
  }
  if (_269) {
    _297 = max(_262, 0.0f);
    _298 = max(_263, 0.0f);
    _299 = max(_264, 0.0f);
  } else {
    _297 = _262;
    _298 = _263;
    _299 = _264;
  }
  _301 = g_bBrightness[1];
  _305 = exp2(g_fExposureCompensationInEV100) * _301;
  _306 = _305 * _297;
  _307 = _305 * _298;
  _308 = _305 * _299;
  if (!(g_bApplyVignette == 0)) {
    _317 = ((((g_vOverriddenAspectRatioUVScale.x * _19) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _318 = (((g_vOverriddenAspectRatioUVScale.y * _20) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _332 = saturate(exp2(log2(saturate(1.0f - sqrt((_317 * _317) + (_318 * _318))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _337 = (_332 * _306);
    _338 = (_332 * _307);
    _339 = (_332 * _308);
  } else {
    _337 = _306;
    _338 = _307;
    _339 = _308;
  }
  _342 = (g_bEnableHDRLUT == 0);
  if (!(_342 || (!_269))) {
    _358 = exp2(log2(saturate(_337 * 0.00800000037997961f)) * 0.1593017578125f);
    _359 = exp2(log2(saturate(_338 * 0.00800000037997961f)) * 0.1593017578125f);
    _360 = exp2(log2(saturate(_339 * 0.00800000037997961f)) * 0.1593017578125f);
    _388 = (exp2(log2(((_359 * 18.8515625f) + 0.8359375f) / ((_359 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
    _390 = max((exp2(log2(((_360 * 18.8515625f) + 0.8359375f) / ((_360 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
    _391 = floor(_390);
    _392 = _390 - _391;
    _394 = (((exp2(log2(((_358 * 18.8515625f) + 0.8359375f) / ((_358 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _391) * 0.02083333395421505f;
    _396 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_394, _388), 0.0f);
    _400 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_394 + 0.02083333395421505f), _388), 0.0f);
    _410 = ((_400.x - _396.x) * _392) + _396.x;
    _411 = ((_400.y - _396.y) * _392) + _396.y;
    _412 = ((_400.z - _396.z) * _392) + _396.z;
    _414 = dot(float3(_410, _411, _412), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _425 = (lerp(_414, _410, g_fTonemapSaturation));
    _426 = (lerp(_414, _411, g_fTonemapSaturation));
    _427 = (lerp(_414, _412, g_fTonemapSaturation));
  } else {
    _425 = _337;
    _426 = _338;
    _427 = _339;
  }
  if (!(_267)) {
    do {
      _1206 = _425;
      _1207 = _426;
      _1208 = _427;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _425, _426, _427, _277,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes);
          _1206 = agx_color.x;
          _1207 = agx_color.y;
          _1208 = agx_color.z;
#else
          _458 = max(_425, 0.0f);
          _459 = max(_426, 0.0f);
          _460 = max(_427, 0.0f);
          _482 = g_fAgxMaxEV - g_fAgxMinEV;
          _486 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _460, mad(g_vAgxInsetRow0.y, _459, (_458 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _482);
          _487 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _460, mad(g_vAgxInsetRow1.y, _459, (_458 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _482);
          _488 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _460, mad(g_vAgxInsetRow2.y, _459, (_458 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _482);
          _497 = (g_fAgxContrastSlope * (_486 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _498 = 1.0f / g_fAgxShoulderPower;
          _515 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _517 = _515 * (0.6060606241226196f - _486);
          _518 = 1.0f / g_fAgxToePower;
          _537 = -0.0f - g_fAgxToePrecalcConstant;
          _540 = select((_486 >= 0.6060606241226196f), ((_497 / exp2(log2((float((int)(((int)(uint)((int)(_497 > 0.0f))) - ((int)(uint)((int)(_497 < 0.0f))))) * exp2(log2(abs(_497)) * g_fAgxShoulderPower)) + 1.0f) * _498)) * g_fAgxShoulderPrecalcConstant), ((_517 / exp2(log2((float((int)(((int)(uint)((int)(_517 > 0.0f))) - ((int)(uint)((int)(_517 < 0.0f))))) * exp2(log2(abs(_517)) * g_fAgxToePower)) + 1.0f) * _518)) * _537)) + 0.4894371032714844f;
          _543 = (g_fAgxContrastSlope * (_487 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _561 = _515 * (0.6060606241226196f - _487);
          _582 = select((_487 >= 0.6060606241226196f), ((_543 / exp2(log2((float((int)(((int)(uint)((int)(_543 > 0.0f))) - ((int)(uint)((int)(_543 < 0.0f))))) * exp2(log2(abs(_543)) * g_fAgxShoulderPower)) + 1.0f) * _498)) * g_fAgxShoulderPrecalcConstant), ((_561 / exp2(log2((exp2(log2(abs(_561)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_561 > 0.0f))) - ((int)(uint)((int)(_561 < 0.0f)))))) + 1.0f) * _518)) * _537)) + 0.4894371032714844f;
          _585 = (g_fAgxContrastSlope * (_488 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _603 = _515 * (0.6060606241226196f - _488);
          _624 = select((_488 >= 0.6060606241226196f), ((_585 / exp2(log2((float((int)(((int)(uint)((int)(_585 > 0.0f))) - ((int)(uint)((int)(_585 < 0.0f))))) * exp2(log2(abs(_585)) * g_fAgxShoulderPower)) + 1.0f) * _498)) * g_fAgxShoulderPrecalcConstant), ((_603 / exp2(log2((exp2(log2(abs(_603)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_603 > 0.0f))) - ((int)(uint)((int)(_603 < 0.0f)))))) + 1.0f) * _518)) * _537)) + 0.4894371032714844f;
          _643 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _624, mad(g_vAgxOutsetRow0.y, _582, (_540 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _644 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _624, mad(g_vAgxOutsetRow1.y, _582, (_540 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _645 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _624, mad(g_vAgxOutsetRow2.y, _582, (_540 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _829 = _643;
            _830 = _644;
            _831 = _645;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_643, max(_644, _645)) >= g_fAgxHDRMidGrey))) {
                _656 = log2(1.0f / g_fAgxHDRMidGrey);
                _657 = _656 + 20.0f;
                _670 = min(max(log2(max(_643, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _656);
                _671 = min(max(log2(max(_644, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _656);
                _672 = min(max(log2(max(_645, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _656);
                _679 = 20.0f / _657;
                _682 = (20.0f - log2(g_fAgxHDRRatio)) / _657;
                _687 = ((_670 / _657) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _702 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                _705 = ((-0.0f - _670) / _657) * _702;
                _724 = -0.0f - g_fAgxHDRToePrecalcConstant;
                _730 = ((_671 / _657) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _747 = ((-0.0f - _671) / _657) * _702;
                _771 = ((_672 / _657) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _788 = ((-0.0f - _672) / _657) * _702;
                _829 = (saturate(exp2(((select((((_670 + 20.0f) / _657) >= _679), ((_687 / exp2(log2((float((int)(((int)(uint)((int)(_687 > 0.0f))) - ((int)(uint)((int)(_687 < 0.0f))))) * exp2(log2(abs(_687)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_705 / exp2(log2((float((int)(((int)(uint)((int)(_705 > 0.0f))) - ((int)(uint)((int)(_705 < 0.0f))))) * exp2(log2(abs(_705)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _724)) + _682) * _657) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _830 = (saturate(exp2(((select((((_671 + 20.0f) / _657) >= _679), ((_730 / exp2(log2((float((int)(((int)(uint)((int)(_730 > 0.0f))) - ((int)(uint)((int)(_730 < 0.0f))))) * exp2(log2(abs(_730)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_747 / exp2(log2((float((int)(((int)(uint)((int)(_747 > 0.0f))) - ((int)(uint)((int)(_747 < 0.0f))))) * exp2(log2(abs(_747)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _724)) + _682) * _657) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _831 = (saturate(exp2(((select((((_672 + 20.0f) / _657) >= _679), ((_771 / exp2(log2((float((int)(((int)(uint)((int)(_771 > 0.0f))) - ((int)(uint)((int)(_771 < 0.0f))))) * exp2(log2(abs(_771)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_788 / exp2(log2((float((int)(((int)(uint)((int)(_788 > 0.0f))) - ((int)(uint)((int)(_788 < 0.0f))))) * exp2(log2(abs(_788)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _724)) + _682) * _657) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _829 = _643;
                _830 = _644;
                _831 = _645;
              }
            }
            _1206 = (mad(-0.07283977419137955f, _831, mad(-0.5876564383506775f, _830, (_829 * 1.6604962348937988f))) * _277);
            _1207 = (mad(-0.008348013274371624f, _831, mad(1.1328951120376587f, _830, (_829 * -0.1245470941066742f))) * _277);
            _1208 = (mad(1.118751049041748f, _831, mad(-0.10059737414121628f, _830, (_829 * -0.018153680488467216f))) * _277);
          } while (false);
#endif
        } else {
          if (_342) {
            _846 = max(_425, 0.0f);
            _847 = max(_426, 0.0f);
            _848 = max(_427, 0.0f);
            _849 = dot(float3(_846, _847, _848), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            do {
              _859 = _846;
              _860 = _847;
              _861 = _848;
              if (!(_849 == 0.0f)) {
                _854 = max(dot(float3(_425, _426, _427), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _849;
                _859 = (_854 * _846);
                _860 = (_854 * _847);
                _861 = (_854 * _848);
              }
              _867 = max(max(_859, max(_860, _861)), 0.0f);
              _869 = 1.0f / max(_867, 1.1754943508222875e-38f);
              _875 = (pow(_867, g_vTonemapGTParams.x));
              _883 = _875 / (((pow(_875, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
              _897 = exp2(log2(_869 * _859) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
              _898 = exp2(log2(_869 * _860) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
              _899 = exp2(log2(_869 * _861) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
              _904 = log2(_883);
              _932 = saturate(exp2(log2((exp2(_904 * g_vTonemapCrosstalk.x) * (1.0f - _897)) + _897) * g_vTonemapCrosstalkSaturation.x) * _883);
              _933 = saturate(exp2(log2((exp2(_904 * g_vTonemapCrosstalk.y) * (1.0f - _898)) + _898) * g_vTonemapCrosstalkSaturation.y) * _883);
              _934 = saturate(exp2(log2((exp2(_904 * g_vTonemapCrosstalk.z) * (1.0f - _899)) + _899) * g_vTonemapCrosstalkSaturation.z) * _883);
              do {
                _1045 = _932;
                _1046 = _933;
                _1047 = _934;
                if (_269) {
                  do {
                    [branch]
                    if (!(_932 <= 0.0031308000907301903f)) {
                      _946 = (((pow(_932, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _946 = (_932 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_933 <= 0.0031308000907301903f)) {
                        _957 = (((pow(_933, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _957 = (_933 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_934 <= 0.0031308000907301903f)) {
                          _968 = (((pow(_934, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _968 = (_934 * 12.920000076293945f);
                        }
                        _975 = (saturate(_957) * 0.96875f) + 0.015625f;
                        _977 = max((saturate(_968) * 31.0f), 0.0f);
                        _978 = floor(_977);
                        _979 = _977 - _978;
                        _981 = (((saturate(_946) * 0.96875f) + 0.015625f) + _978) * 0.03125f;
                        _983 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_981, _975), 0.0f);
                        _987 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_981 + 0.03125f), _975), 0.0f);
                        _997 = ((_987.x - _983.x) * _979) + _983.x;
                        _998 = ((_987.y - _983.y) * _979) + _983.y;
                        _999 = ((_987.z - _983.z) * _979) + _983.z;
                        do {
                          [branch]
                          if (!(_997 <= 0.040449999272823334f)) {
                            _1010 = exp2(log2((_997 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _1010 = (_997 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_998 <= 0.040449999272823334f)) {
                              _1021 = exp2(log2((_998 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _1021 = (_998 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_999 <= 0.040449999272823334f)) {
                                _1032 = exp2(log2((_999 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _1032 = (_999 * 0.07739938050508499f);
                              }
                              _1034 = dot(float3(_1010, _1021, _1032), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _1045 = (lerp(_1034, _1010, g_fTonemapSaturation));
                              _1046 = (lerp(_1034, _1021, g_fTonemapSaturation));
                              _1047 = (lerp(_1034, _1032, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1206 = (_1045 * _277);
                _1207 = (_1046 * _277);
                _1208 = (_1047 * _277);
              } while (false);
            } while (false);
          } else {
            _1056 = g_fMaxOutputNits * 0.012500000186264515f;
            _1061 = max(abs(_425), max(abs(_426), abs(_427)));
            _1063 = 1.0f / max(_1061, 1.1754943508222875e-38f);
            _1064 = _1063 * _425;
            _1065 = _1063 * _426;
            _1066 = _1063 * _427;
            _1076 = (_277 * 0.18000000715255737f) * exp2(log2((pow(_1061, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
            _1080 = dot(float3((_1076 * _1064), (_1076 * _1065), (_1076 * _1066)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1129 = exp2(log2(abs(_1064)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_1064 > 0.0f))) - ((int)(uint)((int)(_1064 < 0.0f)))));
            _1130 = exp2(log2(abs(_1065)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_1065 > 0.0f))) - ((int)(uint)((int)(_1065 < 0.0f)))));
            _1131 = exp2(log2(abs(_1066)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_1066 > 0.0f))) - ((int)(uint)((int)(_1066 < 0.0f)))));
            _1136 = log2(saturate(select((_1080 <= 0.0f), _1080, ((1.0f - exp2(log2(exp2((_1080 / _1056) * -1.4426950216293335f)))) * _1056)) / _1056));
            _1149 = (exp2(_1136 * g_vTonemapCrosstalk.x) * (1.0f - _1129)) + _1129;
            _1150 = (exp2(_1136 * g_vTonemapCrosstalk.y) * (1.0f - _1130)) + _1130;
            _1151 = (exp2(_1136 * g_vTonemapCrosstalk.z) * (1.0f - _1131)) + _1131;
            _1183 = (float((int)(((int)(uint)((int)(_1149 > 0.0f))) - ((int)(uint)((int)(_1149 < 0.0f))))) * _1076) * exp2(log2(abs(_1149)) * g_vTonemapCrosstalkSaturation.x);
            _1185 = (float((int)(((int)(uint)((int)(_1150 > 0.0f))) - ((int)(uint)((int)(_1150 < 0.0f))))) * _1076) * exp2(log2(abs(_1150)) * g_vTonemapCrosstalkSaturation.y);
            _1187 = (float((int)(((int)(uint)((int)(_1151 > 0.0f))) - ((int)(uint)((int)(_1151 < 0.0f))))) * _1076) * exp2(log2(abs(_1151)) * g_vTonemapCrosstalkSaturation.z);
            _1188 = dot(float3(_1183, _1185, _1187), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1201 = select((_1188 <= 0.0f), _1188, ((1.0f - exp2(log2(exp2((_1188 / _1056) * -1.4426950216293335f)))) * _1056)) * select((!(_1188 == 0.0f)), (1.0f / _1188), 0.0f);
            _1206 = (_1201 * _1183);
            _1207 = (_1201 * _1185);
            _1208 = (_1201 * _1187);
          }
        }
      }
      _1217 = (_1206 * g_fTonemapBrightness);
      _1218 = (_1207 * g_fTonemapBrightness);
      _1219 = (_1208 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1217 = (_425 * _277);
    _1218 = (_426 * _277);
    _1219 = (_427 * _277);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1231 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1241 = _1217 / _277;
    _1242 = _1218 / _277;
    _1243 = _1219 / _277;
    _1247 = 1.0f - sqrt(max(dot(float3(_1241, _1242, _1243), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
    _1253 = g_fFilmGrainIntensity * (_277 * 5.0f);
    _1267 = ((((_1253 * ((_1231.x * 2.0f) + -1.0f)) * saturate(_1241)) * _1247) + _1217);
    _1268 = ((((_1253 * ((_1231.y * 2.0f) + -1.0f)) * _1247) * saturate(_1242)) + _1218);
    _1269 = ((((_1253 * ((_1231.z * 2.0f) + -1.0f)) * _1247) * saturate(_1243)) + _1219);
  } else {
    _1267 = _1217;
    _1268 = _1218;
    _1269 = _1219;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1276 = (g_bHDR == 0);
    do {
      _1303 = _1267;
      _1304 = _1268;
      _1305 = _1269;
      if (!(_1276 || (g_bHDR_scRGB == 0))) {
        _1290 = max(mad(0.043306104838848114f, _1269, mad(0.329291969537735f, _1268, (_1267 * 0.6274019479751587f))), 0.0f);
        _1291 = max(mad(0.0113602289929986f, _1269, mad(0.9195442795753479f, _1268, (_1267 * 0.06909549236297607f))), 0.0f);
        _1292 = max(mad(0.895578145980835f, _1269, mad(0.08802816271781921f, _1268, (_1267 * 0.016393709927797318f))), 0.0f);
        _1303 = mad(-0.07283977419137955f, _1292, mad(-0.5876564383506775f, _1291, (_1290 * 1.6604962348937988f)));
        _1304 = mad(-0.008348013274371624f, _1292, mad(1.1328951120376587f, _1291, (_1290 * -0.1245470941066742f)));
        _1305 = mad(1.118751049041748f, _1292, mad(-0.10059737414121628f, _1291, (_1290 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1276)) {
        _1321 = mad(0.043306104838848114f, _1305, mad(0.329291969537735f, _1304, (_1303 * 0.6274019479751587f)));
        _1322 = mad(0.0113602289929986f, _1305, mad(0.9195442795753479f, _1304, (_1303 * 0.06909549236297607f)));
        _1323 = mad(0.895578145980835f, _1305, mad(0.08802816271781921f, _1304, (_1303 * 0.016393709927797318f)));
      } else {
        _1321 = _1303;
        _1322 = _1304;
        _1323 = _1305;
      }
    } while (false);
  } else {
    _1321 = _1267;
    _1322 = _1268;
    _1323 = _1269;
  }
  SV_Target.x = _1321;
  SV_Target.y = _1322;
  SV_Target.z = _1323;
  SV_Target.w = 1.0f;
  return SV_Target;
}
