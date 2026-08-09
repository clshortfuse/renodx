#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = -cb0[2].xyxy * float4(0.5,0.5,-0.5,0.5) + v1.xyxy;
  r1.xyz = t0.Sample(s0_s, r0.zw).xyz;
  if(injectedData.isClamped != 0.f){
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r1.xyz = rolloffSdr(r1.xyz);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;
  if(injectedData.isClamped != 0.f){
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = rolloffSdr(r0.xyz);
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  r0.w = max(r1.y, r1.z);
  r0.w = max(r1.x, r0.w);
  r0.w = 1 + r0.w;
  r2.xyzw = -cb0[2].xyxy * float4(0.5,0.5,-0.5,0.5) + w1.xyxy;
  r1.w = t1.Sample(s1_s, r2.zw).x;
  r2.x = t1.Sample(s1_s, r2.xy).x;
  r2.x = r2.x * 2 + -1;
  r1.w = r1.w * 2 + -1;
  r0.w = abs(r1.w) / r0.w;
  r1.xyz = r1.xyz * r0.www;
  r2.y = max(r0.y, r0.z);
  r2.y = max(r2.y, r0.x);
  r2.y = 1 + r2.y;
  r2.y = abs(r2.x) / r2.y;
  r0.xyz = r0.xyz * r2.yyy + r1.xyz;
  r0.w = r2.y + r0.w;
  r3.xyzw = cb0[2].xyxy * float4(-0.5,0.5,0.5,0.5) + v1.xyxy;
  r1.xyz = t0.Sample(s0_s, r3.xy).xyz;
  if(injectedData.isClamped != 0.f){
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r1.xyz = rolloffSdr(r1.xyz);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r2.yzw = t0.Sample(s0_s, r3.zw).xyz;
  if(injectedData.isClamped != 0.f){
    r2.yzw = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r2.yzw) : r2.yzw;
    r2.yzw = rolloffSdr(r2.yzw);
    r2.yzw = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r2.yzw) : r2.yzw;
  }
  r3.x = max(r1.y, r1.z);
  r3.x = max(r3.x, r1.x);
  r3.x = 1 + r3.x;
  r4.xyzw = cb0[2].xyxy * float4(-0.5,0.5,0.5,0.5) + w1.xyxy;
  r3.y = t1.Sample(s1_s, r4.xy).x;
  r3.z = t1.Sample(s1_s, r4.zw).x;
  r3.z = r3.z * 2 + -1;
  r3.y = r3.y * 2 + -1;
  r3.x = abs(r3.y) / r3.x;
  r3.y = min(r3.y, r3.z);
  r0.xyz = r1.xyz * r3.xxx + r0.xyz;
  r0.w = r3.x + r0.w;
  r1.x = max(r2.z, r2.w);
  r1.x = max(r2.y, r1.x);
  r1.x = 1 + r1.x;
  r1.x = abs(r3.z) / r1.x;
  r0.xyz = r2.yzw * r1.xxx + r0.xyz;
  r0.w = r1.x + r0.w;
  r0.w = max(9.99999975e-06, r0.w);
  o0.xyz = r0.xyz / r0.www;
  r0.x = min(r3.y, r1.w);
  r0.y = max(r3.y, r1.w);
  r0.y = max(r2.x, r0.y);
  r0.x = min(r2.x, r0.x);
  r0.x = r0.y < -r0.x ? r0.x : r0.y;
  o0.w = cb0[4].z * r0.x;
  o0.w = saturate(o0.w);
  return;
}