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
  float _36;
  float _56;
  float _57;
  float _58;
  float _96;
  float _97;
  float _98;
  float _184;
  float _185;
  float _186;
  float _588;
  float _589;
  float _590;
  float _618;
  float _619;
  float _620;
  float _705;
  float _716;
  float _727;
  float _769;
  float _780;
  float _791;
  float _804;
  float _805;
  float _806;
  float _965;
  float _966;
  float _967;
  float _976;
  float _977;
  float _978;
  float _1026;
  float _1027;
  float _1028;
  float _1062;
  float _1063;
  float _1064;
  float _1080;
  float _1081;
  float _1082;
  float _60;
  float _64;
  float _65;
  float _66;
  float _67;
  float _76;
  float _77;
  float _91;
  bool _101;
  float _117;
  float _118;
  float _119;
  float _147;
  float _149;
  float _150;
  float _151;
  float _153;
  float4 _155;
  float4 _159;
  float _169;
  float _170;
  float _171;
  float _173;
  float _217;
  float _218;
  float _219;
  float _241;
  float _245;
  float _246;
  float _247;
  float _256;
  float _257;
  float _274;
  float _276;
  float _277;
  float _296;
  float _299;
  float _302;
  float _320;
  float _341;
  float _344;
  float _362;
  float _383;
  float _402;
  float _403;
  float _404;
  float _415;
  float _416;
  float _429;
  float _430;
  float _431;
  float _438;
  float _441;
  float _446;
  float _461;
  float _464;
  float _483;
  float _489;
  float _506;
  float _530;
  float _547;
  float _605;
  float _606;
  float _607;
  float _608;
  float _613;
  float _626;
  float _628;
  float _634;
  float _642;
  float _656;
  float _657;
  float _658;
  float _663;
  float _691;
  float _692;
  float _693;
  float _734;
  float _736;
  float _737;
  float _738;
  float _740;
  float4 _742;
  float4 _746;
  float _756;
  float _757;
  float _758;
  float _793;
  float _815;
  float _820;
  float _822;
  float _823;
  float _824;
  float _825;
  float _835;
  float _839;
  float _888;
  float _889;
  float _890;
  float _895;
  float _908;
  float _909;
  float _910;
  float _942;
  float _944;
  float _946;
  float _947;
  float _960;
  float4 _990;
  float _1000;
  float _1001;
  float _1002;
  float _1006;
  float _1012;
  bool _1035;
  float _1049;
  float _1050;
  float _1051;
  _18 = g_vInvOutputRes.x * SV_Position.x;
  _19 = g_vInvOutputRes.y * SV_Position.y;
  _20 = g_tSource.Sample(g_sLinearClamp_internal, float2(_18, _19));
  _26 = (g_bPostProcessApplyTonemap == 0);
  _28 = (g_bPostProcessApplyColorGrade != 0);
  if (!(_26)) {
    _36 = g_fPaperWhite;
  } else {
    _36 = 1.0f;
  }
  if (_28) {
    _56 = max(_20.x, 0.0f);
    _57 = max(_20.y, 0.0f);
    _58 = max(_20.z, 0.0f);
  } else {
    _56 = _20.x;
    _57 = _20.y;
    _58 = _20.z;
  }
  _60 = g_bBrightness[1];
  _64 = exp2(g_fExposureCompensationInEV100) * _60;
  _65 = _64 * _56;
  _66 = _64 * _57;
  _67 = _64 * _58;
  if (!(g_bApplyVignette == 0)) {
    _76 = ((((g_vOverriddenAspectRatioUVScale.x * _18) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _77 = (((g_vOverriddenAspectRatioUVScale.y * _19) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _91 = saturate(exp2(log2(saturate(1.0f - sqrt((_76 * _76) + (_77 * _77))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _96 = (_91 * _65);
    _97 = (_91 * _66);
    _98 = (_91 * _67);
  } else {
    _96 = _65;
    _97 = _66;
    _98 = _67;
  }
  _101 = (g_bEnableHDRLUT == 0);
  if (!(_101 || (!_28))) {
#if 1
    float3 graded_color = ApplyVanillaPQLUT(
        float3(_96, _97, _98), g_tBaseColorCorrectionMap, g_sLinearClamp_internal, g_fTonemapSaturation);
    _184 = graded_color.x;
    _185 = graded_color.y;
    _186 = graded_color.z;
#else
    _117 = exp2(log2(saturate(_96 * 0.00800000037997961f)) * 0.1593017578125f);
    _118 = exp2(log2(saturate(_97 * 0.00800000037997961f)) * 0.1593017578125f);
    _119 = exp2(log2(saturate(_98 * 0.00800000037997961f)) * 0.1593017578125f);
    _147 = (exp2(log2(((_118 * 18.8515625f) + 0.8359375f) / ((_118 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
    _149 = max((exp2(log2(((_119 * 18.8515625f) + 0.8359375f) / ((_119 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
    _150 = floor(_149);
    _151 = _149 - _150;
    _153 = (((exp2(log2(((_117 * 18.8515625f) + 0.8359375f) / ((_117 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _150) * 0.02083333395421505f;
    _155 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_153, _147), 0.0f);
    _159 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_153 + 0.02083333395421505f), _147), 0.0f);
    _169 = ((_159.x - _155.x) * _151) + _155.x;
    _170 = ((_159.y - _155.y) * _151) + _155.y;
    _171 = ((_159.z - _155.z) * _151) + _155.z;
    _173 = dot(float3(_169, _170, _171), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _184 = (lerp(_173, _169, g_fTonemapSaturation));
    _185 = (lerp(_173, _170, g_fTonemapSaturation));
    _186 = (lerp(_173, _171, g_fTonemapSaturation));
#endif
  } else {
    _184 = _96;
    _185 = _97;
    _186 = _98;
  }
  if (!(_26)) {
    do {
      _965 = _184;
      _966 = _185;
      _967 = _186;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _184, _185, _186, _36,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes);
          _965 = agx_color.x;
          _966 = agx_color.y;
          _967 = agx_color.z;
#else
          _217 = max(_184, 0.0f);
          _218 = max(_185, 0.0f);
          _219 = max(_186, 0.0f);
          _241 = g_fAgxMaxEV - g_fAgxMinEV;
          _245 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _219, mad(g_vAgxInsetRow0.y, _218, (_217 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _241);
          _246 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _219, mad(g_vAgxInsetRow1.y, _218, (_217 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _241);
          _247 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _219, mad(g_vAgxInsetRow2.y, _218, (_217 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _241);
          _256 = (g_fAgxContrastSlope * (_245 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _257 = 1.0f / g_fAgxShoulderPower;
          _274 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _276 = _274 * (0.6060606241226196f - _245);
          _277 = 1.0f / g_fAgxToePower;
          _296 = -0.0f - g_fAgxToePrecalcConstant;
          _299 = select((_245 >= 0.6060606241226196f), ((_256 / exp2(log2((float((int)(((int)(uint)((int)(_256 > 0.0f))) - ((int)(uint)((int)(_256 < 0.0f))))) * exp2(log2(abs(_256)) * g_fAgxShoulderPower)) + 1.0f) * _257)) * g_fAgxShoulderPrecalcConstant), ((_276 / exp2(log2((float((int)(((int)(uint)((int)(_276 > 0.0f))) - ((int)(uint)((int)(_276 < 0.0f))))) * exp2(log2(abs(_276)) * g_fAgxToePower)) + 1.0f) * _277)) * _296)) + 0.4894371032714844f;
          _302 = (g_fAgxContrastSlope * (_246 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _320 = _274 * (0.6060606241226196f - _246);
          _341 = select((_246 >= 0.6060606241226196f), ((_302 / exp2(log2((float((int)(((int)(uint)((int)(_302 > 0.0f))) - ((int)(uint)((int)(_302 < 0.0f))))) * exp2(log2(abs(_302)) * g_fAgxShoulderPower)) + 1.0f) * _257)) * g_fAgxShoulderPrecalcConstant), ((_320 / exp2(log2((exp2(log2(abs(_320)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_320 > 0.0f))) - ((int)(uint)((int)(_320 < 0.0f)))))) + 1.0f) * _277)) * _296)) + 0.4894371032714844f;
          _344 = (g_fAgxContrastSlope * (_247 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _362 = _274 * (0.6060606241226196f - _247);
          _383 = select((_247 >= 0.6060606241226196f), ((_344 / exp2(log2((float((int)(((int)(uint)((int)(_344 > 0.0f))) - ((int)(uint)((int)(_344 < 0.0f))))) * exp2(log2(abs(_344)) * g_fAgxShoulderPower)) + 1.0f) * _257)) * g_fAgxShoulderPrecalcConstant), ((_362 / exp2(log2((exp2(log2(abs(_362)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_362 > 0.0f))) - ((int)(uint)((int)(_362 < 0.0f)))))) + 1.0f) * _277)) * _296)) + 0.4894371032714844f;
          _402 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _383, mad(g_vAgxOutsetRow0.y, _341, (_299 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _403 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _383, mad(g_vAgxOutsetRow1.y, _341, (_299 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _404 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _383, mad(g_vAgxOutsetRow2.y, _341, (_299 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _588 = _402;
            _589 = _403;
            _590 = _404;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_402, max(_403, _404)) >= g_fAgxHDRMidGrey))) {
                _415 = log2(1.0f / g_fAgxHDRMidGrey);
                _416 = _415 + 20.0f;
                _429 = min(max(log2(max(_402, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _415);
                _430 = min(max(log2(max(_403, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _415);
                _431 = min(max(log2(max(_404, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _415);
                _438 = 20.0f / _416;
                _441 = (20.0f - log2(g_fAgxHDRRatio)) / _416;
                _446 = ((_429 / _416) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _461 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                _464 = ((-0.0f - _429) / _416) * _461;
                _483 = -0.0f - g_fAgxHDRToePrecalcConstant;
                _489 = ((_430 / _416) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _506 = ((-0.0f - _430) / _416) * _461;
                _530 = ((_431 / _416) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _547 = ((-0.0f - _431) / _416) * _461;
                _588 = (saturate(exp2(((select((((_429 + 20.0f) / _416) >= _438), ((_446 / exp2(log2((float((int)(((int)(uint)((int)(_446 > 0.0f))) - ((int)(uint)((int)(_446 < 0.0f))))) * exp2(log2(abs(_446)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_464 / exp2(log2((float((int)(((int)(uint)((int)(_464 > 0.0f))) - ((int)(uint)((int)(_464 < 0.0f))))) * exp2(log2(abs(_464)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _483)) + _441) * _416) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _589 = (saturate(exp2(((select((((_430 + 20.0f) / _416) >= _438), ((_489 / exp2(log2((float((int)(((int)(uint)((int)(_489 > 0.0f))) - ((int)(uint)((int)(_489 < 0.0f))))) * exp2(log2(abs(_489)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_506 / exp2(log2((float((int)(((int)(uint)((int)(_506 > 0.0f))) - ((int)(uint)((int)(_506 < 0.0f))))) * exp2(log2(abs(_506)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _483)) + _441) * _416) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _590 = (saturate(exp2(((select((((_431 + 20.0f) / _416) >= _438), ((_530 / exp2(log2((float((int)(((int)(uint)((int)(_530 > 0.0f))) - ((int)(uint)((int)(_530 < 0.0f))))) * exp2(log2(abs(_530)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_547 / exp2(log2((float((int)(((int)(uint)((int)(_547 > 0.0f))) - ((int)(uint)((int)(_547 < 0.0f))))) * exp2(log2(abs(_547)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _483)) + _441) * _416) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _588 = _402;
                _589 = _403;
                _590 = _404;
              }
            }
            _965 = (mad(-0.07283977419137955f, _590, mad(-0.5876564383506775f, _589, (_588 * 1.6604962348937988f))) * _36);
            _966 = (mad(-0.008348013274371624f, _590, mad(1.1328951120376587f, _589, (_588 * -0.1245470941066742f))) * _36);
            _967 = (mad(1.118751049041748f, _590, mad(-0.10059737414121628f, _589, (_588 * -0.018153680488467216f))) * _36);
          } while (false);
#endif
        } else {
          if (_101) {
            _605 = max(_184, 0.0f);
            _606 = max(_185, 0.0f);
            _607 = max(_186, 0.0f);
            _608 = dot(float3(_605, _606, _607), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            do {
              _618 = _605;
              _619 = _606;
              _620 = _607;
              if (!(_608 == 0.0f)) {
                _613 = max(dot(float3(_184, _185, _186), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _608;
                _618 = (_613 * _605);
                _619 = (_613 * _606);
                _620 = (_613 * _607);
              }
              _626 = max(max(_618, max(_619, _620)), 0.0f);
              _628 = 1.0f / max(_626, 1.1754943508222875e-38f);
              _634 = (pow(_626, g_vTonemapGTParams.x));
              _642 = _634 / (((pow(_634, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
              _656 = exp2(log2(_628 * _618) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
              _657 = exp2(log2(_628 * _619) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
              _658 = exp2(log2(_628 * _620) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
              _663 = log2(_642);
              _691 = saturate(exp2(log2((exp2(_663 * g_vTonemapCrosstalk.x) * (1.0f - _656)) + _656) * g_vTonemapCrosstalkSaturation.x) * _642);
              _692 = saturate(exp2(log2((exp2(_663 * g_vTonemapCrosstalk.y) * (1.0f - _657)) + _657) * g_vTonemapCrosstalkSaturation.y) * _642);
              _693 = saturate(exp2(log2((exp2(_663 * g_vTonemapCrosstalk.z) * (1.0f - _658)) + _658) * g_vTonemapCrosstalkSaturation.z) * _642);
              do {
                _804 = _691;
                _805 = _692;
                _806 = _693;
                if (_28) {
                  do {
                    [branch]
                    if (!(_691 <= 0.0031308000907301903f)) {
                      _705 = (((pow(_691, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _705 = (_691 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_692 <= 0.0031308000907301903f)) {
                        _716 = (((pow(_692, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _716 = (_692 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_693 <= 0.0031308000907301903f)) {
                          _727 = (((pow(_693, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _727 = (_693 * 12.920000076293945f);
                        }
                        _734 = (saturate(_716) * 0.96875f) + 0.015625f;
                        _736 = max((saturate(_727) * 31.0f), 0.0f);
                        _737 = floor(_736);
                        _738 = _736 - _737;
                        _740 = (((saturate(_705) * 0.96875f) + 0.015625f) + _737) * 0.03125f;
                        _742 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_740, _734), 0.0f);
                        _746 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_740 + 0.03125f), _734), 0.0f);
                        _756 = ((_746.x - _742.x) * _738) + _742.x;
                        _757 = ((_746.y - _742.y) * _738) + _742.y;
                        _758 = ((_746.z - _742.z) * _738) + _742.z;
                        do {
                          [branch]
                          if (!(_756 <= 0.040449999272823334f)) {
                            _769 = exp2(log2((_756 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _769 = (_756 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_757 <= 0.040449999272823334f)) {
                              _780 = exp2(log2((_757 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _780 = (_757 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_758 <= 0.040449999272823334f)) {
                                _791 = exp2(log2((_758 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _791 = (_758 * 0.07739938050508499f);
                              }
                              _793 = dot(float3(_769, _780, _791), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _804 = (lerp(_793, _769, g_fTonemapSaturation));
                              _805 = (lerp(_793, _780, g_fTonemapSaturation));
                              _806 = (lerp(_793, _791, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _965 = (_804 * _36);
                _966 = (_805 * _36);
                _967 = (_806 * _36);
              } while (false);
            } while (false);
          } else {
            _815 = g_fMaxOutputNits * 0.012500000186264515f;
            _820 = max(abs(_184), max(abs(_185), abs(_186)));
            _822 = 1.0f / max(_820, 1.1754943508222875e-38f);
            _823 = _822 * _184;
            _824 = _822 * _185;
            _825 = _822 * _186;
            _835 = (_36 * 0.18000000715255737f) * exp2(log2((pow(_820, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
            _839 = dot(float3((_835 * _823), (_835 * _824), (_835 * _825)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _888 = exp2(log2(abs(_823)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_823 > 0.0f))) - ((int)(uint)((int)(_823 < 0.0f)))));
            _889 = exp2(log2(abs(_824)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_824 > 0.0f))) - ((int)(uint)((int)(_824 < 0.0f)))));
            _890 = exp2(log2(abs(_825)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_825 > 0.0f))) - ((int)(uint)((int)(_825 < 0.0f)))));
            _895 = log2(saturate(select((_839 <= 0.0f), _839, ((1.0f - exp2(log2(exp2((_839 / _815) * -1.4426950216293335f)))) * _815)) / _815));
            _908 = (exp2(_895 * g_vTonemapCrosstalk.x) * (1.0f - _888)) + _888;
            _909 = (exp2(_895 * g_vTonemapCrosstalk.y) * (1.0f - _889)) + _889;
            _910 = (exp2(_895 * g_vTonemapCrosstalk.z) * (1.0f - _890)) + _890;
            _942 = (float((int)(((int)(uint)((int)(_908 > 0.0f))) - ((int)(uint)((int)(_908 < 0.0f))))) * _835) * exp2(log2(abs(_908)) * g_vTonemapCrosstalkSaturation.x);
            _944 = (float((int)(((int)(uint)((int)(_909 > 0.0f))) - ((int)(uint)((int)(_909 < 0.0f))))) * _835) * exp2(log2(abs(_909)) * g_vTonemapCrosstalkSaturation.y);
            _946 = (float((int)(((int)(uint)((int)(_910 > 0.0f))) - ((int)(uint)((int)(_910 < 0.0f))))) * _835) * exp2(log2(abs(_910)) * g_vTonemapCrosstalkSaturation.z);
            _947 = dot(float3(_942, _944, _946), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _960 = select((_947 <= 0.0f), _947, ((1.0f - exp2(log2(exp2((_947 / _815) * -1.4426950216293335f)))) * _815)) * select((!(_947 == 0.0f)), (1.0f / _947), 0.0f);
            _965 = (_960 * _942);
            _966 = (_960 * _944);
            _967 = (_960 * _946);
          }
        }
      }
      _976 = (_965 * g_fTonemapBrightness);
      _977 = (_966 * g_fTonemapBrightness);
      _978 = (_967 * g_fTonemapBrightness);
    } while (false);
  } else {
    _976 = (_184 * _36);
    _977 = (_185 * _36);
    _978 = (_186 * _36);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _990 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1000 = _976 / _36;
    _1001 = _977 / _36;
    _1002 = _978 / _36;
    _1006 = 1.0f - sqrt(max(dot(float3(_1000, _1001, _1002), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
    _1012 = g_fFilmGrainIntensity * (_36 * 5.0f);
    _1026 = ((((_1012 * ((_990.x * 2.0f) + -1.0f)) * saturate(_1000)) * _1006) + _976);
    _1027 = ((((_1012 * ((_990.y * 2.0f) + -1.0f)) * _1006) * saturate(_1001)) + _977);
    _1028 = ((((_1012 * ((_990.z * 2.0f) + -1.0f)) * _1006) * saturate(_1002)) + _978);
  } else {
    _1026 = _976;
    _1027 = _977;
    _1028 = _978;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1035 = (g_bHDR == 0);
    do {
      _1062 = _1026;
      _1063 = _1027;
      _1064 = _1028;
      if (!(_1035 || (g_bHDR_scRGB == 0))) {
        _1049 = max(mad(0.043306104838848114f, _1028, mad(0.329291969537735f, _1027, (_1026 * 0.6274019479751587f))), 0.0f);
        _1050 = max(mad(0.0113602289929986f, _1028, mad(0.9195442795753479f, _1027, (_1026 * 0.06909549236297607f))), 0.0f);
        _1051 = max(mad(0.895578145980835f, _1028, mad(0.08802816271781921f, _1027, (_1026 * 0.016393709927797318f))), 0.0f);
        _1062 = mad(-0.07283977419137955f, _1051, mad(-0.5876564383506775f, _1050, (_1049 * 1.6604962348937988f)));
        _1063 = mad(-0.008348013274371624f, _1051, mad(1.1328951120376587f, _1050, (_1049 * -0.1245470941066742f)));
        _1064 = mad(1.118751049041748f, _1051, mad(-0.10059737414121628f, _1050, (_1049 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1035)) {
        _1080 = mad(0.043306104838848114f, _1064, mad(0.329291969537735f, _1063, (_1062 * 0.6274019479751587f)));
        _1081 = mad(0.0113602289929986f, _1064, mad(0.9195442795753479f, _1063, (_1062 * 0.06909549236297607f)));
        _1082 = mad(0.895578145980835f, _1064, mad(0.08802816271781921f, _1063, (_1062 * 0.016393709927797318f)));
      } else {
        _1080 = _1062;
        _1081 = _1063;
        _1082 = _1064;
      }
    } while (false);
  } else {
    _1080 = _1026;
    _1081 = _1027;
    _1082 = _1028;
  }
  SV_Target.x = _1080;
  SV_Target.y = _1081;
  SV_Target.z = _1082;
  SV_Target.w = 1.0f;
  return SV_Target;
}
