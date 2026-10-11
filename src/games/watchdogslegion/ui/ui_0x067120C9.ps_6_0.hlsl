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
  float _31;
  float _82;
  float _83;
  float _84;
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
  float _146;
  float _239;
  float _240;
  float _241;
  float _396;
  float _397;
  float _398;
  float _98;
  float _99;
  float _100;
  float _101;
  float _102;
  float _103;
  float _149;
  float _152;
  float _155;
  float _158;
  float _161;
  float _164;
  float _174;
  float _176;
  float _179;
  float _194;
  bool _201;
  float _275;
  float _276;
  float _277;
  float _278;
  float _286;
  float _287;
  float _291;
  float _292;
  float _293;
  float _309;
  float _316;
  float _323;
  float _332;
  float _336;
  float _345;
  float _349;
  float _358;
  float _367;
  float _368;
  float _369;
  float _370;
  _23 = ((((float4)(t1.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y))))).x) > 0.10000000149011612f);
  if (_23) discard;
  _31 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _82 = (exp2(log2(abs(FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _31)) + _31) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _83 = (exp2(log2(abs(FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _31)) + _31) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _84 = (exp2(log2(abs(FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _31)) + _31) * cb0_836w), 0.0f), 64512.0f))) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!((((_82 < 9.999999747378752e-05f) && (_83 < 9.999999747378752e-05f)) && (_84 < 9.999999747378752e-05f)) || ((uint)((int)((uint)(FireUiPrimitive_388) + (uint)(-1))) > (uint)7))) {
    switch ((int)(FireUiPrimitive_388)) {
      case 1: {
        _98 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _99 = 1.0f - _98;
        _100 = _98 * 2.023439884185791f;
        _101 = _98 * -2.5258100032806396f;
        _102 = _98 * 0.4941999912261963f;
        _103 = _98 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_82 > 0.5f) && ((_84 + _83) < 0.5f)) {
              _132 = min(max((_83 + 0.20000000298023224f), 0.0f), 1.0f);
              _133 = min(max((_84 + 0.20000000298023224f), 0.0f), 1.0f);
              _134 = 0.0f;
              _135 = 1.0f;
              _136 = 0.0f;
              _137 = 1.0f;
              _138 = _99;
              _139 = 0.0f;
              _140 = 0.0f;
              _141 = _100;
              _142 = 1.0f;
              _143 = 0.0f;
              _144 = _101;
              _145 = 0.0f;
              _146 = 1.0f;
            } else {
              _132 = _83;
              _133 = _84;
              _134 = 0.0f;
              _135 = 1.0f;
              _136 = 0.0f;
              _137 = 1.0f;
              _138 = _99;
              _139 = 0.0f;
              _140 = 0.0f;
              _141 = _100;
              _142 = 1.0f;
              _143 = 0.0f;
              _144 = _101;
              _145 = 0.0f;
              _146 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_82 > (_83 * 2.0f)) && ((_83 + _82) > _84)) {
                _132 = _83;
                _133 = min(max((_84 + 0.30000001192092896f), 0.0f), 1.0f);
                _134 = 0.0f;
                _135 = 1.0f;
                _136 = 0.0f;
                _137 = 1.0f;
                _138 = 1.0f;
                _139 = _102;
                _140 = 0.0f;
                _141 = 0.0f;
                _142 = _99;
                _143 = 0.0f;
                _144 = 0.0f;
                _145 = _103;
                _146 = 1.0f;
              } else {
                _132 = _83;
                _133 = _84;
                _134 = 0.0f;
                _135 = 1.0f;
                _136 = 0.0f;
                _137 = 1.0f;
                _138 = 1.0f;
                _139 = _102;
                _140 = 0.0f;
                _141 = 0.0f;
                _142 = _99;
                _143 = 0.0f;
                _144 = 0.0f;
                _145 = _103;
                _146 = 1.0f;
              }
            } else {
              _132 = _83;
              _133 = _84;
              _134 = 1.0f;
              _135 = 0.699999988079071f;
              _136 = 0.699999988079071f;
              _137 = 0.0f;
              _138 = 1.0f;
              _139 = 0.0f;
              _140 = (_98 * -0.012245000340044498f);
              _141 = 0.0f;
              _142 = 1.0f;
              _143 = (_98 * 0.07203499972820282f);
              _144 = 0.0f;
              _145 = 0.0f;
              _146 = _99;
            }
          }
          _149 = mad(4.11929988861084f, _84, mad(43.5161018371582f, _83, (_82 * 17.882400512695312f)));
          _152 = mad(3.8671000003814697f, _84, mad(27.155399322509766f, _83, (_82 * 3.455699920654297f)));
          _155 = mad(1.4670000076293945f, _84, mad(0.18431000411510468f, _83, (_82 * 0.02996000088751316f)));
          _158 = mad(_144, _155, mad(_141, _152, (_149 * _138)));
          _161 = mad(_145, _155, mad(_142, _152, (_149 * _139)));
          _164 = mad(_146, _155, mad(_143, _152, (_149 * _140)));
          _174 = _82 - mad(0.11670000106096268f, _164, mad(-0.13050000369548798f, _161, (_158 * 0.08089999854564667f)));
          _176 = _84 - mad(0.6934999823570251f, _164, mad(-0.004100000020116568f, _161, (_158 * -0.0003000000142492354f)));
          _179 = _174 * 0.699999988079071f;
          _239 = (mad(_136, _176, (_174 * _134)) + _82);
          _240 = (mad(_135, (_83 - mad(-0.1136000007390976f, _164, mad(0.05400000140070915f, _161, (_158 * -0.010200000368058681f)))), _179) + _132);
          _241 = (mad(_137, _176, _179) + _133);
        } while (false);
        break;
      }
      case 2: {
        _98 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _99 = 1.0f - _98;
        _100 = _98 * 2.023439884185791f;
        _101 = _98 * -2.5258100032806396f;
        _102 = _98 * 0.4941999912261963f;
        _103 = _98 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_82 > 0.5f) && ((_84 + _83) < 0.5f)) {
              _132 = min(max((_83 + 0.20000000298023224f), 0.0f), 1.0f);
              _133 = min(max((_84 + 0.20000000298023224f), 0.0f), 1.0f);
              _134 = 0.0f;
              _135 = 1.0f;
              _136 = 0.0f;
              _137 = 1.0f;
              _138 = _99;
              _139 = 0.0f;
              _140 = 0.0f;
              _141 = _100;
              _142 = 1.0f;
              _143 = 0.0f;
              _144 = _101;
              _145 = 0.0f;
              _146 = 1.0f;
            } else {
              _132 = _83;
              _133 = _84;
              _134 = 0.0f;
              _135 = 1.0f;
              _136 = 0.0f;
              _137 = 1.0f;
              _138 = _99;
              _139 = 0.0f;
              _140 = 0.0f;
              _141 = _100;
              _142 = 1.0f;
              _143 = 0.0f;
              _144 = _101;
              _145 = 0.0f;
              _146 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_82 > (_83 * 2.0f)) && ((_83 + _82) > _84)) {
                _132 = _83;
                _133 = min(max((_84 + 0.30000001192092896f), 0.0f), 1.0f);
                _134 = 0.0f;
                _135 = 1.0f;
                _136 = 0.0f;
                _137 = 1.0f;
                _138 = 1.0f;
                _139 = _102;
                _140 = 0.0f;
                _141 = 0.0f;
                _142 = _99;
                _143 = 0.0f;
                _144 = 0.0f;
                _145 = _103;
                _146 = 1.0f;
              } else {
                _132 = _83;
                _133 = _84;
                _134 = 0.0f;
                _135 = 1.0f;
                _136 = 0.0f;
                _137 = 1.0f;
                _138 = 1.0f;
                _139 = _102;
                _140 = 0.0f;
                _141 = 0.0f;
                _142 = _99;
                _143 = 0.0f;
                _144 = 0.0f;
                _145 = _103;
                _146 = 1.0f;
              }
            } else {
              _132 = _83;
              _133 = _84;
              _134 = 1.0f;
              _135 = 0.699999988079071f;
              _136 = 0.699999988079071f;
              _137 = 0.0f;
              _138 = 1.0f;
              _139 = 0.0f;
              _140 = (_98 * -0.012245000340044498f);
              _141 = 0.0f;
              _142 = 1.0f;
              _143 = (_98 * 0.07203499972820282f);
              _144 = 0.0f;
              _145 = 0.0f;
              _146 = _99;
            }
          }
          _149 = mad(4.11929988861084f, _84, mad(43.5161018371582f, _83, (_82 * 17.882400512695312f)));
          _152 = mad(3.8671000003814697f, _84, mad(27.155399322509766f, _83, (_82 * 3.455699920654297f)));
          _155 = mad(1.4670000076293945f, _84, mad(0.18431000411510468f, _83, (_82 * 0.02996000088751316f)));
          _158 = mad(_144, _155, mad(_141, _152, (_149 * _138)));
          _161 = mad(_145, _155, mad(_142, _152, (_149 * _139)));
          _164 = mad(_146, _155, mad(_143, _152, (_149 * _140)));
          _174 = _82 - mad(0.11670000106096268f, _164, mad(-0.13050000369548798f, _161, (_158 * 0.08089999854564667f)));
          _176 = _84 - mad(0.6934999823570251f, _164, mad(-0.004100000020116568f, _161, (_158 * -0.0003000000142492354f)));
          _179 = _174 * 0.699999988079071f;
          _239 = (mad(_136, _176, (_174 * _134)) + _82);
          _240 = (mad(_135, (_83 - mad(-0.1136000007390976f, _164, mad(0.05400000140070915f, _161, (_158 * -0.010200000368058681f)))), _179) + _132);
          _241 = (mad(_137, _176, _179) + _133);
        } while (false);
        break;
      }
      case 3: {
        _98 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _99 = 1.0f - _98;
        _100 = _98 * 2.023439884185791f;
        _101 = _98 * -2.5258100032806396f;
        _102 = _98 * 0.4941999912261963f;
        _103 = _98 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_82 > 0.5f) && ((_84 + _83) < 0.5f)) {
              _132 = min(max((_83 + 0.20000000298023224f), 0.0f), 1.0f);
              _133 = min(max((_84 + 0.20000000298023224f), 0.0f), 1.0f);
              _134 = 0.0f;
              _135 = 1.0f;
              _136 = 0.0f;
              _137 = 1.0f;
              _138 = _99;
              _139 = 0.0f;
              _140 = 0.0f;
              _141 = _100;
              _142 = 1.0f;
              _143 = 0.0f;
              _144 = _101;
              _145 = 0.0f;
              _146 = 1.0f;
            } else {
              _132 = _83;
              _133 = _84;
              _134 = 0.0f;
              _135 = 1.0f;
              _136 = 0.0f;
              _137 = 1.0f;
              _138 = _99;
              _139 = 0.0f;
              _140 = 0.0f;
              _141 = _100;
              _142 = 1.0f;
              _143 = 0.0f;
              _144 = _101;
              _145 = 0.0f;
              _146 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_82 > (_83 * 2.0f)) && ((_83 + _82) > _84)) {
                _132 = _83;
                _133 = min(max((_84 + 0.30000001192092896f), 0.0f), 1.0f);
                _134 = 0.0f;
                _135 = 1.0f;
                _136 = 0.0f;
                _137 = 1.0f;
                _138 = 1.0f;
                _139 = _102;
                _140 = 0.0f;
                _141 = 0.0f;
                _142 = _99;
                _143 = 0.0f;
                _144 = 0.0f;
                _145 = _103;
                _146 = 1.0f;
              } else {
                _132 = _83;
                _133 = _84;
                _134 = 0.0f;
                _135 = 1.0f;
                _136 = 0.0f;
                _137 = 1.0f;
                _138 = 1.0f;
                _139 = _102;
                _140 = 0.0f;
                _141 = 0.0f;
                _142 = _99;
                _143 = 0.0f;
                _144 = 0.0f;
                _145 = _103;
                _146 = 1.0f;
              }
            } else {
              _132 = _83;
              _133 = _84;
              _134 = 1.0f;
              _135 = 0.699999988079071f;
              _136 = 0.699999988079071f;
              _137 = 0.0f;
              _138 = 1.0f;
              _139 = 0.0f;
              _140 = (_98 * -0.012245000340044498f);
              _141 = 0.0f;
              _142 = 1.0f;
              _143 = (_98 * 0.07203499972820282f);
              _144 = 0.0f;
              _145 = 0.0f;
              _146 = _99;
            }
          }
          _149 = mad(4.11929988861084f, _84, mad(43.5161018371582f, _83, (_82 * 17.882400512695312f)));
          _152 = mad(3.8671000003814697f, _84, mad(27.155399322509766f, _83, (_82 * 3.455699920654297f)));
          _155 = mad(1.4670000076293945f, _84, mad(0.18431000411510468f, _83, (_82 * 0.02996000088751316f)));
          _158 = mad(_144, _155, mad(_141, _152, (_149 * _138)));
          _161 = mad(_145, _155, mad(_142, _152, (_149 * _139)));
          _164 = mad(_146, _155, mad(_143, _152, (_149 * _140)));
          _174 = _82 - mad(0.11670000106096268f, _164, mad(-0.13050000369548798f, _161, (_158 * 0.08089999854564667f)));
          _176 = _84 - mad(0.6934999823570251f, _164, mad(-0.004100000020116568f, _161, (_158 * -0.0003000000142492354f)));
          _179 = _174 * 0.699999988079071f;
          _239 = (mad(_136, _176, (_174 * _134)) + _82);
          _240 = (mad(_135, (_83 - mad(-0.1136000007390976f, _164, mad(0.05400000140070915f, _161, (_158 * -0.010200000368058681f)))), _179) + _132);
          _241 = (mad(_137, _176, _179) + _133);
        } while (false);
        break;
      }
      case 4: {
        if (((_82 > 0.25f) && (_83 < 0.550000011920929f)) && (_84 < 0.3199999928474426f)) {
          _194 = min(max((_82 + 0.20000000298023224f), 0.0f), 1.0f);
          _239 = _194;
          _240 = _194;
          _241 = (_84 * 0.25f);
        } else {
          _239 = _82;
          _240 = _83;
          _241 = _84;
        }
        break;
      }
      case 5: {
        _201 = ((_82 > 0.25f) && (_83 < 0.3199999928474426f)) && (_84 < 0.3199999928474426f);
        _239 = _82;
        _240 = select(_201, _82, _83);
        _241 = select(_201, (_84 * 0.25f), _84);
        break;
      }
      case 6: {
        if (((_82 > 0.25f) && (_83 < 0.27000001072883606f)) && (_84 < 0.27000001072883606f)) {
          _239 = ((_82 * 0.10000000149011612f) + 0.40400001406669617f);
          _240 = ((_83 * 0.10000000149011612f) + 0.2630000114440918f);
          _241 = min(max(((_84 * 0.10000000149011612f) + 0.906000018119812f), 0.0f), 1.0f);
        } else {
          _239 = _82;
          _240 = _83;
          _241 = _84;
        }
        break;
      }
      case 7: {
        if (((_82 < 0.3499999940395355f) && (_83 > 0.3499999940395355f)) && (_84 > 0.3499999940395355f)) {
          _239 = (_82 * 0.15000000596046448f);
          _240 = (_83 * 0.15000000596046448f);
          _241 = 0.2150000035762787f;
        } else {
          _239 = _82;
          _240 = _83;
          _241 = _84;
        }
        break;
      }
      case 8: {
        if (((_82 > 0.25f) && (_83 < 0.27000001072883606f)) && (_84 < 0.27000001072883606f)) {
          _239 = (_82 * 0.15000000596046448f);
          _240 = (_83 * 0.15000000596046448f);
          _241 = 0.2150000035762787f;
        } else {
          _239 = _82;
          _240 = _83;
          _241 = _84;
        }
        break;
      }
      default: {
        _239 = _82;
        _240 = _83;
        _241 = _84;
        break;
      }
    }
  } else {
    _239 = _82;
    _240 = _83;
    _241 = _84;
  }
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_239, _240, _241, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _396 = color.r;
    _397 = color.g;
    _398 = color.b;
#else  // original code
    _275 = saturate(select((_239 <= 0.040449999272823334f), (_239 * 0.07739938050508499f), exp2(log2(abs((_239 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _276 = saturate(select((_240 <= 0.040449999272823334f), (_240 * 0.07739938050508499f), exp2(log2(abs((_240 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _277 = saturate(select((_241 <= 0.040449999272823334f), (_241 * 0.07739938050508499f), exp2(log2(abs((_241 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _278 = dot(float3(_275, _276, _277), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _286 = select((_278 > 0.5f), (((_278 * HDROutput_016.y) / (HDROutput_016.y - _278)) + HDROutput_016.x), (_278 / (1.000100016593933f - _278)));
    _287 = _278 + 9.999999747378752e-05f;
    _291 = _286 * (_275 / _287);
    _292 = (_276 / _287) * _286;
    _293 = (_277 / _287) * _286;
    _309 = saturate(max(max(_291, _292), _293) + -1.0f);
    _316 = HDROutput_064 * 9.999999747378752e-05f;
    _323 = exp2(log2(abs(_316 * (((1.0f - _309) * mad(0.04331360012292862f, _293, mad(0.3292819857597351f, _292, (_291 * 0.627403974533081f)))) + (_309 * mad(0.047561999410390854f, _293, mad(0.19859300553798676f, _292, (_291 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _332 = exp2(log2(abs(((_323 * 18.8515625f) + 0.8359375f) / ((_323 * 18.6875f) + 1.0f))) * 78.84375f);
    _336 = exp2(log2(abs(_316 * mad(0.012477199546992779f, _293, mad(0.9417769908905029f, _292, (_291 * 0.045745600014925f))))) * 0.1593017578125f);
    _345 = exp2(log2(abs(((_336 * 18.8515625f) + 0.8359375f) / ((_336 * 18.6875f) + 1.0f))) * 78.84375f);
    _349 = exp2(log2(abs(_316 * mad(0.9836069941520691f, _293, mad(0.017604099586606026f, _292, (_291 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _358 = exp2(log2(abs(((_349 * 18.8515625f) + 0.8359375f) / ((_349 * 18.6875f) + 1.0f))) * 78.84375f);
    _367 = saturate(_332 / HDROutput_084);
    _368 = saturate(_345 / HDROutput_084);
    _369 = saturate(_358 / HDROutput_084);
    _370 = HDROutput_084 - HDROutput_036;
    _396 = select((_332 > HDROutput_076), _332, select((_332 < HDROutput_084), max((((_367 * _367) * _370) + HDROutput_036), _332), _332));
    _397 = select((_345 > HDROutput_076), _345, select((_345 < HDROutput_084), max((((_368 * _368) * _370) + HDROutput_036), _345), _345));
    _398 = select((_358 > HDROutput_076), _358, select((_358 < HDROutput_084), max((((_369 * _369) * _370) + HDROutput_036), _358), _358));
#endif
  } else {
    _396 = _239;
    _397 = _240;
    _398 = _241;
  }
  SV_Target.x = _396;
  SV_Target.y = _397;
  SV_Target.z = _398;
  SV_Target.w = ((select((FireUiPrimitive_396 != 0), 1.0f, (((float4)(t0.Sample(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y)))).y)) * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w);
  return SV_Target;
}