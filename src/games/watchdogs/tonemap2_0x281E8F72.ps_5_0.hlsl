#include "./common.hlsl"

cbuffer PostFxBloom : register(b0){
  float4 _BlurRadii : packoffset(c0);
  float4 _ColorRemapTextureSize : packoffset(c1);
  float4 _QuadParams : packoffset(c2);
  float4 _ToneMapParams0 : packoffset(c3);
  float4 _UVOffsets[9] : packoffset(c4);
  float3 _ArtifactValues : packoffset(c13);
  float _AutoExpScaleAdaptationFactor : packoffset(c13.w);
  float3 _ToneMapParams1 : packoffset(c14);
  float _AutoExpScaleForcedValue : packoffset(c14.w);
  float2 _AutoExpScaleMinMax : packoffset(c15);
  float _AutoExpScaleKeyLuminance : packoffset(c15.z);
  float _AutoExpScaleManualExposureValueDelta : packoffset(c15.w);
  float2 _HistogramMinMax : packoffset(c16);
  float _AutoExposureScale : packoffset(c16.z);
  float _BloomCenterBoost : packoffset(c16.w);
  float2 _UVScale : packoffset(c17);
  float _BloomIntensity : packoffset(c17.z);
  float _BloomIntensityDiv4 : packoffset(c17.w);
  float _LuminanceThreshold : packoffset(c18);
  float _PixelCountSAT : packoffset(c18.y);
}
SamplerState PostFxBloom__BloomSampler__SampObj___s : register(s0);
SamplerState PostFxBloom__SourceTextureSampler__SampObj___s : register(s1);
SamplerState PostFxBloom__ColorRemapTexture__SampObj___s : register(s2);
SamplerState PostFxBloom__CurrentAutoExposureScaleTexture__SampObj___s : register(s3);
Texture2D<float4> PostFxBloom__BloomSampler__TexObj__ : register(t0);
Texture2D<float4> PostFxBloom__SourceTextureSampler__TexObj__ : register(t1);
Texture3D<float4> PostFxBloom__ColorRemapTexture__TexObj__ : register(t2);
Texture2D<float4> PostFxBloom__CurrentAutoExposureScaleTexture__TexObj__ : register(t3);

void main(
  float4 v0 : TEXCOORD0,
  float2 v1 : TEXCOORD1,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = PostFxBloom__BloomSampler__TexObj__.Sample(PostFxBloom__BloomSampler__SampObj___s, v1.xy).xyz;
    r0.a = renodx::color::y::from::BT709(r0.rgb);
  r1.x = -_ArtifactValues.y + r0.w;
  r0.w = saturate(r1.x / r0.w);
  r0.w = _ArtifactValues.z * r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.w = PostFxBloom__CurrentAutoExposureScaleTexture__TexObj__.Sample(PostFxBloom__CurrentAutoExposureScaleTexture__SampObj___s, float2(0.5,0.5)).x;
  r1.rgb = applyCA(PostFxBloom__SourceTextureSampler__TexObj__, PostFxBloom__SourceTextureSampler__SampObj___s, v0.xy, injectedData.fxChroma * injectedData.is_not_camera);
  r1.w = PostFxBloom__SourceTextureSampler__TexObj__.Sample(PostFxBloom__SourceTextureSampler__SampObj___s, v0.xy).w;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  o0.w = r1.w;
  r1.xyz = PostFxBloom__BloomSampler__TexObj__.Sample(PostFxBloom__BloomSampler__SampObj___s, v0.zw).xyz;
  r0.xyz = r1.xyz * injectedData.fxBloom + r0.xyz;
    r0.rgb = applyVignette(r0.rgb, v0.xy, injectedData.fxVignette * injectedData.is_not_camera);
    r0.rgb = applyUserTonemap(r0.rgb, PostFxBloom__ColorRemapTexture__TexObj__, PostFxBloom__ColorRemapTexture__SampObj___s,
                              _ToneMapParams0, _ToneMapParams1);
    r0.rgb = applyFilmGrain(r0.rgb, v0.xy, injectedData.fxFilmGrain * injectedData.is_not_camera);
    o0.rgb = PostToneMapScale(r0.rgb);
  return;
}