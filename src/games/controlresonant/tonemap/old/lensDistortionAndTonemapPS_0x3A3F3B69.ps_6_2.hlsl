#include "../tonemap.hlsli"

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
};

cbuffer shared_tonemap_post : register(b6) {
  float g_fPaperWhite : packoffset(c000.x);
  int g_bApplyVignette : packoffset(c000.y);
  int g_bApplyFilmGrain : packoffset(c000.z);
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
  float _20;
  float _21;
  float4 _22;
  float _35;
  float _36;
  float _37;
  float _97;
  float _98;
  float _99;
  float _113;
  float _133;
  float _134;
  float _135;
  float _173;
  float _174;
  float _175;
  float _261;
  float _262;
  float _263;
  float _665;
  float _666;
  float _667;
  float _691;
  float _692;
  float _693;
  float _779;
  float _790;
  float _801;
  float _843;
  float _854;
  float _865;
  float _878;
  float _879;
  float _880;
  float _885;
  float _886;
  float _887;
  float _896;
  float _897;
  float _898;
  float _996;
  float _997;
  float _998;
  float _1033;
  float _1044;
  float _1055;
  float _1056;
  float _1057;
  bool _1077;
  float _1098;
  float _1099;
  float _1100;
  float _1133;
  float _1134;
  float _1135;
  float _1151;
  float _1152;
  float _1153;
  float4 _30;
  bool _39;
  uint _43;
  uint _44;
  float _52;
  float _54;
  float _55;
  float _76;
  float _77;
  float _78;
  float _80;
  float _85;
  float _89;
  bool _102;
  bool _104;
  float _137;
  float _141;
  float _142;
  float _143;
  float _144;
  float _153;
  float _154;
  float _168;
  bool _178;
  float _194;
  float _195;
  float _196;
  float _224;
  float _226;
  float _227;
  float _228;
  float _230;
  float4 _232;
  float4 _236;
  float _246;
  float _247;
  float _248;
  float _250;
  float _269;
  float _270;
  float _271;
  float _318;
  float _322;
  float _323;
  float _324;
  float _333;
  float _334;
  float _351;
  float _353;
  float _354;
  float _373;
  float _376;
  float _379;
  float _397;
  float _418;
  float _421;
  float _439;
  float _460;
  float _479;
  float _480;
  float _481;
  float _492;
  float _493;
  float _506;
  float _507;
  float _508;
  float _515;
  float _518;
  float _523;
  float _538;
  float _541;
  float _560;
  float _566;
  float _583;
  float _607;
  float _624;
  float _681;
  float _686;
  float _699;
  float _701;
  float _707;
  float _715;
  float _729;
  float _730;
  float _731;
  float _736;
  float _764;
  float _765;
  float _766;
  float _808;
  float _810;
  float _811;
  float _812;
  float _814;
  float4 _816;
  float4 _820;
  float _830;
  float _831;
  float _832;
  float _867;
  float4 _910;
  float _917;
  float _918;
  float _919;
  float _922;
  float _923;
  float _924;
  float _928;
  float _933;
  float _947;
  float _948;
  float _949;
  float _954;
  float _955;
  float _956;
  float _957;
  float _965;
  float _972;
  float _973;
  float _974;
  float _978;
  float _985;
  uint _1002;
  uint _1003;
  uint2 _1004;
  float4 _1018;
  float _1064;
  float _1083;
  float _1093;
  bool _1106;
  float _1120;
  float _1121;
  float _1122;
  _20 = g_vInvOutputRes.x * SV_Position.x;
  _21 = g_vInvOutputRes.y * SV_Position.y;
  _22 = g_tSource.Sample(g_sLinearClamp_internal, float2(_20, _21));
  if (!(g_bDebugReferenceImage == 0)) {
    _30 = g_tSourceReferenceImage.Sample(g_sLinearClamp_internal, float2(_20, _21));
    _35 = _30.x;
    _36 = _30.y;
    _37 = _30.z;
  } else {
    _35 = _22.x;
    _36 = _22.y;
    _37 = _22.z;
  }
  _39 = (g_bDebugLUT == 0);
  if (!(_39)) {
    _43 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _44 = (uint)(int(SV_Position.y)) + (uint)(-112);
    if (((int)_44 < (int)300) && (((int)_43 < (int)500) && ((int)(_44 | _43) > (int)-1))) {
      _52 = float((int)(_43));
      _54 = _52 * 0.0020000000949949026f;
      _55 = float((int)(_44)) * 0.005333333276212215f;
      _76 = saturate(2.0f - (abs(frac(_55) + -0.5f) * 6.0f)) * 2.0f;
      _77 = saturate(2.0f - (abs(frac(_55 + 0.3333333432674408f) + -0.5f) * 6.0f)) * 2.0f;
      _78 = saturate(2.0f - (abs(frac(_55 + -0.3333333432674408f) + -0.5f) * 6.0f)) * 2.0f;
      _80 = g_bBrightness[0];
      _85 = _54 * _54;
      _89 = ((_52 * 0.25f) * (_85 * _85)) * (_80 / exp2(g_fExposureCompensationInEV100));
      _97 = ((_76 * _76) * _89);
      _98 = ((_77 * _77) * _89);
      _99 = ((_78 * _78) * _89);
    } else {
      _97 = _35;
      _98 = _36;
      _99 = _37;
    }
  } else {
    _97 = _35;
    _98 = _36;
    _99 = _37;
  }
  _102 = (g_bPostProcessApplyTonemap != 0);
  _104 = (g_bPostProcessApplyColorGrade != 0);
  if (!(g_bPostProcessApplyTonemap == 0)) {
    _113 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  } else {
    _113 = 1.0f;
  }
  if (_104) {
    _133 = max(_97, 0.0f);
    _134 = max(_98, 0.0f);
    _135 = max(_99, 0.0f);
  } else {
    _133 = _97;
    _134 = _98;
    _135 = _99;
  }
  _137 = g_bBrightness[1];
  _141 = exp2(g_fExposureCompensationInEV100) * _137;
  _142 = _141 * _133;
  _143 = _141 * _134;
  _144 = _141 * _135;
  if (!(g_bApplyVignette == 0)) {
    _153 = ((((g_vOverriddenAspectRatioUVScale.x * _20) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _154 = (((g_vOverriddenAspectRatioUVScale.y * _21) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _168 = saturate(exp2(log2(saturate(1.0f - sqrt((_153 * _153) + (_154 * _154))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _173 = (_168 * _142);
    _174 = (_168 * _143);
    _175 = (_168 * _144);
  } else {
    _173 = _142;
    _174 = _143;
    _175 = _144;
  }
  _178 = (g_bEnableHDRLUT == 0);
  if (!(_178 || (!_104))) {
    _194 = exp2(log2(saturate(_173 * 0.00800000037997961f)) * 0.1593017578125f);
    _195 = exp2(log2(saturate(_174 * 0.00800000037997961f)) * 0.1593017578125f);
    _196 = exp2(log2(saturate(_175 * 0.00800000037997961f)) * 0.1593017578125f);
    _224 = (exp2(log2(((_195 * 18.8515625f) + 0.8359375f) / ((_195 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
    _226 = max((exp2(log2(((_196 * 18.8515625f) + 0.8359375f) / ((_196 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
    _227 = floor(_226);
    _228 = _226 - _227;
    _230 = (((exp2(log2(((_194 * 18.8515625f) + 0.8359375f) / ((_194 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _227) * 0.02083333395421505f;
    _232 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_230, _224), 0.0f);
    _236 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_230 + 0.02083333395421505f), _224), 0.0f);
    _246 = ((_236.x - _232.x) * _228) + _232.x;
    _247 = ((_236.y - _232.y) * _228) + _232.y;
    _248 = ((_236.z - _232.z) * _228) + _232.z;
    _250 = dot(float3(_246, _247, _248), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _261 = (lerp(_250, _246, g_fTonemapSaturation));
    _262 = (lerp(_250, _247, g_fTonemapSaturation));
    _263 = (lerp(_250, _248, g_fTonemapSaturation));
  } else {
    _261 = _173;
    _262 = _174;
    _263 = _175;
  }
  if (_102) {
    do {
      _885 = _261;
      _886 = _262;
      _887 = _263;
      if (!(g_iTonemapper == 0)) {
        _269 = max(_261, 0.0f);
        _270 = max(_262, 0.0f);
        _271 = max(_263, 0.0f);
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _269, _270, _271, _113,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes);
          _885 = agx_color.x;
          _886 = agx_color.y;
          _887 = agx_color.z;
#else
          _318 = g_fAgxMaxEV - g_fAgxMinEV;
          _322 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _271, mad(g_vAgxInsetRow0.y, _270, (g_vAgxInsetRow0.x * _269))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _318);
          _323 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _271, mad(g_vAgxInsetRow1.y, _270, (g_vAgxInsetRow1.x * _269))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _318);
          _324 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _271, mad(g_vAgxInsetRow2.y, _270, (g_vAgxInsetRow2.x * _269))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _318);
          _333 = (g_fAgxContrastSlope * (_322 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _334 = 1.0f / g_fAgxShoulderPower;
          _351 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _353 = _351 * (0.6060606241226196f - _322);
          _354 = 1.0f / g_fAgxToePower;
          _373 = -0.0f - g_fAgxToePrecalcConstant;
          _376 = select((_322 >= 0.6060606241226196f), ((_333 / exp2(log2((float((int)(((int)(uint)((int)(_333 > 0.0f))) - ((int)(uint)((int)(_333 < 0.0f))))) * exp2(log2(abs(_333)) * g_fAgxShoulderPower)) + 1.0f) * _334)) * g_fAgxShoulderPrecalcConstant), ((_353 / exp2(log2((float((int)(((int)(uint)((int)(_353 > 0.0f))) - ((int)(uint)((int)(_353 < 0.0f))))) * exp2(log2(abs(_353)) * g_fAgxToePower)) + 1.0f) * _354)) * _373)) + 0.4894371032714844f;
          _379 = (g_fAgxContrastSlope * (_323 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _397 = _351 * (0.6060606241226196f - _323);
          _418 = select((_323 >= 0.6060606241226196f), ((_379 / exp2(log2((float((int)(((int)(uint)((int)(_379 > 0.0f))) - ((int)(uint)((int)(_379 < 0.0f))))) * exp2(log2(abs(_379)) * g_fAgxShoulderPower)) + 1.0f) * _334)) * g_fAgxShoulderPrecalcConstant), ((_397 / exp2(log2((exp2(log2(abs(_397)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_397 > 0.0f))) - ((int)(uint)((int)(_397 < 0.0f)))))) + 1.0f) * _354)) * _373)) + 0.4894371032714844f;
          _421 = (g_fAgxContrastSlope * (_324 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _439 = _351 * (0.6060606241226196f - _324);
          _460 = select((_324 >= 0.6060606241226196f), ((_421 / exp2(log2((float((int)(((int)(uint)((int)(_421 > 0.0f))) - ((int)(uint)((int)(_421 < 0.0f))))) * exp2(log2(abs(_421)) * g_fAgxShoulderPower)) + 1.0f) * _334)) * g_fAgxShoulderPrecalcConstant), ((_439 / exp2(log2((exp2(log2(abs(_439)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_439 > 0.0f))) - ((int)(uint)((int)(_439 < 0.0f)))))) + 1.0f) * _354)) * _373)) + 0.4894371032714844f;
          _479 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _460, mad(g_vAgxOutsetRow0.y, _418, (_376 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _480 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _460, mad(g_vAgxOutsetRow1.y, _418, (_376 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _481 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _460, mad(g_vAgxOutsetRow2.y, _418, (_376 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _665 = _479;
            _666 = _480;
            _667 = _481;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_479, max(_480, _481)) >= g_fAgxHDRMidGrey))) {
                _492 = log2(1.0f / g_fAgxHDRMidGrey);
                _493 = _492 + 20.0f;
                _506 = min(max(log2(max(_479, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _492);
                _507 = min(max(log2(max(_480, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _492);
                _508 = min(max(log2(max(_481, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _492);
                _515 = 20.0f / _493;
                _518 = (20.0f - log2(g_fAgxHDRRatio)) / _493;
                _523 = ((_506 / _493) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _538 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                _541 = ((-0.0f - _506) / _493) * _538;
                _560 = -0.0f - g_fAgxHDRToePrecalcConstant;
                _566 = ((_507 / _493) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _583 = ((-0.0f - _507) / _493) * _538;
                _607 = ((_508 / _493) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _624 = ((-0.0f - _508) / _493) * _538;
                _665 = (saturate(exp2(((select((((_506 + 20.0f) / _493) >= _515), ((_523 / exp2(log2((float((int)(((int)(uint)((int)(_523 > 0.0f))) - ((int)(uint)((int)(_523 < 0.0f))))) * exp2(log2(abs(_523)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_541 / exp2(log2((float((int)(((int)(uint)((int)(_541 > 0.0f))) - ((int)(uint)((int)(_541 < 0.0f))))) * exp2(log2(abs(_541)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _560)) + _518) * _493) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _666 = (saturate(exp2(((select((((_507 + 20.0f) / _493) >= _515), ((_566 / exp2(log2((float((int)(((int)(uint)((int)(_566 > 0.0f))) - ((int)(uint)((int)(_566 < 0.0f))))) * exp2(log2(abs(_566)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_583 / exp2(log2((float((int)(((int)(uint)((int)(_583 > 0.0f))) - ((int)(uint)((int)(_583 < 0.0f))))) * exp2(log2(abs(_583)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _560)) + _518) * _493) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _667 = (saturate(exp2(((select((((_508 + 20.0f) / _493) >= _515), ((_607 / exp2(log2((float((int)(((int)(uint)((int)(_607 > 0.0f))) - ((int)(uint)((int)(_607 < 0.0f))))) * exp2(log2(abs(_607)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_624 / exp2(log2((float((int)(((int)(uint)((int)(_624 > 0.0f))) - ((int)(uint)((int)(_624 < 0.0f))))) * exp2(log2(abs(_624)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _560)) + _518) * _493) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _665 = _479;
                _666 = _480;
                _667 = _481;
              }
            }
            _885 = (mad(-0.07283977419137955f, _667, mad(-0.5876564383506775f, _666, (_665 * 1.6604962348937988f))) * _113);
            _886 = (mad(-0.008348013274371624f, _667, mad(1.1328951120376587f, _666, (_665 * -0.1245470941066742f))) * _113);
            _887 = (mad(1.118751049041748f, _667, mad(-0.10059737414121628f, _666, (_665 * -0.018153680488467216f))) * _113);
          } while (false);
#endif
        } else {
          _681 = dot(float3(_269, _270, _271), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
          do {
            _691 = _269;
            _692 = _270;
            _693 = _271;
            if (!(_681 == 0.0f)) {
              _686 = max(dot(float3(_261, _262, _263), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _681;
              _691 = (_686 * _269);
              _692 = (_686 * _270);
              _693 = (_686 * _271);
            }
            _699 = max(max(_691, max(_692, _693)), 0.0f);
            _701 = 1.0f / max(_699, 1.1754943508222875e-38f);
            _707 = (pow(_699, g_vTonemapGTParams.x));
            _715 = _707 / (((pow(_707, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
            _729 = exp2(log2(_701 * _691) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
            _730 = exp2(log2(_701 * _692) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
            _731 = exp2(log2(_701 * _693) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
            _736 = log2(_715);
            _764 = saturate(exp2(log2((exp2(_736 * g_vTonemapCrosstalk.x) * (1.0f - _729)) + _729) * g_vTonemapCrosstalkSaturation.x) * _715);
            _765 = saturate(exp2(log2((exp2(_736 * g_vTonemapCrosstalk.y) * (1.0f - _730)) + _730) * g_vTonemapCrosstalkSaturation.y) * _715);
            _766 = saturate(exp2(log2((exp2(_736 * g_vTonemapCrosstalk.z) * (1.0f - _731)) + _731) * g_vTonemapCrosstalkSaturation.z) * _715);
            if (_178) {
              do {
                _878 = _764;
                _879 = _765;
                _880 = _766;
                if (_104) {
                  do {
                    [branch]
                    if (!(_764 <= 0.0031308000907301903f)) {
                      _779 = (((pow(_764, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _779 = (_764 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_765 <= 0.0031308000907301903f)) {
                        _790 = (((pow(_765, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _790 = (_765 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_766 <= 0.0031308000907301903f)) {
                          _801 = (((pow(_766, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _801 = (_766 * 12.920000076293945f);
                        }
                        _808 = (saturate(_790) * 0.96875f) + 0.015625f;
                        _810 = max((saturate(_801) * 31.0f), 0.0f);
                        _811 = floor(_810);
                        _812 = _810 - _811;
                        _814 = (((saturate(_779) * 0.96875f) + 0.015625f) + _811) * 0.03125f;
                        _816 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_814, _808), 0.0f);
                        _820 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_814 + 0.03125f), _808), 0.0f);
                        _830 = ((_820.x - _816.x) * _812) + _816.x;
                        _831 = ((_820.y - _816.y) * _812) + _816.y;
                        _832 = ((_820.z - _816.z) * _812) + _816.z;
                        do {
                          [branch]
                          if (!(_830 <= 0.040449999272823334f)) {
                            _843 = exp2(log2((_830 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _843 = (_830 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_831 <= 0.040449999272823334f)) {
                              _854 = exp2(log2((_831 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _854 = (_831 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_832 <= 0.040449999272823334f)) {
                                _865 = exp2(log2((_832 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _865 = (_832 * 0.07739938050508499f);
                              }
                              _867 = dot(float3(_843, _854, _865), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _878 = (lerp(_867, _843, g_fTonemapSaturation));
                              _879 = (lerp(_867, _854, g_fTonemapSaturation));
                              _880 = (lerp(_867, _865, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _885 = (_878 * _113);
                _886 = (_879 * _113);
                _887 = (_880 * _113);
              } while (false);
            } else {
              _885 = _764;
              _886 = _765;
              _887 = _766;
            }
          } while (false);
        }
      }
      _896 = (_885 * g_fTonemapBrightness);
      _897 = (_886 * g_fTonemapBrightness);
      _898 = (_887 * g_fTonemapBrightness);
    } while (false);
  } else {
    _896 = (_261 * _113);
    _897 = (_262 * _113);
    _898 = (_263 * _113);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _910 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _917 = (_910.x * 2.0f) + -1.0f;
    _918 = (_910.y * 2.0f) + -1.0f;
    _919 = (_910.z * 2.0f) + -1.0f;
    if (!(_102)) {
      _922 = _896 / _113;
      _923 = _897 / _113;
      _924 = _898 / _113;
      _928 = 1.0f - sqrt(max(dot(float3(_922, _923, _924), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
      _933 = g_fFilmGrainIntensity * (_113 * 5.0f);
      _996 = ((((_933 * _917) * saturate(_922)) * _928) + _896);
      _997 = ((((_933 * _918) * _928) * saturate(_923)) + _897);
      _998 = ((((_933 * _919) * _928) * saturate(_924)) + _898);
    } else {
      _947 = saturate(_896);
      _948 = saturate(_897);
      _949 = saturate(_898);
      _954 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_947, max(_948, _949))));
      _955 = _954 * _947;
      _956 = _954 * _948;
      _957 = _954 * _949;
      _965 = ((1.0f - sqrt(dot(float3(_955, _956, _957), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * g_fFilmGrainIntensity;
      _972 = ((_965 * _917) * min(1.0f, _955)) + _955;
      _973 = ((_965 * _918) * min(1.0f, _956)) + _956;
      _974 = ((_965 * _919) * min(1.0f, _957)) + _957;
      _978 = 1.0f / (max(_972, max(_973, _974)) + 1.0f);
      _985 = 1.0f / (max(_955, max(_956, _957)) + 1.0f);
      _996 = (((_972 * _978) + _896) - (_985 * _955));
      _997 = (((_973 * _978) + _897) - (_985 * _956));
      _998 = (((_974 * _978) + _898) - (_985 * _957));
    }
  } else {
    _996 = _896;
    _997 = _897;
    _998 = _898;
  }
  if (!(_39)) {
    _1002 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _1003 = (uint)(int(SV_Position.y)) + (uint)(-48);
    uint2 _1004;
    g_tBaseColorCorrectionMap.GetDimensions(_1004.x, _1004.y);
    if (((int)_1003 < (int)int(float((int)((int)(_1004.y))))) && (((int)(_1003 | _1002) > (int)-1) && ((int)_1002 < (int)int(float((int)((int)(_1004.x))))))) {
      _1018 = g_tBaseColorCorrectionMap.Load(int3(_1002, _1003, 0));
      if (_178) {
        do {
          [branch]
          if (!(_1018.x <= 0.040449999272823334f)) {
            _1033 = exp2(log2((_1018.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
          } else {
            _1033 = (_1018.x * 0.07739938050508499f);
          }
          do {
            [branch]
            if (!(_1018.y <= 0.040449999272823334f)) {
              _1044 = exp2(log2((_1018.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1044 = (_1018.y * 0.07739938050508499f);
            }
            [branch]
            if (!(_1018.z <= 0.040449999272823334f)) {
              _1055 = _1033;
              _1056 = _1044;
              _1057 = exp2(log2((_1018.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1055 = _1033;
              _1056 = _1044;
              _1057 = (_1018.z * 0.07739938050508499f);
            }
          } while (false);
        } while (false);
      } else {
        _1055 = _1018.x;
        _1056 = _1018.y;
        _1057 = _1018.z;
      }
    } else {
      _1055 = _996;
      _1056 = _997;
      _1057 = _998;
    }
  } else {
    _1055 = _996;
    _1056 = _997;
    _1057 = _998;
  }
  if (!(g_bDebugValidateOutputRange == 0)) {
    _1064 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
    do {
      _1077 = true;
      if (!(((_1055 < 0.0f) || (_1056 < 0.0f)) || (_1057 < 0.0f))) {
        _1077 = ((_1057 > _1064) || ((_1055 > _1064) || (_1056 > _1064)));
      }
      if (_1077) {
        _1083 = float((int)(int(g_fRealTime * 15.0f)));
        _1093 = select((((((int)((uint)(int(SV_Position.y - _1083)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1083)) / 5u))) & 1) == 0), 1.0f, 0.0f);
        _1098 = (_1093 * _1055);
        _1099 = (_1093 * _1056);
        _1100 = (_1093 * _1057);
      } else {
        _1098 = _1055;
        _1099 = _1056;
        _1100 = _1057;
      }
    } while (false);
  } else {
    _1098 = _1055;
    _1099 = _1056;
    _1100 = _1057;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1106 = (g_bHDR == 0);
    do {
      _1133 = _1098;
      _1134 = _1099;
      _1135 = _1100;
      if (!(_1106 || (g_bHDR_scRGB == 0))) {
        _1120 = max(mad(0.043306104838848114f, _1100, mad(0.329291969537735f, _1099, (_1098 * 0.6274019479751587f))), 0.0f);
        _1121 = max(mad(0.0113602289929986f, _1100, mad(0.9195442795753479f, _1099, (_1098 * 0.06909549236297607f))), 0.0f);
        _1122 = max(mad(0.895578145980835f, _1100, mad(0.08802816271781921f, _1099, (_1098 * 0.016393709927797318f))), 0.0f);
        _1133 = mad(-0.07283977419137955f, _1122, mad(-0.5876564383506775f, _1121, (_1120 * 1.6604962348937988f)));
        _1134 = mad(-0.008348013274371624f, _1122, mad(1.1328951120376587f, _1121, (_1120 * -0.1245470941066742f)));
        _1135 = mad(1.118751049041748f, _1122, mad(-0.10059737414121628f, _1121, (_1120 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1106)) {
        _1151 = mad(0.043306104838848114f, _1135, mad(0.329291969537735f, _1134, (_1133 * 0.6274019479751587f)));
        _1152 = mad(0.0113602289929986f, _1135, mad(0.9195442795753479f, _1134, (_1133 * 0.06909549236297607f)));
        _1153 = mad(0.895578145980835f, _1135, mad(0.08802816271781921f, _1134, (_1133 * 0.016393709927797318f)));
      } else {
        _1151 = _1133;
        _1152 = _1134;
        _1153 = _1135;
      }
    } while (false);
  } else {
    _1151 = _1098;
    _1152 = _1099;
    _1153 = _1100;
  }
  SV_Target.x = _1151;
  SV_Target.y = _1152;
  SV_Target.z = _1153;
  SV_Target.w = 1.0f;
  return SV_Target;
}
