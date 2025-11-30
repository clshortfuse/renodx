#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 13 18:40:11 2025

cbuffer _Globals : register(b0)
{
  float BlurRate : packoffset(c0);
  float2 BlurRectCenter : packoffset(c0.y);
  float2 BlurEllipseUVAxisDist : packoffset(c1);
  float2 BlurGradationWidth : packoffset(c1.z);
  int IsInside : packoffset(c2);
  float BlurWidth : packoffset(c2.y);
  int SampleNum : packoffset(c2.z);
}

SamplerState smplScene_s : register(s0);
Texture2D<float4> smplScene_Tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = -BlurRectCenter.xyxy + v1.xyxy;
  r0.xy = r0.xy * r0.xy;
  r1.xy = BlurEllipseUVAxisDist.xy + -BlurGradationWidth.xy;
  r1.xy = r1.xy * r1.xy;
  r1.yz = r0.xy / r1.xy;
  r1.y = r1.y + r1.z;
  r1.y = cmp(r1.y < 1);
  if (r1.y != 0) {
    r1.y = IsInside ? BlurRate : 0;
  } else {
    r1.zw = BlurEllipseUVAxisDist.xy * BlurEllipseUVAxisDist.xy;
    r0.xy = r0.xy / r1.zw;
    r0.x = r0.x + r0.y;
    r0.y = cmp(1 < r0.x);
    r1.w = IsInside ? 0 : BlurRate;
    r1.x = r1.x / r1.z;
    r0.x = -r1.x + r0.x;
    r1.x = 1 + -r1.x;
    r0.x = r0.x / r1.x;
    r1.x = BlurRate * r0.x;
    r0.x = -BlurRate * r0.x + 1;
    r0.x = IsInside ? r0.x : r1.x;
    r1.y = r0.y ? r1.w : r0.x;
  }
  r0.x = max(0, r1.y);
  r0.x = min(BlurRate, r0.x);
  r1.xyz = smplScene_Tex.Sample(smplScene_s, v1.xy).xyz;

  PostTmFxSampleScene(r1.xyz, false); // doesn't clamp, doesn't need anything

  r0.y = SampleNum;
  r1.w = BlurWidth / r0.y;
  r2.xyz = float3(0,0,0);
  r2.w = SampleNum;
  r3.x = 1;
  while (true) {
    r3.y = cmp(32 < (int)r3.x);
    if (r3.y != 0) break;
    r3.y = (int)r3.x;
    r3.y = r1.w * r3.y + 1;
    r3.yz = r0.zw * r3.yy + BlurRectCenter.xy;
    r3.yzw = smplScene_Tex.Sample(smplScene_s, r3.yz).xyz;

    PostTmFxSampleScene(r3.yzw, false);

    r3.yzw = r3.yzw + r2.xyz;
    r4.x = cmp((int)r3.x >= (int)r2.w);
    if (r4.x != 0) {
      r2.xyz = r3.yzw;
      break;
    }
    r3.x = (int)r3.x + 1;
    r2.xyz = r3.yzw;
  }
  r0.yzw = r2.xyz / r0.yyy;
  r0.yzw = r0.yzw + -r1.xyz;
  o0.xyz = r0.xxx * r0.yzw + r1.xyz;
  o0.w = 1;

  PostTmFxOutput(o0, false);

  return;
}