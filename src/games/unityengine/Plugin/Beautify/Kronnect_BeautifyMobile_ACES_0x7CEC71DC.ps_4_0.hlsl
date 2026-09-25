#include "../../common.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

// Afallon

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float2 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.x = renodx::color::y::from::NTSC1953(r0.xyz);
  r1.xyzw = t0.Sample(s0_s, w2.xy).xyzw;
  r0.y = renodx::color::y::from::NTSC1953(r1.xyz);
  r0.z = min(r0.x, r0.y);
  r0.x = max(r0.x, r0.y);
  r1.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  r0.y = renodx::color::y::from::NTSC1953(r1.xyz);
  r0.z = min(r0.z, r0.y);
  r0.x = max(r0.x, r0.y);
  r0.y = -9.99999997e-07 + r0.z;
  r0.z = r0.x + -r0.y;
  r0.z = saturate(cb0[6].w / r0.z);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.w = renodx::color::y::from::NTSC1953(r1.xyz);
  r0.y = r0.w * 2 + -r0.y;
  r0.x = r0.y + -r0.x;
  r0.x = r0.x * r0.z;
  r0.x = cb0[6].x * r0.x;
  r0.x = max(-cb0[6].z, r0.x);
  r0.x = min(cb0[6].z, r0.x);
  r2.x = -cb0[2].x;
  r2.y = -0;
  r0.yz = w1.xy + r2.xy;
  r2.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  r0.y = cb1[7].x * r2.x + cb1[7].y;
  r0.y = 1 / r0.y;
  r0.z = -cb0[7].z + r0.y;
  r0.y = step(cb0[7].y, r0.y);
  r0.y = cb0[7].x * r0.y;
  r0.z = abs(r0.z) < cb0[7].w ? 1.000000 : 0;
  r0.x = r0.x * r0.z + 1;
  r0.xzw = r1.xyz * r0.xxx;
  o0.w = r1.w;
  r0.xzw = Bt709AcesTonemap(r0.xzw, cb0[5].x);
  float compression_scale = 1.f;
  GamutCompression(r0.xzw, compression_scale);
  r1.x = max(r0.z, r0.w);
  r1.x = max(r1.x, r0.x);
  r1.y = min(r0.z, r0.w);
  r1.y = min(r1.y, r0.x);
  r1.x = saturate(r1.x + -r1.y);
  r1.x = 1 + -r1.x;
  r1.x = cb0[5].z * r1.x;
  r1.y = renodx::color::y::from::NTSC1953(r0.xzw);
  r1.yzw = -r1.yyy + r0.xzw;
  r1.xyz = r1.xxx * r1.yzw + float3(1,1,1);
  r0.xzw = r1.xyz * r0.xzw;
  r1.xyz = r0.xzw * cb0[9].xyz + -r0.xzw;
  r0.xzw = cb0[9].www * r1.xyz + r0.xzw;
  r0.xzw = float3(-0.5,-0.5,-0.5) + r0.xzw;
  r0.xzw = r0.xzw * cb0[5].yyy + float3(0.5,0.5,0.5);
  r1.xy = cb1[6].xy * v1.xy;
  r1.x = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r1.xxx;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = r0.yyy * r1.xyz + float3(1,1,1);
  o0.xyz = r1.xyz * r0.xzw;
  GamutDecompression(o0.xyz, compression_scale);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    o0.xyz = GradeAndDisplayMap(o0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}