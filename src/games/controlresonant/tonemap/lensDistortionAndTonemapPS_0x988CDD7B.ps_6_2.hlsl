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
  float4 _22;
  float _35;
  float _36;
  float _37;
  float _97;
  float _98;
  float _99;
  float _113;
  float _133;
  float _134;
  float _135;
  float _173;
  float _174;
  float _175;
  float _395;
  float _396;
  float _397;
  float _733;
  float _734;
  float _735;
  float _759;
  float _760;
  float _761;
  float _847;
  float _858;
  float _869;
  float _911;
  float _922;
  float _933;
  float _946;
  float _947;
  float _948;
  float _953;
  float _954;
  float _955;
  float _964;
  float _965;
  float _966;
  float _1064;
  float _1065;
  float _1066;
  float _1123;
  float _1134;
  float _1145;
  float _1146;
  float _1147;
  bool _1167;
  float _1188;
  float _1189;
  float _1190;
  float _1223;
  float _1224;
  float _1225;
  float _1241;
  float _1242;
  float _1243;
  float4 _30;
  bool _39;
  uint _43;
  uint _44;
  float _52;
  float _54;
  float _55;
  float _76;
  float _77;
  float _78;
  float _80;
  float _85;
  float _89;
  bool _102;
  bool _104;
  float _137;
  float _141;
  float _142;
  float _143;
  float _144;
  float _153;
  float _154;
  float _168;
  bool _178;
  float _194;
  float _195;
  float _196;
  float _224;
  float _225;
  float _226;
  int _230;
  int _231;
  int _232;
  float _236;
  float _237;
  float _238;
  int _243;
  int _248;
  int _253;
  bool _254;
  bool _255;
  bool _256;
  float4 _274;
  float4 _289;
  float4 _304;
  float4 _319;
  float _326;
  float _333;
  float _337;
  float _338;
  float _342;
  float _346;
  float _355;
  float _358;
  float _361;
  float _363;
  float _365;
  float _367;
  float _371;
  float _372;
  float _373;
  float _376;
  float _379;
  float _382;
  float _384;
  float _403;
  float _404;
  float _405;
  float _452;
  float _456;
  float _457;
  float _458;
  float _467;
  float _468;
  float _485;
  float _487;
  float _488;
  float _507;
  float _510;
  float _513;
  float _531;
  float _552;
  float _555;
  float _573;
  float _594;
  float _613;
  float _614;
  float _615;
  float _626;
  float _627;
  float _628;
  float _647;
  float _648;
  float _649;
  float _650;
  float _654;
  float _659;
  float _676;
  float _698;
  float _704;
  float _749;
  float _754;
  float _767;
  float _769;
  float _775;
  float _783;
  float _797;
  float _798;
  float _799;
  float _804;
  float _832;
  float _833;
  float _834;
  float _876;
  float _878;
  float _879;
  float _880;
  float _882;
  float4 _884;
  float4 _888;
  float _898;
  float _899;
  float _900;
  float _935;
  float4 _978;
  float _985;
  float _986;
  float _987;
  float _990;
  float _991;
  float _992;
  float _996;
  float _1001;
  float _1015;
  float _1016;
  float _1017;
  float _1022;
  float _1023;
  float _1024;
  float _1025;
  float _1033;
  float _1040;
  float _1041;
  float _1042;
  float _1046;
  float _1053;
  uint _1070;
  uint _1071;
  uint2 _1072;
  float4 _1086;
  float _1092;
  float _1094;
  float _1096;
  float _1100;
  float _1101;
  float _1102;
  float _1154;
  float _1173;
  float _1183;
  bool _1196;
  float _1210;
  float _1211;
  float _1212;
  _20 = g_vInvOutputRes.x * SV_Position.x;
  _21 = g_vInvOutputRes.y * SV_Position.y;
  _22 = g_tSource.Sample(g_sLinearClamp_internal, float2(_20, _21));
  if (!(g_bDebugReferenceImage == 0)) {
    _30 = g_tSourceReferenceImage.Sample(g_sLinearClamp_internal, float2(_20, _21));
    _35 = _30.x;
    _36 = _30.y;
    _37 = _30.z;
  } else {
    _35 = _22.x;
    _36 = _22.y;
    _37 = _22.z;
  }
  _39 = (g_bDebugLUT == 0);
  if (!(_39)) {
    _43 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _44 = (uint)(int(SV_Position.y)) + (uint)(-112);
    if (((int)_44 < (int)300) && (((int)_43 < (int)500) && ((int)(_44 | _43) > (int)-1))) {
      _52 = float((int)(_43));
      _54 = _52 * 0.0020000000949949026f;
      _55 = float((int)(_44)) * 0.005333333276212215f;
      _76 = saturate(2.0f - (abs(frac(_55) + -0.5f) * 6.0f)) * 2.0f;
      _77 = saturate(2.0f - (abs(frac(_55 + 0.3333333432674408f) + -0.5f) * 6.0f)) * 2.0f;
      _78 = saturate(2.0f - (abs(frac(_55 + -0.3333333432674408f) + -0.5f) * 6.0f)) * 2.0f;
      _80 = g_bBrightness[0];
      _85 = _54 * _54;
      _89 = ((_52 * 0.25f) * (_85 * _85)) * (_80 / exp2(g_fExposureCompensationInEV100));
      _97 = ((_76 * _76) * _89);
      _98 = ((_77 * _77) * _89);
      _99 = ((_78 * _78) * _89);
    } else {
      _97 = _35;
      _98 = _36;
      _99 = _37;
    }
  } else {
    _97 = _35;
    _98 = _36;
    _99 = _37;
  }
  _102 = (g_bPostProcessApplyTonemap != 0);
  _104 = (g_bPostProcessApplyColorGrade != 0);
  if (!(g_bPostProcessApplyTonemap == 0)) {
    _113 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  } else {
    _113 = 1.0f;
  }
  if (_104) {
    _133 = max(_97, 0.0f);
    _134 = max(_98, 0.0f);
    _135 = max(_99, 0.0f);
  } else {
    _133 = _97;
    _134 = _98;
    _135 = _99;
  }
  _137 = g_bBrightness[1];
  _141 = exp2(g_fExposureCompensationInEV100) * _137;
  _142 = _141 * _133;
  _143 = _141 * _134;
  _144 = _141 * _135;
  if (!(g_bApplyVignette == 0)) {
    _153 = ((((g_vOverriddenAspectRatioUVScale.x * _20) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _154 = (((g_vOverriddenAspectRatioUVScale.y * _21) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _168 = saturate(exp2(log2(saturate(1.0f - sqrt((_153 * _153) + (_154 * _154))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _173 = (_168 * _142);
    _174 = (_168 * _143);
    _175 = (_168 * _144);
  } else {
    _173 = _142;
    _174 = _143;
    _175 = _144;
  }
  _178 = (g_bEnableHDRLUT == 0);
  if (!(_178 || (!_104))) {
    _194 = exp2(log2(saturate(_173 * 0.00800000037997961f)) * 0.1593017578125f);
    _195 = exp2(log2(saturate(_174 * 0.00800000037997961f)) * 0.1593017578125f);
    _196 = exp2(log2(saturate(_175 * 0.00800000037997961f)) * 0.1593017578125f);
    _224 = saturate(exp2(log2(((_194 * 18.8515625f) + 0.8359375f) / ((_194 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _225 = saturate(exp2(log2(((_195 * 18.8515625f) + 0.8359375f) / ((_195 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _226 = saturate(exp2(log2(((_196 * 18.8515625f) + 0.8359375f) / ((_196 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _230 = int(floor(_224));
    _231 = int(floor(_225));
    _232 = int(floor(_226));
    _236 = _224 - float((int)(_230));
    _237 = _225 - float((int)(_231));
    _238 = _226 - float((int)(_232));
    _243 = ((int)(uint)((int)(_238 > _236))) + ((int)(uint)((int)(_237 > _236)));
    _248 = ((int)(uint)((int)(_238 > _237))) + ((int)(uint)((int)(_236 >= _237)));
    _253 = ((int)(uint)((int)(_236 >= _238))) + ((int)(uint)((int)(_237 >= _238)));
    _254 = (_243 == 0);
    _255 = (_248 == 0);
    _256 = (_253 == 0);
    _274 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_232), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_230), (int)(0))), (int)(47))), min((int)(max((int)(_231), (int)(0))), (int)(47)), 0));
    _289 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_256))) + _232))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_254))) + _230))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_255))) + _231))), (int)(0))), (int)(47)), 0));
    _304 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_253 < (uint)2)))) + _232))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_243 < (uint)2)))) + _230))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_248 < (uint)2)))) + _231))), (int)(0))), (int)(47)), 0));
    _319 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_232 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_230 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_231 + 1u))), (int)(0))), (int)(47)), 0));
    _326 = dot(float3(_236, _237, _238), float3(((float)((bool)_254)), ((float)((bool)_255)), ((float)((bool)_256))));
    _333 = dot(float3(_236, _237, _238), float3(((float)((bool)(uint)(_243 == 2))), ((float)((bool)(uint)(_248 == 2))), ((float)((bool)(uint)(_253 == 2)))));
    _337 = (((_237 + _236) + _238) - _326) - _333;
    _338 = 1.0f - _326;
    _342 = _326 - _337;
    _346 = _337 - _333;
    _355 = (((_333 * _319.x) + (_338 * _274.x)) + (_342 * _289.x)) + (_346 * _304.x);
    _358 = (((_333 * _319.y) + (_338 * _274.y)) + (_342 * _289.y)) + (_346 * _304.y);
    _361 = (((_333 * _319.z) + (_338 * _274.z)) + (_342 * _289.z)) + (_346 * _304.z);
    _363 = mad(0.21580375730991364f, _361, mad(0.3963377773761749f, _358, _355));
    _365 = mad(-0.0638541728258133f, _361, mad(-0.10556134581565857f, _358, _355));
    _367 = mad(-1.2914855480194092f, _361, mad(-0.08948417752981186f, _358, _355));
    _371 = (_363 * _363) * _363;
    _372 = (_365 * _365) * _365;
    _373 = (_367 * _367) * _367;
    _376 = mad(0.23096993565559387f, _373, mad(-3.307711601257324f, _372, (_371 * 4.076741695404053f)));
    _379 = mad(-0.34131938219070435f, _373, mad(2.609757423400879f, _372, (_371 * -1.2684379816055298f)));
    _382 = mad(1.7076146602630615f, _373, mad(-0.7034186124801636f, _372, (_371 * -0.004196086432784796f)));
    _384 = dot(float3(_376, _379, _382), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _395 = (lerp(_384, _376, g_fTonemapSaturation));
    _396 = (lerp(_384, _379, g_fTonemapSaturation));
    _397 = (lerp(_384, _382, g_fTonemapSaturation));
  } else {
    _395 = _173;
    _396 = _174;
    _397 = _175;
  }
  if (_102) {
    do {
      _953 = _395;
      _954 = _396;
      _955 = _397;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          if (TONE_MAP_TYPE == 0.f) {
            _403 = max(_395, 0.0f);
            _404 = max(_396, 0.0f);
            _405 = max(_397, 0.0f);
          } else {
            _403 = _395;
            _404 = _396;
            _405 = _397;
          }
          float3 agx_color = ApplyRemedyAgX(
              _403, _404, _405, _113,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
          _953 = agx_color.x;
          _954 = agx_color.y;
          _955 = agx_color.z;
#else
          _403 = max(_395, 0.0f);
          _404 = max(_396, 0.0f);
          _405 = max(_397, 0.0f);
          _452 = g_fAgxMaxEV - g_fAgxMinEV;
          _456 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _405, mad(g_vAgxInsetRow0.y, _404, (g_vAgxInsetRow0.x * _403))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _452);
          _457 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _405, mad(g_vAgxInsetRow1.y, _404, (g_vAgxInsetRow1.x * _403))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _452);
          _458 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _405, mad(g_vAgxInsetRow2.y, _404, (g_vAgxInsetRow2.x * _403))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _452);
          _467 = (g_fAgxContrastSlope * (_456 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _468 = 1.0f / g_fAgxShoulderPower;
          _485 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _487 = _485 * (0.6060606241226196f - _456);
          _488 = 1.0f / g_fAgxToePower;
          _507 = -0.0f - g_fAgxToePrecalcConstant;
          _510 = select((_456 >= 0.6060606241226196f), ((_467 / exp2(log2((float((int)(((int)(uint)((int)(_467 > 0.0f))) - ((int)(uint)((int)(_467 < 0.0f))))) * exp2(log2(abs(_467)) * g_fAgxShoulderPower)) + 1.0f) * _468)) * g_fAgxShoulderPrecalcConstant), ((_487 / exp2(log2((float((int)(((int)(uint)((int)(_487 > 0.0f))) - ((int)(uint)((int)(_487 < 0.0f))))) * exp2(log2(abs(_487)) * g_fAgxToePower)) + 1.0f) * _488)) * _507)) + 0.4894371032714844f;
          _513 = (g_fAgxContrastSlope * (_457 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _531 = _485 * (0.6060606241226196f - _457);
          _552 = select((_457 >= 0.6060606241226196f), ((_513 / exp2(log2((float((int)(((int)(uint)((int)(_513 > 0.0f))) - ((int)(uint)((int)(_513 < 0.0f))))) * exp2(log2(abs(_513)) * g_fAgxShoulderPower)) + 1.0f) * _468)) * g_fAgxShoulderPrecalcConstant), ((_531 / exp2(log2((exp2(log2(abs(_531)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_531 > 0.0f))) - ((int)(uint)((int)(_531 < 0.0f)))))) + 1.0f) * _488)) * _507)) + 0.4894371032714844f;
          _555 = (g_fAgxContrastSlope * (_458 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _573 = _485 * (0.6060606241226196f - _458);
          _594 = select((_458 >= 0.6060606241226196f), ((_555 / exp2(log2((float((int)(((int)(uint)((int)(_555 > 0.0f))) - ((int)(uint)((int)(_555 < 0.0f))))) * exp2(log2(abs(_555)) * g_fAgxShoulderPower)) + 1.0f) * _468)) * g_fAgxShoulderPrecalcConstant), ((_573 / exp2(log2((exp2(log2(abs(_573)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_573 > 0.0f))) - ((int)(uint)((int)(_573 < 0.0f)))))) + 1.0f) * _488)) * _507)) + 0.4894371032714844f;
          _613 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _594, mad(g_vAgxOutsetRow0.y, _552, (_510 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _614 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _594, mad(g_vAgxOutsetRow1.y, _552, (_510 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _615 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _594, mad(g_vAgxOutsetRow2.y, _552, (_510 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _733 = _613;
            _734 = _614;
            _735 = _615;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_613, max(_614, _615)) >= g_fAgxHDRMidGrey))) {
                _626 = log2(1.0f / g_fAgxHDRMidGrey);
                _627 = _626 + 20.0f;
                _628 = log2(g_fAgxHDRRatio);
                _647 = (min(max(log2(max(_613, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _626) + 20.0f) / _627;
                _648 = (min(max(log2(max(_614, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _626) + 20.0f) / _627;
                _649 = (min(max(log2(max(_615, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _626) + 20.0f) / _627;
                _650 = 20.0f / _627;
                _654 = max(_647, max(_648, _649));
                _659 = ((_654 - _650) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _676 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_650 - _654);
                _698 = select((_654 >= _650), ((_659 / exp2(log2((float((int)(((int)(uint)((int)(_659 > 0.0f))) - ((int)(uint)((int)(_659 < 0.0f))))) * exp2(log2(abs(_659)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_676 / exp2(log2((float((int)(((int)(uint)((int)(_676 > 0.0f))) - ((int)(uint)((int)(_676 < 0.0f))))) * exp2(log2(abs(_676)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _628) / _627);
                _704 = exp2((((_698 - _654) * _627) + _628) * g_fAgxHDRSaturation);
                _733 = (saturate(exp2(((_698 + (_704 * (_647 - _654))) * _627) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _734 = (saturate(exp2(((_698 + (_704 * (_648 - _654))) * _627) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _735 = (saturate(exp2(((_698 + (_704 * (_649 - _654))) * _627) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _733 = _613;
                _734 = _614;
                _735 = _615;
              }
            }
            _953 = (mad(-0.07283977419137955f, _735, mad(-0.5876564383506775f, _734, (_733 * 1.6604962348937988f))) * _113);
            _954 = (mad(-0.008348013274371624f, _735, mad(1.1328951120376587f, _734, (_733 * -0.1245470941066742f))) * _113);
            _955 = (mad(1.118751049041748f, _735, mad(-0.10059737414121628f, _734, (_733 * -0.018153680488467216f))) * _113);
          } while (false);
#endif
        } else {
          _403 = max(_395, 0.0f);
          _404 = max(_396, 0.0f);
          _405 = max(_397, 0.0f);
          _749 = dot(float3(_403, _404, _405), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
          do {
            _759 = _403;
            _760 = _404;
            _761 = _405;
            if (!(_749 == 0.0f)) {
              _754 = max(dot(float3(_395, _396, _397), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _749;
              _759 = (_754 * _403);
              _760 = (_754 * _404);
              _761 = (_754 * _405);
            }
            _767 = max(max(_759, max(_760, _761)), 0.0f);
            _769 = 1.0f / max(_767, 1.1754943508222875e-38f);
            _775 = (pow(_767, g_vTonemapGTParams.x));
            _783 = _775 / (((pow(_775, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
            _797 = exp2(log2(_769 * _759) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
            _798 = exp2(log2(_769 * _760) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
            _799 = exp2(log2(_769 * _761) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
            _804 = log2(_783);
            _832 = saturate(exp2(log2((exp2(_804 * g_vTonemapCrosstalk.x) * (1.0f - _797)) + _797) * g_vTonemapCrosstalkSaturation.x) * _783);
            _833 = saturate(exp2(log2((exp2(_804 * g_vTonemapCrosstalk.y) * (1.0f - _798)) + _798) * g_vTonemapCrosstalkSaturation.y) * _783);
            _834 = saturate(exp2(log2((exp2(_804 * g_vTonemapCrosstalk.z) * (1.0f - _799)) + _799) * g_vTonemapCrosstalkSaturation.z) * _783);
            if (_178) {
              do {
                _946 = _832;
                _947 = _833;
                _948 = _834;
                if (_104) {
                  do {
                    [branch]
                    if (!(_832 <= 0.0031308000907301903f)) {
                      _847 = (((pow(_832, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _847 = (_832 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_833 <= 0.0031308000907301903f)) {
                        _858 = (((pow(_833, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _858 = (_833 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_834 <= 0.0031308000907301903f)) {
                          _869 = (((pow(_834, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _869 = (_834 * 12.920000076293945f);
                        }
                        _876 = (saturate(_858) * 0.96875f) + 0.015625f;
                        _878 = max((saturate(_869) * 31.0f), 0.0f);
                        _879 = floor(_878);
                        _880 = _878 - _879;
                        _882 = (((saturate(_847) * 0.96875f) + 0.015625f) + _879) * 0.03125f;
                        _884 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_882, _876), 0.0f);
                        _888 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_882 + 0.03125f), _876), 0.0f);
                        _898 = ((_888.x - _884.x) * _880) + _884.x;
                        _899 = ((_888.y - _884.y) * _880) + _884.y;
                        _900 = ((_888.z - _884.z) * _880) + _884.z;
                        do {
                          [branch]
                          if (!(_898 <= 0.040449999272823334f)) {
                            _911 = exp2(log2((_898 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _911 = (_898 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_899 <= 0.040449999272823334f)) {
                              _922 = exp2(log2((_899 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _922 = (_899 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_900 <= 0.040449999272823334f)) {
                                _933 = exp2(log2((_900 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _933 = (_900 * 0.07739938050508499f);
                              }
                              _935 = dot(float3(_911, _922, _933), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _946 = (lerp(_935, _911, g_fTonemapSaturation));
                              _947 = (lerp(_935, _922, g_fTonemapSaturation));
                              _948 = (lerp(_935, _933, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _953 = (_946 * _113);
                _954 = (_947 * _113);
                _955 = (_948 * _113);
              } while (false);
            } else {
              _953 = _832;
              _954 = _833;
              _955 = _834;
            }
          } while (false);
        }
      }
      _964 = (_953 * g_fTonemapBrightness);
      _965 = (_954 * g_fTonemapBrightness);
      _966 = (_955 * g_fTonemapBrightness);
    } while (false);
  } else {
    _964 = (_395 * _113);
    _965 = (_396 * _113);
    _966 = (_397 * _113);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _978 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _985 = (_978.x * 2.0f) + -1.0f;
    _986 = (_978.y * 2.0f) + -1.0f;
    _987 = (_978.z * 2.0f) + -1.0f;
    if (!(_102)) {
      _990 = _964 / _113;
      _991 = _965 / _113;
      _992 = _966 / _113;
      _996 = 1.0f - sqrt(max(dot(float3(_990, _991, _992), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
      _1001 = g_fFilmGrainIntensity * (_113 * 5.0f);
      _1064 = ((((_1001 * _985) * saturate(_990)) * _996) + _964);
      _1065 = ((((_1001 * _986) * _996) * saturate(_991)) + _965);
      _1066 = ((((_1001 * _987) * _996) * saturate(_992)) + _966);
    } else {
      _1015 = saturate(_964);
      _1016 = saturate(_965);
      _1017 = saturate(_966);
      _1022 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_1015, max(_1016, _1017))));
      _1023 = _1022 * _1015;
      _1024 = _1022 * _1016;
      _1025 = _1022 * _1017;
      _1033 = ((1.0f - sqrt(dot(float3(_1023, _1024, _1025), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
      _1040 = ((_1033 * _985) * min(1.0f, _1023)) + _1023;
      _1041 = ((_1033 * _986) * min(1.0f, _1024)) + _1024;
      _1042 = ((_1033 * _987) * min(1.0f, _1025)) + _1025;
      _1046 = 1.0f / (max(_1040, max(_1041, _1042)) + 1.0f);
      _1053 = 1.0f / (max(_1023, max(_1024, _1025)) + 1.0f);
      _1064 = (((_1040 * _1046) + _964) - (_1053 * _1023));
      _1065 = (((_1041 * _1046) + _965) - (_1053 * _1024));
      _1066 = (((_1042 * _1046) + _966) - (_1053 * _1025));
    }
  } else {
    _1064 = _964;
    _1065 = _965;
    _1066 = _966;
  }
  if (!(_39)) {
    _1070 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _1071 = (uint)(int(SV_Position.y)) + (uint)(-48);
    uint2 _1072;
    g_tBaseColorCorrectionMap.GetDimensions(_1072.x, _1072.y);
    if (((int)_1071 < (int)int(float((int)((int)(_1072.y))))) && (((int)(_1071 | _1070) > (int)-1) && ((int)_1070 < (int)int(float((int)((int)(_1072.x))))))) {
      _1086 = g_tBaseColorCorrectionMap.Load(int3(_1070, _1071, 0));
      if (!(_178)) {
        _1092 = mad(0.21580375730991364f, _1086.z, mad(0.3963377773761749f, _1086.y, _1086.x));
        _1094 = mad(-0.0638541728258133f, _1086.z, mad(-0.10556134581565857f, _1086.y, _1086.x));
        _1096 = mad(-1.2914855480194092f, _1086.z, mad(-0.08948417752981186f, _1086.y, _1086.x));
        _1100 = (_1092 * _1092) * _1092;
        _1101 = (_1094 * _1094) * _1094;
        _1102 = (_1096 * _1096) * _1096;
        _1145 = mad(0.23096993565559387f, _1102, mad(-3.307711601257324f, _1101, (_1100 * 4.076741695404053f)));
        _1146 = mad(-0.34131938219070435f, _1102, mad(2.609757423400879f, _1101, (_1100 * -1.2684379816055298f)));
        _1147 = mad(1.7076146602630615f, _1102, mad(-0.7034186124801636f, _1101, (_1100 * -0.004196086432784796f)));
      } else {
        do {
          [branch]
          if (!(_1086.x <= 0.040449999272823334f)) {
            _1123 = exp2(log2((_1086.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
          } else {
            _1123 = (_1086.x * 0.07739938050508499f);
          }
          do {
            [branch]
            if (!(_1086.y <= 0.040449999272823334f)) {
              _1134 = exp2(log2((_1086.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1134 = (_1086.y * 0.07739938050508499f);
            }
            [branch]
            if (!(_1086.z <= 0.040449999272823334f)) {
              _1145 = _1123;
              _1146 = _1134;
              _1147 = exp2(log2((_1086.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1145 = _1123;
              _1146 = _1134;
              _1147 = (_1086.z * 0.07739938050508499f);
            }
          } while (false);
        } while (false);
      }
    } else {
      _1145 = _1064;
      _1146 = _1065;
      _1147 = _1066;
    }
  } else {
    _1145 = _1064;
    _1146 = _1065;
    _1147 = _1066;
  }
  if (!(g_bDebugValidateOutputRange == 0)) {
    _1154 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
    do {
      _1167 = true;
      if (!(((_1145 < 0.0f) || (_1146 < 0.0f)) || (_1147 < 0.0f))) {
        _1167 = ((_1147 > _1154) || ((_1145 > _1154) || (_1146 > _1154)));
      }
      if (_1167) {
        _1173 = float((int)(int(g_fRealTime * 15.0f)));
        _1183 = select((((((int)((uint)(int(SV_Position.y - _1173)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1173)) / 5u))) & 1) == 0), 1.0f, 0.0f);
        _1188 = (_1183 * _1145);
        _1189 = (_1183 * _1146);
        _1190 = (_1183 * _1147);
      } else {
        _1188 = _1145;
        _1189 = _1146;
        _1190 = _1147;
      }
    } while (false);
  } else {
    _1188 = _1145;
    _1189 = _1146;
    _1190 = _1147;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1196 = (g_bHDR == 0);
    do {
      _1223 = _1188;
      _1224 = _1189;
      _1225 = _1190;
      if (!(_1196 || (g_bHDR_scRGB == 0))) {
        _1210 = max(mad(0.043306104838848114f, _1190, mad(0.329291969537735f, _1189, (_1188 * 0.6274019479751587f))), 0.0f);
        _1211 = max(mad(0.0113602289929986f, _1190, mad(0.9195442795753479f, _1189, (_1188 * 0.06909549236297607f))), 0.0f);
        _1212 = max(mad(0.895578145980835f, _1190, mad(0.08802816271781921f, _1189, (_1188 * 0.016393709927797318f))), 0.0f);
        _1223 = mad(-0.07283977419137955f, _1212, mad(-0.5876564383506775f, _1211, (_1210 * 1.6604962348937988f)));
        _1224 = mad(-0.008348013274371624f, _1212, mad(1.1328951120376587f, _1211, (_1210 * -0.1245470941066742f)));
        _1225 = mad(1.118751049041748f, _1212, mad(-0.10059737414121628f, _1211, (_1210 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1196)) {
        _1241 = mad(0.043306104838848114f, _1225, mad(0.329291969537735f, _1224, (_1223 * 0.6274019479751587f)));
        _1242 = mad(0.0113602289929986f, _1225, mad(0.9195442795753479f, _1224, (_1223 * 0.06909549236297607f)));
        _1243 = mad(0.895578145980835f, _1225, mad(0.08802816271781921f, _1224, (_1223 * 0.016393709927797318f)));
      } else {
        _1241 = _1223;
        _1242 = _1224;
        _1243 = _1225;
      }
    } while (false);
  } else {
    _1241 = _1188;
    _1242 = _1189;
    _1243 = _1190;
  }
  SV_Target.x = _1241;
  SV_Target.y = _1242;
  SV_Target.z = _1243;
  SV_Target.w = 1.0f;
  return SV_Target;
}
