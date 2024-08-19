// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 16 22:01:41 2024
// "Noise" shader
// Only appears when TAA or TAA+FXAA is enabled as the AA method
// Causes a gamma missmatch when enabled

#include "./shared.h"

cbuffer fblock : register(b0)
{
  float4 positiontoviewtexture : packoffset(c0);
  float4 downsampletype : packoffset(c1);
  float4 noiseparm : packoffset(c2);
  float4 viewrandom : packoffset(c3);
  float4 noisecolor : packoffset(c4);
  float4 noiseparm2 : packoffset(c5);
}

SamplerState viewcolormap_samp_state_s : register(s0);
SamplerState noisemappbr_samp_state_s : register(s1);
Texture2D<float4> viewcolormap_samp : register(t0);
Texture2D<float4> noisemappbr_samp : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * positiontoviewtexture.zw + positiontoviewtexture.xy;
  r1.xyz = viewcolormap_samp.SampleLevel(viewcolormap_samp_state_s, r0.xy, 0).xyz;
  r2.xyzw = positiontoviewtexture.zwzw * float4(0,-1,-1,0) + r0.xyxy;
  r3.xyz = viewcolormap_samp.SampleLevel(viewcolormap_samp_state_s, r2.xy, 0).xyz;
  r2.xyz = viewcolormap_samp.SampleLevel(viewcolormap_samp_state_s, r2.zw, 0).xyz;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r3.xyz * r3.xyz + r2.xyz;
  r2.xyz = r1.xyz * r1.xyz + r2.xyz;
  r3.xyzw = positiontoviewtexture.zwzw * float4(1,0,0,1) + r0.xyxy;
  r4.xyz = viewcolormap_samp.SampleLevel(viewcolormap_samp_state_s, r3.xy, 0).xyz;
  r2.xyz = r4.xyz * r4.xyz + r2.xyz;
  r3.xyz = viewcolormap_samp.SampleLevel(viewcolormap_samp_state_s, r3.zw, 0).xyz;
  r2.xyz = r3.xyz * r3.xyz + r2.xyz;
  r2.xyz = float3(0.200000003,0.200000003,0.200000003) * r2.xyz;
  r0.z = 1 + downsampletype.w;
  r1.xyz = r1.xyz * r1.xyz + -r2.xyz;
  r1.xyz = r0.zzz * r1.xyz + r2.xyz;
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r0.z = cmp(downsampletype.z == 1.000000);
  if (r0.z != 0) {
    r0.z = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
    r0.xy = r0.xy * noiseparm.xy + viewrandom.xy;
    r0.xyw = noisemappbr_samp.SampleLevel(noisemappbr_samp_state_s, r0.xy, 0).xyz;
    r0.xyw = noisecolor.xyz * r0.xyw;
    r0.z = 1 + -r0.z;
    r0.z = max(0, r0.z);
    r0.z = log2(r0.z);
    r0.z = noiseparm2.y * r0.z;
    r0.z = exp2(r0.z);
    r0.z = noiseparm.z * r0.z + -noiseparm.z;
    r0.z = noiseparm2.x * r0.z + noiseparm.z;
    r1.w = downsampletype.y * r0.z;
    r2.x = cmp(noiseparm2.z == 1.000000);
    if (r2.x != 0) {
      r2.xyz = r1.www * r0.xyw;
      r1.xyz = r2.xyz * noisecolor.xyz + r1.xyz;
    } else {
      r0.z = -r0.z * downsampletype.y + 1;
      r0.xyw = r0.xyw * r1.xyz;
      r0.xyw = r0.xyw * r1.www;
      r1.xyz = r1.xyz * r0.zzz + r0.xyw;
    }
  }
  r0.xyz = max(float3(0,0,0), r1.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = 1;
  
    o0.rgb = renodx::math::SafePow(o0.rgb, 2.2); // 2.2 gamma
    
    o0.rgb *= injectedData.toneMapGameNits; // Scale by user nits
        
    o0.rgb /= 80.f;
    
  return;
}