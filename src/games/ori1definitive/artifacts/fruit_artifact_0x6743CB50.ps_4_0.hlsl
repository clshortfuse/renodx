// ---- Created with 3Dmigoto v1.4.1 on Sat Apr  5 00:32:46 2025
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

cbuffer cb1 : register(b1)
{
  float4 cb1[5];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[42];
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
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = saturate(v1.yx);
  r0.xy = -cb0[22].yx + r0.xy;
  r0.xy = saturate(r0.xy / cb0[22].wz);
  r0.zw = cb0[8].yy * r0.xy;
  r1.x = 1 + -cb0[8].y;
  r0.xy = r0.yx * r1.xx + r0.zw;
  r0.xy = r0.xy * cb0[21].zw + cb0[21].xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.x = saturate(dot(r0.xyzw, cb0[9].xyzw));
  r0.xyzw = r1.xxxx * cb0[10].xyzw + r0.xyzw;
  r0.xyz = r0.xyz / r0.www;
  r0.xyzw = cb0[23].xyzw * r0.xyzw;
  r0.xyzw = r0.xyzw + r0.xyzw;
  r1.xyzw = t2.Sample(s2_s, v2.zw).xyzw;
  r1.xyz = r1.xyz * r0.xyz;
  r1.xyz = cb0[34].xyz * r1.xyz;
  r1.xyz = r1.xyz * float3(10,10,10) + -r0.xyz;
  r2.xyzw = t3.Sample(s3_s, v3.xy).xyzw;
  r1.w = cb0[34].w * r2.w;
  r0.xyz = r1.www * r1.xyz + r0.xyz;
  r1.xy = cb1[4].xy + -cb0[37].zw;
  r1.xy = r1.xy * cb0[37].xx + v3.zw;
  r1.xyzw = t4.Sample(s4_s, r1.xy).xyzw;
  r1.xyz = r1.xyz * r0.xyz;
  r1.xyz = cb0[41].xyz * r1.xyz;
  r1.xyz = r1.xyz * float3(10,10,10) + -r0.xyz;
  r2.xyzw = t5.Sample(s5_s, v4.xy).xyzw;
  r1.w = cb0[41].w * r2.w;
  r0.xyz = r1.www * r1.xyz + r0.xyz;
  r1.xyz = v6.xyz + -r0.xyz;
  r0.xyz = v6.www * r1.xyz + r0.xyz;
  r1.xyz = v5.xyz + -r0.xyz;
  o0.xyz = v5.www * r1.xyz + r0.xyz;
  r1.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r0.x = -1 + r1.w;
  r0.x = cb0[27].x * r0.x + 1;
  o0.w = r0.w * r0.x;

  o0 = saturate(o0);

  return;
}