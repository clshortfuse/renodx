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

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float cb0_092z : packoffset(c092.z);
  float cb0_092w : packoffset(c092.w);
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

SamplerState s1 : register(s1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float4 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  bool _23;
  float4 _24;
  bool _31;
  float _35;
  float _36;
  float _37;
  float _39;
  float _90;
  float _91;
  float _92;
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
  float _151;
  float _152;
  float _153;
  float _154;
  float _247;
  float _248;
  float _249;
  float _404;
  float _405;
  float _406;
  float _106;
  float _107;
  float _108;
  float _109;
  float _110;
  float _111;
  float _157;
  float _160;
  float _163;
  float _166;
  float _169;
  float _172;
  float _182;
  float _184;
  float _187;
  float _202;
  bool _209;
  float _283;
  float _284;
  float _285;
  float _286;
  float _294;
  float _295;
  float _299;
  float _300;
  float _301;
  float _317;
  float _324;
  float _331;
  float _340;
  float _344;
  float _353;
  float _357;
  float _366;
  float _375;
  float _376;
  float _377;
  float _378;
  _23 = ((((float4)(t1.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y))))).x) > 0.10000000149011612f);
  if (_23) discard;
  _24 = t0.Sample(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _31 = (FireUiPrimitive_396 != 0);
  _35 = select(_31, 1.0f, _24.x) * TEXCOORD0_centroid.x;
  _36 = select(_31, 1.0f, _24.y) * TEXCOORD0_centroid.y;
  _37 = select(_31, 1.0f, _24.z) * TEXCOORD0_centroid.z;
  _39 = dot(float3(_35, _36, _37), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _90 = (exp2(log2(abs(FireUiPrimitive_016.x * min(max(((lerp(_39, _35, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _91 = (exp2(log2(abs(FireUiPrimitive_016.y * min(max(((lerp(_39, _36, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _92 = (exp2(log2(abs(FireUiPrimitive_016.z * min(max(((lerp(_39, _37, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!((((_90 < 9.999999747378752e-05f) && (_91 < 9.999999747378752e-05f)) && (_92 < 9.999999747378752e-05f)) || ((uint)((int)((uint)(FireUiPrimitive_388) + (uint)(-1))) > (uint)7))) {
    switch ((int)(FireUiPrimitive_388)) {
      case 1: {
        _106 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _107 = 1.0f - _106;
        _108 = _106 * 2.023439884185791f;
        _109 = _106 * -2.5258100032806396f;
        _110 = _106 * 0.4941999912261963f;
        _111 = _106 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_90 > 0.5f) && ((_92 + _91) < 0.5f)) {
              _140 = min(max((_91 + 0.20000000298023224f), 0.0f), 1.0f);
              _141 = min(max((_92 + 0.20000000298023224f), 0.0f), 1.0f);
              _142 = 0.0f;
              _143 = 1.0f;
              _144 = 0.0f;
              _145 = 1.0f;
              _146 = _107;
              _147 = 0.0f;
              _148 = 0.0f;
              _149 = _108;
              _150 = 1.0f;
              _151 = 0.0f;
              _152 = _109;
              _153 = 0.0f;
              _154 = 1.0f;
            } else {
              _140 = _91;
              _141 = _92;
              _142 = 0.0f;
              _143 = 1.0f;
              _144 = 0.0f;
              _145 = 1.0f;
              _146 = _107;
              _147 = 0.0f;
              _148 = 0.0f;
              _149 = _108;
              _150 = 1.0f;
              _151 = 0.0f;
              _152 = _109;
              _153 = 0.0f;
              _154 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_90 > (_91 * 2.0f)) && ((_91 + _90) > _92)) {
                _140 = _91;
                _141 = min(max((_92 + 0.30000001192092896f), 0.0f), 1.0f);
                _142 = 0.0f;
                _143 = 1.0f;
                _144 = 0.0f;
                _145 = 1.0f;
                _146 = 1.0f;
                _147 = _110;
                _148 = 0.0f;
                _149 = 0.0f;
                _150 = _107;
                _151 = 0.0f;
                _152 = 0.0f;
                _153 = _111;
                _154 = 1.0f;
              } else {
                _140 = _91;
                _141 = _92;
                _142 = 0.0f;
                _143 = 1.0f;
                _144 = 0.0f;
                _145 = 1.0f;
                _146 = 1.0f;
                _147 = _110;
                _148 = 0.0f;
                _149 = 0.0f;
                _150 = _107;
                _151 = 0.0f;
                _152 = 0.0f;
                _153 = _111;
                _154 = 1.0f;
              }
            } else {
              _140 = _91;
              _141 = _92;
              _142 = 1.0f;
              _143 = 0.699999988079071f;
              _144 = 0.699999988079071f;
              _145 = 0.0f;
              _146 = 1.0f;
              _147 = 0.0f;
              _148 = (_106 * -0.012245000340044498f);
              _149 = 0.0f;
              _150 = 1.0f;
              _151 = (_106 * 0.07203499972820282f);
              _152 = 0.0f;
              _153 = 0.0f;
              _154 = _107;
            }
          }
          _157 = mad(4.11929988861084f, _92, mad(43.5161018371582f, _91, (_90 * 17.882400512695312f)));
          _160 = mad(3.8671000003814697f, _92, mad(27.155399322509766f, _91, (_90 * 3.455699920654297f)));
          _163 = mad(1.4670000076293945f, _92, mad(0.18431000411510468f, _91, (_90 * 0.02996000088751316f)));
          _166 = mad(_152, _163, mad(_149, _160, (_157 * _146)));
          _169 = mad(_153, _163, mad(_150, _160, (_157 * _147)));
          _172 = mad(_154, _163, mad(_151, _160, (_157 * _148)));
          _182 = _90 - mad(0.11670000106096268f, _172, mad(-0.13050000369548798f, _169, (_166 * 0.08089999854564667f)));
          _184 = _92 - mad(0.6934999823570251f, _172, mad(-0.004100000020116568f, _169, (_166 * -0.0003000000142492354f)));
          _187 = _182 * 0.699999988079071f;
          _247 = (mad(_144, _184, (_182 * _142)) + _90);
          _248 = (mad(_143, (_91 - mad(-0.1136000007390976f, _172, mad(0.05400000140070915f, _169, (_166 * -0.010200000368058681f)))), _187) + _140);
          _249 = (mad(_145, _184, _187) + _141);
        } while (false);
        break;
      }
      case 2: {
        _106 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _107 = 1.0f - _106;
        _108 = _106 * 2.023439884185791f;
        _109 = _106 * -2.5258100032806396f;
        _110 = _106 * 0.4941999912261963f;
        _111 = _106 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_90 > 0.5f) && ((_92 + _91) < 0.5f)) {
              _140 = min(max((_91 + 0.20000000298023224f), 0.0f), 1.0f);
              _141 = min(max((_92 + 0.20000000298023224f), 0.0f), 1.0f);
              _142 = 0.0f;
              _143 = 1.0f;
              _144 = 0.0f;
              _145 = 1.0f;
              _146 = _107;
              _147 = 0.0f;
              _148 = 0.0f;
              _149 = _108;
              _150 = 1.0f;
              _151 = 0.0f;
              _152 = _109;
              _153 = 0.0f;
              _154 = 1.0f;
            } else {
              _140 = _91;
              _141 = _92;
              _142 = 0.0f;
              _143 = 1.0f;
              _144 = 0.0f;
              _145 = 1.0f;
              _146 = _107;
              _147 = 0.0f;
              _148 = 0.0f;
              _149 = _108;
              _150 = 1.0f;
              _151 = 0.0f;
              _152 = _109;
              _153 = 0.0f;
              _154 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_90 > (_91 * 2.0f)) && ((_91 + _90) > _92)) {
                _140 = _91;
                _141 = min(max((_92 + 0.30000001192092896f), 0.0f), 1.0f);
                _142 = 0.0f;
                _143 = 1.0f;
                _144 = 0.0f;
                _145 = 1.0f;
                _146 = 1.0f;
                _147 = _110;
                _148 = 0.0f;
                _149 = 0.0f;
                _150 = _107;
                _151 = 0.0f;
                _152 = 0.0f;
                _153 = _111;
                _154 = 1.0f;
              } else {
                _140 = _91;
                _141 = _92;
                _142 = 0.0f;
                _143 = 1.0f;
                _144 = 0.0f;
                _145 = 1.0f;
                _146 = 1.0f;
                _147 = _110;
                _148 = 0.0f;
                _149 = 0.0f;
                _150 = _107;
                _151 = 0.0f;
                _152 = 0.0f;
                _153 = _111;
                _154 = 1.0f;
              }
            } else {
              _140 = _91;
              _141 = _92;
              _142 = 1.0f;
              _143 = 0.699999988079071f;
              _144 = 0.699999988079071f;
              _145 = 0.0f;
              _146 = 1.0f;
              _147 = 0.0f;
              _148 = (_106 * -0.012245000340044498f);
              _149 = 0.0f;
              _150 = 1.0f;
              _151 = (_106 * 0.07203499972820282f);
              _152 = 0.0f;
              _153 = 0.0f;
              _154 = _107;
            }
          }
          _157 = mad(4.11929988861084f, _92, mad(43.5161018371582f, _91, (_90 * 17.882400512695312f)));
          _160 = mad(3.8671000003814697f, _92, mad(27.155399322509766f, _91, (_90 * 3.455699920654297f)));
          _163 = mad(1.4670000076293945f, _92, mad(0.18431000411510468f, _91, (_90 * 0.02996000088751316f)));
          _166 = mad(_152, _163, mad(_149, _160, (_157 * _146)));
          _169 = mad(_153, _163, mad(_150, _160, (_157 * _147)));
          _172 = mad(_154, _163, mad(_151, _160, (_157 * _148)));
          _182 = _90 - mad(0.11670000106096268f, _172, mad(-0.13050000369548798f, _169, (_166 * 0.08089999854564667f)));
          _184 = _92 - mad(0.6934999823570251f, _172, mad(-0.004100000020116568f, _169, (_166 * -0.0003000000142492354f)));
          _187 = _182 * 0.699999988079071f;
          _247 = (mad(_144, _184, (_182 * _142)) + _90);
          _248 = (mad(_143, (_91 - mad(-0.1136000007390976f, _172, mad(0.05400000140070915f, _169, (_166 * -0.010200000368058681f)))), _187) + _140);
          _249 = (mad(_145, _184, _187) + _141);
        } while (false);
        break;
      }
      case 3: {
        _106 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _107 = 1.0f - _106;
        _108 = _106 * 2.023439884185791f;
        _109 = _106 * -2.5258100032806396f;
        _110 = _106 * 0.4941999912261963f;
        _111 = _106 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_90 > 0.5f) && ((_92 + _91) < 0.5f)) {
              _140 = min(max((_91 + 0.20000000298023224f), 0.0f), 1.0f);
              _141 = min(max((_92 + 0.20000000298023224f), 0.0f), 1.0f);
              _142 = 0.0f;
              _143 = 1.0f;
              _144 = 0.0f;
              _145 = 1.0f;
              _146 = _107;
              _147 = 0.0f;
              _148 = 0.0f;
              _149 = _108;
              _150 = 1.0f;
              _151 = 0.0f;
              _152 = _109;
              _153 = 0.0f;
              _154 = 1.0f;
            } else {
              _140 = _91;
              _141 = _92;
              _142 = 0.0f;
              _143 = 1.0f;
              _144 = 0.0f;
              _145 = 1.0f;
              _146 = _107;
              _147 = 0.0f;
              _148 = 0.0f;
              _149 = _108;
              _150 = 1.0f;
              _151 = 0.0f;
              _152 = _109;
              _153 = 0.0f;
              _154 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_90 > (_91 * 2.0f)) && ((_91 + _90) > _92)) {
                _140 = _91;
                _141 = min(max((_92 + 0.30000001192092896f), 0.0f), 1.0f);
                _142 = 0.0f;
                _143 = 1.0f;
                _144 = 0.0f;
                _145 = 1.0f;
                _146 = 1.0f;
                _147 = _110;
                _148 = 0.0f;
                _149 = 0.0f;
                _150 = _107;
                _151 = 0.0f;
                _152 = 0.0f;
                _153 = _111;
                _154 = 1.0f;
              } else {
                _140 = _91;
                _141 = _92;
                _142 = 0.0f;
                _143 = 1.0f;
                _144 = 0.0f;
                _145 = 1.0f;
                _146 = 1.0f;
                _147 = _110;
                _148 = 0.0f;
                _149 = 0.0f;
                _150 = _107;
                _151 = 0.0f;
                _152 = 0.0f;
                _153 = _111;
                _154 = 1.0f;
              }
            } else {
              _140 = _91;
              _141 = _92;
              _142 = 1.0f;
              _143 = 0.699999988079071f;
              _144 = 0.699999988079071f;
              _145 = 0.0f;
              _146 = 1.0f;
              _147 = 0.0f;
              _148 = (_106 * -0.012245000340044498f);
              _149 = 0.0f;
              _150 = 1.0f;
              _151 = (_106 * 0.07203499972820282f);
              _152 = 0.0f;
              _153 = 0.0f;
              _154 = _107;
            }
          }
          _157 = mad(4.11929988861084f, _92, mad(43.5161018371582f, _91, (_90 * 17.882400512695312f)));
          _160 = mad(3.8671000003814697f, _92, mad(27.155399322509766f, _91, (_90 * 3.455699920654297f)));
          _163 = mad(1.4670000076293945f, _92, mad(0.18431000411510468f, _91, (_90 * 0.02996000088751316f)));
          _166 = mad(_152, _163, mad(_149, _160, (_157 * _146)));
          _169 = mad(_153, _163, mad(_150, _160, (_157 * _147)));
          _172 = mad(_154, _163, mad(_151, _160, (_157 * _148)));
          _182 = _90 - mad(0.11670000106096268f, _172, mad(-0.13050000369548798f, _169, (_166 * 0.08089999854564667f)));
          _184 = _92 - mad(0.6934999823570251f, _172, mad(-0.004100000020116568f, _169, (_166 * -0.0003000000142492354f)));
          _187 = _182 * 0.699999988079071f;
          _247 = (mad(_144, _184, (_182 * _142)) + _90);
          _248 = (mad(_143, (_91 - mad(-0.1136000007390976f, _172, mad(0.05400000140070915f, _169, (_166 * -0.010200000368058681f)))), _187) + _140);
          _249 = (mad(_145, _184, _187) + _141);
        } while (false);
        break;
      }
      case 4: {
        if (((_90 > 0.25f) && (_91 < 0.550000011920929f)) && (_92 < 0.3199999928474426f)) {
          _202 = min(max((_90 + 0.20000000298023224f), 0.0f), 1.0f);
          _247 = _202;
          _248 = _202;
          _249 = (_92 * 0.25f);
        } else {
          _247 = _90;
          _248 = _91;
          _249 = _92;
        }
        break;
      }
      case 5: {
        _209 = ((_90 > 0.25f) && (_91 < 0.3199999928474426f)) && (_92 < 0.3199999928474426f);
        _247 = _90;
        _248 = select(_209, _90, _91);
        _249 = select(_209, (_92 * 0.25f), _92);
        break;
      }
      case 6: {
        if (((_90 > 0.25f) && (_91 < 0.27000001072883606f)) && (_92 < 0.27000001072883606f)) {
          _247 = ((_90 * 0.10000000149011612f) + 0.40400001406669617f);
          _248 = ((_91 * 0.10000000149011612f) + 0.2630000114440918f);
          _249 = min(max(((_92 * 0.10000000149011612f) + 0.906000018119812f), 0.0f), 1.0f);
        } else {
          _247 = _90;
          _248 = _91;
          _249 = _92;
        }
        break;
      }
      case 7: {
        if (((_90 < 0.3499999940395355f) && (_91 > 0.3499999940395355f)) && (_92 > 0.3499999940395355f)) {
          _247 = (_90 * 0.15000000596046448f);
          _248 = (_91 * 0.15000000596046448f);
          _249 = 0.2150000035762787f;
        } else {
          _247 = _90;
          _248 = _91;
          _249 = _92;
        }
        break;
      }
      case 8: {
        if (((_90 > 0.25f) && (_91 < 0.27000001072883606f)) && (_92 < 0.27000001072883606f)) {
          _247 = (_90 * 0.15000000596046448f);
          _248 = (_91 * 0.15000000596046448f);
          _249 = 0.2150000035762787f;
        } else {
          _247 = _90;
          _248 = _91;
          _249 = _92;
        }
        break;
      }
      default: {
        _247 = _90;
        _248 = _91;
        _249 = _92;
        break;
      }
    }
  } else {
    _247 = _90;
    _248 = _91;
    _249 = _92;
  }
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_247, _248, _249, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _404 = color.r;
    _405 = color.g;
    _406 = color.b;
#else  // original code
    _283 = saturate(select((_247 <= 0.040449999272823334f), (_247 * 0.07739938050508499f), exp2(log2(abs((_247 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _284 = saturate(select((_248 <= 0.040449999272823334f), (_248 * 0.07739938050508499f), exp2(log2(abs((_248 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _285 = saturate(select((_249 <= 0.040449999272823334f), (_249 * 0.07739938050508499f), exp2(log2(abs((_249 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _286 = dot(float3(_283, _284, _285), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _294 = select((_286 > 0.5f), (((_286 * HDROutput_016.y) / (HDROutput_016.y - _286)) + HDROutput_016.x), (_286 / (1.000100016593933f - _286)));
    _295 = _286 + 9.999999747378752e-05f;
    _299 = _294 * (_283 / _295);
    _300 = (_284 / _295) * _294;
    _301 = (_285 / _295) * _294;
    _317 = saturate(max(max(_299, _300), _301) + -1.0f);
    _324 = HDROutput_064 * 9.999999747378752e-05f;
    _331 = exp2(log2(abs(_324 * (((1.0f - _317) * mad(0.04331360012292862f, _301, mad(0.3292819857597351f, _300, (_299 * 0.627403974533081f)))) + (_317 * mad(0.047561999410390854f, _301, mad(0.19859300553798676f, _300, (_299 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _340 = exp2(log2(abs(((_331 * 18.8515625f) + 0.8359375f) / ((_331 * 18.6875f) + 1.0f))) * 78.84375f);
    _344 = exp2(log2(abs(_324 * mad(0.012477199546992779f, _301, mad(0.9417769908905029f, _300, (_299 * 0.045745600014925f))))) * 0.1593017578125f);
    _353 = exp2(log2(abs(((_344 * 18.8515625f) + 0.8359375f) / ((_344 * 18.6875f) + 1.0f))) * 78.84375f);
    _357 = exp2(log2(abs(_324 * mad(0.9836069941520691f, _301, mad(0.017604099586606026f, _300, (_299 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _366 = exp2(log2(abs(((_357 * 18.8515625f) + 0.8359375f) / ((_357 * 18.6875f) + 1.0f))) * 78.84375f);
    _375 = saturate(_340 / HDROutput_084);
    _376 = saturate(_353 / HDROutput_084);
    _377 = saturate(_366 / HDROutput_084);
    _378 = HDROutput_084 - HDROutput_036;
    _404 = select((_340 > HDROutput_076), _340, select((_340 < HDROutput_084), max((((_375 * _375) * _378) + HDROutput_036), _340), _340));
    _405 = select((_353 > HDROutput_076), _353, select((_353 < HDROutput_084), max((((_376 * _376) * _378) + HDROutput_036), _353), _353));
    _406 = select((_366 > HDROutput_076), _366, select((_366 < HDROutput_084), max((((_377 * _377) * _378) + HDROutput_036), _366), _366));
#endif
  } else {
    _404 = _247;
    _405 = _248;
    _406 = _249;
  }
  SV_Target.x = _404;
  SV_Target.y = _405;
  SV_Target.z = _406;
  SV_Target.w = ((_24.w * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}