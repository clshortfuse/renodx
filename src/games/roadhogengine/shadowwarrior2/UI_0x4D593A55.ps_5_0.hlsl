Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
cbuffer cb1 : register(b1){
  float4 cb1[4];
}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, v2.xy).xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  o0.xyz = r0.xyz;
  o0.w = r0.w;
  return;
}