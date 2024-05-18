#include "../../shaders/color.hlsl"
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
  // outputColor = injectedData.toneMapGammaCorrection ? pow(outputColor, 2.2f) : linearFromSRGB(outputColor.rgb);
  // outputColor *= signs;
  SV_Target.rgb *= injectedData.toneMapUINits / 80.f;

  // SV_Target.rgb = outputColor;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
