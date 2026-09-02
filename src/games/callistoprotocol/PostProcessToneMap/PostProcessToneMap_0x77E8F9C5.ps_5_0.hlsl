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

static float4 gl_FragCoord;
static float2 TEXCOORD;
static float2 TEXCOORD3;
static float3 TEXCOORD1;
static float4 TEXCOORD2;
static float2 TEXCOORD4;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  noperspective float2 TEXCOORD : TEXCOORD0;
  noperspective float2 TEXCOORD3 : TEXCOORD3;
  noperspective float3 TEXCOORD1 : TEXCOORD1;
  noperspective float4 TEXCOORD2 : TEXCOORD2;
  noperspective float2 TEXCOORD4 : TEXCOORD4;
  float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

float dp3_f32(float3 a, float3 b) {
  precise float _160 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _160));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void frag_main() {
  float _178 = frac(sin(mad(TEXCOORD2.w, 543.30999755859375f, TEXCOORD2.z)) * 493013.0f);
  float _186 = mad(-_178, _178, 1.0f) * asfloat(cb0_m[64u].z);
  float _195 = TEXCOORD2.x - TEXCOORD.x;
  float _196 = TEXCOORD2.y - TEXCOORD.y;
  float _197 = _186 * _195;
  float _198 = _186 * _196;
  float _199 = mad(_186, _195, TEXCOORD.x);
  float _200 = mad(_186, _196, TEXCOORD.y);
  float _216 = mad(TEXCOORD3.x, asfloat(cb0_m[68u].z), asfloat(cb0_m[68u].x));
  float _217 = mad(TEXCOORD3.y, asfloat(cb0_m[68u].w), asfloat(cb0_m[68u].y));
  float _237 = asfloat(cb0_m[71u].z);
  float _242 = float(int(((_216 < 0.0f) ? 4294967295u : 0u) + uint(_216 > 0.0f))) * clamp(abs(_216) - _237, 0.0f, 1.0f);
  float _243 = clamp(abs(_217) - _237, 0.0f, 1.0f) * float(int(((_217 < 0.0f) ? 4294967295u : 0u) + uint(_217 > 0.0f)));
  float _248 = asfloat(cb0_m[71u].x);
  float _249 = asfloat(cb0_m[71u].y);
  float _262 = asfloat(cb0_m[69u].z);
  float _263 = asfloat(cb0_m[69u].w);
  float _266 = asfloat(cb0_m[69u].x);
  float _267 = asfloat(cb0_m[69u].y);
  float _276 = asfloat(cb0_m[38u].z);
  float _277 = asfloat(cb0_m[38u].w);
  float _282 = asfloat(cb0_m[39u].x);
  float _283 = asfloat(cb0_m[39u].y);
  float _290 = asfloat(cb0_m[38u].x);
  float _291 = asfloat(cb0_m[38u].y);
  float _304 = asfloat(cb0_m[43u].z);
  float _305 = asfloat(cb0_m[43u].w);
  float _310 = asfloat(cb0_m[44u].x);
  float _311 = asfloat(cb0_m[44u].y);
  float _336 = asfloat(cb1_m[135u].z);
  float _337 = t0.Sample(s0, float2(clamp(_197 + (mad(mad(mad(-_242, _248, _216), _262, _266), _276, _282) * _290), _304, _310), clamp(_305, _198 + (_291 * mad(_277, mad(_263, mad(-_248, _243, _217), _267), _283)), _311))).x * _336;
  float _338 = t0.Sample(s0, float2(clamp(_304, _197 + (_290 * mad(_276, mad(_262, mad(-_242, _249, _216), _266), _282)), _310), clamp(_305, _198 + (_291 * mad(_277, mad(_263, mad(-_249, _243, _217), _267), _283)), _311))).y * _336;
  float _339 = t0.Sample(s0, float2(clamp(_199, _304, _310), clamp(_200, _305, _311))).z * _336;
  float _341 = dp3_f32(float3(_337, _338, _339), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
  float _358 = mad(float(cvt_f32_u32(floor(_199 * asfloat(cb0_m[37u].y))) & 1u), 2.0f, -1.0f);
  float _359 = mad(float(cvt_f32_u32(floor(_200 * asfloat(cb0_m[37u].z))) & 1u), 2.0f, -1.0f);
  float4 _367 = t0.Sample(s0, float2(mad(asfloat(cb0_m[38u].x), _358, _199), _200 + 0.0f));
  float _368 = _367.x;
  float _369 = _367.y;
  float _370 = _367.z;
  float4 _378 = t0.Sample(s0, float2(mad(_290, 0.0f, _199), mad(_291, _359, _200)));
  float _379 = _378.x;
  float _380 = _378.y;
  float _381 = _378.z;
  float _432 = clamp(mad(-max(max(abs(_341 - dp3_f32(float3(_336 * _379, _336 * _380, _336 * _381), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f))), abs(_341 - dp3_f32(float3(_336 * _368, _336 * _369, _336 * _370), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)))), max(abs(_341 + mad(ddx_fine(_341), _358, -_341)), abs(_341 + mad(ddy_fine(_341), _359, -_341)))), TEXCOORD1.x, 1.0f), 0.0f, 1.0f) * asfloat(cb0_m[62u].y);
  float4 _483 = t1.Sample(s1, float2(clamp(mad(TEXCOORD.x, asfloat(cb0_m[58u].z), asfloat(cb0_m[59u].x)), asfloat(cb0_m[50u].z), asfloat(cb0_m[51u].x)), clamp(asfloat(cb0_m[50u].w), mad(TEXCOORD.y, asfloat(cb0_m[58u].w), asfloat(cb0_m[59u].y)), asfloat(cb0_m[51u].y))));
  float4 _496 = t3.Sample(s3, float2(mad(_216, 0.5f, 0.5f), mad(_217, -0.5f, 0.5f)));
  float _545 = mad(_178, asfloat(cb0_m[64u].x), asfloat(cb0_m[64u].y));
  float _546 = (TEXCOORD1.x * (((_336 * _483.x) * mad(_496.x, asfloat(cb0_m[67u].x), asfloat(cb0_m[61u].x))) + ((_337 - (mad(_337, -4.0f, (_337 - (ddy_fine(_337) * _359)) + mad(_336, _379, mad(_336, _368, _337 - (ddx_fine(_337) * _358)))) * _432)) * asfloat(cb0_m[60u].x)))) * _545;
  float _547 = _545 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].y) * (_338 - (_432 * mad(_338, -4.0f, mad(_336, _380, mad(_336, _369, _338 - (ddx_fine(_338) * _358))) + (_338 - (ddy_fine(_338) * _359)))))) + (mad(_496.y, asfloat(cb0_m[67u].y), asfloat(cb0_m[61u].y)) * (_336 * _483.y))));
  float _548 = _545 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].z) * (_339 - (_432 * mad(_339, -4.0f, mad(_336, _381, mad(_336, _370, _339 - (ddx_fine(_339) * _358))) + (_339 - (ddy_fine(_339) * _359)))))) + (mad(_496.z, asfloat(cb0_m[67u].z), asfloat(cb0_m[61u].z)) * (_336 * _483.z))));
  float _596;
  float _597;
  float _598;
  if (cb0_m[70u].x != 0u) {
    bool _555 = float(cb0_m[70u].x) > 1.0f;
    float _557 = dp3_f32(float3(_546, _547, _548), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
    bool _581 = float(cvt_f32_u32(gl_FragCoord.y - float(cb0_m[53u].w))) > (asfloat(cb0_m[54u].w) - 64.0f);
    float _592 = (1.0f / exp2(max(16.0f - floor((asfloat(cb0_m[55u].x) * float(cvt_f32_u32(gl_FragCoord.x - float(cb0_m[53u].z)))) * 17.0f), 0.0f))) * 10.0f;
    _596 = _581 ? _592 : (_555 ? _557 : _548);
    _597 = _581 ? _592 : (_555 ? _557 : _547);
    _598 = _581 ? _592 : (_555 ? _557 : _546);
  } else {
    _596 = _548;
    _597 = _547;
    _598 = _546;
  }
  float _608 = exp2(log2(_598 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _609 = exp2(log2(_597 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _610 = exp2(log2(_596 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float4 _640 = t4.Sample(s4, float3(mad(exp2(log2((1.0f / mad(_608, 18.6875f, 1.0f)) * mad(_608, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_609, 18.6875f, 1.0f)) * mad(_609, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_610, 18.6875f, 1.0f)) * mad(_610, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f)));
  float _641 = _640.x;
  float _642 = _640.y;
  float _643 = _640.z;
  SV_Target.w = clamp(dp3_f32(float3(_641 * 1.0499999523162841796875f, _642 * 1.0499999523162841796875f, _643 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f);
  float _652 = mad(_178, 0.00390625f, -0.001953125f);
  float _653 = mad(_641, 1.0499999523162841796875f, _652);
  float _654 = mad(_642, 1.0499999523162841796875f, _652);
  float _655 = mad(_643, 1.0499999523162841796875f, _652);
  float _682;
  float _683;
  float _684;
  if (cb0_m[66u].x != 0u) {
    _682 = (_655 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_655) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_655 * 12.9200000762939453125f);
    _683 = (_654 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_654) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_654 * 12.9200000762939453125f);
    _684 = (_653 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_653) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_653 * 12.9200000762939453125f);
  } else {
    _682 = _655;
    _683 = _654;
    _684 = _653;
  }
  float _687 = 1.0f - dp3_f32(float3(_684, _683, _682), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _689 = _687 * _687;
  float _694 = (_687 <= 0.0f) ? 0.110009253025054931640625f : (clamp(_687 * (_689 * _689), 0.19523799419403076171875f, 1.0f) * 0.563462316989898681640625f);
  float _704 = mad(mad(-_694, _684, 1.0f), _684 - 1.0f, 1.0f);
  float _705 = mad(_683 - 1.0f, mad(-_694, _683, 1.0f), 1.0f);
  float _706 = mad(_682 - 1.0f, mad(-_694, _682, 1.0f), 1.0f);
  if (CUSTOM_GRAIN_TYPE == 0.f) {
    float _717 = frac(asfloat(cb1_m[142u].z));
    float _731 = asfloat(cb0_m[65u].y);
    float _737 = dp3_f32(float3(_704, _705, _706), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _738 = 1.0f - _737;
    float _748 = clamp(_737 * 20.0f, 0.0f, 1.0f);
    float _755 = asfloat(cb0_m[65u].z);
    float _772 = mad(((_755 + ((_748 <= 0.0f) ? 0.0f : (exp2(log2(_748) * 0.25f) * (1.0f - _755)))) * ((_738 <= 0.0f) ? 0.0f : exp2(log2(_738) * asfloat(cb0_m[65u].x)))) * asfloat(cb0_m[64u].w), t2.Sample(s2, float2((floor(_717 * 25.0f) * 0.20000000298023223876953125f) + ((TEXCOORD4.x / (asfloat(cb0_m[54u].w) * asfloat(cb0_m[55u].x))) * _731), (TEXCOORD4.y * _731) + (floor(_717 * 5.0f) * 0.20000000298023223876953125f))).x - 0.5f, 0.5f);
    float _773 = 1.0f - _772;
    float _777 = _773 + _773;
    float _784 = _772 + _772;
    SV_Target.x = max((_704 >= 0.5f) ? mad(-(1.0f - _704), _777, 1.0f) : (_704 * _784), 0.0f);
    SV_Target.y = max((_705 >= 0.5f) ? mad(-(1.0f - _705), _777, 1.0f) : (_705 * _784), 0.0f);
    SV_Target.z = max((_706 >= 0.5f) ? mad(-(1.0f - _706), _777, 1.0f) : (_706 * _784), 0.0f);
  } else {
    SV_Target.rgb = ApplyPerceptualFilmGrainBT709(float3(_704, _705, _706), TEXCOORD.xy, cb0_m[66u].x != 0u);
  }
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  TEXCOORD = stage_input.TEXCOORD;
  TEXCOORD3 = stage_input.TEXCOORD3;
  TEXCOORD1 = stage_input.TEXCOORD1;
  TEXCOORD2 = stage_input.TEXCOORD2;
  TEXCOORD4 = stage_input.TEXCOORD4;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
