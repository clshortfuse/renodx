SamplerState SamplerInput_SMP : register(s0);  // can't disambiguate
Texture2D<float4> SamplerInput_TEX : register(t0);

cbuffer cbDefaultPSC : register(b2) {
  float4x4 AlphaLight_WorldtoClipMatrix : packoffset(c0.x);
  float4x4 AlphaLight_CliptoWorldMatrix : packoffset(c4.x);
  float4x4 ProjectorMatrix : packoffset(c8.x);
  float4x4 MotionBlurCurrInvViewProjection : packoffset(c12.x);
  float4x4 MotionBlurPrevViewProjection : packoffset(c16.x);
  float4x4 MotionBlurPrevSecViewProjection : packoffset(c20.x);
  float4x4 Spotlight0_Transform : packoffset(c24.x);
  float4 TextureAnimation : packoffset(c28.x);
  float4 AmbientDiffuse : packoffset(c29.x);
  float4 EnvironmentDebugParams : packoffset(c30.x);
  float4 ShadowFilterESMWeights : packoffset(c31.x);
  float4 LegacyDofParams : packoffset(c32.x);
  float4 OnePixelStepForS0 : packoffset(c33.x);
  float4 RenderTargetSize : packoffset(c34.x);
  float4 ModelTrackerID : packoffset(c35.x);
  float4 Sharpness_Bloom_Controls : packoffset(c36.x);
  float4 Blur_Direction : packoffset(c37.x);
  float4 LightMeterDebugParams : packoffset(c38.x);
  float4 SourceResolution : packoffset(c39.x);
  float4 HDR_EncodeScale : packoffset(c40.x);
  float4 OutputGamma : packoffset(c41.x);
  float4 AlphaLight_ScaleParams : packoffset(c42.x);
  float4 WrinkleMapWeights : packoffset(c43.x);
  float4 RadiosityCubeMapIdx : packoffset(c49.x);
  float4 HairShadingParams : packoffset(c50.x);
  float4 SkinShadingParams : packoffset(c58.x);
  float4 HDR_EncodeScale3 : packoffset(c59.x);
  float4 ScreenResolution : packoffset(c60.x);
  float4 VelocityParams : packoffset(c64.x);
  float4 DeferredConstColor : packoffset(c65.x);
  float4 Spotlight0_Shadow_Params : packoffset(c66.x);
  float4 Spotlight0_ShadowMapDimensions : packoffset(c67.x);
  float4 ShadowFilterType : packoffset(c68.x);
  float4 Spotlight0_ReverseZPerspective : packoffset(c69.x);
  float4 SpacesuitVisorParams : packoffset(c70.x);
  float4 Directional_Light_Colour : packoffset(c71.x);
  float4 Directional_Light_Direction : packoffset(c72.x);
  float4 EnvironmentMap_Params : packoffset(c73.x);
  float4 Spotlight0_Shadow_Bias_GoboScale : packoffset(c74.x);
  float4 ScreenSpaceLightShaftParams1 : packoffset(c75.x);
  float4 ScreenSpaceLightShaftParams2 : packoffset(c76.x);
  float4 ScreenSpaceLightPosition : packoffset(c77.x);
  float4 LensAndScreenCenter : packoffset(c78.x);
  float4 ScaleAndScaleIn : packoffset(c79.x);
  float4 HmdWarpParam : packoffset(c80.x);
  float4 ChromAbParam : packoffset(c81.x);
  float4 SMAA_SubsampleIndices : packoffset(c82.x);
};

struct PSInput {
  float4 param0 : SV_Position;
  float3 param1 : TEXCOORD;
};

struct PSOutput {
  float4 param0 : SV_Target0;
};

PSOutput main(in PSInput IN) {
  PSOutput OUT = (PSOutput)0;

  float2 uv = IN.param0.xy * (RenderTargetSize.zw * 2.0);
  OUT.param0 = SamplerInput_TEX.SampleLevel(SamplerInput_SMP, uv, 0).x;

  return OUT;
}
