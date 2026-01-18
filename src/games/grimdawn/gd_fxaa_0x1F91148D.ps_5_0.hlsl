#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 17 01:55:26 2026

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
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 untonemapped;

  if (CUSTOM_ANTI_ALIASING == 1) {
    r0.z = 0;
    r0.xyw = -pixelSize.yxy;
    r0.zw = v1.xy + r0.zw;
    r1.xyz = baseSampler.Sample(baseSampler_s, r0.zw).xyz;
    r2.x = -pixelSize.x;
    r2.yw = float2(0, 0);
    r3.xy = v1.xy + r2.xy;
    r3.xyz = baseSampler.Sample(baseSampler_s, r3.xy).xyz;
    r4.xyz = baseSampler.Sample(baseSampler_s, v1.xy).xyz;
    r2.z = pixelSize.x;
    r5.xy = v1.xy + r2.zw;
    r5.xyz = baseSampler.Sample(baseSampler_s, r5.xy).xyz;
    r6.x = 0;
    r6.y = pixelSize.y;
    r6.zw = v1.xy + r6.xy;
    r7.xyz = baseSampler.Sample(baseSampler_s, r6.zw).xyz;
    r8.x = r1.x * 1.9632107 + r1.y;
    r9.x = r3.x * 1.9632107 + r3.y;
    r1.w = r4.x * 1.9632107 + r4.y;
    r9.y = r5.x * 1.9632107 + r5.y;
    r8.y = r7.x * 1.9632107 + r7.y;
    r8.zw = min(r9.xy, r8.xy);
    r3.w = min(r8.z, r8.w);
    r3.w = min(r3.w, r1.w);
    r8.zw = max(r9.xy, r8.xy);
    r4.w = max(r8.z, r8.w);
    r4.w = max(r4.w, r1.w);
    r3.w = r4.w + -r3.w;
    r1.xyz = r3.xyz + r1.xyz;
    r1.xyz = r1.xyz + r4.xyz;
    r1.xyz = r1.xyz + r5.xyz;
    r1.xyz = r1.xyz + r7.xyz;
    r3.x = r9.x + r8.x;
    r3.x = r3.x + r9.y;
    r3.x = r3.x + r8.y;
    r3.x = r3.x * 0.25 + -r1.w;
    r3.y = cmp(r3.w != 0.000000);
    r3.x = abs(r3.x) / r3.w;
    r3.x = -0.25 + r3.x;
    r3.x = max(0, r3.x);
    r3.x = 1.33333337 * r3.x;
    r3.x = r3.y ? r3.x : 0;
    r3.x = min(0.75, r3.x);
    r4.xyzw = r2.xyzw + r0.zwzw;
    r3.yzw = baseSampler.Sample(baseSampler_s, r4.xy).xyz;
    r4.xyz = baseSampler.Sample(baseSampler_s, r4.zw).xyz;
    r5.xyzw = r6.zwzw + r2.xyzw;
    r7.xyz = baseSampler.Sample(baseSampler_s, r5.xy).xyz;
    r5.xyz = baseSampler.Sample(baseSampler_s, r5.zw).xyz;
    r10.xyz = r4.xyz + r3.yzw;
    r10.xyz = r10.xyz + r7.xyz;
    r10.xyz = r10.xyz + r5.xyz;
    r1.xyz = r10.xyz + r1.xyz;
    r0.z = r3.y * 1.9632107 + r3.z;
    r0.w = r4.x * 1.9632107 + r4.y;
    r2.x = r7.x * 1.9632107 + r7.y;
    r2.y = r5.x * 1.9632107 + r5.y;
    r3.yz = float2(-0.5, -0.5) * r8.xy;
    r3.y = r0.z * 0.25 + r3.y;
    r3.y = r0.w * 0.25 + r3.y;
    r4.xy = float2(-0.5, -0.5) * r9.xy;
    r3.w = r9.x * 0.5 + -r1.w;
    r3.w = r9.y * 0.5 + r3.w;
    r3.y = abs(r3.y) + abs(r3.w);
    r3.z = r2.x * 0.25 + r3.z;
    r3.z = r2.y * 0.25 + r3.z;
    r3.y = r3.y + abs(r3.z);
    r0.z = r0.z * 0.25 + r4.x;
    r0.z = r2.x * 0.25 + r0.z;
    r2.x = r8.x * 0.5 + -r1.w;
    r2.x = r8.y * 0.5 + r2.x;
    r0.z = abs(r2.x) + abs(r0.z);
    r0.w = r0.w * 0.25 + r4.y;
    r0.w = r2.y * 0.25 + r0.w;
    r0.z = r0.z + abs(r0.w);
    r0.z = cmp(r0.z >= r3.y);
    r4.x = r0.z ? r0.x : r0.y;
    r0.xy = r0.zz ? r8.xy : r9.xy;
    r2.xy = r0.xy + -r1.ww;
    r4.yz = abs(r2.xy);
    r0.xy = r0.xy + r1.ww;
    r5.xy = float2(0.5, 0.5) * r0.xy;
    r0.x = cmp(r4.y < r4.z);
    r5.z = -r4.x;
    r5.w = r4.z;
    r4.w = r5.x;
    r0.xyw = r0.xxx ? r5.yzw : r4.wxy;
    r2.xy = float2(0.5, 0.25) * r0.yw;
    r0.w = r0.z ? 0 : r2.x;
    r4.x = v1.x + r0.w;
    r0.w = r0.z ? r2.x : 0;
    r4.y = v1.y + r0.w;
    r2.xz = r0.zz ? r2.zw : r6.xy;
    r3.yz = r2.xz * float2(-1, -1) + r4.xy;
    r4.zw = r2.xz;
    r4.xy = r4.xy + r4.zw;
    r5.xy = r3.yz;
    r5.zw = r4.xy;
    r0.w = r0.x;
    r2.w = r0.x;
    r3.w = 0;
    r6.xy = float2(0, 0);
    while (true) {
      r6.z = cmp((int)r6.y >= 32);
      if (r6.z != 0) break;
      if (r3.w == 0) {
        r6.zw = baseSampler.SampleLevel(baseSampler_s, r5.xy, 0).xy;
        r6.z = r6.z * 1.9632107 + r6.w;
      } else {
        r6.z = r0.w;
      }
      if (r6.x == 0) {
        r7.xy = baseSampler.SampleLevel(baseSampler_s, r5.zw, 0).xy;
        r6.w = r7.x * 1.9632107 + r7.y;
      } else {
        r6.w = r2.w;
      }
      r7.x = r6.z + -r0.x;
      r7.x = cmp(abs(r7.x) >= r2.y);
      r3.w = (int)r3.w | (int)r7.x;
      r7.x = r6.w + -r0.x;
      r7.x = cmp(abs(r7.x) >= r2.y);
      r6.x = (int)r6.x | (int)r7.x;
      r7.x = (int)r3.w & (int)r6.x;
      if (r7.x != 0) {
        r0.w = r6.z;
        r2.w = r6.w;
        break;
      }
      r7.xy = r5.xy + -r2.xz;
      r5.xy = r3.ww ? r5.xy : r7.xy;
      r7.xy = r5.zw + r4.zw;
      r5.zw = r6.xx ? r5.zw : r7.xy;
      r6.y = (int)r6.y + 1;
      r0.w = r6.z;
      r2.w = r6.w;
    }
    r2.xy = v1.xy + -r5.xy;
    r2.x = r0.z ? r2.x : r2.y;
    r2.yz = -v1.xy + r5.zw;
    r2.y = r0.z ? r2.y : r2.z;
    r2.z = cmp(r2.x < r2.y);
    r0.w = r2.z ? r0.w : r2.w;
    r1.w = r1.w + -r0.x;
    r1.w = cmp(r1.w < 0);
    r0.x = r0.w + -r0.x;
    r0.x = cmp(r0.x < 0);
    r0.x = cmp((int)r1.w == (int)r0.x);
    r0.x = r0.x ? 0 : r0.y;
    r0.y = r2.y + r2.x;
    r0.w = min(r2.y, r2.x);
    r0.y = -1 / r0.y;
    r0.y = r0.w * r0.y + 0.5;
    r0.x = r0.y * r0.x;
    r0.y = r0.z ? 0 : r0.x;
    r0.x = r0.z ? r0.x : 0;
    r2.xy = v1.xy + r0.yx;
    r0.xyz = baseSampler.Sample(baseSampler_s, r2.xy).xyz;

    r1.xyz = r1.xyz * float3(0.111111112, 0.111111112, 0.111111112) + -r0.xyz;
    o0.xyz = r3.xxx * r1.xyz + r0.xyz;

    untonemapped = o0.xyz;
  }
  else {
    untonemapped = baseSampler.Sample(baseSampler_s, v1.xy).xyz;
  }

  float3 untonemapped_linear = renodx::color::srgb::DecodeSafe(untonemapped);
  o0.rgb = CustomTonemap(untonemapped_linear, v1.xy);
  o0.w = 1;
  return;
}
