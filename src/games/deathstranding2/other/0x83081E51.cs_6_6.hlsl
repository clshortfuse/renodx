#include "../common.hlsli"

Texture2D<float4> t0_space6 : register(t0, space6);

Texture2D<float4> t1_space6 : register(t1, space6);

RWTexture2D<float4> u0_space6 : register(u0, space6);

// clang-format off
cbuffer cb0_space5 : register(b0, space5) {
  struct Scratch_PerBatch_Constants {
    struct AAResolverUpscaleParams {
      float4 AAResolverUpscaleParams_000;
      float4 AAResolverUpscaleParams_016;
      float4 AAResolverUpscaleParams_032;
      float4 AAResolverUpscaleParams_048;
      float4 AAResolverUpscaleParams_064;
      float4 AAResolverUpscaleParams_080;
      float4 AAResolverUpscaleParams_096;
      float4 AAResolverUpscaleParams_112;
      float AAResolverUpscaleParams_128;
      float2 AAResolverUpscaleParams_132;
    } Scratch_PerBatch_Constants_000;
  } Scratch_PerBatch_000 : packoffset(c000.x);
};
// clang-format on

[numthreads(64, 1, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  int _30 = (((uint)(SV_GroupThreadID.x) >> 1) & 7) | ((uint)((uint)(SV_GroupID.x) << 4));
  int _31 = ((((uint)(SV_GroupThreadID.x) >> 3) & 6) | ((uint)(SV_GroupThreadID.x) & 1)) | ((uint)((uint)(SV_GroupID.y) << 4));
  uint _33 = _30 << 16;
  uint _34 = _33 >> 16;
  uint _35 = _31 << 16;
  uint _37 = ((uint)(_35 + -65536u)) >> 16;
  float4 _39 = t0_space6.Load(int3(_34, _37, 0));
  half _43 = half(_39.x);
  half _44 = half(_39.y);
  half _45 = half(_39.z);
  uint _47 = ((uint)(_33 + -65536u)) >> 16;
  uint _48 = _35 >> 16;
  float4 _49 = t0_space6.Load(int3(_47, _48, 0));
  half _53 = half(_49.x);
  half _54 = half(_49.y);
  half _55 = half(_49.z);
  float4 _56 = t0_space6.Load(int3(_34, _48, 0));
  uint _64 = (_33 + 65536) >> 16;
  float4 _65 = t0_space6.Load(int3(_64, _48, 0));
  half _69 = half(_65.x);
  half _70 = half(_65.y);
  half _71 = half(_65.z);
  uint _73 = (_35 + 65536) >> 16;
  float4 _74 = t0_space6.Load(int3(_34, _73, 0));
  half _78 = half(_74.x);
  half _79 = half(_74.y);
  half _80 = half(_74.z);
  half _83 = min((half)(min(_43, (half)(min(_53, _69)))), _78);
  half _86 = min((half)(min(_44, (half)(min(_54, _70)))), _79);
  half _89 = min((half)(min(_45, (half)(min(_55, _71)))), _80);
  half _92 = max((half)(max(_43, (half)(max(_53, _69)))), _78);
  half _95 = max((half)(max(_44, (half)(max(_54, _70)))), _79);
  half _98 = max((half)(max(_45, (half)(max(_55, _71)))), _80);
  half _132 = half(f16tof32(((int)(asint(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_000.y) & 65535))));
  half _133 = _132 * (half)(max(-0.1875h, (half)(min((half)(max((half)(max(((half)(-0.0h - ((half)(_83 * ((half)(0.25h / _92)))))), ((half)(((half)(1.0h / ((half)(((half)(_83 * 4.0h)) + -4.0h)))) * ((half)(1.0h - _92)))))), (half)(max((half)(max(((half)(-0.0h - ((half)(_86 * ((half)(0.25h / _95)))))), ((half)(((half)(1.0h / ((half)(((half)(_86 * 4.0h)) + -4.0h)))) * ((half)(1.0h - _95)))))), (half)(max(((half)(-0.0h - ((half)(_89 * ((half)(0.25h / _98)))))), ((half)(((half)(1.0h / ((half)(((half)(_89 * 4.0h)) + -4.0h)))) * ((half)(1.0h - _98)))))))))), 0.0h))));
  half _135 = ((half)(_133 * 4.0h)) + 1.0h;
  half _141 = half(f16tof32(((int)(((uint)(30605u - f32tof16(float(_135)))) & 65535))));
  half _144 = ((half)(2.0h - ((half)(_135 * _141)))) * _141;
  half _163 = half(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.z);
  half _164 = min(((half)(_144 * ((half)(((half)(_133 * ((half)(((half)(((half)(_53 + _43)) + _69)) + _78)))) + (half)(half(_56.x)))))), _163);
  half _165 = min(((half)(_144 * ((half)(((half)(_133 * ((half)(((half)(((half)(_54 + _44)) + _70)) + _79)))) + (half)(half(_56.y)))))), _163);
  half _166 = min(((half)(_144 * ((half)(((half)(_133 * ((half)(((half)(((half)(_55 + _45)) + _71)) + _80)))) + (half)(half(_56.z)))))), _163);
  bool _168 = (int(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_128) == 0);
  float _198;
  float _210;
  float _222;
  float _290;
  float _291;
  float _292;
  float _326;
  float _338;
  float _404;
  float _405;
  float _406;
  half _411;
  half _412;
  half _413;
  float _572;
  float _584;
  float _596;
  float _664;
  float _665;
  float _666;
  float _700;
  float _712;
  float _778;
  float _779;
  float _780;
  half _785;
  half _786;
  half _787;
  float _946;
  float _958;
  float _970;
  float _1038;
  float _1039;
  float _1040;
  float _1074;
  float _1086;
  float _1152;
  float _1153;
  float _1154;
  half _1159;
  half _1160;
  half _1161;
  float _1313;
  float _1325;
  float _1337;
  float _1405;
  float _1406;
  float _1407;
  float _1441;
  float _1453;
  float _1519;
  float _1520;
  float _1521;
  half _1526;
  half _1527;
  half _1528;
  if (!_168) {
    float4 _171 = t1_space6.Load(int3(_30, _31, 0));
    if ((max(_171.x, max(_171.y, _171.z)) + _171.w) > 0.0f) {
      float _181 = float(_164);
      float _182 = float(_165);
      float _183 = float(_166);
      int _184 = int(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.w);
      do {
        [branch]
        if (_184 == 1) {
          do {
            if (_181 < 0.040449999272823334f) {
              _198 = (_181 * 0.07739938050508499f);
            } else {
              _198 = exp2(log2(abs((_181 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
            }
            do {
              if (_182 < 0.040449999272823334f) {
                _210 = (_182 * 0.07739938050508499f);
              } else {
                _210 = exp2(log2(abs((_182 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
              }
              do {
                if (_183 < 0.040449999272823334f) {
                  _222 = (_183 * 0.07739938050508499f);
                } else {
                  _222 = exp2(log2(abs((_183 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
                }
                float _223 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.x;
                _290 = exp2(log2(abs(_198)) * _223);
                _291 = exp2(log2(abs(_210)) * _223);
                _292 = exp2(log2(abs(_222)) * _223);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (_184 == 2) {
#if 1
            BT709FromPQ(
                _181, _182, _183,
                Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.x,
                Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.y,
                _290, _291, _292);
#else
            float _248 = exp2(log2(abs(_181)) * 0.012683313339948654f);
            float _249 = exp2(log2(abs(_182)) * 0.012683313339948654f);
            float _250 = exp2(log2(abs(_183)) * 0.012683313339948654f);
            float _263 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.x;
            float _276 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.y;
            float _277 = _276 * exp2(log2(abs((_248 + -0.8359375f) / (18.8515625f - (_248 * 18.6875f)))) * _263);
            float _278 = _276 * exp2(log2(abs((_249 + -0.8359375f) / (18.8515625f - (_249 * 18.6875f)))) * _263);
            float _279 = _276 * exp2(log2(abs((_250 + -0.8359375f) / (18.8515625f - (_250 * 18.6875f)))) * _263);
            _290 = mad(-0.07284989953041077f, _279, mad(-0.5876410007476807f, _278, (_277 * 1.6604900360107422f)));
            _291 = mad(-0.008349419571459293f, _279, mad(1.1328999996185303f, _278, (_277 * -0.124549999833107f)));
            _292 = mad(1.1187299489974976f, _279, mad(-0.10057900100946426f, _278, (_277 * -0.018150800839066505f)));
#endif
          } else {
            _290 = _181;
            _291 = _182;
            _292 = _183;
          }
        }
        float _293 = 1.0f - _171.w;
        float _297 = (_290 * _293) + _171.x;
        float _298 = (_291 * _293) + _171.y;
        float _299 = (_292 * _293) + _171.z;
        int _300 = int(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.w);
        do {
          [branch]
          if (_300 == 1) {
            float _312 = exp2(log2(abs(_297)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
            float _313 = exp2(log2(abs(_298)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
            float _314 = exp2(log2(abs(_299)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
            do {
              if (_312 < 0.003100000089034438f) {
                _326 = (_312 * 12.920000076293945f);
              } else {
                _326 = ((exp2(log2(abs(_312)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
              }
              do {
                if (_313 < 0.003100000089034438f) {
                  _338 = (_313 * 12.920000076293945f);
                } else {
                  _338 = ((exp2(log2(abs(_313)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
                }
                if (_314 < 0.003100000089034438f) {
                  _404 = _326;
                  _405 = _338;
                  _406 = (_314 * 12.920000076293945f);
                } else {
                  _404 = _326;
                  _405 = _338;
                  _406 = ((exp2(log2(abs(_314)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
                }
              } while (false);
            } while (false);
          } else {
            if (_300 == 2) {
#if 1
              PQFromBT709(
                  _297, _298, _299,
                  Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x,
                  Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y,
                  _404, _405, _406);
#else
              float _373 = exp2(log2(abs(mad(0.04331306740641594f, _299, mad(0.3292830288410187f, _298, (_297 * 0.6274039149284363f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
              float _374 = exp2(log2(abs(mad(0.011362316086888313f, _299, mad(0.9195404052734375f, _298, (_297 * 0.06909728795289993f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
              float _375 = exp2(log2(abs(mad(0.8955952525138855f, _299, mad(0.08801330626010895f, _298, (_297 * 0.016391439363360405f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
              _404 = exp2(log2(abs(((_373 * 18.8515625f) + 0.8359375f) / ((_373 * 18.6875f) + 1.0f))) * 78.84375f);
              _405 = exp2(log2(abs(((_374 * 18.8515625f) + 0.8359375f) / ((_374 * 18.6875f) + 1.0f))) * 78.84375f);
              _406 = exp2(log2(abs(((_375 * 18.8515625f) + 0.8359375f) / ((_375 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
            } else {
              _404 = _297;
              _405 = _298;
              _406 = _299;
            }
          }
          _411 = (half)(half(_404));
          _412 = (half)(half(_405));
          _413 = (half)(half(_406));
        } while (false);
      } while (false);
    } else {
      _411 = _164;
      _412 = _165;
      _413 = _166;
    }
  } else {
    _411 = _164;
    _412 = _165;
    _413 = _166;
  }
  u0_space6[int2(_30, _31)] = float4(float(_411), float(_412), float(_413), 1.0f);
  int _418 = _30 | 8;
  uint _419 = _418 << 16;
  uint _420 = _419 >> 16;
  float4 _422 = t0_space6.Load(int3(_420, _37, 0));
  half _426 = half(_422.x);
  half _427 = half(_422.y);
  half _428 = half(_422.z);
  uint _430 = ((uint)(_419 + -65536u)) >> 16;
  float4 _431 = t0_space6.Load(int3(_430, _48, 0));
  half _435 = half(_431.x);
  half _436 = half(_431.y);
  half _437 = half(_431.z);
  float4 _438 = t0_space6.Load(int3(_420, _48, 0));
  uint _446 = ((uint)(_419 + 65536u)) >> 16;
  float4 _447 = t0_space6.Load(int3(_446, _48, 0));
  half _451 = half(_447.x);
  half _452 = half(_447.y);
  half _453 = half(_447.z);
  float4 _454 = t0_space6.Load(int3(_420, _73, 0));
  half _458 = half(_454.x);
  half _459 = half(_454.y);
  half _460 = half(_454.z);
  half _463 = min((half)(min(_426, (half)(min(_435, _451)))), _458);
  half _466 = min((half)(min(_427, (half)(min(_436, _452)))), _459);
  half _469 = min((half)(min(_428, (half)(min(_437, _453)))), _460);
  half _472 = max((half)(max(_426, (half)(max(_435, _451)))), _458);
  half _475 = max((half)(max(_427, (half)(max(_436, _452)))), _459);
  half _478 = max((half)(max(_428, (half)(max(_437, _453)))), _460);
  half _510 = (half)(max(-0.1875h, (half)(min((half)(max((half)(max(((half)(-0.0h - ((half)(_463 * ((half)(0.25h / _472)))))), ((half)(((half)(1.0h / ((half)(((half)(_463 * 4.0h)) + -4.0h)))) * ((half)(1.0h - _472)))))), (half)(max((half)(max(((half)(-0.0h - ((half)(_466 * ((half)(0.25h / _475)))))), ((half)(((half)(1.0h / ((half)(((half)(_466 * 4.0h)) + -4.0h)))) * ((half)(1.0h - _475)))))), (half)(max(((half)(-0.0h - ((half)(_469 * ((half)(0.25h / _478)))))), ((half)(((half)(1.0h / ((half)(((half)(_469 * 4.0h)) + -4.0h)))) * ((half)(1.0h - _478)))))))))), 0.0h)))) * _132;
  half _512 = ((half)(_510 * 4.0h)) + 1.0h;
  half _518 = half(f16tof32(((int)(((uint)(30605u - f32tof16(float(_512)))) & 65535))));
  half _521 = ((half)(2.0h - ((half)(_512 * _518)))) * _518;
  half _540 = min(((half)(_521 * ((half)(((half)(_510 * ((half)(((half)(((half)(_435 + _426)) + _451)) + _458)))) + (half)(half(_438.x)))))), _163);
  half _541 = min(((half)(_521 * ((half)(((half)(_510 * ((half)(((half)(((half)(_436 + _427)) + _452)) + _459)))) + (half)(half(_438.y)))))), _163);
  half _542 = min(((half)(_521 * ((half)(((half)(_510 * ((half)(((half)(((half)(_437 + _428)) + _453)) + _460)))) + (half)(half(_438.z)))))), _163);
  if (!_168) {
    float4 _545 = t1_space6.Load(int3(_418, _31, 0));
    if ((max(_545.x, max(_545.y, _545.z)) + _545.w) > 0.0f) {
      float _555 = float(_540);
      float _556 = float(_541);
      float _557 = float(_542);
      int _558 = int(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.w);
      do {
        [branch]
        if (_558 == 1) {
          do {
            if (_555 < 0.040449999272823334f) {
              _572 = (_555 * 0.07739938050508499f);
            } else {
              _572 = exp2(log2(abs((_555 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
            }
            do {
              if (_556 < 0.040449999272823334f) {
                _584 = (_556 * 0.07739938050508499f);
              } else {
                _584 = exp2(log2(abs((_556 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
              }
              do {
                if (_557 < 0.040449999272823334f) {
                  _596 = (_557 * 0.07739938050508499f);
                } else {
                  _596 = exp2(log2(abs((_557 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
                }
                float _597 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.x;
                _664 = exp2(log2(abs(_572)) * _597);
                _665 = exp2(log2(abs(_584)) * _597);
                _666 = exp2(log2(abs(_596)) * _597);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (_558 == 2) {
#if 1
            BT709FromPQ(
                _555, _556, _557,
                Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.x,
                Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.y,
                _664, _665, _666);
#else
            float _622 = exp2(log2(abs(_555)) * 0.012683313339948654f);
            float _623 = exp2(log2(abs(_556)) * 0.012683313339948654f);
            float _624 = exp2(log2(abs(_557)) * 0.012683313339948654f);
            float _637 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.x;
            float _650 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.y;
            float _651 = _650 * exp2(log2(abs((_622 + -0.8359375f) / (18.8515625f - (_622 * 18.6875f)))) * _637);
            float _652 = _650 * exp2(log2(abs((_623 + -0.8359375f) / (18.8515625f - (_623 * 18.6875f)))) * _637);
            float _653 = _650 * exp2(log2(abs((_624 + -0.8359375f) / (18.8515625f - (_624 * 18.6875f)))) * _637);
            _664 = mad(-0.07284989953041077f, _653, mad(-0.5876410007476807f, _652, (_651 * 1.6604900360107422f)));
            _665 = mad(-0.008349419571459293f, _653, mad(1.1328999996185303f, _652, (_651 * -0.124549999833107f)));
            _666 = mad(1.1187299489974976f, _653, mad(-0.10057900100946426f, _652, (_651 * -0.018150800839066505f)));
#endif
          } else {
            _664 = _555;
            _665 = _556;
            _666 = _557;
          }
        }
        float _667 = 1.0f - _545.w;
        float _671 = (_664 * _667) + _545.x;
        float _672 = (_665 * _667) + _545.y;
        float _673 = (_666 * _667) + _545.z;
        int _674 = int(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.w);
        do {
          [branch]
          if (_674 == 1) {
            float _686 = exp2(log2(abs(_671)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
            float _687 = exp2(log2(abs(_672)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
            float _688 = exp2(log2(abs(_673)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
            do {
              if (_686 < 0.003100000089034438f) {
                _700 = (_686 * 12.920000076293945f);
              } else {
                _700 = ((exp2(log2(abs(_686)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
              }
              do {
                if (_687 < 0.003100000089034438f) {
                  _712 = (_687 * 12.920000076293945f);
                } else {
                  _712 = ((exp2(log2(abs(_687)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
                }
                if (_688 < 0.003100000089034438f) {
                  _778 = _700;
                  _779 = _712;
                  _780 = (_688 * 12.920000076293945f);
                } else {
                  _778 = _700;
                  _779 = _712;
                  _780 = ((exp2(log2(abs(_688)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
                }
              } while (false);
            } while (false);
          } else {
            if (_674 == 2) {
#if 1
              PQFromBT709(
                  _671, _672, _673,
                  Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x,
                  Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y,
                  _778, _779, _780);
#else
              float _747 = exp2(log2(abs(mad(0.04331306740641594f, _673, mad(0.3292830288410187f, _672, (_671 * 0.6274039149284363f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
              float _748 = exp2(log2(abs(mad(0.011362316086888313f, _673, mad(0.9195404052734375f, _672, (_671 * 0.06909728795289993f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
              float _749 = exp2(log2(abs(mad(0.8955952525138855f, _673, mad(0.08801330626010895f, _672, (_671 * 0.016391439363360405f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
              _778 = exp2(log2(abs(((_747 * 18.8515625f) + 0.8359375f) / ((_747 * 18.6875f) + 1.0f))) * 78.84375f);
              _779 = exp2(log2(abs(((_748 * 18.8515625f) + 0.8359375f) / ((_748 * 18.6875f) + 1.0f))) * 78.84375f);
              _780 = exp2(log2(abs(((_749 * 18.8515625f) + 0.8359375f) / ((_749 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
            } else {
              _778 = _671;
              _779 = _672;
              _780 = _673;
            }
          }
          _785 = (half)(half(_778));
          _786 = (half)(half(_779));
          _787 = (half)(half(_780));
        } while (false);
      } while (false);
    } else {
      _785 = _540;
      _786 = _541;
      _787 = _542;
    }
  } else {
    _785 = _540;
    _786 = _541;
    _787 = _542;
  }
  u0_space6[int2(_418, _31)] = float4(float(_785), float(_786), float(_787), 1.0f);
  int _792 = _31 | 8;
  uint _793 = _792 << 16;
  uint _795 = ((uint)(_793 + -65536u)) >> 16;
  float4 _797 = t0_space6.Load(int3(_420, _795, 0));
  half _801 = half(_797.x);
  half _802 = half(_797.y);
  half _803 = half(_797.z);
  uint _804 = _793 >> 16;
  float4 _805 = t0_space6.Load(int3(_430, _804, 0));
  half _809 = half(_805.x);
  half _810 = half(_805.y);
  half _811 = half(_805.z);
  float4 _812 = t0_space6.Load(int3(_420, _804, 0));
  float4 _819 = t0_space6.Load(int3(_446, _804, 0));
  half _823 = half(_819.x);
  half _824 = half(_819.y);
  half _825 = half(_819.z);
  uint _827 = ((uint)(_793 + 65536u)) >> 16;
  float4 _828 = t0_space6.Load(int3(_420, _827, 0));
  half _832 = half(_828.x);
  half _833 = half(_828.y);
  half _834 = half(_828.z);
  half _837 = min((half)(min(_801, (half)(min(_809, _823)))), _832);
  half _840 = min((half)(min(_802, (half)(min(_810, _824)))), _833);
  half _843 = min((half)(min(_803, (half)(min(_811, _825)))), _834);
  half _846 = max((half)(max(_801, (half)(max(_809, _823)))), _832);
  half _849 = max((half)(max(_802, (half)(max(_810, _824)))), _833);
  half _852 = max((half)(max(_803, (half)(max(_811, _825)))), _834);
  half _884 = (half)(max(-0.1875h, (half)(min((half)(max((half)(max(((half)(-0.0h - ((half)(_837 * ((half)(0.25h / _846)))))), ((half)(((half)(1.0h / ((half)(((half)(_837 * 4.0h)) + -4.0h)))) * ((half)(1.0h - _846)))))), (half)(max((half)(max(((half)(-0.0h - ((half)(_840 * ((half)(0.25h / _849)))))), ((half)(((half)(1.0h / ((half)(((half)(_840 * 4.0h)) + -4.0h)))) * ((half)(1.0h - _849)))))), (half)(max(((half)(-0.0h - ((half)(_843 * ((half)(0.25h / _852)))))), ((half)(((half)(1.0h / ((half)(((half)(_843 * 4.0h)) + -4.0h)))) * ((half)(1.0h - _852)))))))))), 0.0h)))) * _132;
  half _886 = ((half)(_884 * 4.0h)) + 1.0h;
  half _892 = half(f16tof32(((int)(((uint)(30605u - f32tof16(float(_886)))) & 65535))));
  half _895 = ((half)(2.0h - ((half)(_886 * _892)))) * _892;
  half _914 = min(((half)(_895 * ((half)(((half)(_884 * ((half)(((half)(((half)(_809 + _801)) + _823)) + _832)))) + (half)(half(_812.x)))))), _163);
  half _915 = min(((half)(_895 * ((half)(((half)(_884 * ((half)(((half)(((half)(_810 + _802)) + _824)) + _833)))) + (half)(half(_812.y)))))), _163);
  half _916 = min(((half)(_895 * ((half)(((half)(_884 * ((half)(((half)(((half)(_811 + _803)) + _825)) + _834)))) + (half)(half(_812.z)))))), _163);
  if (!_168) {
    float4 _919 = t1_space6.Load(int3(_418, _792, 0));
    if ((max(_919.x, max(_919.y, _919.z)) + _919.w) > 0.0f) {
      float _929 = float(_914);
      float _930 = float(_915);
      float _931 = float(_916);
      int _932 = int(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.w);
      do {
        [branch]
        if (_932 == 1) {
          do {
            if (_929 < 0.040449999272823334f) {
              _946 = (_929 * 0.07739938050508499f);
            } else {
              _946 = exp2(log2(abs((_929 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
            }
            do {
              if (_930 < 0.040449999272823334f) {
                _958 = (_930 * 0.07739938050508499f);
              } else {
                _958 = exp2(log2(abs((_930 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
              }
              do {
                if (_931 < 0.040449999272823334f) {
                  _970 = (_931 * 0.07739938050508499f);
                } else {
                  _970 = exp2(log2(abs((_931 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
                }
                float _971 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.x;
                _1038 = exp2(log2(abs(_946)) * _971);
                _1039 = exp2(log2(abs(_958)) * _971);
                _1040 = exp2(log2(abs(_970)) * _971);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (_932 == 2) {
#if 1
            BT709FromPQ(
                _929, _930, _931,
                Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.x,
                Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.y,
                _1038, _1039, _1040);
#else
            float _996 = exp2(log2(abs(_929)) * 0.012683313339948654f);
            float _997 = exp2(log2(abs(_930)) * 0.012683313339948654f);
            float _998 = exp2(log2(abs(_931)) * 0.012683313339948654f);
            float _1011 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.x;
            float _1024 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.y;
            float _1025 = _1024 * exp2(log2(abs((_996 + -0.8359375f) / (18.8515625f - (_996 * 18.6875f)))) * _1011);
            float _1026 = _1024 * exp2(log2(abs((_997 + -0.8359375f) / (18.8515625f - (_997 * 18.6875f)))) * _1011);
            float _1027 = _1024 * exp2(log2(abs((_998 + -0.8359375f) / (18.8515625f - (_998 * 18.6875f)))) * _1011);
            _1038 = mad(-0.07284989953041077f, _1027, mad(-0.5876410007476807f, _1026, (_1025 * 1.6604900360107422f)));
            _1039 = mad(-0.008349419571459293f, _1027, mad(1.1328999996185303f, _1026, (_1025 * -0.124549999833107f)));
            _1040 = mad(1.1187299489974976f, _1027, mad(-0.10057900100946426f, _1026, (_1025 * -0.018150800839066505f)));
#endif
          } else {
            _1038 = _929;
            _1039 = _930;
            _1040 = _931;
          }
        }
        float _1041 = 1.0f - _919.w;
        float _1045 = (_1038 * _1041) + _919.x;
        float _1046 = (_1039 * _1041) + _919.y;
        float _1047 = (_1040 * _1041) + _919.z;
        int _1048 = int(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.w);
        do {
          [branch]
          if (_1048 == 1) {
            float _1060 = exp2(log2(abs(_1045)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
            float _1061 = exp2(log2(abs(_1046)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
            float _1062 = exp2(log2(abs(_1047)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
            do {
              if (_1060 < 0.003100000089034438f) {
                _1074 = (_1060 * 12.920000076293945f);
              } else {
                _1074 = ((exp2(log2(abs(_1060)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
              }
              do {
                if (_1061 < 0.003100000089034438f) {
                  _1086 = (_1061 * 12.920000076293945f);
                } else {
                  _1086 = ((exp2(log2(abs(_1061)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
                }
                if (_1062 < 0.003100000089034438f) {
                  _1152 = _1074;
                  _1153 = _1086;
                  _1154 = (_1062 * 12.920000076293945f);
                } else {
                  _1152 = _1074;
                  _1153 = _1086;
                  _1154 = ((exp2(log2(abs(_1062)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
                }
              } while (false);
            } while (false);
          } else {
            if (_1048 == 2) {
#if 1
              PQFromBT709(
                  _1045, _1046, _1047,
                  Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x,
                  Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y,
                  _1152, _1153, _1154);
#else
              float _1121 = exp2(log2(abs(mad(0.04331306740641594f, _1047, mad(0.3292830288410187f, _1046, (_1045 * 0.6274039149284363f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
              float _1122 = exp2(log2(abs(mad(0.011362316086888313f, _1047, mad(0.9195404052734375f, _1046, (_1045 * 0.06909728795289993f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
              float _1123 = exp2(log2(abs(mad(0.8955952525138855f, _1047, mad(0.08801330626010895f, _1046, (_1045 * 0.016391439363360405f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
              _1152 = exp2(log2(abs(((_1121 * 18.8515625f) + 0.8359375f) / ((_1121 * 18.6875f) + 1.0f))) * 78.84375f);
              _1153 = exp2(log2(abs(((_1122 * 18.8515625f) + 0.8359375f) / ((_1122 * 18.6875f) + 1.0f))) * 78.84375f);
              _1154 = exp2(log2(abs(((_1123 * 18.8515625f) + 0.8359375f) / ((_1123 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
            } else {
              _1152 = _1045;
              _1153 = _1046;
              _1154 = _1047;
            }
          }
          _1159 = (half)(half(_1152));
          _1160 = (half)(half(_1153));
          _1161 = (half)(half(_1154));
        } while (false);
      } while (false);
    } else {
      _1159 = _914;
      _1160 = _915;
      _1161 = _916;
    }
  } else {
    _1159 = _914;
    _1160 = _915;
    _1161 = _916;
  }
  u0_space6[int2(_418, _792)] = float4(float(_1159), float(_1160), float(_1161), 1.0f);
  float4 _1167 = t0_space6.Load(int3(_34, _795, 0));
  half _1171 = half(_1167.x);
  half _1172 = half(_1167.y);
  half _1173 = half(_1167.z);
  float4 _1174 = t0_space6.Load(int3(_47, _804, 0));
  half _1178 = half(_1174.x);
  half _1179 = half(_1174.y);
  half _1180 = half(_1174.z);
  float4 _1181 = t0_space6.Load(int3(_34, _804, 0));
  float4 _1188 = t0_space6.Load(int3(_64, _804, 0));
  half _1192 = half(_1188.x);
  half _1193 = half(_1188.y);
  half _1194 = half(_1188.z);
  float4 _1195 = t0_space6.Load(int3(_34, _827, 0));
  half _1199 = half(_1195.x);
  half _1200 = half(_1195.y);
  half _1201 = half(_1195.z);
  half _1204 = min((half)(min(_1171, (half)(min(_1178, _1192)))), _1199);
  half _1207 = min((half)(min(_1172, (half)(min(_1179, _1193)))), _1200);
  half _1210 = min((half)(min(_1173, (half)(min(_1180, _1194)))), _1201);
  half _1213 = max((half)(max(_1171, (half)(max(_1178, _1192)))), _1199);
  half _1216 = max((half)(max(_1172, (half)(max(_1179, _1193)))), _1200);
  half _1219 = max((half)(max(_1173, (half)(max(_1180, _1194)))), _1201);
  half _1251 = (half)(max(-0.1875h, (half)(min((half)(max((half)(max(((half)(-0.0h - ((half)(_1204 * ((half)(0.25h / _1213)))))), ((half)(((half)(1.0h / ((half)(((half)(_1204 * 4.0h)) + -4.0h)))) * ((half)(1.0h - _1213)))))), (half)(max((half)(max(((half)(-0.0h - ((half)(_1207 * ((half)(0.25h / _1216)))))), ((half)(((half)(1.0h / ((half)(((half)(_1207 * 4.0h)) + -4.0h)))) * ((half)(1.0h - _1216)))))), (half)(max(((half)(-0.0h - ((half)(_1210 * ((half)(0.25h / _1219)))))), ((half)(((half)(1.0h / ((half)(((half)(_1210 * 4.0h)) + -4.0h)))) * ((half)(1.0h - _1219)))))))))), 0.0h)))) * _132;
  half _1253 = ((half)(_1251 * 4.0h)) + 1.0h;
  half _1259 = half(f16tof32(((int)(((uint)(30605u - f32tof16(float(_1253)))) & 65535))));
  half _1262 = ((half)(2.0h - ((half)(_1253 * _1259)))) * _1259;
  half _1281 = min(((half)(_1262 * ((half)(((half)(_1251 * ((half)(((half)(((half)(_1178 + _1171)) + _1192)) + _1199)))) + (half)(half(_1181.x)))))), _163);
  half _1282 = min(((half)(_1262 * ((half)(((half)(_1251 * ((half)(((half)(((half)(_1179 + _1172)) + _1193)) + _1200)))) + (half)(half(_1181.y)))))), _163);
  half _1283 = min(((half)(_1262 * ((half)(((half)(_1251 * ((half)(((half)(((half)(_1180 + _1173)) + _1194)) + _1201)))) + (half)(half(_1181.z)))))), _163);
  if (!_168) {
    float4 _1286 = t1_space6.Load(int3(_30, _792, 0));
    if ((max(_1286.x, max(_1286.y, _1286.z)) + _1286.w) > 0.0f) {
      float _1296 = float(_1281);
      float _1297 = float(_1282);
      float _1298 = float(_1283);
      int _1299 = int(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.w);
      do {
        [branch]
        if (_1299 == 1) {
          do {
            if (_1296 < 0.040449999272823334f) {
              _1313 = (_1296 * 0.07739938050508499f);
            } else {
              _1313 = exp2(log2(abs((_1296 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
            }
            do {
              if (_1297 < 0.040449999272823334f) {
                _1325 = (_1297 * 0.07739938050508499f);
              } else {
                _1325 = exp2(log2(abs((_1297 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
              }
              do {
                if (_1298 < 0.040449999272823334f) {
                  _1337 = (_1298 * 0.07739938050508499f);
                } else {
                  _1337 = exp2(log2(abs((_1298 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
                }
                float _1338 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.x;
                _1405 = exp2(log2(abs(_1313)) * _1338);
                _1406 = exp2(log2(abs(_1325)) * _1338);
                _1407 = exp2(log2(abs(_1337)) * _1338);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (_1299 == 2) {
#if 1
            BT709FromPQ(
                _1296, _1297, _1298,
                Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.x,
                Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.y,
                _1405, _1406, _1407);
#else
            float _1363 = exp2(log2(abs(_1296)) * 0.012683313339948654f);
            float _1364 = exp2(log2(abs(_1297)) * 0.012683313339948654f);
            float _1365 = exp2(log2(abs(_1298)) * 0.012683313339948654f);
            float _1378 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.x;
            float _1391 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_112.y;
            float _1392 = _1391 * exp2(log2(abs((_1363 + -0.8359375f) / (18.8515625f - (_1363 * 18.6875f)))) * _1378);
            float _1393 = _1391 * exp2(log2(abs((_1364 + -0.8359375f) / (18.8515625f - (_1364 * 18.6875f)))) * _1378);
            float _1394 = _1391 * exp2(log2(abs((_1365 + -0.8359375f) / (18.8515625f - (_1365 * 18.6875f)))) * _1378);
            _1405 = mad(-0.07284989953041077f, _1394, mad(-0.5876410007476807f, _1393, (_1392 * 1.6604900360107422f)));
            _1406 = mad(-0.008349419571459293f, _1394, mad(1.1328999996185303f, _1393, (_1392 * -0.124549999833107f)));
            _1407 = mad(1.1187299489974976f, _1394, mad(-0.10057900100946426f, _1393, (_1392 * -0.018150800839066505f)));
#endif
          } else {
            _1405 = _1296;
            _1406 = _1297;
            _1407 = _1298;
          }
        }
        float _1408 = 1.0f - _1286.w;
        float _1412 = (_1405 * _1408) + _1286.x;
        float _1413 = (_1406 * _1408) + _1286.y;
        float _1414 = (_1407 * _1408) + _1286.z;
        int _1415 = int(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.w);
        do {
          [branch]
          if (_1415 == 1) {
            float _1427 = exp2(log2(abs(_1412)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
            float _1428 = exp2(log2(abs(_1413)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
            float _1429 = exp2(log2(abs(_1414)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
            do {
              if (_1427 < 0.003100000089034438f) {
                _1441 = (_1427 * 12.920000076293945f);
              } else {
                _1441 = ((exp2(log2(abs(_1427)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
              }
              do {
                if (_1428 < 0.003100000089034438f) {
                  _1453 = (_1428 * 12.920000076293945f);
                } else {
                  _1453 = ((exp2(log2(abs(_1428)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
                }
                if (_1429 < 0.003100000089034438f) {
                  _1519 = _1441;
                  _1520 = _1453;
                  _1521 = (_1429 * 12.920000076293945f);
                } else {
                  _1519 = _1441;
                  _1520 = _1453;
                  _1521 = ((exp2(log2(abs(_1429)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
                }
              } while (false);
            } while (false);
          } else {
            if (_1415 == 2) {
#if 1
              PQFromBT709(
                  _1412, _1413, _1414,
                  Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x,
                  Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y,
                  _1519, _1520, _1521);
#else
              float _1488 = exp2(log2(abs(mad(0.04331306740641594f, _1414, mad(0.3292830288410187f, _1413, (_1412 * 0.6274039149284363f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
              float _1489 = exp2(log2(abs(mad(0.011362316086888313f, _1414, mad(0.9195404052734375f, _1413, (_1412 * 0.06909728795289993f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
              float _1490 = exp2(log2(abs(mad(0.8955952525138855f, _1414, mad(0.08801330626010895f, _1413, (_1412 * 0.016391439363360405f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.AAResolverUpscaleParams_064.x);
              _1519 = exp2(log2(abs(((_1488 * 18.8515625f) + 0.8359375f) / ((_1488 * 18.6875f) + 1.0f))) * 78.84375f);
              _1520 = exp2(log2(abs(((_1489 * 18.8515625f) + 0.8359375f) / ((_1489 * 18.6875f) + 1.0f))) * 78.84375f);
              _1521 = exp2(log2(abs(((_1490 * 18.8515625f) + 0.8359375f) / ((_1490 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
            } else {
              _1519 = _1412;
              _1520 = _1413;
              _1521 = _1414;
            }
          }
          _1526 = (half)(half(_1519));
          _1527 = (half)(half(_1520));
          _1528 = (half)(half(_1521));
        } while (false);
      } while (false);
    } else {
      _1526 = _1281;
      _1527 = _1282;
      _1528 = _1283;
    }
  } else {
    _1526 = _1281;
    _1527 = _1282;
    _1528 = _1283;
  }
  u0_space6[int2(_30, _792)] = float4(float(_1526), float(_1527), float(_1528), 1.0f);
}
