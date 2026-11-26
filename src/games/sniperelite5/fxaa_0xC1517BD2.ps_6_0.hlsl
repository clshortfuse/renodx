#include "./shared.h"
Texture2D<float4> g_xPostToneMapFrameBufferTexture : register(t2);

cbuffer FXAAConstants : register(b9) {
  float2 g_xRcpFrame : packoffset(c000.x);
};

SamplerState g_xBilinearClamp : register(s3);

// RenoDX: bilinear fetch where brighter-than-SDR-white taps are down-weighted.
float4 SampleHighlightWeighted(float2 uv) {
  uint width, height;
  g_xPostToneMapFrameBufferTexture.GetDimensions(width, height);
  float2 position = uv * float2(width, height) - 0.5f;
  int2 base = int2(floor(position));
  float2 f = position - float2(base);
  int2 last = int2(width, height) - 1;
  float4 sum = 0.f;
  float weightSum = 0.f;
  [unroll]
  for (int i = 0; i < 4; i++) {
    int2 offset = int2(i & 1, i >> 1);
    float4 tap = g_xPostToneMapFrameBufferTexture.Load(int3(clamp(base + offset, int2(0, 0), last), 0));
    float2 b = select(offset == 1, f, 1.f - f);
    float w = b.x * b.y * pow(max(1.f, renodx::color::y::from::BT709(tap.rgb)), -CUSTOM_AA_HIGHLIGHT_WEIGHT);
    sum += tap * w;
    weightSum += w;
  }
  return sum / max(weightSum, 1e-6f);
}

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float4 _14 = g_xPostToneMapFrameBufferTexture.GatherAlpha(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _18 = g_xPostToneMapFrameBufferTexture.GatherAlpha(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), int2(-1, -1));
  float _22 = max(_14.x, _9.w);
  float _23 = min(_14.x, _9.w);
  float _24 = max(_14.z, _22);
  float _25 = min(_14.z, _23);
  float _26 = max(_18.z, _18.x);
  float _27 = min(_18.z, _18.x);
  float _28 = max(_26, _24);
  float _29 = min(_27, _25);
  float _30 = _28 * 0.1666666716337204f;
  float _31 = _28 - _29;
  float _32 = max(0.0833333358168602f, _30);
  bool _33 = (_31 < _32);
  float _76;
  float _79;
  float _82;
  float _94;
  float _104;
  float _109;
  float _123;
  float _140;
  float _145;
  float _151;
  float _156;
  float _162;
  float _167;
  float _171;
  float _175;
  float _184;
  float _189;
  float _195;
  float _200;
  float _206;
  float _211;
  float _215;
  float _219;
  float _228;
  float _233;
  float _239;
  float _244;
  float _250;
  float _255;
  float _259;
  float _263;
  float _272;
  float _277;
  float _283;
  float _288;
  float _294;
  float _299;
  float _303;
  float _307;
  float _316;
  float _321;
  float _327;
  float _332;
  float _338;
  float _343;
  float _347;
  float _351;
  float _360;
  float _365;
  float _371;
  float _376;
  float _382;
  float _387;
  float _391;
  float _395;
  float _404;
  float _409;
  float _415;
  float _420;
  float _426;
  float _431;
  float _435;
  float _439;
  float _448;
  float _453;
  float _459;
  float _464;
  float _470;
  float _475;
  float _479;
  float _483;
  float _492;
  float _497;
  float _503;
  float _508;
  float _514;
  float _519;
  float _523;
  float _527;
  float _536;
  float _541;
  float _547;
  float _552;
  float _558;
  float _563;
  float _567;
  float _571;
  float _580;
  float _585;
  float _590;
  float _595;
  float _596;
  float _597;
  float _598;
  float _599;
  float _600;
  float _606;
  float _610;
  float _629;
  float _634;
  float _640;
  float _641;
  float _642;
  [branch]
  if (!_33) {
    float4 _35 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, -1));
    float4 _37 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(-1, 1));
    float _39 = _18.z + _14.x;
    float _40 = _18.x + _14.z;
    float _41 = 1.0f / _31;
    float _42 = _39 + _40;
    float _43 = _9.w * 2.0f;
    float _44 = _39 - _43;
    float _45 = _40 - _43;
    float _46 = _35.w + _14.y;
    float _47 = _18.w + _35.w;
    float _48 = _14.z * 2.0f;
    float _49 = _46 - _48;
    float _50 = _18.z * 2.0f;
    float _51 = _47 - _50;
    float _52 = _37.w + _18.w;
    float _53 = _14.y + _37.w;
    float _54 = abs(_44);
    float _55 = _54 * 2.0f;
    float _56 = abs(_49);
    float _57 = _55 + _56;
    float _58 = abs(_45);
    float _59 = _58 * 2.0f;
    float _60 = abs(_51);
    float _61 = _59 + _60;
    float _62 = _18.x * 2.0f;
    float _63 = _52 - _62;
    float _64 = _14.x * 2.0f;
    float _65 = _53 - _64;
    float _66 = abs(_63);
    float _67 = _57 + _66;
    float _68 = abs(_65);
    float _69 = _61 + _68;
    bool _70 = (_67 >= _69);
    float _71 = _42 * 2.0f;
    float _72 = _46 + _71;
    float _73 = _72 + _52;
    [branch]
    if (!_70) {
      _76 = _18.x;
    } else {
      _76 = _18.z;
    }
    [branch]
    if (!_70) {
      _79 = _14.z;
    } else {
      _79 = _14.x;
    }
    [branch]
    if (_70) {
      _82 = g_xRcpFrame.y;
    } else {
      _82 = g_xRcpFrame.x;
    }
    float _83 = _73 * 0.0833333358168602f;
    float _84 = _83 - _9.w;
    float _85 = _76 - _9.w;
    float _86 = _79 - _9.w;
    float _87 = abs(_85);
    float _88 = abs(_86);
    bool _89 = (_87 >= _88);
    float _90 = max(_87, _88);
    [branch]
    if (_89) {
      float _92 = -0.0f - _82;
      _94 = _92;
    } else {
      _94 = _82;
    }
    float _95 = abs(_84);
    float _96 = _95 * _41;
    float _97 = saturate(_96);
    float _98 = select(_70, g_xRcpFrame.x, 0.0f);
    float _99 = select(_70, 0.0f, g_xRcpFrame.y);
    [branch]
    if (!_70) {
      float _101 = _94 * 0.5f;
      float _102 = _101 + TEXCOORD.x;
      _104 = _102;
    } else {
      _104 = TEXCOORD.x;
    }
    [branch]
    if (_70) {
      float _106 = _94 * 0.5f;
      float _107 = _106 + TEXCOORD.y;
      _109 = _107;
    } else {
      _109 = TEXCOORD.y;
    }
    float _110 = _104 - _98;
    float _111 = _109 - _99;
    float _112 = _104 + _98;
    float _113 = _109 + _99;
    float _114 = _97 * 2.0f;
    float _115 = 3.0f - _114;
    float4 _116 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_110, _111), 0.0f);
    float _118 = _97 * _97;
    float4 _119 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_112, _113), 0.0f);
    [branch]
    if (!_89) {
      _123 = _79;
    } else {
      _123 = _76;
    }
    float _124 = _9.w + _123;
    float _125 = _90 * 0.25f;
    float _126 = _124 * 0.5f;
    float _127 = _9.w - _126;
    float _128 = _118 * _115;
    bool _129 = (_127 < 0.0f);
    float _130 = _116.w - _126;
    float _131 = _119.w - _126;
    float _132 = abs(_130);
    bool _133 = (_132 >= _125);
    float _134 = abs(_131);
    bool _135 = (_134 >= _125);
    [branch]
    if (!_133) {
      float _137 = _98 * 1.5f;
      float _138 = _110 - _137;
      _140 = _138;
    } else {
      _140 = _110;
    }
    [branch]
    if (!_133) {
      float _142 = _99 * 1.5f;
      float _143 = _111 - _142;
      _145 = _143;
    } else {
      _145 = _111;
    }
    bool _146 = _133 && _135;
    [branch]
    if (!_135) {
      float _148 = _98 * 1.5f;
      float _149 = _112 + _148;
      _151 = _149;
    } else {
      _151 = _112;
    }
    [branch]
    if (!_135) {
      float _153 = _99 * 1.5f;
      float _154 = _113 + _153;
      _156 = _154;
    } else {
      _156 = _113;
    }
    [branch]
    if (!_146) {
      [branch]
      if (!_133) {
        float4 _159 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_140, _145), 0.0f);
        _162 = _159.w;
      } else {
        _162 = _130;
      }
      [branch]
      if (!_135) {
        float4 _164 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_151, _156), 0.0f);
        _167 = _164.w;
      } else {
        _167 = _131;
      }
      [branch]
      if (!_133) {
        float _169 = _162 - _126;
        _171 = _169;
      } else {
        _171 = _162;
      }
      [branch]
      if (!_135) {
        float _173 = _167 - _126;
        _175 = _173;
      } else {
        _175 = _167;
      }
      float _176 = abs(_171);
      bool _177 = (_176 >= _125);
      float _178 = abs(_175);
      bool _179 = (_178 >= _125);
      [branch]
      if (!_177) {
        float _181 = _98 * 2.0f;
        float _182 = _140 - _181;
        _184 = _182;
      } else {
        _184 = _140;
      }
      [branch]
      if (!_177) {
        float _186 = _99 * 2.0f;
        float _187 = _145 - _186;
        _189 = _187;
      } else {
        _189 = _145;
      }
      bool _190 = _177 && _179;
      [branch]
      if (!_179) {
        float _192 = _98 * 2.0f;
        float _193 = _151 + _192;
        _195 = _193;
      } else {
        _195 = _151;
      }
      [branch]
      if (!_179) {
        float _197 = _99 * 2.0f;
        float _198 = _156 + _197;
        _200 = _198;
      } else {
        _200 = _156;
      }
      [branch]
      if (!_190) {
        [branch]
        if (!_177) {
          float4 _203 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_184, _189), 0.0f);
          _206 = _203.w;
        } else {
          _206 = _171;
        }
        [branch]
        if (!_179) {
          float4 _208 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_195, _200), 0.0f);
          _211 = _208.w;
        } else {
          _211 = _175;
        }
        [branch]
        if (!_177) {
          float _213 = _206 - _126;
          _215 = _213;
        } else {
          _215 = _206;
        }
        [branch]
        if (!_179) {
          float _217 = _211 - _126;
          _219 = _217;
        } else {
          _219 = _211;
        }
        float _220 = abs(_215);
        bool _221 = (_220 >= _125);
        float _222 = abs(_219);
        bool _223 = (_222 >= _125);
        [branch]
        if (!_221) {
          float _225 = _98 * 2.0f;
          float _226 = _184 - _225;
          _228 = _226;
        } else {
          _228 = _184;
        }
        [branch]
        if (!_221) {
          float _230 = _99 * 2.0f;
          float _231 = _189 - _230;
          _233 = _231;
        } else {
          _233 = _189;
        }
        bool _234 = _221 && _223;
        [branch]
        if (!_223) {
          float _236 = _98 * 2.0f;
          float _237 = _195 + _236;
          _239 = _237;
        } else {
          _239 = _195;
        }
        [branch]
        if (!_223) {
          float _241 = _99 * 2.0f;
          float _242 = _200 + _241;
          _244 = _242;
        } else {
          _244 = _200;
        }
        [branch]
        if (!_234) {
          [branch]
          if (!_221) {
            float4 _247 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_228, _233), 0.0f);
            _250 = _247.w;
          } else {
            _250 = _215;
          }
          [branch]
          if (!_223) {
            float4 _252 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_239, _244), 0.0f);
            _255 = _252.w;
          } else {
            _255 = _219;
          }
          [branch]
          if (!_221) {
            float _257 = _250 - _126;
            _259 = _257;
          } else {
            _259 = _250;
          }
          [branch]
          if (!_223) {
            float _261 = _255 - _126;
            _263 = _261;
          } else {
            _263 = _255;
          }
          float _264 = abs(_259);
          bool _265 = (_264 >= _125);
          float _266 = abs(_263);
          bool _267 = (_266 >= _125);
          [branch]
          if (!_265) {
            float _269 = _98 * 2.0f;
            float _270 = _228 - _269;
            _272 = _270;
          } else {
            _272 = _228;
          }
          [branch]
          if (!_265) {
            float _274 = _99 * 2.0f;
            float _275 = _233 - _274;
            _277 = _275;
          } else {
            _277 = _233;
          }
          bool _278 = _265 && _267;
          [branch]
          if (!_267) {
            float _280 = _98 * 2.0f;
            float _281 = _239 + _280;
            _283 = _281;
          } else {
            _283 = _239;
          }
          [branch]
          if (!_267) {
            float _285 = _99 * 2.0f;
            float _286 = _244 + _285;
            _288 = _286;
          } else {
            _288 = _244;
          }
          [branch]
          if (!_278) {
            [branch]
            if (!_265) {
              float4 _291 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_272, _277), 0.0f);
              _294 = _291.w;
            } else {
              _294 = _259;
            }
            [branch]
            if (!_267) {
              float4 _296 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_283, _288), 0.0f);
              _299 = _296.w;
            } else {
              _299 = _263;
            }
            [branch]
            if (!_265) {
              float _301 = _294 - _126;
              _303 = _301;
            } else {
              _303 = _294;
            }
            [branch]
            if (!_267) {
              float _305 = _299 - _126;
              _307 = _305;
            } else {
              _307 = _299;
            }
            float _308 = abs(_303);
            bool _309 = (_308 >= _125);
            float _310 = abs(_307);
            bool _311 = (_310 >= _125);
            [branch]
            if (!_309) {
              float _313 = _98 * 2.0f;
              float _314 = _272 - _313;
              _316 = _314;
            } else {
              _316 = _272;
            }
            [branch]
            if (!_309) {
              float _318 = _99 * 2.0f;
              float _319 = _277 - _318;
              _321 = _319;
            } else {
              _321 = _277;
            }
            bool _322 = _309 && _311;
            [branch]
            if (!_311) {
              float _324 = _98 * 2.0f;
              float _325 = _283 + _324;
              _327 = _325;
            } else {
              _327 = _283;
            }
            [branch]
            if (!_311) {
              float _329 = _99 * 2.0f;
              float _330 = _288 + _329;
              _332 = _330;
            } else {
              _332 = _288;
            }
            [branch]
            if (!_322) {
              [branch]
              if (!_309) {
                float4 _335 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_316, _321), 0.0f);
                _338 = _335.w;
              } else {
                _338 = _303;
              }
              [branch]
              if (!_311) {
                float4 _340 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_327, _332), 0.0f);
                _343 = _340.w;
              } else {
                _343 = _307;
              }
              [branch]
              if (!_309) {
                float _345 = _338 - _126;
                _347 = _345;
              } else {
                _347 = _338;
              }
              [branch]
              if (!_311) {
                float _349 = _343 - _126;
                _351 = _349;
              } else {
                _351 = _343;
              }
              float _352 = abs(_347);
              bool _353 = (_352 >= _125);
              float _354 = abs(_351);
              bool _355 = (_354 >= _125);
              [branch]
              if (!_353) {
                float _357 = _98 * 2.0f;
                float _358 = _316 - _357;
                _360 = _358;
              } else {
                _360 = _316;
              }
              [branch]
              if (!_353) {
                float _362 = _99 * 2.0f;
                float _363 = _321 - _362;
                _365 = _363;
              } else {
                _365 = _321;
              }
              bool _366 = _353 && _355;
              [branch]
              if (!_355) {
                float _368 = _98 * 2.0f;
                float _369 = _327 + _368;
                _371 = _369;
              } else {
                _371 = _327;
              }
              [branch]
              if (!_355) {
                float _373 = _99 * 2.0f;
                float _374 = _332 + _373;
                _376 = _374;
              } else {
                _376 = _332;
              }
              [branch]
              if (!_366) {
                [branch]
                if (!_353) {
                  float4 _379 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_360, _365), 0.0f);
                  _382 = _379.w;
                } else {
                  _382 = _347;
                }
                [branch]
                if (!_355) {
                  float4 _384 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_371, _376), 0.0f);
                  _387 = _384.w;
                } else {
                  _387 = _351;
                }
                [branch]
                if (!_353) {
                  float _389 = _382 - _126;
                  _391 = _389;
                } else {
                  _391 = _382;
                }
                [branch]
                if (!_355) {
                  float _393 = _387 - _126;
                  _395 = _393;
                } else {
                  _395 = _387;
                }
                float _396 = abs(_391);
                bool _397 = (_396 >= _125);
                float _398 = abs(_395);
                bool _399 = (_398 >= _125);
                [branch]
                if (!_397) {
                  float _401 = _98 * 2.0f;
                  float _402 = _360 - _401;
                  _404 = _402;
                } else {
                  _404 = _360;
                }
                [branch]
                if (!_397) {
                  float _406 = _99 * 2.0f;
                  float _407 = _365 - _406;
                  _409 = _407;
                } else {
                  _409 = _365;
                }
                bool _410 = _397 && _399;
                [branch]
                if (!_399) {
                  float _412 = _98 * 2.0f;
                  float _413 = _371 + _412;
                  _415 = _413;
                } else {
                  _415 = _371;
                }
                [branch]
                if (!_399) {
                  float _417 = _99 * 2.0f;
                  float _418 = _376 + _417;
                  _420 = _418;
                } else {
                  _420 = _376;
                }
                [branch]
                if (!_410) {
                  [branch]
                  if (!_397) {
                    float4 _423 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_404, _409), 0.0f);
                    _426 = _423.w;
                  } else {
                    _426 = _391;
                  }
                  [branch]
                  if (!_399) {
                    float4 _428 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_415, _420), 0.0f);
                    _431 = _428.w;
                  } else {
                    _431 = _395;
                  }
                  [branch]
                  if (!_397) {
                    float _433 = _426 - _126;
                    _435 = _433;
                  } else {
                    _435 = _426;
                  }
                  [branch]
                  if (!_399) {
                    float _437 = _431 - _126;
                    _439 = _437;
                  } else {
                    _439 = _431;
                  }
                  float _440 = abs(_435);
                  bool _441 = (_440 >= _125);
                  float _442 = abs(_439);
                  bool _443 = (_442 >= _125);
                  [branch]
                  if (!_441) {
                    float _445 = _98 * 2.0f;
                    float _446 = _404 - _445;
                    _448 = _446;
                  } else {
                    _448 = _404;
                  }
                  [branch]
                  if (!_441) {
                    float _450 = _99 * 2.0f;
                    float _451 = _409 - _450;
                    _453 = _451;
                  } else {
                    _453 = _409;
                  }
                  bool _454 = _441 && _443;
                  [branch]
                  if (!_443) {
                    float _456 = _98 * 2.0f;
                    float _457 = _415 + _456;
                    _459 = _457;
                  } else {
                    _459 = _415;
                  }
                  [branch]
                  if (!_443) {
                    float _461 = _99 * 2.0f;
                    float _462 = _420 + _461;
                    _464 = _462;
                  } else {
                    _464 = _420;
                  }
                  [branch]
                  if (!_454) {
                    [branch]
                    if (!_441) {
                      float4 _467 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_448, _453), 0.0f);
                      _470 = _467.w;
                    } else {
                      _470 = _435;
                    }
                    [branch]
                    if (!_443) {
                      float4 _472 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_459, _464), 0.0f);
                      _475 = _472.w;
                    } else {
                      _475 = _439;
                    }
                    [branch]
                    if (!_441) {
                      float _477 = _470 - _126;
                      _479 = _477;
                    } else {
                      _479 = _470;
                    }
                    [branch]
                    if (!_443) {
                      float _481 = _475 - _126;
                      _483 = _481;
                    } else {
                      _483 = _475;
                    }
                    float _484 = abs(_479);
                    bool _485 = (_484 >= _125);
                    float _486 = abs(_483);
                    bool _487 = (_486 >= _125);
                    [branch]
                    if (!_485) {
                      float _489 = _98 * 2.0f;
                      float _490 = _448 - _489;
                      _492 = _490;
                    } else {
                      _492 = _448;
                    }
                    [branch]
                    if (!_485) {
                      float _494 = _99 * 2.0f;
                      float _495 = _453 - _494;
                      _497 = _495;
                    } else {
                      _497 = _453;
                    }
                    bool _498 = _485 && _487;
                    [branch]
                    if (!_487) {
                      float _500 = _98 * 2.0f;
                      float _501 = _459 + _500;
                      _503 = _501;
                    } else {
                      _503 = _459;
                    }
                    [branch]
                    if (!_487) {
                      float _505 = _99 * 2.0f;
                      float _506 = _464 + _505;
                      _508 = _506;
                    } else {
                      _508 = _464;
                    }
                    [branch]
                    if (!_498) {
                      [branch]
                      if (!_485) {
                        float4 _511 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_492, _497), 0.0f);
                        _514 = _511.w;
                      } else {
                        _514 = _479;
                      }
                      [branch]
                      if (!_487) {
                        float4 _516 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_503, _508), 0.0f);
                        _519 = _516.w;
                      } else {
                        _519 = _483;
                      }
                      [branch]
                      if (!_485) {
                        float _521 = _514 - _126;
                        _523 = _521;
                      } else {
                        _523 = _514;
                      }
                      [branch]
                      if (!_487) {
                        float _525 = _519 - _126;
                        _527 = _525;
                      } else {
                        _527 = _519;
                      }
                      float _528 = abs(_523);
                      bool _529 = (_528 >= _125);
                      float _530 = abs(_527);
                      bool _531 = (_530 >= _125);
                      [branch]
                      if (!_529) {
                        float _533 = _98 * 4.0f;
                        float _534 = _492 - _533;
                        _536 = _534;
                      } else {
                        _536 = _492;
                      }
                      [branch]
                      if (!_529) {
                        float _538 = _99 * 4.0f;
                        float _539 = _497 - _538;
                        _541 = _539;
                      } else {
                        _541 = _497;
                      }
                      bool _542 = _529 && _531;
                      [branch]
                      if (!_531) {
                        float _544 = _98 * 4.0f;
                        float _545 = _503 + _544;
                        _547 = _545;
                      } else {
                        _547 = _503;
                      }
                      [branch]
                      if (!_531) {
                        float _549 = _99 * 4.0f;
                        float _550 = _508 + _549;
                        _552 = _550;
                      } else {
                        _552 = _508;
                      }
                      [branch]
                      if (!_542) {
                        [branch]
                        if (!_529) {
                          float4 _555 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_536, _541), 0.0f);
                          _558 = _555.w;
                        } else {
                          _558 = _523;
                        }
                        [branch]
                        if (!_531) {
                          float4 _560 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_547, _552), 0.0f);
                          _563 = _560.w;
                        } else {
                          _563 = _527;
                        }
                        [branch]
                        if (!_529) {
                          float _565 = _558 - _126;
                          _567 = _565;
                        } else {
                          _567 = _558;
                        }
                        [branch]
                        if (!_531) {
                          float _569 = _563 - _126;
                          _571 = _569;
                        } else {
                          _571 = _563;
                        }
                        float _572 = abs(_567);
                        bool _573 = (_572 >= _125);
                        float _574 = abs(_571);
                        bool _575 = (_574 >= _125);
                        [branch]
                        if (!_573) {
                          float _577 = _98 * 8.0f;
                          float _578 = _536 - _577;
                          _580 = _578;
                        } else {
                          _580 = _536;
                        }
                        [branch]
                        if (!_573) {
                          float _582 = _99 * 8.0f;
                          float _583 = _541 - _582;
                          _585 = _583;
                        } else {
                          _585 = _541;
                        }
                        [branch]
                        if (!_575) {
                          float _587 = _98 * 8.0f;
                          float _588 = _547 + _587;
                          _590 = _588;
                        } else {
                          _590 = _547;
                        }
                        [branch]
                        if (!_575) {
                          float _592 = _99 * 8.0f;
                          float _593 = _552 + _592;
                          _595 = _580;
                          _596 = _585;
                          _597 = _590;
                          _598 = _593;
                          _599 = _567;
                          _600 = _571;
                        } else {
                          _595 = _580;
                          _596 = _585;
                          _597 = _590;
                          _598 = _552;
                          _599 = _567;
                          _600 = _571;
                        }
                      } else {
                        _595 = _536;
                        _596 = _541;
                        _597 = _547;
                        _598 = _552;
                        _599 = _523;
                        _600 = _527;
                      }
                    } else {
                      _595 = _492;
                      _596 = _497;
                      _597 = _503;
                      _598 = _508;
                      _599 = _479;
                      _600 = _483;
                    }
                  } else {
                    _595 = _448;
                    _596 = _453;
                    _597 = _459;
                    _598 = _464;
                    _599 = _435;
                    _600 = _439;
                  }
                } else {
                  _595 = _404;
                  _596 = _409;
                  _597 = _415;
                  _598 = _420;
                  _599 = _391;
                  _600 = _395;
                }
              } else {
                _595 = _360;
                _596 = _365;
                _597 = _371;
                _598 = _376;
                _599 = _347;
                _600 = _351;
              }
            } else {
              _595 = _316;
              _596 = _321;
              _597 = _327;
              _598 = _332;
              _599 = _303;
              _600 = _307;
            }
          } else {
            _595 = _272;
            _596 = _277;
            _597 = _283;
            _598 = _288;
            _599 = _259;
            _600 = _263;
          }
        } else {
          _595 = _228;
          _596 = _233;
          _597 = _239;
          _598 = _244;
          _599 = _215;
          _600 = _219;
        }
      } else {
        _595 = _184;
        _596 = _189;
        _597 = _195;
        _598 = _200;
        _599 = _171;
        _600 = _175;
      }
    } else {
      _595 = _140;
      _596 = _145;
      _597 = _151;
      _598 = _156;
      _599 = _130;
      _600 = _131;
    }
    float _601 = TEXCOORD.x - _595;
    float _602 = _597 - TEXCOORD.x;
    [branch]
    if (!_70) {
      float _604 = TEXCOORD.y - _596;
      _606 = _604;
    } else {
      _606 = _601;
    }
    [branch]
    if (!_70) {
      float _608 = _598 - TEXCOORD.y;
      _610 = _608;
    } else {
      _610 = _602;
    }
    bool _611 = (_599 < 0.0f);
    float _612 = _610 + _606;
    bool _613 = (_600 < 0.0f);
    float _614 = 1.0f / _612;
    bool _615 = (_606 < _610);
    float _616 = min(_606, _610);
    bool _617 = select(_615, _611, _613);
    bool _618 = _129 ^ _617;
    float _619 = _616 * _614;
    float _620 = 0.5f - _619;
    float _621 = _128 * _128;
    float _622 = _621 * 0.75f;
    float _623 = select(_618, _620, 0.0f);
    float _624 = max(_623, _622);
    [branch]
    if (!_70) {
      float _626 = _624 * _94;
      float _627 = _626 + TEXCOORD.x;
      _629 = _627;
    } else {
      _629 = TEXCOORD.x;
    }
    [branch]
    if (_70) {
      float _631 = _624 * _94;
      float _632 = _631 + TEXCOORD.y;
      _634 = _632;
    } else {
      _634 = TEXCOORD.y;
    }
    float4 _635;
    if (RENODX_TONE_MAP_TYPE == 0.f || CUSTOM_AA_HIGHLIGHT_WEIGHT == 0.f) {
      _635 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_629, _634), 0.0f);
    } else {
      _635 = SampleHighlightWeighted(float2(_629, _634));
    }
    _640 = _635.x;
    _641 = _635.y;
    _642 = _635.z;
  } else {
    _640 = _9.x;
    _641 = _9.y;
    _642 = _9.z;
  }
  SV_Target.x = _640;
  SV_Target.y = _641;
  SV_Target.z = _642;
  SV_Target.w = _9.w;
  return SV_Target;
}
