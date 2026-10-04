Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yz = cb0[2].zw + -cb0[2].xy;
  r0.yz = float2(1,1) / r0.yz;
  r1.xy = min(cb0[2].zw, v0.xy);
  r1.xy = max(cb0[2].xy, r1.xy);
  r0.yz = r1.xy * r0.yz;
  r0.xy = cb0[3].x == 1.0 ? r0.yz : r1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.xy = cb0[1].yz + r0.xy;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = v2.xyzw * r0.xyzw;
  o0.w = r0.w * r1.w + -cb0[1].x;
  o0.xyz = r0.xyz;
  o0.w = saturate(o0.w);
  return;
}