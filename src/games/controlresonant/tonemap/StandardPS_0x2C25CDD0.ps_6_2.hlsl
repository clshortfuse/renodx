#include "./tonemap.hlsli"
#include "../composeSceneAndUICS/composeSceneAndUICS.hlsli"

Texture2D<float4> g_tRandomBlueNoiseRGBA : register(t3);

Texture2D<float4> txBuffer : register(t0);

Texture2D<float4> txBuffer1 : register(t1);

Texture2D<float4> txBuffer2 : register(t2);

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
};

cbuffer shared_tonemap_post : register(b3) {
  float g_fPaperWhite : packoffset(c000.x);
  int g_bApplyVignette : packoffset(c000.y);
  int g_bApplyFilmGrain : packoffset(c000.z);
};

cbuffer ManualUpdateCB_DataPS : register(b0) {
  struct {
    float4 Data_PS[2048];
  }
ManualUpdateCB_DataPS_view:
  packoffset(c000.x);

  // Raw views preserve dynamic cbufferLoadLegacy.f32/i32 access.
  float4 ManualUpdateCB_DataPS_raw[2048] : packoffset(c0);
  uint4 ManualUpdateCB_DataPS_raw_uint[2048] : packoffset(c0);
};

cbuffer GameFace_Remedy : register(b4) {
  int txBufferIsUserBackground : packoffset(c000.x);
  int txBufferIsDisplayCalibration : packoffset(c000.y);
  int txBufferIsPureAdditive : packoffset(c000.z);
  int txBufferIsBT2100Encoded : packoffset(c000.w);
  int txBufferIsLinearUserTexture : packoffset(c001.x);
  float fUIHDRBackdropBackgroundDarkeningStrength : packoffset(c001.y);
};

SamplerState samplercoherenttxBuffer : register(s0);

SamplerState samplercoherenttxBuffer1 : register(s1);

SamplerState samplercoherenttxBuffer2 : register(s2);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1,
    linear float3 TEXCOORD_2: TEXCOORD2,
    nointerpolation uint4 TEXCOORD_3: TEXCOORD3,
    noperspective float4 TEXCOORD_4: TEXCOORD4) : SV_Target {
  float4 SV_Target;
  int _25;
  float4 _26;
  float4 _30;
  int _35;
  float4 _38;
  int _40;
  int _42;
  float _66;
  float _67;
  float _95;
  float _96;
  float _97;
  float _533;
  float _534;
  float _535;
  float _566;
  float _567;
  float _568;
  float _803;
  float _804;
  float _805;
  float _860;
  float _861;
  float _862;
  float _884;
  float _895;
  float _906;
  float _968;
  float _969;
  float _970;
  float _1129;
  float _1140;
  float _1169;
  float _1180;
  float _1191;
  float _1192;
  float _1193;
  float _1209;
  float _1218;
  float _1219;
  float _1220;
  float _1221;
  float _1222;
  float _1223;
  float _1231;
  float _1232;
  float _1233;
  float _1288;
  float _1289;
  float _1290;
  float _1291;
  float _1292;
  float4 _50;
  float4 _68;
  bool _79;
  float _104;
  float _119;
  float _162;
  float _163;
  float _164;
  float _186;
  float _190;
  float _191;
  float _192;
  float _201;
  float _202;
  float _219;
  float _221;
  float _222;
  float _241;
  float _244;
  float _247;
  float _265;
  float _286;
  float _289;
  float _307;
  float _328;
  float _347;
  float _348;
  float _349;
  float _360;
  float _361;
  float _374;
  float _375;
  float _376;
  float _383;
  float _386;
  float _391;
  float _406;
  float _409;
  float _428;
  float _434;
  float _451;
  float _475;
  float _492;
  float _553;
  float _554;
  float _555;
  float _556;
  float _561;
  float _574;
  float _576;
  float _582;
  float _590;
  float _604;
  float _605;
  float _606;
  float _611;
  float _639;
  float _640;
  float _641;
  float _653;
  float _658;
  float _660;
  float _661;
  float _662;
  float _663;
  float _673;
  float _677;
  float _726;
  float _727;
  float _728;
  float _733;
  float _746;
  float _747;
  float _748;
  float _780;
  float _782;
  float _784;
  float _785;
  float _798;
  float _821;
  float _822;
  float _823;
  float _845;
  float _848;
  float _849;
  float _865;
  float4 _918;
  float _922;
  float _923;
  float _924;
  float _971;
  float _980;
  float _983;
  float4 _994;
  float _1002;
  float _1003;
  float _1004;
  float _1005;
  float4 _1006;
  float4 _1012;
  float4 _1018;
  float4 _1024;
  float4 _1030;
  float _1045;
  float4 _1053;
  float _1063;
  float _1068;
  float _1079;
  float _1083;
  float _1088;
  float4 _1107;
  int _1194;
  int _1199;
  float _1236;
  float _1237;
  float _1238;
  float _1239;
  float4 _1240;
  float4 _1246;
  float4 _1252;
  float4 _1258;
  float4 _1264;
  float _1273;
  float _1274;
  float _1275;
  float _1282;
  _25 = ((int)(TEXCOORD_3.z << 4)) | (((uint)((uint)(TEXCOORD_3.y)) >> 4) & 15);
  _26 = ManualUpdateCB_DataPS_raw[_25];
  _30 = ManualUpdateCB_DataPS_raw[((int)(_25 + 1))];
  _35 = int(_26.x);
  _38 = ManualUpdateCB_DataPS_raw[(int)(max((int)(0), (int)((_35 + -1))))];
  _40 = int(_38.y);
  _42 = int(_38.z);
  if (TEXCOORD_3.w == 0) {
    _1218 = _30.x;
    _1219 = _30.y;
    _1220 = _30.z;
    _1221 = _30.w;
    _1222 = 1.0f;
    _1223 = min(1.0f, (TEXCOORD_1.w * TEXCOORD_1.z));
    do {
      _1231 = _1218;
      _1232 = _1219;
      _1233 = _1220;
      if (!((_40 & 64) == 0)) {
        _1231 = (_1221 * _1218);
        _1232 = (_1221 * _1219);
        _1233 = (_1221 * _1220);
      }
      if (!(_42 == -1)) {
        _1236 = max(_1221, 9.999999747378752e-06f);
        _1237 = _1231 / _1236;
        _1238 = _1232 / _1236;
        _1239 = _1233 / _1236;
        _1240 = ManualUpdateCB_DataPS_raw[_42];
        _1246 = ManualUpdateCB_DataPS_raw[((int)(_42 + 1))];
        _1252 = ManualUpdateCB_DataPS_raw[((int)(_42 + 2))];
        _1258 = ManualUpdateCB_DataPS_raw[((int)(_42 + 3))];
        _1264 = ManualUpdateCB_DataPS_raw[((int)(_42 + 4))];
        _1273 = dot(float4(_1237, _1238, _1239, _1236), float4(_1240.x, _1240.y, _1240.z, _1240.w)) + _1264.x;
        _1274 = dot(float4(_1237, _1238, _1239, _1236), float4(_1246.x, _1246.y, _1246.z, _1246.w)) + _1264.y;
        _1275 = dot(float4(_1237, _1238, _1239, _1236), float4(_1252.x, _1252.y, _1252.z, _1252.w)) + _1264.z;
        _1282 = saturate(((_1274 * 0.7152000069618225f) + (_1273 * 0.2125999927520752f)) + (_1275 * 0.0722000002861023f));
        _1288 = _1273;
        _1289 = _1274;
        _1290 = _1275;
        _1291 = 1.0f;
        _1292 = (((((dot(float4(_1237, _1238, _1239, _1236), float4(_1258.x, _1258.y, _1258.z, _1258.w)) + _1264.w) - _1282) * _1222) + _1282) * _1223);
      } else {
        _1288 = _1231;
        _1289 = _1232;
        _1290 = _1233;
        _1291 = _1221;
        _1292 = _1223;
      }
    } while (false);
  } else {
    do {
      if (TEXCOORD_3.w == 3) {
        _50 = ManualUpdateCB_DataPS_raw[_35];
        do {
          _66 = TEXCOORD_1.x;
          _67 = TEXCOORD_1.y;
          if ((!(_50.z == -1.0f)) || (!(_50.w == -1.0f))) {
            _66 = min(max(TEXCOORD_1.x, _50.x), (_50.x + _50.z));
            _67 = min(max(TEXCOORD_1.y, _50.y), (_50.y + _50.w));
          }
          _68 = txBuffer.Sample(samplercoherenttxBuffer, float2(_66, _67));
          do {
            if (!(txBufferIsUserBackground == 0)) {
              _79 = (g_bHDR == 0);
              do {
                _95 = _68.x;
                _96 = _68.y;
                _97 = _68.z;
                if ((g_bHDR_scRGB == 0) && (!_79)) {
                  _95 = mad(-0.07283977419137955f, _68.z, mad(-0.5876564383506775f, _68.y, (_68.x * 1.6604962348937988f)));
                  _96 = mad(-0.008348013274371624f, _68.z, mad(1.1328951120376587f, _68.y, (_68.x * -0.1245470941066742f)));
                  _97 = mad(1.118751049041748f, _68.z, mad(-0.10059737414121628f, _68.y, (_68.x * -0.018153680488467216f)));
                }
                if (!(_79)) {
                  _104 = max((dot(float3(_95, _96, _97), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) / (g_fSDRBrightnessMultiplier * 0.3940886855125427f)), 0.0f);
                  _119 = ((1.0f - (1.0f / (fUIHDRBackdropBackgroundDarkeningStrength + 1.0f))) * ((select((!(_104 == 0.0f)), (1.0f / _104), 0.0f) * (_104 / ((_104 + 1.0f) * g_fSDRBrightnessMultiplier))) + -1.0f)) + 1.0f;
                  _860 = (_119 * _95);
                  _861 = (_119 * _96);
                  _862 = (_119 * _97);
                } else {
                  _860 = _95;
                  _861 = _96;
                  _862 = _97;
                }
              } while (false);
            } else {
              if (!(txBufferIsDisplayCalibration == 0)) {
                do {
                  _803 = _68.x;
                  _804 = _68.y;
                  _805 = _68.z;
                  if (!(g_iTonemapper == 0)) {
                    if (g_iTonemapper == 2) {
#if 1
                      float3 agx_color = ApplyRemedyAgX(
                          _68.x, _68.y, _68.z, g_fPaperWhite,
                          g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
                          g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
                          g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
                          g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
                          g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
                          g_fAgxHDRRatio, g_fAgxHDRMidGrey,
                          g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
                          float2(_66, _67));
                      _803 = agx_color.x;
                      _804 = agx_color.y;
                      _805 = agx_color.z;
#else
                      _162 = max(_68.x, 0.0f);
                      _163 = max(_68.y, 0.0f);
                      _164 = max(_68.z, 0.0f);
                      _186 = g_fAgxMaxEV - g_fAgxMinEV;
                      _190 = saturate((log2(max(mad(g_vAgxInsetRow0.z, _164, mad(g_vAgxInsetRow0.y, _163, (_162 * g_vAgxInsetRow0.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _186);
                      _191 = saturate((log2(max(mad(g_vAgxInsetRow1.z, _164, mad(g_vAgxInsetRow1.y, _163, (_162 * g_vAgxInsetRow1.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _186);
                      _192 = saturate((log2(max(mad(g_vAgxInsetRow2.z, _164, mad(g_vAgxInsetRow2.y, _163, (_162 * g_vAgxInsetRow2.x))), 1.000000013351432e-10f)) - g_fAgxMinEV) / _186);
                      _201 = (g_fAgxContrastSlope * (_190 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
                      _202 = 1.0f / g_fAgxShoulderPower;
                      _219 = g_fAgxContrastSlope / g_fAgxToePrecalcConstant;
                      _221 = _219 * (0.6060606241226196f - _190);
                      _222 = 1.0f / g_fAgxToePower;
                      _241 = -0.0f - g_fAgxToePrecalcConstant;
                      _244 = select((_190 >= 0.6060606241226196f), ((_201 / exp2(log2((float((int)(((int)(uint)((int)(_201 > 0.0f))) - ((int)(uint)((int)(_201 < 0.0f))))) * exp2(log2(abs(_201)) * g_fAgxShoulderPower)) + 1.0f) * _202)) * g_fAgxShoulderPrecalcConstant), ((_221 / exp2(log2((float((int)(((int)(uint)((int)(_221 > 0.0f))) - ((int)(uint)((int)(_221 < 0.0f))))) * exp2(log2(abs(_221)) * g_fAgxToePower)) + 1.0f) * _222)) * _241)) + 0.4894371032714844f;
                      _247 = (g_fAgxContrastSlope * (_191 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
                      _265 = _219 * (0.6060606241226196f - _191);
                      _286 = select((_191 >= 0.6060606241226196f), ((_247 / exp2(log2((float((int)(((int)(uint)((int)(_247 > 0.0f))) - ((int)(uint)((int)(_247 < 0.0f))))) * exp2(log2(abs(_247)) * g_fAgxShoulderPower)) + 1.0f) * _202)) * g_fAgxShoulderPrecalcConstant), ((_265 / exp2(log2((exp2(log2(abs(_265)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_265 > 0.0f))) - ((int)(uint)((int)(_265 < 0.0f)))))) + 1.0f) * _222)) * _241)) + 0.4894371032714844f;
                      _289 = (g_fAgxContrastSlope * (_192 + -0.6060606241226196f)) / g_fAgxShoulderPrecalcConstant;
                      _307 = _219 * (0.6060606241226196f - _192);
                      _328 = select((_192 >= 0.6060606241226196f), ((_289 / exp2(log2((float((int)(((int)(uint)((int)(_289 > 0.0f))) - ((int)(uint)((int)(_289 < 0.0f))))) * exp2(log2(abs(_289)) * g_fAgxShoulderPower)) + 1.0f) * _202)) * g_fAgxShoulderPrecalcConstant), ((_307 / exp2(log2((exp2(log2(abs(_307)) * g_fAgxToePower) * float((int)(((int)(uint)((int)(_307 > 0.0f))) - ((int)(uint)((int)(_307 < 0.0f)))))) + 1.0f) * _222)) * _241)) + 0.4894371032714844f;
                      _347 = exp2(log2(max(mad(g_vAgxOutsetRow0.z, _328, mad(g_vAgxOutsetRow0.y, _286, (_244 * g_vAgxOutsetRow0.x))), 0.0f)) * 2.4000000953674316f);
                      _348 = exp2(log2(max(mad(g_vAgxOutsetRow1.z, _328, mad(g_vAgxOutsetRow1.y, _286, (_244 * g_vAgxOutsetRow1.x))), 0.0f)) * 2.4000000953674316f);
                      _349 = exp2(log2(max(mad(g_vAgxOutsetRow2.z, _328, mad(g_vAgxOutsetRow2.y, _286, (_244 * g_vAgxOutsetRow2.x))), 0.0f)) * 2.4000000953674316f);
                      do {
                        _533 = _347;
                        _534 = _348;
                        _535 = _349;
                        if (g_fAgxHDRRatio > 1.0f) {
                          if (!(!(max(_347, max(_348, _349)) >= g_fAgxHDRMidGrey))) {
                            _360 = log2(1.0f / g_fAgxHDRMidGrey);
                            _361 = _360 + 20.0f;
                            _374 = min(max(log2(max(_347, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _360);
                            _375 = min(max(log2(max(_348, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _360);
                            _376 = min(max(log2(max(_349, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _360);
                            _383 = 20.0f / _361;
                            _386 = (20.0f - log2(g_fAgxHDRRatio)) / _361;
                            _391 = ((_374 / _361) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                            _406 = 1.0000009536743164f / g_fAgxHDRToePrecalcConstant;
                            _409 = ((-0.0f - _374) / _361) * _406;
                            _428 = -0.0f - g_fAgxHDRToePrecalcConstant;
                            _434 = ((_375 / _361) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                            _451 = ((-0.0f - _375) / _361) * _406;
                            _475 = ((_376 / _361) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                            _492 = ((-0.0f - _376) / _361) * _406;
                            _533 = (saturate(exp2(((select((((_374 + 20.0f) / _361) >= _383), ((_391 / exp2(log2((float((int)(((int)(uint)((int)(_391 > 0.0f))) - ((int)(uint)((int)(_391 < 0.0f))))) * exp2(log2(abs(_391)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_409 / exp2(log2((float((int)(((int)(uint)((int)(_409 > 0.0f))) - ((int)(uint)((int)(_409 < 0.0f))))) * exp2(log2(abs(_409)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _428)) + _386) * _361) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                            _534 = (saturate(exp2(((select((((_375 + 20.0f) / _361) >= _383), ((_434 / exp2(log2((float((int)(((int)(uint)((int)(_434 > 0.0f))) - ((int)(uint)((int)(_434 < 0.0f))))) * exp2(log2(abs(_434)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_451 / exp2(log2((float((int)(((int)(uint)((int)(_451 > 0.0f))) - ((int)(uint)((int)(_451 < 0.0f))))) * exp2(log2(abs(_451)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _428)) + _386) * _361) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                            _535 = (saturate(exp2(((select((((_376 + 20.0f) / _361) >= _383), ((_475 / exp2(log2((float((int)(((int)(uint)((int)(_475 > 0.0f))) - ((int)(uint)((int)(_475 < 0.0f))))) * exp2(log2(abs(_475)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), ((_492 / exp2(log2((float((int)(((int)(uint)((int)(_492 > 0.0f))) - ((int)(uint)((int)(_492 < 0.0f))))) * exp2(log2(abs(_492)) * 3.0f)) + 1.0f) * 0.3333333432674408f)) * _428)) + _386) * _361) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                          } else {
                            _533 = _347;
                            _534 = _348;
                            _535 = _349;
                          }
                        }
                        _803 = (mad(-0.07283977419137955f, _535, mad(-0.5876564383506775f, _534, (_533 * 1.6604962348937988f))) * g_fPaperWhite);
                        _804 = (mad(-0.008348013274371624f, _535, mad(1.1328951120376587f, _534, (_533 * -0.1245470941066742f))) * g_fPaperWhite);
                        _805 = (mad(1.118751049041748f, _535, mad(-0.10059737414121628f, _534, (_533 * -0.018153680488467216f))) * g_fPaperWhite);
                      } while (false);
#endif
                    } else {
                      if ((g_bHDR == 0) || (g_bEnableHDRLUT == 0)) {
                        _553 = max(_68.x, 0.0f);
                        _554 = max(_68.y, 0.0f);
                        _555 = max(_68.z, 0.0f);
                        _556 = dot(float3(_553, _554, _555), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                        do {
                          _566 = _553;
                          _567 = _554;
                          _568 = _555;
                          if (!(_556 == 0.0f)) {
                            _561 = max(dot(float3(_68.x, _68.y, _68.z), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _556;
                            _566 = (_561 * _553);
                            _567 = (_561 * _554);
                            _568 = (_561 * _555);
                          }
                          _574 = max(max(_566, max(_567, _568)), 0.0f);
                          _576 = 1.0f / max(_574, 1.1754943508222875e-38f);
                          _582 = (pow(_574, g_vTonemapGTParams.x));
                          _590 = _582 / (((pow(_582, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
                          _604 = exp2(log2(_576 * _566) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
                          _605 = exp2(log2(_576 * _567) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
                          _606 = exp2(log2(_576 * _568) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
                          _611 = log2(_590);
                          _639 = saturate(exp2(log2((exp2(_611 * g_vTonemapCrosstalk.x) * (1.0f - _604)) + _604) * g_vTonemapCrosstalkSaturation.x) * _590);
                          _640 = saturate(exp2(log2((exp2(_611 * g_vTonemapCrosstalk.y) * (1.0f - _605)) + _605) * g_vTonemapCrosstalkSaturation.y) * _590);
                          _641 = saturate(exp2(log2((exp2(_611 * g_vTonemapCrosstalk.z) * (1.0f - _606)) + _606) * g_vTonemapCrosstalkSaturation.z) * _590);
                          if (g_bEnableHDRLUT == 0) {
                            _803 = (_639 * g_fPaperWhite);
                            _804 = (_640 * g_fPaperWhite);
                            _805 = (_641 * g_fPaperWhite);
                          } else {
                            _803 = _639;
                            _804 = _640;
                            _805 = _641;
                          }
                        } while (false);
                      } else {
                        _653 = g_fMaxOutputNits * 0.012500000186264515f;
                        _658 = max(abs(_68.x), max(abs(_68.y), abs(_68.z)));
                        _660 = 1.0f / max(_658, 1.1754943508222875e-38f);
                        _661 = _660 * _68.x;
                        _662 = _660 * _68.y;
                        _663 = _660 * _68.z;
                        _673 = (g_fPaperWhite * 0.18000000715255737f) * exp2(log2((pow(_658, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
                        _677 = dot(float3((_673 * _661), (_673 * _662), (_673 * _663)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                        _726 = exp2(log2(abs(_661)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_661 > 0.0f))) - ((int)(uint)((int)(_661 < 0.0f)))));
                        _727 = exp2(log2(abs(_662)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_662 > 0.0f))) - ((int)(uint)((int)(_662 < 0.0f)))));
                        _728 = exp2(log2(abs(_663)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_663 > 0.0f))) - ((int)(uint)((int)(_663 < 0.0f)))));
                        _733 = log2(saturate(select((_677 <= 0.0f), _677, ((1.0f - exp2(log2(exp2((_677 / _653) * -1.4426950216293335f)))) * _653)) / _653));
                        _746 = (exp2(_733 * g_vTonemapCrosstalk.x) * (1.0f - _726)) + _726;
                        _747 = (exp2(_733 * g_vTonemapCrosstalk.y) * (1.0f - _727)) + _727;
                        _748 = (exp2(_733 * g_vTonemapCrosstalk.z) * (1.0f - _728)) + _728;
                        _780 = (float((int)(((int)(uint)((int)(_746 > 0.0f))) - ((int)(uint)((int)(_746 < 0.0f))))) * _673) * exp2(log2(abs(_746)) * g_vTonemapCrosstalkSaturation.x);
                        _782 = (float((int)(((int)(uint)((int)(_747 > 0.0f))) - ((int)(uint)((int)(_747 < 0.0f))))) * _673) * exp2(log2(abs(_747)) * g_vTonemapCrosstalkSaturation.y);
                        _784 = (float((int)(((int)(uint)((int)(_748 > 0.0f))) - ((int)(uint)((int)(_748 < 0.0f))))) * _673) * exp2(log2(abs(_748)) * g_vTonemapCrosstalkSaturation.z);
                        _785 = dot(float3(_780, _782, _784), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                        _798 = select((_785 <= 0.0f), _785, ((1.0f - exp2(log2(exp2((_785 / _653) * -1.4426950216293335f)))) * _653)) * select((!(_785 == 0.0f)), (1.0f / _785), 0.0f);
                        _803 = (_798 * _780);
                        _804 = (_798 * _782);
                        _805 = (_798 * _784);
                      }
                    }
                  }
                  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
                  _860 = (_803 / ui_brightness);
                  _861 = (_804 / ui_brightness);
                  _862 = (_805 / ui_brightness);
                } while (false);
              } else {
                if (!(txBufferIsBT2100Encoded == 0)) {
                  _821 = (pow(_68.x, 0.012683313339948654f));
                  _822 = (pow(_68.y, 0.012683313339948654f));
                  _823 = (pow(_68.z, 0.012683313339948654f));
                  _845 = exp2(log2(max((_821 + -0.8359375f), 0.0f) / (18.8515625f - (_821 * 18.6875f))) * 6.277394771575928f);
                  _848 = exp2(log2(max((_822 + -0.8359375f), 0.0f) / (18.8515625f - (_822 * 18.6875f))) * 6.277394771575928f) * 125.0f;
                  _849 = exp2(log2(max((_823 + -0.8359375f), 0.0f) / (18.8515625f - (_823 * 18.6875f))) * 6.277394771575928f) * 125.0f;
                  _860 = mad(-0.07283977419137955f, _849, mad(-0.5876564383506775f, _848, (_845 * 207.56202697753906f)));
                  _861 = mad(-0.008348013274371624f, _849, mad(1.1328951120376587f, _848, (_845 * -15.568387031555176f)));
                  _862 = mad(1.118751049041748f, _849, mad(-0.10059737414121628f, _848, (_845 * -2.26921010017395f)));
                } else {
                  _860 = _68.x;
                  _861 = _68.y;
                  _862 = _68.z;
                }
              }
            }
            _865 = select((txBufferIsPureAdditive != 0), 0.0f, _68.w);
            do {
              _968 = _860;
              _969 = _861;
              _970 = _862;
              if (!(txBufferIsLinearUserTexture == 0)) {
                if ((int(_26.y) & 1) == 0) {
                  do {
                    [branch]
                    if (!(_860 <= 0.0031308000907301903f)) {
                      _884 = (((pow(_860, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _884 = (_860 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_861 <= 0.0031308000907301903f)) {
                        _895 = (((pow(_861, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _895 = (_861 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_862 <= 0.0031308000907301903f)) {
                          _906 = (((pow(_862, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _906 = (_862 * 12.920000076293945f);
                        }
                        if (!(txBufferIsDisplayCalibration == 0)) {
                          if (g_bHDR == 0) {
                            _918 = g_tRandomBlueNoiseRGBA.Load(int3(((int)(uint(SV_Position.x)) & 255), ((int)(uint(SV_Position.y)) & 255), 0));
                            _922 = mad(_918.x, 2.0f, -1.0f);
                            _923 = mad(_918.y, 2.0f, -1.0f);
                            _924 = mad(_918.z, 2.0f, -1.0f);
                            _968 = (((float((int)(((int)(uint)((int)(_922 > 0.0f))) - ((int)(uint)((int)(_922 < 0.0f))))) * 0.003921568859368563f) * (1.0f - sqrt(max(0.0f, (1.0f - abs(_922)))))) + _884);
                            _969 = (((float((int)(((int)(uint)((int)(_923 > 0.0f))) - ((int)(uint)((int)(_923 < 0.0f))))) * 0.003921568859368563f) * (1.0f - sqrt(max(0.0f, (1.0f - abs(_923)))))) + _895);
                            _970 = (((float((int)(((int)(uint)((int)(_924 > 0.0f))) - ((int)(uint)((int)(_924 < 0.0f))))) * 0.003921568859368563f) * (1.0f - sqrt(max(0.0f, (1.0f - abs(_924)))))) + _906);
                          } else {
                            _968 = _884;
                            _969 = _895;
                            _970 = _906;
                          }
                        } else {
                          _968 = _884;
                          _969 = _895;
                          _970 = _906;
                        }
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _968 = _860;
                  _969 = _861;
                  _970 = _862;
                }
              }
              _971 = 1.0f - _865;
              _980 = saturate(((_969 * 0.7152000069618225f) + (_968 * 0.2125999927520752f)) + (_970 * 0.0722000002861023f));
              _983 = (((lerp(_971, _865, _30.x)) - _980) * _30.z) + _980;
              _1218 = _968;
              _1219 = _969;
              _1220 = _970;
              _1221 = (lerp(_983, 1.0f, _26.y));
              _1222 = _30.z;
              _1223 = (saturate(TEXCOORD_1.z) * _30.w);
            } while (false);
          } while (false);
        } while (false);
      } else {
        do {
          if (TEXCOORD_3.w == 17) {
            _994 = txBuffer1.Sample(samplercoherenttxBuffer1, float2(TEXCOORD_1.x, TEXCOORD_1.y));
            if (!((_40 & 8) == 0)) {
              if (!(_42 == -1)) {
                _1002 = max(_994.w, 9.999999747378752e-06f);
                _1003 = _994.x / _1002;
                _1004 = _994.y / _1002;
                _1005 = _994.z / _1002;
                _1006 = ManualUpdateCB_DataPS_raw[_42];
                _1012 = ManualUpdateCB_DataPS_raw[((int)(_42 + 1))];
                _1018 = ManualUpdateCB_DataPS_raw[((int)(_42 + 2))];
                _1024 = ManualUpdateCB_DataPS_raw[((int)(_42 + 3))];
                _1030 = ManualUpdateCB_DataPS_raw[((int)(_42 + 4))];
                _1288 = (dot(float4(_1003, _1004, _1005, _1002), float4(_1006.x, _1006.y, _1006.z, _1006.w)) + _1030.x);
                _1289 = (dot(float4(_1003, _1004, _1005, _1002), float4(_1012.x, _1012.y, _1012.z, _1012.w)) + _1030.y);
                _1290 = (dot(float4(_1003, _1004, _1005, _1002), float4(_1018.x, _1018.y, _1018.z, _1018.w)) + _1030.z);
                _1291 = 1.0f;
                _1292 = ((dot(float4(_1003, _1004, _1005, _1002), float4(_1024.x, _1024.y, _1024.z, _1024.w)) + _1030.w) * _30.w);
              } else {
                _1288 = _994.x;
                _1289 = _994.y;
                _1290 = _994.z;
                _1291 = _994.w;
                _1292 = _30.w;
              }
            } else {
              _1045 = max(_994.x, 0.0f);
              _1218 = (_1045 * _30.x);
              _1219 = (_1045 * _30.y);
              _1220 = (_1045 * _30.z);
              _1221 = (_1045 * _30.w);
              _1222 = 1.0f;
              _1223 = 1.0f;
              break;
            }
          } else {
            do {
              if (TEXCOORD_3.w == 18) {
                _1053 = txBuffer2.Sample(samplercoherenttxBuffer2, float2(TEXCOORD_1.x, TEXCOORD_1.y));
                do {
                  _1288 = 0.0f;
                  _1289 = 0.0f;
                  _1290 = 0.0f;
                  _1291 = 0.0f;
                  _1292 = 1.0f;
                  if (!(_1053.x == 0.0f)) {
                    _1063 = saturate((TEXCOORD_1.z * 0.9960936903953552f) * (((_1053.x * 7.96875f) + -3.984375f) + (0.501960813999176f / TEXCOORD_1.z)));
                    _1068 = max(((_1063 * _1063) * (3.0f - (_1063 * 2.0f))), 0.0f);
                    _1218 = (_1068 * _30.x);
                    _1219 = (_1068 * _30.y);
                    _1220 = (_1068 * _30.z);
                    _1221 = (_1068 * _30.w);
                    _1222 = 1.0f;
                    _1223 = 1.0f;
                    break;
                  }
                  break;
                } while (false);
              } else {
                if (TEXCOORD_3.w == 22) {
                  _1079 = 0.5f - TEXCOORD_1.z;
                  _1083 = saturate(((((float4)(txBuffer2.Sample(samplercoherenttxBuffer2, float2(TEXCOORD_1.x, TEXCOORD_1.y)))).x) - _1079) / ((TEXCOORD_1.z + 0.5f) - _1079));
                  _1088 = max(((_1083 * _1083) * (3.0f - (_1083 * 2.0f))), 0.0f);
                  _1218 = (_1088 * _30.x);
                  _1219 = (_1088 * _30.y);
                  _1220 = (_1088 * _30.z);
                  _1221 = (_1088 * _30.w);
                  _1222 = 1.0f;
                  _1223 = 1.0f;
                } else {
                  if (TEXCOORD_3.w == 30) {
                    _1218 = _30.x;
                    _1219 = _30.y;
                    _1220 = _30.z;
                    _1221 = _30.w;
                    _1222 = 1.0f;
                    _1223 = (((float4)(txBuffer.Sample(samplercoherenttxBuffer, float2(TEXCOORD_1.x, TEXCOORD_1.y)))).x);
                  } else {
                    if (TEXCOORD_3.w == 34) {
                      _1107 = txBuffer.Sample(samplercoherenttxBuffer, float2(((frac(TEXCOORD_1.x) * _30.z) + _30.x), ((frac(TEXCOORD_1.y) * _30.w) + _30.y)));
                      do {
                        if (((_40 & 2) != 0) && (txBufferIsLinearUserTexture == 0)) {
                          do {
                            if (!(!(_1107.x <= 0.040449999272823334f))) {
                              _1129 = (_1107.x * 0.07739938050508499f);
                            } else {
                              _1129 = exp2(log2((_1107.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            }
                            do {
                              if (!(!(_1107.y <= 0.040449999272823334f))) {
                                _1140 = (_1107.y * 0.07739938050508499f);
                              } else {
                                _1140 = exp2(log2((_1107.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              }
                              if (!(!(_1107.z <= 0.040449999272823334f))) {
                                _1191 = _1129;
                                _1192 = _1140;
                                _1193 = (_1107.z * 0.07739938050508499f);
                              } else {
                                _1191 = _1129;
                                _1192 = _1140;
                                _1193 = exp2(log2((_1107.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              }
                            } while (false);
                          } while (false);
                        } else {
                          if (((_40 & 16) != 0) || (((_40 & 1) == 0) && (txBufferIsLinearUserTexture != 0))) {
                            do {
                              if (!(!(_1107.x <= 0.0031308000907301903f))) {
                                _1169 = (_1107.x * 12.920000076293945f);
                              } else {
                                _1169 = (((pow(_1107.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                              }
                              do {
                                if (!(!(_1107.y <= 0.0031308000907301903f))) {
                                  _1180 = (_1107.y * 12.920000076293945f);
                                } else {
                                  _1180 = (((pow(_1107.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                                }
                                if (!(!(_1107.z <= 0.0031308000907301903f))) {
                                  _1191 = _1169;
                                  _1192 = _1180;
                                  _1193 = (_1107.z * 12.920000076293945f);
                                } else {
                                  _1191 = _1169;
                                  _1192 = _1180;
                                  _1193 = (((pow(_1107.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                                }
                              } while (false);
                            } while (false);
                          } else {
                            _1191 = _1107.x;
                            _1192 = _1107.y;
                            _1193 = _1107.z;
                          }
                        }
                        _1194 = int(_26.y);
                        _1199 = _1194 & 4;
                        do {
                          _1209 = select(((_1194 & 1) != 0), (1.0f - _1107.w), _1107.w);
                          if (!(_1199 == 0)) {
                            _1209 = saturate(((_1192 * 0.7152000069618225f) + (_1191 * 0.2125999927520752f)) + (_1193 * 0.0722000002861023f));
                          }
                          _1218 = _1191;
                          _1219 = _1192;
                          _1220 = _1193;
                          _1221 = select(((_1194 & 2) != 0), 1.0f, _1209);
                          _1222 = select((_1199 != 0), 0.0f, 1.0f);
                          _1223 = (saturate(TEXCOORD_1.z) * TEXCOORD_1.w);
                        } while (false);
                      } while (false);
                    } else {
                      _1218 = _30.x;
                      _1219 = _30.y;
                      _1220 = _30.z;
                      _1221 = _30.w;
                      _1222 = 1.0f;
                      _1223 = 1.0f;
                    }
                  }
                }
              }
              break;
            } while (false);
          }
          break;
        } while (false);
      }
      do {
        _1231 = _1218;
        _1232 = _1219;
        _1233 = _1220;
        if (!((_40 & 64) == 0)) {
          _1231 = (_1221 * _1218);
          _1232 = (_1221 * _1219);
          _1233 = (_1221 * _1220);
        }
        if (!(_42 == -1)) {
          _1236 = max(_1221, 9.999999747378752e-06f);
          _1237 = _1231 / _1236;
          _1238 = _1232 / _1236;
          _1239 = _1233 / _1236;
          _1240 = ManualUpdateCB_DataPS_raw[_42];
          _1246 = ManualUpdateCB_DataPS_raw[((int)(_42 + 1))];
          _1252 = ManualUpdateCB_DataPS_raw[((int)(_42 + 2))];
          _1258 = ManualUpdateCB_DataPS_raw[((int)(_42 + 3))];
          _1264 = ManualUpdateCB_DataPS_raw[((int)(_42 + 4))];
          _1273 = dot(float4(_1237, _1238, _1239, _1236), float4(_1240.x, _1240.y, _1240.z, _1240.w)) + _1264.x;
          _1274 = dot(float4(_1237, _1238, _1239, _1236), float4(_1246.x, _1246.y, _1246.z, _1246.w)) + _1264.y;
          _1275 = dot(float4(_1237, _1238, _1239, _1236), float4(_1252.x, _1252.y, _1252.z, _1252.w)) + _1264.z;
          _1282 = saturate(((_1274 * 0.7152000069618225f) + (_1273 * 0.2125999927520752f)) + (_1275 * 0.0722000002861023f));
          _1288 = _1273;
          _1289 = _1274;
          _1290 = _1275;
          _1291 = 1.0f;
          _1292 = (((((dot(float4(_1237, _1238, _1239, _1236), float4(_1258.x, _1258.y, _1258.z, _1258.w)) + _1264.w) - _1282) * _1222) + _1282) * _1223);
        } else {
          _1288 = _1231;
          _1289 = _1232;
          _1290 = _1233;
          _1291 = _1221;
          _1292 = _1223;
        }
      } while (false);
    } while (false);
  }
  SV_Target.x = (_1292 * _1288);
  SV_Target.y = (_1292 * _1289);
  SV_Target.z = (_1292 * _1290);
  SV_Target.w = (_1292 * _1291);
  return SV_Target;
}
