#include "./common.hlsl"

SamplerState g_tex0_sampler_s : register(s0);
SamplerState g_tex1_sampler_s : register(s1);
SamplerState g_tex2_sampler_s : register(s2);
Texture2D<float4> g_tex0_texture : register(t0);
Texture2D<float4> g_tex1_texture : register(t1);
Texture2D<float4> g_tex2_texture : register(t2);

void main(
    float4 v0: SV_Position0,
    float3 v1: TEXCOORD0,
    float4 v2: COLOR0,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_tex2_texture.Sample(g_tex2_sampler_s, v1.xy).xyzw;
  r0.xyz = float3(0, -0.391448975, 2.01782227) * r0.www;
  r1.xyzw = g_tex1_texture.Sample(g_tex1_sampler_s, v1.xy).xyzw;
  r0.xyz = r1.www * float3(1.59579468, -0.813476563, 0) + r0.xyz;
  r1.xyzw = g_tex0_texture.Sample(g_tex0_sampler_s, v1.xy).xyzw;
  r0.xyz = r1.www * float3(1.16412354, 1.16412354, 1.16412354) + r0.xyz;
  r0.xyz = float3(-0.87065506, 0.529705048, -1.08166885) + r0.xyz;
  r0.xyz = v2.xyz * r0.xyz;
  o0.xyz = r0.xyz;
  o0.w = v2.w;
  o0 = saturate(o0);
  o0.rgb = InverseToneMap(o0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
