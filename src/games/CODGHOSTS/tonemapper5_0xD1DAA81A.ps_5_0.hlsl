#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
Texture2D<float4> t4 : register(t4);
SamplerState s4_s : register(s4);
Texture3D<float4> t5 : register(t5);
SamplerState s5_s : register(s5);

cbuffer cb2 : register(b2) { float4 cb2[37]; }

float GhostsSignedFraction(float x) { return x < 0.f ? -frac(-x) : frac(x); }
float2 GhostsSceneUV(float2 uv) {
  uv = GhostsFiniteSigned(uv);
  float index = floor(GhostsFiniteSigned(cb2[33].y * cb2[22].z * 15.f));
  float phase = max(sin(index * 0.0666666701f), 0.f);
  float2 animation = float2(GhostsSignedFraction(index * 5.39166689f), GhostsSignedFraction(index * 1.82500005f));
  float frame = floor(animation.x * 60.2400017f);
  float2 direction = GhostsFiniteSigned(t4.Sample(s4_s, GhostsFiniteSigned(uv * float2(0.600000024f, 0.400000006f) + animation * 8.f)).xy) * 2.f - 1.f;
  float2 modulation = GhostsFiniteSigned(t4.Sample(s4_s, GhostsFiniteSigned(uv * float2(0.25f, 1.f) + float2(frame * 0.0166002642f, 0.f))).zw);
  float gate = saturate(GhostsFiniteSigned(cb2[33].x) - modulation.x);
  float animated = modulation.y * phase * gate;
  float2 scale = gate * float2(0.100000001f, 0.0329999998f) + animated;
  float2 offset = direction * scale;
  if (modulation.x >= scale.x * 0.5f + cb2[33].x) offset = 0.f;
  return GhostsFiniteSigned(uv + offset);
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
  float scale = hdr ? GhostsLUTScale(color) : 1.f;
  float3 proxy = color * scale;
  float3 graded = t5.Sample(s5_s, saturate(proxy) * 0.9375f + 0.03125f).rgb;
  color = hdr ? GhostsRestoreGrade(proxy, graded, scale) : saturate(GhostsSafeColor(graded));
  if (hdr) color = GhostsDisplayMap(color);
  output.rgb = GhostsEncodeOutput(color, cb2[36].x, cb2[36].y);
}
