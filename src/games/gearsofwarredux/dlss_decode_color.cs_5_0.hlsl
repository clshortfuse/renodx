// NGX HDR reconstruction uses linear light. The UE3 composite remains gamma 2.2
// so native rendering and the game's final blur/fade retain their original domain.
Texture2D<float4> GammaColor : register(t0);
RWTexture2D<float4> LinearColor : register(u0);

cbuffer RenderRect : register(b0) {
  uint2 origin;
  uint2 extent;
};

[numthreads(8, 8, 1)]
void main(uint3 id : SV_DispatchThreadID) {
  if (any(id.xy >= extent)) return;
  uint2 pixel = origin + id.xy;
  float4 color = GammaColor.Load(int3(pixel, 0));
  LinearColor[pixel] = float4(pow(max(color.rgb, 0.f), 2.2f), color.a);
}
