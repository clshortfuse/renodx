cbuffer SceneInfo : register(b0) {
  float SceneInfo_023x : packoffset(c023.x);
  float SceneInfo_023y : packoffset(c023.y);
};

cbuffer HDRMapping : register(b1) {
  float HDRMapping_000z : packoffset(c000.z);
  float HDRMapping_009x : packoffset(c009.x);
  float HDRMapping_009y : packoffset(c009.y);
  float HDRMapping_009z : packoffset(c009.z);
  float HDRMapping_009w : packoffset(c009.w);
  float HDRMapping_010x : packoffset(c010.x);
  float HDRMapping_010z : packoffset(c010.z);
  float HDRMapping_010w : packoffset(c010.w);
  float HDRMapping_014x : packoffset(c014.x);
};

cbuffer OCIOTransformXYZMatrix : register(b2) {
  float OCIOTransformXYZMatrix_000x : packoffset(c000.x);
  float OCIOTransformXYZMatrix_000y : packoffset(c000.y);
  float OCIOTransformXYZMatrix_000z : packoffset(c000.z);
  float OCIOTransformXYZMatrix_001x : packoffset(c001.x);
  float OCIOTransformXYZMatrix_001y : packoffset(c001.y);
  float OCIOTransformXYZMatrix_001z : packoffset(c001.z);
  float OCIOTransformXYZMatrix_002x : packoffset(c002.x);
  float OCIOTransformXYZMatrix_002y : packoffset(c002.y);
  float OCIOTransformXYZMatrix_002z : packoffset(c002.z);
  float OCIOTransformXYZMatrix_004x : packoffset(c004.x);
  float OCIOTransformXYZMatrix_004y : packoffset(c004.y);
  float OCIOTransformXYZMatrix_004z : packoffset(c004.z);
};

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _11 = (HDRMapping_000z) * 0.009999999776482582f;
  float _14 = _11 * (HDRMapping_009w);
  float _18 = (HDRMapping_010w) * 0.004999999888241291f;
  float _21 = (SceneInfo_023x) * 0.029999999329447746f;
  float _22 = (SceneInfo_023y) * 0.800000011920929f;
  bool _23 = ((SV_Position.x) >= _21);
  float _24 = (SceneInfo_023x) * 0.8299999833106995f;
  bool _25 = ((SV_Position.x) <= _24);
  bool _26 = _23 && _25;
  bool _27 = ((SV_Position.y) >= _22);
  bool _28 = _27 && _26;
  bool _29 = ((SV_Position.y) <= (SceneInfo_023y));
  bool _30 = _29 && _28;
  float _65;
  float _233;
  float _241;
  float _285;
  float _290;
  float _434 = 0.0f;
  float _435 = 0.0f;
  float _436 = 0.0f;
  float _437 = 0.0f;
  if (_30) {
    float _32 = (SceneInfo_023y) * 0.20000000298023224f;
    float _33 = (SceneInfo_023y) * 0.0009259259095415473f;
    float _34 = (SceneInfo_023x) * 0.0005208333604969084f;
    float _35 = (SV_Position.x) + -0.5f;
    float _36 = _35 - _21;
    float _37 = 0.5f - (SV_Position.y);
    float _38 = _37 + _22;
    float _39 = _38 + _32;
    float _40 = _36 * _18;
    float _41 = _39 * _18;
    float _42 = _40 / _34;
    float _43 = _41 / _33;
    float _44 = _42 * 2.0f;
    float _45 = -0.0f - _44;
    bool _46 = (_44 >= _45);
    float _47 = abs(_44);
    float _48 = frac(_47);
    float _49 = -0.0f - _48;
    float _50 = (_46 ? _48 : _49);
    float _51 = _50 * 0.5f;
    bool _52 = !(_51 <= 0.019999999552965164f);
    _65 = 0.05999999865889549f;
    do {
      if (_52) {
        float _54 = _43 * 2.0f;
        float _55 = -0.0f - _54;
        bool _56 = (_54 >= _55);
        float _57 = abs(_54);
        float _58 = frac(_57);
        float _59 = -0.0f - _58;
        float _60 = (_56 ? _58 : _59);
        float _61 = _60 * 0.5f;
        bool _62 = (_61 <= 0.019999999552965164f);
        float _63 = (_62 ? 0.05999999865889549f : 0.03999999910593033f);
        _65 = _63;
      }
      float _82 = (OCIOTransformXYZMatrix_000x) * 0.35920000076293945f;
      float _83 = mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), _82);
      float _84 = mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), _83);
      float _85 = (OCIOTransformXYZMatrix_000y) * 0.35920000076293945f;
      float _86 = mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), _85);
      float _87 = mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), _86);
      float _88 = (OCIOTransformXYZMatrix_000z) * 0.35920000076293945f;
      float _89 = mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), _88);
      float _90 = mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), _89);
      float _91 = (OCIOTransformXYZMatrix_000x) * -0.19220000505447388f;
      float _92 = mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), _91);
      float _93 = mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), _92);
      float _94 = (OCIOTransformXYZMatrix_000y) * -0.19220000505447388f;
      float _95 = mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), _94);
      float _96 = mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), _95);
      float _97 = (OCIOTransformXYZMatrix_000z) * -0.19220000505447388f;
      float _98 = mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), _97);
      float _99 = mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), _98);
      float _100 = (OCIOTransformXYZMatrix_000x) * 0.007000000216066837f;
      float _101 = mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), _100);
      float _102 = mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), _101);
      float _103 = (OCIOTransformXYZMatrix_000y) * 0.007000000216066837f;
      float _104 = mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), _103);
      float _105 = mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), _104);
      float _106 = (OCIOTransformXYZMatrix_000z) * 0.007000000216066837f;
      float _107 = mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), _106);
      float _108 = mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), _107);
      float _109 = _84 * 4096.0f;
      float _110 = _87 * 4096.0f;
      float _111 = _90 * 4096.0f;
      float _112 = round(_109);
      float _113 = round(_110);
      float _114 = round(_111);
      float _115 = _113 * 0.000244140625f;
      float _116 = _114 * 0.000244140625f;
      float _117 = _93 * 4096.0f;
      float _118 = _96 * 4096.0f;
      float _119 = _99 * 4096.0f;
      float _120 = round(_117);
      float _121 = round(_118);
      float _122 = round(_119);
      float _123 = _121 * 0.000244140625f;
      float _124 = _122 * 0.000244140625f;
      float _125 = _102 * 4096.0f;
      float _126 = _105 * 4096.0f;
      float _127 = _108 * 4096.0f;
      float _128 = round(_125);
      float _129 = round(_126);
      float _130 = round(_127);
      float _131 = _129 * 0.000244140625f;
      float _132 = _130 * 0.000244140625f;
      float _133 = _42 * 0.000244140625f;
      float _134 = _133 * _112;
      float _135 = mad(_115, _42, _134);
      float _136 = mad(_116, _42, _135);
      float _137 = _133 * _120;
      float _138 = mad(_123, _42, _137);
      float _139 = mad(_124, _42, _138);
      float _140 = _133 * _128;
      float _141 = mad(_131, _42, _140);
      float _142 = mad(_132, _42, _141);
      float _143 = _136 * 0.009999999776482582f;
      float _144 = log2(_143);
      float _145 = _144 * 0.1593017578125f;
      float _146 = exp2(_145);
      float _147 = _146 * 18.8515625f;
      float _148 = _147 + 0.8359375f;
      float _149 = _146 * 18.6875f;
      float _150 = _149 + 1.0f;
      float _151 = _148 / _150;
      float _152 = log2(_151);
      float _153 = _152 * 78.84375f;
      float _154 = exp2(_153);
      float _155 = saturate(_154);
      float _156 = _139 * 0.009999999776482582f;
      float _157 = log2(_156);
      float _158 = _157 * 0.1593017578125f;
      float _159 = exp2(_158);
      float _160 = _159 * 18.8515625f;
      float _161 = _160 + 0.8359375f;
      float _162 = _159 * 18.6875f;
      float _163 = _162 + 1.0f;
      float _164 = _161 / _163;
      float _165 = log2(_164);
      float _166 = _165 * 78.84375f;
      float _167 = exp2(_166);
      float _168 = saturate(_167);
      float _169 = _142 * 0.009999999776482582f;
      float _170 = log2(_169);
      float _171 = _170 * 0.1593017578125f;
      float _172 = exp2(_171);
      float _173 = _172 * 18.8515625f;
      float _174 = _173 + 0.8359375f;
      float _175 = _172 * 18.6875f;
      float _176 = _175 + 1.0f;
      float _177 = _174 / _176;
      float _178 = log2(_177);
      float _179 = _178 * 78.84375f;
      float _180 = exp2(_179);
      float _181 = saturate(_180);
      float _182 = _168 + _155;
      float _183 = _182 * 0.5f;
      float _184 = dot(float3(_155, _168, _181), float3(6610.0f, -13613.0f, 7003.0f));
      float _185 = _184 * 0.000244140625f;
      float _186 = dot(float3(_155, _168, _181), float3(17933.0f, -17390.0f, -543.0f));
      float _187 = _186 * 0.000244140625f;
      float _189 = (HDRMapping_009x) * 0.009999999776482582f;
      float _191 = (HDRMapping_009z) * 0.009999999776482582f;
      float _193 = saturate(_183);
      float _194 = log2(_193);
      float _195 = _194 * 0.012683313339948654f;
      float _196 = exp2(_195);
      float _197 = _196 + -0.8359375f;
      float _198 = max(0.0f, _197);
      float _199 = _196 * 18.6875f;
      float _200 = 18.8515625f - _199;
      float _201 = _198 / _200;
      float _202 = log2(_201);
      float _203 = _202 * 6.277394771575928f;
      float _204 = exp2(_203);
      float _205 = _204 * 100.0f;
      bool _206 = (_189 == 0.0f);
      _241 = _205;
      do {
        if (!_206) {
          float _208 = max(_191, 0.0f);
          float _209 = _189 - _208;
          float _210 = _205 - _208;
          float _211 = _210 / _209;
          float _212 = saturate(_211);
          float _213 = _212 * 2.0f;
          float _214 = 3.0f - _213;
          float _215 = _212 * _212;
          float _216 = _215 * _214;
          float _217 = 1.0f - _216;
          bool _218 = !(_205 <= _191);
          _233 = 0.0f;
          do {
            if (_218) {
              bool _220 = !(_191 >= 0.0f);
              if (!_220) {
                float _222 = _191 + -1.0f;
                float _223 = -1.0f / _222;
                float _224 = 1.0f - _223;
                float _225 = _223 * _205;
                float _226 = _224 + _225;
                _233 = _226;
              } else {
                float _228 = -1.0f - _191;
                float _229 = -0.0f - _191;
                float _230 = _205 * _228;
                float _231 = _229 - _230;
                _233 = _231;
              }
            }
            float _234 = log2(_233);
            float _235 = _234 * (HDRMapping_009y);
            float _236 = exp2(_235);
            float _237 = _236 - _205;
            float _238 = _237 * _217;
            float _239 = _238 + _205;
            _241 = _239;
          } while (false);
        }
        bool _242 = (_14 == _11);
        bool _243 = (_241 > _11);
        bool _244 = _242 && _243;
        _290 = _11;
        do {
          if (!_244) {
            float _247 = 1.0f - (HDRMapping_009w);
            float _248 = _247 * _11;
            float _249 = _11 - _248;
            float _250 = exp2((HDRMapping_010x));
            float _251 = 1.0f / _250;
            float _252 = _251 * _241;
            float _253 = _249 / _250;
            float _254 = _11 - _253;
            float _255 = _252 - _11;
            bool _256 = (_255 < -0.0f);
            _285 = -0.0f;
            do {
              if (_256) {
                float _260 = (HDRMapping_014x) + -0.5f;
                float _261 = min((HDRMapping_010x), 1.0f);
                float _262 = _260 * _261;
                float _263 = _262 + 0.5f;
                float _264 = _263 * 2.0f;
                bool _265 = (_253 == 0.0f);
                float _266 = _249 / _253;
                float _267 = (_265 ? 1.0f : _266);
                float _268 = _264 * _267;
                float _269 = -0.0f - _255;
                float _270 = _268 * _254;
                float _271 = _270 / _248;
                float _272 = log2(_248);
                float _273 = log2(_254);
                float _274 = _271 * -0.6931471824645996f;
                float _275 = _274 * _273;
                float _276 = log2(_269);
                float _277 = _276 * _271;
                float _278 = _277 + _272;
                float _279 = _278 * 0.6931471824645996f;
                float _280 = _279 + _275;
                float _281 = _280 * 1.4426950216293335f;
                float _282 = exp2(_281);
                float _283 = -0.0f - _282;
                _285 = _283;
              }
              float _286 = _285 + _11;
              bool _287 = (_241 <= _14);
              float _288 = (_287 ? _241 : _286);
              _290 = _288;
            } while (false);
          }
          float _291 = _290 * 0.009999999776482582f;
          float _292 = log2(_291);
          float _293 = _292 * 0.1593017578125f;
          float _294 = exp2(_293);
          float _295 = _294 * 18.8515625f;
          float _296 = _295 + 0.8359375f;
          float _297 = _294 * 18.6875f;
          float _298 = _297 + 1.0f;
          float _299 = _296 / _298;
          float _300 = log2(_299);
          float _301 = _300 * 78.84375f;
          float _302 = exp2(_301);
          float _303 = saturate(_302);
          float _305 = _185 * (HDRMapping_010z);
          float _306 = _187 * (HDRMapping_010z);
          float _307 = _303 / _183;
          float _308 = _183 / _303;
          float _309 = min(_308, _307);
          float _310 = _305 * _309;
          float _311 = _306 * _309;
          float _312 = mad(0.008999999612569809f, _310, _303);
          float _313 = mad(0.11100000143051147f, _311, _312);
          float _314 = mad(-0.008999999612569809f, _310, _303);
          float _315 = mad(-0.11100000143051147f, _311, _314);
          float _316 = mad(0.5600000023841858f, _310, _303);
          float _317 = mad(-0.32100000977516174f, _311, _316);
          float _318 = saturate(_313);
          float _319 = log2(_318);
          float _320 = _319 * 0.012683313339948654f;
          float _321 = exp2(_320);
          float _322 = _321 + -0.8359375f;
          float _323 = max(0.0f, _322);
          float _324 = _321 * 18.6875f;
          float _325 = 18.8515625f - _324;
          float _326 = _323 / _325;
          float _327 = log2(_326);
          float _328 = _327 * 6.277394771575928f;
          float _329 = exp2(_328);
          float _330 = saturate(_315);
          float _331 = log2(_330);
          float _332 = _331 * 0.012683313339948654f;
          float _333 = exp2(_332);
          float _334 = _333 + -0.8359375f;
          float _335 = max(0.0f, _334);
          float _336 = _333 * 18.6875f;
          float _337 = 18.8515625f - _336;
          float _338 = _335 / _337;
          float _339 = log2(_338);
          float _340 = _339 * 6.277394771575928f;
          float _341 = exp2(_340);
          float _342 = _341 * 100.0f;
          float _343 = saturate(_317);
          float _344 = log2(_343);
          float _345 = _344 * 0.012683313339948654f;
          float _346 = exp2(_345);
          float _347 = _346 + -0.8359375f;
          float _348 = max(0.0f, _347);
          float _349 = _346 * 18.6875f;
          float _350 = 18.8515625f - _349;
          float _351 = _348 / _350;
          float _352 = log2(_351);
          float _353 = _352 * 6.277394771575928f;
          float _354 = exp2(_353);
          float _355 = _354 * 100.0f;
          float _356 = _329 * 207.10000610351562f;
          float _357 = mad(-1.3270000219345093f, _342, _356);
          float _358 = mad(0.2070000022649765f, _355, _357);
          float _359 = _329 * 36.5f;
          float _360 = mad(0.6809999942779541f, _342, _359);
          float _361 = mad(-0.04500000178813934f, _355, _360);
          float _362 = _329 * -4.900000095367432f;
          float _363 = mad(-0.05000000074505806f, _342, _362);
          float _364 = mad(1.187999963760376f, _355, _363);
          float _365 = _358 * (OCIOTransformXYZMatrix_004x);
          float _366 = mad((OCIOTransformXYZMatrix_004y), _361, _365);
          float _367 = mad((OCIOTransformXYZMatrix_004z), _364, _366);
          float _368 = _367 - _43;
          float _369 = abs(_368);
          float _370 = (HDRMapping_010w) * 0.009999999776482582f;
          bool _371 = (_369 < _370);
          if (_371) {
            bool _373 = !(_42 <= _189);
            _434 = 0.07999999821186066f;
            _435 = 0.15000000596046448f;
            _436 = 1.0f;
            _437 = 0.75f;
            if (_373) {
              bool _375 = (_42 < _14);
              _434 = 0.0f;
              _435 = 1.0f;
              _436 = 0.0f;
              _437 = 0.75f;
              if (!_375) {
                _434 = 1.0f;
                _435 = 0.0f;
                _436 = 0.0f;
                _437 = 0.75f;
              }
            }
          } else {
            float _378 = -0.0f - _42;
            bool _379 = (_42 >= _378);
            float _380 = abs(_42);
            float _381 = frac(_380);
            float _382 = -0.0f - _381;
            float _383 = (_379 ? _381 : _382);
            bool _384 = !(_383 <= 0.019999999552965164f);
            _434 = 0.25f;
            _435 = 0.25f;
            _436 = 0.25f;
            _437 = 0.75f;
            if (_384) {
              float _386 = -0.0f - _43;
              bool _387 = (_43 >= _386);
              float _388 = abs(_43);
              float _389 = frac(_388);
              float _390 = -0.0f - _389;
              float _391 = (_387 ? _389 : _390);
              bool _392 = !(_391 <= 0.019999999552965164f);
              _434 = 0.25f;
              _435 = 0.25f;
              _436 = 0.25f;
              _437 = 0.75f;
              if (_392) {
                bool _394 = (_383 <= _65);
                bool _395 = (_42 <= 1.0f);
                bool _396 = _395 && _394;
                do {
                  if (_396) {
                    float _398 = _43 * 10.0f;
                    float _399 = -0.0f - _398;
                    bool _400 = (_398 >= _399);
                    float _401 = abs(_398);
                    float _402 = frac(_401);
                    float _403 = -0.0f - _402;
                    float _404 = (_400 ? _402 : _403);
                    float _405 = _404 * 0.10000000149011612f;
                    bool _406 = !(_405 <= 0.019999999552965164f);
                    _434 = 0.3499999940395355f;
                    _435 = 0.3499999940395355f;
                    _436 = 0.3499999940395355f;
                    _437 = 0.75f;
                    if (!_406) {
                      break;
                    }
                  }
                  bool _408 = (_391 <= _65);
                  bool _409 = (_43 <= 1.0f);
                  bool _410 = _409 && _408;
                  do {
                    if (_410) {
                      float _412 = _42 * 10.0f;
                      float _413 = -0.0f - _412;
                      bool _414 = (_412 >= _413);
                      float _415 = abs(_412);
                      float _416 = frac(_415);
                      float _417 = -0.0f - _416;
                      float _418 = (_414 ? _416 : _417);
                      float _419 = _418 * 0.10000000149011612f;
                      bool _420 = !(_419 <= 0.019999999552965164f);
                      _434 = 0.3499999940395355f;
                      _435 = 0.3499999940395355f;
                      _436 = 0.3499999940395355f;
                      _437 = 0.75f;
                      if (!_420) {
                        break;
                      }
                    }
                    _434 = 0.11999999731779099f;
                    _435 = 0.11999999731779099f;
                    _436 = 0.11999999731779099f;
                    _437 = 0.75f;
                    if (_52) {
                      float _423 = _43 * 2.0f;
                      float _424 = -0.0f - _423;
                      bool _425 = (_423 >= _424);
                      float _426 = abs(_423);
                      float _427 = frac(_426);
                      float _428 = -0.0f - _427;
                      float _429 = (_425 ? _427 : _428);
                      float _430 = _429 * 0.5f;
                      bool _431 = !(_430 <= 0.019999999552965164f);
                      _434 = 0.11999999731779099f;
                      _435 = 0.11999999731779099f;
                      _436 = 0.11999999731779099f;
                      _437 = 0.75f;
                      if (_431) {
                        _434 = 0.05000000074505806f;
                        _435 = 0.05000000074505806f;
                        _436 = 0.05000000074505806f;
                        _437 = 0.75f;
                      }
                    }
                  } while (false);
                } while (false);
              }
            }
          }
        } while (false);
      } while (false);
    } while (false);
  }
  SV_Target.x = _434;
  SV_Target.y = _435;
  SV_Target.z = _436;
  SV_Target.w = _437;
  return SV_Target;
}
