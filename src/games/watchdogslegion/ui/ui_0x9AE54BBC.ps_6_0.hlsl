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

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  linear float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float2 TEXCOORD1_centroid : TEXCOORD1_centroid,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  bool _19;
  float _20;
  float _71;
  float _72;
  float _73;
  float _122;
  float _123;
  float _124;
  float _125;
  float _126;
  float _127;
  float _128;
  float _129;
  float _130;
  float _131;
  float _132;
  float _133;
  float _134;
  float _135;
  float _136;
  float _229;
  float _230;
  float _231;
  float _386;
  float _387;
  float _388;
  float _88;
  float _89;
  float _90;
  float _91;
  float _92;
  float _93;
  float _139;
  float _142;
  float _145;
  float _148;
  float _151;
  float _154;
  float _164;
  float _166;
  float _169;
  float _184;
  bool _191;
  float _265;
  float _266;
  float _267;
  float _268;
  float _276;
  float _277;
  float _281;
  float _282;
  float _283;
  float _299;
  float _306;
  float _313;
  float _322;
  float _326;
  float _335;
  float _339;
  float _348;
  float _357;
  float _358;
  float _359;
  float _360;
  _19 = ((((float4)(t0.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y))))).x) > 0.10000000149011612f);
  if (_19) discard;
  _20 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _71 = (exp2(log2(abs(FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _20)) + _20) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _72 = (exp2(log2(abs(FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _20)) + _20) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _73 = (exp2(log2(abs(FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _20)) + _20) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!((((_71 < 9.999999747378752e-05f) && (_72 < 9.999999747378752e-05f)) && (_73 < 9.999999747378752e-05f)) || ((uint)((int)((uint)(FireUiPrimitive_388) + (uint)(-1))) > (uint)7))) {
    switch ((int)(FireUiPrimitive_388)) {
      case 1: {
        _88 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _89 = 1.0f - _88;
        _90 = _88 * 2.023439884185791f;
        _91 = _88 * -2.5258100032806396f;
        _92 = _88 * 0.4941999912261963f;
        _93 = _88 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_71 > 0.5f) && ((_73 + _72) < 0.5f)) {
              _122 = min(max((_72 + 0.20000000298023224f), 0.0f), 1.0f);
              _123 = min(max((_73 + 0.20000000298023224f), 0.0f), 1.0f);
              _124 = 0.0f;
              _125 = 1.0f;
              _126 = 0.0f;
              _127 = 1.0f;
              _128 = _89;
              _129 = 0.0f;
              _130 = 0.0f;
              _131 = _90;
              _132 = 1.0f;
              _133 = 0.0f;
              _134 = _91;
              _135 = 0.0f;
              _136 = 1.0f;
            } else {
              _122 = _72;
              _123 = _73;
              _124 = 0.0f;
              _125 = 1.0f;
              _126 = 0.0f;
              _127 = 1.0f;
              _128 = _89;
              _129 = 0.0f;
              _130 = 0.0f;
              _131 = _90;
              _132 = 1.0f;
              _133 = 0.0f;
              _134 = _91;
              _135 = 0.0f;
              _136 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_71 > (_72 * 2.0f)) && ((_72 + _71) > _73)) {
                _122 = _72;
                _123 = min(max((_73 + 0.30000001192092896f), 0.0f), 1.0f);
                _124 = 0.0f;
                _125 = 1.0f;
                _126 = 0.0f;
                _127 = 1.0f;
                _128 = 1.0f;
                _129 = _92;
                _130 = 0.0f;
                _131 = 0.0f;
                _132 = _89;
                _133 = 0.0f;
                _134 = 0.0f;
                _135 = _93;
                _136 = 1.0f;
              } else {
                _122 = _72;
                _123 = _73;
                _124 = 0.0f;
                _125 = 1.0f;
                _126 = 0.0f;
                _127 = 1.0f;
                _128 = 1.0f;
                _129 = _92;
                _130 = 0.0f;
                _131 = 0.0f;
                _132 = _89;
                _133 = 0.0f;
                _134 = 0.0f;
                _135 = _93;
                _136 = 1.0f;
              }
            } else {
              _122 = _72;
              _123 = _73;
              _124 = 1.0f;
              _125 = 0.699999988079071f;
              _126 = 0.699999988079071f;
              _127 = 0.0f;
              _128 = 1.0f;
              _129 = 0.0f;
              _130 = (_88 * -0.012245000340044498f);
              _131 = 0.0f;
              _132 = 1.0f;
              _133 = (_88 * 0.07203499972820282f);
              _134 = 0.0f;
              _135 = 0.0f;
              _136 = _89;
            }
          }
          _139 = mad(4.11929988861084f, _73, mad(43.5161018371582f, _72, (_71 * 17.882400512695312f)));
          _142 = mad(3.8671000003814697f, _73, mad(27.155399322509766f, _72, (_71 * 3.455699920654297f)));
          _145 = mad(1.4670000076293945f, _73, mad(0.18431000411510468f, _72, (_71 * 0.02996000088751316f)));
          _148 = mad(_134, _145, mad(_131, _142, (_139 * _128)));
          _151 = mad(_135, _145, mad(_132, _142, (_139 * _129)));
          _154 = mad(_136, _145, mad(_133, _142, (_139 * _130)));
          _164 = _71 - mad(0.11670000106096268f, _154, mad(-0.13050000369548798f, _151, (_148 * 0.08089999854564667f)));
          _166 = _73 - mad(0.6934999823570251f, _154, mad(-0.004100000020116568f, _151, (_148 * -0.0003000000142492354f)));
          _169 = _164 * 0.699999988079071f;
          _229 = (mad(_126, _166, (_164 * _124)) + _71);
          _230 = (mad(_125, (_72 - mad(-0.1136000007390976f, _154, mad(0.05400000140070915f, _151, (_148 * -0.010200000368058681f)))), _169) + _122);
          _231 = (mad(_127, _166, _169) + _123);
        } while (false);
        break;
      }
      case 2: {
        _88 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _89 = 1.0f - _88;
        _90 = _88 * 2.023439884185791f;
        _91 = _88 * -2.5258100032806396f;
        _92 = _88 * 0.4941999912261963f;
        _93 = _88 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_71 > 0.5f) && ((_73 + _72) < 0.5f)) {
              _122 = min(max((_72 + 0.20000000298023224f), 0.0f), 1.0f);
              _123 = min(max((_73 + 0.20000000298023224f), 0.0f), 1.0f);
              _124 = 0.0f;
              _125 = 1.0f;
              _126 = 0.0f;
              _127 = 1.0f;
              _128 = _89;
              _129 = 0.0f;
              _130 = 0.0f;
              _131 = _90;
              _132 = 1.0f;
              _133 = 0.0f;
              _134 = _91;
              _135 = 0.0f;
              _136 = 1.0f;
            } else {
              _122 = _72;
              _123 = _73;
              _124 = 0.0f;
              _125 = 1.0f;
              _126 = 0.0f;
              _127 = 1.0f;
              _128 = _89;
              _129 = 0.0f;
              _130 = 0.0f;
              _131 = _90;
              _132 = 1.0f;
              _133 = 0.0f;
              _134 = _91;
              _135 = 0.0f;
              _136 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_71 > (_72 * 2.0f)) && ((_72 + _71) > _73)) {
                _122 = _72;
                _123 = min(max((_73 + 0.30000001192092896f), 0.0f), 1.0f);
                _124 = 0.0f;
                _125 = 1.0f;
                _126 = 0.0f;
                _127 = 1.0f;
                _128 = 1.0f;
                _129 = _92;
                _130 = 0.0f;
                _131 = 0.0f;
                _132 = _89;
                _133 = 0.0f;
                _134 = 0.0f;
                _135 = _93;
                _136 = 1.0f;
              } else {
                _122 = _72;
                _123 = _73;
                _124 = 0.0f;
                _125 = 1.0f;
                _126 = 0.0f;
                _127 = 1.0f;
                _128 = 1.0f;
                _129 = _92;
                _130 = 0.0f;
                _131 = 0.0f;
                _132 = _89;
                _133 = 0.0f;
                _134 = 0.0f;
                _135 = _93;
                _136 = 1.0f;
              }
            } else {
              _122 = _72;
              _123 = _73;
              _124 = 1.0f;
              _125 = 0.699999988079071f;
              _126 = 0.699999988079071f;
              _127 = 0.0f;
              _128 = 1.0f;
              _129 = 0.0f;
              _130 = (_88 * -0.012245000340044498f);
              _131 = 0.0f;
              _132 = 1.0f;
              _133 = (_88 * 0.07203499972820282f);
              _134 = 0.0f;
              _135 = 0.0f;
              _136 = _89;
            }
          }
          _139 = mad(4.11929988861084f, _73, mad(43.5161018371582f, _72, (_71 * 17.882400512695312f)));
          _142 = mad(3.8671000003814697f, _73, mad(27.155399322509766f, _72, (_71 * 3.455699920654297f)));
          _145 = mad(1.4670000076293945f, _73, mad(0.18431000411510468f, _72, (_71 * 0.02996000088751316f)));
          _148 = mad(_134, _145, mad(_131, _142, (_139 * _128)));
          _151 = mad(_135, _145, mad(_132, _142, (_139 * _129)));
          _154 = mad(_136, _145, mad(_133, _142, (_139 * _130)));
          _164 = _71 - mad(0.11670000106096268f, _154, mad(-0.13050000369548798f, _151, (_148 * 0.08089999854564667f)));
          _166 = _73 - mad(0.6934999823570251f, _154, mad(-0.004100000020116568f, _151, (_148 * -0.0003000000142492354f)));
          _169 = _164 * 0.699999988079071f;
          _229 = (mad(_126, _166, (_164 * _124)) + _71);
          _230 = (mad(_125, (_72 - mad(-0.1136000007390976f, _154, mad(0.05400000140070915f, _151, (_148 * -0.010200000368058681f)))), _169) + _122);
          _231 = (mad(_127, _166, _169) + _123);
        } while (false);
        break;
      }
      case 3: {
        _88 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _89 = 1.0f - _88;
        _90 = _88 * 2.023439884185791f;
        _91 = _88 * -2.5258100032806396f;
        _92 = _88 * 0.4941999912261963f;
        _93 = _88 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_71 > 0.5f) && ((_73 + _72) < 0.5f)) {
              _122 = min(max((_72 + 0.20000000298023224f), 0.0f), 1.0f);
              _123 = min(max((_73 + 0.20000000298023224f), 0.0f), 1.0f);
              _124 = 0.0f;
              _125 = 1.0f;
              _126 = 0.0f;
              _127 = 1.0f;
              _128 = _89;
              _129 = 0.0f;
              _130 = 0.0f;
              _131 = _90;
              _132 = 1.0f;
              _133 = 0.0f;
              _134 = _91;
              _135 = 0.0f;
              _136 = 1.0f;
            } else {
              _122 = _72;
              _123 = _73;
              _124 = 0.0f;
              _125 = 1.0f;
              _126 = 0.0f;
              _127 = 1.0f;
              _128 = _89;
              _129 = 0.0f;
              _130 = 0.0f;
              _131 = _90;
              _132 = 1.0f;
              _133 = 0.0f;
              _134 = _91;
              _135 = 0.0f;
              _136 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_71 > (_72 * 2.0f)) && ((_72 + _71) > _73)) {
                _122 = _72;
                _123 = min(max((_73 + 0.30000001192092896f), 0.0f), 1.0f);
                _124 = 0.0f;
                _125 = 1.0f;
                _126 = 0.0f;
                _127 = 1.0f;
                _128 = 1.0f;
                _129 = _92;
                _130 = 0.0f;
                _131 = 0.0f;
                _132 = _89;
                _133 = 0.0f;
                _134 = 0.0f;
                _135 = _93;
                _136 = 1.0f;
              } else {
                _122 = _72;
                _123 = _73;
                _124 = 0.0f;
                _125 = 1.0f;
                _126 = 0.0f;
                _127 = 1.0f;
                _128 = 1.0f;
                _129 = _92;
                _130 = 0.0f;
                _131 = 0.0f;
                _132 = _89;
                _133 = 0.0f;
                _134 = 0.0f;
                _135 = _93;
                _136 = 1.0f;
              }
            } else {
              _122 = _72;
              _123 = _73;
              _124 = 1.0f;
              _125 = 0.699999988079071f;
              _126 = 0.699999988079071f;
              _127 = 0.0f;
              _128 = 1.0f;
              _129 = 0.0f;
              _130 = (_88 * -0.012245000340044498f);
              _131 = 0.0f;
              _132 = 1.0f;
              _133 = (_88 * 0.07203499972820282f);
              _134 = 0.0f;
              _135 = 0.0f;
              _136 = _89;
            }
          }
          _139 = mad(4.11929988861084f, _73, mad(43.5161018371582f, _72, (_71 * 17.882400512695312f)));
          _142 = mad(3.8671000003814697f, _73, mad(27.155399322509766f, _72, (_71 * 3.455699920654297f)));
          _145 = mad(1.4670000076293945f, _73, mad(0.18431000411510468f, _72, (_71 * 0.02996000088751316f)));
          _148 = mad(_134, _145, mad(_131, _142, (_139 * _128)));
          _151 = mad(_135, _145, mad(_132, _142, (_139 * _129)));
          _154 = mad(_136, _145, mad(_133, _142, (_139 * _130)));
          _164 = _71 - mad(0.11670000106096268f, _154, mad(-0.13050000369548798f, _151, (_148 * 0.08089999854564667f)));
          _166 = _73 - mad(0.6934999823570251f, _154, mad(-0.004100000020116568f, _151, (_148 * -0.0003000000142492354f)));
          _169 = _164 * 0.699999988079071f;
          _229 = (mad(_126, _166, (_164 * _124)) + _71);
          _230 = (mad(_125, (_72 - mad(-0.1136000007390976f, _154, mad(0.05400000140070915f, _151, (_148 * -0.010200000368058681f)))), _169) + _122);
          _231 = (mad(_127, _166, _169) + _123);
        } while (false);
        break;
      }
      case 4: {
        if (((_71 > 0.25f) && (_72 < 0.550000011920929f)) && (_73 < 0.3199999928474426f)) {
          _184 = min(max((_71 + 0.20000000298023224f), 0.0f), 1.0f);
          _229 = _184;
          _230 = _184;
          _231 = (_73 * 0.25f);
        } else {
          _229 = _71;
          _230 = _72;
          _231 = _73;
        }
        break;
      }
      case 5: {
        _191 = ((_71 > 0.25f) && (_72 < 0.3199999928474426f)) && (_73 < 0.3199999928474426f);
        _229 = _71;
        _230 = select(_191, _71, _72);
        _231 = select(_191, (_73 * 0.25f), _73);
        break;
      }
      case 6: {
        if (((_71 > 0.25f) && (_72 < 0.27000001072883606f)) && (_73 < 0.27000001072883606f)) {
          _229 = ((_71 * 0.10000000149011612f) + 0.40400001406669617f);
          _230 = ((_72 * 0.10000000149011612f) + 0.2630000114440918f);
          _231 = min(max(((_73 * 0.10000000149011612f) + 0.906000018119812f), 0.0f), 1.0f);
        } else {
          _229 = _71;
          _230 = _72;
          _231 = _73;
        }
        break;
      }
      case 7: {
        if (((_71 < 0.3499999940395355f) && (_72 > 0.3499999940395355f)) && (_73 > 0.3499999940395355f)) {
          _229 = (_71 * 0.15000000596046448f);
          _230 = (_72 * 0.15000000596046448f);
          _231 = 0.2150000035762787f;
        } else {
          _229 = _71;
          _230 = _72;
          _231 = _73;
        }
        break;
      }
      case 8: {
        if (((_71 > 0.25f) && (_72 < 0.27000001072883606f)) && (_73 < 0.27000001072883606f)) {
          _229 = (_71 * 0.15000000596046448f);
          _230 = (_72 * 0.15000000596046448f);
          _231 = 0.2150000035762787f;
        } else {
          _229 = _71;
          _230 = _72;
          _231 = _73;
        }
        break;
      }
      default: {
        _229 = _71;
        _230 = _72;
        _231 = _73;
        break;
      }
    }
  } else {
    _229 = _71;
    _230 = _72;
    _231 = _73;
  }
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_229, _230, _231, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _386 = color.r;
    _387 = color.g;
    _388 = color.b;
#else  // original code
    _265 = saturate(select((_229 <= 0.040449999272823334f), (_229 * 0.07739938050508499f), exp2(log2(abs((_229 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _266 = saturate(select((_230 <= 0.040449999272823334f), (_230 * 0.07739938050508499f), exp2(log2(abs((_230 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _267 = saturate(select((_231 <= 0.040449999272823334f), (_231 * 0.07739938050508499f), exp2(log2(abs((_231 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _268 = dot(float3(_265, _266, _267), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _276 = select((_268 > 0.5f), (((_268 * HDROutput_016.y) / (HDROutput_016.y - _268)) + HDROutput_016.x), (_268 / (1.000100016593933f - _268)));
    _277 = _268 + 9.999999747378752e-05f;
    _281 = _276 * (_265 / _277);
    _282 = (_266 / _277) * _276;
    _283 = (_267 / _277) * _276;
    _299 = saturate(max(max(_281, _282), _283) + -1.0f);
    _306 = HDROutput_064 * 9.999999747378752e-05f;
    _313 = exp2(log2(abs(_306 * (((1.0f - _299) * mad(0.04331360012292862f, _283, mad(0.3292819857597351f, _282, (_281 * 0.627403974533081f)))) + (_299 * mad(0.047561999410390854f, _283, mad(0.19859300553798676f, _282, (_281 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _322 = exp2(log2(abs(((_313 * 18.8515625f) + 0.8359375f) / ((_313 * 18.6875f) + 1.0f))) * 78.84375f);
    _326 = exp2(log2(abs(_306 * mad(0.012477199546992779f, _283, mad(0.9417769908905029f, _282, (_281 * 0.045745600014925f))))) * 0.1593017578125f);
    _335 = exp2(log2(abs(((_326 * 18.8515625f) + 0.8359375f) / ((_326 * 18.6875f) + 1.0f))) * 78.84375f);
    _339 = exp2(log2(abs(_306 * mad(0.9836069941520691f, _283, mad(0.017604099586606026f, _282, (_281 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _348 = exp2(log2(abs(((_339 * 18.8515625f) + 0.8359375f) / ((_339 * 18.6875f) + 1.0f))) * 78.84375f);
    _357 = saturate(_322 / HDROutput_084);
    _358 = saturate(_335 / HDROutput_084);
    _359 = saturate(_348 / HDROutput_084);
    _360 = HDROutput_084 - HDROutput_036;
    _386 = select((_322 > HDROutput_076), _322, select((_322 < HDROutput_084), max((((_357 * _357) * _360) + HDROutput_036), _322), _322));
    _387 = select((_335 > HDROutput_076), _335, select((_335 < HDROutput_084), max((((_358 * _358) * _360) + HDROutput_036), _335), _335));
    _388 = select((_348 > HDROutput_076), _348, select((_348 < HDROutput_084), max((((_359 * _359) * _360) + HDROutput_036), _348), _348));
#endif
  } else {
    _386 = _229;
    _387 = _230;
    _388 = _231;
  }
  SV_Target.x = _386;
  SV_Target.y = _387;
  SV_Target.z = _388;
  SV_Target.w = (FireUiPrimitive_016.w * TEXCOORD0_centroid.w);
  return SV_Target;
}