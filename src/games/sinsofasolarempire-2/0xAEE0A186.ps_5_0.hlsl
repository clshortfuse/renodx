// ---- Created with 3Dmigoto v1.4.1 on Tue Oct 14 22:37:26 2025

SamplerState sampler_0_s : register(s0);
Texture2D<float4> texture_0 : register(t0);


// 3Dmigoto declarations
#define cmp -


// Simple UI sprite shader: sample texture, modulate with vertex colour, lift dark values for stylised look.
void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Fetch sprite texel.
  r0.xyzw = texture_0.Sample(sampler_0_s, v2.xy).xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw; // Apply vertex tint.
  r0.xyz = max(float3(0,0,0), r0.xyz); // Remove SDR clamp, allow HDR
  o0.w = r0.w;
  r0.xyz = r0.xyz * float3(0.509803951,0.509803951,0.509803951) + float3(0.117647059,0.117647059,0.117647059); // Lift mids.
  r0.x = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999)); // Convert to luma.
  o0.xyz = float3(-0.0713803917,0.0243058801,0.0643058866) + r0.xxx; // Apply stylised colour offset.
  return;
}