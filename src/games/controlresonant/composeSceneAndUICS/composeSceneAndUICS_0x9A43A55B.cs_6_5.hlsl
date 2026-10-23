#include "./composeSceneAndUICS.hlsli"

Texture2D<float4> g_tFillSource : register(t0);

Texture2D<float4> g_tColorGradingLUT : register(t1);

RWTexture2D<float4> g_rwtBackground : register(u0);

cbuffer shared_hdr_global : register(b0) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

cbuffer ui_compositing : register(b1) {
  float g_fUIHDRBackgroundDarkeningStrength : packoffset(c000.x);
  float g_fUIHDRBackgroundDarkeningAlphaStrength : packoffset(c000.y);
  float g_fUIHDRBackgroundDarkeningBlackInfluence : packoffset(c000.z);
  float g_fGameColorblindnessCompensationIntensity : packoffset(c000.w);
  float g_fUIColorblindnessCompensationIntensity : packoffset(c001.x);
};

SamplerState g_sLinearClamp_internal : register(s6, space1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  const float ui_brightness = ConditionalOverrideUIBrightness(g_fSDRBrightnessMultiplier, g_bHDR);
  float4 _9;
  float _118;
  float _129;
  float _140;
  float _233;
  float _234;
  float _235;
  float _259;
  float _260;
  float _261;
  float _343;
  float _344;
  float _345;
  float _401;
  float _412;
  float _423;
  float _437;
  float _448;
  float _459;
  float _477;
  float _488;
  float _499;
  float _504;
  float _505;
  float _506;
  float _524;
  float _525;
  float _526;
  float _27;
  float _28;
  float _29;
  float _30;
  float _43;
  float _44;
  float _45;
  float _73;
  float _75;
  float _76;
  float _77;
  float _79;
  float4 _81;
  float4 _85;
  float _143;
  float _144;
  float _145;
  float _165;
  float _166;
  float _167;
  float _195;
  float _197;
  float _198;
  float _199;
  float _201;
  float4 _203;
  float4 _207;
  float _239;
  float _240;
  float _241;
  float _278;
  float _279;
  float _280;
  float _308;
  float _310;
  float _311;
  float _312;
  float _314;
  float4 _316;
  float4 _320;
  float _347;
  float _348;
  float _363;
  float _364;
  float _375;
  float _388;
  float _389;
  float _390;
  float _424;
  float _425;
  float _426;
  float _460;
  float _464;
  float _465;
  float _466;
  _9 = g_tFillSource.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
  if ((_9.w == 0.0f) && ((_9.z == 0.0f) && ((_9.x == 0.0f) && (_9.y == 0.0f)))) {
    if (g_fGameColorblindnessCompensationIntensity > 0.0f) {
      _27 = g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))].x;
      _28 = g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))].y;
      _29 = g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))].z;
      _30 = g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))].w;
      _43 = exp2(log2(saturate(_27 * 0.00800000037997961f)) * 0.1593017578125f);
      _44 = exp2(log2(saturate(_28 * 0.00800000037997961f)) * 0.1593017578125f);
      _45 = exp2(log2(saturate(_29 * 0.00800000037997961f)) * 0.1593017578125f);
      _73 = (exp2(log2(((_44 * 18.8515625f) + 0.8359375f) / ((_44 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
      _75 = max((exp2(log2(((_45 * 18.8515625f) + 0.8359375f) / ((_45 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
      _76 = floor(_75);
      _77 = _75 - _76;
      _79 = (((exp2(log2(((_43 * 18.8515625f) + 0.8359375f) / ((_43 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _76) * 0.02083333395421505f;
      _81 = g_tColorGradingLUT.SampleLevel(g_sLinearClamp_internal, float2(_79, _73), 0.0f);
      _85 = g_tColorGradingLUT.SampleLevel(g_sLinearClamp_internal, float2((_79 + 0.02083333395421505f), _73), 0.0f);
      g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(((((_81.x - _27) + ((_85.x - _81.x) * _77)) * g_fGameColorblindnessCompensationIntensity) + _27), ((((_81.y - _28) + ((_85.y - _81.y) * _77)) * g_fGameColorblindnessCompensationIntensity) + _28), ((((_81.z - _29) + ((_85.z - _81.z) * _77)) * g_fGameColorblindnessCompensationIntensity) + _29), _30);
    }
  } else {
    do {
      [branch]
      if (!(_9.x <= 0.040449999272823334f)) {
        _118 = exp2(log2((_9.x + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
      } else {
        _118 = (_9.x * 0.07739938050508499f);
      }
      do {
        [branch]
        if (!(_9.y <= 0.040449999272823334f)) {
          _129 = exp2(log2((_9.y + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
        } else {
          _129 = (_9.y * 0.07739938050508499f);
        }
        do {
          [branch]
          if (!(_9.z <= 0.040449999272823334f)) {
            _140 = exp2(log2((_9.z + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
          } else {
            _140 = (_9.z * 0.07739938050508499f);
          }
          _143 = ui_brightness * _118;
          _144 = ui_brightness * _129;
          _145 = ui_brightness * _140;
          do {
            _233 = _143;
            _234 = _144;
            _235 = _145;
            if (g_fUIColorblindnessCompensationIntensity > 0.0f) {
              _165 = exp2(log2(saturate((_143 / _9.w) * 0.00800000037997961f)) * 0.1593017578125f);
              _166 = exp2(log2(saturate((_144 / _9.w) * 0.00800000037997961f)) * 0.1593017578125f);
              _167 = exp2(log2(saturate((_145 / _9.w) * 0.00800000037997961f)) * 0.1593017578125f);
              _195 = (exp2(log2(((_166 * 18.8515625f) + 0.8359375f) / ((_166 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
              _197 = max((exp2(log2(((_167 * 18.8515625f) + 0.8359375f) / ((_167 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
              _198 = floor(_197);
              _199 = _197 - _198;
              _201 = (((exp2(log2(((_165 * 18.8515625f) + 0.8359375f) / ((_165 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _198) * 0.02083333395421505f;
              _203 = g_tColorGradingLUT.SampleLevel(g_sLinearClamp_internal, float2(_201, _195), 0.0f);
              _207 = g_tColorGradingLUT.SampleLevel(g_sLinearClamp_internal, float2((_201 + 0.02083333395421505f), _195), 0.0f);
              _233 = (((((lerp(_203.x, _207.x, _199)) * _9.w) - _143) * g_fUIColorblindnessCompensationIntensity) + _143);
              _234 = (((((lerp(_203.y, _207.y, _199)) * _9.w) - _144) * g_fUIColorblindnessCompensationIntensity) + _144);
              _235 = (((((lerp(_203.z, _207.z, _199)) * _9.w) - _145) * g_fUIColorblindnessCompensationIntensity) + _145);
            }
            do {
              _504 = _233;
              _505 = _234;
              _506 = _235;
              if (!(_9.w == 1.0f)) {
                _239 = g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))].x;
                _240 = g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))].y;
                _241 = g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))].z;
                do {
                  _259 = _239;
                  _260 = _240;
                  _261 = _241;
                  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
                    _259 = mad(-0.07283977419137955f, _241, mad(-0.5876564383506775f, _240, (_239 * 1.6604962348937988f)));
                    _260 = mad(-0.008348013274371624f, _241, mad(1.1328951120376587f, _240, (_239 * -0.1245470941066742f)));
                    _261 = mad(1.118751049041748f, _241, mad(-0.10059737414121628f, _240, (_239 * -0.018153680488467216f)));
                  }
                  do {
                    _343 = _259;
                    _344 = _260;
                    _345 = _261;
                    if (g_fGameColorblindnessCompensationIntensity > 0.0f) {
                      _278 = exp2(log2(saturate(_259 * 0.00800000037997961f)) * 0.1593017578125f);
                      _279 = exp2(log2(saturate(_260 * 0.00800000037997961f)) * 0.1593017578125f);
                      _280 = exp2(log2(saturate(_261 * 0.00800000037997961f)) * 0.1593017578125f);
                      _308 = (exp2(log2(((_279 * 18.8515625f) + 0.8359375f) / ((_279 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
                      _310 = max((exp2(log2(((_280 * 18.8515625f) + 0.8359375f) / ((_280 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
                      _311 = floor(_310);
                      _312 = _310 - _311;
                      _314 = (((exp2(log2(((_278 * 18.8515625f) + 0.8359375f) / ((_278 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _311) * 0.02083333395421505f;
                      _316 = g_tColorGradingLUT.SampleLevel(g_sLinearClamp_internal, float2(_314, _308), 0.0f);
                      _320 = g_tColorGradingLUT.SampleLevel(g_sLinearClamp_internal, float2((_314 + 0.02083333395421505f), _308), 0.0f);
                      _343 = ((((_316.x - _259) + ((_320.x - _316.x) * _312)) * g_fGameColorblindnessCompensationIntensity) + _259);
                      _344 = ((((_316.y - _260) + ((_320.y - _316.y) * _312)) * g_fGameColorblindnessCompensationIntensity) + _260);
                      _345 = ((((_316.z - _261) + ((_320.z - _316.z) * _312)) * g_fGameColorblindnessCompensationIntensity) + _261);
                    }
                    _347 = max(dot(float3(_343, _344, _345), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f);
                    _348 = _347 / ui_brightness;
                    _363 = ((saturate(1.0f - (dot(float3(_233, _234, _235), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) / ui_brightness)) + -1.0f) * g_fUIHDRBackgroundDarkeningBlackInfluence) + 1.0f;
                    _364 = saturate(_9.w);
                    _375 = (exp2(log2(max((_363 * _364), 1.1754943508222875e-38f)) * (1.0f / max(g_fUIHDRBackgroundDarkeningStrength, 1.1754943508222875e-38f))) * ((((_348 / (_348 + 1.0f)) * ui_brightness) * select((!(_347 == 0.0f)), (1.0f / _347), 0.0f)) + -1.0f)) + 1.0f;
                    _388 = _233 / ui_brightness;
                    _389 = _234 / ui_brightness;
                    _390 = _235 / ui_brightness;
                    do {
                      [branch]
                      if (!(_388 <= 0.0031308000907301903f)) {
                        _401 = (((pow(_388, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _401 = (_388 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_389 <= 0.0031308000907301903f)) {
                          _412 = (((pow(_389, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _412 = (_389 * 12.920000076293945f);
                        }
                        do {
                          [branch]
                          if (!(_390 <= 0.0031308000907301903f)) {
                            _423 = (((pow(_390, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          } else {
                            _423 = (_390 * 12.920000076293945f);
                          }
                          _424 = (_375 * _343) / ui_brightness;
                          _425 = (_375 * _344) / ui_brightness;
                          _426 = (_375 * _345) / ui_brightness;
                          do {
                            [branch]
                            if (!(_424 <= 0.0031308000907301903f)) {
                              _437 = (((pow(_424, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            } else {
                              _437 = (_424 * 12.920000076293945f);
                            }
                            do {
                              [branch]
                              if (!(_425 <= 0.0031308000907301903f)) {
                                _448 = (((pow(_425, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                              } else {
                                _448 = (_425 * 12.920000076293945f);
                              }
                              do {
                                [branch]
                                if (!(_426 <= 0.0031308000907301903f)) {
                                  _459 = (((pow(_426, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                                } else {
                                  _459 = (_426 * 12.920000076293945f);
                                }
                                _460 = 1.0f - exp2(((((1.0f / g_fUIHDRBackgroundDarkeningAlphaStrength) + -1.0f) * _363) + 1.0f) * log2(max(_364, 1.1754943508222875e-38f)));
                                _464 = (_437 * _460) + _401;
                                _465 = (_448 * _460) + _412;
                                _466 = (_459 * _460) + _423;
                                do {
                                  [branch]
                                  if (!(_464 <= 0.040449999272823334f)) {
                                    _477 = exp2(log2((_464 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                  } else {
                                    _477 = (_464 * 0.07739938050508499f);
                                  }
                                  do {
                                    [branch]
                                    if (!(_465 <= 0.040449999272823334f)) {
                                      _488 = exp2(log2((_465 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                    } else {
                                      _488 = (_465 * 0.07739938050508499f);
                                    }
                                    do {
                                      [branch]
                                      if (!(_466 <= 0.040449999272823334f)) {
                                        _499 = exp2(log2((_466 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                      } else {
                                        _499 = (_466 * 0.07739938050508499f);
                                      }
                                      _504 = (_477 * ui_brightness);
                                      _505 = (_488 * ui_brightness);
                                      _506 = (_499 * ui_brightness);
                                    } while (false);
                                  } while (false);
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              }
              do {
                _524 = _504;
                _525 = _505;
                _526 = _506;
                if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
                  _524 = mad(0.043306104838848114f, _506, mad(0.329291969537735f, _505, (_504 * 0.6274019479751587f)));
                  _525 = mad(0.0113602289929986f, _506, mad(0.9195442795753479f, _505, (_504 * 0.06909549236297607f)));
                  _526 = mad(0.895578145980835f, _506, mad(0.08802816271781921f, _505, (_504 * 0.016393709927797318f)));
                }
                g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(_524, _525, _526, _9.w);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  }
}
