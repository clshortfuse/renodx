// ---- Created with 3Dmigoto v1.3.16 on Thu Apr 02 14:27:42 2026
#include "..\..\shared.h"
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[1];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[10];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(128,128) / cb0[8].zw;
  r0.zw = float2(1,1) + -r0.xy;
  r1.xy = r0.zw + -r0.xy;
  r1.zw = v1.xy / v1.ww;
  r2.xy = r1.zw + -r0.xy;
  r1.xy = r2.xy / r1.xy;
  r1.xy = r1.xy * float2(0.5,0.5) + float2(0.25,0.25);
  r2.xy = r1.zw / r0.xy;
  r0.xy = cmp(r0.xy < r1.zw);
  r2.xy = float2(0.25,0.25) * r2.xy;
  r0.xy = r0.xy ? r1.xy : r2.xy;
  r1.xy = float2(1,1) + -r0.zw;
  r2.xy = r1.zw + -r0.zw;
  r0.zw = cmp(r0.zw < r1.zw);
  r1.xy = r2.xy / r1.xy;
  r1.xy = r1.xy * float2(0.25,0.25) + float2(0.75,0.75);
  r0.xy = r0.zw ? r1.xy : r0.xy;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.x = cb0[9].w * r0.w;
  r0.yz = cb0[4].xx * r1.zw;
  r0.w = cb1[0].y * cb0[4].z;
  r0.w = 0.00999999978 * r0.w;
  r1.xy = r0.yz * float2(0.100000001,0.100000001) + r0.ww;
  r0.yz = r0.yz * float2(0.100000001,0.100000001) + -r0.ww;
  r2.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  r0.yz = r2.xy * float2(2,2) + float2(-1,-1);
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xy = r2.xy * float2(2,2) + float2(-1,-1);
  r0.yz = r1.xy * r0.yz;
  r0.yz = cb0[4].yy * r0.yz;
  r0.yz = -r0.yz * float2(0.00999999978,0.00999999978) + r1.zw;
  r1.xy = cb0[5].xy * r0.yz;
  r2.xyzw = t2.Sample(s2_s, r0.yz).xyzw;
  r0.yz = float2(0.0625,0.0625) * r1.xy;
  r1.xyzw = t3.Sample(s3_s, r0.yz).xyzw;
  r0.yzw = -r1.xyz * float3(2,2,2) + float3(1,1,1);
  r3.xyz = cb0[3].xyz + -r2.xyz;
  r2.xyz = cb0[3].www * r3.xyz + r2.xyz;
  r3.xyz = cb0[2].xyz + -r2.xyz;
  r2.xyz = cb0[2].www * r3.xyz + r2.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = r1.xyz + r1.xyz;
  r3.xyz = r2.xyz * r2.xyz;
  r0.yzw = r3.xyz * r0.yzw + r1.xyz;
  r0.yzw = r0.yzw + -r2.xyz;
  r1.x = saturate(cb0[6].x);
  r0.yzw = r1.xxx * r0.yzw + r2.xyz;
  r1.x = max(2, asint(cb0[5].z));
  r1.x = (int)r1.x;
  r0.yzw = r1.xxx * r0.yzw;
  r0.yzw = floor(r0.yzw);
  r0.yzw = r0.yzw / r1.xxx;
  r1.xyz = cb0[9].xyz + -r0.yzw;
  r0.xyz = r0.xxx * r1.xyz + r0.yzw;

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