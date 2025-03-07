Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
cbuffer cb1 : register(b1){
  float4 cb1[5];
}
cbuffer cb0 : register(b0){
  float4 cb0[17];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(1,-1) * cb1[4].xy;
  r0.x = t1.Sample(s2_s, r0.xy).x;
  r1.xy = v1.xy;
  r1.z = cb1[3].x;
  r1.xyzw = t0.Sample(s3_s, r1.xyz).xyzw;
  r0.y = cb1[4].w * r1.w;
  o0.xyz = r1.xyz;
  o0.w = r0.y * r0.x;
  return;
}