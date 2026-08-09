Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = cb0[3].xyz + -r0.xyz;
  o0.xyz = cb0[4].xxx * r1.xyz + r0.xyz;
  o0.w = cb0[3].w * r0.w;
  o0.w = saturate(o0.w);
  return;
}