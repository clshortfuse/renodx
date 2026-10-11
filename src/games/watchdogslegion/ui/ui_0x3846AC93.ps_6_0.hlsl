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
  float4 _12;
  bool _19;
  float _23;
  float _24;
  float _25;
  float _27;
  float _78;
  float _79;
  float _80;
  float _128;
  float _129;
  float _130;
  float _131;
  float _132;
  float _133;
  float _134;
  float _135;
  float _136;
  float _137;
  float _138;
  float _139;
  float _140;
  float _141;
  float _142;
  float _235;
  float _236;
  float _237;
  float _392;
  float _393;
  float _394;
  float _94;
  float _95;
  float _96;
  float _97;
  float _98;
  float _99;
  float _145;
  float _148;
  float _151;
  float _154;
  float _157;
  float _160;
  float _170;
  float _172;
  float _175;
  float _190;
  bool _197;
  float _271;
  float _272;
  float _273;
  float _274;
  float _282;
  float _283;
  float _287;
  float _288;
  float _289;
  float _305;
  float _312;
  float _319;
  float _328;
  float _332;
  float _341;
  float _345;
  float _354;
  float _363;
  float _364;
  float _365;
  float _366;
  _12 = t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _19 = (FireUiPrimitive_396 != 0);
  _23 = select(_19, 1.0f, _12.x) * TEXCOORD0_centroid.x;
  _24 = select(_19, 1.0f, _12.y) * TEXCOORD0_centroid.y;
  _25 = select(_19, 1.0f, _12.z) * TEXCOORD0_centroid.z;
  _27 = dot(float3(_23, _24, _25), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _78 = (exp2(log2(abs(FireUiPrimitive_016.x * min(max(((lerp(_27, _23, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _79 = (exp2(log2(abs(FireUiPrimitive_016.y * min(max(((lerp(_27, _24, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _80 = (exp2(log2(abs(FireUiPrimitive_016.z * min(max(((lerp(_27, _25, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!((((_78 < 9.999999747378752e-05f) && (_79 < 9.999999747378752e-05f)) && (_80 < 9.999999747378752e-05f)) || ((uint)((int)((uint)(FireUiPrimitive_388) + (uint)(-1))) > (uint)7))) {
    switch ((int)(FireUiPrimitive_388)) {
      case 1: {
        _94 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _95 = 1.0f - _94;
        _96 = _94 * 2.023439884185791f;
        _97 = _94 * -2.5258100032806396f;
        _98 = _94 * 0.4941999912261963f;
        _99 = _94 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_78 > 0.5f) && ((_80 + _79) < 0.5f)) {
              _128 = min(max((_79 + 0.20000000298023224f), 0.0f), 1.0f);
              _129 = min(max((_80 + 0.20000000298023224f), 0.0f), 1.0f);
              _130 = 0.0f;
              _131 = 1.0f;
              _132 = 0.0f;
              _133 = 1.0f;
              _134 = _95;
              _135 = 0.0f;
              _136 = 0.0f;
              _137 = _96;
              _138 = 1.0f;
              _139 = 0.0f;
              _140 = _97;
              _141 = 0.0f;
              _142 = 1.0f;
            } else {
              _128 = _79;
              _129 = _80;
              _130 = 0.0f;
              _131 = 1.0f;
              _132 = 0.0f;
              _133 = 1.0f;
              _134 = _95;
              _135 = 0.0f;
              _136 = 0.0f;
              _137 = _96;
              _138 = 1.0f;
              _139 = 0.0f;
              _140 = _97;
              _141 = 0.0f;
              _142 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_78 > (_79 * 2.0f)) && ((_79 + _78) > _80)) {
                _128 = _79;
                _129 = min(max((_80 + 0.30000001192092896f), 0.0f), 1.0f);
                _130 = 0.0f;
                _131 = 1.0f;
                _132 = 0.0f;
                _133 = 1.0f;
                _134 = 1.0f;
                _135 = _98;
                _136 = 0.0f;
                _137 = 0.0f;
                _138 = _95;
                _139 = 0.0f;
                _140 = 0.0f;
                _141 = _99;
                _142 = 1.0f;
              } else {
                _128 = _79;
                _129 = _80;
                _130 = 0.0f;
                _131 = 1.0f;
                _132 = 0.0f;
                _133 = 1.0f;
                _134 = 1.0f;
                _135 = _98;
                _136 = 0.0f;
                _137 = 0.0f;
                _138 = _95;
                _139 = 0.0f;
                _140 = 0.0f;
                _141 = _99;
                _142 = 1.0f;
              }
            } else {
              _128 = _79;
              _129 = _80;
              _130 = 1.0f;
              _131 = 0.699999988079071f;
              _132 = 0.699999988079071f;
              _133 = 0.0f;
              _134 = 1.0f;
              _135 = 0.0f;
              _136 = (_94 * -0.012245000340044498f);
              _137 = 0.0f;
              _138 = 1.0f;
              _139 = (_94 * 0.07203499972820282f);
              _140 = 0.0f;
              _141 = 0.0f;
              _142 = _95;
            }
          }
          _145 = mad(4.11929988861084f, _80, mad(43.5161018371582f, _79, (_78 * 17.882400512695312f)));
          _148 = mad(3.8671000003814697f, _80, mad(27.155399322509766f, _79, (_78 * 3.455699920654297f)));
          _151 = mad(1.4670000076293945f, _80, mad(0.18431000411510468f, _79, (_78 * 0.02996000088751316f)));
          _154 = mad(_140, _151, mad(_137, _148, (_145 * _134)));
          _157 = mad(_141, _151, mad(_138, _148, (_145 * _135)));
          _160 = mad(_142, _151, mad(_139, _148, (_145 * _136)));
          _170 = _78 - mad(0.11670000106096268f, _160, mad(-0.13050000369548798f, _157, (_154 * 0.08089999854564667f)));
          _172 = _80 - mad(0.6934999823570251f, _160, mad(-0.004100000020116568f, _157, (_154 * -0.0003000000142492354f)));
          _175 = _170 * 0.699999988079071f;
          _235 = (mad(_132, _172, (_170 * _130)) + _78);
          _236 = (mad(_131, (_79 - mad(-0.1136000007390976f, _160, mad(0.05400000140070915f, _157, (_154 * -0.010200000368058681f)))), _175) + _128);
          _237 = (mad(_133, _172, _175) + _129);
        } while (false);
        break;
      }
      case 2: {
        _94 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _95 = 1.0f - _94;
        _96 = _94 * 2.023439884185791f;
        _97 = _94 * -2.5258100032806396f;
        _98 = _94 * 0.4941999912261963f;
        _99 = _94 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_78 > 0.5f) && ((_80 + _79) < 0.5f)) {
              _128 = min(max((_79 + 0.20000000298023224f), 0.0f), 1.0f);
              _129 = min(max((_80 + 0.20000000298023224f), 0.0f), 1.0f);
              _130 = 0.0f;
              _131 = 1.0f;
              _132 = 0.0f;
              _133 = 1.0f;
              _134 = _95;
              _135 = 0.0f;
              _136 = 0.0f;
              _137 = _96;
              _138 = 1.0f;
              _139 = 0.0f;
              _140 = _97;
              _141 = 0.0f;
              _142 = 1.0f;
            } else {
              _128 = _79;
              _129 = _80;
              _130 = 0.0f;
              _131 = 1.0f;
              _132 = 0.0f;
              _133 = 1.0f;
              _134 = _95;
              _135 = 0.0f;
              _136 = 0.0f;
              _137 = _96;
              _138 = 1.0f;
              _139 = 0.0f;
              _140 = _97;
              _141 = 0.0f;
              _142 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_78 > (_79 * 2.0f)) && ((_79 + _78) > _80)) {
                _128 = _79;
                _129 = min(max((_80 + 0.30000001192092896f), 0.0f), 1.0f);
                _130 = 0.0f;
                _131 = 1.0f;
                _132 = 0.0f;
                _133 = 1.0f;
                _134 = 1.0f;
                _135 = _98;
                _136 = 0.0f;
                _137 = 0.0f;
                _138 = _95;
                _139 = 0.0f;
                _140 = 0.0f;
                _141 = _99;
                _142 = 1.0f;
              } else {
                _128 = _79;
                _129 = _80;
                _130 = 0.0f;
                _131 = 1.0f;
                _132 = 0.0f;
                _133 = 1.0f;
                _134 = 1.0f;
                _135 = _98;
                _136 = 0.0f;
                _137 = 0.0f;
                _138 = _95;
                _139 = 0.0f;
                _140 = 0.0f;
                _141 = _99;
                _142 = 1.0f;
              }
            } else {
              _128 = _79;
              _129 = _80;
              _130 = 1.0f;
              _131 = 0.699999988079071f;
              _132 = 0.699999988079071f;
              _133 = 0.0f;
              _134 = 1.0f;
              _135 = 0.0f;
              _136 = (_94 * -0.012245000340044498f);
              _137 = 0.0f;
              _138 = 1.0f;
              _139 = (_94 * 0.07203499972820282f);
              _140 = 0.0f;
              _141 = 0.0f;
              _142 = _95;
            }
          }
          _145 = mad(4.11929988861084f, _80, mad(43.5161018371582f, _79, (_78 * 17.882400512695312f)));
          _148 = mad(3.8671000003814697f, _80, mad(27.155399322509766f, _79, (_78 * 3.455699920654297f)));
          _151 = mad(1.4670000076293945f, _80, mad(0.18431000411510468f, _79, (_78 * 0.02996000088751316f)));
          _154 = mad(_140, _151, mad(_137, _148, (_145 * _134)));
          _157 = mad(_141, _151, mad(_138, _148, (_145 * _135)));
          _160 = mad(_142, _151, mad(_139, _148, (_145 * _136)));
          _170 = _78 - mad(0.11670000106096268f, _160, mad(-0.13050000369548798f, _157, (_154 * 0.08089999854564667f)));
          _172 = _80 - mad(0.6934999823570251f, _160, mad(-0.004100000020116568f, _157, (_154 * -0.0003000000142492354f)));
          _175 = _170 * 0.699999988079071f;
          _235 = (mad(_132, _172, (_170 * _130)) + _78);
          _236 = (mad(_131, (_79 - mad(-0.1136000007390976f, _160, mad(0.05400000140070915f, _157, (_154 * -0.010200000368058681f)))), _175) + _128);
          _237 = (mad(_133, _172, _175) + _129);
        } while (false);
        break;
      }
      case 3: {
        _94 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _95 = 1.0f - _94;
        _96 = _94 * 2.023439884185791f;
        _97 = _94 * -2.5258100032806396f;
        _98 = _94 * 0.4941999912261963f;
        _99 = _94 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_78 > 0.5f) && ((_80 + _79) < 0.5f)) {
              _128 = min(max((_79 + 0.20000000298023224f), 0.0f), 1.0f);
              _129 = min(max((_80 + 0.20000000298023224f), 0.0f), 1.0f);
              _130 = 0.0f;
              _131 = 1.0f;
              _132 = 0.0f;
              _133 = 1.0f;
              _134 = _95;
              _135 = 0.0f;
              _136 = 0.0f;
              _137 = _96;
              _138 = 1.0f;
              _139 = 0.0f;
              _140 = _97;
              _141 = 0.0f;
              _142 = 1.0f;
            } else {
              _128 = _79;
              _129 = _80;
              _130 = 0.0f;
              _131 = 1.0f;
              _132 = 0.0f;
              _133 = 1.0f;
              _134 = _95;
              _135 = 0.0f;
              _136 = 0.0f;
              _137 = _96;
              _138 = 1.0f;
              _139 = 0.0f;
              _140 = _97;
              _141 = 0.0f;
              _142 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_78 > (_79 * 2.0f)) && ((_79 + _78) > _80)) {
                _128 = _79;
                _129 = min(max((_80 + 0.30000001192092896f), 0.0f), 1.0f);
                _130 = 0.0f;
                _131 = 1.0f;
                _132 = 0.0f;
                _133 = 1.0f;
                _134 = 1.0f;
                _135 = _98;
                _136 = 0.0f;
                _137 = 0.0f;
                _138 = _95;
                _139 = 0.0f;
                _140 = 0.0f;
                _141 = _99;
                _142 = 1.0f;
              } else {
                _128 = _79;
                _129 = _80;
                _130 = 0.0f;
                _131 = 1.0f;
                _132 = 0.0f;
                _133 = 1.0f;
                _134 = 1.0f;
                _135 = _98;
                _136 = 0.0f;
                _137 = 0.0f;
                _138 = _95;
                _139 = 0.0f;
                _140 = 0.0f;
                _141 = _99;
                _142 = 1.0f;
              }
            } else {
              _128 = _79;
              _129 = _80;
              _130 = 1.0f;
              _131 = 0.699999988079071f;
              _132 = 0.699999988079071f;
              _133 = 0.0f;
              _134 = 1.0f;
              _135 = 0.0f;
              _136 = (_94 * -0.012245000340044498f);
              _137 = 0.0f;
              _138 = 1.0f;
              _139 = (_94 * 0.07203499972820282f);
              _140 = 0.0f;
              _141 = 0.0f;
              _142 = _95;
            }
          }
          _145 = mad(4.11929988861084f, _80, mad(43.5161018371582f, _79, (_78 * 17.882400512695312f)));
          _148 = mad(3.8671000003814697f, _80, mad(27.155399322509766f, _79, (_78 * 3.455699920654297f)));
          _151 = mad(1.4670000076293945f, _80, mad(0.18431000411510468f, _79, (_78 * 0.02996000088751316f)));
          _154 = mad(_140, _151, mad(_137, _148, (_145 * _134)));
          _157 = mad(_141, _151, mad(_138, _148, (_145 * _135)));
          _160 = mad(_142, _151, mad(_139, _148, (_145 * _136)));
          _170 = _78 - mad(0.11670000106096268f, _160, mad(-0.13050000369548798f, _157, (_154 * 0.08089999854564667f)));
          _172 = _80 - mad(0.6934999823570251f, _160, mad(-0.004100000020116568f, _157, (_154 * -0.0003000000142492354f)));
          _175 = _170 * 0.699999988079071f;
          _235 = (mad(_132, _172, (_170 * _130)) + _78);
          _236 = (mad(_131, (_79 - mad(-0.1136000007390976f, _160, mad(0.05400000140070915f, _157, (_154 * -0.010200000368058681f)))), _175) + _128);
          _237 = (mad(_133, _172, _175) + _129);
        } while (false);
        break;
      }
      case 4: {
        if (((_78 > 0.25f) && (_79 < 0.550000011920929f)) && (_80 < 0.3199999928474426f)) {
          _190 = min(max((_78 + 0.20000000298023224f), 0.0f), 1.0f);
          _235 = _190;
          _236 = _190;
          _237 = (_80 * 0.25f);
        } else {
          _235 = _78;
          _236 = _79;
          _237 = _80;
        }
        break;
      }
      case 5: {
        _197 = ((_78 > 0.25f) && (_79 < 0.3199999928474426f)) && (_80 < 0.3199999928474426f);
        _235 = _78;
        _236 = select(_197, _78, _79);
        _237 = select(_197, (_80 * 0.25f), _80);
        break;
      }
      case 6: {
        if (((_78 > 0.25f) && (_79 < 0.27000001072883606f)) && (_80 < 0.27000001072883606f)) {
          _235 = ((_78 * 0.10000000149011612f) + 0.40400001406669617f);
          _236 = ((_79 * 0.10000000149011612f) + 0.2630000114440918f);
          _237 = min(max(((_80 * 0.10000000149011612f) + 0.906000018119812f), 0.0f), 1.0f);
        } else {
          _235 = _78;
          _236 = _79;
          _237 = _80;
        }
        break;
      }
      case 7: {
        if (((_78 < 0.3499999940395355f) && (_79 > 0.3499999940395355f)) && (_80 > 0.3499999940395355f)) {
          _235 = (_78 * 0.15000000596046448f);
          _236 = (_79 * 0.15000000596046448f);
          _237 = 0.2150000035762787f;
        } else {
          _235 = _78;
          _236 = _79;
          _237 = _80;
        }
        break;
      }
      case 8: {
        if (((_78 > 0.25f) && (_79 < 0.27000001072883606f)) && (_80 < 0.27000001072883606f)) {
          _235 = (_78 * 0.15000000596046448f);
          _236 = (_79 * 0.15000000596046448f);
          _237 = 0.2150000035762787f;
        } else {
          _235 = _78;
          _236 = _79;
          _237 = _80;
        }
        break;
      }
      default: {
        _235 = _78;
        _236 = _79;
        _237 = _80;
        break;
      }
    }
  } else {
    _235 = _78;
    _236 = _79;
    _237 = _80;
  }
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_235, _236, _237, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _392 = color.r;
    _393 = color.g;
    _394 = color.b;
#else  // original code
    _271 = saturate(select((_235 <= 0.040449999272823334f), (_235 * 0.07739938050508499f), exp2(log2(abs((_235 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _272 = saturate(select((_236 <= 0.040449999272823334f), (_236 * 0.07739938050508499f), exp2(log2(abs((_236 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _273 = saturate(select((_237 <= 0.040449999272823334f), (_237 * 0.07739938050508499f), exp2(log2(abs((_237 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _274 = dot(float3(_271, _272, _273), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _282 = select((_274 > 0.5f), (((_274 * HDROutput_016.y) / (HDROutput_016.y - _274)) + HDROutput_016.x), (_274 / (1.000100016593933f - _274)));
    _283 = _274 + 9.999999747378752e-05f;
    _287 = _282 * (_271 / _283);
    _288 = (_272 / _283) * _282;
    _289 = (_273 / _283) * _282;
    _305 = saturate(max(max(_287, _288), _289) + -1.0f);
    _312 = HDROutput_064 * 9.999999747378752e-05f;
    _319 = exp2(log2(abs(_312 * (((1.0f - _305) * mad(0.04331360012292862f, _289, mad(0.3292819857597351f, _288, (_287 * 0.627403974533081f)))) + (_305 * mad(0.047561999410390854f, _289, mad(0.19859300553798676f, _288, (_287 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _328 = exp2(log2(abs(((_319 * 18.8515625f) + 0.8359375f) / ((_319 * 18.6875f) + 1.0f))) * 78.84375f);
    _332 = exp2(log2(abs(_312 * mad(0.012477199546992779f, _289, mad(0.9417769908905029f, _288, (_287 * 0.045745600014925f))))) * 0.1593017578125f);
    _341 = exp2(log2(abs(((_332 * 18.8515625f) + 0.8359375f) / ((_332 * 18.6875f) + 1.0f))) * 78.84375f);
    _345 = exp2(log2(abs(_312 * mad(0.9836069941520691f, _289, mad(0.017604099586606026f, _288, (_287 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _354 = exp2(log2(abs(((_345 * 18.8515625f) + 0.8359375f) / ((_345 * 18.6875f) + 1.0f))) * 78.84375f);
    _363 = saturate(_328 / HDROutput_084);
    _364 = saturate(_341 / HDROutput_084);
    _365 = saturate(_354 / HDROutput_084);
    _366 = HDROutput_084 - HDROutput_036;
    _392 = select((_328 > HDROutput_076), _328, select((_328 < HDROutput_084), max((((_363 * _363) * _366) + HDROutput_036), _328), _328));
    _393 = select((_341 > HDROutput_076), _341, select((_341 < HDROutput_084), max((((_364 * _364) * _366) + HDROutput_036), _341), _341));
    _394 = select((_354 > HDROutput_076), _354, select((_354 < HDROutput_084), max((((_365 * _365) * _366) + HDROutput_036), _354), _354));
#endif
  } else {
    _392 = _235;
    _393 = _236;
    _394 = _237;
  }
  SV_Target.x = _392;
  SV_Target.y = _393;
  SV_Target.z = _394;
  SV_Target.w = ((_12.w * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}