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
  float4 v4 : Texcoord2,
  float4 v5 : Texcoord3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = map0Sampler.SampleBias(sampler_bilinear_wrap_s, v2.xy, -1).w;
  r0.xy = -v4.xz + r0.xx;
  r0.zw = v4.yw + -v4.xz;
  r0.zw = float2(1,1) / r0.zw;
  r0.xy = saturate(r0.xy * r0.zw);
  r0.zw = r0.xy * float2(-2,-2) + float2(3,3);
  r0.xy = r0.xy * r0.xy;
  r0.xw = r0.wz * r0.yx;
  r1.x = v5.w * r0.x;
  r1.w = max(r1.x, r0.w);
  r2.xyz = -v5.xyz + v1.xyz;
  r1.xyz = r0.www * r2.xyz + v5.xyz;
  r2.x = cmp(0 < v5.w);
  r0.xyz = v1.xyz;
  r0.xyzw = r2.xxxx ? r1.xyzw : r0.xyzw;
  r1.x = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.y = r0.w;
  r0.xyzw = -r1.xxxy + r0.xyzw;
  r0.xyzw = v2.zzzz * r0.xyzw + r1.xxxy;
  r0.xyz = saturate(r0.xyz);
  o0.w = v1.w * r0.w;
  o0.xyz = color_parameters2.www * r0.xyz;
  return;
}