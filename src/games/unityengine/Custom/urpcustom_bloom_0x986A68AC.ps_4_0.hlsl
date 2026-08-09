#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[114];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float2 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = cb0[108].xyx * float3(-1,-1,1) + v3.xyx;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
    r0.xyz = InvertToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyz = cb0[108].xyx * float3(-1,1,1) + v3.xyx;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r2.xyz = InvertToneMapScale(r2.xyz, injectedData.gammaSpace != 0.f);
    r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
    r2.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r2.xyz) : r2.xyz;
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r0.xyzw = float4(0.25,0.25,0.25,0.25) * r0.xyzw;
  r1.x = max(r0.x, r0.y);
  r1.x = max(r1.x, r0.z);
  r1.y = -cb0[111].y + r1.x;
  r1.y = max(0, r1.y);
  r1.y = min(cb0[111].z, r1.y);
  r1.z = cb0[111].w * r1.y;
  r1.y = r1.z * r1.y;
  r2.xyzw = t1.Sample(s1_s, v3.xy).xyzw;
  r1.z = cb0[113].z * r2.x;
  r1.w = -r1.z * 1.5 + cb0[111].x;
  r1.z = saturate(r1.z);
  r1.w = r1.x + -r1.w;
  r1.x = max(9.99999975e-05, r1.x);
  r1.y = max(r1.y, r1.w);
  r1.x = r1.y / r1.x;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r2.xyzw = float4(-1,-1,-1,-1) + cb0[112].xyzw;
  r1.xyzw = r1.zzzz * r2.xyzw + float4(1,1,1,1);
  o0.xyzw = r1.xyzw * r0.xyzw;
  return;
}