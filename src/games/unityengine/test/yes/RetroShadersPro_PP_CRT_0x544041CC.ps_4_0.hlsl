#include "../../common.hlsli"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[144];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v1.y;
  r0.y = cb0[15].x;
  r0.x = dot(r0.xy, float2(12.9898005,78.2330017));
  r0.x = sin(r0.x);
  r0.x = 43758.5469 * r0.x;
  r0.x = frac(r0.x);
  r0.x = cb0[132].x * r0.x;
  r0.yz = float2(-0.5,-0.5) + v1.xy;
  r0.w = dot(r0.yz, r0.yz);
  r0.w = r0.w * cb0[138].x + 1;
  r1.yz = r0.yz * r0.ww + float2(0.5,0.5);
  r0.yz = cb0[139].ww * r0.yz;
  r1.x = r0.x * cb0[139].y + r1.y;
  r0.xw = r0.yz * cb0[132].xy + r1.xz;
  r0.yz = -r0.yz * cb0[132].xy + r1.xz;
  r2.xyzw = t0.SampleBias(s0_s, r1.xz, cb0[4].x).xyzw;
  r3.xyzw = t0.SampleBias(s0_s, r0.yz, cb0[4].x).xyzw;
  r2.z = r3.z;
  r0.xyzw = t0.SampleBias(s0_s, r0.xw, cb0[4].x).xyzw;
  r2.x = r0.x;
  r0.xyz = cb0[136].xyz * r2.xyz;
  r0.xyz = cb0[143].xxx * r0.xyz;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  float max_channel_scale;
  float compression_scale;
  GamutCompression(r0.xyz, compression_scale);
  NeutwoMaxCh(r0.xyz, max_channel_scale);
  // x - 1
  r2.xyz = float3(-1,-1,-1) + r0.xyz;
  // cb143 * (x - 1)
  r2.xyz = cb0[143].yyy * r2.xyz;
  // x * cb143 * (x - 1)
  r2.xyz = r2.xyz * r0.xyz;
  // (x - 0.5)
  r3.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  // x - (x - 0.5) * x * cb143 * (x - 1)
  r0.xyz = -r2.xyz * r3.xyz + r0.xyz;
  r1.xw = cb0[123].xy * r1.yz;
  r0.w = asint(cb0[138].z);
  r2.xy = r1.xw / r0.ww;
  r3.xyzw = t1.SampleBias(s1_s, r2.xy, cb0[4].x).xyzw;
  r3.xyz = r0.xyz * r3.xyz + -r0.xyz;
  r0.xyz = cb0[138].www * r3.xyz + r0.xyz;
  r2.z = cb0[15].y * cb0[139].z + r2.y;
  r2.xyzw = t2.SampleBias(s1_s, r2.xz, cb0[4].x).xyzw;
  r2.xyz = r0.xyz * r2.xyz + -r0.xyz;
  r0.xyz = cb0[139].xxx * r2.xyz + r0.xyz;
  r0.xyz = -cb0[137].xyz + r0.xyz;
  r0.w = 1 + -cb0[138].y;
  r1.xw = r1.yz + -r0.ww;
  r0.w = 1 + -r0.w;
  r0.w = 1 / r0.w;
  r1.xw = saturate(r1.xw * r0.ww);
  r2.xy = r1.xw * float2(-2,-2) + float2(3,3);
  r1.xw = r1.xw * r1.xw;
  r1.xw = -r2.xy * r1.xw + float2(1,1);
  r0.w = 1 / cb0[138].y;
  r1.yz = saturate(r1.yz * r0.ww);
  r2.xy = r1.yz * float2(-2,-2) + float2(3,3);
  r1.yz = r1.yz * r1.yz;
  r1.yz = r2.xy * r1.yz;
  r1.xy = r1.yz * r1.xw;
  r0.w = min(r1.x, r1.y);
  r0.xyz = r0.www * r0.xyz + cb0[137].xyz;
  NeutwoMaxChInverse(r0.xyz, max_channel_scale);
  GamutDecompression(r0.xyz, compression_scale);
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}