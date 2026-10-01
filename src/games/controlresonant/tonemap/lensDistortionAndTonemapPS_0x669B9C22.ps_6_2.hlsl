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
  float _278;
  float _298;
  float _299;
  float _300;
  float _338;
  float _339;
  float _340;
  float _560;
  float _561;
  float _562;
  float _898;
  float _899;
  float _900;
  float _924;
  float _925;
  float _926;
  float _1012;
  float _1023;
  float _1034;
  float _1076;
  float _1087;
  float _1098;
  float _1111;
  float _1112;
  float _1113;
  float _1118;
  float _1119;
  float _1120;
  float _1129;
  float _1130;
  float _1131;
  float _1229;
  float _1230;
  float _1231;
  float _1265;
  float _1266;
  float _1267;
  float _1283;
  float _1284;
  float _1285;
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
  float _390;
  float _391;
  int _395;
  int _396;
  int _397;
  float _401;
  float _402;
  float _403;
  int _408;
  int _413;
  int _418;
  bool _419;
  bool _420;
  bool _421;
  float4 _439;
  float4 _454;
  float4 _469;
  float4 _484;
  float _491;
  float _498;
  float _502;
  float _503;
  float _507;
  float _511;
  float _520;
  float _523;
  float _526;
  float _528;
  float _530;
  float _532;
  float _536;
  float _537;
  float _538;
  float _541;
  float _544;
  float _547;
  float _549;
  float _568;
  float _569;
  float _570;
  float _617;
  float _621;
  float _622;
  float _623;
  float _632;
  float _633;
  float _650;
  float _652;
  float _653;
  float _672;
  float _675;
  float _678;
  float _696;
  float _717;
  float _720;
  float _738;
  float _759;
  float _778;
  float _779;
  float _780;
  float _791;
  float _792;
  float _793;
  float _812;
  float _813;
  float _814;
  float _815;
  float _819;
  float _824;
  float _841;
  float _863;
  float _869;
  float _914;
  float _919;
  float _932;
  float _934;
  float _940;
  float _948;
  float _962;
  float _963;
  float _964;
  float _969;
  float _997;
  float _998;
  float _999;
  float _1041;
  float _1043;
  float _1044;
  float _1045;
  float _1047;
  float4 _1049;
  float4 _1053;
  float _1063;
  float _1064;
  float _1065;
  float _1100;
  float4 _1143;
  float _1150;
  float _1151;
  float _1152;
  float _1155;
  float _1156;
  float _1157;
  float _1161;
  float _1166;
  float _1180;
  float _1181;
  float _1182;
  float _1187;
  float _1188;
  float _1189;
  float _1190;
  float _1198;
  float _1205;
  float _1206;
  float _1207;
  float _1211;
  float _1218;
  bool _1238;
  float _1252;
  float _1253;
  float _1254;
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
    _278 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
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
    _359 = exp2(log2(saturate(_338 * 0.00800000037997961f)) * 0.1593017578125f);
    _360 = exp2(log2(saturate(_339 * 0.00800000037997961f)) * 0.1593017578125f);
    _361 = exp2(log2(saturate(_340 * 0.00800000037997961f)) * 0.1593017578125f);
    _389 = saturate(exp2(log2(((_359 * 18.8515625f) + 0.8359375f) / ((_359 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _390 = saturate(exp2(log2(((_360 * 18.8515625f) + 0.8359375f) / ((_360 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _391 = saturate(exp2(log2(((_361 * 18.8515625f) + 0.8359375f) / ((_361 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _395 = int(floor(_389));
    _396 = int(floor(_390));
    _397 = int(floor(_391));
    _401 = _389 - float((int)(_395));
    _402 = _390 - float((int)(_396));
    _403 = _391 - float((int)(_397));
    _408 = ((int)(uint)((int)(_403 > _401))) + ((int)(uint)((int)(_402 > _401)));
    _413 = ((int)(uint)((int)(_403 > _402))) + ((int)(uint)((int)(_401 >= _402)));
    _418 = ((int)(uint)((int)(_401 >= _403))) + ((int)(uint)((int)(_402 >= _403)));
    _419 = (_408 == 0);
    _420 = (_413 == 0);
    _421 = (_418 == 0);
    _439 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_397), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_395), (int)(0))), (int)(47))), min((int)(max((int)(_396), (int)(0))), (int)(47)), 0));
    _454 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_421))) + _397))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_419))) + _395))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_420))) + _396))), (int)(0))), (int)(47)), 0));
    _469 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_418 < (uint)2)))) + _397))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_408 < (uint)2)))) + _395))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_413 < (uint)2)))) + _396))), (int)(0))), (int)(47)), 0));
    _484 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_397 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_395 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_396 + 1u))), (int)(0))), (int)(47)), 0));
    _491 = dot(float3(_401, _402, _403), float3(((float)((bool)_419)), ((float)((bool)_420)), ((float)((bool)_421))));
    _498 = dot(float3(_401, _402, _403), float3(((float)((bool)(uint)(_408 == 2))), ((float)((bool)(uint)(_413 == 2))), ((float)((bool)(uint)(_418 == 2)))));
    _502 = (((_402 + _401) + _403) - _491) - _498;
    _503 = 1.0f - _491;
    _507 = _491 - _502;
    _511 = _502 - _498;
    _520 = (((_498 * _484.x) + (_503 * _439.x)) + (_507 * _454.x)) + (_511 * _469.x);
    _523 = (((_498 * _484.y) + (_503 * _439.y)) + (_507 * _454.y)) + (_511 * _469.y);
    _526 = (((_498 * _484.z) + (_503 * _439.z)) + (_507 * _454.z)) + (_511 * _469.z);
    _528 = mad(0.21580375730991364f, _526, mad(0.3963377773761749f, _523, _520));
    _530 = mad(-0.0638541728258133f, _526, mad(-0.10556134581565857f, _523, _520));
    _532 = mad(-1.2914855480194092f, _526, mad(-0.08948417752981186f, _523, _520));
    _536 = (_528 * _528) * _528;
    _537 = (_530 * _530) * _530;
    _538 = (_532 * _532) * _532;
    _541 = mad(0.23096993565559387f, _538, mad(-3.307711601257324f, _537, (_536 * 4.076741695404053f)));
    _544 = mad(-0.34131938219070435f, _538, mad(2.609757423400879f, _537, (_536 * -1.2684379816055298f)));
    _547 = mad(1.7076146602630615f, _538, mad(-0.7034186124801636f, _537, (_536 * -0.004196086432784796f)));
    _549 = dot(float3(_541, _544, _547), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _560 = (lerp(_549, _541, g_fTonemapSaturation));
    _561 = (lerp(_549, _544, g_fTonemapSaturation));
    _562 = (lerp(_549, _547, g_fTonemapSaturation));
  } else {
    _560 = _338;
    _561 = _339;
    _562 = _340;
  }
  if (_267) {
    do {
      _1118 = _560;
      _1119 = _561;
      _1120 = _562;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          if (TONE_MAP_TYPE == 0.f) {
            _568 = max(_560, 0.0f);
            _569 = max(_561, 0.0f);
            _570 = max(_562, 0.0f);
          } else {
            _568 = _560;
            _569 = _561;
            _570 = _562;
          }
          float3 agx_color = ApplyRemedyAgX(
              _568, _569, _570, _278,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
          _1118 = agx_color.x;
          _1119 = agx_color.y;
          _1120 = agx_color.z;
#else
          _568 = max(_560, 0.0f);
          _569 = max(_561, 0.0f);
          _570 = max(_562, 0.0f);
          _617 = g_fAgxMaxEV - g_fAgxMinEV;
          _621 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _570, mad(g_vAgxInsetRow0.y, _569, (g_vAgxInsetRow0.x * _568))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _617);
          _622 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _570, mad(g_vAgxInsetRow1.y, _569, (g_vAgxInsetRow1.x * _568))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _617);
          _623 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _570, mad(g_vAgxInsetRow2.y, _569, (g_vAgxInsetRow2.x * _568))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _617);
          _632 = (g_fAgxContrastSlope * (_621 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _633 = 1.0f / g_fAgxShoulderPower;
          _650 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _652 = _650 * (0.6060606241226196f - _621);
          _653 = 1.0f / g_fAgxToePower;
          _672 = -0.0f - g_fAgxToePrecalcConstant;
          _675 = select((_621 >= 0.6060606241226196f), ((_632 / exp2(log2((float((int)(((int)(uint)((int)(_632 > 0.0f))) - ((int)(uint)((int)(_632 < 0.0f))))) * exp2(log2(abs(_632)) * g_fAgxShoulderPower)) + 1.0f) * _633)) * g_fAgxShoulderPrecalcConstant), ((_652 / exp2(log2((float((int)(((int)(uint)((int)(_652 > 0.0f))) - ((int)(uint)((int)(_652 < 0.0f))))) * exp2(log2(abs(_652)) * g_fAgxToePower)) + 1.0f) * _653)) * _672)) + 0.4894371032714844f;
          _678 = (g_fAgxContrastSlope * (_622 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _696 = _650 * (0.6060606241226196f - _622);
          _717 = select((_622 >= 0.6060606241226196f), ((_678 / exp2(log2((float((int)(((int)(uint)((int)(_678 > 0.0f))) - ((int)(uint)((int)(_678 < 0.0f))))) * exp2(log2(abs(_678)) * g_fAgxShoulderPower)) + 1.0f) * _633)) * g_fAgxShoulderPrecalcConstant), ((_696 / exp2(log2((exp2(log2(abs(_696)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_696 > 0.0f))) - ((int)(uint)((int)(_696 < 0.0f)))))) + 1.0f) * _653)) * _672)) + 0.4894371032714844f;
          _720 = (g_fAgxContrastSlope * (_623 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _738 = _650 * (0.6060606241226196f - _623);
          _759 = select((_623 >= 0.6060606241226196f), ((_720 / exp2(log2((float((int)(((int)(uint)((int)(_720 > 0.0f))) - ((int)(uint)((int)(_720 < 0.0f))))) * exp2(log2(abs(_720)) * g_fAgxShoulderPower)) + 1.0f) * _633)) * g_fAgxShoulderPrecalcConstant), ((_738 / exp2(log2((exp2(log2(abs(_738)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_738 > 0.0f))) - ((int)(uint)((int)(_738 < 0.0f)))))) + 1.0f) * _653)) * _672)) + 0.4894371032714844f;
          _778 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _759, mad(g_vAgxOutsetRow0.y, _717, (_675 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _779 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _759, mad(g_vAgxOutsetRow1.y, _717, (_675 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _780 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _759, mad(g_vAgxOutsetRow2.y, _717, (_675 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _898 = _778;
            _899 = _779;
            _900 = _780;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_778, max(_779, _780)) >= g_fAgxHDRMidGrey))) {
                _791 = log2(1.0f / g_fAgxHDRMidGrey);
                _792 = _791 + 20.0f;
                _793 = log2(g_fAgxHDRRatio);
                _812 = (min(max(log2(max(_778, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _791) + 20.0f) / _792;
                _813 = (min(max(log2(max(_779, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _791) + 20.0f) / _792;
                _814 = (min(max(log2(max(_780, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _791) + 20.0f) / _792;
                _815 = 20.0f / _792;
                _819 = max(_812, max(_813, _814));
                _824 = ((_819 - _815) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _841 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_815 - _819);
                _863 = select((_819 >= _815), ((_824 / exp2(log2((float((int)(((int)(uint)((int)(_824 > 0.0f))) - ((int)(uint)((int)(_824 < 0.0f))))) * exp2(log2(abs(_824)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_841 / exp2(log2((float((int)(((int)(uint)((int)(_841 > 0.0f))) - ((int)(uint)((int)(_841 < 0.0f))))) * exp2(log2(abs(_841)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _793) / _792);
                _869 = exp2((((_863 - _819) * _792) + _793) * g_fAgxHDRSaturation);
                _898 = (saturate(exp2(((_863 + (_869 * (_812 - _819))) * _792) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _899 = (saturate(exp2(((_863 + (_869 * (_813 - _819))) * _792) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _900 = (saturate(exp2(((_863 + (_869 * (_814 - _819))) * _792) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _898 = _778;
                _899 = _779;
                _900 = _780;
              }
            }
            _1118 = (mad(-0.07283977419137955f, _900, mad(-0.5876564383506775f, _899, (_898 * 1.6604962348937988f))) * _278);
            _1119 = (mad(-0.008348013274371624f, _900, mad(1.1328951120376587f, _899, (_898 * -0.1245470941066742f))) * _278);
            _1120 = (mad(1.118751049041748f, _900, mad(-0.10059737414121628f, _899, (_898 * -0.018153680488467216f))) * _278);
          } while (false);
#endif
        } else {
          _568 = max(_560, 0.0f);
          _569 = max(_561, 0.0f);
          _570 = max(_562, 0.0f);
          _914 = dot(float3(_568, _569, _570), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
          do {
            _924 = _568;
            _925 = _569;
            _926 = _570;
            if (!(_914 == 0.0f)) {
              _919 = max(dot(float3(_560, _561, _562), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _914;
              _924 = (_919 * _568);
              _925 = (_919 * _569);
              _926 = (_919 * _570);
            }
            _932 = max(max(_924, max(_925, _926)), 0.0f);
            _934 = 1.0f / max(_932, 1.1754943508222875e-38f);
            _940 = (pow(_932, g_vTonemapGTParams.x));
            _948 = _940 / (((pow(_940, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
            _962 = exp2(log2(_934 * _924) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
            _963 = exp2(log2(_934 * _925) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
            _964 = exp2(log2(_934 * _926) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
            _969 = log2(_948);
            _997 = saturate(exp2(log2((exp2(_969 * g_vTonemapCrosstalk.x) * (1.0f - _962)) + _962) * g_vTonemapCrosstalkSaturation.x) * _948);
            _998 = saturate(exp2(log2((exp2(_969 * g_vTonemapCrosstalk.y) * (1.0f - _963)) + _963) * g_vTonemapCrosstalkSaturation.y) * _948);
            _999 = saturate(exp2(log2((exp2(_969 * g_vTonemapCrosstalk.z) * (1.0f - _964)) + _964) * g_vTonemapCrosstalkSaturation.z) * _948);
            if (_343) {
              do {
                _1111 = _997;
                _1112 = _998;
                _1113 = _999;
                if (_269) {
                  do {
                    [branch]
                    if (!(_997 <= 0.0031308000907301903f)) {
                      _1012 = (((pow(_997, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _1012 = (_997 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_998 <= 0.0031308000907301903f)) {
                        _1023 = (((pow(_998, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _1023 = (_998 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_999 <= 0.0031308000907301903f)) {
                          _1034 = (((pow(_999, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _1034 = (_999 * 12.920000076293945f);
                        }
                        _1041 = (saturate(_1023) * 0.96875f) + 0.015625f;
                        _1043 = max((saturate(_1034) * 31.0f), 0.0f);
                        _1044 = floor(_1043);
                        _1045 = _1043 - _1044;
                        _1047 = (((saturate(_1012) * 0.96875f) + 0.015625f) + _1044) * 0.03125f;
                        _1049 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_1047, _1041), 0.0f);
                        _1053 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_1047 + 0.03125f), _1041), 0.0f);
                        _1063 = ((_1053.x - _1049.x) * _1045) + _1049.x;
                        _1064 = ((_1053.y - _1049.y) * _1045) + _1049.y;
                        _1065 = ((_1053.z - _1049.z) * _1045) + _1049.z;
                        do {
                          [branch]
                          if (!(_1063 <= 0.040449999272823334f)) {
                            _1076 = exp2(log2((_1063 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _1076 = (_1063 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_1064 <= 0.040449999272823334f)) {
                              _1087 = exp2(log2((_1064 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _1087 = (_1064 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_1065 <= 0.040449999272823334f)) {
                                _1098 = exp2(log2((_1065 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _1098 = (_1065 * 0.07739938050508499f);
                              }
                              _1100 = dot(float3(_1076, _1087, _1098), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _1111 = (lerp(_1100, _1076, g_fTonemapSaturation));
                              _1112 = (lerp(_1100, _1087, g_fTonemapSaturation));
                              _1113 = (lerp(_1100, _1098, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1118 = (_1111 * _278);
                _1119 = (_1112 * _278);
                _1120 = (_1113 * _278);
              } while (false);
            } else {
              _1118 = _997;
              _1119 = _998;
              _1120 = _999;
            }
          } while (false);
        }
      }
      _1129 = (_1118 * g_fTonemapBrightness);
      _1130 = (_1119 * g_fTonemapBrightness);
      _1131 = (_1120 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1129 = (_560 * _278);
    _1130 = (_561 * _278);
    _1131 = (_562 * _278);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1143 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1150 = (_1143.x * 2.0f) + -1.0f;
    _1151 = (_1143.y * 2.0f) + -1.0f;
    _1152 = (_1143.z * 2.0f) + -1.0f;
    if (!(_267)) {
      _1155 = _1129 / _278;
      _1156 = _1130 / _278;
      _1157 = _1131 / _278;
      _1161 = 1.0f - sqrt(max(dot(float3(_1155, _1156, _1157), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
      _1166 = g_fFilmGrainIntensity * (_278 * 5.0f);
      _1229 = ((((_1166 * _1150) * saturate(_1155)) * _1161) + _1129);
      _1230 = ((((_1166 * _1151) * _1161) * saturate(_1156)) + _1130);
      _1231 = ((((_1166 * _1152) * _1161) * saturate(_1157)) + _1131);
    } else {
      _1180 = saturate(_1129);
      _1181 = saturate(_1130);
      _1182 = saturate(_1131);
      _1187 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_1180, max(_1181, _1182))));
      _1188 = _1187 * _1180;
      _1189 = _1187 * _1181;
      _1190 = _1187 * _1182;
      _1198 = ((1.0f - sqrt(dot(float3(_1188, _1189, _1190), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
      _1205 = ((_1198 * _1150) * min(1.0f, _1188)) + _1188;
      _1206 = ((_1198 * _1151) * min(1.0f, _1189)) + _1189;
      _1207 = ((_1198 * _1152) * min(1.0f, _1190)) + _1190;
      _1211 = 1.0f / (max(_1205, max(_1206, _1207)) + 1.0f);
      _1218 = 1.0f / (max(_1188, max(_1189, _1190)) + 1.0f);
      _1229 = (((_1205 * _1211) + _1129) - (_1218 * _1188));
      _1230 = (((_1206 * _1211) + _1130) - (_1218 * _1189));
      _1231 = (((_1207 * _1211) + _1131) - (_1218 * _1190));
    }
  } else {
    _1229 = _1129;
    _1230 = _1130;
    _1231 = _1131;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1238 = (g_bHDR == 0);
    do {
      _1265 = _1229;
      _1266 = _1230;
      _1267 = _1231;
      if (!(_1238 || (g_bHDR_scRGB == 0))) {
        _1252 = max(mad(0.043306104838848114f, _1231, mad(0.329291969537735f, _1230, (_1229 * 0.6274019479751587f))), 0.0f);
        _1253 = max(mad(0.0113602289929986f, _1231, mad(0.9195442795753479f, _1230, (_1229 * 0.06909549236297607f))), 0.0f);
        _1254 = max(mad(0.895578145980835f, _1231, mad(0.08802816271781921f, _1230, (_1229 * 0.016393709927797318f))), 0.0f);
        _1265 = mad(-0.07283977419137955f, _1254, mad(-0.5876564383506775f, _1253, (_1252 * 1.6604962348937988f)));
        _1266 = mad(-0.008348013274371624f, _1254, mad(1.1328951120376587f, _1253, (_1252 * -0.1245470941066742f)));
        _1267 = mad(1.118751049041748f, _1254, mad(-0.10059737414121628f, _1253, (_1252 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1238)) {
        _1283 = mad(0.043306104838848114f, _1267, mad(0.329291969537735f, _1266, (_1265 * 0.6274019479751587f)));
        _1284 = mad(0.0113602289929986f, _1267, mad(0.9195442795753479f, _1266, (_1265 * 0.06909549236297607f)));
        _1285 = mad(0.895578145980835f, _1267, mad(0.08802816271781921f, _1266, (_1265 * 0.016393709927797318f)));
      } else {
        _1283 = _1265;
        _1284 = _1266;
        _1285 = _1267;
      }
    } while (false);
  } else {
    _1283 = _1229;
    _1284 = _1230;
    _1285 = _1231;
  }
  SV_Target.x = _1283;
  SV_Target.y = _1284;
  SV_Target.z = _1285;
  SV_Target.w = 1.0f;
  return SV_Target;
}
