#include "../shared.h"

Texture2D<float4> HDRImage : register(t0);

cbuffer SceneInfo : register(b0) {
  row_major float4x4 viewProjMat : packoffset(c000.x);
  row_major float3x4 transposeViewMat : packoffset(c004.x);
  row_major float3x4 transposeViewInvMat : packoffset(c007.x);
  float4 projElement[2] : packoffset(c010.x);
  float4 projInvElements[2] : packoffset(c012.x);
  row_major float4x4 viewProjInvMat : packoffset(c014.x);
  row_major float4x4 prevViewProjMat : packoffset(c018.x);
  float3 ZToLinear : packoffset(c022.x);
  float subdivisionLevel : packoffset(c022.w);
  float2 screenSize : packoffset(c023.x);
  float2 screenInverseSize : packoffset(c023.z);
  float2 cullingHelper : packoffset(c024.x);
  float cameraNearPlane : packoffset(c024.z);
  float cameraFarPlane : packoffset(c024.w);
  float4 viewFrustum[6] : packoffset(c025.x);
  float4 clipplane : packoffset(c031.x);
  float2 vrsVelocityThreshold : packoffset(c032.x);
  uint GPUVisibleMask : packoffset(c032.z);
  uint resolutionRatioPacked : packoffset(c032.w);
};

SamplerState BilinearClamp : register(s5, space32);

#define WHITE_SCALE     (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS)
#define INV_WHITE_SCALE (1.f / WHITE_SCALE)

float4 FxaaSampleScaled(float2 uv) {
  float4 sample = HDRImage.SampleLevel(BilinearClamp, uv, 0.0f);
  sample.rgb *= INV_WHITE_SCALE;
  return sample;
}

float4 FxaaSampleScaled(float2 uv, int2 offset) {
  float4 sample = HDRImage.SampleLevel(BilinearClamp, uv, 0.0f, offset);
  sample.rgb *= INV_WHITE_SCALE;
  return sample;
}

float4 FxaaGatherGreenScaled(float2 uv) {
  return HDRImage.GatherGreen(BilinearClamp, uv) * INV_WHITE_SCALE;
}

float4 main(
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;
  float _10 = screenInverseSize.x * SV_Position.x;
  float _11 = screenInverseSize.y * SV_Position.y;
  float4 _14_raw = HDRImage.SampleLevel(BilinearClamp, float2(_10, _11), 0.0f);
  float4 _14 = _14_raw;
  _14.rgb *= INV_WHITE_SCALE;
  float4 _19 = FxaaGatherGreenScaled(float2(_10, _11));
  float4 _23 = FxaaGatherGreenScaled(float2(_10, _11));
  float _33 = max(max(_23.z, _23.x), max(_19.z, max(_19.x, _14.y)));
  float _36 = _33 - min(min(_23.z, _23.x), min(_19.z, min(_19.x, _14.y)));
  float _132;
  float _133;
  float _141;
  float _142;
  float _148;
  float _153;
  float _168;
  float _169;
  float _177;
  float _178;
  float _184;
  float _189;
  float _204;
  float _205;
  float _213;
  float _214;
  float _220;
  float _225;
  float _240;
  float _241;
  float _248;
  float _249;
  float _250;
  float _251;
  float _252;
  float _253;
  float _284;
  float _285;
  float _286;
  float _287;
  if (!(_36 < max(0.08330000191926956f, (_33 * 0.3330000042915344f)))) {
    float4 _40 = FxaaSampleScaled(float2(_10, _11), int2(1, -1));
    float4 _42 = FxaaSampleScaled(float2(_10, _11), int2(-1, 1));
    float _44 = _23.z + _19.x;
    float _45 = _23.x + _19.z;
    float _48 = _14.y * 2.0f;
    float _51 = _40.y + _19.y;
    float _57 = _42.y + _23.w;
    bool _75 = ((((abs(_44 - _48) * 2.0f) + abs(_51 - (_19.z * 2.0f))) + abs(_57 - (_23.x * 2.0f))) >= (((abs(_45 - _48) * 2.0f) + abs((_23.w + _40.y) - (_23.z * 2.0f))) + abs((_19.y + _42.y) - (_19.x * 2.0f))));
    float _79 = select(_75, _19.x, _19.z);
    float _80 = select(_75, _23.z, _23.x);
    float _81 = select(_75, screenInverseSize.y, screenInverseSize.x);
    float _86 = abs(_80 - _14.y);
    float _87 = abs(_79 - _14.y);
    bool _88 = (_86 >= _87);
    float _91 = select(_88, (-0.0f - _81), _81);
    float _94 = saturate(abs((((_51 + ((_44 + _45) * 2.0f)) + _57) * 0.0833333358168602f) - _14.y) * (1.0f / _36));
    float _95 = select(_75, screenInverseSize.x, 0.0f);
    float _96 = select(_75, 0.0f, screenInverseSize.y);
    float _97 = _91 * 0.5f;
    float _100 = select(_75, _10, (_97 + _10));
    float _101 = select(_75, (_97 + _11), _11);
    float _102 = _100 - _95;
    float _103 = _101 - _96;
    float _104 = _100 + _95;
    float _105 = _101 + _96;
    float4 _108 = FxaaSampleScaled(float2(_102, _103));
    float4 _111 = FxaaSampleScaled(float2(_104, _105));
    float _115 = max(_86, _87) * 0.25f;
    float _116 = (_14.y + select(_88, _80, _79)) * 0.5f;
    float _118 = (_94 * _94) * (3.0f - (_94 * 2.0f));
    float _120 = _108.y - _116;
    float _121 = _111.y - _116;
    bool _123 = (abs(_120) >= _115);
    bool _125 = (abs(_121) >= _115);
    do {
      if (!_123) {
        _132 = (_102 - (_95 * 1.5f));
        _133 = (_103 - (_96 * 1.5f));
      } else {
        _132 = _102;
        _133 = _103;
      }
      do {
        if (!_125) {
          _141 = (_104 + (_95 * 1.5f));
          _142 = (_105 + (_96 * 1.5f));
        } else {
          _141 = _104;
          _142 = _105;
        }
        do {
          if (!(_123 && _125)) {
            do {
              if (!_123) {
                float4 _145 = FxaaSampleScaled(float2(_132, _133));
                _148 = _145.y;
              } else {
                _148 = _120;
              }
              do {
                if (!_125) {
                  float4 _150 = FxaaSampleScaled(float2(_141, _142));
                  _153 = _150.y;
                } else {
                  _153 = _121;
                }
                float _155 = select(_123, _148, (_148 - _116));
                float _157 = select(_125, _153, (_153 - _116));
                bool _159 = (abs(_155) >= _115);
                bool _161 = (abs(_157) >= _115);
                do {
                  if (!_159) {
                    _168 = (_132 - (_95 * 2.0f));
                    _169 = (_133 - (_96 * 2.0f));
                  } else {
                    _168 = _132;
                    _169 = _133;
                  }
                  do {
                    if (!_161) {
                      _177 = (_141 + (_95 * 2.0f));
                      _178 = (_142 + (_96 * 2.0f));
                    } else {
                      _177 = _141;
                      _178 = _142;
                    }
                    if (!(_159 && _161)) {
                      do {
                        if (!_159) {
                          float4 _181 = FxaaSampleScaled(float2(_168, _169));
                          _184 = _181.y;
                        } else {
                          _184 = _155;
                        }
                        do {
                          if (!_161) {
                            float4 _186 = FxaaSampleScaled(float2(_177, _178));
                            _189 = _186.y;
                          } else {
                            _189 = _157;
                          }
                          float _191 = select(_159, _184, (_184 - _116));
                          float _193 = select(_161, _189, (_189 - _116));
                          bool _195 = (abs(_191) >= _115);
                          bool _197 = (abs(_193) >= _115);
                          do {
                            if (!_195) {
                              _204 = (_168 - (_95 * 4.0f));
                              _205 = (_169 - (_96 * 4.0f));
                            } else {
                              _204 = _168;
                              _205 = _169;
                            }
                            do {
                              if (!_197) {
                                _213 = (_177 + (_95 * 4.0f));
                                _214 = (_178 + (_96 * 4.0f));
                              } else {
                                _213 = _177;
                                _214 = _178;
                              }
                              if (!(_195 && _197)) {
                                do {
                                  if (!_195) {
                                    float4 _217 = FxaaSampleScaled(float2(_204, _205));
                                    _220 = _217.y;
                                  } else {
                                    _220 = _191;
                                  }
                                  do {
                                    if (!_197) {
                                      float4 _222 = FxaaSampleScaled(float2(_213, _214));
                                      _225 = _222.y;
                                    } else {
                                      _225 = _193;
                                    }
                                    float _227 = select(_195, _220, (_220 - _116));
                                    float _229 = select(_197, _225, (_225 - _116));
                                    do {
                                      if (!(abs(_227) >= _115)) {
                                        _240 = (_204 - (_95 * 12.0f));
                                        _241 = (_205 - (_96 * 12.0f));
                                      } else {
                                        _240 = _204;
                                        _241 = _205;
                                      }
                                      if (!(abs(_229) >= _115)) {
                                        _248 = _240;
                                        _249 = _241;
                                        _250 = (_213 + (_95 * 12.0f));
                                        _251 = (_214 + (_96 * 12.0f));
                                        _252 = _227;
                                        _253 = _229;
                                      } else {
                                        _248 = _240;
                                        _249 = _241;
                                        _250 = _213;
                                        _251 = _214;
                                        _252 = _227;
                                        _253 = _229;
                                      }
                                    } while (false);
                                  } while (false);
                                } while (false);
                              } else {
                                _248 = _204;
                                _249 = _205;
                                _250 = _213;
                                _251 = _214;
                                _252 = _191;
                                _253 = _193;
                              }
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      _248 = _168;
                      _249 = _169;
                      _250 = _177;
                      _251 = _178;
                      _252 = _155;
                      _253 = _157;
                    }
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } else {
            _248 = _132;
            _249 = _133;
            _250 = _141;
            _251 = _142;
            _252 = _120;
            _253 = _121;
          }
          float _258 = select(_75, (_10 - _248), (_11 - _249));
          float _259 = select(_75, (_250 - _10), (_251 - _11));
          float _274 = max(select((((_14.y - _116) < 0.0f) ^ select((_258 < _259), (_252 < 0.0f), (_253 < 0.0f))), (0.5f - (min(_258, _259) * (1.0f / (_259 + _258)))), 0.0f), ((_118 * _118) * 0.75f)) * _91;
          float4 _279 = FxaaSampleScaled(float2(select(_75, _10, (_274 + _10)), select(_75, (_274 + _11), _11)));
          _284 = _279.x;
          _285 = _279.y;
          _286 = _279.z;
          _287 = _14_raw.y;
        } while (false);
      } while (false);
    } while (false);
  } else {
    _284 = _14.x;
    _285 = _14.y;
    _286 = _14.z;
    _287 = _14_raw.w;
  }
  SV_Target.x = _284;
  SV_Target.y = _285;
  SV_Target.z = _286;
  SV_Target.w = _287;
  SV_Target.rgb *= WHITE_SCALE;
  return SV_Target;
}
