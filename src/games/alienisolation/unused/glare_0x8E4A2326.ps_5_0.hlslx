// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:43:23 2024

SamplerState LightingSampler_SMP_s : register(s0);
SamplerState GlareSampler_SMP_s : register(s1);
Texture2D<float4> LightingSampler_TEX : register(t0);
Texture2D<float4> GlareSampler_TEX : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = LightingSampler_TEX.SampleLevel(LightingSampler_SMP_s, v1.xy, 0).xyz;
  r1.xyz = GlareSampler_TEX.Sample(GlareSampler_SMP_s, v1.xy).xyz;
  o0.xyz = r1.xyz * r1.xyz + r0.xyz;
  o0.w = 0;
  return;
}
