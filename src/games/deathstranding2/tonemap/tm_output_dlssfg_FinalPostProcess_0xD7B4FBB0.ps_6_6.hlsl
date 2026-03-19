#include "./tonemap.hlsli"

static float _1271;
static float _1272;
static float _1273;

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
  linear float2 TEXCOORD : TEXCOORD;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
  float4 SV_Target_1 : SV_Target1;
};

void frag_main() {
  uint4 _141 = asuint(_26_m0[19u]);
  uint _142 = _141.w;
  uint4 _146 = asuint(_26_m0[20u]);
  uint _147 = _146.x;
  uint _148 = _146.y;
  float4 _163 = _13.Sample((SamplerState)ResourceDescriptorHeap[6u], float2(TEXCOORD.x, TEXCOORD.y));
  float _177 = (_26_m0[11u].z * ((TEXCOORD.x * 2.0f) + (-1.0f))) + _26_m0[11u].x;
  float _178 = (_26_m0[11u].w * ((TEXCOORD.y * 2.0f) + (-1.0f))) + _26_m0[11u].y;
  float _182 = (_177 * 0.5f) + 0.5f;
  float _183 = (_178 * 0.5f) + 0.5f;
  float _262;
  float _266;
  float _270;
  if ((_147 & 196608u) == 0u) {
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
      float4 _379 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_359 + _317) * 0.5f, (_360 + _318) * 0.5f), 0.0f);
      float4 _383 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_317 + _260) * 0.5f, (_318 + _261) * 0.5f), 0.0f);
      frontier_phi_3_2_ladder = (_383.z + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_260, _261), 0.0f).z) * 0.5f;
      frontier_phi_3_2_ladder_1 = (((_383.y + _379.y) * 0.5f) + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_359, _360), 0.0f).y) * 0.5f;
      frontier_phi_3_2_ladder_2 = (_379.x + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_317, _318), 0.0f).x) * 0.5f;
    } else {
      float frontier_phi_3_2_ladder_5_ladder;
      float frontier_phi_3_2_ladder_5_ladder_1;
      float frontier_phi_3_2_ladder_5_ladder_2;
      if ((_148 & 1u) == 0u) {
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
        frontier_phi_3_2_ladder_5_ladder = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_260, _261), 0.0f).z;
        frontier_phi_3_2_ladder_5_ladder_1 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_501 * _471) + 0.5f, (_501 * _472) + 0.5f), 0.0f).y;
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
  float _536;
  float _539;
  float _542;
  float _545;
  float _548;
  float _551;
  bool _402;
  for (;;) {
    _402 = (_147 & 2048u) == 0u;
    float _513;
    float _516;
    float _519;
    float _522;
    float _525;
    float _528;
    if (_402) {
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
      if (_142 == 0u) {
#if 1
        ApplyTonemapGamma2LUTAndInverseTonemapDualOutputs(
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
        float _600 = (-0.0f) - _26_m0[14u].w;
        float _640 = sqrt(max((_262 < _26_m0[15u].z) ? ((_262 * _26_m0[14u].y) + _26_m0[14u].z) : ((_600 / (_262 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f));
        float _641 = sqrt(max((_266 < _26_m0[15u].z) ? ((_266 * _26_m0[14u].y) + _26_m0[14u].z) : ((_600 / (_266 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f));
        float _642 = sqrt(max((_270 < _26_m0[15u].z) ? ((_270 * _26_m0[14u].y) + _26_m0[14u].z) : ((_600 / (_270 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f));
        float4 _660 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(sqrt(max((_394 < _26_m0[15u].z) ? ((_394 * _26_m0[14u].y) + _26_m0[14u].z) : ((_600 / (_394 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_396 < _26_m0[15u].z) ? ((_396 * _26_m0[14u].y) + _26_m0[14u].z) : ((_600 / (_396 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_398 < _26_m0[15u].z) ? ((_398 * _26_m0[14u].y) + _26_m0[14u].z) : ((_600 / (_398 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
        float _663 = _660.x;
        float _664 = _660.y;
        float _665 = _660.z;
        float _547 = _640 * _640;
        float _550 = _641 * _641;
        float _553 = _642 * _642;
        float _538 = _663 * _663;
        float _541 = _664 * _664;
        float _544 = _665 * _665;
        // if (!((_147 & 8192u) == 0u))
        // {
        //     _536 = _538;
        //     _539 = _541;
        //     _542 = _544;
        //     _545 = _547;
        //     _548 = _550;
        //     _551 = _553;
        //     break;
        // }
        float _928 = min(_547, _26_m0[14u].x);
        float _929 = min(_550, _26_m0[14u].x);
        float _930 = min(_553, _26_m0[14u].x);
        float _949 = min(_538, _26_m0[14u].x);
        float _950 = min(_541, _26_m0[14u].x);
        float _951 = min(_544, _26_m0[14u].x);
        frontier_phi_10_11_ladder = (_930 < _26_m0[15u].w) ? ((_930 - _26_m0[14u].z) / _26_m0[14u].y) : ((_600 / (_930 - _26_m0[15u].y)) - _26_m0[15u].x);
        frontier_phi_10_11_ladder_1 = (_929 < _26_m0[15u].w) ? ((_929 - _26_m0[14u].z) / _26_m0[14u].y) : ((_600 / (_929 - _26_m0[15u].y)) - _26_m0[15u].x);
        frontier_phi_10_11_ladder_2 = (_928 < _26_m0[15u].w) ? ((_928 - _26_m0[14u].z) / _26_m0[14u].y) : ((_600 / (_928 - _26_m0[15u].y)) - _26_m0[15u].x);
        frontier_phi_10_11_ladder_3 = (_951 < _26_m0[15u].w) ? ((_951 - _26_m0[14u].z) / _26_m0[14u].y) : ((_600 / (_951 - _26_m0[15u].y)) - _26_m0[15u].x);
        frontier_phi_10_11_ladder_4 = (_950 < _26_m0[15u].w) ? ((_950 - _26_m0[14u].z) / _26_m0[14u].y) : ((_600 / (_950 - _26_m0[15u].y)) - _26_m0[15u].x);
        frontier_phi_10_11_ladder_5 = (_949 < _26_m0[15u].w) ? ((_949 - _26_m0[14u].z) / _26_m0[14u].y) : ((_600 / (_949 - _26_m0[15u].y)) - _26_m0[15u].x);
#endif
      } else {
        float _682 = exp2(log2(abs(_262 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
        float _683 = exp2(log2(abs(_266 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
        float _684 = exp2(log2(abs(_270 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
        float4 _726 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(exp2(log2(abs(((_682 * 18.8515625f) + 0.8359375f) / ((_682 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_683 * 18.8515625f) + 0.8359375f) / ((_683 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_684 * 18.8515625f) + 0.8359375f) / ((_684 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
        float _741 = exp2(log2(abs(_726.x)) * 0.0126833133399486541748046875f);
        float _742 = exp2(log2(abs(_726.y)) * 0.0126833133399486541748046875f);
        float _743 = exp2(log2(abs(_726.z)) * 0.0126833133399486541748046875f);
        float _783 = exp2(log2(abs(_394 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
        float _784 = exp2(log2(abs(_396 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
        float _785 = exp2(log2(abs(_398 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
        float4 _822 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(exp2(log2(abs(((_783 * 18.8515625f) + 0.8359375f) / ((_783 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_784 * 18.8515625f) + 0.8359375f) / ((_784 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_785 * 18.8515625f) + 0.8359375f) / ((_785 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
        float _836 = exp2(log2(abs(_822.x)) * 0.0126833133399486541748046875f);
        float _837 = exp2(log2(abs(_822.y)) * 0.0126833133399486541748046875f);
        float _838 = exp2(log2(abs(_822.z)) * 0.0126833133399486541748046875f);
        frontier_phi_10_11_ladder = exp2(log2(abs((_743 + (-0.8359375f)) / (18.8515625f - (_743 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
        frontier_phi_10_11_ladder_1 = exp2(log2(abs((_742 + (-0.8359375f)) / (18.8515625f - (_742 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
        frontier_phi_10_11_ladder_2 = exp2(log2(abs((_741 + (-0.8359375f)) / (18.8515625f - (_741 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
        frontier_phi_10_11_ladder_3 = exp2(log2(abs((_838 + (-0.8359375f)) / (18.8515625f - (_838 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
        frontier_phi_10_11_ladder_4 = exp2(log2(abs((_837 + (-0.8359375f)) / (18.8515625f - (_837 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
        frontier_phi_10_11_ladder_5 = exp2(log2(abs((_836 + (-0.8359375f)) / (18.8515625f - (_836 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      }
      _513 = frontier_phi_10_11_ladder_5;
      _516 = frontier_phi_10_11_ladder_4;
      _519 = frontier_phi_10_11_ladder_3;
      _522 = frontier_phi_10_11_ladder_2;
      _525 = frontier_phi_10_11_ladder_1;
      _528 = frontier_phi_10_11_ladder;
    }
// if ((_147 & 8192u) == 0u)
// {
//     _536 = _513;
//     _539 = _516;
//     _542 = _519;
//     _545 = _522;
//     _548 = _525;
//     _551 = _528;
//     break;
// }
#if 1
    ApplyUserGradingAndToneMapAndScaleDual(
        _513, _516, _519,
        _522, _525, _528,
        _26_m0[14u].y, _26_m0[14u].z,
        _26_m0[15u].z,
        _26_m0[16u].x, _26_m0[16u].y, _26_m0[16u].z,
        _536, _539, _542,
        _545, _548, _551);
#else
    float _562 = (-0.0f) - _26_m0[16u].x;
    _536 = (_513 < _26_m0[15u].z) ? ((_513 * _26_m0[14u].y) + _26_m0[14u].z) : ((_562 / (_513 + _26_m0[16u].y)) + _26_m0[16u].z);
    _539 = (_516 < _26_m0[15u].z) ? ((_516 * _26_m0[14u].y) + _26_m0[14u].z) : ((_562 / (_516 + _26_m0[16u].y)) + _26_m0[16u].z);
    _542 = (_519 < _26_m0[15u].z) ? ((_519 * _26_m0[14u].y) + _26_m0[14u].z) : ((_562 / (_519 + _26_m0[16u].y)) + _26_m0[16u].z);
    _545 = (_522 < _26_m0[15u].z) ? ((_522 * _26_m0[14u].y) + _26_m0[14u].z) : ((_562 / (_522 + _26_m0[16u].y)) + _26_m0[16u].z);
    _548 = (_525 < _26_m0[15u].z) ? ((_525 * _26_m0[14u].y) + _26_m0[14u].z) : ((_562 / (_525 + _26_m0[16u].y)) + _26_m0[16u].z);
    _551 = (_528 < _26_m0[15u].z) ? ((_528 * _26_m0[14u].y) + _26_m0[14u].z) : ((_562 / (_528 + _26_m0[16u].y)) + _26_m0[16u].z);
#endif
    break;
  }
  float _863;
  float _865;
  float _867;
  if ((_147 & 8u) == 0u) {
    _863 = _536;
    _865 = _539;
    _867 = _542;
  } else {
    float _880 = (_182 * _26_m0[1u].x) + _26_m0[1u].z;
    float _881 = (_183 * _26_m0[1u].y) + _26_m0[1u].w;
    float _885 = max(min(_880, _26_m0[2u].x), min(max(_880, _26_m0[2u].x), _26_m0[2u].z));
    float _889 = max(min(_881, _26_m0[2u].y), min(max(_881, _26_m0[2u].y), _26_m0[2u].w));
    uint _905 = asuint(_26_m0[0u].z);
    float _924 = (_14.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((float(_905 & 65535u) * 1.52587890625e-05f) + (_26_m0[0u].x * TEXCOORD.x), (float(_905 >> 16u) * 1.52587890625e-05f) + (_26_m0[0u].y * TEXCOORD.y)), 0.0f).y + (-0.5f)) * (((((_885 - _26_m0[2u].x) * (_885 - _26_m0[2u].z)) == 0.0f) || (((_889 - _26_m0[2u].y) * (_889 - _26_m0[2u].w)) == 0.0f)) ? 0.0f : _15.SampleLevel((SamplerState)ResourceDescriptorHeap[3u], float2(_885, _889), 0.0f).w);
    _863 = max(_924 + _536, 0.0f);
    _865 = max(_924 + _539, 0.0f);
    _867 = max(_924 + _542, 0.0f);
  }
  float _869 = 1.0f - _163.w;
  float _873 = (_863 * _869) + _163.x;
  float _874 = (_865 * _869) + _163.y;
  float _875 = (_867 * _869) + _163.z;
  uint _876 = uint(int(_26_m0[8u].w));
  bool _877 = _876 == 1u;
  float _1056;
  float _1058;
  float _1060;
  if (_877) {
    float _979 = exp2(log2(abs(_873)) * _26_m0[8u].x);
    float _980 = exp2(log2(abs(_874)) * _26_m0[8u].x);
    float _981 = exp2(log2(abs(_875)) * _26_m0[8u].x);
    float _1057;
    if (_979 < 0.00310000008903443813323974609375f) {
      _1057 = _979 * 12.9200000762939453125f;
    } else {
      _1057 = (exp2(log2(abs(_979)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _1059;
    if (_980 < 0.00310000008903443813323974609375f) {
      _1059 = _980 * 12.9200000762939453125f;
    } else {
      _1059 = (exp2(log2(abs(_980)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_24_34_ladder;
    float frontier_phi_24_34_ladder_1;
    float frontier_phi_24_34_ladder_2;
    if (_981 < 0.00310000008903443813323974609375f) {
      frontier_phi_24_34_ladder = _981 * 12.9200000762939453125f;
      frontier_phi_24_34_ladder_1 = _1059;
      frontier_phi_24_34_ladder_2 = _1057;
    } else {
      frontier_phi_24_34_ladder = (exp2(log2(abs(_981)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_24_34_ladder_1 = _1059;
      frontier_phi_24_34_ladder_2 = _1057;
    }
    _1056 = frontier_phi_24_34_ladder_2;
    _1058 = frontier_phi_24_34_ladder_1;
    _1060 = frontier_phi_24_34_ladder;
  } else {
    float frontier_phi_24_20_ladder;
    float frontier_phi_24_20_ladder_1;
    float frontier_phi_24_20_ladder_2;
    if (_876 == 2u) {
#if 1
      float pq_r;
      float pq_g;
      float pq_b;
      PQFromBT709FinalWithGammaCorrection(
          _873, _874, _875,
          _26_m0[8u].x, _26_m0[8u].y,
          pq_r, pq_g, pq_b);
      frontier_phi_24_20_ladder = pq_b;
      frontier_phi_24_20_ladder_1 = pq_g;
      frontier_phi_24_20_ladder_2 = pq_r;
#else
      float _1026 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _875, mad(0.3292830288410186767578125f, _874, _873 * 0.627403914928436279296875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _1027 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _875, mad(0.9195404052734375f, _874, _873 * 0.069097287952899932861328125f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _1028 = exp2(log2(abs(mad(0.895595252513885498046875f, _875, mad(0.08801330626010894775390625f, _874, _873 * 0.01639143936336040496826171875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      frontier_phi_24_20_ladder = exp2(log2(abs(((_1028 * 18.8515625f) + 0.8359375f) / ((_1028 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_24_20_ladder_1 = exp2(log2(abs(((_1027 * 18.8515625f) + 0.8359375f) / ((_1027 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_24_20_ladder_2 = exp2(log2(abs(((_1026 * 18.8515625f) + 0.8359375f) / ((_1026 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_24_20_ladder = _875;
      frontier_phi_24_20_ladder_1 = _874;
      frontier_phi_24_20_ladder_2 = _873;
    }
    _1056 = frontier_phi_24_20_ladder_2;
    _1058 = frontier_phi_24_20_ladder_1;
    _1060 = frontier_phi_24_20_ladder;
  }
  float _1072 = (_16.Load(int3(uint2(uint(int(gl_FragCoord.x)) & 31u, uint(int(gl_FragCoord.y)) & 31u), 0u)).x + (-0.5f)) * _26_m0[10u].x;
  float _1156;
  float _1158;
  float _1160;
  if (_877) {
    float _1086 = exp2(log2(abs(_545)) * _26_m0[8u].x);
    float _1087 = exp2(log2(abs(_548)) * _26_m0[8u].x);
    float _1088 = exp2(log2(abs(_551)) * _26_m0[8u].x);
    float _1157;
    if (_1086 < 0.00310000008903443813323974609375f) {
      _1157 = _1086 * 12.9200000762939453125f;
    } else {
      _1157 = (exp2(log2(abs(_1086)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _1159;
    if (_1087 < 0.00310000008903443813323974609375f) {
      _1159 = _1087 * 12.9200000762939453125f;
    } else {
      _1159 = (exp2(log2(abs(_1087)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_33_40_ladder;
    float frontier_phi_33_40_ladder_1;
    float frontier_phi_33_40_ladder_2;
    if (_1088 < 0.00310000008903443813323974609375f) {
      frontier_phi_33_40_ladder = _1157;
      frontier_phi_33_40_ladder_1 = _1088 * 12.9200000762939453125f;
      frontier_phi_33_40_ladder_2 = _1159;
    } else {
      frontier_phi_33_40_ladder = _1157;
      frontier_phi_33_40_ladder_1 = (exp2(log2(abs(_1088)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_33_40_ladder_2 = _1159;
    }
    _1156 = frontier_phi_33_40_ladder;
    _1158 = frontier_phi_33_40_ladder_2;
    _1160 = frontier_phi_33_40_ladder_1;
  } else {
    float frontier_phi_33_27_ladder;
    float frontier_phi_33_27_ladder_1;
    float frontier_phi_33_27_ladder_2;
    if (_876 == 2u) {
      float _1126 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _551, mad(0.3292830288410186767578125f, _548, _545 * 0.627403914928436279296875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _1127 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _551, mad(0.9195404052734375f, _548, _545 * 0.069097287952899932861328125f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _1128 = exp2(log2(abs(mad(0.895595252513885498046875f, _551, mad(0.08801330626010894775390625f, _548, _545 * 0.01639143936336040496826171875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      frontier_phi_33_27_ladder = exp2(log2(abs(((_1126 * 18.8515625f) + 0.8359375f) / ((_1126 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_33_27_ladder_1 = exp2(log2(abs(((_1128 * 18.8515625f) + 0.8359375f) / ((_1128 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_33_27_ladder_2 = exp2(log2(abs(((_1127 * 18.8515625f) + 0.8359375f) / ((_1127 * 18.6875f) + 1.0f))) * 78.84375f);
    } else {
      frontier_phi_33_27_ladder = _545;
      frontier_phi_33_27_ladder_1 = _551;
      frontier_phi_33_27_ladder_2 = _548;
    }
    _1156 = frontier_phi_33_27_ladder;
    _1158 = frontier_phi_33_27_ladder_2;
    _1160 = frontier_phi_33_27_ladder_1;
  }
  SV_Target_1.x = _1156 + _1072;
  SV_Target_1.y = _1158 + _1072;
  SV_Target_1.z = _1160 + _1072;
  SV_Target_1.w = 1.0f;
  SV_Target.x = _1072 + _1056;
  SV_Target.y = _1072 + _1058;
  SV_Target.z = _1072 + _1060;
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
