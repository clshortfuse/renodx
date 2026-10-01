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
  float _85;
  float _105;
  float _106;
  float _107;
  float _145;
  float _146;
  float _147;
  float _367;
  float _368;
  float _369;
  float _705;
  float _706;
  float _707;
  float _731;
  float _732;
  float _733;
  float _819;
  float _830;
  float _841;
  float _883;
  float _894;
  float _905;
  float _918;
  float _919;
  float _920;
  float _925;
  float _926;
  float _927;
  float _936;
  float _937;
  float _938;
  float _1036;
  float _1037;
  float _1038;
  float _1072;
  float _1073;
  float _1074;
  float _1090;
  float _1091;
  float _1092;
  float _41;
  float _45;
  float _46;
  float _50;
  float _54;
  float4 _68;
  bool _74;
  bool _76;
  float _109;
  float _113;
  float _114;
  float _115;
  float _116;
  float _125;
  float _126;
  float _140;
  bool _150;
  float _166;
  float _167;
  float _168;
  float _196;
  float _197;
  float _198;
  int _202;
  int _203;
  int _204;
  float _208;
  float _209;
  float _210;
  int _215;
  int _220;
  int _225;
  bool _226;
  bool _227;
  bool _228;
  float4 _246;
  float4 _261;
  float4 _276;
  float4 _291;
  float _298;
  float _305;
  float _309;
  float _310;
  float _314;
  float _318;
  float _327;
  float _330;
  float _333;
  float _335;
  float _337;
  float _339;
  float _343;
  float _344;
  float _345;
  float _348;
  float _351;
  float _354;
  float _356;
  float _375;
  float _376;
  float _377;
  float _424;
  float _428;
  float _429;
  float _430;
  float _439;
  float _440;
  float _457;
  float _459;
  float _460;
  float _479;
  float _482;
  float _485;
  float _503;
  float _524;
  float _527;
  float _545;
  float _566;
  float _585;
  float _586;
  float _587;
  float _598;
  float _599;
  float _600;
  float _619;
  float _620;
  float _621;
  float _622;
  float _626;
  float _631;
  float _648;
  float _670;
  float _676;
  float _721;
  float _726;
  float _739;
  float _741;
  float _747;
  float _755;
  float _769;
  float _770;
  float _771;
  float _776;
  float _804;
  float _805;
  float _806;
  float _848;
  float _850;
  float _851;
  float _852;
  float _854;
  float4 _856;
  float4 _860;
  float _870;
  float _871;
  float _872;
  float _907;
  float4 _950;
  float _957;
  float _958;
  float _959;
  float _962;
  float _963;
  float _964;
  float _968;
  float _973;
  float _987;
  float _988;
  float _989;
  float _994;
  float _995;
  float _996;
  float _997;
  float _1005;
  float _1012;
  float _1013;
  float _1014;
  float _1018;
  float _1025;
  bool _1045;
  float _1059;
  float _1060;
  float _1061;
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
  _74 = (g_bPostProcessApplyTonemap != 0);
  _76 = (g_bPostProcessApplyColorGrade != 0);
  if (!(g_bPostProcessApplyTonemap == 0)) {
    _85 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  } else {
    _85 = 1.0f;
  }
  if (_76) {
    _105 = max(_68.x, 0.0f);
    _106 = max(_68.y, 0.0f);
    _107 = max(_68.z, 0.0f);
  } else {
    _105 = _68.x;
    _106 = _68.y;
    _107 = _68.z;
  }
  _109 = g_bBrightness[1];
  _113 = exp2(g_fExposureCompensationInEV100) * _109;
  _114 = _113 * _105;
  _115 = _113 * _106;
  _116 = _113 * _107;
  if (!(g_bApplyVignette == 0)) {
    _125 = ((((g_vOverriddenAspectRatioUVScale.x * _18) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _126 = (((g_vOverriddenAspectRatioUVScale.y * _19) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _140 = saturate(exp2(log2(saturate(1.0f - sqrt((_125 * _125) + (_126 * _126))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _145 = (_140 * _114);
    _146 = (_140 * _115);
    _147 = (_140 * _116);
  } else {
    _145 = _114;
    _146 = _115;
    _147 = _116;
  }
  _150 = (g_bEnableHDRLUT == 0);
  if (!(_150 || (!_76))) {
    _166 = exp2(log2(saturate(_145 * 0.00800000037997961f)) * 0.1593017578125f);
    _167 = exp2(log2(saturate(_146 * 0.00800000037997961f)) * 0.1593017578125f);
    _168 = exp2(log2(saturate(_147 * 0.00800000037997961f)) * 0.1593017578125f);
    _196 = saturate(exp2(log2(((_166 * 18.8515625f) + 0.8359375f) / ((_166 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _197 = saturate(exp2(log2(((_167 * 18.8515625f) + 0.8359375f) / ((_167 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _198 = saturate(exp2(log2(((_168 * 18.8515625f) + 0.8359375f) / ((_168 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _202 = int(floor(_196));
    _203 = int(floor(_197));
    _204 = int(floor(_198));
    _208 = _196 - float((int)(_202));
    _209 = _197 - float((int)(_203));
    _210 = _198 - float((int)(_204));
    _215 = ((int)(uint)((int)(_210 > _208))) + ((int)(uint)((int)(_209 > _208)));
    _220 = ((int)(uint)((int)(_210 > _209))) + ((int)(uint)((int)(_208 >= _209)));
    _225 = ((int)(uint)((int)(_208 >= _210))) + ((int)(uint)((int)(_209 >= _210)));
    _226 = (_215 == 0);
    _227 = (_220 == 0);
    _228 = (_225 == 0);
    _246 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_204), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_202), (int)(0))), (int)(47))), min((int)(max((int)(_203), (int)(0))), (int)(47)), 0));
    _261 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_228))) + _204))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_226))) + _202))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_227))) + _203))), (int)(0))), (int)(47)), 0));
    _276 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_225 < (uint)2)))) + _204))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_215 < (uint)2)))) + _202))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_220 < (uint)2)))) + _203))), (int)(0))), (int)(47)), 0));
    _291 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_204 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_202 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_203 + 1u))), (int)(0))), (int)(47)), 0));
    _298 = dot(float3(_208, _209, _210), float3(((float)((bool)_226)), ((float)((bool)_227)), ((float)((bool)_228))));
    _305 = dot(float3(_208, _209, _210), float3(((float)((bool)(uint)(_215 == 2))), ((float)((bool)(uint)(_220 == 2))), ((float)((bool)(uint)(_225 == 2)))));
    _309 = (((_209 + _208) + _210) - _298) - _305;
    _310 = 1.0f - _298;
    _314 = _298 - _309;
    _318 = _309 - _305;
    _327 = (((_305 * _291.x) + (_310 * _246.x)) + (_314 * _261.x)) + (_318 * _276.x);
    _330 = (((_305 * _291.y) + (_310 * _246.y)) + (_314 * _261.y)) + (_318 * _276.y);
    _333 = (((_305 * _291.z) + (_310 * _246.z)) + (_314 * _261.z)) + (_318 * _276.z);
    _335 = mad(0.21580375730991364f, _333, mad(0.3963377773761749f, _330, _327));
    _337 = mad(-0.0638541728258133f, _333, mad(-0.10556134581565857f, _330, _327));
    _339 = mad(-1.2914855480194092f, _333, mad(-0.08948417752981186f, _330, _327));
    _343 = (_335 * _335) * _335;
    _344 = (_337 * _337) * _337;
    _345 = (_339 * _339) * _339;
    _348 = mad(0.23096993565559387f, _345, mad(-3.307711601257324f, _344, (_343 * 4.076741695404053f)));
    _351 = mad(-0.34131938219070435f, _345, mad(2.609757423400879f, _344, (_343 * -1.2684379816055298f)));
    _354 = mad(1.7076146602630615f, _345, mad(-0.7034186124801636f, _344, (_343 * -0.004196086432784796f)));
    _356 = dot(float3(_348, _351, _354), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _367 = (lerp(_356, _348, g_fTonemapSaturation));
    _368 = (lerp(_356, _351, g_fTonemapSaturation));
    _369 = (lerp(_356, _354, g_fTonemapSaturation));
  } else {
    _367 = _145;
    _368 = _146;
    _369 = _147;
  }
  if (_74) {
    do {
      _925 = _367;
      _926 = _368;
      _927 = _369;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          if (TONE_MAP_TYPE == 0.f) {
            _375 = max(_367, 0.0f);
            _376 = max(_368, 0.0f);
            _377 = max(_369, 0.0f);
          } else {
            _375 = _367;
            _376 = _368;
            _377 = _369;
          }
          float3 agx_color = ApplyRemedyAgX(
              _375, _376, _377, _85,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
          _925 = agx_color.x;
          _926 = agx_color.y;
          _927 = agx_color.z;
#else
          _375 = max(_367, 0.0f);
          _376 = max(_368, 0.0f);
          _377 = max(_369, 0.0f);
          _424 = g_fAgxMaxEV - g_fAgxMinEV;
          _428 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _377, mad(g_vAgxInsetRow0.y, _376, (g_vAgxInsetRow0.x * _375))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _424);
          _429 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _377, mad(g_vAgxInsetRow1.y, _376, (g_vAgxInsetRow1.x * _375))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _424);
          _430 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _377, mad(g_vAgxInsetRow2.y, _376, (g_vAgxInsetRow2.x * _375))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _424);
          _439 = (g_fAgxContrastSlope * (_428 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _440 = 1.0f / g_fAgxShoulderPower;
          _457 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _459 = _457 * (0.6060606241226196f - _428);
          _460 = 1.0f / g_fAgxToePower;
          _479 = -0.0f - g_fAgxToePrecalcConstant;
          _482 = select((_428 >= 0.6060606241226196f), ((_439 / exp2(log2((float((int)(((int)(uint)((int)(_439 > 0.0f))) - ((int)(uint)((int)(_439 < 0.0f))))) * exp2(log2(abs(_439)) * g_fAgxShoulderPower)) + 1.0f) * _440)) * g_fAgxShoulderPrecalcConstant), ((_459 / exp2(log2((float((int)(((int)(uint)((int)(_459 > 0.0f))) - ((int)(uint)((int)(_459 < 0.0f))))) * exp2(log2(abs(_459)) * g_fAgxToePower)) + 1.0f) * _460)) * _479)) + 0.4894371032714844f;
          _485 = (g_fAgxContrastSlope * (_429 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _503 = _457 * (0.6060606241226196f - _429);
          _524 = select((_429 >= 0.6060606241226196f), ((_485 / exp2(log2((float((int)(((int)(uint)((int)(_485 > 0.0f))) - ((int)(uint)((int)(_485 < 0.0f))))) * exp2(log2(abs(_485)) * g_fAgxShoulderPower)) + 1.0f) * _440)) * g_fAgxShoulderPrecalcConstant), ((_503 / exp2(log2((exp2(log2(abs(_503)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_503 > 0.0f))) - ((int)(uint)((int)(_503 < 0.0f)))))) + 1.0f) * _460)) * _479)) + 0.4894371032714844f;
          _527 = (g_fAgxContrastSlope * (_430 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _545 = _457 * (0.6060606241226196f - _430);
          _566 = select((_430 >= 0.6060606241226196f), ((_527 / exp2(log2((float((int)(((int)(uint)((int)(_527 > 0.0f))) - ((int)(uint)((int)(_527 < 0.0f))))) * exp2(log2(abs(_527)) * g_fAgxShoulderPower)) + 1.0f) * _440)) * g_fAgxShoulderPrecalcConstant), ((_545 / exp2(log2((exp2(log2(abs(_545)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_545 > 0.0f))) - ((int)(uint)((int)(_545 < 0.0f)))))) + 1.0f) * _460)) * _479)) + 0.4894371032714844f;
          _585 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _566, mad(g_vAgxOutsetRow0.y, _524, (_482 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _586 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _566, mad(g_vAgxOutsetRow1.y, _524, (_482 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _587 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _566, mad(g_vAgxOutsetRow2.y, _524, (_482 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _705 = _585;
            _706 = _586;
            _707 = _587;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_585, max(_586, _587)) >= g_fAgxHDRMidGrey))) {
                _598 = log2(1.0f / g_fAgxHDRMidGrey);
                _599 = _598 + 20.0f;
                _600 = log2(g_fAgxHDRRatio);
                _619 = (min(max(log2(max(_585, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _598) + 20.0f) / _599;
                _620 = (min(max(log2(max(_586, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _598) + 20.0f) / _599;
                _621 = (min(max(log2(max(_587, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _598) + 20.0f) / _599;
                _622 = 20.0f / _599;
                _626 = max(_619, max(_620, _621));
                _631 = ((_626 - _622) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _648 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_622 - _626);
                _670 = select((_626 >= _622), ((_631 / exp2(log2((float((int)(((int)(uint)((int)(_631 > 0.0f))) - ((int)(uint)((int)(_631 < 0.0f))))) * exp2(log2(abs(_631)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_648 / exp2(log2((float((int)(((int)(uint)((int)(_648 > 0.0f))) - ((int)(uint)((int)(_648 < 0.0f))))) * exp2(log2(abs(_648)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _600) / _599);
                _676 = exp2((((_670 - _626) * _599) + _600) * g_fAgxHDRSaturation);
                _705 = (saturate(exp2(((_670 + (_676 * (_619 - _626))) * _599) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _706 = (saturate(exp2(((_670 + (_676 * (_620 - _626))) * _599) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _707 = (saturate(exp2(((_670 + (_676 * (_621 - _626))) * _599) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _705 = _585;
                _706 = _586;
                _707 = _587;
              }
            }
            _925 = (mad(-0.07283977419137955f, _707, mad(-0.5876564383506775f, _706, (_705 * 1.6604962348937988f))) * _85);
            _926 = (mad(-0.008348013274371624f, _707, mad(1.1328951120376587f, _706, (_705 * -0.1245470941066742f))) * _85);
            _927 = (mad(1.118751049041748f, _707, mad(-0.10059737414121628f, _706, (_705 * -0.018153680488467216f))) * _85);
          } while (false);
#endif
        } else {
          _375 = max(_367, 0.0f);
          _376 = max(_368, 0.0f);
          _377 = max(_369, 0.0f);
          _721 = dot(float3(_375, _376, _377), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
          do {
            _731 = _375;
            _732 = _376;
            _733 = _377;
            if (!(_721 == 0.0f)) {
              _726 = max(dot(float3(_367, _368, _369), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _721;
              _731 = (_726 * _375);
              _732 = (_726 * _376);
              _733 = (_726 * _377);
            }
            _739 = max(max(_731, max(_732, _733)), 0.0f);
            _741 = 1.0f / max(_739, 1.1754943508222875e-38f);
            _747 = (pow(_739, g_vTonemapGTParams.x));
            _755 = _747 / (((pow(_747, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
            _769 = exp2(log2(_741 * _731) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
            _770 = exp2(log2(_741 * _732) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
            _771 = exp2(log2(_741 * _733) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
            _776 = log2(_755);
            _804 = saturate(exp2(log2((exp2(_776 * g_vTonemapCrosstalk.x) * (1.0f - _769)) + _769) * g_vTonemapCrosstalkSaturation.x) * _755);
            _805 = saturate(exp2(log2((exp2(_776 * g_vTonemapCrosstalk.y) * (1.0f - _770)) + _770) * g_vTonemapCrosstalkSaturation.y) * _755);
            _806 = saturate(exp2(log2((exp2(_776 * g_vTonemapCrosstalk.z) * (1.0f - _771)) + _771) * g_vTonemapCrosstalkSaturation.z) * _755);
            if (_150) {
              do {
                _918 = _804;
                _919 = _805;
                _920 = _806;
                if (_76) {
                  do {
                    [branch]
                    if (!(_804 <= 0.0031308000907301903f)) {
                      _819 = (((pow(_804, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _819 = (_804 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_805 <= 0.0031308000907301903f)) {
                        _830 = (((pow(_805, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _830 = (_805 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_806 <= 0.0031308000907301903f)) {
                          _841 = (((pow(_806, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _841 = (_806 * 12.920000076293945f);
                        }
                        _848 = (saturate(_830) * 0.96875f) + 0.015625f;
                        _850 = max((saturate(_841) * 31.0f), 0.0f);
                        _851 = floor(_850);
                        _852 = _850 - _851;
                        _854 = (((saturate(_819) * 0.96875f) + 0.015625f) + _851) * 0.03125f;
                        _856 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_854, _848), 0.0f);
                        _860 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_854 + 0.03125f), _848), 0.0f);
                        _870 = ((_860.x - _856.x) * _852) + _856.x;
                        _871 = ((_860.y - _856.y) * _852) + _856.y;
                        _872 = ((_860.z - _856.z) * _852) + _856.z;
                        do {
                          [branch]
                          if (!(_870 <= 0.040449999272823334f)) {
                            _883 = exp2(log2((_870 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _883 = (_870 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_871 <= 0.040449999272823334f)) {
                              _894 = exp2(log2((_871 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _894 = (_871 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_872 <= 0.040449999272823334f)) {
                                _905 = exp2(log2((_872 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _905 = (_872 * 0.07739938050508499f);
                              }
                              _907 = dot(float3(_883, _894, _905), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _918 = (lerp(_907, _883, g_fTonemapSaturation));
                              _919 = (lerp(_907, _894, g_fTonemapSaturation));
                              _920 = (lerp(_907, _905, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _925 = (_918 * _85);
                _926 = (_919 * _85);
                _927 = (_920 * _85);
              } while (false);
            } else {
              _925 = _804;
              _926 = _805;
              _927 = _806;
            }
          } while (false);
        }
      }
      _936 = (_925 * g_fTonemapBrightness);
      _937 = (_926 * g_fTonemapBrightness);
      _938 = (_927 * g_fTonemapBrightness);
    } while (false);
  } else {
    _936 = (_367 * _85);
    _937 = (_368 * _85);
    _938 = (_369 * _85);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _950 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _957 = (_950.x * 2.0f) + -1.0f;
    _958 = (_950.y * 2.0f) + -1.0f;
    _959 = (_950.z * 2.0f) + -1.0f;
    if (!(_74)) {
      _962 = _936 / _85;
      _963 = _937 / _85;
      _964 = _938 / _85;
      _968 = 1.0f - sqrt(max(dot(float3(_962, _963, _964), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
      _973 = g_fFilmGrainIntensity * (_85 * 5.0f);
      _1036 = ((((_973 * _957) * saturate(_962)) * _968) + _936);
      _1037 = ((((_973 * _958) * _968) * saturate(_963)) + _937);
      _1038 = ((((_973 * _959) * _968) * saturate(_964)) + _938);
    } else {
      _987 = saturate(_936);
      _988 = saturate(_937);
      _989 = saturate(_938);
      _994 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_987, max(_988, _989))));
      _995 = _994 * _987;
      _996 = _994 * _988;
      _997 = _994 * _989;
      _1005 = ((1.0f - sqrt(dot(float3(_995, _996, _997), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
      _1012 = ((_1005 * _957) * min(1.0f, _995)) + _995;
      _1013 = ((_1005 * _958) * min(1.0f, _996)) + _996;
      _1014 = ((_1005 * _959) * min(1.0f, _997)) + _997;
      _1018 = 1.0f / (max(_1012, max(_1013, _1014)) + 1.0f);
      _1025 = 1.0f / (max(_995, max(_996, _997)) + 1.0f);
      _1036 = (((_1012 * _1018) + _936) - (_1025 * _995));
      _1037 = (((_1013 * _1018) + _937) - (_1025 * _996));
      _1038 = (((_1014 * _1018) + _938) - (_1025 * _997));
    }
  } else {
    _1036 = _936;
    _1037 = _937;
    _1038 = _938;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1045 = (g_bHDR == 0);
    do {
      _1072 = _1036;
      _1073 = _1037;
      _1074 = _1038;
      if (!(_1045 || (g_bHDR_scRGB == 0))) {
        _1059 = max(mad(0.043306104838848114f, _1038, mad(0.329291969537735f, _1037, (_1036 * 0.6274019479751587f))), 0.0f);
        _1060 = max(mad(0.0113602289929986f, _1038, mad(0.9195442795753479f, _1037, (_1036 * 0.06909549236297607f))), 0.0f);
        _1061 = max(mad(0.895578145980835f, _1038, mad(0.08802816271781921f, _1037, (_1036 * 0.016393709927797318f))), 0.0f);
        _1072 = mad(-0.07283977419137955f, _1061, mad(-0.5876564383506775f, _1060, (_1059 * 1.6604962348937988f)));
        _1073 = mad(-0.008348013274371624f, _1061, mad(1.1328951120376587f, _1060, (_1059 * -0.1245470941066742f)));
        _1074 = mad(1.118751049041748f, _1061, mad(-0.10059737414121628f, _1060, (_1059 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1045)) {
        _1090 = mad(0.043306104838848114f, _1074, mad(0.329291969537735f, _1073, (_1072 * 0.6274019479751587f)));
        _1091 = mad(0.0113602289929986f, _1074, mad(0.9195442795753479f, _1073, (_1072 * 0.06909549236297607f)));
        _1092 = mad(0.895578145980835f, _1074, mad(0.08802816271781921f, _1073, (_1072 * 0.016393709927797318f)));
      } else {
        _1090 = _1072;
        _1091 = _1073;
        _1092 = _1074;
      }
    } while (false);
  } else {
    _1090 = _1036;
    _1091 = _1037;
    _1092 = _1038;
  }
  SV_Target.x = _1090;
  SV_Target.y = _1091;
  SV_Target.z = _1092;
  SV_Target.w = 1.0f;
  return SV_Target;
}
