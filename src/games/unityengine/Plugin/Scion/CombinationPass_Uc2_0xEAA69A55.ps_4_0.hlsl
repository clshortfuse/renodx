#include "../../common.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[23];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.25 * cb0[21].w;
  r1.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.xyzw = cb0[20].wwzz * r1.xyzw;
  r0.y = dot(r1.xy, r1.xy);
  r0.z = dot(r1.zw, r1.zw);
  r0.yz = float2(1,1) + -r0.yz;
  r0.yz = max(float2(0,0), r0.yz);
  r0.z = r0.z * r0.z + -1;
  r0.z = cb0[20].y * r0.z + 1;
  r0.y = r0.y * r0.y;
  r0.y = -cb0[7].z * r0.y + cb0[7].z;
  r0.xw = r0.yy * r0.xx + v1.xy;
  r1.xyzw = t0.SampleLevel(s1_s, r0.xw, 0).xyzw;
  r1.xyz = float3(0.5,0.5,0) * r1.xyz;
  r2.xyzw = t0.SampleLevel(s1_s, v1.xy, 0).xyzw;
  r1.xyz = r2.xyz * float3(1,0,0) + r1.xyz;
  r0.x = cb0[21].w * r0.y;
  r0.yw = r0.yy * cb0[21].ww + v1.xy;
  r2.xyzw = t0.SampleLevel(s1_s, r0.yw, 0).xyzw;
  r3.xyzw = r0.xxxx * float4(0.5,0.5,0.75,0.75) + v1.xyxy;
  r4.xyzw = t0.SampleLevel(s1_s, r3.xy, 0).xyzw;
  r3.xyzw = t0.SampleLevel(s1_s, r3.zw, 0).xyzw;
  r0.xyw = r4.xyz * float3(0,1,0) + r1.xyz;
  r0.xyw = r3.xyz * float3(0,0.5,0.5) + r0.xyw;
  r0.xyw = r2.xyz * float3(0,0,1) + r0.xyw;
  r1.xyz = float3(0.666666687,0.5,0.666666687) * r0.xyw;
  r1.xyz = cb0[21].xyz * r1.xyz;
  r0.xyw = r0.xyw * float3(0.666666687,0.5,0.666666687) + -r1.xyz;
  r0.xyz = r0.zzz * r0.xyw + r1.xyz;
  r0.w = v1.y * 541.169983 + v1.x;
  r0.w = cb0[22].x + r0.w;
  r0.w = sin(r0.w);
  r0.w = r0.w * 273351.5 + -cb0[22].x;
  r0.w = frac(r0.w);
  r0.w = r0.w * 2 + -1;
  r0.w = cb0[20].x * r0.w;
  r0.xyz = r0.www * r0.xyz + r0.xyz;
  r1.xyzw = t1.SampleLevel(s0_s, float2(0.5,0.5), 0).xyzw;
  r0.xyz = r1.xxx * r0.xyz;
  r0.xyz = Uncharted2Tonemap(r0.xyz, 0.22, 0.3, 0.1, 0.2, 0.01, 0.3, uncharted2GetLinearWhite(cb0[22].y, 0.22, 0.3, 0.1, 0.2, 0.01, 0.3));
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
  r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}