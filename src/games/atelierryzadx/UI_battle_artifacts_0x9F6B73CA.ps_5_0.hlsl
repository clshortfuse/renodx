#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Mon Jul  8 23:38:26 2024

cbuffer _Globals : register(b0)
{
  float fGamma : packoffset(c0) = {2.20000005};
  float fInvToneMapParam : packoffset(c0.y) = {0.401183009};
}

Texture2D<float4> sScene : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = floor(v0.xy);
  r0.xy = (int2)r0.xy;
  r0.zw = float2(0,0);
  r0.xyz = sScene.Load(r0.xyz).xyz;
  
  //skips effect early, new
  o0.xyz = r0.xyz;
  o0.w = 1;

  o0.rgb = renodx::math::SignPow(o0.rgb, fGamma);

  return;
  
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = fGamma * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * fInvToneMapParam + float3(0.0333000012,0.0333000012,0.0333000012);
  r1.xyz = r0.xyz * float3(0.0599999987,0.0599999987,0.0599999987) + float3(-0.00200000009,-0.00200000009,-0.00200000009);
  r2.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(-0.219999999,-0.219999999,-0.219999999);
  r0.xyz = r0.xyz * float3(0.300000012,0.300000012,0.300000012) + float3(-0.0299999993,-0.0299999993,-0.0299999993);
  r1.xyz = r2.xyz * r1.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  r1.xyz = float3(-4,-4,-4) * r1.xyz;
  r1.xyz = r0.xyz * r0.xyz + r1.xyz;
  r1.xyz = sqrt(r1.xyz);
  r0.xyz = -r1.xyz + -r0.xyz;
  o0.xyz = r0.xyz / r2.xyz;
  
  o0.w = 1;
  return; 
}