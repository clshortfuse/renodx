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
    r2.xyz = r5.xyz * r6.xyz + r2.xyz;
    r3.xyz = r6.xyz + r3.xyz;
    r4.xy = r4.xy + r0.xy;
    r2.w = (int)r2.w + 1;
  }
  r0.xyz = r2.xyz / r3.xyz;
  r2.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r3.xyzw = float4(1,1,-1,0) * cb0[7].xyxy;
  r4.xyzw = -r3.xywy * cb0[8].xxxx + w2.xyxy;
  r5.xyzw = t2.Sample(s2_s, r4.xy).xyzw;
  r4.xyzw = t2.Sample(s2_s, r4.zw).xyzw;
  r4.xyz = r4.xyz * float3(2,2,2) + r5.xyz;
  r1.xy = -r3.zy * cb0[8].xx + w2.xy;
  r5.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r4.xyz = r5.xyz + r4.xyz;
  r5.xyzw = r3.zwxw * cb0[8].xxxx + w2.xyxy;
  r6.xyzw = t2.Sample(s2_s, r5.xy).xyzw;
  r4.xyz = r6.xyz * float3(2,2,2) + r4.xyz;
  r6.xyzw = t2.Sample(s2_s, w2.xy).xyzw;
  r4.xyz = r6.xyz * float3(4,4,4) + r4.xyz;
  r5.xyzw = t2.Sample(s2_s, r5.zw).xyzw;
  r4.xyz = r5.xyz * float3(2,2,2) + r4.xyz;
  r5.xyzw = r3.zywy * cb0[8].xxxx + w2.xyxy;
  r6.xyzw = t2.Sample(s2_s, r5.xy).xyzw;
  r4.xyz = r6.xyz + r4.xyz;
  r5.xyzw = t2.Sample(s2_s, r5.zw).xyzw;
  r4.xyz = r5.xyz * float3(2,2,2) + r4.xyz;
  r1.xy = r3.xy * cb0[8].xx + w2.xy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r3.xyz = r4.xyz + r3.xyz;
  r3.xyz = cb0[8].yyy * r3.xyz * injectedData.fxBloom;
  r3.xyz = float3(0.0625,0.0625,0.0625) * r3.xyz;
  r0.xyz = r2.xyz + r3.xyz;
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
  r2.xyz = float3(1,1,1) + -cb0[13].xyz;
  r2.xyz = r0.www * r2.xyz + cb0[13].xyz;
  r0.xyz = r2.xyz * r0.xyz;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  if(injectedData.fxFilmGrainType == 0.f){
  r1.xy = v1.xy * cb0[12].xy + cb0[12].zw;
  r2.xyzw = t3.Sample(s4_s, r1.xy).xyzw;
  r0.w = renodx::color::y::from::BT709(saturate(r0.xyz));
  r0.w = sqrt(r0.w);
  r0.w = cb0[11].x * -r0.w + 1;
  r2.xyz = r2.xyz * r0.xyz;
  r2.xyz = cb0[11].yyy * r2.xyz * injectedData.fxFilmGrain;
  r0.xyz = r2.xyz * r0.www + r0.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, w1);
  }
  r2.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r1.xyz = handleUserLUT(r0.xyz, t4, s3_s, cb0[10].xyz);
  r1.xyz = r1.xyz + -r2.xyz;
  r0.xyz = cb0[10].www * r1.xyz + r2.xyz;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
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