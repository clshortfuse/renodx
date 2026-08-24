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

float dp2_f32(float2 a, float2 b) {
  precise float _164 = a.x * b.x;
  return mad(a.y, b.y, _164);
}

float dp3_f32(float3 a, float3 b) {
  precise float _150 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _150));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void frag_main() {
  float _196 = mad(TEXCOORD3.x, asfloat(cb0_m[68u].z), asfloat(cb0_m[68u].x));
  float _197 = mad(TEXCOORD3.y, asfloat(cb0_m[68u].w), asfloat(cb0_m[68u].y));
  float _218 = asfloat(cb0_m[71u].z);
  float _223 = float(int(((_196 < 0.0f) ? 4294967295u : 0u) + uint(_196 > 0.0f))) * clamp(abs(_196) - _218, 0.0f, 1.0f);
  float _224 = clamp(abs(_197) - _218, 0.0f, 1.0f) * float(int(uint(_197 > 0.0f) + ((_197 < 0.0f) ? 4294967295u : 0u)));
  float _229 = asfloat(cb0_m[71u].x);
  float _230 = asfloat(cb0_m[71u].y);
  float _243 = asfloat(cb0_m[69u].z);
  float _244 = asfloat(cb0_m[69u].w);
  float _247 = asfloat(cb0_m[69u].x);
  float _248 = asfloat(cb0_m[69u].y);
  float _257 = asfloat(cb0_m[38u].z);
  float _258 = asfloat(cb0_m[38u].w);
  float _263 = asfloat(cb0_m[39u].x);
  float _264 = asfloat(cb0_m[39u].y);
  float _271 = asfloat(cb0_m[38u].x);
  float _272 = asfloat(cb0_m[38u].y);
  float _299 = asfloat(cb1_m[135u].z);
  float4 _335 = t1.Sample(s1, float2(clamp(mad(TEXCOORD.x, asfloat(cb0_m[58u].z), asfloat(cb0_m[59u].x)), asfloat(cb0_m[50u].z), asfloat(cb0_m[51u].x)), clamp(asfloat(cb0_m[50u].w), mad(TEXCOORD.y, asfloat(cb0_m[58u].w), asfloat(cb0_m[59u].y)), asfloat(cb0_m[51u].y))));
  float4 _348 = t3.Sample(s3, float2(mad(_196, 0.5f, 0.5f), mad(_197, -0.5f, 0.5f)));
  float _399 = asfloat(cb0_m[62u].x);
  float2 _402 = float2(TEXCOORD1.y * _399, TEXCOORD1.z * _399);
  float _405 = 1.0f / (dp2_f32(_402, _402) + 1.0f);
  float _406 = _405 * _405;
  float _407 = ((((_299 * _335.x) * mad(_348.x, asfloat(cb0_m[67u].x), asfloat(cb0_m[61u].x))) + ((t0.Sample(s0, float2(mad(mad(mad(-_223, _229, _196), _243, _247), _257, _263) * _271, _272 * mad(_258, mad(_244, mad(-_229, _224, _197), _248), _264))).x * _299) * asfloat(cb0_m[60u].x))) * TEXCOORD1.x) * _406;
  float _408 = _406 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].y) * (t0.Sample(s0, float2(_271 * mad(_257, mad(_243, mad(-_223, _230, _196), _247), _263), _272 * mad(_258, mad(_244, mad(-_230, _224, _197), _248), _264))).y * _299)) + (mad(_348.y, asfloat(cb0_m[67u].y), asfloat(cb0_m[61u].y)) * (_299 * _335.y))));
  float _409 = _406 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].z) * (t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y)).z * _299)) + (mad(_348.z, asfloat(cb0_m[67u].z), asfloat(cb0_m[61u].z)) * (_299 * _335.z))));
  float _457;
  float _458;
  float _459;
  if (cb0_m[70u].x != 0u) {
    bool _416 = float(cb0_m[70u].x) > 1.0f;
    float _418 = dp3_f32(float3(_407, _408, _409), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
    bool _442 = float(cvt_f32_u32(gl_FragCoord.y - float(cb0_m[53u].w))) > (asfloat(cb0_m[54u].w) - 64.0f);
    float _453 = (1.0f / exp2(max(16.0f - floor((asfloat(cb0_m[55u].x) * float(cvt_f32_u32(gl_FragCoord.x - float(cb0_m[53u].z)))) * 17.0f), 0.0f))) * 10.0f;
    _457 = _442 ? _453 : (_416 ? _418 : _409);
    _458 = _442 ? _453 : (_416 ? _418 : _408);
    _459 = _442 ? _453 : (_416 ? _418 : _407);
  } else {
    _457 = _409;
    _458 = _408;
    _459 = _407;
  }
  float _469 = exp2(log2(_459 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _470 = exp2(log2(_458 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _471 = exp2(log2(_457 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float4 _501 = t4.Sample(s4, float3(mad(exp2(log2((1.0f / mad(_469, 18.6875f, 1.0f)) * mad(_469, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_470, 18.6875f, 1.0f)) * mad(_470, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_471, 18.6875f, 1.0f)) * mad(_471, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f)));
  float _502 = _501.x;
  float _503 = _501.y;
  float _504 = _501.z;
  SV_Target.w = clamp(dp3_f32(float3(_502 * 1.0499999523162841796875f, _503 * 1.0499999523162841796875f, _504 * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.0f, 1.0f);
  float _513 = mad(frac(sin(mad(TEXCOORD2.w, 543.30999755859375f, TEXCOORD2.z)) * 493013.0f), 0.00390625f, -0.001953125f);
  float _514 = mad(_502, 1.0499999523162841796875f, _513);
  float _515 = mad(_503, 1.0499999523162841796875f, _513);
  float _516 = mad(_504, 1.0499999523162841796875f, _513);
  float _543;
  float _544;
  float _545;
  if (cb0_m[66u].x != 0u) {
    _543 = (_516 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_516) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_516 * 12.9200000762939453125f);
    _544 = (_515 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_515) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_515 * 12.9200000762939453125f);
    _545 = (_514 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_514) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_514 * 12.9200000762939453125f);
  } else {
    _543 = _516;
    _544 = _515;
    _545 = _514;
  }
  float _548 = 1.0f - dp3_f32(float3(_545, _544, _543), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _550 = _548 * _548;
  float _555 = (_548 <= 0.0f) ? 0.110009253025054931640625f : (clamp(_548 * (_550 * _550), 0.19523799419403076171875f, 1.0f) * 0.563462316989898681640625f);
  float _565 = mad(mad(-_555, _545, 1.0f), _545 - 1.0f, 1.0f);
  float _566 = mad(_544 - 1.0f, mad(-_555, _544, 1.0f), 1.0f);
  float _567 = mad(_543 - 1.0f, mad(-_555, _543, 1.0f), 1.0f);
  if (CUSTOM_GRAIN_TYPE == 0.f) {
    float _578 = frac(asfloat(cb1_m[142u].z));
    float _592 = asfloat(cb0_m[65u].y);
    float _598 = dp3_f32(float3(_565, _566, _567), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _599 = 1.0f - _598;
    float _609 = clamp(_598 * 20.0f, 0.0f, 1.0f);
    float _616 = asfloat(cb0_m[65u].z);
    float _633 = mad(((_616 + ((_609 <= 0.0f) ? 0.0f : (exp2(log2(_609) * 0.25f) * (1.0f - _616)))) * ((_599 <= 0.0f) ? 0.0f : exp2(log2(_599) * asfloat(cb0_m[65u].x)))) * asfloat(cb0_m[64u].w), t2.Sample(s2, float2((floor(_578 * 25.0f) * 0.20000000298023223876953125f) + ((TEXCOORD4.x / (asfloat(cb0_m[54u].w) * asfloat(cb0_m[55u].x))) * _592), (TEXCOORD4.y * _592) + (floor(_578 * 5.0f) * 0.20000000298023223876953125f))).x - 0.5f, 0.5f);
    float _634 = 1.0f - _633;
    float _638 = _634 + _634;
    float _645 = _633 + _633;
    SV_Target.x = max((_565 >= 0.5f) ? mad(-(1.0f - _565), _638, 1.0f) : (_565 * _645), 0.0f);
    SV_Target.y = max((_566 >= 0.5f) ? mad(-(1.0f - _566), _638, 1.0f) : (_566 * _645), 0.0f);
    SV_Target.z = max((_567 >= 0.5f) ? mad(-(1.0f - _567), _638, 1.0f) : (_567 * _645), 0.0f);
  } else {
    SV_Target.rgb = ApplyPerceptualFilmGrainBT709(float3(_565, _566, _567), TEXCOORD.xy, cb0_m[66u].x != 0u);
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
