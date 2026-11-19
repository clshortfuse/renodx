#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
Texture2D<float4> t4 : register(t4);
SamplerState s4_s : register(s4);
Texture3D<float4> t5 : register(t5);
SamplerState s5_s : register(s5);

cbuffer cb2 : register(b2) { float4 cb2[26]; }

// The adaptive pass has its own dual-power curve; cb2 is not Hable data here.
float3 GhostsPower(float3 base, float3 exponent) {
  return float3(base.r > 0.f ? GhostsSafePow(base.r, exponent.r) : 0.f,
                base.g > 0.f ? GhostsSafePow(base.g, exponent.g) : 0.f,
                base.b > 0.f ? GhostsSafePow(base.b, exponent.b) : 0.f);
}
float3 GhostsAdaptiveCurve(float3 scene, float weight) {
  float y = dot(scene, float3(0.298999995f, 0.587000012f, 0.114f));
  float3 towardGray = y.xxx - scene;
  float3 a = cb2[0].xyz + GhostsPower((scene + cb2[2].w * towardGray) * cb2[1].xyz, cb2[2].xyz);
  float3 b = cb2[3].xyz + GhostsPower((scene + cb2[5].w * towardGray) * cb2[4].xyz, cb2[5].xyz);
  return GhostsSafeColor(lerp(a, b, weight));
}
float3 GhostsExtendedAdaptive(float3 scene, float weight) {
  float y = dot(scene, float3(0.298999995f, 0.587000012f, 0.114f));
  float3 result = 0.f;
  if (y <= 0.18f) {
    result = GhostsAdaptiveCurve(scene, weight);
  } else {
    float3 ray = scene / max(y, GHOSTS_EPSILON);
    float3 pivot = GhostsAdaptiveCurve(ray * 0.18f, weight);
    float3 slope = (GhostsAdaptiveCurve(ray * 0.181f, weight) - GhostsAdaptiveCurve(ray * 0.179f, weight)) / 0.002f;
    result = GhostsSafeColor(pivot + slope * (y - 0.18f));
  }
  return result;
}

void main(float4 position : SV_POSITION0, float2 uv : TEXCOORD0, out float4 output : SV_TARGET0) {
  float4 source = t0.Sample(s0_s, uv);
  output.a = source.a;
  bool hdr = GhostsUseHDR();
  float adaptation = GhostsSafeDivide(cb2[25].x, abs(t4.SampleLevel(s4_s, uv, 0.f).x));
  float weight = saturate(GhostsFiniteSigned(cb2[3].w * (adaptation - cb2[0].w)));
  float3 scene = GhostsSafeColor(source.rgb);
  float3 color = hdr ? GhostsExtendedAdaptive(GhostsPreControls(scene), weight) : saturate(GhostsAdaptiveCurve(scene, weight));
  float scale = hdr ? GhostsLUTScale(color) : 1.f;
  float3 proxy = color * scale;
  float3 graded = t5.Sample(s5_s, saturate(proxy) * 0.96875f + 0.015625f).rgb;
  if (!hdr) {
    // Preserve the original LUT output, then apply RenoDX's scene/UI scaling.
    output.rgb = GhostsRenderEncodedOutput(graded);
    return;
  }
  color = GhostsRestoreGrade(proxy, graded, scale);
  output.rgb = GhostsEncodeOutput(GhostsDisplayMap(color));
}
