Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  float2 w2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyz = v1.xyz * r0.xyz;
  r0.xyz = r0.xyz + r0.xyz;
  r1.xyzw = t1.Sample(s1_s, w2.xy).xyzw;
  r1.w = 1 + -r1.w;
  o0.xyz = r1.xyz * r1.www + r0.xyz;
  o0.w = r0.w * v1.w + -r1.w;
  o0.w = saturate(o0.w);
  return;
}