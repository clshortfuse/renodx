#include "../../common.hlsli"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[142];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  nointerpolation float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t1.SampleBias(s0_s, v1.xy, cb0[4].x).xyw;
  r1.xyz = t0.SampleBias(s0_s, v1.xy, cb0[4].x).xyz;
  r2.xyz = cb0[138].xyz * cb0[138].www;
  r2.xyz = r2.xyz * r0.zzz;
  r2.xyz = r2.xyz * r0.xxx;
  r1.xyz = r2.xyz * float3(1.5,1.5,1.5) + r1.xyz;
  r0.x = cb0[139].w * r0.z;
  r0.x = r0.x * r0.y;
  r0.x = 1.5 * r0.x;
  r0.yzw = cb0[139].xyz * r1.xyz + -r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  if (cb0[141].x != 0) {
    if (CUSTOM_FILM_GRAIN_TYPE == 0.f) {
    r1.xy = v2.xy + v1.xy;
    r1.zw = cb0[137].xy * cb0[133].zw;
    r1.xy = r1.xy * r1.zw;
    r1.xy = cb0[140].xy * r1.xy;
    r1.xyz = t2.SampleBias(s1_s, r1.xy, cb0[4].x).xyz;
    r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
    r1.xyz = r1.xyz * r0.xyz;
    r0.w = dot(r0.xyz, float3(0.212672904,0.715152204,0.0721750036));
    r0.w = sqrt(r0.w);
    r0.w = cb0[141].z * -r0.w + 1;
    r1.xyz = cb0[141].yyy * r1.xyz * CUSTOM_FILM_GRAIN;
    r1.xyz = r1.xyz * r0.www;
    r0.xyz = r1.xyz * float3(2, 2, 2) + r0.xyz;
    } else {
      r0.xyz = applyFilmGrain(r0.xyz, v1.xy);
    }
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}