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
  float _501;
  float _502;
  float _503;
  float _905;
  float _906;
  float _907;
  float _935;
  float _936;
  float _937;
  float _1022;
  float _1033;
  float _1044;
  float _1086;
  float _1097;
  float _1108;
  float _1121;
  float _1122;
  float _1123;
  float _1282;
  float _1283;
  float _1284;
  float _1293;
  float _1294;
  float _1295;
  float _1343;
  float _1344;
  float _1345;
  float _1380;
  float _1391;
  float _1402;
  float _1403;
  float _1404;
  bool _1433;
  float _1454;
  float _1455;
  float _1456;
  float _1489;
  float _1490;
  float _1491;
  float _1507;
  float _1508;
  float _1509;
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
  float _466;
  float _467;
  float _468;
  float _470;
  float4 _472;
  float4 _476;
  float _486;
  float _487;
  float _488;
  float _490;
  float _534;
  float _535;
  float _536;
  float _558;
  float _562;
  float _563;
  float _564;
  float _573;
  float _574;
  float _591;
  float _593;
  float _594;
  float _613;
  float _616;
  float _619;
  float _637;
  float _658;
  float _661;
  float _679;
  float _700;
  float _719;
  float _720;
  float _721;
  float _732;
  float _733;
  float _746;
  float _747;
  float _748;
  float _755;
  float _758;
  float _763;
  float _778;
  float _781;
  float _800;
  float _806;
  float _823;
  float _847;
  float _864;
  float _922;
  float _923;
  float _924;
  float _925;
  float _930;
  float _943;
  float _945;
  float _951;
  float _959;
  float _973;
  float _974;
  float _975;
  float _980;
  float _1008;
  float _1009;
  float _1010;
  float _1051;
  float _1053;
  float _1054;
  float _1055;
  float _1057;
  float4 _1059;
  float4 _1063;
  float _1073;
  float _1074;
  float _1075;
  float _1110;
  float _1132;
  float _1137;
  float _1139;
  float _1140;
  float _1141;
  float _1142;
  float _1152;
  float _1156;
  float _1205;
  float _1206;
  float _1207;
  float _1212;
  float _1225;
  float _1226;
  float _1227;
  float _1259;
  float _1261;
  float _1263;
  float _1264;
  float _1277;
  float4 _1307;
  float _1317;
  float _1318;
  float _1319;
  float _1323;
  float _1329;
  uint _1349;
  uint _1350;
  uint2 _1351;
  float4 _1365;
  float _1410;
  float _1413;
  float _1416;
  float _1420;
  float _1439;
  float _1449;
  bool _1462;
  float _1476;
  float _1477;
  float _1478;
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
    _464 = (exp2(log2(((_435 * 18.8515625f) + 0.8359375f) / ((_435 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
    _466 = max((exp2(log2(((_436 * 18.8515625f) + 0.8359375f) / ((_436 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
    _467 = floor(_466);
    _468 = _466 - _467;
    _470 = (((exp2(log2(((_434 * 18.8515625f) + 0.8359375f) / ((_434 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _467) * 0.02083333395421505f;
    _472 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_470, _464), 0.0f);
    _476 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_470 + 0.02083333395421505f), _464), 0.0f);
    _486 = ((_476.x - _472.x) * _468) + _472.x;
    _487 = ((_476.y - _472.y) * _468) + _472.y;
    _488 = ((_476.z - _472.z) * _468) + _472.z;
    _490 = dot(float3(_486, _487, _488), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _501 = (lerp(_490, _486, g_fTonemapSaturation));
    _502 = (lerp(_490, _487, g_fTonemapSaturation));
    _503 = (lerp(_490, _488, g_fTonemapSaturation));
  } else {
    _501 = _413;
    _502 = _414;
    _503 = _415;
  }
  if (!(_343)) {
    do {
      _1282 = _501;
      _1283 = _502;
      _1284 = _503;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _501, _502, _503, _353,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes);
          _1282 = agx_color.x;
          _1283 = agx_color.y;
          _1284 = agx_color.z;
#else
          _534 = max(_501, 0.0f);
          _535 = max(_502, 0.0f);
          _536 = max(_503, 0.0f);
          _558 = g_fAgxMaxEV - g_fAgxMinEV;
          _562 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _536, mad(g_vAgxInsetRow0.y, _535, (_534 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _558);
          _563 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _536, mad(g_vAgxInsetRow1.y, _535, (_534 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _558);
          _564 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _536, mad(g_vAgxInsetRow2.y, _535, (_534 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _558);
          _573 = (g_fAgxContrastSlope * (_562 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _574 = 1.0f / g_fAgxShoulderPower;
          _591 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _593 = _591 * (0.6060606241226196f - _562);
          _594 = 1.0f / g_fAgxToePower;
          _613 = -0.0f - g_fAgxToePrecalcConstant;
          _616 = select((_562 >= 0.6060606241226196f), ((_573 / exp2(log2((float((int)(((int)(uint)((int)(_573 > 0.0f))) - ((int)(uint)((int)(_573 < 0.0f))))) * exp2(log2(abs(_573)) * g_fAgxShoulderPower)) + 1.0f) * _574)) * g_fAgxShoulderPrecalcConstant), ((_593 / exp2(log2((float((int)(((int)(uint)((int)(_593 > 0.0f))) - ((int)(uint)((int)(_593 < 0.0f))))) * exp2(log2(abs(_593)) * g_fAgxToePower)) + 1.0f) * _594)) * _613)) + 0.4894371032714844f;
          _619 = (g_fAgxContrastSlope * (_563 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _637 = _591 * (0.6060606241226196f - _563);
          _658 = select((_563 >= 0.6060606241226196f), ((_619 / exp2(log2((float((int)(((int)(uint)((int)(_619 > 0.0f))) - ((int)(uint)((int)(_619 < 0.0f))))) * exp2(log2(abs(_619)) * g_fAgxShoulderPower)) + 1.0f) * _574)) * g_fAgxShoulderPrecalcConstant), ((_637 / exp2(log2((exp2(log2(abs(_637)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_637 > 0.0f))) - ((int)(uint)((int)(_637 < 0.0f)))))) + 1.0f) * _594)) * _613)) + 0.4894371032714844f;
          _661 = (g_fAgxContrastSlope * (_564 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _679 = _591 * (0.6060606241226196f - _564);
          _700 = select((_564 >= 0.6060606241226196f), ((_661 / exp2(log2((float((int)(((int)(uint)((int)(_661 > 0.0f))) - ((int)(uint)((int)(_661 < 0.0f))))) * exp2(log2(abs(_661)) * g_fAgxShoulderPower)) + 1.0f) * _574)) * g_fAgxShoulderPrecalcConstant), ((_679 / exp2(log2((exp2(log2(abs(_679)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_679 > 0.0f))) - ((int)(uint)((int)(_679 < 0.0f)))))) + 1.0f) * _594)) * _613)) + 0.4894371032714844f;
          _719 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _700, mad(g_vAgxOutsetRow0.y, _658, (_616 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _720 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _700, mad(g_vAgxOutsetRow1.y, _658, (_616 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _721 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _700, mad(g_vAgxOutsetRow2.y, _658, (_616 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _905 = _719;
            _906 = _720;
            _907 = _721;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_719, max(_720, _721)) >= g_fAgxHDRMidGrey))) {
                _732 = log2(1.0f / g_fAgxHDRMidGrey);
                _733 = _732 + 20.0f;
                _746 = min(max(log2(max(_719, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _732);
                _747 = min(max(log2(max(_720, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _732);
                _748 = min(max(log2(max(_721, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _732);
                _755 = 20.0f / _733;
                _758 = (20.0f - log2(g_fAgxHDRRatio)) / _733;
                _763 = ((_746 / _733) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _778 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                _781 = ((-0.0f - _746) / _733) * _778;
                _800 = -0.0f - g_fAgxHDRToePrecalcConstant;
                _806 = ((_747 / _733) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _823 = ((-0.0f - _747) / _733) * _778;
                _847 = ((_748 / _733) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _864 = ((-0.0f - _748) / _733) * _778;
                _905 = (saturate(exp2(((select((((_746 + 20.0f) / _733) >= _755), ((_763 / exp2(log2((float((int)(((int)(uint)((int)(_763 > 0.0f))) - ((int)(uint)((int)(_763 < 0.0f))))) * exp2(log2(abs(_763)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_781 / exp2(log2((float((int)(((int)(uint)((int)(_781 > 0.0f))) - ((int)(uint)((int)(_781 < 0.0f))))) * exp2(log2(abs(_781)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _800)) + _758) * _733) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _906 = (saturate(exp2(((select((((_747 + 20.0f) / _733) >= _755), ((_806 / exp2(log2((float((int)(((int)(uint)((int)(_806 > 0.0f))) - ((int)(uint)((int)(_806 < 0.0f))))) * exp2(log2(abs(_806)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_823 / exp2(log2((float((int)(((int)(uint)((int)(_823 > 0.0f))) - ((int)(uint)((int)(_823 < 0.0f))))) * exp2(log2(abs(_823)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _800)) + _758) * _733) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _907 = (saturate(exp2(((select((((_748 + 20.0f) / _733) >= _755), ((_847 / exp2(log2((float((int)(((int)(uint)((int)(_847 > 0.0f))) - ((int)(uint)((int)(_847 < 0.0f))))) * exp2(log2(abs(_847)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_864 / exp2(log2((float((int)(((int)(uint)((int)(_864 > 0.0f))) - ((int)(uint)((int)(_864 < 0.0f))))) * exp2(log2(abs(_864)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _800)) + _758) * _733) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _905 = _719;
                _906 = _720;
                _907 = _721;
              }
            }
            _1282 = (mad(-0.07283977419137955f, _907, mad(-0.5876564383506775f, _906, (_905 * 1.6604962348937988f))) * _353);
            _1283 = (mad(-0.008348013274371624f, _907, mad(1.1328951120376587f, _906, (_905 * -0.1245470941066742f))) * _353);
            _1284 = (mad(1.118751049041748f, _907, mad(-0.10059737414121628f, _906, (_905 * -0.018153680488467216f))) * _353);
          } while (false);
#endif
        } else {
          if (_418) {
            _922 = max(_501, 0.0f);
            _923 = max(_502, 0.0f);
            _924 = max(_503, 0.0f);
            _925 = dot(float3(_922, _923, _924), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            do {
              _935 = _922;
              _936 = _923;
              _937 = _924;
              if (!(_925 == 0.0f)) {
                _930 = max(dot(float3(_501, _502, _503), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _925;
                _935 = (_930 * _922);
                _936 = (_930 * _923);
                _937 = (_930 * _924);
              }
              _943 = max(max(_935, max(_936, _937)), 0.0f);
              _945 = 1.0f / max(_943, 1.1754943508222875e-38f);
              _951 = (pow(_943, g_vTonemapGTParams.x));
              _959 = _951 / (((pow(_951, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
              _973 = exp2(log2(_945 * _935) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
              _974 = exp2(log2(_945 * _936) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
              _975 = exp2(log2(_945 * _937) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
              _980 = log2(_959);
              _1008 = saturate(exp2(log2((exp2(_980 * g_vTonemapCrosstalk.x) * (1.0f - _973)) + _973) * g_vTonemapCrosstalkSaturation.x) * _959);
              _1009 = saturate(exp2(log2((exp2(_980 * g_vTonemapCrosstalk.y) * (1.0f - _974)) + _974) * g_vTonemapCrosstalkSaturation.y) * _959);
              _1010 = saturate(exp2(log2((exp2(_980 * g_vTonemapCrosstalk.z) * (1.0f - _975)) + _975) * g_vTonemapCrosstalkSaturation.z) * _959);
              do {
                _1121 = _1008;
                _1122 = _1009;
                _1123 = _1010;
                if (_345) {
                  do {
                    [branch]
                    if (!(_1008 <= 0.0031308000907301903f)) {
                      _1022 = (((pow(_1008, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _1022 = (_1008 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_1009 <= 0.0031308000907301903f)) {
                        _1033 = (((pow(_1009, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _1033 = (_1009 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_1010 <= 0.0031308000907301903f)) {
                          _1044 = (((pow(_1010, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _1044 = (_1010 * 12.920000076293945f);
                        }
                        _1051 = (saturate(_1033) * 0.96875f) + 0.015625f;
                        _1053 = max((saturate(_1044) * 31.0f), 0.0f);
                        _1054 = floor(_1053);
                        _1055 = _1053 - _1054;
                        _1057 = (((saturate(_1022) * 0.96875f) + 0.015625f) + _1054) * 0.03125f;
                        _1059 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_1057, _1051), 0.0f);
                        _1063 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_1057 + 0.03125f), _1051), 0.0f);
                        _1073 = ((_1063.x - _1059.x) * _1055) + _1059.x;
                        _1074 = ((_1063.y - _1059.y) * _1055) + _1059.y;
                        _1075 = ((_1063.z - _1059.z) * _1055) + _1059.z;
                        do {
                          [branch]
                          if (!(_1073 <= 0.040449999272823334f)) {
                            _1086 = exp2(log2((_1073 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _1086 = (_1073 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_1074 <= 0.040449999272823334f)) {
                              _1097 = exp2(log2((_1074 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _1097 = (_1074 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_1075 <= 0.040449999272823334f)) {
                                _1108 = exp2(log2((_1075 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _1108 = (_1075 * 0.07739938050508499f);
                              }
                              _1110 = dot(float3(_1086, _1097, _1108), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _1121 = (lerp(_1110, _1086, g_fTonemapSaturation));
                              _1122 = (lerp(_1110, _1097, g_fTonemapSaturation));
                              _1123 = (lerp(_1110, _1108, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1282 = (_1121 * _353);
                _1283 = (_1122 * _353);
                _1284 = (_1123 * _353);
              } while (false);
            } while (false);
          } else {
            _1132 = g_fMaxOutputNits * 0.012500000186264515f;
            _1137 = max(abs(_501), max(abs(_502), abs(_503)));
            _1139 = 1.0f / max(_1137, 1.1754943508222875e-38f);
            _1140 = _1139 * _501;
            _1141 = _1139 * _502;
            _1142 = _1139 * _503;
            _1152 = (_353 * 0.18000000715255737f) * exp2(log2((pow(_1137, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
            _1156 = dot(float3((_1152 * _1140), (_1152 * _1141), (_1152 * _1142)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1205 = exp2(log2(abs(_1140)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_1140 > 0.0f))) - ((int)(uint)((int)(_1140 < 0.0f)))));
            _1206 = exp2(log2(abs(_1141)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_1141 > 0.0f))) - ((int)(uint)((int)(_1141 < 0.0f)))));
            _1207 = exp2(log2(abs(_1142)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_1142 > 0.0f))) - ((int)(uint)((int)(_1142 < 0.0f)))));
            _1212 = log2(saturate(select((_1156 <= 0.0f), _1156, ((1.0f - exp2(log2(exp2((_1156 / _1132) * -1.4426950216293335f)))) * _1132)) / _1132));
            _1225 = (exp2(_1212 * g_vTonemapCrosstalk.x) * (1.0f - _1205)) + _1205;
            _1226 = (exp2(_1212 * g_vTonemapCrosstalk.y) * (1.0f - _1206)) + _1206;
            _1227 = (exp2(_1212 * g_vTonemapCrosstalk.z) * (1.0f - _1207)) + _1207;
            _1259 = (float((int)(((int)(uint)((int)(_1225 > 0.0f))) - ((int)(uint)((int)(_1225 < 0.0f))))) * _1152) * exp2(log2(abs(_1225)) * g_vTonemapCrosstalkSaturation.x);
            _1261 = (float((int)(((int)(uint)((int)(_1226 > 0.0f))) - ((int)(uint)((int)(_1226 < 0.0f))))) * _1152) * exp2(log2(abs(_1226)) * g_vTonemapCrosstalkSaturation.y);
            _1263 = (float((int)(((int)(uint)((int)(_1227 > 0.0f))) - ((int)(uint)((int)(_1227 < 0.0f))))) * _1152) * exp2(log2(abs(_1227)) * g_vTonemapCrosstalkSaturation.z);
            _1264 = dot(float3(_1259, _1261, _1263), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1277 = select((_1264 <= 0.0f), _1264, ((1.0f - exp2(log2(exp2((_1264 / _1132) * -1.4426950216293335f)))) * _1132)) * select((!(_1264 == 0.0f)), (1.0f / _1264), 0.0f);
            _1282 = (_1277 * _1259);
            _1283 = (_1277 * _1261);
            _1284 = (_1277 * _1263);
          }
        }
      }
      _1293 = (_1282 * g_fTonemapBrightness);
      _1294 = (_1283 * g_fTonemapBrightness);
      _1295 = (_1284 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1293 = (_501 * _353);
    _1294 = (_502 * _353);
    _1295 = (_503 * _353);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1307 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1317 = _1293 / _353;
    _1318 = _1294 / _353;
    _1319 = _1295 / _353;
    _1323 = 1.0f - sqrt(max(dot(float3(_1317, _1318, _1319), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
    _1329 = g_fFilmGrainIntensity * (_353 * 5.0f);
    _1343 = ((((_1329 * ((_1307.x * 2.0f) + -1.0f)) * saturate(_1317)) * _1323) + _1293);
    _1344 = ((((_1329 * ((_1307.y * 2.0f) + -1.0f)) * _1323) * saturate(_1318)) + _1294);
    _1345 = ((((_1329 * ((_1307.z * 2.0f) + -1.0f)) * _1323) * saturate(_1319)) + _1295);
  } else {
    _1343 = _1293;
    _1344 = _1294;
    _1345 = _1295;
  }
  if (!(_280)) {
    _1349 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _1350 = (uint)(int(SV_Position.y)) + (uint)(-48);
    uint2 _1351;
    g_tBaseColorCorrectionMap.GetDimensions(_1351.x, _1351.y);
    if (((int)_1350 < (int)int(float((int)((int)(_1351.y))))) && (((int)(_1350 | _1349) > (int)-1) && ((int)_1349 < (int)int(float((int)((int)(_1351.x))))))) {
      _1365 = g_tBaseColorCorrectionMap.Load(int3(_1349, _1350, 0));
      if (_418) {
        do {
          [branch]
          if (!(_1365.x <= 0.040449999272823334f)) {
            _1380 = exp2(log2((_1365.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
          } else {
            _1380 = (_1365.x * 0.07739938050508499f);
          }
          do {
            [branch]
            if (!(_1365.y <= 0.040449999272823334f)) {
              _1391 = exp2(log2((_1365.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1391 = (_1365.y * 0.07739938050508499f);
            }
            [branch]
            if (!(_1365.z <= 0.040449999272823334f)) {
              _1402 = _1380;
              _1403 = _1391;
              _1404 = exp2(log2((_1365.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1402 = _1380;
              _1403 = _1391;
              _1404 = (_1365.z * 0.07739938050508499f);
            }
          } while (false);
        } while (false);
      } else {
        _1402 = _1365.x;
        _1403 = _1365.y;
        _1404 = _1365.z;
      }
    } else {
      _1402 = _1343;
      _1403 = _1344;
      _1404 = _1345;
    }
  } else {
    _1402 = _1343;
    _1403 = _1344;
    _1404 = _1345;
  }
  if (!(g_bDebugValidateOutputRange == 0)) {
    _1410 = mad(0.043306104838848114f, _1404, mad(0.329291969537735f, _1403, (_1402 * 0.6274019479751587f)));
    _1413 = mad(0.0113602289929986f, _1404, mad(0.9195442795753479f, _1403, (_1402 * 0.06909549236297607f)));
    _1416 = mad(0.895578145980835f, _1404, mad(0.08802816271781921f, _1403, (_1402 * 0.016393709927797318f)));
    _1420 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
    do {
      _1433 = true;
      if (!(((_1410 < 0.0f) || (_1413 < 0.0f)) || (_1416 < 0.0f))) {
        _1433 = ((_1416 > _1420) || ((_1410 > _1420) || (_1413 > _1420)));
      }
      if (_1433) {
        _1439 = float((int)(int(g_fRealTime * 15.0f)));
        _1449 = select((((((int)((uint)(int(SV_Position.y - _1439)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1439)) / 5u))) & 1) == 0), 1.0f, 0.0f);
        _1454 = (_1449 * _1402);
        _1455 = (_1449 * _1403);
        _1456 = (_1449 * _1404);
      } else {
        _1454 = _1402;
        _1455 = _1403;
        _1456 = _1404;
      }
    } while (false);
  } else {
    _1454 = _1402;
    _1455 = _1403;
    _1456 = _1404;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1462 = (g_bHDR == 0);
    do {
      _1489 = _1454;
      _1490 = _1455;
      _1491 = _1456;
      if (!(_1462 || (g_bHDR_scRGB == 0))) {
        _1476 = max(mad(0.043306104838848114f, _1456, mad(0.329291969537735f, _1455, (_1454 * 0.6274019479751587f))), 0.0f);
        _1477 = max(mad(0.0113602289929986f, _1456, mad(0.9195442795753479f, _1455, (_1454 * 0.06909549236297607f))), 0.0f);
        _1478 = max(mad(0.895578145980835f, _1456, mad(0.08802816271781921f, _1455, (_1454 * 0.016393709927797318f))), 0.0f);
        _1489 = mad(-0.07283977419137955f, _1478, mad(-0.5876564383506775f, _1477, (_1476 * 1.6604962348937988f)));
        _1490 = mad(-0.008348013274371624f, _1478, mad(1.1328951120376587f, _1477, (_1476 * -0.1245470941066742f)));
        _1491 = mad(1.118751049041748f, _1478, mad(-0.10059737414121628f, _1477, (_1476 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1462)) {
        _1507 = mad(0.043306104838848114f, _1491, mad(0.329291969537735f, _1490, (_1489 * 0.6274019479751587f)));
        _1508 = mad(0.0113602289929986f, _1491, mad(0.9195442795753479f, _1490, (_1489 * 0.06909549236297607f)));
        _1509 = mad(0.895578145980835f, _1491, mad(0.08802816271781921f, _1490, (_1489 * 0.016393709927797318f)));
      } else {
        _1507 = _1489;
        _1508 = _1490;
        _1509 = _1491;
      }
    } while (false);
  } else {
    _1507 = _1454;
    _1508 = _1455;
    _1509 = _1456;
  }
  SV_Target.x = _1507;
  SV_Target.y = _1508;
  SV_Target.z = _1509;
  SV_Target.w = 1.0f;
  return SV_Target;
}
