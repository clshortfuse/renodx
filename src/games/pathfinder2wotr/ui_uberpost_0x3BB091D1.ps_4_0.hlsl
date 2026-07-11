// ---- Created with 3Dmigoto v1.3.16 on Mon Nov  4 21:07:25 2024
// Uberpost, but it handles the UI and a vignette
// All we need to do here is SafePow
// All effects on

#include "./shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[16];
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

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;

  r0.w = cmp(0 < cb0[10].z);
  if (r0.w != 0) {
    r1.xy = -cb0[10].xy + v1.xy;
    r1.yz = cb0[10].zz * abs(r1.xy);
    r1.x = cb0[9].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[10].w * r0.w;
    r0.w = exp2(r0.w);
    r1.xyz = float3(1, 1, 1) + -cb0[9].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[9].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[0].www * r0.zxy;
  float3 untonemapped = r0.gbr;
  o0.rgb = untonemapped;
  // o0.rgb = renodx::color::bt709::clamp::AP1(o0.rgb);  // Clamp to AP1
  o0.a = r0.a;
  // o0.rgb = renodx::math::PowSafe(o0.rgb, 1.f / 2.2f);

  return;  // Early return here so we can unclamp rec709

  r0.xyz = r0.xyz * float3(5.55555582, 5.55555582, 5.55555582) + float3(0.0479959995, 0.0479959995, 0.0479959995);
  // r0.xyz = max(float3(0, 0, 0), r0.xyz);  // Rec709 clamp?
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839, 0.0734997839, 0.0734997839) + float3(0.386036009, 0.386036009, 0.386036009));
  r0.yzw = cb0[0].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5, 0.5) * cb0[0].xy;
  r1.yz = r0.zw * cb0[0].xy + r1.xy;
  r1.x = r0.y * cb0[0].y + r1.y;
  r2.xyzw = t1.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[0].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyzw = t1.SampleLevel(s0_s, r0.zw, 0).xyzw;
  r0.x = r0.x * cb0[0].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  // r0.rgb = renodx::tonemap::UpgradeToneMap(untonemapped, saturate(untonemapped), r0.rgb, 1.f);
  //  r0.rgb = applyUserTonemap(untonemapped, t1, s0_s, cb0[0].xyz);  // apply user tonemap
  //  r0.rgb = renodx::math::PowSafe(r0.rgb, 1.f / 2.2f);
  //   o0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
  //   o0.rgb = r0.rgb;
  //   o0.w = 1.f;

  // return;

  r0.w = cmp(0 < cb0[1].w);
  if (r0.w != 0) {
    r0.xyz = saturate(r0.xyz);
    r1.xyz = cb0[1].zzz * r0.zxy;
    r0.w = floor(r1.x);
    r1.xw = float2(0.5, 0.5) * cb0[1].xy;
    r1.yz = r1.yz * cb0[1].xy + r1.xw;
    r1.x = r0.w * cb0[1].y + r1.y;
    r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
    r3.x = cb0[1].y;
    r3.y = 0;
    r1.xy = r3.xy + r1.xz;
    r1.xyzw = t2.SampleLevel(s0_s, r1.xy, 0).xyzw;
    r0.w = r0.z * cb0[1].z + -r0.w;
    r1.xyz = r1.xyz + -r2.xyz;
    r1.xyz = r0.www * r1.xyz + r2.xyz;
    r1.xyz = r1.xyz + -r0.xyz;
    r0.xyz = cb0[1].www * r1.xyz + r0.xyz;
  }
  r0.w = cmp(0 < cb0[15].x);
  if (r0.w != 0) {
    r1.x = dot(float3(0.393000007, 0.768999994, 0.188999996), r0.xyz);
    r1.y = dot(float3(0.349000007, 0.68599999, 0.167999998), r0.xyz);
    r1.z = dot(float3(0.272000015, 0.533999979, 0.130999997), r0.xyz);
    r1.xyz = r1.xyz + -r0.xyz;
    r0.xyz = cb0[15].xxx * r1.xyz + r0.xyz;
  }

  // r1.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  // r2.xyz = log2(abs(r0.xyz));
  // r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz;
  // r2.xyz = exp2(r2.xyz);
  // r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  // r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  // o0.xyz = r0.xyz ? r1.xyz : r2.xyz;
  // r0.rgb = renodx::color::correct::GammaSafe(r0.rgb);
  // r0.rgb = renodx::math::PowSafe(r0.rgb, 1.f / 2.2f);
  // r0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);

  o0.rgb = r0.rgb;
  o0.w = 1;

  return;
}