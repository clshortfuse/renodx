// ---- Created with 3Dmigoto v1.4.1 on Sat Apr  5 00:32:21 2025
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

cbuffer cb0 : register(b0)
{
  float4 cb0[54];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = saturate(v1.yx);
  r0.xy = -cb0[20].yx + r0.xy;
  r0.xy = saturate(r0.xy / cb0[20].wz);
  r0.zw = cb0[7].yy * r0.xy;
  r1.x = 1 + -cb0[7].y;
  r0.xy = r0.yx * r1.xx + r0.zw;
  r0.xy = r0.xy * cb0[19].zw + cb0[19].xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.x = saturate(dot(r0.xyzw, cb0[8].xyzw));
  r0.xyzw = r1.xxxx * cb0[9].xyzw + r0.xyzw;
  r0.xyz = r0.xyz / r0.www;
  r0.xyzw = cb0[21].xyzw * r0.xyzw;
  r0.xyzw = r0.xyzw + r0.xyzw;
  r1.x = cmp(r0.y < r0.z);
  r2.xy = r0.zy;
  r3.xy = r2.yx;
  r2.zw = float2(-1,0.666666687);
  r3.zw = float2(0,-0.333333343);
  r1.xyzw = r1.xxxx ? r2.xywz : r3.xywz;
  r0.y = cmp(r0.x < r1.x);
  r2.z = r1.w;
  r1.w = r0.x;
  o0.w = r0.w;
  r2.xyw = r1.wyx;
  r0.xyzw = r0.yyyy ? r1.xyzw : r2.xyzw;
  r1.x = min(r0.w, r0.y);
  r1.x = -r1.x + r0.x;
  r1.y = r1.x * 6 + cb0[53].x;
  r0.y = r0.w + -r0.y;
  r0.y = r0.y / r1.y;
  r0.y = r0.y + r0.z;
  r0.y = cb0[42].x + abs(r0.y);
  r0.y = frac(r0.y);
  r0.yzw = r0.yyy * float3(6,6,6) + float3(-3,-2,-4);
  r0.yzw = saturate(abs(r0.yzw) * float3(1,-1,-1) + float3(-1,2,2));
  r0.yzw = float3(-1,-1,-1) + r0.yzw;
  r1.y = cb0[53].x + r0.x;
  r1.x = r1.x / r1.y;
  r0.yzw = r0.yzw * r1.xxx + float3(1,1,1);
  r0.xyz = r0.yzw * r0.xxx;
  r1.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r1.xyz = r1.xyz * r0.xyz;
  r1.xyz = cb0[47].xyz * r1.xyz;
  r1.xyz = r1.xyz * float3(10,10,10) + -r0.xyz;
  r2.xyzw = t2.Sample(s2_s, v2.zw).xyzw;
  r0.w = cb0[47].w * r2.w;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r1.xyzw = t3.Sample(s3_s, v3.xy).xyzw;
  r1.xyz = r1.xyz * r0.xyz;
  r1.xyz = cb0[52].xyz * r1.xyz;
  r1.xyz = r1.xyz * float3(10,10,10) + -r0.xyz;
  r2.xyzw = t4.Sample(s4_s, v3.zw).xyzw;
  r0.w = cb0[52].w * r2.w;
  o0.xyz = r0.www * r1.xyz + r0.xyz;

  o0 = saturate(o0);
  return;
}