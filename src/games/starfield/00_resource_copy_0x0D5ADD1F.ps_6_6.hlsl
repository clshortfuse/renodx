#include "./shared.h"

cbuffer _13_15 : register(b0, space0) {
  float4 _15_m0[1] : packoffset(c0);
}

// cbuffer injectedBuffer : register(b0, space9) {
//   ShaderInjectData injectedData : packoffset(c0);
// }

Texture2D<float4> _8 : register(t0, space8);
SamplerState _18 : register(s0, space8);
SamplerState _19 : register(s1, space8);

static float4 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 TEXCOORD : TEXCOORD0;
  float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float _59;
  float _60;
  float _61;
  float _62;
  if (asuint(_15_m0[0u]).x == 0u) {
    float4 _44 = _8.Sample(_18, float2(TEXCOORD.x, TEXCOORD.y));
    _59 = _44.x;
    _60 = _44.y;
    _61 = _44.z;
    _62 = _44.w;
  } else {
    float4 _53 = _8.Sample(_19, float2(TEXCOORD.x, TEXCOORD.y));
    _59 = _53.x;
    _60 = _53.y;
    _61 = _53.z;
    _62 = _53.w;
  }
  SV_Target.x = _59;
  SV_Target.y = _60;
  SV_Target.z = _61;
  SV_Target.w = _62;

  // float3 outputColor = SV_Target.rgb;
  // float3 signs = sign(outputColor.rgb);
  // outputColor = abs(outputColor);
  // outputColor = injectedData.toneMapGammaCorrection ? pow(outputColor, 2.2f) : renodx::color::bt709::from::SRGB(outputColor.rgb);
  // outputColor *= signs;

  float3 outputColor = SV_Target.rgb;
  float3 signs = sign(outputColor);
  outputColor = abs(outputColor);
  if (injectedData.toneMapGammaCorrection == 0.f) {
    outputColor = renodx::color::bt709::from::SRGB(outputColor);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    outputColor = pow(outputColor, 2.2f);
  } else if (injectedData.toneMapGammaCorrection == 2.f) {
    outputColor = pow(outputColor, 2.2f);
  }
  outputColor *= signs;
  SV_Target.rgb = outputColor * injectedData.toneMapUINits;

  if (injectedData.toneMapGammaCorrection == 2.f) {
    SV_Target.rgb = renodx::color::bt2020::from::BT709(SV_Target.rgb);  // use bt2020
    SV_Target.rgb /= 10000.f;                                           // Scale for PQ
    SV_Target.rgb = max(0, SV_Target.rgb);                              // clamp out of gamut
    SV_Target.rgb = renodx::color::pq::from::BT2020(SV_Target.rgb);     // convert to PQ
    SV_Target.rgb = min(1.f, SV_Target.rgb);                            // clamp PQ (10K nits)
  } else {
    SV_Target.rgb /= 80.f;
  }
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
