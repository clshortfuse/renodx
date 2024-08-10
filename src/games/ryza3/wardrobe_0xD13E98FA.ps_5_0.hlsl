// ---- Created with 3Dmigoto v1.3.16 on Wed Jul 31 20:56:53 2024
// The wardrobe's shader when you swap costumes
// Only loads when you're in the wardrobe
// Functions like the main tonemapper, but uses FXAA regardless of AA settings lol


#include "./shared.h"
#include "./tonemapper.hlsl" //Include our custom tonemapper

cbuffer _Globals : register(b0)
{
  float fFXAAEdgeThreshold : packoffset(c0) = {0.5};
  float fFXAAEdgeThresholdMin : packoffset(c0.y) = {0.5};
  float fFXAAEdgeSharpness : packoffset(c0.z) = {8};
  float fFXAAPixelRange : packoffset(c0.w) = {2};
  float4 vRecipScreenSize : packoffset(c1) = {0.000781250012,0.00138888892,0.000390625006,0.000694444461};
  float2 SimulateHDRParams : packoffset(c2);
  float fSaturationScaleEx : packoffset(c2.z) = {1};
  float fGamma : packoffset(c2.w) = {1};
}

SamplerState smplScene_s : register(s0);
Texture2D<float4> smplScene_Tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(1,1) / vRecipScreenSize.xy;
  r0.zw = fFXAAPixelRange / r0.xy;
  r0.xy = float2(2,2) / r0.xy;
  r1.xy = cmp(v2.xy < float2(0,0));
  r1.z = (int)r1.y | (int)r1.x;
  r2.xy = cmp(float2(1,1) < v2.xy);
  r1.z = (int)r1.z | (int)r2.x;
  r1.z = (int)r2.y | (int)r1.z;
  r1.zw = r1.zz ? v1.xy : v2.xy;
  r3.xyz = smplScene_Tex.Sample(smplScene_s, r1.zw).xyz;    
  r1.z = dot(r3.xyz, float3(0.222014993,0.706655025,0.0713300034));
  r2.zw = cmp(v3.wz < float2(0,0));
  r1.xy = (int2)r1.xy | (int2)r2.zw;
  r1.x = (int)r2.x | (int)r1.x;
  r3.xy = cmp(float2(1,1) < v3.wz);
  r1.xy = (int2)r1.xy | (int2)r3.xy;
  r4.xw = v2.xy;
  r4.yz = v3.wz;
  r1.xw = r1.xx ? v1.xy : r4.xy;
  r5.xyz = smplScene_Tex.Sample(smplScene_s, r1.xw).xyz;
  r1.x = dot(r5.xyz, float3(0.222014993,0.706655025,0.0713300034));
  r1.y = (int)r2.y | (int)r1.y;
  r1.yw = r1.yy ? v1.xy : r4.zw;
  r4.xyz = smplScene_Tex.Sample(smplScene_s, r1.yw).xyz;
  r1.y = dot(r4.xyz, float3(0.222014993,0.706655025,0.0713300034));
  r1.w = (int)r2.z | (int)r2.w;
  r1.w = (int)r3.y | (int)r1.w;
  r1.w = (int)r3.x | (int)r1.w;
  r2.xy = r1.ww ? v1.xy : v3.zw;
  r2.xyz = smplScene_Tex.Sample(smplScene_s, r2.xy).xyz;
  r1.w = dot(r2.xyz, float3(0.222014993,0.706655025,0.0713300034));
  r2.xyzw = smplScene_Tex.Sample(smplScene_s, v1.xy).xyzw;
  r3.x = dot(r2.xyz, float3(0.222014993,0.706655025,0.0713300034));
  r3.z = min(r1.z, r1.x);
  r1.y = 0.00260416674 + r1.y;
  r3.yw = max(r1.zy, r1.xw);
  r4.x = min(r1.y, r1.w);
  r3.y = max(r3.w, r3.y);
  r3.z = min(r4.x, r3.z);
  r3.w = fFXAAEdgeThreshold * r3.y;
  r4.x = min(r3.z, r3.x);
  r3.w = max(fFXAAEdgeThresholdMin, r3.w);
  r3.x = max(r3.y, r3.x);
  r1.xz = r1.xw + -r1.yz;
  r1.y = r3.x + -r4.x;
  r1.y = cmp(r1.y >= r3.w);
  r4.x = r1.x + r1.z;
  r4.y = r1.x + -r1.z;
  r1.x = dot(r4.xy, r4.xy);
  r1.x = rsqrt(r1.x);
  r1.xz = r4.xy * r1.xx;
  r3.xw = -r1.xz * r0.zw + v1.xy;
  r4.xy = cmp(r3.xw < float2(0,0));
  r1.w = (int)r4.y | (int)r4.x;
  r4.xy = cmp(float2(1,1) < r3.xw);
  r1.w = (int)r1.w | (int)r4.x;
  r1.w = (int)r4.y | (int)r1.w;
  r3.xw = r1.ww ? v1.xy : r3.xw;
  r4.xyzw = smplScene_Tex.Sample(smplScene_s, r3.xw).xyzw;
  r0.zw = r1.xz * r0.zw + v1.xy;
  r3.xw = cmp(r0.zw < float2(0,0));
  r1.w = (int)r3.w | (int)r3.x;
  r3.xw = cmp(float2(1,1) < r0.zw);
  r1.w = (int)r1.w | (int)r3.x;
  r1.w = (int)r3.w | (int)r1.w;
  r0.zw = r1.ww ? v1.xy : r0.zw;
  r5.xyzw = smplScene_Tex.Sample(smplScene_s, r0.zw).xyzw;
  r0.z = min(abs(r1.x), abs(r1.z));
  r0.z = fFXAAEdgeSharpness * r0.z;
  r0.zw = r1.xz / r0.zz;
  r0.zw = max(float2(-2,-2), r0.zw);
  r0.zw = min(float2(2,2), r0.zw);
  r1.xz = -r0.zw * r0.xy + v1.xy;
  r3.xw = cmp(r1.xz < float2(0,0));
  r1.w = (int)r3.w | (int)r3.x;
  r3.xw = cmp(float2(1,1) < r1.xz);
  r1.w = (int)r1.w | (int)r3.x;
  r1.w = (int)r3.w | (int)r1.w;
  r1.xz = r1.ww ? v1.xy : r1.xz;
  r6.xyzw = smplScene_Tex.Sample(smplScene_s, r1.xz).xyzw;
  r0.xy = r0.zw * r0.xy + v1.xy;
  r0.zw = cmp(r0.xy < float2(0,0));
  r0.z = (int)r0.w | (int)r0.z;
  r1.xz = cmp(float2(1,1) < r0.xy);
  r0.z = (int)r0.z | (int)r1.x;
  r0.z = (int)r1.z | (int)r0.z;
  r0.xy = r0.zz ? v1.xy : r0.xy;
  r0.xyzw = smplScene_Tex.Sample(smplScene_s, r0.xy).xyzw;
    
  if (r1.y != 0) {
    r1.xyzw = r5.xyzw + r4.xyzw;
    r0.xyzw = r6.xyzw + r0.xyzw;
    r4.xyzw = float4(0.25,0.25,0.25,0.25) * r1.xyzw;
    r2.xyzw = r0.xyzw * float4(0.25,0.25,0.25,0.25) + r4.xyzw;
    r0.x = dot(r2.xyz, float3(0.222014993,0.706655025,0.0713300034));
    r0.y = cmp(r0.x < r3.z);
    r0.x = cmp(r3.y < r0.x);
    r0.x = (int)r0.x | (int)r0.y;
    r0.yzw = float3(0.5,0.5,0.5) * r1.xyz;
    r2.xyz = r0.xxx ? r0.yzw : r2.xyz;
  } //fxaa end
  
    float3 untonemapped = r2.rgb;
    
  //vanilla tonemapper / hable start
  r0.xyz = r2.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  r0.xyz = r2.xyz * r0.xyz + float3(0.00200000009,0.00200000009,0.00200000009);
  r1.xyz = r2.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.300000012,0.300000012,0.300000012);
  r1.xyz = r2.xyz * r1.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
  r0.xyz = r0.xyz / r1.xyz;
  r0.xyz = float3(-0.0333000012,-0.0333000012,-0.0333000012) + r0.xyz;
  r0.xyz = SimulateHDRParams.xxx * r0.xyz;
 // r0.xyz = log2(r0.xyz);
 // r0.xyz = fGamma * r0.xyz;
 // r0.xyz = exp2(r0.xyz);
  //hable end
    
    float3 vanillaColor = r0.rgb;
    
  
 //second hable run to get mid grey
    r2.rgb = float3(0.18f, 0.18f, 0.18f);
    
    r0.xyz = r2.xyz * float3(0.219999999, 0.219999999, 0.219999999) + float3(0.0299999993, 0.0299999993, 0.0299999993);
    r0.xyz = r2.xyz * r0.xyz + float3(0.00200000009, 0.00200000009, 0.00200000009);
    r1.xyz = r2.xyz * float3(0.219999999, 0.219999999, 0.219999999) + float3(0.300000012, 0.300000012, 0.300000012);
    r1.xyz = r2.xyz * r1.xyz + float3(0.0599999987, 0.0599999987, 0.0599999987);
    r0.xyz = r0.xyz / r1.xyz;
    r0.xyz = float3(-0.0333000012, -0.0333000012, -0.0333000012) + r0.xyz;
    r0.xyz = SimulateHDRParams.xxx * r0.xyz;
    float3 vanMidGray = r0.rgb;
    //second hable run end

 

 // Custom tonemapper here
    r0.rgb = applyUserTonemap(untonemapped, vanillaColor, renodx::color::y::from::BT709(vanMidGray));

 //new stuff expects fGamma    
    r0.rgb = renodx::math::SafePow(r0.rgb, fGamma); //fGamma = 1, I think this linearizes the gamma
    
    //new stuff
  r0.w = cmp(fSaturationScaleEx == 1.000000);
  r1.x = cmp(1 < fSaturationScaleEx);
  r1.y = min(r0.y, r0.z);
  r1.y = min(r1.y, r0.x);
  r1.z = max(r0.y, r0.z);
  r1.z = max(r1.z, r0.x);
  r1.y = r1.z + r1.y;
  r1.y = -r1.y * 0.5 + 1;
  r1.z = -1 + fSaturationScaleEx;
  r1.y = r1.y * r1.z + 1;
  r1.x = r1.x ? r1.y : fSaturationScaleEx;
  r1.y = dot(r0.xyz, float3(0.298909992,0.586610019,0.114480004)); //rec601
  r3.xyz = -r1.yyy + r0.xyz;
  r1.xyz = r1.xxx * r3.xyz + r1.yyy;
  r2.xyz = r0.www ? r0.xyz : r1.xyz;
  o0.xyzw = r2.xyzw;
    //vanilla shader end

    
    
    //add final gamma correction/paper white scaling -- Moved to Final
    //o0.rgb = renodx::math::SafePow(o0.rgb); //2.2 power gamma; we need both fGamma + 2.2 for proper power gamma output
    
    //o0.rgb *= injectedData.toneMapGameNits; // Scale by user nits
        
    //o0.rgb /= 80.f;
    
  return;
}