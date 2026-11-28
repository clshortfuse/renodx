#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) { float4 cb2[10]; }

// This pass uses an encoded-space analytic grade, with no Hable curve or LUT.
float3 GhostsAnalyticGrade(float3 encoded) {
  float y = dot(encoded, float3(0.298999995f, 0.587000012f, 0.114f));
  float desaturation = cb2[6].w + cb2[7].w * y;
  float3 gain = cb2[6].xyz + cb2[7].xyz * y + cb2[8].xyz * y * y;
  return GhostsSafeColor((encoded + desaturation * (y.xxx - encoded)) * gain + cb2[9].xyz);
}

void main(float4 position : SV_POSITION0, float2 uv : TEXCOORD0, out float4 output : SV_TARGET0) {
  float4 source = t0.Sample(s0_s, uv);
  output.a = source.a;
  bool hdr = GhostsUseHDR();
  float3 scene = GhostsSafeColor(source.rgb);
  if (!hdr) {
    output.rgb = GhostsRenderEncodedOutput(GhostsAnalyticGrade(renodx::color::srgb::EncodeSafe(saturate(scene))));
    return;
  }
  scene = GhostsPreControls(scene);
  float scale = GhostsLUTScale(scene);
  float3 proxy = scene * scale;
  float3 encodedGrade = GhostsAnalyticGrade(renodx::color::srgb::EncodeSafe(proxy));
  float3 graded = GhostsSafeColor(renodx::color::srgb::DecodeSafe(encodedGrade));
  float3 color = GhostsRestoreGrade(proxy, graded, scale);
  output.rgb = GhostsEncodeOutput(GhostsDisplayMap(color));
}
