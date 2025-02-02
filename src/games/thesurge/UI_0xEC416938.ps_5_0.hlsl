cbuffer PER_FRAME : register(b0){
  float4 time_parameters : packoffset(c0);
  float4 color_parameters2 : packoffset(c1);
}
SamplerState sampler_bilinear_wrap_s : register(s2);
Texture2D<float4> map0Sampler : register(t0);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : Color0,
  float4 v2 : Texcoord0,
  float2 v3 : Texcoord1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.5 + -v3.y;
  r0.x = abs(r0.x);
  r0.y = ddy_coarse(r0.x);
  r0.z = 0.5 + abs(r0.y);
  r0.y = -abs(r0.y) * 1.5 + 0.5;
  r0.xz = r0.xz + -r0.yy;
  r0.y = 1 / r0.z;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r1.w = 0;
  r2.xyzw = map0Sampler.SampleBias(sampler_bilinear_wrap_s, v2.xy, -1).xyzw;
  r1.xyz = r2.xyz;
  r1.xyzw = -r2.xyzw + r1.xyzw;
  r0.xyzw = r0.xxxx * r1.xyzw + r2.xyzw;
  r1.x = cmp(r0.w < 0);
  r0.xyzw = v1.xyzw * r0.xyzw;
  if (r1.x != 0) discard;
  r0.xyz = saturate(r0.xyz * r0.www);
  o0.w = r0.w;
  o0.xyz = color_parameters2.www * r0.xyz;
  return;
}