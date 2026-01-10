// ---- Created with 3Dmigoto v1.4.1 on Tue Dec  9 19:21:25 2025
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

  // Vignette falloff factor from UV (radial distance from center).
  r0.xy = float2(-0.5,-0.5) + v1.yx;
  r0.z = min(0, r0.x);
  r0.x = dot(r0.yz, r0.yz);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = log2(r0.x);
  r0.x = cb5[1].x * r0.x;
  r0.x = exp2(r0.x);
  // Exposure scalar (t1) and UV scale for fetches.
  r0.y = t1.Sample(s10_s, float2(0,0)).x;
  r0.zw = cb1[90].xx * v1.xy;
  // Base color is stored as negative HDR; clamp to valid range.
  r1.xyz = t0.Sample(s10_s, r0.zw).xyz;
  r1.xyz = min(float3(0,0,0), -r1.xyz);
  r1.xyz = min(float3(65504,65504,65504), -r1.xyz);
  // Add secondary buffer (bloom/upscale) then apply exposure and vignette.
  r2.xy = min(cb5[10].zw, r0.zw);
  r2.xyz = t2.Sample(s6_s, r2.xy).xyz;
  r1.xyz = r1.xyz * r0.yyy + r2.xyz;
  r1.xyz = r1.xyz * r0.xxx;
  // Capture untonemapped linear (post exposure/vignette, pre-curve) for RenoDX tonemapper input.
  float3 hdr_color = max(float3(0,0,0), r1.xyz);
  // Curve params (ACES-like) from structured buffer.
  r0.x = t5[0].val[16/4];
  r0.y = t5[0].val[16/4+1];
  r1.xyz = r1.xyz * r0.yyy;
  r0.x = 1 + r0.x;
  // Log space for curve math.
  r1.xyz = log2(r1.xyz);
  r2.x = t5[0].val[0/4];
  r2.y = t5[0].val[0/4+1];
  r2.z = t5[0].val[0/4+2];
  r2.w = t5[0].val[0/4+3];
  // Shoulder branch of the curve.
  r0.y = 0.819999993 + -r2.y;
  r0.y = r0.y / r2.x;
  r0.y = -0.73299998 + r0.y;
  r3.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + -r0.yyy;
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
  // Alternate knee branch for smooth blend.
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
  // Hermite smoothstep to blend branches based on log luminance.
  r0.x = max(r2.y, r0.y);
  r1.w = min(r2.y, r0.y);
  r0.x = -r1.w + r0.x;
  r5.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + -r1.www;
  r0.x = 1 / r0.x;
  r5.xyz = saturate(r5.xyz * r0.xxx);
  r6.xyz = r5.xyz * float3(-2,-2,-2) + float3(3,3,3);
  r5.xyz = r5.xyz * r5.xyz;
  r5.xyz = r6.xyz * r5.xyz;
  r3.xyz = r5.xyz * r4.xyz + r3.xyz;
  // Rebuild color with slope/offset and gating between segments.
  r4.xyz = float3(0.30103001,0.30103001,0.30103001) * r1.xyz;
  r1.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + float3(0.73299998,0.73299998,0.73299998);
  r1.xyz = r2.xxx * r1.xyz + float3(0.180000007,0.180000007,0.180000007);
  r2.xzw = cmp(r0.yyy < r4.xyz);
  r4.xyz = cmp(r4.xyz < r2.yyy);
  r2.xyz = r2.xzw ? r4.xyz : 0;
  r1.xyz = r2.xyz ? r1.xyz : r3.xyz;
  r1.xyz = max(float3(0,0,0), r1.xyz);
  // Grade slope/offset and chroma tilt.
  r1.xyz = log2(r1.xyz);
  r1.xyz = cb5[11].www * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = cb5[11].xxx + r1.xyz;
  r0.x = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r1.xyz = r1.xyz + -r0.xxx;
  r1.xyz = cb5[11].yyy * r1.xyz + r0.xxx;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = r1.xyz * cb5[11].zzz + float3(0.5,0.5,0.5);
  r1.xyz = max(float3(0,0,0), r1.xyz);
  // Highlight compression and output RGB.
  r0.x = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r1.xyz = r1.xyz + -r0.xxx;
  r0.y = dot(abs(r1.xyz), float3(0.212599993,0.715200007,0.0722000003));
  r0.y = saturate(cb5[12].x * r0.y);
  r0.y = 1 + -r0.y;
  r0.y = r0.y * r0.y;
  r0.y = r0.y * cb5[12].y + 1;
  float3 graded_sdr = r1.xyz * r0.yyy + r0.xxx;
  // Optional RenoDX ToneMapPass: use captured hdr_color (unclamped) as input and graded SDR as reference.
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 color = renodx::draw::ToneMapPass(hdr_color, graded_sdr);
    color = renodx::draw::RenderIntermediatePass(color);
    o0.xyz = color;
  } else {
    o0.xyz = graded_sdr;
  }
  // Alpha mask from motion/depth validity gate.
  r0.x = t8.Sample(s10_s, r0.zw).x;
  r0.yz = t7.Sample(s10_s, r0.zw).xy;
  r0.y = dot(r0.yz, r0.yz);
  r0.y = cmp(r0.y != 0.000000);
  r0.xz = r0.xx * cb2[20].wz + cb2[20].yx;
  r0.x = r0.x / r0.z;
  r0.x = cmp(15 >= r0.x);
  r0.xy = r0.xy ? float2(1,1) : 0;
  o0.w = r0.y * r0.x;
  return;
}