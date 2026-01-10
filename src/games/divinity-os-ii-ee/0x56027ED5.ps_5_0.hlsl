// ---- Created with 3Dmigoto v1.4.1 on Sat Dec 27 06:39:35 2025
// 5-tap separable Gaussian-ish blur accumulate. Samples Base at five UVs
// (v1.xy center, v2.xy/v2.zw, v3.xy/v3.zw) with weights matching a normalized
// kernel: 0.2270 center, 0.3162 for near taps, 0.07027 for far taps.

SamplerState LinearClampSampler_s : register(s0);
Texture2D<float4> Base : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TexCoord0,
  float4 v2 : TexCoord1,
  float4 v3 : TexCoord2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Near tap 1
  r0.xyzw = Base.Sample(LinearClampSampler_s, v2.xy).xyzw;
  r0.xyzw = float4(0.31621623,0.31621623,0.31621623,0.31621623) * r0.xyzw;
  // Center tap
  r1.xyzw = Base.Sample(LinearClampSampler_s, v1.xy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.227027029,0.227027029,0.227027029,0.227027029) + r0.xyzw;
  // Near tap 2
  r1.xyzw = Base.Sample(LinearClampSampler_s, v2.zw).xyzw;
  r0.xyzw = r1.xyzw * float4(0.31621623,0.31621623,0.31621623,0.31621623) + r0.xyzw;
  // Far tap 1
  r1.xyzw = Base.Sample(LinearClampSampler_s, v3.xy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.0702702701,0.0702702701,0.0702702701,0.0702702701) + r0.xyzw;
  // Far tap 2
  r1.xyzw = Base.Sample(LinearClampSampler_s, v3.zw).xyzw;
  o0.xyzw = r1.xyzw * float4(0.0702702701,0.0702702701,0.0702702701,0.0702702701) + r0.xyzw;
  return;
}