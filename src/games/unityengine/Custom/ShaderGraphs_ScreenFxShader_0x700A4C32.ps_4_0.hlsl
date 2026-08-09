#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[5];
}
cbuffer cb0 : register(b0){
  float4 cb0[130];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : INTERP0,
  float4 v2 : INTERP1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 15 * cb0[129].x;
  r0.x = round(r0.x);
  r0.x = dot(r0.xx, float2(12.9898005,78.2330017));
  r0.x = sin(r0.x);
  r0.x = 43758.5469 * r0.x;
  r0.z = cb0[129].x * 15 + 100;
  r0.z = round(r0.z);
  r0.z = dot(r0.zz, float2(12.9898005,78.2330017));
  r0.z = sin(r0.z);
  r0.z = 43758.5469 * r0.z;
  r0.xy = frac(r0.xz);
  r0.zw = float2(1,1) / cb1[1].zw;
  r0.xy = r0.xy / r0.zw;
  r0.xy = round(r0.xy);
  r0.xy = r0.xy * r0.zw;
  r0.xy = v1.xy * float2(3.74999928,2.109375) + r0.xy;
  r0.xyzw = t1.SampleBias(s1_s, r0.xy, cb0[5].x).xyzw;
  r1.xyz = cmp(r0.xyz < float3(0.5,0.5,0.5));
  r2.xy = cb0[128].ww / cb1[4].xy;
  r2.w = -r2.x;
  r2.z = 0;
  r3.xy = v1.xy + r2.wz;
  r3.xyzw = t0.SampleBias(s0_s, r3.xy, cb0[5].x).xyzw;
  if (injectedData.countOld < injectedData.countNew) {
    r3.xyz = InvertToneMapScale(r3.xyz, injectedData.gammaSpace != 0.f);
    r3.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r3.xyz) : r3.xyz;
  }
  r4.xy = r2.zy * float2(1,-1) + v1.xy;
  r2.xyzw = v1.xyxy + r2.xzzy;
  r4.xyzw = t0.SampleBias(s0_s, r4.xy, cb0[5].x).xyzw;
  if (injectedData.countOld < injectedData.countNew) {
    r4.xyz = InvertToneMapScale(r4.xyz, injectedData.gammaSpace != 0.f);
    r4.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r4.xyz) : r4.xyz;
  }
  r3.xyz = r4.xyz + r3.xyz;
  r4.xyzw = t0.SampleBias(s0_s, r2.xy, cb0[5].x).xyzw;
  if (injectedData.countOld < injectedData.countNew) {
    r4.xyz = InvertToneMapScale(r4.xyz, injectedData.gammaSpace != 0.f);
    r4.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r4.xyz) : r4.xyz;
  }
  r2.xyzw = t0.SampleBias(s0_s, r2.zw, cb0[5].x).xyzw;
  if (injectedData.countOld < injectedData.countNew) {
    r2.xyz = InvertToneMapScale(r2.xyz, injectedData.gammaSpace != 0.f);
    r2.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r2.xyz) : r2.xyz;
  }
  r2.xyz = r4.xyz + r2.xyz;
  r2.xyz = r2.xyz + r3.xyz;
  r3.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  if (injectedData.countOld < injectedData.countNew) {
    r3.xyz = InvertToneMapScale(r3.xyz, injectedData.gammaSpace != 0.f);
    r3.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r3.xyz) : r3.xyz;
  }
  r2.xyz = r2.xyz * float3(0.25,0.25,0.25) + -r3.xyz;
  r2.xyz = cb0[128].xxx * r2.xyz + r3.xyz;
  r3.xyz = r0.xyz * float3(2,2,2) + r2.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * float3(2,2,2) + r2.xyz;
  r0.xyz = min(float3(1,1,1), r0.xyz);
  r3.xyz = float3(-1,-1,-1) + r3.xyz;
  r3.xyz = max(float3(0,0,0), r3.xyz);
  r0.xyz = r1.xyz ? r3.xyz : r0.xyz;
  r0.xyz = r0.xyz + -r2.xyz;
  r0.xyz = cb0[128].zzz * r0.xyz + r2.xyz;
  r1.xy = cb1[4].xy * cb1[2].xx;
  r1.xy = r1.xy / cb1[2].yz;
  r1.xy = v1.xy * r1.xy;
  r1.xyzw = t2.SampleBias(s2_s, r1.xy, cb0[5].x).xyzw;
  r1.xyz = r0.xyz * float3(2,2,2) + r1.xyz;
  r1.xyz = float3(-1,-1,-1) + r1.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[128].yyy * r1.xyz + r0.xyz;
  o0.xyz = cb0[129].zzz * r0.xyz;
  if (injectedData.countOld <= injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  o0.w = 1;
  return;
}