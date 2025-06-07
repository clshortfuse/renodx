Texture2D<float4> t12 : register(t12);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[14];
}

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float2 v1 : TEXCOORD1,
  float w1 : TEXCOORD2,
  float4 v2 : TEXCOORD3,
  float4 v3 : TEXCOORD4,
  float4 v4 : TEXCOORD5,
  float4 v5 : TEXCOORD6,
  float4 v6 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v3.xyz, v3.xyz);
  r0.x = sqrt(r0.x);
  r0.yz = cmp(float2(9.99999991e-38,0) < r0.xx);
  r0.z = (int)-r0.z;
  r0.w = cmp(r0.z != 0.000000);
  r0.z = 9.99999991e-38 * r0.z;
  r0.z = r0.w ? r0.z : 9.99999991e-38;
  r0.x = r0.y ? r0.x : r0.z;
  r0.xyz = v3.xyz / r0.xxx;
  r0.x = dot(v4.xyz, r0.xyz);
  r0.yz = cmp(float2(9.99999991e-38,0) < abs(r0.xx));
  r0.z = (int)-r0.z;
  r0.w = cmp(r0.z != 0.000000);
  r0.z = 9.99999991e-38 * r0.z;
  r0.z = r0.w ? r0.z : 9.99999991e-38;
  r0.x = r0.y ? abs(r0.x) : r0.z;
  r0.x = log2(r0.x);
  r0.x = cb0[5].x * r0.x;
  r0.x = exp2(r0.x);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.xyz = cb0[4].xyz * r0.xxx;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.xyz = r1.www * r0.xyz;
  r1.xyz = cb0[4].www * r1.xyz;
  r0.yzw = r1.xyz * float3(2,2,2) + r0.xyz;
  r1.xy = cb0[7].xx * v0.zw;
  r1.xy = t1.Sample(s1_s, r1.xy).xy;
  r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
  r2.xy = cb0[9].xx * v1.xy;
  r1.xy = r1.xy * cb0[8].xx + r2.xy;
  r1.xyz = t2.Sample(s2_s, r1.xy).xyz;
  r1.xyz = -cb0[10].xxx + r1.xyz;
  r2.x = 1 + -cb0[10].x;
  r2.x = 1 / r2.x;
  r1.xyz = saturate(r2.xxx * r1.xyz);
  r2.xyz = r1.xyz * float3(-2,-2,-2) + float3(3,3,3);
  r1.xyz = r1.xyz * r1.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = r1.xyz + r1.xyz;
  r1.xyz = cb0[4].www * r1.xyz;
  r1.xyz = r1.xyz * r1.www;
  r1.xyz = cb0[6].xyz * r1.xyz;
  r1.xyz = r1.xyz + r1.xyz;
  r0.yzw = r1.xyz * cb0[6].www + r0.yzw;
  r1.xyz = cb0[4].xyz * r1.www;
  r1.w = saturate(r1.w + r1.w);
  r0.yzw = r1.xyz * float3(2,2,2) + r0.yzw;
  r1.xy = cb0[2].xx + v6.xy;
  r1.xy = cb0[0].xy * r1.xy;
  r1.x = t12.Sample(s12_s, r1.xy).x;
  r1.x = r1.x * cb0[0].w + -cb0[0].z;
  r1.x = -w1.x + r1.x;
  r1.x = saturate(r1.x / cb0[13].x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r1.x = r1.x * r1.w;
  r1.y = cb0[1].z * cb0[1].w;
  r1.y = saturate(-r1.y * cb0[12].x + 1);
  r1.x = r1.y * r1.x;
  r1.y = -1 + cb0[11].x;
  r1.y = 1 / r1.y;
  r1.z = -1 + abs(v2.z);
  r1.y = saturate(r1.z * r1.y);
  r1.z = r1.y * -2 + 3;
  r1.y = r1.y * r1.y;
  r1.y = r1.z * r1.y;
  r0.x = r1.y * r1.x + r0.x;
  r0.x = cb0[4].w * r0.x;
  r0.yzw = r0.yzw * r0.xxx;
  o0.w = r0.x;
  r0.x = 1 + -v5.w;
  o0.xyz = r0.yzw * r0.xxx;
  o0 = saturate(o0);
  return;
}