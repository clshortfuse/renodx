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
  float _67;
  float _68;
  float _69;
  float _70;
  float _83;
  float _84;
  float _85;
  float _86;
  float _156;
  float _157;
  float _158;
  float _159;
  float _160;
  float _161;
  float _162;
  float _163;
  float _164;
  float _165;
  float _166;
  float _167;
  float _168;
  float _169;
  float _170;
  float _263;
  float _264;
  float _265;
  float _420;
  float _421;
  float _422;
  float _106;
  float _107;
  float _108;
  float _122;
  float _123;
  float _124;
  float _125;
  float _126;
  float _127;
  float _173;
  float _176;
  float _179;
  float _182;
  float _185;
  float _188;
  float _198;
  float _200;
  float _203;
  float _218;
  bool _225;
  float _299;
  float _300;
  float _301;
  float _302;
  float _310;
  float _311;
  float _315;
  float _316;
  float _317;
  float _333;
  float _340;
  float _347;
  float _356;
  float _360;
  float _369;
  float _373;
  float _382;
  float _391;
  float _392;
  float _393;
  float _394;
  _23 = ((((float4)(t1.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y))))).x) > 0.10000000149011612f);
  if (_23) discard;
  _24 = t0.Sample(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _31 = (FireUiPrimitive_396 != 0);
  _35 = select(_31, 1.0f, _24.x) * TEXCOORD0_centroid.x;
  _36 = select(_31, 1.0f, _24.y) * TEXCOORD0_centroid.y;
  _37 = select(_31, 1.0f, _24.z) * TEXCOORD0_centroid.z;
  _39 = dot(float3(_35, _36, _37), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _67 = FireUiPrimitive_016.x * min(max(((lerp(_39, _35, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f);
  _68 = FireUiPrimitive_016.y * min(max(((lerp(_39, _36, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f);
  _69 = FireUiPrimitive_016.z * min(max(((lerp(_39, _37, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f);
  _70 = (_24.w * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w;
  if (_24.w > 0.0f) {
    _83 = (FireUiPrimitive_000.x + _67);
    _84 = (FireUiPrimitive_000.y + _68);
    _85 = (FireUiPrimitive_000.z + _69);
    _86 = (FireUiPrimitive_000.w + _70);
  } else {
    _83 = _67;
    _84 = _68;
    _85 = _69;
    _86 = _70;
  }
  _106 = (exp2(log2(abs(_83)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _107 = (exp2(log2(abs(_84)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _108 = (exp2(log2(abs(_85)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!((((_106 < 9.999999747378752e-05f) && (_107 < 9.999999747378752e-05f)) && (_108 < 9.999999747378752e-05f)) || ((uint)((int)((uint)(FireUiPrimitive_388) + (uint)(-1))) > (uint)7))) {
    switch ((int)(FireUiPrimitive_388)) {
      case 1: {
        _122 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _123 = 1.0f - _122;
        _124 = _122 * 2.023439884185791f;
        _125 = _122 * -2.5258100032806396f;
        _126 = _122 * 0.4941999912261963f;
        _127 = _122 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_106 > 0.5f) && ((_108 + _107) < 0.5f)) {
              _156 = min(max((_107 + 0.20000000298023224f), 0.0f), 1.0f);
              _157 = min(max((_108 + 0.20000000298023224f), 0.0f), 1.0f);
              _158 = 0.0f;
              _159 = 1.0f;
              _160 = 0.0f;
              _161 = 1.0f;
              _162 = _123;
              _163 = 0.0f;
              _164 = 0.0f;
              _165 = _124;
              _166 = 1.0f;
              _167 = 0.0f;
              _168 = _125;
              _169 = 0.0f;
              _170 = 1.0f;
            } else {
              _156 = _107;
              _157 = _108;
              _158 = 0.0f;
              _159 = 1.0f;
              _160 = 0.0f;
              _161 = 1.0f;
              _162 = _123;
              _163 = 0.0f;
              _164 = 0.0f;
              _165 = _124;
              _166 = 1.0f;
              _167 = 0.0f;
              _168 = _125;
              _169 = 0.0f;
              _170 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_106 > (_107 * 2.0f)) && ((_107 + _106) > _108)) {
                _156 = _107;
                _157 = min(max((_108 + 0.30000001192092896f), 0.0f), 1.0f);
                _158 = 0.0f;
                _159 = 1.0f;
                _160 = 0.0f;
                _161 = 1.0f;
                _162 = 1.0f;
                _163 = _126;
                _164 = 0.0f;
                _165 = 0.0f;
                _166 = _123;
                _167 = 0.0f;
                _168 = 0.0f;
                _169 = _127;
                _170 = 1.0f;
              } else {
                _156 = _107;
                _157 = _108;
                _158 = 0.0f;
                _159 = 1.0f;
                _160 = 0.0f;
                _161 = 1.0f;
                _162 = 1.0f;
                _163 = _126;
                _164 = 0.0f;
                _165 = 0.0f;
                _166 = _123;
                _167 = 0.0f;
                _168 = 0.0f;
                _169 = _127;
                _170 = 1.0f;
              }
            } else {
              _156 = _107;
              _157 = _108;
              _158 = 1.0f;
              _159 = 0.699999988079071f;
              _160 = 0.699999988079071f;
              _161 = 0.0f;
              _162 = 1.0f;
              _163 = 0.0f;
              _164 = (_122 * -0.012245000340044498f);
              _165 = 0.0f;
              _166 = 1.0f;
              _167 = (_122 * 0.07203499972820282f);
              _168 = 0.0f;
              _169 = 0.0f;
              _170 = _123;
            }
          }
          _173 = mad(4.11929988861084f, _108, mad(43.5161018371582f, _107, (_106 * 17.882400512695312f)));
          _176 = mad(3.8671000003814697f, _108, mad(27.155399322509766f, _107, (_106 * 3.455699920654297f)));
          _179 = mad(1.4670000076293945f, _108, mad(0.18431000411510468f, _107, (_106 * 0.02996000088751316f)));
          _182 = mad(_168, _179, mad(_165, _176, (_173 * _162)));
          _185 = mad(_169, _179, mad(_166, _176, (_173 * _163)));
          _188 = mad(_170, _179, mad(_167, _176, (_173 * _164)));
          _198 = _106 - mad(0.11670000106096268f, _188, mad(-0.13050000369548798f, _185, (_182 * 0.08089999854564667f)));
          _200 = _108 - mad(0.6934999823570251f, _188, mad(-0.004100000020116568f, _185, (_182 * -0.0003000000142492354f)));
          _203 = _198 * 0.699999988079071f;
          _263 = (mad(_160, _200, (_198 * _158)) + _106);
          _264 = (mad(_159, (_107 - mad(-0.1136000007390976f, _188, mad(0.05400000140070915f, _185, (_182 * -0.010200000368058681f)))), _203) + _156);
          _265 = (mad(_161, _200, _203) + _157);
        } while (false);
        break;
      }
      case 2: {
        _122 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _123 = 1.0f - _122;
        _124 = _122 * 2.023439884185791f;
        _125 = _122 * -2.5258100032806396f;
        _126 = _122 * 0.4941999912261963f;
        _127 = _122 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_106 > 0.5f) && ((_108 + _107) < 0.5f)) {
              _156 = min(max((_107 + 0.20000000298023224f), 0.0f), 1.0f);
              _157 = min(max((_108 + 0.20000000298023224f), 0.0f), 1.0f);
              _158 = 0.0f;
              _159 = 1.0f;
              _160 = 0.0f;
              _161 = 1.0f;
              _162 = _123;
              _163 = 0.0f;
              _164 = 0.0f;
              _165 = _124;
              _166 = 1.0f;
              _167 = 0.0f;
              _168 = _125;
              _169 = 0.0f;
              _170 = 1.0f;
            } else {
              _156 = _107;
              _157 = _108;
              _158 = 0.0f;
              _159 = 1.0f;
              _160 = 0.0f;
              _161 = 1.0f;
              _162 = _123;
              _163 = 0.0f;
              _164 = 0.0f;
              _165 = _124;
              _166 = 1.0f;
              _167 = 0.0f;
              _168 = _125;
              _169 = 0.0f;
              _170 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_106 > (_107 * 2.0f)) && ((_107 + _106) > _108)) {
                _156 = _107;
                _157 = min(max((_108 + 0.30000001192092896f), 0.0f), 1.0f);
                _158 = 0.0f;
                _159 = 1.0f;
                _160 = 0.0f;
                _161 = 1.0f;
                _162 = 1.0f;
                _163 = _126;
                _164 = 0.0f;
                _165 = 0.0f;
                _166 = _123;
                _167 = 0.0f;
                _168 = 0.0f;
                _169 = _127;
                _170 = 1.0f;
              } else {
                _156 = _107;
                _157 = _108;
                _158 = 0.0f;
                _159 = 1.0f;
                _160 = 0.0f;
                _161 = 1.0f;
                _162 = 1.0f;
                _163 = _126;
                _164 = 0.0f;
                _165 = 0.0f;
                _166 = _123;
                _167 = 0.0f;
                _168 = 0.0f;
                _169 = _127;
                _170 = 1.0f;
              }
            } else {
              _156 = _107;
              _157 = _108;
              _158 = 1.0f;
              _159 = 0.699999988079071f;
              _160 = 0.699999988079071f;
              _161 = 0.0f;
              _162 = 1.0f;
              _163 = 0.0f;
              _164 = (_122 * -0.012245000340044498f);
              _165 = 0.0f;
              _166 = 1.0f;
              _167 = (_122 * 0.07203499972820282f);
              _168 = 0.0f;
              _169 = 0.0f;
              _170 = _123;
            }
          }
          _173 = mad(4.11929988861084f, _108, mad(43.5161018371582f, _107, (_106 * 17.882400512695312f)));
          _176 = mad(3.8671000003814697f, _108, mad(27.155399322509766f, _107, (_106 * 3.455699920654297f)));
          _179 = mad(1.4670000076293945f, _108, mad(0.18431000411510468f, _107, (_106 * 0.02996000088751316f)));
          _182 = mad(_168, _179, mad(_165, _176, (_173 * _162)));
          _185 = mad(_169, _179, mad(_166, _176, (_173 * _163)));
          _188 = mad(_170, _179, mad(_167, _176, (_173 * _164)));
          _198 = _106 - mad(0.11670000106096268f, _188, mad(-0.13050000369548798f, _185, (_182 * 0.08089999854564667f)));
          _200 = _108 - mad(0.6934999823570251f, _188, mad(-0.004100000020116568f, _185, (_182 * -0.0003000000142492354f)));
          _203 = _198 * 0.699999988079071f;
          _263 = (mad(_160, _200, (_198 * _158)) + _106);
          _264 = (mad(_159, (_107 - mad(-0.1136000007390976f, _188, mad(0.05400000140070915f, _185, (_182 * -0.010200000368058681f)))), _203) + _156);
          _265 = (mad(_161, _200, _203) + _157);
        } while (false);
        break;
      }
      case 3: {
        _122 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _123 = 1.0f - _122;
        _124 = _122 * 2.023439884185791f;
        _125 = _122 * -2.5258100032806396f;
        _126 = _122 * 0.4941999912261963f;
        _127 = _122 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_106 > 0.5f) && ((_108 + _107) < 0.5f)) {
              _156 = min(max((_107 + 0.20000000298023224f), 0.0f), 1.0f);
              _157 = min(max((_108 + 0.20000000298023224f), 0.0f), 1.0f);
              _158 = 0.0f;
              _159 = 1.0f;
              _160 = 0.0f;
              _161 = 1.0f;
              _162 = _123;
              _163 = 0.0f;
              _164 = 0.0f;
              _165 = _124;
              _166 = 1.0f;
              _167 = 0.0f;
              _168 = _125;
              _169 = 0.0f;
              _170 = 1.0f;
            } else {
              _156 = _107;
              _157 = _108;
              _158 = 0.0f;
              _159 = 1.0f;
              _160 = 0.0f;
              _161 = 1.0f;
              _162 = _123;
              _163 = 0.0f;
              _164 = 0.0f;
              _165 = _124;
              _166 = 1.0f;
              _167 = 0.0f;
              _168 = _125;
              _169 = 0.0f;
              _170 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_106 > (_107 * 2.0f)) && ((_107 + _106) > _108)) {
                _156 = _107;
                _157 = min(max((_108 + 0.30000001192092896f), 0.0f), 1.0f);
                _158 = 0.0f;
                _159 = 1.0f;
                _160 = 0.0f;
                _161 = 1.0f;
                _162 = 1.0f;
                _163 = _126;
                _164 = 0.0f;
                _165 = 0.0f;
                _166 = _123;
                _167 = 0.0f;
                _168 = 0.0f;
                _169 = _127;
                _170 = 1.0f;
              } else {
                _156 = _107;
                _157 = _108;
                _158 = 0.0f;
                _159 = 1.0f;
                _160 = 0.0f;
                _161 = 1.0f;
                _162 = 1.0f;
                _163 = _126;
                _164 = 0.0f;
                _165 = 0.0f;
                _166 = _123;
                _167 = 0.0f;
                _168 = 0.0f;
                _169 = _127;
                _170 = 1.0f;
              }
            } else {
              _156 = _107;
              _157 = _108;
              _158 = 1.0f;
              _159 = 0.699999988079071f;
              _160 = 0.699999988079071f;
              _161 = 0.0f;
              _162 = 1.0f;
              _163 = 0.0f;
              _164 = (_122 * -0.012245000340044498f);
              _165 = 0.0f;
              _166 = 1.0f;
              _167 = (_122 * 0.07203499972820282f);
              _168 = 0.0f;
              _169 = 0.0f;
              _170 = _123;
            }
          }
          _173 = mad(4.11929988861084f, _108, mad(43.5161018371582f, _107, (_106 * 17.882400512695312f)));
          _176 = mad(3.8671000003814697f, _108, mad(27.155399322509766f, _107, (_106 * 3.455699920654297f)));
          _179 = mad(1.4670000076293945f, _108, mad(0.18431000411510468f, _107, (_106 * 0.02996000088751316f)));
          _182 = mad(_168, _179, mad(_165, _176, (_173 * _162)));
          _185 = mad(_169, _179, mad(_166, _176, (_173 * _163)));
          _188 = mad(_170, _179, mad(_167, _176, (_173 * _164)));
          _198 = _106 - mad(0.11670000106096268f, _188, mad(-0.13050000369548798f, _185, (_182 * 0.08089999854564667f)));
          _200 = _108 - mad(0.6934999823570251f, _188, mad(-0.004100000020116568f, _185, (_182 * -0.0003000000142492354f)));
          _203 = _198 * 0.699999988079071f;
          _263 = (mad(_160, _200, (_198 * _158)) + _106);
          _264 = (mad(_159, (_107 - mad(-0.1136000007390976f, _188, mad(0.05400000140070915f, _185, (_182 * -0.010200000368058681f)))), _203) + _156);
          _265 = (mad(_161, _200, _203) + _157);
        } while (false);
        break;
      }
      case 4: {
        if (((_106 > 0.25f) && (_107 < 0.550000011920929f)) && (_108 < 0.3199999928474426f)) {
          _218 = min(max((_106 + 0.20000000298023224f), 0.0f), 1.0f);
          _263 = _218;
          _264 = _218;
          _265 = (_108 * 0.25f);
        } else {
          _263 = _106;
          _264 = _107;
          _265 = _108;
        }
        break;
      }
      case 5: {
        _225 = ((_106 > 0.25f) && (_107 < 0.3199999928474426f)) && (_108 < 0.3199999928474426f);
        _263 = _106;
        _264 = select(_225, _106, _107);
        _265 = select(_225, (_108 * 0.25f), _108);
        break;
      }
      case 6: {
        if (((_106 > 0.25f) && (_107 < 0.27000001072883606f)) && (_108 < 0.27000001072883606f)) {
          _263 = ((_106 * 0.10000000149011612f) + 0.40400001406669617f);
          _264 = ((_107 * 0.10000000149011612f) + 0.2630000114440918f);
          _265 = min(max(((_108 * 0.10000000149011612f) + 0.906000018119812f), 0.0f), 1.0f);
        } else {
          _263 = _106;
          _264 = _107;
          _265 = _108;
        }
        break;
      }
      case 7: {
        if (((_106 < 0.3499999940395355f) && (_107 > 0.3499999940395355f)) && (_108 > 0.3499999940395355f)) {
          _263 = (_106 * 0.15000000596046448f);
          _264 = (_107 * 0.15000000596046448f);
          _265 = 0.2150000035762787f;
        } else {
          _263 = _106;
          _264 = _107;
          _265 = _108;
        }
        break;
      }
      case 8: {
        if (((_106 > 0.25f) && (_107 < 0.27000001072883606f)) && (_108 < 0.27000001072883606f)) {
          _263 = (_106 * 0.15000000596046448f);
          _264 = (_107 * 0.15000000596046448f);
          _265 = 0.2150000035762787f;
        } else {
          _263 = _106;
          _264 = _107;
          _265 = _108;
        }
        break;
      }
      default: {
        _263 = _106;
        _264 = _107;
        _265 = _108;
        break;
      }
    }
  } else {
    _263 = _106;
    _264 = _107;
    _265 = _108;
  }
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_263, _264, _265, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _420 = color.r;
    _421 = color.g;
    _422 = color.b;
#else  // original code
    _299 = saturate(select((_263 <= 0.040449999272823334f), (_263 * 0.07739938050508499f), exp2(log2(abs((_263 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _300 = saturate(select((_264 <= 0.040449999272823334f), (_264 * 0.07739938050508499f), exp2(log2(abs((_264 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _301 = saturate(select((_265 <= 0.040449999272823334f), (_265 * 0.07739938050508499f), exp2(log2(abs((_265 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _302 = dot(float3(_299, _300, _301), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _310 = select((_302 > 0.5f), (((_302 * HDROutput_016.y) / (HDROutput_016.y - _302)) + HDROutput_016.x), (_302 / (1.000100016593933f - _302)));
    _311 = _302 + 9.999999747378752e-05f;
    _315 = _310 * (_299 / _311);
    _316 = (_300 / _311) * _310;
    _317 = (_301 / _311) * _310;
    _333 = saturate(max(max(_315, _316), _317) + -1.0f);
    _340 = HDROutput_064 * 9.999999747378752e-05f;
    _347 = exp2(log2(abs(_340 * (((1.0f - _333) * mad(0.04331360012292862f, _317, mad(0.3292819857597351f, _316, (_315 * 0.627403974533081f)))) + (_333 * mad(0.047561999410390854f, _317, mad(0.19859300553798676f, _316, (_315 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _356 = exp2(log2(abs(((_347 * 18.8515625f) + 0.8359375f) / ((_347 * 18.6875f) + 1.0f))) * 78.84375f);
    _360 = exp2(log2(abs(_340 * mad(0.012477199546992779f, _317, mad(0.9417769908905029f, _316, (_315 * 0.045745600014925f))))) * 0.1593017578125f);
    _369 = exp2(log2(abs(((_360 * 18.8515625f) + 0.8359375f) / ((_360 * 18.6875f) + 1.0f))) * 78.84375f);
    _373 = exp2(log2(abs(_340 * mad(0.9836069941520691f, _317, mad(0.017604099586606026f, _316, (_315 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _382 = exp2(log2(abs(((_373 * 18.8515625f) + 0.8359375f) / ((_373 * 18.6875f) + 1.0f))) * 78.84375f);
    _391 = saturate(_356 / HDROutput_084);
    _392 = saturate(_369 / HDROutput_084);
    _393 = saturate(_382 / HDROutput_084);
    _394 = HDROutput_084 - HDROutput_036;
    _420 = select((_356 > HDROutput_076), _356, select((_356 < HDROutput_084), max((((_391 * _391) * _394) + HDROutput_036), _356), _356));
    _421 = select((_369 > HDROutput_076), _369, select((_369 < HDROutput_084), max((((_392 * _392) * _394) + HDROutput_036), _369), _369));
    _422 = select((_382 > HDROutput_076), _382, select((_382 < HDROutput_084), max((((_393 * _393) * _394) + HDROutput_036), _382), _382));
#endif
  } else {
    _420 = _263;
    _421 = _264;
    _422 = _265;
  }
  SV_Target.x = _420;
  SV_Target.y = _421;
  SV_Target.z = _422;
  SV_Target.w = _86;
  return SV_Target;
}