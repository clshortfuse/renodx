// Final output pass (0x4564BB42, ps_5_0): the scene is read straight from an r11g11b10_float texture.
// Used at 100% render scale. See common.hlsli for the rest of the pass.
#include "./common.hlsli"

float4 main(float4 vpos : SV_Position, float2 uv : TEXCOORD0) : SV_Target {
  return FinalPass(uv, max(0.f, g_mainTexture.SampleLevel(g_pointSampler, uv, 0).rgb * g_planeWeights.x));
}
