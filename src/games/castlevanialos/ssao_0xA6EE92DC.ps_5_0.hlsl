// ---- Created with 3Dmigoto v1.4.1 on Wed Apr 16 22:35:30 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
  float4 cb4[236];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[77];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD8,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  float4 v4 : TEXCOORD9,
  float4 v5 : TEXCOORD0,
  float4 v6 : TEXCOORD1,
  float4 v7 : TEXCOORD2,
  float4 v8 : TEXCOORD3,
  float4 v9 : TEXCOORD4,
  float4 v10 : TEXCOORD5,
  float4 v11 : TEXCOORD6,
  float4 v12 : TEXCOORD7,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v7.xy + cb4[9].xy;
  r1.xyzw = cb4[15].xyzw * r0.yyyy;
  r1.xyzw = r0.xxxx * cb4[14].xyzw + r1.xyzw;
  r0.xy = r0.xy * float2(0.5,0.5) + float2(0.500100017,0.499900013);
  r0.z = 1 + -r0.y;
  r0.xyzw = t0.Sample(s0_s, r0.xz).xyzw;
 //r0.xyzw = (int4)r0.xyzw & asint(cb3[44].xyzw);
 //r0.xyzw = (int4)r0.xyzw | asint(cb3[45].xyzw);
  r0.xyzw = r0.xxxx * cb4[16].xyzw + r1.xyzw;
  r0.xyzw = cb4[17].xyzw + r0.xyzw;
  r2.y = cmp(0 < abs(r0.w));
  r2.x = rcp(r0.w);
  r0.w = r2.y ? r2.x : 99999999;
  r1.xyzw = v7.yyyy * cb4[15].xyzw;
  r1.xyzw = v7.xxxx * cb4[14].xyzw + r1.xyzw;
  r2.xy = v7.xy * float2(0.5,-0.5) + float2(0.500100017,0.500100017);
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
 //r3.xyzw = (int4)r3.xyzw & asint(cb3[44].xyzw);
 //r3.xyzw = (int4)r3.xyzw | asint(cb3[45].xyzw);
  r2.xyzw = t1.Sample(s1_s, r2.xy).xyzw;
 //r2.xyzw = (int4)r2.xyzw & asint(cb3[46].xyzw);
 //r2.xyzw = (int4)r2.xyzw | asint(cb3[47].xyzw);
  r2.xyz = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r5.x = dot(r2.xyz, r2.xyz);
  r5.x = rsqrt(r5.x);
  r5.y = cmp((int)r5.x != 0x7f800000);
  r5.x = r5.y ? r5.x : 0;
  r4.xyz = r2.xyz * r5.xxx;
  r1.xyzw = r3.xxxx * cb4[16].xyzw + r1.xyzw;
  r1.xyzw = cb4[17].xyzw + r1.xyzw;
  r5.y = cmp(0 < abs(r1.w));
  r5.x = rcp(r1.w);
  r1.w = r5.y ? r5.x : 99999999;
  r1.xyz = r1.xyz * r1.www;
  r0.xyz = r0.xyz * r0.www + -r1.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r5.y = rsqrt(abs(r0.w));
  r5.x = cmp((int)r5.y == 0x7f800000);
  r0.w = r5.x ? 99999999 : r5.y;
  r5.y = cmp(0 < abs(r0.w));
  r5.x = rcp(r0.w);
  r1.w = r5.y ? r5.x : 99999999;
  r0.xyz = r0.xyz * r0.www;
  r0.x = dot(r4.xyz, r0.xyz);
  r0.x = -cb4[21].x + r0.x;
  r2.x = max(0, r0.x);
  r0.x = cb4[19].x + r1.w;
  r5.y = cmp(0 < abs(r0.x));
  r5.x = rcp(r0.x);
  r0.x = r5.y ? r5.x : 99999999;
  r0.x = cb4[20].x + r0.x;
  r0.x = r2.x * r0.x;
  r0.yz = v7.xy + cb4[8].xy;
  r2.xyzw = cb4[15].xyzw * r0.zzzz;
  r2.xyzw = r0.yyyy * cb4[14].xyzw + r2.xyzw;
  r3.xy = r0.yz * float2(0.5,0.5) + float2(0.500100017,0.499900013);
  r3.z = 1 + -r3.y;
  r3.xyzw = t0.Sample(s0_s, r3.xz).xyzw;
 //r3.xyzw = (int4)r3.xyzw & asint(cb3[44].xyzw);
 //r3.xyzw = (int4)r3.xyzw | asint(cb3[45].xyzw);
  r2.xyzw = r3.xxxx * cb4[16].xyzw + r2.xyzw;
  r2.xyzw = cb4[17].xyzw + r2.xyzw;
  r5.y = cmp(0 < abs(r2.w));
  r5.x = rcp(r2.w);
  r0.y = r5.y ? r5.x : 99999999;
  r0.yzw = r2.xyz * r0.yyy + -r1.xyz;
  r1.w = dot(r0.yzw, r0.yzw);
  r5.y = rsqrt(abs(r1.w));
  r5.x = cmp((int)r5.y == 0x7f800000);
  r1.w = r5.x ? 99999999 : r5.y;
  r5.y = cmp(0 < abs(r1.w));
  r5.x = rcp(r1.w);
  r2.x = r5.y ? r5.x : 99999999;
  r0.yzw = r1.www * r0.yzw;
  r0.y = dot(r4.xyz, r0.yzw);
  r0.y = -cb4[21].x + r0.y;
  r1.w = max(0, r0.y);
  r0.y = cb4[19].x + r2.x;
  r5.y = cmp(0 < abs(r0.y));
  r5.x = rcp(r0.y);
  r0.y = r5.y ? r5.x : 99999999;
  r0.y = cb4[20].x + r0.y;
  r0.x = r1.w * r0.y + r0.x;
  r0.yz = v7.xy + cb4[10].xy;
  r2.xyzw = cb4[15].xyzw * r0.zzzz;
  r2.xyzw = r0.yyyy * cb4[14].xyzw + r2.xyzw;
  r3.xy = r0.yz * float2(0.5,0.5) + float2(0.500100017,0.499900013);
  r3.z = 1 + -r3.y;
  r3.xyzw = t0.Sample(s0_s, r3.xz).xyzw;
 //r3.xyzw = (int4)r3.xyzw & asint(cb3[44].xyzw);
 //r3.xyzw = (int4)r3.xyzw | asint(cb3[45].xyzw);
  r2.xyzw = r3.xxxx * cb4[16].xyzw + r2.xyzw;
  r2.xyzw = cb4[17].xyzw + r2.xyzw;
  r5.y = cmp(0 < abs(r2.w));
  r5.x = rcp(r2.w);
  r0.y = r5.y ? r5.x : 99999999;
  r0.yzw = r2.xyz * r0.yyy + -r1.xyz;
  r1.w = dot(r0.yzw, r0.yzw);
  r5.y = rsqrt(abs(r1.w));
  r5.x = cmp((int)r5.y == 0x7f800000);
  r1.w = r5.x ? 99999999 : r5.y;
  r5.y = cmp(0 < abs(r1.w));
  r5.x = rcp(r1.w);
  r2.x = r5.y ? r5.x : 99999999;
  r0.yzw = r1.www * r0.yzw;
  r0.y = dot(r4.xyz, r0.yzw);
  r0.y = -cb4[21].x + r0.y;
  r1.w = max(0, r0.y);
  r0.y = cb4[19].x + r2.x;
  r5.y = cmp(0 < abs(r0.y));
  r5.x = rcp(r0.y);
  r0.y = r5.y ? r5.x : 99999999;
  r0.y = cb4[20].x + r0.y;
  r0.x = r1.w * r0.y + r0.x;
  r0.yz = v7.xy + cb4[11].xy;
  r2.xyzw = cb4[15].xyzw * r0.zzzz;
  r2.xyzw = r0.yyyy * cb4[14].xyzw + r2.xyzw;
  r3.xy = r0.yz * float2(0.5,0.5) + float2(0.500100017,0.499900013);
  r3.z = 1 + -r3.y;
  r3.xyzw = t0.Sample(s0_s, r3.xz).xyzw;
 //r3.xyzw = (int4)r3.xyzw & asint(cb3[44].xyzw);
 //r3.xyzw = (int4)r3.xyzw | asint(cb3[45].xyzw);
  r2.xyzw = r3.xxxx * cb4[16].xyzw + r2.xyzw;
  r2.xyzw = cb4[17].xyzw + r2.xyzw;
  r5.y = cmp(0 < abs(r2.w));
  r5.x = rcp(r2.w);
  r0.y = r5.y ? r5.x : 99999999;
  r0.yzw = r2.xyz * r0.yyy + -r1.xyz;
  r1.w = dot(r0.yzw, r0.yzw);
  r5.y = rsqrt(abs(r1.w));
  r5.x = cmp((int)r5.y == 0x7f800000);
  r1.w = r5.x ? 99999999 : r5.y;
  r5.y = cmp(0 < abs(r1.w));
  r5.x = rcp(r1.w);
  r2.x = r5.y ? r5.x : 99999999;
  r0.yzw = r1.www * r0.yzw;
  r0.y = dot(r4.xyz, r0.yzw);
  r0.y = -cb4[21].x + r0.y;
  r1.w = max(0, r0.y);
  r0.y = cb4[19].x + r2.x;
  r5.y = cmp(0 < abs(r0.y));
  r5.x = rcp(r0.y);
  r0.y = r5.y ? r5.x : 99999999;
  r0.y = cb4[20].x + r0.y;
  r0.x = r1.w * r0.y + r0.x;
  r0.yz = v7.xy + cb4[12].xy;
  r2.xyzw = cb4[15].xyzw * r0.zzzz;
  r2.xyzw = r0.yyyy * cb4[14].xyzw + r2.xyzw;
  r3.xy = r0.yz * float2(0.5,0.5) + float2(0.500100017,0.499900013);
  r3.z = 1 + -r3.y;
  r3.xyzw = t0.Sample(s0_s, r3.xz).xyzw;
 //r3.xyzw = (int4)r3.xyzw & asint(cb3[44].xyzw);
 //r3.xyzw = (int4)r3.xyzw | asint(cb3[45].xyzw);
  r2.xyzw = r3.xxxx * cb4[16].xyzw + r2.xyzw;
  r2.xyzw = cb4[17].xyzw + r2.xyzw;
  r5.y = cmp(0 < abs(r2.w));
  r5.x = rcp(r2.w);
  r0.y = r5.y ? r5.x : 99999999;
  r0.yzw = r2.xyz * r0.yyy + -r1.xyz;
  r1.w = dot(r0.yzw, r0.yzw);
  r5.y = rsqrt(abs(r1.w));
  r5.x = cmp((int)r5.y == 0x7f800000);
  r1.w = r5.x ? 99999999 : r5.y;
  r5.y = cmp(0 < abs(r1.w));
  r5.x = rcp(r1.w);
  r2.x = r5.y ? r5.x : 99999999;
  r0.yzw = r1.www * r0.yzw;
  r0.y = dot(r4.xyz, r0.yzw);
  r0.y = -cb4[21].x + r0.y;
  r1.w = max(0, r0.y);
  r0.y = cb4[19].x + r2.x;
  r5.y = cmp(0 < abs(r0.y));
  r5.x = rcp(r0.y);
  r0.y = r5.y ? r5.x : 99999999;
  r0.y = cb4[20].x + r0.y;
  r0.x = r1.w * r0.y + r0.x;
  r0.yz = v7.xy + cb4[13].xy;
  r2.xyzw = cb4[15].xyzw * r0.zzzz;
  r2.xyzw = r0.yyyy * cb4[14].xyzw + r2.xyzw;
  r3.xy = r0.yz * float2(0.5,0.5) + float2(0.500100017,0.499900013);
  r3.z = 1 + -r3.y;
  r3.xyzw = t0.Sample(s0_s, r3.xz).xyzw;
 //r3.xyzw = (int4)r3.xyzw & asint(cb3[44].xyzw);
 //r3.xyzw = (int4)r3.xyzw | asint(cb3[45].xyzw);
  r2.xyzw = r3.xxxx * cb4[16].xyzw + r2.xyzw;
  r2.xyzw = cb4[17].xyzw + r2.xyzw;
  r5.y = cmp(0 < abs(r2.w));
  r5.x = rcp(r2.w);
  r0.y = r5.y ? r5.x : 99999999;
  r0.yzw = r2.xyz * r0.yyy + -r1.xyz;
  r1.x = dot(r0.yzw, r0.yzw);
  r5.y = rsqrt(abs(r1.x));
  r5.x = cmp((int)r5.y == 0x7f800000);
  r1.x = r5.x ? 99999999 : r5.y;
  r5.y = cmp(0 < abs(r1.x));
  r5.x = rcp(r1.x);
  r1.y = r5.y ? r5.x : 99999999;
  r0.yzw = r1.xxx * r0.yzw;
  r0.y = dot(r4.xyz, r0.yzw);
  r0.y = -cb4[21].x + r0.y;
  r1.x = max(0, r0.y);
  r0.y = cb4[19].x + r1.y;
  r5.y = cmp(0 < abs(r0.y));
  r5.x = rcp(r0.y);
  r0.y = r5.y ? r5.x : 99999999;
  r0.y = cb4[20].x + r0.y;
  r0.x = r1.x * r0.y + r0.x;
  r0.x = saturate(0.199999999999 * r0.x);
  r0.x = cb4[22].x * r0.x;
  o0.xyzw = cb4[18].xxxx * r0.xxxx;
  return;
}