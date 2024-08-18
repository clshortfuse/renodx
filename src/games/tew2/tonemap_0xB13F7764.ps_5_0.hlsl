// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 16 00:14:03 2024
// Main tonemap shader [all effects on]

#include "./shared.h"
#include "./tonemapper.hlsl"

cbuffer fblock : register(b0)
{
  float4 renderpositiontoviewtexture : packoffset(c0);
  float4 tonemapparm2 : packoffset(c1);
  float4 tonemapparm4 : packoffset(c2);
  float4 tonemapparm5 : packoffset(c3);
  float4 bloomparm : packoffset(c4);
  float4 bloomnoiseparm : packoffset(c5);
  float4 viewrandom : packoffset(c6);
  float4 bloomnoisecolor : packoffset(c7);
  float4 bloomnoiseparm2 : packoffset(c8);
  float4 bloomtonemapparm : packoffset(c9);
  float4 bloomtonemapparm2 : packoffset(c10);
  float4 cgbloomgamma : packoffset(c11);
  float4 cgbloomgain : packoffset(c12);
  float4 volumelightparms4 : packoffset(c13);
  float4 volumelighttonemapparm : packoffset(c14);
  float4 volumelighttonemapparm2 : packoffset(c15);
  float4 testvector : packoffset(c16);
}

SamplerState viewcolormap_samp_state_s : register(s0);
SamplerState avgluminancedownsampletex_samp_state_s : register(s1);
SamplerState bloomtex_samp_state_s : register(s2);
SamplerState bloomnoisemappbr_samp_state_s : register(s3);
SamplerState bloomdustmappbr_samp_state_s : register(s4);
SamplerState volumelightmap_samp_state_s : register(s5);
Texture2D<float4> viewcolormap_samp : register(t0);
Texture2D<float4> avgluminancedownsampletex_samp : register(t1);
Texture2D<float4> bloomtex_samp : register(t2);
Texture2D<float4> bloomnoisemappbr_samp : register(t3);
Texture2D<float4> bloomdustmappbr_samp : register(t4);
Texture2D<float4> volumelightmap_samp : register(t5);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * renderpositiontoviewtexture.zw + renderpositiontoviewtexture.xy;
  r1.xyz = viewcolormap_samp.SampleLevel(viewcolormap_samp_state_s, r0.xy, 0).xyz;
  r0.z = avgluminancedownsampletex_samp.SampleLevel(avgluminancedownsampletex_samp_state_s, float2(0,0), 0).y;
  r1.xyz = r1.xyz * r0.zzz;
    
    float3 untonemapped = r1.rgb;
 // Tonemapper
  r2.xyz = tonemapparm4.xxx * r1.xyz;
  r2.xyz = tonemapparm4.zzz * tonemapparm4.yyy + r2.xyz;
  r0.zw = tonemapparm5.xy * tonemapparm4.ww;
  r2.xyz = r1.xyz * r2.xyz + r0.zzz;
  r3.xyz = tonemapparm4.xxx * r1.xyz + tonemapparm4.yyy;
  r1.xyz = r1.xyz * r3.xyz + r0.www;
  r1.xyz = r2.xyz / r1.xyz;
  r0.z = tonemapparm5.x / tonemapparm5.y;
  r1.xyz = r1.xyz + -r0.zzz;
 //end vanilla tonemapper
    
    float3 vanillaColor = r1.rgb;
    
 //second tonemap run for midgray   
    r1.rgb = (0.18f, 0.18f, 0.18f);
    
    r2.xyz = tonemapparm4.xxx * r1.xyz;
    r2.xyz = tonemapparm4.zzz * tonemapparm4.yyy + r2.xyz;
    r0.zw = tonemapparm5.xy * tonemapparm4.ww;
    r2.xyz = r1.xyz * r2.xyz + r0.zzz;
    r3.xyz = tonemapparm4.xxx * r1.xyz + tonemapparm4.yyy;
    r1.xyz = r1.xyz * r3.xyz + r0.www;
    r1.xyz = r2.xyz / r1.xyz;
    r0.z = tonemapparm5.x / tonemapparm5.y;
    r1.xyz = r1.xyz + -r0.zzz;
    
    float3 vanMidGray = r1.rgb;
 //end second tonemap run   

        
  //r1.xyz = max(float3(0,0,0), r1.xyz); //clamp negative colors, we'll do this inside of RenoDX
  
  r2.xyz = bloomtex_samp.SampleLevel(bloomtex_samp_state_s, r0.xy, 0).xyz;
  r2.xyz = bloomparm.yyy * r2.xyz;
  r0.z = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r3.xy = r0.xy * bloomnoiseparm.xy + viewrandom.xy;
  r3.xyz = bloomnoisemappbr_samp.SampleLevel(bloomnoisemappbr_samp_state_s, r3.xy, 0).xyz;
  r3.xyz = bloomnoisecolor.xyz * r3.xyz;
  r0.w = (r0.z);
  r0.w = log2(r0.w);
  r0.w = bloomnoiseparm2.y * r0.w;
  r0.w = exp2(r0.w);
  r0.w = (bloomnoiseparm.z * r0.w);
  r0.w = r0.w + -r0.z;
  r0.w = bloomnoiseparm2.x * r0.w + r0.z;
  r2.xyz = r3.xyz * r0.www + r2.xyz;
  r0.z = 9.99999997e-07 + r0.z;
  r0.w = bloomtonemapparm.x * r0.z;
  r0.w = bloomtonemapparm.z * bloomtonemapparm.y + r0.w;
  r3.xy = bloomtonemapparm2.xy * bloomtonemapparm.ww;
  r0.w = r0.z * r0.w + r3.x;
  r1.w = bloomtonemapparm.x * r0.z + bloomtonemapparm.y;
  r1.w = r0.z * r1.w + r3.y;
  r0.w = r0.w / r1.w;
  r1.w = bloomtonemapparm2.x / bloomtonemapparm2.y;
  r0.w = -r1.w + r0.w;
  r0.w = max(0, r0.w);
  r1.w = (int)r0.w & 0x7fffffff;
  r1.w = cmp((int)r1.w == 0x7f800000);
  r0.w = min(65535, r0.w);
  r0.w = r1.w ? 0 : r0.w;
  r2.xyz = r2.xyz * r0.www;
  r2.xyz = r2.xyz / r0.zzz;
  r3.xyz = bloomdustmappbr_samp.SampleLevel(bloomdustmappbr_samp_state_s, r0.xy, 0).xyz;
  r2.xyz = r3.xyz * r2.xyz + r2.xyz;
  r3.xyz = float3(1,1,1) / cgbloomgamma.xyz;
  r2.xyz = log2(r2.xyz);
  r2.xyz = r3.xyz * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r0.z = cmp(0 < volumelightparms4.w);
  if (r0.z != 0) {
    r0.xyz = volumelightmap_samp.SampleLevel(volumelightmap_samp_state_s, r0.xy, 0).xyz;
    r0.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
    r1.w = cmp(9.99999997e-07 < r0.w);
    r2.w = volumelighttonemapparm.x * r0.w;
    r2.w = volumelighttonemapparm.z * volumelighttonemapparm.y + r2.w;
    r3.xy = volumelighttonemapparm2.xy * volumelighttonemapparm.ww;
    r2.w = r0.w * r2.w + r3.x;
    r3.x = volumelighttonemapparm.x * r0.w + volumelighttonemapparm.y;
    r3.x = r0.w * r3.x + r3.y;
    r2.w = r2.w / r3.x;
    r3.x = volumelighttonemapparm2.x / volumelighttonemapparm2.y;
    r2.w = -r3.x + r2.w;
    r2.w = max(0, r2.w);
    r0.xyz = r2.www * r0.xyz;
    r0.xyz = r0.xyz / r0.www;
    r0.xyz = r1.www ? r0.xyz : 0;
  } else {
    r0.xyz = float3(0,0,0);
  }

    //r1.xyz = r2.xyz * cgbloomgain.xyz + r1.xyz; //Add bloom slider [vanilla code]
    vanillaColor.rgb = r2.xyz * cgbloomgain.xyz * injectedData.fxBloom + vanillaColor; //Add bloom to vanillaColor

    untonemapped.rgb = r2.xyz * cgbloomgain.xyz * injectedData.fxBloom + untonemapped; //We add untonemapped to where bloom gets added to the main render, to fix issues with bloom -- Also add a slider

    r1.rgb = applyUserTonemap(untonemapped, vanillaColor, renodx::color::y::from::BT709(vanMidGray)); //Apply RenoDX
    

    
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = rsqrt(r0.xyz);
  r0.xyz = float3(1,1,1) / r0.xyz;
  o0.xyz = testvector.zzz * float3(1.20000005,1.20000005,1.20000005) + r0.xyz;
  o0.w = 1;
  
  
    o0.rgb = renodx::math::SafePow(o0.rgb, 2.2); // 2.2 gamma
    
    o0.rgb *= injectedData.toneMapGameNits; // Scale by user nits
        
    o0.rgb /= 80.f;
  
  return;
}