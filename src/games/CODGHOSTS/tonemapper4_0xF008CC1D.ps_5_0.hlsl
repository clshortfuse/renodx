#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
Texture2D<float4> t4 : register(t4);
SamplerState s4_s : register(s4);

cbuffer cb2 : register(b2) { float4 cb2[37]; }

float2 GhostsSceneUV(float2 uv) {
  uv = GhostsFiniteSigned(uv);
  float2 lookup = float2(uv.x + cb2[22].x * cb2[33].x, uv.y - cb2[22].w * cb2[33].z + 1.f);
  lookup = GhostsFiniteSigned(lookup);
  float2 full = GhostsFiniteSigned(t4.Sample(s4_s, lookup).xy) * GhostsFiniteSigned(cb2[22].y);
  float2 halfBlur = GhostsFiniteSigned(t4.Sample(s4_s, lookup * 0.5f).xy) * GhostsFiniteSigned(cb2[22].x) * 0.5f;
  float mask = saturate(uv.y - 2.f * cb2[34].w + 1.f);
  mask = GhostsFiniteSigned(mask * mask * GhostsFiniteSigned(cb2[33].w));
  return saturate(GhostsFiniteSigned(uv + GhostsFiniteSigned(full * 0.5f + halfBlur) * mask));
}

void main(float4 position : SV_POSITION0, float2 uv : TEXCOORD0, float exposure : TEXCOORD2, out float4 output : SV_TARGET0) {
  float4 source = t0.Sample(s0_s, GhostsSceneUV(uv));
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
