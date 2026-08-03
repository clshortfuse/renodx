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

float dp2_f32(float2 a, float2 b) {
  precise float _167 = a.x * b.x;
  return mad(a.y, b.y, _167);
}

float dp3_f32(float3 a, float3 b) {
  precise float _152 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _152));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void comp_main() {
  float _187 = float(cb0_m[53u].w);
  float _188 = float(cb0_m[53u].z);
  float _191 = (_187 + float(gl_GlobalInvocationID.y)) + 0.5f;
  float _192 = (_188 + float(gl_GlobalInvocationID.x)) + 0.5f;
  float _197 = asfloat(cb0_m[52u].x);
  float _198 = asfloat(cb0_m[52u].y);
  float _199 = _197 * _192;
  float _200 = _191 * _198;
  if (max(abs(mad(_191, _198, -0.5f)), abs(mad(_197, _192, -0.5f))) >= 0.5f) {
    return;
  }
  float4 _214 = t0.Load(int3(uint2(0u, 0u), 0u));
  float _216 = _214.x;
  float _220 = asfloat(cb0_m[54u].w);
  float _223 = asfloat(cb0_m[55u].x);
  float _224 = _220 * _223;
  float _235 = asfloat(cb0_m[39u].x);
  float _236 = asfloat(cb0_m[39u].y);
  float _245 = asfloat(cb0_m[38u].z);
  float _246 = asfloat(cb0_m[38u].w);
  float _259 = mad(mad(_199, asfloat(cb0_m[37u].y), -_235) / _245, asfloat(cb0_m[68u].z), asfloat(cb0_m[68u].x));
  float _260 = mad(mad(asfloat(cb0_m[37u].z), _200, -_236) / _246, asfloat(cb0_m[68u].w), asfloat(cb0_m[68u].y));
  float _263 = 1.41421353816986083984375f / sqrt(mad(_224, _224, 1.0f));
  float _299 = asfloat(cb0_m[71u].z);
  float _304 = float(int(((_259 < 0.0f) ? 4294967295u : 0u) + uint(_259 > 0.0f))) * clamp(abs(_259) - _299, 0.0f, 1.0f);
  float _305 = clamp(abs(_260) - _299, 0.0f, 1.0f) * float(int(uint(_260 > 0.0f) + ((_260 < 0.0f) ? 4294967295u : 0u)));
  float _310 = asfloat(cb0_m[71u].x);
  float _311 = asfloat(cb0_m[71u].y);
  float _324 = asfloat(cb0_m[69u].z);
  float _325 = asfloat(cb0_m[69u].w);
  float _328 = asfloat(cb0_m[69u].x);
  float _329 = asfloat(cb0_m[69u].y);
  float _340 = asfloat(cb0_m[38u].x);
  float _341 = asfloat(cb0_m[38u].y);
  float _364 = asfloat(cb1_m[135u].z);
  float4 _400 = t2.SampleLevel(s1, float2(clamp(mad(_199, asfloat(cb0_m[58u].z), asfloat(cb0_m[59u].x)), asfloat(cb0_m[50u].z), asfloat(cb0_m[51u].x)), clamp(asfloat(cb0_m[50u].w), mad(asfloat(cb0_m[58u].w), _200, asfloat(cb0_m[59u].y)), asfloat(cb0_m[51u].y))), 0.0f);
  float4 _413 = t4.SampleLevel(s3, float2(mad(_259, 0.5f, 0.5f), mad(_260, -0.5f, 0.5f)), 0.0f);
  float _458 = asfloat(cb0_m[62u].x);
  float2 _461 = float2(((_259 * 1.0f) * _263) * _458, _458 * (_263 * (_260 * _224)));
  float _464 = 1.0f / (dp2_f32(_461, _461) + 1.0f);
  float _465 = _464 * _464;
  float _466 = (_216 * (((_364 * _400.x) * mad(_413.x, asfloat(cb0_m[67u].x), asfloat(cb0_m[61u].x))) + ((t1.SampleLevel(s0, float2(mad(_245, mad(mad(-_304, _310, _259), _324, _328), _235) * _340, _341 * mad(_246, mad(_325, mad(-_310, _305, _260), _329), _236)), 0.0f).x * _364) * asfloat(cb0_m[60u].x)))) * _465;
  float _467 = _465 * (_216 * ((asfloat(cb0_m[60u].y) * (t1.SampleLevel(s0, float2(_340 * mad(_245, mad(_324, mad(-_304, _311, _259), _328), _235), _341 * mad(_246, mad(_325, mad(-_311, _305, _260), _329), _236)), 0.0f).y * _364)) + (mad(_413.y, asfloat(cb0_m[67u].y), asfloat(cb0_m[61u].y)) * (_364 * _400.y))));
  float _468 = _465 * (_216 * ((asfloat(cb0_m[60u].z) * (t1.SampleLevel(s0, float2(_199, _200), 0.0f).z * _364)) + (mad(_413.z, asfloat(cb0_m[67u].z), asfloat(cb0_m[61u].z)) * (_364 * _400.z))));
  float _500;
  float _501;
  float _502;
  if (cb0_m[70u].x != 0u) {
    bool _475 = float(cb0_m[70u].x) > 1.0f;
    float _477 = dp3_f32(float3(_466, _467, _468), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
    bool _488 = float(cvt_f32_u32(_191 - _187)) > (_220 - 64.0f);
    float _496 = (1.0f / exp2(max(16.0f - floor((_223 * float(cvt_f32_u32(_192 - _188))) * 17.0f), 0.0f))) * 10.0f;
    _500 = _488 ? _496 : (_475 ? _477 : _468);
    _501 = _488 ? _496 : (_475 ? _477 : _467);
    _502 = _488 ? _496 : (_475 ? _477 : _466);
  } else {
    _500 = _468;
    _501 = _467;
    _502 = _466;
  }
  float _512 = exp2(log2(_502 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _513 = exp2(log2(_501 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _514 = exp2(log2(_500 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float4 _544 = t5.SampleLevel(s4, float3(mad(exp2(log2((1.0f / mad(_512, 18.6875f, 1.0f)) * mad(_512, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_513, 18.6875f, 1.0f)) * mad(_513, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_514, 18.6875f, 1.0f)) * mad(_514, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f)), 0.0f);
  float _545 = _544.x;
  float _546 = _544.y;
  float _547 = _544.z;
  float _554 = mad(frac(sin(mad(mad(_191, _198, asfloat(cb0_m[63u].y)), 543.30999755859375f, mad(_197, _192, asfloat(cb0_m[63u].x)))) * 493013.0f), 0.00390625f, -0.001953125f);
  float _555 = mad(_545, 1.0499999523162841796875f, _554);
  float _556 = mad(_546, 1.0499999523162841796875f, _554);
  float _557 = mad(_547, 1.0499999523162841796875f, _554);
  float _584;
  float _585;
  float _586;
  if (cb0_m[66u].x != 0u) {
    _584 = (_557 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_557) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_557 * 12.9200000762939453125f);
    _585 = (_556 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_556) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_556 * 12.9200000762939453125f);
    _586 = (_555 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_555) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_555 * 12.9200000762939453125f);
  } else {
    _584 = _557;
    _585 = _556;
    _586 = _555;
  }
  float _589 = 1.0f - dp3_f32(float3(_586, _585, _584), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _591 = _589 * _589;
  float _596 = (_589 <= 0.0f) ? 0.110009253025054931640625f : (clamp(_589 * (_591 * _591), 0.19523799419403076171875f, 1.0f) * 0.563462316989898681640625f);
  float _606 = mad(mad(-_586, _596, 1.0f), _586 - 1.0f, 1.0f);
  float _607 = mad(_585 - 1.0f, mad(-_585, _596, 1.0f), 1.0f);
  float _608 = mad(_584 - 1.0f, mad(-_584, _596, 1.0f), 1.0f);
  if (CUSTOM_GRAIN_TYPE == 0.f) {
    float _612 = frac(asfloat(cb1_m[142u].z));
    float _622 = asfloat(cb0_m[65u].y);
    float _628 = dp3_f32(float3(_606, _607, _608), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _629 = 1.0f - _628;
    float _639 = clamp(_628 * 20.0f, 0.0f, 1.0f);
    float _646 = asfloat(cb0_m[65u].z);
    float _663 = mad(((_646 + ((_639 <= 0.0f) ? 0.0f : (exp2(log2(_639) * 0.25f) * (1.0f - _646)))) * ((_629 <= 0.0f) ? 0.0f : exp2(log2(_629) * asfloat(cb0_m[65u].x)))) * asfloat(cb0_m[64u].w), t3.SampleLevel(s2, float2((floor(_612 * 25.0f) * 0.20000000298023223876953125f) + ((mad(mad(_199, 2.0f, -1.0f), 0.5f, 0.5f) / _224) * _622), (mad(mad(_200, 2.0f, -1.0f), -0.5f, 0.5f) * _622) + (floor(_612 * 5.0f) * 0.20000000298023223876953125f)), 0.0f).x - 0.5f, 0.5f);
    float _664 = 1.0f - _663;
    float _668 = _664 + _664;
    float _675 = _663 + _663;
    u0[uint2(gl_GlobalInvocationID.x + cb0_m[53u].z, gl_GlobalInvocationID.y + cb0_m[53u].w)] = float4(max((_606 >= 0.5f) ? mad(-(1.0f - _606), _668, 1.0f) : (_606 * _675), 0.0f), max((_607 >= 0.5f) ? mad(-(1.0f - _607), _668, 1.0f) : (_607 * _675), 0.0f), max((_608 >= 0.5f) ? mad(-(1.0f - _608), _668, 1.0f) : (_608 * _675), 0.0f), clamp(dp3_f32(float3(_545 * 1.0499999523162841796875f, _546 * 1.0499999523162841796875f, _547 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f));
  } else {
    float3 grained_color = ApplyPerceptualFilmGrainBT709(float3(_606, _607, _608), float2(_199, _200), cb0_m[66u].x != 0u);
    u0[uint2(gl_GlobalInvocationID.x + cb0_m[53u].z, gl_GlobalInvocationID.y + cb0_m[53u].w)] = float4(grained_color, clamp(dp3_f32(float3(_545 * 1.0499999523162841796875f, _546 * 1.0499999523162841796875f, _547 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f));
  }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
