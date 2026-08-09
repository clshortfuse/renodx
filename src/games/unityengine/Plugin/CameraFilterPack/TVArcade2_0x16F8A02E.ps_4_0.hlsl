#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * cb0[5].xy + cb0[5].zw;
  r0.zw = float2(-0.5,-0.5) + r0.xy;
  r0.zw = float2(2.2,2.2) * r0.zw;
  r1.x = 0.2 * abs(r0.w);
  r1.x = r1.x * r1.x + 1;
  r1.x = r1.x * r0.z;
  r0.z = 0.25 * abs(r1.x);
  r0.z = r0.z * r0.z + 1;
  r1.y = r0.w * r0.z;
  r0.zw = r1.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r0.zw = r0.zw * float2(0.92,0.92) + float2(0.04,0.04);
  r0.zw = r0.zw + -r0.xy;
  r0.xy = saturate(cb0[3].xx * r0.zw + r0.xy);
  r0.zw = float2(21,29) * r0.yy;
  r0.zw = cb0[2].xx * float2(0.3,0.7) + r0.zw;
  r0.zw = sin(r0.zw);
  r0.z = r0.z * r0.w;
  r0.w = cb0[2].x * 0.33 + 0.3;
  r0.w = r0.y * 31 + r0.w;
  r0.w = sin(r0.w);
  r0.z = r0.z * r0.w;
  r0.w = r0.z * 0.0017 + r0.x;
  r0.z = r0.z * 0.0017 + 0.025;
  r1.x = 0.001 + r0.w;
  r1.yw = float2(0.001,-0.015) + r0.yy;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r2.xyz = float3(0.05,0.05,0.05) + r2.xyz;
  r0.w = -cb0[2].x * cb0[2].z;
  r0.w = frac(r0.w);
  r0.w = r0.y * cb0[2].y + -r0.w;
  r0.w = -0.05 + r0.w;
  r0.w = max(0, r0.w);
  r0.w = min(0.1, r0.w);
  r1.x = r0.w * 10 + -0.5;
  r0.w = 100 * r0.w;
  r0.w = sin(r0.w);
  r1.x = r1.x * r1.x;
  r1.x = r1.x * -4 + 1;
  r0.w = r1.x * r0.w;
  r1.x = 0.02 * r0.w;
  r1.y = 0;
  r0.xy = r1.xy + r0.xy;
  r1.z = r0.z * 0.75 + r0.x;
  r0.zw = float2(0.001,0.001) + r1.zw;
  r1.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r1.xyz = r1.xyz * float3(0.08,0.05,0.08) + r2.xyz;
  r2.xyz = r1.xyz * r1.xyz;
  r2.xyz = float3(0.4,0.4,0.4) * r2.xyz;
  r1.xyz = r1.xyz * float3(0.6,0.6,0.6) + r2.xyz;
  if(injectedData.toneMapType == 0.f){
    r1.xyz = saturate(r1.xyz);
  }
  r0.z = r0.y * r0.x;
  r0.z = 16 * r0.z;
  r2.xy = float2(1,1) + -r0.xy;
  r0.z = r2.x * r0.z;
  r0.z = r0.z * r2.y;
  r0.z = log2(r0.z);
  r0.z = 0.3 * r0.z;
  r0.z = exp2(r0.z);
  r1.xyz = r1.xyz * r0.zzz;
  r1.xyz = float3(2.66,2.94,2.66) * r1.xyz;
  r0.z = cb0[4].y * r0.y;
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xw = float2(3.5,110) * cb0[2].xx;
  r0.x = r0.z * 1.5 + r0.x;
  r0.xw = sin(r0.xw);
  r0.x = r0.x * 0.35 + 0.35;
  r0.x = log2(r0.x);
  r0.x = 1.7 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = cb0[2].w * r0.x;
  r0.x = r0.x * 0.7 + 0.4;
  r0.xyz = r1.xyz * r0.xxx;
  r0.w = r0.w * 0.01 + 1;
  r0.xyz = r0.xyz * r0.www + -r2.xyz;
  o0.xyz = cb0[3].xxx * r0.xyz + r2.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  o0.w = 1;
  return;
}