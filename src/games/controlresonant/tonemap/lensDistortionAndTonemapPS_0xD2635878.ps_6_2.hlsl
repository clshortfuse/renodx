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
  float _172;
  float _192;
  float _193;
  float _194;
  float _232;
  float _233;
  float _234;
  float _454;
  float _455;
  float _456;
  float _792;
  float _793;
  float _794;
  float _818;
  float _819;
  float _820;
  float _906;
  float _917;
  float _928;
  float _970;
  float _981;
  float _992;
  float _1005;
  float _1006;
  float _1007;
  float _1012;
  float _1013;
  float _1014;
  float _1023;
  float _1024;
  float _1025;
  float _1123;
  float _1124;
  float _1125;
  float _1159;
  float _1160;
  float _1161;
  float _1177;
  float _1178;
  float _1179;
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
  float _196;
  float _200;
  float _201;
  float _202;
  float _203;
  float _212;
  float _213;
  float _227;
  bool _237;
  float _253;
  float _254;
  float _255;
  float _283;
  float _284;
  float _285;
  int _289;
  int _290;
  int _291;
  float _295;
  float _296;
  float _297;
  int _302;
  int _307;
  int _312;
  bool _313;
  bool _314;
  bool _315;
  float4 _333;
  float4 _348;
  float4 _363;
  float4 _378;
  float _385;
  float _392;
  float _396;
  float _397;
  float _401;
  float _405;
  float _414;
  float _417;
  float _420;
  float _422;
  float _424;
  float _426;
  float _430;
  float _431;
  float _432;
  float _435;
  float _438;
  float _441;
  float _443;
  float _462;
  float _463;
  float _464;
  float _511;
  float _515;
  float _516;
  float _517;
  float _526;
  float _527;
  float _544;
  float _546;
  float _547;
  float _566;
  float _569;
  float _572;
  float _590;
  float _611;
  float _614;
  float _632;
  float _653;
  float _672;
  float _673;
  float _674;
  float _685;
  float _686;
  float _687;
  float _706;
  float _707;
  float _708;
  float _709;
  float _713;
  float _718;
  float _735;
  float _757;
  float _763;
  float _808;
  float _813;
  float _826;
  float _828;
  float _834;
  float _842;
  float _856;
  float _857;
  float _858;
  float _863;
  float _891;
  float _892;
  float _893;
  float _935;
  float _937;
  float _938;
  float _939;
  float _941;
  float4 _943;
  float4 _947;
  float _957;
  float _958;
  float _959;
  float _994;
  float4 _1037;
  float _1044;
  float _1045;
  float _1046;
  float _1049;
  float _1050;
  float _1051;
  float _1055;
  float _1060;
  float _1074;
  float _1075;
  float _1076;
  float _1081;
  float _1082;
  float _1083;
  float _1084;
  float _1092;
  float _1099;
  float _1100;
  float _1101;
  float _1105;
  float _1112;
  bool _1132;
  float _1146;
  float _1147;
  float _1148;
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
      _161 = (g_bPostProcessApplyTonemap != 0);
      _163 = (g_bPostProcessApplyColorGrade != 0);
      if (!(g_bPostProcessApplyTonemap == 0)) {
        _172 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
      } else {
        _172 = 1.0f;
      }
      if (_163) {
        _192 = max(_156, 0.0f);
        _193 = max(_157, 0.0f);
        _194 = max(_158, 0.0f);
      } else {
        _192 = _156;
        _193 = _157;
        _194 = _158;
      }
      _196 = g_bBrightness[1];
      _200 = exp2(g_fExposureCompensationInEV100) * _196;
      _201 = _200 * _192;
      _202 = _200 * _193;
      _203 = _200 * _194;
      if (!(g_bApplyVignette == 0)) {
        _212 = ((((g_vOverriddenAspectRatioUVScale.x * _19) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
        _213 = (((g_vOverriddenAspectRatioUVScale.y * _20) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
        _227 = saturate(exp2(log2(saturate(1.0f - sqrt((_212 * _212) + (_213 * _213))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
        _232 = (_227 * _201);
        _233 = (_227 * _202);
        _234 = (_227 * _203);
      } else {
        _232 = _201;
        _233 = _202;
        _234 = _203;
      }
      _237 = (g_bEnableHDRLUT == 0);
      if (!(_237 || (!_163))) {
        _253 = exp2(log2(saturate(_232 * 0.00800000037997961f)) * 0.1593017578125f);
        _254 = exp2(log2(saturate(_233 * 0.00800000037997961f)) * 0.1593017578125f);
        _255 = exp2(log2(saturate(_234 * 0.00800000037997961f)) * 0.1593017578125f);
        _283 = saturate(exp2(log2(((_253 * 18.8515625f) + 0.8359375f) / ((_253 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
        _284 = saturate(exp2(log2(((_254 * 18.8515625f) + 0.8359375f) / ((_254 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
        _285 = saturate(exp2(log2(((_255 * 18.8515625f) + 0.8359375f) / ((_255 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
        _289 = int(floor(_283));
        _290 = int(floor(_284));
        _291 = int(floor(_285));
        _295 = _283 - float((int)(_289));
        _296 = _284 - float((int)(_290));
        _297 = _285 - float((int)(_291));
        _302 = ((int)(uint)((int)(_297 > _295))) + ((int)(uint)((int)(_296 > _295)));
        _307 = ((int)(uint)((int)(_297 > _296))) + ((int)(uint)((int)(_295 >= _296)));
        _312 = ((int)(uint)((int)(_295 >= _297))) + ((int)(uint)((int)(_296 >= _297)));
        _313 = (_302 == 0);
        _314 = (_307 == 0);
        _315 = (_312 == 0);
        _333 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_291), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_289), (int)(0))), (int)(47))), min((int)(max((int)(_290), (int)(0))), (int)(47)), 0));
        _348 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_315))) + _291))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_313))) + _289))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_314))) + _290))), (int)(0))), (int)(47)), 0));
        _363 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_312 < (uint)2)))) + _291))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_302 < (uint)2)))) + _289))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_307 < (uint)2)))) + _290))), (int)(0))), (int)(47)), 0));
        _378 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_291 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_289 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_290 + 1u))), (int)(0))), (int)(47)), 0));
        _385 = dot(float3(_295, _296, _297), float3(((float)((bool)_313)), ((float)((bool)_314)), ((float)((bool)_315))));
        _392 = dot(float3(_295, _296, _297), float3(((float)((bool)(uint)(_302 == 2))), ((float)((bool)(uint)(_307 == 2))), ((float)((bool)(uint)(_312 == 2)))));
        _396 = (((_296 + _295) + _297) - _385) - _392;
        _397 = 1.0f - _385;
        _401 = _385 - _396;
        _405 = _396 - _392;
        _414 = (((_392 * _378.x) + (_397 * _333.x)) + (_401 * _348.x)) + (_405 * _363.x);
        _417 = (((_392 * _378.y) + (_397 * _333.y)) + (_401 * _348.y)) + (_405 * _363.y);
        _420 = (((_392 * _378.z) + (_397 * _333.z)) + (_401 * _348.z)) + (_405 * _363.z);
        _422 = mad(0.21580375730991364f, _420, mad(0.3963377773761749f, _417, _414));
        _424 = mad(-0.0638541728258133f, _420, mad(-0.10556134581565857f, _417, _414));
        _426 = mad(-1.2914855480194092f, _420, mad(-0.08948417752981186f, _417, _414));
        _430 = (_422 * _422) * _422;
        _431 = (_424 * _424) * _424;
        _432 = (_426 * _426) * _426;
        _435 = mad(0.23096993565559387f, _432, mad(-3.307711601257324f, _431, (_430 * 4.076741695404053f)));
        _438 = mad(-0.34131938219070435f, _432, mad(2.609757423400879f, _431, (_430 * -1.2684379816055298f)));
        _441 = mad(1.7076146602630615f, _432, mad(-0.7034186124801636f, _431, (_430 * -0.004196086432784796f)));
        _443 = dot(float3(_435, _438, _441), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _454 = (lerp(_443, _435, g_fTonemapSaturation));
        _455 = (lerp(_443, _438, g_fTonemapSaturation));
        _456 = (lerp(_443, _441, g_fTonemapSaturation));
      } else {
        _454 = _232;
        _455 = _233;
        _456 = _234;
      }
      if (_161) {
        do {
          _1012 = _454;
          _1013 = _455;
          _1014 = _456;
          if (!(g_iTonemapper == 0)) {
            if (g_iTonemapper == 2) {
#if 1
              if (TONE_MAP_TYPE == 0.f) {
                _462 = max(_454, 0.0f);
                _463 = max(_455, 0.0f);
                _464 = max(_456, 0.0f);
              } else {
                _462 = _454;
                _463 = _455;
                _464 = _456;
              }
              float3 agx_color = ApplyRemedyAgX(
                  _462, _463, _464, _172,
                  g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
                  g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
                  g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
                  g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
                  g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
                  g_fAgxHDRRatio, g_fAgxHDRMidGrey,
                  g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
                  SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
              _1012 = agx_color.x;
              _1013 = agx_color.y;
              _1014 = agx_color.z;
#else
              _462 = max(_454, 0.0f);
              _463 = max(_455, 0.0f);
              _464 = max(_456, 0.0f);
              _511 = g_fAgxMaxEV - g_fAgxMinEV;
              _515 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _464, mad(g_vAgxInsetRow0.y, _463, (g_vAgxInsetRow0.x * _462))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _511);
              _516 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _464, mad(g_vAgxInsetRow1.y, _463, (g_vAgxInsetRow1.x * _462))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _511);
              _517 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _464, mad(g_vAgxInsetRow2.y, _463, (g_vAgxInsetRow2.x * _462))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _511);
              _526 = (g_fAgxContrastSlope * (_515 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _527 = 1.0f / g_fAgxShoulderPower;
              _544 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
              _546 = _544 * (0.6060606241226196f - _515);
              _547 = 1.0f / g_fAgxToePower;
              _566 = -0.0f - g_fAgxToePrecalcConstant;
              _569 = select((_515 >= 0.6060606241226196f), ((_526 / exp2(log2((float((int)(((int)(uint)((int)(_526 > 0.0f))) - ((int)(uint)((int)(_526 < 0.0f))))) * exp2(log2(abs(_526)) * g_fAgxShoulderPower)) + 1.0f) * _527)) * g_fAgxShoulderPrecalcConstant), ((_546 / exp2(log2((float((int)(((int)(uint)((int)(_546 > 0.0f))) - ((int)(uint)((int)(_546 < 0.0f))))) * exp2(log2(abs(_546)) * g_fAgxToePower)) + 1.0f) * _547)) * _566)) + 0.4894371032714844f;
              _572 = (g_fAgxContrastSlope * (_516 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _590 = _544 * (0.6060606241226196f - _516);
              _611 = select((_516 >= 0.6060606241226196f), ((_572 / exp2(log2((float((int)(((int)(uint)((int)(_572 > 0.0f))) - ((int)(uint)((int)(_572 < 0.0f))))) * exp2(log2(abs(_572)) * g_fAgxShoulderPower)) + 1.0f) * _527)) * g_fAgxShoulderPrecalcConstant), ((_590 / exp2(log2((exp2(log2(abs(_590)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_590 > 0.0f))) - ((int)(uint)((int)(_590 < 0.0f)))))) + 1.0f) * _547)) * _566)) + 0.4894371032714844f;
              _614 = (g_fAgxContrastSlope * (_517 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _632 = _544 * (0.6060606241226196f - _517);
              _653 = select((_517 >= 0.6060606241226196f), ((_614 / exp2(log2((float((int)(((int)(uint)((int)(_614 > 0.0f))) - ((int)(uint)((int)(_614 < 0.0f))))) * exp2(log2(abs(_614)) * g_fAgxShoulderPower)) + 1.0f) * _527)) * g_fAgxShoulderPrecalcConstant), ((_632 / exp2(log2((exp2(log2(abs(_632)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_632 > 0.0f))) - ((int)(uint)((int)(_632 < 0.0f)))))) + 1.0f) * _547)) * _566)) + 0.4894371032714844f;
              _672 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _653, mad(g_vAgxOutsetRow0.y, _611, (_569 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
              _673 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _653, mad(g_vAgxOutsetRow1.y, _611, (_569 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
              _674 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _653, mad(g_vAgxOutsetRow2.y, _611, (_569 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
              do {
                _792 = _672;
                _793 = _673;
                _794 = _674;
                if (g_fAgxHDRRatio > 1.0f) {
                  if (!(!(max(_672, max(_673, _674)) >= g_fAgxHDRMidGrey))) {
                    _685 = log2(1.0f / g_fAgxHDRMidGrey);
                    _686 = _685 + 20.0f;
                    _687 = log2(g_fAgxHDRRatio);
                    _706 = (min(max(log2(max(_672, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _685) + 20.0f) / _686;
                    _707 = (min(max(log2(max(_673, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _685) + 20.0f) / _686;
                    _708 = (min(max(log2(max(_674, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _685) + 20.0f) / _686;
                    _709 = 20.0f / _686;
                    _713 = max(_706, max(_707, _708));
                    _718 = ((_713 - _709) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _735 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_709 - _713);
                    _757 = select((_713 >= _709), ((_718 / exp2(log2((float((int)(((int)(uint)((int)(_718 > 0.0f))) - ((int)(uint)((int)(_718 < 0.0f))))) * exp2(log2(abs(_718)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_735 / exp2(log2((float((int)(((int)(uint)((int)(_735 > 0.0f))) - ((int)(uint)((int)(_735 < 0.0f))))) * exp2(log2(abs(_735)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _687) / _686);
                    _763 = exp2((((_757 - _713) * _686) + _687) * g_fAgxHDRSaturation);
                    _792 = (saturate(exp2(((_757 + (_763 * (_706 - _713))) * _686) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _793 = (saturate(exp2(((_757 + (_763 * (_707 - _713))) * _686) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _794 = (saturate(exp2(((_757 + (_763 * (_708 - _713))) * _686) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                  } else {
                    _792 = _672;
                    _793 = _673;
                    _794 = _674;
                  }
                }
                _1012 = (mad(-0.07283977419137955f, _794, mad(-0.5876564383506775f, _793, (_792 * 1.6604962348937988f))) * _172);
                _1013 = (mad(-0.008348013274371624f, _794, mad(1.1328951120376587f, _793, (_792 * -0.1245470941066742f))) * _172);
                _1014 = (mad(1.118751049041748f, _794, mad(-0.10059737414121628f, _793, (_792 * -0.018153680488467216f))) * _172);
              } while (false);
#endif
              if (_loop_break_1 && !_loop_break_0) break;
            } else {
              _462 = max(_454, 0.0f);
              _463 = max(_455, 0.0f);
              _464 = max(_456, 0.0f);
              _808 = dot(float3(_462, _463, _464), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
              do {
                _818 = _462;
                _819 = _463;
                _820 = _464;
                if (!(_808 == 0.0f)) {
                  _813 = max(dot(float3(_454, _455, _456), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _808;
                  _818 = (_813 * _462);
                  _819 = (_813 * _463);
                  _820 = (_813 * _464);
                }
                _826 = max(max(_818, max(_819, _820)), 0.0f);
                _828 = 1.0f / max(_826, 1.1754943508222875e-38f);
                _834 = (pow(_826, g_vTonemapGTParams.x));
                _842 = _834 / (((pow(_834, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
                _856 = exp2(log2(_828 * _818) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
                _857 = exp2(log2(_828 * _819) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
                _858 = exp2(log2(_828 * _820) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
                _863 = log2(_842);
                _891 = saturate(exp2(log2((exp2(_863 * g_vTonemapCrosstalk.x) * (1.0f - _856)) + _856) * g_vTonemapCrosstalkSaturation.x) * _842);
                _892 = saturate(exp2(log2((exp2(_863 * g_vTonemapCrosstalk.y) * (1.0f - _857)) + _857) * g_vTonemapCrosstalkSaturation.y) * _842);
                _893 = saturate(exp2(log2((exp2(_863 * g_vTonemapCrosstalk.z) * (1.0f - _858)) + _858) * g_vTonemapCrosstalkSaturation.z) * _842);
                if (_237) {
                  do {
                    _1005 = _891;
                    _1006 = _892;
                    _1007 = _893;
                    if (_163) {
                      do {
                        [branch]
                        if (!(_891 <= 0.0031308000907301903f)) {
                          _906 = (((pow(_891, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _906 = (_891 * 12.920000076293945f);
                        }
                        do {
                          [branch]
                          if (!(_892 <= 0.0031308000907301903f)) {
                            _917 = (((pow(_892, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          } else {
                            _917 = (_892 * 12.920000076293945f);
                          }
                          do {
                            [branch]
                            if (!(_893 <= 0.0031308000907301903f)) {
                              _928 = (((pow(_893, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            } else {
                              _928 = (_893 * 12.920000076293945f);
                            }
                            _935 = (saturate(_917) * 0.96875f) + 0.015625f;
                            _937 = max((saturate(_928) * 31.0f), 0.0f);
                            _938 = floor(_937);
                            _939 = _937 - _938;
                            _941 = (((saturate(_906) * 0.96875f) + 0.015625f) + _938) * 0.03125f;
                            _943 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_941, _935), 0.0f);
                            _947 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_941 + 0.03125f), _935), 0.0f);
                            _957 = ((_947.x - _943.x) * _939) + _943.x;
                            _958 = ((_947.y - _943.y) * _939) + _943.y;
                            _959 = ((_947.z - _943.z) * _939) + _943.z;
                            do {
                              [branch]
                              if (!(_957 <= 0.040449999272823334f)) {
                                _970 = exp2(log2((_957 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _970 = (_957 * 0.07739938050508499f);
                              }
                              do {
                                [branch]
                                if (!(_958 <= 0.040449999272823334f)) {
                                  _981 = exp2(log2((_958 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                } else {
                                  _981 = (_958 * 0.07739938050508499f);
                                }
                                do {
                                  [branch]
                                  if (!(_959 <= 0.040449999272823334f)) {
                                    _992 = exp2(log2((_959 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                  } else {
                                    _992 = (_959 * 0.07739938050508499f);
                                  }
                                  _994 = dot(float3(_970, _981, _992), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                                  _1005 = (lerp(_994, _970, g_fTonemapSaturation));
                                  _1006 = (lerp(_994, _981, g_fTonemapSaturation));
                                  _1007 = (lerp(_994, _992, g_fTonemapSaturation));
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
                    _1012 = (_1005 * _172);
                    _1013 = (_1006 * _172);
                    _1014 = (_1007 * _172);
                  } while (false);
                  if (_loop_break_1 && !_loop_break_0) break;
                } else {
                  _1012 = _891;
                  _1013 = _892;
                  _1014 = _893;
                }
              } while (false);
              if (_loop_break_1 && !_loop_break_0) break;
            }
          }
          _1023 = (_1012 * g_fTonemapBrightness);
          _1024 = (_1013 * g_fTonemapBrightness);
          _1025 = (_1014 * g_fTonemapBrightness);
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _1023 = (_454 * _172);
        _1024 = (_455 * _172);
        _1025 = (_456 * _172);
      }
      if (!(g_bApplyFilmGrain == 0)) {
        _1037 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
        _1044 = (_1037.x * 2.0f) + -1.0f;
        _1045 = (_1037.y * 2.0f) + -1.0f;
        _1046 = (_1037.z * 2.0f) + -1.0f;
        if (!(_161)) {
          _1049 = _1023 / _172;
          _1050 = _1024 / _172;
          _1051 = _1025 / _172;
          _1055 = 1.0f - sqrt(max(dot(float3(_1049, _1050, _1051), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
          _1060 = g_fFilmGrainIntensity * (_172 * 5.0f);
          _1123 = ((((_1060 * _1044) * saturate(_1049)) * _1055) + _1023);
          _1124 = ((((_1060 * _1045) * _1055) * saturate(_1050)) + _1024);
          _1125 = ((((_1060 * _1046) * _1055) * saturate(_1051)) + _1025);
        } else {
          _1074 = saturate(_1023);
          _1075 = saturate(_1024);
          _1076 = saturate(_1025);
          _1081 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_1074, max(_1075, _1076))));
          _1082 = _1081 * _1074;
          _1083 = _1081 * _1075;
          _1084 = _1081 * _1076;
          _1092 = ((1.0f - sqrt(dot(float3(_1082, _1083, _1084), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
          _1099 = ((_1092 * _1044) * min(1.0f, _1082)) + _1082;
          _1100 = ((_1092 * _1045) * min(1.0f, _1083)) + _1083;
          _1101 = ((_1092 * _1046) * min(1.0f, _1084)) + _1084;
          _1105 = 1.0f / (max(_1099, max(_1100, _1101)) + 1.0f);
          _1112 = 1.0f / (max(_1082, max(_1083, _1084)) + 1.0f);
          _1123 = (((_1099 * _1105) + _1023) - (_1112 * _1082));
          _1124 = (((_1100 * _1105) + _1024) - (_1112 * _1083));
          _1125 = (((_1101 * _1105) + _1025) - (_1112 * _1084));
        }
      } else {
        _1123 = _1023;
        _1124 = _1024;
        _1125 = _1025;
      }
      if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
        _1132 = (g_bHDR == 0);
        do {
          _1159 = _1123;
          _1160 = _1124;
          _1161 = _1125;
          if (!(_1132 || (g_bHDR_scRGB == 0))) {
            _1146 = max(mad(0.043306104838848114f, _1125, mad(0.329291969537735f, _1124, (_1123 * 0.6274019479751587f))), 0.0f);
            _1147 = max(mad(0.0113602289929986f, _1125, mad(0.9195442795753479f, _1124, (_1123 * 0.06909549236297607f))), 0.0f);
            _1148 = max(mad(0.895578145980835f, _1125, mad(0.08802816271781921f, _1124, (_1123 * 0.016393709927797318f))), 0.0f);
            _1159 = mad(-0.07283977419137955f, _1148, mad(-0.5876564383506775f, _1147, (_1146 * 1.6604962348937988f)));
            _1160 = mad(-0.008348013274371624f, _1148, mad(1.1328951120376587f, _1147, (_1146 * -0.1245470941066742f)));
            _1161 = mad(1.118751049041748f, _1148, mad(-0.10059737414121628f, _1147, (_1146 * -0.018153680488467216f)));
          }
          if ((g_bHDR_scRGB == 0) && (!_1132)) {
            _1177 = mad(0.043306104838848114f, _1161, mad(0.329291969537735f, _1160, (_1159 * 0.6274019479751587f)));
            _1178 = mad(0.0113602289929986f, _1161, mad(0.9195442795753479f, _1160, (_1159 * 0.06909549236297607f)));
            _1179 = mad(0.895578145980835f, _1161, mad(0.08802816271781921f, _1160, (_1159 * 0.016393709927797318f)));
          } else {
            _1177 = _1159;
            _1178 = _1160;
            _1179 = _1161;
          }
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _1177 = _1123;
        _1178 = _1124;
        _1179 = _1125;
      }
      SV_Target.x = _1177;
      SV_Target.y = _1178;
      SV_Target.z = _1179;
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
