// HDR mode UI pass used when ReShade effects render before UI.
// Samples the premultiplied UI buffer; the pipeline blends ONE / SRC_ALPHA,
// matching the vanilla composite `scene * ui.a + ui.rgb`.
Texture2D t0 : register(t0);
SamplerState s0 : register(s0);

float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0) : SV_TARGET {
  // The proxy triangle has uv.y = 0 at the top; Unity's UI buffer is stored
  // bottom-up (the vanilla composite VS uses uv = clip * 0.5 + 0.5)
  return t0.Sample(s0, float2(uv.x, 1.f - uv.y));
}
