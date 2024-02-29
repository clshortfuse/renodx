// UI Alpha Compositing

#include "../common/color.hlsl"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[24];
}

void main(float2 v0 : TEXCOORD0, float4 v1 : SV_POSITION0, out float4 uiOutput : SV_Target0, out float4 o1 : SV_Target1) {
  float4 r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  const float uiPaperWhiteNits = cb0[23].x / 2.f; // cb0[23].x;  // 200
  const float gamma = cb0[23].y;             // 2.2

  const float4 inputColor = t0.SampleLevel(s0_s, v0.xy, 0).rgba;
  const float MIN_ALPHA = 0.01f;
  const float uiAlpha = inputColor.a;

  float3 outputRGB = inputColor.rgb;
  // Convert UI render to PQ
  if (uiAlpha > MIN_ALPHA) {
    outputRGB = saturate(outputRGB);  // Clamp to SDR

    outputRGB = pow(outputRGB, gamma);  // Apply gamma to UI elements

    outputRGB = mul(BT709_2_BT2020_MAT, outputRGB);

    outputRGB *= uiPaperWhiteNits;  // Scale peak to 200
    outputRGB /= 10000.f;           // Scale for PQ
    outputRGB = max(0, outputRGB);
    outputRGB = pqFromLinear(outputRGB);

    outputRGB = min(1.f, outputRGB);  // clamp PQ (10K nits)

    uiOutput.rgb = outputRGB;
    uiOutput.a = uiAlpha;


    // Unknown output
    o1.rgba = inputColor.rgba;
  } else {
    if (-1 != 0) discard;
    uiOutput.rgba = float4(0, 0, 0, 0);
    o1.rgba = float4(0, 0, 0, 0);
  }
  return;
}
