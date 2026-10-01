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
  float _248;
  float _268;
  float _269;
  float _270;
  float _308;
  float _309;
  float _310;
  float _530;
  float _531;
  float _532;
  float _868;
  float _869;
  float _870;
  float _894;
  float _895;
  float _896;
  float _982;
  float _993;
  float _1004;
  float _1046;
  float _1057;
  float _1068;
  float _1081;
  float _1082;
  float _1083;
  float _1088;
  float _1089;
  float _1090;
  float _1099;
  float _1100;
  float _1101;
  float _1199;
  float _1200;
  float _1201;
  float _1258;
  float _1269;
  float _1280;
  float _1281;
  float _1282;
  bool _1302;
  float _1323;
  float _1324;
  float _1325;
  float _1358;
  float _1359;
  float _1360;
  float _1376;
  float _1377;
  float _1378;
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
  float _360;
  float _361;
  int _365;
  int _366;
  int _367;
  float _371;
  float _372;
  float _373;
  int _378;
  int _383;
  int _388;
  bool _389;
  bool _390;
  bool _391;
  float4 _409;
  float4 _424;
  float4 _439;
  float4 _454;
  float _461;
  float _468;
  float _472;
  float _473;
  float _477;
  float _481;
  float _490;
  float _493;
  float _496;
  float _498;
  float _500;
  float _502;
  float _506;
  float _507;
  float _508;
  float _511;
  float _514;
  float _517;
  float _519;
  float _538;
  float _539;
  float _540;
  float _587;
  float _591;
  float _592;
  float _593;
  float _602;
  float _603;
  float _620;
  float _622;
  float _623;
  float _642;
  float _645;
  float _648;
  float _666;
  float _687;
  float _690;
  float _708;
  float _729;
  float _748;
  float _749;
  float _750;
  float _761;
  float _762;
  float _763;
  float _782;
  float _783;
  float _784;
  float _785;
  float _789;
  float _794;
  float _811;
  float _833;
  float _839;
  float _884;
  float _889;
  float _902;
  float _904;
  float _910;
  float _918;
  float _932;
  float _933;
  float _934;
  float _939;
  float _967;
  float _968;
  float _969;
  float _1011;
  float _1013;
  float _1014;
  float _1015;
  float _1017;
  float4 _1019;
  float4 _1023;
  float _1033;
  float _1034;
  float _1035;
  float _1070;
  float4 _1113;
  float _1120;
  float _1121;
  float _1122;
  float _1125;
  float _1126;
  float _1127;
  float _1131;
  float _1136;
  float _1150;
  float _1151;
  float _1152;
  float _1157;
  float _1158;
  float _1159;
  float _1160;
  float _1168;
  float _1175;
  float _1176;
  float _1177;
  float _1181;
  float _1188;
  uint _1205;
  uint _1206;
  uint2 _1207;
  float4 _1221;
  float _1227;
  float _1229;
  float _1231;
  float _1235;
  float _1236;
  float _1237;
  float _1289;
  float _1308;
  float _1318;
  bool _1331;
  float _1345;
  float _1346;
  float _1347;
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
      _237 = (g_bPostProcessApplyTonemap != 0);
      _239 = (g_bPostProcessApplyColorGrade != 0);
      if (!(g_bPostProcessApplyTonemap == 0)) {
        _248 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
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
        _329 = exp2(log2(saturate(_308 * 0.00800000037997961f)) * 0.1593017578125f);
        _330 = exp2(log2(saturate(_309 * 0.00800000037997961f)) * 0.1593017578125f);
        _331 = exp2(log2(saturate(_310 * 0.00800000037997961f)) * 0.1593017578125f);
        _359 = saturate(exp2(log2(((_329 * 18.8515625f) + 0.8359375f) / ((_329 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
        _360 = saturate(exp2(log2(((_330 * 18.8515625f) + 0.8359375f) / ((_330 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
        _361 = saturate(exp2(log2(((_331 * 18.8515625f) + 0.8359375f) / ((_331 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
        _365 = int(floor(_359));
        _366 = int(floor(_360));
        _367 = int(floor(_361));
        _371 = _359 - float((int)(_365));
        _372 = _360 - float((int)(_366));
        _373 = _361 - float((int)(_367));
        _378 = ((int)(uint)((int)(_373 > _371))) + ((int)(uint)((int)(_372 > _371)));
        _383 = ((int)(uint)((int)(_373 > _372))) + ((int)(uint)((int)(_371 >= _372)));
        _388 = ((int)(uint)((int)(_371 >= _373))) + ((int)(uint)((int)(_372 >= _373)));
        _389 = (_378 == 0);
        _390 = (_383 == 0);
        _391 = (_388 == 0);
        _409 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_367), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_365), (int)(0))), (int)(47))), min((int)(max((int)(_366), (int)(0))), (int)(47)), 0));
        _424 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_391))) + _367))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_389))) + _365))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_390))) + _366))), (int)(0))), (int)(47)), 0));
        _439 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_388 < (uint)2)))) + _367))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_378 < (uint)2)))) + _365))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_383 < (uint)2)))) + _366))), (int)(0))), (int)(47)), 0));
        _454 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_367 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_365 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_366 + 1u))), (int)(0))), (int)(47)), 0));
        _461 = dot(float3(_371, _372, _373), float3(((float)((bool)_389)), ((float)((bool)_390)), ((float)((bool)_391))));
        _468 = dot(float3(_371, _372, _373), float3(((float)((bool)(uint)(_378 == 2))), ((float)((bool)(uint)(_383 == 2))), ((float)((bool)(uint)(_388 == 2)))));
        _472 = (((_372 + _371) + _373) - _461) - _468;
        _473 = 1.0f - _461;
        _477 = _461 - _472;
        _481 = _472 - _468;
        _490 = (((_468 * _454.x) + (_473 * _409.x)) + (_477 * _424.x)) + (_481 * _439.x);
        _493 = (((_468 * _454.y) + (_473 * _409.y)) + (_477 * _424.y)) + (_481 * _439.y);
        _496 = (((_468 * _454.z) + (_473 * _409.z)) + (_477 * _424.z)) + (_481 * _439.z);
        _498 = mad(0.21580375730991364f, _496, mad(0.3963377773761749f, _493, _490));
        _500 = mad(-0.0638541728258133f, _496, mad(-0.10556134581565857f, _493, _490));
        _502 = mad(-1.2914855480194092f, _496, mad(-0.08948417752981186f, _493, _490));
        _506 = (_498 * _498) * _498;
        _507 = (_500 * _500) * _500;
        _508 = (_502 * _502) * _502;
        _511 = mad(0.23096993565559387f, _508, mad(-3.307711601257324f, _507, (_506 * 4.076741695404053f)));
        _514 = mad(-0.34131938219070435f, _508, mad(2.609757423400879f, _507, (_506 * -1.2684379816055298f)));
        _517 = mad(1.7076146602630615f, _508, mad(-0.7034186124801636f, _507, (_506 * -0.004196086432784796f)));
        _519 = dot(float3(_511, _514, _517), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _530 = (lerp(_519, _511, g_fTonemapSaturation));
        _531 = (lerp(_519, _514, g_fTonemapSaturation));
        _532 = (lerp(_519, _517, g_fTonemapSaturation));
      } else {
        _530 = _308;
        _531 = _309;
        _532 = _310;
      }
      if (_237) {
        do {
          _1088 = _530;
          _1089 = _531;
          _1090 = _532;
          if (!(g_iTonemapper == 0)) {
            if (g_iTonemapper == 2) {
#if 1
              if (TONE_MAP_TYPE == 0.f) {
                _538 = max(_530, 0.0f);
                _539 = max(_531, 0.0f);
                _540 = max(_532, 0.0f);
              } else {
                _538 = _530;
                _539 = _531;
                _540 = _532;
              }
              float3 agx_color = ApplyRemedyAgX(
                  _538, _539, _540, _248,
                  g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
                  g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
                  g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
                  g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
                  g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
                  g_fAgxHDRRatio, g_fAgxHDRMidGrey,
                  g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
                  SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
              _1088 = agx_color.x;
              _1089 = agx_color.y;
              _1090 = agx_color.z;
#else
              _538 = max(_530, 0.0f);
              _539 = max(_531, 0.0f);
              _540 = max(_532, 0.0f);
              _587 = g_fAgxMaxEV - g_fAgxMinEV;
              _591 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _540, mad(g_vAgxInsetRow0.y, _539, (g_vAgxInsetRow0.x * _538))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _587);
              _592 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _540, mad(g_vAgxInsetRow1.y, _539, (g_vAgxInsetRow1.x * _538))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _587);
              _593 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _540, mad(g_vAgxInsetRow2.y, _539, (g_vAgxInsetRow2.x * _538))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _587);
              _602 = (g_fAgxContrastSlope * (_591 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _603 = 1.0f / g_fAgxShoulderPower;
              _620 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
              _622 = _620 * (0.6060606241226196f - _591);
              _623 = 1.0f / g_fAgxToePower;
              _642 = -0.0f - g_fAgxToePrecalcConstant;
              _645 = select((_591 >= 0.6060606241226196f), ((_602 / exp2(log2((float((int)(((int)(uint)((int)(_602 > 0.0f))) - ((int)(uint)((int)(_602 < 0.0f))))) * exp2(log2(abs(_602)) * g_fAgxShoulderPower)) + 1.0f) * _603)) * g_fAgxShoulderPrecalcConstant), ((_622 / exp2(log2((float((int)(((int)(uint)((int)(_622 > 0.0f))) - ((int)(uint)((int)(_622 < 0.0f))))) * exp2(log2(abs(_622)) * g_fAgxToePower)) + 1.0f) * _623)) * _642)) + 0.4894371032714844f;
              _648 = (g_fAgxContrastSlope * (_592 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _666 = _620 * (0.6060606241226196f - _592);
              _687 = select((_592 >= 0.6060606241226196f), ((_648 / exp2(log2((float((int)(((int)(uint)((int)(_648 > 0.0f))) - ((int)(uint)((int)(_648 < 0.0f))))) * exp2(log2(abs(_648)) * g_fAgxShoulderPower)) + 1.0f) * _603)) * g_fAgxShoulderPrecalcConstant), ((_666 / exp2(log2((exp2(log2(abs(_666)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_666 > 0.0f))) - ((int)(uint)((int)(_666 < 0.0f)))))) + 1.0f) * _623)) * _642)) + 0.4894371032714844f;
              _690 = (g_fAgxContrastSlope * (_593 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _708 = _620 * (0.6060606241226196f - _593);
              _729 = select((_593 >= 0.6060606241226196f), ((_690 / exp2(log2((float((int)(((int)(uint)((int)(_690 > 0.0f))) - ((int)(uint)((int)(_690 < 0.0f))))) * exp2(log2(abs(_690)) * g_fAgxShoulderPower)) + 1.0f) * _603)) * g_fAgxShoulderPrecalcConstant), ((_708 / exp2(log2((exp2(log2(abs(_708)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_708 > 0.0f))) - ((int)(uint)((int)(_708 < 0.0f)))))) + 1.0f) * _623)) * _642)) + 0.4894371032714844f;
              _748 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _729, mad(g_vAgxOutsetRow0.y, _687, (_645 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
              _749 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _729, mad(g_vAgxOutsetRow1.y, _687, (_645 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
              _750 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _729, mad(g_vAgxOutsetRow2.y, _687, (_645 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
              do {
                _868 = _748;
                _869 = _749;
                _870 = _750;
                if (g_fAgxHDRRatio > 1.0f) {
                  if (!(!(max(_748, max(_749, _750)) >= g_fAgxHDRMidGrey))) {
                    _761 = log2(1.0f / g_fAgxHDRMidGrey);
                    _762 = _761 + 20.0f;
                    _763 = log2(g_fAgxHDRRatio);
                    _782 = (min(max(log2(max(_748, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _761) + 20.0f) / _762;
                    _783 = (min(max(log2(max(_749, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _761) + 20.0f) / _762;
                    _784 = (min(max(log2(max(_750, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _761) + 20.0f) / _762;
                    _785 = 20.0f / _762;
                    _789 = max(_782, max(_783, _784));
                    _794 = ((_789 - _785) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _811 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_785 - _789);
                    _833 = select((_789 >= _785), ((_794 / exp2(log2((float((int)(((int)(uint)((int)(_794 > 0.0f))) - ((int)(uint)((int)(_794 < 0.0f))))) * exp2(log2(abs(_794)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_811 / exp2(log2((float((int)(((int)(uint)((int)(_811 > 0.0f))) - ((int)(uint)((int)(_811 < 0.0f))))) * exp2(log2(abs(_811)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _763) / _762);
                    _839 = exp2((((_833 - _789) * _762) + _763) * g_fAgxHDRSaturation);
                    _868 = (saturate(exp2(((_833 + (_839 * (_782 - _789))) * _762) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _869 = (saturate(exp2(((_833 + (_839 * (_783 - _789))) * _762) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _870 = (saturate(exp2(((_833 + (_839 * (_784 - _789))) * _762) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                  } else {
                    _868 = _748;
                    _869 = _749;
                    _870 = _750;
                  }
                }
                _1088 = (mad(-0.07283977419137955f, _870, mad(-0.5876564383506775f, _869, (_868 * 1.6604962348937988f))) * _248);
                _1089 = (mad(-0.008348013274371624f, _870, mad(1.1328951120376587f, _869, (_868 * -0.1245470941066742f))) * _248);
                _1090 = (mad(1.118751049041748f, _870, mad(-0.10059737414121628f, _869, (_868 * -0.018153680488467216f))) * _248);
              } while (false);
#endif
              if (_loop_break_1 && !_loop_break_0) break;
            } else {
              _538 = max(_530, 0.0f);
              _539 = max(_531, 0.0f);
              _540 = max(_532, 0.0f);
              _884 = dot(float3(_538, _539, _540), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
              do {
                _894 = _538;
                _895 = _539;
                _896 = _540;
                if (!(_884 == 0.0f)) {
                  _889 = max(dot(float3(_530, _531, _532), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _884;
                  _894 = (_889 * _538);
                  _895 = (_889 * _539);
                  _896 = (_889 * _540);
                }
                _902 = max(max(_894, max(_895, _896)), 0.0f);
                _904 = 1.0f / max(_902, 1.1754943508222875e-38f);
                _910 = (pow(_902, g_vTonemapGTParams.x));
                _918 = _910 / (((pow(_910, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
                _932 = exp2(log2(_904 * _894) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
                _933 = exp2(log2(_904 * _895) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
                _934 = exp2(log2(_904 * _896) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
                _939 = log2(_918);
                _967 = saturate(exp2(log2((exp2(_939 * g_vTonemapCrosstalk.x) * (1.0f - _932)) + _932) * g_vTonemapCrosstalkSaturation.x) * _918);
                _968 = saturate(exp2(log2((exp2(_939 * g_vTonemapCrosstalk.y) * (1.0f - _933)) + _933) * g_vTonemapCrosstalkSaturation.y) * _918);
                _969 = saturate(exp2(log2((exp2(_939 * g_vTonemapCrosstalk.z) * (1.0f - _934)) + _934) * g_vTonemapCrosstalkSaturation.z) * _918);
                if (_313) {
                  do {
                    _1081 = _967;
                    _1082 = _968;
                    _1083 = _969;
                    if (_239) {
                      do {
                        [branch]
                        if (!(_967 <= 0.0031308000907301903f)) {
                          _982 = (((pow(_967, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _982 = (_967 * 12.920000076293945f);
                        }
                        do {
                          [branch]
                          if (!(_968 <= 0.0031308000907301903f)) {
                            _993 = (((pow(_968, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          } else {
                            _993 = (_968 * 12.920000076293945f);
                          }
                          do {
                            [branch]
                            if (!(_969 <= 0.0031308000907301903f)) {
                              _1004 = (((pow(_969, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            } else {
                              _1004 = (_969 * 12.920000076293945f);
                            }
                            _1011 = (saturate(_993) * 0.96875f) + 0.015625f;
                            _1013 = max((saturate(_1004) * 31.0f), 0.0f);
                            _1014 = floor(_1013);
                            _1015 = _1013 - _1014;
                            _1017 = (((saturate(_982) * 0.96875f) + 0.015625f) + _1014) * 0.03125f;
                            _1019 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_1017, _1011), 0.0f);
                            _1023 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_1017 + 0.03125f), _1011), 0.0f);
                            _1033 = ((_1023.x - _1019.x) * _1015) + _1019.x;
                            _1034 = ((_1023.y - _1019.y) * _1015) + _1019.y;
                            _1035 = ((_1023.z - _1019.z) * _1015) + _1019.z;
                            do {
                              [branch]
                              if (!(_1033 <= 0.040449999272823334f)) {
                                _1046 = exp2(log2((_1033 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _1046 = (_1033 * 0.07739938050508499f);
                              }
                              do {
                                [branch]
                                if (!(_1034 <= 0.040449999272823334f)) {
                                  _1057 = exp2(log2((_1034 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                } else {
                                  _1057 = (_1034 * 0.07739938050508499f);
                                }
                                do {
                                  [branch]
                                  if (!(_1035 <= 0.040449999272823334f)) {
                                    _1068 = exp2(log2((_1035 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                  } else {
                                    _1068 = (_1035 * 0.07739938050508499f);
                                  }
                                  _1070 = dot(float3(_1046, _1057, _1068), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                                  _1081 = (lerp(_1070, _1046, g_fTonemapSaturation));
                                  _1082 = (lerp(_1070, _1057, g_fTonemapSaturation));
                                  _1083 = (lerp(_1070, _1068, g_fTonemapSaturation));
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
                    _1088 = (_1081 * _248);
                    _1089 = (_1082 * _248);
                    _1090 = (_1083 * _248);
                  } while (false);
                  if (_loop_break_1 && !_loop_break_0) break;
                } else {
                  _1088 = _967;
                  _1089 = _968;
                  _1090 = _969;
                }
              } while (false);
              if (_loop_break_1 && !_loop_break_0) break;
            }
          }
          _1099 = (_1088 * g_fTonemapBrightness);
          _1100 = (_1089 * g_fTonemapBrightness);
          _1101 = (_1090 * g_fTonemapBrightness);
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _1099 = (_530 * _248);
        _1100 = (_531 * _248);
        _1101 = (_532 * _248);
      }
      if (!(g_bApplyFilmGrain == 0)) {
        _1113 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
        _1120 = (_1113.x * 2.0f) + -1.0f;
        _1121 = (_1113.y * 2.0f) + -1.0f;
        _1122 = (_1113.z * 2.0f) + -1.0f;
        if (!(_237)) {
          _1125 = _1099 / _248;
          _1126 = _1100 / _248;
          _1127 = _1101 / _248;
          _1131 = 1.0f - sqrt(max(dot(float3(_1125, _1126, _1127), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
          _1136 = g_fFilmGrainIntensity * (_248 * 5.0f);
          _1199 = ((((_1136 * _1120) * saturate(_1125)) * _1131) + _1099);
          _1200 = ((((_1136 * _1121) * _1131) * saturate(_1126)) + _1100);
          _1201 = ((((_1136 * _1122) * _1131) * saturate(_1127)) + _1101);
        } else {
          _1150 = saturate(_1099);
          _1151 = saturate(_1100);
          _1152 = saturate(_1101);
          _1157 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_1150, max(_1151, _1152))));
          _1158 = _1157 * _1150;
          _1159 = _1157 * _1151;
          _1160 = _1157 * _1152;
          _1168 = ((1.0f - sqrt(dot(float3(_1158, _1159, _1160), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
          _1175 = ((_1168 * _1120) * min(1.0f, _1158)) + _1158;
          _1176 = ((_1168 * _1121) * min(1.0f, _1159)) + _1159;
          _1177 = ((_1168 * _1122) * min(1.0f, _1160)) + _1160;
          _1181 = 1.0f / (max(_1175, max(_1176, _1177)) + 1.0f);
          _1188 = 1.0f / (max(_1158, max(_1159, _1160)) + 1.0f);
          _1199 = (((_1175 * _1181) + _1099) - (_1188 * _1158));
          _1200 = (((_1176 * _1181) + _1100) - (_1188 * _1159));
          _1201 = (((_1177 * _1181) + _1101) - (_1188 * _1160));
        }
      } else {
        _1199 = _1099;
        _1200 = _1100;
        _1201 = _1101;
      }
      if (!(_174)) {
        _1205 = (uint)(int(SV_Position.x)) + (uint)(-96);
        _1206 = (uint)(int(SV_Position.y)) + (uint)(-48);
        uint2 _1207;
        g_tBaseColorCorrectionMap.GetDimensions(_1207.x, _1207.y);
        if (((int)_1206 < (int)int(float((int)((int)(_1207.y))))) && (((int)(_1206 | _1205) > (int)-1) && ((int)_1205 < (int)int(float((int)((int)(_1207.x))))))) {
          _1221 = g_tBaseColorCorrectionMap.Load(int3(_1205, _1206, 0));
          if (!(_313)) {
            _1227 = mad(0.21580375730991364f, _1221.z, mad(0.3963377773761749f, _1221.y, _1221.x));
            _1229 = mad(-0.0638541728258133f, _1221.z, mad(-0.10556134581565857f, _1221.y, _1221.x));
            _1231 = mad(-1.2914855480194092f, _1221.z, mad(-0.08948417752981186f, _1221.y, _1221.x));
            _1235 = (_1227 * _1227) * _1227;
            _1236 = (_1229 * _1229) * _1229;
            _1237 = (_1231 * _1231) * _1231;
            _1280 = mad(0.23096993565559387f, _1237, mad(-3.307711601257324f, _1236, (_1235 * 4.076741695404053f)));
            _1281 = mad(-0.34131938219070435f, _1237, mad(2.609757423400879f, _1236, (_1235 * -1.2684379816055298f)));
            _1282 = mad(1.7076146602630615f, _1237, mad(-0.7034186124801636f, _1236, (_1235 * -0.004196086432784796f)));
          } else {
            do {
              [branch]
              if (!(_1221.x <= 0.040449999272823334f)) {
                _1258 = exp2(log2((_1221.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
              } else {
                _1258 = (_1221.x * 0.07739938050508499f);
              }
              do {
                [branch]
                if (!(_1221.y <= 0.040449999272823334f)) {
                  _1269 = exp2(log2((_1221.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                } else {
                  _1269 = (_1221.y * 0.07739938050508499f);
                }
                [branch]
                if (!(_1221.z <= 0.040449999272823334f)) {
                  _1280 = _1258;
                  _1281 = _1269;
                  _1282 = exp2(log2((_1221.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                } else {
                  _1280 = _1258;
                  _1281 = _1269;
                  _1282 = (_1221.z * 0.07739938050508499f);
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
          _1280 = _1199;
          _1281 = _1200;
          _1282 = _1201;
        }
      } else {
        _1280 = _1199;
        _1281 = _1200;
        _1282 = _1201;
      }
      if (!(g_bDebugValidateOutputRange == 0)) {
        _1289 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
        do {
          _1302 = true;
          if (!(((_1280 < 0.0f) || (_1281 < 0.0f)) || (_1282 < 0.0f))) {
            _1302 = ((_1282 > _1289) || ((_1280 > _1289) || (_1281 > _1289)));
          }
          if (_1302) {
            _1308 = float((int)(int(g_fRealTime * 15.0f)));
            _1318 = select((((((int)((uint)(int(SV_Position.y - _1308)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1308)) / 5u))) & 1) == 0), 1.0f, 0.0f);
            _1323 = (_1318 * _1280);
            _1324 = (_1318 * _1281);
            _1325 = (_1318 * _1282);
          } else {
            _1323 = _1280;
            _1324 = _1281;
            _1325 = _1282;
          }
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _1323 = _1280;
        _1324 = _1281;
        _1325 = _1282;
      }
      if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
        _1331 = (g_bHDR == 0);
        do {
          _1358 = _1323;
          _1359 = _1324;
          _1360 = _1325;
          if (!(_1331 || (g_bHDR_scRGB == 0))) {
            _1345 = max(mad(0.043306104838848114f, _1325, mad(0.329291969537735f, _1324, (_1323 * 0.6274019479751587f))), 0.0f);
            _1346 = max(mad(0.0113602289929986f, _1325, mad(0.9195442795753479f, _1324, (_1323 * 0.06909549236297607f))), 0.0f);
            _1347 = max(mad(0.895578145980835f, _1325, mad(0.08802816271781921f, _1324, (_1323 * 0.016393709927797318f))), 0.0f);
            _1358 = mad(-0.07283977419137955f, _1347, mad(-0.5876564383506775f, _1346, (_1345 * 1.6604962348937988f)));
            _1359 = mad(-0.008348013274371624f, _1347, mad(1.1328951120376587f, _1346, (_1345 * -0.1245470941066742f)));
            _1360 = mad(1.118751049041748f, _1347, mad(-0.10059737414121628f, _1346, (_1345 * -0.018153680488467216f)));
          }
          if ((g_bHDR_scRGB == 0) && (!_1331)) {
            _1376 = mad(0.043306104838848114f, _1360, mad(0.329291969537735f, _1359, (_1358 * 0.6274019479751587f)));
            _1377 = mad(0.0113602289929986f, _1360, mad(0.9195442795753479f, _1359, (_1358 * 0.06909549236297607f)));
            _1378 = mad(0.895578145980835f, _1360, mad(0.08802816271781921f, _1359, (_1358 * 0.016393709927797318f)));
          } else {
            _1376 = _1358;
            _1377 = _1359;
            _1378 = _1360;
          }
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _1376 = _1323;
        _1377 = _1324;
        _1378 = _1325;
      }
      SV_Target.x = _1376;
      SV_Target.y = _1377;
      SV_Target.z = _1378;
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
