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
  float _277;
  float _297;
  float _298;
  float _299;
  float _337;
  float _338;
  float _339;
  float _559;
  float _560;
  float _561;
  float _897;
  float _898;
  float _899;
  float _927;
  float _928;
  float _929;
  float _1014;
  float _1025;
  float _1036;
  float _1078;
  float _1089;
  float _1100;
  float _1113;
  float _1114;
  float _1115;
  float _1274;
  float _1275;
  float _1276;
  float _1285;
  float _1286;
  float _1287;
  float _1335;
  float _1336;
  float _1337;
  float _1371;
  float _1372;
  float _1373;
  float _1389;
  float _1390;
  float _1391;
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
  float _389;
  float _390;
  int _394;
  int _395;
  int _396;
  float _400;
  float _401;
  float _402;
  int _407;
  int _412;
  int _417;
  bool _418;
  bool _419;
  bool _420;
  float4 _438;
  float4 _453;
  float4 _468;
  float4 _483;
  float _490;
  float _497;
  float _501;
  float _502;
  float _506;
  float _510;
  float _519;
  float _522;
  float _525;
  float _527;
  float _529;
  float _531;
  float _535;
  float _536;
  float _537;
  float _540;
  float _543;
  float _546;
  float _548;
  float _592;
  float _593;
  float _594;
  float _616;
  float _620;
  float _621;
  float _622;
  float _631;
  float _632;
  float _649;
  float _651;
  float _652;
  float _671;
  float _674;
  float _677;
  float _695;
  float _716;
  float _719;
  float _737;
  float _758;
  float _777;
  float _778;
  float _779;
  float _790;
  float _791;
  float _792;
  float _811;
  float _812;
  float _813;
  float _814;
  float _818;
  float _823;
  float _840;
  float _862;
  float _868;
  float _914;
  float _915;
  float _916;
  float _917;
  float _922;
  float _935;
  float _937;
  float _943;
  float _951;
  float _965;
  float _966;
  float _967;
  float _972;
  float _1000;
  float _1001;
  float _1002;
  float _1043;
  float _1045;
  float _1046;
  float _1047;
  float _1049;
  float4 _1051;
  float4 _1055;
  float _1065;
  float _1066;
  float _1067;
  float _1102;
  float _1124;
  float _1129;
  float _1131;
  float _1132;
  float _1133;
  float _1134;
  float _1144;
  float _1148;
  float _1197;
  float _1198;
  float _1199;
  float _1204;
  float _1217;
  float _1218;
  float _1219;
  float _1251;
  float _1253;
  float _1255;
  float _1256;
  float _1269;
  float4 _1299;
  float _1309;
  float _1310;
  float _1311;
  float _1315;
  float _1321;
  bool _1344;
  float _1358;
  float _1359;
  float _1360;
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
    _388 = saturate(exp2(log2(((_358 * 18.8515625f) + 0.8359375f) / ((_358 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _389 = saturate(exp2(log2(((_359 * 18.8515625f) + 0.8359375f) / ((_359 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _390 = saturate(exp2(log2(((_360 * 18.8515625f) + 0.8359375f) / ((_360 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _394 = int(floor(_388));
    _395 = int(floor(_389));
    _396 = int(floor(_390));
    _400 = _388 - float((int)(_394));
    _401 = _389 - float((int)(_395));
    _402 = _390 - float((int)(_396));
    _407 = ((int)(uint)((int)(_402 > _400))) + ((int)(uint)((int)(_401 > _400)));
    _412 = ((int)(uint)((int)(_402 > _401))) + ((int)(uint)((int)(_400 >= _401)));
    _417 = ((int)(uint)((int)(_400 >= _402))) + ((int)(uint)((int)(_401 >= _402)));
    _418 = (_407 == 0);
    _419 = (_412 == 0);
    _420 = (_417 == 0);
    _438 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_396), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_394), (int)(0))), (int)(47))), min((int)(max((int)(_395), (int)(0))), (int)(47)), 0));
    _453 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_420))) + _396))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_418))) + _394))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_419))) + _395))), (int)(0))), (int)(47)), 0));
    _468 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_417 < (uint)2)))) + _396))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_407 < (uint)2)))) + _394))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_412 < (uint)2)))) + _395))), (int)(0))), (int)(47)), 0));
    _483 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_396 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_394 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_395 + 1u))), (int)(0))), (int)(47)), 0));
    _490 = dot(float3(_400, _401, _402), float3(((float)((bool)_418)), ((float)((bool)_419)), ((float)((bool)_420))));
    _497 = dot(float3(_400, _401, _402), float3(((float)((bool)(uint)(_407 == 2))), ((float)((bool)(uint)(_412 == 2))), ((float)((bool)(uint)(_417 == 2)))));
    _501 = (((_401 + _400) + _402) - _490) - _497;
    _502 = 1.0f - _490;
    _506 = _490 - _501;
    _510 = _501 - _497;
    _519 = (((_497 * _483.x) + (_502 * _438.x)) + (_506 * _453.x)) + (_510 * _468.x);
    _522 = (((_497 * _483.y) + (_502 * _438.y)) + (_506 * _453.y)) + (_510 * _468.y);
    _525 = (((_497 * _483.z) + (_502 * _438.z)) + (_506 * _453.z)) + (_510 * _468.z);
    _527 = mad(0.21580375730991364f, _525, mad(0.3963377773761749f, _522, _519));
    _529 = mad(-0.0638541728258133f, _525, mad(-0.10556134581565857f, _522, _519));
    _531 = mad(-1.2914855480194092f, _525, mad(-0.08948417752981186f, _522, _519));
    _535 = (_527 * _527) * _527;
    _536 = (_529 * _529) * _529;
    _537 = (_531 * _531) * _531;
    _540 = mad(0.23096993565559387f, _537, mad(-3.307711601257324f, _536, (_535 * 4.076741695404053f)));
    _543 = mad(-0.34131938219070435f, _537, mad(2.609757423400879f, _536, (_535 * -1.2684379816055298f)));
    _546 = mad(1.7076146602630615f, _537, mad(-0.7034186124801636f, _536, (_535 * -0.004196086432784796f)));
    _548 = dot(float3(_540, _543, _546), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _559 = (lerp(_548, _540, g_fTonemapSaturation));
    _560 = (lerp(_548, _543, g_fTonemapSaturation));
    _561 = (lerp(_548, _546, g_fTonemapSaturation));
  } else {
    _559 = _337;
    _560 = _338;
    _561 = _339;
  }
  if (!(_267)) {
    do {
      _1274 = _559;
      _1275 = _560;
      _1276 = _561;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _559, _560, _561, _277,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
          _1274 = agx_color.x;
          _1275 = agx_color.y;
          _1276 = agx_color.z;
#else
          _592 = max(_559, 0.0f);
          _593 = max(_560, 0.0f);
          _594 = max(_561, 0.0f);
          _616 = g_fAgxMaxEV - g_fAgxMinEV;
          _620 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _594, mad(g_vAgxInsetRow0.y, _593, (_592 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _616);
          _621 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _594, mad(g_vAgxInsetRow1.y, _593, (_592 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _616);
          _622 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _594, mad(g_vAgxInsetRow2.y, _593, (_592 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _616);
          _631 = (g_fAgxContrastSlope * (_620 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _632 = 1.0f / g_fAgxShoulderPower;
          _649 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _651 = _649 * (0.6060606241226196f - _620);
          _652 = 1.0f / g_fAgxToePower;
          _671 = -0.0f - g_fAgxToePrecalcConstant;
          _674 = select((_620 >= 0.6060606241226196f), ((_631 / exp2(log2((float((int)(((int)(uint)((int)(_631 > 0.0f))) - ((int)(uint)((int)(_631 < 0.0f))))) * exp2(log2(abs(_631)) * g_fAgxShoulderPower)) + 1.0f) * _632)) * g_fAgxShoulderPrecalcConstant), ((_651 / exp2(log2((float((int)(((int)(uint)((int)(_651 > 0.0f))) - ((int)(uint)((int)(_651 < 0.0f))))) * exp2(log2(abs(_651)) * g_fAgxToePower)) + 1.0f) * _652)) * _671)) + 0.4894371032714844f;
          _677 = (g_fAgxContrastSlope * (_621 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _695 = _649 * (0.6060606241226196f - _621);
          _716 = select((_621 >= 0.6060606241226196f), ((_677 / exp2(log2((float((int)(((int)(uint)((int)(_677 > 0.0f))) - ((int)(uint)((int)(_677 < 0.0f))))) * exp2(log2(abs(_677)) * g_fAgxShoulderPower)) + 1.0f) * _632)) * g_fAgxShoulderPrecalcConstant), ((_695 / exp2(log2((exp2(log2(abs(_695)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_695 > 0.0f))) - ((int)(uint)((int)(_695 < 0.0f)))))) + 1.0f) * _652)) * _671)) + 0.4894371032714844f;
          _719 = (g_fAgxContrastSlope * (_622 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _737 = _649 * (0.6060606241226196f - _622);
          _758 = select((_622 >= 0.6060606241226196f), ((_719 / exp2(log2((float((int)(((int)(uint)((int)(_719 > 0.0f))) - ((int)(uint)((int)(_719 < 0.0f))))) * exp2(log2(abs(_719)) * g_fAgxShoulderPower)) + 1.0f) * _632)) * g_fAgxShoulderPrecalcConstant), ((_737 / exp2(log2((exp2(log2(abs(_737)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_737 > 0.0f))) - ((int)(uint)((int)(_737 < 0.0f)))))) + 1.0f) * _652)) * _671)) + 0.4894371032714844f;
          _777 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _758, mad(g_vAgxOutsetRow0.y, _716, (_674 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _778 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _758, mad(g_vAgxOutsetRow1.y, _716, (_674 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _779 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _758, mad(g_vAgxOutsetRow2.y, _716, (_674 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _897 = _777;
            _898 = _778;
            _899 = _779;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_777, max(_778, _779)) >= g_fAgxHDRMidGrey))) {
                _790 = log2(1.0f / g_fAgxHDRMidGrey);
                _791 = _790 + 20.0f;
                _792 = log2(g_fAgxHDRRatio);
                _811 = (min(max(log2(max(_777, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _790) + 20.0f) / _791;
                _812 = (min(max(log2(max(_778, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _790) + 20.0f) / _791;
                _813 = (min(max(log2(max(_779, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _790) + 20.0f) / _791;
                _814 = 20.0f / _791;
                _818 = max(_811, max(_812, _813));
                _823 = ((_818 - _814) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _840 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_814 - _818);
                _862 = select((_818 >= _814), ((_823 / exp2(log2((float((int)(((int)(uint)((int)(_823 > 0.0f))) - ((int)(uint)((int)(_823 < 0.0f))))) * exp2(log2(abs(_823)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_840 / exp2(log2((float((int)(((int)(uint)((int)(_840 > 0.0f))) - ((int)(uint)((int)(_840 < 0.0f))))) * exp2(log2(abs(_840)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _792) / _791);
                _868 = exp2((((_862 - _818) * _791) + _792) * g_fAgxHDRSaturation);
                _897 = (saturate(exp2(((_862 + (_868 * (_811 - _818))) * _791) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _898 = (saturate(exp2(((_862 + (_868 * (_812 - _818))) * _791) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _899 = (saturate(exp2(((_862 + (_868 * (_813 - _818))) * _791) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _897 = _777;
                _898 = _778;
                _899 = _779;
              }
            }
            _1274 = (mad(-0.07283977419137955f, _899, mad(-0.5876564383506775f, _898, (_897 * 1.6604962348937988f))) * _277);
            _1275 = (mad(-0.008348013274371624f, _899, mad(1.1328951120376587f, _898, (_897 * -0.1245470941066742f))) * _277);
            _1276 = (mad(1.118751049041748f, _899, mad(-0.10059737414121628f, _898, (_897 * -0.018153680488467216f))) * _277);
          } while (false);
#endif
        } else {
          if (_342) {
            _914 = max(_559, 0.0f);
            _915 = max(_560, 0.0f);
            _916 = max(_561, 0.0f);
            _917 = dot(float3(_914, _915, _916), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            do {
              _927 = _914;
              _928 = _915;
              _929 = _916;
              if (!(_917 == 0.0f)) {
                _922 = max(dot(float3(_559, _560, _561), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _917;
                _927 = (_922 * _914);
                _928 = (_922 * _915);
                _929 = (_922 * _916);
              }
              _935 = max(max(_927, max(_928, _929)), 0.0f);
              _937 = 1.0f / max(_935, 1.1754943508222875e-38f);
              _943 = (pow(_935, g_vTonemapGTParams.x));
              _951 = _943 / (((pow(_943, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
              _965 = exp2(log2(_937 * _927) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
              _966 = exp2(log2(_937 * _928) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
              _967 = exp2(log2(_937 * _929) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
              _972 = log2(_951);
              _1000 = saturate(exp2(log2((exp2(_972 * g_vTonemapCrosstalk.x) * (1.0f - _965)) + _965) * g_vTonemapCrosstalkSaturation.x) * _951);
              _1001 = saturate(exp2(log2((exp2(_972 * g_vTonemapCrosstalk.y) * (1.0f - _966)) + _966) * g_vTonemapCrosstalkSaturation.y) * _951);
              _1002 = saturate(exp2(log2((exp2(_972 * g_vTonemapCrosstalk.z) * (1.0f - _967)) + _967) * g_vTonemapCrosstalkSaturation.z) * _951);
              do {
                _1113 = _1000;
                _1114 = _1001;
                _1115 = _1002;
                if (_269) {
                  do {
                    [branch]
                    if (!(_1000 <= 0.0031308000907301903f)) {
                      _1014 = (((pow(_1000, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _1014 = (_1000 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_1001 <= 0.0031308000907301903f)) {
                        _1025 = (((pow(_1001, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _1025 = (_1001 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_1002 <= 0.0031308000907301903f)) {
                          _1036 = (((pow(_1002, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _1036 = (_1002 * 12.920000076293945f);
                        }
                        _1043 = (saturate(_1025) * 0.96875f) + 0.015625f;
                        _1045 = max((saturate(_1036) * 31.0f), 0.0f);
                        _1046 = floor(_1045);
                        _1047 = _1045 - _1046;
                        _1049 = (((saturate(_1014) * 0.96875f) + 0.015625f) + _1046) * 0.03125f;
                        _1051 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_1049, _1043), 0.0f);
                        _1055 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_1049 + 0.03125f), _1043), 0.0f);
                        _1065 = ((_1055.x - _1051.x) * _1047) + _1051.x;
                        _1066 = ((_1055.y - _1051.y) * _1047) + _1051.y;
                        _1067 = ((_1055.z - _1051.z) * _1047) + _1051.z;
                        do {
                          [branch]
                          if (!(_1065 <= 0.040449999272823334f)) {
                            _1078 = exp2(log2((_1065 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _1078 = (_1065 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_1066 <= 0.040449999272823334f)) {
                              _1089 = exp2(log2((_1066 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _1089 = (_1066 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_1067 <= 0.040449999272823334f)) {
                                _1100 = exp2(log2((_1067 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _1100 = (_1067 * 0.07739938050508499f);
                              }
                              _1102 = dot(float3(_1078, _1089, _1100), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _1113 = (lerp(_1102, _1078, g_fTonemapSaturation));
                              _1114 = (lerp(_1102, _1089, g_fTonemapSaturation));
                              _1115 = (lerp(_1102, _1100, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1274 = (_1113 * _277);
                _1275 = (_1114 * _277);
                _1276 = (_1115 * _277);
              } while (false);
            } while (false);
          } else {
            _1124 = g_fMaxOutputNits * 0.012500000186264515f;
            _1129 = max(abs(_559), max(abs(_560), abs(_561)));
            _1131 = 1.0f / max(_1129, 1.1754943508222875e-38f);
            _1132 = _1131 * _559;
            _1133 = _1131 * _560;
            _1134 = _1131 * _561;
            _1144 = (_277 * 0.18000000715255737f) * exp2(log2((pow(_1129, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
            _1148 = dot(float3((_1144 * _1132), (_1144 * _1133), (_1144 * _1134)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1197 = exp2(log2(abs(_1132)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_1132 > 0.0f))) - ((int)(uint)((int)(_1132 < 0.0f)))));
            _1198 = exp2(log2(abs(_1133)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_1133 > 0.0f))) - ((int)(uint)((int)(_1133 < 0.0f)))));
            _1199 = exp2(log2(abs(_1134)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_1134 > 0.0f))) - ((int)(uint)((int)(_1134 < 0.0f)))));
            _1204 = log2(saturate(select((_1148 <= 0.0f), _1148, ((1.0f - exp2(log2(exp2((_1148 / _1124) * -1.4426950216293335f)))) * _1124)) / _1124));
            _1217 = (exp2(_1204 * g_vTonemapCrosstalk.x) * (1.0f - _1197)) + _1197;
            _1218 = (exp2(_1204 * g_vTonemapCrosstalk.y) * (1.0f - _1198)) + _1198;
            _1219 = (exp2(_1204 * g_vTonemapCrosstalk.z) * (1.0f - _1199)) + _1199;
            _1251 = (float((int)(((int)(uint)((int)(_1217 > 0.0f))) - ((int)(uint)((int)(_1217 < 0.0f))))) * _1144) * exp2(log2(abs(_1217)) * g_vTonemapCrosstalkSaturation.x);
            _1253 = (float((int)(((int)(uint)((int)(_1218 > 0.0f))) - ((int)(uint)((int)(_1218 < 0.0f))))) * _1144) * exp2(log2(abs(_1218)) * g_vTonemapCrosstalkSaturation.y);
            _1255 = (float((int)(((int)(uint)((int)(_1219 > 0.0f))) - ((int)(uint)((int)(_1219 < 0.0f))))) * _1144) * exp2(log2(abs(_1219)) * g_vTonemapCrosstalkSaturation.z);
            _1256 = dot(float3(_1251, _1253, _1255), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1269 = select((_1256 <= 0.0f), _1256, ((1.0f - exp2(log2(exp2((_1256 / _1124) * -1.4426950216293335f)))) * _1124)) * select((!(_1256 == 0.0f)), (1.0f / _1256), 0.0f);
            _1274 = (_1269 * _1251);
            _1275 = (_1269 * _1253);
            _1276 = (_1269 * _1255);
          }
        }
      }
      _1285 = (_1274 * g_fTonemapBrightness);
      _1286 = (_1275 * g_fTonemapBrightness);
      _1287 = (_1276 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1285 = (_559 * _277);
    _1286 = (_560 * _277);
    _1287 = (_561 * _277);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1299 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1309 = _1285 / _277;
    _1310 = _1286 / _277;
    _1311 = _1287 / _277;
    _1315 = 1.0f - sqrt(max(dot(float3(_1309, _1310, _1311), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
    _1321 = g_fFilmGrainIntensity * (_277 * 5.0f);
    _1335 = ((((_1321 * ((_1299.x * 2.0f) + -1.0f)) * saturate(_1309)) * _1315) + _1285);
    _1336 = ((((_1321 * ((_1299.y * 2.0f) + -1.0f)) * _1315) * saturate(_1310)) + _1286);
    _1337 = ((((_1321 * ((_1299.z * 2.0f) + -1.0f)) * _1315) * saturate(_1311)) + _1287);
  } else {
    _1335 = _1285;
    _1336 = _1286;
    _1337 = _1287;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1344 = (g_bHDR == 0);
    do {
      _1371 = _1335;
      _1372 = _1336;
      _1373 = _1337;
      if (!(_1344 || (g_bHDR_scRGB == 0))) {
        _1358 = max(mad(0.043306104838848114f, _1337, mad(0.329291969537735f, _1336, (_1335 * 0.6274019479751587f))), 0.0f);
        _1359 = max(mad(0.0113602289929986f, _1337, mad(0.9195442795753479f, _1336, (_1335 * 0.06909549236297607f))), 0.0f);
        _1360 = max(mad(0.895578145980835f, _1337, mad(0.08802816271781921f, _1336, (_1335 * 0.016393709927797318f))), 0.0f);
        _1371 = mad(-0.07283977419137955f, _1360, mad(-0.5876564383506775f, _1359, (_1358 * 1.6604962348937988f)));
        _1372 = mad(-0.008348013274371624f, _1360, mad(1.1328951120376587f, _1359, (_1358 * -0.1245470941066742f)));
        _1373 = mad(1.118751049041748f, _1360, mad(-0.10059737414121628f, _1359, (_1358 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1344)) {
        _1389 = mad(0.043306104838848114f, _1373, mad(0.329291969537735f, _1372, (_1371 * 0.6274019479751587f)));
        _1390 = mad(0.0113602289929986f, _1373, mad(0.9195442795753479f, _1372, (_1371 * 0.06909549236297607f)));
        _1391 = mad(0.895578145980835f, _1373, mad(0.08802816271781921f, _1372, (_1371 * 0.016393709927797318f)));
      } else {
        _1389 = _1371;
        _1390 = _1372;
        _1391 = _1373;
      }
    } while (false);
  } else {
    _1389 = _1335;
    _1390 = _1336;
    _1391 = _1337;
  }
  SV_Target.x = _1389;
  SV_Target.y = _1390;
  SV_Target.z = _1391;
  SV_Target.w = 1.0f;
  return SV_Target;
}
