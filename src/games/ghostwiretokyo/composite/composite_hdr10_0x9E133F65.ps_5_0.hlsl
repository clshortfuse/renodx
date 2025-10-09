#include "./composite.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Wed Oct  8 08:23:25 2025
Texture3D<float4> t2 : register(t2);  // They apply ACES to the UI only in HDR, likely to cover up gamma mismatch

Texture2D<float4> SceneTexture : register(t1);

Texture2D<float4> UITexture : register(t0);

SamplerState s2_s : register(s2);

SamplerState SceneSampler : register(s1);

SamplerState UISampler : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[11];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0: TEXCOORD0,
    float4 v1: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;

  r1.xyz = SceneTexture.Sample(SceneSampler, v0.xy).xyz;
  r0.xyzw = UITexture.Sample(UISampler, v0.xy).xyzw;

  // skip cursed ACES lutbuilder on UI, they don't use it in SDR
  if (HandleUICompositing(r0, r1, o0, v0.xy, SceneTexture, SceneSampler)) {
    return;
  }

  // linearize UI
  r0.rgb = renodx::color::srgb::Decode(max(6.10351999e-05, r0.rgb));

  // sample UI LUT
  r0.rgb = renodx::color::pq::EncodeSafe(r0.rgb, 1.f);
  r0.xyz = t2.SampleLevel(s2_s, r0.xyz * (31.f / 32.f) + (1.f / 64.f), 0).xyz;
  r0.xyz = r0.xyz * 1.05f;

  // linearize scene
  r1.rgb = renodx::color::pq::DecodeSafe(r1.rgb, 1.f);

  // linearize UI
  r0.xyz = renodx::color::pq::DecodeSafe(r0.rgb, 10000.f / cb0[10].w);

  r1.w = cmp(0 < r0.w);
  r2.x = cmp(r0.w < 1);
  r1.w = r1.w ? r2.x : 0;
  if (r1.w != 0) {
    r1.w = dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114));
    r1.w = r1.w / cb0[10].w;
    r1.w = 1 + r1.w;
    r1.w = 1 / r1.w;
    r1.w = r1.w * cb0[10].w + -1;
    r1.w = r0.w * r1.w + 1;
    r1.xyz = r1.xyz * r1.www;
  }
  r0.xyz = float3(10000, 10000, 10000) * r0.xyz;
  r0.xyz = r1.xyz * (1 - r0.w) + r0.xyz;
  o0.rgb = renodx::color::pq::Encode(r0.rgb, 1.f);
  o0.w = 1;
  return;
}
