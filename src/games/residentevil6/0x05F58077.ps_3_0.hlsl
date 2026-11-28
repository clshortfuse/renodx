#include "./color_grade.hlsli"

float4 CBHDRFactor__packed0 : register(c1);
sampler2D base_map : register(s0);

float2 SampleExposureLog(float2 uv) {
  float4 packed = tex2D(base_map, uv);
  if (!all(isfinite(packed)) || packed.a <= 0.f) return 0.f;
  float3 color = DecodeGameSRGB(packed.rgb) / packed.a * CBHDRFactor__packed0.w;
  float luminance = dot(color, float3(0.299010009f, 0.587000012f, 0.114f));
  if (!isfinite(luminance) || luminance < 0.f) return 0.f;
  // Preserve the game's log-luminance floor and all finite HDR samples.
  return float2(log2(luminance + 1.e-5f) * 0.693147182f, 1.f);
}

float4 main(float4 uv0 : TEXCOORD0, float4 uv1 : TEXCOORD1) : COLOR0 {
  float2 measured = SampleExposureLog(uv0.zw) + SampleExposureLog(uv0.xy)
                    + SampleExposureLog(uv1.xy) + SampleExposureLog(uv1.zw);
  // Ignore invalid samples rather than poisoning every later reduction. With
  // no valid samples, log(1) supplies a finite neutral reference for this tile.
  return float4(measured.x / max(measured.y, 1.f), 0.f, 0.f, 0.f);
}
