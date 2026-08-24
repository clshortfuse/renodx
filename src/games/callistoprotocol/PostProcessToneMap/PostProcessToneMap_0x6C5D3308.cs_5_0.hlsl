#include "./PostProcessToneMap.hlsli"

cbuffer cb0_buf : register(b0) {
  uint4 cb0_m[72] : packoffset(c0);
};

cbuffer cb1_buf : register(b1) {
  uint4 cb1_m[143] : packoffset(c0);
};

SamplerState s0 : register(s0);
SamplerState s1 : register(s1);
SamplerState s2 : register(s2);
SamplerState s3 : register(s3);
SamplerState s4 : register(s4);
Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t4 : register(t4);
Texture3D<float4> t5 : register(t5);
RWTexture2D<float4> u0 : register(u0);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

float dp3_f32(float3 a, float3 b) {
  precise float _180 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _180));
}

float dp2_f32(float2 a, float2 b) {
  precise float _169 = a.x * b.x;
  return mad(a.y, b.y, _169);
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void comp_main() {
  float _203 = float(cb0_m[53u].w);
  float _204 = float(cb0_m[53u].z);
  float _207 = (_203 + float(gl_GlobalInvocationID.y)) + 0.5f;
  float _208 = (_204 + float(gl_GlobalInvocationID.x)) + 0.5f;
  float _213 = asfloat(cb0_m[52u].x);
  float _214 = asfloat(cb0_m[52u].y);
  float _215 = _213 * _208;
  float _216 = _207 * _214;
  if (max(abs(mad(_207, _214, -0.5f)), abs(mad(_213, _208, -0.5f))) >= 0.5f) {
    return;
  }
  float4 _230 = t0.Load(int3(uint2(0u, 0u), 0u));
  float _232 = _230.x;
  float _236 = asfloat(cb0_m[54u].w);
  float _239 = asfloat(cb0_m[55u].x);
  float _240 = _236 * _239;
  float _251 = asfloat(cb0_m[39u].x);
  float _252 = asfloat(cb0_m[39u].y);
  float _261 = asfloat(cb0_m[38u].z);
  float _262 = asfloat(cb0_m[38u].w);
  float _275 = mad(mad(_215, asfloat(cb0_m[37u].y), -_251) / _261, asfloat(cb0_m[68u].z), asfloat(cb0_m[68u].x));
  float _276 = mad(asfloat(cb0_m[68u].w), mad(asfloat(cb0_m[37u].z), _216, -_252) / _262, asfloat(cb0_m[68u].y));
  float _279 = 1.41421353816986083984375f / sqrt(mad(_240, _240, 1.0f));
  float _286 = asfloat(cb0_m[38u].x);
  float _287 = asfloat(cb0_m[38u].y);
  float _301 = frac(sin(mad(mad(_207, _214, asfloat(cb0_m[63u].y)), 543.30999755859375f, mad(_213, _208, asfloat(cb0_m[63u].x)))) * 493013.0f);
  float _307 = mad(-_301, _301, 1.0f) * asfloat(cb0_m[64u].z);
  float _308 = (_286 * (-0.5f)) * _307;
  float _309 = (_287 * 0.5f) * _307;
  float _310 = _215 + _308;
  float _311 = _309 + _216;
  float _330 = asfloat(cb0_m[71u].z);
  float _335 = float(int(((_275 < 0.0f) ? 4294967295u : 0u) + uint(_275 > 0.0f))) * clamp(abs(_275) - _330, 0.0f, 1.0f);
  float _336 = clamp(abs(_276) - _330, 0.0f, 1.0f) * float(int(uint(_276 > 0.0f) + ((_276 < 0.0f) ? 4294967295u : 0u)));
  float _341 = asfloat(cb0_m[71u].x);
  float _342 = asfloat(cb0_m[71u].y);
  float _355 = asfloat(cb0_m[69u].z);
  float _356 = asfloat(cb0_m[69u].w);
  float _359 = asfloat(cb0_m[69u].x);
  float _360 = asfloat(cb0_m[69u].y);
  float _381 = asfloat(cb0_m[43u].z);
  float _382 = asfloat(cb0_m[43u].w);
  float _387 = asfloat(cb0_m[44u].x);
  float _388 = asfloat(cb0_m[44u].y);
  float _413 = asfloat(cb1_m[135u].z);
  float _414 = t1.SampleLevel(s0, float2(clamp(_308 + (_286 * mad(_261, mad(mad(-_335, _341, _275), _355, _359), _251)), _381, _387), clamp(_382, _309 + (_287 * mad(_262, mad(_356, mad(-_341, _336, _276), _360), _252)), _388)), 0.0f).x * _413;
  float _415 = t1.SampleLevel(s0, float2(clamp(_381, _308 + (_286 * mad(_261, mad(_355, mad(-_335, _342, _275), _359), _251)), _387), clamp(_382, _309 + (_287 * mad(_262, mad(_356, mad(-_342, _336, _276), _360), _252)), _388)), 0.0f).y * _413;
  float _416 = t1.SampleLevel(s0, float2(clamp(_310, _381, _387), clamp(_382, _311, _388)), 0.0f).z * _413;
  float _418 = dp3_f32(float3(_414, _415, _416), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
  float2 _419 = float2(_310, _311);
  float4 _421 = t1.SampleLevel(s0, _419, 0.0f, int2(-1, 0));
  float _425 = _413 * _421.x;
  float _426 = _413 * _421.y;
  float _427 = _413 * _421.z;
  float4 _429 = t1.SampleLevel(s0, _419, 0.0f, int2(1, 0));
  float _433 = _413 * _429.x;
  float _434 = _413 * _429.y;
  float _435 = _413 * _429.z;
  float4 _437 = t1.SampleLevel(s0, _419, 0.0f, int2(0, -1));
  float _438 = _437.x;
  float _439 = _437.y;
  float _440 = _437.z;
  float4 _445 = t1.SampleLevel(s0, _419, 0.0f, int2(0, 1));
  float _446 = _445.x;
  float _447 = _445.y;
  float _448 = _445.z;
  float _477 = clamp(mad(-_232, max(max(abs(_418 - dp3_f32(float3(_433, _434, _435), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f))), abs(_418 - dp3_f32(float3(_425, _426, _427), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)))), max(abs(_418 - dp3_f32(float3(_413 * _438, _413 * _439, _413 * _440), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f))), abs(_418 - dp3_f32(float3(_413 * _446, _413 * _447, _413 * _448), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f))))), 1.0f), 0.0f, 1.0f) * asfloat(cb0_m[62u].y);
  float4 _528 = t2.SampleLevel(s1, float2(clamp(mad(_215, asfloat(cb0_m[58u].z), asfloat(cb0_m[59u].x)), asfloat(cb0_m[50u].z), asfloat(cb0_m[51u].x)), clamp(asfloat(cb0_m[50u].w), mad(_216, asfloat(cb0_m[58u].w), asfloat(cb0_m[59u].y)), asfloat(cb0_m[51u].y))), 0.0f);
  float4 _541 = t4.SampleLevel(s3, float2(mad(_275, 0.5f, 0.5f), mad(_276, -0.5f, 0.5f)), 0.0f);
  float _586 = asfloat(cb0_m[62u].x);
  float2 _589 = float2(((_275 * 1.0f) * _279) * _586, (_279 * (_240 * _276)) * _586);
  float _592 = 1.0f / (dp2_f32(_589, _589) + 1.0f);
  float _593 = _592 * _592;
  float _603 = mad(_301, asfloat(cb0_m[64u].x), asfloat(cb0_m[64u].y));
  float _604 = ((_232 * (((_413 * _528.x) * mad(_541.x, asfloat(cb0_m[67u].x), asfloat(cb0_m[61u].x))) + ((_414 - (_477 * mad(_414, -4.0f, mad(_413, _446, mad(_413, _438, _425 + _433))))) * asfloat(cb0_m[60u].x)))) * _593) * _603;
  float _605 = _603 * (_593 * (_232 * ((asfloat(cb0_m[60u].y) * (_415 - (_477 * mad(_415, -4.0f, mad(_413, _447, mad(_413, _439, _434 + _426)))))) + (mad(_541.y, asfloat(cb0_m[67u].y), asfloat(cb0_m[61u].y)) * (_413 * _528.y)))));
  float _606 = _603 * (_593 * (_232 * ((asfloat(cb0_m[60u].z) * (_416 - (_477 * mad(_416, -4.0f, mad(_413, _448, mad(_413, _440, _435 + _427)))))) + (mad(_541.z, asfloat(cb0_m[67u].z), asfloat(cb0_m[61u].z)) * (_413 * _528.z)))));
  float _638;
  float _639;
  float _640;
  if (cb0_m[70u].x != 0u) {
    bool _613 = float(cb0_m[70u].x) > 1.0f;
    float _615 = dp3_f32(float3(_604, _605, _606), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
    bool _626 = float(cvt_f32_u32(_207 - _203)) > (_236 - 64.0f);
    float _634 = (1.0f / exp2(max(16.0f - floor((_239 * float(cvt_f32_u32(_208 - _204))) * 17.0f), 0.0f))) * 10.0f;
    _638 = _626 ? _634 : (_613 ? _615 : _606);
    _639 = _626 ? _634 : (_613 ? _615 : _605);
    _640 = _626 ? _634 : (_613 ? _615 : _604);
  } else {
    _638 = _606;
    _639 = _605;
    _640 = _604;
  }
  float _650 = exp2(log2(_640 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _651 = exp2(log2(_639 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _652 = exp2(log2(_638 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float4 _682 = t5.SampleLevel(s4, float3(mad(exp2(log2((1.0f / mad(_650, 18.6875f, 1.0f)) * mad(_650, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_651, 18.6875f, 1.0f)) * mad(_651, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_652, 18.6875f, 1.0f)) * mad(_652, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f)), 0.0f);
  float _683 = _682.x;
  float _684 = _682.y;
  float _685 = _682.z;
  float _692 = mad(_301, 0.00390625f, -0.001953125f);
  float _693 = mad(_683, 1.0499999523162841796875f, _692);
  float _694 = mad(_684, 1.0499999523162841796875f, _692);
  float _695 = mad(_685, 1.0499999523162841796875f, _692);
  float _722;
  float _723;
  float _724;
  if (cb0_m[66u].x != 0u) {
    _722 = (_695 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_695) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_695 * 12.9200000762939453125f);
    _723 = (_694 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_694) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_694 * 12.9200000762939453125f);
    _724 = (_693 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_693) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_693 * 12.9200000762939453125f);
  } else {
    _722 = _695;
    _723 = _694;
    _724 = _693;
  }
  float _727 = 1.0f - dp3_f32(float3(_724, _723, _722), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _729 = _727 * _727;
  float _734 = (_727 <= 0.0f) ? 0.110009253025054931640625f : (clamp(_727 * (_729 * _729), 0.19523799419403076171875f, 1.0f) * 0.563462316989898681640625f);
  float _744 = mad(mad(-_724, _734, 1.0f), _724 - 1.0f, 1.0f);
  float _745 = mad(_723 - 1.0f, mad(-_723, _734, 1.0f), 1.0f);
  float _746 = mad(_722 - 1.0f, mad(-_722, _734, 1.0f), 1.0f);
  if (CUSTOM_GRAIN_TYPE == 0.f) {
    float _750 = frac(asfloat(cb1_m[142u].z));
    float _760 = asfloat(cb0_m[65u].y);
    float _766 = dp3_f32(float3(_744, _745, _746), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _767 = 1.0f - _766;
    float _777 = clamp(_766 * 20.0f, 0.0f, 1.0f);
    float _784 = asfloat(cb0_m[65u].z);
    float _801 = mad(((_784 + ((_777 <= 0.0f) ? 0.0f : (exp2(log2(_777) * 0.25f) * (1.0f - _784)))) * ((_767 <= 0.0f) ? 0.0f : exp2(log2(_767) * asfloat(cb0_m[65u].x)))) * asfloat(cb0_m[64u].w), t3.SampleLevel(s2, float2((floor(_750 * 25.0f) * 0.20000000298023223876953125f) + ((mad(mad(_215, 2.0f, -1.0f), 0.5f, 0.5f) / _240) * _760), (mad(mad(_216, 2.0f, -1.0f), -0.5f, 0.5f) * _760) + (floor(_750 * 5.0f) * 0.20000000298023223876953125f)), 0.0f).x - 0.5f, 0.5f);
    float _802 = 1.0f - _801;
    float _806 = _802 + _802;
    float _813 = _801 + _801;
    u0[uint2(gl_GlobalInvocationID.x + cb0_m[53u].z, gl_GlobalInvocationID.y + cb0_m[53u].w)] = float4(max((_744 >= 0.5f) ? mad(-(1.0f - _744), _806, 1.0f) : (_744 * _813), 0.0f), max((_745 >= 0.5f) ? mad(-(1.0f - _745), _806, 1.0f) : (_745 * _813), 0.0f), max((_746 >= 0.5f) ? mad(-(1.0f - _746), _806, 1.0f) : (_746 * _813), 0.0f), clamp(dp3_f32(float3(_683 * 1.0499999523162841796875f, _684 * 1.0499999523162841796875f, _685 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f));
  } else {
    float3 grained_color = ApplyPerceptualFilmGrainBT709(float3(_744, _745, _746), float2(_215, _216), cb0_m[66u].x != 0u);
    u0[uint2(gl_GlobalInvocationID.x + cb0_m[53u].z, gl_GlobalInvocationID.y + cb0_m[53u].w)] = float4(grained_color, clamp(dp3_f32(float3(_683 * 1.0499999523162841796875f, _684 * 1.0499999523162841796875f, _685 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f));
  }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
