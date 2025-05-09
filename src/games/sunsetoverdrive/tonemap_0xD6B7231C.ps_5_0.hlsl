#include "./common.hlsl"

cbuffer PSToneMapCB : register(b2){
  float4 g_TM_VignetteParams : packoffset(c0);
  float g_TM_BloomDirtiness : packoffset(c1);
  float g_TM_ColorCorrectionLUTDimension3D : packoffset(c1.y);
  float g_TM_Saturation : packoffset(c1.z);
  float g_TM_PadA : packoffset(c1.w);
  float g_TM_GrainSizeRcp : packoffset(c2);
  float g_TM_GrainStrength : packoffset(c2.y);
  float g_TM_GrainSecondOctaveStrength : packoffset(c2.z);
  float g_TM_ViewportAspectRatio : packoffset(c2.w);
  float g_TM_Brightness : packoffset(c3);
}
SamplerState g_LinearClampSampler_s : register(s2);
SamplerState g_ToneCurveSampler_s : register(s5);
SamplerState g_RadianceMapSampler_s : register(s6);
Texture1D<float4> g_ToneCurve : register(t5);
Texture2D<float4> g_RadianceMap : register(t6);
StructuredBuffer<float> g_AdaptedLumBuffer : register(t7);
Texture3D<float4> g_ColorLut3d : register(t12);

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = g_RadianceMap.Sample(g_RadianceMapSampler_s, v1.xy).xyz;
  r0.w = g_AdaptedLumBuffer[1].x;
  r0.xyz = r0.xyz * lerp(1.f, r0.www, injectedData.fxAutoExposure);
  float3 untonemapped = r0.rgb;
  r0.xyz = max(float3(0.00390625,0.00390625,0.00390625), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.0769230798,0.0769230798,0.0769230798) + float3(0.615384638,0.615384638,0.615384638);
  r0.xyz = min(float3(1,1,1), r0.xyz);
  r1.x = g_ToneCurve.Sample(g_ToneCurveSampler_s, r0.x).x;
  r1.y = g_ToneCurve.Sample(g_ToneCurveSampler_s, r0.y).x;
  r1.z = g_ToneCurve.Sample(g_ToneCurveSampler_s, r0.z).x;
  float3 vanilla = r1.rgb;
  r0.r = 0.18f;
  r0.x = log2(r0.x);
  r0.x = r0.x * 0.0769230798f + 0.615384638f;
  r1.x = g_ToneCurve.Sample(g_ToneCurveSampler_s, r0.x).x;
  float midGray = renodx::color::y::from::BT709(r1.rrr);
  r0.xyz = log2(abs(r1.xyz));
  r0.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = cmp(r1.xyz < float3(0.00313080009,0.00313080009,0.00313080009));
  r1.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
  r0.xyz = r2.xyz ? r1.xyz : r0.xyz;
  r0.xyz = saturate(g_TM_Brightness * r0.xyz);
  r0.w = -1 + g_TM_ColorCorrectionLUTDimension3D;
  r0.w = r0.w / g_TM_ColorCorrectionLUTDimension3D;
  r1.x = g_TM_ColorCorrectionLUTDimension3D + g_TM_ColorCorrectionLUTDimension3D;
  r1.x = 1 / r1.x;
  r0.xyz = r0.www * r0.xyz + r1.xxx;
  r0.xyz = g_ColorLut3d.Sample(g_LinearClampSampler_s, r0.xyz).xyz;
  r0.rgb = applyUserTonemap(untonemapped, g_ColorLut3d, g_LinearClampSampler_s, vanilla, midGray);
  r0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
  r1.xy = float2(1,1) + -v1.xy;
  r1.xy = v1.xy * r1.xy;
  r0.w = r1.x * r1.y;
  r0.w = saturate(4 * r0.w);
  r0.w = log2(r0.w);
  r0.w = g_TM_VignetteParams.x * r0.w * injectedData.fxVignette;
  r0.w = exp2(r0.w);
  r0.w = saturate(r0.w * g_TM_VignetteParams.y + g_TM_VignetteParams.z);
  o0.xyz = r0.xyz * r0.www;
  o0.w = 1;
  return;
}