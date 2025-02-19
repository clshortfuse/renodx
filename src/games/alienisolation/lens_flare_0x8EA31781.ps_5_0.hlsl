#include "./shared.h"

SamplerState SamplerFlare0_SMP_s : register(s0);
Texture2D<float4> SamplerFlare0_TEX : register(t0);

void main(
    float4 v0: TEXCOORD0,
    float4 v1: TEXCOORD1,
    float4 v2: SV_Position0,
    out float4 o0: SV_Target0) {
  float4 r0, r1;

  r0.x = dot(v0.zw, v0.zw);
  r0.x = 0.09 + r0.x;
  r0.x = 0.09 / r0.x;
  r0.x = r0.x * r0.x;
  r0.xyz = v1.xyz * r0.xxx;
  r1.xyz = SamplerFlare0_TEX.SampleLevel(SamplerFlare0_SMP_s, v0.xy, 0).xyz;
  o0.xyz = r1.xyz * r0.xyz;
  o0.w = 1;

  o0.rgb = saturate(o0.rgb);  // draws on swapchain (originally unorm)
  o0.rgb *= injectedData.fxLensFlare;
  return;
}
