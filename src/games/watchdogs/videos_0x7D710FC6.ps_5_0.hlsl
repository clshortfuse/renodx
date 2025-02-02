#include "./common.hlsl"

cbuffer Primitive : register(b0){
  float4 _ColorMultiplier : packoffset(c0);
  float4x4 _SecondTextureUVTransform : packoffset(c1);
  float4x4 _Transform : packoffset(c5);
  float4 _VideoTextureUnpack[8] : packoffset(c9);
  float _CustomExposureScale : packoffset(c17);
  float _VolumeTextureSizeZ : packoffset(c17.y);
}

SamplerState Primitive__DiffuseSampler0__SampObj___s : register(s0);
Texture2D<float4> Primitive__DiffuseSampler0__TexObj__ : register(t0);

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float2 v1 : TEXCOORD1,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = frac(v1.xy);
  r1.xy = r0.xy * _VideoTextureUnpack[2].xy + _VideoTextureUnpack[2].zw;
  r1.zw = r0.xy * _VideoTextureUnpack[3].xy + _VideoTextureUnpack[3].zw;
  r0.xy = r0.xy * _VideoTextureUnpack[0].xy + _VideoTextureUnpack[0].zw;
  r0.xy = max(_VideoTextureUnpack[4].xy, r0.xy);
  r0.xy = min(_VideoTextureUnpack[5].xy, r0.xy);
  r0.x = Primitive__DiffuseSampler0__TexObj__.Sample(Primitive__DiffuseSampler0__SampObj___s, r0.xy).w;
  r1.xyzw = max(_VideoTextureUnpack[6].xyzw, r1.xyzw);
  r1.xyzw = min(_VideoTextureUnpack[7].xyzw, r1.xyzw);
  r0.y = Primitive__DiffuseSampler0__TexObj__.Sample(Primitive__DiffuseSampler0__SampObj___s, r1.zw).w;
  r0.z = Primitive__DiffuseSampler0__TexObj__.Sample(Primitive__DiffuseSampler0__SampObj___s, r1.xy).w;
  r1.xyz = float3(0,-0.391448975,2.01782227) * r0.yyy;
  r0.yzw = r0.zzz * float3(1.59579468,-0.813476563,0) + r1.xyz;
  r0.xyz = r0.xxx * float3(1.16412354,1.16412354,1.16412354) + r0.yzw;
  r0.xyz = float3(-0.87065506,0.529705048,-1.08166885) + r0.xyz;
  r0.w = 1;
  o0.xyzw = v0.xyzw * r0.xyzw;
  o0 = saturate(o0);
  o0.rgb = InverseToneMap(o0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}