// ---- Created with 3Dmigoto v1.3.16 on Tue Jan 20 19:04:00 2026
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb1[0].xy + v1.xy;
  r0.z = dot(r0.xy, r0.xy);
  r0.w = sqrt(r0.z);
  r0.w = max(0.00999999978, r0.w);
  r0.w = 1 / r0.w;
  r1.x = cb1[0].w * 0.5;
  r0.z = log2(r0.z);
  r0.z = r1.x * r0.z;
  r0.z = exp2(r0.z);
  r0.xy = r0.xy * r0.zz;
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r1.xyz = float3(1,0,0) * r1.xyz;
  r0.z = cmp(3 < cb1[25].x);
  if (r0.z != 0) {
    r2.xy = cmp(float2(0,0) != cb1[25].wz);
    r0.z = (int)r2.y | (int)r2.x;
    r2.xy = r0.xy * r0.ww;
    r2.xy = r0.zz ? r2.xy : r0.xy;
    r0.z = cb1[25].y + cb1[0].z;
    r2.z = cb1[25].y + cb1[25].y;
    r3.xyzw = cb1[25].yyyy * float4(3,3,4,4);
    r4.xy = -r2.xy * r0.zz + v1.xy;
    r4.xyz = t0.SampleLevel(s0_s, r4.xy, 0).xyz;
    r4.xyz = r4.xyz * float3(1,0,0) + r1.xyz;
    r0.z = r0.z + r0.z;
    r5.xy = -r2.xy * r0.zz + v1.xy;
    r5.xyz = t0.SampleLevel(s0_s, r5.xy, 0).xyz;
    r4.xyz = r5.xyz * float3(1,0,0) + r4.xyz;
    r5.xy = -r2.xy * cb1[25].yy + v1.xy;
    r5.xyz = t0.SampleLevel(s0_s, r5.xy, 0).xyz;
    r4.xyz = r5.xyz * float3(0,1,0) + r4.xyz;
    r0.z = cb1[25].y * 2 + cb1[0].z;
    r5.xy = -r2.xy * r0.zz + v1.xy;
    r5.xyz = t0.SampleLevel(s0_s, r5.xy, 0).xyz;
    r4.xyz = r5.xyz * float3(0,1,0) + r4.xyz;
    r3.xyzw = cb1[0].zzzz * float4(2,2,2,2) + r3.xyzw;
    r3.xyzw = -r2.xyxy * r3.xyzw + v1.xyxy;
    r5.xyz = t0.SampleLevel(s0_s, r3.xy, 0).xyz;
    r4.xyz = r5.xyz * float3(0,1,0) + r4.xyz;
    r2.zw = -r2.xy * r2.zz + v1.xy;
    r5.xyz = t0.SampleLevel(s0_s, r2.zw, 0).xyz;
    r4.xyz = r5.xyz * float3(0,0,1) + r4.xyz;
    r0.z = cb1[25].y * 3 + cb1[0].z;
    r2.xy = -r2.xy * r0.zz + v1.xy;
    r2.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
    r2.xyz = r2.xyz * float3(0,0,1) + r4.xyz;
    r3.xyz = t0.SampleLevel(s0_s, r3.zw, 0).xyz;
    r2.xyz = r3.xyz * float3(0,0,1) + r2.xyz;
    r2.xyz = float3(0.333333403,0.333333403,0.333333403) * r2.xyz;
  } else {
    r0.z = cmp(0.000000 != cb1[25].w);
    r3.xy = r0.xy * r0.ww;
    r0.xy = r0.zz ? r3.xy : r0.xy;
    r0.z = cb1[25].y * 2 + cb1[0].z;
    r0.zw = -r0.xy * r0.zz + v1.xy;
    r3.xyz = t0.SampleLevel(s0_s, r0.zw, 0).xyz;
    r1.xyz = r3.xyz * float3(0,1,0) + r1.xyz;
    r0.z = cb1[0].z + cb1[0].z;
    r0.z = cb1[25].y * 3 + r0.z;
    r0.xy = -r0.xy * r0.zz + v1.xy;
    r0.xyz = t0.SampleLevel(s0_s, r0.xy, 0).xyz;
    r2.xyz = r0.xyz * float3(0,0,1) + r1.xyz;
  }
  r0.xw = float2(0,0);
  r0.yz = cb0[82].wz;
  r3.xyzw = v1.xyxy + r0.xyzw;
  r1.xyz = t0.SampleLevel(s0_s, r3.xy, 0).xyz;
  r0.xyzw = v1.xyxy + -r0.zwxy;
  r4.xyz = t0.SampleLevel(s0_s, r0.xy, 0).xyz;
  r3.xyz = t0.SampleLevel(s0_s, r3.zw, 0).xyz;
  r0.xyz = t0.SampleLevel(s0_s, r0.zw, 0).xyz;
  r0.w = r1.x * 0.5 + r1.y;
  r0.w = r1.z * 0.5 + r0.w;
  r2.w = r4.x * 0.5 + r4.y;
  r2.w = r4.z * 0.5 + r2.w;
  r3.w = r2.x * 0.5 + r2.y;
  r3.w = r2.z * 0.5 + r3.w;
  r4.w = r3.x * 0.5 + r3.y;
  r4.w = r3.z * 0.5 + r4.w;
  r5.x = r0.x * 0.5 + r0.y;
  r5.x = r0.z * 0.5 + r5.x;
  r5.yzw = min(r4.xyz, r3.xyz);
  r5.yzw = min(r5.yzw, r1.xyz);
  r5.yzw = min(r5.yzw, r0.xyz);
  r6.xyz = max(r4.xyz, r3.xyz);
  r6.xyz = max(r6.xyz, r1.xyz);
  r6.xyz = max(r6.xyz, r0.xyz);
  r7.xyz = float3(0.25,0.25,0.25) / r6.xyz;
  r7.xyz = r7.xyz * r5.yzw;
  r6.xyz = float3(1,1,1) + -r6.xyz;
  r5.yzw = r5.yzw * float3(4,4,4) + float3(-4,-4,-4);
  r5.yzw = float3(1,1,1) / r5.yzw;
  r5.yzw = r6.xyz * r5.yzw;
  r5.yzw = max(-r7.xyz, r5.yzw);
  r5.z = max(r5.z, r5.w);
  r5.y = max(r5.y, r5.z);
  r5.y = min(0, r5.y);
  r5.y = max(-0.1875, r5.y);
  r5.y = cb1[24].x * r5.y;
  r5.z = r2.w + r0.w;
  r5.z = r5.z + r4.w;
  r5.z = r5.z + r5.x;
  r5.z = r5.z * 0.25 + -r3.w;
  r5.w = max(r3.w, r2.w);
  r5.w = max(r5.w, r0.w);
  r6.x = max(r5.x, r4.w);
  r5.w = max(r6.x, r5.w);
  r2.w = min(r3.w, r2.w);
  r0.w = min(r2.w, r0.w);
  r2.w = min(r5.x, r4.w);
  r0.w = min(r2.w, r0.w);
  r0.w = r5.w + -r0.w;
  r0.w = 1 / r0.w;
  r0.w = saturate(abs(r5.z) * r0.w);
  r0.w = r0.w * -0.5 + 1;
  r0.w = r5.y * r0.w;
  r2.w = r0.w * 4 + 1;
  r2.w = 1 / r2.w;
  r1.xyz = r4.zxy + r1.zxy;
  r0.xyz = r1.xyz + r0.zxy;
  r0.xyz = r0.xyz + r3.zxy;
  r0.xyz = r0.www * r0.xyz + r2.zxy;
  r0.xyz = r0.xyz * r2.www;
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
  r5.xz = -cb1[1].xy + v1.xy;
  r3.w = -cb1[2].x + 1;
  r3.w = cb1[1].w * r3.w + cb1[2].x;
  r5.xz = abs(r5.xz) * r3.ww;
  r3.w = saturate(cb1[2].x * 1.04999995);
  r3.w = r3.w * 1.5 + -1;
  r3.w = cb1[1].w * r3.w + 1;
  r3.w = r5.x * r3.w;
  r4.w = cb1[2].x * 2 + -1;
  r4.w = cb1[1].w * r4.w + 1;
  r5.x = saturate(cb1[2].x + -2.79999995);
  r5.x = 5 * r5.x;
  r6.y = saturate(r5.z * r4.w + r5.x);
  r4.w = cb0[82].x / cb0[82].y;
  r5.x = -1 + r4.w;
  r5.x = cb1[2].w * r5.x + 1;
  r4.w = r4.w * 0.5625 + -r5.x;
  r4.w = cb1[1].w * r4.w + r5.x;
  r6.x = saturate(r4.w * r3.w);
  r5.xz = log2(r6.xy);
  r5.xz = cb1[2].zz * r5.xz;
  r5.xz = exp2(r5.xz);
  r2.w = r2.w * r2.w;
  r2.w = cb1[10].w * r2.w;
  r2.w = max(r2.w, r5.y);
  r0.w = max(9.99999975e-005, r0.w);
  r0.w = r2.w / r0.w;
  r6.xyz = r1.xyz * r0.www;
  r6.xyz = -r6.xyz * cb1[9].zzz + r1.xyz;
  r2.xyz = r3.xyz ? r4.xyz : r2.zxy;
  r2.xyz = r2.xyz * cb1[11].zxy + r6.xyz;
  r0.xyz = -r0.xyz * cb0[109].xxx + r2.xyz;
  r0.xyz = cb1[9].xxx * r0.xyz + r1.xyz;
  r0.w = dot(r5.xz, r5.xz);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = log2(r0.w);
  r0.w = cb1[2].y * r0.w;
  r0.w = exp2(r0.w);
  float vignette_value = lerp(1.0, r0.w, VIGNETTE_STRENGTH);
  r0.w = 1.0; // Disable original vignette, apply after tonemapping
  r1.xyz = -cb1[4].zxy + float3(1,1,1);
  r1.xyz = r0.www * r1.xyz + cb1[4].zxy;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = cb1[7].www * r0.xyz;
  /* Original Code
  [branch]
  if (shader_injection.tone_map_type == 0.f) {
    r0.xyz = r0.xyz * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839,0.0734997839,0.0734997839) + float3(0.386036009,0.386036009,0.386036009));
  r0.yzw = cb1[7].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = cb1[7].xy * float2(0.5,0.5);
  r1.yz = r0.zw * cb1[7].xy + r1.xy;
  r1.x = r0.y * cb1[7].y + r1.y;
  r2.xyz = t2.SampleLevel(s0_s, r1.xz, 0).xyz;
  r3.x = cb1[7].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyz = t2.SampleLevel(s0_s, r0.zw, 0).xyz;
  r0.x = r0.x * cb1[7].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  r1.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  r2.xyz = log2(abs(r0.xyz));
  r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;
  r1.xy = cb0[82].xy * v1.xy;
  r0.w = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r0.www;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  o0.xyz = r1.xyz * float3(0.0013725491,0.0013725491,0.0013725491) + r0.xyz;

  
  } else {
    renodx::lut::Config lut_config = renodx::lut::config::Create(
        s0_s,
        shader_injection.color_grade_strength,
        0.f,
        renodx::lut::config::type::ARRI_C1000_NO_CUT,
        renodx::lut::config::type::LINEAR
    );

    float3 graded = renodx::lut::Sample(t2, lut_config, r0.yzx);
    o0.xyz = renodx::draw::ToneMapPass(r0.yzx, graded);
    o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
  }
  */
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
  o0.w = min(1, r1.w);
  return;
}