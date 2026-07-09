struct ACESTonemapperParameters__Constants {
  float ACESTonemapperParameters__Constants_000;
};

struct GTTonemapperParameters__Constants {
  float GTTonemapperParameters__Constants_000;
  float GTTonemapperParameters__Constants_004;
  float GTTonemapperParameters__Constants_008;
  float GTTonemapperParameters__Constants_012;
  float GTTonemapperParameters__Constants_016;
};

struct LottesTonemapperParameters__Constants {
  float LottesTonemapperParameters__Constants_000;
  float LottesTonemapperParameters__Constants_004;
  float LottesTonemapperParameters__Constants_008;
  float LottesTonemapperParameters__Constants_012;
};

struct GeneralTonemappingParameters__Constants {
  int GeneralTonemappingParameters__Constants_000;
  int GeneralTonemappingParameters__Constants_004;
  float GeneralTonemappingParameters__Constants_008;
  float GeneralTonemappingParameters__Constants_012;
};

struct TonemapperParams__Constants {
  GTTonemapperParameters__Constants TonemapperParams__Constants_000;
  LottesTonemapperParameters__Constants TonemapperParams__Constants_020;
  GeneralTonemappingParameters__Constants TonemapperParams__Constants_036;
  ACESTonemapperParameters__Constants TonemapperParams__Constants_052;
};

struct ColorGradingGenerateVideoSDRtoHDRLUT__Constants {
  TonemapperParams__Constants ColorGradingGenerateVideoSDRtoHDRLUT__Constants_000;
  TonemapperParams__Constants ColorGradingGenerateVideoSDRtoHDRLUT__Constants_056;
};

RWTexture3D<float4> u0_space5 : register(u0, space5);

cbuffer cb0_space5 : register(b0, space5) {
  float cb0_space5_000x : packoffset(c000.x);
  float cb0_space5_000y : packoffset(c000.y);
  float cb0_space5_000z : packoffset(c000.z);
  float cb0_space5_000w : packoffset(c000.w);
  float cb0_space5_001x : packoffset(c001.x);
  float cb0_space5_002x : packoffset(c002.x);
  float cb0_space5_002y : packoffset(c002.y);
  float cb0_space5_002z : packoffset(c002.z);
  float cb0_space5_002w : packoffset(c002.w);
  int cb0_space5_003x : packoffset(c003.x);
  int cb0_space5_003y : packoffset(c003.y);
  float cb0_space5_003z : packoffset(c003.z);
  float cb0_space5_003w : packoffset(c003.w);
  float cb0_space5_005x : packoffset(c005.x);
  float cb0_space5_005y : packoffset(c005.y);
  float cb0_space5_005z : packoffset(c005.z);
  float cb0_space5_005w : packoffset(c005.w);
  float cb0_space5_006x : packoffset(c006.x);
  float cb0_space5_007x : packoffset(c007.x);
  float cb0_space5_007y : packoffset(c007.y);
  float cb0_space5_007z : packoffset(c007.z);
  float cb0_space5_007w : packoffset(c007.w);
  int cb0_space5_008x : packoffset(c008.x);
  int cb0_space5_008y : packoffset(c008.y);
  float cb0_space5_008z : packoffset(c008.z);
  float cb0_space5_008w : packoffset(c008.w);
};

[numthreads(16, 16, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _9;
  float _10;
  float _11;
  float _112;
  float _113;
  float _114;
  float _140;
  float _141;
  float _170;
  float _171;
  float _192;
  float _202;
  float _203;
  float _232;
  float _233;
  float _254;
  float _264;
  float _265;
  float _294;
  float _295;
  float _316;
  float _355;
  float _356;
  int _357;
  float _382;
  float _383;
  int _384;
  float _410;
  float _411;
  int _412;
  float _472;
  float _473;
  float _501;
  float _502;
  float _524;
  float _534;
  float _535;
  float _563;
  float _564;
  float _586;
  float _596;
  float _597;
  float _625;
  float _626;
  float _648;
  float _652;
  float _653;
  float _654;
  float _1001;
  float _1002;
  float _1003;
  float _1097;
  float _1098;
  float _1099;
  float _19;
  float _20;
  float _29;
  float _33;
  float _34;
  float _44;
  float _48;
  float _49;
  float _59;
  float _70;
  float _71;
  float _72;
  float _99;
  float _100;
  float _101;
  float _118;
  float _121;
  float _131;
  float _133;
  float _143;
  float _147;
  float _154;
  float _158;
  bool _163;
  float _164;
  float _165;
  float _195;
  float _205;
  float _209;
  float _216;
  float _220;
  bool _225;
  float _226;
  float _227;
  float _257;
  float _267;
  float _271;
  float _278;
  float _282;
  bool _287;
  float _288;
  float _289;
  float _321;
  float _330;
  float _333;
  float _335;
  float _336;
  float _338;
  float _340;
  float _342;
  float _345;
  float _350;
  float _351;
  float _353;
  float _359;
  bool _367;
  float _368;
  float _369;
  int _370;
  float _386;
  bool _394;
  float _395;
  float _396;
  int _397;
  float _414;
  bool _422;
  float _423;
  float _424;
  int _425;
  float _450;
  float _453;
  float _463;
  float _465;
  float _475;
  float _479;
  float _485;
  float _489;
  bool _494;
  float _495;
  float _496;
  float _508;
  float _527;
  float _537;
  float _541;
  float _547;
  float _551;
  bool _556;
  float _557;
  float _558;
  float _570;
  float _589;
  float _599;
  float _603;
  float _609;
  float _613;
  bool _618;
  float _619;
  float _620;
  float _632;
  float _662;
  float _663;
  float _664;
  float _669;
  float _671;
  float _681;
  float _682;
  bool _685;
  float _686;
  float _697;
  float _698;
  float _705;
  float _709;
  float _711;
  float _713;
  float _722;
  float _723;
  float _726;
  float _740;
  float _744;
  float _747;
  float _756;
  float _757;
  float _760;
  float _774;
  float _778;
  float _781;
  float _791;
  float _800;
  float _803;
  float _805;
  float _806;
  float _808;
  float _810;
  float _812;
  float _815;
  float _820;
  float _823;
  float _835;
  float _847;
  float _873;
  float _875;
  float _885;
  float _886;
  bool _889;
  float _890;
  float _901;
  float _902;
  float _911;
  float _915;
  float _917;
  float _919;
  float _928;
  float _929;
  float _932;
  float _948;
  float _952;
  float _955;
  float _964;
  float _965;
  float _968;
  float _984;
  float _988;
  float _991;
  float _1020;
  float _1033;
  float _1046;
  float _1069;
  float _1070;
  float _1071;
  _9 = ((float)((uint)SV_DispatchThreadID.x)) * 0.032258063554763794f;
  _10 = ((float)((uint)SV_DispatchThreadID.y)) * 0.032258063554763794f;
  _11 = ((float)((uint)SV_DispatchThreadID.z)) * 0.032258063554763794f;
  if (!(cb0_space5_008x == 0)) {
    _19 = exp2(log2(abs(_9)) * 0.012683313339948654f);
    _20 = _19 + -0.8359375f;
    _29 = exp2(log2(abs(select((_20 < 0.0f), 0.0f, _20) / (18.8515625f - (_19 * 18.6875f)))) * 6.277394771575928f);
    _33 = exp2(log2(abs(_10)) * 0.012683313339948654f);
    _34 = _33 + -0.8359375f;
    _44 = exp2(log2(abs(select((_34 < 0.0f), 0.0f, _34) / (18.8515625f - (_33 * 18.6875f)))) * 6.277394771575928f) * 10000.0f;
    _48 = exp2(log2(abs(_11)) * 0.012683313339948654f);
    _49 = _48 + -0.8359375f;
    _59 = exp2(log2(abs(select((_49 < 0.0f), 0.0f, _49) / (18.8515625f - (_48 * 18.6875f)))) * 6.277394771575928f) * 10000.0f;
    _112 = mad(_59, 0.005505878012627363f, mad(_44, 0.01959916017949581f, (_29 * 9748.951171875f)));
    _113 = mad(_59, 0.0022850031964480877f, mad(_44, 0.9955354928970337f, (_29 * 21.795501708984375f)));
    _114 = mad(_59, 0.9706707000732422f, mad(_44, 0.024532008916139603f, (_29 * 47.97255325317383f)));
  } else {
    _70 = saturate(_9);
    _71 = saturate(_10);
    _72 = saturate(_11);
    _99 = cb0_space5_008w * select((_70 <= 0.040449999272823334f), (_70 * 0.07739938050508499f), exp2(log2((_70 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f));
    _100 = cb0_space5_008w * select((_71 <= 0.040449999272823334f), (_71 * 0.07739938050508499f), exp2(log2((_71 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f));
    _101 = cb0_space5_008w * select((_72 <= 0.040449999272823334f), (_72 * 0.07739938050508499f), exp2(log2((_72 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f));
    _112 = mad(_101, 0.04737943410873413f, mad(_100, 0.3395232558250427f, (_99 * 0.6130974292755127f)));
    _113 = mad(_101, 0.013452420942485332f, mad(_100, 0.916354238986969f, (_99 * 0.07019375264644623f)));
    _114 = mad(_101, 0.8698144555091858f, mad(_100, 0.10956975817680359f, (_99 * 0.020615598186850548f)));
  }
  switch ((int)(cb0_space5_008y)) {
    case 2: {
      _118 = abs(_112 * 0.009999999776482582f);
      _121 = cb0_space5_008w * 0.009999999776482582f;
      _131 = ((_121 - cb0_space5_005y) * cb0_space5_005z) / cb0_space5_005x;
      _133 = (_131 * cb0_space5_005x) + cb0_space5_005y;
      do {
        if (_118 < cb0_space5_005y) {
          do {
            _170 = cb0_space5_006x;
            _171 = cb0_space5_005y;
            if ((cb0_space5_005y - cb0_space5_006x) > 9.999999747378752e-06f) {
              _140 = cb0_space5_006x;
              _141 = cb0_space5_005y;
              bool _loop_break_0 = false;
              while (true) {
                _143 = (_141 + _140) * 0.5f;
                _147 = _143 / cb0_space5_005y;
                _154 = saturate(_147);
                _158 = (_154 * _154) * (3.0f - (_154 * 2.0f));
                _163 = ((((1.0f - _158) * ((exp2(log2(abs(_147)) * cb0_space5_005w) * cb0_space5_005y) + cb0_space5_006x)) + (_158 * (lerp(cb0_space5_005y, _143, cb0_space5_005x)))) > _118);
                _164 = select(_163, _140, _143);
                _165 = select(_163, _143, _141);
                do {
                  if ((_165 - _164) > 9.999999747378752e-06f) {
                    _140 = _164;
                    _141 = _165;
                    _loop_break_0 = true;
                    break;
                  }
                  _170 = _164;
                  _171 = _165;
                } while (false);
                if (_loop_break_0) {
                  _loop_break_0 = false;
                  continue;
                }
                break;
              }
            }
            _192 = ((_171 + _170) * 0.5f);
          } while (false);
        } else {
          _192 = select((_118 > _133), ((_131 + cb0_space5_005y) + (((_118 - _133) * _121) / (max((_121 - _118), 9.999999747378752e-06f) * ((cb0_space5_005x * _121) / (_121 - _133))))), (((_118 - cb0_space5_005y) / cb0_space5_005x) + cb0_space5_005y));
        }
        _195 = abs(_113 * 0.009999999776482582f);
        do {
          if (_195 < cb0_space5_005y) {
            do {
              _232 = cb0_space5_006x;
              _233 = cb0_space5_005y;
              if ((cb0_space5_005y - cb0_space5_006x) > 9.999999747378752e-06f) {
                _202 = cb0_space5_006x;
                _203 = cb0_space5_005y;
                bool _loop_break_1 = false;
                while (true) {
                  _205 = (_203 + _202) * 0.5f;
                  _209 = _205 / cb0_space5_005y;
                  _216 = saturate(_209);
                  _220 = (_216 * _216) * (3.0f - (_216 * 2.0f));
                  _225 = ((((1.0f - _220) * ((exp2(log2(abs(_209)) * cb0_space5_005w) * cb0_space5_005y) + cb0_space5_006x)) + (_220 * (lerp(cb0_space5_005y, _205, cb0_space5_005x)))) > _195);
                  _226 = select(_225, _202, _205);
                  _227 = select(_225, _205, _203);
                  do {
                    if ((_227 - _226) > 9.999999747378752e-06f) {
                      _202 = _226;
                      _203 = _227;
                      _loop_break_1 = true;
                      break;
                    }
                    _232 = _226;
                    _233 = _227;
                  } while (false);
                  if (_loop_break_1) {
                    _loop_break_1 = false;
                    continue;
                  }
                  break;
                }
              }
              _254 = ((_233 + _232) * 0.5f);
            } while (false);
          } else {
            _254 = select((_195 > _133), ((_131 + cb0_space5_005y) + (((_195 - _133) * _121) / (max((_121 - _195), 9.999999747378752e-06f) * ((cb0_space5_005x * _121) / (_121 - _133))))), (((_195 - cb0_space5_005y) / cb0_space5_005x) + cb0_space5_005y));
          }
          _257 = abs(_114 * 0.009999999776482582f);
          do {
            if (_257 < cb0_space5_005y) {
              do {
                _294 = cb0_space5_006x;
                _295 = cb0_space5_005y;
                if ((cb0_space5_005y - cb0_space5_006x) > 9.999999747378752e-06f) {
                  _264 = cb0_space5_006x;
                  _265 = cb0_space5_005y;
                  bool _loop_break_2 = false;
                  while (true) {
                    _267 = (_265 + _264) * 0.5f;
                    _271 = _267 / cb0_space5_005y;
                    _278 = saturate(_271);
                    _282 = (_278 * _278) * (3.0f - (_278 * 2.0f));
                    _287 = ((((1.0f - _282) * ((exp2(log2(abs(_271)) * cb0_space5_005w) * cb0_space5_005y) + cb0_space5_006x)) + (_282 * (lerp(cb0_space5_005y, _267, cb0_space5_005x)))) > _257);
                    _288 = select(_287, _264, _267);
                    _289 = select(_287, _267, _265);
                    do {
                      if ((_289 - _288) > 9.999999747378752e-06f) {
                        _264 = _288;
                        _265 = _289;
                        _loop_break_2 = true;
                        break;
                      }
                      _294 = _288;
                      _295 = _289;
                    } while (false);
                    if (_loop_break_2) {
                      _loop_break_2 = false;
                      continue;
                    }
                    break;
                  }
                }
                _316 = ((_295 + _294) * 0.5f);
              } while (false);
            } else {
              _316 = select((_257 > _133), ((_131 + cb0_space5_005y) + (((_257 - _133) * _121) / (max((_121 - _257), 9.999999747378752e-06f) * ((cb0_space5_005x * _121) / (_121 - _133))))), (((_257 - cb0_space5_005y) / cb0_space5_005x) + cb0_space5_005y));
            }
            _652 = (_192 * 100.0f);
            _653 = (_254 * 100.0f);
            _654 = (_316 * 100.0f);
          } while (false);
        } while (false);
      } while (false);
      break;
    }
    case 3: {
      _321 = abs(cb0_space5_008w);
      _330 = log2(abs(cb0_space5_007x));
      _333 = cb0_space5_007w * cb0_space5_007z;
      _335 = exp2(_333 * _330);
      _336 = log2(_321);
      _338 = exp2(_336 * cb0_space5_007z);
      _340 = exp2(_333 * _336);
      _342 = (_340 - _335) * cb0_space5_007y;
      _345 = ((_338 * cb0_space5_007y) - exp2(_330 * cb0_space5_007z)) / _342;
      _350 = ((_340 * _335) - ((_335 * cb0_space5_007y) * _338)) / _342;
      _351 = 1.0f / cb0_space5_007z;
      _353 = exp2(_336 * _351);
      _355 = 0.0f;
      _356 = _353;
      _357 = 0;
      bool _loop_break_3 = false;
      while (true) {
        _359 = (_356 + _355) * 0.5f;
        _367 = ((_359 / ((exp2(log2(abs(_359)) * cb0_space5_007w) * _345) + _350)) > abs(_112 / _321));
        _368 = select(_367, _355, _359);
        _369 = select(_367, _359, _356);
        _370 = _357 + 1;
        do {
          if (!(_370 == 32)) {
            _355 = _368;
            _356 = _369;
            _357 = _370;
            _loop_break_3 = true;
            break;
          }
          _382 = 0.0f;
          _383 = _353;
          _384 = 0;
          bool _loop_break_4 = false;
          while (true) {
            _386 = (_383 + _382) * 0.5f;
            _394 = ((_386 / ((exp2(log2(abs(_386)) * cb0_space5_007w) * _345) + _350)) > abs(_113 / _321));
            _395 = select(_394, _382, _386);
            _396 = select(_394, _386, _383);
            _397 = _384 + 1;
            do {
              if (!(_397 == 32)) {
                _382 = _395;
                _383 = _396;
                _384 = _397;
                _loop_break_4 = true;
                break;
              }
              _410 = 0.0f;
              _411 = _353;
              _412 = 0;
              bool _loop_break_5 = false;
              while (true) {
                _414 = (_411 + _410) * 0.5f;
                _422 = ((_414 / ((exp2(log2(abs(_414)) * cb0_space5_007w) * _345) + _350)) > abs(_114 / _321));
                _423 = select(_422, _410, _414);
                _424 = select(_422, _414, _411);
                _425 = _412 + 1;
                do {
                  if (!(_425 == 32)) {
                    _410 = _423;
                    _411 = _424;
                    _412 = _425;
                    _loop_break_5 = true;
                    break;
                  }
                  _652 = (exp2(log2(abs((_368 + _369) * 0.5f)) * _351) * _321);
                  _653 = (exp2(log2(abs((_395 + _396) * 0.5f)) * _351) * _321);
                  _654 = (exp2(log2(abs((_423 + _424) * 0.5f)) * _351) * _321);
                } while (false);
                if (_loop_break_5 && !_loop_break_4 && !_loop_break_3) {
                  _loop_break_5 = false;
                  continue;
                }
                break;
              }
              if (_loop_break_4 && !_loop_break_3) break;
            } while (false);
            if (_loop_break_4 && !_loop_break_3) {
              _loop_break_4 = false;
              continue;
            }
            break;
          }
          if (_loop_break_3) break;
        } while (false);
        if (_loop_break_3) {
          _loop_break_3 = false;
          continue;
        }
        break;
      }
      break;
    }
    case 4: {
      _652 = (_112 / (1.0f - (_112 / cb0_space5_008w)));
      _653 = (_113 / (1.0f - (_113 / cb0_space5_008w)));
      _654 = (_114 / (1.0f - (_114 / cb0_space5_008w)));
      break;
    }
    case 5: {
      _652 = _112;
      _652 = _112;
      _653 = _113;
      _653 = _113;
      _654 = _114;
      _654 = _114;
      break;
    }
    case 6: {
      _652 = _112;
      _652 = _112;
      _653 = _113;
      _653 = _113;
      _654 = _114;
      _654 = _114;
      break;
    }
    case 1: {
      _450 = abs(_112 * 0.009999999776482582f);
      _453 = cb0_space5_008w * 0.009999999776482582f;
      _463 = ((_453 - cb0_space5_005y) * cb0_space5_005z) / cb0_space5_005x;
      _465 = (_463 * cb0_space5_005x) + cb0_space5_005y;
      do {
        if (_450 < cb0_space5_005y) {
          do {
            _501 = cb0_space5_006x;
            _502 = cb0_space5_005y;
            if ((cb0_space5_005y - cb0_space5_006x) > 9.999999747378752e-06f) {
              _472 = cb0_space5_006x;
              _473 = cb0_space5_005y;
              bool _loop_break_6 = false;
              while (true) {
                _475 = (_473 + _472) * 0.5f;
                _479 = _475 / cb0_space5_005y;
                _485 = saturate(_479);
                _489 = (_485 * _485) * (3.0f - (_485 * 2.0f));
                _494 = ((((1.0f - _489) * (((pow(_479, cb0_space5_005w))*cb0_space5_005y) + cb0_space5_006x)) + (_489 * (lerp(cb0_space5_005y, _475, cb0_space5_005x)))) > _450);
                _495 = select(_494, _472, _475);
                _496 = select(_494, _475, _473);
                do {
                  if ((_496 - _495) > 9.999999747378752e-06f) {
                    _472 = _495;
                    _473 = _496;
                    _loop_break_6 = true;
                    break;
                  }
                  _501 = _495;
                  _502 = _496;
                } while (false);
                if (_loop_break_6) {
                  _loop_break_6 = false;
                  continue;
                }
                break;
              }
            }
            _524 = ((_502 + _501) * 0.5f);
          } while (false);
        } else {
          _508 = _453 - _465;
          _524 = select((_450 > _465), ((_463 + cb0_space5_005y) - ((((cb0_space5_008w * 0.006931471638381481f) * _508) * log2(max(((_453 - _450) / _508), 9.999999747378752e-06f))) / (cb0_space5_005x * _453))), (((_450 - cb0_space5_005y) / cb0_space5_005x) + cb0_space5_005y));
        }
        _527 = abs(_113 * 0.009999999776482582f);
        do {
          if (_527 < cb0_space5_005y) {
            do {
              _563 = cb0_space5_006x;
              _564 = cb0_space5_005y;
              if ((cb0_space5_005y - cb0_space5_006x) > 9.999999747378752e-06f) {
                _534 = cb0_space5_006x;
                _535 = cb0_space5_005y;
                bool _loop_break_7 = false;
                while (true) {
                  _537 = (_535 + _534) * 0.5f;
                  _541 = _537 / cb0_space5_005y;
                  _547 = saturate(_541);
                  _551 = (_547 * _547) * (3.0f - (_547 * 2.0f));
                  _556 = ((((1.0f - _551) * (((pow(_541, cb0_space5_005w))*cb0_space5_005y) + cb0_space5_006x)) + (_551 * (lerp(cb0_space5_005y, _537, cb0_space5_005x)))) > _527);
                  _557 = select(_556, _534, _537);
                  _558 = select(_556, _537, _535);
                  do {
                    if ((_558 - _557) > 9.999999747378752e-06f) {
                      _534 = _557;
                      _535 = _558;
                      _loop_break_7 = true;
                      break;
                    }
                    _563 = _557;
                    _564 = _558;
                  } while (false);
                  if (_loop_break_7) {
                    _loop_break_7 = false;
                    continue;
                  }
                  break;
                }
              }
              _586 = ((_564 + _563) * 0.5f);
            } while (false);
          } else {
            _570 = _453 - _465;
            _586 = select((_527 > _465), ((_463 + cb0_space5_005y) - ((((cb0_space5_008w * 0.006931471638381481f) * _570) * log2(max(((_453 - _527) / _570), 9.999999747378752e-06f))) / (cb0_space5_005x * _453))), (((_527 - cb0_space5_005y) / cb0_space5_005x) + cb0_space5_005y));
          }
          _589 = abs(_114 * 0.009999999776482582f);
          do {
            if (_589 < cb0_space5_005y) {
              do {
                _625 = cb0_space5_006x;
                _626 = cb0_space5_005y;
                if ((cb0_space5_005y - cb0_space5_006x) > 9.999999747378752e-06f) {
                  _596 = cb0_space5_006x;
                  _597 = cb0_space5_005y;
                  bool _loop_break_8 = false;
                  while (true) {
                    _599 = (_597 + _596) * 0.5f;
                    _603 = _599 / cb0_space5_005y;
                    _609 = saturate(_603);
                    _613 = (_609 * _609) * (3.0f - (_609 * 2.0f));
                    _618 = ((((1.0f - _613) * (((pow(_603, cb0_space5_005w))*cb0_space5_005y) + cb0_space5_006x)) + (_613 * (lerp(cb0_space5_005y, _599, cb0_space5_005x)))) > _589);
                    _619 = select(_618, _596, _599);
                    _620 = select(_618, _599, _597);
                    do {
                      if ((_620 - _619) > 9.999999747378752e-06f) {
                        _596 = _619;
                        _597 = _620;
                        _loop_break_8 = true;
                        break;
                      }
                      _625 = _619;
                      _626 = _620;
                    } while (false);
                    if (_loop_break_8) {
                      _loop_break_8 = false;
                      continue;
                    }
                    break;
                  }
                }
                _648 = ((_626 + _625) * 0.5f);
              } while (false);
            } else {
              _632 = _453 - _465;
              _648 = select((_589 > _465), ((_463 + cb0_space5_005y) - ((((cb0_space5_008w * 0.006931471638381481f) * _632) * log2(max(((_453 - _589) / _632), 9.999999747378752e-06f))) / (cb0_space5_005x * _453))), (((_589 - cb0_space5_005y) / cb0_space5_005x) + cb0_space5_005y));
            }
            _652 = (_524 * 100.0f);
            _653 = (_586 * 100.0f);
            _654 = (_648 * 100.0f);
          } while (false);
        } while (false);
      } while (false);
      break;
    }
    default: {
      _652 = 0.0f;
      _653 = 0.0f;
      _654 = 0.0f;
      break;
    }
  }
  _662 = cb0_space5_003z * (_652 / cb0_space5_008z);
  _663 = cb0_space5_003z * (_653 / cb0_space5_008z);
  _664 = cb0_space5_003z * (_654 / cb0_space5_008z);
  switch ((int)(cb0_space5_003y)) {
    case 2: {
      _669 = abs(_662 * 0.009999999776482582f);
      _671 = cb0_space5_003w * 0.009999999776482582f;
      _681 = ((_671 - cb0_space5_000y) * cb0_space5_000z) / cb0_space5_000x;
      _682 = _669 - cb0_space5_000y;
      _685 = (cb0_space5_000y > 9.999999747378752e-06f);
      _686 = _669 / cb0_space5_000y;
      _697 = _671 - ((_681 * cb0_space5_000x) + cb0_space5_000y);
      _698 = (cb0_space5_000x * _671) / _697;
      _705 = saturate(_686);
      _709 = (_705 * _705) * (3.0f - (_705 * 2.0f));
      _711 = _681 + cb0_space5_000y;
      _713 = select((_669 > _711), 1.0f, 0.0f);
      _722 = abs(_663 * 0.009999999776482582f);
      _723 = _722 - cb0_space5_000y;
      _726 = _722 / cb0_space5_000y;
      _740 = saturate(_726);
      _744 = (_740 * _740) * (3.0f - (_740 * 2.0f));
      _747 = select((_722 > _711), 1.0f, 0.0f);
      _756 = abs(_664 * 0.009999999776482582f);
      _757 = _756 - cb0_space5_000y;
      _760 = _756 / cb0_space5_000y;
      _774 = saturate(_760);
      _778 = (_774 * _774) * (3.0f - (_774 * 2.0f));
      _781 = select((_756 > _711), 1.0f, 0.0f);
      _1001 = (((((_709 - _713) * ((_682 * cb0_space5_000x) + cb0_space5_000y)) + ((_671 - (_697 / (((_698 * (_682 - _681)) / _671) + 1.0f))) * _713)) + ((1.0f - _709) * select(_685, ((exp2(log2(abs(_686)) * cb0_space5_000w) * cb0_space5_000y) + cb0_space5_001x), cb0_space5_001x))) * 100.0f);
      _1002 = (((((_744 - _747) * ((_723 * cb0_space5_000x) + cb0_space5_000y)) + ((_671 - (_697 / (((_698 * (_723 - _681)) / _671) + 1.0f))) * _747)) + ((1.0f - _744) * select(_685, ((exp2(log2(abs(_726)) * cb0_space5_000w) * cb0_space5_000y) + cb0_space5_001x), cb0_space5_001x))) * 100.0f);
      _1003 = (((((_778 - _781) * ((_757 * cb0_space5_000x) + cb0_space5_000y)) + ((_671 - (_697 / (((_698 * (_757 - _681)) / _671) + 1.0f))) * _781)) + ((1.0f - _778) * select(_685, ((exp2(log2(abs(_760)) * cb0_space5_000w) * cb0_space5_000y) + cb0_space5_001x), cb0_space5_001x))) * 100.0f);
      break;
    }
    case 3: {
      _791 = abs(cb0_space5_003w);
      _800 = log2(abs(cb0_space5_002x));
      _803 = cb0_space5_002w * cb0_space5_002z;
      _805 = exp2(_803 * _800);
      _806 = log2(_791);
      _808 = exp2(_806 * cb0_space5_002z);
      _810 = exp2(_803 * _806);
      _812 = (_810 - _805) * cb0_space5_002y;
      _815 = ((_808 * cb0_space5_002y) - exp2(_800 * cb0_space5_002z)) / _812;
      _820 = ((_810 * _805) - ((_805 * cb0_space5_002y) * _808)) / _812;
      _823 = exp2(log2(abs(_662 / _791)) * cb0_space5_002z);
      _835 = exp2(log2(abs(_663 / _791)) * cb0_space5_002z);
      _847 = exp2(log2(abs(_664 / _791)) * cb0_space5_002z);
      _1001 = (cb0_space5_003w * (_823 / (((pow(_823, cb0_space5_002w))*_815) + _820)));
      _1002 = (cb0_space5_003w * (_835 / (((pow(_835, cb0_space5_002w))*_815) + _820)));
      _1003 = (cb0_space5_003w * (_847 / (((pow(_847, cb0_space5_002w))*_815) + _820)));
      break;
    }
    case 4: {
      _1001 = (_662 / ((_662 / cb0_space5_003w) + 1.0f));
      _1002 = (_663 / ((_663 / cb0_space5_003w) + 1.0f));
      _1003 = (_664 / ((_664 / cb0_space5_003w) + 1.0f));
      break;
    }
    case 5: {
      _1001 = _662;
      _1002 = _663;
      _1003 = _664;
      break;
    }
    case 6: {
      _1001 = min(_662, cb0_space5_003w);
      _1002 = min(_663, cb0_space5_003w);
      _1003 = min(_664, cb0_space5_003w);
      break;
    }
    case 1: {
      _873 = abs(_662 * 0.009999999776482582f);
      _875 = cb0_space5_003w * 0.009999999776482582f;
      _885 = ((_875 - cb0_space5_000y) * cb0_space5_000z) / cb0_space5_000x;
      _886 = _873 - cb0_space5_000y;
      _889 = (cb0_space5_000y > 9.999999747378752e-06f);
      _890 = _873 / cb0_space5_000y;
      _901 = _875 - ((_885 * cb0_space5_000x) + cb0_space5_000y);
      _902 = (cb0_space5_000x * _875) / _901;
      _911 = saturate(_890);
      _915 = (_911 * _911) * (3.0f - (_911 * 2.0f));
      _917 = _885 + cb0_space5_000y;
      _919 = select((_873 > _917), 1.0f, 0.0f);
      _928 = abs(_663 * 0.009999999776482582f);
      _929 = _928 - cb0_space5_000y;
      _932 = _928 / cb0_space5_000y;
      _948 = saturate(_932);
      _952 = (_948 * _948) * (3.0f - (_948 * 2.0f));
      _955 = select((_928 > _917), 1.0f, 0.0f);
      _964 = abs(_664 * 0.009999999776482582f);
      _965 = _964 - cb0_space5_000y;
      _968 = _964 / cb0_space5_000y;
      _984 = saturate(_968);
      _988 = (_984 * _984) * (3.0f - (_984 * 2.0f));
      _991 = select((_964 > _917), 1.0f, 0.0f);
      _1001 = (((((_915 - _919) * ((_886 * cb0_space5_000x) + cb0_space5_000y)) + ((_875 - (exp2(((-0.0f - ((_886 - _885) * _902)) / _875) * 1.4426950216293335f) * _901)) * _919)) + ((1.0f - _915) * select(_889, ((exp2(log2(abs(_890)) * cb0_space5_000w) * cb0_space5_000y) + cb0_space5_001x), cb0_space5_001x))) * 100.0f);
      _1002 = (((((_952 - _955) * ((_929 * cb0_space5_000x) + cb0_space5_000y)) + ((_875 - (exp2(((-0.0f - ((_929 - _885) * _902)) / _875) * 1.4426950216293335f) * _901)) * _955)) + ((1.0f - _952) * select(_889, ((exp2(log2(abs(_932)) * cb0_space5_000w) * cb0_space5_000y) + cb0_space5_001x), cb0_space5_001x))) * 100.0f);
      _1003 = (((((_988 - _991) * ((_965 * cb0_space5_000x) + cb0_space5_000y)) + ((_875 - (exp2(((-0.0f - ((_965 - _885) * _902)) / _875) * 1.4426950216293335f) * _901)) * _991)) + ((1.0f - _988) * select(_889, ((exp2(log2(abs(_968)) * cb0_space5_000w) * cb0_space5_000y) + cb0_space5_001x), cb0_space5_001x))) * 100.0f);
      break;
    }
    default: {
      _1001 = 0.0f;
      _1002 = 0.0f;
      _1003 = 0.0f;
      break;
    }
  }
  if (!(cb0_space5_003x == 0)) {
    _1020 = exp2(log2(abs(mad(_1003, -0.005771517753601074f, mad(_1002, -0.020053241401910782f, (_1001 * 1.0258245468139648f))) * 9.999999747378752e-05f)) * 0.1593017578125f);
    _1033 = exp2(log2(abs(mad(_1003, -0.002352168783545494f, mad(_1002, 1.0045864582061768f, (_1001 * -0.0022343560121953487f))) * 9.999999747378752e-05f)) * 0.1593017578125f);
    _1046 = exp2(log2(abs(mad(_1003, 1.0303034782409668f, mad(_1002, -0.02529006451368332f, (_1001 * -0.005013367626816034f))) * 9.999999747378752e-05f)) * 0.1593017578125f);
    _1097 = exp2(log2(((_1020 * 18.8515625f) + 0.8359375f) / ((_1020 * 18.6875f) + 1.0f)) * 78.84375f);
    _1098 = exp2(log2(((_1033 * 18.8515625f) + 0.8359375f) / ((_1033 * 18.6875f) + 1.0f)) * 78.84375f);
    _1099 = exp2(log2(((_1046 * 18.8515625f) + 0.8359375f) / ((_1046 * 18.6875f) + 1.0f)) * 78.84375f);
  } else {
    _1069 = saturate(mad(_1003, -0.08325883746147156f, mad(_1002, -0.6217920184135437f, (_1001 * 1.7050509452819824f))) / cb0_space5_003w);
    _1070 = saturate(mad(_1003, -0.010548345744609833f, mad(_1002, 1.1408041715621948f, (_1001 * -0.13025641441345215f))) / cb0_space5_003w);
    _1071 = saturate(mad(_1003, 1.1529725790023804f, mad(_1002, -0.12896890938282013f, (_1001 * -0.024003375321626663f))) / cb0_space5_003w);
    _1097 = select((_1069 <= 0.0031308000907301903f), (_1069 * 12.920000076293945f), (((pow(_1069, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    _1098 = select((_1070 <= 0.0031308000907301903f), (_1070 * 12.920000076293945f), (((pow(_1070, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    _1099 = select((_1071 <= 0.0031308000907301903f), (_1071 * 12.920000076293945f), (((pow(_1071, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
  }
  u0_space5[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(_1097, _1098, _1099, 1.0f);
}
