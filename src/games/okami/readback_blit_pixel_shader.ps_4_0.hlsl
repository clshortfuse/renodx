// Writes an upgraded FP16 render target back into its original 8-bit target
// before the game reads it on the CPU (see readback.hpp). The UNORM target
// clamps the way the vanilla one did; saturate() makes that explicit and maps
// NaN to 0.
Texture2D<float4> fp16_source : register(t0);

float4 main(float4 position: SV_Position) : SV_Target {
  return saturate(fp16_source.Load(int3(int2(position.xy), 0)));
}
