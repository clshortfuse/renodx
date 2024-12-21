#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Fri Dec 20 20:00:34 2024
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[16];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    float2 v2: TEXCOORD2,
    float2 w2: TEXCOORD3,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(1, 1, -1, 0) * cb0[10].xyxy;
  r1.xyzw = -r0.xywy * cb0[11].xxxx + w2.rgrg;
  r2.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  r1.xyz = r1.zxy * float3(2, 2, 2) + r2.zxy;
  r2.xy = -r0.zy * cb0[11].xx + w2.xy;
  r2.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r1.xyz = r2.zxy + r1.xyz;
  r2.xyzw = r0.zwxw * cb0[11].xxxx + w2.rgrg;
  r3.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r2.xyzw = t2.Sample(s2_s, r2.zw).xyzw;
  r1.xyz = r3.zxy * float3(2, 2, 2) + r1.xyz;
  r3.xyzw = t2.Sample(s2_s, w2.xy).xyzw;
  r1.xyz = r3.zxy * float3(4, 4, 4) + r1.xyz;
  r1.xyz = r2.zxy * float3(2, 2, 2) + r1.xyz;
  r2.xyzw = r0.zywy * cb0[11].xxxx + w2.rgrg;
  r0.xy = r0.xy * cb0[11].xx + w2.xy;
  r0.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r3.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r2.xyzw = t2.Sample(s2_s, r2.zw).xyzw;
  r1.xyz = r3.zxy + r1.xyz;
  r1.xyz = r2.zxy * float3(2, 2, 2) + r1.xyz;
  r0.xyz = r1.xyz + r0.zxy;
  r0.xyz = cb0[11].yyy * r0.xyz;
  r0.xyz = float3(0.0625, 0.0625, 0.0625) * r0.xyz;
  r1.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r2.xyzw = t1.Sample(s0_s, w1.xy).xyzw;
  float3 untonemapped = r2.rgb;

  float3 output = applyUserTonemap(untonemapped);
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      s3_s, 1.f, 0.f,
      renodx::lut::config::type::ARRI_C1000_NO_CUT,
      renodx::lut::config::type::LINEAR);

  float3 sampled = renodx::lut::Sample(t3, lut_config, untonemapped);
  output = renodx::tonemap::UpgradeToneMap(output, saturate(output), sampled, 1.f);

  if (false) {
    r0.xyz = r2.zxy * r1.xxx + r0.xyz;
    r0.xyz = cb0[15].www * r0.xyz;
    r0.xyz = r0.xyz * float3(5.55555582, 5.55555582, 5.55555582) + float3(0.0479959995, 0.0479959995, 0.0479959995);
    r0.xyz = log2(r0.xyz);
    r0.xyz = saturate(r0.xyz * float3(0.0734997839, 0.0734997839, 0.0734997839) + float3(0.386036009, 0.386036009, 0.386036009));
    r0.yzw = cb0[15].zzz * r0.xyz;
    r0.y = floor(r0.y);
    r0.x = r0.x * cb0[15].z + -r0.y;
    r1.xy = float2(0.5, 0.5) * cb0[15].xy;
    r1.yz = r0.zw * cb0[15].xy + r1.xy;
    r1.x = r0.y * cb0[15].y + r1.y;
    r2.x = cb0[15].y;
    r2.y = 0;
    r0.yz = r2.xy + r1.xz;
    r1.xyzw = t3.Sample(s3_s, r1.xz).xyzw;
    r2.xyzw = t3.Sample(s3_s, r0.yz).xyzw;
    r0.yzw = r2.xyz + -r1.xyz;
    o0.xyz = saturate(r0.xxx * r0.yzw + r1.xyz);
  }
  o0.rgb = output;
  o0.rgb = renodx::color::bt709::clamp::AP1(o0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb);

  o0.w = 1;
  return;
}
