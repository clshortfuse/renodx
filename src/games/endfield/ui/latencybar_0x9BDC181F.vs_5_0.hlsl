
cbuffer cb5 : register(b5)
{
  float4 cb5[45];
}

cbuffer cb4 : register(b4)
{
  float4 cb4[1];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[11];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[21];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[4];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
}

void main(
  float4 v0 : POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Position0,
  out float4 o1 : TEXCOORD0,
  out float2 o2 : TEXCOORD1,
  out float4 o3 : TEXCOORD2,
  out float4 o4 : TEXCOORD3,
  out float4 o5 : TEXCOORD4)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb4[0].yz * float2(2,2) + float2(1,1);
  r1.xyz = cb1[1].xyz * v0.yyy;
  r1.xyz = cb1[0].xyz * v0.xxx + r1.xyz;
  r1.xyz = cb1[2].xyz * v0.zzz + r1.xyz;
  r1.xyz = cb1[3].xyz + r1.xyz;
  r1.xyz = -cb5[44].xyz * cb4[0].xxx + r1.xyz;
  r1.w = 1;
  r0.z = 0 < cb4[0].x ? 1.0 : 0.0;
  r2.x = r0.z != 0 ? cb5[32].x : cb2[17].x;
  r2.y = r0.z != 0 ? cb5[33].x : cb2[18].x;
  r2.z = r0.z != 0 ? cb5[34].x : cb2[19].x;
  r2.w = r0.z != 0 ? cb5[35].x : cb2[20].x;
  r2.x = dot(r2.xyzw, r1.xyzw);
  r3.x = r0.z != 0 ? cb5[32].y : cb2[17].y;
  r3.y = r0.z != 0 ? cb5[33].y : cb2[18].y;
  r3.z = r0.z != 0 ? cb5[34].y : cb2[19].y;
  r3.w = r0.z != 0 ? cb5[35].y : cb2[20].y;
  r2.y = dot(r3.xyzw, r1.xyzw);
  r0.xy = r2.xy * r0.xy;
  r2.xy = r0.zz != 0 ? r0.xy : r2.xy;
  r3.x = r0.z != 0 ? cb5[32].z : cb2[17].z;
  r3.y = r0.z != 0 ? cb5[33].z : cb2[18].z;
  r3.z = r0.z != 0 ? cb5[34].z : cb2[19].z;
  r3.w = r0.z != 0 ? cb5[35].z : cb2[20].z;
  r2.z = dot(r3.xyzw, r1.xyzw);
  r3.x = r0.z != 0 ? cb5[32].w : cb2[17].w;
  r3.y = r0.z != 0 ? cb5[33].w : cb2[18].w;
  r3.z = r0.z != 0 ? cb5[34].w : cb2[19].w;
  r3.w = r0.z != 0 ? cb5[35].w : cb2[20].w;
  r2.w = dot(r3.xyzw, r1.xyzw);
  o0.xyzw = r2.xyzw;
  o5.zw = r2.zw;
  r0.x = cb3[9].w != 0.000000 ? 1.0 : 0.0;
  r1.xyzw = r0.xxxx != 0 ? cb3[10].xxxy : float4(1,1,1,1);
  r3.xyzw = cb3[2].xyzw * v1.xyzw;
  o1.xyzw = r3.xyzw * r1.xyzw;
  o2.xy = v2.xy * cb3[5].xy + cb3[5].zw;
  o3.xyzw = v0.xyzw;
  r1.xz = r0.zz != 0 ? cb5[8].yx : cb2[5].yx;
  r1.yw = r0.zz != 0 ? cb5[9].yx : cb2[6].yx;
  r0.z = dot(r1.zw, cb0[6].xy);
  r0.w = dot(r1.xy, cb0[6].xy);
  r0.xy = r2.ww / abs(r0.zw);
  r1.xz = float2(0.5,0.5) * r2.xw;
  r0.z = cb0[5].x * r2.y;
  r1.w = 0.5 * r0.z;
  o5.xy = r1.xw + r1.zz;
  r0.xy = cb3[9].xy * float2(0.25,0.25) + abs(r0.xy);
  o4.zw = float2(0.25,0.25) / r0.xy;
  r0.xyzw = max(cb3[4].xyzw, float4(-2e+10,-2e+10,-2e+10,-2e+10));
  r0.xyzw = min(float4(2e+10,2e+10,2e+10,2e+10), r0.xyzw);
  r0.xy = v0.xy * float2(2,2) + -r0.xy;
  o4.xy = r0.xy + -r0.zw;

  return;
}
