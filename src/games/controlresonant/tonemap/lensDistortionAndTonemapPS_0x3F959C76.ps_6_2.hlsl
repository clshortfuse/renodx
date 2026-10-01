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
  float _353;
  float _373;
  float _374;
  float _375;
  float _413;
  float _414;
  float _415;
  float _635;
  float _636;
  float _637;
  float _973;
  float _974;
  float _975;
  float _1003;
  float _1004;
  float _1005;
  float _1090;
  float _1101;
  float _1112;
  float _1154;
  float _1165;
  float _1176;
  float _1189;
  float _1190;
  float _1191;
  float _1350;
  float _1351;
  float _1352;
  float _1361;
  float _1362;
  float _1363;
  float _1411;
  float _1412;
  float _1413;
  float _1470;
  float _1481;
  float _1492;
  float _1493;
  float _1494;
  bool _1523;
  float _1544;
  float _1545;
  float _1546;
  float _1579;
  float _1580;
  float _1581;
  float _1597;
  float _1598;
  float _1599;
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
  float _377;
  float _381;
  float _382;
  float _383;
  float _384;
  float _393;
  float _394;
  float _408;
  bool _418;
  float _434;
  float _435;
  float _436;
  float _464;
  float _465;
  float _466;
  int _470;
  int _471;
  int _472;
  float _476;
  float _477;
  float _478;
  int _483;
  int _488;
  int _493;
  bool _494;
  bool _495;
  bool _496;
  float4 _514;
  float4 _529;
  float4 _544;
  float4 _559;
  float _566;
  float _573;
  float _577;
  float _578;
  float _582;
  float _586;
  float _595;
  float _598;
  float _601;
  float _603;
  float _605;
  float _607;
  float _611;
  float _612;
  float _613;
  float _616;
  float _619;
  float _622;
  float _624;
  float _668;
  float _669;
  float _670;
  float _692;
  float _696;
  float _697;
  float _698;
  float _707;
  float _708;
  float _725;
  float _727;
  float _728;
  float _747;
  float _750;
  float _753;
  float _771;
  float _792;
  float _795;
  float _813;
  float _834;
  float _853;
  float _854;
  float _855;
  float _866;
  float _867;
  float _868;
  float _887;
  float _888;
  float _889;
  float _890;
  float _894;
  float _899;
  float _916;
  float _938;
  float _944;
  float _990;
  float _991;
  float _992;
  float _993;
  float _998;
  float _1011;
  float _1013;
  float _1019;
  float _1027;
  float _1041;
  float _1042;
  float _1043;
  float _1048;
  float _1076;
  float _1077;
  float _1078;
  float _1119;
  float _1121;
  float _1122;
  float _1123;
  float _1125;
  float4 _1127;
  float4 _1131;
  float _1141;
  float _1142;
  float _1143;
  float _1178;
  float _1200;
  float _1205;
  float _1207;
  float _1208;
  float _1209;
  float _1210;
  float _1220;
  float _1224;
  float _1273;
  float _1274;
  float _1275;
  float _1280;
  float _1293;
  float _1294;
  float _1295;
  float _1327;
  float _1329;
  float _1331;
  float _1332;
  float _1345;
  float4 _1375;
  float _1385;
  float _1386;
  float _1387;
  float _1391;
  float _1397;
  uint _1417;
  uint _1418;
  uint2 _1419;
  float4 _1433;
  float _1439;
  float _1441;
  float _1443;
  float _1447;
  float _1448;
  float _1449;
  float _1500;
  float _1503;
  float _1506;
  float _1510;
  float _1529;
  float _1539;
  bool _1552;
  float _1566;
  float _1567;
  float _1568;
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
  _343 = (g_bPostProcessApplyTonemap == 0);
  _345 = (g_bPostProcessApplyColorGrade != 0);
  if (!(_343)) {
    _353 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  } else {
    _353 = 1.0f;
  }
  if (_345) {
    _373 = max(_338, 0.0f);
    _374 = max(_339, 0.0f);
    _375 = max(_340, 0.0f);
  } else {
    _373 = _338;
    _374 = _339;
    _375 = _340;
  }
  _377 = g_bBrightness[1];
  _381 = exp2(g_fExposureCompensationInEV100) * _377;
  _382 = _381 * _373;
  _383 = _381 * _374;
  _384 = _381 * _375;
  if (!(g_bApplyVignette == 0)) {
    _393 = ((((g_vOverriddenAspectRatioUVScale.x * _21) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _394 = (((g_vOverriddenAspectRatioUVScale.y * _22) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _408 = saturate(exp2(log2(saturate(1.0f - sqrt((_393 * _393) + (_394 * _394))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _413 = (_408 * _382);
    _414 = (_408 * _383);
    _415 = (_408 * _384);
  } else {
    _413 = _382;
    _414 = _383;
    _415 = _384;
  }
  _418 = (g_bEnableHDRLUT == 0);
  if (!(_418 || (!_345))) {
    _434 = exp2(log2(saturate(_413 * 0.00800000037997961f)) * 0.1593017578125f);
    _435 = exp2(log2(saturate(_414 * 0.00800000037997961f)) * 0.1593017578125f);
    _436 = exp2(log2(saturate(_415 * 0.00800000037997961f)) * 0.1593017578125f);
    _464 = saturate(exp2(log2(((_434 * 18.8515625f) + 0.8359375f) / ((_434 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _465 = saturate(exp2(log2(((_435 * 18.8515625f) + 0.8359375f) / ((_435 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _466 = saturate(exp2(log2(((_436 * 18.8515625f) + 0.8359375f) / ((_436 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _470 = int(floor(_464));
    _471 = int(floor(_465));
    _472 = int(floor(_466));
    _476 = _464 - float((int)(_470));
    _477 = _465 - float((int)(_471));
    _478 = _466 - float((int)(_472));
    _483 = ((int)(uint)((int)(_478 > _476))) + ((int)(uint)((int)(_477 > _476)));
    _488 = ((int)(uint)((int)(_478 > _477))) + ((int)(uint)((int)(_476 >= _477)));
    _493 = ((int)(uint)((int)(_476 >= _478))) + ((int)(uint)((int)(_477 >= _478)));
    _494 = (_483 == 0);
    _495 = (_488 == 0);
    _496 = (_493 == 0);
    _514 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_472), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_470), (int)(0))), (int)(47))), min((int)(max((int)(_471), (int)(0))), (int)(47)), 0));
    _529 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_496))) + _472))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_494))) + _470))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_495))) + _471))), (int)(0))), (int)(47)), 0));
    _544 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_493 < (uint)2)))) + _472))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_483 < (uint)2)))) + _470))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_488 < (uint)2)))) + _471))), (int)(0))), (int)(47)), 0));
    _559 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_472 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_470 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_471 + 1u))), (int)(0))), (int)(47)), 0));
    _566 = dot(float3(_476, _477, _478), float3(((float)((bool)_494)), ((float)((bool)_495)), ((float)((bool)_496))));
    _573 = dot(float3(_476, _477, _478), float3(((float)((bool)(uint)(_483 == 2))), ((float)((bool)(uint)(_488 == 2))), ((float)((bool)(uint)(_493 == 2)))));
    _577 = (((_477 + _476) + _478) - _566) - _573;
    _578 = 1.0f - _566;
    _582 = _566 - _577;
    _586 = _577 - _573;
    _595 = (((_573 * _559.x) + (_578 * _514.x)) + (_582 * _529.x)) + (_586 * _544.x);
    _598 = (((_573 * _559.y) + (_578 * _514.y)) + (_582 * _529.y)) + (_586 * _544.y);
    _601 = (((_573 * _559.z) + (_578 * _514.z)) + (_582 * _529.z)) + (_586 * _544.z);
    _603 = mad(0.21580375730991364f, _601, mad(0.3963377773761749f, _598, _595));
    _605 = mad(-0.0638541728258133f, _601, mad(-0.10556134581565857f, _598, _595));
    _607 = mad(-1.2914855480194092f, _601, mad(-0.08948417752981186f, _598, _595));
    _611 = (_603 * _603) * _603;
    _612 = (_605 * _605) * _605;
    _613 = (_607 * _607) * _607;
    _616 = mad(0.23096993565559387f, _613, mad(-3.307711601257324f, _612, (_611 * 4.076741695404053f)));
    _619 = mad(-0.34131938219070435f, _613, mad(2.609757423400879f, _612, (_611 * -1.2684379816055298f)));
    _622 = mad(1.7076146602630615f, _613, mad(-0.7034186124801636f, _612, (_611 * -0.004196086432784796f)));
    _624 = dot(float3(_616, _619, _622), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _635 = (lerp(_624, _616, g_fTonemapSaturation));
    _636 = (lerp(_624, _619, g_fTonemapSaturation));
    _637 = (lerp(_624, _622, g_fTonemapSaturation));
  } else {
    _635 = _413;
    _636 = _414;
    _637 = _415;
  }
  if (!(_343)) {
    do {
      _1350 = _635;
      _1351 = _636;
      _1352 = _637;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _635, _636, _637, _353,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
          _1350 = agx_color.x;
          _1351 = agx_color.y;
          _1352 = agx_color.z;
#else
          _668 = max(_635, 0.0f);
          _669 = max(_636, 0.0f);
          _670 = max(_637, 0.0f);
          _692 = g_fAgxMaxEV - g_fAgxMinEV;
          _696 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _670, mad(g_vAgxInsetRow0.y, _669, (_668 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _692);
          _697 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _670, mad(g_vAgxInsetRow1.y, _669, (_668 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _692);
          _698 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _670, mad(g_vAgxInsetRow2.y, _669, (_668 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _692);
          _707 = (g_fAgxContrastSlope * (_696 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _708 = 1.0f / g_fAgxShoulderPower;
          _725 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _727 = _725 * (0.6060606241226196f - _696);
          _728 = 1.0f / g_fAgxToePower;
          _747 = -0.0f - g_fAgxToePrecalcConstant;
          _750 = select((_696 >= 0.6060606241226196f), ((_707 / exp2(log2((float((int)(((int)(uint)((int)(_707 > 0.0f))) - ((int)(uint)((int)(_707 < 0.0f))))) * exp2(log2(abs(_707)) * g_fAgxShoulderPower)) + 1.0f) * _708)) * g_fAgxShoulderPrecalcConstant), ((_727 / exp2(log2((float((int)(((int)(uint)((int)(_727 > 0.0f))) - ((int)(uint)((int)(_727 < 0.0f))))) * exp2(log2(abs(_727)) * g_fAgxToePower)) + 1.0f) * _728)) * _747)) + 0.4894371032714844f;
          _753 = (g_fAgxContrastSlope * (_697 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _771 = _725 * (0.6060606241226196f - _697);
          _792 = select((_697 >= 0.6060606241226196f), ((_753 / exp2(log2((float((int)(((int)(uint)((int)(_753 > 0.0f))) - ((int)(uint)((int)(_753 < 0.0f))))) * exp2(log2(abs(_753)) * g_fAgxShoulderPower)) + 1.0f) * _708)) * g_fAgxShoulderPrecalcConstant), ((_771 / exp2(log2((exp2(log2(abs(_771)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_771 > 0.0f))) - ((int)(uint)((int)(_771 < 0.0f)))))) + 1.0f) * _728)) * _747)) + 0.4894371032714844f;
          _795 = (g_fAgxContrastSlope * (_698 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _813 = _725 * (0.6060606241226196f - _698);
          _834 = select((_698 >= 0.6060606241226196f), ((_795 / exp2(log2((float((int)(((int)(uint)((int)(_795 > 0.0f))) - ((int)(uint)((int)(_795 < 0.0f))))) * exp2(log2(abs(_795)) * g_fAgxShoulderPower)) + 1.0f) * _708)) * g_fAgxShoulderPrecalcConstant), ((_813 / exp2(log2((exp2(log2(abs(_813)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_813 > 0.0f))) - ((int)(uint)((int)(_813 < 0.0f)))))) + 1.0f) * _728)) * _747)) + 0.4894371032714844f;
          _853 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _834, mad(g_vAgxOutsetRow0.y, _792, (_750 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _854 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _834, mad(g_vAgxOutsetRow1.y, _792, (_750 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _855 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _834, mad(g_vAgxOutsetRow2.y, _792, (_750 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _973 = _853;
            _974 = _854;
            _975 = _855;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_853, max(_854, _855)) >= g_fAgxHDRMidGrey))) {
                _866 = log2(1.0f / g_fAgxHDRMidGrey);
                _867 = _866 + 20.0f;
                _868 = log2(g_fAgxHDRRatio);
                _887 = (min(max(log2(max(_853, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _866) + 20.0f) / _867;
                _888 = (min(max(log2(max(_854, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _866) + 20.0f) / _867;
                _889 = (min(max(log2(max(_855, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _866) + 20.0f) / _867;
                _890 = 20.0f / _867;
                _894 = max(_887, max(_888, _889));
                _899 = ((_894 - _890) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _916 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_890 - _894);
                _938 = select((_894 >= _890), ((_899 / exp2(log2((float((int)(((int)(uint)((int)(_899 > 0.0f))) - ((int)(uint)((int)(_899 < 0.0f))))) * exp2(log2(abs(_899)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_916 / exp2(log2((float((int)(((int)(uint)((int)(_916 > 0.0f))) - ((int)(uint)((int)(_916 < 0.0f))))) * exp2(log2(abs(_916)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _868) / _867);
                _944 = exp2((((_938 - _894) * _867) + _868) * g_fAgxHDRSaturation);
                _973 = (saturate(exp2(((_938 + (_944 * (_887 - _894))) * _867) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _974 = (saturate(exp2(((_938 + (_944 * (_888 - _894))) * _867) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _975 = (saturate(exp2(((_938 + (_944 * (_889 - _894))) * _867) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _973 = _853;
                _974 = _854;
                _975 = _855;
              }
            }
            _1350 = (mad(-0.07283977419137955f, _975, mad(-0.5876564383506775f, _974, (_973 * 1.6604962348937988f))) * _353);
            _1351 = (mad(-0.008348013274371624f, _975, mad(1.1328951120376587f, _974, (_973 * -0.1245470941066742f))) * _353);
            _1352 = (mad(1.118751049041748f, _975, mad(-0.10059737414121628f, _974, (_973 * -0.018153680488467216f))) * _353);
          } while (false);
#endif
        } else {
          if (_418) {
            _990 = max(_635, 0.0f);
            _991 = max(_636, 0.0f);
            _992 = max(_637, 0.0f);
            _993 = dot(float3(_990, _991, _992), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            do {
              _1003 = _990;
              _1004 = _991;
              _1005 = _992;
              if (!(_993 == 0.0f)) {
                _998 = max(dot(float3(_635, _636, _637), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _993;
                _1003 = (_998 * _990);
                _1004 = (_998 * _991);
                _1005 = (_998 * _992);
              }
              _1011 = max(max(_1003, max(_1004, _1005)), 0.0f);
              _1013 = 1.0f / max(_1011, 1.1754943508222875e-38f);
              _1019 = (pow(_1011, g_vTonemapGTParams.x));
              _1027 = _1019 / (((pow(_1019, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
              _1041 = exp2(log2(_1013 * _1003) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
              _1042 = exp2(log2(_1013 * _1004) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
              _1043 = exp2(log2(_1013 * _1005) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
              _1048 = log2(_1027);
              _1076 = saturate(exp2(log2((exp2(_1048 * g_vTonemapCrosstalk.x) * (1.0f - _1041)) + _1041) * g_vTonemapCrosstalkSaturation.x) * _1027);
              _1077 = saturate(exp2(log2((exp2(_1048 * g_vTonemapCrosstalk.y) * (1.0f - _1042)) + _1042) * g_vTonemapCrosstalkSaturation.y) * _1027);
              _1078 = saturate(exp2(log2((exp2(_1048 * g_vTonemapCrosstalk.z) * (1.0f - _1043)) + _1043) * g_vTonemapCrosstalkSaturation.z) * _1027);
              do {
                _1189 = _1076;
                _1190 = _1077;
                _1191 = _1078;
                if (_345) {
                  do {
                    [branch]
                    if (!(_1076 <= 0.0031308000907301903f)) {
                      _1090 = (((pow(_1076, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _1090 = (_1076 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_1077 <= 0.0031308000907301903f)) {
                        _1101 = (((pow(_1077, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _1101 = (_1077 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_1078 <= 0.0031308000907301903f)) {
                          _1112 = (((pow(_1078, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _1112 = (_1078 * 12.920000076293945f);
                        }
                        _1119 = (saturate(_1101) * 0.96875f) + 0.015625f;
                        _1121 = max((saturate(_1112) * 31.0f), 0.0f);
                        _1122 = floor(_1121);
                        _1123 = _1121 - _1122;
                        _1125 = (((saturate(_1090) * 0.96875f) + 0.015625f) + _1122) * 0.03125f;
                        _1127 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_1125, _1119), 0.0f);
                        _1131 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_1125 + 0.03125f), _1119), 0.0f);
                        _1141 = ((_1131.x - _1127.x) * _1123) + _1127.x;
                        _1142 = ((_1131.y - _1127.y) * _1123) + _1127.y;
                        _1143 = ((_1131.z - _1127.z) * _1123) + _1127.z;
                        do {
                          [branch]
                          if (!(_1141 <= 0.040449999272823334f)) {
                            _1154 = exp2(log2((_1141 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _1154 = (_1141 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_1142 <= 0.040449999272823334f)) {
                              _1165 = exp2(log2((_1142 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _1165 = (_1142 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_1143 <= 0.040449999272823334f)) {
                                _1176 = exp2(log2((_1143 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _1176 = (_1143 * 0.07739938050508499f);
                              }
                              _1178 = dot(float3(_1154, _1165, _1176), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _1189 = (lerp(_1178, _1154, g_fTonemapSaturation));
                              _1190 = (lerp(_1178, _1165, g_fTonemapSaturation));
                              _1191 = (lerp(_1178, _1176, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1350 = (_1189 * _353);
                _1351 = (_1190 * _353);
                _1352 = (_1191 * _353);
              } while (false);
            } while (false);
          } else {
            _1200 = g_fMaxOutputNits * 0.012500000186264515f;
            _1205 = max(abs(_635), max(abs(_636), abs(_637)));
            _1207 = 1.0f / max(_1205, 1.1754943508222875e-38f);
            _1208 = _1207 * _635;
            _1209 = _1207 * _636;
            _1210 = _1207 * _637;
            _1220 = (_353 * 0.18000000715255737f) * exp2(log2((pow(_1205, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
            _1224 = dot(float3((_1220 * _1208), (_1220 * _1209), (_1220 * _1210)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1273 = exp2(log2(abs(_1208)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_1208 > 0.0f))) - ((int)(uint)((int)(_1208 < 0.0f)))));
            _1274 = exp2(log2(abs(_1209)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_1209 > 0.0f))) - ((int)(uint)((int)(_1209 < 0.0f)))));
            _1275 = exp2(log2(abs(_1210)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_1210 > 0.0f))) - ((int)(uint)((int)(_1210 < 0.0f)))));
            _1280 = log2(saturate(select((_1224 <= 0.0f), _1224, ((1.0f - exp2(log2(exp2((_1224 / _1200) * -1.4426950216293335f)))) * _1200)) / _1200));
            _1293 = (exp2(_1280 * g_vTonemapCrosstalk.x) * (1.0f - _1273)) + _1273;
            _1294 = (exp2(_1280 * g_vTonemapCrosstalk.y) * (1.0f - _1274)) + _1274;
            _1295 = (exp2(_1280 * g_vTonemapCrosstalk.z) * (1.0f - _1275)) + _1275;
            _1327 = (float((int)(((int)(uint)((int)(_1293 > 0.0f))) - ((int)(uint)((int)(_1293 < 0.0f))))) * _1220) * exp2(log2(abs(_1293)) * g_vTonemapCrosstalkSaturation.x);
            _1329 = (float((int)(((int)(uint)((int)(_1294 > 0.0f))) - ((int)(uint)((int)(_1294 < 0.0f))))) * _1220) * exp2(log2(abs(_1294)) * g_vTonemapCrosstalkSaturation.y);
            _1331 = (float((int)(((int)(uint)((int)(_1295 > 0.0f))) - ((int)(uint)((int)(_1295 < 0.0f))))) * _1220) * exp2(log2(abs(_1295)) * g_vTonemapCrosstalkSaturation.z);
            _1332 = dot(float3(_1327, _1329, _1331), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1345 = select((_1332 <= 0.0f), _1332, ((1.0f - exp2(log2(exp2((_1332 / _1200) * -1.4426950216293335f)))) * _1200)) * select((!(_1332 == 0.0f)), (1.0f / _1332), 0.0f);
            _1350 = (_1345 * _1327);
            _1351 = (_1345 * _1329);
            _1352 = (_1345 * _1331);
          }
        }
      }
      _1361 = (_1350 * g_fTonemapBrightness);
      _1362 = (_1351 * g_fTonemapBrightness);
      _1363 = (_1352 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1361 = (_635 * _353);
    _1362 = (_636 * _353);
    _1363 = (_637 * _353);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1375 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1385 = _1361 / _353;
    _1386 = _1362 / _353;
    _1387 = _1363 / _353;
    _1391 = 1.0f - sqrt(max(dot(float3(_1385, _1386, _1387), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
    _1397 = g_fFilmGrainIntensity * (_353 * 5.0f);
    _1411 = ((((_1397 * ((_1375.x * 2.0f) + -1.0f)) * saturate(_1385)) * _1391) + _1361);
    _1412 = ((((_1397 * ((_1375.y * 2.0f) + -1.0f)) * _1391) * saturate(_1386)) + _1362);
    _1413 = ((((_1397 * ((_1375.z * 2.0f) + -1.0f)) * _1391) * saturate(_1387)) + _1363);
  } else {
    _1411 = _1361;
    _1412 = _1362;
    _1413 = _1363;
  }
  if (!(_280)) {
    _1417 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _1418 = (uint)(int(SV_Position.y)) + (uint)(-48);
    uint2 _1419;
    g_tBaseColorCorrectionMap.GetDimensions(_1419.x, _1419.y);
    if (((int)_1418 < (int)int(float((int)((int)(_1419.y))))) && (((int)(_1418 | _1417) > (int)-1) && ((int)_1417 < (int)int(float((int)((int)(_1419.x))))))) {
      _1433 = g_tBaseColorCorrectionMap.Load(int3(_1417, _1418, 0));
      if (!(_418)) {
        _1439 = mad(0.21580375730991364f, _1433.z, mad(0.3963377773761749f, _1433.y, _1433.x));
        _1441 = mad(-0.0638541728258133f, _1433.z, mad(-0.10556134581565857f, _1433.y, _1433.x));
        _1443 = mad(-1.2914855480194092f, _1433.z, mad(-0.08948417752981186f, _1433.y, _1433.x));
        _1447 = (_1439 * _1439) * _1439;
        _1448 = (_1441 * _1441) * _1441;
        _1449 = (_1443 * _1443) * _1443;
        _1492 = mad(0.23096993565559387f, _1449, mad(-3.307711601257324f, _1448, (_1447 * 4.076741695404053f)));
        _1493 = mad(-0.34131938219070435f, _1449, mad(2.609757423400879f, _1448, (_1447 * -1.2684379816055298f)));
        _1494 = mad(1.7076146602630615f, _1449, mad(-0.7034186124801636f, _1448, (_1447 * -0.004196086432784796f)));
      } else {
        do {
          [branch]
          if (!(_1433.x <= 0.040449999272823334f)) {
            _1470 = exp2(log2((_1433.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
          } else {
            _1470 = (_1433.x * 0.07739938050508499f);
          }
          do {
            [branch]
            if (!(_1433.y <= 0.040449999272823334f)) {
              _1481 = exp2(log2((_1433.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1481 = (_1433.y * 0.07739938050508499f);
            }
            [branch]
            if (!(_1433.z <= 0.040449999272823334f)) {
              _1492 = _1470;
              _1493 = _1481;
              _1494 = exp2(log2((_1433.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1492 = _1470;
              _1493 = _1481;
              _1494 = (_1433.z * 0.07739938050508499f);
            }
          } while (false);
        } while (false);
      }
    } else {
      _1492 = _1411;
      _1493 = _1412;
      _1494 = _1413;
    }
  } else {
    _1492 = _1411;
    _1493 = _1412;
    _1494 = _1413;
  }
  if (!(g_bDebugValidateOutputRange == 0)) {
    _1500 = mad(0.043306104838848114f, _1494, mad(0.329291969537735f, _1493, (_1492 * 0.6274019479751587f)));
    _1503 = mad(0.0113602289929986f, _1494, mad(0.9195442795753479f, _1493, (_1492 * 0.06909549236297607f)));
    _1506 = mad(0.895578145980835f, _1494, mad(0.08802816271781921f, _1493, (_1492 * 0.016393709927797318f)));
    _1510 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
    do {
      _1523 = true;
      if (!(((_1500 < 0.0f) || (_1503 < 0.0f)) || (_1506 < 0.0f))) {
        _1523 = ((_1506 > _1510) || ((_1500 > _1510) || (_1503 > _1510)));
      }
      if (_1523) {
        _1529 = float((int)(int(g_fRealTime * 15.0f)));
        _1539 = select((((((int)((uint)(int(SV_Position.y - _1529)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1529)) / 5u))) & 1) == 0), 1.0f, 0.0f);
        _1544 = (_1539 * _1492);
        _1545 = (_1539 * _1493);
        _1546 = (_1539 * _1494);
      } else {
        _1544 = _1492;
        _1545 = _1493;
        _1546 = _1494;
      }
    } while (false);
  } else {
    _1544 = _1492;
    _1545 = _1493;
    _1546 = _1494;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1552 = (g_bHDR == 0);
    do {
      _1579 = _1544;
      _1580 = _1545;
      _1581 = _1546;
      if (!(_1552 || (g_bHDR_scRGB == 0))) {
        _1566 = max(mad(0.043306104838848114f, _1546, mad(0.329291969537735f, _1545, (_1544 * 0.6274019479751587f))), 0.0f);
        _1567 = max(mad(0.0113602289929986f, _1546, mad(0.9195442795753479f, _1545, (_1544 * 0.06909549236297607f))), 0.0f);
        _1568 = max(mad(0.895578145980835f, _1546, mad(0.08802816271781921f, _1545, (_1544 * 0.016393709927797318f))), 0.0f);
        _1579 = mad(-0.07283977419137955f, _1568, mad(-0.5876564383506775f, _1567, (_1566 * 1.6604962348937988f)));
        _1580 = mad(-0.008348013274371624f, _1568, mad(1.1328951120376587f, _1567, (_1566 * -0.1245470941066742f)));
        _1581 = mad(1.118751049041748f, _1568, mad(-0.10059737414121628f, _1567, (_1566 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1552)) {
        _1597 = mad(0.043306104838848114f, _1581, mad(0.329291969537735f, _1580, (_1579 * 0.6274019479751587f)));
        _1598 = mad(0.0113602289929986f, _1581, mad(0.9195442795753479f, _1580, (_1579 * 0.06909549236297607f)));
        _1599 = mad(0.895578145980835f, _1581, mad(0.08802816271781921f, _1580, (_1579 * 0.016393709927797318f)));
      } else {
        _1597 = _1579;
        _1598 = _1580;
        _1599 = _1581;
      }
    } while (false);
  } else {
    _1597 = _1544;
    _1598 = _1545;
    _1599 = _1546;
  }
  SV_Target.x = _1597;
  SV_Target.y = _1598;
  SV_Target.z = _1599;
  SV_Target.w = 1.0f;
  return SV_Target;
}
