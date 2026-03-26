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
  // float4 _163 = _13.Sample(_8[6u], float2(TEXCOORD.x, TEXCOORD.y));
  float4 _163 = _13.Sample((SamplerState)ResourceDescriptorHeap[6u], float2(TEXCOORD.x, TEXCOORD.y));
  float _177 = (_26_m0[11u].z * ((TEXCOORD.x * 2.0f) + (-1.0f))) + _26_m0[11u].x;
  float _178 = (_26_m0[11u].w * ((TEXCOORD.y * 2.0f) + (-1.0f))) + _26_m0[11u].y;
  float _182 = (_177 * 0.5f) + 0.5f;
  float _183 = (_178 * 0.5f) + 0.5f;
  float _262;
  float _266;
  float _270;
  if ((_147 & 196608u) == 0u) {
    // float4 _190 = _12.SampleLevel(_8[3u], float2(_182, _183), 0.0f);
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
      // float4 _379 = _12.SampleLevel(_8[17u], float2((_359 + _317) * 0.5f, (_360 + _318) * 0.5f), 0.0f);
      float4 _379 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_359 + _317) * 0.5f, (_360 + _318) * 0.5f), 0.0f);
      // float4 _383 = _12.SampleLevel(_8[17u], float2((_317 + _260) * 0.5f, (_318 + _261) * 0.5f), 0.0f);
      float4 _383 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_317 + _260) * 0.5f, (_318 + _261) * 0.5f), 0.0f);
      // frontier_phi_3_2_ladder = (_383.z + _12.SampleLevel(_8[17u], float2(_260, _261), 0.0f).z) * 0.5f;
      frontier_phi_3_2_ladder = (_383.z + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_260, _261), 0.0f).z) * 0.5f;
      // frontier_phi_3_2_ladder_1 = (((_383.y + _379.y) * 0.5f) + _12.SampleLevel(_8[17u], float2(_359, _360), 0.0f).y) * 0.5f;
      frontier_phi_3_2_ladder_1 = (((_383.y + _379.y) * 0.5f) + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_359, _360), 0.0f).y) * 0.5f;
      // frontier_phi_3_2_ladder_2 = (_379.x + _12.SampleLevel(_8[17u], float2(_317, _318), 0.0f).x) * 0.5f;
      frontier_phi_3_2_ladder_2 = (_379.x + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_317, _318), 0.0f).x) * 0.5f;
    } else {
      float frontier_phi_3_2_ladder_5_ladder;
      float frontier_phi_3_2_ladder_5_ladder_1;
      float frontier_phi_3_2_ladder_5_ladder_2;
      if ((_148 & 1u) == 0u) {
        // float4 _420 = _12.SampleLevel(_8[17u], float2(_260, _261), 0.0f);
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
        // frontier_phi_3_2_ladder_5_ladder = _12.SampleLevel(_8[17u], float2(_260, _261), 0.0f).z;
        frontier_phi_3_2_ladder_5_ladder = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_260, _261), 0.0f).z;
        // frontier_phi_3_2_ladder_5_ladder_1 = _12.SampleLevel(_8[17u], float2((_501 * _471) + 0.5f, (_501 * _472) + 0.5f), 0.0f).y;
        frontier_phi_3_2_ladder_5_ladder_1 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_501 * _471) + 0.5f, (_501 * _472) + 0.5f), 0.0f).y;
        // frontier_phi_3_2_ladder_5_ladder_2 = _12.SampleLevel(_8[17u], float2((_459 * _429) + 0.5f, (_459 * _430) + 0.5f), 0.0f).x;
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
      ApplyTonemapGamma2LUTAndInverseTonemapDualOutputsOld(
          (SamplerState)ResourceDescriptorHeap[17u],
          _19,
          _262, _266, _270,
          _394, _396, _398,
          _26_m0[14u].w,
          _26_m0[14u].x, _26_m0[14u].y, _26_m0[14u].z,
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
      float _634 = sqrt(max((_262 < _26_m0[15u].z) ? ((_262 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_262 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f));
      float _635 = sqrt(max((_266 < _26_m0[15u].z) ? ((_266 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_266 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f));
      float _636 = sqrt(max((_270 < _26_m0[15u].z) ? ((_270 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_270 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f));
      // float4 _654 = _19.SampleLevel(_8[17u], float3((clamp(sqrt(max((_394 < _26_m0[15u].z) ? ((_394 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_394 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_396 < _26_m0[15u].z) ? ((_396 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_396 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_398 < _26_m0[15u].z) ? ((_398 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_398 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float4 _654 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(sqrt(max((_394 < _26_m0[15u].z) ? ((_394 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_394 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_396 < _26_m0[15u].z) ? ((_396 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_396 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_398 < _26_m0[15u].z) ? ((_398 * _26_m0[14u].y) + _26_m0[14u].z) : ((_594 / (_398 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float _657 = _654.x;
      float _658 = _654.y;
      float _659 = _654.z;
      float _666 = min(_634 * _634, _26_m0[14u].x);
      float _667 = min(_635 * _635, _26_m0[14u].x);
      float _668 = min(_636 * _636, _26_m0[14u].x);
      float _687 = min(_657 * _657, _26_m0[14u].x);
      float _688 = min(_658 * _658, _26_m0[14u].x);
      float _689 = min(_659 * _659, _26_m0[14u].x);
      frontier_phi_10_11_ladder = (_668 < _26_m0[15u].w) ? ((_668 - _26_m0[14u].z) / _26_m0[14u].y) : ((_594 / (_668 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_1 = (_667 < _26_m0[15u].w) ? ((_667 - _26_m0[14u].z) / _26_m0[14u].y) : ((_594 / (_667 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_2 = (_666 < _26_m0[15u].w) ? ((_666 - _26_m0[14u].z) / _26_m0[14u].y) : ((_594 / (_666 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_3 = (_689 < _26_m0[15u].w) ? ((_689 - _26_m0[14u].z) / _26_m0[14u].y) : ((_594 / (_689 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_4 = (_688 < _26_m0[15u].w) ? ((_688 - _26_m0[14u].z) / _26_m0[14u].y) : ((_594 / (_688 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_5 = (_687 < _26_m0[15u].w) ? ((_687 - _26_m0[14u].z) / _26_m0[14u].y) : ((_594 / (_687 - _26_m0[15u].y)) - _26_m0[15u].x);
#endif
    } else {
      float _722 = exp2(log2(abs(_262 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _723 = exp2(log2(abs(_266 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _724 = exp2(log2(abs(_270 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      // float4 _766 = _19.SampleLevel(_8[17u], float3((clamp(exp2(log2(abs(((_722 * 18.8515625f) + 0.8359375f) / ((_722 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_723 * 18.8515625f) + 0.8359375f) / ((_723 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_724 * 18.8515625f) + 0.8359375f) / ((_724 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float4 _766 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(exp2(log2(abs(((_722 * 18.8515625f) + 0.8359375f) / ((_722 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_723 * 18.8515625f) + 0.8359375f) / ((_723 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_724 * 18.8515625f) + 0.8359375f) / ((_724 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float _781 = exp2(log2(abs(_766.x)) * 0.0126833133399486541748046875f);
      float _782 = exp2(log2(abs(_766.y)) * 0.0126833133399486541748046875f);
      float _783 = exp2(log2(abs(_766.z)) * 0.0126833133399486541748046875f);
      float _823 = exp2(log2(abs(_394 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _824 = exp2(log2(abs(_396 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _825 = exp2(log2(abs(_398 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      // float4 _862 = _19.SampleLevel(_8[17u], float3((clamp(exp2(log2(abs(((_823 * 18.8515625f) + 0.8359375f) / ((_823 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_824 * 18.8515625f) + 0.8359375f) / ((_824 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_825 * 18.8515625f) + 0.8359375f) / ((_825 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float4 _862 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(exp2(log2(abs(((_823 * 18.8515625f) + 0.8359375f) / ((_823 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_824 * 18.8515625f) + 0.8359375f) / ((_824 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_825 * 18.8515625f) + 0.8359375f) / ((_825 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float _876 = exp2(log2(abs(_862.x)) * 0.0126833133399486541748046875f);
      float _877 = exp2(log2(abs(_862.y)) * 0.0126833133399486541748046875f);
      float _878 = exp2(log2(abs(_862.z)) * 0.0126833133399486541748046875f);
      frontier_phi_10_11_ladder = exp2(log2(abs((_783 + (-0.8359375f)) / (18.8515625f - (_783 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_1 = exp2(log2(abs((_782 + (-0.8359375f)) / (18.8515625f - (_782 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_2 = exp2(log2(abs((_781 + (-0.8359375f)) / (18.8515625f - (_781 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_3 = exp2(log2(abs((_878 + (-0.8359375f)) / (18.8515625f - (_878 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_4 = exp2(log2(abs((_877 + (-0.8359375f)) / (18.8515625f - (_877 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_5 = exp2(log2(abs((_876 + (-0.8359375f)) / (18.8515625f - (_876 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
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
  float _903;
  float _905;
  float _907;
  if ((_147 & 8u) == 0u) {
    _903 = _536;
    _905 = _538;
    _907 = _540;
  } else {
    float _920 = (_182 * _26_m0[1u].x) + _26_m0[1u].z;
    float _921 = (_183 * _26_m0[1u].y) + _26_m0[1u].w;
    float _925 = max(min(_920, _26_m0[2u].x), min(max(_920, _26_m0[2u].x), _26_m0[2u].z));
    float _929 = max(min(_921, _26_m0[2u].y), min(max(_921, _26_m0[2u].y), _26_m0[2u].w));
    uint _945 = asuint(_26_m0[0u].z);
    // float _964 = (_14.SampleLevel(_8[17u], float2((float(_945 & 65535u) * 1.52587890625e-05f) + (_26_m0[0u].x * TEXCOORD.x), (float(_945 >> 16u) * 1.52587890625e-05f) + (_26_m0[0u].y * TEXCOORD.y)), 0.0f).y + (-0.5f)) * (((((_925 - _26_m0[2u].x) * (_925 - _26_m0[2u].z)) == 0.0f) || (((_929 - _26_m0[2u].y) * (_929 - _26_m0[2u].w)) == 0.0f)) ? 0.0f : _15.SampleLevel(_8[3u], float2(_925, _929), 0.0f).w);
    float _964 = (_14.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((float(_945 & 65535u) * 1.52587890625e-05f) + (_26_m0[0u].x * TEXCOORD.x), (float(_945 >> 16u) * 1.52587890625e-05f) + (_26_m0[0u].y * TEXCOORD.y)), 0.0f).y + (-0.5f)) * (((((_925 - _26_m0[2u].x) * (_925 - _26_m0[2u].z)) == 0.0f) || (((_929 - _26_m0[2u].y) * (_929 - _26_m0[2u].w)) == 0.0f)) ? 0.0f : _15.SampleLevel((SamplerState)ResourceDescriptorHeap[3u], float2(_925, _929), 0.0f).w);
#if 1
    _903 = (_964 + _536);
    _905 = (_964 + _538);
    _907 = (_964 + _540);
#else
    _903 = max(_964 + _536, 0.0f);
    _905 = max(_964 + _538, 0.0f);
    _907 = max(_964 + _540, 0.0f);
#endif
  }
  float _909 = 1.0f - _163.w;
  float _913 = (_903 * _909) + _163.x;
  float _914 = (_905 * _909) + _163.y;
  float _915 = (_907 * _909) + _163.z;
  uint _916 = uint(int(_26_m0[8u].w));
  bool _917 = _916 == 1u;
  float _1054;
  float _1056;
  float _1058;
  if (_917) {
    float _977 = exp2(log2(abs(_913)) * _26_m0[8u].x);
    float _978 = exp2(log2(abs(_914)) * _26_m0[8u].x);
    float _979 = exp2(log2(abs(_915)) * _26_m0[8u].x);
    float _1055;
    if (_977 < 0.00310000008903443813323974609375f) {
      _1055 = _977 * 12.9200000762939453125f;
    } else {
      _1055 = (exp2(log2(abs(_977)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _1057;
    if (_978 < 0.00310000008903443813323974609375f) {
      _1057 = _978 * 12.9200000762939453125f;
    } else {
      _1057 = (exp2(log2(abs(_978)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_23_33_ladder;
    float frontier_phi_23_33_ladder_1;
    float frontier_phi_23_33_ladder_2;
    if (_979 < 0.00310000008903443813323974609375f) {
      frontier_phi_23_33_ladder = _979 * 12.9200000762939453125f;
      frontier_phi_23_33_ladder_1 = _1057;
      frontier_phi_23_33_ladder_2 = _1055;
    } else {
      frontier_phi_23_33_ladder = (exp2(log2(abs(_979)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_23_33_ladder_1 = _1057;
      frontier_phi_23_33_ladder_2 = _1055;
    }
    _1054 = frontier_phi_23_33_ladder_2;
    _1056 = frontier_phi_23_33_ladder_1;
    _1058 = frontier_phi_23_33_ladder;
  } else {
    float frontier_phi_23_19_ladder;
    float frontier_phi_23_19_ladder_1;
    float frontier_phi_23_19_ladder_2;
    if (_916 == 2u) {
#if 1
      float pq_r;
      float pq_g;
      float pq_b;
      PQFromBT709FinalWithGammaCorrection(
          _913, _914, _915,
          _26_m0[8u].x, _26_m0[8u].y,
          pq_r, pq_g, pq_b);
      frontier_phi_23_19_ladder = pq_b;
      frontier_phi_23_19_ladder_1 = pq_g;
      frontier_phi_23_19_ladder_2 = pq_r;
#else
      float _1024 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _915, mad(0.3292830288410186767578125f, _914, _913 * 0.627403914928436279296875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _1025 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _915, mad(0.9195404052734375f, _914, _913 * 0.069097287952899932861328125f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _1026 = exp2(log2(abs(mad(0.895595252513885498046875f, _915, mad(0.08801330626010894775390625f, _914, _913 * 0.01639143936336040496826171875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      frontier_phi_23_19_ladder = exp2(log2(abs(((_1026 * 18.8515625f) + 0.8359375f) / ((_1026 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_23_19_ladder_1 = exp2(log2(abs(((_1025 * 18.8515625f) + 0.8359375f) / ((_1025 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_23_19_ladder_2 = exp2(log2(abs(((_1024 * 18.8515625f) + 0.8359375f) / ((_1024 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_23_19_ladder = _915;
      frontier_phi_23_19_ladder_1 = _914;
      frontier_phi_23_19_ladder_2 = _913;
    }
    _1054 = frontier_phi_23_19_ladder_2;
    _1056 = frontier_phi_23_19_ladder_1;
    _1058 = frontier_phi_23_19_ladder;
  }
  float _1070 = (_16.Load(int3(uint2(uint(int(gl_FragCoord.x)) & 31u, uint(int(gl_FragCoord.y)) & 31u), 0u)).x + (-0.5f)) * _26_m0[10u].x;
  float _1154;
  float _1156;
  float _1158;
  if (_917) {
    float _1084 = exp2(log2(abs(_542)) * _26_m0[8u].x);
    float _1085 = exp2(log2(abs(_544)) * _26_m0[8u].x);
    float _1086 = exp2(log2(abs(_546)) * _26_m0[8u].x);
    float _1155;
    if (_1084 < 0.00310000008903443813323974609375f) {
      _1155 = _1084 * 12.9200000762939453125f;
    } else {
      _1155 = (exp2(log2(abs(_1084)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _1157;
    if (_1085 < 0.00310000008903443813323974609375f) {
      _1157 = _1085 * 12.9200000762939453125f;
    } else {
      _1157 = (exp2(log2(abs(_1085)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_32_39_ladder;
    float frontier_phi_32_39_ladder_1;
    float frontier_phi_32_39_ladder_2;
    if (_1086 < 0.00310000008903443813323974609375f) {
      frontier_phi_32_39_ladder = _1155;
      frontier_phi_32_39_ladder_1 = _1086 * 12.9200000762939453125f;
      frontier_phi_32_39_ladder_2 = _1157;
    } else {
      frontier_phi_32_39_ladder = _1155;
      frontier_phi_32_39_ladder_1 = (exp2(log2(abs(_1086)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_32_39_ladder_2 = _1157;
    }
    _1154 = frontier_phi_32_39_ladder;
    _1156 = frontier_phi_32_39_ladder_2;
    _1158 = frontier_phi_32_39_ladder_1;
  } else {
    float frontier_phi_32_26_ladder;
    float frontier_phi_32_26_ladder_1;
    float frontier_phi_32_26_ladder_2;
    if (_916 == 2u) {
#if 1
      float pq_r;
      float pq_g;
      float pq_b;
      PQFromBT709(
          _542, _544, _546,
          _26_m0[8u].x, _26_m0[8u].y,
          pq_r, pq_g, pq_b);
      frontier_phi_32_26_ladder = pq_r;
      frontier_phi_32_26_ladder_1 = pq_b;  // keep existing swapped local mapping
      frontier_phi_32_26_ladder_2 = pq_g;
#else
      float _1124 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _546, mad(0.3292830288410186767578125f, _544, _542 * 0.627403914928436279296875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _1125 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _546, mad(0.9195404052734375f, _544, _542 * 0.069097287952899932861328125f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _1126 = exp2(log2(abs(mad(0.895595252513885498046875f, _546, mad(0.08801330626010894775390625f, _544, _542 * 0.01639143936336040496826171875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      frontier_phi_32_26_ladder = exp2(log2(abs(((_1124 * 18.8515625f) + 0.8359375f) / ((_1124 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_32_26_ladder_1 = exp2(log2(abs(((_1126 * 18.8515625f) + 0.8359375f) / ((_1126 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_32_26_ladder_2 = exp2(log2(abs(((_1125 * 18.8515625f) + 0.8359375f) / ((_1125 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_32_26_ladder = _542;
      frontier_phi_32_26_ladder_1 = _546;
      frontier_phi_32_26_ladder_2 = _544;
    }
    _1154 = frontier_phi_32_26_ladder;
    _1156 = frontier_phi_32_26_ladder_2;
    _1158 = frontier_phi_32_26_ladder_1;
  }
  SV_Target_1.x = _1154 + _1070;
  SV_Target_1.y = _1156 + _1070;
  SV_Target_1.z = _1158 + _1070;
  SV_Target_1.w = 1.0f;
  SV_Target.x = _1070 + _1054;
  SV_Target.y = _1070 + _1056;
  SV_Target.z = _1070 + _1058;
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
