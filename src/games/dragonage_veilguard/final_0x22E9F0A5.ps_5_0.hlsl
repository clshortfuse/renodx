// Final output pass with Lanczos resampling and two render targets (0x22E9F0A5, ps_5_0): the game uses it when it
// renders below 100% with DLSS Frame Generation on. SV_Target0 is the final image with the UI; SV_Target1 is the same
// picture without the UI. See FinalPassWithHudLess() in common.hlsli.
#include "./lanczos.hlsli"

FinalOutputs main(float4 vpos : SV_Position, float2 uv : TEXCOORD0) {
  return FinalPassWithHudLess(uv, ResampleScene(uv));
}
