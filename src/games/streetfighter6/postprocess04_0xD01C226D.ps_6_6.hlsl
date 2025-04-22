#include "./common.hlsl"

Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

Texture3D<float4> tTextureMap0 : register(t1);

Texture3D<float4> tTextureMap1 : register(t2);

Texture3D<float4> tTextureMap2 : register(t3);

cbuffer CameraKerare : register(b0) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
};

cbuffer TonemapParam : register(b1) {
  float contrast : packoffset(c000.x);
  float linearBegin : packoffset(c000.y);
  float linearLength : packoffset(c000.z);
  float toe : packoffset(c000.w);
  float maxNit : packoffset(c001.x);
  float linearStart : packoffset(c001.y);
  float displayMaxNitSubContrastFactor : packoffset(c001.z);
  float contrastFactor : packoffset(c001.w);
  float mulLinearStartContrastFactor : packoffset(c002.x);
  float invLinearBegin : packoffset(c002.y);
  float madLinearStartContrastFactor : packoffset(c002.z);
};

cbuffer DynamicRangeConversionParam : register(b2) {
  float useDynamicRangeConversion : packoffset(c000.x);
  float exposureScale : packoffset(c000.y);
  float kneeStartNit : packoffset(c000.z);
  float knee : packoffset(c000.w);
};

cbuffer ColorCorrectTexture : register(b3) {
  float fTextureSize : packoffset(c000.x);
  float fTextureBlendRate : packoffset(c000.y);
  float fTextureBlendRate2 : packoffset(c000.z);
  float fTextureInverseSize : packoffset(c000.w);
  row_major float4x4 fColorMatrix : packoffset(c001.x);
};

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  float _23 = Kerare.x / Kerare.w;
  float _24 = Kerare.y / Kerare.w;
  float _25 = Kerare.z / Kerare.w;
  float _26 = dot(float3(_23, _24, _25), float3(_23, _24, _25));
  float _27 = rsqrt(_26);
  float _28 = _27 * _25;
  float _29 = abs(_28);
  float _31 = kerare_scale * _29;
  float _33 = _31 + kerare_offset;
  float _34 = saturate(_33);
  float _35 = 1.0f - _34;
  float _36 = _29 * _29;
  float _37 = _36 * _36;
  float _38 = _37 * _35;
  float _39 = _38 + kerare_brightness;
  float _40 = saturate(_39);
  float _41 = _40 * Exposure;
  uint _42 = uint(SV_Position.x);
  uint _43 = uint(SV_Position.y);
  float4 _45 = RE_POSTPROCESS_Color.Load(int3(_42, _43, 0));
  float _49 = _45.x * _41;
  float _50 = _45.y * _41;
  float _51 = _45.z * _41;
  float3 untonemapped = float3(_49, _50, _51);
  float _52 = max(_49, _50);
  float _53 = max(_52, _51);
  bool _54 = isfinite(_53);
  float _154;
  float _155;
  float _156;
  float _194;
  float _205;
  float _216;
  float _258;
  float _269;
  float _280;
  float _331;
  float _342;
  float _353;
  float _374;
  float _375;
  float _376;
  float _436;
  float _461;
  float _462;
  float _463;
  if (_54) {
    float _60 = invLinearBegin * _49;
    bool _61 = (_49 >= linearBegin);
    float _62 = _60 * _60;
    float _63 = _60 * 2.0f;
    float _64 = 3.0f - _63;
    float _65 = _62 * _64;
    float _66 = invLinearBegin * _50;
    bool _67 = (_50 >= linearBegin);
    float _68 = _66 * _66;
    float _69 = _66 * 2.0f;
    float _70 = 3.0f - _69;
    float _71 = _68 * _70;
    float _72 = invLinearBegin * _51;
    bool _73 = (_51 >= linearBegin);
    float _74 = _72 * _72;
    float _75 = _72 * 2.0f;
    float _76 = 3.0f - _75;
    float _77 = _74 * _76;
    float _78 = 1.0f - _65;
    float _79 = select(_61, 0.0f, _78);
    float _80 = 1.0f - _71;
    float _81 = select(_67, 0.0f, _80);
    float _82 = 1.0f - _77;
    float _83 = select(_73, 0.0f, _82);
    bool _86 = (_49 < linearStart);
    bool _87 = (_50 < linearStart);
    bool _88 = (_51 < linearStart);
    float _89 = select(_86, 0.0f, 1.0f);
    float _90 = select(_87, 0.0f, 1.0f);
    float _91 = select(_88, 0.0f, 1.0f);
    float _92 = 1.0f - _89;
    float _93 = _92 - _79;
    float _94 = 1.0f - _90;
    float _95 = _94 - _81;
    float _96 = 1.0f - _91;
    float _97 = _96 - _83;
    float _99 = log2(_60);
    float _100 = log2(_66);
    float _101 = log2(_72);
    float _102 = _99 * toe;
    float _103 = _100 * toe;
    float _104 = _101 * toe;
    float _105 = exp2(_102);
    float _106 = exp2(_103);
    float _107 = exp2(_104);
    float _108 = _105 * _79;
    float _109 = _108 * linearBegin;
    float _110 = _106 * _81;
    float _111 = _110 * linearBegin;
    float _112 = _107 * _83;
    float _113 = _112 * linearBegin;
    float _115 = contrast * _49;
    float _116 = contrast * _50;
    float _117 = contrast * _51;
    float _119 = _115 + madLinearStartContrastFactor;
    float _120 = _116 + madLinearStartContrastFactor;
    float _121 = _117 + madLinearStartContrastFactor;
    float _122 = _119 * _93;
    float _123 = _120 * _95;
    float _124 = _121 * _97;
    float _125 = _122 + _109;
    float _126 = _123 + _111;
    float _127 = _124 + _113;
    float _131 = contrastFactor * _49;
    float _132 = contrastFactor * _50;
    float _133 = contrastFactor * _51;
    float _135 = _131 + mulLinearStartContrastFactor;
    float _136 = _132 + mulLinearStartContrastFactor;
    float _137 = _133 + mulLinearStartContrastFactor;
    float _138 = exp2(_135);
    float _139 = exp2(_136);
    float _140 = exp2(_137);
    float _141 = _138 * displayMaxNitSubContrastFactor;
    float _142 = _139 * displayMaxNitSubContrastFactor;
    float _143 = _140 * displayMaxNitSubContrastFactor;
    float _144 = maxNit - _141;
    float _145 = maxNit - _142;
    float _146 = maxNit - _143;
    float _147 = _144 * _89;
    float _148 = _145 * _90;
    float _149 = _146 * _91;
    float _150 = _125 + _147;
    float _151 = _126 + _148;
    float _152 = _127 + _149;
    _154 = _150;
    _155 = _151;
    _156 = _152;
  } else {
    _154 = 1.0f;
    _155 = 1.0f;
    _156 = 1.0f;
  }
  float _157 = saturate(_154);
  float _158 = saturate(_155);
  float _159 = saturate(_156);
  float _180 = saturate(_157);
  float _181 = saturate(_158);
  float _182 = saturate(_159);
  float _183 = fTextureInverseSize * 0.5f;
  bool _184 = !(_180 <= 0.0031308000907301903f);
  [branch]
  if (!_184) {
    float _186 = _180 * 12.920000076293945f;
    _194 = _186;
  } else {
    float _188 = log2(_180);
    float _189 = _188 * 0.4166666567325592f;
    float _190 = exp2(_189);
    float _191 = _190 * 1.0549999475479126f;
    float _192 = _191 + -0.054999999701976776f;
    _194 = _192;
  }
  bool _195 = !(_181 <= 0.0031308000907301903f);
  [branch]
  if (!_195) {
    float _197 = _181 * 12.920000076293945f;
    _205 = _197;
  } else {
    float _199 = log2(_181);
    float _200 = _199 * 0.4166666567325592f;
    float _201 = exp2(_200);
    float _202 = _201 * 1.0549999475479126f;
    float _203 = _202 + -0.054999999701976776f;
    _205 = _203;
  }
  bool _206 = !(_182 <= 0.0031308000907301903f);
  [branch]
  if (!_206) {
    float _208 = _182 * 12.920000076293945f;
    _216 = _208;
  } else {
    float _210 = log2(_182);
    float _211 = _210 * 0.4166666567325592f;
    float _212 = exp2(_211);
    float _213 = _212 * 1.0549999475479126f;
    float _214 = _213 + -0.054999999701976776f;
    _216 = _214;
  }
  float _217 = 1.0f - fTextureInverseSize;
  float _218 = _194 * _217;
  float _219 = _205 * _217;
  float _220 = _216 * _217;
  float _221 = _218 + _183;
  float _222 = _219 + _183;
  float _223 = _220 + _183;
  bool _224 = (fTextureBlendRate > 0.0f);
  bool _225 = (fTextureBlendRate2 > 0.0f);
  bool _226 = _224 && _225;
  [branch]
  if (_226) {
    float4 _230 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_221, _222, _223), 0.0f);
    float4 _235 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_221, _222, _223), 0.0f);
    float _239 = _235.x - _230.x;
    float _240 = _235.y - _230.y;
    float _241 = _235.z - _230.z;
    float _242 = _239 * fTextureBlendRate;
    float _243 = _240 * fTextureBlendRate;
    float _244 = _241 * fTextureBlendRate;
    float _245 = _242 + _230.x;
    float _246 = _243 + _230.y;
    float _247 = _244 + _230.z;
    bool _248 = !(_245 <= 0.0031308000907301903f);
    [branch]
    if (!_248) {
      float _250 = _245 * 12.920000076293945f;
      _258 = _250;
    } else {
      float _252 = log2(_245);
      float _253 = _252 * 0.4166666567325592f;
      float _254 = exp2(_253);
      float _255 = _254 * 1.0549999475479126f;
      float _256 = _255 + -0.054999999701976776f;
      _258 = _256;
    }
    bool _259 = !(_246 <= 0.0031308000907301903f);
    [branch]
    if (!_259) {
      float _261 = _246 * 12.920000076293945f;
      _269 = _261;
    } else {
      float _263 = log2(_246);
      float _264 = _263 * 0.4166666567325592f;
      float _265 = exp2(_264);
      float _266 = _265 * 1.0549999475479126f;
      float _267 = _266 + -0.054999999701976776f;
      _269 = _267;
    }
    bool _270 = !(_247 <= 0.0031308000907301903f);
    [branch]
    if (!_270) {
      float _272 = _247 * 12.920000076293945f;
      _280 = _272;
    } else {
      float _274 = log2(_247);
      float _275 = _274 * 0.4166666567325592f;
      float _276 = exp2(_275);
      float _277 = _276 * 1.0549999475479126f;
      float _278 = _277 + -0.054999999701976776f;
      _280 = _278;
    }
    float4 _282 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_258, _269, _280), 0.0f);
    float _286 = _282.x - _245;
    float _287 = _282.y - _246;
    float _288 = _282.z - _247;
    float _289 = _286 * fTextureBlendRate2;
    float _290 = _287 * fTextureBlendRate2;
    float _291 = _288 * fTextureBlendRate2;
    float _292 = _289 + _245;
    float _293 = _290 + _246;
    float _294 = _291 + _247;
    _374 = _292;
    _375 = _293;
    _376 = _294;
  } else {
    if (_224) {
      float4 _297 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_221, _222, _223), 0.0f);
      float4 _302 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_221, _222, _223), 0.0f);
      float _306 = _302.x - _297.x;
      float _307 = _302.y - _297.y;
      float _308 = _302.z - _297.z;
      float _309 = _306 * fTextureBlendRate;
      float _310 = _307 * fTextureBlendRate;
      float _311 = _308 * fTextureBlendRate;
      float _312 = _309 + _297.x;
      float _313 = _310 + _297.y;
      float _314 = _311 + _297.z;
      _374 = _312;
      _375 = _313;
      _376 = _314;
    } else {
      if (_225) {
        float4 _317 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_221, _222, _223), 0.0f);
        bool _321 = !(_317.x <= 0.0031308000907301903f);
        [branch]
        if (!_321) {
          float _323 = _317.x * 12.920000076293945f;
          _331 = _323;
        } else {
          float _325 = log2(_317.x);
          float _326 = _325 * 0.4166666567325592f;
          float _327 = exp2(_326);
          float _328 = _327 * 1.0549999475479126f;
          float _329 = _328 + -0.054999999701976776f;
          _331 = _329;
        }
        bool _332 = !(_317.y <= 0.0031308000907301903f);
        [branch]
        if (!_332) {
          float _334 = _317.y * 12.920000076293945f;
          _342 = _334;
        } else {
          float _336 = log2(_317.y);
          float _337 = _336 * 0.4166666567325592f;
          float _338 = exp2(_337);
          float _339 = _338 * 1.0549999475479126f;
          float _340 = _339 + -0.054999999701976776f;
          _342 = _340;
        }
        bool _343 = !(_317.z <= 0.0031308000907301903f);
        [branch]
        if (!_343) {
          float _345 = _317.z * 12.920000076293945f;
          _353 = _345;
        } else {
          float _347 = log2(_317.z);
          float _348 = _347 * 0.4166666567325592f;
          float _349 = exp2(_348);
          float _350 = _349 * 1.0549999475479126f;
          float _351 = _350 + -0.054999999701976776f;
          _353 = _351;
        }
        float4 _355 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_331, _342, _353), 0.0f);
        float _359 = _355.x - _317.x;
        float _360 = _355.y - _317.y;
        float _361 = _355.z - _317.z;
        float _362 = _359 * fTextureBlendRate2;
        float _363 = _360 * fTextureBlendRate2;
        float _364 = _361 * fTextureBlendRate2;
        float _365 = _362 + _317.x;
        float _366 = _363 + _317.y;
        float _367 = _364 + _317.z;
        _374 = _365;
        _375 = _366;
        _376 = _367;
      } else {
        float4 _369 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_221, _222, _223), 0.0f);
        _374 = _369.x;
        _375 = _369.y;
        _376 = _369.z;
      }
    }
  }
  float _377 = _374 * (fColorMatrix[0].x);
  float _378 = mad(_375, (fColorMatrix[1].x), _377);
  float _379 = mad(_376, (fColorMatrix[2].x), _378);
  float _380 = _379 + (fColorMatrix[3].x);
  float _381 = _374 * (fColorMatrix[0].y);
  float _382 = mad(_375, (fColorMatrix[1].y), _381);
  float _383 = mad(_376, (fColorMatrix[2].y), _382);
  float _384 = _383 + (fColorMatrix[3].y);
  float _385 = _374 * (fColorMatrix[0].z);
  float _386 = mad(_375, (fColorMatrix[1].z), _385);
  float _387 = mad(_376, (fColorMatrix[2].z), _386);
  float _388 = _387 + (fColorMatrix[3].z);
  bool _391 = !(useDynamicRangeConversion == 0.0f);
  if (_391) {
    float _396 = _380 * 0.6699999570846558f;
    float _397 = mad(0.16500000655651093f, _384, _396);
    float _398 = mad(0.16500000655651093f, _388, _397);
    float _399 = _380 * 0.16500000655651093f;
    float _400 = mad(0.6699999570846558f, _384, _399);
    float _401 = mad(0.16500000655651093f, _388, _400);
    float _402 = mad(0.16500000655651093f, _384, _399);
    float _403 = mad(0.6699999570846558f, _388, _402);
    float _404 = _398 * 0.6370000243186951f;
    float _405 = mad(0.1446000039577484f, _401, _404);
    float _406 = mad(0.1688999980688095f, _403, _405);
    float _407 = _398 * 0.26269999146461487f;
    float _408 = mad(0.6779999732971191f, _401, _407);
    float _409 = mad(0.059300001710653305f, _403, _408);
    float _410 = mad(0.02810000069439411f, _401, 0.0f);
    float _411 = mad(1.0609999895095825f, _403, _410);
    float _412 = _409 + _406;
    float _413 = _412 + _411;
    float _414 = _406 / _413;
    float _415 = _409 / _413;
    float _416 = kneeStartNit / exposureScale;
    float _417 = _416 * 0.009999999776482582f;
    float _418 = 1.0f - knee;
    bool _419 = (_409 < _417);
    if (_419) {
      float _421 = _409 * exposureScale;
      _436 = _421;
    } else {
      float _423 = exposureScale * _418;
      float _424 = _423 * _417;
      float _425 = _417 * exposureScale;
      float _426 = log2(_418);
      float _427 = _424 * 0.6931471824645996f;
      float _428 = _427 * _426;
      float _429 = _425 - _428;
      float _430 = _409 / _417;
      float _431 = _430 - knee;
      float _432 = log2(_431);
      float _433 = _427 * _432;
      float _434 = _429 + _433;
      _436 = _434;
    }
    float _437 = _414 / _415;
    float _438 = _437 * _436;
    float _439 = 1.0f - _414;
    float _440 = _439 - _415;
    float _441 = _440 / _415;
    float _442 = _441 * _436;
    float _443 = _438 * 1.7166999578475952f;
    float _444 = mad(-0.35569998621940613f, _436, _443);
    float _445 = mad(-0.2533999979496002f, _442, _444);
    float _446 = _438 * -0.666700005531311f;
    float _447 = mad(1.6165000200271606f, _436, _446);
    float _448 = mad(0.015799999237060547f, _442, _447);
    float _449 = _438 * 0.01759999990463257f;
    float _450 = mad(-0.04280000180006027f, _436, _449);
    float _451 = mad(0.9420999884605408f, _442, _450);
    float _452 = _445 * 1.6534652709960938f;
    float _453 = mad(-0.32673269510269165f, _448, _452);
    float _454 = mad(-0.32673269510269165f, _451, _453);
    float _455 = _445 * -0.32673269510269165f;
    float _456 = mad(1.6534652709960938f, _448, _455);
    float _457 = mad(-0.32673269510269165f, _451, _456);
    float _458 = mad(-0.32673269510269165f, _448, _455);
    float _459 = mad(1.6534652709960938f, _451, _458);
    _461 = _454;
    _462 = _457;
    _463 = _459;
  } else {
    _461 = _380;
    _462 = _384;
    _463 = _388;
  }
  SV_Target.x = _461;
  SV_Target.y = _462;
  SV_Target.z = _463;
  SV_Target.w = 0.0f;

  SV_Target.rgb = Tonemap(untonemapped, SV_Target.rgb);
  return SV_Target;
}
