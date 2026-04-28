// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:43:36 2024

cbuffer cbDefaultXSC : register(b0) {
  float4x4 ViewProj : packoffset(c0);
  float4x4 ViewMatrix : packoffset(c4);
  float4x4 SecondaryProj : packoffset(c8);
  float4x4 SecondaryViewProj : packoffset(c12);
  float4x4 SecondaryInvViewProj : packoffset(c16);
  float4 ConstantColour : packoffset(c20);
  float4 Time : packoffset(c21);
  float4 CameraPosition : packoffset(c22);
  float4 InvProjectionParams : packoffset(c23);
  float4 SecondaryInvProjectionParams : packoffset(c24);
  float4 ShaderDebugParams : packoffset(c25);
  float4 ToneMappingDebugParams : packoffset(c26);
  float4 HDR_EncodeScale2 : packoffset(c27);
  float4 EmissiveSurfaceMultiplier : packoffset(c28);
  float4 AlphaLight_OffsetScale : packoffset(c29);
  float4 TessellationScaleFactor : packoffset(c30);
  float4 FogNearColour : packoffset(c31);
  float4 FogFarColour : packoffset(c32);
  float4 FogParams : packoffset(c33);
  float4 AdvanceEnvironmentShaderDebugParams : packoffset(c34);
  float4 SMAA_RTMetrics : packoffset(c35);
}

cbuffer cbDefaultPSC : register(b2) {
  float4x4 AlphaLight_WorldtoClipMatrix : packoffset(c0);
  float4x4 AlphaLight_CliptoWorldMatrix : packoffset(c4);
  float4x4 ProjectorMatrix : packoffset(c8);
  float4x4 MotionBlurCurrInvViewProjection : packoffset(c12);
  float4x4 MotionBlurPrevViewProjection : packoffset(c16);
  float4x4 MotionBlurPrevSecViewProjection : packoffset(c20);
  float4x4 Spotlight0_Transform : packoffset(c24);
  float4 TextureAnimation : packoffset(c28);
  float4 AmbientDiffuse : packoffset(c29);
  float4 EnvironmentDebugParams : packoffset(c30);
  float4 ShadowFilterESMWeights : packoffset(c31);
  float4 LegacyDofParams : packoffset(c32);
  float4 OnePixelStepForS0 : packoffset(c33);
  float4 RenderTargetSize : packoffset(c34);
  float4 ModelTrackerID : packoffset(c35);
  float4 Sharpness_Bloom_Controls : packoffset(c36);
  float4 Blur_Direction : packoffset(c37);
  float4 LightMeterDebugParams : packoffset(c38);
  float4 SourceResolution : packoffset(c39);
  float4 HDR_EncodeScale : packoffset(c40);
  float4 OutputGamma : packoffset(c41);
  float4 AlphaLight_ScaleParams : packoffset(c42);
  float4 WrinkleMapWeights[6] : packoffset(c43);
  float4 RadiosityCubeMapIdx : packoffset(c49);
  float4 HairShadingParams[8] : packoffset(c50);
  float4 SkinShadingParams : packoffset(c58);
  float4 HDR_EncodeScale3 : packoffset(c59);
  float4 ScreenResolution[4] : packoffset(c60);
  float4 VelocityParams : packoffset(c64);
  float4 DeferredConstColor : packoffset(c65);
  float4 Spotlight0_Shadow_Params : packoffset(c66);
  float4 Spotlight0_ShadowMapDimensions : packoffset(c67);
  float4 ShadowFilterType : packoffset(c68);
  float4 Spotlight0_ReverseZPerspective : packoffset(c69);
  float4 SpacesuitVisorParams : packoffset(c70);
  float4 Directional_Light_Colour : packoffset(c71);
  float4 Directional_Light_Direction : packoffset(c72);
  float4 EnvironmentMap_Params : packoffset(c73);
  float4 Spotlight0_Shadow_Bias_GoboScale : packoffset(c74);
  float4 ScreenSpaceLightShaftParams1 : packoffset(c75);
  float4 ScreenSpaceLightShaftParams2 : packoffset(c76);
  float4 ScreenSpaceLightPosition : packoffset(c77);
  float4 LensAndScreenCenter : packoffset(c78);
  float4 ScaleAndScaleIn : packoffset(c79);
  float4 HmdWarpParam : packoffset(c80);
  float4 ChromAbParam : packoffset(c81);
  float4 SMAA_SubsampleIndices : packoffset(c82);
}

SamplerState LinearSampler_s : register(s0);
Texture2D<float4> colorTex : register(t0);
Texture2D<float4> velocityTex : register(t4);
Texture2D<float4> blendTex : register(t6);
Texture2D<float4> motionBlurTex : register(t9);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    out float4 o0: SV_Target0,
    out float4 o1: SV_Target1) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = blendTex.Sample(LinearSampler_s, v2.xy).w;
  r0.y = blendTex.Sample(LinearSampler_s, v2.zw).y;
  r1.xy = blendTex.Sample(LinearSampler_s, v1.xy).xz;
  r0.zw = r1.yx;
  r1.z = dot(r0.xyzw, float4(1, 1, 1, 1));
  r1.z = cmp(r1.z < 9.99999975e-006);
  if (r1.z != 0) {
    r2.xyz = colorTex.SampleLevel(LinearSampler_s, v1.xy, 0).xyz;
    r1.zw = velocityTex.SampleLevel(LinearSampler_s, v1.xy, 0).xy;
    r1.z = dot(r1.zw, r1.zw);
    r1.z = sqrt(r1.z);
    o0.xyz = r2.xyz;
  } else {
    r1.xy = max(r0.xy, r1.yx);
    r1.x = cmp(r1.y < r1.x);
    r2.xz = r1.xx ? r0.xz : 0;
    r2.yw = r1.xx ? float2(0, 0) : r0.yw;
    r0.xy = r1.xx ? r0.xz : r0.yw;
    r0.z = dot(r0.xy, float2(1, 1));
    r0.xy = r0.xy / r0.zz;
    r3.xyzw = float4(1, 1, -1, -1) * SMAA_RTMetrics.xyxy;
    r2.xyzw = r2.xyzw * r3.xyzw + v1.xyxy;
    r1.xyw = colorTex.SampleLevel(LinearSampler_s, r2.xy, 0).xyz;
    r3.xyz = colorTex.SampleLevel(LinearSampler_s, r2.zw, 0).xyz;
    r3.xyz = r3.xyz * r0.yyy;
    o0.xyz = r0.xxx * r1.xyw + r3.xyz;
    r0.zw = velocityTex.SampleLevel(LinearSampler_s, r2.xy, 0).xy;
    r1.xy = velocityTex.SampleLevel(LinearSampler_s, r2.zw, 0).xy;
    r1.xy = r1.xy * r0.yy;
    r0.xy = r0.xx * r0.zw + r1.xy;
    r0.x = dot(r0.xy, r0.xy);
    r1.z = sqrt(r0.x);
  }
  r0.x = motionBlurTex.SampleLevel(LinearSampler_s, v1.xy, 0).w;
  o0.w = Blur_Direction.x * r0.x;
  o1.xyzw = r1.zzzz;
  return;
}
