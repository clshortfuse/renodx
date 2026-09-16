#include "./common.hlsl"

Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

Texture3D<float4> tTextureMap0 : register(t1);

Texture3D<float4> tTextureMap1 : register(t2);

Texture3D<float4> tTextureMap2 : register(t3);

cbuffer TonemapParam : register(b0) {
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

cbuffer DynamicRangeConversionParam : register(b1) {
  float useDynamicRangeConversion : packoffset(c000.x);
  float exposureScale : packoffset(c000.y);
  float kneeStartNit : packoffset(c000.z);
  float knee : packoffset(c000.w);
};

cbuffer ColorCorrectTexture : register(b2) {
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

  uint _15 = uint(SV_Position.x);
  uint _16 = uint(SV_Position.y);
  float4 _18 = RE_POSTPROCESS_Color.Load(int3(_15, _16, 0));
  float _22 = min(_18.x, 65000.0f);
  float _23 = min(_18.y, 65000.0f);
  float _24 = min(_18.z, 65000.0f);
  float _25 = _22 * Exposure;
  float _26 = _23 * Exposure;
  float _27 = _24 * Exposure;

  float3 untonemapped = ApplyCustomGrade1(float3(_25, _26, _27));
  _25 = untonemapped.x;
  _26 = untonemapped.y;
  _27 = untonemapped.z;

  float _28 = max(_25, _26);
  float _29 = max(_28, _27);
  bool _30 = isfinite(_29);
  float _130;
  float _131;
  float _132;
  float _170;
  float _181;
  float _192;
  float _234;
  float _245;
  float _256;
  float _307;
  float _318;
  float _329;
  float _350;
  float _351;
  float _352;
  float _412;
  float _437;
  float _438;
  float _439;
  if (_30) {
    float _36 = invLinearBegin * _25;
    bool _37 = (_25 >= linearBegin);
    float _38 = _36 * _36;
    float _39 = _36 * 2.0f;
    float _40 = 3.0f - _39;
    float _41 = _38 * _40;
    float _42 = invLinearBegin * _26;
    bool _43 = (_26 >= linearBegin);
    float _44 = _42 * _42;
    float _45 = _42 * 2.0f;
    float _46 = 3.0f - _45;
    float _47 = _44 * _46;
    float _48 = invLinearBegin * _27;
    bool _49 = (_27 >= linearBegin);
    float _50 = _48 * _48;
    float _51 = _48 * 2.0f;
    float _52 = 3.0f - _51;
    float _53 = _50 * _52;
    float _54 = 1.0f - _41;
    float _55 = select(_37, 0.0f, _54);
    float _56 = 1.0f - _47;
    float _57 = select(_43, 0.0f, _56);
    float _58 = 1.0f - _53;
    float _59 = select(_49, 0.0f, _58);
    bool _62 = (_25 < custom_linearStart);
    bool _63 = (_26 < custom_linearStart);
    bool _64 = (_27 < custom_linearStart);
    float _65 = select(_62, 0.0f, 1.0f);
    float _66 = select(_63, 0.0f, 1.0f);
    float _67 = select(_64, 0.0f, 1.0f);
    float _68 = 1.0f - _65;
    float _69 = _68 - _55;
    float _70 = 1.0f - _66;
    float _71 = _70 - _57;
    float _72 = 1.0f - _67;
    float _73 = _72 - _59;
    float _75 = log2(_36);
    float _76 = log2(_42);
    float _77 = log2(_48);
    float _78 = _75 * toe;
    float _79 = _76 * toe;
    float _80 = _77 * toe;
    float _81 = exp2(_78);
    float _82 = exp2(_79);
    float _83 = exp2(_80);
    float _84 = _81 * _55;
    float _85 = _84 * linearBegin;
    float _86 = _82 * _57;
    float _87 = _86 * linearBegin;
    float _88 = _83 * _59;
    float _89 = _88 * linearBegin;
    float _91 = contrast * _25;
    float _92 = contrast * _26;
    float _93 = contrast * _27;
    float _95 = _91 + madLinearStartContrastFactor;
    float _96 = _92 + madLinearStartContrastFactor;
    float _97 = _93 + madLinearStartContrastFactor;
    float _98 = _95 * _69;
    float _99 = _96 * _71;
    float _100 = _97 * _73;
    float _101 = _98 + _85;
    float _102 = _99 + _87;
    float _103 = _100 + _89;
    float _107 = contrastFactor * _25;
    float _108 = contrastFactor * _26;
    float _109 = contrastFactor * _27;
    float _111 = _107 + mulLinearStartContrastFactor;
    float _112 = _108 + mulLinearStartContrastFactor;
    float _113 = _109 + mulLinearStartContrastFactor;
    float _114 = exp2(_111);
    float _115 = exp2(_112);
    float _116 = exp2(_113);
    float _117 = _114 * displayMaxNitSubContrastFactor;
    float _118 = _115 * displayMaxNitSubContrastFactor;
    float _119 = _116 * displayMaxNitSubContrastFactor;
    float _120 = custom_maxNit - _117;
    float _121 = custom_maxNit - _118;
    float _122 = custom_maxNit - _119;
    float _123 = _120 * _65;
    float _124 = _121 * _66;
    float _125 = _122 * _67;
    float _126 = _101 + _123;
    float _127 = _102 + _124;
    float _128 = _103 + _125;
    _130 = _126;
    _131 = _127;
    _132 = _128;
  } else {
    _130 = 1.0f;
    _131 = 1.0f;
    _132 = 1.0f;
  }

  float3 tonemapped = float3(_130, _131, _132);
  float3 new_tonemap = HDRTonemap(untonemapped, tonemapped);
  _130 = new_tonemap.x;
  _131 = new_tonemap.y;
  _132 = new_tonemap.z;

  float3 ungraded = float3(_130, _131, _132);
  float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(ungraded);
  float gamut_compress_scale = renodx::color::correct::ComputeGamutCompressionScale(ungraded);
  float3 sdr_color = ungraded * scale;
  sdr_color = renodx::color::correct::GamutCompress(sdr_color, gamut_compress_scale);
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    _130 = sdr_color.x;
    _131 = sdr_color.y;
    _132 = sdr_color.z;
  }

  float _133 = (_130);
  float _134 = (_131);
  float _135 = (_132);
  float _156 = (_133);
  float _157 = (_134);
  float _158 = (_135);
  float _159 = fTextureInverseSize * 0.5f;
  bool _160 = !(_156 <= 0.0031308000907301903f);
  [branch]
  if (!_160) {
    float _162 = _156 * 12.920000076293945f;
    _170 = _162;
  } else {
    float _164 = log2(_156);
    float _165 = _164 * 0.4166666567325592f;
    float _166 = exp2(_165);
    float _167 = _166 * 1.0549999475479126f;
    float _168 = _167 + -0.054999999701976776f;
    _170 = _168;
  }
  bool _171 = !(_157 <= 0.0031308000907301903f);
  [branch]
  if (!_171) {
    float _173 = _157 * 12.920000076293945f;
    _181 = _173;
  } else {
    float _175 = log2(_157);
    float _176 = _175 * 0.4166666567325592f;
    float _177 = exp2(_176);
    float _178 = _177 * 1.0549999475479126f;
    float _179 = _178 + -0.054999999701976776f;
    _181 = _179;
  }
  bool _182 = !(_158 <= 0.0031308000907301903f);
  [branch]
  if (!_182) {
    float _184 = _158 * 12.920000076293945f;
    _192 = _184;
  } else {
    float _186 = log2(_158);
    float _187 = _186 * 0.4166666567325592f;
    float _188 = exp2(_187);
    float _189 = _188 * 1.0549999475479126f;
    float _190 = _189 + -0.054999999701976776f;
    _192 = _190;
  }
  float _193 = 1.0f - fTextureInverseSize;
  float _194 = _170 * _193;
  float _195 = _181 * _193;
  float _196 = _192 * _193;
  float _197 = _194 + _159;
  float _198 = _195 + _159;
  float _199 = _196 + _159;
  bool _200 = (fTextureBlendRate > 0.0f);
  bool _201 = (fTextureBlendRate2 > 0.0f);
  bool _202 = _200 && _201;
  [branch]
  if (_202) {
    float4 _206 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_197, _198, _199), 0.0f);
    float4 _211 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_197, _198, _199), 0.0f);
    float _215 = _211.x - _206.x;
    float _216 = _211.y - _206.y;
    float _217 = _211.z - _206.z;
    float _218 = _215 * fTextureBlendRate;
    float _219 = _216 * fTextureBlendRate;
    float _220 = _217 * fTextureBlendRate;
    float _221 = _218 + _206.x;
    float _222 = _219 + _206.y;
    float _223 = _220 + _206.z;
    bool _224 = !(_221 <= 0.0031308000907301903f);
    [branch]
    if (!_224) {
      float _226 = _221 * 12.920000076293945f;
      _234 = _226;
    } else {
      float _228 = log2(_221);
      float _229 = _228 * 0.4166666567325592f;
      float _230 = exp2(_229);
      float _231 = _230 * 1.0549999475479126f;
      float _232 = _231 + -0.054999999701976776f;
      _234 = _232;
    }
    bool _235 = !(_222 <= 0.0031308000907301903f);
    [branch]
    if (!_235) {
      float _237 = _222 * 12.920000076293945f;
      _245 = _237;
    } else {
      float _239 = log2(_222);
      float _240 = _239 * 0.4166666567325592f;
      float _241 = exp2(_240);
      float _242 = _241 * 1.0549999475479126f;
      float _243 = _242 + -0.054999999701976776f;
      _245 = _243;
    }
    bool _246 = !(_223 <= 0.0031308000907301903f);
    [branch]
    if (!_246) {
      float _248 = _223 * 12.920000076293945f;
      _256 = _248;
    } else {
      float _250 = log2(_223);
      float _251 = _250 * 0.4166666567325592f;
      float _252 = exp2(_251);
      float _253 = _252 * 1.0549999475479126f;
      float _254 = _253 + -0.054999999701976776f;
      _256 = _254;
    }
    float4 _258 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_234, _245, _256), 0.0f);
    float _262 = _258.x - _221;
    float _263 = _258.y - _222;
    float _264 = _258.z - _223;
    float _265 = _262 * fTextureBlendRate2;
    float _266 = _263 * fTextureBlendRate2;
    float _267 = _264 * fTextureBlendRate2;
    float _268 = _265 + _221;
    float _269 = _266 + _222;
    float _270 = _267 + _223;
    _350 = _268;
    _351 = _269;
    _352 = _270;
  } else {
    if (_200) {
      float4 _273 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_197, _198, _199), 0.0f);
      float4 _278 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_197, _198, _199), 0.0f);
      float _282 = _278.x - _273.x;
      float _283 = _278.y - _273.y;
      float _284 = _278.z - _273.z;
      float _285 = _282 * fTextureBlendRate;
      float _286 = _283 * fTextureBlendRate;
      float _287 = _284 * fTextureBlendRate;
      float _288 = _285 + _273.x;
      float _289 = _286 + _273.y;
      float _290 = _287 + _273.z;
      _350 = _288;
      _351 = _289;
      _352 = _290;
    } else {
      if (_201) {
        float4 _293 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_197, _198, _199), 0.0f);
        bool _297 = !(_293.x <= 0.0031308000907301903f);
        [branch]
        if (!_297) {
          float _299 = _293.x * 12.920000076293945f;
          _307 = _299;
        } else {
          float _301 = log2(_293.x);
          float _302 = _301 * 0.4166666567325592f;
          float _303 = exp2(_302);
          float _304 = _303 * 1.0549999475479126f;
          float _305 = _304 + -0.054999999701976776f;
          _307 = _305;
        }
        bool _308 = !(_293.y <= 0.0031308000907301903f);
        [branch]
        if (!_308) {
          float _310 = _293.y * 12.920000076293945f;
          _318 = _310;
        } else {
          float _312 = log2(_293.y);
          float _313 = _312 * 0.4166666567325592f;
          float _314 = exp2(_313);
          float _315 = _314 * 1.0549999475479126f;
          float _316 = _315 + -0.054999999701976776f;
          _318 = _316;
        }
        bool _319 = !(_293.z <= 0.0031308000907301903f);
        [branch]
        if (!_319) {
          float _321 = _293.z * 12.920000076293945f;
          _329 = _321;
        } else {
          float _323 = log2(_293.z);
          float _324 = _323 * 0.4166666567325592f;
          float _325 = exp2(_324);
          float _326 = _325 * 1.0549999475479126f;
          float _327 = _326 + -0.054999999701976776f;
          _329 = _327;
        }
        float4 _331 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_307, _318, _329), 0.0f);
        float _335 = _331.x - _293.x;
        float _336 = _331.y - _293.y;
        float _337 = _331.z - _293.z;
        float _338 = _335 * fTextureBlendRate2;
        float _339 = _336 * fTextureBlendRate2;
        float _340 = _337 * fTextureBlendRate2;
        float _341 = _338 + _293.x;
        float _342 = _339 + _293.y;
        float _343 = _340 + _293.z;
        _350 = _341;
        _351 = _342;
        _352 = _343;
      } else {
        float4 _345 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_197, _198, _199), 0.0f);
        _350 = _345.x;
        _351 = _345.y;
        _352 = _345.z;
      }
    }
  }
  float _353 = _350 * (fColorMatrix[0].x);
  float _354 = mad(_351, (fColorMatrix[1].x), _353);
  float _355 = mad(_352, (fColorMatrix[2].x), _354);
  float _356 = _355 + (fColorMatrix[3].x);
  float _357 = _350 * (fColorMatrix[0].y);
  float _358 = mad(_351, (fColorMatrix[1].y), _357);
  float _359 = mad(_352, (fColorMatrix[2].y), _358);
  float _360 = _359 + (fColorMatrix[3].y);
  float _361 = _350 * (fColorMatrix[0].z);
  float _362 = mad(_351, (fColorMatrix[1].z), _361);
  float _363 = mad(_352, (fColorMatrix[2].z), _362);
  float _364 = _363 + (fColorMatrix[3].z);
  bool _367 = !(useDynamicRangeConversion == 0.0f);
  if (_367) {
    float _372 = _356 * 0.6699999570846558f;
    float _373 = mad(0.16500000655651093f, _360, _372);
    float _374 = mad(0.16500000655651093f, _364, _373);
    float _375 = _356 * 0.16500000655651093f;
    float _376 = mad(0.6699999570846558f, _360, _375);
    float _377 = mad(0.16500000655651093f, _364, _376);
    float _378 = mad(0.16500000655651093f, _360, _375);
    float _379 = mad(0.6699999570846558f, _364, _378);
    float _380 = _374 * 0.6370000243186951f;
    float _381 = mad(0.1446000039577484f, _377, _380);
    float _382 = mad(0.1688999980688095f, _379, _381);
    float _383 = _374 * 0.26269999146461487f;
    float _384 = mad(0.6779999732971191f, _377, _383);
    float _385 = mad(0.059300001710653305f, _379, _384);
    float _386 = mad(0.02810000069439411f, _377, 0.0f);
    float _387 = mad(1.0609999895095825f, _379, _386);
    float _388 = _385 + _382;
    float _389 = _388 + _387;
    float _390 = _382 / _389;
    float _391 = _385 / _389;
    float _392 = kneeStartNit / exposureScale;
    float _393 = _392 * 0.009999999776482582f;
    float _394 = 1.0f - knee;
    bool _395 = (_385 < _393);
    if (_395) {
      float _397 = _385 * exposureScale;
      _412 = _397;
    } else {
      float _399 = exposureScale * _394;
      float _400 = _399 * _393;
      float _401 = _393 * exposureScale;
      float _402 = log2(_394);
      float _403 = _400 * 0.6931471824645996f;
      float _404 = _403 * _402;
      float _405 = _401 - _404;
      float _406 = _385 / _393;
      float _407 = _406 - knee;
      float _408 = log2(_407);
      float _409 = _403 * _408;
      float _410 = _405 + _409;
      _412 = _410;
    }
    float _413 = _390 / _391;
    float _414 = _413 * _412;
    float _415 = 1.0f - _390;
    float _416 = _415 - _391;
    float _417 = _416 / _391;
    float _418 = _417 * _412;
    float _419 = _414 * 1.7166999578475952f;
    float _420 = mad(-0.35569998621940613f, _412, _419);
    float _421 = mad(-0.2533999979496002f, _418, _420);
    float _422 = _414 * -0.666700005531311f;
    float _423 = mad(1.6165000200271606f, _412, _422);
    float _424 = mad(0.015799999237060547f, _418, _423);
    float _425 = _414 * 0.01759999990463257f;
    float _426 = mad(-0.04280000180006027f, _412, _425);
    float _427 = mad(0.9420999884605408f, _418, _426);
    float _428 = _421 * 1.6534652709960938f;
    float _429 = mad(-0.32673269510269165f, _424, _428);
    float _430 = mad(-0.32673269510269165f, _427, _429);
    float _431 = _421 * -0.32673269510269165f;
    float _432 = mad(1.6534652709960938f, _424, _431);
    float _433 = mad(-0.32673269510269165f, _427, _432);
    float _434 = mad(-0.32673269510269165f, _424, _431);
    float _435 = mad(1.6534652709960938f, _427, _434);
    _437 = _430;
    _438 = _433;
    _439 = _435;
  } else {
    _437 = _356;
    _438 = _360;
    _439 = _364;
  }

  float3 graded = float3(_437, _438, _439);
  float3 new_grade = TonemappedGraded(graded, scale, gamut_compress_scale);
  _437 = new_grade.x;
  _438 = new_grade.y;
  _439 = new_grade.z;
  
  SV_Target.x = _437;
  SV_Target.y = _438;
  SV_Target.z = _439;
  SV_Target.w = 0.0f;

  // untonemapped is linear
  SV_Target.rgb = Tonemap(SV_Target.rgb);
  return SV_Target;
}
