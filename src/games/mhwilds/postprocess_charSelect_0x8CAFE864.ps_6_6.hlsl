#include "./postprocess.hlsl"

Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

struct _WhitePtSrv {
  float data[1];
};
Buffer<uint4> WhitePtSrv : register(t1);

Texture3D<float2> BilateralLuminanceSRV : register(t2);

Texture2D<float> BlurredLogLumSRV : register(t3);

Texture3D<float4> tTextureMap0 : register(t4);

Texture3D<float4> tTextureMap1 : register(t5);

Texture3D<float4> tTextureMap2 : register(t6);

cbuffer SceneInfo : register(b0) {
  float SceneInfo_023z : packoffset(c023.z);
  float SceneInfo_023w : packoffset(c023.w);
};

cbuffer RangeCompressInfo : register(b1) {
  float RangeCompressInfo_000y : packoffset(c000.y);
};

cbuffer Tonemap : register(b2) {
  float Tonemap_000x : packoffset(c000.x);
  uint Tonemap_001y : packoffset(c001.y);
  float Tonemap_003z : packoffset(c003.z);
  float Tonemap_003w : packoffset(c003.w);
  float Tonemap_004x : packoffset(c004.x);
  float Tonemap_004y : packoffset(c004.y);
  float Tonemap_004z : packoffset(c004.z);
  float Tonemap_004w : packoffset(c004.w);
  float Tonemap_005x : packoffset(c005.x);
};

cbuffer CameraKerare : register(b3) {
  float CameraKerare_000x : packoffset(c000.x);
  float CameraKerare_000y : packoffset(c000.y);
  float CameraKerare_000z : packoffset(c000.z);
  float CameraKerare_000w : packoffset(c000.w);
};

cbuffer TonemapParam : register(b4) {
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

cbuffer LDRPostProcessParam : register(b5) {
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

cbuffer CBControl : register(b6) {
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
  float _77;
  float _103;
  float _218;
  float _239;
  float _259;
  float _267;
  float _268;
  float _269;
  float _301;
  float _311;
  float _321;
  float _347;
  float _361;
  float _375;
  float _386;
  float _395;
  float _404;
  float _429;
  float _443;
  float _457;
  float _478;
  float _488;
  float _498;
  float _523;
  float _537;
  float _551;
  float _573;
  float _583;
  float _593;
  float _618;
  float _632;
  float _646;
  float _657;
  float _658;
  float _659;
  float _693;
  float _702;
  float _711;
  float _782;
  float _783;
  float _784;
  [branch]
  if (CameraKerare_000w == 0.0f) {
    float _38 = Kerare.x / Kerare.w;
    float _39 = Kerare.y / Kerare.w;
    float _40 = Kerare.z / Kerare.w;
    float _44 = abs((rsqrt(dot(float3(_38, _39, _40), float3(_38, _39, _40)))) * _40);
    float _49 = _44 * _44;
    _77 = ((_49 * _49) * (1.0f - (saturate((CameraKerare_000x * _44) + CameraKerare_000y))));
  } else {
    float _60 = ((SceneInfo_023w * SV_Position.y) + -0.5f) * 2.0f;
    float _62 = (CameraKerare_000w * 2.0f) * ((SceneInfo_023z * SV_Position.x) + -0.5f);
    float _64 = sqrt(dot(float2(_62, _60), float2(_62, _60)));
    float _72 = (_64 * _64) + 1.0f;
    _77 = ((1.0f / (_72 * _72)) * (1.0f - (saturate((CameraKerare_000x * (1.0f / (_64 + 1.0f))) + CameraKerare_000y))));
  }
  float _80 = (saturate(_77 + CameraKerare_000z));
  CustomVignette(_80);
  _80 *= Exposure;

  float _84 = SceneInfo_023z * SV_Position.x;
  float _85 = SceneInfo_023w * SV_Position.y;
  float4 _88 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_84, _85));
  if (!((uint)(Tonemap_001y) == 0)) {
    _103 = (asfloat((((int4)(asint(WhitePtSrv[0 / 4]))).x)));
  } else {
    _103 = 1.0f;
  }
  float _104 = _103 * Tonemap_000x;
  float _115 = log2((dot(float3(((_104 * _88.x) * RangeCompressInfo_000y), ((_104 * _88.y) * RangeCompressInfo_000y), ((_104 * _88.z) * RangeCompressInfo_000y)), float3(0.25f, 0.5f, 0.25f))) + 9.999999747378752e-06f);
  float2 _124 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_84, _85, ((((Tonemap_004z * _115) + Tonemap_004w) * 0.984375f) + 0.0078125f)), 0.0f);
  float _132 = (((bool)(_124.y < 0.0010000000474974513f)) ? ((BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_84, _85), 0.0f)).x) : (_124.x / _124.y));
  float _138 = (Tonemap_005x + _132) + ((((BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_84, _85), 0.0f)).x) - _132) * 0.6000000238418579f);
  float _139 = Tonemap_005x + _115;
  float _142 = _138 - Tonemap_004y;
  float _154 = exp2(((((((bool)(_142 > 0.0f)) ? Tonemap_003z : Tonemap_003w) * _142) - _139) + Tonemap_004y) + (Tonemap_004x * (_139 - _138)));
  _154 = PickExposure(_154);

  float _156 = (_88.x * _80) * _154;
  float _158 = (_88.y * _80) * _154;
  float _160 = (_88.z * _80) * _154;
  float _175 = mad(_160, CBControl_003x, (mad(_158, CBControl_002x, (_156 * CBControl_001x))));
  float _178 = mad(_160, CBControl_003y, (mad(_158, CBControl_002y, (_156 * CBControl_001y))));
  float _181 = mad(_160, CBControl_003z, (mad(_158, CBControl_002z, (_156 * CBControl_001z))));
  if (!(((uint)(CBControl_006w)) == 0)) {
    float _187 = max((max(_175, _178)), _181);
    if (!(_187 == 0.0f)) {
      float _193 = abs(_187);
      float _194 = (_187 - _175) / _193;
      float _195 = (_187 - _178) / _193;
      float _196 = (_187 - _181) / _193;
      do {
        if (!(!(_194 >= CBControl_005w))) {
          float _206 = _194 - CBControl_005w;
          _218 = ((_206 / (exp2((log2((exp2((log2(_206 * CBControl_007x)) * (CBControl_006z))) + 1.0f)) * CBControl_007w))) + CBControl_005w);
        } else {
          _218 = _194;
        }
        do {
          if (!(!(_195 >= (CBControl_006x)))) {
            float _227 = _195 - (CBControl_006x);
            _239 = ((_227 / (exp2((log2((exp2((log2(_227 * CBControl_007y)) * (CBControl_006z))) + 1.0f)) * CBControl_007w))) + (CBControl_006x));
          } else {
            _239 = _195;
          }
          do {
            if (!(!(_196 >= (CBControl_006y)))) {
              float _247 = _196 - (CBControl_006y);
              _259 = ((_247 / (exp2((log2((exp2((log2(_247 * CBControl_007z)) * (CBControl_006z))) + 1.0f)) * CBControl_007w))) + (CBControl_006y));
            } else {
              _259 = _196;
            }
            _267 = (_187 - (_193 * _218));
            _268 = (_187 - (_193 * _239));
            _269 = (_187 - (_193 * _259));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _267 = _175;
      _268 = _178;
      _269 = _181;
    }
  } else {
    _267 = _175;
    _268 = _178;
    _269 = _181;
  }
  bool _292 = !(_267 <= 0.0078125f);
  if (!_292) {
    _301 = ((_267 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _301 = (((log2(_267)) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _302 = !(_268 <= 0.0078125f);
  if (!_302) {
    _311 = ((_268 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _311 = (((log2(_268)) + 9.720000267028809f) * 0.05707762390375137f);
  }
  bool _312 = !(_269 <= 0.0078125f);
  if (!_312) {
    _321 = ((_269 * 10.540237426757812f) + 0.072905533015728f);
  } else {
    _321 = (((log2(_269)) + 9.720000267028809f) * 0.05707762390375137f);
  }
  float4 _330 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_301 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_311 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_321 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x)), 0.0f);
  if (_330.x < 0.155251145362854f) {
    _347 = ((_330.x + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if (((bool)(_330.x >= 0.155251145362854f)) && ((bool)(_330.x < 1.4679962396621704f))) {
      _347 = (exp2((_330.x * 17.520000457763672f) + -9.720000267028809f));
    } else {
      _347 = 65504.0f;
    }
  }
  if (_330.y < 0.155251145362854f) {
    _361 = ((_330.y + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if (((bool)(_330.y >= 0.155251145362854f)) && ((bool)(_330.y < 1.4679962396621704f))) {
      _361 = (exp2((_330.y * 17.520000457763672f) + -9.720000267028809f));
    } else {
      _361 = 65504.0f;
    }
  }
  if (_330.z < 0.155251145362854f) {
    _375 = ((_330.z + -0.072905533015728f) * 0.09487452358007431f);
  } else {
    if (((bool)(_330.z >= 0.155251145362854f)) && ((bool)(_330.z < 1.4679962396621704f))) {
      _375 = (exp2((_330.z * 17.520000457763672f) + -9.720000267028809f));
    } else {
      _375 = 65504.0f;
    }
  }
  [branch]
  if (LDRPostProcessParam_010y > 0.0f) {
    do {
      if (!_292) {
        _386 = ((_267 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _386 = (((log2(_267)) + 9.720000267028809f) * 0.05707762390375137f);
      }
      do {
        if (!_302) {
          _395 = ((_268 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _395 = (((log2(_268)) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!_312) {
            _404 = ((_269 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _404 = (((log2(_269)) + 9.720000267028809f) * 0.05707762390375137f);
          }
          float4 _412 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_386 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_395 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_404 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x)), 0.0f);
          do {
            if (_412.x < 0.155251145362854f) {
              _429 = ((_412.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if (((bool)(_412.x >= 0.155251145362854f)) && ((bool)(_412.x < 1.4679962396621704f))) {
                _429 = (exp2((_412.x * 17.520000457763672f) + -9.720000267028809f));
              } else {
                _429 = 65504.0f;
              }
            }
            do {
              if (_412.y < 0.155251145362854f) {
                _443 = ((_412.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if (((bool)(_412.y >= 0.155251145362854f)) && ((bool)(_412.y < 1.4679962396621704f))) {
                  _443 = (exp2((_412.y * 17.520000457763672f) + -9.720000267028809f));
                } else {
                  _443 = 65504.0f;
                }
              }
              do {
                if (_412.z < 0.155251145362854f) {
                  _457 = ((_412.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if (((bool)(_412.z >= 0.155251145362854f)) && ((bool)(_412.z < 1.4679962396621704f))) {
                    _457 = (exp2((_412.z * 17.520000457763672f) + -9.720000267028809f));
                  } else {
                    _457 = 65504.0f;
                  }
                }
                float _464 = ((_429 - _347) * LDRPostProcessParam_010y) + _347;
                float _465 = ((_443 - _361) * LDRPostProcessParam_010y) + _361;
                float _466 = ((_457 - _375) * LDRPostProcessParam_010y) + _375;
                if (LDRPostProcessParam_010z > 0.0f) {
                  do {
                    if (!(!(_464 <= 0.0078125f))) {
                      _478 = ((_464 * 10.540237426757812f) + 0.072905533015728f);
                    } else {
                      _478 = (((log2(_464)) + 9.720000267028809f) * 0.05707762390375137f);
                    }
                    do {
                      if (!(!(_465 <= 0.0078125f))) {
                        _488 = ((_465 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _488 = (((log2(_465)) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(!(_466 <= 0.0078125f))) {
                          _498 = ((_466 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _498 = (((log2(_466)) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        float4 _506 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_478 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_488 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_498 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x)), 0.0f);
                        do {
                          if ((_506.x) < 0.155251145362854f) {
                            _523 = (((_506.x) + -0.072905533015728f) * 0.09487452358007431f);
                          } else {
                            if (((bool)((_506.x) >= 0.155251145362854f)) && ((bool)((_506.x) < 1.4679962396621704f))) {
                              _523 = (exp2(((_506.x) * 17.520000457763672f) + -9.720000267028809f));
                            } else {
                              _523 = 65504.0f;
                            }
                          }
                          do {
                            if ((_506.y) < 0.155251145362854f) {
                              _537 = (((_506.y) + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if (((bool)((_506.y) >= 0.155251145362854f)) && ((bool)((_506.y) < 1.4679962396621704f))) {
                                _537 = (exp2(((_506.y) * 17.520000457763672f) + -9.720000267028809f));
                              } else {
                                _537 = 65504.0f;
                              }
                            }
                            do {
                              if ((_506.z) < 0.155251145362854f) {
                                _551 = (((_506.z) + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if (((bool)((_506.z) >= 0.155251145362854f)) && ((bool)((_506.z) < 1.4679962396621704f))) {
                                  _551 = (exp2(((_506.z) * 17.520000457763672f) + -9.720000267028809f));
                                } else {
                                  _551 = 65504.0f;
                                }
                              }
                              _657 = (((_523 - _464) * LDRPostProcessParam_010z) + _464);
                              _658 = (((_537 - _465) * LDRPostProcessParam_010z) + _465);
                              _659 = (((_551 - _466) * LDRPostProcessParam_010z) + _466);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _657 = _464;
                  _658 = _465;
                  _659 = _466;
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
        if (!(!(_347 <= 0.0078125f))) {
          _573 = ((_347 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _573 = (((log2(_347)) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(!(_361 <= 0.0078125f))) {
            _583 = ((_361 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _583 = (((log2(_361)) + 9.720000267028809f) * 0.05707762390375137f);
          }
          do {
            if (!(!(_375 <= 0.0078125f))) {
              _593 = ((_375 * 10.540237426757812f) + 0.072905533015728f);
            } else {
              _593 = (((log2(_375)) + 9.720000267028809f) * 0.05707762390375137f);
            }
            float4 _601 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_573 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_583 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x), ((_593 * LDRPostProcessParam_011y) + LDRPostProcessParam_011x)), 0.0f);
            do {
              if ((_601.x) < 0.155251145362854f) {
                _618 = (((_601.x) + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if (((bool)((_601.x) >= 0.155251145362854f)) && ((bool)((_601.x) < 1.4679962396621704f))) {
                  _618 = (exp2(((_601.x) * 17.520000457763672f) + -9.720000267028809f));
                } else {
                  _618 = 65504.0f;
                }
              }
              do {
                if ((_601.y) < 0.155251145362854f) {
                  _632 = (((_601.y) + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if (((bool)((_601.y) >= 0.155251145362854f)) && ((bool)((_601.y) < 1.4679962396621704f))) {
                    _632 = (exp2(((_601.y) * 17.520000457763672f) + -9.720000267028809f));
                  } else {
                    _632 = 65504.0f;
                  }
                }
                do {
                  if ((_601.z) < 0.155251145362854f) {
                    _646 = (((_601.z) + -0.072905533015728f) * 0.09487452358007431f);
                  } else {
                    if (((bool)((_601.z) >= 0.155251145362854f)) && ((bool)((_601.z) < 1.4679962396621704f))) {
                      _646 = (exp2(((_601.z) * 17.520000457763672f) + -9.720000267028809f));
                    } else {
                      _646 = 65504.0f;
                    }
                  }
                  _657 = (((_618 - _347) * LDRPostProcessParam_010z) + _347);
                  _658 = (((_632 - _361) * LDRPostProcessParam_010z) + _361);
                  _659 = (((_646 - _375) * LDRPostProcessParam_010z) + _375);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } else {
      _657 = _347;
      _658 = _361;
      _659 = _375;
    }
  }
  float _663 = (mad(_659, LDRPostProcessParam_014x, (mad(_658, LDRPostProcessParam_013x, (_657 * LDRPostProcessParam_012x))))) + LDRPostProcessParam_015x;
  float _667 = (mad(_659, LDRPostProcessParam_014y, (mad(_658, LDRPostProcessParam_013y, (_657 * LDRPostProcessParam_012y))))) + LDRPostProcessParam_015y;
  float _671 = (mad(_659, LDRPostProcessParam_014z, (mad(_658, LDRPostProcessParam_013z, (_657 * LDRPostProcessParam_012z))))) + LDRPostProcessParam_015z;
  float3 new_color = CustomLUTColor(float3(_267, _268, _269), float3(_663, _667, _671));
  _663 = new_color.r;
  _667 = new_color.g;
  _671 = new_color.b;

  bool _674 = isfinite(max((max(_663, _667)), _671));
  float _675 = (_674 ? _663 : 1.0f);
  float _676 = (_674 ? _667 : 1.0f);
  float _677 = (_674 ? _671 : 1.0f);
  if (TonemapParam_002w == 0.0f && ProcessSDRVanilla()) {
    float _685 = TonemapParam_002y * _675;
    do {
      if (!(_675 >= TonemapParam_000y)) {
        _693 = ((_685 * _685) * (3.0f - (_685 * 2.0f)));
      } else {
        _693 = 1.0f;
      }
      float _694 = TonemapParam_002y * _676;
      do {
        if (!(_676 >= TonemapParam_000y)) {
          _702 = ((_694 * _694) * (3.0f - (_694 * 2.0f)));
        } else {
          _702 = 1.0f;
        }
        float _703 = TonemapParam_002y * _677;
        do {
          if (!(_677 >= TonemapParam_000y)) {
            _711 = ((_703 * _703) * (3.0f - (_703 * 2.0f)));
          } else {
            _711 = 1.0f;
          }
          float _720 = (((bool)(_675 < TonemapParam_001y)) ? 0.0f : 1.0f);
          float _721 = (((bool)(_676 < TonemapParam_001y)) ? 0.0f : 1.0f);
          float _722 = (((bool)(_677 < TonemapParam_001y)) ? 0.0f : 1.0f);
          _782 = (((((TonemapParam_000x * _675) + TonemapParam_002z) * (_693 - _720)) + (((exp2((log2(_685)) * TonemapParam_000w)) * (1.0f - _693)) * TonemapParam_000y)) + ((TonemapParam_001x - ((exp2((TonemapParam_001w * _675) + TonemapParam_002x)) * TonemapParam_001z)) * _720));
          _783 = (((((TonemapParam_000x * _676) + TonemapParam_002z) * (_702 - _721)) + (((exp2((log2(_694)) * TonemapParam_000w)) * (1.0f - _702)) * TonemapParam_000y)) + ((TonemapParam_001x - ((exp2((TonemapParam_001w * _676) + TonemapParam_002x)) * TonemapParam_001z)) * _721));
          _784 = (((((TonemapParam_000x * _677) + TonemapParam_002z) * (_711 - _722)) + (((exp2((log2(_703)) * TonemapParam_000w)) * (1.0f - _711)) * TonemapParam_000y)) + ((TonemapParam_001x - ((exp2((TonemapParam_001w * _677) + TonemapParam_002x)) * TonemapParam_001z)) * _722));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _782 = _675;
    _783 = _676;
    _784 = _677;
  }
  SV_Target.x = _782;
  SV_Target.y = _783;
  SV_Target.z = _784;
  SV_Target.w = 0.0f;
  return SV_Target;
}
