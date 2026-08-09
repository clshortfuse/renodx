Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  float2 w2 : TEXCOORD1,
  float v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, w2.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyzw = -r1.xyzw + r0.xyzw;
  r0.xyzw = v3.xxxx * r0.xyzw + r1.xyzw;
  r1.x = saturate(1 + -v1.w);
  r0.w = -r1.x + r0.w;
  o0.w = cb0[5].w * r0.w;
  r1.xyz = cb0[5].xyz * v1.xyz;
  o0.xyz = r1.xyz * r0.xyz;
  o0.w = max(0.f, o0.w);
  return;
}