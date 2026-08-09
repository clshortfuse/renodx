#include "../../tonemap.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[16];
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

  r0.xyzw = float4(1,1,-1,0) * cb0[7].xyxy;
  r1.xyzw = -r0.xywy * cb0[8].xxxx + w2.xyxy;
  r2.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  r1.xyz = r1.xyz * float3(2,2,2) + r2.xyz;
  r2.xy = -r0.zy * cb0[8].xx + w2.xy;
  r2.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r2.xyzw = r0.zwxw * cb0[8].xxxx + w2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r2.xyzw = t2.Sample(s2_s, r2.zw).xyzw;
  r1.xyz = r3.xyz * float3(2,2,2) + r1.xyz;
  r3.xyzw = t2.Sample(s2_s, w2.xy).xyzw;
  r1.xyz = r3.xyz * float3(4,4,4) + r1.xyz;
  r1.xyz = r2.xyz * float3(2,2,2) + r1.xyz;
  r2.xyzw = r0.zywy * cb0[8].xxxx + w2.xyxy;
  r0.xy = r0.xy * cb0[8].xx + w2.xy;
  r0.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r3.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r2.xyzw = t2.Sample(s2_s, r2.zw).xyzw;
  r1.xyz = r3.xyz + r1.xyz;
  r1.xyz = r2.xyz * float3(2,2,2) + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = cb0[8].yyy * r0.xyz * injectedData.fxBloom;
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r1.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  r2.xyzw = t1.Sample(s1_s, w2.xy).xyzw;
  r1.xyz = r1.xyz * r2.www + r2.xyz;
  r0.xyz = r0.xyz * float3(0.0625,0.0625,0.0625) + r1.xyz;
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
  r1.xyz = float3(1,1,1) + -cb0[13].xyz;
  r1.xyz = r0.www * r1.xyz + cb0[13].xyz;
  r0.xyz = r1.xyz * r0.xyz;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if(injectedData.fxFilmGrainType == 0.f){
  r1.xy = v1.xy * cb0[12].xy + cb0[12].zw;
  r1.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r1.xyz = r1.xyz * r0.xyz;
  r1.xyz = cb0[11].yyy * r1.xyz * injectedData.fxFilmGrain;
  r0.w = renodx::color::y::from::BT709(saturate(r0.xyz));
  r0.w = sqrt(r0.w);
  r0.w = cb0[11].x * -r0.w + 1;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, w1);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}