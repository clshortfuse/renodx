// ---- Created with 3Dmigoto v1.4.1 on Tue Oct 14 22:53:55 2025

SamplerState sampler_0_s : register(s0);
Texture2D<float4> texture_0 : register(t0);


// 3Dmigoto declarations
#define cmp -


// Basic sprite/line shader: sample texture and modulate by vertex colour.
void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Fetch texel and multiply by colour.
  r0.xyzw = texture_0.Sample(sampler_0_s, v2.xy).xyzw;
  o0.xyzw = v1.xyzw * r0.xyzw;
  return;
}