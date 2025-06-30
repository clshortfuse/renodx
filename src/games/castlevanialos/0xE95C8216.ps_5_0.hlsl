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

  r0.xyzw = t0.Sample(s0_s, v5.xy).xyzw;
 //r0.xyzw = (int4)r0.xyzw & asint(cb3[44].xyzw);
 //r0.xyzw = (int4)r0.xyzw | asint(cb3[45].xyzw);
  r0.xyz = cb4[8].xxx * r0.xyz;
  r1.x = max(r0.z, r0.y);
  r2.x = max(r1.x, r0.x);
  r1.x = r0.w * cb4[11].x + r2.x;
  r0.xyzw = float4(-0,-0,-0,-1) + r0.xyzw;
  r1.y = -cb4[9].x + r1.x;
  r1.x = cb4[9].x + -r1.x;

   r1.y = saturate(cb4[10].x * r1.y);

  r0.xyzw = r1.yyyy * r0.xyzw + float4(0,0,0,1);
  r3.xyzw = cmp(r1.xxxx >= float4(0,0,0,0));
  o0.xyzw = r3.xyzw ? float4(0,0,0,1) : r0.xyzw;
  return;
}