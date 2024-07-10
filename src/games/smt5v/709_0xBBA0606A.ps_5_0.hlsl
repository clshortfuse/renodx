// ---- Created with 3Dmigoto v1.3.16 on Sun Jul  7 17:53:22 2024
#include "./shared.h"

Texture3D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[136];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[68];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float2 v0 : TEXCOORD0,
  linear noperspective float2 w0 : TEXCOORD3,
  linear noperspective float4 v1 : TEXCOORD1,
  linear noperspective float4 v2 : TEXCOORD2,
  float2 v3 : TEXCOORD4,
  float4 v4 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v2.w * 543.309998 + v2.z;
  r0.x = sin(r0.x);
  r0.x = 493013 * r0.x;
  r0.x = frac(r0.x);
  r0.yzw = t0.Sample(s0_s, v0.xy).xyz; //Renderer?
  r0.yzw = cb1[135].zzz * r0.yzw;
  r1.xy = cb0[58].zw * v0.xy + cb0[59].xy;
  r1.xy = max(cb0[50].zw, r1.xy);
  r1.xy = min(cb0[51].xy, r1.xy);
  r1.xyz = t1.Sample(s1_s, r1.xy).xyz;
  r1.xyz = cb1[135].zzz * r1.xyz;
  r2.xy = w0.xy * cb0[67].zw + cb0[67].xy;
  r2.xy = r2.xy * float2(0.5,-0.5) + float2(0.5,0.5);
  r2.xyz = t2.Sample(s2_s, r2.xy).xyz;
  r2.xyz = r2.xyz * cb0[66].xyz + cb0[61].xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.yzw = r0.yzw * cb0[60].xyz + r1.xyz;
    
    
    
  r0.yzw = v1.xxx * r0.yzw; //auto exposure?
  r1.xy = cb0[62].xx * v1.yz;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = 1 + r1.x;
  r1.x = rcp(r1.x);
  r1.x = r1.x * r1.x;
    
    float3 untonemapped = r0.yzw; //untonemapped image?  
  r0.yzw = r0.yzw * r1.xxx + float3(0.00266771927,0.00266771927,0.00266771927);
  
    
    r0.yzw = log2(r0.yzw);

  //r0.yzw = saturate(r0.yzw * float3(0.0714285746,0.0714285746,0.0714285746) + float3(0.610726953,0.610726953,0.610726953));
  r0.yzw = r0.yzw * float3(0.0714285746, 0.0714285746, 0.0714285746) + float3(0.610726953, 0.610726953, 0.610726953); //no saturate -- IMPORTANT LUT
  
    
    //LUT stuff Start
    
    
  //lets get lerping
    //float3 prelut = r0.yzw; //added for lerp -- param 1
    r0.yzw = r0.yzw * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625); //lut? [vanilla code]
    //write our lerp here
    //r0.yzw = lerp(prelut, t3.Sample(s3_s, r0.yzw).xyz, injectedData.colorGradeLUTStrength); //the magical lerp
    //r0.yzw = pow(r0.yzw, 2.2); //random test
    r0.yzw = t3.Sample(s3_s, r0.yzw).xyz; //lut? [vanilla code] ^ implemented in the magical lerp
    
    
    //LUT stuff End
    
  r1.xyz = float3(1.04999995,1.04999995,1.04999995) * r0.yzw;
    
  //o0.w = saturate(dot(r1.xyz, float3(0.298999995,0.587000012,0.114))); //rec601
    //o0.w = dot(r1.xyz, float3(0.2126f, 0.7152f, 0.0722f)); //rec709 no saturate
    o0.w = saturate(dot(r1.xyz, float3(0.2126f, 0.7152f, 0.0722f))); //rec709 + saturate
  r0.x = r0.x * 0.00390625 + -0.001953125;
  r0.xyz = r0.yzw * float3(1.04999995,1.04999995,1.04999995) + r0.xxx;

  if (cb0[65].x != 0) {
    r1.xyz = log2(r0.xyz);
    r1.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r1.xyz;
    r2.xyz = max(float3(0,0,0), r2.xyz);
    r1.xyz = -r1.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
    r1.xyz = r2.xyz / r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(6.27739477,6.27739477,6.27739477) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = float3(10000,10000,10000) * r1.xyz;
    r1.xyz = r1.xyz / cb0[64].www;
    r1.xyz = max(float3(6.10351999e-05,6.10351999e-05,6.10351999e-05), r1.xyz);
    r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
    r1.xyz = max(float3(0.00313066994,0.00313066994,0.00313066994), r1.xyz);
        
   //r1.xyz = log2(r1.xyz); //2.4 gamma
   //r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;//2.4 gamma
   // r1.xyz = exp2(r1.xyz); //2.4 gamma
  r1.xyz = sign(r1.xyz) * pow(r1.xyz, 1 / 2.4); //2.4 gamma re-written
        
    r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    o0.xyz = min(r2.xyz, r1.xyz);
  

        
        } else {
    o0.xyz = r0.xyz;
  }
    
    //vanilla code end
    //custom code start
    
    //copy pasta from Shortfuse's Tunic start
    //float4 t1Color = t1.Sample(s1_s, r1.xy).xyzw; // last frame
    //r1.xyzw = t1Color;
    //t1Color *= 80.f / injectedData.toneMapGameNits; // reduce paperwhite sclaing
    //r1.xyzw = sign(t1Color) * pow(abs(t1Color), 1.f / 2.2f); // Convert raw framebuffer to gamma

    //r1.xyz = r1.xyz - r0.xyz; // delta
    //copy pasta from Shortfuse's tonic end
    
    //o0.rgb = sign(o0.rgb) * pow(abs(o0.rgb), 2.2f); // linear
    //o0.rgb *= injectedData.toneMapGameNits / 80.f;
    
    // Clamp needed before effects happen after tone mapping...
   // o0.rgb = min(o0.rgb, injectedData.toneMapPeakNits / 80.f);
    
    //custom code end
    

        
        
    
            float3 outputColor = o0.rgb;
            outputColor = max(0, outputColor);
            if (injectedData.toneMapType == 0.f)
            {
               // outputColor = pow(outputColor, 2.2f);
            }
            else
            {
                outputColor = untonemapped;
            }
    float vanillaMidGray = 0.18f;
    float renoDRTContrast = 1.1f;
    float renoDRTFlare = 0.f;
    float renoDRTShadows = 1.f;
    float renoDRTDechroma = 0.5f;
    float renoDRTSaturation = 1.15f;
    float renoDRTHighlights = 1.f;

            renodx::tonemap::Config config = renodx::tonemap::config::Create(
      injectedData.toneMapType,
      injectedData.toneMapPeakNits,
      injectedData.toneMapGameNits,
      0,
      injectedData.colorGradeExposure,
      injectedData.colorGradeHighlights,
      injectedData.colorGradeShadows,
      injectedData.colorGradeContrast,
      injectedData.colorGradeSaturation,
      vanillaMidGray,
      vanillaMidGray * 100.f,
      renoDRTHighlights,
      renoDRTShadows,
      renoDRTContrast,
      renoDRTSaturation,
      renoDRTDechroma,
      renoDRTFlare);

            outputColor = renodx::tonemap::config::Apply(outputColor, config);

            //outputColor *= injectedData.toneMapGameNits; // Scale by user nits

   //o0.rgb = mul(renodx::color::BT709_TO_BT2020_MAT, o0.rgb);  // use bt2020
   //o0.rgb /= 10000.f;                         // Scale for PQ
   //o0.rgb = max(0, o0.rgb);                   // clamp out of gamut
   //o0.rgb = renodx::color::pq::from::BT2020(o0.rgb);             // convert to PQ
  // o0.rgb = min(1.f, o0.rgb);                 // clamp PQ (10K nits)
   // outputColor.rgb = max(0, outputColor.rgb); //clamp 709
            //outputColor.rgb /= 80.f;
            o0.rgb = outputColor.rgb;

            return;
        }
    
    
    
  //return