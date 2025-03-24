#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyzw = float4(0.150000006,0.150000006,0.150000006,0.150000006) * r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  float3 preBlur = r1.rgb;
  r0.xyzw = r1.xyzw * float4(0.400000006,0.400000006,0.400000006,0.400000006) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v2.zw).xyzw;
  r0.xyzw = r1.xyzw * float4(0.150000006,0.150000006,0.150000006,0.150000006) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.100000001,0.100000001,0.100000001,0.100000001) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v3.zw).xyzw;
  r0.xyzw = r1.xyzw * float4(0.100000001,0.100000001,0.100000001,0.100000001) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v4.xy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.0500000007,0.0500000007,0.0500000007,0.0500000007) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v4.zw).xyzw;
  o0.xyzw = r1.xyzw * float4(0.0500000007, 0.0500000007, 0.0500000007, 0.0500000007) + r0.xyzw;
  o0.rgb = lerp(preBlur, o0.rgb, injectedData.fxBlur);
  return;
}