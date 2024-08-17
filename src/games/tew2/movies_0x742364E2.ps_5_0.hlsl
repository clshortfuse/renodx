// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 16 22:01:41 2024
// Movies -- ingame FMV

#include "./shared.h"

cbuffer fblock : register(b0)
{
  float4 positiontoviewtexture : packoffset(c0);
  float4 computeparm0 : packoffset(c1);
  float4 binkmaskrate : packoffset(c2);
  float4 binkluminancerate : packoffset(c3);
  float4 fsbinkblendrate : packoffset(c4);
}

SamplerState binky_samp_state_s : register(s0);
SamplerState binkcr_samp_state_s : register(s1);
SamplerState binkcb_samp_state_s : register(s2);
Texture2D<float4> binky_samp : register(t0);
Texture2D<float4> binkcr_samp : register(t1);
Texture2D<float4> binkcb_samp : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(1,1) / computeparm0.xy;
  r0.zw = float2(-0.5,-0.5) + v0.xy;
  r1.xy = r0.zw * positiontoviewtexture.zw + positiontoviewtexture.xy;
  r0.z = r1.y * 0.985000014 + -0.5;
  r2.x = r0.z * r0.y + 0.5;
  r0.y = cmp(r2.x < 0);
  r0.z = cmp(1 < r2.x);
  r0.y = (int)r0.z | (int)r0.y;
  r0.z = -0.5 + r1.x;
  r3.y = r0.z * r0.x + 0.5;
  r0.x = cmp(r3.y < 0);
  r0.z = cmp(1 < r3.y);
  r3.z = (int)r0.z | (int)r0.x;
  r1.z = 0;
  r0.xz = cmp(computeparm0.xy != float2(1,1));
  r3.yz = r0.xx ? r3.yz : r1.xz;
  r3.x = 0.985000014 * r1.y;
  r2.y = (int)r0.y | (int)r3.z;
  r3.xw = r0.zz ? r2.yx : r3.zx;
  r0.x = ~(int)r3.x;
  r0.y = -0.00999999978 + fsbinkblendrate.x;
  r0.y = cmp(r0.y < 0);
  r0.x = r0.x ? r0.y : 0;
  if (r0.x != 0) discard;
  r0.x = binkcb_samp.Sample(binkcb_samp_state_s, r3.yw, int2(0, 0)).x;
  r0.xyz = float3(0,-0.391448975,2.01782227) * r0.xxx;
  r0.w = binkcr_samp.Sample(binkcr_samp_state_s, r3.yw, int2(0, 0)).x;
  r1.x = binky_samp.Sample(binky_samp_state_s, r3.yw, int2(0, 0)).x;
  r0.xyz = r0.www * float3(1.59579468,-0.813476563,0) + r0.xyz;
  r0.xyz = r1.xxx * float3(1.16412354,1.16412354,1.16412354) + r0.xyz;
  r0.xyz = float3(-0.87065506,0.529705048,-1.08166885) + r0.xyz;
  r0.xyz = binkmaskrate.xyz * r0.xyz;
  r0.xyz = binkluminancerate.xyz * r0.xyz;
  r0.xyz = fsbinkblendrate.xxx * r0.xyz;
  r0.w = fsbinkblendrate.x;
  o0.xyzw = r3.xxxx ? float4(0,0,0,1) : r0.xyzw;
  
  o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); //2.2 gamma correction
    
  o0.rgb *= injectedData.toneMapGameNits / 80.f; //Using paper white saling, the movies are too bright for bt2446a
  
  return;
}