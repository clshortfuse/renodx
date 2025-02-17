Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s3_s, v2.xy).xyzw;
  r1.x = r0.w * v1.w + -9.99999975e-05;
  r0.xyzw = v1.xyzw * r0.xyzw;
  o0.xyzw = r0.xyzw;
  o0.a = saturate(o0.a);
  r0.x = cmp(r1.x < 0);
  if (r0.x != 0) discard;
  return;
}