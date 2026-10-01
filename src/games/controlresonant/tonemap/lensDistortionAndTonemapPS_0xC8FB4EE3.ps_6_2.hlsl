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
  float _160;
  float _180;
  float _181;
  float _182;
  float _220;
  float _221;
  float _222;
  float _442;
  float _443;
  float _444;
  float _780;
  float _781;
  float _782;
  float _810;
  float _811;
  float _812;
  float _897;
  float _908;
  float _919;
  float _961;
  float _972;
  float _983;
  float _996;
  float _997;
  float _998;
  float _1157;
  float _1158;
  float _1159;
  float _1168;
  float _1169;
  float _1170;
  float _1218;
  float _1219;
  float _1220;
  float _1277;
  float _1288;
  float _1299;
  float _1300;
  float _1301;
  bool _1330;
  float _1351;
  float _1352;
  float _1353;
  float _1386;
  float _1387;
  float _1388;
  float _1404;
  float _1405;
  float _1406;
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
  float _184;
  float _188;
  float _189;
  float _190;
  float _191;
  float _200;
  float _201;
  float _215;
  bool _225;
  float _241;
  float _242;
  float _243;
  float _271;
  float _272;
  float _273;
  int _277;
  int _278;
  int _279;
  float _283;
  float _284;
  float _285;
  int _290;
  int _295;
  int _300;
  bool _301;
  bool _302;
  bool _303;
  float4 _321;
  float4 _336;
  float4 _351;
  float4 _366;
  float _373;
  float _380;
  float _384;
  float _385;
  float _389;
  float _393;
  float _402;
  float _405;
  float _408;
  float _410;
  float _412;
  float _414;
  float _418;
  float _419;
  float _420;
  float _423;
  float _426;
  float _429;
  float _431;
  float _475;
  float _476;
  float _477;
  float _499;
  float _503;
  float _504;
  float _505;
  float _514;
  float _515;
  float _532;
  float _534;
  float _535;
  float _554;
  float _557;
  float _560;
  float _578;
  float _599;
  float _602;
  float _620;
  float _641;
  float _660;
  float _661;
  float _662;
  float _673;
  float _674;
  float _675;
  float _694;
  float _695;
  float _696;
  float _697;
  float _701;
  float _706;
  float _723;
  float _745;
  float _751;
  float _797;
  float _798;
  float _799;
  float _800;
  float _805;
  float _818;
  float _820;
  float _826;
  float _834;
  float _848;
  float _849;
  float _850;
  float _855;
  float _883;
  float _884;
  float _885;
  float _926;
  float _928;
  float _929;
  float _930;
  float _932;
  float4 _934;
  float4 _938;
  float _948;
  float _949;
  float _950;
  float _985;
  float _1007;
  float _1012;
  float _1014;
  float _1015;
  float _1016;
  float _1017;
  float _1027;
  float _1031;
  float _1080;
  float _1081;
  float _1082;
  float _1087;
  float _1100;
  float _1101;
  float _1102;
  float _1134;
  float _1136;
  float _1138;
  float _1139;
  float _1152;
  float4 _1182;
  float _1192;
  float _1193;
  float _1194;
  float _1198;
  float _1204;
  uint _1224;
  uint _1225;
  uint2 _1226;
  float4 _1240;
  float _1246;
  float _1248;
  float _1250;
  float _1254;
  float _1255;
  float _1256;
  float _1307;
  float _1310;
  float _1313;
  float _1317;
  float _1336;
  float _1346;
  bool _1359;
  float _1373;
  float _1374;
  float _1375;
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
  _150 = (g_bPostProcessApplyTonemap == 0);
  _152 = (g_bPostProcessApplyColorGrade != 0);
  if (!(_150)) {
    _160 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  } else {
    _160 = 1.0f;
  }
  if (_152) {
    _180 = max(_145, 0.0f);
    _181 = max(_146, 0.0f);
    _182 = max(_147, 0.0f);
  } else {
    _180 = _145;
    _181 = _146;
    _182 = _147;
  }
  _184 = g_bBrightness[1];
  _188 = exp2(g_fExposureCompensationInEV100) * _184;
  _189 = _188 * _180;
  _190 = _188 * _181;
  _191 = _188 * _182;
  if (!(g_bApplyVignette == 0)) {
    _200 = ((((g_vOverriddenAspectRatioUVScale.x * _20) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _201 = (((g_vOverriddenAspectRatioUVScale.y * _21) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _215 = saturate(exp2(log2(saturate(1.0f - sqrt((_200 * _200) + (_201 * _201))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _220 = (_215 * _189);
    _221 = (_215 * _190);
    _222 = (_215 * _191);
  } else {
    _220 = _189;
    _221 = _190;
    _222 = _191;
  }
  _225 = (g_bEnableHDRLUT == 0);
  if (!(_225 || (!_152))) {
    _241 = exp2(log2(saturate(_220 * 0.00800000037997961f)) * 0.1593017578125f);
    _242 = exp2(log2(saturate(_221 * 0.00800000037997961f)) * 0.1593017578125f);
    _243 = exp2(log2(saturate(_222 * 0.00800000037997961f)) * 0.1593017578125f);
    _271 = saturate(exp2(log2(((_241 * 18.8515625f) + 0.8359375f) / ((_241 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _272 = saturate(exp2(log2(((_242 * 18.8515625f) + 0.8359375f) / ((_242 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _273 = saturate(exp2(log2(((_243 * 18.8515625f) + 0.8359375f) / ((_243 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _277 = int(floor(_271));
    _278 = int(floor(_272));
    _279 = int(floor(_273));
    _283 = _271 - float((int)(_277));
    _284 = _272 - float((int)(_278));
    _285 = _273 - float((int)(_279));
    _290 = ((int)(uint)((int)(_285 > _283))) + ((int)(uint)((int)(_284 > _283)));
    _295 = ((int)(uint)((int)(_285 > _284))) + ((int)(uint)((int)(_283 >= _284)));
    _300 = ((int)(uint)((int)(_283 >= _285))) + ((int)(uint)((int)(_284 >= _285)));
    _301 = (_290 == 0);
    _302 = (_295 == 0);
    _303 = (_300 == 0);
    _321 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_279), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_277), (int)(0))), (int)(47))), min((int)(max((int)(_278), (int)(0))), (int)(47)), 0));
    _336 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_303))) + _279))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_301))) + _277))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_302))) + _278))), (int)(0))), (int)(47)), 0));
    _351 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_300 < (uint)2)))) + _279))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_290 < (uint)2)))) + _277))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_295 < (uint)2)))) + _278))), (int)(0))), (int)(47)), 0));
    _366 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_279 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_277 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_278 + 1u))), (int)(0))), (int)(47)), 0));
    _373 = dot(float3(_283, _284, _285), float3(((float)((bool)_301)), ((float)((bool)_302)), ((float)((bool)_303))));
    _380 = dot(float3(_283, _284, _285), float3(((float)((bool)(uint)(_290 == 2))), ((float)((bool)(uint)(_295 == 2))), ((float)((bool)(uint)(_300 == 2)))));
    _384 = (((_284 + _283) + _285) - _373) - _380;
    _385 = 1.0f - _373;
    _389 = _373 - _384;
    _393 = _384 - _380;
    _402 = (((_380 * _366.x) + (_385 * _321.x)) + (_389 * _336.x)) + (_393 * _351.x);
    _405 = (((_380 * _366.y) + (_385 * _321.y)) + (_389 * _336.y)) + (_393 * _351.y);
    _408 = (((_380 * _366.z) + (_385 * _321.z)) + (_389 * _336.z)) + (_393 * _351.z);
    _410 = mad(0.21580375730991364f, _408, mad(0.3963377773761749f, _405, _402));
    _412 = mad(-0.0638541728258133f, _408, mad(-0.10556134581565857f, _405, _402));
    _414 = mad(-1.2914855480194092f, _408, mad(-0.08948417752981186f, _405, _402));
    _418 = (_410 * _410) * _410;
    _419 = (_412 * _412) * _412;
    _420 = (_414 * _414) * _414;
    _423 = mad(0.23096993565559387f, _420, mad(-3.307711601257324f, _419, (_418 * 4.076741695404053f)));
    _426 = mad(-0.34131938219070435f, _420, mad(2.609757423400879f, _419, (_418 * -1.2684379816055298f)));
    _429 = mad(1.7076146602630615f, _420, mad(-0.7034186124801636f, _419, (_418 * -0.004196086432784796f)));
    _431 = dot(float3(_423, _426, _429), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _442 = (lerp(_431, _423, g_fTonemapSaturation));
    _443 = (lerp(_431, _426, g_fTonemapSaturation));
    _444 = (lerp(_431, _429, g_fTonemapSaturation));
  } else {
    _442 = _220;
    _443 = _221;
    _444 = _222;
  }
  if (!(_150)) {
    do {
      _1157 = _442;
      _1158 = _443;
      _1159 = _444;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _442, _443, _444, _160,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
          _1157 = agx_color.x;
          _1158 = agx_color.y;
          _1159 = agx_color.z;
#else
          _475 = max(_442, 0.0f);
          _476 = max(_443, 0.0f);
          _477 = max(_444, 0.0f);
          _499 = g_fAgxMaxEV - g_fAgxMinEV;
          _503 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _477, mad(g_vAgxInsetRow0.y, _476, (_475 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _499);
          _504 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _477, mad(g_vAgxInsetRow1.y, _476, (_475 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _499);
          _505 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _477, mad(g_vAgxInsetRow2.y, _476, (_475 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _499);
          _514 = (g_fAgxContrastSlope * (_503 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _515 = 1.0f / g_fAgxShoulderPower;
          _532 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _534 = _532 * (0.6060606241226196f - _503);
          _535 = 1.0f / g_fAgxToePower;
          _554 = -0.0f - g_fAgxToePrecalcConstant;
          _557 = select((_503 >= 0.6060606241226196f), ((_514 / exp2(log2((float((int)(((int)(uint)((int)(_514 > 0.0f))) - ((int)(uint)((int)(_514 < 0.0f))))) * exp2(log2(abs(_514)) * g_fAgxShoulderPower)) + 1.0f) * _515)) * g_fAgxShoulderPrecalcConstant), ((_534 / exp2(log2((float((int)(((int)(uint)((int)(_534 > 0.0f))) - ((int)(uint)((int)(_534 < 0.0f))))) * exp2(log2(abs(_534)) * g_fAgxToePower)) + 1.0f) * _535)) * _554)) + 0.4894371032714844f;
          _560 = (g_fAgxContrastSlope * (_504 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _578 = _532 * (0.6060606241226196f - _504);
          _599 = select((_504 >= 0.6060606241226196f), ((_560 / exp2(log2((float((int)(((int)(uint)((int)(_560 > 0.0f))) - ((int)(uint)((int)(_560 < 0.0f))))) * exp2(log2(abs(_560)) * g_fAgxShoulderPower)) + 1.0f) * _515)) * g_fAgxShoulderPrecalcConstant), ((_578 / exp2(log2((exp2(log2(abs(_578)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_578 > 0.0f))) - ((int)(uint)((int)(_578 < 0.0f)))))) + 1.0f) * _535)) * _554)) + 0.4894371032714844f;
          _602 = (g_fAgxContrastSlope * (_505 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _620 = _532 * (0.6060606241226196f - _505);
          _641 = select((_505 >= 0.6060606241226196f), ((_602 / exp2(log2((float((int)(((int)(uint)((int)(_602 > 0.0f))) - ((int)(uint)((int)(_602 < 0.0f))))) * exp2(log2(abs(_602)) * g_fAgxShoulderPower)) + 1.0f) * _515)) * g_fAgxShoulderPrecalcConstant), ((_620 / exp2(log2((exp2(log2(abs(_620)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_620 > 0.0f))) - ((int)(uint)((int)(_620 < 0.0f)))))) + 1.0f) * _535)) * _554)) + 0.4894371032714844f;
          _660 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _641, mad(g_vAgxOutsetRow0.y, _599, (_557 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _661 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _641, mad(g_vAgxOutsetRow1.y, _599, (_557 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _662 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _641, mad(g_vAgxOutsetRow2.y, _599, (_557 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _780 = _660;
            _781 = _661;
            _782 = _662;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_660, max(_661, _662)) >= g_fAgxHDRMidGrey))) {
                _673 = log2(1.0f / g_fAgxHDRMidGrey);
                _674 = _673 + 20.0f;
                _675 = log2(g_fAgxHDRRatio);
                _694 = (min(max(log2(max(_660, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _673) + 20.0f) / _674;
                _695 = (min(max(log2(max(_661, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _673) + 20.0f) / _674;
                _696 = (min(max(log2(max(_662, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _673) + 20.0f) / _674;
                _697 = 20.0f / _674;
                _701 = max(_694, max(_695, _696));
                _706 = ((_701 - _697) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _723 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_697 - _701);
                _745 = select((_701 >= _697), ((_706 / exp2(log2((float((int)(((int)(uint)((int)(_706 > 0.0f))) - ((int)(uint)((int)(_706 < 0.0f))))) * exp2(log2(abs(_706)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_723 / exp2(log2((float((int)(((int)(uint)((int)(_723 > 0.0f))) - ((int)(uint)((int)(_723 < 0.0f))))) * exp2(log2(abs(_723)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _675) / _674);
                _751 = exp2((((_745 - _701) * _674) + _675) * g_fAgxHDRSaturation);
                _780 = (saturate(exp2(((_745 + (_751 * (_694 - _701))) * _674) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _781 = (saturate(exp2(((_745 + (_751 * (_695 - _701))) * _674) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _782 = (saturate(exp2(((_745 + (_751 * (_696 - _701))) * _674) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _780 = _660;
                _781 = _661;
                _782 = _662;
              }
            }
            _1157 = (mad(-0.07283977419137955f, _782, mad(-0.5876564383506775f, _781, (_780 * 1.6604962348937988f))) * _160);
            _1158 = (mad(-0.008348013274371624f, _782, mad(1.1328951120376587f, _781, (_780 * -0.1245470941066742f))) * _160);
            _1159 = (mad(1.118751049041748f, _782, mad(-0.10059737414121628f, _781, (_780 * -0.018153680488467216f))) * _160);
          } while (false);
#endif
        } else {
          if (_225) {
            _797 = max(_442, 0.0f);
            _798 = max(_443, 0.0f);
            _799 = max(_444, 0.0f);
            _800 = dot(float3(_797, _798, _799), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            do {
              _810 = _797;
              _811 = _798;
              _812 = _799;
              if (!(_800 == 0.0f)) {
                _805 = max(dot(float3(_442, _443, _444), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _800;
                _810 = (_805 * _797);
                _811 = (_805 * _798);
                _812 = (_805 * _799);
              }
              _818 = max(max(_810, max(_811, _812)), 0.0f);
              _820 = 1.0f / max(_818, 1.1754943508222875e-38f);
              _826 = (pow(_818, g_vTonemapGTParams.x));
              _834 = _826 / (((pow(_826, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
              _848 = exp2(log2(_820 * _810) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
              _849 = exp2(log2(_820 * _811) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
              _850 = exp2(log2(_820 * _812) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
              _855 = log2(_834);
              _883 = saturate(exp2(log2((exp2(_855 * g_vTonemapCrosstalk.x) * (1.0f - _848)) + _848) * g_vTonemapCrosstalkSaturation.x) * _834);
              _884 = saturate(exp2(log2((exp2(_855 * g_vTonemapCrosstalk.y) * (1.0f - _849)) + _849) * g_vTonemapCrosstalkSaturation.y) * _834);
              _885 = saturate(exp2(log2((exp2(_855 * g_vTonemapCrosstalk.z) * (1.0f - _850)) + _850) * g_vTonemapCrosstalkSaturation.z) * _834);
              do {
                _996 = _883;
                _997 = _884;
                _998 = _885;
                if (_152) {
                  do {
                    [branch]
                    if (!(_883 <= 0.0031308000907301903f)) {
                      _897 = (((pow(_883, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _897 = (_883 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_884 <= 0.0031308000907301903f)) {
                        _908 = (((pow(_884, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _908 = (_884 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_885 <= 0.0031308000907301903f)) {
                          _919 = (((pow(_885, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _919 = (_885 * 12.920000076293945f);
                        }
                        _926 = (saturate(_908) * 0.96875f) + 0.015625f;
                        _928 = max((saturate(_919) * 31.0f), 0.0f);
                        _929 = floor(_928);
                        _930 = _928 - _929;
                        _932 = (((saturate(_897) * 0.96875f) + 0.015625f) + _929) * 0.03125f;
                        _934 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_932, _926), 0.0f);
                        _938 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_932 + 0.03125f), _926), 0.0f);
                        _948 = ((_938.x - _934.x) * _930) + _934.x;
                        _949 = ((_938.y - _934.y) * _930) + _934.y;
                        _950 = ((_938.z - _934.z) * _930) + _934.z;
                        do {
                          [branch]
                          if (!(_948 <= 0.040449999272823334f)) {
                            _961 = exp2(log2((_948 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _961 = (_948 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_949 <= 0.040449999272823334f)) {
                              _972 = exp2(log2((_949 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _972 = (_949 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_950 <= 0.040449999272823334f)) {
                                _983 = exp2(log2((_950 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _983 = (_950 * 0.07739938050508499f);
                              }
                              _985 = dot(float3(_961, _972, _983), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _996 = (lerp(_985, _961, g_fTonemapSaturation));
                              _997 = (lerp(_985, _972, g_fTonemapSaturation));
                              _998 = (lerp(_985, _983, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1157 = (_996 * _160);
                _1158 = (_997 * _160);
                _1159 = (_998 * _160);
              } while (false);
            } while (false);
          } else {
            _1007 = g_fMaxOutputNits * 0.012500000186264515f;
            _1012 = max(abs(_442), max(abs(_443), abs(_444)));
            _1014 = 1.0f / max(_1012, 1.1754943508222875e-38f);
            _1015 = _1014 * _442;
            _1016 = _1014 * _443;
            _1017 = _1014 * _444;
            _1027 = (_160 * 0.18000000715255737f) * exp2(log2((pow(_1012, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
            _1031 = dot(float3((_1027 * _1015), (_1027 * _1016), (_1027 * _1017)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1080 = exp2(log2(abs(_1015)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_1015 > 0.0f))) - ((int)(uint)((int)(_1015 < 0.0f)))));
            _1081 = exp2(log2(abs(_1016)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_1016 > 0.0f))) - ((int)(uint)((int)(_1016 < 0.0f)))));
            _1082 = exp2(log2(abs(_1017)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_1017 > 0.0f))) - ((int)(uint)((int)(_1017 < 0.0f)))));
            _1087 = log2(saturate(select((_1031 <= 0.0f), _1031, ((1.0f - exp2(log2(exp2((_1031 / _1007) * -1.4426950216293335f)))) * _1007)) / _1007));
            _1100 = (exp2(_1087 * g_vTonemapCrosstalk.x) * (1.0f - _1080)) + _1080;
            _1101 = (exp2(_1087 * g_vTonemapCrosstalk.y) * (1.0f - _1081)) + _1081;
            _1102 = (exp2(_1087 * g_vTonemapCrosstalk.z) * (1.0f - _1082)) + _1082;
            _1134 = (float((int)(((int)(uint)((int)(_1100 > 0.0f))) - ((int)(uint)((int)(_1100 < 0.0f))))) * _1027) * exp2(log2(abs(_1100)) * g_vTonemapCrosstalkSaturation.x);
            _1136 = (float((int)(((int)(uint)((int)(_1101 > 0.0f))) - ((int)(uint)((int)(_1101 < 0.0f))))) * _1027) * exp2(log2(abs(_1101)) * g_vTonemapCrosstalkSaturation.y);
            _1138 = (float((int)(((int)(uint)((int)(_1102 > 0.0f))) - ((int)(uint)((int)(_1102 < 0.0f))))) * _1027) * exp2(log2(abs(_1102)) * g_vTonemapCrosstalkSaturation.z);
            _1139 = dot(float3(_1134, _1136, _1138), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1152 = select((_1139 <= 0.0f), _1139, ((1.0f - exp2(log2(exp2((_1139 / _1007) * -1.4426950216293335f)))) * _1007)) * select((!(_1139 == 0.0f)), (1.0f / _1139), 0.0f);
            _1157 = (_1152 * _1134);
            _1158 = (_1152 * _1136);
            _1159 = (_1152 * _1138);
          }
        }
      }
      _1168 = (_1157 * g_fTonemapBrightness);
      _1169 = (_1158 * g_fTonemapBrightness);
      _1170 = (_1159 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1168 = (_442 * _160);
    _1169 = (_443 * _160);
    _1170 = (_444 * _160);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1182 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1192 = _1168 / _160;
    _1193 = _1169 / _160;
    _1194 = _1170 / _160;
    _1198 = 1.0f - sqrt(max(dot(float3(_1192, _1193, _1194), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
    _1204 = g_fFilmGrainIntensity * (_160 * 5.0f);
    _1218 = ((((_1204 * ((_1182.x * 2.0f) + -1.0f)) * saturate(_1192)) * _1198) + _1168);
    _1219 = ((((_1204 * ((_1182.y * 2.0f) + -1.0f)) * _1198) * saturate(_1193)) + _1169);
    _1220 = ((((_1204 * ((_1182.z * 2.0f) + -1.0f)) * _1198) * saturate(_1194)) + _1170);
  } else {
    _1218 = _1168;
    _1219 = _1169;
    _1220 = _1170;
  }
  if (!(_87)) {
    _1224 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _1225 = (uint)(int(SV_Position.y)) + (uint)(-48);
    uint2 _1226;
    g_tBaseColorCorrectionMap.GetDimensions(_1226.x, _1226.y);
    if (((int)_1225 < (int)int(float((int)((int)(_1226.y))))) && (((int)(_1225 | _1224) > (int)-1) && ((int)_1224 < (int)int(float((int)((int)(_1226.x))))))) {
      _1240 = g_tBaseColorCorrectionMap.Load(int3(_1224, _1225, 0));
      if (!(_225)) {
        _1246 = mad(0.21580375730991364f, _1240.z, mad(0.3963377773761749f, _1240.y, _1240.x));
        _1248 = mad(-0.0638541728258133f, _1240.z, mad(-0.10556134581565857f, _1240.y, _1240.x));
        _1250 = mad(-1.2914855480194092f, _1240.z, mad(-0.08948417752981186f, _1240.y, _1240.x));
        _1254 = (_1246 * _1246) * _1246;
        _1255 = (_1248 * _1248) * _1248;
        _1256 = (_1250 * _1250) * _1250;
        _1299 = mad(0.23096993565559387f, _1256, mad(-3.307711601257324f, _1255, (_1254 * 4.076741695404053f)));
        _1300 = mad(-0.34131938219070435f, _1256, mad(2.609757423400879f, _1255, (_1254 * -1.2684379816055298f)));
        _1301 = mad(1.7076146602630615f, _1256, mad(-0.7034186124801636f, _1255, (_1254 * -0.004196086432784796f)));
      } else {
        do {
          [branch]
          if (!(_1240.x <= 0.040449999272823334f)) {
            _1277 = exp2(log2((_1240.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
          } else {
            _1277 = (_1240.x * 0.07739938050508499f);
          }
          do {
            [branch]
            if (!(_1240.y <= 0.040449999272823334f)) {
              _1288 = exp2(log2((_1240.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1288 = (_1240.y * 0.07739938050508499f);
            }
            [branch]
            if (!(_1240.z <= 0.040449999272823334f)) {
              _1299 = _1277;
              _1300 = _1288;
              _1301 = exp2(log2((_1240.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1299 = _1277;
              _1300 = _1288;
              _1301 = (_1240.z * 0.07739938050508499f);
            }
          } while (false);
        } while (false);
      }
    } else {
      _1299 = _1218;
      _1300 = _1219;
      _1301 = _1220;
    }
  } else {
    _1299 = _1218;
    _1300 = _1219;
    _1301 = _1220;
  }
  if (!(g_bDebugValidateOutputRange == 0)) {
    _1307 = mad(0.043306104838848114f, _1301, mad(0.329291969537735f, _1300, (_1299 * 0.6274019479751587f)));
    _1310 = mad(0.0113602289929986f, _1301, mad(0.9195442795753479f, _1300, (_1299 * 0.06909549236297607f)));
    _1313 = mad(0.895578145980835f, _1301, mad(0.08802816271781921f, _1300, (_1299 * 0.016393709927797318f)));
    _1317 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
    do {
      _1330 = true;
      if (!(((_1307 < 0.0f) || (_1310 < 0.0f)) || (_1313 < 0.0f))) {
        _1330 = ((_1313 > _1317) || ((_1307 > _1317) || (_1310 > _1317)));
      }
      if (_1330) {
        _1336 = float((int)(int(g_fRealTime * 15.0f)));
        _1346 = select((((((int)((uint)(int(SV_Position.y - _1336)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1336)) / 5u))) & 1) == 0), 1.0f, 0.0f);
        _1351 = (_1346 * _1299);
        _1352 = (_1346 * _1300);
        _1353 = (_1346 * _1301);
      } else {
        _1351 = _1299;
        _1352 = _1300;
        _1353 = _1301;
      }
    } while (false);
  } else {
    _1351 = _1299;
    _1352 = _1300;
    _1353 = _1301;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1359 = (g_bHDR == 0);
    do {
      _1386 = _1351;
      _1387 = _1352;
      _1388 = _1353;
      if (!(_1359 || (g_bHDR_scRGB == 0))) {
        _1373 = max(mad(0.043306104838848114f, _1353, mad(0.329291969537735f, _1352, (_1351 * 0.6274019479751587f))), 0.0f);
        _1374 = max(mad(0.0113602289929986f, _1353, mad(0.9195442795753479f, _1352, (_1351 * 0.06909549236297607f))), 0.0f);
        _1375 = max(mad(0.895578145980835f, _1353, mad(0.08802816271781921f, _1352, (_1351 * 0.016393709927797318f))), 0.0f);
        _1386 = mad(-0.07283977419137955f, _1375, mad(-0.5876564383506775f, _1374, (_1373 * 1.6604962348937988f)));
        _1387 = mad(-0.008348013274371624f, _1375, mad(1.1328951120376587f, _1374, (_1373 * -0.1245470941066742f)));
        _1388 = mad(1.118751049041748f, _1375, mad(-0.10059737414121628f, _1374, (_1373 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1359)) {
        _1404 = mad(0.043306104838848114f, _1388, mad(0.329291969537735f, _1387, (_1386 * 0.6274019479751587f)));
        _1405 = mad(0.0113602289929986f, _1388, mad(0.9195442795753479f, _1387, (_1386 * 0.06909549236297607f)));
        _1406 = mad(0.895578145980835f, _1388, mad(0.08802816271781921f, _1387, (_1386 * 0.016393709927797318f)));
      } else {
        _1404 = _1386;
        _1405 = _1387;
        _1406 = _1388;
      }
    } while (false);
  } else {
    _1404 = _1351;
    _1405 = _1352;
    _1406 = _1353;
  }
  SV_Target.x = _1404;
  SV_Target.y = _1405;
  SV_Target.z = _1406;
  SV_Target.w = 1.0f;
  return SV_Target;
}
