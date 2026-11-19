#include "./hdr.hlsli"

// cb3[6].y read live with a DevKit probe on 2026-10-17: 2.8284 (2^1.5), constant
// across frames. Custom mappers use this fixed value so the game's HDR menu
// settings cannot change their output; Vanilla still reads cb3[6].y.
// cb5[3].x varied per frame (~1.14, engine exposure) and stays live.
#define CODWW2_NATIVE_HDR_SCALE 2.8284271f

// ---- Original resources, reconstructed from the Devkit shader dump.
Texture3D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s0_s : register(s0);

cbuffer cb5 : register(b5)
{
  float4 cb5[7];
}

cbuffer cb3 : register(b3)
{
#if CODWW2_HAS_VIGNETTE
  float4 cb3[43];
#else
  float4 cb3[42];
#endif
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0,
  out float o1 : SV_TARGET1)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.Sample(s0_s, v1.xy).xyz;
  // These engine flags are integer bit patterns inside a float4 buffer.
  // Match DXBC if_nz/if_z tests without flushing small integer bits to zero.
  if (asuint(cb3[5].x) != 0u) {
    r1.xy = max(cb3[CODWW2_BLOOM_BOUNDS].xy, v1.xy);
    r1.xy = min(cb3[CODWW2_BLOOM_BOUNDS].zw, r1.xy);
    r1.xyz = t2.Sample(s2_s, r1.xy).xyz;
    r1.xyz = cb3[37].xxx * r1.xyz;
    r0.xyz = cb3[37].yyy * r0.xyz + r1.xyz;
  }
  if (asuint(cb3[5].y) != 0u) {
    r0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
    r1.x = cb3[37].w * -r0.w;
    r1.x = 1.44269502 * r1.x;
    r1.x = exp2(r1.x);
    r1.yzw = r0.www + -r0.xyz;
    r0.xyz = r1.xxx * r1.yzw + r0.xyz;
  }
  bool hdr_enabled = asuint(cb3[6].x) != 0u;
  bool renodx_hdr = hdr_enabled
      && RENODX_TONE_MAP_TYPE != CODWW2_TONE_MAP_TYPE_VANILLA
      && RENODX_PEAK_WHITE_NITS > 0.0f
      && RENODX_DIFFUSE_WHITE_NITS > 0.0f;
  if (renodx_hdr) {
    // Keep the native LUT input. Custom display mapping runs after the grade.
    r0.xyz = cb5[3].xxx * CODWW2_NATIVE_HDR_SCALE * r0.xyz;
  } else if (asuint(cb3[5].w) == 0u) {
    r1.xyz = cb5[3].xxx * r0.xyz;
    r0.xyz = cb3[6].yyy * r1.xyz;
  } else {
    r0.w = cmp(asint(cb3[5].w) == 2);
    if (r0.w != 0) {
      r1.xyz = cmp(r0.xyz < cb5[0].xxx);
      r2.xyzw = r1.xxxx ? cb5[2].xyzw : cb5[1].xyzw;
      r1.xw = r2.xy * r0.xx + r2.zw;
      r2.x = saturate(r1.x / r1.w);
      r3.xyzw = r1.yyyy ? cb5[2].xyzw : cb5[1].xyzw;
      r1.xy = r3.xy * r0.yy + r3.zw;
      r2.y = saturate(r1.x / r1.y);
      r1.xyzw = r1.zzzz ? cb5[2].xyzw : cb5[1].xyzw;
      r1.xy = r1.xy * r0.zz + r1.zw;
      r2.z = saturate(r1.x / r1.y);
      r1.xyz = log2(r2.xyz);
      r1.xyz = cb5[3].zzz * r1.xyz;
      r0.xyz = exp2(r1.xyz);
    } else {
      r0.w = cmp(asint(cb3[5].w) == 1);
      if (r0.w != 0) {
        r1.xyz = cb5[3].xxx * r0.xyz;
        r0.w = cb5[3].y * cb5[3].y;
        r2.xyz = r1.xyz / r0.www;
        r2.xyz = float3(1,1,1) + r2.xyz;
        r1.xyz = r2.xyz * r1.xyz;
        r2.xyz = r0.xyz * cb5[3].xxx + float3(1,1,1);
        r1.xyz = saturate(r1.xyz / r2.xyz);
        r1.xyz = log2(r1.xyz);
        r1.xyz = cb5[3].zzz * r1.xyz;
        r0.xyz = exp2(r1.xyz);
      } else {
        r0.w = cmp(asint(cb3[5].w) == 3);
        if (r0.w != 0) {
          r1.xyz = saturate(cb5[3].xxx * r0.xyz);
          r1.xyz = log2(r1.xyz);
          r1.xyz = cb5[3].zzz * r1.xyz;
          r0.xyz = exp2(r1.xyz);
        } else {
          r0.w = cmp(asint(cb3[5].w) == 4);
          if (r0.w != 0) {
            r0.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
            r0.w = log2(r0.w);
            r0.w = r0.w * 0.693147182 + 9.2103405;
            r0.w = max(0, r0.w);
            r0.w = 0.0492605828 * r0.w;
            r0.w = min(1, r0.w);
            r0.w = r0.w * -240 + 240;
            r1.x = 0.0166666675 * r0.w;
            r1.x = floor(r1.x);
            r0.w = r0.w * 0.0166666675 + -r1.x;
            r2.x = 1 + -r0.w;
            r2.z = 1 + -r2.x;
            r0.w = (uint)r1.x;
            switch (r0.w) {
              case 0 :              r2.xy = float2(1,0);
              r2.xyz = r2.zyx;
              break;
              case 1 :              r2.yz = float2(0,1);
              r2.xyz = r2.zyx;
              break;
              case 2 :              r2.xy = float2(0,1);
              r2.xyz = r2.yzx;
              break;
              case 3 :              r2.yz = float2(1,0);
              break;
              case 4 :              r2.xy = float2(0,1);
              break;
            }
            r1.xyz = log2(r2.zxy);
            r1.xyz = cb5[3].zzz * r1.xyz;
            r0.xyz = exp2(r1.xyz);
          }
        }
      }
    }
  }
  if (asuint(cb3[5].z) != 0u) {
    r1.x = dot(cb5[4].xyz, r0.xyz);
    r1.y = dot(cb5[5].xyz, r0.xyz);
    r1.z = dot(cb5[6].xyz, r0.xyz);
    r0.xyz = r1.xyz;
  }
#if CODWW2_HAS_VIGNETTE
  r1.xy = -cb3[40].xy + v1.xy;
  r1.zw = rcp(cb3[40].zw);
  r1.xy = r1.xy * r1.zw + float2(-0.5,-0.5);
  r1.xy = cb3[39].xy * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = log2(r0.w);
  r0.w = cb3[39].w * r0.w;
  r0.w = exp2(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = -r0.w * cb3[39].z + 1;
  r0.xyz = r0.xyz * r0.www;
#endif
  if (hdr_enabled) {
    r1.x = dot(float3(0.627399981,0.329299986,0.0432999991), r0.xyz);
    r1.y = dot(float3(0.0691,0.919499993,0.0114000002), r0.xyz);
    r1.z = dot(float3(0.0164000001,0.0879999995,0.895600021), r0.xyz);
    float3 pre_lut_bt2020 = r1.xyz;
    if (asuint(cb3[8].w) != 0u) {
      r2.xyz = float3(0.0009765625,0.0009765625,0.0009765625) + r1.xyz;
      r2.xyz = log2(r2.xyz);
      r2.xyz = float3(10,10,10) + r2.xyz;
      r2.xyz = saturate(float3(0.0500000007,0.0500000007,0.0500000007) * r2.xyz);
      r2.xyz = r2.xyz * cb3[8].xyz + cb3[9].xyz;
      r1.xyz = t3.Sample(s3_s, r2.xyz).xyz;
      if (renodx_hdr) {
        r1.xyz = CODWW2MapHDR(pre_lut_bt2020, r1.xyz, t3, s3_s, cb3[8].xyz, cb3[9].xyz);
      }
    }
  } else {
    r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
    r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = r0.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r1.xyz = r2.xyz ? r3.xyz : r0.xyz;
  }
  o1.x = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  o0.xyz = r1.xyz;
  o0.w = 1;
  return;
}
