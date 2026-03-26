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

struct SPIRV_Cross_Input {
  noperspective float4 gl_FragCoord : SV_Position;
  linear float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  uint4 _145 = asuint(_26_m0[20u]);
  uint _146 = _145.x;
  uint _147 = _145.y;
  // float4 _162 = _13.Sample(_8[6u], float2(TEXCOORD.x, TEXCOORD.y));
  float4 _162 = _13.Sample((SamplerState)ResourceDescriptorHeap[6u], float2(TEXCOORD.x, TEXCOORD.y));
  float _176 = (_26_m0[11u].z * ((TEXCOORD.x * 2.0f) + (-1.0f))) + _26_m0[11u].x;
  float _177 = (_26_m0[11u].w * ((TEXCOORD.y * 2.0f) + (-1.0f))) + _26_m0[11u].y;
  float _181 = (_176 * 0.5f) + 0.5f;
  float _182 = (_177 * 0.5f) + 0.5f;
  float _261;
  float _265;
  float _269;
  if ((_146 & 196608u) == 0u) {
    // float4 _189 = _12.SampleLevel(_8[3u], float2(_181, _182), 0.0f);
    float4 _189 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[3u], float2(_181, _182), 0.0f);
    _261 = _189.x;
    _265 = _189.y;
    _269 = _189.z;
  } else {
    float _197 = TEXCOORD.x + (-0.5f);
    float _199 = TEXCOORD.y + (-0.5f);
    float _206 = (((_26_m0[3u].z * _197) + 0.5f) * 2.0f) + (-1.0f);
    float _207 = (((_26_m0[3u].z * _199) + 0.5f) * 2.0f) + (-1.0f);
    float _208 = _206 * _26_m0[5u].x;
    float _209 = _207 * _26_m0[5u].y;
    float _210 = dot(float2(_208, _209), float2(_208, _209));
    float _213 = _210 * _210;
    float _214 = _26_m0[3u].x * 2.0f;
    float _215 = _26_m0[3u].y * 4.0f;
    float _222 = _26_m0[3u].x * 3.0f;
    float _224 = _26_m0[3u].y * 5.0f;
    float _238 = (dot(1.0f.xx, float2(_214, _215)) + 1.0f) / (dot(1.0f.xx, float2(_222, _224)) + 1.0f);
    float _240 = (dot(float2(_210, _213), float2(_214, _215)) + 1.0f) / (_238 * (dot(float2(_210, _213), float2(_222, _224)) + 1.0f));
    bool _241 = _26_m0[3u].w != 0.0f;
    float _245 = log2(abs(_241 ? _206 : _207));
    float _252 = _26_m0[4u].x * 0.5f;
    float _256 = ((((1.0f - _240) * _252) * (exp2(_245 * _26_m0[4u].z) + exp2(_245 * _26_m0[4u].y))) + _240) * 0.5f;
    float _259 = (_256 * _206) + 0.5f;
    float _260 = (_256 * _207) + 0.5f;
    float frontier_phi_3_2_ladder;
    float frontier_phi_3_2_ladder_1;
    float frontier_phi_3_2_ladder_2;
    if (_147 == 3u) {
      float _276 = _26_m0[6u].x * _26_m0[3u].z;
      float _283 = (((_276 * _197) + 0.5f) * 2.0f) + (-1.0f);
      float _284 = (((_276 * _199) + 0.5f) * 2.0f) + (-1.0f);
      float _285 = _283 * _26_m0[5u].x;
      float _286 = _284 * _26_m0[5u].y;
      float _287 = dot(float2(_285, _286), float2(_285, _286));
      float _290 = _287 * _287;
      float _300 = (dot(float2(_287, _290), float2(_214, _215)) + 1.0f) / ((dot(float2(_287, _290), float2(_222, _224)) + 1.0f) * _238);
      float _303 = log2(abs(_241 ? _283 : _284));
      float _313 = ((((1.0f - _300) * _252) * (exp2(_303 * _26_m0[4u].z) + exp2(_303 * _26_m0[4u].y))) + _300) * 0.5f;
      float _316 = (_313 * _283) + 0.5f;
      float _317 = (_313 * _284) + 0.5f;
      float _318 = _26_m0[6u].y * _26_m0[3u].z;
      float _325 = (((_318 * _197) + 0.5f) * 2.0f) + (-1.0f);
      float _326 = (((_318 * _199) + 0.5f) * 2.0f) + (-1.0f);
      float _327 = _325 * _26_m0[5u].x;
      float _328 = _326 * _26_m0[5u].y;
      float _329 = dot(float2(_327, _328), float2(_327, _328));
      float _332 = _329 * _329;
      float _342 = (dot(float2(_329, _332), float2(_214, _215)) + 1.0f) / ((dot(float2(_329, _332), float2(_222, _224)) + 1.0f) * _238);
      float _345 = log2(abs(_241 ? _325 : _326));
      float _355 = ((((1.0f - _342) * _252) * (exp2(_345 * _26_m0[4u].z) + exp2(_345 * _26_m0[4u].y))) + _342) * 0.5f;
      float _358 = (_355 * _325) + 0.5f;
      float _359 = (_355 * _326) + 0.5f;
      // float4 _378 = _12.SampleLevel(_8[17u], float2((_358 + _316) * 0.5f, (_359 + _317) * 0.5f), 0.0f);
      float4 _378 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_358 + _316) * 0.5f, (_359 + _317) * 0.5f), 0.0f);
      // float4 _382 = _12.SampleLevel(_8[17u], float2((_316 + _259) * 0.5f, (_317 + _260) * 0.5f), 0.0f);
      float4 _382 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_316 + _259) * 0.5f, (_317 + _260) * 0.5f), 0.0f);
      // frontier_phi_3_2_ladder = (_382.z + _12.SampleLevel(_8[17u], float2(_259, _260), 0.0f).z) * 0.5f;
      frontier_phi_3_2_ladder = (_382.z + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_259, _260), 0.0f).z) * 0.5f;
      // frontier_phi_3_2_ladder_1 = (((_382.y + _378.y) * 0.5f) + _12.SampleLevel(_8[17u], float2(_358, _359), 0.0f).y) * 0.5f;
      frontier_phi_3_2_ladder_1 = (((_382.y + _378.y) * 0.5f) + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_358, _359), 0.0f).y) * 0.5f;
      // frontier_phi_3_2_ladder_2 = (_378.x + _12.SampleLevel(_8[17u], float2(_316, _317), 0.0f).x) * 0.5f;
      frontier_phi_3_2_ladder_2 = (_378.x + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_316, _317), 0.0f).x) * 0.5f;
    } else {
      float frontier_phi_3_2_ladder_5_ladder;
      float frontier_phi_3_2_ladder_5_ladder_1;
      float frontier_phi_3_2_ladder_5_ladder_2;
      if ((_147 & 1u) == 0u) {
        // float4 _419 = _12.SampleLevel(_8[17u], float2(_259, _260), 0.0f);
        float4 _419 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_259, _260), 0.0f);
        frontier_phi_3_2_ladder_5_ladder = _419.z;
        frontier_phi_3_2_ladder_5_ladder_1 = _419.y;
        frontier_phi_3_2_ladder_5_ladder_2 = _419.x;
      } else {
        float _421 = _26_m0[6u].x * _26_m0[3u].z;
        float _428 = (((_421 * _197) + 0.5f) * 2.0f) + (-1.0f);
        float _429 = (((_421 * _199) + 0.5f) * 2.0f) + (-1.0f);
        float _430 = _428 * _26_m0[5u].x;
        float _431 = _429 * _26_m0[5u].y;
        float _432 = dot(float2(_430, _431), float2(_430, _431));
        float _435 = _432 * _432;
        float _445 = (dot(float2(_432, _435), float2(_214, _215)) + 1.0f) / ((dot(float2(_432, _435), float2(_222, _224)) + 1.0f) * _238);
        float _448 = log2(abs(_241 ? _428 : _429));
        float _458 = ((((1.0f - _445) * _252) * (exp2(_448 * _26_m0[4u].z) + exp2(_448 * _26_m0[4u].y))) + _445) * 0.5f;
        float _463 = _26_m0[6u].y * _26_m0[3u].z;
        float _470 = (((_463 * _197) + 0.5f) * 2.0f) + (-1.0f);
        float _471 = (((_463 * _199) + 0.5f) * 2.0f) + (-1.0f);
        float _472 = _470 * _26_m0[5u].x;
        float _473 = _471 * _26_m0[5u].y;
        float _474 = dot(float2(_472, _473), float2(_472, _473));
        float _477 = _474 * _474;
        float _487 = (dot(float2(_474, _477), float2(_214, _215)) + 1.0f) / ((dot(float2(_474, _477), float2(_222, _224)) + 1.0f) * _238);
        float _490 = log2(abs(_241 ? _470 : _471));
        float _500 = ((((1.0f - _487) * _252) * (exp2(_490 * _26_m0[4u].z) + exp2(_490 * _26_m0[4u].y))) + _487) * 0.5f;
        // frontier_phi_3_2_ladder_5_ladder = _12.SampleLevel(_8[17u], float2(_259, _260), 0.0f).z;
        frontier_phi_3_2_ladder_5_ladder = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_259, _260), 0.0f).z;
        // frontier_phi_3_2_ladder_5_ladder_1 = _12.SampleLevel(_8[17u], float2((_500 * _470) + 0.5f, (_500 * _471) + 0.5f), 0.0f).y;
        frontier_phi_3_2_ladder_5_ladder_1 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_500 * _470) + 0.5f, (_500 * _471) + 0.5f), 0.0f).y;
        // frontier_phi_3_2_ladder_5_ladder_2 = _12.SampleLevel(_8[17u], float2((_458 * _428) + 0.5f, (_458 * _429) + 0.5f), 0.0f).x;
        frontier_phi_3_2_ladder_5_ladder_2 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_458 * _428) + 0.5f, (_458 * _429) + 0.5f), 0.0f).x;
      }
      frontier_phi_3_2_ladder = frontier_phi_3_2_ladder_5_ladder;
      frontier_phi_3_2_ladder_1 = frontier_phi_3_2_ladder_5_ladder_1;
      frontier_phi_3_2_ladder_2 = frontier_phi_3_2_ladder_5_ladder_2;
    }
    _261 = frontier_phi_3_2_ladder_2;
    _265 = frontier_phi_3_2_ladder_1;
    _269 = frontier_phi_3_2_ladder;
  }
  float _393;
  float _395;
  float _397;
  if ((_146 & 64u) == 0u) {
    _393 = _261;
    _395 = _265;
    _397 = _269;
  } else {
    float _408 = clamp((sqrt((_176 * _176) + (_177 * _177)) * _26_m0[18u].z) + _26_m0[18u].w, 0.0f, 1.0f);
    float _410 = (_408 * _408) * _26_m0[13u].w;
    float _411 = 1.0f - _410;
    _393 = (_411 * _261) + (_410 * _26_m0[13u].x);
    _395 = (_411 * _265) + (_410 * _26_m0[13u].y);
    _397 = (_411 * _269) + (_410 * _26_m0[13u].z);
  }
  float _512;
  float _515;
  float _518;
  if ((_146 & 2048u) == 0u) {
    _512 = _393;
    _515 = _395;
    _518 = _397;
  } else {
    float frontier_phi_10_11_ladder;
    float frontier_phi_10_11_ladder_1;
    float frontier_phi_10_11_ladder_2;
    if (asuint(_26_m0[19u]).w == 0u) {
#if 1
      ApplyTonemapGamma2LUTAndInverseTonemap(
          (SamplerState)ResourceDescriptorHeap[17u],
          _19,
          _393, _395, _397,
          _26_m0[14u].w,
          _26_m0[14u].x, _26_m0[14u].y, _26_m0[14u].z,
          _26_m0[15u].x, _26_m0[15u].y, _26_m0[15u].z, _26_m0[15u].w,
          _26_m0[18u].x, _26_m0[18u].y,
          frontier_phi_10_11_ladder,
          frontier_phi_10_11_ladder_1,
          frontier_phi_10_11_ladder_2);
#else
      float _560 = (-0.0f) - _26_m0[14u].w;
      // float4 _593 = _19.SampleLevel(_8[17u], float3((clamp(sqrt(max((_393 < _26_m0[15u].z) ? ((_393 * _26_m0[14u].y) + _26_m0[14u].z) : ((_560 / (_393 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_395 < _26_m0[15u].z) ? ((_395 * _26_m0[14u].y) + _26_m0[14u].z) : ((_560 / (_395 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_397 < _26_m0[15u].z) ? ((_397 * _26_m0[14u].y) + _26_m0[14u].z) : ((_560 / (_397 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float4 _593 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(sqrt(max((_393 < _26_m0[15u].z) ? ((_393 * _26_m0[14u].y) + _26_m0[14u].z) : ((_560 / (_393 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_395 < _26_m0[15u].z) ? ((_395 * _26_m0[14u].y) + _26_m0[14u].z) : ((_560 / (_395 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(sqrt(max((_397 < _26_m0[15u].z) ? ((_397 * _26_m0[14u].y) + _26_m0[14u].z) : ((_560 / (_397 + _26_m0[15u].x)) + _26_m0[15u].y), 0.0f)), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float _596 = _593.x;
      float _597 = _593.y;
      float _598 = _593.z;
      float _602 = min(_596 * _596, _26_m0[14u].x);
      float _603 = min(_597 * _597, _26_m0[14u].x);
      float _604 = min(_598 * _598, _26_m0[14u].x);
      frontier_phi_10_11_ladder = (_604 < _26_m0[15u].w) ? ((_604 - _26_m0[14u].z) / _26_m0[14u].y) : ((_560 / (_604 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_1 = (_603 < _26_m0[15u].w) ? ((_603 - _26_m0[14u].z) / _26_m0[14u].y) : ((_560 / (_603 - _26_m0[15u].y)) - _26_m0[15u].x);
      frontier_phi_10_11_ladder_2 = (_602 < _26_m0[15u].w) ? ((_602 - _26_m0[14u].z) / _26_m0[14u].y) : ((_560 / (_602 - _26_m0[15u].y)) - _26_m0[15u].x);
#endif
    } else {
      float _637 = exp2(log2(abs(_393 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _638 = exp2(log2(abs(_395 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _639 = exp2(log2(abs(_397 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      // float4 _681 = _19.SampleLevel(_8[17u], float3((clamp(exp2(log2(abs(((_637 * 18.8515625f) + 0.8359375f) / ((_637 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_638 * 18.8515625f) + 0.8359375f) / ((_638 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_639 * 18.8515625f) + 0.8359375f) / ((_639 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float4 _681 = _19.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float3((clamp(exp2(log2(abs(((_637 * 18.8515625f) + 0.8359375f) / ((_637 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_638 * 18.8515625f) + 0.8359375f) / ((_638 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y, (clamp(exp2(log2(abs(((_639 * 18.8515625f) + 0.8359375f) / ((_639 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _26_m0[18u].x) + _26_m0[18u].y), 0.0f);
      float _696 = exp2(log2(abs(_681.x)) * 0.0126833133399486541748046875f);
      float _697 = exp2(log2(abs(_681.y)) * 0.0126833133399486541748046875f);
      float _698 = exp2(log2(abs(_681.z)) * 0.0126833133399486541748046875f);
      frontier_phi_10_11_ladder = exp2(log2(abs((_698 + (-0.8359375f)) / (18.8515625f - (_698 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_1 = exp2(log2(abs((_697 + (-0.8359375f)) / (18.8515625f - (_697 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_2 = exp2(log2(abs((_696 + (-0.8359375f)) / (18.8515625f - (_696 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
    }
    _512 = frontier_phi_10_11_ladder_2;
    _515 = frontier_phi_10_11_ladder_1;
    _518 = frontier_phi_10_11_ladder;
  }
  float _526;
  float _528;
  float _530;
  if ((_146 & 8192u) == 0u) {
    _526 = _512;
    _528 = _515;
    _530 = _518;
  } else {
#if 1
    ApplyUserGradingAndToneMapAndScale(
        _512, _515, _518,
        _26_m0[14u].y, _26_m0[14u].z,
        _26_m0[15u].z,
        _26_m0[16u].x, _26_m0[16u].y, _26_m0[16u].z,
        _526, _528, _530);
#else
    float _540 = (-0.0f) - _26_m0[16u].x;
    _526 = (_512 < _26_m0[15u].z) ? ((_512 * _26_m0[14u].y) + _26_m0[14u].z) : ((_540 / (_512 + _26_m0[16u].y)) + _26_m0[16u].z);
    _528 = (_515 < _26_m0[15u].z) ? ((_515 * _26_m0[14u].y) + _26_m0[14u].z) : ((_540 / (_515 + _26_m0[16u].y)) + _26_m0[16u].z);
    _530 = (_518 < _26_m0[15u].z) ? ((_518 * _26_m0[14u].y) + _26_m0[14u].z) : ((_540 / (_518 + _26_m0[16u].y)) + _26_m0[16u].z);
#endif
  }
  float _726;
  float _728;
  float _730;
  if ((_146 & 8u) == 0u) {
    _726 = _526;
    _728 = _528;
    _730 = _530;
  } else {
    float _743 = (_181 * _26_m0[1u].x) + _26_m0[1u].z;
    float _744 = (_182 * _26_m0[1u].y) + _26_m0[1u].w;
    float _748 = max(min(_743, _26_m0[2u].x), min(max(_743, _26_m0[2u].x), _26_m0[2u].z));
    float _752 = max(min(_744, _26_m0[2u].y), min(max(_744, _26_m0[2u].y), _26_m0[2u].w));
    uint _768 = asuint(_26_m0[0u].z);
    // float _787 = (_14.SampleLevel(_8[17u], float2((float(_768 & 65535u) * 1.52587890625e-05f) + (_26_m0[0u].x * TEXCOORD.x), (float(_768 >> 16u) * 1.52587890625e-05f) + (_26_m0[0u].y * TEXCOORD.y)), 0.0f).y + (-0.5f)) * (((((_748 - _26_m0[2u].x) * (_748 - _26_m0[2u].z)) == 0.0f) || (((_752 - _26_m0[2u].y) * (_752 - _26_m0[2u].w)) == 0.0f)) ? 0.0f : _15.SampleLevel(_8[3u], float2(_748, _752), 0.0f).w);
    float _787 = (_14.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((float(_768 & 65535u) * 1.52587890625e-05f) + (_26_m0[0u].x * TEXCOORD.x), (float(_768 >> 16u) * 1.52587890625e-05f) + (_26_m0[0u].y * TEXCOORD.y)), 0.0f).y + (-0.5f)) * (((((_748 - _26_m0[2u].x) * (_748 - _26_m0[2u].z)) == 0.0f) || (((_752 - _26_m0[2u].y) * (_752 - _26_m0[2u].w)) == 0.0f)) ? 0.0f : _15.SampleLevel((SamplerState)ResourceDescriptorHeap[3u], float2(_748, _752), 0.0f).w);
#if 1
    _726 = (_787 + _526);
    _728 = (_787 + _528);
    _730 = (_787 + _530);
#else
    _726 = max(_787 + _526, 0.0f);
    _728 = max(_787 + _528, 0.0f);
    _730 = max(_787 + _530, 0.0f);
#endif
  }
  float _732 = 1.0f - _162.w;
  float _736 = (_726 * _732) + _162.x;
  float _737 = (_728 * _732) + _162.y;
  float _738 = (_730 * _732) + _162.z;
  uint _739 = uint(int(_26_m0[8u].w));
  float _877;
  float _879;
  float _881;
  if (_739 == 1u) {
    float _800 = exp2(log2(abs(_736)) * _26_m0[8u].x);
    float _801 = exp2(log2(abs(_737)) * _26_m0[8u].x);
    float _802 = exp2(log2(abs(_738)) * _26_m0[8u].x);
    float _878;
    if (_800 < 0.00310000008903443813323974609375f) {
      _878 = _800 * 12.9200000762939453125f;
    } else {
      _878 = (exp2(log2(abs(_800)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _880;
    if (_801 < 0.00310000008903443813323974609375f) {
      _880 = _801 * 12.9200000762939453125f;
    } else {
      _880 = (exp2(log2(abs(_801)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_23_27_ladder;
    float frontier_phi_23_27_ladder_1;
    float frontier_phi_23_27_ladder_2;
    if (_802 < 0.00310000008903443813323974609375f) {
      frontier_phi_23_27_ladder = _878;
      frontier_phi_23_27_ladder_1 = _802 * 12.9200000762939453125f;
      frontier_phi_23_27_ladder_2 = _880;
    } else {
      frontier_phi_23_27_ladder = _878;
      frontier_phi_23_27_ladder_1 = (exp2(log2(abs(_802)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_23_27_ladder_2 = _880;
    }
    _877 = frontier_phi_23_27_ladder;
    _879 = frontier_phi_23_27_ladder_2;
    _881 = frontier_phi_23_27_ladder_1;
  } else {
    float frontier_phi_23_19_ladder;
    float frontier_phi_23_19_ladder_1;
    float frontier_phi_23_19_ladder_2;
    if (_739 == 2u) {
#if 1
      float cbuffer_diffuse_white = _26_m0[8u].y;
      float cbuffer_PQ_M1 = _26_m0[8u].x;

      PQFromBT709FinalWithGammaCorrection(_736, _737, _738,
                                          cbuffer_PQ_M1, cbuffer_diffuse_white,
                                          frontier_phi_23_19_ladder, frontier_phi_23_19_ladder_2, frontier_phi_23_19_ladder_1);
#else
      float _847 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _738, mad(0.3292830288410186767578125f, _737, _736 * 0.627403914928436279296875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _848 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _738, mad(0.9195404052734375f, _737, _736 * 0.069097287952899932861328125f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      float _849 = exp2(log2(abs(mad(0.895595252513885498046875f, _738, mad(0.08801330626010894775390625f, _737, _736 * 0.01639143936336040496826171875f)) * _26_m0[8u].y)) * _26_m0[8u].x);
      frontier_phi_23_19_ladder = exp2(log2(abs(((_847 * 18.8515625f) + 0.8359375f) / ((_847 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_23_19_ladder_1 = exp2(log2(abs(((_849 * 18.8515625f) + 0.8359375f) / ((_849 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_23_19_ladder_2 = exp2(log2(abs(((_848 * 18.8515625f) + 0.8359375f) / ((_848 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_23_19_ladder = _736;
      frontier_phi_23_19_ladder_1 = _738;
      frontier_phi_23_19_ladder_2 = _737;
    }
    _877 = frontier_phi_23_19_ladder;
    _879 = frontier_phi_23_19_ladder_2;
    _881 = frontier_phi_23_19_ladder_1;
  }
  float _893 = (_16.Load(int3(uint2(uint(int(gl_FragCoord.x)) & 31u, uint(int(gl_FragCoord.y)) & 31u), 0u)).x + (-0.5f)) * _26_m0[10u].x;
  SV_Target.x = _893 + _877;
  SV_Target.y = _893 + _879;
  SV_Target.z = _893 + _881;
  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
