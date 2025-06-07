Texture2D<float4> t1 : register(t1);
SamplerState s1_s : register(s1);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v0.zw).xyzw;
  r0.xyzw = v1.xxxx * r0.xyzw;
  r1.xyzw = t1.Sample(s1_s, v0.xy).xyzw;
  r2.x = 1 + -v1.x;
  r0.xyzw = r2.xxxx * r1.xyzw + r0.xyzw;
  r0.xyzw = v2.xyzw * r0.xyzw;
  r1.x = r0.w * cb0[3].x + -cb0[0].x;
  if (r1.x < 0) discard;
  r0.xyz = r0.xyz + r0.xyz;
  r0.w = cb0[3].x * r0.w;
  o0.w = r0.w;
  o0.xyz = cb0[2].xxx * r0.xyz;
  o0.a = saturate(o0.a);
  return;
}