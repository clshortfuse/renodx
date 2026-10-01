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

cbuffer postprocess : register(b6) {
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
  float _18;
  float _19;
  float _29;
  float _30;
  float _60;
  float _61;
  float _84;
  float _104;
  float _105;
  float _106;
  float _144;
  float _145;
  float _146;
  float _366;
  float _367;
  float _368;
  float _704;
  float _705;
  float _706;
  float _734;
  float _735;
  float _736;
  float _821;
  float _832;
  float _843;
  float _885;
  float _896;
  float _907;
  float _920;
  float _921;
  float _922;
  float _1081;
  float _1082;
  float _1083;
  float _1092;
  float _1093;
  float _1094;
  float _1142;
  float _1143;
  float _1144;
  float _1178;
  float _1179;
  float _1180;
  float _1196;
  float _1197;
  float _1198;
  float _41;
  float _45;
  float _46;
  float _50;
  float _54;
  float4 _68;
  bool _74;
  bool _76;
  float _108;
  float _112;
  float _113;
  float _114;
  float _115;
  float _124;
  float _125;
  float _139;
  bool _149;
  float _165;
  float _166;
  float _167;
  float _195;
  float _196;
  float _197;
  int _201;
  int _202;
  int _203;
  float _207;
  float _208;
  float _209;
  int _214;
  int _219;
  int _224;
  bool _225;
  bool _226;
  bool _227;
  float4 _245;
  float4 _260;
  float4 _275;
  float4 _290;
  float _297;
  float _304;
  float _308;
  float _309;
  float _313;
  float _317;
  float _326;
  float _329;
  float _332;
  float _334;
  float _336;
  float _338;
  float _342;
  float _343;
  float _344;
  float _347;
  float _350;
  float _353;
  float _355;
  float _399;
  float _400;
  float _401;
  float _423;
  float _427;
  float _428;
  float _429;
  float _438;
  float _439;
  float _456;
  float _458;
  float _459;
  float _478;
  float _481;
  float _484;
  float _502;
  float _523;
  float _526;
  float _544;
  float _565;
  float _584;
  float _585;
  float _586;
  float _597;
  float _598;
  float _599;
  float _618;
  float _619;
  float _620;
  float _621;
  float _625;
  float _630;
  float _647;
  float _669;
  float _675;
  float _721;
  float _722;
  float _723;
  float _724;
  float _729;
  float _742;
  float _744;
  float _750;
  float _758;
  float _772;
  float _773;
  float _774;
  float _779;
  float _807;
  float _808;
  float _809;
  float _850;
  float _852;
  float _853;
  float _854;
  float _856;
  float4 _858;
  float4 _862;
  float _872;
  float _873;
  float _874;
  float _909;
  float _931;
  float _936;
  float _938;
  float _939;
  float _940;
  float _941;
  float _951;
  float _955;
  float _1004;
  float _1005;
  float _1006;
  float _1011;
  float _1024;
  float _1025;
  float _1026;
  float _1058;
  float _1060;
  float _1062;
  float _1063;
  float _1076;
  float4 _1106;
  float _1116;
  float _1117;
  float _1118;
  float _1122;
  float _1128;
  bool _1151;
  float _1165;
  float _1166;
  float _1167;
  _18 = g_vInvOutputRes.x * SV_Position.x;
  _19 = g_vInvOutputRes.y * SV_Position.y;
  _29 = ((_18 * 2.0f) + -1.0f) / g_vLensDistortionUVScale.x;
  _30 = ((_19 * 2.0f) + -1.0f) / g_vLensDistortionUVScale.y;
  if (!(!(g_vLensDistortionParams.w >= 0.0f))) {
    _41 = (g_vLensDistortionParams.x - ((_29 * _29) * g_vLensDistortionParams.y)) - ((_30 * _30) * g_vLensDistortionParams.z);
    _60 = (_29 / _41);
    _61 = (_30 / _41);
  } else {
    _45 = _29 * 0.5f;
    _46 = _30 * 0.5f;
    _50 = sqrt((_46 * _46) + (_45 * _45));
    _54 = (((_50 * _50) * g_vLensDistortionParams.w) + 1.0f) * _50;
    _60 = (_54 * (_29 / _50));
    _61 = (_54 * (_30 / _50));
  }
  _68 = g_tSource.Sample(g_sLinearClamp_internal, float2((((_60 * g_vLensDistortionUVScale.x) + 1.0f) * 0.5f), (((_61 * g_vLensDistortionUVScale.y) + 1.0f) * 0.5f)));
  _74 = (g_bPostProcessApplyTonemap == 0);
  _76 = (g_bPostProcessApplyColorGrade != 0);
  if (!(_74)) {
    _84 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  } else {
    _84 = 1.0f;
  }
  if (_76) {
    _104 = max(_68.x, 0.0f);
    _105 = max(_68.y, 0.0f);
    _106 = max(_68.z, 0.0f);
  } else {
    _104 = _68.x;
    _105 = _68.y;
    _106 = _68.z;
  }
  _108 = g_bBrightness[1];
  _112 = exp2(g_fExposureCompensationInEV100) * _108;
  _113 = _112 * _104;
  _114 = _112 * _105;
  _115 = _112 * _106;
  if (!(g_bApplyVignette == 0)) {
    _124 = ((((g_vOverriddenAspectRatioUVScale.x * _18) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _125 = (((g_vOverriddenAspectRatioUVScale.y * _19) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _139 = saturate(exp2(log2(saturate(1.0f - sqrt((_124 * _124) + (_125 * _125))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _144 = (_139 * _113);
    _145 = (_139 * _114);
    _146 = (_139 * _115);
  } else {
    _144 = _113;
    _145 = _114;
    _146 = _115;
  }
  _149 = (g_bEnableHDRLUT == 0);
  if (!(_149 || (!_76))) {
    _165 = exp2(log2(saturate(_144 * 0.00800000037997961f)) * 0.1593017578125f);
    _166 = exp2(log2(saturate(_145 * 0.00800000037997961f)) * 0.1593017578125f);
    _167 = exp2(log2(saturate(_146 * 0.00800000037997961f)) * 0.1593017578125f);
    _195 = saturate(exp2(log2(((_165 * 18.8515625f) + 0.8359375f) / ((_165 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _196 = saturate(exp2(log2(((_166 * 18.8515625f) + 0.8359375f) / ((_166 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _197 = saturate(exp2(log2(((_167 * 18.8515625f) + 0.8359375f) / ((_167 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _201 = int(floor(_195));
    _202 = int(floor(_196));
    _203 = int(floor(_197));
    _207 = _195 - float((int)(_201));
    _208 = _196 - float((int)(_202));
    _209 = _197 - float((int)(_203));
    _214 = ((int)(uint)((int)(_209 > _207))) + ((int)(uint)((int)(_208 > _207)));
    _219 = ((int)(uint)((int)(_209 > _208))) + ((int)(uint)((int)(_207 >= _208)));
    _224 = ((int)(uint)((int)(_207 >= _209))) + ((int)(uint)((int)(_208 >= _209)));
    _225 = (_214 == 0);
    _226 = (_219 == 0);
    _227 = (_224 == 0);
    _245 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_203), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_201), (int)(0))), (int)(47))), min((int)(max((int)(_202), (int)(0))), (int)(47)), 0));
    _260 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_227))) + _203))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_225))) + _201))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_226))) + _202))), (int)(0))), (int)(47)), 0));
    _275 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_224 < (uint)2)))) + _203))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_214 < (uint)2)))) + _201))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_219 < (uint)2)))) + _202))), (int)(0))), (int)(47)), 0));
    _290 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_203 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_201 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_202 + 1u))), (int)(0))), (int)(47)), 0));
    _297 = dot(float3(_207, _208, _209), float3(((float)((bool)_225)), ((float)((bool)_226)), ((float)((bool)_227))));
    _304 = dot(float3(_207, _208, _209), float3(((float)((bool)(uint)(_214 == 2))), ((float)((bool)(uint)(_219 == 2))), ((float)((bool)(uint)(_224 == 2)))));
    _308 = (((_208 + _207) + _209) - _297) - _304;
    _309 = 1.0f - _297;
    _313 = _297 - _308;
    _317 = _308 - _304;
    _326 = (((_304 * _290.x) + (_309 * _245.x)) + (_313 * _260.x)) + (_317 * _275.x);
    _329 = (((_304 * _290.y) + (_309 * _245.y)) + (_313 * _260.y)) + (_317 * _275.y);
    _332 = (((_304 * _290.z) + (_309 * _245.z)) + (_313 * _260.z)) + (_317 * _275.z);
    _334 = mad(0.21580375730991364f, _332, mad(0.3963377773761749f, _329, _326));
    _336 = mad(-0.0638541728258133f, _332, mad(-0.10556134581565857f, _329, _326));
    _338 = mad(-1.2914855480194092f, _332, mad(-0.08948417752981186f, _329, _326));
    _342 = (_334 * _334) * _334;
    _343 = (_336 * _336) * _336;
    _344 = (_338 * _338) * _338;
    _347 = mad(0.23096993565559387f, _344, mad(-3.307711601257324f, _343, (_342 * 4.076741695404053f)));
    _350 = mad(-0.34131938219070435f, _344, mad(2.609757423400879f, _343, (_342 * -1.2684379816055298f)));
    _353 = mad(1.7076146602630615f, _344, mad(-0.7034186124801636f, _343, (_342 * -0.004196086432784796f)));
    _355 = dot(float3(_347, _350, _353), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _366 = (lerp(_355, _347, g_fTonemapSaturation));
    _367 = (lerp(_355, _350, g_fTonemapSaturation));
    _368 = (lerp(_355, _353, g_fTonemapSaturation));
  } else {
    _366 = _144;
    _367 = _145;
    _368 = _146;
  }
  if (!(_74)) {
    do {
      _1081 = _366;
      _1082 = _367;
      _1083 = _368;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _366, _367, _368, _84,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
          _1081 = agx_color.x;
          _1082 = agx_color.y;
          _1083 = agx_color.z;
#else
          _399 = max(_366, 0.0f);
          _400 = max(_367, 0.0f);
          _401 = max(_368, 0.0f);
          _423 = g_fAgxMaxEV - g_fAgxMinEV;
          _427 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _401, mad(g_vAgxInsetRow0.y, _400, (_399 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _423);
          _428 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _401, mad(g_vAgxInsetRow1.y, _400, (_399 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _423);
          _429 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _401, mad(g_vAgxInsetRow2.y, _400, (_399 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _423);
          _438 = (g_fAgxContrastSlope * (_427 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _439 = 1.0f / g_fAgxShoulderPower;
          _456 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _458 = _456 * (0.6060606241226196f - _427);
          _459 = 1.0f / g_fAgxToePower;
          _478 = -0.0f - g_fAgxToePrecalcConstant;
          _481 = select((_427 >= 0.6060606241226196f), ((_438 / exp2(log2((float((int)(((int)(uint)((int)(_438 > 0.0f))) - ((int)(uint)((int)(_438 < 0.0f))))) * exp2(log2(abs(_438)) * g_fAgxShoulderPower)) + 1.0f) * _439)) * g_fAgxShoulderPrecalcConstant), ((_458 / exp2(log2((float((int)(((int)(uint)((int)(_458 > 0.0f))) - ((int)(uint)((int)(_458 < 0.0f))))) * exp2(log2(abs(_458)) * g_fAgxToePower)) + 1.0f) * _459)) * _478)) + 0.4894371032714844f;
          _484 = (g_fAgxContrastSlope * (_428 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _502 = _456 * (0.6060606241226196f - _428);
          _523 = select((_428 >= 0.6060606241226196f), ((_484 / exp2(log2((float((int)(((int)(uint)((int)(_484 > 0.0f))) - ((int)(uint)((int)(_484 < 0.0f))))) * exp2(log2(abs(_484)) * g_fAgxShoulderPower)) + 1.0f) * _439)) * g_fAgxShoulderPrecalcConstant), ((_502 / exp2(log2((exp2(log2(abs(_502)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_502 > 0.0f))) - ((int)(uint)((int)(_502 < 0.0f)))))) + 1.0f) * _459)) * _478)) + 0.4894371032714844f;
          _526 = (g_fAgxContrastSlope * (_429 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _544 = _456 * (0.6060606241226196f - _429);
          _565 = select((_429 >= 0.6060606241226196f), ((_526 / exp2(log2((float((int)(((int)(uint)((int)(_526 > 0.0f))) - ((int)(uint)((int)(_526 < 0.0f))))) * exp2(log2(abs(_526)) * g_fAgxShoulderPower)) + 1.0f) * _439)) * g_fAgxShoulderPrecalcConstant), ((_544 / exp2(log2((exp2(log2(abs(_544)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_544 > 0.0f))) - ((int)(uint)((int)(_544 < 0.0f)))))) + 1.0f) * _459)) * _478)) + 0.4894371032714844f;
          _584 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _565, mad(g_vAgxOutsetRow0.y, _523, (_481 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _585 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _565, mad(g_vAgxOutsetRow1.y, _523, (_481 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _586 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _565, mad(g_vAgxOutsetRow2.y, _523, (_481 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _704 = _584;
            _705 = _585;
            _706 = _586;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_584, max(_585, _586)) >= g_fAgxHDRMidGrey))) {
                _597 = log2(1.0f / g_fAgxHDRMidGrey);
                _598 = _597 + 20.0f;
                _599 = log2(g_fAgxHDRRatio);
                _618 = (min(max(log2(max(_584, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _597) + 20.0f) / _598;
                _619 = (min(max(log2(max(_585, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _597) + 20.0f) / _598;
                _620 = (min(max(log2(max(_586, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _597) + 20.0f) / _598;
                _621 = 20.0f / _598;
                _625 = max(_618, max(_619, _620));
                _630 = ((_625 - _621) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _647 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_621 - _625);
                _669 = select((_625 >= _621), ((_630 / exp2(log2((float((int)(((int)(uint)((int)(_630 > 0.0f))) - ((int)(uint)((int)(_630 < 0.0f))))) * exp2(log2(abs(_630)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_647 / exp2(log2((float((int)(((int)(uint)((int)(_647 > 0.0f))) - ((int)(uint)((int)(_647 < 0.0f))))) * exp2(log2(abs(_647)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _599) / _598);
                _675 = exp2((((_669 - _625) * _598) + _599) * g_fAgxHDRSaturation);
                _704 = (saturate(exp2(((_669 + (_675 * (_618 - _625))) * _598) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _705 = (saturate(exp2(((_669 + (_675 * (_619 - _625))) * _598) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _706 = (saturate(exp2(((_669 + (_675 * (_620 - _625))) * _598) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _704 = _584;
                _705 = _585;
                _706 = _586;
              }
            }
            _1081 = (mad(-0.07283977419137955f, _706, mad(-0.5876564383506775f, _705, (_704 * 1.6604962348937988f))) * _84);
            _1082 = (mad(-0.008348013274371624f, _706, mad(1.1328951120376587f, _705, (_704 * -0.1245470941066742f))) * _84);
            _1083 = (mad(1.118751049041748f, _706, mad(-0.10059737414121628f, _705, (_704 * -0.018153680488467216f))) * _84);
          } while (false);
#endif
        } else {
          if (_149) {
            _721 = max(_366, 0.0f);
            _722 = max(_367, 0.0f);
            _723 = max(_368, 0.0f);
            _724 = dot(float3(_721, _722, _723), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            do {
              _734 = _721;
              _735 = _722;
              _736 = _723;
              if (!(_724 == 0.0f)) {
                _729 = max(dot(float3(_366, _367, _368), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _724;
                _734 = (_729 * _721);
                _735 = (_729 * _722);
                _736 = (_729 * _723);
              }
              _742 = max(max(_734, max(_735, _736)), 0.0f);
              _744 = 1.0f / max(_742, 1.1754943508222875e-38f);
              _750 = (pow(_742, g_vTonemapGTParams.x));
              _758 = _750 / (((pow(_750, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
              _772 = exp2(log2(_744 * _734) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
              _773 = exp2(log2(_744 * _735) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
              _774 = exp2(log2(_744 * _736) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
              _779 = log2(_758);
              _807 = saturate(exp2(log2((exp2(_779 * g_vTonemapCrosstalk.x) * (1.0f - _772)) + _772) * g_vTonemapCrosstalkSaturation.x) * _758);
              _808 = saturate(exp2(log2((exp2(_779 * g_vTonemapCrosstalk.y) * (1.0f - _773)) + _773) * g_vTonemapCrosstalkSaturation.y) * _758);
              _809 = saturate(exp2(log2((exp2(_779 * g_vTonemapCrosstalk.z) * (1.0f - _774)) + _774) * g_vTonemapCrosstalkSaturation.z) * _758);
              do {
                _920 = _807;
                _921 = _808;
                _922 = _809;
                if (_76) {
                  do {
                    [branch]
                    if (!(_807 <= 0.0031308000907301903f)) {
                      _821 = (((pow(_807, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _821 = (_807 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_808 <= 0.0031308000907301903f)) {
                        _832 = (((pow(_808, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _832 = (_808 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_809 <= 0.0031308000907301903f)) {
                          _843 = (((pow(_809, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _843 = (_809 * 12.920000076293945f);
                        }
                        _850 = (saturate(_832) * 0.96875f) + 0.015625f;
                        _852 = max((saturate(_843) * 31.0f), 0.0f);
                        _853 = floor(_852);
                        _854 = _852 - _853;
                        _856 = (((saturate(_821) * 0.96875f) + 0.015625f) + _853) * 0.03125f;
                        _858 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_856, _850), 0.0f);
                        _862 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_856 + 0.03125f), _850), 0.0f);
                        _872 = ((_862.x - _858.x) * _854) + _858.x;
                        _873 = ((_862.y - _858.y) * _854) + _858.y;
                        _874 = ((_862.z - _858.z) * _854) + _858.z;
                        do {
                          [branch]
                          if (!(_872 <= 0.040449999272823334f)) {
                            _885 = exp2(log2((_872 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _885 = (_872 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_873 <= 0.040449999272823334f)) {
                              _896 = exp2(log2((_873 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _896 = (_873 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_874 <= 0.040449999272823334f)) {
                                _907 = exp2(log2((_874 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _907 = (_874 * 0.07739938050508499f);
                              }
                              _909 = dot(float3(_885, _896, _907), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _920 = (lerp(_909, _885, g_fTonemapSaturation));
                              _921 = (lerp(_909, _896, g_fTonemapSaturation));
                              _922 = (lerp(_909, _907, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1081 = (_920 * _84);
                _1082 = (_921 * _84);
                _1083 = (_922 * _84);
              } while (false);
            } while (false);
          } else {
            _931 = g_fMaxOutputNits * 0.012500000186264515f;
            _936 = max(abs(_366), max(abs(_367), abs(_368)));
            _938 = 1.0f / max(_936, 1.1754943508222875e-38f);
            _939 = _938 * _366;
            _940 = _938 * _367;
            _941 = _938 * _368;
            _951 = (_84 * 0.18000000715255737f) * exp2(log2((pow(_936, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
            _955 = dot(float3((_951 * _939), (_951 * _940), (_951 * _941)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1004 = exp2(log2(abs(_939)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_939 > 0.0f))) - ((int)(uint)((int)(_939 < 0.0f)))));
            _1005 = exp2(log2(abs(_940)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_940 > 0.0f))) - ((int)(uint)((int)(_940 < 0.0f)))));
            _1006 = exp2(log2(abs(_941)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_941 > 0.0f))) - ((int)(uint)((int)(_941 < 0.0f)))));
            _1011 = log2(saturate(select((_955 <= 0.0f), _955, ((1.0f - exp2(log2(exp2((_955 / _931) * -1.4426950216293335f)))) * _931)) / _931));
            _1024 = (exp2(_1011 * g_vTonemapCrosstalk.x) * (1.0f - _1004)) + _1004;
            _1025 = (exp2(_1011 * g_vTonemapCrosstalk.y) * (1.0f - _1005)) + _1005;
            _1026 = (exp2(_1011 * g_vTonemapCrosstalk.z) * (1.0f - _1006)) + _1006;
            _1058 = (float((int)(((int)(uint)((int)(_1024 > 0.0f))) - ((int)(uint)((int)(_1024 < 0.0f))))) * _951) * exp2(log2(abs(_1024)) * g_vTonemapCrosstalkSaturation.x);
            _1060 = (float((int)(((int)(uint)((int)(_1025 > 0.0f))) - ((int)(uint)((int)(_1025 < 0.0f))))) * _951) * exp2(log2(abs(_1025)) * g_vTonemapCrosstalkSaturation.y);
            _1062 = (float((int)(((int)(uint)((int)(_1026 > 0.0f))) - ((int)(uint)((int)(_1026 < 0.0f))))) * _951) * exp2(log2(abs(_1026)) * g_vTonemapCrosstalkSaturation.z);
            _1063 = dot(float3(_1058, _1060, _1062), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1076 = select((_1063 <= 0.0f), _1063, ((1.0f - exp2(log2(exp2((_1063 / _931) * -1.4426950216293335f)))) * _931)) * select((!(_1063 == 0.0f)), (1.0f / _1063), 0.0f);
            _1081 = (_1076 * _1058);
            _1082 = (_1076 * _1060);
            _1083 = (_1076 * _1062);
          }
        }
      }
      _1092 = (_1081 * g_fTonemapBrightness);
      _1093 = (_1082 * g_fTonemapBrightness);
      _1094 = (_1083 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1092 = (_366 * _84);
    _1093 = (_367 * _84);
    _1094 = (_368 * _84);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1106 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1116 = _1092 / _84;
    _1117 = _1093 / _84;
    _1118 = _1094 / _84;
    _1122 = 1.0f - sqrt(max(dot(float3(_1116, _1117, _1118), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
    _1128 = g_fFilmGrainIntensity * (_84 * 5.0f);
    _1142 = ((((_1128 * ((_1106.x * 2.0f) + -1.0f)) * saturate(_1116)) * _1122) + _1092);
    _1143 = ((((_1128 * ((_1106.y * 2.0f) + -1.0f)) * _1122) * saturate(_1117)) + _1093);
    _1144 = ((((_1128 * ((_1106.z * 2.0f) + -1.0f)) * _1122) * saturate(_1118)) + _1094);
  } else {
    _1142 = _1092;
    _1143 = _1093;
    _1144 = _1094;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1151 = (g_bHDR == 0);
    do {
      _1178 = _1142;
      _1179 = _1143;
      _1180 = _1144;
      if (!(_1151 || (g_bHDR_scRGB == 0))) {
        _1165 = max(mad(0.043306104838848114f, _1144, mad(0.329291969537735f, _1143, (_1142 * 0.6274019479751587f))), 0.0f);
        _1166 = max(mad(0.0113602289929986f, _1144, mad(0.9195442795753479f, _1143, (_1142 * 0.06909549236297607f))), 0.0f);
        _1167 = max(mad(0.895578145980835f, _1144, mad(0.08802816271781921f, _1143, (_1142 * 0.016393709927797318f))), 0.0f);
        _1178 = mad(-0.07283977419137955f, _1167, mad(-0.5876564383506775f, _1166, (_1165 * 1.6604962348937988f)));
        _1179 = mad(-0.008348013274371624f, _1167, mad(1.1328951120376587f, _1166, (_1165 * -0.1245470941066742f)));
        _1180 = mad(1.118751049041748f, _1167, mad(-0.10059737414121628f, _1166, (_1165 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1151)) {
        _1196 = mad(0.043306104838848114f, _1180, mad(0.329291969537735f, _1179, (_1178 * 0.6274019479751587f)));
        _1197 = mad(0.0113602289929986f, _1180, mad(0.9195442795753479f, _1179, (_1178 * 0.06909549236297607f)));
        _1198 = mad(0.895578145980835f, _1180, mad(0.08802816271781921f, _1179, (_1178 * 0.016393709927797318f)));
      } else {
        _1196 = _1178;
        _1197 = _1179;
        _1198 = _1180;
      }
    } while (false);
  } else {
    _1196 = _1142;
    _1197 = _1143;
    _1198 = _1144;
  }
  SV_Target.x = _1196;
  SV_Target.y = _1197;
  SV_Target.z = _1198;
  SV_Target.w = 1.0f;
  return SV_Target;
}
