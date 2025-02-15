#include "../common.hlsl"

cbuffer $Globals : register(b0) {
  uint $Globals_000x : packoffset(c000.x);
  uint $Globals_000y : packoffset(c000.y);
  float $Globals_001x : packoffset(c001.x);
  float $Globals_001y : packoffset(c001.y);
  float $Globals_001z : packoffset(c001.z);
  float $Globals_001w : packoffset(c001.w);
  float $Globals_002x : packoffset(c002.x);
  float $Globals_003x : packoffset(c003.x);
  float $Globals_003y : packoffset(c003.y);
  float $Globals_003z : packoffset(c003.z);
  float $Globals_003w : packoffset(c003.w);
  float $Globals_004x : packoffset(c004.x);
  float $Globals_004y : packoffset(c004.y);
  float $Globals_004z : packoffset(c004.z);
  float $Globals_004w : packoffset(c004.w);
  float $Globals_005x : packoffset(c005.x);
  float $Globals_005y : packoffset(c005.y);
};

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
  float4 SV_Target;
  float _6[6];
  float _7[6];
  float _10 = ((TEXCOORD.x) + -0.015625f) * 1.0322580337524414f;
  float _11 = ((TEXCOORD.y) + -0.015625f) * 1.0322580337524414f;
  float _13 = (float((uint)(SV_RenderTargetArrayIndex))) * 0.032258063554763794f;
  float _33 = 1.3792141675949097f;
  float _34 = -0.30886411666870117f;
  float _35 = -0.0703500509262085f;
  float _36 = -0.06933490186929703f;
  float _37 = 1.08229660987854f;
  float _38 = -0.012961871922016144f;
  float _39 = -0.0021590073592960835f;
  float _40 = -0.0454593189060688f;
  float _41 = 1.0476183891296387f;
  float _172;
  float _205;
  float _219;
  float _258;
  float _368;
  float _442;
  float _516;
  float _597;
  float _598;
  float _599;
  float _700;
  float _733;
  float _747;
  float _786;
  float _896;
  float _970;
  float _1044;
  float _1125;
  float _1126;
  float _1127;
  float _1168;
  float _1169;
  float _1170;
  if (!((((uint)($Globals_000y)) == 1))) {
    _33 = 1.0258246660232544f;
    _34 = -0.020053181797266006f;
    _35 = -0.005771636962890625f;
    _36 = -0.002234415616840124f;
    _37 = 1.0045864582061768f;
    _38 = -0.002352118492126465f;
    _39 = -0.005013350863009691f;
    _40 = -0.025290070101618767f;
    _41 = 1.0303035974502563f;
    if (!((((uint)($Globals_000y)) == 2))) {
      _33 = 0.6954522132873535f;
      _34 = 0.14067870378494263f;
      _35 = 0.16386906802654266f;
      _36 = 0.044794563204050064f;
      _37 = 0.8596711158752441f;
      _38 = 0.0955343171954155f;
      _39 = -0.005525882821530104f;
      _40 = 0.004025210160762072f;
      _41 = 1.0015007257461548f;
      if (!((((uint)($Globals_000y)) == 3))) {
        bool _22 = (((uint)($Globals_000y)) == 4);
        _33 = ((_22 ? 1.0f : 1.705051064491272f));
        _34 = ((_22 ? 0.0f : -0.6217921376228333f));
        _35 = ((_22 ? 0.0f : -0.0832589864730835f));
        _36 = ((_22 ? 0.0f : -0.13025647401809692f));
        _37 = ((_22 ? 1.0f : 1.140804648399353f));
        _38 = ((_22 ? 0.0f : -0.010548308491706848f));
        _39 = ((_22 ? 0.0f : -0.024003351107239723f));
        _40 = ((_22 ? 0.0f : -0.1289689838886261f));
        _41 = ((_22 ? 1.0f : 1.1529725790023804f));
      }
    }
  }
  float _48 = exp2(((log2(_10)) * 0.012683313339948654f));
  float _49 = exp2(((log2(_11)) * 0.012683313339948654f));
  float _50 = exp2(((log2(_13)) * 0.012683313339948654f));
  float _72 = exp2(((log2(((max(0.0f, (_48 + -0.8359375f))) / (18.8515625f - (_48 * 18.6875f))))) * 6.277394771575928f));
  float _75 = (exp2(((log2(((max(0.0f, (_49 + -0.8359375f))) / (18.8515625f - (_49 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f;
  float _76 = (exp2(((log2(((max(0.0f, (_50 + -0.8359375f))) / (18.8515625f - (_50 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f;
  _6[0] = ($Globals_003x);
  _6[1] = ($Globals_003y);
  _6[2] = ($Globals_003z);
  _6[3] = ($Globals_003w);
  _6[4] = ($Globals_005x);
  _6[5] = ($Globals_005x);
  _7[0] = ($Globals_004x);
  _7[1] = ($Globals_004y);
  _7[2] = ($Globals_004z);
  _7[3] = ($Globals_004w);
  _7[4] = ($Globals_005y);
  _7[5] = ($Globals_005y);
  if ((((bool)((((uint)($Globals_000x)) == 3))) || ((bool)((((uint)($Globals_000x)) == 5))))) {
    float _117 = mad(0.177378311753273f, _76, (mad(0.38298869132995605f, _75, (_72 * 4396.32958984375f))));
    float _120 = mad(0.09678413718938828f, _76, (mad(0.8134394288063049f, _75, (_72 * 897.7644653320312f))));
    float _123 = mad(0.8709122538566589f, _76, (mad(0.11154655367136002f, _75, (_72 * 175.4116973876953f))));
    float _127 = max((max(_117, _120)), _123);
    float _132 = ((max(_127, 1.000000013351432e-10f)) - (max((min((min(_117, _120)), _123)), 1.000000013351432e-10f))) / (max(_127, 0.009999999776482582f));
    float _145 = ((_120 + _117) + _123) + ((sqrt(((((_123 - _120) * _123) + ((_120 - _117) * _120)) + ((_117 - _123) * _117)))) * 1.75f);
    float _146 = _145 * 0.3333333432674408f;
    float _147 = _132 + -0.4000000059604645f;
    float _148 = _147 * 5.0f;
    float _152 = max((1.0f - (abs((_147 * 2.5f)))), 0.0f);
    float _163 = (((float(((int(((bool)((_148 > 0.0f))))) - (int(((bool)((_148 < 0.0f)))))))) * (1.0f - (_152 * _152))) + 1.0f) * 0.02500000037252903f;
    _172 = _163;
    do {
      if ((!(_146 <= 0.0533333346247673f))) {
        _172 = 0.0f;
        if ((!(_146 >= 0.1599999964237213f))) {
          _172 = (((0.23999999463558197f / _145) + -0.5f) * _163);
        }
      }
      float _173 = _172 + 1.0f;
      float _174 = _173 * _117;
      float _175 = _173 * _120;
      float _176 = _173 * _123;
      _205 = 0.0f;
      do {
        if (!(((bool)((_174 == _175))) && ((bool)((_175 == _176))))) {
          float _183 = ((_174 * 2.0f) - _175) - _176;
          float _186 = ((_120 - _123) * 1.7320507764816284f) * _173;
          float _188 = atan((_186 / _183));
          bool _191 = (_183 < 0.0f);
          bool _192 = (_183 == 0.0f);
          bool _193 = (_186 >= 0.0f);
          bool _194 = (_186 < 0.0f);
          _205 = ((((bool)(_193 && _192)) ? 90.0f : ((((bool)(_194 && _192)) ? -90.0f : (((((bool)(_194 && _191)) ? (_188 + -3.1415927410125732f) : ((((bool)(_193 && _191)) ? (_188 + 3.1415927410125732f) : _188)))) * 57.2957763671875f)))));
        }
        float _210 = min((max(((((bool)((_205 < 0.0f))) ? (_205 + 360.0f) : _205)), 0.0f)), 360.0f);
        do {
          if (((_210 < -180.0f))) {
            _219 = (_210 + 360.0f);
          } else {
            _219 = _210;
            if (((_210 > 180.0f))) {
              _219 = (_210 + -360.0f);
            }
          }
          _258 = 0.0f;
          do {
            if ((((bool)((_219 > -67.5f))) && ((bool)((_219 < 67.5f))))) {
              float _225 = (_219 + 67.5f) * 0.029629629105329514f;
              int _226 = int(226);
              float _228 = _225 - (float(_226));
              float _229 = _228 * _228;
              float _230 = _229 * _228;
              if (((_226 == 3))) {
                _258 = (((0.1666666716337204f - (_228 * 0.5f)) + (_229 * 0.5f)) - (_230 * 0.1666666716337204f));
              } else {
                if (((_226 == 2))) {
                  _258 = ((0.6666666865348816f - _229) + (_230 * 0.5f));
                } else {
                  if (((_226 == 1))) {
                    _258 = (((_230 * -0.5f) + 0.1666666716337204f) + ((_229 + _228) * 0.5f));
                  } else {
                    _258 = ((((bool)((_226 == 0))) ? (_230 * 0.1666666716337204f) : 0.0f));
                  }
                }
              }
            }
            float _267 = min((max(((((_132 * 0.27000001072883606f) * (0.029999999329447746f - _174)) * _258) + _174), 0.0f)), 65535.0f);
            float _268 = min((max(_175, 0.0f)), 65535.0f);
            float _269 = min((max(_176, 0.0f)), 65535.0f);
            float _282 = min((max((mad(-0.21492856740951538f, _269, (mad(-0.2365107536315918f, _268, (_267 * 1.4514392614364624f))))), 0.0f)), 65504.0f);
            float _283 = min((max((mad(-0.09967592358589172f, _269, (mad(1.17622971534729f, _268, (_267 * -0.07655377686023712f))))), 0.0f)), 65504.0f);
            float _284 = min((max((mad(0.9977163076400757f, _269, (mad(-0.006032449658960104f, _268, (_267 * 0.008316148072481155f))))), 0.0f)), 65504.0f);
            float _285 = dot(float3(_282, _283, _284), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
            float _296 = log2((max((((_282 - _285) * 0.9599999785423279f) + _285), 1.000000013351432e-10f)));
            float _297 = _296 * 0.3010300099849701f;
            float _298 = log2(($Globals_001x));
            float _299 = _298 * 0.3010300099849701f;
            do {
              if (!(!(_297 <= _299))) {
                _368 = ((log2(($Globals_001y))) * 0.3010300099849701f);
              } else {
                float _306 = log2(($Globals_002x));
                float _307 = _306 * 0.3010300099849701f;
                if ((((bool)((_297 > _299))) && ((bool)((_297 < _307))))) {
                  float _315 = ((_296 - _298) * 0.9030900001525879f) / ((_306 - _298) * 0.3010300099849701f);
                  int _316 = int(316);
                  float _318 = _315 - (float(_316));
                  float _320 = _6[_316];
                  float _323 = _6[(_316 + 1)];
                  float _328 = _320 * 0.5f;
                  _368 = (dot(float3((_318 * _318), _318, 1.0f), float3((mad((_6[(_316 + 2)]), 0.5f, (mad(_323, -1.0f, _328)))), (_323 - _320), (mad(_323, 0.5f, _328)))));
                } else {
                  do {
                    if (!(!(_297 >= _307))) {
                      float _337 = log2(($Globals_001z));
                      if (((_297 < (_337 * 0.3010300099849701f)))) {
                        float _345 = ((_296 - _306) * 0.9030900001525879f) / ((_337 - _306) * 0.3010300099849701f);
                        int _346 = int(346);
                        float _348 = _345 - (float(_346));
                        float _350 = _7[_346];
                        float _353 = _7[(_346 + 1)];
                        float _358 = _350 * 0.5f;
                        _368 = (dot(float3((_348 * _348), _348, 1.0f), float3((mad((_7[(_346 + 2)]), 0.5f, (mad(_353, -1.0f, _358)))), (_353 - _350), (mad(_353, 0.5f, _358)))));
                        break;
                      }
                    }
                    _368 = ((log2(($Globals_001w))) * 0.3010300099849701f);
                  } while (false);
                }
              }
              float _372 = log2((max((((_283 - _285) * 0.9599999785423279f) + _285), 1.000000013351432e-10f)));
              float _373 = _372 * 0.3010300099849701f;
              do {
                if (!(!(_373 <= _299))) {
                  _442 = ((log2(($Globals_001y))) * 0.3010300099849701f);
                } else {
                  float _380 = log2(($Globals_002x));
                  float _381 = _380 * 0.3010300099849701f;
                  if ((((bool)((_373 > _299))) && ((bool)((_373 < _381))))) {
                    float _389 = ((_372 - _298) * 0.9030900001525879f) / ((_380 - _298) * 0.3010300099849701f);
                    int _390 = int(390);
                    float _392 = _389 - (float(_390));
                    float _394 = _6[_390];
                    float _397 = _6[(_390 + 1)];
                    float _402 = _394 * 0.5f;
                    _442 = (dot(float3((_392 * _392), _392, 1.0f), float3((mad((_6[(_390 + 2)]), 0.5f, (mad(_397, -1.0f, _402)))), (_397 - _394), (mad(_397, 0.5f, _402)))));
                  } else {
                    do {
                      if (!(!(_373 >= _381))) {
                        float _411 = log2(($Globals_001z));
                        if (((_373 < (_411 * 0.3010300099849701f)))) {
                          float _419 = ((_372 - _380) * 0.9030900001525879f) / ((_411 - _380) * 0.3010300099849701f);
                          int _420 = int(420);
                          float _422 = _419 - (float(_420));
                          float _424 = _7[_420];
                          float _427 = _7[(_420 + 1)];
                          float _432 = _424 * 0.5f;
                          _442 = (dot(float3((_422 * _422), _422, 1.0f), float3((mad((_7[(_420 + 2)]), 0.5f, (mad(_427, -1.0f, _432)))), (_427 - _424), (mad(_427, 0.5f, _432)))));
                          break;
                        }
                      }
                      _442 = ((log2(($Globals_001w))) * 0.3010300099849701f);
                    } while (false);
                  }
                }
                float _446 = log2((max((((_284 - _285) * 0.9599999785423279f) + _285), 1.000000013351432e-10f)));
                float _447 = _446 * 0.3010300099849701f;
                do {
                  if (!(!(_447 <= _299))) {
                    _516 = ((log2(($Globals_001y))) * 0.3010300099849701f);
                  } else {
                    float _454 = log2(($Globals_002x));
                    float _455 = _454 * 0.3010300099849701f;
                    if ((((bool)((_447 > _299))) && ((bool)((_447 < _455))))) {
                      float _463 = ((_446 - _298) * 0.9030900001525879f) / ((_454 - _298) * 0.3010300099849701f);
                      int _464 = int(464);
                      float _466 = _463 - (float(_464));
                      float _468 = _6[_464];
                      float _471 = _6[(_464 + 1)];
                      float _476 = _468 * 0.5f;
                      _516 = (dot(float3((_466 * _466), _466, 1.0f), float3((mad((_6[(_464 + 2)]), 0.5f, (mad(_471, -1.0f, _476)))), (_471 - _468), (mad(_471, 0.5f, _476)))));
                    } else {
                      do {
                        if (!(!(_447 >= _455))) {
                          float _485 = log2(($Globals_001z));
                          if (((_447 < (_485 * 0.3010300099849701f)))) {
                            float _493 = ((_446 - _454) * 0.9030900001525879f) / ((_485 - _454) * 0.3010300099849701f);
                            int _494 = int(494);
                            float _496 = _493 - (float(_494));
                            float _498 = _7[_494];
                            float _501 = _7[(_494 + 1)];
                            float _506 = _498 * 0.5f;
                            _516 = (dot(float3((_496 * _496), _496, 1.0f), float3((mad((_7[(_494 + 2)]), 0.5f, (mad(_501, -1.0f, _506)))), (_501 - _498), (mad(_501, 0.5f, _506)))));
                            break;
                          }
                        }
                        _516 = ((log2(($Globals_001w))) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _520 = ($Globals_001w) - ($Globals_001y);
                  float _521 = ((exp2((_368 * 3.321928024291992f))) - ($Globals_001y)) / _520;
                  float _523 = ((exp2((_442 * 3.321928024291992f))) - ($Globals_001y)) / _520;
                  float _525 = ((exp2((_516 * 3.321928024291992f))) - ($Globals_001y)) / _520;
                  float _528 = mad(0.15618768334388733f, _525, (mad(0.13400420546531677f, _523, (_521 * 0.6624541878700256f))));
                  float _531 = mad(0.053689517080783844f, _525, (mad(0.6740817427635193f, _523, (_521 * 0.2722287178039551f))));
                  float _534 = mad(1.0103391408920288f, _525, (mad(0.00406073359772563f, _523, (_521 * -0.005574649665504694f))));
                  float _547 = min((max((mad(-0.23642469942569733f, _534, (mad(-0.32480329275131226f, _531, (_528 * 1.6410233974456787f))))), 0.0f)), 1.0f);
                  float _548 = min((max((mad(0.016756348311901093f, _534, (mad(1.6153316497802734f, _531, (_528 * -0.663662850856781f))))), 0.0f)), 1.0f);
                  float _549 = min((max((mad(0.9883948564529419f, _534, (mad(-0.008284442126750946f, _531, (_528 * 0.011721894145011902f))))), 0.0f)), 1.0f);
                  float _552 = mad(0.15618768334388733f, _549, (mad(0.13400420546531677f, _548, (_547 * 0.6624541878700256f))));
                  float _555 = mad(0.053689517080783844f, _549, (mad(0.6740817427635193f, _548, (_547 * 0.2722287178039551f))));
                  float _558 = mad(1.0103391408920288f, _549, (mad(0.00406073359772563f, _548, (_547 * -0.005574649665504694f))));
                  float _580 = min((max(((min((max((mad(-0.23642469942569733f, _558, (mad(-0.32480329275131226f, _555, (_552 * 1.6410233974456787f))))), 0.0f)), 65535.0f)) * ($Globals_001w)), 0.0f)), 65535.0f);
                  float _581 = min((max(((min((max((mad(0.016756348311901093f, _558, (mad(1.6153316497802734f, _555, (_552 * -0.663662850856781f))))), 0.0f)), 65535.0f)) * ($Globals_001w)), 0.0f)), 65535.0f);
                  float _582 = min((max(((min((max((mad(0.9883948564529419f, _558, (mad(-0.008284442126750946f, _555, (_552 * 0.011721894145011902f))))), 0.0f)), 65535.0f)) * ($Globals_001w)), 0.0f)), 65535.0f);
                  _597 = _580;
                  _598 = _581;
                  _599 = _582;
                  do {
                    if (!((((uint)($Globals_000x)) == 5))) {
                      _597 = (mad(_35, _582, (mad(_34, _581, (_580 * _33)))));
                      _598 = (mad(_38, _582, (mad(_37, _581, (_580 * _36)))));
                      _599 = (mad(_41, _582, (mad(_40, _581, (_580 * _39)))));
                    }
                    float _609 = exp2(((log2((_597 * 9.999999747378752e-05f))) * 0.1593017578125f));
                    float _610 = exp2(((log2((_598 * 9.999999747378752e-05f))) * 0.1593017578125f));
                    float _611 = exp2(((log2((_599 * 9.999999747378752e-05f))) * 0.1593017578125f));
                    _1168 = (exp2(((log2(((1.0f / ((_609 * 18.6875f) + 1.0f)) * ((_609 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                    _1169 = (exp2(((log2(((1.0f / ((_610 * 18.6875f) + 1.0f)) * ((_610 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                    _1170 = (exp2(((log2(((1.0f / ((_611 * 18.6875f) + 1.0f)) * ((_611 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1168 = _10;
    _1169 = _11;
    _1170 = _13;
    if ((((((uint)($Globals_000x)) & -3) == 4))) {
      float _645 = mad(0.177378311753273f, _76, (mad(0.38298869132995605f, _75, (_72 * 4396.32958984375f))));
      float _648 = mad(0.09678413718938828f, _76, (mad(0.8134394288063049f, _75, (_72 * 897.7644653320312f))));
      float _651 = mad(0.8709122538566589f, _76, (mad(0.11154655367136002f, _75, (_72 * 175.4116973876953f))));
      float _655 = max((max(_645, _648)), _651);
      float _660 = ((max(_655, 1.000000013351432e-10f)) - (max((min((min(_645, _648)), _651)), 1.000000013351432e-10f))) / (max(_655, 0.009999999776482582f));
      float _673 = ((_648 + _645) + _651) + ((sqrt(((((_651 - _648) * _651) + ((_648 - _645) * _648)) + ((_645 - _651) * _645)))) * 1.75f);
      float _674 = _673 * 0.3333333432674408f;
      float _675 = _660 + -0.4000000059604645f;
      float _676 = _675 * 5.0f;
      float _680 = max((1.0f - (abs((_675 * 2.5f)))), 0.0f);
      float _691 = (((float(((int(((bool)((_676 > 0.0f))))) - (int(((bool)((_676 < 0.0f)))))))) * (1.0f - (_680 * _680))) + 1.0f) * 0.02500000037252903f;
      _700 = _691;
      do {
        if ((!(_674 <= 0.0533333346247673f))) {
          _700 = 0.0f;
          if ((!(_674 >= 0.1599999964237213f))) {
            _700 = (((0.23999999463558197f / _673) + -0.5f) * _691);
          }
        }
        float _701 = _700 + 1.0f;
        float _702 = _701 * _645;
        float _703 = _701 * _648;
        float _704 = _701 * _651;
        _733 = 0.0f;
        do {
          if (!(((bool)((_702 == _703))) && ((bool)((_703 == _704))))) {
            float _711 = ((_702 * 2.0f) - _703) - _704;
            float _714 = ((_648 - _651) * 1.7320507764816284f) * _701;
            float _716 = atan((_714 / _711));
            bool _719 = (_711 < 0.0f);
            bool _720 = (_711 == 0.0f);
            bool _721 = (_714 >= 0.0f);
            bool _722 = (_714 < 0.0f);
            _733 = ((((bool)(_721 && _720)) ? 90.0f : ((((bool)(_722 && _720)) ? -90.0f : (((((bool)(_722 && _719)) ? (_716 + -3.1415927410125732f) : ((((bool)(_721 && _719)) ? (_716 + 3.1415927410125732f) : _716)))) * 57.2957763671875f)))));
          }
          float _738 = min((max(((((bool)((_733 < 0.0f))) ? (_733 + 360.0f) : _733)), 0.0f)), 360.0f);
          do {
            if (((_738 < -180.0f))) {
              _747 = (_738 + 360.0f);
            } else {
              _747 = _738;
              if (((_738 > 180.0f))) {
                _747 = (_738 + -360.0f);
              }
            }
            _786 = 0.0f;
            do {
              if ((((bool)((_747 > -67.5f))) && ((bool)((_747 < 67.5f))))) {
                float _753 = (_747 + 67.5f) * 0.029629629105329514f;
                int _754 = int(754);
                float _756 = _753 - (float(_754));
                float _757 = _756 * _756;
                float _758 = _757 * _756;
                if (((_754 == 3))) {
                  _786 = (((0.1666666716337204f - (_756 * 0.5f)) + (_757 * 0.5f)) - (_758 * 0.1666666716337204f));
                } else {
                  if (((_754 == 2))) {
                    _786 = ((0.6666666865348816f - _757) + (_758 * 0.5f));
                  } else {
                    if (((_754 == 1))) {
                      _786 = (((_758 * -0.5f) + 0.1666666716337204f) + ((_757 + _756) * 0.5f));
                    } else {
                      _786 = ((((bool)((_754 == 0))) ? (_758 * 0.1666666716337204f) : 0.0f));
                    }
                  }
                }
              }
              float _795 = min((max(((((_660 * 0.27000001072883606f) * (0.029999999329447746f - _702)) * _786) + _702), 0.0f)), 65535.0f);
              float _796 = min((max(_703, 0.0f)), 65535.0f);
              float _797 = min((max(_704, 0.0f)), 65535.0f);
              float _810 = min((max((mad(-0.21492856740951538f, _797, (mad(-0.2365107536315918f, _796, (_795 * 1.4514392614364624f))))), 0.0f)), 65504.0f);
              float _811 = min((max((mad(-0.09967592358589172f, _797, (mad(1.17622971534729f, _796, (_795 * -0.07655377686023712f))))), 0.0f)), 65504.0f);
              float _812 = min((max((mad(0.9977163076400757f, _797, (mad(-0.006032449658960104f, _796, (_795 * 0.008316148072481155f))))), 0.0f)), 65504.0f);
              float _813 = dot(float3(_810, _811, _812), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _824 = log2((max((((_810 - _813) * 0.9599999785423279f) + _813), 1.000000013351432e-10f)));
              float _825 = _824 * 0.3010300099849701f;
              float _826 = log2(($Globals_001x));
              float _827 = _826 * 0.3010300099849701f;
              do {
                if (!(!(_825 <= _827))) {
                  _896 = ((log2(($Globals_001y))) * 0.3010300099849701f);
                } else {
                  float _834 = log2(($Globals_002x));
                  float _835 = _834 * 0.3010300099849701f;
                  if ((((bool)((_825 > _827))) && ((bool)((_825 < _835))))) {
                    float _843 = ((_824 - _826) * 0.9030900001525879f) / ((_834 - _826) * 0.3010300099849701f);
                    int _844 = int(844);
                    float _846 = _843 - (float(_844));
                    float _848 = _6[_844];
                    float _851 = _6[(_844 + 1)];
                    float _856 = _848 * 0.5f;
                    _896 = (dot(float3((_846 * _846), _846, 1.0f), float3((mad((_6[(_844 + 2)]), 0.5f, (mad(_851, -1.0f, _856)))), (_851 - _848), (mad(_851, 0.5f, _856)))));
                  } else {
                    do {
                      if (!(!(_825 >= _835))) {
                        float _865 = log2(($Globals_001z));
                        if (((_825 < (_865 * 0.3010300099849701f)))) {
                          float _873 = ((_824 - _834) * 0.9030900001525879f) / ((_865 - _834) * 0.3010300099849701f);
                          int _874 = int(874);
                          float _876 = _873 - (float(_874));
                          float _878 = _7[_874];
                          float _881 = _7[(_874 + 1)];
                          float _886 = _878 * 0.5f;
                          _896 = (dot(float3((_876 * _876), _876, 1.0f), float3((mad((_7[(_874 + 2)]), 0.5f, (mad(_881, -1.0f, _886)))), (_881 - _878), (mad(_881, 0.5f, _886)))));
                          break;
                        }
                      }
                      _896 = ((log2(($Globals_001w))) * 0.3010300099849701f);
                    } while (false);
                  }
                }
                float _900 = log2((max((((_811 - _813) * 0.9599999785423279f) + _813), 1.000000013351432e-10f)));
                float _901 = _900 * 0.3010300099849701f;
                do {
                  if (!(!(_901 <= _827))) {
                    _970 = ((log2(($Globals_001y))) * 0.3010300099849701f);
                  } else {
                    float _908 = log2(($Globals_002x));
                    float _909 = _908 * 0.3010300099849701f;
                    if ((((bool)((_901 > _827))) && ((bool)((_901 < _909))))) {
                      float _917 = ((_900 - _826) * 0.9030900001525879f) / ((_908 - _826) * 0.3010300099849701f);
                      int _918 = int(918);
                      float _920 = _917 - (float(_918));
                      float _922 = _6[_918];
                      float _925 = _6[(_918 + 1)];
                      float _930 = _922 * 0.5f;
                      _970 = (dot(float3((_920 * _920), _920, 1.0f), float3((mad((_6[(_918 + 2)]), 0.5f, (mad(_925, -1.0f, _930)))), (_925 - _922), (mad(_925, 0.5f, _930)))));
                    } else {
                      do {
                        if (!(!(_901 >= _909))) {
                          float _939 = log2(($Globals_001z));
                          if (((_901 < (_939 * 0.3010300099849701f)))) {
                            float _947 = ((_900 - _908) * 0.9030900001525879f) / ((_939 - _908) * 0.3010300099849701f);
                            int _948 = int(948);
                            float _950 = _947 - (float(_948));
                            float _952 = _7[_948];
                            float _955 = _7[(_948 + 1)];
                            float _960 = _952 * 0.5f;
                            _970 = (dot(float3((_950 * _950), _950, 1.0f), float3((mad((_7[(_948 + 2)]), 0.5f, (mad(_955, -1.0f, _960)))), (_955 - _952), (mad(_955, 0.5f, _960)))));
                            break;
                          }
                        }
                        _970 = ((log2(($Globals_001w))) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _974 = log2((max((((_812 - _813) * 0.9599999785423279f) + _813), 1.000000013351432e-10f)));
                  float _975 = _974 * 0.3010300099849701f;
                  do {
                    if (!(!(_975 <= _827))) {
                      _1044 = ((log2(($Globals_001y))) * 0.3010300099849701f);
                    } else {
                      float _982 = log2(($Globals_002x));
                      float _983 = _982 * 0.3010300099849701f;
                      if ((((bool)((_975 > _827))) && ((bool)((_975 < _983))))) {
                        float _991 = ((_974 - _826) * 0.9030900001525879f) / ((_982 - _826) * 0.3010300099849701f);
                        int _992 = int(992);
                        float _994 = _991 - (float(_992));
                        float _996 = _6[_992];
                        float _999 = _6[(_992 + 1)];
                        float _1004 = _996 * 0.5f;
                        _1044 = (dot(float3((_994 * _994), _994, 1.0f), float3((mad((_6[(_992 + 2)]), 0.5f, (mad(_999, -1.0f, _1004)))), (_999 - _996), (mad(_999, 0.5f, _1004)))));
                      } else {
                        do {
                          if (!(!(_975 >= _983))) {
                            float _1013 = log2(($Globals_001z));
                            if (((_975 < (_1013 * 0.3010300099849701f)))) {
                              float _1021 = ((_974 - _982) * 0.9030900001525879f) / ((_1013 - _982) * 0.3010300099849701f);
                              int _1022 = int(1022);
                              float _1024 = _1021 - (float(_1022));
                              float _1026 = _7[_1022];
                              float _1029 = _7[(_1022 + 1)];
                              float _1034 = _1026 * 0.5f;
                              _1044 = (dot(float3((_1024 * _1024), _1024, 1.0f), float3((mad((_7[(_1022 + 2)]), 0.5f, (mad(_1029, -1.0f, _1034)))), (_1029 - _1026), (mad(_1029, 0.5f, _1034)))));
                              break;
                            }
                          }
                          _1044 = ((log2(($Globals_001w))) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1048 = ($Globals_001w) - ($Globals_001y);
                    float _1049 = ((exp2((_896 * 3.321928024291992f))) - ($Globals_001y)) / _1048;
                    float _1051 = ((exp2((_970 * 3.321928024291992f))) - ($Globals_001y)) / _1048;
                    float _1053 = ((exp2((_1044 * 3.321928024291992f))) - ($Globals_001y)) / _1048;
                    float _1056 = mad(0.15618768334388733f, _1053, (mad(0.13400420546531677f, _1051, (_1049 * 0.6624541878700256f))));
                    float _1059 = mad(0.053689517080783844f, _1053, (mad(0.6740817427635193f, _1051, (_1049 * 0.2722287178039551f))));
                    float _1062 = mad(1.0103391408920288f, _1053, (mad(0.00406073359772563f, _1051, (_1049 * -0.005574649665504694f))));
                    float _1075 = min((max((mad(-0.23642469942569733f, _1062, (mad(-0.32480329275131226f, _1059, (_1056 * 1.6410233974456787f))))), 0.0f)), 1.0f);
                    float _1076 = min((max((mad(0.016756348311901093f, _1062, (mad(1.6153316497802734f, _1059, (_1056 * -0.663662850856781f))))), 0.0f)), 1.0f);
                    float _1077 = min((max((mad(0.9883948564529419f, _1062, (mad(-0.008284442126750946f, _1059, (_1056 * 0.011721894145011902f))))), 0.0f)), 1.0f);
                    float _1080 = mad(0.15618768334388733f, _1077, (mad(0.13400420546531677f, _1076, (_1075 * 0.6624541878700256f))));
                    float _1083 = mad(0.053689517080783844f, _1077, (mad(0.6740817427635193f, _1076, (_1075 * 0.2722287178039551f))));
                    float _1086 = mad(1.0103391408920288f, _1077, (mad(0.00406073359772563f, _1076, (_1075 * -0.005574649665504694f))));
                    float _1108 = min((max(((min((max((mad(-0.23642469942569733f, _1086, (mad(-0.32480329275131226f, _1083, (_1080 * 1.6410233974456787f))))), 0.0f)), 65535.0f)) * ($Globals_001w)), 0.0f)), 65535.0f);
                    float _1109 = min((max(((min((max((mad(0.016756348311901093f, _1086, (mad(1.6153316497802734f, _1083, (_1080 * -0.663662850856781f))))), 0.0f)), 65535.0f)) * ($Globals_001w)), 0.0f)), 65535.0f);
                    float _1110 = min((max(((min((max((mad(0.9883948564529419f, _1086, (mad(-0.008284442126750946f, _1083, (_1080 * 0.011721894145011902f))))), 0.0f)), 65535.0f)) * ($Globals_001w)), 0.0f)), 65535.0f);
                    _1125 = _1108;
                    _1126 = _1109;
                    _1127 = _1110;
                    do {
                      if (!((((uint)($Globals_000x)) == 6))) {
                        _1125 = (mad(_35, _1110, (mad(_34, _1109, (_1108 * _33)))));
                        _1126 = (mad(_38, _1110, (mad(_37, _1109, (_1108 * _36)))));
                        _1127 = (mad(_41, _1110, (mad(_40, _1109, (_1108 * _39)))));
                      }
                      float _1137 = exp2(((log2((_1125 * 9.999999747378752e-05f))) * 0.1593017578125f));
                      float _1138 = exp2(((log2((_1126 * 9.999999747378752e-05f))) * 0.1593017578125f));
                      float _1139 = exp2(((log2((_1127 * 9.999999747378752e-05f))) * 0.1593017578125f));
                      _1168 = (exp2(((log2(((1.0f / ((_1137 * 18.6875f) + 1.0f)) * ((_1137 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                      _1169 = (exp2(((log2(((1.0f / ((_1138 * 18.6875f) + 1.0f)) * ((_1138 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                      _1170 = (exp2(((log2(((1.0f / ((_1139 * 18.6875f) + 1.0f)) * ((_1139 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    }
  }
  SV_Target.x = (_1168 * 0.9523810148239136f);
  SV_Target.y = (_1169 * 0.9523810148239136f);
  SV_Target.z = (_1170 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
