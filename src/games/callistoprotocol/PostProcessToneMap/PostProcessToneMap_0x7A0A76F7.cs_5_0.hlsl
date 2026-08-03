#include "./PostProcessToneMap.hlsli"

cbuffer cb0_buf : register(b0) {
  uint4 cb0_m[71] : packoffset(c0);
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
Texture3D<float4> t4 : register(t4);
RWTexture2D<float4> u0 : register(u0);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

float dp2_f32(float2 a, float2 b) {
  precise float _163 = a.x * b.x;
  return mad(a.y, b.y, _163);
}

float dp3_f32(float3 a, float3 b) {
  precise float _148 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _148));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void comp_main() {
  float _183 = float(cb0_m[53u].w);
  float _184 = float(cb0_m[53u].z);
  float _187 = (_183 + float(gl_GlobalInvocationID.y)) + 0.5f;
  float _188 = (_184 + float(gl_GlobalInvocationID.x)) + 0.5f;
  float _193 = asfloat(cb0_m[52u].x);
  float _194 = asfloat(cb0_m[52u].y);
  float _195 = _193 * _188;
  float _196 = _187 * _194;
  if (max(abs(mad(_187, _194, -0.5f)), abs(mad(_193, _188, -0.5f))) >= 0.5f) {
    return;
  }
  float _212 = asfloat(cb0_m[54u].w);
  float _215 = asfloat(cb0_m[55u].x);
  float _216 = _212 * _215;
  float _251 = mad(mad(_195, asfloat(cb0_m[37u].y), -asfloat(cb0_m[39u].x)) / asfloat(cb0_m[38u].z), asfloat(cb0_m[68u].z), asfloat(cb0_m[68u].x));
  float _252 = mad(asfloat(cb0_m[68u].w), mad(asfloat(cb0_m[37u].z), _196, -asfloat(cb0_m[39u].y)) / asfloat(cb0_m[38u].w), asfloat(cb0_m[68u].y));
  float _255 = 1.41421353816986083984375f / sqrt(mad(_216, _216, 1.0f));
  float4 _277 = t0.SampleLevel(s0, float2(_195, _196), 0.0f);
  float _285 = asfloat(cb1_m[135u].z);
  float4 _321 = t1.SampleLevel(s1, float2(clamp(mad(_195, asfloat(cb0_m[58u].z), asfloat(cb0_m[59u].x)), asfloat(cb0_m[50u].z), asfloat(cb0_m[51u].x)), clamp(asfloat(cb0_m[50u].w), mad(asfloat(cb0_m[58u].w), _196, asfloat(cb0_m[59u].y)), asfloat(cb0_m[51u].y))), 0.0f);
  float4 _334 = t3.SampleLevel(s3, float2(mad(_251, 0.5f, 0.5f), mad(_252, -0.5f, 0.5f)), 0.0f);
  float _376 = asfloat(cb0_m[66u].y);
  float _382 = asfloat(cb0_m[62u].x);
  float2 _385 = float2(((_251 * 1.0f) * _255) * _382, _382 * (_255 * (_216 * _252)));
  float _388 = 1.0f / (dp2_f32(_385, _385) + 1.0f);
  float _389 = _388 * _388;
  float _390 = ((((_285 * _321.x) * mad(_334.x, asfloat(cb0_m[67u].x), asfloat(cb0_m[61u].x))) + ((_277.x * _285) * asfloat(cb0_m[60u].x))) * _376) * _389;
  float _391 = _389 * (_376 * ((asfloat(cb0_m[60u].y) * (_277.y * _285)) + (mad(_334.y, asfloat(cb0_m[67u].y), asfloat(cb0_m[61u].y)) * (_285 * _321.y))));
  float _392 = _389 * (_376 * ((asfloat(cb0_m[60u].z) * (_277.z * _285)) + (mad(_334.z, asfloat(cb0_m[67u].z), asfloat(cb0_m[61u].z)) * (_285 * _321.z))));
  float _424;
  float _425;
  float _426;
  if (cb0_m[70u].x != 0u) {
    bool _399 = float(cb0_m[70u].x) > 1.0f;
    float _401 = dp3_f32(float3(_390, _391, _392), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
    bool _412 = float(cvt_f32_u32(_187 - _183)) > (_212 - 64.0f);
    float _420 = (1.0f / exp2(max(16.0f - floor((_215 * float(cvt_f32_u32(_188 - _184))) * 17.0f), 0.0f))) * 10.0f;
    _424 = _412 ? _420 : (_399 ? _401 : _392);
    _425 = _412 ? _420 : (_399 ? _401 : _391);
    _426 = _412 ? _420 : (_399 ? _401 : _390);
  } else {
    _424 = _392;
    _425 = _391;
    _426 = _390;
  }
  float _436 = exp2(log2(_426 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _437 = exp2(log2(_425 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _438 = exp2(log2(_424 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float4 _468 = t4.SampleLevel(s4, float3(mad(exp2(log2((1.0f / mad(_436, 18.6875f, 1.0f)) * mad(_436, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_437, 18.6875f, 1.0f)) * mad(_437, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_438, 18.6875f, 1.0f)) * mad(_438, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f)), 0.0f);
  float _469 = _468.x;
  float _470 = _468.y;
  float _471 = _468.z;
  float _478 = mad(frac(sin(mad(mad(_187, _194, asfloat(cb0_m[63u].y)), 543.30999755859375f, mad(_193, _188, asfloat(cb0_m[63u].x)))) * 493013.0f), 0.00390625f, -0.001953125f);
  float _479 = mad(_469, 1.0499999523162841796875f, _478);
  float _480 = mad(_470, 1.0499999523162841796875f, _478);
  float _481 = mad(_471, 1.0499999523162841796875f, _478);
  float _508;
  float _509;
  float _510;
  if (cb0_m[66u].x != 0u) {
    _508 = (_481 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_481) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_481 * 12.9200000762939453125f);
    _509 = (_480 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_480) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_480 * 12.9200000762939453125f);
    _510 = (_479 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_479) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_479 * 12.9200000762939453125f);
  } else {
    _508 = _481;
    _509 = _480;
    _510 = _479;
  }
  float _513 = 1.0f - dp3_f32(float3(_510, _509, _508), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _515 = _513 * _513;
  float _520 = (_513 <= 0.0f) ? 0.110009253025054931640625f : (clamp(_513 * (_515 * _515), 0.19523799419403076171875f, 1.0f) * 0.563462316989898681640625f);
  float _530 = mad(mad(-_510, _520, 1.0f), _510 - 1.0f, 1.0f);
  float _531 = mad(_509 - 1.0f, mad(-_509, _520, 1.0f), 1.0f);
  float _532 = mad(_508 - 1.0f, mad(-_508, _520, 1.0f), 1.0f);
  if (CUSTOM_GRAIN_TYPE == 0.f) {
    float _536 = frac(asfloat(cb1_m[142u].z));
    float _546 = asfloat(cb0_m[65u].y);
    float _552 = dp3_f32(float3(_530, _531, _532), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _553 = 1.0f - _552;
    float _563 = clamp(_552 * 20.0f, 0.0f, 1.0f);
    float _570 = asfloat(cb0_m[65u].z);
    float _587 = mad(((_570 + ((_563 <= 0.0f) ? 0.0f : (exp2(log2(_563) * 0.25f) * (1.0f - _570)))) * ((_553 <= 0.0f) ? 0.0f : exp2(log2(_553) * asfloat(cb0_m[65u].x)))) * asfloat(cb0_m[64u].w), t2.SampleLevel(s2, float2((floor(_536 * 25.0f) * 0.20000000298023223876953125f) + ((mad(mad(_195, 2.0f, -1.0f), 0.5f, 0.5f) / _216) * _546), (mad(mad(_196, 2.0f, -1.0f), -0.5f, 0.5f) * _546) + (floor(_536 * 5.0f) * 0.20000000298023223876953125f)), 0.0f).x - 0.5f, 0.5f);
    float _588 = 1.0f - _587;
    float _592 = _588 + _588;
    float _599 = _587 + _587;
    u0[uint2(gl_GlobalInvocationID.x + cb0_m[53u].z, gl_GlobalInvocationID.y + cb0_m[53u].w)] = float4(max((_530 >= 0.5f) ? mad(-(1.0f - _530), _592, 1.0f) : (_530 * _599), 0.0f), max((_531 >= 0.5f) ? mad(-(1.0f - _531), _592, 1.0f) : (_531 * _599), 0.0f), max((_532 >= 0.5f) ? mad(-(1.0f - _532), _592, 1.0f) : (_532 * _599), 0.0f), clamp(dp3_f32(float3(_469 * 1.0499999523162841796875f, _470 * 1.0499999523162841796875f, _471 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f));
  } else {
    float3 grained_color = ApplyPerceptualFilmGrainBT709(float3(_530, _531, _532), float2(_195, _196), cb0_m[66u].x != 0u);
    u0[uint2(gl_GlobalInvocationID.x + cb0_m[53u].z, gl_GlobalInvocationID.y + cb0_m[53u].w)] = float4(grained_color, clamp(dp3_f32(float3(_469 * 1.0499999523162841796875f, _470 * 1.0499999523162841796875f, _471 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f));
  }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
