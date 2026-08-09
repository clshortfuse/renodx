#include "../../common.hlsl"

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
  float4 r0,r1,r2,r3,r4,r5,r6;
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
  r1.yw = float2(0,0);
  r3.xyz = float3(0,0,0);
  r4.xy = v1.xy;
  r2.xyzw = float4(0,0,0,0);
  while (true) {
    r3.w = cmp((int)r2.w >= (int)r0.z);
    if (r3.w != 0) break;
    r3.w = (int)r2.w;
    r3.w = 0.5 + r3.w;
    r1.x = r3.w / r0.w;
    r4.zw = r4.xy * cb0[3].xy + cb0[3].zw;
    r5.xyzw = t0.SampleLevel(s0_s, r4.zw, 0).xyzw;
    r6.xyzw = t1.SampleLevel(s1_s, r1.xy, 0).xyzw;
    r2.xyz = r5.zxy * r6.zxy + r2.xyz;
    r3.xyz = r6.zxy + r3.xyz;
    r4.xy = r4.xy + r0.xy;
    r2.w = (int)r2.w + 1;
  }
  r0.xyz = r2.xyz / r3.xyz;
  r2.xyzw = float4(1,1,-1,0) * cb0[7].xyxy;
  r3.xyzw = -r2.xywy * cb0[8].xxxx + w2.xyxy;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r3.xyz = r3.zxy * float3(2,2,2) + r4.zxy;
  r1.xy = -r2.zy * cb0[8].xx + w2.xy;
  r4.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r3.xyz = r4.zxy + r3.xyz;
  r4.xyzw = r2.zwxw * cb0[8].xxxx + w2.xyxy;
  r5.xyzw = t2.Sample(s2_s, r4.xy).xyzw;
  r3.xyz = r5.zxy * float3(2,2,2) + r3.xyz;
  r5.xyzw = t2.Sample(s2_s, w2.xy).xyzw;
  r3.xyz = r5.zxy * float3(4,4,4) + r3.xyz;
  r4.xyzw = t2.Sample(s2_s, r4.zw).xyzw;
  r3.xyz = r4.zxy * float3(2,2,2) + r3.xyz;
  r4.xyzw = r2.zywy * cb0[8].xxxx + w2.xyxy;
  r5.xyzw = t2.Sample(s2_s, r4.xy).xyzw;
  r3.xyz = r5.zxy + r3.xyz;
  r4.xyzw = t2.Sample(s2_s, r4.zw).xyzw;
  r3.xyz = r4.zxy * float3(2,2,2) + r3.xyz;
  r1.xy = r2.xy * cb0[8].xx + w2.xy;
  r2.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r2.xyz = r3.xyz + r2.zxy;
  r2.xyz = cb0[8].yyy * r2.xyz * injectedData.fxBloom;
  r3.xyz = float3(0.0625,0.0625,0.0625) * r2.xyz;
  r0.xyz = r2.xyz * float3(0.0625,0.0625,0.0625) + r0.xyz;
  r2.xyzw = t3.Sample(s3_s, v2.xy).xyzw;
  r2.xyz = cb0[8].zzz * r2.zxy * injectedData.fxLens;
  r0.xyz = r3.xyz * r2.xyz + r0.xyz;
  r1.xy = -cb0[14].xy + v1.xy;
  r1.xy = cb0[15].xx * abs(r1.xy) * min(1.f, injectedData.fxVignette);
  r1.xy = log2(r1.xy);
  r1.xy = cb0[15].zz * r1.xy;
  r1.xy = exp2(r1.xy);
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = log2(r0.w);
  r0.w = cb0[15].y * r0.w * max(1.f, injectedData.fxVignette);
  r0.w = exp2(r0.w);
  r2.xyz = float3(1,1,1) + -cb0[13].zxy;
  r2.xyz = r0.www * r2.xyz + cb0[13].zxy;
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = cb0[9].www * r0.xyz;
  r0.yzx = lutShaper(r0.yzx);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.yzw = cb0[9].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[9].xy;
  r2.yz = r0.zw * cb0[9].xy + r1.xy;
  r2.x = r0.y * cb0[9].y + r2.y;
  r3.xyzw = t4.Sample(s4_s, r2.xz).xyzw;
  r1.z = cb0[9].y;
  r0.zw = r2.xz + r1.zw;
  r1.xyzw = t4.Sample(s4_s, r0.zw).xyzw;
  r0.x = r0.x * cb0[9].z + -r0.y;
  r0.yzw = r1.xyz + -r3.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t4, r0.yzx, cb0[9].z + 1u);
  }
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  if(injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}