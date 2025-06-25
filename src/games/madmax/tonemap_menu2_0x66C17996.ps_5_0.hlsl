// ---- Created with 3Dmigoto v1.4.1 on Sun Jun 22 10:06:11 2025

cbuffer cbInstanceConsts : register(b1)
{
  float4 InstanceConsts : packoffset(c0);
}

cbuffer cbTypeConsts : register(b2)
{
  float4 TypeConsts[2] : packoffset(c0);
}

SamplerState DiffuseMap_s : register(s0);
Texture2D<float4> DiffuseMap : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = DiffuseMap.Sample(DiffuseMap_s, v1.xy).xyzw;
  r1.x = cmp(r0.w == 0.000000);
  r0.xyzw = InstanceConsts.xyzw * r0.xyzw;
  r0.xyzw = r1.xxxx ? float4(0, 0, 0, 0) : r0.xyzw;
  // r0.xyz = log2(r0.xyz);
  o0.w = r0.w;
  //r0.xyz = TypeConsts[1].xxx * r0.xyz;
  // o0.xyz = exp2(r0.xyz);
  o0.rgb = r0.rgb;
  return;
}