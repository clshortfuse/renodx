// ---- Created with 3Dmigoto v1.3.16 on Mon Apr 27 11:58:22 2026
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

cbuffer cb2 : register(b2)
{
  float4 cb2[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float3 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;
  r0.x = t2.Sample(s2_s, v1.xy).x;
  r1.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r0.x = max(0, r0.x);      // clamp mask
  r1.xyz = max(0, r1.xyz);  // clamp color
  r0.xyzw = r1.xyzw * r0.xxxx;
  o0.xyzw = cb2[0].xxxx * r0.xyzw;
  o0.xyzw = max(0, o0.xyzw);
  return;
}