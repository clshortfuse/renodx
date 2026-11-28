#include "./lut_domain.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Fri Nov 20 21:43:20 2026
Texture3D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[1];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[38];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float2 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[0].xy * v0.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (int2)r0.xy & int2(1,1);
  r0.xy = (uint2)r0.xy;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.zw = (uint2)r0.xy;
  r1.xy = (uint2)r0.zw;
  r2.x = cb0[0].z * r1.x;
  r2.y = 0;
  r0.zw = v0.xy + r2.xy;
  r2.xyz = t1.SampleLevel(s1_s, r0.zw, 0).xyz;
  r3.x = r2.y;
  r1.z = 0;
  r0.zw = r1.zy * cb0[0].zw + v0.xy;
  r1.xyz = t1.SampleLevel(s1_s, r0.zw, 0).xyz;
  r3.z = r1.y;
  r4.xyz = t1.SampleLevel(s1_s, v0.xy, 0).xyz;
  r5.xyz = ddx_fine(r4.xyz);
  r0.xzw = -r5.xyz * r0.xxx + r4.xyz;
  r3.y = r0.z;
  r0.xzw = r2.xyz + r0.xzw;
  r0.xzw = r0.xzw + r1.xyz;
  r1.xyz = ddy_fine(r4.xyz);
  r1.xyz = -r1.xyz * r0.yyy + r4.xyz;
  r3.w = r1.y;
  r0.xyz = r1.xyz + r0.xzw;
  r0.xyz = -r4.xyz * float3(4,4,4) + r0.xyz;
  r1.xyzw = r4.yyyy + -r3.xyzw;
  r0.w = max(abs(r1.x), abs(r1.y));
  r0.w = max(r0.w, abs(r1.z));
  r0.w = max(r0.w, abs(r1.w));
  r0.w = saturate(-v0.z * r0.w + 1);
  r1.x = 0.166666672 * cb0[34].y;
  r0.w = r1.x * -r0.w;
  r0.xyz = r0.xyz * r0.www + r4.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.xyz = t0.SampleLevel(s0_s, v1.xy, 0).xyz;
  r1.xyz = r1.xyz * cb1[0].xyz + cb0[32].xyz;
  r2.xyz = t2.SampleLevel(s2_s, v0.xy, 0).xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.xyz = r0.xyz * cb0[31].xyz + r1.xyz;
  r1.xy = cb0[37].xx * v1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = r0.w * r0.w + -1;
  r0.w = saturate(cb0[37].y * r0.w + 1);
  r0.w = v0.z * r0.w;
  r0.xyz = r0.xyz * r0.www + float3(0.00300000003,0.00300000003,0.00300000003);
  r0.xyz = log2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.0714285746,0.0714285746,0.0714285746) + float3(0.610726953,0.610726953,0.610726953);
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    // Invert the builders' quadratic log-domain extension before addressing
    // the native 32^3 LUT. The rational form avoids cancellation at the join.
    float3 distance = max(r0.xyz - GEARS4_LUT_DOMAIN_PIVOT, 0.f);
    r0.xyz = min(r0.xyz, GEARS4_LUT_DOMAIN_PIVOT)
             + 2.f * distance / (1.f + sqrt(1.f + 4.f * GEARS4_LUT_DOMAIN_CURVATURE * distance));
  }
  r0.xyz = saturate(r0.xyz);
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r0.xyz = t3.Sample(s3_s, r0.xyz).xyz;
  o0.xyz = float3(1.04999995,1.04999995,1.04999995) * r0.xyz;
  // Restore the native UNORM write clamp for the vanilla scene path.
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.xyz = saturate(o0.xyz);
  }
  o0.w = 0;
  return;
}
