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
  float _247;
  float _267;
  float _268;
  float _269;
  float _307;
  float _308;
  float _309;
  float _395;
  float _396;
  float _397;
  float _799;
  float _800;
  float _801;
  float _829;
  float _830;
  float _831;
  float _916;
  float _927;
  float _938;
  float _980;
  float _991;
  float _1002;
  float _1015;
  float _1016;
  float _1017;
  float _1176;
  float _1177;
  float _1178;
  float _1187;
  float _1188;
  float _1189;
  float _1237;
  float _1238;
  float _1239;
  float _1274;
  float _1285;
  float _1296;
  float _1297;
  float _1298;
  bool _1327;
  float _1348;
  float _1349;
  float _1350;
  float _1383;
  float _1384;
  float _1385;
  float _1401;
  float _1402;
  float _1403;
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
  float _271;
  float _275;
  float _276;
  float _277;
  float _278;
  float _287;
  float _288;
  float _302;
  bool _312;
  float _328;
  float _329;
  float _330;
  float _358;
  float _360;
  float _361;
  float _362;
  float _364;
  float4 _366;
  float4 _370;
  float _380;
  float _381;
  float _382;
  float _384;
  float _428;
  float _429;
  float _430;
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
  float _640;
  float _641;
  float _642;
  float _649;
  float _652;
  float _657;
  float _672;
  float _675;
  float _694;
  float _700;
  float _717;
  float _741;
  float _758;
  float _816;
  float _817;
  float _818;
  float _819;
  float _824;
  float _837;
  float _839;
  float _845;
  float _853;
  float _867;
  float _868;
  float _869;
  float _874;
  float _902;
  float _903;
  float _904;
  float _945;
  float _947;
  float _948;
  float _949;
  float _951;
  float4 _953;
  float4 _957;
  float _967;
  float _968;
  float _969;
  float _1004;
  float _1026;
  float _1031;
  float _1033;
  float _1034;
  float _1035;
  float _1036;
  float _1046;
  float _1050;
  float _1099;
  float _1100;
  float _1101;
  float _1106;
  float _1119;
  float _1120;
  float _1121;
  float _1153;
  float _1155;
  float _1157;
  float _1158;
  float _1171;
  float4 _1201;
  float _1211;
  float _1212;
  float _1213;
  float _1217;
  float _1223;
  uint _1243;
  uint _1244;
  uint2 _1245;
  float4 _1259;
  float _1304;
  float _1307;
  float _1310;
  float _1314;
  float _1333;
  float _1343;
  bool _1356;
  float _1370;
  float _1371;
  float _1372;
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
      _237 = (g_bPostProcessApplyTonemap == 0);
      _239 = (g_bPostProcessApplyColorGrade != 0);
      if (!(_237)) {
        _247 = g_fPaperWhite;
      } else {
        _247 = 1.0f;
      }
      if (_239) {
        _267 = max(_232, 0.0f);
        _268 = max(_233, 0.0f);
        _269 = max(_234, 0.0f);
      } else {
        _267 = _232;
        _268 = _233;
        _269 = _234;
      }
      _271 = g_bBrightness[1];
      _275 = exp2(g_fExposureCompensationInEV100) * _271;
      _276 = _275 * _267;
      _277 = _275 * _268;
      _278 = _275 * _269;
      if (!(g_bApplyVignette == 0)) {
        _287 = ((((g_vOverriddenAspectRatioUVScale.x * _21) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
        _288 = (((g_vOverriddenAspectRatioUVScale.y * _22) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
        _302 = saturate(exp2(log2(saturate(1.0f - sqrt((_287 * _287) + (_288 * _288))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
        _307 = (_302 * _276);
        _308 = (_302 * _277);
        _309 = (_302 * _278);
      } else {
        _307 = _276;
        _308 = _277;
        _309 = _278;
      }
      _312 = (g_bEnableHDRLUT == 0);
      if (!(_312 || (!_239))) {
      #if 1
        float3 graded_color = ApplyVanillaPQLUT(
            float3(_307, _308, _309), g_tBaseColorCorrectionMap, g_sLinearClamp_internal, g_fTonemapSaturation);
        _395 = graded_color.x;
        _396 = graded_color.y;
        _397 = graded_color.z;
      #else
        _328 = exp2(log2(saturate(_307 * 0.00800000037997961f)) * 0.1593017578125f);
        _329 = exp2(log2(saturate(_308 * 0.00800000037997961f)) * 0.1593017578125f);
        _330 = exp2(log2(saturate(_309 * 0.00800000037997961f)) * 0.1593017578125f);
        _358 = (exp2(log2(((_329 * 18.8515625f) + 0.8359375f) / ((_329 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
        _360 = max((exp2(log2(((_330 * 18.8515625f) + 0.8359375f) / ((_330 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
        _361 = floor(_360);
        _362 = _360 - _361;
        _364 = (((exp2(log2(((_328 * 18.8515625f) + 0.8359375f) / ((_328 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _361) * 0.02083333395421505f;
        _366 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_364, _358), 0.0f);
        _370 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_364 + 0.02083333395421505f), _358), 0.0f);
        _380 = ((_370.x - _366.x) * _362) + _366.x;
        _381 = ((_370.y - _366.y) * _362) + _366.y;
        _382 = ((_370.z - _366.z) * _362) + _366.z;
        _384 = dot(float3(_380, _381, _382), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _395 = (lerp(_384, _380, g_fTonemapSaturation));
        _396 = (lerp(_384, _381, g_fTonemapSaturation));
        _397 = (lerp(_384, _382, g_fTonemapSaturation));
      #endif
      } else {
        _395 = _307;
        _396 = _308;
        _397 = _309;
      }
      if (!(_237)) {
        do {
          _1176 = _395;
          _1177 = _396;
          _1178 = _397;
          if (!(g_iTonemapper == 0)) {
            if (g_iTonemapper == 2) {
#if 1
              float3 agx_color = ApplyRemedyAgX(
                  _395, _396, _397, _247,
                  g_fAgxMinEV, g_fAgxMaxEV,
                  g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
                  g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
                  g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
                  g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
                  g_fAgxHDRRatio, g_fAgxHDRMidGrey,
                  g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
                  SV_Position.xy * g_vInvOutputRes);
              _1176 = agx_color.x;
              _1177 = agx_color.y;
              _1178 = agx_color.z;
#else
              _428 = max(_395, 0.0f);
              _429 = max(_396, 0.0f);
              _430 = max(_397, 0.0f);
              _452 = g_fAgxMaxEV - g_fAgxMinEV;
              _456 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _430, mad(g_vAgxInsetRow0.y, _429, (_428 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _452);
              _457 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _430, mad(g_vAgxInsetRow1.y, _429, (_428 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _452);
              _458 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _430, mad(g_vAgxInsetRow2.y, _429, (_428 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _452);
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
                _799 = _613;
                _800 = _614;
                _801 = _615;
                if (g_fAgxHDRRatio > 1.0f) {
                  if (!(!(max(_613, max(_614, _615)) >= g_fAgxHDRMidGrey))) {
                    _626 = log2(1.0f / g_fAgxHDRMidGrey);
                    _627 = _626 + 20.0f;
                    _640 = min(max(log2(max(_613, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _626);
                    _641 = min(max(log2(max(_614, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _626);
                    _642 = min(max(log2(max(_615, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _626);
                    _649 = 20.0f / _627;
                    _652 = (20.0f - log2(g_fAgxHDRRatio)) / _627;
                    _657 = ((_640 / _627) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _672 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                    _675 = ((-0.0f - _640) / _627) * _672;
                    _694 = -0.0f - g_fAgxHDRToePrecalcConstant;
                    _700 = ((_641 / _627) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _717 = ((-0.0f - _641) / _627) * _672;
                    _741 = ((_642 / _627) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _758 = ((-0.0f - _642) / _627) * _672;
                    _799 = (saturate(exp2(((select((((_640 + 20.0f) / _627) >= _649), ((_657 / exp2(log2((float((int)(((int)(uint)((int)(_657 > 0.0f))) - ((int)(uint)((int)(_657 < 0.0f))))) * exp2(log2(abs(_657)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_675 / exp2(log2((float((int)(((int)(uint)((int)(_675 > 0.0f))) - ((int)(uint)((int)(_675 < 0.0f))))) * exp2(log2(abs(_675)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _694)) + _652) * _627) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _800 = (saturate(exp2(((select((((_641 + 20.0f) / _627) >= _649), ((_700 / exp2(log2((float((int)(((int)(uint)((int)(_700 > 0.0f))) - ((int)(uint)((int)(_700 < 0.0f))))) * exp2(log2(abs(_700)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_717 / exp2(log2((float((int)(((int)(uint)((int)(_717 > 0.0f))) - ((int)(uint)((int)(_717 < 0.0f))))) * exp2(log2(abs(_717)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _694)) + _652) * _627) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _801 = (saturate(exp2(((select((((_642 + 20.0f) / _627) >= _649), ((_741 / exp2(log2((float((int)(((int)(uint)((int)(_741 > 0.0f))) - ((int)(uint)((int)(_741 < 0.0f))))) * exp2(log2(abs(_741)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_758 / exp2(log2((float((int)(((int)(uint)((int)(_758 > 0.0f))) - ((int)(uint)((int)(_758 < 0.0f))))) * exp2(log2(abs(_758)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _694)) + _652) * _627) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                  } else {
                    _799 = _613;
                    _800 = _614;
                    _801 = _615;
                  }
                }
                _1176 = (mad(-0.07283977419137955f, _801, mad(-0.5876564383506775f, _800, (_799 * 1.6604962348937988f))) * _247);
                _1177 = (mad(-0.008348013274371624f, _801, mad(1.1328951120376587f, _800, (_799 * -0.1245470941066742f))) * _247);
                _1178 = (mad(1.118751049041748f, _801, mad(-0.10059737414121628f, _800, (_799 * -0.018153680488467216f))) * _247);
              } while (false);
#endif
              if (_loop_break_1 && !_loop_break_0) break;
            } else {
              if (_312) {
                _816 = max(_395, 0.0f);
                _817 = max(_396, 0.0f);
                _818 = max(_397, 0.0f);
                _819 = dot(float3(_816, _817, _818), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                do {
                  _829 = _816;
                  _830 = _817;
                  _831 = _818;
                  if (!(_819 == 0.0f)) {
                    _824 = max(dot(float3(_395, _396, _397), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _819;
                    _829 = (_824 * _816);
                    _830 = (_824 * _817);
                    _831 = (_824 * _818);
                  }
                  _837 = max(max(_829, max(_830, _831)), 0.0f);
                  _839 = 1.0f / max(_837, 1.1754943508222875e-38f);
                  _845 = (pow(_837, g_vTonemapGTParams.x));
                  _853 = _845 / (((pow(_845, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
                  _867 = exp2(log2(_839 * _829) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
                  _868 = exp2(log2(_839 * _830) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
                  _869 = exp2(log2(_839 * _831) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
                  _874 = log2(_853);
                  _902 = saturate(exp2(log2((exp2(_874 * g_vTonemapCrosstalk.x) * (1.0f - _867)) + _867) * g_vTonemapCrosstalkSaturation.x) * _853);
                  _903 = saturate(exp2(log2((exp2(_874 * g_vTonemapCrosstalk.y) * (1.0f - _868)) + _868) * g_vTonemapCrosstalkSaturation.y) * _853);
                  _904 = saturate(exp2(log2((exp2(_874 * g_vTonemapCrosstalk.z) * (1.0f - _869)) + _869) * g_vTonemapCrosstalkSaturation.z) * _853);
                  do {
                    _1015 = _902;
                    _1016 = _903;
                    _1017 = _904;
                    if (_239) {
                      do {
                        [branch]
                        if (!(_902 <= 0.0031308000907301903f)) {
                          _916 = (((pow(_902, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _916 = (_902 * 12.920000076293945f);
                        }
                        do {
                          [branch]
                          if (!(_903 <= 0.0031308000907301903f)) {
                            _927 = (((pow(_903, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          } else {
                            _927 = (_903 * 12.920000076293945f);
                          }
                          do {
                            [branch]
                            if (!(_904 <= 0.0031308000907301903f)) {
                              _938 = (((pow(_904, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            } else {
                              _938 = (_904 * 12.920000076293945f);
                            }
                            _945 = (saturate(_927) * 0.96875f) + 0.015625f;
                            _947 = max((saturate(_938) * 31.0f), 0.0f);
                            _948 = floor(_947);
                            _949 = _947 - _948;
                            _951 = (((saturate(_916) * 0.96875f) + 0.015625f) + _948) * 0.03125f;
                            _953 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_951, _945), 0.0f);
                            _957 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_951 + 0.03125f), _945), 0.0f);
                            _967 = ((_957.x - _953.x) * _949) + _953.x;
                            _968 = ((_957.y - _953.y) * _949) + _953.y;
                            _969 = ((_957.z - _953.z) * _949) + _953.z;
                            do {
                              [branch]
                              if (!(_967 <= 0.040449999272823334f)) {
                                _980 = exp2(log2((_967 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _980 = (_967 * 0.07739938050508499f);
                              }
                              do {
                                [branch]
                                if (!(_968 <= 0.040449999272823334f)) {
                                  _991 = exp2(log2((_968 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                } else {
                                  _991 = (_968 * 0.07739938050508499f);
                                }
                                do {
                                  [branch]
                                  if (!(_969 <= 0.040449999272823334f)) {
                                    _1002 = exp2(log2((_969 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                  } else {
                                    _1002 = (_969 * 0.07739938050508499f);
                                  }
                                  _1004 = dot(float3(_980, _991, _1002), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                                  _1015 = (lerp(_1004, _980, g_fTonemapSaturation));
                                  _1016 = (lerp(_1004, _991, g_fTonemapSaturation));
                                  _1017 = (lerp(_1004, _1002, g_fTonemapSaturation));
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
                    _1176 = (_1015 * _247);
                    _1177 = (_1016 * _247);
                    _1178 = (_1017 * _247);
                  } while (false);
                  if (_loop_break_1 && !_loop_break_0) break;
                } while (false);
                if (_loop_break_1 && !_loop_break_0) break;
              } else {
                _1026 = g_fMaxOutputNits * 0.012500000186264515f;
                _1031 = max(abs(_395), max(abs(_396), abs(_397)));
                _1033 = 1.0f / max(_1031, 1.1754943508222875e-38f);
                _1034 = _1033 * _395;
                _1035 = _1033 * _396;
                _1036 = _1033 * _397;
                _1046 = (_247 * 0.18000000715255737f) * exp2(log2((pow(_1031, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
                _1050 = dot(float3((_1046 * _1034), (_1046 * _1035), (_1046 * _1036)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                _1099 = exp2(log2(abs(_1034)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_1034 > 0.0f))) - ((int)(uint)((int)(_1034 < 0.0f)))));
                _1100 = exp2(log2(abs(_1035)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_1035 > 0.0f))) - ((int)(uint)((int)(_1035 < 0.0f)))));
                _1101 = exp2(log2(abs(_1036)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_1036 > 0.0f))) - ((int)(uint)((int)(_1036 < 0.0f)))));
                _1106 = log2(saturate(select((_1050 <= 0.0f), _1050, ((1.0f - exp2(log2(exp2((_1050 / _1026) * -1.4426950216293335f)))) * _1026)) / _1026));
                _1119 = (exp2(_1106 * g_vTonemapCrosstalk.x) * (1.0f - _1099)) + _1099;
                _1120 = (exp2(_1106 * g_vTonemapCrosstalk.y) * (1.0f - _1100)) + _1100;
                _1121 = (exp2(_1106 * g_vTonemapCrosstalk.z) * (1.0f - _1101)) + _1101;
                _1153 = (float((int)(((int)(uint)((int)(_1119 > 0.0f))) - ((int)(uint)((int)(_1119 < 0.0f))))) * _1046) * exp2(log2(abs(_1119)) * g_vTonemapCrosstalkSaturation.x);
                _1155 = (float((int)(((int)(uint)((int)(_1120 > 0.0f))) - ((int)(uint)((int)(_1120 < 0.0f))))) * _1046) * exp2(log2(abs(_1120)) * g_vTonemapCrosstalkSaturation.y);
                _1157 = (float((int)(((int)(uint)((int)(_1121 > 0.0f))) - ((int)(uint)((int)(_1121 < 0.0f))))) * _1046) * exp2(log2(abs(_1121)) * g_vTonemapCrosstalkSaturation.z);
                _1158 = dot(float3(_1153, _1155, _1157), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                _1171 = select((_1158 <= 0.0f), _1158, ((1.0f - exp2(log2(exp2((_1158 / _1026) * -1.4426950216293335f)))) * _1026)) * select((!(_1158 == 0.0f)), (1.0f / _1158), 0.0f);
                _1176 = (_1171 * _1153);
                _1177 = (_1171 * _1155);
                _1178 = (_1171 * _1157);
              }
            }
          }
          _1187 = (_1176 * g_fTonemapBrightness);
          _1188 = (_1177 * g_fTonemapBrightness);
          _1189 = (_1178 * g_fTonemapBrightness);
        } while (false);
        if (_loop_break_1 && !_loop_break_0) { _loop_break_1 = false; continue; }
      } else {
        _1187 = (_395 * _247);
        _1188 = (_396 * _247);
        _1189 = (_397 * _247);
      }
      if (!(g_bApplyFilmGrain == 0)) {
        _1201 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
        _1211 = _1187 / _247;
        _1212 = _1188 / _247;
        _1213 = _1189 / _247;
        _1217 = 1.0f - sqrt(max(dot(float3(_1211, _1212, _1213), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
        _1223 = g_fFilmGrainIntensity * (_247 * 5.0f);
        _1237 = ((((_1223 * ((_1201.x * 2.0f) + -1.0f)) * saturate(_1211)) * _1217) + _1187);
        _1238 = ((((_1223 * ((_1201.y * 2.0f) + -1.0f)) * _1217) * saturate(_1212)) + _1188);
        _1239 = ((((_1223 * ((_1201.z * 2.0f) + -1.0f)) * _1217) * saturate(_1213)) + _1189);
      } else {
        _1237 = _1187;
        _1238 = _1188;
        _1239 = _1189;
      }
      if (!(_174)) {
        _1243 = (uint)(int(SV_Position.x)) + (uint)(-96);
        _1244 = (uint)(int(SV_Position.y)) + (uint)(-48);
        uint2 _1245; g_tBaseColorCorrectionMap.GetDimensions(_1245.x, _1245.y);
        if (((int)_1244 < (int)int(float((int)((int)(_1245.y))))) && (((int)(_1244 | _1243) > (int)-1) && ((int)_1243 < (int)int(float((int)((int)(_1245.x))))))) {
          _1259 = g_tBaseColorCorrectionMap.Load(int3(_1243, _1244, 0));
          if (_312) {
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
              if (_loop_break_1 && !_loop_break_0) break;
            } while (false);
            if (_loop_break_1 && !_loop_break_0) { _loop_break_1 = false; continue; }
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
        _1304 = mad(0.043306104838848114f, _1298, mad(0.329291969537735f, _1297, (_1296 * 0.6274019479751587f)));
        _1307 = mad(0.0113602289929986f, _1298, mad(0.9195442795753479f, _1297, (_1296 * 0.06909549236297607f)));
        _1310 = mad(0.895578145980835f, _1298, mad(0.08802816271781921f, _1297, (_1296 * 0.016393709927797318f)));
        _1314 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
        do {
          _1327 = true;
          if (!(((_1304 < 0.0f) || (_1307 < 0.0f)) || (_1310 < 0.0f))) {
            _1327 = ((_1310 > _1314) || ((_1304 > _1314) || (_1307 > _1314)));
          }
          if (_1327) {
            _1333 = float((int)(int(g_fRealTime * 15.0f)));
            _1343 = select((((((int)((uint)(int(SV_Position.y - _1333)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1333)) / 5u))) & 1) == 0), 1.0f, 0.0f);
            _1348 = (_1343 * _1296);
            _1349 = (_1343 * _1297);
            _1350 = (_1343 * _1298);
          } else {
            _1348 = _1296;
            _1349 = _1297;
            _1350 = _1298;
          }
        } while (false);
        if (_loop_break_1 && !_loop_break_0) { _loop_break_1 = false; continue; }
      } else {
        _1348 = _1296;
        _1349 = _1297;
        _1350 = _1298;
      }
      if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
        _1356 = (g_bHDR == 0);
        do {
          _1383 = _1348;
          _1384 = _1349;
          _1385 = _1350;
          if (!(_1356 || (g_bHDR_scRGB == 0))) {
            _1370 = max(mad(0.043306104838848114f, _1350, mad(0.329291969537735f, _1349, (_1348 * 0.6274019479751587f))), 0.0f);
            _1371 = max(mad(0.0113602289929986f, _1350, mad(0.9195442795753479f, _1349, (_1348 * 0.06909549236297607f))), 0.0f);
            _1372 = max(mad(0.895578145980835f, _1350, mad(0.08802816271781921f, _1349, (_1348 * 0.016393709927797318f))), 0.0f);
            _1383 = mad(-0.07283977419137955f, _1372, mad(-0.5876564383506775f, _1371, (_1370 * 1.6604962348937988f)));
            _1384 = mad(-0.008348013274371624f, _1372, mad(1.1328951120376587f, _1371, (_1370 * -0.1245470941066742f)));
            _1385 = mad(1.118751049041748f, _1372, mad(-0.10059737414121628f, _1371, (_1370 * -0.018153680488467216f)));
          }
          if ((g_bHDR_scRGB == 0) && (!_1356)) {
            _1401 = mad(0.043306104838848114f, _1385, mad(0.329291969537735f, _1384, (_1383 * 0.6274019479751587f)));
            _1402 = mad(0.0113602289929986f, _1385, mad(0.9195442795753479f, _1384, (_1383 * 0.06909549236297607f)));
            _1403 = mad(0.895578145980835f, _1385, mad(0.08802816271781921f, _1384, (_1383 * 0.016393709927797318f)));
          } else {
            _1401 = _1383;
            _1402 = _1384;
            _1403 = _1385;
          }
        } while (false);
        if (_loop_break_1 && !_loop_break_0) { _loop_break_1 = false; continue; }
      } else {
        _1401 = _1348;
        _1402 = _1349;
        _1403 = _1350;
      }
      SV_Target.x = _1401;
      SV_Target.y = _1402;
      SV_Target.z = _1403;
      SV_Target.w = 1.0f;
      break;
    }
    if (_loop_break_0) { _loop_break_0 = false; continue; }
    break;
  }
  return SV_Target;
}