Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.w = saturate(r0.w);
  r0.xyz = -r1.xyz + r0.xyz;
  o0.xyz = r0.www * r0.xyz + r1.xyz;
  o0.w = r1.w;
  return;
}