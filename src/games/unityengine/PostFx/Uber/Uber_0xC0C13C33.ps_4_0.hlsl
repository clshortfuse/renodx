#include "../../common.hlsl"

Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[21];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float4 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s3_s, w2.xy).xyzw;
  r0.y = cb1[7].x * r1.x + cb1[7].y;
  r0.y = 1 / r0.y;
  r0.zw = v1.xy * float2(2,2) + float2(-1,-1);
  r1.x = dot(r0.zw, r0.zw);
  r0.zw = r1.xx * r0.zw;
  r0.zw = cb0[4].xx * r0.zw * injectedData.fxCA;
  r1.xy = cb0[2].zw * -r0.zw;
  r1.xy = float2(0.5,0.5) * r1.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = sqrt(r1.x);
  r1.x = (int)r1.x;
  r1.x = max(3, (int)r1.x);
  r1.x = min(16, (int)r1.x);
  r1.y = (int)r1.x;
  r0.zw = -r0.zw / r1.yy;
  r2.yw = float2(0,0);
  r4.xyz = float3(0,0,0);
  r1.zw = v1.xy;
  r3.xyzw = float4(0,0,0,0);
  while (true) {
    r4.w = cmp((int)r3.w >= (int)r1.x);
    if (r4.w != 0) break;
    r4.w = (int)r3.w;
    r4.w = 0.5 + r4.w;
    r2.x = r4.w / r1.y;
    r5.xy = r1.zw * cb0[3].xy + cb0[3].zw;
    r5.xyzw = t2.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r6.xyzw = t3.SampleLevel(s2_s, r2.xy, 0).xyzw;
    r3.xyz = r5.zxy * r6.zxy + r3.xyz;
    r4.xyz = r6.zxy + r4.xyz;
    r1.zw = r1.zw + r0.zw;
    r3.w = (int)r3.w + 1;
  }
  r1.xyz = r3.xyz / r4.xyz;
  r3.xyzw = float4(1,1,-1,0) * cb0[7].xyxy;
  r4.xyzw = -r3.xywy * cb0[8].xxxx + w2.xyxy;
  r5.xyzw = t4.Sample(s4_s, r4.xy).xyzw;
  r4.xyzw = t4.Sample(s4_s, r4.zw).xyzw;
  r4.xyz = r4.zxy * float3(2,2,2) + r5.zxy;
  r0.zw = -r3.zy * cb0[8].xx + w2.xy;
  r5.xyzw = t4.Sample(s4_s, r0.zw).xyzw;
  r4.xyz = r5.zxy + r4.xyz;
  r5.xyzw = r3.zwxw * cb0[8].xxxx + w2.xyxy;
  r6.xyzw = t4.Sample(s4_s, r5.xy).xyzw;
  r4.xyz = r6.zxy * float3(2,2,2) + r4.xyz;
  r6.xyzw = t4.Sample(s4_s, w2.xy).xyzw;
  r4.xyz = r6.zxy * float3(4,4,4) + r4.xyz;
  r5.xyzw = t4.Sample(s4_s, r5.zw).xyzw;
  r4.xyz = r5.zxy * float3(2,2,2) + r4.xyz;
  r5.xyzw = r3.zywy * cb0[8].xxxx + w2.xyxy;
  r6.xyzw = t4.Sample(s4_s, r5.xy).xyzw;
  r4.xyz = r6.zxy + r4.xyz;
  r5.xyzw = t4.Sample(s4_s, r5.zw).xyzw;
  r4.xyz = r5.zxy * float3(2,2,2) + r4.xyz;
  r0.zw = r3.xy * cb0[8].xx + w2.xy;
  r3.xyzw = t4.Sample(s4_s, r0.zw).xyzw;
  r3.xyz = r4.xyz + r3.zxy;
  r3.xyz = cb0[8].yyy * r3.xyz * injectedData.fxBloom;
  r3.xyz = float3(0.0625,0.0625,0.0625) * r3.xyz;
  r0.xzw = r1.xyz * r0.xxx + r3.xyz;
  r1.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + w2.xyxy;
  r3.xy = -cb0[15].yz;
  r3.zw = -cb0[18].xy;
  r1.xyzw = r1.xyzw * float4(2,2,2,2) + r3.xyzw;
  r1.xy = r1.xy / cb0[16].xy;
  r1.zw = r1.zw / cb0[19].xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.y = dot(r1.zw, r1.zw);
  r1.xy = float2(4,4) * r1.xy;
  r1.xy = min(float2(1,1), r1.xy);
  r1.xy = float2(1,1) + -r1.xy;
  r1.xy = r1.xy * r1.xy;
  r0.y = -cb0[16].z + r0.y;
  r0.y = saturate(r0.y / cb0[19].z);
  r2.x = saturate(cb0[15].w);
  r2.y = saturate(cb0[18].z);
  r0.y = r0.y * r0.y + -1;
  r1.zw = r2.xy * r0.yy + float2(1,1);
  r1.xy = r1.xy * r1.zw;
  r3.xyzw = cb0[20].xyzw * r1.yyyy;
  r1.xyzw = cb0[17].xyzw * r1.xxxx + r3.xyzw;
  r0.xyz = r1.www + r0.xzw;
  r1.xyz = float3(1,1,1) + r1.zxy;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = cb0[9].www * r0.xyz;
  r0.yzx = lutShaper(r0.yzx);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.yzw = cb0[9].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[9].xy;
  r1.yz = r0.zw * cb0[9].xy + r1.xy;
  r1.x = r0.y * cb0[9].y + r1.y;
  r3.xyzw = t5.Sample(s5_s, r1.xz).xyzw;
  r2.z = cb0[9].y;
  r0.zw = r1.xz + r2.zw;
  r1.xyzw = t5.Sample(s5_s, r0.zw).xyzw;
  r0.x = r0.x * cb0[9].z + -r0.y;
  r0.yzw = r1.xyz + -r3.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t5, r0.yzx, cb0[9].z + 1u);
  }
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}