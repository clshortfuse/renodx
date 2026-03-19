#include "../common.hlsli"

Texture2D<float4> t0_space8 : register(t0, space8);

RWTexture2D<float4> u0_space8 : register(u0, space8);

// clang-format off
cbuffer cb0_space8 : register(b0, space8) {
  struct ShaderInstance_PerInstance_Constants {
    struct InUniform_Constant {
      int4 InUniform_Constant_000;
      int4 InUniform_Constant_016;
      float4 InUniform_Constant_032;
    } ShaderInstance_PerInstance_Constants_000;
  } ShaderInstance_PerInstance_000 : packoffset(c000.x);
};
// clang-format on

[numthreads(64, 1, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  int _27 = (((uint)(SV_GroupThreadID.x) >> 1) & 7) | ((uint)((uint)(SV_GroupID.x) << 4));
  int _28 = ((((uint)(SV_GroupThreadID.x) >> 3) & 6) | ((uint)(SV_GroupThreadID.x) & 1)) | ((uint)((uint)(SV_GroupID.y) << 4));
  float _31 = asfloat(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.x);
  float _32 = asfloat(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.y);
  float _35 = asfloat(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.z);
  float _36 = asfloat(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.w);
  float _37 = (_31 * float((uint)_27)) + _35;
  float _38 = (float((uint)_28) * _32) + _36;
  float _39 = floor(_37);
  float _40 = floor(_38);
  float _41 = _37 - _39;
  float _42 = _38 - _40;
  int _43 = int(_39);
  int _44 = int(_40);
  uint _45 = _44 + -1u;
  float4 _47 = t0_space8.Load(int3(_43, _45, 0));
  uint _51 = _43 + -1u;
  float4 _52 = t0_space8.Load(int3(_51, _44, 0));
  float4 _56 = t0_space8.Load(int3(_43, _44, 0));
  uint _60 = _43 + 1u;
  float4 _61 = t0_space8.Load(int3(_60, _45, 0));
  float4 _65 = t0_space8.Load(int3(_60, _44, 0));
  uint _69 = _43 + 2u;
  float4 _70 = t0_space8.Load(int3(_69, _44, 0));
  uint _74 = _44 + 1u;
  float4 _75 = t0_space8.Load(int3(_51, _74, 0));
  float4 _79 = t0_space8.Load(int3(_43, _74, 0));
  uint _83 = _44 + 2u;
  float4 _84 = t0_space8.Load(int3(_43, _83, 0));
  float4 _88 = t0_space8.Load(int3(_60, _74, 0));
  float4 _92 = t0_space8.Load(int3(_69, _74, 0));
  float4 _96 = t0_space8.Load(int3(_60, _83, 0));
  float _103 = min(min(_47.y, min(_52.y, _56.y)), min(_65.y, _79.y));
  float _107 = max(max(_47.y, max(_52.y, _56.y)), max(_65.y, _79.y));
  float _111 = min(min(_61.y, min(_56.y, _65.y)), min(_70.y, _88.y));
  float _115 = max(max(_61.y, max(_56.y, _65.y)), max(_70.y, _88.y));
  float _119 = min(min(_56.y, min(_75.y, _79.y)), min(_88.y, _84.y));
  float _123 = max(max(_56.y, max(_75.y, _79.y)), max(_88.y, _84.y));
  float _127 = min(min(_65.y, min(_79.y, _88.y)), min(_92.y, _96.y));
  float _131 = max(max(_65.y, max(_79.y, _88.y)), max(_92.y, _96.y));
  float _176 = asfloat(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_016.x);
  float _177 = 1.0f - _41;
  float _178 = 1.0f - _42;
  float _188 = (_177 * _178) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _103) + _107))))));
  float _194 = (_178 * _41) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _111) + _115))))));
  float _200 = (_177 * _42) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _119) + _123))))));
  float _206 = (_41 * _42) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _127) + _131))))));
  float _208 = (_188 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_103, (1.0f - _107)) * asfloat(((uint)(2129690299u - (int)(asint(_107))))))))) >> 1)) + 532432441u)));
  float _210 = (_194 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_111, (1.0f - _115)) * asfloat(((uint)(2129690299u - (int)(asint(_115))))))))) >> 1)) + 532432441u)));
  float _212 = (_200 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_119, (1.0f - _123)) * asfloat(((uint)(2129690299u - (int)(asint(_123))))))))) >> 1)) + 532432441u)));
  float _213 = _212 + _210;
  float _214 = _213 + _188;
  float _216 = (_206 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_127, (1.0f - _131)) * asfloat(((uint)(2129690299u - (int)(asint(_131))))))))) >> 1)) + 532432441u)));
  float _217 = _216 + _208;
  float _218 = _217 + _194;
  float _219 = _217 + _200;
  float _220 = _213 + _206;
  float _227 = (((_219 + _218) + _214) + _220) + (((_213 + _208) + _216) * 2.0f);
  float _230 = asfloat(((uint)(2129764351u - (int)(asint(_227)))));
  float _233 = (2.0f - (_230 * _227)) * _230;
  float _254 = saturate(_233 * ((((((((_218 * _65.x) + (_208 * (_52.x + _47.x))) + (_219 * _79.x)) + (_210 * (_70.x + _61.x))) + (_214 * _56.x)) + (_220 * _88.x)) + (_212 * (_84.x + _75.x))) + (_216 * (_96.x + _92.x))));
  float _275 = saturate(_233 * ((((((((_218 * _65.y) + (_208 * (_52.y + _47.y))) + (_219 * _79.y)) + (_210 * (_70.y + _61.y))) + (_214 * _56.y)) + (_220 * _88.y)) + (_212 * (_84.y + _75.y))) + (_216 * (_96.y + _92.y))));
  float _296 = saturate(_233 * ((((((((_218 * _65.z) + (_208 * (_52.z + _47.z))) + (_219 * _79.z)) + (_210 * (_70.z + _61.z))) + (_214 * _56.z)) + (_220 * _88.z)) + (_212 * (_84.z + _75.z))) + (_216 * (_96.z + _92.z))));
  int _297 = int(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.w);
  bool _298 = (_297 == 1);
  float _323;
  float _335;
  float _401;
  float _402;
  float _403;
  float _683;
  float _695;
  float _761;
  float _762;
  float _763;
  float _1043;
  float _1055;
  float _1121;
  float _1122;
  float _1123;
  float _1392;
  float _1404;
  float _1470;
  float _1471;
  float _1472;
  [branch]
  if (_298) {
    float _309 = exp2(log2(abs(_254)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    float _310 = exp2(log2(abs(_275)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    float _311 = exp2(log2(abs(_296)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    do {
      if (_309 < 0.003100000089034438f) {
        _323 = (_309 * 12.920000076293945f);
      } else {
        _323 = ((exp2(log2(abs(_309)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      do {
        if (_310 < 0.003100000089034438f) {
          _335 = (_310 * 12.920000076293945f);
        } else {
          _335 = ((exp2(log2(abs(_310)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        if (_311 < 0.003100000089034438f) {
          _401 = _323;
          _402 = _335;
          _403 = (_311 * 12.920000076293945f);
        } else {
          _401 = _323;
          _402 = _335;
          _403 = ((exp2(log2(abs(_311)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
        }
      } while (false);
    } while (false);
  } else {
    if (_297 == 2) {
#if 1
      PQFromBT709(
          _254, _275, _296,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y,
          _401, _402, _403);
#else
      float _370 = exp2(log2(abs(mad(0.04331306740641594f, _296, mad(0.3292830288410187f, _275, (_254 * 0.6274039149284363f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      float _371 = exp2(log2(abs(mad(0.011362316086888313f, _296, mad(0.9195404052734375f, _275, (_254 * 0.06909728795289993f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      float _372 = exp2(log2(abs(mad(0.8955952525138855f, _296, mad(0.08801330626010895f, _275, (_254 * 0.016391439363360405f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      _401 = exp2(log2(abs(((_370 * 18.8515625f) + 0.8359375f) / ((_370 * 18.6875f) + 1.0f))) * 78.84375f);
      _402 = exp2(log2(abs(((_371 * 18.8515625f) + 0.8359375f) / ((_371 * 18.6875f) + 1.0f))) * 78.84375f);
      _403 = exp2(log2(abs(((_372 * 18.8515625f) + 0.8359375f) / ((_372 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      _401 = _254;
      _402 = _275;
      _403 = _296;
    }
  }
  u0_space8[int2(_27, _28)] = float4(_401, _402, _403, 1.0f);
  int _405 = _27 | 8;
  float _408 = (float((uint)_405) * _31) + _35;
  float _409 = floor(_408);
  float _410 = _408 - _409;
  int _411 = int(_409);
  float4 _413 = t0_space8.Load(int3(_411, _45, 0));
  uint _417 = _411 + -1u;
  float4 _418 = t0_space8.Load(int3(_417, _44, 0));
  float4 _422 = t0_space8.Load(int3(_411, _44, 0));
  uint _426 = _411 + 1u;
  float4 _427 = t0_space8.Load(int3(_426, _45, 0));
  float4 _431 = t0_space8.Load(int3(_426, _44, 0));
  uint _435 = _411 + 2u;
  float4 _436 = t0_space8.Load(int3(_435, _44, 0));
  float4 _440 = t0_space8.Load(int3(_417, _74, 0));
  float4 _444 = t0_space8.Load(int3(_411, _74, 0));
  float4 _448 = t0_space8.Load(int3(_411, _83, 0));
  float4 _452 = t0_space8.Load(int3(_426, _74, 0));
  float4 _456 = t0_space8.Load(int3(_435, _74, 0));
  float4 _460 = t0_space8.Load(int3(_426, _83, 0));
  float _467 = min(min(_413.y, min(_418.y, _422.y)), min(_431.y, _444.y));
  float _471 = max(max(_413.y, max(_418.y, _422.y)), max(_431.y, _444.y));
  float _475 = min(min(_427.y, min(_422.y, _431.y)), min(_436.y, _452.y));
  float _479 = max(max(_427.y, max(_422.y, _431.y)), max(_436.y, _452.y));
  float _483 = min(min(_422.y, min(_440.y, _444.y)), min(_452.y, _448.y));
  float _487 = max(max(_422.y, max(_440.y, _444.y)), max(_452.y, _448.y));
  float _491 = min(min(_431.y, min(_444.y, _452.y)), min(_456.y, _460.y));
  float _495 = max(max(_431.y, max(_444.y, _452.y)), max(_456.y, _460.y));
  float _540 = 1.0f - _410;
  float _550 = (_540 * _178) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _467) + _471))))));
  float _556 = (_410 * _178) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _475) + _479))))));
  float _562 = (_540 * _42) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _483) + _487))))));
  float _568 = (_410 * _42) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _491) + _495))))));
  float _570 = (_550 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_467, (1.0f - _471)) * asfloat(((uint)(2129690299u - (int)(asint(_471))))))))) >> 1)) + 532432441u)));
  float _572 = (_556 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_475, (1.0f - _479)) * asfloat(((uint)(2129690299u - (int)(asint(_479))))))))) >> 1)) + 532432441u)));
  float _574 = (_562 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_483, (1.0f - _487)) * asfloat(((uint)(2129690299u - (int)(asint(_487))))))))) >> 1)) + 532432441u)));
  float _575 = _574 + _572;
  float _576 = _575 + _550;
  float _578 = (_568 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_491, (1.0f - _495)) * asfloat(((uint)(2129690299u - (int)(asint(_495))))))))) >> 1)) + 532432441u)));
  float _579 = _578 + _570;
  float _580 = _579 + _556;
  float _581 = _579 + _562;
  float _582 = _575 + _568;
  float _589 = (((_581 + _580) + _576) + _582) + (((_575 + _570) + _578) * 2.0f);
  float _592 = asfloat(((uint)(2129764351u - (int)(asint(_589)))));
  float _595 = (2.0f - (_592 * _589)) * _592;
  float _616 = saturate(_595 * ((((((((_580 * _431.x) + (_570 * (_418.x + _413.x))) + (_581 * _444.x)) + (_572 * (_436.x + _427.x))) + (_576 * _422.x)) + (_582 * _452.x)) + (_574 * (_448.x + _440.x))) + (_578 * (_460.x + _456.x))));
  float _637 = saturate(_595 * ((((((((_580 * _431.y) + (_570 * (_418.y + _413.y))) + (_581 * _444.y)) + (_572 * (_436.y + _427.y))) + (_576 * _422.y)) + (_582 * _452.y)) + (_574 * (_448.y + _440.y))) + (_578 * (_460.y + _456.y))));
  float _658 = saturate(_595 * ((((((((_580 * _431.z) + (_570 * (_418.z + _413.z))) + (_581 * _444.z)) + (_572 * (_436.z + _427.z))) + (_576 * _422.z)) + (_582 * _452.z)) + (_574 * (_448.z + _440.z))) + (_578 * (_460.z + _456.z))));
  [branch]
  if (_298) {
    float _669 = exp2(log2(abs(_616)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    float _670 = exp2(log2(abs(_637)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    float _671 = exp2(log2(abs(_658)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    do {
      if (_669 < 0.003100000089034438f) {
        _683 = (_669 * 12.920000076293945f);
      } else {
        _683 = ((exp2(log2(abs(_669)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      do {
        if (_670 < 0.003100000089034438f) {
          _695 = (_670 * 12.920000076293945f);
        } else {
          _695 = ((exp2(log2(abs(_670)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        if (_671 < 0.003100000089034438f) {
          _761 = _683;
          _762 = _695;
          _763 = (_671 * 12.920000076293945f);
        } else {
          _761 = _683;
          _762 = _695;
          _763 = ((exp2(log2(abs(_671)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
        }
      } while (false);
    } while (false);
  } else {
    if (_297 == 2) {
#if 1
      PQFromBT709(
          _616, _637, _658,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y,
          _761, _762, _763);
#else
      float _730 = exp2(log2(abs(mad(0.04331306740641594f, _658, mad(0.3292830288410187f, _637, (_616 * 0.6274039149284363f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      float _731 = exp2(log2(abs(mad(0.011362316086888313f, _658, mad(0.9195404052734375f, _637, (_616 * 0.06909728795289993f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      float _732 = exp2(log2(abs(mad(0.8955952525138855f, _658, mad(0.08801330626010895f, _637, (_616 * 0.016391439363360405f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      _761 = exp2(log2(abs(((_730 * 18.8515625f) + 0.8359375f) / ((_730 * 18.6875f) + 1.0f))) * 78.84375f);
      _762 = exp2(log2(abs(((_731 * 18.8515625f) + 0.8359375f) / ((_731 * 18.6875f) + 1.0f))) * 78.84375f);
      _763 = exp2(log2(abs(((_732 * 18.8515625f) + 0.8359375f) / ((_732 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      _761 = _616;
      _762 = _637;
      _763 = _658;
    }
  }
  u0_space8[int2(_405, _28)] = float4(_761, _762, _763, 1.0f);
  int _765 = _28 | 8;
  float _768 = (float((uint)_765) * _32) + _36;
  float _769 = floor(_768);
  float _770 = _768 - _769;
  int _771 = int(_769);
  uint _772 = _771 + -1u;
  float4 _774 = t0_space8.Load(int3(_411, _772, 0));
  float4 _778 = t0_space8.Load(int3(_417, _771, 0));
  float4 _782 = t0_space8.Load(int3(_411, _771, 0));
  float4 _786 = t0_space8.Load(int3(_426, _772, 0));
  float4 _790 = t0_space8.Load(int3(_426, _771, 0));
  float4 _794 = t0_space8.Load(int3(_435, _771, 0));
  uint _798 = _771 + 1u;
  float4 _799 = t0_space8.Load(int3(_417, _798, 0));
  float4 _803 = t0_space8.Load(int3(_411, _798, 0));
  uint _807 = _771 + 2u;
  float4 _808 = t0_space8.Load(int3(_411, _807, 0));
  float4 _812 = t0_space8.Load(int3(_426, _798, 0));
  float4 _816 = t0_space8.Load(int3(_435, _798, 0));
  float4 _820 = t0_space8.Load(int3(_426, _807, 0));
  float _827 = min(min(_774.y, min(_778.y, _782.y)), min(_790.y, _803.y));
  float _831 = max(max(_774.y, max(_778.y, _782.y)), max(_790.y, _803.y));
  float _835 = min(min(_786.y, min(_782.y, _790.y)), min(_794.y, _812.y));
  float _839 = max(max(_786.y, max(_782.y, _790.y)), max(_794.y, _812.y));
  float _843 = min(min(_782.y, min(_799.y, _803.y)), min(_812.y, _808.y));
  float _847 = max(max(_782.y, max(_799.y, _803.y)), max(_812.y, _808.y));
  float _851 = min(min(_790.y, min(_803.y, _812.y)), min(_816.y, _820.y));
  float _855 = max(max(_790.y, max(_803.y, _812.y)), max(_816.y, _820.y));
  float _900 = 1.0f - _770;
  float _910 = (_900 * _540) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _827) + _831))))));
  float _916 = (_900 * _410) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _835) + _839))))));
  float _922 = (_770 * _540) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _843) + _847))))));
  float _928 = (_770 * _410) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _851) + _855))))));
  float _930 = (_910 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_827, (1.0f - _831)) * asfloat(((uint)(2129690299u - (int)(asint(_831))))))))) >> 1)) + 532432441u)));
  float _932 = (_916 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_835, (1.0f - _839)) * asfloat(((uint)(2129690299u - (int)(asint(_839))))))))) >> 1)) + 532432441u)));
  float _934 = (_922 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_843, (1.0f - _847)) * asfloat(((uint)(2129690299u - (int)(asint(_847))))))))) >> 1)) + 532432441u)));
  float _935 = _934 + _932;
  float _936 = _935 + _910;
  float _938 = (_928 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_851, (1.0f - _855)) * asfloat(((uint)(2129690299u - (int)(asint(_855))))))))) >> 1)) + 532432441u)));
  float _939 = _938 + _930;
  float _940 = _939 + _916;
  float _941 = _939 + _922;
  float _942 = _935 + _928;
  float _949 = (((_941 + _940) + _936) + _942) + (((_935 + _930) + _938) * 2.0f);
  float _952 = asfloat(((uint)(2129764351u - (int)(asint(_949)))));
  float _955 = (2.0f - (_952 * _949)) * _952;
  float _976 = saturate(_955 * ((((((((_940 * _790.x) + (_930 * (_778.x + _774.x))) + (_941 * _803.x)) + (_932 * (_794.x + _786.x))) + (_936 * _782.x)) + (_942 * _812.x)) + (_934 * (_808.x + _799.x))) + (_938 * (_820.x + _816.x))));
  float _997 = saturate(_955 * ((((((((_940 * _790.y) + (_930 * (_778.y + _774.y))) + (_941 * _803.y)) + (_932 * (_794.y + _786.y))) + (_936 * _782.y)) + (_942 * _812.y)) + (_934 * (_808.y + _799.y))) + (_938 * (_820.y + _816.y))));
  float _1018 = saturate(_955 * ((((((((_940 * _790.z) + (_930 * (_778.z + _774.z))) + (_941 * _803.z)) + (_932 * (_794.z + _786.z))) + (_936 * _782.z)) + (_942 * _812.z)) + (_934 * (_808.z + _799.z))) + (_938 * (_820.z + _816.z))));
  [branch]
  if (_298) {
    float _1029 = exp2(log2(abs(_976)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    float _1030 = exp2(log2(abs(_997)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    float _1031 = exp2(log2(abs(_1018)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    do {
      if (_1029 < 0.003100000089034438f) {
        _1043 = (_1029 * 12.920000076293945f);
      } else {
        _1043 = ((exp2(log2(abs(_1029)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      do {
        if (_1030 < 0.003100000089034438f) {
          _1055 = (_1030 * 12.920000076293945f);
        } else {
          _1055 = ((exp2(log2(abs(_1030)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        if (_1031 < 0.003100000089034438f) {
          _1121 = _1043;
          _1122 = _1055;
          _1123 = (_1031 * 12.920000076293945f);
        } else {
          _1121 = _1043;
          _1122 = _1055;
          _1123 = ((exp2(log2(abs(_1031)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
        }
      } while (false);
    } while (false);
  } else {
    if (_297 == 2) {
#if 1
      PQFromBT709(
          _976, _997, _1018,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y,
          _1121, _1122, _1123);
#else
      float _1090 = exp2(log2(abs(mad(0.04331306740641594f, _1018, mad(0.3292830288410187f, _997, (_976 * 0.6274039149284363f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      float _1091 = exp2(log2(abs(mad(0.011362316086888313f, _1018, mad(0.9195404052734375f, _997, (_976 * 0.06909728795289993f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      float _1092 = exp2(log2(abs(mad(0.8955952525138855f, _1018, mad(0.08801330626010895f, _997, (_976 * 0.016391439363360405f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      _1121 = exp2(log2(abs(((_1090 * 18.8515625f) + 0.8359375f) / ((_1090 * 18.6875f) + 1.0f))) * 78.84375f);
      _1122 = exp2(log2(abs(((_1091 * 18.8515625f) + 0.8359375f) / ((_1091 * 18.6875f) + 1.0f))) * 78.84375f);
      _1123 = exp2(log2(abs(((_1092 * 18.8515625f) + 0.8359375f) / ((_1092 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      _1121 = _976;
      _1122 = _997;
      _1123 = _1018;
    }
  }
  u0_space8[int2(_405, _765)] = float4(_1121, _1122, _1123, 1.0f);
  float4 _1126 = t0_space8.Load(int3(_43, _772, 0));
  float4 _1130 = t0_space8.Load(int3(_51, _771, 0));
  float4 _1134 = t0_space8.Load(int3(_43, _771, 0));
  float4 _1138 = t0_space8.Load(int3(_60, _772, 0));
  float4 _1142 = t0_space8.Load(int3(_60, _771, 0));
  float4 _1146 = t0_space8.Load(int3(_69, _771, 0));
  float4 _1150 = t0_space8.Load(int3(_51, _798, 0));
  float4 _1154 = t0_space8.Load(int3(_43, _798, 0));
  float4 _1158 = t0_space8.Load(int3(_43, _807, 0));
  float4 _1162 = t0_space8.Load(int3(_60, _798, 0));
  float4 _1166 = t0_space8.Load(int3(_69, _798, 0));
  float4 _1170 = t0_space8.Load(int3(_60, _807, 0));
  float _1177 = min(min(_1126.y, min(_1130.y, _1134.y)), min(_1142.y, _1154.y));
  float _1181 = max(max(_1126.y, max(_1130.y, _1134.y)), max(_1142.y, _1154.y));
  float _1185 = min(min(_1138.y, min(_1134.y, _1142.y)), min(_1146.y, _1162.y));
  float _1189 = max(max(_1138.y, max(_1134.y, _1142.y)), max(_1146.y, _1162.y));
  float _1193 = min(min(_1134.y, min(_1150.y, _1154.y)), min(_1162.y, _1158.y));
  float _1197 = max(max(_1134.y, max(_1150.y, _1154.y)), max(_1162.y, _1158.y));
  float _1201 = min(min(_1142.y, min(_1154.y, _1162.y)), min(_1166.y, _1170.y));
  float _1205 = max(max(_1142.y, max(_1154.y, _1162.y)), max(_1166.y, _1170.y));
  float _1259 = (_900 * _177) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _1177) + _1181))))));
  float _1265 = (_900 * _41) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _1185) + _1189))))));
  float _1271 = (_770 * _177) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _1193) + _1197))))));
  float _1277 = (_770 * _41) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _1201) + _1205))))));
  float _1279 = (_1259 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_1177, (1.0f - _1181)) * asfloat(((uint)(2129690299u - (int)(asint(_1181))))))))) >> 1)) + 532432441u)));
  float _1281 = (_1265 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_1185, (1.0f - _1189)) * asfloat(((uint)(2129690299u - (int)(asint(_1189))))))))) >> 1)) + 532432441u)));
  float _1283 = (_1271 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_1193, (1.0f - _1197)) * asfloat(((uint)(2129690299u - (int)(asint(_1197))))))))) >> 1)) + 532432441u)));
  float _1284 = _1283 + _1281;
  float _1285 = _1284 + _1259;
  float _1287 = (_1277 * _176) * asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_1201, (1.0f - _1205)) * asfloat(((uint)(2129690299u - (int)(asint(_1205))))))))) >> 1)) + 532432441u)));
  float _1288 = _1287 + _1279;
  float _1289 = _1288 + _1265;
  float _1290 = _1288 + _1271;
  float _1291 = _1284 + _1277;
  float _1298 = (((_1290 + _1289) + _1285) + _1291) + (((_1284 + _1279) + _1287) * 2.0f);
  float _1301 = asfloat(((uint)(2129764351u - (int)(asint(_1298)))));
  float _1304 = (2.0f - (_1301 * _1298)) * _1301;
  float _1325 = saturate(_1304 * ((((((((_1289 * _1142.x) + (_1279 * (_1130.x + _1126.x))) + (_1290 * _1154.x)) + (_1281 * (_1146.x + _1138.x))) + (_1285 * _1134.x)) + (_1291 * _1162.x)) + (_1283 * (_1158.x + _1150.x))) + (_1287 * (_1170.x + _1166.x))));
  float _1346 = saturate(_1304 * ((((((((_1289 * _1142.y) + (_1279 * (_1130.y + _1126.y))) + (_1290 * _1154.y)) + (_1281 * (_1146.y + _1138.y))) + (_1285 * _1134.y)) + (_1291 * _1162.y)) + (_1283 * (_1158.y + _1150.y))) + (_1287 * (_1170.y + _1166.y))));
  float _1367 = saturate(_1304 * ((((((((_1289 * _1142.z) + (_1279 * (_1130.z + _1126.z))) + (_1290 * _1154.z)) + (_1281 * (_1146.z + _1138.z))) + (_1285 * _1134.z)) + (_1291 * _1162.z)) + (_1283 * (_1158.z + _1150.z))) + (_1287 * (_1170.z + _1166.z))));
  [branch]
  if (_298) {
    float _1378 = exp2(log2(abs(_1325)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    float _1379 = exp2(log2(abs(_1346)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    float _1380 = exp2(log2(abs(_1367)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    do {
      if (_1378 < 0.003100000089034438f) {
        _1392 = (_1378 * 12.920000076293945f);
      } else {
        _1392 = ((exp2(log2(abs(_1378)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      do {
        if (_1379 < 0.003100000089034438f) {
          _1404 = (_1379 * 12.920000076293945f);
        } else {
          _1404 = ((exp2(log2(abs(_1379)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        if (_1380 < 0.003100000089034438f) {
          _1470 = _1392;
          _1471 = _1404;
          _1472 = (_1380 * 12.920000076293945f);
        } else {
          _1470 = _1392;
          _1471 = _1404;
          _1472 = ((exp2(log2(abs(_1380)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
        }
      } while (false);
    } while (false);
  } else {
    if (_297 == 2) {
#if 1
      PQFromBT709(
          _1325, _1346, _1367,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y,
          _1470, _1471, _1472);
#else
      float _1439 = exp2(log2(abs(mad(0.04331306740641594f, _1367, mad(0.3292830288410187f, _1346, (_1325 * 0.6274039149284363f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      float _1440 = exp2(log2(abs(mad(0.011362316086888313f, _1367, mad(0.9195404052734375f, _1346, (_1325 * 0.06909728795289993f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      float _1441 = exp2(log2(abs(mad(0.8955952525138855f, _1367, mad(0.08801330626010895f, _1346, (_1325 * 0.016391439363360405f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      _1470 = exp2(log2(abs(((_1439 * 18.8515625f) + 0.8359375f) / ((_1439 * 18.6875f) + 1.0f))) * 78.84375f);
      _1471 = exp2(log2(abs(((_1440 * 18.8515625f) + 0.8359375f) / ((_1440 * 18.6875f) + 1.0f))) * 78.84375f);
      _1472 = exp2(log2(abs(((_1441 * 18.8515625f) + 0.8359375f) / ((_1441 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      _1470 = _1325;
      _1471 = _1346;
      _1472 = _1367;
    }
  }
  u0_space8[int2(_27, _765)] = float4(_1470, _1471, _1472, 1.0f);
}
