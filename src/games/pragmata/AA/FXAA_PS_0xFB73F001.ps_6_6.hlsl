#include "./AA.hlsli"

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
  float4 viewFrustum[8] : packoffset(c025.x);
  float4 clipplane : packoffset(c033.x);
  float2 vrsVelocityThreshold : packoffset(c034.x);
  uint GPUVisibleMask : packoffset(c034.z);
  uint resolutionRatioPacked : packoffset(c034.w);
  float3 worldOffset : packoffset(c035.x);
  uint sceneInfoMisc : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float4 sceneExtendedData : packoffset(c037.x);
  float2 projectionSpaceJitterOffset : packoffset(c038.x);
  uint blueNoiseJitterIndex : packoffset(c038.z);
  float tessellationParam : packoffset(c038.w);
  uint sceneInfoAdditionalFlags : packoffset(c039.x);
};

SamplerState BilinearClamp : register(s5, space32);

float4 main(
    precise noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float _10;
  float _11;
  float4 _14;
  float4 _19;
  float4 _23;
  float _33;
  float _36;
  float _134;
  float _135;
  bool _136;
  float _143;
  float _144;
  float _150;
  float _155;
  float _172;
  float _173;
  bool _174;
  float _181;
  float _182;
  float _188;
  float _193;
  float _210;
  float _211;
  bool _212;
  float _219;
  float _220;
  float _226;
  float _231;
  float _246;
  float _247;
  float _254;
  float _255;
  float _256;
  float _257;
  float _258;
  float _259;
  float _290;
  float _291;
  float _292;
  float _293;
  float4 _40;
  float4 _42;
  float _44;
  float _45;
  float _48;
  float _51;
  float _57;
  bool _75;
  float _79;
  float _80;
  float _81;
  float _86;
  float _87;
  bool _88;
  float _91;
  float _94;
  float _95;
  float _96;
  float _97;
  float _100;
  float _101;
  float _102;
  float _103;
  float _104;
  float _105;
  float _115;
  float _116;
  float _118;
  float _120;
  float _121;
  bool _123;
  bool _125;
  float _157;
  float _159;
  bool _161;
  bool _163;
  float _195;
  float _197;
  bool _199;
  bool _201;
  float _233;
  float _235;
  float _264;
  float _265;
  float _280;
  float4 _285;
  _10 = screenInverseSize.x * SV_Position.x;
  _11 = screenInverseSize.y * SV_Position.y;
  _14 = HDRImage.SampleLevel(BilinearClamp, float2(_10, _11), 0.0f);
  if (CUSTOM_FXAA == 0.0f) {
    return _14;
  }
  _19 = HDRImage.GatherGreen(BilinearClamp, float2(_10, _11));
  _23 = HDRImage.GatherGreen(BilinearClamp, float2(_10, _11));
  _33 = max(max(_23.z, _23.x), max(_19.z, max(_19.x, _14.y)));
  _36 = _33 - min(min(_23.z, _23.x), min(_19.z, min(_19.x, _14.y)));
  if (!(_36 < max(0.08330000191926956f, (_33 * 0.3330000042915344f)))) {
    _40 = HDRImage.SampleLevel(BilinearClamp, float2(_10, _11), 0.0f, int2(1, -1));
    _42 = HDRImage.SampleLevel(BilinearClamp, float2(_10, _11), 0.0f, int2(-1, 1));
    _44 = _23.z + _19.x;
    _45 = _23.x + _19.z;
    _48 = _14.y * 2.0f;
    _51 = _40.y + _19.y;
    _57 = _42.y + _23.w;
    _75 = ((((abs(_44 - _48) * 2.0f) + abs(_51 - (_19.z * 2.0f))) + abs(_57 - (_23.x * 2.0f))) >= (((abs(_45 - _48) * 2.0f) + abs((_23.w - (_23.z * 2.0f)) + _40.y)) + abs((_19.y - (_19.x * 2.0f)) + _42.y)));
    _79 = select(_75, _19.x, _19.z);
    _80 = select(_75, _23.z, _23.x);
    _81 = select(_75, screenInverseSize.y, screenInverseSize.x);
    _86 = abs(_80 - _14.y);
    _87 = abs(_79 - _14.y);
    _88 = (_86 >= _87);
    _91 = select(_88, (-0.0f - _81), _81);
    _94 = saturate(abs((((_51 + ((_44 + _45) * 2.0f)) + _57) * 0.0833333358168602f) - _14.y) * (1.0f / _36));
    _95 = select(_75, screenInverseSize.x, 0.0f);
    _96 = select(_75, 0.0f, screenInverseSize.y);
    _97 = _91 * 0.5f;
    _100 = select(_75, _10, (_97 + _10));
    _101 = select(_75, (_97 + _11), _11);
    _102 = _100 - _95;
    _103 = _101 - _96;
    _104 = _100 + _95;
    _105 = _101 + _96;
    _115 = max(_86, _87) * 0.25f;
    _116 = (_14.y + select(_88, _80, _79)) * 0.5f;
    _118 = (_94 * _94) * (3.0f - (_94 * 2.0f));
    _120 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_102, _103), 0.0f))).y) - _116;
    _121 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_104, _105), 0.0f))).y) - _116;
    _123 = (abs(_120) >= _115);
    _125 = (abs(_121) >= _115);
    do {
      if (!(_123)) {
        _134 = (_102 - (_95 * 1.5f));
        _135 = (_103 - (_96 * 1.5f));
        _136 = true;
      } else {
        _134 = _102;
        _135 = _103;
        _136 = (!_125);
      }
      do {
        _143 = _104;
        _144 = _105;
        if (!(_125)) {
          _143 = (_104 + (_95 * 1.5f));
          _144 = (_105 + (_96 * 1.5f));
        }
        do {
          _254 = _134;
          _255 = _135;
          _256 = _143;
          _257 = _144;
          _258 = _120;
          _259 = _121;
          if (_136) {
            do {
              _150 = _120;
              if (!(_123)) {
                _150 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_134, _135), 0.0f))).y);
              }
              do {
                _155 = _121;
                if (!(_125)) {
                  _155 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_143, _144), 0.0f))).y);
                }
                _157 = select(_123, _150, (_150 - _116));
                _159 = select(_125, _155, (_155 - _116));
                _161 = (abs(_157) >= _115);
                _163 = (abs(_159) >= _115);
                do {
                  if (!(_161)) {
                    _172 = (_134 - (_95 * 2.0f));
                    _173 = (_135 - (_96 * 2.0f));
                    _174 = true;
                  } else {
                    _172 = _134;
                    _173 = _135;
                    _174 = (!_163);
                  }
                  do {
                    _181 = _143;
                    _182 = _144;
                    if (!(_163)) {
                      _181 = (_143 + (_95 * 2.0f));
                      _182 = (_144 + (_96 * 2.0f));
                    }
                    if (_174) {
                      do {
                        _188 = _157;
                        if (!(_161)) {
                          _188 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_172, _173), 0.0f))).y);
                        }
                        do {
                          _193 = _159;
                          if (!(_163)) {
                            _193 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_181, _182), 0.0f))).y);
                          }
                          _195 = select(_161, _188, (_188 - _116));
                          _197 = select(_163, _193, (_193 - _116));
                          _199 = (abs(_195) >= _115);
                          _201 = (abs(_197) >= _115);
                          do {
                            if (!(_199)) {
                              _210 = (_172 - (_95 * 4.0f));
                              _211 = (_173 - (_96 * 4.0f));
                              _212 = true;
                            } else {
                              _210 = _172;
                              _211 = _173;
                              _212 = (!_201);
                            }
                            do {
                              _219 = _181;
                              _220 = _182;
                              if (!(_201)) {
                                _219 = (_181 + (_95 * 4.0f));
                                _220 = (_182 + (_96 * 4.0f));
                              }
                              if (_212) {
                                do {
                                  _226 = _195;
                                  if (!(_199)) {
                                    _226 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_210, _211), 0.0f))).y);
                                  }
                                  do {
                                    _231 = _197;
                                    if (!(_201)) {
                                      _231 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_219, _220), 0.0f))).y);
                                    }
                                    _233 = select(_199, _226, (_226 - _116));
                                    _235 = select(_201, _231, (_231 - _116));
                                    do {
                                      _246 = _210;
                                      _247 = _211;
                                      if (!(abs(_233) >= _115)) {
                                        _246 = (_210 - (_95 * 12.0f));
                                        _247 = (_211 - (_96 * 12.0f));
                                      }
                                      if (!(abs(_235) >= _115)) {
                                        _254 = _246;
                                        _255 = _247;
                                        _256 = (_219 + (_95 * 12.0f));
                                        _257 = (_220 + (_96 * 12.0f));
                                        _258 = _233;
                                        _259 = _235;
                                      } else {
                                        _254 = _246;
                                        _255 = _247;
                                        _256 = _219;
                                        _257 = _220;
                                        _258 = _233;
                                        _259 = _235;
                                      }
                                    } while (false);
                                  } while (false);
                                } while (false);
                              } else {
                                _254 = _210;
                                _255 = _211;
                                _256 = _219;
                                _257 = _220;
                                _258 = _195;
                                _259 = _197;
                              }
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      _254 = _172;
                      _255 = _173;
                      _256 = _181;
                      _257 = _182;
                      _258 = _157;
                      _259 = _159;
                    }
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          }
          _264 = select(_75, (_10 - _254), (_11 - _255));
          _265 = select(_75, (_256 - _10), (_257 - _11));
          _280 = max(select((((_14.y - _116) < 0.0f) ^ select((_264 < _265), (_258 < 0.0f), (_259 < 0.0f))), (0.5f - (min(_264, _265) * (1.0f / (_265 + _264)))), 0.0f), ((_118 * _118) * 0.75f)) * _91;
          _285 = HDRImage.SampleLevel(BilinearClamp, float2(select(_75, _10, (_280 + _10)), select(_75, (_280 + _11), _11)), 0.0f);
          _290 = _285.x;
          _291 = _285.y;
          _292 = _285.z;
          _293 = _14.y;
        } while (false);
      } while (false);
    } while (false);
  } else {
    _290 = _14.x;
    _291 = _14.y;
    _292 = _14.z;
    _293 = _14.w;
  }
  SV_Target.x = _290;
  SV_Target.y = _291;
  SV_Target.z = _292;
  SV_Target.w = _293;
  return SV_Target;
}
