#include "../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s3_s, v1.xy).xyzw;
  r0.x = r0.x + r0.y;
  r0.x = r0.x + r0.z;
  r0.x = 0.333 * r0.x;
  r0.x = dot(r0.xx, cb0[5].xx);
  r0.x = min(1, r0.x);
  r1.xyzw = t3.Sample(s2_s, v2.xy).xyzw;
  r0.yzw = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.xyzw = t2.Sample(s1_s, w1.xy).xyzw;
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = r2.w;
  if(injectedData.fxFilmGrainType == 0.f){
  r1.xyz = r1.xyz * cb0[4].xxx * injectedData.fxFilmGrain + r2.xyz;
  } else {
    r2.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r2.xyz) : r2.xyz;
    r1.xyz = applyFilmGrain(r2.xyz, v1);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.yzw = r0.yzw * cb0[4].yyy + r1.xyz;
  r1.xyz = cb0[6].xyz + -r0.yzw;
  o0.xyz = r0.xxx * r1.xyz + r0.yzw;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}