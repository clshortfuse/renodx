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
Texture3D<float4> t4 : register(t4);
RWTexture2D<float4> u0 : register(u0);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

float dp2_f32(float2 a, float2 b) {
  precise float _166 = a.x * b.x;
  return mad(a.y, b.y, _166);
}

float dp3_f32(float3 a, float3 b) {
  precise float _151 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _151));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void comp_main() {
  float _186 = float(cb0_m[53u].w);
  float _187 = float(cb0_m[53u].z);
  float _190 = (_186 + float(gl_GlobalInvocationID.y)) + 0.5f;
  float _191 = (_187 + float(gl_GlobalInvocationID.x)) + 0.5f;
  float _196 = asfloat(cb0_m[52u].x);
  float _197 = asfloat(cb0_m[52u].y);
  float _198 = _196 * _191;
  float _199 = _190 * _197;
  if (max(abs(mad(_190, _197, -0.5f)), abs(mad(_196, _191, -0.5f))) >= 0.5f) {
    return;
  }
  float _215 = asfloat(cb0_m[54u].w);
  float _218 = asfloat(cb0_m[55u].x);
  float _219 = _215 * _218;
  float _230 = asfloat(cb0_m[39u].x);
  float _231 = asfloat(cb0_m[39u].y);
  float _240 = asfloat(cb0_m[38u].z);
  float _241 = asfloat(cb0_m[38u].w);
  float _254 = mad(mad(_198, asfloat(cb0_m[37u].y), -_230) / _240, asfloat(cb0_m[68u].z), asfloat(cb0_m[68u].x));
  float _255 = mad(mad(asfloat(cb0_m[37u].z), _199, -_231) / _241, asfloat(cb0_m[68u].w), asfloat(cb0_m[68u].y));
  float _258 = 1.41421353816986083984375f / sqrt(mad(_219, _219, 1.0f));
  float _294 = asfloat(cb0_m[71u].z);
  float _299 = float(int(((_254 < 0.0f) ? 4294967295u : 0u) + uint(_254 > 0.0f))) * clamp(abs(_254) - _294, 0.0f, 1.0f);
  float _300 = clamp(abs(_255) - _294, 0.0f, 1.0f) * float(int(uint(_255 > 0.0f) + ((_255 < 0.0f) ? 4294967295u : 0u)));
  float _305 = asfloat(cb0_m[71u].x);
  float _306 = asfloat(cb0_m[71u].y);
  float _319 = asfloat(cb0_m[69u].z);
  float _320 = asfloat(cb0_m[69u].w);
  float _323 = asfloat(cb0_m[69u].x);
  float _324 = asfloat(cb0_m[69u].y);
  float _335 = asfloat(cb0_m[38u].x);
  float _336 = asfloat(cb0_m[38u].y);
  float _360 = asfloat(cb1_m[135u].z);
  float4 _396 = t1.SampleLevel(s1, float2(clamp(mad(_198, asfloat(cb0_m[58u].z), asfloat(cb0_m[59u].x)), asfloat(cb0_m[50u].z), asfloat(cb0_m[51u].x)), clamp(asfloat(cb0_m[50u].w), mad(asfloat(cb0_m[58u].w), _199, asfloat(cb0_m[59u].y)), asfloat(cb0_m[51u].y))), 0.0f);
  float4 _409 = t3.SampleLevel(s3, float2(mad(_254, 0.5f, 0.5f), mad(_255, -0.5f, 0.5f)), 0.0f);
  float _451 = asfloat(cb0_m[66u].y);
  float _457 = asfloat(cb0_m[62u].x);
  float2 _460 = float2(((_254 * 1.0f) * _258) * _457, _457 * (_258 * (_219 * _255)));
  float _463 = 1.0f / (dp2_f32(_460, _460) + 1.0f);
  float _464 = _463 * _463;
  float _465 = ((((_360 * _396.x) * mad(_409.x, asfloat(cb0_m[67u].x), asfloat(cb0_m[61u].x))) + ((t0.SampleLevel(s0, float2(mad(_240, mad(mad(-_299, _305, _254), _319, _323), _230) * _335, _336 * mad(_241, mad(_320, mad(-_305, _300, _255), _324), _231)), 0.0f).x * _360) * asfloat(cb0_m[60u].x))) * _451) * _464;
  float _466 = _464 * (_451 * ((asfloat(cb0_m[60u].y) * (t0.SampleLevel(s0, float2(_335 * mad(_240, mad(_319, mad(-_299, _306, _254), _323), _230), _336 * mad(_241, mad(_320, mad(-_306, _300, _255), _324), _231)), 0.0f).y * _360)) + (mad(_409.y, asfloat(cb0_m[67u].y), asfloat(cb0_m[61u].y)) * (_360 * _396.y))));
  float _467 = _464 * (_451 * ((asfloat(cb0_m[60u].z) * (t0.SampleLevel(s0, float2(_198, _199), 0.0f).z * _360)) + (mad(_409.z, asfloat(cb0_m[67u].z), asfloat(cb0_m[61u].z)) * (_360 * _396.z))));
  float _499;
  float _500;
  float _501;
  if (cb0_m[70u].x != 0u) {
    bool _474 = float(cb0_m[70u].x) > 1.0f;
    float _476 = dp3_f32(float3(_465, _466, _467), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
    bool _487 = float(cvt_f32_u32(_190 - _186)) > (_215 - 64.0f);
    float _495 = (1.0f / exp2(max(16.0f - floor((_218 * float(cvt_f32_u32(_191 - _187))) * 17.0f), 0.0f))) * 10.0f;
    _499 = _487 ? _495 : (_474 ? _476 : _467);
    _500 = _487 ? _495 : (_474 ? _476 : _466);
    _501 = _487 ? _495 : (_474 ? _476 : _465);
  } else {
    _499 = _467;
    _500 = _466;
    _501 = _465;
  }
  float _511 = exp2(log2(_501 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _512 = exp2(log2(_500 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _513 = exp2(log2(_499 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float4 _543 = t4.SampleLevel(s4, float3(mad(exp2(log2((1.0f / mad(_511, 18.6875f, 1.0f)) * mad(_511, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_512, 18.6875f, 1.0f)) * mad(_512, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_513, 18.6875f, 1.0f)) * mad(_513, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f)), 0.0f);
  float _544 = _543.x;
  float _545 = _543.y;
  float _546 = _543.z;
  float _553 = mad(frac(sin(mad(mad(_190, _197, asfloat(cb0_m[63u].y)), 543.30999755859375f, mad(_196, _191, asfloat(cb0_m[63u].x)))) * 493013.0f), 0.00390625f, -0.001953125f);
  float _554 = mad(_544, 1.0499999523162841796875f, _553);
  float _555 = mad(_545, 1.0499999523162841796875f, _553);
  float _556 = mad(_546, 1.0499999523162841796875f, _553);
  float _583;
  float _584;
  float _585;
  if (cb0_m[66u].x != 0u) {
    _583 = (_556 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_556) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_556 * 12.9200000762939453125f);
    _584 = (_555 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_555) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_555 * 12.9200000762939453125f);
    _585 = (_554 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_554) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_554 * 12.9200000762939453125f);
  } else {
    _583 = _556;
    _584 = _555;
    _585 = _554;
  }
  float _588 = 1.0f - dp3_f32(float3(_585, _584, _583), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _590 = _588 * _588;
  float _595 = (_588 <= 0.0f) ? 0.110009253025054931640625f : (clamp(_588 * (_590 * _590), 0.19523799419403076171875f, 1.0f) * 0.563462316989898681640625f);
  float _605 = mad(mad(-_585, _595, 1.0f), _585 - 1.0f, 1.0f);
  float _606 = mad(_584 - 1.0f, mad(-_584, _595, 1.0f), 1.0f);
  float _607 = mad(_583 - 1.0f, mad(-_583, _595, 1.0f), 1.0f);
  if (CUSTOM_GRAIN_TYPE == 0.f) {
    float _611 = frac(asfloat(cb1_m[142u].z));
    float _621 = asfloat(cb0_m[65u].y);
    float _627 = dp3_f32(float3(_605, _606, _607), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _628 = 1.0f - _627;
    float _638 = clamp(_627 * 20.0f, 0.0f, 1.0f);
    float _645 = asfloat(cb0_m[65u].z);
    float _662 = mad(((_645 + ((_638 <= 0.0f) ? 0.0f : (exp2(log2(_638) * 0.25f) * (1.0f - _645)))) * ((_628 <= 0.0f) ? 0.0f : exp2(log2(_628) * asfloat(cb0_m[65u].x)))) * asfloat(cb0_m[64u].w), t2.SampleLevel(s2, float2((floor(_611 * 25.0f) * 0.20000000298023223876953125f) + ((mad(mad(_198, 2.0f, -1.0f), 0.5f, 0.5f) / _219) * _621), (mad(mad(_199, 2.0f, -1.0f), -0.5f, 0.5f) * _621) + (floor(_611 * 5.0f) * 0.20000000298023223876953125f)), 0.0f).x - 0.5f, 0.5f);
    float _663 = 1.0f - _662;
    float _667 = _663 + _663;
    float _674 = _662 + _662;
    u0[uint2(gl_GlobalInvocationID.x + cb0_m[53u].z, gl_GlobalInvocationID.y + cb0_m[53u].w)] = float4(max((_605 >= 0.5f) ? mad(-(1.0f - _605), _667, 1.0f) : (_605 * _674), 0.0f), max((_606 >= 0.5f) ? mad(-(1.0f - _606), _667, 1.0f) : (_606 * _674), 0.0f), max((_607 >= 0.5f) ? mad(-(1.0f - _607), _667, 1.0f) : (_607 * _674), 0.0f), clamp(dp3_f32(float3(_544 * 1.0499999523162841796875f, _545 * 1.0499999523162841796875f, _546 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f));
  } else {
    float3 grained_color = ApplyPerceptualFilmGrainBT709(float3(_605, _606, _607), float2(_198, _199), cb0_m[66u].x != 0u);
    u0[uint2(gl_GlobalInvocationID.x + cb0_m[53u].z, gl_GlobalInvocationID.y + cb0_m[53u].w)] = float4(grained_color, clamp(dp3_f32(float3(_544 * 1.0499999523162841796875f, _545 * 1.0499999523162841796875f, _546 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f));
  }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
