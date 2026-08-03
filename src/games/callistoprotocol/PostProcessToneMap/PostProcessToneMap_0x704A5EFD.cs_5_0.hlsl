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
Texture2D<float4> t4 : register(t4);
Texture3D<float4> t5 : register(t5);
RWTexture2D<float4> u0 : register(u0);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

float dp2_f32(float2 a, float2 b) {
  precise float _164 = a.x * b.x;
  return mad(a.y, b.y, _164);
}

float dp3_f32(float3 a, float3 b) {
  precise float _149 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _149));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void comp_main() {
  float _184 = float(cb0_m[53u].w);
  float _185 = float(cb0_m[53u].z);
  float _188 = (_184 + float(gl_GlobalInvocationID.y)) + 0.5f;
  float _189 = (_185 + float(gl_GlobalInvocationID.x)) + 0.5f;
  float _194 = asfloat(cb0_m[52u].x);
  float _195 = asfloat(cb0_m[52u].y);
  float _196 = _194 * _189;
  float _197 = _188 * _195;
  if (max(abs(mad(_188, _195, -0.5f)), abs(mad(_194, _189, -0.5f))) >= 0.5f) {
    return;
  }
  float4 _211 = t0.Load(int3(uint2(0u, 0u), 0u));
  float _213 = _211.x;
  float _217 = asfloat(cb0_m[54u].w);
  float _220 = asfloat(cb0_m[55u].x);
  float _221 = _217 * _220;
  float _256 = mad(mad(_196, asfloat(cb0_m[37u].y), -asfloat(cb0_m[39u].x)) / asfloat(cb0_m[38u].z), asfloat(cb0_m[68u].z), asfloat(cb0_m[68u].x));
  float _257 = mad(mad(asfloat(cb0_m[37u].z), _197, -asfloat(cb0_m[39u].y)) / asfloat(cb0_m[38u].w), asfloat(cb0_m[68u].w), asfloat(cb0_m[68u].y));
  float _260 = 1.41421353816986083984375f / sqrt(mad(_221, _221, 1.0f));
  float4 _282 = t1.SampleLevel(s0, float2(_196, _197), 0.0f);
  float _289 = asfloat(cb1_m[135u].z);
  float4 _325 = t2.SampleLevel(s1, float2(clamp(mad(_196, asfloat(cb0_m[58u].z), asfloat(cb0_m[59u].x)), asfloat(cb0_m[50u].z), asfloat(cb0_m[51u].x)), clamp(asfloat(cb0_m[50u].w), mad(asfloat(cb0_m[58u].w), _197, asfloat(cb0_m[59u].y)), asfloat(cb0_m[51u].y))), 0.0f);
  float4 _338 = t4.SampleLevel(s3, float2(mad(_256, 0.5f, 0.5f), mad(_257, -0.5f, 0.5f)), 0.0f);
  float _383 = asfloat(cb0_m[62u].x);
  float2 _386 = float2(((_256 * 1.0f) * _260) * _383, _383 * (_260 * (_221 * _257)));
  float _389 = 1.0f / (dp2_f32(_386, _386) + 1.0f);
  float _390 = _389 * _389;
  float _391 = (_213 * (((_289 * _325.x) * mad(_338.x, asfloat(cb0_m[67u].x), asfloat(cb0_m[61u].x))) + ((_282.x * _289) * asfloat(cb0_m[60u].x)))) * _390;
  float _392 = _390 * (_213 * ((asfloat(cb0_m[60u].y) * (_282.y * _289)) + (mad(_338.y, asfloat(cb0_m[67u].y), asfloat(cb0_m[61u].y)) * (_289 * _325.y))));
  float _393 = _390 * (_213 * ((asfloat(cb0_m[60u].z) * (_282.z * _289)) + (mad(_338.z, asfloat(cb0_m[67u].z), asfloat(cb0_m[61u].z)) * (_289 * _325.z))));
  float _425;
  float _426;
  float _427;
  if (cb0_m[70u].x != 0u) {
    bool _400 = float(cb0_m[70u].x) > 1.0f;
    float _402 = dp3_f32(float3(_391, _392, _393), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
    bool _413 = float(cvt_f32_u32(_188 - _184)) > (_217 - 64.0f);
    float _421 = (1.0f / exp2(max(16.0f - floor((_220 * float(cvt_f32_u32(_189 - _185))) * 17.0f), 0.0f))) * 10.0f;
    _425 = _413 ? _421 : (_400 ? _402 : _393);
    _426 = _413 ? _421 : (_400 ? _402 : _392);
    _427 = _413 ? _421 : (_400 ? _402 : _391);
  } else {
    _425 = _393;
    _426 = _392;
    _427 = _391;
  }
  float _437 = exp2(log2(_427 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _438 = exp2(log2(_426 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _439 = exp2(log2(_425 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float4 _469 = t5.SampleLevel(s4, float3(mad(exp2(log2((1.0f / mad(_437, 18.6875f, 1.0f)) * mad(_437, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_438, 18.6875f, 1.0f)) * mad(_438, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_439, 18.6875f, 1.0f)) * mad(_439, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f)), 0.0f);
  float _470 = _469.x;
  float _471 = _469.y;
  float _472 = _469.z;
  float _479 = mad(frac(sin(mad(mad(_188, _195, asfloat(cb0_m[63u].y)), 543.30999755859375f, mad(_194, _189, asfloat(cb0_m[63u].x)))) * 493013.0f), 0.00390625f, -0.001953125f);
  float _480 = mad(_470, 1.0499999523162841796875f, _479);
  float _481 = mad(_471, 1.0499999523162841796875f, _479);
  float _482 = mad(_472, 1.0499999523162841796875f, _479);
  float _509;
  float _510;
  float _511;
  if (cb0_m[66u].x != 0u) {
    _509 = (_482 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_482) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_482 * 12.9200000762939453125f);
    _510 = (_481 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_481) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_481 * 12.9200000762939453125f);
    _511 = (_480 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_480) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_480 * 12.9200000762939453125f);
  } else {
    _509 = _482;
    _510 = _481;
    _511 = _480;
  }
  float _514 = 1.0f - dp3_f32(float3(_511, _510, _509), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _516 = _514 * _514;
  float _521 = (_514 <= 0.0f) ? 0.110009253025054931640625f : (clamp(_514 * (_516 * _516), 0.19523799419403076171875f, 1.0f) * 0.563462316989898681640625f);
  float _531 = mad(mad(-_511, _521, 1.0f), _511 - 1.0f, 1.0f);
  float _532 = mad(_510 - 1.0f, mad(-_510, _521, 1.0f), 1.0f);
  float _533 = mad(_509 - 1.0f, mad(-_509, _521, 1.0f), 1.0f);
  if (CUSTOM_GRAIN_TYPE == 0.f) {
    float _537 = frac(asfloat(cb1_m[142u].z));
    float _547 = asfloat(cb0_m[65u].y);
    float _553 = dp3_f32(float3(_531, _532, _533), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _554 = 1.0f - _553;
    float _564 = clamp(_553 * 20.0f, 0.0f, 1.0f);
    float _571 = asfloat(cb0_m[65u].z);
    float _588 = mad(((_571 + ((_564 <= 0.0f) ? 0.0f : (exp2(log2(_564) * 0.25f) * (1.0f - _571)))) * ((_554 <= 0.0f) ? 0.0f : exp2(log2(_554) * asfloat(cb0_m[65u].x)))) * asfloat(cb0_m[64u].w), t3.SampleLevel(s2, float2((floor(_537 * 25.0f) * 0.20000000298023223876953125f) + ((mad(mad(_196, 2.0f, -1.0f), 0.5f, 0.5f) / _221) * _547), (mad(mad(_197, 2.0f, -1.0f), -0.5f, 0.5f) * _547) + (floor(_537 * 5.0f) * 0.20000000298023223876953125f)), 0.0f).x - 0.5f, 0.5f);
    float _589 = 1.0f - _588;
    float _593 = _589 + _589;
    float _600 = _588 + _588;
    u0[uint2(gl_GlobalInvocationID.x + cb0_m[53u].z, gl_GlobalInvocationID.y + cb0_m[53u].w)] = float4(max((_531 >= 0.5f) ? mad(-(1.0f - _531), _593, 1.0f) : (_531 * _600), 0.0f), max((_532 >= 0.5f) ? mad(-(1.0f - _532), _593, 1.0f) : (_532 * _600), 0.0f), max((_533 >= 0.5f) ? mad(-(1.0f - _533), _593, 1.0f) : (_533 * _600), 0.0f), clamp(dp3_f32(float3(_470 * 1.0499999523162841796875f, _471 * 1.0499999523162841796875f, _472 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f));
  } else {
    float3 grained_color = ApplyPerceptualFilmGrainBT709(float3(_531, _532, _533), float2(_196, _197), cb0_m[66u].x != 0u);
    u0[uint2(gl_GlobalInvocationID.x + cb0_m[53u].z, gl_GlobalInvocationID.y + cb0_m[53u].w)] = float4(grained_color, clamp(dp3_f32(float3(_470 * 1.0499999523162841796875f, _471 * 1.0499999523162841796875f, _472 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f));
  }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
