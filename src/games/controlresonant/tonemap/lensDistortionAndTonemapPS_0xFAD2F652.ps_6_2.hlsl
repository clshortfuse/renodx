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
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
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
  float _502;
  float _503;
  float _504;
  float _906;
  float _907;
  float _908;
  float _932;
  float _933;
  float _934;
  float _1020;
  float _1031;
  float _1042;
  float _1084;
  float _1095;
  float _1106;
  float _1119;
  float _1120;
  float _1121;
  float _1126;
  float _1127;
  float _1128;
  float _1137;
  float _1138;
  float _1139;
  float _1237;
  float _1238;
  float _1239;
  float _1274;
  float _1285;
  float _1296;
  float _1297;
  float _1298;
  bool _1318;
  float _1339;
  float _1340;
  float _1341;
  float _1374;
  float _1375;
  float _1376;
  float _1392;
  float _1393;
  float _1394;
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
  float _467;
  float _468;
  float _469;
  float _471;
  float4 _473;
  float4 _477;
  float _487;
  float _488;
  float _489;
  float _491;
  float _510;
  float _511;
  float _512;
  float _559;
  float _563;
  float _564;
  float _565;
  float _574;
  float _575;
  float _592;
  float _594;
  float _595;
  float _614;
  float _617;
  float _620;
  float _638;
  float _659;
  float _662;
  float _680;
  float _701;
  float _720;
  float _721;
  float _722;
  float _733;
  float _734;
  float _747;
  float _748;
  float _749;
  float _756;
  float _759;
  float _764;
  float _779;
  float _782;
  float _801;
  float _807;
  float _824;
  float _848;
  float _865;
  float _922;
  float _927;
  float _940;
  float _942;
  float _948;
  float _956;
  float _970;
  float _971;
  float _972;
  float _977;
  float _1005;
  float _1006;
  float _1007;
  float _1049;
  float _1051;
  float _1052;
  float _1053;
  float _1055;
  float4 _1057;
  float4 _1061;
  float _1071;
  float _1072;
  float _1073;
  float _1108;
  float4 _1151;
  float _1158;
  float _1159;
  float _1160;
  float _1163;
  float _1164;
  float _1165;
  float _1169;
  float _1174;
  float _1188;
  float _1189;
  float _1190;
  float _1195;
  float _1196;
  float _1197;
  float _1198;
  float _1206;
  float _1213;
  float _1214;
  float _1215;
  float _1219;
  float _1226;
  uint _1243;
  uint _1244;
  uint2 _1245;
  float4 _1259;
  float _1305;
  float _1324;
  float _1334;
  bool _1347;
  float _1361;
  float _1362;
  float _1363;
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
    _354 = g_fPaperWhite;
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
  #if 1
    float3 graded_color = ApplyVanillaPQLUT(
      float3(_414, _415, _416), g_tBaseColorCorrectionMap, g_sLinearClamp_internal, g_fTonemapSaturation);
    _502 = graded_color.x;
    _503 = graded_color.y;
    _504 = graded_color.z;
  #else
    _435 = exp2(log2(saturate(_414 * 0.00800000037997961f)) * 0.1593017578125f);
    _436 = exp2(log2(saturate(_415 * 0.00800000037997961f)) * 0.1593017578125f);
    _437 = exp2(log2(saturate(_416 * 0.00800000037997961f)) * 0.1593017578125f);
    _465 = (exp2(log2(((_436 * 18.8515625f) + 0.8359375f) / ((_436 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
    _467 = max((exp2(log2(((_437 * 18.8515625f) + 0.8359375f) / ((_437 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
    _468 = floor(_467);
    _469 = _467 - _468;
    _471 = (((exp2(log2(((_435 * 18.8515625f) + 0.8359375f) / ((_435 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _468) * 0.02083333395421505f;
    _473 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_471, _465), 0.0f);
    _477 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_471 + 0.02083333395421505f), _465), 0.0f);
    _487 = ((_477.x - _473.x) * _469) + _473.x;
    _488 = ((_477.y - _473.y) * _469) + _473.y;
    _489 = ((_477.z - _473.z) * _469) + _473.z;
    _491 = dot(float3(_487, _488, _489), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _502 = (lerp(_491, _487, g_fTonemapSaturation));
    _503 = (lerp(_491, _488, g_fTonemapSaturation));
    _504 = (lerp(_491, _489, g_fTonemapSaturation));
  #endif
  } else {
    _502 = _414;
    _503 = _415;
    _504 = _416;
  }
  if (_343) {
    do {
      _1126 = _502;
      _1127 = _503;
      _1128 = _504;
      if (!(g_iTonemapper == 0)) {
        _510 = max(_502, 0.0f);
        _511 = max(_503, 0.0f);
        _512 = max(_504, 0.0f);
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _510, _511, _512, _354,
              g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes);
          _1126 = agx_color.x;
          _1127 = agx_color.y;
          _1128 = agx_color.z;
#else
          _559 = g_fAgxMaxEV - g_fAgxMinEV;
          _563 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _512, mad(g_vAgxInsetRow0.y, _511, (g_vAgxInsetRow0.x * _510))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _559);
          _564 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _512, mad(g_vAgxInsetRow1.y, _511, (g_vAgxInsetRow1.x * _510))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _559);
          _565 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _512, mad(g_vAgxInsetRow2.y, _511, (g_vAgxInsetRow2.x * _510))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _559);
          _574 = (g_fAgxContrastSlope * (_563 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _575 = 1.0f / g_fAgxShoulderPower;
          _592 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _594 = _592 * (0.6060606241226196f - _563);
          _595 = 1.0f / g_fAgxToePower;
          _614 = -0.0f - g_fAgxToePrecalcConstant;
          _617 = select((_563 >= 0.6060606241226196f), ((_574 / exp2(log2((float((int)(((int)(uint)((int)(_574 > 0.0f))) - ((int)(uint)((int)(_574 < 0.0f))))) * exp2(log2(abs(_574)) * g_fAgxShoulderPower)) + 1.0f) * _575)) * g_fAgxShoulderPrecalcConstant), ((_594 / exp2(log2((float((int)(((int)(uint)((int)(_594 > 0.0f))) - ((int)(uint)((int)(_594 < 0.0f))))) * exp2(log2(abs(_594)) * g_fAgxToePower)) + 1.0f) * _595)) * _614)) + 0.4894371032714844f;
          _620 = (g_fAgxContrastSlope * (_564 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _638 = _592 * (0.6060606241226196f - _564);
          _659 = select((_564 >= 0.6060606241226196f), ((_620 / exp2(log2((float((int)(((int)(uint)((int)(_620 > 0.0f))) - ((int)(uint)((int)(_620 < 0.0f))))) * exp2(log2(abs(_620)) * g_fAgxShoulderPower)) + 1.0f) * _575)) * g_fAgxShoulderPrecalcConstant), ((_638 / exp2(log2((exp2(log2(abs(_638)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_638 > 0.0f))) - ((int)(uint)((int)(_638 < 0.0f)))))) + 1.0f) * _595)) * _614)) + 0.4894371032714844f;
          _662 = (g_fAgxContrastSlope * (_565 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _680 = _592 * (0.6060606241226196f - _565);
          _701 = select((_565 >= 0.6060606241226196f), ((_662 / exp2(log2((float((int)(((int)(uint)((int)(_662 > 0.0f))) - ((int)(uint)((int)(_662 < 0.0f))))) * exp2(log2(abs(_662)) * g_fAgxShoulderPower)) + 1.0f) * _575)) * g_fAgxShoulderPrecalcConstant), ((_680 / exp2(log2((exp2(log2(abs(_680)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_680 > 0.0f))) - ((int)(uint)((int)(_680 < 0.0f)))))) + 1.0f) * _595)) * _614)) + 0.4894371032714844f;
          _720 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _701, mad(g_vAgxOutsetRow0.y, _659, (_617 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _721 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _701, mad(g_vAgxOutsetRow1.y, _659, (_617 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _722 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _701, mad(g_vAgxOutsetRow2.y, _659, (_617 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _906 = _720;
            _907 = _721;
            _908 = _722;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_720, max(_721, _722)) >= g_fAgxHDRMidGrey))) {
                _733 = log2(1.0f / g_fAgxHDRMidGrey);
                _734 = _733 + 20.0f;
                _747 = min(max(log2(max(_720, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _733);
                _748 = min(max(log2(max(_721, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _733);
                _749 = min(max(log2(max(_722, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _733);
                _756 = 20.0f / _734;
                _759 = (20.0f - log2(g_fAgxHDRRatio)) / _734;
                _764 = ((_747 / _734) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _779 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                _782 = ((-0.0f - _747) / _734) * _779;
                _801 = -0.0f - g_fAgxHDRToePrecalcConstant;
                _807 = ((_748 / _734) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _824 = ((-0.0f - _748) / _734) * _779;
                _848 = ((_749 / _734) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _865 = ((-0.0f - _749) / _734) * _779;
                _906 = (saturate(exp2(((select((((_747 + 20.0f) / _734) >= _756), ((_764 / exp2(log2((float((int)(((int)(uint)((int)(_764 > 0.0f))) - ((int)(uint)((int)(_764 < 0.0f))))) * exp2(log2(abs(_764)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_782 / exp2(log2((float((int)(((int)(uint)((int)(_782 > 0.0f))) - ((int)(uint)((int)(_782 < 0.0f))))) * exp2(log2(abs(_782)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _801)) + _759) * _734) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _907 = (saturate(exp2(((select((((_748 + 20.0f) / _734) >= _756), ((_807 / exp2(log2((float((int)(((int)(uint)((int)(_807 > 0.0f))) - ((int)(uint)((int)(_807 < 0.0f))))) * exp2(log2(abs(_807)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_824 / exp2(log2((float((int)(((int)(uint)((int)(_824 > 0.0f))) - ((int)(uint)((int)(_824 < 0.0f))))) * exp2(log2(abs(_824)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _801)) + _759) * _734) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _908 = (saturate(exp2(((select((((_749 + 20.0f) / _734) >= _756), ((_848 / exp2(log2((float((int)(((int)(uint)((int)(_848 > 0.0f))) - ((int)(uint)((int)(_848 < 0.0f))))) * exp2(log2(abs(_848)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_865 / exp2(log2((float((int)(((int)(uint)((int)(_865 > 0.0f))) - ((int)(uint)((int)(_865 < 0.0f))))) * exp2(log2(abs(_865)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _801)) + _759) * _734) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _906 = _720;
                _907 = _721;
                _908 = _722;
              }
            }
            _1126 = (mad(-0.07283977419137955f, _908, mad(-0.5876564383506775f, _907, (_906 * 1.6604962348937988f))) * _354);
            _1127 = (mad(-0.008348013274371624f, _908, mad(1.1328951120376587f, _907, (_906 * -0.1245470941066742f))) * _354);
            _1128 = (mad(1.118751049041748f, _908, mad(-0.10059737414121628f, _907, (_906 * -0.018153680488467216f))) * _354);
          } while (false);
#endif
        } else {
          _922 = dot(float3(_510, _511, _512), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
          do {
            _932 = _510;
            _933 = _511;
            _934 = _512;
            if (!(_922 == 0.0f)) {
              _927 = max(dot(float3(_502, _503, _504), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _922;
              _932 = (_927 * _510);
              _933 = (_927 * _511);
              _934 = (_927 * _512);
            }
            _940 = max(max(_932, max(_933, _934)), 0.0f);
            _942 = 1.0f / max(_940, 1.1754943508222875e-38f);
            _948 = (pow(_940, g_vTonemapGTParams.x));
            _956 = _948 / (((pow(_948, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
            _970 = exp2(log2(_942 * _932) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
            _971 = exp2(log2(_942 * _933) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
            _972 = exp2(log2(_942 * _934) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
            _977 = log2(_956);
            _1005 = saturate(exp2(log2((exp2(_977 * g_vTonemapCrosstalk.x) * (1.0f - _970)) + _970) * g_vTonemapCrosstalkSaturation.x) * _956);
            _1006 = saturate(exp2(log2((exp2(_977 * g_vTonemapCrosstalk.y) * (1.0f - _971)) + _971) * g_vTonemapCrosstalkSaturation.y) * _956);
            _1007 = saturate(exp2(log2((exp2(_977 * g_vTonemapCrosstalk.z) * (1.0f - _972)) + _972) * g_vTonemapCrosstalkSaturation.z) * _956);
            if (_419) {
              do {
                _1119 = _1005;
                _1120 = _1006;
                _1121 = _1007;
                if (_345) {
                  do {
                    [branch]
                    if (!(_1005 <= 0.0031308000907301903f)) {
                      _1020 = (((pow(_1005, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _1020 = (_1005 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_1006 <= 0.0031308000907301903f)) {
                        _1031 = (((pow(_1006, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _1031 = (_1006 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_1007 <= 0.0031308000907301903f)) {
                          _1042 = (((pow(_1007, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _1042 = (_1007 * 12.920000076293945f);
                        }
                        _1049 = (saturate(_1031) * 0.96875f) + 0.015625f;
                        _1051 = max((saturate(_1042) * 31.0f), 0.0f);
                        _1052 = floor(_1051);
                        _1053 = _1051 - _1052;
                        _1055 = (((saturate(_1020) * 0.96875f) + 0.015625f) + _1052) * 0.03125f;
                        _1057 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_1055, _1049), 0.0f);
                        _1061 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_1055 + 0.03125f), _1049), 0.0f);
                        _1071 = ((_1061.x - _1057.x) * _1053) + _1057.x;
                        _1072 = ((_1061.y - _1057.y) * _1053) + _1057.y;
                        _1073 = ((_1061.z - _1057.z) * _1053) + _1057.z;
                        do {
                          [branch]
                          if (!(_1071 <= 0.040449999272823334f)) {
                            _1084 = exp2(log2((_1071 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _1084 = (_1071 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_1072 <= 0.040449999272823334f)) {
                              _1095 = exp2(log2((_1072 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _1095 = (_1072 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_1073 <= 0.040449999272823334f)) {
                                _1106 = exp2(log2((_1073 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _1106 = (_1073 * 0.07739938050508499f);
                              }
                              _1108 = dot(float3(_1084, _1095, _1106), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _1119 = (lerp(_1108, _1084, g_fTonemapSaturation));
                              _1120 = (lerp(_1108, _1095, g_fTonemapSaturation));
                              _1121 = (lerp(_1108, _1106, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1126 = (_1119 * _354);
                _1127 = (_1120 * _354);
                _1128 = (_1121 * _354);
              } while (false);
            } else {
              _1126 = _1005;
              _1127 = _1006;
              _1128 = _1007;
            }
          } while (false);
        }
      }
      _1137 = (_1126 * g_fTonemapBrightness);
      _1138 = (_1127 * g_fTonemapBrightness);
      _1139 = (_1128 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1137 = (_502 * _354);
    _1138 = (_503 * _354);
    _1139 = (_504 * _354);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1151 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1158 = (_1151.x * 2.0f) + -1.0f;
    _1159 = (_1151.y * 2.0f) + -1.0f;
    _1160 = (_1151.z * 2.0f) + -1.0f;
    if (!(_343)) {
      _1163 = _1137 / _354;
      _1164 = _1138 / _354;
      _1165 = _1139 / _354;
      _1169 = 1.0f - sqrt(max(dot(float3(_1163, _1164, _1165), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
      _1174 = g_fFilmGrainIntensity * (_354 * 5.0f);
      _1237 = ((((_1174 * _1158) * saturate(_1163)) * _1169) + _1137);
      _1238 = ((((_1174 * _1159) * _1169) * saturate(_1164)) + _1138);
      _1239 = ((((_1174 * _1160) * _1169) * saturate(_1165)) + _1139);
    } else {
      _1188 = saturate(_1137);
      _1189 = saturate(_1138);
      _1190 = saturate(_1139);
      _1195 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_1188, max(_1189, _1190))));
      _1196 = _1195 * _1188;
      _1197 = _1195 * _1189;
      _1198 = _1195 * _1190;
      _1206 = ((1.0f - sqrt(dot(float3(_1196, _1197, _1198), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
      _1213 = ((_1206 * _1158) * min(1.0f, _1196)) + _1196;
      _1214 = ((_1206 * _1159) * min(1.0f, _1197)) + _1197;
      _1215 = ((_1206 * _1160) * min(1.0f, _1198)) + _1198;
      _1219 = 1.0f / (max(_1213, max(_1214, _1215)) + 1.0f);
      _1226 = 1.0f / (max(_1196, max(_1197, _1198)) + 1.0f);
      _1237 = (((_1213 * _1219) + _1137) - (_1226 * _1196));
      _1238 = (((_1214 * _1219) + _1138) - (_1226 * _1197));
      _1239 = (((_1215 * _1219) + _1139) - (_1226 * _1198));
    }
  } else {
    _1237 = _1137;
    _1238 = _1138;
    _1239 = _1139;
  }
  if (!(_280)) {
    _1243 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _1244 = (uint)(int(SV_Position.y)) + (uint)(-48);
    uint2 _1245; g_tBaseColorCorrectionMap.GetDimensions(_1245.x, _1245.y);
    if (((int)_1244 < (int)int(float((int)((int)(_1245.y))))) && (((int)(_1244 | _1243) > (int)-1) && ((int)_1243 < (int)int(float((int)((int)(_1245.x))))))) {
      _1259 = g_tBaseColorCorrectionMap.Load(int3(_1243, _1244, 0));
      if (_419) {
        do {
          [branch]
          if (!(_1259.x <= 0.040449999272823334f)) {
            _1274 = exp2(log2((_1259.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
          } else {
            _1274 = (_1259.x * 0.07739938050508499f);
          }
          do {
            [branch]
            if (!(_1259.y <= 0.040449999272823334f)) {
              _1285 = exp2(log2((_1259.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1285 = (_1259.y * 0.07739938050508499f);
            }
            [branch]
            if (!(_1259.z <= 0.040449999272823334f)) {
              _1296 = _1274;
              _1297 = _1285;
              _1298 = exp2(log2((_1259.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1296 = _1274;
              _1297 = _1285;
              _1298 = (_1259.z * 0.07739938050508499f);
            }
          } while (false);
        } while (false);
      } else {
        _1296 = _1259.x;
        _1297 = _1259.y;
        _1298 = _1259.z;
      }
    } else {
      _1296 = _1237;
      _1297 = _1238;
      _1298 = _1239;
    }
  } else {
    _1296 = _1237;
    _1297 = _1238;
    _1298 = _1239;
  }
  if (!(g_bDebugValidateOutputRange == 0)) {
    _1305 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
    do {
      _1318 = true;
      if (!(((_1296 < 0.0f) || (_1297 < 0.0f)) || (_1298 < 0.0f))) {
        _1318 = ((_1298 > _1305) || ((_1296 > _1305) || (_1297 > _1305)));
      }
      if (_1318) {
        _1324 = float((int)(int(g_fRealTime * 15.0f)));
        _1334 = select((((((int)((uint)(int(SV_Position.y - _1324)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1324)) / 5u))) & 1) == 0), 1.0f, 0.0f);
        _1339 = (_1334 * _1296);
        _1340 = (_1334 * _1297);
        _1341 = (_1334 * _1298);
      } else {
        _1339 = _1296;
        _1340 = _1297;
        _1341 = _1298;
      }
    } while (false);
  } else {
    _1339 = _1296;
    _1340 = _1297;
    _1341 = _1298;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1347 = (g_bHDR == 0);
    do {
      _1374 = _1339;
      _1375 = _1340;
      _1376 = _1341;
      if (!(_1347 || (g_bHDR_scRGB == 0))) {
        _1361 = max(mad(0.043306104838848114f, _1341, mad(0.329291969537735f, _1340, (_1339 * 0.6274019479751587f))), 0.0f);
        _1362 = max(mad(0.0113602289929986f, _1341, mad(0.9195442795753479f, _1340, (_1339 * 0.06909549236297607f))), 0.0f);
        _1363 = max(mad(0.895578145980835f, _1341, mad(0.08802816271781921f, _1340, (_1339 * 0.016393709927797318f))), 0.0f);
        _1374 = mad(-0.07283977419137955f, _1363, mad(-0.5876564383506775f, _1362, (_1361 * 1.6604962348937988f)));
        _1375 = mad(-0.008348013274371624f, _1363, mad(1.1328951120376587f, _1362, (_1361 * -0.1245470941066742f)));
        _1376 = mad(1.118751049041748f, _1363, mad(-0.10059737414121628f, _1362, (_1361 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1347)) {
        _1392 = mad(0.043306104838848114f, _1376, mad(0.329291969537735f, _1375, (_1374 * 0.6274019479751587f)));
        _1393 = mad(0.0113602289929986f, _1376, mad(0.9195442795753479f, _1375, (_1374 * 0.06909549236297607f)));
        _1394 = mad(0.895578145980835f, _1376, mad(0.08802816271781921f, _1375, (_1374 * 0.016393709927797318f)));
      } else {
        _1392 = _1374;
        _1393 = _1375;
        _1394 = _1376;
      }
    } while (false);
  } else {
    _1392 = _1339;
    _1393 = _1340;
    _1394 = _1341;
  }
  SV_Target.x = _1392;
  SV_Target.y = _1393;
  SV_Target.z = _1394;
  SV_Target.w = 1.0f;
  return SV_Target;
}