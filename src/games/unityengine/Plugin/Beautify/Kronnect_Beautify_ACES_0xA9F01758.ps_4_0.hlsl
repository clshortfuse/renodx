#include "../../common.hlsli"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[161];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float2 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s1_s, v1.xy, cb0[5].x).xyzw;
  if(RENODX_TONE_MAP_TYPE == 0.f){
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(cb0[142].zzz, r0.xyz);
  }
  r1.xyzw = t3.SampleBias(s0_s, v1.xy, cb0[5].x).wxyz;
  if (cb0[160].z < cb0[132].z) {
    r2.xyzw = t1.SampleBias(s2_s, v1.xy, cb0[5].x).xyzw;
    r2.x = cb0[23].z * r2.x + cb0[23].w;
    r2.x = 1 / r2.x;
    r2.y = -cb0[147].x + r2.x;
    r2.z = r2.x < cb0[147].x ? 1.000000 : 0;
    r2.y = -cb0[148].x * r2.z + abs(r2.y);
    r2.y = cb0[147].y * r2.y;
    r2.y = 0.5 * r2.y;
    r2.x = r2.y / r2.x;
    r2.x = min(cb0[149].z, r2.x);
    r2.y = 0.0078125 * r2.x;
    r2.z = cb0[160].z / cb0[132].z;
    r2.x = -r2.x * 0.0078125 + r1.x;
    r1.x = r2.z * r2.x + r2.y;
  }
  r1.x = saturate(128 * r1.x);
  r1.yzw = r1.yzw + -r0.xyz;
  r0.xyz = r1.xxx * r1.yzw + r0.xyz;
  r1.xyzw = t2.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r0.xyz = r1.xyz * cb0[140].xxx * CUSTOM_BLOOM + r0.xyz;
  r0.xyz = SHAcesTonemap(r0.xyz, cb0[142].x, cb0[142].y);
  float compression_scale;
  GamutCompression(r0.xyz, compression_scale);
  r1.w = max(r0.y, r0.z);
  r1.w = max(r1.w, r0.x);
  r2.x = min(r0.y, r0.z);
  r2.x = min(r2.x, r0.x);
  r1.w = saturate(-r2.x + r1.w);
  r1.w = 1 + -r1.w;
  r1.w = cb0[143].z * r1.w;
  r2.x = renodx::color::y::from::NTSC1953(r0.xyz);
  r1.xyz = r0.xyz + -r2.xxx;
  r1.xyz = r1.www * r1.xyz + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  r1.xyz = r0.xyz * cb0[144].xyz + -r0.xyz;
  r0.xyz = cb0[144].www * r1.xyz + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[143].yyy + float3(0.5,0.5,0.5);
  r1.xyz = cb0[143].xxx * r0.xyz;
  r2.xy = -cb0[158].xy + v1.xy;
  r3.x = cb0[159].x * r2.x;
  r3.y = cb0[158].z * r2.y;
  r1.w = dot(r3.xy, r3.xy);
  r1.w = -cb0[158].w + r1.w;
  r2.x = -cb0[158].w + cb0[145].w;
  r1.w = saturate(r1.w / r2.x);
  r1.w = saturate(-cb0[145].z + r1.w);
  r2.xyz = r0.xyz * cb0[143].xxx + -cb0[157].xyz;
  r2.xyz = r1.www * r2.xyz + cb0[157].xyz;
  r0.xyz = -r0.xyz * cb0[143].xxx + r2.xyz;
  o0.xyz = cb0[157].www * r0.xyz + r1.xyz;
  o0.w = r0.w;
  GamutDecompression(o0.xyz, compression_scale);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    o0.xyz = GradeAndDisplayMap(o0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}