#include "../common.hlsli"

cbuffer CB0_buf : register(b17, space0) {
  uint4 CB0_m0 : packoffset(c0);
  uint4 CB0_m1 : packoffset(c1);
  uint3 CB0_m2 : packoffset(c2);
  float CB0_m3 : packoffset(c2.w);
  uint4 CB0_m4 : packoffset(c3);
  uint4 CB0_m5 : packoffset(c4);
  uint4 CB0_m6 : packoffset(c5);
  uint4 CB0_m7 : packoffset(c6);
  uint4 CB0_m8 : packoffset(c7);
  float4 CB0_m9 : packoffset(c8);
};

cbuffer CB1_buf : register(b18, space0) {
  float2 CB1_m0 : packoffset(c0);
  uint2 CB1_m1 : packoffset(c0.z);
  uint4 CB1_m2 : packoffset(c1);
  float4 CB1_m3 : packoffset(c2);
  float4 CB1_m4 : packoffset(c3);
  uint4 CB1_m5 : packoffset(c4);
};

ByteAddressBuffer T0 : register(t3, space0);
SamplerState S0 : register(s0, space0);
SamplerState S1 : register(s2, space0);
Texture2DArray<float4> T1 : register(t27, space0);
Texture2D<float4> T2 : register(t91, space0);
Texture3D<float4> T3 : register(t111, space0);

static float4 gl_FragCoord;
static float4 COLOR;
static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position0;
  float4 COLOR : COLOR0;
  float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

float dp3_f32(float3 a, float3 b) {
  precise float _101 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _101));
}

void frag_main() {
  float4 _131 = T2.SampleLevel(S0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _132 = _131.x;
  float _133 = _131.y;
  float _134 = _131.z;
  bool _144 = (CB1_m1.y != 0u) && (CB1_m1.x == 0u);
  float _163 = 1.0f / CB1_m4.x;
  float _173 = 0.003130800090730190277099609375f / CB1_m3.w;
  float _180 = _144 ? _132 : ((_132 < _173) ? (_132 / CB1_m3.w) : exp2(log2((_132 + CB1_m4.z) / CB1_m4.y) * _163));
  float _181 = _144 ? _133 : ((_133 < _173) ? (_133 / CB1_m3.w) : exp2(log2((_133 + CB1_m4.z) / CB1_m4.y) * _163));
  float _182 = _144 ? _134 : ((_134 < _173) ? (_134 / CB1_m3.w) : exp2(log2((_134 + CB1_m4.z) / CB1_m4.y) * _163));
  float _264;
  float _265;
  float _266;
  if (CB1_m5.x != 0u) {
    uint _191 = cvt_f32_u32(CB0_m9.x);
    float _252;
    float _253;
    float _254;
    if (_191 == 1u) {
      _252 = mad(log2(_182 + 1.0000000116860974230803549289703e-07f), CB0_m9.y, CB0_m9.z);
      _253 = mad(log2(_181 + 1.0000000116860974230803549289703e-07f), CB0_m9.y, CB0_m9.z);
      _254 = mad(log2(_180 + 1.0000000116860974230803549289703e-07f), CB0_m9.y, CB0_m9.z);
    } else {
      float _249;
      float _250;
      float _251;
      if (_191 == 2u) {
        float _228 = exp2(log2(mad(CB0_m9.y, _180, CB0_m9.z) * 9.9999997473787516355514526367188e-05f) * 0.1593017578125f);
        float _229 = exp2(log2(mad(CB0_m9.y, _181, CB0_m9.z) * 9.9999997473787516355514526367188e-05f) * 0.1593017578125f);
        float _230 = exp2(log2(mad(CB0_m9.y, _182, CB0_m9.z) * 9.9999997473787516355514526367188e-05f) * 0.1593017578125f);
        _249 = exp2(log2(mad(_230, 18.8515625f, 0.8359375f) / mad(_230, 18.6875f, 1.0f)) * 78.84375f);
        _250 = exp2(log2(mad(_229, 18.8515625f, 0.8359375f) / mad(_229, 18.6875f, 1.0f)) * 78.84375f);
        _251 = exp2(log2(mad(_228, 18.8515625f, 0.8359375f) / mad(_228, 18.6875f, 1.0f)) * 78.84375f);
      } else {
        _249 = _182;
        _250 = _181;
        _251 = _180;
      }
      _252 = _249;
      _253 = _250;
      _254 = _251;
    }
    float4 _260 = T3.SampleLevel(S1, float3(_254, _253, _252), 0.0f);
    _264 = _260.z;
    _265 = _260.y;
    _266 = _260.x;
  } else {
    _264 = _182;
    _265 = _181;
    _266 = _180;
  }
  float3 _267 = float3(_266, _265, _264);
  float _290, _300, _310;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float _284 = exp2(log2(abs((CB1_m0.x * dp3_f32(float3(0.6274039745330810546875f, 0.329281985759735107421875f, 0.043313600122928619384765625f), _267)) / CB1_m4.w)) * 0.1593017578125f);
    _290 = exp2(log2(mad(_284, 18.8515625f, 0.8359375f) / mad(_284, 18.6875f, 1.0f)) * 78.84375f);
    float _294 = exp2(log2(abs((CB1_m0.x * dp3_f32(float3(0.06909699738025665283203125f, 0.919539988040924072265625f, 0.0113612003624439239501953125f), _267)) / CB1_m4.w)) * 0.1593017578125f);
    _300 = exp2(log2(mad(_294, 18.8515625f, 0.8359375f) / mad(_294, 18.6875f, 1.0f)) * 78.84375f);
    float _304 = exp2(log2(abs((CB1_m0.x * dp3_f32(float3(0.01639159955084323883056640625f, 0.0880132019519805908203125f, 0.895595014095306396484375f), _267)) / CB1_m4.w)) * 0.1593017578125f);
    _310 = exp2(log2(mad(_304, 18.8515625f, 0.8359375f) / mad(_304, 18.6875f, 1.0f)) * 78.84375f);
  } else {
    _267 = ApplyGammaCorrection(_267);
    _267 = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(_267), RENODX_GRAPHICS_WHITE_NITS);
    _290 = _267.x, _300 = _267.y, _310 = _267.z;
  }
  float _362;
  float _363;
  float _364;
  if (CB0_m2.x != 0u) {
    float _339 = mad(T1.Load(int4(uint3(uint2(cvt_f32_u32(gl_FragCoord.x) & 63u, cvt_f32_u32(gl_FragCoord.y) & 63u), (CB0_m2.y != 0u) ? (T0.Load(1840) & 31u) : 31u), 0u)).x, 2.0f, -1.0f);
    float _356 = (CB0_m2.z != 0u) ? (float(int(((_339 < 0.0f) ? 4294967295u : 0u) + uint(_339 > 0.0f))) * (1.0f - sqrt(1.0f - abs(_339)))) : _339;
    _362 = mad(_356, CB0_m3, _310);
    _363 = mad(_356, CB0_m3, _300);
    _364 = mad(_356, CB0_m3, _290);
  } else {
    _362 = _310;
    _363 = _300;
    _364 = _290;
  }
  SV_Target.x = _364;
  SV_Target.y = _363;
  SV_Target.z = _362;
  SV_Target.w = _131.w;
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
