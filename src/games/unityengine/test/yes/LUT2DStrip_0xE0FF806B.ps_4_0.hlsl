#include "../../common.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  /*r1.xyz = max(float3(0,0,0), r0.xyz);
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = saturate(r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997));*/
  float compression_scale = 1.f;
  float max_channel_scale = 1.f;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    GamutCompression(r0.xyz, compression_scale);
    NeutwoMaxCh(r0.xyz, max_channel_scale);
  }
  r1.xyz = fastSrgbEncodeSafe(r0.xyz);
  r1.xyz = r1.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r1.xw = float2(31,31) * r1.zx;
  r1.x = floor(r1.x);
  r2.x = 1 + r1.x;
  r2.x = r2.x * 32 + r1.w;
  r1.w = r1.x * 32 + r1.w;
  r1.x = r1.z * 31 + -r1.x;
  r3.z = 1 + -r1.y;
  r3.y = 0.0009765625 * r1.w;
  r4.xyzw = t1.Sample(s1_s, r3.yz).xyzw;
  r3.x = 0.0009765625 * r2.x;
  r2.xyzw = t1.Sample(s1_s, r3.xz).xyzw;
  r1.yzw = r2.xyz + -r4.xyz;
  r1.xyz = r1.xxx * r1.yzw + r4.xyz;
  /*r2.xyz = r1.xyz * float3(0.305306017,0.305306017,0.305306017) + float3(0.682171106,0.682171106,0.682171106);
  r2.xyz = r1.xyz * r2.xyz + float3(0.0125228781,0.0125228781,0.0125228781);
  r1.xyz = r1.xyz * r2.xyz + -r0.xyz;*/
  r1.xyz = fastSrgbDecodeSafe(r1.xyz);
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    GamutDecompression(r1.xyz, compression_scale);
    NeutwoMaxChInverse(r1.xyz, max_channel_scale);
  }
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[4].xxx * r1.xyz + r0.xyz;
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}