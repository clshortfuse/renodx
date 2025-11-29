// ---- Created with 3Dmigoto v1.4.1 on Mon Oct 27 14:03:36 2025

cbuffer _Globals : register(b0)
{
  float2 fParam_DepthCastScaleOffset : packoffset(c0) = {1,0};
  float4 fParam_DepthOfFieldFactorScaleOffset : packoffset(c1) = {0.5,0.5,2,-1};
  float4 fParam_HDRFormatFactor_LOGRGB : packoffset(c2);
  float4 fParam_HDRFormatFactor_RGBALUM : packoffset(c3);
  float4 fParam_HDRFormatFactor_REINHARDRGB : packoffset(c4);
  float2 fParam_ScreenSpaceScale : packoffset(c5) = {1,-1};
  float4x4 m44_ModelViewProject : packoffset(c6);
  float4 vParam_LensDistortion : packoffset(c10);
  float4 afUVWQ_TexCoordScaleOffset[4] : packoffset(c11);
  float4 fParam_PerspectiveFactor : packoffset(c15);
  float fParam_FocusDistance : packoffset(c16);
  float4 fParam_DepthOfFieldConvertDepthFactor : packoffset(c17);
  float2 afXY_DepthOfFieldLevelBlendFactor16[16] : packoffset(c18);
  float fParam_DepthOfFieldLayerMaskThreshold : packoffset(c33.z) = {0.25};
  float fParam_DepthOfFieldFactorThreshold : packoffset(c33.w) = {0.00039999999};
  float4 afUV_TexCoordOffsetV16[16] : packoffset(c34);
  float4 afUV_TexCoordOffsetP32[96] : packoffset(c50);
  float4 afParam_TexCoordScaler8[8] : packoffset(c146);
  float4 afRGBA_Modulate[32] : packoffset(c154);
  float4 afRGBA_Offset[16] : packoffset(c186);
  float4 fParam_GammaCorrection : packoffset(c202) = {0.454545468,0.454545468,0.454545468,0.454545468};
  float4 fParam_DitherOffsetScale : packoffset(c203) = {0.00392156886,0.00392156886,-0.00392156886,0};
  float4 fRGBA_Constant : packoffset(c204);
  float4 afRGBA_Constant[4] : packoffset(c205);
  float4 fParam_TonemapMaxMappingLuminance : packoffset(c209) = {1,1,1.015625,1};
  float4 fParam_BrightPassRemapFactor : packoffset(c210);
  float4x4 m44_ColorTransformMatrix : packoffset(c211);
  float4x4 m44_PreTonemapColorTransformMatrix : packoffset(c215);
  float4x4 m44_PreTonemapGlareColorTransformMatrix : packoffset(c219);
  float4 fParam_VignetteSimulate : packoffset(c223);
  float fParam_VignettePowerOfCosine : packoffset(c224);
  float4x4 am44_TransformMatrix[8] : packoffset(c225);
}

SamplerState asamp2D_Texture_s : register(s0);
Texture2D<float4> atex2D_Texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float2 v1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Grab the source color and pre-scale it for the bright-pass computation.
  r0.xyzw = atex2D_Texture.Sample(asamp2D_Texture_s, v0.xy, int2(0, 0)).xyzw;
  r0.xyz = afRGBA_Modulate[0].xyz * r0.xyz;
  o0.w = r0.w;
  // Derive average luminance and compute a remapped bright-pass value.
  r0.w = dot(r0.xyz, float3(0.333333343,0.333333343,0.333333343));
  r1.x = -afRGBA_Modulate[2].w + r0.w;
  r0.w = 2.38418579e-07 + r0.w;
  r0.xyz = r0.xyz / r0.www;
  r0.w = max(0, r1.x);
  r1.x = fParam_BrightPassRemapFactor.x + r0.w;
  r1.x = r1.x * r0.w + 1;
  r1.x = sqrt(r1.x);
  r1.x = r1.x + r0.w;
  r1.x = -1 + r1.x;
  r1.x = fParam_BrightPassRemapFactor.w * r1.x;
  r1.xyz = r1.xxx * r0.xyz;
  r0.xyz = r0.xyz * r0.www;
  // Select between original and boosted color depending on luminance.
  r0.w = cmp(0 < r0.w);
  r0.xyz = lerp(r0.xyz, r1.xyz, r0.www);
  // Apply a radial vignette falloff using the secondary UV input.
  r0.w = dot(v1.xy, v1.xy);
  r1.x = 1 + r0.w;
  r0.w = saturate(-r0.w * 2 + r1.x);
  r0.w = r0.w * r0.w;
  r0.w = r0.w * r0.w;
  r0.xyz = r0.xyz * r0.www;
  // Final scaling, clamp to HDR range cap, and output.
  r0.xyz = afRGBA_Modulate[1].xyz * r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  o0.xyz = min(float3(64512,64512,64512), r0.xyz);
  return;
}