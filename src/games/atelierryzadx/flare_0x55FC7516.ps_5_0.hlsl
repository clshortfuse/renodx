#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 13 18:40:12 2025

cbuffer _Globals : register(b0)
{
  row_major float4x4 mRotation : packoffset(c0);
  float fFlareCurveCoefficient : packoffset(c4);
  float fFlareCurveCenter : packoffset(c4.y);
  float fFlareAmount : packoffset(c4.z);
  float fIntensity : packoffset(c4.w);
  float fFlareShadowInfluenceRatio : packoffset(c5);
  float fParaffinCurveCoefficient : packoffset(c5.y);
  float fParaffinCurveCenter : packoffset(c5.z);
  float fParaffinAmount : packoffset(c5.w);
  float fParaffinShadowInfluenceRatio : packoffset(c6);
  float4 vFlareColor : packoffset(c7);
  float4 vParaffinColor : packoffset(c8);
}

SamplerState smplScene_s : register(s0);
SamplerState smplShadowIntensityCurrent_s : register(s1);
Texture2D<float4> smplScene_Tex : register(t0);
Texture2D<float4> smplShadowIntensityCurrent_Tex : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.yz = mRotation._m10_m11 * r0.yy;
  r0.xy = r0.xx * mRotation._m00_m01 + r0.yz;
  r0.xy = mRotation._m20_m21 + r0.xy;
  r0.xy = mRotation._m30_m31 + r0.xy;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.z = fParaffinCurveCenter + -r0.x;
  r0.z = r0.z * r0.z;
  r0.z = fParaffinCurveCoefficient * r0.z + r0.y;
  r0.w = 1 + -fParaffinAmount;
  r0.z = r0.z + -r0.w;
  r0.z = max(0, r0.z);
  r0.z = min(255, r0.z);
  r0.z = fIntensity * r0.z;
  r0.w = saturate(fParaffinShadowInfluenceRatio);
  r1.x = smplShadowIntensityCurrent_Tex.Sample(smplShadowIntensityCurrent_s, float2(0,0)).x;
  r0.w = r1.x * r0.w;
  r0.z = r0.z * r0.w;
  r0.z = vParaffinColor.w * r0.z;
  r1.yzw = float3(-1,-1,-1) + vParaffinColor.xyz;
  r1.yzw = r0.zzz * r1.yzw + float3(1,1,1);
  r0.x = fFlareCurveCenter + -r0.x;
  r0.x = r0.x * r0.x;
  r0.x = fFlareCurveCoefficient * r0.x + r0.y;
  r0.x = fFlareAmount + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = min(255, r0.x);
  r0.x = fIntensity * r0.x;
  r0.y = saturate(fFlareShadowInfluenceRatio);
  r0.y = -r1.x * r0.y + 1;
  r0.x = r0.x * r0.y;
  r0.yzw = vFlareColor.xyz * vFlareColor.www;
  r2.xyzw = smplScene_Tex.Sample(smplScene_s, v1.xy).xyzw;

  r2.rgb = renodx::draw::InvertIntermediatePass(r2.rgb);
  r2.rgb = renodx::color::srgb::EncodeSafe(r2.rgb);

  r0.xyz = r0.yzw * r0.xxx * CUSTOM_FLARE_EFFECT + r2.xyz;
  o0.w = r2.w;
  o0.xyz = r0.xyz * r1.yzw;  // r1.yzw = vignette bottom; r0.xyz = sun flare top

  o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

  return;
}