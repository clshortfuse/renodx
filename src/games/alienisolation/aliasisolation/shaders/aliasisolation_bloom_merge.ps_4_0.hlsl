SamplerState SamplerBloomTight_SMP : register(s3);          // can't disambiguate
SamplerState SamplerBloomHoriz_SMP : register(s4);          // can't disambiguate
SamplerState SamplerBloomRound0_SMP : register(s9);         // can't disambiguate
SamplerState SamplerBloomRound1_SMP : register(s10);        // can't disambiguate
SamplerState SamplerBloomRound3_SMP : register(s12);        // can't disambiguate
SamplerState SamplerBloomMapSuperWide_SMP : register(s13);  // can't disambiguate
SamplerState SamplerLensDust_SMP : register(s14);           // can't disambiguate
Texture2D<float4> SamplerBloomTight_TEX : register(t3);
Texture2D<float4> SamplerBloomHoriz_TEX : register(t4);
Texture2D<float4> SamplerBloomRound0_TEX : register(t9);
Texture2D<float4> SamplerBloomRound1_TEX : register(t10);
Texture2D<float4> SamplerBloomRound3_TEX : register(t12);
Texture2D<float4> SamplerBloomMapSuperWide_TEX : register(t13);
Texture2D<float4> SamplerLensDust_TEX : register(t14);

#if 1
#define FLARE_SCALE     1
#define LENS_DUST_SCALE 0
#define WIDE_SCALE      1
#define MEDIUM_SCALE    1.5
#define HORIZ_SCALE     1
#define GLOBAL_SCALE    1
#else
#define FLARE_SCALE     1
#define LENS_DUST_SCALE 0
#define WIDE_SCALE      1
#define MEDIUM_SCALE    1
#define HORIZ_SCALE     1
#define GLOBAL_SCALE    1
#endif

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

cbuffer cbUbershaderXSC : register(b5) {
  float4 rp_parameter_vs[32] : packoffset(c0.x);
  float4 rp_parameter_ps[32] : packoffset(c32.x);
};

struct PSInput {
  float4 param0 : TEXCOORD0;
  float4 param1 : TEXCOORD1;
  float4 param2 : TEXCOORD2;
  float4 param3 : TEXCOORD3;
  float4 param4 : SV_Position;
};

struct PSOutput {
  float4 param0 : SV_Target0;
};

PSOutput main(in PSInput IN) {
  PSOutput OUT = (PSOutput)0;

  float unusedParam;
  float4 r0;
  r0.xy = (-IN.param0.zwzz + IN.param1.xyxx).xy;
  r0.z = (dot(r0.xyxx.xy, r0.xyxx.xy)).x;
  r0.z = (sqrt(r0.z)).x;
  r0.z = (float1(0.030000) / r0.z).x;
  r0.z = (min(r0.z, float1(1.000000))).x;
  r0.xy = (r0.xyxx * r0.zzzz + IN.param0.zwzz).xy;

  {
    float edgeFade = smoothstep(0.55, 0.4, abs(r0.x - 0.5)) * smoothstep(0.55, 0.4, abs(r0.y - 0.5));
    r0.xyz = SamplerBloomRound0_TEX.SampleLevel(SamplerBloomRound0_SMP, r0.xyxx.xy, 0).xyz * edgeFade;
  }
  r0.xyz = (r0.xyzx * rp_parameter_ps[0].yyyy).xyz;
  r0.xyz = (r0.xyzx * float4(0.067725, 0.302125, 0.136099, 0.000000)).xyz;
  float4 r1;

  {
    float edgeFade = smoothstep(0.55, 0.4, abs(IN.param0.z - 0.5)) * smoothstep(0.55, 0.4, abs(IN.param0.w - 0.5));
    r1.xyz = SamplerBloomTight_TEX.SampleLevel(SamplerBloomTight_SMP, IN.param0.zwzz.xy, 0).xyz * edgeFade;
  }

  r1.xyz = (r1.xyzx * rp_parameter_ps[0].xxxx).xyz;
  r0.xyz = (r1.xyzx * float4(0.680020, 0.215764, 0.075926, 0.000000) + r0.xyzx).xyz;
  r1.xyz = SamplerBloomRound1_TEX.SampleLevel(SamplerBloomRound1_SMP, IN.param1.zwzz.xy, 0).xyz;
  r1.xyz = (r1.xyzx * rp_parameter_ps[0].zzzz).xyz;
  r0.xyz = (r1.xyzx * float4(0.009021, 0.046149, 0.358654, 0.000000) + r0.xyzx).xyz;
  r1.xyz = SamplerBloomRound3_TEX.SampleLevel(SamplerBloomRound3_SMP, IN.param2.xyxx.xy, 0).xyz;
  r1.xyz = (r1.xyzx * rp_parameter_ps[0].wwww).xyz;
  r0.xyz = (r1.xyzx * float4(0.204710, 0.073828, 0.246800, 0.000000) + r0.xyzx).xyz;
  float flareOffset = 2 * length(IN.param2.xy - 0.5);
  r0.w = exp2(-10 * flareOffset);
  // r0.w = (dot(IN.param2.zwzz.xy, IN.param2.zwzz.xy)).x;
  r0.w = (r0.w + float1(0.090000)).x;
  r0.w = (float1(0.090000) / r0.w).x;
  r0.w = (r0.w * r0.w).x;
  r0.w = (r0.w * rp_parameter_ps[1].w).x;
  r0.w = (r0.w * float1(3.000000)).x;
  r0.xyz = (r0.wwww * r0.xyzx).xyz * FLARE_SCALE;

  r1.xyz = SamplerBloomMapSuperWide_TEX.SampleLevel(SamplerBloomMapSuperWide_SMP, IN.param0.xyxx.xy, 0).xyz * WIDE_SCALE;

  r0.w = (dot(r1.xyzx.xyz, float4(0.212600, 0.715200, 0.072200, 0.000000).xyz)).x;
  float4 r2;
  r2.xyz = (r0.wwww + r1.xyzx).xyz;
  r1.xyz = (r1.xyzx * rp_parameter_ps[3].wwww).xyz;
  r1.xyz = (min(r1.xyzx, rp_parameter_ps[3].xyzx)).xyz;
  r0.xyz = (r2.xyzx * float4(0.250000, 0.250000, 0.250000, 0.000000) + r0.xyzx).xyz;
  r2.xyz = SamplerBloomRound1_TEX.SampleLevel(SamplerBloomRound1_SMP, IN.param0.xyxx.xy, 0).xyz;
  float4 r3;
  r3.xyz = SamplerBloomRound3_TEX.SampleLevel(SamplerBloomRound3_SMP, IN.param0.xyxx.xy, 0).xyz;
  r2.xyz = (r2.xyzx + r3.xyzx).xyz * MEDIUM_SCALE;
  r2.xyz = (r2.xyzx * float4(0.300000, 0.300000, 0.300000, 0.000000)).xyz;
  r3.xyz = SamplerBloomTight_TEX.SampleLevel(SamplerBloomTight_SMP, IN.param0.xyxx.xy, 0).xyz;
  r2.xyz = (r3.xyzx * float4(1.500000, 1.500000, 1.500000, 0.000000) + r2.xyzx).xyz;
  r3.xyz = SamplerBloomHoriz_TEX.SampleLevel(SamplerBloomHoriz_SMP, IN.param0.xyxx.xy, 0).xyz * HORIZ_SCALE;
  r2.xyz = (r3.xyzx * float4(0.500000, 0.500000, 1.100000, 0.000000) + r2.xyzx).xyz;
  r0.xyz = (r0.xyzx + r2.xyzx).xyz;
  r2.xyz = SamplerBloomMapSuperWide_TEX.SampleLevel(SamplerBloomMapSuperWide_SMP, IN.param3.xyxx.xy, 0).xyz;

  r2.xyz = (r2.xyzx * rp_parameter_ps[2].wwww).xyz;
  r2.xyz = (min(r2.xyzx, rp_parameter_ps[2].xyzx)).xyz;

  // r2.xyz += 0.125 * SamplerBloomMapSuperWide_TEX.SampleLevel(SamplerBloomMapSuperWide_SMP, IN.param0.xyxx.xy, 0).xyz;
  r2.xyz += LENS_DUST_SCALE * SamplerBloomMapSuperWide_TEX.SampleLevel(SamplerBloomMapSuperWide_SMP, IN.param3.xyxx.xy, 0).xyz;

  // OUT.param0 = float4(r2.xyz, 1);
  // return OUT;

  r1.xyz = (r1.xyzx + r2.xyzx).xyz;
  r0.w = (dot(r1.xyzx.xyz, float4(0.212600, 0.715200, 0.072200, 0.000000).xyz)).x;
  r1.xyz = (r0.wwww + r1.xyzx).xyz;

  r2.xyz = SamplerLensDust_TEX.SampleLevel(SamplerLensDust_SMP, IN.param2.zwzz.xy, 0).xyz;
  r2.xyz = (r2.xyzx * r2.xyzx).xyz;

  r1.xyz = (r1.xyzx * r2.xyzx).xyz;
  r0.w = (dot(r1.xyzx.xyz, float4(0.212600, 0.715200, 0.072200, 0.000000).xyz)).x;
  r0.w = (r0.w + -rp_parameter_ps[4].x).x;
  r0.w = (saturate(-r0.w)).x;
  r0.w = (-r0.w + float1(1.000000)).x;
  r1.xyz = (r0.wwww * r1.xyzx).xyz;

  r0.xyz = (r0.xyzx * float4(0.500000, 0.500000, 0.500000, 0.000000) + r1.xyzx).xyz;
  r0.w = (dot(r0.xyzx.xyz, float4(0.212600, 0.715200, 0.072200, 0.000000).xyz)).x;
  r0.xyz = (-r0.wwww + r0.xyzx).xyz;
  r0.xyz = (r0.xyzx * float4(1.200000, 1.200000, 1.200000, 0.000000) + r0.wwww).xyz;

  r0.xyz *= GLOBAL_SCALE;

  r0.xyz = (max(r0.xyzx, float4(0, 0, 0, 0))).xyz;
  r0.xyz = (sqrt(r0.xyzx)).xyz;
  OUT.param0.xyz = (saturate(r0.xyzx * Sharpness_Bloom_Controls.wwww)).xyz;
  OUT.param0.w = (float1(1.000000)).x;
  return OUT;
}
