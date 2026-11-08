// TEMPORARY LIVE TEST (no shader_injection: this hash is not registered by the
// running addon). Peak/Game Brightness hard-coded to the current 2700/203.
Texture2D<float4> colorMapSampler : register(t0);
cbuffer PerSceneConsts : register(b2) {
  float4 _perScenePad[108] : packoffset(c0);
  float4 ui2dColorMatrixR : packoffset(c108);
  float4 ui2dColorMatrixG : packoffset(c109);
  float4 ui2dColorMatrixB : packoffset(c110);
};
SamplerState colorSampler : register(s0);

float4 main(noperspective float4 SV_Position : SV_Position,
            linear float4 COLOR : COLOR,
            linear float2 TEXCOORD : TEXCOORD) : SV_Target {
  float4 _10 = colorMapSampler.Sample(colorSampler, TEXCOORD);
  float3 c = _10.rgb * COLOR.rgb;
  float3 g;
  [branch]
  if (ui2dColorMatrixR.w == 1.0f) {
    g = exp2(log2(c * 5.55555534362793f) * ui2dColorMatrixG.w) * 0.18000000715255737f;
  } else {
    [branch]
    if (ui2dColorMatrixR.w == 2.0f) g = pow(c, ui2dColorMatrixG.w);
    else g = c;
  }
  float4 o;
  o.r = dot(g, ui2dColorMatrixR.xyz);
  o.g = dot(g, ui2dColorMatrixG.xyz);
  o.b = dot(g, ui2dColorMatrixB.xyz);
  o.a = _10.w * COLOR.w;

  // Black overlay over an HDR scene: raise opacity so the residual scales like SDR.
  if (max(o.r, max(o.g, o.b)) <= 0.00001f && o.a > 0.0f && o.a < 1.0f) {
    float k = 1.0f + log2(2700.0f / 203.0f) / log2(50.0f);
    o.a = 1.0f - pow(1.0f - o.a, k);
  }
  return o;
}
