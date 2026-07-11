// ---- Created with 3Dmigoto v1.3.16 on Mon Sep  2 18:01:59 2024
// Color correction
// Currently not part of the mod, just added to the game's project folder
// The shader right before the tonemapper
// Might be used for future effect sliders (film grain strength for example)
// Seems to include a lot of ACES AP1 color correction
// Similar to the Unreal Engine ACES Lut Builder
// The game's tonemapper is uncharted2, so this is probably just for color correction

#include "./shared.h"

cbuffer fblock : register(b0) {
  float4 renderpositiontoviewtexture : packoffset(c0);
  float4 toneoverbrightcolor : packoffset(c1);
  float4 screenscale : packoffset(c2);
  float4 cgsaturation : packoffset(c3);
  float4 cgcontrast : packoffset(c4);
  float4 cggamma : packoffset(c5);
  float4 cggain : packoffset(c6);
  float4 cgoffset : packoffset(c7);
  float4 cgmidtonecolor : packoffset(c8);
  float4 cgparm : packoffset(c9);
  float4 cgshadowcolor : packoffset(c10);
  float4 cghighlightcolor : packoffset(c11);
  float4 vignetteparm2 : packoffset(c12);
  float4 vignetteparm : packoffset(c13);
  float4 vignettecolor : packoffset(c14);
  float4 vignetteinvparm2 : packoffset(c15);
  float4 vignetteinvparm : packoffset(c16);
  float4 vignetteinvcolor : packoffset(c17);
}

SamplerState postdistortionmap_samp_state_s : register(s0);
SamplerState viewcolormap_samp_state_s : register(s1);
Texture2D<float4> postdistortionmap_samp : register(t0);
Texture2D<float4> viewcolormap_samp : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0 : SV_Position0,
    out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * renderpositiontoviewtexture.zw + renderpositiontoviewtexture.xy;
  r1.xyz = postdistortionmap_samp.Sample(postdistortionmap_samp_state_s, r0.xy, int2(0, 0)).xyz;
  r1.xyz = float3(-0.498039216, -0.498039216, -0.498039216) + r1.xyz;
  r0.zw = r1.xy * r1.zz;
  r1.xy = r1.xy * r1.zz + r0.xy;
  r2.xyz = viewcolormap_samp.SampleLevel(viewcolormap_samp_state_s, r1.xy, 0).xyz;
  r3.xyz = postdistortionmap_samp.Sample(postdistortionmap_samp_state_s, r1.xy, int2(0, 0)).xyz;
  r3.xyz = float3(-0.498039216, -0.498039216, -0.498039216) + r3.xyz;
  r0.z = dot(r0.zw, r0.zw);
  r1.zw = r3.xy * r3.zz;
  r0.w = dot(r1.zw, r1.zw);
  r0.zw = sqrt(r0.zw);
  r1.z = cmp(r0.w < r0.z);
  if (r1.z != 0) {
    r3.xyz = viewcolormap_samp.SampleLevel(viewcolormap_samp_state_s, r0.xy, 0).xyz;
    r0.x = r0.w / r0.z;
    r0.yzw = -r3.xyz + r2.xyz;
    r2.xyz = r0.xxx * r0.yzw + r3.xyz;
  }
  r0.xyz = toneoverbrightcolor.xyz * r2.xyz;
  r2.xyz = screenscale.xyz * r0.xyz;
  r0.w = dot(r2.xyz, float3(0.272228718, 0.674081743, 0.0536895171));  // AP1
  r0.xyz = r0.xyz * screenscale.xyz + -r0.www;
  r0.xyz = cgsaturation.xyz * r0.xyz + r0.www;
  // r0.xyz = max(float3(0, 0, 0), r0.xyz); //rec709 clamp
  r0.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cgcontrast.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.xyz;  // ACES Film Toe
  r2.xyz = float3(1, 1, 1) / cggamma.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * cggain.xyz + cgoffset.xyz;
  r2.xyz = cgmidtonecolor.xyz * r0.xyz;
  r1.z = cmp(r0.w < cgparm.x);
  if (r1.z != 0) {
    r1.z = saturate(cgparm.x + -r0.w);
    r1.w = 9.99999975e-05 + cgparm.x;
    r1.z = saturate(r1.z / r1.w);
    r3.xyz = r0.xyz * cgshadowcolor.xyz + -r2.xyz;
    r3.xyz = r1.zzz * r3.xyz + r2.xyz;
  } else {
    r1.z = cmp(cgparm.z < r0.w);
    r1.w = saturate(-cgparm.z + r0.w);
    r2.w = 1.00010002 + -cgparm.z;
    r1.w = saturate(r1.w / r2.w);
    r4.xyz = r0.xyz * cghighlightcolor.xyz + -r2.xyz;
    r4.xyz = r1.www * r4.xyz + r2.xyz;
    r5.xy = cmp(float2(0, 0) < cgparm.xz);
    if (r5.x != 0) {
      r5.xzw = cgshadowcolor.xyz * r2.xyz;
      r1.w = saturate(-cgparm.x + r0.w);
      r2.w = 1.00010002 + -cgparm.x;
      r1.w = saturate(r1.w / r2.w);
      r6.xyz = r0.xyz * cgmidtonecolor.xyz + -r5.xzw;
      r2.xyz = r1.www * r6.xyz + r5.xzw;
    }
    if (r5.y != 0) {
      r5.xyz = cghighlightcolor.xyz * r2.xyz;
      r1.w = saturate(cgparm.z + -r0.w);
      r2.w = 9.99999975e-05 + cgparm.z;
      r1.w = saturate(r1.w / r2.w);
      r6.xyz = r0.xyz * cgmidtonecolor.xyz + -r5.xyz;
      r2.xyz = r1.www * r6.xyz + r5.xyz;
    }
    r3.xyz = r1.zzz ? r4.xyz : r2.xyz;
  }
  r1.z = cmp(0 < cgparm.w);
  if (r1.z != 0) {
    r0.x = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r0.y = cmp(cgparm.w == 1.000000);
    r0.x = r0.y ? r0.x : r0.w;
    r0.y = dot(r3.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r0.x = r0.x / r0.y;
    r3.xyz = r3.xyz * r0.xxx;
  }
  r0.xy = r1.xy * float2(2, 2) + float2(-1, -1);
  r0.z = cmp(0 < vignetteparm2.x);
  if (r0.z != 0) {
    r0.zw = r0.xy * vignetteparm.xy + vignetteparm.zw;
    r0.z = dot(r0.zw, r0.zw);
    r0.z = min(1, r0.z);
    r0.z = 5.55555534 * r0.z;
    r0.w = 9.99999975e-06 + vignetteparm2.y;
    r0.z = log2(r0.z);
    r0.z = r0.w * r0.z;
    r0.z = exp2(r0.z);
    r0.z = vignetteparm2.x * r0.z;
    r0.z = 0.180000007 * r0.z;
    r1.xyz = float3(-1, -1, -1) + vignettecolor.xyz;
    r1.xyz = r0.zzz * r1.xyz + float3(1, 1, 1);
    r3.xyz = r3.xyz * r1.xyz;
  }
  r0.z = cmp(0 < vignetteinvparm2.x);
  if (r0.z != 0) {
    r0.xy = r0.xy * vignetteinvparm.xy + vignetteinvparm.zw;
    r0.x = dot(r0.xy, r0.xy);
    r0.x = min(1, r0.x);
    r0.x = 1 + -r0.x;
    r0.y = 9.99999975e-06 + vignetteinvparm2.y;
    r0.x = log2(r0.x);
    r0.x = r0.y * r0.x;
    r0.x = exp2(r0.x);
    r0.x = vignetteinvparm2.x * r0.x;
    r0.yzw = float3(-1, -1, -1) + vignetteinvcolor.xyz;
    r0.xyz = r0.xxx * r0.yzw + float3(1, 1, 1);
    r3.xyz = r3.xyz * r0.xyz;
  }
  o0.xyz = r3.xyz;
  o0.w = 1;
  return;
}