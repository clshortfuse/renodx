#ifndef SRC_MHWILDS_COMMON_HLSL_
#define SRC_MHWILDS_COMMON_HLSL_

#include "./include/CBuffers.hlsl"
#include "./include/Registers.hlsl"
#include "./shared.h"

float3 VanillaLutTransform(float3 color) {
  float _38;
  float _52;
  float _66;
  float _242;
  float _250;
  float _295;
  float _300;
  float _407;
  float _436;
  float _463;
  float _635;
  float _636;
  float _637;
  float _638;
  float _639;

  color = mul(renodx::color::BT709_TO_AP1_MAT, color);
  // AP1_2_AP0
  float _387 = mad(color.z, 0.1638689935207367f, (mad(color.y, 0.1406790018081665f, (color.x * 0.6954519748687744f))));
  float _390 = mad(color.z, 0.0955343022942543f, (mad(color.y, 0.8596709966659546f, (color.x * 0.04479460045695305f))));
  float _393 = mad(color.z, 1.0015000104904175f, (mad(color.y, 0.004025210160762072f, (color.x * -0.00552588002756238f))));

  float _394 = abs(_387);
  if (((_394 > 6.103515625e-05f))) {
    float _397 = min(_394, 65504.0f);
    float _399 = floor((log2(_397)));
    float _400 = exp2(_399);
    _407 = (dot(float3(_399, ((_397 - _400) / _400), 15.0f), float3(1024.0f, 1024.0f, 1024.0f)));
  } else {
    _407 = (_394 * 16777216.0f);
  }
  float _410 = _407 + ((((bool)((_387 > 0.0f))) ? 0.0f : 32768.0f));
  float _412 = floor((_410 * 0.00024420025874860585f));

  // Do stuff on Y
  float _423 = abs(_390);
  if (((_423 > 6.103515625e-05f))) {
    float _426 = min(_423, 65504.0f);
    float _428 = floor((log2(_426)));
    float _429 = exp2(_428);
    _436 = (dot(float3(_428, ((_426 - _429) / _429), 15.0f), float3(1024.0f, 1024.0f, 1024.0f)));
  } else {
    _436 = (_423 * 16777216.0f);
  }
  float _439 = _436 + ((((bool)((_390 > 0.0f))) ? 0.0f : 32768.0f));
  float _441 = floor((_439 * 0.00024420025874860585f));

  // Do stuff on Z
  float _450 = abs(_393);
  if (((_450 > 6.103515625e-05f))) {
    float _453 = min(_450, 65504.0f);
    float _455 = floor((log2(_453)));
    float _456 = exp2(_455);
    _463 = (dot(float3(_455, ((_453 - _456) / _456), 15.0f), float3(1024.0f, 1024.0f, 1024.0f)));
  } else {
    _463 = (_450 * 16777216.0f);
  }
  float _466 = _463 + ((((bool)((_393 > 0.0f))) ? 0.0f : 32768.0f));
  float _468 = floor((_466 * 0.00024420025874860585f));

  // Finally lut stuff
  // Reminder XYZ is now float3(_412, _441, _468) in AP0 linear space I believe
  // Lut width is 64
  float _477 = (((float4)(OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_410 + 0.5f) - (_412 * 4095.0f)) * 0.000244140625f), ((_412 + 0.5f) * 0.05882352963089943f)), 0.0f))).x) * 64.0f;
  float _478 = (((float4)(OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_439 + 0.5f) - (_441 * 4095.0f)) * 0.000244140625f), ((_441 + 0.5f) * 0.05882352963089943f)), 0.0f))).x) * 64.0f;
  float _479 = (((float4)(OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_466 + 0.5f) - (_468 * 4095.0f)) * 0.000244140625f), ((_468 + 0.5f) * 0.05882352963089943f)), 0.0f))).x) * 64.0f;
  float _480 = floor(_477);
  float _481 = floor(_478);
  float _482 = floor(_479);
  float _483 = _477 - _480;
  float _484 = _478 - _481;
  float _485 = _479 - _482;

  // This 0.015384615398943424f is for LUT ssize
  float _489 = (_482 + 0.5f) * 0.015384615398943424f;
  float _490 = (_481 + 0.5f) * 0.015384615398943424f;
  float _491 = (_480 + 0.5f) * 0.015384615398943424f;
  float4 _494 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _490, _491), 0.0f);
  float _498 = _489 + 0.015384615398943424f;
  float _499 = _490 + 0.015384615398943424f;
  float _500 = _491 + 0.015384615398943424f;
  float4 _501 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _499, _500), 0.0f);

  // Reminder XYZ is now float3(_483, _484, _485) in X space
  if (!(!(_483 >= _484))) {  // g bigger than b? I don't know how LUT sampling works
    if (!(!(_484 >= _485))) {
      float4 _509 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _490, _500), 0.0f);
      float4 _513 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _499, _500), 0.0f);
      float _517 = _483 - _484;
      float _518 = _484 - _485;
      _635 = (((_513.x) * _518) + ((_509.x) * _517));
      _636 = (((_513.y) * _518) + ((_509.y) * _517));
      _637 = (((_513.z) * _518) + ((_509.z) * _517));
      _638 = _483;
      _639 = _485;
    } else {
      if (!(!(_483 >= _485))) {
        float4 _531 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _490, _500), 0.0f);
        float4 _535 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _490, _500), 0.0f);
        float _539 = _483 - _485;
        float _540 = _485 - _484;
        _635 = (((_535.x) * _540) + ((_531.x) * _539));
        _636 = (((_535.y) * _540) + ((_531.y) * _539));
        _637 = (((_535.z) * _540) + ((_531.z) * _539));
        _638 = _483;
        _639 = _484;
      } else {
        float4 _551 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _490, _491), 0.0f);
        float4 _555 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _490, _500), 0.0f);
        float _559 = _485 - _483;
        float _560 = _483 - _484;
        _635 = (((_555.x) * _560) + ((_551.x) * _559));
        _636 = (((_555.y) * _560) + ((_551.y) * _559));
        _637 = (((_555.z) * _560) + ((_551.z) * _559));
        _638 = _485;
        _639 = _484;
      }
    }
  } else {
    if (!(!(_484 <= _485))) {
      float4 _573 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _490, _491), 0.0f);
      float4 _577 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _499, _491), 0.0f);
      float _581 = _485 - _484;
      float _582 = _484 - _483;
      _635 = (((_577.x) * _582) + ((_573.x) * _581));
      _636 = (((_577.y) * _582) + ((_573.y) * _581));
      _637 = (((_577.z) * _582) + ((_573.z) * _581));
      _638 = _485;
      _639 = _483;
    } else {
      if (!(!(_483 >= _485))) {
        float4 _595 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _499, _491), 0.0f);
        float4 _599 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _499, _500), 0.0f);
        float _603 = _484 - _483;
        float _604 = _483 - _485;
        _635 = (((_599.x) * _604) + ((_595.x) * _603));
        _636 = (((_599.y) * _604) + ((_595.y) * _603));
        _637 = (((_599.z) * _604) + ((_595.z) * _603));
        _638 = _484;
        _639 = _485;
      } else {
        float4 _615 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _499, _491), 0.0f);
        float4 _619 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _499, _491), 0.0f);
        float _623 = _484 - _485;
        float _624 = _485 - _483;
        _635 = (((_619.x) * _624) + ((_615.x) * _623));
        _636 = (((_619.y) * _624) + ((_615.y) * _623));
        _637 = (((_619.z) * _624) + ((_615.z) * _623));
        _638 = _484;
        _639 = _483;
      }
    }
  }
  // I think this is lerp strength, gonna have to double check
  float _640 = 1.0f - _638;
  float3 final = float3((((_640 * (_494.x)) + _635) + (_639 * (_501.x))), (((_640 * (_494.y)) + _636) + (_639 * (_501.y))), (((_640 * (_494.z)) + _637) + (_639 * (_501.z))));
  /* final = renodx::color::pq::DecodeSafe(final.rgb, 100.f);
  final = renodx::color::bt709::from::BT2020(final.rgb); */
  return final;
}

float3 Lut1DSample(float3 color) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = BilinearClamp;
  // lut_config.size = 64u;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::LINEAR;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  lut_config.scaling = 0.f;

  color = mul(renodx::color::BT709_TO_AP0_MAT, color);
  color = renodx::lut::Sample(
      OCIO_lut1d_0,
      lut_config,
      color);
  color = renodx::color::bt709::from::AP1(color);

  return color;
}

float3 Lut3DSample(float3 color) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = TrilinearClamp;
  // lut_config.size = 64u;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::LINEAR;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  lut_config.scaling = 0.f;

  color = mul(renodx::color::BT709_TO_AP1_MAT, color);
  color = renodx::lut::Sample(
      OCIO_lut3d_1,
      lut_config,
      color);

  return color;
}

float4 LutToneMap(float3 lutInput) {
  float3 output = renodx::color::pq::DecodeSafe(lutInput, RENODX_GAME_NITS);
  output = renodx::color::correct::GammaSafe(output);
  output = VanillaLutTransform(output);  // returns PQ encoded at 100.f
  // output = renodx::color::pq::EncodeSafe(output, 100.f);
  // output = Lut3DSample(output);

  return float4(output, 1.f);
}

float4 FinalizeOutput(float3 color) {
  color = renodx::color::correct::GammaSafe(color);
  // bt709 PQ looks closer to vanilla...
  // color = renodx::color::bt2020::from::BT709(color);
  color = renodx::color::pq::EncodeSafe(color, RENODX_GAME_NITS);

  return float4(color, 1.f);
}

#endif  // SRC_MHWILDS_COMMON_HLSL_
