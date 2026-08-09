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
  float4 cb0[42];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r0.xyz = r1.xyz * r0.xxx;
  if (cb0[40].y < 0.5) {
    r1.xy = -cb0[38].xy + v1.xy;
    r1.yz = cb0[39].xx * abs(r1.yx) * min(1.f, injectedData.fxVignette);
    r0.w = cb0[22].x / cb0[22].y;
    r0.w = -1 + r0.w;
    r0.w = cb0[39].w * r0.w + 1;
    r1.x = r1.z * r0.w;
    r1.xy = saturate(r1.xy);
    r1.xy = log2(r1.xy);
    r1.xy = cb0[39].zz * r1.xy;
    r1.xy = exp2(r1.xy);
    r0.w = dot(r1.xy, r1.xy);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[39].y * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[37].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[37].xyz;
    r1.xyz = r1.xyz * r0.xyz;
    r2.x = -1 + r1.w;
    o0.w = r0.w * r2.x + 1;
  } else {
    r2.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
    r0.w = renodx::color::srgb::DecodeSafe(r2.w);
    r2.xyz = float3(1,1,1) + -cb0[37].xyz;
    r2.xyz = r0.www * r2.xyz + cb0[37].xyz;
    r2.xyz = r0.xyz * r2.xyz + -r0.xyz;
    r1.xyz = cb0[40].xxx * r2.xyz + r0.xyz;
    r0.x = -1 + r1.w;
    o0.w = r0.w * r0.x + 1;
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r1.xyz = applyUserNoTonemap(r1.xyz);
  }
  if(injectedData.fxFilmGrainType == 0.f){
  r0.xy = w1.xy * cb0[41].xy + cb0[41].zw;
  r0.xyzw = t4.Sample(s4_s, r0.xy).xyzw;
  r0.w = renodx::color::y::from::BT709(saturate(r1.xyz));
  r0.w = sqrt(r0.w);
  r0.w = cb0[40].z * -r0.w + 1;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = cb0[40].www * r0.xyz * injectedData.fxFilmGrain;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  } else {
    r0.xyz = applyFilmGrain(r1.xyz, w1);
  }
  r1.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = saturate(r0.w * renodx::math::FLT_MAX + 0.5);
  r1.x = r1.x * 2 + -1;
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}