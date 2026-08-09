#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb0[2].xyxy * cb0[4].zzzz + v1.xyxy;
  r1.xy = r0.zw * cb0[3].xy + cb0[3].zw;
  r2.xyzw = t0.Sample(s1_s, r1.xy).xyzw;
  r1.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r1.xyz = InvertToneMapScale(r1.xyz);
  }
  if(injectedData.isClamped != 0.f){
    r1.xyz = rolloffSdr(r1.xyz);
  }
  r1.xyz = r1.xyz * r2.xxx;
  r1.xyz = min(float3(65504,65504,65504), r1.xyz);
  r2.xyzw = -cb0[2].xxxy * float4(1,0,0,1) + r0.zwzw;
  r0.xyzw = cb0[2].xxxy * float4(1,0,0,1) + r0.xyzw;
  r0.xyzw = r0.xyzw * cb0[3].xyxy + cb0[3].zwzw;
  r2.xyzw = r2.xyzw * cb0[3].xyxy + cb0[3].zwzw;
  r3.xyzw = t0.Sample(s1_s, r2.xy).xyzw;
  r4.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r4.xyz = InvertToneMapScale(r4.xyz);
  }
  if(injectedData.isClamped != 0.f){
    r4.xyz = rolloffSdr(r4.xyz);
  }
  r3.xyz = r4.xyz * r3.xxx;
  r3.xyz = min(float3(65504,65504,65504), r3.xyz);
  r4.xyz = r3.xyz + r1.xyz;
  r5.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r6.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r6.xyz = InvertToneMapScale(r6.xyz);
  }
  if(injectedData.isClamped != 0.f){
    r6.xyz = rolloffSdr(r6.xyz);
  }
  r5.xyz = r6.xyz * r5.xxx;
  r5.xyz = min(float3(65504,65504,65504), r5.xyz);
  r4.xyz = r5.xyz + r4.xyz;
  r6.xyz = min(r3.xyz, r1.xyz);
  r1.xyz = max(r3.xyz, r1.xyz);
  r1.xyz = max(r1.xyz, r5.xyz);
  r3.xyz = min(r6.xyz, r5.xyz);
  r3.xyz = r4.xyz + -r3.xyz;
  r1.xyz = r3.xyz + -r1.xyz;
  r3.xyzw = t0.Sample(s1_s, r2.zw).xyzw;
  r2.xyzw = t1.Sample(s0_s, r2.zw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r2.xyz = InvertToneMapScale(r2.xyz);
  }
  if(injectedData.isClamped != 0.f){
    r2.xyz = rolloffSdr(r2.xyz);
  }
  r2.xyz = r2.xyz * r3.xxx;
  r2.xyz = min(float3(65504,65504,65504), r2.xyz);
  r3.xyz = r2.xyz + r1.xyz;
  r4.xyzw = t0.Sample(s1_s, r0.zw).xyzw;
  r0.xyzw = t1.Sample(s0_s, r0.zw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r0.xyz = InvertToneMapScale(r0.xyz);
  }
  if(injectedData.isClamped != 0.f){
    r0.xyz = rolloffSdr(r0.xyz);
  }
  r0.xyz = r0.xyz * r4.xxx;
  r0.xyz = min(float3(65504,65504,65504), r0.xyz);
  r3.xyz = r3.xyz + r0.xyz;
  r4.xyz = min(r2.xyz, r1.xyz);
  r1.xyz = max(r2.xyz, r1.xyz);
  r1.xyz = max(r1.xyz, r0.xyz);
  r0.xyz = min(r4.xyz, r0.xyz);
  r0.xyz = r3.xyz + -r0.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.w = max(r0.y, r0.z);
  r0.w = max(r0.x, r0.w);
  r1.x = -cb0[5].x + r0.w;
  r1.x = max(0, r1.x);
  r1.x = min(cb0[5].y, r1.x);
  r1.y = cb0[5].z * r1.x;
  r1.x = r1.y * r1.x;
  r1.y = -cb0[4].w + r0.w;
  r0.w = max(9.99999975e-06, r0.w);
  r1.x = max(r1.x, r1.y);
  r0.w = r1.x / r0.w;
  o0.xyz = r0.xyz * r0.www;
  o0.w = 0;
  return;
}