#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[1];
}
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[25];
}

void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD3,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD5,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[0].xx + cb1[0].xy;
  r0.xz = cb0[23].xy * r0.xx;
  r0.yw = cb0[19].yz * r0.yy;
  r1.xy = r0.xz >= -r0.xz ? float2(1,1) : float2(-1,-1);
  r0.xz = r1.xy * r0.xz;
  r0.xz = frac(r0.xz);
  r0.xz = r1.xy * r0.xz + w0.xy;
  r1.xyzw = t0.Sample(s1_s, r0.xz).xyzw;
  r0.x = -0.5 + r1.x;
  r0.x = 0.2 * r0.x;
  r0.xz = r0.xx * cb0[23].zz + v0.xy;
  r1.xy = r0.yw >= -r0.yw ? float2(1,1) : float2(-1,-1);
  r0.yw = r1.xy * r0.yw;
  r0.yw = frac(r0.yw);
  r0.xy = r1.xy * r0.yw + r0.xz;
  r0.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = v2.xyzw * r0.xyzw;
  r1.x = r0.w * r0.w;
  r1.x = cb0[21].x * r1.x;
  r1.xyz = cb0[20].xyz * r1.xxx;
  r0.xyz = log2(r0.xyz);
  r2.w = cb0[19].x * r0.w;
  r0.xyz = cb0[24].xxx * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = cb0[23].www * r0.xyz;
  r0.xyz = floor(r0.xyz);
  r0.xyz = r0.xyz / cb0[23].www;
  r0.xyz = log2(r0.xyz);
  r0.w = 1 / cb0[24].x;
  r0.xyz = r0.www * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * r1.xyz;
  r2.xyz = r0.xyz * cb0[21].yyy + r1.xyz;
  o0.xyzw = cb0[18].xyzw * r2.xyzw;
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