#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[20];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.xy = cb0[17].zz * r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = r0.x * r0.x + -1;
  r0.x = cb0[17].y * r0.x + 1;
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r0.yzw = cb0[18].xyz * r1.xyz;
  r1.xyz = -cb0[18].xyz * r1.xyz + r1.xyz;
  r0.xyz = r0.xxx * r1.xyz + r0.yzw;
  if(injectedData.fxFilmGrainType == 0.f){
  r0.w = v1.y * 541.169983 + v1.x;
  r0.w = cb0[19].x + r0.w;
  r0.w = sin(r0.w);
  r0.w = r0.w * 273351.5 + cb0[19].x;
  r0.w = frac(r0.w);
  r0.w = r0.w * 2 + -1;
  r0.w = cb0[17].x * r0.w * injectedData.fxFilmGrain;
  r0.xyz = r0.www * r0.xyz + r0.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, v1);
  }
  o0.xyz = cb0[14].xxx * r0.xyz;
  if(injectedData.toneMapType == 0.f){
    o0.xyz = saturate(r0.xyz);
  }
  o0.w = 1;
  return;
}