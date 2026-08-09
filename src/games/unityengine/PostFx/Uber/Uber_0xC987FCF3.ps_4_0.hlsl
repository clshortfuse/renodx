#include "../../common.hlsl"

Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s6_s : register(s6);
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
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(1,1,-1,0) * cb0[7].xyxy;
  r1.xyzw = -r0.xywy * cb0[8].xxxx + w2.xyxy;
  r2.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r1.xyzw = t3.Sample(s3_s, r1.zw).xyzw;
  r1.xyz = r1.zxy * float3(2,2,2) + r2.zxy;
  r2.xy = -r0.zy * cb0[8].xx + w2.xy;
  r2.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r1.xyz = r2.zxy + r1.xyz;
  r2.xyzw = r0.zwxw * cb0[8].xxxx + w2.xyxy;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r1.xyz = r3.zxy * float3(2,2,2) + r1.xyz;
  r3.xyzw = t3.Sample(s3_s, w2.xy).xyzw;
  r1.xyz = r3.zxy * float3(4,4,4) + r1.xyz;
  r1.xyz = r2.zxy * float3(2,2,2) + r1.xyz;
  r2.xyzw = r0.zywy * cb0[8].xxxx + w2.xyxy;
  r0.xy = r0.xy * cb0[8].xx + w2.xy;
  r0.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r1.xyz = r3.zxy + r1.xyz;
  r1.xyz = r2.zxy * float3(2,2,2) + r1.xyz;
  r0.xyz = r1.xyz + r0.zxy;
  r0.xyz = cb0[8].yyy * r0.xyz * injectedData.fxBloom;
  r0.xyz = float3(0.0625,0.0625,0.0625) * r0.xyz;
  r1.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r2.xyzw = t2.Sample(s0_s, w1.xy).xyzw;
  r0.xyz = r2.zxy * r1.xxx + r0.xyz;
  r1.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + w2.xyxy;
  r2.xy = -cb0[15].yz;
  r2.zw = -cb0[18].xy;
  r1.xyzw = r1.xyzw * float4(2,2,2,2) + r2.xyzw;
  r1.xy = r1.xy / cb0[16].xy;
  r1.zw = r1.zw / cb0[19].xy;
  r2.y = dot(r1.zw, r1.zw);
  r2.x = dot(r1.xy, r1.xy);
  r1.xy = float2(4,4) * r2.xy;
  r1.xy = min(float2(1,1), r1.xy);
  r1.xy = float2(1,1) + -r1.xy;
  r1.xy = r1.xy * r1.xy;
  r2.xyzw = t1.Sample(s2_s, w2.xy).xyzw;
  r0.w = cb1[7].x * r2.x + cb1[7].y;
  r0.w = 1 / r0.w;
  r1.z = -cb0[16].z + r0.w;
  r0.w = -cb0[11].x + r0.w;
  r0.w = saturate(r0.w / cb0[11].y);
  r0.w = 1 + -r0.w;
  r1.z = saturate(r1.z / cb0[19].z);
  r1.z = r1.z * r1.z + -1;
  r2.x = saturate(cb0[15].w);
  r2.y = saturate(cb0[18].z);
  r1.zw = r2.xy * r1.zz + float2(1,1);
  r1.xy = r1.xy * r1.zw;
  r2.xyzw = cb0[20].xyzw * r1.yyyy;
  r1.xyzw = cb0[17].xyzw * r1.xxxx + r2.xyzw;
  r0.xyz = r1.www + r0.xyz;
  r1.xyz = float3(1,1,1) + r1.zxy;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = cb0[9].www * r0.xyz;
  r0.yzx = lutShaper(r0.yzx);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r1.xyz = cb0[9].zzz * r0.xyz;
  r0.y = floor(r1.x);
  r0.x = r0.x * cb0[9].z + -r0.y;
  r1.xw = float2(0.5,0.5) * cb0[9].xy;
  r1.yz = r1.yz * cb0[9].xy + r1.xw;
  r1.x = r0.y * cb0[9].y + r1.y;
  r2.x = cb0[9].y;
  r2.yw = float2(0,0);
  r0.yz = r2.xy + r1.xz;
  r1.xyzw = t4.Sample(s4_s, r1.xz).xyzw;
  r3.xyzw = t4.Sample(s4_s, r0.yz).xyzw;
  r3.xyz = r3.xyz + -r1.xyz;
  r0.xyz = r0.xxx * r3.xyz + r1.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t4, r0.yzx, cb0[9].z + 1u);
  }
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  /*r1.xyz = log2(r0.zxy);
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r1.yzw = cb0[10].zzz * r1.xyz;
  r1.y = floor(r1.y);
  r1.x = r1.x * cb0[10].z + -r1.y;
  r2.xy = float2(0.5,0.5) * cb0[10].xy;
  r3.yz = r1.zw * cb0[10].xy + r2.xy;
  r3.x = r1.y * cb0[10].y + r3.y;
  r2.z = cb0[10].y;
  r1.yz = r3.xz + r2.zw;
  r2.xyzw = t6.Sample(s6_s, r1.yz).xyzw;
  r4.xyzw = t5.Sample(s5_s, r1.yz).xyzw;
  r5.xyzw = t6.Sample(s6_s, r3.xz).xyzw;
  r3.xyzw = t5.Sample(s5_s, r3.xz).xyzw;
  r1.yzw = -r5.xyz + r2.xyz;
  r1.yzw = r1.xxx * r1.yzw + r5.xyz;*/
  r1.yzw = handleUserLUT(r0.xyz, t6, s6_s, cb0[10].xyz, 1);
  /*r2.xyz = r4.xyz + -r3.xyz;
  r2.xyz = r1.xxx * r2.xyz + r3.xyz;*/
  r2.xyz = handleUserLUT(r0.xyz, t5, s5_s, cb0[10].xyz, 1);
  r1.xyz = -r2.xyz + r1.yzw;
  r1.xyz = cb0[11].zzz * r1.xyz;
  r1.xyz = r0.www * r1.xyz + r2.xyz;
  r1.xyz = fastSrgbDecodeSafe(r1.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[10].www * r1.xyz + r0.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}