#include "./common.hlsl"

// Contrast stuff (I think) - gamma slider controls removed
// TODO - tidy up this shit

// ---- Created with 3Dmigoto v1.4.1 on Sat Apr 12 14:11:13 2025
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[4];
}
// 3Dmigoto declarations
#define cmp -
void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0)

{
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;
  r0.xy = v1.xy * cb0[2].xy + cb0[2].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;

  r0.rgb = renodx::draw::InvertIntermediatePass(r0.rgb);

  if (ORIGINAL_GAMMA == 1.f) {
    r0.xyz = saturate(r0.xyz);
    r0.xyz = r0.xyz * float3(255, 255, 255) + float3(-127, -127, -127);
    r0.w = 259 + -cb0[3].x;
    r0.w = 255 * r0.w;
    r1.xy = float2(255, 1) + cb0[3].xz;
    r1.x = 259 * r1.x;
    r1.y = 1 / r1.y;
    r0.w = r1.x / r0.w;
    r0.xyz = r0.www * r0.xyz + cb0[3].yyy;
    r0.xyz = float3(128, 128, 128) + r0.xyz;
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r0.xyz = min(float3(255, 255, 255), r0.xyz);
    r0.xyz = float3(0.00392156886, 0.00392156886, 0.00392156886) * r0.xyz;
    r0.xyz = min(float3(1, 1, 1), r0.xyz);

    o0.rgb = renodx::draw::RenderIntermediatePass(r0.rgb);
    o0.a = 1;
  } else {
    float3 input = r0.rgb;

    r0.xyz = r0.xyz * float3(255, 255, 255) + float3(-127, -127, -127);
    r0.w = 259 + -cb0[3].x;
    r0.w = 255 * r0.w;
    r1.xy = float2(255, 1) + cb0[3].xz;
    r1.x = 259 * r1.x;
    r1.y = 1 / r1.y;
    r0.w = r1.x / r0.w;
    r0.xyz = r0.www * r0.xyz + cb0[3].yyy;
    r0.xyz = float3(128, 128, 128) + r0.xyz;
    r0.xyz = float3(0.00392156886, 0.00392156886, 0.00392156886) * r0.xyz;
    
    float3 output = lerp(input, r0.rgb, ORIGINAL_BLACK_FLOOR);

    if (CUSTOM_GRAIN_TOGGLE == 1.f) {
      output = renodx::effects::ApplyFilmGrain(
          output,
          v1.xy,
          CUSTOM_RANDOM,
          CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
    }

    o0.rgb = renodx::draw::RenderIntermediatePass(output);
    o0.a = 1;
  }
}
