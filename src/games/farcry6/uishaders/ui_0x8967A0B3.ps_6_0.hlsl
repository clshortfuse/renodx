#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

cbuffer cb1 : register(b1) {
  int cb1_018w : packoffset(c018.w);
};

cbuffer cb0 : register(b0) {
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
  linear float2 TEXCOORD2_centroid : TEXCOORD2_centroid,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace
) : SV_Target {
  float4 SV_Target;
  float4 _15 = t0.Sample(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y));
  float4 _17 = t1.Sample(s2_space2, float2(TEXCOORD0_centroid.z, TEXCOORD0_centroid.w));
  float4 _19 = t2.Sample(s2_space2, float2(TEXCOORD0_centroid.z, TEXCOORD0_centroid.w));
  float _21 = _17.x * 1.4019999504089355f;
  float _22 = _17.x * 0.714139997959137f;
  float _23 = _15.x - _22;
  float _24 = _19.x * 0.3441399931907654f;
  float _25 = _19.x * 1.7719999551773071f;
  float _26 = _23 - _24;
  float _27 = _15.x + -0.7009999752044678f;
  float _28 = _27 + _21;
  float _29 = _26 + 0.5291399955749512f;
  float _30 = _15.x + -0.8859999775886536f;
  float _31 = _30 + _25;
  bool _32 = (_28 <= 0.040449999272823334f);
  bool _33 = (_29 <= 0.040449999272823334f);
  bool _34 = (_31 <= 0.040449999272823334f);
  float _35 = _28 * 0.07739938050508499f;
  float _36 = _29 * 0.07739938050508499f;
  float _37 = _31 * 0.07739938050508499f;
  float _38 = abs(_28);
  float _39 = abs(_29);
  float _40 = abs(_31);
  float _41 = _38 + 0.054999999701976776f;
  float _42 = _39 + 0.054999999701976776f;
  float _43 = _40 + 0.054999999701976776f;
  float _44 = _41 * 0.9478673338890076f;
  float _45 = _42 * 0.9478673338890076f;
  float _46 = _43 * 0.9478673338890076f;
  float _47 = log2(_44);
  float _48 = log2(_45);
  float _49 = log2(_46);
  float _50 = _47 * 2.4000000953674316f;
  float _51 = _48 * 2.4000000953674316f;
  float _52 = _49 * 2.4000000953674316f;
  float _53 = exp2(_50);
  float _54 = exp2(_51);
  float _55 = exp2(_52);
  float _56 = select(_32, _35, _53);
  float _57 = select(_33, _36, _54);
  float _58 = select(_34, _37, _55);
  float _59 = _56 * TEXCOORD1_centroid.x;
  float _60 = _57 * TEXCOORD1_centroid.y;
  float _61 = _58 * TEXCOORD1_centroid.z;
  float _62 = TEXCOORD1_centroid.w * TEXCOORD1_centroid.w;
  bool _65 = (cb1_018w == -1);
  float _71;
  float _72;
  float _73;
  float _144;
  float _145;
  float _146;
  float _147;
  float _159;
  float _171;
  float _183;
  float _211;
  float _212;
  float _213;
  float _214;
  float _264;
  float _276;
  float _288;
  float _343;
  float _355;
  float _367;
  float _422;
  float _434;
  float _446;
  float _501;
  float _513;
  float _525;
  float _580;
  float _592;
  float _604;
  float _659;
  float _671;
  float _683;
  float _738;
  float _750;
  float _762;
  float _817;
  float _829;
  float _841;
  float _852;
  float _853;
  float _854;
  if (_65) {
    float _67 = saturate(_59);
    float _68 = saturate(_60);
    float _69 = saturate(_61);
    _71 = _67;
    _72 = _68;
    _73 = _69;
  } else {
    _71 = _59;
    _72 = _60;
    _73 = _61;
  }
  bool _74 = (cb1_018w == -2);
  if (!_74) {
    bool _78 = (cb0_030z > 0.0f);
    if (_78) {
      if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _81 = cb0_030y * 0.10000000149011612f;
        float _82 = log2(cb0_030z);
        float _83 = _82 + -13.287712097167969f;
        float _84 = _83 * 1.4929734468460083f;
        float _85 = _84 + 18.0f;
        float _86 = exp2(_85);
        float _87 = _86 * 0.18000000715255737f;
        float _88 = abs(_87);
        float _89 = log2(_88);
        float _90 = _89 * 1.5f;
        float _91 = exp2(_90);
        float _92 = _91 * _81;
        float _93 = _92 / cb0_030z;
        float _94 = _93 + -0.07636754959821701f;
        float _95 = _89 * 1.2750000953674316f;
        float _96 = exp2(_95);
        float _97 = _96 * 0.07636754959821701f;
        float _98 = cb0_030y * 0.011232397519052029f;
        float _99 = _98 * _91;
        float _100 = _99 / cb0_030z;
        float _101 = _97 - _100;
        float _102 = _96 + -0.11232396960258484f;
        float _103 = _102 * _81;
        float _104 = _103 / cb0_030z;
        float _105 = _104 * cb0_030z;
        float _106 = abs(_71);
        float _107 = abs(_72);
        float _108 = abs(_73);
        float _109 = log2(_106);
        float _110 = log2(_107);
        float _111 = log2(_108);
        float _112 = _109 * 1.5f;
        float _113 = _110 * 1.5f;
        float _114 = _111 * 1.5f;
        float _115 = exp2(_112);
        float _116 = exp2(_113);
        float _117 = exp2(_114);
        float _118 = _115 * _105;
        float _119 = _116 * _105;
        float _120 = _117 * _105;
        float _121 = _109 * 1.2750000953674316f;
        float _122 = _110 * 1.2750000953674316f;
        float _123 = _111 * 1.2750000953674316f;
        float _124 = exp2(_121);
        float _125 = exp2(_122);
        float _126 = exp2(_123);
        float _127 = _124 * _94;
        float _128 = _125 * _94;
        float _129 = _126 * _94;
        float _130 = _127 + _101;
        float _131 = _128 + _101;
        float _132 = _129 + _101;
        float _133 = _118 / _130;
        float _134 = _119 / _131;
        float _135 = _120 / _132;
        float _136 = _133 * 9.999999747378752e-05f;
        float _137 = _134 * 9.999999747378752e-05f;
        float _138 = _135 * 9.999999747378752e-05f;
        float _139 = 5000.0f / cb0_030y;
        float _140 = _136 * _139;
        float _141 = _137 * _139;
        float _142 = _138 * _139;
        _144 = _140;
        _145 = _141;
        _146 = _142;
      } else {
        float3 tonemapped = renodx::color::bt709::from::AP1(ApplyCustomToneMap(renodx::color::ap1::from::BT709(float3(_71, _72, _73))));
        tonemapped = GameScale(tonemapped);
        _144 = tonemapped.x, _145 = tonemapped.y, _146 = tonemapped.z;
      }
      _147 = 1.0f;
    } else {
      _144 = _71;
      _145 = _72;
      _146 = _73;
      _147 = _62;
    }
    // bool _148 = !(_144 >= 0.0030399328097701073f);
    // if (!_148) {
    //   float _150 = abs(_144);
    //   float _151 = log2(_150);
    //   float _152 = _151 * 0.4166666567325592f;
    //   float _153 = exp2(_152);
    //   float _154 = _153 * 1.0549999475479126f;
    //   float _155 = _154 + -0.054999999701976776f;
    //   _159 = _155;
    // } else {
    //   float _157 = _144 * 12.923210144042969f;
    //   _159 = _157;
    // }
    // bool _160 = !(_145 >= 0.0030399328097701073f);
    // if (!_160) {
    //   float _162 = abs(_145);
    //   float _163 = log2(_162);
    //   float _164 = _163 * 0.4166666567325592f;
    //   float _165 = exp2(_164);
    //   float _166 = _165 * 1.0549999475479126f;
    //   float _167 = _166 + -0.054999999701976776f;
    //   _171 = _167;
    // } else {
    //   float _169 = _145 * 12.923210144042969f;
    //   _171 = _169;
    // }
    // bool _172 = !(_146 >= 0.0030399328097701073f);
    // if (!_172) {
    //   float _174 = abs(_146);
    //   float _175 = log2(_174);
    //   float _176 = _175 * 0.4166666567325592f;
    //   float _177 = exp2(_176);
    //   float _178 = _177 * 1.0549999475479126f;
    //   float _179 = _178 + -0.054999999701976776f;
    //   _183 = _179;
    // } else {
    //   float _181 = _146 * 12.923210144042969f;
    //   _183 = _181;
    // }
    _159 = renodx::color::srgb::EncodeSafe(_144);
    _171 = renodx::color::srgb::EncodeSafe(_145);
    _183 = renodx::color::srgb::EncodeSafe(_146);

    if (_65) {
      float _189 = abs(_159);
      float _190 = abs(_171);
      float _191 = abs(_183);
      float _192 = log2(_189);
      float _193 = log2(_190);
      float _194 = log2(_191);
      float _195 = _192 * cb0_027z;
      float _196 = _193 * cb0_027z;
      float _197 = _194 * cb0_027z;
      float _198 = exp2(_195);
      float _199 = exp2(_196);
      float _200 = exp2(_197);
      float _201 = _198 * cb0_027y;
      float _202 = _199 * cb0_027y;
      float _203 = _200 * cb0_027y;
      float _204 = _201 + cb0_027x;
      float _205 = _202 + cb0_027x;
      float _206 = _203 + cb0_027x;
      float _207 = saturate(_204);
      float _208 = saturate(_205);
      float _209 = saturate(_206);
      _211 = _207;
      _212 = _208;
      _213 = _209;
      _214 = _147;
    } else {
      _211 = _159;
      _212 = _171;
      _213 = _183;
      _214 = _147;
    }
  } else {
    _211 = _71;
    _212 = _72;
    _213 = _73;
    _214 = _62;
  }
  bool _217 = (cb0_030w == 0);
  if (!_217) {
    bool _222 = (cb0_033x < 0.0f);
    if (!_222) {
      float _229 = dot(float3(_211, _212, _213), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      float _230 = cb0_033x - _211;
      float _231 = cb0_033y - _212;
      float _232 = cb0_033z - _213;
      float _233 = _230 * _230;
      float _234 = _231 * _231;
      float _235 = _233 + _234;
      float _236 = _232 * _232;
      float _237 = _235 + _236;
      float _238 = sqrt(_237);
      float _242 = cb0_049y - cb0_049x;
      float _243 = _238 - cb0_049x;
      float _244 = _243 / _242;
      float _245 = saturate(_244);
      float _246 = _245 * 2.0f;
      float _247 = 3.0f - _246;
      float _248 = _245 * _245;
      float _249 = _248 * _247;
      float _250 = _229 * cb0_041x;
      float _251 = _229 * cb0_041y;
      float _252 = _229 * cb0_041z;
      // bool _253 = !(_250 >= 0.0030399328097701073f);
      // if (_253) {
      //   float _255 = _250 * 12.923210144042969f;
      //   _264 = _255;
      // } else {
      //   float _257 = abs(_250);
      //   float _258 = log2(_257);
      //   float _259 = _258 * 0.4166666567325592f;
      //   float _260 = exp2(_259);
      //   float _261 = _260 * 1.0549999475479126f;
      //   float _262 = _261 + -0.054999999701976776f;
      //   _264 = _262;
      // }
      // bool _265 = !(_251 >= 0.0030399328097701073f);
      // if (_265) {
      //   float _267 = _251 * 12.923210144042969f;
      //   _276 = _267;
      // } else {
      //   float _269 = abs(_251);
      //   float _270 = log2(_269);
      //   float _271 = _270 * 0.4166666567325592f;
      //   float _272 = exp2(_271);
      //   float _273 = _272 * 1.0549999475479126f;
      //   float _274 = _273 + -0.054999999701976776f;
      //   _276 = _274;
      // }
      // bool _277 = !(_252 >= 0.0030399328097701073f);
      // if (_277) {
      //   float _279 = _252 * 12.923210144042969f;
      //   _288 = _279;
      // } else {
      //   float _281 = abs(_252);
      //   float _282 = log2(_281);
      //   float _283 = _282 * 0.4166666567325592f;
      //   float _284 = exp2(_283);
      //   float _285 = _284 * 1.0549999475479126f;
      //   float _286 = _285 + -0.054999999701976776f;
      //   _288 = _286;
      // }
      _264 = renodx::color::srgb::EncodeSafe(_250);
      _276 = renodx::color::srgb::EncodeSafe(_251);
      _288 = renodx::color::srgb::EncodeSafe(_252);

      float _289 = _211 - _264;
      float _290 = _212 - _276;
      float _291 = _213 - _288;
      float _292 = _289 * _249;
      float _293 = _290 * _249;
      float _294 = _291 * _249;
      float _295 = _292 + _264;
      float _296 = _293 + _276;
      float _297 = _294 + _288;
      bool _301 = (cb0_034x < 0.0f);
      if (!_301) {
        float _308 = dot(float3(_295, _296, _297), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
        float _309 = cb0_034x - _295;
        float _310 = cb0_034y - _296;
        float _311 = cb0_034z - _297;
        float _312 = _309 * _309;
        float _313 = _310 * _310;
        float _314 = _312 + _313;
        float _315 = _311 * _311;
        float _316 = _314 + _315;
        float _317 = sqrt(_316);
        float _321 = cb0_050y - cb0_050x;
        float _322 = _317 - cb0_050x;
        float _323 = _322 / _321;
        float _324 = saturate(_323);
        float _325 = _324 * 2.0f;
        float _326 = 3.0f - _325;
        float _327 = _324 * _324;
        float _328 = _327 * _326;
        float _329 = _308 * cb0_042x;
        float _330 = _308 * cb0_042y;
        float _331 = _308 * cb0_042z;
        // bool _332 = !(_329 >= 0.0030399328097701073f);
        // if (_332) {
        //   float _334 = _329 * 12.923210144042969f;
        //   _343 = _334;
        // } else {
        //   float _336 = abs(_329);
        //   float _337 = log2(_336);
        //   float _338 = _337 * 0.4166666567325592f;
        //   float _339 = exp2(_338);
        //   float _340 = _339 * 1.0549999475479126f;
        //   float _341 = _340 + -0.054999999701976776f;
        //   _343 = _341;
        // }
        // bool _344 = !(_330 >= 0.0030399328097701073f);
        // if (_344) {
        //   float _346 = _330 * 12.923210144042969f;
        //   _355 = _346;
        // } else {
        //   float _348 = abs(_330);
        //   float _349 = log2(_348);
        //   float _350 = _349 * 0.4166666567325592f;
        //   float _351 = exp2(_350);
        //   float _352 = _351 * 1.0549999475479126f;
        //   float _353 = _352 + -0.054999999701976776f;
        //   _355 = _353;
        // }
        // bool _356 = !(_331 >= 0.0030399328097701073f);
        // if (_356) {
        //   float _358 = _331 * 12.923210144042969f;
        //   _367 = _358;
        // } else {
        //   float _360 = abs(_331);
        //   float _361 = log2(_360);
        //   float _362 = _361 * 0.4166666567325592f;
        //   float _363 = exp2(_362);
        //   float _364 = _363 * 1.0549999475479126f;
        //   float _365 = _364 + -0.054999999701976776f;
        //   _367 = _365;
        // }
        _343 = renodx::color::srgb::EncodeSafe(_329);
        _355 = renodx::color::srgb::EncodeSafe(_330);
        _367 = renodx::color::srgb::EncodeSafe(_331);

        float _368 = _295 - _343;
        float _369 = _296 - _355;
        float _370 = _297 - _367;
        float _371 = _368 * _328;
        float _372 = _369 * _328;
        float _373 = _370 * _328;
        float _374 = _371 + _343;
        float _375 = _372 + _355;
        float _376 = _373 + _367;
        bool _380 = (cb0_035x < 0.0f);
        if (!_380) {
          float _387 = dot(float3(_374, _375, _376), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
          float _388 = cb0_035x - _374;
          float _389 = cb0_035y - _375;
          float _390 = cb0_035z - _376;
          float _391 = _388 * _388;
          float _392 = _389 * _389;
          float _393 = _391 + _392;
          float _394 = _390 * _390;
          float _395 = _393 + _394;
          float _396 = sqrt(_395);
          float _400 = cb0_051y - cb0_051x;
          float _401 = _396 - cb0_051x;
          float _402 = _401 / _400;
          float _403 = saturate(_402);
          float _404 = _403 * 2.0f;
          float _405 = 3.0f - _404;
          float _406 = _403 * _403;
          float _407 = _406 * _405;
          float _408 = _387 * cb0_043x;
          float _409 = _387 * cb0_043y;
          float _410 = _387 * cb0_043z;
          // bool _411 = !(_408 >= 0.0030399328097701073f);
          // if (_411) {
          //   float _413 = _408 * 12.923210144042969f;
          //   _422 = _413;
          // } else {
          //   float _415 = abs(_408);
          //   float _416 = log2(_415);
          //   float _417 = _416 * 0.4166666567325592f;
          //   float _418 = exp2(_417);
          //   float _419 = _418 * 1.0549999475479126f;
          //   float _420 = _419 + -0.054999999701976776f;
          //   _422 = _420;
          // }
          // bool _423 = !(_409 >= 0.0030399328097701073f);
          // if (_423) {
          //   float _425 = _409 * 12.923210144042969f;
          //   _434 = _425;
          // } else {
          //   float _427 = abs(_409);
          //   float _428 = log2(_427);
          //   float _429 = _428 * 0.4166666567325592f;
          //   float _430 = exp2(_429);
          //   float _431 = _430 * 1.0549999475479126f;
          //   float _432 = _431 + -0.054999999701976776f;
          //   _434 = _432;
          // }
          // bool _435 = !(_410 >= 0.0030399328097701073f);
          // if (_435) {
          //   float _437 = _410 * 12.923210144042969f;
          //   _446 = _437;
          // } else {
          //   float _439 = abs(_410);
          //   float _440 = log2(_439);
          //   float _441 = _440 * 0.4166666567325592f;
          //   float _442 = exp2(_441);
          //   float _443 = _442 * 1.0549999475479126f;
          //   float _444 = _443 + -0.054999999701976776f;
          //   _446 = _444;
          // }
          _422 = renodx::color::srgb::EncodeSafe(_408);
          _434 = renodx::color::srgb::EncodeSafe(_409);
          _446 = renodx::color::srgb::EncodeSafe(_410);

          float _447 = _374 - _422;
          float _448 = _375 - _434;
          float _449 = _376 - _446;
          float _450 = _447 * _407;
          float _451 = _448 * _407;
          float _452 = _449 * _407;
          float _453 = _450 + _422;
          float _454 = _451 + _434;
          float _455 = _452 + _446;
          bool _459 = (cb0_036x < 0.0f);
          if (!_459) {
            float _466 = dot(float3(_453, _454, _455), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
            float _467 = cb0_036x - _453;
            float _468 = cb0_036y - _454;
            float _469 = cb0_036z - _455;
            float _470 = _467 * _467;
            float _471 = _468 * _468;
            float _472 = _470 + _471;
            float _473 = _469 * _469;
            float _474 = _472 + _473;
            float _475 = sqrt(_474);
            float _479 = cb0_052y - cb0_052x;
            float _480 = _475 - cb0_052x;
            float _481 = _480 / _479;
            float _482 = saturate(_481);
            float _483 = _482 * 2.0f;
            float _484 = 3.0f - _483;
            float _485 = _482 * _482;
            float _486 = _485 * _484;
            float _487 = _466 * cb0_044x;
            float _488 = _466 * cb0_044y;
            float _489 = _466 * cb0_044z;
            // bool _490 = !(_487 >= 0.0030399328097701073f);
            // if (_490) {
            //   float _492 = _487 * 12.923210144042969f;
            //   _501 = _492;
            // } else {
            //   float _494 = abs(_487);
            //   float _495 = log2(_494);
            //   float _496 = _495 * 0.4166666567325592f;
            //   float _497 = exp2(_496);
            //   float _498 = _497 * 1.0549999475479126f;
            //   float _499 = _498 + -0.054999999701976776f;
            //   _501 = _499;
            // }
            // bool _502 = !(_488 >= 0.0030399328097701073f);
            // if (_502) {
            //   float _504 = _488 * 12.923210144042969f;
            //   _513 = _504;
            // } else {
            //   float _506 = abs(_488);
            //   float _507 = log2(_506);
            //   float _508 = _507 * 0.4166666567325592f;
            //   float _509 = exp2(_508);
            //   float _510 = _509 * 1.0549999475479126f;
            //   float _511 = _510 + -0.054999999701976776f;
            //   _513 = _511;
            // }
            // bool _514 = !(_489 >= 0.0030399328097701073f);
            // if (_514) {
            //   float _516 = _489 * 12.923210144042969f;
            //   _525 = _516;
            // } else {
            //   float _518 = abs(_489);
            //   float _519 = log2(_518);
            //   float _520 = _519 * 0.4166666567325592f;
            //   float _521 = exp2(_520);
            //   float _522 = _521 * 1.0549999475479126f;
            //   float _523 = _522 + -0.054999999701976776f;
            //   _525 = _523;
            // }
            _501 = renodx::color::srgb::EncodeSafe(_487);
            _513 = renodx::color::srgb::EncodeSafe(_488);
            _525 = renodx::color::srgb::EncodeSafe(_489);

            float _526 = _453 - _501;
            float _527 = _454 - _513;
            float _528 = _455 - _525;
            float _529 = _526 * _486;
            float _530 = _527 * _486;
            float _531 = _528 * _486;
            float _532 = _529 + _501;
            float _533 = _530 + _513;
            float _534 = _531 + _525;
            bool _538 = (cb0_037x < 0.0f);
            if (!_538) {
              float _545 = dot(float3(_532, _533, _534), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
              float _546 = cb0_037x - _532;
              float _547 = cb0_037y - _533;
              float _548 = cb0_037z - _534;
              float _549 = _546 * _546;
              float _550 = _547 * _547;
              float _551 = _549 + _550;
              float _552 = _548 * _548;
              float _553 = _551 + _552;
              float _554 = sqrt(_553);
              float _558 = cb0_053y - cb0_053x;
              float _559 = _554 - cb0_053x;
              float _560 = _559 / _558;
              float _561 = saturate(_560);
              float _562 = _561 * 2.0f;
              float _563 = 3.0f - _562;
              float _564 = _561 * _561;
              float _565 = _564 * _563;
              float _566 = _545 * cb0_045x;
              float _567 = _545 * cb0_045y;
              float _568 = _545 * cb0_045z;
              // bool _569 = !(_566 >= 0.0030399328097701073f);
              // if (_569) {
              //   float _571 = _566 * 12.923210144042969f;
              //   _580 = _571;
              // } else {
              //   float _573 = abs(_566);
              //   float _574 = log2(_573);
              //   float _575 = _574 * 0.4166666567325592f;
              //   float _576 = exp2(_575);
              //   float _577 = _576 * 1.0549999475479126f;
              //   float _578 = _577 + -0.054999999701976776f;
              //   _580 = _578;
              // }
              // bool _581 = !(_567 >= 0.0030399328097701073f);
              // if (_581) {
              //   float _583 = _567 * 12.923210144042969f;
              //   _592 = _583;
              // } else {
              //   float _585 = abs(_567);
              //   float _586 = log2(_585);
              //   float _587 = _586 * 0.4166666567325592f;
              //   float _588 = exp2(_587);
              //   float _589 = _588 * 1.0549999475479126f;
              //   float _590 = _589 + -0.054999999701976776f;
              //   _592 = _590;
              // }
              // bool _593 = !(_568 >= 0.0030399328097701073f);
              // if (_593) {
              //   float _595 = _568 * 12.923210144042969f;
              //   _604 = _595;
              // } else {
              //   float _597 = abs(_568);
              //   float _598 = log2(_597);
              //   float _599 = _598 * 0.4166666567325592f;
              //   float _600 = exp2(_599);
              //   float _601 = _600 * 1.0549999475479126f;
              //   float _602 = _601 + -0.054999999701976776f;
              //   _604 = _602;
              // }
              _580 = renodx::color::srgb::EncodeSafe(_566);
              _592 = renodx::color::srgb::EncodeSafe(_567);
              _604 = renodx::color::srgb::EncodeSafe(_568);

              float _605 = _532 - _580;
              float _606 = _533 - _592;
              float _607 = _534 - _604;
              float _608 = _605 * _565;
              float _609 = _606 * _565;
              float _610 = _607 * _565;
              float _611 = _608 + _580;
              float _612 = _609 + _592;
              float _613 = _610 + _604;
              bool _617 = (cb0_038x < 0.0f);
              if (!_617) {
                float _624 = dot(float3(_611, _612, _613), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                float _625 = cb0_038x - _611;
                float _626 = cb0_038y - _612;
                float _627 = cb0_038z - _613;
                float _628 = _625 * _625;
                float _629 = _626 * _626;
                float _630 = _628 + _629;
                float _631 = _627 * _627;
                float _632 = _630 + _631;
                float _633 = sqrt(_632);
                float _637 = cb0_054y - cb0_054x;
                float _638 = _633 - cb0_054x;
                float _639 = _638 / _637;
                float _640 = saturate(_639);
                float _641 = _640 * 2.0f;
                float _642 = 3.0f - _641;
                float _643 = _640 * _640;
                float _644 = _643 * _642;
                float _645 = _624 * cb0_046x;
                float _646 = _624 * cb0_046y;
                float _647 = _624 * cb0_046z;
                // bool _648 = !(_645 >= 0.0030399328097701073f);
                // if (_648) {
                //   float _650 = _645 * 12.923210144042969f;
                //   _659 = _650;
                // } else {
                //   float _652 = abs(_645);
                //   float _653 = log2(_652);
                //   float _654 = _653 * 0.4166666567325592f;
                //   float _655 = exp2(_654);
                //   float _656 = _655 * 1.0549999475479126f;
                //   float _657 = _656 + -0.054999999701976776f;
                //   _659 = _657;
                // }
                // bool _660 = !(_646 >= 0.0030399328097701073f);
                // if (_660) {
                //   float _662 = _646 * 12.923210144042969f;
                //   _671 = _662;
                // } else {
                //   float _664 = abs(_646);
                //   float _665 = log2(_664);
                //   float _666 = _665 * 0.4166666567325592f;
                //   float _667 = exp2(_666);
                //   float _668 = _667 * 1.0549999475479126f;
                //   float _669 = _668 + -0.054999999701976776f;
                //   _671 = _669;
                // }
                // bool _672 = !(_647 >= 0.0030399328097701073f);
                // if (_672) {
                //   float _674 = _647 * 12.923210144042969f;
                //   _683 = _674;
                // } else {
                //   float _676 = abs(_647);
                //   float _677 = log2(_676);
                //   float _678 = _677 * 0.4166666567325592f;
                //   float _679 = exp2(_678);
                //   float _680 = _679 * 1.0549999475479126f;
                //   float _681 = _680 + -0.054999999701976776f;
                //   _683 = _681;
                // }
                _659 = renodx::color::srgb::EncodeSafe(_645);
                _671 = renodx::color::srgb::EncodeSafe(_646);
                _683 = renodx::color::srgb::EncodeSafe(_647);

                float _684 = _611 - _659;
                float _685 = _612 - _671;
                float _686 = _613 - _683;
                float _687 = _684 * _644;
                float _688 = _685 * _644;
                float _689 = _686 * _644;
                float _690 = _687 + _659;
                float _691 = _688 + _671;
                float _692 = _689 + _683;
                bool _696 = (cb0_039x < 0.0f);
                if (!_696) {
                  float _703 = dot(float3(_690, _691, _692), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                  float _704 = cb0_039x - _690;
                  float _705 = cb0_039y - _691;
                  float _706 = cb0_039z - _692;
                  float _707 = _704 * _704;
                  float _708 = _705 * _705;
                  float _709 = _707 + _708;
                  float _710 = _706 * _706;
                  float _711 = _709 + _710;
                  float _712 = sqrt(_711);
                  float _716 = cb0_055y - cb0_055x;
                  float _717 = _712 - cb0_055x;
                  float _718 = _717 / _716;
                  float _719 = saturate(_718);
                  float _720 = _719 * 2.0f;
                  float _721 = 3.0f - _720;
                  float _722 = _719 * _719;
                  float _723 = _722 * _721;
                  float _724 = _703 * cb0_047x;
                  float _725 = _703 * cb0_047y;
                  float _726 = _703 * cb0_047z;
                  // bool _727 = !(_724 >= 0.0030399328097701073f);
                  // if (_727) {
                  //   float _729 = _724 * 12.923210144042969f;
                  //   _738 = _729;
                  // } else {
                  //   float _731 = abs(_724);
                  //   float _732 = log2(_731);
                  //   float _733 = _732 * 0.4166666567325592f;
                  //   float _734 = exp2(_733);
                  //   float _735 = _734 * 1.0549999475479126f;
                  //   float _736 = _735 + -0.054999999701976776f;
                  //   _738 = _736;
                  // }
                  // bool _739 = !(_725 >= 0.0030399328097701073f);
                  // if (_739) {
                  //   float _741 = _725 * 12.923210144042969f;
                  //   _750 = _741;
                  // } else {
                  //   float _743 = abs(_725);
                  //   float _744 = log2(_743);
                  //   float _745 = _744 * 0.4166666567325592f;
                  //   float _746 = exp2(_745);
                  //   float _747 = _746 * 1.0549999475479126f;
                  //   float _748 = _747 + -0.054999999701976776f;
                  //   _750 = _748;
                  // }
                  // bool _751 = !(_726 >= 0.0030399328097701073f);
                  // if (_751) {
                  //   float _753 = _726 * 12.923210144042969f;
                  //   _762 = _753;
                  // } else {
                  //   float _755 = abs(_726);
                  //   float _756 = log2(_755);
                  //   float _757 = _756 * 0.4166666567325592f;
                  //   float _758 = exp2(_757);
                  //   float _759 = _758 * 1.0549999475479126f;
                  //   float _760 = _759 + -0.054999999701976776f;
                  //   _762 = _760;
                  // }
                  _738 = renodx::color::srgb::EncodeSafe(_724);
                  _750 = renodx::color::srgb::EncodeSafe(_725);
                  _762 = renodx::color::srgb::EncodeSafe(_726);

                  float _763 = _690 - _738;
                  float _764 = _691 - _750;
                  float _765 = _692 - _762;
                  float _766 = _763 * _723;
                  float _767 = _764 * _723;
                  float _768 = _765 * _723;
                  float _769 = _766 + _738;
                  float _770 = _767 + _750;
                  float _771 = _768 + _762;
                  bool _775 = (cb0_040x < 0.0f);
                  if (!_775) {
                    float _782 = dot(float3(_769, _770, _771), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                    float _783 = cb0_040x - _769;
                    float _784 = cb0_040y - _770;
                    float _785 = cb0_040z - _771;
                    float _786 = _783 * _783;
                    float _787 = _784 * _784;
                    float _788 = _786 + _787;
                    float _789 = _785 * _785;
                    float _790 = _788 + _789;
                    float _791 = sqrt(_790);
                    float _795 = cb0_056y - cb0_056x;
                    float _796 = _791 - cb0_056x;
                    float _797 = _796 / _795;
                    float _798 = saturate(_797);
                    float _799 = _798 * 2.0f;
                    float _800 = 3.0f - _799;
                    float _801 = _798 * _798;
                    float _802 = _801 * _800;
                    float _803 = _782 * cb0_048x;
                    float _804 = _782 * cb0_048y;
                    float _805 = _782 * cb0_048z;
                    // bool _806 = !(_803 >= 0.0030399328097701073f);
                    // if (_806) {
                    //   float _808 = _803 * 12.923210144042969f;
                    //   _817 = _808;
                    // } else {
                    //   float _810 = abs(_803);
                    //   float _811 = log2(_810);
                    //   float _812 = _811 * 0.4166666567325592f;
                    //   float _813 = exp2(_812);
                    //   float _814 = _813 * 1.0549999475479126f;
                    //   float _815 = _814 + -0.054999999701976776f;
                    //   _817 = _815;
                    // }
                    // bool _818 = !(_804 >= 0.0030399328097701073f);
                    // if (_818) {
                    //   float _820 = _804 * 12.923210144042969f;
                    //   _829 = _820;
                    // } else {
                    //   float _822 = abs(_804);
                    //   float _823 = log2(_822);
                    //   float _824 = _823 * 0.4166666567325592f;
                    //   float _825 = exp2(_824);
                    //   float _826 = _825 * 1.0549999475479126f;
                    //   float _827 = _826 + -0.054999999701976776f;
                    //   _829 = _827;
                    // }
                    // bool _830 = !(_805 >= 0.0030399328097701073f);
                    // if (_830) {
                    //   float _832 = _805 * 12.923210144042969f;
                    //   _841 = _832;
                    // } else {
                    //   float _834 = abs(_805);
                    //   float _835 = log2(_834);
                    //   float _836 = _835 * 0.4166666567325592f;
                    //   float _837 = exp2(_836);
                    //   float _838 = _837 * 1.0549999475479126f;
                    //   float _839 = _838 + -0.054999999701976776f;
                    //   _841 = _839;
                    // }
                    _817 = renodx::color::srgb::EncodeSafe(_803);
                    _829 = renodx::color::srgb::EncodeSafe(_804);
                    _841 = renodx::color::srgb::EncodeSafe(_805);

                    float _842 = _769 - _817;
                    float _843 = _770 - _829;
                    float _844 = _771 - _841;
                    float _845 = _842 * _802;
                    float _846 = _843 * _802;
                    float _847 = _844 * _802;
                    float _848 = _845 + _817;
                    float _849 = _846 + _829;
                    float _850 = _847 + _841;
                    _852 = _848;
                    _853 = _849;
                    _854 = _850;
                  } else {
                    _852 = _769;
                    _853 = _770;
                    _854 = _771;
                  }
                } else {
                  _852 = _690;
                  _853 = _691;
                  _854 = _692;
                }
              } else {
                _852 = _611;
                _853 = _612;
                _854 = _613;
              }
            } else {
              _852 = _532;
              _853 = _533;
              _854 = _534;
            }
          } else {
            _852 = _453;
            _853 = _454;
            _854 = _455;
          }
        } else {
          _852 = _374;
          _853 = _375;
          _854 = _376;
        }
      } else {
        _852 = _295;
        _853 = _296;
        _854 = _297;
      }
    } else {
      _852 = _211;
      _853 = _212;
      _854 = _213;
    }
  } else {
    _852 = _211;
    _853 = _212;
    _854 = _213;
  }
  SV_Target.x = _852;
  SV_Target.y = _853;
  SV_Target.z = _854;
  SV_Target.w = _214;

  SV_Target.rgb = UIScale(SV_Target.rgb);

  return SV_Target;
}
