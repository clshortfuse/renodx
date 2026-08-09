Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[3].xy + -v1.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = saturate(cb0[2].x * r0.x);
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = -r2.xyzw + r1.xyzw;
  o0.xyzw = r0.xxxx * r1.xyzw + r2.xyzw;
  o0.w = saturate(o0.w);
  return;
}