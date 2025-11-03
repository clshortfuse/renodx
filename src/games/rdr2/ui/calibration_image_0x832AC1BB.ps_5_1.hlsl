#include "../common.hlsli"

cbuffer CB0_buf : register(b17, space0) {
  uint4 CB0_m0 : packoffset(c0);
  uint4 CB0_m1 : packoffset(c1);
  float4 CB0_m2 : packoffset(c2);
};

cbuffer CB1_buf : register(b18, space0) {
  uint4 CB1_m0 : packoffset(c0);
  uint2 CB1_m1 : packoffset(c1);
  float2 CB1_m2 : packoffset(c1.z);
};

SamplerState S0 : register(s5, space0);
Texture2D<float4> T0 : register(t8, space0);

static float4 SV_Position;
static float4 COLOR;
static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 SV_Position : SV_Position;
  float4 COLOR : COLOR0;
  float2 TEXCOORD : TEXCOORD;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

float dp3_f32(float3 a, float3 b) {
  precise float _50 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _50));
}

void frag_main() {
  SV_Target.w = 1.0f;

  float4 _71 = T0.SampleLevel(S0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    SV_Target.rgb = _71.rgb;
    const float sdr_peak = 0.9525f;
    SV_Target.rgb = InverseReinhardScalablePiecewise(SV_Target.rgb, sdr_peak, 0.4f);

    float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

    if (RENODX_GAMMA_CORRECTION) {
      peak_ratio = renodx::color::correct::Gamma(peak_ratio, true);
      if (RENODX_TONE_MAP_TYPE != 1.f) {
        SV_Target.rgb = renodx::tonemap::ReinhardPiecewiseExtended(SV_Target.rgb, 99.1f, peak_ratio, 0.4f);
      }
      SV_Target.rgb = renodx::color::correct::GammaSafe(SV_Target.rgb);
      SV_Target.rgb *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
      SV_Target.rgb = renodx::color::correct::GammaSafe(SV_Target.rgb, true);
    } else {
      if (RENODX_TONE_MAP_TYPE != 1.f) {
        SV_Target.rgb = renodx::tonemap::ReinhardPiecewiseExtended(SV_Target.rgb, 99.1f, peak_ratio, 0.4f);
      }
      SV_Target.rgb *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    }
    return;
  }

  float _72 = _71.x;
  float _93 = clamp((dp3_f32(float3(_72, _71.yz), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)) - CB0_m2.z) * (1.0f / (CB0_m2.w - CB0_m2.z)), 0.0f, 1.0f);

  bool boolean = (CB1_m1.y != 0u);  // true = game, false = cinematic
  float _106 = boolean ? ((CB1_m2.x * CB0_m2.y) + ((mad(_93, -2.0f, 3.0f) * (_93 * _93)) * mad(-CB1_m2.x, CB0_m2.y, CB1_m2.x)))
                       : 1.0f;

  SV_Target.x = (_72 * _106) * CB0_m2.x;
  SV_Target.y = (_71.y * _106) * CB0_m2.x;
  SV_Target.z = (_71.z * _106) * CB0_m2.x;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
