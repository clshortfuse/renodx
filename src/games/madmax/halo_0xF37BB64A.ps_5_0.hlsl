#include "./common.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Wed Apr  8 10:26:54 2026

cbuffer booleans : register(b4)
{
  bool4 Bools[4] : packoffset(c0);
  float2 AlphaMulRef : packoffset(c4);
}

cbuffer GlobalConstants : register(b0)
{
  float4 Globals[17] : packoffset(c0);
  float4 LightPositions[65] : packoffset(c17);
  float4 LightColors[65] : packoffset(c82);
}

cbuffer cbInstanceConsts : register(b1)
{
  float4 InstanceConsts[11] : packoffset(c0);
}

SamplerState DiffuseTexture_s : register(s0);
SamplerState SkyMaskA_s : register(s5);
SamplerState SkyMaskB_s : register(s6);
SamplerState CloudShadow_s : register(s7);
Texture2D<float4> DiffuseTexture : register(t0);
TextureCube<float4> SkyMaskA : register(t5);
TextureCube<float4> SkyMaskB : register(t6);
Texture2D<float4> CloudShadow : register(t7);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD5,
  float3 v6 : TEXCOORD6,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;
  float haloAlpha;

  r0.xyz = -Globals[5].xyz + v4.xyz;
  r1.xyzw = DiffuseTexture.Sample(DiffuseTexture_s, v1.xy).xyzw;
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    haloAlpha = saturate(r1.w);
    r1.w = pow(haloAlpha, 2);
    r0.w = haloAlpha * -0.200000003 + 1;
  }
  r0.w = r1.w * -0.200000003 + 1;
  r2.xyz = r0.xyz * r0.www;
  r0.xyz = r0.xyz * r0.www + Globals[5].xyz;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = sqrt(r0.w);
  r0.w = InstanceConsts[1].w * r0.w;
  r0.w = 8 * r0.w;
  r0.w = max(1, r0.w);
  r0.w = min(6, r0.w);
  r0.xz = InstanceConsts[1].yz + r0.xz;
  r2.x = Globals[1].w * r0.y;
  r2.y = Globals[3].w * r0.y;
  r0.xy = -r2.xy + r0.xz;
  r0.xy = InstanceConsts[1].ww * r0.xy;
  r0.x = CloudShadow.SampleLevel(CloudShadow_s, r0.xy, r0.w).w;
  r0.x = saturate(InstanceConsts[1].x + r0.x);
  r0.xyz = v5.xyz * r0.xxx + v6.xyz;
  r0.xyz = v2.xyz * r0.xyz;
  r0.w = v2.w;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r1.x = dot(v3.xyz, v3.xyz);
  r1.x = rsqrt(r1.x);
  r1.y = v3.y * r1.x + InstanceConsts[0].w;
  r1.xzw = v3.xyz * r1.xxx;
  r1.y = -0.5 + r1.y;
  r1.y = saturate(0.5 + -r1.y);
  r2.x = SkyMaskB.Sample(SkyMaskB_s, r1.xzw).y;
  r1.x = SkyMaskA.Sample(SkyMaskA_s, r1.xzw).y;
  r1.z = r2.x + -r1.x;
  r1.x = r1.y * r1.z + r1.x;
  r0.w = r1.x * r0.w;
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    r0.x = max(r0.x, max(r0.y, r0.z));
    r0.y = r0.x * 0.80;
    r0.z = r0.x * 0.35;
  }
  o0.xyzw = r0.xyzw;  
  r0.x = AlphaMulRef.x * r0.w + AlphaMulRef.y;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  return;
}