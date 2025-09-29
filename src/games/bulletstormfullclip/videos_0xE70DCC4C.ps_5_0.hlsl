#include "./common.hlsl"

cbuffer _Globals : register(b0){
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  bool bDecompressSceneColor : packoffset(c4);
  float4 TextureComponentReplicate : packoffset(c5);
  float4 TextureComponentReplicateAlpha : packoffset(c6);
  bool ShouldSwizzle : packoffset(c7);
  float Gamma : packoffset(c7.y);
  float ClipRef : packoffset(c7.z);
  float SmoothWidth : packoffset(c7.w);
  bool EnableShadow : packoffset(c8);
  float2 ShadowDirection : packoffset(c8.y);
  float4 ShadowColor : packoffset(c9);
  float ShadowSmoothWidth : packoffset(c10);
  bool EnableGlow : packoffset(c10.y);
  float4 GlowColor : packoffset(c11);
  float2 GlowOuterRadius : packoffset(c12);
  float2 GlowInnerRadius : packoffset(c12.z);
}
SamplerState InTextureSampler_s : register(s0);
Texture2D<float4> InTexture : register(t0);

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2,
  out float4 o3 : SV_Target3)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r1.xyzw = InTexture.Sample(InTextureSampler_s, v0.xy).xyzw;
  r1.xz = ShouldSwizzle ? r1.zx : r1.xz;
  r0.y = dot(r1.xyzw, TextureComponentReplicate.xyzw);
  r0.xyzw = (TextureComponentReplicate.x != 0.f || TextureComponentReplicate.y != 0.f
    || TextureComponentReplicate.z != 0.f || TextureComponentReplicate.w != 0.f) ? r0.yyyy : r1.xyzw;
  r0.w = dot(r0.xyzw, TextureComponentReplicateAlpha.xyzw);
  o0.xyzw = v1.xyzw * r0.xyzw;
  o0.xyz = max(0.f, o0.xyz);
  o0.w = saturate(o0.w);
  o1.xyzw = float4(0,0,0,0);
  o2.xyzw = float4(0,0,0,0);
  o3.xyzw = float4(0,0,0,0);
  o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  o0.xyz = PostToneMapScale(o0.xyz);
  return;
}