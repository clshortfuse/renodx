#include "./shared.h"
// ---- Created with 3Dmigoto v1.3.2 on Sat Apr 12 13:35:24 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1405];
}




// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb0[1394].zwzw * v1.xyxy;
  r0.xyzw = (int4)r0.xyzw;
  r1.xyzw = (int4)r0.zwzw + int4(-1,-1,1,-1);
  r0.xyzw = (int4)r0.xyzw + int4(-1,1,1,1);
  r0.xyzw = (int4)r0.xyzw;
  r0.xyzw = cb0[1394].xyxy * r0.xyzw;
  r1.xyzw = (int4)r1.xyzw;
  r1.xyzw = cb0[1394].xyxy * r1.xyzw;
  r2.xyzw = t0.Sample(s1_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s1_s, r1.zw).xyzw;
  r1.xyz = saturate(r1.xyz);
  r1.x = dot(r1.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r2.xyz = saturate(r2.xyz);
  r1.y = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r2.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s1_s, r0.zw).xyzw;
  r0.xyz = saturate(r0.xyz);
  r0.x = dot(r0.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r2.xyz = saturate(r2.xyz);
  r0.y = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.zw = r1.yx + r0.yx;
  r2.yw = r0.zz + -r0.ww;
  r0.z = r1.y + r1.x;
  r0.w = r0.y + r0.x;
  r0.w = r0.z + -r0.w;
  r0.z = r0.z + r0.y;
  r0.z = r0.z + r0.x;
  r0.z = 0.03125 * r0.z;
  r0.z = max(0.0078125, r0.z);
  r1.z = min(abs(r0.w), abs(r2.w));
  r2.xz = -r0.ww;
  r0.z = r1.z + r0.z;
  r0.z = 1 / r0.z;
  r2.xyzw = r2.xyzw * r0.zzzz;
  r2.xyzw = max(float4(-8,-8,-8,-8), r2.xyzw);
  r2.xyzw = min(float4(8,8,8,8), r2.xyzw);
  r2.xyzw = cb0[1394].xyxy * r2.xyzw;
  r3.xyzw = r2.zwzw * float4(-0.5,-0.5,-0.166666672,-0.166666672) + v1.xyxy;
  r2.xyzw = r2.xyzw * float4(0.166666672,0.166666672,0.5,0.5) + v1.xyxy;
  r4.xyzw = t0.Sample(s1_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s1_s, r3.zw).xyzw;
  r3.xyz = saturate(r3.xyz);
  r4.xyz = saturate(r4.xyz);
  r5.xyzw = t0.Sample(s1_s, r2.zw).xyzw;
  r2.xyzw = t0.Sample(s1_s, r2.xy).xyzw;
  r2.xyz = saturate(r2.xyz);
  r2.xyz = r3.xyz + r2.xyz;
  r5.xyz = saturate(r5.xyz);
  r3.xyz = r5.xyz + r4.xyz;
  r3.xyz = float3(0.25,0.25,0.25) * r3.xyz;
  r3.xyz = r2.xyz * float3(0.25,0.25,0.25) + r3.xyz;
  r2.xyz = float3(0.5,0.5,0.5) * r2.xyz;
  r0.z = dot(r3.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.w = min(r1.x, r0.y);
  r0.y = max(r1.x, r0.y);
  r0.y = max(r0.y, r0.x);
  r0.x = min(r0.w, r0.x);
  r4.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  float3 untonemapped = r4.rgb;
  untonemapped = renodx::color::srgb::DecodeSafe(untonemapped);
  r4.xyz = saturate(r4.xyz);
  o0.w = r4.w;
  r0.w = dot(r4.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r1.x = min(r0.w, r1.y);
  r0.w = max(r0.w, r1.y);
  r0.y = max(r0.w, r0.y);
  r0.x = min(r1.x, r0.x);
  r0.xy = cmp(r0.zy < r0.xz);
  r0.x = (int)r0.y | (int)r0.x;
  r0.xyz = r0.xxx ? r2.xyz : r3.xyz;
  r1.xy = v1.xy * cb0[1404].xy + cb0[1404].zw;
  r1.xyzw = t1.Sample(s2_s, r1.xy).xyzw;
  r0.w = -0.5 + r1.w;
  r0.w = r0.w + r0.w;
  r1.xyz = r0.xyz * r0.www;
  r1.xyz = cb0[1403].xxx * r1.xyz;
  r0.w = dot(r0.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.w = sqrt(r0.w);
  r0.w = cb0[1403].y * -r0.w + 1;
  o0.xyz = r1.xyz * r0.www + r0.xyz;

  float3 sdr = saturate(o0.rgb);
  o0.rgb = renodx::color::srgb::DecodeSafe(sdr);
  o0.rgb = renodx::draw::ToneMapPass(untonemapped, sdr);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}