
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float3 v4 : TEXCOORD4,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = t3.Sample(s3_s, v0.zw).xy;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r0.xy, r0.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.z = sqrt(r0.w);
  r1.xy = t1.Sample(s1_s, v0.xy).xy;
  r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r1.z = sqrt(r0.w);
  r0.xyz = -r1.xyz + r0.xyz;
  r0.w = t4.Sample(s4_s, v1.xy).x;
  r1.w = t2.Sample(s2_s, v0.zw).w;
  r2.x = saturate(r1.w + r1.w);
  r1.w = -0.5 + r1.w;
  r1.w = saturate(r1.w + r1.w);
  r0.w = r2.x * r0.w;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r1.x = dot(r0.xyz, r0.xyz);
  r1.x = rsqrt(r1.x);
  r0.xyz = r1.xxx * r0.xyz;
  r1.xyz = v2.xyz * r0.yyy;
  r1.xyz = r0.xxx * v3.xyz + r1.xyz;
  r0.xyz = r0.zzz * v4.xyz + r1.xyz;
  r1.x = dot(r0.xyz, r0.xyz);
  r1.x = sqrt(r1.x);
  r1.yz = cmp(float2(9.99999991e-38,0) < r1.xx);
  r1.z = (int)-r1.z;
  r2.x = cmp(r1.z != 0.000000);
  r1.z = 9.99999991e-38 * r1.z;
  r1.z = r2.x ? r1.z : 9.99999991e-38;
  r1.x = r1.y ? r1.x : r1.z;
  r0.xyz = r0.xyz / r1.xxx;
  o0.xyz = r0.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
  r0.x = t0.Sample(s0_s, v0.xy).w;
  r0.x = -0.5 + r0.x;
  r0.x = saturate(r0.x + r0.x);
  r0.y = r1.w + -r0.x;
  r0.x = r0.w * r0.y + r0.x;
  r0.x = cb0[3].w * r0.x;
  o0.w = cb0[0].z * r0.x;
  o0.a = max(0, o0.a);
  return;
}