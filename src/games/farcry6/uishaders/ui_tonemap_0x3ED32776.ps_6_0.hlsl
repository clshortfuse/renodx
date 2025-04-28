#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);

cbuffer cb1 : register(b1) {
  int cb1_018w : packoffset(c018.w);
};

cbuffer cb0 : register(b0) {
  float cb0_027x : packoffset(c027.x);
  float cb0_027y : packoffset(c027.y);
  float cb0_027z : packoffset(c027.z);
  int cb0_030x : packoffset(c030.x);
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
  float4 _11 = t0.Sample(s2_space2, float2(TEXCOORD1_centroid.z, TEXCOORD1_centroid.w));
  bool _18 = (cb0_030x == 0);
  float _26;
  float _27;
  float _28;
  float _41;
  float _42;
  float _43;
  float _114;
  float _115;
  float _116;
  float _117;
  float _129;
  float _141;
  float _153;
  float _181;
  float _182;
  float _183;
  float _184;
  float _233;
  float _245;
  float _257;
  float _312;
  float _324;
  float _336;
  float _391;
  float _403;
  float _415;
  float _470;
  float _482;
  float _494;
  float _549;
  float _561;
  float _573;
  float _628;
  float _640;
  float _652;
  float _707;
  float _719;
  float _731;
  float _786;
  float _798;
  float _810;
  float _821;
  float _822;
  float _823;
  if (!_18) {
    bool _20 = (_11.w == 0.0f);
    float _21 = select(_20, 1.0f, _11.w);
    float _22 = _11.x / _21;
    float _23 = _11.y / _21;
    float _24 = _11.z / _21;
    _26 = _22;
    _27 = _23;
    _28 = _24;
  } else {
    _26 = _11.x;
    _27 = _11.y;
    _28 = _11.z;
  }
  float _29 = _26 * TEXCOORD0_centroid.x;
  float _30 = _27 * TEXCOORD0_centroid.y;
  float _31 = _28 * TEXCOORD0_centroid.z;
  float _32 = _11.w * TEXCOORD0_centroid.w;
  bool _35 = (cb1_018w == -1);
  if (_35) {
    float _37 = saturate(_29);
    float _38 = saturate(_30);
    float _39 = saturate(_31);
    _41 = _37;
    _42 = _38;
    _43 = _39;
  } else {
    _41 = _29;
    _42 = _30;
    _43 = _31;
  }
  bool _44 = (cb1_018w == -2);
  if (!_44) {
    bool _48 = (cb0_030z > 0.0f);
    if (_48) {
      if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _51 = cb0_030y * 0.10000000149011612f;
        float _52 = log2(cb0_030z);
        float _53 = _52 + -13.287712097167969f;
        float _54 = _53 * 1.4929734468460083f;
        float _55 = _54 + 18.0f;
        float _56 = exp2(_55);
        float _57 = _56 * 0.18000000715255737f;
        float _58 = abs(_57);
        float _59 = log2(_58);
        float _60 = _59 * 1.5f;
        float _61 = exp2(_60);
        float _62 = _61 * _51;
        float _63 = _62 / cb0_030z;
        float _64 = _63 + -0.07636754959821701f;
        float _65 = _59 * 1.2750000953674316f;
        float _66 = exp2(_65);
        float _67 = _66 * 0.07636754959821701f;
        float _68 = cb0_030y * 0.011232397519052029f;
        float _69 = _68 * _61;
        float _70 = _69 / cb0_030z;
        float _71 = _67 - _70;
        float _72 = _66 + -0.11232396960258484f;
        float _73 = _72 * _51;
        float _74 = _73 / cb0_030z;
        float _75 = _74 * cb0_030z;
        float _76 = abs(_41);
        float _77 = abs(_42);
        float _78 = abs(_43);
        float _79 = log2(_76);
        float _80 = log2(_77);
        float _81 = log2(_78);
        float _82 = _79 * 1.5f;
        float _83 = _80 * 1.5f;
        float _84 = _81 * 1.5f;
        float _85 = exp2(_82);
        float _86 = exp2(_83);
        float _87 = exp2(_84);
        float _88 = _85 * _75;
        float _89 = _86 * _75;
        float _90 = _87 * _75;
        float _91 = _79 * 1.2750000953674316f;
        float _92 = _80 * 1.2750000953674316f;
        float _93 = _81 * 1.2750000953674316f;
        float _94 = exp2(_91);
        float _95 = exp2(_92);
        float _96 = exp2(_93);
        float _97 = _94 * _64;
        float _98 = _95 * _64;
        float _99 = _96 * _64;
        float _100 = _97 + _71;
        float _101 = _98 + _71;
        float _102 = _99 + _71;
        float _103 = _88 / _100;
        float _104 = _89 / _101;
        float _105 = _90 / _102;
        float _106 = _103 * 9.999999747378752e-05f;
        float _107 = _104 * 9.999999747378752e-05f;
        float _108 = _105 * 9.999999747378752e-05f;
        float _109 = 5000.0f / cb0_030y;
        float _110 = _106 * _109;
        float _111 = _107 * _109;
        float _112 = _108 * _109;
        _114 = _110;
        _115 = _111;
        _116 = _112;
      } else {
        float3 tonemapped = renodx::color::bt709::from::AP1(ApplyCustomToneMap(renodx::color::ap1::from::BT709(float3(_41, _42, _43))));
        tonemapped = GameScale(tonemapped);
        _114 = tonemapped.x, _115 = tonemapped.y, _116 = tonemapped.z;
      }
      _117 = 1.0f;
    } else {
      _114 = _41;
      _115 = _42;
      _116 = _43;
      _117 = _32;
    }
    // bool _118 = !(_114 >= 0.0030399328097701073f);
    // if (!_118) {
    //   float _120 = abs(_114);
    //   float _121 = log2(_120);
    //   float _122 = _121 * 0.4166666567325592f;
    //   float _123 = exp2(_122);
    //   float _124 = _123 * 1.0549999475479126f;
    //   float _125 = _124 + -0.054999999701976776f;
    //   _129 = _125;
    // } else {
    //   float _127 = _114 * 12.923210144042969f;
    //   _129 = _127;
    // }
    // bool _130 = !(_115 >= 0.0030399328097701073f);
    // if (!_130) {
    //   float _132 = abs(_115);
    //   float _133 = log2(_132);
    //   float _134 = _133 * 0.4166666567325592f;
    //   float _135 = exp2(_134);
    //   float _136 = _135 * 1.0549999475479126f;
    //   float _137 = _136 + -0.054999999701976776f;
    //   _141 = _137;
    // } else {
    //   float _139 = _115 * 12.923210144042969f;
    //   _141 = _139;
    // }
    // bool _142 = !(_116 >= 0.0030399328097701073f);
    // if (!_142) {
    //   float _144 = abs(_116);
    //   float _145 = log2(_144);
    //   float _146 = _145 * 0.4166666567325592f;
    //   float _147 = exp2(_146);
    //   float _148 = _147 * 1.0549999475479126f;
    //   float _149 = _148 + -0.054999999701976776f;
    //   _153 = _149;
    // } else {
    //   float _151 = _116 * 12.923210144042969f;
    //   _153 = _151;
    // }
    _129 = renodx::color::srgb::EncodeSafe(_114);
    _141 = renodx::color::srgb::EncodeSafe(_115);
    _153 = renodx::color::srgb::EncodeSafe(_116);

    if (_35) {
      float _159 = abs(_129);
      float _160 = abs(_141);
      float _161 = abs(_153);
      float _162 = log2(_159);
      float _163 = log2(_160);
      float _164 = log2(_161);
      float _165 = _162 * cb0_027z;
      float _166 = _163 * cb0_027z;
      float _167 = _164 * cb0_027z;
      float _168 = exp2(_165);
      float _169 = exp2(_166);
      float _170 = exp2(_167);
      float _171 = _168 * cb0_027y;
      float _172 = _169 * cb0_027y;
      float _173 = _170 * cb0_027y;
      float _174 = _171 + cb0_027x;
      float _175 = _172 + cb0_027x;
      float _176 = _173 + cb0_027x;
      float _177 = saturate(_174);
      float _178 = saturate(_175);
      float _179 = saturate(_176);
      _181 = _177;
      _182 = _178;
      _183 = _179;
      _184 = _117;
    } else {
      _181 = _129;
      _182 = _141;
      _183 = _153;
      _184 = _117;
    }
  } else {
    _181 = _41;
    _182 = _42;
    _183 = _43;
    _184 = _32;
  }

  bool _186 = (cb0_030w == 0);
  if (!_186) {
    bool _191 = (cb0_033x < 0.0f);
    if (!_191) {
      float _198 = dot(float3(_181, _182, _183), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      float _199 = cb0_033x - _181;
      float _200 = cb0_033y - _182;
      float _201 = cb0_033z - _183;
      float _202 = _199 * _199;
      float _203 = _200 * _200;
      float _204 = _202 + _203;
      float _205 = _201 * _201;
      float _206 = _204 + _205;
      float _207 = sqrt(_206);
      float _211 = cb0_049y - cb0_049x;
      float _212 = _207 - cb0_049x;
      float _213 = _212 / _211;
      float _214 = saturate(_213);
      float _215 = _214 * 2.0f;
      float _216 = 3.0f - _215;
      float _217 = _214 * _214;
      float _218 = _217 * _216;
      float _219 = _198 * cb0_041x;
      float _220 = _198 * cb0_041y;
      float _221 = _198 * cb0_041z;
      // bool _222 = !(_219 >= 0.0030399328097701073f);
      // if (_222) {
      //   float _224 = _219 * 12.923210144042969f;
      //   _233 = _224;
      // } else {
      //   float _226 = abs(_219);
      //   float _227 = log2(_226);
      //   float _228 = _227 * 0.4166666567325592f;
      //   float _229 = exp2(_228);
      //   float _230 = _229 * 1.0549999475479126f;
      //   float _231 = _230 + -0.054999999701976776f;
      //   _233 = _231;
      // }
      // bool _234 = !(_220 >= 0.0030399328097701073f);
      // if (_234) {
      //   float _236 = _220 * 12.923210144042969f;
      //   _245 = _236;
      // } else {
      //   float _238 = abs(_220);
      //   float _239 = log2(_238);
      //   float _240 = _239 * 0.4166666567325592f;
      //   float _241 = exp2(_240);
      //   float _242 = _241 * 1.0549999475479126f;
      //   float _243 = _242 + -0.054999999701976776f;
      //   _245 = _243;
      // }
      // bool _246 = !(_221 >= 0.0030399328097701073f);
      // if (_246) {
      //   float _248 = _221 * 12.923210144042969f;
      //   _257 = _248;
      // } else {
      //   float _250 = abs(_221);
      //   float _251 = log2(_250);
      //   float _252 = _251 * 0.4166666567325592f;
      //   float _253 = exp2(_252);
      //   float _254 = _253 * 1.0549999475479126f;
      //   float _255 = _254 + -0.054999999701976776f;
      //   _257 = _255;
      // }
      _233 = renodx::color::srgb::EncodeSafe(_219);
      _245 = renodx::color::srgb::EncodeSafe(_220);
      _257 = renodx::color::srgb::EncodeSafe(_221);

      float _258 = _181 - _233;
      float _259 = _182 - _245;
      float _260 = _183 - _257;
      float _261 = _258 * _218;
      float _262 = _259 * _218;
      float _263 = _260 * _218;
      float _264 = _261 + _233;
      float _265 = _262 + _245;
      float _266 = _263 + _257;

      bool _270 = (cb0_034x < 0.0f);
      if (!_270) {
        float _277 = dot(float3(_264, _265, _266), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
        float _278 = cb0_034x - _264;
        float _279 = cb0_034y - _265;
        float _280 = cb0_034z - _266;
        float _281 = _278 * _278;
        float _282 = _279 * _279;
        float _283 = _281 + _282;
        float _284 = _280 * _280;
        float _285 = _283 + _284;
        float _286 = sqrt(_285);
        float _290 = cb0_050y - cb0_050x;
        float _291 = _286 - cb0_050x;
        float _292 = _291 / _290;
        float _293 = saturate(_292);
        float _294 = _293 * 2.0f;
        float _295 = 3.0f - _294;
        float _296 = _293 * _293;
        float _297 = _296 * _295;
        float _298 = _277 * cb0_042x;
        float _299 = _277 * cb0_042y;
        float _300 = _277 * cb0_042z;
        // bool _301 = !(_298 >= 0.0030399328097701073f);
        // if (_301) {
        //   float _303 = _298 * 12.923210144042969f;
        //   _312 = _303;
        // } else {
        //   float _305 = abs(_298);
        //   float _306 = log2(_305);
        //   float _307 = _306 * 0.4166666567325592f;
        //   float _308 = exp2(_307);
        //   float _309 = _308 * 1.0549999475479126f;
        //   float _310 = _309 + -0.054999999701976776f;
        //   _312 = _310;
        // }
        // bool _313 = !(_299 >= 0.0030399328097701073f);
        // if (_313) {
        //   float _315 = _299 * 12.923210144042969f;
        //   _324 = _315;
        // } else {
        //   float _317 = abs(_299);
        //   float _318 = log2(_317);
        //   float _319 = _318 * 0.4166666567325592f;
        //   float _320 = exp2(_319);
        //   float _321 = _320 * 1.0549999475479126f;
        //   float _322 = _321 + -0.054999999701976776f;
        //   _324 = _322;
        // }
        // bool _325 = !(_300 >= 0.0030399328097701073f);
        // if (_325) {
        //   float _327 = _300 * 12.923210144042969f;
        //   _336 = _327;
        // } else {
        //   float _329 = abs(_300);
        //   float _330 = log2(_329);
        //   float _331 = _330 * 0.4166666567325592f;
        //   float _332 = exp2(_331);
        //   float _333 = _332 * 1.0549999475479126f;
        //   float _334 = _333 + -0.054999999701976776f;
        //   _336 = _334;
        // }
        _312 = renodx::color::srgb::EncodeSafe(_298);
        _324 = renodx::color::srgb::EncodeSafe(_299);
        _336 = renodx::color::srgb::EncodeSafe(_300);

        float _337 = _264 - _312;
        float _338 = _265 - _324;
        float _339 = _266 - _336;
        float _340 = _337 * _297;
        float _341 = _338 * _297;
        float _342 = _339 * _297;
        float _343 = _340 + _312;
        float _344 = _341 + _324;
        float _345 = _342 + _336;
        bool _349 = (cb0_035x < 0.0f);
        if (!_349) {
          float _356 = dot(float3(_343, _344, _345), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
          float _357 = cb0_035x - _343;
          float _358 = cb0_035y - _344;
          float _359 = cb0_035z - _345;
          float _360 = _357 * _357;
          float _361 = _358 * _358;
          float _362 = _360 + _361;
          float _363 = _359 * _359;
          float _364 = _362 + _363;
          float _365 = sqrt(_364);
          float _369 = cb0_051y - cb0_051x;
          float _370 = _365 - cb0_051x;
          float _371 = _370 / _369;
          float _372 = saturate(_371);
          float _373 = _372 * 2.0f;
          float _374 = 3.0f - _373;
          float _375 = _372 * _372;
          float _376 = _375 * _374;
          float _377 = _356 * cb0_043x;
          float _378 = _356 * cb0_043y;
          float _379 = _356 * cb0_043z;
          // bool _380 = !(_377 >= 0.0030399328097701073f);
          // if (_380) {
          //   float _382 = _377 * 12.923210144042969f;
          //   _391 = _382;
          // } else {
          //   float _384 = abs(_377);
          //   float _385 = log2(_384);
          //   float _386 = _385 * 0.4166666567325592f;
          //   float _387 = exp2(_386);
          //   float _388 = _387 * 1.0549999475479126f;
          //   float _389 = _388 + -0.054999999701976776f;
          //   _391 = _389;
          // }
          // bool _392 = !(_378 >= 0.0030399328097701073f);
          // if (_392) {
          //   float _394 = _378 * 12.923210144042969f;
          //   _403 = _394;
          // } else {
          //   float _396 = abs(_378);
          //   float _397 = log2(_396);
          //   float _398 = _397 * 0.4166666567325592f;
          //   float _399 = exp2(_398);
          //   float _400 = _399 * 1.0549999475479126f;
          //   float _401 = _400 + -0.054999999701976776f;
          //   _403 = _401;
          // }
          // bool _404 = !(_379 >= 0.0030399328097701073f);
          // if (_404) {
          //   float _406 = _379 * 12.923210144042969f;
          //   _415 = _406;
          // } else {
          //   float _408 = abs(_379);
          //   float _409 = log2(_408);
          //   float _410 = _409 * 0.4166666567325592f;
          //   float _411 = exp2(_410);
          //   float _412 = _411 * 1.0549999475479126f;
          //   float _413 = _412 + -0.054999999701976776f;
          //   _415 = _413;
          // }
          _391 = renodx::color::srgb::EncodeSafe(_377);
          _403 = renodx::color::srgb::EncodeSafe(_378);
          _415 = renodx::color::srgb::EncodeSafe(_379);

          float _416 = _343 - _391;
          float _417 = _344 - _403;
          float _418 = _345 - _415;
          float _419 = _416 * _376;
          float _420 = _417 * _376;
          float _421 = _418 * _376;
          float _422 = _419 + _391;
          float _423 = _420 + _403;
          float _424 = _421 + _415;
          bool _428 = (cb0_036x < 0.0f);
          if (!_428) {
            float _435 = dot(float3(_422, _423, _424), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
            float _436 = cb0_036x - _422;
            float _437 = cb0_036y - _423;
            float _438 = cb0_036z - _424;
            float _439 = _436 * _436;
            float _440 = _437 * _437;
            float _441 = _439 + _440;
            float _442 = _438 * _438;
            float _443 = _441 + _442;
            float _444 = sqrt(_443);
            float _448 = cb0_052y - cb0_052x;
            float _449 = _444 - cb0_052x;
            float _450 = _449 / _448;
            float _451 = saturate(_450);
            float _452 = _451 * 2.0f;
            float _453 = 3.0f - _452;
            float _454 = _451 * _451;
            float _455 = _454 * _453;
            float _456 = _435 * cb0_044x;
            float _457 = _435 * cb0_044y;
            float _458 = _435 * cb0_044z;
            // bool _459 = !(_456 >= 0.0030399328097701073f);
            // if (_459) {
            //   float _461 = _456 * 12.923210144042969f;
            //   _470 = _461;
            // } else {
            //   float _463 = abs(_456);
            //   float _464 = log2(_463);
            //   float _465 = _464 * 0.4166666567325592f;
            //   float _466 = exp2(_465);
            //   float _467 = _466 * 1.0549999475479126f;
            //   float _468 = _467 + -0.054999999701976776f;
            //   _470 = _468;
            // }
            // bool _471 = !(_457 >= 0.0030399328097701073f);
            // if (_471) {
            //   float _473 = _457 * 12.923210144042969f;
            //   _482 = _473;
            // } else {
            //   float _475 = abs(_457);
            //   float _476 = log2(_475);
            //   float _477 = _476 * 0.4166666567325592f;
            //   float _478 = exp2(_477);
            //   float _479 = _478 * 1.0549999475479126f;
            //   float _480 = _479 + -0.054999999701976776f;
            //   _482 = _480;
            // }
            // bool _483 = !(_458 >= 0.0030399328097701073f);
            // if (_483) {
            //   float _485 = _458 * 12.923210144042969f;
            //   _494 = _485;
            // } else {
            //   float _487 = abs(_458);
            //   float _488 = log2(_487);
            //   float _489 = _488 * 0.4166666567325592f;
            //   float _490 = exp2(_489);
            //   float _491 = _490 * 1.0549999475479126f;
            //   float _492 = _491 + -0.054999999701976776f;
            //   _494 = _492;
            // }
            _470 = renodx::color::srgb::EncodeSafe(_456);
            _482 = renodx::color::srgb::EncodeSafe(_457);
            _494 = renodx::color::srgb::EncodeSafe(_458);

            float _495 = _422 - _470;
            float _496 = _423 - _482;
            float _497 = _424 - _494;
            float _498 = _495 * _455;
            float _499 = _496 * _455;
            float _500 = _497 * _455;
            float _501 = _498 + _470;
            float _502 = _499 + _482;
            float _503 = _500 + _494;
            bool _507 = (cb0_037x < 0.0f);
            if (!_507) {
              float _514 = dot(float3(_501, _502, _503), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
              float _515 = cb0_037x - _501;
              float _516 = cb0_037y - _502;
              float _517 = cb0_037z - _503;
              float _518 = _515 * _515;
              float _519 = _516 * _516;
              float _520 = _518 + _519;
              float _521 = _517 * _517;
              float _522 = _520 + _521;
              float _523 = sqrt(_522);
              float _527 = cb0_053y - cb0_053x;
              float _528 = _523 - cb0_053x;
              float _529 = _528 / _527;
              float _530 = saturate(_529);
              float _531 = _530 * 2.0f;
              float _532 = 3.0f - _531;
              float _533 = _530 * _530;
              float _534 = _533 * _532;
              float _535 = _514 * cb0_045x;
              float _536 = _514 * cb0_045y;
              float _537 = _514 * cb0_045z;
              // bool _538 = !(_535 >= 0.0030399328097701073f);
              // if (_538) {
              //   float _540 = _535 * 12.923210144042969f;
              //   _549 = _540;
              // } else {
              //   float _542 = abs(_535);
              //   float _543 = log2(_542);
              //   float _544 = _543 * 0.4166666567325592f;
              //   float _545 = exp2(_544);
              //   float _546 = _545 * 1.0549999475479126f;
              //   float _547 = _546 + -0.054999999701976776f;
              //   _549 = _547;
              // }
              // bool _550 = !(_536 >= 0.0030399328097701073f);
              // if (_550) {
              //   float _552 = _536 * 12.923210144042969f;
              //   _561 = _552;
              // } else {
              //   float _554 = abs(_536);
              //   float _555 = log2(_554);
              //   float _556 = _555 * 0.4166666567325592f;
              //   float _557 = exp2(_556);
              //   float _558 = _557 * 1.0549999475479126f;
              //   float _559 = _558 + -0.054999999701976776f;
              //   _561 = _559;
              // }
              // bool _562 = !(_537 >= 0.0030399328097701073f);
              // if (_562) {
              //   float _564 = _537 * 12.923210144042969f;
              //   _573 = _564;
              // } else {
              //   float _566 = abs(_537);
              //   float _567 = log2(_566);
              //   float _568 = _567 * 0.4166666567325592f;
              //   float _569 = exp2(_568);
              //   float _570 = _569 * 1.0549999475479126f;
              //   float _571 = _570 + -0.054999999701976776f;
              //   _573 = _571;
              // }
              _549 = renodx::color::srgb::EncodeSafe(_535);
              _561 = renodx::color::srgb::EncodeSafe(_536);
              _573 = renodx::color::srgb::EncodeSafe(_537);

              float _574 = _501 - _549;
              float _575 = _502 - _561;
              float _576 = _503 - _573;
              float _577 = _574 * _534;
              float _578 = _575 * _534;
              float _579 = _576 * _534;
              float _580 = _577 + _549;
              float _581 = _578 + _561;
              float _582 = _579 + _573;
              bool _586 = (cb0_038x < 0.0f);
              if (!_586) {
                float _593 = dot(float3(_580, _581, _582), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                float _594 = cb0_038x - _580;
                float _595 = cb0_038y - _581;
                float _596 = cb0_038z - _582;
                float _597 = _594 * _594;
                float _598 = _595 * _595;
                float _599 = _597 + _598;
                float _600 = _596 * _596;
                float _601 = _599 + _600;
                float _602 = sqrt(_601);
                float _606 = cb0_054y - cb0_054x;
                float _607 = _602 - cb0_054x;
                float _608 = _607 / _606;
                float _609 = saturate(_608);
                float _610 = _609 * 2.0f;
                float _611 = 3.0f - _610;
                float _612 = _609 * _609;
                float _613 = _612 * _611;
                float _614 = _593 * cb0_046x;
                float _615 = _593 * cb0_046y;
                float _616 = _593 * cb0_046z;
                // bool _617 = !(_614 >= 0.0030399328097701073f);
                // if (_617) {
                //   float _619 = _614 * 12.923210144042969f;
                //   _628 = _619;
                // } else {
                //   float _621 = abs(_614);
                //   float _622 = log2(_621);
                //   float _623 = _622 * 0.4166666567325592f;
                //   float _624 = exp2(_623);
                //   float _625 = _624 * 1.0549999475479126f;
                //   float _626 = _625 + -0.054999999701976776f;
                //   _628 = _626;
                // }
                // bool _629 = !(_615 >= 0.0030399328097701073f);
                // if (_629) {
                //   float _631 = _615 * 12.923210144042969f;
                //   _640 = _631;
                // } else {
                //   float _633 = abs(_615);
                //   float _634 = log2(_633);
                //   float _635 = _634 * 0.4166666567325592f;
                //   float _636 = exp2(_635);
                //   float _637 = _636 * 1.0549999475479126f;
                //   float _638 = _637 + -0.054999999701976776f;
                //   _640 = _638;
                // }
                // bool _641 = !(_616 >= 0.0030399328097701073f);
                // if (_641) {
                //   float _643 = _616 * 12.923210144042969f;
                //   _652 = _643;
                // } else {
                //   float _645 = abs(_616);
                //   float _646 = log2(_645);
                //   float _647 = _646 * 0.4166666567325592f;
                //   float _648 = exp2(_647);
                //   float _649 = _648 * 1.0549999475479126f;
                //   float _650 = _649 + -0.054999999701976776f;
                //   _652 = _650;
                // }
                _628 = renodx::color::srgb::EncodeSafe(_614);
                _640 = renodx::color::srgb::EncodeSafe(_615);
                _652 = renodx::color::srgb::EncodeSafe(_616);

                float _653 = _580 - _628;
                float _654 = _581 - _640;
                float _655 = _582 - _652;
                float _656 = _653 * _613;
                float _657 = _654 * _613;
                float _658 = _655 * _613;
                float _659 = _656 + _628;
                float _660 = _657 + _640;
                float _661 = _658 + _652;
                bool _665 = (cb0_039x < 0.0f);
                if (!_665) {
                  float _672 = dot(float3(_659, _660, _661), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                  float _673 = cb0_039x - _659;
                  float _674 = cb0_039y - _660;
                  float _675 = cb0_039z - _661;
                  float _676 = _673 * _673;
                  float _677 = _674 * _674;
                  float _678 = _676 + _677;
                  float _679 = _675 * _675;
                  float _680 = _678 + _679;
                  float _681 = sqrt(_680);
                  float _685 = cb0_055y - cb0_055x;
                  float _686 = _681 - cb0_055x;
                  float _687 = _686 / _685;
                  float _688 = saturate(_687);
                  float _689 = _688 * 2.0f;
                  float _690 = 3.0f - _689;
                  float _691 = _688 * _688;
                  float _692 = _691 * _690;
                  float _693 = _672 * cb0_047x;
                  float _694 = _672 * cb0_047y;
                  float _695 = _672 * cb0_047z;
                  // bool _696 = !(_693 >= 0.0030399328097701073f);
                  // if (_696) {
                  //   float _698 = _693 * 12.923210144042969f;
                  //   _707 = _698;
                  // } else {
                  //   float _700 = abs(_693);
                  //   float _701 = log2(_700);
                  //   float _702 = _701 * 0.4166666567325592f;
                  //   float _703 = exp2(_702);
                  //   float _704 = _703 * 1.0549999475479126f;
                  //   float _705 = _704 + -0.054999999701976776f;
                  //   _707 = _705;
                  // }
                  // bool _708 = !(_694 >= 0.0030399328097701073f);
                  // if (_708) {
                  //   float _710 = _694 * 12.923210144042969f;
                  //   _719 = _710;
                  // } else {
                  //   float _712 = abs(_694);
                  //   float _713 = log2(_712);
                  //   float _714 = _713 * 0.4166666567325592f;
                  //   float _715 = exp2(_714);
                  //   float _716 = _715 * 1.0549999475479126f;
                  //   float _717 = _716 + -0.054999999701976776f;
                  //   _719 = _717;
                  // }
                  // bool _720 = !(_695 >= 0.0030399328097701073f);
                  // if (_720) {
                  //   float _722 = _695 * 12.923210144042969f;
                  //   _731 = _722;
                  // } else {
                  //   float _724 = abs(_695);
                  //   float _725 = log2(_724);
                  //   float _726 = _725 * 0.4166666567325592f;
                  //   float _727 = exp2(_726);
                  //   float _728 = _727 * 1.0549999475479126f;
                  //   float _729 = _728 + -0.054999999701976776f;
                  //   _731 = _729;
                  // }
                  _707 = renodx::color::srgb::EncodeSafe(_693);
                  _719 = renodx::color::srgb::EncodeSafe(_694);
                  _731 = renodx::color::srgb::EncodeSafe(_695);

                  float _732 = _659 - _707;
                  float _733 = _660 - _719;
                  float _734 = _661 - _731;
                  float _735 = _732 * _692;
                  float _736 = _733 * _692;
                  float _737 = _734 * _692;
                  float _738 = _735 + _707;
                  float _739 = _736 + _719;
                  float _740 = _737 + _731;
                  bool _744 = (cb0_040x < 0.0f);
                  if (!_744) {
                    float _751 = dot(float3(_738, _739, _740), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                    float _752 = cb0_040x - _738;
                    float _753 = cb0_040y - _739;
                    float _754 = cb0_040z - _740;
                    float _755 = _752 * _752;
                    float _756 = _753 * _753;
                    float _757 = _755 + _756;
                    float _758 = _754 * _754;
                    float _759 = _757 + _758;
                    float _760 = sqrt(_759);
                    float _764 = cb0_056y - cb0_056x;
                    float _765 = _760 - cb0_056x;
                    float _766 = _765 / _764;
                    float _767 = saturate(_766);
                    float _768 = _767 * 2.0f;
                    float _769 = 3.0f - _768;
                    float _770 = _767 * _767;
                    float _771 = _770 * _769;
                    float _772 = _751 * cb0_048x;
                    float _773 = _751 * cb0_048y;
                    float _774 = _751 * cb0_048z;
                    // bool _775 = !(_772 >= 0.0030399328097701073f);
                    // if (_775) {
                    //   float _777 = _772 * 12.923210144042969f;
                    //   _786 = _777;
                    // } else {
                    //   float _779 = abs(_772);
                    //   float _780 = log2(_779);
                    //   float _781 = _780 * 0.4166666567325592f;
                    //   float _782 = exp2(_781);
                    //   float _783 = _782 * 1.0549999475479126f;
                    //   float _784 = _783 + -0.054999999701976776f;
                    //   _786 = _784;
                    // }
                    // bool _787 = !(_773 >= 0.0030399328097701073f);
                    // if (_787) {
                    //   float _789 = _773 * 12.923210144042969f;
                    //   _798 = _789;
                    // } else {
                    //   float _791 = abs(_773);
                    //   float _792 = log2(_791);
                    //   float _793 = _792 * 0.4166666567325592f;
                    //   float _794 = exp2(_793);
                    //   float _795 = _794 * 1.0549999475479126f;
                    //   float _796 = _795 + -0.054999999701976776f;
                    //   _798 = _796;
                    // }
                    // bool _799 = !(_774 >= 0.0030399328097701073f);
                    // if (_799) {
                    //   float _801 = _774 * 12.923210144042969f;
                    //   _810 = _801;
                    // } else {
                    //   float _803 = abs(_774);
                    //   float _804 = log2(_803);
                    //   float _805 = _804 * 0.4166666567325592f;
                    //   float _806 = exp2(_805);
                    //   float _807 = _806 * 1.0549999475479126f;
                    //   float _808 = _807 + -0.054999999701976776f;
                    //   _810 = _808;
                    // }
                    _786 = renodx::color::srgb::EncodeSafe(_772);
                    _798 = renodx::color::srgb::EncodeSafe(_773);
                    _810 = renodx::color::srgb::EncodeSafe(_774);


                    float _811 = _738 - _786;
                    float _812 = _739 - _798;
                    float _813 = _740 - _810;
                    float _814 = _811 * _771;
                    float _815 = _812 * _771;
                    float _816 = _813 * _771;
                    float _817 = _814 + _786;
                    float _818 = _815 + _798;
                    float _819 = _816 + _810;
                    _821 = _817;
                    _822 = _818;
                    _823 = _819;
                  } else {
                    _821 = _738;
                    _822 = _739;
                    _823 = _740;
                  }
                } else {
                  _821 = _659;
                  _822 = _660;
                  _823 = _661;
                }
              } else {
                _821 = _580;
                _822 = _581;
                _823 = _582;
              }
            } else {
              _821 = _501;
              _822 = _502;
              _823 = _503;
            }
          } else {
            _821 = _422;
            _822 = _423;
            _823 = _424;
          }
        } else {
          _821 = _343;
          _822 = _344;
          _823 = _345;
        }
      } else {
        _821 = _264;
        _822 = _265;
        _823 = _266;
      }
    } else {
      _821 = _181;
      _822 = _182;
      _823 = _183;
    }
  } else {
    _821 = _181;
    _822 = _182;
    _823 = _183;
  }
  SV_Target.x = _821;
  SV_Target.y = _822;
  SV_Target.z = _823;
  SV_Target.w = _184;

  SV_Target.rgb = UIScale(SV_Target.rgb);

  return SV_Target;
}
