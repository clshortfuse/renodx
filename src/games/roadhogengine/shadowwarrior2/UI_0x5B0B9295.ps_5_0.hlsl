Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
cbuffer cb1 : register(b1){
  float4 cb1[6];
}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = -cb1[4].xyzw + v2.xyxy;
  r1.xyzw = t0.SampleLevel(s3_s, r0.xy, 0).xyzw;
  r0.xyzw = t0.SampleLevel(s3_s, r0.zw, 0).xyzw;
  r2.xyzw = cb1[4].xyzw + v2.xyxy;
  r3.xyzw = t0.SampleLevel(s3_s, r2.xy, 0).xyzw;
  r2.xyzw = t0.SampleLevel(s3_s, r2.zw, 0).xyzw;
  r4.xyzw = t0.SampleLevel(s3_s, v2.xy, 0).xyzw;
  r3.xyzw = r4.xyzw * float4(5,5,5,5) + -r3.xyzw;
  r1.xyzw = r3.xyzw + -r1.xyzw;
  r1.xyzw = r1.xyzw + -r2.xyzw;
  r0.xyzw = r1.xyzw + -r0.xyzw;
  r0.xyzw = r0.xyzw + -r4.xyzw;
  r0.xyzw = cb1[5].xxxx * r0.xyzw + r4.xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  o0.xyz = r0.xyz;
  o0.w = r0.w;
  return;
}