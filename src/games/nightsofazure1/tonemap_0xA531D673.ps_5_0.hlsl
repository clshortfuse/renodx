// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 11 19:29:56 2024
// This is the last shader before the UI gets drawn
// The game has no tonemapper, so we're just going to slap on DICE here to compress the highlights, and call it a day
// With just BGR8_TYPELESS upgraded, the game runs bright, so we'll just add a slider, and hdr done!

#include "./shared.h"

SamplerState smplScene_s : register(s0);
SamplerState smplBlurFront_s : register(s1);
SamplerState smplBlurBack_s : register(s2);
Texture2D<float4> smplScene_Tex : register(t0);
Texture2D<float4> smplBlurFront_Tex : register(t1);
Texture2D<float4> smplBlurBack_Tex : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = smplBlurBack_Tex.Sample(smplBlurBack_s, v1.xy).xyzw;
  r1.xyzw = smplScene_Tex.Sample(smplScene_s, v1.xy).xyzw;
  r2.x = cmp(r1.w < 0.5);
  r0.xyzw = r2.xxxx ? r1.xyzw : r0.xyzw;
  r0.xyzw = r0.xyzw + -r1.xyzw;
  r2.x = -0.5 + r1.w;
  r2.x = abs(r2.x) * -2 + 1;
  r2.x = max(0, r2.x);
  r2.x = 9.99999975e-06 + r2.x;
  r2.x = 1 / r2.x;
  r2.x = -1 + r2.x;
  r2.x = saturate(0.25 * r2.x);
  r0.xyzw = r2.xxxx * r0.xyzw + r1.xyzw;
  r1.xyzw = smplBlurFront_Tex.Sample(smplBlurFront_s, v1.xy).xyzw;
  r2.xyzw = r1.xyzw + -r0.xyzw;
  r1.x = -0.5 + r1.w;
  r1.x = abs(r1.x) * -2 + 1;
  r1.x = max(0, r1.x);
  r1.x = 9.99999975e-06 + r1.x;
  r1.x = 1 / r1.x;
  r1.x = -1 + r1.x;
  r1.x = saturate(0.25 * r1.x);
  o0.xyzw = r1.xxxx * r2.xyzw + r0.xyzw;
    //Vanilla shader end
    
    // Start dice (ty Musa for max pain example code)
    if (injectedData.toneMapType >= 2)
    {
       //Converting from gamma space to linear space
        const float paperWhite = injectedData.toneMapGameNits / 80.f; 
        float3 linearColor = pow(abs(o0.xyz), 2.2) * sign(o0.xyz);
        linearColor *= paperWhite;

        const float peakWhite = injectedData.toneMapPeakNits / 80.f; //Getting the peak slider's value
        const float highlightsShoulderStart = paperWhite; // Don't tonemap the "SDR" range
        linearColor = renodx::tonemap::dice::BT709(linearColor, peakWhite, highlightsShoulderStart); //Do DICE with inputs

        linearColor /= paperWhite; 

        float3 linearSDR = sign(r0.rgb) * pow(abs(r0.rgb), 2.2f);


        o0.xyz = pow(abs(linearColor), 1.0 / 2.2) * sign(linearColor); //Inverse 2.2 gamma as the final output; Final will convert back to linear space


    }
    else if (injectedData.toneMapType == 0) //If tonemapper is vanilla, output is clamped
    {
        o0.xyz = saturate(o0.xyz);
    }
    
  return;
}