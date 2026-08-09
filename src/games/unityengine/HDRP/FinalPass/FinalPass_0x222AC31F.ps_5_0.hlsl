#include "../../common.hlsl"

Texture2DArray<float4> t3 : register(t3);
Texture2DArray<float4> t2 : register(t2);
Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[53];
}
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.z = 0;
  r1.xy = rcp(cb1[52].xy);
  r1.xy = cb1[50].xy * r1.xy;
  r1.zw = v1.xy * cb0[3].xy + cb0[3].zw;
  r2.xy = cb1[52].xy * r1.zw;
  r3.xy = cb0[2].xy * r1.zw;
  r1.zw = r2.xy * r1.xy + float2(0.5,0.5);
  r1.xy = float2(1,1) / r1.xy;
  r4.xy = frac(r1.zw);
  r1.zw = floor(r1.zw);
  r4.zw = r4.xy * float2(0.5,0.5) + float2(-1,-1);
  r5.xy = r4.xy * r4.xy;
  r4.zw = r5.xy * r4.zw + float2(0.666666687,0.666666687);
  r5.xy = float2(1,1) + -r4.zw;
  r6.xyzw = -r4.xyxy * float4(0.5,0.5,0.166666672,0.166666672) + float4(0.5,0.5,0.5,0.5);
  r6.xyzw = r4.xyxy * r6.xyzw + float4(0.5,0.5,-0.5,-0.5);
  r6.xyzw = r4.xyxy * r6.xyzw + float4(0.166666672,0.166666672,0.166666672,0.166666672);
  r4.xy = -r6.xy + r5.xy;
  r4.xy = r4.xy + -r6.zw;
  r5.xyzw = r6.xyzw + r4.xyzw;
  r6.xy = rcp(r5.xy);
  r6.xy = r4.xy * r6.xy + float2(1,1);
  r4.xy = rcp(r5.zw);
  r6.zw = r4.zw * r4.xy + float2(-1,-1);
  r4.xyzw = r6.zyxy + r1.zwzw;
  r6.xyzw = r6.zwxw + r1.zwzw;
  r6.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r6.xyzw;
  r6.xyzw = r6.xyzw * r1.xyxy;
  r4.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r4.xyzw;
  r1.xyzw = r4.xyzw * r1.xyxy;
  r4.xy = -cb1[50].zw * float2(0.5,0.5) + float2(1,1);
  r4.xy = cb1[52].xy * r4.xy;
  r0.xy = min(r4.xy, r1.zw);
  r1.xy = min(r4.xy, r1.xy);
  r0.xyz = t0.SampleLevel(s1_s, r0.xyz, 0).xyz;
  r0.xyz = r5.xxx * r0.xyz;
  r1.z = 0;
  r1.xyz = t0.SampleLevel(s1_s, r1.xyz, 0).xyz;
  r0.xyz = r5.zzz * r1.xyz + r0.xyz;
  r0.xyz = r5.yyy * r0.xyz;
  r1.xy = min(r6.zw, r4.xy);
  r4.xy = min(r6.xy, r4.xy);
  r1.z = 0;
  r1.xyz = t0.SampleLevel(s1_s, r1.xyz, 0).xyz;
  r1.xyz = r5.xxx * r1.xyz;
  r4.z = 0;
  r4.xyz = t0.SampleLevel(s1_s, r4.xyz, 0).xyz;
  r1.xyz = r5.zzz * r4.xyz + r1.xyz;
  r0.xyz = r5.www * r1.xyz + r0.xyz;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r3.z = cb0[2].z;
  r0.w = t2.Sample(s2_s, r3.xyz).w;
  r0.w = r0.w * 2 + -1;
  r1.x = 1 + -abs(r0.w);
  r0.w = r0.w >= 0 ? 1 : -1;
  r1.x = sqrt(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  r2.z = 0;
  r1.xyzw = t1.SampleLevel(s0_s, r2.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.xyz + r1.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  r0.xy = cb1[50].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(-1,-1) + cb1[50].xy;
  r0.zw = cb0[3].zw * r0.zw;
  r0.xy = r0.xy * cb0[3].xy + r0.zw;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0,0);
  r0.x = t3.Load(r0.xyzw).x;
  o0.w = cb0[5].x == 1.0 ? r0.x : 1;
  return;
}