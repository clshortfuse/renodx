// ---- Created with 3Dmigoto v1.4.1 on Mon Dec  1 16:17:50 2025

cbuffer cb0 : register(b0)
{
  row_major float4x4 g_mViewProj : packoffset(c0);
  row_major float4x4 g_mViewProjInv : packoffset(c4);
  row_major float4x4 g_mLightProj[4] : packoffset(c8);
  row_major float4x4 g_mLightProjInv[4] : packoffset(c24);
  float3 g_vEyePosition : packoffset(c40);
  float3 g_vLightPosition : packoffset(c41);
  float3 g_vSigmaAbsorption : packoffset(c42);
  float3 g_vSigmaScatter : packoffset(c43);
  float g_fDistanceScale : packoffset(c40.w);
  float g_fBufferWidthInv : packoffset(c41.w);
  float g_fBufferHeightInv : packoffset(c42.w);
  float g_fResMultiplier : packoffset(c43.w);
  float4 g_vCascadeOffsetAndScale[4] : packoffset(c44);
  float4 g_vLightDir : packoffset(c48);
  float4 g_vAirlightParams : packoffset(c49);
  float4 g_vCascadeTessFactor : packoffset(c50);
  float4 g_vShadowMapDim : packoffset(c51);
}

SamplerState g_sPoint_s : register(s0);
Texture2D<float> tDepthMap : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = g_fBufferWidthInv;
  r0.y = g_fBufferHeightInv;
  r0.zw = g_fResMultiplier * r0.xy;
  r1.xy = v1.xy / r0.zw;
  r1.xy = trunc(r1.xy);
  r1.z = g_fResMultiplier;
  r1.w = 0;
  r2.x = 0;
  while (true) {
    r2.y = cmp((int)r2.x >= (int)r1.z);
    if (r2.y != 0) break;
    r3.x = (int)r2.x;
    r2.y = r1.w;
    r2.z = 0;
    while (true) {
      r2.w = cmp((int)r2.z >= (int)r1.z);
      if (r2.w != 0) break;
      r3.y = (int)r2.z;
      r3.yz = r3.xy * r0.xy;
      r3.yz = r1.xy * r0.zw + r3.yz;
      r2.w = tDepthMap.SampleLevel(g_sPoint_s, r3.yz, 0).x;
      r2.y = r2.y + r2.w;
      r2.z = (int)r2.z + 1;
    }
    r1.w = r2.y;
    r2.x = (int)r2.x + 1;
  }
  r0.x = g_fResMultiplier * g_fResMultiplier;
  o0.xyzw = r1.wwww / r0.xxxx;

  o0.w = saturate(o0.w);
  return;
}