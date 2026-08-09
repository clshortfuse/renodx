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

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r0.yz = v1.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r0.yz, r0.yz);
  r0.yz = r0.yz * r0.ww;
  r0.yz = cb0[7].xx * r0.yz * injectedData.fxCA;
  r1.xy = cb0[2].zw * -r0.yz;
  r1.xy = float2(0.5,0.5) * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r0.w = max(3, (int)r0.w);
  r0.w = min(16, (int)r0.w);
  r1.x = (int)r0.w;
  r0.yz = -r0.yz / r1.xx;
  r2.y = 0;
  r1.yzw = float3(0,0,0);
  r2.zw = v1.xy;
  r3.xyzw = float4(0,0,0,0);
  while (true) {
    r4.x = cmp((int)r3.w >= (int)r0.w);
    if (r4.x != 0) break;
    r4.x = (int)r3.w;
    r4.x = 0.5 + r4.x;
    r2.x = r4.x / r1.x;
    r4.xy = r2.zw * cb0[3].xy + cb0[3].zw;
    r4.xyzw = t1.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r5.xyzw = t2.SampleLevel(s2_s, r2.xy, 0).xyzw;
    r1.yzw = r4.xyz * r5.xyz + r1.yzw;
    r3.xyz = r5.xyz + r3.xyz;
    r2.zw = r2.zw + r0.yz;
    r3.w = (int)r3.w + 1;
  }
  r0.yzw = r1.yzw / r3.xyz;
  r1.xyzw = float4(1,1,-1,0) * cb0[10].xyxy;
  r2.xyzw = -r1.xywy * cb0[11].xxxx + w2.xyxy;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.xyz = r2.xyz * float3(2,2,2) + r3.xyz;
  r3.xy = -r1.zy * cb0[11].xx + w2.xy;
  r3.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyzw = r1.zwxw * cb0[11].xxxx + w2.xyxy;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyz = r4.xyz * float3(2,2,2) + r2.xyz;
  r4.xyzw = t3.Sample(s3_s, w2.xy).xyzw;
  r2.xyz = r4.xyz * float3(4,4,4) + r2.xyz;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r2.xyz = r3.xyz * float3(2,2,2) + r2.xyz;
  r3.xyzw = r1.zywy * cb0[11].xxxx + w2.xyxy;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyz = r4.xyz + r2.xyz;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r2.xyz = r3.xyz * float3(2,2,2) + r2.xyz;
  r1.xy = r1.xy * cb0[11].xx + w2.xy;
  r1.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = cb0[11].yyy * r1.xyz * injectedData.fxBloom;
  r1.xyz = float3(0.0625,0.0625,0.0625) * r1.xyz;
  r0.xyz = r0.yzw * r0.xxx + r1.xyz;
  r2.xyzw = t4.Sample(s4_s, v2.xy).xyzw;
  r2.xyz = cb0[11].zzz * r2.xyz * injectedData.fxLens;
  r0.xyz = r1.xyz * r2.xyz + r0.xyz;
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