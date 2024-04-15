// ---- Created with 3Dmigoto v1.3.16 on Thu Mar  7 11:19:04 2024
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[21];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  out float2 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[6].xy * float2(-0.5,-0.5) + v0.xy;
  r0.xyz = t1.Gather(s0_s, r0.xy, int2(0, 0)).xyz;
  r0.xyz = min(float3(0.999999881,0.999999881,0.999999881), r0.yxz);
  r0.xyz = r0.xyz * cb1[20].zzz + -cb1[20].www;
  r0.xyz = float3(1,1,1) / r0.xyz;
  r0.yz = r0.xx + -r0.yz;
  r0.x = 0.0399999991 * r0.x;
  r0.xy = cmp(abs(r0.yz) >= r0.xx);
  r0.xy = r0.xy ? float2(0,0) : float2(0.0512499996,0.0512499996);
  r1.xyz = t0.Sample(s1_s, v0.xy).xyz;
  r0.z = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.z = max(9.99999975e-06, r0.z);
  r0.z = sqrt(r0.z);
  r1.xyz = t0.Sample(s1_s, v1.xy).xyz;
  r0.w = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.w = max(9.99999975e-06, r0.w);
  r1.x = sqrt(r0.w);
  r2.xyz = t0.Sample(s1_s, v1.zw).xyz;
  r0.w = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.w = max(9.99999975e-06, r0.w);
  r1.y = sqrt(r0.w);
  r1.zw = -r1.xy + r0.zz;
  r0.xy = cmp(abs(r1.zw) >= r0.xy);
  r0.xy = r0.xy ? float2(1,1) : 0;
  r0.w = dot(r0.xy, float2(1,1));
  r0.w = cmp(r0.w == 0.000000);
  if (r0.w != 0) discard;
  r2.xyz = t0.Sample(s1_s, v2.xy).xyz;
  r0.w = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.w = max(9.99999975e-06, r0.w);
  r2.x = sqrt(r0.w);
  r3.xyz = t0.Sample(s1_s, v2.zw).xyz;
  r0.w = dot(r3.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.w = max(9.99999975e-06, r0.w);
  r2.y = sqrt(r0.w);
  r0.zw = -r2.xy + r0.zz;
  r0.zw = max(abs(r1.zw), abs(r0.zw));
  r2.xyz = t0.Sample(s1_s, v3.xy).xyz;
  r2.x = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r2.x = max(9.99999975e-06, r2.x);
  r3.xyz = t0.Sample(s1_s, v3.zw).xyz;
  r2.z = dot(r3.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r2.z = max(9.99999975e-06, r2.z);
  r2.xy = sqrt(r2.xz);
  r1.xy = -r2.xy + r1.xy;
  r0.zw = max(abs(r1.xy), r0.zw);
  r0.z = max(r0.z, r0.w);
  r1.xy = float2(4,4) * abs(r1.zw);
  r0.zw = cmp(r1.xy >= r0.zz);
  r0.zw = r0.zw ? float2(1,1) : 0;
  o0.xy = r0.xy * r0.zw;
  return;
}