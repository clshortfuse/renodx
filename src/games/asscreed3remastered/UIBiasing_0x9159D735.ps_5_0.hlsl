// ---- Created with 3Dmigoto v1.3.16 on Thu May 14 14:08:21 2026

#include "./common.hlsli"

cbuffer UIBiasingConstcb : register(b5)
{

  struct
  {
    float PaperWhite;
  } g_UIBiasingConst : packoffset(c0);

}

SamplerState g_PointClampSampler_s : register(s0);
Texture2D<float4> g_InputTexture0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_InputTexture0.Sample(g_PointClampSampler_s, v1.xy).xyzw;
  r1.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.xyz;
  r1.xyz = float3(0.947867274,0.947867274,0.947867274) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(2.4000001,2.4000001,2.4000001) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
  r0.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  o0.w = r0.w;
  r0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  float paper_white = g_UIBiasingConst.PaperWhite;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    paper_white = AC3R_NATIVE_DIFFUSE_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.f);
  }
  r0.w = 1 / paper_white;
  r0.xyz = r0.xyz * r0.www;
  r1.xyz = log2(r0.xyz);
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  r0.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  o0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  return;
}
