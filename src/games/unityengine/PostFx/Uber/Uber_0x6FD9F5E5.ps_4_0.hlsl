#include "../../common.hlsl"

Texture2D<float4> t8 : register(t8);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s8_s : register(s8);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[17];
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s2_s, v1.xy).xyzw;
  r0.yz = v1.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r0.yz, r0.yz);
  r0.yz = r0.yz * r0.ww;
  r0.yz = -r0.yz * cb0[7].xx * injectedData.fxCA + v1.xy;
  r1.xy = float2(1,1) / cb1[6].xy;
  r0.yz = r1.xy * float2(2.5,2.5) + r0.yz;
  r0.yz = -v1.xy + r0.yz;
  r1.zw = cb0[2].zw * r0.yz;
  r1.zw = float2(0.5,0.5) * r1.zw;
  r0.w = dot(r1.zw, r1.zw);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r0.w = max(3, (int)r0.w);
  r0.w = min(16, (int)r0.w);
  r2.w = (int)r0.w;
  r3.xy = r0.yz / r2.ww;
  r4.x = -r3.y;
  r4.y = 1 + -v1.y;
  r3.z = v1.y;
  r0.yz = cb0[2].y < 0 ? r4.xy : r3.yz;
  r4.yw = float2(0,0);
  r5.w = 1;
  r3.w = r0.y;
  r6.xyzw = float4(0,0,0,0);
  r7.xyz = float3(0,0,0);
  r2.xyz = float3(0,0,0);
  r1.zw = v1.xy;
  r8.x = v1.x;
  r8.y = r0.z;
  r0.y = 0;
  while (true) {
    r3.z = cmp((int)r0.y >= (int)r0.w);
    if (r3.z != 0) break;
    r3.z = (int)r0.y;
    r3.z = 0.5 + r3.z;
    r4.x = r3.z / r2.w;
    r8.zw = r1.zw * cb0[3].xy + cb0[3].zw;
    r9.xyzw = t1.SampleLevel(s0_s, r8.zw, 0).xyzw;
    r10.xyzw = t2.SampleLevel(s3_s, r4.xy, 0).xyzw;
    r7.xyz = r9.zxy * r10.zxy + r7.xyz;
    r2.xyz = r10.xyz + r2.xyz;
    r1.zw = r1.zw + r3.xy;
    r8.zw = r8.xy * cb0[3].xy + cb0[3].zw;
    r9.xyzw = t3.SampleLevel(s4_s, r8.zw, 0).xyzw;
    r5.xyz = r10.xyz;
    r6.xyzw = r9.xyzw * r5.xyzw + r6.xyzw;
    r8.xy = r8.xy + r3.xw;
    r0.y = (int)r0.y + 1;
  }
  r0.yzw = r7.xyz / r2.zxy;
  r2.xyzw = r6.xyzw / r2.xyzw;
  r0.yzw = r0.yzw * r0.xxx;
  r2.xyz = r2.zxy * r0.xxx;
  r0.xyz = r0.yzw * r2.www + r2.xyz;
  r2.xyzw = float4(1,1,-1,0) * cb0[10].xyxy;
  r3.xyzw = float4(0.0009765625,0.0009765625,0.0009765625,0.0009765625) * cb1[6].xyxy;
  r1.zw = w2.xy * r3.xy;
  r5.xyzw = t4.Sample(s1_s, r1.zw).xyzw;
  r1.zw = r5.xy * float2(2,2) + float2(-1,-1);
  r6.xyzw = -w2.xyyx * r3.xyzw + float4(1,1,1.5,1.5);
  r3.xy = float2(0.660000026,0.660000026) * r6.xy;
  r7.xyzw = t4.Sample(s1_s, r3.xy).xyzw;
  r3.xy = r7.xy * float2(2,2) + float2(-1,-1);
  r3.zw = w2.xy * r3.zw + float2(0.330000013,0.330000013);
  r8.xyzw = t4.Sample(s1_s, r3.zw).xyzw;
  r3.zw = r8.yx * float2(2,2) + float2(-1,-1);
  r6.xyzw = t4.Sample(s1_s, r6.zw).xyzw;
  r4.xy = r6.yx * float2(2,2) + float2(-1,-1);
  r1.zw = r1.zw * r1.xy;
  r1.zw = r1.zw * float2(500,500) + w2.xy;
  r9.xyzw = t5.Sample(s5_s, r1.zw).xyzw;
  r1.zw = r3.xy * r1.xy;
  r1.zw = r1.zw * float2(450,450) + w2.xy;
  r10.xyzw = t5.Sample(s5_s, r1.zw).xyzw;
  r5.xyw = r10.zxy * r7.zzz;
  r5.xyz = r9.zxy * r5.zzz + r5.xyw;
  r1.zw = r3.zw * r1.xy;
  r1.zw = r1.zw * float2(400,400) + w2.xy;
  r3.xyzw = t5.Sample(s5_s, r1.zw).xyzw;
  r3.xyz = r3.zxy * r8.zzz + r5.xyz;
  r1.xy = r4.xy * r1.xy;
  r1.xy = r1.xy * float2(350,350) + w2.xy;
  r1.xyzw = t5.Sample(s5_s, r1.xy).xyzw;
  r1.xyz = r1.zxy * r6.zzz + r3.xyz;
  r3.xyzw = -r2.xywy * cb0[11].xxxx + w2.xyxy;
  r5.xyzw = t5.Sample(s5_s, r3.xy).xyzw;
  r1.xyz = r5.zxy + r1.xyz;
  r3.xyzw = t5.Sample(s5_s, r3.zw).xyzw;
  r1.xyz = r3.zxy * float3(2,2,2) + r1.xyz;
  r3.xy = -r2.zy * cb0[11].xx + w2.xy;
  r3.xyzw = t5.Sample(s5_s, r3.xy).xyzw;
  r1.xyz = r3.zxy + r1.xyz;
  r3.xyzw = r2.zwxw * cb0[11].xxxx + w2.xyxy;
  r5.xyzw = t5.Sample(s5_s, r3.xy).xyzw;
  r1.xyz = r5.zxy * float3(2,2,2) + r1.xyz;
  r5.xyzw = t5.Sample(s5_s, w2.xy).xyzw;
  r1.xyz = r5.zxy * float3(4,4,4) + r1.xyz;
  r3.xyzw = t5.Sample(s5_s, r3.zw).xyzw;
  r1.xyz = r3.zxy * float3(2,2,2) + r1.xyz;
  r3.xyzw = r2.zywy * cb0[11].xxxx + w2.xyxy;
  r5.xyzw = t5.Sample(s5_s, r3.xy).xyzw;
  r1.xyz = r5.zxy + r1.xyz;
  r3.xyzw = t5.Sample(s5_s, r3.zw).xyzw;
  r1.xyz = r3.zxy * float3(2,2,2) + r1.xyz;
  r2.xy = r2.xy * cb0[11].xx + w2.xy;
  r2.xyzw = t5.Sample(s5_s, r2.xy).xyzw;
  r1.xyz = r2.zxy + r1.xyz;
  r1.xyz = cb0[11].yyy * r1.xyz * injectedData.fxBloom;
  r2.xyz = float3(0.0625,0.0625,0.0625) * r1.xyz;
  r0.xyz = r1.xyz * float3(0.0625,0.0625,0.0625) + r0.xyz;
  r1.xyzw = t6.Sample(s6_s, v2.xy).xyzw;
  r1.xyz = cb0[11].zzz * r1.zxy * injectedData.fxLens;
  r0.xyz = r2.xyz * r1.xyz + r0.xyz;
  r1.xy = -cb0[15].xy + v1.xy;
  r1.xy = cb0[16].xx * abs(r1.xy) * min(1.f, injectedData.fxVignette);
  r0.w = cb1[6].x / cb1[6].y;
  r0.w = -1 + r0.w;
  r0.w = cb0[16].w * r0.w + 1;
  r0.w = r1.x * r0.w;
  r2.x = log2(r0.w);
  r2.y = log2(r1.y);
  r1.xy = cb0[16].zz * r2.xy;
  r1.xy = exp2(r1.xy);
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = log2(r0.w);
  r0.w = cb0[16].y * r0.w * max(1.f, injectedData.fxVignette);
  r0.w = exp2(r0.w);
  r1.xyz = float3(1,1,1) + -cb0[14].zxy;
  r1.xyz = r0.www * r1.xyz + cb0[14].zxy;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = cb0[12].www * r0.xyz;
  r0.yzx = lutShaper(r0.yzx);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.yzw = cb0[12].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[12].xy;
  r1.yz = r0.zw * cb0[12].xy + r1.xy;
  r1.x = r0.y * cb0[12].y + r1.y;
  r2.xyzw = t7.Sample(s7_s, r1.xz).xyzw;
  r4.z = cb0[12].y;
  r0.zw = r1.xz + r4.zw;
  r1.xyzw = t7.Sample(s7_s, r0.zw).xyzw;
  r0.x = r0.x * cb0[12].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t7, r0.yzx, cb0[12].z + 1u);
  }
  if (injectedData.toneMapType == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  r1.xyz = fastSrgbEncodeSafe(r0.xyz);
  r1.xyz = handleUserLUT(r0.xyz, t8, s8_s, cb0[13].xyz, 1, true);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[13].www * r1.xyz + r0.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}