// Final output pass with two render targets (0x23DC66B2, ps_5_0): the game uses it at 100% render scale with DLSS Frame
// Generation on. The scene is read straight from an r11g11b10_float texture, like 0x4564BB42, and SV_Target0 is the final
// image with the UI while SV_Target1 is the same picture without it. See FinalPassWithHudLess() in common.hlsli.
#include "./common.hlsli"

FinalOutputs main(float4 vpos : SV_Position, float2 uv : TEXCOORD0) {
  return FinalPassWithHudLess(uv, max(0.f, g_mainTexture.SampleLevel(g_pointSampler, uv, 0).rgb * g_planeWeights.x));
}
