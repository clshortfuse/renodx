#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Mon May 05 09:43:18 2025

cbuffer _Globals : register(b0)
{
  float cameraNearTimesFar : packoffset(c0);
  float cameraFarMinusNear : packoffset(c0.y);
  float4 cameraNearFar : packoffset(c1);
  float sharpMult : packoffset(c2);
  float bloomMult : packoffset(c2.y);
  float dofIntMult : packoffset(c2.z);
}

SamplerState LinearClampSampler_s : register(s9);
Texture2DMS<float4> texSharpMSAA : register(t0);
Texture2D<float4> texBloom : register(t1);
Texture2D<float4> texBlur : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  texSharpMSAA.GetDimensions(uiDest.x, uiDest.y, uiDest.z);
  r0.xy = uiDest.xy;
  texSharpMSAA.GetDimensions(uiDest.x, uiDest.y, uiDest.z);
  r0.z = uiDest.z;
  r0.x = r0.x;
  r0.y = r0.y;
  r1.xyzw = int4(0,0,0,0);
  r2.x = (uint)r0.x;
  r2.y = (uint)r0.y;
  r0.xy = v1.xy * r2.xy;
  r0.w = 0;
  r2.xyzw = r1.xyzw;
  r3.x = r0.w;
  while (true) {
    r3.y = cmp((uint)r3.x < (uint)r0.z);
    if (r3.y == 0) break;
    r4.xy = (int2)r0.xy;
    r4.zw = float2(0,0);
    r4.xyzw = texSharpMSAA.Load(r4.xy, r3.x).xyzw;
    r2.xyzw = r4.xyzw + r2.xyzw;
    r3.x = (int)r3.x + 1;
  }
  r0.x = (uint)r0.z;
  r0.xyzw = r2.xyzw / r0.xxxx;
  r1.xyz = texBloom.Sample(LinearClampSampler_s, v1.xy).xyz;
  r1.xyz = r1.xyz;
  r2.xyzw = texBlur.Sample(LinearClampSampler_s, v1.xy).xyzw;
  r0.w = dofIntMult * r0.w;
  r0.w = max(0, r0.w);
  r0.w = min(1, r0.w);
  r0.w = max(r0.w, r2.w);
  r3.xyz = -r0.xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r2.xyz = r2.xyz * r0.www;
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = sharpMult * r0.xyz;
  r1.xyz = bloomMult * r1.xyz * CUSTOM_BLOOM;
  r0.xyz = r1.xyz + r0.xyz;

  float3 hdr_color = r0.rgb;
  float3 hdr_color_tm = HermiteSplineRolloff(r0.rgb);

  if (RENODX_TONE_MAP_TYPE == 0) {
  r1.xyz = float3(-0.00400000019, -0.00400000019, -0.00400000019);
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(float3(64,64,64), r0.xyz);
  r1.xyz = float3(6.19999981,6.19999981,6.19999981) * r0.xyz;
  r1.xyz = float3(0.5,0.5,0.5) + r1.xyz;
  r1.xyz = r1.xyz * r0.xyz;
  r2.xyz = float3(6.19999981,6.19999981,6.19999981) * r0.xyz;
  r2.xyz = float3(1.70000005,1.70000005,1.70000005) + r2.xyz;
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = float3(0.0599999987,0.0599999987,0.0599999987) + r0.xyz;
  r0.xyz = r1.xyz / r0.xyz;
  o0.xyz = r0.xyz;
  } else {
    r1.xyz = float3(-0.00300000019, -0.00300000019, -0.00300000019);
    r0.xyz = r1.xyz + r0.xyz;
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r0.xyz = min(float3(64, 64, 64), r0.xyz);
    r1.xyz = float3(6.49999981, 6.49999981, 6.49999981) * r0.xyz;
    r1.xyz = float3(0.5, 0.5, 0.5) + r1.xyz;
    r1.xyz = r1.xyz * r0.xyz;
    r2.xyz = float3(4.59999981, 4.59999981, 4.59999981) * r0.xyz;
    r2.xyz = float3(1.30000005, 1.30000005, 1.30000005) + r2.xyz;
    r0.xyz = r2.xyz * r0.xyz;
    r0.xyz = float3(0.0509999987, 0.0509999987, 0.0509999987) + r0.xyz;
    r0.xyz = r1.xyz / r0.xyz;
    o0.xyz = r0.xyz;  
  }

  float3 sdr_color = renodx::color::srgb::DecodeSafe(o0.rgb);
  o0.rgb = ToneMapPass(hdr_color, sdr_color, hdr_color_tm, v1);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

  o0.w = 1;
  return;
}