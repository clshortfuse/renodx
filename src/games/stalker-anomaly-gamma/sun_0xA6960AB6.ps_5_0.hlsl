// ---- Created with 3Dmigoto v1.4.1 on Wed Oct 15 21:57:25 2025

SamplerState smp_base_s : register(s0);
Texture2D<float4> s_base : register(t0);

// Brightness multiplier
#define SUN_BRIGHTNESS 3.0f


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = s_base.Sample(smp_base_s, v0.xy).xyzw;
  o0.rgb = (v1.rgb * r0.rgb) * SUN_BRIGHTNESS;
  o0.a = v1.a * r0.a;
  return;
}