#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);

cbuffer cb1 : register(b1) {
  int cb1_018w : packoffset(c018.w);
};

cbuffer cb0 : register(b0) {
  float cb0_000x : packoffset(c000.x);
  float cb0_001x : packoffset(c001.x);
  float cb0_002x : packoffset(c002.x);
  float cb0_003x : packoffset(c003.x);
  float cb0_004x : packoffset(c004.x);
  float cb0_005x : packoffset(c005.x);
  float cb0_006x : packoffset(c006.x);
  float cb0_007x : packoffset(c007.x);
  float cb0_008x : packoffset(c008.x);
  float cb0_009x : packoffset(c009.x);
  float cb0_010x : packoffset(c010.x);
  float cb0_011x : packoffset(c011.x);
  float cb0_012x : packoffset(c012.x);
  float cb0_014x : packoffset(c014.x);
  float cb0_015x : packoffset(c015.x);
  float cb0_016x : packoffset(c016.x);
  float cb0_027x : packoffset(c027.x);
  float cb0_027y : packoffset(c027.y);
  float cb0_027z : packoffset(c027.z);
  float cb0_030y : packoffset(c030.y);
  float cb0_030z : packoffset(c030.z);
  int cb0_030w : packoffset(c030.w);
  float cb0_033x : packoffset(c033.x);
  float cb0_033y : packoffset(c033.y);
  float cb0_033z : packoffset(c033.z);
  float cb0_034x : packoffset(c034.x);
  float cb0_034y : packoffset(c034.y);
  float cb0_034z : packoffset(c034.z);
  float cb0_035x : packoffset(c035.x);
  float cb0_035y : packoffset(c035.y);
  float cb0_035z : packoffset(c035.z);
  float cb0_036x : packoffset(c036.x);
  float cb0_036y : packoffset(c036.y);
  float cb0_036z : packoffset(c036.z);
  float cb0_037x : packoffset(c037.x);
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_038x : packoffset(c038.x);
  float cb0_038y : packoffset(c038.y);
  float cb0_038z : packoffset(c038.z);
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_040x : packoffset(c040.x);
  float cb0_040y : packoffset(c040.y);
  float cb0_040z : packoffset(c040.z);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_042x : packoffset(c042.x);
  float cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
  float cb0_043x : packoffset(c043.x);
  float cb0_043y : packoffset(c043.y);
  float cb0_043z : packoffset(c043.z);
  float cb0_044x : packoffset(c044.x);
  float cb0_044y : packoffset(c044.y);
  float cb0_044z : packoffset(c044.z);
  float cb0_045x : packoffset(c045.x);
  float cb0_045y : packoffset(c045.y);
  float cb0_045z : packoffset(c045.z);
  float cb0_046x : packoffset(c046.x);
  float cb0_046y : packoffset(c046.y);
  float cb0_046z : packoffset(c046.z);
  float cb0_047x : packoffset(c047.x);
  float cb0_047y : packoffset(c047.y);
  float cb0_047z : packoffset(c047.z);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_049x : packoffset(c049.x);
  float cb0_049y : packoffset(c049.y);
  float cb0_050x : packoffset(c050.x);
  float cb0_050y : packoffset(c050.y);
  float cb0_051x : packoffset(c051.x);
  float cb0_051y : packoffset(c051.y);
  float cb0_052x : packoffset(c052.x);
  float cb0_052y : packoffset(c052.y);
  float cb0_053x : packoffset(c053.x);
  float cb0_053y : packoffset(c053.y);
  float cb0_054x : packoffset(c054.x);
  float cb0_054y : packoffset(c054.y);
  float cb0_055x : packoffset(c055.x);
  float cb0_055y : packoffset(c055.y);
  float cb0_056x : packoffset(c056.x);
  float cb0_056y : packoffset(c056.y);
};

SamplerState s2_space2 : register(s2, space2);

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float4 TEXCOORD1_centroid : TEXCOORD1_centroid,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace
) : SV_Target {
  float4 SV_Target;
  bool _13 = (cb0_000x == -1.0f);
  float4 _14 = t0.Sample(s2_space2, float2(TEXCOORD1_centroid.z, TEXCOORD1_centroid.w));
  float _67;
  float _81;
  float _92;
  float _93;
  float _94;
  float _111;
  float _124;
  float _138;
  float _152;
  float _153;
  float _154;
  float _155;
  float _229;
  float _230;
  float _231;
  float _232;
  float _244;
  float _256;
  float _268;
  float _297;
  float _298;
  float _299;
  float _300;
  float _350;
  float _362;
  float _374;
  float _429;
  float _441;
  float _453;
  float _508;
  float _520;
  float _532;
  float _587;
  float _599;
  float _611;
  float _666;
  float _678;
  float _690;
  float _745;
  float _757;
  float _769;
  float _824;
  float _836;
  float _848;
  float _903;
  float _915;
  float _927;
  float _938;
  float _939;
  float _940;
  if (_13) {
    float _20 = _14.x * TEXCOORD0_centroid.x;
    float _21 = _14.y * TEXCOORD0_centroid.y;
    float _22 = _14.z * TEXCOORD0_centroid.z;
    _152 = _20;
    _153 = _21;
    _154 = _22;
    _155 = _14.w;
  } else {
    float _54 = 1.0f - _14.x;
    bool _55 = !(cb0_002x == -1.0f);
    if (_55) {
      bool _57 = !(cb0_004x == 0.0f);
      bool _58 = !(cb0_005x == 0.0f);
      bool _59 = _57 || _58;
      if (_59) {
        float _61 = cb0_004x + TEXCOORD1_centroid.z;
        float _62 = cb0_005x + TEXCOORD1_centroid.w;
        float4 _63 = t0.Sample(s2_space2, float2(_61, _62));
        float _65 = 1.0f - _63.x;
        _67 = _65;
      } else {
        _67 = _54;
      }
      bool _68 = !(_67 >= cb0_002x);
      if (!_68) {
        bool _70 = (_67 < cb0_003x);
        if (_70) {
          float _72 = cb0_003x - cb0_002x;
          float _73 = _67 - cb0_002x;
          float _74 = _73 / _72;
          float _75 = saturate(_74);
          float _76 = _75 * 2.0f;
          float _77 = 3.0f - _76;
          float _78 = _75 * _75;
          float _79 = _78 * _77;
          _81 = _79;
        } else {
          _81 = 1.0f;
        }
        float _82 = cb0_010x - TEXCOORD0_centroid.x;
        float _83 = cb0_011x - TEXCOORD0_centroid.y;
        float _84 = cb0_012x - TEXCOORD0_centroid.z;
        float _85 = _81 * _82;
        float _86 = _81 * _83;
        float _87 = _81 * _84;
        float _88 = _85 + TEXCOORD0_centroid.x;
        float _89 = _86 + TEXCOORD0_centroid.y;
        float _90 = _87 + TEXCOORD0_centroid.z;
        _92 = _88;
        _93 = _89;
        _94 = _90;
      } else {
        _92 = TEXCOORD0_centroid.x;
        _93 = TEXCOORD0_centroid.y;
        _94 = TEXCOORD0_centroid.z;
      }
    } else {
      _92 = TEXCOORD0_centroid.x;
      _93 = TEXCOORD0_centroid.y;
      _94 = TEXCOORD0_centroid.z;
    }
    bool _95 = !(cb0_000x == cb0_001x);
    if (_95) {
      float _97 = cb0_000x - cb0_001x;
      float _98 = _54 - cb0_001x;
      float _99 = _98 / _97;
      float _100 = saturate(_99);
      float _101 = _100 * 2.0f;
      float _102 = 3.0f - _101;
      float _103 = _100 * _100;
      float _104 = _103 * _102;
      _111 = _104;
    } else {
      float _106 = cb0_001x + cb0_000x;
      float _107 = _106 * 0.5f;
      bool _108 = (_54 <= _107);
      float _109 = float((bool)_108);
      _111 = _109;
    }
    bool _112 = !(cb0_006x == -1.0f);
    if (_112) {
      bool _114 = !(cb0_008x == 0.0f);
      bool _115 = !(cb0_009x == 0.0f);
      bool _116 = _114 || _115;
      if (_116) {
        float _118 = cb0_008x + TEXCOORD1_centroid.z;
        float _119 = cb0_009x + TEXCOORD1_centroid.w;
        float4 _120 = t0.Sample(s2_space2, float2(_118, _119));
        float _122 = 1.0f - _120.x;
        _124 = _122;
      } else {
        _124 = _54;
      }
      bool _125 = !(_124 <= cb0_007x);
      if (!_125) {
        bool _127 = (_124 > cb0_006x);
        if (_127) {
          float _129 = cb0_006x - cb0_007x;
          float _130 = _124 - cb0_007x;
          float _131 = _130 / _129;
          float _132 = saturate(_131);
          float _133 = _132 * 2.0f;
          float _134 = 3.0f - _133;
          float _135 = _132 * _132;
          float _136 = _135 * _134;
          _138 = _136;
        } else {
          _138 = 1.0f;
        }
        float _139 = _92 - cb0_014x;
        float _140 = _93 - cb0_015x;
        float _141 = _94 - cb0_016x;
        float _142 = _111 - _138;
        float _143 = _111 * _139;
        float _144 = _111 * _140;
        float _145 = _111 * _141;
        float _146 = _142 * _111;
        float _147 = _143 + cb0_014x;
        float _148 = _144 + cb0_015x;
        float _149 = _145 + cb0_016x;
        float _150 = _146 + _138;
        _152 = _147;
        _153 = _148;
        _154 = _149;
        _155 = _150;
      } else {
        _152 = _92;
        _153 = _93;
        _154 = _94;
        _155 = _111;
      }
    } else {
      _152 = _92;
      _153 = _93;
      _154 = _94;
      _155 = _111;
    }
  }
  float _156 = _155 * TEXCOORD0_centroid.w;
  bool _159 = (cb1_018w == -2);
  if (!_159) {
    bool _163 = (cb0_030z > 0.0f);
    if (_163) {
      if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _166 = cb0_030y * 0.10000000149011612f;
        float _167 = log2(cb0_030z);
        float _168 = _167 + -13.287712097167969f;
        float _169 = _168 * 1.4929734468460083f;
        float _170 = _169 + 18.0f;
        float _171 = exp2(_170);
        float _172 = _171 * 0.18000000715255737f;
        float _173 = abs(_172);
        float _174 = log2(_173);
        float _175 = _174 * 1.5f;
        float _176 = exp2(_175);
        float _177 = _176 * _166;
        float _178 = _177 / cb0_030z;
        float _179 = _178 + -0.07636754959821701f;
        float _180 = _174 * 1.2750000953674316f;
        float _181 = exp2(_180);
        float _182 = _181 * 0.07636754959821701f;
        float _183 = cb0_030y * 0.011232397519052029f;
        float _184 = _183 * _176;
        float _185 = _184 / cb0_030z;
        float _186 = _182 - _185;
        float _187 = _181 + -0.11232396960258484f;
        float _188 = _187 * _166;
        float _189 = _188 / cb0_030z;
        float _190 = _189 * cb0_030z;
        float _191 = abs(_152);
        float _192 = abs(_153);
        float _193 = abs(_154);
        float _194 = log2(_191);
        float _195 = log2(_192);
        float _196 = log2(_193);
        float _197 = _194 * 1.5f;
        float _198 = _195 * 1.5f;
        float _199 = _196 * 1.5f;
        float _200 = exp2(_197);
        float _201 = exp2(_198);
        float _202 = exp2(_199);
        float _203 = _200 * _190;
        float _204 = _201 * _190;
        float _205 = _202 * _190;
        float _206 = _194 * 1.2750000953674316f;
        float _207 = _195 * 1.2750000953674316f;
        float _208 = _196 * 1.2750000953674316f;
        float _209 = exp2(_206);
        float _210 = exp2(_207);
        float _211 = exp2(_208);
        float _212 = _209 * _179;
        float _213 = _210 * _179;
        float _214 = _211 * _179;
        float _215 = _212 + _186;
        float _216 = _213 + _186;
        float _217 = _214 + _186;
        float _218 = _203 / _215;
        float _219 = _204 / _216;
        float _220 = _205 / _217;
        float _221 = _218 * 9.999999747378752e-05f;
        float _222 = _219 * 9.999999747378752e-05f;
        float _223 = _220 * 9.999999747378752e-05f;
        float _224 = 5000.0f / cb0_030y;
        float _225 = _221 * _224;
        float _226 = _222 * _224;
        float _227 = _223 * _224;
        _229 = _225;
        _230 = _226;
        _231 = _227;
      } else {
        float3 tonemapped = renodx::color::bt709::from::AP1(ApplyCustomToneMap(renodx::color::ap1::from::BT709(float3(_152, _153, _154))));
        tonemapped = GameScale(tonemapped);
        _229 = tonemapped.x, _230 = tonemapped.y, _231 = tonemapped.z;
      }
      _232 = 1.0f;
    } else {
      _229 = _152;
      _230 = _153;
      _231 = _154;
      _232 = _156;
    }
    bool _233 = !(_229 >= 0.0030399328097701073f);
    if (!_233) {
      float _235 = abs(_229);
      float _236 = log2(_235);
      float _237 = _236 * 0.4166666567325592f;
      float _238 = exp2(_237);
      float _239 = _238 * 1.0549999475479126f;
      float _240 = _239 + -0.054999999701976776f;
      _244 = _240;
    } else {
      float _242 = _229 * 12.923210144042969f;
      _244 = _242;
    }
    bool _245 = !(_230 >= 0.0030399328097701073f);
    if (!_245) {
      float _247 = abs(_230);
      float _248 = log2(_247);
      float _249 = _248 * 0.4166666567325592f;
      float _250 = exp2(_249);
      float _251 = _250 * 1.0549999475479126f;
      float _252 = _251 + -0.054999999701976776f;
      _256 = _252;
    } else {
      float _254 = _230 * 12.923210144042969f;
      _256 = _254;
    }
    bool _257 = !(_231 >= 0.0030399328097701073f);
    if (!_257) {
      float _259 = abs(_231);
      float _260 = log2(_259);
      float _261 = _260 * 0.4166666567325592f;
      float _262 = exp2(_261);
      float _263 = _262 * 1.0549999475479126f;
      float _264 = _263 + -0.054999999701976776f;
      _268 = _264;
    } else {
      float _266 = _231 * 12.923210144042969f;
      _268 = _266;
    }
    bool _269 = (cb1_018w == -1);
    if (_269) {
      float _275 = abs(_244);
      float _276 = abs(_256);
      float _277 = abs(_268);
      float _278 = log2(_275);
      float _279 = log2(_276);
      float _280 = log2(_277);
      float _281 = _278 * cb0_027z;
      float _282 = _279 * cb0_027z;
      float _283 = _280 * cb0_027z;
      float _284 = exp2(_281);
      float _285 = exp2(_282);
      float _286 = exp2(_283);
      float _287 = _284 * cb0_027y;
      float _288 = _285 * cb0_027y;
      float _289 = _286 * cb0_027y;
      float _290 = _287 + cb0_027x;
      float _291 = _288 + cb0_027x;
      float _292 = _289 + cb0_027x;
      float _293 = saturate(_290);
      float _294 = saturate(_291);
      float _295 = saturate(_292);
      _297 = _293;
      _298 = _294;
      _299 = _295;
      _300 = _232;
    } else {
      _297 = _244;
      _298 = _256;
      _299 = _268;
      _300 = _232;
    }
  } else {
    _297 = _152;
    _298 = _153;
    _299 = _154;
    _300 = _156;
  }
  bool _303 = (cb0_030w == 0);
  if (!_303) {
    bool _308 = (cb0_033x < 0.0f);
    if (!_308) {
      float _315 = dot(float3(_297, _298, _299), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      float _316 = cb0_033x - _297;
      float _317 = cb0_033y - _298;
      float _318 = cb0_033z - _299;
      float _319 = _316 * _316;
      float _320 = _317 * _317;
      float _321 = _319 + _320;
      float _322 = _318 * _318;
      float _323 = _321 + _322;
      float _324 = sqrt(_323);
      float _328 = cb0_049y - cb0_049x;
      float _329 = _324 - cb0_049x;
      float _330 = _329 / _328;
      float _331 = saturate(_330);
      float _332 = _331 * 2.0f;
      float _333 = 3.0f - _332;
      float _334 = _331 * _331;
      float _335 = _334 * _333;
      float _336 = _315 * cb0_041x;
      float _337 = _315 * cb0_041y;
      float _338 = _315 * cb0_041z;
      bool _339 = !(_336 >= 0.0030399328097701073f);
      if (_339) {
        float _341 = _336 * 12.923210144042969f;
        _350 = _341;
      } else {
        float _343 = abs(_336);
        float _344 = log2(_343);
        float _345 = _344 * 0.4166666567325592f;
        float _346 = exp2(_345);
        float _347 = _346 * 1.0549999475479126f;
        float _348 = _347 + -0.054999999701976776f;
        _350 = _348;
      }
      bool _351 = !(_337 >= 0.0030399328097701073f);
      if (_351) {
        float _353 = _337 * 12.923210144042969f;
        _362 = _353;
      } else {
        float _355 = abs(_337);
        float _356 = log2(_355);
        float _357 = _356 * 0.4166666567325592f;
        float _358 = exp2(_357);
        float _359 = _358 * 1.0549999475479126f;
        float _360 = _359 + -0.054999999701976776f;
        _362 = _360;
      }
      bool _363 = !(_338 >= 0.0030399328097701073f);
      if (_363) {
        float _365 = _338 * 12.923210144042969f;
        _374 = _365;
      } else {
        float _367 = abs(_338);
        float _368 = log2(_367);
        float _369 = _368 * 0.4166666567325592f;
        float _370 = exp2(_369);
        float _371 = _370 * 1.0549999475479126f;
        float _372 = _371 + -0.054999999701976776f;
        _374 = _372;
      }
      float _375 = _297 - _350;
      float _376 = _298 - _362;
      float _377 = _299 - _374;
      float _378 = _375 * _335;
      float _379 = _376 * _335;
      float _380 = _377 * _335;
      float _381 = _378 + _350;
      float _382 = _379 + _362;
      float _383 = _380 + _374;
      bool _387 = (cb0_034x < 0.0f);
      if (!_387) {
        float _394 = dot(float3(_381, _382, _383), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
        float _395 = cb0_034x - _381;
        float _396 = cb0_034y - _382;
        float _397 = cb0_034z - _383;
        float _398 = _395 * _395;
        float _399 = _396 * _396;
        float _400 = _398 + _399;
        float _401 = _397 * _397;
        float _402 = _400 + _401;
        float _403 = sqrt(_402);
        float _407 = cb0_050y - cb0_050x;
        float _408 = _403 - cb0_050x;
        float _409 = _408 / _407;
        float _410 = saturate(_409);
        float _411 = _410 * 2.0f;
        float _412 = 3.0f - _411;
        float _413 = _410 * _410;
        float _414 = _413 * _412;
        float _415 = _394 * cb0_042x;
        float _416 = _394 * cb0_042y;
        float _417 = _394 * cb0_042z;
        bool _418 = !(_415 >= 0.0030399328097701073f);
        if (_418) {
          float _420 = _415 * 12.923210144042969f;
          _429 = _420;
        } else {
          float _422 = abs(_415);
          float _423 = log2(_422);
          float _424 = _423 * 0.4166666567325592f;
          float _425 = exp2(_424);
          float _426 = _425 * 1.0549999475479126f;
          float _427 = _426 + -0.054999999701976776f;
          _429 = _427;
        }
        bool _430 = !(_416 >= 0.0030399328097701073f);
        if (_430) {
          float _432 = _416 * 12.923210144042969f;
          _441 = _432;
        } else {
          float _434 = abs(_416);
          float _435 = log2(_434);
          float _436 = _435 * 0.4166666567325592f;
          float _437 = exp2(_436);
          float _438 = _437 * 1.0549999475479126f;
          float _439 = _438 + -0.054999999701976776f;
          _441 = _439;
        }
        bool _442 = !(_417 >= 0.0030399328097701073f);
        if (_442) {
          float _444 = _417 * 12.923210144042969f;
          _453 = _444;
        } else {
          float _446 = abs(_417);
          float _447 = log2(_446);
          float _448 = _447 * 0.4166666567325592f;
          float _449 = exp2(_448);
          float _450 = _449 * 1.0549999475479126f;
          float _451 = _450 + -0.054999999701976776f;
          _453 = _451;
        }
        float _454 = _381 - _429;
        float _455 = _382 - _441;
        float _456 = _383 - _453;
        float _457 = _454 * _414;
        float _458 = _455 * _414;
        float _459 = _456 * _414;
        float _460 = _457 + _429;
        float _461 = _458 + _441;
        float _462 = _459 + _453;
        bool _466 = (cb0_035x < 0.0f);
        if (!_466) {
          float _473 = dot(float3(_460, _461, _462), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
          float _474 = cb0_035x - _460;
          float _475 = cb0_035y - _461;
          float _476 = cb0_035z - _462;
          float _477 = _474 * _474;
          float _478 = _475 * _475;
          float _479 = _477 + _478;
          float _480 = _476 * _476;
          float _481 = _479 + _480;
          float _482 = sqrt(_481);
          float _486 = cb0_051y - cb0_051x;
          float _487 = _482 - cb0_051x;
          float _488 = _487 / _486;
          float _489 = saturate(_488);
          float _490 = _489 * 2.0f;
          float _491 = 3.0f - _490;
          float _492 = _489 * _489;
          float _493 = _492 * _491;
          float _494 = _473 * cb0_043x;
          float _495 = _473 * cb0_043y;
          float _496 = _473 * cb0_043z;
          bool _497 = !(_494 >= 0.0030399328097701073f);
          if (_497) {
            float _499 = _494 * 12.923210144042969f;
            _508 = _499;
          } else {
            float _501 = abs(_494);
            float _502 = log2(_501);
            float _503 = _502 * 0.4166666567325592f;
            float _504 = exp2(_503);
            float _505 = _504 * 1.0549999475479126f;
            float _506 = _505 + -0.054999999701976776f;
            _508 = _506;
          }
          bool _509 = !(_495 >= 0.0030399328097701073f);
          if (_509) {
            float _511 = _495 * 12.923210144042969f;
            _520 = _511;
          } else {
            float _513 = abs(_495);
            float _514 = log2(_513);
            float _515 = _514 * 0.4166666567325592f;
            float _516 = exp2(_515);
            float _517 = _516 * 1.0549999475479126f;
            float _518 = _517 + -0.054999999701976776f;
            _520 = _518;
          }
          bool _521 = !(_496 >= 0.0030399328097701073f);
          if (_521) {
            float _523 = _496 * 12.923210144042969f;
            _532 = _523;
          } else {
            float _525 = abs(_496);
            float _526 = log2(_525);
            float _527 = _526 * 0.4166666567325592f;
            float _528 = exp2(_527);
            float _529 = _528 * 1.0549999475479126f;
            float _530 = _529 + -0.054999999701976776f;
            _532 = _530;
          }
          float _533 = _460 - _508;
          float _534 = _461 - _520;
          float _535 = _462 - _532;
          float _536 = _533 * _493;
          float _537 = _534 * _493;
          float _538 = _535 * _493;
          float _539 = _536 + _508;
          float _540 = _537 + _520;
          float _541 = _538 + _532;
          bool _545 = (cb0_036x < 0.0f);
          if (!_545) {
            float _552 = dot(float3(_539, _540, _541), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
            float _553 = cb0_036x - _539;
            float _554 = cb0_036y - _540;
            float _555 = cb0_036z - _541;
            float _556 = _553 * _553;
            float _557 = _554 * _554;
            float _558 = _556 + _557;
            float _559 = _555 * _555;
            float _560 = _558 + _559;
            float _561 = sqrt(_560);
            float _565 = cb0_052y - cb0_052x;
            float _566 = _561 - cb0_052x;
            float _567 = _566 / _565;
            float _568 = saturate(_567);
            float _569 = _568 * 2.0f;
            float _570 = 3.0f - _569;
            float _571 = _568 * _568;
            float _572 = _571 * _570;
            float _573 = _552 * cb0_044x;
            float _574 = _552 * cb0_044y;
            float _575 = _552 * cb0_044z;
            bool _576 = !(_573 >= 0.0030399328097701073f);
            if (_576) {
              float _578 = _573 * 12.923210144042969f;
              _587 = _578;
            } else {
              float _580 = abs(_573);
              float _581 = log2(_580);
              float _582 = _581 * 0.4166666567325592f;
              float _583 = exp2(_582);
              float _584 = _583 * 1.0549999475479126f;
              float _585 = _584 + -0.054999999701976776f;
              _587 = _585;
            }
            bool _588 = !(_574 >= 0.0030399328097701073f);
            if (_588) {
              float _590 = _574 * 12.923210144042969f;
              _599 = _590;
            } else {
              float _592 = abs(_574);
              float _593 = log2(_592);
              float _594 = _593 * 0.4166666567325592f;
              float _595 = exp2(_594);
              float _596 = _595 * 1.0549999475479126f;
              float _597 = _596 + -0.054999999701976776f;
              _599 = _597;
            }
            bool _600 = !(_575 >= 0.0030399328097701073f);
            if (_600) {
              float _602 = _575 * 12.923210144042969f;
              _611 = _602;
            } else {
              float _604 = abs(_575);
              float _605 = log2(_604);
              float _606 = _605 * 0.4166666567325592f;
              float _607 = exp2(_606);
              float _608 = _607 * 1.0549999475479126f;
              float _609 = _608 + -0.054999999701976776f;
              _611 = _609;
            }
            float _612 = _539 - _587;
            float _613 = _540 - _599;
            float _614 = _541 - _611;
            float _615 = _612 * _572;
            float _616 = _613 * _572;
            float _617 = _614 * _572;
            float _618 = _615 + _587;
            float _619 = _616 + _599;
            float _620 = _617 + _611;
            bool _624 = (cb0_037x < 0.0f);
            if (!_624) {
              float _631 = dot(float3(_618, _619, _620), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
              float _632 = cb0_037x - _618;
              float _633 = cb0_037y - _619;
              float _634 = cb0_037z - _620;
              float _635 = _632 * _632;
              float _636 = _633 * _633;
              float _637 = _635 + _636;
              float _638 = _634 * _634;
              float _639 = _637 + _638;
              float _640 = sqrt(_639);
              float _644 = cb0_053y - cb0_053x;
              float _645 = _640 - cb0_053x;
              float _646 = _645 / _644;
              float _647 = saturate(_646);
              float _648 = _647 * 2.0f;
              float _649 = 3.0f - _648;
              float _650 = _647 * _647;
              float _651 = _650 * _649;
              float _652 = _631 * cb0_045x;
              float _653 = _631 * cb0_045y;
              float _654 = _631 * cb0_045z;
              bool _655 = !(_652 >= 0.0030399328097701073f);
              if (_655) {
                float _657 = _652 * 12.923210144042969f;
                _666 = _657;
              } else {
                float _659 = abs(_652);
                float _660 = log2(_659);
                float _661 = _660 * 0.4166666567325592f;
                float _662 = exp2(_661);
                float _663 = _662 * 1.0549999475479126f;
                float _664 = _663 + -0.054999999701976776f;
                _666 = _664;
              }
              bool _667 = !(_653 >= 0.0030399328097701073f);
              if (_667) {
                float _669 = _653 * 12.923210144042969f;
                _678 = _669;
              } else {
                float _671 = abs(_653);
                float _672 = log2(_671);
                float _673 = _672 * 0.4166666567325592f;
                float _674 = exp2(_673);
                float _675 = _674 * 1.0549999475479126f;
                float _676 = _675 + -0.054999999701976776f;
                _678 = _676;
              }
              bool _679 = !(_654 >= 0.0030399328097701073f);
              if (_679) {
                float _681 = _654 * 12.923210144042969f;
                _690 = _681;
              } else {
                float _683 = abs(_654);
                float _684 = log2(_683);
                float _685 = _684 * 0.4166666567325592f;
                float _686 = exp2(_685);
                float _687 = _686 * 1.0549999475479126f;
                float _688 = _687 + -0.054999999701976776f;
                _690 = _688;
              }
              float _691 = _618 - _666;
              float _692 = _619 - _678;
              float _693 = _620 - _690;
              float _694 = _691 * _651;
              float _695 = _692 * _651;
              float _696 = _693 * _651;
              float _697 = _694 + _666;
              float _698 = _695 + _678;
              float _699 = _696 + _690;
              bool _703 = (cb0_038x < 0.0f);
              if (!_703) {
                float _710 = dot(float3(_697, _698, _699), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                float _711 = cb0_038x - _697;
                float _712 = cb0_038y - _698;
                float _713 = cb0_038z - _699;
                float _714 = _711 * _711;
                float _715 = _712 * _712;
                float _716 = _714 + _715;
                float _717 = _713 * _713;
                float _718 = _716 + _717;
                float _719 = sqrt(_718);
                float _723 = cb0_054y - cb0_054x;
                float _724 = _719 - cb0_054x;
                float _725 = _724 / _723;
                float _726 = saturate(_725);
                float _727 = _726 * 2.0f;
                float _728 = 3.0f - _727;
                float _729 = _726 * _726;
                float _730 = _729 * _728;
                float _731 = _710 * cb0_046x;
                float _732 = _710 * cb0_046y;
                float _733 = _710 * cb0_046z;
                bool _734 = !(_731 >= 0.0030399328097701073f);
                if (_734) {
                  float _736 = _731 * 12.923210144042969f;
                  _745 = _736;
                } else {
                  float _738 = abs(_731);
                  float _739 = log2(_738);
                  float _740 = _739 * 0.4166666567325592f;
                  float _741 = exp2(_740);
                  float _742 = _741 * 1.0549999475479126f;
                  float _743 = _742 + -0.054999999701976776f;
                  _745 = _743;
                }
                bool _746 = !(_732 >= 0.0030399328097701073f);
                if (_746) {
                  float _748 = _732 * 12.923210144042969f;
                  _757 = _748;
                } else {
                  float _750 = abs(_732);
                  float _751 = log2(_750);
                  float _752 = _751 * 0.4166666567325592f;
                  float _753 = exp2(_752);
                  float _754 = _753 * 1.0549999475479126f;
                  float _755 = _754 + -0.054999999701976776f;
                  _757 = _755;
                }
                bool _758 = !(_733 >= 0.0030399328097701073f);
                if (_758) {
                  float _760 = _733 * 12.923210144042969f;
                  _769 = _760;
                } else {
                  float _762 = abs(_733);
                  float _763 = log2(_762);
                  float _764 = _763 * 0.4166666567325592f;
                  float _765 = exp2(_764);
                  float _766 = _765 * 1.0549999475479126f;
                  float _767 = _766 + -0.054999999701976776f;
                  _769 = _767;
                }
                float _770 = _697 - _745;
                float _771 = _698 - _757;
                float _772 = _699 - _769;
                float _773 = _770 * _730;
                float _774 = _771 * _730;
                float _775 = _772 * _730;
                float _776 = _773 + _745;
                float _777 = _774 + _757;
                float _778 = _775 + _769;
                bool _782 = (cb0_039x < 0.0f);
                if (!_782) {
                  float _789 = dot(float3(_776, _777, _778), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                  float _790 = cb0_039x - _776;
                  float _791 = cb0_039y - _777;
                  float _792 = cb0_039z - _778;
                  float _793 = _790 * _790;
                  float _794 = _791 * _791;
                  float _795 = _793 + _794;
                  float _796 = _792 * _792;
                  float _797 = _795 + _796;
                  float _798 = sqrt(_797);
                  float _802 = cb0_055y - cb0_055x;
                  float _803 = _798 - cb0_055x;
                  float _804 = _803 / _802;
                  float _805 = saturate(_804);
                  float _806 = _805 * 2.0f;
                  float _807 = 3.0f - _806;
                  float _808 = _805 * _805;
                  float _809 = _808 * _807;
                  float _810 = _789 * cb0_047x;
                  float _811 = _789 * cb0_047y;
                  float _812 = _789 * cb0_047z;
                  bool _813 = !(_810 >= 0.0030399328097701073f);
                  if (_813) {
                    float _815 = _810 * 12.923210144042969f;
                    _824 = _815;
                  } else {
                    float _817 = abs(_810);
                    float _818 = log2(_817);
                    float _819 = _818 * 0.4166666567325592f;
                    float _820 = exp2(_819);
                    float _821 = _820 * 1.0549999475479126f;
                    float _822 = _821 + -0.054999999701976776f;
                    _824 = _822;
                  }
                  bool _825 = !(_811 >= 0.0030399328097701073f);
                  if (_825) {
                    float _827 = _811 * 12.923210144042969f;
                    _836 = _827;
                  } else {
                    float _829 = abs(_811);
                    float _830 = log2(_829);
                    float _831 = _830 * 0.4166666567325592f;
                    float _832 = exp2(_831);
                    float _833 = _832 * 1.0549999475479126f;
                    float _834 = _833 + -0.054999999701976776f;
                    _836 = _834;
                  }
                  bool _837 = !(_812 >= 0.0030399328097701073f);
                  if (_837) {
                    float _839 = _812 * 12.923210144042969f;
                    _848 = _839;
                  } else {
                    float _841 = abs(_812);
                    float _842 = log2(_841);
                    float _843 = _842 * 0.4166666567325592f;
                    float _844 = exp2(_843);
                    float _845 = _844 * 1.0549999475479126f;
                    float _846 = _845 + -0.054999999701976776f;
                    _848 = _846;
                  }
                  float _849 = _776 - _824;
                  float _850 = _777 - _836;
                  float _851 = _778 - _848;
                  float _852 = _849 * _809;
                  float _853 = _850 * _809;
                  float _854 = _851 * _809;
                  float _855 = _852 + _824;
                  float _856 = _853 + _836;
                  float _857 = _854 + _848;
                  bool _861 = (cb0_040x < 0.0f);
                  if (!_861) {
                    float _868 = dot(float3(_855, _856, _857), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                    float _869 = cb0_040x - _855;
                    float _870 = cb0_040y - _856;
                    float _871 = cb0_040z - _857;
                    float _872 = _869 * _869;
                    float _873 = _870 * _870;
                    float _874 = _872 + _873;
                    float _875 = _871 * _871;
                    float _876 = _874 + _875;
                    float _877 = sqrt(_876);
                    float _881 = cb0_056y - cb0_056x;
                    float _882 = _877 - cb0_056x;
                    float _883 = _882 / _881;
                    float _884 = saturate(_883);
                    float _885 = _884 * 2.0f;
                    float _886 = 3.0f - _885;
                    float _887 = _884 * _884;
                    float _888 = _887 * _886;
                    float _889 = _868 * cb0_048x;
                    float _890 = _868 * cb0_048y;
                    float _891 = _868 * cb0_048z;
                    bool _892 = !(_889 >= 0.0030399328097701073f);
                    if (_892) {
                      float _894 = _889 * 12.923210144042969f;
                      _903 = _894;
                    } else {
                      float _896 = abs(_889);
                      float _897 = log2(_896);
                      float _898 = _897 * 0.4166666567325592f;
                      float _899 = exp2(_898);
                      float _900 = _899 * 1.0549999475479126f;
                      float _901 = _900 + -0.054999999701976776f;
                      _903 = _901;
                    }
                    bool _904 = !(_890 >= 0.0030399328097701073f);
                    if (_904) {
                      float _906 = _890 * 12.923210144042969f;
                      _915 = _906;
                    } else {
                      float _908 = abs(_890);
                      float _909 = log2(_908);
                      float _910 = _909 * 0.4166666567325592f;
                      float _911 = exp2(_910);
                      float _912 = _911 * 1.0549999475479126f;
                      float _913 = _912 + -0.054999999701976776f;
                      _915 = _913;
                    }
                    bool _916 = !(_891 >= 0.0030399328097701073f);
                    if (_916) {
                      float _918 = _891 * 12.923210144042969f;
                      _927 = _918;
                    } else {
                      float _920 = abs(_891);
                      float _921 = log2(_920);
                      float _922 = _921 * 0.4166666567325592f;
                      float _923 = exp2(_922);
                      float _924 = _923 * 1.0549999475479126f;
                      float _925 = _924 + -0.054999999701976776f;
                      _927 = _925;
                    }
                    float _928 = _855 - _903;
                    float _929 = _856 - _915;
                    float _930 = _857 - _927;
                    float _931 = _928 * _888;
                    float _932 = _929 * _888;
                    float _933 = _930 * _888;
                    float _934 = _931 + _903;
                    float _935 = _932 + _915;
                    float _936 = _933 + _927;
                    _938 = _934;
                    _939 = _935;
                    _940 = _936;
                  } else {
                    _938 = _855;
                    _939 = _856;
                    _940 = _857;
                  }
                } else {
                  _938 = _776;
                  _939 = _777;
                  _940 = _778;
                }
              } else {
                _938 = _697;
                _939 = _698;
                _940 = _699;
              }
            } else {
              _938 = _618;
              _939 = _619;
              _940 = _620;
            }
          } else {
            _938 = _539;
            _939 = _540;
            _940 = _541;
          }
        } else {
          _938 = _460;
          _939 = _461;
          _940 = _462;
        }
      } else {
        _938 = _381;
        _939 = _382;
        _940 = _383;
      }
    } else {
      _938 = _297;
      _939 = _298;
      _940 = _299;
    }
  } else {
    _938 = _297;
    _939 = _298;
    _940 = _299;
  }
  SV_Target.x = _938;
  SV_Target.y = _939;
  SV_Target.z = _940;
  SV_Target.w = _300;

  SV_Target.rgb = UIScale(SV_Target.rgb);

  return SV_Target;
}
