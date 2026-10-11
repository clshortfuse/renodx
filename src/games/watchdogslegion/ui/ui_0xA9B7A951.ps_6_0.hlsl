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
  float _55;
  float _56;
  float _57;
  float _58;
  float _71;
  float _72;
  float _73;
  float _74;
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
  float _155;
  float _156;
  float _157;
  float _158;
  float _251;
  float _252;
  float _253;
  float _408;
  float _409;
  float _410;
  float _94;
  float _95;
  float _96;
  float _110;
  float _111;
  float _112;
  float _113;
  float _114;
  float _115;
  float _161;
  float _164;
  float _167;
  float _170;
  float _173;
  float _176;
  float _186;
  float _188;
  float _191;
  float _206;
  bool _213;
  float _287;
  float _288;
  float _289;
  float _290;
  float _298;
  float _299;
  float _303;
  float _304;
  float _305;
  float _321;
  float _328;
  float _335;
  float _344;
  float _348;
  float _357;
  float _361;
  float _370;
  float _379;
  float _380;
  float _381;
  float _382;
  _12 = t0.Sample(s0, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _19 = (FireUiPrimitive_396 != 0);
  _23 = select(_19, 1.0f, _12.x) * TEXCOORD0_centroid.x;
  _24 = select(_19, 1.0f, _12.y) * TEXCOORD0_centroid.y;
  _25 = select(_19, 1.0f, _12.z) * TEXCOORD0_centroid.z;
  _27 = dot(float3(_23, _24, _25), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  _55 = FireUiPrimitive_016.x * min(max(((lerp(_27, _23, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f);
  _56 = FireUiPrimitive_016.y * min(max(((lerp(_27, _24, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f);
  _57 = FireUiPrimitive_016.z * min(max(((lerp(_27, _25, FireUiPrimitive_344)) * cb0_836w), 0.0f), 64512.0f);
  _58 = (_12.w * TEXCOORD0_centroid.w) * FireUiPrimitive_016.w;
  if (_12.w > 0.0f) {
    _71 = (FireUiPrimitive_000.x + _55);
    _72 = (FireUiPrimitive_000.y + _56);
    _73 = (FireUiPrimitive_000.z + _57);
    _74 = (FireUiPrimitive_000.w + _58);
  } else {
    _71 = _55;
    _72 = _56;
    _73 = _57;
    _74 = _58;
  }
  _94 = (exp2(log2(abs(_71)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _95 = (exp2(log2(abs(_72)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _96 = (exp2(log2(abs(_73)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!((((_94 < 9.999999747378752e-05f) && (_95 < 9.999999747378752e-05f)) && (_96 < 9.999999747378752e-05f)) || ((uint)((int)((uint)(FireUiPrimitive_388) + (uint)(-1))) > (uint)7))) {
    switch ((int)(FireUiPrimitive_388)) {
      case 1: {
        _110 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _111 = 1.0f - _110;
        _112 = _110 * 2.023439884185791f;
        _113 = _110 * -2.5258100032806396f;
        _114 = _110 * 0.4941999912261963f;
        _115 = _110 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_94 > 0.5f) && ((_96 + _95) < 0.5f)) {
              _144 = min(max((_95 + 0.20000000298023224f), 0.0f), 1.0f);
              _145 = min(max((_96 + 0.20000000298023224f), 0.0f), 1.0f);
              _146 = 0.0f;
              _147 = 1.0f;
              _148 = 0.0f;
              _149 = 1.0f;
              _150 = _111;
              _151 = 0.0f;
              _152 = 0.0f;
              _153 = _112;
              _154 = 1.0f;
              _155 = 0.0f;
              _156 = _113;
              _157 = 0.0f;
              _158 = 1.0f;
            } else {
              _144 = _95;
              _145 = _96;
              _146 = 0.0f;
              _147 = 1.0f;
              _148 = 0.0f;
              _149 = 1.0f;
              _150 = _111;
              _151 = 0.0f;
              _152 = 0.0f;
              _153 = _112;
              _154 = 1.0f;
              _155 = 0.0f;
              _156 = _113;
              _157 = 0.0f;
              _158 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_94 > (_95 * 2.0f)) && ((_95 + _94) > _96)) {
                _144 = _95;
                _145 = min(max((_96 + 0.30000001192092896f), 0.0f), 1.0f);
                _146 = 0.0f;
                _147 = 1.0f;
                _148 = 0.0f;
                _149 = 1.0f;
                _150 = 1.0f;
                _151 = _114;
                _152 = 0.0f;
                _153 = 0.0f;
                _154 = _111;
                _155 = 0.0f;
                _156 = 0.0f;
                _157 = _115;
                _158 = 1.0f;
              } else {
                _144 = _95;
                _145 = _96;
                _146 = 0.0f;
                _147 = 1.0f;
                _148 = 0.0f;
                _149 = 1.0f;
                _150 = 1.0f;
                _151 = _114;
                _152 = 0.0f;
                _153 = 0.0f;
                _154 = _111;
                _155 = 0.0f;
                _156 = 0.0f;
                _157 = _115;
                _158 = 1.0f;
              }
            } else {
              _144 = _95;
              _145 = _96;
              _146 = 1.0f;
              _147 = 0.699999988079071f;
              _148 = 0.699999988079071f;
              _149 = 0.0f;
              _150 = 1.0f;
              _151 = 0.0f;
              _152 = (_110 * -0.012245000340044498f);
              _153 = 0.0f;
              _154 = 1.0f;
              _155 = (_110 * 0.07203499972820282f);
              _156 = 0.0f;
              _157 = 0.0f;
              _158 = _111;
            }
          }
          _161 = mad(4.11929988861084f, _96, mad(43.5161018371582f, _95, (_94 * 17.882400512695312f)));
          _164 = mad(3.8671000003814697f, _96, mad(27.155399322509766f, _95, (_94 * 3.455699920654297f)));
          _167 = mad(1.4670000076293945f, _96, mad(0.18431000411510468f, _95, (_94 * 0.02996000088751316f)));
          _170 = mad(_156, _167, mad(_153, _164, (_161 * _150)));
          _173 = mad(_157, _167, mad(_154, _164, (_161 * _151)));
          _176 = mad(_158, _167, mad(_155, _164, (_161 * _152)));
          _186 = _94 - mad(0.11670000106096268f, _176, mad(-0.13050000369548798f, _173, (_170 * 0.08089999854564667f)));
          _188 = _96 - mad(0.6934999823570251f, _176, mad(-0.004100000020116568f, _173, (_170 * -0.0003000000142492354f)));
          _191 = _186 * 0.699999988079071f;
          _251 = (mad(_148, _188, (_186 * _146)) + _94);
          _252 = (mad(_147, (_95 - mad(-0.1136000007390976f, _176, mad(0.05400000140070915f, _173, (_170 * -0.010200000368058681f)))), _191) + _144);
          _253 = (mad(_149, _188, _191) + _145);
        } while (false);
        break;
      }
      case 2: {
        _110 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _111 = 1.0f - _110;
        _112 = _110 * 2.023439884185791f;
        _113 = _110 * -2.5258100032806396f;
        _114 = _110 * 0.4941999912261963f;
        _115 = _110 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_94 > 0.5f) && ((_96 + _95) < 0.5f)) {
              _144 = min(max((_95 + 0.20000000298023224f), 0.0f), 1.0f);
              _145 = min(max((_96 + 0.20000000298023224f), 0.0f), 1.0f);
              _146 = 0.0f;
              _147 = 1.0f;
              _148 = 0.0f;
              _149 = 1.0f;
              _150 = _111;
              _151 = 0.0f;
              _152 = 0.0f;
              _153 = _112;
              _154 = 1.0f;
              _155 = 0.0f;
              _156 = _113;
              _157 = 0.0f;
              _158 = 1.0f;
            } else {
              _144 = _95;
              _145 = _96;
              _146 = 0.0f;
              _147 = 1.0f;
              _148 = 0.0f;
              _149 = 1.0f;
              _150 = _111;
              _151 = 0.0f;
              _152 = 0.0f;
              _153 = _112;
              _154 = 1.0f;
              _155 = 0.0f;
              _156 = _113;
              _157 = 0.0f;
              _158 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_94 > (_95 * 2.0f)) && ((_95 + _94) > _96)) {
                _144 = _95;
                _145 = min(max((_96 + 0.30000001192092896f), 0.0f), 1.0f);
                _146 = 0.0f;
                _147 = 1.0f;
                _148 = 0.0f;
                _149 = 1.0f;
                _150 = 1.0f;
                _151 = _114;
                _152 = 0.0f;
                _153 = 0.0f;
                _154 = _111;
                _155 = 0.0f;
                _156 = 0.0f;
                _157 = _115;
                _158 = 1.0f;
              } else {
                _144 = _95;
                _145 = _96;
                _146 = 0.0f;
                _147 = 1.0f;
                _148 = 0.0f;
                _149 = 1.0f;
                _150 = 1.0f;
                _151 = _114;
                _152 = 0.0f;
                _153 = 0.0f;
                _154 = _111;
                _155 = 0.0f;
                _156 = 0.0f;
                _157 = _115;
                _158 = 1.0f;
              }
            } else {
              _144 = _95;
              _145 = _96;
              _146 = 1.0f;
              _147 = 0.699999988079071f;
              _148 = 0.699999988079071f;
              _149 = 0.0f;
              _150 = 1.0f;
              _151 = 0.0f;
              _152 = (_110 * -0.012245000340044498f);
              _153 = 0.0f;
              _154 = 1.0f;
              _155 = (_110 * 0.07203499972820282f);
              _156 = 0.0f;
              _157 = 0.0f;
              _158 = _111;
            }
          }
          _161 = mad(4.11929988861084f, _96, mad(43.5161018371582f, _95, (_94 * 17.882400512695312f)));
          _164 = mad(3.8671000003814697f, _96, mad(27.155399322509766f, _95, (_94 * 3.455699920654297f)));
          _167 = mad(1.4670000076293945f, _96, mad(0.18431000411510468f, _95, (_94 * 0.02996000088751316f)));
          _170 = mad(_156, _167, mad(_153, _164, (_161 * _150)));
          _173 = mad(_157, _167, mad(_154, _164, (_161 * _151)));
          _176 = mad(_158, _167, mad(_155, _164, (_161 * _152)));
          _186 = _94 - mad(0.11670000106096268f, _176, mad(-0.13050000369548798f, _173, (_170 * 0.08089999854564667f)));
          _188 = _96 - mad(0.6934999823570251f, _176, mad(-0.004100000020116568f, _173, (_170 * -0.0003000000142492354f)));
          _191 = _186 * 0.699999988079071f;
          _251 = (mad(_148, _188, (_186 * _146)) + _94);
          _252 = (mad(_147, (_95 - mad(-0.1136000007390976f, _176, mad(0.05400000140070915f, _173, (_170 * -0.010200000368058681f)))), _191) + _144);
          _253 = (mad(_149, _188, _191) + _145);
        } while (false);
        break;
      }
      case 3: {
        _110 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _111 = 1.0f - _110;
        _112 = _110 * 2.023439884185791f;
        _113 = _110 * -2.5258100032806396f;
        _114 = _110 * 0.4941999912261963f;
        _115 = _110 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_94 > 0.5f) && ((_96 + _95) < 0.5f)) {
              _144 = min(max((_95 + 0.20000000298023224f), 0.0f), 1.0f);
              _145 = min(max((_96 + 0.20000000298023224f), 0.0f), 1.0f);
              _146 = 0.0f;
              _147 = 1.0f;
              _148 = 0.0f;
              _149 = 1.0f;
              _150 = _111;
              _151 = 0.0f;
              _152 = 0.0f;
              _153 = _112;
              _154 = 1.0f;
              _155 = 0.0f;
              _156 = _113;
              _157 = 0.0f;
              _158 = 1.0f;
            } else {
              _144 = _95;
              _145 = _96;
              _146 = 0.0f;
              _147 = 1.0f;
              _148 = 0.0f;
              _149 = 1.0f;
              _150 = _111;
              _151 = 0.0f;
              _152 = 0.0f;
              _153 = _112;
              _154 = 1.0f;
              _155 = 0.0f;
              _156 = _113;
              _157 = 0.0f;
              _158 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_94 > (_95 * 2.0f)) && ((_95 + _94) > _96)) {
                _144 = _95;
                _145 = min(max((_96 + 0.30000001192092896f), 0.0f), 1.0f);
                _146 = 0.0f;
                _147 = 1.0f;
                _148 = 0.0f;
                _149 = 1.0f;
                _150 = 1.0f;
                _151 = _114;
                _152 = 0.0f;
                _153 = 0.0f;
                _154 = _111;
                _155 = 0.0f;
                _156 = 0.0f;
                _157 = _115;
                _158 = 1.0f;
              } else {
                _144 = _95;
                _145 = _96;
                _146 = 0.0f;
                _147 = 1.0f;
                _148 = 0.0f;
                _149 = 1.0f;
                _150 = 1.0f;
                _151 = _114;
                _152 = 0.0f;
                _153 = 0.0f;
                _154 = _111;
                _155 = 0.0f;
                _156 = 0.0f;
                _157 = _115;
                _158 = 1.0f;
              }
            } else {
              _144 = _95;
              _145 = _96;
              _146 = 1.0f;
              _147 = 0.699999988079071f;
              _148 = 0.699999988079071f;
              _149 = 0.0f;
              _150 = 1.0f;
              _151 = 0.0f;
              _152 = (_110 * -0.012245000340044498f);
              _153 = 0.0f;
              _154 = 1.0f;
              _155 = (_110 * 0.07203499972820282f);
              _156 = 0.0f;
              _157 = 0.0f;
              _158 = _111;
            }
          }
          _161 = mad(4.11929988861084f, _96, mad(43.5161018371582f, _95, (_94 * 17.882400512695312f)));
          _164 = mad(3.8671000003814697f, _96, mad(27.155399322509766f, _95, (_94 * 3.455699920654297f)));
          _167 = mad(1.4670000076293945f, _96, mad(0.18431000411510468f, _95, (_94 * 0.02996000088751316f)));
          _170 = mad(_156, _167, mad(_153, _164, (_161 * _150)));
          _173 = mad(_157, _167, mad(_154, _164, (_161 * _151)));
          _176 = mad(_158, _167, mad(_155, _164, (_161 * _152)));
          _186 = _94 - mad(0.11670000106096268f, _176, mad(-0.13050000369548798f, _173, (_170 * 0.08089999854564667f)));
          _188 = _96 - mad(0.6934999823570251f, _176, mad(-0.004100000020116568f, _173, (_170 * -0.0003000000142492354f)));
          _191 = _186 * 0.699999988079071f;
          _251 = (mad(_148, _188, (_186 * _146)) + _94);
          _252 = (mad(_147, (_95 - mad(-0.1136000007390976f, _176, mad(0.05400000140070915f, _173, (_170 * -0.010200000368058681f)))), _191) + _144);
          _253 = (mad(_149, _188, _191) + _145);
        } while (false);
        break;
      }
      case 4: {
        if (((_94 > 0.25f) && (_95 < 0.550000011920929f)) && (_96 < 0.3199999928474426f)) {
          _206 = min(max((_94 + 0.20000000298023224f), 0.0f), 1.0f);
          _251 = _206;
          _252 = _206;
          _253 = (_96 * 0.25f);
        } else {
          _251 = _94;
          _252 = _95;
          _253 = _96;
        }
        break;
      }
      case 5: {
        _213 = ((_94 > 0.25f) && (_95 < 0.3199999928474426f)) && (_96 < 0.3199999928474426f);
        _251 = _94;
        _252 = select(_213, _94, _95);
        _253 = select(_213, (_96 * 0.25f), _96);
        break;
      }
      case 6: {
        if (((_94 > 0.25f) && (_95 < 0.27000001072883606f)) && (_96 < 0.27000001072883606f)) {
          _251 = ((_94 * 0.10000000149011612f) + 0.40400001406669617f);
          _252 = ((_95 * 0.10000000149011612f) + 0.2630000114440918f);
          _253 = min(max(((_96 * 0.10000000149011612f) + 0.906000018119812f), 0.0f), 1.0f);
        } else {
          _251 = _94;
          _252 = _95;
          _253 = _96;
        }
        break;
      }
      case 7: {
        if (((_94 < 0.3499999940395355f) && (_95 > 0.3499999940395355f)) && (_96 > 0.3499999940395355f)) {
          _251 = (_94 * 0.15000000596046448f);
          _252 = (_95 * 0.15000000596046448f);
          _253 = 0.2150000035762787f;
        } else {
          _251 = _94;
          _252 = _95;
          _253 = _96;
        }
        break;
      }
      case 8: {
        if (((_94 > 0.25f) && (_95 < 0.27000001072883606f)) && (_96 < 0.27000001072883606f)) {
          _251 = (_94 * 0.15000000596046448f);
          _252 = (_95 * 0.15000000596046448f);
          _253 = 0.2150000035762787f;
        } else {
          _251 = _94;
          _252 = _95;
          _253 = _96;
        }
        break;
      }
      default: {
        _251 = _94;
        _252 = _95;
        _253 = _96;
        break;
      }
    }
  } else {
    _251 = _94;
    _252 = _95;
    _253 = _96;
  }
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_251, _252, _253, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _408 = color.r;
    _409 = color.g;
    _410 = color.b;
#else  // original code
    _287 = saturate(select((_251 <= 0.040449999272823334f), (_251 * 0.07739938050508499f), exp2(log2(abs((_251 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _288 = saturate(select((_252 <= 0.040449999272823334f), (_252 * 0.07739938050508499f), exp2(log2(abs((_252 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _289 = saturate(select((_253 <= 0.040449999272823334f), (_253 * 0.07739938050508499f), exp2(log2(abs((_253 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _290 = dot(float3(_287, _288, _289), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _298 = select((_290 > 0.5f), (((_290 * HDROutput_016.y) / (HDROutput_016.y - _290)) + HDROutput_016.x), (_290 / (1.000100016593933f - _290)));
    _299 = _290 + 9.999999747378752e-05f;
    _303 = _298 * (_287 / _299);
    _304 = (_288 / _299) * _298;
    _305 = (_289 / _299) * _298;
    _321 = saturate(max(max(_303, _304), _305) + -1.0f);
    _328 = HDROutput_064 * 9.999999747378752e-05f;
    _335 = exp2(log2(abs(_328 * (((1.0f - _321) * mad(0.04331360012292862f, _305, mad(0.3292819857597351f, _304, (_303 * 0.627403974533081f)))) + (_321 * mad(0.047561999410390854f, _305, mad(0.19859300553798676f, _304, (_303 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _344 = exp2(log2(abs(((_335 * 18.8515625f) + 0.8359375f) / ((_335 * 18.6875f) + 1.0f))) * 78.84375f);
    _348 = exp2(log2(abs(_328 * mad(0.012477199546992779f, _305, mad(0.9417769908905029f, _304, (_303 * 0.045745600014925f))))) * 0.1593017578125f);
    _357 = exp2(log2(abs(((_348 * 18.8515625f) + 0.8359375f) / ((_348 * 18.6875f) + 1.0f))) * 78.84375f);
    _361 = exp2(log2(abs(_328 * mad(0.9836069941520691f, _305, mad(0.017604099586606026f, _304, (_303 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _370 = exp2(log2(abs(((_361 * 18.8515625f) + 0.8359375f) / ((_361 * 18.6875f) + 1.0f))) * 78.84375f);
    _379 = saturate(_344 / HDROutput_084);
    _380 = saturate(_357 / HDROutput_084);
    _381 = saturate(_370 / HDROutput_084);
    _382 = HDROutput_084 - HDROutput_036;
    _408 = select((_344 > HDROutput_076), _344, select((_344 < HDROutput_084), max((((_379 * _379) * _382) + HDROutput_036), _344), _344));
    _409 = select((_357 > HDROutput_076), _357, select((_357 < HDROutput_084), max((((_380 * _380) * _382) + HDROutput_036), _357), _357));
    _410 = select((_370 > HDROutput_076), _370, select((_370 < HDROutput_084), max((((_381 * _381) * _382) + HDROutput_036), _370), _370));
#endif
  } else {
    _408 = _251;
    _409 = _252;
    _410 = _253;
  }
  SV_Target.x = _408;
  SV_Target.y = _409;
  SV_Target.z = _410;
  SV_Target.w = _74;
  return SV_Target;
}