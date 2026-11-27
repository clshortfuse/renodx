// VoxelizedLightScatteringApply_PS: applies froxel in-scatter + analytic distance/height fog to the lit scene.
// Blend: dst = dst * out.a + out.rgb.

#include "./shared.h"
#include "./voxel_fog.hlsli"

Texture3D<float4> mapVoxelizedLightScatteringBuffer : register(t65, space1);

Texture2D<float4> mapDepthBuffer : register(t0);

// CUSTOM: pre-fog copy of RT0 (RGBA16F, 8 bytes per pixel), filled by the addon and bound as a root buffer SRV.
// A buffer, not a texture, so ReShade does not switch descriptor heaps under the game's tables.
ByteAddressBuffer mapPreFogScene : register(t0, space51);

SamplerState MaterialSamplers[1920] : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 result = VoxelFog(mapVoxelizedLightScatteringBuffer, MaterialSamplers[1u], TEXCOORD, mapDepthBuffer.Sample(MaterialSamplers[6u], TEXCOORD).x);
  if (RENODX_FOG_BLACK_PRESERVATION > 0.f) {
    uint2 pixel = uint2(SV_Position.xy);
    uint2 packed = mapPreFogScene.Load2((pixel.y * (uint)RENODX_FOG_SCENE_ROW_PIXELS + pixel.x) * 8u);
    float3 scene = float3(f16tof32(packed.x), f16tof32(packed.x >> 16), f16tof32(packed.y));
    // CUSTOM: the blend is dst * a + rgb. Returning alpha 0 makes it dst * 0 + rgb, so the output is the full
    // composite and replaces RT0 instead of adding to it. The addon fills t0 space51 with the pre-fog RT0 copy.
    return float4(FogBlackPreservingComposite(scene, result.rgb, result.a, RENODX_FOG_BLACK_PRESERVATION), 0.f);
  }
  return result;
}
