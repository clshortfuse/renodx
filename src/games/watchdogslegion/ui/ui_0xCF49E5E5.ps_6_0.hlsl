#include "UI.hlsli"

struct SCameraDistances {
  float SCameraDistances_000;
  float SCameraDistances_004;
  float SCameraDistances_008;
  float SCameraDistances_012;
};

struct SLCMFrustumPlanes {
  float4 SLCMFrustumPlanes_000[6];
};


Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float cb0_836w : packoffset(c836.w);
};

cbuffer cb1 : register(b1) {
  float4 HDROutput_000 : packoffset(c000.x);
  float4 HDROutput_016 : packoffset(c001.x);
  float HDROutput_032 : packoffset(c002.x);
  float HDROutput_036 : packoffset(c002.y);
  float HDROutput_040 : packoffset(c002.z);
  float HDROutput_044 : packoffset(c002.w);
  float HDROutput_048 : packoffset(c003.x);
  float HDROutput_052 : packoffset(c003.y);
  float HDROutput_056 : packoffset(c003.z);
  float HDROutput_060 : packoffset(c003.w);
  float HDROutput_064 : packoffset(c004.x);
  float HDROutput_068 : packoffset(c004.y);
  float HDROutput_072 : packoffset(c004.z);
  float HDROutput_076 : packoffset(c004.w);
  float HDROutput_080 : packoffset(c005.x);
  float HDROutput_084 : packoffset(c005.y);
};

cbuffer cb2 : register(b2) {
  float4 FireUiPrimitive_000 : packoffset(c000.x);
  float4 FireUiPrimitive_016 : packoffset(c001.x);
  float4 FireUiPrimitive_032 : packoffset(c002.x);
  float4 FireUiPrimitive_048[4] : packoffset(c003.x);
  float4 FireUiPrimitive_112 : packoffset(c007.x);
  float4 FireUiPrimitive_128[4] : packoffset(c008.x);
  float4 FireUiPrimitive_192[8] : packoffset(c012.x);
  float3 FireUiPrimitive_320 : packoffset(c020.x);
  float FireUiPrimitive_332 : packoffset(c020.w);
  float2 FireUiPrimitive_336 : packoffset(c021.x);
  float FireUiPrimitive_344 : packoffset(c021.z);
  float FireUiPrimitive_348 : packoffset(c021.w);
  float2 FireUiPrimitive_352 : packoffset(c022.x);
  float FireUiPrimitive_360 : packoffset(c022.z);
  float FireUiPrimitive_364 : packoffset(c022.w);
  float FireUiPrimitive_368 : packoffset(c023.x);
  float FireUiPrimitive_372 : packoffset(c023.y);
  float FireUiPrimitive_376 : packoffset(c023.z);
  float FireUiPrimitive_380 : packoffset(c023.w);
  float FireUiPrimitive_384 : packoffset(c024.x);
  int FireUiPrimitive_388 : packoffset(c024.y);
  int FireUiPrimitive_392 : packoffset(c024.z);
  int FireUiPrimitive_396 : packoffset(c024.w);
};

SamplerState s0 : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float4 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _17;
  float _19;
  float _47;
  float _48;
  float _49;
  float _50;
  float _63;
  float _64;
  float _65;
  float _66;
  float _136;
  float _137;
  float _138;
  float _139;
  float _140;
  float _141;
  float _142;
  float _143;
  float _144;
  float _145;
  float _146;
  float _147;
  float _148;
  float _149;
  float _150;
  float _243;
  float _244;
  float _245;
  float _400;
  float _401;
  float _402;
  float _86;
  float _87;
  float _88;
  float _102;
  float _103;
  float _104;
  float _105;
  float _106;
  float _107;
  float _153;
  float _156;
  float _159;
  float _162;
  float _165;
  float _168;
  float _178;
  float _180;
  float _183;
  float _198;
  bool _205;
  float _279;
  float _280;
  float _281;
  float _282;
  float _290;
  float _291;
  float _295;
  float _296;
  float _297;
  float _313;
  float _320;
  float _327;
  float _336;
  float _340;
  float _349;
  float _353;
  float _362;
  float _371;
  float _372;
  float _373;
  float _374;
  _17 = select((FireUiPrimitive_396 != 0), 1.0f, (((float4)(t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y)))).y));
  _19 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _47 = FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _19)) + _19) * cb0_836w), 0.0f), 64512.0f);
  _48 = FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _19)) + _19) * cb0_836w), 0.0f), 64512.0f);
  _49 = FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _19)) + _19) * cb0_836w), 0.0f), 64512.0f);
  _50 = (_17 * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w;
  if (_17 > 0.0f) {
    _63 = (FireUiPrimitive_000.x + _47);
    _64 = (FireUiPrimitive_000.y + _48);
    _65 = (FireUiPrimitive_000.z + _49);
    _66 = (FireUiPrimitive_000.w + _50);
  } else {
    _63 = _47;
    _64 = _48;
    _65 = _49;
    _66 = _50;
  }
  _86 = (exp2(log2(abs(_63)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _87 = (exp2(log2(abs(_64)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _88 = (exp2(log2(abs(_65)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!((((_86 < 9.999999747378752e-05f) && (_87 < 9.999999747378752e-05f)) && (_88 < 9.999999747378752e-05f)) || ((uint)((int)((uint)(FireUiPrimitive_388) + (uint)(-1))) > (uint)7))) {
    switch ((int)(FireUiPrimitive_388)) {
      case 1: {
        _102 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _103 = 1.0f - _102;
        _104 = _102 * 2.023439884185791f;
        _105 = _102 * -2.5258100032806396f;
        _106 = _102 * 0.4941999912261963f;
        _107 = _102 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_86 > 0.5f) && ((_88 + _87) < 0.5f)) {
              _136 = min(max((_87 + 0.20000000298023224f), 0.0f), 1.0f);
              _137 = min(max((_88 + 0.20000000298023224f), 0.0f), 1.0f);
              _138 = 0.0f;
              _139 = 1.0f;
              _140 = 0.0f;
              _141 = 1.0f;
              _142 = _103;
              _143 = 0.0f;
              _144 = 0.0f;
              _145 = _104;
              _146 = 1.0f;
              _147 = 0.0f;
              _148 = _105;
              _149 = 0.0f;
              _150 = 1.0f;
            } else {
              _136 = _87;
              _137 = _88;
              _138 = 0.0f;
              _139 = 1.0f;
              _140 = 0.0f;
              _141 = 1.0f;
              _142 = _103;
              _143 = 0.0f;
              _144 = 0.0f;
              _145 = _104;
              _146 = 1.0f;
              _147 = 0.0f;
              _148 = _105;
              _149 = 0.0f;
              _150 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_86 > (_87 * 2.0f)) && ((_87 + _86) > _88)) {
                _136 = _87;
                _137 = min(max((_88 + 0.30000001192092896f), 0.0f), 1.0f);
                _138 = 0.0f;
                _139 = 1.0f;
                _140 = 0.0f;
                _141 = 1.0f;
                _142 = 1.0f;
                _143 = _106;
                _144 = 0.0f;
                _145 = 0.0f;
                _146 = _103;
                _147 = 0.0f;
                _148 = 0.0f;
                _149 = _107;
                _150 = 1.0f;
              } else {
                _136 = _87;
                _137 = _88;
                _138 = 0.0f;
                _139 = 1.0f;
                _140 = 0.0f;
                _141 = 1.0f;
                _142 = 1.0f;
                _143 = _106;
                _144 = 0.0f;
                _145 = 0.0f;
                _146 = _103;
                _147 = 0.0f;
                _148 = 0.0f;
                _149 = _107;
                _150 = 1.0f;
              }
            } else {
              _136 = _87;
              _137 = _88;
              _138 = 1.0f;
              _139 = 0.699999988079071f;
              _140 = 0.699999988079071f;
              _141 = 0.0f;
              _142 = 1.0f;
              _143 = 0.0f;
              _144 = (_102 * -0.012245000340044498f);
              _145 = 0.0f;
              _146 = 1.0f;
              _147 = (_102 * 0.07203499972820282f);
              _148 = 0.0f;
              _149 = 0.0f;
              _150 = _103;
            }
          }
          _153 = mad(4.11929988861084f, _88, mad(43.5161018371582f, _87, (_86 * 17.882400512695312f)));
          _156 = mad(3.8671000003814697f, _88, mad(27.155399322509766f, _87, (_86 * 3.455699920654297f)));
          _159 = mad(1.4670000076293945f, _88, mad(0.18431000411510468f, _87, (_86 * 0.02996000088751316f)));
          _162 = mad(_148, _159, mad(_145, _156, (_153 * _142)));
          _165 = mad(_149, _159, mad(_146, _156, (_153 * _143)));
          _168 = mad(_150, _159, mad(_147, _156, (_153 * _144)));
          _178 = _86 - mad(0.11670000106096268f, _168, mad(-0.13050000369548798f, _165, (_162 * 0.08089999854564667f)));
          _180 = _88 - mad(0.6934999823570251f, _168, mad(-0.004100000020116568f, _165, (_162 * -0.0003000000142492354f)));
          _183 = _178 * 0.699999988079071f;
          _243 = (mad(_140, _180, (_178 * _138)) + _86);
          _244 = (mad(_139, (_87 - mad(-0.1136000007390976f, _168, mad(0.05400000140070915f, _165, (_162 * -0.010200000368058681f)))), _183) + _136);
          _245 = (mad(_141, _180, _183) + _137);
        } while (false);
        break;
      }
      case 2: {
        _102 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _103 = 1.0f - _102;
        _104 = _102 * 2.023439884185791f;
        _105 = _102 * -2.5258100032806396f;
        _106 = _102 * 0.4941999912261963f;
        _107 = _102 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_86 > 0.5f) && ((_88 + _87) < 0.5f)) {
              _136 = min(max((_87 + 0.20000000298023224f), 0.0f), 1.0f);
              _137 = min(max((_88 + 0.20000000298023224f), 0.0f), 1.0f);
              _138 = 0.0f;
              _139 = 1.0f;
              _140 = 0.0f;
              _141 = 1.0f;
              _142 = _103;
              _143 = 0.0f;
              _144 = 0.0f;
              _145 = _104;
              _146 = 1.0f;
              _147 = 0.0f;
              _148 = _105;
              _149 = 0.0f;
              _150 = 1.0f;
            } else {
              _136 = _87;
              _137 = _88;
              _138 = 0.0f;
              _139 = 1.0f;
              _140 = 0.0f;
              _141 = 1.0f;
              _142 = _103;
              _143 = 0.0f;
              _144 = 0.0f;
              _145 = _104;
              _146 = 1.0f;
              _147 = 0.0f;
              _148 = _105;
              _149 = 0.0f;
              _150 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_86 > (_87 * 2.0f)) && ((_87 + _86) > _88)) {
                _136 = _87;
                _137 = min(max((_88 + 0.30000001192092896f), 0.0f), 1.0f);
                _138 = 0.0f;
                _139 = 1.0f;
                _140 = 0.0f;
                _141 = 1.0f;
                _142 = 1.0f;
                _143 = _106;
                _144 = 0.0f;
                _145 = 0.0f;
                _146 = _103;
                _147 = 0.0f;
                _148 = 0.0f;
                _149 = _107;
                _150 = 1.0f;
              } else {
                _136 = _87;
                _137 = _88;
                _138 = 0.0f;
                _139 = 1.0f;
                _140 = 0.0f;
                _141 = 1.0f;
                _142 = 1.0f;
                _143 = _106;
                _144 = 0.0f;
                _145 = 0.0f;
                _146 = _103;
                _147 = 0.0f;
                _148 = 0.0f;
                _149 = _107;
                _150 = 1.0f;
              }
            } else {
              _136 = _87;
              _137 = _88;
              _138 = 1.0f;
              _139 = 0.699999988079071f;
              _140 = 0.699999988079071f;
              _141 = 0.0f;
              _142 = 1.0f;
              _143 = 0.0f;
              _144 = (_102 * -0.012245000340044498f);
              _145 = 0.0f;
              _146 = 1.0f;
              _147 = (_102 * 0.07203499972820282f);
              _148 = 0.0f;
              _149 = 0.0f;
              _150 = _103;
            }
          }
          _153 = mad(4.11929988861084f, _88, mad(43.5161018371582f, _87, (_86 * 17.882400512695312f)));
          _156 = mad(3.8671000003814697f, _88, mad(27.155399322509766f, _87, (_86 * 3.455699920654297f)));
          _159 = mad(1.4670000076293945f, _88, mad(0.18431000411510468f, _87, (_86 * 0.02996000088751316f)));
          _162 = mad(_148, _159, mad(_145, _156, (_153 * _142)));
          _165 = mad(_149, _159, mad(_146, _156, (_153 * _143)));
          _168 = mad(_150, _159, mad(_147, _156, (_153 * _144)));
          _178 = _86 - mad(0.11670000106096268f, _168, mad(-0.13050000369548798f, _165, (_162 * 0.08089999854564667f)));
          _180 = _88 - mad(0.6934999823570251f, _168, mad(-0.004100000020116568f, _165, (_162 * -0.0003000000142492354f)));
          _183 = _178 * 0.699999988079071f;
          _243 = (mad(_140, _180, (_178 * _138)) + _86);
          _244 = (mad(_139, (_87 - mad(-0.1136000007390976f, _168, mad(0.05400000140070915f, _165, (_162 * -0.010200000368058681f)))), _183) + _136);
          _245 = (mad(_141, _180, _183) + _137);
        } while (false);
        break;
      }
      case 3: {
        _102 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _103 = 1.0f - _102;
        _104 = _102 * 2.023439884185791f;
        _105 = _102 * -2.5258100032806396f;
        _106 = _102 * 0.4941999912261963f;
        _107 = _102 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_86 > 0.5f) && ((_88 + _87) < 0.5f)) {
              _136 = min(max((_87 + 0.20000000298023224f), 0.0f), 1.0f);
              _137 = min(max((_88 + 0.20000000298023224f), 0.0f), 1.0f);
              _138 = 0.0f;
              _139 = 1.0f;
              _140 = 0.0f;
              _141 = 1.0f;
              _142 = _103;
              _143 = 0.0f;
              _144 = 0.0f;
              _145 = _104;
              _146 = 1.0f;
              _147 = 0.0f;
              _148 = _105;
              _149 = 0.0f;
              _150 = 1.0f;
            } else {
              _136 = _87;
              _137 = _88;
              _138 = 0.0f;
              _139 = 1.0f;
              _140 = 0.0f;
              _141 = 1.0f;
              _142 = _103;
              _143 = 0.0f;
              _144 = 0.0f;
              _145 = _104;
              _146 = 1.0f;
              _147 = 0.0f;
              _148 = _105;
              _149 = 0.0f;
              _150 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_86 > (_87 * 2.0f)) && ((_87 + _86) > _88)) {
                _136 = _87;
                _137 = min(max((_88 + 0.30000001192092896f), 0.0f), 1.0f);
                _138 = 0.0f;
                _139 = 1.0f;
                _140 = 0.0f;
                _141 = 1.0f;
                _142 = 1.0f;
                _143 = _106;
                _144 = 0.0f;
                _145 = 0.0f;
                _146 = _103;
                _147 = 0.0f;
                _148 = 0.0f;
                _149 = _107;
                _150 = 1.0f;
              } else {
                _136 = _87;
                _137 = _88;
                _138 = 0.0f;
                _139 = 1.0f;
                _140 = 0.0f;
                _141 = 1.0f;
                _142 = 1.0f;
                _143 = _106;
                _144 = 0.0f;
                _145 = 0.0f;
                _146 = _103;
                _147 = 0.0f;
                _148 = 0.0f;
                _149 = _107;
                _150 = 1.0f;
              }
            } else {
              _136 = _87;
              _137 = _88;
              _138 = 1.0f;
              _139 = 0.699999988079071f;
              _140 = 0.699999988079071f;
              _141 = 0.0f;
              _142 = 1.0f;
              _143 = 0.0f;
              _144 = (_102 * -0.012245000340044498f);
              _145 = 0.0f;
              _146 = 1.0f;
              _147 = (_102 * 0.07203499972820282f);
              _148 = 0.0f;
              _149 = 0.0f;
              _150 = _103;
            }
          }
          _153 = mad(4.11929988861084f, _88, mad(43.5161018371582f, _87, (_86 * 17.882400512695312f)));
          _156 = mad(3.8671000003814697f, _88, mad(27.155399322509766f, _87, (_86 * 3.455699920654297f)));
          _159 = mad(1.4670000076293945f, _88, mad(0.18431000411510468f, _87, (_86 * 0.02996000088751316f)));
          _162 = mad(_148, _159, mad(_145, _156, (_153 * _142)));
          _165 = mad(_149, _159, mad(_146, _156, (_153 * _143)));
          _168 = mad(_150, _159, mad(_147, _156, (_153 * _144)));
          _178 = _86 - mad(0.11670000106096268f, _168, mad(-0.13050000369548798f, _165, (_162 * 0.08089999854564667f)));
          _180 = _88 - mad(0.6934999823570251f, _168, mad(-0.004100000020116568f, _165, (_162 * -0.0003000000142492354f)));
          _183 = _178 * 0.699999988079071f;
          _243 = (mad(_140, _180, (_178 * _138)) + _86);
          _244 = (mad(_139, (_87 - mad(-0.1136000007390976f, _168, mad(0.05400000140070915f, _165, (_162 * -0.010200000368058681f)))), _183) + _136);
          _245 = (mad(_141, _180, _183) + _137);
        } while (false);
        break;
      }
      case 4: {
        if (((_86 > 0.25f) && (_87 < 0.550000011920929f)) && (_88 < 0.3199999928474426f)) {
          _198 = min(max((_86 + 0.20000000298023224f), 0.0f), 1.0f);
          _243 = _198;
          _244 = _198;
          _245 = (_88 * 0.25f);
        } else {
          _243 = _86;
          _244 = _87;
          _245 = _88;
        }
        break;
      }
      case 5: {
        _205 = ((_86 > 0.25f) && (_87 < 0.3199999928474426f)) && (_88 < 0.3199999928474426f);
        _243 = _86;
        _244 = select(_205, _86, _87);
        _245 = select(_205, (_88 * 0.25f), _88);
        break;
      }
      case 6: {
        if (((_86 > 0.25f) && (_87 < 0.27000001072883606f)) && (_88 < 0.27000001072883606f)) {
          _243 = ((_86 * 0.10000000149011612f) + 0.40400001406669617f);
          _244 = ((_87 * 0.10000000149011612f) + 0.2630000114440918f);
          _245 = min(max(((_88 * 0.10000000149011612f) + 0.906000018119812f), 0.0f), 1.0f);
        } else {
          _243 = _86;
          _244 = _87;
          _245 = _88;
        }
        break;
      }
      case 7: {
        if (((_86 < 0.3499999940395355f) && (_87 > 0.3499999940395355f)) && (_88 > 0.3499999940395355f)) {
          _243 = (_86 * 0.15000000596046448f);
          _244 = (_87 * 0.15000000596046448f);
          _245 = 0.2150000035762787f;
        } else {
          _243 = _86;
          _244 = _87;
          _245 = _88;
        }
        break;
      }
      case 8: {
        if (((_86 > 0.25f) && (_87 < 0.27000001072883606f)) && (_88 < 0.27000001072883606f)) {
          _243 = (_86 * 0.15000000596046448f);
          _244 = (_87 * 0.15000000596046448f);
          _245 = 0.2150000035762787f;
        } else {
          _243 = _86;
          _244 = _87;
          _245 = _88;
        }
        break;
      }
      default: {
        _243 = _86;
        _244 = _87;
        _245 = _88;
        break;
      }
    }
  } else {
    _243 = _86;
    _244 = _87;
    _245 = _88;
  }
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_243, _244, _245, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _400 = color.r;
    _401 = color.g;
    _402 = color.b;
#else  // original code
    _279 = saturate(select((_243 <= 0.040449999272823334f), (_243 * 0.07739938050508499f), exp2(log2(abs((_243 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _280 = saturate(select((_244 <= 0.040449999272823334f), (_244 * 0.07739938050508499f), exp2(log2(abs((_244 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _281 = saturate(select((_245 <= 0.040449999272823334f), (_245 * 0.07739938050508499f), exp2(log2(abs((_245 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _282 = dot(float3(_279, _280, _281), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _290 = select((_282 > 0.5f), (((_282 * HDROutput_016.y) / (HDROutput_016.y - _282)) + HDROutput_016.x), (_282 / (1.000100016593933f - _282)));
    _291 = _282 + 9.999999747378752e-05f;
    _295 = _290 * (_279 / _291);
    _296 = (_280 / _291) * _290;
    _297 = (_281 / _291) * _290;
    _313 = saturate(max(max(_295, _296), _297) + -1.0f);
    _320 = HDROutput_064 * 9.999999747378752e-05f;
    _327 = exp2(log2(abs(_320 * (((1.0f - _313) * mad(0.04331360012292862f, _297, mad(0.3292819857597351f, _296, (_295 * 0.627403974533081f)))) + (_313 * mad(0.047561999410390854f, _297, mad(0.19859300553798676f, _296, (_295 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _336 = exp2(log2(abs(((_327 * 18.8515625f) + 0.8359375f) / ((_327 * 18.6875f) + 1.0f))) * 78.84375f);
    _340 = exp2(log2(abs(_320 * mad(0.012477199546992779f, _297, mad(0.9417769908905029f, _296, (_295 * 0.045745600014925f))))) * 0.1593017578125f);
    _349 = exp2(log2(abs(((_340 * 18.8515625f) + 0.8359375f) / ((_340 * 18.6875f) + 1.0f))) * 78.84375f);
    _353 = exp2(log2(abs(_320 * mad(0.9836069941520691f, _297, mad(0.017604099586606026f, _296, (_295 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _362 = exp2(log2(abs(((_353 * 18.8515625f) + 0.8359375f) / ((_353 * 18.6875f) + 1.0f))) * 78.84375f);
    _371 = saturate(_336 / HDROutput_084);
    _372 = saturate(_349 / HDROutput_084);
    _373 = saturate(_362 / HDROutput_084);
    _374 = HDROutput_084 - HDROutput_036;
    _400 = select((_336 > HDROutput_076), _336, select((_336 < HDROutput_084), max((((_371 * _371) * _374) + HDROutput_036), _336), _336));
    _401 = select((_349 > HDROutput_076), _349, select((_349 < HDROutput_084), max((((_372 * _372) * _374) + HDROutput_036), _349), _349));
    _402 = select((_362 > HDROutput_076), _362, select((_362 < HDROutput_084), max((((_373 * _373) * _374) + HDROutput_036), _362), _362));
#endif
  } else {
    _400 = _243;
    _401 = _244;
    _402 = _245;
  }
  SV_Target.x = _400;
  SV_Target.y = _401;
  SV_Target.z = _402;
  SV_Target.w = _66;
  return SV_Target;
}