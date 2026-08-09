Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.x = 1 + -v2.y;
  r1.x = r1.x / cb0[3].y;
  r1.x = min(1, r1.x);
  r0.w = r1.x * r0.w;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.x = cmp(r0.w == 0.000000);
  if (r1.x != 0) discard;
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
  o0 = max(0, o0);
  return;
}