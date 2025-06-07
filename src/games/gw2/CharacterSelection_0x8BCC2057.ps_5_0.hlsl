Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : TEXCOORD0,
  float2 v1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t2.Sample(s2_s, v0.zw).x;
  r0.x = r0.x * 0.8 + cb0[3].x;
  r0.x = -0.8 + r0.x;
  r0.x = saturate(5.0 * r0.x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.y = t1.Sample(s1_s, v1.xy).x;
  r0.x = r0.x * r0.y;
  r0.y = cb0[0].w * r0.x + -cb0[1].x;
  r0.x = cb0[0].w * r0.x;
  o0.w = r0.x;
  if (r0.y < 0) discard;
  r0.xyz = t0.Sample(s0_s, v0.xy).xyz;
  r0.xyz = cb0[0].xyz * r0.xyz;
  o0.xyz = r0.xyz + r0.xyz;
  o0 = max(0, o0);
  return;
}