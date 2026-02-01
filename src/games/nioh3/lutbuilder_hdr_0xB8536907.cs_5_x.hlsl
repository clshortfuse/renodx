#include "./common.hlsl"

cbuffer cb4_buf : register(b4) {
  float2 cb4_m0 : packoffset(c0);
  float2 cb4_m1 : packoffset(c0.z);
  float4 cb4_m2 : packoffset(c1);
  float2 cb4_m3 : packoffset(c2);
  float2 cb4_m4 : packoffset(c2.z);
};

Texture3D<float4> t0 : register(t0);  // was t1
RWTexture3D<float4> u0 : register(u0);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

int cvt_f32_i32(float v) {
  return isnan(v) ? 0
                  : ((v < (-2147483648.0f))
                         ? int(0x80000000)
                         : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

float dp3_f32(float3 a, float3 b) {
  precise float _201 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _201));
}

float4 vanillaTonemapper(float3 color) {
  uint3 _232 = uint3(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y,
                     gl_GlobalInvocationID.z);
  float3 _371 = color;
  float _372 =
      dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f,
                     0.16386906802654266357421875f),
              _371);
  float _373 =
      dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f,
                     0.095534317195415496826171875f),
              _371);
  float _374 = dp3_f32(float3(-0.0055258828215301036834716796875f,
                              0.0040252101607620716094970703125f,
                              1.00150072574615478515625f),
                       _371);
  bool _375 = _372 < _373;
  float _427;
  float _428;
  float _429;
  if (_375) {
    bool _379 = _373 < _374;
    float _380 = _374 - _372;
    bool _381 = _380 > 0.0f;
    float _382 = _372 - _373;
    float _383 = _382 * 60.0f;
    float _384 = _383 / _380;
    float _385 = _384 + 240.0f;
    float _386 = _381 ? _385 : 0.0f;
    bool _387 = _372 < _374;
    float _388 = _373 - _372;
    bool _389 = _388 > 0.0f;
    float _390 = _380 * 60.0f;
    float _391 = _390 / _388;
    float _392 = _391 + 120.0f;
    float _393 = _373 - _374;
    bool _394 = _393 > 0.0f;
    float _395 = _390 / _393;
    float _396 = _395 + 120.0f;
    float _397 = _389 ? _392 : 0.0f;
    float _398 = _394 ? _396 : 0.0f;
    float _399 = _387 ? _397 : _398;
    float _400 = _387 ? _388 : _393;
    float _401 = _379 ? _374 : _373;
    float _402 = _379 ? _380 : _400;
    float _403 = _379 ? _386 : _399;
    _427 = _402;
    _428 = _401;
    _429 = _403;
  } else {
    bool _404 = _372 < _374;
    float _405 = _374 - _373;
    bool _406 = _405 > 0.0f;
    float _407 = _372 - _373;
    float _408 = _407 * 60.0f;
    float _409 = _408 / _405;
    float _410 = _409 + 240.0f;
    float _411 = _406 ? _410 : 0.0f;
    bool _412 = _373 < _374;
    bool _413 = _407 > 0.0f;
    float _414 = _373 - _374;
    float _415 = _414 * 60.0f;
    float _416 = _415 / _407;
    float _417 = _372 - _374;
    bool _418 = _417 > 0.0f;
    float _419 = _415 / _417;
    float _420 = _413 ? _416 : 0.0f;
    float _421 = _418 ? _419 : 0.0f;
    float _422 = _412 ? _420 : _421;
    float _423 = _412 ? _407 : _417;
    float _424 = _404 ? _374 : _372;
    float _425 = _404 ? _405 : _423;
    float _426 = _404 ? _411 : _422;
    _427 = _425;
    _428 = _424;
    _429 = _426;
  }
  bool _430 = _429 < 0.0f;
  bool _431 = _429 > 360.0f;
  float _432 = _429 + 360.0f;
  float _433 = _429 - 360.0f;
  float _434 = _431 ? _433 : _429;
  float _435 = _430 ? _432 : _434;
  bool _436 = _428 == 0.0f;
  float _437 = _427 / _428;
  float _438 = _436 ? 0.0f : _437;
  float _439 = _374 - _373;
  float _440 = _373 - _372;
  float _441 = _373 * _440;
  float _442 = _374 * _439;
  float _443 = _441 + _442;
  float _444 = _372 - _374;
  float _445 = mad(_372, _444, _443);
  float _446 = sqrt(_445);
  float _447 = _372 + _373;
  float _448 = _374 + _447;
  float _449 = _446 + _448;
  float _450 = _449 + 1.75f;
  float _451 = _450 * 0.3333333432674407958984375f;
  float _452 = _438 - 0.4000000059604644775390625f;
  float _453 = _452 * 2.5f;
  float _454 = abs(_453);
  float _455 = 1.0f - _454;
  float _456 = max(_455, 0.0f);
  bool _457 = _452 >= 0.0f;
  float _458 = _457 ? 1.0f : (-1.0f);
  float _459 = -_456;
  float _460 = mad(_459, _456, 1.0f);
  float _461 = mad(_460, _458, 1.0f);
  float _462 = _461 * 0.02500000037252902984619140625f;
  bool _463 = _450 <= 0.1599999964237213134765625f;
  float _464 = mad(_461, 0.02500000037252902984619140625f, 1.0f);
  bool _465 = _450 >= 0.4799999892711639404296875f;
  float _466 = 0.07999999821186065673828125f / _451;
  float _467 = _466 - 0.5f;
  float _468 = mad(_462, _467, 1.0f);
  float _469 = _465 ? 1.0f : _468;
  float _470 = _463 ? _464 : _469;
  float _471 = _372 * _470;
  float _472 = _373 * _470;
  float _473 = _374 * _470;
  float _474 = _435 * 1.0f;
  bool _475 = _435 < (-180.0f);
  bool _476 = _435 > 180.0f;
  float _477 = mad(_435, 1.0f, 360.0f);
  float _478 = mad(_435, 1.0f, -360.0f);
  float _479 = _476 ? _478 : _474;
  float _480 = _475 ? _477 : _479;
  float _481 = _480 * 2.439024448394775390625f;
  float _482 = abs(_481);
  float _483 = 1.0f - _482;
  float _484 = max(_483, 0.0f);
  float _485 = mad(_484, -2.0f, 3.0f);
  float _486 = _484 * _484;
  float _487 = _485 * _486;
  float _488 = _487 * _487;
  float _489 = _488 * _438;
  float _490 = -_372;
  float _491 = mad(_490, _470, 0.02999999932944774627685546875f);
  float _492 = _489 * _491;
  float _493 = _492 * 0.180000007152557373046875f;
  float _494 = _471 + _493;
  float _495 = clamp(_494, 0.0f, 65504.0f);
  float _496 = clamp(_472, 0.0f, 65504.0f);
  float _497 = clamp(_473, 0.0f, 65504.0f);
  float3 _498 = float3(_495, _496, _497);
  float _499 =
      dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f,
                     -0.214928567409515380859375f),
              _498);
  float _500 =
      dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f,
                     -0.0996759235858917236328125f),
              _498);
  float _501 = dp3_f32(float3(0.0083161480724811553955078125f,
                              -0.0060324496589601039886474609375f,
                              0.99771630764007568359375f),
                       _498);
  float _502 = clamp(_499, 0.0f, 65504.0f);
  float _503 = clamp(_500, 0.0f, 65504.0f);
  float _504 = clamp(_501, 0.0f, 65504.0f);
  float3 _505 = float3(_502, _503, _504);
  float _506 = dp3_f32(_505, float3(0.2722289860248565673828125f,
                                    0.674081981182098388671875f,
                                    0.0536894984543323516845703125f));
  float _507 = _502 - _506;
  float _508 = _503 - _506;
  float _509 = _504 - _506;
  float _510 = mad(_507, 0.959999978542327880859375f, _506);
  float _511 = mad(_508, 0.959999978542327880859375f, _506);
  float _512 = mad(_509, 0.959999978542327880859375f, _506);
  float _517 = cb4_m0.x / cb4_m0.y;
  float _518 = cb4_m0.y / cb4_m0.x;
  bool _519 = _510 > 0.5f;
  bool _520 = _511 > 0.5f;
  bool _521 = _512 > 0.5f;
  float _522 = _510 - 0.5f;
  float _523 = _511 - 0.5f;
  float _524 = _512 - 0.5f;
  float _525 = _522 * (-0.13750354945659637451171875f);
  float _526 = _523 * (-0.13750354945659637451171875f);
  float _527 = _524 * (-0.13750354945659637451171875f);
  float _528 = exp2(_525);
  float _529 = exp2(_526);
  float _530 = exp2(_527);
  float _531 = _517 - 1.0f;
  float _532 = -_528;
  float _533 = mad(_532, _531, _517);
  float _534 = -_531;
  float _535 = mad(_534, _529, _517);
  float _536 = -_531;
  float _537 = mad(_536, _530, _517);
  float _538 = _519 ? _533 : 1.0f;
  float _539 = _520 ? _535 : 1.0f;
  float _540 = _521 ? _537 : 1.0f;
  float _541 = _510 / _538;
  float _542 = _511 / _539;
  float _543 = _512 / _540;

  float3 _562;
  // Filmic curve
  if (RENODX_TONE_MAP_TYPE) {
    // float3 x = r1.rgb;
    // float A = 30.9882221;
    // float B = 1.19912136;
    // float C = 32.667881;
    // float D = 9.87056255;
    // float E = 8.97784805;
    // float3 W = r2.xzw;

    // r1.rgb = (x * (A * x + B)) / (x * (C * x + D) + E);

    // r1.rgb *= W;

    float3 x = float3(_541, _542, _543);
    renodx::color::grade::Config cg_config =
        renodx::color::grade::config::Create();
    cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
    cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
    cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
    cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
    cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
    cg_config.saturation = RENODX_TONE_MAP_SATURATION;
    cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
    cg_config.hue_correction_strength = RENODX_TONE_MAP_HUE_CORRECTION;
    float untonemapped_lum = renodx::color::y::from::AP1(x);
    cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

    x = ApplyExposureContrastFlareHighlightsShadowsByLuminance(
        x, renodx::color::y::from::AP1(untonemapped_lum), cg_config);

    float A = 30.9882221;
    float B = 1.19912136;
    float C = 32.667881;
    float D = 9.87056255;
    float E = 8.97784805;
    float3 W = float3(_538, _539, _540);

    float3 base = ApplyNiohCurve(x, A, B, C, D, E);
    float3 extended = ApplyNiohExtended(x, base, A, B, C, D, E);
    extended = renodx::color::ap1::from::BT709(
        ApplySaturationBlowoutHueCorrectionHighlightSaturation(
            renodx::color::bt709::from::AP1(extended), untonemapped_lum,
            cg_config));

    _562 = extended * W;

  } else {
    float _544 = mad(_541, 30.9882221221923828125f, 1.19912135601043701171875f);
    float _545 = mad(_542, 30.9882221221923828125f, 1.19912135601043701171875f);
    float _546 = mad(_543, 30.9882221221923828125f, 1.19912135601043701171875f);
    float _547 = _541 * _544;
    float _548 = _545 * _542;
    float _549 = _546 * _543;
    float _550 = mad(_541, 32.667881011962890625f, 9.87056255340576171875f);
    float _551 = mad(_542, 32.667881011962890625f, 9.87056255340576171875f);
    float _552 = mad(_543, 32.667881011962890625f, 9.87056255340576171875f);
    float _553 = mad(_541, _550, 8.977848052978515625f);
    float _554 = mad(_551, _542, 8.977848052978515625f);
    float _555 = mad(_552, _543, 8.977848052978515625f);
    float _556 = _547 / _553;
    float _557 = _548 / _554;
    float _558 = _549 / _555;
    float _559 = _556 * _538;
    float _560 = _557 * _539;
    float _561 = _558 * _540;
    _562 = float3(_559, _560, _561);
  }
  float _563 =
      dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f,
                     0.1561876833438873291015625f),
              _562);
  float _564 =
      dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f,
                     0.053689517080783843994140625f),
              _562);
  float _565 = dp3_f32(float3(-0.0055746496655046939849853515625f,
                              0.0040607335977256298065185546875f,
                              1.01033914089202880859375f),
                       _562);
  float _566 = _563 + _564;
  float _567 = _565 + _566;
  float _568 = max(_567, 1.0000000133514319600180897396058e-10f);
  float _569 = max(_564, 0.0f);
  float _570 = _563 / _568;
  float _571 = _564 / _568;
  float _572 = log2(_569);
  float _573 = _572 * 0.981100022792816162109375f;
  float _574 = exp2(_573);
  float _575 = max(_571, 1.0000000133514319600180897396058e-10f);
  float _576 = _574 / _575;
  float _577 = _570 * _576;
  float _578 = 1.0f - _570;
  float _579 = _578 - _571;
  float _580 = _576 * _579;
  float3 _581 = float3(_577, _574, _580);
  float _582 =
      dp3_f32(float3(1.6410233974456787109375f, -0.324803292751312255859375f,
                     -0.23642469942569732666015625f),
              _581);
  float _583 =
      dp3_f32(float3(-0.663662850856781005859375f, 1.6153316497802734375f,
                     0.016756348311901092529296875f),
              _581);
  float _584 = dp3_f32(float3(0.01172189414501190185546875f,
                              -0.008284442126750946044921875f,
                              0.98839485645294189453125f),
                       _581);
  float3 _585 = float3(_582, _583, _584);
  float _586 = dp3_f32(_585, float3(0.2722289860248565673828125f,
                                    0.674081981182098388671875f,
                                    0.0536894984543323516845703125f));
  float _587 = _582 - _586;
  float _588 = _583 - _586;
  float _589 = _584 - _586;
  float _590 = mad(_587, 0.930000007152557373046875f, _586);
  float _591 = mad(_588, 0.930000007152557373046875f, _586);
  float _592 = mad(_589, 0.930000007152557373046875f, _586);
  float3 _593 = float3(_590, _591, _592);
  float _594 =
      dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f,
                     0.1561876833438873291015625f),
              _593);
  float _595 =
      dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f,
                     0.053689517080783843994140625f),
              _593);
  float _596 = dp3_f32(float3(-0.0055746496655046939849853515625f,
                              0.0040607335977256298065185546875f,
                              1.01033914089202880859375f),
                       _593);
  float3 _597 = float3(_594, _595, _596);
  float _598 = dp3_f32(float3(0.98823249340057373046875f,
                              -0.007885635830461978912353515625f,
                              0.01675787009298801422119140625f),
                       _597);
  float _599 = dp3_f32(float3(-0.0056932144798338413238525390625f,
                              0.9986922740936279296875f,
                              0.0066724647767841815948486328125f),
                       _597);
  float _600 = dp3_f32(float3(0.0003529542009346187114715576171875f,
                              0.0011229668743908405303955078125f,
                              1.0780842304229736328125f),
                       _597);
  int _603 = cvt_f32_i32(cb4_m1.y);
  uint _604 = uint(_603);
  float _622;
  float _623;
  float _624;
  switch (_604) {
    case 0u: {
      float3 _610 = float3(_598, _599, _600);
      float _611 =
          dp3_f32(float3(3.2409698963165283203125f, -1.53738319873809814453125f,
                         -0.4986107647418975830078125f),
                  _610);
      float _612 =
          dp3_f32(float3(-0.96924364566802978515625f, 1.875967502593994140625f,
                         0.0415550582110881805419921875f),
                  _610);
      float _613 =
          dp3_f32(float3(0.055630080401897430419921875f,
                         -0.2039769589900970458984375f, 1.05697154998779296875f),
                  _610);
      _622 = _613;
      _623 = _612;
      _624 = _611;
      break;
    }
    case 1u: {
      float3 _614 = float3(_598, _599, _600);
      float _615 =
          dp3_f32(float3(1.7166512012481689453125f, -0.3556707799434661865234375f,
                         -0.253366291522979736328125f),
                  _614);
      float _616 =
          dp3_f32(float3(-0.666684329509735107421875f, 1.61648118495941162109375f,
                         0.0157685466110706329345703125f),
                  _614);
      float _617 = dp3_f32(float3(0.0176398567855358123779296875f,
                                  -0.0427706129848957061767578125f,
                                  0.9421031475067138671875f),
                           _614);
      _622 = _617;
      _623 = _616;
      _624 = _615;
      break;
    }
    case 2u: {
      float3 _618 = float3(_598, _599, _600);
      float _619 =
          dp3_f32(float3(2.4214050769805908203125f, -0.8729364871978759765625f,
                         -0.3934614658355712890625f),
                  _618);
      float _620 =
          dp3_f32(float3(-0.83118975162506103515625f, 1.76404297351837158203125f,
                         0.023842893540859222412109375f),
                  _618);
      float _621 = dp3_f32(float3(0.03059644438326358795166015625f,
                                  -0.162594377994537353515625f,
                                  1.04082071781158447265625f),
                           _618);
      _622 = _621;
      _623 = _620;
      _624 = _619;
      break;
    }
    default: {
      _622 = _592;
      _623 = _591;
      _624 = _590;
      break;
    }
  }
  float _625 = _518 * _624;
  float _626 = _518 * _623;
  float _627 = _518 * _622;
  float4 _629 = float4(_625, _626, _627, _625);
  return _629;
}

void comp_main() {
  uint3 _232 = uint3(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y,
                     gl_GlobalInvocationID.z);
  float4 _233 = t0.Load(int4(_232, 0u));
  float _234 = _233.x;
  switch (uint(cvt_f32_i32(cb4_m1.x))) {
    case 0u: {
      float3 _250 = float3(_234, _233.yz);
      float _251 =
          dp3_f32(float3(1.70507967472076416015625f, -0.624233424663543701171875f,
                         -0.080846212804317474365234375f),
                  _250);
      u0[_232] = float4(_251,
                        dp3_f32(float3(-0.12970052659511566162109375f,
                                       1.1384685039520263671875f,
                                       -0.00876801647245883941650390625f),
                                _250),
                        dp3_f32(float3(-0.02416686527431011199951171875f,
                                       -0.124614916741847991943359375f,
                                       1.14878177642822265625f),
                                _250),
                        _251);
      break;
    }
    case 1u: {
      float3 _256 = float3(_234, _233.yz);
      float _257 =
          dp3_f32(float3(1.70507967472076416015625f, -0.624233424663543701171875f,
                         -0.080846212804317474365234375f),
                  _256);
      float _258 = dp3_f32(float3(-0.12970052659511566162109375f,
                                  1.1384685039520263671875f,
                                  -0.00876801647245883941650390625f),
                           _256);
      float _259 = dp3_f32(float3(-0.02416686527431011199951171875f,
                                  -0.124614916741847991943359375f,
                                  1.14878177642822265625f),
                           _256);
      float _265 = cb4_m0.x / cb4_m0.y;
      float _266 = cb4_m0.y / cb4_m0.x;
      float _279 = _265 - 1.0f;
      float _286 =
          (_257 > 0.5f)
              ? mad(-exp2((_257 - 0.5f) * (-0.13750354945659637451171875f)), _279,
                    _265)
              : 1.0f;
      float _287 =
          (_258 > 0.5f)
              ? mad(-exp2((_258 - 0.5f) * (-0.13750354945659637451171875f)), _279,
                    _265)
              : 1.0f;
      float _288 =
          (_259 > 0.5f)
              ? mad(-exp2((_259 - 0.5f) * (-0.13750354945659637451171875f)), _279,
                    _265)
              : 1.0f;
      float _301 = cb4_m3.x * cb4_m2.w;
      float _302 = cb4_m3.y * cb4_m2.w;
      float _307 = cb4_m2.z * cb4_m2.y;
      float _324 = cb4_m3.x / cb4_m3.y;
      float _326 =
          1.0f / (((_301 + ((_307 + (cb4_m4.x * cb4_m2.x)) * cb4_m4.x)) / ((mad(cb4_m4.x, cb4_m2.x, cb4_m2.y) * cb4_m4.x) + _302)) - _324);
      float _327 = max(_257 / _286, 0.0f) * _326;
      float _328 = _326 * max(_258 / _287, 0.0f);
      float _329 = _326 * max(_259 / _288, 0.0f);
      float _359 = _326 / cb4_m4.y;
      float _366 = (_286 * ((((_301 + (_327 * (_307 + (_327 * cb4_m2.x)))) / ((_327 * mad(_327, cb4_m2.x, cb4_m2.y)) + _302)) - _324) * _359)) * _266;
      u0[_232] = float4(
          _366,
          _266 * (_287 * (_359 * (((_301 + ((_307 + (_328 * cb4_m2.x)) * _328)) / ((mad(_328, cb4_m2.x, cb4_m2.y) * _328) + _302)) - _324))),
          _266 * (_288 * (_359 * (((_301 + ((_307 + (_329 * cb4_m2.x)) * _329)) / ((mad(_329, cb4_m2.x, cb4_m2.y) * _329) + _302)) - _324))),
          _366);
      break;
    }
    case 2u: {
      u0[_232] = vanillaTonemapper(float3(_234, _233.yz));
      break;
    }
    case 4u: {
      u0[_232] = vanillaTonemapper(float3(_234, _233.yz));
      break;
    }
    case 3u: {
      float3 _630 = float3(_234, _233.yz);
      float _631 =
          dp3_f32(float3(1.70507967472076416015625f, -0.624233424663543701171875f,
                         -0.080846212804317474365234375f),
                  _630);
      float _632 = dp3_f32(float3(-0.12970052659511566162109375f,
                                  1.1384685039520263671875f,
                                  -0.00876801647245883941650390625f),
                           _630);
      float _633 = dp3_f32(float3(-0.02416686527431011199951171875f,
                                  -0.124614916741847991943359375f,
                                  1.14878177642822265625f),
                           _630);
      float _638 = cb4_m0.x / cb4_m0.y;
      float _639 = cb4_m0.y / cb4_m0.x;
      float _652 = _638 - 1.0f;
      float _659 =
          (_631 > 0.5f)
              ? mad(-exp2((_631 - 0.5f) * (-0.13750354945659637451171875f)), _652,
                    _638)
              : 1.0f;
      float _660 =
          (_632 > 0.5f)
              ? mad(-exp2((_632 - 0.5f) * (-0.13750354945659637451171875f)), _652,
                    _638)
              : 1.0f;
      float _661 =
          (_633 > 0.5f)
              ? mad(-exp2((_633 - 0.5f) * (-0.13750354945659637451171875f)), _652,
                    _638)
              : 1.0f;
      float _673 = 1.0f / ((mad(mad(cb4_m4.x, 0.1500000059604644775390625f, 0.0500000007450580596923828125f), cb4_m4.x, 0.0040000001899898052215576171875f) / mad(mad(cb4_m4.x, 0.1500000059604644775390625f, 0.5f), cb4_m4.x, 0.060000002384185791015625f)) - 0.066666662693023681640625f);
      float _674 = max(_631 / _659, 0.0f);
      float _675 = max(_632 / _660, 0.0f);
      float _676 = max(_633 / _661, 0.0f);
      float _701 =
          _639 * ((_673 * ((mad(_674, mad(_674, 0.1500000059604644775390625f, 0.0500000007450580596923828125f), 0.0040000001899898052215576171875f) / mad(_674, mad(_674, 0.1500000059604644775390625f, 0.5f), 0.060000002384185791015625f)) - 0.066666662693023681640625f)) * _659);
      u0[_232] =
          float4(_701,
                 ((((mad(mad(_675, 0.1500000059604644775390625f,
                             0.0500000007450580596923828125f),
                         _675, 0.0040000001899898052215576171875f)
                     / mad(mad(_675, 0.1500000059604644775390625f, 0.5f), _675,
                           0.060000002384185791015625f))
                    - 0.066666662693023681640625f)
                   * _673)
                  * _660)
                     * _639,
                 (_661 * (((mad(mad(_676, 0.1500000059604644775390625f, 0.0500000007450580596923828125f), _676, 0.0040000001899898052215576171875f) / mad(mad(_676, 0.1500000059604644775390625f, 0.5f), _676, 0.060000002384185791015625f)) - 0.066666662693023681640625f) * _673)) * _639,
                 _701);
      break;
    }
    default: {
      u0[_232] = float4(_234, _233.yz, _234);
      break;
    }
  }
}

[numthreads(4, 4, 4)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}

// ---- Created with 3Dmigoto v1.4.1 on Fri Jan 30 01:59:38 2026

// cbuffer cbHdrLut : register(b4) {
//   float4 g_vHdrLutInfo : packoffset(c0);
//   float4 g_vNeutralTonemapperParams0 : packoffset(c1);
//   float4 g_vNeutralTonemapperParams1 : packoffset(c2);
// }

// Texture3D<float3> g_tInputMap : register(t0);
// RWTexture3D<float3> g_uRwOutputLut : register(u0);

// // 3Dmigoto declarations
// #define cmp -

// [numthreads(4, 4, 4)]
// void main(uint3 vThreadID: SV_DispatchThreadID) {
//   float4 r0, r1, r2, r3, r4, r5, r6;
//   uint4 bitmask, uiDest;
//   float4 fDest;

//   r0.xyz = vThreadID.xyz;
//   r0.w = 0;
//   r0.xyz = g_tInputMap.Load(r0.xyzw).xyz;
//   r0.w = (int)g_vHdrLutInfo.z;
//   switch (r0.w) {
//     case 0:
//       r1.x = dot(float3(1.70507967, -0.624233425, -0.0808462128), r0.xyz);
//       r1.y = dot(float3(-0.129700527, 1.1384685, -0.00876801647), r0.xyz);
//       r1.z = dot(float3(-0.0241668653, -0.124614917, 1.14878178), r0.xyz);
//       g_uRwOutputLut[vThreadID.xyz] = r1.xyz;
//       break;
//     case 1:
//       r1.x = dot(float3(1.70507967, -0.624233425, -0.0808462128), r0.xyz);
//       r1.y = dot(float3(-0.129700527, 1.1384685, -0.00876801647), r0.xyz);
//       r1.z = dot(float3(-0.0241668653, -0.124614917, 1.14878178), r0.xyz);
//       r2.xy = g_vHdrLutInfo.xy / g_vHdrLutInfo.yx;
//       r3.xyzw = cmp(float4(0.5, 0.5, 0.5, 0.5) < r1.xyzx);
//       r4.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r1.xyzx;
//       r4.xyzw = float4(-0.137503549, -0.137503549, -0.137503549, -0.137503549) * r4.xyzw;
//       r4.xyzw = exp2(r4.xyzw);
//       r0.w = -1 + r2.x;
//       r4.xyzw = -r4.xyzw * r0.wwww + r2.xxxx;
//       r3.xyzw = r3.xyzw ? r4.xyzw : float4(1, 1, 1, 1);
//       r1.xyzw = r1.xyzx / r3.wyzw;
//       r1.xyzw = max(float4(0, 0, 0, 0), r1.xyzw);
//       r2.xz = g_vNeutralTonemapperParams1.xy * g_vNeutralTonemapperParams0.ww;
//       r0.w = g_vNeutralTonemapperParams0.z * g_vNeutralTonemapperParams0.y;
//       r2.w = g_vNeutralTonemapperParams0.x * g_vNeutralTonemapperParams1.z + r0.w;
//       r2.w = g_vNeutralTonemapperParams1.z * r2.w + r2.x;
//       r4.x = g_vNeutralTonemapperParams0.x * g_vNeutralTonemapperParams1.z + g_vNeutralTonemapperParams0.y;
//       r4.x = g_vNeutralTonemapperParams1.z * r4.x + r2.z;
//       r2.w = r2.w / r4.x;
//       r4.x = g_vNeutralTonemapperParams1.x / g_vNeutralTonemapperParams1.y;
//       r2.w = -r4.x + r2.w;
//       r2.w = 1 / r2.w;
//       r1.xyzw = r2.wwww * r1.xyzw;
//       r5.xyzw = g_vNeutralTonemapperParams0.xxxx * r1.wyzw + r0.wwww;
//       r5.xyzw = r1.wyzw * r5.xyzw + r2.xxxx;
//       r6.xyzw = g_vNeutralTonemapperParams0.xxxx * r1.wyzw + g_vNeutralTonemapperParams0.yyyy;
//       r1.xyzw = r1.xyzw * r6.xyzw + r2.zzzz;
//       r1.xyzw = r5.xyzw / r1.xyzw;
//       r1.xyzw = r1.xyzw + -r4.xxxx;
//       r0.w = r2.w / g_vNeutralTonemapperParams1.w;
//       r1.xyzw = r1.xyzw * r0.wwww;
//       r1.xyzw = r1.xyzw * r3.xyzw;
//       r1.xyzw = r1.xyzw * r2.yyyy;
//       g_uRwOutputLut[vThreadID.xyz] = r1.xyz;
//       break;
//     case 2:
//     case 4:  // Here
//       // RGB -> luma-like channels
//       r1.y = dot(float3(0.695452213, 0.140678704, 0.163869068), r0.xyz);
//       r2.y = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r0.xyz);
//       r3.y = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r0.xyz);
//       // Hue selection based on channel ordering
//       r0.w = cmp(r1.y < r2.y);
//       if (r0.w != 0) {
//         r0.w = cmp(r2.y < r3.y);
//         r3.z = r3.y + -r1.y;
//         r1.w = cmp(0 < r3.z);
//         r2.w = -r2.y + r1.y;
//         r2.w = 60 * r2.w;
//         r2.w = r2.w / r3.z;
//         r2.w = 240 + r2.w;
//         r3.x = r1.w ? r2.w : 0;
//         r1.w = cmp(r1.y < r3.y);
//         r4.z = r2.y + -r1.y;
//         r2.w = cmp(0 < r4.z);
//         r4.y = 60 * r3.z;
//         r4.w = r4.y / r4.z;
//         r4.w = 120 + r4.w;
//         r4.x = r2.w ? r4.w : 0;
//         r5.z = -r3.y + r2.y;
//         r2.w = cmp(0 < r5.z);
//         r4.y = r4.y / r5.z;
//         r4.y = 120 + r4.y;
//         r5.x = r2.w ? r4.y : 0;
//         r2.xz = r1.ww ? r4.xz : r5.xz;
//         r2.xzw = r0.www ? r3.yzx : r2.yzx;
//       } else {
//         r0.w = cmp(r1.y < r3.y);
//         r3.z = r3.y + -r2.y;
//         r1.w = cmp(0 < r3.z);
//         r4.z = -r2.y + r1.y;
//         r4.y = 60 * r4.z;
//         r4.y = r4.y / r3.z;
//         r4.y = 240 + r4.y;
//         r3.x = r1.w ? r4.y : 0;
//         r1.w = cmp(r2.y < r3.y);
//         r4.y = cmp(0 < r4.z);
//         r4.w = -r3.y + r2.y;
//         r4.w = 60 * r4.w;
//         r5.x = r4.w / r4.z;
//         r4.x = r4.y ? r5.x : 0;
//         r5.z = -r3.y + r1.y;
//         r4.y = cmp(0 < r5.z);
//         r4.w = r4.w / r5.z;
//         r5.x = r4.y ? r4.w : 0;
//         r1.xz = r1.ww ? r4.xz : r5.xz;
//         r2.xzw = r0.www ? r3.yzx : r1.yzx;
//       }
//       // Hue wrap and normalize
//       r0.w = cmp(r2.w < 0);
//       r1.x = cmp(360 < r2.w);
//       r1.zw = float2(360, -360) + r2.ww;
//       r1.x = r1.x ? r1.w : r2.w;
//       r0.w = r0.w ? r1.z : r1.x;
//       // Chroma ratio and magnitude
//       r1.x = cmp(r2.x == 0.000000);
//       r1.z = r2.z / r2.x;
//       r1.x = r1.x ? 0 : r1.z;
//       r1.z = r3.y + -r2.y;
//       r1.w = r2.y + -r1.y;
//       r1.w = r2.y * r1.w;
//       r1.z = r3.y * r1.z + r1.w;
//       r1.w = -r3.y + r1.y;
//       r1.z = r1.y * r1.w + r1.z;
//       r1.z = sqrt(r1.z);
//       r1.w = r2.y + r1.y;
//       r1.w = r1.w + r3.y;
//       r1.z = r1.w + r1.z;
//       // Nonlinear hue/sat shaping
//       r1.z = 1.75 + r1.z;
//       r1.w = 0.333333343 * r1.z;
//       r2.x = -0.400000006 + r1.x;
//       r2.z = 2.5 * r2.x;
//       r2.z = 1 + -abs(r2.z);
//       r2.z = max(0, r2.z);
//       r2.x = cmp(r2.x >= 0);
//       r2.x = r2.x ? 1 : -1;
//       r2.z = -r2.z * r2.z + 1;
//       r2.x = r2.x * r2.z + 1;
//       r2.z = 0.0250000004 * r2.x;
//       r2.w = cmp(0.159999996 >= r1.z);
//       r2.x = r2.x * 0.0250000004 + 1;
//       r1.z = cmp(r1.z >= 0.479999989);
//       r1.w = 0.0799999982 / r1.w;
//       r1.w = -0.5 + r1.w;
//       r1.w = r2.z * r1.w + 1;
//       r1.z = r1.z ? 1 : r1.w;
//       r1.z = r2.w ? r2.x : r1.z;
//       // Apply shaped saturation to channels
//       r3.z = r1.y;
//       r3.w = r2.y;
//       r2.yzw = r3.zwy * r1.zzz;
//       // Hue wrap for trig-like curve
//       r1.y = 1 * r0.w;
//       r1.w = cmp(r0.w < -180);
//       r3.x = cmp(180 < r0.w);
//       r3.yw = r0.ww * float2(1, 1) + float2(360, -360);
//       r0.w = r3.x ? r3.w : r1.y;
//       r0.w = r1.w ? r3.y : r0.w;
//       // Hue curve shaping
//       r0.w = 2.43902445 * r0.w;
//       r0.w = 1 + -abs(r0.w);
//       r0.w = max(0, r0.w);
//       r1.y = r0.w * -2 + 3;
//       r0.w = r0.w * r0.w;
//       r0.w = r1.y * r0.w;
//       r0.w = r0.w * r0.w;
//       r0.w = r0.w * r1.x;
//       // Recombine shaped hue with base
//       r1.x = -r3.z * r1.z + 0.0299999993;
//       r0.w = r1.x * r0.w;
//       r2.x = r0.w * 0.180000007 + r2.y;
//       // AP0 -> AP1
//       r1.xyz = max(float3(0, 0, 0), r2.xzw);
//       r1.xyz = min(float3(65504, 65504, 65504), r1.xyz);
//       r2.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r1.xyz);
//       r2.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r1.xyz);
//       r2.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r1.xyz);
//       r1.xyz = max(float3(0, 0, 0), r2.xyz);
//       r1.xyz = min(float3(65504, 65504, 65504), r1.xyz);
//       // Luma-preserving desat
//       r0.w = dot(r1.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
//       r1.xyz = r1.xyz + -r0.www;
//       r1.xyz = r1.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
//       // END RRT

//       // Toe/shoulder gate
//       r2.xy = g_vHdrLutInfo.xy / g_vHdrLutInfo.yx;
//       r3.xyz = cmp(float3(0.5, 0.5, 0.5) < r1.xyz);
//       r4.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
//       r4.xyz = float3(-0.137503549, -0.137503549, -0.137503549) * r4.xyz;
//       r4.xyz = exp2(r4.xyz);
//       r0.w = -1 + r2.x;
//       r2.xzw = -r4.xyz * r0.www + r2.xxx;
//       r2.xzw = r3.xyz ? r2.xzw : float3(1, 1, 1);
//       r1.xyz = r1.xyz / r2.xzw;
//       // Filmic curve
//       if (RENODX_TONE_MAP_TYPE) {
//         // float3 x = r1.rgb;
//         // float A = 30.9882221;
//         // float B = 1.19912136;
//         // float C = 32.667881;
//         // float D = 9.87056255;
//         // float E = 8.97784805;
//         // float3 W = r2.xzw;

//         // r1.rgb = (x * (A * x + B)) / (x * (C * x + D) + E);

//         // r1.rgb *= W;

//         float3 x = r1.rgb;
//         renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
//         cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
//         cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
//         cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
//         cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
//         cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
//         cg_config.saturation = RENODX_TONE_MAP_SATURATION;
//         cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
//         cg_config.hue_correction_strength = RENODX_TONE_MAP_HUE_CORRECTION;
//         float untonemapped_lum = renodx::color::y::from::AP1(x);
//         cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

//         x = ApplyExposureContrastFlareHighlightsShadowsByLuminance(x, renodx::color::y::from::AP1(untonemapped_lum), cg_config);

//         float A = 30.9882221;
//         float B = 1.19912136;
//         float C = 32.667881;
//         float D = 9.87056255;
//         float E = 8.97784805;
//         float3 W = r2.xzw;

//         float3 base = ApplyNiohCurve(x, A, B, C, D, E);
//         float3 extended = ApplyNiohExtended(x, base, A, B, C, D, E);
//         extended = renodx::color::ap1::from::BT709(ApplySaturationBlowoutHueCorrectionHighlightSaturation(renodx::color::bt709::from::AP1(extended), untonemapped_lum, cg_config));

//         r1.rgb = extended * W;

//       } else {
//         r3.xyz = r1.xyz * float3(30.9882221, 30.9882221, 30.9882221) + float3(1.19912136, 1.19912136, 1.19912136);
//         r3.xyz = r3.xyz * r1.xyz;
//         r4.xyz = r1.xyz * float3(32.667881, 32.667881, 32.667881) + float3(9.87056255, 9.87056255, 9.87056255);
//         r1.xyz = r1.xyz * r4.xyz + float3(8.97784805, 8.97784805, 8.97784805);
//         r1.xyz = r3.xyz / r1.xyz;
//         r1.xyz = r1.xyz * r2.xzw;
//       }
//       // AP1 -> XYZ
//       r0.w = dot(float3(0.662454188, 0.134004205, 0.156187683), r1.xyz);
//       r1.w = dot(float3(0.272228718, 0.674081743, 0.0536895171), r1.xyz);
//       r1.x = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r1.xyz);
//       r1.y = r1.w + r0.w;
//       r1.x = r1.y + r1.x;
//       r1.xy = max(float2(1.00000001e-10, 0), r1.xw);
//       r0.w = r0.w / r1.x;
//       r1.x = r1.w / r1.x;
//       r1.y = log2(r1.y);
//       r1.y = 0.981100023 * r1.y;
//       r3.y = exp2(r1.y);
//       r1.y = max(1.00000001e-10, r1.x);
//       r1.y = r3.y / r1.y;
//       r3.x = r1.y * r0.w;
//       r0.w = 1 + -r0.w;
//       r0.w = r0.w + -r1.x;
//       r3.z = r0.w * r1.y;
//       // XYZ -> AP1
//       r1.x = dot(float3(1.6410234, -0.324803293, -0.236424699), r3.xyz);
//       r1.y = dot(float3(-0.663662851, 1.61533165, 0.0167563483), r3.xyz);
//       r1.z = dot(float3(0.0117218941, -0.00828444213, 0.988394856), r3.xyz);
//       // Luma-preserving desat
//       r0.w = dot(r1.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
//       r1.xyz = r1.xyz + -r0.www;
//       r1.xyz = r1.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r0.www;
//       // AP1 -> XYZ
//       r3.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r1.xyz);
//       r3.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r1.xyz);
//       r3.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r1.xyz);
//       // XYZ-like -> output primaries
//       r4.x = dot(float3(0.988232493, -0.00788563583, 0.0167578701), r3.xyz);
//       r4.y = dot(float3(-0.00569321448, 0.998692274, 0.00667246478), r3.xyz);
//       r4.z = dot(float3(0.000352954201, 0.00112296687, 1.07808423), r3.xyz);
//       r0.w = (int)g_vHdrLutInfo.w;
//       switch (r0.w) {
//         case 0:  // Here
//           // Output matrix 0
//           r1.x = dot(float3(3.2409699, -1.5373832, -0.498610765), r4.xyz);
//           r1.y = dot(float3(-0.969243646, 1.8759675, 0.0415550582), r4.xyz);
//           r1.z = dot(float3(0.0556300804, -0.203976959, 1.05697155), r4.xyz);
//           break;
//         case 1:
//           // Output matrix 1
//           r1.x = dot(float3(1.7166512, -0.35567078, -0.253366292), r4.xyz);
//           r1.y = dot(float3(-0.66668433, 1.61648118, 0.0157685466), r4.xyz);
//           r1.z = dot(float3(0.0176398568, -0.042770613, 0.942103148), r4.xyz);
//           break;
//         case 2:
//           // Output matrix 2
//           r1.x = dot(float3(2.42140508, -0.872936487, -0.393461466), r4.xyz);
//           r1.y = dot(float3(-0.831189752, 1.76404297, 0.0238428935), r4.xyz);
//           r1.z = dot(float3(0.0305964444, -0.162594378, 1.04082072), r4.xyz);
//           break;
//         default:
//           break;
//       }
//       // Scale by LUT range
//       r1.xyzw = r1.xyzx;
//       r1.xyzw = r1.xyzw * r2.yyyy;

//       g_uRwOutputLut[vThreadID.xyz] = r1.xyz;
//       break;
//     case 3:
//       r1.x = dot(float3(1.70507967, -0.624233425, -0.0808462128), r0.xyz);
//       r1.y = dot(float3(-0.129700527, 1.1384685, -0.00876801647), r0.xyz);
//       r1.z = dot(float3(-0.0241668653, -0.124614917, 1.14878178), r0.xyz);
//       r2.xy = g_vHdrLutInfo.xy / g_vHdrLutInfo.yx;
//       r3.xyzw = cmp(float4(0.5, 0.5, 0.5, 0.5) < r1.xyzx);
//       r4.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r1.xyzx;
//       r4.xyzw = float4(-0.137503549, -0.137503549, -0.137503549, -0.137503549) * r4.xyzw;
//       r4.xyzw = exp2(r4.xyzw);
//       r0.w = -1 + r2.x;
//       r4.xyzw = -r4.xyzw * r0.wwww + r2.xxxx;
//       r3.xyzw = r3.xyzw ? r4.xyzw : float4(1, 1, 1, 1);
//       r1.xyzw = r1.xyzx / r3.wyzw;
//       r2.xz = g_vNeutralTonemapperParams1.zz * float2(0.150000006, 0.150000006) + float2(0.0500000007, 0.5);
//       r2.xz = g_vNeutralTonemapperParams1.zz * r2.xz + float2(0.00400000019, 0.0600000024);
//       r0.w = r2.x / r2.z;
//       r0.w = -0.0666666627 + r0.w;
//       r0.w = 1 / r0.w;
//       r1.xyzw = max(float4(0, 0, 0, 0), r1.xyzw);
//       r4.xyzw = r1.wyzw * float4(0.150000006, 0.150000006, 0.150000006, 0.150000006) + float4(0.0500000007, 0.0500000007, 0.0500000007, 0.0500000007);
//       r4.xyzw = r1.wyzw * r4.xyzw + float4(0.00400000019, 0.00400000019, 0.00400000019, 0.00400000019);
//       r5.xyzw = r1.wyzw * float4(0.150000006, 0.150000006, 0.150000006, 0.150000006) + float4(0.5, 0.5, 0.5, 0.5);
//       r1.xyzw = r1.xyzw * r5.xyzw + float4(0.0600000024, 0.0600000024, 0.0600000024, 0.0600000024);
//       r1.xyzw = r4.xyzw / r1.xyzw;
//       r1.xyzw = float4(-0.0666666627, -0.0666666627, -0.0666666627, -0.0666666627) + r1.xyzw;
//       r1.xyzw = r1.xyzw * r0.wwww;
//       r1.xyzw = r1.xyzw * r3.xyzw;
//       r1.xyzw = r1.xyzw * r2.yyyy;
//       g_uRwOutputLut[vThreadID.xyz] = r1.xyz;
//       break;
//     default:
//       g_uRwOutputLut[vThreadID.xyz] = r0.xyz;
//       break;
//   }
//   return;
// }
