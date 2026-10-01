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
  float4 _20;
  bool _26;
  bool _28;
  float _37;
  float _57;
  float _58;
  float _59;
  float _97;
  float _98;
  float _99;
  float _319;
  float _320;
  float _321;
  float _657;
  float _658;
  float _659;
  float _683;
  float _684;
  float _685;
  float _771;
  float _782;
  float _793;
  float _835;
  float _846;
  float _857;
  float _870;
  float _871;
  float _872;
  float _877;
  float _878;
  float _879;
  float _888;
  float _889;
  float _890;
  float _988;
  float _989;
  float _990;
  float _1024;
  float _1025;
  float _1026;
  float _1042;
  float _1043;
  float _1044;
  float _61;
  float _65;
  float _66;
  float _67;
  float _68;
  float _77;
  float _78;
  float _92;
  bool _102;
  float _118;
  float _119;
  float _120;
  float _148;
  float _149;
  float _150;
  int _154;
  int _155;
  int _156;
  float _160;
  float _161;
  float _162;
  int _167;
  int _172;
  int _177;
  bool _178;
  bool _179;
  bool _180;
  float4 _198;
  float4 _213;
  float4 _228;
  float4 _243;
  float _250;
  float _257;
  float _261;
  float _262;
  float _266;
  float _270;
  float _279;
  float _282;
  float _285;
  float _287;
  float _289;
  float _291;
  float _295;
  float _296;
  float _297;
  float _300;
  float _303;
  float _306;
  float _308;
  float _327;
  float _328;
  float _329;
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
  float _552;
  float _571;
  float _572;
  float _573;
  float _574;
  float _578;
  float _583;
  float _600;
  float _622;
  float _628;
  float _673;
  float _678;
  float _691;
  float _693;
  float _699;
  float _707;
  float _721;
  float _722;
  float _723;
  float _728;
  float _756;
  float _757;
  float _758;
  float _800;
  float _802;
  float _803;
  float _804;
  float _806;
  float4 _808;
  float4 _812;
  float _822;
  float _823;
  float _824;
  float _859;
  float4 _902;
  float _909;
  float _910;
  float _911;
  float _914;
  float _915;
  float _916;
  float _920;
  float _925;
  float _939;
  float _940;
  float _941;
  float _946;
  float _947;
  float _948;
  float _949;
  float _957;
  float _964;
  float _965;
  float _966;
  float _970;
  float _977;
  bool _997;
  float _1011;
  float _1012;
  float _1013;
  _18 = g_vInvOutputRes.x * SV_Position.x;
  _19 = g_vInvOutputRes.y * SV_Position.y;
  _20 = g_tSource.Sample(g_sLinearClamp_internal, float2(_18, _19));
  _26 = (g_bPostProcessApplyTonemap != 0);
  _28 = (g_bPostProcessApplyColorGrade != 0);
  if (!(g_bPostProcessApplyTonemap == 0)) {
    _37 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  } else {
    _37 = 1.0f;
  }
  if (_28) {
    _57 = max(_20.x, 0.0f);
    _58 = max(_20.y, 0.0f);
    _59 = max(_20.z, 0.0f);
  } else {
    _57 = _20.x;
    _58 = _20.y;
    _59 = _20.z;
  }
  _61 = g_bBrightness[1];
  _65 = exp2(g_fExposureCompensationInEV100) * _61;
  _66 = _65 * _57;
  _67 = _65 * _58;
  _68 = _65 * _59;
  if (!(g_bApplyVignette == 0)) {
    _77 = ((((g_vOverriddenAspectRatioUVScale.x * _18) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _78 = (((g_vOverriddenAspectRatioUVScale.y * _19) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _92 = saturate(exp2(log2(saturate(1.0f - sqrt((_77 * _77) + (_78 * _78))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _97 = (_92 * _66);
    _98 = (_92 * _67);
    _99 = (_92 * _68);
  } else {
    _97 = _66;
    _98 = _67;
    _99 = _68;
  }
  _102 = (g_bEnableHDRLUT == 0);
  if (!(_102 || (!_28))) {
    _118 = exp2(log2(saturate(_97 * 0.00800000037997961f)) * 0.1593017578125f);
    _119 = exp2(log2(saturate(_98 * 0.00800000037997961f)) * 0.1593017578125f);
    _120 = exp2(log2(saturate(_99 * 0.00800000037997961f)) * 0.1593017578125f);
    _148 = saturate(exp2(log2(((_118 * 18.8515625f) + 0.8359375f) / ((_118 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _149 = saturate(exp2(log2(((_119 * 18.8515625f) + 0.8359375f) / ((_119 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _150 = saturate(exp2(log2(((_120 * 18.8515625f) + 0.8359375f) / ((_120 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _154 = int(floor(_148));
    _155 = int(floor(_149));
    _156 = int(floor(_150));
    _160 = _148 - float((int)(_154));
    _161 = _149 - float((int)(_155));
    _162 = _150 - float((int)(_156));
    _167 = ((int)(uint)((int)(_162 > _160))) + ((int)(uint)((int)(_161 > _160)));
    _172 = ((int)(uint)((int)(_162 > _161))) + ((int)(uint)((int)(_160 >= _161)));
    _177 = ((int)(uint)((int)(_160 >= _162))) + ((int)(uint)((int)(_161 >= _162)));
    _178 = (_167 == 0);
    _179 = (_172 == 0);
    _180 = (_177 == 0);
    _198 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_156), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_154), (int)(0))), (int)(47))), min((int)(max((int)(_155), (int)(0))), (int)(47)), 0));
    _213 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_180))) + _156))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_178))) + _154))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_179))) + _155))), (int)(0))), (int)(47)), 0));
    _228 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_177 < (uint)2)))) + _156))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_167 < (uint)2)))) + _154))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_172 < (uint)2)))) + _155))), (int)(0))), (int)(47)), 0));
    _243 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_156 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_154 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_155 + 1u))), (int)(0))), (int)(47)), 0));
    _250 = dot(float3(_160, _161, _162), float3(((float)((bool)_178)), ((float)((bool)_179)), ((float)((bool)_180))));
    _257 = dot(float3(_160, _161, _162), float3(((float)((bool)(uint)(_167 == 2))), ((float)((bool)(uint)(_172 == 2))), ((float)((bool)(uint)(_177 == 2)))));
    _261 = (((_161 + _160) + _162) - _250) - _257;
    _262 = 1.0f - _250;
    _266 = _250 - _261;
    _270 = _261 - _257;
    _279 = (((_257 * _243.x) + (_262 * _198.x)) + (_266 * _213.x)) + (_270 * _228.x);
    _282 = (((_257 * _243.y) + (_262 * _198.y)) + (_266 * _213.y)) + (_270 * _228.y);
    _285 = (((_257 * _243.z) + (_262 * _198.z)) + (_266 * _213.z)) + (_270 * _228.z);
    _287 = mad(0.21580375730991364f, _285, mad(0.3963377773761749f, _282, _279));
    _289 = mad(-0.0638541728258133f, _285, mad(-0.10556134581565857f, _282, _279));
    _291 = mad(-1.2914855480194092f, _285, mad(-0.08948417752981186f, _282, _279));
    _295 = (_287 * _287) * _287;
    _296 = (_289 * _289) * _289;
    _297 = (_291 * _291) * _291;
    _300 = mad(0.23096993565559387f, _297, mad(-3.307711601257324f, _296, (_295 * 4.076741695404053f)));
    _303 = mad(-0.34131938219070435f, _297, mad(2.609757423400879f, _296, (_295 * -1.2684379816055298f)));
    _306 = mad(1.7076146602630615f, _297, mad(-0.7034186124801636f, _296, (_295 * -0.004196086432784796f)));
    _308 = dot(float3(_300, _303, _306), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _319 = (lerp(_308, _300, g_fTonemapSaturation));
    _320 = (lerp(_308, _303, g_fTonemapSaturation));
    _321 = (lerp(_308, _306, g_fTonemapSaturation));
  } else {
    _319 = _97;
    _320 = _98;
    _321 = _99;
  }
  if (_26) {
    do {
      _877 = _319;
      _878 = _320;
      _879 = _321;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          if (TONE_MAP_TYPE == 0.f) {
            _327 = max(_319, 0.0f);
            _328 = max(_320, 0.0f);
            _329 = max(_321, 0.0f);
          } else {
            _327 = _319;
            _328 = _320;
            _329 = _321;
          }
          float3 agx_color = ApplyRemedyAgX(
              _327, _328, _329, _37,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
          _877 = agx_color.x;
          _878 = agx_color.y;
          _879 = agx_color.z;
#else
          _327 = max(_319, 0.0f);
          _328 = max(_320, 0.0f);
          _329 = max(_321, 0.0f);
          _376 = g_fAgxMaxEV - g_fAgxMinEV;
          _380 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _329, mad(g_vAgxInsetRow0.y, _328, (g_vAgxInsetRow0.x * _327))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _376);
          _381 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _329, mad(g_vAgxInsetRow1.y, _328, (g_vAgxInsetRow1.x * _327))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _376);
          _382 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _329, mad(g_vAgxInsetRow2.y, _328, (g_vAgxInsetRow2.x * _327))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _376);
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
            _657 = _537;
            _658 = _538;
            _659 = _539;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_537, max(_538, _539)) >= g_fAgxHDRMidGrey))) {
                _550 = log2(1.0f / g_fAgxHDRMidGrey);
                _551 = _550 + 20.0f;
                _552 = log2(g_fAgxHDRRatio);
                _571 = (min(max(log2(max(_537, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _550) + 20.0f) / _551;
                _572 = (min(max(log2(max(_538, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _550) + 20.0f) / _551;
                _573 = (min(max(log2(max(_539, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _550) + 20.0f) / _551;
                _574 = 20.0f / _551;
                _578 = max(_571, max(_572, _573));
                _583 = ((_578 - _574) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _600 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_574 - _578);
                _622 = select((_578 >= _574), ((_583 / exp2(log2((float((int)(((int)(uint)((int)(_583 > 0.0f))) - ((int)(uint)((int)(_583 < 0.0f))))) * exp2(log2(abs(_583)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_600 / exp2(log2((float((int)(((int)(uint)((int)(_600 > 0.0f))) - ((int)(uint)((int)(_600 < 0.0f))))) * exp2(log2(abs(_600)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _552) / _551);
                _628 = exp2((((_622 - _578) * _551) + _552) * g_fAgxHDRSaturation);
                _657 = (saturate(exp2(((_622 + (_628 * (_571 - _578))) * _551) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _658 = (saturate(exp2(((_622 + (_628 * (_572 - _578))) * _551) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _659 = (saturate(exp2(((_622 + (_628 * (_573 - _578))) * _551) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _657 = _537;
                _658 = _538;
                _659 = _539;
              }
            }
            _877 = (mad(-0.07283977419137955f, _659, mad(-0.5876564383506775f, _658, (_657 * 1.6604962348937988f))) * _37);
            _878 = (mad(-0.008348013274371624f, _659, mad(1.1328951120376587f, _658, (_657 * -0.1245470941066742f))) * _37);
            _879 = (mad(1.118751049041748f, _659, mad(-0.10059737414121628f, _658, (_657 * -0.018153680488467216f))) * _37);
          } while (false);
#endif
        } else {
          _327 = max(_319, 0.0f);
          _328 = max(_320, 0.0f);
          _329 = max(_321, 0.0f);
          _673 = dot(float3(_327, _328, _329), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
          do {
            _683 = _327;
            _684 = _328;
            _685 = _329;
            if (!(_673 == 0.0f)) {
              _678 = max(dot(float3(_319, _320, _321), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _673;
              _683 = (_678 * _327);
              _684 = (_678 * _328);
              _685 = (_678 * _329);
            }
            _691 = max(max(_683, max(_684, _685)), 0.0f);
            _693 = 1.0f / max(_691, 1.1754943508222875e-38f);
            _699 = (pow(_691, g_vTonemapGTParams.x));
            _707 = _699 / (((pow(_699, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
            _721 = exp2(log2(_693 * _683) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
            _722 = exp2(log2(_693 * _684) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
            _723 = exp2(log2(_693 * _685) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
            _728 = log2(_707);
            _756 = saturate(exp2(log2((exp2(_728 * g_vTonemapCrosstalk.x) * (1.0f - _721)) + _721) * g_vTonemapCrosstalkSaturation.x) * _707);
            _757 = saturate(exp2(log2((exp2(_728 * g_vTonemapCrosstalk.y) * (1.0f - _722)) + _722) * g_vTonemapCrosstalkSaturation.y) * _707);
            _758 = saturate(exp2(log2((exp2(_728 * g_vTonemapCrosstalk.z) * (1.0f - _723)) + _723) * g_vTonemapCrosstalkSaturation.z) * _707);
            if (_102) {
              do {
                _870 = _756;
                _871 = _757;
                _872 = _758;
                if (_28) {
                  do {
                    [branch]
                    if (!(_756 <= 0.0031308000907301903f)) {
                      _771 = (((pow(_756, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _771 = (_756 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_757 <= 0.0031308000907301903f)) {
                        _782 = (((pow(_757, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _782 = (_757 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_758 <= 0.0031308000907301903f)) {
                          _793 = (((pow(_758, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _793 = (_758 * 12.920000076293945f);
                        }
                        _800 = (saturate(_782) * 0.96875f) + 0.015625f;
                        _802 = max((saturate(_793) * 31.0f), 0.0f);
                        _803 = floor(_802);
                        _804 = _802 - _803;
                        _806 = (((saturate(_771) * 0.96875f) + 0.015625f) + _803) * 0.03125f;
                        _808 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_806, _800), 0.0f);
                        _812 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_806 + 0.03125f), _800), 0.0f);
                        _822 = ((_812.x - _808.x) * _804) + _808.x;
                        _823 = ((_812.y - _808.y) * _804) + _808.y;
                        _824 = ((_812.z - _808.z) * _804) + _808.z;
                        do {
                          [branch]
                          if (!(_822 <= 0.040449999272823334f)) {
                            _835 = exp2(log2((_822 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _835 = (_822 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_823 <= 0.040449999272823334f)) {
                              _846 = exp2(log2((_823 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _846 = (_823 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_824 <= 0.040449999272823334f)) {
                                _857 = exp2(log2((_824 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _857 = (_824 * 0.07739938050508499f);
                              }
                              _859 = dot(float3(_835, _846, _857), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _870 = (lerp(_859, _835, g_fTonemapSaturation));
                              _871 = (lerp(_859, _846, g_fTonemapSaturation));
                              _872 = (lerp(_859, _857, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _877 = (_870 * _37);
                _878 = (_871 * _37);
                _879 = (_872 * _37);
              } while (false);
            } else {
              _877 = _756;
              _878 = _757;
              _879 = _758;
            }
          } while (false);
        }
      }
      _888 = (_877 * g_fTonemapBrightness);
      _889 = (_878 * g_fTonemapBrightness);
      _890 = (_879 * g_fTonemapBrightness);
    } while (false);
  } else {
    _888 = (_319 * _37);
    _889 = (_320 * _37);
    _890 = (_321 * _37);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _902 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _909 = (_902.x * 2.0f) + -1.0f;
    _910 = (_902.y * 2.0f) + -1.0f;
    _911 = (_902.z * 2.0f) + -1.0f;
    if (!(_26)) {
      _914 = _888 / _37;
      _915 = _889 / _37;
      _916 = _890 / _37;
      _920 = 1.0f - sqrt(max(dot(float3(_914, _915, _916), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
      _925 = g_fFilmGrainIntensity * (_37 * 5.0f);
      _988 = ((((_925 * _909) * saturate(_914)) * _920) + _888);
      _989 = ((((_925 * _910) * _920) * saturate(_915)) + _889);
      _990 = ((((_925 * _911) * _920) * saturate(_916)) + _890);
    } else {
      _939 = saturate(_888);
      _940 = saturate(_889);
      _941 = saturate(_890);
      _946 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_939, max(_940, _941))));
      _947 = _946 * _939;
      _948 = _946 * _940;
      _949 = _946 * _941;
      _957 = ((1.0f - sqrt(dot(float3(_947, _948, _949), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
      _964 = ((_957 * _909) * min(1.0f, _947)) + _947;
      _965 = ((_957 * _910) * min(1.0f, _948)) + _948;
      _966 = ((_957 * _911) * min(1.0f, _949)) + _949;
      _970 = 1.0f / (max(_964, max(_965, _966)) + 1.0f);
      _977 = 1.0f / (max(_947, max(_948, _949)) + 1.0f);
      _988 = (((_964 * _970) + _888) - (_977 * _947));
      _989 = (((_965 * _970) + _889) - (_977 * _948));
      _990 = (((_966 * _970) + _890) - (_977 * _949));
    }
  } else {
    _988 = _888;
    _989 = _889;
    _990 = _890;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _997 = (g_bHDR == 0);
    do {
      _1024 = _988;
      _1025 = _989;
      _1026 = _990;
      if (!(_997 || (g_bHDR_scRGB == 0))) {
        _1011 = max(mad(0.043306104838848114f, _990, mad(0.329291969537735f, _989, (_988 * 0.6274019479751587f))), 0.0f);
        _1012 = max(mad(0.0113602289929986f, _990, mad(0.9195442795753479f, _989, (_988 * 0.06909549236297607f))), 0.0f);
        _1013 = max(mad(0.895578145980835f, _990, mad(0.08802816271781921f, _989, (_988 * 0.016393709927797318f))), 0.0f);
        _1024 = mad(-0.07283977419137955f, _1013, mad(-0.5876564383506775f, _1012, (_1011 * 1.6604962348937988f)));
        _1025 = mad(-0.008348013274371624f, _1013, mad(1.1328951120376587f, _1012, (_1011 * -0.1245470941066742f)));
        _1026 = mad(1.118751049041748f, _1013, mad(-0.10059737414121628f, _1012, (_1011 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_997)) {
        _1042 = mad(0.043306104838848114f, _1026, mad(0.329291969537735f, _1025, (_1024 * 0.6274019479751587f)));
        _1043 = mad(0.0113602289929986f, _1026, mad(0.9195442795753479f, _1025, (_1024 * 0.06909549236297607f)));
        _1044 = mad(0.895578145980835f, _1026, mad(0.08802816271781921f, _1025, (_1024 * 0.016393709927797318f)));
      } else {
        _1042 = _1024;
        _1043 = _1025;
        _1044 = _1026;
      }
    } while (false);
  } else {
    _1042 = _988;
    _1043 = _989;
    _1044 = _990;
  }
  SV_Target.x = _1042;
  SV_Target.y = _1043;
  SV_Target.z = _1044;
  SV_Target.w = 1.0f;
  return SV_Target;
}
