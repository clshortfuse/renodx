#include "../../tonemap.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[16];
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

  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.z = dot(r0.xy, r0.xy);
  r0.xy = r0.xy * r0.zz;
  r0.xy = cb0[4].xx * r0.xy * injectedData.fxCA;
  r0.zw = cb0[2].zw * -r0.xy;
  r0.zw = float2(0.5,0.5) * r0.zw;
  r0.z = dot(r0.zw, r0.zw);
  r0.z = sqrt(r0.z);
  r0.z = (int)r0.z;
  r0.z = max(3, (int)r0.z);
  r0.z = min(16, (int)r0.z);
  r0.w = (int)r0.z;
  r0.xy = -r0.xy / r0.ww;
  r1.y = 0;
  r3.xyz = float3(0,0,0);
  r1.zw = v1.xy;
  r2.xyzw = float4(0,0,0,0);
  while (true) {
    r3.w = cmp((int)r2.w >= (int)r0.z);
    if (r3.w != 0) break;
    r3.w = (int)r2.w;
    r3.w = 0.5 + r3.w;
    r1.x = r3.w / r0.w;
    r4.xy = r1.zw * cb0[3].xy + cb0[3].zw;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r5.xyzw = t1.SampleLevel(s1_s, r1.xy, 0).xyzw;
    r2.xyz = r4.xyz * r5.xyz + r2.xyz;
    r3.xyz = r5.xyz + r3.xyz;
    r1.zw = r1.zw + r0.xy;
    r2.w = (int)r2.w + 1;
  }
  r0.xyz = r2.xyz / r3.xyz;
  r1.xyzw = float4(1,1,-1,0) * cb0[7].xyxy;
  r2.xyzw = -r1.xywy * cb0[8].xxxx + w2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r2.xyzw = t2.Sample(s2_s, r2.zw).xyzw;
  r2.xyz = r2.xyz * float3(2,2,2) + r3.xyz;
  r3.xy = -r1.zy * cb0[8].xx + w2.xy;
  r3.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyzw = r1.zwxw * cb0[8].xxxx + w2.xyxy;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r2.xyz = r4.xyz * float3(2,2,2) + r2.xyz;
  r4.xyzw = t2.Sample(s2_s, w2.xy).xyzw;
  r2.xyz = r4.xyz * float3(4,4,4) + r2.xyz;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r2.xyz = r3.xyz * float3(2,2,2) + r2.xyz;
  r3.xyzw = r1.zywy * cb0[8].xxxx + w2.xyxy;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r2.xyz = r4.xyz + r2.xyz;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r2.xyz = r3.xyz * float3(2,2,2) + r2.xyz;
  r1.xy = r1.xy * cb0[8].xx + w2.xy;
  r1.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = cb0[8].yyy * r1.xyz * injectedData.fxBloom;
  r2.xyz = float3(0.0625,0.0625,0.0625) * r1.xyz;
  r0.xyz = r1.xyz * float3(0.0625,0.0625,0.0625) + r0.xyz;
  r1.xyzw = t3.Sample(s3_s, v2.xy).xyzw;
  r1.xyz = cb0[8].zzz * r1.xyz * injectedData.fxLens;
  r0.xyz = r2.xyz * r1.xyz + r0.xyz;
  r1.xy = -cb0[14].xy + v1.xy;
  r1.yz = cb0[15].xx * abs(r1.xy) * min(1.f, injectedData.fxVignette);
  r0.w = cb1[6].x / cb1[6].y;
  r1.x = r1.y * r0.w;
  r0.w = dot(r1.xz, r1.xz);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = log2(r0.w);
  r0.w = cb0[15].y * r0.w * max(1.f, injectedData.fxVignette);
  r0.w = exp2(r0.w);
  r1.xyz = float3(1,1,1) + -cb0[13].xyz;
  r1.xyz = r0.www * r1.xyz + cb0[13].xyz;
  r0.xyz = r1.xyz * r0.xyz;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if(injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}