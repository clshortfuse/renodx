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
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[17];
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
  r2.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  r1.xyz = r1.zxy * float3(2,2,2) + r2.zxy;
  r2.xy = -r0.zy * cb0[11].xx + w2.xy;
  r2.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r1.xyz = r2.zxy + r1.xyz;
  r2.xyzw = r0.zwxw * cb0[11].xxxx + w2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r2.xyzw = t2.Sample(s2_s, r2.zw).xyzw;
  r1.xyz = r3.zxy * float3(2,2,2) + r1.xyz;
  r3.xyzw = t2.Sample(s2_s, w2.xy).xyzw;
  r1.xyz = r3.zxy * float3(4,4,4) + r1.xyz;
  r1.xyz = r2.zxy * float3(2,2,2) + r1.xyz;
  r2.xyzw = r0.zywy * cb0[11].xxxx + w2.xyxy;
  r0.xy = r0.xy * cb0[11].xx + w2.xy;
  r0.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r3.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r2.xyzw = t2.Sample(s2_s, r2.zw).xyzw;
  r1.xyz = r3.zxy + r1.xyz;
  r1.xyz = r2.zxy * float3(2,2,2) + r1.xyz;
  r0.xyz = r1.xyz + r0.zxy;
  r0.xyz = cb0[11].yyy * r0.xyz * injectedData.fxBloom;
  r0.xyz = float3(0.0625,0.0625,0.0625) * r0.xyz;
  r1.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r2.xyzw = t1.Sample(s0_s, w1.xy).xyzw;
  r0.xyz = r2.zxy * r1.xxx + r0.xyz;
  r0.w = cb1[6].x / cb1[6].y;
  r0.w = -1 + r0.w;
  r0.w = cb0[16].w * r0.w + 1;
  r1.xy = -cb0[15].xy + v1.xy;
  r1.xy = cb0[16].xx * abs(r1.xy) * min(1.f, injectedData.fxVignette);
  r0.w = r1.x * r0.w;
  r1.y = log2(r1.y);
  r1.x = log2(r0.w);
  r1.xy = cb0[16].zz * r1.xy;
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
  r0.x = r0.x * cb0[12].z + -r0.y;
  r1.xy = float2(0.5,0.5) * cb0[12].xy;
  r1.yz = r0.zw * cb0[12].xy + r1.xy;
  r1.x = r0.y * cb0[12].y + r1.y;
  r2.x = cb0[12].y;
  r2.yw = float2(0,0);
  r0.yz = r2.xy + r1.xz;
  r1.xyzw = t3.Sample(s3_s, r1.xz).xyzw;
  r3.xyzw = t3.Sample(s3_s, r0.yz).xyzw;
  r0.yzw = r3.xyz + -r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t3, r0.yzx, cb0[12].z + 1u);
  }
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r1.xyz = handleUserLUT(r0.xyz, t4, s4_s, cb0[13].xyz, 1, true);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[13].www * r1.xyz + r0.xyz;
  if (injectedData.countOld == injectedData.countNew) {
  r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}