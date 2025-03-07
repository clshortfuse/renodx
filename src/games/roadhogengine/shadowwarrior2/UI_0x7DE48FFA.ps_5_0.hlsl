Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
cbuffer cb1 : register(b1){
  float4 cb1[4];
}
cbuffer cb3 : register(b3){
  float4 cb3[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[17];
}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s2_s, v2.xy, cb1[3].x).xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r0.xyz = cb3[0].zzz * r0.xyz;
  o0.w = r0.w;
  o0.xyz = r0.xyz;
  return;
}