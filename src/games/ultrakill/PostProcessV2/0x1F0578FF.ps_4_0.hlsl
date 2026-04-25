// ---- Created with 3Dmigoto v1.3.16 on Thu Apr 02 14:27:42 2026
#include "../shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
}


// 3Dmigoto declarations2222
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.zw = cb0[5].xy * r0.xy;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xy = float2(0.0625,0.0625) * r0.zw;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r2.xyz = -r0.xyz * float3(2,2,2) + float3(1,1,1);
  r3.xyz = cb0[3].xyz + -r1.xyz;
  r1.xyz = cb0[3].www * r3.xyz + r1.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = r0.xyz + r0.xyz;
  r3.xyz = r1.xyz * r1.xyz;
  r0.xyz = r3.xyz * r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.w = saturate(cb0[6].x);
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r0.w = max(2, asint(cb0[5].z));
  r0.w = (int)r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = floor(r0.xyz);
  r0.xyz = r0.xyz / r0.www;

  // unsafe POW fix part 1

  float3 signs = sign(r0.rgb);
  r0.rgb = abs(r0.rgb);
  
  // unsafe POW fix part 1 end

  r0.xyz = log2(r0.xyz);
  r0.w = -cb0[6].w * 0.5 + 1;
  r0.w = r0.w + r0.w;
  r0.w = max(0.00999999978, r0.w);
  r0.xyz = r0.www * r0.xyz;
  o0.xyz = exp2(r0.xyz);

  // unsafe POW fix part 2

  o0.rgb = signs * o0.rgb;
  
  // unsafe POW fix part 2 end
  
  // tonemap pass
  o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  if (RENODX_TONE_MAP_TYPE != 0) {
    o0.rgb = renodx::draw::ToneMapPass(o0.rgb);
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  } else {
    o0.rgb = saturate(o0.rgb);
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  }

  o0.w = 1;
  return;
}
