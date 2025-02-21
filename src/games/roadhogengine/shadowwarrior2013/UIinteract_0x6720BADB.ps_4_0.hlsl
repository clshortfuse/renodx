Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
cbuffer cb1 : register(b1){
  float4 cb1[3];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb1[2].xyzw + v1.xyxy;
  r1.xyzw = t0.SampleLevel(s3_s, r0.xy, 0).xyzw;
  r0.xyzw = t0.SampleLevel(s3_s, r0.zw, 0).xyzw;
  r2.xyzw = -cb1[2].xyzw + v1.xyxy;
  r3.xyzw = t0.SampleLevel(s3_s, r2.xy, 0).xyzw;
  r2.xyzw = t0.SampleLevel(s3_s, r2.zw, 0).xyzw;
  r1.xyz = r3.xyz + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = r0.xyz + r2.xyz;
  o0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  o0.w = 1;
  o0.rgb = saturate(o0.rgb);
  return;
}