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
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = map0Sampler.SampleBias(sampler_bilinear_wrap_s, v2.xy, -1).xyzw;
  r1.x = cmp(r0.w < 0);
  if (r1.x != 0) discard;
  r1.xyzw = v1.xwyz * r0.xwyz;
  r1.x = dot(r1.xzw, float3(0.300000012,0.589999974,0.109999999));
  r0.xyzw = r0.xyzw * v1.xyzw + -r1.xxxy;
  r0.xyzw = v2.wwww * r0.xyzw + r1.xxxy;
  r0.xyz = saturate(r0.xyz);
  o0.w = r0.w;
  o0.xyz = color_parameters2.www * r0.xyz;
  return;
}