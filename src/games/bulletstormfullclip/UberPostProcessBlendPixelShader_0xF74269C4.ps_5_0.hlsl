#include "./common.hlsl"

cbuffer _Globals : register(b0){
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  bool bDecompressSceneColor : packoffset(c4);
  float4 PackedParameters : packoffset(c5);
  float4 MinMaxBlurClamp : packoffset(c6);
  float4 SceneShadowsAndDesaturation : packoffset(c7);
  float4 SceneInverseHighLights : packoffset(c8);
  float4 SceneMidTones : packoffset(c9);
  float4 SceneScaledLuminanceWeights : packoffset(c10);
  float4 SceneColorize : packoffset(c11);
  float4 GammaColorScaleAndInverse : packoffset(c12);
  float4 GammaOverlayColor : packoffset(c13);
  float4 RenderTargetExtent : packoffset(c14);
  float UseBrightnessCorrection : packoffset(c15);
  float4 BS_HeightDOFPacked : packoffset(c16);
  float BS_BlurredSceneAmount : packoffset(c17);
  float4 RenderTargetClampParameter : packoffset(c18);
  float4 MotionBlurMaskScaleAndBias : packoffset(c19);
  float4x4 ScreenToWorld : packoffset(c20);
  float4x4 PrevViewProjMatrix : packoffset(c24);
  float4 StaticVelocityParameters : packoffset(c28) = {0.5,-0.5,0.0125000002,0.0222222228};
  float4 DynamicVelocityParameters : packoffset(c29) = {0.0250000004,-0.0444444455,-0.0500000007,0.088888891};
  float StepOffsetsOpaque[5] : packoffset(c30);
  float StepWeightsOpaque[5] : packoffset(c35);
  float StepOffsetsTranslucent[5] : packoffset(c40);
  float StepWeightsTranslucent[5] : packoffset(c45);
  float4 BloomTintAndScreenBlendThreshold : packoffset(c50);
  float4 ImageAdjustments1 : packoffset(c51);
  float4 ImageAdjustments2 : packoffset(c52);
  float4 ImageAdjustments3 : packoffset(c53);
  float4 HalfResMaskRect : packoffset(c54);
  float4 DOFKernelSize : packoffset(c55);
  float3 BS_DirtMaskColorAndIntensity : packoffset(c56);
  float4 BS_CustomPacked : packoffset(c57);
}

SamplerState SceneColorTextureSampler_s : register(s0);
SamplerState BS_OutlineMaskTextureSampler_s : register(s1);
SamplerState BS_ColorLookupTextureSampler_s : register(s2);
SamplerState FilterColor1TextureSampler_s : register(s3);
SamplerState BS_DirtTextureSampler_s : register(s4);
SamplerState ColorGradingLUTSampler_s : register(s5);
SamplerState LowResPostProcessBufferSampler_s : register(s6);
Texture2D<float4> SceneColorTexture : register(t0);
Texture2D<float4> BS_OutlineMaskTexture : register(t1);
Texture2D<float4> BS_ColorLookupTexture : register(t2);
Texture2D<float4> FilterColor1Texture : register(t3);
Texture2D<float4> BS_DirtTexture : register(t4);
Texture2D<float4> ColorGradingLUT : register(t5);
Texture2D<float4> LowResPostProcessBuffer : register(t6);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float2 v3 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = max(HalfResMaskRect.xy, v1.zw);
  r0.xy = min(HalfResMaskRect.zw, r0.xy);
  r1.xyz = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, v1.xy, 0).xyz;
  r0.xyzw = LowResPostProcessBuffer.Sample(LowResPostProcessBufferSampler_s, r0.xy).xyzw;
  r2.xyz = float3(4,4,4) * r0.xyz;
  r0.xyz = -r0.xyz * float3(4,4,4) + r1.xyz;
  r0.xyz = r0.www * r0.xyz + r2.xyz;
  r0.xyz = min(float3(65503,65503,65503), r0.xyz);
  r1.xyz = BS_DirtTexture.Sample(BS_DirtTextureSampler_s, v2.zw).xyz;
  r2.xyz = FilterColor1Texture.Sample(FilterColor1TextureSampler_s, v0.zw).xyz;
  r2.xyz = float3(4,4,4) * r2.xyz * injectedData.fxBloom;
  r1.xyz = r1.xyz * BS_DirtMaskColorAndIntensity.xyz + BloomTintAndScreenBlendThreshold.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.w = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r0.w = -3 * r0.w;
  r0.w = exp2(r0.w);
  r0.w = saturate(BloomTintAndScreenBlendThreshold.w * r0.w);
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  if (BS_CustomPacked.z > 0) {
    r1.xyz = -v3.xyx;
    r1.w = 0;
    r2.x = v3.x;
    r2.yz = float2(0,0);
    r2.w = -v3.y;
    r2.xyzw = v1.xyxy + r2.xyzw;
    r3.xw = float2(0,0);
    r3.y = v3.y;
    r3.xy = v1.xy + r3.xy;
    r1.xyzw = v1.xyxy + r1.zwxy;
    r4.xyzw = v3.xyxy * float4(-1,1,1,-1) + v1.xyxy;
    r5.xy = v3.xy + v1.xy;
    r1.xy = BS_OutlineMaskTexture.Sample(BS_OutlineMaskTextureSampler_s, r1.xy).xy;
    r2.xy = BS_OutlineMaskTexture.Sample(BS_OutlineMaskTextureSampler_s, r2.xy).xy;
    r0.w = max(0, r1.y);
    r0.w = max(r0.w, r2.y);
    r2.yz = BS_OutlineMaskTexture.Sample(BS_OutlineMaskTextureSampler_s, r2.zw).xy;
    r3.xy = BS_OutlineMaskTexture.Sample(BS_OutlineMaskTextureSampler_s, r3.xy).xy;
    r0.w = max(r2.z, r0.w);
    r0.w = max(r0.w, r3.y);
    r1.yz = BS_OutlineMaskTexture.Sample(BS_OutlineMaskTextureSampler_s, r1.zw).xy;
    r2.zw = BS_OutlineMaskTexture.Sample(BS_OutlineMaskTextureSampler_s, r4.xy).xy;
    r0.w = max(r1.z, r0.w);
    r0.w = max(r0.w, r2.w);
    r1.zw = BS_OutlineMaskTexture.Sample(BS_OutlineMaskTextureSampler_s, r4.zw).xy;
    r4.xy = BS_OutlineMaskTexture.Sample(BS_OutlineMaskTextureSampler_s, r5.xy).xy;
    r0.w = max(r1.w, r0.w);
    r0.w = max(r0.w, r4.y);
    r4.yz = BS_OutlineMaskTexture.Sample(BS_OutlineMaskTextureSampler_s, v1.xy).xy;
    r3.z = max(r4.z, r0.w);
    r0.w = r2.x + r1.x;
    r0.w = r0.w + r2.y;
    r0.w = r0.w + r3.x;
    r0.w = r0.w + r1.y;
    r0.w = r0.w + r2.z;
    r0.w = r0.w + r1.z;
    r0.w = r0.w + r4.x;
    r0.w = r0.w + r4.y;
    r0.w = saturate(r0.w * 0.111111112 + -r4.y);
    r1.xyz = BS_ColorLookupTexture.Sample(BS_ColorLookupTextureSampler_s, r3.zw).xyz;
    r1.xyz = r1.xyz * float3(2,2,2) + -r0.xyz;
    r0.xyz = r0.www * r1.xyz + r0.xyz;
  }
  float3 untonemapped = r0.xyz;
  r0.xyzw = lerp(1.f, ImageAdjustments3.y, injectedData.fxAutoExposure) * r0.zzxy;
  r0.xyzw = saturate(float4(0.588235319,0.588235319,0.588235319,0.588235319) * r0.xyzw);
  r1.xyzw = float4(1.7,1.7,1.7,1.7) * r0.yyzw;
  r0.xyzw = float4(-0.98255378,-0.98255378,-0.98255378,-0.98255378) * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  r0.xyzw = float4(1.44580638,1.44580638,1.44580638,1.44580638) * r0.xyzw;
  r1.xyzw = log2(r1.xyzw);
  r1.xyzw = float4(0.564518631,0.564518631,0.564518631,0.564518631) * r1.xyzw;
  r1.xyzw = exp2(r1.xyzw);
  r0.xyzw = r1.xyzw * r0.xyzw;
  float3 vanilla = r0.zwy;
  r0.xyzw = min(float4(1,1,1,1), r0.xyzw);
  r1.xyw = float3(14.9998999,0.9375,0.05859375) * r0.xwz;
  r0.x = floor(r1.x);
  r0.y = r0.y * 15 + -r0.x;
  r1.x = r0.x * 0.0625 + r1.w;
  r1.xyzw = float4(0.001953125,0.03125,0.064453125,0.03125) + r1.xyxy;
  r0.xzw = ColorGradingLUT.Sample(ColorGradingLUTSampler_s, r1.xy).xyz;
  r1.xyz = ColorGradingLUT.Sample(ColorGradingLUTSampler_s, r1.zw).xyz;
  r1.xyz = r1.xyz + -r0.xzw;
  r0.xyz = r0.yyy * r1.xyz + r0.xzw;
  float3 vignetteInput;
  if(injectedData.toneMapType != 0.f){
    r0.xyzw = 0.18f;
    r0.xyzw = lerp(1.f, ImageAdjustments3.y, injectedData.fxAutoExposure) * r0.zzxy;
    r0.xyzw = saturate(float4(0.588235319,0.588235319,0.588235319,0.588235319) * r0.xyzw);
    r1.xyzw = float4(1.70000005,1.70000005,1.70000005,1.70000005) * r0.yyzw;
    r0.xyzw = float4(-0.98255378,-0.98255378,-0.98255378,-0.98255378) * r0.xyzw;
    r0.xyzw = exp2(r0.xyzw);
    r0.xyzw = float4(1.44580638,1.44580638,1.44580638,1.44580638) * r0.xyzw;
    r1.xyzw = log2(r1.xyzw);
    r1.xyzw = float4(0.564518631,0.564518631,0.564518631,0.564518631) * r1.xyzw;
    r1.xyzw = exp2(r1.xyzw);
    r0.xyzw = r1.xyzw * r0.xyzw;
    float midGray = renodx::color::srgb::Decode(r0.y);
    r0.xyz = applyUserTonemap(untonemapped, renodx::color::srgb::DecodeSafe(vanilla), midGray);
    r0.xyz = doLutThings(r0.xyz, ColorGradingLUT, ColorGradingLUTSampler_s);
    vignetteInput = renodx::color::srgb::EncodeSafe(rolloffSdr(r0.xyz));
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  } else {
    r0.xyz = lerp(vanilla, r0.xyz, injectedData.colorGradeLUTStrength);
    vignetteInput = r0.xyz;
  }
  o0.w = renodx::color::y::from::NTSC1953(r0.xyz);
  r1.xy = float2(-0.5,-0.7) + v2.zw;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1.5 * r0.w;
  r0.w = min(1, r0.w);
  r0.w = r0.w * r0.w;
  r1.xyz = float3(1.2,1.2,1.2) * vignetteInput;
  r1.xyz = max(float3(9.99999997e-07,9.99999997e-07,9.99999997e-07), abs(r1.xyz));
  r2.xyz = r1.xyz * r1.xyz;
  r3.xyz = r2.xyz * r1.xyz;
  r1.w = renodx::color::y::from::NTSC1953(r3.xyz);
  r1.xyz = -r1.xyz * r2.xyz + r1.www;
  r1.xyz = r1.xyz * float3(0.5,0.5,0.5) + r3.xyz;
  r1.xyz = float3(0.1,0.1,0.1) + r1.xyz;
  r1.w = 1 + -v2.w;
  r2.xyz = r1.www * float3(0.31,0.09,0.02) + float3(0.25,0.25,0.18);
  r0.w = BS_CustomPacked.w * r0.w * injectedData.fxVignette;
  r1.xyz = r2.xyz * r1.xyz + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  o0.xyz = r0.xyz;
  return;
}