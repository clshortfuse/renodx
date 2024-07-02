#include "./shared.h"

Texture2D<float4> Texture : register(t0, space2);
SamplerState Sampler : register(s0, space0);

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

cbuffer injectedBuffer : register(b49, space1) {
  ShaderInjectData injectedData : packoffset(c0);
}

void frag_main() {
  float4 _34 = Texture.Sample(Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  SV_Target.x = _34.x;
  SV_Target.y = _34.y;
  SV_Target.z = _34.z;
  SV_Target.w = _34.w;
  float3 signs = sign(SV_Target.xyz);
  SV_Target.xyz = abs(SV_Target.xyz);
  SV_Target.xyz = injectedData.toneMapGammaCorrection
                      ? pow(SV_Target.xyz, 2.2f)
                      : renodx::color::bt709::from::SRGB(SV_Target.xyz);
  SV_Target.xyz *= signs;
  SV_Target.xyz *= injectedData.toneMapUINits / 80.f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  COLOR = stage_input.COLOR;
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
