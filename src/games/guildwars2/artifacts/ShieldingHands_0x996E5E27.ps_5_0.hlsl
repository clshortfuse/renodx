Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t1.Sample(s1_s, v0.xy).xyz;
  r1.xyz = t0.Sample(s0_s, v0.zw).xyz;
  r0.xyw = cb0[3].xxx * r0.yzx + -r1.yzx;
  r1.xyz = saturate(float3(1,1,1) + -r0.wxy);
  r2.xyz = cb0[4].xyz * r0.wxy;
  r1.xyz = saturate(cb0[2].xyz * r1.xyz + r2.xyz);
  r1.xyz = r1.xyz * r0.www;
  r0.xyz = cb0[0].xyz * r1.xyz;
  o0.xyzw = cb0[0].wwww * r0.xyzw;
  o0 = max(0.f, o0);
  return;
}