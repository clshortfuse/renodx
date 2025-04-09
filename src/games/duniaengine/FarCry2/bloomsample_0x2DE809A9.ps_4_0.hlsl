Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_Position0,
  linear centroid float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  o0.xyzw = r1.xyzw + r0.xyzw;
  o0.rgb = max(0, o0.rgb);  // clears "black square" artifacts, game issue (not caused by addon). doesn't seem to have any visual impact on bloom.
  return;
}