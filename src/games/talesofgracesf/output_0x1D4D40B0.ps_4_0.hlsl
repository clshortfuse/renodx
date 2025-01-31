#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 18 02:59:57 2025
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[143];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;

  r1.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r2.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r0.xyz;
  r2.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r2.xyz;
  r2.xyz = log2(abs(r2.xyz));
  r2.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  float3 untonemapped = r2.rgb;

  r0.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r0.xyz);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;
  r1.xyzw = t1.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r1.xyz = r1.xyz * r1.xyz;
  r0.w = cmp(0 < cb0[135].x);
  if (r0.w != 0) {
    r2.xyz = r1.xyz * r1.www;
    r1.xyz = float3(8, 8, 8) * r2.xyz;
  }
  r1.xyz = cb0[134].xxx * r1.xyz * RENODX_EFFECT_BLOOM;
  r0.xyz = r1.xyz * cb0[134].yzw + r0.xyz;

  r0.w = cmp(0 < cb0[142].z);
  if (r0.w != 0) {
    r1.xy = -cb0[142].xy + v1.xy;
    r1.yz = cb0[142].zz * abs(r1.xy);
    r1.x = cb0[141].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[142].w * r0.w;
    r0.w = exp2(r0.w);
    r1.xyz = float3(1, 1, 1) + -cb0[141].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[141].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }

  // r0.xyz = saturate(cb0[132].www * r0.xyz);
  r0.rgb = cb0[132].www * r0.xyz;

  r0.w = cmp(0 < cb0[133].w);
  if (r0.w != 0) {
    r1.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r0.xyz);
    r2.xyz = float3(12.9232101, 12.9232101, 12.9232101) * r0.xyz;
    r3.xyz = log2(r0.xyz);
    r3.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r3.xyz = r3.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r1.xyz = r1.xyz ? r2.xyz : r3.xyz;
    r2.xyz = cb0[133].zzz * r1.zxy;
    r0.w = floor(r2.x);
    r2.xw = float2(0.5, 0.5) * cb0[133].xy;
    r2.yz = r2.yz * cb0[133].xy + r2.xw;
    r2.x = r0.w * cb0[133].y + r2.y;
    r3.xyzw = t3.SampleLevel(s0_s, r2.xz, 0).xyzw;
    r4.x = cb0[133].y;
    r4.y = 0;
    r2.xy = r4.xy + r2.xz;
    r2.xyzw = t3.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r0.w = r1.z * cb0[133].z + -r0.w;
    r2.xyz = r2.xyz + -r3.xyz;
    r2.xyz = r0.www * r2.xyz + r3.xyz;
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[133].www * r2.xyz + r1.xyz;
    r2.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r1.xyz;
    r3.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r1.xyz;
    r3.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r3.xyz;
    r3.xyz = log2(abs(r3.xyz));
    r3.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r1.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r1.xyz);
    r0.xyz = r1.xyz ? r2.xyz : r3.xyz;
  }
  untonemapped = r0.rgb;

  r0.rgb = saturate(r0.rgb);  // We add it back before lut sampling
  if (false) {
    r0.xyw = cb0[132].zzz * r0.xyz;
    r0.w = floor(r0.w);
    r1.xy = float2(0.5, 0.5) * cb0[132].xy;
    r1.yz = r0.xy * cb0[132].xy + r1.xy;
    r1.x = r0.w * cb0[132].y + r1.y;
    r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
    r0.x = cb0[132].y;
    r0.y = 0;
    r0.xy = r1.xz + r0.xy;
    r1.xyzw = t2.SampleLevel(s0_s, r0.xy, 0).xyzw;
    r0.x = r0.z * cb0[132].z + -r0.w;
    r0.yzw = r1.xyz + -r2.xyz;
    r0.xyz = r0.xxx * r0.yzw + r2.xyz;
    r1.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r0.xyz);
    r2.xyz = float3(12.9232101, 12.9232101, 12.9232101) * r0.xyz;
    r0.xyz = log2(abs(r0.xyz));
    r0.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = r0.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    o0.xyz = r1.xyz ? r2.xyz : r0.xyz;
  }

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = s0_s;
  lut_config.precompute = cb0[132].rgb;
  lut_config.size = 16u;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::LINEAR;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  lut_config.scaling = 0.f;

  float3 outputColor = untonemapped;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    outputColor = renodx::lut::Sample(
        saturate(outputColor),
        lut_config,
        t2);
  } else {
    outputColor = renodx::draw::ToneMapPass(
        outputColor,
        renodx::lut::Sample(
            renodx::tonemap::renodrt::NeutralSDR(outputColor),
            lut_config,
            t2));
  }

  outputColor = renodx::draw::RenderIntermediatePass(outputColor);

  o0.rgb = outputColor;
  o0.w = 1;
  return;
}
