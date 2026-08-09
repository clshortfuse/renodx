#include "../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[141];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[4].x).xyzw;
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r1.xyzw = t1.SampleBias(s0_s, v1.xy, cb0[4].x).xyzw;
  r1.xyz = cb0[137].xyz * cb0[137].www;
  r1.xyz = r1.xyz * r1.www;
  r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  if(injectedData.toneMapType == 0.f){
    r1.xyz = saturate(r1.xyz);
  }
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = t2.SampleBias(s0_s, v1.xy, cb0[4].x).xyzw;
  r1.xyzw = cb0[138].xyzw * r1.xyzw;
  r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  if(injectedData.toneMapType == 0.f){
    r1.xyz = saturate(r1.xyz);
  }
  r1.xyz = r1.xyz * r0.xyz + -r0.xyz;
  r0.xyz = r1.www * r1.xyz + r0.xyz;
  if (cb0[140].x != 0) {
    r1.y = dot(cb0[21].xyz, cb0[48].xyz);
    r1.x = dot(cb0[21].xyz, cb0[47].xyz);
    r1.xy = r1.xy * float2(0.04,0.04) + v1.xy;
    r1.zw = cb0[136].xy * cb0[132].zw;
    r1.xy = r1.xy * r1.zw;
    r1.xy = cb0[139].xy * r1.xy;
    r1.xyzw = t3.SampleBias(s1_s, r1.xy, cb0[4].x).xyzw;
    r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
    r1.xyz = r1.xyz * r0.xyz;
    r0.w = renodx::color::y::from::BT709(r0.xyz);
    r0.w = sqrt(r0.w);
    r0.w = cb0[140].z * -r0.w + 1;
    r1.xyz = cb0[140].yyy * r1.xyz;
    r1.xyz = r1.xyz * r0.www;
    r0.xyz = r1.xyz * float3(2,2,2) + r0.xyz;
  }
  o0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  o0.w = 1;
  return;
}