// ---- Created with 3Dmigoto v1.3.16 on Tue Dec  3 16:00:09 2024

SamplerState TextureSamplerState_s : register(s0);
Texture2D<float4> TextureSampler : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float3 v3 : TEXCOORD2,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = log2(v1.xyz);
  r0.xyz = float3(0.588235319,0.588235319,0.588235319) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = saturate(v1.xyz * float3(0.300000012,0.300000012,0.300000012) + r0.xyz);
  r0.xyz = float3(3.14159012,3.14159012,3.14159012) * r0.xyz;
  r0.xyz = cos(r0.xyz);
  o0.xyz = r0.xyz * float3(-0.5,-0.5,-0.5) + float3(0.5,0.5,0.5);
  r0.xyzw = TextureSampler.Sample(TextureSamplerState_s, v2.xy).xyzw;
  o0.w = v1.w * r0.w;
  o0 = saturate(o0);
  return;
}