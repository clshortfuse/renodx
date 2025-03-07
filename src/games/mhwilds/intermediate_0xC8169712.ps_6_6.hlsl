#include "./shared.h"

Texture2D<float4> HDRImage : register(t0);

cbuffer SceneInfo : register(b0) {
  float SceneInfo_023z : packoffset(c023.z);
  float SceneInfo_023w : packoffset(c023.w);
};

SamplerState BilinearClamp : register(s5, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _10 = (SceneInfo_023z) * (SV_Position.x);
  float _11 = (SceneInfo_023w) * (SV_Position.y);
  float4 _14 = HDRImage.SampleLevel(BilinearClamp, float2(_10, _11), 0.0f);
  float4 _19 = HDRImage.GatherGreen(BilinearClamp, float2(_10, _11));
  float4 _23 = HDRImage.GatherGreen(BilinearClamp, float2(_10, _11));
  float _33 = max((max((_23.z), (_23.x))), (max((_19.z), (max((_19.x), (_14.y))))));
  float _36 = _33 - (min((min((_23.z), (_23.x))), (min((_19.z), (min((_19.x), (_14.y)))))));
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
  float _290 = (_14.x);
  float _291 = (_14.y);
  float _292 = (_14.z);
  float _293 = (_14.w);
  if (!((_36 < (max(0.08330000191926956f, (_33 * 0.3330000042915344f)))))) {
    float _44 = (_23.z) + (_19.x);
    float _45 = (_23.x) + (_19.z);
    float _48 = (_14.y) * 2.0f;
    float _51 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_10, _11), 0.0f, 1))).y) + (_19.y);
    float _57 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_10, _11), 0.0f, -1))).y) + (_23.w);
    bool _75 = (((((abs((_44 - _48))) * 2.0f) + (abs((_51 - ((_19.z) * 2.0f))))) + (abs((_57 - ((_23.x) * 2.0f))))) >= ((((abs((_45 - _48))) * 2.0f) + (abs((((_23.w) + (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_10, _11), 0.0f, 1))).y)) - ((_23.z) * 2.0f))))) + (abs((((_19.y) + (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_10, _11), 0.0f, -1))).y)) - ((_19.x) * 2.0f))))));
    float _79 = (_75 ? (_19.x) : (_19.z));
    float _80 = (_75 ? (_23.z) : (_23.x));
    float _81 = (_75 ? (SceneInfo_023w) : (SceneInfo_023z));
    float _86 = abs((_80 - (_14.y)));
    float _87 = abs((_79 - (_14.y)));
    bool _88 = (_86 >= _87);
    float _91 = (_88 ? (-0.0f - _81) : _81);
    float _94 = saturate(((abs(((((_51 + ((_44 + _45) * 2.0f)) + _57) * 0.0833333358168602f) - (_14.y)))) * (1.0f / _36)));
    float _95 = (_75 ? (SceneInfo_023z) : 0.0f);
    float _96 = (_75 ? 0.0f : (SceneInfo_023w));
    float _97 = _91 * 0.5f;
    float _100 = (_75 ? _10 : (_97 + _10));
    float _101 = (_75 ? (_97 + _11) : _11);
    float _102 = _100 - _95;
    float _103 = _101 - _96;
    float _104 = _100 + _95;
    float _105 = _101 + _96;
    float _115 = (max(_86, _87)) * 0.25f;
    float _116 = ((_14.y) + ((_88 ? _80 : _79))) * 0.5f;
    float _118 = (_94 * _94) * (3.0f - (_94 * 2.0f));
    float _120 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_102, _103), 0.0f))).y) - _116;
    float _121 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_104, _105), 0.0f))).y) - _116;
    bool _123 = ((abs(_120)) >= _115);
    bool _125 = ((abs(_121)) >= _115);
    do {
      if (!_123) {
        _134 = (_102 - (_95 * 1.5f));
        _135 = (_103 - (_96 * 1.5f));
        _136 = true;
      } else {
        _134 = _102;
        _135 = _103;
        _136 = (!_125);
      }
      _143 = _104;
      _144 = _105;
      do {
        if (!_125) {
          _143 = (_104 + (_95 * 1.5f));
          _144 = (_105 + (_96 * 1.5f));
        }
        _254 = _134;
        _255 = _135;
        _256 = _143;
        _257 = _144;
        _258 = _120;
        _259 = _121;
        do {
          if (_136) {
            _150 = _120;
            do {
              if (!_123) {
                _150 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_134, _135), 0.0f))).y);
              }
              _155 = _121;
              do {
                if (!_125) {
                  _155 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_143, _144), 0.0f))).y);
                }
                float _157 = (_123 ? _150 : (_150 - _116));
                float _159 = (_125 ? _155 : (_155 - _116));
                bool _161 = ((abs(_157)) >= _115);
                bool _163 = ((abs(_159)) >= _115);
                do {
                  if (!_161) {
                    _172 = (_134 - (_95 * 2.0f));
                    _173 = (_135 - (_96 * 2.0f));
                    _174 = true;
                  } else {
                    _172 = _134;
                    _173 = _135;
                    _174 = (!_163);
                  }
                  _181 = _143;
                  _182 = _144;
                  do {
                    if (!_163) {
                      _181 = (_143 + (_95 * 2.0f));
                      _182 = (_144 + (_96 * 2.0f));
                    }
                    _254 = _172;
                    _255 = _173;
                    _256 = _181;
                    _257 = _182;
                    _258 = _157;
                    _259 = _159;
                    if (_174) {
                      _188 = _157;
                      do {
                        if (!_161) {
                          _188 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_172, _173), 0.0f))).y);
                        }
                        _193 = _159;
                        do {
                          if (!_163) {
                            _193 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_181, _182), 0.0f))).y);
                          }
                          float _195 = (_161 ? _188 : (_188 - _116));
                          float _197 = (_163 ? _193 : (_193 - _116));
                          bool _199 = ((abs(_195)) >= _115);
                          bool _201 = ((abs(_197)) >= _115);
                          do {
                            if (!_199) {
                              _210 = (_172 - (_95 * 4.0f));
                              _211 = (_173 - (_96 * 4.0f));
                              _212 = true;
                            } else {
                              _210 = _172;
                              _211 = _173;
                              _212 = (!_201);
                            }
                            _219 = _181;
                            _220 = _182;
                            do {
                              if (!_201) {
                                _219 = (_181 + (_95 * 4.0f));
                                _220 = (_182 + (_96 * 4.0f));
                              }
                              _254 = _210;
                              _255 = _211;
                              _256 = _219;
                              _257 = _220;
                              _258 = _195;
                              _259 = _197;
                              if (_212) {
                                _226 = _195;
                                do {
                                  if (!_199) {
                                    _226 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_210, _211), 0.0f))).y);
                                  }
                                  _231 = _197;
                                  do {
                                    if (!_201) {
                                      _231 = (((float4)(HDRImage.SampleLevel(BilinearClamp, float2(_219, _220), 0.0f))).y);
                                    }
                                    float _233 = (_199 ? _226 : (_226 - _116));
                                    float _235 = (_201 ? _231 : (_231 - _116));
                                    _246 = _210;
                                    _247 = _211;
                                    do {
                                      if ((!((abs(_233)) >= _115))) {
                                        _246 = (_210 - (_95 * 12.0f));
                                        _247 = (_211 - (_96 * 12.0f));
                                      }
                                      _254 = _246;
                                      _255 = _247;
                                      _256 = _219;
                                      _257 = _220;
                                      _258 = _233;
                                      _259 = _235;
                                      if ((!((abs(_235)) >= _115))) {
                                        _254 = _246;
                                        _255 = _247;
                                        _256 = (_219 + (_95 * 12.0f));
                                        _257 = (_220 + (_96 * 12.0f));
                                        _258 = _233;
                                        _259 = _235;
                                      }
                                    } while (false);
                                  } while (false);
                                } while (false);
                              }
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    }
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          }
          float _264 = (_75 ? (_10 - _254) : (_11 - _255));
          float _265 = (_75 ? (_256 - _10) : (_257 - _11));
          float _280 = (max(((((bool)(((((_14.y) - _116) < 0.0f)) ^ ((((_264 < _265)) ? ((_258 < 0.0f)) : ((_259 < 0.0f)))))) ? (0.5f - ((min(_264, _265)) * (1.0f / (_265 + _264)))) : 0.0f)), ((_118 * _118) * 0.75f))) * _91;
          float4 _285 = HDRImage.SampleLevel(BilinearClamp, float2(((_75 ? _10 : (_280 + _10))), ((_75 ? (_280 + _11) : _11))), 0.0f);
          _290 = (_285.x);
          _291 = (_285.y);
          _292 = (_285.z);
          _293 = (_14.y);
        } while (false);
      } while (false);
    } while (false);
  }
  SV_Target.x = _290;
  SV_Target.y = _291;
  SV_Target.z = _292;
  SV_Target.w = _293;

  SV_Target.xyz = lerp(_14.rgb, SV_Target.xyz, CUSTOM_SHARPNESS);
  return SV_Target;
}
