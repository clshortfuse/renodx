#include "./shared.h"

cbuffer GUICommon_Instance_cbufferUBO : register(b0, space1) {
  float4 GUICommon_Instance_cbuffer_m0[213] : packoffset(c0);
}

Texture2D<float4> GUICommon_Instance_Texture : register(t1, space1);
SamplerState GUICommon_Instance_Sampler : register(s0, space2);

static float4 COLOR;
static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 COLOR : COLOR0;
  float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float4 _48 = GUICommon_Instance_Texture.Sample(GUICommon_Instance_Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  SV_Target.x = (GUICommon_Instance_cbuffer_m0[210u].x + COLOR.x) * _48.x;
  SV_Target.y = (GUICommon_Instance_cbuffer_m0[210u].y + COLOR.y) * _48.y;
  SV_Target.z = (GUICommon_Instance_cbuffer_m0[210u].z + COLOR.z) * _48.z;
  SV_Target.w = ((GUICommon_Instance_cbuffer_m0[8u].x >= 0.0f) ? GUICommon_Instance_cbuffer_m0[8u].x : COLOR.w) * _48.w;

  SV_Target.rgb = max(0, SV_Target.rgb);
  SV_Target.rgb = injectedData.toneMapGammaCorrection
                      ? pow(SV_Target.rgb, 2.2f)
                      : renodx::color::bt709::from::SRGB(SV_Target.rgb);
  SV_Target.rgb *= injectedData.toneMapUINits / 80.f;
  // SV_Target.rgb = 0;
  // SV_Target.a = 1.f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  COLOR = stage_input.COLOR;
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
