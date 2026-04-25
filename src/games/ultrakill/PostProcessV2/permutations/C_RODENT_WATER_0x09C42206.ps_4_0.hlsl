// ---- Created with 3Dmigoto v1.3.16 on Thu Apr 02 14:27:42 2026
#include "..\..\shared.h"
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[1];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb1[0].y * cb0[4].z;
  r0.x = 0.00999999978 * r0.x;
  r0.yz = v1.xy / v1.ww;
  r1.xy = cb0[4].xx * r0.yz;
  r1.zw = r1.xy * float2(0.100000001,0.100000001) + r0.xx;
  r0.xw = r1.xy * float2(0.100000001,0.100000001) + -r0.xx;
  r2.xyzw = t0.Sample(s0_s, r0.xw).xyzw;
  r0.xw = r2.xy * float2(2,2) + float2(-1,-1);
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
  r0.xw = r1.xy * r0.xw;
  r0.xw = cb0[4].yy * r0.xw;
  r0.xy = -r0.xw * float2(0.00999999978,0.00999999978) + r0.yz;
  r1.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r2.xyz = cb0[3].xyz + -r1.xyz;
  r1.xyz = cb0[3].www * r2.xyz + r1.xyz;
  r2.xyz = cb0[2].xyz + -r1.xyz;
  r1.xyz = cb0[2].www * r2.xyz + r1.xyz;
  r2.xyz = r1.xyz * r1.xyz;
  r3.xyzw = float4(0.25,0.25,0.0625,0.0625) * cb0[5].xyxy;
  r4.xyzw = r3.xyzw * r0.xyxy;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = -1 + r0.x;
  r5.xyzw = t2.Sample(s2_s, r4.zw).xyzw;
  r4.xyzw = floor(r4.xyzw);
  r3.xyzw = r4.xyzw / r3.xyzw;
  r0.yzw = -r5.xyz * float3(2,2,2) + float3(1,1,1);
  r4.xyz = r5.xyz * r1.xyz;
  r4.xyz = r4.xyz + r4.xyz;
  r0.yzw = r2.xyz * r0.yzw + r4.xyz;
  r0.yzw = r0.yzw + -r1.xyz;
  r1.w = saturate(cb0[6].x);
  r0.yzw = r1.www * r0.yzw + r1.xyz;
  r1.x = max(2, asint(cb0[5].z));
  r1.x = (int)r1.x;
  r0.yzw = r1.xxx * r0.yzw;
  r0.yzw = floor(r0.yzw);
  r0.yzw = r0.yzw / r1.xxx;
  r1.xyz = float3(12.3450003,67.8899994,15) * cb1[0].www;
  r1.z = floor(r1.z);
  r1.zw = float2(12.3450003,67.8899994) * r1.zz;
  r2.x = dot(r3.zw, r1.zw);
  r2.x = sin(r2.x);
  r2.x = 12345.6787 * r2.x;
  r2.x = frac(r2.x);
  r4.xyzw = float4(9.99999975e-005,9.99999975e-005,0.000199999995,0.000199999995) + r3.zwzw;
  r2.w = dot(r4.xy, r1.zw);
  r1.z = dot(r4.zw, r1.zw);
  r1.z = sin(r1.z);
  r1.z = 12345.6787 * r1.z;
  r2.z = frac(r1.z);
  r1.z = sin(r2.w);
  r1.z = 12345.6787 * r1.z;
  r2.y = frac(r1.z);
  r2.xyz = float3(-0.899999976,-0.899999976,-0.899999976) + r2.xyz;
  r2.xyz = ceil(r2.xyz);
  r1.z = dot(r3.xy, r1.xy);
  r1.z = sin(r1.z);
  r1.z = r1.z * 12345.6787 + cb1[0].w;
  r4.x = frac(r1.z);
  r5.xyzw = float4(1,1,2,2) + r3.xyxy;
  r1.z = dot(r5.xy, r1.xy);
  r1.x = dot(r5.zw, r1.xy);
  r1.x = sin(r1.x);
  r1.x = r1.x * 12345.6787 + cb1[0].w;
  r4.z = frac(r1.x);
  r1.x = sin(r1.z);
  r1.x = r1.x * 12345.6787 + cb1[0].w;
  r4.y = frac(r1.x);
  r1.xyz = r2.xyz * float3(0.5,0.5,0.5) + r4.xyz;
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1.99000001,-1.99000001,-1.99000001);
  r1.xyz = ceil(r1.xyz);
  r1.xyz = r4.xyz * float3(0.100000001,0.100000001,0.100000001) + r1.xyz;
  r1.w = 0.333333343 * cb0[6].y;
  r1.w = saturate(r1.w);
  r1.xyz = r1.xyz * r1.www;
  r2.x = r1.w + r1.w;
  r1.w = log2(r1.w);
  r1.w = 1.75 * r1.w;
  r1.w = exp2(r1.w);
  r1.w = r1.w * -0.100000024 + 1;
  r2.x = min(1, r2.x);
  r0.x = r2.x * r0.x + 1;
  r0.xyz = saturate(r0.yzw * r0.xxx + r1.xyz);
  r0.w = floor(cb1[0].w);
  r1.xy = float2(12.3450003,67.8899994) * r0.ww;
  r0.w = dot(r3.xy, r1.xy);
  r0.w = sin(r0.w);
  r0.w = 12345.6787 * r0.w;
  r0.w = frac(r0.w);
  r0.w = r0.w + -r1.w;
  r0.w = ceil(r0.w);
  r0.w = max(0, r0.w);
  r0.xyz = r0.xyz + r0.www;

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