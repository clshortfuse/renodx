#include "./shared.h"

Texture2D<float4> g_xTexture : register(t0);

cbuffer FXAAGammaAndClampConsts : register(b0) {
  float g_fFXAALinearGamma : packoffset(c000.x);
  float g_fFXAAClampValue : packoffset(c000.y);
  float2 g_xRcpFrame : packoffset(c000.z);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _14 = dot(float3(_9.x, _9.y, _9.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float4 _15 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(0, 1));
  float _19 = dot(float3(_15.x, _15.y, _15.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float4 _20 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, 0));
  float _24 = dot(float3(_20.x, _20.y, _20.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float4 _25 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(0, -1));
  float _29 = dot(float3(_25.x, _25.y, _25.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float4 _30 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(-1, 0));
  float _34 = dot(float3(_30.x, _30.y, _30.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float _35 = max(_19, _14);
  float _36 = min(_19, _14);
  float _37 = max(_24, _35);
  float _38 = min(_24, _36);
  float _39 = max(_29, _34);
  float _40 = min(_29, _34);
  float _41 = max(_39, _37);
  float _42 = min(_40, _38);
  float _43 = _41 * 0.1666666716337204f;
  float _44 = _41 - _42;
  float _45 = max(0.0833333358168602f, _43);
  bool _46 = (_44 < _45);
  float _105;
  float _108;
  float _111;
  float _123;
  float _133;
  float _138;
  float _158;
  float _175;
  float _180;
  float _186;
  float _191;
  float _200;
  float _208;
  float _212;
  float _216;
  float _225;
  float _230;
  float _236;
  float _241;
  float _250;
  float _258;
  float _262;
  float _266;
  float _275;
  float _280;
  float _286;
  float _291;
  float _300;
  float _308;
  float _312;
  float _316;
  float _325;
  float _330;
  float _336;
  float _341;
  float _350;
  float _358;
  float _362;
  float _366;
  float _375;
  float _380;
  float _386;
  float _391;
  float _400;
  float _408;
  float _412;
  float _416;
  float _425;
  float _430;
  float _436;
  float _441;
  float _450;
  float _458;
  float _462;
  float _466;
  float _475;
  float _480;
  float _485;
  float _490;
  float _491;
  float _492;
  float _493;
  float _494;
  float _495;
  float _501;
  float _505;
  float _524;
  float _529;
  float _535;
  float _536;
  float _537;
  float _538;
  [branch]
  if (!_46) {
    float4 _48 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(-1, -1));
    float _52 = dot(float3(_48.x, _48.y, _48.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
    float4 _53 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, 1));
    float _57 = dot(float3(_53.x, _53.y, _53.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
    float4 _58 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, -1));
    float _62 = dot(float3(_58.x, _58.y, _58.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
    float4 _63 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(-1, 1));
    float _67 = dot(float3(_63.x, _63.y, _63.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
    float _68 = _29 + _19;
    float _69 = _34 + _24;
    float _70 = 1.0f / _44;
    float _71 = _69 + _68;
    float _72 = _14 * 2.0f;
    float _73 = _68 - _72;
    float _74 = _69 - _72;
    float _75 = _62 + _57;
    float _76 = _52 + _62;
    float _77 = _24 * 2.0f;
    float _78 = _75 - _77;
    float _79 = _29 * 2.0f;
    float _80 = _76 - _79;
    float _81 = _67 + _52;
    float _82 = _57 + _67;
    float _83 = abs(_73);
    float _84 = _83 * 2.0f;
    float _85 = abs(_78);
    float _86 = _84 + _85;
    float _87 = abs(_74);
    float _88 = _87 * 2.0f;
    float _89 = abs(_80);
    float _90 = _88 + _89;
    float _91 = _34 * 2.0f;
    float _92 = _81 - _91;
    float _93 = _19 * 2.0f;
    float _94 = _82 - _93;
    float _95 = abs(_92);
    float _96 = _86 + _95;
    float _97 = abs(_94);
    float _98 = _90 + _97;
    bool _99 = (_96 >= _98);
    float _100 = _71 * 2.0f;
    float _101 = _75 + _100;
    float _102 = _101 + _81;
    [branch]
    if (!_99) {
      _105 = _34;
    } else {
      _105 = _29;
    }
    [branch]
    if (!_99) {
      _108 = _24;
    } else {
      _108 = _19;
    }
    [branch]
    if (_99) {
      _111 = g_xRcpFrame.y;
    } else {
      _111 = g_xRcpFrame.x;
    }
    float _112 = _102 * 0.0833333358168602f;
    float _113 = _112 - _14;
    float _114 = _105 - _14;
    float _115 = _108 - _14;
    float _116 = abs(_114);
    float _117 = abs(_115);
    bool _118 = (_116 >= _117);
    float _119 = max(_116, _117);
    [branch]
    if (_118) {
      float _121 = -0.0f - _111;
      _123 = _121;
    } else {
      _123 = _111;
    }
    float _124 = abs(_113);
    float _125 = _124 * _70;
    float _126 = saturate(_125);
    float _127 = select(_99, g_xRcpFrame.x, 0.0f);
    float _128 = select(_99, 0.0f, g_xRcpFrame.y);
    [branch]
    if (!_99) {
      float _130 = _123 * 0.5f;
      float _131 = _130 + TEXCOORD.x;
      _133 = _131;
    } else {
      _133 = TEXCOORD.x;
    }
    [branch]
    if (_99) {
      float _135 = _123 * 0.5f;
      float _136 = _135 + TEXCOORD.y;
      _138 = _136;
    } else {
      _138 = TEXCOORD.y;
    }
    float _139 = _133 - _127;
    float _140 = _138 - _128;
    float _141 = _133 + _127;
    float _142 = _138 + _128;
    float _143 = _126 * 2.0f;
    float _144 = 3.0f - _143;
    float4 _145 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_139, _140), 0.0f);
    float _149 = dot(float3(_145.x, _145.y, _145.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
    float _150 = _126 * _126;
    float4 _151 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_141, _142), 0.0f);
    float _155 = dot(float3(_151.x, _151.y, _151.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
    [branch]
    if (!_118) {
      _158 = _108;
    } else {
      _158 = _105;
    }
    float _159 = _14 + _158;
    float _160 = _119 * 0.25f;
    float _161 = _159 * 0.5f;
    float _162 = _14 - _161;
    float _163 = _150 * _144;
    bool _164 = (_162 < 0.0f);
    float _165 = _149 - _161;
    float _166 = _155 - _161;
    float _167 = abs(_165);
    bool _168 = (_167 >= _160);
    float _169 = abs(_166);
    bool _170 = (_169 >= _160);
    [branch]
    if (!_168) {
      float _172 = _127 * 1.5f;
      float _173 = _139 - _172;
      _175 = _173;
    } else {
      _175 = _139;
    }
    [branch]
    if (!_168) {
      float _177 = _128 * 1.5f;
      float _178 = _140 - _177;
      _180 = _178;
    } else {
      _180 = _140;
    }
    bool _181 = _168 && _170;
    [branch]
    if (!_170) {
      float _183 = _127 * 1.5f;
      float _184 = _141 + _183;
      _186 = _184;
    } else {
      _186 = _141;
    }
    [branch]
    if (!_170) {
      float _188 = _128 * 1.5f;
      float _189 = _142 + _188;
      _191 = _189;
    } else {
      _191 = _142;
    }
    [branch]
    if (!_181) {
      [branch]
      if (!_168) {
        float4 _194 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_175, _180), 0.0f);
        float _198 = dot(float3(_194.x, _194.y, _194.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
        _200 = _198;
      } else {
        _200 = _165;
      }
      [branch]
      if (!_170) {
        float4 _202 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_186, _191), 0.0f);
        float _206 = dot(float3(_202.x, _202.y, _202.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
        _208 = _206;
      } else {
        _208 = _166;
      }
      [branch]
      if (!_168) {
        float _210 = _200 - _161;
        _212 = _210;
      } else {
        _212 = _200;
      }
      [branch]
      if (!_170) {
        float _214 = _208 - _161;
        _216 = _214;
      } else {
        _216 = _208;
      }
      float _217 = abs(_212);
      bool _218 = (_217 >= _160);
      float _219 = abs(_216);
      bool _220 = (_219 >= _160);
      [branch]
      if (!_218) {
        float _222 = _127 * 2.0f;
        float _223 = _175 - _222;
        _225 = _223;
      } else {
        _225 = _175;
      }
      [branch]
      if (!_218) {
        float _227 = _128 * 2.0f;
        float _228 = _180 - _227;
        _230 = _228;
      } else {
        _230 = _180;
      }
      bool _231 = _218 && _220;
      [branch]
      if (!_220) {
        float _233 = _127 * 2.0f;
        float _234 = _186 + _233;
        _236 = _234;
      } else {
        _236 = _186;
      }
      [branch]
      if (!_220) {
        float _238 = _128 * 2.0f;
        float _239 = _191 + _238;
        _241 = _239;
      } else {
        _241 = _191;
      }
      [branch]
      if (!_231) {
        [branch]
        if (!_218) {
          float4 _244 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_225, _230), 0.0f);
          float _248 = dot(float3(_244.x, _244.y, _244.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
          _250 = _248;
        } else {
          _250 = _212;
        }
        [branch]
        if (!_220) {
          float4 _252 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_236, _241), 0.0f);
          float _256 = dot(float3(_252.x, _252.y, _252.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
          _258 = _256;
        } else {
          _258 = _216;
        }
        [branch]
        if (!_218) {
          float _260 = _250 - _161;
          _262 = _260;
        } else {
          _262 = _250;
        }
        [branch]
        if (!_220) {
          float _264 = _258 - _161;
          _266 = _264;
        } else {
          _266 = _258;
        }
        float _267 = abs(_262);
        bool _268 = (_267 >= _160);
        float _269 = abs(_266);
        bool _270 = (_269 >= _160);
        [branch]
        if (!_268) {
          float _272 = _127 * 2.0f;
          float _273 = _225 - _272;
          _275 = _273;
        } else {
          _275 = _225;
        }
        [branch]
        if (!_268) {
          float _277 = _128 * 2.0f;
          float _278 = _230 - _277;
          _280 = _278;
        } else {
          _280 = _230;
        }
        bool _281 = _268 && _270;
        [branch]
        if (!_270) {
          float _283 = _127 * 2.0f;
          float _284 = _236 + _283;
          _286 = _284;
        } else {
          _286 = _236;
        }
        [branch]
        if (!_270) {
          float _288 = _128 * 2.0f;
          float _289 = _241 + _288;
          _291 = _289;
        } else {
          _291 = _241;
        }
        [branch]
        if (!_281) {
          [branch]
          if (!_268) {
            float4 _294 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_275, _280), 0.0f);
            float _298 = dot(float3(_294.x, _294.y, _294.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
            _300 = _298;
          } else {
            _300 = _262;
          }
          [branch]
          if (!_270) {
            float4 _302 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_286, _291), 0.0f);
            float _306 = dot(float3(_302.x, _302.y, _302.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
            _308 = _306;
          } else {
            _308 = _266;
          }
          [branch]
          if (!_268) {
            float _310 = _300 - _161;
            _312 = _310;
          } else {
            _312 = _300;
          }
          [branch]
          if (!_270) {
            float _314 = _308 - _161;
            _316 = _314;
          } else {
            _316 = _308;
          }
          float _317 = abs(_312);
          bool _318 = (_317 >= _160);
          float _319 = abs(_316);
          bool _320 = (_319 >= _160);
          [branch]
          if (!_318) {
            float _322 = _127 * 2.0f;
            float _323 = _275 - _322;
            _325 = _323;
          } else {
            _325 = _275;
          }
          [branch]
          if (!_318) {
            float _327 = _128 * 2.0f;
            float _328 = _280 - _327;
            _330 = _328;
          } else {
            _330 = _280;
          }
          bool _331 = _318 && _320;
          [branch]
          if (!_320) {
            float _333 = _127 * 2.0f;
            float _334 = _286 + _333;
            _336 = _334;
          } else {
            _336 = _286;
          }
          [branch]
          if (!_320) {
            float _338 = _128 * 2.0f;
            float _339 = _291 + _338;
            _341 = _339;
          } else {
            _341 = _291;
          }
          [branch]
          if (!_331) {
            [branch]
            if (!_318) {
              float4 _344 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_325, _330), 0.0f);
              float _348 = dot(float3(_344.x, _344.y, _344.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
              _350 = _348;
            } else {
              _350 = _312;
            }
            [branch]
            if (!_320) {
              float4 _352 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_336, _341), 0.0f);
              float _356 = dot(float3(_352.x, _352.y, _352.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
              _358 = _356;
            } else {
              _358 = _316;
            }
            [branch]
            if (!_318) {
              float _360 = _350 - _161;
              _362 = _360;
            } else {
              _362 = _350;
            }
            [branch]
            if (!_320) {
              float _364 = _358 - _161;
              _366 = _364;
            } else {
              _366 = _358;
            }
            float _367 = abs(_362);
            bool _368 = (_367 >= _160);
            float _369 = abs(_366);
            bool _370 = (_369 >= _160);
            [branch]
            if (!_368) {
              float _372 = _127 * 2.0f;
              float _373 = _325 - _372;
              _375 = _373;
            } else {
              _375 = _325;
            }
            [branch]
            if (!_368) {
              float _377 = _128 * 2.0f;
              float _378 = _330 - _377;
              _380 = _378;
            } else {
              _380 = _330;
            }
            bool _381 = _368 && _370;
            [branch]
            if (!_370) {
              float _383 = _127 * 2.0f;
              float _384 = _336 + _383;
              _386 = _384;
            } else {
              _386 = _336;
            }
            [branch]
            if (!_370) {
              float _388 = _128 * 2.0f;
              float _389 = _341 + _388;
              _391 = _389;
            } else {
              _391 = _341;
            }
            [branch]
            if (!_381) {
              [branch]
              if (!_368) {
                float4 _394 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_375, _380), 0.0f);
                float _398 = dot(float3(_394.x, _394.y, _394.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
                _400 = _398;
              } else {
                _400 = _362;
              }
              [branch]
              if (!_370) {
                float4 _402 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_386, _391), 0.0f);
                float _406 = dot(float3(_402.x, _402.y, _402.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
                _408 = _406;
              } else {
                _408 = _366;
              }
              [branch]
              if (!_368) {
                float _410 = _400 - _161;
                _412 = _410;
              } else {
                _412 = _400;
              }
              [branch]
              if (!_370) {
                float _414 = _408 - _161;
                _416 = _414;
              } else {
                _416 = _408;
              }
              float _417 = abs(_412);
              bool _418 = (_417 >= _160);
              float _419 = abs(_416);
              bool _420 = (_419 >= _160);
              [branch]
              if (!_418) {
                float _422 = _127 * 4.0f;
                float _423 = _375 - _422;
                _425 = _423;
              } else {
                _425 = _375;
              }
              [branch]
              if (!_418) {
                float _427 = _128 * 4.0f;
                float _428 = _380 - _427;
                _430 = _428;
              } else {
                _430 = _380;
              }
              bool _431 = _418 && _420;
              [branch]
              if (!_420) {
                float _433 = _127 * 4.0f;
                float _434 = _386 + _433;
                _436 = _434;
              } else {
                _436 = _386;
              }
              [branch]
              if (!_420) {
                float _438 = _128 * 4.0f;
                float _439 = _391 + _438;
                _441 = _439;
              } else {
                _441 = _391;
              }
              [branch]
              if (!_431) {
                [branch]
                if (!_418) {
                  float4 _444 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_425, _430), 0.0f);
                  float _448 = dot(float3(_444.x, _444.y, _444.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
                  _450 = _448;
                } else {
                  _450 = _412;
                }
                [branch]
                if (!_420) {
                  float4 _452 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_436, _441), 0.0f);
                  float _456 = dot(float3(_452.x, _452.y, _452.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
                  _458 = _456;
                } else {
                  _458 = _416;
                }
                [branch]
                if (!_418) {
                  float _460 = _450 - _161;
                  _462 = _460;
                } else {
                  _462 = _450;
                }
                [branch]
                if (!_420) {
                  float _464 = _458 - _161;
                  _466 = _464;
                } else {
                  _466 = _458;
                }
                float _467 = abs(_462);
                bool _468 = (_467 >= _160);
                float _469 = abs(_466);
                bool _470 = (_469 >= _160);
                [branch]
                if (!_468) {
                  float _472 = _127 * 8.0f;
                  float _473 = _425 - _472;
                  _475 = _473;
                } else {
                  _475 = _425;
                }
                [branch]
                if (!_468) {
                  float _477 = _128 * 8.0f;
                  float _478 = _430 - _477;
                  _480 = _478;
                } else {
                  _480 = _430;
                }
                [branch]
                if (!_470) {
                  float _482 = _127 * 8.0f;
                  float _483 = _436 + _482;
                  _485 = _483;
                } else {
                  _485 = _436;
                }
                [branch]
                if (!_470) {
                  float _487 = _128 * 8.0f;
                  float _488 = _441 + _487;
                  _490 = _475;
                  _491 = _480;
                  _492 = _485;
                  _493 = _488;
                  _494 = _462;
                  _495 = _466;
                } else {
                  _490 = _475;
                  _491 = _480;
                  _492 = _485;
                  _493 = _441;
                  _494 = _462;
                  _495 = _466;
                }
              } else {
                _490 = _425;
                _491 = _430;
                _492 = _436;
                _493 = _441;
                _494 = _412;
                _495 = _416;
              }
            } else {
              _490 = _375;
              _491 = _380;
              _492 = _386;
              _493 = _391;
              _494 = _362;
              _495 = _366;
            }
          } else {
            _490 = _325;
            _491 = _330;
            _492 = _336;
            _493 = _341;
            _494 = _312;
            _495 = _316;
          }
        } else {
          _490 = _275;
          _491 = _280;
          _492 = _286;
          _493 = _291;
          _494 = _262;
          _495 = _266;
        }
      } else {
        _490 = _225;
        _491 = _230;
        _492 = _236;
        _493 = _241;
        _494 = _212;
        _495 = _216;
      }
    } else {
      _490 = _175;
      _491 = _180;
      _492 = _186;
      _493 = _191;
      _494 = _165;
      _495 = _166;
    }
    float _496 = TEXCOORD.x - _490;
    float _497 = _492 - TEXCOORD.x;
    [branch]
    if (!_99) {
      float _499 = TEXCOORD.y - _491;
      _501 = _499;
    } else {
      _501 = _496;
    }
    [branch]
    if (!_99) {
      float _503 = _493 - TEXCOORD.y;
      _505 = _503;
    } else {
      _505 = _497;
    }
    bool _506 = (_494 < 0.0f);
    float _507 = _505 + _501;
    bool _508 = (_495 < 0.0f);
    float _509 = 1.0f / _507;
    bool _510 = (_501 < _505);
    float _511 = min(_501, _505);
    bool _512 = select(_510, _506, _508);
    bool _513 = _164 ^ _512;
    float _514 = _511 * _509;
    float _515 = 0.5f - _514;
    float _516 = _163 * _163;
    float _517 = _516 * 0.75f;
    float _518 = select(_513, _515, 0.0f);
    float _519 = max(_518, _517);
    [branch]
    if (!_99) {
      float _521 = _519 * _123;
      float _522 = _521 + TEXCOORD.x;
      _524 = _522;
    } else {
      _524 = TEXCOORD.x;
    }
    [branch]
    if (_99) {
      float _526 = _519 * _123;
      float _527 = _526 + TEXCOORD.y;
      _529 = _527;
    } else {
      _529 = TEXCOORD.y;
    }
    float4 _530 = g_xTexture.SampleLevel(g_xBilinearClamp, float2(_524, _529), 0.0f);
    _535 = _530.x;
    _536 = _530.y;
    _537 = _530.z;
    _538 = _14;
  } else {
    _535 = _9.x;
    _536 = _9.y;
    _537 = _9.z;
    _538 = _9.w;
  }
  // RenoDX: output the FXAA colour before the gamma pow and clamp; vanilla gamma/clamp kept below for reference
  SV_Target.x = _535;
  SV_Target.y = _536;
  SV_Target.z = _537;
  SV_Target.w = 1.0f;
  return SV_Target;
  // float _539 = abs(_535);
  // float _540 = abs(_536);
  // float _541 = abs(_537);
  // float _542 = abs(_538);
  // float _545 = log2(_539);
  // float _546 = log2(_540);
  // float _547 = log2(_541);
  // float _548 = log2(_542);
  // float _549 = _545 * g_fFXAALinearGamma;
  // float _550 = _546 * g_fFXAALinearGamma;
  // float _551 = _547 * g_fFXAALinearGamma;
  // float _552 = _548 * g_fFXAALinearGamma;
  // float _553 = exp2(_549);
  // float _554 = exp2(_550);
  // float _555 = exp2(_551);
  // float _556 = exp2(_552);
  // float _557 = max(_553, g_fFXAAClampValue);
  // float _558 = max(_554, g_fFXAAClampValue);
  // float _559 = max(_555, g_fFXAAClampValue);
  // float _560 = max(_556, g_fFXAAClampValue);
  // SV_Target.x = _557;
  // SV_Target.y = _558;
  // SV_Target.z = _559;
  // SV_Target.w = _560;
  // return SV_Target;
}
