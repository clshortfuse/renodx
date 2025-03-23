#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.xyz = float3(1.59579468,-0.813476562,0) * r0.xxx;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = r1.xxx * float3(1.16412354,1.16412354,1.16412354) + r0.xyz;
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r1.xxx * float3(0,-0.391448975,2.01782227) + r0.xyz;
  o0.xyz = float3(-0.87065506,0.529705048,-1.08166885) + r0.xyz;
  o0.w = 1;
  o0.rgb = saturate(o0.rgb);
  o0.rgb = renodx::color::srgb::Decode(o0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}