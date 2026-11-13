// Final output pass with Lanczos resampling (0x3998EA61, ps_5_0): the game uses it when it renders below 100%
// with frame generation off. Same HDR10 PQ output as 0x4564BB42. See lanczos.hlsli for the scene read.
#include "./lanczos.hlsli"

float4 main(float4 vpos : SV_Position, float2 uv : TEXCOORD0) : SV_Target {
  return FinalPass(uv, ResampleScene(uv), true);
}
