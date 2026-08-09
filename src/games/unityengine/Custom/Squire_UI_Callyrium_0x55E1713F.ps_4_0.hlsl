#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[128];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.SampleBias(s2_s, v1.xy, cb0[5].x).xyzw;
  r1.x = -0.01 + r0.w;
  if (r1.x < 0) discard;
  r1.xy = v0.xy / cb0[4].xy;
  r1.zw = cb0[127].yy * r1.xy;
  r2.xy = float2(0.25,0.25) * r1.zw;
  r2.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
  r2.x = cb0[15].x + r2.y;
  r2.yzw = float3(0.134,0.214,0.05314) * r2.xxx;
  r2.yz = r1.xy * cb0[127].yy + -r2.yz;
  r1.xy = r1.xy * cb0[127].yy + r2.ww;
  r3.xyzw = t0.SampleBias(s0_s, r1.xy, cb0[5].x).xyzw;
  r4.xyzw = t0.SampleLevel(s0_s, r2.yz, 0).xyzw;
  r1.x = r2.x * 0.25 + r4.y;
  r1.xy = r1.zw * float2(0.35,0.35) + r1.xx;
  r1.xyzw = t0.SampleBias(s0_s, r1.xy, cb0[5].x).xyzw;
  r1.x = max(0, r1.x);
  r1.x = r1.x * r1.x;
  r1.y = r1.x * r1.x;
  r1.x = r1.x * r1.y;
  r1.y = r3.y * 0.9 + r1.x;
  r2.xyzw = t1.SampleBias(s1_s, r1.xx, cb0[5].x).xyzw;
  r1.x = 0.1 + r1.y;
  r1.xyz = r2.xyz * r1.xxx;
  r1.xyz = cb0[127].xxx * r1.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  o0.xyzw = v2.xyzw * r0.xyzw;
  o0.w = saturate(o0.w);
  if(injectedData.toneMapType >= 2.f){
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = rolloff(o0.xyz, 0.85f, true);
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
  }
  return;
}