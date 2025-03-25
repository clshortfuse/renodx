#include "./shared.h"

cbuffer cFilter : register(b0)
{
  row_major float3x4 cFilter : packoffset(c0);
}

cbuffer cFilterForDark : register(b1)
{
  row_major float3x4 cFilterForDark : packoffset(c0);
}

cbuffer cLutParam : register(b2)
{
  float4 cLutParam : packoffset(c0);
}

cbuffer cDarkFilterParam : register(b3)
{
  float4 cDarkFilterParam : packoffset(c0);
}

SamplerState sInputS_s : register(s0);
SamplerState sLutS_s : register(s1);
Texture2D<float4> sInputT : register(t0);
Texture2D<float4> sLutT : register(t1);


float SampleLUT(float colorChannel) {
    float unclippedColorChannel = colorChannel;
    float clippedColorChannel = saturate(abs(colorChannel));
    float outValue = sLutT.Sample(sLutS_s, float2(clippedColorChannel * cLutParam.x + cLutParam.y, 0.5f)).w;
    if (clippedColorChannel != 0.f) {
      outValue *= unclippedColorChannel / clippedColorChannel;
    }
    
    return outValue;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 outputColor : SV_TARGET0)
{  
  float4 inputColor = sInputT.Sample(sInputS_s, v1.xy);
  outputColor = inputColor;
  
  float4 filterR = cFilter._m00_m01_m02_m03;
  float4 filterG = cFilter._m10_m11_m12_m13;
  float4 filterB = cFilter._m20_m21_m22_m23;

  float4 colorAfterLut;

  if (injectedData.toneMapType == 0) {
    float4 lutPreparedColor;
    lutPreparedColor.rgb = inputColor.rgb * cLutParam.xxx + cLutParam.yyy;
    lutPreparedColor.a = 0.5;
    colorAfterLut.x = sLutT.Sample(sLutS_s, lutPreparedColor.xw).w;
    colorAfterLut.y = sLutT.Sample(sLutS_s, lutPreparedColor.yw).w;
    colorAfterLut.z = sLutT.Sample(sLutS_s, lutPreparedColor.zw).w;
  } else {
    colorAfterLut.x = SampleLUT(inputColor.r);
    colorAfterLut.y = SampleLUT(inputColor.g);
    colorAfterLut.z = SampleLUT(inputColor.b);
  }

  // fix raised black floor
  filterR.a = filterR.a > 0.f ? max(0.f, filterR.a + injectedData.blackFloorOffset) : filterR.a;
  filterG.a = filterG.a > 0.f ? max(0.f, filterG.a + injectedData.blackFloorOffset) : filterG.a;
  filterB.a = filterB.a > 0.f ? max(0.f, filterB.a + injectedData.blackFloorOffset) : filterB.a;

  colorAfterLut.w = 1;

  float3 someColor; // Filtered color
  someColor.r = dot(filterR, colorAfterLut.xyzw);
  someColor.g = dot(filterG, colorAfterLut.xyzw);
  someColor.b = dot(filterB, colorAfterLut.xyzw);

  float luminance = injectedData.toneMapType > 0 ? dot(someColor.xyz, float3(0.2126390059,0.7151686788,0.0721923154)) : saturate(dot(someColor.xyz, float3(0.298909992,0.586610019,0.114480004)));  // fixed from wrong BT.601 values, and removed saturate
  float somethingFromLuminance = luminance * 0.899999976 + 0.0500000007;
  float darkFilterParam1 = max(0, 0.5 * cDarkFilterParam.y);
  float somethingFromLuminancePlusParam = somethingFromLuminance + darkFilterParam1;
  float somethingFromLuminanceMinusParam = somethingFromLuminance - darkFilterParam1;
  float someMax = max(0.0500000007, somethingFromLuminanceMinusParam);
  float someMin = min(0.949999988, somethingFromLuminancePlusParam);
  float someMinMinusSomeMax = someMin - someMax;

  float r0 = max(0, cDarkFilterParam.x) - someMax;
  r0 = saturate(r0 * (1 / someMinMinusSomeMax));
  r0 = (r0 * -2 + 3) * (r0 * r0);
  float filterForDarkIntensity = min(1, r0);
  
  float4 preFilterForDarkColor;
  preFilterForDarkColor.rgb = someColor.xyz;
  preFilterForDarkColor.a = 1;
  // This code made no sense, they supposedly had a second LUT here, removed it and forgot to remove the LUT coordinates scaling
  if (injectedData.toneMapType > 0) {
    preFilterForDarkColor.rgb *= cLutParam.xxx + cLutParam.yyy;
  }
  
  float3 filterForDarkColor;
  filterForDarkColor.r = dot(cFilterForDark._m00_m01_m02_m03, preFilterForDarkColor.rgba);
  filterForDarkColor.g = dot(cFilterForDark._m10_m11_m12_m13, preFilterForDarkColor.rgba);
  filterForDarkColor.b = dot(cFilterForDark._m20_m21_m22_m23, preFilterForDarkColor.rgba);
  outputColor.rgb = lerp(someColor.rgb, filterForDarkColor.rgb, filterForDarkIntensity);
  //outputColor.rgba = lerp(inputColor.rgba, outputColor.rgba , cLutParam.zzzz); //added with 7.2

  outputColor.rgb = injectedData.toneMapType == 0 ? saturate(outputColor.rgb) : max(outputColor.rgb, 0);
  outputColor.a = saturate(outputColor.a);

  return;
}