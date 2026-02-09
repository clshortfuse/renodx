#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[8];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[110];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[82].x / cb0[82].y;
  r0.y = -1 + r0.x;
  r0.y = cb1[2].w * r0.y + 1;
  r0.x = r0.x * 0.5625 + -r0.y;
  r0.x = cb1[1].w * r0.x + r0.y;
  r0.y = saturate(cb1[2].x * 1.04999995);
  r0.y = r0.y * 1.5 + -1;
  r0.y = cb1[1].w * r0.y + 1;
  r0.z = -cb1[2].x + 1;
  r0.z = cb1[1].w * r0.z + cb1[2].x;
  r1.xy = -cb1[1].xy + v1.xy;
  r0.zw = abs(r1.xy) * r0.zz;
  r0.y = r0.z * r0.y;
  r0.x = saturate(r0.y * r0.x);
  r0.z = cb1[2].x * 2 + -1;
  r0.z = cb1[1].w * r0.z + 1;
  r1.x = saturate(cb1[2].x + -2.79999995);
  r1.x = 5 * r1.x;
  r0.y = saturate(r0.w * r0.z + r1.x);
  r0.xy = log2(r0.xy);
  r0.xy = cb1[2].zz * r0.xy;
  r0.xy = exp2(r0.xy);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = log2(r0.x);
  r0.x = cb1[2].y * r0.x;
  r0.x = exp2(r0.x);
  float vignette_value = lerp(1.0, r0.x, VIGNETTE_STRENGTH);
  r0.x = 1.0; // Disable original vignette, apply after tonemapping
  r0.yzw = -cb1[4].zxy + float3(1,1,1);
  r0.xyz = r0.xxx * r0.yzw + cb1[4].zxy;
  r1.xyz = t2.SampleLevel(s0_s, v1.xy, 0).xyz;
  r0.w = min(r1.x, r1.y);
  r0.w = min(r0.w, r1.z);
  r1.xyz = float3(-1,-1,-1) + r1.zxy;
  r0.w = -0.200000003 + r0.w;
  r0.w = cmp(r0.w >= 0);
  r0.w = r0.w ? 1.000000 : 0;
  r1.w = saturate(cb1[3].x * 3 + -2);
  r1.w = -cb1[3].x + r1.w;
  r0.w = r0.w * r1.w + cb1[3].x;
  r1.xyz = r0.www * r1.xyz + float3(1,1,1);
  r2.xyzw = t0.SampleLevel(s1_s, v1.xy, 0).xyzw;
  r2.xyz = cb0[109].xxx * r2.zxy;
  o0.w = min(1, r2.w);
  r1.xyz = r2.xyz * r1.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = cb1[7].www * r0.xyz;
  
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      s1_s,
      shader_injection.color_grade_strength,
      0.f,
      renodx::lut::config::type::ARRI_C1000_NO_CUT,
      renodx::lut::config::type::LINEAR,
      cb1[7].xyz
    );
  float3 graded = renodx::lut::Sample(t1, lut_config, r0.yzx);
  
  [branch]
  if (shader_injection.tone_map_type == 0.f) {
    o0.xyz = renodx::tonemap::ExponentialRollOff(max(0, graded), 0.18f, 1.f);
  } else {
    UserGradingConfig cg_config = CreateColorGradeConfig();
    float y = renodx::color::y::from::BT709(graded);
    float3 graded_ap1 = renodx::color::ap1::from::BT709(graded);
    float3 hue_chrominance_reference_color = renodx::color::bt709::from::AP1(renodx::tonemap::ReinhardPiecewise(graded_ap1, 2.f, 0.18f));
    float3 graded_bt709 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(graded, y, cg_config);
    o0.xyz = ApplySaturationBlowoutHueCorrectionHighlightSaturation(graded_bt709, hue_chrominance_reference_color, y, cg_config);
    o0.xyz = renodx::color::bt2020::from::BT709(o0.xyz);
    o0.xyz = ApplyHermiteSplineByMaxChannel(o0.xyz, shader_injection.peak_white_nits / shader_injection.diffuse_white_nits);
    o0.xyz = renodx::color::bt709::from::BT2020(o0.xyz);
  }
  // Apply vignette after tonemapping
  o0.xyz *= vignette_value;
  if (CUSTOM_GRAIN_STRENGTH > 0) {
    o0.xyz = renodx::effects::ApplyFilmGrain(
        o0.xyz,
        v1.xy,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.03f);
  }
  o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
  return;
}