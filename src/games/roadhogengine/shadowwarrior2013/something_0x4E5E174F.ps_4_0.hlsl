Texture2D<float4> t12 : register(t12);
SamplerState s5_s : register(s5);
cbuffer cb1 : register(b1){
  float4 cb1[4];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = -cb1[2].xyzw + v1.xyxy;
  r0.xyzw = min(cb1[1].xyxy, r0.xyzw);
  r1.xyzw = t12.SampleLevel(s5_s, r0.xy, 0).xyzw;
  r0.xyzw = t12.SampleLevel(s5_s, r0.zw, 0).xyzw;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xy = -cb1[3].xy + v1.xy;
  r1.xy = min(cb1[1].xy, r1.xy);
  r1.xyzw = t12.SampleLevel(s5_s, r1.xy, 0).xyzw;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xy = min(cb1[1].xy, v1.xy);
  r1.xyzw = t12.SampleLevel(s5_s, r1.xy, 0).xyzw;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xy = cb1[3].xy + v1.xy;
  r1.xy = min(cb1[1].xy, r1.xy);
  r1.xyzw = t12.SampleLevel(s5_s, r1.xy, 0).xyzw;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = cb1[2].zwxy + v1.xyxy;
  r1.xyzw = min(cb1[1].xyxy, r1.xyzw);
  r2.xyzw = t12.SampleLevel(s5_s, r1.xy, 0).xyzw;
  r1.xyzw = t12.SampleLevel(s5_s, r1.zw, 0).xyzw;
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  o0.xyz = float3(0.142857149,0.142857149,0.142857149) * r0.xyz;
  o0.w = 1;
  o0.rgb = saturate(o0.rgb);
  return;
}