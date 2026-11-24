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
  float _19;
  float _70;
  float _71;
  float _72;
  float _120;
  float _121;
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
  float _227;
  float _228;
  float _229;
  float _384;
  float _385;
  float _386;
  float _86;
  float _87;
  float _88;
  float _89;
  float _90;
  float _91;
  float _137;
  float _140;
  float _143;
  float _146;
  float _149;
  float _152;
  float _162;
  float _164;
  float _167;
  float _182;
  bool _189;
  float _263;
  float _264;
  float _265;
  float _266;
  float _274;
  float _275;
  float _279;
  float _280;
  float _281;
  float _297;
  float _304;
  float _311;
  float _320;
  float _324;
  float _333;
  float _337;
  float _346;
  float _355;
  float _356;
  float _357;
  float _358;
  _19 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _70 = (exp2(log2(abs(FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _19)) + _19) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _71 = (exp2(log2(abs(FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _19)) + _19) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _72 = (exp2(log2(abs(FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _19)) + _19) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!((((_70 < 9.999999747378752e-05f) && (_71 < 9.999999747378752e-05f)) && (_72 < 9.999999747378752e-05f)) || ((uint)((int)((uint)(FireUiPrimitive_388) + (uint)(-1))) > (uint)7))) {
    switch ((int)(FireUiPrimitive_388)) {
      case 1: {
        _86 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _87 = 1.0f - _86;
        _88 = _86 * 2.023439884185791f;
        _89 = _86 * -2.5258100032806396f;
        _90 = _86 * 0.4941999912261963f;
        _91 = _86 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_70 > 0.5f) && ((_72 + _71) < 0.5f)) {
              _120 = min(max((_71 + 0.20000000298023224f), 0.0f), 1.0f);
              _121 = min(max((_72 + 0.20000000298023224f), 0.0f), 1.0f);
              _122 = 0.0f;
              _123 = 1.0f;
              _124 = 0.0f;
              _125 = 1.0f;
              _126 = _87;
              _127 = 0.0f;
              _128 = 0.0f;
              _129 = _88;
              _130 = 1.0f;
              _131 = 0.0f;
              _132 = _89;
              _133 = 0.0f;
              _134 = 1.0f;
            } else {
              _120 = _71;
              _121 = _72;
              _122 = 0.0f;
              _123 = 1.0f;
              _124 = 0.0f;
              _125 = 1.0f;
              _126 = _87;
              _127 = 0.0f;
              _128 = 0.0f;
              _129 = _88;
              _130 = 1.0f;
              _131 = 0.0f;
              _132 = _89;
              _133 = 0.0f;
              _134 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_70 > (_71 * 2.0f)) && ((_71 + _70) > _72)) {
                _120 = _71;
                _121 = min(max((_72 + 0.30000001192092896f), 0.0f), 1.0f);
                _122 = 0.0f;
                _123 = 1.0f;
                _124 = 0.0f;
                _125 = 1.0f;
                _126 = 1.0f;
                _127 = _90;
                _128 = 0.0f;
                _129 = 0.0f;
                _130 = _87;
                _131 = 0.0f;
                _132 = 0.0f;
                _133 = _91;
                _134 = 1.0f;
              } else {
                _120 = _71;
                _121 = _72;
                _122 = 0.0f;
                _123 = 1.0f;
                _124 = 0.0f;
                _125 = 1.0f;
                _126 = 1.0f;
                _127 = _90;
                _128 = 0.0f;
                _129 = 0.0f;
                _130 = _87;
                _131 = 0.0f;
                _132 = 0.0f;
                _133 = _91;
                _134 = 1.0f;
              }
            } else {
              _120 = _71;
              _121 = _72;
              _122 = 1.0f;
              _123 = 0.699999988079071f;
              _124 = 0.699999988079071f;
              _125 = 0.0f;
              _126 = 1.0f;
              _127 = 0.0f;
              _128 = (_86 * -0.012245000340044498f);
              _129 = 0.0f;
              _130 = 1.0f;
              _131 = (_86 * 0.07203499972820282f);
              _132 = 0.0f;
              _133 = 0.0f;
              _134 = _87;
            }
          }
          _137 = mad(4.11929988861084f, _72, mad(43.5161018371582f, _71, (_70 * 17.882400512695312f)));
          _140 = mad(3.8671000003814697f, _72, mad(27.155399322509766f, _71, (_70 * 3.455699920654297f)));
          _143 = mad(1.4670000076293945f, _72, mad(0.18431000411510468f, _71, (_70 * 0.02996000088751316f)));
          _146 = mad(_132, _143, mad(_129, _140, (_137 * _126)));
          _149 = mad(_133, _143, mad(_130, _140, (_137 * _127)));
          _152 = mad(_134, _143, mad(_131, _140, (_137 * _128)));
          _162 = _70 - mad(0.11670000106096268f, _152, mad(-0.13050000369548798f, _149, (_146 * 0.08089999854564667f)));
          _164 = _72 - mad(0.6934999823570251f, _152, mad(-0.004100000020116568f, _149, (_146 * -0.0003000000142492354f)));
          _167 = _162 * 0.699999988079071f;
          _227 = (mad(_124, _164, (_162 * _122)) + _70);
          _228 = (mad(_123, (_71 - mad(-0.1136000007390976f, _152, mad(0.05400000140070915f, _149, (_146 * -0.010200000368058681f)))), _167) + _120);
          _229 = (mad(_125, _164, _167) + _121);
        } while (false);
        break;
      }
      case 2: {
        _86 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _87 = 1.0f - _86;
        _88 = _86 * 2.023439884185791f;
        _89 = _86 * -2.5258100032806396f;
        _90 = _86 * 0.4941999912261963f;
        _91 = _86 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_70 > 0.5f) && ((_72 + _71) < 0.5f)) {
              _120 = min(max((_71 + 0.20000000298023224f), 0.0f), 1.0f);
              _121 = min(max((_72 + 0.20000000298023224f), 0.0f), 1.0f);
              _122 = 0.0f;
              _123 = 1.0f;
              _124 = 0.0f;
              _125 = 1.0f;
              _126 = _87;
              _127 = 0.0f;
              _128 = 0.0f;
              _129 = _88;
              _130 = 1.0f;
              _131 = 0.0f;
              _132 = _89;
              _133 = 0.0f;
              _134 = 1.0f;
            } else {
              _120 = _71;
              _121 = _72;
              _122 = 0.0f;
              _123 = 1.0f;
              _124 = 0.0f;
              _125 = 1.0f;
              _126 = _87;
              _127 = 0.0f;
              _128 = 0.0f;
              _129 = _88;
              _130 = 1.0f;
              _131 = 0.0f;
              _132 = _89;
              _133 = 0.0f;
              _134 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_70 > (_71 * 2.0f)) && ((_71 + _70) > _72)) {
                _120 = _71;
                _121 = min(max((_72 + 0.30000001192092896f), 0.0f), 1.0f);
                _122 = 0.0f;
                _123 = 1.0f;
                _124 = 0.0f;
                _125 = 1.0f;
                _126 = 1.0f;
                _127 = _90;
                _128 = 0.0f;
                _129 = 0.0f;
                _130 = _87;
                _131 = 0.0f;
                _132 = 0.0f;
                _133 = _91;
                _134 = 1.0f;
              } else {
                _120 = _71;
                _121 = _72;
                _122 = 0.0f;
                _123 = 1.0f;
                _124 = 0.0f;
                _125 = 1.0f;
                _126 = 1.0f;
                _127 = _90;
                _128 = 0.0f;
                _129 = 0.0f;
                _130 = _87;
                _131 = 0.0f;
                _132 = 0.0f;
                _133 = _91;
                _134 = 1.0f;
              }
            } else {
              _120 = _71;
              _121 = _72;
              _122 = 1.0f;
              _123 = 0.699999988079071f;
              _124 = 0.699999988079071f;
              _125 = 0.0f;
              _126 = 1.0f;
              _127 = 0.0f;
              _128 = (_86 * -0.012245000340044498f);
              _129 = 0.0f;
              _130 = 1.0f;
              _131 = (_86 * 0.07203499972820282f);
              _132 = 0.0f;
              _133 = 0.0f;
              _134 = _87;
            }
          }
          _137 = mad(4.11929988861084f, _72, mad(43.5161018371582f, _71, (_70 * 17.882400512695312f)));
          _140 = mad(3.8671000003814697f, _72, mad(27.155399322509766f, _71, (_70 * 3.455699920654297f)));
          _143 = mad(1.4670000076293945f, _72, mad(0.18431000411510468f, _71, (_70 * 0.02996000088751316f)));
          _146 = mad(_132, _143, mad(_129, _140, (_137 * _126)));
          _149 = mad(_133, _143, mad(_130, _140, (_137 * _127)));
          _152 = mad(_134, _143, mad(_131, _140, (_137 * _128)));
          _162 = _70 - mad(0.11670000106096268f, _152, mad(-0.13050000369548798f, _149, (_146 * 0.08089999854564667f)));
          _164 = _72 - mad(0.6934999823570251f, _152, mad(-0.004100000020116568f, _149, (_146 * -0.0003000000142492354f)));
          _167 = _162 * 0.699999988079071f;
          _227 = (mad(_124, _164, (_162 * _122)) + _70);
          _228 = (mad(_123, (_71 - mad(-0.1136000007390976f, _152, mad(0.05400000140070915f, _149, (_146 * -0.010200000368058681f)))), _167) + _120);
          _229 = (mad(_125, _164, _167) + _121);
        } while (false);
        break;
      }
      case 3: {
        _86 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _87 = 1.0f - _86;
        _88 = _86 * 2.023439884185791f;
        _89 = _86 * -2.5258100032806396f;
        _90 = _86 * 0.4941999912261963f;
        _91 = _86 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_70 > 0.5f) && ((_72 + _71) < 0.5f)) {
              _120 = min(max((_71 + 0.20000000298023224f), 0.0f), 1.0f);
              _121 = min(max((_72 + 0.20000000298023224f), 0.0f), 1.0f);
              _122 = 0.0f;
              _123 = 1.0f;
              _124 = 0.0f;
              _125 = 1.0f;
              _126 = _87;
              _127 = 0.0f;
              _128 = 0.0f;
              _129 = _88;
              _130 = 1.0f;
              _131 = 0.0f;
              _132 = _89;
              _133 = 0.0f;
              _134 = 1.0f;
            } else {
              _120 = _71;
              _121 = _72;
              _122 = 0.0f;
              _123 = 1.0f;
              _124 = 0.0f;
              _125 = 1.0f;
              _126 = _87;
              _127 = 0.0f;
              _128 = 0.0f;
              _129 = _88;
              _130 = 1.0f;
              _131 = 0.0f;
              _132 = _89;
              _133 = 0.0f;
              _134 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_70 > (_71 * 2.0f)) && ((_71 + _70) > _72)) {
                _120 = _71;
                _121 = min(max((_72 + 0.30000001192092896f), 0.0f), 1.0f);
                _122 = 0.0f;
                _123 = 1.0f;
                _124 = 0.0f;
                _125 = 1.0f;
                _126 = 1.0f;
                _127 = _90;
                _128 = 0.0f;
                _129 = 0.0f;
                _130 = _87;
                _131 = 0.0f;
                _132 = 0.0f;
                _133 = _91;
                _134 = 1.0f;
              } else {
                _120 = _71;
                _121 = _72;
                _122 = 0.0f;
                _123 = 1.0f;
                _124 = 0.0f;
                _125 = 1.0f;
                _126 = 1.0f;
                _127 = _90;
                _128 = 0.0f;
                _129 = 0.0f;
                _130 = _87;
                _131 = 0.0f;
                _132 = 0.0f;
                _133 = _91;
                _134 = 1.0f;
              }
            } else {
              _120 = _71;
              _121 = _72;
              _122 = 1.0f;
              _123 = 0.699999988079071f;
              _124 = 0.699999988079071f;
              _125 = 0.0f;
              _126 = 1.0f;
              _127 = 0.0f;
              _128 = (_86 * -0.012245000340044498f);
              _129 = 0.0f;
              _130 = 1.0f;
              _131 = (_86 * 0.07203499972820282f);
              _132 = 0.0f;
              _133 = 0.0f;
              _134 = _87;
            }
          }
          _137 = mad(4.11929988861084f, _72, mad(43.5161018371582f, _71, (_70 * 17.882400512695312f)));
          _140 = mad(3.8671000003814697f, _72, mad(27.155399322509766f, _71, (_70 * 3.455699920654297f)));
          _143 = mad(1.4670000076293945f, _72, mad(0.18431000411510468f, _71, (_70 * 0.02996000088751316f)));
          _146 = mad(_132, _143, mad(_129, _140, (_137 * _126)));
          _149 = mad(_133, _143, mad(_130, _140, (_137 * _127)));
          _152 = mad(_134, _143, mad(_131, _140, (_137 * _128)));
          _162 = _70 - mad(0.11670000106096268f, _152, mad(-0.13050000369548798f, _149, (_146 * 0.08089999854564667f)));
          _164 = _72 - mad(0.6934999823570251f, _152, mad(-0.004100000020116568f, _149, (_146 * -0.0003000000142492354f)));
          _167 = _162 * 0.699999988079071f;
          _227 = (mad(_124, _164, (_162 * _122)) + _70);
          _228 = (mad(_123, (_71 - mad(-0.1136000007390976f, _152, mad(0.05400000140070915f, _149, (_146 * -0.010200000368058681f)))), _167) + _120);
          _229 = (mad(_125, _164, _167) + _121);
        } while (false);
        break;
      }
      case 4: {
        if (((_70 > 0.25f) && (_71 < 0.550000011920929f)) && (_72 < 0.3199999928474426f)) {
          _182 = min(max((_70 + 0.20000000298023224f), 0.0f), 1.0f);
          _227 = _182;
          _228 = _182;
          _229 = (_72 * 0.25f);
        } else {
          _227 = _70;
          _228 = _71;
          _229 = _72;
        }
        break;
      }
      case 5: {
        _189 = ((_70 > 0.25f) && (_71 < 0.3199999928474426f)) && (_72 < 0.3199999928474426f);
        _227 = _70;
        _228 = select(_189, _70, _71);
        _229 = select(_189, (_72 * 0.25f), _72);
        break;
      }
      case 6: {
        if (((_70 > 0.25f) && (_71 < 0.27000001072883606f)) && (_72 < 0.27000001072883606f)) {
          _227 = ((_70 * 0.10000000149011612f) + 0.40400001406669617f);
          _228 = ((_71 * 0.10000000149011612f) + 0.2630000114440918f);
          _229 = min(max(((_72 * 0.10000000149011612f) + 0.906000018119812f), 0.0f), 1.0f);
        } else {
          _227 = _70;
          _228 = _71;
          _229 = _72;
        }
        break;
      }
      case 7: {
        if (((_70 < 0.3499999940395355f) && (_71 > 0.3499999940395355f)) && (_72 > 0.3499999940395355f)) {
          _227 = (_70 * 0.15000000596046448f);
          _228 = (_71 * 0.15000000596046448f);
          _229 = 0.2150000035762787f;
        } else {
          _227 = _70;
          _228 = _71;
          _229 = _72;
        }
        break;
      }
      case 8: {
        if (((_70 > 0.25f) && (_71 < 0.27000001072883606f)) && (_72 < 0.27000001072883606f)) {
          _227 = (_70 * 0.15000000596046448f);
          _228 = (_71 * 0.15000000596046448f);
          _229 = 0.2150000035762787f;
        } else {
          _227 = _70;
          _228 = _71;
          _229 = _72;
        }
        break;
      }
      default: {
        _227 = _70;
        _228 = _71;
        _229 = _72;
        break;
      }
    }
  } else {
    _227 = _70;
    _228 = _71;
    _229 = _72;
  }
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_227, _228, _229, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _384 = color.r;
    _385 = color.g;
    _386 = color.b;
#else  // original code
    _263 = saturate(select((_227 <= 0.040449999272823334f), (_227 * 0.07739938050508499f), exp2(log2(abs((_227 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _264 = saturate(select((_228 <= 0.040449999272823334f), (_228 * 0.07739938050508499f), exp2(log2(abs((_228 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _265 = saturate(select((_229 <= 0.040449999272823334f), (_229 * 0.07739938050508499f), exp2(log2(abs((_229 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _266 = dot(float3(_263, _264, _265), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _274 = select((_266 > 0.5f), (((_266 * HDROutput_016.y) / (HDROutput_016.y - _266)) + HDROutput_016.x), (_266 / (1.000100016593933f - _266)));
    _275 = _266 + 9.999999747378752e-05f;
    _279 = _274 * (_263 / _275);
    _280 = (_264 / _275) * _274;
    _281 = (_265 / _275) * _274;
    _297 = saturate(max(max(_279, _280), _281) + -1.0f);
    _304 = HDROutput_064 * 9.999999747378752e-05f;
    _311 = exp2(log2(abs(_304 * (((1.0f - _297) * mad(0.04331360012292862f, _281, mad(0.3292819857597351f, _280, (_279 * 0.627403974533081f)))) + (_297 * mad(0.047561999410390854f, _281, mad(0.19859300553798676f, _280, (_279 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _320 = exp2(log2(abs(((_311 * 18.8515625f) + 0.8359375f) / ((_311 * 18.6875f) + 1.0f))) * 78.84375f);
    _324 = exp2(log2(abs(_304 * mad(0.012477199546992779f, _281, mad(0.9417769908905029f, _280, (_279 * 0.045745600014925f))))) * 0.1593017578125f);
    _333 = exp2(log2(abs(((_324 * 18.8515625f) + 0.8359375f) / ((_324 * 18.6875f) + 1.0f))) * 78.84375f);
    _337 = exp2(log2(abs(_304 * mad(0.9836069941520691f, _281, mad(0.017604099586606026f, _280, (_279 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _346 = exp2(log2(abs(((_337 * 18.8515625f) + 0.8359375f) / ((_337 * 18.6875f) + 1.0f))) * 78.84375f);
    _355 = saturate(_320 / HDROutput_084);
    _356 = saturate(_333 / HDROutput_084);
    _357 = saturate(_346 / HDROutput_084);
    _358 = HDROutput_084 - HDROutput_036;
    _384 = select((_320 > HDROutput_076), _320, select((_320 < HDROutput_084), max((((_355 * _355) * _358) + HDROutput_036), _320), _320));
    _385 = select((_333 > HDROutput_076), _333, select((_333 < HDROutput_084), max((((_356 * _356) * _358) + HDROutput_036), _333), _333));
    _386 = select((_346 > HDROutput_076), _346, select((_346 < HDROutput_084), max((((_357 * _357) * _358) + HDROutput_036), _346), _346));
#endif
  } else {
    _384 = _227;
    _385 = _228;
    _386 = _229;
  }
  SV_Target.x = _384;
  SV_Target.y = _385;
  SV_Target.z = _386;
  SV_Target.w = ((select((FireUiPrimitive_396 != 0), 1.0f, (((float4)(t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y)))).y)) * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}