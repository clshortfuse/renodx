Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xy = float2(0.15,0.15) * r0.xy;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xy = r1.xy * float2(0.4,0.4) + r0.xy;
  r2.xyzw = t0.Sample(s0_s, v2.zw).xyzw;
  r0.xy = r2.xy * float2(0.15,0.15) + r0.xy;
  r2.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  r0.xy = r2.xy * float2(0.1,0.1) + r0.xy;
  r2.xyzw = t0.Sample(s0_s, v3.zw).xyzw;
  r0.xy = r2.xy * float2(0.1,0.1) + r0.xy;
  r2.xyzw = t0.Sample(s0_s, v4.xy).xyzw;
  r0.xy = r2.xy * float2(0.05,0.05) + r0.xy;
  r2.xyzw = t0.Sample(s0_s, v4.zw).xyzw;
  r0.xy = r2.xy * float2(0.05,0.05) + r0.xy;
  r0.xy = r0.xy + -r1.zz;
  r1.xyzw = cb0[8].xyzw * r0.yyyy;
  o0.xyzw = r0.xxxx * cb0[7].xyzw + r1.xyzw;
  o0 = max(0.f, o0);
  return;
}