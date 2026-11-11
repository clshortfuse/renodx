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
  bool _20;
  uint2 _21;
  float _24;
  float _26;
  float _28;
  float4 _29;
  float _32;
  float _39;
  float _45;
  float _46;
  float _51;
  float _55;
  float _56;
  float _66;
  float4 _71;
  float _80;
  float _124;
  float _125;
  float _126;
  float _175;
  float _176;
  float _177;
  float _178;
  float _179;
  float _180;
  float _181;
  float _182;
  float _183;
  float _184;
  float _185;
  float _186;
  float _187;
  float _188;
  float _189;
  float _282;
  float _283;
  float _284;
  float _439;
  float _440;
  float _441;
  float _141;
  float _142;
  float _143;
  float _144;
  float _145;
  float _146;
  float _192;
  float _195;
  float _198;
  float _201;
  float _204;
  float _207;
  float _217;
  float _219;
  float _222;
  float _237;
  bool _244;
  float _318;
  float _319;
  float _320;
  float _321;
  float _329;
  float _330;
  float _334;
  float _335;
  float _336;
  float _352;
  float _359;
  float _366;
  float _375;
  float _379;
  float _388;
  float _392;
  float _401;
  float _410;
  float _411;
  float _412;
  float _413;
  _20 = ((((float4)(t1.Sample(s0, float2((cb0_092z * SV_Position.x), (cb0_092w * SV_Position.y))))).x) > 0.10000000149011612f);
  if (_20) discard;
  // uint2 _21;
  t0.GetDimensions(_21.x, _21.y);
  _24 = ddx_coarse(TEXCOORD1_centroid.x);
  _26 = ddx_coarse(TEXCOORD1_centroid.z);
  _28 = (_24 * float((int)((int)(_21.x)))) / _26;
  _29 = t0.Sample(s1, float2(TEXCOORD1_centroid.x, TEXCOORD1_centroid.y));
  _32 = min(_29.x, _29.w);
  _39 = ((FireUiPrimitive_364 - FireUiPrimitive_368) * _28) + FireUiPrimitive_368;
  _45 = ((FireUiPrimitive_348 - FireUiPrimitive_360) * _28) + FireUiPrimitive_360;
  _46 = _45 * 2.0f;
  _51 = saturate((((1.0f - _32) - _39) + _45) / _46);
  _55 = (_51 * _51) * (3.0f - (_51 * 2.0f));
  _56 = 1.0f - _55;
  _66 = FireUiPrimitive_380 * (4.0f / _26);
  _71 = t0.Sample(s1, float2((TEXCOORD1_centroid.x - ((FireUiPrimitive_336.x * _24) * _66)), (TEXCOORD1_centroid.y - ((FireUiPrimitive_336.y * ddy_coarse(TEXCOORD1_centroid.y)) * _66))));
  _80 = saturate((((1.0f - _39) + _45) - max(((FireUiPrimitive_372 * _28) + _32), min(_71.x, _71.w))) / _46);
  _124 = (exp2(log2(abs(FireUiPrimitive_016.x * _56)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _125 = (exp2(log2(abs(FireUiPrimitive_016.y * _56)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  _126 = (exp2(log2(abs(FireUiPrimitive_016.z * _56)) * FireUiPrimitive_320.x) * FireUiPrimitive_320.y) + FireUiPrimitive_320.z;
  if (!((((_124 < 9.999999747378752e-05f) && (_125 < 9.999999747378752e-05f)) && (_126 < 9.999999747378752e-05f)) || ((uint)((int)((uint)(FireUiPrimitive_388) + (uint)(-1))) > (uint)7))) {
    switch ((int)(FireUiPrimitive_388)) {
      case 1: {
        _141 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _142 = 1.0f - _141;
        _143 = _141 * 2.023439884185791f;
        _144 = _141 * -2.5258100032806396f;
        _145 = _141 * 0.4941999912261963f;
        _146 = _141 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_124 > 0.5f) && ((_126 + _125) < 0.5f)) {
              _175 = min(max((_125 + 0.20000000298023224f), 0.0f), 1.0f);
              _176 = min(max((_126 + 0.20000000298023224f), 0.0f), 1.0f);
              _177 = 0.0f;
              _178 = 1.0f;
              _179 = 0.0f;
              _180 = 1.0f;
              _181 = _142;
              _182 = 0.0f;
              _183 = 0.0f;
              _184 = _143;
              _185 = 1.0f;
              _186 = 0.0f;
              _187 = _144;
              _188 = 0.0f;
              _189 = 1.0f;
            } else {
              _175 = _125;
              _176 = _126;
              _177 = 0.0f;
              _178 = 1.0f;
              _179 = 0.0f;
              _180 = 1.0f;
              _181 = _142;
              _182 = 0.0f;
              _183 = 0.0f;
              _184 = _143;
              _185 = 1.0f;
              _186 = 0.0f;
              _187 = _144;
              _188 = 0.0f;
              _189 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_124 > (_125 * 2.0f)) && ((_125 + _124) > _126)) {
                _175 = _125;
                _176 = min(max((_126 + 0.30000001192092896f), 0.0f), 1.0f);
                _177 = 0.0f;
                _178 = 1.0f;
                _179 = 0.0f;
                _180 = 1.0f;
                _181 = 1.0f;
                _182 = _145;
                _183 = 0.0f;
                _184 = 0.0f;
                _185 = _142;
                _186 = 0.0f;
                _187 = 0.0f;
                _188 = _146;
                _189 = 1.0f;
              } else {
                _175 = _125;
                _176 = _126;
                _177 = 0.0f;
                _178 = 1.0f;
                _179 = 0.0f;
                _180 = 1.0f;
                _181 = 1.0f;
                _182 = _145;
                _183 = 0.0f;
                _184 = 0.0f;
                _185 = _142;
                _186 = 0.0f;
                _187 = 0.0f;
                _188 = _146;
                _189 = 1.0f;
              }
            } else {
              _175 = _125;
              _176 = _126;
              _177 = 1.0f;
              _178 = 0.699999988079071f;
              _179 = 0.699999988079071f;
              _180 = 0.0f;
              _181 = 1.0f;
              _182 = 0.0f;
              _183 = (_141 * -0.012245000340044498f);
              _184 = 0.0f;
              _185 = 1.0f;
              _186 = (_141 * 0.07203499972820282f);
              _187 = 0.0f;
              _188 = 0.0f;
              _189 = _142;
            }
          }
          _192 = mad(4.11929988861084f, _126, mad(43.5161018371582f, _125, (_124 * 17.882400512695312f)));
          _195 = mad(3.8671000003814697f, _126, mad(27.155399322509766f, _125, (_124 * 3.455699920654297f)));
          _198 = mad(1.4670000076293945f, _126, mad(0.18431000411510468f, _125, (_124 * 0.02996000088751316f)));
          _201 = mad(_187, _198, mad(_184, _195, (_192 * _181)));
          _204 = mad(_188, _198, mad(_185, _195, (_192 * _182)));
          _207 = mad(_189, _198, mad(_186, _195, (_192 * _183)));
          _217 = _124 - mad(0.11670000106096268f, _207, mad(-0.13050000369548798f, _204, (_201 * 0.08089999854564667f)));
          _219 = _126 - mad(0.6934999823570251f, _207, mad(-0.004100000020116568f, _204, (_201 * -0.0003000000142492354f)));
          _222 = _217 * 0.699999988079071f;
          _282 = (mad(_179, _219, (_217 * _177)) + _124);
          _283 = (mad(_178, (_125 - mad(-0.1136000007390976f, _207, mad(0.05400000140070915f, _204, (_201 * -0.010200000368058681f)))), _222) + _175);
          _284 = (mad(_180, _219, _222) + _176);
        } while (false);
        break;
      }
      case 2: {
        _141 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _142 = 1.0f - _141;
        _143 = _141 * 2.023439884185791f;
        _144 = _141 * -2.5258100032806396f;
        _145 = _141 * 0.4941999912261963f;
        _146 = _141 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_124 > 0.5f) && ((_126 + _125) < 0.5f)) {
              _175 = min(max((_125 + 0.20000000298023224f), 0.0f), 1.0f);
              _176 = min(max((_126 + 0.20000000298023224f), 0.0f), 1.0f);
              _177 = 0.0f;
              _178 = 1.0f;
              _179 = 0.0f;
              _180 = 1.0f;
              _181 = _142;
              _182 = 0.0f;
              _183 = 0.0f;
              _184 = _143;
              _185 = 1.0f;
              _186 = 0.0f;
              _187 = _144;
              _188 = 0.0f;
              _189 = 1.0f;
            } else {
              _175 = _125;
              _176 = _126;
              _177 = 0.0f;
              _178 = 1.0f;
              _179 = 0.0f;
              _180 = 1.0f;
              _181 = _142;
              _182 = 0.0f;
              _183 = 0.0f;
              _184 = _143;
              _185 = 1.0f;
              _186 = 0.0f;
              _187 = _144;
              _188 = 0.0f;
              _189 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_124 > (_125 * 2.0f)) && ((_125 + _124) > _126)) {
                _175 = _125;
                _176 = min(max((_126 + 0.30000001192092896f), 0.0f), 1.0f);
                _177 = 0.0f;
                _178 = 1.0f;
                _179 = 0.0f;
                _180 = 1.0f;
                _181 = 1.0f;
                _182 = _145;
                _183 = 0.0f;
                _184 = 0.0f;
                _185 = _142;
                _186 = 0.0f;
                _187 = 0.0f;
                _188 = _146;
                _189 = 1.0f;
              } else {
                _175 = _125;
                _176 = _126;
                _177 = 0.0f;
                _178 = 1.0f;
                _179 = 0.0f;
                _180 = 1.0f;
                _181 = 1.0f;
                _182 = _145;
                _183 = 0.0f;
                _184 = 0.0f;
                _185 = _142;
                _186 = 0.0f;
                _187 = 0.0f;
                _188 = _146;
                _189 = 1.0f;
              }
            } else {
              _175 = _125;
              _176 = _126;
              _177 = 1.0f;
              _178 = 0.699999988079071f;
              _179 = 0.699999988079071f;
              _180 = 0.0f;
              _181 = 1.0f;
              _182 = 0.0f;
              _183 = (_141 * -0.012245000340044498f);
              _184 = 0.0f;
              _185 = 1.0f;
              _186 = (_141 * 0.07203499972820282f);
              _187 = 0.0f;
              _188 = 0.0f;
              _189 = _142;
            }
          }
          _192 = mad(4.11929988861084f, _126, mad(43.5161018371582f, _125, (_124 * 17.882400512695312f)));
          _195 = mad(3.8671000003814697f, _126, mad(27.155399322509766f, _125, (_124 * 3.455699920654297f)));
          _198 = mad(1.4670000076293945f, _126, mad(0.18431000411510468f, _125, (_124 * 0.02996000088751316f)));
          _201 = mad(_187, _198, mad(_184, _195, (_192 * _181)));
          _204 = mad(_188, _198, mad(_185, _195, (_192 * _182)));
          _207 = mad(_189, _198, mad(_186, _195, (_192 * _183)));
          _217 = _124 - mad(0.11670000106096268f, _207, mad(-0.13050000369548798f, _204, (_201 * 0.08089999854564667f)));
          _219 = _126 - mad(0.6934999823570251f, _207, mad(-0.004100000020116568f, _204, (_201 * -0.0003000000142492354f)));
          _222 = _217 * 0.699999988079071f;
          _282 = (mad(_179, _219, (_217 * _177)) + _124);
          _283 = (mad(_178, (_125 - mad(-0.1136000007390976f, _207, mad(0.05400000140070915f, _204, (_201 * -0.010200000368058681f)))), _222) + _175);
          _284 = (mad(_180, _219, _222) + _176);
        } while (false);
        break;
      }
      case 3: {
        _141 = min(max(FireUiPrimitive_332, 0.0f), 1.0f);
        _142 = 1.0f - _141;
        _143 = _141 * 2.023439884185791f;
        _144 = _141 * -2.5258100032806396f;
        _145 = _141 * 0.4941999912261963f;
        _146 = _141 * 1.248270034790039f;
        do {
          if (FireUiPrimitive_388 == 1) {
            if ((_124 > 0.5f) && ((_126 + _125) < 0.5f)) {
              _175 = min(max((_125 + 0.20000000298023224f), 0.0f), 1.0f);
              _176 = min(max((_126 + 0.20000000298023224f), 0.0f), 1.0f);
              _177 = 0.0f;
              _178 = 1.0f;
              _179 = 0.0f;
              _180 = 1.0f;
              _181 = _142;
              _182 = 0.0f;
              _183 = 0.0f;
              _184 = _143;
              _185 = 1.0f;
              _186 = 0.0f;
              _187 = _144;
              _188 = 0.0f;
              _189 = 1.0f;
            } else {
              _175 = _125;
              _176 = _126;
              _177 = 0.0f;
              _178 = 1.0f;
              _179 = 0.0f;
              _180 = 1.0f;
              _181 = _142;
              _182 = 0.0f;
              _183 = 0.0f;
              _184 = _143;
              _185 = 1.0f;
              _186 = 0.0f;
              _187 = _144;
              _188 = 0.0f;
              _189 = 1.0f;
            }
          } else {
            if (FireUiPrimitive_388 == 2) {
              if ((_124 > (_125 * 2.0f)) && ((_125 + _124) > _126)) {
                _175 = _125;
                _176 = min(max((_126 + 0.30000001192092896f), 0.0f), 1.0f);
                _177 = 0.0f;
                _178 = 1.0f;
                _179 = 0.0f;
                _180 = 1.0f;
                _181 = 1.0f;
                _182 = _145;
                _183 = 0.0f;
                _184 = 0.0f;
                _185 = _142;
                _186 = 0.0f;
                _187 = 0.0f;
                _188 = _146;
                _189 = 1.0f;
              } else {
                _175 = _125;
                _176 = _126;
                _177 = 0.0f;
                _178 = 1.0f;
                _179 = 0.0f;
                _180 = 1.0f;
                _181 = 1.0f;
                _182 = _145;
                _183 = 0.0f;
                _184 = 0.0f;
                _185 = _142;
                _186 = 0.0f;
                _187 = 0.0f;
                _188 = _146;
                _189 = 1.0f;
              }
            } else {
              _175 = _125;
              _176 = _126;
              _177 = 1.0f;
              _178 = 0.699999988079071f;
              _179 = 0.699999988079071f;
              _180 = 0.0f;
              _181 = 1.0f;
              _182 = 0.0f;
              _183 = (_141 * -0.012245000340044498f);
              _184 = 0.0f;
              _185 = 1.0f;
              _186 = (_141 * 0.07203499972820282f);
              _187 = 0.0f;
              _188 = 0.0f;
              _189 = _142;
            }
          }
          _192 = mad(4.11929988861084f, _126, mad(43.5161018371582f, _125, (_124 * 17.882400512695312f)));
          _195 = mad(3.8671000003814697f, _126, mad(27.155399322509766f, _125, (_124 * 3.455699920654297f)));
          _198 = mad(1.4670000076293945f, _126, mad(0.18431000411510468f, _125, (_124 * 0.02996000088751316f)));
          _201 = mad(_187, _198, mad(_184, _195, (_192 * _181)));
          _204 = mad(_188, _198, mad(_185, _195, (_192 * _182)));
          _207 = mad(_189, _198, mad(_186, _195, (_192 * _183)));
          _217 = _124 - mad(0.11670000106096268f, _207, mad(-0.13050000369548798f, _204, (_201 * 0.08089999854564667f)));
          _219 = _126 - mad(0.6934999823570251f, _207, mad(-0.004100000020116568f, _204, (_201 * -0.0003000000142492354f)));
          _222 = _217 * 0.699999988079071f;
          _282 = (mad(_179, _219, (_217 * _177)) + _124);
          _283 = (mad(_178, (_125 - mad(-0.1136000007390976f, _207, mad(0.05400000140070915f, _204, (_201 * -0.010200000368058681f)))), _222) + _175);
          _284 = (mad(_180, _219, _222) + _176);
        } while (false);
        break;
      }
      case 4: {
        if (((_124 > 0.25f) && (_125 < 0.550000011920929f)) && (_126 < 0.3199999928474426f)) {
          _237 = min(max((_124 + 0.20000000298023224f), 0.0f), 1.0f);
          _282 = _237;
          _283 = _237;
          _284 = (_126 * 0.25f);
        } else {
          _282 = _124;
          _283 = _125;
          _284 = _126;
        }
        break;
      }
      case 5: {
        _244 = ((_124 > 0.25f) && (_125 < 0.3199999928474426f)) && (_126 < 0.3199999928474426f);
        _282 = _124;
        _283 = select(_244, _124, _125);
        _284 = select(_244, (_126 * 0.25f), _126);
        break;
      }
      case 6: {
        if (((_124 > 0.25f) && (_125 < 0.27000001072883606f)) && (_126 < 0.27000001072883606f)) {
          _282 = ((_124 * 0.10000000149011612f) + 0.40400001406669617f);
          _283 = ((_125 * 0.10000000149011612f) + 0.2630000114440918f);
          _284 = min(max(((_126 * 0.10000000149011612f) + 0.906000018119812f), 0.0f), 1.0f);
        } else {
          _282 = _124;
          _283 = _125;
          _284 = _126;
        }
        break;
      }
      case 7: {
        if (((_124 < 0.3499999940395355f) && (_125 > 0.3499999940395355f)) && (_126 > 0.3499999940395355f)) {
          _282 = (_124 * 0.15000000596046448f);
          _283 = (_125 * 0.15000000596046448f);
          _284 = 0.2150000035762787f;
        } else {
          _282 = _124;
          _283 = _125;
          _284 = _126;
        }
        break;
      }
      case 8: {
        if (((_124 > 0.25f) && (_125 < 0.27000001072883606f)) && (_126 < 0.27000001072883606f)) {
          _282 = (_124 * 0.15000000596046448f);
          _283 = (_125 * 0.15000000596046448f);
          _284 = 0.2150000035762787f;
        } else {
          _282 = _124;
          _283 = _125;
          _284 = _126;
        }
        break;
      }
      default: {
        _282 = _124;
        _283 = _125;
        _284 = _126;
        break;
      }
    }
  } else {
    _282 = _124;
    _283 = _125;
    _284 = _126;
  }
  if (!(FireUiPrimitive_392 == 0)) {
#if 1  // custom code
    float3 color = EncodeUIForHDR(_282, _283, _284, HDROutput_016, HDROutput_036, HDROutput_064, HDROutput_076, HDROutput_084);
    _439 = color.r;
    _440 = color.g;
    _441 = color.b;
#else  // original code
    _318 = saturate(select((_282 <= 0.040449999272823334f), (_282 * 0.07739938050508499f), exp2(log2(abs((_282 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _319 = saturate(select((_283 <= 0.040449999272823334f), (_283 * 0.07739938050508499f), exp2(log2(abs((_283 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _320 = saturate(select((_284 <= 0.040449999272823334f), (_284 * 0.07739938050508499f), exp2(log2(abs((_284 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _321 = dot(float3(_318, _319, _320), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _329 = select((_321 > 0.5f), (((_321 * HDROutput_016.y) / (HDROutput_016.y - _321)) + HDROutput_016.x), (_321 / (1.000100016593933f - _321)));
    _330 = _321 + 9.999999747378752e-05f;
    _334 = _329 * (_318 / _330);
    _335 = (_319 / _330) * _329;
    _336 = (_320 / _330) * _329;
    _352 = saturate(max(max(_334, _335), _336) + -1.0f);
    _359 = HDROutput_064 * 9.999999747378752e-05f;
    _366 = exp2(log2(abs(_359 * (((1.0f - _352) * mad(0.04331360012292862f, _336, mad(0.3292819857597351f, _335, (_334 * 0.627403974533081f)))) + (_352 * mad(0.047561999410390854f, _336, mad(0.19859300553798676f, _335, (_334 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _375 = exp2(log2(abs(((_366 * 18.8515625f) + 0.8359375f) / ((_366 * 18.6875f) + 1.0f))) * 78.84375f);
    _379 = exp2(log2(abs(_359 * mad(0.012477199546992779f, _336, mad(0.9417769908905029f, _335, (_334 * 0.045745600014925f))))) * 0.1593017578125f);
    _388 = exp2(log2(abs(((_379 * 18.8515625f) + 0.8359375f) / ((_379 * 18.6875f) + 1.0f))) * 78.84375f);
    _392 = exp2(log2(abs(_359 * mad(0.9836069941520691f, _336, mad(0.017604099586606026f, _335, (_334 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _401 = exp2(log2(abs(((_392 * 18.8515625f) + 0.8359375f) / ((_392 * 18.6875f) + 1.0f))) * 78.84375f);
    _410 = saturate(_375 / HDROutput_084);
    _411 = saturate(_388 / HDROutput_084);
    _412 = saturate(_401 / HDROutput_084);
    _413 = HDROutput_084 - HDROutput_036;
    _439 = select((_375 > HDROutput_076), _375, select((_375 < HDROutput_084), max((((_410 * _410) * _413) + HDROutput_036), _375), _375));
    _440 = select((_388 > HDROutput_076), _388, select((_388 < HDROutput_084), max((((_411 * _411) * _413) + HDROutput_036), _388), _388));
    _441 = select((_401 > HDROutput_076), _401, select((_401 < HDROutput_084), max((((_412 * _412) * _413) + HDROutput_036), _401), _401));
#endif
  } else {
    _439 = _282;
    _440 = _283;
    _441 = _284;
  }
  SV_Target.x = _439;
  SV_Target.y = _440;
  SV_Target.z = _441;
  SV_Target.w = ((max(_56, (((_55 - ((_80 * _80) * (3.0f - (_80 * 2.0f)))) * dot(float3(FireUiPrimitive_016.x, FireUiPrimitive_016.y, FireUiPrimitive_016.z), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f))) + _56)) * FireUiPrimitive_016.w) * (lerp(FireUiPrimitive_376, 1.0f, _56)));
  return SV_Target;
}