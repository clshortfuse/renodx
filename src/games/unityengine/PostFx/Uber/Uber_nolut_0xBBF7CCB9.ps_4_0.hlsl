#include "../../tonemap.hlsl"

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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
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
  r1.w = (int)r0.z;
  r2.xy = -r0.xy / r1.ww;
  r3.x = -r2.y;
  r3.y = 1 + -v1.y;
  r2.z = v1.y;
  r0.xy = cb0[2].y < 0 ? r3.xy : r2.yz;
  r3.yw = float2(0,0);
  r4.w = 1;
  r2.w = r0.x;
  r5.xyzw = float4(0,0,0,0);
  r6.xyz = float3(0,0,0);
  r1.xyz = float3(0,0,0);
  r0.xw = v1.xy;
  r7.x = v1.x;
  r7.y = r0.y;
  r2.z = 0;
  while (true) {
    r6.w = cmp((int)r2.z >= (int)r0.z);
    if (r6.w != 0) break;
    r6.w = (int)r2.z;
    r6.w = 0.5 + r6.w;
    r3.x = r6.w / r1.w;
    r7.zw = r0.xw * cb0[3].xy + cb0[3].zw;
    r8.xyzw = t0.SampleLevel(s0_s, r7.zw, 0).xyzw;
    r9.xyzw = t1.SampleLevel(s1_s, r3.xy, 0).xyzw;
    r6.xyz = r8.xyz * r9.xyz + r6.xyz;
    r1.xyz = r9.xyz + r1.xyz;
    r0.xw = r0.xw + r2.xy;
    r7.zw = r7.xy * cb0[3].xy + cb0[3].zw;
    r8.xyzw = t2.SampleLevel(s2_s, r7.zw, 0).xyzw;
    r4.xyz = r9.xyz;
    r5.xyzw = r8.xyzw * r4.xyzw + r5.xyzw;
    r7.xy = r7.xy + r2.xw;
    r2.z = (int)r2.z + 1;
  }
  r0.xyz = r6.xyz / r1.xyz;
  r1.xyzw = r5.xyzw / r1.xyzw;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r0.xyz = r0.xyz * r1.www + r1.xyz;
  r1.xyzw = float4(1,1,-1,0) * cb0[7].xyxy;
  r2.xyzw = -r1.xywy * cb0[8].xxxx + w2.xyxy;
  r4.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.xyz = r2.xyz * float3(2,2,2) + r4.xyz;
  r3.xy = -r1.zy * cb0[8].xx + w2.xy;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyz = r4.xyz + r2.xyz;
  r4.xyzw = r1.zwxw * cb0[8].xxxx + w2.xyxy;
  r5.xyzw = t3.Sample(s3_s, r4.xy).xyzw;
  r2.xyz = r5.xyz * float3(2,2,2) + r2.xyz;
  r5.xyzw = t3.Sample(s3_s, w2.xy).xyzw;
  r2.xyz = r5.xyz * float3(4,4,4) + r2.xyz;
  r4.xyzw = t3.Sample(s3_s, r4.zw).xyzw;
  r2.xyz = r4.xyz * float3(2,2,2) + r2.xyz;
  r4.xyzw = r1.zywy * cb0[8].xxxx + w2.xyxy;
  r5.xyzw = t3.Sample(s3_s, r4.xy).xyzw;
  r2.xyz = r5.xyz + r2.xyz;
  r4.xyzw = t3.Sample(s3_s, r4.zw).xyzw;
  r2.xyz = r4.xyz * float3(2,2,2) + r2.xyz;
  r1.xy = r1.xy * cb0[8].xx + w2.xy;
  r1.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = cb0[8].yyy * r1.xyz * injectedData.fxBloom;
  r0.xyz = r1.xyz * float3(0.0625,0.0625,0.0625) + r0.xyz;
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
  if(injectedData.fxFilmGrainType == 0.f){
  r1.xy = v1.xy * cb0[12].xy + cb0[12].zw;
  r1.xyzw = t4.Sample(s5_s, r1.xy).xyzw;
  r0.w = renodx::color::y::from::BT709(saturate(r0.xyz));
  r0.w = sqrt(r0.w);
  r0.w = cb0[11].x * -r0.w + 1;
  r1.xyz = r1.xyz * r0.xyz;
  r1.xyz = cb0[11].yyy * r1.xyz * injectedData.fxFilmGrain;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, w1);
  }
  r2.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r1.xyz = handleUserLUT(r0.xyz, t5, s4_s, cb0[10].xyz);
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