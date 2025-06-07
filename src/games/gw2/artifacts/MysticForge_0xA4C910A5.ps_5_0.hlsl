Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v2.xyz, v1.xyz);
  r0.xyzw = t2.Sample(s2_s, r0.xx).xyzw;
  r1.xyz = t1.Sample(s1_s, v0.zw).xyz;
  r2.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r3.xyz = r2.xyz + r1.xyz;
  r2.xyz = -r2.xyz * r1.xyz + r3.xyz;
  r0.xyzw = r2.xyzw * r0.xyzw;
  r0.xyzw = cb0[1].xxxx * r0.xyzw;
  r0.xyzw = cb0[2].xxxx * r0.xyzw;
  r1.x = 1 + -v3.w;
  o0.xyz = r1.xxx * r0.xyz;
  o0.w = r0.w;
  o0 = saturate(o0);
  return;
}