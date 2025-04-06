// ---- Created with 3Dmigoto v1.4.1 on Sat Apr  5 00:32:50 2025
Texture2D<float4> t9 : register(t9);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s9_s : register(s9);

SamplerState s8_s : register(s8);

SamplerState s7_s : register(s7);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[46];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  float4 v7 : TEXCOORD6,
  float4 v8 : TEXCOORD7,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s2_s, v2.zw).xyzw;
  r0.xy = r0.wz * float2(2,2) + float2(-1,-1);
  r0.xy = cb0[23].yx * r0.xy;
  r1.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r0.xy = saturate(r0.xy * r1.ww + v1.yx);
  r0.xy = -cb0[21].yx + r0.xy;
  r0.xy = saturate(r0.xy / cb0[21].wz);
  r0.zw = cb0[8].yy * r0.xy;
  r1.x = 1 + -cb0[8].y;
  r0.xy = r0.yx * r1.xx + r0.zw;
  r0.xy = r0.xy * cb0[20].zw + cb0[20].xy;
  r0.xyzw = t2.Sample(s0_s, r0.xy).xyzw;
  r1.x = saturate(dot(r0.xyzw, cb0[9].xyzw));
  r0.xyzw = r1.xxxx * cb0[10].xyzw + r0.xyzw;
  r0.xyz = r0.xyz / r0.www;
  r1.xyzw = cb0[22].xyzw + cb0[22].xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r1.xyzw = t4.Sample(s4_s, v3.zw).xyzw;
  r1.xyz = r1.xyz * r0.xyz;
  r1.xyz = cb0[35].xyz * r1.xyz;
  r1.xyz = r1.xyz * float3(10,10,10) + -r0.xyz;
  r2.xyzw = t5.Sample(s5_s, v4.xy).xyzw;
  r1.w = cb0[35].w * r2.w;
  r0.xyz = r1.www * r1.xyz + r0.xyz;
  r1.xyzw = t6.Sample(s6_s, v4.zw).xyzw;
  r1.xyz = r1.xyz * r0.xyz;
  r1.xyz = cb0[40].xyz * r1.xyz;
  r1.xyz = r1.xyz * float3(10,10,10) + -r0.xyz;
  r2.xyzw = t7.Sample(s7_s, v5.xy).xyzw;
  r1.w = cb0[40].w * r2.w;
  r0.xyz = r1.www * r1.xyz + r0.xyz;
  r1.xyzw = t8.Sample(s8_s, v5.zw).xyzw;
  r1.xyz = cb0[45].xyz * r1.xyz;
  r2.xyzw = t9.Sample(s9_s, v6.xy).xyzw;
  r1.xyz = r2.www * r1.xyz;
  r1.xyz = cb0[45].www * r1.xyz;
  r0.xyz = r1.xyz * float3(2,2,2) + r0.xyz;
  r1.xyz = v8.xyz + -r0.xyz;
  r0.xyz = v8.www * r1.xyz + r0.xyz;
  r1.xyz = v7.xyz + -r0.xyz;
  o0.xyz = v7.www * r1.xyz + r0.xyz;
  r1.xyzw = t3.Sample(s3_s, v3.xy).xyzw;
  r0.x = -1 + r1.w;
  r0.x = cb0[30].x * r0.x + 1;
  o0.w = r0.w * r0.x;

  o0 = saturate(o0);
  return;
}