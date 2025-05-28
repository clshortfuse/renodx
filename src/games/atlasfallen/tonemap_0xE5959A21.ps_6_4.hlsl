#include "./shared.h"

Texture2D<float4> globalTextures[8192] : register(t0, space1);

Texture2D<float4> sceneHDRTex : register(t0);

Texture2D<float4> filmgrainNoiseTex : register(t1);

Texture2D<float4> distortTex : register(t2);

Texture2D<float4> bloomTex : register(t3);

Texture2D<float4> lensflareTex : register(t4);

Texture2D<float4> motionBlurTex : register(t5);

Texture3D<float4> colorGradingLutTex : register(t6);

Texture2D<float4> radialBlurTex : register(t7);

StructuredBuffer<float> avgLum : register(t8);

cbuffer PerFrame : register(b0) {
  float4 FrameParameters0 : packoffset(c000.x);
  uint4 frameIndexMod_2_4_8_16 : packoffset(c001.x);
  float4 haltonSamples : packoffset(c002.x);
  float4 chromashiftParameters : packoffset(c003.x);
  float4 vignetteParameters : packoffset(c004.x);
  float4 postCombineParams0 : packoffset(c005.x);
  float4 postCombineParams1 : packoffset(c006.x);
  float4 radialBlurParameters : packoffset(c007.x);
  float4 photomodeParameters0 : packoffset(c008.x);
  float4 photomodeParameters1 : packoffset(c009.x);
  float4 dynamicResolutionMaxUV : packoffset(c010.x);
  float4 dynamicResolutionPostUpsampleMaxUV : packoffset(c011.x);
};

cbuffer PerRenderPass : register(b1) {
  float4 viewportSize : packoffset(c000.x);
};

cbuffer PerView : register(b2) {
  float4 dynamicResolutionParameters : packoffset(c000.x);
  float4 postUpsampleDynamicResolutionParameters : packoffset(c001.x);
};

SamplerState linearClampSampler : register(s0);

SamplerState nearestClampSampler : register(s2);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 UV : UV
) : SV_Target {
  float4 SV_Target;
  bool _21 = (photomodeParameters1.x > 0.0f);
  float _35;
  float _36;
  float _54;
  float _55;
  float _70;
  float _213;
  float _214;
  float _215;
  float _304;
  float _305;
  float _306;
  float _372;
  float _387;
  float _402;
  float _477;
  float _478;
  float _479;
  if (_21) {
    bool _25 = (photomodeParameters0.x > 0.0f);
    if (_25) {
      float _28 = photomodeParameters0.y * UV.x;
      float _29 = photomodeParameters0.y * UV.y;
      float _30 = round(_28);
      float _31 = round(_29);
      float _32 = _30 / photomodeParameters0.y;
      float _33 = _31 / photomodeParameters0.y;
      _35 = _32;
      _36 = _33;
    } else {
      _35 = UV.x;
      _36 = UV.y;
    }
  } else {
    _35 = UV.x;
    _36 = UV.y;
  }
  float _40 = dynamicResolutionParameters.x * _35;
  float _41 = dynamicResolutionParameters.y * _36;
  float4 _42 = distortTex.SampleLevel(nearestClampSampler, float2(_40, _41), 0.0f);
  bool _45 = (_42.w > 0.0010000000474974513f);
  if (_45) {
    float _49 = _42.x * 0.10000000149011612f;
    float _50 = _42.y * 0.10000000149011612f;
    float _51 = _49 + _35;
    float _52 = _50 + _36;
    _54 = _51;
    _55 = _52;
  } else {
    _54 = _35;
    _55 = _36;
  }
  float _56 = 0.5f - _35;
  float _57 = 0.5f - _36;
  bool _58 = (photomodeParameters1.x < 0.0f);
  if (_58) {
    float _62 = dot(float2(_56, _57), float2(_56, _57));
    float _63 = saturate(_62);
    float _64 = log2(_63);
    float _65 = _64 * chromashiftParameters.w;
    float _66 = exp2(_65);
    float _68 = chromashiftParameters.x * _66;
    _70 = _68;
  } else {
    _70 = 0.0f;
  }
  float _73 = chromashiftParameters.z * _70;
  float _75 = _70 * 0.0010000000474974513f;
  float _76 = _75 * chromashiftParameters.y;
  float _77 = _76 + _42.z;
  float _80 = postCombineParams0.z * 0.004999999888241291f;
  uint2 _82; sceneHDRTex.GetDimensions(_82.x, _82.y);
  float _89 = 0.5f - _54;
  float _90 = 0.5f - _55;
  float _91 = _89 * _89;
  float _92 = _90 * _90;
  float _93 = _92 + _91;
  float _94 = sqrt(_93);
  float _95 = _94 * postCombineParams0.w * CUSTOM_CHROMATIC_ABERRATION;
  float _96 = _95 * _80;
  float _97 = _54 + -0.5f;
  float _98 = _55 + -0.5f;
  float _99 = dot(float2(_97, _98), float2(_97, _98));
  float _100 = _99 * _73;
  float _101 = 1.0f - _100;
  float _102 = _77 * 8.0f;
  float _103 = _102 + 1.0f;
  float _104 = _77 * 3.0f;
  float _105 = _104 + 1.0f;
  float _106 = _77 + 1.0f;
  float _107 = _101 * _103;
  float _108 = _101 * _105;
  float _109 = _101 * _106;
  float _110 = _107 * _97;
  float _111 = _107 * _98;
  float _112 = _108 * _97;
  float _113 = _108 * _98;
  float _114 = _112 + 0.5f;
  float _115 = _113 + 0.5f;
  float _116 = _109 * _97;
  float _117 = _109 * _98;
  float _118 = _114 * postUpsampleDynamicResolutionParameters.x;
  float _119 = _115 * postUpsampleDynamicResolutionParameters.y;
  float _120 = _96 + 0.5f;
  float _121 = _120 + _110;
  float _122 = _121 * postUpsampleDynamicResolutionParameters.x;
  float _123 = _120 + _111;
  float _124 = _123 * postUpsampleDynamicResolutionParameters.y;
  float _125 = min(_122, dynamicResolutionPostUpsampleMaxUV.x);
  float _126 = min(_124, dynamicResolutionPostUpsampleMaxUV.y);
  float _127 = min(_118, dynamicResolutionPostUpsampleMaxUV.x);
  float _128 = min(_119, dynamicResolutionPostUpsampleMaxUV.y);
  float _129 = 0.5f - _96;
  float _130 = _129 + _116;
  float _131 = _130 * postUpsampleDynamicResolutionParameters.x;
  float _132 = _129 + _117;
  float _133 = _132 * postUpsampleDynamicResolutionParameters.y;
  float _134 = min(_131, dynamicResolutionPostUpsampleMaxUV.x);
  float _135 = min(_133, dynamicResolutionPostUpsampleMaxUV.y);
  float4 _136 = sceneHDRTex.SampleLevel(linearClampSampler, float2(_125, _126), 0.0f);
  float4 _138 = sceneHDRTex.SampleLevel(linearClampSampler, float2(_127, _128), 0.0f);
  float4 _140 = sceneHDRTex.SampleLevel(linearClampSampler, float2(_134, _135), 0.0f);
  float4 _142 = motionBlurTex.SampleLevel(linearClampSampler, float2(_121, _123), 0.0f);
  float4 _144 = motionBlurTex.SampleLevel(linearClampSampler, float2(_114, _115), 0.0f);
  float4 _146 = motionBlurTex.SampleLevel(linearClampSampler, float2(_130, _132), 0.0f);
  float _149 = saturate(_146.w);
  float _150 = _142.x - _136.x;
  float _151 = _144.y - _138.y;
  float _152 = _146.z - _140.z;
  float _153 = _149 * _150;
  float _154 = _149 * _151;
  float _155 = _152 * _149;
  float _156 = _153 + _136.x;
  float _157 = _154 + _138.y;
  float _158 = _155 + _140.z;
  if (_21) {
    float _161 = float((uint)_82.y);
    float _163 = float((uint)_82.x);
    float _164 = 1.5f / _163;
    float _165 = 1.5f / _161;
    float _166 = _35 - _164;
    float _167 = _36 - _165;
    float _168 = postUpsampleDynamicResolutionParameters.x * _166;
    float _169 = postUpsampleDynamicResolutionParameters.y * _167;
    float4 _170 = sceneHDRTex.SampleLevel(nearestClampSampler, float2(_168, _169), 0.0f);
    float _174 = _164 + _35;
    float _175 = postUpsampleDynamicResolutionParameters.x * _174;
    float4 _176 = sceneHDRTex.SampleLevel(nearestClampSampler, float2(_175, _169), 0.0f);
    float _180 = _165 + _36;
    float _181 = postUpsampleDynamicResolutionParameters.y * _180;
    float4 _182 = sceneHDRTex.SampleLevel(nearestClampSampler, float2(_168, _181), 0.0f);
    float4 _186 = sceneHDRTex.SampleLevel(nearestClampSampler, float2(_175, _181), 0.0f);
    float _190 = _176.x + _170.x;
    float _191 = _176.y + _170.y;
    float _192 = _176.z + _170.z;
    float _193 = _190 + _182.x;
    float _194 = _191 + _182.y;
    float _195 = _192 + _182.z;
    float _196 = _193 + _186.x;
    float _197 = _194 + _186.y;
    float _198 = _195 + _186.z;
    float _199 = _196 * 0.25f;
    float _200 = _197 * 0.25f;
    float _201 = _198 * 0.25f;
    float _202 = _156 - _199;
    float _203 = _157 - _200;
    float _204 = _158 - _201;
    float _206 = _202 * photomodeParameters1.z;
    float _207 = _203 * photomodeParameters1.z;
    float _208 = _204 * photomodeParameters1.z;
    float _209 = _206 + _156;
    float _210 = _207 + _157;
    float _211 = _208 + _158;
    _213 = _209;
    _214 = _210;
    _215 = _211;
  } else {
    _213 = _156;
    _214 = _157;
    _215 = _158;
  }
  float4 _216 = bloomTex.SampleLevel(linearClampSampler, float2(_121, _123), 0.0f);
  float4 _218 = bloomTex.SampleLevel(linearClampSampler, float2(_114, _115), 0.0f);
  float4 _220 = bloomTex.SampleLevel(linearClampSampler, float2(_130, _132), 0.0f);
  float4 _222 = lensflareTex.SampleLevel(linearClampSampler, float2(_35, _36), 0.0f);
  int _228 = asint(vignetteParameters.z);
  uint _230 = _228 + 0u;
  float4 _232 = globalTextures[_230].SampleLevel(linearClampSampler, float2(_35, _36), 0.0f);
  float _236 = _232.x * vignetteParameters.w;
  float _237 = _232.y * vignetteParameters.w;
  float _238 = _232.z * vignetteParameters.w;
  float _241 = postCombineParams0.y + _236;
  float _242 = postCombineParams0.y + _237;
  float _243 = postCombineParams0.y + _238;
  float _244 = saturate(_241);
  float _245 = saturate(_242);
  float _246 = saturate(_243);
  float _247 = _216.x - _213;
  float _248 = _247 + _222.x;
  float _249 = _218.y - _214;
  float _250 = _249 + _222.y;
  float _251 = _220.z - _215;
  float _252 = _251 + _222.z;
  float _253 = _244 * _248;
  float _254 = _245 * _250;
  float _255 = _246 * _252;
  float _256 = _253 + _213;
  float _257 = _254 + _214;
  float _258 = _255 + _215;
  float _259 = _35 + -0.5f;
  float _260 = _36 + -0.5f;
  float _263 = vignetteParameters.x * _259;
  float _264 = vignetteParameters.x * _260;
  float _266 = dot(float2(_263, _264), float2(_263, _264));
  float _267 = 1.0f - _266;
  float _268 = saturate(_267);
  float _269 = log2(_268);
  float _270 = _269 * vignetteParameters.y;
  float _271 = exp2(_270);
  float _272 = _271 * _256;
  float _273 = _271 * _257;
  float _274 = _271 * _258;
  bool _277 = (radialBlurParameters.z > 0.0f);
  if (_277) {
    float _280 = radialBlurParameters.x * 0.5f;
    bool _282 = (radialBlurParameters.y > 0.0f);
    float _283 = _56 * _56;
    float _284 = _57 * _57;
    float _285 = _284 + _283;
    float _286 = sqrt(_285);
    float4 _287 = radialBlurTex.SampleLevel(linearClampSampler, float2(_35, _36), 0.0f);
    float _291 = 1.0f - _286;
    float _292 = select(_282, _291, _286);
    float _293 = _280 * _292;
    float _294 = _287.x - _272;
    float _295 = _287.y - _273;
    float _296 = _287.z - _274;
    float _297 = _294 * _293;
    float _298 = _295 * _293;
    float _299 = _296 * _293;
    float _300 = _297 + _272;
    float _301 = _298 + _273;
    float _302 = _299 + _274;
    _304 = _300;
    _305 = _301;
    _306 = _302;
  } else {
    _304 = _272;
    _305 = _273;
    _306 = _274;
  }
  
  float3 untonemapped = float3(_304, _305, _306);
  
  float luminance = avgLum[2]; // exposure
  
  untonemapped *= luminance;

  float3 displaymappedColor = untonemapped;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    if (CUSTOM_DISPLAY_MAP_TYPE == 1.f) {
      displaymappedColor = renodx::tonemap::dice::BT709(untonemapped, 1.f, 0.f);
    }
    else if (CUSTOM_DISPLAY_MAP_TYPE == 2.f) {
      displaymappedColor = renodx::tonemap::frostbite::BT709(untonemapped, 1.f, 0.f, 1.f);
    }
    else if (CUSTOM_DISPLAY_MAP_TYPE == 3.f) {
      untonemapped = min(100.f, untonemapped);
      displaymappedColor = renodx::tonemap::renodrt::NeutralSDR(untonemapped);
    }

    displaymappedColor = lerp(untonemapped, displaymappedColor, saturate(renodx::color::y::from::BT709(untonemapped)));

    displaymappedColor /= luminance;

    _304 = displaymappedColor.r;
    _305 = displaymappedColor.g;
    _306 = displaymappedColor.b;
  }
  
  float _308 = avgLum[2];
  float _309 = _304 * 0.009999999776482582f;
  float _310 = _309 * _308;
  float _311 = _305 * 0.009999999776482582f;
  float _312 = _311 * _308;
  float _313 = _306 * 0.009999999776482582f;
  float _314 = _313 * _308;
  float _315 = log2(_310);
  float _316 = log2(_312);
  float _317 = log2(_314);
  float _318 = _315 * 0.1593017578125f;
  float _319 = _316 * 0.1593017578125f;
  float _320 = _317 * 0.1593017578125f;
  float _321 = exp2(_318);
  float _322 = exp2(_319);
  float _323 = exp2(_320);
  float _324 = _321 * 18.8515625f;
  float _325 = _322 * 18.8515625f;
  float _326 = _323 * 18.8515625f;
  float _327 = _324 + 0.8359375f;
  float _328 = _325 + 0.8359375f;
  float _329 = _326 + 0.8359375f;
  float _330 = _321 * 18.6875f;
  float _331 = _322 * 18.6875f;
  float _332 = _323 * 18.6875f;
  float _333 = _330 + 1.0f;
  float _334 = _331 + 1.0f;
  float _335 = _332 + 1.0f;
  float _336 = _327 / _333;
  float _337 = _328 / _334;
  float _338 = _329 / _335;
  float _339 = log2(_336);
  float _340 = log2(_337);
  float _341 = log2(_338);
  float _342 = _339 * 78.84375f;
  float _343 = _340 * 78.84375f;
  float _344 = _341 * 78.84375f;
  float _345 = exp2(_342);
  float _346 = exp2(_343);
  float _347 = exp2(_344);
  float _348 = _345 * 0.9696969985961914f;
  float _349 = _346 * 0.9696969985961914f;
  float _350 = _347 * 0.9696969985961914f;
  float _351 = _348 + 0.01515151560306549f;
  float _352 = _349 + 0.01515151560306549f;
  float _353 = _350 + 0.01515151560306549f;

  //float4 _354 = colorGradingLutTex.SampleLevel(linearClampSampler, float3(_351, _352, _353), 0.0f);

  float4 _354 = 0.f;
  _354.rgb = renodx::lut::SampleTetrahedral(colorGradingLutTex, float3(_351, _352, _353), 32.f);

  bool _358 = !(_354.x <= 0.0f);
  if (_358) {
    bool _360 = !(_354.x <= 0.040449999272823334f);
    if (!_360) {
      float _362 = _354.x * 0.07739938050508499f;
      _372 = _362;
    } else {
      bool _364 = !(_354.x <= 1.0f);
      if (!_364) {
        float _366 = _354.x + 0.054999999701976776f;
        float _367 = _366 * 0.9478673338890076f;
        float _368 = log2(_367);
        float _369 = _368 * 2.4000000953674316f;
        float _370 = exp2(_369);
        _372 = _370;
      } else {
        _372 = 1.0f;
      }
    }
  } else {
    _372 = 0.0f;
  }
  bool _373 = !(_354.y <= 0.0f);
  if (_373) {
    bool _375 = !(_354.y <= 0.040449999272823334f);
    if (!_375) {
      float _377 = _354.y * 0.07739938050508499f;
      _387 = _377;
    } else {
      bool _379 = !(_354.y <= 1.0f);
      if (!_379) {
        float _381 = _354.y + 0.054999999701976776f;
        float _382 = _381 * 0.9478673338890076f;
        float _383 = log2(_382);
        float _384 = _383 * 2.4000000953674316f;
        float _385 = exp2(_384);
        _387 = _385;
      } else {
        _387 = 1.0f;
      }
    }
  } else {
    _387 = 0.0f;
  }
  bool _388 = !(_354.z <= 0.0f);
  if (_388) {
    bool _390 = !(_354.z <= 0.040449999272823334f);
    if (!_390) {
      float _392 = _354.z * 0.07739938050508499f;
      _402 = _392;
    } else {
      bool _394 = !(_354.z <= 1.0f);
      if (!_394) {
        float _396 = _354.z + 0.054999999701976776f;
        float _397 = _396 * 0.9478673338890076f;
        float _398 = log2(_397);
        float _399 = _398 * 2.4000000953674316f;
        float _400 = exp2(_399);
        _402 = _400;
      } else {
        _402 = 1.0f;
      }
    }
  } else {
    _402 = 0.0f;
  }
  
  float _410 = postCombineParams0.x * 0.007858515717089176f;
  float _411 = viewportSize.z * _35;
  float _412 = viewportSize.w * _36;
  int _413 = int(_411);
  int _414 = int(_412);
  float _415 = haltonSamples.x * 255.0f;
  float _416 = haltonSamples.y * 255.0f;
  int _417 = int(_415);
  int _418 = int(_416);
  uint _419 = _413 + _417;
  uint _420 = _414 + _418;
  int _421 = _419 & 255;
  int _422 = _420 & 255;
  float4 _423 = filmgrainNoiseTex.Load(int3(_421, _422, 0));
  float _427 = _423.x * 2.0f;
  float _428 = _423.y * 2.0f;
  float _429 = _423.z * 2.0f;
  float _430 = _427 + -1.0f;
  float _431 = _428 + -1.0f;
  float _432 = _429 + -1.0f;
  float _433 = sqrt(_372);
  float _434 = sqrt(_387);
  float _435 = sqrt(_402);
  float _436 = _433 + 7.689350240980275e-06f;
  float _437 = _434 + 7.689350240980275e-06f;
  float _438 = _435 + 7.689350240980275e-06f;
  float _439 = min(_436, _410);
  float _440 = min(_437, _410);
  float _441 = min(_438, _410);
  float _442 = _439 * _430;
  float _443 = _440 * _431;
  float _444 = _441 * _432;
  float _445 = _442 + _433;
  float _446 = _443 + _434;
  float _447 = _444 + _435;
  float _448 = _445 * _445;
  float _449 = _446 * _446;
  float _450 = _447 * _447;
  bool _453 = (photomodeParameters1.x > 0.0f);
  if (_453) {
    float _456 = 1.0f - photomodeParameters1.w;
    float _457 = _456 * 0.3086000084877014f;
    float _458 = _457 + photomodeParameters1.w;
    float _459 = _456 * 0.6093999743461609f;
    float _460 = _459 + photomodeParameters1.w;
    float _461 = _456 * 0.0820000022649765f;
    float _462 = _461 + photomodeParameters1.w;
    float _464 = _458 * _448;
    float _465 = mad(_459, _449, _464);
    float _466 = mad(_461, _450, _465);
    float _467 = _466 + photomodeParameters1.y;
    float _468 = _448 * 0.3086000084877014f;
    float _469 = _468 * _456;
    float _470 = mad(_460, _449, _469);
    float _471 = mad(_461, _450, _470);
    float _472 = _471 + photomodeParameters1.y;
    float _473 = mad(_459, _449, _469);
    float _474 = mad(_462, _450, _473);
    float _475 = _474 + photomodeParameters1.y;
    _477 = _467;
    _478 = _472;
    _479 = _475;
  } else {
    _477 = _448;
    _478 = _449;
    _479 = _450;
  }
  float _482 = dot(float3(0.28999999165534973f, 0.5f, 0.10999999940395355f), float3(_477, _478, _479));
  float _483 = _482 + -0.5199999809265137f;
  float _484 = _483 * 33.33329772949219f;
  float _485 = saturate(_484);
  float _486 = _485 * 2.0f;
  float _487 = 3.0f - _486;
  float _488 = _485 * _485;
  float _489 = _488 * _487;
  float _490 = _489 - _477;
  float _491 = _489 - _478;
  float _492 = _489 - _479;
  float _493 = _490 * postCombineParams1.x;
  float _494 = _491 * postCombineParams1.x;
  float _495 = _492 * postCombineParams1.x;
  float _496 = _493 + _477;
  float _497 = _494 + _478;
  float _498 = _495 + _479;
  float _501 = float((uint)(int)(frameIndexMod_2_4_8_16.w));
  float _502 = _501 + 1.0f;
  float _503 = SV_Position.x * 0.1031000018119812f;
  float _504 = SV_Position.y * 0.1031000018119812f;
  float _505 = _502 * 0.1031000018119812f;
  float _506 = frac(_503);
  float _507 = frac(_504);
  float _508 = frac(_505);
  float _509 = _508 + 31.31999969482422f;
  float _510 = _507 + 31.31999969482422f;
  float _511 = _506 + 31.31999969482422f;
  float _512 = dot(float3(_506, _507, _508), float3(_509, _510, _511));
  float _513 = _512 + _508;
  float _514 = _512 * 2.0f;
  float _515 = _507 + _506;
  float _516 = _515 + _514;
  float _517 = _516 * _513;
  float _518 = frac(_517);
  float _519 = _501 + 2.0f;
  float _520 = _519 * 0.1031000018119812f;
  float _521 = frac(_520);
  float _522 = _521 + 31.31999969482422f;
  float _523 = dot(float3(_506, _507, _521), float3(_522, _510, _511));
  float _524 = _523 + _521;
  float _525 = _523 * 2.0f;
  float _526 = _515 + _525;
  float _527 = _526 * _524;
  float _528 = frac(_527);
  float _529 = _518 + -1.0f;
  float _530 = _529 + _528;
  float _531 = dot(float3(_496, _497, _498), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _532 = saturate(_531);
  float _533 = _532 * 0.03125f;
  float _534 = _533 * _530;
  float _535 = _534 + _496;
  float _536 = _534 + _497;
  float _537 = _534 + _498;
  SV_Target.x = _535;
  SV_Target.y = _536;
  SV_Target.z = _537;
  SV_Target.w = 1.0f;
  
  float3 graded = float3(_535, _536, _537);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    untonemapped = renodx::color::grade::UserColorGrading(
      untonemapped,
      1.f,
      1.f,
      1.f,
      1.6f,
      1.6f,
      0.8f);
    
    untonemapped = min(100.f, untonemapped);
    SV_Target.rgb = renodx::draw::ToneMapPass(untonemapped, graded);
  }

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);
  
  return SV_Target;
}
