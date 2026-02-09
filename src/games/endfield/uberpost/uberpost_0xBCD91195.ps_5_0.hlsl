// ---- Created with 3Dmigoto v1.3.16 on Wed Jan 21 21:30:43 2026
#include "../common.hlsl"
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[12];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[110];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t1.SampleLevel(s0_s, v1.xy, 0).xyz;
  r1.xyz = log2(r0.zxy);
  r1.xyz = float3(0.330000013,0.330000013,0.330000013) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.49380004,1.49380004,1.49380004) + float3(-0.699999988,-0.699999988,-0.699999988);
  r0.w = -cb1[9].z + 1;
  r2.xyz = r0.zxy * r0.www;
  r2.xyz = cmp(float3(0.300000012,0.300000012,0.300000012) < r2.xyz);
  r0.xyz = r2.xyz ? r1.xyz : r0.zxy;
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r2.xyz = cb0[109].xxx * r1.zxy;
  r0.w = max(r2.y, r2.z);
  r0.w = max(r0.w, r2.x);
  r3.xy = -cb1[10].yx + r0.ww;
  r0.w = max(9.99999975e-005, r0.w);
  r2.w = max(0, r3.x);
  r2.w = min(cb1[10].z, r2.w);
  r2.w = r2.w * r2.w;
  r2.w = cb1[10].w * r2.w;
  r2.w = max(r2.w, r3.y);
  r0.w = r2.w / r0.w;
  r3.xyz = r2.xyz * r0.www;
  r3.xyz = -r3.xyz * cb1[9].zzz + r2.xyz;
  r0.xyz = r0.xyz * cb1[11].zxy + r3.xyz;
  r0.xyz = -r1.zxy * cb0[109].xxx + r0.xyz;
  o0.w = min(1, r1.w);
  r0.xyz = cb1[9].xxx * r0.xyz + r2.xyz;
  r0.xyz = cb1[7].www * r0.xyz;
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      s0_s,
      shader_injection.color_grade_strength,
      0.f,
      renodx::lut::config::type::ARRI_C1000_NO_CUT,
      renodx::lut::config::type::LINEAR,
      cb1[7].xyz
    );
  float3 graded = renodx::lut::Sample(t2, lut_config, r0.yzx);
  
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