// ---- Created with 3Dmigoto v1.3.16 on Sat Feb 07 22:54:49 2026
#include "./shared.h"

cbuffer ShaderFunction18_Uniforms : register(b0)
{
  float4 uniforms_float4[11] : packoffset(c0);
}

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);
Texture2D<float4> s0_texture : register(t0);
Texture2D<float4> s1_texture : register(t1);
Texture2D<float4> s2_texture : register(t2);
Texture2D<float4> s3_texture : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : TEXCOORD0,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(0.100000001,0.200000003,-0.5,-0.300000012);
  r1.xyz = float3(1,1,0.100000001);
  r2.xyzw = float4(0.00100000005,100,500,2);
  r3.xyzw = float4(-2,3,0,0.333333343);
  r4.xy = uniforms_float4[6].xy;
  r4.zw = v1.yx * r4.yx;
  r4.zw = uniforms_float4[7].yx + r4.zw;
  r4.zw = uniforms_float4[0].yx * r4.zw;
  r5.x = r4.w * r0.x;
  r0.xy = r0.xy;
  r1.w = r4.z * r0.x;
  r5.y = uniforms_float4[1].x + r1.w;
  r6.x = r4.w * r0.y;
  r0.y = r4.z * r0.y;
  r6.y = uniforms_float4[2].x + r0.y;
  r4.zw = uniforms_float4[3].xy;
  r4.zw = v1.xy * r4.zw;
  r4.zw = uniforms_float4[10].xy + r4.zw;
  r5.xyzw = s1_texture.Sample(s1_s, r5.xy).xyzw;
  r5.xy = r5.xy;
  r6.xyzw = s1_texture.Sample(s1_s, r6.xy).xyzw;
  r6.xy = r6.xy;
  r7.xyzw = s2_texture.Sample(s2_s, r4.zw).xzyw;
  r7.xy = r7.xy;
  r4.zw = r5.xy + r0.zz;
  r5.xy = r6.xy + r0.zz;
  r5.xy = -r5.xy;
  r4.zw = r5.xy + r4.zw;
  r0.xy = r4.zw * r0.xx;
  r0.z = r7.x + r0.z;
  r1.w = -0.400000006 * r7.y;
  r1.w = r1.w + r1.x;
  r0.z = r1.w * r0.z;
  r1.w = -r0.z;
  r0.w = max(r1.w, r0.w);
  r0.w = min(0.300000012, r0.w);
  r1.w = uniforms_float4[9].x * r0.y;
  r5.y = r1.w + r0.w;
  r5.x = uniforms_float4[9].x * r0.x;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = r0.x + r3.z;
  r0.y = cmp(r0.x == 0.000000);
  r0.w = -r0.x;
  r0.x = max(r0.x, r0.w);
  r0.x = rsqrt(r0.x);
  r0.x = r0.y ? 9.99999968e+037 : r0.x;
  r0.y = cmp(r0.x == 0.000000);
  r0.x = 1 / r0.x;
  r0.x = r0.y ? 9.99999968e+037 : r0.x;
  r0.y = 0.300000012 * r0.z;
  r0.x = r0.y + r0.x;
  r0.yz = r5.xy * r1.zy;
  r2.x = r2.x;
  r0.w = uniforms_float4[4].y * r0.z;
  r0.w = r0.w + r2.x;
  r0.yz = uniforms_float4[4].xy * r0.yz;
  r0.yz = v1.xy + r0.yz;
  r0.w = r0.w * r2.z;
  r0.w = max(0, r0.w);
  r0.w = min(1, r0.w);
  r1.y = r0.w * r3.x;
  r1.y = r1.y + r3.y;
  r0.w = r0.w * r0.w;
  r0.w = r1.y * r0.w;
  r1.yz = r0.yz * r4.xy;
  r1.yz = uniforms_float4[8].xy + r1.yz;
  r1.yz = uniforms_float4[5].xy * r1.yz;
  r2.xz = v1.xy * r4.xy;
  r2.xz = uniforms_float4[8].xy + r2.xz;
  r2.xz = uniforms_float4[5].xy * r2.xz;
  r4.xyzw = s0_texture.Sample(s0_s, r0.yz).xyzw;
  r5.xyzw = s3_texture.Sample(s3_s, r1.yz).wxyz;
  r5.x = r5.x;
  r6.xyzw = s3_texture.Sample(s3_s, r2.xz).wxyz;
  r6.x = r6.x;
  r7.xyzw = s0_texture.Sample(s0_s, v1.xy).xyzw;
  r0.y = r5.x * r2.y;
  r0.y = min(r0.y, r1.x);
  r0.z = r6.x * r2.y;
  r0.z = min(r0.z, r1.x);
  r1.y = -r0.z;
  r1.y = r1.y + r0.y;
  r0.z = r0.y + r0.z;
  r0.z = r0.z * r2.y;
  r0.z = min(r0.z, r1.x);
  r0.w = r0.w * r2.w;
  r0.w = r0.w + r1.y;
  r1.z = -r1.y;
  r1.y = max(r1.y, r1.z);
  r0.w = -1 + r0.w;
  r1.z = -r0.w;
  r0.w = max(r1.z, r0.w);
  r0.w = -r0.w;
  r0.w = r0.w + r1.x;
  r0.w = r1.y * r0.w;
  r0.w = max(0, r0.w);
  r0.w = min(1, r0.w);
  r0.w = -r0.w;
  r0.w = r0.w + r1.x;
  r0.z = r0.z * r0.w;
  r1.xyzw = -r7.xyzw;
  r1.xyzw = r4.xyzw + r1.xyzw;
  r1.xyzw = r1.xyzw * r0.zzzz;
  r1.xyzw = r7.xyzw + r1.xyzw;
  r0.z = r1.y + r1.x;
  r0.z = r1.z + r0.z;
  r0.x = r0.x * r0.z;
  r0.x = r0.y * r0.x;
  r0.x = r0.w * r0.x;
  r0.xyz = r0.xxx * r3.www;
  r1.xyz = r0.xyz + r1.xyz;
  r1.xyz = r1.xyz;
  r1.w = r1.w;
  o0.xyzw = r1.xyzw;
  o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  // o0.rgb = renodx::draw::ToneMapPass(o0.rgb);
  // o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  if (RENODX_TONE_MAP_TYPE != 0) {
    o0.rgb = renodx::draw::ToneMapPass(o0.rgb);
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  } else {
    o0.rgb = saturate(o0.rgb);
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  }
  return;
}