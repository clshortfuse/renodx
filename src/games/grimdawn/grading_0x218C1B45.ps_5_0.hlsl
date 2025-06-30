#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Tue Feb 11 16:39:33 2025

cbuffer heynottoorough : register(b0) {
  float dofDistance : packoffset(c0);
  float dofRange : packoffset(c0.y);
  float brightnessAdjustment : packoffset(c0.z);
  float contrastAdjustment : packoffset(c0.w);
  float saturationAdjustment : packoffset(c1);
  float farClipDist : packoffset(c1.y);
  float ssaoStrength : packoffset(c1.z);
  float ssaoScale : packoffset(c1.w);
  float saturation : packoffset(c2);
  float windStrength : packoffset(c2.y);
  float bladeHeight : packoffset(c2.z);
  float highlight : packoffset(c2.w);
  float zNear : packoffset(c3);
  float zFar : packoffset(c3.y);
  float outlineThickness : packoffset(c3.z);
  float blendedGlobalFadeFactor : packoffset(c3.w);
  float iceyAlphaMultiplier : packoffset(c4);
  float iceyFactor : packoffset(c4.y);
  float dissolveValue : packoffset(c4.z);
  float rate : packoffset(c4.w);
  float offset : packoffset(c5);
  float minScale : packoffset(c5.y);
  float maxScale : packoffset(c5.z);
  float invBlockSize : packoffset(c5.w);
  float dShadowBias : packoffset(c6);
  float pShadowBias : packoffset(c6.y);
  float ambientIntensity : packoffset(c6.z);
  float rimLight : packoffset(c6.w);
  float xRippleAmplitude : packoffset(c7);
  float yRippleAmplitude : packoffset(c7.y);
  float zRippleAmplitude : packoffset(c7.z);
  float filmThickness : packoffset(c7.w);
  float normalPush : packoffset(c8);
  float fresnelAmount : packoffset(c8.y);
  float distortion : packoffset(c8.z);
  float tint : packoffset(c8.w);
  float dSpecularIntensity : packoffset(c9);
  float pSpecularIntensity : packoffset(c9.y);
  float specularIntensity : packoffset(c9.z);
  float xColorScrollSpeed : packoffset(c9.w);
  float yColorScrollSpeed : packoffset(c10);
  float xAlphaScrollSpeed : packoffset(c10.y);
  float yAlphaScrollSpeed : packoffset(c10.z);
  float smoothness : packoffset(c10.w);
  float maxDepth : packoffset(c11);
  float textureScroll : packoffset(c11.y);
  float2 screenSize : packoffset(c11.z);
  float2 scrollRate : packoffset(c12);
  float2 bumpScrollRate : packoffset(c12.z);
  float2 colorScrollSpeed : packoffset(c13);
  float2 alphaScrollSpeed : packoffset(c13.z);
  float2 scrollDiffuse1 : packoffset(c14);
  float2 scrollAlpha1 : packoffset(c14.z);
  float2 scrollBump : packoffset(c15);
  float2 scrollDiffuse2 : packoffset(c15.z);
  float2 scrollRate1 : packoffset(c16);
  float2 scrollRate2 : packoffset(c16.z);
  float2 screenTextureScale : packoffset(c17);
  float2 sampleOffset0 : packoffset(c17.z);
  float2 sampleOffset1 : packoffset(c18);
  float2 sampleOffset2 : packoffset(c18.z);
  float2 sampleOffset3 : packoffset(c19);
  float2 sampleOffset4 : packoffset(c19.z);
  float2 sampleOffset5 : packoffset(c20);
  float2 sampleOffset6 : packoffset(c20.z);
  float2 sampleOffset7 : packoffset(c21);
  float2 pixelSize : packoffset(c21.z);
  float2 planes : packoffset(c22);
  float2 invNoiseTexSize : packoffset(c22.z);
  float2 textureDirection : packoffset(c23);
  float2 textureOffset : packoffset(c23.z);
  float2 invViewportSize : packoffset(c24);
  float3 red : packoffset(c25);
  float3 green : packoffset(c26);
  float3 blue : packoffset(c27);
  float3 surfaceParams : packoffset(c28);
  float3 waterColor : packoffset(c29);
  float3 surfaceNormal : packoffset(c30);
  float3 waveColor : packoffset(c31);
  float3 opaqueColor : packoffset(c32);
  float3 upVector : packoffset(c33);
  float3 terrainOffset : packoffset(c34);
  float3 terrainMapColor : packoffset(c35);
  float3 regionToSceneOffset : packoffset(c36);
  float3 dissolveColor : packoffset(c37);
  float3 ambientColor : packoffset(c38);
  float3 velocity : packoffset(c39);
  float3 cameraDirection : packoffset(c40);
  float3 depthFogParams : packoffset(c41);
  float3 heightFogParams : packoffset(c42);
  float3 fogColor : packoffset(c43);
  float3 lightDirection : packoffset(c44);
  float4 transparencyValue : packoffset(c45);
  float4 outlineColor : packoffset(c46);
  float4 extractConst : packoffset(c47);
  float4 sampleWeight0 : packoffset(c48);
  float4 sampleWeight1 : packoffset(c49);
  float4 blendFactor : packoffset(c50);
  float4 level : packoffset(c51);
  float4 depthParams : packoffset(c52);
  float4 textureScale : packoffset(c53);
  float4x4 worldToScreenMatrix : packoffset(c54);
  float4x4 clipToViewSpaceMatrix : packoffset(c58);
  float4x4 worldToObjectMatrix : packoffset(c62);
  float4 clipPlane : packoffset(c66);
  float4 terrainParams : packoffset(c67);
}

SamplerState baseSampler_s : register(s0);
Texture2D<float4> baseSampler : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = baseSampler.Sample(baseSampler_s, v2.xy).xyzw;

  float3 ungraded = r0.xyz;

  r1.x = dot(r0.xyz, float3(0.300000012, 0.589999974, 0.109999999));
  r1.xyz = r1.xxx + -r0.xyz;
  r1.xyz = saturationAdjustment * r1.xyz + r0.xyz;
  r2.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
  r1.xyz = r2.xyz * contrastAdjustment + r1.xyz;

  // original output code
  // r0.xyz = saturate(brightnessAdjustment + r1.xyz);
  // o0.xyzw = v1.xyzw * r0.xyzw;

  r0.xyz = brightnessAdjustment + r1.xyz;
  float3 vanilla_graded = saturate(r0.xyz) * v1.xyz;

  float3 graded = r0.rgb * v1.rgb;

  graded = renodx::color::srgb::DecodeSafe(graded);
  ungraded = renodx::color::srgb::DecodeSafe(ungraded);
  vanilla_graded = renodx::color::srgb::DecodeSafe(vanilla_graded);
  graded = lerp(ungraded, graded, CUSTOM_COLOR_GRADING);

  float3 outputColor = vanilla_graded;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    if (CUSTOM_TONE_MAP_CONFIGURATION == 0) {
      outputColor = renodx::draw::ToneMapPass(graded, vanilla_graded);
    }
    else {
      outputColor = renodx::draw::ToneMapPass(graded);
    }
  }
  o0.rgb = renodx::draw::RenderIntermediatePass(outputColor);
  o0.w = v1.w * r0.w;
  return;
}
