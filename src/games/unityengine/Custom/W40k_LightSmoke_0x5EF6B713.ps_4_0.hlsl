Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float3 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = cb0[3].xyz + -v3.xyz;
  r0.x = dot(r0.xyz, r0.xyz);
  r0.x = sqrt(r0.x);
  r0.x = r0.x / cb0[4].x;
  r0.x = 1 + -r0.x;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.xyzw = v1.xyzw * r1.xyzw;
  o0.w = r1.w * r0.x;
  o0.xyz = r1.xyz;
  o0.w = saturate(o0.w);
  return;
}