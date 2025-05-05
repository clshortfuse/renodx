#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  float3 hdrColor = r0.rgb;
  r0.xyz = saturate(r0.xyz);
  o0.w = r0.w;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[1].xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * cb0[2].xxx + cb0[2].yyy;
  r1.xyz = r0.xyz * r1.xyz + cb0[2].zzz;
  r2.xyz = r1.xyz * r0.xyz;
  r0.w = dot(float3(0.308600008,0.609399974,0.0820000023), r2.xyz);
  r0.xyz = r0.xyz * r1.xyz + -r0.www;
  r0.xyz = cb0[1].www * r0.xyz + r0.www;
  if (injectedData.toneMapType == 0.f) {
    o0.rgb = r0.rgb;
  } else {
    o0.rgb = UpgradeToneMapPerChannel(hdrColor, min(1.f, hdrColor), r0.rgb, 1.f);
  }
  return;
}