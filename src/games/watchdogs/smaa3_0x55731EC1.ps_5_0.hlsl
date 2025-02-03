#include "./common.hlsl"

cbuffer PostFxAntialias : register(b0){
  float4 _AntiAliasQuadParams : packoffset(c0);
  float4x4 _CurrInvViewMatrix : packoffset(c1);
  float4 _Jitter : packoffset(c5);
  float4 _Params0 : packoffset(c6);
  float4 _Params1 : packoffset(c7);
  float4x4 _PrevViewProjMatrix : packoffset(c8);
  float4 _Resolution : packoffset(c12);
}

SamplerState LinearSampler_s : register(s0);
Texture2D<float4> PostFxAntialias__BlendTexture__TexObj__ : register(t0);
Texture2D<float4> PostFxAntialias__FrameBufferTexture__TexObj__ : register(t1);

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float4 v3 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = PostFxAntialias__BlendTexture__TexObj__.SampleLevel(LinearSampler_s, v2.xy, 0).xz;
  r1.y = PostFxAntialias__BlendTexture__TexObj__.SampleLevel(LinearSampler_s, v1.zw, 0).y;
  r1.w = PostFxAntialias__BlendTexture__TexObj__.SampleLevel(LinearSampler_s, v1.xy, 0).w;
  r1.xz = r0.xy;
  r0.z = dot(r1.xyzw, float4(1,1,1,1));
  r0.z = cmp(r0.z < 9.99999975e-06);
  if (r0.z != 0) {
    o0.xyzw = PostFxAntialias__FrameBufferTexture__TexObj__.SampleLevel(LinearSampler_s, v2.xy, 0).xyzw;
  } else {
    r0.zw = cmp(r1.zx < r1.wy);
    r0.xw = r0.zw ? r1.wy : -r0.yx;
    r1.x = cmp(abs(r0.w) < abs(r0.x));
    r0.yz = float2(0,0);
    r0.xy = r1.xx ? r0.xy : r0.zw;
    r0.xy = r0.xy * _Resolution.zw + v2.xy;
    o0.xyzw = PostFxAntialias__FrameBufferTexture__TexObj__.SampleLevel(LinearSampler_s, r0.xy, 0).xyzw;
  }
  return;
}