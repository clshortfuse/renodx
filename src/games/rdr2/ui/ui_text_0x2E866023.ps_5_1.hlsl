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

static float4 SV_Position;
static float2 TEXCOORD;
static float4 COLOR;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 SV_Position : SV_Position;
  float2 TEXCOORD : TEXCOORD0;
  float4 COLOR : COLOR0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

float dp3_f32(float3 a, float3 b) {
  precise float _83 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _83));
}

void frag_main() {
  float _117 = mad(COLOR.x, CB0_m8.x, CB0_m7.x);
  float _118 = mad(COLOR.y, CB0_m8.y, CB0_m7.y);
  float _119 = mad(COLOR.z, CB0_m8.z, CB0_m7.z);
  float4 _130 = T1.Sample(S1, float2(TEXCOORD.x, TEXCOORD.y));
  float _132 = mad(COLOR.w, CB0_m8.w, CB0_m7.w) * _130.w;
  float _149;
  float _150;
  float _151;
  if (CB0_m13.x != 0u) {
    float4 _145 = T2.SampleLevel(S0, float3(_117, _118, _119), 0.0f);
    _149 = _145.z;
    _150 = _145.y;
    _151 = _145.x;
  } else {
    _149 = _119;
    _150 = _118;
    _151 = _117;
  }
  float _203;
  float _204;
  float _205;
  if (CB0_m10 != 0u) {
    float3 _157 = float3(_151, _150, _149);
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      float _176 = exp2(log2(abs((dp3_f32(float3(0.6274039745330810546875f, 0.329281985759735107421875f, 0.043313600122928619384765625f), _157) * CB1_m0.x) / CB1_m3.w)) * 0.1593017578125f);
      float _186 = exp2(log2(abs((dp3_f32(float3(0.06909699738025665283203125f, 0.919539988040924072265625f, 0.0113612003624439239501953125f), _157) * CB1_m0.x) / CB1_m3.w)) * 0.1593017578125f);
      float _196 = exp2(log2(abs((dp3_f32(float3(0.01639159955084323883056640625f, 0.0880132019519805908203125f, 0.895595014095306396484375f), _157) * CB1_m0.x) / CB1_m3.w)) * 0.1593017578125f);
      _203 = exp2(log2(mad(_196, 18.8515625f, 0.8359375f) / mad(_196, 18.6875f, 1.0f)) * 78.84375f);
      _204 = exp2(log2(mad(_186, 18.8515625f, 0.8359375f) / mad(_186, 18.6875f, 1.0f)) * 78.84375f);
      _205 = exp2(log2(mad(_176, 18.8515625f, 0.8359375f) / mad(_176, 18.6875f, 1.0f)) * 78.84375f);
    } else {
      _157 = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(ApplyGammaCorrection(_157)), RENODX_GRAPHICS_WHITE_NITS);
      _203 = _157.x, _204 = _157.y, _205 = _157.z;
    }
  } else {
    _203 = _149;
    _204 = _150;
    _205 = _151;
  }
  bool _208 = CB0_m9 == 0.0f;
  float _219 = _132 * asfloat(T0.Load(12));
  SV_Target.z = (asfloat(T0.Load(12)) != 1.0f) ? (_219 * _219) : (_208 ? _203 : (_132 * _203));
  float _227 = _132 * asfloat(T0.Load(0));
  float _233 = (CB0_m11 != 0u) ? (_227 * asfloat(CB0_m11)) : _227;
  SV_Target.w = clamp((CB0_m13.y != 0u) ? ((CB0_m12 != 0u) ? ((cos(_233 * 3.1415927410125732421875f) - 1.0f) * (-0.5f)) : _233) : _227, 0.0f, 1.0f);
  SV_Target.x = _208 ? _205 : (_132 * _205);
  SV_Target.y = _208 ? _204 : (_132 * _204);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  COLOR = stage_input.COLOR;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
