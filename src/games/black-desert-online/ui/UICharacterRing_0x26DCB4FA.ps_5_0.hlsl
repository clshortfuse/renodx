// ---- Created with 3Dmigoto v1.4.1 on Sat Jan  3 02:07:05 2026

#include "../shared.h"

cbuffer AALineConst : register(b0)
{
  float4 invScreenSize : packoffset(c0);
  float3 vecViewPosition : packoffset(c1);
  float fAspect : packoffset(c1.w);
  float2 screenSize : packoffset(c2);
  float2 AALineDynamicResolution : packoffset(c2.z);
}

cbuffer AALineSceneConst : register(b2)
{
  row_major float4x4 matWVP[2] : packoffset(c0);
  float4 lineConst : packoffset(c8);
}

SamplerState PA_LINEAR_CLAMP_FILTER_s : register(s0);
SamplerState lineTextureSampler_s : register(s1);
Texture2D<float4> lineTexture : register(t0);
Texture2D<float4> texDepth : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v1.xy, v1.xy);             
  r0.x = sqrt(r0.x);                    
  r0.x = cmp(v1.z >= r0.x);            
  r0.yz = v1.xy / v1.zz;                
  r1.xyzw = lineTexture.Sample(lineTextureSampler_s, r0.yz).xyzw;
  r1.xyzw = v4.xyzw * r1.xyzw;
  r2.xyzw = lineTexture.Sample(lineTextureSampler_s, v1.xy).xyzw;
  r2.xyzw = v3.xyzw * r2.xyzw;
  r3.xyz = r1.xyz * r1.www + r2.xyz;    
  r3.w = max(r2.w, r1.w);               
  r0.xyzw = r0.xxxx ? r3.xyzw : r2.xyzw;
  r0.xyzw = log2(r0.xyzw);
  r0.xyzw = float4(2.20000005,2.20000005,2.20000005,2.20000005) * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  r0.xyzw = r0.xyzw + r0.xyzw;      

  // ---- Clamp to 300 nits ----
  // Otherwise the ring is untonemapped and blasts you

  const float max_lum = 300.0 / 203.0;
  float lum = dot(r0.xyz, float3(0.2126, 0.7152, 0.0722));
  float lum_scale = min(1.0, max_lum / max(lum, 1e-4));
  r0.xyz *= lum_scale;

  r1.x = dot(v2.xyz, v2.xyz);           
  r1.x = sqrt(r1.x);
  r1.yz = invScreenSize.xy * v0.xy;     
  r1.yz = AALineDynamicResolution.xy * r1.yz; 
  r1.y = texDepth.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r1.yz, 0).x; 
  r1.x = r1.y * 10 + -r1.x;             
  r1.y = cmp(0 < r1.y);                 
  r1.x = saturate(r1.x / lineConst.x);  
  r1.x = r1.x * r0.w;                   
  r1.z = cmp(0.5 < lineConst.y);
  r1.y = r1.z ? 0 : r1.y;              
  o0.w = r1.y ? r1.x : r0.w;            
  o0.xyz = r0.xyz;                      
  return;
}