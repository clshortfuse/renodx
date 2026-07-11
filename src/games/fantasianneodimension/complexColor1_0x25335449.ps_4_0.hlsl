// ---- Created with 3Dmigoto v1.3.16 on Thu Dec  5 19:31:25 2024
// The game clamps here
// There seems to be color correction going on here

#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) { float4 cb0[23]; }

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0,
          out float4 o0 : SV_Target0) {  // Changed o0 from float4 -> float3
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-1, -1, 1, 1) * cb0[14].xyxy;
  r1.x = 0.5 * cb0[15].z;
  r2.xyzw = r0.xyzy * r1.xxxx + v1.xyxy;
  r0.xyzw = r0.xwzw * r1.xxxx + v1.xyxy;
  r1.xyzw = t0.Sample(s1_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s1_s, r2.zw).xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r2.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s1_s, r0.zw).xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = float4(0.25, 0.25, 0.25, 0.25) * r0.xyzw;
  r1.xyzw = cb0[16].xyzw * cb0[15].xxxx;
  r2.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
  r0.xyzw = r0.xyzw * r1.xyzw + r2.xyzw;
  r1.x = cb0[10].w * cb0[10].z;
  r2.xyzw = float4(0.700999975, 0.587000012, 0.114, 0.298999995) * r1.xxxx;
  r1.xyzw = float4(0.412999988, 0.300000012, 0.588, 0.885999978) * r1.xxxx;
  r2.yzw = cb0[10].www * float3(0.587000012, 0.114, 0.298999995) + -r2.yzw;
  r2.x = cb0[10].w * 0.298999995 + r2.x;
  r2.y = r2.y * r0.y;
  r2.x = r2.x * r0.x + r2.y;
  r3.x = r2.z * r0.z + r2.x;
  r1.yz = cb0[10].ww * float2(0.298999995, 0.587000012) + -r1.yz;
  r1.xw = cb0[10].ww * float2(0.587000012, 0.114) + r1.xw;
  r1.yz = r1.yz * r0.xy;
  r1.y = r1.y + r1.z;
  r3.z = r1.w * r0.z + r1.y;
  r0.y = r1.x * r0.y;
  r0.x = r2.w * r0.x + r0.y;
  r3.y = r2.z * r0.z + r0.x;
  r0.xyz = float3(-0.217637643, -0.217637643, -0.217637643) + r3.xyz;
  r0.xyz = (r0.xyz * cb0[12].www + float3(0.217637643, 0.217637643, 0.217637643));  // saturate removed, unclamps the game
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