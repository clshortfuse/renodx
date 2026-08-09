#include "../../common.hlsl"

Texture2DArray<float4> t2 : register(t2);
Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[49];
}
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.z = 0;
  r1.xy = rcp(cb1[48].xy);
  r1.xy = cb1[46].xy * r1.xy;
  r1.zw = v1.xy * cb0[3].xy + cb0[3].zw;
  r2.xy = cb1[48].xy * r1.zw;
  r1.zw = r2.xy * r1.xy + float2(0.5,0.5);
  r1.xy = float2(1,1) / r1.xy;
  r3.xy = frac(r1.zw);
  r1.zw = floor(r1.zw);
  r3.zw = r3.xy * float2(0.5,0.5) + float2(-1,-1);
  r4.xy = r3.xy * r3.xy;
  r3.zw = r4.xy * r3.zw + float2(0.666666687,0.666666687);
  r4.xy = float2(1,1) + -r3.zw;
  r5.xyzw = -r3.xyxy * float4(0.5,0.5,0.166666672,0.166666672) + float4(0.5,0.5,0.5,0.5);
  r5.xyzw = r3.xyxy * r5.xyzw + float4(0.5,0.5,-0.5,-0.5);
  r5.xyzw = r3.xyxy * r5.xyzw + float4(0.166666672,0.166666672,0.166666672,0.166666672);
  r3.xy = -r5.xy + r4.xy;
  r3.xy = r3.xy + -r5.zw;
  r4.xyzw = r5.xyzw + r3.xyzw;
  r5.xy = rcp(r4.xy);
  r5.xy = r3.xy * r5.xy + float2(1,1);
  r3.xy = rcp(r4.zw);
  r5.zw = r3.zw * r3.xy + float2(-1,-1);
  r3.xyzw = r5.zyxy + r1.zwzw;
  r5.xyzw = r5.zwxw + r1.zwzw;
  r5.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r5.xyzw;
  r5.xyzw = r5.xyzw * r1.xyxy;
  r3.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r3.xyzw;
  r1.xyzw = r3.xyzw * r1.xyxy;
  r3.xy = -cb1[46].zw * float2(0.5,0.5) + float2(1,1);
  r3.xy = cb1[48].xy * r3.xy;
  r0.xy = min(r3.xy, r1.zw);
  r1.xy = min(r3.xy, r1.xy);
  r0.xyz = t0.SampleLevel(s1_s, r0.xyz, 0).xyz;
  r0.xyz = r4.xxx * r0.xyz;
  r1.z = 0;
  r1.xyz = t0.SampleLevel(s1_s, r1.xyz, 0).xyz;
  r0.xyz = r4.zzz * r1.xyz + r0.xyz;
  r0.xyz = r4.yyy * r0.xyz;
  r1.xy = min(r5.zw, r3.xy);
  r3.xy = min(r5.xy, r3.xy);
  r1.z = 0;
  r1.xyz = t0.SampleLevel(s1_s, r1.xyz, 0).xyz;
  r1.xyz = r4.xxx * r1.xyz;
  r3.z = 0;
  r3.xyz = t0.SampleLevel(s1_s, r3.xyz, 0).xyz;
  r1.xyz = r4.zzz * r3.xyz + r1.xyz;
  r0.xyz = r4.www * r1.xyz + r0.xyz;
  r2.z = 0;
  r1.xyzw = t1.SampleLevel(s0_s, r2.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.xyz + r1.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  r0.xy = cb1[46].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(-1,-1) + cb1[46].xy;
  r0.zw = cb0[3].zw * r0.zw;
  r0.xy = r0.xy * cb0[3].xy + r0.zw;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0,0);
  r0.x = t2.Load(r0.xyzw).x;
  o0.w = cb0[5].x == 1.0 ? r0.x : 1;
  return;
}