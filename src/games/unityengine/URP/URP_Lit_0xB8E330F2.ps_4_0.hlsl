#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[5];
}
cbuffer cb1 : register(b1){
  float4 cb1[11];
}
cbuffer cb0 : register(b0){
  float4 cb0[50];
}

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD3,
  float4 v3 : TEXCOORD5,
  float4 v4 : TEXCOORD6,
  float4 v5 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 + -cb2[4].y;
  r0.x = r0.x * r0.x;
  r0.x = max(6.10351562e-05, r0.x);
  r0.x = r0.x * r0.x + 1;
  r0.x = 1 / r0.x;
  r0.xyz = cb0[0].xyz * r0.xxx;
  r0.w = dot(v3.xyz, v3.xyz);
  r0.w = max(1.17549435e-38, r0.w);
  r0.w = rsqrt(r0.w);
  r1.xyz = v3.xyz * r0.www;
  r0.w = dot(v2.xyz, v2.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = v2.xyz * r0.www;
  r0.w = saturate(dot(r2.xyz, r1.xyz));
  r1.x = saturate(dot(r2.xyz, cb0[3].xyz));
  r1.x = cb1[10].z * r1.x;
  r1.xyz = cb0[4].xyz * r1.xxx;
  r0.w = 1 + -r0.w;
  r0.w = r0.w * r0.w;
  r0.w = r0.w * r0.w;
  r1.w = -cb2[4].z * 0.959999979 + 0.959999979;
  r2.x = 1 + -r1.w;
  r2.x = saturate(cb2[4].y + r2.x);
  r3.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r2.yzw = r3.xyz * cb2[1].xyz + float3(-0.0399999991,-0.0399999991,-0.0399999991);
  r2.yzw = cb2[4].zzz * r2.yzw + float3(0.0399999991,0.0399999991,0.0399999991);
  r4.xyz = r2.xxx + -r2.yzw;
  r2.xyz = r0.www * r4.xyz + r2.yzw;
  r0.xyz = r2.xyz * r0.xyz;
  r2.xyz = cb2[1].xyz * r3.xyz;
  o0.w = saturate(r3.w * cb2[1].w + cb0[5].w);
  r2.xyz = r2.xyz * r1.www;
  r0.xyz = v1.xyz * r2.xyz + r0.xyz;
  r0.xyz = r2.xyz * r1.xyz + r0.xyz;
  r1.xyzw = t1.Sample(s1_s, v0.xy).xyzw;
  r0.xyz = r1.xyz * cb2[3].xyz + r0.xyz;
  r0.xyz = -cb0[49].xyz + r0.xyz;
  r0.w = exp2(-v4.x);
  r0.w = min(1, r0.w);
  o0.xyz = r0.www * r0.xyz + cb0[49].xyz;
  if(injectedData.countOld == injectedData.countNew && injectedData.toneMapType >= 2.f){
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = rolloff(o0.xyz, 0.85f, true);
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
  }
  return;
}