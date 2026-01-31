#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Fri Jan 30 01:59:38 2026

cbuffer cbRenewFilterInfo : register(b2) {
  float4 g_cbScreenScale : packoffset(c0);
  float4 g_cbNoiseInfo : packoffset(c1);
  float4 g_cbHPassInfo : packoffset(c2);
  float4 g_cbMinMaxUV : packoffset(c3);
  float4 g_cbColorInfo : packoffset(c4);
}

SamplerState samplePoint_s : register(s8);
Texture2D<float4> g_tFilterInput : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  const float4 icb[] = { { 91, 0, 0, 0 },
                         { 90, 0, 0, 0 },
                         { 15, 0, 0, 0 },
                         { 13, 0, 0, 0 },
                         { 95, 0, 0, 0 },
                         { 96, 0, 0, 0 },
                         { 53, 0, 0, 0 },
                         { 7, 0, 0, 0 },
                         { 36, 0, 0, 0 },
                         { 103, 0, 0, 0 },
                         { 30, 0, 0, 0 },
                         { 69, 0, 0, 0 },
                         { 8, 0, 0, 0 },
                         { 99, 0, 0, 0 },
                         { 37, 0, 0, 0 },
                         { 21, 0, 0, 0 },
                         { 10, 0, 0, 0 },
                         { 23, 0, 0, 0 },
                         { 6, 0, 0, 0 },
                         { 120, 0, 0, 0 },
                         { 75, 0, 0, 0 },
                         { 0, 0, 0, 0 },
                         { 26, 0, 0, 0 },
                         { 62, 0, 0, 0 },
                         { 94, 0, 0, 0 },
                         { 117, 0, 0, 0 },
                         { 35, 0, 0, 0 },
                         { 11, 0, 0, 0 },
                         { 32, 0, 0, 0 },
                         { 57, 0, 0, 0 },
                         { 33, 0, 0, 0 },
                         { 88, 0, 0, 0 },
                         { 56, 0, 0, 0 },
                         { 87, 0, 0, 0 },
                         { 20, 0, 0, 0 },
                         { 125, 0, 0, 0 },
                         { 68, 0, 0, 0 },
                         { 74, 0, 0, 0 },
                         { 71, 0, 0, 0 },
                         { 48, 0, 0, 0 },
                         { 27, 0, 0, 0 },
                         { 77, 0, 0, 0 },
                         { 83, 0, 0, 0 },
                         { 111, 0, 0, 0 },
                         { 122, 0, 0, 0 },
                         { 60, 0, 0, 0 },
                         { 105, 0, 0, 0 },
                         { 92, 0, 0, 0 },
                         { 41, 0, 0, 0 },
                         { 55, 0, 0, 0 },
                         { 46, 0, 0, 0 },
                         { 40, 0, 0, 0 },
                         { 102, 0, 0, 0 },
                         { 54, 0, 0, 0 },
                         { 65, 0, 0, 0 },
                         { 25, 0, 0, 0 },
                         { 63, 0, 0, 0 },
                         { 1, 0, 0, 0 },
                         { 80, 0, 0, 0 },
                         { 73, 0, 0, 0 },
                         { 76, 0, 0, 0 },
                         { 89, 0, 0, 0 },
                         { 18, 0, 0, 0 },
                         { 116, 0, 0, 0 },
                         { 86, 0, 0, 0 },
                         { 100, 0, 0, 0 },
                         { 109, 0, 0, 0 },
                         { 3, 0, 0, 0 },
                         { 64, 0, 0, 0 },
                         { 52, 0, 0, 0 },
                         { 124, 0, 0, 0 },
                         { 123, 0, 0, 0 },
                         { 5, 0, 0, 0 },
                         { 38, 0, 0, 0 },
                         { 118, 0, 0, 0 },
                         { 126, 0, 0, 0 },
                         { 82, 0, 0, 0 },
                         { 85, 0, 0, 0 },
                         { 59, 0, 0, 0 },
                         { 47, 0, 0, 0 },
                         { 16, 0, 0, 0 },
                         { 58, 0, 0, 0 },
                         { 17, 0, 0, 0 },
                         { 28, 0, 0, 0 },
                         { 42, 0, 0, 0 },
                         { 119, 0, 0, 0 },
                         { 2, 0, 0, 0 },
                         { 44, 0, 0, 0 },
                         { 70, 0, 0, 0 },
                         { 101, 0, 0, 0 },
                         { 43, 0, 0, 0 },
                         { 9, 0, 0, 0 },
                         { 22, 0, 0, 0 },
                         { 39, 0, 0, 0 },
                         { 19, 0, 0, 0 },
                         { 98, 0, 0, 0 },
                         { 108, 0, 0, 0 },
                         { 110, 0, 0, 0 },
                         { 79, 0, 0, 0 },
                         { 113, 0, 0, 0 },
                         { 112, 0, 0, 0 },
                         { 104, 0, 0, 0 },
                         { 97, 0, 0, 0 },
                         { 34, 0, 0, 0 },
                         { 12, 0, 0, 0 },
                         { 81, 0, 0, 0 },
                         { 51, 0, 0, 0 },
                         { 14, 0, 0, 0 },
                         { 107, 0, 0, 0 },
                         { 49, 0, 0, 0 },
                         { 31, 0, 0, 0 },
                         { 106, 0, 0, 0 },
                         { 84, 0, 0, 0 },
                         { 115, 0, 0, 0 },
                         { 121, 0, 0, 0 },
                         { 50, 0, 0, 0 },
                         { 45, 0, 0, 0 },
                         { 127, 0, 0, 0 },
                         { 4, 0, 0, 0 },
                         { 93, 0, 0, 0 },
                         { 114, 0, 0, 0 },
                         { 67, 0, 0, 0 },
                         { 29, 0, 0, 0 },
                         { 24, 0, 0, 0 },
                         { 72, 0, 0, 0 },
                         { 78, 0, 0, 0 },
                         { 66, 0, 0, 0 },
                         { 61, 0, 0, 0 } };
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (CUSTOM_FILM_GRAIN_TYPE != 0 && CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    o0 = g_tFilterInput.SampleLevel(samplePoint_s, v1.xy, 0).xyzw;
    o0.xyz = renodx::effects::ApplyFilmGrain(
        o0.rgb,
        v1.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
        1.f);  // if 1.f = SDR range

    return;
  }

  r0.xy = g_cbNoiseInfo.xy * v1.xy;
  r0.xy = floor(r0.xy);
  r0.xy = (uint2)r0.xy;
  r0.z = (int)r0.x & 1;
  r0.z = r0.z ? r0.x : r0.y;
  r0.x = (int)r0.y + (int)r0.x;
  r0.x = (int)r0.x & 127;
  r0.x = 1 + (int)icb[r0.x + 0].x;
  r0.x = (int)r0.z + (int)r0.x;
  r0.y = (uint)g_cbNoiseInfo.w;
  r0.x = (int)r0.y + (int)r0.x;
  r0.x = (int)r0.x & 127;
  r0.x = 0x010dcd00 * (int)icb[r0.x + 0].x;
  r0.x = (uint)r0.x >> 16;
  r0.x = (uint)r0.x;
  r1.x = r0.x * 1.52590219e-05 + 0.25;
  r2.xyzw = v1.xyxy * g_cbNoiseInfo.xyxy + float4(1.33000004, 1.33000004, -1.66999996, -1.66999996);
  r2.xyzw = floor(r2.xyzw);
  r2.xyzw = (uint4)r2.xyzw;
  r0.xz = (int2)r2.xz & int2(1, 1);
  r0.xz = r0.xz ? r2.xz : r2.yw;
  r2.xy = (int2)r2.yw + (int2)r2.xz;
  r2.xy = (int2)r2.xy & int2(127, 127);
  r0.w = 1 + (int)icb[r2.x + 0].x;
  r1.w = 1 + (int)icb[r2.y + 0].x;
  r0.z = (int)r0.z + (int)r1.w;
  r0.x = (int)r0.x + (int)r0.w;
  r0.x = (int)r0.y + (int)r0.x;
  r0.y = (int)r0.y + (int)r0.z;
  r0.xy = (int2)r0.xy & int2(127, 127);
  r0.y = 0x010dcd00 * (int)icb[r0.y + 0].x;
  r0.y = (uint)r0.y >> 16;
  r0.y = (uint)r0.y;
  r1.z = r0.y * 1.52590219e-05 + 0.25;
  r0.x = 0x010dcd00 * (int)icb[r0.x + 0].x;
  r0.x = (uint)r0.x >> 16;
  r0.x = (uint)r0.x;
  r1.y = r0.x * 1.52590219e-05 + 0.25;
  r0.xyz = float3(1, 1, 1) + -r1.xyz;
  r2.xyzw = g_tFilterInput.SampleLevel(samplePoint_s, v1.xy, 0).xyzw;
  r3.xyz = float3(1, 1, 1) + -r2.xyz;
  r0.xyz = r3.xyz * r0.xyz;
  r0.xyz = -r0.xyz * float3(2, 2, 2) + float3(1, 1, 1);
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = r1.xyz + r1.xyz;
  r3.xyz = cmp(r2.xyz < float3(0.5, 0.5, 0.5));
  r0.xyz = r3.xyz ? r1.xyz : r0.xyz;
  r0.xyz = r0.xyz + -r2.xyz;
  r0.xyz = g_cbNoiseInfo.zzz * r0.xyz + r2.xyz;
  o0.w = r2.w;
  r1.xyz = log2(abs(r0.xyz));
  r1.xyz = g_cbColorInfo.yyy * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = g_cbColorInfo.zzz * r1.xyz;
  r0.w = floor(g_cbColorInfo.x);
  r0.w = (int)r0.w;
  r0.w = cmp((int)r0.w == 1);
  o0.xyz = r0.www ? r1.xyz : r0.xyz;
  return;
}
