// ---- Created with 3Dmigoto v1.3.16 on Tue Jan 20 19:04:26 2026
#include "../common.hlsl"
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[26];
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
  const float4 icb[] = { { 0.500000, 0, 0, 0},
                              { 1.000000, 0, 0, 0},
                              { 1.500000, 0, 0, 0},
                              { 2.000000, 0, 0, 0},
                              { 2.500000, 0, 0, 0} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb1[0].xy + v1.xy;
  r0.z = dot(r0.xy, r0.xy);
  r0.z = sqrt(r0.z);
  r0.w = log2(r0.z);
  r0.w = cb1[0].w * r0.w;
  r0.w = exp2(r0.w);
  r0.xy = r0.xy * r0.ww;
  r0.z = max(0.00999999978, r0.z);
  r0.z = 1 / r0.z;
  r0.z = -1 + r0.z;
  r0.z = cb1[25].z * r0.z + 1;
  r0.xy = r0.xy * r0.zz;
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r2.xyz = r1.xyz;
  r0.z = 0;
  while (true) {
    r0.w = cmp((int)r0.z >= 5);
    if (r0.w != 0) break;
    r0.w = icb[r0.z+0].x * cb1[0].z;
    r3.xy = -r0.xy * r0.ww + v1.xy;
    r3.xyz = t0.SampleLevel(s0_s, r3.xy, 0).xyz;
    r3.xyz = r3.xyz + r2.xyz;
    r0.w = (int)r0.z + 1;
    r2.xyz = r3.xyz;
    r0.z = r0.w;
    continue;
  }
  r0.xyzw = r2.xyzz;
  r2.xw = float2(0,0);
  r2.yz = cb0[82].wz;
  r3.xyzw = v1.xyxy + r2.xyzw;
  r1.xyz = t0.SampleLevel(s0_s, r3.xy, 0).xyz;
  r2.xyzw = v1.xyxy + -r2.zwxy;
  r4.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
  r3.xyz = t0.SampleLevel(s0_s, r3.zw, 0).xyz;
  r2.xyz = t0.SampleLevel(s0_s, r2.zw, 0).xyz;
  r2.w = r1.x * 0.5 + r1.y;
  r2.w = r1.z * 0.5 + r2.w;
  r3.w = r4.x * 0.5 + r4.y;
  r3.w = r4.z * 0.5 + r3.w;
  r5.xyz = float3(0.166666672,0.166666672,0.166666672) * r0.xyz;
  r0.x = r0.x * 0.0833333358 + r5.y;
  r0.x = r0.w * 0.0833333358 + r0.x;
  r0.y = r3.x * 0.5 + r3.y;
  r0.y = r3.z * 0.5 + r0.y;
  r0.z = r2.x * 0.5 + r2.y;
  r0.z = r2.z * 0.5 + r0.z;
  r6.xyz = min(r4.xyz, r3.xyz);
  r6.xyz = min(r6.xyz, r1.xyz);
  r6.xyz = min(r6.xyz, r2.xyz);
  r7.xyz = max(r4.xyz, r3.xyz);
  r7.xyz = max(r7.xyz, r1.xyz);
  r7.xyz = max(r7.xyz, r2.xyz);
  r8.xyz = float3(0.25,0.25,0.25) / r7.xyz;
  r8.xyz = r8.xyz * r6.xyz;
  r7.xyz = float3(1,1,1) + -r7.xyz;
  r6.xyz = r6.xyz * float3(4,4,4) + float3(-4,-4,-4);
  r6.xyz = float3(1,1,1) / r6.xyz;
  r6.xyz = r7.xyz * r6.xyz;
  r6.xyz = max(-r8.xyz, r6.xyz);
  r0.w = max(r6.y, r6.z);
  r0.w = max(r6.x, r0.w);
  r0.w = min(0, r0.w);
  r0.w = max(-0.1875, r0.w);
  r0.w = cb1[24].x * r0.w;
  r4.w = r3.w + r2.w;
  r4.w = r4.w + r0.y;
  r4.w = r4.w + r0.z;
  r4.w = r4.w * 0.25 + -r0.x;
  r5.w = max(r3.w, r0.x);
  r5.w = max(r5.w, r2.w);
  r6.x = max(r0.y, r0.z);
  r5.w = max(r6.x, r5.w);
  r0.x = min(r3.w, r0.x);
  r0.x = min(r2.w, r0.x);
  r0.y = min(r0.y, r0.z);
  r0.x = min(r0.x, r0.y);
  r0.x = r5.w + -r0.x;
  r0.x = 1 / r0.x;
  r0.x = saturate(abs(r4.w) * r0.x);
  r0.x = r0.x * -0.5 + 1;
  r0.x = r0.w * r0.x;
  r0.y = r0.x * 4 + 1;
  r0.y = 1 / r0.y;
  r1.xyz = r4.zxy + r1.zxy;
  r1.xyz = r1.xyz + r2.zxy;
  r1.xyz = r1.xyz + r3.zxy;
  r0.xzw = r0.xxx * r1.xyz + r5.zxy;
  r0.xyz = r0.xzw * r0.yyy;
  r1.xyz = cb0[109].xxx * r0.xyz;
  r2.xyz = t1.SampleLevel(s0_s, v1.xy, 0).xyz;
  r0.w = -cb1[9].z + 1;
  r3.xyz = r2.zxy * r0.www;
  r3.xyz = cmp(float3(0.300000012,0.300000012,0.300000012) < r3.xyz);
  r4.xyz = log2(r2.zxy);
  r4.xyz = float3(0.330000013,0.330000013,0.330000013) * r4.xyz;
  r4.xyz = exp2(r4.xyz);
  r4.xyz = r4.xyz * float3(1.49380004,1.49380004,1.49380004) + float3(-0.699999988,-0.699999988,-0.699999988);
  r0.w = max(r1.y, r1.z);
  r0.w = max(r0.w, r1.x);
  r5.xy = -cb1[10].yx + r0.ww;
  r2.w = max(0, r5.x);
  r2.w = min(cb1[10].z, r2.w);
  r2.w = r2.w * r2.w;
  r2.w = cb1[10].w * r2.w;
  r2.w = max(r2.w, r5.y);
  r0.w = max(9.99999975e-005, r0.w);
  r0.w = r2.w / r0.w;
  r5.xyz = r1.xyz * r0.www;
  r5.xyz = -r5.xyz * cb1[9].zzz + r1.xyz;
  r2.xyz = r3.xyz ? r4.xyz : r2.zxy;
  r2.xyz = r2.xyz * cb1[11].zxy + r5.xyz;
  r0.xyz = -r0.xyz * cb0[109].xxx + r2.xyz;
  r0.xyz = cb1[9].xxx * r0.xyz + r1.xyz;
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
  o0.w = min(1, r1.w);
  return;
}