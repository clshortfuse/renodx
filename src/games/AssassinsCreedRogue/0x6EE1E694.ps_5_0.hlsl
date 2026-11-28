// ---- Created with 3Dmigoto v1.3.16 on Tue Jul 07 18:51:33 2026
// HDR-unclamped + final output brightness boost
//
// Important:
// If RENODX_FORCE_HDR_TEST = 1 does NOT output above SDR white,
// then the render target/view is still clamping, likely R8G8B8A8_UNORM / SRGB.
// In that case, this shader cannot output HDR until the target is upgraded.

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[144];
}

// 3Dmigoto declarations
#define cmp -

#ifndef RENODX_PRE_BLEND_BRIGHTNESS
#define RENODX_PRE_BLEND_BRIGHTNESS 2.0f
#endif

#ifndef RENODX_FINAL_BRIGHTNESS
#define RENODX_FINAL_BRIGHTNESS 2.0f
#endif

// Set this to 1 to test whether the render target can actually store HDR.
// If this still looks SDR-clamped, the problem is not this shader.
#ifndef RENODX_FORCE_HDR_TEST
#define RENODX_FORCE_HDR_TEST 0
#endif

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : COLOR0,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD4,
  float4 v7 : TEXCOORD5,
  uint v8 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v7.xyz, v7.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = v7.xyz * r0.xxx;

  r1.xyz = -cb0[63].xxx * r0.xyz;
  r0.xyz = v8.xxx ? r1.xyz : r0.xyz;

  r1.xyz = v4.xyz;
  r1.w = 0;
  r1.xyzw = cb0[40].xyzw + -r1.xyzw;

  r0.w = dot(r1.xyzw, r1.xyzw);
  r1.w = rsqrt(r0.w);
  r0.w = sqrt(r0.w);

  r0.w = -cb0[136].x + r0.w;
  r1.xyz = r1.xyz * r1.www;

  r0.x = dot(r1.xyz, r0.xyz);
  r0.x = -cb0[141].x + r0.x;

  r0.y = cb0[142].x + -cb0[141].x;
  r0.x = saturate(r0.x / r0.y);
  r0.x = -1 + r0.x;
  r0.x = cb0[143].x * r0.x + 1;

  r0.y = cb0[138].x + -cb0[136].x;
  r0.z = cb0[139].x + -cb0[136].x;
  r0.yz = saturate(r0.ww / r0.yz);

  r0.y = r0.y + r0.z;
  r0.z = 1 + -r0.y;

  r1.xy = v2.xy;
  r1.z = 1;

  r2.x = dot(r1.xyz, cb0[131].xyz);
  r2.y = dot(r1.xyz, cb0[132].xyz);

  r0.w = t0.Sample(s0_s, r2.xy).x;
  r0.z = r0.w * r0.z;

  r0.w = v3.w;
  r0.w = cb0[140].w * r0.w;
  r0.z = r0.z * r0.w;

  r2.x = dot(r1.xyz, cb0[128].xyz);
  r2.y = dot(r1.xyz, cb0[129].xyz);

  r0.w = t1.Sample(s1_s, r2.xy).x;
  r0.z = r0.w * r0.z;
  r0.z = cb0[134].x * r0.z;

  r0.x = r0.z * r0.x;

  r0.z = cb0[40].z + cb0[37].z;
  r0.z = v4.z + -r0.z;
  r0.z = min(cb0[37].z, r0.z);
  r0.z = saturate(-r0.z * cb0[37].w + 1);

  r0.w = cb0[37].y + -cb0[37].x;

  r1.xyz = cb0[40].xyz + -v4.xyz;
  r1.w = dot(r1.xyz, r1.xyz);

  r2.x = sqrt(r1.w);
  r1.w = rsqrt(r1.w);
  r1.xyz = r1.xyz * r1.www;

  r1.x = dot(cb0[11].xyz, r1.xyz);
  r1.x = 1 + r1.x;
  r1.x = -r1.x * 0.5 + 1;
  r1.x = r1.x * r1.x;

  r1.y = -cb0[37].x + r2.x;

  r1.z = -20 + r2.x;
  r1.z = saturate(0.0700000003 * r1.z);
  r1.z = 1 + -r1.z;
  r1.z = -r1.z * r1.z + 1;
  r1.z = cb0[36].x * r1.z;

  r0.w = saturate(r1.y / r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r0.w * r0.w;
  r0.w = -r0.w * r0.w + 1;

  r0.z = saturate(r0.w * r0.z + r1.z);
  r0.w = 1 + -r0.z;

  r0.x = r0.x * r0.w;

  o0.w = r0.x;
  o1.w = r0.x;

  r1.yzw = -cb0[61].xyz + cb0[60].xyz;
  r1.xyz = r1.xxx * r1.yzw + cb0[61].xyz;

  r2.xyz = cb0[137].xyz + -cb0[135].xyz;
  r0.xyw = r0.yyy * r2.xyz + cb0[135].xyz;

  r2.xyz = cb0[140].xyz * v3.xyz;
  r2.xyz = float3(2, 2, 2) * r2.xyz;

  r0.xyw = r2.xyz * r0.xyw;

  // Original SDR clamp:
  // r0.xyw = min(float3(1,1,1), abs(r0.xyw));

  // Unclamped pre-blend color.
  r0.xyw = abs(r0.xyw) * RENODX_PRE_BLEND_BRIGHTNESS;

  r1.xyz = r1.xyz + -r0.xyw;
  r0.xyz = r0.zzz * r1.xyz + r0.xyw;

  // Build final output color first.
  float3 final_color = cb0[49].xyz + r0.xyz;

  // Force non-negative HDR-safe output.
  final_color = max(final_color, float3(0, 0, 0));


  o0.xyz = final_color;

  // Likely depth / auxiliary target. Leave unchanged.
  o1.xyz = v1.zzz / v1.www;

  return;
}