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

float dp2_f32(float2 a, float2 b) {
  precise float _159 = a.x * b.x;
  return mad(a.y, b.y, _159);
}

float dp3_f32(float3 a, float3 b) {
  precise float _145 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _145));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void frag_main() {
  float4 _184 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  float _192 = asfloat(cb1_m[135u].z);
  float4 _230 = t1.Sample(s1, float2(clamp(mad(TEXCOORD.x, asfloat(cb0_m[58u].z), asfloat(cb0_m[59u].x)), asfloat(cb0_m[50u].z), asfloat(cb0_m[51u].x)), clamp(asfloat(cb0_m[50u].w), mad(TEXCOORD.y, asfloat(cb0_m[58u].w), asfloat(cb0_m[59u].y)), asfloat(cb0_m[51u].y))));
  float4 _259 = t3.Sample(s3, float2(mad(mad(TEXCOORD3.x, asfloat(cb0_m[68u].z), asfloat(cb0_m[68u].x)), 0.5f, 0.5f), mad(mad(TEXCOORD3.y, asfloat(cb0_m[68u].w), asfloat(cb0_m[68u].y)), -0.5f, 0.5f)));
  float _310 = asfloat(cb0_m[62u].x);
  float2 _313 = float2(TEXCOORD1.y * _310, TEXCOORD1.z * _310);
  float _316 = 1.0f / (dp2_f32(_313, _313) + 1.0f);
  float _317 = _316 * _316;
  float _318 = ((((_192 * _230.x) * mad(_259.x, asfloat(cb0_m[67u].x), asfloat(cb0_m[61u].x))) + (asfloat(cb0_m[60u].x) * (_184.x * _192))) * TEXCOORD1.x) * _317;
  float _319 = _317 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].y) * (_184.y * _192)) + ((_192 * _230.y) * mad(_259.y, asfloat(cb0_m[67u].y), asfloat(cb0_m[61u].y)))));
  float _320 = _317 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].z) * (_184.z * _192)) + ((_192 * _230.z) * mad(_259.z, asfloat(cb0_m[67u].z), asfloat(cb0_m[61u].z)))));
  float _368;
  float _369;
  float _370;
  if (cb0_m[70u].x != 0u) {
    bool _327 = float(cb0_m[70u].x) > 1.0f;
    float _329 = dp3_f32(float3(_318, _319, _320), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
    bool _353 = float(cvt_f32_u32(gl_FragCoord.y - float(cb0_m[53u].w))) > (asfloat(cb0_m[54u].w) - 64.0f);
    float _364 = (1.0f / exp2(max(16.0f - floor((asfloat(cb0_m[55u].x) * float(cvt_f32_u32(gl_FragCoord.x - float(cb0_m[53u].z)))) * 17.0f), 0.0f))) * 10.0f;
    _368 = _353 ? _364 : (_327 ? _329 : _320);
    _369 = _353 ? _364 : (_327 ? _329 : _319);
    _370 = _353 ? _364 : (_327 ? _329 : _318);
  } else {
    _368 = _320;
    _369 = _319;
    _370 = _318;
  }
  float _380 = exp2(log2(_370 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _381 = exp2(log2(_369 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _382 = exp2(log2(_368 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float4 _412 = t4.Sample(s4, float3(mad(exp2(log2((1.0f / mad(_380, 18.6875f, 1.0f)) * mad(_380, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_381, 18.6875f, 1.0f)) * mad(_381, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_382, 18.6875f, 1.0f)) * mad(_382, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f)));
  float _413 = _412.x;
  float _414 = _412.y;
  float _415 = _412.z;
  SV_Target.w = clamp(dp3_f32(float3(_413 * 1.0499999523162841796875f, _414 * 1.0499999523162841796875f, _415 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f);
  float _424 = mad(frac(sin(mad(TEXCOORD2.w, 543.30999755859375f, TEXCOORD2.z)) * 493013.0f), 0.00390625f, -0.001953125f);
  float _425 = mad(_413, 1.0499999523162841796875f, _424);
  float _426 = mad(_414, 1.0499999523162841796875f, _424);
  float _427 = mad(_415, 1.0499999523162841796875f, _424);
  float _454;
  float _455;
  float _456;
  if (cb0_m[66u].x != 0u) {
    _454 = (_427 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_427) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_427 * 12.9200000762939453125f);
    _455 = (_426 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_426) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_426 * 12.9200000762939453125f);
    _456 = (_425 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_425) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_425 * 12.9200000762939453125f);
  } else {
    _454 = _427;
    _455 = _426;
    _456 = _425;
  }
  float _459 = 1.0f - dp3_f32(float3(_456, _455, _454), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _461 = _459 * _459;
  float _466 = (_459 <= 0.0f) ? 0.110009253025054931640625f : (clamp(_459 * (_461 * _461), 0.19523799419403076171875f, 1.0f) * 0.563462316989898681640625f);
  float _476 = mad(mad(-_466, _456, 1.0f), _456 - 1.0f, 1.0f);
  float _477 = mad(_455 - 1.0f, mad(-_466, _455, 1.0f), 1.0f);
  float _478 = mad(_454 - 1.0f, mad(-_466, _454, 1.0f), 1.0f);
  if (CUSTOM_GRAIN_TYPE == 0.f) {
    float _489 = frac(asfloat(cb1_m[142u].z));
    float _503 = asfloat(cb0_m[65u].y);
    float _509 = dp3_f32(float3(_476, _477, _478), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _510 = 1.0f - _509;
    float _519 = clamp(_509 * 20.0f, 0.0f, 1.0f);
    float _526 = asfloat(cb0_m[65u].z);
    float _544 = mad(t2.Sample(s2, float2((floor(_489 * 25.0f) * 0.20000000298023223876953125f) + ((TEXCOORD4.x / (asfloat(cb0_m[54u].w) * asfloat(cb0_m[55u].x))) * _503), (TEXCOORD4.y * _503) + (floor(_489 * 5.0f) * 0.20000000298023223876953125f))).x - 0.5f, (_510 <= 0.0f) ? 0.0f : ((exp2(log2(_510) * asfloat(cb0_m[65u].x)) * (_526 + ((_519 <= 0.0f) ? 0.0f : (exp2(log2(_519) * 0.25f) * (1.0f - _526))))) * asfloat(cb0_m[64u].w)), 0.5f);
    float _545 = 1.0f - _544;
    float _549 = _545 + _545;
    float _556 = _544 + _544;
    SV_Target.x = max((_476 >= 0.5f) ? mad(-(1.0f - _476), _549, 1.0f) : (_476 * _556), 0.0f);
    SV_Target.y = max((_477 >= 0.5f) ? mad(-(1.0f - _477), _549, 1.0f) : (_477 * _556), 0.0f);
    SV_Target.z = max((_478 >= 0.5f) ? mad(-(1.0f - _478), _549, 1.0f) : (_478 * _556), 0.0f);
  } else {
    SV_Target.rgb = ApplyPerceptualFilmGrainBT709(float3(_476, _477, _478), TEXCOORD.xy, cb0_m[66u].x != 0u);
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
