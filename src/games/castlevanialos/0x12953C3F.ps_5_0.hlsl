// ---- Created with 3Dmigoto v1.4.1 on Tue Apr 15 09:35:48 2025
Texture2D<float4> t0 : register(t0);

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
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v5.xy + cb4[8].xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  //r0.xyzw = (int4)r0.xyzw & asint(cb3[44].xyzw);
  //r0.xyzw = (int4)r0.xyzw | asint(cb3[45].xyzw);
  r0.xyz = cb4[12].xxx * r0.xyz;
  r1.x = max(r0.z, r0.y);
  r2.x = max(r1.x, r0.x);
  r0.x = max(r2.x, -1.00000002e+20);
  r0.y = 9.99999975e-06 + r2.x;
  r3.y = log2(abs(r0.y));
  r3.x = cmp((int)r3.y == 0xff800000);
  r0.y = r3.x ? -9.99999993e+36 : r3.y;
  r0.zw = v5.xy + cb4[9].xy;
  r1.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  //r1.xyzw = (int4)r1.xyzw & asint(cb3[44].xyzw);
  //r1.xyzw = (int4)r1.xyzw | asint(cb3[45].xyzw);
  r1.xyz = cb4[12].xxx * r1.xyz;
  r0.z = max(r1.z, r1.y);
  r2.x = max(r0.z, r1.x);
  r1.x = max(r2.x, r0.x);
  r0.x = 9.99999975e-06 + r2.x;
  r3.y = log2(abs(r0.x));
  r3.x = cmp((int)r3.y == 0xff800000);
  r0.x = r3.x ? -9.99999993e+36 : r3.y;
  r0.x = 0.173286796 * r0.x;
  r0.x = r0.y * 0.173286796 + r0.x;
  r0.yz = v5.xy + cb4[10].xy;
  r2.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  //r2.xyzw = (int4)r2.xyzw & asint(cb3[44].xyzw);
  //r2.xyzw = (int4)r2.xyzw | asint(cb3[45].xyzw);
  r0.yzw = cb4[12].xxx * r2.xyz;
  r1.y = max(r0.w, r0.z);
  r2.x = max(r1.y, r0.y);
  r0.y = max(r2.x, r1.x);
  r0.z = 9.99999975e-06 + r2.x;
  r3.y = log2(abs(r0.z));
  r3.x = cmp((int)r3.y == 0xff800000);
  r0.z = r3.x ? -9.99999993e+36 : r3.y;
  r0.x = r0.z * 0.173286796 + r0.x;
  r0.zw = v5.xy + cb4[11].xy;
  r1.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  //r1.xyzw = (int4)r1.xyzw & asint(cb3[44].xyzw);
  //r1.xyzw = (int4)r1.xyzw | asint(cb3[45].xyzw);
  r1.xyz = cb4[12].xxx * r1.xyz;
  r0.z = max(r1.z, r1.y);
  r2.x = max(r0.z, r1.x);
  o0.y = max(r2.x, r0.y);
  r0.y = 9.99999975e-06 + r2.x;
  r3.y = log2(abs(r0.y));
  r3.x = cmp((int)r3.y == 0xff800000);
  r0.y = r3.x ? -9.99999993e+36 : r3.y;
  r0.x = r0.y * 0.173286796 + r0.x;
  r0.x = 1.44269502 * r0.x;
  o0.x = exp2(r0.x);
  o0.zw = float2(0,1);
  return;
}