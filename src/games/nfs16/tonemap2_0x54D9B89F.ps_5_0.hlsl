#include "./common.hlsl"

cbuffer _Globals : register(b0) {
  float2 invPixelSize : packoffset(c0);
  float3 filmGrainColorScale : packoffset(c1);
  float4 filmGrainTextureScaleAndOffset : packoffset(c2);
  float4 color : packoffset(c3);
  float4 colorMatrix0 : packoffset(c4);
  float4 colorMatrix1 : packoffset(c5);
  float4 colorMatrix2 : packoffset(c6);
  float4 ironsightsDofParams : packoffset(c7);
  float4 filmicLensDistortParams : packoffset(c8);
  float4 colorScale : packoffset(c9);
  float3 depthScaleFactors : packoffset(c10);
  float4 dofParams : packoffset(c11);
  float4 dofParams2 : packoffset(c12);
  float4 dofDebugParams : packoffset(c13);
  float3 bloomScale : packoffset(c14);
  float3 luminanceVector : packoffset(c15);
  float3 vignetteParams : packoffset(c16);
  float4 vignetteColor : packoffset(c17);
  float4 chromostereopsisParams : packoffset(c18);
  float4 distortionScaleOffset : packoffset(c19);
  float3 maxClampColor : packoffset(c20);
  float fftBloomSpikeDampingScale : packoffset(c20.w);
  float4 fftKernelSampleScales : packoffset(c21);
}
SamplerState mainTextureSampler_s : register(s0);
SamplerState colorGradingTextureSampler_s : register(s1);
SamplerState distortionTextureSampler_s : register(s2);
SamplerState tonemapBloomTextureSampler_s : register(s3);
SamplerState filmGrainTextureSampler_s : register(s4);
Texture2D<float4> mainTexture : register(t0);
Texture3D<float4> colorGradingTexture : register(t1);
Texture2D<float4> distortionTexture : register(t2);
Texture2D<float4> tonemapBloomTexture : register(t3);
Texture2D<float4> filmGrainTexture : register(t4);

#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    float2 v2: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5, -0.5) + v2.xy;
  r0.z = dot(r0.xy, r0.xy);
  r0.w = cmp(abs(filmicLensDistortParams.y) < 9.99999975e-05);
  if (r0.w != 0) {
    r0.w = r0.z * filmicLensDistortParams.x + 1;
    r0.w = filmicLensDistortParams.z * r0.w;
  } else {
    r1.x = sqrt(r0.z);
    r1.x = filmicLensDistortParams.y * r1.x + filmicLensDistortParams.x;
    r0.z = r0.z * r1.x + 1;
    r0.w = filmicLensDistortParams.w * r0.z;
  }
  r1.xyzw = r0.xyxy * r0.wwww + float4(0.5, 0.5, 0.5, 0.5);
  r2.xyz = distortionTexture.Sample(distortionTextureSampler_s, v2.xy).xyz;
  r3.xyzw = r2.xyxy * distortionScaleOffset.xyxy + distortionScaleOffset.zwzw;
  r1.xyzw = r3.xyzw + r1.xyzw;
  r2.w = mainTexture.Sample(mainTextureSampler_s, r1.zw).z;
  r3.xyz = tonemapBloomTexture.Sample(tonemapBloomTextureSampler_s, r1.zw).xyz;
  r1.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r1.xyzw;
  r1.xyzw = r1.xyzw + r1.xyzw;
  r1.xyzw = r1.xyzw * chromostereopsisParams.xyzw + float4(0.5, 0.5, 0.5, 0.5);
  r2.x = mainTexture.Sample(mainTextureSampler_s, r1.xy).x;
  r2.y = mainTexture.Sample(mainTextureSampler_s, r1.zw).y;
  r1.xyz = r3.xyz * r2.zzz + r2.xyw;
  r1.xyz = r3.xyz * bloomScale.xyz * injectedData.fxBloom + r1.xyz;
  r1.xyz = colorScale.xyz * r1.xyz;
  r0.xy = vignetteParams.xy * r0.xy * min(1, injectedData.fxVignette);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = saturate(-r0.x * vignetteColor.w + 1);
  r0.x = log2(r0.x);
  r0.x = vignetteParams.z * r0.x * max(1, injectedData.fxVignette);
  r0.x = exp2(r0.x);
  r0.yzw = r1.xyz * r0.xxx;
  float3 untonemapped = r0.gba;
  r2.xyz = cmp(float3(0.100000001, 0.100000001, 0.100000001) < r0.yzw);
  if (r2.x != 0) {
    r1.x = r1.x * r0.x + -0.100000001;
    r1.x = 1.74532938 * r1.x;
    r1.w = min(1, abs(r1.x));
    r2.x = max(1, abs(r1.x));
    r2.x = 1 / r2.x;
    r1.w = r2.x * r1.w;
    r2.x = r1.w * r1.w;
    r2.w = r2.x * 0.0208350997 + -0.0851330012;
    r2.w = r2.x * r2.w + 0.180141002;
    r2.w = r2.x * r2.w + -0.330299497;
    r2.x = r2.x * r2.w + 0.999866009;
    r2.w = r2.x * r1.w;
    r3.x = cmp(1 < abs(r1.x));
    r2.w = r2.w * -2 + 1.57079637;
    r2.w = r3.x ? r2.w : 0;
    r1.w = r1.w * r2.x + r2.w;
    r1.x = min(1, r1.x);
    r1.x = cmp(r1.x < -r1.x);
    r1.x = r1.x ? -r1.w : r1.w;
    r0.y = r1.x * 0.572957754 + 0.100000001;
    r1.x = cmp(0.850000024 < r0.y);
    if (r1.x != 0) {
      r1.x = r0.y * 0.0199999809 + 1;
      r0.y = r1.x * r0.y;
    }
  }
  if (r2.y != 0) {
    r1.x = r1.y * r0.x + -0.100000001;
    r1.x = 1.74532938 * r1.x;
    r1.y = min(1, abs(r1.x));
    r1.w = max(1, abs(r1.x));
    r1.w = 1 / r1.w;
    r1.y = r1.y * r1.w;
    r1.w = r1.y * r1.y;
    r2.x = r1.w * 0.0208350997 + -0.0851330012;
    r2.x = r1.w * r2.x + 0.180141002;
    r2.x = r1.w * r2.x + -0.330299497;
    r1.w = r1.w * r2.x + 0.999866009;
    r2.x = r1.y * r1.w;
    r2.y = cmp(1 < abs(r1.x));
    r2.x = r2.x * -2 + 1.57079637;
    r2.x = r2.y ? r2.x : 0;
    r1.y = r1.y * r1.w + r2.x;
    r1.x = min(1, r1.x);
    r1.x = cmp(r1.x < -r1.x);
    r1.x = r1.x ? -r1.y : r1.y;
    r0.z = r1.x * 0.572957754 + 0.100000001;
    r1.x = cmp(0.850000024 < r0.z);
    if (r1.x != 0) {
      r1.x = r0.z * 0.0199999809 + 1;
      r0.z = r1.x * r0.z;
    }
  }
  if (r2.z != 0) {
    r0.x = r1.z * r0.x + -0.100000001;
    r0.x = 1.74532938 * r0.x;
    r1.x = min(1, abs(r0.x));
    r1.y = max(1, abs(r0.x));
    r1.y = 1 / r1.y;
    r1.x = r1.x * r1.y;
    r1.y = r1.x * r1.x;
    r1.z = r1.y * 0.0208350997 + -0.0851330012;
    r1.z = r1.y * r1.z + 0.180141002;
    r1.z = r1.y * r1.z + -0.330299497;
    r1.y = r1.y * r1.z + 0.999866009;
    r1.z = r1.x * r1.y;
    r1.w = cmp(1 < abs(r0.x));
    r1.z = r1.z * -2 + 1.57079637;
    r1.z = r1.w ? r1.z : 0;
    r1.x = r1.x * r1.y + r1.z;
    r0.x = min(1, r0.x);
    r0.x = cmp(r0.x < -r0.x);
    r0.x = r0.x ? -r1.x : r1.x;
    r0.w = r0.x * 0.572957754 + 0.100000001;
    r0.x = cmp(0.850000024 < r0.w);
    if (r0.x != 0) {
      r0.x = r0.w * 0.0199999809 + 1;
      r0.w = r0.w * r0.x;
    }
  }
  r1.xyz = float3(1.10000002, 1.10000002, 1.10000002) * r0.yzw;
  float3 LUTless = r1.rgb;
  r2.xyz = float3(14.2120008, 14.2120008, 14.2120008) * r0.yzw;
  r1.xyz = log2(abs(r1.xyz));
  r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r0.xyz = cmp(float3(0.00284618186, 0.00284618186, 0.00284618186) >= r0.yzw);
  r0.xyz = r0.xyz ? r2.xyz : r1.xyz;
  r0.xyz = r0.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
  r0.xyz = colorGradingTexture.Sample(colorGradingTextureSampler_s, r0.xyz).xyz;
  r0.rgb = applyUserTonemap(untonemapped, colorGradingTexture, colorGradingTextureSampler_s, LUTless);
  r1.xy = v2.xy * filmGrainTextureScaleAndOffset.xy + filmGrainTextureScaleAndOffset.zw;
    r0.w = filmGrainTexture.Sample(filmGrainTextureSampler_s, r1.xy).x;
    r0.w = -0.5 + r0.w;
    r0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
    r0.xyz = r0.www * filmGrainColorScale.xyz * injectedData.fxFilmGrain + r0.xyz;
    r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  o0.w = renodx::color::y::from::BT709(r0.rgb);
  o0.xyz = r0.xyz;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
