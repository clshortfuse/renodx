// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 16 22:01:40 2024
// UI, save  menu, mouse

#include "./shared.h"

cbuffer fblock : register(b0)
{
  float4 virtualmapping : packoffset(c0);
  float4 hdrglobalparams : packoffset(c1);
}

SamplerState pagetablemap_samp_state_s : register(s0);
SamplerState physicalvmtrmappingsmap0_samp_state_s : register(s1);
SamplerState physicalvmtrpagesmap1_samp_state_s : register(s2);
SamplerState physicalvmtrpagesmap2_samp_state_s : register(s3);
Texture2D<float4> pagetablemap_samp : register(t0);
Texture2D<float4> physicalvmtrmappingsmap0_samp : register(t1);
Texture2D<float4> physicalvmtrpagesmap1_samp : register(t2);
Texture2D<float4> physicalvmtrpagesmap2_samp : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : TEXCOORD1,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = saturate(v1.xy);
  r0.xy = r0.xy * virtualmapping.xy + virtualmapping.zw;
  r0.zw = pagetablemap_samp.Sample(pagetablemap_samp_state_s, r0.xy, int2(0, 0)).xy;
  r1.xyz = physicalvmtrmappingsmap0_samp.Sample(physicalvmtrmappingsmap0_samp_state_s, r0.zw, int2(0, 0)).xzw;
  r0.xy = r0.xy * r1.xx + r1.yz;
  r1.xyz = physicalvmtrpagesmap1_samp.Sample(physicalvmtrpagesmap1_samp_state_s, r0.xy, int2(0, 0)).yzw;
  r0.w = physicalvmtrpagesmap2_samp.Sample(physicalvmtrpagesmap2_samp_state_s, r0.xy, int2(0, 0)).w;
  r1.xyz = max(float3(0,0,0), r1.xzy);
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.909090936,0.909090936,0.909090936) * r1.xyz;
  r0.xyz = exp2(r1.xyz);
  r0.xyzw = v0.xyzw * r0.xyzw;
  r0.xyz = saturate(r0.xyz * float3(1.03100002,1.03100002,1.03100002) + float3(-0.0309999995,-0.0309999995,-0.0309999995));
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
    
    o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); //2.2 gamma correction
    o0.rgb *= injectedData.toneMapUINits / 80.f; //Added ui slider
  return;
}