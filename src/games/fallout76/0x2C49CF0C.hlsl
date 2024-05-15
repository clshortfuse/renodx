// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:50 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;
  
  /* code block also appears in LUT shader */
  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = log2(r0.xyz);
  o0.w = r0.w;
  r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  return;
}