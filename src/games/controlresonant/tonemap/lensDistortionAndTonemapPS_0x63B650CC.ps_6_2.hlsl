#include "./tonemap.hlsli"

StructuredBuffer<float> g_bBrightness : register(t0);

Texture2D<float4> g_tFilmGrain : register(t1);

Texture2D<float4> g_tBaseColorCorrectionMap : register(t2);

Texture2D<float4> g_tSource : register(t3);

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

cbuffer shared_hdr_global : register(b2) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

cbuffer shared_hdr : register(b3) {
  float g_fExposureCompensationInEV100 : packoffset(c000.x);
};

cbuffer shared_tonemap_general : register(b4) {
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

cbuffer shared_tonemap_post : register(b5) {
  float g_fPaperWhite : packoffset(c000.x);
  int g_bApplyVignette : packoffset(c000.y);
  int g_bApplyFilmGrain : packoffset(c000.z);
};

cbuffer sourceres : register(b6) {
  float2 g_vSourceRes : packoffset(c000.x);
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
  float _19;
  float _20;
  float _30;
  float _31;
  float _61;
  float _62;
  float _80;
  float _81;
  float _82;
  float _83;
  int _84;
  float _86;
  float _87;
  float _88;
  float _89;
  int _90;
  float _128;
  float _146;
  float _147;
  float _148;
  float _149;
  float _171;
  float _191;
  float _192;
  float _193;
  float _231;
  float _232;
  float _233;
  float _453;
  float _454;
  float _455;
  float _791;
  float _792;
  float _793;
  float _821;
  float _822;
  float _823;
  float _908;
  float _919;
  float _930;
  float _972;
  float _983;
  float _994;
  float _1007;
  float _1008;
  float _1009;
  float _1168;
  float _1169;
  float _1170;
  float _1179;
  float _1180;
  float _1181;
  float _1229;
  float _1230;
  float _1231;
  float _1265;
  float _1266;
  float _1267;
  float _1283;
  float _1284;
  float _1285;
  float _42;
  float _46;
  float _47;
  float _51;
  float _55;
  float _67;
  float _68;
  float _93;
  float _94;
  float _102;
  float _103;
  float _108;
  float _113;
  float _114;
  float _115;
  float _116;
  float _121;
  float _122;
  float4 _134;
  int _150;
  int _153;
  float _156;
  float _157;
  float _158;
  bool _161;
  bool _163;
  float _195;
  float _199;
  float _200;
  float _201;
  float _202;
  float _211;
  float _212;
  float _226;
  bool _236;
  float _252;
  float _253;
  float _254;
  float _282;
  float _283;
  float _284;
  int _288;
  int _289;
  int _290;
  float _294;
  float _295;
  float _296;
  int _301;
  int _306;
  int _311;
  bool _312;
  bool _313;
  bool _314;
  float4 _332;
  float4 _347;
  float4 _362;
  float4 _377;
  float _384;
  float _391;
  float _395;
  float _396;
  float _400;
  float _404;
  float _413;
  float _416;
  float _419;
  float _421;
  float _423;
  float _425;
  float _429;
  float _430;
  float _431;
  float _434;
  float _437;
  float _440;
  float _442;
  float _486;
  float _487;
  float _488;
  float _510;
  float _514;
  float _515;
  float _516;
  float _525;
  float _526;
  float _543;
  float _545;
  float _546;
  float _565;
  float _568;
  float _571;
  float _589;
  float _610;
  float _613;
  float _631;
  float _652;
  float _671;
  float _672;
  float _673;
  float _684;
  float _685;
  float _686;
  float _705;
  float _706;
  float _707;
  float _708;
  float _712;
  float _717;
  float _734;
  float _756;
  float _762;
  float _808;
  float _809;
  float _810;
  float _811;
  float _816;
  float _829;
  float _831;
  float _837;
  float _845;
  float _859;
  float _860;
  float _861;
  float _866;
  float _894;
  float _895;
  float _896;
  float _937;
  float _939;
  float _940;
  float _941;
  float _943;
  float4 _945;
  float4 _949;
  float _959;
  float _960;
  float _961;
  float _996;
  float _1018;
  float _1023;
  float _1025;
  float _1026;
  float _1027;
  float _1028;
  float _1038;
  float _1042;
  float _1091;
  float _1092;
  float _1093;
  float _1098;
  float _1111;
  float _1112;
  float _1113;
  float _1145;
  float _1147;
  float _1149;
  float _1150;
  float _1163;
  float4 _1193;
  float _1203;
  float _1204;
  float _1205;
  float _1209;
  float _1215;
  bool _1238;
  float _1252;
  float _1253;
  float _1254;
  _19 = g_vInvOutputRes.x * SV_Position.x;
  _20 = g_vInvOutputRes.y * SV_Position.y;
  _30 = ((_19 * 2.0f) + -1.0f) / g_vLensDistortionUVScale.x;
  _31 = ((_20 * 2.0f) + -1.0f) / g_vLensDistortionUVScale.y;
  if (!(!(g_vLensDistortionParams.w >= 0.0f))) {
    _42 = (g_vLensDistortionParams.x - ((_30 * _30) * g_vLensDistortionParams.y)) - ((_31 * _31) * g_vLensDistortionParams.z);
    _61 = (_30 / _42);
    _62 = (_31 / _42);
  } else {
    _46 = _30 * 0.5f;
    _47 = _31 * 0.5f;
    _51 = sqrt((_47 * _47) + (_46 * _46));
    _55 = (((_51 * _51) * g_vLensDistortionParams.w) + 1.0f) * _51;
    _61 = (_55 * (_30 / _51));
    _62 = (_55 * (_31 / _51));
  }
  _67 = ((_61 * g_vLensDistortionUVScale.x) + 1.0f) * 0.5f;
  _68 = ((_62 * g_vLensDistortionUVScale.y) + 1.0f) * 0.5f;
  _80 = 0.0f;
  _81 = 0.0f;
  _82 = 0.0f;
  _83 = 0.0f;
  _84 = -1;
  bool _loop_break_0 = false;
  while (true) {
    _86 = _80;
    _87 = _81;
    _88 = _82;
    _89 = _83;
    _90 = -1;
    bool _loop_break_1 = false;
    while (true) {
      _93 = (floor(_67 * g_vSourceRes.x) + 0.5f) + float((int)(_90));
      _94 = (floor(_68 * g_vSourceRes.y) + 0.5f) + float((int)(_84));
      _102 = (_67 - (_93 / g_vSourceRes.x)) * g_vSourceRes.x;
      _103 = (_68 - (_94 / g_vSourceRes.y)) * g_vSourceRes.y;
      _108 = sqrt((_103 * _103) + (_102 * _102)) * g_fLensDistortionJincSize;
      if (!(_108 > 1.2196699380874634f)) {
        _113 = 0.652899980545044f - (_108 * 1.0068999528884888f);
        _114 = (_108 * 0.59170001745224f) + 0.8378999829292297f;
        _115 = _113 * _113;
        _116 = _114 * _114;
        _121 = mad(-0.5547999739646912f, _116, (_115 * 0.5823000073432922f)) + 0.15240000188350677f;
        _122 = mad(0.4828000068664551f, _116, (_115 * -0.47380000352859497f)) + -0.22939999401569366f;
        _128 = (dot(float2((_121 * _121), (_122 * _122)), float2(-0.7231000065803528f, -0.44690001010894775f)) + 0.9991000294685364f);
      } else {
        _128 = 0.0f;
      }
      if (abs(_128) > 0.0f) {
        _134 = g_tSource.Load(int3((int)(uint(_93)), (int)(uint(_94)), 0));
        _146 = ((_134.x * _128) + _86);
        _147 = ((_134.y * _128) + _87);
        _148 = ((_134.z * _128) + _88);
        _149 = (_128 + _89);
      } else {
        _146 = _86;
        _147 = _87;
        _148 = _88;
        _149 = _89;
      }
      _150 = _90 + 1;
      if (!(_150 == 2)) {
        _86 = _146;
        _87 = _147;
        _88 = _148;
        _89 = _149;
        _90 = _150;
        continue;
      }
      _153 = _84 + 1;
      if (!(_153 == 2)) {
        _80 = _146;
        _81 = _147;
        _82 = _148;
        _83 = _149;
        _84 = _153;
        _loop_break_0 = true;
        break;
      }
      _156 = _146 / _149;
      _157 = _147 / _149;
      _158 = _148 / _149;
      _161 = (g_bPostProcessApplyTonemap == 0);
      _163 = (g_bPostProcessApplyColorGrade != 0);
      if (!(_161)) {
        _171 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
      } else {
        _171 = 1.0f;
      }
      if (_163) {
        _191 = max(_156, 0.0f);
        _192 = max(_157, 0.0f);
        _193 = max(_158, 0.0f);
      } else {
        _191 = _156;
        _192 = _157;
        _193 = _158;
      }
      _195 = g_bBrightness[1];
      _199 = exp2(g_fExposureCompensationInEV100) * _195;
      _200 = _199 * _191;
      _201 = _199 * _192;
      _202 = _199 * _193;
      if (!(g_bApplyVignette == 0)) {
        _211 = ((((g_vOverriddenAspectRatioUVScale.x * _19) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
        _212 = (((g_vOverriddenAspectRatioUVScale.y * _20) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
        _226 = saturate(exp2(log2(saturate(1.0f - sqrt((_211 * _211) + (_212 * _212))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
        _231 = (_226 * _200);
        _232 = (_226 * _201);
        _233 = (_226 * _202);
      } else {
        _231 = _200;
        _232 = _201;
        _233 = _202;
      }
      _236 = (g_bEnableHDRLUT == 0);
      if (!(_236 || (!_163))) {
        _252 = exp2(log2(saturate(_231 * 0.00800000037997961f)) * 0.1593017578125f);
        _253 = exp2(log2(saturate(_232 * 0.00800000037997961f)) * 0.1593017578125f);
        _254 = exp2(log2(saturate(_233 * 0.00800000037997961f)) * 0.1593017578125f);
        _282 = saturate(exp2(log2(((_252 * 18.8515625f) + 0.8359375f) / ((_252 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
        _283 = saturate(exp2(log2(((_253 * 18.8515625f) + 0.8359375f) / ((_253 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
        _284 = saturate(exp2(log2(((_254 * 18.8515625f) + 0.8359375f) / ((_254 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
        _288 = int(floor(_282));
        _289 = int(floor(_283));
        _290 = int(floor(_284));
        _294 = _282 - float((int)(_288));
        _295 = _283 - float((int)(_289));
        _296 = _284 - float((int)(_290));
        _301 = ((int)(uint)((int)(_296 > _294))) + ((int)(uint)((int)(_295 > _294)));
        _306 = ((int)(uint)((int)(_296 > _295))) + ((int)(uint)((int)(_294 >= _295)));
        _311 = ((int)(uint)((int)(_294 >= _296))) + ((int)(uint)((int)(_295 >= _296)));
        _312 = (_301 == 0);
        _313 = (_306 == 0);
        _314 = (_311 == 0);
        _332 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_290), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_288), (int)(0))), (int)(47))), min((int)(max((int)(_289), (int)(0))), (int)(47)), 0));
        _347 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_314))) + _290))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_312))) + _288))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_313))) + _289))), (int)(0))), (int)(47)), 0));
        _362 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_311 < (uint)2)))) + _290))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_301 < (uint)2)))) + _288))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_306 < (uint)2)))) + _289))), (int)(0))), (int)(47)), 0));
        _377 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_290 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_288 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_289 + 1u))), (int)(0))), (int)(47)), 0));
        _384 = dot(float3(_294, _295, _296), float3(((float)((bool)_312)), ((float)((bool)_313)), ((float)((bool)_314))));
        _391 = dot(float3(_294, _295, _296), float3(((float)((bool)(uint)(_301 == 2))), ((float)((bool)(uint)(_306 == 2))), ((float)((bool)(uint)(_311 == 2)))));
        _395 = (((_295 + _294) + _296) - _384) - _391;
        _396 = 1.0f - _384;
        _400 = _384 - _395;
        _404 = _395 - _391;
        _413 = (((_391 * _377.x) + (_396 * _332.x)) + (_400 * _347.x)) + (_404 * _362.x);
        _416 = (((_391 * _377.y) + (_396 * _332.y)) + (_400 * _347.y)) + (_404 * _362.y);
        _419 = (((_391 * _377.z) + (_396 * _332.z)) + (_400 * _347.z)) + (_404 * _362.z);
        _421 = mad(0.21580375730991364f, _419, mad(0.3963377773761749f, _416, _413));
        _423 = mad(-0.0638541728258133f, _419, mad(-0.10556134581565857f, _416, _413));
        _425 = mad(-1.2914855480194092f, _419, mad(-0.08948417752981186f, _416, _413));
        _429 = (_421 * _421) * _421;
        _430 = (_423 * _423) * _423;
        _431 = (_425 * _425) * _425;
        _434 = mad(0.23096993565559387f, _431, mad(-3.307711601257324f, _430, (_429 * 4.076741695404053f)));
        _437 = mad(-0.34131938219070435f, _431, mad(2.609757423400879f, _430, (_429 * -1.2684379816055298f)));
        _440 = mad(1.7076146602630615f, _431, mad(-0.7034186124801636f, _430, (_429 * -0.004196086432784796f)));
        _442 = dot(float3(_434, _437, _440), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _453 = (lerp(_442, _434, g_fTonemapSaturation));
        _454 = (lerp(_442, _437, g_fTonemapSaturation));
        _455 = (lerp(_442, _440, g_fTonemapSaturation));
      } else {
        _453 = _231;
        _454 = _232;
        _455 = _233;
      }
      if (!(_161)) {
        do {
          _1168 = _453;
          _1169 = _454;
          _1170 = _455;
          if (!(g_iTonemapper == 0)) {
            if (g_iTonemapper == 2) {
#if 1
              float3 agx_color = ApplyRemedyAgX(
                  _453, _454, _455, _171,
                  g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
                  g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
                  g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
                  g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
                  g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
                  g_fAgxHDRRatio, g_fAgxHDRMidGrey,
                  g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
                  SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
              _1168 = agx_color.x;
              _1169 = agx_color.y;
              _1170 = agx_color.z;
#else
              _486 = max(_453, 0.0f);
              _487 = max(_454, 0.0f);
              _488 = max(_455, 0.0f);
              _510 = g_fAgxMaxEV - g_fAgxMinEV;
              _514 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _488, mad(g_vAgxInsetRow0.y, _487, (_486 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _510);
              _515 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _488, mad(g_vAgxInsetRow1.y, _487, (_486 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _510);
              _516 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _488, mad(g_vAgxInsetRow2.y, _487, (_486 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _510);
              _525 = (g_fAgxContrastSlope * (_514 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _526 = 1.0f / g_fAgxShoulderPower;
              _543 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
              _545 = _543 * (0.6060606241226196f - _514);
              _546 = 1.0f / g_fAgxToePower;
              _565 = -0.0f - g_fAgxToePrecalcConstant;
              _568 = select((_514 >= 0.6060606241226196f), ((_525 / exp2(log2((float((int)(((int)(uint)((int)(_525 > 0.0f))) - ((int)(uint)((int)(_525 < 0.0f))))) * exp2(log2(abs(_525)) * g_fAgxShoulderPower)) + 1.0f) * _526)) * g_fAgxShoulderPrecalcConstant), ((_545 / exp2(log2((float((int)(((int)(uint)((int)(_545 > 0.0f))) - ((int)(uint)((int)(_545 < 0.0f))))) * exp2(log2(abs(_545)) * g_fAgxToePower)) + 1.0f) * _546)) * _565)) + 0.4894371032714844f;
              _571 = (g_fAgxContrastSlope * (_515 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _589 = _543 * (0.6060606241226196f - _515);
              _610 = select((_515 >= 0.6060606241226196f), ((_571 / exp2(log2((float((int)(((int)(uint)((int)(_571 > 0.0f))) - ((int)(uint)((int)(_571 < 0.0f))))) * exp2(log2(abs(_571)) * g_fAgxShoulderPower)) + 1.0f) * _526)) * g_fAgxShoulderPrecalcConstant), ((_589 / exp2(log2((exp2(log2(abs(_589)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_589 > 0.0f))) - ((int)(uint)((int)(_589 < 0.0f)))))) + 1.0f) * _546)) * _565)) + 0.4894371032714844f;
              _613 = (g_fAgxContrastSlope * (_516 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _631 = _543 * (0.6060606241226196f - _516);
              _652 = select((_516 >= 0.6060606241226196f), ((_613 / exp2(log2((float((int)(((int)(uint)((int)(_613 > 0.0f))) - ((int)(uint)((int)(_613 < 0.0f))))) * exp2(log2(abs(_613)) * g_fAgxShoulderPower)) + 1.0f) * _526)) * g_fAgxShoulderPrecalcConstant), ((_631 / exp2(log2((exp2(log2(abs(_631)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_631 > 0.0f))) - ((int)(uint)((int)(_631 < 0.0f)))))) + 1.0f) * _546)) * _565)) + 0.4894371032714844f;
              _671 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _652, mad(g_vAgxOutsetRow0.y, _610, (_568 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
              _672 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _652, mad(g_vAgxOutsetRow1.y, _610, (_568 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
              _673 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _652, mad(g_vAgxOutsetRow2.y, _610, (_568 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
              do {
                _791 = _671;
                _792 = _672;
                _793 = _673;
                if (g_fAgxHDRRatio > 1.0f) {
                  if (!(!(max(_671, max(_672, _673)) >= g_fAgxHDRMidGrey))) {
                    _684 = log2(1.0f / g_fAgxHDRMidGrey);
                    _685 = _684 + 20.0f;
                    _686 = log2(g_fAgxHDRRatio);
                    _705 = (min(max(log2(max(_671, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _684) + 20.0f) / _685;
                    _706 = (min(max(log2(max(_672, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _684) + 20.0f) / _685;
                    _707 = (min(max(log2(max(_673, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _684) + 20.0f) / _685;
                    _708 = 20.0f / _685;
                    _712 = max(_705, max(_706, _707));
                    _717 = ((_712 - _708) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _734 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_708 - _712);
                    _756 = select((_712 >= _708), ((_717 / exp2(log2((float((int)(((int)(uint)((int)(_717 > 0.0f))) - ((int)(uint)((int)(_717 < 0.0f))))) * exp2(log2(abs(_717)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_734 / exp2(log2((float((int)(((int)(uint)((int)(_734 > 0.0f))) - ((int)(uint)((int)(_734 < 0.0f))))) * exp2(log2(abs(_734)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _686) / _685);
                    _762 = exp2((((_756 - _712) * _685) + _686) * g_fAgxHDRSaturation);
                    _791 = (saturate(exp2(((_756 + (_762 * (_705 - _712))) * _685) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _792 = (saturate(exp2(((_756 + (_762 * (_706 - _712))) * _685) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _793 = (saturate(exp2(((_756 + (_762 * (_707 - _712))) * _685) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                  } else {
                    _791 = _671;
                    _792 = _672;
                    _793 = _673;
                  }
                }
                _1168 = (mad(-0.07283977419137955f, _793, mad(-0.5876564383506775f, _792, (_791 * 1.6604962348937988f))) * _171);
                _1169 = (mad(-0.008348013274371624f, _793, mad(1.1328951120376587f, _792, (_791 * -0.1245470941066742f))) * _171);
                _1170 = (mad(1.118751049041748f, _793, mad(-0.10059737414121628f, _792, (_791 * -0.018153680488467216f))) * _171);
              } while (false);
#endif
              if (_loop_break_1 && !_loop_break_0) break;
            } else {
              if (_236) {
                _808 = max(_453, 0.0f);
                _809 = max(_454, 0.0f);
                _810 = max(_455, 0.0f);
                _811 = dot(float3(_808, _809, _810), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                do {
                  _821 = _808;
                  _822 = _809;
                  _823 = _810;
                  if (!(_811 == 0.0f)) {
                    _816 = max(dot(float3(_453, _454, _455), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _811;
                    _821 = (_816 * _808);
                    _822 = (_816 * _809);
                    _823 = (_816 * _810);
                  }
                  _829 = max(max(_821, max(_822, _823)), 0.0f);
                  _831 = 1.0f / max(_829, 1.1754943508222875e-38f);
                  _837 = (pow(_829, g_vTonemapGTParams.x));
                  _845 = _837 / (((pow(_837, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
                  _859 = exp2(log2(_831 * _821) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
                  _860 = exp2(log2(_831 * _822) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
                  _861 = exp2(log2(_831 * _823) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
                  _866 = log2(_845);
                  _894 = saturate(exp2(log2((exp2(_866 * g_vTonemapCrosstalk.x) * (1.0f - _859)) + _859) * g_vTonemapCrosstalkSaturation.x) * _845);
                  _895 = saturate(exp2(log2((exp2(_866 * g_vTonemapCrosstalk.y) * (1.0f - _860)) + _860) * g_vTonemapCrosstalkSaturation.y) * _845);
                  _896 = saturate(exp2(log2((exp2(_866 * g_vTonemapCrosstalk.z) * (1.0f - _861)) + _861) * g_vTonemapCrosstalkSaturation.z) * _845);
                  do {
                    _1007 = _894;
                    _1008 = _895;
                    _1009 = _896;
                    if (_163) {
                      do {
                        [branch]
                        if (!(_894 <= 0.0031308000907301903f)) {
                          _908 = (((pow(_894, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _908 = (_894 * 12.920000076293945f);
                        }
                        do {
                          [branch]
                          if (!(_895 <= 0.0031308000907301903f)) {
                            _919 = (((pow(_895, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          } else {
                            _919 = (_895 * 12.920000076293945f);
                          }
                          do {
                            [branch]
                            if (!(_896 <= 0.0031308000907301903f)) {
                              _930 = (((pow(_896, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            } else {
                              _930 = (_896 * 12.920000076293945f);
                            }
                            _937 = (saturate(_919) * 0.96875f) + 0.015625f;
                            _939 = max((saturate(_930) * 31.0f), 0.0f);
                            _940 = floor(_939);
                            _941 = _939 - _940;
                            _943 = (((saturate(_908) * 0.96875f) + 0.015625f) + _940) * 0.03125f;
                            _945 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_943, _937), 0.0f);
                            _949 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_943 + 0.03125f), _937), 0.0f);
                            _959 = ((_949.x - _945.x) * _941) + _945.x;
                            _960 = ((_949.y - _945.y) * _941) + _945.y;
                            _961 = ((_949.z - _945.z) * _941) + _945.z;
                            do {
                              [branch]
                              if (!(_959 <= 0.040449999272823334f)) {
                                _972 = exp2(log2((_959 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _972 = (_959 * 0.07739938050508499f);
                              }
                              do {
                                [branch]
                                if (!(_960 <= 0.040449999272823334f)) {
                                  _983 = exp2(log2((_960 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                } else {
                                  _983 = (_960 * 0.07739938050508499f);
                                }
                                do {
                                  [branch]
                                  if (!(_961 <= 0.040449999272823334f)) {
                                    _994 = exp2(log2((_961 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                  } else {
                                    _994 = (_961 * 0.07739938050508499f);
                                  }
                                  _996 = dot(float3(_972, _983, _994), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                                  _1007 = (lerp(_996, _972, g_fTonemapSaturation));
                                  _1008 = (lerp(_996, _983, g_fTonemapSaturation));
                                  _1009 = (lerp(_996, _994, g_fTonemapSaturation));
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
                    _1168 = (_1007 * _171);
                    _1169 = (_1008 * _171);
                    _1170 = (_1009 * _171);
                  } while (false);
                  if (_loop_break_1 && !_loop_break_0) break;
                } while (false);
                if (_loop_break_1 && !_loop_break_0) break;
              } else {
                _1018 = g_fMaxOutputNits * 0.012500000186264515f;
                _1023 = max(abs(_453), max(abs(_454), abs(_455)));
                _1025 = 1.0f / max(_1023, 1.1754943508222875e-38f);
                _1026 = _1025 * _453;
                _1027 = _1025 * _454;
                _1028 = _1025 * _455;
                _1038 = (_171 * 0.18000000715255737f) * exp2(log2((pow(_1023, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
                _1042 = dot(float3((_1038 * _1026), (_1038 * _1027), (_1038 * _1028)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                _1091 = exp2(log2(abs(_1026)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_1026 > 0.0f))) - ((int)(uint)((int)(_1026 < 0.0f)))));
                _1092 = exp2(log2(abs(_1027)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_1027 > 0.0f))) - ((int)(uint)((int)(_1027 < 0.0f)))));
                _1093 = exp2(log2(abs(_1028)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_1028 > 0.0f))) - ((int)(uint)((int)(_1028 < 0.0f)))));
                _1098 = log2(saturate(select((_1042 <= 0.0f), _1042, ((1.0f - exp2(log2(exp2((_1042 / _1018) * -1.4426950216293335f)))) * _1018)) / _1018));
                _1111 = (exp2(_1098 * g_vTonemapCrosstalk.x) * (1.0f - _1091)) + _1091;
                _1112 = (exp2(_1098 * g_vTonemapCrosstalk.y) * (1.0f - _1092)) + _1092;
                _1113 = (exp2(_1098 * g_vTonemapCrosstalk.z) * (1.0f - _1093)) + _1093;
                _1145 = (float((int)(((int)(uint)((int)(_1111 > 0.0f))) - ((int)(uint)((int)(_1111 < 0.0f))))) * _1038) * exp2(log2(abs(_1111)) * g_vTonemapCrosstalkSaturation.x);
                _1147 = (float((int)(((int)(uint)((int)(_1112 > 0.0f))) - ((int)(uint)((int)(_1112 < 0.0f))))) * _1038) * exp2(log2(abs(_1112)) * g_vTonemapCrosstalkSaturation.y);
                _1149 = (float((int)(((int)(uint)((int)(_1113 > 0.0f))) - ((int)(uint)((int)(_1113 < 0.0f))))) * _1038) * exp2(log2(abs(_1113)) * g_vTonemapCrosstalkSaturation.z);
                _1150 = dot(float3(_1145, _1147, _1149), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                _1163 = select((_1150 <= 0.0f), _1150, ((1.0f - exp2(log2(exp2((_1150 / _1018) * -1.4426950216293335f)))) * _1018)) * select((!(_1150 == 0.0f)), (1.0f / _1150), 0.0f);
                _1168 = (_1163 * _1145);
                _1169 = (_1163 * _1147);
                _1170 = (_1163 * _1149);
              }
            }
          }
          _1179 = (_1168 * g_fTonemapBrightness);
          _1180 = (_1169 * g_fTonemapBrightness);
          _1181 = (_1170 * g_fTonemapBrightness);
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _1179 = (_453 * _171);
        _1180 = (_454 * _171);
        _1181 = (_455 * _171);
      }
      if (!(g_bApplyFilmGrain == 0)) {
        _1193 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
        _1203 = _1179 / _171;
        _1204 = _1180 / _171;
        _1205 = _1181 / _171;
        _1209 = 1.0f - sqrt(max(dot(float3(_1203, _1204, _1205), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
        _1215 = g_fFilmGrainIntensity * (_171 * 5.0f);
        _1229 = ((((_1215 * ((_1193.x * 2.0f) + -1.0f)) * saturate(_1203)) * _1209) + _1179);
        _1230 = ((((_1215 * ((_1193.y * 2.0f) + -1.0f)) * _1209) * saturate(_1204)) + _1180);
        _1231 = ((((_1215 * ((_1193.z * 2.0f) + -1.0f)) * _1209) * saturate(_1205)) + _1181);
      } else {
        _1229 = _1179;
        _1230 = _1180;
        _1231 = _1181;
      }
      if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
        _1238 = (g_bHDR == 0);
        do {
          _1265 = _1229;
          _1266 = _1230;
          _1267 = _1231;
          if (!(_1238 || (g_bHDR_scRGB == 0))) {
            _1252 = max(mad(0.043306104838848114f, _1231, mad(0.329291969537735f, _1230, (_1229 * 0.6274019479751587f))), 0.0f);
            _1253 = max(mad(0.0113602289929986f, _1231, mad(0.9195442795753479f, _1230, (_1229 * 0.06909549236297607f))), 0.0f);
            _1254 = max(mad(0.895578145980835f, _1231, mad(0.08802816271781921f, _1230, (_1229 * 0.016393709927797318f))), 0.0f);
            _1265 = mad(-0.07283977419137955f, _1254, mad(-0.5876564383506775f, _1253, (_1252 * 1.6604962348937988f)));
            _1266 = mad(-0.008348013274371624f, _1254, mad(1.1328951120376587f, _1253, (_1252 * -0.1245470941066742f)));
            _1267 = mad(1.118751049041748f, _1254, mad(-0.10059737414121628f, _1253, (_1252 * -0.018153680488467216f)));
          }
          if ((g_bHDR_scRGB == 0) && (!_1238)) {
            _1283 = mad(0.043306104838848114f, _1267, mad(0.329291969537735f, _1266, (_1265 * 0.6274019479751587f)));
            _1284 = mad(0.0113602289929986f, _1267, mad(0.9195442795753479f, _1266, (_1265 * 0.06909549236297607f)));
            _1285 = mad(0.895578145980835f, _1267, mad(0.08802816271781921f, _1266, (_1265 * 0.016393709927797318f)));
          } else {
            _1283 = _1265;
            _1284 = _1266;
            _1285 = _1267;
          }
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _1283 = _1229;
        _1284 = _1230;
        _1285 = _1231;
      }
      SV_Target.x = _1283;
      SV_Target.y = _1284;
      SV_Target.z = _1285;
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
