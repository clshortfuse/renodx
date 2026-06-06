// Once Human (sm5 / DX11) - tonemap + color-grade pass (gameplay; final image -> r8 LDR buffer 0x74C96560)
// RenoDX HDR injection: tap pre-LUT HDR scene + post-LUT graded SDR, run renodx tonemap.
// Original decompile by 3Dmigoto; vanilla output preserved in comments at the bottom.
#include "./shared.h"

cbuffer _Globals : register(b0) {
  float4 Tint : packoffset(c0);
  float GrayScale : packoffset(c1);
  float VignetteIntensity : packoffset(c1.y);
  float ChromaticAberrationRange : packoffset(c1.z);
  float ChromaticAberrationIntensity : packoffset(c1.w);
  float BrightnessFactor : packoffset(c2);
}

cbuffer PerScene : register(b1) {
  float VolumeWeight : packoffset(c0);
  int LocalFogShapeType : packoffset(c0.y);
  float4 LocalFogPackedParams[4] : packoffset(c1);
  int BlendWithFog : packoffset(c5);
  float4 ScreenSize : packoffset(c6);
  float FrameTime : packoffset(c7);
  float FrameTimeIndex : packoffset(c7.y);
  float FrameDeltaTime : packoffset(c7.z);
  float4 FrameID : packoffset(c8);
  float4 SkyLightColor : packoffset(c9);
  float SkyReflectionIntensity : packoffset(c10);
  float SceneEmissiveAdaption : packoffset(c10.y);
  float4 VolumetricFogParamsArray[5] : packoffset(c11);
  int WeatherSystem_Active : packoffset(c16);
  float4 WeatherSystem_Param[7] : packoffset(c17);
  float4 WildShadowMapParams[2] : packoffset(c24);
  float4 VerticalOcclusionCam[2] : packoffset(c26);
  float4 ReflectionProbeInfo : packoffset(c28);
  float4 LocalReflectionProbeInfo[3] : packoffset(c29);
  float4 LightProbeSH[7] : packoffset(c32);
  float4 LocalProbeSH[7] : packoffset(c39);
  float4 DayNightFade : packoffset(c46);
  float4 DayNightCustom : packoffset(c47);
  float4 SkyIlluminance : packoffset(c48);
  float4 RainColorRatio : packoffset(c49);
}

SamplerState Sampler_Bilinear_Clamp_s : register(s0);
SamplerState Sampler_Point_Clamp_s : register(s1);
Texture2D<float4> SDFCheckerBuffer : register(t0);
Texture2D<float4> AutoExposureTex : register(t1);
Texture2D<float4> BloomTex : register(t2);
Texture2D<float4> ColorGradingLut : register(t3);
Texture2D<float4> BgTex : register(t4);

#define cmp -

void main(
    float4 v0 : TEXCOORD0,
    float4 v1 : TEXCOORD1,
    out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + v0.xyxy;
  r1.xyzw = cmp(float4(0, 0, 0, 0) < r0.zwzw);
  r0.xyzw = cmp(r0.xyzw < float4(0, 0, 0, 0));
  r0.xyzw = (int4)-r1.xyzw + (int4)r0.xyzw;
  r0.xyzw = (int4)r0.xyzw;
  r1.x = saturate(1 + -ChromaticAberrationRange);
  r1.y = 1 + -r1.x;
  r1.y = 1 / r1.y;
  r2.xyzw = v0.yxyx * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r3.xyzw = abs(r2.yzwx) + -r1.xxxx;
  r2.x = saturate(-r2.x);
  r1.x = r2.x * r2.x;
  r2.xyzw = saturate(r3.xyzw * r1.yyyy);
  r3.xyzw = r2.zwzw * float4(-2, -2, -2, -2) + float4(3, 3, 3, 3);
  r2.xyzw = r2.xyzw * r2.xyzw;
  r2.xyzw = r3.xyzw * r2.xyzw;
  r0.xyzw = r2.xyzw * r0.xyzw;
  r0.xyzw = (ChromaticAberrationIntensity * shader_injection.chromatic_aberration_strength) * r0.xyzw;  // RENODX: CA strength
  r0.xyzw = r0.xyzw * float4(-0.00999998953, -0.00999998953, -0.0199999791, -0.0199999791) + v0.xyxy;
  r1.w = BgTex.Sample(Sampler_Bilinear_Clamp_s, r0.xy).y;
  r1.y = BgTex.Sample(Sampler_Bilinear_Clamp_s, r0.zw).z;
  r0.x = -VolumeWeight + 1;
  r0.x = min(DayNightFade.w, r0.x);
  r0.y = SDFCheckerBuffer.SampleLevel(Sampler_Point_Clamp_s, float2(0.5, 0.5), 0).w;
  r0.x = min(r0.x, r0.y);
  r0.x = r0.x * -r1.x + 1;
  r0.zw = v0.xy * float2(2, -2) + float2(-1, 1);
  r0.zw = (VignetteIntensity * shader_injection.vignette_strength) * r0.zw;  // RENODX: vignette strength
  r0.z = dot(r0.zw, r0.zw);
  r0.z = 1 + r0.z;
  r0.z = 1 / r0.z;
  r0.z = r0.z * r0.z;
  r0.x = r0.z * r0.x;
  r1.z = BgTex.Sample(Sampler_Bilinear_Clamp_s, v0.xy).x;
  r0.xzw = r1.yzw * r0.xxx;
  r1.xyz = BloomTex.Sample(Sampler_Bilinear_Clamp_s, v0.xy).xyz;
  r2.xyz = r1.zxy * r0.yyy;
  r2.xyz = float3(0.899999976, 0.899999976, 0.899999976) * r2.xyz;
  r1.xyz = r1.zxy * float3(0.100000001, 0.100000001, 0.100000001) + r2.xyz;
  r0.y = AutoExposureTex.Sample(Sampler_Bilinear_Clamp_s, float2(0.5, 0.5)).x;
  r0.xyz = r0.xzw * r0.yyy + r1.xyz * shader_injection.bloom_strength;  // RENODX: bloom strength

  // RENODX: HDR scene tapped here (pre log-shaper / pre-LUT). Linear, game working space.
  // The decompiled composite stores channels rotated as (B, R, G); reorder to (R, G, B).
  float3 untonemapped = r0.yzx;

  r0.xyz = float3(-0.0110916002, -0.0110916002, -0.0110916002) + r0.xyz;
  r0.xyz = r0.xyz * float3(0.5, 0.5, 0.5) + float3(0.0375839993, 0.0375839993, 0.0375839993);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.130255386, 0.130255386, 0.130255386) + float3(0.646596014, 0.646596014, 0.646596014));
  r0.w = 31 * r0.x;
  r0.w = floor(r0.w);
  r0.x = r0.x * 31 + -r0.w;
  r0.yz = r0.yz * float2(0.0302734207, 0.96875) + float2(0.000488280988, 0.015625);
  r1.x = r0.w * 0.03125 + r0.y;
  r1.z = -r0.z;
  r0.yz = float2(0.03125, 1) + r1.xz;
  r1.y = 1 + r1.z;
  r1.xyz = ColorGradingLut.Sample(Sampler_Bilinear_Clamp_s, r1.xy).xyz;
  r0.yzw = ColorGradingLut.Sample(Sampler_Bilinear_Clamp_s, r0.yz).xyz;
  r0.yzw = r0.yzw + -r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  r0.w = 1;
  r1.xyzw = Tint.xyzw * r0.xyzw;
  r2.x = dot(r1.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
  r0.xyzw = -r0.xyzw * Tint.xyzw + r2.xxxx;
  r0.xyzw = GrayScale * r0.xyzw + r1.xyzw;

  // RENODX: graded SDR look tapped here (linear, before vanilla display-gamma encode).
  float3 graded = r0.xyz;

  // RENODX: HDR tone mapping. Reads tone-mapper/peak/etc. config from shader_injection (shared.h).
  // RenderIntermediatePass applies intermediate_scaling (diffuse/graphics) + intermediate encoding
  // so the downstream swapchain-proxy SwapChainPass lands the scene at Game Brightness (diffuse),
  // NOT UI Brightness (graphics). Without it the scene inherits graphics_white and reads dark.
  o0.rgb = renodx::draw::RenderIntermediatePass(renodx::draw::ToneMapPass(untonemapped, graded));
  o0.w = 1.0;
  return;

  // ---- vanilla output (replaced by ToneMapPass above) ----
  // r0.xyz = log2(r0.xyz);
  // o0.w = r0.w;
  // r0.w = BrightnessFactor * 0.799999952 + 1.79999995;
  // r0.w = 1 / r0.w;
  // r0.xyz = r0.www * r0.xyz;
  // o0.xyz = exp2(r0.xyz);
  // return;
}
