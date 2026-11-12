#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) { float4 cb2[37]; }

void main(float4 position : SV_POSITION0, float2 uv : TEXCOORD0, float exposure : TEXCOORD2, out float4 output : SV_TARGET0) {
  float4 source = t0.Sample(s0_s, uv);
  output.a = source.a;
  bool hdr = GhostsUseHDR();
  float3 color;
  if (hdr) {
    color = GhostsExtendedHable(GhostsPreControls(source.rgb), GhostsExposure(exposure),
        cb2[3].xyz, cb2[4].xyz, cb2[6].xyz, cb2[7].xyz, cb2[8].xyz, cb2[9].xyz);
  } else {
    color = GhostsOriginalHable(source.rgb, exposure, cb2[3].xyz, cb2[4].xyz,
        cb2[5].xyz, cb2[6].xyz, cb2[7].xyz, cb2[8].xyz, cb2[9].xyz);
  }
  if (hdr) color = GhostsDisplayMap(color);
  output.rgb = GhostsEncodeOutput(color, cb2[36].x, cb2[36].y);
}
