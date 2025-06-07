Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = t1.Sample(s1_s, v0.xy).xy;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.xy = cb0[1].xx * r0.xy;
  r0.z = saturate(1 + -v0.w);
  r0.xy = r0.xy * r0.zz + v0.zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.w = cb0[2].x * r0.w;
  r0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
  r0.w = 1 + -v1.w;
  o0.xyz = r0.xyz * r0.www;
  o0 = saturate(o0);
  return;
}