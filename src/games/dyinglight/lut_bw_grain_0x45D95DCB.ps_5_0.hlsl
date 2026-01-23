#include "./common.hlsli"
#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:06 2024
Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[8];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float4 v3: TEXCOORD2,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.xyzw = r0.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r1.xyzw = t2.Sample(s2_s, v1.zw).xyzw;
  r1.xyzw = r1.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = cb0[2].wwww + r0.xyzw;
  r0.xyzw = frac(r0.xyzw);
  r0.xyzw = r0.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r0.xyzw = saturate(abs(r0.xyzw) * float4(5, 5, 5, 5) + float4(-1, -1, -1, -1));
  r0.xyzw = float4(1, 1, 1, 1) + -r0.xyzw;
  r0.xyzw = r0.xyzw * cb0[2].yyyy + cb0[2].zzzz;
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = cb0[3].xxx * r0.xyz + r0.www;
  r1.xy = -abs(v3.xy) * abs(v3.xy) + float2(1, 1);
  r0.w = saturate(-r1.x * r1.y + 1);
  r0.w = cb0[2].x * r0.w;
  r0.w = cb0[0].w * r0.w;
  r1.x = t0.SampleLevel(s0_s, v2.xy, 0).x;
  r1.y = t0.SampleLevel(s0_s, v2.zw, 0).z;
  r2.xyzw = t0.SampleLevel(s0_s, v3.zw, 0).xyzw;
  r1.xy = -r2.xz + r1.xy;
  r2.xz = r0.ww * r1.xy + r2.xz;
  o0.w = r2.w;
  r0.w = saturate(dot(float3(0.212500006, 0.715399981, 0.0720999986), r2.xyz));
  r0.w = sqrt(r0.w);
  r0.w = sqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r1.xyz = r0.xyz * r0.xyz;
  r0.xyz = cmp(r0.xyz >= float3(0, 0, 0));
  r0.xyz = r0.xyz ? r1.xyz : -r1.xyz;
  r0.xyz = r0.xyz * CUSTOM_GRAIN_STRENGTH + r2.xyz;  //  r0.xyz = saturate(r0.xyz + r2.xyz);
  r0.w = dot(float3(0.212500006, 0.715399981, 0.0720999986), r0.xyz);
  r1.xyz = r0.www + -r0.xyz;
  r0.w = saturate(r0.w * cb0[0].y + cb0[0].z);
  r0.w = cb0[0].x * r0.w;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r0.w = dot(r0.xyz, cb0[1].xyz);
  r0.xyz = r0.xyz * cb0[1].www + r0.www;  //  r0.xyz = saturate(r0.xyz * cb0[1].www + r0.www);
  r0.w = saturate(dot(r0.xyz, cb0[4].xyz));
  r1.xyz = cb0[6].xyz * r0.www;
  r2.xyz = r0.xyz * cb0[7].xyz + -r1.xyz;
  r0.w = saturate(dot(r0.xyz, cb0[5].xyz));
  r1.xyz = r0.www * r2.xyz + r1.xyz;      //  r1.xyz = saturate(r0.www * r2.xyz + r1.xyz);
  r0.xyz = r0.xyz * cb0[6].www + r1.xyz;  //  r0.xyz = saturate(r0.xyz * cb0[6].www + r1.xyz);

  r0.rgb = max(0, r0.rgb);

  float3 lut_input = r0.xyz;
  float scale = 1.f;
  if (RENODX_TONE_MAP_TYPE != 0) {
    scale = ComputeReinhardSmoothClampScale(r0.xyz);
  }
  r0.rgb = lut_input * scale;
// LUT
#if 0
  r0.xyz = renodx::color::gamma::Encode(saturate(r0.rgb), 2.2f);
  r0.xyz = r0.xyz * float3(0.99609375, 0.99609375, 0.99609375) + float3(0.001953125, 0.001953125, 0.001953125);
  r1.x = t4.Sample(s4_s, r0.xx).x;
  r1.y = t4.Sample(s4_s, r0.yy).y;
  r1.z = t4.Sample(s4_s, r0.zz).z;
  r0.xyz = renodx::color::gamma::Decode(r1.rgb, 2.2f);
#else
  r0.rgb = SampleLUT1D(t4, s4_s, r0.rgb);
#endif
  float3 lut_output = r0.rgb / scale;

  lut_output = lerp(lut_input, lut_output, RENODX_COLOR_GRADE_STRENGTH);

  r1.xyz = t3.SampleLevel(s3_s, v3.zw, 0).xyz;
  o0.xyz = r1.xyz * lut_output;  //  o0.xyz = r1.xyz * r0.xyz;
  return;
}
