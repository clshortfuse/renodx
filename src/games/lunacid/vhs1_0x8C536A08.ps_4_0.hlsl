#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Tue Apr 15 14:30:45 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[9];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = frac(v1.x);
  r0.y = cb0[5].z + v1.y;
  r1.y = frac(r0.y);
  r0.y = cmp(cb0[5].w < 3498);
  r0.z = cb0[8].x + r1.y;
  r0.z = 100 * r0.z;
  r0.z = cos(r0.z);
  r0.z = r0.z / cb0[5].w;
  r0.z = r0.x + r0.z;
  r0.xz = frac(r0.xz);
  r1.x = r0.y ? r0.z : r0.x;
  r0.xyzw = t0.Sample(s0_s, r1.xy).xyzw;

  float3 untonemapped = renodx::color::srgb::DecodeSafe(r0.xyz);
  float3 sdr_color = renodx::tonemap::renodrt::NeutralSDR(untonemapped);
  float4 sdr_color_srgb = saturate(r0);
  if (RENODX_TONE_MAP_TYPE >= 1) {
    sdr_color_srgb.xyz = renodx::color::srgb::EncodeSafe(sdr_color.xyz);
    sdr_color_srgb.w = r0.w;
  }
  r0 = sdr_color_srgb;
  
  r0.xz = float2(-0.5,-0.5) + r1.xy;
  r0.x = dot(r0.xz, r0.xz);
  r0.x = sqrt(r0.x);
  r0.x = dot(cb0[4].zz, r0.xx);
  r1.zw = r0.xx * cb0[5].yx + r1.xy;

  //r2.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r2 = sdr_color_srgb;

  r1.xy = -r0.xx * cb0[5].yx + r1.xy;

  //r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1 = sdr_color_srgb;

  //VHS Noise
  r0.x = cmp(0 != cb0[6].z);
  if (r0.x != 0) {
    r2.y = cb0[0].z * cb0[0].z;
    r2.z = 6.28318548 * r2.y;
    r2.z = sqrt(r2.z);
    r2.z = 1 / r2.z;
    r2.y = r2.y + r2.y;
    r3.x = 0;
    r4.xyzw = float4(0,0,0,0);
    r2.w = 0;
    r3.z = 0;
    while (true) {
      r3.w = cmp(r3.z >= cb0[0].x);
      if (r3.w != 0) break;
      r3.w = r3.z * 0.111111112 + -0.5;
      r3.y = cb0[0].y * r3.w;
      r5.xy = w1.xy + r3.xy;
      r3.y = r3.y * r3.y;
      r3.y = r3.y / r2.y;
      r3.y = -1.44269502 * r3.y;
      r3.y = exp2(r3.y);
      r3.w = r3.y * r2.z;
      r2.w = r2.z * r3.y + r2.w;
      r5.xyzw = t1.Sample(s1_s, r5.xy).xyzw;
      r4.xyzw = r5.xyzw * r3.wwww + r4.xyzw;
      r3.z = 1 + r3.z;
    }
    r3.xyzw = r4.xyzw / r2.wwww;
  } else {
    r3.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  }
  r4.xyzw = cmp(r3.xyzw >= float4(0.5,0.5,0.5,0.5));
  r5.xyzw = r4.xyzw ? float4(1,1,1,1) : 0;
  r1.x = r2.x;
  r1.yw = r0.yw;
  r2.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r1.xyzw;
  r2.xyzw = -r2.xyzw * float4(2,2,2,2) + float4(1,1,1,1);
  r6.xyzw = float4(1,1,1,1) + -r3.xyzw;
  r2.xyzw = -r2.xyzw * r6.xyzw + float4(1,1,1,1);
  r4.xyzw = r4.xyzw ? float4(0,0,0,0) : float4(1,1,1,1);
  r3.xyzw = r3.xyzw * r1.xyzw;
  r3.xyzw = r3.xyzw * r4.xyzw;
  r3.xyzw = r3.xyzw + r3.xyzw;
  r2.xyzw = r5.xyzw * r2.xyzw + r3.xyzw;
  r2.xyzw = r2.xyzw + -r1.xyzw;
  r3.xyzw = cb0[4].xxxx * r2.xyzw;
  r0.y = cb0[4].x * r2.x + r1.x;
  r0.y = -cb0[4].y + r0.y;
  r0.w = saturate(r0.y);
  r0.y = ceil(r0.y);
  r0.x = r0.x ? r0.w : r0.y;
  r1.xyzw = r0.xxxx * r3.xyzw + r1.xyzw;
  r0.x = saturate(-cb0[1].y + abs(r0.z));
  r0.x = ceil(r0.x);
  r0.x = 1 + -r0.x;
  o0.xyzw = r1.xyzw * r0.xxxx;

  float3 processed_sdr = renodx::color::srgb::DecodeSafe(o0.rgb);

  if (RENODX_TONE_MAP_TYPE >= 1) {
    o0.rgb = renodx::tonemap::UpgradeToneMap(untonemapped, sdr_color, processed_sdr, 1.f);
    o0.rgb = renodx::color::srgb::EncodeSafe(o0.rgb);
  }
  return;
}