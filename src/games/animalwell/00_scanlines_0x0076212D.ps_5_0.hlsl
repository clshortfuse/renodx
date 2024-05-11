#include "./shared.h"

cbuffer ViewportConstantBuffer : register(b2) {
  float4 viewportSize : packoffset(c0);
}

SamplerState BilinearSampler_s : register(s1);
Texture2D<float4> tex : register(t0);

#define cmp -

void main(float4 v0 : SV_POSITION0, float4 v1 : COLOR0, float2 v2 : UV0, out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 untouched;
  r0.y = 0;
  r1.xyz = float3(1, 1, 1) / viewportSize.xxy;
  r0.xzw = float3(0.150000006, 0.5, 0.5) * r1.xyz;
  r1.xy = -r1.yz * float2(0.5, 0.5) + float2(1, 1);
  r1.zw = v2.xy + r0.xy;
  r0.xy = v2.xy + -r0.xy;
  r2.xy = float2(320, 180) * r1.zw;
  r2.zw = frac(r2.xy);
  r2.xy = floor(r2.xy);
  r2.xy = float2(0.5, 0.5) + r2.xy;
  r2.zw = float2(0.5, 0.5) + -r2.zw;
  r3.xy = abs(r2.zw) + abs(r2.zw);
  r2.zw = abs(r2.zw) * float2(-4, -4) + float2(3, 3);
  r3.xy = r3.xy * r3.xy;
  r2.zw = r3.xy * r2.zw;
  r1.w = r2.z * r2.z;
  r1.z = -r2.x * 0.00312500005 + r1.z;
  r2.yz = float2(0.00312500005, 0.00555555569) * r2.xy;
  r2.x = r1.w * r1.z + r2.y;
  r1.zw = max(r2.xz, r0.zw);
  r1.zw = min(r1.zw, r1.xy);
  r1.z = tex.Sample(BilinearSampler_s, r1.zw).z;
  untouched.z = r1.z;
  r1.w = saturate(r1.z);
  r2.x = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = r2.x * r1.w;
  r1.w = 0.800000012 * r1.w;
  r1.w = r1.w * -r2.w + r2.w;
  r1.w = saturate(1 + -r1.w);
  r2.x = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = r2.x * r1.w;
  r1.z = r1.z * r1.w;
  r1.z = log2(abs(r1.z));
  r1.z = 0.75 * r1.z;
  o0.z = exp2(r1.z);
  r1.zw = float2(320, 180) * r0.xy;
  r2.xy = floor(r1.zw);
  r1.zw = frac(r1.zw);
  r1.zw = float2(0.5, 0.5) + -r1.zw;
  r2.xy = float2(0.5, 0.5) + r2.xy;
  r0.x = -r2.x * 0.00312500005 + r0.x;
  r2.yz = float2(0.00312500005, 0.00555555569) * r2.xy;
  r3.xy = abs(r1.zw) + abs(r1.zw);
  r1.zw = abs(r1.zw) * float2(-4, -4) + float2(3, 3);
  r3.xy = r3.xy * r3.xy;
  r1.zw = r3.xy * r1.zw;
  r2.x = r1.z * r0.x + r2.y;
  r0.xy = max(r2.xz, r0.zw);
  r0.xy = min(r0.xy, r1.xy);
  r0.x = tex.Sample(BilinearSampler_s, r0.xy).x;
  untouched.x = r0.x;
  r0.y = saturate(r0.x);
  r1.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r1.z * r0.y;
  r0.y = 0.600000024 * r0.y;
  r0.y = r0.y * -r1.w + r1.w;
  r0.y = saturate(1 + -r0.y);
  r1.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r1.z * r0.y;
  r0.x = r0.x * r0.y;
  r0.x = log2(abs(r0.x));
  r0.x = 0.75 * r0.x;
  o0.x = exp2(r0.x);
  r0.xy = float2(320, 180) * v2.xy;
  r1.zw = frac(r0.xy);
  r0.xy = floor(r0.xy);
  r0.xy = float2(0.5, 0.5) + r0.xy;
  r1.zw = float2(0.5, 0.5) + -r1.zw;
  r2.xy = abs(r1.zw) + abs(r1.zw);
  r1.zw = abs(r1.zw) * float2(-4, -4) + float2(3, 3);
  r2.xy = r2.xy * r2.xy;
  r1.zw = r2.xy * r1.zw;
  r1.z = r1.z * r1.z;
  r2.x = -r0.x * 0.00312500005 + v2.x;
  r3.yz = float2(0.00312500005, 0.00555555569) * r0.xy;
  r3.x = r1.z * r2.x + r3.y;
  r0.xy = max(r3.xz, r0.zw);
  r0.xy = min(r0.xy, r1.xy);
  r0.x = tex.Sample(BilinearSampler_s, r0.xy).y;
  untouched.y = r0.x;
  r0.y = saturate(r0.x);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.z * r0.y;
  r0.y = 0.699999988 * r0.y;
  r0.y = r0.y * -r1.w + r1.w;
  r0.y = saturate(1 + -r0.y);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.z * r0.y;
  r0.x = r0.x * r0.y;
  r0.x = log2(abs(r0.x));
  r0.x = 0.75 * r0.x;
  o0.y = exp2(r0.x);
  o0.w = 1;

  o0.rgb = lerp(untouched, o0.rgb, injectedData.fxScanlines);
  o0.rgb = pow(o0.rgb, 2.2f);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
