#include "./shared.h"

cbuffer Compositing_Parameters_cbufferUBO : register(b0, space1) {
  float4 Compositing_Parameters_cbuffer_m0[1] : packoffset(c0);
}

Texture2D<float4> Compositing_Parameters_tex_MainRT : register(t1, space1);
SamplerState Compositing_Parameters_sampler_MainRT : register(s0, space2);

static float4 gl_FragCoord;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float4 _45 = Compositing_Parameters_tex_MainRT.Sample(
      Compositing_Parameters_sampler_MainRT,
      float2(
          (
              gl_FragCoord.x - Compositing_Parameters_cbuffer_m0[0u].z)
              * Compositing_Parameters_cbuffer_m0[0u].x,
          (gl_FragCoord.y - Compositing_Parameters_cbuffer_m0[0u].w) * Compositing_Parameters_cbuffer_m0[0u].y));
  SV_Target.x = _45.x;
  SV_Target.y = _45.y;
  SV_Target.z = _45.z;
  SV_Target.w = _45.w;
  SV_Target.rgb = max(0, SV_Target.rgb);
  SV_Target.rgb = injectedData.toneMapGammaCorrection
                      ? pow(SV_Target.rgb, 2.2f)
                      : renodx::color::bt709::from::SRGB(SV_Target.rgb);
  SV_Target.rgb *= injectedData.toneMapGameNits / 80.f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
