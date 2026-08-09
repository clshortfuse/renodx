Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[123];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(1,1) / cb0[15].xy;
  r0.zw = -r0.yx;
  r1.xyzw = r0.xzwy * cb0[122].yyyy + v1.xyxy;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r0.zw = -r0.xy * cb0[122].yy + v1.xy;
  r0.xy = r0.xy * cb0[122].yy + v1.xy;
  r3.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xyz = r0.xyz + r2.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  r0.xyz = r0.xyz + r3.xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.xyz = saturate(r1.xyz);
  r0.xyz = -r0.xyz * float3(0.25,0.25,0.25) + r2.xyz;
  o0.xyz = r0.xyz * cb0[122].xxx + r1.xyz;
  o0.w = r1.w;
  o0.w = saturate(o0.w);
  return;
}