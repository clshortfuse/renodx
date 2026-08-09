Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v0.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.w = saturate(r1.w);
  r0.w = 1 + - r1.w;
  o0.xyz = r0.www * r0.xyz + r1.xyz;
  o0.w = 1;
  return;
}