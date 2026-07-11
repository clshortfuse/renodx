// Ghostwire tokyo gliding effect
// Game render needs to go PQ to sRGB, and then output back to PQ

#include "../postfx.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Sat Apr 11 23:31:33 2026
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[17];
}

cbuffer cb0 : register(b0) {
  float4 cb0[39];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0: SV_POSITION0, float4 v1: TEXCOORD0,
          out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asuint(cb0[37].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.zw = cb0[38].zw * r0.xy;
  r1.xy = r0.zw * cb0[5].xy + cb0[4].xy;
  r1.xyz = t2.Sample(s2_s, r1.xy).xyz;  // Game render

  if (PROCESSING_PATH == 0.f) {
    // Convert PQ -> sRGB
    r1.rgb = ConvertPQToSRGB(r1.rgb);
  }

  r2.xy = r0.xy * cb0[38].zw + -cb1[1].xy;
  r1.w = 1 + cb1[10].z;
  r1.w = 1 / r1.w;
  r3.xyz = r1.xyz;
  r2.zw = float2(1, 1);

  while (true) {
    r3.w = cmp(r2.w >= cb1[10].z);
    if (r3.w != 0)
      break;
    r3.w = r2.w * r1.w;
    r3.w = log2(r3.w);
    r3.w = cb1[11].x * r3.w;
    r3.w = exp2(r3.w);
    r3.w = 1 + -r3.w;
    r4.x = -cb1[10].w * r2.w + 1;
    r4.xy = saturate(r2.xy * r4.xx + cb1[1].xy);
    r4.xy = r4.xy * cb0[5].xy + cb0[4].xy;

    r4.xyz = t2.Sample(s2_s, r4.xy).xyz;  // "Wide" game render
    if (PROCESSING_PATH == 0.f) {
      // Convert PQ -> sRGB
      r4.rgb = ConvertPQToSRGB(r4.rgb);
    }

    r3.xyz = r4.xyz * r3.www + r3.xyz;
    r2.z = r3.w + r2.z;
    r2.w = 1 + r2.w;
  }
  r3.xyz = r3.xyz / r2.zzz;
  r1.w = saturate(cb1[11].y);
  r2.x = dot(r2.xy, r2.xy);
  r2.x = sqrt(r2.x);
  r2.x = cb1[11].z + r2.x;
  r2.x = saturate(cb1[11].w * r2.x);
  r1.w = r2.x * r1.w;
  r2.xyz = r3.xyz + -r1.xyz;
  r1.xyz = r1.www * r2.xyz + r1.xyz;
  r0.xy = r0.yx * cb0[38].wz + float2(-0.5, -0.5);
  r1.w = dot(r0.xy, r0.xy);
  r1.w = sqrt(r1.w);
  r1.w = -cb1[12].z + r1.w;
  r2.x = 1 + -cb1[12].z;
  r1.w = saturate(r1.w / r2.x);
  r2.x = r1.w * r1.w;
  r1.w = -r1.w * 2 + 3;
  r1.w = r2.x * r1.w;
  r2.x = cmp(0 >= r1.w);
  r1.w = log2(r1.w);
  r2.y = cb1[12].w * r1.w;
  r2.y = exp2(r2.y);
  r2.y = saturate(cb1[13].x * r2.y);
  r2.y = r2.x ? 0 : r2.y;
  r3.xyz = r1.xyz * cb1[3].xyz + -r1.xyz;
  r1.xyz = r2.yyy * r3.xyz + r1.xyz;
  r2.y = cb1[13].y * r1.w;
  r2.y = exp2(r2.y);
  r2.y = saturate(cb1[13].z * r2.y);
  r2.y = r2.x ? 0 : r2.y;
  r0.xy = r0.xy + r0.xy;
  r2.z = min(abs(r0.x), abs(r0.y));
  r2.w = max(abs(r0.x), abs(r0.y));
  r2.w = 1 / r2.w;
  r2.z = r2.z * r2.w;
  r2.w = r2.z * r2.z;
  r3.x = r2.w * 0.0208350997 + -0.0851330012;
  r3.x = r2.w * r3.x + 0.180141002;
  r3.x = r2.w * r3.x + -0.330299497;
  r2.w = r2.w * r3.x + 0.999866009;
  r3.x = r2.z * r2.w;
  r3.y = cmp(abs(r0.y) < abs(r0.x));
  r3.x = r3.x * -2 + 1.57079637;
  r3.x = r3.y ? r3.x : 0;
  r2.z = r2.z * r2.w + r3.x;
  r2.w = cmp(r0.y < -r0.y);
  r2.w = r2.w ? -3.141593 : 0;
  r2.z = r2.z + r2.w;
  r2.w = min(r0.x, r0.y);
  r0.x = max(r0.x, r0.y);
  r0.y = cmp(r2.w < -r2.w);
  r0.x = cmp(r0.x >= -r0.x);
  r0.x = r0.x ? r0.y : 0;
  r0.x = r0.x ? -r2.z : r2.z;
  r0.x = 0.159154952 * r0.x;
  r0.y = cb1[13].w * r0.x;
  r3.x = frac(r0.y);
  r0.yz = r0.zw * float2(2, 2) + float2(-1, -1);
  r0.yz = r0.yz * r0.yz;
  r0.y = r0.y + r0.z;
  r0.y = sqrt(r0.y);
  r0.z = r0.y * cb1[14].x + cb1[14].w;
  r3.y = frac(r0.z);
  r0.z = t0.Sample(s0_s, r3.xy).x;
  r3.xyz = cb1[5].xyz * r0.zzz;
  r0.z = cb1[15].x * r1.w;
  r0.z = exp2(r0.z);
  r0.z = saturate(cb1[15].y * r0.z);
  r0.z = r2.x ? 0 : r0.z;
  r0.x = cb1[15].z * r0.x;
  r4.x = frac(r0.x);
  r0.x = r0.y * cb1[15].w + cb1[16].y;
  r4.y = frac(r0.x);
  r0.x = t1.Sample(s1_s, r4.xy).x;
  r0.xyw = cb1[7].xyz * r0.xxx;
  r0.xyz = r0.zzz * r0.xyw;
  r0.xyz = r2.yyy * r3.xyz + r0.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyz = cb1[8].xyz + -r0.xyz;
  r0.xyz = cb1[16].zzz * r1.xyz + r0.xyz;
  // o0.xyz = max(float3(0, 0, 0), r0.xyz);
  o0.xyz = r0.xyz;
  o0.w = 1;

  // Back to PQ
  if (PROCESSING_PATH == 0.f) {
    o0.xyz = ConvertSRGBtoPQ(o0.xyz);
  }

  return;
}
