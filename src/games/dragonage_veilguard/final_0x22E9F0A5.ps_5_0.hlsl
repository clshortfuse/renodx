// Final output pass with Lanczos resampling and two render targets (0x22E9F0A5, ps_5_0): the game uses it when it
// renders below 100% with DLSS Frame Generation on. SV_Target0 is the final image with the UI; SV_Target1 is the same
// picture without the UI (the HUD-less colour buffer frame generation reads), so both go through the same tone mapping.
#include "./lanczos.hlsli"

struct Outputs {
  float4 with_ui : SV_Target0;
  float4 hud_less : SV_Target1;
};

Outputs main(float4 vpos : SV_Position, float2 uv : TEXCOORD0) {
  const float3 scene = ResampleScene(uv);
  Outputs outputs;
  outputs.with_ui = FinalPass(uv, scene, true);
  outputs.hud_less = FinalPass(uv, scene, false);
  return outputs;
}
