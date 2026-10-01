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
  float _161;
  float _181;
  float _182;
  float _183;
  float _221;
  float _222;
  float _223;
  float _443;
  float _444;
  float _445;
  float _781;
  float _782;
  float _783;
  float _807;
  float _808;
  float _809;
  float _895;
  float _906;
  float _917;
  float _959;
  float _970;
  float _981;
  float _994;
  float _995;
  float _996;
  float _1001;
  float _1002;
  float _1003;
  float _1012;
  float _1013;
  float _1014;
  float _1112;
  float _1113;
  float _1114;
  float _1171;
  float _1182;
  float _1193;
  float _1194;
  float _1195;
  bool _1215;
  float _1236;
  float _1237;
  float _1238;
  float _1271;
  float _1272;
  float _1273;
  float _1289;
  float _1290;
  float _1291;
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
  float _273;
  float _274;
  int _278;
  int _279;
  int _280;
  float _284;
  float _285;
  float _286;
  int _291;
  int _296;
  int _301;
  bool _302;
  bool _303;
  bool _304;
  float4 _322;
  float4 _337;
  float4 _352;
  float4 _367;
  float _374;
  float _381;
  float _385;
  float _386;
  float _390;
  float _394;
  float _403;
  float _406;
  float _409;
  float _411;
  float _413;
  float _415;
  float _419;
  float _420;
  float _421;
  float _424;
  float _427;
  float _430;
  float _432;
  float _451;
  float _452;
  float _453;
  float _500;
  float _504;
  float _505;
  float _506;
  float _515;
  float _516;
  float _533;
  float _535;
  float _536;
  float _555;
  float _558;
  float _561;
  float _579;
  float _600;
  float _603;
  float _621;
  float _642;
  float _661;
  float _662;
  float _663;
  float _674;
  float _675;
  float _676;
  float _695;
  float _696;
  float _697;
  float _698;
  float _702;
  float _707;
  float _724;
  float _746;
  float _752;
  float _797;
  float _802;
  float _815;
  float _817;
  float _823;
  float _831;
  float _845;
  float _846;
  float _847;
  float _852;
  float _880;
  float _881;
  float _882;
  float _924;
  float _926;
  float _927;
  float _928;
  float _930;
  float4 _932;
  float4 _936;
  float _946;
  float _947;
  float _948;
  float _983;
  float4 _1026;
  float _1033;
  float _1034;
  float _1035;
  float _1038;
  float _1039;
  float _1040;
  float _1044;
  float _1049;
  float _1063;
  float _1064;
  float _1065;
  float _1070;
  float _1071;
  float _1072;
  float _1073;
  float _1081;
  float _1088;
  float _1089;
  float _1090;
  float _1094;
  float _1101;
  uint _1118;
  uint _1119;
  uint2 _1120;
  float4 _1134;
  float _1140;
  float _1142;
  float _1144;
  float _1148;
  float _1149;
  float _1150;
  float _1202;
  float _1221;
  float _1231;
  bool _1244;
  float _1258;
  float _1259;
  float _1260;
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
    _161 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
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
    _242 = exp2(log2(saturate(_221 * 0.00800000037997961f)) * 0.1593017578125f);
    _243 = exp2(log2(saturate(_222 * 0.00800000037997961f)) * 0.1593017578125f);
    _244 = exp2(log2(saturate(_223 * 0.00800000037997961f)) * 0.1593017578125f);
    _272 = saturate(exp2(log2(((_242 * 18.8515625f) + 0.8359375f) / ((_242 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _273 = saturate(exp2(log2(((_243 * 18.8515625f) + 0.8359375f) / ((_243 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _274 = saturate(exp2(log2(((_244 * 18.8515625f) + 0.8359375f) / ((_244 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _278 = int(floor(_272));
    _279 = int(floor(_273));
    _280 = int(floor(_274));
    _284 = _272 - float((int)(_278));
    _285 = _273 - float((int)(_279));
    _286 = _274 - float((int)(_280));
    _291 = ((int)(uint)((int)(_286 > _284))) + ((int)(uint)((int)(_285 > _284)));
    _296 = ((int)(uint)((int)(_286 > _285))) + ((int)(uint)((int)(_284 >= _285)));
    _301 = ((int)(uint)((int)(_284 >= _286))) + ((int)(uint)((int)(_285 >= _286)));
    _302 = (_291 == 0);
    _303 = (_296 == 0);
    _304 = (_301 == 0);
    _322 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_280), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_278), (int)(0))), (int)(47))), min((int)(max((int)(_279), (int)(0))), (int)(47)), 0));
    _337 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_304))) + _280))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_302))) + _278))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_303))) + _279))), (int)(0))), (int)(47)), 0));
    _352 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_301 < (uint)2)))) + _280))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_291 < (uint)2)))) + _278))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_296 < (uint)2)))) + _279))), (int)(0))), (int)(47)), 0));
    _367 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_280 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_278 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_279 + 1u))), (int)(0))), (int)(47)), 0));
    _374 = dot(float3(_284, _285, _286), float3(((float)((bool)_302)), ((float)((bool)_303)), ((float)((bool)_304))));
    _381 = dot(float3(_284, _285, _286), float3(((float)((bool)(uint)(_291 == 2))), ((float)((bool)(uint)(_296 == 2))), ((float)((bool)(uint)(_301 == 2)))));
    _385 = (((_285 + _284) + _286) - _374) - _381;
    _386 = 1.0f - _374;
    _390 = _374 - _385;
    _394 = _385 - _381;
    _403 = (((_381 * _367.x) + (_386 * _322.x)) + (_390 * _337.x)) + (_394 * _352.x);
    _406 = (((_381 * _367.y) + (_386 * _322.y)) + (_390 * _337.y)) + (_394 * _352.y);
    _409 = (((_381 * _367.z) + (_386 * _322.z)) + (_390 * _337.z)) + (_394 * _352.z);
    _411 = mad(0.21580375730991364f, _409, mad(0.3963377773761749f, _406, _403));
    _413 = mad(-0.0638541728258133f, _409, mad(-0.10556134581565857f, _406, _403));
    _415 = mad(-1.2914855480194092f, _409, mad(-0.08948417752981186f, _406, _403));
    _419 = (_411 * _411) * _411;
    _420 = (_413 * _413) * _413;
    _421 = (_415 * _415) * _415;
    _424 = mad(0.23096993565559387f, _421, mad(-3.307711601257324f, _420, (_419 * 4.076741695404053f)));
    _427 = mad(-0.34131938219070435f, _421, mad(2.609757423400879f, _420, (_419 * -1.2684379816055298f)));
    _430 = mad(1.7076146602630615f, _421, mad(-0.7034186124801636f, _420, (_419 * -0.004196086432784796f)));
    _432 = dot(float3(_424, _427, _430), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _443 = (lerp(_432, _424, g_fTonemapSaturation));
    _444 = (lerp(_432, _427, g_fTonemapSaturation));
    _445 = (lerp(_432, _430, g_fTonemapSaturation));
  } else {
    _443 = _221;
    _444 = _222;
    _445 = _223;
  }
  if (_150) {
    do {
      _1001 = _443;
      _1002 = _444;
      _1003 = _445;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          if (TONE_MAP_TYPE == 0.f) {
            _451 = max(_443, 0.0f);
            _452 = max(_444, 0.0f);
            _453 = max(_445, 0.0f);
          } else {
            _451 = _443;
            _452 = _444;
            _453 = _445;
          }
          float3 agx_color = ApplyRemedyAgX(
              _451, _452, _453, _161,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
          _1001 = agx_color.x;
          _1002 = agx_color.y;
          _1003 = agx_color.z;
#else
          _451 = max(_443, 0.0f);
          _452 = max(_444, 0.0f);
          _453 = max(_445, 0.0f);
          _500 = g_fAgxMaxEV - g_fAgxMinEV;
          _504 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _453, mad(g_vAgxInsetRow0.y, _452, (g_vAgxInsetRow0.x * _451))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _500);
          _505 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _453, mad(g_vAgxInsetRow1.y, _452, (g_vAgxInsetRow1.x * _451))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _500);
          _506 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _453, mad(g_vAgxInsetRow2.y, _452, (g_vAgxInsetRow2.x * _451))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _500);
          _515 = (g_fAgxContrastSlope * (_504 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _516 = 1.0f / g_fAgxShoulderPower;
          _533 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _535 = _533 * (0.6060606241226196f - _504);
          _536 = 1.0f / g_fAgxToePower;
          _555 = -0.0f - g_fAgxToePrecalcConstant;
          _558 = select((_504 >= 0.6060606241226196f), ((_515 / exp2(log2((float((int)(((int)(uint)((int)(_515 > 0.0f))) - ((int)(uint)((int)(_515 < 0.0f))))) * exp2(log2(abs(_515)) * g_fAgxShoulderPower)) + 1.0f) * _516)) * g_fAgxShoulderPrecalcConstant), ((_535 / exp2(log2((float((int)(((int)(uint)((int)(_535 > 0.0f))) - ((int)(uint)((int)(_535 < 0.0f))))) * exp2(log2(abs(_535)) * g_fAgxToePower)) + 1.0f) * _536)) * _555)) + 0.4894371032714844f;
          _561 = (g_fAgxContrastSlope * (_505 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _579 = _533 * (0.6060606241226196f - _505);
          _600 = select((_505 >= 0.6060606241226196f), ((_561 / exp2(log2((float((int)(((int)(uint)((int)(_561 > 0.0f))) - ((int)(uint)((int)(_561 < 0.0f))))) * exp2(log2(abs(_561)) * g_fAgxShoulderPower)) + 1.0f) * _516)) * g_fAgxShoulderPrecalcConstant), ((_579 / exp2(log2((exp2(log2(abs(_579)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_579 > 0.0f))) - ((int)(uint)((int)(_579 < 0.0f)))))) + 1.0f) * _536)) * _555)) + 0.4894371032714844f;
          _603 = (g_fAgxContrastSlope * (_506 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _621 = _533 * (0.6060606241226196f - _506);
          _642 = select((_506 >= 0.6060606241226196f), ((_603 / exp2(log2((float((int)(((int)(uint)((int)(_603 > 0.0f))) - ((int)(uint)((int)(_603 < 0.0f))))) * exp2(log2(abs(_603)) * g_fAgxShoulderPower)) + 1.0f) * _516)) * g_fAgxShoulderPrecalcConstant), ((_621 / exp2(log2((exp2(log2(abs(_621)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_621 > 0.0f))) - ((int)(uint)((int)(_621 < 0.0f)))))) + 1.0f) * _536)) * _555)) + 0.4894371032714844f;
          _661 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _642, mad(g_vAgxOutsetRow0.y, _600, (_558 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _662 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _642, mad(g_vAgxOutsetRow1.y, _600, (_558 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _663 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _642, mad(g_vAgxOutsetRow2.y, _600, (_558 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _781 = _661;
            _782 = _662;
            _783 = _663;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_661, max(_662, _663)) >= g_fAgxHDRMidGrey))) {
                _674 = log2(1.0f / g_fAgxHDRMidGrey);
                _675 = _674 + 20.0f;
                _676 = log2(g_fAgxHDRRatio);
                _695 = (min(max(log2(max(_661, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _674) + 20.0f) / _675;
                _696 = (min(max(log2(max(_662, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _674) + 20.0f) / _675;
                _697 = (min(max(log2(max(_663, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _674) + 20.0f) / _675;
                _698 = 20.0f / _675;
                _702 = max(_695, max(_696, _697));
                _707 = ((_702 - _698) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _724 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_698 - _702);
                _746 = select((_702 >= _698), ((_707 / exp2(log2((float((int)(((int)(uint)((int)(_707 > 0.0f))) - ((int)(uint)((int)(_707 < 0.0f))))) * exp2(log2(abs(_707)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_724 / exp2(log2((float((int)(((int)(uint)((int)(_724 > 0.0f))) - ((int)(uint)((int)(_724 < 0.0f))))) * exp2(log2(abs(_724)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _676) / _675);
                _752 = exp2((((_746 - _702) * _675) + _676) * g_fAgxHDRSaturation);
                _781 = (saturate(exp2(((_746 + (_752 * (_695 - _702))) * _675) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _782 = (saturate(exp2(((_746 + (_752 * (_696 - _702))) * _675) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _783 = (saturate(exp2(((_746 + (_752 * (_697 - _702))) * _675) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _781 = _661;
                _782 = _662;
                _783 = _663;
              }
            }
            _1001 = (mad(-0.07283977419137955f, _783, mad(-0.5876564383506775f, _782, (_781 * 1.6604962348937988f))) * _161);
            _1002 = (mad(-0.008348013274371624f, _783, mad(1.1328951120376587f, _782, (_781 * -0.1245470941066742f))) * _161);
            _1003 = (mad(1.118751049041748f, _783, mad(-0.10059737414121628f, _782, (_781 * -0.018153680488467216f))) * _161);
          } while (false);
#endif
        } else {
          _451 = max(_443, 0.0f);
          _452 = max(_444, 0.0f);
          _453 = max(_445, 0.0f);
          _797 = dot(float3(_451, _452, _453), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
          do {
            _807 = _451;
            _808 = _452;
            _809 = _453;
            if (!(_797 == 0.0f)) {
              _802 = max(dot(float3(_443, _444, _445), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _797;
              _807 = (_802 * _451);
              _808 = (_802 * _452);
              _809 = (_802 * _453);
            }
            _815 = max(max(_807, max(_808, _809)), 0.0f);
            _817 = 1.0f / max(_815, 1.1754943508222875e-38f);
            _823 = (pow(_815, g_vTonemapGTParams.x));
            _831 = _823 / (((pow(_823, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
            _845 = exp2(log2(_817 * _807) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
            _846 = exp2(log2(_817 * _808) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
            _847 = exp2(log2(_817 * _809) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
            _852 = log2(_831);
            _880 = saturate(exp2(log2((exp2(_852 * g_vTonemapCrosstalk.x) * (1.0f - _845)) + _845) * g_vTonemapCrosstalkSaturation.x) * _831);
            _881 = saturate(exp2(log2((exp2(_852 * g_vTonemapCrosstalk.y) * (1.0f - _846)) + _846) * g_vTonemapCrosstalkSaturation.y) * _831);
            _882 = saturate(exp2(log2((exp2(_852 * g_vTonemapCrosstalk.z) * (1.0f - _847)) + _847) * g_vTonemapCrosstalkSaturation.z) * _831);
            if (_226) {
              do {
                _994 = _880;
                _995 = _881;
                _996 = _882;
                if (_152) {
                  do {
                    [branch]
                    if (!(_880 <= 0.0031308000907301903f)) {
                      _895 = (((pow(_880, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _895 = (_880 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_881 <= 0.0031308000907301903f)) {
                        _906 = (((pow(_881, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _906 = (_881 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_882 <= 0.0031308000907301903f)) {
                          _917 = (((pow(_882, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _917 = (_882 * 12.920000076293945f);
                        }
                        _924 = (saturate(_906) * 0.96875f) + 0.015625f;
                        _926 = max((saturate(_917) * 31.0f), 0.0f);
                        _927 = floor(_926);
                        _928 = _926 - _927;
                        _930 = (((saturate(_895) * 0.96875f) + 0.015625f) + _927) * 0.03125f;
                        _932 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_930, _924), 0.0f);
                        _936 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_930 + 0.03125f), _924), 0.0f);
                        _946 = ((_936.x - _932.x) * _928) + _932.x;
                        _947 = ((_936.y - _932.y) * _928) + _932.y;
                        _948 = ((_936.z - _932.z) * _928) + _932.z;
                        do {
                          [branch]
                          if (!(_946 <= 0.040449999272823334f)) {
                            _959 = exp2(log2((_946 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _959 = (_946 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_947 <= 0.040449999272823334f)) {
                              _970 = exp2(log2((_947 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _970 = (_947 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_948 <= 0.040449999272823334f)) {
                                _981 = exp2(log2((_948 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _981 = (_948 * 0.07739938050508499f);
                              }
                              _983 = dot(float3(_959, _970, _981), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _994 = (lerp(_983, _959, g_fTonemapSaturation));
                              _995 = (lerp(_983, _970, g_fTonemapSaturation));
                              _996 = (lerp(_983, _981, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1001 = (_994 * _161);
                _1002 = (_995 * _161);
                _1003 = (_996 * _161);
              } while (false);
            } else {
              _1001 = _880;
              _1002 = _881;
              _1003 = _882;
            }
          } while (false);
        }
      }
      _1012 = (_1001 * g_fTonemapBrightness);
      _1013 = (_1002 * g_fTonemapBrightness);
      _1014 = (_1003 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1012 = (_443 * _161);
    _1013 = (_444 * _161);
    _1014 = (_445 * _161);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1026 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1033 = (_1026.x * 2.0f) + -1.0f;
    _1034 = (_1026.y * 2.0f) + -1.0f;
    _1035 = (_1026.z * 2.0f) + -1.0f;
    if (!(_150)) {
      _1038 = _1012 / _161;
      _1039 = _1013 / _161;
      _1040 = _1014 / _161;
      _1044 = 1.0f - sqrt(max(dot(float3(_1038, _1039, _1040), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
      _1049 = g_fFilmGrainIntensity * (_161 * 5.0f);
      _1112 = ((((_1049 * _1033) * saturate(_1038)) * _1044) + _1012);
      _1113 = ((((_1049 * _1034) * _1044) * saturate(_1039)) + _1013);
      _1114 = ((((_1049 * _1035) * _1044) * saturate(_1040)) + _1014);
    } else {
      _1063 = saturate(_1012);
      _1064 = saturate(_1013);
      _1065 = saturate(_1014);
      _1070 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_1063, max(_1064, _1065))));
      _1071 = _1070 * _1063;
      _1072 = _1070 * _1064;
      _1073 = _1070 * _1065;
      _1081 = ((1.0f - sqrt(dot(float3(_1071, _1072, _1073), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
      _1088 = ((_1081 * _1033) * min(1.0f, _1071)) + _1071;
      _1089 = ((_1081 * _1034) * min(1.0f, _1072)) + _1072;
      _1090 = ((_1081 * _1035) * min(1.0f, _1073)) + _1073;
      _1094 = 1.0f / (max(_1088, max(_1089, _1090)) + 1.0f);
      _1101 = 1.0f / (max(_1071, max(_1072, _1073)) + 1.0f);
      _1112 = (((_1088 * _1094) + _1012) - (_1101 * _1071));
      _1113 = (((_1089 * _1094) + _1013) - (_1101 * _1072));
      _1114 = (((_1090 * _1094) + _1014) - (_1101 * _1073));
    }
  } else {
    _1112 = _1012;
    _1113 = _1013;
    _1114 = _1014;
  }
  if (!(_87)) {
    _1118 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _1119 = (uint)(int(SV_Position.y)) + (uint)(-48);
    uint2 _1120;
    g_tBaseColorCorrectionMap.GetDimensions(_1120.x, _1120.y);
    if (((int)_1119 < (int)int(float((int)((int)(_1120.y))))) && (((int)(_1119 | _1118) > (int)-1) && ((int)_1118 < (int)int(float((int)((int)(_1120.x))))))) {
      _1134 = g_tBaseColorCorrectionMap.Load(int3(_1118, _1119, 0));
      if (!(_226)) {
        _1140 = mad(0.21580375730991364f, _1134.z, mad(0.3963377773761749f, _1134.y, _1134.x));
        _1142 = mad(-0.0638541728258133f, _1134.z, mad(-0.10556134581565857f, _1134.y, _1134.x));
        _1144 = mad(-1.2914855480194092f, _1134.z, mad(-0.08948417752981186f, _1134.y, _1134.x));
        _1148 = (_1140 * _1140) * _1140;
        _1149 = (_1142 * _1142) * _1142;
        _1150 = (_1144 * _1144) * _1144;
        _1193 = mad(0.23096993565559387f, _1150, mad(-3.307711601257324f, _1149, (_1148 * 4.076741695404053f)));
        _1194 = mad(-0.34131938219070435f, _1150, mad(2.609757423400879f, _1149, (_1148 * -1.2684379816055298f)));
        _1195 = mad(1.7076146602630615f, _1150, mad(-0.7034186124801636f, _1149, (_1148 * -0.004196086432784796f)));
      } else {
        do {
          [branch]
          if (!(_1134.x <= 0.040449999272823334f)) {
            _1171 = exp2(log2((_1134.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
          } else {
            _1171 = (_1134.x * 0.07739938050508499f);
          }
          do {
            [branch]
            if (!(_1134.y <= 0.040449999272823334f)) {
              _1182 = exp2(log2((_1134.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1182 = (_1134.y * 0.07739938050508499f);
            }
            [branch]
            if (!(_1134.z <= 0.040449999272823334f)) {
              _1193 = _1171;
              _1194 = _1182;
              _1195 = exp2(log2((_1134.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1193 = _1171;
              _1194 = _1182;
              _1195 = (_1134.z * 0.07739938050508499f);
            }
          } while (false);
        } while (false);
      }
    } else {
      _1193 = _1112;
      _1194 = _1113;
      _1195 = _1114;
    }
  } else {
    _1193 = _1112;
    _1194 = _1113;
    _1195 = _1114;
  }
  if (!(g_bDebugValidateOutputRange == 0)) {
    _1202 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
    do {
      _1215 = true;
      if (!(((_1193 < 0.0f) || (_1194 < 0.0f)) || (_1195 < 0.0f))) {
        _1215 = ((_1195 > _1202) || ((_1193 > _1202) || (_1194 > _1202)));
      }
      if (_1215) {
        _1221 = float((int)(int(g_fRealTime * 15.0f)));
        _1231 = select((((((int)((uint)(int(SV_Position.y - _1221)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1221)) / 5u))) & 1) == 0), 1.0f, 0.0f);
        _1236 = (_1231 * _1193);
        _1237 = (_1231 * _1194);
        _1238 = (_1231 * _1195);
      } else {
        _1236 = _1193;
        _1237 = _1194;
        _1238 = _1195;
      }
    } while (false);
  } else {
    _1236 = _1193;
    _1237 = _1194;
    _1238 = _1195;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1244 = (g_bHDR == 0);
    do {
      _1271 = _1236;
      _1272 = _1237;
      _1273 = _1238;
      if (!(_1244 || (g_bHDR_scRGB == 0))) {
        _1258 = max(mad(0.043306104838848114f, _1238, mad(0.329291969537735f, _1237, (_1236 * 0.6274019479751587f))), 0.0f);
        _1259 = max(mad(0.0113602289929986f, _1238, mad(0.9195442795753479f, _1237, (_1236 * 0.06909549236297607f))), 0.0f);
        _1260 = max(mad(0.895578145980835f, _1238, mad(0.08802816271781921f, _1237, (_1236 * 0.016393709927797318f))), 0.0f);
        _1271 = mad(-0.07283977419137955f, _1260, mad(-0.5876564383506775f, _1259, (_1258 * 1.6604962348937988f)));
        _1272 = mad(-0.008348013274371624f, _1260, mad(1.1328951120376587f, _1259, (_1258 * -0.1245470941066742f)));
        _1273 = mad(1.118751049041748f, _1260, mad(-0.10059737414121628f, _1259, (_1258 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1244)) {
        _1289 = mad(0.043306104838848114f, _1273, mad(0.329291969537735f, _1272, (_1271 * 0.6274019479751587f)));
        _1290 = mad(0.0113602289929986f, _1273, mad(0.9195442795753479f, _1272, (_1271 * 0.06909549236297607f)));
        _1291 = mad(0.895578145980835f, _1273, mad(0.08802816271781921f, _1272, (_1271 * 0.016393709927797318f)));
      } else {
        _1289 = _1271;
        _1290 = _1272;
        _1291 = _1273;
      }
    } while (false);
  } else {
    _1289 = _1236;
    _1290 = _1237;
    _1291 = _1238;
  }
  SV_Target.x = _1289;
  SV_Target.y = _1290;
  SV_Target.z = _1291;
  SV_Target.w = 1.0f;
  return SV_Target;
}
