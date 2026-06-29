// ---- Created with 3Dmigoto v1.3.16 on Tue Mar 10 11:09:37 2026
Texture2D<float4> t4 : register(t4);

Texture2D<float4> t0 : register(t0);

SamplerState s4_s : register(s4);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[9];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[3];
}

cbuffer cb11 : register(b11)
{
  float4 cb11[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  float v4 : TEXCOORD5,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb1[0].wxyz * v2.wxyz;
  r1.x = v1.z;
  r2.xyzw = t0.Sample(s0_s, v1.xy).wxyz;
  r1.yzw = r2.yzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r2.y = cb2[8].w * r0.x;
  r1.w = t4.Sample(s4_s, r2.xy).w;
  r2.w = 1;
  r0.x = r1.w * r2.w + -cb11[0].x;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r3.xyz = r0.yzw * cb2[8].xyz + -r0.yzw;
  r0.xyz = cb1[2].xxx * r3.xyz + r0.yzw;
  r0.xyz = max(r0.xyz, 0.0);  // ensure we don't go negative after shift
  r0.w = 1 + -v3.w;
  r1.xyz = r0.xyz * r0.www;
  r2.x = v4.x;
  r0.xyzw = r2.xxxw * r1.xyzw;
  o0.xyzw = r0.xyzw;
  o1.w = r0.w;
  o2.xyzw = r0.xyzw;
  o1.xyz = float3(1,0,0);
  return;
}