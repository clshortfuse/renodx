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
  float _529;
  float _530;
  float _531;
  float _867;
  float _868;
  float _869;
  float _897;
  float _898;
  float _899;
  float _984;
  float _995;
  float _1006;
  float _1048;
  float _1059;
  float _1070;
  float _1083;
  float _1084;
  float _1085;
  float _1244;
  float _1245;
  float _1246;
  float _1255;
  float _1256;
  float _1257;
  float _1305;
  float _1306;
  float _1307;
  float _1364;
  float _1375;
  float _1386;
  float _1387;
  float _1388;
  bool _1417;
  float _1438;
  float _1439;
  float _1440;
  float _1473;
  float _1474;
  float _1475;
  float _1491;
  float _1492;
  float _1493;
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
  float _359;
  float _360;
  int _364;
  int _365;
  int _366;
  float _370;
  float _371;
  float _372;
  int _377;
  int _382;
  int _387;
  bool _388;
  bool _389;
  bool _390;
  float4 _408;
  float4 _423;
  float4 _438;
  float4 _453;
  float _460;
  float _467;
  float _471;
  float _472;
  float _476;
  float _480;
  float _489;
  float _492;
  float _495;
  float _497;
  float _499;
  float _501;
  float _505;
  float _506;
  float _507;
  float _510;
  float _513;
  float _516;
  float _518;
  float _562;
  float _563;
  float _564;
  float _586;
  float _590;
  float _591;
  float _592;
  float _601;
  float _602;
  float _619;
  float _621;
  float _622;
  float _641;
  float _644;
  float _647;
  float _665;
  float _686;
  float _689;
  float _707;
  float _728;
  float _747;
  float _748;
  float _749;
  float _760;
  float _761;
  float _762;
  float _781;
  float _782;
  float _783;
  float _784;
  float _788;
  float _793;
  float _810;
  float _832;
  float _838;
  float _884;
  float _885;
  float _886;
  float _887;
  float _892;
  float _905;
  float _907;
  float _913;
  float _921;
  float _935;
  float _936;
  float _937;
  float _942;
  float _970;
  float _971;
  float _972;
  float _1013;
  float _1015;
  float _1016;
  float _1017;
  float _1019;
  float4 _1021;
  float4 _1025;
  float _1035;
  float _1036;
  float _1037;
  float _1072;
  float _1094;
  float _1099;
  float _1101;
  float _1102;
  float _1103;
  float _1104;
  float _1114;
  float _1118;
  float _1167;
  float _1168;
  float _1169;
  float _1174;
  float _1187;
  float _1188;
  float _1189;
  float _1221;
  float _1223;
  float _1225;
  float _1226;
  float _1239;
  float4 _1269;
  float _1279;
  float _1280;
  float _1281;
  float _1285;
  float _1291;
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
  float _1394;
  float _1397;
  float _1400;
  float _1404;
  float _1423;
  float _1433;
  bool _1446;
  float _1460;
  float _1461;
  float _1462;
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
  while (true) {
    _88 = _82;
    _89 = _83;
    _90 = _84;
    _91 = _85;
    _92 = -1;
    bool _loop_break_1 = false;
    while (true) {
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
        _247 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
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
        _328 = exp2(log2(saturate(_307 * 0.00800000037997961f)) * 0.1593017578125f);
        _329 = exp2(log2(saturate(_308 * 0.00800000037997961f)) * 0.1593017578125f);
        _330 = exp2(log2(saturate(_309 * 0.00800000037997961f)) * 0.1593017578125f);
        _358 = saturate(exp2(log2(((_328 * 18.8515625f) + 0.8359375f) / ((_328 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
        _359 = saturate(exp2(log2(((_329 * 18.8515625f) + 0.8359375f) / ((_329 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
        _360 = saturate(exp2(log2(((_330 * 18.8515625f) + 0.8359375f) / ((_330 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
        _364 = int(floor(_358));
        _365 = int(floor(_359));
        _366 = int(floor(_360));
        _370 = _358 - float((int)(_364));
        _371 = _359 - float((int)(_365));
        _372 = _360 - float((int)(_366));
        _377 = ((int)(uint)((int)(_372 > _370))) + ((int)(uint)((int)(_371 > _370)));
        _382 = ((int)(uint)((int)(_372 > _371))) + ((int)(uint)((int)(_370 >= _371)));
        _387 = ((int)(uint)((int)(_370 >= _372))) + ((int)(uint)((int)(_371 >= _372)));
        _388 = (_377 == 0);
        _389 = (_382 == 0);
        _390 = (_387 == 0);
        _408 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_366), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_364), (int)(0))), (int)(47))), min((int)(max((int)(_365), (int)(0))), (int)(47)), 0));
        _423 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_390))) + _366))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_388))) + _364))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_389))) + _365))), (int)(0))), (int)(47)), 0));
        _438 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_387 < (uint)2)))) + _366))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_377 < (uint)2)))) + _364))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_382 < (uint)2)))) + _365))), (int)(0))), (int)(47)), 0));
        _453 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_366 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_364 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_365 + 1u))), (int)(0))), (int)(47)), 0));
        _460 = dot(float3(_370, _371, _372), float3(((float)((bool)_388)), ((float)((bool)_389)), ((float)((bool)_390))));
        _467 = dot(float3(_370, _371, _372), float3(((float)((bool)(uint)(_377 == 2))), ((float)((bool)(uint)(_382 == 2))), ((float)((bool)(uint)(_387 == 2)))));
        _471 = (((_371 + _370) + _372) - _460) - _467;
        _472 = 1.0f - _460;
        _476 = _460 - _471;
        _480 = _471 - _467;
        _489 = (((_467 * _453.x) + (_472 * _408.x)) + (_476 * _423.x)) + (_480 * _438.x);
        _492 = (((_467 * _453.y) + (_472 * _408.y)) + (_476 * _423.y)) + (_480 * _438.y);
        _495 = (((_467 * _453.z) + (_472 * _408.z)) + (_476 * _423.z)) + (_480 * _438.z);
        _497 = mad(0.21580375730991364f, _495, mad(0.3963377773761749f, _492, _489));
        _499 = mad(-0.0638541728258133f, _495, mad(-0.10556134581565857f, _492, _489));
        _501 = mad(-1.2914855480194092f, _495, mad(-0.08948417752981186f, _492, _489));
        _505 = (_497 * _497) * _497;
        _506 = (_499 * _499) * _499;
        _507 = (_501 * _501) * _501;
        _510 = mad(0.23096993565559387f, _507, mad(-3.307711601257324f, _506, (_505 * 4.076741695404053f)));
        _513 = mad(-0.34131938219070435f, _507, mad(2.609757423400879f, _506, (_505 * -1.2684379816055298f)));
        _516 = mad(1.7076146602630615f, _507, mad(-0.7034186124801636f, _506, (_505 * -0.004196086432784796f)));
        _518 = dot(float3(_510, _513, _516), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _529 = (lerp(_518, _510, g_fTonemapSaturation));
        _530 = (lerp(_518, _513, g_fTonemapSaturation));
        _531 = (lerp(_518, _516, g_fTonemapSaturation));
      } else {
        _529 = _307;
        _530 = _308;
        _531 = _309;
      }
      if (!(_237)) {
        do {
          _1244 = _529;
          _1245 = _530;
          _1246 = _531;
          if (!(g_iTonemapper == 0)) {
            if (g_iTonemapper == 2) {
#if 1
              float3 agx_color = ApplyRemedyAgX(
                  _529, _530, _531, _247,
                  g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
                  g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
                  g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
                  g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
                  g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
                  g_fAgxHDRRatio, g_fAgxHDRMidGrey,
                  g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
                  SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
              _1244 = agx_color.x;
              _1245 = agx_color.y;
              _1246 = agx_color.z;
#else
              _562 = max(_529, 0.0f);
              _563 = max(_530, 0.0f);
              _564 = max(_531, 0.0f);
              _586 = g_fAgxMaxEV - g_fAgxMinEV;
              _590 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _564, mad(g_vAgxInsetRow0.y, _563, (_562 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _586);
              _591 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _564, mad(g_vAgxInsetRow1.y, _563, (_562 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _586);
              _592 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _564, mad(g_vAgxInsetRow2.y, _563, (_562 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _586);
              _601 = (g_fAgxContrastSlope * (_590 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _602 = 1.0f / g_fAgxShoulderPower;
              _619 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
              _621 = _619 * (0.6060606241226196f - _590);
              _622 = 1.0f / g_fAgxToePower;
              _641 = -0.0f - g_fAgxToePrecalcConstant;
              _644 = select((_590 >= 0.6060606241226196f), ((_601 / exp2(log2((float((int)(((int)(uint)((int)(_601 > 0.0f))) - ((int)(uint)((int)(_601 < 0.0f))))) * exp2(log2(abs(_601)) * g_fAgxShoulderPower)) + 1.0f) * _602)) * g_fAgxShoulderPrecalcConstant), ((_621 / exp2(log2((float((int)(((int)(uint)((int)(_621 > 0.0f))) - ((int)(uint)((int)(_621 < 0.0f))))) * exp2(log2(abs(_621)) * g_fAgxToePower)) + 1.0f) * _622)) * _641)) + 0.4894371032714844f;
              _647 = (g_fAgxContrastSlope * (_591 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _665 = _619 * (0.6060606241226196f - _591);
              _686 = select((_591 >= 0.6060606241226196f), ((_647 / exp2(log2((float((int)(((int)(uint)((int)(_647 > 0.0f))) - ((int)(uint)((int)(_647 < 0.0f))))) * exp2(log2(abs(_647)) * g_fAgxShoulderPower)) + 1.0f) * _602)) * g_fAgxShoulderPrecalcConstant), ((_665 / exp2(log2((exp2(log2(abs(_665)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_665 > 0.0f))) - ((int)(uint)((int)(_665 < 0.0f)))))) + 1.0f) * _622)) * _641)) + 0.4894371032714844f;
              _689 = (g_fAgxContrastSlope * (_592 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _707 = _619 * (0.6060606241226196f - _592);
              _728 = select((_592 >= 0.6060606241226196f), ((_689 / exp2(log2((float((int)(((int)(uint)((int)(_689 > 0.0f))) - ((int)(uint)((int)(_689 < 0.0f))))) * exp2(log2(abs(_689)) * g_fAgxShoulderPower)) + 1.0f) * _602)) * g_fAgxShoulderPrecalcConstant), ((_707 / exp2(log2((exp2(log2(abs(_707)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_707 > 0.0f))) - ((int)(uint)((int)(_707 < 0.0f)))))) + 1.0f) * _622)) * _641)) + 0.4894371032714844f;
              _747 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _728, mad(g_vAgxOutsetRow0.y, _686, (_644 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
              _748 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _728, mad(g_vAgxOutsetRow1.y, _686, (_644 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
              _749 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _728, mad(g_vAgxOutsetRow2.y, _686, (_644 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
              do {
                _867 = _747;
                _868 = _748;
                _869 = _749;
                if (g_fAgxHDRRatio > 1.0f) {
                  if (!(!(max(_747, max(_748, _749)) >= g_fAgxHDRMidGrey))) {
                    _760 = log2(1.0f / g_fAgxHDRMidGrey);
                    _761 = _760 + 20.0f;
                    _762 = log2(g_fAgxHDRRatio);
                    _781 = (min(max(log2(max(_747, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _760) + 20.0f) / _761;
                    _782 = (min(max(log2(max(_748, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _760) + 20.0f) / _761;
                    _783 = (min(max(log2(max(_749, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _760) + 20.0f) / _761;
                    _784 = 20.0f / _761;
                    _788 = max(_781, max(_782, _783));
                    _793 = ((_788 - _784) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _810 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_784 - _788);
                    _832 = select((_788 >= _784), ((_793 / exp2(log2((float((int)(((int)(uint)((int)(_793 > 0.0f))) - ((int)(uint)((int)(_793 < 0.0f))))) * exp2(log2(abs(_793)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_810 / exp2(log2((float((int)(((int)(uint)((int)(_810 > 0.0f))) - ((int)(uint)((int)(_810 < 0.0f))))) * exp2(log2(abs(_810)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _762) / _761);
                    _838 = exp2((((_832 - _788) * _761) + _762) * g_fAgxHDRSaturation);
                    _867 = (saturate(exp2(((_832 + (_838 * (_781 - _788))) * _761) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _868 = (saturate(exp2(((_832 + (_838 * (_782 - _788))) * _761) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _869 = (saturate(exp2(((_832 + (_838 * (_783 - _788))) * _761) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                  } else {
                    _867 = _747;
                    _868 = _748;
                    _869 = _749;
                  }
                }
                _1244 = (mad(-0.07283977419137955f, _869, mad(-0.5876564383506775f, _868, (_867 * 1.6604962348937988f))) * _247);
                _1245 = (mad(-0.008348013274371624f, _869, mad(1.1328951120376587f, _868, (_867 * -0.1245470941066742f))) * _247);
                _1246 = (mad(1.118751049041748f, _869, mad(-0.10059737414121628f, _868, (_867 * -0.018153680488467216f))) * _247);
              } while (false);
#endif
              if (_loop_break_1 && !_loop_break_0) break;
            } else {
              if (_312) {
                _884 = max(_529, 0.0f);
                _885 = max(_530, 0.0f);
                _886 = max(_531, 0.0f);
                _887 = dot(float3(_884, _885, _886), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                do {
                  _897 = _884;
                  _898 = _885;
                  _899 = _886;
                  if (!(_887 == 0.0f)) {
                    _892 = max(dot(float3(_529, _530, _531), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _887;
                    _897 = (_892 * _884);
                    _898 = (_892 * _885);
                    _899 = (_892 * _886);
                  }
                  _905 = max(max(_897, max(_898, _899)), 0.0f);
                  _907 = 1.0f / max(_905, 1.1754943508222875e-38f);
                  _913 = (pow(_905, g_vTonemapGTParams.x));
                  _921 = _913 / (((pow(_913, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
                  _935 = exp2(log2(_907 * _897) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
                  _936 = exp2(log2(_907 * _898) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
                  _937 = exp2(log2(_907 * _899) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
                  _942 = log2(_921);
                  _970 = saturate(exp2(log2((exp2(_942 * g_vTonemapCrosstalk.x) * (1.0f - _935)) + _935) * g_vTonemapCrosstalkSaturation.x) * _921);
                  _971 = saturate(exp2(log2((exp2(_942 * g_vTonemapCrosstalk.y) * (1.0f - _936)) + _936) * g_vTonemapCrosstalkSaturation.y) * _921);
                  _972 = saturate(exp2(log2((exp2(_942 * g_vTonemapCrosstalk.z) * (1.0f - _937)) + _937) * g_vTonemapCrosstalkSaturation.z) * _921);
                  do {
                    _1083 = _970;
                    _1084 = _971;
                    _1085 = _972;
                    if (_239) {
                      do {
                        [branch]
                        if (!(_970 <= 0.0031308000907301903f)) {
                          _984 = (((pow(_970, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _984 = (_970 * 12.920000076293945f);
                        }
                        do {
                          [branch]
                          if (!(_971 <= 0.0031308000907301903f)) {
                            _995 = (((pow(_971, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          } else {
                            _995 = (_971 * 12.920000076293945f);
                          }
                          do {
                            [branch]
                            if (!(_972 <= 0.0031308000907301903f)) {
                              _1006 = (((pow(_972, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            } else {
                              _1006 = (_972 * 12.920000076293945f);
                            }
                            _1013 = (saturate(_995) * 0.96875f) + 0.015625f;
                            _1015 = max((saturate(_1006) * 31.0f), 0.0f);
                            _1016 = floor(_1015);
                            _1017 = _1015 - _1016;
                            _1019 = (((saturate(_984) * 0.96875f) + 0.015625f) + _1016) * 0.03125f;
                            _1021 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_1019, _1013), 0.0f);
                            _1025 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_1019 + 0.03125f), _1013), 0.0f);
                            _1035 = ((_1025.x - _1021.x) * _1017) + _1021.x;
                            _1036 = ((_1025.y - _1021.y) * _1017) + _1021.y;
                            _1037 = ((_1025.z - _1021.z) * _1017) + _1021.z;
                            do {
                              [branch]
                              if (!(_1035 <= 0.040449999272823334f)) {
                                _1048 = exp2(log2((_1035 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _1048 = (_1035 * 0.07739938050508499f);
                              }
                              do {
                                [branch]
                                if (!(_1036 <= 0.040449999272823334f)) {
                                  _1059 = exp2(log2((_1036 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                } else {
                                  _1059 = (_1036 * 0.07739938050508499f);
                                }
                                do {
                                  [branch]
                                  if (!(_1037 <= 0.040449999272823334f)) {
                                    _1070 = exp2(log2((_1037 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                  } else {
                                    _1070 = (_1037 * 0.07739938050508499f);
                                  }
                                  _1072 = dot(float3(_1048, _1059, _1070), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                                  _1083 = (lerp(_1072, _1048, g_fTonemapSaturation));
                                  _1084 = (lerp(_1072, _1059, g_fTonemapSaturation));
                                  _1085 = (lerp(_1072, _1070, g_fTonemapSaturation));
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
                    _1244 = (_1083 * _247);
                    _1245 = (_1084 * _247);
                    _1246 = (_1085 * _247);
                  } while (false);
                  if (_loop_break_1 && !_loop_break_0) break;
                } while (false);
                if (_loop_break_1 && !_loop_break_0) break;
              } else {
                _1094 = g_fMaxOutputNits * 0.012500000186264515f;
                _1099 = max(abs(_529), max(abs(_530), abs(_531)));
                _1101 = 1.0f / max(_1099, 1.1754943508222875e-38f);
                _1102 = _1101 * _529;
                _1103 = _1101 * _530;
                _1104 = _1101 * _531;
                _1114 = (_247 * 0.18000000715255737f) * exp2(log2((pow(_1099, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
                _1118 = dot(float3((_1114 * _1102), (_1114 * _1103), (_1114 * _1104)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                _1167 = exp2(log2(abs(_1102)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_1102 > 0.0f))) - ((int)(uint)((int)(_1102 < 0.0f)))));
                _1168 = exp2(log2(abs(_1103)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_1103 > 0.0f))) - ((int)(uint)((int)(_1103 < 0.0f)))));
                _1169 = exp2(log2(abs(_1104)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_1104 > 0.0f))) - ((int)(uint)((int)(_1104 < 0.0f)))));
                _1174 = log2(saturate(select((_1118 <= 0.0f), _1118, ((1.0f - exp2(log2(exp2((_1118 / _1094) * -1.4426950216293335f)))) * _1094)) / _1094));
                _1187 = (exp2(_1174 * g_vTonemapCrosstalk.x) * (1.0f - _1167)) + _1167;
                _1188 = (exp2(_1174 * g_vTonemapCrosstalk.y) * (1.0f - _1168)) + _1168;
                _1189 = (exp2(_1174 * g_vTonemapCrosstalk.z) * (1.0f - _1169)) + _1169;
                _1221 = (float((int)(((int)(uint)((int)(_1187 > 0.0f))) - ((int)(uint)((int)(_1187 < 0.0f))))) * _1114) * exp2(log2(abs(_1187)) * g_vTonemapCrosstalkSaturation.x);
                _1223 = (float((int)(((int)(uint)((int)(_1188 > 0.0f))) - ((int)(uint)((int)(_1188 < 0.0f))))) * _1114) * exp2(log2(abs(_1188)) * g_vTonemapCrosstalkSaturation.y);
                _1225 = (float((int)(((int)(uint)((int)(_1189 > 0.0f))) - ((int)(uint)((int)(_1189 < 0.0f))))) * _1114) * exp2(log2(abs(_1189)) * g_vTonemapCrosstalkSaturation.z);
                _1226 = dot(float3(_1221, _1223, _1225), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                _1239 = select((_1226 <= 0.0f), _1226, ((1.0f - exp2(log2(exp2((_1226 / _1094) * -1.4426950216293335f)))) * _1094)) * select((!(_1226 == 0.0f)), (1.0f / _1226), 0.0f);
                _1244 = (_1239 * _1221);
                _1245 = (_1239 * _1223);
                _1246 = (_1239 * _1225);
              }
            }
          }
          _1255 = (_1244 * g_fTonemapBrightness);
          _1256 = (_1245 * g_fTonemapBrightness);
          _1257 = (_1246 * g_fTonemapBrightness);
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _1255 = (_529 * _247);
        _1256 = (_530 * _247);
        _1257 = (_531 * _247);
      }
      if (!(g_bApplyFilmGrain == 0)) {
        _1269 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
        _1279 = _1255 / _247;
        _1280 = _1256 / _247;
        _1281 = _1257 / _247;
        _1285 = 1.0f - sqrt(max(dot(float3(_1279, _1280, _1281), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
        _1291 = g_fFilmGrainIntensity * (_247 * 5.0f);
        _1305 = ((((_1291 * ((_1269.x * 2.0f) + -1.0f)) * saturate(_1279)) * _1285) + _1255);
        _1306 = ((((_1291 * ((_1269.y * 2.0f) + -1.0f)) * _1285) * saturate(_1280)) + _1256);
        _1307 = ((((_1291 * ((_1269.z * 2.0f) + -1.0f)) * _1285) * saturate(_1281)) + _1257);
      } else {
        _1305 = _1255;
        _1306 = _1256;
        _1307 = _1257;
      }
      if (!(_174)) {
        _1311 = (uint)(int(SV_Position.x)) + (uint)(-96);
        _1312 = (uint)(int(SV_Position.y)) + (uint)(-48);
        uint2 _1313;
        g_tBaseColorCorrectionMap.GetDimensions(_1313.x, _1313.y);
        if (((int)_1312 < (int)int(float((int)((int)(_1313.y))))) && (((int)(_1312 | _1311) > (int)-1) && ((int)_1311 < (int)int(float((int)((int)(_1313.x))))))) {
          _1327 = g_tBaseColorCorrectionMap.Load(int3(_1311, _1312, 0));
          if (!(_312)) {
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
              if (_loop_break_1 && !_loop_break_0) break;
            } while (false);
            if (_loop_break_1 && !_loop_break_0) {
              _loop_break_1 = false;
              continue;
            }
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
        _1394 = mad(0.043306104838848114f, _1388, mad(0.329291969537735f, _1387, (_1386 * 0.6274019479751587f)));
        _1397 = mad(0.0113602289929986f, _1388, mad(0.9195442795753479f, _1387, (_1386 * 0.06909549236297607f)));
        _1400 = mad(0.895578145980835f, _1388, mad(0.08802816271781921f, _1387, (_1386 * 0.016393709927797318f)));
        _1404 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
        do {
          _1417 = true;
          if (!(((_1394 < 0.0f) || (_1397 < 0.0f)) || (_1400 < 0.0f))) {
            _1417 = ((_1400 > _1404) || ((_1394 > _1404) || (_1397 > _1404)));
          }
          if (_1417) {
            _1423 = float((int)(int(g_fRealTime * 15.0f)));
            _1433 = select((((((int)((uint)(int(SV_Position.y - _1423)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1423)) / 5u))) & 1) == 0), 1.0f, 0.0f);
            _1438 = (_1433 * _1386);
            _1439 = (_1433 * _1387);
            _1440 = (_1433 * _1388);
          } else {
            _1438 = _1386;
            _1439 = _1387;
            _1440 = _1388;
          }
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _1438 = _1386;
        _1439 = _1387;
        _1440 = _1388;
      }
      if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
        _1446 = (g_bHDR == 0);
        do {
          _1473 = _1438;
          _1474 = _1439;
          _1475 = _1440;
          if (!(_1446 || (g_bHDR_scRGB == 0))) {
            _1460 = max(mad(0.043306104838848114f, _1440, mad(0.329291969537735f, _1439, (_1438 * 0.6274019479751587f))), 0.0f);
            _1461 = max(mad(0.0113602289929986f, _1440, mad(0.9195442795753479f, _1439, (_1438 * 0.06909549236297607f))), 0.0f);
            _1462 = max(mad(0.895578145980835f, _1440, mad(0.08802816271781921f, _1439, (_1438 * 0.016393709927797318f))), 0.0f);
            _1473 = mad(-0.07283977419137955f, _1462, mad(-0.5876564383506775f, _1461, (_1460 * 1.6604962348937988f)));
            _1474 = mad(-0.008348013274371624f, _1462, mad(1.1328951120376587f, _1461, (_1460 * -0.1245470941066742f)));
            _1475 = mad(1.118751049041748f, _1462, mad(-0.10059737414121628f, _1461, (_1460 * -0.018153680488467216f)));
          }
          if ((g_bHDR_scRGB == 0) && (!_1446)) {
            _1491 = mad(0.043306104838848114f, _1475, mad(0.329291969537735f, _1474, (_1473 * 0.6274019479751587f)));
            _1492 = mad(0.0113602289929986f, _1475, mad(0.9195442795753479f, _1474, (_1473 * 0.06909549236297607f)));
            _1493 = mad(0.895578145980835f, _1475, mad(0.08802816271781921f, _1474, (_1473 * 0.016393709927797318f)));
          } else {
            _1491 = _1473;
            _1492 = _1474;
            _1493 = _1475;
          }
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _1491 = _1438;
        _1492 = _1439;
        _1493 = _1440;
      }
      SV_Target.x = _1491;
      SV_Target.y = _1492;
      SV_Target.z = _1493;
      SV_Target.w = 1.0f;
      break;
    }
    if (_loop_break_0) {
      _loop_break_0 = false;
      continue;
    }
    break;
  }
  return SV_Target;
}
