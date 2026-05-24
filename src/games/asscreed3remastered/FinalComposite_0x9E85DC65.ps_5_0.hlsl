// ---- Created with 3Dmigoto v1.3.16 on Thu May 14 14:08:21 2026

#include "./common.hlsli"

cbuffer FinalCompositingConstscb : register(b12)
{

  struct
  {
    float Brightness;
    float MaxNitsHDRTV;
    float PaperWhite;
  } g_FinalCompositingConsts : packoffset(c0);

}

SamplerState g_PointClampSampler_s : register(s0);
SamplerState g_TrilinearClampSampler_s : register(s1);
Texture2D<float4> g_InputTexture0 : register(t0);
Texture3D<float4> g_FinalCompositingLUT : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    r0.xyzw = g_InputTexture0.Sample(g_PointClampSampler_s, v1.xy).xyzw;
    o0.xyz = ApplyAC3RDisplayTransformToScRGB(DecodeAC3RSceneIntermediate(r0.xyz));
    o0.xyz = ApplyAC3RRCAS(o0.xyz, v1.xy, g_InputTexture0, g_PointClampSampler_s);
    o0.xyz = ApplyAC3RFilmGrain(o0.xyz, v1.xy);
    o0.w = r0.w;
    return;
  }

  r0.x = log2(g_FinalCompositingConsts.MaxNitsHDRTV);
  r0.x = 0.416666657 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.x * 1.05499995 + -0.0549999997;
  r0.y = cmp(0.00313080009 >= g_FinalCompositingConsts.MaxNitsHDRTV);
  r0.z = 12.9200001 * g_FinalCompositingConsts.MaxNitsHDRTV;
  r0.x = r0.y ? r0.z : r0.x;
  r0.yzw = g_InputTexture0.Sample(g_PointClampSampler_s, v1.xy).xyz;
  r0.yzw = max(float3(0,0,0), r0.yzw);
  r0.xyz = r0.yzw / r0.xxx;
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r0.xyzw = g_FinalCompositingLUT.SampleLevel(g_TrilinearClampSampler_s, r0.xyz, 0).xyzw;
  r0.xyz = log2(abs(r0.xyz));
  o0.w = r0.w;
  r0.xyz = g_FinalCompositingConsts.Brightness * r0.xyz;
  r0.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r0.xyz;
  r0.xyz = -r0.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(6.27739477,6.27739477,6.27739477) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(10000,10000,10000) * r0.xyz;
  r1.x = dot(r0.xyz, float3(0.636958063,0.144616902,0.168880969));
  r1.y = dot(r0.xyz, float3(0.2627002,0.677998066,0.0593017153));
  r1.z = dot(r0.xyz, float3(4.99410659e-017,0.0280726925,1.06098509));
  r0.x = dot(r1.xyz, float3(3.2409699,-1.5373832,-0.498610765));
  r0.y = dot(r1.xyz, float3(-0.969243646,1.8759675,0.0415550582));
  r0.z = dot(r1.xyz, float3(0.0556300804,-0.203976959,1.05697155));
  o0.xyz = float3(0.0125000002,0.0125000002,0.0125000002) * r0.xyz;
  return;
}
