#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Thu Feb 26 15:03:02 2026

cbuffer ShaderFunction4_Uniforms : register(b0)
{
  float4 uniforms_float4[7] : packoffset(c0);
}

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
Texture2D<float4> s0_texture : register(t0);
Texture2D<float4> s1_texture : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : TEXCOORD0,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(1.875,1.0546875,6.28318548,-3.14159274);
  r1.xyzw = float4(0.0078125,0.0245312508,7.20253038,0.5);
  r2.xyz = float3(1,0,1.77777779);
  r2.w = 128;
  r3.xyzw = s0_texture.Sample(s0_s, v1.xy).xyzw;

  float4 before_bloom = r3;

  r2.xyz = r2.xyz;
  r2.xy = r2.xy;
  r4.xy = uniforms_float4[1].xx * r2.yx;
  r4.xy = r4.xy + r2.xy;
  r4.zw = uniforms_float4[1].xx * r2.xy;
  r4.zw = r4.zw + r2.yz;
  r5.xyz = r2.yyy;
  r6.xyzw = r2.yyyy;
  r2.y = r2.y;
  r2.z = 0;
  r7.xyz = r5.xyz;
  r8.xyz = r6.xyz;
  r5.w = r2.y;
  r8.w = r6.w;
  r9.x = r2.z;
  while (true) {
    r9.y = cmp((int)r9.x < (int)r2.w);
    if (r9.y == 0) break;
    r9.yz = r5.ww * r1.xy;
    r9.w = cmp(r9.y == 0.000000);
    r10.x = -r9.y;
    r9.y = max(r10.x, r9.y);
    r9.y = rsqrt(r9.y);
    r9.y = r9.w ? 9.99999968e+37 : r9.y;
    r9.w = cmp(r9.y == 0.000000);
    r9.y = 1 / r9.y;
    r9.y = r9.w ? 9.99999968e+37 : r9.y;
    r9.w = r9.y * r1.z;
    r9.w = r9.w + r1.w;
    r9.w = frac(r9.w);
    r9.w = r9.w * r0.z;
    r9.w = r9.w + r0.w;
    r10.y = cos(r9.w);
    r10.x = sin(r9.w);
    r9.yw = r10.xy * r9.yy;
    r9.yw = r9.yw * r4.xy;
    r9.yw = r9.yw * r4.zw;
    r9.yw = v1.xy + r9.yw;
    r10.xyzw = s0_texture.Sample(s0_s, r9.yw).xyzw;
    r9.y = cos(r9.z);
    r9.y = r9.y + r2.x;
    r10.xyz = r10.xyz * r10.xyz;
    r10.xyz = r10.www * r10.xyz;
    r10.xyz = r10.xyz * r9.yyy;
    r7.xyz = r10.xyz + r7.xyz;
    r9.z = -uniforms_float4[0].x;
    r9.z = r9.z + r5.w;
    r7.w = r9.y + r8.w;
    r9.y = cmp(r9.z >= 0);
    r8.xyzw = r9.yyyy ? r8.xyzw : r7.xyzw;
    r5.w = r5.w + r2.x;
    r9.x = (int)r9.x + 1;
  }
  r0.z = cmp(r8.w == 0.000000);
  r0.w = 1 / r8.w;
  r0.z = r0.z ? 9.99999968e+37 : r0.w;
  r1.yzw = r0.zzz * r8.xyz;
  r2.xyz = r3.xyz * r3.xyz;
  r1.yzw = -r1.yzw;
  r1.yzw = r2.xyz + r1.yzw;
  r1.yzw = uniforms_float4[4].xxx * r1.yzw;
  r1.yzw = r1.yzw + r3.xyz;
  r0.xy = r0.xy;

  float3 before_filmgrain = r1.yzw;
  if (CUSTOM_FILM_GRAIN_TYPE != 0) {
    before_filmgrain = renodx::color::srgb::DecodeSafe(before_filmgrain);
    r0.xyz = renodx::effects::ApplyFilmGrain(before_filmgrain, v1.xy, CUSTOM_RANDOM, CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  } else {
    r0.xy = v1.xy * r0.xy;
    r0.xy = uniforms_float4[5].xy + r0.xy;
    r0.xyzw = s1_texture.Sample(s1_s, r0.xy).xyzw;
    r0.xyz = r0.xyz;
    r0.xyz = float3(-0.5, -0.5, -0.5) + r0.xyz;
    r0.xyz = uniforms_float4[6].xxx * r0.xyz;
    r0.xyz = r0.xyz + r1.yzw;
  }

  r7.xyz *= CUSTOM_BLOOM;

  r1.xyz = r7.xyz * r1.xxx;
  r2.x = log2(r1.x);
  r2.y = log2(r1.y);
  r2.z = log2(r1.z);
  r1.xyz = uniforms_float4[3].xxx * r2.xyz;
  r2.x = exp2(r1.x);
  r2.y = exp2(r1.y);
  r2.z = exp2(r1.z);
  r1.xyz = uniforms_float4[2].xxx * r2.xyz;

  //r1.xyz *= 0.f;

  r0.xyz = max(r1.xyz, r0.xyz);
  r3.w = r3.w;
  o0.xyz = r0.xyz;
  o0.w = r3.w;

  //o0.xyz = before_filmgrain.xyz;
  return;
}