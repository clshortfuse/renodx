#include "../../tonemap.hlsl"

Texture2D<float4> t6 : register(t6);
Texture3D<float4> t5 : register(t5);
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
cbuffer cb0 : register(b0){
  float4 cb0[42];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-1,-1,1,1) * cb0[32].xyxy;
  r1.x = 0.5 * cb0[34].x;
  r2.xyzw = saturate(r0.xyzy * r1.xxxx + v1.xyxy);
  r0.xyzw = saturate(r0.xwzw * r1.xxxx + v1.xyxy);
  r0.xyzw = cb0[26].xxxx * r0.xyzw;
  r1.xyzw = cb0[26].xxxx * r2.xyzw;
  r2.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r1.xyzw = t3.Sample(s3_s, r1.zw).xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r2.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r0.xyzw = t3.Sample(s3_s, r0.zw).xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw * injectedData.fxBloom;
  r1.xyzw = float4(0.25,0.25,0.25,1) * r0.xyzw;
  r0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  r2.xyz = cb0[35].xyz * r1.xyz;
  r2.w = 0.25 * r1.w;
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r3.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r3.xyz = r3.xyz * r1.xxx;
  r1.xyzw = r3.xyzw + r2.xyzw;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r2.xyz = cb0[34].zzz * r2.xyz * injectedData.fxLens;
  r0.xyz = r2.xyz * r0.xyz;
  r0.w = 0;
  r0.xyzw = r1.xyzw + r0.xyzw;
  if(injectedData.fxFilmGrainType == 0.f){
  r1.x = renodx::color::y::from::BT709(saturate(r0.xyz));
  r1.x = sqrt(r1.x);
  r1.x = cb0[40].z * -r1.x + 1;
  r1.yz = w1.xy * cb0[41].xy + cb0[41].zw;
  r2.xyzw = t6.Sample(s6_s, r1.yz).xyzw;
  r1.yzw = r2.xyz * r0.xyz;
  r1.yzw = cb0[40].www * r1.yzw;
  r0.xyz = r1.yzw * r1.xxx + r0.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, w1);
  }
  r0.xyzw = cb0[36].zzzz * r0.xyzw;
  o0.w = r0.w;
  r0.xyz = lutShaper(r0.xyz);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.xyz = cb0[36].yyy * r0.xyz;
  r0.w = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r0.www;
  r0.xyzw = t5.Sample(s5_s, r0.xyz).xyzw;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t5, r0.xyz, 1 / cb0[36].x);
  }
  r1.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = 1 + -abs(r0.w);
  r0.w = saturate(r0.w * renodx::math::FLT_MAX + 0.5);
  r0.w = r0.w * 2 + -1;
  r1.x = sqrt(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}