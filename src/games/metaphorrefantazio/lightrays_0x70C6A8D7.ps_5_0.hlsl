// ---- Created with 3Dmigoto v1.3.16 on Thu Sep 26 18:25:59 2024
#include "./shared.h"
#include "./tonemapper.hlsl"

cbuffer GFD_PSCONST_SYSTEM : register(b0) {
  float2 resolution : packoffset(c0);
  float2 resolutionRev : packoffset(c0.z);
  float4x4 mtxView : packoffset(c1);
  float4x4 mtxInvView : packoffset(c5);
  float4x4 mtxProj : packoffset(c9);
  float4x4 mtxInvProj : packoffset(c13);
  float4 invProjParams : packoffset(c17);
}

cbuffer GFD_PSCONST_MATERIAL : register(b1) {
  float4 matBaseColor : packoffset(c0);
  float4 matEmissiveColor : packoffset(c1);
  float matBloomIntensity : packoffset(c2);
  float atestRef : packoffset(c2.y);
  float distortionPower : packoffset(c2.z);
  float dissolveThreshold : packoffset(c2.w);
  float rimTransPower : packoffset(c3);
  float lerpBlendRate : packoffset(c3.y);
  float fittingTile : packoffset(c3.z);
  float multiFittingTile : packoffset(c3.w);
  float matBrightness : packoffset(c4);
}

SamplerState linearWrapSampler_s : register(s12);
Texture2D<float4> baseTexture : register(t0);
Texture2D<float4> viewSpaceDepthTexture : register(t3);
Texture2D<float4> multipleTexture : register(t4);
Texture2D<float4> alphaTexture : register(t9);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0
          : SV_POSITION0, float3 v1
          : NORMAL0, float3 v2
          : BINORMAL0, float4 v3
          : COLOR0, float2 v4
          : TEXCOORD0, float2 w4
          : TEXCOORD9, float2 v5
          : TEXCOORD10, float w5
          : TEXCOORD2, float4 v6
          : TEXCOORD3, float4 v7
          : TEXCOORD4, out float4 o0
          : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = multipleTexture.Sample(linearWrapSampler_s, v5.xy).xy;
  r0.z = -dissolveThreshold + r0.x;
  r0.z = cmp(r0.z < 0);
  if (r0.z != 0)
    discard;
  r0.z = dot(v1.xyz, v1.xyz);
  r0.z = rsqrt(r0.z);
  r1.xyz = v1.xyz * r0.zzz;
  r0.z = dot(-v2.xyz, -v2.xyz);
  r0.z = rsqrt(r0.z);
  r2.xyz = -v2.xyz * r0.zzz;
  r0.z = dot(r2.xyz, r1.xyz);
  r0.z = saturate(1 + -r0.z);
  r0.z = 1 + -r0.z;
  r0.z = log2(r0.z);
  r0.z = rimTransPower * r0.z;
  r0.z = exp2(r0.z);
  r1.xyzw = r0.xyxy * distortionPower + w4.xyxy;
  r0.xy = r0.xy * distortionPower + v5.xy;
  r2.xyzw = multipleTexture.Sample(linearWrapSampler_s, r0.xy).xyzw;
  r0.x = alphaTexture.Sample(linearWrapSampler_s, r1.xy).x;
  r1.xyzw = baseTexture.Sample(linearWrapSampler_s, r1.zw).xyzw;
  r0.x = matBaseColor.w * r0.x;
  r0.x = r1.w * r0.x;
  /* r1.xyz = log2(abs(r1.xyz));
  r1.xyz = float3(2.20000005,2.20000005,2.20000005) * r1.xyz;
  r1.xyz = exp2(r1.xyz); */
  r1.xyz = renodx::color::gamma::DecodeSafe(r1.xyz);

  r1.xyz = matBaseColor.xyz * r1.xyz;
  r0.y = -1 + r2.w;
  /* r2.xyz = log2(abs(r2.xyz));
  r2.xyz = float3(2.20000005,2.20000005,2.20000005) * r2.xyz;
  r2.xyz = exp2(r2.xyz); */
  r2.xyz = renodx::color::gamma::DecodeSafe(r2.xyz);

  r2.xyz = r1.xyz * r2.xyz + -r1.xyz;
  r1.xyz = matEmissiveColor.www * r2.xyz + r1.xyz;
  r1.xyz = matEmissiveColor.xyz + r1.xyz;
  o0.xyz = v3.xyz * r1.xyz;
  r0.y = matEmissiveColor.w * r0.y + 1;
  r0.x = r0.x * r0.y;
  r0.x = r0.x * r0.z;
  r0.x = v3.w * r0.x;
  r0.yz = v6.xy / v6.ww;
  r0.yz = float2(1, 1) + r0.yz;
  r0.y = resolution.x * r0.y;
  r0.z = -r0.z * 0.5 + 1;
  r1.y = resolution.y * r0.z;
  r1.x = 0.5 * r0.y;
  r1.xy = (int2)r1.xy;
  r1.zw = float2(0, 0);
  r0.y = viewSpaceDepthTexture.Load(r1.xyz).x;
  r0.y = -w5.x + r0.y;
  r0.y = saturate(0.0149999997 * r0.y);
  o0.w = r0.x * r0.y;
  return;
}