#include "./tonemap.hlsli"

cbuffer cb6_buf : register(b6) {
  float4 cb6_m0 : packoffset(c0);
  float4 cb6_m1 : packoffset(c1);
  float4 cb6_m2 : packoffset(c2);
  uint2 cb6_m3 : packoffset(c3);
  float2 cb6_m4 : packoffset(c3.z);
  float cb6_m5 : packoffset(c4);
  uint cb6_m6 : packoffset(c4.y);
  float2 cb6_m7 : packoffset(c4.z);
  uint4 cb6_m8 : packoffset(c5);
  float4 cb6_m9 : packoffset(c6);
  uint2 cb6_m10 : packoffset(c7);
  float2 cb6_m11 : packoffset(c7.z);
};

RWTexture3D<float4> u4 : register(u4);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

float dp3_f32(float3 a, float3 b) {
  precise float _145 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _145));
}

void comp_main() {
  bool output_hdr_enabled = cb6_m3.x != 0u;
  float exposure = cb6_m4.x;
  float peak_nits = cb6_m4.y;
  float tone_map_contrast = cb6_m0.x;
  float tone_map_toe_threshold = cb6_m0.y;
  float tone_map_mid_point = cb6_m0.z;
  float tone_map_toe_slope = cb6_m0.w;
  float tone_map_black_offset = cb6_m1.x;

  float diffuse_white_nits = (exposure / 128.f) * 203.f;
  float target_peak_ratio = peak_nits / diffuse_white_nits;
#if RENODX_GAME_GAMMA_CORRECTION
  target_peak_ratio = renodx::color::correct::GammaSafe(target_peak_ratio, true);
#endif
  float peak_value = (RENODX_TONE_MAP_TYPE != 0.f)
                         ? target_peak_ratio * 100.f
                         : peak_nits;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    exposure = 32.f;  // SDR exposure value
    tone_map_contrast = 1.00f;
    tone_map_toe_threshold = 0.00f;
    tone_map_mid_point = 0.50f;
    tone_map_toe_slope = 1.00f;
    tone_map_black_offset = 1.00f;
    if (!output_hdr_enabled) {
      peak_nits = diffuse_white_nits;
    }
  }

  float _166 = float(gl_GlobalInvocationID.x) * 0.0322580635547637939453125f;
  float _167 = float(gl_GlobalInvocationID.y) * 0.0322580635547637939453125f;
  float _168 = float(gl_GlobalInvocationID.z) * 0.0322580635547637939453125f;
  float _255;
  float _256;
  float _257;
  if (cb6_m10.x != 0u) {
    float _184 = exp2(log2(_166) * 0.0126833133399486541748046875f);
    float _185 = exp2(log2(_167) * 0.0126833133399486541748046875f);
    float _186 = exp2(log2(_168) * 0.0126833133399486541748046875f);
    float3 _214 = float3(exp2(log2(abs(max(_184 - 0.8359375f, 0.0f) / mad(_184, -18.6875f, 18.8515625f))) * 6.277394771575927734375f) * 10000.0f,
                         exp2(log2(abs(max(_185 - 0.8359375f, 0.0f) / mad(_185, -18.6875f, 18.8515625f))) * 6.277394771575927734375f) * 10000.0f,
                         exp2(log2(abs(max(_186 - 0.8359375f, 0.0f) / mad(_186, -18.6875f, 18.8515625f))) * 6.277394771575927734375f) * 10000.0f);
    _255 = dp3_f32(_214, float3(0.0047972532920539379119873046875f, 0.02453201077878475189208984375f, 0.9706707000732421875f));
    _256 = dp3_f32(_214, float3(0.002179562114179134368896484375f, 0.995535671710968017578125f, 0.0022850073873996734619140625f));
    _257 = dp3_f32(_214, float3(0.974895000457763671875f, 0.01959909498691558837890625f, 0.0055059031583368778228759765625f));
  } else {
    float _218 = min(_166, 1.0f);
    float _219 = min(_167, 1.0f);
    float _220 = min(_168, 1.0f);
    float3 _251 = float3(cb6_m11.y * ((_218 <= 0.040449999272823333740234375f) ? (_218 * 0.077399380505084991455078125f) : exp2(log2((_218 + 0.054999999701976776123046875f) * 0.947867333889007568359375f) * 2.400000095367431640625f)),
                         cb6_m11.y * ((_219 <= 0.040449999272823333740234375f) ? (_219 * 0.077399380505084991455078125f) : exp2(log2((_219 + 0.054999999701976776123046875f) * 0.947867333889007568359375f) * 2.400000095367431640625f)),
                         cb6_m11.y * ((_220 <= 0.040449999272823333740234375f) ? (_220 * 0.077399380505084991455078125f) : exp2(log2((_220 + 0.054999999701976776123046875f) * 0.947867333889007568359375f) * 2.400000095367431640625f)));
    _255 = dp3_f32(_251, float3(0.02061560191214084625244140625f, 0.109569765627384185791015625f, 0.869814455509185791015625f));
    _256 = dp3_f32(_251, float3(0.070193774998188018798828125f, 0.916354358196258544921875f, 0.013452428393065929412841796875f));
    _257 = dp3_f32(_251, float3(0.6130974292755126953125f, 0.3395231664180755615234375f, 0.0473794378340244293212890625f));
  }
  float _851;
  float _852;
  float _853;
  switch (cb6_m10.y) {
    case 2u: {
      float _273 = cb6_m11.y * 0.00999999977648258209228515625f;
      float _276 = asfloat(cb6_m6);
      float _278 = mad(cb6_m11.y, 0.00999999977648258209228515625f, -_276);
      float _285 = _276 + ((_278 * cb6_m7.x) / cb6_m5);
      float _286 = mad(_278, cb6_m7.x, _276);
      float _290 = (_273 * cb6_m5) / mad(cb6_m11.y, 0.00999999977648258209228515625f, -_286);
      float _291 = abs(_257 * 0.00999999977648258209228515625f);
      float _292 = abs(_256 * 0.00999999977648258209228515625f);
      float _293 = abs(_255 * 0.00999999977648258209228515625f);
      float _357;
      if (_291 < _276) {
        uint _304;
        uint _307;
        float _310;
        float _311;
        uint _303 = cb6_m6;
        uint _306 = cb6_m8.x;
        for (;;) {
          _310 = asfloat(_306);
          _311 = asfloat(_303);
          if ((_311 - _310) <= 9.9999997473787516355514526367188e-06f) {
            break;
          }
          float _316 = _310 + _311;
          float _317 = _316 * 0.5f;
          uint _318 = asuint(_317);
          float _322 = _317 / _276;
          float _331 = clamp(_322, 0.0f, 1.0f);
          float _332 = _331 * _331;
          float _333 = mad(_331, -2.0f, 3.0f);
          bool _341 = _291 < ((mad(cb6_m5, mad(_316, 0.5f, -_276), _276) * (mad(_332, _333, -1.0f) + 1.0f)) + (mad(_276, exp2(log2(abs(_322)) * cb6_m7.y), asfloat(cb6_m8.x)) * mad(-_332, _333, 1.0f)));
          _307 = _341 ? _306 : _318;
          _304 = _341 ? _318 : _303;
          _303 = _304;
          _306 = _307;
          continue;
        }
        _357 = (_310 + _311) * 0.5f;
      } else {
        _357 = (_291 > _285) ? (_285 + ((_273 * (_291 - _286)) / (_290 * max(mad(cb6_m11.y, 0.00999999977648258209228515625f, -_291), 9.9999997473787516355514526367188e-06f)))) : (_276 + ((_291 - _276) / cb6_m5));
      }
      float _419;
      if (_276 > _292) {
        uint _366;
        uint _369;
        float _372;
        float _373;
        uint _365 = cb6_m6;
        uint _368 = cb6_m8.x;
        for (;;) {
          _372 = asfloat(_368);
          _373 = asfloat(_365);
          if ((_373 - _372) <= 9.9999997473787516355514526367188e-06f) {
            break;
          }
          float _378 = _372 + _373;
          float _379 = _378 * 0.5f;
          uint _380 = asuint(_379);
          float _384 = _379 / _276;
          float _393 = clamp(_384, 0.0f, 1.0f);
          float _394 = _393 * _393;
          float _395 = mad(_393, -2.0f, 3.0f);
          bool _403 = ((mad(cb6_m5, mad(_378, 0.5f, -_276), _276) * (mad(_394, _395, -1.0f) + 1.0f)) + (mad(_276, exp2(log2(abs(_384)) * cb6_m7.y), asfloat(cb6_m8.x)) * mad(-_394, _395, 1.0f))) > _292;
          _369 = _403 ? _368 : _380;
          _366 = _403 ? _380 : _365;
          _365 = _366;
          _368 = _369;
          continue;
        }
        _419 = (_372 + _373) * 0.5f;
      } else {
        _419 = (_285 < _292) ? (_285 + ((_273 * (_292 - _286)) / (_290 * max(mad(cb6_m11.y, 0.00999999977648258209228515625f, -_292), 9.9999997473787516355514526367188e-06f)))) : (_276 + ((_292 - _276) / cb6_m5));
      }
      float _481;
      if (_276 > _293) {
        uint _428;
        uint _431;
        float _434;
        float _435;
        uint _427 = cb6_m6;
        uint _430 = cb6_m8.x;
        for (;;) {
          _434 = asfloat(_430);
          _435 = asfloat(_427);
          if ((_435 - _434) <= 9.9999997473787516355514526367188e-06f) {
            break;
          }
          float _440 = _434 + _435;
          float _441 = _440 * 0.5f;
          uint _442 = asuint(_441);
          float _446 = _441 / _276;
          float _455 = clamp(_446, 0.0f, 1.0f);
          float _456 = _455 * _455;
          float _457 = mad(_455, -2.0f, 3.0f);
          bool _465 = ((mad(cb6_m5, mad(_440, 0.5f, -_276), _276) * (mad(_456, _457, -1.0f) + 1.0f)) + (mad(_276, exp2(log2(abs(_446)) * cb6_m7.y), asfloat(cb6_m8.x)) * mad(-_456, _457, 1.0f))) > _293;
          _431 = _465 ? _430 : _442;
          _428 = _465 ? _442 : _427;
          _427 = _428;
          _430 = _431;
          continue;
        }
        _481 = (_434 + _435) * 0.5f;
      } else {
        _481 = (_285 < _293) ? (_285 + ((_273 * (_293 - _286)) / (_290 * max(mad(cb6_m11.y, 0.00999999977648258209228515625f, -_293), 9.9999997473787516355514526367188e-06f)))) : (_276 + ((_293 - _276) / cb6_m5));
      }
      _851 = _481 * 100.0f;
      _852 = _419 * 100.0f;
      _853 = _357 * 100.0f;
      break;
    }
    case 3u: {
      float _485 = abs(cb6_m11.y);
      float _486 = _257 / _485;
      float _487 = _256 / _485;
      float _488 = _255 / _485;
      float _492 = log2(abs(cb6_m9.x));
      float _499 = cb6_m9.w * cb6_m9.z;
      float _501 = exp2(_492 * _499);
      float _502 = log2(_485);
      float _504 = exp2(_502 * cb6_m9.z);
      float _506 = exp2(_499 * _502);
      float _510 = (_506 - _501) * cb6_m9.y;
      float _513 = mad(_504, cb6_m9.y, -exp2(_492 * cb6_m9.z)) / _510;
      float _518 = ((_501 * _506) - ((_501 * _504) * cb6_m9.y)) / _510;
      float _519 = 1.0f / cb6_m9.z;
      uint _522 = asuint(exp2(_502 * _519));
      uint _524;
      uint _527;
      _524 = 0u;
      _527 = _522;
      uint _525;
      uint _528;
      uint _530;
      uint _529 = 0u;
      for (;;) {
        if (_529 >= 32u) {
          break;
        }
        float _539 = (asfloat(_527) + asfloat(_524)) * 0.5f;
        uint _540 = asuint(_539);
        bool _547 = (_539 / mad(_513, exp2(log2(_539) * cb6_m9.w), _518)) > abs(_486);
        _525 = _547 ? _524 : _540;
        _528 = _547 ? _540 : _527;
        _530 = _529 + 1u;
        _524 = _525;
        _527 = _528;
        _529 = _530;
        continue;
      }
      uint _557;
      uint _560;
      _557 = 0u;
      _560 = _522;
      uint _558;
      uint _561;
      uint _563;
      uint _562 = 0u;
      for (;;) {
        if (_562 >= 32u) {
          break;
        }
        float _572 = (asfloat(_560) + asfloat(_557)) * 0.5f;
        uint _573 = asuint(_572);
        bool _580 = (_572 / mad(_513, exp2(log2(_572) * cb6_m9.w), _518)) > abs(_487);
        _558 = _580 ? _557 : _573;
        _561 = _580 ? _573 : _560;
        _563 = _562 + 1u;
        _557 = _558;
        _560 = _561;
        _562 = _563;
        continue;
      }
      uint _590;
      uint _593;
      _590 = 0u;
      _593 = _522;
      uint _591;
      uint _594;
      uint _596;
      uint _595 = 0u;
      for (;;) {
        if (_595 >= 32u) {
          break;
        }
        float _605 = (asfloat(_593) + asfloat(_590)) * 0.5f;
        uint _606 = asuint(_605);
        bool _613 = (_605 / mad(_513, exp2(log2(_605) * cb6_m9.w), _518)) > abs(_488);
        _591 = _613 ? _590 : _606;
        _594 = _613 ? _606 : _593;
        _596 = _595 + 1u;
        _590 = _591;
        _593 = _594;
        _595 = _596;
        continue;
      }
      _851 = _485 * exp2(_519 * log2((asfloat(_593) + asfloat(_590)) * 0.5f));
      _852 = _485 * exp2(_519 * log2((asfloat(_560) + asfloat(_557)) * 0.5f));
      _853 = _485 * exp2(_519 * log2((asfloat(_527) + asfloat(_524)) * 0.5f));
      break;
    }
    case 4u: {
      _851 = _255 / (1.0f - (_255 / cb6_m11.y));
      _852 = _256 / (1.0f - (_256 / cb6_m11.y));
      _853 = _257 / (1.0f - (_257 / cb6_m11.y));
      break;
    }
    case 5u: {
      _851 = _255;
      _852 = _256;
      _853 = _257;
      break;
    }
    case 6u: {
      _851 = _255;
      _852 = _256;
      _853 = _257;
      break;
    }
    case 1u: {
      float _638 = cb6_m11.y * 0.00999999977648258209228515625f;
      float _641 = asfloat(cb6_m6);
      float _643 = mad(cb6_m11.y, 0.00999999977648258209228515625f, -_641);
      float _650 = _641 + ((_643 * cb6_m7.x) / cb6_m5);
      float _654 = mad(cb6_m11.y, 0.00999999977648258209228515625f, -mad(_643, cb6_m7.x, _641));
      float _655 = (_638 * cb6_m5) / _654;
      float _656 = abs(_257 * 0.00999999977648258209228515625f);
      float _657 = abs(_256 * 0.00999999977648258209228515625f);
      float _658 = abs(_255 * 0.00999999977648258209228515625f);
      float _723;
      if (_656 < _641) {
        uint _669;
        uint _672;
        float _675;
        float _676;
        uint _668 = cb6_m6;
        uint _671 = cb6_m8.x;
        for (;;) {
          _675 = asfloat(_671);
          _676 = asfloat(_668);
          if ((_676 - _675) <= 9.9999997473787516355514526367188e-06f) {
            break;
          }
          float _681 = _675 + _676;
          float _682 = _681 * 0.5f;
          uint _683 = asuint(_682);
          float _687 = _682 / _641;
          float _696 = clamp(_687, 0.0f, 1.0f);
          float _697 = _696 * _696;
          float _698 = mad(_696, -2.0f, 3.0f);
          bool _706 = _656 < ((mad(cb6_m5, mad(_681, 0.5f, -_641), _641) * (mad(_697, _698, -1.0f) + 1.0f)) + (mad(_641, exp2(log2(abs(_687)) * cb6_m7.y), asfloat(cb6_m8.x)) * mad(-_697, _698, 1.0f)));
          _672 = _706 ? _671 : _683;
          _669 = _706 ? _683 : _668;
          _668 = _669;
          _671 = _672;
          continue;
        }
        _723 = (_675 + _676) * 0.5f;
      } else {
        _723 = (_656 > _650) ? (_650 - (((_638 * log2(max(mad(cb6_m11.y, 0.00999999977648258209228515625f, -_656) / _654, 9.9999997473787516355514526367188e-06f))) * 0.693147182464599609375f) / _655)) : (_641 + ((_656 - _641) / cb6_m5));
      }
      float _786;
      if (_641 > _657) {
        uint _732;
        uint _735;
        float _738;
        float _739;
        uint _731 = cb6_m6;
        uint _734 = cb6_m8.x;
        for (;;) {
          _738 = asfloat(_734);
          _739 = asfloat(_731);
          if ((_739 - _738) <= 9.9999997473787516355514526367188e-06f) {
            break;
          }
          float _744 = _738 + _739;
          float _745 = _744 * 0.5f;
          uint _746 = asuint(_745);
          float _750 = _745 / _641;
          float _759 = clamp(_750, 0.0f, 1.0f);
          float _760 = _759 * _759;
          float _761 = mad(_759, -2.0f, 3.0f);
          bool _769 = ((mad(cb6_m5, mad(_744, 0.5f, -_641), _641) * (mad(_760, _761, -1.0f) + 1.0f)) + (mad(_641, exp2(log2(abs(_750)) * cb6_m7.y), asfloat(cb6_m8.x)) * mad(-_760, _761, 1.0f))) > _657;
          _735 = _769 ? _734 : _746;
          _732 = _769 ? _746 : _731;
          _731 = _732;
          _734 = _735;
          continue;
        }
        _786 = (_738 + _739) * 0.5f;
      } else {
        _786 = (_650 < _657) ? (_650 - (((_638 * log2(max(mad(cb6_m11.y, 0.00999999977648258209228515625f, -_657) / _654, 9.9999997473787516355514526367188e-06f))) * 0.693147182464599609375f) / _655)) : (_641 + ((_657 - _641) / cb6_m5));
      }
      float _849;
      if (_641 > _658) {
        uint _795;
        uint _798;
        float _801;
        float _802;
        uint _794 = cb6_m6;
        uint _797 = cb6_m8.x;
        for (;;) {
          _801 = asfloat(_797);
          _802 = asfloat(_794);
          if ((_802 - _801) <= 9.9999997473787516355514526367188e-06f) {
            break;
          }
          float _807 = _801 + _802;
          float _808 = _807 * 0.5f;
          uint _809 = asuint(_808);
          float _813 = _808 / _641;
          float _822 = clamp(_813, 0.0f, 1.0f);
          float _823 = _822 * _822;
          float _824 = mad(_822, -2.0f, 3.0f);
          bool _832 = ((mad(cb6_m5, mad(_807, 0.5f, -_641), _641) * (mad(_823, _824, -1.0f) + 1.0f)) + (mad(_641, exp2(log2(abs(_813)) * cb6_m7.y), asfloat(cb6_m8.x)) * mad(-_823, _824, 1.0f))) > _658;
          _798 = _832 ? _797 : _809;
          _795 = _832 ? _809 : _794;
          _794 = _795;
          _797 = _798;
          continue;
        }
        _849 = (_801 + _802) * 0.5f;
      } else {
        _849 = (_650 < _658) ? (_650 - (((_638 * log2(max(mad(cb6_m11.y, 0.00999999977648258209228515625f, -_658) / _654, 9.9999997473787516355514526367188e-06f))) * 0.693147182464599609375f) / _655)) : (_641 + ((_658 - _641) / cb6_m5));
      }
      _851 = _849 * 100.0f;
      _852 = _786 * 100.0f;
      _853 = _723 * 100.0f;
      break;
    }
    default: {
      _851 = 0.0f;
      _852 = 0.0f;
      _853 = 0.0f;
      break;
    }
  }
  float _861 = (_853 / cb6_m11.x) * exposure;
  float _862 = exposure * (_852 / cb6_m11.x);
  float _863 = exposure * (_851 / cb6_m11.x);
  float _1207;
  float _1208;
  float _1209;
  switch (cb6_m3.y) {
    case 2u: {
      float _879 = cb6_m4.y * 0.00999999977648258209228515625f;
      float _883 = mad(cb6_m4.y, 0.00999999977648258209228515625f, -cb6_m0.y);
      float _890 = abs(_861 * 0.00999999977648258209228515625f);
      float _891 = abs(_862 * 0.00999999977648258209228515625f);
      float _892 = abs(_863 * 0.00999999977648258209228515625f);
      bool _899 = cb6_m0.y > 9.9999997473787516355514526367188e-06f;
      float _900 = _890 / cb6_m0.y;
      float _901 = _891 / cb6_m0.y;
      float _902 = _892 / cb6_m0.y;
      float _925 = ((_883 * cb6_m0.z) / cb6_m0.x) + cb6_m0.y;
      float _929 = mad(cb6_m4.y, 0.00999999977648258209228515625f, -mad(_883, cb6_m0.z, cb6_m0.y));
      float _930 = (_879 * cb6_m0.x) / _929;
      float _952 = clamp(_900, 0.0f, 1.0f);
      float _953 = clamp(_901, 0.0f, 1.0f);
      float _954 = clamp(_902, 0.0f, 1.0f);
      float _955 = _952 * _952;
      float _956 = _953 * _953;
      float _957 = _954 * _954;
      float _958 = mad(_952, -2.0f, 3.0f);
      float _959 = mad(_953, -2.0f, 3.0f);
      float _960 = mad(_954, -2.0f, 3.0f);
      bool _967 = _890 > _925;
      bool _968 = _925 < _891;
      bool _969 = _925 < _892;
      _1207 = mad(float(_969), mad(cb6_m4.y, 0.00999999977648258209228515625f, -(_929 / (((_930 * (_892 - _925)) / _879) + 1.0f))), (mad(-_960, _957, 1.0f) * (_899 ? mad(cb6_m0.y, exp2(cb6_m0.w * log2(abs(_902))), cb6_m1.x) : cb6_m1.x)) + (((_969 ? (-1.0f) : (-0.0f)) + (mad(_960, _957, -1.0f) + 1.0f)) * mad(cb6_m0.x, _892 - cb6_m0.y, cb6_m0.y))) * 100.0f;
      _1208 = mad(float(_968), mad(cb6_m4.y, 0.00999999977648258209228515625f, -(_929 / (((_930 * (_891 - _925)) / _879) + 1.0f))), (mad(-_959, _956, 1.0f) * (_899 ? mad(cb6_m0.y, exp2(cb6_m0.w * log2(abs(_901))), cb6_m1.x) : cb6_m1.x)) + (((_968 ? (-1.0f) : (-0.0f)) + (mad(_959, _956, -1.0f) + 1.0f)) * mad(cb6_m0.x, _891 - cb6_m0.y, cb6_m0.y))) * 100.0f;
      _1209 = mad(mad(cb6_m4.y, 0.00999999977648258209228515625f, -(_929 / (((_930 * (_890 - _925)) / _879) + 1.0f))), float(_967), (mad(_890 - cb6_m0.y, cb6_m0.x, cb6_m0.y) * ((mad(_955, _958, -1.0f) + 1.0f) + (_967 ? (-1.0f) : (-0.0f)))) + (mad(-_955, _958, 1.0f) * (_899 ? mad(exp2(cb6_m0.w * log2(abs(_900))), cb6_m0.y, cb6_m1.x) : cb6_m1.x))) * 100.0f;
      break;
    }
    case 3u: {
      float _1002 = abs(cb6_m4.y);
      float _1009 = log2(abs(cb6_m2.x));
      float _1016 = cb6_m2.z * cb6_m2.w;
      float _1018 = exp2(_1009 * _1016);
      float _1019 = log2(_1002);
      float _1021 = exp2(cb6_m2.z * _1019);
      float _1023 = exp2(_1016 * _1019);
      float _1027 = cb6_m2.y * (_1023 - _1018);
      float _1030 = mad(cb6_m2.y, _1021, -exp2(cb6_m2.z * _1009)) / _1027;
      float _1035 = ((_1018 * _1023) - (cb6_m2.y * (_1018 * _1021))) / _1027;
      float _1042 = cb6_m2.z * log2(abs(_861 / _1002));
      float _1043 = cb6_m2.z * log2(abs(_862 / _1002));
      float _1044 = cb6_m2.z * log2(abs(_863 / _1002));
      _1207 = cb6_m4.y * (exp2(_1044) / mad(_1030, exp2(cb6_m2.w * _1044), _1035));
      _1208 = cb6_m4.y * (exp2(_1043) / mad(_1030, exp2(cb6_m2.w * _1043), _1035));
      _1209 = cb6_m4.y * (exp2(_1042) / mad(_1030, exp2(_1042 * cb6_m2.w), _1035));
      break;
    }
    case 4u: {
      _1207 = _863 / ((_863 / cb6_m4.y) + 1.0f);
      _1208 = _862 / ((_862 / cb6_m4.y) + 1.0f);
      _1209 = _861 / ((_861 / cb6_m4.y) + 1.0f);
      break;
    }
    case 5u: {
      _1207 = _863;
      _1208 = _862;
      _1209 = _861;
      break;
    }
    case 6u: {
      _1207 = min(cb6_m4.y, _863);
      _1208 = min(cb6_m4.y, _862);
      _1209 = min(cb6_m4.y, _861);
      break;
    }
    case 1u: {
      ImmortalsToneMapConfig config = CreateImmortalsToneMapConfig(tone_map_contrast, tone_map_toe_threshold, tone_map_mid_point, tone_map_toe_slope, tone_map_black_offset, peak_value);
      float3 tonemapped_ap1 = ApplyImmortalsToneMap(float3(_861, _862, _863), config);

      tonemapped_ap1 /= 100.f;

#if RENODX_GAME_GAMMA_CORRECTION
      float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);
      tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
      tonemapped_ap1 = renodx::color::ap1::from::BT709(tonemapped_bt709);
#endif

      tonemapped_ap1 *= diffuse_white_nits;

      _1207 = tonemapped_ap1.z;
      _1208 = tonemapped_ap1.y;
      _1209 = tonemapped_ap1.x;
      break;
    }
    default: {
      _1207 = 0.0f;
      _1208 = 0.0f;
      _1209 = 0.0f;
      break;
    }
  }
  float _1286;
  float _1287;
  float _1288;
  if (output_hdr_enabled) {
    float3 _1216 = float3(_1209, _1208, _1207);
    float _1224 = exp2(log2(abs(dp3_f32(_1216, float3(1.02582466602325439453125f, -0.020053170621395111083984375f, -0.0057715452276170253753662109375f)) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
    float _1235 = exp2(log2(abs(dp3_f32(_1216, float3(-0.00223436788655817508697509765625f, 1.00458621978759765625f, -0.00235217227600514888763427734375f)) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
    float _1246 = exp2(log2(abs(dp3_f32(_1216, float3(-0.005013366229832172393798828125f, -0.0252900607883930206298828125f, 1.030303478240966796875f)) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
    _1286 = exp2(log2(mad(_1246, 18.8515625f, 0.8359375f) / mad(_1246, 18.6875f, 1.0f)) * 78.84375f);
    _1287 = exp2(log2(mad(_1235, 18.8515625f, 0.8359375f) / mad(_1235, 18.6875f, 1.0f)) * 78.84375f);
    _1288 = exp2(log2(mad(_1224, 18.8515625f, 0.8359375f) / mad(_1224, 18.6875f, 1.0f)) * 78.84375f);
  } else {
    float3 _1253 = float3(_1209, _1208, _1207);
    float _1262 = clamp(dp3_f32(_1253, float3(1.70505106449127197265625f, -0.621791899204254150390625f, -0.083258844912052154541015625f)) / cb6_m4.y, 0.0f, 1.0f);
    float _1263 = clamp(dp3_f32(_1253, float3(-0.1302564442157745361328125f, 1.14080417156219482421875f, -0.01054835133254528045654296875f)) / cb6_m4.y, 0.0f, 1.0f);
    float _1264 = clamp(dp3_f32(_1253, float3(-0.024003379046916961669921875f, -0.12896890938282012939453125f, 1.15297257900238037109375f)) / cb6_m4.y, 0.0f, 1.0f);
    _1286 = (_1264 <= 0.003130800090730190277099609375f) ? (_1264 * 12.9200000762939453125f) : mad(exp2(log2(_1264) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1287 = (_1263 <= 0.003130800090730190277099609375f) ? (_1263 * 12.9200000762939453125f) : mad(exp2(log2(_1263) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1288 = (_1262 <= 0.003130800090730190277099609375f) ? (_1262 * 12.9200000762939453125f) : mad(exp2(log2(_1262) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
  }
  u4[uint3(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y, gl_GlobalInvocationID.z)] = float4(_1288, _1287, _1286, 1.0f);
}

[numthreads(16, 16, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
