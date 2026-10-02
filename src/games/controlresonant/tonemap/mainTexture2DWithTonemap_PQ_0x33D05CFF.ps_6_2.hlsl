#include "./tonemap.hlsli"

Texture2D<float4> g_tFilmGrain : register(t0);

Texture2D<float4> g_tBaseColorCorrectionMap : register(t1);

Texture2D<float4> g_tTexture2D : register(t2);

cbuffer shared_sys : register(b0) {
  float2 g_vScreenRes : packoffset(c000.x);
  float2 g_vInvScreenRes : packoffset(c000.z);
};

cbuffer shared_hdr_global : register(b1) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

cbuffer shared_tonemap_general : register(b2) {
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

cbuffer shared_tonemap_post : register(b3) {
  float g_fPaperWhite : packoffset(c000.x);
  int g_bApplyVignette : packoffset(c000.y);
  int g_bApplyFilmGrain : packoffset(c000.z);
};

cbuffer embedded_shapeengine : register(b4) {
  row_major float4x4 g_mShapeEngineLocalToClip : packoffset(c000.x);
  row_major float4x4 g_mShapeEngineColorTransform : packoffset(c004.x);
  float4 g_vShapeEngineColorAdd : packoffset(c008.x);
  float4 g_vShapeEngineCircle : packoffset(c009.x);
  float2 g_vShapeEngineInvTexSize : packoffset(c010.x);
  float2 g_vShapeEngineHalfPixelOffset : packoffset(c010.z);
  uint2 g_vShapeEngineInstanceDataOffsetAndStride : packoffset(c011.x);
  float g_fShapeEnginePointSize : packoffset(c011.z);
  int g_iShapeEngineInstanceStartIndex : packoffset(c011.w);
  float g_fGridPrimaryDivisions : packoffset(c012.x);
  float g_fGridSecondaryDivisions : packoffset(c012.y);
  float g_fGridPrimaryLineThickness : packoffset(c012.z);
  float g_fGridSecondaryLineThickness : packoffset(c012.w);
  float4 g_vGridPrimaryColor : packoffset(c013.x);
  float4 g_vGridSecondaryColor : packoffset(c014.x);
};

SamplerState g_sLinearClamp_internal : register(s6, space1);

SamplerState g_sSampler : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    linear float3 TEXCOORD: TEXCOORD,
    linear float4 COLOR: COLOR,
    precise noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float4 _19;
  float _30;
  float _31;
  float _32;
  float _54;
  float _57;
  float _58;
  float _68;
  float _69;
  float _70;
  float _71;
  uint2 _117;
  float _122;
  float _126;
  bool _127;
  float _130;
  float _131;
  bool _134;
  float _144;
  float _145;
  float _148;
  float _149;
  float _150;
  float _184;
  float _185;
  float _186;
  float _228;
  float _229;
  float _230;
  float _449;
  float _450;
  float _451;
  float _786;
  float _787;
  float _788;
  float _817;
  float _818;
  float _819;
  float _904;
  float _915;
  float _926;
  float _968;
  float _979;
  float _990;
  float _1161;
  float _1162;
  float _1163;
  float _1179;
  float _1180;
  float _1181;
  float _164;
  float _165;
  float _179;
  float4 _197;
  float _217;
  bool _233;
  float _247;
  float _248;
  float _249;
  float _277;
  float _278;
  float _279;
  int _283;
  int _284;
  int _285;
  float _289;
  float _290;
  float _291;
  int _296;
  int _301;
  int _306;
  bool _307;
  bool _308;
  bool _309;
  float4 _327;
  float4 _342;
  float4 _357;
  float4 _372;
  float _379;
  float _386;
  float _390;
  float _391;
  float _395;
  float _399;
  float _408;
  float _411;
  float _414;
  float _416;
  float _418;
  float _420;
  float _424;
  float _425;
  float _426;
  float _429;
  float _432;
  float _435;
  float _438;
  float _481;
  float _482;
  float _483;
  float _505;
  float _509;
  float _510;
  float _511;
  float _520;
  float _521;
  float _538;
  float _540;
  float _541;
  float _560;
  float _563;
  float _566;
  float _584;
  float _605;
  float _608;
  float _626;
  float _647;
  float _666;
  float _667;
  float _668;
  float _679;
  float _680;
  float _681;
  float _700;
  float _701;
  float _702;
  float _703;
  float _707;
  float _712;
  float _729;
  float _751;
  float _757;
  float _804;
  float _805;
  float _806;
  float _807;
  float _812;
  float _825;
  float _827;
  float _833;
  float _841;
  float _855;
  float _856;
  float _857;
  float _862;
  float _890;
  float _891;
  float _892;
  float _933;
  float _935;
  float _936;
  float _937;
  float _939;
  float4 _941;
  float4 _945;
  float _955;
  float _956;
  float _957;
  float _993;
  float _1011;
  float _1016;
  float _1018;
  float _1019;
  float _1020;
  float _1021;
  float _1031;
  float _1035;
  float _1084;
  float _1085;
  float _1086;
  float _1091;
  float _1104;
  float _1105;
  float _1106;
  float _1138;
  float _1140;
  float _1142;
  float _1143;
  float _1156;
  _19 = g_tTexture2D.Sample(g_sSampler, float2(TEXCOORD.x, TEXCOORD.y));
  _30 = (pow(_19.x, 0.012683313339948654f));
  _31 = (pow(_19.y, 0.012683313339948654f));
  _32 = (pow(_19.z, 0.012683313339948654f));
  _54 = exp2(log2(max((_30 + -0.8359375f), 0.0f) / (18.8515625f - (_30 * 18.6875f))) * 6.277394771575928f);
  _57 = exp2(log2(max((_31 + -0.8359375f), 0.0f) / (18.8515625f - (_31 * 18.6875f))) * 6.277394771575928f) * 125.0f;
  _58 = exp2(log2(max((_32 + -0.8359375f), 0.0f) / (18.8515625f - (_32 * 18.6875f))) * 6.277394771575928f) * 125.0f;
  _68 = mad(-0.07283977419137955f, _58, mad(-0.5876564383506775f, _57, (_54 * 207.56202697753906f))) * COLOR.x;
  _69 = mad(-0.008348013274371624f, _58, mad(1.1328951120376587f, _57, (_54 * -15.568387031555176f))) * COLOR.y;
  _70 = mad(1.118751049041748f, _58, mad(-0.10059737414121628f, _57, (_54 * -2.26921010017395f))) * COLOR.z;
  _71 = _19.w * COLOR.w;
  g_tTexture2D.GetDimensions(_117.x, _117.y);
  _122 = float((int)((int)(_117.x))) / float((int)((int)(_117.y)));
  _126 = g_vScreenRes.x / g_vScreenRes.y;
  _127 = (_122 >= _126);
  _130 = select(_127, 1.0f, (_126 / _122));
  _131 = select(_127, (_122 / _126), 1.0f);
  _134 = (g_bHDR == 0);
  _144 = g_vInvScreenRes.x * SV_Position.x;
  _145 = g_vInvScreenRes.y * SV_Position.y;
  _148 = max((g_vShapeEngineColorAdd.x + mad((g_mShapeEngineColorTransform[3].x), _71, mad((g_mShapeEngineColorTransform[2].x), _70, mad((g_mShapeEngineColorTransform[1].x), _69, ((g_mShapeEngineColorTransform[0].x) * _68))))), 0.0f);
  _149 = max((g_vShapeEngineColorAdd.y + mad((g_mShapeEngineColorTransform[3].y), _71, mad((g_mShapeEngineColorTransform[2].y), _70, mad((g_mShapeEngineColorTransform[1].y), _69, ((g_mShapeEngineColorTransform[0].y) * _68))))), 0.0f);
  _150 = max((g_vShapeEngineColorAdd.z + mad((g_mShapeEngineColorTransform[3].z), _71, mad((g_mShapeEngineColorTransform[2].z), _70, mad((g_mShapeEngineColorTransform[1].z), _69, ((g_mShapeEngineColorTransform[0].z) * _68))))), 0.0f);
  if (!(g_bApplyVignette == 0)) {
    _164 = ((((_130 * _144) + -0.5f) - ((_130 + -1.0f) * 0.5f)) * 0.956250011920929f) * min(_126, 1.7777777910232544f);
    _165 = (((_131 * _145) + -0.5f) - ((_131 + -1.0f) * 0.5f)) * 0.956250011920929f;
    _179 = saturate(exp2(log2(saturate(1.0f - sqrt((_164 * _164) + (_165 * _165))) + 0.05000000074505806f) * g_fVignetteExp) * 1.0499999523162842f);
    _184 = (_179 * _148);
    _185 = (_179 * _149);
    _186 = (_179 * _150);
  } else {
    _184 = _148;
    _185 = _149;
    _186 = _150;
  }
  if (!(g_bApplyFilmGrain == 0)) {
    _197 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(_144 * g_vScreenRes.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(_145 * g_vScreenRes.y)))) % 512), 0));
    _217 = g_fFilmGrainIntensity * ((1.0f - sqrt(max(dot(float3(_184, _185, _186), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f))) * 5.0f);
    _228 = (((_217 * ((_197.x * 2.0f) + -1.0f)) * saturate(_184)) + _184);
    _229 = (((_217 * ((_197.y * 2.0f) + -1.0f)) * saturate(_185)) + _185);
    _230 = (((_217 * ((_197.z * 2.0f) + -1.0f)) * saturate(_186)) + _186);
  } else {
    _228 = _184;
    _229 = _185;
    _230 = _186;
  }
  _233 = (g_bEnableHDRLUT == 0);
  if (!(_233)) {
    _247 = exp2(log2(saturate(_228 * 0.00800000037997961f)) * 0.1593017578125f);
    _248 = exp2(log2(saturate(_229 * 0.00800000037997961f)) * 0.1593017578125f);
    _249 = exp2(log2(saturate(_230 * 0.00800000037997961f)) * 0.1593017578125f);
    _277 = saturate(exp2(log2(((_247 * 18.8515625f) + 0.8359375f) / ((_247 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _278 = saturate(exp2(log2(((_248 * 18.8515625f) + 0.8359375f) / ((_248 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _279 = saturate(exp2(log2(((_249 * 18.8515625f) + 0.8359375f) / ((_249 * 18.6875f) + 1.0f)) * 78.84375f)) * 47.0f;
    _283 = int(floor(_277));
    _284 = int(floor(_278));
    _285 = int(floor(_279));
    _289 = _277 - float((int)(_283));
    _290 = _278 - float((int)(_284));
    _291 = _279 - float((int)(_285));
    _296 = ((int)(uint)((int)(_291 > _289))) + ((int)(uint)((int)(_290 > _289)));
    _301 = ((int)(uint)((int)(_291 > _290))) + ((int)(uint)((int)(_289 >= _290)));
    _306 = ((int)(uint)((int)(_289 >= _291))) + ((int)(uint)((int)(_290 >= _291)));
    _307 = (_296 == 0);
    _308 = (_301 == 0);
    _309 = (_306 == 0);
    _327 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(_285), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(_283), (int)(0))), (int)(47))), min((int)(max((int)(_284), (int)(0))), (int)(47)), 0));
    _342 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)(_309))) + _285))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)(_307))) + _283))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)(_308))) + _284))), (int)(0))), (int)(47)), 0));
    _357 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_306 < (uint)2)))) + _285))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_296 < (uint)2)))) + _283))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(((uint)((int)(uint)((int)((uint)_301 < (uint)2)))) + _284))), (int)(0))), (int)(47)), 0));
    _372 = g_tBaseColorCorrectionMap.Load(int3(((min((int)(max((int)(((int)(_285 + 1u))), (int)(0))), (int)(47)) * 48) + min((int)(max((int)(((int)(_283 + 1u))), (int)(0))), (int)(47))), min((int)(max((int)(((int)(_284 + 1u))), (int)(0))), (int)(47)), 0));
    _379 = dot(float3(_289, _290, _291), float3(((float)((bool)_307)), ((float)((bool)_308)), ((float)((bool)_309))));
    _386 = dot(float3(_289, _290, _291), float3(((float)((bool)(uint)(_296 == 2))), ((float)((bool)(uint)(_301 == 2))), ((float)((bool)(uint)(_306 == 2)))));
    _390 = (((_290 + _289) + _291) - _379) - _386;
    _391 = 1.0f - _379;
    _395 = _379 - _390;
    _399 = _390 - _386;
    _408 = (((_386 * _372.x) + (_391 * _327.x)) + (_395 * _342.x)) + (_399 * _357.x);
    _411 = (((_386 * _372.y) + (_391 * _327.y)) + (_395 * _342.y)) + (_399 * _357.y);
    _414 = (((_386 * _372.z) + (_391 * _327.z)) + (_395 * _342.z)) + (_399 * _357.z);
    _416 = mad(0.21580375730991364f, _414, mad(0.3963377773761749f, _411, _408));
    _418 = mad(-0.0638541728258133f, _414, mad(-0.10556134581565857f, _411, _408));
    _420 = mad(-1.2914855480194092f, _414, mad(-0.08948417752981186f, _411, _408));
    _424 = (_416 * _416) * _416;
    _425 = (_418 * _418) * _418;
    _426 = (_420 * _420) * _420;
    _429 = mad(0.23096993565559387f, _426, mad(-3.307711601257324f, _425, (_424 * 4.076741695404053f)));
    _432 = mad(-0.34131938219070435f, _426, mad(2.609757423400879f, _425, (_424 * -1.2684379816055298f)));
    _435 = mad(1.7076146602630615f, _426, mad(-0.7034186124801636f, _425, (_424 * -0.004196086432784796f)));
    _438 = dot(float3(_429, _432, _435), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
    _449 = (lerp(_438, _429, g_fTonemapSaturation));
    _450 = (lerp(_438, _432, g_fTonemapSaturation));
    _451 = (lerp(_438, _435, g_fTonemapSaturation));
  } else {
    _449 = _228;
    _450 = _229;
    _451 = _230;
  }
  if (!(g_iTonemapper == 0)) {
    if (g_iTonemapper == 2) {
#if 1
      if (TONE_MAP_TYPE == 0.f) {
        _481 = max(_449, 0.0f);
        _482 = max(_450, 0.0f);
        _483 = max(_451, 0.0f);
      } else {
        _481 = _449;
        _482 = _450;
        _483 = _451;
      }
      float3 agx_color = ApplyRemedyAgX(
          _481, _482, _483, ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR),
          g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
          g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
          g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
          g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
          g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
          g_fAgxHDRRatio, g_fAgxHDRMidGrey,
          g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
          float2(_144, _145), g_fAgxHDRSaturation);
      _1161 = agx_color.x;
      _1162 = agx_color.y;
      _1163 = agx_color.z;
#else
      _481 = max(_449, 0.0f);
      _482 = max(_450, 0.0f);
      _483 = max(_451, 0.0f);
      _505 = g_fAgxMaxEV - g_fAgxMinEV;
      _509 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _483, mad(g_vAgxInsetRow0.y, _482, (_481 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _505);
      _510 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _483, mad(g_vAgxInsetRow1.y, _482, (_481 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _505);
      _511 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _483, mad(g_vAgxInsetRow2.y, _482, (_481 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _505);
      _520 = (g_fAgxContrastSlope * (_509 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
      _521 = 1.0f / g_fAgxShoulderPower;
      _538 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
      _540 = _538 * (0.6060606241226196f - _509);
      _541 = 1.0f / g_fAgxToePower;
      _560 = -0.0f - g_fAgxToePrecalcConstant;
      _563 = select((_509 >= 0.6060606241226196f), ((_520 / exp2(log2((float((int)(((int)(uint)((int)(_520 > 0.0f))) - ((int)(uint)((int)(_520 < 0.0f))))) * exp2(log2(abs(_520)) * g_fAgxShoulderPower)) + 1.0f) * _521)) * g_fAgxShoulderPrecalcConstant), ((_540 / exp2(log2((float((int)(((int)(uint)((int)(_540 > 0.0f))) - ((int)(uint)((int)(_540 < 0.0f))))) * exp2(log2(abs(_540)) * g_fAgxToePower)) + 1.0f) * _541)) * _560)) + 0.4894371032714844f;
      _566 = (g_fAgxContrastSlope * (_510 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
      _584 = _538 * (0.6060606241226196f - _510);
      _605 = select((_510 >= 0.6060606241226196f), ((_566 / exp2(log2((float((int)(((int)(uint)((int)(_566 > 0.0f))) - ((int)(uint)((int)(_566 < 0.0f))))) * exp2(log2(abs(_566)) * g_fAgxShoulderPower)) + 1.0f) * _521)) * g_fAgxShoulderPrecalcConstant), ((_584 / exp2(log2((exp2(log2(abs(_584)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_584 > 0.0f))) - ((int)(uint)((int)(_584 < 0.0f)))))) + 1.0f) * _541)) * _560)) + 0.4894371032714844f;
      _608 = (g_fAgxContrastSlope * (_511 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
      _626 = _538 * (0.6060606241226196f - _511);
      _647 = select((_511 >= 0.6060606241226196f), ((_608 / exp2(log2((float((int)(((int)(uint)((int)(_608 > 0.0f))) - ((int)(uint)((int)(_608 < 0.0f))))) * exp2(log2(abs(_608)) * g_fAgxShoulderPower)) + 1.0f) * _521)) * g_fAgxShoulderPrecalcConstant), ((_626 / exp2(log2((exp2(log2(abs(_626)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_626 > 0.0f))) - ((int)(uint)((int)(_626 < 0.0f)))))) + 1.0f) * _541)) * _560)) + 0.4894371032714844f;
      _666 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _647, mad(g_vAgxOutsetRow0.y, _605, (_563 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
      _667 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _647, mad(g_vAgxOutsetRow1.y, _605, (_563 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
      _668 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _647, mad(g_vAgxOutsetRow2.y, _605, (_563 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
      do {
        _786 = _666;
        _787 = _667;
        _788 = _668;
        if (g_fAgxHDRRatio > 1.0f) {
          if (!(!(max(_666, max(_667, _668)) >= g_fAgxHDRMidGrey))) {
            _679 = log2(1.0f / g_fAgxHDRMidGrey);
            _680 = _679 + 20.0f;
            _681 = log2(g_fAgxHDRRatio);
            _700 = (min(max(log2(max(_666, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _679) + 20.0f) / _680;
            _701 = (min(max(log2(max(_667, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _679) + 20.0f) / _680;
            _702 = (min(max(log2(max(_668, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _679) + 20.0f) / _680;
            _703 = 20.0f / _680;
            _707 = max(_700, max(_701, _702));
            _712 = ((_707 - _703) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
            _729 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_703 - _707);
            _751 = select((_707 >= _703), ((_712 / exp2(log2((float((int)(((int)(uint)((int)(_712 > 0.0f))) - ((int)(uint)((int)(_712 < 0.0f))))) * exp2(log2(abs(_712)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_729 / exp2(log2((float((int)(((int)(uint)((int)(_729 > 0.0f))) - ((int)(uint)((int)(_729 < 0.0f))))) * exp2(log2(abs(_729)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _681) / _680);
            _757 = exp2((((_751 - _707) * _680) + _681) * g_fAgxHDRSaturation);
            _786 = (saturate(exp2(((_751 + (_757 * (_700 - _707))) * _680) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
            _787 = (saturate(exp2(((_751 + (_757 * (_701 - _707))) * _680) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
            _788 = (saturate(exp2(((_751 + (_757 * (_702 - _707))) * _680) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
          } else {
            _786 = _666;
            _787 = _667;
            _788 = _668;
          }
        }
        _1161 = (mad(-0.07283977419137955f, _788, mad(-0.5876564383506775f, _787, (_786 * 1.6604962348937988f))) * g_fPaperWhite);
        _1162 = (mad(-0.008348013274371624f, _788, mad(1.1328951120376587f, _787, (_786 * -0.1245470941066742f))) * g_fPaperWhite);
        _1163 = (mad(1.118751049041748f, _788, mad(-0.10059737414121628f, _787, (_786 * -0.018153680488467216f))) * g_fPaperWhite);
      } while (false);
#endif
    } else {
      if (_134 || _233) {
        _804 = max(_449, 0.0f);
        _805 = max(_450, 0.0f);
        _806 = max(_451, 0.0f);
        _807 = dot(float3(_804, _805, _806), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        do {
          _817 = _804;
          _818 = _805;
          _819 = _806;
          if (!(_807 == 0.0f)) {
            _812 = max(dot(float3(_449, _450, _451), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _807;
            _817 = (_812 * _804);
            _818 = (_812 * _805);
            _819 = (_812 * _806);
          }
          _825 = max(max(_817, max(_818, _819)), 0.0f);
          _827 = 1.0f / max(_825, 1.1754943508222875e-38f);
          _833 = (pow(_825, g_vTonemapGTParams.x));
          _841 = _833 / (((pow(_833, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
          _855 = exp2(log2(_827 * _817) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
          _856 = exp2(log2(_827 * _818) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
          _857 = exp2(log2(_827 * _819) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
          _862 = log2(_841);
          _890 = saturate(exp2(log2((exp2(_862 * g_vTonemapCrosstalk.x) * (1.0f - _855)) + _855) * g_vTonemapCrosstalkSaturation.x) * _841);
          _891 = saturate(exp2(log2((exp2(_862 * g_vTonemapCrosstalk.y) * (1.0f - _856)) + _856) * g_vTonemapCrosstalkSaturation.y) * _841);
          _892 = saturate(exp2(log2((exp2(_862 * g_vTonemapCrosstalk.z) * (1.0f - _857)) + _857) * g_vTonemapCrosstalkSaturation.z) * _841);
          if (_233) {
            do {
              [branch]
              if (!(_890 <= 0.0031308000907301903f)) {
                _904 = (((pow(_890, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
              } else {
                _904 = (_890 * 12.920000076293945f);
              }
              do {
                [branch]
                if (!(_891 <= 0.0031308000907301903f)) {
                  _915 = (((pow(_891, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                } else {
                  _915 = (_891 * 12.920000076293945f);
                }
                do {
                  [branch]
                  if (!(_892 <= 0.0031308000907301903f)) {
                    _926 = (((pow(_892, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                  } else {
                    _926 = (_892 * 12.920000076293945f);
                  }
                  _933 = (saturate(_915) * 0.96875f) + 0.015625f;
                  _935 = max((saturate(_926) * 31.0f), 0.0f);
                  _936 = floor(_935);
                  _937 = _935 - _936;
                  _939 = (((saturate(_904) * 0.96875f) + 0.015625f) + _936) * 0.03125f;
                  _941 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2(_939, _933), 0.0f);
                  _945 = g_tBaseColorCorrectionMap.SampleLevel(g_sLinearClamp_internal, float2((_939 + 0.03125f), _933), 0.0f);
                  _955 = ((_945.x - _941.x) * _937) + _941.x;
                  _956 = ((_945.y - _941.y) * _937) + _941.y;
                  _957 = ((_945.z - _941.z) * _937) + _941.z;
                  do {
                    [branch]
                    if (!(_955 <= 0.040449999272823334f)) {
                      _968 = exp2(log2((_955 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                    } else {
                      _968 = (_955 * 0.07739938050508499f);
                    }
                    do {
                      [branch]
                      if (!(_956 <= 0.040449999272823334f)) {
                        _979 = exp2(log2((_956 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                      } else {
                        _979 = (_956 * 0.07739938050508499f);
                      }
                      do {
                        [branch]
                        if (!(_957 <= 0.040449999272823334f)) {
                          _990 = exp2(log2((_957 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                        } else {
                          _990 = (_957 * 0.07739938050508499f);
                        }
                        _993 = dot(float3(_968, _979, _990), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                        _1161 = ((lerp(_993, _968, g_fTonemapSaturation)) * g_fPaperWhite);
                        _1162 = ((lerp(_993, _979, g_fTonemapSaturation)) * g_fPaperWhite);
                        _1163 = ((lerp(_993, _990, g_fTonemapSaturation)) * g_fPaperWhite);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } else {
            _1161 = _890;
            _1162 = _891;
            _1163 = _892;
          }
        } while (false);
      } else {
        _1011 = g_fMaxOutputNits * 0.012500000186264515f;
        _1016 = max(abs(_449), max(abs(_450), abs(_451)));
        _1018 = 1.0f / max(_1016, 1.1754943508222875e-38f);
        _1019 = _1018 * _449;
        _1020 = _1018 * _450;
        _1021 = _1018 * _451;
        _1031 = (g_fPaperWhite * 0.18000000715255737f) * exp2(log2((pow(_1016, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
        _1035 = dot(float3((_1031 * _1019), (_1031 * _1020), (_1031 * _1021)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _1084 = exp2(log2(abs(_1019)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_1019 > 0.0f))) - ((int)(uint)((int)(_1019 < 0.0f)))));
        _1085 = exp2(log2(abs(_1020)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_1020 > 0.0f))) - ((int)(uint)((int)(_1020 < 0.0f)))));
        _1086 = exp2(log2(abs(_1021)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_1021 > 0.0f))) - ((int)(uint)((int)(_1021 < 0.0f)))));
        _1091 = log2(saturate(select((_1035 <= 0.0f), _1035, ((1.0f - exp2(log2(exp2((_1035 / _1011) * -1.4426950216293335f)))) * _1011)) / _1011));
        _1104 = (exp2(_1091 * g_vTonemapCrosstalk.x) * (1.0f - _1084)) + _1084;
        _1105 = (exp2(_1091 * g_vTonemapCrosstalk.y) * (1.0f - _1085)) + _1085;
        _1106 = (exp2(_1091 * g_vTonemapCrosstalk.z) * (1.0f - _1086)) + _1086;
        _1138 = (float((int)(((int)(uint)((int)(_1104 > 0.0f))) - ((int)(uint)((int)(_1104 < 0.0f))))) * _1031) * exp2(log2(abs(_1104)) * g_vTonemapCrosstalkSaturation.x);
        _1140 = (float((int)(((int)(uint)((int)(_1105 > 0.0f))) - ((int)(uint)((int)(_1105 < 0.0f))))) * _1031) * exp2(log2(abs(_1105)) * g_vTonemapCrosstalkSaturation.y);
        _1142 = (float((int)(((int)(uint)((int)(_1106 > 0.0f))) - ((int)(uint)((int)(_1106 < 0.0f))))) * _1031) * exp2(log2(abs(_1106)) * g_vTonemapCrosstalkSaturation.z);
        _1143 = dot(float3(_1138, _1140, _1142), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
        _1156 = select((_1143 <= 0.0f), _1143, ((1.0f - exp2(log2(exp2((_1143 / _1011) * -1.4426950216293335f)))) * _1011)) * select((!(_1143 == 0.0f)), (1.0f / _1143), 0.0f);
        _1161 = (_1156 * _1138);
        _1162 = (_1156 * _1140);
        _1163 = (_1156 * _1142);
      }
    }
  } else {
    _1161 = _449;
    _1162 = _450;
    _1163 = _451;
  }
  if ((g_bHDR_scRGB == 0) && (!_134)) {
    _1179 = mad(0.043306104838848114f, _1163, mad(0.329291969537735f, _1162, (_1161 * 0.6274019479751587f)));
    _1180 = mad(0.0113602289929986f, _1163, mad(0.9195442795753479f, _1162, (_1161 * 0.06909549236297607f)));
    _1181 = mad(0.895578145980835f, _1163, mad(0.08802816271781921f, _1162, (_1161 * 0.016393709927797318f)));
  } else {
    _1179 = _1161;
    _1180 = _1162;
    _1181 = _1163;
  }
  SV_Target.x = _1179;
  SV_Target.y = _1180;
  SV_Target.z = _1181;
  SV_Target.w = (g_vShapeEngineColorAdd.w + mad((g_mShapeEngineColorTransform[3].w), _71, mad((g_mShapeEngineColorTransform[2].w), _70, mad((g_mShapeEngineColorTransform[1].w), _69, ((g_mShapeEngineColorTransform[0].w) * _68)))));
  return SV_Target;
}
