#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[13];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float4 v3 : TEXCOORD4,
  float2 v4 : TEXCOORD5,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.x = cb1[7].x * r0.x + cb1[7].y;
  r0.x = 1 / r0.x;
  r0.x = -0.99 + r0.x;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r0.y = cb1[7].x * r1.x + cb1[7].y;
  r0.y = 1 / r0.y;
  r0.y = -0.99 + r0.y;
  r0.xy = saturate(float2(100,100) * r0.xy);
  r0.x = r0.y * 2 + r0.x;
  r1.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r0.y = cb1[7].x * r1.x + cb1[7].y;
  r0.y = 1 / r0.y;
  r0.y = -0.99 + r0.y;
  r0.y = saturate(100 * r0.y);
  r0.x = r0.x + r0.y;
  r0.y = dot(v3.xyz, v3.xyz);
  r0.y = rsqrt(r0.y);
  r0.yzw = v3.xyz * r0.yyy;
  r0.y = dot(r0.yzw, cb0[12].xyz);
  r0.y = saturate(-r0.y);
  r0.y = -0.8 + r0.y;
  r0.xy = float2(0.25,5.0) * r0.xy;
  r0.y = max(0, r0.y);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.z * r0.y;
  r0.x = r0.y * r0.x;
  r0.yz = float2(1,1) + -abs(v4.xy);
  r0.yz = saturate(float2(3,4) * r0.yz);
  r0.x = r0.x * r0.y;
  o0.w = r0.x * r0.z;
  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if(injectedData.isClamped != 0.f){
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = rolloffSdr(r0.xyz);
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  if(injectedData.isClamped != 0.f){
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r1.xyz = rolloffSdr(r1.xyz);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  if(injectedData.isClamped != 0.f){
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r1.xyz = rolloffSdr(r1.xyz);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, w2.xy).xyzw;
  if(injectedData.isClamped != 0.f){
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r1.xyz = rolloffSdr(r1.xyz);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  r0.xyz = saturate(r0.xyz * float3(0.25,0.25,0.25) + -cb0[5].zzz);
  r1.xyz = saturate(r1.xyz);
  r1.xyz = r1.xyz * r1.xyz;
  o0.xyz = r1.xyz * cb0[5].www + r0.xyz;
  return;
}