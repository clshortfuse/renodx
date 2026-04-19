#include "./tonemap.hlsli"

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
  if ((_147 & 2048u) == 0u) {
    _513 = _394;
    _516 = _396;
    _519 = _398;
  } else {
    float frontier_phi_10_11_ladder;
    float frontier_phi_10_11_ladder_1;
    float frontier_phi_10_11_ladder_2;
    if (asuint(_26_m0[19u]).w == 0u) {
#if 1
      ApplyTonemapGamma2LUTAndInverseTonemap(
          (SamplerState)ResourceDescriptorHeap[17u],
          _19,
          _394, _396, _398,
          _26_m0[14u].w,
          _26_m0[14u].x, _26_m0[14u].y, _26_m0[14u].z,
          _26_m0[15u].x, _26_m0[15u].y, _26_m0[15u].z, _26_m0[15u].w,
          _26_m0[18u].x, _26_m0[18u].y,
          frontier_phi_10_11_ladder,
          frontier_phi_10_11_ladder_1,
          frontier_phi_10_11_ladder_2);
#else
      float _561 = (-0.0f) - _26_m0[14u].w;
      // float4 _594 = _19.SampleLevel(_8[17u], float3((clamp(sqrt(max((_394 < _26_m0[15u].z) ? ((_394 * _26_m0[14u].y) + _26_m0[14u].z) : ((_561 / (_394 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_396 < _26_m0[15u].z) ? ((_396 * _26_m0[14u].y) + _26_m0[14u].z) : ((_561 / (_396 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_398 < _26_m0[15u].z) ? ((_398 * _26_m0[14u].y) + _26_m0[14u].z) : ((_561 / (_398 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float4 _594 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(sqrt(max((_394 < _26_m0[15u].z) ? ((_394 * _26_m0[14u].y) + _26_m0[14u].z) : ((_561 / (_394 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_396 < _26_m0[15u].z) ? ((_396 * _26_m0[14u].y) + _26_m0[14u].z) : ((_561 / (_396 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_398 < _26_m0[15u].z) ? ((_398 * _26_m0[14u].y) + _26_m0[14u].z) : ((_561 / (_398 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float _597 = _594.x;
      float _598 = _594.y;
      float _599 = _594.z;
      float _603 = min(_597 * _597, _26_m0[14u].x);
      float _604 = min(_598 * _598, _26_m0[14u].x);
      float _605 = min(_599 * _599, _26_m0[14u].x);
      frontier_phi_10_11_ladder = (_605 < _26_m0[15u].w) ? ((_605 - _26_m0[14u].z) / _26_m0[14u].y) : ((_561 / (_605 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_1 = (_604 < _26_m0[15u].w) ? ((_604 - _26_m0[14u].z) / _26_m0[14u].y) : ((_561 / (_604 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_2 = (_603 < _26_m0[15u].w) ? ((_603 - _26_m0[14u].z) / _26_m0[14u].y) : ((_561 / (_603 - _26_m0[15u].y)) - _26_m0[15u].x);
#endif
    } else {
      float _638 = exp2(log2(abs(_394 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _639 = exp2(log2(abs(_396 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _640 = exp2(log2(abs(_398 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      // float4 _682 = _19.SampleLevel(_8[17u], float3((clamp(exp2(log2(abs(((_638 * 18.8515625f) + 0.8359375f) / ((_638 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_639 * 18.8515625f) + 0.8359375f) / ((_639 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_640 * 18.8515625f) + 0.8359375f) / ((_640 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float4 _682 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(exp2(log2(abs(((_638 * 18.8515625f) + 0.8359375f) / ((_638 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_639 * 18.8515625f) + 0.8359375f) / ((_639 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_640 * 18.8515625f) + 0.8359375f) / ((_640 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float _697 = exp2(log2(abs(_682.x)) * 0.0126833133399486541748046875f);
      float _698 = exp2(log2(abs(_682.y)) * 0.0126833133399486541748046875f);
      float _699 = exp2(log2(abs(_682.z)) * 0.0126833133399486541748046875f);
      frontier_phi_10_11_ladder = exp2(log2(abs((_699 + (-0.8359375f)) / (18.8515625f - (_699 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_1 = exp2(log2(abs((_698 + (-0.8359375f)) / (18.8515625f - (_698 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_2 = exp2(log2(abs((_697 + (-0.8359375f)) / (18.8515625f - (_697 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
    }
    _513 = frontier_phi_10_11_ladder_2;
    _516 = frontier_phi_10_11_ladder_1;
    _519 = frontier_phi_10_11_ladder;
  }
  float _527;
  float _529;
  float _531;
  if ((_147 & 8192u) == 0u) {
    _527 = _513;
    _529 = _516;
    _531 = _519;
  } else {
#if 1
    ApplyUserGradingAndToneMapAndScale(
        _513, _516, _519,
        _26_m0[14u].y, _26_m0[14u].z,
        _26_m0[15u].z,
        _26_m0[16u].x, _26_m0[16u].y, _26_m0[16u].z,
        _527, _529, _531);
#else
    float _541 = (-0.0f) - _26_m0[16u].x;
    _527 = (_513 < _26_m0[15u].z) ? ((_513 * _26_m0[14u].y) + _26_m0[14u].z) : ((_541 / (_513 + _26_m0[16u].y)) + _26_m0[16u].z);
    _529 = (_516 < _26_m0[15u].z) ? ((_516 * _26_m0[14u].y) + _26_m0[14u].z) : ((_541 / (_516 + _26_m0[16u].y)) + _26_m0[16u].z);
    _531 = (_519 < _26_m0[15u].z) ? ((_519 * _26_m0[14u].y) + _26_m0[14u].z) : ((_541 / (_519 + _26_m0[16u].y)) + _26_m0[16u].z);
#endif
  }
  float _727;
  float _729;
  float _731;
  if ((_147 & 8u) == 0u) {
    _727 = _527;
    _729 = _529;
    _731 = _531;
  } else {
    float _744 = (_182 * _26_m0[1u].x) + _26_m0[1u].z;
    float _745 = (_183 * _26_m0[1u].y) + _26_m0[1u].w;
    float _749 = max(min(_744, _26_m0[2u].x), min(max(_744, _26_m0[2u].x), _26_m0[2u].z));
    float _753 = max(min(_745, _26_m0[2u].y), min(max(_745, _26_m0[2u].y), _26_m0[2u].w));
    uint _769 = asuint(_26_m0[0u].z);
    // float _788 = (_14.SampleLevel(_8[17u], float2((float(_769 & 65535u) * 1.52587890625e-05f) + (_26_m0[0u].x * TEXCOORD.x), (float(_769 >> 16u) * 1.52587890625e-05f) + (_26_m0[0u].y * TEXCOORD.y)), 0.0f).y + (-0.5f)) * (((((_749 - _26_m0[2u].x) * (_749 - _26_m0[2u].z)) == 0.0f) || (((_753 - _26_m0[2u].y) * (_753 - _26_m0[2u].w)) == 0.0f)) ? 0.0f : _15.SampleLevel(_8[3u], float2(_749, _753), 0.0f).w);
    float _788 = (_14.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((float(_769 & 65535u) * 1.52587890625e-05f) + (_26_m0[0u].x * TEXCOORD.x), (float(_769 >> 16u) * 1.52587890625e-05f) + (_26_m0[0u].y * TEXCOORD.y)), 0.0f).y + (-0.5f)) * (((((_749 - _26_m0[2u].x) * (_749 - _26_m0[2u].z)) == 0.0f) || (((_753 - _26_m0[2u].y) * (_753 - _26_m0[2u].w)) == 0.0f)) ? 0.0f : _15.SampleLevel((SamplerState)ResourceDescriptorHeap[3u], float2(_749, _753), 0.0f).w);
    // _727 = max(_788 + _527, 0.0f);
    // _729 = max(_788 + _529, 0.0f);
    // _731 = max(_788 + _531, 0.0f);
    _727 = _788 + _527;
    _729 = _788 + _529;
    _731 = _788 + _531;
  }
  float _733 = 1.0f - _163.w;
  float _737 = (_727 * _733) + _163.x;
  float _738 = (_729 * _733) + _163.y;
  float _739 = (_731 * _733) + _163.z;
  uint _740 = uint(int(_26_m0[8u].w));
  bool _741 = _740 == 1u;
  float _878;
  float _880;
  float _882;
  if (_741) {
    float _801 = exp2(log2(abs(_737)) * _26_m0[8u].x);
    float _802 = exp2(log2(abs(_738)) * _26_m0[8u].x);
    float _803 = exp2(log2(abs(_739)) * _26_m0[8u].x);
    float _879;
    if (_801 < 0.00310000008903443813323974609375f) {
      _879 = _801 * 12.9200000762939453125f;
    } else {
      _879 = (exp2(log2(abs(_801)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _881;
    if (_802 < 0.00310000008903443813323974609375f) {
      _881 = _802 * 12.9200000762939453125f;
    } else {
      _881 = (exp2(log2(abs(_802)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_23_33_ladder;
    float frontier_phi_23_33_ladder_1;
    float frontier_phi_23_33_ladder_2;
    if (_803 < 0.00310000008903443813323974609375f) {
      frontier_phi_23_33_ladder = _803 * 12.9200000762939453125f;
      frontier_phi_23_33_ladder_1 = _881;
      frontier_phi_23_33_ladder_2 = _879;
    } else {
      frontier_phi_23_33_ladder = (exp2(log2(abs(_803)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_23_33_ladder_1 = _881;
      frontier_phi_23_33_ladder_2 = _879;
    }
    _878 = frontier_phi_23_33_ladder_2;
    _880 = frontier_phi_23_33_ladder_1;
    _882 = frontier_phi_23_33_ladder;
  } else {
    float frontier_phi_23_19_ladder;
    float frontier_phi_23_19_ladder_1;
    float frontier_phi_23_19_ladder_2;
    if (_740 == 2u) {
#if 1
      float pq_r;
      float pq_g;
      float pq_b;
      PQFromBT709FinalWithGammaCorrection(
          _737, _738, _739,
          _26_m0[8u].x, _26_m0[8u].y,
          pq_r, pq_g, pq_b);
      frontier_phi_23_19_ladder = pq_b;
      frontier_phi_23_19_ladder_1 = pq_g;
      frontier_phi_23_19_ladder_2 = pq_r;
#else
      float _848 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _739, mad(0.3292830288410186767578125f, _738, _737 * 0.627403914928436279296875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _849 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _739, mad(0.9195404052734375f, _738, _737 * 0.069097287952899932861328125f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _850 = exp2(log2(abs(mad(0.895595252513885498046875f, _739, mad(0.08801330626010894775390625f, _738, _737 * 0.01639143936336040496826171875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      frontier_phi_23_19_ladder = exp2(log2(abs(((_850 * 18.8515625f) + 0.8359375f) / ((_850 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_23_19_ladder_1 = exp2(log2(abs(((_849 * 18.8515625f) + 0.8359375f) / ((_849 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_23_19_ladder_2 = exp2(log2(abs(((_848 * 18.8515625f) + 0.8359375f) / ((_848 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_23_19_ladder = _739;
      frontier_phi_23_19_ladder_1 = _738;
      frontier_phi_23_19_ladder_2 = _737;
    }
    _878 = frontier_phi_23_19_ladder_2;
    _880 = frontier_phi_23_19_ladder_1;
    _882 = frontier_phi_23_19_ladder;
  }
  float _894 = (_16.Load(int3(uint2(uint(int(gl_FragCoord.x)) & 31u, uint(int(gl_FragCoord.y)) & 31u), 0u)).x + (-0.5f)) * _26_m0[10u].x;
  float _978;
  float _980;
  float _982;
  if (_741) {
    float _908 = exp2(log2(abs(_727)) * _26_m0[8u].x);
    float _909 = exp2(log2(abs(_729)) * _26_m0[8u].x);
    float _910 = exp2(log2(abs(_731)) * _26_m0[8u].x);
    float _979;
    if (_908 < 0.00310000008903443813323974609375f) {
      _979 = _908 * 12.9200000762939453125f;
    } else {
      _979 = (exp2(log2(abs(_908)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _981;
    if (_909 < 0.00310000008903443813323974609375f) {
      _981 = _909 * 12.9200000762939453125f;
    } else {
      _981 = (exp2(log2(abs(_909)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_32_39_ladder;
    float frontier_phi_32_39_ladder_1;
    float frontier_phi_32_39_ladder_2;
    if (_910 < 0.00310000008903443813323974609375f) {
      frontier_phi_32_39_ladder = _979;
      frontier_phi_32_39_ladder_1 = _910 * 12.9200000762939453125f;
      frontier_phi_32_39_ladder_2 = _981;
    } else {
      frontier_phi_32_39_ladder = _979;
      frontier_phi_32_39_ladder_1 = (exp2(log2(abs(_910)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_32_39_ladder_2 = _981;
    }
    _978 = frontier_phi_32_39_ladder;
    _980 = frontier_phi_32_39_ladder_2;
    _982 = frontier_phi_32_39_ladder_1;
  } else {
    float frontier_phi_32_26_ladder;
    float frontier_phi_32_26_ladder_1;
    float frontier_phi_32_26_ladder_2;
    if (_740 == 2u) {
#if 1
      float pq_r;
      float pq_g;
      float pq_b;
      PQFromBT709FinalWithGammaCorrection(
          _727, _729, _731,
          _26_m0[8u].x, _26_m0[8u].y,
          pq_r, pq_g, pq_b);
      frontier_phi_32_26_ladder = pq_r;
      frontier_phi_32_26_ladder_1 = pq_b;
      frontier_phi_32_26_ladder_2 = pq_g;
#else
      float _948 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _731, mad(0.3292830288410186767578125f, _729, _727 * 0.627403914928436279296875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _949 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _731, mad(0.9195404052734375f, _729, _727 * 0.069097287952899932861328125f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _950 = exp2(log2(abs(mad(0.895595252513885498046875f, _731, mad(0.08801330626010894775390625f, _729, _727 * 0.01639143936336040496826171875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      frontier_phi_32_26_ladder = exp2(log2(abs(((_948 * 18.8515625f) + 0.8359375f) / ((_948 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_32_26_ladder_1 = exp2(log2(abs(((_950 * 18.8515625f) + 0.8359375f) / ((_950 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_32_26_ladder_2 = exp2(log2(abs(((_949 * 18.8515625f) + 0.8359375f) / ((_949 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_32_26_ladder = _727;
      frontier_phi_32_26_ladder_1 = _731;
      frontier_phi_32_26_ladder_2 = _729;
    }
    _978 = frontier_phi_32_26_ladder;
    _980 = frontier_phi_32_26_ladder_2;
    _982 = frontier_phi_32_26_ladder_1;
  }
  SV_Target_1.x = _978 + _894;
  SV_Target_1.y = _980 + _894;
  SV_Target_1.z = _982 + _894;
  SV_Target_1.w = 1.0f;
  SV_Target.x = _894 + _878;
  SV_Target.y = _894 + _880;
  SV_Target.z = _894 + _882;
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
