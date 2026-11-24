#include "./UI.hlsli"

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
  float4 _9;
  float _118;
  float _129;
  float _140;
  float _228;
  float _229;
  float _230;
  float _254;
  float _255;
  float _256;
  float _338;
  float _339;
  float _340;
  float _387;
  float _398;
  float _409;
  float _423;
  float _434;
  float _445;
  float _463;
  float _474;
  float _485;
  float _486;
  float _487;
  float _505;
  float _506;
  float _507;
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
  float _160;
  float _161;
  float _162;
  float _190;
  float _192;
  float _193;
  float _194;
  float _196;
  float4 _198;
  float4 _202;
  float _234;
  float _235;
  float _236;
  float _273;
  float _274;
  float _275;
  float _303;
  float _305;
  float _306;
  float _307;
  float _309;
  float4 _311;
  float4 _315;
  float _342;
  float _355;
  float _356;
  float _367;
  float _410;
  float _411;
  float _412;
  float _446;
  float _450;
  float _451;
  float _452;
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
          do {
            _228 = _118;
            _229 = _129;
            _230 = _140;
            if (g_fUIColorblindnessCompensationIntensity > 0.0f) {
              _160 = exp2(log2(saturate((_118 / _9.w) * 0.00800000037997961f)) * 0.1593017578125f);
              _161 = exp2(log2(saturate((_129 / _9.w) * 0.00800000037997961f)) * 0.1593017578125f);
              _162 = exp2(log2(saturate((_140 / _9.w) * 0.00800000037997961f)) * 0.1593017578125f);
              _190 = (exp2(log2(((_161 * 18.8515625f) + 0.8359375f) / ((_161 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
              _192 = max((exp2(log2(((_162 * 18.8515625f) + 0.8359375f) / ((_162 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
              _193 = floor(_192);
              _194 = _192 - _193;
              _196 = (((exp2(log2(((_160 * 18.8515625f) + 0.8359375f) / ((_160 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _193) * 0.02083333395421505f;
              _198 = g_tColorGradingLUT.SampleLevel(g_sLinearClamp_internal, float2(_196, _190), 0.0f);
              _202 = g_tColorGradingLUT.SampleLevel(g_sLinearClamp_internal, float2((_196 + 0.02083333395421505f), _190), 0.0f);
              _228 = (((((lerp(_198.x, _202.x, _194)) * _9.w) - _118) * g_fUIColorblindnessCompensationIntensity) + _118);
              _229 = (((((lerp(_198.y, _202.y, _194)) * _9.w) - _129) * g_fUIColorblindnessCompensationIntensity) + _129);
              _230 = (((((lerp(_198.z, _202.z, _194)) * _9.w) - _140) * g_fUIColorblindnessCompensationIntensity) + _140);
            }
            do {
              _485 = _228;
              _486 = _229;
              _487 = _230;
              if (!(_9.w == 1.0f)) {
                _234 = g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))].x;
                _235 = g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))].y;
                _236 = g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))].z;
                do {
                  _254 = _234;
                  _255 = _235;
                  _256 = _236;
                  if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
                    _254 = mad(-0.07283977419137955f, _236, mad(-0.5876564383506775f, _235, (_234 * 1.6604962348937988f)));
                    _255 = mad(-0.008348013274371624f, _236, mad(1.1328951120376587f, _235, (_234 * -0.1245470941066742f)));
                    _256 = mad(1.118751049041748f, _236, mad(-0.10059737414121628f, _235, (_234 * -0.018153680488467216f)));
                  }
                  do {
                    _338 = _254;
                    _339 = _255;
                    _340 = _256;
                    if (g_fGameColorblindnessCompensationIntensity > 0.0f) {
                      _273 = exp2(log2(saturate(_254 * 0.00800000037997961f)) * 0.1593017578125f);
                      _274 = exp2(log2(saturate(_255 * 0.00800000037997961f)) * 0.1593017578125f);
                      _275 = exp2(log2(saturate(_256 * 0.00800000037997961f)) * 0.1593017578125f);
                      _303 = (exp2(log2(((_274 * 18.8515625f) + 0.8359375f) / ((_274 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f;
                      _305 = max((exp2(log2(((_275 * 18.8515625f) + 0.8359375f) / ((_275 * 18.6875f) + 1.0f)) * 78.84375f) * 47.0f), 0.0f);
                      _306 = floor(_305);
                      _307 = _305 - _306;
                      _309 = (((exp2(log2(((_273 * 18.8515625f) + 0.8359375f) / ((_273 * 18.6875f) + 1.0f)) * 78.84375f) * 0.9791666865348816f) + 0.010416666977107525f) + _306) * 0.02083333395421505f;
                      _311 = g_tColorGradingLUT.SampleLevel(g_sLinearClamp_internal, float2(_309, _303), 0.0f);
                      _315 = g_tColorGradingLUT.SampleLevel(g_sLinearClamp_internal, float2((_309 + 0.02083333395421505f), _303), 0.0f);
                      _338 = ((((_311.x - _254) + ((_315.x - _311.x) * _307)) * g_fGameColorblindnessCompensationIntensity) + _254);
                      _339 = ((((_311.y - _255) + ((_315.y - _311.y) * _307)) * g_fGameColorblindnessCompensationIntensity) + _255);
                      _340 = ((((_311.z - _256) + ((_315.z - _311.z) * _307)) * g_fGameColorblindnessCompensationIntensity) + _256);
                    }
                    _342 = max(dot(float3(_338, _339, _340), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f);
                    _355 = ((saturate(1.0f - dot(float3(_228, _229, _230), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f))) + -1.0f) * g_fUIHDRBackgroundDarkeningBlackInfluence) + 1.0f;
                    _356 = saturate(_9.w);
                    _367 = (exp2(log2(max((_355 * _356), 1.1754943508222875e-38f)) * (1.0f / max(g_fUIHDRBackgroundDarkeningStrength, 1.1754943508222875e-38f))) * ((select((!(_342 == 0.0f)), (1.0f / _342), 0.0f) * (_342 / (_342 + 1.0f))) + -1.0f)) + 1.0f;
                    do {
                      [branch]
                      if (!(_228 <= 0.0031308000907301903f)) {
                        _387 = (((pow(_228, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      } else {
                        _387 = (_228 * 12.920000076293945f);
                      }
                      do {
                        [branch]
                        if (!(_229 <= 0.0031308000907301903f)) {
                          _398 = (((pow(_229, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        } else {
                          _398 = (_229 * 12.920000076293945f);
                        }
                        do {
                          [branch]
                          if (!(_230 <= 0.0031308000907301903f)) {
                            _409 = (((pow(_230, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          } else {
                            _409 = (_230 * 12.920000076293945f);
                          }
                          _410 = _367 * _338;
                          _411 = _367 * _339;
                          _412 = _367 * _340;
                          do {
                            [branch]
                            if (!(_410 <= 0.0031308000907301903f)) {
                              _423 = (((pow(_410, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            } else {
                              _423 = (_410 * 12.920000076293945f);
                            }
                            do {
                              [branch]
                              if (!(_411 <= 0.0031308000907301903f)) {
                                _434 = (((pow(_411, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                              } else {
                                _434 = (_411 * 12.920000076293945f);
                              }
                              do {
                                [branch]
                                if (!(_412 <= 0.0031308000907301903f)) {
                                  _445 = (((pow(_412, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                                } else {
                                  _445 = (_412 * 12.920000076293945f);
                                }
                                _446 = 1.0f - exp2(((((1.0f / g_fUIHDRBackgroundDarkeningAlphaStrength) + -1.0f) * _355) + 1.0f) * log2(max(_356, 1.1754943508222875e-38f)));
                                _450 = (_423 * _446) + _387;
                                _451 = (_434 * _446) + _398;
                                _452 = (_445 * _446) + _409;
                                do {
                                  [branch]
                                  if (!(_450 <= 0.040449999272823334f)) {
                                    _463 = exp2(log2((_450 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                  } else {
                                    _463 = (_450 * 0.07739938050508499f);
                                  }
                                  do {
                                    [branch]
                                    if (!(_451 <= 0.040449999272823334f)) {
                                      _474 = exp2(log2((_451 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                    } else {
                                      _474 = (_451 * 0.07739938050508499f);
                                    }
                                    [branch]
                                    if (!(_452 <= 0.040449999272823334f)) {
                                      _485 = _463;
                                      _486 = _474;
                                      _487 = exp2(log2((_452 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
                                    } else {
                                      _485 = _463;
                                      _486 = _474;
                                      _487 = (_452 * 0.07739938050508499f);
                                    }
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
                _505 = _485;
                _506 = _486;
                _507 = _487;
                if ((g_bHDR != 0) && (g_bHDR_scRGB == 0)) {
                  _505 = mad(0.043306104838848114f, _487, mad(0.329291969537735f, _486, (_485 * 0.6274019479751587f)));
                  _506 = mad(0.0113602289929986f, _487, mad(0.9195442795753479f, _486, (_485 * 0.06909549236297607f)));
                  _507 = mad(0.895578145980835f, _487, mad(0.08802816271781921f, _486, (_485 * 0.016393709927797318f)));
                }
                g_rwtBackground[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(_505, _506, _507, _9.w);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  }
}
