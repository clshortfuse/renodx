Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[1];
}

void main(
  float4 v0 : TEXCOORD0,
  float3 v1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t0.Sample(s0_s, v0.xy).w;
  r0.y = saturate(r0.x + r0.x);
  r0.x = -0.5 + r0.x;
  r0.x = saturate(r0.x + r0.x);
  r0.x = 32 * r0.x;
  o0.w = cb0[0].z * r0.x;
  r0.x = -0.5 + r0.y;
  if (r0.x < 0) discard;
  if (r0.x < 0) discard;
  r0.x = dot(v1.xyz, v1.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = v1.xyz * r0.xxx;
  o0.xyz = r0.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
  o0.rgb = max(0, o0.rgb);
  return;
}