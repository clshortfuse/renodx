// Final output pass with two render targets and no Lanczos (0xE779DCD3, ps_5_0): seen with DLSS Frame Generation on and
// Render Scale 70% (input 1344x756) and 85% (1632x920). Same as 0x23DC66B2 except that the scene is a packed r10g10b10a2
// texture read with the bilinear sampler (s1) and unpacked afterwards. SV_Target0 is the final image with the UI;
// SV_Target1 is the same picture without it. See FinalPassWithHudLess() in common.hlsli.
#include "./common.hlsli"

FinalOutputs main(float4 vpos : SV_Position, float2 uv : TEXCOORD0) {
  return FinalPassWithHudLess(uv, UnpackScene(g_mainTexture.SampleLevel(g_linearSampler, uv, 0).rgb));
}
