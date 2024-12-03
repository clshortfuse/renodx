// ---- Created with 3Dmigoto v1.3.16 on Tue Dec  3 16:00:04 2024



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD0,
  float3 v3 : TEXCOORD2,
  out float4 o0 : SV_TARGET0)
{
  o0.xyz = v1.xyz * v1.www;
  o0.w = v1.w;
  o0 = saturate(o0);
  return;
}