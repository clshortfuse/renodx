#include "../../tonemap.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[12];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(1,1,-1,0) * cb0[10].xyxy;
  r1.xyzw = -r0.xywy * cb0[11].xxxx + w2.xyxy;
  r2.xyzw = t4.Sample(s4_s, r1.xy).xyzw;
  r1.xyzw = t4.Sample(s4_s, r1.zw).xyzw;
  r1.xyz = r1.xyz * float3(2,2,2) + r2.xyz;
  r2.xy = -r0.zy * cb0[11].xx + w2.xy;
  r2.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r2.xyzw = r0.zwxw * cb0[11].xxxx + w2.xyxy;
  r3.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r2.xyzw = t4.Sample(s4_s, r2.zw).xyzw;
  r1.xyz = r3.xyz * float3(2,2,2) + r1.xyz;
  r3.xyzw = t4.Sample(s4_s, w2.xy).xyzw;
  r1.xyz = r3.xyz * float3(4,4,4) + r1.xyz;
  r1.xyz = r2.xyz * float3(2,2,2) + r1.xyz;
  r2.xyzw = r0.zywy * cb0[11].xxxx + w2.xyxy;
  r0.xy = r0.xy * cb0[11].xx + w2.xy;
  r0.xyzw = t4.Sample(s4_s, r0.xy).xyzw;
  r3.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r2.xyzw = t4.Sample(s4_s, r2.zw).xyzw;
  r1.xyz = r3.xyz + r1.xyz;
  r1.xyz = r2.xyz * float3(2,2,2) + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = cb0[11].yyy * r0.xyz * injectedData.fxBloom;
  r1.xyzw = t3.Sample(s3_s, w2.xy).xyzw;
  r0.w = -0.5 + r1.x;
  r0.w = r0.w + r0.w;
  r1.x = cb0[2].y + cb0[2].y;
  r0.w = r0.w * cb0[9].z + -r1.x;
  r1.x = 1 / r1.x;
  r0.w = saturate(r1.x * r0.w);
  r1.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r1.y = r1.x * r0.w;
  r2.xyzw = t2.Sample(s2_s, w2.xy).xyzw;
  r0.w = r1.x * r0.w + r2.w;
  r0.w = -r1.y * r2.w + r0.w;
  r1.xyzw = t1.Sample(s0_s, w1.xy).xyzw;
  r3.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r1.xyz = r3.xxx * r1.xyz;
  r2.xyz = r2.xyz * r3.xxx + -r1.xyz;
  r1.xyz = r0.www * r2.xyz + r1.xyz;
  r0.xyz = r0.xyz * float3(0.0625,0.0625,0.0625) + r1.xyz;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}