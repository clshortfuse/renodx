#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Fri Jun 27 11:59:33 2025

cbuffer CBRenderFrame : register(b2)
{
  uint iRenderFrame : packoffset(c0);
  uint iTotalTime : packoffset(c0.y);
  uint iTotalTimeEx : packoffset(c0.z);
  float fFPS : packoffset(c0.w);
  float fDeltaTime : packoffset(c1);
  float fSSAOEffect : packoffset(c1.y);
  bool bSSSEnable : packoffset(c1.z) = false;
  bool bIsRenderingWater : packoffset(c1.w) = false;
  float fWaterDepthBias : packoffset(c2);
  uint iGpuMode : packoffset(c2.y);
  float2 fDitherSize : packoffset(c2.z);
  bool bHdrOutput : packoffset(c3) = false;
  float fHdrOutputWhiteLevel : packoffset(c3.y) = {100};
  float fHdrOutputGamutMappingRatio : packoffset(c3.z) = {0};
  float fHdrOutputGamma : packoffset(c3.w) = {1};
  bool bIsGUIHdrGamma : packoffset(c4) = false;
}

// cbuffer CBToneMapping : register(b3)
// {
//   uint iToneMapType : packoffset(c0);
//   bool bLuminanceVersion : packoffset(c0.y);
//   float fShouldStr : packoffset(c0.z);
//   float fLinearStr : packoffset(c0.w);
//   float fIntermediate : packoffset(c1);
//   float fS1 : packoffset(c1.y);
//   float fS2 : packoffset(c1.z);
//   float fS3 : packoffset(c1.w);
//   float fS4 : packoffset(c2);
//   uint iLUTSize : packoffset(c2.y);
//   bool bIsLinearToPQ : packoffset(c2.z);
//   bool bIsPQToLinear : packoffset(c2.w);
//   bool bEnableColorGrading : packoffset(c3);
// }

SamplerState SSFilter_s : register(s0);
SamplerState SSColorGrading_s : register(s1);
Texture2D<float4> tBaseMap : register(t0);
Texture3D<float4> tLUT3DMap0 : register(t1);


// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TexCoord0,
  float2 w1 : TexCoord1,
  float4 v2 : Color0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = tBaseMap.Sample(SSFilter_s, v1.xy).xyzw;

  float3 untonemapped = r0.rgb;
  
  if (bEnableColorGrading != 0) {
    float3 sdr_color = CustomGradingBegin(untonemapped);
    r0.rgb = sdr_color;

    r1.x = iLUTSize;
    r1.x = 1 / r1.x;
    r1.y = 0.5 * r1.x;
    r1.z = tLUT3DMap0.Load(float4(0,0,0,0)).w;
    r1.z = 255 * r1.z;
    r2.xyz = saturate(r0.xyz / r1.zzz);
    r3.xyz = log2(r2.xyz);
    r3.xyz = float3(0.159301758,0.159301758,0.159301758) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r4.xyz = r3.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
    r3.xyz = r3.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
    r3.xyz = r4.xyz / r3.xyz;
    r3.xyz = log2(r3.xyz);
    r3.xyz = float3(78.84375,78.84375,78.84375) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r2.xyz = bIsLinearToPQ ? r3.xyz : r2.xyz;
    r1.x = 1 + -r1.x;
    r1.xyw = r2.xyz * r1.xxx + r1.yyy;
    r1.xyw = tLUT3DMap0.SampleLevel(SSColorGrading_s, r1.xyw, 0).xyz;
    r2.xyz = saturate(r1.xyw);
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r3.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r2.xyz;
    r2.xyz = -r2.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
    r2.xyz = r3.xyz / r2.xyz;
    r2.xyz = max(float3(0,0,0), r2.xyz);
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(6.27739477,6.27739477,6.27739477) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r1.xyw = bIsPQToLinear ? r2.xyz : r1.xyw;
    r0.xyz = r1.xyw * r1.zzz;
  
    r0.xyz = CustomGradingEnd(untonemapped, sdr_color, r0.xyz);
  }

  if (RENODX_TONE_MAP_TYPE != 0) {
    float3 outputColor = r0.xyz;
    outputColor = CustomTonemap(outputColor, v1.xy);
    //outputColor = renodx::color::gamma::DecodeSafe(outputColor, fHdrOutputGamma);
    o0.rgb = outputColor;
    o0.w = r0.w;

    // r0.xyz = o0.xyz;

    // r1.x = cmp(bHdrOutput != 0);
    // r1.y = cmp(bIsGUIHdrGamma == 0);
    // r1.x = r1.y ? r1.x : 0;
    // r1.yzw = cmp(r0.xyz < float3(1, 1, 1));
    // r2.xyz = max(float3(0, 0, 0), r0.xyz);
    // r2.xyz = log2(r2.xyz);
    // r2.xyz = fHdrOutputGamma * r2.xyz;
    // r2.xyz = exp2(r2.xyz);
    // r1.yzw = r1.yzw ? r2.xyz : r0.xyz;
    // o0.xyz = r1.xxx ? r1.yzw : r0.xyz;
    // o0.w = r0.w;

    return;
  }

  r1.x = cmp(iToneMapType == 5);
  if (r1.x != 0) {  // sdr path
  //if (1) {
    // Narkowicz ACES
    r1.xyz = r0.xyz * float3(2.50999999,2.50999999,2.50999999) + float3(0.0299999993,0.0299999993,0.0299999993);
    r1.xyz = r1.xyz * r0.xyz;
    r2.xyz = r0.xyz * float3(2.43000007,2.43000007,2.43000007) + float3(0.589999974,0.589999974,0.589999974);
    r2.xyz = r0.xyz * r2.xyz + float3(0.140000001,0.140000001,0.140000001);
    r0.xyz = r1.xyz / r2.xyz;
  } else {
    r1.x = cmp(iToneMapType == 6);
    if (r1.x != 0) {  // hdr path
	    // per channel compression?
      r1.xyz = r0.xyz * fLinearStr + fS4;
      r1.xyz = r1.xyz * r0.xyz + fS3;
      r2.xyz = r0.xyz * fShouldStr + fLinearStr;
      r2.xyz = r2.xyz * r0.xyz + fS2;
      r1.xyz = r1.xyz / r2.xyz;
      r1.xyz = -fS1 + r1.xyz;
      r0.xyz = fIntermediate * r1.xyz;
    } else { // doesn't run
      if (bLuminanceVersion != 0) {
        r1.x = dot(r0.xyz, float3(0.299010009,0.587000012,0.114));
        switch (iToneMapType) {
          case 1 :          break;
          case 2 :          r1.y = -1.44269502 * r1.x;
          r1.y = exp2(r1.y);
          r1.y = 1 + -r1.y;
          r1.y = r1.y / r1.x;
          r0.xyz = r1.yyy * r0.xyz;
          break;
          case 3 :          r1.y = -1.44269502 * r1.x;
          r1.y = exp2(r1.y);
          r1.y = 1 + -r1.y;
          r1.y = max(0, r1.y);
          r1.y = log2(r1.y);
          r1.y = 1.5 * r1.y;
          r1.y = exp2(r1.y);
          r1.y = r1.y / r1.x;
          r0.xyz = r1.yyy * r0.xyz;
          break;
          case 4 :          r1.x = 1 + r1.x;
          r0.xyz = r0.xyz / r1.xxx;
          break;
          default :
          break;
        }
      } else {
        switch (iToneMapType) {
          case 1 :          break;
          case 2 :          r1.xyz = float3(-1.44269502,-1.44269502,-1.44269502) * r0.xyz;
          r1.xyz = exp2(r1.xyz);
          r0.xyz = float3(1,1,1) + -r1.xyz;
          break;
          case 3 :          r1.xyz = float3(-1.44269502,-1.44269502,-1.44269502) * r0.xyz;
          r1.xyz = exp2(r1.xyz);
          r1.xyz = float3(1,1,1) + -r1.xyz;
          r1.xyz = max(float3(0,0,0), r1.xyz);
          r1.xyz = log2(r1.xyz);
          r1.xyz = float3(1.5,1.5,1.5) * r1.xyz;
          r0.xyz = exp2(r1.xyz);
          break;
          case 4 :          r1.xyz = float3(1,1,1) + r0.xyz;
          r0.xyz = r0.xyz / r1.xyz;
          break;
          default :
          break;
        }
      }
    }
  }
  
  r1.x = cmp(bHdrOutput != 0);
  r1.y = cmp(bIsGUIHdrGamma == 0);
  r1.x = r1.y ? r1.x : 0;
  r1.yzw = cmp(r0.xyz < float3(1,1,1));
  r2.xyz = max(float3(0,0,0), r0.xyz);
  r2.xyz = log2(r2.xyz);
  r2.xyz = fHdrOutputGamma * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r1.yzw = r1.yzw ? r2.xyz : r0.xyz;
  o0.xyz = r1.xxx ? r1.yzw : r0.xyz;
  o0.w = r0.w;
  return;
}