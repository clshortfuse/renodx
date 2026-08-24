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
  precise float _172 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _172));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

float dp2_f32(float2 a, float2 b) {
  precise float _151 = a.x * b.x;
  return mad(a.y, b.y, _151);
}

void frag_main() {
  float _190 = frac(sin(mad(TEXCOORD2.w, 543.30999755859375f, TEXCOORD2.z)) * 493013.0f);
  float _198 = mad(-_190, _190, 1.0f) * asfloat(cb0_m[64u].z);
  float _207 = TEXCOORD2.x - TEXCOORD.x;
  float _208 = TEXCOORD2.y - TEXCOORD.y;
  float _209 = _198 * _207;
  float _210 = _198 * _208;
  float _211 = mad(_198, _207, TEXCOORD.x);
  float _212 = mad(_198, _208, TEXCOORD.y);
  float _228 = mad(TEXCOORD3.x, asfloat(cb0_m[68u].z), asfloat(cb0_m[68u].x));
  float _229 = mad(TEXCOORD3.y, asfloat(cb0_m[68u].w), asfloat(cb0_m[68u].y));
  float _249 = asfloat(cb0_m[71u].z);
  float _254 = float(int(((_228 < 0.0f) ? 4294967295u : 0u) + uint(_228 > 0.0f))) * clamp(abs(_228) - _249, 0.0f, 1.0f);
  float _255 = clamp(abs(_229) - _249, 0.0f, 1.0f) * float(int(((_229 < 0.0f) ? 4294967295u : 0u) + uint(_229 > 0.0f)));
  float _260 = asfloat(cb0_m[71u].x);
  float _261 = asfloat(cb0_m[71u].y);
  float _274 = asfloat(cb0_m[69u].z);
  float _275 = asfloat(cb0_m[69u].w);
  float _278 = asfloat(cb0_m[69u].x);
  float _279 = asfloat(cb0_m[69u].y);
  float _288 = asfloat(cb0_m[38u].z);
  float _289 = asfloat(cb0_m[38u].w);
  float _294 = asfloat(cb0_m[39u].x);
  float _295 = asfloat(cb0_m[39u].y);
  float _302 = asfloat(cb0_m[38u].x);
  float _303 = asfloat(cb0_m[38u].y);
  float _316 = asfloat(cb0_m[43u].z);
  float _317 = asfloat(cb0_m[43u].w);
  float _322 = asfloat(cb0_m[44u].x);
  float _323 = asfloat(cb0_m[44u].y);
  float _348 = asfloat(cb1_m[135u].z);
  float _349 = t0.Sample(s0, float2(clamp(_209 + (mad(mad(mad(-_254, _260, _228), _274, _278), _288, _294) * _302), _316, _322), clamp(_317, _210 + (_303 * mad(_289, mad(_275, mad(-_260, _255, _229), _279), _295)), _323))).x * _348;
  float _350 = t0.Sample(s0, float2(clamp(_316, _209 + (_302 * mad(_288, mad(_274, mad(-_254, _261, _228), _278), _294)), _322), clamp(_317, _210 + (_303 * mad(_289, mad(_275, mad(-_261, _255, _229), _279), _295)), _323))).y * _348;
  float _351 = t0.Sample(s0, float2(clamp(_211, _316, _322), clamp(_212, _317, _323))).z * _348;
  float _353 = dp3_f32(float3(_349, _350, _351), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
  float _370 = mad(float(cvt_f32_u32(floor(_211 * asfloat(cb0_m[37u].y))) & 1u), 2.0f, -1.0f);
  float _371 = mad(float(cvt_f32_u32(floor(_212 * asfloat(cb0_m[37u].z))) & 1u), 2.0f, -1.0f);
  float4 _379 = t0.Sample(s0, float2(mad(asfloat(cb0_m[38u].x), _370, _211), _212 + 0.0f));
  float _380 = _379.x;
  float _381 = _379.y;
  float _382 = _379.z;
  float4 _390 = t0.Sample(s0, float2(mad(_302, 0.0f, _211), mad(_303, _371, _212)));
  float _391 = _390.x;
  float _392 = _390.y;
  float _393 = _390.z;
  float _444 = clamp(mad(-max(max(abs(_353 - dp3_f32(float3(_348 * _391, _348 * _392, _348 * _393), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f))), abs(_353 - dp3_f32(float3(_348 * _380, _348 * _381, _348 * _382), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)))), max(abs(_353 + mad(ddx_fine(_353), _370, -_353)), abs(_353 + mad(ddy_fine(_353), _371, -_353)))), TEXCOORD1.x, 1.0f), 0.0f, 1.0f) * asfloat(cb0_m[62u].y);
  float4 _495 = t1.Sample(s1, float2(clamp(mad(TEXCOORD.x, asfloat(cb0_m[58u].z), asfloat(cb0_m[59u].x)), asfloat(cb0_m[50u].z), asfloat(cb0_m[51u].x)), clamp(asfloat(cb0_m[50u].w), mad(TEXCOORD.y, asfloat(cb0_m[58u].w), asfloat(cb0_m[59u].y)), asfloat(cb0_m[51u].y))));
  float4 _508 = t3.Sample(s3, float2(mad(_228, 0.5f, 0.5f), mad(_229, -0.5f, 0.5f)));
  float _557 = asfloat(cb0_m[62u].x);
  float2 _560 = float2(TEXCOORD1.y * _557, TEXCOORD1.z * _557);
  float _563 = 1.0f / (dp2_f32(_560, _560) + 1.0f);
  float _564 = _563 * _563;
  float _574 = mad(_190, asfloat(cb0_m[64u].x), asfloat(cb0_m[64u].y));
  float _575 = ((TEXCOORD1.x * (((_348 * _495.x) * mad(_508.x, asfloat(cb0_m[67u].x), asfloat(cb0_m[61u].x))) + ((_349 - (mad(_349, -4.0f, (_349 - (ddy_fine(_349) * _371)) + mad(_348, _391, mad(_348, _380, _349 - (ddx_fine(_349) * _370)))) * _444)) * asfloat(cb0_m[60u].x)))) * _564) * _574;
  float _576 = _574 * (_564 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].y) * (_350 - (_444 * mad(_350, -4.0f, mad(_348, _392, mad(_348, _381, _350 - (ddx_fine(_350) * _370))) + (_350 - (ddy_fine(_350) * _371)))))) + (mad(_508.y, asfloat(cb0_m[67u].y), asfloat(cb0_m[61u].y)) * (_348 * _495.y)))));
  float _577 = _574 * (_564 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].z) * (_351 - (_444 * mad(_351, -4.0f, mad(_348, _393, mad(_348, _382, _351 - (ddx_fine(_351) * _370))) + (_351 - (ddy_fine(_351) * _371)))))) + (mad(_508.z, asfloat(cb0_m[67u].z), asfloat(cb0_m[61u].z)) * (_348 * _495.z)))));
  float _625;
  float _626;
  float _627;
  if (cb0_m[70u].x != 0u) {
    bool _584 = float(cb0_m[70u].x) > 1.0f;
    float _586 = dp3_f32(float3(_575, _576, _577), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
    bool _610 = float(cvt_f32_u32(gl_FragCoord.y - float(cb0_m[53u].w))) > (asfloat(cb0_m[54u].w) - 64.0f);
    float _621 = (1.0f / exp2(max(16.0f - floor((asfloat(cb0_m[55u].x) * float(cvt_f32_u32(gl_FragCoord.x - float(cb0_m[53u].z)))) * 17.0f), 0.0f))) * 10.0f;
    _625 = _610 ? _621 : (_584 ? _586 : _577);
    _626 = _610 ? _621 : (_584 ? _586 : _576);
    _627 = _610 ? _621 : (_584 ? _586 : _575);
  } else {
    _625 = _577;
    _626 = _576;
    _627 = _575;
  }
  float _637 = exp2(log2(_627 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _638 = exp2(log2(_626 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _639 = exp2(log2(_625 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float4 _669 = t4.Sample(s4, float3(mad(exp2(log2((1.0f / mad(_637, 18.6875f, 1.0f)) * mad(_637, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_638, 18.6875f, 1.0f)) * mad(_638, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_639, 18.6875f, 1.0f)) * mad(_639, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f)));
  float _670 = _669.x;
  float _671 = _669.y;
  float _672 = _669.z;
  SV_Target.w = clamp(dp3_f32(float3(_670 * 1.0499999523162841796875f, _671 * 1.0499999523162841796875f, _672 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f);
  float _681 = mad(_190, 0.00390625f, -0.001953125f);
  float _682 = mad(_670, 1.0499999523162841796875f, _681);
  float _683 = mad(_671, 1.0499999523162841796875f, _681);
  float _684 = mad(_672, 1.0499999523162841796875f, _681);
  float _711;
  float _712;
  float _713;
  if (cb0_m[66u].x != 0u) {
    _711 = (_684 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_684) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_684 * 12.9200000762939453125f);
    _712 = (_683 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_683) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_683 * 12.9200000762939453125f);
    _713 = (_682 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_682) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_682 * 12.9200000762939453125f);
  } else {
    _711 = _684;
    _712 = _683;
    _713 = _682;
  }
  float _716 = 1.0f - dp3_f32(float3(_713, _712, _711), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _718 = _716 * _716;
  float _723 = (_716 <= 0.0f) ? 0.110009253025054931640625f : (clamp(_716 * (_718 * _718), 0.19523799419403076171875f, 1.0f) * 0.563462316989898681640625f);
  float _733 = mad(mad(-_723, _713, 1.0f), _713 - 1.0f, 1.0f);
  float _734 = mad(_712 - 1.0f, mad(-_723, _712, 1.0f), 1.0f);
  float _735 = mad(_711 - 1.0f, mad(-_723, _711, 1.0f), 1.0f);
  if (CUSTOM_GRAIN_TYPE == 0.f) {
    float _746 = frac(asfloat(cb1_m[142u].z));
    float _760 = asfloat(cb0_m[65u].y);
    float _766 = dp3_f32(float3(_733, _734, _735), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _767 = 1.0f - _766;
    float _777 = clamp(_766 * 20.0f, 0.0f, 1.0f);
    float _784 = asfloat(cb0_m[65u].z);
    float _801 = mad(((_784 + ((_777 <= 0.0f) ? 0.0f : (exp2(log2(_777) * 0.25f) * (1.0f - _784)))) * ((_767 <= 0.0f) ? 0.0f : exp2(log2(_767) * asfloat(cb0_m[65u].x)))) * asfloat(cb0_m[64u].w), t2.Sample(s2, float2((floor(_746 * 25.0f) * 0.20000000298023223876953125f) + ((TEXCOORD4.x / (asfloat(cb0_m[54u].w) * asfloat(cb0_m[55u].x))) * _760), (TEXCOORD4.y * _760) + (floor(_746 * 5.0f) * 0.20000000298023223876953125f))).x - 0.5f, 0.5f);
    float _802 = 1.0f - _801;
    float _806 = _802 + _802;
    float _813 = _801 + _801;
    SV_Target.x = max((_733 >= 0.5f) ? mad(-(1.0f - _733), _806, 1.0f) : (_733 * _813), 0.0f);
    SV_Target.y = max((_734 >= 0.5f) ? mad(-(1.0f - _734), _806, 1.0f) : (_734 * _813), 0.0f);
    SV_Target.z = max((_735 >= 0.5f) ? mad(-(1.0f - _735), _806, 1.0f) : (_735 * _813), 0.0f);
  } else {
    SV_Target.rgb = ApplyPerceptualFilmGrainBT709(float3(_733, _734, _735), TEXCOORD.xy, cb0_m[66u].x != 0u);
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
