#include "./common.hlsl"

Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

struct RadialBlurComputeResult {
  float computeAlpha;
};

StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t1);

Texture3D<float4> tTextureMap0 : register(t2);

Texture3D<float4> tTextureMap1 : register(t3);

Texture3D<float4> tTextureMap2 : register(t4);

cbuffer SceneInfo : register(b0) {
  row_major float4x4 viewProjMat : packoffset(c000.x);
  row_major float3x4 transposeViewMat : packoffset(c004.x);
  row_major float3x4 transposeViewInvMat : packoffset(c007.x);
  float4 projElement[2] : packoffset(c010.x);
  float4 projInvElements[2] : packoffset(c012.x);
  row_major float4x4 viewProjInvMat : packoffset(c014.x);
  row_major float4x4 prevViewProjMat : packoffset(c018.x);
  float3 ZToLinear : packoffset(c022.x);
  float subdivisionLevel : packoffset(c022.w);
  float2 screenSize : packoffset(c023.x);
  float2 screenInverseSize : packoffset(c023.z);
  float2 cullingHelper : packoffset(c024.x);
  float cameraNearPlane : packoffset(c024.z);
  float cameraFarPlane : packoffset(c024.w);
  float4 viewFrustum[8] : packoffset(c025.x);
  float4 clipplane : packoffset(c033.x);
  float2 vrsVelocityThreshold : packoffset(c034.x);
  uint GPUVisibleMask : packoffset(c034.z);
  uint resolutionRatioPacked : packoffset(c034.w);
};

cbuffer CameraKerare : register(b1) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
};

cbuffer TonemapParam : register(b2) {
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

cbuffer DynamicRangeConversionParam : register(b3) {
  float useDynamicRangeConversion : packoffset(c000.x);
  float exposureScale : packoffset(c000.y);
  float kneeStartNit : packoffset(c000.z);
  float knee : packoffset(c000.w);
};

cbuffer RadialBlurRenderParam : register(b4) {
  float4 cbRadialColor : packoffset(c000.x);
  float2 cbRadialScreenPos : packoffset(c001.x);
  float2 cbRadialMaskSmoothstep : packoffset(c001.z);
  float2 cbRadialMaskRate : packoffset(c002.x);
  float cbRadialBlurPower : packoffset(c002.z);
  float cbRadialSharpRange : packoffset(c002.w);
  uint cbRadialBlurFlags : packoffset(c003.x);
  float cbRadialReserve0 : packoffset(c003.y);
  float cbRadialReserve1 : packoffset(c003.z);
  float cbRadialReserve2 : packoffset(c003.w);
};

cbuffer ColorCorrectTexture : register(b5) {
  float fTextureSize : packoffset(c000.x);
  float fTextureBlendRate : packoffset(c000.y);
  float fTextureBlendRate2 : packoffset(c000.z);
  float fTextureInverseSize : packoffset(c000.w);
  row_major float4x4 fColorMatrix : packoffset(c001.x);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  float3 untonemapped;
  float3 tonemapped;
  float3 new_tonemap;

  float custom_linearStart = linearStart;
  float custom_maxNit = maxNit;
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    custom_linearStart = 100.f;
    custom_maxNit = 100.f;
  }

  float _29 = Kerare.x / Kerare.w;
  float _30 = Kerare.y / Kerare.w;
  float _31 = Kerare.z / Kerare.w;
  float _32 = dot(float3(_29, _30, _31), float3(_29, _30, _31));
  float _33 = rsqrt(_32);
  float _34 = _33 * _31;
  float _35 = abs(_34);
  float _37 = kerare_scale * _35;
  float _39 = _37 + kerare_offset;
  float _40 = saturate(_39);
  float _41 = 1.0f - _40;
  float _42 = _35 * _35;
  float _43 = _42 * _42;
  float _44 = _43 * _41;
  float _45 = _44 + kerare_brightness;
  float _46 = saturate(_45);
  float _47 = _46 * Exposure;
  uint _48 = uint(SV_Position.x);
  uint _49 = uint(SV_Position.y);
  float4 _51 = RE_POSTPROCESS_Color.Load(int3(_48, _49, 0));
  float _55 = min(_51.x, 65000.0f);
  float _56 = min(_51.y, 65000.0f);
  float _57 = min(_51.z, 65000.0f);
  float _58 = _55 * _47;
  float _59 = _56 * _47;
  float _60 = _57 * _47;

  untonemapped = ApplyCustomGrade1(float3(_58, _59, _60));
  _58 = untonemapped.x;
  _59 = untonemapped.y;
  _60 = untonemapped.z;

  float _61 = max(_58, _59);
  float _62 = max(_61, _60);
  bool _63 = isfinite(_62);
  float _163;
  float _164;
  float _165;
  float _485;
  float _486;
  float _487;
  float _521;
  float _522;
  float _523;
  float _534;
  float _535;
  float _536;
  float _571;
  float _582;
  float _593;
  float _635;
  float _646;
  float _657;
  float _708;
  float _719;
  float _730;
  float _751;
  float _752;
  float _753;
  float _813;
  float _838;
  float _839;
  float _840;
  if (_63) {
    float _69 = invLinearBegin * _58;
    bool _70 = (_58 >= linearBegin);
    float _71 = _69 * _69;
    float _72 = _69 * 2.0f;
    float _73 = 3.0f - _72;
    float _74 = _71 * _73;
    float _75 = invLinearBegin * _59;
    bool _76 = (_59 >= linearBegin);
    float _77 = _75 * _75;
    float _78 = _75 * 2.0f;
    float _79 = 3.0f - _78;
    float _80 = _77 * _79;
    float _81 = invLinearBegin * _60;
    bool _82 = (_60 >= linearBegin);
    float _83 = _81 * _81;
    float _84 = _81 * 2.0f;
    float _85 = 3.0f - _84;
    float _86 = _83 * _85;
    float _87 = 1.0f - _74;
    float _88 = select(_70, 0.0f, _87);
    float _89 = 1.0f - _80;
    float _90 = select(_76, 0.0f, _89);
    float _91 = 1.0f - _86;
    float _92 = select(_82, 0.0f, _91);
    bool _95 = (_58 < custom_linearStart);
    bool _96 = (_59 < custom_linearStart);
    bool _97 = (_60 < custom_linearStart);
    float _98 = select(_95, 0.0f, 1.0f);
    float _99 = select(_96, 0.0f, 1.0f);
    float _100 = select(_97, 0.0f, 1.0f);
    float _101 = 1.0f - _98;
    float _102 = _101 - _88;
    float _103 = 1.0f - _99;
    float _104 = _103 - _90;
    float _105 = 1.0f - _100;
    float _106 = _105 - _92;
    float _108 = log2(_69);
    float _109 = log2(_75);
    float _110 = log2(_81);
    float _111 = _108 * toe;
    float _112 = _109 * toe;
    float _113 = _110 * toe;
    float _114 = exp2(_111);
    float _115 = exp2(_112);
    float _116 = exp2(_113);
    float _117 = _114 * _88;
    float _118 = _117 * linearBegin;
    float _119 = _115 * _90;
    float _120 = _119 * linearBegin;
    float _121 = _116 * _92;
    float _122 = _121 * linearBegin;
    float _124 = contrast * _58;
    float _125 = contrast * _59;
    float _126 = contrast * _60;
    float _128 = _124 + madLinearStartContrastFactor;
    float _129 = _125 + madLinearStartContrastFactor;
    float _130 = _126 + madLinearStartContrastFactor;
    float _131 = _128 * _102;
    float _132 = _129 * _104;
    float _133 = _130 * _106;
    float _134 = _131 + _118;
    float _135 = _132 + _120;
    float _136 = _133 + _122;
    float _140 = contrastFactor * _58;
    float _141 = contrastFactor * _59;
    float _142 = contrastFactor * _60;
    float _144 = _140 + mulLinearStartContrastFactor;
    float _145 = _141 + mulLinearStartContrastFactor;
    float _146 = _142 + mulLinearStartContrastFactor;
    float _147 = exp2(_144);
    float _148 = exp2(_145);
    float _149 = exp2(_146);
    float _150 = _147 * displayMaxNitSubContrastFactor;
    float _151 = _148 * displayMaxNitSubContrastFactor;
    float _152 = _149 * displayMaxNitSubContrastFactor;
    float _153 = custom_maxNit - _150;
    float _154 = custom_maxNit - _151;
    float _155 = custom_maxNit - _152;
    float _156 = _153 * _98;
    float _157 = _154 * _99;
    float _158 = _155 * _100;
    float _159 = _134 + _156;
    float _160 = _135 + _157;
    float _161 = _136 + _158;
    _163 = _159;
    _164 = _160;
    _165 = _161;
  } else {
    _163 = 1.0f;
    _164 = 1.0f;
    _165 = 1.0f;
  }

  tonemapped = float3(_163, _164, _165);
  new_tonemap = HDRTonemap(untonemapped, tonemapped);
  _163 = new_tonemap.x;
  _164 = new_tonemap.y;
  _165 = new_tonemap.z;

  float _166 = _163;  // float _166 = saturate(_163);
  float _167 = _164;  // float _167 = saturate(_164);
  float _168 = _165;  // float _168 = saturate(_165);
  int _185 = cbRadialBlurFlags & 2;
  bool _186 = (_185 != 0);
  float _187 = float((bool)_186);
  float _188 = 1.0f - _187;
  float _191 = ComputeResultSRV[0].computeAlpha;
  float _192 = _191 * _187;
  float _193 = _188 + _192;
  float _194 = _193 * cbRadialColor.w;
  bool _195 = (_194 == 0.0f);
  if (!_195) {
    float _200 = screenInverseSize.x * SV_Position.x;
    float _201 = screenInverseSize.y * SV_Position.y;
    float _202 = -0.5f - cbRadialScreenPos.x;
    float _203 = _202 + _200;
    float _204 = -0.5f - cbRadialScreenPos.y;
    float _205 = _204 + _201;
    bool _206 = (_203 < 0.0f);
    float _207 = 1.0f - _200;
    float _208 = select(_206, _207, _200);
    bool _209 = (_205 < 0.0f);
    float _210 = 1.0f - _201;
    float _211 = select(_209, _210, _201);
    float _212 = _203 * _203;
    float _213 = _205 * _205;
    float _214 = _212 + _213;
    float _215 = sqrt(_214);
    float _216 = max(1.0f, _215);
    float _217 = 1.0f / _216;
    float _218 = cbRadialBlurPower * -0.0011111111380159855f;
    float _219 = _218 * _217;
    float _220 = _219 * _208;
    float _221 = _219 * _211;
    float _222 = _220 + 1.0f;
    float _223 = _221 + 1.0f;
    float _224 = _222 * _203;
    float _225 = _223 * _205;
    float _226 = cbRadialScreenPos.x + 0.5f;
    float _227 = _226 + _224;
    float _228 = cbRadialScreenPos.y + 0.5f;
    float _229 = _228 + _225;
    float4 _231 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_227, _229), 0.0f);
    float _235 = cbRadialBlurPower * -0.002222222276031971f;
    float _236 = _235 * _217;
    float _237 = _236 * _208;
    float _238 = _236 * _211;
    float _239 = _237 + 1.0f;
    float _240 = _238 + 1.0f;
    float _241 = _239 * _203;
    float _242 = _240 * _205;
    float _243 = _226 + _241;
    float _244 = _228 + _242;
    float4 _245 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_243, _244), 0.0f);
    float _249 = _245.x + _231.x;
    float _250 = _245.y + _231.y;
    float _251 = _245.z + _231.z;
    float _252 = cbRadialBlurPower * -0.0033333334140479565f;
    float _253 = _252 * _217;
    float _254 = _253 * _208;
    float _255 = _253 * _211;
    float _256 = _254 + 1.0f;
    float _257 = _255 + 1.0f;
    float _258 = _256 * _203;
    float _259 = _257 * _205;
    float _260 = _226 + _258;
    float _261 = _228 + _259;
    float4 _262 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_260, _261), 0.0f);
    float _266 = _249 + _262.x;
    float _267 = _250 + _262.y;
    float _268 = _251 + _262.z;
    float _269 = cbRadialBlurPower * -0.004444444552063942f;
    float _270 = _269 * _217;
    float _271 = _270 * _208;
    float _272 = _270 * _211;
    float _273 = _271 + 1.0f;
    float _274 = _272 + 1.0f;
    float _275 = _273 * _203;
    float _276 = _274 * _205;
    float _277 = _226 + _275;
    float _278 = _228 + _276;
    float4 _279 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_277, _278), 0.0f);
    float _283 = _266 + _279.x;
    float _284 = _267 + _279.y;
    float _285 = _268 + _279.z;
    float _286 = cbRadialBlurPower * -0.0055555556900799274f;
    float _287 = _286 * _217;
    float _288 = _287 * _208;
    float _289 = _287 * _211;
    float _290 = _288 + 1.0f;
    float _291 = _289 + 1.0f;
    float _292 = _290 * _203;
    float _293 = _291 * _205;
    float _294 = _226 + _292;
    float _295 = _228 + _293;
    float4 _296 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_294, _295), 0.0f);
    float _300 = _283 + _296.x;
    float _301 = _284 + _296.y;
    float _302 = _285 + _296.z;
    float _303 = cbRadialBlurPower * -0.006666666828095913f;
    float _304 = _303 * _217;
    float _305 = _304 * _208;
    float _306 = _304 * _211;
    float _307 = _305 + 1.0f;
    float _308 = _306 + 1.0f;
    float _309 = _307 * _203;
    float _310 = _308 * _205;
    float _311 = _226 + _309;
    float _312 = _228 + _310;
    float4 _313 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_311, _312), 0.0f);
    float _317 = _300 + _313.x;
    float _318 = _301 + _313.y;
    float _319 = _302 + _313.z;
    float _320 = cbRadialBlurPower * -0.007777777966111898f;
    float _321 = _320 * _217;
    float _322 = _321 * _208;
    float _323 = _321 * _211;
    float _324 = _322 + 1.0f;
    float _325 = _323 + 1.0f;
    float _326 = _324 * _203;
    float _327 = _325 * _205;
    float _328 = _226 + _326;
    float _329 = _228 + _327;
    float4 _330 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_328, _329), 0.0f);
    float _334 = _317 + _330.x;
    float _335 = _318 + _330.y;
    float _336 = _319 + _330.z;
    float _337 = cbRadialBlurPower * -0.008888889104127884f;
    float _338 = _337 * _217;
    float _339 = _338 * _208;
    float _340 = _338 * _211;
    float _341 = _339 + 1.0f;
    float _342 = _340 + 1.0f;
    float _343 = _341 * _203;
    float _344 = _342 * _205;
    float _345 = _226 + _343;
    float _346 = _228 + _344;
    float4 _347 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_345, _346), 0.0f);
    float _351 = _334 + _347.x;
    float _352 = _335 + _347.y;
    float _353 = _336 + _347.z;
    float _354 = cbRadialBlurPower * -0.009999999776482582f;
    float _355 = _354 * _217;
    float _356 = _355 * _208;
    float _357 = _355 * _211;
    float _358 = _356 + 1.0f;
    float _359 = _357 + 1.0f;
    float _360 = _358 * _203;
    float _361 = _359 * _205;
    float _362 = _226 + _360;
    float _363 = _228 + _361;
    float4 _364 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_362, _363), 0.0f);
    float _368 = _351 + _364.x;
    float _369 = _352 + _364.y;
    float _370 = _353 + _364.z;
    float _371 = cbRadialColor.x * 0.10000000149011612f;
    float _372 = _371 * _368;
    float _373 = cbRadialColor.y * 0.10000000149011612f;
    float _374 = _373 * _369;
    float _375 = cbRadialColor.z * 0.10000000149011612f;
    float _376 = _375 * _370;
    float _377 = min(_372, 65000.0f);
    float _378 = min(_374, 65000.0f);
    float _379 = min(_376, 65000.0f);
    float _380 = _377 * _47;
    float _381 = _378 * _47;
    float _382 = _379 * _47;

    untonemapped = ApplyCustomGrade1(float3(_380, _381, _382));
    _380 = untonemapped.x;
    _381 = untonemapped.y;
    _382 = untonemapped.z;

    float _383 = max(_380, _381);
    float _384 = max(_383, _382);
    bool _385 = isfinite(_384);
    if (_385) {
      float _391 = invLinearBegin * _380;
      bool _392 = (_380 >= linearBegin);
      float _393 = _391 * _391;
      float _394 = _391 * 2.0f;
      float _395 = 3.0f - _394;
      float _396 = _393 * _395;
      float _397 = invLinearBegin * _381;
      bool _398 = (_381 >= linearBegin);
      float _399 = _397 * _397;
      float _400 = _397 * 2.0f;
      float _401 = 3.0f - _400;
      float _402 = _399 * _401;
      float _403 = invLinearBegin * _382;
      bool _404 = (_382 >= linearBegin);
      float _405 = _403 * _403;
      float _406 = _403 * 2.0f;
      float _407 = 3.0f - _406;
      float _408 = _405 * _407;
      float _409 = 1.0f - _396;
      float _410 = select(_392, 0.0f, _409);
      float _411 = 1.0f - _402;
      float _412 = select(_398, 0.0f, _411);
      float _413 = 1.0f - _408;
      float _414 = select(_404, 0.0f, _413);
      bool _417 = (_380 < custom_linearStart);
      bool _418 = (_381 < custom_linearStart);
      bool _419 = (_382 < custom_linearStart);
      float _420 = select(_417, 0.0f, 1.0f);
      float _421 = select(_418, 0.0f, 1.0f);
      float _422 = select(_419, 0.0f, 1.0f);
      float _423 = 1.0f - _420;
      float _424 = _423 - _410;
      float _425 = 1.0f - _421;
      float _426 = _425 - _412;
      float _427 = 1.0f - _422;
      float _428 = _427 - _414;
      float _430 = log2(_391);
      float _431 = log2(_397);
      float _432 = log2(_403);
      float _433 = _430 * toe;
      float _434 = _431 * toe;
      float _435 = _432 * toe;
      float _436 = exp2(_433);
      float _437 = exp2(_434);
      float _438 = exp2(_435);
      float _439 = _436 * _410;
      float _440 = _439 * linearBegin;
      float _441 = _437 * _412;
      float _442 = _441 * linearBegin;
      float _443 = _438 * _414;
      float _444 = _443 * linearBegin;
      float _446 = contrast * _380;
      float _447 = contrast * _381;
      float _448 = contrast * _382;
      float _450 = _446 + madLinearStartContrastFactor;
      float _451 = _447 + madLinearStartContrastFactor;
      float _452 = _448 + madLinearStartContrastFactor;
      float _453 = _450 * _424;
      float _454 = _451 * _426;
      float _455 = _452 * _428;
      float _456 = _453 + _440;
      float _457 = _454 + _442;
      float _458 = _455 + _444;
      float _462 = contrastFactor * _380;
      float _463 = contrastFactor * _381;
      float _464 = contrastFactor * _382;
      float _466 = _462 + mulLinearStartContrastFactor;
      float _467 = _463 + mulLinearStartContrastFactor;
      float _468 = _464 + mulLinearStartContrastFactor;
      float _469 = exp2(_466);
      float _470 = exp2(_467);
      float _471 = exp2(_468);
      float _472 = _469 * displayMaxNitSubContrastFactor;
      float _473 = _470 * displayMaxNitSubContrastFactor;
      float _474 = _471 * displayMaxNitSubContrastFactor;
      float _475 = custom_maxNit - _472;
      float _476 = custom_maxNit - _473;
      float _477 = custom_maxNit - _474;
      float _478 = _475 * _420;
      float _479 = _476 * _421;
      float _480 = _477 * _422;
      float _481 = _456 + _478;
      float _482 = _457 + _479;
      float _483 = _458 + _480;
      _485 = _481;
      _486 = _482;
      _487 = _483;
    } else {
      _485 = 1.0f;
      _486 = 1.0f;
      _487 = 1.0f;
    }

    tonemapped = float3(_485, _486, _487);
    new_tonemap = HDRTonemap(untonemapped, tonemapped);
    _485 = new_tonemap.x;
    _486 = new_tonemap.y;
    _487 = new_tonemap.z;

    float _488 = _485;  // float _488 = saturate(_485);
    float _489 = _486;  // float _489 = saturate(_486);
    float _490 = _487;  // float _490 = saturate(_487);
    float _491 = _166 * 0.10000000149011612f;
    float _492 = _491 * cbRadialColor.x;
    float _493 = _167 * 0.10000000149011612f;
    float _494 = _493 * cbRadialColor.y;
    float _495 = _168 * 0.10000000149011612f;
    float _496 = _495 * cbRadialColor.z;
    float _497 = _488 + _492;
    float _498 = _489 + _494;
    float _499 = _490 + _496;
    bool _500 = (cbRadialMaskRate.x > 0.0f);
    if (_500) {
      float _502 = _215 * cbRadialMaskSmoothstep.x;
      float _503 = _502 + cbRadialMaskSmoothstep.y;
      float _504 = saturate(_503);
      float _505 = _504 * 2.0f;
      float _506 = 3.0f - _505;
      float _507 = _504 * _504;
      float _508 = _507 * cbRadialMaskRate.x;
      float _509 = _508 * _506;
      float _510 = _509 + cbRadialMaskRate.y;
      float _511 = _497 - _166;
      float _512 = _498 - _167;
      float _513 = _499 - _168;
      float _514 = _510 * _511;
      float _515 = _510 * _512;
      float _516 = _510 * _513;
      float _517 = _514 + _166;
      float _518 = _515 + _167;
      float _519 = _516 + _168;
      _521 = _517;
      _522 = _518;
      _523 = _519;
    } else {
      _521 = _497;
      _522 = _498;
      _523 = _499;
    }
    float _524 = _521 - _166;
    float _525 = _522 - _167;
    float _526 = _523 - _168;
    float _527 = _524 * _194;
    float _528 = _525 * _194;
    float _529 = _526 * _194;
    float _530 = _527 + _166;
    float _531 = _528 + _167;
    float _532 = _529 + _168;
    _534 = _530;
    _535 = _531;
    _536 = _532;
  } else {
    _534 = _166;
    _535 = _167;
    _536 = _168;
  }
  float _557 = _534;  // float _557 = saturate(_534);
  float _558 = _535;  // float _558 = saturate(_535);
  float _559 = _536;  // float _559 = saturate(_536);

  float3 ungraded = float3(_557, _558, _559);
  float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(ungraded);
  float gamut_compress_scale = renodx::color::correct::ComputeGamutCompressionScale(ungraded);
  float3 sdr_color = ungraded * scale;
  sdr_color = renodx::color::correct::GamutCompress(sdr_color, gamut_compress_scale);
  if (RENODX_TONE_MAP_TYPE > 0) {
    _557 = sdr_color.x;
    _558 = sdr_color.y;
    _559 = sdr_color.z;
  }

  float _560 = fTextureInverseSize * 0.5f;
  bool _561 = !(_557 <= 0.0031308000907301903f);
  [branch]
  if (!_561) {
    float _563 = _557 * 12.920000076293945f;
    _571 = _563;
  } else {
    float _565 = log2(_557);
    float _566 = _565 * 0.4166666567325592f;
    float _567 = exp2(_566);
    float _568 = _567 * 1.0549999475479126f;
    float _569 = _568 + -0.054999999701976776f;
    _571 = _569;
  }
  bool _572 = !(_558 <= 0.0031308000907301903f);
  [branch]
  if (!_572) {
    float _574 = _558 * 12.920000076293945f;
    _582 = _574;
  } else {
    float _576 = log2(_558);
    float _577 = _576 * 0.4166666567325592f;
    float _578 = exp2(_577);
    float _579 = _578 * 1.0549999475479126f;
    float _580 = _579 + -0.054999999701976776f;
    _582 = _580;
  }
  bool _583 = !(_559 <= 0.0031308000907301903f);
  [branch]
  if (!_583) {
    float _585 = _559 * 12.920000076293945f;
    _593 = _585;
  } else {
    float _587 = log2(_559);
    float _588 = _587 * 0.4166666567325592f;
    float _589 = exp2(_588);
    float _590 = _589 * 1.0549999475479126f;
    float _591 = _590 + -0.054999999701976776f;
    _593 = _591;
  }
  float _594 = 1.0f - fTextureInverseSize;
  float _595 = _571 * _594;
  float _596 = _582 * _594;
  float _597 = _593 * _594;
  float _598 = _595 + _560;
  float _599 = _596 + _560;
  float _600 = _597 + _560;
  bool _601 = (fTextureBlendRate > 0.0f);
  bool _602 = (fTextureBlendRate2 > 0.0f);
  bool _603 = _601 && _602;
  [branch]
  if (_603) {
    float4 _607 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_598, _599, _600), 0.0f);
    float4 _612 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_598, _599, _600), 0.0f);
    float _616 = _612.x - _607.x;
    float _617 = _612.y - _607.y;
    float _618 = _612.z - _607.z;
    float _619 = _616 * fTextureBlendRate;
    float _620 = _617 * fTextureBlendRate;
    float _621 = _618 * fTextureBlendRate;
    float _622 = _619 + _607.x;
    float _623 = _620 + _607.y;
    float _624 = _621 + _607.z;
    bool _625 = !(_622 <= 0.0031308000907301903f);
    [branch]
    if (!_625) {
      float _627 = _622 * 12.920000076293945f;
      _635 = _627;
    } else {
      float _629 = log2(_622);
      float _630 = _629 * 0.4166666567325592f;
      float _631 = exp2(_630);
      float _632 = _631 * 1.0549999475479126f;
      float _633 = _632 + -0.054999999701976776f;
      _635 = _633;
    }
    bool _636 = !(_623 <= 0.0031308000907301903f);
    [branch]
    if (!_636) {
      float _638 = _623 * 12.920000076293945f;
      _646 = _638;
    } else {
      float _640 = log2(_623);
      float _641 = _640 * 0.4166666567325592f;
      float _642 = exp2(_641);
      float _643 = _642 * 1.0549999475479126f;
      float _644 = _643 + -0.054999999701976776f;
      _646 = _644;
    }
    bool _647 = !(_624 <= 0.0031308000907301903f);
    [branch]
    if (!_647) {
      float _649 = _624 * 12.920000076293945f;
      _657 = _649;
    } else {
      float _651 = log2(_624);
      float _652 = _651 * 0.4166666567325592f;
      float _653 = exp2(_652);
      float _654 = _653 * 1.0549999475479126f;
      float _655 = _654 + -0.054999999701976776f;
      _657 = _655;
    }
    float4 _659 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_635, _646, _657), 0.0f);
    float _663 = _659.x - _622;
    float _664 = _659.y - _623;
    float _665 = _659.z - _624;
    float _666 = _663 * fTextureBlendRate2;
    float _667 = _664 * fTextureBlendRate2;
    float _668 = _665 * fTextureBlendRate2;
    float _669 = _666 + _622;
    float _670 = _667 + _623;
    float _671 = _668 + _624;
    _751 = _669;
    _752 = _670;
    _753 = _671;
  } else {
    if (_601) {
      float4 _674 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_598, _599, _600), 0.0f);
      float4 _679 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_598, _599, _600), 0.0f);
      float _683 = _679.x - _674.x;
      float _684 = _679.y - _674.y;
      float _685 = _679.z - _674.z;
      float _686 = _683 * fTextureBlendRate;
      float _687 = _684 * fTextureBlendRate;
      float _688 = _685 * fTextureBlendRate;
      float _689 = _686 + _674.x;
      float _690 = _687 + _674.y;
      float _691 = _688 + _674.z;
      _751 = _689;
      _752 = _690;
      _753 = _691;
    } else {
      if (_602) {
        float4 _694 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_598, _599, _600), 0.0f);
        bool _698 = !(_694.x <= 0.0031308000907301903f);
        [branch]
        if (!_698) {
          float _700 = _694.x * 12.920000076293945f;
          _708 = _700;
        } else {
          float _702 = log2(_694.x);
          float _703 = _702 * 0.4166666567325592f;
          float _704 = exp2(_703);
          float _705 = _704 * 1.0549999475479126f;
          float _706 = _705 + -0.054999999701976776f;
          _708 = _706;
        }
        bool _709 = !(_694.y <= 0.0031308000907301903f);
        [branch]
        if (!_709) {
          float _711 = _694.y * 12.920000076293945f;
          _719 = _711;
        } else {
          float _713 = log2(_694.y);
          float _714 = _713 * 0.4166666567325592f;
          float _715 = exp2(_714);
          float _716 = _715 * 1.0549999475479126f;
          float _717 = _716 + -0.054999999701976776f;
          _719 = _717;
        }
        bool _720 = !(_694.z <= 0.0031308000907301903f);
        [branch]
        if (!_720) {
          float _722 = _694.z * 12.920000076293945f;
          _730 = _722;
        } else {
          float _724 = log2(_694.z);
          float _725 = _724 * 0.4166666567325592f;
          float _726 = exp2(_725);
          float _727 = _726 * 1.0549999475479126f;
          float _728 = _727 + -0.054999999701976776f;
          _730 = _728;
        }
        float4 _732 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_708, _719, _730), 0.0f);
        float _736 = _732.x - _694.x;
        float _737 = _732.y - _694.y;
        float _738 = _732.z - _694.z;
        float _739 = _736 * fTextureBlendRate2;
        float _740 = _737 * fTextureBlendRate2;
        float _741 = _738 * fTextureBlendRate2;
        float _742 = _739 + _694.x;
        float _743 = _740 + _694.y;
        float _744 = _741 + _694.z;
        _751 = _742;
        _752 = _743;
        _753 = _744;
      } else {
        float4 _746 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_598, _599, _600), 0.0f);
        _751 = _746.x;
        _752 = _746.y;
        _753 = _746.z;
      }
    }
  }
  float _754 = _751 * (fColorMatrix[0].x);
  float _755 = mad(_752, (fColorMatrix[1].x), _754);
  float _756 = mad(_753, (fColorMatrix[2].x), _755);
  float _757 = _756 + (fColorMatrix[3].x);
  float _758 = _751 * (fColorMatrix[0].y);
  float _759 = mad(_752, (fColorMatrix[1].y), _758);
  float _760 = mad(_753, (fColorMatrix[2].y), _759);
  float _761 = _760 + (fColorMatrix[3].y);
  float _762 = _751 * (fColorMatrix[0].z);
  float _763 = mad(_752, (fColorMatrix[1].z), _762);
  float _764 = mad(_753, (fColorMatrix[2].z), _763);
  float _765 = _764 + (fColorMatrix[3].z);
  bool _768 = !(useDynamicRangeConversion == 0.0f);
  if (_768) {
    float _773 = _757 * 0.6699999570846558f;
    float _774 = mad(0.16500000655651093f, _761, _773);
    float _775 = mad(0.16500000655651093f, _765, _774);
    float _776 = _757 * 0.16500000655651093f;
    float _777 = mad(0.6699999570846558f, _761, _776);
    float _778 = mad(0.16500000655651093f, _765, _777);
    float _779 = mad(0.16500000655651093f, _761, _776);
    float _780 = mad(0.6699999570846558f, _765, _779);
    float _781 = _775 * 0.6370000243186951f;
    float _782 = mad(0.1446000039577484f, _778, _781);
    float _783 = mad(0.1688999980688095f, _780, _782);
    float _784 = _775 * 0.26269999146461487f;
    float _785 = mad(0.6779999732971191f, _778, _784);
    float _786 = mad(0.059300001710653305f, _780, _785);
    float _787 = mad(0.02810000069439411f, _778, 0.0f);
    float _788 = mad(1.0609999895095825f, _780, _787);
    float _789 = _786 + _783;
    float _790 = _789 + _788;
    float _791 = _783 / _790;
    float _792 = _786 / _790;
    float _793 = kneeStartNit / exposureScale;
    float _794 = _793 * 0.009999999776482582f;
    float _795 = 1.0f - knee;
    bool _796 = (_786 < _794);
    if (_796) {
      float _798 = _786 * exposureScale;
      _813 = _798;
    } else {
      float _800 = exposureScale * _795;
      float _801 = _800 * _794;
      float _802 = _794 * exposureScale;
      float _803 = log2(_795);
      float _804 = _801 * 0.6931471824645996f;
      float _805 = _804 * _803;
      float _806 = _802 - _805;
      float _807 = _786 / _794;
      float _808 = _807 - knee;
      float _809 = log2(_808);
      float _810 = _804 * _809;
      float _811 = _806 + _810;
      _813 = _811;
    }
    float _814 = _791 / _792;
    float _815 = _814 * _813;
    float _816 = 1.0f - _791;
    float _817 = _816 - _792;
    float _818 = _817 / _792;
    float _819 = _818 * _813;
    float _820 = _815 * 1.7166999578475952f;
    float _821 = mad(-0.35569998621940613f, _813, _820);
    float _822 = mad(-0.2533999979496002f, _819, _821);
    float _823 = _815 * -0.666700005531311f;
    float _824 = mad(1.6165000200271606f, _813, _823);
    float _825 = mad(0.015799999237060547f, _819, _824);
    float _826 = _815 * 0.01759999990463257f;
    float _827 = mad(-0.04280000180006027f, _813, _826);
    float _828 = mad(0.9420999884605408f, _819, _827);
    float _829 = _822 * 1.6534652709960938f;
    float _830 = mad(-0.32673269510269165f, _825, _829);
    float _831 = mad(-0.32673269510269165f, _828, _830);
    float _832 = _822 * -0.32673269510269165f;
    float _833 = mad(1.6534652709960938f, _825, _832);
    float _834 = mad(-0.32673269510269165f, _828, _833);
    float _835 = mad(-0.32673269510269165f, _825, _832);
    float _836 = mad(1.6534652709960938f, _828, _835);
    _838 = _831;
    _839 = _834;
    _840 = _836;
  } else {
    _838 = _757;
    _839 = _761;
    _840 = _765;
  }

  float3 graded = float3(_838, _839, _840);
  float3 new_grade = TonemappedGraded(graded, scale, gamut_compress_scale);
  _838 = new_grade.x;
  _839 = new_grade.y;
  _840 = new_grade.z;

  SV_Target.x = _838;
  SV_Target.y = _839;
  SV_Target.z = _840;
  SV_Target.w = 0.0f;

  // untonemapped is linear
  SV_Target.rgb = Tonemap(SV_Target.rgb);
  return SV_Target;
}
