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
  float _320;
  float _321;
  float _322;
  float _724;
  float _725;
  float _726;
  float _750;
  float _751;
  float _752;
  float _838;
  float _849;
  float _860;
  float _902;
  float _913;
  float _924;
  float _937;
  float _938;
  float _939;
  float _944;
  float _945;
  float _946;
  float _955;
  float _956;
  float _957;
  float _1055;
  float _1056;
  float _1057;
  float _1091;
  float _1092;
  float _1093;
  float _1109;
  float _1110;
  float _1111;
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
  float _285;
  float _286;
  float _287;
  float _289;
  float4 _291;
  float4 _295;
  float _305;
  float _306;
  float _307;
  float _309;
  float _328;
  float _329;
  float _330;
  float _377;
  float _381;
  float _382;
  float _383;
  float _392;
  float _393;
  float _410;
  float _412;
  float _413;
  float _432;
  float _435;
  float _438;
  float _456;
  float _477;
  float _480;
  float _498;
  float _519;
  float _538;
  float _539;
  float _540;
  float _551;
  float _552;
  float _565;
  float _566;
  float _567;
  float _574;
  float _577;
  float _582;
  float _597;
  float _600;
  float _619;
  float _625;
  float _642;
  float _666;
  float _683;
  float _740;
  float _745;
  float _758;
  float _760;
  float _766;
  float _774;
  float _788;
  float _789;
  float _790;
  float _795;
  float _823;
  float _824;
  float _825;
  float _867;
  float _869;
  float _870;
  float _871;
  float _873;
  float4 _875;
  float4 _879;
  float _889;
  float _890;
  float _891;
  float _926;
  float4 _969;
  float _976;
  float _977;
  float _978;
  float _981;
  float _982;
  float _983;
  float _987;
  float _992;
  float _1006;
  float _1007;
  float _1008;
  float _1013;
  float _1014;
  float _1015;
  float _1016;
  float _1024;
  float _1031;
  float _1032;
  float _1033;
  float _1037;
  float _1044;
  bool _1064;
  float _1078;
  float _1079;
  float _1080;
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
        _172 = g_fPaperWhite;
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
#if 1
        float3 graded_color = ApplyVanillaPQLUT(
            float3(_232, _233, _234), g_tBaseColorCorrectionMap, g_sLinearClamp_internal, g_fTonemapSaturation);
        _320 = graded_color.x;
        _321 = graded_color.y;
        _322 = graded_color.z;
#else
        _253 = exp2(log2(saturate(_232 * 0.00800000037997961f)) * 0.1593017578125f);
        _254 = exp2(log2(saturate(_233 * 0.00800000037997961f)) * 0.1593017578125f);
        _255 = exp2(log2(saturate(_234 * 0.00800000037997961f)) * 0.1593017578125f);
        _283 = (exp2(log2(((_254 * 18.8515625f) + 0.8359375f) / ((_254 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
        _285 = max((exp2(log2(((_255 * 18.8515625f) + 0.8359375f) / ((_255 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
        _286 = floor(_285);
        _287 = _285 - _286;
        _289 = (((exp2(log2(((_253 * 18.8515625f) + 0.8359375f) / ((_253 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _286) * 0.02083333395421505f;
        _291 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_289, _283), 0.0f);
        _295 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_289 + 0.02083333395421505f), _283), 0.0f);
        _305 = ((_295.x - _291.x) * _287) + _291.x;
        _306 = ((_295.y - _291.y) * _287) + _291.y;
        _307 = ((_295.z - _291.z) * _287) + _291.z;
        _309 = dot(float3(_305, _306, _307), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _320 = (lerp(_309, _305, g_fTonemapSaturation));
        _321 = (lerp(_309, _306, g_fTonemapSaturation));
        _322 = (lerp(_309, _307, g_fTonemapSaturation));
#endif
      } else {
        _320 = _232;
        _321 = _233;
        _322 = _234;
      }
      if (_161) {
        do {
          _944 = _320;
          _945 = _321;
          _946 = _322;
          if (!(g_iTonemapper == 0)) {
            _328 = max(_320, 0.0f);
            _329 = max(_321, 0.0f);
            _330 = max(_322, 0.0f);
            if (g_iTonemapper == 2) {
#if 1
              float3 agx_color = ApplyRemedyAgX(
                  _328, _329, _330, _172,
                  g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
                  g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
                  g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
                  g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
                  g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
                  g_fAgxHDRRatio, g_fAgxHDRMidGrey,
                  g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
                  SV_Position.xy * g_vInvOutputRes);
              _944 = agx_color.x;
              _945 = agx_color.y;
              _946 = agx_color.z;
#else
              _377 = g_fAgxMaxEV - g_fAgxMinEV;
              _381 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _330, mad(g_vAgxInsetRow0.y, _329, (g_vAgxInsetRow0.x * _328))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _377);
              _382 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _330, mad(g_vAgxInsetRow1.y, _329, (g_vAgxInsetRow1.x * _328))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _377);
              _383 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _330, mad(g_vAgxInsetRow2.y, _329, (g_vAgxInsetRow2.x * _328))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _377);
              _392 = (g_fAgxContrastSlope * (_381 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _393 = 1.0f / g_fAgxShoulderPower;
              _410 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
              _412 = _410 * (0.6060606241226196f - _381);
              _413 = 1.0f / g_fAgxToePower;
              _432 = -0.0f - g_fAgxToePrecalcConstant;
              _435 = select((_381 >= 0.6060606241226196f), ((_392 / exp2(log2((float((int)(((int)(uint)((int)(_392 > 0.0f))) - ((int)(uint)((int)(_392 < 0.0f))))) * exp2(log2(abs(_392)) * g_fAgxShoulderPower)) + 1.0f) * _393)) * g_fAgxShoulderPrecalcConstant), ((_412 / exp2(log2((float((int)(((int)(uint)((int)(_412 > 0.0f))) - ((int)(uint)((int)(_412 < 0.0f))))) * exp2(log2(abs(_412)) * g_fAgxToePower)) + 1.0f) * _413)) * _432)) + 0.4894371032714844f;
              _438 = (g_fAgxContrastSlope * (_382 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _456 = _410 * (0.6060606241226196f - _382);
              _477 = select((_382 >= 0.6060606241226196f), ((_438 / exp2(log2((float((int)(((int)(uint)((int)(_438 > 0.0f))) - ((int)(uint)((int)(_438 < 0.0f))))) * exp2(log2(abs(_438)) * g_fAgxShoulderPower)) + 1.0f) * _393)) * g_fAgxShoulderPrecalcConstant), ((_456 / exp2(log2((exp2(log2(abs(_456)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_456 > 0.0f))) - ((int)(uint)((int)(_456 < 0.0f)))))) + 1.0f) * _413)) * _432)) + 0.4894371032714844f;
              _480 = (g_fAgxContrastSlope * (_383 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _498 = _410 * (0.6060606241226196f - _383);
              _519 = select((_383 >= 0.6060606241226196f), ((_480 / exp2(log2((float((int)(((int)(uint)((int)(_480 > 0.0f))) - ((int)(uint)((int)(_480 < 0.0f))))) * exp2(log2(abs(_480)) * g_fAgxShoulderPower)) + 1.0f) * _393)) * g_fAgxShoulderPrecalcConstant), ((_498 / exp2(log2((exp2(log2(abs(_498)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_498 > 0.0f))) - ((int)(uint)((int)(_498 < 0.0f)))))) + 1.0f) * _413)) * _432)) + 0.4894371032714844f;
              _538 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _519, mad(g_vAgxOutsetRow0.y, _477, (_435 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
              _539 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _519, mad(g_vAgxOutsetRow1.y, _477, (_435 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
              _540 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _519, mad(g_vAgxOutsetRow2.y, _477, (_435 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
              do {
                _724 = _538;
                _725 = _539;
                _726 = _540;
                if (g_fAgxHDRRatio > 1.0f) {
                  if (!(!(max(_538, max(_539, _540)) >= g_fAgxHDRMidGrey))) {
                    _551 = log2(1.0f / g_fAgxHDRMidGrey);
                    _552 = _551 + 20.0f;
                    _565 = min(max(log2(max(_538, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _551);
                    _566 = min(max(log2(max(_539, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _551);
                    _567 = min(max(log2(max(_540, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _551);
                    _574 = 20.0f / _552;
                    _577 = (20.0f - log2(g_fAgxHDRRatio)) / _552;
                    _582 = ((_565 / _552) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _597 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                    _600 = ((-0.0f - _565) / _552) * _597;
                    _619 = -0.0f - g_fAgxHDRToePrecalcConstant;
                    _625 = ((_566 / _552) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _642 = ((-0.0f - _566) / _552) * _597;
                    _666 = ((_567 / _552) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _683 = ((-0.0f - _567) / _552) * _597;
                    _724 = (saturate(exp2(((select((((_565 + 20.0f) / _552) >= _574), ((_582 / exp2(log2((float((int)(((int)(uint)((int)(_582 > 0.0f))) - ((int)(uint)((int)(_582 < 0.0f))))) * exp2(log2(abs(_582)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_600 / exp2(log2((float((int)(((int)(uint)((int)(_600 > 0.0f))) - ((int)(uint)((int)(_600 < 0.0f))))) * exp2(log2(abs(_600)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _619)) + _577) * _552) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _725 = (saturate(exp2(((select((((_566 + 20.0f) / _552) >= _574), ((_625 / exp2(log2((float((int)(((int)(uint)((int)(_625 > 0.0f))) - ((int)(uint)((int)(_625 < 0.0f))))) * exp2(log2(abs(_625)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_642 / exp2(log2((float((int)(((int)(uint)((int)(_642 > 0.0f))) - ((int)(uint)((int)(_642 < 0.0f))))) * exp2(log2(abs(_642)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _619)) + _577) * _552) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _726 = (saturate(exp2(((select((((_567 + 20.0f) / _552) >= _574), ((_666 / exp2(log2((float((int)(((int)(uint)((int)(_666 > 0.0f))) - ((int)(uint)((int)(_666 < 0.0f))))) * exp2(log2(abs(_666)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_683 / exp2(log2((float((int)(((int)(uint)((int)(_683 > 0.0f))) - ((int)(uint)((int)(_683 < 0.0f))))) * exp2(log2(abs(_683)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _619)) + _577) * _552) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                  } else {
                    _724 = _538;
                    _725 = _539;
                    _726 = _540;
                  }
                }
                _944 = (mad(-0.07283977419137955f, _726, mad(-0.5876564383506775f, _725, (_724 * 1.6604962348937988f))) * _172);
                _945 = (mad(-0.008348013274371624f, _726, mad(1.1328951120376587f, _725, (_724 * -0.1245470941066742f))) * _172);
                _946 = (mad(1.118751049041748f, _726, mad(-0.10059737414121628f, _725, (_724 * -0.018153680488467216f))) * _172);
              } while (false);
#endif
              if (_loop_break_1 && !_loop_break_0) break;
            } else {
              _740 = dot(float3(_328, _329, _330), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
              do {
                _750 = _328;
                _751 = _329;
                _752 = _330;
                if (!(_740 == 0.0f)) {
                  _745 = max(dot(float3(_320, _321, _322), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _740;
                  _750 = (_745 * _328);
                  _751 = (_745 * _329);
                  _752 = (_745 * _330);
                }
                _758 = max(max(_750, max(_751, _752)), 0.0f);
                _760 = 1.0f / max(_758, 1.1754943508222875e-38f);
                _766 = (pow(_758, g_vTonemapGTParams.x));
                _774 = _766 / (((pow(_766, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
                _788 = exp2(log2(_760 * _750) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
                _789 = exp2(log2(_760 * _751) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
                _790 = exp2(log2(_760 * _752) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
                _795 = log2(_774);
                _823 = saturate(exp2(log2((exp2(_795 * g_vTonemapCrosstalk.x) * (1.0f - _788)) + _788) * g_vTonemapCrosstalkSaturation.x) * _774);
                _824 = saturate(exp2(log2((exp2(_795 * g_vTonemapCrosstalk.y) * (1.0f - _789)) + _789) * g_vTonemapCrosstalkSaturation.y) * _774);
                _825 = saturate(exp2(log2((exp2(_795 * g_vTonemapCrosstalk.z) * (1.0f - _790)) + _790) * g_vTonemapCrosstalkSaturation.z) * _774);
                if (_237) {
                  do {
                    _937 = _823;
                    _938 = _824;
                    _939 = _825;
                    if (_163) {
                      do {
                        [branch]
                        if (!(_823 <= 0.0031308000907301903f)) {
                          _838 = (((pow(_823, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _838 = (_823 * 12.920000076293945f);
                        }
                        do {
                          [branch]
                          if (!(_824 <= 0.0031308000907301903f)) {
                            _849 = (((pow(_824, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          } else {
                            _849 = (_824 * 12.920000076293945f);
                          }
                          do {
                            [branch]
                            if (!(_825 <= 0.0031308000907301903f)) {
                              _860 = (((pow(_825, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            } else {
                              _860 = (_825 * 12.920000076293945f);
                            }
                            _867 = (saturate(_849) * 0.96875f) + 0.015625f;
                            _869 = max((saturate(_860) * 31.0f), 0.0f);
                            _870 = floor(_869);
                            _871 = _869 - _870;
                            _873 = (((saturate(_838) * 0.96875f) + 0.015625f) + _870) * 0.03125f;
                            _875 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_873, _867), 0.0f);
                            _879 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_873 + 0.03125f), _867), 0.0f);
                            _889 = ((_879.x - _875.x) * _871) + _875.x;
                            _890 = ((_879.y - _875.y) * _871) + _875.y;
                            _891 = ((_879.z - _875.z) * _871) + _875.z;
                            do {
                              [branch]
                              if (!(_889 <= 0.040449999272823334f)) {
                                _902 = exp2(log2((_889 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _902 = (_889 * 0.07739938050508499f);
                              }
                              do {
                                [branch]
                                if (!(_890 <= 0.040449999272823334f)) {
                                  _913 = exp2(log2((_890 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                } else {
                                  _913 = (_890 * 0.07739938050508499f);
                                }
                                do {
                                  [branch]
                                  if (!(_891 <= 0.040449999272823334f)) {
                                    _924 = exp2(log2((_891 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                  } else {
                                    _924 = (_891 * 0.07739938050508499f);
                                  }
                                  _926 = dot(float3(_902, _913, _924), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                                  _937 = (lerp(_926, _902, g_fTonemapSaturation));
                                  _938 = (lerp(_926, _913, g_fTonemapSaturation));
                                  _939 = (lerp(_926, _924, g_fTonemapSaturation));
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
                    _944 = (_937 * _172);
                    _945 = (_938 * _172);
                    _946 = (_939 * _172);
                  } while (false);
                  if (_loop_break_1 && !_loop_break_0) break;
                } else {
                  _944 = _823;
                  _945 = _824;
                  _946 = _825;
                }
              } while (false);
              if (_loop_break_1 && !_loop_break_0) break;
            }
          }
          _955 = (_944 * g_fTonemapBrightness);
          _956 = (_945 * g_fTonemapBrightness);
          _957 = (_946 * g_fTonemapBrightness);
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _955 = (_320 * _172);
        _956 = (_321 * _172);
        _957 = (_322 * _172);
      }
      if (!(g_bApplyFilmGrain == 0)) {
        _969 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
        _976 = (_969.x * 2.0f) + -1.0f;
        _977 = (_969.y * 2.0f) + -1.0f;
        _978 = (_969.z * 2.0f) + -1.0f;
        if (!(_161)) {
          _981 = _955 / _172;
          _982 = _956 / _172;
          _983 = _957 / _172;
          _987 = 1.0f - sqrt(max(dot(float3(_981, _982, _983), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
          _992 = g_fFilmGrainIntensity * (_172 * 5.0f);
          _1055 = ((((_992 * _976) * saturate(_981)) * _987) + _955);
          _1056 = ((((_992 * _977) * _987) * saturate(_982)) + _956);
          _1057 = ((((_992 * _978) * _987) * saturate(_983)) + _957);
        } else {
          _1006 = saturate(_955);
          _1007 = saturate(_956);
          _1008 = saturate(_957);
          _1013 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_1006, max(_1007, _1008))));
          _1014 = _1013 * _1006;
          _1015 = _1013 * _1007;
          _1016 = _1013 * _1008;
          _1024 = ((1.0f - sqrt(dot(float3(_1014, _1015, _1016), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
          _1031 = ((_1024 * _976) * min(1.0f, _1014)) + _1014;
          _1032 = ((_1024 * _977) * min(1.0f, _1015)) + _1015;
          _1033 = ((_1024 * _978) * min(1.0f, _1016)) + _1016;
          _1037 = 1.0f / (max(_1031, max(_1032, _1033)) + 1.0f);
          _1044 = 1.0f / (max(_1014, max(_1015, _1016)) + 1.0f);
          _1055 = (((_1031 * _1037) + _955) - (_1044 * _1014));
          _1056 = (((_1032 * _1037) + _956) - (_1044 * _1015));
          _1057 = (((_1033 * _1037) + _957) - (_1044 * _1016));
        }
      } else {
        _1055 = _955;
        _1056 = _956;
        _1057 = _957;
      }
      if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
        _1064 = (g_bHDR == 0);
        do {
          _1091 = _1055;
          _1092 = _1056;
          _1093 = _1057;
          if (!(_1064 || (g_bHDR_scRGB == 0))) {
            _1078 = max(mad(0.043306104838848114f, _1057, mad(0.329291969537735f, _1056, (_1055 * 0.6274019479751587f))), 0.0f);
            _1079 = max(mad(0.0113602289929986f, _1057, mad(0.9195442795753479f, _1056, (_1055 * 0.06909549236297607f))), 0.0f);
            _1080 = max(mad(0.895578145980835f, _1057, mad(0.08802816271781921f, _1056, (_1055 * 0.016393709927797318f))), 0.0f);
            _1091 = mad(-0.07283977419137955f, _1080, mad(-0.5876564383506775f, _1079, (_1078 * 1.6604962348937988f)));
            _1092 = mad(-0.008348013274371624f, _1080, mad(1.1328951120376587f, _1079, (_1078 * -0.1245470941066742f)));
            _1093 = mad(1.118751049041748f, _1080, mad(-0.10059737414121628f, _1079, (_1078 * -0.018153680488467216f)));
          }
          if ((g_bHDR_scRGB == 0) && (!_1064)) {
            _1109 = mad(0.043306104838848114f, _1093, mad(0.329291969537735f, _1092, (_1091 * 0.6274019479751587f)));
            _1110 = mad(0.0113602289929986f, _1093, mad(0.9195442795753479f, _1092, (_1091 * 0.06909549236297607f)));
            _1111 = mad(0.895578145980835f, _1093, mad(0.08802816271781921f, _1092, (_1091 * 0.016393709927797318f)));
          } else {
            _1109 = _1091;
            _1110 = _1092;
            _1111 = _1093;
          }
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _1109 = _1055;
        _1110 = _1056;
        _1111 = _1057;
      }
      SV_Target.x = _1109;
      SV_Target.y = _1110;
      SV_Target.z = _1111;
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
