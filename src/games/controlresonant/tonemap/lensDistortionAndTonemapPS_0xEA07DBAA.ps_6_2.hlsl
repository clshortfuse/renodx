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
  float _112;
  float _132;
  float _133;
  float _134;
  float _172;
  float _173;
  float _174;
  float _394;
  float _395;
  float _396;
  float _732;
  float _733;
  float _734;
  float _762;
  float _763;
  float _764;
  float _849;
  float _860;
  float _871;
  float _913;
  float _924;
  float _935;
  float _948;
  float _949;
  float _950;
  float _1109;
  float _1110;
  float _1111;
  float _1120;
  float _1121;
  float _1122;
  float _1170;
  float _1171;
  float _1172;
  float _1229;
  float _1240;
  float _1251;
  float _1252;
  float _1253;
  bool _1282;
  float _1303;
  float _1304;
  float _1305;
  float _1338;
  float _1339;
  float _1340;
  float _1356;
  float _1357;
  float _1358;
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
  float _136;
  float _140;
  float _141;
  float _142;
  float _143;
  float _152;
  float _153;
  float _167;
  bool _177;
  float _193;
  float _194;
  float _195;
  float _223;
  float _224;
  float _225;
  int _229;
  int _230;
  int _231;
  float _235;
  float _236;
  float _237;
  int _242;
  int _247;
  int _252;
  bool _253;
  bool _254;
  bool _255;
  float4 _273;
  float4 _288;
  float4 _303;
  float4 _318;
  float _325;
  float _332;
  float _336;
  float _337;
  float _341;
  float _345;
  float _354;
  float _357;
  float _360;
  float _362;
  float _364;
  float _366;
  float _370;
  float _371;
  float _372;
  float _375;
  float _378;
  float _381;
  float _383;
  float _427;
  float _428;
  float _429;
  float _451;
  float _455;
  float _456;
  float _457;
  float _466;
  float _467;
  float _484;
  float _486;
  float _487;
  float _506;
  float _509;
  float _512;
  float _530;
  float _551;
  float _554;
  float _572;
  float _593;
  float _612;
  float _613;
  float _614;
  float _625;
  float _626;
  float _627;
  float _646;
  float _647;
  float _648;
  float _649;
  float _653;
  float _658;
  float _675;
  float _697;
  float _703;
  float _749;
  float _750;
  float _751;
  float _752;
  float _757;
  float _770;
  float _772;
  float _778;
  float _786;
  float _800;
  float _801;
  float _802;
  float _807;
  float _835;
  float _836;
  float _837;
  float _878;
  float _880;
  float _881;
  float _882;
  float _884;
  float4 _886;
  float4 _890;
  float _900;
  float _901;
  float _902;
  float _937;
  float _959;
  float _964;
  float _966;
  float _967;
  float _968;
  float _969;
  float _979;
  float _983;
  float _1032;
  float _1033;
  float _1034;
  float _1039;
  float _1052;
  float _1053;
  float _1054;
  float _1086;
  float _1088;
  float _1090;
  float _1091;
  float _1104;
  float4 _1134;
  float _1144;
  float _1145;
  float _1146;
  float _1150;
  float _1156;
  uint _1176;
  uint _1177;
  uint2 _1178;
  float4 _1192;
  float _1198;
  float _1200;
  float _1202;
  float _1206;
  float _1207;
  float _1208;
  float _1259;
  float _1262;
  float _1265;
  float _1269;
  float _1288;
  float _1298;
  bool _1311;
  float _1325;
  float _1326;
  float _1327;
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
  _102 = (g_bPostProcessApplyTonemap == 0);
  _104 = (g_bPostProcessApplyColorGrade != 0);
  if (!(_102)) {
    _112 = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  } else {
    _112 = 1.0f;
  }
  if (_104) {
    _132 = max(_97, 0.0f);
    _133 = max(_98, 0.0f);
    _134 = max(_99, 0.0f);
  } else {
    _132 = _97;
    _133 = _98;
    _134 = _99;
  }
  _136 = g_bBrightness[1];
  _140 = exp2(g_fExposureCompensationInEV100) * _136;
  _141 = _140 * _132;
  _142 = _140 * _133;
  _143 = _140 * _134;
  if (!(g_bApplyVignette == 0)) {
    _152 = ((((g_vOverriddenAspectRatioUVScale.x * _20) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.x + -1.0f) * 0.5f)) * 0.956250011920929f) * min((g_vScreenRes.x / g_vScreenRes.y), 1.7777777910232544f);
    _153 = (((g_vOverriddenAspectRatioUVScale.y * _21) + -0.5f) - ((g_vOverriddenAspectRatioUVScale.y + -1.0f) * 0.5f)) * 0.956250011920929f;
    _167 = saturate(exp2(log2(saturate(1.0f - sqrt((_152 * _152) + (_153 * _153))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _172 = (_167 * _141);
    _173 = (_167 * _142);
    _174 = (_167 * _143);
  } else {
    _172 = _141;
    _173 = _142;
    _174 = _143;
  }
  _177 = (g_bEnableHDRLUT == 0);
  if (!(_177 || (!_104))) {
    _193 = exp2(log2(saturate(_172 * 0.00800000037997961f)) * 0.1593017578125f);
    _194 = exp2(log2(saturate(_173 * 0.00800000037997961f)) * 0.1593017578125f);
    _195 = exp2(log2(saturate(_174 * 0.00800000037997961f)) * 0.1593017578125f);
    _223 = saturate(exp2(log2(((_193 * 18.8515625f) + 0.8359375f) / ((_193 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _224 = saturate(exp2(log2(((_194 * 18.8515625f) + 0.8359375f) / ((_194 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _225 = saturate(exp2(log2(((_195 * 18.8515625f) + 0.8359375f) / ((_195 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _229 = int(floor(_223));
    _230 = int(floor(_224));
    _231 = int(floor(_225));
    _235 = _223 - float((int)(_229));
    _236 = _224 - float((int)(_230));
    _237 = _225 - float((int)(_231));
    _242 = ((int)(uint)((int)(_237 > _235))) + ((int)(uint)((int)(_236 > _235)));
    _247 = ((int)(uint)((int)(_237 > _236))) + ((int)(uint)((int)(_235 >= _236)));
    _252 = ((int)(uint)((int)(_235 >= _237))) + ((int)(uint)((int)(_236 >= _237)));
    _253 = (_242 == 0);
    _254 = (_247 == 0);
    _255 = (_252 == 0);
    _273 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_231), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_229), (int)(0))), (int)(47))), min((int)(max((int)(_230), (int)(0))), (int)(47)), 0));
    _288 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_255))) + _231))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_253))) + _229))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_254))) + _230))), (int)(0))), (int)(47)), 0));
    _303 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_252 < (uint)2)))) + _231))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_242 < (uint)2)))) + _229))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_247 < (uint)2)))) + _230))), (int)(0))), (int)(47)), 0));
    _318 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_231 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_229 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_230 + 1u))), (int)(0))), (int)(47)), 0));
    _325 = dot(float3(_235, _236, _237), float3(((float)((bool)_253)), ((float)((bool)_254)), ((float)((bool)_255))));
    _332 = dot(float3(_235, _236, _237), float3(((float)((bool)(uint)(_242 == 2))), ((float)((bool)(uint)(_247 == 2))), ((float)((bool)(uint)(_252 == 2)))));
    _336 = (((_236 + _235) + _237) - _325) - _332;
    _337 = 1.0f - _325;
    _341 = _325 - _336;
    _345 = _336 - _332;
    _354 = (((_332 * _318.x) + (_337 * _273.x)) + (_341 * _288.x)) + (_345 * _303.x);
    _357 = (((_332 * _318.y) + (_337 * _273.y)) + (_341 * _288.y)) + (_345 * _303.y);
    _360 = (((_332 * _318.z) + (_337 * _273.z)) + (_341 * _288.z)) + (_345 * _303.z);
    _362 = mad(0.21580375730991364f, _360, mad(0.3963377773761749f, _357, _354));
    _364 = mad(-0.0638541728258133f, _360, mad(-0.10556134581565857f, _357, _354));
    _366 = mad(-1.2914855480194092f, _360, mad(-0.08948417752981186f, _357, _354));
    _370 = (_362 * _362) * _362;
    _371 = (_364 * _364) * _364;
    _372 = (_366 * _366) * _366;
    _375 = mad(0.23096993565559387f, _372, mad(-3.307711601257324f, _371, (_370 * 4.076741695404053f)));
    _378 = mad(-0.34131938219070435f, _372, mad(2.609757423400879f, _371, (_370 * -1.2684379816055298f)));
    _381 = mad(1.7076146602630615f, _372, mad(-0.7034186124801636f, _371, (_370 * -0.004196086432784796f)));
    _383 = dot(float3(_375, _378, _381), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _394 = (lerp(_383, _375, g_fTonemapSaturation));
    _395 = (lerp(_383, _378, g_fTonemapSaturation));
    _396 = (lerp(_383, _381, g_fTonemapSaturation));
  } else {
    _394 = _172;
    _395 = _173;
    _396 = _174;
  }
  if (!(_102)) {
    do {
      _1109 = _394;
      _1110 = _395;
      _1111 = _396;
      if (!(g_iTonemapper == 0)) {
        if (g_iTonemapper == 2) {
#if 1
          float3 agx_color = ApplyRemedyAgX(
              _394, _395, _396, _112,
              g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
              g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
              g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
              g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
              g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
              g_fAgxHDRRatio, g_fAgxHDRMidGrey,
              g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
              SV_Position.xy * g_vInvOutputRes, g_fAgxHDRSaturation);
          _1109 = agx_color.x;
          _1110 = agx_color.y;
          _1111 = agx_color.z;
#else
          _427 = max(_394, 0.0f);
          _428 = max(_395, 0.0f);
          _429 = max(_396, 0.0f);
          _451 = g_fAgxMaxEV - g_fAgxMinEV;
          _455 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _429, mad(g_vAgxInsetRow0.y, _428, (_427 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _451);
          _456 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _429, mad(g_vAgxInsetRow1.y, _428, (_427 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _451);
          _457 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _429, mad(g_vAgxInsetRow2.y, _428, (_427 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _451);
          _466 = (g_fAgxContrastSlope * (_455 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _467 = 1.0f / g_fAgxShoulderPower;
          _484 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
          _486 = _484 * (0.6060606241226196f - _455);
          _487 = 1.0f / g_fAgxToePower;
          _506 = -0.0f - g_fAgxToePrecalcConstant;
          _509 = select((_455 >= 0.6060606241226196f), ((_466 / exp2(log2((float((int)(((int)(uint)((int)(_466 > 0.0f))) - ((int)(uint)((int)(_466 < 0.0f))))) * exp2(log2(abs(_466)) * g_fAgxShoulderPower)) + 1.0f) * _467)) * g_fAgxShoulderPrecalcConstant), ((_486 / exp2(log2((float((int)(((int)(uint)((int)(_486 > 0.0f))) - ((int)(uint)((int)(_486 < 0.0f))))) * exp2(log2(abs(_486)) * g_fAgxToePower)) + 1.0f) * _487)) * _506)) + 0.4894371032714844f;
          _512 = (g_fAgxContrastSlope * (_456 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _530 = _484 * (0.6060606241226196f - _456);
          _551 = select((_456 >= 0.6060606241226196f), ((_512 / exp2(log2((float((int)(((int)(uint)((int)(_512 > 0.0f))) - ((int)(uint)((int)(_512 < 0.0f))))) * exp2(log2(abs(_512)) * g_fAgxShoulderPower)) + 1.0f) * _467)) * g_fAgxShoulderPrecalcConstant), ((_530 / exp2(log2((exp2(log2(abs(_530)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_530 > 0.0f))) - ((int)(uint)((int)(_530 < 0.0f)))))) + 1.0f) * _487)) * _506)) + 0.4894371032714844f;
          _554 = (g_fAgxContrastSlope * (_457 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
          _572 = _484 * (0.6060606241226196f - _457);
          _593 = select((_457 >= 0.6060606241226196f), ((_554 / exp2(log2((float((int)(((int)(uint)((int)(_554 > 0.0f))) - ((int)(uint)((int)(_554 < 0.0f))))) * exp2(log2(abs(_554)) * g_fAgxShoulderPower)) + 1.0f) * _467)) * g_fAgxShoulderPrecalcConstant), ((_572 / exp2(log2((exp2(log2(abs(_572)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_572 > 0.0f))) - ((int)(uint)((int)(_572 < 0.0f)))))) + 1.0f) * _487)) * _506)) + 0.4894371032714844f;
          _612 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _593, mad(g_vAgxOutsetRow0.y, _551, (_509 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
          _613 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _593, mad(g_vAgxOutsetRow1.y, _551, (_509 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
          _614 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _593, mad(g_vAgxOutsetRow2.y, _551, (_509 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
          do {
            _732 = _612;
            _733 = _613;
            _734 = _614;
            if (g_fAgxHDRRatio > 1.0f) {
              if (!(!(max(_612, max(_613, _614)) >= g_fAgxHDRMidGrey))) {
                _625 = log2(1.0f / g_fAgxHDRMidGrey);
                _626 = _625 + 20.0f;
                _627 = log2(g_fAgxHDRRatio);
                _646 = (min(max(log2(max(_612, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _625) + 20.0f) / _626;
                _647 = (min(max(log2(max(_613, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _625) + 20.0f) / _626;
                _648 = (min(max(log2(max(_614, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _625) + 20.0f) / _626;
                _649 = 20.0f / _626;
                _653 = max(_646, max(_647, _648));
                _658 = ((_653 - _649) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                _675 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_649 - _653);
                _697 = select((_653 >= _649), ((_658 / exp2(log2((float((int)(((int)(uint)((int)(_658 > 0.0f))) - ((int)(uint)((int)(_658 < 0.0f))))) * exp2(log2(abs(_658)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_675 / exp2(log2((float((int)(((int)(uint)((int)(_675 > 0.0f))) - ((int)(uint)((int)(_675 < 0.0f))))) * exp2(log2(abs(_675)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _627) / _626);
                _703 = exp2((((_697 - _653) * _626) + _627) * g_fAgxHDRSaturation);
                _732 = (saturate(exp2(((_697 + (_703 * (_646 - _653))) * _626) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _733 = (saturate(exp2(((_697 + (_703 * (_647 - _653))) * _626) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                _734 = (saturate(exp2(((_697 + (_703 * (_648 - _653))) * _626) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
              } else {
                _732 = _612;
                _733 = _613;
                _734 = _614;
              }
            }
            _1109 = (mad(-0.07283977419137955f, _734, mad(-0.5876564383506775f, _733, (_732 * 1.6604962348937988f))) * _112);
            _1110 = (mad(-0.008348013274371624f, _734, mad(1.1328951120376587f, _733, (_732 * -0.1245470941066742f))) * _112);
            _1111 = (mad(1.118751049041748f, _734, mad(-0.10059737414121628f, _733, (_732 * -0.018153680488467216f))) * _112);
          } while (false);
#endif
        } else {
          if (_177) {
            _749 = max(_394, 0.0f);
            _750 = max(_395, 0.0f);
            _751 = max(_396, 0.0f);
            _752 = dot(float3(_749, _750, _751), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            do {
              _762 = _749;
              _763 = _750;
              _764 = _751;
              if (!(_752 == 0.0f)) {
                _757 = max(dot(float3(_394, _395, _396), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _752;
                _762 = (_757 * _749);
                _763 = (_757 * _750);
                _764 = (_757 * _751);
              }
              _770 = max(max(_762, max(_763, _764)), 0.0f);
              _772 = 1.0f / max(_770, 1.1754943508222875e-38f);
              _778 = (pow(_770, g_vTonemapGTParams.x));
              _786 = _778 / (((pow(_778, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
              _800 = exp2(log2(_772 * _762) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
              _801 = exp2(log2(_772 * _763) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
              _802 = exp2(log2(_772 * _764) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
              _807 = log2(_786);
              _835 = saturate(exp2(log2((exp2(_807 * g_vTonemapCrosstalk.x) * (1.0f - _800)) + _800) * g_vTonemapCrosstalkSaturation.x) * _786);
              _836 = saturate(exp2(log2((exp2(_807 * g_vTonemapCrosstalk.y) * (1.0f - _801)) + _801) * g_vTonemapCrosstalkSaturation.y) * _786);
              _837 = saturate(exp2(log2((exp2(_807 * g_vTonemapCrosstalk.z) * (1.0f - _802)) + _802) * g_vTonemapCrosstalkSaturation.z) * _786);
              do {
                _948 = _835;
                _949 = _836;
                _950 = _837;
                if (_104) {
                  do {
                    [branch]
                    if (!(_835 <= 0.0031308000907301903f)) {
                      _849 = (((pow(_835, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _849 = (_835 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_836 <= 0.0031308000907301903f)) {
                        _860 = (((pow(_836, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _860 = (_836 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_837 <= 0.0031308000907301903f)) {
                          _871 = (((pow(_837, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _871 = (_837 * 12.920000076293945f);
                        }
                        _878 = (saturate(_860) * 0.96875f) + 0.015625f;
                        _880 = max((saturate(_871) * 31.0f), 0.0f);
                        _881 = floor(_880);
                        _882 = _880 - _881;
                        _884 = (((saturate(_849) * 0.96875f) + 0.015625f) + _881) * 0.03125f;
                        _886 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_884, _878), 0.0f);
                        _890 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_884 + 0.03125f), _878), 0.0f);
                        _900 = ((_890.x - _886.x) * _882) + _886.x;
                        _901 = ((_890.y - _886.y) * _882) + _886.y;
                        _902 = ((_890.z - _886.z) * _882) + _886.z;
                        do {
                          [branch]
                          if (!(_900 <= 0.040449999272823334f)) {
                            _913 = exp2(log2((_900 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                          } else {
                            _913 = (_900 * 0.07739938050508499f);
                          }
                          do {
                            [branch]
                            if (!(_901 <= 0.040449999272823334f)) {
                              _924 = exp2(log2((_901 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            } else {
                              _924 = (_901 * 0.07739938050508499f);
                            }
                            do {
                              [branch]
                              if (!(_902 <= 0.040449999272823334f)) {
                                _935 = exp2(log2((_902 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              } else {
                                _935 = (_902 * 0.07739938050508499f);
                              }
                              _937 = dot(float3(_913, _924, _935), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                              _948 = (lerp(_937, _913, g_fTonemapSaturation));
                              _949 = (lerp(_937, _924, g_fTonemapSaturation));
                              _950 = (lerp(_937, _935, g_fTonemapSaturation));
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                }
                _1109 = (_948 * _112);
                _1110 = (_949 * _112);
                _1111 = (_950 * _112);
              } while (false);
            } while (false);
          } else {
            _959 = g_fMaxOutputNits * 0.012500000186264515f;
            _964 = max(abs(_394), max(abs(_395), abs(_396)));
            _966 = 1.0f / max(_964, 1.1754943508222875e-38f);
            _967 = _966 * _394;
            _968 = _966 * _395;
            _969 = _966 * _396;
            _979 = (_112 * 0.18000000715255737f) * exp2(log2((pow(_964, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
            _983 = dot(float3((_979 * _967), (_979 * _968), (_979 * _969)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1032 = exp2(log2(abs(_967)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_967 > 0.0f))) - ((int)(uint)((int)(_967 < 0.0f)))));
            _1033 = exp2(log2(abs(_968)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_968 > 0.0f))) - ((int)(uint)((int)(_968 < 0.0f)))));
            _1034 = exp2(log2(abs(_969)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_969 > 0.0f))) - ((int)(uint)((int)(_969 < 0.0f)))));
            _1039 = log2(saturate(select((_983 <= 0.0f), _983, ((1.0f - exp2(log2(exp2((_983 / _959) * -1.4426950216293335f)))) * _959)) / _959));
            _1052 = (exp2(_1039 * g_vTonemapCrosstalk.x) * (1.0f - _1032)) + _1032;
            _1053 = (exp2(_1039 * g_vTonemapCrosstalk.y) * (1.0f - _1033)) + _1033;
            _1054 = (exp2(_1039 * g_vTonemapCrosstalk.z) * (1.0f - _1034)) + _1034;
            _1086 = (float((int)(((int)(uint)((int)(_1052 > 0.0f))) - ((int)(uint)((int)(_1052 < 0.0f))))) * _979) * exp2(log2(abs(_1052)) * g_vTonemapCrosstalkSaturation.x);
            _1088 = (float((int)(((int)(uint)((int)(_1053 > 0.0f))) - ((int)(uint)((int)(_1053 < 0.0f))))) * _979) * exp2(log2(abs(_1053)) * g_vTonemapCrosstalkSaturation.y);
            _1090 = (float((int)(((int)(uint)((int)(_1054 > 0.0f))) - ((int)(uint)((int)(_1054 < 0.0f))))) * _979) * exp2(log2(abs(_1054)) * g_vTonemapCrosstalkSaturation.z);
            _1091 = dot(float3(_1086, _1088, _1090), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
            _1104 = select((_1091 <= 0.0f), _1091, ((1.0f - exp2(log2(exp2((_1091 / _959) * -1.4426950216293335f)))) * _959)) * select((!(_1091 == 0.0f)), (1.0f / _1091), 0.0f);
            _1109 = (_1104 * _1086);
            _1110 = (_1104 * _1088);
            _1111 = (_1104 * _1090);
          }
        }
      }
      _1120 = (_1109 * g_fTonemapBrightness);
      _1121 = (_1110 * g_fTonemapBrightness);
      _1122 = (_1111 * g_fTonemapBrightness);
    } while (false);
  } else {
    _1120 = (_394 * _112);
    _1121 = (_395 * _112);
    _1122 = (_396 * _112);
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _1134 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    _1144 = _1120 / _112;
    _1145 = _1121 / _112;
    _1146 = _1122 / _112;
    _1150 = 1.0f - sqrt(max(dot(float3(_1144, _1145, _1146), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
    _1156 = g_fFilmGrainIntensity * (_112 * 5.0f);
    _1170 = ((((_1156 * ((_1134.x * 2.0f) + -1.0f)) * saturate(_1144)) * _1150) + _1120);
    _1171 = ((((_1156 * ((_1134.y * 2.0f) + -1.0f)) * _1150) * saturate(_1145)) + _1121);
    _1172 = ((((_1156 * ((_1134.z * 2.0f) + -1.0f)) * _1150) * saturate(_1146)) + _1122);
  } else {
    _1170 = _1120;
    _1171 = _1121;
    _1172 = _1122;
  }
  if (!(_39)) {
    _1176 = (uint)(int(SV_Position.x)) + (uint)(-96);
    _1177 = (uint)(int(SV_Position.y)) + (uint)(-48);
    uint2 _1178;
    g_tBaseColorCorrectionMap.GetDimensions(_1178.x, _1178.y);
    if (((int)_1177 < (int)int(float((int)((int)(_1178.y))))) && (((int)(_1177 | _1176) > (int)-1) && ((int)_1176 < (int)int(float((int)((int)(_1178.x))))))) {
      _1192 = g_tBaseColorCorrectionMap.Load(int3(_1176, _1177, 0));
      if (!(_177)) {
        _1198 = mad(0.21580375730991364f, _1192.z, mad(0.3963377773761749f, _1192.y, _1192.x));
        _1200 = mad(-0.0638541728258133f, _1192.z, mad(-0.10556134581565857f, _1192.y, _1192.x));
        _1202 = mad(-1.2914855480194092f, _1192.z, mad(-0.08948417752981186f, _1192.y, _1192.x));
        _1206 = (_1198 * _1198) * _1198;
        _1207 = (_1200 * _1200) * _1200;
        _1208 = (_1202 * _1202) * _1202;
        _1251 = mad(0.23096993565559387f, _1208, mad(-3.307711601257324f, _1207, (_1206 * 4.076741695404053f)));
        _1252 = mad(-0.34131938219070435f, _1208, mad(2.609757423400879f, _1207, (_1206 * -1.2684379816055298f)));
        _1253 = mad(1.7076146602630615f, _1208, mad(-0.7034186124801636f, _1207, (_1206 * -0.004196086432784796f)));
      } else {
        do {
          [branch]
          if (!(_1192.x <= 0.040449999272823334f)) {
            _1229 = exp2(log2((_1192.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
          } else {
            _1229 = (_1192.x * 0.07739938050508499f);
          }
          do {
            [branch]
            if (!(_1192.y <= 0.040449999272823334f)) {
              _1240 = exp2(log2((_1192.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1240 = (_1192.y * 0.07739938050508499f);
            }
            [branch]
            if (!(_1192.z <= 0.040449999272823334f)) {
              _1251 = _1229;
              _1252 = _1240;
              _1253 = exp2(log2((_1192.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
            } else {
              _1251 = _1229;
              _1252 = _1240;
              _1253 = (_1192.z * 0.07739938050508499f);
            }
          } while (false);
        } while (false);
      }
    } else {
      _1251 = _1170;
      _1252 = _1171;
      _1253 = _1172;
    }
  } else {
    _1251 = _1170;
    _1252 = _1171;
    _1253 = _1172;
  }
  if (!(g_bDebugValidateOutputRange == 0)) {
    _1259 = mad(0.043306104838848114f, _1253, mad(0.329291969537735f, _1252, (_1251 * 0.6274019479751587f)));
    _1262 = mad(0.0113602289929986f, _1253, mad(0.9195442795753479f, _1252, (_1251 * 0.06909549236297607f)));
    _1265 = mad(0.895578145980835f, _1253, mad(0.08802816271781921f, _1252, (_1251 * 0.016393709927797318f)));
    _1269 = max(1.0f, (g_fMaxOutputNits * 0.012500000186264515f));
    do {
      _1282 = true;
      if (!(((_1259 < 0.0f) || (_1262 < 0.0f)) || (_1265 < 0.0f))) {
        _1282 = ((_1265 > _1269) || ((_1259 > _1269) || (_1262 > _1269)));
      }
      if (_1282) {
        _1288 = float((int)(int(g_fRealTime * 15.0f)));
        _1298 = select((((((int)((uint)(int(SV_Position.y - _1288)) / 5u)) ^ ((int)((uint)(int(SV_Position.x - _1288)) / 5u))) & 1) == 0), 1.0f, 0.0f);
        _1303 = (_1298 * _1251);
        _1304 = (_1298 * _1252);
        _1305 = (_1298 * _1253);
      } else {
        _1303 = _1251;
        _1304 = _1252;
        _1305 = _1253;
      }
    } while (false);
  } else {
    _1303 = _1251;
    _1304 = _1252;
    _1305 = _1253;
  }
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _1311 = (g_bHDR == 0);
    do {
      _1338 = _1303;
      _1339 = _1304;
      _1340 = _1305;
      if (!(_1311 || (g_bHDR_scRGB == 0))) {
        _1325 = max(mad(0.043306104838848114f, _1305, mad(0.329291969537735f, _1304, (_1303 * 0.6274019479751587f))), 0.0f);
        _1326 = max(mad(0.0113602289929986f, _1305, mad(0.9195442795753479f, _1304, (_1303 * 0.06909549236297607f))), 0.0f);
        _1327 = max(mad(0.895578145980835f, _1305, mad(0.08802816271781921f, _1304, (_1303 * 0.016393709927797318f))), 0.0f);
        _1338 = mad(-0.07283977419137955f, _1327, mad(-0.5876564383506775f, _1326, (_1325 * 1.6604962348937988f)));
        _1339 = mad(-0.008348013274371624f, _1327, mad(1.1328951120376587f, _1326, (_1325 * -0.1245470941066742f)));
        _1340 = mad(1.118751049041748f, _1327, mad(-0.10059737414121628f, _1326, (_1325 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_1311)) {
        _1356 = mad(0.043306104838848114f, _1340, mad(0.329291969537735f, _1339, (_1338 * 0.6274019479751587f)));
        _1357 = mad(0.0113602289929986f, _1340, mad(0.9195442795753479f, _1339, (_1338 * 0.06909549236297607f)));
        _1358 = mad(0.895578145980835f, _1340, mad(0.08802816271781921f, _1339, (_1338 * 0.016393709927797318f)));
      } else {
        _1356 = _1338;
        _1357 = _1339;
        _1358 = _1340;
      }
    } while (false);
  } else {
    _1356 = _1303;
    _1357 = _1304;
    _1358 = _1305;
  }
  SV_Target.x = _1356;
  SV_Target.y = _1357;
  SV_Target.z = _1358;
  SV_Target.w = 1.0f;
  return SV_Target;
}
