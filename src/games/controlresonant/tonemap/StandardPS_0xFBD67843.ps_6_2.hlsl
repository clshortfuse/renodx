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
  float g_fAgxHDRSaturation : packoffset(c014.w);
};

cbuffer shared_tonemap_post : register(b3) {
  float g_fPaperWhite : packoffset(c000.x);
  int g_bApplyVignette : packoffset(c000.y);
  int g_bApplyFilmGrain : packoffset(c000.z);
};

cbuffer ManualUpdateCB_DataPS : register(b0) {
  struct {
    float4 Data_PS[2048];
  } ManualUpdateCB_DataPS_view : packoffset(c000.x);

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
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1,
  linear float3 TEXCOORD_2 : TEXCOORD2,
  nointerpolation uint4 TEXCOORD_3 : TEXCOORD3,
  noperspective float4 TEXCOORD_4 : TEXCOORD4
) : SV_Target {
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
  float _467;
  float _468;
  float _469;
  float _500;
  float _501;
  float _502;
  float _737;
  float _738;
  float _739;
  float _794;
  float _795;
  float _796;
  float _818;
  float _829;
  float _840;
  float _902;
  float _903;
  float _904;
  float _1063;
  float _1074;
  float _1103;
  float _1114;
  float _1125;
  float _1126;
  float _1127;
  float _1143;
  float _1152;
  float _1153;
  float _1154;
  float _1155;
  float _1156;
  float _1157;
  float _1165;
  float _1166;
  float _1167;
  float _1222;
  float _1223;
  float _1224;
  float _1225;
  float _1226;
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
  float _362;
  float _381;
  float _382;
  float _383;
  float _384;
  float _388;
  float _393;
  float _410;
  float _432;
  float _438;
  float _487;
  float _488;
  float _489;
  float _490;
  float _495;
  float _508;
  float _510;
  float _516;
  float _524;
  float _538;
  float _539;
  float _540;
  float _545;
  float _573;
  float _574;
  float _575;
  float _587;
  float _592;
  float _594;
  float _595;
  float _596;
  float _597;
  float _607;
  float _611;
  float _660;
  float _661;
  float _662;
  float _667;
  float _680;
  float _681;
  float _682;
  float _714;
  float _716;
  float _718;
  float _719;
  float _732;
  float _755;
  float _756;
  float _757;
  float _779;
  float _782;
  float _783;
  float _799;
  float4 _852;
  float _856;
  float _857;
  float _858;
  float _905;
  float _914;
  float _917;
  float4 _928;
  float _936;
  float _937;
  float _938;
  float _939;
  float4 _940;
  float4 _946;
  float4 _952;
  float4 _958;
  float4 _964;
  float _979;
  float4 _987;
  float _997;
  float _1002;
  float _1013;
  float _1017;
  float _1022;
  float4 _1041;
  int _1128;
  int _1133;
  float _1170;
  float _1171;
  float _1172;
  float _1173;
  float4 _1174;
  float4 _1180;
  float4 _1186;
  float4 _1192;
  float4 _1198;
  float _1207;
  float _1208;
  float _1209;
  float _1216;
  _25 = ((int)(TEXCOORD_3.z << 4)) | (((uint)((uint)(TEXCOORD_3.y)) >> 4) & 15);
  _26 = ManualUpdateCB_DataPS_raw[_25];
  _30 = ManualUpdateCB_DataPS_raw[((int)(_25 + 1))];
  _35 = int(_26.x);
  _38 = ManualUpdateCB_DataPS_raw[(int)(max((int)(0), (int)((_35 + -1))))];
  _40 = int(_38.y);
  _42 = int(_38.z);
  if (TEXCOORD_3.w == 0) {
    _1152 = _30.x;
    _1153 = _30.y;
    _1154 = _30.z;
    _1155 = _30.w;
    _1156 = 1.0f;
    _1157 = min(1.0f, (TEXCOORD_1.w * TEXCOORD_1.z));
    do {
      _1165 = _1152;
      _1166 = _1153;
      _1167 = _1154;
      if (!((_40 & 64) == 0)) {
        _1165 = (_1155 * _1152);
        _1166 = (_1155 * _1153);
        _1167 = (_1155 * _1154);
      }
      if (!(_42 == -1)) {
        _1170 = max(_1155, 9.999999747378752e-06f);
        _1171 = _1165 / _1170;
        _1172 = _1166 / _1170;
        _1173 = _1167 / _1170;
        _1174 = ManualUpdateCB_DataPS_raw[_42];
        _1180 = ManualUpdateCB_DataPS_raw[((int)(_42 + 1))];
        _1186 = ManualUpdateCB_DataPS_raw[((int)(_42 + 2))];
        _1192 = ManualUpdateCB_DataPS_raw[((int)(_42 + 3))];
        _1198 = ManualUpdateCB_DataPS_raw[((int)(_42 + 4))];
        _1207 = dot(float4(_1171, _1172, _1173, _1170), float4(_1174.x, _1174.y, _1174.z, _1174.w)) + _1198.x;
        _1208 = dot(float4(_1171, _1172, _1173, _1170), float4(_1180.x, _1180.y, _1180.z, _1180.w)) + _1198.y;
        _1209 = dot(float4(_1171, _1172, _1173, _1170), float4(_1186.x, _1186.y, _1186.z, _1186.w)) + _1198.z;
        _1216 = saturate(((_1208 * 0.7152000069618225f) + (_1207 * 0.2125999927520752f)) + (_1209 * 0.0722000002861023f));
        _1222 = _1207;
        _1223 = _1208;
        _1224 = _1209;
        _1225 = 1.0f;
        _1226 = (((((dot(float4(_1171, _1172, _1173, _1170), float4(_1192.x, _1192.y, _1192.z, _1192.w)) + _1198.w) - _1216) * _1156) + _1216) * _1157);
      } else {
        _1222 = _1165;
        _1223 = _1166;
        _1224 = _1167;
        _1225 = _1155;
        _1226 = _1157;
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
                  _794 = (_119 * _95);
                  _795 = (_119 * _96);
                  _796 = (_119 * _97);
                } else {
                  _794 = _95;
                  _795 = _96;
                  _796 = _97;
                }
              } while (false);
            } else {
              if (!(txBufferIsDisplayCalibration == 0)) {
                do {
                  _737 = _68.x;
                  _738 = _68.y;
                  _739 = _68.z;
                  if (!(g_iTonemapper == 0)) {
                    if (g_iTonemapper == 2) {
#if 1
                      float3 agx_color = ApplyRemedyAgX(
                        _68.x, _68.y, _68.z, ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR),
                          g_bHDR, g_fAgxMinEV, g_fAgxMaxEV,
                          g_fAgxToePower, g_fAgxShoulderPower, g_fAgxContrastSlope,
                          g_fAgxToePrecalcConstant, g_fAgxShoulderPrecalcConstant,
                          g_vAgxInsetRow0, g_vAgxInsetRow1, g_vAgxInsetRow2,
                          g_vAgxOutsetRow0, g_vAgxOutsetRow1, g_vAgxOutsetRow2,
                          g_fAgxHDRRatio, g_fAgxHDRMidGrey,
                          g_fAgxHDRToePrecalcConstant, g_fAgxHDRShoulderPrecalcConstant,
                          float2(_66, _67), g_fAgxHDRSaturation);
                      _737 = agx_color.x;
                      _738 = agx_color.y;
                      _739 = agx_color.z;
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
                        _467 = _347;
                        _468 = _348;
                        _469 = _349;
                        if (g_fAgxHDRRatio > 1.0f) {
                          if (!(!(max(_347, max(_348, _349)) >= g_fAgxHDRMidGrey))) {
                            _360 = log2(1.0f / g_fAgxHDRMidGrey);
                            _361 = _360 + 20.0f;
                            _362 = log2(g_fAgxHDRRatio);
                            _381 = (min(max(log2(max(_347, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _360) + 20.0f) / _361;
                            _382 = (min(max(log2(max(_348, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _360) + 20.0f) / _361;
                            _383 = (min(max(log2(max(_349, 9.999999960041972e-13f) / g_fAgxHDRMidGrey), -20.0f), _360) + 20.0f) / _361;
                            _384 = 20.0f / _361;
                            _388 = max(_381, max(_382, _383));
                            _393 = ((_388 - _384) * 1.0000009536743164f) / g_fAgxHDRShoulderPrecalcConstant;
                            _410 = (1.0000009536743164f / g_fAgxHDRToePrecalcConstant) * (_384 - _388);
                            _432 = select((_388 >= _384), ((_393 / exp2(log2((float((int)(((int)(uint)((int)(_393 > 0.0f))) - ((int)(uint)((int)(_393 < 0.0f))))) * exp2(log2(abs(_393)))) + 1.0f))) * g_fAgxHDRShoulderPrecalcConstant), (-0.0f - (g_fAgxHDRToePrecalcConstant * (_410 / exp2(log2((float((int)(((int)(uint)((int)(_410 > 0.0f))) - ((int)(uint)((int)(_410 < 0.0f))))) * exp2(log2(abs(_410)) * 3.0f)) + 1.0f) * 0.3333333432674408f))))) + ((20.0f - _362) / _361);
                            _438 = exp2((((_432 - _388) * _361) + _362) * g_fAgxHDRSaturation);
                            _467 = (saturate(exp2(((_432 + (_438 * (_381 - _388))) * _361) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                            _468 = (saturate(exp2(((_432 + (_438 * (_382 - _388))) * _361) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                            _469 = (saturate(exp2(((_432 + (_438 * (_383 - _388))) * _361) + -20.0f) * g_fAgxHDRMidGrey) * g_fAgxHDRRatio);
                          } else {
                            _467 = _347;
                            _468 = _348;
                            _469 = _349;
                          }
                        }
                        _737 = (mad(-0.07283977419137955f, _469, mad(-0.5876564383506775f, _468, (_467 * 1.6604962348937988f))) * g_fPaperWhite);
                        _738 = (mad(-0.008348013274371624f, _469, mad(1.1328951120376587f, _468, (_467 * -0.1245470941066742f))) * g_fPaperWhite);
                        _739 = (mad(1.118751049041748f, _469, mad(-0.10059737414121628f, _468, (_467 * -0.018153680488467216f))) * g_fPaperWhite);
                      } while (false);
#endif
                    } else {
                      if ((g_bHDR == 0) || (g_bEnableHDRLUT == 0)) {
                        _487 = max(_68.x, 0.0f);
                        _488 = max(_68.y, 0.0f);
                        _489 = max(_68.z, 0.0f);
                        _490 = dot(float3(_487, _488, _489), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                        do {
                          _500 = _487;
                          _501 = _488;
                          _502 = _489;
                          if (!(_490 == 0.0f)) {
                            _495 = max(dot(float3(_68.x, _68.y, _68.z), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f) / _490;
                            _500 = (_495 * _487);
                            _501 = (_495 * _488);
                            _502 = (_495 * _489);
                          }
                          _508 = max(max(_500, max(_501, _502)), 0.0f);
                          _510 = 1.0f / max(_508, 1.1754943508222875e-38f);
                          _516 = (pow(_508, g_vTonemapGTParams.x));
                          _524 = _516 / (((pow(_516, g_vTonemapGTParams.y)) * g_vTonemapGTParams.z) + g_vTonemapGTParams.w);
                          _538 = exp2(log2(_510 * _500) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x));
                          _539 = exp2(log2(_510 * _501) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y));
                          _540 = exp2(log2(_510 * _502) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z));
                          _545 = log2(_524);
                          _573 = saturate(exp2(log2((exp2(_545 * g_vTonemapCrosstalk.x) * (1.0f - _538)) + _538) * g_vTonemapCrosstalkSaturation.x) * _524);
                          _574 = saturate(exp2(log2((exp2(_545 * g_vTonemapCrosstalk.y) * (1.0f - _539)) + _539) * g_vTonemapCrosstalkSaturation.y) * _524);
                          _575 = saturate(exp2(log2((exp2(_545 * g_vTonemapCrosstalk.z) * (1.0f - _540)) + _540) * g_vTonemapCrosstalkSaturation.z) * _524);
                          if (g_bEnableHDRLUT == 0) {
                            _737 = (_573 * g_fPaperWhite);
                            _738 = (_574 * g_fPaperWhite);
                            _739 = (_575 * g_fPaperWhite);
                          } else {
                            _737 = _573;
                            _738 = _574;
                            _739 = _575;
                          }
                        } while (false);
                      } else {
                        _587 = g_fMaxOutputNits * 0.012500000186264515f;
                        _592 = max(abs(_68.x), max(abs(_68.y), abs(_68.z)));
                        _594 = 1.0f / max(_592, 1.1754943508222875e-38f);
                        _595 = _594 * _68.x;
                        _596 = _594 * _68.y;
                        _597 = _594 * _68.z;
                        _607 = (g_fPaperWhite * 0.18000000715255737f) * exp2(log2((pow(_592, g_vTonemapGTParams.x)) * 5.55555534362793f) * (1.0f / g_vTonemapGTParams.x));
                        _611 = dot(float3((_607 * _595), (_607 * _596), (_607 * _597)), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                        _660 = exp2(log2(abs(_595)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.x)) * float((int)(((int)(uint)((int)(_595 > 0.0f))) - ((int)(uint)((int)(_595 < 0.0f)))));
                        _661 = exp2(log2(abs(_596)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.y)) * float((int)(((int)(uint)((int)(_596 > 0.0f))) - ((int)(uint)((int)(_596 < 0.0f)))));
                        _662 = exp2(log2(abs(_597)) * (g_vTonemapGTParams.x / g_vTonemapCrosstalkSaturation.z)) * float((int)(((int)(uint)((int)(_597 > 0.0f))) - ((int)(uint)((int)(_597 < 0.0f)))));
                        _667 = log2(saturate(select((_611 <= 0.0f), _611, ((1.0f - exp2(log2(exp2((_611 / _587) * -1.4426950216293335f)))) * _587)) / _587));
                        _680 = (exp2(_667 * g_vTonemapCrosstalk.x) * (1.0f - _660)) + _660;
                        _681 = (exp2(_667 * g_vTonemapCrosstalk.y) * (1.0f - _661)) + _661;
                        _682 = (exp2(_667 * g_vTonemapCrosstalk.z) * (1.0f - _662)) + _662;
                        _714 = (float((int)(((int)(uint)((int)(_680 > 0.0f))) - ((int)(uint)((int)(_680 < 0.0f))))) * _607) * exp2(log2(abs(_680)) * g_vTonemapCrosstalkSaturation.x);
                        _716 = (float((int)(((int)(uint)((int)(_681 > 0.0f))) - ((int)(uint)((int)(_681 < 0.0f))))) * _607) * exp2(log2(abs(_681)) * g_vTonemapCrosstalkSaturation.y);
                        _718 = (float((int)(((int)(uint)((int)(_682 > 0.0f))) - ((int)(uint)((int)(_682 < 0.0f))))) * _607) * exp2(log2(abs(_682)) * g_vTonemapCrosstalkSaturation.z);
                        _719 = dot(float3(_714, _716, _718), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f));
                        _732 = select((_719 <= 0.0f), _719, ((1.0f - exp2(log2(exp2((_719 / _587) * -1.4426950216293335f)))) * _587)) * select((!(_719 == 0.0f)), (1.0f / _719), 0.0f);
                        _737 = (_732 * _714);
                        _738 = (_732 * _716);
                        _739 = (_732 * _718);
                      }
                    }
                  }
                  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
                  _794 = (_737 / ui_brightness);
                  _795 = (_738 / ui_brightness);
                  _796 = (_739 / ui_brightness);
                } while (false);
              } else {
                if (!(txBufferIsBT2100Encoded == 0)) {
                  _755 = (pow(_68.x, 0.012683313339948654f));
                  _756 = (pow(_68.y, 0.012683313339948654f));
                  _757 = (pow(_68.z, 0.012683313339948654f));
                  _779 = exp2(log2(max((_755 + -0.8359375f), 0.0f) / (18.8515625f - (_755 * 18.6875f))) * 6.277394771575928f);
                  _782 = exp2(log2(max((_756 + -0.8359375f), 0.0f) / (18.8515625f - (_756 * 18.6875f))) * 6.277394771575928f) * 125.0f;
                  _783 = exp2(log2(max((_757 + -0.8359375f), 0.0f) / (18.8515625f - (_757 * 18.6875f))) * 6.277394771575928f) * 125.0f;
                  _794 = mad(-0.07283977419137955f, _783, mad(-0.5876564383506775f, _782, (_779 * 207.56202697753906f)));
                  _795 = mad(-0.008348013274371624f, _783, mad(1.1328951120376587f, _782, (_779 * -15.568387031555176f)));
                  _796 = mad(1.118751049041748f, _783, mad(-0.10059737414121628f, _782, (_779 * -2.26921010017395f)));
                } else {
                  _794 = _68.x;
                  _795 = _68.y;
                  _796 = _68.z;
                }
              }
            }
            _799 = select((txBufferIsPureAdditive != 0), 0.0f, _68.w);
            do {
              _902 = _794;
              _903 = _795;
              _904 = _796;
              if (!(txBufferIsLinearUserTexture == 0)) {
                if ((int(_26.y) & 1) == 0) {
                  do {
                    [branch]
                    if (!(_794 <= 0.0031308000907301903f)) {
                      _818 = (((pow(_794, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    } else {
                      _818 = (_794 * 12.920000076293945f);
                    }
                    do {
                      [branch]
                      if (!(_795 <= 0.0031308000907301903f)) {
                        _829 = (((pow(_795, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _829 = (_795 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_796 <= 0.0031308000907301903f)) {
                          _840 = (((pow(_796, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _840 = (_796 * 12.920000076293945f);
                        }
                        if (!(txBufferIsDisplayCalibration == 0)) {
                          if (g_bHDR == 0) {
                            _852 = g_tRandomBlueNoiseRGBA.Load(int3(((int)(uint(SV_Position.x)) & 255), ((int)(uint(SV_Position.y)) & 255), 0));
                            _856 = mad(_852.x, 2.0f, -1.0f);
                            _857 = mad(_852.y, 2.0f, -1.0f);
                            _858 = mad(_852.z, 2.0f, -1.0f);
                            _902 = (((float((int)(((int)(uint)((int)(_856 > 0.0f))) - ((int)(uint)((int)(_856 < 0.0f))))) * 0.003921568859368563f) * (1.0f - sqrt(max(0.0f, (1.0f - abs(_856)))))) + _818);
                            _903 = (((float((int)(((int)(uint)((int)(_857 > 0.0f))) - ((int)(uint)((int)(_857 < 0.0f))))) * 0.003921568859368563f) * (1.0f - sqrt(max(0.0f, (1.0f - abs(_857)))))) + _829);
                            _904 = (((float((int)(((int)(uint)((int)(_858 > 0.0f))) - ((int)(uint)((int)(_858 < 0.0f))))) * 0.003921568859368563f) * (1.0f - sqrt(max(0.0f, (1.0f - abs(_858)))))) + _840);
                          } else {
                            _902 = _818;
                            _903 = _829;
                            _904 = _840;
                          }
                        } else {
                          _902 = _818;
                          _903 = _829;
                          _904 = _840;
                        }
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _902 = _794;
                  _903 = _795;
                  _904 = _796;
                }
              }
              _905 = 1.0f - _799;
              _914 = saturate(((_903 * 0.7152000069618225f) + (_902 * 0.2125999927520752f)) + (_904 * 0.0722000002861023f));
              _917 = (((lerp(_905, _799, _30.x)) - _914) * _30.z) + _914;
              _1152 = _902;
              _1153 = _903;
              _1154 = _904;
              _1155 = (lerp(_917, 1.0f, _26.y));
              _1156 = _30.z;
              _1157 = (saturate(TEXCOORD_1.z) * _30.w);
            } while (false);
          } while (false);
        } while (false);
      } else {
        do {
          if (TEXCOORD_3.w == 17) {
            _928 = txBuffer1.Sample(samplercoherenttxBuffer1, float2(TEXCOORD_1.x, TEXCOORD_1.y));
            if (!((_40 & 8) == 0)) {
              if (!(_42 == -1)) {
                _936 = max(_928.w, 9.999999747378752e-06f);
                _937 = _928.x / _936;
                _938 = _928.y / _936;
                _939 = _928.z / _936;
                _940 = ManualUpdateCB_DataPS_raw[_42];
                _946 = ManualUpdateCB_DataPS_raw[((int)(_42 + 1))];
                _952 = ManualUpdateCB_DataPS_raw[((int)(_42 + 2))];
                _958 = ManualUpdateCB_DataPS_raw[((int)(_42 + 3))];
                _964 = ManualUpdateCB_DataPS_raw[((int)(_42 + 4))];
                _1222 = (dot(float4(_937, _938, _939, _936), float4(_940.x, _940.y, _940.z, _940.w)) + _964.x);
                _1223 = (dot(float4(_937, _938, _939, _936), float4(_946.x, _946.y, _946.z, _946.w)) + _964.y);
                _1224 = (dot(float4(_937, _938, _939, _936), float4(_952.x, _952.y, _952.z, _952.w)) + _964.z);
                _1225 = 1.0f;
                _1226 = ((dot(float4(_937, _938, _939, _936), float4(_958.x, _958.y, _958.z, _958.w)) + _964.w) * _30.w);
              } else {
                _1222 = _928.x;
                _1223 = _928.y;
                _1224 = _928.z;
                _1225 = _928.w;
                _1226 = _30.w;
              }
            } else {
              _979 = max(_928.x, 0.0f);
              _1152 = (_979 * _30.x);
              _1153 = (_979 * _30.y);
              _1154 = (_979 * _30.z);
              _1155 = (_979 * _30.w);
              _1156 = 1.0f;
              _1157 = 1.0f;
              break;
            }
          } else {
            do {
              if (TEXCOORD_3.w == 18) {
                _987 = txBuffer2.Sample(samplercoherenttxBuffer2, float2(TEXCOORD_1.x, TEXCOORD_1.y));
                do {
                  _1222 = 0.0f;
                  _1223 = 0.0f;
                  _1224 = 0.0f;
                  _1225 = 0.0f;
                  _1226 = 1.0f;
                  if (!(_987.x == 0.0f)) {
                    _997 = saturate((TEXCOORD_1.z * 0.9960936903953552f) * (((_987.x * 7.96875f) + -3.984375f) + (0.501960813999176f / TEXCOORD_1.z)));
                    _1002 = max(((_997 * _997) * (3.0f - (_997 * 2.0f))), 0.0f);
                    _1152 = (_1002 * _30.x);
                    _1153 = (_1002 * _30.y);
                    _1154 = (_1002 * _30.z);
                    _1155 = (_1002 * _30.w);
                    _1156 = 1.0f;
                    _1157 = 1.0f;
                    break;
                  }
                  break;
                } while (false);
              } else {
                if (TEXCOORD_3.w == 22) {
                  _1013 = 0.5f - TEXCOORD_1.z;
                  _1017 = saturate(((((float4)(txBuffer2.Sample(samplercoherenttxBuffer2, float2(TEXCOORD_1.x, TEXCOORD_1.y)))).x) - _1013) / ((TEXCOORD_1.z + 0.5f) - _1013));
                  _1022 = max(((_1017 * _1017) * (3.0f - (_1017 * 2.0f))), 0.0f);
                  _1152 = (_1022 * _30.x);
                  _1153 = (_1022 * _30.y);
                  _1154 = (_1022 * _30.z);
                  _1155 = (_1022 * _30.w);
                  _1156 = 1.0f;
                  _1157 = 1.0f;
                } else {
                  if (TEXCOORD_3.w == 30) {
                    _1152 = _30.x;
                    _1153 = _30.y;
                    _1154 = _30.z;
                    _1155 = _30.w;
                    _1156 = 1.0f;
                    _1157 = (((float4)(txBuffer.Sample(samplercoherenttxBuffer, float2(TEXCOORD_1.x, TEXCOORD_1.y)))).x);
                  } else {
                    if (TEXCOORD_3.w == 34) {
                      _1041 = txBuffer.Sample(samplercoherenttxBuffer, float2(((frac(TEXCOORD_1.x) * _30.z) + _30.x), ((frac(TEXCOORD_1.y) * _30.w) + _30.y)));
                      do {
                        if (((_40 & 2) != 0) && (txBufferIsLinearUserTexture == 0)) {
                          do {
                            if (!(!(_1041.x <= 0.040449999272823334f))) {
                              _1063 = (_1041.x * 0.07739938050508499f);
                            } else {
                              _1063 = exp2(log2((_1041.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                            }
                            do {
                              if (!(!(_1041.y <= 0.040449999272823334f))) {
                                _1074 = (_1041.y * 0.07739938050508499f);
                              } else {
                                _1074 = exp2(log2((_1041.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              }
                              if (!(!(_1041.z <= 0.040449999272823334f))) {
                                _1125 = _1063;
                                _1126 = _1074;
                                _1127 = (_1041.z * 0.07739938050508499f);
                              } else {
                                _1125 = _1063;
                                _1126 = _1074;
                                _1127 = exp2(log2((_1041.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                              }
                            } while (false);
                          } while (false);
                        } else {
                          if (((_40 & 16) != 0) || (((_40 & 1) == 0) && (txBufferIsLinearUserTexture != 0))) {
                            do {
                              if (!(!(_1041.x <= 0.0031308000907301903f))) {
                                _1103 = (_1041.x * 12.920000076293945f);
                              } else {
                                _1103 = (((pow(_1041.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                              }
                              do {
                                if (!(!(_1041.y <= 0.0031308000907301903f))) {
                                  _1114 = (_1041.y * 12.920000076293945f);
                                } else {
                                  _1114 = (((pow(_1041.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                                }
                                if (!(!(_1041.z <= 0.0031308000907301903f))) {
                                  _1125 = _1103;
                                  _1126 = _1114;
                                  _1127 = (_1041.z * 12.920000076293945f);
                                } else {
                                  _1125 = _1103;
                                  _1126 = _1114;
                                  _1127 = (((pow(_1041.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                                }
                              } while (false);
                            } while (false);
                          } else {
                            _1125 = _1041.x;
                            _1126 = _1041.y;
                            _1127 = _1041.z;
                          }
                        }
                        _1128 = int(_26.y);
                        _1133 = _1128 & 4;
                        do {
                          _1143 = select(((_1128 & 1) != 0), (1.0f - _1041.w), _1041.w);
                          if (!(_1133 == 0)) {
                            _1143 = saturate(((_1126 * 0.7152000069618225f) + (_1125 * 0.2125999927520752f)) + (_1127 * 0.0722000002861023f));
                          }
                          _1152 = _1125;
                          _1153 = _1126;
                          _1154 = _1127;
                          _1155 = select(((_1128 & 2) != 0), 1.0f, _1143);
                          _1156 = select((_1133 != 0), 0.0f, 1.0f);
                          _1157 = (saturate(TEXCOORD_1.z) * TEXCOORD_1.w);
                        } while (false);
                      } while (false);
                    } else {
                      _1152 = _30.x;
                      _1153 = _30.y;
                      _1154 = _30.z;
                      _1155 = _30.w;
                      _1156 = 1.0f;
                      _1157 = 1.0f;
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
        _1165 = _1152;
        _1166 = _1153;
        _1167 = _1154;
        if (!((_40 & 64) == 0)) {
          _1165 = (_1155 * _1152);
          _1166 = (_1155 * _1153);
          _1167 = (_1155 * _1154);
        }
        if (!(_42 == -1)) {
          _1170 = max(_1155, 9.999999747378752e-06f);
          _1171 = _1165 / _1170;
          _1172 = _1166 / _1170;
          _1173 = _1167 / _1170;
          _1174 = ManualUpdateCB_DataPS_raw[_42];
          _1180 = ManualUpdateCB_DataPS_raw[((int)(_42 + 1))];
          _1186 = ManualUpdateCB_DataPS_raw[((int)(_42 + 2))];
          _1192 = ManualUpdateCB_DataPS_raw[((int)(_42 + 3))];
          _1198 = ManualUpdateCB_DataPS_raw[((int)(_42 + 4))];
          _1207 = dot(float4(_1171, _1172, _1173, _1170), float4(_1174.x, _1174.y, _1174.z, _1174.w)) + _1198.x;
          _1208 = dot(float4(_1171, _1172, _1173, _1170), float4(_1180.x, _1180.y, _1180.z, _1180.w)) + _1198.y;
          _1209 = dot(float4(_1171, _1172, _1173, _1170), float4(_1186.x, _1186.y, _1186.z, _1186.w)) + _1198.z;
          _1216 = saturate(((_1208 * 0.7152000069618225f) + (_1207 * 0.2125999927520752f)) + (_1209 * 0.0722000002861023f));
          _1222 = _1207;
          _1223 = _1208;
          _1224 = _1209;
          _1225 = 1.0f;
          _1226 = (((((dot(float4(_1171, _1172, _1173, _1170), float4(_1192.x, _1192.y, _1192.z, _1192.w)) + _1198.w) - _1216) * _1156) + _1216) * _1157);
        } else {
          _1222 = _1165;
          _1223 = _1166;
          _1224 = _1167;
          _1225 = _1155;
          _1226 = _1157;
        }
      } while (false);
    } while (false);
  }
  SV_Target.x = (_1226 * _1222);
  SV_Target.y = (_1226 * _1223);
  SV_Target.z = (_1226 * _1224);
  SV_Target.w = (_1226 * _1225);
  return SV_Target;
}