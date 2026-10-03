#include "./common.hlsli"

// Genshin Impact HDR final composite (HDR mode only): blends the premultiplied
// UI over the PQ BT.2020 scene and writes the R10G10B10A2 HDR10 swapchain.
// Vanilla scales the scene by the game's UI paper white for the blend, scales
// the UI by the game's UI intensity (cb0[2].w) and PQ encodes through a 1D LUT
// (t2).
// RenoDX: see CompositeSceneAndUI; the swapchain proxy does the final
// HDR10/scRGB encode, same as the SDR path.
// Original bytecode decompiled with 3Dmigoto, cleaned up and annotated.

Texture2D<float4> t0 : register(t0);  // UI, premultiplied alpha
Texture2D<float4> t1 : register(t1);  // scene, PQ BT.2020
Texture2D<float4> t2 : register(t2);  // vanilla PQ encode LUT (unused)

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);

cbuffer cb0 : register(b0) {
  float4 cb0[7];
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  o0 = CompositeSceneAndUI(t1.Sample(s0_s, v1.xy).xyz, t0.Sample(s1_s, v1.xy));
}
