// ---- Created with 3Dmigoto v1.2.45 on Sun Jan 25 22:10:20 2026

SamplerState samClr0_s : register(s0);
Texture2D<float4> sClr0 : register(t0);


// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = sClr0.Sample(samClr0_s, v1.zy).xyzw;
  r0.w = saturate(r0.w * 2 + -1);
  r0.xyz = r0.www * r0.xyz;
  r1.xyzw = sClr0.Sample(samClr0_s, v1.xy).xyzw;
  r1.w = saturate(r1.w * 2 + -1);
  r0.xyz = r1.xyz * r1.www + r0.xyz;
  r0.w = r1.w + r0.w;
  r1.xyzw = sClr0.Sample(samClr0_s, v1.xw).xyzw;
  r1.w = saturate(r1.w * 2 + -1);
  r0.xyz = r1.xyz * r1.www + r0.xyz;
  r0.w = r1.w + r0.w;
  r1.xyzw = sClr0.Sample(samClr0_s, v1.zw).xyzw;
  r1.w = saturate(r1.w * 2 + -1);
  r0.xyz = r1.xyz * r1.www + r0.xyz;
  r0.w = r1.w + r0.w;
  o0.xyz = (r0.xyz / max(r0.www, 1e-7));
  o0.w = r0.w;
  return;
}