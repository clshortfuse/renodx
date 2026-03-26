#include "./tonemap.hlsli"

cbuffer _33_35 : register(b0, space3) {
  float4 _35_m0[1] : packoffset(c0);
};

cbuffer _38_40 : register(b0, space5) {
  float4 _40_m0[23] : packoffset(c0);
};

// SamplerState _8[] : register(s0, space0);
Texture2D<uint4> _12 : register(t0, space3);
Texture2D<float4> _16 : register(t1, space3);
Texture2D<float4> _17 : register(t2, space3);
Texture2D<float4> _18 : register(t4, space3);
Texture2D<float4> _19 : register(t5, space3);
Texture2D<float4> _20 : register(t6, space3);
Texture2D<float4> _21 : register(t7, space3);
Texture2D<float4> _22 : register(t8, space3);
Texture2D<float4> _23 : register(t9, space3);
Buffer<float4> _26 : register(t0, space5);
Texture3D<float4> _29 : register(t1, space5);

static float2 TEXCOORD;
static float4 SV_Target;
static float SV_Target_1;

struct SPIRV_Cross_Input {
  noperspective float4 SV_Position : SV_Position;
  linear float2 TEXCOORD : TEXCOORD;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
  float SV_Target_1 : SV_Target1;
};

uint2 spvTextureSize(Texture2D<float4> Tex, uint Level, out uint Param) {
  uint2 ret;
  Tex.GetDimensions(Level, ret.x, ret.y, Param);
  return ret;
}

void frag_main() {
  uint4 _68 = asuint(_35_m0[0u]);
  uint _69 = _68.z;
  uint _70 = _68.w;
  uint4 _138 = asuint(_40_m0[13u]);
  uint _139 = _138.x;
  uint _140 = _138.y;
  uint _141 = _138.z;
  uint _142 = _138.w;
  uint4 _159 = asuint(_40_m0[21u]);
  float _59[3];
  float _60[3];
  float _181 = ((_40_m0[0u].x * TEXCOORD.x) + _40_m0[0u].z) + (-0.5f);
  float _183 = ((_40_m0[0u].y * TEXCOORD.y) + _40_m0[0u].w) + (-0.5f);
  float _192 = (((_40_m0[6u].z * _181) + 0.5f) * 2.0f) + (-1.0f);
  float _194 = (((_40_m0[6u].z * _183) + 0.5f) * 2.0f) + (-1.0f);
  float _195 = _192 * _40_m0[8u].x;
  float _196 = _194 * _40_m0[8u].y;
  float _197 = dot(float2(_195, _196), float2(_195, _196));
  float _200 = _197 * _197;
  float _201 = _40_m0[6u].x * 2.0f;
  float _202 = _40_m0[6u].y * 4.0f;
  float _209 = _40_m0[6u].x * 3.0f;
  float _211 = _40_m0[6u].y * 5.0f;
  float _225 = (dot(1.0f.xx, float2(_201, _202)) + 1.0f) / (dot(1.0f.xx, float2(_209, _211)) + 1.0f);
  float _227 = (dot(float2(_197, _200), float2(_201, _202)) + 1.0f) / (_225 * (dot(float2(_197, _200), float2(_209, _211)) + 1.0f));
  bool _229 = _40_m0[6u].w != 0.0f;
  float _234 = log2(abs(_229 ? _192 : _194));
  float _241 = _40_m0[7u].x * 0.5f;
  float _245 = ((((1.0f - _227) * _241) * (exp2(_234 * _40_m0[7u].z) + exp2(_234 * _40_m0[7u].y))) + _227) * 0.5f;
  float _248 = (_245 * _192) + 0.5f;
  float _249 = (_245 * _194) + 0.5f;
  _59[0u] = _248;
  _60[0u] = _249;
  float _254 = _40_m0[9u].x * _40_m0[6u].z;
  float _261 = (((_254 * _181) + 0.5f) * 2.0f) + (-1.0f);
  float _262 = (((_254 * _183) + 0.5f) * 2.0f) + (-1.0f);
  float _263 = _261 * _40_m0[8u].x;
  float _264 = _262 * _40_m0[8u].y;
  float _265 = dot(float2(_263, _264), float2(_263, _264));
  float _268 = _265 * _265;
  float _278 = (dot(float2(_265, _268), float2(_201, _202)) + 1.0f) / ((dot(float2(_265, _268), float2(_209, _211)) + 1.0f) * _225);
  float _281 = log2(abs(_229 ? _261 : _262));
  float _291 = ((((1.0f - _278) * _241) * (exp2(_281 * _40_m0[7u].z) + exp2(_281 * _40_m0[7u].y))) + _278) * 0.5f;
  _59[1u] = (_291 * _261) + 0.5f;
  _60[1u] = (_291 * _262) + 0.5f;
  float _296 = _40_m0[9u].y * _40_m0[6u].z;
  float _303 = (((_296 * _181) + 0.5f) * 2.0f) + (-1.0f);
  float _304 = (((_296 * _183) + 0.5f) * 2.0f) + (-1.0f);
  float _305 = _303 * _40_m0[8u].x;
  float _306 = _304 * _40_m0[8u].y;
  float _307 = dot(float2(_305, _306), float2(_305, _306));
  float _310 = _307 * _307;
  float _320 = (dot(float2(_307, _310), float2(_201, _202)) + 1.0f) / ((dot(float2(_307, _310), float2(_209, _211)) + 1.0f) * _225);
  float _323 = log2(abs(_229 ? _303 : _304));
  float _333 = ((((1.0f - _320) * _241) * (exp2(_323 * _40_m0[7u].z) + exp2(_323 * _40_m0[7u].y))) + _320) * 0.5f;
  _59[2u] = (_333 * _303) + 0.5f;
  _60[2u] = (_333 * _304) + 0.5f;
  uint _340_dummy_parameter;
  uint2 _340 = spvTextureSize(_18, 0u, _340_dummy_parameter);
  float _342 = float(int(_340.x));
  float _344 = float(int(_340.y));
  float _345 = 1.0f / _40_m0[0u].x;
  float _346 = 1.0f / _40_m0[0u].y;
  uint _352;
  float _61[3];
  float _62[3];
  float _63[3];
  float _347 = _249;
  float _349 = _248;
  uint _351 = 0u;
  float _357;
  float _358;
  float _370;
  float _371;
  float _372;
  uint _397;
  bool _398;
  for (;;) {
    float _353 = _349 * _345;
    float _355 = _347 * _346;
    _357 = _353 * _40_m0[22u].x;
    _358 = _355 * _40_m0[22u].y;
    float4 _368 = _18.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_353 * _40_m0[21u].z, _355 * _40_m0[21u].w));
    _370 = _368.x;
    _371 = _368.y;
    _372 = _368.z;
    float _375 = float(int(_139));
    float _376 = float(int(_140));
    float _382 = float(int(uint(int(uint(clamp(_357, 0.0f, 1.0f) * _342)) >> int(_69 & 31u))));
    float _383 = float(int(uint(int(uint(clamp(_358, 0.0f, 1.0f) * _344)) >> int(_70 & 31u))));
    _397 = _12.Load(int3(uint2(uint(int(max(min(_382, _375), min(max(_382, _375), float(int(_141)))))), uint(int(max(min(_383, _376), min(max(_383, _376), float(int(_142))))))), 0u)).x;
    _398 = _397 == 0u;
    float _399;
    float _404;
    float _409;
    if (_398) {
      _399 = _370;
      _404 = _371;
      _409 = _372;
    } else {
      float frontier_phi_2_3_ladder;
      float frontier_phi_2_3_ladder_1;
      float frontier_phi_2_3_ladder_2;
      if ((_397 & 536870912u) == 0u) {
        float4 _562 = _20.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_357, _358));
        float _403 = _562.x;
        float _408 = _562.y;
        float _413 = _562.z;
        float frontier_phi_2_3_ladder_6_ladder;
        float frontier_phi_2_3_ladder_6_ladder_1;
        float frontier_phi_2_3_ladder_6_ladder_2;
        if ((_397 & 268435456u) == 0u) {
          float4 _606 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_357, _358));
          float4 _611 = _17.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_357, _358));
          float _613 = _611.x;
          float _618 = clamp((_606.x * 4.80000019073486328125f) + (-0.20000000298023223876953125f), 0.0f, 1.0f);
          float _402 = (_618 * (_403 - _370)) + _370;
          float _407 = (_618 * (_408 - _371)) + _371;
          float _412 = (_618 * (_413 - _372)) + _372;
          float4 _627 = _19.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_357, _358));
          float frontier_phi_2_3_ladder_6_ladder_10_ladder;
          float frontier_phi_2_3_ladder_6_ladder_10_ladder_1;
          float frontier_phi_2_3_ladder_6_ladder_10_ladder_2;
          if ((_627.z > 0.0f) || ((_627.x > 0.0f) || (_627.y > 0.0f))) {
            float4 _671 = _19.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_357, _358));
            frontier_phi_2_3_ladder_6_ladder_10_ladder = ((_671.z - _412) * _613) + _412;
            frontier_phi_2_3_ladder_6_ladder_10_ladder_1 = ((_671.y - _407) * _613) + _407;
            frontier_phi_2_3_ladder_6_ladder_10_ladder_2 = ((_671.x - _402) * _613) + _402;
          } else {
            frontier_phi_2_3_ladder_6_ladder_10_ladder = _412;
            frontier_phi_2_3_ladder_6_ladder_10_ladder_1 = _407;
            frontier_phi_2_3_ladder_6_ladder_10_ladder_2 = _402;
          }
          frontier_phi_2_3_ladder_6_ladder = frontier_phi_2_3_ladder_6_ladder_10_ladder;
          frontier_phi_2_3_ladder_6_ladder_1 = frontier_phi_2_3_ladder_6_ladder_10_ladder_1;
          frontier_phi_2_3_ladder_6_ladder_2 = frontier_phi_2_3_ladder_6_ladder_10_ladder_2;
        } else {
          frontier_phi_2_3_ladder_6_ladder = _413;
          frontier_phi_2_3_ladder_6_ladder_1 = _408;
          frontier_phi_2_3_ladder_6_ladder_2 = _403;
        }
        frontier_phi_2_3_ladder = frontier_phi_2_3_ladder_6_ladder;
        frontier_phi_2_3_ladder_1 = frontier_phi_2_3_ladder_6_ladder_1;
        frontier_phi_2_3_ladder_2 = frontier_phi_2_3_ladder_6_ladder_2;
      } else {
        float4 _566 = _19.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_357, _358));
        frontier_phi_2_3_ladder = _566.z;
        frontier_phi_2_3_ladder_1 = _566.y;
        frontier_phi_2_3_ladder_2 = _566.x;
      }
      _399 = frontier_phi_2_3_ladder_2;
      _404 = frontier_phi_2_3_ladder_1;
      _409 = frontier_phi_2_3_ladder;
    }
    _61[_351] = _399;
    _62[_351] = _404;
    _63[_351] = _409;
    _352 = _351 + 1u;
    if (_352 == 3u) {
      break;
    }
    _347 = _60[_352];
    _349 = _59[_352];
    _351 = _352;
    continue;
  }
  uint _439 = _159.y;
  float _448 = (_248 - _40_m0[0u].z) / _40_m0[0u].x;
  float _449 = (_249 - _40_m0[0u].w) / _40_m0[0u].y;
  float4 _451 = _26.Load(2u);
  float _452 = _451.x;
  float4 _455 = _21.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_448, _449));
  float _457 = _455.x;
  float _458 = _455.y;
  float _459 = _455.z;
  float4 _462 = _22.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_448, _449));
  float _470 = _40_m0[19u].y * 0.25f;
  float _472 = _61[1u] * _470;
  float _473 = _62[2u] * _470;
  float _474 = _63[0u] * _470;
  float _487 = (clamp(dot(float3(_472, _473, _474), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) + 9.9999999747524270787835121154785e-07f, 0.0f, 1.0f) * (1.0f - _40_m0[17u].w)) + _40_m0[17u].w;
  float _503 = (exp2(log2(max(_472, 0.0f)) * _487) / _470) * _40_m0[17u].w;
  float _504 = (exp2(log2(max(_473, 0.0f)) * _487) / _470) * _40_m0[17u].w;
  float _505 = (exp2(log2(max(_474, 0.0f)) * _487) / _470) * _40_m0[17u].w;
  float _506 = (_457 * _457) / _40_m0[19u].z;
  float _507 = (_458 * _458) / _40_m0[19u].z;
  float _508 = (_459 * _459) / _40_m0[19u].z;
  float _511 = (_452 * 4.0f) / (_452 + 0.25f);
  float _515 = max(_452, 1.0000000031710768509710513471353e-30f);
  float _528 = 1.0f / ((_452 + 1.0f) + _511);
  float _542 = (((_507 + _504) + (sqrt((_507 * _504) / _515) * _511)) * _528) + (_462.y * _40_m0[19u].x);
  float _548 = ((_542 * (_40_m0[17u].x - _40_m0[17u].y)) + (((_528 * ((_506 + _503) + (sqrt((_506 * _503) / _515) * _511))) + (_462.x * _40_m0[19u].x)) * _40_m0[17u].x)) * _40_m0[19u].z;
  float _550 = (_40_m0[19u].z * _40_m0[17u].y) * _542;
  float _552 = (_40_m0[19u].z * _40_m0[17u].z) * ((((_508 + _505) + (sqrt((_508 * _505) / _515) * _511)) * _528) + (_462.z * _40_m0[19u].x));
  float _568;
  float _570;
  float _572;
  if ((_439 & 1u) == 0u) {
    _568 = _548;
    _570 = _550;
    _572 = _552;
  } else {
    uint _580 = asuint(_40_m0[11u].z);
    float _600 = (_23.Sample((SamplerState)ResourceDescriptorHeap[17u], float2((_248 * _40_m0[11u].x) + (float(_580 & 65535u) * 1.52587890625e-05f), (_249 * _40_m0[11u].y) + (float(_580 >> 16u) * 1.52587890625e-05f))).y + (-0.5f)) * _455.w;
    _568 = max(_600 + _548, 0.0f);
    _570 = max(_600 + _550, 0.0f);
    _572 = max(_600 + _552, 0.0f);
  }
  float _637;
  float _639;
  float _641;
  if ((_439 & 32u) == 0u) {
    _637 = _568;
    _639 = _570;
    _641 = _572;
  } else {
    float _651 = (_248 * 2.0f) + (-1.0f);
    float _652 = (_249 * 2.0f) + (-1.0f);
    float _659 = clamp((sqrt((_652 * _652) + (_651 * _651)) * _40_m0[10u].x) + _40_m0[10u].y, 0.0f, 1.0f);
    float _661 = (_659 * _659) * _40_m0[1u].w;
    float _662 = 1.0f - _661;
    float _666 = (_528 * _40_m0[19u].z) * _661;
    _637 = (_662 * _568) + (_666 * _40_m0[1u].x);
    _639 = (_662 * _570) + (_666 * _40_m0[1u].y);
    _641 = (_662 * _572) + (_666 * _40_m0[1u].z);
  }
  float _643 = max(_637, 9.9999999747524270787835121154785e-07f);
  float _644 = max(_639, 9.9999999747524270787835121154785e-07f);
  float _645 = max(_641, 9.9999999747524270787835121154785e-07f);
  float _682;
  float _685;
  float _688;
  if ((_439 & 16u) == 0u) {
    _682 = _643;
    _685 = _644;
    _688 = _645;
  } else {
    float frontier_phi_14_15_ladder;
    float frontier_phi_14_15_ladder_1;
    float frontier_phi_14_15_ladder_2;
    if (asuint(_40_m0[12u]).w == 0u) {
#if 1
      ApplyTonemapGamma2LUTAndInverseTonemap(
          (SamplerState)ResourceDescriptorHeap[2u],
          _29,
          _643, _644, _645,
          _40_m0[2u].w,
          _40_m0[2u].x, _40_m0[2u].y, _40_m0[2u].z,
          _40_m0[3u].x, _40_m0[3u].y, _40_m0[3u].z, _40_m0[3u].w,
          _40_m0[10u].z, _40_m0[10u].w,
          frontier_phi_14_15_ladder,
          frontier_phi_14_15_ladder_1,
          frontier_phi_14_15_ladder_2);
#else
      // tonemap + gamma 2 encode + sample LUT
      float _729 = (-0.0f) - _40_m0[2u].w;
      float4 _762 = _29.SampleLevel((SamplerState)ResourceDescriptorHeap[2u],
                                    float3((clamp(sqrt(max((_643 < _40_m0[3u].z) ? ((_643 * _40_m0[2u].y) + _40_m0[2u].z) : ((_729 / (_643 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w,
                                           (clamp(sqrt(max((_644 < _40_m0[3u].z) ? ((_644 * _40_m0[2u].y) + _40_m0[2u].z) : ((_729 / (_644 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w,
                                           (clamp(sqrt(max((_645 < _40_m0[3u].z) ? ((_645 * _40_m0[2u].y) + _40_m0[2u].z) : ((_729 / (_645 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w),
                                    0.0f);
      float _764 = _762.x;
      float _765 = _762.y;
      float _766 = _762.z;

      // gamma 2 -> linear with clamp
      float _770 = min(_764 * _764, _40_m0[2u].x);
      float _771 = min(_765 * _765, _40_m0[2u].x);
      float _772 = min(_766 * _766, _40_m0[2u].x);

      // inverse tonemap
      frontier_phi_14_15_ladder = (_772 < _40_m0[3u].w) ? ((_772 - _40_m0[2u].z) / _40_m0[2u].y) : ((_729 / (_772 - _40_m0[3u].y)) - _40_m0[3u].x);
      frontier_phi_14_15_ladder_1 = (_771 < _40_m0[3u].w) ? ((_771 - _40_m0[2u].z) / _40_m0[2u].y) : ((_729 / (_771 - _40_m0[3u].y)) - _40_m0[3u].x);
      frontier_phi_14_15_ladder_2 = (_770 < _40_m0[3u].w) ? ((_770 - _40_m0[2u].z) / _40_m0[2u].y) : ((_729 / (_770 - _40_m0[3u].y)) - _40_m0[3u].x);
#endif
    } else {
      float _805 = exp2(log2(abs(_643 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _806 = exp2(log2(abs(_644 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _807 = exp2(log2(abs(_645 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float4 _849 = _29.SampleLevel(
          (SamplerState)ResourceDescriptorHeap[2u],
          float3(
              (clamp(exp2(log2(abs(((_805 * 18.8515625f) + 0.8359375f) / ((_805 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w,
              (clamp(exp2(log2(abs(((_806 * 18.8515625f) + 0.8359375f) / ((_806 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w,
              (clamp(exp2(log2(abs(((_807 * 18.8515625f) + 0.8359375f) / ((_807 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w),
          0.0f);

      float _864 = exp2(log2(abs(_849.x)) * 0.0126833133399486541748046875f);
      float _865 = exp2(log2(abs(_849.y)) * 0.0126833133399486541748046875f);
      float _866 = exp2(log2(abs(_849.z)) * 0.0126833133399486541748046875f);
      frontier_phi_14_15_ladder = exp2(log2(abs((_866 + (-0.8359375f)) / (18.8515625f - (_866 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_14_15_ladder_1 = exp2(log2(abs((_865 + (-0.8359375f)) / (18.8515625f - (_865 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_14_15_ladder_2 = exp2(log2(abs((_864 + (-0.8359375f)) / (18.8515625f - (_864 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
    }
    _682 = frontier_phi_14_15_ladder_2;
    _685 = frontier_phi_14_15_ladder_1;
    _688 = frontier_phi_14_15_ladder;
  }
  float _695;
  float _697;
  float _699;
  if ((_439 & 2u) == 0u) {
    _695 = _682;
    _697 = _685;
    _699 = _688;
  } else {
#if 1
    ApplyUserGradingAndToneMapAndScale(
        _682, _685, _688,
        _40_m0[2u].y, _40_m0[2u].z,
        _40_m0[3u].z,
        _40_m0[4u].x, _40_m0[4u].y, _40_m0[4u].z,
        _695, _697, _699);
#else
    float _709 = (-0.0f) - _40_m0[4u].x;
    _695 = (_682 < _40_m0[3u].z) ? ((_682 * _40_m0[2u].y) + _40_m0[2u].z) : ((_709 / (_682 + _40_m0[4u].y)) + _40_m0[4u].z);
    _697 = (_685 < _40_m0[3u].z) ? ((_685 * _40_m0[2u].y) + _40_m0[2u].z) : ((_709 / (_685 + _40_m0[4u].y)) + _40_m0[4u].z);
    _699 = (_688 < _40_m0[3u].z) ? ((_688 * _40_m0[2u].y) + _40_m0[2u].z) : ((_709 / (_688 + _40_m0[4u].y)) + _40_m0[4u].z);
#endif
  }
  uint _701 = uint(int(_40_m0[18u].w));
  float _980;
  float _982;
  float _984;
  if (_701 == 1u) {
    float _903 = exp2(log2(abs(_695)) * _40_m0[18u].x);
    float _904 = exp2(log2(abs(_697)) * _40_m0[18u].x);
    float _905 = exp2(log2(abs(_699)) * _40_m0[18u].x);
    float _981;
    if (_903 < 0.00310000008903443813323974609375f) {
      _981 = _903 * 12.9200000762939453125f;
    } else {
      _981 = (exp2(log2(abs(_903)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _983;
    if (_904 < 0.00310000008903443813323974609375f) {
      _983 = _904 * 12.9200000762939453125f;
    } else {
      _983 = (exp2(log2(abs(_904)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_25_29_ladder;
    float frontier_phi_25_29_ladder_1;
    float frontier_phi_25_29_ladder_2;
    if (_905 < 0.00310000008903443813323974609375f) {
      frontier_phi_25_29_ladder = _981;
      frontier_phi_25_29_ladder_1 = _905 * 12.9200000762939453125f;
      frontier_phi_25_29_ladder_2 = _983;
    } else {
      frontier_phi_25_29_ladder = _981;
      frontier_phi_25_29_ladder_1 = (exp2(log2(abs(_905)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_25_29_ladder_2 = _983;
    }
    _980 = frontier_phi_25_29_ladder;
    _982 = frontier_phi_25_29_ladder_2;
    _984 = frontier_phi_25_29_ladder_1;
  } else {
    float frontier_phi_25_21_ladder;
    float frontier_phi_25_21_ladder_1;
    float frontier_phi_25_21_ladder_2;
    if (_701 == 2u) {
#if 1
      float pq_r, pq_g, pq_b;
      PQFromBT709(
          _695, _697, _699,   // BT709 in (r,g,b)
          _40_m0[18u].x,      // cbuffer_PQ_M1
          _40_m0[18u].y,      // cbuffer_diffuse_white
          pq_r, pq_g, pq_b);  // PQ out (r,g,b)

      frontier_phi_25_21_ladder = pq_r;
      frontier_phi_25_21_ladder_1 = pq_b;  // keep existing swapped local mapping
      frontier_phi_25_21_ladder_2 = pq_g;
#else
      float _950 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _699, mad(0.3292830288410186767578125f, _697, _695 * 0.627403914928436279296875f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      float _951 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _699, mad(0.9195404052734375f, _697, _695 * 0.069097287952899932861328125f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      float _952 = exp2(log2(abs(mad(0.895595252513885498046875f, _699, mad(0.08801330626010894775390625f, _697, _695 * 0.01639143936336040496826171875f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      frontier_phi_25_21_ladder = exp2(log2(abs(((_950 * 18.8515625f) + 0.8359375f) / ((_950 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_25_21_ladder_1 = exp2(log2(abs(((_952 * 18.8515625f) + 0.8359375f) / ((_952 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_25_21_ladder_2 = exp2(log2(abs(((_951 * 18.8515625f) + 0.8359375f) / ((_951 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_25_21_ladder = _695;
      frontier_phi_25_21_ladder_1 = _699;
      frontier_phi_25_21_ladder_2 = _697;
    }
    _980 = frontier_phi_25_21_ladder;
    _982 = frontier_phi_25_21_ladder_2;
    _984 = frontier_phi_25_21_ladder_1;
  }
  float _996 = max(((_980 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  float _997 = max(((_982 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  float _998 = max(((_984 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  SV_Target.x = _996;
  SV_Target.y = _997;
  SV_Target.z = _998;
  SV_Target.w = 1.0f;

  SV_Target_1 = dot(float3(_996, _997, _998), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
