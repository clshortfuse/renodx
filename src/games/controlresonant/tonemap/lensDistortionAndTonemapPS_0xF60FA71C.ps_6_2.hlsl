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
  float g_fAgxHDRSaturation : packoffset(c014.w);
};

cbuffer shared_tonemap_post : register(b6) {
  float g_fPaperWhite : packoffset(c000.x);
  int g_bApplyVignette : packoffset(c000.y);
  int g_bApplyFilmGrain : packoffset(c000.z);
};

cbuffer sourceres : register(b7) {
  float2 g_vSourceRes : packoffset(c000.x);
};

cbuffer postprocess : register(b8) {
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
  float _21;
  float _22;
  float _32;
  float _33;
  float _63;
  float _64;
  float _276;
  float _277;
  float _278;
  float _338;
  float _339;
  float _340;
  float _354;
  float _374;
  float _375;
  float _376;
  float _414;
  float _415;
  float _416;
  float _636;
  float _637;
  float _638;
  float _974;
  float _975;
  float _976;
  float _1000;
  float _1001;
  float _1002;
  float _1088;
  float _1099;
  float _1110;
  float _1152;
  float _1163;
  float _1174;
  float _1187;
  float _1188;
  float _1189;
  float _1194;
  float _1195;
  float _1196;
  float _1205;
  float _1206;
  float _1207;
  float _1305;
  float _1306;
  float _1307;
  float _1364;
  float _1375;
  float _1386;
  float _1387;
  float _1388;
  bool _1408;
  float _1429;
  float _1430;
  float _1431;
  float _1464;
  float _1465;
  float _1466;
  float _1482;
  float _1483;
  float _1484;
  float _44;
  float _48;
  float _49;
  float _53;
  float _57;
  float _69;
  float _70;
  float _74;
  float _75;
  float _78;
  float _79;
  float _80;
  float _81;
  float _82;
  float _83;
  float _84;
  float _85;
  float _92;
  float _93;
  float _94;
  float _95;
  float _96;
  float _97;
  float _110;
  float _111;
  float _114;
  float _115;
  float _116;
  float _117;
  float _126;
  float _127;
  float _128;
  float _129;
  float _130;
  float _131;
  float4 _132;
  float4 _139;
  float4 _149;
  float4 _162;
  float4 _169;
  float4 _176;
  float4 _183;
  float4 _190;
  float4 _197;
  float4 _228;
  float4 _233;
  float4 _238;
  float4 _271;
  bool _280;
  uint _284;
  uint _285;
  float _293;
  float _295;
  float _296;
  float _317;
  float _318;
  float _319;
  float _321;
  float _326;
  float _330;
  bool _343;
  bool _345;
  float _378;
  float _382;
  float _383;
  float _384;
  float _385;
  float _394;
  float _395;
  float _409;
  bool _419;
  float _435;
  float _436;
  float _437;
  float _465;
  float _466;
  float _467;
  int _471;
  int _472;
  int _473;
  float _477;
  float _478;
  float _479;
  int _484;
  int _489;
  int _494;
  bool _495;
  bool _496;
  bool _497;
  float4 _515;
  float4 _530;
  float4 _545;
  float4 _560;
  float _567;
  float _574;
  float _578;
  float _579;
  float _583;
  float _587;
  float _596;
  float _599;
  float _602;
  float _604;
  float _606;
  float _608;
  float _612;
  float _613;
  float _614;
  float _617;
  float _620;
  float _623;
  float _625;
  float _644;
  float _645;
  float _646;
  float _693;
  float _697;
  float _698;
  float _699;
  float _708;
  float _709;
  float _726;
  float _728;
  float _729;
  float _748;
  float _751;
  float _754;
  float _772;
  float _793;
  float _796;
  float _814;
  float _835;
  float _854;
  float _855;
  float _856;
  float _867;
  float _868;
  float _869;
  float _888;
  float _889;
  float _890;
  float _891;
  float _895;
  float _900;
  float _917;
  float _939;
  float _945;
  float _990;
  float _995;
  float _1008;
  float _1010;
  float _1016;
  float _1024;
  float _1038;
  float _1039;
  float _1040;
  float _1045;
  float _1073;
  float _1074;
  float _1075;
  float _1117;
  float _1119;
  float _1120;
  float _1121;
  float _1123;
  float4 _1125;
  float4 _1129;
  float _1139;
  float _1140;
  float _1141;
  float _1176;
  float4 _1219;
  float _1226;
  float _1227;
  float _1228;
  float _1231;
  float _1232;
  float _1233;
  float _1237;
  float _1242;
  float _1256;
  float _1257;
  float _1258;
  float _1263;
  float _1264;
  float _1265;
  float _1266;
  float _1274;
  float _1281;
  float _1282;
  float _1283;
  float _1287;
  float _1294;
  uint _1311;
  uint _1312;
  uint2 _1313;
  float4 _1327;
  float _1333;
  float _1335;
  float _1337;
  float _1341;
  float _1342;
  float _1343;
  float _1395;
  float _1414;
  float _1424;
  bool _1437;
  float _1451;
  float _1452;
  float _1453;
  _21 = g_vInvOutputRes.x * SV_Position.x;
  _22 = g_vInvOutputRes.y * SV_Position.y;
  _32 = ((_21 * 2.0f) + -1.0f) / g_vLensDistortionUVScale.x;
  _33 = ((_22 * 2.0f) + -1.0f) / g_vLensDistortionUVScale.y;
  if (!(!(g_vLensDistortionParams.w >= 0.0f))) {
    _44 = (g_vLensDistortionParams.x - ((_32 * _32) * g_vLensDistortionParams.y)) - ((_33 * _33) * g_vLensDistortionParams.z);
    _63 = (_32 / _44);
    _64 = (_33 / _44);
  } else {
    _48 = _32 * 0.5f;
    _49 = _33 * 0.5f;
    _53 = sqrt((_49 * _49) + (_48 * _48));
    _57 = (((_53 * _53) * g_vLensDistortionParams.w) + 1.0f) * _53;
    _63 = (_57 * (_32 / _53));
    _64 = (_57 * (_33 / _53));
  }
  _69 = ((_63 * g_vLensDistortionUVScale.x) + 1.0f) * 0.5f;
  _70 = ((_64 * g_vLensDistortionUVScale.y) + 1.0f) * 0.5f;
  _74 = _69 * g_vSourceRes.x;
  _75 = _70 * g_vSourceRes.y;
  _78 = floor(_74 + -0.5f);
  _79 = floor(_75 + -0.5f);
  _80 = _78 + 0.5f;
  _81 = _79 + 0.5f;
  _82 = _74 - _80;
  _83 = _75 - _81;
  _84 = _82 * 0.5f;
  _85 = _83 * 0.5f;
  _92 = (((1.0f - _84) * _82) + -0.5f) * _82;
  _93 = (((1.0f - _85) * _83) + -0.5f) * _83;
  _94 = _82 * _82;
  _95 = _83 * _83;
  _96 = _82 * 1.5f;
  _97 = _83 * 1.5f;
  _110 = (((2.0f - _96) * _82) + 0.5f) * _82;
  _111 = (((2.0f - _97) * _83) + 0.5f) * _83;
  _114 = (_84 + -0.5f) * _94;
  _115 = (_85 + -0.5f) * _95;
  _116 = (((_96 + -2.5f) * _94) + 1.0f) + _110;
  _117 = (((_97 + -2.5f) * _95) + 1.0f) + _111;
  _126 = (_78 + -0.5f) / g_vSourceRes.x;
  _127 = (_79 + -0.5f) / g_vSourceRes.y;
  _128 = (_78 + 2.5f) / g_vSourceRes.x;
  _129 = (_79 + 2.5f) / g_vSourceRes.y;
  _130 = ((_110 / _116) + _80) / g_vSourceRes.x;
  _131 = ((_111 / _117) + _81) / g_vSourceRes.y;
  _132 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_126, _127), 0.0f);
  _139 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_130, _127), 0.0f);
  _149 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_128, _127), 0.0f);
  _162 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_126, _131), 0.0f);
  _169 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_130, _131), 0.0f);
  _176 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_128, _131), 0.0f);
  _183 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_126, _129), 0.0f);
  _190 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_130, _129), 0.0f);
  _197 = g_tSource.SampleLevel(g_sLinearClamp_internal, float2(_128, _129), 0.0f);
  _228 = g_tSource.GatherRed(g_sLinearClamp_internal, float2(_69, _70));
  _233 = g_tSource.GatherGreen(g_sLinearClamp_internal, float2(_69, _70));
  _238 = g_tSource.GatherBlue(g_sLinearClamp_internal, float2(_69, _70));
  if (!(g_bDebugReferenceImage == 0)) {
    _271 = g_tSourceReferenceImage.Sample(g_sLinearClamp_internal, float2(_21, _22));
    _276 = _271.x;
    _277 = _271.y;
    _278 = _271.z;
  } else {
    _276 = min(max(((((((_169.x * _116) + (_162.x * _92)) + (_176.x * _114)) * _117) + ((((_139.x * _116) + (_132.x * _92)) + (_149.x * _114)) * _93)) + ((((_190.x * _116) + (_183.x * _92)) + (_197.x * _114)) * _115)), min(min(_228.x, _228.y), min(_228.z, _228.w))), max(max(_228.x, _228.y), max(_228.z, _228.w)));
    _277 = min(max(((((((_169.y * _116) + (_162.y * _92)) + (_176.y * _114)) * _117) + ((((_139.y * _116) + (_132.y * _92)) + (_149.y * _114)) * _93)) + ((((_190.y * _116) + (_183.y * _92)) + (_197.y * _114)) * _115)), min(min(_233.x, _233.y), min(_233.z, _233.w))), max(max(_233.x, _233.y), max(_233.z, _233.w)));
    _278 = min(max(((((((_169.z * _116) + (_162.z * _92)) + (_176.z * _114)) * _117) + ((((_139.z * _116) + (_132.z * _92)) + (_149.z * _114)) * _93)) + ((((_190.z * _116) + (_183.z * _92)) + (_197.z * _114)) * _115)), min(min(_238.x, _238.y), min(_238.z, _238.w))), max(max(_238.x, _238.y), max(_238.z, _238.w)));
  }
  _280 = (g_bDebugLUT == 0);
  if (!(_280)) {
    _284 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _285 = (uint)(int(SV_Position.y)) + (uint)(-112);
    if (((int)_285 < (int)300) && (((int)_284 < (int)500) && ((int)(_285 | _284) > (int)-1))) {
      _293 = float((int)(_284));
      _295 = _293 * 0.0020000000949949026f;
      _296 = float((int)(_285)) * 0.005333333276212215f;
      _317 = saturate(2.0f - (abs(frac(_296) + -0.5f) * 6.0f)) * 2.0f;
      _318 = saturate(2.0f - (abs(frac(_296 + 0.3333333432674408f) + -0.5f) * 6.0f)) * 2.0f;
      _319 = saturate(2.0f - (abs(frac(_296 + -0.3333333432674408f) + -0.5f) * 6.0f)) * 2.0f;
      _321 = g_bBrightness[0];
      _326 = _295 * _295;
      _330 = ((_293 * 0.25f) * (_326 * _326)) * (_321 / exp2(g_fExposureCompensationInEV100));
      _338 = ((_317 * _317) * _330);
      _339 = ((_318 * _318) * _330);
      _340 = ((_319 * _319) * _330);
    } else {
      _338 = _276;
      _339 = _277;
      _340 = _278;
    }
  } else {
    _338 = _276;
    _339 = _277;
    _340 = _278;
  }
  _343 = (g_bPostProcessApplyTonemap != 0);
  _345 = (g_bPostProcessApplyColorGrade != 0);
  if (!(g_bPostProcessApplyTonemap == 0)) {
    _354 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  } else {
    _354 = 1.0f;
  }
  if (_345) {
    _374 = max(_338, 0.0f);
    _375 = max(_339, 0.0f);
    _376 = max(_340, 0.0f);
  } else {
    _374 = _338;
    _375 = _339;
    _376 = _340;
  }
  _378 = g_bBrightness[1];
  _382 = exp2(g_fExposureCompensationInEV100) * _378;
  _383 = _382 * _374;
  _384 = _382 * _375;
  _385 = _382 * _376;
  if (!(g_bApplyVignette == 0)) {
    _394 = ((((g_vOverriddenAspectRatioUVScale.x * _21) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _395 = (((g_vOverriddenAspectRatioUVScale.y * _22) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _409 = saturate(exp2(log2(saturate(1.0f - sqrt((_394 * _394) + (_395 * _395))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _414 = (_409 * _383);
    _415 = (_409 * _384);
    _416 = (_409 * _385);
  } else {
    _414 = _383;
    _415 = _384;
    _416 = _385;
  }
  _419 = (g_bEnableHDRLUT == 0);
  if (!(_419 || (!_345))) {
    _435 = exp2(log2(saturate(_414 * 0.00800000037997961f)) * 0.1593017578125f);
    _436 = exp2(log2(saturate(_415 * 0.00800000037997961f)) * 0.1593017578125f);
    _437 = exp2(log2(saturate(_416 * 0.00800000037997961f)) * 0.1593017578125f);
    _465 = saturate(exp2(log2(((_435 * 18.8515625f) + 0.8359375f) / ((_435 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _466 = saturate(exp2(log2(((_436 * 18.8515625f) + 0.8359375f) / ((_436 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _467 = saturate(exp2(log2(((_437 * 18.8515625f) + 0.8359375f) / ((_437 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _471 = int(floor(_465));
    _472 = int(floor(_466));
    _473 = int(floor(_467));
    _477 = _465 - float((int)(_471));
    _478 = _466 - float((int)(_472));
    _479 = _467 - float((int)(_473));
    _484 = ((int)(uint)((int)(_479 > _477))) + ((int)(uint)((int)(_478 > _477)));
    _489 = ((int)(uint)((int)(_479 > _478))) + ((int)(uint)((int)(_477 >= _478)));
    _494 = ((int)(uint)((int)(_477 >= _479))) + ((int)(uint)((int)(_478 >= _479)));
    _495 = (_484 == 0);
    _496 = (_489 == 0);
    _497 = (_494 == 0);
    _515 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_473), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_471), (int)(0))), (int)(47))), min((int)(max((int)(_472), (int)(0))), (int)(47)), 0));
    _530 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_497))) + _473))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_495))) + _471))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_496))) + _472))), (int)(0))), (int)(47)), 0));
    _545 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_494 < (uint)2)))) + _473))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_484 < (uint)2)))) + _471))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_489 < (uint)2)))) + _472))), (int)(0))), (int)(47)), 0));
    _560 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_473 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_471 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_472 + 1u))), (int)(0))), (int)(47)), 0));
    _567 = dot(float3(_477, _478, _479), float3(((float)((bool)_495)), ((float)((bool)_496)), ((float)((bool)_497))));
    _574 = dot(float3(_477, _478, _479), float3(((float)((bool)(uint)(_484 == 2))), ((float)((bool)(uint)(_489 == 2))), ((float)((bool)(uint)(_494 == 2)))));
    _578 = (((_478 + _477) + _479) - _567) - _574;
    _579 = 1.0f - _567;
    _583 = _567 - _578;
    _587 = _578 - _574;
    _596 = (((_574 * _560.x) + (_579 * _515.x)) + (_583 * _530.x)) + (_587 * _545.x);
    _599 = (((_574 * _560.y) + (_579 * _515.y)) + (_583 * _530.y)) + (_587 * _545.y);
    _602 = (((_574 * _560.z) + (_579 * _515.z)) + (_583 * _530.z)) + (_587 * _545.z);
    _604 = mad(0.21580375730991364f, _602, mad(0.3963377773761749f, _599, _596));
    _606 = mad(-0.0638541728258133f, _602, mad(-0.10556134581565857f, _599, _596));
    _608 = mad(-1.2914855480194092f, _602, mad(-0.08948417752981186f, _599, _596));
    _612 = (_604 * _604) * _604;
    _613 = (_606 * _606) * _606;
    _614 = (_608 * _608) * _608;
    _617 = mad(0.23096993565559387f, _614, mad(-3.307711601257324f, _613, (_612 * 4.076741695404053f)));
    _620 = mad(-0.34131938219070435f, _614, mad(2.609757423400879f, _613, (_612 * -1.2684379816055298f)));
    _623 = mad(1.7076146602630615f, _614, mad(-0.7034186124801636f, _613, (_612 * -0.004196086432784796f)));
    _625 = dot(float3(_617, _620, _623), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _636 = (lerp(_625, _617, g_fTonemapSaturation));
    _637 = (lerp(_625, _620, g_fTonemapSaturation));
    _638 = (lerp(_625, _623, g_fTonemapSaturation));
  } else {
    _636 = _414;
    _637 = _415;
    _638 = _416;
  }
  if (_343) {
    do {
      _1194 = _636;
      _1195 = _637;
      _1196 = _638;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          if (TONE_MAP_TYPE == 0.f) {
            _644 = max(_636, 0.0f);
            _645 = max(_637, 0.0f);
            _646 = max(_638, 0.0f);
          } else {
            _644 = _636;
            _645 = _637;
            _646 = _638;
          }
          float3 agx_color = ApplyRemedyAgX(
              _644, _645, _646, _354,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
          _1194 = agx_color.x;
          _1195 = agx_color.y;
          _1196 = agx_color.z;
#else
          _644 = max(_636, 0.0f);
          _645 = max(_637, 0.0f);
          _646 = max(_638, 0.0f);
          _693 = g_fAgxMaxEV - g_fAgxMinEV;
          _697 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _646, mad(g_vAgxInsetRow0.y, _645, (g_vAgxInsetRow0.x * _644))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _693);
          _698 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _646, mad(g_vAgxInsetRow1.y, _645, (g_vAgxInsetRow1.x * _644))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _693);
          _699 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _646, mad(g_vAgxInsetRow2.y, _645, (g_vAgxInsetRow2.x * _644))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _693);
          _708 = (g_fAgxContrastSlope * (_697 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _709 = 1.0f / g_fAgxShoulderPower;
          _726 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _728 = _726 * (0.6060606241226196f - _697);
          _729 = 1.0f / g_fAgxToePower;
          _748 = -0.0f - g_fAgxToePrecalcConstant;
          _751 = select((_697 >= 0.6060606241226196f), ((_708 / exp2(log2((float((int)(((int)(uint)((int)(_708 > 0.0f))) - ((int)(uint)((int)(_708 < 0.0f))))) * exp2(log2(abs(_708)) * g_fAgxShoulderPower)) + 1.0f) * _709)) * g_fAgxShoulderPrecalcConstant), ((_728 / exp2(log2((float((int)(((int)(uint)((int)(_728 > 0.0f))) - ((int)(uint)((int)(_728 < 0.0f))))) * exp2(log2(abs(_728)) * g_fAgxToePower)) + 1.0f) * _729)) * _748)) + 0.4894371032714844f;
          _754 = (g_fAgxContrastSlope * (_698 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _772 = _726 * (0.6060606241226196f - _698);
          _793 = select((_698 >= 0.6060606241226196f), ((_754 / exp2(log2((float((int)(((int)(uint)((int)(_754 > 0.0f))) - ((int)(uint)((int)(_754 < 0.0f))))) * exp2(log2(abs(_754)) * g_fAgxShoulderPower)) + 1.0f) * _709)) * g_fAgxShoulderPrecalcConstant), ((_772 / exp2(log2((exp2(log2(abs(_772)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_772 > 0.0f))) - ((int)(uint)((int)(_772 < 0.0f)))))) + 1.0f) * _729)) * _748)) + 0.4894371032714844f;
          _796 = (g_fAgxContrastSlope * (_699 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _814 = _726 * (0.6060606241226196f - _699);
          _835 = select((_699 >= 0.6060606241226196f), ((_796 / exp2(log2((float((int)(((int)(uint)((int)(_796 > 0.0f))) - ((int)(uint)((int)(_796 < 0.0f))))) * exp2(log2(abs(_796)) * g_fAgxShoulderPower)) + 1.0f) * _709)) * g_fAgxShoulderPrecalcConstant), ((_814 / exp2(log2((exp2(log2(abs(_814)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_814 > 0.0f))) - ((int)(uint)((int)(_814 < 0.0f)))))) + 1.0f) * _729)) * _748)) + 0.4894371032714844f;
          _854 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _835, mad(g_vAgxOutsetRow0.y, _793, (_751 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _855 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _835, mad(g_vAgxOutsetRow1.y, _793, (_751 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _856 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _835, mad(g_vAgxOutsetRow2.y, _793, (_751 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _974 = _854;
            _975 = _855;
            _976 = _856;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_854, max(_855, _856)) >= g_fAgxHDRMidGrey))) {
                _867 = log2(1.0f / g_fAgxHDRMidGrey);
                _868 = _867 + 20.0f;
                _869 = log2(g_fAgxHDRRatio);
                _888 = (min(max(log2(max(_854, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _867) + 20.0f) / _868;
                _889 = (min(max(log2(max(_855, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _867) + 20.0f) / _868;
                _890 = (min(max(log2(max(_856, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _867) + 20.0f) / _868;
                _891 = 20.0f / _868;
                _895 = max(_888, max(_889, _890));
                _900 = ((_895 - _891) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _917 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_891 - _895);
                _939 = select((_895 >= _891), ((_900 / exp2(log2((float((int)(((int)(uint)((int)(_900 > 0.0f))) - ((int)(uint)((int)(_900 < 0.0f))))) * exp2(log2(abs(_900)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_917 / exp2(log2((float((int)(((int)(uint)((int)(_917 > 0.0f))) - ((int)(uint)((int)(_917 < 0.0f))))) * exp2(log2(abs(_917)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _869) / _868);
                _945 = exp2((((_939 - _895) * _868) + _869) * g_fAgxHDRSaturation);
                _974 = (saturate(exp2(((_939 + (_945 * (_888 - _895))) * _868) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _975 = (saturate(exp2(((_939 + (_945 * (_889 - _895))) * _868) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _976 = (saturate(exp2(((_939 + (_945 * (_890 - _895))) * _868) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _974 = _854;
                _975 = _855;
                _976 = _856;
              }
            }
            _1194 = (mad(-0.07283977419137955f, _976, mad(-0.5876564383506775f, _975, (_974 * 1.6604962348937988f))) * _354);
            _1195 = (mad(-0.008348013274371624f, _976, mad(1.1328951120376587f, _975, (_974 * -0.1245470941066742f))) * _354);
            _1196 = (mad(1.118751049041748f, _976, mad(-0.10059737414121628f, _975, (_974 * -0.018153680488467216f))) * _354);
          } while (false);
#endif
        } else {
          _644 = max(_636, 0.0f);
          _645 = max(_637, 0.0f);
          _646 = max(_638, 0.0f);
          _990 = dot(float3(_644, _645, _646), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
          do {
            _1000 = _644;
            _1001 = _645;
            _1002 = _646;
            if (!(_990 == 0.0f)) {
              _995 = max(dot(float3(_636, _637, _638), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _990;
              _1000 = (_995 * _644);
              _1001 = (_995 * _645);
              _1002 = (_995 * _646);
            }
            _1008 = max(max(_1000, max(_1001, _1002)), 0.0f);
            _1010 = 1.0f / max(_1008, 1.1754943508222875e-38f);
            _1016 = (pow(_1008, g_vTonemapGTParams.x));
            _1024 = _1016 / (((pow(_1016, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
            _1038 = exp2(log2(_1010 * _1000) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
            _1039 = exp2(log2(_1010 * _1001) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
            _1040 = exp2(log2(_1010 * _1002) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
            _1045 = log2(_1024);
            _1073 = saturate(exp2(log2((exp2(_1045 * g_vTonemapCrosstalk.x) * (1.0f - _1038)) + _1038) * g_vTonemapCrosstalkSaturation.x) * _1024);
            _1074 = saturate(exp2(log2((exp2(_1045 * g_vTonemapCrosstalk.y) * (1.0f - _1039)) + _1039) * g_vTonemapCrosstalkSaturation.y) * _1024);
            _1075 = saturate(exp2(log2((exp2(_1045 * g_vTonemapCrosstalk.z) * (1.0f - _1040)) + _1040) * g_vTonemapCrosstalkSaturation.z) * _1024);
            if (_419) {
              do {
                _1187 = _1073;
                _1188 = _1074;
                _1189 = _1075;
                if (_345) {
                  do {
                    [branch]
                    if (!(_1073 <= 0.0031308000907301903f)) {
                      _1088 = (((pow(_1073, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _1088 = (_1073 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_1074 <= 0.0031308000907301903f)) {
                        _1099 = (((pow(_1074, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _1099 = (_1074 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_1075 <= 0.0031308000907301903f)) {
                          _1110 = (((pow(_1075, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _1110 = (_1075 * 12.920000076293945f);
                        }
                        _1117 = (saturate(_1099) * 0.96875f) + 0.015625f;
                        _1119 = max((saturate(_1110) * 31.0f), 0.0f);
                        _1120 = floor(_1119);
                        _1121 = _1119 - _1120;
                        _1123 = (((saturate(_1088) * 0.96875f) + 0.015625f) + _1120) * 0.03125f;
                        _1125 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_1123, _1117), 0.0f);
                        _1129 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_1123 + 0.03125f), _1117), 0.0f);
                        _1139 = ((_1129.x - _1125.x) * _1121) + _1125.x;
                        _1140 = ((_1129.y - _1125.y) * _1121) + _1125.y;
                        _1141 = ((_1129.z - _1125.z) * _1121) + _1125.z;
                        do {
                          [branch]
                          if (!(_1139 <= 0.040449999272823334f)) {
                            _1152 = exp2(log2((_1139 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _1152 = (_1139 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_1140 <= 0.040449999272823334f)) {
                              _1163 = exp2(log2((_1140 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _1163 = (_1140 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_1141 <= 0.040449999272823334f)) {
                                _1174 = exp2(log2((_1141 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _1174 = (_1141 * 0.07739938050508499f);
                              }
                              _1176 = dot(float3(_1152, _1163, _1174), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _1187 = (lerp(_1176, _1152, g_fTonemapSaturation));
                              _1188 = (lerp(_1176, _1163, g_fTonemapSaturation));
                              _1189 = (lerp(_1176, _1174, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1194 = (_1187 * _354);
                _1195 = (_1188 * _354);
                _1196 = (_1189 * _354);
              } while (false);
            } else {
              _1194 = _1073;
              _1195 = _1074;
              _1196 = _1075;
            }
          } while (false);
        }
      }
      _1205 = (_1194 * g_fTonemapBrightness);
      _1206 = (_1195 * g_fTonemapBrightness);
      _1207 = (_1196 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1205 = (_636 * _354);
    _1206 = (_637 * _354);
    _1207 = (_638 * _354);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1219 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1226 = (_1219.x * 2.0f) + -1.0f;
    _1227 = (_1219.y * 2.0f) + -1.0f;
    _1228 = (_1219.z * 2.0f) + -1.0f;
    if (!(_343)) {
      _1231 = _1205 / _354;
      _1232 = _1206 / _354;
      _1233 = _1207 / _354;
      _1237 = 1.0f - sqrt(max(dot(float3(_1231, _1232, _1233), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
      _1242 = g_fFilmGrainIntensity * (_354 * 5.0f);
      _1305 = ((((_1242 * _1226) * saturate(_1231)) * _1237) + _1205);
      _1306 = ((((_1242 * _1227) * _1237) * saturate(_1232)) + _1206);
      _1307 = ((((_1242 * _1228) * _1237) * saturate(_1233)) + _1207);
    } else {
      _1256 = saturate(_1205);
      _1257 = saturate(_1206);
      _1258 = saturate(_1207);
      _1263 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_1256, max(_1257, _1258))));
      _1264 = _1263 * _1256;
      _1265 = _1263 * _1257;
      _1266 = _1263 * _1258;
      _1274 = ((1.0f - sqrt(dot(float3(_1264, _1265, _1266), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
      _1281 = ((_1274 * _1226) * min(1.0f, _1264)) + _1264;
      _1282 = ((_1274 * _1227) * min(1.0f, _1265)) + _1265;
      _1283 = ((_1274 * _1228) * min(1.0f, _1266)) + _1266;
      _1287 = 1.0f / (max(_1281, max(_1282, _1283)) + 1.0f);
      _1294 = 1.0f / (max(_1264, max(_1265, _1266)) + 1.0f);
      _1305 = (((_1281 * _1287) + _1205) - (_1294 * _1264));
      _1306 = (((_1282 * _1287) + _1206) - (_1294 * _1265));
      _1307 = (((_1283 * _1287) + _1207) - (_1294 * _1266));
    }
  } else {
    _1305 = _1205;
    _1306 = _1206;
    _1307 = _1207;
  }
  if (!(_280)) {
    _1311 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _1312 = (uint)(int(SV_Position.y)) + (uint)(-48);
    uint2 _1313;
    g_tBaseColorCorrectionMap.GetDimensions(_1313.x, _1313.y);
    if (((int)_1312 < (int)int(float((int)((int)(_1313.y))))) && (((int)(_1312 | _1311) > (int)-1) && ((int)_1311 < (int)int(float((int)((int)(_1313.x))))))) {
      _1327 = g_tBaseColorCorrectionMap.Load(int3(_1311, _1312, 0));
      if (!(_419)) {
        _1333 = mad(0.21580375730991364f, _1327.z, mad(0.3963377773761749f, _1327.y, _1327.x));
        _1335 = mad(-0.0638541728258133f, _1327.z, mad(-0.10556134581565857f, _1327.y, _1327.x));
        _1337 = mad(-1.2914855480194092f, _1327.z, mad(-0.08948417752981186f, _1327.y, _1327.x));
        _1341 = (_1333 * _1333) * _1333;
        _1342 = (_1335 * _1335) * _1335;
        _1343 = (_1337 * _1337) * _1337;
        _1386 = mad(0.23096993565559387f, _1343, mad(-3.307711601257324f, _1342, (_1341 * 4.076741695404053f)));
        _1387 = mad(-0.34131938219070435f, _1343, mad(2.609757423400879f, _1342, (_1341 * -1.2684379816055298f)));
        _1388 = mad(1.7076146602630615f, _1343, mad(-0.7034186124801636f, _1342, (_1341 * -0.004196086432784796f)));
      } else {
        do {
          [branch]
          if (!(_1327.x <= 0.040449999272823334f)) {
            _1364 = exp2(log2((_1327.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
          } else {
            _1364 = (_1327.x * 0.07739938050508499f);
          }
          do {
            [branch]
            if (!(_1327.y <= 0.040449999272823334f)) {
              _1375 = exp2(log2((_1327.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1375 = (_1327.y * 0.07739938050508499f);
            }
            [branch]
            if (!(_1327.z <= 0.040449999272823334f)) {
              _1386 = _1364;
              _1387 = _1375;
              _1388 = exp2(log2((_1327.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1386 = _1364;
              _1387 = _1375;
              _1388 = (_1327.z * 0.07739938050508499f);
            }
          } while (false);
        } while (false);
      }
    } else {
      _1386 = _1305;
      _1387 = _1306;
      _1388 = _1307;
    }
  } else {
    _1386 = _1305;
    _1387 = _1306;
    _1388 = _1307;
  }
  if (!(g_bDebugValidateOutputRange == 0)) {
    _1395 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
    do {
      _1408 = true;
      if (!(((_1386 < 0.0f) || (_1387 < 0.0f)) || (_1388 < 0.0f))) {
        _1408 = ((_1388 > _1395) || ((_1386 > _1395) || (_1387 > _1395)));
      }
      if (_1408) {
        _1414 = float((int)(int(g_fRealTime * 15.0f)));
        _1424 = select((((((int)((uint)(int(SV_Position.y - _1414)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1414)) / 5u))) & 1) == 0), 1.0f, 0.0f);
        _1429 = (_1424 * _1386);
        _1430 = (_1424 * _1387);
        _1431 = (_1424 * _1388);
      } else {
        _1429 = _1386;
        _1430 = _1387;
        _1431 = _1388;
      }
    } while (false);
  } else {
    _1429 = _1386;
    _1430 = _1387;
    _1431 = _1388;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1437 = (g_bHDR == 0);
    do {
      _1464 = _1429;
      _1465 = _1430;
      _1466 = _1431;
      if (!(_1437 || (g_bHDR_scRGB == 0))) {
        _1451 = max(mad(0.043306104838848114f, _1431, mad(0.329291969537735f, _1430, (_1429 * 0.6274019479751587f))), 0.0f);
        _1452 = max(mad(0.0113602289929986f, _1431, mad(0.9195442795753479f, _1430, (_1429 * 0.06909549236297607f))), 0.0f);
        _1453 = max(mad(0.895578145980835f, _1431, mad(0.08802816271781921f, _1430, (_1429 * 0.016393709927797318f))), 0.0f);
        _1464 = mad(-0.07283977419137955f, _1453, mad(-0.5876564383506775f, _1452, (_1451 * 1.6604962348937988f)));
        _1465 = mad(-0.008348013274371624f, _1453, mad(1.1328951120376587f, _1452, (_1451 * -0.1245470941066742f)));
        _1466 = mad(1.118751049041748f, _1453, mad(-0.10059737414121628f, _1452, (_1451 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1437)) {
        _1482 = mad(0.043306104838848114f, _1466, mad(0.329291969537735f, _1465, (_1464 * 0.6274019479751587f)));
        _1483 = mad(0.0113602289929986f, _1466, mad(0.9195442795753479f, _1465, (_1464 * 0.06909549236297607f)));
        _1484 = mad(0.895578145980835f, _1466, mad(0.08802816271781921f, _1465, (_1464 * 0.016393709927797318f)));
      } else {
        _1482 = _1464;
        _1483 = _1465;
        _1484 = _1466;
      }
    } while (false);
  } else {
    _1482 = _1429;
    _1483 = _1430;
    _1484 = _1431;
  }
  SV_Target.x = _1482;
  SV_Target.y = _1483;
  SV_Target.z = _1484;
  SV_Target.w = 1.0f;
  return SV_Target;
}
