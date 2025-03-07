Texture2DArray<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
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
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy;
  r0.z = cb1[3].x;
  r0.xyzw = t0.Sample(s3_s, r0.xyz).xyzw;
  o0.w = cb1[4].w * r0.w;
  o0.xyz = r0.xyz;
  return;
}