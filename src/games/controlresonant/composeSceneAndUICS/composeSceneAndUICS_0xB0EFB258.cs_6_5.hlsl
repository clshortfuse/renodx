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
  float _359;
  float _370;
  float _381;
  float _395;
  float _406;
  float _417;
  float _435;
  float _446;
  float _457;
  float _462;
  float _463;
  float _464;
  float _482;
  float _483;
  float _484;
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
  float _346;
  float _347;
  float _348;
  float _382;
  float _383;
  float _384;
  float _418;
  float _422;
  float _423;
  float _424;
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
              _462 = _233;
              _463 = _234;
              _464 = _235;
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
                    _346 = _233 / ui_brightness;
                    _347 = _234 / ui_brightness;
                    _348 = _235 / ui_brightness;
                    do {
                      [branch]
                      if (!(_346 <= 0.0031308000907301903f)) {
                        _359 = (((pow(_346, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _359 = (_346 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_347 <= 0.0031308000907301903f)) {
                          _370 = (((pow(_347, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _370 = (_347 * 12.920000076293945f);
                        }
                        do {
                          [branch]
                          if (!(_348 <= 0.0031308000907301903f)) {
                            _381 = (((pow(_348, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          } else {
                            _381 = (_348 * 12.920000076293945f);
                          }
                          _382 = _343 / ui_brightness;
                          _383 = _344 / ui_brightness;
                          _384 = _345 / ui_brightness;
                          do {
                            [branch]
                            if (!(_382 <= 0.0031308000907301903f)) {
                              _395 = (((pow(_382, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            } else {
                              _395 = (_382 * 12.920000076293945f);
                            }
                            do {
                              [branch]
                              if (!(_383 <= 0.0031308000907301903f)) {
                                _406 = (((pow(_383, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                              } else {
                                _406 = (_383 * 12.920000076293945f);
                              }
                              do {
                                [branch]
                                if (!(_384 <= 0.0031308000907301903f)) {
                                  _417 = (((pow(_384, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                                } else {
                                  _417 = (_384 * 12.920000076293945f);
                                }
                                _418 = 1.0f - _9.w;
                                _422 = (_395 * _418) + _359;
                                _423 = (_406 * _418) + _370;
                                _424 = (_417 * _418) + _381;
                                do {
                                  [branch]
                                  if (!(_422 <= 0.040449999272823334f)) {
                                    _435 = exp2(log2((_422 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                  } else {
                                    _435 = (_422 * 0.07739938050508499f);
                                  }
                                  do {
                                    [branch]
                                    if (!(_423 <= 0.040449999272823334f)) {
                                      _446 = exp2(log2((_423 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                    } else {
                                      _446 = (_423 * 0.07739938050508499f);
                                    }
                                    do {
                                      [branch]
                                      if (!(_424 <= 0.040449999272823334f)) {
                                        _457 = exp2(log2((_424 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                      } else {
                                        _457 = (_424 * 0.07739938050508499f);
                                      }
                                      _462 = (_435 * ui_brightness);
                                      _463 = (_446 * ui_brightness);
                                      _464 = (_457 * ui_brightness);
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
                _482 = _462;
                _483 = _463;
                _484 = _464;
                if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
                  _482 = mad(0.043306104838848114f, _464, mad(0.329291969537735f, _463, (_462 * 0.6274019479751587f)));
                  _483 = mad(0.0113602289929986f, _464, mad(0.9195442795753479f, _463, (_462 * 0.06909549236297607f)));
                  _484 = mad(0.895578145980835f, _464, mad(0.08802816271781921f, _463, (_462 * 0.016393709927797318f)));
                }
                g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(_482, _483, _484, _9.w);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  }
}
