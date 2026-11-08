#include "./hdr.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Sat Oct 03 23:02:43 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = log2(r0.xyz);
  o0.w = r0.w;
  r0.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r0.xyz;
  r0.xyz = -r0.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(6.27739477,6.27739477,6.27739477) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(10000,10000,10000) * r0.xyz;
  // Bound the actual display output after temporal effects and UI blending.
  if (RENODX_TONE_MAP_TYPE != CODWW2_TONE_MAP_TYPE_VANILLA && RENODX_PEAK_WHITE_NITS > 0.f) {
    r0.xyz = CODWW2LimitPeak(r0.xyz);
  }
  r1.x = dot(float3(1.66050005,-0.587700009,-0.072800003), r0.xyz);
  r1.y = dot(float3(-0.124600001,1.13300002,-0.0083999997), r0.xyz);
  r1.z = dot(float3(-0.0182000007,-0.100599997,1.11870003), r0.xyz);
  o0.xyz = float3(0.0125000002,0.0125000002,0.0125000002) * r1.xyz;
  return;
}
