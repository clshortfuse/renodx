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
  float _80;
  float _81;
  float _82;
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
  float _143;
  float _144;
  float _145;
  float _238;
  float _239;
  float _240;
  float _395;
  float _396;
  float _397;
  float _97;
  float _98;
  float _99;
  float _100;
  float _101;
  float _102;
  float _148;
  float _151;
  float _154;
  float _157;
  float _160;
  float _163;
  float _173;
  float _175;
  float _178;
  float _193;
  bool _200;
  float _274;
  float _275;
  float _276;
  float _277;
  float _285;
  float _286;
  float _290;
  float _291;
  float _292;
  float _308;
  float _315;
  float _322;
  float _331;
  float _335;
  float _344;
  float _348;
  float _357;
  float _366;
  float _367;
  float _368;
  float _369;
  _19 = ((((float4)(t0.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y))))).x) > 0.10000000149011612f);
  if (_19) discard;
  _20 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _80 = (exp2(log2(abs((FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _20)) + _20) * cb0_836w), 0.0f), 64512.0f)) + FireUiPrimitive_000.x)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _81 = (exp2(log2(abs((FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _20)) + _20) * cb0_836w), 0.0f), 64512.0f)) + FireUiPrimitive_000.y)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _82 = (exp2(log2(abs((FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _20)) + _20) * cb0_836w), 0.0f), 64512.0f)) + FireUiPrimitive_000.z)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!((((_80 < 9.999999747378752e-05f) && (_81 < 9.999999747378752e-05f)) && (_82 < 9.999999747378752e-05f)) || ((uint)((int)((uint)(FireUiPrimitive_388) + (uint)(-1))) > (uint)7))) {
    switch ((int)(FireUiPrimitive_388)) {
      case 1: {
        _97 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _98 = 1.0f - _97;
        _99 = _97 * 2.023439884185791f;
        _100 = _97 * -2.5258100032806396f;
        _101 = _97 * 0.4941999912261963f;
        _102 = _97 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_80 > 0.5f) && ((_82 + _81) < 0.5f)) {
              _131 = min(max((_81 + 0.20000000298023224f), 0.0f), 1.0f);
              _132 = min(max((_82 + 0.20000000298023224f), 0.0f), 1.0f);
              _133 = 0.0f;
              _134 = 1.0f;
              _135 = 0.0f;
              _136 = 1.0f;
              _137 = _98;
              _138 = 0.0f;
              _139 = 0.0f;
              _140 = _99;
              _141 = 1.0f;
              _142 = 0.0f;
              _143 = _100;
              _144 = 0.0f;
              _145 = 1.0f;
            } else {
              _131 = _81;
              _132 = _82;
              _133 = 0.0f;
              _134 = 1.0f;
              _135 = 0.0f;
              _136 = 1.0f;
              _137 = _98;
              _138 = 0.0f;
              _139 = 0.0f;
              _140 = _99;
              _141 = 1.0f;
              _142 = 0.0f;
              _143 = _100;
              _144 = 0.0f;
              _145 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_80 > (_81 * 2.0f)) && ((_81 + _80) > _82)) {
                _131 = _81;
                _132 = min(max((_82 + 0.30000001192092896f), 0.0f), 1.0f);
                _133 = 0.0f;
                _134 = 1.0f;
                _135 = 0.0f;
                _136 = 1.0f;
                _137 = 1.0f;
                _138 = _101;
                _139 = 0.0f;
                _140 = 0.0f;
                _141 = _98;
                _142 = 0.0f;
                _143 = 0.0f;
                _144 = _102;
                _145 = 1.0f;
              } else {
                _131 = _81;
                _132 = _82;
                _133 = 0.0f;
                _134 = 1.0f;
                _135 = 0.0f;
                _136 = 1.0f;
                _137 = 1.0f;
                _138 = _101;
                _139 = 0.0f;
                _140 = 0.0f;
                _141 = _98;
                _142 = 0.0f;
                _143 = 0.0f;
                _144 = _102;
                _145 = 1.0f;
              }
            } else {
              _131 = _81;
              _132 = _82;
              _133 = 1.0f;
              _134 = 0.699999988079071f;
              _135 = 0.699999988079071f;
              _136 = 0.0f;
              _137 = 1.0f;
              _138 = 0.0f;
              _139 = (_97 * -0.012245000340044498f);
              _140 = 0.0f;
              _141 = 1.0f;
              _142 = (_97 * 0.07203499972820282f);
              _143 = 0.0f;
              _144 = 0.0f;
              _145 = _98;
            }
          }
          _148 = mad(4.11929988861084f, _82, mad(43.5161018371582f, _81, (_80 * 17.882400512695312f)));
          _151 = mad(3.8671000003814697f, _82, mad(27.155399322509766f, _81, (_80 * 3.455699920654297f)));
          _154 = mad(1.4670000076293945f, _82, mad(0.18431000411510468f, _81, (_80 * 0.02996000088751316f)));
          _157 = mad(_143, _154, mad(_140, _151, (_148 * _137)));
          _160 = mad(_144, _154, mad(_141, _151, (_148 * _138)));
          _163 = mad(_145, _154, mad(_142, _151, (_148 * _139)));
          _173 = _80 - mad(0.11670000106096268f, _163, mad(-0.13050000369548798f, _160, (_157 * 0.08089999854564667f)));
          _175 = _82 - mad(0.6934999823570251f, _163, mad(-0.004100000020116568f, _160, (_157 * -0.0003000000142492354f)));
          _178 = _173 * 0.699999988079071f;
          _238 = (mad(_135, _175, (_173 * _133)) + _80);
          _239 = (mad(_134, (_81 - mad(-0.1136000007390976f, _163, mad(0.05400000140070915f, _160, (_157 * -0.010200000368058681f)))), _178) + _131);
          _240 = (mad(_136, _175, _178) + _132);
        } while (false);
        break;
      }
      case 2: {
        _97 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _98 = 1.0f - _97;
        _99 = _97 * 2.023439884185791f;
        _100 = _97 * -2.5258100032806396f;
        _101 = _97 * 0.4941999912261963f;
        _102 = _97 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_80 > 0.5f) && ((_82 + _81) < 0.5f)) {
              _131 = min(max((_81 + 0.20000000298023224f), 0.0f), 1.0f);
              _132 = min(max((_82 + 0.20000000298023224f), 0.0f), 1.0f);
              _133 = 0.0f;
              _134 = 1.0f;
              _135 = 0.0f;
              _136 = 1.0f;
              _137 = _98;
              _138 = 0.0f;
              _139 = 0.0f;
              _140 = _99;
              _141 = 1.0f;
              _142 = 0.0f;
              _143 = _100;
              _144 = 0.0f;
              _145 = 1.0f;
            } else {
              _131 = _81;
              _132 = _82;
              _133 = 0.0f;
              _134 = 1.0f;
              _135 = 0.0f;
              _136 = 1.0f;
              _137 = _98;
              _138 = 0.0f;
              _139 = 0.0f;
              _140 = _99;
              _141 = 1.0f;
              _142 = 0.0f;
              _143 = _100;
              _144 = 0.0f;
              _145 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_80 > (_81 * 2.0f)) && ((_81 + _80) > _82)) {
                _131 = _81;
                _132 = min(max((_82 + 0.30000001192092896f), 0.0f), 1.0f);
                _133 = 0.0f;
                _134 = 1.0f;
                _135 = 0.0f;
                _136 = 1.0f;
                _137 = 1.0f;
                _138 = _101;
                _139 = 0.0f;
                _140 = 0.0f;
                _141 = _98;
                _142 = 0.0f;
                _143 = 0.0f;
                _144 = _102;
                _145 = 1.0f;
              } else {
                _131 = _81;
                _132 = _82;
                _133 = 0.0f;
                _134 = 1.0f;
                _135 = 0.0f;
                _136 = 1.0f;
                _137 = 1.0f;
                _138 = _101;
                _139 = 0.0f;
                _140 = 0.0f;
                _141 = _98;
                _142 = 0.0f;
                _143 = 0.0f;
                _144 = _102;
                _145 = 1.0f;
              }
            } else {
              _131 = _81;
              _132 = _82;
              _133 = 1.0f;
              _134 = 0.699999988079071f;
              _135 = 0.699999988079071f;
              _136 = 0.0f;
              _137 = 1.0f;
              _138 = 0.0f;
              _139 = (_97 * -0.012245000340044498f);
              _140 = 0.0f;
              _141 = 1.0f;
              _142 = (_97 * 0.07203499972820282f);
              _143 = 0.0f;
              _144 = 0.0f;
              _145 = _98;
            }
          }
          _148 = mad(4.11929988861084f, _82, mad(43.5161018371582f, _81, (_80 * 17.882400512695312f)));
          _151 = mad(3.8671000003814697f, _82, mad(27.155399322509766f, _81, (_80 * 3.455699920654297f)));
          _154 = mad(1.4670000076293945f, _82, mad(0.18431000411510468f, _81, (_80 * 0.02996000088751316f)));
          _157 = mad(_143, _154, mad(_140, _151, (_148 * _137)));
          _160 = mad(_144, _154, mad(_141, _151, (_148 * _138)));
          _163 = mad(_145, _154, mad(_142, _151, (_148 * _139)));
          _173 = _80 - mad(0.11670000106096268f, _163, mad(-0.13050000369548798f, _160, (_157 * 0.08089999854564667f)));
          _175 = _82 - mad(0.6934999823570251f, _163, mad(-0.004100000020116568f, _160, (_157 * -0.0003000000142492354f)));
          _178 = _173 * 0.699999988079071f;
          _238 = (mad(_135, _175, (_173 * _133)) + _80);
          _239 = (mad(_134, (_81 - mad(-0.1136000007390976f, _163, mad(0.05400000140070915f, _160, (_157 * -0.010200000368058681f)))), _178) + _131);
          _240 = (mad(_136, _175, _178) + _132);
        } while (false);
        break;
      }
      case 3: {
        _97 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _98 = 1.0f - _97;
        _99 = _97 * 2.023439884185791f;
        _100 = _97 * -2.5258100032806396f;
        _101 = _97 * 0.4941999912261963f;
        _102 = _97 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_80 > 0.5f) && ((_82 + _81) < 0.5f)) {
              _131 = min(max((_81 + 0.20000000298023224f), 0.0f), 1.0f);
              _132 = min(max((_82 + 0.20000000298023224f), 0.0f), 1.0f);
              _133 = 0.0f;
              _134 = 1.0f;
              _135 = 0.0f;
              _136 = 1.0f;
              _137 = _98;
              _138 = 0.0f;
              _139 = 0.0f;
              _140 = _99;
              _141 = 1.0f;
              _142 = 0.0f;
              _143 = _100;
              _144 = 0.0f;
              _145 = 1.0f;
            } else {
              _131 = _81;
              _132 = _82;
              _133 = 0.0f;
              _134 = 1.0f;
              _135 = 0.0f;
              _136 = 1.0f;
              _137 = _98;
              _138 = 0.0f;
              _139 = 0.0f;
              _140 = _99;
              _141 = 1.0f;
              _142 = 0.0f;
              _143 = _100;
              _144 = 0.0f;
              _145 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_80 > (_81 * 2.0f)) && ((_81 + _80) > _82)) {
                _131 = _81;
                _132 = min(max((_82 + 0.30000001192092896f), 0.0f), 1.0f);
                _133 = 0.0f;
                _134 = 1.0f;
                _135 = 0.0f;
                _136 = 1.0f;
                _137 = 1.0f;
                _138 = _101;
                _139 = 0.0f;
                _140 = 0.0f;
                _141 = _98;
                _142 = 0.0f;
                _143 = 0.0f;
                _144 = _102;
                _145 = 1.0f;
              } else {
                _131 = _81;
                _132 = _82;
                _133 = 0.0f;
                _134 = 1.0f;
                _135 = 0.0f;
                _136 = 1.0f;
                _137 = 1.0f;
                _138 = _101;
                _139 = 0.0f;
                _140 = 0.0f;
                _141 = _98;
                _142 = 0.0f;
                _143 = 0.0f;
                _144 = _102;
                _145 = 1.0f;
              }
            } else {
              _131 = _81;
              _132 = _82;
              _133 = 1.0f;
              _134 = 0.699999988079071f;
              _135 = 0.699999988079071f;
              _136 = 0.0f;
              _137 = 1.0f;
              _138 = 0.0f;
              _139 = (_97 * -0.012245000340044498f);
              _140 = 0.0f;
              _141 = 1.0f;
              _142 = (_97 * 0.07203499972820282f);
              _143 = 0.0f;
              _144 = 0.0f;
              _145 = _98;
            }
          }
          _148 = mad(4.11929988861084f, _82, mad(43.5161018371582f, _81, (_80 * 17.882400512695312f)));
          _151 = mad(3.8671000003814697f, _82, mad(27.155399322509766f, _81, (_80 * 3.455699920654297f)));
          _154 = mad(1.4670000076293945f, _82, mad(0.18431000411510468f, _81, (_80 * 0.02996000088751316f)));
          _157 = mad(_143, _154, mad(_140, _151, (_148 * _137)));
          _160 = mad(_144, _154, mad(_141, _151, (_148 * _138)));
          _163 = mad(_145, _154, mad(_142, _151, (_148 * _139)));
          _173 = _80 - mad(0.11670000106096268f, _163, mad(-0.13050000369548798f, _160, (_157 * 0.08089999854564667f)));
          _175 = _82 - mad(0.6934999823570251f, _163, mad(-0.004100000020116568f, _160, (_157 * -0.0003000000142492354f)));
          _178 = _173 * 0.699999988079071f;
          _238 = (mad(_135, _175, (_173 * _133)) + _80);
          _239 = (mad(_134, (_81 - mad(-0.1136000007390976f, _163, mad(0.05400000140070915f, _160, (_157 * -0.010200000368058681f)))), _178) + _131);
          _240 = (mad(_136, _175, _178) + _132);
        } while (false);
        break;
      }
      case 4: {
        if (((_80 > 0.25f) && (_81 < 0.550000011920929f)) && (_82 < 0.3199999928474426f)) {
          _193 = min(max((_80 + 0.20000000298023224f), 0.0f), 1.0f);
          _238 = _193;
          _239 = _193;
          _240 = (_82 * 0.25f);
        } else {
          _238 = _80;
          _239 = _81;
          _240 = _82;
        }
        break;
      }
      case 5: {
        _200 = ((_80 > 0.25f) && (_81 < 0.3199999928474426f)) && (_82 < 0.3199999928474426f);
        _238 = _80;
        _239 = select(_200, _80, _81);
        _240 = select(_200, (_82 * 0.25f), _82);
        break;
      }
      case 6: {
        if (((_80 > 0.25f) && (_81 < 0.27000001072883606f)) && (_82 < 0.27000001072883606f)) {
          _238 = ((_80 * 0.10000000149011612f) + 0.40400001406669617f);
          _239 = ((_81 * 0.10000000149011612f) + 0.2630000114440918f);
          _240 = min(max(((_82 * 0.10000000149011612f) + 0.906000018119812f), 0.0f), 1.0f);
        } else {
          _238 = _80;
          _239 = _81;
          _240 = _82;
        }
        break;
      }
      case 7: {
        if (((_80 < 0.3499999940395355f) && (_81 > 0.3499999940395355f)) && (_82 > 0.3499999940395355f)) {
          _238 = (_80 * 0.15000000596046448f);
          _239 = (_81 * 0.15000000596046448f);
          _240 = 0.2150000035762787f;
        } else {
          _238 = _80;
          _239 = _81;
          _240 = _82;
        }
        break;
      }
      case 8: {
        if (((_80 > 0.25f) && (_81 < 0.27000001072883606f)) && (_82 < 0.27000001072883606f)) {
          _238 = (_80 * 0.15000000596046448f);
          _239 = (_81 * 0.15000000596046448f);
          _240 = 0.2150000035762787f;
        } else {
          _238 = _80;
          _239 = _81;
          _240 = _82;
        }
        break;
      }
      default: {
        _238 = _80;
        _239 = _81;
        _240 = _82;
        break;
      }
    }
  } else {
    _238 = _80;
    _239 = _81;
    _240 = _82;
  }
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_238, _239, _240, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _395 = color.r;
    _396 = color.g;
    _397 = color.b;
#else  // original code
    _274 = saturate(select((_238 <= 0.040449999272823334f), (_238 * 0.07739938050508499f), exp2(log2(abs((_238 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _275 = saturate(select((_239 <= 0.040449999272823334f), (_239 * 0.07739938050508499f), exp2(log2(abs((_239 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _276 = saturate(select((_240 <= 0.040449999272823334f), (_240 * 0.07739938050508499f), exp2(log2(abs((_240 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _277 = dot(float3(_274, _275, _276), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _285 = select((_277 > 0.5f), (((_277 * HDROutput_016.y) / (HDROutput_016.y - _277)) + HDROutput_016.x), (_277 / (1.000100016593933f - _277)));
    _286 = _277 + 9.999999747378752e-05f;
    _290 = _285 * (_274 / _286);
    _291 = (_275 / _286) * _285;
    _292 = (_276 / _286) * _285;
    _308 = saturate(max(max(_290, _291), _292) + -1.0f);
    _315 = HDROutput_064 * 9.999999747378752e-05f;
    _322 = exp2(log2(abs(_315 * (((1.0f - _308) * mad(0.04331360012292862f, _292, mad(0.3292819857597351f, _291, (_290 * 0.627403974533081f)))) + (_308 * mad(0.047561999410390854f, _292, mad(0.19859300553798676f, _291, (_290 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _331 = exp2(log2(abs(((_322 * 18.8515625f) + 0.8359375f) / ((_322 * 18.6875f) + 1.0f))) * 78.84375f);
    _335 = exp2(log2(abs(_315 * mad(0.012477199546992779f, _292, mad(0.9417769908905029f, _291, (_290 * 0.045745600014925f))))) * 0.1593017578125f);
    _344 = exp2(log2(abs(((_335 * 18.8515625f) + 0.8359375f) / ((_335 * 18.6875f) + 1.0f))) * 78.84375f);
    _348 = exp2(log2(abs(_315 * mad(0.9836069941520691f, _292, mad(0.017604099586606026f, _291, (_290 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _357 = exp2(log2(abs(((_348 * 18.8515625f) + 0.8359375f) / ((_348 * 18.6875f) + 1.0f))) * 78.84375f);
    _366 = saturate(_331 / HDROutput_084);
    _367 = saturate(_344 / HDROutput_084);
    _368 = saturate(_357 / HDROutput_084);
    _369 = HDROutput_084 - HDROutput_036;
    _395 = select((_331 > HDROutput_076), _331, select((_331 < HDROutput_084), max((((_366 * _366) * _369) + HDROutput_036), _331), _331));
    _396 = select((_344 > HDROutput_076), _344, select((_344 < HDROutput_084), max((((_367 * _367) * _369) + HDROutput_036), _344), _344));
    _397 = select((_357 > HDROutput_076), _357, select((_357 < HDROutput_084), max((((_368 * _368) * _369) + HDROutput_036), _357), _357));
#endif
  } else {
    _395 = _238;
    _396 = _239;
    _397 = _240;
  }
  SV_Target.x = _395;
  SV_Target.y = _396;
  SV_Target.z = _397;
  SV_Target.w = ((FireUiPrimitive_016.w * TEXCOORD0_centroid.w) + FireUiPrimitive_000.w);
  return SV_Target;
}