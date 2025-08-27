#include "./shared.h"

// DoF Normal settings - in game

// ---- Created with 3Dmigoto v1.4.1 on Thu Apr 24 07:27:44 2025

cbuffer cbConsts : register(b1)
{
  float4 Consts[15] : packoffset(c0);
}

SamplerState SceneTexture_s : register(s0);
SamplerState BlurredSceneTexture_s : register(s1);
SamplerState DepthTexture_s : register(s2);
SamplerState BloomTexture_s : register(s3);
SamplerState SecondaryBloomTexture_s : register(s4);
SamplerState HeatHazeTexture_s : register(s5);
SamplerState LensDirtTexture_s : register(s6);
SamplerState EdgeFadeTexture_s : register(s9);
SamplerState ColorCorrectionTexture_s : register(s10);
Texture2D<float4> SceneTexture : register(t0);
Texture2D<float4> BlurredSceneTexture : register(t1);
Texture2D<float4> DepthTexture : register(t2);
Texture2D<float4> BloomTexture : register(t3);
Texture2D<float4> SecondaryBloomTexture : register(t4);
Texture2D<float4> HeatHazeTexture : register(t5);
Texture2D<float4> LensDirtTexture : register(t6);
Texture2D<float4> EdgeFadeTexture : register(t9);
Texture3D<float4> ColorCorrectionTexture : register(t10);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float3 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = Consts[9].xyzw * v1.xyxy;
  r1.x = dot(v2.xyz, v2.xyz);
  r1.x = rsqrt(r1.x);
  r1.xyz = v2.yxz * r1.xxx;
  r1.w = DepthTexture.Sample(DepthTexture_s, r0.xy).x;
  r1.w = r1.w * Consts[2].z + Consts[2].w;
  r1.w = 1 / r1.w;
  r2.x = cmp(0 < Consts[14].w);
  if (r2.x != 0) {
    r2.x = min(abs(r1.y), abs(r1.z));
    r2.y = max(abs(r1.y), abs(r1.z));
    r2.y = 1 / r2.y;
    r2.x = r2.x * r2.y;
    r2.y = r2.x * r2.x;
    r2.z = r2.y * 0.0208350997 + -0.0851330012;
    r2.z = r2.y * r2.z + 0.180141002;
    r2.z = r2.y * r2.z + -0.330299497;
    r2.y = r2.y * r2.z + 0.999866009;
    r2.z = r2.x * r2.y;
    r2.w = cmp(abs(r1.z) < abs(r1.y));
    r2.z = r2.z * -2 + 1.57079637;
    r2.z = r2.w ? r2.z : 0;
    r2.x = r2.x * r2.y + r2.z;
    r2.y = cmp(r1.z < -r1.z);
    r2.y = r2.y ? -3.141593 : 0;
    r2.x = r2.x + r2.y;
    r2.y = min(r1.y, r1.z);
    r1.y = max(r1.y, r1.z);
    r1.z = cmp(r2.y < -r2.y);
    r1.y = cmp(r1.y >= -r1.y);
    r1.y = r1.y ? r1.z : 0;
    r1.y = r1.y ? -r2.x : r2.x;
    r1.y = 3.14159274 + r1.y;
    r2.x = 0.159154937 * r1.y;
    r1.y = abs(r1.x) * 0.5 + 0.5;
    r2.y = r1.x * r1.y;
    r1.yz = saturate(Consts[14].zy * r1.wx);
    r1.y = Consts[14].x * r1.y;
    r1.z = 1 + -r1.z;
    r1.y = r1.y * r1.z;
    r2.xyzw = -Consts[13].xyzw + r2.xyxy;
    r2.xyzw = float4(8,3,25,8) * r2.xyzw;
    r3.xyz = HeatHazeTexture.Sample(HeatHazeTexture_s, r2.xy).xyw;
    r3.xyz = float3(-0,-0.5,-0.5) + r3.xyz;
    r2.xyz = HeatHazeTexture.Sample(HeatHazeTexture_s, r2.zw).xyw;
    r2.xyz = float3(-0.5,-0.5,-0.5) + r2.xyz;
    r2.xyz = r2.xyz * float3(0, 0.75, 0.75) + r3.xyz;
    r2.xyw *= CUSTOM_HEAT_HAZE;
    r1.yz = r2.zy * r1.yy;
    r1.yz = r1.yz * r2.xx + v1.xy;
    r0.xy = Consts[9].xy * r1.yz;
    r2.x = DepthTexture.Sample(DepthTexture_s, r0.xy).x;
    r2.x = r2.x * Consts[2].z + Consts[2].w;
    r1.w = 1 / r2.x;
  } else {
    r1.yz = v1.xy;
  }
  r2.xyz = SceneTexture.Sample(SceneTexture_s, r0.xy).xyz;
  r3.xyz = BloomTexture.Sample(BloomTexture_s, r0.xy).xyz * CUSTOM_BLOOM;
  r4.xyz = SecondaryBloomTexture.Sample(SecondaryBloomTexture_s, r0.xy).xyz * CUSTOM_BLOOM;
  r1.x = saturate(r1.x);
  r0.x = r1.x * r1.x;
  r0.x = r0.x * Consts[12].z + 1;
  r0.y = saturate(r1.w * Consts[4].x + -Consts[4].y);
  r0.x = r0.y / r0.x;
  r0.y = saturate(r1.w * Consts[4].z + Consts[4].w);
  r0.y = Consts[2].y * r0.y;
  r0.x = r0.x * Consts[0].w + r0.y;
  r0.x = saturate(Consts[0].z + r0.x);
  r0.y = -0.333000004 + r0.x;
  r0.y = r0.y + r0.y;
  r0.y = max(0, r0.y);
  r1.x = floor(r0.y);
  r5.xyz = BlurredSceneTexture.SampleLevel(BlurredSceneTexture_s, r1.yz, r1.x).xyz;
  r1.x = 1 + r1.x;
  r1.xyz = BlurredSceneTexture.SampleLevel(BlurredSceneTexture_s, r1.yz, r1.x).xyz;
  r0.y = frac(r0.y);
  r1.xyz = r1.xyz + -r5.xyz;
  r1.xyz = r0.yyy * r1.xyz + r5.xyz;
  r0.x = 3 * r0.x;
  r0.x = min(1, r0.x);
  r1.xyz = r1.xyz + -r2.xyz;
  r1.xyz = r0.xxx * r1.xyz + r2.xyz;
  r2.xyz = EdgeFadeTexture.Sample(EdgeFadeTexture_s, v1.xy).xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.xyz = LensDirtTexture.Sample(LensDirtTexture_s, r0.zw).xyz;
  r0.xyz = r0.xyz * Consts[12].www + float3(1,1,1);
  r2.xyz = Consts[3].yyy * r4.xyz;
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = r3.xyz * Consts[3].xxx + r0.xyz;
  r0.xyz = r1.xyz * Consts[2].xxx + r0.xyz;

  float3 untonemapped = r0.rgb;

  r0.xyz = max(float3(1.00000001e-07,1.00000001e-07,1.00000001e-07), r0.xyz);
  r1.xyz = r0.xyz * float3(0.150000006,0.150000006,0.150000006) + float3(0.0500000007,0.0500000007,0.0500000007);
  r1.xyz = r0.xyz * r1.xyz + float3(0.00400000019,0.00400000019,0.00400000019);
  r2.xyz = r0.xyz * float3(0.150000006,0.150000006,0.150000006) + float3(0.5,0.5,0.5);
  r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = float3(-0.0666666701,-0.0666666701,-0.0666666701) + r0.xyz;
  r0.xyz = Consts[1].xyz * r0.xyz;
  r0.xyz = sqrt(r0.xyz);
  r0.xyz = min(float3(1,1,1), r0.xyz);
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r0.xyz = ColorCorrectionTexture.Sample(ColorCorrectionTexture_s, r0.xyz).xyz;
  r0.xyz = r0.xyz * r0.xyz;
  r0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  o0.w = sqrt(r0.w);
  o0.xyz = r0.xyz;

  if (RENODX_TONE_MAP_TYPE == 0) {
    o0.rgb = saturate(o0.rgb);
  } else {
    o0.rgb = renodx::draw::ToneMapPass(untonemapped, o0.rgb);
  }
  if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    o0.rgb = renodx::effects::ApplyFilmGrain(
        o0.rgb,
        v1.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
        1.f);
  }
  return;
}