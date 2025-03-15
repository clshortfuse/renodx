#include "./postprocess.hlsl"

Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

Texture3D<float4> tTextureMap0 : register(t1);

Texture3D<float4> tTextureMap1 : register(t2);

Texture3D<float4> tTextureMap2 : register(t3);

cbuffer SceneInfo : register(b0) {
  float SceneInfo_023z : packoffset(c023.z);
  float SceneInfo_023w : packoffset(c023.w);
};

cbuffer CameraKerare : register(b1) {
  float CameraKerare_000x : packoffset(c000.x);
  float CameraKerare_000y : packoffset(c000.y);
  float CameraKerare_000z : packoffset(c000.z);
  float CameraKerare_000w : packoffset(c000.w);
};

cbuffer TonemapParam : register(b2) {
  float TonemapParam_000x : packoffset(c000.x);
  float TonemapParam_000y : packoffset(c000.y);
  float TonemapParam_000w : packoffset(c000.w);
  float TonemapParam_001x : packoffset(c001.x);
  float TonemapParam_001y : packoffset(c001.y);
  float TonemapParam_001z : packoffset(c001.z);
  float TonemapParam_001w : packoffset(c001.w);
  float TonemapParam_002x : packoffset(c002.x);
  float TonemapParam_002y : packoffset(c002.y);
  float TonemapParam_002z : packoffset(c002.z);
  float TonemapParam_002w : packoffset(c002.w);
};

cbuffer LDRPostProcessParam : register(b3) {
  float LDRPostProcessParam_010y : packoffset(c010.y);
  float LDRPostProcessParam_010z : packoffset(c010.z);
  float LDRPostProcessParam_011x : packoffset(c011.x);
  float LDRPostProcessParam_011y : packoffset(c011.y);
  float LDRPostProcessParam_012x : packoffset(c012.x);
  float LDRPostProcessParam_012y : packoffset(c012.y);
  float LDRPostProcessParam_012z : packoffset(c012.z);
  float LDRPostProcessParam_013x : packoffset(c013.x);
  float LDRPostProcessParam_013y : packoffset(c013.y);
  float LDRPostProcessParam_013z : packoffset(c013.z);
  float LDRPostProcessParam_014x : packoffset(c014.x);
  float LDRPostProcessParam_014y : packoffset(c014.y);
  float LDRPostProcessParam_014z : packoffset(c014.z);
  float LDRPostProcessParam_015x : packoffset(c015.x);
  float LDRPostProcessParam_015y : packoffset(c015.y);
  float LDRPostProcessParam_015z : packoffset(c015.z);
};

cbuffer CBControl : register(b4) {
  float CBControl_001x : packoffset(c001.x);
  float CBControl_001y : packoffset(c001.y);
  float CBControl_001z : packoffset(c001.z);
  float CBControl_002x : packoffset(c002.x);
  float CBControl_002y : packoffset(c002.y);
  float CBControl_002z : packoffset(c002.z);
  float CBControl_003x : packoffset(c003.x);
  float CBControl_003y : packoffset(c003.y);
  float CBControl_003z : packoffset(c003.z);
  float CBControl_005w : packoffset(c005.w);
  float CBControl_006x : packoffset(c006.x);
  float CBControl_006y : packoffset(c006.y);
  float CBControl_006z : packoffset(c006.z);
  uint CBControl_006w : packoffset(c006.w);
  float CBControl_007x : packoffset(c007.x);
  float CBControl_007y : packoffset(c007.y);
  float CBControl_007z : packoffset(c007.z);
  float CBControl_007w : packoffset(c007.w);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float4 SV_Target;
  float _70;
  float _145;
  float _166;
  float _186;
  float _194;
  float _195;
  float _196;
  float _228;
  float _238;
  float _248;
  float _274;
  float _288;
  float _302;
  float _313;
  float _322;
  float _331;
  float _356;
  float _370;
  float _384;
  float _405;
  float _415;
  float _425;
  float _450;
  float _464;
  float _478;
  float _500;
  float _510;
  float _520;
  float _545;
  float _559;
  float _573;
  float _584;
  float _585;
  float _586;
  float _620;
  float _629;
  float _638;
  float _709;
  float _710;
  float _711;
  [branch]
  if (CameraKerare_000w == 0.0f) {
    float _31 = Kerare.x / Kerare.w;
    float _32 = Kerare.y / Kerare.w;
    float _33 = Kerare.z / Kerare.w;
    float _37 = abs((rsqrt(dot(float3(_31, _32, _33), float3(_31, _32, _33)))) * _33);
    float _42 = _37 * _37;
    _70 = ((_42 * _42) * (1.0f - (saturate((CameraKerare_000x * _37) + CameraKerare_000y))));
  } else {
    float _53 = ((SceneInfo_023w * SV_Position.y) + -0.5f) * 2.0f;
    float _55 = (CameraKerare_000w * 2.0f) * ((SceneInfo_023z * SV_Position.x) + -0.5f);
    float _57 = sqrt(dot(float2(_55, _53), float2(_55, _53)));
    float _65 = (_57 * _57) + 1.0f;
    _70 = ((1.0f / (_65 * _65)) * (1.0f - (saturate((CameraKerare_000x * (1.0f / (_57 + 1.0f))) + CameraKerare_000y))));
  }
  float _73 = (saturate(_70 + CameraKerare_000z));
  CustomVignette(_73);
  _73 = _73 * Exposure;

  float4 _81 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((SceneInfo_023z * SV_Position.x), (SceneInfo_023w * SV_Position.y)));
  float _85 = _81.x * _73;
  float _86 = _81.y * _73;
  float _87 = _81.z * _73;
  float _102 = mad(_87, CBControl_003x, (mad(_86, CBControl_002x, (_85 * CBControl_001x))));
  float _105 = mad(_87, CBControl_003y, (mad(_86, CBControl_002y, (_85 * CBControl_001y))));
  float _108 = mad(_87, CBControl_003z, (mad(_86, CBControl_002z, (_85 * CBControl_001z))));
  if (!(((uint)(CBControl_006w)) == 0)) {
    float _114 = max((max(_102, _105)), _108);
    if (!(_114 == 0.0f)) {
      float _120 = abs(_114);
      float _121 = (_114 - _102) / _120;
      float _122 = (_114 - _105) / _120;
      float _123 = (_114 - _108) / _120;
      do {
        if (!(!(_121 >= CBControl_005w))) {
          float _133 = _121 - CBControl_005w;
          _145 = ((_133 / (exp2((log2((exp2((log2(_133 * CBControl_007x)) * (CBControl_006z))) + 1.0f)) * CBControl_007w))) + CBControl_005w);
        } else {
          _145 = _121;
        }
        do {
          if (!(!(_122 >= (CBControl_006x)))) {
            float _154 = _122 - (CBControl_006x);
            _166 = ((_154 / (exp2((log2((exp2((log2(_154 * CBControl_007y)) * (CBControl_006z))) + 1.0f)) * CBControl_007w))) + (CBControl_006x));
          } else {
            _166 = _122;
          }
          do {
            if (!(!(_123 >= (CBControl_006y)))) {
              float _174 = _123 - (CBControl_006y);
              _186 = ((_174 / (exp2((log2((exp2((log2(_174 * CBControl_007z)) * (CBControl_006z))) + 1.0f)) * CBControl_007w))) + (CBControl_006y));
            } else {
              _186 = _123;
            }
            _194 = (_114 - (_120 * _145));
            _195 = (_114 - (_120 * _166));
            _196 = (_114 - (_120 * _186));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _194 = _102;
      _195 = _105;
      _196 = _108;
    }
  } else {
    _194 = _102;
    _195 = _105;
    _196 = _108;
  }
  bool _219 = !(_194 <= 0.0078125f);
  if (!_219) {
    _228 = ((_194 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _228 = (((log2(_194)) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _229 = !(_195 <= 0.0078125f);
  if (!_229) {
    _238 = ((_195 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _238 = (((log2(_195)) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _239 = !(_196 <= 0.0078125f);
  if (!_239) {
    _248 = ((_196 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _248 = (((log2(_196)) + 9.720000267028809f) * 0.05707762390375137f);
  }
  float4 _257 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_228 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_238 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_248 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x)), 0.0f);
  if (_257.x < 0.155251145362854f) {
    _274 = ((_257.x + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if (((bool)(_257.x >= 0.155251145362854f)) && ((bool)(_257.x < 1.4679962396621704f))) {
      _274 = (exp2((_257.x * 17.520000457763672f) + -9.720000267028809f));
    } else {
      _274 = 65504.0f;
    }
  }
  if (_257.y < 0.155251145362854f) {
    _288 = ((_257.y + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if (((bool)(_257.y >= 0.155251145362854f)) && ((bool)(_257.y < 1.4679962396621704f))) {
      _288 = (exp2((_257.y * 17.520000457763672f) + -9.720000267028809f));
    } else {
      _288 = 65504.0f;
    }
  }
  if (_257.z < 0.155251145362854f) {
    _302 = ((_257.z + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if (((bool)(_257.z >= 0.155251145362854f)) && ((bool)(_257.z < 1.4679962396621704f))) {
      _302 = (exp2((_257.z * 17.520000457763672f) + -9.720000267028809f));
    } else {
      _302 = 65504.0f;
    }
  }
  [branch]
  if (LDRPostProcessParam_010y > 0.0f) {
    do {
      if (!_219) {
        _313 = ((_194 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _313 = (((log2(_194)) + 9.720000267028809f) * 0.05707762390375137f);
      }
      do {
        if (!_229) {
          _322 = ((_195 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _322 = (((log2(_195)) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!_239) {
            _331 = ((_196 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _331 = (((log2(_196)) + 9.720000267028809f) * 0.05707762390375137f);
          }
          float4 _339 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_313 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_322 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_331 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x)), 0.0f);
          do {
            if (_339.x < 0.155251145362854f) {
              _356 = ((_339.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if (((bool)(_339.x >= 0.155251145362854f)) && ((bool)(_339.x < 1.4679962396621704f))) {
                _356 = (exp2((_339.x * 17.520000457763672f) + -9.720000267028809f));
              } else {
                _356 = 65504.0f;
              }
            }
            do {
              if (_339.y < 0.155251145362854f) {
                _370 = ((_339.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if (((bool)(_339.y >= 0.155251145362854f)) && ((bool)(_339.y < 1.4679962396621704f))) {
                  _370 = (exp2((_339.y * 17.520000457763672f) + -9.720000267028809f));
                } else {
                  _370 = 65504.0f;
                }
              }
              do {
                if (_339.z < 0.155251145362854f) {
                  _384 = ((_339.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if (((bool)(_339.z >= 0.155251145362854f)) && ((bool)(_339.z < 1.4679962396621704f))) {
                    _384 = (exp2((_339.z * 17.520000457763672f) + -9.720000267028809f));
                  } else {
                    _384 = 65504.0f;
                  }
                }
                float _391 = ((_356 - _274) * LDRPostProcessParam_010y) + _274;
                float _392 = ((_370 - _288) * LDRPostProcessParam_010y) + _288;
                float _393 = ((_384 - _302) * LDRPostProcessParam_010y) + _302;
                if (LDRPostProcessParam_010z > 0.0f) {
                  do {
                    if (!(!(_391 <= 0.0078125f))) {
                      _405 = ((_391 * 10.540237426757812f) + 0.072905533015728f);
                    } else {
                      _405 = (((log2(_391)) + 9.720000267028809f) * 0.05707762390375137f);
                    }
                    do {
                      if (!(!(_392 <= 0.0078125f))) {
                        _415 = ((_392 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _415 = (((log2(_392)) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(!(_393 <= 0.0078125f))) {
                          _425 = ((_393 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _425 = (((log2(_393)) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        float4 _433 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_405 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_415 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_425 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x)), 0.0f);
                        do {
                          if (_433.x < 0.155251145362854f) {
                            _450 = ((_433.x + -0.072905533015728f) * 0.09487452358007431f);
                          } else {
                            if (((bool)(_433.x >= 0.155251145362854f)) && ((bool)(_433.x < 1.4679962396621704f))) {
                              _450 = (exp2((_433.x * 17.520000457763672f) + -9.720000267028809f));
                            } else {
                              _450 = 65504.0f;
                            }
                          }
                          do {
                            if (_433.y < 0.155251145362854f) {
                              _464 = ((_433.y + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if (((bool)(_433.y >= 0.155251145362854f)) && ((bool)(_433.y < 1.4679962396621704f))) {
                                _464 = (exp2((_433.y * 17.520000457763672f) + -9.720000267028809f));
                              } else {
                                _464 = 65504.0f;
                              }
                            }
                            do {
                              if (_433.z < 0.155251145362854f) {
                                _478 = ((_433.z + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if (((bool)(_433.z >= 0.155251145362854f)) && ((bool)(_433.z < 1.4679962396621704f))) {
                                  _478 = (exp2((_433.z * 17.520000457763672f) + -9.720000267028809f));
                                } else {
                                  _478 = 65504.0f;
                                }
                              }
                              _584 = (((_450 - _391) * LDRPostProcessParam_010z) + _391);
                              _585 = (((_464 - _392) * LDRPostProcessParam_010z) + _392);
                              _586 = (((_478 - _393) * LDRPostProcessParam_010z) + _393);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _584 = _391;
                  _585 = _392;
                  _586 = _393;
                }
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (LDRPostProcessParam_010z > 0.0f) {
      do {
        if (!(!(_274 <= 0.0078125f))) {
          _500 = ((_274 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _500 = (((log2(_274)) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(!(_288 <= 0.0078125f))) {
            _510 = ((_288 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _510 = (((log2(_288)) + 9.720000267028809f) * 0.05707762390375137f);
          }
          do {
            if (!(!(_302 <= 0.0078125f))) {
              _520 = ((_302 * 10.540237426757812f) + 0.072905533015728f);
            } else {
              _520 = (((log2(_302)) + 9.720000267028809f) * 0.05707762390375137f);
            }
            float4 _528 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_500 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_510 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_520 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x)), 0.0f);
            do {
              if (_528.x < 0.155251145362854f) {
                _545 = ((_528.x + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if (((bool)(_528.x >= 0.155251145362854f)) && ((bool)(_528.x < 1.4679962396621704f))) {
                  _545 = (exp2((_528.x * 17.520000457763672f) + -9.720000267028809f));
                } else {
                  _545 = 65504.0f;
                }
              }
              do {
                if (_528.y < 0.155251145362854f) {
                  _559 = ((_528.y + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if (((bool)(_528.y >= 0.155251145362854f)) && ((bool)(_528.y < 1.4679962396621704f))) {
                    _559 = (exp2((_528.y * 17.520000457763672f) + -9.720000267028809f));
                  } else {
                    _559 = 65504.0f;
                  }
                }
                do {
                  if (_528.z < 0.155251145362854f) {
                    _573 = ((_528.z + -0.072905533015728f) * 0.09487452358007431f);
                  } else {
                    if (((bool)(_528.z >= 0.155251145362854f)) && ((bool)(_528.z < 1.4679962396621704f))) {
                      _573 = (exp2((_528.z * 17.520000457763672f) + -9.720000267028809f));
                    } else {
                      _573 = 65504.0f;
                    }
                  }
                  _584 = (((_545 - _274) * LDRPostProcessParam_010z) + _274);
                  _585 = (((_559 - _288) * LDRPostProcessParam_010z) + _288);
                  _586 = (((_573 - _302) * LDRPostProcessParam_010z) + _302);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } else {
      _584 = _274;
      _585 = _288;
      _586 = _302;
    }
  }
  float _590 = (mad(_586, LDRPostProcessParam_014x, (mad(_585, LDRPostProcessParam_013x, (_584 * LDRPostProcessParam_012x))))) + LDRPostProcessParam_015x;
  float _594 = (mad(_586, LDRPostProcessParam_014y, (mad(_585, LDRPostProcessParam_013y, (_584 * LDRPostProcessParam_012y))))) + LDRPostProcessParam_015y;
  float _598 = (mad(_586, LDRPostProcessParam_014z, (mad(_585, LDRPostProcessParam_013z, (_584 * LDRPostProcessParam_012z))))) + LDRPostProcessParam_015z;
  float3 new_color = CustomLUTColor(float3(_194, _195, _196), float3(_590, _594, _598));
  _194 = new_color.r;
  _195 = new_color.g;
  _196 = new_color.b;
  
  bool _601 = isfinite(max((max(_590, _594)), _598));
  float _602 = (_601 ? _590 : 1.0f);
  float _603 = (_601 ? _594 : 1.0f);
  float _604 = (_601 ? _598 : 1.0f);
  if (TonemapParam_002w == 0.0f && ProcessSDRVanilla()) {
    float _612 = TonemapParam_002y * _602;
    do {
      if (!(_602 >= TonemapParam_000y)) {
        _620 = ((_612 * _612) * (3.0f - (_612 * 2.0f)));
      } else {
        _620 = 1.0f;
      }
      float _621 = TonemapParam_002y * _603;
      do {
        if (!(_603 >= TonemapParam_000y)) {
          _629 = ((_621 * _621) * (3.0f - (_621 * 2.0f)));
        } else {
          _629 = 1.0f;
        }
        float _630 = TonemapParam_002y * _604;
        do {
          if (!(_604 >= TonemapParam_000y)) {
            _638 = ((_630 * _630) * (3.0f - (_630 * 2.0f)));
          } else {
            _638 = 1.0f;
          }
          float _647 = (((bool)(_602 < TonemapParam_001y)) ? 0.0f : 1.0f);
          float _648 = (((bool)(_603 < TonemapParam_001y)) ? 0.0f : 1.0f);
          float _649 = (((bool)(_604 < TonemapParam_001y)) ? 0.0f : 1.0f);
          _709 = (((((TonemapParam_000x * _602) + TonemapParam_002z) * (_620 - _647)) + (((exp2((log2(_612)) * TonemapParam_000w)) * (1.0f - _620)) * TonemapParam_000y)) + ((TonemapParam_001x - ((exp2((TonemapParam_001w * _602) + TonemapParam_002x)) * TonemapParam_001z)) * _647));
          _710 = (((((TonemapParam_000x * _603) + TonemapParam_002z) * (_629 - _648)) + (((exp2((log2(_621)) * TonemapParam_000w)) * (1.0f - _629)) * TonemapParam_000y)) + ((TonemapParam_001x - ((exp2((TonemapParam_001w * _603) + TonemapParam_002x)) * TonemapParam_001z)) * _648));
          _711 = (((((TonemapParam_000x * _604) + TonemapParam_002z) * (_638 - _649)) + (((exp2((log2(_630)) * TonemapParam_000w)) * (1.0f - _638)) * TonemapParam_000y)) + ((TonemapParam_001x - ((exp2((TonemapParam_001w * _604) + TonemapParam_002x)) * TonemapParam_001z)) * _649));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _709 = _602;
    _710 = _603;
    _711 = _604;
  }
  SV_Target.x = _709;
  SV_Target.y = _710;
  SV_Target.z = _711;
  SV_Target.w = 0.0f;
  return SV_Target;
}
