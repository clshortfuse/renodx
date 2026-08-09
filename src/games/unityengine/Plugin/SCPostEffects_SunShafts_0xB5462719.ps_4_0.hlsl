#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[147];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = cb0[145].zzz * cb0[135].xyw;
  r0.xyz = cb0[134].xyw * cb0[145].yyy + r0.xyz;
  r0.xyz = cb0[136].xyw * cb0[145].www + r0.xyz;
  r0.xyz = cb0[137].xyw + r0.xyz;
  r0.y = cb0[21].x * r0.y;
  r1.xzw = float3(0.5,0.5,0.5) * r0.xzy;
  r0.xy = r1.xw + r1.zz;
  r0.xy = r0.xy / r0.zz;
  r0.yz = -v1.xy + r0.xy;
  r0.w = cb0[22].x / cb0[22].y;
  r0.x = r0.y * r0.w;
  r0.x = dot(r0.xz, r0.xz);
  r0.x = sqrt(r0.x);
  r0.x = saturate(cb0[146].y + -r0.x);
  r1.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  if(injectedData.isClamped != 0.f){
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r1.xyz = rolloffSdr(r1.xyz);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r0.yzw = -cb0[143].xyz + r1.xyz;
  r0.yzw = max(float3(0,0,0), r0.yzw);
  r0.y = dot(r0.yzw, float3(1,1,1));
  r0.x = r0.y * r0.x;
  r1.xyzw = t1.SampleBias(s1_s, v1.xy, cb0[5].x).xyzw;
  r0.y = cb0[23].x * r1.x + cb0[23].y;
  r0.y = 1 / r0.y;
  r0.x = r0.y > 0.99 ? r0.x : 0;
  r0.yzw = -cb0[145].yzw + cb0[20].xyz;
  r1.x = dot(r0.yzw, r0.yzw);
  r1.x = rsqrt(r1.x);
  r0.yzw = r1.xxx * r0.yzw;
  r1.x = cb0[138].z;
  r1.y = cb0[139].z;
  r1.z = cb0[140].z;
  r0.y = saturate(dot(r0.yzw, r1.xyz));
  o0.xyzw = r0.xxxx * r0.yyyy;
  return;
}