#include "./common.hlsl"

Texture2D<float4> sceneTexture : register(t0);

Texture2D<float3> bloomMaskTexture : register(t1);

Texture3D<float3> colorLUT : register(t2);

Texture2D<float4> overlayTexture : register(t3);

cbuffer DeviceParameters : register(b0) {
  float4 g_sceneClipViewport : packoffset(c000.x);
  float g_screenMinNits : packoffset(c001.x);
  float g_screenMaxNits : packoffset(c001.y);
  float g_sceneNits : packoffset(c001.z);
  float g_overlayNits : packoffset(c001.w);
  float g_hdrGamma : packoffset(c002.x);
};

cbuffer BloomParams : register(b1) {
  float g_ppFlags : packoffset(c000.x);
  float g_bloomThreshold : packoffset(c000.y);
  float g_bloomMagnitude : packoffset(c000.z);
  float g_linearExposure : packoffset(c000.w);
  float g_middleGrayValue : packoffset(c001.x);
};

SamplerState samplerBilinearClamp : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _17 = (TEXCOORD.x - g_sceneClipViewport.x) / g_sceneClipViewport.z;
  float _18 = (TEXCOORD.y - g_sceneClipViewport.y) / g_sceneClipViewport.w;
  float _26 = float((bool)((bool)(((bool)((bool)(_17 > 0.0f) && (bool)(_18 > 0.0f))) && ((bool)((bool)(_17 < 1.0f) && (bool)(_18 < 1.0f))))));
  float4 _27 = sceneTexture.Sample(samplerBilinearClamp, float2(_17, _18));
  uint _34 = uint(g_ppFlags);
  float _118;
  float _119;
  float _155;
  float _176;
  float _220;
  float _221;
  float _257;
  float _278;
  float _320;
  float _321;
  float _357;
  float _378;
  float _420;
  float _421;
  float _457;
  float _478;
  float _489;
  float _490;
  float _491;
  bool _496;
  if (!((_34 & 8) == 0)) {
    uint2 _38; sceneTexture.GetDimensions(_38.x, _38.y);
    float _41 = float((uint)_38.x);
    float _42 = float((uint)_38.y);
    float _43 = _42 * _18;
    float _44 = _42 * 0.5f;
    float _45 = _17 + -0.5f;
    float _46 = _41 * _45;
    float _48 = _42 * (_18 + -0.5f);
    float _52 = sqrt((_46 * _46) + (_48 * _48));
    float _55 = saturate((_52 + -5.5f) * 0.5f);
    float _62 = saturate((_52 + -4.5f) * 0.5f);
    float _67 = ((_62 * _62) * (3.0f - (_62 * 2.0f))) - ((_55 * _55) * (3.0f - (_55 * 2.0f)));
    float _72 = (_67 * (1.0f - _27.x)) + _27.x;
    float _73 = _27.y - (_67 * _27.y);
    float _74 = _27.z - (_67 * _27.z);
    float4 _79 = sceneTexture.Load(int3(((uint)(uint(_41)) >> 1), ((uint)(uint(_42)) >> 1), 0));
    float _83 = dot(float3(_79.x, _79.y, _79.z), float3(0.33329999446868896f, 0.33329999446868896f, 0.33329999446868896f));
    float _86 = 1.0f - floor(_83 * 2.0f);
    float _87 = _46 * 0.125f;
    float _88 = _48 * 0.06666667014360428f;
    do {
      if (((bool)(!(_88 >= 1.0f))) && ((bool)(!(_88 > 0.0f)))) {
        float _94 = abs(_79.x);
        float _99 = max(floor(log2(abs(_94)) * 0.3010300099849701f), 0.0f);
        float _100 = floor(_87);
        float _101 = 4.0f - _100;
        do {
          if (_101 > -5.010000228881836f) {
            if (_101 > _99) {
              _155 = select(((bool)(_79.x < 0.0f) && (bool)(_101 < (_99 + 1.5f))), 1792.0f, 0.0f);
            } else {
              if (!(_101 == -1.0f)) {
                do {
                  if (_101 < 0.0f) {
                    _118 = (5.0f - _100);
                    _119 = frac(_94);
                  } else {
                    _118 = _101;
                    _119 = _94;
                  }
                  float _124 = abs(_119 / exp2(_118 * 3.321928024291992f)) * 0.10000000149011612f;
                  float _128 = frac(abs(_124));
                  int _133 = int(floor(select((_124 >= (-0.0f - _124)), _128, (-0.0f - _128)) * 10.0f));
                  _155 = select((_133 == 0), 480599.0f, select((_133 == 1), 139810.0f, select((_133 == 2), 476951.0f, select((_133 == 3), 476999.0f, select((_133 == 4), 350020.0f, select((_133 == 5), 464711.0f, select((_133 == 6), 464727.0f, select((_133 == 7), 476228.0f, select((_133 == 8), 481111.0f, select((_133 == 9), 481095.0f, 0.0f))))))))));
                } while (false);
              } else {
                _155 = 2.0f;
              }
            }
          } else {
            _155 = 0.0f;
          }
          float _166 = (_155 / exp2((floor(5.0f - (_48 * 0.3333333432674408f)) * 4.0f) + floor(frac(_87) * 4.0f))) * 0.5f;
          float _170 = frac(abs(_166));
          _176 = floor(select((_166 >= (-0.0f - _166)), _170, (-0.0f - _170)) * 2.0f);
        } while (false);
      } else {
        _176 = 0.0f;
      }
      float _183 = (_176 * (_86 - _72)) + _72;
      float _184 = (_176 * (_86 - _73)) + _73;
      float _185 = (_176 * (_86 - _74)) + _74;
      float _187 = (-20.0f - _44) + _43;
      float _189 = (_45 * 0.125f) * _41;
      float _190 = _187 * 0.06666667014360428f;
      do {
        if (((bool)(!(_190 >= 1.0f))) && ((bool)(!(_190 > 0.0f)))) {
          float _196 = abs(_79.y);
          float _201 = max(floor(log2(abs(_196)) * 0.3010300099849701f), 0.0f);
          float _202 = floor(_189);
          float _203 = 4.0f - _202;
          do {
            if (_203 > -5.010000228881836f) {
              if (_203 > _201) {
                _257 = select(((bool)(_79.y < 0.0f) && (bool)(_203 < (_201 + 1.5f))), 1792.0f, 0.0f);
              } else {
                if (!(_203 == -1.0f)) {
                  do {
                    if (_203 < 0.0f) {
                      _220 = (5.0f - _202);
                      _221 = frac(_196);
                    } else {
                      _220 = _203;
                      _221 = _196;
                    }
                    float _226 = abs(_221 / exp2(_220 * 3.321928024291992f)) * 0.10000000149011612f;
                    float _230 = frac(abs(_226));
                    int _235 = int(floor(select((_226 >= (-0.0f - _226)), _230, (-0.0f - _230)) * 10.0f));
                    _257 = select((_235 == 0), 480599.0f, select((_235 == 1), 139810.0f, select((_235 == 2), 476951.0f, select((_235 == 3), 476999.0f, select((_235 == 4), 350020.0f, select((_235 == 5), 464711.0f, select((_235 == 6), 464727.0f, select((_235 == 7), 476228.0f, select((_235 == 8), 481111.0f, select((_235 == 9), 481095.0f, 0.0f))))))))));
                  } while (false);
                } else {
                  _257 = 2.0f;
                }
              }
            } else {
              _257 = 0.0f;
            }
            float _268 = (_257 / exp2((floor(5.0f - (_187 * 0.3333333432674408f)) * 4.0f) + floor(frac(_189) * 4.0f))) * 0.5f;
            float _272 = frac(abs(_268));
            _278 = floor(select((_268 >= (-0.0f - _268)), _272, (-0.0f - _272)) * 2.0f);
          } while (false);
        } else {
          _278 = 0.0f;
        }
        float _285 = (_278 * (_86 - _183)) + _183;
        float _286 = (_278 * (_86 - _184)) + _184;
        float _287 = (_278 * (_86 - _185)) + _185;
        float _289 = (-40.0f - _44) + _43;
        float _290 = _289 * 0.06666667014360428f;
        do {
          if (((bool)(!(_290 >= 1.0f))) && ((bool)(!(_290 > 0.0f)))) {
            float _296 = abs(_79.z);
            float _301 = max(floor(log2(abs(_296)) * 0.3010300099849701f), 0.0f);
            float _302 = floor(_189);
            float _303 = 4.0f - _302;
            do {
              if (_303 > -5.010000228881836f) {
                if (_303 > _301) {
                  _357 = select(((bool)(_79.z < 0.0f) && (bool)(_303 < (_301 + 1.5f))), 1792.0f, 0.0f);
                } else {
                  if (!(_303 == -1.0f)) {
                    do {
                      if (_303 < 0.0f) {
                        _320 = (5.0f - _302);
                        _321 = frac(_296);
                      } else {
                        _320 = _303;
                        _321 = _296;
                      }
                      float _326 = abs(_321 / exp2(_320 * 3.321928024291992f)) * 0.10000000149011612f;
                      float _330 = frac(abs(_326));
                      int _335 = int(floor(select((_326 >= (-0.0f - _326)), _330, (-0.0f - _330)) * 10.0f));
                      _357 = select((_335 == 0), 480599.0f, select((_335 == 1), 139810.0f, select((_335 == 2), 476951.0f, select((_335 == 3), 476999.0f, select((_335 == 4), 350020.0f, select((_335 == 5), 464711.0f, select((_335 == 6), 464727.0f, select((_335 == 7), 476228.0f, select((_335 == 8), 481111.0f, select((_335 == 9), 481095.0f, 0.0f))))))))));
                    } while (false);
                  } else {
                    _357 = 2.0f;
                  }
                }
              } else {
                _357 = 0.0f;
              }
              float _368 = (_357 / exp2((floor(5.0f - (_289 * 0.3333333432674408f)) * 4.0f) + floor(frac(_189) * 4.0f))) * 0.5f;
              float _372 = frac(abs(_368));
              _378 = floor(select((_368 >= (-0.0f - _368)), _372, (-0.0f - _372)) * 2.0f);
            } while (false);
          } else {
            _378 = 0.0f;
          }
          float _385 = (_378 * (_86 - _285)) + _285;
          float _386 = (_378 * (_86 - _286)) + _286;
          float _387 = (_378 * (_86 - _287)) + _287;
          float _389 = (-66.0f - _44) + _43;
          float _390 = _389 * 0.06666667014360428f;
          do {
            if (((bool)(!(_390 >= 1.0f))) && ((bool)(!(_390 > 0.0f)))) {
              float _396 = abs(_83);
              float _401 = max(floor(log2(abs(_396)) * 0.3010300099849701f), 0.0f);
              float _402 = floor(_189);
              float _403 = 4.0f - _402;
              do {
                if (_403 > -5.010000228881836f) {
                  if (_403 > _401) {
                    _457 = select(((bool)(_83 < 0.0f) && (bool)(_403 < (_401 + 1.5f))), 1792.0f, 0.0f);
                  } else {
                    if (!(_403 == -1.0f)) {
                      do {
                        if (_403 < 0.0f) {
                          _420 = (5.0f - _402);
                          _421 = frac(_396);
                        } else {
                          _420 = _403;
                          _421 = _396;
                        }
                        float _426 = abs(_421 / exp2(_420 * 3.321928024291992f)) * 0.10000000149011612f;
                        float _430 = frac(abs(_426));
                        int _435 = int(floor(select((_426 >= (-0.0f - _426)), _430, (-0.0f - _430)) * 10.0f));
                        _457 = select((_435 == 0), 480599.0f, select((_435 == 1), 139810.0f, select((_435 == 2), 476951.0f, select((_435 == 3), 476999.0f, select((_435 == 4), 350020.0f, select((_435 == 5), 464711.0f, select((_435 == 6), 464727.0f, select((_435 == 7), 476228.0f, select((_435 == 8), 481111.0f, select((_435 == 9), 481095.0f, 0.0f))))))))));
                      } while (false);
                    } else {
                      _457 = 2.0f;
                    }
                  }
                } else {
                  _457 = 0.0f;
                }
                float _468 = (_457 / exp2((floor(5.0f - (_389 * 0.3333333432674408f)) * 4.0f) + floor(frac(_189) * 4.0f))) * 0.5f;
                float _472 = frac(abs(_468));
                _478 = floor(select((_468 >= (-0.0f - _468)), _472, (-0.0f - _472)) * 2.0f);
              } while (false);
            } else {
              _478 = 0.0f;
            }
            _489 = ((_478 * (_86 - _385)) + _385);
            _490 = ((_478 * (_86 - _386)) + _386);
            _491 = ((_478 * (_86 - _387)) + _387);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _489 = _27.x;
    _490 = _27.y;
    _491 = _27.z;
  }
  if (!((_34 & 4) == 0)) {
    SV_Target.x = _489;
    SV_Target.y = _490;
    SV_Target.z = _491;
    SV_Target.w = 1.0f;
    _496 = false;
  } else {
    _496 = true;
  }
  if (_496) {
    float3 _498 = bloomMaskTexture.Sample(samplerBilinearClamp, float2(_17, _18));
    float _510 = (((g_bloomMagnitude * CUSTOM_BLOOM) * _498.x) + _489) * _26;
    float _511 = (((g_bloomMagnitude * CUSTOM_BLOOM) * _498.y) + _490) * _26;
    float _512 = (((g_bloomMagnitude * CUSTOM_BLOOM) * _498.z) + _491) * _26;

    float3 untonemapped = ApplyCustomGrade1(float3(_510, _511, _512));

    float3 output_color;
    if (RENODX_TONE_MAP_TYPE > 0.f) {
      float3 sdr_color = NeutralSDR(untonemapped);

      float3 encoded = saturate(log2(sdr_color + 0.002667719265446067f) * 0.0714285746216774f + 0.6107269525527954f);

      float3 tonemapped = renodx::lut::SampleTetrahedral(colorLUT, encoded, 32.f);

      float3 upgraded_tonemap = renodx::tonemap::UpgradeToneMap(untonemapped, sdr_color, tonemapped, RENODX_COLOR_GRADE_STRENGTH);

      float3 final_color = ApplyCustomGrade2(upgraded_tonemap);

      output_color = N2PerChannelLMS(final_color);
    } else {
      float3 tonemapped = colorLUT.Sample(samplerBilinearClamp, float3(((saturate((log2(_510 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_511 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_512 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));

      output_color = lerp(untonemapped, tonemapped, RENODX_COLOR_GRADE_STRENGTH);
    }
    output_color = renodx::draw::RenderIntermediatePass(output_color);

    float3 _534 = output_color;
    
    bool _541 = (((uint)(uint(g_ppFlags)) & 2) != 0);
    float4 _545 = overlayTexture.Sample(samplerBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
    float _553 = (_545.w * select(_541, _510, _534.x)) + _545.x;
    float _554 = (_545.w * select(_541, _511, _534.y)) + _545.y;
    float _555 = (_545.w * select(_541, _512, _534.z)) + _545.z;

    // SV_Target.x = select((_553 < 0.0031308000907301903f), (_553 * 12.920000076293945f), (((pow(_553, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    // SV_Target.y = select((_554 < 0.0031308000907301903f), (_554 * 12.920000076293945f), (((pow(_554, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    // SV_Target.z = select((_555 < 0.0031308000907301903f), (_555 * 12.920000076293945f), (((pow(_555, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    
    SV_Target.x = _553;
    SV_Target.y = _554;
    SV_Target.z = _555;
    SV_Target.w = (_27.w * _26);
  }
  
  SV_Target.rgb = renodx::draw::SwapChainPass(SV_Target.rgb);
  return SV_Target;
}
