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
  float4 cb0[22];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.z = dot(r0.xy, r0.xy);
  r0.z = rsqrt(r0.z);
  r0.zw = r0.xy * r0.zz;
  r1.xyzw = cb0[17].wwzz * r0.xyxy * min(1.f, injectedData.fxVignette);
  r0.x = dot(r1.xy, r1.xy);
  r0.y = dot(r1.zw, r1.zw);
  r0.xy = float2(1,1) + -r0.xy;
  r0.xy = max(float2(0,0), r0.xy);
  r0.y = r0.y * r0.y + -1;
  r0.y = cb0[17].y * r0.y * max(1.f, injectedData.fxVignette) + 1;
  r0.x = -r0.x * r0.x + 1;
  r0.x = cb0[3].z * r0.x;
  r0.xz = r0.zw * r0.xx;
  r1.xy = cb0[18].ww * r0.xz * injectedData.fxCA;
  r0.xz = r0.xz * cb0[18].ww * injectedData.fxCA + v1.xy;
  r2.xyzw = t0.SampleLevel(s1_s, r0.xz, 0).xyzw;
  r3.xyzw = r1.xyxy * float4(0.2,0.2,0.4,0.4) + v1.xyxy;
  r1.xyzw = r1.xyxy * float4(0.6,0.6,0.8,0.8) + v1.xyxy;
  r4.xyzw = t0.SampleLevel(s1_s, r3.zw, 0).xyzw;
  r3.xyzw = t0.SampleLevel(s1_s, r3.xy, 0).xyzw;
  r0.xzw = float3(0.5,0.5,0) * r4.xyz;
  r0.xzw = r3.xyz * float3(1,0,0) + r0.xzw;
  r3.xyzw = t0.SampleLevel(s1_s, r1.xy, 0).xyzw;
  r1.xyzw = t0.SampleLevel(s1_s, r1.zw, 0).xyzw;
  r0.xzw = r3.xyz * float3(0,1,0) + r0.xzw;
  r0.xzw = r1.xyz * float3(0,0.5,0.5) + r0.xzw;
  r0.xzw = r2.xyz * float3(0,0,1) + r0.xzw;
  r0.xzw = float3(2.0 / 3.0, 0.5, 2.0 / 3.0) * r0.xzw;
  r1.xyzw = t1.SampleLevel(s2_s, v1.xy, 0).xyzw;
  r1.xyz = cb0[15].zzz * r1.xyz * max(0.1f, injectedData.fxBloom);
  r1.xyz = cb0[15].yyy * r1.xyz;
  r1.w = max(r1.y, r1.z);
  r1.w = max(r1.x, r1.w);
  r2.x = -cb0[21].z + r1.w;
  r2.x = max(0.01, r2.x);
  r1.w = r1.w / r2.x;
  r1.xyz = r1.xyz * r1.www + -r0.xzw;
  r1.w = cb0[15].x + -r1.w;
  r1.w = saturate(1 + r1.w);
  r0.xzw = r1.www * r1.xyz + r0.xzw;
  r1.xy = v1.xy * cb0[20].zz + cb0[20].ww;
  r1.xy = float2(-0.5,-0.5) + r1.xy;
  r1.z = cb0[20].y * r1.y;
  r1.z = cb0[20].x * r1.x + -r1.z;
  r1.x = dot(cb0[20].yx, r1.xy);
  r1.y = 0.5 + r1.x;
  r1.x = 0.5 + r1.z;
  r1.xyzw = t2.SampleLevel(s4_s, r1.xy, 0).xyzw;
  r2.xyzw = t3.SampleLevel(s3_s, v1.xy, 0).xyzw;
  r1.xyz = r2.xyz * r1.xyz;
  r1.w = max(r1.y, r1.z);
  r1.w = max(r1.x, r1.w);
  r1.w = 9.99999975e-05 + r1.w;
  r2.x = -cb0[21].x + r1.w;
  r2.x = max(0, r2.x);
  r1.w = r2.x / r1.w;
  r0.xzw = r1.xyz * r1.www + r0.xzw;
  r1.xyz = cb0[18].xyz * r0.xzw;
  r0.xzw = -cb0[18].xyz * r0.xzw + r0.xzw;
  r0.xyz = r0.yyy * r0.xzw + r1.xyz;
  if(injectedData.fxFilmGrainType == 0.f){
  r0.w = v1.y * 541.169983 + v1.x;
  r0.w = cb0[19].x + r0.w;
  r0.w = sin(r0.w);
  r0.w = r0.w * 273351.5 + cb0[19].x;
  r0.w = frac(r0.w);
  r0.w = r0.w * 2 + -1;
  r0.w = cb0[17].x * r0.w * injectedData.fxFilmGrain;
  r0.xyz = r0.www * r0.xyz + r0.xyz;
  } else {
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = applyFilmGrain(r0.xyz, v1);
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  r1.xyzw = t4.SampleLevel(s0_s, float2(0.5,0.5), 0).xyzw;
  o0.xyz = r1.xxx * r0.xyz;
  o0.w = 1;
  if(injectedData.toneMapType == 0.f){
    o0.xyz = saturate(o0.xyz);
  }
  if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
  o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
  o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}