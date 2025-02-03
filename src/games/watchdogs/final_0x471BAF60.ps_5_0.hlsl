#include "./common.hlsl"

cbuffer PostFxSimple : register(b0){
  float4 _Color : packoffset(c0);
  float4 _QuadParams : packoffset(c1);
  float4 _UVScaleOffset : packoffset(c2);
  float3 _GammaBrightnessContrastParams : packoffset(c3);
  float2 _TextureSize : packoffset(c4);
  float2 _Tiling : packoffset(c4.z);
}

SamplerState PostFxSimple__TextureSampler__SampObj___s : register(s0);
Texture2D<float4> PostFxSimple__TextureSampler__TexObj__ : register(t0);

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = PostFxSimple__TextureSampler__TexObj__.Sample(PostFxSimple__TextureSampler__SampObj___s, v0.xy).xyzw;
 // r0.xyz = log2(abs(r0.xyz));
  o0.w = r0.w;
  //r0.xyz = _GammaBrightnessContrastParams.xxx * r0.xyz;
  //r0.xyz = exp2(r0.xyz);
  //o0.xyz = r0.xyz * _GammaBrightnessContrastParams.yyy + _GammaBrightnessContrastParams.zzz;
    o0.rgb = FinalizeOutput(r0.rgb);
  return;
}