#include "./common.hlsl"

cbuffer PostFxGeneric : register(b0){
  float4 _Color : packoffset(c0);
  float4 _QuadParams : packoffset(c1);
  float4 _Random : packoffset(c2);
  float4 _UVScaleOffset : packoffset(c3);
  float2 _Tiling : packoffset(c4);
  float _Intensity : packoffset(c4.z);
  float _Parameter1 : packoffset(c4.w);
  float _Parameter2 : packoffset(c5);
  float _Parameter3 : packoffset(c5.y);
  float _Parameter4 : packoffset(c5.z);
}
SamplerState PostFxGeneric__SrcSampler__SampObj___s : register(s0);
Texture2D<float4> PostFxGeneric__SrcSampler__TexObj__ : register(t0);

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + _Color.xyzw;
  r0.xyzw = _Color.wwww * r0.xyzw + float4(0.5,0.5,0.5,0.5);
  r1.xyzw = PostFxGeneric__SrcSampler__TexObj__.Sample(PostFxGeneric__SrcSampler__SampObj___s, v0.xy).xyzw;
      if(injectedData.toneMapGammaCorrection == 2.f){
    r1.rgb = renodx::color::gamma::DecodeSafe(r1.rgb, 2.4f);
    } else if(injectedData.toneMapGammaCorrection == 1.f){
    r1.rgb = renodx::color::gamma::DecodeSafe(r1.rgb, 2.2f);
    } else {
    r1.rgb = renodx::color::srgb::DecodeSafe(r1.rgb);
    }
  r0.xyzw = r1.xyzw * r0.xyzw;
  o0.xyzw = r0.xyzw + r0.xyzw;
      if(injectedData.toneMapGammaCorrection == 2.f){
    o0.rgb = renodx::color::gamma::EncodeSafe(o0.rgb, 2.4f);
    } else if(injectedData.toneMapGammaCorrection == 1.f){
    o0.rgb = renodx::color::gamma::EncodeSafe(o0.rgb, 2.2f);
    } else {
    o0.rgb = renodx::color::srgb::EncodeSafe(o0.rgb);
    }
  return;
}