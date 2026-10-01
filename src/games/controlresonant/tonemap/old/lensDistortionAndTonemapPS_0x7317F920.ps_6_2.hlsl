#include "../tonemap.hlsli"

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
  float _171;
  float _191;
  float _192;
  float _193;
  float _231;
  float _232;
  float _233;
  float _319;
  float _320;
  float _321;
  float _723;
  float _724;
  float _725;
  float _753;
  float _754;
  float _755;
  float _840;
  float _851;
  float _862;
  float _904;
  float _915;
  float _926;
  float _939;
  float _940;
  float _941;
  float _1100;
  float _1101;
  float _1102;
  float _1111;
  float _1112;
  float _1113;
  float _1161;
  float _1162;
  float _1163;
  float _1197;
  float _1198;
  float _1199;
  float _1215;
  float _1216;
  float _1217;
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
  float _284;
  float _285;
  float _286;
  float _288;
  float4 _290;
  float4 _294;
  float _304;
  float _305;
  float _306;
  float _308;
  float _352;
  float _353;
  float _354;
  float _376;
  float _380;
  float _381;
  float _382;
  float _391;
  float _392;
  float _409;
  float _411;
  float _412;
  float _431;
  float _434;
  float _437;
  float _455;
  float _476;
  float _479;
  float _497;
  float _518;
  float _537;
  float _538;
  float _539;
  float _550;
  float _551;
  float _564;
  float _565;
  float _566;
  float _573;
  float _576;
  float _581;
  float _596;
  float _599;
  float _618;
  float _624;
  float _641;
  float _665;
  float _682;
  float _740;
  float _741;
  float _742;
  float _743;
  float _748;
  float _761;
  float _763;
  float _769;
  float _777;
  float _791;
  float _792;
  float _793;
  float _798;
  float _826;
  float _827;
  float _828;
  float _869;
  float _871;
  float _872;
  float _873;
  float _875;
  float4 _877;
  float4 _881;
  float _891;
  float _892;
  float _893;
  float _928;
  float _950;
  float _955;
  float _957;
  float _958;
  float _959;
  float _960;
  float _970;
  float _974;
  float _1023;
  float _1024;
  float _1025;
  float _1030;
  float _1043;
  float _1044;
  float _1045;
  float _1077;
  float _1079;
  float _1081;
  float _1082;
  float _1095;
  float4 _1125;
  float _1135;
  float _1136;
  float _1137;
  float _1141;
  float _1147;
  bool _1170;
  float _1184;
  float _1185;
  float _1186;
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
        _282 = (exp2(log2(((_253 * 18.8515625f) + 0.8359375f) / ((_253 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
        _284 = max((exp2(log2(((_254 * 18.8515625f) + 0.8359375f) / ((_254 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
        _285 = floor(_284);
        _286 = _284 - _285;
        _288 = (((exp2(log2(((_252 * 18.8515625f) + 0.8359375f) / ((_252 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _285) * 0.02083333395421505f;
        _290 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_288, _282), 0.0f);
        _294 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_288 + 0.02083333395421505f), _282), 0.0f);
        _304 = ((_294.x - _290.x) * _286) + _290.x;
        _305 = ((_294.y - _290.y) * _286) + _290.y;
        _306 = ((_294.z - _290.z) * _286) + _290.z;
        _308 = dot(float3(_304, _305, _306), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _319 = (lerp(_308, _304, g_fTonemapSaturation));
        _320 = (lerp(_308, _305, g_fTonemapSaturation));
        _321 = (lerp(_308, _306, g_fTonemapSaturation));
      } else {
        _319 = _231;
        _320 = _232;
        _321 = _233;
      }
      if (!(_161)) {
        do {
          _1100 = _319;
          _1101 = _320;
          _1102 = _321;
          if (!(g_iTonemapper == 0)) {
            if (g_iTonemapper == 2) {
#if 1
              float3 agx_color = ApplyRemedyAgX(
                  _319, _320, _321, _171,
                  g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
                  g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
                  g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
                  g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
                  g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
                  g_fAgxHDRRatio, g_fAgxHDRMidGrey,
                  g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
                  SV_Position.xy * g_vInvOutputRes);
              _1100 = agx_color.x;
              _1101 = agx_color.y;
              _1102 = agx_color.z;
#else
              _352 = max(_319, 0.0f);
              _353 = max(_320, 0.0f);
              _354 = max(_321, 0.0f);
              _376 = g_fAgxMaxEV - g_fAgxMinEV;
              _380 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _354, mad(g_vAgxInsetRow0.y, _353, (_352 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _376);
              _381 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _354, mad(g_vAgxInsetRow1.y, _353, (_352 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _376);
              _382 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _354, mad(g_vAgxInsetRow2.y, _353, (_352 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _376);
              _391 = (g_fAgxContrastSlope * (_380 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _392 = 1.0f / g_fAgxShoulderPower;
              _409 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
              _411 = _409 * (0.6060606241226196f - _380);
              _412 = 1.0f / g_fAgxToePower;
              _431 = -0.0f - g_fAgxToePrecalcConstant;
              _434 = select((_380 >= 0.6060606241226196f), ((_391 / exp2(log2((float((int)(((int)(uint)((int)(_391 > 0.0f))) - ((int)(uint)((int)(_391 < 0.0f))))) * exp2(log2(abs(_391)) * g_fAgxShoulderPower)) + 1.0f) * _392)) * g_fAgxShoulderPrecalcConstant), ((_411 / exp2(log2((float((int)(((int)(uint)((int)(_411 > 0.0f))) - ((int)(uint)((int)(_411 < 0.0f))))) * exp2(log2(abs(_411)) * g_fAgxToePower)) + 1.0f) * _412)) * _431)) + 0.4894371032714844f;
              _437 = (g_fAgxContrastSlope * (_381 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _455 = _409 * (0.6060606241226196f - _381);
              _476 = select((_381 >= 0.6060606241226196f), ((_437 / exp2(log2((float((int)(((int)(uint)((int)(_437 > 0.0f))) - ((int)(uint)((int)(_437 < 0.0f))))) * exp2(log2(abs(_437)) * g_fAgxShoulderPower)) + 1.0f) * _392)) * g_fAgxShoulderPrecalcConstant), ((_455 / exp2(log2((exp2(log2(abs(_455)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_455 > 0.0f))) - ((int)(uint)((int)(_455 < 0.0f)))))) + 1.0f) * _412)) * _431)) + 0.4894371032714844f;
              _479 = (g_fAgxContrastSlope * (_382 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
              _497 = _409 * (0.6060606241226196f - _382);
              _518 = select((_382 >= 0.6060606241226196f), ((_479 / exp2(log2((float((int)(((int)(uint)((int)(_479 > 0.0f))) - ((int)(uint)((int)(_479 < 0.0f))))) * exp2(log2(abs(_479)) * g_fAgxShoulderPower)) + 1.0f) * _392)) * g_fAgxShoulderPrecalcConstant), ((_497 / exp2(log2((exp2(log2(abs(_497)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_497 > 0.0f))) - ((int)(uint)((int)(_497 < 0.0f)))))) + 1.0f) * _412)) * _431)) + 0.4894371032714844f;
              _537 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _518, mad(g_vAgxOutsetRow0.y, _476, (_434 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
              _538 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _518, mad(g_vAgxOutsetRow1.y, _476, (_434 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
              _539 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _518, mad(g_vAgxOutsetRow2.y, _476, (_434 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
              do {
                _723 = _537;
                _724 = _538;
                _725 = _539;
                if (g_fAgxHDRRatio > 1.0f) {
                  if (!(!(max(_537, max(_538, _539)) >= g_fAgxHDRMidGrey))) {
                    _550 = log2(1.0f / g_fAgxHDRMidGrey);
                    _551 = _550 + 20.0f;
                    _564 = min(max(log2(max(_537, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _550);
                    _565 = min(max(log2(max(_538, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _550);
                    _566 = min(max(log2(max(_539, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _550);
                    _573 = 20.0f / _551;
                    _576 = (20.0f - log2(g_fAgxHDRRatio)) / _551;
                    _581 = ((_564 / _551) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _596 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                    _599 = ((-0.0f - _564) / _551) * _596;
                    _618 = -0.0f - g_fAgxHDRToePrecalcConstant;
                    _624 = ((_565 / _551) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _641 = ((-0.0f - _565) / _551) * _596;
                    _665 = ((_566 / _551) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                    _682 = ((-0.0f - _566) / _551) * _596;
                    _723 = (saturate(exp2(((select((((_564 + 20.0f) / _551) >= _573), ((_581 / exp2(log2((float((int)(((int)(uint)((int)(_581 > 0.0f))) - ((int)(uint)((int)(_581 < 0.0f))))) * exp2(log2(abs(_581)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_599 / exp2(log2((float((int)(((int)(uint)((int)(_599 > 0.0f))) - ((int)(uint)((int)(_599 < 0.0f))))) * exp2(log2(abs(_599)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _618)) + _576) * _551) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _724 = (saturate(exp2(((select((((_565 + 20.0f) / _551) >= _573), ((_624 / exp2(log2((float((int)(((int)(uint)((int)(_624 > 0.0f))) - ((int)(uint)((int)(_624 < 0.0f))))) * exp2(log2(abs(_624)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_641 / exp2(log2((float((int)(((int)(uint)((int)(_641 > 0.0f))) - ((int)(uint)((int)(_641 < 0.0f))))) * exp2(log2(abs(_641)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _618)) + _576) * _551) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                    _725 = (saturate(exp2(((select((((_566 + 20.0f) / _551) >= _573), ((_665 / exp2(log2((float((int)(((int)(uint)((int)(_665 > 0.0f))) - ((int)(uint)((int)(_665 < 0.0f))))) * exp2(log2(abs(_665)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_682 / exp2(log2((float((int)(((int)(uint)((int)(_682 > 0.0f))) - ((int)(uint)((int)(_682 < 0.0f))))) * exp2(log2(abs(_682)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _618)) + _576) * _551) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                  } else {
                    _723 = _537;
                    _724 = _538;
                    _725 = _539;
                  }
                }
                _1100 = (mad(-0.07283977419137955f, _725, mad(-0.5876564383506775f, _724, (_723 * 1.6604962348937988f))) * _171);
                _1101 = (mad(-0.008348013274371624f, _725, mad(1.1328951120376587f, _724, (_723 * -0.1245470941066742f))) * _171);
                _1102 = (mad(1.118751049041748f, _725, mad(-0.10059737414121628f, _724, (_723 * -0.018153680488467216f))) * _171);
              } while (false);
#endif
              if (_loop_break_1 && !_loop_break_0) break;
            } else {
              if (_236) {
                _740 = max(_319, 0.0f);
                _741 = max(_320, 0.0f);
                _742 = max(_321, 0.0f);
                _743 = dot(float3(_740, _741, _742), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                do {
                  _753 = _740;
                  _754 = _741;
                  _755 = _742;
                  if (!(_743 == 0.0f)) {
                    _748 = max(dot(float3(_319, _320, _321), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _743;
                    _753 = (_748 * _740);
                    _754 = (_748 * _741);
                    _755 = (_748 * _742);
                  }
                  _761 = max(max(_753, max(_754, _755)), 0.0f);
                  _763 = 1.0f / max(_761, 1.1754943508222875e-38f);
                  _769 = (pow(_761, g_vTonemapGTParams.x));
                  _777 = _769 / (((pow(_769, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
                  _791 = exp2(log2(_763 * _753) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
                  _792 = exp2(log2(_763 * _754) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
                  _793 = exp2(log2(_763 * _755) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
                  _798 = log2(_777);
                  _826 = saturate(exp2(log2((exp2(_798 * g_vTonemapCrosstalk.x) * (1.0f - _791)) + _791) * g_vTonemapCrosstalkSaturation.x) * _777);
                  _827 = saturate(exp2(log2((exp2(_798 * g_vTonemapCrosstalk.y) * (1.0f - _792)) + _792) * g_vTonemapCrosstalkSaturation.y) * _777);
                  _828 = saturate(exp2(log2((exp2(_798 * g_vTonemapCrosstalk.z) * (1.0f - _793)) + _793) * g_vTonemapCrosstalkSaturation.z) * _777);
                  do {
                    _939 = _826;
                    _940 = _827;
                    _941 = _828;
                    if (_163) {
                      do {
                        [branch]
                        if (!(_826 <= 0.0031308000907301903f)) {
                          _840 = (((pow(_826, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _840 = (_826 * 12.920000076293945f);
                        }
                        do {
                          [branch]
                          if (!(_827 <= 0.0031308000907301903f)) {
                            _851 = (((pow(_827, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          } else {
                            _851 = (_827 * 12.920000076293945f);
                          }
                          do {
                            [branch]
                            if (!(_828 <= 0.0031308000907301903f)) {
                              _862 = (((pow(_828, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            } else {
                              _862 = (_828 * 12.920000076293945f);
                            }
                            _869 = (saturate(_851) * 0.96875f) + 0.015625f;
                            _871 = max((saturate(_862) * 31.0f), 0.0f);
                            _872 = floor(_871);
                            _873 = _871 - _872;
                            _875 = (((saturate(_840) * 0.96875f) + 0.015625f) + _872) * 0.03125f;
                            _877 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_875, _869), 0.0f);
                            _881 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_875 + 0.03125f), _869), 0.0f);
                            _891 = ((_881.x - _877.x) * _873) + _877.x;
                            _892 = ((_881.y - _877.y) * _873) + _877.y;
                            _893 = ((_881.z - _877.z) * _873) + _877.z;
                            do {
                              [branch]
                              if (!(_891 <= 0.040449999272823334f)) {
                                _904 = exp2(log2((_891 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _904 = (_891 * 0.07739938050508499f);
                              }
                              do {
                                [branch]
                                if (!(_892 <= 0.040449999272823334f)) {
                                  _915 = exp2(log2((_892 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                } else {
                                  _915 = (_892 * 0.07739938050508499f);
                                }
                                do {
                                  [branch]
                                  if (!(_893 <= 0.040449999272823334f)) {
                                    _926 = exp2(log2((_893 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                  } else {
                                    _926 = (_893 * 0.07739938050508499f);
                                  }
                                  _928 = dot(float3(_904, _915, _926), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                                  _939 = (lerp(_928, _904, g_fTonemapSaturation));
                                  _940 = (lerp(_928, _915, g_fTonemapSaturation));
                                  _941 = (lerp(_928, _926, g_fTonemapSaturation));
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
                    _1100 = (_939 * _171);
                    _1101 = (_940 * _171);
                    _1102 = (_941 * _171);
                  } while (false);
                  if (_loop_break_1 && !_loop_break_0) break;
                } while (false);
                if (_loop_break_1 && !_loop_break_0) break;
              } else {
                _950 = g_fMaxOutputNits * 0.012500000186264515f;
                _955 = max(abs(_319), max(abs(_320), abs(_321)));
                _957 = 1.0f / max(_955, 1.1754943508222875e-38f);
                _958 = _957 * _319;
                _959 = _957 * _320;
                _960 = _957 * _321;
                _970 = (_171 * 0.18000000715255737f) * exp2(log2((pow(_955, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
                _974 = dot(float3((_970 * _958), (_970 * _959), (_970 * _960)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                _1023 = exp2(log2(abs(_958)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_958 > 0.0f))) - ((int)(uint)((int)(_958 < 0.0f)))));
                _1024 = exp2(log2(abs(_959)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_959 > 0.0f))) - ((int)(uint)((int)(_959 < 0.0f)))));
                _1025 = exp2(log2(abs(_960)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_960 > 0.0f))) - ((int)(uint)((int)(_960 < 0.0f)))));
                _1030 = log2(saturate(select((_974 <= 0.0f), _974, ((1.0f - exp2(log2(exp2((_974 / _950) * -1.4426950216293335f)))) * _950)) / _950));
                _1043 = (exp2(_1030 * g_vTonemapCrosstalk.x) * (1.0f - _1023)) + _1023;
                _1044 = (exp2(_1030 * g_vTonemapCrosstalk.y) * (1.0f - _1024)) + _1024;
                _1045 = (exp2(_1030 * g_vTonemapCrosstalk.z) * (1.0f - _1025)) + _1025;
                _1077 = (float((int)(((int)(uint)((int)(_1043 > 0.0f))) - ((int)(uint)((int)(_1043 < 0.0f))))) * _970) * exp2(log2(abs(_1043)) * g_vTonemapCrosstalkSaturation.x);
                _1079 = (float((int)(((int)(uint)((int)(_1044 > 0.0f))) - ((int)(uint)((int)(_1044 < 0.0f))))) * _970) * exp2(log2(abs(_1044)) * g_vTonemapCrosstalkSaturation.y);
                _1081 = (float((int)(((int)(uint)((int)(_1045 > 0.0f))) - ((int)(uint)((int)(_1045 < 0.0f))))) * _970) * exp2(log2(abs(_1045)) * g_vTonemapCrosstalkSaturation.z);
                _1082 = dot(float3(_1077, _1079, _1081), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                _1095 = select((_1082 <= 0.0f), _1082, ((1.0f - exp2(log2(exp2((_1082 / _950) * -1.4426950216293335f)))) * _950)) * select((!(_1082 == 0.0f)), (1.0f / _1082), 0.0f);
                _1100 = (_1095 * _1077);
                _1101 = (_1095 * _1079);
                _1102 = (_1095 * _1081);
              }
            }
          }
          _1111 = (_1100 * g_fTonemapBrightness);
          _1112 = (_1101 * g_fTonemapBrightness);
          _1113 = (_1102 * g_fTonemapBrightness);
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _1111 = (_319 * _171);
        _1112 = (_320 * _171);
        _1113 = (_321 * _171);
      }
      if (!(g_bApplyFilmGrain == 0)) {
        _1125 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
        _1135 = _1111 / _171;
        _1136 = _1112 / _171;
        _1137 = _1113 / _171;
        _1141 = 1.0f - sqrt(max(dot(float3(_1135, _1136, _1137), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
        _1147 = g_fFilmGrainIntensity * (_171 * 5.0f);
        _1161 = ((((_1147 * ((_1125.x * 2.0f) + -1.0f)) * saturate(_1135)) * _1141) + _1111);
        _1162 = ((((_1147 * ((_1125.y * 2.0f) + -1.0f)) * _1141) * saturate(_1136)) + _1112);
        _1163 = ((((_1147 * ((_1125.z * 2.0f) + -1.0f)) * _1141) * saturate(_1137)) + _1113);
      } else {
        _1161 = _1111;
        _1162 = _1112;
        _1163 = _1113;
      }
      if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
        _1170 = (g_bHDR == 0);
        do {
          _1197 = _1161;
          _1198 = _1162;
          _1199 = _1163;
          if (!(_1170 || (g_bHDR_scRGB == 0))) {
            _1184 = max(mad(0.043306104838848114f, _1163, mad(0.329291969537735f, _1162, (_1161 * 0.6274019479751587f))), 0.0f);
            _1185 = max(mad(0.0113602289929986f, _1163, mad(0.9195442795753479f, _1162, (_1161 * 0.06909549236297607f))), 0.0f);
            _1186 = max(mad(0.895578145980835f, _1163, mad(0.08802816271781921f, _1162, (_1161 * 0.016393709927797318f))), 0.0f);
            _1197 = mad(-0.07283977419137955f, _1186, mad(-0.5876564383506775f, _1185, (_1184 * 1.6604962348937988f)));
            _1198 = mad(-0.008348013274371624f, _1186, mad(1.1328951120376587f, _1185, (_1184 * -0.1245470941066742f)));
            _1199 = mad(1.118751049041748f, _1186, mad(-0.10059737414121628f, _1185, (_1184 * -0.018153680488467216f)));
          }
          if ((g_bHDR_scRGB == 0) && (!_1170)) {
            _1215 = mad(0.043306104838848114f, _1199, mad(0.329291969537735f, _1198, (_1197 * 0.6274019479751587f)));
            _1216 = mad(0.0113602289929986f, _1199, mad(0.9195442795753479f, _1198, (_1197 * 0.06909549236297607f)));
            _1217 = mad(0.895578145980835f, _1199, mad(0.08802816271781921f, _1198, (_1197 * 0.016393709927797318f)));
          } else {
            _1215 = _1197;
            _1216 = _1198;
            _1217 = _1199;
          }
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _1215 = _1161;
        _1216 = _1162;
        _1217 = _1163;
      }
      SV_Target.x = _1215;
      SV_Target.y = _1216;
      SV_Target.z = _1217;
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
