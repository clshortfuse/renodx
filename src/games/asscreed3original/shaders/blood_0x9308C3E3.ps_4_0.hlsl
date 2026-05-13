// ---- Created with 3Dmigoto v1.3.16 on Wed May 13 19:42:25 2026

cbuffer _Globals : register(b0)
{
  float4 g_ZParams : packoffset(c121);
  float4 g_LerpStart : packoffset(c122);
  float4 g_LerpMask : packoffset(c123);
  float g_FadeFactor : packoffset(c124);
  float4 g_FogColor : packoffset(c16);
  float4 g_FogParams : packoffset(c17);
  float4 g_FogWeatherParams : packoffset(c90);
  float4 g_FogSunBackColor : packoffset(c31);
  float GlowIntensity_1 : packoffset(c128);
  float4 ColorMultiply_2 : packoffset(c129);

  struct
  {
    float m_Alpha;
  } c : packoffset(c130);

}

SamplerState DiffuseMapTextureObject_0_s : register(s0);
Texture2D<float4> DiffuseMapTextureObject_0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : COLOR0,
  float4 v4 : TEXCOORD2,
  uint v5 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = DiffuseMapTextureObject_0.Sample(DiffuseMapTextureObject_0_s, v2.xy).xyzw;
  r1.x = -v1.x + r0.w;
  r1.x = cmp(r1.x < 0);
  if (r1.x != 0) discard;
  r1.xyzw = ColorMultiply_2.xyzw * v3.xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.xyz = saturate(r0.xyz);
  r0.xyz = v4.xyz * r0.xyz;
  r0.xyzw = -g_LerpStart.xyzw + r0.xyzw;
  r1.xyzw = saturate(g_FadeFactor + g_LerpMask.xyzw);
  o0.xyzw = r1.xyzw * r0.xyzw + g_LerpStart.xyzw;

  o0.w = saturate(o0.w);
  return;
}