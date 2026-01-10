// ---- Created with 3Dmigoto v1.4.1 on Tue Dec  9 17:10:31 2025
Texture2D<float4> t8 : register(t8);

Texture2D<float4> t7 : register(t7);

struct t5_t {
  float val[16];
};
StructuredBuffer<t5_t> t5 : register(t5);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s10_s : register(s10);

SamplerState s6_s : register(s6);

cbuffer cb5 : register(b5)
{
  float4 cb5[13];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[21];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[91];
}




// 3Dmigoto declarations
#define cmp -

#include "./shared.h"


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Read exposure scalar and UV for the current pixel.
  r0.x = t1.Sample(s10_s, float2(0,0)).x;
  r0.yz = cb1[90].xx * v1.xy;
  // Sample base color (negative HDR encoding) and clamp to valid range.
  r1.xyz = t0.Sample(s10_s, r0.yz).xyz;
  r1.xyz = min(float3(0,0,0), -r1.xyz);
  r1.xyz = min(float3(65504,65504,65504), -r1.xyz);
  // Sample additive component (e.g., bloom/upscaled buffer) and accumulate with exposure.
  r2.xy = min(cb5[10].zw, r0.yz);
  r2.xyz = t2.Sample(s6_s, r2.xy).xyz;
  r1.xyz = r1.xyz * r0.xxx + r2.xyz;
  // Early branch: if RenoDX tonemapping is active, bypass the local ACES curve and feed linear UI color directly.
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    // Decode to linear (UI inputs are stored in gamma-ish space); keep exposure-applied signal as HDR input.
    float3 hdr_color = renodx::color::srgb::DecodeSafe(max(float3(0,0,0), r1.xyz));
    float3 graded_sdr = hdr_color;  // no local grading when RenoDX tonemapper is in control
    float3 color = renodx::draw::ToneMapPass(hdr_color, graded_sdr);
    color = renodx::draw::RenderIntermediatePass(color);
    o0.xyz = color;
    // Alpha: validity flag from depth/motion buffer gate.
    r0.x = t8.Sample(s10_s, r0.yz).x;
    r0.yz = t7.Sample(s10_s, r0.yz).xy;
    r0.y = dot(r0.yz, r0.yz);
    r0.y = cmp(r0.y != 0.000000);
    r0.xz = r0.xx * cb2[20].wz + cb2[20].yx;
    r0.x = r0.x / r0.z;
    r0.x = cmp(15 >= r0.x);
    r0.xy = r0.xy ? float2(1,1) : 0;
    o0.w = r0.y * r0.x;
    return;
  }
  // Unpack ACES curve parameters from structured buffer (offset 16/4).
  r0.x = t5[0].val[16/4];
  r0.w = t5[0].val[16/4+1];
  r1.xyz = r1.xyz * r0.www;
  r0.x = 1 + r0.x;
  // Convert to log space for tone curve math.
  r1.xyz = log2(r1.xyz);
  // Read ACES parameters (A/B/C/D) from structured buffer start.
  r2.x = t5[0].val[0/4];
  r2.y = t5[0].val[0/4+1];
  r2.z = t5[0].val[0/4+2];
  r2.w = t5[0].val[0/4+3];
  // First shoulder/knee evaluation branch of ACES-like curve.
  r0.w = 0.819999993 + -r2.y;
  r0.w = r0.w / r2.x;
  r0.w = -0.73299998 + r0.w;
  r3.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + -r0.www;
  r4.xy = float2(1,-0.180000007) + r2.wz;
  r1.w = r4.x + -r2.y;
  r2.y = r4.y / r2.x;
  r2.y = -0.73299998 + r2.y;
  r3.w = r2.x / r1.w;
  r1.w = r1.w + r1.w;
  r3.w = -2 * r3.w;
  r3.xyz = r3.www * r3.xyz;
  r3.xyz = float3(1.44269502,1.44269502,1.44269502) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = float3(1,1,1) + r3.xyz;
  r3.xyz = r1.www / r3.xyz;
  r3.xyz = r3.xyz + -r2.www;
  // Second branch of the curve (alt knee) for smooth blend.
  r1.w = -r2.z + r0.x;
  r2.z = r2.x / r1.w;
  r1.w = r1.w + r1.w;
  r2.z = r2.z + r2.z;
  r4.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + -r2.yyy;
  r4.xyz = r4.xyz * r2.zzz;
  r4.xyz = float3(1.44269502,1.44269502,1.44269502) * r4.xyz;
  r4.xyz = exp2(r4.xyz);
  r4.xyz = float3(1,1,1) + r4.xyz;
  r4.xyz = r1.www / r4.xyz;
  r4.xyz = -r4.xyz + r0.xxx;
  r4.xyz = r4.xyz + -r3.xyz;
  // Hermite smoothstep between curve segments using normalized log luminance.
  r0.x = max(r2.y, r0.w);
  r1.w = min(r2.y, r0.w);
  r0.x = -r1.w + r0.x;
  r5.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + -r1.www;
  r0.x = 1 / r0.x;
  r5.xyz = saturate(r5.xyz * r0.xxx);
  r6.xyz = r5.xyz * float3(-2,-2,-2) + float3(3,3,3);
  r5.xyz = r5.xyz * r5.xyz;
  r5.xyz = r6.xyz * r5.xyz;
  r3.xyz = r5.xyz * r4.xyz + r3.xyz;
  // Rebuild exposure/tint and apply slope/offset from cb5[11].
  r4.xyz = float3(0.30103001,0.30103001,0.30103001) * r1.xyz;
  r1.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + float3(0.73299998,0.73299998,0.73299998);
  r1.xyz = r2.xxx * r1.xyz + float3(0.180000007,0.180000007,0.180000007);
  r2.xzw = cmp(r0.www < r4.xyz);
  r4.xyz = cmp(r4.xyz < r2.yyy);
  r2.xyz = r2.xzw ? r4.xyz : 0;
  r1.xyz = r2.xyz ? r1.xyz : r3.xyz;
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r1.xyz = log2(r1.xyz);
  r1.xyz = cb5[11].www * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = cb5[11].xxx + r1.xyz;
  // Apply color grade: isolate luma then blend back with chroma tilt and slope.
  r0.x = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r1.xyz = r1.xyz + -r0.xxx;
  r1.xyz = cb5[11].yyy * r1.xyz + r0.xxx;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = r1.xyz * cb5[11].zzz + float3(0.5,0.5,0.5);
  r1.xyz = max(float3(0,0,0), r1.xyz);
  // Highlight compression based on luma magnitude and softness.
  r0.x = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r1.xyz = r1.xyz + -r0.xxx;
  r0.w = dot(abs(r1.xyz), float3(0.212599993,0.715200007,0.0722000003));
  r0.w = saturate(cb5[12].x * r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r0.w * r0.w;
  r0.w = r0.w * cb5[12].y + 1;
  float3 graded_sdr = r1.xyz * r0.www + r0.xxx;
  o0.xyz = graded_sdr;
  // Alpha: validity flag from depth/motion buffer gate.
  r0.x = t8.Sample(s10_s, r0.yz).x;
  r0.yz = t7.Sample(s10_s, r0.yz).xy;
  r0.y = dot(r0.yz, r0.yz);
  r0.y = cmp(r0.y != 0.000000);
  r0.xz = r0.xx * cb2[20].wz + cb2[20].yx;
  r0.x = r0.x / r0.z;
  r0.x = cmp(15 >= r0.x);
  r0.xy = r0.xy ? float2(1,1) : 0;
  o0.w = r0.y * r0.x;
  return;
}