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
  float _29;
  float _31;
  float _59;
  float _60;
  float _61;
  float _62;
  float _75;
  float _76;
  float _77;
  float _78;
  float _148;
  float _149;
  float _150;
  float _151;
  float _152;
  float _153;
  float _154;
  float _155;
  float _156;
  float _157;
  float _158;
  float _159;
  float _160;
  float _161;
  float _162;
  float _255;
  float _256;
  float _257;
  float _412;
  float _413;
  float _414;
  float _98;
  float _99;
  float _100;
  float _114;
  float _115;
  float _116;
  float _117;
  float _118;
  float _119;
  float _165;
  float _168;
  float _171;
  float _174;
  float _177;
  float _180;
  float _190;
  float _192;
  float _195;
  float _210;
  bool _217;
  float _291;
  float _292;
  float _293;
  float _294;
  float _302;
  float _303;
  float _307;
  float _308;
  float _309;
  float _325;
  float _332;
  float _339;
  float _348;
  float _352;
  float _361;
  float _365;
  float _374;
  float _383;
  float _384;
  float _385;
  float _386;
  _23 = ((((float4)(t1.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y))))).x) > 0.10000000149011612f);
  if (_23) discard;
  _29 = select((FireUiPrimitive_396 != 0), 1.0f, (((float4)(t0.Sample(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y)))).y));
  _31 = dot(float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, TEXCOORD0_centroid.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _59 = FireUiPrimitive_016.x * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.x - _31)) + _31) * cb0_836w), 0.0f), 64512.0f);
  _60 = FireUiPrimitive_016.y * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.y - _31)) + _31) * cb0_836w), 0.0f), 64512.0f);
  _61 = FireUiPrimitive_016.z * min(max((((FireUiPrimitive_344 * (TEXCOORD0_centroid.z - _31)) + _31) * cb0_836w), 0.0f), 64512.0f);
  _62 = (_29 * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w;
  if (_29 > 0.0f) {
    _75 = (FireUiPrimitive_000.x + _59);
    _76 = (FireUiPrimitive_000.y + _60);
    _77 = (FireUiPrimitive_000.z + _61);
    _78 = (FireUiPrimitive_000.w + _62);
  } else {
    _75 = _59;
    _76 = _60;
    _77 = _61;
    _78 = _62;
  }
  _98 = (exp2(log2(abs(_75)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _99 = (exp2(log2(abs(_76)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _100 = (exp2(log2(abs(_77)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!((((_98 < 9.999999747378752e-05f) && (_99 < 9.999999747378752e-05f)) && (_100 < 9.999999747378752e-05f)) || ((uint)((int)((uint)(FireUiPrimitive_388) + (uint)(-1))) > (uint)7))) {
    switch ((int)(FireUiPrimitive_388)) {
      case 1: {
        _114 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _115 = 1.0f - _114;
        _116 = _114 * 2.023439884185791f;
        _117 = _114 * -2.5258100032806396f;
        _118 = _114 * 0.4941999912261963f;
        _119 = _114 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_98 > 0.5f) && ((_100 + _99) < 0.5f)) {
              _148 = min(max((_99 + 0.20000000298023224f), 0.0f), 1.0f);
              _149 = min(max((_100 + 0.20000000298023224f), 0.0f), 1.0f);
              _150 = 0.0f;
              _151 = 1.0f;
              _152 = 0.0f;
              _153 = 1.0f;
              _154 = _115;
              _155 = 0.0f;
              _156 = 0.0f;
              _157 = _116;
              _158 = 1.0f;
              _159 = 0.0f;
              _160 = _117;
              _161 = 0.0f;
              _162 = 1.0f;
            } else {
              _148 = _99;
              _149 = _100;
              _150 = 0.0f;
              _151 = 1.0f;
              _152 = 0.0f;
              _153 = 1.0f;
              _154 = _115;
              _155 = 0.0f;
              _156 = 0.0f;
              _157 = _116;
              _158 = 1.0f;
              _159 = 0.0f;
              _160 = _117;
              _161 = 0.0f;
              _162 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_98 > (_99 * 2.0f)) && ((_99 + _98) > _100)) {
                _148 = _99;
                _149 = min(max((_100 + 0.30000001192092896f), 0.0f), 1.0f);
                _150 = 0.0f;
                _151 = 1.0f;
                _152 = 0.0f;
                _153 = 1.0f;
                _154 = 1.0f;
                _155 = _118;
                _156 = 0.0f;
                _157 = 0.0f;
                _158 = _115;
                _159 = 0.0f;
                _160 = 0.0f;
                _161 = _119;
                _162 = 1.0f;
              } else {
                _148 = _99;
                _149 = _100;
                _150 = 0.0f;
                _151 = 1.0f;
                _152 = 0.0f;
                _153 = 1.0f;
                _154 = 1.0f;
                _155 = _118;
                _156 = 0.0f;
                _157 = 0.0f;
                _158 = _115;
                _159 = 0.0f;
                _160 = 0.0f;
                _161 = _119;
                _162 = 1.0f;
              }
            } else {
              _148 = _99;
              _149 = _100;
              _150 = 1.0f;
              _151 = 0.699999988079071f;
              _152 = 0.699999988079071f;
              _153 = 0.0f;
              _154 = 1.0f;
              _155 = 0.0f;
              _156 = (_114 * -0.012245000340044498f);
              _157 = 0.0f;
              _158 = 1.0f;
              _159 = (_114 * 0.07203499972820282f);
              _160 = 0.0f;
              _161 = 0.0f;
              _162 = _115;
            }
          }
          _165 = mad(4.11929988861084f, _100, mad(43.5161018371582f, _99, (_98 * 17.882400512695312f)));
          _168 = mad(3.8671000003814697f, _100, mad(27.155399322509766f, _99, (_98 * 3.455699920654297f)));
          _171 = mad(1.4670000076293945f, _100, mad(0.18431000411510468f, _99, (_98 * 0.02996000088751316f)));
          _174 = mad(_160, _171, mad(_157, _168, (_165 * _154)));
          _177 = mad(_161, _171, mad(_158, _168, (_165 * _155)));
          _180 = mad(_162, _171, mad(_159, _168, (_165 * _156)));
          _190 = _98 - mad(0.11670000106096268f, _180, mad(-0.13050000369548798f, _177, (_174 * 0.08089999854564667f)));
          _192 = _100 - mad(0.6934999823570251f, _180, mad(-0.004100000020116568f, _177, (_174 * -0.0003000000142492354f)));
          _195 = _190 * 0.699999988079071f;
          _255 = (mad(_152, _192, (_190 * _150)) + _98);
          _256 = (mad(_151, (_99 - mad(-0.1136000007390976f, _180, mad(0.05400000140070915f, _177, (_174 * -0.010200000368058681f)))), _195) + _148);
          _257 = (mad(_153, _192, _195) + _149);
        } while (false);
        break;
      }
      case 2: {
        _114 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _115 = 1.0f - _114;
        _116 = _114 * 2.023439884185791f;
        _117 = _114 * -2.5258100032806396f;
        _118 = _114 * 0.4941999912261963f;
        _119 = _114 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_98 > 0.5f) && ((_100 + _99) < 0.5f)) {
              _148 = min(max((_99 + 0.20000000298023224f), 0.0f), 1.0f);
              _149 = min(max((_100 + 0.20000000298023224f), 0.0f), 1.0f);
              _150 = 0.0f;
              _151 = 1.0f;
              _152 = 0.0f;
              _153 = 1.0f;
              _154 = _115;
              _155 = 0.0f;
              _156 = 0.0f;
              _157 = _116;
              _158 = 1.0f;
              _159 = 0.0f;
              _160 = _117;
              _161 = 0.0f;
              _162 = 1.0f;
            } else {
              _148 = _99;
              _149 = _100;
              _150 = 0.0f;
              _151 = 1.0f;
              _152 = 0.0f;
              _153 = 1.0f;
              _154 = _115;
              _155 = 0.0f;
              _156 = 0.0f;
              _157 = _116;
              _158 = 1.0f;
              _159 = 0.0f;
              _160 = _117;
              _161 = 0.0f;
              _162 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_98 > (_99 * 2.0f)) && ((_99 + _98) > _100)) {
                _148 = _99;
                _149 = min(max((_100 + 0.30000001192092896f), 0.0f), 1.0f);
                _150 = 0.0f;
                _151 = 1.0f;
                _152 = 0.0f;
                _153 = 1.0f;
                _154 = 1.0f;
                _155 = _118;
                _156 = 0.0f;
                _157 = 0.0f;
                _158 = _115;
                _159 = 0.0f;
                _160 = 0.0f;
                _161 = _119;
                _162 = 1.0f;
              } else {
                _148 = _99;
                _149 = _100;
                _150 = 0.0f;
                _151 = 1.0f;
                _152 = 0.0f;
                _153 = 1.0f;
                _154 = 1.0f;
                _155 = _118;
                _156 = 0.0f;
                _157 = 0.0f;
                _158 = _115;
                _159 = 0.0f;
                _160 = 0.0f;
                _161 = _119;
                _162 = 1.0f;
              }
            } else {
              _148 = _99;
              _149 = _100;
              _150 = 1.0f;
              _151 = 0.699999988079071f;
              _152 = 0.699999988079071f;
              _153 = 0.0f;
              _154 = 1.0f;
              _155 = 0.0f;
              _156 = (_114 * -0.012245000340044498f);
              _157 = 0.0f;
              _158 = 1.0f;
              _159 = (_114 * 0.07203499972820282f);
              _160 = 0.0f;
              _161 = 0.0f;
              _162 = _115;
            }
          }
          _165 = mad(4.11929988861084f, _100, mad(43.5161018371582f, _99, (_98 * 17.882400512695312f)));
          _168 = mad(3.8671000003814697f, _100, mad(27.155399322509766f, _99, (_98 * 3.455699920654297f)));
          _171 = mad(1.4670000076293945f, _100, mad(0.18431000411510468f, _99, (_98 * 0.02996000088751316f)));
          _174 = mad(_160, _171, mad(_157, _168, (_165 * _154)));
          _177 = mad(_161, _171, mad(_158, _168, (_165 * _155)));
          _180 = mad(_162, _171, mad(_159, _168, (_165 * _156)));
          _190 = _98 - mad(0.11670000106096268f, _180, mad(-0.13050000369548798f, _177, (_174 * 0.08089999854564667f)));
          _192 = _100 - mad(0.6934999823570251f, _180, mad(-0.004100000020116568f, _177, (_174 * -0.0003000000142492354f)));
          _195 = _190 * 0.699999988079071f;
          _255 = (mad(_152, _192, (_190 * _150)) + _98);
          _256 = (mad(_151, (_99 - mad(-0.1136000007390976f, _180, mad(0.05400000140070915f, _177, (_174 * -0.010200000368058681f)))), _195) + _148);
          _257 = (mad(_153, _192, _195) + _149);
        } while (false);
        break;
      }
      case 3: {
        _114 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _115 = 1.0f - _114;
        _116 = _114 * 2.023439884185791f;
        _117 = _114 * -2.5258100032806396f;
        _118 = _114 * 0.4941999912261963f;
        _119 = _114 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_98 > 0.5f) && ((_100 + _99) < 0.5f)) {
              _148 = min(max((_99 + 0.20000000298023224f), 0.0f), 1.0f);
              _149 = min(max((_100 + 0.20000000298023224f), 0.0f), 1.0f);
              _150 = 0.0f;
              _151 = 1.0f;
              _152 = 0.0f;
              _153 = 1.0f;
              _154 = _115;
              _155 = 0.0f;
              _156 = 0.0f;
              _157 = _116;
              _158 = 1.0f;
              _159 = 0.0f;
              _160 = _117;
              _161 = 0.0f;
              _162 = 1.0f;
            } else {
              _148 = _99;
              _149 = _100;
              _150 = 0.0f;
              _151 = 1.0f;
              _152 = 0.0f;
              _153 = 1.0f;
              _154 = _115;
              _155 = 0.0f;
              _156 = 0.0f;
              _157 = _116;
              _158 = 1.0f;
              _159 = 0.0f;
              _160 = _117;
              _161 = 0.0f;
              _162 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_98 > (_99 * 2.0f)) && ((_99 + _98) > _100)) {
                _148 = _99;
                _149 = min(max((_100 + 0.30000001192092896f), 0.0f), 1.0f);
                _150 = 0.0f;
                _151 = 1.0f;
                _152 = 0.0f;
                _153 = 1.0f;
                _154 = 1.0f;
                _155 = _118;
                _156 = 0.0f;
                _157 = 0.0f;
                _158 = _115;
                _159 = 0.0f;
                _160 = 0.0f;
                _161 = _119;
                _162 = 1.0f;
              } else {
                _148 = _99;
                _149 = _100;
                _150 = 0.0f;
                _151 = 1.0f;
                _152 = 0.0f;
                _153 = 1.0f;
                _154 = 1.0f;
                _155 = _118;
                _156 = 0.0f;
                _157 = 0.0f;
                _158 = _115;
                _159 = 0.0f;
                _160 = 0.0f;
                _161 = _119;
                _162 = 1.0f;
              }
            } else {
              _148 = _99;
              _149 = _100;
              _150 = 1.0f;
              _151 = 0.699999988079071f;
              _152 = 0.699999988079071f;
              _153 = 0.0f;
              _154 = 1.0f;
              _155 = 0.0f;
              _156 = (_114 * -0.012245000340044498f);
              _157 = 0.0f;
              _158 = 1.0f;
              _159 = (_114 * 0.07203499972820282f);
              _160 = 0.0f;
              _161 = 0.0f;
              _162 = _115;
            }
          }
          _165 = mad(4.11929988861084f, _100, mad(43.5161018371582f, _99, (_98 * 17.882400512695312f)));
          _168 = mad(3.8671000003814697f, _100, mad(27.155399322509766f, _99, (_98 * 3.455699920654297f)));
          _171 = mad(1.4670000076293945f, _100, mad(0.18431000411510468f, _99, (_98 * 0.02996000088751316f)));
          _174 = mad(_160, _171, mad(_157, _168, (_165 * _154)));
          _177 = mad(_161, _171, mad(_158, _168, (_165 * _155)));
          _180 = mad(_162, _171, mad(_159, _168, (_165 * _156)));
          _190 = _98 - mad(0.11670000106096268f, _180, mad(-0.13050000369548798f, _177, (_174 * 0.08089999854564667f)));
          _192 = _100 - mad(0.6934999823570251f, _180, mad(-0.004100000020116568f, _177, (_174 * -0.0003000000142492354f)));
          _195 = _190 * 0.699999988079071f;
          _255 = (mad(_152, _192, (_190 * _150)) + _98);
          _256 = (mad(_151, (_99 - mad(-0.1136000007390976f, _180, mad(0.05400000140070915f, _177, (_174 * -0.010200000368058681f)))), _195) + _148);
          _257 = (mad(_153, _192, _195) + _149);
        } while (false);
        break;
      }
      case 4: {
        if (((_98 > 0.25f) && (_99 < 0.550000011920929f)) && (_100 < 0.3199999928474426f)) {
          _210 = min(max((_98 + 0.20000000298023224f), 0.0f), 1.0f);
          _255 = _210;
          _256 = _210;
          _257 = (_100 * 0.25f);
        } else {
          _255 = _98;
          _256 = _99;
          _257 = _100;
        }
        break;
      }
      case 5: {
        _217 = ((_98 > 0.25f) && (_99 < 0.3199999928474426f)) && (_100 < 0.3199999928474426f);
        _255 = _98;
        _256 = select(_217, _98, _99);
        _257 = select(_217, (_100 * 0.25f), _100);
        break;
      }
      case 6: {
        if (((_98 > 0.25f) && (_99 < 0.27000001072883606f)) && (_100 < 0.27000001072883606f)) {
          _255 = ((_98 * 0.10000000149011612f) + 0.40400001406669617f);
          _256 = ((_99 * 0.10000000149011612f) + 0.2630000114440918f);
          _257 = min(max(((_100 * 0.10000000149011612f) + 0.906000018119812f), 0.0f), 1.0f);
        } else {
          _255 = _98;
          _256 = _99;
          _257 = _100;
        }
        break;
      }
      case 7: {
        if (((_98 < 0.3499999940395355f) && (_99 > 0.3499999940395355f)) && (_100 > 0.3499999940395355f)) {
          _255 = (_98 * 0.15000000596046448f);
          _256 = (_99 * 0.15000000596046448f);
          _257 = 0.2150000035762787f;
        } else {
          _255 = _98;
          _256 = _99;
          _257 = _100;
        }
        break;
      }
      case 8: {
        if (((_98 > 0.25f) && (_99 < 0.27000001072883606f)) && (_100 < 0.27000001072883606f)) {
          _255 = (_98 * 0.15000000596046448f);
          _256 = (_99 * 0.15000000596046448f);
          _257 = 0.2150000035762787f;
        } else {
          _255 = _98;
          _256 = _99;
          _257 = _100;
        }
        break;
      }
      default: {
        _255 = _98;
        _256 = _99;
        _257 = _100;
        break;
      }
    }
  } else {
    _255 = _98;
    _256 = _99;
    _257 = _100;
  }
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_255, _256, _257, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _412 = color.r;
    _413 = color.g;
    _414 = color.b;
#else  // original code
    _291 = saturate(select((_255 <= 0.040449999272823334f), (_255 * 0.07739938050508499f), exp2(log2(abs((_255 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _292 = saturate(select((_256 <= 0.040449999272823334f), (_256 * 0.07739938050508499f), exp2(log2(abs((_256 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _293 = saturate(select((_257 <= 0.040449999272823334f), (_257 * 0.07739938050508499f), exp2(log2(abs((_257 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _294 = dot(float3(_291, _292, _293), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _302 = select((_294 > 0.5f), (((_294 * HDROutput_016.y) / (HDROutput_016.y - _294)) + HDROutput_016.x), (_294 / (1.000100016593933f - _294)));
    _303 = _294 + 9.999999747378752e-05f;
    _307 = _302 * (_291 / _303);
    _308 = (_292 / _303) * _302;
    _309 = (_293 / _303) * _302;
    _325 = saturate(max(max(_307, _308), _309) + -1.0f);
    _332 = HDROutput_064 * 9.999999747378752e-05f;
    _339 = exp2(log2(abs(_332 * (((1.0f - _325) * mad(0.04331360012292862f, _309, mad(0.3292819857597351f, _308, (_307 * 0.627403974533081f)))) + (_325 * mad(0.047561999410390854f, _309, mad(0.19859300553798676f, _308, (_307 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _348 = exp2(log2(abs(((_339 * 18.8515625f) + 0.8359375f) / ((_339 * 18.6875f) + 1.0f))) * 78.84375f);
    _352 = exp2(log2(abs(_332 * mad(0.012477199546992779f, _309, mad(0.9417769908905029f, _308, (_307 * 0.045745600014925f))))) * 0.1593017578125f);
    _361 = exp2(log2(abs(((_352 * 18.8515625f) + 0.8359375f) / ((_352 * 18.6875f) + 1.0f))) * 78.84375f);
    _365 = exp2(log2(abs(_332 * mad(0.9836069941520691f, _309, mad(0.017604099586606026f, _308, (_307 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _374 = exp2(log2(abs(((_365 * 18.8515625f) + 0.8359375f) / ((_365 * 18.6875f) + 1.0f))) * 78.84375f);
    _383 = saturate(_348 / HDROutput_084);
    _384 = saturate(_361 / HDROutput_084);
    _385 = saturate(_374 / HDROutput_084);
    _386 = HDROutput_084 - HDROutput_036;
    _412 = select((_348 > HDROutput_076), _348, select((_348 < HDROutput_084), max((((_383 * _383) * _386) + HDROutput_036), _348), _348));
    _413 = select((_361 > HDROutput_076), _361, select((_361 < HDROutput_084), max((((_384 * _384) * _386) + HDROutput_036), _361), _361));
    _414 = select((_374 > HDROutput_076), _374, select((_374 < HDROutput_084), max((((_385 * _385) * _386) + HDROutput_036), _374), _374));
#endif
  } else {
    _412 = _255;
    _413 = _256;
    _414 = _257;
  }
  SV_Target.x = _412;
  SV_Target.y = _413;
  SV_Target.z = _414;
  SV_Target.w = _78;
  return SV_Target;
}