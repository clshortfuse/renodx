#include "../tonemap.hlsli"

cbuffer _24_26 : register(b0, space6) {
  float4 _26_m0[21] : packoffset(c0);
};

// SamplerState _8[] : register(s0, space0);
Texture2D<float4> _12 : register(t0, space6);
Texture2D<float4> _13 : register(t1, space6);
Texture2D<float4> _14 : register(t2, space6);
Texture2D<float4> _15 : register(t3, space6);
Texture2D<float4> _16 : register(t4, space6);
Texture3D<float4> _19 : register(t5, space6);

static float4 gl_FragCoord;
static float2 TEXCOORD;
static float4 SV_Target;
static float4 SV_Target_1;

struct SPIRV_Cross_Input {
  noperspective float4 gl_FragCoord : SV_Position;
  linear float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
  float4 SV_Target_1 : SV_Target1;
};

void frag_main() {
  uint4 _146 = asuint(_26_m0[20u]);
  uint _147 = _146.x;
  uint _148 = _146.y;
  //   float4 _163 = _13.Sample(_8[6u], float2(TEXCOORD.x, TEXCOORD.y));
  float4 _163 = _13.Sample((SamplerState)ResourceDescriptorHeap[6u], float2(TEXCOORD.x, TEXCOORD.y));
  float _177 = (_26_m0[11u].z * ((TEXCOORD.x * 2.0f) + (-1.0f))) + _26_m0[11u].x;
  float _178 = (_26_m0[11u].w * ((TEXCOORD.y * 2.0f) + (-1.0f))) + _26_m0[11u].y;
  float _182 = (_177 * 0.5f) + 0.5f;
  float _183 = (_178 * 0.5f) + 0.5f;
  float _262;
  float _266;
  float _270;
  if ((_147 & 196608u) == 0u) {
    //     float4 _190 = _12.SampleLevel(_8[3u], float2(_182, _183), 0.0f);
    float4 _190 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[3u], float2(_182, _183), 0.0f);
    _262 = _190.x;
    _266 = _190.y;
    _270 = _190.z;
  } else {
    float _198 = TEXCOORD.x + (-0.5f);
    float _200 = TEXCOORD.y + (-0.5f);
    float _207 = (((_26_m0[3u].z * _198) + 0.5f) * 2.0f) + (-1.0f);
    float _208 = (((_26_m0[3u].z * _200) + 0.5f) * 2.0f) + (-1.0f);
    float _209 = _207 * _26_m0[5u].x;
    float _210 = _208 * _26_m0[5u].y;
    float _211 = dot(float2(_209, _210), float2(_209, _210));
    float _214 = _211 * _211;
    float _215 = _26_m0[3u].x * 2.0f;
    float _216 = _26_m0[3u].y * 4.0f;
    float _223 = _26_m0[3u].x * 3.0f;
    float _225 = _26_m0[3u].y * 5.0f;
    float _239 = (dot(1.0f.xx, float2(_215, _216)) + 1.0f) / (dot(1.0f.xx, float2(_223, _225)) + 1.0f);
    float _241 = (dot(float2(_211, _214), float2(_215, _216)) + 1.0f) / (_239 * (dot(float2(_211, _214), float2(_223, _225)) + 1.0f));
    bool _242 = _26_m0[3u].w != 0.0f;
    float _246 = log2(abs(_242 ? _207 : _208));
    float _253 = _26_m0[4u].x * 0.5f;
    float _257 = ((((1.0f - _241) * _253) * (exp2(_246 * _26_m0[4u].z) + exp2(_246 * _26_m0[4u].y))) + _241) * 0.5f;
    float _260 = (_257 * _207) + 0.5f;
    float _261 = (_257 * _208) + 0.5f;
    float frontier_phi_3_2_ladder;
    float frontier_phi_3_2_ladder_1;
    float frontier_phi_3_2_ladder_2;
    if (_148 == 3u) {
      float _277 = _26_m0[6u].x * _26_m0[3u].z;
      float _284 = (((_277 * _198) + 0.5f) * 2.0f) + (-1.0f);
      float _285 = (((_277 * _200) + 0.5f) * 2.0f) + (-1.0f);
      float _286 = _284 * _26_m0[5u].x;
      float _287 = _285 * _26_m0[5u].y;
      float _288 = dot(float2(_286, _287), float2(_286, _287));
      float _291 = _288 * _288;
      float _301 = (dot(float2(_288, _291), float2(_215, _216)) + 1.0f) / ((dot(float2(_288, _291), float2(_223, _225)) + 1.0f) * _239);
      float _304 = log2(abs(_242 ? _284 : _285));
      float _314 = ((((1.0f - _301) * _253) * (exp2(_304 * _26_m0[4u].z) + exp2(_304 * _26_m0[4u].y))) + _301) * 0.5f;
      float _317 = (_314 * _284) + 0.5f;
      float _318 = (_314 * _285) + 0.5f;
      float _319 = _26_m0[6u].y * _26_m0[3u].z;
      float _326 = (((_319 * _198) + 0.5f) * 2.0f) + (-1.0f);
      float _327 = (((_319 * _200) + 0.5f) * 2.0f) + (-1.0f);
      float _328 = _326 * _26_m0[5u].x;
      float _329 = _327 * _26_m0[5u].y;
      float _330 = dot(float2(_328, _329), float2(_328, _329));
      float _333 = _330 * _330;
      float _343 = (dot(float2(_330, _333), float2(_215, _216)) + 1.0f) / ((dot(float2(_330, _333), float2(_223, _225)) + 1.0f) * _239);
      float _346 = log2(abs(_242 ? _326 : _327));
      float _356 = ((((1.0f - _343) * _253) * (exp2(_346 * _26_m0[4u].z) + exp2(_346 * _26_m0[4u].y))) + _343) * 0.5f;
      float _359 = (_356 * _326) + 0.5f;
      float _360 = (_356 * _327) + 0.5f;
      //       float4 _379 = _12.SampleLevel(_8[17u], float2((_359 + _317) * 0.5f, (_360 + _318) * 0.5f), 0.0f);
      float4 _379 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_359 + _317) * 0.5f, (_360 + _318) * 0.5f), 0.0f);
      //       float4 _383 = _12.SampleLevel(_8[17u], float2((_317 + _260) * 0.5f, (_318 + _261) * 0.5f), 0.0f);
      float4 _383 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_317 + _260) * 0.5f, (_318 + _261) * 0.5f), 0.0f);
      //       frontier_phi_3_2_ladder = (_383.z + _12.SampleLevel(_8[17u], float2(_260, _261), 0.0f).z) * 0.5f;
      frontier_phi_3_2_ladder = (_383.z + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_260, _261), 0.0f).z) * 0.5f;
      //       frontier_phi_3_2_ladder_1 = (((_383.y + _379.y) * 0.5f) + _12.SampleLevel(_8[17u], float2(_359, _360), 0.0f).y) * 0.5f;
      frontier_phi_3_2_ladder_1 = (((_383.y + _379.y) * 0.5f) + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_359, _360), 0.0f).y) * 0.5f;
      //       frontier_phi_3_2_ladder_2 = (_379.x + _12.SampleLevel(_8[17u], float2(_317, _318), 0.0f).x) * 0.5f;
      frontier_phi_3_2_ladder_2 = (_379.x + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_317, _318), 0.0f).x) * 0.5f;
    } else {
      float frontier_phi_3_2_ladder_5_ladder;
      float frontier_phi_3_2_ladder_5_ladder_1;
      float frontier_phi_3_2_ladder_5_ladder_2;
      if ((_148 & 1u) == 0u) {
        //         float4 _420 = _12.SampleLevel(_8[17u], float2(_260, _261), 0.0f);
        float4 _420 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_260, _261), 0.0f);
        frontier_phi_3_2_ladder_5_ladder = _420.z;
        frontier_phi_3_2_ladder_5_ladder_1 = _420.y;
        frontier_phi_3_2_ladder_5_ladder_2 = _420.x;
      } else {
        float _422 = _26_m0[6u].x * _26_m0[3u].z;
        float _429 = (((_422 * _198) + 0.5f) * 2.0f) + (-1.0f);
        float _430 = (((_422 * _200) + 0.5f) * 2.0f) + (-1.0f);
        float _431 = _429 * _26_m0[5u].x;
        float _432 = _430 * _26_m0[5u].y;
        float _433 = dot(float2(_431, _432), float2(_431, _432));
        float _436 = _433 * _433;
        float _446 = (dot(float2(_433, _436), float2(_215, _216)) + 1.0f) / ((dot(float2(_433, _436), float2(_223, _225)) + 1.0f) * _239);
        float _449 = log2(abs(_242 ? _429 : _430));
        float _459 = ((((1.0f - _446) * _253) * (exp2(_449 * _26_m0[4u].z) + exp2(_449 * _26_m0[4u].y))) + _446) * 0.5f;
        float _464 = _26_m0[6u].y * _26_m0[3u].z;
        float _471 = (((_464 * _198) + 0.5f) * 2.0f) + (-1.0f);
        float _472 = (((_464 * _200) + 0.5f) * 2.0f) + (-1.0f);
        float _473 = _471 * _26_m0[5u].x;
        float _474 = _472 * _26_m0[5u].y;
        float _475 = dot(float2(_473, _474), float2(_473, _474));
        float _478 = _475 * _475;
        float _488 = (dot(float2(_475, _478), float2(_215, _216)) + 1.0f) / ((dot(float2(_475, _478), float2(_223, _225)) + 1.0f) * _239);
        float _491 = log2(abs(_242 ? _471 : _472));
        float _501 = ((((1.0f - _488) * _253) * (exp2(_491 * _26_m0[4u].z) + exp2(_491 * _26_m0[4u].y))) + _488) * 0.5f;
        //         frontier_phi_3_2_ladder_5_ladder = _12.SampleLevel(_8[17u], float2(_260, _261), 0.0f).z;
        frontier_phi_3_2_ladder_5_ladder = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_260, _261), 0.0f).z;
        //         frontier_phi_3_2_ladder_5_ladder_1 = _12.SampleLevel(_8[17u], float2((_501 * _471) + 0.5f, (_501 * _472) + 0.5f), 0.0f).y;
        frontier_phi_3_2_ladder_5_ladder_1 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_501 * _471) + 0.5f, (_501 * _472) + 0.5f), 0.0f).y;
        //         frontier_phi_3_2_ladder_5_ladder_2 = _12.SampleLevel(_8[17u], float2((_459 * _429) + 0.5f, (_459 * _430) + 0.5f), 0.0f).x;
        frontier_phi_3_2_ladder_5_ladder_2 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_459 * _429) + 0.5f, (_459 * _430) + 0.5f), 0.0f).x;
      }
      frontier_phi_3_2_ladder = frontier_phi_3_2_ladder_5_ladder;
      frontier_phi_3_2_ladder_1 = frontier_phi_3_2_ladder_5_ladder_1;
      frontier_phi_3_2_ladder_2 = frontier_phi_3_2_ladder_5_ladder_2;
    }
    _262 = frontier_phi_3_2_ladder_2;
    _266 = frontier_phi_3_2_ladder_1;
    _270 = frontier_phi_3_2_ladder;
  }
  float _394;
  float _396;
  float _398;
  if ((_147 & 64u) == 0u) {
    _394 = _262;
    _396 = _266;
    _398 = _270;
  } else {
    float _409 = clamp((sqrt((_177 * _177) + (_178 * _178)) * _26_m0[18u].z) + _26_m0[18u].w, 0.0f, 1.0f);
    float _411 = (_409 * _409) * _26_m0[13u].w;
    float _412 = 1.0f - _411;
    _394 = (_412 * _262) + (_411 * _26_m0[13u].x);
    _396 = (_412 * _266) + (_411 * _26_m0[13u].y);
    _398 = (_412 * _270) + (_411 * _26_m0[13u].z);
  }
  float _513;
  float _516;
  float _519;
  float _522;
  float _525;
  float _528;
  if ((_147 & 2048u) == 0u) {
    _513 = _394;
    _516 = _396;
    _519 = _398;
    _522 = _262;
    _525 = _266;
    _528 = _270;
  } else {
    float frontier_phi_10_11_ladder;
    float frontier_phi_10_11_ladder_1;
    float frontier_phi_10_11_ladder_2;
    float frontier_phi_10_11_ladder_3;
    float frontier_phi_10_11_ladder_4;
    float frontier_phi_10_11_ladder_5;
    if (asuint(_26_m0[19u]).w == 0u) {
#if 1
      ApplyTonemapGamma2LUTAndInverseTonemapDualOutputs(
          (SamplerState)ResourceDescriptorHeap[17u],
          _19,
          _262, _266, _270,
          _394, _396, _398,
          _26_m0[14u].x, _26_m0[14u].y, _26_m0[14u].z, _26_m0[14u].w,
          _26_m0[15u].x, _26_m0[15u].y, _26_m0[15u].z, _26_m0[15u].w,
          _26_m0[18u].x, _26_m0[18u].y,
          frontier_phi_10_11_ladder,
          frontier_phi_10_11_ladder_1,
          frontier_phi_10_11_ladder_2,
          frontier_phi_10_11_ladder_3,
          frontier_phi_10_11_ladder_4,
          frontier_phi_10_11_ladder_5);
#else
      float _594 = (-0.0f) - _26_m0[14u].w;
      //       float4 _654 = _19.SampleLevel(_8[17u], float3((clamp(sqrt(max((_262 < _26_m0[15u].z) ? ((_262 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_262 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_266 < _26_m0[15u].z) ? ((_266 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_266 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_270 < _26_m0[15u].z) ? ((_270 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_270 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float4 _654 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(sqrt(max((_262 < _26_m0[15u].z) ? ((_262 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_262 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_266 < _26_m0[15u].z) ? ((_266 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_266 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_270 < _26_m0[15u].z) ? ((_270 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_270 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float _657 = _654.x;
      float _658 = _654.y;
      float _659 = _654.z;
      //       float4 _669 = _19.SampleLevel(_8[17u], float3((clamp(sqrt(max((_394 < _26_m0[15u].z) ? ((_394 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_394 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_396 < _26_m0[15u].z) ? ((_396 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_396 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_398 < _26_m0[15u].z) ? ((_398 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_398 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float4 _669 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(sqrt(max((_394 < _26_m0[15u].z) ? ((_394 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_394 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_396 < _26_m0[15u].z) ? ((_396 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_396 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_398 < _26_m0[15u].z) ? ((_398 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_398 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float _671 = _669.x;
      float _672 = _669.y;
      float _673 = _669.z;
      float _680 = min(_657 * _657, _26_m0[14u].x);
      float _681 = min(_658 * _658, _26_m0[14u].x);
      float _682 = min(_659 * _659, _26_m0[14u].x);
      float _701 = min(_671 * _671, _26_m0[14u].x);
      float _702 = min(_672 * _672, _26_m0[14u].x);
      float _703 = min(_673 * _673, _26_m0[14u].x);
      frontier_phi_10_11_ladder = (_682 < _26_m0[15u].w) ? ((_682 - _26_m0[14u].z) / _26_m0[14u].y) : ((_594 / (_682 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_1 = (_681 < _26_m0[15u].w) ? ((_681 - _26_m0[14u].z) / _26_m0[14u].y) : ((_594 / (_681 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_2 = (_680 < _26_m0[15u].w) ? ((_680 - _26_m0[14u].z) / _26_m0[14u].y) : ((_594 / (_680 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_3 = (_703 < _26_m0[15u].w) ? ((_703 - _26_m0[14u].z) / _26_m0[14u].y) : ((_594 / (_703 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_4 = (_702 < _26_m0[15u].w) ? ((_702 - _26_m0[14u].z) / _26_m0[14u].y) : ((_594 / (_702 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_5 = (_701 < _26_m0[15u].w) ? ((_701 - _26_m0[14u].z) / _26_m0[14u].y) : ((_594 / (_701 - _26_m0[15u].y)) - _26_m0[15u].x);
#endif
    } else {
      float _736 = exp2(log2(abs(_262 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _737 = exp2(log2(abs(_266 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _738 = exp2(log2(abs(_270 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      //       float4 _780 = _19.SampleLevel(_8[17u], float3((clamp(exp2(log2(abs(((_736 * 18.8515625f) + 0.8359375f) / ((_736 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_737 * 18.8515625f) + 0.8359375f) / ((_737 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_738 * 18.8515625f) + 0.8359375f) / ((_738 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float4 _780 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(exp2(log2(abs(((_736 * 18.8515625f) + 0.8359375f) / ((_736 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_737 * 18.8515625f) + 0.8359375f) / ((_737 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_738 * 18.8515625f) + 0.8359375f) / ((_738 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float _795 = exp2(log2(abs(_780.x)) * 0.0126833133399486541748046875f);
      float _796 = exp2(log2(abs(_780.y)) * 0.0126833133399486541748046875f);
      float _797 = exp2(log2(abs(_780.z)) * 0.0126833133399486541748046875f);
      float _837 = exp2(log2(abs(_394 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _838 = exp2(log2(abs(_396 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _839 = exp2(log2(abs(_398 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      //       float4 _876 = _19.SampleLevel(_8[17u], float3((clamp(exp2(log2(abs(((_837 * 18.8515625f) + 0.8359375f) / ((_837 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_838 * 18.8515625f) + 0.8359375f) / ((_838 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_839 * 18.8515625f) + 0.8359375f) / ((_839 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float4 _876 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(exp2(log2(abs(((_837 * 18.8515625f) + 0.8359375f) / ((_837 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_838 * 18.8515625f) + 0.8359375f) / ((_838 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_839 * 18.8515625f) + 0.8359375f) / ((_839 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float _890 = exp2(log2(abs(_876.x)) * 0.0126833133399486541748046875f);
      float _891 = exp2(log2(abs(_876.y)) * 0.0126833133399486541748046875f);
      float _892 = exp2(log2(abs(_876.z)) * 0.0126833133399486541748046875f);
      frontier_phi_10_11_ladder = exp2(log2(abs((_797 + (-0.8359375f)) / (18.8515625f - (_797 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_1 = exp2(log2(abs((_796 + (-0.8359375f)) / (18.8515625f - (_796 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_2 = exp2(log2(abs((_795 + (-0.8359375f)) / (18.8515625f - (_795 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_3 = exp2(log2(abs((_892 + (-0.8359375f)) / (18.8515625f - (_892 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_4 = exp2(log2(abs((_891 + (-0.8359375f)) / (18.8515625f - (_891 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_5 = exp2(log2(abs((_890 + (-0.8359375f)) / (18.8515625f - (_890 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
    }
    _513 = frontier_phi_10_11_ladder_5;
    _516 = frontier_phi_10_11_ladder_4;
    _519 = frontier_phi_10_11_ladder_3;
    _522 = frontier_phi_10_11_ladder_2;
    _525 = frontier_phi_10_11_ladder_1;
    _528 = frontier_phi_10_11_ladder;
  }
  float _536;
  float _538;
  float _540;
  float _542;
  float _544;
  float _546;
  if ((_147 & 8192u) == 0u) {
    _536 = _513;
    _538 = _516;
    _540 = _519;
    _542 = _522;
    _544 = _525;
    _546 = _528;
  } else {
#if 1
    ApplyUserGradingAndToneMapAndScaleDual(
        _513, _516, _519,
        _522, _525, _528,
        _26_m0[14u].y, _26_m0[14u].z,
        _26_m0[15u].z,
        _26_m0[16u].x, _26_m0[16u].y, _26_m0[16u].z,
        _536, _538, _540,
        _542, _544, _546);
#else
    float _556 = (-0.0f) - _26_m0[16u].x;
    _536 = (_513 < _26_m0[15u].z) ? ((_513 * _26_m0[14u].y) + _26_m0[14u].z) : ((_556 / (_513 + _26_m0[16u].y)) + _26_m0[16u].z);
    _538 = (_516 < _26_m0[15u].z) ? ((_516 * _26_m0[14u].y) + _26_m0[14u].z) : ((_556 / (_516 + _26_m0[16u].y)) + _26_m0[16u].z);
    _540 = (_519 < _26_m0[15u].z) ? ((_519 * _26_m0[14u].y) + _26_m0[14u].z) : ((_556 / (_519 + _26_m0[16u].y)) + _26_m0[16u].z);
    _542 = (_522 < _26_m0[15u].z) ? ((_522 * _26_m0[14u].y) + _26_m0[14u].z) : ((_556 / (_522 + _26_m0[16u].y)) + _26_m0[16u].z);
    _544 = (_525 < _26_m0[15u].z) ? ((_525 * _26_m0[14u].y) + _26_m0[14u].z) : ((_556 / (_525 + _26_m0[16u].y)) + _26_m0[16u].z);
    _546 = (_528 < _26_m0[15u].z) ? ((_528 * _26_m0[14u].y) + _26_m0[14u].z) : ((_556 / (_528 + _26_m0[16u].y)) + _26_m0[16u].z);
#endif
  }
  float _917;
  float _919;
  float _921;
  if ((_147 & 8u) == 0u) {
    _917 = _536;
    _919 = _538;
    _921 = _540;
  } else {
    float _934 = (_182 * _26_m0[1u].x) + _26_m0[1u].z;
    float _935 = (_183 * _26_m0[1u].y) + _26_m0[1u].w;
    float _939 = max(min(_934, _26_m0[2u].x), min(max(_934, _26_m0[2u].x), _26_m0[2u].z));
    float _943 = max(min(_935, _26_m0[2u].y), min(max(_935, _26_m0[2u].y), _26_m0[2u].w));
    uint _959 = asuint(_26_m0[0u].z);
    //     float _978 = (_14.SampleLevel(_8[17u], float2((float(_959 & 65535u) * 1.52587890625e-05f) + (_26_m0[0u].x * TEXCOORD.x), (float(_959 >> 16u) * 1.52587890625e-05f) + (_26_m0[0u].y * TEXCOORD.y)), 0.0f).y + (-0.5f)) * (((((_939 - _26_m0[2u].x) * (_939 - _26_m0[2u].z)) == 0.0f) || (((_943 - _26_m0[2u].y) * (_943 - _26_m0[2u].w)) == 0.0f)) ? 0.0f : _15.SampleLevel(_8[3u], float2(_939, _943), 0.0f).w);
    float _978 = (_14.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((float(_959 & 65535u) * 1.52587890625e-05f) + (_26_m0[0u].x * TEXCOORD.x), (float(_959 >> 16u) * 1.52587890625e-05f) + (_26_m0[0u].y * TEXCOORD.y)), 0.0f).y + (-0.5f)) * (((((_939 - _26_m0[2u].x) * (_939 - _26_m0[2u].z)) == 0.0f) || (((_943 - _26_m0[2u].y) * (_943 - _26_m0[2u].w)) == 0.0f)) ? 0.0f : _15.SampleLevel((SamplerState)ResourceDescriptorHeap[3u], float2(_939, _943), 0.0f).w);
#if 1
    _917 = _978 + _536;
    _919 = _978 + _538;
    _921 = _978 + _540;
#else
    _917 = max(_978 + _536, 0.0f);
    _919 = max(_978 + _538, 0.0f);
    _921 = max(_978 + _540, 0.0f);
#endif
  }
  float _923 = 1.0f - _163.w;
  float _927 = (_917 * _923) + _163.x;
  float _928 = (_919 * _923) + _163.y;
  float _929 = (_921 * _923) + _163.z;
  uint _930 = uint(int(_26_m0[8u].w));
  bool _931 = _930 == 1u;
  float _1068;
  float _1070;
  float _1072;
  if (_931) {
    float _991 = exp2(log2(abs(_927)) * _26_m0[8u].x);
    float _992 = exp2(log2(abs(_928)) * _26_m0[8u].x);
    float _993 = exp2(log2(abs(_929)) * _26_m0[8u].x);
    float _1069;
    if (_991 < 0.00310000008903443813323974609375f) {
      _1069 = _991 * 12.9200000762939453125f;
    } else {
      _1069 = (exp2(log2(abs(_991)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _1071;
    if (_992 < 0.00310000008903443813323974609375f) {
      _1071 = _992 * 12.9200000762939453125f;
    } else {
      _1071 = (exp2(log2(abs(_992)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_23_33_ladder;
    float frontier_phi_23_33_ladder_1;
    float frontier_phi_23_33_ladder_2;
    if (_993 < 0.00310000008903443813323974609375f) {
      frontier_phi_23_33_ladder = _993 * 12.9200000762939453125f;
      frontier_phi_23_33_ladder_1 = _1071;
      frontier_phi_23_33_ladder_2 = _1069;
    } else {
      frontier_phi_23_33_ladder = (exp2(log2(abs(_993)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_23_33_ladder_1 = _1071;
      frontier_phi_23_33_ladder_2 = _1069;
    }
    _1068 = frontier_phi_23_33_ladder_2;
    _1070 = frontier_phi_23_33_ladder_1;
    _1072 = frontier_phi_23_33_ladder;
  } else {
    float frontier_phi_23_19_ladder;
    float frontier_phi_23_19_ladder_1;
    float frontier_phi_23_19_ladder_2;
    if (_930 == 2u) {
#if 1
      float pq_r;
      float pq_g;
      float pq_b;
      PQFromBT709FinalWithGammaCorrection(
          _927, _928, _929,
          _26_m0[8u].x, _26_m0[8u].y,
          pq_r, pq_g, pq_b);
      frontier_phi_23_19_ladder = pq_b;
      frontier_phi_23_19_ladder_1 = pq_g;
      frontier_phi_23_19_ladder_2 = pq_r;
#else
      float _1038 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _929, mad(0.3292830288410186767578125f, _928, _927 * 0.627403914928436279296875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _1039 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _929, mad(0.9195404052734375f, _928, _927 * 0.069097287952899932861328125f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _1040 = exp2(log2(abs(mad(0.895595252513885498046875f, _929, mad(0.08801330626010894775390625f, _928, _927 * 0.01639143936336040496826171875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      frontier_phi_23_19_ladder = exp2(log2(abs(((_1040 * 18.8515625f) + 0.8359375f) / ((_1040 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_23_19_ladder_1 = exp2(log2(abs(((_1039 * 18.8515625f) + 0.8359375f) / ((_1039 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_23_19_ladder_2 = exp2(log2(abs(((_1038 * 18.8515625f) + 0.8359375f) / ((_1038 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_23_19_ladder = _929;
      frontier_phi_23_19_ladder_1 = _928;
      frontier_phi_23_19_ladder_2 = _927;
    }
    _1068 = frontier_phi_23_19_ladder_2;
    _1070 = frontier_phi_23_19_ladder_1;
    _1072 = frontier_phi_23_19_ladder;
  }
  float _1084 = (_16.Load(int3(uint2(uint(int(gl_FragCoord.x)) & 31u, uint(int(gl_FragCoord.y)) & 31u), 0u)).x + (-0.5f)) * _26_m0[10u].x;
  float _1168;
  float _1170;
  float _1172;
  if (_931) {
    float _1098 = exp2(log2(abs(_542)) * _26_m0[8u].x);
    float _1099 = exp2(log2(abs(_544)) * _26_m0[8u].x);
    float _1100 = exp2(log2(abs(_546)) * _26_m0[8u].x);
    float _1169;
    if (_1098 < 0.00310000008903443813323974609375f) {
      _1169 = _1098 * 12.9200000762939453125f;
    } else {
      _1169 = (exp2(log2(abs(_1098)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _1171;
    if (_1099 < 0.00310000008903443813323974609375f) {
      _1171 = _1099 * 12.9200000762939453125f;
    } else {
      _1171 = (exp2(log2(abs(_1099)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_32_39_ladder;
    float frontier_phi_32_39_ladder_1;
    float frontier_phi_32_39_ladder_2;
    if (_1100 < 0.00310000008903443813323974609375f) {
      frontier_phi_32_39_ladder = _1169;
      frontier_phi_32_39_ladder_1 = _1100 * 12.9200000762939453125f;
      frontier_phi_32_39_ladder_2 = _1171;
    } else {
      frontier_phi_32_39_ladder = _1169;
      frontier_phi_32_39_ladder_1 = (exp2(log2(abs(_1100)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_32_39_ladder_2 = _1171;
    }
    _1168 = frontier_phi_32_39_ladder;
    _1170 = frontier_phi_32_39_ladder_2;
    _1172 = frontier_phi_32_39_ladder_1;
  } else {
    float frontier_phi_32_26_ladder;
    float frontier_phi_32_26_ladder_1;
    float frontier_phi_32_26_ladder_2;
    if (_930 == 2u) {
#if 1
      float pq_r;
      float pq_g;
      float pq_b;
      PQFromBT709(
          _542, _544, _546,
          _26_m0[8u].x, _26_m0[8u].y,
          pq_r, pq_g, pq_b);
      frontier_phi_32_26_ladder = pq_r;
      frontier_phi_32_26_ladder_1 = pq_b;
      frontier_phi_32_26_ladder_2 = pq_g;
#else
      float _1138 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _546, mad(0.3292830288410186767578125f, _544, _542 * 0.627403914928436279296875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _1139 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _546, mad(0.9195404052734375f, _544, _542 * 0.069097287952899932861328125f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _1140 = exp2(log2(abs(mad(0.895595252513885498046875f, _546, mad(0.08801330626010894775390625f, _544, _542 * 0.01639143936336040496826171875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      frontier_phi_32_26_ladder = exp2(log2(abs(((_1138 * 18.8515625f) + 0.8359375f) / ((_1138 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_32_26_ladder_1 = exp2(log2(abs(((_1140 * 18.8515625f) + 0.8359375f) / ((_1140 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_32_26_ladder_2 = exp2(log2(abs(((_1139 * 18.8515625f) + 0.8359375f) / ((_1139 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_32_26_ladder = _542;
      frontier_phi_32_26_ladder_1 = _546;
      frontier_phi_32_26_ladder_2 = _544;
    }
    _1168 = frontier_phi_32_26_ladder;
    _1170 = frontier_phi_32_26_ladder_2;
    _1172 = frontier_phi_32_26_ladder_1;
  }
  SV_Target_1.x = _1168 + _1084;
  SV_Target_1.y = _1170 + _1084;
  SV_Target_1.z = _1172 + _1084;
  SV_Target_1.w = 1.0f;
  SV_Target.x = _1084 + _1068;
  SV_Target.y = _1084 + _1070;
  SV_Target.z = _1084 + _1072;
  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
