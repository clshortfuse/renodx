#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[48];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[44].xy + -v1.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = saturate(cb0[44].w + -r0.x);
  r0.yz = v1.xy * cb0[46].xy + cb0[46].zw;
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  if(injectedData.isClamped != 0.f){
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r1.xyz = rolloffSdr(r1.xyz);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.y = 1.01 + -r1.w;
  r0.x = r0.y * r0.x;
  r0.yz = w1.xy * cb0[47].xy + cb0[47].zw;
  r1.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  r0.y = cb1[7].x * r1.x + cb1[7].y;
  r0.y = 1 / r0.y;
  o0.xyzw = (r0.y > 0.99) ? r0.xxxx : 0;
  return;
}