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

  float custom_linearStart = linearStart;
  float custom_maxNit = maxNit;
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    custom_linearStart = 100.f;
    custom_maxNit = 100.f;
  }

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
  float _49 = min(_45.x, 65000.0f);
  float _50 = min(_45.y, 65000.0f);
  float _51 = min(_45.z, 65000.0f);
  float _52 = _49 * _41;
  float _53 = _50 * _41;
  float _54 = _51 * _41;

  float3 untonemapped = ApplyCustomGrade1(float3(_52, _53, _54));
  _52 = untonemapped.x;
  _53 = untonemapped.y;
  _54 = untonemapped.z;

  float _55 = max(_52, _53);
  float _56 = max(_55, _54);
  bool _57 = isfinite(_56);
  float _157;
  float _158;
  float _159;
  float _197;
  float _208;
  float _219;
  float _261;
  float _272;
  float _283;
  float _334;
  float _345;
  float _356;
  float _377;
  float _378;
  float _379;
  float _439;
  float _464;
  float _465;
  float _466;
  if (_57) {
    float _63 = invLinearBegin * _52;
    bool _64 = (_52 >= linearBegin);
    float _65 = _63 * _63;
    float _66 = _63 * 2.0f;
    float _67 = 3.0f - _66;
    float _68 = _65 * _67;
    float _69 = invLinearBegin * _53;
    bool _70 = (_53 >= linearBegin);
    float _71 = _69 * _69;
    float _72 = _69 * 2.0f;
    float _73 = 3.0f - _72;
    float _74 = _71 * _73;
    float _75 = invLinearBegin * _54;
    bool _76 = (_54 >= linearBegin);
    float _77 = _75 * _75;
    float _78 = _75 * 2.0f;
    float _79 = 3.0f - _78;
    float _80 = _77 * _79;
    float _81 = 1.0f - _68;
    float _82 = select(_64, 0.0f, _81);
    float _83 = 1.0f - _74;
    float _84 = select(_70, 0.0f, _83);
    float _85 = 1.0f - _80;
    float _86 = select(_76, 0.0f, _85);
    bool _89 = (_52 < custom_linearStart);
    bool _90 = (_53 < custom_linearStart);
    bool _91 = (_54 < custom_linearStart);
    float _92 = select(_89, 0.0f, 1.0f);
    float _93 = select(_90, 0.0f, 1.0f);
    float _94 = select(_91, 0.0f, 1.0f);
    float _95 = 1.0f - _92;
    float _96 = _95 - _82;
    float _97 = 1.0f - _93;
    float _98 = _97 - _84;
    float _99 = 1.0f - _94;
    float _100 = _99 - _86;
    float _102 = log2(_63);
    float _103 = log2(_69);
    float _104 = log2(_75);
    float _105 = _102 * toe;
    float _106 = _103 * toe;
    float _107 = _104 * toe;
    float _108 = exp2(_105);
    float _109 = exp2(_106);
    float _110 = exp2(_107);
    float _111 = _108 * _82;
    float _112 = _111 * linearBegin;
    float _113 = _109 * _84;
    float _114 = _113 * linearBegin;
    float _115 = _110 * _86;
    float _116 = _115 * linearBegin;
    float _118 = contrast * _52;
    float _119 = contrast * _53;
    float _120 = contrast * _54;
    float _122 = _118 + madLinearStartContrastFactor;
    float _123 = _119 + madLinearStartContrastFactor;
    float _124 = _120 + madLinearStartContrastFactor;
    float _125 = _122 * _96;
    float _126 = _123 * _98;
    float _127 = _124 * _100;
    float _128 = _125 + _112;
    float _129 = _126 + _114;
    float _130 = _127 + _116;
    float _134 = contrastFactor * _52;
    float _135 = contrastFactor * _53;
    float _136 = contrastFactor * _54;
    float _138 = _134 + mulLinearStartContrastFactor;
    float _139 = _135 + mulLinearStartContrastFactor;
    float _140 = _136 + mulLinearStartContrastFactor;
    float _141 = exp2(_138);
    float _142 = exp2(_139);
    float _143 = exp2(_140);
    float _144 = _141 * displayMaxNitSubContrastFactor;
    float _145 = _142 * displayMaxNitSubContrastFactor;
    float _146 = _143 * displayMaxNitSubContrastFactor;
    float _147 = custom_maxNit - _144;
    float _148 = custom_maxNit - _145;
    float _149 = custom_maxNit - _146;
    float _150 = _147 * _92;
    float _151 = _148 * _93;
    float _152 = _149 * _94;
    float _153 = _128 + _150;
    float _154 = _129 + _151;
    float _155 = _130 + _152;
    _157 = _153;
    _158 = _154;
    _159 = _155;
  } else {
    _157 = 1.0f;
    _158 = 1.0f;
    _159 = 1.0f;
  }

  float3 tonemapped = float3(_157, _158, _159);
  float3 new_tonemap = HDRTonemap(untonemapped, tonemapped);
  _157 = new_tonemap.x;
  _158 = new_tonemap.y;
  _159 = new_tonemap.z;

  float3 ungraded = float3(_157, _158, _159);
  float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(ungraded);
  float gamut_compress_scale = renodx::color::correct::ComputeGamutCompressionScale(ungraded);
  float3 sdr_color = ungraded * scale;
  sdr_color = renodx::color::correct::GamutCompress(sdr_color, gamut_compress_scale);
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    _157 = sdr_color.x;
    _158 = sdr_color.y;
    _159 = sdr_color.z;
  }

  float _160 = (_157);
  float _161 = (_158);
  float _162 = (_159);
  float _183 = (_160);
  float _184 = (_161);
  float _185 = (_162);
  float _186 = fTextureInverseSize * 0.5f;
  bool _187 = !(_183 <= 0.0031308000907301903f);
  [branch]
  if (!_187) {
    float _189 = _183 * 12.920000076293945f;
    _197 = _189;
  } else {
    float _191 = log2(_183);
    float _192 = _191 * 0.4166666567325592f;
    float _193 = exp2(_192);
    float _194 = _193 * 1.0549999475479126f;
    float _195 = _194 + -0.054999999701976776f;
    _197 = _195;
  }
  bool _198 = !(_184 <= 0.0031308000907301903f);
  [branch]
  if (!_198) {
    float _200 = _184 * 12.920000076293945f;
    _208 = _200;
  } else {
    float _202 = log2(_184);
    float _203 = _202 * 0.4166666567325592f;
    float _204 = exp2(_203);
    float _205 = _204 * 1.0549999475479126f;
    float _206 = _205 + -0.054999999701976776f;
    _208 = _206;
  }
  bool _209 = !(_185 <= 0.0031308000907301903f);
  [branch]
  if (!_209) {
    float _211 = _185 * 12.920000076293945f;
    _219 = _211;
  } else {
    float _213 = log2(_185);
    float _214 = _213 * 0.4166666567325592f;
    float _215 = exp2(_214);
    float _216 = _215 * 1.0549999475479126f;
    float _217 = _216 + -0.054999999701976776f;
    _219 = _217;
  }
  float _220 = 1.0f - fTextureInverseSize;
  float _221 = _197 * _220;
  float _222 = _208 * _220;
  float _223 = _219 * _220;
  float _224 = _221 + _186;
  float _225 = _222 + _186;
  float _226 = _223 + _186;
  bool _227 = (fTextureBlendRate > 0.0f);
  bool _228 = (fTextureBlendRate2 > 0.0f);
  bool _229 = _227 && _228;
  [branch]
  if (_229) {
    float4 _233 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_224, _225, _226), 0.0f);
    float4 _238 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_224, _225, _226), 0.0f);
    float _242 = _238.x - _233.x;
    float _243 = _238.y - _233.y;
    float _244 = _238.z - _233.z;
    float _245 = _242 * fTextureBlendRate;
    float _246 = _243 * fTextureBlendRate;
    float _247 = _244 * fTextureBlendRate;
    float _248 = _245 + _233.x;
    float _249 = _246 + _233.y;
    float _250 = _247 + _233.z;
    bool _251 = !(_248 <= 0.0031308000907301903f);
    [branch]
    if (!_251) {
      float _253 = _248 * 12.920000076293945f;
      _261 = _253;
    } else {
      float _255 = log2(_248);
      float _256 = _255 * 0.4166666567325592f;
      float _257 = exp2(_256);
      float _258 = _257 * 1.0549999475479126f;
      float _259 = _258 + -0.054999999701976776f;
      _261 = _259;
    }
    bool _262 = !(_249 <= 0.0031308000907301903f);
    [branch]
    if (!_262) {
      float _264 = _249 * 12.920000076293945f;
      _272 = _264;
    } else {
      float _266 = log2(_249);
      float _267 = _266 * 0.4166666567325592f;
      float _268 = exp2(_267);
      float _269 = _268 * 1.0549999475479126f;
      float _270 = _269 + -0.054999999701976776f;
      _272 = _270;
    }
    bool _273 = !(_250 <= 0.0031308000907301903f);
    [branch]
    if (!_273) {
      float _275 = _250 * 12.920000076293945f;
      _283 = _275;
    } else {
      float _277 = log2(_250);
      float _278 = _277 * 0.4166666567325592f;
      float _279 = exp2(_278);
      float _280 = _279 * 1.0549999475479126f;
      float _281 = _280 + -0.054999999701976776f;
      _283 = _281;
    }
    float4 _285 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_261, _272, _283), 0.0f);
    float _289 = _285.x - _248;
    float _290 = _285.y - _249;
    float _291 = _285.z - _250;
    float _292 = _289 * fTextureBlendRate2;
    float _293 = _290 * fTextureBlendRate2;
    float _294 = _291 * fTextureBlendRate2;
    float _295 = _292 + _248;
    float _296 = _293 + _249;
    float _297 = _294 + _250;
    _377 = _295;
    _378 = _296;
    _379 = _297;
  } else {
    if (_227) {
      float4 _300 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_224, _225, _226), 0.0f);
      float4 _305 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_224, _225, _226), 0.0f);
      float _309 = _305.x - _300.x;
      float _310 = _305.y - _300.y;
      float _311 = _305.z - _300.z;
      float _312 = _309 * fTextureBlendRate;
      float _313 = _310 * fTextureBlendRate;
      float _314 = _311 * fTextureBlendRate;
      float _315 = _312 + _300.x;
      float _316 = _313 + _300.y;
      float _317 = _314 + _300.z;
      _377 = _315;
      _378 = _316;
      _379 = _317;
    } else {
      if (_228) {
        float4 _320 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_224, _225, _226), 0.0f);
        bool _324 = !(_320.x <= 0.0031308000907301903f);
        [branch]
        if (!_324) {
          float _326 = _320.x * 12.920000076293945f;
          _334 = _326;
        } else {
          float _328 = log2(_320.x);
          float _329 = _328 * 0.4166666567325592f;
          float _330 = exp2(_329);
          float _331 = _330 * 1.0549999475479126f;
          float _332 = _331 + -0.054999999701976776f;
          _334 = _332;
        }
        bool _335 = !(_320.y <= 0.0031308000907301903f);
        [branch]
        if (!_335) {
          float _337 = _320.y * 12.920000076293945f;
          _345 = _337;
        } else {
          float _339 = log2(_320.y);
          float _340 = _339 * 0.4166666567325592f;
          float _341 = exp2(_340);
          float _342 = _341 * 1.0549999475479126f;
          float _343 = _342 + -0.054999999701976776f;
          _345 = _343;
        }
        bool _346 = !(_320.z <= 0.0031308000907301903f);
        [branch]
        if (!_346) {
          float _348 = _320.z * 12.920000076293945f;
          _356 = _348;
        } else {
          float _350 = log2(_320.z);
          float _351 = _350 * 0.4166666567325592f;
          float _352 = exp2(_351);
          float _353 = _352 * 1.0549999475479126f;
          float _354 = _353 + -0.054999999701976776f;
          _356 = _354;
        }
        float4 _358 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_334, _345, _356), 0.0f);
        float _362 = _358.x - _320.x;
        float _363 = _358.y - _320.y;
        float _364 = _358.z - _320.z;
        float _365 = _362 * fTextureBlendRate2;
        float _366 = _363 * fTextureBlendRate2;
        float _367 = _364 * fTextureBlendRate2;
        float _368 = _365 + _320.x;
        float _369 = _366 + _320.y;
        float _370 = _367 + _320.z;
        _377 = _368;
        _378 = _369;
        _379 = _370;
      } else {
        float4 _372 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_224, _225, _226), 0.0f);
        _377 = _372.x;
        _378 = _372.y;
        _379 = _372.z;
      }
    }
  }
  float _380 = _377 * (fColorMatrix[0].x);
  float _381 = mad(_378, (fColorMatrix[1].x), _380);
  float _382 = mad(_379, (fColorMatrix[2].x), _381);
  float _383 = _382 + (fColorMatrix[3].x);
  float _384 = _377 * (fColorMatrix[0].y);
  float _385 = mad(_378, (fColorMatrix[1].y), _384);
  float _386 = mad(_379, (fColorMatrix[2].y), _385);
  float _387 = _386 + (fColorMatrix[3].y);
  float _388 = _377 * (fColorMatrix[0].z);
  float _389 = mad(_378, (fColorMatrix[1].z), _388);
  float _390 = mad(_379, (fColorMatrix[2].z), _389);
  float _391 = _390 + (fColorMatrix[3].z);
  bool _394 = !(useDynamicRangeConversion == 0.0f);
  if (_394) {
    float _399 = _383 * 0.6699999570846558f;
    float _400 = mad(0.16500000655651093f, _387, _399);
    float _401 = mad(0.16500000655651093f, _391, _400);
    float _402 = _383 * 0.16500000655651093f;
    float _403 = mad(0.6699999570846558f, _387, _402);
    float _404 = mad(0.16500000655651093f, _391, _403);
    float _405 = mad(0.16500000655651093f, _387, _402);
    float _406 = mad(0.6699999570846558f, _391, _405);
    float _407 = _401 * 0.6370000243186951f;
    float _408 = mad(0.1446000039577484f, _404, _407);
    float _409 = mad(0.1688999980688095f, _406, _408);
    float _410 = _401 * 0.26269999146461487f;
    float _411 = mad(0.6779999732971191f, _404, _410);
    float _412 = mad(0.059300001710653305f, _406, _411);
    float _413 = mad(0.02810000069439411f, _404, 0.0f);
    float _414 = mad(1.0609999895095825f, _406, _413);
    float _415 = _412 + _409;
    float _416 = _415 + _414;
    float _417 = _409 / _416;
    float _418 = _412 / _416;
    float _419 = kneeStartNit / exposureScale;
    float _420 = _419 * 0.009999999776482582f;
    float _421 = 1.0f - knee;
    bool _422 = (_412 < _420);
    if (_422) {
      float _424 = _412 * exposureScale;
      _439 = _424;
    } else {
      float _426 = exposureScale * _421;
      float _427 = _426 * _420;
      float _428 = _420 * exposureScale;
      float _429 = log2(_421);
      float _430 = _427 * 0.6931471824645996f;
      float _431 = _430 * _429;
      float _432 = _428 - _431;
      float _433 = _412 / _420;
      float _434 = _433 - knee;
      float _435 = log2(_434);
      float _436 = _430 * _435;
      float _437 = _432 + _436;
      _439 = _437;
    }
    float _440 = _417 / _418;
    float _441 = _440 * _439;
    float _442 = 1.0f - _417;
    float _443 = _442 - _418;
    float _444 = _443 / _418;
    float _445 = _444 * _439;
    float _446 = _441 * 1.7166999578475952f;
    float _447 = mad(-0.35569998621940613f, _439, _446);
    float _448 = mad(-0.2533999979496002f, _445, _447);
    float _449 = _441 * -0.666700005531311f;
    float _450 = mad(1.6165000200271606f, _439, _449);
    float _451 = mad(0.015799999237060547f, _445, _450);
    float _452 = _441 * 0.01759999990463257f;
    float _453 = mad(-0.04280000180006027f, _439, _452);
    float _454 = mad(0.9420999884605408f, _445, _453);
    float _455 = _448 * 1.6534652709960938f;
    float _456 = mad(-0.32673269510269165f, _451, _455);
    float _457 = mad(-0.32673269510269165f, _454, _456);
    float _458 = _448 * -0.32673269510269165f;
    float _459 = mad(1.6534652709960938f, _451, _458);
    float _460 = mad(-0.32673269510269165f, _454, _459);
    float _461 = mad(-0.32673269510269165f, _451, _458);
    float _462 = mad(1.6534652709960938f, _454, _461);
    _464 = _457;
    _465 = _460;
    _466 = _462;
  } else {
    _464 = _383;
    _465 = _387;
    _466 = _391;
  }

  float3 graded = float3(_464, _465, _466);
  float3 new_grade = TonemappedGraded(graded, scale, gamut_compress_scale);
  _464 = new_grade.x;
  _465 = new_grade.y;
  _466 = new_grade.z;

  SV_Target.x = _464;
  SV_Target.y = _465;
  SV_Target.z = _466;
  SV_Target.w = 0.0f;

  // untonemapped is linear
  SV_Target.rgb = Tonemap(SV_Target.rgb);
  return SV_Target;
}
