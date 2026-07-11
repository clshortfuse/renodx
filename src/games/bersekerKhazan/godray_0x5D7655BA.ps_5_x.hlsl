// ---- Created with 3Dmigoto v1.3.16 on Mon Mar 24 17:25:11 2025
// Godray shader that draws after sample, and before postEffect
// Thank you to Shortfuse for fixing it up
// Used in an older version of the game
// Keeping the shader incase people are on an older update for w/e reason

#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3) {
  float4 cb3[9];
}

cbuffer cb2 : register(b2) {
  float4 cb2[2];
}

cbuffer cb1 : register(b1) {
  float4 cb1[18];
}

cbuffer cb0 : register(b0) {
  float4 cb0[39];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asuint(cb0[37].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.zw = cb0[38].zw * r0.xy;
  r0.xy = r0.xy * cb0[38].zw + float2(-0.5, -0.5);
  r0.xy = r0.xy * float2(2, 2) + float2(-0, 3);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = renodx::math::SignSqrt(r0.x);
  r0.yz = r0.zw * cb0[5].xy + cb0[4].xy;
  r0.yzw = t0.Sample(s0_s, r0.yz).xyz;

  float3 input_color = r0.yzw;
  float3 linear_color = renodx::draw::InvertIntermediatePass(input_color);
  float3 signs = sign(linear_color);
  // float3 sdr_color = saturate(renodx::tonemap::renodrt::NeutralSDR((linear_color)));
  float3 sdr_color = saturate(NeutralSDRYOrMaxCH((linear_color)));

  float3 gamma_color = renodx::color::srgb::Encode(sdr_color);
  // r0.yzw = gamma_color;
  r0.yzw = RENODX_TONE_MAP_TYPE ? gamma_color : r0.yzw;  // Fix vanilla

  // r0.yzw = log2(r0.yzw);
  // r0.yzw = cb3[5].www * r0.yzw;
  // r0.yzw = exp2(r0.yzw);
  r0.yzw = renodx::math::PowSafe(r0.yzw, cb3[5].w);  // Make the above pow safe, gamma decode

  r0.yzw = float3(-0.00999999978, -0.00999999978, -0.00999999978) + r0.yzw;
  r0.yzw = cb3[5].zzz * r0.yzw + float3(0.00999999978, 0.00999999978, 0.00999999978);
  r1.x = dot(r0.yzw, cb3[3].xyz);
  r1.x = -0.5 + r1.x;
  r1.x = -1.44269502 * r1.x;
  r1.x = exp2(r1.x);
  r1.x = 1 + r1.x;
  r1.x = 1 / r1.x;
  r1.x = -0.377540678 + r1.x;
  r1.x = 4.08298826 * r1.x;
  r1.x = log2(abs(r1.x));
  r1.yz = float2(1, 1) / cb3[6].zw;
  r1.x = r1.y * r1.x;
  r1.x = exp2(r1.x);
  r1.y = r1.x * -2 + 1;
  r1.x = cb3[6].x * r1.y + r1.x;
  r1.x = log2(abs(r1.x));
  r1.y = r1.z * r1.x;
  r1.y = exp2(r1.y);
  r1.z = r1.y * 2 + -1;
  r1.y = cmp(r1.y < 0.5);
  r2.xyz = renodx::math::SignSqrt((r0.yzw));
  r2.xyz = r2.xyz + -abs(r0.yzw);
  r1.w = r1.z * r2.x + abs(r0.y);
  r3.xyz = -abs(r0.yzw) * abs(r0.yzw) + abs(r0.yzw);
  r1.z = r1.z * r3.x + abs(r0.y);
  r4.z = r1.y ? r1.z : r1.w;
  r1.yz = float2(1, 1) / cb3[7].xy;
  r1.xy = r1.yz * r1.xx;
  r1.xy = exp2(r1.xy);
  r1.zw = r1.xy * float2(2, 2) + float2(-1, -1);
  r1.xy = cmp(r1.xy < float2(0.5, 0.5));
  r2.xy = r1.zw * r2.yz + abs(r0.zw);
  r1.zw = r1.zw * r3.yz + abs(r0.zw);
  r4.xy = r1.xy ? r1.zw : r2.xy;
  r1.xyz = r4.xyz + -abs(r0.zwy);
  r1.xyz = cb3[5].xxx * r1.xyz + abs(r0.zwy);
  r1.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
  r1.xyz = float3(-2.16404247, -2.16404247, -2.16404247) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(1, 1, 1) + r1.xyz;
  r1.xyz = float3(1, 1, 1) / r1.xyz;
  r1.xyz = float3(-0.320821315, -0.320821315, -0.320821315) + r1.xyz;
  r1.xyz = float3(2.79051042, 2.79051042, 2.79051042) * r1.xyz;
  r2.xy = cb3[6].yy * r1.xz;
  r1.w = 1 + -cb3[6].y;
  r1.w = r1.z * r1.w + r2.x;
  r3.x = r1.y * cb3[6].y + r1.w;
  r1.w = -cb3[6].y + -cb3[5].y;
  r1.w = 1 + r1.w;
  r2.x = r1.x * r1.w;
  r1.z = r1.z * cb3[6].y + r2.x;
  r2.x = cb3[6].y + cb3[5].y;
  r3.y = r1.y * r2.x + r1.z;
  r1.x = r1.x * r2.x + r2.y;
  r3.z = r1.y * r1.w + r1.x;
  r1.xyz = renodx::math::SignSqrt(r3.xyz);
  r1.xyz = r1.xyz + -r3.xyz;
  r1.w = dot(r3.xyz, cb3[3].xyz);
  r2.x = r1.w * 2 + -1;
  r1.w = cmp(r1.w < 0.5);
  r1.xyz = r2.xxx * r1.xyz + r3.xyz;
  r2.yzw = -r3.xyz * r3.xyz + r3.xyz;
  r2.xyz = r2.xxx * r2.yzw + r3.xyz;
  r1.xyz = r1.www ? r2.xyz : r1.xyz;
  r1.xyz = max(float3(0, 0, 0), r1.xyz);

  // r1.xyz = log2(r1.xyz);
  // r1.w = 1 / cb3[5].w;
  // r1.xyz = r1.www * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  r1.rgb = renodx::math::PowSafe(r1.rgb, 1.f / cb3[5].w);  // Make the above pow safe -- Gamma Encode

  r1.xyz = r1.xyz + -abs(r0.yzw);
  r0.yzw = cb3[5].xxx * r1.xyz + abs(r0.yzw);
  r1.x = cb3[8].x * 0.300000012 + -0.200000003;
  r0.x = saturate(r0.x * 0.333333343 + -r1.x);
  r0.x = 1 + -r0.x;
  r1.xyz = cb1[17].xyz * r0.xxx;
  r1.xyz = cb1[17].www * r1.xyz;
  r0.x = saturate(cb2[1].y);
  r0.x = 1 + -r0.x;
  r0.xyz = r1.xyz * r0.xxx + r0.yzw;
  r1.xyz = cb3[4].xyz + -r0.xyz;
  r0.xyz = cb3[8].yyy * r1.xyz + r0.xyz;
  // o0.xyz = max(float3(0, 0, 0), r0.xyz);
  o0.rgb = RENODX_TONE_MAP_TYPE ? r0.rgb : max(0, r0.rgb);  // We need the above max(0 -- or else death screens artifact
  o0.w = 1;

  // if (RENODX_TONE_MAP_TYPE) {
  //   float3 processed_sdr = signs * renodx::color::srgb::Decode(o0.rgb);

  //   float3 upgraded_hdr = renodx::tonemap::UpgradeToneMap(linear_color, signs * sdr_color, processed_sdr, 1.f);

  //   o0.rgb = renodx::draw::RenderIntermediatePass(upgraded_hdr);
  // }

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 processed_sdr = renodx::color::srgb::Decode(o0.rgb);
    if (POSTFX_EXIST != 0.f) {
      o0.rgb = renodx::draw::ComputeUntonemappedGraded(linear_color, processed_sdr, sdr_color);
    }
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  }

  return;
}
