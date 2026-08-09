#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v2.xy, 0).xyzw;
  r0.x = dot(r0.xyz, float3(0.219999999,0.707000017,0.0710000023));
  r1.xyzw = t0.SampleLevel(s0_s, v2.xw, 0).xyzw;
  r0.y = dot(r1.xyz, float3(0.219999999,0.707000017,0.0710000023));
  r1.xyzw = t0.SampleLevel(s0_s, v2.zy, 0).xyzw;
  r0.z = dot(r1.xyz, float3(0.219999999,0.707000017,0.0710000023));
  r1.xyzw = t0.SampleLevel(s0_s, v2.zw, 0).xyzw;
  r0.w = dot(r1.xyz, float3(0.219999999,0.707000017,0.0710000023));
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r1.w = dot(r1.xyz, float3(0.219999999,0.707000017,0.0710000023));
  r0.z = 0.00260416674 + r0.z;
  r2.xz = max(r0.xz, r0.yw);
  r2.yw = min(r0.xz, r0.yw);
  r2.x = max(r2.z, r2.x);
  r2.y = min(r2.w, r2.y);
  r2.z = cb0[2].y * r2.x;
  r2.w = min(r2.y, r1.w);
  r2.z = max(cb0[2].x, r2.z);
  r1.w = max(r2.x, r1.w);
  r1.w = r1.w + -r2.w;
  if (r1.w >= r2.z) {
    r0.xy = r0.wy + -r0.xz;
    r3.x = r0.y + r0.x;
    r3.y = r0.y + -r0.x;
    r0.x = dot(r3.xy, r3.xy);
    r0.x = rsqrt(r0.x);
    r0.xy = r3.xy * r0.xx;
    r0.zw = -r0.xy * v3.zw + v1.xy;
    r3.xyzw = t0.SampleLevel(s0_s, r0.zw, 0).xyzw;
    r0.zw = r0.xy * v3.zw + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r0.zw, 0).xyzw;
    r0.z = min(abs(r0.x), abs(r0.y));
    r0.z = cb0[2].z * r0.z;
    r0.xy = r0.xy / r0.zz;
    r0.xy = max(float2(-2,-2), r0.xy);
    r0.xy = min(float2(2,2), r0.xy);
    r0.zw = -r0.xy * v4.zw + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r0.zw, 0).xyzw;
    r0.xy = r0.xy * v4.zw + v1.xy;
    r0.xyzw = t0.SampleLevel(s0_s, r0.xy, 0).xyzw;
    r3.xyz = r4.xyz + r3.xyz;
    r0.xyz = r5.xyz + r0.xyz;
    r4.xyz = float3(0.25,0.25,0.25) * r3.xyz;
    r0.xyz = r0.xyz * float3(0.25,0.25,0.25) + r4.xyz;
    r0.w = dot(r3.xyz, float3(0.219999999,0.707000017,0.0710000023));
    r1.w = dot(r0.xyz, float3(0.219999999,0.707000017,0.0710000023));
    r2.xyz = float3(0.5,0.5,0.5) * r3.xyz;
    r1.xyz = (r2.y > r0.w) || (r2.x < r1.w) ? r2.xyz : r0.xyz;
  }
  if(injectedData.gammaSpace != 0.f){
    r1.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r1.xyz = applyUserNoTonemap(r1.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r1.xyz = PostToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  }
  o0.xyz = r1.xyz;
  o0.w = 1;
  return;
}