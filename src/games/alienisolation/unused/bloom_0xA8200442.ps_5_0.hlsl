// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:43:27 2024

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

cbuffer cbUbershaderXSC : register(b5) {
  float4 rp_parameter_vs[32] : packoffset(c0);
  float4 rp_parameter_ps[32] : packoffset(c32);
}

SamplerState SamplerBloomTight_SMP_s : register(s3);
SamplerState SamplerBloomHoriz_SMP_s : register(s4);
SamplerState SamplerBloomRound0_SMP_s : register(s9);
SamplerState SamplerBloomRound1_SMP_s : register(s10);
SamplerState SamplerBloomRound3_SMP_s : register(s12);
SamplerState SamplerBloomMapSuperWide_SMP_s : register(s13);
SamplerState SamplerLensDust_SMP_s : register(s14);
Texture2D<float4> SamplerBloomTight_TEX : register(t3);
Texture2D<float4> SamplerBloomHoriz_TEX : register(t4);
Texture2D<float4> SamplerBloomRound0_TEX : register(t9);
Texture2D<float4> SamplerBloomRound1_TEX : register(t10);
Texture2D<float4> SamplerBloomRound3_TEX : register(t12);
Texture2D<float4> SamplerBloomMapSuperWide_TEX : register(t13);
Texture2D<float4> SamplerLensDust_TEX : register(t14);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: TEXCOORD0,
    float4 v1: TEXCOORD1,
    float4 v2: TEXCOORD2,
    float4 v3: TEXCOORD3,
    float4 v4: SV_Position0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  o0.w = 1;
  r0.xy = v1.xy + -v0.zw;
  r0.z = dot(r0.xy, r0.xy);
  r0.z = sqrt(r0.z);
  r0.z = 0.0299999993 / r0.z;
  r0.z = min(1, r0.z);
  r0.xy = r0.xy * r0.zz + v0.zw;
  r0.xyz = SamplerBloomRound0_TEX.Sample(SamplerBloomRound0_SMP_s, r0.xy).xyz;
  r0.xyz = rp_parameter_ps[0].yyy * r0.xyz;
  r0.xyz = float3(0.0677250028, 0.302125007, 0.136098996) * r0.xyz;
  r1.xyz = SamplerBloomTight_TEX.Sample(SamplerBloomTight_SMP_s, v0.zw).xyz;
  r1.xyz = rp_parameter_ps[0].xxx * r1.xyz;
  r0.xyz = r1.xyz * float3(0.680019975, 0.215764001, 0.0759259984) + r0.xyz;
  r1.xyz = SamplerBloomRound1_TEX.Sample(SamplerBloomRound1_SMP_s, v1.zw).xyz;
  r1.xyz = rp_parameter_ps[0].zzz * r1.xyz;
  r0.xyz = r1.xyz * float3(0.00902100001, 0.0461490005, 0.358653992) + r0.xyz;
  r1.xyz = SamplerBloomRound3_TEX.Sample(SamplerBloomRound3_SMP_s, v2.xy).xyz;
  r1.xyz = rp_parameter_ps[0].www * r1.xyz;
  r0.xyz = r1.xyz * float3(0.204710007, 0.0738279969, 0.246800005) + r0.xyz;
  r0.w = dot(v2.zw, v2.zw);
  r0.w = 0.0900000036 + r0.w;
  r0.w = 0.0900000036 / r0.w;
  r0.w = r0.w * r0.w;
  r0.w = rp_parameter_ps[1].w * r0.w;
  r0.w = 3 * r0.w;
  r0.xyz = r0.xyz * r0.www;
  r1.xyz = SamplerBloomMapSuperWide_TEX.Sample(SamplerBloomMapSuperWide_SMP_s, v0.xy).xyz;
  r0.w = dot(r1.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
  r2.xyz = r1.xyz + r0.www;
  r1.xyz = rp_parameter_ps[3].www * r1.xyz;
  r1.xyz = min(rp_parameter_ps[3].xyz, r1.xyz);
  r0.xyz = r2.xyz * float3(0.25, 0.25, 0.25) + r0.xyz;
  r2.xyz = SamplerBloomRound1_TEX.Sample(SamplerBloomRound1_SMP_s, v0.xy).xyz;
  r3.xyz = SamplerBloomRound3_TEX.Sample(SamplerBloomRound3_SMP_s, v0.xy).xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r2.xyz = float3(0.300000012, 0.300000012, 0.300000012) * r2.xyz;
  r3.xyz = SamplerBloomTight_TEX.Sample(SamplerBloomTight_SMP_s, v0.xy).xyz;
  r2.xyz = r3.xyz * float3(1.5, 1.5, 1.5) + r2.xyz;
  r3.xyz = SamplerBloomHoriz_TEX.Sample(SamplerBloomHoriz_SMP_s, v0.xy).xyz;
  r2.xyz = r3.xyz * float3(0.5, 0.5, 1.10000002) + r2.xyz;
  r0.xyz = r2.xyz + r0.xyz;
  r2.xyz = SamplerBloomMapSuperWide_TEX.Sample(SamplerBloomMapSuperWide_SMP_s, v3.xy).xyz;
  r2.xyz = rp_parameter_ps[2].www * r2.xyz;
  r2.xyz = min(rp_parameter_ps[2].xyz, r2.xyz);
  r1.xyz = r2.xyz + r1.xyz;
  r0.w = dot(r1.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
  r1.xyz = r1.xyz + r0.www;
  r2.xyz = SamplerLensDust_TEX.Sample(SamplerLensDust_SMP_s, v2.zw).xyz;
  r2.xyz = r2.xyz * r2.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.w = dot(r1.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
  r0.w = -rp_parameter_ps[4].x + r0.w;
  r0.w = saturate(-r0.w);
  r0.w = 1 + -r0.w;
  r1.xyz = r1.xyz * r0.www;
  r0.xyz = r0.xyz * float3(0.5, 0.5, 0.5) + r1.xyz;
  r0.w = dot(r0.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = r0.xyz * float3(1.20000005, 1.20000005, 1.20000005) + r0.www;
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = sqrt(r0.xyz);
  o0.xyz = saturate(Sharpness_Bloom_Controls.www * r0.xyz);
  return;
}
