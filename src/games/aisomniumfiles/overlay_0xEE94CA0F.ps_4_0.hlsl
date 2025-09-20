// ---- Created with 3Dmigoto v1.3.16 on Sat Mar  1 01:01:22 2025
Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[11];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float w2 : TEXCOORD3,
  float4 v3 : TEXCOORD4,
  float4 v4 : TEXCOORD5,
  float2 v5 : TEXCOORD6,
  float2 w5 : TEXCOORD7,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[9].xy + cb0[9].zw;
  r0.xyzw = t0.Sample(s5_s, r0.xy).xyzw;
  r0.x = r0.x * r0.w;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.xy = cb0[10].xx * -r0.xy;
  r0.z = v3.y * v3.y;
  r0.xy = r0.zz * r0.xy;
  r0.zw = w1.xy * cb0[5].xy + cb0[5].zw;
  r1.xyzw = t4.Sample(s2_s, r0.zw).xyzw;
  r1.x = r1.x * r1.w;
  r0.zw = r1.xy * float2(2,2) + float2(-1,-1);
  r1.xy = v2.xy * cb0[5].xy + cb0[5].zw;
  r1.xyzw = t4.Sample(s2_s, r1.xy).xyzw;
  r1.x = r1.x * r1.w;
  r0.zw = r1.xy * float2(2,2) + r0.zw;
  r0.zw = float2(-1,-1) + r0.zw;
  r0.zw = cb0[6].yy * r0.zw;
  r0.zw = float2(0.150000006,0.150000006) * r0.zw;
  r1.xyzw = t3.Sample(s1_s, v1.xy).xyzw;
  r0.zw = r1.xx * r0.zw;
  r0.zw = r0.zw * w2.xx + v1.xy;
  r2.xyzw = t1.Sample(s4_s, v5.xy).xyzw;
  r0.xy = r0.xy * r2.xx + r0.zw;
  r0.xyzw = t5.Sample(s0_s, r0.xy).xyzw;
  r0.xyz = v3.xxx * float3(0.300000012,0.200000003,0.100000001) + r0.xyz;
  o0.w = saturate(r0.w);
  r1.xyz = r0.xyz * r1.xyz;
  r1.xyz = r1.xyz + r1.xyz;
  r1.xyz = w2.xxx * r1.xyz;
  r0.xyz = r1.xyz * float3(0.300000012,0.300000012,0.300000012) + r0.xyz;
  r1.xyzw = t2.Sample(s3_s, w5.xy).xyzw;
  r0.w = dot(v3.zz, v3.zz);
  r1.xyz = saturate(r1.xyz + r0.www);
  r1.xyz = r1.xyz + -r0.xyz;
  r3.xyzw = t1.Sample(s4_s, v1.xy).xyzw;
  r0.w = -0.5 + v3.z;
  r1.w = r3.z * r2.x + -r0.w;
  r0.w = v3.z + -r0.w;
  r0.w = 1 / r0.w;
  r0.w = saturate(r1.w * r0.w);
  r1.w = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.w * r0.w;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r0.xyz = v4.xyz + r0.xyz;
  r0.w = -0.300000012 + v4.w;
  r1.x = r3.y + -r0.w;
  r0.w = v4.w + -r0.w;
  r0.w = 1 / r0.w;
  r0.w = saturate(r1.x * r0.w);
  r1.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.x * r0.w;
  //o0.xyz = saturate(r0.xyz * r0.www);
  o0.xyz = (r0.xyz * r0.www);
  
  return;
}