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
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.SampleLevel(s2_s, v1.xy, 0).xyzw;
  r0.xyz = cb0[15].zzz * r0.xyz * min(0.1f, injectedData.fxBloom);
  r0.xyz = cb0[15].yyy * r0.xyz;
  r0.w = max(r0.y, r0.z);
  r0.w = max(r0.x, r0.w);
  r1.x = -cb0[21].z + r0.w;
  r1.x = max(0.01, r1.x);
  r0.w = r0.w / r1.x;
  r1.x = cb0[15].x + -r0.w;
  r1.x = saturate(1 + r1.x);
  r2.xyzw = t0.SampleLevel(s1_s, v1.xy, 0).xyzw;
  r0.xyz = r0.xyz * r0.www + -r2.xyz;
  r0.xyz = r1.xxx * r0.xyz + r2.xyz;
  r1.xy = v1.xy * cb0[20].zz + cb0[20].ww;
  r1.xy = float2(-0.5,-0.5) + r1.xy;
  r0.w = cb0[20].y * r1.y;
  r0.w = cb0[20].x * r1.x + -r0.w;
  r1.x = dot(cb0[20].yx, r1.xy);
  r1.y = 0.5 + r1.x;
  r1.x = 0.5 + r0.w;
  r1.xyzw = t2.SampleLevel(s4_s, r1.xy, 0).xyzw;
  r2.xyzw = t3.SampleLevel(s3_s, v1.xy, 0).xyzw;
  r1.xyz = r2.xyz * r1.xyz;
  r0.w = max(r1.y, r1.z);
  r0.w = max(r1.x, r0.w);
  r0.w = 9.99999975e-05 + r0.w;
  r1.w = -cb0[21].x + r0.w;
  r1.w = max(0, r1.w);
  r0.w = r1.w / r0.w;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  r1.xyz = cb0[18].xyz * r0.xyz;
  r0.xyz = -cb0[18].xyz * r0.xyz + r0.xyz;
  r2.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r2.xy = cb0[17].zz * r2.xy * min(1.f, injectedData.fxVignette);
  r0.w = dot(r2.xy, r2.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = r0.w * r0.w + -1;
  r0.w = cb0[17].y * r0.w * max(1.f, injectedData.fxVignette) + 1;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  if(injectedData.fxFilmGrainType == 0.f){
  r0.w = v1.y * 541.169983 + v1.x;
  r0.w = cb0[19].x + r0.w;
  r0.w = sin(r0.w);
  r0.w = r0.w * 273351.5 + cb0[19].x;
  r0.w = frac(r0.w);
  r0.w = r0.w * 2 + -1;
  r0.w = cb0[17].x * r0.w;
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