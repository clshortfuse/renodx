Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[1];
}
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb2[0].x + cb1[0].w;
  r0.x = r0.x * cb0[5].y + 0.0500000007;
  r0.x = frac(r0.x);
  r0.y = 1 + -cb0[5].z;
  r0.x = cmp(r0.y >= r0.x);
  r0.x = r0.x ? 1.000000 : 0;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.xyzw = v2.xyzw * r1.xyzw;
  r0.x = saturate(r1.w * r0.x + cb0[5].w);
  r0.x = r1.w * r0.x;
  r1.w = cb0[5].x * r0.x;
  o0.xyzw = cb0[4].xyzw * r1.xyzw;
  o0 = saturate(o0);
  return;
}