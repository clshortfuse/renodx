// ---- Created with 3Dmigoto v1.4.1 on Sun Apr 20 14:49:31 2025

cbuffer CScenePrimitiveParameterProvider : register(b0)
{
  float4x4 Transform : packoffset(c0);
  float4 BinkUVTransforms : packoffset(c4);
  float4 ScissorRect : packoffset(c5);
  float4 ColorAdd : packoffset(c6);
  float4 ColorAdjustment : packoffset(c7);
  float4 ColorMultiplier : packoffset(c8);
  float TextureAddress : packoffset(c9);
  float Desaturation : packoffset(c9.y);
  float HDRFactor : packoffset(c9.z);
  float OutputOnlyAlpha : packoffset(c9.w);
  float UseAlpha : packoffset(c10);
}

SamplerState Wrap_s : register(s0);
SamplerState Clamp_s : register(s1);
SamplerState Mirror_s : register(s2);
Texture2D<float4> DiffuseSampler0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  uint v3 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -ScissorRect.xy + v0.xy;
  r0.zw = ScissorRect.zw + -v0.xy;
  r0.xy = min(r0.xy, r0.zw);
  r0.x = min(r0.x, r0.y);
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.x = cmp(TextureAddress == 3.000000);
  if (r0.x != 0) {
    r0.xyzw = DiffuseSampler0.Sample(Clamp_s, v2.zw).xyzw;
  } else {
    r1.x = cmp(TextureAddress == 2.000000);
    if (r1.x != 0) {
      r0.xyzw = DiffuseSampler0.Sample(Mirror_s, v2.zw).xyzw;
    } else {
      r0.xyzw = DiffuseSampler0.Sample(Wrap_s, v2.zw).xyzw;
    }
  }
  r1.xyz = v1.xyz * r0.xyz;
  r1.w = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  r0.xyz = -v1.xyz * r0.xyz + r1.www;
  r0.xyz = Desaturation * r0.xyz + r1.xyz;
  r1.x = saturate(OutputOnlyAlpha);
  r1.yzw = v1.www * r0.www + -r0.xyz;
  r0.xyz = r1.xxx * r1.yzw + r0.xyz;
  r0.w = v1.w * r0.w + -1;
  o0.w = UseAlpha * r0.w + 1;
  o0.xyz = HDRFactor * r0.xyz;
  return;
}