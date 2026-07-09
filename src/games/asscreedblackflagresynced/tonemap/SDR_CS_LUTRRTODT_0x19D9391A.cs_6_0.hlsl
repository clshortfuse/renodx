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

struct ColorGradingGenerateRRTODTLUT__Constants {
  TonemapperParams__Constants ColorGradingGenerateRRTODTLUT__Constants_000;
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
};

[numthreads(16, 16, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _20;
  float _21;
  float _22;
  float _359;
  float _360;
  float _361;
  float _455;
  float _456;
  float _457;
  float _27;
  float _29;
  float _39;
  float _40;
  bool _43;
  float _44;
  float _55;
  float _56;
  float _63;
  float _67;
  float _69;
  float _71;
  float _80;
  float _81;
  float _84;
  float _98;
  float _102;
  float _105;
  float _114;
  float _115;
  float _118;
  float _132;
  float _136;
  float _139;
  float _149;
  float _158;
  float _161;
  float _163;
  float _164;
  float _166;
  float _168;
  float _170;
  float _173;
  float _178;
  float _181;
  float _193;
  float _205;
  float _231;
  float _233;
  float _243;
  float _244;
  bool _247;
  float _248;
  float _259;
  float _260;
  float _269;
  float _273;
  float _275;
  float _277;
  float _286;
  float _287;
  float _290;
  float _306;
  float _310;
  float _313;
  float _322;
  float _323;
  float _326;
  float _342;
  float _346;
  float _349;
  float _378;
  float _391;
  float _404;
  float _427;
  float _428;
  float _429;
  _20 = cb0_space5_003z * exp2((((float)((uint)SV_DispatchThreadID.x)) * 0.6451612710952759f) + -12.473931312561035f);
  _21 = cb0_space5_003z * exp2((((float)((uint)SV_DispatchThreadID.y)) * 0.6451612710952759f) + -12.473931312561035f);
  _22 = cb0_space5_003z * exp2((((float)((uint)SV_DispatchThreadID.z)) * 0.6451612710952759f) + -12.473931312561035f);
  switch ((int)(cb0_space5_003y)) {
    case 2: {
      _27 = abs(_20 * 0.009999999776482582f);
      _29 = cb0_space5_003w * 0.009999999776482582f;
      _39 = ((_29 - cb0_space5_000y) * cb0_space5_000z) / cb0_space5_000x;
      _40 = _27 - cb0_space5_000y;
      _43 = (cb0_space5_000y > 9.999999747378752e-06f);
      _44 = _27 / cb0_space5_000y;
      _55 = _29 - ((_39 * cb0_space5_000x) + cb0_space5_000y);
      _56 = (cb0_space5_000x * _29) / _55;
      _63 = saturate(_44);
      _67 = (_63 * _63) * (3.0f - (_63 * 2.0f));
      _69 = _39 + cb0_space5_000y;
      _71 = select((_27 > _69), 1.0f, 0.0f);
      _80 = abs(_21 * 0.009999999776482582f);
      _81 = _80 - cb0_space5_000y;
      _84 = _80 / cb0_space5_000y;
      _98 = saturate(_84);
      _102 = (_98 * _98) * (3.0f - (_98 * 2.0f));
      _105 = select((_80 > _69), 1.0f, 0.0f);
      _114 = abs(_22 * 0.009999999776482582f);
      _115 = _114 - cb0_space5_000y;
      _118 = _114 / cb0_space5_000y;
      _132 = saturate(_118);
      _136 = (_132 * _132) * (3.0f - (_132 * 2.0f));
      _139 = select((_114 > _69), 1.0f, 0.0f);
      _359 = (((((_67 - _71) * ((_40 * cb0_space5_000x) + cb0_space5_000y)) + ((_29 - (_55 / (((_56 * (_40 - _39)) / _29) + 1.0f))) * _71)) + ((1.0f - _67) * select(_43, ((exp2(log2(abs(_44)) * cb0_space5_000w) * cb0_space5_000y) + cb0_space5_001x), cb0_space5_001x))) * 100.0f);
      _360 = (((((_102 - _105) * ((_81 * cb0_space5_000x) + cb0_space5_000y)) + ((_29 - (_55 / (((_56 * (_81 - _39)) / _29) + 1.0f))) * _105)) + ((1.0f - _102) * select(_43, ((exp2(log2(abs(_84)) * cb0_space5_000w) * cb0_space5_000y) + cb0_space5_001x), cb0_space5_001x))) * 100.0f);
      _361 = (((((_136 - _139) * ((_115 * cb0_space5_000x) + cb0_space5_000y)) + ((_29 - (_55 / (((_56 * (_115 - _39)) / _29) + 1.0f))) * _139)) + ((1.0f - _136) * select(_43, ((exp2(log2(abs(_118)) * cb0_space5_000w) * cb0_space5_000y) + cb0_space5_001x), cb0_space5_001x))) * 100.0f);
      break;
    }
    case 3: {
      _149 = abs(cb0_space5_003w);
      _158 = log2(abs(cb0_space5_002x));
      _161 = cb0_space5_002w * cb0_space5_002z;
      _163 = exp2(_161 * _158);
      _164 = log2(_149);
      _166 = exp2(_164 * cb0_space5_002z);
      _168 = exp2(_161 * _164);
      _170 = (_168 - _163) * cb0_space5_002y;
      _173 = ((_166 * cb0_space5_002y) - exp2(_158 * cb0_space5_002z)) / _170;
      _178 = ((_168 * _163) - ((_163 * cb0_space5_002y) * _166)) / _170;
      _181 = exp2(log2(abs(_20 / _149)) * cb0_space5_002z);
      _193 = exp2(log2(abs(_21 / _149)) * cb0_space5_002z);
      _205 = exp2(log2(abs(_22 / _149)) * cb0_space5_002z);
      _359 = (cb0_space5_003w * (_181 / (((pow(_181, cb0_space5_002w))*_173) + _178)));
      _360 = (cb0_space5_003w * (_193 / (((pow(_193, cb0_space5_002w))*_173) + _178)));
      _361 = (cb0_space5_003w * (_205 / (((pow(_205, cb0_space5_002w))*_173) + _178)));
      break;
    }
    case 4: {
      _359 = (_20 / ((_20 / cb0_space5_003w) + 1.0f));
      _360 = (_21 / ((_21 / cb0_space5_003w) + 1.0f));
      _361 = (_22 / ((_22 / cb0_space5_003w) + 1.0f));
      break;
    }
    case 5: {
      _359 = _20;
      _360 = _21;
      _361 = _22;
      break;
    }
    case 6: {
      _359 = min(_20, cb0_space5_003w);
      _360 = min(_21, cb0_space5_003w);
      _361 = min(_22, cb0_space5_003w);
      break;
    }
    case 1: {
      _231 = abs(_20 * 0.009999999776482582f);
      _233 = cb0_space5_003w * 0.009999999776482582f;
      _243 = ((_233 - cb0_space5_000y) * cb0_space5_000z) / cb0_space5_000x;
      _244 = _231 - cb0_space5_000y;
      _247 = (cb0_space5_000y > 9.999999747378752e-06f);
      _248 = _231 / cb0_space5_000y;
      _259 = _233 - ((_243 * cb0_space5_000x) + cb0_space5_000y);
      _260 = (cb0_space5_000x * _233) / _259;
      _269 = saturate(_248);
      _273 = (_269 * _269) * (3.0f - (_269 * 2.0f));
      _275 = _243 + cb0_space5_000y;
      _277 = select((_231 > _275), 1.0f, 0.0f);
      _286 = abs(_21 * 0.009999999776482582f);
      _287 = _286 - cb0_space5_000y;
      _290 = _286 / cb0_space5_000y;
      _306 = saturate(_290);
      _310 = (_306 * _306) * (3.0f - (_306 * 2.0f));
      _313 = select((_286 > _275), 1.0f, 0.0f);
      _322 = abs(_22 * 0.009999999776482582f);
      _323 = _322 - cb0_space5_000y;
      _326 = _322 / cb0_space5_000y;
      _342 = saturate(_326);
      _346 = (_342 * _342) * (3.0f - (_342 * 2.0f));
      _349 = select((_322 > _275), 1.0f, 0.0f);
      _359 = (((((_273 - _277) * ((_244 * cb0_space5_000x) + cb0_space5_000y)) + ((_233 - (exp2(((-0.0f - ((_244 - _243) * _260)) / _233) * 1.4426950216293335f) * _259)) * _277)) + ((1.0f - _273) * select(_247, ((exp2(log2(abs(_248)) * cb0_space5_000w) * cb0_space5_000y) + cb0_space5_001x), cb0_space5_001x))) * 100.0f);
      _360 = (((((_310 - _313) * ((_287 * cb0_space5_000x) + cb0_space5_000y)) + ((_233 - (exp2(((-0.0f - ((_287 - _243) * _260)) / _233) * 1.4426950216293335f) * _259)) * _313)) + ((1.0f - _310) * select(_247, ((exp2(log2(abs(_290)) * cb0_space5_000w) * cb0_space5_000y) + cb0_space5_001x), cb0_space5_001x))) * 100.0f);
      _361 = (((((_346 - _349) * ((_323 * cb0_space5_000x) + cb0_space5_000y)) + ((_233 - (exp2(((-0.0f - ((_323 - _243) * _260)) / _233) * 1.4426950216293335f) * _259)) * _349)) + ((1.0f - _346) * select(_247, ((exp2(log2(abs(_326)) * cb0_space5_000w) * cb0_space5_000y) + cb0_space5_001x), cb0_space5_001x))) * 100.0f);
      break;
    }
    default: {
      _359 = 0.0f;
      _360 = 0.0f;
      _361 = 0.0f;
      break;
    }
  }
  if (!(cb0_space5_003x == 0)) {
    _378 = exp2(log2(abs(mad(_361, -0.005771517753601074f, mad(_360, -0.020053241401910782f, (_359 * 1.0258245468139648f))) * 9.999999747378752e-05f)) * 0.1593017578125f);
    _391 = exp2(log2(abs(mad(_361, -0.002352168783545494f, mad(_360, 1.0045864582061768f, (_359 * -0.0022343560121953487f))) * 9.999999747378752e-05f)) * 0.1593017578125f);
    _404 = exp2(log2(abs(mad(_361, 1.0303034782409668f, mad(_360, -0.02529006451368332f, (_359 * -0.005013367626816034f))) * 9.999999747378752e-05f)) * 0.1593017578125f);
    _455 = exp2(log2(((_378 * 18.8515625f) + 0.8359375f) / ((_378 * 18.6875f) + 1.0f)) * 78.84375f);
    _456 = exp2(log2(((_391 * 18.8515625f) + 0.8359375f) / ((_391 * 18.6875f) + 1.0f)) * 78.84375f);
    _457 = exp2(log2(((_404 * 18.8515625f) + 0.8359375f) / ((_404 * 18.6875f) + 1.0f)) * 78.84375f);
  } else {
    _427 = saturate(mad(_361, -0.08325883746147156f, mad(_360, -0.6217920184135437f, (_359 * 1.7050509452819824f))) / cb0_space5_003w);
    _428 = saturate(mad(_361, -0.010548345744609833f, mad(_360, 1.1408041715621948f, (_359 * -0.13025641441345215f))) / cb0_space5_003w);
    _429 = saturate(mad(_361, 1.1529725790023804f, mad(_360, -0.12896890938282013f, (_359 * -0.024003375321626663f))) / cb0_space5_003w);
    _455 = select((_427 <= 0.0031308000907301903f), (_427 * 12.920000076293945f), (((pow(_427, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    _456 = select((_428 <= 0.0031308000907301903f), (_428 * 12.920000076293945f), (((pow(_428, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
    _457 = select((_429 <= 0.0031308000907301903f), (_429 * 12.920000076293945f), (((pow(_429, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
  }

  u0_space5[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(_455, _456, _457, 1.0f);
}
