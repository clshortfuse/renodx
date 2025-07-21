Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[1];
}

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v2.xyz, v1.xyz);
  r0.x = 1 + -r0.x;
  r0.yz = cmp(float2(9.99999991e-38,0) < abs(r0.xx));
  r0.z = (int)-r0.z;
  r0.w = cmp(r0.z != 0.000000);
  r0.z = 9.99999991e-38 * r0.z;
  r0.z = r0.w ? r0.z : 9.99999991e-38;
  r0.x = r0.y ? abs(r0.x) : r0.z;
  r0.x = r0.x * r0.x;
  r0.x = r0.x * r0.x;
  r0.x = min(1, r0.x);
  r0.x = cb0[0].w * r0.x;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.yzw = cb0[0].xyz + -r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  o0.w = r1.w;
  r1.xyz = float3(1,1,1) + -r0.xyz;
  o0.xyz = v3.www * r1.xyz + r0.xyz;
  o0 = max(0.f, o0);
  return;
}