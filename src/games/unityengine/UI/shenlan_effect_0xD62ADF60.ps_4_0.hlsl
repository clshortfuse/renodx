#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float2 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v2.zw).xyzw;
  r0.x = r0.x * r0.w;
  r1.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r0.x = r1.x * r1.w + r0.x;
  r0.x = -1 + r0.x;
  r0.y = -cb0[9].w * 2 + r0.x;
  r0.xz = cb0[9].xy * r0.xx;
  r0.xz = r0.xz * float2(0.5,0.5) + v3.xy;
  r1.xyzw = t0.Sample(s0_s, r0.xz).xyzw;
  r0.x = saturate(1 + r0.y);
  r0.x = log2(r0.x);
  r0.y = 8 * cb0[9].z;
  r0.x = r0.y * r0.x;
  r0.x = exp2(r0.x);
  r0.x = min(1, r0.x);
  r0.y = dot(r1.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.y = r0.y * r1.w;
  r2.xyzw = -cb0[8].xyzw + cb0[7].xyzw;
  r2.xyzw = r0.yyyy * r2.xyzw + cb0[8].xyzw;
  r1.xyzw = r2.xyzw * r1.wwww;
  r1.xyzw = v1.xyzw * r1.xyzw;
  o0.w = saturate(r1.w * r0.x);
  o0.xyz = r1.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    if(injectedData.rolloffUI == 1.f){
      o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
      o0.xyz = rolloff(o0.xyz, 0.85f, true);
      o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
    } else if(injectedData.rolloffUI == 2.f){
      o0.xyz = saturate(o0.xyz);
    }
  }
  return;
}