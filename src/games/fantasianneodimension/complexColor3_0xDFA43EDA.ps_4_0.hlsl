// ---- Created with 3Dmigoto v1.3.16 on Fri Dec  6 01:35:02 2024

#include "./common.hlsl"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[25];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0 : SV_POSITION0,
    float2 v1 : TEXCOORD0,
    out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[23].xy + v1.xy;
  r0.z = cb0[24].x * r0.y;
  r0.x = dot(r0.xz, r0.xz);
  r0.x = sqrt(r0.x);
  r0.x = r0.x * 2 + -cb0[23].z;
  r0.x = saturate(r0.x / cb0[23].w);
  r0.x = cb0[24].z * r0.x;
  r1.xyzw = float4(-1, -1, 1, 1) * cb0[14].xyxy;
  r0.y = 0.5 * cb0[15].z;
  r2.xyzw = r1.xyzy * r0.yyyy + v1.xyxy;
  r1.xyzw = r1.xwzw * r0.yyyy + v1.xyxy;
  r3.xyzw = t0.Sample(s1_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s1_s, r2.zw).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r3.xyzw = t0.Sample(s1_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s1_s, r1.zw).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r1.xyzw = float4(0.25, 0.25, 0.25, 0.25) * r1.xyzw;
  r2.xyzw = cb0[16].xyzw * cb0[15].xxxx;
  r3.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = r1.xyzw * r2.xyzw + r3.xyzw;
  r2.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.yzw = r2.xyz + -r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  o0.w = r1.w;
  r0.xyz = r0.xyz * cb0[10].www + float3(-0.217637643, -0.217637643, -0.217637643);
  r0.xyz = (r0.xyz * cb0[12].www + float3(0.217637643, 0.217637643, 0.217637643));  // Saturate removed to unclamp
  r1.xyz = -r0.xyz * r0.xyz + r0.xyz;
  r1.xyz = -r1.xyz * -cb0[13].xxx + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.219999999, 0.707000017, 0.0710000023));
  r0.w = saturate(r0.w / cb0[13].y);
  r2.xyz = r0.xyz * r0.www;
  r0.w = 1 + -r0.w;
  r1.xyz = r1.xyz * r0.www + r2.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[13].zzz * r1.xyz + r0.xyz;
  r0.xyz = cb0[11].xyz + r0.xyz;
  r0.xyz = cb0[12].xyz * r0.xyz;

  // r0.xyz = log2(r0.xyz);
  r0.w = cb0[13].w + cb0[13].w;
  // r0.xyz = r0.www * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  r0.rgb = renodx::math::PowSafe(r0.rgb, r0.w);  // Make the above pow safe

  r0.w = -0.5 + v1.y;
  r0.w = r0.w / cb0[20].y;
  r0.w = saturate(0.5 + r0.w);
  r1.xyz = cb0[18].xyz + -cb0[17].xyz;
  r1.xyz = r0.www * r1.xyz + cb0[17].xyz;
  r1.xyz = float3(-1, -1, -1) + r1.xyz;
  r2.xy = -cb0[19].xy + v1.xy;
  r2.z = cb0[20].x * r2.y;
  r1.w = dot(r2.xxzz, r2.xxzz);
  r1.w = -cb0[19].z + r1.w;
  r1.w = saturate(r1.w / cb0[19].w);
  r1.xyz = r1.www * r1.xyz + float3(1, 1, 1);
  r2.xyz = cb0[22].xyz + -cb0[21].xyz;
  r2.xyz = r0.www * r2.xyz + cb0[21].xyz;
  r2.xyz = r2.xyz * r1.www;
  o0.xyz = r0.xyz * r1.xyz + r2.xyz;

  o0.rgb = renodx::math::PowSafe(o0.rgb, 2.2f);  // Linearize
  o0.rgb = applyUserTonemap(o0.rgb);
  o0.rgb *= injectedData.toneMapGameNits / injectedData.toneMapUINits;  // Scale luminance
  o0.rgb = renodx::math::PowSafe(o0.rgb, 1.f / 2.2f);                   // Return to gamma space

  o0.w = 1.f;

  return;
}