#include "../shared.h"

cbuffer CB0_buf : register(b18, space0) {
  float4 CB0_m0 : packoffset(c0);
  uint4 CB0_m1 : packoffset(c1);
  uint4 CB0_m2 : packoffset(c2);
  float4 CB0_m3 : packoffset(c3);
};

SamplerState S0 : register(s5, space0);
Texture2D<float4> T0 : register(t8, space0);
Texture2D<float4> T1 : register(t91, space0);

static float4 SV_Position;
static float4 COLOR;
static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 SV_Position : SV_Position;
  float4 COLOR : COLOR0;
  float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float2 _52 = float2(TEXCOORD.x, TEXCOORD.y);
  float4 _55 = T1.SampleLevel(S0, _52, 0.0f);
  float _56 = _55.w;

  float peak_ratio = (CB0_m0.y / CB0_m0.x);
  float maximum_ratio = (CB0_m3.w / CB0_m0.x);
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    peak_ratio = RENODX_PEAK_WHITE_NITS / (RENODX_GRAPHICS_WHITE_NITS);
    maximum_ratio = (CB0_m3.w / (RENODX_GRAPHICS_WHITE_NITS));
    if (RENODX_GAMMA_CORRECTION != 0.f) {
      peak_ratio = renodx::color::correct::Gamma(peak_ratio, true);
      maximum_ratio = renodx::color::correct::Gamma(maximum_ratio, true);
    }
  }
  float _65 = (peak_ratio * _56) + (maximum_ratio * ((1.0f - _56) * T0.SampleLevel(S0, _52, 0.0f).w));
  SV_Target.x = _65;
  SV_Target.y = _65;
  SV_Target.z = _65;
  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
