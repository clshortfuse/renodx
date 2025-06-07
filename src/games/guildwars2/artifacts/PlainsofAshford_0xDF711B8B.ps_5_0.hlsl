Texture2D<float4> t14 : register(t14);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t0 : register(t0);
SamplerState s14_s : register(s14);
SamplerState s2_s : register(s2);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.x = saturate(r0.w + r0.w);
  r1.x = -0.5 + r1.x;
  if (r1.x < 0) discard;
  r0.w = -0.5 + r0.w;
  r0.w = saturate(r0.w + r0.w);
  r1.xyz = cb0[7].xyz * r0.www;
  r1.xyz = r1.xyz + r1.xyz;
  r1.xyz = cb0[3].xyz * r1.xyz;
  r2.xy = cb0[4].xx + v3.xy;
  r2.xy = cb0[2].xy * r2.xy;
  r2.xyzw = t14.Sample(s14_s, r2.xy).xyzw;
  r2.a = saturate(r2.a);
  r2.xyzw = cb0[0].yyyy * r2.xyzw;
  r1.xyz = r2.www * r1.xyz;
  r3.xyz = t2.Sample(s2_s, v0.zw).xyz;
  r0.xyz = r3.xyz * r0.xyz;
  r0.xyz = r0.xyz + r0.xyz;
  r0.xyz = r0.xyz * r2.xyz + r1.xyz;
  r0.w = 1 + -v2.w;
  o0.xyz = r0.xyz * r0.www + v2.xyz;
  o0.w = cb0[1].x;
  return;
}