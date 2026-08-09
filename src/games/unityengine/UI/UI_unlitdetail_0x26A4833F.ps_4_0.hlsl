Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r0.w = cb0[6].x * r0.w;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = cb0[7].xyzw + r1.xyzw;
  r1.xyzw = v3.xyzw * r1.xyzw;
  r0.xyz = r1.xyz * r0.xyz + -r1.xyz;
  r1.xyz = r0.www * r0.xyz + r1.xyz;
  o0.xyzw = cb0[5].xyzw * r1.xyzw;
  o0.w = saturate(o0.w);
  return;
}