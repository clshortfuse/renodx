#include "./composite.hlsl"

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  SYS_TEXCOORD = stage_input.SYS_TEXCOORD;
  SPIRV_Cross_Output stage_output;
  float4 outputColor = float4(composite(true).rgb, 1.f);
  stage_output.SV_Target = outputColor;
  return stage_output;
}
