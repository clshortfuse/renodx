Texture2D<float4> t12 : register(t12);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : TEXCOORD0,
  float v1 : TEXCOORD1,
  float4 v2 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t1.Sample(s1_s, v0.xy).xyz;
  r1.xyz = t0.Sample(s0_s, v0.zw).xyz;
  r0.xyz = cb0[4].xxx * r0.xyz + -r1.xyz;
  r1.xyz = saturate(float3(1,1,1) + -r0.xyz);
  r0.yzw = cb0[5].xyz * r0.xyz;
  r0.yzw = saturate(cb0[3].xyz * r1.xyz + r0.yzw);
  r1.xy = cb0[1].xx + v2.xy;
  r1.xy = cb0[0].xy * r1.xy;
  r1.x = t12.Sample(s12_s, r1.xy).x;
  r1.x = r1.x * cb0[0].w + -cb0[0].z;
  r1.x = -v1.x + r1.x;
  r1.x = saturate(r1.x / cb0[6].x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r0.x = r1.x * r0.x;
  o0.xyz = r0.yzw * r0.xxx;
  o0.w = r0.x;
  o0 = max(0, o0);
  return;
}