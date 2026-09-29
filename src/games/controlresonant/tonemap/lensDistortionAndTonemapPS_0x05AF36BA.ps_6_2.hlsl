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
  float _82;
  float _83;
  float _84;
  float _85;
  int _86;
  float _88;
  float _89;
  float _90;
  float _91;
  int _92;
  float _130;
  float _148;
  float _149;
  float _150;
  float _151;
  float _170;
  float _171;
  float _172;
  float _232;
  float _233;
  float _234;
  float _248;
  float _268;
  float _269;
  float _270;
  float _308;
  float _309;
  float _310;
  float _396;
  float _397;
  float _398;
  float _800;
  float _801;
  float _802;
  float _826;
  float _827;
  float _828;
  float _914;
  float _925;
  float _936;
  float _978;
  float _989;
  float _1000;
  float _1013;
  float _1014;
  float _1015;
  float _1020;
  float _1021;
  float _1022;
  float _1031;
  float _1032;
  float _1033;
  float _1131;
  float _1132;
  float _1133;
  float _1168;
  float _1179;
  float _1190;
  float _1191;
  float _1192;
  bool _1212;
  float _1233;
  float _1234;
  float _1235;
  float _1268;
  float _1269;
  float _1270;
  float _1286;
  float _1287;
  float _1288;
  float _44;
  float _48;
  float _49;
  float _53;
  float _57;
  float _69;
  float _70;
  float _95;
  float _96;
  float _104;
  float _105;
  float _110;
  float _115;
  float _116;
  float _117;
  float _118;
  float _123;
  float _124;
  float4 _136;
  int _152;
  int _155;
  float4 _165;
  bool _174;
  uint _178;
  uint _179;
  float _187;
  float _189;
  float _190;
  float _211;
  float _212;
  float _213;
  float _215;
  float _220;
  float _224;
  bool _237;
  bool _239;
  float _272;
  float _276;
  float _277;
  float _278;
  float _279;
  float _288;
  float _289;
  float _303;
  bool _313;
  float _329;
  float _330;
  float _331;
  float _359;
  float _361;
  float _362;
  float _363;
  float _365;
  float4 _367;
  float4 _371;
  float _381;
  float _382;
  float _383;
  float _385;
  float _404;
  float _405;
  float _406;
  float _453;
  float _457;
  float _458;
  float _459;
  float _468;
  float _469;
  float _486;
  float _488;
  float _489;
  float _508;
  float _511;
  float _514;
  float _532;
  float _553;
  float _556;
  float _574;
  float _595;
  float _614;
  float _615;
  float _616;
  float _627;
  float _628;
  float _641;
  float _642;
  float _643;
  float _650;
  float _653;
  float _658;
  float _673;
  float _676;
  float _695;
  float _701;
  float _718;
  float _742;
  float _759;
  float _816;
  float _821;
  float _834;
  float _836;
  float _842;
  float _850;
  float _864;
  float _865;
  float _866;
  float _871;
  float _899;
  float _900;
  float _901;
  float _943;
  float _945;
  float _946;
  float _947;
  float _949;
  float4 _951;
  float4 _955;
  float _965;
  float _966;
  float _967;
  float _1002;
  float4 _1045;
  float _1052;
  float _1053;
  float _1054;
  float _1057;
  float _1058;
  float _1059;
  float _1063;
  float _1068;
  float _1082;
  float _1083;
  float _1084;
  float _1089;
  float _1090;
  float _1091;
  float _1092;
  float _1100;
  float _1107;
  float _1108;
  float _1109;
  float _1113;
  float _1120;
  uint _1137;
  uint _1138;
  uint2 _1139;
  float4 _1153;
  float _1199;
  float _1218;
  float _1228;
  bool _1241;
  float _1255;
  float _1256;
  float _1257;
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
  _82 = 0.0f;
  _83 = 0.0f;
  _84 = 0.0f;
  _85 = 0.0f;
  _86 = -1;
  bool _loop_break_0 = false;
  while(true) {
    _88 = _82;
    _89 = _83;
    _90 = _84;
    _91 = _85;
    _92 = -1;
    bool _loop_break_1 = false;
    while(true) {
      _95 = (floor(_69 * g_vSourceRes.x) + 0.5f) + float((int)(_92));
      _96 = (floor(_70 * g_vSourceRes.y) + 0.5f) + float((int)(_86));
      _104 = (_69 - (_95 / g_vSourceRes.x)) * g_vSourceRes.x;
      _105 = (_70 - (_96 / g_vSourceRes.y)) * g_vSourceRes.y;
      _110 = sqrt((_105 * _105) + (_104 * _104)) * g_fLensDistortionJincSize;
      if (!(_110 > 1.2196699380874634f)) {
        _115 = 0.652899980545044f - (_110 * 1.0068999528884888f);
        _116 = (_110 * 0.59170001745224f) + 0.8378999829292297f;
        _117 = _115 * _115;
        _118 = _116 * _116;
        _123 = mad(-0.5547999739646912f, _118, (_117 * 0.5823000073432922f)) + 0.15240000188350677f;
        _124 = mad(0.4828000068664551f, _118, (_117 * -0.47380000352859497f)) + -0.22939999401569366f;
        _130 = (dot(float2((_123 * _123), (_124 * _124)), float2(-0.7231000065803528f, -0.44690001010894775f)) + 0.9991000294685364f);
      } else {
        _130 = 0.0f;
      }
      if (abs(_130) > 0.0f) {
        _136 = g_tSource.Load(int3((int)(uint(_95)), (int)(uint(_96)), 0));
        _148 = ((_136.x * _130) + _88);
        _149 = ((_136.y * _130) + _89);
        _150 = ((_136.z * _130) + _90);
        _151 = (_130 + _91);
      } else {
        _148 = _88;
        _149 = _89;
        _150 = _90;
        _151 = _91;
      }
      _152 = _92 + 1;
      if (!(_152 == 2)) {
        _88 = _148;
        _89 = _149;
        _90 = _150;
        _91 = _151;
        _92 = _152;
        continue;
      }
      _155 = _86 + 1;
      if (!(_155 == 2)) {
        _82 = _148;
        _83 = _149;
        _84 = _150;
        _85 = _151;
        _86 = _155;
        _loop_break_0 = true;
        break;
      }
      if (!(g_bDebugReferenceImage == 0)) {
        _165 = g_tSourceReferenceImage.Sample(g_sLinearClamp_internal, float2(_21, _22));
        _170 = _165.x;
        _171 = _165.y;
        _172 = _165.z;
      } else {
        _170 = (_148 / _151);
        _171 = (_149 / _151);
        _172 = (_150 / _151);
      }
      _174 = (g_bDebugLUT == 0);
      if (!(_174)) {
        _178 = (uint)(int(SV_Position.x)) + (uint)(-96);
        _179 = (uint)(int(SV_Position.y)) + (uint)(-112);
        if (((int)_179 < (int)300) && (((int)_178 < (int)500) && ((int)(_179 | _178) > (int)-1))) {
          _187 = float((int)(_178));
          _189 = _187 * 0.0020000000949949026f;
          _190 = float((int)(_179)) * 0.005333333276212215f;
          _211 = saturate(2.0f - (abs(frac(_190) + -0.5f) * 6.0f)) * 2.0f;
          _212 = saturate(2.0f - (abs(frac(_190 + 0.3333333432674408f) + -0.5f) * 6.0f)) * 2.0f;
          _213 = saturate(2.0f - (abs(frac(_190 + -0.3333333432674408f) + -0.5f) * 6.0f)) * 2.0f;
          _215 = g_bBrightness[0];
          _220 = _189 * _189;
          _224 = ((_187 * 0.25f) * (_220 * _220)) * (_215 / exp2(g_fExposureCompensationInEV100));
          _232 = ((_211 * _211) * _224);
          _233 = ((_212 * _212) * _224);
          _234 = ((_213 * _213) * _224);
        } else {
          _232 = _170;
          _233 = _171;
          _234 = _172;
        }
      } else {
        _232 = _170;
        _233 = _171;
        _234 = _172;
      }
      _237 = (g_bPostProcessApplyTonemap != 0);
      _239 = (g_bPostProcessApplyColorGrade != 0);
      if (!(g_bPostProcessApplyTonemap == 0)) {
        _248 = g_fPaperWhite;
      } else {
        _248 = 1.0f;
      }
      if (_239) {
        _268 = max(_232, 0.0f);
        _269 = max(_233, 0.0f);
        _270 = max(_234, 0.0f);
      } else {
        _268 = _232;
        _269 = _233;
        _270 = _234;
      }
      _272 = g_bBrightness[1];
      _276 = exp2(g_fExposureCompensationInEV100) * _272;
      _277 = _276 * _268;
      _278 = _276 * _269;
      _279 = _276 * _270;
      if (!(g_bApplyVignette == 0)) {
        _288 = ((((g_vOverriddenAspectRatioUVScale.x * _21) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
        _289 = (((g_vOverriddenAspectRatioUVScale.y * _22) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
        _303 = saturate(exp2(log2(saturate(1.0f - sqrt((_288 * _288) + (_289 * _289))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
        _308 = (_303 * _277);
        _309 = (_303 * _278);
        _310 = (_303 * _279);
      } else {
        _308 = _277;
        _309 = _278;
        _310 = _279;
      }
      _313 = (g_bEnableHDRLUT == 0);
      if (!(_313 || (!_239))) {
      #if 1
        float3 graded_color = ApplyVanillaPQLUT(
            float3(_308, _309, _310), g_tBaseColorCorrectionMap, g_sLinearClamp_internal, g_fTonemapSaturation);
        _396 = graded_color.x;
        _397 = graded_color.y;
        _398 = graded_color.z;
      #else
        _329 = exp2(log2(saturate(_308 * 0.00800000037997961f)) * 0.1593017578125f);
        _330 = exp2(log2(saturate(_309 * 0.00800000037997961f)) * 0.1593017578125f);
        _331 = exp2(log2(saturate(_310 * 0.00800000037997961f)) * 0.1593017578125f);
        _359 = (exp2(log2(((_330 * 18.8515625f) + 0.8359375f) / ((_330 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
        _361 = max((exp2(log2(((_331 * 18.8515625f) + 0.8359375f) / ((_331 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
        _362 = floor(_361);
        _363 = _361 - _362;
        _365 = (((exp2(log2(((_329 * 18.8515625f) + 0.8359375f) / ((_329 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _362) * 0.02083333395421505f;
        _367 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_365, _359), 0.0f);
        _371 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_365 + 0.02083333395421505f), _359), 0.0f);
        _381 = ((_371.x - _367.x) * _363) + _367.x;
        _382 = ((_371.y - _367.y) * _363) + _367.y;
        _383 = ((_371.z - _367.z) * _363) + _367.z;
        _385 = dot(float3(_381, _382, _383), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _396 = (lerp(_385, _381, g_fTonemapSaturation));
        _397 = (lerp(_385, _382, g_fTonemapSaturation));
        _398 = (lerp(_385, _383, g_fTonemapSaturation));
      #endif
      } else {
        _396 = _308;
        _397 = _309;
        _398 = _310;
      }
      if (_237) {
        do {
          _1020 = _396;
          _1021 = _397;
          _1022 = _398;
          if (!(g_iTonemapper == 0)) {
            _404 = max(_396, 0.0f);
            _405 = max(_397, 0.0f);
            _406 = max(_398, 0.0f);
            if (g_iTonemapper == 2) {
#if 1
              float3 agx_color = ApplyRemedyAgX(
                  _404, _405, _406, _248,
                  g_fAgxMinEV, g_fAgxMaxEV,
                  g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
                  g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
                  g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
                  g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
                  g_fAgxHDRRatio, g_fAgxHDRMidGrey,
                  g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
                  SV_Position.xy * g_vInvOutputRes);
              _1020 = agx_color.x;
              _1021 = agx_color.y;
              _1022 = agx_color.z;
#else
              _453 = g_fAgxMaxEV - g_fAgxMinEV;
              _457 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _406, mad(g_vAgxInsetRow0.y, _405, (g_vAgxInsetRow0.x * _404))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _453);
              _458 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _406, mad(g_vAgxInsetRow1.y, _405, (g_vAgxInsetRow1.x * _404))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _453);
              _459 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _406, mad(g_vAgxInsetRow2.y, _405, (g_vAgxInsetRow2.x * _404))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _453);
              _468 = (g_fAgxContrastSlope * (_457 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _469 = 1.0f / g_fAgxShoulderPower;
              _486 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
              _488 = _486 * (0.6060606241226196f - _457);
              _489 = 1.0f / g_fAgxToePower;
              _508 = -0.0f - g_fAgxToePrecalcConstant;
              _511 = select((_457 >= 0.6060606241226196f), ((_468 / exp2(log2((float((int)(((int)(uint)((int)(_468 > 0.0f))) - ((int)(uint)((int)(_468 < 0.0f))))) * exp2(log2(abs(_468)) * g_fAgxShoulderPower)) + 1.0f) * _469)) * g_fAgxShoulderPrecalcConstant), ((_488 / exp2(log2((float((int)(((int)(uint)((int)(_488 > 0.0f))) - ((int)(uint)((int)(_488 < 0.0f))))) * exp2(log2(abs(_488)) * g_fAgxToePower)) + 1.0f) * _489)) * _508)) + 0.4894371032714844f;
              _514 = (g_fAgxContrastSlope * (_458 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _532 = _486 * (0.6060606241226196f - _458);
              _553 = select((_458 >= 0.6060606241226196f), ((_514 / exp2(log2((float((int)(((int)(uint)((int)(_514 > 0.0f))) - ((int)(uint)((int)(_514 < 0.0f))))) * exp2(log2(abs(_514)) * g_fAgxShoulderPower)) + 1.0f) * _469)) * g_fAgxShoulderPrecalcConstant), ((_532 / exp2(log2((exp2(log2(abs(_532)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_532 > 0.0f))) - ((int)(uint)((int)(_532 < 0.0f)))))) + 1.0f) * _489)) * _508)) + 0.4894371032714844f;
              _556 = (g_fAgxContrastSlope * (_459 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _574 = _486 * (0.6060606241226196f - _459);
              _595 = select((_459 >= 0.6060606241226196f), ((_556 / exp2(log2((float((int)(((int)(uint)((int)(_556 > 0.0f))) - ((int)(uint)((int)(_556 < 0.0f))))) * exp2(log2(abs(_556)) * g_fAgxShoulderPower)) + 1.0f) * _469)) * g_fAgxShoulderPrecalcConstant), ((_574 / exp2(log2((exp2(log2(abs(_574)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_574 > 0.0f))) - ((int)(uint)((int)(_574 < 0.0f)))))) + 1.0f) * _489)) * _508)) + 0.4894371032714844f;
              _614 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _595, mad(g_vAgxOutsetRow0.y, _553, (_511 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
              _615 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _595, mad(g_vAgxOutsetRow1.y, _553, (_511 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
              _616 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _595, mad(g_vAgxOutsetRow2.y, _553, (_511 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
              do {
                _800 = _614;
                _801 = _615;
                _802 = _616;
                if (g_fAgxHDRRatio > 1.0f) {
                  if (!(!(max(_614, max(_615, _616)) >= g_fAgxHDRMidGrey))) {
                    _627 = log2(1.0f / g_fAgxHDRMidGrey);
                    _628 = _627 + 20.0f;
                    _641 = min(max(log2(max(_614, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _627);
                    _642 = min(max(log2(max(_615, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _627);
                    _643 = min(max(log2(max(_616, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _627);
                    _650 = 20.0f / _628;
                    _653 = (20.0f - log2(g_fAgxHDRRatio)) / _628;
                    _658 = ((_641 / _628) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _673 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                    _676 = ((-0.0f - _641) / _628) * _673;
                    _695 = -0.0f - g_fAgxHDRToePrecalcConstant;
                    _701 = ((_642 / _628) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _718 = ((-0.0f - _642) / _628) * _673;
                    _742 = ((_643 / _628) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _759 = ((-0.0f - _643) / _628) * _673;
                    _800 = (saturate(exp2(((select((((_641 + 20.0f) / _628) >= _650), ((_658 / exp2(log2((float((int)(((int)(uint)((int)(_658 > 0.0f))) - ((int)(uint)((int)(_658 < 0.0f))))) * exp2(log2(abs(_658)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_676 / exp2(log2((float((int)(((int)(uint)((int)(_676 > 0.0f))) - ((int)(uint)((int)(_676 < 0.0f))))) * exp2(log2(abs(_676)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _695)) + _653) * _628) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _801 = (saturate(exp2(((select((((_642 + 20.0f) / _628) >= _650), ((_701 / exp2(log2((float((int)(((int)(uint)((int)(_701 > 0.0f))) - ((int)(uint)((int)(_701 < 0.0f))))) * exp2(log2(abs(_701)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_718 / exp2(log2((float((int)(((int)(uint)((int)(_718 > 0.0f))) - ((int)(uint)((int)(_718 < 0.0f))))) * exp2(log2(abs(_718)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _695)) + _653) * _628) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _802 = (saturate(exp2(((select((((_643 + 20.0f) / _628) >= _650), ((_742 / exp2(log2((float((int)(((int)(uint)((int)(_742 > 0.0f))) - ((int)(uint)((int)(_742 < 0.0f))))) * exp2(log2(abs(_742)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_759 / exp2(log2((float((int)(((int)(uint)((int)(_759 > 0.0f))) - ((int)(uint)((int)(_759 < 0.0f))))) * exp2(log2(abs(_759)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _695)) + _653) * _628) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                  } else {
                    _800 = _614;
                    _801 = _615;
                    _802 = _616;
                  }
                }
                _1020 = (mad(-0.07283977419137955f, _802, mad(-0.5876564383506775f, _801, (_800 * 1.6604962348937988f))) * _248);
                _1021 = (mad(-0.008348013274371624f, _802, mad(1.1328951120376587f, _801, (_800 * -0.1245470941066742f))) * _248);
                _1022 = (mad(1.118751049041748f, _802, mad(-0.10059737414121628f, _801, (_800 * -0.018153680488467216f))) * _248);
              } while (false);
#endif
              if (_loop_break_1 && !_loop_break_0) break;
            } else {
              _816 = dot(float3(_404, _405, _406), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
              do {
                _826 = _404;
                _827 = _405;
                _828 = _406;
                if (!(_816 == 0.0f)) {
                  _821 = max(dot(float3(_396, _397, _398), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _816;
                  _826 = (_821 * _404);
                  _827 = (_821 * _405);
                  _828 = (_821 * _406);
                }
                _834 = max(max(_826, max(_827, _828)), 0.0f);
                _836 = 1.0f / max(_834, 1.1754943508222875e-38f);
                _842 = (pow(_834, g_vTonemapGTParams.x));
                _850 = _842 / (((pow(_842, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
                _864 = exp2(log2(_836 * _826) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
                _865 = exp2(log2(_836 * _827) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
                _866 = exp2(log2(_836 * _828) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
                _871 = log2(_850);
                _899 = saturate(exp2(log2((exp2(_871 * g_vTonemapCrosstalk.x) * (1.0f - _864)) + _864) * g_vTonemapCrosstalkSaturation.x) * _850);
                _900 = saturate(exp2(log2((exp2(_871 * g_vTonemapCrosstalk.y) * (1.0f - _865)) + _865) * g_vTonemapCrosstalkSaturation.y) * _850);
                _901 = saturate(exp2(log2((exp2(_871 * g_vTonemapCrosstalk.z) * (1.0f - _866)) + _866) * g_vTonemapCrosstalkSaturation.z) * _850);
                if (_313) {
                  do {
                    _1013 = _899;
                    _1014 = _900;
                    _1015 = _901;
                    if (_239) {
                      do {
                        [branch]
                        if (!(_899 <= 0.0031308000907301903f)) {
                          _914 = (((pow(_899, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _914 = (_899 * 12.920000076293945f);
                        }
                        do {
                          [branch]
                          if (!(_900 <= 0.0031308000907301903f)) {
                            _925 = (((pow(_900, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          } else {
                            _925 = (_900 * 12.920000076293945f);
                          }
                          do {
                            [branch]
                            if (!(_901 <= 0.0031308000907301903f)) {
                              _936 = (((pow(_901, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            } else {
                              _936 = (_901 * 12.920000076293945f);
                            }
                            _943 = (saturate(_925) * 0.96875f) + 0.015625f;
                            _945 = max((saturate(_936) * 31.0f), 0.0f);
                            _946 = floor(_945);
                            _947 = _945 - _946;
                            _949 = (((saturate(_914) * 0.96875f) + 0.015625f) + _946) * 0.03125f;
                            _951 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_949, _943), 0.0f);
                            _955 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_949 + 0.03125f), _943), 0.0f);
                            _965 = ((_955.x - _951.x) * _947) + _951.x;
                            _966 = ((_955.y - _951.y) * _947) + _951.y;
                            _967 = ((_955.z - _951.z) * _947) + _951.z;
                            do {
                              [branch]
                              if (!(_965 <= 0.040449999272823334f)) {
                                _978 = exp2(log2((_965 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _978 = (_965 * 0.07739938050508499f);
                              }
                              do {
                                [branch]
                                if (!(_966 <= 0.040449999272823334f)) {
                                  _989 = exp2(log2((_966 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                } else {
                                  _989 = (_966 * 0.07739938050508499f);
                                }
                                do {
                                  [branch]
                                  if (!(_967 <= 0.040449999272823334f)) {
                                    _1000 = exp2(log2((_967 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                  } else {
                                    _1000 = (_967 * 0.07739938050508499f);
                                  }
                                  _1002 = dot(float3(_978, _989, _1000), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                                  _1013 = (lerp(_1002, _978, g_fTonemapSaturation));
                                  _1014 = (lerp(_1002, _989, g_fTonemapSaturation));
                                  _1015 = (lerp(_1002, _1000, g_fTonemapSaturation));
                                } while (false);
                                if (_loop_break_1 && !_loop_break_0) break;
                              } while (false);
                              if (_loop_break_1 && !_loop_break_0) break;
                            } while (false);
                            if (_loop_break_1 && !_loop_break_0) break;
                          } while (false);
                          if (_loop_break_1 && !_loop_break_0) break;
                        } while (false);
                        if (_loop_break_1 && !_loop_break_0) break;
                      } while (false);
                      if (_loop_break_1 && !_loop_break_0) break;
                    }
                    _1020 = (_1013 * _248);
                    _1021 = (_1014 * _248);
                    _1022 = (_1015 * _248);
                  } while (false);
                  if (_loop_break_1 && !_loop_break_0) break;
                } else {
                  _1020 = _899;
                  _1021 = _900;
                  _1022 = _901;
                }
              } while (false);
              if (_loop_break_1 && !_loop_break_0) break;
            }
          }
          _1031 = (_1020 * g_fTonemapBrightness);
          _1032 = (_1021 * g_fTonemapBrightness);
          _1033 = (_1022 * g_fTonemapBrightness);
        } while (false);
        if (_loop_break_1 && !_loop_break_0) { _loop_break_1 = false; continue; }
      } else {
        _1031 = (_396 * _248);
        _1032 = (_397 * _248);
        _1033 = (_398 * _248);
      }
      if (!(g_bApplyFilmGrain == 0)) {
        _1045 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
        _1052 = (_1045.x * 2.0f) + -1.0f;
        _1053 = (_1045.y * 2.0f) + -1.0f;
        _1054 = (_1045.z * 2.0f) + -1.0f;
        if (!(_237)) {
          _1057 = _1031 / _248;
          _1058 = _1032 / _248;
          _1059 = _1033 / _248;
          _1063 = 1.0f - sqrt(max(dot(float3(_1057, _1058, _1059), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
          _1068 = g_fFilmGrainIntensity * (_248 * 5.0f);
          _1131 = ((((_1068 * _1052) * saturate(_1057)) * _1063) + _1031);
          _1132 = ((((_1068 * _1053) * _1063) * saturate(_1058)) + _1032);
          _1133 = ((((_1068 * _1054) * _1063) * saturate(_1059)) + _1033);
        } else {
          _1082 = saturate(_1031);
          _1083 = saturate(_1032);
          _1084 = saturate(_1033);
          _1089 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_1082, max(_1083, _1084))));
          _1090 = _1089 * _1082;
          _1091 = _1089 * _1083;
          _1092 = _1089 * _1084;
          _1100 = ((1.0f - sqrt(dot(float3(_1090, _1091, _1092), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
          _1107 = ((_1100 * _1052) * min(1.0f, _1090)) + _1090;
          _1108 = ((_1100 * _1053) * min(1.0f, _1091)) + _1091;
          _1109 = ((_1100 * _1054) * min(1.0f, _1092)) + _1092;
          _1113 = 1.0f / (max(_1107, max(_1108, _1109)) + 1.0f);
          _1120 = 1.0f / (max(_1090, max(_1091, _1092)) + 1.0f);
          _1131 = (((_1107 * _1113) + _1031) - (_1120 * _1090));
          _1132 = (((_1108 * _1113) + _1032) - (_1120 * _1091));
          _1133 = (((_1109 * _1113) + _1033) - (_1120 * _1092));
        }
      } else {
        _1131 = _1031;
        _1132 = _1032;
        _1133 = _1033;
      }
      if (!(_174)) {
        _1137 = (uint)(int(SV_Position.x)) + (uint)(-96);
        _1138 = (uint)(int(SV_Position.y)) + (uint)(-48);
        uint2 _1139; g_tBaseColorCorrectionMap.GetDimensions(_1139.x, _1139.y);
        if (((int)_1138 < (int)int(float((int)((int)(_1139.y))))) && (((int)(_1138 | _1137) > (int)-1) && ((int)_1137 < (int)int(float((int)((int)(_1139.x))))))) {
          _1153 = g_tBaseColorCorrectionMap.Load(int3(_1137, _1138, 0));
          if (_313) {
            do {
              [branch]
              if (!(_1153.x <= 0.040449999272823334f)) {
                _1168 = exp2(log2((_1153.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
              } else {
                _1168 = (_1153.x * 0.07739938050508499f);
              }
              do {
                [branch]
                if (!(_1153.y <= 0.040449999272823334f)) {
                  _1179 = exp2(log2((_1153.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                } else {
                  _1179 = (_1153.y * 0.07739938050508499f);
                }
                [branch]
                if (!(_1153.z <= 0.040449999272823334f)) {
                  _1190 = _1168;
                  _1191 = _1179;
                  _1192 = exp2(log2((_1153.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                } else {
                  _1190 = _1168;
                  _1191 = _1179;
                  _1192 = (_1153.z * 0.07739938050508499f);
                }
              } while (false);
              if (_loop_break_1 && !_loop_break_0) break;
            } while (false);
            if (_loop_break_1 && !_loop_break_0) { _loop_break_1 = false; continue; }
          } else {
            _1190 = _1153.x;
            _1191 = _1153.y;
            _1192 = _1153.z;
          }
        } else {
          _1190 = _1131;
          _1191 = _1132;
          _1192 = _1133;
        }
      } else {
        _1190 = _1131;
        _1191 = _1132;
        _1192 = _1133;
      }
      if (!(g_bDebugValidateOutputRange == 0)) {
        _1199 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
        do {
          _1212 = true;
          if (!(((_1190 < 0.0f) || (_1191 < 0.0f)) || (_1192 < 0.0f))) {
            _1212 = ((_1192 > _1199) || ((_1190 > _1199) || (_1191 > _1199)));
          }
          if (_1212) {
            _1218 = float((int)(int(g_fRealTime * 15.0f)));
            _1228 = select((((((int)((uint)(int(SV_Position.y - _1218)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1218)) / 5u))) & 1) == 0), 1.0f, 0.0f);
            _1233 = (_1228 * _1190);
            _1234 = (_1228 * _1191);
            _1235 = (_1228 * _1192);
          } else {
            _1233 = _1190;
            _1234 = _1191;
            _1235 = _1192;
          }
        } while (false);
        if (_loop_break_1 && !_loop_break_0) { _loop_break_1 = false; continue; }
      } else {
        _1233 = _1190;
        _1234 = _1191;
        _1235 = _1192;
      }
      if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
        _1241 = (g_bHDR == 0);
        do {
          _1268 = _1233;
          _1269 = _1234;
          _1270 = _1235;
          if (!(_1241 || (g_bHDR_scRGB == 0))) {
            _1255 = max(mad(0.043306104838848114f, _1235, mad(0.329291969537735f, _1234, (_1233 * 0.6274019479751587f))), 0.0f);
            _1256 = max(mad(0.0113602289929986f, _1235, mad(0.9195442795753479f, _1234, (_1233 * 0.06909549236297607f))), 0.0f);
            _1257 = max(mad(0.895578145980835f, _1235, mad(0.08802816271781921f, _1234, (_1233 * 0.016393709927797318f))), 0.0f);
            _1268 = mad(-0.07283977419137955f, _1257, mad(-0.5876564383506775f, _1256, (_1255 * 1.6604962348937988f)));
            _1269 = mad(-0.008348013274371624f, _1257, mad(1.1328951120376587f, _1256, (_1255 * -0.1245470941066742f)));
            _1270 = mad(1.118751049041748f, _1257, mad(-0.10059737414121628f, _1256, (_1255 * -0.018153680488467216f)));
          }
          if ((g_bHDR_scRGB == 0) && (!_1241)) {
            _1286 = mad(0.043306104838848114f, _1270, mad(0.329291969537735f, _1269, (_1268 * 0.6274019479751587f)));
            _1287 = mad(0.0113602289929986f, _1270, mad(0.9195442795753479f, _1269, (_1268 * 0.06909549236297607f)));
            _1288 = mad(0.895578145980835f, _1270, mad(0.08802816271781921f, _1269, (_1268 * 0.016393709927797318f)));
          } else {
            _1286 = _1268;
            _1287 = _1269;
            _1288 = _1270;
          }
        } while (false);
        if (_loop_break_1 && !_loop_break_0) { _loop_break_1 = false; continue; }
      } else {
        _1286 = _1233;
        _1287 = _1234;
        _1288 = _1235;
      }
      SV_Target.x = _1286;
      SV_Target.y = _1287;
      SV_Target.z = _1288;
      SV_Target.w = 1.0f;
      break;
    }
    if (_loop_break_0) { _loop_break_0 = false; continue; }
    break;
  }
  return SV_Target;
}