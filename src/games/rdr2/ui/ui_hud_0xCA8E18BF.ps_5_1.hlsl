
#include "../common.hlsli"

struct anon_m {
  float4 _m0;
  uint4 _m1;
  uint4 _m2;
  uint4 _m3;
  uint4 _m4;
  uint3 _m5;
};

cbuffer CB0_buf : register(b22, space0) {
  uint4 CB0_m0 : packoffset(c0);
  uint4 CB0_m1 : packoffset(c1);
  uint4 CB0_m2 : packoffset(c2);
  uint4 CB0_m3 : packoffset(c3);
  uint4 CB0_m4 : packoffset(c4);
  uint4 CB0_m5 : packoffset(c5);
  uint4 CB0_m6 : packoffset(c6);
  float4 CB0_m7 : packoffset(c7);
  float4 CB0_m8 : packoffset(c8);
  float CB0_m9 : packoffset(c9);
  uint CB0_m10 : packoffset(c9.y);
  uint CB0_m11 : packoffset(c9.z);
  uint CB0_m12 : packoffset(c9.w);
  uint4 CB0_m13 : packoffset(c10);
};

cbuffer CB1_buf : register(b23, space0) {
  float4 CB1_m0 : packoffset(c0);
  uint4 CB1_m1 : packoffset(c1);
  uint4 CB1_m2 : packoffset(c2);
  float4 CB1_m3 : packoffset(c3);
};

ByteAddressBuffer T0 : register(t0, space0);
SamplerState S0 : register(s2, space0);
SamplerState S1 : register(s5, space0);
Texture2D<float4> T1 : register(t32, space0);
Texture3D<float4> T2 : register(t35, space0);

static float4 SV_POSITION0;
static float4 COLOR0;
static float4 COLOR1;
static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 SV_POSITION0 : SV_POSITION0;
  float4 COLOR0 : COLOR0;
  float4 COLOR1 : COLOR1;
  float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

float dp3_f32(float3 a, float3 b) {
  precise float _83 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _83));
}

void frag_main() {
  float4 _104 = T1.Sample(S1, float2(TEXCOORD.x, TEXCOORD.y));
  float _123 = mad(_104.x, CB0_m8.x, CB0_m7.x);
  float _124 = mad(_104.y, CB0_m8.y, CB0_m7.y);
  float _125 = mad(_104.z, CB0_m8.z, CB0_m7.z);
  float _129 = mad(_104.w, CB0_m8.w, CB0_m7.w) * COLOR1.w;
  float _146;
  float _147;
  float _148;
  if (CB0_m13.x != 0u) {
    float4 _142 = T2.SampleLevel(S0, float3(_123, _124, _125), 0.0f);
    _146 = _142.z;
    _147 = _142.y;
    _148 = _142.x;
  } else {
    _146 = _125;
    _147 = _124;
    _148 = _123;
  }
  float _200;
  float _201;
  float _202;
  if (CB0_m10 != 0u) {
    float3 _154 = float3(_148, _147, _146);
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      float _173 = exp2(log2(abs((dp3_f32(float3(0.6274039745330810546875f, 0.329281985759735107421875f, 0.043313600122928619384765625f), _154) * CB1_m0.x) / CB1_m3.w)) * 0.1593017578125f);
      float _183 = exp2(log2(abs((dp3_f32(float3(0.06909699738025665283203125f, 0.919539988040924072265625f, 0.0113612003624439239501953125f), _154) * CB1_m0.x) / CB1_m3.w)) * 0.1593017578125f);
      float _193 = exp2(log2(abs((dp3_f32(float3(0.01639159955084323883056640625f, 0.0880132019519805908203125f, 0.895595014095306396484375f), _154) * CB1_m0.x) / CB1_m3.w)) * 0.1593017578125f);
      _200 = exp2(log2(mad(_193, 18.8515625f, 0.8359375f) / mad(_193, 18.6875f, 1.0f)) * 78.84375f);
      _201 = exp2(log2(mad(_183, 18.8515625f, 0.8359375f) / mad(_183, 18.6875f, 1.0f)) * 78.84375f);
      _202 = exp2(log2(mad(_173, 18.8515625f, 0.8359375f) / mad(_173, 18.6875f, 1.0f)) * 78.84375f);
    } else {
      _154 = ApplyGammaCorrection(_154);
      _154 = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(_154), RENODX_GRAPHICS_WHITE_NITS);
      _200 = _154.x, _201 = _154.y, _202 = _154.z;
    }
  } else {
    _200 = _146;
    _201 = _147;
    _202 = _148;
  }
  bool _205 = CB0_m9 == 0.0f;
  float _216 = _129 * asfloat(T0.Load(12));
  SV_Target.z = (asfloat(T0.Load(12)) != 1.0f) ? (_216 * _216) : (_205 ? _200 : (_129 * _200));
  float _224 = _129 * asfloat(T0.Load(0));
  float _230 = (CB0_m11 != 0u) ? (_224 * asfloat(CB0_m11)) : _224;
  SV_Target.w = clamp((CB0_m13.y != 0u) ? ((CB0_m12 != 0u) ? ((cos(_230 * 3.1415927410125732421875f) - 1.0f) * (-0.5f)) : _230) : _224, 0.0f, 1.0f);
  SV_Target.x = _205 ? _202 : (_129 * _202);
  SV_Target.y = _205 ? _201 : (_129 * _201);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  COLOR1 = stage_input.COLOR1;
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
